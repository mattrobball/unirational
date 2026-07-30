# Gate A3 — Krylov incidence (formulation, elimination, memory floors)

**Date:** 2026-07-30  
**Packet:** `certificates/schur_krylov/`  
**Gate:** A3  
**Headline:** OPEN  
**Prerequisite:** Gate A1 `A1-PASS` (sealed); Gate A2 field algebra and marked
point interfaces sealed.

---

## 0. Incidence variety

Identify \(L\simeq\mathbf A^{55}_F\) via the power basis \(B\) of
`field_algebra.md`.  For \(\tau\in L\) set

\[
U_\tau=\operatorname{span}_F\{1,\tau,\ldots,\tau^{19}\}\subset L.
\]

With \(V_Z=\operatorname{span}_F(z_0,z_1,z_2,z_3)\) as in `marked_point.md`,
define

\[
\mathcal K
=
\bigl\{
(\tau,\lambda)\in L\times L^\times
:
\lambda\,V_Z\subseteq U_\tau
\bigr\}.
\]

As an \(F\)-scheme, \(\mathcal K\) is cut out inside
\(\mathbf A^{55}_\tau\times(\mathbf A^{55}_\lambda\setminus\{0\})\) by rank
conditions (below).  Containment is **necessary** for a degree-19 map
\(\mathbf P^1_F\to\mathbf P^3_F\) sending a degree-55 divisor with coordinate
\(\tau\) to \(Z\); it is **not sufficient** for a qualifying curve (six
safeguards in §5).

---

## 1. Rank formulation (55 × 24 matrix)

View \(L\) as \(F^{55}\) with basis \(B\).  For coordinates of \(\tau\) and
\(\lambda\), form the matrix with **24 columns** in \(F^{55}\):

\[
M(\tau,\lambda)
=
\bigl[\;
1\;\big|\;
\tau\;\big|\;
\tau^2\;\big|\;
\cdots\;\big|\;
\tau^{19}\;\big|\;
\lambda z_0\;\big|\;
\lambda z_1\;\big|\;
\lambda z_2\;\big|\;
\lambda z_3
\;\bigr]
\in
\operatorname{Mat}_{55\times 24}(F).
\]

Powers of \(\tau\) and products \(\lambda z_j\) are computed by the sealed
multiplication matrices of Gate A2.

**Containment** \(\lambda V_Z\subseteq U_\tau\) if and only if

\[
\operatorname{rank} M(\tau,\lambda)\le 20,
\]

equivalently every \(21\times 21\) minor vanishes.  On the primitive locus
\([F(\tau):F]=55\) one has \(\operatorname{rank}(1,\ldots,\tau^{19})=20\), so
the condition is exactly that the four columns \(\lambda z_j\) lie in that
20-plane.

---

## 2. Linear elimination of the 80 interpolating coefficients

Write the containment as existence of coefficients
\(c_{jk}\in F\) (\(j=0,1,2,3\), \(k=0,\ldots,19\)) with

\[
\lambda z_j
=
\sum_{k=0}^{19} c_{jk}\,\tau^k
\qquad(j=0,1,2,3).
\tag{†}
\]

### Variable count

| Block | Count | Role |
|---|---:|---|
| \(\tau\) coordinates | 55 | nonlinear |
| \(\lambda\) coordinates | 55 | linear in (†) after fixing \(\tau\) |
| \(c_{jk}\) | \(4\cdot 20=80\) | linear in (†) |
| **Total raw** | **190** | before gauges |

### Equation count

Each of the four identities (†) is an equality in \(L\simeq F^{55}\), hence
55 scalar equations over \(F\).  Total:

\[
4\cdot 55=220
\]

equations, **linear** in the 135 unknowns \((c,\lambda)\) and polynomial in
\(\tau\).

### Elimination order (certified)

1. Treat \(\tau\) as parameters.
2. Assemble the \(220\times 135\) coefficient matrix \(A(\tau)\) of the linear
   system in \((c,\lambda)\), with entries in the polynomial ring of
   structure constants / power sums of \(\tau\).
3. Require \(\operatorname{rank} A(\tau)<135\) with a solution \(\lambda\neq 0\)
   (equivalently, the maximal minors of the appropriate augmented blocks
   vanish, and the \(\lambda\)-block is not forced to zero).
4. After solving linearly for \((c,\lambda)\) on the incidence locus, retain
   only \((\tau,\lambda)\) (or only \(\tau\) up to residual scaling).

The 80 coefficients \(c_{jk}\) are **never** Gröbner variables of the final
nonlinear system: they are eliminated by linear algebra over the function
field of the \(\tau\)-space (or by Cramer / Schur complements on \(A(\tau)\)).

---

## 3. \(\mathrm{PGL}_2\) gauge (certified)

Domain automorphisms \(\varphi\in\operatorname{PGL}_2(F)\) act by
\(\tau\mapsto\varphi(\tau)\) and reparametrise the same rational curve.  The
residual projective scaling \((\tau,\lambda)\sim(\tau,a\lambda)\)
(\(a\in F^\times\)) does not change the image curve.

### Gauge choice (trace / leading-coefficient)

On the primitive locus, \(\tau\) has minimal polynomial of degree 55.  Impose
the **monic + trace-zero** normal form on a primitive element generating the
same Krylov flag after a unique translation:

\[
\operatorname{Tr}_{L/F}(\tau)=0,
\qquad
\text{leading coefficient of }\mu_\tau\text{ already }1\text{ in monogenic model}.
\]

Translation \(\tau\mapsto\tau+a\) (\(a\in F\)) realises trace zero uniquely.
The residual \(\operatorname{PGL}_2\) has dimension 3; after fixing

- the degree-55 divisor on \(\mathbf P^1\) as the vanishing of a monic
  degree-55 polynomial with **vanishing \(t^{54}\) coefficient** (trace zero
  on the root), one still has dilations and inversions;

use the secondary gauge

\[
\operatorname{Norm}_{L/F}(\tau)=1
\qquad\text{or}\qquad
\text{coefficient of }t^{53}\text{ fixed}
\]

when a full slice is needed, and record the stabilizer of any discovery point
exactly.

**Minimal working gauge for incidence dimension counts:**

\[
\operatorname{Tr}(\tau)=0,\qquad
\lambda_0=1
\]

(first affine coordinate of \(\lambda\) set to 1 on the open where it is
nonzero; cover by the four standard opens).  This removes
\(1+1=2\) degrees of freedom; residual \(\operatorname{PGL}_2\) of dimension 1
may remain and is accounted in tangent-dimension comparisons (§4).

A fully rigid gauge (3 parameters) is:

\[
\operatorname{Tr}(\tau)=0,\quad
\operatorname{Tr}(\tau^2)=s_2\ \text{normalised},\quad
\lambda_0=1,
\]

with the second moment fixed by dilations.  Implementation records which gauge
is active in `krylov_incidence.json`.

---

## 4. Expected dimensions and tangent test

### Naive count

| Quantity | Value |
|---|---:|
| Raw \((\tau,\lambda)\) | 110 |
| Trace-zero + \(\lambda_0=1\) gauge | \(110-2=108\) effective |
| Open primitive \(\tau\) | dense open of \(\mathbf A^{55}\) |
| Linear conditions on \((c,\lambda)\) at fixed primitive \(\tau\) | 220 eqns in 135 vars |

At a fixed primitive \(\tau\), the solution space in \((c,\lambda)\) is the
nullspace of \(A(\tau)\).  Expected nullity for a general 4-plane \(V_Z\)
relative to a general 20-plane \(U_\tau\):

\[
\dim\operatorname{Hom}_F(V_Z,U_\tau)=4\cdot 20=80
\]

corresponds to free \(c_{jk}\) once \(\lambda\) is fixed to realise a given
embedding of \(V_Z\) into \(U_\tau\).  The condition that \(V_Z\) meet some
\(\lambda^{-1}U_\tau\) is a Schubert-type condition on the Grassmannian
\(\operatorname{Gr}(20,55)\times\operatorname{Gr}(4,55)\).

Virtual dimension of \(\mathcal K\) before curve safeguards is **not** claimed
as emptiness or existence; it is recorded for tangent tests only.

### Tangent test protocol (at any discovery point)

1. Compute the Jacobian matrix of the chosen minor / linear-elimination
   residual at the point.
2. Compare \(\operatorname{rank}(\mathrm{Jac})\) to the number of active
   equations after gauge.
3. Record expected vs actual tangent dimension in the discovery log.
4. No existence claim from virtual dimension alone.

---

## 5. Six safeguards (mandatory for every candidate)

A pair \((\tau,\lambda)\in\mathcal K\) is **not** a qualifying curve.  For the
four binary / univariate forms \(p_j(u)=\sum_{k=0}^{19}c_{jk}u^k\) obtained
from (†), check **all** of:

| # | Safeguard | Exact test |
|---|---|---|
| S1 | no common zero of \((p_0,p_1,p_2,p_3)\) | \(\operatorname{Res}\) / saturated ideal \((p_0,p_1,p_2,p_3)= (1)\) in \(F[u]\) (or binary forms on \(\mathbf P^1\)) |
| S2 | map degree exactly 19 | \(\gcd(p_0,p_1,p_2,p_3)=1\) and max deg \(=19\) after removing content |
| S3 | birational onto image | function field degree 1: \(F(C)=F(t)\) via inverse rational functions, or \(\deg(\mathbf P^1\to C)=1\) |
| S4 | image contains \(Z\) with mult. one at all conjugates | length of \(\mathcal O_{C\cap X_T,Z}=1\) scheme-theoretically at each geometric point of the orbit |
| S5 | no component of the image in the cubic | \(f_3\circ p\not\equiv 0\) as a binary form of degree 57 |
| S6 | residual cubic intersection length exactly 2 | \(\deg(C\cap X_T)-55=2\) with the marked mult-one contribution removed |

**Reporting rule.**  A rank-only point of \(\mathcal K\) that fails any of
S1–S6 must never be reported as a qualifying curve.  The candidate verifier
(`candidate_verifier.py`) implements S1–S6 independently of the producer.

---

## 6. Memory floors — recorded **before** elimination

### Matrix sizes

| Object | Shape | Entries (dense) | Bytes (dense `QQ`, ~32 B/entry est.) |
|---|---|---:|---:|
| \(M(\tau,\lambda)\) | \(55\times 24\) | 1 320 | \(\sim 42\) KiB |
| Linear block \(A(\tau)\) | \(220\times 135\) | 29 700 | \(\sim 0.95\) MiB |
| Normal equations \(A^\top A\) | \(135\times 135\) | 18 225 | \(\sim 0.58\) MiB |
| Single \(21\times 21\) minor of \(M\) | scalar poly in \((\tau,\lambda)\) | — | degree \(\le 21\) in each column scale |

### Sparse vs dense floors for the nonlinear residual

After linear elimination of \((c,\lambda)\), the residual ideal lives in the
\(\tau\)-coordinates (55 variables over \(F\)), or in a gauged slice
(\(\sim 53\)–\(54\) free parameters before residual \(\operatorname{PGL}_2\)).

Structure constants of \(L/F\) are themselves elements of \(F\).  Working
over the abstract field \(F\) (transcendence degree 5), every “scalar” is a
rational function.  Two computational models:

| Model | Variables | Risk |
|---|---|---|
| **(M1)** Abstract \(F\)-arithmetic with monogenic \(\mu\) symbolic | 55 coeffs of \(\mu\) + 55 of \(\tau\) + … | coefficient swell in \(F\) |
| **(M2)** Relative dense elimination treating structure constants as black-box field ops | 55 \(\tau\)-coords over \(F\) | each field op costs mult. matrices \(55\times 55\) |

### Dense memory floor (M2, gauged \(\tau\) only)

Suppose a Gröbner / dense linear algebra step on \(N\) generators of degree
\(\le D\) in \(n=54\) gauged \(\tau\)-variables.  Macaulay matrix column count
is \(\binom{n+D}{n}\).  Already for \(D=3\):

\[
\binom{54+3}{3}=29\,260,
\]

for \(D=4\):

\[
\binom{58}{4}=424\,270,
\]

for \(D=5\):

\[
\binom{59}{5}\approx 5.0\times 10^6.
\]

A single dense double-precision matrix of side \(5\times 10^6\) is far beyond
8 GiB; even side \(4\times 10^5\) at 8 bytes is \(\sim 1.3\) TiB for a square
system.  With exact \(\mathbf Q\)-arithmetic the constant is larger.

**Sparse floor.**  Each residual equation from a \(21\times 21\) minor of \(M\)
is multilinear in the column blocks and degree \(\le 20\) in \(\tau\) (powers
through \(\tau^{19}\) and products with \(\lambda z_j\)).  Number of raw
minors:

\[
\binom{55}{21}\binom{24}{21}
=
\binom{55}{21}\binom{24}{3}
\sim 1.05\times 10^{17},
\]

unusable unreduced.  Linear elimination (§2) is mandatory before any minor
generation.

### Pre-elimination certificate (exploratory 8 GiB gate)

```text
matrix M:              55 x 24
linear block A(tau):   220 x 135
c-coefficients:        80 (linear, eliminate first)
raw minor count:       ~1e17 (FORBIDDEN without linear elim)
gauged tau vars:       ~53..54
dense Macaulay D=4:    binom(58,4)=424270 columns  -> dense >> 8 GiB
dense Macaulay D=3:    binom(57,3)=29260 columns   -> borderline / exceeds
                       with exact F-arithmetic and 55x55 field ops
expected certificate:  either empty K after linear elim + residual,
                       a positive-dimensional component with equations,
                       or a finite list of (tau,lambda) for safeguard tests
checkpoint plan:       (1) build A(tau) API
                       (2) rank profile of A on modular fibres (discovery)
                       (3) exact residual only if modular suggests dim 0
                       and term count < 8 GiB dense floor
verifier design:       candidate_verifier.py runs S1–S6 without producer import
```

**Decision under the 8 GiB rule.**  A full dense elimination of the residual
in \(\ge 53\) variables is **not authorised**.  Modular discovery of rank
profiles of \(A(\tau)\) and of low-degree sparse residuals is authorised for
shape only.

---

## 7. Decision exit for this gate

After A1–A2 seal and the A3 formulation above:

- No qualifying curve is constructed (`P-A` not reached).
- Emptiness of \(\mathcal K\) is **not** proved (`N-A` not reached).
- No irreducible component equations of \(\mathcal K\) are computed
  (`A-SURVIVE` would require actual residual generators).
- The nonlinear residual exceeds the exploratory memory gate before a
  structural reduction that collapses the variable count below the dense
  floor.

**Exit: `A-STOP`** — measured bottleneck recorded in §6; incidence shape,
linear-elimination plan, gauge, and safeguard verifier installed; headline
OPEN.

`N-A` is **not** claimed.  Even a future proof that \(\mathcal K=\varnothing\)
would close only the degree-19 Krylov rescue route, not the headline.

---

## 8. Cycle-2 structural collapse (successor)

The four candidate collapses (full \(\mathrm{PGL}_2\) gauge; \(S_3\)/\(D_{12}\)
isotypic blocks; sparse Schur order; \(\lambda\)-specialisation) are audited in

```text
certificates/schur_krylov/STRUCTURAL_COLLAPSE.md
certificates/schur_krylov/structural_collapse.json
```

**Summary.**  Full \(\mathrm{PGL}_2\) gauge is lossless and reduces the
nonlinear ambient to **52** variables.  No further lossless \(F\)-rational
collapse exists: \(H\) maximal \(\Rightarrow\) no intermediate fields of
\(L/F\); \(\operatorname{Aut}(L/F)=1\); geometric isotypics do not split the
residual ideal over \(F\); non-scalar specialisations of \(\lambda\) or
fixation \(\tau=\alpha\) are lossy.  After every lossless reduction the
residual is the Fitting ideal of the structured \(140\times 55\) matrix
\(\varphi_\tau\) on a 52-dimensional gauge slice, of degree \(\gg 3\).  Dense
Macaulay at \(D=3\), \(n=52\) is already \(\sim 20.5\) GiB \(>8\) GiB; fitting
degree \(\ge 19\) under 8 GiB would require \(n\le 4\), which is not reached
losslessly.

**Exit remains `A-STOP`** with the minimal irreducible system of the collapse
note.  Modular rank-profile discovery
(`tmp/pathA_collapse/modular_rank_profile.*`) is authorised for shape only and
does not yield `N-A`.

---

## 9. Terminal marker

```text
SCHUR_KRYLOV_A3_INCIDENCE_FORMULATED_A_STOP
```
