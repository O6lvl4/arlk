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
def snoc(xs: L, x: N) -> L:
  match xs:
    case Nil{}:
      Con{x, Nil{}}
    case Con{h, t}:
      Con{h, snoc(t, x)}
def rev(xs: L) -> L:
  match xs:
    case Nil{}:
      Nil{}
    case Con{h, t}:
      snoc(rev(t), h)
# PROOF
def len_snoc(xs: L, x: N) -> {len(snoc(xs, x)) == S{len(xs)} : N}:
  match xs:
    case Nil{}:
      {==}
    case Con{h, t}:
      %len_snoc(t, x) : {S{len(snoc(t, x))} == S{_} : N}
      {==}
law rev_length:
  for +xs: L
  {len(rev(xs)) == len(xs) : N}
def rev_length(xs):
  match xs:
    case Nil{}:
      {==}
    case Con{h, t}:
      %rev_length(t) : {len(snoc(rev(t), h)) == S{_} : N}
      len_snoc(rev(t), h)
