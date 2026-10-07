module Rewriting where

-- Equational proofs by `rewrite`, helpers in `where`, `let`, point-free
-- definitions and implicit patterns: a self-contained Agda module (no
-- library).

data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

infixl 6 _+_
infixl 7 _*_
infix 4 _≡_

data _≡_ {A : Set} (x : A) : A → Set where
  refl : x ≡ x

{-# BUILTIN EQUALITY _≡_ #-}

sym : {A : Set} {x y : A} → x ≡ y → y ≡ x
sym refl = refl

trans : {A : Set} {x y z : A} → x ≡ y → y ≡ z → x ≡ z
trans refl q = q

cong : {A B : Set} (f : A → B) {x y : A} → x ≡ y → f x ≡ f y
cong f refl = refl

_+_ : ℕ → ℕ → ℕ
zero  + n = n
suc m + n = suc (m + n)

_*_ : ℕ → ℕ → ℕ
zero  * n = zero
suc m * n = n + m * n

+-zero : (n : ℕ) → n + zero ≡ n
+-zero zero    = refl
+-zero (suc n) rewrite +-zero n = refl

+-suc : (m n : ℕ) → m + suc n ≡ suc (m + n)
+-suc zero    n = refl
+-suc (suc m) n rewrite +-suc m n = refl

+-comm : (m n : ℕ) → m + n ≡ n + m
+-comm zero    n rewrite +-zero n = refl
+-comm (suc m) n rewrite +-comm m n | +-suc n m = refl

+-assoc : (a b c : ℕ) → (a + b) + c ≡ a + (b + c)
+-assoc zero    b c = refl
+-assoc (suc a) b c rewrite +-assoc a b c = refl

*-zero : (n : ℕ) → n * zero ≡ zero
*-zero zero    = refl
*-zero (suc n) rewrite *-zero n = refl

pred-suc : {n : ℕ} → suc n ≡ suc n
pred-suc {n} = refl

twice : (ℕ → ℕ) → ℕ → ℕ
twice f x = let y = f x in f y

id-lam : ℕ → ℕ
id-lam = λ x → x

*-suc : (m n : ℕ) → m * suc n ≡ m + m * n
*-suc zero    n = refl
*-suc (suc m) n rewrite *-suc m n = cong suc (lemma m n (m * n))
  where
    swap : (a b c : ℕ) → a + (b + c) ≡ b + (a + c)
    swap a b c rewrite sym (+-assoc a b c) | +-comm a b | +-assoc b a c = refl
    lemma : (a b c : ℕ) → b + (a + c) ≡ a + (b + c)
    lemma a b c = swap b a c
