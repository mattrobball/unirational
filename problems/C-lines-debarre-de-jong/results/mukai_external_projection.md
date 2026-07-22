# External projection of a genus-6 Mukai sixfold

Command:

```sh
M2 --script experiments/mukai_external_projection.m2
```

The script works exactly over `QQ`.  It takes the smooth genus-6 Mukai
sixfold in `P^10` used in the inner-projection experiment and projects it from
the external point

```text
q = [p14=1].
```

The displayed quadric has value `2` at `q`, so the center is not on the
source.  Elimination gives a prime six-dimensional image `Y` in `P^9`, of
degree 10, with minimal generator degrees

```text
2, 2, 4, 4, 4, 4, 4, 4.
```

This example genuinely escapes the elementary low-generator lemma: its ideal
needs eight generators rather than at most six.

The seven-dimensional family of source lines survives the projection.  The
source argument is the same as for the inner-projection experiment:
adjunction gives `-K_X=4H`, Mori's bound supplies a covering family of lines,
and a general free line has a rank-five normal bundle of degree two, hence a
seven-dimensional Hilbert component.  Since `q` is outside `X`, every source
line avoids the center.  If a fiber of the induced map on line schemes were
positive-dimensional, infinitely many distinct source lines would lie in
the inverse-image plane over one target line.  Their union is dense in that
plane, so closedness would put the whole plane in `X`, including `q`; this is
impossible.  Thus the projected image has a seven-dimensional family of
lines.

The construction nevertheless cannot be contained in a smooth hypersurface.
The exact saturated calculation shows that

```text
I_Y + (all entries of jacobian(gens I_Y))
```

has the single projective zero

```text
y = [z=1].
```

Equivalently, every minimal generator `G_i` and every differential `dG_i`
vanishes at `y`; the embedded tangent space of `Y` there is all of `P^9`.
For any homogeneous `F` in `I_Y`, write
`F=sum A_i G_i`.  Then `F(y)=0` and

```text
dF(y) = sum (A_i(y)dG_i(y) + G_i(y)dA_i(y)) = 0.
```

Every hypersurface containing `Y` is therefore singular at `y`, regardless
of its degree.  This pointwise conormal obstruction is strictly stronger than
the low-generator obstruction and avoids an expensive degree-nine global
smoothness saturation.

The script independently certifies the external-center condition; source
dimension, degree, primeness, and smoothness; image dimension, degree,
primeness, and generator degrees; and the reduced degree-one locus where all
embedded conormal differentials vanish.
The line-family assertion uses the characteristic-zero geometric argument
above.
