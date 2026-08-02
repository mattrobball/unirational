# Projective rational covariants: the mixed-degree reduction

## Result

Let `G = PSL_2(F_11)`, let `W` be the five-dimensional Klein module, and let
`U = B_5^perp` be the ten-dimensional Pluecker target.  A rational
`G`-equivariant map

```text
P(W)  --->  P(U)
```

is represented by one primitive homogeneous polynomial `G`-covariant
`P : W -> U`.  If its image lies in the fixed `F_14`, then `P` lands in the
affine Pluecker cone.  Consequently mixed-degree formulas and invariant
denominators do not define an additional class of projective maps.  They
homogenize to a single degree; the unresolved issue is that this degree has
no known a priori bound.

The exact Hilbert--90 frame and the weight-one invariant

```text
R = [x,C,D,E,K],       degrees = [1,4,5,6,7],
tau = f3^2/f5
```

give an all-degree finite normal form.  Polarizing the unique quadratic map
`Sym^2(W) -> U` on pairs of columns of `R`, then dividing a pair `(i,j)` by
`tau^(d_i+d_j)`, gives a generically spanning family in the degree-zero
projective function field.  The good-fibre replay selects the ten pairs

```text
(x,x), (x,C), (x,D), (x,E), (x,K),
(C,C), (C,D), (C,E), (C,K), (D,D)
```

of degrees

```text
2,5,6,7,8,8,9,10,11,10.
```

Their determinant is `2 mod 23`.  Since the exact Molien calculation gives
rank ten for the Fano-target covariant module over the invariant field, the
corresponding exact lifts form a `K_proj`-basis on a dense open.

Thus every rational equivariant target vector has the unique form

```text
p = c0*eta0 + ... + c9*eta9,       ci in K_proj.
```

Using a full quadratic isomorphism `Sym^2(W) -> wedge^2(V6)` on all fifteen
pairs of frame columns gives a relation-test frame.  Its determinant is
`21 mod 23`.  Pairing `p wedge p` against that frame produces exactly fifteen
quadratic equations in the ten `ci`, with coefficients in `K_proj`.  The
replay directly checks scalar invariance after tau-normalization and checks
the resulting `15 x 55` coefficient tensor at two nontrivial group
translates.

This is an exact finite structural reduction, not a point: no solution of
the fifteen quadrics over `K_proj` is constructed.

## Why projective equivariance forces a homogeneous covariant

Put `S = C[W]`.  Any rational map `P(W) -> P(U)` can be represented by a
tuple of homogeneous forms of one degree.  Remove their common gcd and call
the resulting primitive tuple `P`.

For `g in G`, projective equivariance says that the two primitive tuples

```text
P(g*x)        and        g*P(x)
```

are proportional over `Frac(S)`.  If primitive tuples `A,B in S^n` satisfy
`B=(a/b)A`, with `a,b` coprime, then `b` divides every component of `A` and
`a` divides every component of `B`.  Primitivity forces both to be units.
Hence

```text
P(g*x) = lambda_g * g*P(x),       lambda_g in C^*.
```

Composition shows that `g -> lambda_g` is a character of `G`.  The group is
perfect, so the character is trivial.  The replay independently checks that
the normal closure of the commutator of the sealed two generators has order
`660`.  Therefore `P(g*x)=g*P(x)` exactly.

The converse is immediate.  This proves

```text
rational G-map P(W) -> F14
  <=> primitive homogeneous G-covariant W -> affine_cone(F14)
       of some degree d.
```

The existing complete homogeneous exclusions through degree 16 therefore
exclude precisely maps whose primitive representative has degree at most
16.  They do not exclude degree 17 or higher because no degree bound is
known.  Cross-degree cancellation is not a separate loophole.

## Replay

```sh
/opt/homebrew/bin/python3 -u \
  C5_PROJECTOR_INCIDENCE/verify_projective_mixed_reduction.py
```

Final marker:

```text
C5_PROJECTIVE_MIXED_REDUCTION_OK
```

The JSON output is
`C5_PROJECTOR_INCIDENCE/projective_mixed_reduction.json`.

## Scope

Proved:

- character twists cannot occur;
- rational projective maps have primitive homogeneous covariant
  representatives;
- tau-normalized mixed degrees admit a finite ten-coordinate `K_proj`
  normal form;
- the Fano condition becomes fifteen invariant quadrics in those ten
  coordinates.

Not proved:

- a `K_proj`-point of those quadrics;
- emptiness of those quadrics over `K_proj`;
- an upper bound for the degree of a primitive homogeneous landing
  covariant.
