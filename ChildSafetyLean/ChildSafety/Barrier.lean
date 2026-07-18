import ChildSafety.Safety

/-!
# Barriers and Interventions

This module defines interventions, sound interventions, and barrier theorems.
-/

/-- Definition 17: Intervention.
A formal modification to edges, guards, barriers, capabilities, or initial conditions.
For simplicity, we model this as a restriction on the transition relation. -/
def RestrictedScenario {V Q A B Γ : Type} (scen : Scenario V Q A B Γ)
    (restrict : (V × V) → Q → A → B → Γ → Prop) : Scenario V Q A B Γ :=
  { scen with guard := fun e q a b γ => scen.guard e q a b γ ∧ restrict e q a b γ }

/-- Definition 18: Sound intervention.
An intervention C satisfying Safe(Σ restricted by C, Γ). -/
def SoundIntervention {V Q A B Γ : Type} (scen : Scenario V Q A B Γ)
    (restrict : (V × V) → Q → A → B → Γ → Prop) (assumptions : Γ) : Prop :=
  Safe (RestrictedScenario scen restrict) assumptions

/-- Theorem 2: Barrier monotonicity.
When interventions only remove transitions, adding further blocked transitions
preserves an already established safety property. -/
theorem barrier_monotonicity {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (assumptions : Γ)
    (restrict₁ restrict₂ : (V × V) → Q → A → B → Γ → Prop)
    (h_more_restrictive : ∀ e q a b γ, restrict₂ e q a b γ → restrict₁ e q a b γ)
    (h_safe : SoundIntervention scen restrict₁ assumptions) :
    SoundIntervention scen restrict₂ assumptions := by
  intro s₀ s h_init h_reach h_hazard
  apply h_safe s₀ s h_init _ h_hazard
  apply restricted_transition_inclusion (Transition (RestrictedScenario scen restrict₂) assumptions) (Transition (RestrictedScenario scen restrict₁) assumptions) _ h_reach
  intro x y h_trans
  rcases h_trans with ⟨h_edge, ⟨h_guard, h_res2⟩, h_cap, h_care, h_bar⟩
  exact ⟨h_edge, ⟨h_guard, h_more_restrictive _ _ _ _ _ h_res2⟩, h_cap, h_care, h_bar⟩
