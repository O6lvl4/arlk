/-
  Export a Lean declaration and everything it depends on, for `arlk absorb`.

  Nothing here is trusted: Arlk re-checks every term it receives. This
  program only has to produce text that a correct kernel will accept.

  - Universe polymorphism is removed: every constant is instantiated at the
    concrete universe levels it is used at, and named `c@l1@l2...`.
  - Every binder carries the universe level of its domain, and every
    function type the level of its codomain, so the Arlk side can write
    `El l A` without inferring levels itself.
  - Projections `e.i` become applications of the structure's projection
    function, which is exported as a symbol with a rewrite rule.
  - Recursors are exported with one rewrite rule per constructor.

  Usage: lean --run Export.lean Nat.add_zero > nat_add_zero.json
-/
import Lean
open Lean Meta

structure St where
  done : Std.HashSet String := {}
  decls : Array Json := #[]

abbrev M := StateRefT St MetaM

def evalLevel : Level → Option Nat
  | .zero => some 0
  | .succ l => (evalLevel l).map (· + 1)
  | .max a b => do return Nat.max (← evalLevel a) (← evalLevel b)
  | .imax a b => do
      let y ← evalLevel b
      if y == 0 then return 0 else return Nat.max (← evalLevel a) y
  | _ => none

def lvl (l : Level) : MetaM Nat :=
  match evalLevel l with
  | some n => pure n
  | none => throwError "level is not closed: {l}"

def key (c : Name) (us : List Nat) : String :=
  us.foldl (fun s u => s ++ "@" ++ toString u) c.toString

def levelOf (ty : Expr) : MetaM Nat := do
  match ← whnf (← inferType ty) with
  | .sort u => lvl (← instantiateLevelMVars u)
  | t => throwError "not a type: {ty} : {t}"

def bvarIndex (fvs : Array Expr) (x : Expr) : MetaM Nat := do
  match fvs.toList.reverse.idxOf? x with
  | some i => pure i
  | none => throwError "free variable outside the exported context: {x}"

mutual

partial def ensure (c : Name) (us : List Level) : M String := do
  let ns ← us.mapM (fun u => (lvl u : MetaM Nat))
  let k := key c ns
  if (← get).done.contains k then return k
  modify fun s => { s with done := s.done.insert k }
  let info ← getConstInfo c
  let inst (e : Expr) := e.instantiateLevelParams info.levelParams us
  let ty := inst info.type
  let jty ← exportExpr #[] ty
  let tl ← levelOf ty
  let base := [("name", toJson k), ("type", jty), ("level", toJson tl)]
  let env ← getEnv
  let decl ← match info with
    | .defnInfo d =>
      if let some p := env.getProjectionFnInfo? c then
        let rule ← projRule c us p
        pure (Json.mkObj (base ++ [("kind", toJson "symbol"), ("rules", Json.arr #[rule])]))
      else
        pure (Json.mkObj (base ++ [("kind", toJson "def"), ("value", ← exportExpr #[] (inst d.value))]))
    | .thmInfo d =>
      pure (Json.mkObj (base ++ [("kind", toJson "theorem"), ("value", ← exportExpr #[] (inst d.value))]))
    | .recInfo r =>
      let rules ← r.rules.toArray.mapM (recRule c us r)
      pure (Json.mkObj (base ++ [("kind", toJson "symbol"), ("rules", Json.arr rules)]))
    | _ => pure (Json.mkObj (base ++ [("kind", toJson "symbol")]))
  modify fun s => { s with decls := s.decls.push decl }
  return k

partial def exportExpr (fvs : Array Expr) (e : Expr) : M Json := do
  match e with
  | .fvar _ => return Json.mkObj [("v", toJson (← bvarIndex fvs e))]
  | .bvar i => throwError "loose bound variable {i}"
  | .sort u => return Json.mkObj [("s", toJson (← lvl u))]
  | .const c us => return Json.mkObj [("c", toJson (← ensure c us))]
  | .app f a => return Json.mkObj [("a", Json.arr #[← exportExpr fvs f, ← exportExpr fvs a])]
  | .lam n d b bi =>
    let jd ← exportExpr fvs d
    let ld ← levelOf d
    withLocalDecl n bi d fun x => do
      let jb ← exportExpr (fvs.push x) (b.instantiate1 x)
      return Json.mkObj [("l", Json.arr #[toJson n.toString, jd, toJson ld, jb])]
  | .forallE n d b bi =>
    let jd ← exportExpr fvs d
    let ld ← levelOf d
    withLocalDecl n bi d fun x => do
      let body := b.instantiate1 x
      let jb ← exportExpr (fvs.push x) body
      let lb ← levelOf body
      return Json.mkObj [("p", Json.arr #[toJson n.toString, jd, toJson ld, jb, toJson lb])]
  | .letE _ _ v b _ => exportExpr fvs (b.instantiate1 v)
  | .mdata _ e => exportExpr fvs e
  | .lit (.natVal n) =>
    let _ ← ensure ``Nat.zero []
    let _ ← ensure ``Nat.succ []
    return Json.mkObj [("n", toJson n)]
  | .lit (.strVal _) => throwError "string literals are not supported yet"
  | .proj s i x =>
    let t ← whnf (← inferType x)
    let some info := getStructureInfo? (← getEnv) s
      | throwError "projection of a non-structure {s}"
    let some field := info.fieldNames[i]?
      | throwError "bad projection index {i} of {s}"
    let fn := s ++ field
    let .const _ us := t.getAppFn
      | throwError "projection of a value whose type is not a structure: {t}"
    let np := (← getConstInfoInduct s).numParams
    exportExpr fvs (mkAppN (.const fn us) (t.getAppArgs[:np].toArray.push x))
  | .mvar _ => throwError "metavariable in exported term"

/-- Variables of a rule, each typed in the context of the ones before it. -/
partial def exportVars (vars : Array Expr) : M Json := do
  let mut out := #[]
  for i in [:vars.size] do
    let x := vars[i]!
    let d ← x.fvarId!.getDecl
    let jt ← exportExpr (vars[:i].toArray) d.type
    out := out.push (Json.arr #[toJson d.userName.toString, jt, toJson (← levelOf d.type)])
  return Json.arr out

partial def patVar (vars : Array Expr) (x : Expr) : M Json := do
  return Json.mkObj [("pv", toJson (← bvarIndex vars x))]

partial def patBracket (vars : Array Expr) (e : Expr) : M Json := do
  return Json.mkObj [("pb", ← exportExpr vars e)]

/-- `Rec params motives minors indices (ctor {params} fields) --> rhs`. -/
partial def recRule (rec : Name) (us : List Level) (r : RecursorVal) (rule : RecursorRule) : M Json := do
  let recTy := r.type.instantiateLevelParams r.levelParams us
  forallTelescope recTy fun xs _ => do
    let np := r.numParams
    let nm := r.numMotives
    let nmin := r.numMinors
    let params := xs[:np].toArray
    let pmm := xs[:np + nm + nmin].toArray
    let ctorInfo ← getConstInfoCtor rule.ctor
    let ctorUs := ctorInfo.levelParams.map fun n =>
      match (r.levelParams.zip us).find? (·.1 == n) with
      | some (_, u) => u
      | none => Level.zero
    let ctorTy ← instantiateForall (ctorInfo.type.instantiateLevelParams ctorInfo.levelParams ctorUs) params
    forallTelescope ctorTy fun fields resTy => do
      let vars := pmm ++ fields
      let jvars ← exportVars vars
      let ctorKey ← ensure rule.ctor ctorUs
      let indices := resTy.getAppArgs[np:].toArray
      let mut ctorArgs := #[]
      for p in params do ctorArgs := ctorArgs.push (← patBracket vars p)
      for f in fields do ctorArgs := ctorArgs.push (← patVar vars f)
      let mut args := #[]
      for x in pmm do args := args.push (← patVar vars x)
      for i in indices do args := args.push (← patBracket vars i)
      args := args.push (Json.mkObj [("pc", toJson ctorKey), ("args", Json.arr ctorArgs)])
      let rhs := (rule.rhs.instantiateLevelParams r.levelParams us).beta vars
      let jrhs ← exportExpr vars rhs
      let head ← ensure rec us
      return Json.mkObj [("vars", jvars), ("head", toJson head), ("args", Json.arr args), ("rhs", jrhs)]

/-- `proj params (ctor {params} fields) --> field_i`. -/
partial def projRule (fn : Name) (us : List Level) (p : ProjectionFunctionInfo) : M Json := do
  let info ← getConstInfo fn
  let fnTy := info.type.instantiateLevelParams info.levelParams us
  forallTelescope fnTy fun xs _ => do
    let params := xs[:p.numParams].toArray
    let ctorInfo ← getConstInfoCtor p.ctorName
    let ctorTy ← instantiateForall (ctorInfo.type.instantiateLevelParams ctorInfo.levelParams us) params
    forallTelescope ctorTy fun fields _ => do
      let vars := params ++ fields
      let jvars ← exportVars vars
      let ctorKey ← ensure p.ctorName us
      let mut ctorArgs := #[]
      for x in params do ctorArgs := ctorArgs.push (← patBracket vars x)
      for f in fields do ctorArgs := ctorArgs.push (← patVar vars f)
      let mut args := #[]
      for x in params do args := args.push (← patVar vars x)
      args := args.push (Json.mkObj [("pc", toJson ctorKey), ("args", Json.arr ctorArgs)])
      let jrhs ← exportExpr vars fields[p.i]!
      let head ← ensure fn us
      return Json.mkObj [("vars", jvars), ("head", toJson head), ("args", Json.arr args), ("rhs", jrhs)]

end

def run (target : Name) : MetaM Json := do
  let info ← getConstInfo target
  unless info.levelParams.isEmpty do
    throwError "{target} is universe polymorphic; export a monomorphic instance instead"
  let (k, st) ← (ensure target []).run {}
  return Json.mkObj [("target", toJson k), ("decls", Json.arr st.decls)]

def main (args : List String) : IO Unit := do
  let some target := args.head? | throw (IO.userError "usage: lean --run Export.lean NAME")
  initSearchPath (← findSysroot)
  let env ← importModules #[{ module := `Init }] {} (trustLevel := 1024)
  let name := target.toName
  let ctx : Core.Context := { fileName := "<export>", fileMap := default, maxHeartbeats := 0 }
  let (j, _, _) ← (run name).toIO ctx { env }
  IO.println j.compress
