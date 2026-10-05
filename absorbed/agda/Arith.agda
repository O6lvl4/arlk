module Arith where

-- Natural numbers, lists and equality, with the usual laws, proved by
-- pattern matching: a self-contained Agda module (no library).

data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

infixl 6 _+_
infixl 7 _*_
infix 4 _≡_
infixr 5 _∷_ _++_

data _≡_ {A : Set} (x : A) : A → Set where
  refl : x ≡ x

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
+-zero (suc n) = cong suc (+-zero n)

+-suc : (m n : ℕ) → m + suc n ≡ suc (m + n)
+-suc zero    n = refl
+-suc (suc m) n = cong suc (+-suc m n)

+-comm : (m n : ℕ) → m + n ≡ n + m
+-comm zero    n = sym (+-zero n)
+-comm (suc m) n = trans (cong suc (+-comm m n)) (sym (+-suc n m))

+-assoc : (a b c : ℕ) → (a + b) + c ≡ a + (b + c)
+-assoc zero    b c = refl
+-assoc (suc a) b c = cong suc (+-assoc a b c)

*-zero : (n : ℕ) → n * zero ≡ zero
*-zero zero    = refl
*-zero (suc n) = *-zero n

data List (A : Set) : Set where
  []  : List A
  _∷_ : A → List A → List A

_++_ : {A : Set} → List A → List A → List A
[]       ++ ys = ys
(x ∷ xs) ++ ys = x ∷ (xs ++ ys)

length : {A : Set} → List A → ℕ
length []       = zero
length (x ∷ xs) = suc (length xs)

map : {A B : Set} → (A → B) → List A → List B
map f []       = []
map f (x ∷ xs) = f x ∷ map f xs

++-length : {A : Set} (xs ys : List A) → length (xs ++ ys) ≡ length xs + length ys
++-length []       ys = refl
++-length (x ∷ xs) ys = cong suc (++-length xs ys)

map-length : {A B : Set} (f : A → B) (xs : List A) → length (map f xs) ≡ length xs
map-length f []       = refl
map-length f (x ∷ xs) = cong suc (map-length f xs)

++-assoc : {A : Set} (xs ys zs : List A) → (xs ++ ys) ++ zs ≡ xs ++ (ys ++ zs)
++-assoc []       ys zs = refl
++-assoc (x ∷ xs) ys zs = cong (λ l → x ∷ l) (++-assoc xs ys zs)
