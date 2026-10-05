# Matched domain: every finite list of Peano naturals.
# FOUNDATION
type N is Data:
  Z{}
  S{p: N}
type L is Data:
  Nil{}
  Con{h: N, t: L}
# PROGRAM
def len(xs: L) -> N:
  match xs:
    case Nil{}:
      Z{}
    case Con{h, t}:
      S{len(t)}
def add(x: N, y: N) -> N:
  match x:
    case Z{}:
      y
    case S{p}:
      S{add(p, y)}
def go(xs: L, acc: L) -> L:
  match xs:
    case Nil{}:
      acc
    case Con{h, t}:
      go(t, Con{h, acc})
def rev(xs: L) -> L:
  go(xs, Nil{})
# PROOF
def add_s(x: N, y: N) -> {add(x, S{y}) == S{add(x, y)} : N}:
  match x:
    case Z{}:
      {==}
    case S{p}:
      %add_s(p, y) : {S{add(p, S{y})} == S{_} : N}
      {==}
def add_z(x: N) -> {add(x, Z{}) == x : N}:
  match x:
    case Z{}:
      {==}
    case S{p}:
      %add_z(p) : {S{add(p, Z{})} == S{_} : N}
      {==}
def go_length(+xs: L, +acc: L) -> {len(go(xs, acc)) == add(len(xs), len(acc)) : N}:
  match xs:
    case Nil{}:
      {==}
    case Con{h, t}:
      %add_s(len(t), len(acc)) : {len(go(t, Con{h, acc})) == _ : N}
      go_length(t, Con{h, acc})
law rev_length:
  for +xs: L
  {len(rev(xs)) == len(xs) : N}
def rev_length(xs):
  %add_z(len(xs)) : {len(go(xs, Nil{})) == _ : N}
  go_length(xs, Nil{})
