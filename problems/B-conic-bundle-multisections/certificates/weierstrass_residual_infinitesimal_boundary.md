# Short-Weierstrass infinitesimal rigidity: certificate and exact boundary

This note records an axiom-clean local infinitesimal certificate for the special family

```text
x |-> specializeFirstCoordinates x F.
```

The global dependency has since been closed by the stronger nonlinear Hesse route:
`Standard.exists_pencil_of_hasCommonResidualLineMap` and `exists_good_line` are both proved and
axiom-audited.  The infinitesimal route below is therefore independent corroboration, not a
dependency of the good-line theorem.

## Lean certificate

The file
`BConicBundleMultisections/WeierstrassResidualInfinitesimalCertificate.lean` works at

```text
G_(A,B) = -U^3 + V^2 W - A U W^2 - B W^3.
```

On the affine dual chart `W = sU+tV`, Lean proves directly from the universal residual covariant
that the first ambient residual quartic is

```text
-4 (A^2 s^2 t^2 + A s^3 - 3 A t^2 + B s^4 - 9 B s t^2 + s).
```

The theorem `tangent_eq_smul_of_cross_equations` is the finite rank certificate.  Write
`(da,db,dc,dd,de,df,dh,di,dj,dk)` for a tangent cubic.  Ten coefficients of

```text
R_U dR_V - R_V dR_U,
R_U dR_W - R_W dR_U,
R_V dR_W - R_W dR_V
```

are enough:

```text
 24 dc = 0
-36 dd = 0
-16 db = 0
4 (4 A dc - de) = 0
-6 (6 A dd + df) = 0
12 (A dh + 3 B dc + di) = 0
12 (A da + 5 B dc - di) = 0
-2 (A db + 135 B dd + 9 dj) = 0
-8 (2 A de + 9 B da - 9 dk) = 0
-16 (2 A^2 dc - A de + 9 B dh + 9 dk) = 0.
```

If `A != 0` or `B != 0`, Lean concludes

```text
da = -dh,  db=dc=dd=de=df=dj=0,  di=-A dh,  dk=-B dh.
```

Thus the tangent cubic is `-dh * G_(A,B)`: its projective tangent direction is zero.  The helper
`ne_zero_or_ne_zero_of_discr_ne_zero` supplies `A != 0 or B != 0` from
`4 A^3 + 27 B^2 != 0`.

The same file retains the independent first-component/global-scalar certificate
`tangent_eq_smul_of_residualU_equations`.  It concludes the same scalar tangent, together with
`mu = 5 dh`, from twelve coefficients of `dR_U = mu R_U`.

The audit file
`BConicBundleMultisections/WeierstrassResidualInfinitesimalCertificateAxiomAudit.lean` prints only
Lean's foundational axioms (`propext`, `Quot.sound`, and where needed `Classical.choice`), and no
`sorryAx`.

There is also an independent nonflex tangent-point certificate in
`BConicBundleMultisections/TangentPointResidualInfinitesimalCertificate.lean`.  It works at

```text
U^2 V + V^2 W + P U W^2 + Q V W^2 + S W^3
```

and proves that thirteen sparse residual cross-product coefficients force all nine normalized
tangent coefficients to vanish when

```text
D = 27 P^4 - 16 P^2 Q^3 + 72 P^2 Q S - 16 Q^2 S^2 + 64 S^3 != 0.
```

Its three-chart proof is finite field algebra.  The exceptional chart is closed by the identity

```text
3 D = (9 P^2 + 4 Q S)^2 + (48 S - 16 Q^2) (3 P^2 Q + 4 S^2).
```

The corresponding axiom audit again prints only Lean's foundational axioms and no `sorryAx`.

## Exact external derivation of the ten inputs

Run

```sh
python3 certificates/weierstrass_residual_infinitesimal_certificate.py
```

The script starts from the same universal residual covariant, derives all three residual quartics,
differentiates a universal ten-coefficient tangent cubic, forms the three cross-products, and
asserts the ten displayed coefficients symbolically.  It also checks rank nine on both parameter
charts `A != 0` and `B != 0`.  This is an exact symbolic check, not a numerical sample; it is still
external evidence rather than a Lean proof of coefficient extraction.

The optional tangent-point derivation can be reproduced by

```sh
python3 certificates/tangent_point_residual_infinitesimal_probe.py \
  --nonflex-normal --minor --cover-minors
```

It extracts the thirteen Lean hypotheses from the universal residual covariant and verifies the
three determinant factors used in the Lean case split.

## Historical alternative route (not used)

Assume every line is bad, so the specialized family has a common residual-line map.  The intended
direct route is now:

1. Choose one smooth fibre `G_x0` and make one fixed projective change in the `y` coordinates which
   carries it to `G_(A,B)`.  Apply the same change to the whole family.
2. Pointwise projective equality of residual maps implies the three cross-product identities for
   `R(G_x,L)` and `R(G_x0,L)`.  Density in the base and dual-plane affine charts upgrades equality
   on `k`-points to polynomial identities.  Differentiating at `x0` supplies the ten hypotheses of
   `tangent_eq_smul_of_cross_equations` for every base tangent direction.
3. Repeat at every smooth fibre.  The coefficient map from the base to projective cubic space then
   has zero differential on a dense open.  In characteristic zero, its coordinate quadratics are
   projectively constant: equivalently all Wronskians
   `q_i * pderiv_r q_j - q_j * pderiv_r q_i` vanish and the ratios `q_i/q_j` are constants.
4. Consequently all cubic fibres are scalar multiples of one cubic (in particular they lie in a
   pencil), contradicting `not_eq_pencil_of_smooth`.

This would give another proof of the specialized statement consumed by `GoodLineExistence`.
The current tree instead proves the stronger arbitrary-index-family theorem directly.

## Remaining bridges for this unused infinitesimal alternative

### 1. Flex support to short Weierstrass

This normalization is now closed axiom-free by
`ShortWeierstrassNormalForm.exists_shortWeierstrass_coordinates`.  Its flex-support input
`HesseNormalForm.exists_weierstrassSupport_coordinates` supplies inverse coordinate matrices and a
smooth transformed cubic with

```text
coeff(V^3) = coeff(U V^2) = coeff(U^2 V) = 0,
coeff(V^2 W) = 1,
coeff(U^3) != 0.
```

The checked shear-and-scaling continuation carries this form to

```text
a U^3 + e U^2 W + f U V W + V^2 W + i U W^2 + j V W^2 + k W^3
```

with `a != 0`, and then to short Weierstrass form.  No cube root is used.  The formulas are:

1. Substitute `V_old = V - (f U + j W)/2`.  The new coefficients are
   `E=e-f^2/4`, `I=i-fj/2`, and `K=k-j^2/4`.
2. Substitute `U_old = U - E/(3a) W` to kill `U^2 W`.
3. Substitute `W_old = -a W` and multiply the cubic by `-a^-1` to obtain
   `-U^3 + V^2 W - A U W^2 - B W^3`.

Coordinate equivariance of the residual construction is also proved.  Thus this first bridge is no
longer an open item.

### 2. Common-map to infinitesimal cross equations

`HasCommonResidualLineMap` is stated pointwise over field-valued lines, not over dual numbers.  One
must first form the cross-products as polynomials in the base and line parameters, use infinitude
to prove those polynomials are zero, and only then differentiate.  Coordinate equivariance of the
undifferentiated residual form is already proved; its use in this density/differentiation bridge is
not yet packaged.

### 3. Characteristic-zero integration

The final implication "zero projective differential on the smooth open implies constant
projective coefficient map" is not currently a named Mathlib theorem.  A low-degree proof can be
made finite because the ten cubic coefficients are homogeneous ternary quadratics: extract their
six coefficients and prove directly that vanishing of all three Wronskians makes every pair
proportional.  A fraction-field derivation proof is conceptually shorter but needs more API.

## Source line conditions (2) and (3)

The current formal `exists_good_line` concludes only G3: nonconstancy of the residual line with
the cubic-fibre parameter.  It does not state that the generic `C intersect L` is reduced or that
`[-2]` is injective on its three points.

Those two conditions are used in the source to make the map from the vertical surface to its
residual image birational.  The current component/base-change route deliberately does not consume
that birationality, which is why `PLAN.md` marks them unnecessary.  If source-faithful line data is
required anyway, it is a separate strengthening: define the two bad loci in the dual plane, prove
they are proper closed subsets (tangent lines for reducedness, and the finitely many two-torsion
difference loci for `[-2]`-injectivity), prove G3 is a nonempty open condition, and intersect the
three opens.  None of those predicates or avoidance lemmas is presently part of the conclusion of
`exists_good_line`.

## Reproduction

```sh
lake build +BConicBundleMultisections.WeierstrassResidualInfinitesimalCertificate
lake env lean BConicBundleMultisections/WeierstrassResidualInfinitesimalCertificateAxiomAudit.lean
python3 certificates/weierstrass_residual_infinitesimal_certificate.py
lake build +BConicBundleMultisections.TangentPointResidualInfinitesimalCertificate
lake env lean BConicBundleMultisections/TangentPointResidualInfinitesimalCertificateAxiomAudit.lean
python3 certificates/tangent_point_residual_infinitesimal_probe.py \
  --nonflex-normal --minor --cover-minors
```
