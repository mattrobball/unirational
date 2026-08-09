# Finite-target audit for the Klein-cubic headline

**Date:** 2026-08-08  
**Objective:** non-`PSL(2,11)`-unirationality of the Klein cubic  
**Verdict:** `OPEN`

## 1. Exact headline gate

For the maximal subgroup `H=C11:C5`, put

\[
 E=\mathbf C(r_0,\ldots,r_4)/(r_0\cdots r_4-1),
 \qquad K=E^{C_5},
\]

with cyclic shift `sigma`.  The installed equivalence is

\[
 X_{\rm Klein}\text{ is }H\text{-unirational}
 \Longleftrightarrow
 \exists,0\ne a\in E:\quad
 \operatorname {Tr}_{E/K}(r_2^{-1}a^2\sigma(a))=0.
\]

Pointlessness of this twist implies the requested `PSL(2,11)` negative
headline.  This is a finite-type cubic threefold over `K`, but the unresolved
predicate is a **K-rational point**, not geometric nonemptiness.

## 2. The named theorem-forced finite targets actually computed

### Full-group restriction and selfmap gate

For the full simple group, a hypothetical dominant map

\[
 \mathbf P(W)\dashrightarrow X
\]

restricts **dominantly** to the source Klein cubic.  Indeed, primitive
coordinates make the restriction generically defined; a proper
positive-dimensional image would be a faithful compression of dimension at
most two, contradicting \(\operatorname {ed}_{\mathbf C}(G)\geq3\).  Thus the
restriction is a generically finite \(G\)-selfmap of degree \(\delta>0\).

This reduces the full-group problem to a sharper all-degree gate, but does
not close it.  Birational superrigidity handles \(\delta=1\), and Beauville's
theorem handles a restriction which is everywhere regular.  No audited
theorem excludes \(\delta>1\) with a nonempty invariant base locus.  The
finite surjective quartic \(G\)-endomorphism of \(\mathbf P(W)\) also shows
that precomposition propagates any hypothetical landing map to unbounded
coordinate degrees.  See `../FULL_G_RESTRICTION_DOMINANCE/`.

There is one unconditional refinement.  Degree two is impossible.  The
quadratic field extension

\[
 \mathbf C(X)/\varphi^*\mathbf C(X)
\]

would have a unique deck involution.  Equivariance makes it commute with
\(G\), hence it lies in \(\operatorname {Bir}^G(X)\).  Full-\(G\)
superrigidity identifies this equivariant birational group with
\(\operatorname {Aut}^G(X)\); because \(\operatorname {Aut}(X)=G\), the
latter is \(Z(G)=1\), a contradiction.  The same
argument excludes every cyclic Galois restriction
extension.  Using the minimal faithful permutation degree (11) of (G), it
also excludes every Galois restriction degree from two through eleven.  It
does not exclude a deckless non-Galois extension of degree at least three.
See `../FULL_G_SUPERRIGID_SELFMAP_AUDIT/`.

### Full-group graph localization and fixed-stratum layers

The theorem-forced `C11` fixed-graph equations were solved exactly for every
residue of \(\delta\).  In particular, \(\delta=2\) has a formal two-channel
solution and a positive log-concave mixed-degree lift.  This formal cycle is
not a genuine graph (and degree two is independently excluded by the deck
argument), but it proves that fixed-point Chow congruences alone do not give
the exclusion.  The complete normalizer-coupled `C3` and `C5` systems are
also soluble for every degree residue, and the `V4` graph equations impose
no parity.  A single positive log-concave mixed-degree vector satisfies the
`C3`, `C5`, and `C11` congruences simultaneously for formal degree two.

The finite exceptional-incidence CSP was then carried two layers further.
The ambient `V4` line is forced into the base.  Exactly one
incidence-preserving type-I state survives the first layer.  At the next
layer the tangent/equalizer system again has the explicit solution

\[
 \lambda=1,\qquad \mu=0,\qquad D_i=I-E_{ii}.
\]

It satisfies the residual `C3`, all involution-edge, `D12` common-scale, and
`A4` intertwiner conditions.  It is first-derivative data, not a landing jet,
but it rules out a finite character/incidence contradiction at those two
layers.  See `../FULL_G_GRAPH_DEGREE_LOCALIZATION/` and
`../FULL_G_C3_C5_GRAPH_LOCALIZATION/` and
`../FULL_G_V4_SECOND_LAYER_CSP/`.

### The degree-one rational-retraction branch

If \(\delta=1\), superrigidity normalizes the restriction to the identity, so
the ambient map would be a rational \(G\)-retraction.  The ordinary finite
minimal-class obstruction was computed exactly and passes: Roulleau's period
lattice identifies \(J(X)\) with \(E^5\) as an unpolarized abelian variety,
and the inverse Hermitian matrix of the actual principal polarization has an
explicit integral rank-one decomposition.  Thus \(\theta^4/4!\) is
algebraic.  By Voisin's criterion the Klein cubic is universally
\(CH_0\)-trivial, so ordinary decomposition of the diagonal does not exclude
the retraction.

An equivariant retraction would force the Kresch--Tschinkel equivariant
integral diagonal.  Its first finite condition also passes for the actual
Klein cubic.  Sylow-fixed points give equivariant zero-cycles of degrees
\(60,132,165,220\), and

\[
 -13\cdot 60+3\cdot132+165+220=1.
\]

These are genuine point orbits on \(X\); the size-twelve `11:5` vertices and
size-fifty-five `A4` configurations in auxiliary packets are not.  Moreover,
the proper support allowed in an equivariant diagonal may be enlarged by the
entire nonfree locus.  Consequently the involution-fixed elliptic curves do
not inherit ordinary decompositions of the diagonal.  All higher Amitsur
groups, relative Brauer classes, and the direct finite descent tests vanish
or pass.

No cited theorem transports the remaining support equality to a primitive
fixed integral cycle on \(J(X)\).  The exact possible boundary lies in

\[
 H^1\!\left(G,CH_1(J(X))_{\rm hom}\right),
\]

not in the finite Hermitian lattice.  Consequently an elliptic-orbit gcd
calculation is not a theorem-forced decision target.  See
`../DELTA1_MINIMAL_CLASS/`,
`../DELTA1_EQUIVARIANT_MINIMAL_CLASS_AUDIT/`, and
`../DELTA1_EQUIVARIANT_DIAGONAL_OBSTRUCTION_AUDIT/`.

The polynomial landing identity also admits a complete all-degree reduction.
After normalizing the restriction to the identity, every primitive tuple has

\[
 T=Hx+FQ,
\]

and exact polarization gives invariants \(R,S\) with

\[
 F(x+tQ)=(Ht-F)(St^2-Rt-1).
\]

If \(R^2+4S\) is a square, the residual quadratic produces two landing
covariants of degree \(d-3\).  A globally degree-minimal landing tuple whose
restriction is the identity must therefore lie on the nonsquare branch.  That
branch cannot be discarded
formally: the packet gives an exact primitive degree-nine retraction onto an
irreducible singular cubic with nonsquare discriminant, while invariant
nonsquares and connected invariant branched double covers occur in unbounded
degrees.  On \(F=H=0\), the exceptional lines split the six-sheeted Fano-line
incidence cover, but such split divisors likewise occur in unbounded classes.
Thus the identities are exact and useful, but the additional smooth-Klein
theorem needed to force a square or control the actual base ideal is missing.
See `../DELTA1_RETRACTION_POLAR_IDENTITY/`.

### Normalized Stein graph

If the normalized Stein source of the restriction were terminal,
Q-factorial, Fano, and of invariant Picard rank one, superrigidity plus
Beauville would force \(\delta=1\).  In the Galois-canonical case the same
conclusion follows from the invariant branch degree and Hurwitz.  These
hypotheses are not automatic: normalized Stein graphs of rational maps from
smooth varieties can be noncanonical.  Thus this is an exact conditional
bridge, not a finite classification of the actual landing base ideal.  See
`../GENERIC_FIBER_STEIN_MORI/`.

### The first deckless branch: degree three

The non-Galois cubic branch was audited through its complete `S3` normal
closure.  The semilinear lift extension is

\[
  S_3\times G,
\]

so the full group is compatible with the cubic monodromy.  The residual and
discriminant involutions live on auxiliary quadratic covers, not in
\(\operatorname {Bir}(X)\), and therefore do not trigger the quadratic-deck
exclusion.  The invariant branch lower bound is sharp: the invariant sextic
gives an actual connected auxiliary double cover.  A clean
intermediate-Jacobian norm screen also passes because, for
\(\nu=(-1+\sqrt{-11})/2\), one has \(\nu\bar\nu=3\).  Finally, all installed
`C3`, `C5`, `C11`, and `V4` graph equations admit a common positive,
log-concave formal bidegree vector

\[
  (3,126,177,9).
\]

These are separate screens; the auxiliary cover, CM endomorphism, and formal
localization vector are not asserted to arise jointly from a cubic selfmap.
Their individual compatibility proves that degree three is the first genuine
deckless boundary above degree one and is not eliminated by another finite
normal-closure calculation.  See
`../DELTA3_S3_RESOLVENT_AUDIT/`.

### Schur quartics

The rank-exactly-20 `25 x 21` companion target and its intrinsic quaternionic
descent were computed exactly.  The good component is equivariantly
isomorphic to the open Klein cubic twist and its compactification is the
Klein twist itself.  This is a complete finite calculation, but it proves
circularity rather than pointlessness.  See
`../SCHUR_QUARTIC_ARITHMETIC/` and `../SCHUR_QUARTIC_QUATERNION/`.

### Degree at most eight `C11`-stable curves

The complete finite classification has five degree-seven and five
degree-eight curves and none below degree seven.  Every degree-eight
all-eleven tangency target has a unit-monomial obstruction; the residual
intersection has multiplicities `5+8`, not degree two.  The five types form
one `C5` orbit and no individual type descends.  This does not classify
non-`C11`-stable curves.  See `../C11_DEGREE8_TANGENT/`.

### Degree-nine osculating contact

After analytic elimination the full contact chart has ten cubics in twenty
variables.  A transverse `F7` point proves a genuine characteristic-zero
geometric component, so a unit-ideal strategy is impossible.  On the
covariant slice the exact Rabinowitsch system has eleven equations in eleven
variables, toric mixed volume `26264`, and affine Bezout bound `354294`.
Its generic degree/factorization is not known.  A degree-one descended branch
would construct a point (the opposite headline); failure of this chosen
slice would not prove pointlessness.  See `../OSCULATING_GENERAL_H/` and
`../OSCULATING_COVARIANT_COVER/`.

### Characteristic-five progression families

The exact two-Frobenius-residue classification leaves sixteen progression
families.  Complete projective coefficient saturation closes root degrees
one through four.  Independent exact support certificates close root
degrees five and six, and a dependency-free static semantic-DPLL certificate
closes root degree seven.  Hence every exact-two-residue landing through
covariant degree forty-five is empty:

```text
F55-CHAR5-TWO-RESIDUE-EMPTY-THROUGH-45
```

Root degree eight (covariant degree fifty) is UNSAT in a solver preflight for
all sixteen families, but has no independent proof certificate and is not a
theorem here.  More importantly, an exact three-residue no-singleton pattern
proves that a minimal landing need not reduce to the two-residue branch.  For
one fixed such three-residue pattern, exact semantic DPLL excludes root
degrees two through seven, and two independent coefficient reconstructions
give the same pinned-solver `UNSAT` replay at root degree eight (ordinary
degree fifty).  The latter has no DRAT/RUP trace and is recorded at trusted
solver rather than proof-certificate grade.  Other three-residue patterns,
four-or-more-residue supports, and root degree at least nine remain open.  See
`../CHAR5_PROGRESSION_LOW_DEGREE/`, `../CHAR5_PROGRESSION_CLOSE/`, and
`../CHAR5_THREE_RESIDUE_BOUNDARY/` and
`../CHAR5_THREE_RESIDUE_LIFTS_N8/`.

## 3. Why ordinary finite CAS does not yet close the headline

The other complete coordinate presentations have the same arithmetic
boundary:

1. the full-group universal object is a projective system over a rational
   function field and is geometrically nonempty;
2. the `F55` decision object is a smooth cubic threefold over `K` and is
   geometrically nonempty;
3. the Schur quartic component is the Klein twist in different coordinates;
4. every fixed Laurent support, covariant degree, curve type, or Hermite slice
   gives a finite ideal, but no theorem bounds the support, degree, or curve
   type of an arbitrary hypothetical map.

The new full-group finite systems do not alter this boundary: their exact
solution sets are nonempty.  The deck argument removes \(\delta=2\), but the
two remaining cases are \(\delta=1\) (a rational retraction) and deckless
non-Galois \(\delta\ge3\), neither of which has a bounded base-ideal model.

Consequently there is currently no noncircular algebraically-closed-field
unit-ideal computation with a proved universal bridge to the headline.
A decisive negative computation first needs one of:

- a support/height cutoff for the trace equation;
- a rigidity theorem forcing every source map into a finite curve or
  base-ideal class;
- an explicit specialized `F55` torsor with a computable arithmetic
  pointlessness obstruction; or
- an all-degree characteristic-five theorem covering arbitrary Frobenius
  residue supports.

None of these bridges is presently proved.  Therefore the objective has not
been established.

```text
KLEIN-PSL2(11)-NONUNIRATIONALITY-NOT-PROVED
F55-TRACE-CUBIC-K-POINT-UNDECIDED
FULL-G-RESTRICTION-DOMINANT-BUT-DEGREE-GREATER-ONE-OPEN
FULL-G-RESTRICTION-DEGREE-TWO-EXCLUDED
FULL-G-GALOIS-DEGREES-TWO-THROUGH-ELEVEN-EXCLUDED
FULL-G-DEGREE-THREE-S3-RESOLVENT-FINITE-TESTS-PASS
FULL-G-V4-FIRST-AND-SECOND-LAYER-CSP-NONEMPTY
DELTA1-ORDINARY-DECOMPOSITION-DIAGONAL-OBSTRUCTION-PASSES
DELTA1-EQUIVARIANT-DIAGONAL-DIRECT-FINITE-TESTS-PASS
DELTA1-RETRACTION-POLAR-IDENTITY-NONSQUARE-BRANCH-OPEN
FINITE-TARGETS-DEPLOYED-NO-COMPLETE-NEGATIVE-BRIDGE
```
