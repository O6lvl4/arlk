module Inspect where

-- `with e in eq`: each case of e also gets the equation that it is that
-- case. A self-contained Agda module (no library).

data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

data Bool : Set where
  true  : Bool
  false : Bool

infix 4 _≡_

data _≡_ {A : Set} (x : A) : A → Set where
  refl : x ≡ x

{-# BUILTIN EQUALITY _≡_ #-}

data _⊎_ (A B : Set) : Set where
  inj₁ : A → A ⊎ B
  inj₂ : B → A ⊎ B

is-zero : ℕ → Bool
is-zero zero    = true
is-zero (suc n) = false

data ⊥ : Set where

⊥-elim : {A : Set} → ⊥ → A
⊥-elim ()

false≢true : false ≡ true → ⊥
false≢true ()

zero-of-true : (n : ℕ) → is-zero n ≡ true → n ≡ zero
zero-of-true zero    e = refl
zero-of-true (suc n) e = ⊥-elim (false≢true e)

zero-or-false : (n : ℕ) → (n ≡ zero) ⊎ (is-zero n ≡ false)
zero-or-false n with is-zero n in eq
... | true  = inj₁ (zero-of-true n eq)
... | false = inj₂ refl
