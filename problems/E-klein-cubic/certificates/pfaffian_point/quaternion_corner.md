# Quaternion corner — abstract reduction (Gate 2, Task 1C.1)

**Date:** 2026-07-30  
**Headline:** OPEN  
**Scope:** structural reduction only; no Gate 3 solve; no executable
quaternion symbol over `K_proj` is installed.

Machine-readable twin: `quaternion_corner.json`.

---

## 1. Explicit quaternion corner (abstract form)

After a σ-self-adjoint reduced-rank-two idempotent `e` (existence abstract;
coordinates open):

```text
D      := e A e                         # quaternion division algebra over K
P      := e A ≅ D³                      # after choice of D-basis
σ      = ad_{h_struct}                  # structure Hermitian form on P
```

Write the standard presentation (placeholders until an explicit `e` is known):

```text
D = (a, b)_K
    = K + K i + K j + K i j,
    i² = a,  j² = b,  j i = − i j,
    * = standard involution (i* = −i, j* = −j, (ij)* = −ij).
```

**Status of `(a,b)`.** Existence of some symbol is guaranteed by
`index(A) = 2`. An explicit pair `(a,b)` in the executable model of `K_proj`
is **not** produced here (requires coordinates of `e` or an independent
cocycle construction). Local models after the odd `V_4` base change give
symbols of the form `(p², q²)`-type parameters; those are not global.

---

## 2. Five Hermitian matrices / forms

Identify `Herm_3(D)` with 3×3 matrices `H` satisfying `H* = H`, where
`*` is entrywise quaternion conjugation composed with transpose.

The descended Klein five-plane is a 5-dimensional `K`-subspace

```text
H_T = ⟨ H_1, H_2, H_3, H_4, H_5 ⟩_K  ⊂  Herm_3(D).
```

Each `H_r` determines the Hermitian form

```text
h_r : D³ × D³ → D,
h_r(u, v) = u* H_r v,
```

and the scalar quadratic form on the underlying 12-dimensional `K`-space

```text
q_r(v) := h_r(v, v)  ∈  K
```

(the pure quaternion part of a Hermitian value `v* H v` vanishes).

**Transport recipe (not executed).** Align `B_5 ⊂ ∧² V_6*` with the
Pfaffian hyperplanes; under Morita, pure rank-one elements `q q*` are
Plücker points; the five hyperplanes dualize to `H_1, …, H_5`. The Moore /
Pfaffian determinant of the universal combination `Σ t_r H_r` must recover
the certified twisted Klein cubic on `P(H_T)`.

**Explicit matrices:** not installed. Any numeric 3×3 array written without a
certified `e` would be a placeholder and is refused.

---

## 3. Common-isotropic-line equations

### Projective form

```text
∃  0 ≠ q ∈ D³  such that
    h_r(q, q) = 0    for r = 1, …, 5,
```

up to right scaling `q ∼ q · δ`, `δ ∈ D×`.

### Affine chart (smallest coordinate system)

```text
q = (1, x, y)^t ,    x, y ∈ D.
```

Write `x = x_0 + x_1 i + x_2 j + x_3 i j` and similarly `y`, giving eight
`K`-coordinates

```text
(x_0,x_1,x_2,x_3, y_0,y_1,y_2,y_3).
```

The system is

```text
F_r(x, y) := h_r( (1,x,y), (1,x,y) ) = 0,    r = 1, …, 5,
```

five equations in `K[x_•, y_•]`.

### Chart at infinity

The complementary charts `(x, 1, y)` and `(x, y, 1)` are required for a
projective existence certificate; expected dimension is chart-independent.

---

## 4. Equivalence with `c_3(a) = 0`, `c_2(a) ≠ 0`

**Not equivalent.** Precise relationship:

```text
{ c_3(a)=0, c_2(a)≠0 } / K
    ≅   I_σ     (σ-self-adjoint reduced-rank-two idempotents)
    ≅   open of P²_D
    =   Morita projectors for h_struct.

{ F_r(x,y)=0 } / K
    ≅   F14_T(K) in the affine chart
    =   common isotropic lines for H_T.
```

The first system is the **coordinate form of Morita data**. The second is the
**Fano section**. Functional calculus (§3 of `IDEMPOTENT_TO_KLEIN_POINT.md`)
identifies the first system with projectors; Plücker / Hermitian rank-one
geometry identifies the second with Fano points.

A solution of the first system yields `D` and a frame in which the second
system can be written. It does not solve the second system.

---

## 5. Dimension count

| Object | `K`-dimension |
|---|---:|
| `P²_D` | 8 |
| affine chart `D²` | 8 |
| five scalar equations `F_r = 0` | 5 conditions |
| expected dimension of common-isotropic scheme | 3 |
| classical `F14` | 3 |
| space `I_σ` of structure projectors | 8 (open in `P²_D`) |
| installed cubic hypersurface in `A^{15}` | expected 14, with open `c_2≠0` |

The match `8 − 5 = 3` is the dimension count required by the work order. It is
not a rationality or solubility theorem.

---

## 6. Singular-locus analysis (structural)

1. **Split model.** Over a splitting field of `D`, `F14` is the smooth
   irreducible Fano threefold of lines on the Klein cubic. Singular locus
   empty.
2. **Twisted model.** `F14_T` is a form of that Fano threefold. Smoothness
   is an open condition on the versal base of algebras-with-involution and
   five-planes; the generic Klein twist lies in the smooth locus by the
   classical smoothness of `F14` and invariance of the Hilbert scheme
   component (accepted Pfaffian geometry; no new Macaulay2 run here).
3. **Affine chart singularities.** The scheme `V(F_1,…,F_5) ⊂ A^8` may be
   singular along:
   - the intersection with the hyperplane at infinity after projective
     closure (chart artefact);
   - the degeneracy locus of `d(F_1,…,F_5)`, expected codimension ≥ 1 in the
     threefold, hence dimension ≤ 2.
4. **No complete-intersection claim.** The five forms are special; the ideal
   `(F_1,…,F_5)` need not be generated by a regular sequence in the same way
   as five general Hermitian forms. Singular-locus dimension bounds for a
   *general* five-plane do not apply, and are not used.

**Computational singular-locus ideal in coordinates:** deferred until
explicit `H_r` exist. Reporting a fake Jacobian rank without matrices would
violate the “never assert something you believe might be false” rule.

---

## 7. Primary Gate-2 question

> Does the abstract idempotent theorem already force a rational point of the
> installed symmetric cubic, without choosing coordinates?

**Answer:** **Yes** for the installed cubic scheme
`{c_3 = 0, c_2 ≠ 0}`; **no** for `C_gen` or for the common-isotropic system.

---

## 8. Gate 2 decision (repeated)

```text
P1-REDUCED
```

Reduced system to report (not solve):

```text
F_r(x, y) = 0,   r = 1..5,
x, y ∈ D = (a,b)_K,
```

eight scalar unknowns over `K_proj`, five scalar equations, expected
dimension three, smooth projective model `F14_T`.

---

## 9. What is deliberately absent

- Explicit `(a,b) ∈ K_proj× × K_proj×`
- Explicit 3×3 matrices `H_1,…,H_5`
- Any Gröbner basis, resultant, or point search on the five equations
- Any modular solubility advertised as characteristic zero
- Gate 3 conic-algebra packet (`conic_algebra.*`)

---

## 10. Replay / independence note

This file is a theorem-boundary certificate. An independent verifier should:

1. confirm that no executable quaternion matrices are claimed;
2. confirm the logical separation of `I_σ` from `F14_T`;
3. confirm the dimension count `8 − 5 = 3`;
4. refuse any reading that equates abstract idempotent existence with a
   Klein point.

**Headline:** OPEN.
