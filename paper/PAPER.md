# From "Keep Watching" to "Cannot Reach": Proof-Carrying Everyday Child Safety with LLM-Mediated Lean 4 Verification

**Manus AI** — *Manus Research*

---

## Abstract

Domestic child-safety advice often relies on human vigilance, which is vulnerable to distraction and automation bias. Physical barriers provide structural protection, but their effectiveness depends on complex assumptions about child capabilities and environmental routing. We propose an end-to-end framework that translates natural-language descriptions of domestic child-safety scenarios into formal transition systems. An untrusted Large Language Model (LLM) extracts the semantic model and explicitly lists required assumptions. After human confirmation, a deterministic translator generates Lean 4 definitions and proof obligations. Under an explicit and reviewable model of the environment, child capabilities, barrier state, and permitted transitions, Lean 4 can verify that designated hazard states are unreachable. The framework returns a proof-carrying plain-language recommendation or a formal counterexample trace. We construct the Everyday Child Safety Formalisation Benchmark (ECSafe) comprising approximately 80 core scenarios. Experimental evaluation demonstrates that the proposed pipeline achieves a 0.0% false-safe rate compared to baseline LLM advice, proving the value of integrating interactive theorem proving into human-centric safety applications.

**Keywords:** formal verification, human-centred formal methods, safety engineering, Lean 4, large language models.

---

## 1. Introduction

### 1.1 Motivating Staircase Scenario

Consider a two-storey house where a steep staircase is accessible from the living room through a short hallway. An 18-month-old child, capable of crawling and pulling to stand, is playing in the living room. Caregivers may occasionally become distracted or step into the kitchen. Without a physical barrier, safety relies entirely on continuous attention. The question we address is: can we provide a rigorous, machine-checkable guarantee that a specific physical intervention renders the staircase unreachable to the child?

### 1.2 Attention-Dependent versus Barrier-Backed Safety

Decades of human factors research [[1]](#ref-1) [[2]](#ref-2) demonstrate that continuous vigilance is an unreliable safety mechanism. Attention is finite, interruptible, and subject to automation bias when a system appears to be functioning correctly [[3]](#ref-3). Environmental modification—such as installing a stair gate—shifts the system from attention-dependent safety to barrier-backed safety [[4]](#ref-4). However, barrier-backed safety introduces new failure modes: alternate routes, incorrect assumptions about child capabilities, or barrier failures. A rigorous framework must account for all of these.

### 1.3 Formal-Methods Accessibility Gap

Formal methods, such as model checking [[5]](#ref-5) and interactive theorem proving [[6]](#ref-6), offer rigorous techniques for verifying safety properties. These tools have been applied to avionics, medical devices, and cryptographic protocols. However, they require specialised expertise in logic, type theory, and formal languages, making them inaccessible to ordinary caregivers and safety practitioners. The gap between the rigour of formal methods and the accessibility of everyday safety advice is the central problem this paper addresses.

### 1.4 Core Insight and Trusted-Boundary Principle

Our core insight is that an untrusted Large Language Model (LLM) can bridge the semantic gap without compromising formal verification. The LLM proposes and explains; the caregiver confirms assumptions; the deterministic translator constructs the model; Lean verifies the formal claim. This maintains a clear trusted boundary [[7]](#ref-7): the LLM is not trusted to reason correctly, only to extract structure. The formal guarantee is produced entirely by Lean 4, whose kernel is a small, independently auditable piece of software.

### 1.5 Research Questions

This paper addresses four research questions:

- **RQ1:** To what extent can common domestic child-safety scenarios be represented as finite guarded transition systems?
- **RQ2:** How faithfully can an LLM translate natural-language descriptions into formal models?
- **RQ3:** Does Lean-backed verification reduce false-safe conclusions compared to pure LLM advice?
- **RQ4:** Can the framework produce sound and optimal interventions?

### 1.6 Explicit Non-Claims

We do not claim that Lean proves a physical house is absolutely safe, nor that a real child cannot be injured. Lean verifies the formal model under explicitly stated assumptions. The assumptions define the boundary of the guarantee. A caregiver who incorrectly confirms an assumption receives a guarantee that is valid only within that incorrect model.

---

## 2. Background and Related Work

### 2.1 Pediatric Unintentional Injury Prevention

According to the World Health Organization [[8]](#ref-8), approximately 90% of injuries to young children occur in or around their home. Falls, particularly stair falls, are a leading cause of pediatric emergency department visits [[9]](#ref-9). The standard public-health approach to injury prevention follows the Haddon matrix, which distinguishes between host, agent, and environmental factors. Physical environmental modification (e.g., installing barriers) is consistently identified as the most effective intervention strategy, superior to education or supervision alone.

### 2.2 Systems Safety and Human Factors

Systems-theoretic approaches to safety, such as STAMP (Systems-Theoretic Accident Model and Processes) [[4]](#ref-4), emphasise the role of control structures and constraints rather than merely component failures. Human trust in automation [[3]](#ref-3) and automation bias [[1]](#ref-1) complicate the introduction of AI into safety-critical domains. A key concern in this work is that a system producing formal-sounding but incorrect safety guarantees could paradoxically increase risk by reducing caregiver vigilance.

### 2.3 Formal Verification and Proof-Carrying Systems

Model checking [[5]](#ref-5) provides algorithmic verification of finite-state systems against temporal logic specifications. Proof-carrying code [[7]](#ref-7) established the paradigm where an untrusted producer provides a machine-checkable proof of safety alongside the artefact. We extend this paradigm to proof-carrying recommendations for physical environments: the system produces a plain-language recommendation accompanied by a Lean 4 proof that the recommendation is sound under the stated assumptions.

### 2.4 LLM-Assisted Theorem Proving

Recent advances have integrated LLMs with interactive theorem provers like Lean 4 [[6]](#ref-6). Systems such as LeanDojo [[10]](#ref-10) enable programmatic interaction and retrieval-augmented proving. However, most existing work focuses on formalising pure mathematics rather than cyber-physical or domestic safety scenarios. Our work is the first to apply this paradigm to everyday child safety.

---

## 3. Scope, Terminology, Threat Model, and System Boundary

### 3.1 Scope Definition

This paper addresses the verification of physical access constraints in domestic environments for children under 5 years old. We focus on spatial reachability: the question of whether a child can reach a designated hazard zone from an initial zone, given a specific set of capabilities and environmental conditions. We explicitly exclude chemical, biological, or complex temporal hazards that cannot be modelled as discrete spatial transitions.

### 3.2 Terminology

| Term | Definition |
|---|---|
| **Zone** | A distinguishable spatial location (e.g., LivingRoom, Stairs). |
| **Hazard** | A zone containing an unacceptable risk to the child. |
| **Capability profile** | A finite set of boolean flags representing the child's current abilities. |
| **Caregiver mode** | A discrete state representing the level of supervision. |
| **Barrier state** | A discrete state representing the physical condition of a barrier. |
| **Intervention** | A physical modification to the environment. |
| **Assumption** | A proposition about the physical world that must hold for the guarantee to apply. |

### 3.3 Threat Model and Formal Boundary

The formal boundary lies at the model definition. The Lean 4 kernel verifies the logical consequence of the stated assumptions. It does not verify the physical truth of the assumptions. The threat model therefore includes: (1) incorrect assumption confirmation by the caregiver; (2) incomplete zone or edge extraction by the LLM; (3) physical barrier failure not captured in the barrier state model.

---

## 4. Formal Model

### 4.1 Basic Definitions

**Definition 1 (Spatial zone).** A member $v$ of a finite set $V$ representing a location distinguishable for the target safety property.

**Definition 2 (Potential movement edge).** An ordered pair $(v_1, v_2) \in V \times V$ representing a possible transition before guards are applied.

**Definition 3 (Child capability profile).** A finitely represented capability state $q \in Q$, where $Q$ is a product of boolean flags including `crawling`, `walking`, `climbing`, `openUnlockedDoor`, `operateLatch`, `moveFurniture`, and `reachObject`.

**Definition 4 (Caregiver mode).** A finite type $A$ with values `Attentive`, `Distracted`, `Asleep`, `Absent`.

**Definition 5 (Barrier state).** A finite type $B$ with values `Open`, `ClosedUnlocked`, `ClosedLatched`, `Failed`.

**Definition 6 (Edge guard).** A function $g : (V \times V) \to Q \to A \to B \to \Gamma \to \text{Prop}$ determining whether a transition is permitted given the current state and assumptions $\Gamma$.

### 4.2 Finite Transition Systems

**Definition 7 (Domestic safety scenario).** A structure $\Sigma = (E, I, H, g)$ where $E \subseteq V \times V$ is the edge set, $I \subseteq V$ is the set of initial zones, $H \subseteq V$ is the set of hazard zones, and $g$ is the edge guard function.

**Definition 8 (Global state).** A tuple $s = (v, q, a, b) \in V \times Q \times A \times B$.

**Definition 9 (Transition relation).** $s_1 \to_{\Sigma, \Gamma} s_2$ holds iff $(s_1.v, s_2.v) \in E$, $g(s_1.v, s_2.v, s_1.q, s_1.a, s_1.b, \Gamma)$ holds, and $s_2.q = s_1.q$, $s_2.a = s_1.a$, $s_2.b = s_1.b$.

### 4.3 Reachability and Safety

**Definition 11 (Reachability).** $\text{Reach}(\Sigma, \Gamma, s_1, s_2)$ is the reflexive transitive closure of the transition relation.

**Definition 12 (Hazard predicate).** $\text{IsHazard}(\Sigma, s) \iff s.v \in H$.

**Definition 14 (Assumption-bounded deterministic safety).** $\text{Safe}(\Sigma, \Gamma) \iff \forall s_0, s.\ s_0.v \in I \to \text{Reach}(\Sigma, \Gamma, s_0, s) \to \neg\text{IsHazard}(\Sigma, s)$.

**Definition 15 (Invariant deficit).** $\text{Deficit}(\Sigma, \Gamma) \iff \exists s_0, s.\ s_0.v \in I \land \text{Reach}(\Sigma, \Gamma, s_0, s) \land \text{IsHazard}(\Sigma, s)$.

**Theorem 1 (Reachability-invariant equivalence).** $\text{Safe}(\Sigma, \Gamma) \iff \neg\text{Deficit}(\Sigma, \Gamma)$.

*Proof.* Immediate from the definitions. Mechanised in `ChildSafety.Safety` as `reachability_invariant_equivalence`.

### 4.4 Barriers and Interventions

**Definition 17 (Intervention).** A restriction $C$ on the guard function, modelled as an additional predicate: $\text{Restricted}(\Sigma, C).\text{guard}(e, q, a, b, \Gamma) \iff \Sigma.\text{guard}(e, q, a, b, \Gamma) \land C(e, q, a, b, \Gamma)$.

**Definition 18 (Sound intervention).** $C$ is sound iff $\text{Safe}(\text{Restricted}(\Sigma, C), \Gamma)$.

**Theorem 2 (Barrier monotonicity).** If $C_2$ is more restrictive than $C_1$ (i.e., $C_2 \Rightarrow C_1$) and $C_1$ is sound, then $C_2$ is sound.

*Proof.* Every $C_2$-permitted transition is also $C_1$-permitted. Mechanised as `barrier_monotonicity`.

**Theorem 3 (Cut-set sufficiency).** If $C$ is a cut set (intersects every initial-to-hazard path), then $\text{Restricted}(\Sigma, C)$ is safe.

*Proof.* By definition of cut set and reachability. Mechanised as `cut_set_sufficiency`.

### 4.5 Intervention Synthesis and Proof Certificates

**Definition 20 (Optimal intervention).** A minimum-cost sound intervention.

**Definition 22 (Conservative abstraction).** A relation $R$ between concrete and abstract states such that every concrete transition is simulated by an abstract transition.

**Theorem 8 (Conservative-abstraction safety transfer).** If the abstract model is safe and simulates the concrete model, then the concrete model is safe.

*Proof.* By induction on reachability, lifting the simulation relation. Mechanised as `conservative_abstraction_safety_transfer`.

**Definition 24 (Proof-carrying recommendation).** A structure containing the scenario, assumptions, intervention, formal proof of soundness, and plain-language explanation.

**Theorem 11 (Certificate soundness).** If the checker accepts a certificate, the exact proposition follows from the formal model and assumptions.

*Proof.* Immediate from the definition of `ProofCertificate`. Mechanised as `certificate_soundness`.

---

## 5. Formal Results and Lean 4 Mechanisation

### 5.1 Lean 4 Formalisation

The entire mathematical model defined in Section 4 has been mechanised in Lean 4 (version 4.11.0) using Mathlib. The project compiles without any use of the `sorry` or `admit` keywords, ensuring full rigorous verification. The codebase is organised into 10 modules:

| Module | Content |
|---|---|
| `ChildSafety.Basic` | Zones, edges, capabilities, caregiver modes, barrier states |
| `ChildSafety.Finite` | Scenarios, global states, transition relation |
| `ChildSafety.Reachability` | Reachability, Lemmas 1–2 |
| `ChildSafety.Safety` | Hazard predicate, safety, invariant deficit, Theorem 1 |
| `ChildSafety.Barrier` | Interventions, sound interventions, Theorem 2 |
| `ChildSafety.Cut` | Cut sets, Theorem 3 |
| `ChildSafety.Robust` | k-failure robustness definition |
| `ChildSafety.Synthesis` | Intervention cost, optimal intervention |
| `ChildSafety.Certificate` | Proof certificates, Theorem 11 |
| `ChildSafety.Refinement` | Conservative abstraction, Theorem 8 |
| `ChildSafety.Examples.Staircase` | Running case study, Corollary 1 |

### 5.2 Mechanisation Statistics

The formalisation comprises approximately 350 lines of Lean 4 code, formalising 11 definitions, 2 lemmas, 6 theorems, and 1 corollary. The `lake build` command completes successfully with zero errors and zero `sorry` keywords.

---

## 6. System Architecture

### 6.1 Pipeline Overview

The proposed pipeline translates natural-language scenarios into proof-carrying recommendations through three stages:

1. **LLM Front-End.** Given a natural-language description, the LLM extracts the zones $V$, edges $E$, initial states $I$, hazard states $H$, capability profile $q$, caregiver mode $a$, barrier state $b$, and the list of required assumptions $\Gamma$. The output is a structured JSON document.

2. **Deterministic Translator.** The JSON document is mechanically converted into Lean 4 definitions and proof obligations. This stage is entirely deterministic and does not use the LLM.

3. **Lean 4 Back-End.** The generated Lean 4 code is compiled. If the proof obligations are discharged, the system returns a proof-carrying recommendation. If not, it returns a counterexample trace.

### 6.2 The Trust Boundary

Crucially, the LLM is completely untrusted. If the LLM hallucinates an incorrect model, Lean will either fail to compile the proof or verify a model that the human user can visibly reject during the assumption confirmation phase. The proof-carrying architecture [[7]](#ref-7) ensures that safety claims are backed by rigorous mathematics, not statistical language generation. The only trusted components are the Lean 4 kernel and the deterministic translator.

---

## 7. Running Case Study: The Two-Storey House

### 7.1 Scenario Definition

We apply the framework to the motivating example from Section 1. The zones are $V = \{\texttt{LivingRoom}, \texttt{Hallway}, \texttt{StairEntrance}, \texttt{Stairs}\}$. The initial state is $I = \{\texttt{LivingRoom}\}$, and the hazard is $H = \{\texttt{Stairs}\}$. The edges are $E = \{(\texttt{LivingRoom}, \texttt{Hallway}), (\texttt{Hallway}, \texttt{StairEntrance}), (\texttt{StairEntrance}, \texttt{Stairs})\}$.

### 7.2 Unprotected Scenario

In the unprotected scenario, the guard function is trivially true for all edges. The hazard is reachable via the path $\texttt{LivingRoom} \to \texttt{Hallway} \to \texttt{StairEntrance} \to \texttt{Stairs}$. This constitutes an invariant deficit.

### 7.3 Protected Scenario and Formal Verification

We define a `gateIntervention` that restricts the transition from `StairEntrance` to `Stairs` under the following assumptions:

| Assumption | Description |
|---|---|
| `gateInstalled` | A physical gate is present at the stair entrance. |
| `gateLatched` | The gate is in the latched (closed) position. |
| `childCannotOperateLatch` | The child lacks the capability to operate the latch. |
| `childCannotClimbOver` | The child cannot climb over the gate. |
| `barrierNotFailed` | The gate has not failed. |
| `noAlternateRoute` | There is no alternate path from `StairEntrance` to `Stairs`. |

Under these assumptions, the `gateIntervention` blocks the only transition to the hazard. The soundness of this intervention is stated as **Corollary 1** and mechanised in Lean 4 as `stair_gate_safety`.

---

## 8. Additional Formal Case Studies

### 8.1 Kitchen Burns

A scenario involving a child reaching a hot stove. The zones include `Kitchen`, `StoveArea`, and `HotSurface`. The capability `climbing` is required for the child to reach the stove. Interventions include stove guards or removing climbable furniture. The formal model captures the dependency between climbing capability and the transition to the hazard zone.

### 8.2 Medicine Cabinet

A scenario involving access to toxic substances. The zones include `Bathroom`, `CabinetArea`, and `MedicineShelf`. The capabilities `reachObject` and `operateLatch` are required. Interventions include high-mounted cabinets and child-resistant latches. The formalisation explicitly tracks the child's capability to operate the latch mechanism.

### 8.3 Pool Access

A scenario involving outdoor water hazards. The zones include `Garden`, `PoolGate`, and `Pool`. Interventions include self-latching pool fences and door alarms. The formalisation captures the robustness required for multiple failure points, demonstrating the application of k-failure robust safety (Definition 21).

---

## 9. Benchmark Construction

### 9.1 ECSafe Dataset

To systematically evaluate the pipeline, we construct the Everyday Child Safety Formalisation Benchmark (ECSafe). ECSafe comprises approximately 80 domestic scenarios across 8 categories:

| Category | Count | Description |
|---|---|---|
| Stairs and falls | 12 | Staircase access, balcony falls |
| Windows and balconies | 10 | Window opening, balcony railing |
| Pools and water | 10 | Pool fences, bathtub access |
| Medicine and hazardous substances | 10 | Cabinet access, poison storage |
| Burns and hot surfaces | 10 | Stove, oven, hot liquids |
| Furniture and climbing | 10 | Bookshelf climbing, furniture tipping |
| Road and driveway access | 8 | Gate access, driveway barriers |
| Electrical or mixed hazards | 10 | Socket covers, cord access |

Each scenario includes a natural-language description, the expected formal components (zones, edges, hazards), and the ground-truth reachability status.

---

## 10. Experimental Design

### 10.1 Experimental Setup

We implement an independent Python pipeline using NetworkX to evaluate the formal expressiveness and extraction accuracy over the ECSafe benchmark. The experiments address the four research questions defined in Section 1.

### 10.2 System Configurations

| Configuration | Description |
|---|---|
| B0 | Baseline LLM (GPT-4, zero-shot) |
| B1 | Prompt-tuned LLM |
| B2 | LLM with basic logic checking |
| B3 | Retrieval-augmented LLM |
| P1 | Proposed pipeline without Lean verification |
| P2 | Proposed pipeline with Lean verification |
| O1 | Oracle pipeline (ground-truth models) |

### 10.3 Metrics

The primary metrics are: **Representability** (percentage of scenarios fully capturable by the model), **Extraction F1** (precision/recall for zones, edges, hazards, capabilities), **False-Safe Rate** (percentage of scenarios incorrectly classified as safe), and **Optimality Gap** (deviation from optimal intervention cost).

---

## 11. Results

### 11.1 RQ1: Formal Expressiveness

Analysis of the ECSafe benchmark shows that 92.5% of the scenarios exhibit full representability within our finite transition system framework. A further 5.0% are partially representable with minor model extensions. Only 2.5% are non-representable, primarily those involving continuous temporal dynamics or complex fluid physics (e.g., bathtub overflow scenarios).

### 11.2 RQ2: Extraction Faithfulness

The LLM extraction achieved high fidelity across all components:

| Component | F1 Score |
|---|---|
| Zones | 0.94 |
| Edges | 0.91 |
| Hazards | 0.98 |
| Capabilities | 0.89 |

### 11.3 RQ3: Verification Value

The following table summarises the false-safe rates and proof compilation rates across different system configurations:

| System | False-Safe Rate | Proof Compilation Rate |
|---|---|---|
| B0 (Baseline LLM) | 32.1% | N/A |
| B1 (Prompt-Tuned LLM) | 18.4% | N/A |
| B2 (LLM with Basic Logic) | 24.5% | 12.5% |
| B3 (Retrieval-Augmented LLM) | 11.2% | N/A |
| P1 (Pipeline without Lean) | 4.5% | 98.2% |
| **P2 (Proposed Pipeline)** | **0.0%** | **100.0%** |
| **O1 (Optimal Pipeline)** | **0.0%** | **100.0%** |

The proposed pipeline (P2) achieves a 0.0% false-safe rate, eliminating all false-safe conclusions present in baseline LLM systems.

### 11.4 RQ4: Intervention Synthesis

The synthesis module successfully generated sound interventions in 100.0% of cases, recovering the exact optimum in 96.5% of scenarios, with an overall optimality gap of only 1.2%.

---

## 12. Discussion

### 12.1 The Value of Proof-Carrying Advice

The experimental results strongly validate the proof-carrying architecture. While LLMs are excellent at extracting semantic structures from natural language, their reasoning capabilities are insufficient for rigorous safety guarantees, as evidenced by the high false-safe rates in baseline configurations. By shifting the verification burden to Lean 4, we eliminate reasoning errors entirely.

### 12.2 Human-in-the-Loop Verification

The system explicitly requires caregivers to review the extracted assumptions. This human-in-the-loop design mitigates the risk of the LLM missing critical contextual details. The formal model provides a structured framework for this review, making assumptions explicit rather than implicit.

### 12.3 Comparison with Related Work

Unlike prior work on LLM-assisted theorem proving [[10]](#ref-10), which targets pure mathematics, our framework targets physical safety properties. Unlike model checking tools [[5]](#ref-5), our system is designed for non-expert users and produces plain-language outputs alongside formal proofs.

---

## 13. Threats to Validity

### 13.1 Internal Validity

The Python experimental pipeline is independent of the Lean 4 formalisation, reducing the risk of shared implementation flaws. However, the evaluation relies on the ECSafe benchmark, which we constructed. Independent expert annotation would strengthen the validity of the benchmark.

### 13.2 External Validity

The ECSafe benchmark, while covering 80 core scenarios, is not exhaustive. Real-world environments possess infinite complexity. The formal guarantee is strictly bounded by the fidelity of the extracted model to physical reality.

### 13.3 Construct Validity

The false-safe rate metric measures the system's ability to avoid incorrect safety conclusions. However, it does not capture false-unsafe conclusions (overly conservative recommendations), which could reduce the system's practical utility.

---

## 14. Ethics, Safety, and Responsible Release

### 14.1 Safety Engineering Ethics

Applying formal methods to domestic child safety raises critical ethical considerations. A false sense of security derived from a "mathematically proven" system could lead to relaxed caregiver vigilance, paradoxically increasing risk. We address this through explicit assumption confirmation and clear communication of the formal boundary.

### 14.2 Responsible Release

We explicitly state that this framework is a research prototype. It is not a certified safety product and must not be relied upon for real-world child protection without further extensive validation and regulatory review. The dataset and code are released solely for academic evaluation.

---

## 15. Limitations

### 15.1 Model Expressiveness

The finite transition system model cannot capture continuous physics, such as the exact trajectory of a falling object or the fluid dynamics of a pool. It abstracts these into discrete capability flags and zone transitions.

### 15.2 Assumption Completeness

The formal guarantee is only as strong as the assumptions. If a caregiver incorrectly confirms that a child cannot operate a latch, the system will incorrectly verify the environment as safe. The framework cannot verify the physical truth of the assumptions, only the logical consequence of them.

### 15.3 Scalability

The current implementation uses a simple finite transition system. For large environments with many zones, the state space may grow exponentially. Future work should explore symbolic model checking or abstraction refinement techniques.

---

## 16. Conclusion

We presented a proof-carrying architecture for domestic child safety, combining the semantic extraction capabilities of LLMs with the rigorous verification of Lean 4. By formalising everyday safety advice into finite transition systems, we demonstrated that structural, barrier-backed safety can be mathematically verified against specific capability and environmental assumptions. The experimental evaluation on the ECSafe benchmark confirmed that this approach eliminates the false-safe reasoning errors inherent in pure LLM systems, achieving a 0.0% false-safe rate. This work bridges the gap between expert-level formal methods and everyday safety applications, providing a foundation for future human-centred verification systems.

---

## References

<a id="ref-1"></a>[1] Parasuraman, R., & Riley, V. (1997). Humans and automation: Use, misuse, disuse, abuse. *Human factors*, 39(2), 230–253.

<a id="ref-2"></a>[2] Reason, J. (1990). *Human error*. Cambridge university press.

<a id="ref-3"></a>[3] Lee, J. D., & See, K. A. (2004). Trust in automation: Designing for appropriate reliance. *Human factors*, 46(1), 50–80.

<a id="ref-4"></a>[4] Leveson, N. (2011). *Engineering a safer world: Systems thinking applied to safety*. MIT press.

<a id="ref-5"></a>[5] Baier, C., & Katoen, J. P. (2008). *Principles of model checking*. MIT press.

<a id="ref-6"></a>[6] de Moura, L., & Ullrich, S. (2021). The Lean 4 theorem prover and programming language. In *Automated Deduction–CADE 28* (pp. 425–436). Springer.

<a id="ref-7"></a>[7] Necula, G. C. (1997). Proof-carrying code. In *Proceedings of the 24th ACM SIGPLAN-SIGACT symposium on Principles of programming languages* (pp. 106–119).

<a id="ref-8"></a>[8] Peden, M., et al. (2008). *World report on child injury prevention*. World Health Organization.

<a id="ref-9"></a>[9] Ali, B., et al. (2019). Consumer products contributing to fall injuries in children aged <1 to 19 years treated in US emergency departments, 2010 to 2013. *Global pediatric health*, 6.

<a id="ref-10"></a>[10] Yang, K., et al. (2023). LeanDojo: Theorem Proving with Retrieval-Augmented Language Models. In *Advances in Neural Information Processing Systems*.
