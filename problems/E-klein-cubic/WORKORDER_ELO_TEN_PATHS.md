# Problem E — Elo-ranked ten-path successor work order

**Worker:** local research agent  
**Authored:** 2026-07-30  
**Repository:** `mattrobball/unirational`  
**Pinned base:** `83d2b1092fc06e4bb18998dc716ddea224c14cdb`  
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

This order follows the completed five-attempt campaign and the subsequent adversarial ten-path audit. It replaces the previous ranking rather than extending it mechanically.

### Positive proof standard

A positive resolution must provide either:

1. a rational point on a generic versal twist of the Klein cubic over the correct invariant field; or
2. an explicit nonzero homogeneous landing self-covariant \(p:W\to W\),

with exact verification of:

- field of definition;
- landing in the correct twisted or untwisted target;
- every descent or incidence arrow;
- primitivity and common-domain control;
- dominance;
- conversion to \(G\)-unirationality.

A point on an auxiliary Morita, Severi–Brauer, Fano-partner, or descent space is not a positive result until the full bridge to the generic Klein twist is proved.

### Negative proof standard

A negative resolution must prove either:

- a generic versal Klein twist has no rational point; or
- every nonzero homogeneous landing self-covariant is impossible in characteristic zero.

The following are insufficient:

- one failed construction;
- one support pattern;
- one finite degree range;
- one modular null result;
- one unresolved valuation;
- exclusion of one formal family;
- emptiness of an auxiliary Fano section without a theorem equating it to pointlessness of the Klein twist.

---

## 1. Authoritative inputs and corrections

The following tracked packets are accepted inputs:

```text
problems/E-klein-cubic/RESOLUTION.md
problems/E-klein-cubic/CURRENT_PATHS.md
problems/E-klein-cubic/HANDOFF.md

problems/E-klein-cubic/certificates/STRATA_EXACT.md
problems/E-klein-cubic/certificates/NORMAL_CHARACTERS.md
problems/E-klein-cubic/certificates/MARKED_S3_GEOMETRY.md
problems/E-klein-cubic/certificates/LOCAL_TRANSITION_MODULES.md
problems/E-klein-cubic/certificates/GLOBAL_TRANSITION_DIAGRAM.md
problems/E-klein-cubic/certificates/TRANSITION_CATEGORY_REPAIR.md
problems/E-klein-cubic/certificates/NONLINEAR_LIFTING_EQUATIONS.md
problems/E-klein-cubic/certificates/lifting/OBSTRUCTION_TOWER.md
problems/E-klein-cubic/certificates/elliptic_lifting/PICARD_OBSTRUCTION.md
problems/E-klein-cubic/certificates/hodge_centers/HODGE_CENTER_NECESSITY.md
problems/E-klein-cubic/certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md
problems/E-klein-cubic/certificates/WP_Z_GATE_REPORT.md

problems/E-klein-cubic/certificates/pfaffian_point/*
problems/E-klein-cubic/certificates/target_branch_global/*
problems/E-klein-cubic/certificates/global_lifting/*
problems/E-klein-cubic/certificates/schur_degree19/*
```

The exact repository strata packet is authoritative. In particular, type-II \(V_4\)-points are triple intersections of the three local fixed elliptics. Any candidate statement that positive-dimensional fixed loci meet only at type-I points is superseded.

### Current route boundary

| Prior route | Exact current status |
|---|---|
| Pfaffian–Morita idempotent | `FAIL-SCOPE`: idempotent gives a point of auxiliary \(\mathbf P^2_D\), not of \(F_{14,T}\) |
| Common isotropic line | Sound positive antecedent, still open |
| Target branch | `STOP-2`: direct target elimination exceeded the exploratory gate; normalization not constructed |
| Schur degree-19 curve | implication chain `PASS`; both Rao branches remain live; `STOP-3` |
| Global lifting | decisive containment \(G_{m,d}\subseteq\mathcal R_{3,m}\) versus open meeting is formulated and undecided |
| Finite/linear strata obstruction | structurally exhausted |
| Hodge-center character screen | necessary condition only; 40 representation channels survive |

---

## 2. Elo ranking and resource allocation

The tournament question was:

> Which path has the larger expected value for producing a decisive theorem or a genuinely narrowing structural result in the next serious research cycle?

| Rank | Code | Path | Elo | Queue status |
|---:|---|---|---:|---|
| 1 | A | Schur–Krylov rational parametrization | 1607 | primary |
| 2 | F | Fixed-frame genus-one torsor arithmetic | 1607 | primary |
| 3 | G | Global-state image / nonlinear lifting | 1554 | primary, cheap gate |
| 4 | B | Upstairs simple fold / mod-3 class group | 1553 | conditional negative |
| 5 | C | Direct twisted Fano equations | 1500 | secondary positive |
| 6 | H | KLS minimality–conductor theorem | 1487 | structural |
| 7 | I | Hermitian five-plane intersection theory | 1473 | structural |
| 8 | E | Proper-subgroup generic twists | 1420 | bounded exploratory |
| 9 | D | CM-polarized Hodge obstruction | 1420 | structural |
| 10 | J | Direct essential-dimension invariant | 1379 | theory watch |

Tie-breaks:

- A ranks above F because its next object is a finite determinantal incidence with a certified implication chain.
- G ranks above B because its first exact gate is sparse, dimensioned, and below the ordinary memory ceiling.
- E ranks above D because one pointless subgroup twist is decisive, while the Hodge route presently has unlimited hidden-center flexibility.

### Time allocation before the first director gate

| Path | Share |
|---|---:|
| A | 30% |
| F | 25% |
| G | 20% |
| B | 12% |
| C | 8% |
| H–J combined | 5% |

No route is promoted merely because its computation is largest.

---

# Path A — Schur–Krylov rational parametrization

## A0. Objective

Construct a qualifying degree-19 curve through the exact degree-55 closed point on the generic Schur twist, thereby obtaining a residual degree-2 zero-cycle and an \(F\)-point on the twisted cubic.

The implication chain is already certified. This path attacks existence directly.

## A1. Gate A1 — prove the \(\mathbf P^1\) reduction

Let \(F=K_{\mathrm{Schur}}\), let \(Z\) be the degree-55 closed point, and let \(C\) be a qualifying geometrically integral curve with Hilbert polynomial \(19t+1\).

Prove and seal:

1. \(p_a(C)=0\) and geometric integrality imply \(C_{\overline F}\) is a smooth genus-zero curve.
2. The degree-55 point on \(C\) forces the index of \(C\) to divide \(55\).
3. A genus-zero curve has index \(1\) or \(2\).
4. Therefore \(C(F)\neq\varnothing\) and \(C\simeq\mathbf P^1_F\).

Do not use the Krylov parametrization until this theorem is independently verified.

### Gate A1 exits

- `A1-PASS`: proceed to A2.
- `A1-FAIL`: identify the exact singular or index loophole; return to the marked Hilbert formulation.

## A2. Gate A2 — install the degree-55 algebra and marked point

Let

\[
L=F(Z),\qquad [L:F]=55.
\]

Required exact data:

1. a monogenic or Hironaka-module presentation of \(L/F\);
2. exact multiplication matrices for a fixed \(F\)-basis;
3. exact projective coordinates
   \[
   z=[z_0:z_1:z_2:z_3]\in\mathbf P^3(L)
   \]
   of the marked point;
4. the four-dimensional subspace
   \[
   V_Z=\operatorname{span}_F(z_0,z_1,z_2,z_3)\subset L;
   \]
5. a verifier that reconstructs the residue degree, point equations, and field action independently.

No interpolation search is authorized until these data are sealed.

## A3. Gate A3 — Krylov incidence

For \(\tau\in L\), set

\[
U_\tau=\operatorname{span}_F\{1,\tau,\ldots,\tau^{19}\}\subset L.
\]

Construct the incidence

\[
\mathcal K=
\left\{(\tau,\lambda)\in L\times L^\times:
\lambda V_Z\subseteq U_\tau\right\}.
\]

### Tasks

1. Express the containment by rank conditions on the \(55\times24\) matrix whose columns are
   \[
   1,\tau,\ldots,\tau^{19},\lambda z_0,\ldots,\lambda z_3.
   \]
2. Eliminate the 80 coefficients of the four degree-19 interpolating polynomials linearly.
3. Retain \(\tau\) and \(\lambda\) as the nonlinear variables.
4. Remove the \(\mathrm{PGL}_2\)-redundancy by a certified trace/norm or coefficient gauge.
5. Compute expected and actual tangent dimensions at discovery points.
6. Record sparse and dense memory floors before elimination.

### Required safeguards

Containment in \(U_\tau\) is necessary but not sufficient. Every candidate must also satisfy:

- the four binary forms have no common zero;
- the map has degree exactly 19;
- the map is birational onto its image;
- the image contains \(Z\) with intersection multiplicity one at all conjugates;
- the image has no component in the cubic;
- the residual cubic intersection has length exactly two.

## A4. Decision exits

- `P-A`: qualifying curve constructed; apply the accepted residual-degree-2 implication and close positively.
- `N-A`: prove \(\mathcal K=\varnothing\) and that the parametrization criterion is exhaustive; close the full degree-19 rescue route only.
- `A-SURVIVE`: an irreducible incidence component survives; output its equations, dimension, and next exact point problem.
- `A-STOP`: the incidence exceeds the approved resource gate before a structural reduction; stop with a measured bottleneck.

## A5. Deliverables

```text
certificates/schur_krylov/P1_REDUCTION.md
certificates/schur_krylov/field_algebra.*
certificates/schur_krylov/marked_point.*
certificates/schur_krylov/krylov_incidence.*
certificates/schur_krylov/candidate_verifier.*
certificates/schur_krylov/SEAL.json
```

---

# Path F — Fixed-frame genus-one torsor arithmetic

## F0. Objective

Decide whether the explicit fixed-frame genus-one curve has a rational point over \(K_{\mathrm{proj}}\), or produce a genuine local obstruction.

Accepted inputs include:

- the exact depressed cubic;
- the Jacobian and \(E[3]\)-algebra;
- the class \(\alpha_R=w_1(\xi)\);
- pinned CFOSS injectivity;
- exact local Kummer comparisons at existing quotient divisors;
- soluble \(D_3\) and \(D_5\) places;
- the exact degree-six extension \(K_{\mathrm{proj}}/F\) with \(S_6\)-monodromy;
- the conic/intersection-algebra reformulation.

## F1. Gate F1 — choose one terminal arithmetic target

The worker must choose exactly one of the following before computation.

### Fork F1-N — new divisorial local obstruction

Identify a divisorial valuation \(v\) not already retired and compute:

1. an integral homogeneous gauge for the cubic and \(\alpha_R\);
2. reduction of the genus-one curve and Jacobian;
3. the local Kummer image;
4. whether \(\xi_v\) lies in that image;
5. the exact implication from nonmembership to pointlessness.

A mixed-weight DAG valuation is not an integral gauge.

### Fork F1-P — conic/intersection-algebra construction

Over

\[
F=\mathbf C(A,B,Y,Z),\qquad [K_{\mathrm{proj}}:F]=6,
\]

construct the scheme of conics \(Q\) satisfying:

1. \(Q\cap C\) is finite flat of length six;
2. its coordinate algebra is isomorphic to \(K_{\mathrm{proj}}\);
3. the induced point lies in the projector open;
4. every field-identification condition is expressed by exact traces, norms, or multiplication tables.

Do not run both forks in parallel before one reaches its first gate.

## F2. Gate F2 — terminality audit

Before a large calculation, write the complete final implication:

- local Kummer nonmembership \(\Rightarrow C(K_{\mathrm{proj}})=\varnothing\); or
- conic-algebra solution \(\Rightarrow C(K_{\mathrm{proj}})\neq\varnothing\).

The audit must exclude a repeat of the auxiliary-idempotent scope error.

## F3. Decision exits

- `N-F`: a complete local obstruction is proved; close negatively.
- `P-F`: a conic/algebra or direct point is constructed; close positively.
- `F-LOCAL-SOLUBLE`: the chosen place is retired; select at most one further place before a director gate.
- `F-STOP`: no terminal local-global criterion remains; do not enlarge the descent DAG without a new theorem.

## F4. Deliverables

```text
certificates/fixed_frame_arithmetic/TERMINALITY_AUDIT.md
certificates/fixed_frame_arithmetic/valuation_*.*
certificates/fixed_frame_arithmetic/conic_algebra_*.*
certificates/fixed_frame_arithmetic/SEAL.json
```

---

# Path G — Global-state image versus nonlinear rank drop

## G0. Objective

Decide the first genuinely global question left by the stabilizer-normal-cone machine:

\[
G_{m,d}\subseteq\mathcal R_{3,m}
\quad\text{or}\quad
G_{m,d}\cap(B_{m,d}\setminus\mathcal R_{3,m})\neq\varnothing.
\]

No further generic local lifting stage is authorized before this decision.

## G1. Gate G1 — exact \((m,d)=(1,7)\) calculation

Rebuild over \(\mathbf Q\):

1. the repaired global equalizer \(\Lambda^{\mathrm{rep}}_{1,7}\);
2. an exact sparse basis in CSR form;
3. the projection to the leading-state image \(G_{1,7}\);
4. the accepted free-module operator \(L_3\);
5. the restriction of \(L_3\) to \(G_{1,7}\);
6. its generic rank over the coordinate ring or function field of \(G_{1,7}\).

### Decisive certificates

- open meeting: one characteristic-zero globally compatible point where \(L_3\) has full generic rank, or a nonzero maximal minor on \(G_{1,7}\);
- containment: every maximal minor restricts identically to zero on \(G_{1,7}\).

Modular rank samples are discovery only.

## G2. Director fork

### Fork G-A — global states are forced into rank drop

1. restrict \(\omega_3\) to \(G_{1,7}\);
2. impose all coefficient couplings and equalizers;
3. decide whether the obstruction class is nonzero;
4. only then test \((1,13)\) and \((3,19)\);
5. seek a finite-generation or periodicity theorem before any all-degree claim.

### Fork G-B — global states meet the generic-surjective open

1. prove the generic-rank formulas for every odd \(m\);
2. derive the higher polar recursion;
3. test formal smoothness on a common global open;
4. formulate equivariant gluing;
5. isolate the algebraization theorem required for an actual covariant.

## G3. Decision exits

- `G-ACTIVE-OBSTRUCTION`: rank-drop containment plus nonzero \(\omega_3\) at the global level.
- `G-CONSTRUCTION`: globally compatible states meet the unobstructed open; machine is reclassified as constructive.
- `G-SCOPED`: verdict only at one bidegree; no headline claim.
- `G-STOP`: exact equalizer reconstruction disagrees with accepted dimensions or exceeds the sparse resource plan.

## G4. Deliverables

```text
certificates/global_lifting_decision/Lambda_basis_CSR.json
certificates/global_lifting_decision/G_projection_matrix.json
certificates/global_lifting_decision/Fitt_coker_L3.*
certificates/global_lifting_decision/rank_certificate.json
certificates/global_lifting_decision/DECISION.md
certificates/global_lifting_decision/SEAL.json
```

---

# Path B — Upstairs simple-fold normalization and mod-3 class group

## B0. Objective

Avoid elimination of the target branch and prove that the simple ramification locus upstairs is the relevant normalization on its open set.

Set

\[
\widetilde D^\circ=
V(P,P_u)\cap\{P_{uu}\delta C\neq0\}.
\]

## B1. Gate B1 — normalization without eliminating \(u\)

Prove or refute:

1. \(\widetilde D^\circ\) is smooth;
2. it is geometrically irreducible;
3. its map to the target coefficient space is generically one-to-one;
4. it is the normalization of the multiplicity-one branch on the simple-fold open.

Permitted inputs:

- the exact primitive sextic;
- unit conditions \(P_{uu},\delta,C\);
- exact \(S_6\)-monodromy;
- the dimension-one degree-14 critical curve on the accepted slice.

Forbidden shortcut:

- transitivity of transpositions alone does not prove irreducibility of the ramification locus.

### Gate B1 exits

- `B1-PASS`: proceed to B2.
- `B1-HIGHER`: a higher singular or multiple component is identified; compute its local class group modulo three only.
- `B1-STOP`: the upstairs component itself requires the same elimination-scale computation; stop and demote.

## B2. Gate B2 — discriminant contacts modulo three

On a normal compactification of the upstairs branch:

1. pull back the cubic discriminant;
2. list every height-one prime \(E\);
3. compute \(v_E(\Delta_{\mathrm{cub}})\bmod3\);
4. compute codimension-two local class groups modulo three;
5. control codimension-three punctured Picard groups or prove residual bad locus codimension at least four.

Do not compute the full class group.

## B3. Decision exits

- `N-B`: the three-primary defect vanishes; preserve index three and close negatively.
- `B-DANGER`: an explicit dangerous three-primary class is exhibited.
- `B-STOP`: normalization or conductor remains unavailable without target elimination.

## B4. Deliverables

```text
certificates/upstairs_fold/UPSTAIRS_NORMALIZATION.md
certificates/upstairs_fold/ramification_component.*
certificates/upstairs_fold/compactification.*
certificates/upstairs_fold/discriminant_contacts_mod3.*
certificates/upstairs_fold/local_picard_mod3.*
certificates/upstairs_fold/SEAL.json
```

---

# Path C — Direct twisted Fano equations

## C0. Objective

Construct and solve the actual positive Pfaffian gate

\[
F_{14,T}(K_{\mathrm{proj}})\neq\varnothing,
\]

without detouring through an auxiliary self-adjoint idempotent.

## C1. Gate C1 — descend the rank-one cone

In the installed 15-dimensional symmetric/Pfaffian basis:

1. derive the equations for Hermitian/Plücker rank one;
2. identify the exact 10-plane cutting out the twisted Fano section;
3. restrict the rank-one equations to that 10-plane;
4. after a splitting extension, verify scheme-theoretically that the result is the classical smooth degree-14 Fano threefold;
5. descend the verification to \(K_{\mathrm{proj}}\).

No explicit quaternion symbol is required if the rank-one equations can be expressed intrinsically by reduced characteristic coefficients or Plücker relations.

## C2. Gate C2 — rational-point structure

Attempt, in order:

1. a rational fibration with fibres of dimension at most two;
2. a conic- or quadric-bundle presentation;
3. Noether normalization plus a low-degree multisection;
4. direct sparse point equations only after the first three fail.

A negative result on \(F_{14,T}\) is not a headline negative theorem unless a separate equivalence with Klein pointlessness is proved.

## C3. Decision exits

- `P-C`: \(F_{14,T}(K_{\mathrm{proj}})\neq\varnothing\); use the audited incidence arrow and close positively.
- `N-C-SCOPED`: Fano section proved pointless; no headline conversion without an additional theorem.
- `C-STOP`: executable descended equations are not obtained.

## C4. Deliverables

```text
certificates/direct_fano/RANK_ONE_CONE.md
certificates/direct_fano/rank_one_equations.*
certificates/direct_fano/restricted_fano.*
certificates/direct_fano/split_fibre_verify.*
certificates/direct_fano/point_structure.*
certificates/direct_fano/SEAL.json
```

---

# Path H — KLS minimality–conductor theorem

## H0. Objective

Prove an all-degree negative theorem by showing that a primitive minimal rank-four covariant cannot support the surviving conductor geometry.

## H1. Gate H1 — state the exact target theorem

The theorem must control:

- non-plt conductor places;
- the number and multiplicity of source components dominating each conductor component;
- cancellation in the normalized Gauss map;
- invariant and orbit-product gcd factors;
- Darboux-invariant leaf divisors;
- degree lowering compatible with primitivity.

Normality, lc, or plt alone are not sufficient hypotheses.

## H2. Gate H2 — construct a degree-lowering operation

From one forbidden conductor configuration, construct exactly one of:

- a lower-degree primitive rank-four covariant;
- a factorization through a lower-degree equivariant endomorphism;
- a contradiction to saturation or primitivity.

If no such operation is constructed, stop. Do not begin another bounded KLS scan.

## H3. Decision exits

- `N-H`: every primitive minimal rank-four covariant excluded; close negatively.
- `H-UNIQUE`: theorem forces a unique geometric configuration; pass it to a constructive route.
- `H-COUNTERMODEL`: a counterexample satisfying the proposed hypotheses is constructed; retire the theorem.

## H4. Deliverables

```text
certificates/kls_next/TARGET_THEOREM.md
certificates/kls_next/degree_lowering.*
certificates/kls_next/component_bound.*
certificates/kls_next/GLOBAL_INEQUALITY.md
certificates/kls_next/SEAL.json
```

---

# Path I — Hermitian five-plane intersection theory

## I0. Objective

Study the common-zero locus of five Hermitian sections on

\[
SB_2(A)\simeq\mathbf P^2_D
\]

using arithmetic intersection theory rather than direct equation solving.

## I1. Gate I1 — identify a point-sensitive invariant

Compute the ordinary Chow class first, but do not stop there. Determine whether one of the following carries point-sensitive information:

- Chow–Witt Euler class;
- Witt-group obstruction;
- unramified cohomology class;
- canonical-dimension or incompressibility class;
- hermitian Euler class of the five-plane section.

The invariant must distinguish rational points from zero-cycles of index one. Ordinary top Chern class alone is insufficient.

## I2. Decision exits

- `N-I`: point-sensitive invariant obstructs a common isotropic line; state exact implication to the Klein problem.
- `P-I`: invariant forces or constructs a rational common zero.
- `I-STOP`: only ordinary cycle/index data are obtained; retire from active queue.

## I3. Deliverables

```text
certificates/hermitian_intersection/INVARIANT_AUDIT.md
certificates/hermitian_intersection/chow_data.*
certificates/hermitian_intersection/point_sensitive_invariant.*
certificates/hermitian_intersection/SEAL.json
```

---

# Path E — Proper-subgroup generic twists

## E0. Objective

Seek a decisive negative result for a proper subgroup. If \(X\) is \(G\)-unirational, then it is \(H\)-unirational for every \(H\le G\).

Begin with one of the two maximal \(A_5\) classes.

## E1. Gate E1 — one-class pilot only

1. restrict the exact five-dimensional representation and Klein cubic to one \(A_5\) class;
2. use the faithful three-dimensional icosahedral representation to construct the generic \(A_5\)-torsor over
   \[
   K_{A_5}=\mathbf C(\mathbf P^2)^{A_5};
   \]
3. construct an exact Hilbert–90 frame for the twisted \(\mathbf P^4\);
4. write the twisted Klein cubic over \(K_{A_5}\);
5. test one positive construction and one valuation obstruction.

Do not run both \(A_5\) classes until the first pilot is sealed.

## E2. Decision exits

- `N-E`: generic \(A_5\)-twist pointless; close the full \(G\)-problem negatively.
- `P-E-SCOPED`: generic \(A_5\)-twist has a point; run the second class only after a director gate.
- `E-STOP`: subgroup twist is as difficult as the full twist; retire subgroup sweep.

## E3. Deliverables

```text
certificates/subgroup_twists/A5_CLASS1.md
certificates/subgroup_twists/a5_frame.*
certificates/subgroup_twists/a5_twisted_cubic.*
certificates/subgroup_twists/a5_point_or_obstruction.*
certificates/subgroup_twists/SEAL.json
```

---

# Path D — CM-polarized Hodge obstruction

## D0. Objective

Upgrade the representation-only Hodge-center screen to the integral polarized intermediate-Jacobian structure.

## D1. Gate D1 — repair and install the Hodge input

1. repair the split-injection proof for a fourfold mapping to a threefold by using a relatively ample divisor and projection formula;
2. install the exact period lattice and CM order of the Klein cubic intermediate Jacobian;
3. install the principal polarization, not merely the unpolarized isogeny class;
4. verify the actual character on differentials of the 55 fixed elliptics.

## D2. Gate D2 — geometric channel screen

For each surviving center channel, require an actual equivariant isogeny or Albanese map carrying the needed CM factor and polarization data.

Eliminate:

- genus-one centers not isogenous to the CM elliptic factor;
- channels incompatible with the integral \(\mathcal O_{-11}\)-lattice;
- induced polarizations with impossible discriminant or type.

Do not claim a contradiction from representation multiplicities alone.

## D3. Decision exits

- `N-D`: no collection of admissible centers can supply the polarized Hodge structure; close negatively.
- `D-NARROW`: finite list of geometric CM-center configurations remains.
- `D-STOP`: high-genus or irregular-surface flexibility remains uncontrolled; retire.

## D4. Deliverables

```text
certificates/hodge_cm/SPLIT_INJECTION_REPAIR.md
certificates/hodge_cm/period_lattice.*
certificates/hodge_cm/polarization.*
certificates/hodge_cm/geometric_channel_screen.*
certificates/hodge_cm/SEAL.json
```

---

# Path J — Direct essential-dimension / canonical-dimension invariant

## J0. Objective

Prove directly

\[
\operatorname{ed}_{\mathbf C}(G)=4
\]

using an invariant that survives every three-dimensional compression.

## J1. Gate J1 — candidate-invariant audit

Before any computation, list candidate invariants from:

- cohomological invariants;
- equivariant Chow groups and Steenrod operations;
- canonical dimension and incompressibility;
- motives of generic projective representations;
- unramified cohomology.

For each candidate, state:

1. its degree;
2. its value on the generic \(G\)-torsor;
3. why it must vanish on every field of transcendence degree at most three or every threefold compression;
4. whether existing subgroup restrictions force it to vanish already.

No candidate proceeds without all four items.

## J2. Decision exits

- `N-J`: invariant proves \(\operatorname{ed}_{\mathbf C}(G)\ge4\); close negatively.
- `J-CANDIDATE`: one exact candidate survives the audit; issue a separate work order.
- `J-STOP`: no candidate invariant is found; retain as theory watch only.

## J3. Deliverables

```text
certificates/essential_dimension/CANDIDATE_AUDIT.md
certificates/essential_dimension/invariant_*.*
certificates/essential_dimension/SEAL.json
```

---

## 3. First dispatch

The first dispatch runs exactly three parallel gates.

### Dispatch A

Complete Path A through Gate A2:

1. seal the \(\mathbf P^1\)-reduction;
2. install \(L/F\);
3. install exact coordinates of \(Z\);
4. emit the Krylov-incidence matrix dimensions and memory plan.

Do not launch the nonlinear incidence solve.

### Dispatch F

Complete Path F through Gate F2:

1. choose one terminal fork;
2. write the implication audit;
3. prepare the exact local or conic-algebra interface;
4. stop before a large computation.

### Dispatch G

Complete Path G Gate G1 at \((m,d)=(1,7)\):

1. rebuild the equalizer;
2. compute \(G_{1,7}\);
3. restrict \(L_3\);
4. decide containment versus open meeting over \(\mathbf Q\).

### Deferred until the first director gate

- B begins only if its upstairs-normalization theorem has a proof plan not requiring target elimination.
- C begins only after the descended rank-one equations are specified symbolically.
- H–J remain documentation/theory tracks and may use no large compute allocation.

---

## 4. Director gate after the first dispatch

The gate report must select exactly one primary continuation.

1. `A-READY`: Krylov incidence is structurally small; authorize exact solve.
2. `F-TERMINAL`: a genuinely terminal valuation or conic-algebra problem is ready; prioritize F.
3. `G-A`: global states are forced into rank drop; prioritize the global obstruction.
4. `G-B`: global states meet the unobstructed open; reclassify the machine as constructive.
5. `B-READY`: an upstairs normalization theorem is proved; prioritize mod-3 class groups.
6. `C-READY`: exact restricted rank-one equations are installed; prioritize Fano point construction.
7. `NO-GATE`: none crosses; start E’s one-class \(A_5\) pilot and H’s theorem-formulation gate only.

No option may be selected from heuristic dimension counts or modular samples.

---

## 5. Universal house rules

1. **No auxiliary-point headline claim.** Every bridge to the generic Klein twist must be explicit.
2. **No return to the abstract idempotent as if it supplied a common isotropic line.**
3. **No direct full marked-Hilbert Gröbner solve before the \(\mathbf P^1\)/Krylov reduction is audited.**
4. **No raw target elimination of \((P,P_u)\) above the 8 GiB gate while the upstairs route remains untested.**
5. **No generic higher local lifting before the global-state image is decided.**
6. **No full class-group calculation when only the three-primary quotient is relevant.**
7. **No pointwise singularity treatment of a positive-dimensional critical locus.**
8. **No naive averaging of affine solution torsors.** Use correct character projectors and prove stability.
9. **No formal lift called a covariant.**
10. **No finite-field result advertised as characteristic zero without a written lifting argument.**
11. **No proper-subgroup positive result promoted to the full \(G\)-case.**
12. **No representation-only Hodge contradiction.** Integral Hodge and geometric realizability are required.
13. **No ordinary Chow/index computation treated as a rational-point theorem.**
14. **No KLS theorem based only on normality, lc, or plt.**
15. **Stop and certify any exact invariant obstruction independent of all admissible corrections.**
16. Every producer has an independent verifier that does not import it.
17. Every artifact states its exact theorem boundary.
18. Update the ranking only at a director gate.

---

## 6. Software and hardware policy

### Free software only

No Magma dependency in final certificates.

Preferred stack:

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

Use absolute binary paths where shell aliases are dangerous.

### Memory gates

- ordinary exploratory ceiling: **8 GiB RSS**;
- structurally justified sealed job: up to **96 GiB RSS** after director approval;
- no concurrent memory-saturating jobs;
- stream sparse rows, transformation circuits, and checkpoints.

Before any job expected to exceed 8 GiB, emit:

```text
matrix/module dimensions
term count
sparse memory floor
dense memory floor
expected certificate
checkpoint plan
independent verifier design
```

### Characteristic-zero discipline

Finite fields may be used for discovery, pivot selection, support selection, and shape inference only.

A characteristic-zero theorem requires:

- exact computation over \(\mathbf Q\), the relevant number field, or the relevant function field; or
- a written DVR/properness/rank-preservation argument with every hypothesis checked.

---

## 7. Final exit table

| Exit | Meaning | Headline consequence |
|---|---|---|
| `P-A`, `P-F`, `P-C` | exact rational point on a generic twist | \(G\)-unirational; \(\operatorname{ed}_{\mathbf C}(G)=3\) |
| `N-F`, `N-B`, `N-E`, `N-H`, `N-D`, `N-J` | exact pointless generic/residue twist or exclusion of all compressions | not \(G\)-unirational; \(\operatorname{ed}_{\mathbf C}(G)=4\) |
| `G-CONSTRUCTION` | global formal machine points toward construction | no headline until algebraization |
| `G-ACTIVE-OBSTRUCTION` | global nonlinear obstruction becomes active | no headline until all degrees/families are covered |
| scoped negative | one route or family excluded | no headline conclusion |
| formal survivor | formal state or lift survives | no headline conclusion |
| auxiliary point | point on Morita/Fano/descent auxiliary space only | no headline without bridge |
| no gate crossed | all paths remain open | preserve exact interfaces; no new sweep |

---

## 8. Required status update

After every accepted gate, update only:

```text
problems/E-klein-cubic/HANDOFF.md
problems/E-klein-cubic/CURRENT_PATHS.md
problems/E-klein-cubic/RESOLUTION.md
problems/E-klein-cubic/SPEC.md
```

Each update must record:

1. exact commit and artifact hashes;
2. replay commands;
3. theorem boundary;
4. director decision;
5. revised Elo ranking only if pairwise evidence changes;
6. explicit statement that Problem E remains open unless a final exit above has been reached.
