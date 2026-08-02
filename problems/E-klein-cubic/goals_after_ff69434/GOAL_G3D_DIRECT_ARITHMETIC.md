# Problem E — Goal G3D: structured direct arithmetic on `V(Phi)`

**Pinned `main`:** `ff69434ffa49062402234c0661fef69e07416dd7`  
**Priority:** 1  
**Headline direction:** positive  
**Problem E headline at dispatch:** **OPEN**

## Mission

Decide

\[
X_{\rm gen}(K_{\rm proj})\neq\varnothing,
\qquad
X_{\rm gen}=V(\Phi)\subset\mathbf P^4_{K_{\rm proj}},
\]

by direct arithmetic on the exact generic cubic.  G3B/G3C already installed the
full line equations, but another unrestricted search through the
six-parameter Grassmann charts is not authorized.  This order replaces that
scan by three intrinsic, low-dimensional constructions attached to `Phi`:

1. the canonical **second-polar cubic surface**;
2. the symmetric **Hessian-kernel / cube-cover correspondence**;
3. the **spinor discriminant** of the first-polar quadric.

The two exact maximal-`A5` structures may be used only to split or identify
these canonical objects.  They are not permission to use the invalid G7B
constant-field coset orbit, and an odd-degree cubic point does not descend by
itself.

The first exact `K_proj`-point produced by any lane must be promoted through
G2 and the G3A dominance bridge.

---

## Binding inputs

Consume and hash the live versions of

```text
goal_runs_after_35fa/G_UNIVERSAL/
goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/
goal_runs_after_0aecc89/G3B_LINE_CONIC_SEARCH/
goal_runs_after_0aecc89/G3C_LINE_CONIC_FANO/
goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/
goal_runs_after_35fa/H_A5_TWISTS/
goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/
goals_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER.md
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
tmp/kproj_arithmetic/normalized_kproj_table.json
```

The G3H order is an optional accelerator input until its packet returns.  G3D
must begin without waiting for G3H.

### Hard scope fences

- Do not re-run the broad G3B/G3C line or plane scan.
- Do not launch the `72`-variable full-`K_proj` Grassmann chart merely because
  it exists.
- Do not duplicate C6's five-alternating-form / Palatini common-line problem.
  “Determinantal” in this order means the determinant structures intrinsic to
  `Phi`: cubic-surface determinantal representations, the symmetric polar
  matrix, and binary-cubic resultants.
- Do not use `rho(g_i)e_0` or any other representative-dependent split orbit as
  a degree-eleven cycle.
- Modular points, factors, lines, or unit ideals are discovery data unless an
  exact characteristic-zero reconstruction or a theorem in the correct
  direction is supplied.

---

## G3D.0 — exact simple field model for CAS

G3A represents

\[
K=K_{\rm proj}
\]

as a rank-12 field over

\[
P_0=\mathbf Q(t_3,t_6,t_8,t_{11})
\]

in the normalized secondary basis.  Before running algebraic-geometry CAS,
construct a primitive-element presentation.

Choose a small deterministic combination

\[
\eta=\sum_{i=0}^{11} c_i b_i
\]

and compute the exact multiplication matrix `L_eta`.  Produce

\[
m_\eta(T)\in P_0[T]
\]

and prove:

1. `deg m_eta = 12`;
2. the power-basis matrix
   \[
   (1,\eta,\ldots,\eta^{11})
   \]
   has nonzero determinant on an explicit principal open;
3. multiplication in `P0[T]/(m_eta)` agrees with all 78 stored secondary
   products;
4. maps between the power basis and the G3A secondary basis are exact in both
   directions;
5. trace, norm, inversion, and denominator opens agree with `field_api.py`.

A good-prime nonzero reduction may certify that a displayed determinant is not
identically zero, provided the integral model and denominator conditions are
recorded.  It may not replace the exact basis maps.

Deliver:

```text
K_SIMPLE_MODEL.md
k_simple_model.json
src/k_simple.py
verify_k_simple.py
```

Required marker:

```text
G3D-K-SIMPLE-MODEL-PASS
```

This is an arithmetic interface, not a headline exit.

---

## G3D.1 — the canonical second-polar cubic surface

Let

\[
q=e_0=[1:0:0:0:0],
\qquad
\Phi(q)=t_3\neq0.
\]

Let `B` be the symmetric trilinear polarization with
`Phi(x)=B(x,x,x)`.  The canonical second-polar hyperplane is

\[
H_q=V(\ell_q),
\qquad
\ell_q(a)=B(q,q,a).
\]

In the installed normalized basis the exact linear form is

\[
\ell_q(a)=
 t_3a_0+\frac{t_6}{3}a_1+\frac{b_7}{3}a_2
 +\frac{t_8}{3}a_3+\frac{b_9}{3}a_4,
\]

where `b_7,b_9` are secondary-basis elements 1 and 2 in the G3A field model.
Thus, on `t3 != 0`, eliminate

\[
a_0=-\frac{t_6a_1+b_7a_2+t_8a_3+b_9a_4}{3t_3}.
\]

Define

\[
S_q=X_{\rm gen}\cap H_q\subset H_q\simeq\mathbf P^3_K.
\]

This is the primary direct-arithmetic target.

### G3D.1A — exact surface and smoothness

1. Substitute the displayed expression for `a0` into all twelve secondary
   components of `Phi` and produce one exact cubic
   \[
   G_q(y_1,y_2,y_3,y_4)=0
   \]
   over the simple field model.
2. Verify that re-embedding into `P^4` gives both `ell_q=0` and `Phi=0`.
3. Decide smoothness over `K` by the saturated Jacobian ideal.  A smooth good
   specialization is sufficient to prove the generic discriminant is nonzero
   only after all specialization denominators and the integral model are
   checked.
4. If the surface is singular, solve the singular locus exactly.  A
   `K`-rational singular point is immediately a headline candidate and
   projection from it must be written explicitly.

Deliver:

```text
POLAR_CUBIC_SURFACE.md
polar_cubic_surface.json
verify_polar_surface.py
```

Required structural marker:

```text
G3D-POLAR-CUBIC-SURFACE-PASS
```

### G3D.1B — finite 27-line algebra, not the full Fano scan

For a smooth cubic surface, compute its line scheme in

\[
\operatorname{Gr}(2,4).
\]

This has six Grassmann big cells and is zero-dimensional of geometric degree
27.  Reuse the G3B/G3C polarization formulas after imposing `ell_q=0`; do not
start from the six-parameter line scheme in `P^4` again.

For each chart:

1. write the four binary-cubic containment coefficients;
2. saturate by the chart minor and by all field denominators;
3. compute a zero-dimensional RUR or multiplication algebra over `K`;
4. deduplicate chart overlaps scheme-theoretically;
5. verify total geometric degree 27 when the surface is smooth;
6. factor the finite algebra over `K` and record orbit degrees;
7. test every degree-one factor by direct substitution into `G_q` and `Phi`.

A `K`-line is already headline-positive because it contains `K`-points.  Give
an explicit point avoiding all exceptional denominators.

Deliver:

```text
LINE_27_ALGEBRA.md
line_27_algebra.json
produce_lines.py
verify_lines.py
```

### G3D.1C — sixers, double-sixes, and determinantal descent

From the exact line algebra and intersection pairing, reconstruct rather than
assume the classical finite configurations:

- pairwise-skew sixers;
- double-sixes;
- tritangent planes;
- their Galois actions over `K`.

For every `K`-defined sixer orbit:

1. construct its descent cocycle;
2. determine whether the contraction target is `P^2_K` or a degree-three
   Severi–Brauer surface;
3. compute the associated `3`-torsion Brauer class exactly;
4. when the class is zero, construct a `3 x 3` matrix `A(y)` of linear forms
   satisfying
   \[
   \det A(y)=\lambda G_q(y),\qquad \lambda\in K^\times;
   \]
5. independently reconstruct the determinant representation from the sixer;
6. choose an explicit `u in P^2(K)` for which `A(y)u=0` has a one-dimensional
   kernel in the four `y`-coordinates, solve it, and verify the resulting
   `K`-point on `S_q` and `X_gen`.

Do not claim that a Galois-stable set of six lines automatically gives an
honest matrix over `K`; the Severi–Brauer obstruction is load-bearing.

Deliver:

```text
SIXER_DESCENT.md
sixer_descent.json
DETERMINANTAL_SURFACE.md
surface_determinantal.json
verify_sixers.py
verify_surface_determinant.py
```

---

## G3D.2 — symmetric Hessian-kernel cube cover

For `z in K^5`, define the symmetric polar matrix

\[
\mathcal M(z)_{ij}=B(z,e_i,e_j).
\]

It is a `5 x 5` symmetric matrix of linear forms in `z`.  Define

\[
\Gamma=\{([z],[v])\in\mathbf P^4\times\mathbf P^4:
          \mathcal M(z)v=0\}.
\]

Because `B` is symmetric,

\[
\mathcal M(z)v=\mathcal M(v)z.
\]

On `Gamma`, all mixed terms vanish:

\[
B(z,z,v)=B(z,v,v)=0,
\]

and therefore

\[
\Phi(sz+tv)=s^3\Phi(z)+t^3\Phi(v).
\]

This identity is the determinantal bridge to the cubic.

### G3D.2A — Hessian and rank strata

1. Build `M(z)` independently from `generic_cubic.json` and from the G3A
   polarization tables.
2. Compute
   \[
   h(z)=\det\mathcal M(z)
   \]
   exactly.
3. Compute and saturate the rank-at-most-three ideal generated by the `4 x 4`
   minors; determine its actual dimension, degree, components, and reducedness
   rather than imposing the expected codimension.
4. Audit the rank-at-most-two boundary separately.
5. On every rank-four adjugate chart, construct the kernel vector from a
   nonzero adjugate column and verify all five bilinear equations.

Deliver:

```text
HESSIAN_MATRIX.md
hessian_matrix.json
HESSIAN_RANK_STRATA.md
hessian_rank_strata.json
verify_hessian.py
```

Required structural marker:

```text
G3D-HESSIAN-KERNEL-PASS
```

### G3D.2B — cube-cover decision

Define

\[
\mathcal Y=
\{(z,v,[s:t]):(z,v)\in\Gamma,
  s^3\Phi(z)+t^3\Phi(v)=0\}.
\]

The exact map

\[
(z,v,[s:t])\longmapsto sz+tv
\]

lands on `X_gen`.

On each rank-four chart eliminate `v` by the adjugate and obtain the explicit
cube cover

\[
u^3=-\frac{\Phi(z)}{\Phi(v(z))}.
\]

Tasks:

1. compute the divisor class of the ratio on the normalization of each
   accessible Hessian component;
2. determine whether it is a cube in the component function field;
3. factor numerator and denominator and test 3-divisibility of valuations;
4. if the generic ratio is not a cube, search only the following canonical
   subloci:
   - the rank-at-most-three components;
   - intersections with the polar hyperplanes arising from `q`;
   - components forced by the 27-line/sixer geometry of `S_q`;
   - exact `A5`-resolvent components after the A5 phase below;
5. verify every point of the cube cover by direct substitution in all twelve
   components of `Phi`.

On a rank-at-most-three component, work with the projectivized kernel bundle.
If the kernel is two-dimensional, restrict `Phi` to it as a binary cubic.  Its
zero discriminant locus is preferred because the repeated root can be
extracted over `K` by the polynomial gcd, without adjoining a root.

Deliver:

```text
HESSIAN_CUBE_COVER.md
hessian_cube_cover.json
produce_hessian_cover.py
verify_hessian_cover.py
```

Authorized reduction marker:

```text
G3D-HESSIAN-CUBE-REDUCTION-PASS
```

This marker is structural unless an exact `K`-point is produced.

---

## G3D.3 — spinor discriminant of the first-polar quadric

The canonical first-polar quadric is

\[
Q_q=V(B(q,v,v))\subset\mathbf P^4_K.
\]

Let

\[
\mathscr F_q=\operatorname{OGr}(2,Q_q)
\]

be its variety of projective lines.  For a smooth five-dimensional quadratic
form, this is the Severi–Brauer form attached to the even Clifford algebra;
all claims must be checked for the actual exact form rather than assumed from
specializations.

### G3D.3A — exact Witt and Clifford model

1. Compute the determinant, discriminant, Witt index, and even Clifford
   algebra of `Q_q` over `K`.
2. Construct the Clifford algebra by exact structure constants and verify its
   center and degree.
3. Decide whether `F_q` is split.
4. If split, write an explicit hyperbolic basis and a spinor parameterization
   of all lines on `Q_q`.
5. If not split, retain exact equations for the Severi–Brauer form; do not
   replace it by `P^3` after a convenient specialization.

Deliver:

```text
POLAR_QUADRIC_WITT.md
polar_quadric_witt.json
SPINOR_MODEL.md
spinor_model.json
verify_clifford.py
```

Required structural marker:

```text
G3D-POLAR-CLIFFORD-PASS
```

### G3D.3B — binary-cubic discriminant divisor

For a line

\[
L=\langle u,v\rangle\subset Q_q,
\]

write

\[
f_L(s,t)=\Phi(su+tv)
=a s^3+3b s^2t+3c st^2+d t^3.
\]

Its discriminant is

\[
\Delta_L=
162abcd-108b^3d+81b^2c^2-108ac^3-27a^2d^2.
\]

This is well-defined as a section on `F_q`; construct it from the Sylvester
resultant as well as from the displayed formula.

If `Delta_L=0` and `f_L` is not identically zero, the repeated root is defined
over `K`: compute it as the common linear factor of `f_L` and its derivatives.
That repeated point lies on `X_gen`.  If `f_L` is identically zero, the whole
line lies on `X_gen`.

Tasks:

1. construct the exact discriminant divisor
   \[
   \mathscr D_q\subset\mathscr F_q;
   \]
2. compute its actual degree, components, singular locus, and boundary where
   `f_L` is the zero cubic;
3. search for `K`-points only through its determinant/resultant structure,
   singular components, or the A5 splittings below;
4. on a split spinor chart, project from every exact rational singular point
   and write inverse formulas;
5. extract and verify the repeated root directly in `Phi`.

Deliver:

```text
SPINOR_DISCRIMINANT.md
spinor_discriminant.json
produce_spinor_discriminant.py
verify_spinor_discriminant.py
```

Authorized reduction marker:

```text
G3D-SPINOR-DISCRIMINANT-PASS
```

---

## G3D.4 — exact `A5` accelerator and odd-degree descent

This phase uses the two maximal `A5` classes to split **canonical quadratic or
Brauer objects**, not to descend a cubic point directly.

When the G3H packet returns, consume its exact degree-eleven fields

\[
L_i/K,\qquad [L_i:K]=11,
\]

and its genuine semilinear arithmetic.  Until then, use the H_A5 packets only
for exact split-model discovery and component identification; no G7B point
coordinates are allowed.

Run both classes separately.

### Authorized uses of odd degree 11

1. **Quadratic forms.**  Odd-degree extension preserves the anisotropic kernel.
   If `Q_q` acquires an isotropic line over `L_i`, its Witt index was already at
   least two over `K`.  Reconstruct the `K`-line from exact descent data.
2. **Two-primary Clifford classes.**  If a `K`-defined even Clifford class
   restricts to zero over `L_i`, restriction/corestriction gives
   `11 alpha = 0`; multiplication by 11 is invertible on 2-primary torsion, so
   `alpha=0`.
3. **Three-primary cubic-surface descent.**  If a `K`-defined twisted sixer or
   degree-three Severi–Brauer contraction splits over `L_i`, its Brauer class
   is 3-primary and the same restriction/corestriction argument forces it to
   split already over `K`.
4. **Finite component identification.**  Factor the 27-line, sixer, Hessian,
   and spinor-discriminant algebras after base change to each `L_i` and compute
   the exact Galois action needed for descent.

### Forbidden uses

```text
X(L_i) nonempty  =>  X(K) nonempty
line scheme has an odd-degree point  =>  line scheme has a K-point
sixer exists over L_i  =>  an honest K determinantal matrix exists
```

The relevant quadratic/Witt or Brauer descent object must first be defined
over `K`.

Deliver:

```text
A5_STRUCTURED_DESCENT.md
a5_structured_descent_class_1.json
a5_structured_descent_class_2.json
verify_a5_descent.py
```

Authorized marker:

```text
G3D-A5-STRUCTURED-DESCENT-PASS
```

---

## G3D.5 — promotion to the headline

For any candidate

\[
r=[r_0:\cdots:r_4]\in\mathbf P^4(K),
\]

perform all of the following:

1. verify `r` is nonzero and record a nonvanishing coordinate;
2. verify `Phi(r)=0` in all twelve secondary components;
3. verify every power-basis and secondary-basis denominator/open condition;
4. clear denominators through the G2 normalized frame to an original
   homogeneous `G`-covariant;
5. verify the original Klein equation exactly;
6. verify generator equivariance independently, without importing the
   producer;
7. consume `G3-DOMINANCE-AUTOMATIC`;
8. write `BRIDGE_DIRECT_ARITHMETIC_POS.md`.

Only then exit

```text
G3D-POINT-HEADLINE-POSITIVE
```

---

## Local CAS order

CAS is required.  Run it locally only; do not create or invoke GitHub Actions
or any hosted runner.

### Phase A — exact field and polar surface

Preferred:

```text
SageMath / FLINT
Python + sympy for independent checks
Singular for chart ideals
```

Expected envelope: `< 8 GiB RSS`.

Tasks:

- primitive element for `K/P0`;
- exact polar-surface equation and Jacobian;
- six zero-dimensional line charts;
- line-algebra factorization and intersection graph.

### Phase B — sixer and determinant descent

Preferred:

```text
SageMath
Magma locally if its cubic-surface line/determinantal routines are useful
Singular or Macaulay2 locally for syzygies
```

Expected envelope: `8–16 GiB RSS`.

Tasks:

- RUR/multiplication algebra of the 27 lines;
- sixer/double-six enumeration;
- descent cocycles and degree-three Brauer classes;
- exact `3 x 3` linear determinant reconstruction.

### Phase C — Hessian and spinor geometry

Preferred:

```text
Singular
Macaulay2 locally
SageMath / Magma locally for Clifford and normalization work
```

Expected ceiling: `16–32 GiB RSS`.

Tasks:

- rank-at-most-three primary decomposition;
- normalization and function-field cube tests;
- exact even Clifford algebra;
- spinor Severi–Brauer model;
- binary-cubic resultant divisor.

At most one unrelated job expected to exceed 8 GiB may run at a time.  Before
materializing a dense matrix, record its dimensions, coefficient ring, and
estimated memory floor.  Prefer sparse elimination after linear reduction.

### Modular protocol

Good primes may be used to discover factor degrees, components, singular
points, and candidate syzygies.  Use at least one independent holdout prime for
reconstruction.  A modular result becomes load-bearing only after:

1. exact characteristic-zero reconstruction and verification; or
2. a proved nonvanishing/good-reduction implication in the required direction.

Timeouts, OOMs, killed jobs, empty logs, and solver crashes are nonverdicts.

---

## Deliverables

Write only under

```text
problems/E-klein-cubic/goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC/
```

Provide at least

```text
INPUT_MANIFEST.json
STATUS.md
K_SIMPLE_MODEL.md
k_simple_model.json
POLAR_CUBIC_SURFACE.md
polar_cubic_surface.json
LINE_27_ALGEBRA.md
line_27_algebra.json
SIXER_DESCENT.md
sixer_descent.json
DETERMINANTAL_SURFACE.md
surface_determinantal.json
HESSIAN_MATRIX.md
hessian_matrix.json
HESSIAN_RANK_STRATA.md
hessian_rank_strata.json
HESSIAN_CUBE_COVER.md
hessian_cube_cover.json
POLAR_QUADRIC_WITT.md
polar_quadric_witt.json
SPINOR_MODEL.md
spinor_model.json
SPINOR_DISCRIMINANT.md
spinor_discriminant.json
A5_STRUCTURED_DESCENT.md
POINT.md                         # only if obtained
BRIDGE_DIRECT_ARITHMETIC_POS.md  # only if obtained
src/k_simple.py
produce_surface.py
produce_lines.py
produce_sixers.py
produce_hessian.py
produce_spinor.py
verify_k_simple.py
verify_polar_surface.py
verify_lines.py
verify_sixers.py
verify_hessian.py
verify_spinor.py
verify_point.py
verify_all.py
REPLAY.md
SHA256SUMS
SEAL.json
```

Producer and verifier implementations must be independent.  A verifier may not
certify a field degree, smoothness result, line count, component, cube class,
Clifford class, determinant representation, or point merely by reading a
stored boolean.

---

## Authorized exits

```text
G3D-POINT-HEADLINE-POSITIVE
G3D-POLAR-CUBIC-SURFACE-PASS
G3D-HESSIAN-CUBE-REDUCTION-PASS
G3D-SPINOR-DISCRIMINANT-PASS
G3D-A5-STRUCTURED-DESCENT-PASS
G3D-STRUCTURED-NO-GO-SCOPED
G3D-UNDECIDED
G3D-CANONICAL-INPUT-FAIL
```

Interpretation:

- `G3D-POINT-HEADLINE-POSITIVE` is the only Problem E headline candidate.
- The four structural PASS exits install exact lower-dimensional arithmetic
  reductions but do not claim a point.
- `G3D-STRUCTURED-NO-GO-SCOPED` is allowed only after the exact canonical
  second-polar surface line/sixer route, the Hessian rank strata and cube
  cover, and the spinor discriminant have all been decided for the stated
  opens.  It is not pointlessness of `X_gen`.
- `G3D-UNDECIDED` is the honest result of incomplete elimination or resource
  exhaustion.
- `G3D-CANONICAL-INPUT-FAIL` is reserved for an independently verified
  inconsistency in G2, G3A, or the exact 35-coefficient cubic.

---

## Acceptance matrix

| Gate | Required evidence |
|---|---|
| Simple field | degree-12 power basis, exact two-way maps, multiplication agreement |
| Polar surface | exact elimination, direct re-embedding, smoothness or singular point |
| 27 lines | saturated six-chart algebra, degree/orbit ledger, direct line checks |
| Sixer descent | exact intersection graph, descent cocycle, Brauer class, determinant verification |
| Hessian | exact symmetric matrix, rank ideals, kernel charts, mixed-term identity |
| Cube cover | exact ratio/divisor test and explicit map `sz+tv -> X` |
| Spinor | exact Witt/Clifford model, genuine line space, resultant discriminant |
| A5 use | genuine degree-11 field or exact split discovery; valid odd-degree descent theorem |
| Headline | exact `K`-point, all opens, G2 denominator clearing, original equivariance, G3A dominance |

The intended first attack is the finite 27-line/sixer algebra of the canonical
polar cubic surface.  The Hessian cube cover and spinor discriminant are the
parallel intrinsic backups.  No broad line/conic scan is authorized.