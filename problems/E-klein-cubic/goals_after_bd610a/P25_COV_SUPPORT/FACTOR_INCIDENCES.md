# PC.3 factor-incidence audit

Status: `PC-FACTOR-INCIDENCE-PASS` is **not authorized**.

The inherited literal `m=1` coefficient spaces have dimensions 198 and 361
in degrees 31 and 35.  Fixed positive-invariant-multiple subspaces have exact
dimensions 197 and 361.  These are linear spans, not closed loci of covariants
having a common scalar factor.

## Exact refutation of the linear primitive quotient

In degree 31, the sum of positive-multiple basis directions `(0,9)` belongs to
`(R_+K1)_31`.  In degree 35 the analogous sum uses `(0,18)`.  For each sum the
stored five component polynomials on a fixed projective line satisfy an exact
Bezout identity

```text
sum A_i(u) p_i(u) = 1 in F_419[u].
```

The independent verifier recomputes both polynomial sums and obtains `[1]`.
The nonzero-at-infinity guard and good reduction then rule out a nonconstant
homogeneous common factor in characteristic zero.  Hence both displayed sums
have component gcd one even though they lie in the positive-multiple span.

Consequently

```text
K1_d / (R_+K1)_d
```

is an indecomposable-module quotient, not a primitive-covariant quotient.  The
landing equations do not descend to it.  In particular, the zero degree-35
linear quotient proves no degree-35 emptiness theorem.

## Required incidence loci and current state

| required closed locus | current exact state |
|---|---|
| common scalar factor of positive degree | the lower-`K1` factor subunions are constructed as kernel-aware Segre graphs; they are not exhaustive because the quotient after gcd division need only be equivariant |
| invariant-multiple images of lower-degree landing schemes | fixed linear spans and old P25 multiplier localizations only; no authoritative scheme image |
| primitive-quartic and all installed lower-map compositions | not constructed as a closed incidence locus |
| named ansatz families | no joined closed incidence locus in the inherited literal-space packet |
| union, intersections, and closures | certified lower-`K1` factor subunions are finite unions of proper images; the correct full common-factor incidence, cross-class union, and intersections remain open |
| saturation of every affine landing chart away from that union | not performed |

## Gcd-invariant theorem and the missing implication

Let `F=(F_0,...,F_4)` be a nonzero `G`-equivariant covariant and let `h` be
the homogeneous gcd of its components.  For every `g in G`, equivariance
sends `h` to an associate, so the line spanned by `h` is `G`-stable.  The
associated scalar action is a character `G -> G_m`.  Since
`G=PSL_2(F_11)` is perfect, that character is trivial.  Thus `h` is an
invariant.  Conversely, if `F=hH` and `h` is invariant, cancellation in the
polynomial domain shows that `H` is equivariant.

It does **not** follow that `H` belongs to the lower `K1` space.  An invariant
factor can itself vanish on every involution plus-plane.  Then `hH` lies in
`K1_d` even when `H` has nonzero plane restriction.  The coefficient-exact
fixed-word audit finds precisely this phenomenon (for example, nonzero
families `h*x` in both target degrees).

The correct exhaustive common-factor source is therefore

```text
P(I_e) x P(M_(d-e)),
```

where `M_r` is the full degree-`r` equivariant covariant space, cut by the
literal linear condition that the product lies in `K1_d`.  Projecting this
closed cut from the projective product gives the actual closed factor
component.  The existing packets use the smaller source
`P(I_e) x P(K1_(d-e))`; every such image is valid and closed, but their union
is only a certified sublocus.

## Kernel-aware projective graphs

For every nonempty pair `(I_e,K1_(d-e))`, introduce auxiliary coordinates
`z_(a,b)` and target coordinates `y_k`.  The component graph is defined by

```text
all 2x2 minors of the matrix (z_(a,b)),
y_k - sum_(a,b) T_e[k,a,b] z_(a,b) = 0 for every k.
```

The first equations retain the Segre variety of decomposable tensors.  The
second equations use the literal multiplication tensor.  Eliminating `z`
defines the target image ideal.  Auxiliary variables are retained in the
installed packets; no target-only elimination is claimed.

This distinction is load-bearing.  The degree-31 `e=6` tensor has shape
`198 x 118`, rank 111, and kernel dimension 7.  Its separate deep certificate
uses two maximal-minor polynomials of the `59`-column pencil; their gcd is one
at both primes, so the seven-dimensional linear kernel contains no
decomposable Segre point.  Replacing this component by its 111-dimensional
linear image would be false.

## Degree 31 lower-`K1` factor subunion ledger

The installed factor degrees in this certified subunion are
`3,5,6,7,8,9,10,11,12,13,14`.  Factor degrees at least 15 have lower degree
at most 16, where the installed `K1` circuit spaces are zero.

| e | dim I_e | lower degree | dim K1 | tensor columns | tensor rank | image dimension |
|---:|---:|---:|---:|---:|---:|---:|
| 3 | 1 | 28 | 115 | 115 | 115 | 114 |
| 5 | 1 | 26 | 75 | 75 | 75 | 74 |
| 6 | 2 | 25 | 59 | 118 | 111 | 59 |
| 7 | 1 | 24 | 44 | 44 | 44 | 43 |
| 8 | 2 | 23 | 34 | 68 | 68 | 34 |
| 9 | 3 | 22 | 25 | 75 | 75 | 26 |
| 10 | 3 | 21 | 16 | 48 | 48 | 17 |
| 11 | 4 | 20 | 11 | 44 | 44 | 13 |
| 12 | 6 | 19 | 7 | 42 | 42 | 11 |
| 13 | 5 | 18 | 3 | 15 | 15 | 6 |
| 14 | 8 | 17 | 2 | 16 | 16 | 8 |

All ranks, all-400-row multiplication identities, graph samples, and fixed
projective tangent minors replay independently at `p=419` and `p=463`.
The subunion artifact is `pc3_d31_common_factor_union.{json,npz}`; the deep
kernel certificate is `pc3_d31_e6_factor_incidence.{json,npz}`.

## Degree 35 lower-`K1` factor subunion ledger

The installed factor degrees in this certified subunion are
`3,5,6,7,8,9,10,11,12,13,14,15,16,17,18`.  Factor degrees at least 19 have
lower degree at most 16 and therefore no installed `K1` source.

| e | dim I_e | lower degree | dim K1 | tensor columns | tensor rank | kernel |
|---:|---:|---:|---:|---:|---:|---:|
| 3 | 1 | 32 | 232 | 232 | 232 | 0 |
| 5 | 1 | 30 | 165 | 165 | 165 | 0 |
| 6 | 2 | 29 | 138 | 276 | 242 | 34 |
| 7 | 1 | 28 | 115 | 115 | 115 | 0 |
| 8 | 2 | 27 | 91 | 182 | 175 | 7 |
| 9 | 3 | 26 | 75 | 225 | 210 | 15 |
| 10 | 3 | 25 | 59 | 177 | 177 | 0 |
| 11 | 4 | 24 | 44 | 176 | 173 | 3 |
| 12 | 6 | 23 | 34 | 204 | 200 | 4 |
| 13 | 5 | 22 | 25 | 125 | 125 | 0 |
| 14 | 8 | 21 | 16 | 128 | 128 | 0 |
| 15 | 10 | 20 | 11 | 110 | 110 | 0 |
| 16 | 10 | 19 | 7 | 70 | 70 | 0 |
| 17 | 13 | 18 | 3 | 39 | 39 | 0 |
| 18 | 17 | 17 | 2 | 34 | 34 | 0 |

The five kernel-bearing degrees `6,8,9,11,12` all retain their auxiliary
Segre graphs.  The subunion packet `pc3_d35_common_factor_union.{json,npz}` and
its independent verifier replay both primes.  The `e=10`, `f10` leg composed
with the fixed strict `59 x 43` inclusion agrees entry by entry with the
separately produced degree-25 multiplier map.

## Scope of the installed common-factor packets

The Hironaka factors, lower cross covariants, and target cross bases are fixed
characteristic-zero arithmetic circuits.  Nonzero good-fibre minors certify
their stated independence and the displayed image-dimension lower bounds.
The `.npz` tensors themselves are only reductions at 419 and 463: no
entrywise `Q(zeta_11)` tensor reconstruction is asserted.

The target-only eliminated ideals and their intersections have not been
computed.  More importantly, these graphs cover only the lower-`K1` sources.
An exhaustive auxiliary construction must install full lower equivariant
spaces `M_r`, impose the post-multiplication plane-restriction equations, and
then project.  A target-coordinate saturation still needs those larger graph
cuts or an equivalent auxiliary-cover computation.

Finally, on a factor component the Klein equation obeys

```text
Klein(hH) = h^3 Klein(H).
```

Hence its intersection with the landing scheme pulls back the corresponding
lower landing scheme.  In particular, the `e=6` degree-31 component and the
`e=10/f10` degree-35 component retain the unresolved authoritative PC.2
degree-25 landing ideal in their lower variables.

## Smallest remaining PC.3 incidence gate

The lower-landing-image class is not the smallest executable next gate.  Its
load-bearing degree-25 sources are exactly the unresolved PC.2 scheme, and a
complete inventory of other lower landing schemes is not installed.  The
`f6` and `f10` ambient coordinate maps are now available, but applying them
to the whole strict 43-space would overstate the authoritative nonlinear
source.

Variable lower-map compositions are also structurally larger: a correct
incidence must retain the lower map parameters, distinguish precomposition
from outer composition, and impose the lower landing ideal.  A separate
worker is auditing that class.

The smallest independently materializable remaining class is therefore the
fixed-word named ansatz union.  The inherited
`COV_STRUCTURED_SEARCH/degree_{31,35}/ansatz.json` files contain 13 and 17
selected directions, respectively, but choose only one Hironaka invariant
label for each word.  They prove emptiness only for those selected linear
ansatz spaces, not for every invariant multiple of each named word.

The minimal next computation is:

1. freeze the integral words `x,C,D,E,K` and every installed ordered two-fold
   word, with their exact code hashes;
2. for each word `w` of degree `r`, enumerate the full Hironaka basis of
   `I_(d-r)`, rather than one rotating label;
3. evaluate all `I*w` circuits at the fixed target points and compute their
   literal `K1_d` intersection (or prove the whole word family lies there);
4. express a fixed basis in the installed `K1_d` coordinates at 419 and 463;
5. record each word as its actual projective linear image and take the finite
   union by intersecting those linear ideals.

This is smaller than a variable composition graph because each word is fixed:
only its invariant multiplier varies.  The first independently testable unit
is the full invariant-multiple family of the primitive quartic `C` in degree
31, followed by the same word in degree 35.  Its verifier should recompute the
target-coordinate identities and the involution-plane restriction, not read
stored ranks.

The new `pc3_p25_multiplier_maps` packet freezes a `59 x 43` Cramer inclusion
of the full strict degree-25 coefficient space and exact arithmetic circuits
for multiplication by `f6` and `f10`.  Independent replays at primes 419 and
463 give rank-43 maps of shapes `198 x 43` and `361 x 43`, with zero residual
on all 400 evaluation coordinates.  Thus the authoritative ambient strict
space is now connected to both literal target spaces.

This still does not compute the scheme images required by PC.3: the nonlinear
PC.2 landing subscheme inside the strict 43-space is unresolved.  The earlier
fixed-59 localization closes one common branch B and deeper named branches but
leaves a 51-dimensional branch A.  Neither the ambient linear maps nor that
localization can discharge the binding lower-degree-image dependency before
PC.2 is decided.

At the authoritative PC.2 fibre, the fixed characteristic-zero source chart
used by the 419/463 multiplier packet drops to rank 15.  The separate
`verify_pc3_p25_multiplier_p89.py` replay repairs it with a determinant-74
unit chart, identifies the same strict 43-space in `Q(37)|K(6)` coordinates,
and reconstructs both rank-43 ambient maps with zero 400-row residual.  This
removes the coordinate-binding defect but does not substitute the unresolved
nonlinear PC.2 scheme through either map.

`verify_pc3_inherited_bezout.py` pins the inherited 182-record seal, rehashes
the small load-bearing snapshot in `imports_pc3/`, replays both Bezout
identities, and derives the 47/101 remaining chart counts.  Its scope is an
audit and a counterexample to the false quotient, not an incidence
construction.
