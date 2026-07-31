# Problem E — Decision Work Order after `7fdbe42`

**Repository:** `mattrobball/unirational`  
**Pinned base:** `7fdbe42d324a255e08fba808302fb4e96427ee57`  
**Supersedes for the next dispatch:** `WORKORDER_CAS_HEADLINE_REVISED.md`  
**Binding correction layer:** `REPAIR.md`  
**Problem:** PSL\((2,11)\)-unirationality of the Klein cubic threefold  
**Worker role:** exact computer algebra only  
**Headline:** **OPEN**

---

## 0. Mission and theorem discipline

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

This order requests exact CAS artifacts only. A passing verifier certifies the computation it replays; it does not certify analytic implications merely quoted in prose. Every producer must have an independent verifier that does not import the producer.

### 0.1 Headline-capable outputs

| Exit | Exact CAS object | Analytic use |
|---|---|---|
| `P25-POLYNOMIAL` | one primitive degree-25 landing self-covariant with generic Jacobian rank four | proves the positive headline |
| `T-INDEX3` | normalized residue-degree-one branch with horizontal divisor-degree subgroup \(3\mathbf Z\) | proves the negative headline |
| `C-POSITIVE` | a common isotropic right \(D\)-line / point of \(F_{14,T}(K_{\rm proj})\) | proves the positive headline |

The following are not headline outputs:

- normality or nonnormality of the fold algebra by itself;
- a finite-degree exclusion;
- a modular point or modular empty fibre without the required properness/lifting certificate;
- a free-fibre residual or free-fibre cancellation;
- a formal state or formal lift;
- a point of the auxiliary Morita-projector cubic.

### 0.2 Binding status at the pinned base

1. `T-BIRATIONAL` is retained on the common open \(S_G\).
2. \(S_G\) is \(S_2\); \(R_1\) is undecided.
3. The exact upper bound
   \[
   \dim\operatorname{Sing}(S_G)\le2
   \]
   is retained.
4. `T2R4-PASS` installs \(\ell,P_{uu},C,\delta\) exactly and \(G=\operatorname{Res}_u(P,P_u)/H\) as an exact quotient circuit. The displayed factorization
   \[
   G\equiv c\,L\,M^4Q_4F_{27}^2
   \]
   is a good-prime shape; only \(L=A-15\), \(M=B\), and \(Q_4\) are presently expanded in characteristic zero. Do not consume \(F_{27}\) as an exact characteristic-zero polynomial until it is reconstructed and verified.
5. The old `T-NONNORMAL` claim remains suspended.
6. The degree-25 packets do not contain an executable exact global \(43\)-coordinate landing system. `P25R0-PASS`, `P25R1-PASS`, and `P25R2_FULL_TOWER_VERIFIED` are not accepted as execution gates for this order.
7. The calculation at commit `807451f` proves only that one selected P25.1 free-fibre residual cancellation does not lie in the residual \(D_{12}\)-module. It does not kill the residual family globally.
8. Universal Path G is parked. Its free-fibre recurrence may be reused as a local formula, but no degree ladder or free-fibre support calculation is authorized.

---

# 1. Revised priority and first dispatch

Run two tracks in parallel:

```text
Track T: T6.0 + T6.1 + T6.2
Track P25: P25X.0 + P25X.1
```

Do not start direct Fano coordinate solving before the director gate in §6.

The objective is not another sample. Each track must terminate in a binary, theorem-shaped finite object:

- Track T decides \(R_1\) on the exact common open, then proceeds to the index-three calculation on the resulting normalization.
- Track P25 constructs the actual characteristic-zero projective landing scheme in the genuine \(43\)-dimensional global coefficient space.

---

# 2. Track T — decide the simple-fold geometry without a giant product saturation

## 2.0 Objects

Use

\[
R=\mathbf Q[A,B,Y,Z],
\qquad
P\in R[u],
\qquad
\operatorname{Res}_u(P,P_u)=H\,G,
\]

\[
B_G=(R/(H))[(\ell P_{uu}C\delta G)^{-1}],
\]

and

\[
S_G=\left(B_G[u]/(P,P_u)\right).
\]

The singular ideal on this open is represented by

\[
J=(P,P_u,P_A,P_B,P_Y,P_Z)
\subset \mathbf Q[A,B,Y,Z,u]
\]

followed by localization at \(\ell P_{uu}C\delta G\). The equation \(H=0\) is redundant on this open because \(HG\in(P,P_u)\) and \(G\) is inverted.

The current upper bound is

\[
\dim V(J)\cap D(\ell P_{uu}C\delta G)\le2.
\]

The immediate binary target is:

\[
\dim\operatorname{Sing}(S_G)\le1
\quad\text{or}\quad
\dim\operatorname{Sing}(S_G)=2.
\]

Because \(S_G\) is \(S_2\), the first outcome proves \(S_G\) normal; the second proves it nonnormal. **Either outcome advances Track T**:

- if normal, \(S_G\) is the normalization of \(B_G\) on this open;
- if nonnormal, normalize only the certified height-one singular components.

Normality is not a failure of Track T.

---

## T6.0 — global first-subresultant and rank-one algebra audit

### Purpose

Before attempting another saturation, determine whether the finite birational algebra is already equal to the branch algebra on the simple-fold open.

### Computation

1. Compute the first nonzero subresultant of \(P,P_u\) in \(u\):
   \[
   \operatorname{Sres}_1(P,P_u)=s_1(A,B,Y,Z)u+s_0(A,B,Y,Z).
   \]
   Store \(s_1,s_0\) as exact sparse polynomials or exact straight-line circuits.
2. Compute the principal subresultant coefficient \(s_1\) and the next subresultant data controlling \(\deg\gcd(P,P_u)\ge2\).
3. Decide whether \(s_1\) is a unit on \(D(\ell P_{uu}C\delta G)\). Acceptable certificates:
   - an exact radical/Nullstellensatz certificate
     \[
     (J_{\rm gcd\ge2}):(\ell P_{uu}C\delta G)^\infty=(1);
     \]
   - exact factor containment showing every irreducible factor of \(s_1\) is removed by the gates;
   - a Bézout/subresultant identity whose coefficient is explicitly invertible on the open.
4. If \(s_1\) is a unit, construct and verify the mutually inverse maps
   \[
   S_G\rightleftarrows B_G,
   \qquad
   u\longmapsto-s_0/s_1.
   \]
5. If \(s_1\) is not a unit, decompose the divisor \(s_1=0\) on \(S_G\), identify which components meet the open, and compute the finite module \(S_G/B_G\) along them.
6. Compute
   \[
   \Omega_{S_G/B_G}.
   \]
   On the \(P_{uu}\)-open, verify directly that it vanishes; keep this separate from flatness or isomorphism.

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

- `T60-ISOMORPHISM`: \(S_G\simeq B_G\) proved.
- `T60-PARTIAL-NORMALIZATION`: non-isomorphism divisor explicitly installed.
- `T60-UNDECIDED`: exact remaining subresultant saturation named.

Do not infer normality from `T60-ISOMORPHISM`.

---

## T6.1 — exact factorwise removal of the gate complement

### Purpose

Replace the infeasible single Rabinowitsch gate for \(\ell P_{uu}C\delta G\) by a factorwise computation that records what is removed at every step.

### Computation

1. Begin with
   \[
   J_0=(P,P_u,P_A,P_B,P_Y,P_Z).
   \]
2. Saturate sequentially by the exact factors
   \[
   \ell,\quad P_{uu},\quad C,\quad\delta,\quad L=A-15,\quad M=B,\quad Q_4.
   \]
   After every step record:
   - Krull dimension;
   - degree of one- and two-hyperplane sections;
   - associated-prime dimensions where available;
   - whether the ideal becomes the unit ideal.
3. Decide whether the remaining locus is contained in the exact quotient-circuit divisor \(G=0\) before reconstructing \(F_{27}\). Use exact membership via
   \[
   \operatorname{Res}_u(P,P_u)=H\,G
   \]
   and subresultant identities whenever possible.
4. Reconstruct \(F_{27}\in\mathbf Z[A,B,Y,Z]\) only if the remaining locus cannot be removed through the quotient circuit. Requirements:
   - enough good primes to cross an explicit coefficient-height uniqueness bound;
   - holdout primes not used in CRT;
   - exact agreement with the accepted line factor of degree \(11\);
   - exact verification that the reconstructed factor divides the quotient circuit.
5. Saturate sequentially by the reconstructed \(F_{27}\), not by the full product.
6. Modular primary decomposition is discovery only. A characteristic-zero component is accepted only after exact generators and exact ideal-containment checks are supplied.

### Deliverables

```text
certificates/fold_decision_t6/FACTORWISE_SATURATION.md
certificates/fold_decision_t6/saturation_ledger.json
certificates/fold_decision_t6/ideals_after_each_gate/*
certificates/fold_decision_t6/F27/*              # conditional
certificates/fold_decision_t6/produce_t61.py
certificates/fold_decision_t6/verify_t61.py
```

### Resource rule

A single structured factorwise job may use up to **64 GiB RSS** after emitting:

```text
input term counts
monomial order
predicted matrix dimensions
sparse and dense floors
checkpoint plan
independent verifier design
```

Do not authorize the old one-shot product saturation.

---

## T6.2 — binary \(R_1\) decision by the cheapest exact certificate

Run on the final factorwise-saturated ideal \(J_{\rm open}\).

### Normal exit: prove \(\dim J_{\rm open}\le1\)

The preferred certificate is one exact affine linear form \(L_0\) such that

\[
J_{\rm open}+(L_0)
\]

is zero-dimensional. Since one equation raises height by at most one, this proves

\[
\operatorname{height}J_{\rm open}\ge4,
\qquad
\dim J_{\rm open}\le1.
\]

No genericity assertion is needed. Verify zero-dimensionality over \(\mathbf Q\), and verify that the computation is on the fully saturated same open.

Alternative accepted certificates:

- the saturated ideal is the unit ideal;
- an exact Krull-dimension computation gives dimension at most one;
- a finite Noether normalization of dimension at most one.

### Nonnormal exit: prove \(\dim J_{\rm open}=2\)

Because the upper bound \(\le2\) is already proved, it suffices to produce one exact height-three prime \(\mathfrak p\supset J_{\rm open}\) meeting the open. Acceptable certificates:

- exact prime generators, height three, and noncontainment of every gate;
- an exact two-parameter Noether normalization of an irreducible component;
- a finite dominant map from a two-dimensional integral algebra into the singular locus.

Random sections and modular degree stability are not lower-bound proofs.

### Deliverables

```text
certificates/fold_decision_t6/R1_DECISION.md
certificates/fold_decision_t6/r1_decision.json
certificates/fold_decision_t6/normal_certificate/*
certificates/fold_decision_t6/nonnormal_component/*
certificates/fold_decision_t6/verify_t62.py
```

### Exits

- `T2R-NORMAL`: \(S_G\) is normal and is the normalization of \(B_G\) on the common open.
- `T2R-NONNORMAL`: a height-one singular component is certified.
- `T2R-UNDECIDED`: smallest exact saturated ideal and resource wall recorded.

---

## T6.3 — continue to the actual index-three question

Run only after `T2R-NORMAL` or `T2R-NONNORMAL`.

### If `T2R-NORMAL`

Use \(S_G\) as the normalized branch model. Compute:

1. the conductor of the compactification boundary, keeping it distinct from \(\operatorname{Ann}_{B_G}(S_G/B_G)\);
2. the pullback of the cubic discriminant;
3. every height-one contact multiplicity modulo \(3\);
4. the local \(3\)-primary divisor-class defect at every codimension-two contact;
5. residual codimension-three punctured Picard exponents.

### If `T2R-NONNORMAL`

1. normalize only the certified height-one local domains;
2. adjoin their integral generators globally;
3. verify the resulting finite algebra is normal;
4. then perform the same discriminant/contact/class-group calculation.

### Decisive exit

Produce

\[
\left(\operatorname{Cl}(T_{\widetilde D})/\operatorname{Pic}(T_{\widetilde D})\right)[3]=0
\]

with vertical classes accounted for. Then output `T-INDEX3`.

---

# 3. Track P25 — install the real global landing scheme, not another metadata packet

## 3.0 Objective

Construct and decide the characteristic-zero projective scheme of degree-25 landing self-covariants in the genuine global coefficient space.

Do not split into the based and residual ledgers before the full projective landing scheme is installed. Family labels classify components after support is found; they do not replace the global equations.

---

## P25X.0 — exact executable global coefficient model

### Required output

Work over the minimal exact cyclotomic field \(K\) required by the representation. Produce actual entries or replayable arithmetic circuits for:

1. an exact basis
   \[
   p_1,\ldots,p_{43}
   \]
   of the strict global coefficient space \(V_{25}\), expressed in the original degree-25 Reynolds basis;
2. the exact change-of-basis matrices among:
   - original Reynolds coordinates;
   - strict \(43\)-coordinates;
   - \(Q\oplus K\) coordinates;
   - rank-28 border coordinates;
3. the actual block restriction matrix
   \[
   \rho_{\le25}:V_{25}\longrightarrow\bigoplus_{r=1}^{25}J_r.
   \]
   The nominal \(868\times43\) matrix is small enough to materialize. A JSON list of block names and dimensions is not a matrix.
4. the actual residual restriction matrix to the degree-\(19\) det-twisted \(D_{12}\)-module;
5. exact source-line, \(V_4\), point-kernel, and character-block matrices not already forced by the definition of \(V_{25}\).

### Characteristic-zero requirement

Modular pivots may choose the bases, but the delivered matrices must be reconstructed and verified over \(K\). Nakayama or good reduction proves ranks; it does not supply missing entries.

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

- `P25X0-PASS`: the exact model is executable.
- `P25X0-FAIL`: missing exact matrix or basis named. No later P25 task may run.

---

## P25X.1 — construct the exact cubic landing ideal directly

Run only after `P25X0-PASS`.

Let

\[
p_c=\sum_{i=1}^{43}c_i p_i.
\]

Construct the coefficient ideal of

\[
F(p_c(x))
\]

as cubic forms in \(c_1,\ldots,c_{43}\).

### Two accepted implementations

1. **Direct coefficient collection:** expand \(F(p_c(x))\) sparsely in the source monomial basis and row-reduce the cubic coefficient equations over \(K\).
2. **Polar implementation:** substitute the actual exact block map \(\rho_{\le25}(c)\) into every normal-order equation
   \[
   F_N(c)=0,\qquad N=4,6,\ldots,74,
   \]
   and prove coefficientwise equality with direct landing on enough exact source charts to give an identity, not a sample.

### Required comparisons

1. Compare the exact row space with the historical modular rank-842 system at good primes \(89,199,331\).
2. Prove exact row/ideal containment in both directions between the direct landing ideal and the rank-28 border presentation, or state the exact residual gap before support is computed.
3. Store a sparse row-reduced characteristic-zero basis of the cubic ideal.

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

- `P25X1-PASS`: exact projective landing ideal installed.
- `P25X1-FAIL`: exact smallest missing identity named.

---

## P25X.2 — decide projective support

Run only after `P25X1-PASS`.

### Modular-first properness gate

Use integral equations at good primes \(89\) and \(199\), with \(331\) as a holdout.

1. Compute the saturated projective support of the complete landing ideal, preferably through the rank-28 border module.
2. If one complete good special fibre is empty, emit:
   - the exact integral model;
   - the irrelevant saturation certificate;
   - the proof data needed for the analyst to apply properness of projective closure and conclude the characteristic-zero degree-25 fibre is empty.
3. A single bad prime or a prime with rank drop is not admissible.
4. If support survives, compute its dimensions, degrees, associated components, and residue fields at two primes.
5. Attempt Hensel lifting of isolated smooth points and exact reconstruction over \(K\).

### Characteristic-zero candidate verification

For every reconstructed point \(c\):

\[
F(p_c)=0,\qquad
p_c\ne0,\qquad
\gcd(p_{c,0},\ldots,p_{c,4})=1,\qquad
\operatorname{rank}Dp_c=4,
\]

and exact equivariance against group generators.

### Deliverables

```text
certificates/degree25_exact/PROJECTIVE_SUPPORT.md
certificates/degree25_exact/special_fibres/p89/*
certificates/degree25_exact/special_fibres/p199/*
certificates/degree25_exact/special_fibres/p331_holdout/*
certificates/degree25_exact/char0_candidates/*
certificates/degree25_exact/verify_p25x2.py
```

### Exits

- `P25-POLYNOMIAL`: exact dominant landing covariant; stop all other routes.
- `P25-EMPTY`: exact degree-25 exclusion only.
- `P25-SUPPORT`: nonempty support component installed; continue exact lifting.
- `P25X2-UNDECIDED`: smallest exact support ideal and resource wall recorded.

---

# 4. Conditional Track C — direct twisted Fano section

Begin only if both Track T and Track P25 return undecided at the director gate.

1. Produce one exact self-adjoint reduced-rank-two idempotent in the installed \(15\)-basis.
2. Construct the quaternion corner \(D=eAe\), a right \(D\)-basis of \(eA\simeq D^3\), and the five exact Hermitian matrices.
3. Independently construct the descended rank-one/Plücker equations of \(F_{14,T}\).
4. Verify equality of the two models after a splitting extension.
5. Search first for a rational fibration, conic bundle, or odd-degree multisection; do not begin with a raw five-quadrics-in-eight-variables elimination.

Exit `C-POSITIVE` only after an exact common isotropic line is verified.

---

# 5. Universal house rules

1. No free-fibre object may be called global.
2. Metadata describing a matrix is not the matrix.
3. Every asserted characteristic-zero rank must have an exact matrix or a valid DVR rank argument with both lower and upper bounds.
4. Good-prime factorization is discovery until reconstructed and checked in characteristic zero.
5. Never infer dimension two from hand-selected codimension-two sections.
6. For an upper bound \(\dim J\le1\), one exact zero-dimensional single-hyperplane section is sufficient by PIT and needs no genericity claim.
7. A nonnormal fold is not yet the index-three obstruction; a normal fold is not failure and may be the desired normalization.
8. Do not form a giant Rabinowitsch equation for the full gate product when sequential saturation or subresultants are available.
9. Do not split the degree-25 projective scheme into state families before the full landing ideal is installed.
10. Every producer has an independent verifier; no verifier may merely read the claimed dimension or exit from JSON.
11. No wall-clock fields in sealed payloads.
12. Use path-scoped commits; never `git add -A` while parallel workers are active.

---

# 6. Director gate

After `T6.0–T6.2` and `P25X.0–P25X.1`, choose exactly one primary continuation.

| Gate result | Continuation |
|---|---|
| `P25-POLYNOMIAL` | stop; assemble positive proof |
| `P25X1-PASS` with manageable support | prioritize `P25X.2` |
| `T2R-NORMAL` | prioritize normalized branch discriminant/contact calculation `T6.3` |
| `T2R-NONNORMAL` | prioritize height-one normalization, then `T6.3` |
| T and P25 both undecided | start conditional Track C |
| one route has only a resource wall with a structurally finite job | authorize at most one 64–96 GiB job after preflight |

No universal G degree ladder, Path A elimination, or broad subgroup sweep is authorized by this order.

---

# 7. Resource and certificate policy

Default exploratory ceiling: **8 GiB RSS**.  
Structured single-job ceiling after preflight: **64 GiB RSS**.  
Absolute one-job ceiling with director approval: **96 GiB RSS**.  
No concurrent memory-saturating jobs.

A preflight must report:

```text
ring and variable order
matrix / module dimensions
term count and nnz
sparse memory floor
dense memory floor
checkpoint plan
expected exact certificate
independent verifier plan
```

For CRT reconstruction:

- record every prime;
- exclude bad leading-form primes;
- cross an explicit uniqueness bound;
- use holdout primes;
- verify exact divisibility or identity over characteristic zero.

**Problem E remains OPEN until one headline-capable exit in §0.1 is independently verified and its analytic bridge is written into the final proof.**
