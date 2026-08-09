# Rank-one terminal Fano addendum

**Date:** 2026-08-08  
**Status:** theorem-level necessary-condition sieve; the final threefold
exclusion is still open  
**Scope:** the geometric `C11`-`G`-Fano point-base branch

Keep the notation of `THEOREM.md`.  Thus

```text
K = C(t),  L = C(s),  s^5=t,
gamma(s)=zeta_5 s,  while descent sends a |-> a^9,
R=<9>={1,3,4,5,9} subset F_11^*.
```

Let `X/K` be a terminal Fano threefold with a faithful action of the
nonsplit group scheme `A`.  In this note we impose, after geometric base
change, the actual `G`-Fano hypothesis

```text
rank Cl(X_bar)^C11 = 1.                                    (GF)
```

This is the hypothesis in Prokhorov's and Prokhorov--Shramov's geometric
`G`-Fano theorems.  An arithmetic MMP output known only to have invariant
rank one over `K` does not automatically satisfy (GF); every conclusion
below is conditional on this distinction.

## 1. Two arithmetic lemmas

### 1.1 Twisted projective weights

For a projective `A`-representation, choose a lift after splitting `A`.
Its weights form a multiset in `F_11`, well defined up to simultaneous
translation.  Galois descent acts on this multiset by

```text
j |-> 9j+c.
```

This affine map has one fixed point `p=c/(1-9)` and two orbits of length
five, `p+R` and `p-R`.  Translating all weights by `-p`, every descended
projective weight multiset is therefore a union of

```text
{0}, R, -R.                                                (1)
```

For a canonically linearized bundle, such as `-K_X`, the translation is
zero.  In particular, a faithful linear representation of `A` has
dimension at least five, and a faithful five-dimensional one has weights
`R` or `-R`.

The following elementary zero-sum consequences will be used.  On a single
five-cycle there is no weight-zero quadratic monomial.  The weight-zero
cubics are precisely one five-cycle

```text
x_i^2 x_(i+1),                                             (2)
```

after cyclically ordering the weights by multiplication by `9=-2`.  The
weight-zero quartics are precisely one five-cycle

```text
x_i^2 x_(i+2) x_(i+4).                                    (3)
```

These assertions are unchanged if `R` is replaced by `-R`.  They are a
five-line check in `F_11`, not a degree sweep.

### 1.2 A local fixed-point obstruction

Let `P` be a closed `A`-fixed point on a terminal Gorenstein threefold and
put `E=k(P)`.  If `E` does not contain `L`, then `A_E` is still nonsplit.
The action on the Zariski tangent space is faithful: a finite group acting
faithfully on an irreducible germ acts faithfully on its tangent space
(Bialynicki-Birula, as quoted in Prokhorov--Shramov, Remark 3.4).  A
three-dimensional terminal Gorenstein germ is a cDV hypersurface, so its
embedding dimension is at most four.  This contradicts the five-dimensional
lower bound in Section 1.1.  Hence

```text
every closed A-fixed Gorenstein point has residue field containing L. (4)
```

In particular, on any finite reduced `A`-fixed subscheme, the sum of the
degrees of its closed points is divisible by five.

There is a prime-to-index version for a non-Gorenstein terminal point of
index `r`.  If `(r,11)=1`, the canonical index-one cover is functorial.  The
preimage of `A_E` in its automorphism group is a central extension by
`mu_r`; its `11`-primary subgroup is the unique complement and is
isomorphic to `A_E`.  It fixes the point above `P`, whose index-one-cover
germ is cDV of embedding dimension at most four.  Thus (4) also holds for
an `A`-fixed terminal point whose index is prime to `11`.

The coprimality is essential.  At index `11` or `22`, the order-eleven
action can mix with the deck group of the index-one cover, and this
argument supplies no four-dimensional linear representation of `A_E`.

## 2. Gorenstein geometric rank one

Assume that `X_bar` is Gorenstein, `rho(X_bar)=1`, and (GF) holds.  Then the
following is an exhaustive necessary list:

```text
index 2, degree 3       the smooth Klein cubic;
index 1, genus 6        singular, Q-factorial, with the representation
                        and singular-orbit restrictions in Section 2.3;
index 1, genus 7        singular, Q-factorial, exactly five singular points;
index 1, genus 8        smooth Pfaffian-Klein, or singular, Q-factorial,
                        exactly five singular points.
                                                               (5)
```

No other Gorenstein geometric-rank-one case survives.

### 2.1 Index at least two

Use the standard terminal del Pezzo-threefold classification.

* Index four is a form of `P3` and is excluded by the projective-weight
  lemma.
* At index three the ample generator embeds the threefold as a quadric in
  `P4`.  Its five weights are one orbit `R` or `-R`, but this orbit contains
  no opposite pair.  Hence there is no descended semi-invariant quadratic
  equation.
* At index two and degree five the threefold is smooth and has automorphism
  group `PGL2`.
* In degree four the ample generator gives an intersection of two quadrics
  in `P5`.  The six projective weights are one five-cycle and one fixed
  weight.  Since a two-dimensional descended ideal cannot contain a
  nontrivial `A`-module, both quadrics must have the fixed induced weight.
  After translating the fixed coordinate to weight zero, the only such
  quadric is its square.  Two independent equations do not exist.
* In degree two the double-cover map to `P3` is equivariant and the
  order-eleven action on the base is faithful; this contradicts the
  projective-weight lemma.
* In degree one the unique base point of the fundamental linear system is
  `K`-rational and `A`-fixed, contradicting Section 1.2.
* In degree three the five ambient weights form one five-cycle.  By (2) the
  cubic is

  ```text
  sum_i c_i x_i^2 x_(i+1).
  ```

  The order-five descent permutes the five monomial lines transitively, so
  every `c_i` is nonzero.  A diagonal change of coordinates makes all
  coefficients equal (the exponent matrix has determinant `33`).  Thus the
  cubic is the smooth Klein cubic.

This proves the index-at-least-two part of (5), including terminal singular
members rather than only the smooth classification.

### 2.2 Main series in genera two through five

For genus two, and for the non-very-ample genus-three case, the
anticanonical map is a double cover of a threefold of minimal degree.  Its
kernel has order at most two, so `A` acts faithfully on the image.  The
smooth possibilities are `P3`, a quadric, and a scroll over `P1`; they are
excluded respectively by the projective/orthogonal lemmas and by passing
to the generic `P2` fibre over the ruling.  If the minimal-degree image is
singular, its vertex is a point or a line; a fibre of the double cover over
the vertex gives an `A`-fixed closed point of degree at most two, contrary
to Section 1.2.

The very ample genus-three case is a quartic in `P4`.  Formula (3) and the
transitivity of descent show that its geometric equation is, after diagonal
rescaling,

```text
Q_4:  sum_(i mod 5) x_i^2 x_(i+2) x_(i+4) = 0.             (6)
```

This is a genuine terminal `F55`-model, but it is not a geometric
`C11`-`G`-Fano.  Indeed its singular locus consists exactly of the five
coordinate vertices.  At a vertex its affine equation is

```text
bd+a^2c+bc^2+ab^2d+acd^2=0.
```

The splitting lemma gives a cDV singularity of type `cD_10`: the reduced
plane function has three smooth branches with pairwise intersection
multiplicities `1,1,4`, hence Milnor number `10`.  To see that there are no
other singularities, put

```text
m_i=x_i^2 x_(i+2)x_(i+4).
```

At a singular point, multiplying the five partial derivatives by `x_i`
gives the linear system

```text
2m_i+m_(i-2)+m_(i+1)=0.
```

Its circulant determinant is `44`, so every `m_i` vanishes; the derivative
equations then leave only the five vertices.  Finally `Q_4` contains, for
example, the `C11`-invariant plane `{x_1=x_2=0}`.  This plane is not
`Q`-Cartier at the vertex `[1:0:0:0:0]` (it is one of the three local
branches).  Its class and the Cartier hyperplane class are independent in
`Cl(Q_4)_Q`.  Thus

```text
rank Cl(Q_4)^C11 >= 2,
```

contrary to (GF).  If (GF) is dropped and only geometric Picard rank one is
retained, (6) is an exact additional survivor and demonstrates why the two
rank conditions cannot be conflated.

At genus four, the anticanonical model is a quadric-cubic complete
intersection in `P5`.  Its weights are `R+{0}` (up to sign), so its unique
quadric would have to be a multiple of the square of the fixed coordinate;
this cannot define an integral threefold.  At genus five, the model is an
intersection of three quadrics in `P6`, with weights `R+{0,0}`.  Its
three-dimensional quadratic ideal must be trivial as an `A`-module, hence
is exactly `Sym^2` of the two fixed coordinates.  The common zero locus then
contains the ambient `P(R)=P4`, again impossible.

This excludes genera two through five under (GF).

### 2.3 Genera six through twelve

Prokhorov--Shramov, Lemma 7.6, applied with `p=11`, makes every main-series
`G`-Fano of genus `6,7,8,9,10` `Q`-factorial.  Genus twelve is smooth by
their Lemma 7.7 and Prokhorov's genus-twelve theorem.

For genus six, put `V=H^0(-K_X)`.  Then

```text
V = 1^3 + U,                 dim U=5, weights(U)=R or -R.
```

The anticanonical model is scheme-theoretically cut out by six quadrics.
The quadratic ideal cannot be the six-dimensional trivial summand
`Sym^2(1^3)`, since then its zero locus contains `P(U)=P4`.  Consequently

```text
I_2(X) = 1 + U_epsilon,       epsilon in {+,-}.             (7)
```

Here `Sym^2(U_+)=U_+ + 2U_-`, so (7) is the complete representation-level
alternative.  The smooth genus-six cases are excluded in
`SMOOTH_FANO_ADDENDUM.md`; hence a survivor is singular.

Namikawa's general bound, in the form quoted in Prokhorov's 2017 paper,
gives `s(X)<=29` for genus six.  Write the geometric singular set as `f`
points fixed by `C11` and `q` free `C11`-orbits.  Section 1.2 gives

```text
f = 0 mod 5,        s(X)=f+11q<=29,        q<=2.            (8)
```

Thus the only possible singular-point counts are

```text
5,10,15,20,25;  11,16,21,26;  22,27.                       (9)
```

If a `cA_1` point occurs, Prokhorov's sharper estimate `s(X)<=15` leaves
only `5,10,11,15`.

For genera at least seven, Prokhorov, *On the number of singular points of
factorial terminal Fano threefolds*, Theorem 1, gives

```text
g       7  8  9  10  12
s(X)<=  7  5  3   2   0.                                  (10)
```

Every singular point is fixed by `C11`, since the bound is below eleven.
By Section 1.2 the total number is divisible by five.  Therefore a singular
genus-seven or genus-eight survivor has exactly five singular points, while
genera nine, ten, and twelve are smooth.  The smooth sieve excludes genera
seven, nine, ten, and twelve and reduces smooth genus eight to the
Pfaffian-Klein case.  This proves (5).

The cases left in (5), especially singular genera six through eight, are
not excluded by the cited classification.

### 2.4 A sharp conditional K3 obstruction

There is one useful way to recognize what any survivor in (5) must avoid.
Suppose that it has an `A`-stable, geometrically integral anticanonical
divisor `S` which is normal with at worst Du Val singularities.  First the
action on `S` is faithful.  Otherwise `A` fixes `S` pointwise.  At its
generic point the normal line would be a one-dimensional representation of
`A` over the regular field `K(S)`.  The nonsplit `A` has no nontrivial
character over that field, so the normal action is trivial as well; formal
linearization of the finite action would make `A` trivial on `X`, a
contradiction.

The minimal resolution of `S_bar` is therefore a K3 surface with a faithful
`C11` action, and the actions lift.  If `a` acts on its one-dimensional
space of holomorphic two-forms by
`lambda in mu_11`, the semilinear descent operator `delta` fixes the
constant field `C`, while

```text
delta a delta^-1=a^9.
```

Conjugating on the two-form line therefore gives `lambda=lambda^9`, hence
`lambda=1`.  Thus `a` would be a symplectic automorphism of order eleven on
a K3 surface, impossible by Nikulin's classification (the possible prime
orders are `2,3,5,7`).

Consequently no such `A`-stable elephant can occur on a survivor.  Ordinary
general-elephant theorems do not produce a normal Du Val member inside the
invariant linear subsystem.  (For genera six and seven this subsystem is
nonempty because `H^0(-K)` contains respectively `1^3` and `1^4`; its base
locus and its behavior at the surviving singular orbit are the unresolved
points.)  Likewise, Namikawa and Jahnke--Radloff supply a
smoothing and Picard constancy, but not a smoothing equivariant for the
given `C11` action and its multiplier-`9` semilinear descent.  This is why
neither argument silently reduces the singular cases to the smooth sieve.

## 3. Non-Gorenstein baskets: an exact finite necessary list

Now assume that `X_bar` has at least one non-Gorenstein terminal point.  For
a point `P`, let `r_P` be its local index.  Kawamata's basket inequality,
as used in Prokhorov--Shramov, Proposition 8.1, is

```text
sum_P (r_P-1/r_P) < 24.                                   (11)
```

The `C11`-orbits on the non-Gorenstein locus have length one or eleven.
An orbit of length eleven must have index two, since

```text
11(3-1/3)>24,
```

and there can be at most one such orbit.  For pointwise fixed points whose
index is prime to eleven, Section 1.2 says that the number of geometric
points of each fixed index is divisible by five.  Inequality (11) then says
that such an index can only be `2`, `3`, or `4`.

The only indices divisible by eleven which can occur are `11` and `22`.
Combining these observations with the strict inequality (11) gives the
following exhaustive necessary list of actual local-index multisets:

```text
{2^5}, {2^10}, {2^15},
{3^5}, {2^5,3^5}, {4^5},
{2^11},
{11}, {11,2^5}, {11^2}, {22}.                             (12)
```

For example, an eleven-point orbit contributes `11(2-1/2)=33/2`, so no
additional five-point index-two block is possible.  One index-eleven point
leaves room only for a five-point index-two block; two index-eleven points
or one index-twenty-two point leave room for none.  This proves (12)
without enumerating the Q-Fano database.

List (12) is only a necessary basket list.  The exceptional baskets
containing indices `11` or `22` survive precisely because the local
index-one-cover extension need not split off the nonsplit `A`.  No cited
classification simultaneously eliminates (12), treats the required
semilinear descent, and preserves (GF).

## 4. What `ed_K(A)=4` would and would not imply

The upper bound `ed_K(A)<=4` is known.  To prove equality by this route one
must exclude every three-dimensional **versal** `A`-variety, hence every
terminal point-base output left in (5) and (12), as well as the arithmetic
rank-one/geometric-rank-larger boundary.

Let `F55=C11 semidirect_9 C5`.  If an `F55`-threefold `Y` is
`F55`-unirational, twist an equivariant dominant map from a representation
by the generic `C5`-torsor `L/K`.  The source remains a `K`-vector space and
the twist of `Y` is an `A`-unirational threefold.  Hence

```text
F55-unirational threefold  =>  ed_K(A)<=3.                 (13)
```

Consequently `ed_K(A)=4` would imply that the Klein cubic is not
`F55`-unirational.  Since `F55` is the order-55 Borel subgroup of
`PSL(2,11)`, `PSL(2,11)`-unirationality would restrict to
`F55`-unirationality; thus equality would prove the desired negative result
for the Klein cubic.

No stronger group-action conclusion follows.  In particular:

* `ed_K(A)=4` does **not** mean that `F55` has no regular action on a
  threefold.  It acts on the Klein cubic, and also on the terminal cyclic
  quartic (6).
* It does not formally imply `F55` is absent from `Cr3`; a faithful rational
  action need not be versal or equivariantly unirational.
* Conversely, classifying constant `F55`-actions does not exclude a
  nonconstant semilinear descent.  Over `L=C(s)` the descent operator has
  the form `h(s)gamma`, with twisted norm one, and need not specialize to an
  order-five automorphism of one constant complex Fano.
* Failure of `F55`-unirationality for the Klein cubic alone would not imply
  `ed_K(A)=4`, because another three-dimensional `A`-versal Fano could
  exist.

Thus the valid target is `F55`-**unirationality/versality NO**, not
`F55`-action NO.  The remaining terminal configurations in (5) and (12)
show exactly why the current classification does not yet prove it.
