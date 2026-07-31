# Problem E — Post-Elo construction and obstruction work order

**Worker:** local research agent  
**Authored:** 2026-07-30  
**Repository:** `mattrobball/unirational`  
**Pinned base:** `865b262b4242769577b79c04dbd9f500aa8613f6`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Status at issue:** **OPEN**

---

## 0. Mission and theorem boundary

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
\subset \mathbf P(W)\simeq\mathbf P^4.
\]

The accepted reduction remains

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

The completed Elo campaign changes the active program as follows.

1. **Path G is now constructive.** Global states meet the generically surjective nonlinear-lifting open at \((1,7)\), \((1,13)\), and \((3,19)\); the free polar operator is generically surjective for every normal order; and the higher polar recursion is formally unobstructed on a common open. The unresolved issue is finite global lifting to an actual homogeneous polynomial covariant.
2. **Path F remains a terminal point criterion.** The conic/intersection-algebra bridge is exact, but existence is undecided. The next useful object is the restricted \(E[3]\)-class, not another unstructured conic solve.
3. **The target-branch route now owns an exact irreducible degree-43 equation.** The missing step is normalization/conductor geometry.
4. **Path A is computationally stopped in its current form.** After all lossless collapses, the Krylov problem still has 52 nonlinear variables and high-degree determinantal equations. No memory increase changes that. Only a new low-degree structural theorem can revive it.
5. **The auxiliary Morita idempotent is not a Klein point.** Any direct Fano route must work on the twisted Fano section itself.

### Positive proof standard

A positive resolution requires either:

- a rational point on a generic versal twist of the Klein cubic over the correct invariant field; or
- an explicit nonzero homogeneous landing self-covariant \(p:W\to W\),

with exact verification of:

1. field of definition;
2. landing in the correct target;
3. equivariance;
4. primitivity/common-domain control;
5. generic rank and dominance;
6. conversion to \(G\)-unirationality.

A formal normal lift, point on an auxiliary Morita space, modular solution, or point on an unbridged Fano partner is insufficient.

### Negative proof standard

A negative resolution must prove either:

- a generic versal Klein twist has no rational point; or
- every nonzero homogeneous landing self-covariant is impossible in characteristic zero.

A failed construction, finite degree exclusion, modular null result, one family obstruction, or unresolved valuation is insufficient.

---

## 1. Authoritative inputs

Treat the following as accepted and do not rederive except for regression or theorem-boundary repair:

```text
problems/E-klein-cubic/RESOLUTION.md
problems/E-klein-cubic/CURRENT_PATHS.md
problems/E-klein-cubic/HANDOFF.md

problems/E-klein-cubic/certificates/global_lifting_decision/*
problems/E-klein-cubic/certificates/fixed_frame_arithmetic/*
problems/E-klein-cubic/certificates/schur_krylov/*
problems/E-klein-cubic/certificates/target_branch_global/*
problems/E-klein-cubic/certificates/pfaffian_point/*
problems/E-klein-cubic/certificates/strata/*
problems/E-klein-cubic/certificates/transitions/*
```

The exact repository strata packet is authoritative. In particular, type-II \(V_4\)-points are triple intersections of the three local fixed elliptics.

---

# Path G — finite global lifting to a polynomial covariant

## G0. Objective

Convert the constructive formal-normal data into an actual homogeneous polynomial landing self-covariant, or identify a finite terminal obstruction.

This is the primary path.

## G1. Finite-truncation theorem

For a homogeneous degree-\(d\) polynomial map \(p\), prove precisely that the normal expansion along one involution plus-plane is finite and that

\[
F(p)\in I_{Z_t}^{\,3d+1}
\quad\Longrightarrow\quad
F(p)=0.
\]

Required consequences:

1. the lifting tower terminates by normal order \(3d\);
2. there is no infinite Artin-approximation problem at fixed \(d\);
3. the true algebraization problem is a finite terminal system.

### Deliverables

```text
certificates/global_finite_lifting/FINITE_TRUNCATION_THEOREM.md
certificates/global_finite_lifting/verify_finite_truncation.py
```

### Gate G1

- **PASS:** finite terminal order certified; proceed to G2.
- **FAIL:** identify the precise grading mistake before any further computation.

## G2. Complete degree-7 tower

At \((m,d)=(1,7)\), compute every nonautomatic lifting stage through the terminal order.

Tasks:

1. construct every global correction module;
2. retain the repaired category, source-line coefficient coupling, triple-line equalizers, point kernels, marked elliptic data, and irrelevant torsion;
3. determine the first stage at which no further polynomial correction is available;
4. compute the terminal residual exactly;
5. decompose the residual by stabilizer and \(G\)-representation type;
6. reconcile with the already accepted direct exclusion in degree 7.

The result must explain **why early formal smoothness does not produce a degree-7 covariant**.

### Exits

- **G7-OBSTRUCTION:** terminal residual nonzero for every global state.
- **G7-CANDIDATE:** a full degree-7 polynomial landing candidate appears; verify immediately against the accepted degree-7 exclusion and locate the inconsistency.
- **G7-INTERFACE:** exact terminal matrix/module produced but support undecided.

## G3. Compare degrees 13 and 19

Run the complete finite tower at:

\[
(m,d)=(1,13),\qquad (3,19).
\]

The aim is to classify terminal behavior, not merely repeat calculations.

Record whether the terminal obstruction depends on:

- \(d\bmod N\);
- \(m\);
- \(d-6m\);
- source-line ledger;
- residual \(S_3\)-type;
- another finite combinatorial invariant.

### Decision exits

- **G-PERIODIC-NEGATIVE:** a proved periodic terminal obstruction covers all degrees/families.
- **G-POLYNOMIAL:** one finite tower closes and yields an actual polynomial covariant.
- **G-PATTERN:** a finite congruence classification is conjectured with exact supporting data but not proved.

## G4. Global correction sheaves

For every stage used in G2–G3, present the global correction map through the exact architecture

```text
plane normalization
  -> triple-line equalizer
  -> residual point kernel
```

and prove either surjectivity or compute its cokernel.

No local free-module surjectivity may be promoted to global solvability without this step.

## G5. Final candidate audit

For any completed polynomial candidate, verify:

1. exact \(G\)-equivariance;
2. \(F(p)=0\);
3. no common factor;
4. nonzero projective map;
5. Jacobian rank \(4\) generically;
6. dominance and the accepted exhaustiveness conversion.

### Required artifacts

```text
certificates/global_finite_lifting/degree7/*
certificates/global_finite_lifting/degree13/*
certificates/global_finite_lifting/degree19/*
certificates/global_finite_lifting/TERMINAL_PATTERN.md
certificates/global_finite_lifting/SEAL.json
```

---

# Path F — restricted \(E[3]\)-class over \(K_{\mathrm{proj}}\)

## F0. Objective

Decide whether the explicit genus-one torsor class becomes trivial over \(K_{\mathrm{proj}}\).

Let

\[
\xi\in H^1(F,E[3]),\qquad
\alpha_R=w_1(\xi)\in R^\times/R^{\times3}.
\]

The conic scheme remains a positive reconstruction interface. The immediate binary question is whether

\[
\operatorname{res}_{K_{\mathrm{proj}}/F}(\xi)=0.
\]

## F1. Restricted étale algebra

Construct exactly

\[
R_K=R\otimes_F K_{\mathrm{proj}}.
\]

Determine:

1. factorization into fields/étale factors;
2. Galois-module structure;
3. the image of the explicit representative \(\alpha_R\);
4. compatibility with the pinned CFOSS \(w_1\)-convention.

### Deliverables

```text
certificates/restricted_e3/RESTRICTED_ETALE_ALGEBRA.md
certificates/restricted_e3/restricted_algebra.json
certificates/restricted_e3/verify_restricted_algebra.py
```

## F2. Divisor cube test

Choose a normal integral model on which every factor of \(R_K\) and \(\alpha_R\) is represented integrally.

Compute the divisor vector

\[
(v_E(\alpha_R))_E\pmod 3.
\]

### Decision exits

- **F-NONCUBE:** one valuation is nonzero modulo 3; restricted class is nontrivial.
- **F-DIVISOR-CUBE:** all valuations vanish modulo 3; proceed to the unit test.

If all valuations are divisible by 3, decide whether the residual unit is a cube. Use the algebraically closed constant field and the exact unit group of the chosen normal model; do not assume divisor-cube implies global cube without the unit argument.

## F3. Group-cohomological restriction

Independently identify the Galois closure and subgroup corresponding to \(K_{\mathrm{proj}}\), and compute

\[
H^1(\Gamma,E[3])
\longrightarrow
H^1(\Gamma_K,E[3])
\]

on the explicit class \(\xi\).

The divisor and cohomological computations must agree.

## F4. Consequences

- If the restricted class vanishes, reconstruct a point or conic and verify the sealed bridge to the Klein twist.
- If it remains nonzero, record that the fixed-frame genus-one torsor stays pointless over \(K_{\mathrm{proj}}\). State carefully whether this alone closes the generic Klein-twist point problem or only this fixed-frame criterion.

### Required artifacts

```text
certificates/restricted_e3/CUBE_TEST.md
certificates/restricted_e3/divisor_vector_mod3.json
certificates/restricted_e3/group_cohomology.json
certificates/restricted_e3/DECISION.md
certificates/restricted_e3/SEAL.json
```

---

# Path T — normalize the target branch through the fold algebra

## T0. Objective

Avoid direct normalization of the 37,992-term degree-43 hypersurface by proving that the finite fold algebra is its normalization on the simple-fold open.

Let

\[
B=\mathbf Q[A,B,Y,Z]/(H_{43})
\]

and define, with all accepted simple-fold gates inverted,

\[
S=B[u]/(P,P_u).
\]

## T1. Finite birationality

Prove:

1. \(S\) is finite over \(B\);
2. the generic rank is one;
3. \(\operatorname{Frac}(S)=\operatorname{Frac}(B)\);
4. the selected component corresponds to the multiplicity-one branch.

Use the exact degree-43 factor, accepted line specialization, and simple-root gates. Do not re-eliminate \(u\).

### Gate T1

- **T-BIRATIONAL:** all four claims proved; proceed.
- **T-MULTIRANK:** generic rank exceeds one; identify the correct idempotent/component in the fold algebra.
- **T-STOP:** finite birationality cannot be established from installed data.

## T2. Normality by Serre's criterion

Prove \(S_2\), preferably from its complete-intersection or Cohen–Macaulay presentation.

Prove \(R_1\) by computing the singular locus of \(S\) and showing codimension at least two.

### Exit

- **T-NORMAL:** \(S\) is the normalization on the simple-fold open.
- **T-NONNORMAL:** compute the further normalization defect and conductor locally.

## T3. Conductor and discriminant pullback

Once normality is settled:

1. compute
   \[
   \mathfrak c=\operatorname{Ann}_B(S/B);
   \]
2. pull back the cubic discriminant;
3. factor it in codimension one;
4. compute every contact order modulo 3.

## T4. Local and global class-group ledger

Compute only the 3-primary defect:

\[
\left(\operatorname{Cl}(T_S)/\operatorname{Pic}(T_S)\right)[3].
\]

Include codimension-three punctured Picard groups or prove parafactoriality on the residual locus.

### Decision exits

- **T-NEGATIVE:** 3-primary defect vanishes and index 3 survives on the residue branch.
- **T-DANGEROUS:** exhibit an explicit 3-primary class.
- **T-OPEN:** normalization succeeds but class-group assembly remains undecided.

### Required artifacts

```text
certificates/fold_normalization/FINITE_BIRATIONAL.md
certificates/fold_normalization/SERRE_NORMALITY.md
certificates/fold_normalization/conductor.*
certificates/fold_normalization/discriminant_contacts_mod3.*
certificates/fold_normalization/CLASS_GROUP_MOD3.md
certificates/fold_normalization/SEAL.json
```

---

# Path A — low-degree Krylov-growth theorem only

## A0. Scope

The direct 52-variable high-degree elimination is retired. No memory authorization may be used on it.

A solution of the Schur–Krylov incidence satisfies

\[
\lambda V_Z\subseteq U_\tau=\langle1,\tau,\ldots,\tau^{19}\rangle.
\]

Define

\[
K_s(\tau,\lambda V_Z)
=\sum_{j=0}^{s}\tau^j(\lambda V_Z).
\]

Then

\[
\dim K_s\le20+s.
\]

The only authorized continuation is to exploit these low-order growth conditions.

## A1. Low-order block-Krylov equations

For \(s=4,5,6\), construct rank equations for

\[
[\lambda V_Z,\tau\lambda V_Z,\ldots,\tau^s\lambda V_Z].
\]

The entries have degree at most \(s\) in \(\tau\).

## A2. Eliminate \(\lambda\) structurally

Use block-Wiedemann, minimal approximant bases, displacement rank, or trace-pairing Hankel matrices. Do not enumerate high-degree maximal minors.

## A3. Equivalence theorem

Prove or refute:

> the low-growth conditions through some finite \(s\) are equivalent to containment in a 20-dimensional cyclic Krylov space.

If only necessary, quantify the gap and state whether the resulting locus is still computationally useful.

## A4. Determinantal-height alternative

Attempt a 1-genericity/Buchsbaum–Rim theorem showing that the full rank-defect locus has codimension greater than 52.

### Stopping rule

If neither A3 nor A4 yields a decisive structural theorem, retire Path A. No further elimination, degree sweep, or memory increase is permitted.

### Deliverables

```text
certificates/schur_krylov_growth/LOW_GROWTH.md
certificates/schur_krylov_growth/approximant_system.*
certificates/schur_krylov_growth/EQUIVALENCE_OR_GAP.md
certificates/schur_krylov_growth/HEIGHT_THEOREM.md
certificates/schur_krylov_growth/SEAL.json
```

---

# Path C — direct twisted Fano section

## C0. Objective

Construct and study the twisted Fano section itself, without passing through the auxiliary Morita-idempotent space.

## C1. Descend rank-one/Plücker equations

In the installed 15-dimensional symmetric basis:

1. write the rank-one Hermitian/Plücker cone equations;
2. restrict them to the exact 10-plane defining the twisted Fano section;
3. verify after a splitting extension that the result is the classical smooth \(F_{14}\).

## C2. Structural geometry

Search for:

- rational fibrations;
- conic bundles;
- odd-degree multisections;
- homogeneous-space descriptions;
- tractable cohomological obstructions.

Do not launch a raw coordinate solve until this audit is complete.

## C3. Point implication audit

Reconfirm the exact implication

\[
F_{14,T}(K_{\mathrm{proj}})\neq\varnothing
\Longrightarrow
C_{\mathrm{gen}}(K_{\mathrm{proj}})\neq\varnothing.
\]

Reject any stable-factor argument using a nonsplit Severi–Brauer factor.

### Deliverables

```text
certificates/direct_fano/DESCENDED_PLUCKER.md
certificates/direct_fano/restricted_equations.*
certificates/direct_fano/SPLIT_FIBRE_VERIFY.md
certificates/direct_fano/STRUCTURAL_GEOMETRY.md
certificates/direct_fano/SEAL.json
```

---

## 2. Ranking and dispatch order

| Rank | Path | Immediate target |
|---:|---|---|
| **1** | G — finite global lifting | terminal degree-cap obstruction or actual polynomial covariant |
| **2** | F — restricted \(E[3]\)-class | decide whether \(\xi|_{K_{\mathrm{proj}}}=0\) |
| **3** | T — fold algebra normalization | prove finite birational normality and compute conductor |
| **4** | A — low-degree Krylov growth | replace the impossible elimination by a theorem |
| **5** | C — direct Fano section | install the actual geometric target and audit its structure |

KLS minimality/conductor, CM-polarized Hodge, and proper-subgroup twists remain reserve tracks only. They receive no primary compute allocation under this order.

---

## 3. First dispatch

Run exactly three tasks in parallel.

### Dispatch G

1. Prove G1 finite truncation.
2. Build the complete degree-7 tower.
3. Return the first terminal obstruction or a complete polynomial candidate.

### Dispatch F

1. Construct \(R\otimes_FK_{\mathrm{proj}}\).
2. Emit the exact divisor-cube and group-cohomology plans.
3. Do not start a large conic elimination.

### Dispatch T

1. Prove or refute finite birationality of \(B\to S\).
2. Emit a Serre-normality computation plan with exact dimensions and resource estimates.

Path A receives only a theorem-design task after the first director gate. Path C begins only after its equation-descent interface is scoped below 8 GiB.

---

## 4. Director gate

After the first dispatch, select exactly one:

1. **G terminal obstruction found:** prioritize proving its periodic/all-degree form.
2. **G polynomial candidate found:** stop all other routes and verify it end to end.
3. **F restricted class decided:** reconstruct a point or assemble the exact negative consequence.
4. **T finite birational normalization succeeds:** prioritize conductor and mod-3 class groups.
5. **All three remain open:** authorize A1–A3 and C1 only; no large generic solve.

No route may be promoted because its computation is largest.

---

## 5. Software and resource policy

Use freely available software only:

```text
GAP
Macaulay2
Singular / Singular.jl
OSCAR / Nemo / Hecke
Groebner.jl
PARI/GP
python-flint
msolve
Normaliz
custom sparse exact linear algebra
```

### Memory rules

- exploratory ceiling: **8 GiB RSS**;
- structurally justified sealed job: up to **96 GiB RSS** after director approval;
- no concurrent memory-saturating jobs;
- stream sparse rows and transformation circuits.

Before any job expected to exceed 8 GiB, emit:

```text
matrix/module dimensions
term count
sparse memory floor
dense memory floor
certificate format
checkpoint plan
independent verifier design
```

Path A's retired 52-variable high-degree elimination is not eligible for a memory exception.

### Characteristic-zero discipline

Finite fields are discovery, pivot selection, or support design only unless accompanied by a written characteristic-zero lifting argument.

Every decisive producer must have an independent verifier that does not import it.

---

## 6. Universal house rules

1. Do not call a formal lift a covariant.
2. Do not invoke Artin approximation before proving the finite-truncation theorem at fixed degree.
3. Do not infer global solvability from local free-module surjectivity.
4. Do not restart the Path A high-degree elimination.
5. Do not solve the conic scheme before testing the restricted \(E[3]\)-class.
6. Do not normalize the degree-43 hypersurface directly before testing the fold algebra as normalization.
7. Do not use the auxiliary Morita idempotent as a Klein point.
8. Do not compute a full class group when only its 3-primary quotient is relevant.
9. Do not advertise modular ranks or points as characteristic-zero conclusions.
10. Stop and certify any exact obstruction independent of all admissible corrections.
11. Every artifact must state what is proved, what is not proved, and its headline consequence.
12. Update route ranking only at a director gate.

---

## 7. Required status updates

After each accepted gate, update:

```text
problems/E-klein-cubic/HANDOFF.md
problems/E-klein-cubic/CURRENT_PATHS.md
problems/E-klein-cubic/RESOLUTION.md
problems/E-klein-cubic/SPEC.md
```

Each update must include:

1. exact commit and artifact hashes;
2. theorem boundary;
3. replay commands;
4. director decision;
5. revised ranking;
6. explicit statement that Problem E remains open unless a final positive or negative proof standard has been met.
