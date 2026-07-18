import ChildSafety.Finite
import Mathlib.Logic.Relation

/-!
# Reachability

This module defines reachability in the transition system.
-/

/-- Definition 11: Reachability.
Reflexive transitive closure of the transition relation. -/
def Reachable {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (assumptions : Γ) (s₁ s₂ : GlobalState V Q A B) : Prop :=
  Relation.ReflTransGen (Transition scen assumptions) s₁ s₂

/-- Lemma 1: Reachability concatenation.
If `s` can reach `t` and `t` can reach `u`, then `s` can reach `u`. -/
lemma reachability_concatenation {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (assumptions : Γ)
    {s t u : GlobalState V Q A B} (h₁ : Reachable scen assumptions s t) (h₂ : Reachable scen assumptions t u) :
    Reachable scen assumptions s u := by
  exact Relation.ReflTransGen.trans h₁ h₂

/-- Lemma 2: Restricted-transition inclusion.
If step₁ is a subset of step₂, then every step₁-reachable state is step₂-reachable. -/
lemma restricted_transition_inclusion {α : Type} (step₁ step₂ : α → α → Prop)
    (h_sub : ∀ a b, step₁ a b → step₂ a b) {s t : α}
    (h_reach : Relation.ReflTransGen step₁ s t) :
    Relation.ReflTransGen step₂ s t := by
  induction h_reach with
  | refl => exact Relation.ReflTransGen.refl
  | tail _ hbc ih => exact Relation.ReflTransGen.tail ih (h_sub _ _ hbc)
