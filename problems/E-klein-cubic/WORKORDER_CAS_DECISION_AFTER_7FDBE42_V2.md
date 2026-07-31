# Problem E — Decision Work Order after `7fdbe42` (V2)

**Repository:** `mattrobball/unirational`  
**Pinned research base:** `7fdbe42d324a255e08fba808302fb4e96427ee57`  
**Supersedes for execution:**

```text
WORKORDER_CAS_HEADLINE_REVISED.md
WORKORDER_CAS_DECISION_AFTER_7FDBE42.md
```

**Binding correction layer:** `REPAIR.md`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** exact computer algebra only  
**Headline:** **OPEN**

---

## 0. Correction to V1

The first post-`7fdbe42` work order contained an invalid shortcut: an arbitrary **affine** hyperplane section of an affine scheme can miss a positive-dimensional component, so one zero-dimensional affine section does not by itself prove dimension at most one.

This V2 replaces that shortcut by either:

1. an exact Krull-dimension/Noether-normalization certificate; or
2. a zero-dimensional section of the correctly saturated **projective closure**, where projective dimension theory prevents a two-dimensional component from being missed.

V2 is the only executable order.

---

# 1. Mission and accepted theorem boundaries

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),
\qquad
X=\left\{\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}=0\right\}
\subset \mathbf P(W)\simeq\mathbf P^4.
\]

The accepted headline equivalence is

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

A passing verifier certifies the computation it replays; it does not certify an analytic implication merely copied into JSON or Markdown.

## 1.1 Headline-capable exits

| Exit | Exact object | Consequence after analytic audit |
|---|---|---|
| `P25-POLYNOMIAL` | primitive degree-25 landing self-covariant with generic Jacobian rank four | positive headline |
| `T-INDEX3` | normalized residue-degree-one branch with horizontal degree subgroup \(3\mathbf Z\) | negative headline |
| `C-POSITIVE` | common isotropic right \(D\)-line / \(F_{14,T}(K_{\rm proj})\)-point | positive headline |

The following are not headline exits:

- normality or nonnormality of the fold algebra alone;
- a degree-25 exclusion;
- a free-fibre residual or cancellation;
- modular emptiness without an integral projective model and properness certificate;
- a point of the auxiliary Morita-projector cubic.

## 1.2 Binding status at `7fdbe42`

1. `T-BIRATIONAL` is retained on the common open \(S_G\).
2. \(S_G\) is \(S_2\); \(R_1\) is undecided.
3. The exact upper bound
   \[
   \dim\operatorname{Sing}(S_G)\le2
   \]
   is retained.
4. `T2R4-PASS` installs \(\ell,P_{uu},C,\delta\) exactly and \(G=\operatorname{Res}_u(P,P_u)/H\) as an exact quotient circuit.
5. The shape
   \[
   G\equiv c\,(A-15)\,B^4\,Q_4\,F_{27}^2
   \]
   is modular discovery except for the characteristic-zero factors \(A-15\), \(B\), and \(Q_4\). \(F_{27}\) must not be consumed in characteristic zero until reconstructed and verified.
6. `T-NONNORMAL` remains suspended.
7. The degree-25 packets do not contain the executable exact global \(43\)-coordinate landing system required below.
8. The commit `807451f` excludes only one selected free-fibre cancellation after projection to the rank-seven residual module. It does not kill a global family.
9. Universal Path G is parked.

---

# 2. First dispatch and priorities

Run in parallel:

```text
Track T:    T6.0 + T6.1 + T6.2
Track P25:  P25X.0 + P25X.1
```

Do not begin direct Fano solving before the director gate in §7.

The objective is to replace both current bottlenecks by exact finite objects:

- Track T decides \(R_1\) on the exact common open and then continues regardless of whether the answer is normal or nonnormal.
- Track P25 constructs the actual characteristic-zero projective landing scheme in \(\mathbf P^{42}\).

---

# 3. Track T — exploit the simple-root algebra before further saturation

## 3.0 Exact objects

Let

\[
R=\mathbf Q[A,B,Y,Z],
\qquad
P\in R[u],
\qquad
\operatorname{Res}_u(P,P_u)=H\,G.
\]

Define

\[
B_G=(R/(H))[(\ell P_{uu}C\delta G)^{-1}],
\]

\[
S_G=B_G[u]/(P,P_u).
\]

On the common open the singular ideal is represented by

\[
J=(P,P_u,P_A,P_B,P_Y,P_Z)
\subset \mathbf Q[A,B,Y,Z,u]
\]

localized at \(\ell P_{uu}C\delta G\). The equation \(H=0\) is redundant there because \(HG\in(P,P_u)\) and \(G\) is inverted.

The immediate target is

\[
\dim\operatorname{Sing}(S_G)\le1
\quad\text{or}\quad
\dim\operatorname{Sing}(S_G)=2.
\]

Since \(S_G\) is \(S_2\):

- dimension at most one gives `T2R-NORMAL`;
- dimension two gives `T2R-NONNORMAL`.

Either exit advances the index-three route. If normal, \(S_G\) is the normalization of \(B_G\) on this open. If nonnormal, only the certified height-one components require further normalization.

---

## T6.0 — first-subresultant and finite rank-one algebra audit

### Computation

1. Compute the first subresultant
   \[
   \operatorname{Sres}_1(P,P_u)=s_1(A,B,Y,Z)u+s_0(A,B,Y,Z)
   \]
   and the principal subresultant coefficients controlling \(\deg\gcd(P,P_u)\ge2\).
2. Store \(s_0,s_1\) as exact sparse polynomials or exact straight-line circuits.
3. Decide whether \(s_1\) is a unit on \(D(\ell P_{uu}C\delta G)\). Accepted certificates:
   - exact radical/Nullstellensatz certificate for the degree-\(\ge2\) gcd locus;
   - exact factor containment in the removed gate divisors;
   - exact Bézout/subresultant identity with explicitly invertible coefficient.
4. If \(s_1\) is a unit, construct and verify
   \[
   S_G\simeq B_G,
   \qquad
   u\mapsto-s_0/s_1.
   \]
5. If \(s_1\) is not a unit, compute the divisor of its failure and the finite module \(S_G/B_G\) on every component meeting the open.
6. Compute \(\Omega_{S_G/B_G}\) and verify its vanishing on the \(P_{uu}\)-open. Do not infer flatness or isomorphism from vanishing differentials alone.

### Deliverables

```text
certificates/fold_decision_t6/SUBRESULTANT_AUDIT.md
certificates/fold_decision_t6/subresultant_1.*
certificates/fold_decision_t6/principal_subresultants.json
certificates/fold_decision_t6/rank_one_algebra_map.*
certificates/fold_decision_t6/relative_differentials.json
certificates/fold_decision_t6/produce_t60.py
certificates/fold_decision_t6/verify_t60.py
```

### Exits

```text
T60-ISOMORPHISM
T60-PARTIAL-NORMALIZATION
T60-UNDECIDED
```

Do not infer normality from `T60-ISOMORPHISM`.

---

## T6.1 — factorwise exact localization

### Computation

1. Begin with
   \[
   J_0=(P,P_u,P_A,P_B,P_Y,P_Z).
   \]
2. Saturate sequentially by
   \[
   \ell,\quad P_{uu},\quad C,\quad\delta,\quad A-15,\quad B,\quad Q_4.
   \]
3. After each saturation record:
   - exact Krull dimension if available;
   - exact projective-closure dimension;
   - degrees of certified sections;
   - associated-prime dimensions;
   - whether the ideal is the unit ideal.
4. Before reconstructing \(F_{27}\), determine whether the remaining locus is contained in \(G=0\) using the quotient circuit, resultant identity, or subresultant identities.
5. Reconstruct \(F_{27}\in\mathbf Z[A,B,Y,Z]\) only if required. The reconstruction must:
   - cross an explicit coefficient-height uniqueness bound;
   - use holdout primes;
   - agree exactly with the line factor of degree \(11\);
   - divide the exact quotient circuit.
6. Saturate by \(F_{27}\) sequentially, not by a single giant gate product.
7. Modular primary decomposition is discovery only. Lifted components require exact generators and ideal containments.

### Deliverables

```text
certificates/fold_decision_t6/FACTORWISE_SATURATION.md
certificates/fold_decision_t6/saturation_ledger.json
certificates/fold_decision_t6/ideals_after_each_gate/*
certificates/fold_decision_t6/F27/*
certificates/fold_decision_t6/produce_t61.py
certificates/fold_decision_t6/verify_t61.py
```

### Resource gate

One structured job may use up to **64 GiB RSS** after a written preflight. Do not rerun the one-shot full-product Rabinowitsch saturation.

---

## T6.2 — exact binary \(R_1\) decision

Run on the final factorwise-saturated affine ideal \(J_{\rm open}\).

### Normal certificate: prove \(\dim J_{\rm open}\le1\)

Accepted certificates:

1. exact Krull dimension at most one;
2. exact Noether normalization of dimension at most one;
3. the unit ideal; or
4. the following projective certificate:

   - homogenize \(J_{\rm open}\) with a new variable \(w\);
   - remove spurious homogenization components by
     \[
     \overline J=(J_{\rm open}^{h}:w^\infty);
     \]
   - choose an exact projective hyperplane \(\Lambda\);
   - prove
     \[
     \operatorname{Proj}\frac{\mathbf Q[A,B,Y,Z,u,w]}{(\overline J,\Lambda)}
     \]
     is zero-dimensional or empty.

A two-dimensional projective component meets every projective hyperplane in dimension at least one, so this certificate excludes all two-dimensional components. No claim of genericity is needed.

An affine hyperplane section is not an accepted dimension certificate unless an independent proof shows it meets every positive-dimensional component.

### Nonnormal certificate: prove dimension two

Since the upper bound \(\le2\) is retained, it suffices to produce one exact height-three prime component meeting the open. Accepted certificates:

- exact prime generators, height three, and gate noncontainment;
- a two-parameter Noether normalization of an integral component;
- a finite dominant map from an integral two-dimensional algebra.

### Deliverables

```text
certificates/fold_decision_t6/R1_DECISION.md
certificates/fold_decision_t6/r1_decision.json
certificates/fold_decision_t6/projective_closure/*
certificates/fold_decision_t6/normal_certificate/*
certificates/fold_decision_t6/nonnormal_component/*
certificates/fold_decision_t6/verify_t62.py
```

### Exits

```text
T2R-NORMAL
T2R-NONNORMAL
T2R-UNDECIDED
```

---

## T6.3 — continue to the index-three obstruction

Run after either normality exit.

### If `T2R-NORMAL`

Use \(S_G\) as the normalized branch model. Compute:

1. the boundary/conductor data of a proper compactification;
2. the pullback of the cubic discriminant;
3. every height-one contact multiplicity modulo \(3\);
4. every codimension-two local \(3\)-primary divisor-class defect;
5. residual codimension-three punctured Picard exponents.

### If `T2R-NONNORMAL`

1. normalize the certified height-one local domains;
2. globalize their integral generators;
3. verify normality of the resulting finite algebra;
4. perform the same contact and class-group calculation.

The decisive output is

\[
\left(\operatorname{Cl}(T_{\widetilde D})/\operatorname{Pic}(T_{\widetilde D})\right)[3]=0
\]

with vertical classes accounted for. Exit `T-INDEX3` only after this is proved.

---

# 4. Track P25 — construct the actual global projective landing scheme

## 4.0 Objective

Construct and decide the characteristic-zero projective scheme of degree-25 landing self-covariants in the genuine \(43\)-dimensional global coefficient space.

Do not split into `based` and `residual` families before the complete projective landing ideal exists. Those labels may classify components afterward.

---

## P25X.0 — executable characteristic-zero coefficient model

Work over the minimal exact cyclotomic field \(K\) required by the representation.

### Required objects

1. an exact basis
   \[
   p_1,\ldots,p_{43}
   \]
   of \(V_{25}\), expressed in the original Reynolds basis;
2. exact change-of-basis matrices among original, strict, \(Q\oplus K\), and border coordinates;
3. the actual block restriction matrix
   \[
   \rho_{\le25}:V_{25}\to\bigoplus_{r=1}^{25}J_r.
   \]
   The nominal \(868\times43\) matrix must be materialized or supplied as a replayable exact arithmetic circuit. A list of block names and dimensions is not a matrix;
4. the actual residual restriction matrix to the degree-19 det-twisted \(D_{12}\)-module;
5. exact source-line, \(V_4\), point-kernel, and character-block maps not already forced by the definition of \(V_{25}\).

Modular pivots may select bases. The final entries must be reconstructed and independently verified over \(K\).

### Deliverables

```text
certificates/degree25_exact/COEFFICIENT_MODEL.md
certificates/degree25_exact/covariant_basis/*
certificates/degree25_exact/change_of_basis/*
certificates/degree25_exact/rho_1_to_25.*
certificates/degree25_exact/residual_and_incidence_maps/*
certificates/degree25_exact/produce_p25x0.py
certificates/degree25_exact/verify_p25x0.py
```

### Exit

```text
P25X0-PASS
P25X0-FAIL
```

No later P25 stage may run after `P25X0-FAIL`.

---

## P25X.1 — exact cubic landing ideal

Let

\[
p_c=\sum_{i=1}^{43}c_i p_i.
\]

Construct the coefficient ideal of

\[
F(p_c(x))
\]

as cubic forms in \(c_1,\ldots,c_{43}\).

### Accepted implementations

1. sparse direct coefficient collection in the source monomial basis; or
2. substitution of the exact global jet map into every normal-order equation, followed by an exact identity comparison with direct landing.

### Required checks

1. store a sparse row-reduced characteristic-zero basis of the cubic equations;
2. recover the historical rank-842 row spaces at good primes \(89,199,331\);
3. prove exact containment in both directions between the direct landing ideal and the rank-28 border presentation, or stop before support and state the residual gap;
4. use one fixed coordinate convention throughout.

### Deliverables

```text
certificates/degree25_exact/LANDING_IDEAL.md
certificates/degree25_exact/landing_cubics.*
certificates/degree25_exact/rowspace_comparison.json
certificates/degree25_exact/equivalence_to_border.*
certificates/degree25_exact/produce_p25x1.py
certificates/degree25_exact/verify_p25x1.py
```

### Exit

```text
P25X1-PASS
P25X1-FAIL
```

---

## P25X.2 — projective support

Run only after `P25X1-PASS`.

1. Choose an integral model at good primes \(89\) and \(199\), with \(331\) as holdout.
2. Compute the irrelevant-saturated projective support of the **complete** landing ideal, preferably through the verified rank-28 border presentation.
3. If one complete good special fibre is empty, emit the integral model and saturation certificate needed for the analyst to apply properness and conclude the characteristic-zero degree-25 fibre is empty.
4. If support survives, compute dimensions, degrees, components, and residue fields at two primes.
5. Attempt Hensel lifting and exact reconstruction of isolated smooth points.
6. For every characteristic-zero candidate verify directly:
   \[
   F(p_c)=0,
   \quad p_c\ne0,
   \quad\gcd(p_{c,0},\ldots,p_{c,4})=1,
   \quad\operatorname{rank}Dp_c=4,
   \]
   together with exact equivariance.

### Exits

```text
P25-POLYNOMIAL
P25-EMPTY
P25-SUPPORT
P25X2-UNDECIDED
```

`P25-EMPTY` is a degree-25 exclusion only.

---

# 5. Conditional Track C — direct twisted Fano section

Begin only if both Track T and Track P25 remain undecided at the director gate.

1. construct one exact self-adjoint reduced-rank-two idempotent in the installed \(15\)-basis;
2. construct the quaternion corner \(D=eAe\), a right \(D\)-basis of \(eA\simeq D^3\), and the five exact Hermitian matrices;
3. independently construct the descended rank-one/Plücker equations of \(F_{14,T}\);
4. verify equality after a splitting extension;
5. search first for a rational fibration, conic bundle, or odd-degree multisection, not a raw five-equation elimination.

Exit `C-POSITIVE` only after an exact common isotropic line is verified.

---

# 6. House rules

1. No free-fibre object may be called global.
2. Metadata describing a matrix is not the matrix.
3. Good-prime factorization is discovery until reconstructed and checked in characteristic zero.
4. Never infer dimension two from selected codimension-two sections.
5. Never infer dimension at most one from an arbitrary affine hyperplane section.
6. Projective hyperplane certificates must use the saturated projective closure.
7. Normality is useful on Track T: finite birational plus normal identifies the normalization.
8. Do not form a giant full-product Rabinowitsch equation when sequential saturation or subresultants are available.
9. Do not split P25 into state families before installing the complete projective landing ideal.
10. Every producer has an independent verifier that recomputes the decisive invariant rather than reading it from JSON.
11. Use path-scoped commits; no `git add -A` while workers run in parallel.

---

# 7. Director gate

After `T6.0–T6.2` and `P25X.0–P25X.1`, select exactly one primary continuation.

| Result | Continuation |
|---|---|
| `P25-POLYNOMIAL` | stop and assemble the positive proof |
| `P25X1-PASS` with manageable support | prioritize `P25X.2` |
| `T2R-NORMAL` | prioritize normalized branch contacts and class group |
| `T2R-NONNORMAL` | prioritize height-one normalization, then contacts and class group |
| both tracks undecided | begin conditional Track C |
| one route has a structurally finite resource wall | authorize at most one 64–96 GiB job after preflight |

No universal Path G degree ladder, Path A elimination, or subgroup sweep is authorized.

---

# 8. Resources and certificates

Default exploratory ceiling: **8 GiB RSS**.  
Structured single-job ceiling after preflight: **64 GiB RSS**.  
Absolute one-job ceiling with director approval: **96 GiB RSS**.  
No concurrent memory-saturating jobs.

Every preflight records:

```text
ring and monomial order
matrix/module dimensions
term and nnz counts
sparse and dense memory floors
checkpoint plan
expected exact certificate
independent verifier plan
```

Every CRT reconstruction records all primes, excludes bad primes, crosses an explicit uniqueness bound, uses holdouts, and verifies the resulting characteristic-zero identity.

**Problem E remains OPEN until one headline-capable exit is independently verified and its analytic bridge is written into the final proof.**
