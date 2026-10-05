(* Export Rocq declarations for `arlk absorb`.

   Nothing here is trusted: Arlk re-checks every term it receives. This
   plugin only has to produce text that a correct kernel will accept.

   - Universe levels are global variables in Rocq. They are given the
     numbers of the longest path from Set in the universe graph, which
     satisfies every constraint, so the export is one valid instance.
   - Every binder carries the level of its domain, and every function type
     the level of its codomain, as in the Lean export.
   - Cumulativity becomes explicit: wherever Rocq's kernel only accepts a
     term by subtyping (conv_leq but not conv), a `lift` is inserted.
   - `match` and `fix` become lambda-lifted symbols with one rewrite rule
     per constructor. A fixpoint's rule fires only when its recursive
     argument is a constructor, as Rocq's guard condition expects. *)

open Names
open Constr
module RelDecl = Context.Rel.Declaration

(* ── JSON ─────────────────────────────────────────────────────────── *)

type json = S of string | I of int | A of json list | O of (string * json) list

let rec write b = function
  | S s ->
    Buffer.add_char b '"';
    String.iter (fun c -> match c with
      | '"' -> Buffer.add_string b "\\\""
      | '\\' -> Buffer.add_string b "\\\\"
      | '\n' -> Buffer.add_string b "\\n"
      | c when Char.code c < 0x20 -> Buffer.add_string b (Printf.sprintf "\\u%04x" (Char.code c))
      | c -> Buffer.add_char b c) s;
    Buffer.add_char b '"'
  | I n -> Buffer.add_string b (string_of_int n)
  | A xs ->
    Buffer.add_char b '[';
    List.iteri (fun i x -> if i > 0 then Buffer.add_char b ','; write b x) xs;
    Buffer.add_char b ']'
  | O kvs ->
    Buffer.add_char b '{';
    List.iteri (fun i (k, v) -> if i > 0 then Buffer.add_char b ','; write b (S k); Buffer.add_char b ':'; write b v) kvs;
    Buffer.add_char b '}'

exception Unsupported of string
let unsupported fmt = Printf.ksprintf (fun s -> raise (Unsupported s)) fmt

let accessor : Global.indirect_accessor ref = ref Library.indirect_accessor

(* ── Universe levels as numbers ───────────────────────────────────── *)

(* Longest path from Set: Set is 1 (Prop is 0), u < v adds one. *)
let level_numbers : int Univ.Level.Map.t Lazy.t = lazy (
  let g = UGraph.repr (Environ.universes (Global.env ())) in
  let canon = Hashtbl.create 97 in
  let rec target l = match Univ.Level.Map.find_opt l g with
    | Some (UGraph.Alias l') -> target l'
    | _ -> l in
  Univ.Level.Map.iter (fun l _ -> Hashtbl.replace canon l (target l)) g;
  let value = ref Univ.Level.Map.empty in
  let get l = Option.default (if Univ.Level.is_set l then 1 else 1) (Univ.Level.Map.find_opt (target l) !value) in
  let changed = ref true in
  while !changed do
    changed := false;
    Univ.Level.Map.iter (fun u node -> match node with
      | UGraph.Alias _ -> ()
      | UGraph.Node succ ->
        let vu = get u in
        Univ.Level.Map.iter (fun v strict ->
          let need = vu + (if strict then 1 else 0) in
          if get v < need then begin
            value := Univ.Level.Map.add (target v) need !value;
            changed := true
          end) succ) g
  done;
  Univ.Level.Map.fold (fun l _ m -> Univ.Level.Map.add l (get l) m) g Univ.Level.Map.empty)

let level_of_level l =
  if Univ.Level.is_set l then 1
  else match Univ.Level.Map.find_opt l (Lazy.force level_numbers) with
    | Some n -> n
    | None -> unsupported "universe level %s is not a global level" (Univ.Level.to_string l)

let level_of_universe u =
  List.fold_left (fun acc (l, k) -> max acc (level_of_level l + k)) 0 (Univ.Universe.repr u)

let level_of_sort = function
  | Sorts.SProp -> unsupported "SProp is not supported yet"
  | Sorts.Prop -> 0
  | Sorts.Set -> 1
  | Sorts.Type u -> level_of_universe u
  | Sorts.QSort _ -> unsupported "sort polymorphism is not supported"

let imax a b = if b = 0 then 0 else max a b

(* The universe a type lives in, counted the way Arlk's encoding counts:
   a sort's own type is one level up (so Prop : Univ 1, as in Lean, where
   Rocq says Type@{Set+1}), and a function type sits at imax of its parts.
   This can be lower than Rocq's answer; `lift` makes up the difference. *)
let rec level_of_type env ty =
  match kind (Reduction.whd_all env ty) with
  | Sort s -> level_of_sort s + 1
  | Prod (na, d, b) ->
    imax (level_of_type env d) (level_of_type (Environ.push_rel (RelDecl.LocalAssum (na, d)) env) b)
  | _ ->
    match kind (Reduction.whd_all env (Typeops.infer env ty).Environ.uj_type) with
    | Sort s -> level_of_sort s
    | _ -> unsupported "not a type"

(* ── Names ────────────────────────────────────────────────────────── *)

let ind_name (mi, i) =
  let mib = Environ.lookup_mind mi (Global.env ()) in
  ModPath.to_string (MutInd.modpath mi) ^ "." ^ Id.to_string mib.Declarations.mind_packets.(i).Declarations.mind_typename

let ctor_name ((mi, i), j) =
  let mib = Environ.lookup_mind mi (Global.env ()) in
  ind_name (mi, i) ^ "." ^ Id.to_string mib.Declarations.mind_packets.(i).Declarations.mind_consnames.(j - 1)

let binder_name na = match Context.binder_name na with
  | Name id -> Id.to_string id
  | Anonymous -> "x"

(* ── State ────────────────────────────────────────────────────────── *)

type state = {
  mutable done_ : (string, unit) Hashtbl.t;
  mutable decls : json list;           (* newest first *)
  mutable aux : (Constr.t, Id.t list) Hashtbl.t; (* closed match/fix → its symbols *)
  mutable named : (Id.t * Constr.t * string) list; (* aux variable, closed type, symbol name *)
  mutable counter : int;
}

let st = { done_ = Hashtbl.create 97; decls = []; aux = Hashtbl.create 97; named = []; counter = 0 }
let emit d = st.decls <- d :: st.decls

(* Auxiliary symbols are named variables of Rocq's own environment, so the
   kernel can type terms that mention them. *)
let with_aux env =
  List.fold_left (fun e (id, ty, _) ->
    if Environ.mem_named id e then e
    else Environ.push_named (Context.Named.Declaration.LocalAssum (Context.annotR id, ty)) e) env st.named

let aux_symbol id = List.find_map (fun (i, _, n) -> if Id.equal i id then Some n else None) st.named

let new_aux parent what ty =
  st.counter <- st.counter + 1;
  let name = Printf.sprintf "%s.%s_%d" parent what st.counter in
  let id = Id.of_string (Printf.sprintf "arlk_aux_%d" st.counter) in
  st.named <- (id, ty, name) :: st.named;
  (id, name)

(* ── Terms ────────────────────────────────────────────────────────── *)

(* Γ as arguments: the outermost binder first. *)
let rel_args env shift =
  let n = List.length (Environ.rel_context env) in
  List.init n (fun v -> mkRel (n - v + shift))

(* If `a : ta` fits `expected` only by cumulativity, the lifted term:
   `lift` on type codes, η-expansion through function types. *)
type coercion = Lift of int * int | Eta of Constr.t * coercion

(* `a` is accepted where `expected` is wanted. When `expected` is a sort
   and `a` lives lower in the encoding, lift it; through function types
   (arities), η-expand and lift the result. *)
let rec coerce env a expected : coercion option =
  match kind (Reduction.whd_all env expected) with
  | Sort s ->
    let la = level_of_type env a and lb = level_of_sort s in
    if la = lb then None else Some (Lift (la, lb))
  | Prod (na, d, b) ->
    let env' = Environ.push_rel (RelDecl.LocalAssum (na, d)) env in
    (match kind (Reduction.whd_all env' b) with
     | Sort _ | Prod _ ->
       (match coerce env' (mkApp (Vars.lift 1 a, [| mkRel 1 |])) b with
        | Some c -> Some (Eta (d, c))
        | None -> None)
     | _ -> None)
  | _ -> None

let rec tr (parent : string) (env : Environ.env) (t : Constr.t) : json =
  let env = with_aux env in
  match kind t with
  | Rel i -> O [ "v", I (i - 1) ]
  | Var id ->
    (match aux_symbol id with
     | Some n -> O [ "c", S n ]
     | None -> unsupported "section variable %s" (Id.to_string id))
  | Sort s -> O [ "s", I (level_of_sort s) ]
  | Cast (c, _, _) -> tr parent env c
  | LetIn (_, v, _, b) -> tr parent env (Vars.subst1 v b)
  | Prod (na, d, b) ->
    let jd = tr parent env d in
    let ld = level_of_type env d in
    let env' = Environ.push_rel (RelDecl.LocalAssum (na, d)) env in
    let jb = tr parent env' b in
    let lb = level_of_type env' b in
    O [ "p", A [ S (binder_name na); jd; I ld; jb; I lb ] ]
  | Lambda (na, d, b) ->
    let jd = tr parent env d in
    let ld = level_of_type env d in
    let env' = Environ.push_rel (RelDecl.LocalAssum (na, d)) env in
    O [ "l", A [ S (binder_name na); jd; I ld; tr parent env' b ] ]
  | App (f, args) -> tr_app parent env f args
  | Const (c, u) ->
    if not (UVars.Instance.is_empty u) then unsupported "universe polymorphic constant %s" (Constant.to_string c);
    O [ "c", S (ensure_const c) ]
  | Ind ((ind, u)) ->
    if not (UVars.Instance.is_empty u) then unsupported "universe polymorphic inductive";
    O [ "c", S (ensure_ind ind) ]
  | Construct ((cstr, u)) ->
    if not (UVars.Instance.is_empty u) then unsupported "universe polymorphic constructor";
    let _ = ensure_ind (fst cstr) in
    O [ "c", S (ctor_name cstr) ]
  | Case (ci, u, pms, p, iv, c, brs) -> tr_case parent env (ci, u, pms, p, iv, c, brs)
  | Fix ((recs, i), (names, types, bodies)) -> tr_fix parent env recs i names types bodies
  | Proj _ -> unsupported "primitive projections are not supported yet"
  | CoFix _ -> unsupported "cofixpoints are not supported yet"
  | Int _ | Float _ | String _ | Array _ -> unsupported "primitive values are not supported yet"
  | Meta _ | Evar _ -> unsupported "open term"

(* f a1 .. an, lifting any argument that Rocq accepts only by cumulativity. *)
and tr_app parent env f args =
  let jf = ref (tr parent env f) in
  let ft = ref (Typeops.infer env f).Environ.uj_type in
  Array.iter (fun a ->
    match kind (Reduction.whd_all env !ft) with
    | Prod (_, dom, cod) ->
      jf := O [ "a", A [ !jf; tr_fit parent env a dom ] ];
      ft := Vars.subst1 a cod
    | _ -> unsupported "application of a non-function") args;
  !jf

(* `a`, made to fit `expected` *)
and tr_fit parent env a expected =
  match coerce env a expected with
  | None -> tr parent env a
  | Some c -> tr_coerce parent env a c

and tr_coerce parent env a = function
  | Lift (la, lb) -> O [ "lift", A [ I la; I lb; tr parent env a ] ]
  | Eta (d, c) ->
    let na = Context.annotR (Name (Id.of_string "x")) in
    let env' = Environ.push_rel (RelDecl.LocalAssum (na, d)) env in
    let a' = mkApp (Vars.lift 1 a, [| mkRel 1 |]) in
    O [ "l", A [ S "x"; tr parent env d; I (level_of_type env d); tr_coerce parent env' a' c ] ]

(* Constructor j of ind, its parameters replaced by pms (terms of env):
   the field context and the indices of its result type. *)
and ctor_fields env spec ind j pms =
  let (mib, _) = spec in
  let cty = Inductive.type_of_constructor ((ind, j + 1), UVars.Instance.empty) spec in
  let (_, rest) = Term.decompose_prod_n_decls mib.Declarations.mind_nparams cty in
  let rest = Vars.substl (List.rev (Array.to_list pms)) rest in
  let nfields = (snd spec).Declarations.mind_consnrealdecls.(j) in
  let (fctx, res) = Term.decompose_prod_n_decls nfields rest in
  if List.exists RelDecl.is_local_def fctx then unsupported "let in a constructor";
  let idx = Array.sub (snd (decompose_app res)) mib.Declarations.mind_nparams
              (Array.length (snd (decompose_app res)) - mib.Declarations.mind_nparams) in
  let _ = env in
  (fctx, idx, nfields)

and ctor_term ind j pms nfields =
  mkApp (UnsafeMonomorphic.mkConstruct (ind, j + 1),
    Array.append (Array.map (Vars.lift nfields) pms) (Array.init nfields (fun q -> mkRel (nfields - q))))

(* match c as x in I pms idx return P with C_j fields => b_j end
   becomes  M Γ idx c  with  M : Π Γ (idx) (x : I pms idx), P  and one rule per C_j. *)
and tr_case parent env case =
  let (ci, (p, _), _, c, brs) = Inductive.expand_case env case in
  let (_, _, pms, _, _, _, _) = case in
  let ind = ci.ci_ind in
  let spec = Inductive.lookup_mind_specif env ind in
  let (mib, mip) = spec in
  let nidx = mip.Declarations.mind_nrealargs in
  let ctx = Environ.rel_context env in
  let closed = Term.it_mkLambda_or_LetIn (mkCase case) ctx in
  let id = match Hashtbl.find_opt st.aux closed with
    | Some [ id ] -> id
    | _ ->
      let (pctx, pbody) = Term.decompose_lambda_n_decls (nidx + 1) p in
      let mty = Term.it_mkProd_or_LetIn (Term.it_mkProd_or_LetIn pbody pctx) ctx in
      let (id, name) = new_aux parent "match" mty in
      Hashtbl.replace st.aux closed [ id ];
      let genv = with_aux (Global.env ()) in
      emit (O [ "kind", S "symbol"; "name", S name; "type", tr parent genv mty; "level", I (level_of_type genv mty) ]);
      let nctx = List.length ctx in
      let rules = Array.to_list (Array.mapi (fun j br ->
        let (_, idx, nfields) = ctor_fields env spec ind j pms in
        let (bctx, body) = Term.decompose_lambda_n_decls nfields br in
        let env_f = with_aux (Environ.push_rel_context bctx env) in
        let ind_pms = mkApp (UnsafeMonomorphic.mkInd ind, Array.map (Vars.lift nfields) pms) in
        let idx_typed = with_domains env_f (Typeops.infer env_f ind_pms).Environ.uj_type (Array.to_list idx) in
        let pats = List.map (fun v -> `Var v) (rel_args env nfields)
                   @ List.map (fun (i, d) -> `Bracket (i, d)) idx_typed
                   @ [ `Ctor (ctor_term ind j pms nfields, nfields) ] in
        let _ = nctx in
        rule parent env_f name pats body) brs) in
      emit (O [ "kind", S "rules"; "name", S name; "rules", A rules ]);
      id
  in
  let ((_, _), args) = Inductive.find_rectype env (Typeops.infer env c).Environ.uj_type in
  let idx = List.filteri (fun k _ -> k >= mib.Declarations.mind_nparams) args in
  tr parent (with_aux env) (mkApp (mkVar id, Array.of_list (rel_args env 0 @ idx @ [ c ])))

(* fix f_1 .. f_k { struct x_r } becomes symbols F_m : Π Γ, T_m with one
   rule per constructor of the recursive argument's type. *)
and tr_fix parent env recs i _names types bodies =
  let ctx = Environ.rel_context env in
  let nctx = List.length ctx in
  let k = Array.length types in
  let closed = Term.it_mkLambda_or_LetIn (mkFix ((recs, i), (_names, types, bodies))) ctx in
  let ids = match Hashtbl.find_opt st.aux closed with
    | Some ids -> ids
    | None ->
      let auxs = Array.to_list (Array.map (fun ty -> new_aux parent "fix" (Term.it_mkProd_or_LetIn ty ctx)) types) in
      let ids = List.map fst auxs in
      Hashtbl.replace st.aux closed ids;
      let genv = with_aux (Global.env ()) in
      (* every symbol of the block before any rule *)
      List.iteri (fun m (_, name) ->
        let fty = Term.it_mkProd_or_LetIn types.(m) ctx in
        emit (O [ "kind", S "symbol"; "name", S name; "type", tr parent genv fty; "level", I (level_of_type genv fty) ])) auxs;
      List.iteri (fun m (_, name) ->
        let r = recs.(m) in
        let (actx, _) = Term.decompose_prod_n_decls (r + 1) types.(m) in
        if List.exists RelDecl.is_local_def actx then unsupported "let in a fixpoint's arguments";
        let env_a = with_aux (Environ.push_rel_context (List.tl actx) env) in
        let rec_ty = RelDecl.get_type (List.hd actx) in
        let ((ind, _), rargs) = Inductive.find_rectype env_a rec_ty in
        let spec = Inductive.lookup_mind_specif env_a ind in
        let (mib, mip) = spec in
        if mip.Declarations.mind_nrealargs > 0 then unsupported "fixpoint over an indexed family";
        let pms = Array.of_list (List.filteri (fun q _ -> q < mib.Declarations.mind_nparams) rargs) in
        let rules = List.init (Array.length mip.Declarations.mind_consnames) (fun j ->
          let (fctx, _, nfields) = ctor_fields env_a spec ind j pms in
          let env_f = with_aux (Environ.push_rel_context fctx env_a) in
          let shift = r + nfields in
          (* f_q ↦ F_q Γ, with Γ seen from env_f *)
          let calls = List.map (fun id -> mkApp (mkVar id, Array.of_list (rel_args env shift))) ids in
          let body = Vars.substl (List.rev calls) (Vars.liftn shift (k + 1) bodies.(m)) in
          let xs = Array.init r (fun q -> mkRel (nfields + r - q)) in
          let rhs = mkApp (body, Array.append xs [| ctor_term ind j pms nfields |]) in
          let pats = List.map (fun v -> `Var v) (rel_args env shift)
                     @ List.map (fun v -> `Var v) (Array.to_list xs)
                     @ [ `Ctor (ctor_term ind j pms nfields, nfields) ] in
          rule parent env_f name pats rhs) in
        emit (O [ "kind", S "rules"; "name", S name; "rules", A rules ])) auxs;
      ids
  in
  let _ = nctx in
  tr parent (with_aux env) (mkApp (mkVar (List.nth ids i), Array.of_list (rel_args env 0)))

(* Each argument with the domain it is given at, walking f's type. *)
and with_domains env fty args =
  let rec go ty = function
    | [] -> []
    | a :: rest ->
      (match kind (Reduction.whd_all env ty) with
       | Prod (_, d, b) -> (a, d) :: go (Vars.subst1 a b) rest
       | _ -> unsupported "too many arguments") in
  go fty args

and rule parent env_f head pats rhs =
  let vars = List.rev (Environ.rel_context env_f) in
  let genv = with_aux (Global.env ()) in
  let jvars = List.rev (snd (List.fold_left (fun (env, acc) d ->
    let ty = RelDecl.get_type d in
    let j = A [ S (binder_name (RelDecl.get_annot d)); tr parent env ty; I (level_of_type env ty) ] in
    (Environ.push_rel d env, j :: acc)) (genv, []) vars)) in
  let rec pat = function
    | `Var v -> O [ "pv", I (destRel v - 1) ]
    | `Bracket (t, expected) -> O [ "pb", tr_fit parent env_f t expected ]
    | `Ctor (c, nfields) ->
      let (h, args) = decompose_app c in
      let ((ind, j), _) = destConstruct h in
      let npar = Array.length args - nfields in
      let typed = with_domains env_f (Typeops.infer env_f h).Environ.uj_type (Array.to_list args) in
      let ps = List.mapi (fun q (a, d) -> if q < npar then pat (`Bracket (a, d)) else pat (`Var a)) typed in
      O [ "pc", S (ctor_name (ind, j)); "args", A ps ] in
  O [ "vars", A jvars; "head", S head; "args", A (List.map pat pats); "rhs", tr parent env_f rhs ]

(* ── Declarations ─────────────────────────────────────────────────── *)

and ensure_const c =
  let name = Constant.to_string c in
  if not (Hashtbl.mem st.done_ name) then begin
    Hashtbl.replace st.done_ name ();
    let env = Global.env () in
    let cb = Environ.lookup_constant c env in
    (match cb.Declarations.const_universes with
     | Declarations.Monomorphic -> ()
     | Declarations.Polymorphic _ -> unsupported "universe polymorphic constant %s" name);
    let ty = cb.Declarations.const_type in
    let jty = tr name env ty in
    let lty = level_of_type env ty in
    let body_decl kind body =
      O [ "kind", S kind; "name", S name; "type", jty; "level", I lty; "value", tr_fit name env body ty ] in
    let d = match cb.Declarations.const_body with
      | Declarations.Def b -> body_decl "def" b
      | Declarations.OpaqueDef o ->
        let (b, _) = Global.force_proof !accessor o in
        body_decl "theorem" b
      | Declarations.Undef _ -> O [ "kind", S "symbol"; "name", S name; "type", jty; "level", I lty ]
      | Declarations.Primitive _ -> unsupported "primitive %s" name
      | Declarations.Symbol _ -> unsupported "rewrite-rule symbol %s" name in
    emit d
  end;
  name

and ensure_ind ((mi, _) as ind) =
  let name = ind_name ind in
  if not (Hashtbl.mem st.done_ name) then begin
    let env = Global.env () in
    let mib = Environ.lookup_mind mi env in
    (match mib.Declarations.mind_universes with
     | Declarations.Monomorphic -> ()
     | Declarations.Polymorphic _ -> unsupported "universe polymorphic inductive %s" name);
    (* declare the whole mutual block: every type, then every constructor *)
    Array.iteri (fun i _ -> Hashtbl.replace st.done_ (ind_name (mi, i)) ()) mib.Declarations.mind_packets;
    Array.iteri (fun i _ ->
      let spec = Inductive.lookup_mind_specif env (mi, i) in
      let ty = Inductive.type_of_inductive (spec, UVars.Instance.empty) in
      emit (O [ "kind", S "symbol"; "name", S (ind_name (mi, i)); "type", tr name env ty; "level", I (level_of_type env ty) ])) mib.Declarations.mind_packets;
    Array.iteri (fun i p ->
      let spec = Inductive.lookup_mind_specif env (mi, i) in
      Array.iteri (fun j _ ->
        let ty = Inductive.type_of_constructor (((mi, i), j + 1), UVars.Instance.empty) spec in
        emit (O [ "kind", S "symbol"; "name", S (ctor_name ((mi, i), j + 1)); "type", tr name env ty; "level", I (level_of_type env ty) ]))
        p.Declarations.mind_consnames) mib.Declarations.mind_packets
  end;
  name

(* ── Entry point ──────────────────────────────────────────────────── *)

let run opaque_access file (refs : Libnames.qualid list) =
  PrintingFlags.print_universes := true;
  accessor := opaque_access;
  let ok = ref [] and skipped = ref [] in
  List.iter (fun r ->
    let gr = Nametab.global r in
    let saved_done = Hashtbl.copy st.done_ and saved_decls = st.decls and saved_aux = Hashtbl.copy st.aux in
    try
      let n = match gr with
        | GlobRef.ConstRef c -> ensure_const c
        | GlobRef.IndRef i -> ensure_ind i
        | GlobRef.ConstructRef (i, _) -> ensure_ind i
        | GlobRef.VarRef _ -> unsupported "section variable" in
      ok := S n :: !ok
    with Unsupported why ->
      st.done_ <- saved_done; st.decls <- saved_decls; st.aux <- saved_aux;
      skipped := O [ "name", S (Libnames.string_of_qualid r); "reason", S why ] :: !skipped) refs;
  let b = Buffer.create (1 lsl 20) in
  write b (O [ "theory", S "rocq"; "targets", A (List.rev !ok); "skipped", A (List.rev !skipped); "decls", A (List.rev st.decls) ]);
  let oc = open_out file in
  Buffer.output_buffer oc b;
  close_out oc;
  Feedback.msg_notice (Pp.str (Printf.sprintf "arlk export: %d exported, %d skipped, %d declarations -> %s"
    (List.length !ok) (List.length !skipped) (List.length st.decls) file))
