# Low-dimensional birational audit for the generic twisted `C11`

**Date:** 2026-08-08
**Status:** `ed_K(A)>=3 PROVED / DIMENSION THREE REDUCED TO FANO`

Let

```text
K = C(t),   L = C(s),   s^5=t,
```

and let `gamma(s)=omega*s`.  Let `A/K` be the form of `mu_11` for which
`gamma` acts on `X^*(A_L)=F_11` by multiplication by `9`.

If an `A`-compression of dimension `d` exists, then after passing to `L` and
then to an algebraic closure, its descent is represented birationally by

```text
delta = h gamma,       delta^5=1,       delta a delta^-1 = a^9,       (1)
```

where `a` generates the split `C11`.  For `d<=2`, the geometric target is
rational: it is geometrically unirational in characteristic zero.  Thus (1)
is a semilinear cocycle in `Cr_d`.

The distinction between a **constant normalizer** `h` and a genuinely
parameter-dependent Cremona cocycle is essential.

## 1. Two elementary representation lemmas

### 1.1 Minimal torus rank

Over every regular field extension `F/K`, every `F`-torus containing `A_F`
has dimension at least four.

Indeed, `L tensor_K F` is still a field of degree five.  On character
lattices an embedding `A_F -> T` gives a Galois-equivariant surjection

```text
X^*(T) -> F_11(9).
```

Choose a lift in the absolute Galois group of a generator of
`Gal(LF/F)=C5`.  Its image on `X^*(T)` has finite order.  Since its action on
the quotient `F_11(9)` has order five, the order of the integral matrix is
divisible by five.  Hence its characteristic polynomial has a cyclotomic
factor `Phi_m` with `5|m`; this has degree at least `phi(5)=4`.  Thus
`rank X^*(T)>=4`.

Notice that `T` need not split over `L`; the finite-order lift argument is
why the conclusion still holds.

### 1.2 Projective weight obstruction

There is no embedding of `A_F` into an inner `F`-form of `PGL_n` for
`n<=4`.
After a separable extension, a projective `C11`-action has a multiset `W` of
`n` weights in `F_11`.  Galois descent makes `W` invariant under an affine
permutation

```text
j |-> 9j+c.
```

This permutation has one fixed point and two orbits of length five.  Since
`n<=4`, `W` is supported at the fixed point and the projective action is
trivial.  For an inner form `PGL_1(D)`, split `D` and read the same weights
there.  The argument applies over any further field extension disjoint from
`LF/F`, not just over regular extensions of `K`.

## 2. No faithful action on a geometrically rational surface

> **Theorem.**  The group scheme `A/K` has no faithful rational action on a
> geometrically rational surface.  The same holds after every regular field
> extension of `K`.

Resolve and compactify the action, then run the `A`-equivariant surface MMP.
The output is either a del Pezzo surface or a conic bundle.

For a del Pezzo surface `S`:

* in degrees at most five, `Aut(S_bar)` acts faithfully on `Pic(S_bar)`, and
  the relevant Weyl groups have no element of order eleven;
* in degree six, the component group has order prime to eleven and the
  identity component is a two-dimensional torus, contradicting Section 1.1;
* in degree seven, the canonical blowdown of the two disjoint outer
  `(-1)`-curves is automorphism-equivariant.  The pair is uniquely
  characterized by the geometric intersection graph, hence is Galois-stable
  and its contraction descends to `F`.  The target is a degree-nine del
  Pezzo surface, and `Aut(S)` embeds in its inner form of `PGL3` (an
  automorphism trivial after blowdown is trivial on a dense open set),
  contradicting Section 1.2;
* in degree eight, the `F_1` case has a unique geometric `(-1)`-curve, so
  its blowdown likewise descends and embeds `Aut(S)` in the automorphism
  group of a degree-nine del Pezzo surface.  In the quadric-surface case the
  odd-order subgroup lies in the identity component.  After the
  at-most-quadratic extension `E/F` separating the two rulings, this
  component acts on the two conic bases.  Since `A_E` has prime order and
  acts faithfully, one of its two projections to a form of `PGL2` is
  faithful.  Section 1.2 excludes both cases; degrees two and five are
  coprime, so `E` is disjoint from `LF/F` and the multiplier remains `9`;
* in degree nine, `Aut(S)` is an inner form of `PGL3`, again excluded by
  Section 1.2.

For a conic bundle `S -> B`, the map from the prime-order group scheme `A`
to `Aut(B)` is either trivial or injective.  The base is a geometrically
rational curve.  An injection is impossible because `Aut(B)` is a form of
`PGL2`, excluded by Section 1.2.  Hence `A` acts trivially on `B` and
faithfully on the generic conic.  Its automorphism group is again a form of
`PGL2`, now over the regular extension `K(B)/K`, giving the same
contradiction.

This argument handles the genuinely nonconstant descent cocycles left open
by the algebraically closed Cremona classification.

### Essential-dimension consequence

If `ed_K(A)<=2`, a compression target is geometrically unirational and hence,
in characteristic zero, geometrically rational.  Its generically free
`A`-action is faithful, contradicting the theorem.  Therefore

```text
ed_K(A) >= 3.                                                   (3)
```

Combined with the previously installed projective upper bound, the exact
ordinary range is now

```text
3 <= ed_K(A) <= 4.
```

## 3. No constant normalizer in dimensions one or two

There is no faithful birational action of

```text
F55 = C11 semidirect_9 C5
```

on a rational curve or rational surface over an algebraically closed field of
characteristic zero.

For curves this is the classification of finite subgroups of `PGL2`.

For surfaces, run the `F55`-equivariant surface MMP.

* In the conic-bundle case, if `C11` acts nontrivially on the base, then the
  whole group would embed in `PGL2`.  If `C11` acts trivially on the base, it
  acts on the generic fibre.  A semilinear automorphism of that `P1` can only
  preserve or exchange the two `C11` fixed points, and hence induces `+1` or
  `-1` on `C11`, never multiplication by `9`.
* On a del Pezzo surface of degree at most five, the automorphism action on
  the Picard lattice is faithful, while the relevant Weyl groups have no
  prime divisor `11`.
* In degree six, `Aut(S)=(G_m)^2 semidirect D_12`; both odd factors would lie
  in the torus and commute.
* In degree seven, the canonical blowdown of the two outer `(-1)`-curves
  embeds the group in `PGL3`, where the same three-weight argument as in
  degree nine applies.
* In degree eight, `F_1` reduces by its canonical blowdown to `PGL3`.  For
  `P1 x P1` the odd-order group lies in `PGL2 x PGL2`; on each factor a
  normalizer of `C11` induces only `+1` or `-1`, never `9`.  Neither case
  contains `F55` faithfully.
* In degree nine, suppose `F55` embedded in `PGL3`.  If the three projective
  `C11` weights form a multiset `W` in `F_11`, conjugation by the order-five
  element would make `W` invariant under

  ```text
  j |-> 9j+c.
  ```

  This affine permutation has one fixed point and two orbits of length five.
  An invariant multiset of cardinality three is supported at its fixed point,
  so `C11` would act by scalars.  This is a contradiction.

Consequently, if (1) becomes `h gamma` with `h` defined over the constant
field, then `delta^5=1` gives `h^5=1`, and `<a,h>` is a copy of `F55` in
`Cr_d`.  This is impossible for `d<=2`.

This is a strict subcase of the unconditional surface theorem in Section 2.
It also explains why the algebraically closed finite-subgroup classification
alone initially sees only a conditional obstruction.

Here is the exact isotriviality hypothesis under which this argument applies.
Suppose that, after base change to `L`, the compression is birational to a
constant rational variety `Y_0 x_C L`, the split `C11`-action is identified
with a constant element `a in Bir(Y_0)`, and the resulting descent class

```text
[h] in H^1(C5, N_{Bir(Y_0)_L}(<a>))
```

is represented by an element of the constant subgroup
`N_{Bir(Y_0)}(<a>)(C)`.  Then the preceding `F55` contradiction proves that
such a compression cannot have dimension at most two.  Equivalently, the
same conclusion holds if the normalizer cocycle is cohomologous, through a
change of birational trivialization, to a constant cocycle.

Mere birational isotriviality is weaker and does **not** meet this
hypothesis.  In an arbitrary trivialization its descent datum is

```text
h(s) gamma,       h(s) h(omega s) ... h(omega^4 s)=1,
```

with `h(s) in N_{Bir(Y_0)}(<a>)(L)`.  The twisted product is not `h(s)^5`,
so it produces no finite subgroup `F55` of the constant Cremona group.
Moreover, linearizing the individual element `a` over an algebraic closure
does not simultaneously make this normalizer cocycle constant: changing the
linearization replaces `h(s)` by a nonabelian coboundary, and the full
normalizer has parameter-dependent Cremona maps and Sarkisov links.  Thus
`F55 not\subset Cr2(C)` by itself implies `ed_K(A)>=3` only under the stated
constant-cocycle (or cohomologically constant) hypothesis.  Section 2 is the
separate arithmetic argument that removes that hypothesis.

## 4. A stronger all-degree exclusion for a fixed toric model

Let `T=(G_m)^d` be the standard birational torus.  Its normalizer in the
Cremona group has quotient `GL_d(Z)`.  Suppose all the maps in (1) preserve
one fixed torus, and let `M` be the lattice image of `h`.  The cocycle and
normalizer relations imply

```text
M^5=I,                 M v = 9v mod 11,                         (2)
```

where `v` is the nonzero `C11` weight vector.

For `d<=3`, `GL_d(Z)` has no element of order five: a primitive fifth root of
unity has minimal polynomial `Phi_5` of degree four.  Hence `M=I`, and the
second equation in (2) forces `v=0`, a contradiction.

The parallel projective-linear statement is just as rigid.  A projective
`C11` action on `P^d` gives a multiset of `d+1` weights in `F_11`, and the
normalizer relation makes it invariant under `j |-> 9j+c`.  Since this
permutation has one fixed point and two five-cycles, a multiset of cardinality
at most four is supported at the fixed point.  The projective action is then
trivial.  Hence a faithful projectively linear model also requires `d>=4`.

Thus:

```text
NO-TORIC-OR-MONOMIAL-SEMILINEAR-MODEL-IN-DIMENSION-LE-3.
```

This is an all-degree analytic statement.  It uses no search and no CAS.  A
hypothetical surface compression must change toric models through genuinely
non-toric Cremona links during the five Galois conjugates.

## 5. Why the surface classification alone does not finish the lower bound

Every element of prime order greater than five in the plane Cremona group is
birationally linearizable.  Moreover, the required *one-step* outer
automorphism is present in the Cremona normalizer.

For example, on the dense torus put

```text
a(x,y) = (zeta*x,y),
h(x,y) = (x^9*y^4, x^11*y^5).
```

The exponent matrix

```text
M = [[9,4],[11,5]],       det(M)=1,
```

satisfies

```text
h a h^-1 = a^9.
```

It has trace `14` and infinite order.  It cannot itself be the order-five
descent datum, and Section 4 shows that no correction staying in this toric
normalizer can work.  Nevertheless, this example proves that conjugacy of
`a` and `a^9` is not an obstruction.  The missing statement would have to
classify nonconstant cocycles

```text
h(s) gamma(h(s)) ... gamma^4(h(s)) = 1
```

in the full Cremona normalizer, including ramified Sarkisov degenerations at
`s=0` and `s=infinity`.  The algebraically closed classification of a single
`C11` action does not classify these cocycles.  Section 2 excludes them by
arithmetic equivariant MMP, not by the one-element classification.  No cited
classification excludes a three-dimensional Fano cocycle, so it gives no
proof of `ed_K(A)>=4`.

## 6. Threefold MMP reduction and the exact surviving configuration

The surface theorem also eliminates every positive-dimensional Mori base for
a hypothetical three-dimensional `A`-compression.

Indeed, let `Y -> B` be the output of an `A`-equivariant threefold MMP.  The
base `B` is geometrically rationally connected and is dominated by the
unirational compression target.  If `A` acts faithfully on `B`, then
`dim(B)<=2` contradicts Section 2 (and the curve case).  Otherwise `A` acts
trivially on `B` and faithfully on the generic fibre.  For `dim(B)=2` this is
a conic over `K(B)`; for `dim(B)=1` it is a geometrically rational surface
over `K(B)`.  Both are excluded by Sections 1--2 because `K(B)/K` is regular.

Thus any three-dimensional `A`-versal model must be `A`-birational to a
terminal Fano threefold with invariant relative Picard rank one.  This is a
genuine finite-type birational-geometric boundary, not a degree search.

`SMOOTH_FANO_ADDENDUM.md` proves the following further, deliberately scoped
statement.  If this Fano output is smooth and has **geometric** Picard rank
one, then its only geometric survivors are the Klein cubic and genus-eight
prime Fanos whose associated Pfaffian cubic is the Klein cubic.  The unique
ordinary genus-six order-eleven model is excluded because its full
automorphism group is the constant abelian group `C11`, which cannot descend
with multiplier `9`.  Terminal singular outputs, geometric Picard rank
greater than one, and outputs having only an arithmetic/invariant Picard-rank
condition are not covered by that sieve.

`TERMINAL_FANO_BOUNDARY.md` and `RANK_ONE_TERMINAL_ADDENDUM.md` record the
exact singular boundary.  In the
Gorenstein geometric `G`-Fano branch with `rho>1`, Prokhorov reduces to eight
explicit degeneration types; an order-eleven survivor there must be singular,
geometrically non-`Q`-factorial, and have `rank Cl>=11`.  The Gorenstein `rho=1` and
non-Gorenstein terminal branches are not completely classified by the cited
literature.  Under the additional geometric condition
`rank Cl(X_bar)^C11=1`, the rank-one addendum leaves only the smooth
Klein/Pfaffian-Klein cases, singular Q-factorial genera `6,7,8` (with exactly
five singular points in genera `7,8`), and eleven explicit necessary
non-Gorenstein baskets.  These survivors are not exclusions.

The Klein cubic realizes the precise smooth Fano configuration which
survives this reduction.

Let

```text
w = (1,9,4,3,5) in F_11^5,
a = diag(zeta^w_0,...,zeta^w_4),
b[x_0:x_1:x_2:x_3:x_4] = [x_1:x_2:x_3:x_4:x_0].
```

Then

```text
b^5=1,                 b a b^-1 = a^9.
```

The recurrence `w_(i+1)=-2w_i` shows that both transformations preserve the
Klein cubic

```text
X: sum_i x_i^2 x_(i+1) = 0.
```

Thus `F55` acts regularly on the smooth, unirational threefold `X`.  The five
coordinate vertices are exactly `X^C11`; they are smooth points and form one
`C5` orbit.  Twisting by `L/K` turns this fixed locus into a closed point of
degree five.  Hence the standard fixed-point and orbit-size tests are passed
exactly, rather than merely failing to detect an obstruction.

This is the concrete nonlinear escape from the linear and toric bounds: the
smallest projective representation is `P4`, but its invariant Klein cubic has
dimension three.  `F55`-unirationality of the Klein cubic would make the
generic `C5` twist `A`-versal.  Neither that assertion nor the associated
trace-cubic rational-point problem is known; low-dimensional classification
does not rule this candidate out.

## 7. Strict conclusion

```text
constant curve descent                         EXCLUDED
constant rational-surface descent              EXCLUDED
all geometrically rational surfaces             EXCLUDED
single-torus descent in dimensions <=3         EXCLUDED
projectively linear model in dimensions <=3    EXCLUDED
nonconstant non-toric surface cocycle           EXCLUDED BY EQUIVARIANT MMP
positive-dimensional threefold Mori base        EXCLUDED
rank-one Fano threefold                          SURVIVES
smooth geometric-rank-one Fano                   REDUCED TO KLEIN/PFAFFIAN-KLEIN
terminal singular Fano                            FINITE NECESSARY LISTS / OPEN
geometric-rank >1 or arithmetic-only rank one     OPEN
Klein threefold fixed-point configuration       EXISTS EXACTLY
ed_K(A)>=3                                      PROVED
ed_K(A)>=4                                      NOT PROVED
Klein PSL2(F11)-NO                              NOT PROVED
```
