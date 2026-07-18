import ChildSafety.Safety

/-!
# Conservative Abstraction

This module defines conservative abstraction and simulation.
-/

/-- Definition 22: Conservative abstraction.
Every relevant concrete transition is represented by the abstract model. -/
def Simulates {V₁ Q₁ A₁ B₁ Γ₁ V₂ Q₂ A₂ B₂ Γ₂ : Type}
    (scen₁ : Scenario V₁ Q₁ A₁ B₁ Γ₁) (assumptions₁ : Γ₁)
    (scen₂ : Scenario V₂ Q₂ A₂ B₂ Γ₂) (assumptions₂ : Γ₂)
    (rel : GlobalState V₁ Q₁ A₁ B₁ → GlobalState V₂ Q₂ A₂ B₂ → Prop) : Prop :=
  ∀ s₁ s₂ t₁, Transition scen₁ assumptions₁ s₁ t₁ → rel s₁ s₂ →
    ∃ t₂, Transition scen₂ assumptions₂ s₂ t₂ ∧ rel t₁ t₂

lemma simulates_reach {V₁ Q₁ A₁ B₁ Γ₁ V₂ Q₂ A₂ B₂ Γ₂ : Type}
    (scen₁ : Scenario V₁ Q₁ A₁ B₁ Γ₁) (assumptions₁ : Γ₁)
    (scen₂ : Scenario V₂ Q₂ A₂ B₂ Γ₂) (assumptions₂ : Γ₂)
    (rel : GlobalState V₁ Q₁ A₁ B₁ → GlobalState V₂ Q₂ A₂ B₂ → Prop)
    (h_sim : Simulates scen₁ assumptions₁ scen₂ assumptions₂ rel)
    {s₁ t₁ : GlobalState V₁ Q₁ A₁ B₁} {s₂ : GlobalState V₂ Q₂ A₂ B₂}
    (h_reach : Reachable scen₁ assumptions₁ s₁ t₁) (h_rel : rel s₁ s₂) :
    ∃ t₂, Reachable scen₂ assumptions₂ s₂ t₂ ∧ rel t₁ t₂ := by
  induction h_reach generalizing s₂ with
  | refl =>
    exact ⟨s₂, Relation.ReflTransGen.refl, h_rel⟩
  | tail _ h_step ih =>
    rcases ih h_rel with ⟨mid₂, h_reach₂, h_rel_mid⟩
    rcases h_sim _ _ _ h_step h_rel_mid with ⟨t₂, h_step₂, h_rel_t⟩
    exact ⟨t₂, Relation.ReflTransGen.tail h_reach₂ h_step₂, h_rel_t⟩

/-- Theorem 8: Conservative-abstraction safety transfer.
If the abstract model overapproximates the concrete system, concrete hazards
map to abstract hazards, and the abstract model is safe, then the represented
concrete property follows under the abstraction assumptions. -/
theorem conservative_abstraction_safety_transfer {V₁ Q₁ A₁ B₁ Γ₁ V₂ Q₂ A₂ B₂ Γ₂ : Type}
    (scen₁ : Scenario V₁ Q₁ A₁ B₁ Γ₁) (assumptions₁ : Γ₁)
    (scen₂ : Scenario V₂ Q₂ A₂ B₂ Γ₂) (assumptions₂ : Γ₂)
    (rel : GlobalState V₁ Q₁ A₁ B₁ → GlobalState V₂ Q₂ A₂ B₂ → Prop)
    (h_sim : Simulates scen₁ assumptions₁ scen₂ assumptions₂ rel)
    (h_init : ∀ s₁, s₁.zone ∈ scen₁.initial → ∃ s₂, s₂.zone ∈ scen₂.initial ∧ rel s₁ s₂)
    (h_hazard : ∀ s₁ s₂, rel s₁ s₂ → s₁.zone ∈ scen₁.hazard → s₂.zone ∈ scen₂.hazard)
    (h_safe : Safe scen₂ assumptions₂) :
    Safe scen₁ assumptions₁ := by
  intro s₀ s h_init_s₀ h_reach h_haz
  rcases h_init s₀ h_init_s₀ with ⟨t₀, h_init_t₀, h_rel_s₀_t₀⟩
  rcases simulates_reach scen₁ assumptions₁ scen₂ assumptions₂ rel h_sim h_reach h_rel_s₀_t₀ with ⟨t, h_reach_t, h_rel_s_t⟩
  have h_haz_t := h_hazard s t h_rel_s_t h_haz
  exact h_safe t₀ t h_init_t₀ h_reach_t h_haz_t
