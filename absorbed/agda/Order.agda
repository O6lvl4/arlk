module Order where

-- Order on the naturals: ≤ as an indexed family, proofs by dependent
-- pattern matching, and absurd patterns for the impossible cases. A
-- self-contained Agda module (no library).

data ℕ : Set where
  zero : ℕ
  suc  : ℕ → ℕ

data ⊥ : Set where

infix 4 _≤_

data _≤_ : ℕ → ℕ → Set where
  z≤n : {n : ℕ} → zero ≤ n
  s≤s : {m n : ℕ} → m ≤ n → suc m ≤ suc n

≤-pred : {m n : ℕ} → suc m ≤ suc n → m ≤ n
≤-pred (s≤s p) = p

¬s≤z : {m : ℕ} → suc m ≤ zero → ⊥
¬s≤z ()

≤-refl : (n : ℕ) → n ≤ n
≤-refl zero    = z≤n
≤-refl (suc n) = s≤s (≤-refl n)

≤-step : {m n : ℕ} → m ≤ n → m ≤ suc n
≤-step z≤n     = z≤n
≤-step (s≤s p) = s≤s (≤-step p)

¬s≤self : (n : ℕ) → suc n ≤ n → ⊥
¬s≤self zero    ()
¬s≤self (suc n) p = ¬s≤self n (≤-pred p)
