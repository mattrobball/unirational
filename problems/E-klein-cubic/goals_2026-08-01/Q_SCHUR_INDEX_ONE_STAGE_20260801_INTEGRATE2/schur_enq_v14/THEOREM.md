# Schur-split Pfaffian quintics and the associated genus-eight Fano

Date: 2026-08-01  
Scope: `K_Schur = C(P(V6))^G`, `G = PSL_2(F_11)`  
Headline verdict: **Q-UNDECIDED**

This note records an unconditional new model and its exact stopping point.  It
does **not** prove either `X_Schur(K_Schur) != empty` or
`X_Schur(K_Schur) = empty`.

## 1. The projective Schur obstruction vanishes over the Schur source

Let `E=C(P(V6))` and `K=E^G`.  The generic point of `P(V6)` is a
`G`-equivariant `E`-point.  After twisting, it is a `K`-point of
`^T P(V6)`.  Hence the associated Severi--Brauer class is zero, and

```text
^T P(V6)       = P5_K,
^T P(V6*)      = P5_K,
^T Gr(2,V6)    = Gr(2,6)_K.
```

This is special to the Schur-source field; it is the opposite of the
index-two projective-source boundary in the earlier Pfaffian packet.

The exact Klein Pfaffian five-plane

```text
B5 -> wedge^2(V6*)
```

therefore defines over `K` both the smooth cubic `X=X_Schur` and its smooth
associated Fano threefold

```text
V14 = Gr(2,V6) cap P(B5^perp).
```

The twist of the Pfaffian elliptic-quintic section space is the split
`P(V6*)=P5_K`.  Its smooth-member locus is a nonempty open.  Since `K` is
infinite, it has a `K`-point.  Thus:

> **Schur-source ENQ theorem.**  `X_Schur` contains a smooth geometrically
> integral elliptic normal quintic `C_lambda/K`.

Writing `L=ker(lambda) subset P(V6)`, this is precisely the Fano--Iskovskikh
center

```text
C_lambda = { H in X : center(H) subset L }.
```

It is not a point construction.  If `beta_C in H^1(K,Jac(C))` is the
genus-one torsor class, the embedding supplies `Pic^5(C)(K)`, hence only
`5 beta_C=0`.

## 2. What the tautological Schur point does not do

A point `x in V14` represents a line `l_x subset P(V6)`.  The union of these
lines is the irreducible Palatini quartic `W subset P(V6)`.  After base
change to `E`, the Schur tautological point is the generic point of `P(V6)`.
Since `W` is a proper quartic,

```text
p_taut notin W,
{x in V14 : p_taut in l_x} = empty.
```

Thus the tautological point does not give a `V14(K)`-point.  Choosing an
arbitrary `K`-line in the now split `P5` does not help: that line represents
a point of `V14` exactly when it is simultaneously isotropic for all five
forms in `B5`, which is the original missing Fano-point gate.

The split ambient space does give effective zero-cycles.  Since
`[V14]=sigma_1^5` in `CH^5(Gr(2,6))`, Schubert calculus gives

```text
V14 cap sigma_3    : degree 4,
V14 cap sigma_21   : degree 5.
```

Here `sigma_3` is the locus of lines meeting a fixed `K`-line in `P5`, and
`sigma_21` is the locus of lines contained in a fixed `P4` and meeting a
fixed `P2` inside it.  The numbers are

```text
integral sigma_1^5 sigma_3  = f^(4,1) = 4,
integral sigma_1^5 sigma_21 = f^(3,2) = 5.
```

Equivalently, for a general `L`,

```text
B = V14 cap Gr(2,L)
```

is the elliptic normal quintic contracted to/from the Fano--Iskovskikh link,
and a Pluecker hyperplane cuts a degree-five divisor on `B`.

Consequently `ind(V14)=1` (degrees four and five are coprime), but this gives
no rational point.  The odd degree-five cycle is only another index-one
certificate.

## 3. Exact birational links and their indeterminacy

The selected elliptic quintic produces the **Fano--Iskovskikh**, not the
Tregub--Takeuchi, link:

```text
X  -- |O_X(7)-4C| -->  V14.
```

Its resolution blows up `C`, flops the 25 bisecant lines of `C`, and
contracts the proper transform of the unique surface in `|O_X(5)-3C|` to
an elliptic quintic `B subset V14`.  The inverse is given by
`|O_V14(3)-4B|`; the non-isomorphism loci are `C` plus 25 bisecants and `B`
plus their 25 secant transforms.

The Tregub--Takeuchi link instead starts with a rational normal quartic
`Gamma subset X`: blow up `Gamma`, flop its 16 bisecants, and contract the
surface in `|O_X(3)-2Gamma|` to a point `P in V14`.  Its inverse is
`|O_V14(2)-5P|`, with 16 conics through `P`.  The ambient tautological
`p_taut in P(V6)` is not this `P in V14`.

Any actual `V14(K)`-point would nevertheless solve the headline.  The
Fano--Iskovskikh map is defined over `K`, and Nishimura's lemma applied to
the inverse rational map from the smooth `V14` to the proper `X` gives

```text
V14(K) nonempty  =>  X(K) nonempty,
```

even when the chosen point lies in the displayed indeterminacy locus.

An effective degree-five zero-cycle on `V14` does not upgrade through either
link: on a common resolution it remains a degree-five zero-cycle.  It is not
a `K`-point, and applying Tregub--Takeuchi separately over its residue fields
does not descend a rational quartic over `K`.

## 4. Degree-three cycle versus the genus-one center

Work in the only branch where this question matters, namely `X(K)=empty`.
Choose the general `K`-line `ell subset P4_K` used for the linear section.
Then

```text
Z3 = X cap ell = Spec(L3)
```

is a reduced integral point of degree three: any degree-one factor would be
a `K`-point.

The ideal of every Pfaffian `C_lambda` is generated by the six quadratic
entries of `A(x)lambda`.  If `Z3` were contained in `C_lambda`, each of those
quadratics would restrict to a degree-at-most-two form on `ell=P1` vanishing
on a length-three divisor.  Every restriction would therefore vanish
identically, forcing

```text
ell subset C_lambda subset X,
```

contrary to the construction of the proper line section.  Since `Z3` is the
spectrum of a field, its intersection with a `K`-closed subscheme is either
empty or all of `Z3`.  Hence

> **Degree-three stopping theorem.**  `Z3 cap C_lambda = empty`.

In particular the known degree-three cycle supplies neither a degree-three
divisor nor a `Pic^2(C_lambda)(K)`-point.

The same cycle can be transported through the Fano--Iskovskikh birational
map as a degree-three zero-cycle on `V14` (choose the general representative
in the common isomorphism open).  It does not thereby become a divisor on
`B`: a codimension-two inclusion `i:B->V14` has no reverse map on
zero-cycles; the refined Gysin target would be `CH_{-2}(B)=0`.

## 5. Degree fifty-five versus the genus-one center

The certified `Z55` is an integral degree-55 point obtained by taking one
general hyperplane point on each line of the transitive 55-line `D12` orbit.
There is an exact stronger statement than general-position avoidance.

For a fixed contained line `l`, the locus of section parameters `lambda`
such that `C_lambda` meets `l` is a rank-four quadric `Q_l` in the section
space `P5`.  At the split good prime 331, the 55 quadrics belonging to the
full `D12` orbit span all of

```text
H^0(P5,O(2)),   dimension 21.
```

The rank-21 minor modulo 331 proves the same spanning statement in
characteristic zero.  If a descended `C_lambda/K` met the descended line
union, then after splitting the torsor it would meet one line; Galois descent
would force it to meet every conjugate line.  Its parameter would therefore
lie in `cap_l Q_l`.  Since the `Q_l` span every quadratic form, this common
projective zero locus is empty.  Hence

> **D12-orbit stopping theorem.**  Every descended Pfaffian elliptic
> quintic is disjoint from the entire descended 55-line union, and therefore
> from the certified point `Z55` supported on it.

Even without this stronger exclusion, hypothetical containment would only
give a divisor of degree 55, and

```text
55 beta_C = 11*(5 beta_C) = 0
```

is redundant.  It cannot split the genus-one torsor.

Transport through the birational link likewise preserves only a degree-55
zero-cycle class.  It gives no restriction to `B`.  Any claimed residue-field
drop under an exceptional contraction to a divisor of degree 1 or 11 on `B`
would be a genuinely new incidence theorem, not a formal consequence of the
known point; no such theorem is installed.

More conceptually, inclusions of the centers are covariant on zero-cycles:

```text
CH_0(C) -> CH_0(X),      CH_0(B) -> CH_0(V14),
```

not contravariant.  The blow-up formula also has no `CH_0(center)` summand in
`CH_0` of the blow-up.  Finally `Pic(X_bar)=Z.H` and `Pic(V14_bar)=Z.H_V`, so
every ambient divisor restricts to either center with degree a multiple of
five.  None of these operations can manufacture degree two.

For either genus-one center, a `Pic^2(K)`-point would give `2 beta=0`; together
with `5 beta=0` this would give `beta=0`, hence a rational point.  Thus the
missing `Pic^2` choice (equivalently the cubic-scroll choice on `C`) is not a
weaker intermediate consequence of the degree-3/55 cycles; it is already a
headline-positive gate.

## 6. Full line-orbit incidence obstruction

The split Klein cubic also has a transitive orbit of 66 contained `D10`
lines.  A smooth elliptic normal quintic has no trisecants.  If a descended
`C_lambda` meets one `D10` line, descent forces the same intersection length
on all 66 conjugates.  Length two is impossible because an elliptic quintic
on a cubic threefold has exactly 25 bisecant lines.  Therefore the universal
line incidence gives a `K`-divisor of degree exactly 66 on `C_lambda`.
Since `gcd(5,66)=1`, this forces `C_lambda(K)` and hence `X(K)`.

> **Formal D10-incidence exit.**  Any Schur-source Pfaffian elliptic quintic
> meeting the descended 66-line `D10` orbit would prove
> `X_Schur(K_Schur) != empty`.

The restriction computation at the split good prime `p=331` gives, for both
a certified `D10` and `D12` representative line,

```text
rank A(u) = rank A(v) = rank A(u+v) = 2,
rank [binary coefficients of A(su+tv)] = 4,
rank [A(u);A(v)] = 4.
```

Thus the characteristic-zero restriction is
`E_0(1)|_line = O(1)+O(1)`, the global restriction map is onto its
four-dimensional section space, and the locus of `lambda` whose quintic
meets a fixed orbit line is the pullback of the `2x2` resultant quadric in
`P3` (a rank-four quadric in `P5` with vertex the `P1` of sections containing
the whole line).

The exact orbit computation closes this formal exit within the selected
Pfaffian family.  At `p=331`, the 66 `D10` incidence quadrics also span the
full 21-dimensional quadratic space.  As above, a descended intersection
would impose all 66 equations simultaneously, whose common projective locus
is empty.  The nonzero rank-21 minor proves this in characteristic zero:

> **D10-orbit stopping theorem.**  Every descended Pfaffian elliptic
> quintic is disjoint from the entire descended 66-line union.

This is a full proper-twist incidence exclusion, not a point or pointlessness
theorem for `X`: it closes one attempted way of extracting a coprime divisor
from the elliptic center.

## 7. Exact status

The new unconditional output is:

1. a smooth `K_Schur`-defined Pfaffian elliptic quintic;
2. a `K_Schur`-defined Fano--Iskovskikh link to a split-ambient `V14`;
3. effective degree-four and degree-five cycles on `V14`, hence index one;
4. an exact proof that the known degree-three cycle misses the genus-one
   center and the degree-55 cycle cannot provide coprime degree there;
5. the exact rank-21 obstruction showing that neither the 55-line nor the
   66-line orbit can meet a descended member of this Pfaffian family.

No rational point or pointlessness theorem follows.  The binary verdict stays
`Q-UNDECIDED`.

Primary geometric source used: A. Iliev--D. Markushevich, *The Abel--Jacobi
map for a cubic threefold and periods of Fano threefolds of degree 14*,
especially the Fano--Iskovskikh and Tregub--Takeuchi theorem statements, the
Puts description of the Palatini quartic, and the Pfaffian kernel-bundle
theorem in the checked local TeX source; arXiv:math/9910058,
<https://arxiv.org/abs/math/9910058>.
