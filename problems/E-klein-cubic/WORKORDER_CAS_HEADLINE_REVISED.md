# Problem E — Revised CAS-Only Work Order for Headline Resolution

**Repository:** `mattrobball/unirational`  
**Pinned base:** `d8550e109d3c6d1e1e1324125a5c283b2da74b04`  
**Supersedes for execution:** `WORKORDER_CAS_HEADLINE.md`  
**Binding correction layer:** `REPAIR.md`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** exact computer algebra only  
**Headline status:** **OPEN**

---

## 0. Mission and proof discipline

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),
\qquad
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
\subset \mathbf P(W)\simeq\mathbf P^4.
\]

The accepted headline equivalence remains

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

This order requests **CAS results only**. Every computation must end in an exact algebraic object, an independently replayable verifier, and a precise theorem boundary. The worker must not prove or restate analytic implications beyond those explicitly supplied by the director.

### 0.1 Binding distinction

```text
hash / verifier replay
    !=
mathematical verification of an analytic implication recorded in prose.
```

`REPAIR.md` is binding. Historical files remain computation records, but any theorem boundary corrected there supersedes the historical label.

### 0.2 Headline-capable outputs

A CAS packet may contribute to a complete result only through one of the following already-audited interfaces.

| Exit | CAS output | Analytic bridge |
|---|---|---|
| `P25-POLYNOMIAL` | one exact primitive degree-25 landing self-covariant of generic Jacobian rank four | exact covariant \(\Rightarrow\) dominant \(G\)-map |
| `C-POSITIVE` | one exact common isotropic right \(D\)-line, equivalently a point of \(F_{14,T}(K_{\rm proj})\) | twisted Fano point \(\Rightarrow\) generic Klein-twist point |
| `T-NEGATIVE` | an exact residue-degree-one branch on which the cubic retains index three | pointless versal twist \(\Rightarrow\) not \(G\)-unirational |
| `S19-POSITIVE` | one qualifying degree-19 curve through the degree-55 Schur point | residual degree-two cycle \(\Rightarrow\) point on the generic Schur twist |
| `H-NEGATIVE` | one certified pointless generic twist for a subgroup \(H\le G\) | subgroup obstruction \(\Rightarrow\) full-group obstruction |

The following are **not** headline outputs:

- a nonzero terminal residual at one sample;
- a zero of a free-fibre normal-cone equation;
- a formal jet or boundary state;
- a finite-degree exclusion;
- emptiness of the degree-19 rescue construction;
- a point of the auxiliary Morita-projector cubic;
- a point of the auxiliary fixed-frame genus-one curve without a separate audited bridge;
- normality or nonnormality of an intermediate fold algebra by itself.

---

## 1. Authoritative current status

The revised order starts from the following status.

| Route / object | Accepted current status |
|---|---|
| `T-BIRATIONAL` | retained on its stated generic/open scope |
| `T2R` | `T2R-UNDECIDED`: on the common open \(S_G\), \(S_2\) is proved and \(\dim\operatorname{Sing}(S_G)\le2\); the lower bound is not proved |
| `T-NONNORMAL` | suspended |
| G finite truncation | retained: fixed-degree tower terminates by order \(3d\) |
| G isolation cutoff | retained: \(N_\star=d+2m+1\) |
| G4.1 | exact free-fibre recurrence and structural residual identity on its stated chart |
| G4.2 | no finite global presentation was **constructed** in the pure \((m,d)\)-grading; nonexistence of such a presentation is not proved |
| P25.1 | only the first non-isolable free-fibre equation at \(N_\star=28\) survives; this is not a full global tower |
| degree-25 border module | finite rank-28 presentation exists; projective support remains undecided |
| Path A | abstract degree-55 algebra/evaluation interface only; executable generic \((L,V_Z)\) not installed |
| direct Fano | analytic target is correct; executable quaternion/Hermitian model not installed |

### 1.1 Revised priority

1. **P25R — exact global degree-25 solve.**
2. **T2R/T — finish the same-open dimension and normalization gate.**
3. **C — install and solve the actual twisted Fano section.**
4. **S19 — relative marked degree-19 curve construction.**
5. **G-universal — parked pending a new multigrading or finite-generation theorem.**
6. **H — maximal-subgroup twists, only after the next director gate.**

---

# 2. First dispatch

Run the following in parallel:

```text
P25R.0 + P25R.1 + P25R.2
T2R.4 + T2R.5
```

Do not start the direct Fano model, the relative Schur Hilbert scheme, or any universal degree ladder before the director gate in §7.

---

# 3. Route P25R — replace free-fibre cancellation by one global finite system

## 3.0 Objective

Decide whether the existing degree-25 landing system contains an actual nonzero primitive landing self-covariant.

The current P25.1 packet proves only that selected local/free normal-cone states can cancel the first non-isolable residual. It does **not** prove that the cancellation parameters belong to the genuine equivariant modules, that they arise from one global coefficient vector, or that the equations at orders \(30,32,\ldots,74\) vanish.

All P25R stages must use one fixed global coefficient vector throughout.

---

## P25R.0 — freeze the exact characteristic-zero global coefficient model

### Computation

Construct one exact characteristic-zero model for the normalized degree-25 self-covariant coefficient space and all maps consumed below.

Required objects:

1. The strict global coefficient space
   \[
   V_{25}=Q\oplus K
   \]
   with the accepted dimensions \(37+6=43\), over \(\mathbf Q\) or the minimal exact cyclotomic field required by the representation.
2. The exact change-of-basis matrices between:
   - the original degree-25 covariant basis;
   - the normalized \((Q\mid K)\)-basis;
   - the rank-28 border basis;
   - every representative local normal-jet basis.
3. For every normal order \(1\le r\le25\), the exact restriction map
   \[
   \rho_r:V_{25}\longrightarrow
   \operatorname{Sym}^r(E_-^*)\otimes E_{\pm}.
   \]
4. Exact restriction maps to:
   - the source involution line;
   - the exceptional normal-direction line;
   - the target involution line;
   - the \(V_4\) triple-line equalizer;
   - the \(A_4,D_{10},D_{12}\), type-I/type-II point kernels;
   - the \(C_3,A_4,C_6\) character blocks.
5. The actual characteristic-zero residual module at degree \(25\). Confirm or correct the modular rank-seven claim. The full local space of dimension \(52\) must not be substituted for this module.

### Required checks

- Every matrix is exact in characteristic zero.
- Every modular matrix previously used is recovered by good reduction at the stated prime.
- Source, normal, and target copies of \(\mathbf P(E_-)\) remain distinct.
- The seven based-minus-line rows are reconstructed in characteristic zero, not imported from \(\mathbf F_{67}\).
- The image of every global map is compared with the corresponding free local kernel; equality must not be assumed.

### Deliverables

```text
certificates/degree25_global/COEFFICIENT_MODEL.md
certificates/degree25_global/bases.json
certificates/degree25_global/restriction_maps/*
certificates/degree25_global/residual_module_char0.json
certificates/degree25_global/produce_model.py
certificates/degree25_global/verify_model.py
```

### Exit

- `P25R0-PASS`: exact model and maps installed.
- `P25R0-FAIL`: smallest missing basis or map named; P25R stops.

---

## P25R.1 — compute the genuine global correction spaces

Run only after `P25R0-PASS`.

### Computation

For each isolable polar stage, compute the space of corrections that actually comes from the same global coefficient vector and satisfies every previously imposed global condition.

For stage \(r\), define

\[
C_r^{\rm glob}
=
\rho_r(V_{25})
\cap\ker L_r
\cap E_{V_4}
\cap E_{\rm points}
\cap E_{\rm chars}
\cap E_{\rm source\ line},
\]

where every factor is represented by an exact matrix from P25R.0.

Compute separately for:

```text
based_minus_lines_odd_m
residual_e_ge7_generic_swap_both
```

For the residual family, replace the free \(52\)-dimensional \(a_{25}\)-space by the actual global residual image.

### Critical consistency rule

Do not choose a new independent element of \(C_r^{\rm glob}\) at each stage. Express every jet as a linear function of one global coordinate vector

\[
c\in V_{25}.
\]

The output is a compatible block map

\[
\rho_{\le25}:V_{25}	o\bigoplus_{r=1}^{25}J_r.
\]

### Deliverables

```text
certificates/degree25_global/GLOBAL_CORRECTION_SPACES.md
certificates/degree25_global/global_jet_map.*
certificates/degree25_global/stage_subspaces.json
certificates/degree25_global/family_linear_gates.json
certificates/degree25_global/verify_correction_spaces.py
```

### Exit

- `P25R1-PASS`: genuine global spaces installed.
- `P25R1-EMPTY-BASED`: based family globally empty before nonlinear equations.
- `P25R1-EMPTY-RESIDUAL`: residual family globally empty before nonlinear equations.
- `P25R1-FAIL`: exact missing global equalizer named.

---

## P25R.2 — solve the entire finite tower simultaneously

Run only for families surviving P25R.1.

### Computation

Using the same global variable vector \(c\), impose every nonautomatic equation

\[
F_N(c)=0,
\qquad
N=4,6,\ldots,74.
\]

Requirements:

1. The order-28 cancellation must be recomputed inside the genuine global correction spaces.
2. The same chosen coefficients must be substituted into all later equations.
3. No equation may be solved by independently resetting an earlier jet.
4. Use stagewise linear elimination where valid, but retain exact back-substitution maps to the original \(43\) coordinates.
5. At the end, compare the assembled tower equations coefficientwise with the accepted rank-842 cubic landing system. Prove equivalence on the family branch by exact row/ideal containment in both directions, or state the precise residual gap.
6. Saturate by:
   - the nonzero-covariant ideal;
   - exact-order gates;
   - the `swap_both` open for the residual family;
   - all denominators introduced by basis changes.

### Preferred representation

Use sparse polynomial matrices and the rank-28 border module whenever this reduces the system. Do not materialize the raw dense \(842\times43\)-variable Macaulay system unless a preflight proves it is smaller than the sparse alternative.

### Deliverables

```text
certificates/degree25_global/FULL_FINITE_TOWER.md
certificates/degree25_global/tower_equations/*
certificates/degree25_global/elimination_ledger.json
certificates/degree25_global/equivalence_to_842.json
certificates/degree25_global/projective_support_preborder.json
certificates/degree25_global/verify_full_tower.py
```

### Exits

- `P25-GLOBAL-EMPTY`: both family branches have empty projective support. This is a degree-25 exclusion only.
- `P25-GLOBAL-SURVIVES`: one exact global projective support component survives; proceed to P25R.3.
- `P25R2-UNDECIDED`: smallest unresolved sparse system and resource floor recorded.

---

## P25R.3 — projective border support and candidate reconstruction

Run only after `P25-GLOBAL-SURVIVES`.

### Computation

1. Translate every surviving global tower equation into the rank-28 border module.
2. Form the full \(T_i\)-stable closure, including neighbor and commutator syzygies.
3. Compute either
   \[
   \operatorname{Ann}(F/N')
   \quad\text{or}\quad
   \operatorname{Fitt}_0(F/N'),
   \]
   then saturate by the irrelevant ideal and all family opens.
4. Determine whether projective support is empty, positive-dimensional, or zero-dimensional.
5. For every zero-dimensional support point, reconstruct exact characteristic-zero coordinates.
6. Recover the original degree-25 covariant and verify directly:
   \[
   F(p)=0,
   \quad p\ne0,
   \quad\gcd(p_0,\ldots,p_4)=1,
   \quad\operatorname{rank}Dp=4
   \]
   at an exact rational or algebraic test point outside the degeneracy ideal.
7. Verify full \(G\)-equivariance against exact generators.

### Exits

- `P25-POLYNOMIAL`: exact dominant landing covariant. Stop all other routes and hand to the analyst.
- `P25-EMPTY`: degree-25 support empty; no headline negative claim.
- `P25-SUPPORT-UNDECIDED`: exact support ideal and bottleneck recorded.

---

# 4. Route T2R — finish the same-open dimension gate before normalization

## 4.0 Current boundary

The common object is the fold algebra on the open \(S_G\), with the complementary resultant factor \(G\) inverted. On this same open:

- \(S_2\) is proved;
- \(\dim\operatorname{Sing}(S_G)\le2\) is proved;
- the lower bound \(2\) is not proved;
- exact sparse data for the Cramer factor \(\delta\) and complementary factor \(G\) are not installed.

No T3 normalization may begin before this gate closes.

---

## T2R.4 — install exact saturation data

### Computation

Install exact arithmetic-circuit or sparse-polynomial representations of:

```text
delta
G = Res_u(P,P_u) / H
C
ell = lc_u(P)
P_uu
```

A fully expanded polynomial is not required if an exact straight-line circuit supports:

- evaluation;
- ideal membership;
- saturation via auxiliary variables;
- good-prime reduction;
- independent identity verification.

Verify exactly:

\[
\operatorname{Res}_u(P,P_u)=H\,G.
\]

### Deliverables

```text
certificates/fold_normalization_t2r/saturation_factors/*
certificates/fold_normalization_t2r/RESULTANT_FACTOR_IDENTITY.md
certificates/fold_normalization_t2r/verify_saturation_factors.py
```

### Exit

- `T2R4-PASS`: all factors executable.
- `T2R4-FAIL`: exact missing factor and reason recorded.

---

## T2R.5 — decide the exact saturated singular dimension

Run only after `T2R4-PASS`.

### Exact object

Compute the dimension and equidimensional decomposition of

\[
I_{\rm sing}^{S_G}
=
(H,P,P_u,P_A,P_B,P_Y,P_Z):
(\ell P_{uu}\delta C G)^\infty.
\]

### Required proof components

A dimension-two conclusion requires both an upper and a lower bound.

Acceptable lower-bound certificates:

1. an exact height-three prime component meeting the open;
2. an exact Noether normalization with two algebraically independent parameters;
3. a finite dominant two-parameter parametrization;
4. an exact irreducible surface component plus gate nonvanishing.

Acceptable upper-bound certificates:

1. exact Krull dimension of the saturated ideal;
2. exhaustive equidimensional decomposition;
3. certified Noether normalization of dimension at most two.

Random or hand-selected linear sections alone are insufficient.

### Deliverables

```text
certificates/fold_normalization_t2r/SAME_OPEN_DIMENSION.md
certificates/fold_normalization_t2r/saturated_ideal.*
certificates/fold_normalization_t2r/equidimensional_components.json
certificates/fold_normalization_t2r/lower_bound_certificate.*
certificates/fold_normalization_t2r/upper_bound_certificate.*
certificates/fold_normalization_t2r/verify_same_open_dimension.py
```

### Exits

- `T2R-NONNORMAL`: dimension \(2\), hence failure of \(R_1\), proved on the same \(S_2\) open.
- `T2R-NORMAL`: singular locus dimension at most \(1\), hence \(R_1\), proved on the same open.
- `T2R-UNDECIDED`: exact remaining scheme and resource bottleneck recorded.

---

## T3/T4 — deferred branch after a director gate

No T3/T4 computation is authorized by this file until the director reviews T2R.5.

If `T2R-NONNORMAL`, the next packet must distinguish

\[
\mathfrak c_{B\subset S_G}=\operatorname{Ann}_B(S_G/B)
\]

from

\[
\mathfrak c_{S_G\subset\widetilde S_G}
=
\operatorname{Ann}_{S_G}(\widetilde S_G/S_G).
\]

If `T2R-NORMAL`, the next packet must still account for all codimension-one strata removed by the inversion of \(G\) before a class-group conclusion can be used for the headline.

---

# 5. Route C — direct twisted Fano section

This route starts only if the director gate does not continue P25 as primary.

## C1 — executable algebra with involution

Construct:

1. one exact self-adjoint Morita projector in the installed symmetric basis;
2. the quaternion corner \(D=eAe\);
3. a multiplication table and involution on \(D\);
4. a right \(D\)-basis of \(eA\simeq D^3\);
5. the five exact Hermitian matrices
   \[
   H_1,\ldots,H_5\in\operatorname{Herm}_3(D).
   \]

The auxiliary projector is only a coordinate device. It is not a positive exit.

## C2 — direct Fano equations

Independently construct the descended rank-one/Plücker equations in the installed \(15\)-dimensional symmetric basis and restrict them to the exact \(10\)-plane defining \(F_{14,T}\).

After a splitting extension, verify:

- the classical smooth degree-14 Fano threefold;
- agreement with the five Hermitian isotropy equations on all affine charts;
- no chart-at-infinity loss.

## C3 — point construction

Search in this order:

1. rational fibration / conic-bundle structure;
2. odd-degree multisection;
3. exact rational section over a smaller invariant subfield;
4. sparse exact solve on the smallest resulting fibre.

Exit `C-POSITIVE` requires an exact common isotropic right \(D\)-line.

---

# 6. Parked routes

## 6.1 Universal Path G

No further all-degree computation is authorized from the pure \((m,d)\)-semigroup presentation.

The worker has proved a free-fibre recurrence but has not constructed the full equalizer/Fitting module. Cubic Hilbert growth does not prove non-finite-generation. A future universal dispatch requires an analyst-supplied multigrading or finite-generation theorem retaining at least:

```text
plane polynomial degree
normal order
line residual degree
stabilizer character
point-link degree
source / normal / target copy
```

Until then:

```text
no degree ladder
no additional sample residuals
no G-NEGATIVE claim
```

## 6.2 Schur degree 19

Start only after the director gate if P25 and C do not advance. The permitted CAS target remains the relative universal hyperplane orbit, its full relative ideal/resolution, and the two marked Quot/Rao branches. Emptiness is non-headline; an explicit curve is positive.

## 6.3 Proper subgroups

Do not begin before the director gate. If authorized, start with the two maximal \(A_5\) conjugacy classes only.

---

# 7. Director gate

After P25R.2 and T2R.5, the worker must issue one gate report selecting **no more than one** primary continuation.

| Condition | Primary continuation |
|---|---|
| `P25-GLOBAL-SURVIVES` with manageable border support | P25R.3 |
| `P25R2-UNDECIDED` but exact system is small and structurally sparse | director decides whether to authorize up to 64/96 GiB |
| `T2R-NONNORMAL` or `T2R-NORMAL` with complete same-open certificate | director scopes T3/T4 |
| P25 empty and T2R blocked | start Route C |
| all three blocked | stop; do not substitute a larger unstructured computation |

No route is promoted merely because it used the most compute.

---

# 8. Resource policy

The machine is a fully specified M5 Max MacBook Pro with 128 GiB unified memory.

### Default gate

```text
8 GiB RSS
```

### Structured authorization

A single job may use up to

```text
64 GiB RSS
```

after emitting:

```text
matrix/module dimensions
term count and nnz
sparse memory floor
dense memory floor
checkpoint plan
expected certificate
independent verifier design
```

Absolute one-job ceiling:

```text
96 GiB RSS
```

No concurrent memory-saturating jobs.

The worker must stream sparse rows, checkpoint row spaces, and hash every completed block. A job crossing its ceiling must stop and report the last valid checkpoint.

---

# 9. Characteristic-zero and verifier discipline

Finite fields may be used for discovery, pivot selection, shape selection, and component-degree estimates.

A characteristic-zero claim requires one of:

1. direct exact computation over \(\mathbf Q\), a cyclotomic field, or the relevant function field;
2. CRT/rational reconstruction with implemented congruence checks, a uniqueness bound, and holdout primes;
3. a written DVR/properness/rank-preservation argument whose hypotheses are checked computationally.

Every producer must have an independent verifier that does not import the producer.

Candidate verification always substitutes into the **original** equations, not only eliminated consequences.

---

# 10. Final exit table

| Exit | Meaning |
|---|---|
| `P25-POLYNOMIAL` | complete positive headline candidate; hand to analyst |
| `P25-GLOBAL-EMPTY` | degree-25 exclusion only |
| `T2R-NONNORMAL` | same-open nonnormality repaired; T3 still needs director authorization |
| `T2R-NORMAL` | same-open normality repaired; removed strata still require audit |
| `T-NEGATIVE` | complete negative headline certificate after later authorized T3/T4 |
| `C-POSITIVE` | complete positive headline candidate; hand to analyst |
| `S19-POSITIVE` | complete positive headline candidate; hand to analyst |
| `H-NEGATIVE` | complete negative headline candidate; hand to analyst |
| modular-only / free-fibre-only / sample result | discovery or scoped theorem only |

**Problem E remains OPEN until one headline-capable exit is independently verified and its analytic bridge is written into the final proof.**
