import ChildSafety.Reachability

/-!
# Safety Definitions

This module defines safety, hazards, and assumption contracts.
-/

/-- Definition 12: Hazard predicate. -/
def IsHazard {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (s : GlobalState V Q A B) : Prop :=
  s.zone ∈ scen.hazard

/-- Definition 14: Assumption-bounded deterministic safety.
Safety holds if every permitted execution from every initial state avoids every hazard. -/
def Safe {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (assumptions : Γ) : Prop :=
  ∀ (s₀ s : GlobalState V Q A B), s₀.zone ∈ scen.initial → Reachable scen assumptions s₀ s → ¬IsHazard scen s

/-- Definition 15: Invariant deficit.
A reachable hazard state from an initial state. -/
def InvariantDeficit {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (assumptions : Γ) : Prop :=
  ∃ (s₀ s : GlobalState V Q A B), s₀.zone ∈ scen.initial ∧ Reachable scen assumptions s₀ s ∧ IsHazard scen s

/-- Theorem 1: Reachability-invariant equivalence.
Safety holds if and only if there is no initial-to-hazard reachable state. -/
theorem reachability_invariant_equivalence {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (assumptions : Γ) :
    Safe scen assumptions ↔ ¬InvariantDeficit scen assumptions := by
  constructor
  · intro h_safe h_deficit
    rcases h_deficit with ⟨s₀, s, h_init, h_reach, h_hazard⟩
    exact h_safe s₀ s h_init h_reach h_hazard
  · intro h_no_deficit s₀ s h_init h_reach h_hazard
    apply h_no_deficit
    use s₀, s, h_init, h_reach, h_hazard
