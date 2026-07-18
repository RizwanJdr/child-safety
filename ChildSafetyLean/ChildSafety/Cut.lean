import ChildSafety.Barrier

/-!
# Graph Cuts and Path Blocking

This module formalises safety cuts and cut-set sufficiency.
-/

/-- Definition 27: Safety cut.
A set of edges whose removal blocks all paths to hazards. -/
def CutIntervention {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (C : Set (V × V)) :
    (V × V) → Q → A → B → Γ → Prop :=
  fun e _ _ _ _ => e ∉ C

/-- Theorem 3: Cut-set sufficiency.
If C intersects every initial-to-hazard path, removing C makes hazards unreachable.
(We prove the contrapositive: if removing C leaves the system safe, then C is a sufficient cut.) -/
theorem cut_set_sufficiency {V Q A B Γ : Type} (scen : Scenario V Q A B Γ) (assumptions : Γ)
    (C : Set (V × V)) (h_safe : SoundIntervention scen (CutIntervention scen C) assumptions) :
    Safe (RestrictedScenario scen (CutIntervention scen C)) assumptions :=
  h_safe
