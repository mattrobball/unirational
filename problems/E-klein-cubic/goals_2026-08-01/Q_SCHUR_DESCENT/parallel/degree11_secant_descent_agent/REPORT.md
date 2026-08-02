# Degree-11 `A5` secants: exact six-root completion and bounded descent

## Verdict

For each of the six exact constant landing maps supplied by the two maximal
`A5` classes, the transferred eleven-point orbit has full linear span in
`P4`, has quadric-evaluation rank `11`, and has `55` proper pair secants with
`55` distinct third intersections.  The third intersections form another
degree-`55` orbit with stabilizer `D12`.

This new orbit has the same transitive `G`-set and the same residue-field
type `E^D12/K` as the installed degree-`55` point, but it is not the installed
line/hyperplane point: the corresponding third intersection is off the
corresponding contained `D12` line in every one of the six certified good
fibres.  The secant relation is exact in `CH_0`, but it is signed and supplies
no rational point.  The headline therefore remains

```text
Q-UNDECIDED
```

## 1. Completing the two missing class-1 roots

At the good prime `89`, the class-1 parameter cubic is

```text
t^3 + 56 t^2 + 69 t + 18
  = (t-80)(t^2+47t+2).
```

The quadratic discriminant is `65`, a nonsquare in `F_89`.  In

```text
F_89[u]/(u^2-65)
```

the two omitted roots are

```text
21 + 45u,  21 + 44u.
```

The analyzer implements this quadratic field directly and repeats the full
Hilbert--90 transfer, exact `A5` covariance guards, Klein substitution, coset
enumeration, and rank computation.  Together with the class-1 root `80` and
the class-2 roots `49,51,75`, this covers all six roots of the two exact
parameter cubics.

For every root the eleven conjugates are distinct and give

```text
linear evaluation rank   = 5,
quadric evaluation rank  = 11,
quadrics through Z11     = 4.
```

The nonzero minors at this good fibre are characteristic-zero exclusions:
the corresponding generic orbit is not contained in a plane or a `P3`, and
its quadric rank is not at most `9`.  Thus all six maps fail the plane-cubic,
twisted-cubic, and rational-normal-quartic tests.

There is a slightly stronger degree-four conclusion.  If a `K`-defined curve
of degree at most four contained the transitive orbit, then after splitting
the torsor `G=PSL_2(F_11)` would act on its at most four geometric components.
Simplicity and `|G|>|S4|` make this component action trivial.  The component
through one point would therefore contain all eleven.  Linear rank five
makes that component nondegenerate in `P4`; degree at most four then forces a
curve of minimal degree, hence a rational normal quartic, contradicting
quadric rank `11>9`.  Consequently none of these six natural degree-11
cycles lies on a `K`-defined curve of degree at most four.  This closes the
direct `3*4-11=1` residual-curve exit for these cycles.

The four quadrics themselves have no hidden positive-dimensional carrier.
Singular gives, for all six roots,

```text
dim affine cone of four-quadric base = 1,
h-vector                              = 1,4,6,4,1,
projective degree                     = 16;

dim affine cone after adding Klein F = 1,
h-vector                              = 1,4,6,3,-3,
projective degree                     = 11.
```

Thus the four quadrics are a complete intersection of length `16`, and their
intersection with the Klein cubic is exactly the length-`11` orbit in this
good fibre.  Dimension semicontinuity and the already-present eleven generic
points rule out a generic positive-dimensional quadric base or a forced extra
point of `X` from this four-quadric construction.  This is an exclusion of
this canonical base-locus route, not a classification of all surfaces.

The exact linkage calculation makes the Cayley--Bacharach boundary explicit.
Colon by the reduced eleven-point ideal leaves a linked length-`5` scheme
with h-vector

```text
1,4
```

in every case.  It spans all of `P4`; in particular it has no special linear
span that could lower the descent degree.  Reducing the Klein cubic modulo
the residual Groebner basis is nonzero for all six roots, so
Cayley--Bacharach does **not** force the residual five points onto `X`.
For five roots the residual intersection with `X` is projectively empty.  At
the displayed class-2 specialization `alpha=49`, one orbit point is a
nontransverse point of the four-quadric base (Jacobian rank `3` rather than
`4`), and the linked residual meets `X` there with degree one.  This is the
same already-known orbit point, not a new residual point; the full
four-quadric base intersected with `X` still has degree exactly `11`.  No
generic lift is inferred from this accidental special-fibre overlap.

## 2. The 55 third intersections

For two points `p,q` on the Klein cubic, write

```text
F(sp+tq) = st(A s + B t).
```

When `(A,B)!=(0,0)`, the third intersection is `[Bp-Aq]`.  The replay checks
this formula and substitutes the result into the Klein cubic for every one of
the `55` unordered pairs and every one of the six maps.  In all six cases:

```text
proper pair secants             = 55,
distinct third intersections    = 55,
linear rank of residual orbit   = 5,
quadric rank of residual orbit  = 15.
```

The action of `G` on unordered pairs of the eleven `A5` cosets is transitive.
Every pair stabilizer has order `12` and element-order distribution

```text
1^1, 2^7, 3^2, 6^2,
```

so it is the installed `D12` class.  Distinctness at the good fibre is an
open nonvanishing condition.  Hence generically the third intersections form
a genuine reduced degree-`55` closed point

```text
R55,  with residue field E^D12 up to G-conjugacy.
```

Summing the 55 line-section identities gives the exact rational-equivalence
relation over `K`

```text
10 [Z11] + [R55] = 55 H3  in CH_0(X).
```

Indeed each of the eleven points occurs in ten unordered pairs, and each
proper secant cuts one cubic linear section of degree three.

## 3. Comparison with the installed degree-55 point

The installed point `Z55` is obtained differently: over `E^D12` one takes a
point on the contained `D12` projective line, equivalently a general
hyperplane point on each of its 55 conjugates.  Abstractly `R55` and `Z55`
have the same stabilizer and residue-field type.  That does not identify
their geometric points or their zero-cycle classes.

For each unordered pair the analyzer reconstructs its `D12`, its central
involution, and the two-dimensional minus-eigenspace whose projective line is
contained in the Klein cubic.  It then tests the corresponding third
intersection against that corresponding line.  The result for all six maps
is

```text
third intersections on their corresponding D12 lines = 0 of 55.
```

Because `D12` is self-normalizing, the transitive `G/D12` set has no
nontrivial `G`-equivariant relabeling.  Therefore this good-fibre
nonincidence rules out identity with the installed line-supported orbit as a
generic rational construction.  There are incidental cross-line incidences
in two displayed class-2 specializations (one among `55*55` tests in each);
no claim of disjointness from the entire line union is made.

The relation

```text
[R55] = 55 H3 - 10 [Z11]
```

is a signed equality.  It neither makes `R55` equal to `Z55` nor produces an
effective degree-one cycle.  Having two points over isomorphic degree-55
fields also supplies no descent theorem.  Thus the secant construction adds
an exact `CH_0` relation and a second degree-55 point, but no `K`-point.

## 4. Palatini boundary

The computation closes the original-cubic degree-four residual-curve route
and the four-quadric/linkage shortcut for these six cycles.  It does not
explicitly transport the eleven points
through a chosen Fano--Iskovskikh birational map to `V14` and then to points
on the Palatini quartic.  Consequently it does not certify the linear span
of any such transported orbit, and it does not exclude every `K`-defined
cubic curve through a transported degree-11 cycle.  That remains a separate
incidence calculation.

## Replay

From this directory run

```sh
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify.py
```

The terminal marker is

```text
A5_DEGREE11_ALL_SIX_SECANT_DESCENT_AUDIT_OK
```
