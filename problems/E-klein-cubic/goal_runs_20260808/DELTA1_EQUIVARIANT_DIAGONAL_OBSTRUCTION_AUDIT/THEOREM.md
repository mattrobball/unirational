# The degree-one equivariant-diagonal obstruction audit

**Date:** 2026-08-08  
**Field:** \(\mathbf C\)  
**Group:** \(G=\operatorname {PSL}_2(\mathbf F_{11})\), \(|G|=660\)  
**Verdict:** every currently theorem-forced finite test of the
Kresch--Tschinkel equivariant diagonal passes or has no rational-retraction
variance; no contradiction to a rational \(G\)-retraction is obtained

Let \(X\) be the Klein cubic threefold.  Consume Theorem 1.1 of
`../DELTA1_EQUIVARIANT_MINIMAL_CLASS_AUDIT/`: a rational \(G\)-retraction

\[
 X\hookrightarrow \mathbf P(W)\dashrightarrow X
\]

forces a \(G\)-equivariant integral decomposition of the diagonal in the
sense of Kresch--Tschinkel, Definition 4.2.  This packet tests the direct
finite consequences of that necessary condition.

## 1. The equivariant degree-one condition passes exactly

For a Sylow subgroup \(P_p\leq G\), choose \(x_p\in X^{P_p}\).  The exact
fixed-locus packets give

\[
 X^{P_2}\ne\varnothing,\qquad X^{P_3}\ne\varnothing,\qquad
 X^{P_5}\ne\varnothing,\qquad X^{P_{11}}\ne\varnothing.
\tag{1.1}
\]

Here one may take \(P_2=V_4\); the respective fixed loci contain six, six,
four, and five points.  The equivariant maps

\[
 G/P_p\longrightarrow X,\qquad gP_p\longmapsto g x_p,
\]

give classes \(z_p\in CH_0^G(X)\).  Their equivariant degrees are the
indices

\[
 \deg_0^G(z_2)=165,\quad \deg_0^G(z_3)=220,\quad
 \deg_0^G(z_5)=132,\quad \deg_0^G(z_{11})=60.
\tag{1.2}
\]

Indeed, on an Edidin--Graham approximation \(U\), the map represented by
\(G/P\) is \(U/P\to U/G\), of degree \([G:P]\).  Consequently

\[
 \boxed{\zeta=-13z_{11}+3z_5+z_2+z_3}
\tag{1.3}
\]

satisfies

\[
 \deg_0^G(\zeta)=-13\cdot60+3\cdot132+165+220=1.
\tag{1.4}
\]

Signed coefficients are allowed in the Chow group.  Thus the first clause
of Kresch--Tschinkel Definition 4.2 is already satisfied unconditionally.

This also corrects a tempting but invalid shortcut: the size-twelve
`11:5` vertices and the size-fifty-five ambient `A4` points occurring in
other packets are not point orbits on the Klein cubic.  In fact
\(X^{A_4}=\varnothing\).  They are not used in (1.3).

## 2. Fixed loci do not inherit a decomposition of the diagonal

Suppose

\[
 [\Delta_X]=[X]\times\zeta+\gamma,
 \qquad
 \gamma\in\operatorname {im}\bigl(CH_3^G(D\times X)
 \to CH_3^G(X\times X)\bigr)
\tag{2.1}
\]

for a proper invariant closed subset \(D\subsetneq X\).  Put

\[
 D_{\mathrm{nf}}=\bigcup_{1\ne g\in G}X^g.
\tag{2.2}
\]

The action is generically free, hence \(D_{\mathrm{nf}}\subsetneq X\) is
proper, closed, and invariant.  Replacing \(D\) by
\(D'=D\cup D_{\mathrm{nf}}\) preserves (2.1), and now

\[
 X^H\subset D'\qquad(1\ne H\leq G).
\tag{2.3}
\]

Therefore restriction or equivariant localization of (2.1) to a component
\(F\subset X^H\) leaves the support term on all of \(F\times X\), not on a
proper subset of the first factor.  Even after the normal Euler class is
inverted, it is not an ordinary decomposition of \(\Delta_F\).

In particular, the involution fixed locus

\[
 X^{C_2}=E_\sigma\sqcup L_\sigma
\]

with \(E_\sigma\) elliptic gives no contradiction: Kresch--Tschinkel's
condition does **not** imply universal \(CH_0\)-triviality of
\(E_\sigma\).  The same observation disposes of every finite fixed-locus
incidence test unless an additional theorem controls the support \(D\).

The full abelian-subgroup necessary condition also passes.  Up to
conjugacy the nontrivial abelian subgroups are

\[
 C_2,C_3,V_4,C_5,C_6,C_{11},
\]

and the installed exact packets give a nonempty fixed locus for each one.

## 3. Higher Amitsur and standard torsor tests collapse

The Lefschetz theorem gives

\[
 \operatorname {Pic}(X)=\mathbf Z[H].
\tag{3.1}
\]

The hyperplane bundle \(H=\mathcal O_X(1)\) is honestly \(G\)-linearized by
the five-dimensional representation.  Hence

\[
 \operatorname {Pic}([X/G])\longrightarrow
 \operatorname {Pic}(X)^G
\]

is surjective, the ordinary Amitsur group and the universal-torsor
obstruction vanish, and the Scavia--Tschinkel--Zhang theorem gives

\[
 \operatorname {Am}^d(X,G)=0\qquad(d\ge2).
\tag{3.2}
\]

The same proof works after restriction to every subgroup of \(G\).

For every \(G\)-torsor \(T/K\), twisting the four maps in Section 1 gives
zero-cycles on \({}^T X\) of degrees \(165,220,132,60\).  Formula (1.4)
therefore gives an integral zero-cycle of degree one on every twist.  This
proves index one, not a rational point and not universal
\(CH_0\)-triviality.

The remaining standard tests likewise give no obstruction:

1. \(\operatorname {Br}({}^T X)=\operatorname {Br}(K)\): geometrically the
   Brauer group is zero, while the generator of geometric Picard descends;
2. \(\pi_1^{\mathrm{et}}(X_{\bar K})=1\), so finite etale/fppf descent is
   pulled back from the base field;
3. any fixed abelian obstruction class with restriction, corestriction, and
   point-trivialization is killed by the coprime degrees in (1.2);
4. the installed Sylow-detection theorem kills every additive primary
   Mackey-valued point obstruction normalized to vanish in the presence of
   a fixed point.

These statements do not cover a genuinely nonlinear, point-dependent, or
non-transfer obstruction.

## 4. Equivariant Burnside symbols have the wrong variance

The equivariant Burnside class is a \(G\)-birational invariant.  It has no
functorial pullback/splitting theorem for a dominant rational map of relative
dimension one and no theorem saying that a rational retraction makes
\([X]\) a summand of \([\mathbf P(W)]\) in a Burnside group.  Moreover,
Kresch--Tschinkel Definition 4.2 is formulated in Borel equivariant Chow,
not in the equivariant Burnside group.

The exact source computation in
`../../goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/` therefore remains
useful stabilizer data, but its 20-symbol list and non-removable core do not
test (2.1).  A mismatch of Burnside symbols would obstruct equivariant
birationality, not the rational retraction under audit.

## 5. Exact remaining boundary

Kresch--Tschinkel Theorem 4.4 identifies the missing support equality in
(2.1) with ordinary integral decomposition of the diagonal for one versal
twist (equivalently, for all torsor twists).  The direct finite pieces of
that condition have now been exhausted:

| theorem-forced test | result |
|---|---|
| \(\deg_0^G\zeta=1\) | passes by (1.3) |
| all abelian fixed loci | nonempty |
| fixed elliptic component | swallowed by the allowed support; no consequence |
| ordinary split minimal class | algebraic, by the sibling packet |
| universal torsor / all higher Amitsur groups | zero |
| relative Brauer and finite descent | trivial/tautological |
| additive Sylow-detected obstruction | zero |
| Burnside symbol comparison | no retraction variance theorem |

What remains is the non-finite Chow-theoretic problem of proving that a
versal twist of \(X\) fails integral decomposition of the diagonal.  The
sibling packet isolates a possible boundary class in
\(H^1(G,CH_1(J(X))_{\mathrm{hom}})\), but no cited theorem sends the
Kresch--Tschinkel diagonal to that class, and the target is not a finite
lattice computation.

Accordingly no new bounded CAS search is justified.  The exact finite
arithmetic and all referenced fixed-locus assertions are replayed by
`verify.py`.

```text
DELTA1-KT-EQUIVARIANT-DEGREE-ONE-PASSES
DELTA1-KT-FIXED-LOCUS-RESTRICTION-VACUOUS-WITH-ALLOWED-SUPPORT
DELTA1-KT-HIGHER-AMITSUR-PACKAGE-ZERO
DELTA1-KT-STANDARD-TORSOR-TESTS-PASS
DELTA1-KT-BURNSIDE-HAS-NO-RETRACTION-VARIANCE
DELTA1-KT-FINITE-OBSTRUCTION-AUDIT-DOES-NOT-CLOSE-RETRACTION
```
