# Klein cubic / `F55` analytic status after the 2026-08-08 audit

**Date:** 2026-08-08  
**Headline:** `OPEN`  
**Decision object:**

\[
 \Phi(a)=\operatorname {Tr}_{E/K}
 \left(r_2^{-1}a^2\sigma(a)\right)=0,
 \qquad
 E=\mathbf C(r_0,\ldots,r_4)/(\prod r_i-1),
 \quad K=E^{\langle\sigma\rangle}.
\]

The Klein cubic is `F55`-unirational exactly when this equation has a
nonzero solution in `E`.  A proof of `F55-NO` would imply that the Klein
cubic is not `PSL(2,11)`-unirational.  No such proof, and no trace-cubic
point, is currently known.

## 1. New exact characteristic-zero theorems

### 1.1 Laurent supports of size at most four are empty

`TRACE_TRIANGLE` and `TRACE_TETRAHEDRON` prove, with no exponent, degree,
width, or box cutoff, that

```text
0 != a in C[M] and |supp(a)| <= 4  =>  Phi(a) != 0.
```

The four-term proof is analytic.  Fixed torus points reduce the degree
residues; tangent and higher jets exclude two-residue support and affine
rank three; Vandermonde moments reduce the planar branch to an affine
circuit; positivity excludes the `1+3` circuit; and a rational rank-two
quadratic landing theorem excludes the convex `2+2` circuit.  The last step
uses four sparse evaluations plus one Fourier coefficient, not a collision
or exponent enumeration.

Replay:

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/TRACE_TRIANGLE/classify_collision_arrangements.py
/opt/homebrew/bin/python3 \
  goal_runs_20260808/TRACE_TETRAHEDRON/verify_all.py
```

Final markers:

```text
F55-TRACE-THREE-TERM-ALL-EXPONENT-EXCLUSION-OK
F55-TRACE-FOUR-TERM-ALL-EXPONENT-EXCLUSION-REPLAY-OK
```

This is not a support bound for an arbitrary rational point.  Denominator
clearing produces some finite Laurent support, but no theorem bounds its
cardinality.

### 1.2 Exact divisor residues and cyclic rank

For `b=r_2^{-1}a^2 sigma(a)`, the complete multiplicative obstruction at a
free prime orbit is one class in `Z/11`, detected by

\[
 \lambda=(1,9,4,3,5)\pmod {11}.
\]

The same order-eleven residue remains after projectivizing; fixed primes
have no projective residue.  This decides whether a *specified* trace-zero
`b` lifts multiplicatively, but does not bound the additive trace kernel.

`TRACE_COBOUNDARY` proves uniformly that the five conjugates of a nonzero
trace-zero `b` have no proper zero subsum and that their complex cyclic span
has dimension at least three.  Cyclic rank two is excluded by the
order-eleven multiplicities and a three-term power-pencil Mason argument.

At cyclic rank three, every prime divides at most two Fourier forms.  The
pairwise-coprime case is excluded, but pair-common primes with multiplicity
patterns `(1,2)` and `(2,3)` satisfy the full integral lift and pass the
available Wronskian and Cartan bounds.  This is a sharp boundary, not a
rank-three point.

Replay:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/TRACE_COBOUNDARY/verify.py
```

### 1.3 Any point can be replaced by one of full cyclic span four

`TRACE_FULL_CYCLIC_REPLACEMENT` proves

```text
any trace zero  =>  another trace zero of cyclic span four.
```

The proof fills a genuine prescribed-source gap.  A point makes the twisted
smooth cubic unirational.  Spreading a parametrization and specializing its
auxiliary affine parameters along a rational graph with a prescribed first
jet gives a dominant `F55`-map from the original `P4`.  Composing with the
degree-eleven monomial isogeny from the Klein cubic torus to the trace
hyperplane is dominant.  Hence the five trace summands have no constant
linear relation besides their sum.

Thus a negative proof may focus on cyclic rank four; rank three need not be
separately excluded for the headline.

Replay:

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/TRACE_FULL_CYCLIC_REPLACEMENT/verify.py
```

Final marker:

```text
F55-TRACE-FULL-CYCLIC-SPAN-REPLACEMENT-OK
```

### 1.4 The full-rank divisor boundary is exact but feasible

`TRACE_COBOUNDARY/RANK_FOUR_BOUNDARY.md` classifies the unrestricted
four-character Fourier boundary without a degree or support scan.  After
removing the Laurent gcd, every prime divides at most three of the five
Fourier hyperplane forms.  The order-eleven residue gives the complete
singleton, pair, and triple multiplicity table.  In particular, the least
triple patterns are `(3,1,1)` and `(2,1,1)`, and both admit integral lifts
through `2+sigma`.

This does not yield pointlessness.  A cyclic ten-prime divisor
counterconfiguration passes the refined Wronskian and level-three Cartan
bounds, and exact unramified local Fourier nets realize both triple types.
These are formal/local models, not a global solution in `E`; they prove that
incidence, logarithmic-differential, Wronskian, and truncated-Cartan data do
not by themselves close the remaining branch.

Replay:

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/TRACE_COBOUNDARY/verify_rank_four_boundary.py
```

Final marker:

```text
RANK4-FOURIER-BOUNDARY-OK
```

### 1.5 Global Kummer covers force incidence rank three

`RANK4_GLOBAL` couples all Laurent-prime orbits through finite Kummer covers
of the one trace hyperplane.  If `S` is the span over `F_11` of their five
entry incidence vectors and

\[
 \mu=(1,5,3,4,9),
\]

then the multiplicative residue gives `S subset ker(mu)`.  Any extra
annihilator character makes the dominant trace map lift, after the fixed
`[11]` source isogeny, to an intermediate Kummer cover.

Cyclic rotation is semisimple on the four-dimensional character space over
`F_11`.  Thus any larger invariant annihilator contains one of exactly three
two-planes through `<mu>`.  For each plane, the complete normalized residue
box has 500 vectors; their minimum coordinate sums are `6,8,8`.  Hence the
barycenter is strictly inside all three four-dimensional Fine interiors.
Batyrev's toric-hypersurface theorem gives Kodaira dimension three, so a
rational fourfold cannot dominate any of the three covers.  A separate audit
independently checks the two planes that escaped the weaker level-one
interior-lattice-point test.

Consequently every hypothetical dominant full-cyclic-span solution satisfies

```text
S = ker(mu),   dim_F11(S) = 3.
```

This is an all-support, all-degree theorem.  It does not settle the problem:
the remaining one-character cover for `<mu>` is precisely the degree-eleven
monomial cover whose dense hypersurface is the Klein cubic.  The coefficient
`r_2^-1` records its nontrivial semilinear descent, so excluding a lift to
this final cover is the original `F55` trace problem rather than a new
intermediate obstruction.

Replay:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/RANK4_GLOBAL/verify.py
/opt/homebrew/bin/python3 goal_runs_20260808/RANK4_GLOBAL/verify_kummer_newton.py
/opt/homebrew/bin/python3 goal_runs_20260808/RANK4_GLOBAL/verify_fine_interior_audit.py
/opt/homebrew/bin/python3 goal_runs_20260808/RANK4_GLOBAL/verify_rank3_klein_cover.py
```

Final audited marker:

```text
RANK4-FINE-INTERIOR-UPGRADE-AUDIT-OK
```

### 1.6 Fixed-vertex localization forces deeper base points, but not a contradiction

`EQUIVARIANT_LOCALIZATION` applies `C11`-localization to an arbitrary finite
equivariant resolution of a hypothetical `F55`-map.  Every such map is
undefined at all five `C11`-fixed coordinate vertices.  After blowing up
that orbit, at least one orbit of infinitely-near fixed directions is still
in the base locus.  Both statements are independent of the degree.

On a complete resolution, however, the exceptional fixed strata contribute
five normalized masses `n_s` satisfying the exact Fourier moment law

```text
g_b = sum_s n_s*(-2)^(s*b) mod 11,   0 <= b <= 4.
```

The Fourier matrix is invertible.  Consequently later exceptional strata can
absorb arbitrary values of the three undetermined mixed projective degrees.
An exact two-channel counterconfiguration has a positive, log-concave lift
compatible with cubic divisibility.  It is not a genuine graph, but it proves
that localization, positivity, and projective-degree inequalities alone do
not close the problem; one would have to control the actual base ideal and
its normal cones.

`INVARIANT_RESTRICTION` also audits the proposed ambient-selfmap repair.  A
general invariant hypersurface of degree 55 necessarily meets the generic
fibre and restricts dominantly, but it is of general type.  The five stable
cubics have the coordinate pentagon as their common base.  Horizontal
exceptional multisections over that pentagon can absorb the entire
intersection with the generic fibre, so dominance on the source Klein cubic
is not forced.  The subgroup is genuinely non-rigid: its explicit Sarkisov
link to the degree-14 Fano has exactly this pentagon as base.  Beauville's
endomorphism theorem only excludes the basepoint-free selfmap branch.

Replay:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/EQUIVARIANT_LOCALIZATION/verify.py
/opt/homebrew/bin/python3 goal_runs_20260808/INVARIANT_RESTRICTION/verify.py
```

Final markers:

```text
F55-C11-EQUIVARIANT-LOCALIZATION-OK
F55-INVARIANT-RESTRICTION-AUDIT-OK
```

### 1.7 The final semilinear coefficient is a torsor translate

`SEMILINEAR_RANK3_DESCENT` identifies the surviving cover over the trace
hyperplane complement `U` as one universal order-eleven torsor translated by
the constant class of `c`.  Over the splitting field,

```text
Pic(U_E)=0,
O(U_E)^*/E^* = augmentation lattice,
H^1(U,A)/H^1(K,A) = <mu>.
```

Thus every coefficient has the same nonzero geometric cover; changing `c`
only changes the constant torsor translate.  Norm, order, and the abstract
one-dimensional `C5` module do not decide whether that translate meets the
trace hyperplane.  Indeed, with `d_i=r_i-r_(i+1)`, `n=prod d_i`,

```text
a=d_0^2,
c_b=n/(d_0^3*d_1^2)
```

give a literal trace zero, while `c_b` has norm one and exact order eleven in
the projective isogeny cokernel.  Its nonzero residue lies on a free prime
orbit, whereas the authoritative `r_2^-1` class lies in the Laurent-unit
residue.  Regular equivariant automorphisms preserve that distinction;
birational transfer after multiplication by an isogeny image is precisely
the unresolved three-dimensional compression problem.

Replay:

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/SEMILINEAR_RANK3_DESCENT/verify.py
```

Final marker:

```text
RANK3-SEMILINEAR-DESCENT-COUNTERMODEL-OK
```

### 1.8 Every fixed finite split-local ledger has a soluble global match

`UNIT_RESIDUE_TOROIDAL` identifies the complete projective coefficient
quotient at a free divisor orbit with

\[
 L^*/L^{*11},
 \qquad
 \rho(x)=\prod_{i=0}^4\sigma^{-i}(x)^{(1,9,4,3,5)_i}.
\]

The apparent distinction between the Laurent-unit class `r_2^-1` and an
interior free-prime class is not birationally local.  At the toric ray

```text
(-1,1,2,-1,-1)
```

the actual coefficient has valuation vector `(-2,-1,1,1,1)`, exactly the
vector of the explicit soluble coefficient from
`SEMILINEAR_RANK3_DESCENT`.  Their completed semilocal projective classes,
including every flag and higher tame-symbol datum below that divisor, are
isomorphic.  The actual cubic is locally soluble at the corresponding
quotient place.

The stronger theorem is simultaneous and contains no search.  For every
field `L` containing `C` and every `z in L*`, the split trace-zero tuple

```text
(z^10,-z^10,1,omega,omega^2),    omega^3=1,
```

has resolvent class `z` modulo eleventh powers.  Weak approximation in the
four-dimensional vector space `ker(Tr)` therefore produces one globally
soluble coefficient matching arbitrary prescribed projective classes at
any fixed finite collection of split places.  The same conclusion holds at
finitely many dense-torus locally soluble Henselian places of residue
characteristic prime to `33`.

Consequently no finite list of separate local tests, no pair of intersecting
toric ray orbits, and no full Gersten ledger on one fixed finite fan can
prove pointlessness.  A successful divisor argument must constrain the
unbounded, solution-dependent global prime support, find a genuinely bad
completion, or use a global invariant not determined by finitely many
completions.

Replay:

```sh
/opt/homebrew/bin/python3 \
  goal_runs_20260808/UNIT_RESIDUE_TOROIDAL/verify.py
```

Final marker:

```text
F55-UNIT-FREE-PRIME-TOROIDAL-LOCAL-EQUIVALENCE-OK
```

### 1.9 All divisorial completions reduce to one interior residue type

`TRACE_LOCAL_PLACE_CLASSIFICATION` classifies divisorial completions of the
exact generic trace cubic.  For the full splitting torsor with group
`F55`, every proper decomposition group is `1`, `C11`, or `C5`; each fixes
a projective point on the Klein cubic.  Nontrivial tame inertia is central
in its decomposition group, while the centralizer of a nontrivial element
of either Sylow subgroup is proper.  Hence every ramified place and every
unramified place with proper decomposition group is soluble.

Every toric-boundary place is split.  Indeed, a stabilized valuation would
define a fixed cocharacter in the augmentation lattice, but that lattice
has no nonzero `C5`-fixed vector.  The dense split-local surjectivity from
Section 1.8 therefore supplies a torus point at every such completion.

The sole unresolved type is an interior, unramified place with full `F55`
decomposition.  There all Laurent characters and the Kummer radicand are
units.  The torsor extends etale over the henselian DVR, and smooth proper
descent gives the exact equivalence

\[
 X_T(K_v^h)\ne\varnothing
 \quad\Longleftrightarrow\quad
 \overline X_\Delta(\kappa(v))\ne\varnothing,
\]

where the right side is the complete smooth residue `F55` trace cubic over
a field of transcendence degree three over `C`.  No pointless residue cubic
of this type is known.  Thus the local route has not found a bad completion;
it reduces any possible bad completion to a lower-transcendence-degree copy
of the same mixed-prime point problem.

Replay marker:

```text
F55-TRACE-LOCAL-PLACE-CLASSIFICATION-OK
```

## 2. Characteristic-five route

Over an algebraically closed field of characteristic five, the exact known
range remains

\[
 2\le \operatorname {ed}(F_{55})\le4.
\]

The desired value four is equivalent to dominance of every nonzero
homogeneous self-covariant.  All monomial and additive covariants are
dominant in every degree; all covariants below degree five are dominant; and
the complete degree-five Klein landing scheme is empty.

Minimal landing coordinates are Frobenius-primitive, have no common cyclic
factor, and use at least two Frobenius residue classes.  The complete
two-residue no-singleton classification leaves sixteen arithmetic-progression
families.  Their five six-term bucket equations are exact.  Treating the ten
cyclic values independently gives smooth universal components on which
neither pure component lands, so universal polarization forcing is false.
The remaining global compatibility `h_i=rho^i h`, `k_i=rho^i k` is open.

No characteristic-five all-degree dominance theorem has been proved.

The later modular-invariant audit identifies the exact surviving
all-degree object.  For the generic Artin--Schreier `C5`-torsor, the twisted
kernel `A` has character module `Z/11` with multiplier 9.  Its minimal
permutation-lattice presentation has rank four, realized by the augmentation
ideal of `Z[C5]`; nevertheless `ed(A;11)=1`.  Ruozzi's conjecture predicts
absolute essential dimension four, but no theorem through 2026-08-08 proves
this mixed `5/11` case.  The concrete missing statement is incompressibility
of the generic fibre of the degree-eleven isogeny

```text
(Res_(L/K) G_m)/G_m  -->  S.
```

Proving it would be stronger than excluding a landing on this one Klein
cubic.  Finite generation of modular covariants gives no degree cutoff, and
the available Cohen--Macaulay/generator theorem requires fixed-space
codimension at most two, while the present regular `C5` module has
codimension four.

Replay marker:

```text
F55-CHAR5-MIXED-PRIME-LATTICE-BOUNDARY-OK
```

The remaining two-residue progression families now also satisfy exact
ordinary grading and `C11`-weight constraints.  Each has the form

\[
 f=x^{a_d}H^5+x^{b_{d,r}}K^5,
 \qquad \deg f=10+5\deg H,
 \qquad \deg H=\deg K.
\]

There is no progression landing below degree 20, and the three families
`(2,2)`, `(3,3)`, `(4,3)` start in degree at least 25.  These are lower
floors, not a cutoff: from root degree three onward every required weight
occurs, and sixteen exact coordinate-valuation counterprofiles show that
homogeneity, Kummer congruences, and coordinate ramification alone do not
force a contradiction.

The fixed-line Hasse audit adds one exact all-degree lemma.  If a landing
covariant vanishes on a Sylow-`C5` fixed line, its circulant first derivative
lies in `(rho-1)^3` and has rank at most two.  However the explicit family

```text
f_M=(x0^11-x1^11)^M*x1^5,  M = 1 mod 5,
```

is Frobenius-primitive and cyclic-gcd-one, evades every prescribed finite
fixed-line jet order, and nevertheless has dominant covariant by the segment
theorem.  Hence no degree-independent finite fixed-line Hasse test can decide
the all-degree problem.

Replay marker:

```text
F55-CHAR5-FIXED-LINE-HASSE-BOUNDARY-EXACT
```

## 3. Twisted-kernel and threefold boundaries

For the generic twisted `C11` kernel `A`, the exact range presently proved is

\[
 3\le \operatorname {ed}_K(A)\le4.
\]

The lower bound uses arithmetic equivariant surface MMP; the upper bound is
the faithful five-character projective representation.  Bayarmagnai's
expected value four remains conjectural in this case.  The `11`-essential
dimension is only one, so prime-local and canonical-dimension methods cannot
give the missing lower bound.

Under geometric rank-one hypotheses, terminal threefold reductions leave
the smooth Klein cubic, its genus-eight Pfaffian twin, and an explicit short
basket list in the non-Gorenstein case.  A later audited addendum eliminates
the formerly surviving geometric Gorenstein rank-greater-than-one branch,
factorial terminal genera six and seven, singular factorial genus eight, and
all baskets containing an index-eleven or index-twenty-two point.  The seven
remaining geometric baskets are

```text
{2^5}, {2^10}, {2^15}, {3^5}, {2^5,3^5}, {4^5}, {2^11}.
```

The weaker arithmetic rank-one boundary is not covered by the geometric
classification.  More importantly, the smooth Klein/Pfaffian survivor is
the original problem, so the strengthened MMP sieve still does not decide
it.  `KERNEL_BIRATIONAL/AUDIT.md` independently checks the classification,
index-one-cover, character-module, and Pfaffian-duality bridges.

`TWISTED_KERNEL_CYCLOTOMIC` makes the remaining mixed-prime kernel problem
fully explicit.  If `I` is the augmentation lattice, then

\[
 I\simeq\mathbf Z[\zeta_5],\qquad
 \ker(I\to\mathbf F_{11}(9))=\alpha I,
 \qquad
 \alpha=\zeta_5^3-\zeta_5^2-\zeta_5-1,
\]

and `Norm(alpha)=11`.  Thus the generic versal `A`-torsor is the single
degree-eleven self-isogeny

\[
 \phi_\alpha:H\longrightarrow H,
 \qquad H=(R_{L/K}\mathbf G_m)/\mathbf G_m,
\]

of one `K`-rational four-torus.  After splitting, Smith reduction makes it
the pullback of `x -> x^11` on `G_m`, whose essential dimension is one.
The desired lower bound must therefore retain the order-five semilinear
descent.

The standard characteristic-class routes are exactly empty:

\[
 CH^*(BA)=\mathbf Z[u]/(11u),\qquad \deg u=5,
\]

so codimensions one through four vanish and every positive Chow class pulls
back to zero on the fourfold `H`.  Moreover `R_K(H) -> R_K(A)` is
surjective.  All associated representation, Chern, lambda, gamma, and
ordinary equivariant `K_0` classes on the versal cover reduce to rank, and
`(phi_alpha)_*O_H` is the trivial rank-eleven vector bundle.  These facts do
not trivialize its finite-algebra structure.

The exact surviving formulation is a faithful, effective-descent subfield

```text
E_L subset L(H),  trdeg_L(E_L)=3,
stable under a and delta,  delta*a*delta^-1=a^9.
```

Character-generated subfields and projective-space/P3 models are excluded
by the irreducible cyclotomic lattice and the five-element affine weight
orbits.  A nonlinear threefold invariant in the five-weight `P4` is not
excluded; the Klein cubic is precisely the smooth Fano survivor.  Thus
`ed_K(A)=4` remains open.

Replay marker:

```text
TWISTED-C11-CYCLOTOMIC-SELF-ISOGENY-OK
```

## 4. The Schur function-field point is an even rational-curve problem

Let `beta` be the generic spin Brauer class, let

```text
A_beta=M_3(D),  S=SB(A_beta),  C=SB(D),
```

where `D` is quaternion division.  `SCHUR_CONIC_CURVES` proves for every
proper `K`-variety `Z` that

\[
 Z(K(S))\ne\varnothing
 \quad\Longleftrightarrow\quad
 \operatorname{Mor}_K(C,Z)\ne\varnothing.
\]

Indeed, `S` has a dense rank-four vector-bundle open over `C`, so
`K(S)=K(C)(t_1,\ldots,t_4)`; specialization and properness give the
equivalence.  For the twisted `V14`/Klein pair this sharpens to

\[
 V_T(K(S))\ne\varnothing
 \Longleftrightarrow \operatorname{Mor}_K(C,V_T)\ne\varnothing
 \Longleftrightarrow Y_T(K)\ne\varnothing.
\]

If `V_T(K)` is empty, multiple covers can be removed.  For the normalization
`Q` of the image of a map of degree `e`, naturality of the Picard--Brauer
boundary gives

\[
 \alpha(Q)=e\beta.
\]

Hence `e` is odd, `Q` is the original nonsplit conic, and every image has
even anticanonical degree.  Degree two is excluded by the canonical
conic-on-`V14`/line-on-the-orthogonal-cubic correspondence and the generic
no-line theorem.  Degree four is the first survivor, with tautological
splitting types `(1,3)` and `(2,2)`.

`SCHUR_QUARTIC_MODULI` proves that every surviving degree can in fact be
replaced by one canonical quartic of type `(1,3)`.  If `y in Y_T(K)`, choose
it in the dense open where its projective kernel conic misses the exceptional
locus of the Pfaffian--Grassmannian flop.  On

\[
 L_y=\mathbf P(\ker f(y))\simeq C
\]

the contraction matrix is `4 x 6`, has entries linear in the conic
coordinates, and has rank four everywhere.  Its kernel bundle fits into

\[
0\longrightarrow F\longrightarrow
 U\otimes\mathcal O_{\mathbf P^1}
 \longrightarrow (A/\langle y\rangle)^*\otimes
 \mathcal O_{\mathbf P^1}(1)
 \longrightarrow0.
\]

The tautological vector gives `O(-1) subset F`; the quotient is `O(-3)` and
the extension splits.  Hence

\[
 F\simeq\mathcal O(-1)\oplus\mathcal O(-3),\qquad
 \deg_H(C\to V_T)=4.
\]

Equivalently, the Pluecker coordinates are the complementary `4 x 4`
minors of the contraction matrix.  Conversely any Schur-conic curve gives a
Klein point by the preceding criterion.  Therefore

\[
 Y_T(K)\ne\varnothing
 \quad\Longleftrightarrow\quad
 \operatorname{Mor}_K(C,V_T)_{\deg_H=4}\ne\varnothing.
\]

Known bend-and-break theorems apply to general members of the Fano moduli
and supply geometric boundary divisors, not `K`-rational boundary points on
this special twist.  Abel--Jacobi identifies degree four as the same
circular Pfaffian boundary but gives no emptiness theorem for the selected
arithmetic fibre.  Thus all degrees are reduced to one explicit quartic
case, but that quartic remains equivalent to the original headline.

Replay marker:

```text
SCHUR-CONIC-CRITERION-AND-DEGREE2-EXCLUSION-OK
SCHUR-CONIC-ALL-DEGREES-REDUCED-TO-DEGREE4
```

## 5. Methods now ruled out as complete proofs

The following cannot be promoted to a headline:

```text
the withdrawn conserved-eleven / PL boundary contradiction;
index one or the simultaneous degree-5 and degree-11 zero-cycles;
prime-local essential dimension, p-incompressibility, or standard
cohomological invariants;
bounded degree or bounded support emptiness;
universal polar-circuit coverage without a proved support bound;
the characteristic-five universal bucket ideal without cyclic compatibility;
rank-three Wronskian or Cartan inequalities that ignore pair-common divisors;
fixed-point localization without control of the full equivariant base ideal;
regular automorphisms, Picard/Brauer classes, or relative logarithmic forms
on the final semilinear cover;
ambient selfmap arguments that assume the source Klein cubic restricts
dominantly or that `F55` is birationally rigid;
ordinary Chow, representation K-theory, or split-cover canonical dimension
for the cyclotomic self-isogeny;
any fixed finite split-local or finite-fan toroidal/Gersten ledger;
Schur bend-and-break without a K-rational boundary point.
```

The old tropical boundary is not merely incomplete: an explicit convex
integral support function satisfies it.  It therefore cannot be repaired by
reasserting the same valuation shadow.

## 6. Exact remaining `F55` target

The negative project is now reduced to the following quantified statement:

```text
there is no nonzero a in E with Phi(a)=0 whose five trace summands
have cyclic span four.
```

This remains an unrestricted rational-function problem.  A successful proof
must couple additive coefficients across prime orbits, or produce a genuinely
new global invariant.  Conversely, one explicit trace zero decides the
`F55` question positively and retires this subgroup as a route to
`PSL(2,11)-NO`.

## 7. Full-group selfmap addendum

A separate full-group reduction is now exact.  Every hypothetical dominant
map \(\mathbf P(W)\dashrightarrow X\) restricts to a dominant generically
finite \(G\)-selfmap of \(X\), of degree \(\delta>0\).

The named theorem-forced finite consequences isolated in this audit behave as
follows; this is not a theorem that no other finite invariant can exist.

* Degree two is impossible: its unique deck involution centralizes \(G\),
  while full-\(G\) superrigidity and \(\operatorname {Aut}(X)=G\) force it
  into \(Z(G)=1\).  The same argument excludes every cyclic Galois
  restriction, and the minimal faithful permutation degree of \(G\) excludes
  every Galois degree from two through eleven.
* Normalizer-coupled `C3`, `C5`, `C11`, and `V4` fixed-graph localization
  eliminates no degree residue.  The first two exceptional `V4` layers have
  exact compatible formal states, so fixed-character CAS does not close the
  base ideal.
* In degree one, the ordinary minimal-class obstruction and every direct
  finite test of the equivariant diagonal pass.  The exact retraction normal
  form

  \[
    T=Hx+FQ,
    \qquad
    F(x+tQ)=(Ht-F)(St^2-Rt-1)
  \]

  lowers degree if \(R^2+4S\) is square, but the nonsquare branch is genuine
  and unbounded.  The resulting split Fano-line incidence divisors also occur
  in unbounded classes.
* The first deckless branch, \(\delta=3\), survives its complete `S3`
  resolvent, auxiliary double-cover, intermediate-Jacobian, and fixed-graph
  screens separately.  The auxiliary objects are not claimed to form one
  realized cubic selfmap.  The common positive witness for the fixed-graph
  equations alone is
  \((3,126,177,9)\).

Thus the full-group route now stops exactly at an equivariant rational
retraction in degree one or a deckless non-Galois selfmap of degree at least
three.  Closing either branch requires control of the actual all-degree
ambient landing base ideal; no theorem currently bounds it.

The durable synthesis and replays are in
`FINITE_TARGETS_HEADLINE_AUDIT/`.

```text
F55-QUESTION-OPEN
PSL2(11)-KLEIN-UNIRATIONALITY-OPEN
```
