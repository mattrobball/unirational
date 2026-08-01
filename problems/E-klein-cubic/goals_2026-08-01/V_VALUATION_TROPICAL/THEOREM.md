# Theorem and decision narrative

## Theorem A — local index one at every valuation

For every valuation `v` of the genuine generic field `K`,

\[
\operatorname{ind}(X_T\otimes_KK_v)=1.
\]

Proof: the fixed-subgroup orbit cycles of degrees `60,132,165,220` base
change to every `K_v`, and their gcd is one.  This is unconditional and does
not depend on a chosen model.

The theorem refutes the proposed `V-NEW-INDEX3-DIVISOR-STRUCTURAL` direction
for the actual twist.  Any model computation apparently producing local
index divisible by three is necessarily a model/scope error or concerns an
auxiliary subvariety.

## Theorem B — five covariant divisors are locally soluble

For `V` equal to any of `x,C,D,E,K`, every irreducible component of

\[
F(V)=0
\]

gives a divisorial completion over which the genuine twist has a point.

The five coordinate polynomials of each `V` have gcd one, so `V` is defined
and nonzero at the generic point of every component.  The nonfree locus of
`P(W)` has codimension at least two.  Thus the generic quotient cover is an
etale `G`-torsor there, and the equivariant map `[w] -> [V(w)]` gives a point
on the residue twist.  The twisted constant cubic has a smooth proper model,
so the residue point Hensel-lifts.

This retires diagonal coefficient divisors of degrees `3,12,15,18,21`; the
first two are exactly `f3` and `f12`.

## Theorem C — ramified valuations are locally soluble

Let `v` be any Krull valuation of `K` trivial on `C`, pass to its
henselization, choose a prolongation to the generic splitting field, and let
`D` and `I` be the decomposition and inertia groups.  If `I` is nontrivial,
then

\[
X_T(K_v^h)\ne\varnothing.
\]

In residue characteristic zero inertia is tame.  It is abelian, and it is
central in `D` because `C` contains every root of unity.  Hence, for any
nonidentity `g` in `I`,

\[
D\subset C_G(g).
\]

The exact centralizer orders for element orders `2,3,5,6,11` are
`12,6,5,6,11`.  The only nonabelian case is the order-two centralizer
`D12`; it preserves the involution minus-space `E_-`, and
`P(E_-)=P1` is contained in the Klein cubic.  The order-three and order-six
centralizers preserve the same kind of line.  The order-five and order-eleven
centralizers have projective eigenpoints on the cubic.  Twisting the stable
line or fixed point supplies the asserted local point.

## Theorem D — no empty-tropicalization obstruction in any rank

For every valuation of the genuine generic field, of arbitrary rank, the
tropical hypersurface of the exact generic cubic contains a projective point
over the **base** value group.

If inertia is nontrivial, Theorem C gives an actual local point.  If inertia
is trivial, the splitting extension and the base have the same value group.
Over the splitting field the twist is the constant Klein cubic; choose a
split point away from the five frame-coordinate hyperplanes and take the
valuations of its five Hilbert--90 coordinates.  The nonarchimedean
cancellation rule makes this a tropical point, and its coordinates lie in
the base value group.

Thus neither a higher-rank value-group gap nor a rank-one Newton gap can
prove pointlessness.  In the unramified case the unresolved datum is the
point set of the residue twist, not the tropical support.

## Theorem E — exact unramified reduction boundary

If `I=1`, the torsor extends etale over the henselian valuation ring and the
smooth proper twist satisfies

\[
X_T(K_v^h)\ne\varnothing
\quad\Longleftrightarrow\quad
{}^{\bar T}X(\kappa(v))\ne\varnothing.
\]

In particular every valuation with residue field `C` is locally soluble:
either inertia is nontrivial and Theorem C applies, or the unramified residue
torsor over `C` is trivial.  A negative valuation must therefore be
unramified and must leave a genuinely pointless residue twist over a residue
field of positive transcendence degree.

## Rank-one combinatorial refinement

For any discrete rank-one valuation of the coefficients of the exact generic
cubic, its tropical hypersurface contains an integral projective valuation
vector.

All five pure cubes occur.  Two pure-cube coefficient valuations agree
modulo three.  The lower Newton polygon on their binary edge either has a
unit-length edge or is one length-three edge of integral slope.  Extending
the resulting two-coordinate weights by sufficiently large weights on the
other coordinates produces the required integral tropical point.

The all-rank theorem supersedes this lemma as an existence statement.  The
lemma remains a coefficient-only certificate which does not invoke the
splitting torsor.  Neither statement proves a point for an unramified
valuation whose residue twist is pointless.

## Theorem F — standard length-three/four Parshin completions survive

Every Klein twist has an effective zero-cycle of degree `55`, obtained from
the orbit of the `D12`-stable line contained in `X`.  Coray's Theorem 4.7
shows that the prime-to-three point property for cubic forms ascends through
a complete DVR when it holds over the residue field.  Starting from `C` or a
one-variable function field over `C` and iterating gives

\[
X_T(K_w^{\mathrm{iter\,comp}})\ne\varnothing
\]

for every standard successive complete-DVR field of a saturated geometric
Parshin chain of length three or four on `K_proj`.  This exact theorem does
not identify an arbitrary higher-rank completion with the iterated field and
does not cover rank-one or rank-two chains.

## Exact decision

These theorems remove every ramified and every value-group-only negative
mechanism, as well as the standard length-three/four successive Parshin
completions.  They do not settle unramified rank-one/rank-two residue-field
pointlessness with index one.  The correct exit is
`V-UNDECIDED`.  See `VALUATION_CENSUS.md` for every named route and
`MODEL.md` for the bridge and theorem boundaries.
