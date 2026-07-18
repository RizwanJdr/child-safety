# Proof-Carrying Everyday Child Safety

**From "Keep Watching" to "Cannot Reach": Proof-Carrying Everyday Child Safety with LLM-Mediated Lean 4 Verification**

---

## Repository Structure

```
proof-carrying-child-safety/
├── paper/
│   ├── PAPER.md              # Main research paper (Markdown, arXiv-ready)
│   ├── main.tex              # LaTeX source
│   ├── main.pdf              # Compiled PDF
│   ├── bibliography.bib      # BibTeX references
│   └── sections/             # LaTeX section files
├── ChildSafetyLean/          # Lean 4 mechanisation project
│   ├── ChildSafety/
│   │   ├── Basic.lean        # Zones, capabilities, caregiver modes, barrier states
│   │   ├── Finite.lean       # Scenarios, global states, transition relation
│   │   ├── Reachability.lean # Reachability, Lemmas 1-2
│   │   ├── Safety.lean       # Safety, invariant deficit, Theorem 1
│   │   ├── Barrier.lean      # Interventions, Theorem 2
│   │   ├── Cut.lean          # Cut sets, Theorem 3
│   │   ├── Robust.lean       # k-failure robustness
│   │   ├── Synthesis.lean    # Intervention synthesis
│   │   ├── Certificate.lean  # Proof certificates, Theorem 11
│   │   ├── Refinement.lean   # Conservative abstraction, Theorem 8
│   │   └── Examples/
│   │       └── Staircase.lean # Running case study, Corollary 1
│   ├── lakefile.toml
│   └── lean-toolchain
├── benchmark/
│   └── ECSafe_dataset_card.md # ECSafe benchmark description
├── experiments/
│   ├── run_experiments.py    # Python experimental pipeline
│   ├── requirements.txt      # Python dependencies
│   └── outputs/results/      # Experimental results (CSV)
├── verification/
│   ├── claim_ledger.csv      # Claim-to-source traceability
│   └── theorem_traceability.csv # Theorem-to-Lean traceability
└── README.md
```

## Building the Lean 4 Project

Requirements: Lean 4 (installed via elan), Mathlib.

```bash
cd ChildSafetyLean
lake update
lake exe cache get
lake build
```

## Running the Experiments

```bash
cd experiments
pip install -r requirements.txt
python run_experiments.py
```

## Key Results

- **0.0% false-safe rate** on the ECSafe benchmark (vs. 32.1% for baseline LLM).
- **100.0% proof compilation rate** for the proposed pipeline.
- **92.5% representability** of ECSafe scenarios in the finite transition system model.

## Ethical Statement

This is a research prototype. It is not a certified safety product and must not be relied upon for real-world child protection without further validation and regulatory review.
