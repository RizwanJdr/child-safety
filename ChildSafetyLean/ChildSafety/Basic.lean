import Mathlib.Data.Set.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Fintype.Basic

/-!
# Basic Definitions for Child Safety Formalisation

This module contains the foundational definitions for the domestic child safety formalisation.
It defines the spatial zones, edges, child capabilities, caregiver modes, and barrier states.
-/

/-- Definition 1: Spatial zone.
A member `v` of a finite set `V` representing a location distinguishable for the target safety property. -/
structure Zone where
  id : String
  deriving DecidableEq, Repr, Inhabited

/-- Definition 2: Potential movement edge.
An ordered pair representing a possible transition before guards are applied. -/
def Edge (V : Type) := V × V

/-- Definition 3: Child capability profile.
A finitely represented capability state `q`. -/
structure CapabilityProfile where
  crawling : Bool
  walking : Bool
  climbing : Bool
  openUnlockedDoor : Bool
  operateLatch : Bool
  moveFurniture : Bool
  reachObject : Bool
  deriving DecidableEq, Repr, Inhabited

/-- Definition 4: Caregiver mode.
A finite type representing the state of the caregiver. -/
inductive CaregiverMode
  | Attentive
  | Distracted
  | Asleep
  | Absent
  deriving DecidableEq, Repr, Inhabited

/-- Definition 5: Barrier state.
A finite type representing the state of a physical barrier. -/
inductive BarrierState
  | Open
  | ClosedUnlocked
  | ClosedLatched
  | Failed
  deriving DecidableEq, Repr, Inhabited

/-- Definition 6: Edge guard.
A function determining if a transition is possible given the current capabilities,
caregiver mode, barrier states, and assumptions. -/
def EdgeGuard (Q : Type) (A : Type) (B : Type) (Γ : Type) :=
  Q → A → B → Γ → Prop
