import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Finset.Basic

/-!
# Finite Transition Systems

This module defines finite transition systems for the child safety formalisation.
-/

/-- Definition 7: Domestic safety scenario.
A structure containing all components of the formal model. -/
structure Scenario (V Q A B Γ : Type) where
  edges : Set (V × V)
  initial : Set V
  hazard : Set V
  guard : (V × V) → Q → A → B → Γ → Prop

/-- Definition 8: Global state.
The complete state of the system at any given moment. -/
structure GlobalState (V Q A B : Type) where
  zone : V
  cap : Q
  caregiver : A
  barrier : B

/-- Definition 9: Transition relation.
A relation defining when one state can transition to another. -/
def Transition {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (assumptions : Γ) (s₁ s₂ : GlobalState V Q A B) : Prop :=
  (s₁.zone, s₂.zone) ∈ scen.edges ∧
  scen.guard (s₁.zone, s₂.zone) s₁.cap s₁.caregiver s₁.barrier assumptions ∧
  s₂.cap = s₁.cap ∧
  s₂.caregiver = s₁.caregiver ∧
  s₂.barrier = s₁.barrier
