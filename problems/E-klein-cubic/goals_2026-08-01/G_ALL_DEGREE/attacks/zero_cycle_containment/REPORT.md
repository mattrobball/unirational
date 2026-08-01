# Zero-cycle containment and closed-point descent audit

## Verdict

This attack does **not** decide the Goal G headline.  It closes two tempting
shortcuts exactly.

1. If a finite etale residual cycle of degree at most four on the genuine
   projective generic twist is already split by the connected generic
   `PSL(2,11)`-extension, then it contains a ground-field point.  Thus a
   genuinely `E`-split quadratic or quartic residual would finish the
   positive problem.
2. Merely constructing the residual over the ground field does not imply
   that it is split by `E`.  A smooth cubic-threefold countermodel below
   shows that the residual quadratic field can be wholly unrelated to the
   previously known Galois extension.

3. A general cubic-surface section through the effective `D12` line-orbit
   construction and Voisin's cubic-surface theorem give the unconditional
   alternative: the genuine projective generic twist has a rational point,
   or it has one integral primitive quartic point with Galois closure `A4` or
   `S4`.  The second alternative remains possible and is not a rational
   point.

A ground-field residual construction still supplies no theorem that its
splitting field lies in `E`.  Consequently the small-permutation argument
cannot be applied without a new field-containment input.  Throughout this
packet

\[
K=K_{\rm proj}=\mathbf C(\mathbf P(W))^G,
\qquad E=\mathbf C(\mathbf P(W)),
\]

so the cubic is exactly the genuine twist represented by
`generic_cubic.json`, not an auxiliary Schur-cover twist.

## 1. Exact small-splitting lemma

Let `E/K` be the connected generic projective torsor.  Its Galois group is

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),\qquad |G|=660,
\]

and `G` is nonabelian simple.  Let `R` be a finite etale `K`-scheme of degree
`n <= 4`, and suppose

\[
R_E\simeq \operatorname{Spec}(E^n).
\]

The Galois action on the `n` geometric points gives a homomorphism

\[
G\longrightarrow S_n.
\]

Its kernel is normal.  Simplicity says that the homomorphism is trivial or
injective, while `|S_n| <= 24 < 660` rules out injectivity.  The action is
therefore trivial, every point is defined over `K`, and `R(K)` is nonempty.

For a quadratic field point this can also be phrased as follows: an
`E`-split quadratic point would define an index-two intermediate field of
`E/K`, but `G` has no index-two subgroup.

The same proof works for any `n` for which `G` does not embed in `S_n`; only
`n=2` and `n=4` are needed here.  The script `group_check.g` independently
checks the order and simplicity of the exact finite group used in the
argument.

## 2. Why a ground-field residual need not be `E`-split

Let `a in K^x` be a nonsquare such that `sqrt(a)` is not in `E`.  In the
actual simple-Galois situation, every nonsquare stays nonsquare in `E`:
otherwise `K(sqrt(a))` would be an index-two intermediate field of `E/K`.

In `P^4_K` consider

\[
X_a:\quad
x_0(x_0^2-a x_1^2)+x_2^3+x_3^3+x_4^3=0.
\]

This cubic threefold is smooth.  Indeed, its partial derivatives force
`x2=x3=x4=0` and `x0*x1=0`; either choice then forces both `x0=x1=0`, so
there is no projective singular point.

On the `K`-line `L={x2=x3=x4=0}`, the intersection divisor is

\[
X_a\cap L=\{x_0=0\}+\{x_0^2-a x_1^2=0\}.
\]

The first summand is a `K`-point, while the residual degree-two cycle is
defined over `K` but splits only over `K(sqrt(a))`, not over `E`.  Thus even
for a smooth cubic threefold and an entirely ground-field residual
construction, the implication

```text
residual cycle is K-defined  =>  residual cycle is split by E
```

is false.  `counterexample.sing` verifies the restriction and projective
smoothness over the exact rational-function field `QQ(a)`.

## 3. Closed-point degree reduction does not force termination

Balestrieri's Theorem 3.6 applies to a degree-`d` form made isotropic over a
simple extension of degree `n`, under its stated bad-partition hypothesis.
For `(d,n)=(3,55)` the controlling number is

\[
nd-n-d=107.
\]

The bad-partition set is empty here.  A partition of 107 cannot have all
parts divisible by 3.  If every part not divisible by 3 were divisible by
55, at most one such part could occur; removing it would leave 52, which is
not divisible by 3.  The theorem therefore gives some new prime-to-three
point degree at most 107 and not divisible by 55.

This is a real reduction of divisibility, but it is not a decreasing-degree
algorithm.  For every `n>3` coprime to 3, the one-part outcome

\[
[,2n-3,]
\]

is compatible with the theorem's numerical conclusion: `2n-3` is coprime
to 3, is not divisible by `n`, and is the upper bound.  Hence the permitted
sequence

\[
55,107,211,419,835,\ldots,\qquad n_{i+1}=2n_i-3,
\]

strictly grows.  The theorem does not assert that this worst case occurs for
the Klein point; it shows that its stated conclusion alone cannot prove
termination at degree two.  An explicit factorization arising from an
explicit degree-55 point could do better, but no such terminating
factorization is currently installed.

The relevant primary sources are:

- F. Balestrieri, *Degrees of closed points on hypersurfaces*, Theorem 3.6,
  <https://arxiv.org/abs/2304.04562>;
- Q. Ma, *Closed points on cubic hypersurfaces*,
  <https://arxiv.org/abs/1908.03139>;
- D. Coray, *Algebraic points on cubic hypersurfaces*,
  <https://doi.org/10.4064/aa-30-3-267-296>.
- C. Voisin, *Rank 2 vector bundles and degrees of points of del Pezzo
  surfaces*, arXiv v2 (20 February 2026), Theorem 1.5,
  <https://arxiv.org/abs/2509.17996>.  The v2 PDF observed for this audit has
  SHA-256
  `fc2210924b225cd095f2d428cfd50fb798535a153465832f65c56b1ec32069c5`.

None of the cited conclusions supplies the missing `E`-splitting statement
for an arbitrary residual or an unconditional descent of the surviving
primitive quartic to degree two on a cubic threefold.

## 4. Genuine-twist quartic frontier

The installed `D12` line has full stabilizer of order 12, so its orbit has
degree `660/12=55`.  Over the connected generic torsor, twisting that orbit
gives a projective-line bundle over the connected degree-55 field
`E^D12/K`.  Choose a general `K`-hyperplane.  Bertini and avoidance give a
smooth cubic-surface section `S` which meets the 55 conjugate lines
transversely.  Their intersections form one closed point of degree 55 on
`S`.

The surface also has its ordinary degree-three linear-section cycle, and
`55-18*3=1`; hence it has a zero-cycle of degree one.  Voisin's
characteristic-zero Theorem 1.5 says that such a smooth cubic surface either
has a ground-field point or a point over an extension of degree four.
Therefore

\[
X(K)\ne\varnothing
\quad\text{or}\quad
X\text{ has an effective closed point of degree }4.
\]

In the no-point branch the degree-four cycle is necessarily one integral
closed point: every other partition of four has a degree-one or degree-two
component, and a quadratic point on a cubic hypersurface yields a
ground-field point by the conjugate-secant third-intersection construction;
if the conjugate secant is contained in the cubic, that `K`-line itself has
`K`-points.
If its quartic residue field had an intermediate quadratic field, applying
the same quadratic descent twice would again yield a `K`-point.  The
quartic is therefore primitive.  Enumerating transitive subgroups of `S4`
then leaves exactly `A4` and `S4` for its Galois closure.

Thus the exact unconditional frontier for the genuine twist is

\[
\boxed{X(K)\ne\varnothing\quad\text{or}\quad
X\text{ has a primitive quartic point with closure }A_4\text{ or }S_4.}
\]

The no-point alternative is not ruled out by formal group theory: a primitive
quartic field need not be contained in the unrelated degree-660 field `E`.

## 5. Exact remaining gate

This route would become positive if one proves either of the following for
the genuine projective generic twist:

1. the primitive quartic supplied above has an intermediate quadratic field
   (which immediately descends twice to a `K`-point);
2. its splitting field embeds in `E` (the small-splitting lemma then makes
   all four points rational); or
3. an explicit closed-point reduction has an actual quadratic factor.

Without one of those new inputs, the small-splitting lemma is conditional
and the headline remains open.

## Replay

From the repository goal directory:

```text
/opt/homebrew/bin/python3 G_ALL_DEGREE/attacks/zero_cycle_containment/verify.py
```

Optional primary-source hash replay:

```text
/opt/homebrew/bin/python3 \
  G_ALL_DEGREE/attacks/zero_cycle_containment/verify.py \
  --voisin-pdf /path/to/arxiv-2509.17996v2.pdf
```

Expected final markers:

```text
ZERO_CYCLE_SMALL_SPLITTING_LEMMA_OK
ZERO_CYCLE_RESIDUAL_CONTAINMENT_COUNTERMODEL_OK
ZERO_CYCLE_CLOSED_POINT_NONTERMINATION_OK
ZERO_CYCLE_GENUINE_QUARTIC_FRONTIER_OK
ZERO_CYCLE_CONTAINMENT_ROUTE_AUDIT_OK
HEADLINE_OPEN
```
