theory Arith
  imports Main
begin

text \<open>Natural numbers and lists of our own, with addition, append and
reverse, and their laws: each proof is an Isabelle proof method, replayed
by Arlk's simp.\<close>

datatype num = Z | S num

fun add :: "num \<Rightarrow> num \<Rightarrow> num" where
  "add Z n = n"
| "add (S m) n = S (add m n)"

lemma add_Z [simp]: "add n Z = n"
  by (induction n) auto

lemma add_S [simp]: "add m (S n) = S (add m n)"
  by (induction m) auto

lemma add_comm: "add m n = add n m"
  by (induction m) auto

lemma add_assoc: "add (add a b) c = add a (add b c)"
  by (induction a) auto

datatype 'a seq = Nil | Cons 'a "'a seq"

fun app :: "'a seq \<Rightarrow> 'a seq \<Rightarrow> 'a seq" where
  "app Nil ys = ys"
| "app (Cons x xs) ys = Cons x (app xs ys)"

fun rev :: "'a seq \<Rightarrow> 'a seq" where
  "rev Nil = Nil"
| "rev (Cons x xs) = app (rev xs) (Cons x Nil)"

fun len :: "'a seq \<Rightarrow> num" where
  "len Nil = Z"
| "len (Cons x xs) = S (len xs)"

lemma app_Nil [simp]: "app xs Nil = xs"
  by (induction xs) auto

lemma app_assoc [simp]: "app (app xs ys) zs = app xs (app ys zs)"
  by (induction xs) auto

lemma rev_app [simp]: "rev (app xs ys) = app (rev ys) (rev xs)"
  by (induction xs) auto

lemma rev_rev: "rev (rev xs) = xs"
  by (induction xs) auto

lemma len_app: "len (app xs ys) = add (len xs) (len ys)"
  by (induction xs) auto

end
