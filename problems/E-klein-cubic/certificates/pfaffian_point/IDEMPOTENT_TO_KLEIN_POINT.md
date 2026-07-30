# From abstract idempotent to Klein point — exact dictionary

**Packet:** Attempt 1, Gates 1–2  
**Date:** 2026-07-30  
**Headline:** OPEN  
**Gate 1:** `FAIL-SCOPE`  
**Gate 2:** `P1-REDUCED`

---

## 0. Purpose and boundary

This note records, without a large coordinate solve, the exact relationship
between:

1. a σ-self-adjoint reduced-rank-two idempotent in the descended algebra;
2. the installed 15-variable symmetric cubic `c_3(a) = 0`, `c_2(a) ≠ 0`;
3. the quaternion corner and five Hermitian forms;
4. a common isotropic right `D`-line;
5. a `K_proj`-point of the generic Klein twist.

**Theorem boundary.** Everything here is structural. No explicit matrix over
the executable `K_proj` model is produced. No claim of `ed_C(G) = 3` is made.

---

## 1. Objects

```text
G        = PSL_2(F_11)
W        = honest 5-dimensional Klein representation
K        = K_proj = C(P(W))^G
A        = A_proj          degree-6 CSA, period = index = 2
σ        = symplectic involution of the first kind on A
Sym      = Sym(A, σ)       15-dimensional K-space
D        = quaternion division algebra with A ≅ M_3(D)
h_struct = structure Hermitian form on D³ with σ = ad_{h_struct}
H_T      = <h_1,…,h_5>_K ⊂ Herm_3(D)   (descended B_5 five-plane)
C_gen    = generic Klein twist over K
F14_T    = twisted Fano partner
```

Accepted: `A ≅ M_3(D)`, `SB_2(A) ≅ P²_D` rational with chart `D²`, every
individual `h ∈ H_T` is isotropic over `K` (Springer + deg-55), common line
open.

---

## 2. What an abstract σ-self-adjoint reduced-rank-two idempotent is

### 2.1 Definition

```text
e ∈ A,   e² = e,   σ(e) = e,   reduced rank(e) = 2.
```

“Reduced rank two” means that in any splitting of `A` to `M_6`, the ordinary
rank is four and the Pfaffian characteristic polynomial of `e` has simple zero
root with complementary double root `1` (equivalently `c_2(e) ≠ 0` after
normalizing the projector calculus of §3).

### 2.2 Morita translation

```text
(A, σ) ≅ (End_D(D³), ad_{h_struct}).
```

Under this identification:

```text
e  =  orthogonal projector onto a right line L_e ⊂ D³
      that is nondegenerate for h_struct.
```

Thus `e` is equivalent to a `K`-point of a Zariski-open subset

```text
U_struct  ⊂  P²_D ≅ SB_2(A).
```

The ambient `P²_D` is `K`-rational (affine chart `(1 : x : y)`, `x,y ∈ D`).
Existence of at least one such `e` over `K` is the Hermitian Gram–Schmidt
argument in characteristic zero (`tmp/pfaffian_rank2_hostile_audit`).

### 2.3 What it is not

`L_e` need not satisfy `h_i(q,q) = 0` for the five Klein forms. So `e` is
**not** a Fano point and **not** a Klein point.

---

## 3. Installed symmetric cubic and equivalence with `c_3 = 0`, `c_2 ≠ 0`

### 3.1 Pfaffian characteristic polynomial

For `a ∈ Sym(A,σ)` the reduced characteristic polynomial is a square. Its
Pfaffian square root is

```text
p_a(T) = T³ − c_1(a) T² + c_2(a) T − c_3(a),
```

with

```text
c_1(a) = Trd(a)/2,
c_2(a) = (2 c_1(a)² − Trd(a²))/4,
c_3(a) = Nrp_σ(a) = Pf(Q a)/Pf(Q)
```

in the installed frame. Book of Involutions, Proposition 2.9 and Chapter 32
(type `C_3`): `p_a(a) = 0`.

### 3.2 Functional calculus projector

Put `q(T) = T² − c_1 T + c_2`. Whenever

```text
c_3(a) = 0  and  c_2(a) ≠ 0,
```

one has `p_a(T) = T · q(T)` with `q` coprime to `T` at the zero root, and

```text
q(T)² ≡ c_2 · q(T)  (mod  p_a(T)).
```

Hence

```text
e := q(a)/c_2(a) = (a² − c_1(a) a + c_2(a) · 1) / c_2(a)
```

is a σ-self-adjoint reduced-rank-two idempotent.

### 3.3 Converse

If `e` is such an idempotent, then `a = e` satisfies

```text
p_e(T) = T (T − 1)²    (after the standard normalization of reduced rank),
```

so `(c_1, c_2, c_3) = (2, 1, 0)` and in particular `c_3 = 0`, `c_2 ≠ 0`.
More generally any `a` in the open of elements with the same spectral
projector yields the same `e`.

### 3.4 Installed 15-variable system

With a `K`-basis `(S_0, …, S_14)` of `Sym(A,σ)`,

```text
a(u) = Σ_{i=0}^{14} u_i S_i,
c_3(a(u)) = 0,     c_2(a(u)) ≠ 0
```

is a single cubic hypersurface in `A^{15}` plus a nonvanishing open. This is
exactly the coordinate form of the space of structure projectors of §2, not
of `F14_T`.

### 3.5 Abstract solubility of the installed cubic

Because abstract `e` exists over `K`, the scheme

```text
{ u ∈ A^{15} : c_3(a(u)) = 0,  c_2(a(u)) ≠ 0 }
```

is nonempty over `K`. This is an existence statement **without coordinates**
in the installed basis. It is **not** a point of `C_gen`.

---

## 4. Quaternion corner from an idempotent

Given `e` as in §2:

```text
D_e  := e A e          (quaternion algebra, isomorphic to D)
P    := e A            (right D_e-module of reduced rank 3 ≅ D_e³ after basis)
```

Choose a `D_e`-basis of `P`. Transport `σ` to a structure form `h_struct` and
transport the descended five-plane `B_5` (via the Plücker / trace pairing) to

```text
H_T = <h_1, h_2, h_3, h_4, h_5>  ⊂  Herm_3(D_e).
```

This is the **quaternion corner**. Explicit generators `(i,j)` with
`i² = a`, `j² = b`, `ji = −ij` in the executable field model are
**not** constructed in this dispatch (they need an explicit `e` in the
installed frame, still missing as coordinates).

---

## 5. Common isotropic line — the reduced intrinsic system

### 5.1 Equations

A right line `L = q D ⊂ D³` is a common isotropic line for `H_T` iff

```text
h_i(q, q) = 0    for i = 1, …, 5.
```

Each value `h_i(q,q)` lies in the fixed field of the standard involution of
`D`, i.e. in `K`. On the standard affine chart of `P²_D`,

```text
q = (1, x, y),    x, y ∈ D,
```

one obtains **five scalar equations in eight scalar unknowns**
(`dim_K D = 4`, so `(x,y)` contributes 8 coordinates).

### 5.2 Equivalence with Fano / Klein

```text
F14_T(K) ≠ ∅
  ⇔  ∃ common isotropic right D-line
  ⇔  P(H_T^⊥) ∩ { [q q*] : q ≠ 0 } (K) ≠ ∅.
```

Incidence with the Pfaffian dual then gives `C_gen(K) ≠ ∅` (Arrow B of the
bridge audit).

### 5.3 Relation to `c_3 = 0`, `c_2 ≠ 0`

| System | Unknowns | Meaning | Soluble abstractly over `K`? |
|---|---|---|---|
| `c_3(a)=0, c_2≠0` in 15 vars | Morita projector | structure idempotent | **yes** (Gram–Schmidt) |
| `h_i(q,q)=0` (5 eqs on `D²`) | Fano point | common isotropic line | **unknown** (live gate) |

The first system is auxiliary. The second is the smallest intrinsic Hermitian
problem equivalent to the positive Pfaffian gate.

### 5.4 Dimension count

```text
ambient:     P²_D                 dim_K = 8
conditions:  five scalar equations of Hermitian weight 2
expected:    dim = 8 − 5 = 3
```

This matches `dim F14 = 3`. The five equations are highly dependent on the
special geometry of the Klein five-plane (their Pfaffian / Moore determinant
on `P(H_T)` recovers the twisted Klein cubic), so the actual scheme is the
Fano twist, not a complete intersection of five general quadrics.

### 5.5 Singular locus (structural)

- On the split fibre (`D ≅ M_2`, `A ≅ M_6`), `F14` is the classical smooth
  degree-14 Fano threefold of lines on the Klein cubic.
- For the generic twist, the same Hilbert polynomial and smoothness of the
  split model, together with the nonsplit but index-two Brauer class living
  on ambient lines rather than on two-planes, give that `F14_T` is a smooth
  projective threefold over `K` on a dense open of the versal base
  (accepted Pfaffian geometry; no new singularity computation in this
  dispatch).
- The affine chart equations `h_i(1,x,y; 1,x,y) = 0` are singular exactly
  where the chart meets the hyperplane at infinity of `P²_D` or where the
  differential of the five-plane section drops rank; both loci are proper.
  Expected smooth locus dimension remains three.

No claim is made that a random five-plane of Hermitian forms has smooth
common-isotropic scheme of dimension three; the Klein five-plane is special.

---

## 6. Task 1C.2 — classification of the idempotent space

Let

```text
I_σ  :=  { e ∈ A | e² = e, σ(e) = e, reduced rank 2 }.
```

### 6.1 Geometric type

`I_σ` is a Zariski-open subset of `P²_D` (nondegenerate lines for
`h_struct`). Equivalently, it is a homogeneous space under the unitary group

```text
U(D³, h_struct)  =  { g ∈ GL_3(D) | g* h_struct g = h_struct }
```

acting transitively on nondegenerate lines (after base change to a splitting
field; over `K`, orbits may a priori break by Hermitian classification, but
see §6.2).

### 6.2 Rationality / torsor status

| Question | Answer |
|---|---|
| Does `I_σ(K)` nonempty? | **Yes** (abstract Gram–Schmidt / Morita) |
| Is the ambient `P²_D` rational over `K`? | **Yes** (chart `D²`) |
| Is `I_σ` rational over `K`? | **Yes on a dense open**: it is open in a rational variety and has a `K`-point, so the function field is purely transcendental over `K` of degree 8 |
| Homogeneous space with nontrivial class? | **No obstruction to points**: the cohomological class in `H¹(K, U)` classifying the form `h_struct` is already neutralized by the known algebra-with-involution data `(A,σ)` (which exists over `K` by descent). The residual point problem for `I_σ` is empty |
| Relation to Klein | **none direct** |

**Cohomological class of `I_σ` as homogeneous space.** Writing
`X = U / U_L` for the stabilizer of a line, the class of `I_σ` in
`H¹(K, U_L)` is neutral precisely because `I_σ(K) ≠ ∅`. No new Brauer class
appears beyond the already-accounted quaternion class of `D`, which is
absorbed by working with right `D`-lines rather than splitting `D`.

### 6.3 Contrast: the Fano section as torsor / variety

The common-isotropic scheme `F14_T` is **not** a homogeneous space under a
group with obviously neutral class. It is a twisted form of a Fano threefold,
and its point problem is the live arithmetic gate. Index-one zero-cycles are
known (gcd of orbit degrees is 1) but do not yield a rational point.

---

## 7. Does the abstract idempotent force a point of the installed cubic
without coordinates?

**Yes, for the cubic; no, for the Klein twist.**

```text
abstract e
  ⇒  installed scheme {c_3 = 0, c_2 ≠ 0} is K-nonempty     (P1 for the cubic)
  ⇏  C_gen(K) ≠ ∅                                         (house rule 1)
  ⇏  common isotropic line
```

Coordinates of that cubic point in the installed basis are still unknown; their
construction is an implementation problem of expected lower complexity than
the original 36-variable raw idempotent equations, but solving them is
**Gate 3 territory** and is **not authorized** here. Even after solving them,
one still faces §5.

---

## 8. Gate 2 decision

```text
P1-REDUCED
```

**Meaning in this dispatch.**

- The abstract Morita / idempotent theory **does** force solubility of the
  installed 15-variable cubic, without writing coordinates.
- That solubility is **auxiliary** and does **not** assemble a positive
  theorem for `C_gen` or for `G`-unirationality (all five verification items
  of work-order §0 remain open for the headline).
- The headline-positive problem reduces to the **smaller explicit intrinsic
  system** of §5: five Hermitian scalar equations on `D²` (eight `K`-variables),
  i.e. `F14_T(K) ≠ ∅`.
- That reduced system is **reported, not solved**.
- No 15-variable Gate 3 solve is launched.
- `STOP-1` is not selected: the idempotent space is not a nontrivial
  obstructing torsor; the obstruction, if any, sits on `F14_T`, which is not
  classified here as a neutral/non-neutral homogeneous space.

---

## 9. Hostile self-check (house rule: attack a positive claim)

**Hypothetical positive claim:** “Abstract idempotent ⇒ `ed_C(G) = 3`.”

**Strongest failure mode.** The idempotent is a point of `P²_D`, and
`P²_D(K) ≠ ∅` is true for every index-two degree-six algebra, including those
unrelated to the Klein cubic. Essential dimension of `G` cannot follow from a
structure theorem that holds for every such algebra-with-involution.

**Why the failure mode is real here.** The Klein geometry enters only through
the five-plane `H_T`. Without simultaneous isotropy, no Fano point and no
compression of the versal torsor to a threefold image is obtained.

**Conclusion.** Any positive headline from the abstract idempotent alone would
be false. The packet refuses that claim.

---

## 10. Five verification items (work-order §0) — status

| Item | Status |
|---|---|
| 1. `G`-equivariance of a landing map | **not constructed** |
| 2. Landing in `X` | **not constructed** |
| 3. Domain / primitivity control | **not constructed** |
| 4. Dominance | **not constructed** |
| 5. Conversion to `G`-unirationality | accepted equivalence only; hypothesis `C_gen(K)≠∅` **not obtained** |

---

## 11. Files and next step

| File | Content |
|---|---|
| `CFOSS_W1_INPUT.md` | Lemma 3.1 pin |
| `BRIDGE_AUDIT.md` | Gate 1, four-arrow audit, stable trap |
| `IDEMPOTENT_TO_KLEIN_POINT.md` | this file |
| `quaternion_corner.md` / `.json` | corner equations, dimension, singular locus |
| `SEAL.json` | hashes and decisions |

**Authorized next work (not this dispatch):** build explicit `(D, H_T)` over
the executable `K_proj` model, then attack the five equations on `D²` by exact
methods — or prove `F14_T(K) = ∅`.

**Headline:** OPEN.
