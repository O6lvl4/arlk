# Self-contained insertion sort: arbitrary finite lists of Peano naturals.
# Proof strategy adapted from Bend's demos/proof_insertion_sort at pinned HEAD.
# No Base import, axioms, unsafe definitions, foreign code, or open goals.

# FOUNDATION
type Number is Data:
  Zero{}
  Succ{pred: Number}

type List is Data:
  Nil{}
  Con{head: Number, tail: List}

type Flag is Data:
  False{}
  True{}

type One is Data:
  One{}

type Empty is Data:

type Sum<-A: Data, -B: Data> is Data:
  Left{value: A}
  Right{value: B}

type Both<-A: Type, -B: Type> is Type:
  Pair{left: A, right: B}

# PROGRAM
def LE(a: Number, b: Number) -> Data:
  match a b:
    case Zero{} b0:
      One
    case Succ{a1} Zero{}:
      Empty
    case Succ{a1} Succ{b1}:
      LE(a1, b1)

def le_case(x: Number, h: Number) -> Sum<LE(x, h), LE(h, x)>:
  match x h:
    case Zero{} b:
      Left{One{}}
    case Succ{a} Zero{}:
      Right{One{}}
    case Succ{a} Succ{b}:
      le_case(a, b)

def dec(x: Number, h: Number, t: List, r: List, c: Sum<LE(x, h), LE(h, x)>) -> List:
  match c:
    case Left{e}:
      Con{x, Con{h, t}}
    case Right{e}:
      Con{h, r}

def insert(+x: Number, +xs: List) -> List:
  match xs:
    case Nil{}:
      Con{x, Nil{}}
    case Con{h, t}:
      dec(x, h, t, insert(x, t), le_case(x, h))

def sort(xs: List) -> List:
  match xs:
    case Nil{}:
      Nil{}
    case Con{h, t}:
      insert(h, sort(t))

# PROPERTY
def SortedB(xs: List, lo: Number) -> Type:
  match xs:
    case Nil{}:
      One
    case Con{h, t}:
      Both<LE(lo, h), SortedB(t, h)>

def eq_nat(a: Number, b: Number) -> Flag:
  match a b:
    case Zero{} Zero{}:
      True{}
    case Zero{} Succ{bp}:
      False{}
    case Succ{ap} Zero{}:
      False{}
    case Succ{ap} Succ{bp}:
      eq_nat(ap, bp)

def bump(b: Flag, n: Number) -> Number:
  match b:
    case True{}:
      Succ{n}
    case False{}:
      n

def count(+x: Number, xs: List) -> Number:
  match xs:
    case Nil{}:
      Zero{}
    case Con{h, t}:
      bump(eq_nat(x, h), count(x, t))

# PROOF
# Ascending order, including its preserved lower bound.
def sorted_ins_fin(-lo: Number, -x: Number, -h: Number, -t: List,
  sx: SortedB(Con{h, t}, lo), lx: LE(lo, x),
  rec: SortedB(t, h) -> LE(h, x) -> SortedB(insert(x, t), h),
  c: Sum<LE(x, h), LE(h, x)>) -> SortedB(dec(x, h, t, insert(x, t), c), lo):
  match sx:
    case Pair{lh, st}:
      match c:
        case Left{e}:
          Pair{lx, Pair{e, st}}
        case Right{e}:
          Pair{lh, rec(st, e)}

def sorted_ins(xs: List, -lo: Number, +x: Number)
  -> SortedB(xs, lo) -> LE(lo, x) -> SortedB(insert(x, xs), lo):
  match xs:
    case Nil{}:
      sx => lx => Pair{lx, One{}}
    case Con{h, t}:
      sx => lx => sorted_ins_fin(lo, x, h, t, sx, lx,
        sorted_ins(t, h, x), le_case(x, h))

law sort_sorted:
  for +xs: List
  SortedB(sort(xs), Zero{})

def sort_sorted(xs):
  match xs:
    case Nil{}:
      One{}
    case Con{h, t}:
      sorted_ins(sort(t), Zero{}, h)(sort_sorted(t), One{})

# Multiplicities, for every queried natural number.
def bump_swap(a: Flag, b: Flag, -n: Number)
  -> {bump(a, bump(b, n)) == bump(b, bump(a, n)) : Number}:
  match a b:
    case True{} True{}:
      {==}
    case True{} False{}:
      {==}
    case False{} True{}:
      {==}
    case False{} False{}:
      {==}

def count_ins_fin(+x: Number, y: Number, h: Number, -t: List,
  rec: {count(x, Con{y, t}) == count(x, insert(y, t)) : Number},
  c: Sum<LE(y, h), LE(h, y)>)
  -> {count(x, Con{y, Con{h, t}}) == count(x, dec(y, h, t, insert(y, t), c)) : Number}:
  match c:
    case Left{e}:
      {==}
    case Right{e}:
      %rec : {count(x, Con{y, Con{h, t}}) == bump(eq_nat(x, h), _) : Number}
      bump_swap(eq_nat(x, y), eq_nat(x, h), count(x, t))

def count_ins(+x: Number, +y: Number, +xs: List)
  -> {count(x, Con{y, xs}) == count(x, insert(y, xs)) : Number}:
  match xs:
    case Nil{}:
      {==}
    case Con{h, t}:
      count_ins_fin(x, y, h, t, count_ins(x, y, t), le_case(y, h))

law sort_perm:
  for +x: Number
  for +xs: List
  {count(x, sort(xs)) == count(x, xs) : Number}

def sort_perm(x, xs):
  match xs:
    case Nil{}:
      {==}
    case Con{h, t}:
      %count_ins(x, h, sort(t)) : {_ == bump(eq_nat(x, h), count(x, t)) : Number}
      %sort_perm(x, t) : {bump(eq_nat(x, h), count(x, sort(t))) == bump(eq_nat(x, h), _) : Number}
      {==}
