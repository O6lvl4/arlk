module Records where

-- Records with projections, `open` on a record, and `with` on the value
-- of a call. A self-contained Agda module (no library).

data Bool : Set where
  true  : Bool
  false : Bool

data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

infixr 5 _∷_
infixr 4 _,_
infix 4 _≡_

data _≡_ {A : Set} (x : A) : A → Set where
  refl : x ≡ x

data List (A : Set) : Set where
  []  : List A
  _∷_ : A → List A → List A

record Pair (A B : Set) : Set where
  constructor _,_
  field
    fst : A
    snd : B

open Pair

swap : {A B : Set} → Pair A B → Pair B A
swap p = snd p , fst p

swap-swap : {A B : Set} (p : Pair A B) → swap (swap p) ≡ p
swap-swap (a , b) = refl

filter : {A : Set} → (A → Bool) → List A → List A
filter p [] = []
filter p (x ∷ xs) with p x
... | true  = x ∷ filter p xs
... | false = filter p xs

not : Bool → Bool
not true  = false
not false = true

evens : List Bool
evens = filter not (true ∷ false ∷ false ∷ [])

evens-ok : evens ≡ false ∷ false ∷ []
evens-ok = refl

-- `with` in a proof: the goal mentions `p x`, and each arm sees it replaced
-- by the case it is in.
not-not-with : {A : Set} (p : A → Bool) (x : A) → not (not (p x)) ≡ p x
not-not-with p x with p x
... | true  = refl
... | false = refl
