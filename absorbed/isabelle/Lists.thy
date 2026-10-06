theory Lists
  imports Main
begin

text \<open>Lists and numbers from Main: infix syntax, numerals, list
literals, a generalised induction and a structured (Isar) proof. Each
proof is replayed by Arlk's simp over lib/isabelle_main.arlk.\<close>

fun itrev :: "'a list \<Rightarrow> 'a list \<Rightarrow> 'a list" where
  "itrev [] ys = ys"
| "itrev (x # xs) ys = itrev xs (x # ys)"

lemma itrev_rev [simp]: "itrev xs ys = rev xs @ ys"
  by (induction xs arbitrary: ys) auto

lemma itrev_Nil: "itrev xs [] = rev xs"
  by simp

fun total :: "nat list \<Rightarrow> nat" where
  "total [] = 0"
| "total (x # xs) = x + total xs"

lemma total_append [simp]: "total (xs @ ys) = total xs + total ys"
  by (induction xs) auto

lemma total_rev: "total (rev xs) = total xs"
proof (induction xs)
  case Nil
  show ?case by simp
next
  case (Cons x xs)
  thus ?case by (simp add: add.commute)
qed

fun double :: "nat \<Rightarrow> nat" where
  "double 0 = 0"
| "double (Suc n) = Suc (Suc (double n))"

lemma double_add: "double n = n + n"
  by (induction n) auto

lemma length_three: "length [a, b, c] = 3"
  by simp

lemma rev_two: "rev [a, b] = [b, a]"
  by simp

lemma map_double: "map double (xs @ ys) = map double xs @ map double ys"
  by simp

end
