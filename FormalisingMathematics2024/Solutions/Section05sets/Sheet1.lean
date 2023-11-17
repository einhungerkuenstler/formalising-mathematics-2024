/-
Copyright (c) 2022 Kevin Buzzard. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author : Kevin Buzzard
-/
import Mathbin.Tactic.Default

#align_import solutions.section05sets.sheet1

/-!

# Sets in Lean, sheet 1 : ∪ ∩ ⊆ and all that

Lean doesn't have "abstract" sets, it only has *subsets* of a type. If `X : Type` is a type
then the type of subsets of `X` is called `set X`. A term `A : set X`
can be thought of in three ways:

1) A set of elements of `X` (i.e. a set of elements all of which have type `X`);
2) A subset of `X`;
3) An element of the power set of `X`;
4) A function from `X` to `Prop` (sending the elements of `A` to `true` and the other ones to `false`)

So `set X` could have been called `subset X` or `powerset X`; I guess they chose `set X`
because it was the shortest.

Note that `X` is a type, but `A` is a term; the type of `A` is `set X`. This means
that `a : A` doesn't make sense. What we say instead is `a : X` and `a ∈ A`. 
Of course `a ∈ A` is a true-false statement, so `a ∈ A : Prop`. 

All the sets `A`, `B`, `C` etc we consider will be subsets of `X`. 
If `x : X` then `x` may or may not be an element of `A`, `B`, `C`,
but it will always be a term of type `X`.

-/


-- imports all the Lean tactics
-- imports all the Lean tactics
-- set up variables
variable (X : Type)
  -- Everything will be a subset of `X`
  (A B C D : Set X)
  -- A,B,C,D are subsets of `X`
  (x y z : X)

-- x,y,z are elements of `X` or, more precisely, terms of type `X`
/-

# subset (`⊆`), union (`∪`) and intersection (`∩`)

Here are some mathematical facts:

`A ⊆ B` is equivalent to `∀ x, x ∈ A → x ∈ B`;
`x ∈ A ∪ B` is equivalent to `x ∈ A ∨ x ∈ B`;
`x ∈ A ∩ B` is equivalent to `x ∈ A ∧ x ∈ B`. 

All of these things are true *by definition* in Lean. Let's
check this.

-/
theorem subset_def : A ⊆ B ↔ ∀ x, x ∈ A → x ∈ B :=
  by-- ↔ is reflexive so `refl` works because LHS is defined to be equal to RHS
  rfl

theorem mem_union_iff : x ∈ A ∪ B ↔ x ∈ A ∨ x ∈ B := by rfl

theorem mem_inter_iff : x ∈ A ∩ B ↔ x ∈ A ∧ x ∈ B :=
  Iff.rfl

-- you don't even have to go into tactic mode to prove this stuff
/-

So now to change one side of these `↔`s to the other, you can
`rw` the appropriate lemma, or you can just use `change`. Or
you can ask yourself whether you need to do this at all.

Let's prove some theorems.

-/
example : A ⊆ A := by
  rw [subset_def]
  -- don't need this
  intro x
  exact id

-- could do intro h, exact h
example : A ⊆ B → B ⊆ C → A ⊆ C := by
  intro hAB hBC x hxA
  apply hBC
  apply hAB hxA

-- or apply hAB, exact hxA
example : A ⊆ A ∪ B := by
  intro x hx
  left
  assumption

example : A ∩ B ⊆ A := by
  rintro x ⟨hxA, -⟩
  exact hxA

example : A ⊆ B → A ⊆ C → A ⊆ B ∩ C := by
  intro hAB hAC x hxA
  -- exact ⟨hAB hxA, hAC hxA⟩, -- finishes the level in one line
  constructor
  · apply hAB
    exact hxA
  · exact hAC hxA

example : B ⊆ A → C ⊆ A → B ∪ C ⊆ A :=
  by
  rintro hBA hCA x (hxB | hxC)
  · exact hBA hxB
  · exact hCA hxC

example : A ⊆ B → C ⊆ D → A ∪ C ⊆ B ∪ D :=
  Set.union_subset_union

-- found this with `library_search`
example : A ⊆ B → C ⊆ D → A ∩ C ⊆ B ∩ D :=
  by
  rintro hAB hCD x ⟨hxA, hxC⟩
  exact ⟨hAB hxA, hCD hxC⟩

