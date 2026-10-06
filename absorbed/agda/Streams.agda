{-# OPTIONS --guardedness #-}
module Streams where

-- A coinductive record and definitions by copatterns: streams, built by
-- guarded corecursion. A self-contained Agda module (no library).

data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

infix 4 _≡_

data _≡_ {A : Set} (x : A) : A → Set where
  refl : x ≡ x

record Stream (A : Set) : Set where
  coinductive
  field
    head : A
    tail : Stream A

open Stream

repeat : {A : Set} → A → Stream A
head (repeat x) = x
tail (repeat x) = repeat x

from : ℕ → Stream ℕ
head (from n) = n
tail (from n) = from (suc n)

map : {A B : Set} → (A → B) → Stream A → Stream B
head (map f s) = f (head s)
tail (map f s) = map f (tail s)

third : head (tail (tail (from zero))) ≡ suc (suc zero)
third = refl

map-from : head (tail (map suc (from zero))) ≡ suc (suc zero)
map-from = refl

repeat-tail : {A : Set} (x : A) → head (tail (repeat x)) ≡ x
repeat-tail x = refl
