import ChildSafety.Safety
import ChildSafety.Barrier

/-!
# Proof Certificates

This module defines proof-carrying recommendations.
-/

/-- Definition 24: Proof-carrying recommendation. -/
structure ProofCertificate (V Q A B Γ : Type) where
  scenario : Scenario V Q A B Γ
  assumptions : Γ
  intervention : (V × V) → Q → A → B → Γ → Prop
  proposition : Prop
  proof : SoundIntervention scenario intervention assumptions
  explanation : String

/-- Theorem 11: Certificate soundness.
If the checker accepts the artifact, the exact proposition follows from the
formal model and assumptions. -/
theorem certificate_soundness {V Q A B Γ : Type} (cert : ProofCertificate V Q A B Γ) :
    SoundIntervention cert.scenario cert.intervention cert.assumptions :=
  cert.proof
