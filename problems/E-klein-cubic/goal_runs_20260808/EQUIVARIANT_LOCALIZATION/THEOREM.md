# `C_11` localization for a hypothetical `F55` compression

**Date:** 2026-08-08  
**Scope:** arbitrary degree and arbitrary finite equivariant resolution  
**Headline:** the fixed vertices and their first exceptional layer are forced
into the base locus; unrestricted exceptional localization is nevertheless
formally non-obstructive

Let

\[
 G=C_{11}\rtimes C_5,
 \qquad X=\{\textstyle\sum_i x_i^2x_{i+1}=0\}\subset\mathbf P(W),
\]

and suppose that there is a `G`-equivariant rational map

\[
 f_0:\mathbf P(W)\dashrightarrow X.
 \tag{0.1}
\]

Fix a generator of `C_11`.  In the cyclic Klein frame its five weights are

\[
 q_i=(-2)^i=(1,9,4,3,5)\in\mathbf F_{11}^{*}.
 \tag{0.2}
\]

They are the fifth roots of unity in `F_11`.  The five coordinate vertices
`p_i` are the complete `C_11`-fixed loci of both `P(W)` and `X`.  The
`C_5` generator sends `p_i` to `p_{i+1}`.

## Theorem A: every fixed vertex is a base point

The rational map (0.1) is undefined at all five `p_i`.

### Proof

The indeterminacy locus is `C_5`-stable, so it either contains all five
vertices or none.  Suppose it contains none.  Choose an equivariant smooth
resolution

\[
 \pi:Z\longrightarrow\mathbf P(W),\qquad f:Z\longrightarrow X
 \tag{1.1}
\]

which is an isomorphism near the vertices.  Every `C_11`-fixed point of `Z`
maps under `pi` to a fixed point of `P(W)`, hence

\[
 Z^{C_{11}}=\{p_0,\ldots,p_4\}.
 \tag{1.2}
\]

Equivariance under `C_5` gives one shift `s` such that

\[
 f(p_i)=p_{i+s}\quad\hbox{for every }i.
 \tag{1.3}
\]

Work in the localized equivariant Chow ring with `F_11` coefficients.  If
`t=c_1(chi_1)`, the tangent Euler class at `p_i` is

\[
 e_i=\prod_{j\ne i}(q_j-q_i)t^4=5q_i^4t^4,
 \tag{1.4}
\]

because the `q_i` are the roots of `z^5-1`.  Put
`eta=c_1^{C_11}(f^*O_X(1))`.  Its restriction at `p_i` is, up to the common
sign convention, `q_(i+s)t`.  Since `dim X=3`, one has `eta^4=0`.  Fixed
point localization gives

\[
 0=\int_Z\eta^4
  =\sum_i\frac{q_{i+s}^4}{5q_i^4}
  =q_s^4\ne0\quad\text{in }\mathbf F_{11},
 \tag{1.5}
\]

a contradiction.  This proves the theorem.  Notice that dominance was not
used.

## Theorem B: one blowup never resolves the fixed base locus

Represent (0.1) by a primitive homogeneous covariant of degree `d`, and let
`m>=1` be its common order at the five vertices.  Blow up those vertices.
On the exceptional `P^3` over `p_i`, the four `C_11`-fixed directions are
indexed by `r=1,2,3,4`, the direction toward `p_(i+r)`.

A projective covariant may be twisted by a character of `G`, but
`G_ab=C_5`; hence that twist is trivial on `C_11` and does not alter any
weight congruence below.

At least one of these four fixed directions remains a base point of the
lifted rational map.

### Proof

Suppose all four directions are regular.  At direction `r`, the fibre
character of the moving linear system is

\[
 q_i\bigl(d+m(q_r-1)\bigr).
 \tag{2.1}
\]

It must equal one of the target characters `q_j`.  Consequently the affine
map

\[
 A(q)=mq+(d-m)
 \tag{2.2}
\]

sends `Q minus {1}` into `Q`, where `Q={q_0,...,q_4}`.

Here is a calculation-free classification of that condition.  Write
`b=d-m`.  Since `A` is injective, its four images are `Q minus {u}`.  Comparing
the first and second power sums, using
`sum_(q in Q) q=sum_(q in Q)q^2=0`, gives

\[
 u=m-4b,
 \qquad b(m+9b)=0.
 \tag{2.3}
\]

If `b` is nonzero, then `m=2b`; comparison of the third power sums gives
`0=-u^3=-3b^3`, impossible.  Thus `b=0`, and multiplication by `m` carries
four elements of `Q` into `Q`; hence

\[
 d=m\in Q\pmod {11}.
 \tag{2.4}
\]

Now complete the resolution away from the first exceptional fixed locus.
Further centers have no `C_11`-fixed points and hence contribute zero to
localized degree modulo eleven.  Near the fixed locus the moving line bundle
is

\[
 L=dH-m\sum_{i=0}^4E_i.
 \]

Since it is the pullback of `O_X(1)`, its fourth power is zero.  Localization,
or equivalently the point-blowup intersection formula, therefore requires

\[
 0\equiv L^4\equiv d^4-5m^4\pmod {11}.
 \tag{2.5}
\]

But (2.4) makes the right side `-4d^4`, which is nonzero.  This contradiction
proves Theorem B.

Thus every hypothetical compression has a `C_5`-orbit of five infinitely
near `C_11`-fixed base points after the first blowup.  This is an all-degree
statement, not a bounded covariant calculation.

## Theorem C: conservation through an arbitrary resolution

The later exceptional terms can be packaged exactly.  Let (1.1) now be any
finite smooth equivariant resolution.  Put

\[
 h=c_1(\pi^*O_{\mathbf P(W)}(1)),\qquad
 \eta=c_1(f^*O_X(1)),
\]

and define the mixed projective degrees

\[
 g_b=\int_Zh^{4-b}\eta^b,\qquad 0\le b\le4.
 \tag{3.1}
\]

Thus `g_0=1`, `g_1=d`, and `g_4=0`; moreover `g_3` is divisible by three.

Every connected component of `Z^(C_11)` lies over one `p_i` and maps to one
`p_j`.  Sum its inverse Euler contribution, including the ordinary Chern
terms when the component is positive-dimensional.  Birational pushforward
under `pi` says that the sum over all components above `p_i` is
`1/(5q_i^4t^4)`.  After grouping by the shift `s=j-i` and using `C_5`
equivariance, there are uniquely defined normalized masses

\[
 n_0,\ldots,n_4\in\mathbf F_{11}
 \tag{3.2}
\]

such that

\[
 \boxed{\quad
 g_b\equiv\sum_{s=0}^4n_sq_s^b\pmod {11},
 \qquad b=0,1,2,3,4.
 \quad}
 \tag{3.3}
\]

In particular,

\[
 \sum_sn_s=1,
 \qquad \sum_sn_sq_s^4=0.
 \tag{3.4}
\]

Formula (3.3) is the exact conservation law through every sequence of point,
curve, surface, or mixed equivariant blowups.  It does not assume isolated
fixed points on the final resolution.

The Fourier matrix `(q_s^b)_(0<=b,s<=4)` is invertible.  Explicitly,

\[
 n_s={1\over5}\sum_{b=0}^4g_bq_s^{-b}.
 \tag{3.5}
\]

Consequently (3.3) imposes **no congruence at all** on `g_1,g_2,g_3` after
arbitrary exceptional fixed strata are admitted.  The fourth equation merely
determines the fifth Fourier coordinate.  Positivity and proximity of base
ideal multiplicities do not turn the `n_s` into nonnegative numbers: inverse
Euler classes already have signs and denominators, and positive-dimensional
fixed components add Chern corrections.

## A minimal exact counterconfiguration to the moment obstruction

At least two shift channels are necessary in (3.4), because every `q_s^4`
is nonzero.  Two are sufficient.  Take

\[
 (n_0,n_1,n_2,n_3,n_4)=(4,8,0,0,0).
 \tag{4.1}
\]

Then the five Fourier moments are

\[
 (g_0,g_1,g_2,g_3,g_4)\equiv(1,10,3,6,0)\pmod {11}.
 \tag{4.2}
\]

These residues have an ordinary positive log-concave lift compatible with
all immediate projective-degree requirements:

\[
 (g_0,g_1,g_2,g_3,g_4)=(1,10,91,798,0).
 \tag{4.3}
\]

Indeed `g_3` is divisible by three,

\[
 10^2\ge91,
 \qquad 91^2\ge10\cdot798,
 \qquad 91\le10^2,
 \qquad 798\le10\cdot91.
\]

This is a counterconfiguration to a contradiction based only on fixed-point
localization, projective-degree positivity, divisibility by `deg(X)=3`, and
log-concavity.  It is not asserted to be the graph of a genuine covariant.
Realizability retains the full base-ideal and landing equations, which are
the original problem.

## Verdict

The theorem-sized output is therefore:

```text
F55-C11-FIXED-VERTICES-ARE-FORCED-BASE-POINTS
F55-C11-FIRST-EXCEPTIONAL-LAYER-STILL-HAS-A-BASE-POINT
F55-C11-ARBITRARY-RESOLUTION-MOMENT-CONSERVATION
F55-C11-LOCALIZATION-MOMENTS-ARE-FORMALLY-SURJECTIVE
F55-GLOBAL-QUESTION-OPEN
```

The first two statements are genuine new restrictions on every hypothetical
map.  The last two delimit the method: a negative proof must control the
geometry of the infinitely-near base ideal, not merely append fixed-point
residue equations after an unrestricted resolution.
