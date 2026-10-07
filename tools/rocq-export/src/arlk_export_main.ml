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

(* While a template inductive's instance is emitted or used, its template
   levels (global levels such as option.u0) stand for these numbers. *)
let template_override : (Univ.Level.t * int) list ref = ref []

(* The template instances whose declarations are being emitted. *)
let declaring : (Names.inductive * int array) list ref = ref []

let level_of_level l =
  if Univ.Level.is_set l then 1
  else match List.find_opt (fun (l', _) -> Univ.Level.equal l l') !template_override with
  | Some (_, n) -> n
  | None ->
  match Univ.Level.Map.find_opt l (Lazy.force level_numbers) with
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

(* ── Template polymorphism ─────────────────────────────────────────── *)

(* Rocq's template inductives (option, prod, list, ...) take the universe of
   the types they are given. Each universe they are used at becomes its own
   instance, `option@1`, as Lean's universe polymorphism does. *)
let template_of ind =
  let t = (Environ.lookup_mind (fst ind) (Global.env ())).Declarations.mind_template in
  if t = None && Environ.template_polymorphic_ind ind (Global.env ()) then
    unsupported "template inductive without template data";
  t

(* The global levels a monomorphic inductive's sort parameters are written
   with (`PER (A : Type@{u})`): such an inductive is instantiated at the
   levels of its arguments like a template one, so that it is the same
   type wherever those arguments live. *)
let sort_param_levels ind =
  let env = Global.env () in
  let mib = Environ.lookup_mind (fst ind) env in
  match mib.Declarations.mind_universes with
  | Declarations.Polymorphic _ -> [||]
  | Declarations.Monomorphic ->
    let ls = List.fold_left (fun acc d ->
      match d with
      | RelDecl.LocalAssum (_, t) ->
        let (ctx, concl) = Term.decompose_prod_decls t in
        (match kind (Reduction.whd_all (Environ.push_rel_context ctx env) concl) with
         | Sort (Sorts.Type u) ->
           (match Univ.Universe.repr u with
            | [ (l, 0) ] when not (Univ.Level.is_set l) && not (List.exists (Univ.Level.equal l) acc) -> acc @ [ l ]
            | _ -> acc)
         | _ -> acc)
      | _ -> acc) [] (List.rev mib.Declarations.mind_params_ctxt) in
    Array.of_list ls

let template_levels ind =
  match template_of ind with
  | Some tu -> snd (UVars.Instance.to_array tu.Declarations.template_defaults)
  | None -> sort_param_levels ind

let with_override ind nums f =
  let saved = !template_override in
  let levels = template_levels ind in
  template_override := List.init (Array.length levels) (fun i -> (levels.(i), nums.(i))) @ saved;
  match f () with
  | v -> template_override := saved; v
  | exception e -> template_override := saved; raise e

let with_pairs pairs f =
  let saved = !template_override in
  template_override := pairs @ saved;
  match f () with
  | v -> template_override := saved; v
  | exception e -> template_override := saved; raise e

let with_only pairs f =
  let saved = !template_override and saved_decl = !declaring in
  template_override := pairs; declaring := [];
  match f () with
  | v -> template_override := saved; declaring := saved_decl; v
  | exception e -> template_override := saved; declaring := saved_decl; raise e

let inst_name base nums =
  base ^ String.concat "" (List.map (fun n -> "@" ^ string_of_int n) (Array.to_list nums))

(* If `a : ta` fits `expected` only by cumulativity, the lifted term:
   `lift` on type codes, η-expansion through function types. *)
type coercion = Lift of int * int | Eta of Constr.t * coercion

let imax a b = if b = 0 then 0 else max a b

(* The universe a type lives in, counted the way Arlk's encoding counts:
   a sort's own type is one level up (so Prop : Univ 1, as in Lean, where
   Rocq says Type@{Set+1}), a function type sits at imax of its parts, and
   a template inductive at the level of the instance it is used at. This
   can be lower than Rocq's answer; `lift` makes up the difference. *)
let rec level_of_type env ty =
  match kind (fst (decompose_app ty)) with
  | Const (c, u) when UVars.Instance.is_empty u ->
    (* a constant's application lives where the constant (at the instance
       its arguments pick) says, as it is emitted unfolded no further *)
    let pairs = mono_pairs env c (snd (decompose_app ty)) in
    (match kind (Reduction.whd_all env (Typeops.infer env ty).Environ.uj_type) with
     | Sort s -> with_pairs pairs (fun () -> level_of_sort s)
     | _ -> level_of_unfolded env ty)
  | _ -> level_of_unfolded env ty

and level_of_unfolded env ty =
  let w = Reduction.whd_all env ty in
  match kind w with
  | Sort s -> level_of_sort s + 1
  | Prod (na, d, b) ->
    imax (level_of_type env d) (level_of_type (Environ.push_rel (RelDecl.LocalAssum (na, d)) env) b)
  | _ ->
    let (h, args) = decompose_app w in
    match kind h with
    | Ind ((ind, _)) when template_nums env ind args <> None ->
      let nums = Option.get (template_nums env ind args) in
      let spec = Inductive.lookup_mind_specif env ind in
      let arity = Inductive.type_of_inductive (spec, UVars.Instance.empty) in
      let (_, concl) = Term.decompose_prod arity in
      (match kind concl with
       | Sort s -> with_override ind nums (fun () -> level_of_sort s)
       | _ -> unsupported "template inductive with a non-sort arity")
    | _ ->
      match kind (Reduction.whd_all env (Typeops.infer env ty).Environ.uj_type) with
      | Sort s -> level_of_sort s
      | _ -> unsupported "not a type"

(* The instance of a template inductive applied to these arguments: each
   template level is its default, raised to the level of the type given
   for it. Never below the default, so a use whose argument is generalised
   and a use whose argument is concrete pick the same instance. *)
and template_nums env ind args =
  match template_of ind with
  | None -> sort_param_nums env ind args
  | Some tu ->
    let (_, defaults) = UVars.Instance.to_array tu.Declarations.template_defaults in
    (* Inside the declaration of one of ind's instances (its constructors'
       types), ind itself is that instance. *)
    match List.assoc_opt ind !declaring with
    | Some nums -> Some nums
    | None ->
    let saved = !template_override in
    template_override := [];
    let nums = Array.map level_of_level defaults in
    template_override := saved;
    (* Rocq may also lower a template inductive into Prop (sig, sigT on
       propositions). Then the instance follows the arguments exactly. *)
    let nparams = List.length tu.Declarations.template_param_arguments in
    let default_concl_prop =
      let arity = Inductive.type_of_inductive (Inductive.lookup_mind_specif env ind, UVars.Instance.empty) in
      match kind (snd (Term.decompose_prod arity)) with
      | Sort Sorts.Prop -> true
      | _ -> false in
    let in_prop =
      not default_concl_prop &&
      Array.length args >= nparams &&
      (let ty = (Typeops.infer env (mkApp (UnsafeMonomorphic.mkInd ind, Array.sub args 0 nparams))).Environ.uj_type in
       match kind (snd (Term.decompose_prod (Reduction.whd_all env ty))) with
       | Sort Sorts.Prop -> true
       | _ -> false) in
    if Sys.getenv_opt "ARLK_DEBUG" <> None then
      Feedback.msg_notice (Pp.str (Printf.sprintf "template %s %d: %d args, nparams %d, in_prop %b" (MutInd.to_string (fst ind)) (snd ind) (Array.length args) nparams in_prop));
    List.iteri (fun p so ->
      let lv = match so with
        | Some (Sorts.Type u) | Some (Sorts.QSort (_, u)) -> Some u
        | _ -> None in
      match lv with
      | Some u ->
        (match Univ.Universe.repr u with
         | [ (l, 0) ] ->
           let index = match Univ.Level.var_index l with
             | Some i -> Some i
             | None ->
               (* Array.find_index is OCaml 5.1; Rocq's image has an older one. *)
               let rec find i = if i >= Array.length defaults then None
                 else if Univ.Level.equal l defaults.(i) then Some i else find (i + 1) in
               find 0 in
           (match index with
            | Some i when p < Array.length args && i < Array.length nums ->
              let la = level_of_family env args.(p) in
              nums.(i) <- if in_prop then la else max 1 la
            | _ -> ())
         | _ -> ())
      | _ -> ()) tu.Declarations.template_param_arguments;
    (* Rocq lowers a template inductive into Prop only when every template
       universe is instantiated by Prop: the instance at level 0. *)
    if in_prop then Array.fill nums 0 (Array.length nums) 0;
    Some nums

(* A monomorphic inductive with sort parameters: the instance its
   arguments put lower, when they are all given and one of them is. *)
and sort_param_nums env ind args =
  match List.assoc_opt ind !declaring with
  | Some nums -> Some nums
  | None ->
  let levels = sort_param_levels ind in
  if Array.length levels = 0 then None else
  let mib = Environ.lookup_mind (fst ind) env in
  let params = List.rev mib.Declarations.mind_params_ctxt in
  let saved = !template_override in
  template_override := [];
  let defaults = Array.map level_of_level levels in
  template_override := saved;
  let nums = Array.make (Array.length defaults) 0 in
  let complete = ref true in
  List.iteri (fun i d ->
    match d with
    | RelDecl.LocalAssum (_, t) ->
      (match arity_level env t with
       | Some l ->
         if i >= Array.length args then complete := false
         else Array.iteri (fun k l' -> if Univ.Level.equal l l' then nums.(k) <- max nums.(k) (max 1 (level_of_family env args.(i)))) levels
       | None -> ())
    | _ -> ()) params;
  (* a level no parameter fixed keeps its default *)
  Array.iteri (fun k n -> if n = 0 then nums.(k) <- defaults.(k)) nums;
  if !complete && nums <> defaults then Some nums else None

and abstract_instance _ind = UVars.Instance.empty

(* `a` is accepted where `expected` is wanted. When `expected` is a sort
   and `a` lives lower in the encoding, lift it; through function types
   (arities), η-expand and lift the result. *)
and coerce ?la env a expected : coercion option =
  match kind (Reduction.whd_all env expected) with
  | Sort s ->
    let la = match la with Some n -> n | None -> level_of_type env a in
    let lb = level_of_sort s in
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

(* The global levels of c's sort parameters that its arguments put lower,
   with those levels; empty when every argument fits at c's own levels. *)
and mono_pairs env c args =
  let cb = Environ.lookup_constant c env in
  match cb.Declarations.const_universes with
  | Declarations.Polymorphic _ -> []
  | Declarations.Monomorphic ->
    (* Only when every sort parameter is given: a partial application is
       left at c's own levels, as its type is still to be completed. *)
    let complete = ref true in
    let rec go ty i acc =
      match kind (Reduction.whd_all env ty) with
      | Prod (_, d, _) when i >= Array.length args ->
        (match arity_level env d with Some _ -> complete := false | None -> ()); acc
      | _ when i >= Array.length args -> acc
      | Prod (_, d, b) ->
        let acc = match arity_level env d with
          | Some l ->
            (* never Prop: a Type parameter stays predicative; parameters
               written with the same level take the highest of theirs *)
            let n = max 1 (level_of_family env args.(i)) in
            (match List.find_opt (fun (l', _) -> Univ.Level.equal l l') acc with
             | Some (_, n') -> (l, max n n') :: List.filter (fun (l', _) -> not (Univ.Level.equal l l')) acc
             | None -> (l, n) :: acc)
          | None -> acc in
        go (Vars.subst1 args.(i) b) (i + 1) acc
      | _ -> acc in
    let pairs = List.rev (go cb.Declarations.const_type 0 []) in
    let pairs = if !complete then pairs else [] in
    (* against c's own declaration, not the levels in force here *)
    let global l = let saved = !template_override in
      template_override := [];
      let n = level_of_level l in template_override := saved; n in
    if List.exists (fun (l, n) -> n < global l) pairs then pairs else []

(* The global level of a parameter's sort, `A : Type@{l}` or a family's,
   `P : A -> Type@{l}`. *)
and arity_level env d =
  let (ctx, concl) = Term.decompose_prod_decls (Reduction.whd_all env d) in
  match kind (Reduction.whd_all (Environ.push_rel_context ctx env) concl) with
  | Sort (Sorts.Type u) ->
    (match Univ.Universe.repr u with
     | [ (l, 0) ] when not (Univ.Level.is_set l) -> Some l
     | _ -> None)
  | _ -> None

(* The level of a type, or of the types a family returns (`P : A -> Type`). *)
and level_of_family env a =
  let ty = Reduction.whd_all env (Typeops.infer env a).Environ.uj_type in
  match kind ty with
  | Sort _ -> level_of_type env a
  (* `fun x => T`: where T lives in the encoding, which Rocq's sort for it
     may not say (a template instance follows its arguments) *)
  | Prod _ when isLambda a ->
    let (ctx, body) = Term.decompose_lambda_decls a in
    let benv = Environ.push_rel_context ctx env in
    (match kind (Reduction.whd_all benv (Typeops.infer benv body).Environ.uj_type) with
     | Sort _ -> level_of_type benv body
     | _ -> level_of_family benv body)
  | Prod _ ->
    let (ctx, concl) = Term.decompose_prod_decls ty in
    (match kind (Reduction.whd_all (Environ.push_rel_context ctx env) concl) with
     | Sort s -> level_of_sort s
     | _ -> unsupported "a family that does not return types")
  | _ -> unsupported "not a type or family"

(* Some global level other than Set, to stand for a given level number. *)
and any_level () =
  match Univ.Level.Map.choose_opt (Univ.Level.Map.filter (fun l _ -> not (Univ.Level.is_set l)) (Lazy.force level_numbers)) with
  | Some (l, _) -> l
  | None -> unsupported "no global level"

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
  mutable aux : (string * Constr.t, Id.t list) Hashtbl.t; (* closed match/fix, at the levels in force → its symbols *)
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



(* ── Lambda lifting over what a term actually uses ─────────────────── *)

(* Free Rel indices of t, seen from outside `depth` binders. *)
let free_rels ?(depth = 0) t =
  let rec go d acc t = match kind t with
    | Rel r -> if r > d then Int.Set.add (r - d) acc else acc
    | _ -> Constr.fold_constr_with_binders succ go d acc t in
  go depth Int.Set.empty t

(* The part Δ of the local context that `needed` (env indices) and their
   types depend on, and a renaming of terms from env into Δ. Lifting a
   match or fix over Δ instead of the whole context makes the same match
   in two places the same symbol. *)
type strengthened = {
  delta : Constr.rel_context;
  kept : int list;  (* env indices of Δ, innermost first *)
  rename : depth:int -> Constr.t -> Constr.t;
}

let strengthen env needed =
  let ctx = Environ.rel_context env in
  let n = List.length ctx in
  let decl k = List.nth ctx (k - 1) in
  let rec close s =
    let s' = Int.Set.fold (fun k acc ->
      Int.Set.fold (fun j acc -> Int.Set.add (k + j) acc) (free_rels (RelDecl.get_type (decl k))) acc) s s in
    if Int.Set.equal s s' then s else close s' in
  let set = close (Int.Set.filter (fun k -> k <= n) needed) in
  let kept = Int.Set.elements set in
  let index = Hashtbl.create 17 in
  List.iteri (fun i k -> Hashtbl.replace index k (i + 1)) kept;
  let ren ~env_offset ~new_offset ~depth t =
    let rec go d t = match kind t with
      | Rel r when r > d -> mkRel (d + Hashtbl.find index (r - d + env_offset) - new_offset)
      | _ -> Constr.map_with_binders succ go d t in
    go depth t in
  let delta = List.mapi (fun i k ->
    match decl k with
    | RelDecl.LocalAssum (na, ty) -> RelDecl.LocalAssum (na, ren ~env_offset:k ~new_offset:(i + 1) ~depth:0 ty)
    | RelDecl.LocalDef _ -> unsupported "let in a lifted context") kept in
  { delta; kept; rename = (fun ~depth t -> ren ~env_offset:0 ~new_offset:0 ~depth t) }

let kept_args st = List.rev_map (fun k -> mkRel k) st.kept

(* The auxiliary symbols already made for a closed match or fix. Two keys
   that Rocq's kernel finds convertible (say, return clauses that differ
   only in an annotation) share their symbols, as they are the same term
   to Rocq. *)
let shape key =
  let (ctx, body) = Term.decompose_lambda_decls key in
  (List.length ctx, fst (decompose_app body))

(* The levels in force: the same match at another instance of a constant
   (or template inductive) is a different symbol. *)
let levels_in_force () =
  String.concat "," (List.map (fun (l, n) -> Univ.Level.to_string l ^ "=" ^ string_of_int n) !template_override)

(* The level numbers of a term's sorts, in order. *)
let sort_numbers t =
  let rec go acc t = match kind t with
    | Sort s -> (try level_of_sort s with Unsupported _ -> -1) :: acc
    | _ -> Constr.fold go acc t in
  go [] t

let find_aux key0 =
  let key = (levels_in_force (), key0) in
  match Hashtbl.find_opt st.aux key with
  | Some ids -> Some ids
  | None ->
    let env = with_aux (Global.env ()) in
    let (n, h) = shape key0 in
    Hashtbl.fold (fun (lv, k) ids found ->
      match found with
      | Some _ -> found
      | None ->
        let (n', h') = shape k in
        if lv <> fst key || n <> n' || not (Constr.equal h h') then None
        (* The same term up to the names of universes whose numbers agree
           (`Type@{app.u0}` and `Type@{Facts.u0}` are both level 2 here). *)
        else if Constr.eq_constr_nounivs k key0 && sort_numbers k = sort_numbers key0 then Some ids
        else match Conversion.default_conv Conversion.CONV env k key0 with
          | Ok () -> Some ids
          | Error () -> None) st.aux None

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
  | Const (c, u) -> O [ "c", S (ensure_const c u) ]
  | Ind ((ind, u)) ->
    if not (UVars.Instance.is_empty u) then unsupported "universe polymorphic inductive";
    let nums = template_nums env ind [||] in
    O [ "c", S (ensure_ind ind nums) ]
  | Construct ((cstr, u)) ->
    if not (UVars.Instance.is_empty u) then unsupported "universe polymorphic constructor";
    let nums = template_nums env (fst cstr) [||] in
    let _ = ensure_ind (fst cstr) nums in
    O [ "c", S (inst_name (ctor_name cstr) (Option.default [||] nums)) ]
  | Case (ci, u, pms, p, iv, c, brs) -> tr_case parent env (ci, u, pms, p, iv, c, brs)
  | Fix ((recs, i), (names, types, bodies)) -> tr_fix parent env recs i names types bodies
  | Proj _ -> unsupported "primitive projections are not supported yet"
  | CoFix _ -> unsupported "cofixpoints are not supported yet"
  | Int _ | Float _ | String _ | Array _ -> unsupported "primitive values are not supported yet"
  | Meta _ | Evar _ -> unsupported "open term"

(* f a1 .. an, lifting any argument that Rocq accepts only by cumulativity. *)
and tr_app parent env f args =
  (* A template inductive or constructor: pick its instance from the
     types it is given, and type its arguments at that instance. *)
  let template = match kind f with
    | Ind ((ind, _)) -> Option.map (fun nums -> (ind, nums, `Ind)) (template_nums env ind args)
    | Construct (((ind, j), _)) -> Option.map (fun nums -> (ind, nums, `Ctor j)) (template_nums env ind args)
    | _ -> None in
  match template with
  | Some (ind, nums, what) ->
    let name = ensure_ind ind (Some nums) in
    let spec = Inductive.lookup_mind_specif env ind in
    let inst = abstract_instance ind in
    let (head, fty) = match what with
      | `Ind -> (name, Inductive.type_of_inductive (spec, inst))
      | `Ctor j -> (inst_name (ctor_name (ind, j)) nums, Inductive.type_of_constructor ((ind, j), inst) spec) in
    let jf = ref (O [ "c", S head ]) and ft = ref fty in
    Array.iter (fun a ->
      match kind (Reduction.whd_all env !ft) with
      | Prod (_, dom, cod) ->
        (* a's own level is what it is here: the instance's template
           levels may be the very levels a's type is written with. *)
        let la = match kind (Reduction.whd_all env dom) with Sort _ -> Some (level_of_type env a) | _ -> None in
        let ja = with_override ind nums (fun () ->
          match coerce ?la env a dom with
          | None -> None
          | Some c -> Some c) in
        let ja = match ja with None -> tr parent env a | Some c -> tr_coerce parent env a c in
        jf := O [ "a", A [ !jf; ja ] ];
        ft := Vars.subst1 a cod
      | _ -> unsupported "application of a non-function") args;
    !jf
  | None ->
  (* A monomorphic constant whose parameters are sorts at global levels
     (`eq_trans (A : Type@{u})`), applied to types that live lower: the
     constant at the levels of its arguments, as a template inductive is,
     instead of lifting them (cumulativity has no counterpart in the
     encoding). Arlk checks that instance like any other declaration. *)
  let pairs = match kind f with
    | Const (c, u) when UVars.Instance.is_empty u -> mono_pairs env c args
    | _ -> [] in
  let jf = ref (match kind f with
    | Const (c, u) when pairs <> [] -> O [ "c", S (ensure_const ~pairs c u) ]
    | _ -> tr parent env f) in
  let ft = ref (Typeops.infer env f).Environ.uj_type in
  Array.iter (fun a ->
    match kind (Reduction.whd_all env !ft) with
    | Prod (_, dom, cod) ->
      (* c's levels set the expected type; a itself is translated here *)
      let la = match kind (Reduction.whd_all env dom) with Sort _ -> Some (level_of_type env a) | _ -> None in
      let co = with_pairs pairs (fun () -> coerce ?la env a dom) in
      let ja = match co with None -> tr parent env a | Some c -> tr_coerce parent env a c in
      jf := O [ "a", A [ !jf; ja ] ];
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

(* match c as x in I pms idx return P with C_j fields => b_j end becomes
   I.case@s(pms, P, b_1, .., b_n, idx, c): one eliminator per inductive (at
   each instance) and sort s of P, with one rule per constructor,
   I.case@s(pms, P, bs, idx_j, C_j(pms, fs)) = b_j(fs). As in Rocq, two
   matches with convertible branches are then convertible. Falls back to a
   symbol for this one match when the eliminator cannot be written. *)
and tr_case parent env case =
  try tr_case_elim parent env case
  with Unsupported _ | CErrors.UserError _ -> tr_case_aux parent env case

and tr_case_elim parent env case =
  let (ci, (p, _), _, c, brs) = Inductive.expand_case env case in
  let (_, _, pms, _, _, _, _) = case in
  let ind = ci.ci_ind in
  let spec = Inductive.lookup_mind_specif env ind in
  let (mib, mip) = spec in
  (* the sort of the motive *)
  let (pctx, pbody) = Term.decompose_lambda_decls p in
  if List.length pctx < mip.Declarations.mind_nrealdecls + 1 then unsupported "case: a motive with fewer binders";
  let (pctx, pbody) = Term.decompose_lambda_n_decls (mip.Declarations.mind_nrealdecls + 1) p in
  if List.exists RelDecl.is_local_def pctx then unsupported "let in indices";
  let penv = Environ.push_rel_context pctx env in
  let s = match kind (Reduction.whd_all penv (Typeops.infer penv pbody).Environ.uj_type) with
    | Sort s -> s
    | _ -> unsupported "a motive that is not a type" in
  (* the motive's level in the encoding (it can differ from Rocq's sort: a
     template instance follows its arguments), and a sort standing for it:
     Prop, Set, or some global level set to that number *)
  let m = level_of_type penv pbody in
  ignore s;
  let (s, spair) =
    if m = 0 then (Sorts.prop, [])
    else if m = 1 then (Sorts.set, [])
    else let l = any_level () in (Sorts.sort_of_univ (Univ.Universe.make l), [ (l, m) ]) in
  let nums = template_nums env ind pms in
  let name = ensure_case ind nums s m spair in
  let (_, args) = Inductive.find_rectype env (Typeops.infer env c).Environ.uj_type in
  let idx = Array.of_list (List.filteri (fun k _ -> k >= mib.Declarations.mind_nparams) args) in
  let all = Array.concat [ pms; [| p |]; brs; idx; [| c |] ] in
  (* each argument fits the eliminator's type at this instance and sort *)
  let fty = case_type ind s in
  let tlev = template_levels ind in
  let pairs = spair @ (match nums with Some n -> List.init (Array.length tlev) (fun i -> (tlev.(i), n.(i))) | None -> []) in
  let jf = ref (O [ "c", S name ]) and ft = ref fty in
  Array.iter (fun a ->
    match kind (Reduction.whd_all env !ft) with
    | Prod (_, dom, cod) ->
      let la = match kind (Reduction.whd_all env dom) with Sort _ -> Some (level_of_type env a) | _ -> None in
      let co = with_pairs pairs (fun () -> coerce ?la env a dom) in
      let ja = match co with None -> tr parent env a | Some c -> tr_coerce parent env a c in
      jf := O [ "a", A [ !jf; ja ] ];
      ft := Vars.subst1 a cod
    | _ -> unsupported "case: too many arguments") all;
  !jf

(* Π pms (P : Π idx (x : I pms idx), s) (b_j : Π fs_j, P idx_j (C_j pms fs_j))
     idx (x : I pms idx), P idx x *)
and case_type ind s =
  let env = Global.env () in
  let spec = Inductive.lookup_mind_specif env ind in
  let (mib, mip) = spec in
  let params = mib.Declarations.mind_params_ctxt in
  if List.exists RelDecl.is_local_def params then unsupported "let in parameters";
  let np = List.length params in
  let u = UVars.Instance.empty in
  let prels = Array.init np (fun i -> mkRel (np - i)) in
  let k = mip.Declarations.mind_nrealdecls + 1 in
  let names = Array.init k (fun i -> Context.annotR (Name (Id.of_string (if i = k - 1 then "x" else Printf.sprintf "i%d" i)))) in
  let arity = Inductive.expand_arity spec (ind, u) prels names in
  if List.exists RelDecl.is_local_def arity then unsupported "let in indices";
  let motive = Term.it_mkProd_or_LetIn (mkSort s) arity in
  (* P, η-expanded over its context: Rocq's branch types apply it *)
  let p_lam = Term.it_mkLambda_or_LetIn (mkApp (mkRel (k + 1), Array.init k (fun i -> mkRel (k - i)))) (Vars.lift_rel_context 1 arity) in
  let brtys = Inductive.build_branches_type (ind, u) spec (Array.to_list (Array.map (Vars.lift 1) prels)) p_lam in
  let nb = Array.length brtys in
  let brctx = List.rev (Array.to_list (Array.mapi (fun j t ->
    RelDecl.LocalAssum (Context.annotR (Name (Id.of_string (Printf.sprintf "b%d" j))), Vars.lift j t)) brtys)) in
  let arity' = Vars.lift_rel_context (1 + nb) arity in
  let concl = mkApp (mkRel (k + nb + 1), Array.init k (fun i -> mkRel (k - i))) in
  let t = Term.it_mkProd_or_LetIn concl arity' in
  let t = Term.it_mkProd_or_LetIn t brctx in
  let t = mkProd (Context.annotR (Name (Id.of_string "P")), motive, t) in
  Term.it_mkProd_or_LetIn t params

and ensure_case ind nums s m spair =
  let base = match nums with Some n -> inst_name (ind_name ind) n | None -> ind_name ind in
  let name = base ^ ".case@" ^ string_of_int m in
  if not (Hashtbl.mem st.done_ name) then begin
    let env = Global.env () in
    let spec = Inductive.lookup_mind_specif env ind in
    let (mib, mip) = spec in
    let cty = case_type ind s in
    (* Rocq checks the eliminator's type before it is emitted *)
    (try ignore (Typeops.infer env cty) with e when CErrors.noncritical e -> unsupported "case type");
    Hashtbl.replace st.done_ name ();
    let tlev = template_levels ind in
    let pairs = spair @ (match nums with Some n -> List.init (Array.length tlev) (fun i -> (tlev.(i), n.(i))) | None -> []) in
    with_only pairs (fun () ->
      let saved = !declaring in
      (match nums with Some n -> declaring := (ind, n) :: saved | None -> ());
      Fun.protect ~finally:(fun () -> declaring := saved) (fun () ->
      emit (O [ "kind", S "symbol"; "name", S name; "type", tr name env cty; "level", I (level_of_type env cty) ]);
      let np = List.length mib.Declarations.mind_params_ctxt in
      let nb = Array.length mip.Declarations.mind_consnames in
      (* Γ: the parameters, P and the branches *)
      let (gctx, _) = Term.decompose_prod_n_decls (np + 1 + nb) cty in
      let env_d = Environ.push_rel_context gctx env in
      let pms = Array.init np (fun i -> mkRel (np - i + 1 + nb)) in
      let rules = List.init nb (fun j ->
        let (fctx, idx, nfields) = ctor_fields env_d spec ind j pms in
        let env_f = Environ.push_rel_context fctx env_d in
        let ind_pms = mkApp (UnsafeMonomorphic.mkInd ind, Array.map (Vars.lift nfields) pms) in
        let idx_typed = with_domains env_f (Typeops.infer env_f ind_pms).Environ.uj_type (Array.to_list idx) in
        let pats = List.map (fun v -> `Var v) (rel_args env_d nfields)
                   @ List.map (fun (i, d) -> `Bracket (i, d)) idx_typed
                   @ [ `Ctor (ctor_term ind j pms nfields, nfields) ] in
        let rhs = mkApp (mkRel (nb - j + nfields), Array.init nfields (fun q -> mkRel (nfields - q))) in
        rule name env_f name pats rhs) in
      emit (O [ "kind", S "rules"; "name", S name; "rules", A rules ])))
  end;
  name

and tr_case_aux parent env case =
  let (ci, (p, _), _, c, brs) = Inductive.expand_case env case in
  let (_, _, pms, _, _, _, _) = case in
  let ind = ci.ci_ind in
  let spec = Inductive.lookup_mind_specif env ind in
  let (mib, mip) = spec in
  let nidx = mip.Declarations.mind_nrealargs in
  let needed = Array.fold_left (fun acc t -> Int.Set.union acc (free_rels t)) (free_rels p) (Array.append pms brs) in
  let sg = strengthen env needed in
  let rn t = sg.rename ~depth:0 t in
  let p = rn p and pms = Array.map rn pms and brs = Array.map rn brs in
  let delta = sg.delta in
  let key = Term.it_mkLambda_or_LetIn (mkApp (UnsafeMonomorphic.mkInd ind, Array.concat [ [| p |]; pms; brs ])) delta in
  let id = match find_aux key with
    | Some [ id ] -> id
    | _ ->
      let (pctx, pbody) = Term.decompose_lambda_n_decls (nidx + 1) p in
      let mty = Term.it_mkProd_or_LetIn (Term.it_mkProd_or_LetIn pbody pctx) delta in
      let (id, name) = new_aux parent "match" mty in
      Hashtbl.replace st.aux (levels_in_force (), key) [ id ];
      let genv = with_aux (Global.env ()) in
      emit (O [ "kind", S "symbol"; "name", S name; "type", tr parent genv mty; "level", I (level_of_type genv mty) ]);
      let env_d = with_aux (Environ.push_rel_context delta genv) in
      let rules = Array.to_list (Array.mapi (fun j br ->
        let (_, idx, nfields) = ctor_fields env_d spec ind j pms in
        let (bctx, body) = Term.decompose_lambda_n_decls nfields br in
        let env_f = with_aux (Environ.push_rel_context bctx env_d) in
        let ind_pms = mkApp (UnsafeMonomorphic.mkInd ind, Array.map (Vars.lift nfields) pms) in
        let idx_typed = with_domains env_f (Typeops.infer env_f ind_pms).Environ.uj_type (Array.to_list idx) in
        let pats = List.map (fun v -> `Var v) (rel_args env_d nfields)
                   @ List.map (fun (i, d) -> `Bracket (i, d)) idx_typed
                   @ [ `Ctor (ctor_term ind j pms nfields, nfields) ] in
        rule parent env_f name pats body) brs) in
      emit (O [ "kind", S "rules"; "name", S name; "rules", A rules ]);
      id
  in
  let ((_, _), args) = Inductive.find_rectype env (Typeops.infer env c).Environ.uj_type in
  let idx = List.filteri (fun k _ -> k >= mib.Declarations.mind_nparams) args in
  tr parent (with_aux env) (mkApp (mkVar id, Array.of_list (kept_args sg @ idx @ [ c ])))

(* fix f_1 .. f_k { struct x_r } becomes symbols F_m : Π Δ, T_m with one
   rule per constructor of the recursive argument's type. *)
and tr_fix parent env recs i names types bodies =
  let k = Array.length types in
  let needed = Array.fold_left (fun acc t -> Int.Set.union acc (free_rels ~depth:k t))
                 (Array.fold_left (fun acc t -> Int.Set.union acc (free_rels t)) Int.Set.empty types) bodies in
  let sg = strengthen env needed in
  let types = Array.map (fun t -> sg.rename ~depth:0 t) types in
  let bodies = Array.map (fun t -> sg.rename ~depth:k t) bodies in
  let delta = sg.delta in
  let key = Term.it_mkLambda_or_LetIn (mkFix ((recs, i), (names, types, bodies))) delta in
  let ids = match find_aux key with
    | Some ids -> ids
    | None ->
      let auxs = Array.to_list (Array.map (fun ty -> new_aux parent "fix" (Term.it_mkProd_or_LetIn ty delta)) types) in
      let ids = List.map fst auxs in
      Hashtbl.replace st.aux (levels_in_force (), key) ids;
      let genv = with_aux (Global.env ()) in
      (* every symbol of the block before any rule *)
      List.iteri (fun m (_, name) ->
        let fty = Term.it_mkProd_or_LetIn types.(m) delta in
        emit (O [ "kind", S "symbol"; "name", S name; "type", tr parent genv fty; "level", I (level_of_type genv fty) ])) auxs;
      let env = with_aux (Environ.push_rel_context delta genv) in
      List.iteri (fun m (_, name) ->
        let r = recs.(m) in
        let (actx, _) = Term.decompose_prod_n_decls (r + 1) types.(m) in
        if List.exists RelDecl.is_local_def actx then unsupported "let in a fixpoint's arguments";
        let env_a = with_aux (Environ.push_rel_context (List.tl actx) env) in
        let rec_ty = RelDecl.get_type (List.hd actx) in
        let ((ind, _), rargs) = Inductive.find_rectype env_a rec_ty in
        let spec = Inductive.lookup_mind_specif env_a ind in
        let (mib, mip) = spec in
        let np = mib.Declarations.mind_nparams in
        let pms_a = Array.of_list (List.filteri (fun q _ -> q < np) rargs) in
        let idx_a = Array.of_list (List.filteri (fun q _ -> q >= np) rargs) in
        let nidx = Array.length idx_a in
        (* An indexed family: each index must be one of the arguments just
           before the recursive one. Those arguments are fixed by the
           constructor, so the rule writes them as brackets holding the
           constructor's index. *)
        let s = r - nidx in
        let pos_of_arg = Array.make r (-1) in
        Array.iteri (fun p e -> match kind e with
          | Rel k when k >= 1 && k <= nidx && pos_of_arg.(r - k) < 0 -> pos_of_arg.(r - k) <- p
          | _ -> unsupported "fixpoint over an indexed family whose indices are not its last arguments") idx_a;
        if Array.exists (fun par -> not (Vars.noccur_between 1 nidx par)) pms_a then
          unsupported "fixpoint whose parameters depend on its indices";
        let pms = Array.map (Vars.lift (-nidx)) pms_a in
        let kept_ctx = List.filteri (fun q _ -> q >= nidx) (List.tl actx) in
        let env_b = with_aux (Environ.push_rel_context kept_ctx env) in
        let rules = List.init (Array.length mip.Declarations.mind_consnames) (fun j ->
          let (fctx, idx_j, nfields) = ctor_fields env_b spec ind j pms in
          let env_f = with_aux (Environ.push_rel_context fctx env_b) in
          let shift = s + nfields in
          (* f_q ↦ F_q Δ, with Δ seen from env_f *)
          let calls = List.map (fun id -> mkApp (mkVar id, Array.of_list (rel_args env shift))) ids in
          let body = Vars.substl (List.rev calls) (Vars.liftn shift (k + 1) bodies.(m)) in
          let kept = Array.init s (fun q -> mkRel (nfields + s - q)) in
          let fixed = Array.init nidx (fun q -> idx_j.(pos_of_arg.(s + q))) in
          let ctor = ctor_term ind j pms nfields in
          let rhs = mkApp (body, Array.concat [ kept; fixed; [| ctor |] ]) in
          let pats = List.map (fun v -> `Var v) (rel_args env shift)
                     @ List.map (fun v -> `Var v) (Array.to_list kept)
                     @ List.map (fun e -> `Bracket (e, (Typeops.infer env_f e).Environ.uj_type)) (Array.to_list fixed)
                     @ [ `Ctor (ctor, nfields) ] in
          rule parent env_f name pats rhs) in
        emit (O [ "kind", S "rules"; "name", S name; "rules", A rules ])) auxs;
      ids
  in
  tr parent (with_aux env) (mkApp (mkVar (List.nth ids i), Array.of_list (kept_args sg)))

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
      let nums = template_nums env_f ind (Array.sub args 0 npar) in
      let spec = Inductive.lookup_mind_specif env_f ind in
      let cty = Inductive.type_of_constructor ((ind, j), abstract_instance ind) spec in
      let typed = with_domains env_f cty (Array.to_list args) in
      let fit (a, d) = match nums with
        | Some n -> O [ "pb", (match (let la = match kind (Reduction.whd_all env_f d) with Sort _ -> Some (level_of_type env_f a) | _ -> None in
                                       with_override ind n (fun () -> coerce ?la env_f a d)) with
                                | None -> tr parent env_f a
                                | Some c -> tr_coerce parent env_f a c) ]
        | None -> pat (`Bracket (a, d)) in
      let ps = List.mapi (fun q ad -> if q < npar then fit ad else pat (`Var (fst ad))) typed in
      let cname = match nums with Some n -> inst_name (ctor_name (ind, j)) n | None -> ctor_name (ind, j) in
      O [ "pc", S cname; "args", A ps ] in
  O [ "vars", A jvars; "head", S head; "args", A (List.map pat pats); "rhs", tr parent env_f rhs ]

(* ── Declarations ─────────────────────────────────────────────────── *)

(* A universe-polymorphic constant is declared once per instance it is used
   at, named by the instance's levels as numbers (`c@1@2`), with its type
   and body instantiated there, as for Lean. *)
and ensure_const ?(pairs = []) c u =
  let env = Global.env () in
  let cb = Environ.lookup_constant c env in
  let poly = match cb.Declarations.const_universes with
    | Declarations.Monomorphic -> false
    | Declarations.Polymorphic _ -> true in
  let (qs, ls) = UVars.Instance.to_array u in
  if Array.length qs > 0 then unsupported "sort polymorphic constant %s" (Constant.to_string c);
  let name = if poly then inst_name (Constant.to_string c) (Array.map level_of_level ls)
    else if pairs <> [] then inst_name (Constant.to_string c) (Array.of_list (List.map snd pairs))
    else Constant.to_string c in
  let inst t = if poly then Vars.subst_instance_constr u t else t in
  (* A declaration is translated at its own levels only, whatever is in
     force where it was first used. *)
  if not (Hashtbl.mem st.done_ name) then with_only pairs (fun () -> begin
    Hashtbl.replace st.done_ name ();
    let ty = inst cb.Declarations.const_type in
    let jty = tr name env ty in
    let lty = level_of_type env ty in
    (* A body that is a partial application (`f_equal nat`) is η-expanded
       along its type, so that the applications inside it are complete and
       pick their instances from its parameters. *)
    let rec eta env body ty = match kind (Reduction.whd_all env ty) with
      | Prod (na, d, b) ->
        let env' = Environ.push_rel (RelDecl.LocalAssum (na, d)) env in
        (match kind body with
         | Lambda (na', d', b') -> mkLambda (na', d', eta env' b' b)
         | _ -> mkLambda (na, d, eta env' (mkApp (Vars.lift 1 body, [| mkRel 1 |])) b))
      | _ -> body in
    let inst b = eta env (inst b) ty in
    let body_decl kind body =
      O [ "kind", S kind; "name", S name; "type", jty; "level", I lty; "value", tr_fit name env body ty ] in
    let d = match cb.Declarations.const_body with
      | Declarations.Def b -> body_decl "def" (inst b)
      | Declarations.OpaqueDef o ->
        let (b, _) = Global.force_proof !accessor o in
        body_decl "theorem" (inst b)
      | Declarations.Undef _ -> O [ "kind", S "symbol"; "name", S name; "type", jty; "level", I lty ]
      | Declarations.Primitive _ -> unsupported "primitive %s" name
      | Declarations.Symbol _ -> unsupported "rewrite-rule symbol %s" name in
    emit d
  end);
  name

and ensure_ind ((mi, _) as ind) nums =
  let suffix n = match nums with Some a -> inst_name n a | None -> n in
  let name = suffix (ind_name ind) in
  if not (Hashtbl.mem st.done_ name) then begin
    let env = Global.env () in
    let mib = Environ.lookup_mind mi env in
    (match mib.Declarations.mind_universes with
     | Declarations.Monomorphic -> ()
     | Declarations.Polymorphic _ -> unsupported "universe polymorphic inductive %s" name);
    let inst = abstract_instance ind in
    let under f = with_only [] (fun () -> match nums with
      | Some a ->
        let saved = !declaring in
        declaring := Array.to_list (Array.mapi (fun i _ -> ((mi, i), a)) mib.Declarations.mind_packets) @ saved;
        (match with_override ind a f with
         | v -> declaring := saved; v
         | exception e -> declaring := saved; raise e)
      | None -> f ()) in
    (* declare the whole mutual block: every type, then every constructor *)
    Array.iteri (fun i _ -> Hashtbl.replace st.done_ (suffix (ind_name (mi, i))) ()) mib.Declarations.mind_packets;
    Array.iteri (fun i _ ->
      let spec = Inductive.lookup_mind_specif env (mi, i) in
      let ty = Inductive.type_of_inductive (spec, inst) in
      let (jt, lt) = under (fun () -> (tr name env ty, level_of_type env ty)) in
      emit (O [ "kind", S "symbol"; "name", S (suffix (ind_name (mi, i))); "type", jt; "level", I lt ])) mib.Declarations.mind_packets;
    Array.iteri (fun i p ->
      let spec = Inductive.lookup_mind_specif env (mi, i) in
      Array.iteri (fun j _ ->
        let ty = Inductive.type_of_constructor (((mi, i), j + 1), inst) spec in
        let (jt, lt) = under (fun () -> (tr name env ty, level_of_type env ty)) in
        emit (O [ "kind", S "symbol"; "name", S (suffix (ctor_name ((mi, i), j + 1))); "type", jt; "level", I lt ]))
        p.Declarations.mind_consnames) mib.Declarations.mind_packets
  end;
  name

(* ── Entry point ──────────────────────────────────────────────────── *)

(* A universe-polymorphic target is exported at Set for every level. *)
let top_instance = function
  | Declarations.Monomorphic -> UVars.Instance.empty
  | Declarations.Polymorphic ctx ->
    let (nq, n) = UVars.AbstractContext.size ctx in
    if nq > 0 then unsupported "sort polymorphic target";
    UVars.Instance.of_array ([||], Array.make n Univ.Level.set)

let run opaque_access file (refs : Libnames.qualid list) =
  PrintingFlags.print_universes := true;
  accessor := opaque_access;
  let ok = ref [] and skipped = ref [] in
  List.iter (fun r ->
    match (try Some (Nametab.global r) with e when CErrors.noncritical e -> None) with
    | None -> skipped := O [ "name", S (Libnames.string_of_qualid r); "reason", S "not found" ] :: !skipped
    | Some gr ->
    let saved_done = Hashtbl.copy st.done_ and saved_decls = st.decls and saved_aux = Hashtbl.copy st.aux in
    try
      let n = match gr with
        | GlobRef.ConstRef c -> ensure_const c (top_instance (Environ.lookup_constant c (Global.env ())).Declarations.const_universes)
        | GlobRef.IndRef i -> ensure_ind i (template_nums (Global.env ()) i [||])
        | GlobRef.ConstructRef (i, _) -> ensure_ind i (template_nums (Global.env ()) i [||])
        | GlobRef.VarRef _ -> unsupported "section variable" in
      ok := S n :: !ok
    with
    | Unsupported why ->
      st.done_ <- saved_done; st.decls <- saved_decls; st.aux <- saved_aux;
      skipped := O [ "name", S (Libnames.string_of_qualid r); "reason", S why ] :: !skipped
    | e when CErrors.noncritical e ->
      st.done_ <- saved_done; st.decls <- saved_decls; st.aux <- saved_aux;
      skipped := O [ "name", S (Libnames.string_of_qualid r); "reason", S ("export failed: " ^ Printexc.to_string e) ] :: !skipped) refs;
  let b = Buffer.create (1 lsl 20) in
  write b (O [ "theory", S "rocq"; "targets", A (List.rev !ok); "skipped", A (List.rev !skipped); "decls", A (List.rev st.decls) ]);
  let oc = open_out file in
  Buffer.output_buffer oc b;
  close_out oc;
  Feedback.msg_notice (Pp.str (Printf.sprintf "arlk export: %d exported, %d skipped, %d declarations -> %s"
    (List.length !ok) (List.length !skipped) (List.length st.decls) file))
