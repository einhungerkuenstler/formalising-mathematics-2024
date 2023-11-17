/-
Copyright (c) 2022 Kevin Buzzard. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Author : Kevin Buzzard
-/
import Mathbin.Tactic.Default

#align_import section01logic.sheet5

/-!

# Logic in Lean, example sheet 5 : "iff" (`↔`)

We learn about how to manipulate `P ↔ Q` in Lean.

## Tactics

You'll need to know about the tactics from the previous sheets,
and also the following two new tactics:

* `refl`
* `rw`

-/


-- imports all the Lean tactics
-- imports all the Lean tactics
variable (P Q R S : Prop)

example : P ↔ P := by sorry

example : (P ↔ Q) → (Q ↔ P) := by sorry

example : (P ↔ Q) ↔ (Q ↔ P) := by sorry

example : (P ↔ Q) → (Q ↔ R) → (P ↔ R) := by sorry

example : P ∧ Q ↔ Q ∧ P := by sorry

example : (P ∧ Q) ∧ R ↔ P ∧ Q ∧ R := by sorry

example : P ↔ P ∧ True := by sorry

example : False ↔ P ∧ False := by sorry

example : (P ↔ Q) → (R ↔ S) → (P ∧ R ↔ Q ∧ S) := by sorry

example : ¬(P ↔ ¬P) := by sorry

