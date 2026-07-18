import ChildSafety.Basic
import ChildSafety.Finite
import ChildSafety.Reachability
import ChildSafety.Safety
import ChildSafety.Barrier
import ChildSafety.Cut
import ChildSafety.Robust
import ChildSafety.Synthesis
import ChildSafety.Certificate
import ChildSafety.Refinement
import ChildSafety.Examples.Staircase

/-!
# Main Entry Point

This file imports all modules to ensure they are built.
-/

def main : IO Unit :=
  IO.println "Child Safety Formalisation Lean 4 Project successfully built."
