/-
Copyright (c) 2023 Kevin Buzzard. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author : Kevin Buzzard
-/
import Mathbin.Tactic.Default
import Order.Filter.Basic

#align_import solutions.section11_and_a_half_filters.sheet2

/-!

# The order (≤) on filters

We think of filters as generalised subsets, and just as subsets are partially ordered
by `⊆`, filters are partially ordered too, by `≤`. Recall that a subset `X : set α`
of `α` gives rise to a principal filter `𝓟 X : filter α`, and we definitely
want `X ⊆ Y ↔ 𝓟 X ≤ 𝓟 Y` so let's think about how this should work. If `F` and `G`
are filters, then `F ≤ G` should mean "the generalised subset `F` is contained
in the generalised subset `G`", so it should mean "if a normal subset of α contains
`G` then it contains `F`", so it should mean `G.sets ⊆ F.sets`, which is in fact
the definition. Note that the smaller the filter `F`, the bigger the collection
`F.sets`, because `F` is contained in more sets!

In the `filter` namespace there's a lemma


Let's formalise this. Show that 𝓟 S ≤ 𝓟 T ↔ S ⊆ T.
Note that this is called `principal_mono` in mathlib but 
there's no harm in proving it yourself.

Some helpful lemmas (all in the `filter` namespace):

`mem_principal : T ∈ 𝓟 S ↔ S ⊆ T`
`mem_principal_self S : S ∈ 𝓟 S`
`le_def : F ≤ G ↔ ∀ (S : set α), S ∈ G → S ∈ F`

-/


-- imports all the Lean tactics
-- imports all the Lean tactics
variable {α : Type}

open Filter Set

-- so we don't keep having to type `filter.le_def` and `set.subset.trans` etc
open scoped Filter

-- for 𝓟 notation
example (S T : Set α) : 𝓟 S ≤ 𝓟 T ↔ S ⊆ T :=
  by
  constructor
  · intro h
    rw [le_def] at h 
    have hT : T ∈ 𝓟 T := mem_principal_self T
    specialize h T hT
    rwa [mem_principal] at h 
  · intro hST
    rw [le_def]
    intro X hX
    rw [mem_principal] at hX ⊢
    exact subset.trans hST hX

-- Here's another useful lemma about principal filters.
-- It's called `le_principal_iff` in mathlib but why
-- not try proving it yourself?
example (F : Filter α) (S : Set α) : F ≤ 𝓟 S ↔ S ∈ F :=
  by
  rw [le_def]
  constructor
  · intro h
    apply h
    exact mem_principal_self S
  · intro hSF X hX
    rw [mem_principal] at hX 
    exact mem_of_superset hSF hX

/-

## Filters are a complete lattice

First I claim that if Fᵢ are a bunch of filters, indexed by `i : I`, then
the intersection of `Fᵢ.sets` is also a filter. Let's check this.

-/
def lUB {I : Type} (F : I → Filter α) : Filter α
    where
  sets := {X | ∀ i, X ∈ F i}
  univ_sets := by
    intro i
    apply univ_mem
  sets_of_superset := by
    intro S T hS hST i
    apply mem_of_superset _ hST
    apply hS
  inter_sets := by
    intro S T hS hT i
    exact inter_mem (hS i) (hT i)

/-

Now let's check that this is a least upper bound for the Fᵢ! We check the
two axioms.

-/
-- it's an upper bound
example (I : Type) (F : I → Filter α) (i : I) : F i ≤ lUB F :=
  by
  intro S hS
  apply hS

-- it's ≤ all other upper bounds
example (I : Type) (F : I → Filter α) (G : Filter α) (hG : ∀ i, F i ≤ G) : lUB F ≤ G :=
  by
  intro S hS i
  apply hG
  exact hS

/-

Just like it's possible to talk about the topological space generated
by a collection of subsets of `α` -- this is the smallest topology
for which the given subsets are all open -- it's also possible to talk
about the filter generated by a collection of subsets of `α`. One
can define it as the intersection of all the filters that contain your
given collection of subsets (we just proved above that this is a filter).
This gives us a definition of greatest lower bound for filters too.

-/
-- greatest lower bound of filters Fᵢ is the least upper bound of the filters G whose `sets`
-- contain all of the `Fᵢ.sets`
def gLB {I : Type} (F : I → Filter α) : Filter α :=
  lUB fun G : {G : Filter α | ∀ i, (F i).sets ⊆ G.sets} => G.1

-- it's a lower bound
example (I : Type) (F : I → Filter α) (i : I) : gLB F ≤ F i :=
  by
  rintro S hS ⟨G, hG⟩
  dsimp
  apply hG _ hS

-- it's ≥ all other lower bounds
example (I : Type) (F : I → Filter α) (G : Filter α) (hG : ∀ i, G ≤ F i) : G ≤ gLB F :=
  by
  intro S hS
  unfold gLB at hS 
  dsimp at hS 
  unfold lUB at hS 
  dsimp at hS 
  specialize hS ⟨G, _⟩
  · exact hG
  · exact hS

