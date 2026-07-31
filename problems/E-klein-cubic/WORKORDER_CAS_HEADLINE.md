# Problem E — CAS-Only Work Order for Headline Resolution

**Repository:** `mattrobball/unirational`
**Pinned base:** `3c9b385f5bba0fc29845e9b9fd9bfa067ed8b0bc`
**Problem:** `PSL(2,11)`-unirationality of the Klein cubic threefold
**Worker role:** exact computer algebra only
**Headline status at issue:** OPEN

---

## 0. Scope and theorem boundary

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
\subset \mathbf P(W)\simeq \mathbf P^4 .
\]

Accepted reduction:

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3 .
\]

This order is for the CAS worker only. The worker must produce exact
algebraic data, certificates, and independently replayable verifiers. **The
worker must not promote a computation to the headline unless the
corresponding analytic bridge below has already been proved and every
hypothesis is checked.**

### 0.1 Accepted analytic closure bridges

| Code | Analytic implication | Headline effect |
|---|---|---|
| `BR-T-NEG` | A residue-degree-one versal target branch whose cubic retains index `3` gives a pointless versal Klein twist | negative |
| `BR-G-NEG` | Exclusion of every nonzero homogeneous landing self-covariant, with the accepted exhaustive reduction, gives `ed_C(G)=4` | negative |
| `BR-COV-POS` | One exact nonzero primitive landing self-covariant of generic Jacobian rank `4` gives a dominant `G`-map and `G`-unirationality | positive |
| `BR-FANO-POS` | A `K_proj`-point of the twisted Fano section `F_{14,T}`, equivalently a common isotropic right `D`-line for the five descended Hermitian forms, gives a point of the generic Klein twist | positive |
| `BR-SCHUR19-POS` | A qualifying degree-19 curve through the degree-55 Schur point leaves a degree-2 residual cycle; the audited residual-line argument gives a point of the generic Schur twist and the headline | positive |
| `BR-SUBGROUP-NEG` | A pointless generic twist for any subgroup `H <= G` disproves `G`-unirationality | negative |

**Not headline bridges:** emptiness of the auxiliary Morita-projector cubic;
triviality or nontriviality of the fixed-frame auxiliary genus-one torsor
without a separate bridge to `F_{14,T}` or the generic Klein twist; emptiness
of the degree-19 Schur rescue construction; a finite-degree covariant
exclusion; a formal state, formal jet, or formal boundary map; emptiness of
the twisted Fano section, unless an additional theorem equates it with
pointlessness of the Klein twist.

### 0.2 Worker restrictions

The worker must **not**:

1. perform a raw 43-variable or 52-variable elimination;
2. infer characteristic-zero statements from modular ranks without a written
   lifting argument;
3. treat a random finite-field point or null result as a theorem;
4. replace normalization by normality of a known nonnormal intermediate
   algebra;
5. infer an all-degree theorem from finitely many degrees;
6. call a formal state a covariant;
7. edit `HANDOFF.md`, `CURRENT_PATHS.md`, `RESOLUTION.md`, or `SPEC.md`
   before a director gate;
8. use Magma as a dependency.

Preferred software: Macaulay2, Singular/Singular.jl, OSCAR/Nemo/Hecke,
Groebner.jl, msolve, GAP, PARI/GP, python-flint, Normaliz, custom exact
sparse linear algebra.

---

## 1. Global execution order

| Priority | Route | First CAS target | Possible complete exit |
|---:|---|---|---|
| **1** | `T` — normalized target branch | height-one normalization and conductor | `T-NEGATIVE` |
| **2** | `G` — universal terminal residual | finite semigroup/module presentation of the cutoff residual | `G-NEGATIVE` or `G-POLYNOMIAL` |
| **3** | `P25` — degree-25 support | complete finite tower, then sparse projective support | `P25-POSITIVE` |
| **4** | `C` — direct twisted Fano section | executable quaternion/Plücker model | `C-POSITIVE` |
| **5** | `S19` — marked degree-19 Schur curve | universal 55-point ideal and marked Quot scheme | `S19-POSITIVE` |
| **6** | `KLS` — minimality/conductor | conditional finite tables after analyst supplies theorem | `KLS-NEGATIVE` |
| **7** | `H` — proper-subgroup twists | one maximal `A_5` generic twist | `H-NEGATIVE` |

The first director gate occurs after **T3.2, G4.2, and P25.1**. Do not start
memory-heavy work on lower routes before that gate.

---

## 2. Phase 0 — freeze and replay accepted inputs

**CAS-0.1 — baseline hash manifest.** Create

```text
certificates/headline_cas_order/BASELINE.json
certificates/headline_cas_order/SHA256SUMS
```

recording hashes for the exact inputs consumed by every route, including at
least:

```text
certificates/fold_normalization/*
certificates/target_branch_global/H_factor/*
certificates/global_finite_lifting/*
certificates/global_transition/*
certificates/global_lifting_decision/*
certificates/border_support/*
certificates/pfaffian_point/*
certificates/schur_degree19/*
certificates/schur_krylov/*
certificates/exact_weil_check.py
```

**CAS-0.2 — independent replay.** Replay the accepted independent verifiers.
Record only pass/fail, versions, and content hashes; **do not include
wall-clock time in sealed payloads.**

Required terminal marker: `HEADLINE_CAS_BASELINE_ACCEPT`.

**STOP rule.** If any accepted verifier fails, stop all dependent routes and
issue `BASELINE-FAIL` with the smallest inconsistent artifact set.

---

## 3. Route T — normalize the multiplicity-one branch, decide the 3-primary defect

### 3.0 Accepted input

\[
R=\mathbf Q[A,B,Y,Z],\qquad B=R/(H_{43}),\qquad
S=\left(B[u]/(P,P_u)\right)[\Sigma^{-1}]
\]

with `H_43` the sealed irreducible 37,992-term branch equation, on the
accepted simple-fold open. The repository proves: `S` is finite birational
over `B`; `S` is a three-dimensional complete intersection satisfying `S_2`;
`S` is **not** normal; its singular locus is a divisor supported by

```text
I_sing = (H, P, P_u, P_A, P_B, P_Y, P_Z)
```

on the simple-fold open. The analytic route closes negatively if the
normalized cubic incidence has no 3-primary non-Cartier defect, so horizontal
divisor degrees remain `3Z`.

### T3.1 — decompose the divisorial singular locus

Compute the height-one components of the singular divisor of `S`, **without a
full Gröbner basis of the degree-43 hypersurface.** Method sequence:

1. work in the fold presentation in `A,B,Y,Z,u`;
2. saturate by the simple-fold gates `Sigma`;
3. use modular equidimensional decomposition and generic linear sections to
   discover component degrees and multiplicities;
4. reconstruct component equations over `Q`;
5. verify each reconstructed component by exact ideal membership and
   independent holdout primes;
6. prove exhaustiveness by matching dimension, degree of generic
   two-hyperplane sections, associated-prime multiplicities, and the accepted
   total singular-section degree.

For each component `D_i` record: prime/radical ideal; dimension; degree;
multiplicity in the singular divisor; generic gate values; field of
definition; generic Jacobian rank.

Deliverables under `certificates/fold_normalization_t3/`:
`SINGULAR_DIVISOR_COMPONENTS.md`, `components.json`, `components/*.tsv`,
`produce_components.py`, `verify_components.py`.

Decision: `T3.1-PASS` (exhaustive height-one list) or `T3.1-STOP` (emit exact
bottleneck and resource floor).

### T3.2 — generic local normalization on every `D_i`

For each generic point `eta_i` of a divisorial singular component:

1. form the one-dimensional local domain transverse to `D_i` (localize at
   `eta_i`; quotient by two independent generic parameters along `D_i`, or
   work over `k(D_i)` with one transverse variable);
2. compute its integral closure;
3. determine number of analytic branches, ramification indices, residue
   extensions, conductor exponent, delta invariant, and local class group
   torsion — **especially its 3-primary part**;
4. identify an exact local normal form where possible: `xy`, `xy - pi^n`,
   `y^2 - x^m`, or another explicit finite model;
5. verify the local model by mutually inverse completed-local-ring maps
   through a certified finite jet plus a determinacy bound, or by an exact
   integral-basis certificate.

Preferred tools: Singular `normalization`/`libnormal`, OSCAR
`integral_closure`, Macaulay2 `integralClosure`, PARI/GP for function-field
factorization.

Deliverables: `LOCAL_NORMALIZATION.md`, `local_models.json`,
`integral_bases/*`, `verify_local_models.py`.

**Director gate T-A.** Every height-one defect explicitly normalized with
torsion prime to 3 → prioritize T3.3–T4. A height-one 3-primary defect found
→ record the exact dangerous class and stop the negative claim. Local
extensions too complicated → demote Route T.

### T3.3 — global normalization and conductor (after T3.2-PASS)

Adjoin the local integral generators, `S~ = S[theta_1,...,theta_r]`. Verify
finiteness over `S`, equality of fraction fields, normality by `R_1 + S_2` or
an independent integral-closure check, and agreement with every local
integral basis from T3.2. Compute the conductor
`c = Ann_S(S~/S)` and decompose it into height-one and residual
higher-codimension strata.

Deliverables: `GLOBAL_NORMALIZATION.md`, `normalization_algebra.json`,
`conductor_generators.tsv`, `conductor_decomposition.json`,
`verify_normalization.py`.

### T3.4 — discriminant pullback and contacts mod 3

On `Spec S~`: pull back the fixed-frame cubic discriminant; factor it at
every height-one prime; compute `m_E = v_E(Delta_cub) mod 3`; construct the
local cubic-incidence model for each contact component; determine local
divisor-class torsion (`xy = pi^n` → `Z/n`; nonnormal crossings → normalize
and compute the conductor contribution; higher models → exact 3-primary local
class group).

Deliverables: `DISCRIMINANT_CONTACTS_MOD3.md`,
`discriminant_factorization.json`, `contact_valuations.json`,
`local_class_groups.json`.

### T4 — codimension-three Picard audit and global 3-primary assembly

Compute the residual singular locus of the normalized cubic incidence after
removing codimension-two contact strata. Prove one of: residual codimension
`>= 4`; lci parafactoriality applies; every punctured local Picard group in
codimension 3 has exponent prime to 3. Assemble the local-to-global exact
sequence for `(Cl/Pic)[3]` and output the horizontal divisor-degree subgroup.

Exits: **`T-NEGATIVE`** (`(Cl/Pic)[3] = 0`, `deg_horiz = 3Z`; consumed by
`BR-T-NEG`); **`T-POSITIVE-ESCAPE`** (explicit horizontal divisor of degree 1
or 2 → hand to analyst); **`T-DANGEROUS-3`** (explicit nonzero 3-primary
defect; negative route fails at this branch); **`T-UNDECIDED`** (exact
remaining local ring named).

---

## 4. Route G — universal terminal-residual module

### 4.0 Accepted input

The repository proves: fixed-degree lifting terminates by order `3d`; the
first non-isolable order is `N_star = d + 2m + 1`; exact terminal residuals
are nonzero in the sample towers `(m,d) = (1,7), (1,13), (3,19)`; early global
states meet the generically surjective polar open; **no all-degree
nonvanishing theorem exists.**

### G4.1 — symbolic free-fibre terminal formula

For each accepted Level-1 family — `based_minus_lines_odd_m`,
`residual_e1_swap_both`, `residual_e_ge7_generic_swap_both` — derive the
residual at `N_star = d + 2m + 1` **symbolically**:

1. implement the full polar recursion with symbolic indices `(m,d)`, not a
   fixed-degree tensor;
2. express coefficients via binomial/falling-factorial functions and the
   finite basis of `ker L_1`;
3. compute exact towers on a grid sufficient to interpolate candidate
   formulas: `1 <= m <= 11`, `m <= d <= 6m + 25`, respecting each family's
   parity and source-line ledger;
4. prove the candidate recurrence computationally by an exact polynomial
   identity in the symbolic coefficient ring, or by recurrence verification
   plus a certified order bound;
5. decompose the terminal residual into residual `C_3/S_3` characters.

Deliverables under `certificates/global_terminal_module/`:
`FREE_TERMINAL_FORMULA.md`, `free_terminal_formula.json`,
`recurrence_certificate.json`, `produce_free_formula.py`,
`verify_free_formula.py`.

**STOP rule.** A numerical pattern over many bidegrees is `G-PATTERN`, not a
theorem. Do not proceed to a headline claim without a symbolic identity or a
finite recurrence proof.

### G4.2 — global terminal map as a finitely presented module

Construct `Theta^fam_{m,d} : G^fam_{m,d} -> Q^fam_{m,d}` at the cutoff order,
retaining plane normalization; `V_4` triple-line equalizers; residual point
kernels; `C_3, A_4, C_6, D_10, D_12` character blocks; source-line
coefficient coupling; finite irrelevant torsion; and the repaired distinction
among source, normal, and target copies of `P(E_-)`.

Encode all `(m,d)` simultaneously over a semigroup algebra and compute: a
Hilbert basis for admissible `(m, d, ledger)`; a finite presentation of the
source and target Rees modules; the matrix of `Theta` over that finite base;
and specialization maps recovering the existing degree 7, 13, 19 packets.

Deliverables: `GLOBAL_TERMINAL_MODULE.md`, `semigroup_generators.json`,
`source_presentation.*`, `target_presentation.*`, `terminal_matrix.*`,
`regression_7_13_19.json`.

**Director gate G-A.** No finite semigroup/module presentation with the
current gradings → report the exact obstruction; **do not run a degree
ladder.** Finite presentation exists → proceed to G4.3.

### G4.3 — projective zero support of the universal terminal map

Decide whether `(Theta^fam)^{-1}(0)` has projective support on the admissible
open, using in order: character-block rank and unit-minor tests;
annihilator/Fitting ideals of the cokernel or residual module; saturation by
irrelevant ideals, nonzero leading-jet gates, exact-order gates, and
`swap_both` open conditions; Normaliz/semigroup reduction; sparse Gröbner
**only** after reduction to finite Hilbert-basis charts.

Exits: **`G-NEGATIVE`** (every family's universal projective zero support
empty → `BR-G-NEG`); **`G-CANDIDATE`** (exact projective point survives →
specialize to finite `(m,d)`, complete all remaining correction stages,
reconstruct a polynomial); **`G-UNDECIDED`** (smallest unresolved chart and
matrix dimensions).

### G4.4 — candidate reconstruction (only after `G-CANDIDATE`)

Reconstruct `p in Hom(Sym^d W, W)^G` and verify exactly: `F(p) = 0`;
`p != 0`; `gcd(p_0,...,p_4) = 1`; Jacobian generic rank `= 4`; all
repaired-category restrictions; source-line ledger.

Deliverables: `candidate_covariant.*`, `CANDIDATE_VERIFICATION.md`.
Exit `G-POLYNOMIAL` is consumed by `BR-COV-POS`.

---

## 5. Route P25 — decide the existing finite degree-25 support

Bounded; can close the headline **only positively**.

### P25.1 — complete finite Path G tower at `(m,d) = (1,25)`

Before any border-module saturation: run the complete finite polar/global
tower through order 75; treat `based_minus_lines_odd_m` and
`residual_e_ge7_generic_swap_both` separately; compute the first non-isolable
residual at `N_star = 25 + 2 + 1 = 28`; decide its zero locus on the exact
global state space.

Exits: `P25-TOWER-EMPTY` (both families killed — a degree-25 exclusion only)
or `P25-TOWER-SURVIVES` (pass exact survivor equations to P25.2).

### P25.2 — lift the seven based rows to characteristic zero

The current seven rows are known on the split `p = 67` fibre. Compute them
exactly over `Q(zeta_11)` or `Q` with: exact basis changes `Q (+) K`; exact
restriction to a representative minus-line; exact residual image rank; and a
DVR/rank-preservation certificate comparing with the stored modular rows.

Deliverables under `certificates/degree25_support_char0/`:
`translation_char0.json`, `seven_rows.tsv`, `verify_translation.py`.

### P25.3 — full `T_i`-stable restricted module

With `N' = N + <L_0,...,L_6>` for the based branch (and the appropriate
tower-survivor equations for the generic branch), compute the stable closure
incrementally: degree-by-degree sparse multiplication by the six `T_i`;
neighbor/commutator closure; row-reduced checkpoint bases; exact hashes for
every streamed block. **Do not build a dense global Macaulay matrix.**

### P25.4 — projective support

Compute `Ann(F/N')` or `Fitt_0(F/N')`, then saturate by the irrelevant ideal
and all open gates. Decide: projective support empty; positive-dimensional;
or zero-dimensional with explicit residue fields. For nonempty support:
reconstruct an exact point; recover all 43 coefficients; verify the full
rank-842 cubic system; run the G4.4 covariant checks. Exit `P25-POSITIVE` is
consumed by `BR-COV-POS`.

**Resource rule.** A structured run up to 64 GiB RSS is authorized only after
a preflight file reports matrix dimensions, nnz, sparse floor, dense floor,
degree reached, checkpoint plan, verifier design. Absolute maximum 96 GiB,
one job at a time.

---

## 6. Route C — install and solve the actual twisted Fano section

Can close **only positively**.

**C1 — explicit Morita/quaternion model.** Produce one exact
`sigma`-self-adjoint reduced-rank-two idempotent `e` in the installed
15-basis; construct `D = eAe`, `P = eA`; compute a `K_proj`-basis of `D`,
multiplication table, standard involution, norm and trace forms, optionally a
symbol `D = (a,b)`; choose a right `D`-basis of `P ~= D^3`; transport the
descended five-plane to five exact Hermitian matrices
`H_1,...,H_5 in Herm_3(D)`. After a certified splitting extension: recover
the classical Plücker model; verify that the Moore/Pfaffian determinant of the
universal combination gives the Klein cubic; verify smoothness and Hilbert
polynomial of the Fano section.

Deliverables under `certificates/direct_fano/`: `quaternion_model.*`,
`hermitian_five_plane.*`, `split_fibre_verification.*`.

**C2 — direct rank-one/Plücker equations.** Independently of the affine
quaternion chart: construct the rank-one Hermitian cone in the installed
15-dimensional symmetric basis; restrict to the exact 10-plane defining
`F_{14,T}`; produce homogeneous equations over `K_proj`; cross-check
equivalence with `h_i(q,q) = 0`, `i = 1..5`, on all three quaternionic affine
charts. **This dual presentation is mandatory**; it protects against a
chart-at-infinity miss.

**C3 — structural rational-point search,** in order: sparse Noether
normalization; rational fibration or conic-bundle presentation; odd-degree
multisections; low-degree rational sections over the invariant subfield; only
then exact elimination on the smallest resulting fibres.

Exits: `C-POSITIVE` (exact common isotropic line / `F_{14,T}(K_proj)`-point →
`BR-FANO-POS`); `C-NO-POINT-IN-MODEL` (no point in a specified
fibration/chart; **no headline negative claim**); `C-UNDECIDED`.

---

## 7. Route S19 — marked degree-19 curve on the generic Schur twist

Can close **only positively**. Emptiness closes the construction, not the
headline.

**S19.1 — universal split-hyperplane marked orbit.** Over the exact split
representation: enumerate the 55 `D_12`-lines `l_i = P<a_i, b_i>`; introduce
universal hyperplane parameters `h`; form
`p_i(h) = h(b_i) a_i - h(a_i) b_i`; on the good hyperplane open construct the
relative 55-point scheme `Z_h subset P^3`; verify the accepted Hilbert
function fibrewise on a dense open.

Deliverables under `certificates/schur19_relative/`: `universal_points.*`,
`good_hyperplane_open.*`, `verify_points.py`.

**S19.2 — complete relative ideal and minimal resolution** over the
four-parameter hyperplane base: the saturated ideal `I_{Z_h}`; minimal
generators through stabilization; the complete graded Betti table;
multiplication maps and syzygies; stratification of the hyperplane base where
the resolution changes. The current low-degree data `I_Z(3), I_Z(4), I_Z(5)`
are **not enough** — the full resolution is required.

**S19.3 — marked Quot schemes for the two live Rao branches**
(`epsilon = 0`, no quintic; `epsilon = 1`, unique quintic `f_5 + f_3 q`). For
each: parameterize saturated subideals `I_C subset I_{Z_h}` with Hilbert
polynomial `19t + 1`; impose purity, geometric integrality, no component in
the cubic, multiplicity one at the 55 marked points; compute the image in the
hyperplane parameter space; determine whether the image meets the good
descended hyperplane locus.

Exits: `S19-POSITIVE` (explicit curve and parametrization — verify Bézout
residual length 2 → `BR-SCHUR19-POS`); `S19-EMPTY-ALL-H` (both branches empty
over the entire admissible hyperplane open — closes only the degree-19
construction); `S19-SPECIAL-H` (curves only on a proper special locus; report
equations and descent fields).

---

## 8. Route KLS — conditional packet

**No large KLS computation is authorized** until the analyst supplies a
precise theorem of the form: *minimal primitive rank-four covariant `=>`
finite list of conductor configurations `C_1,...,C_r`.*

Then compute only: **KLS.1** invariant-factor and orbit-product table (stable
invariant hypersurface factors by degree; proper-stabilizer component orbits;
possible gcd degrees and multiplicities; conductor-dominating supports;
residual adjugate-scalar factors); **KLS.2** local discrepancy/conductor table
per configuration (normalization; conductor; source pullback multiplicities;
local discrepancy data; degree contribution; possible degree-lowering factor);
**KLS.3** systematic counterexample search **before** accepting the theorem.

Exits: `KLS-FINITE-TABLE-CLOSED` (→ `BR-G-NEG`); `KLS-COUNTERMODEL`
(candidate theorem false); `KLS-NO-THEOREM` (no CAS work should begin).

---

## 9. Route H — proper-subgroup generic twists

Run only after the first director gate if Routes T and G do not cross a
decisive gate.

**H1 — two maximal `A_5` classes.** For each conjugacy class of maximal
`A_5 <= G`: construct the faithful three-dimensional generic `A_5`-torsor;
compute an exact Hilbert-90 frame for the restricted five-dimensional Klein
representation; write the twisted Klein cubic over
`K_{A_5} = C(P^2)^{A_5}`; compute fixed-scheme/valuation candidates, index and
low-degree zero-cycles, explicit rational points if present, and local point
obstructions if absent.

Exits: `H-NEGATIVE` (one generic `A_5`-twist certified pointless →
`BR-SUBGROUP-NEG`); `H-POINTS` (both have points; no headline conclusion);
`H-UNDECIDED`.

**No sweep over smaller subgroups** is authorized until both `A_5` classes are
decided.

---

## 10. First dispatch and director gate

Run in parallel:

```text
T3.1 + T3.2
G4.1 + G4.2
P25.1
```

Do not begin P25.3, C1, or S19.1 before the gate.

The gate report must select **exactly one** primary continuation:

1. **T-primary:** height-one normalization explicit, no 3-primary local
   defect visible.
2. **G-primary:** a finite universal terminal module is constructed.
3. **P25-primary:** the complete degree-25 tower survives and yields a small
   exact support problem.
4. **C-primary:** none of the first three crosses its gate; install the Fano
   model.
5. **S19-primary:** direct Fano installation fails or remains too large;
   build the relative marked orbit.
6. **No route crossed:** stop and report; **do not substitute a larger
   unstructured computation.**

---

## 11. Universal certificate requirements

Every producer must have an independent verifier that **does not import the
producer**. Every sealed packet must contain: theorem boundary; input hashes;
exact ring/field declarations; generator ordering; basis ordering;
open/saturation gates; characteristic; dimensions and degrees; resource
preflight; checkpoint hashes; terminal marker.

**For modular reconstruction:** record all primes; reject bad leading
coefficients and denominator primes; implement and verify every
rational-reconstruction congruence; use at least one holdout prime;
independently verify the reconstructed characteristic-zero identity.

**For candidate points or covariants:** substitute into the original
equations, not only eliminated consequences; verify every nonvanishing open;
verify field of definition; verify no chart-at-infinity solution was omitted;
provide exact reconstruction, not decimal approximations.

---

## 12. Resource policy

Default exploratory ceiling **8 GiB RSS**. A structurally justified job may
use up to **64 GiB RSS** after emitting the preflight above. Absolute one-job
ceiling **96 GiB RSS**. No concurrent memory-saturating jobs.

A job crossing its authorized ceiling must stop, checkpoint, and emit: last
completed checkpoint; current matrix/module dimensions; observed RSS;
reformulation options; whether the route remains headline-capable.

---

## 13. Final exit table

| Exit | CAS result | Analytic action |
|---|---|---|
| `T-NEGATIVE` | normalized incidence has no 3-primary defect; degree subgroup `3Z` | apply `BR-T-NEG` |
| `G-NEGATIVE` | universal terminal zero support empty for all families | apply `BR-G-NEG` |
| `G-POLYNOMIAL` | exact dominant landing covariant | apply `BR-COV-POS` |
| `P25-POSITIVE` | exact degree-25 dominant landing covariant | apply `BR-COV-POS` |
| `C-POSITIVE` | exact common isotropic line / `F_{14,T}`-point | apply `BR-FANO-POS` |
| `S19-POSITIVE` | exact qualifying degree-19 curve | apply `BR-SCHUR19-POS` |
| `KLS-FINITE-TABLE-CLOSED` | all analytically allowed minimal configurations excluded | apply `BR-G-NEG` |
| `H-NEGATIVE` | pointless generic proper-subgroup twist | apply `BR-SUBGROUP-NEG` |
| scoped emptiness | one finite degree/construction excluded | no headline claim |
| modular-only result | discovery | no headline claim |
| auxiliary point/torsor result | auxiliary route only | no headline claim |

**Problem E remains OPEN** until one complete exit above is independently
verified and the corresponding analytic bridge is written into the final
proof.
