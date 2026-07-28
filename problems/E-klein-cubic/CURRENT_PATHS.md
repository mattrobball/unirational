# Current paths for Problem E

Date: 2026-07-28.

## Verdict

The headline remains **OPEN**:

\[
C\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3,
\]

but the current work does not choose between essential dimensions three and
four.  The calculations below are exact at their stated finite degree or
specialization; none is an all-degree negative solution.

## 2026-07-28 execution update

The completed follow-ups changed the tactical boundary without deciding the
headline.

1. **Landing self-covariants are now excluded through degree 15.**  At the
   split good prime 67, the exact quotient
   \(M_{15}/fM_{12}\) has dimension 16.  Its complete landing-coefficient
   image has rank 75 inside the independently certified
   76-dimensional space \(R_{45}/fR_{42}\).  The scalar classes form a
   four-plane; all twelve homogeneous normal charts have literal `msolve`
   output `[-1]:`, so the quotient landing locus is exactly that scalar
   four-plane set-theoretically.  The two possible lifts reduce to
   16-variable systems with respectively 3,528 and 2,346 leading monomials;
   both leading ideals are Artinian and their Hilbert functions vanish in
   degree five.  Proper specialization proves the characteristic-zero
   degree-15 exclusion.  See `tmp/degree15_structural/REPORT.md`.

2. **The degree-12 mixed Jacobian problem is generically empty over its
   primitive parameter space.**  On `p0=1`, the exact fiber
   `[p0:p1:p2:p3]=[1:1:1:1]` has unit ideal over `F_67`.  Because the pure
   decomposable center was already proved empty, projection of the
   projective Jacobian-zero incidence to the primitive `P^3` is proper.
   Hence its image is a proper closed subset, in characteristic 67 and in
   characteristic zero.  Degree 12 is still open on that exceptional closed
   subset.  The retained degree-seven border map
   \[
   \mu_7:A^{65,611}\longrightarrow A^{50,388},\qquad
   A=\mathbf F_{67}[p_1,p_2,p_3].
   \]
   is an exact truncated diagnostic, but it is **not** yet a presentation of
   the exceptional image or of the full quotient.  In particular, unit
   membership after specializing at `[1:1:1]` does not by itself lift to a
   relative annihilator.  The parameter-free top ideal is now completely
   certified: its Hilbert function is
   `[1,12,78,364,1365,3647,3726,0,0]`, its colength is `9,193`, and all
   degree-at-least-seven monomials lie in its leading ideal.  The full
   15,283,769-term reduced Groebner basis is serialized and audited.  This
   proves finite top control and identifies a possible `9,193 x 24,416`
   Schur target, but no relative Fitting determinant has yet been produced.
   A separate audited determinant lemma avoids needing a full presentation:
   a right inverse for the `31,824 x 56,238` degree-seven top map and one
   degree-at-most-two multiplier vector whose reduced multiplication operator
   has full rank at the sample point would define a degree-lowering
   endomorphism of a free module of rank `18,564`; its determinant is nonzero
   there and kills the full quotient after localization.  A specialized unit
   vector guarantees such a choice, but a sparse choice may suffice.  The
   lemma is sound; the right inverse and full-rank operator are not yet
   certified.  The survivor-only, ancestor-pruned F4 replay has now completed
   under the `768 MiB` trace-allocation gate.  Its corrected graph has `55,966`
   roots, `45,751,159` committed operations, and `479,691,384` discarded
   zero-row operations; it used `372,506,624` bytes and serialized to
   `367,937,576` bytes.  All 721 sorted/normalized input leaves are explicitly
   mapped back to the original generators.  Structural replay passes.  A new
   exact semantic evaluator checks all 721 degree-five final rows
   coefficientwise in the 4,368-monomial ambient space: all 2,882 selected
   roots and 474,949 trace operations replay with zero mismatches, using only
   19,111,096 planned live bytes.  Independently, one complete cross-round
   degree-seven source row (48,255 nonzero transform entries) multiplies the
   original forms to exactly `d11^7`.  A compact
   division plan covers all 31,824 target monomials using 8,181 retained basis
   rows and 72,484,088 lower-tail edges.  This makes the `M7` solve circuit
   constructible, but not yet certified: the selected degree-six and remaining
   degree-seven roots still need coefficientwise comparison with the retained
   basis, and no full right inverse or `M7 R = I` check has been emitted.
   Dense source expansion is
   rejected (`782,526,535` live bytes before overhead and about
   `1.59e12` scalar updates).  The exact next gate is to extend the ambient-
   polynomial semantic verifier from the completed 721 degree-five rows to
   the remaining 7,846 degree-six/seven rows.  The audited all-row plan has
   peak `478,080,096` bytes and about `1.05e12` scalar updates.  Circuit-level
   right-inverse and multiplication-rank checks follow.  Everything here
   remains over `F_67`; a
   characteristic-zero determinant would require a separate lift.
   The parameter-independent degree-five block has an explicit
   \(721\times721\) minor of determinant \(18\bmod67\), so no parameter
   localization enters at the initial equation stage.  Primitive-only
   permutations and sign changes do not reduce the system.  See
   `tmp/relative_kls_chart/REPORT.md`,
   `tmp/relative_kls_chart/TOP_IDEAL_REPORT.md`, and
   `tmp/relative_kls_chart/DEGREE_LOWERING_DETERMINANT.md`.  The measured
   extraction gate is in
   `tmp/relative_kls_chart/TRANSFORM_EXTRACTION_GATE.md`; the completed trace
   and exact evaluator boundary are in
   `tmp/relative_kls_chart/survivor_trace/REPORT.md`,
   `tmp/relative_kls_chart/survivor_trace/evaluator/REPORT.md`, and
   `tmp/relative_kls_chart/survivor_trace/semantic_check/REPORT.md`.
   A separate exact cover of the base hyperplane `p3=0` did not establish
   finite projection: its 14-, 13-, and 12-variable charts all timed out in
   degree seven at gates of 900, 600, and 600 seconds.  A deterministic
   coordinate-nondegenerate projective-line audit then reproduced the same
   first-matrix sizes and densities, so its solver was stopped before an
   unchanged retry.  The line was not proved generic relative to the unknown
   exceptional image.  No hyperplane emptiness
   or exceptional-image dimension bound follows.  See
   `tmp/relative_kls_hyperplane/REPORT.md` and `LINE_PILOT.md` there.

3. **The polar support of the degree-free KLS connection is now exact.**  If
   \(\delta\) is the normalized frame determinant, \(D=N(\delta)\),
   \(\Delta\) is the trace discriminant, and \(A\) is the horizontal
   four-by-four matrix, then
   \[
   N(\det A)=
   \frac{2^{10}3^8 11^{12}}{5^4t_3^{24}}D\Delta.
   \]
   Thus, away from `t3=0`, there is no hidden third polar divisor.  The
   residue spectra are `1,0^4` at a simple frame zero and
   `0^55,(1/2)^5` on the pushed-forward simple branch.  Their unrestricted
   leading systems are now solved: they are rational determinant
   hypersurfaces of dimensions 19 and 24 in the corresponding first-jet
   spaces, so neither residue is a pointwise obstruction.  A complete
   projective cover at two regular fibres excludes the entire
   constant-coefficient `P4`, upgrading the former 121 sampled directions;
   the simultaneous constant centralizer of the four labelled connection
   matrices consists only of scalars.  Beyond the prior
   140 one-parameter families, all 60 constant-coefficient simultaneous
   three-coordinate planes
   `c0*e_i + c1*delta*e_j + c2*eta_Delta*e_k` are excluded exactly.  The first
   nonconstant enlargement is now complete too.  For every ordered distinct
   triple `(i,j,k)`, every base coordinate `u`, and every coefficient role,
   the projective family
   `sum_(m!=r) c_m*s_m + (c_r+d*u)*s_r` is empty.  Two regular fibres remove
   the artificial one-fibre base point, and exact projective covers exclude
   all `60*4*3=720` families over `F_65537`, hence in characteristic zero.
   A stronger complete projective screen lets all three coefficients acquire
   independent slopes in one common base-coordinate direction:
   `sum_r (c_r+d_r*u)*s_r`.  All `60*4=240` resulting `P5` families are empty
   over `F_65537`, hence in characteristic zero.  The full replay rebuilt
   `240*2*12*252` coefficients and reran 1,200 affine Gröbner charts plus 240
   terminal points.  The canonical two-direction family
   `sum_(r=0)^2(c_r+d_r*t3+e_r*t6)*s_r` for the ordered triple `(0,1,2)` is
   now completely projectively empty too: seven charts are Macaulay2 unit
   ideals, the hard eighth chart is an exact `msolve [-1]:`, and the last
   point is nonzero.  This is the stopping point for three-support sweeps.
   At a regular base point the complete projective first-jet space has
   dimension 20 and the determinant locus dimension 19, while even arbitrary
   four-direction jets constrained to a fixed coordinate `P2` have dimension
   at most 10.  Thus no finite union of the `P3/P5/P8` families can be
   exhaustive.  The first chart of the structurally preferable full-support
   one-direction `P9` reached the 700 MiB watchdog without algebraic output.
   A negative proof now requires a global line-subsheaf/foliation theorem or
   a genuine bounded-pole normal form, not a larger finite jet box.  See
   `tmp/kls_divisor_ansatz/REPORT.md`,
   `tmp/kls_residue_next/REPORT.md`, and
   `tmp/kls_first_jet_two_fiber/REPORT.md` and `REPORT_P5.md`,
   `tmp/kls_first_jet_three_fiber/REPORT.md`, and
   `tmp/kls_structural_audit/REPORT.md`.

4. **The nonzero-Kummer control and the generic Cech difference are
   explicit.**  On the soluble
   characteristic-23 control, the tangent residual gives an exact
   \(Q=[H-3O]=[R-O]\) on the saved Jacobian.  The irreducible degree-eight
   nonzero \(E[3]\) field and the genuine nonzero representative
   \(G_T(Q)\) are serialized and replayed.  The independent translation
   interpolation still times out before a matrix or determinant.  On the
   generic characteristic-zero side, however, a replay-locked expression DAG
   now contains the monic degree-nine flex eliminant `Q`, first
   subresultants `r1,r0`, `r1^-1 mod Q`, and the universal flex point over
   the rank-nine algebra.  A second segmented DAG contains `Q'^-1` and all
   81 coordinates of the divided-difference diagonal idempotent.  A typed
   nested-etale-algebra circuit now executes the formerly missing inverse
   `lambdaSharp=(lambda+eDelta)^-1*(1-eDelta)` with nine outer Euclidean
   steps and constructs the actual short-Weierstrass Cech coordinates
   `(X,Y)=P2-P1`.  Full rank-81 replay checks the curve equation, the
   3-division polynomial, diagonal vanishing, and the correct factor-swap
   signs.  No dense `81 x 81` inverse or splitting field is used.  The typed
   outputs are exact operation nodes but have not been distributed into
   length-twelve Hironaka coordinates.  The naïve determinant ratio is now
   exactly refuted as an `E[3]`-algebra element (rank `108`, augmented rank
   `109`).  Dividing the projective translation lift by the unit scalar
   cochain `c=ell(M0)` fixes it: the geometric descent lemma and a selected
   exact `9 x 9` solve give a generic-open rational first-Kummer
   representative `alpha_R=det(M0)/c^3` modulo cubes.  The descent lemma is
   the generic proof; the retained `GF(101)` full-81 test is a modular replay,
   not a substitute for it.  It corroborates cubic scaling and the `P2-P1`
   orientation.  The saved representative retains
   `alpha_R(O)=71^-3` and fixes `z_O=71`.  Equivalently, cube-normalizing
   `alpha_R(O)` to one would fix `z_O=1`; these are alternative gauges.  The
   affine first-descent unit chart is now assembled exactly.  It has ten
   variables and nine cubics.  Its `3^8`-sheet unit-open covering scheme has
   `3^6=729` geometric components, each a degree-nine 3-covering; it is not
   one geometrically integral curve.  CFOSS III, Section 2.5 guarantees a
   distinguished component defined over the base field, and in this case it
   is \(K_{\mathrm{proj},\mathbf C}\)-isomorphic as a covering to the original explicit
   projective `xCD` plane cubic.  It need not be literally the same embedded
   component in `E x P(R)`.  Thus extracting or closing all 729 components is
   unnecessary for the rational-point attack: work directly on that plane
   cubic.  The exact formulas are over the `QQ`-model `K_proj,QQ`, whereas the
   headline field is
   \(K_{\mathrm{proj},\mathbf C}=K_{\mathrm{proj},\mathbf Q}
   \otimes_{\mathbf Q}\mathbf C\).  A `K_proj,QQ` point is
   a sufficient positive certificate, but nonexistence, arithmetic-prime
   local tests, or a Selmer result only over that smaller field are not
   negative results for the complex problem.  An exact geometric pilot with
   the integral gauge `q=f6/f5` proves that every prime component of the
   pure-coefficient divisors `A=0`, `B=0`, and `C=0` has a smooth coordinate
   residue point, hence none can be a local obstruction.  The degree-120
   discriminant audit is now complete as well.  A full-degree squarefree
   `F_23` line restriction proves geometric squarefreeness in characteristic
   zero and coprimality with `f5*f6`.  For `q=f6/f5`, every discriminant
   valuation of `D/q^120` on the normal quotient is exactly one.  The
   2026-06-30 Poonen--Stoll valuation theorem then gives one residue-rational
   nondegenerate node; projection and Hensel lifting give a local point at
   every discriminant component.  No `K_proj,C`-rational point or global
   obstruction is known.  The two most natural smooth-reduction places have
   also been isolated exactly.  The forms `f5` and `f6` define single
   geometrically integral divisors; `f7/f6` and `f3^2/f5` are componentwise
   unit weight-one gauges.  Their residue cubics are smooth, but none of the
   three coordinate vertices lies on them and the complete invariant-
   polynomial `x,C,D` point ansatz is empty in every total source degree
   1 through 15.  This proves only a height lower bound.  A local obstruction
   now requires the actual residue 3-descent at one of these primes, or a
   relative unramified 3-Selmer class.
   See
   `tmp/xcd_control_next/REPORT.md`,
   `tmp/xcd_generic_cech_next/REPORT.md`,
   `tmp/xcd_first_descent_next/REPORT.md`,
   `tmp/xcd_arithmetic_next/REPORT.md`,
   `tmp/xcd_discriminant_divisor/REPORT.md`, and
   `tmp/xcd_gauge_divisors/REPORT.md`.

5. **The very recent level-11 theta/Schwarz lead is closed.**  Its
   five-dimensional projective action is exactly the repository Klein
   representation, but after the unique monomial conjugacy its theta series
   satisfies
   \[
   F(H\Phi_{11})=\xi_{44}^5u^{11}+O(u^{99})\ne0.
   \]
   All 25 classical Hessian minors are nonzero as well.  The paper's
   one-variable Picard--Vessiot construction could regression-test a curve
   pullback of the connection, but its explicit ODE is only for level 9; a
   level-11 equation would first need reconstruction and still could not
   constrain the connection's four independent derivations.  See
   `tmp/theta11_test/REPORT.md`.

6. **Degree 16 is reduced to a finite relative incidence.**  The complete
   quotient has dimension 20 and the complete landing image has rank 93.
   In scalar/normal coordinates the 93 cubics have bidegree ranks
   `0,66,77,93`.  The pure-normal cubic ideal is Artinian of length `6,169`,
   so projection to the scalar `P3` is finite.  The scalar locus has constant
   normal linear rank seven and a common nine-dimensional tangent kernel;
   the entire straight tangent-kernel stratum is empty by an exact weighted
   cokernel of length `713`.  The weighted-projective second-order lifting
   incidence is empty: no nonzero normal tangent direction admits a
   second-order lift.  A formerly proposed shortcut is now refuted:
   the `93 x 15` weighted matrix has rank exactly five on the tangent-kernel
   `P8`, so its cokernel cannot have finite length.  This rank drop produces
   no landing point because its kernel misses the required
   `y=(Sym^2(s),s,1)` locus.  Degree 16 itself remains open at the actual
   Veronese-affine residual incidence.  Off the tangent kernel, the first ten
   columns have rank ten, but quotienting them does **not** descend the
   problem to `P(im T)=P6`: the nine tangent-kernel coordinates remain in
   `Q(n)` and `C(n)`.  The honest base is the blowup of `P15` along `P8`,
   fibred over `P6`.  A cleared quotient formulation has 19 variables and
   93 equations of degrees 12 and 13, so the `83 x 5` matrix shape is not a
   computational reduction and its 5-minors must not be expanded.  Use the
   absence of nonzero second-order lifts to split or saturate away the scalar
   component in the original cubic system.  The first exceptional-image
   equation is now exact in characteristic 67.  There is a normal linear form

   ```text
   L=(1,38,20,6,8,2,25,56,9,25,34,21,38,12,54,64)
   ```

   which annihilates the common kernel `K`, and one fixed combination of the
   93 complete landing cubics is exactly `59*L^3`.  Hence every residual
   special-fibre point lies over the hyperplane
   `ell=t0+38*t1+20*t2+6*t3+8*t4+2*t5+25*t6=0` in `P6`.  On `ell=0` two
   fixed row combinations vanish identically and one exact fibre proves the
   generic row rank there is 91.  Exact full solves exclude 8 initial gate
   failures and 256 further deterministic points of this hyperplane.  These
   finite solves do not prove hyperplane emptiness.  The first complete
   hyperplane chart has 18 variables, 91 independent cubics, and 99,744
   terms; both four-thread and one-thread `msolve` runs reached the 700 MiB
   watchdog without output.  Thus the residual support is rigorously narrowed
   to `ell=0` only in the mod-67 fibre, while its deeper scheme structure and
   any lifted characteristic-zero support equation remain open.  See
   `tmp/degree16_landing_probe/REPORT.md` and
   `tmp/degree16_exceptional_search/REPORT.md`.

## Recent literature and tool audit

The 2026-07-18 author version of Cheltsov--Tschinkel--Zhang still lists this
\(\operatorname{PSL}_2(\mathbf F_{11})\) Klein-cubic action as open.  The
July 2026 Schwarz-map construction is the only newly found result with the
right level-11 representation; the exact test above closes its displayed
theta curve as a Klein-cubic parametrization.

The February 2026 Kresch--Tschinkel survey
[*Invariants in equivariant birational geometry*](https://arxiv.org/abs/2602.23998)
adds higher Amitsur and equivariant Burnside tools to the audit.  It does not
open a missed obstruction here: the honestly linearized hyperplane class
makes the ordinary and higher Amitsur classes vanish, while Burnside and
decomposition-of-the-diagonal invariants distinguish equivariant birational
or stable-linearization types and do not obstruct the weaker existence of a
dominant equivariant map in this case.

The 2026-06-30 Poonen--Stoll paper
[*The valuation of the discriminant of a hypersurface*](https://math.mit.edu/~poonen/papers/discriminant.pdf)
is a genuinely relevant missed theorem, rather than a new solver.  Its
Theorem 1.1 says that discriminant valuation one over a DVR is equivalent to
a regular total hypersurface with one residue-rational nondegenerate double
point.  Combined with the new squarefree `xCD` discriminant certificate, it
closes every discriminant component as a local-obstruction place.  It does
not supply a global point or control smooth-reduction divisors.

One 2025 elimination method is a genuine conditional lead.  The
[generalized multiplication matrices of Bender--Busé--Checa--Tsigaridas](https://arxiv.org/abs/2502.07048)
apply to a
bihomogeneous system when its projection to parameter space is finite (or
empty) and an admissible bidegree is certified.  They would supply the
multiplication-closed quotient missing from the degree-12 border truncation.
The hypothesis is not yet available here: the exceptional projection is only
known to be proper closed and could contain a surface or curve.  Test its
dimension on the bihomogeneous graph incidence in `P3 x P15`.  Exact Hilbert
counts rule out every fiber degree `b=5` or `b=6`; the first pair not ruled
out by dimension alone is `(a,b)=(2,7)`, already a structured
`422,484 x 434,763` hyperplane rank problem.  The general guaranteed bound is
astronomically too large here, so continue only if a sparse or
representation-theoretic calculation makes this first feasible gate
practical.  Use this method only if the projection is zero-dimensional.
The direct `p3=0` triangular cover has now timed out on all three charts, and
the tested deterministic coordinate-nondegenerate line offers no first-round
structural gain, so neither direct test supplies that hypothesis and neither
should be extended unchanged.
[SPQR-style finite-field reconstruction](https://arxiv.org/abs/2511.14875) may
suggest parameter equations, including through elimination orders for
positive-dimensional systems over rational-function fields; its
companion-matrix route alone is zero-dimensional.  Mathematica is unavailable
locally, and any reconstructed candidate still needs exact ideal or
annihilator verification.

The other recent computational releases do not change the exact proof boundary.
HomotopyContinuation.jl now has numerical irreducible decomposition,
membership/intersection routines, and stronger duplicate certification;
these could diagnose a smaller exceptional component but do not certify the
characteristic-zero relative ideal used here.  EliminationTemplates targets
zero-dimensional radical parameter families, not the present large relative
border module.  The July 2026
[RationalUnivariateRepresentation.jl](https://arxiv.org/abs/2607.06397)
provides exact fast output only after a zero-dimensional ideal is already
available; neither current relative locus has reached that gate.  The
2026-07-27 Groebner.jl interface does expose
`groebner_with_change_matrix`, returning `M*generators=basis` over finite
fields or `QQ`.  This was the one material missed tool capability, so Julia
1.12.6 and Groebner.jl 0.10.4 were installed under ignored `tmp/` and tested
exactly.  A toy system and the one-row top-ideal prefix pass both the matrix
identity and deterministic certified Groebner checks.  The fixed two-row
change-matrix prefix, however, crosses the `768 MiB` RSS gate before output,
and parsing 512 of the 721 rows crosses the same gate before Groebner
computation.  There is no public raw-data change-matrix entry point.  The
official high-level route is therefore closed at this scale under the stated
memory bound; see `tmp/groebnerjl_change_matrix_pilot/REPORT.md`.  Magma's
`ThreeTorsionMatrices` functionality does not solve the arithmetic point or
local-obstruction problem on the assembled transcendence-degree-four cover,
and Magma is also unavailable in this workspace.  The exact stack is custom
Python quotient-algebra DAG arithmetic plus `M2` and `msolve`; the latter two
remain the large-elimination backends.  Stop broad tool search unless a
package offers one of these precise missing capabilities: a certified
relative Fitting presentation with transformations, or exact generic
multivariate rational-point/local/Selmer machinery for the assembled
3-descent covering.

## What the current attacks established

### 1. Jacobian-zero self-covariants

The complete degree-eleven system is certified. At the good split prime 67
the degree-eleven self-covariant space has dimension 12. The same 640 source
points separate all 509 degree-50 invariants, and the universal Jacobian
coefficients have exact rank 496. All twelve triangular projective charts
return the unit ideal; the two largest take 85.89 and 18.57 seconds. Proper
specialization therefore proves that every nonzero degree-eleven
self-covariant is dominant. Together with the earlier degrees, the
Kraft--Loetscher--Schwarz Jacobian-zero alternative is excluded through
degree eleven only.

The certified degree-eleven envelope is:

```text
self-covariant dimension                 12
coefficient degree of det(Dq)             5
source degree of det(Dq)                 50
dimension of source invariants R_50     509
coefficient quintic monomials          4368
retained exact solver input             35.7 MB
```

Degree twelve has now also been reconstructed completely at the good split
prime 67.  The self-covariant space has dimension 16, the Jacobian has source
degree 55, and the complete coefficient span has rank

```text
dim R_55                                  721
coefficient quintic monomials          15504
retained independent equation rows       721
```

The exact splitting used for the structural attack is

\[
M^{W}_{12}=D^{W}_{12}\oplus P^{W}_{12},\qquad
\dim D^{W}_{12}=12,\quad \dim P^{W}_{12}=4.
\]

The pure primitive locus is empty because its restriction has the full
rank 56 of all quintics in four variables.  All twelve triangular charts of
the decomposable projective locus are unit ideals.  The first direct mixed
chart gate timed out after 600 seconds at a degree-seven matrix of size
`104836 x 166810`, so the other three direct charts were not launched.
The relative calculation has since replaced that gate.  On the primitive
chart `p0=1`, the exact fiber `[1:1:1:1]` is a unit ideal.  Because the
decomposable center is empty, projective projection to the primitive
parameter space is proper; its image is therefore a proper closed subset in
characteristic 67 and in characteristic zero.  Thus the KLS Jacobian
alternative is excluded through degree eleven uniformly and on a nonempty
Zariski-open part of degree twelve.  The only remaining degree-twelve locus
is a proper closed exceptional subset.  The explicit map

\[
\mu_7:A^{65,611}\longrightarrow A^{50,388},\qquad
A=\mathbf F_{67}[p_1,p_2,p_3].
\]

records degree-at-most-seven multiples only; it is not yet a presentation of
that geometric subset.  Fiberwise membership of the constant class at the
empty sample fiber does not produce a relative annihilator.  Its initial
degree-five block has a parameter-independent `721 x 721` minor of
determinant `18 mod 67`.  The fixed top ideal has colength `9,193` and no
degree-seven standard monomials, proving finite top control.  Its full
reduced basis is audited, but the degree-six/seven source transformations
and a multiplication-stable relative annihilator are still missing.  See
`tmp/relative_kls_chart/REPORT.md` and
`tmp/relative_kls_chart/TOP_IDEAL_REPORT.md`.

These are bounded theorems, not an all-degree result. A
characteristic-zero covariant verified to have zero Jacobian would be
headline-positive; a finite-field survivor would only be a lifting
candidate.

There is now also an exact degree-free form of this attack.  Put
\(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\) and
\(P_0=\mathbf C(t_3,t_6,t_8,t_{11})\).  Normalize the generic frame by
\(\tau=f_3^2/f_5\).  Its logarithmic derivative defines a flat connection
\(\nabla\) on \(K_{\rm proj}^5\), and the complete KLS question is

\[
\exists[a]\in\mathbf P^4(K_{\rm proj}):
\det[a,\nabla_1a,\nabla_2a,\nabla_3a,\nabla_4a]=0.
\]

A point proves essential dimension three; universal nonvanishing proves
essential dimension four.  This removes the artificial polynomial-degree
parameter but does not solve the resulting first-order rational PDE.  Finite
module generation gives no cutoff, as an exact \(S_5\) counterexample shows.
The invariant-field infrastructure is no longer missing.  The primaries
\(f_3,f_5,f_6,f_8,f_{11}\) are certified algebraically independent, Adler's
twelve secondaries are certified as a free Hironaka basis, all 78 symmetric
basis products have exact rational reductions, and the normalization by
\(\tau\) gives a checked extension \([K_{\rm proj}:P_0]=12\).  This model
supports exact addition, multiplication, inversion, trace, and norm.  The
four connection matrices are now retained as exact arithmetic circuits in
this model rather than expanded through the tested 1,810,306-term
primitive-element adjugate.  The circuit is backed by 101 frame/structure reductions
and 20 secondary-derivative reductions over \(\mathbf Q\).  At
\((t_3,t_6,t_8,t_{11})=(1,2,3,4)\), the horizontal regular operator has rank
48, the frame determinant is invertible, all 100 specialized matrix entries
are reconstructed exactly, and Leibniz is checked on all 78 field products.
Exact modular-rank certificates exclude all 121 projective constant
directions in \(\{-1,0,1\}^5\) and all 440 ordered Hironaka-linear ansätze
\(e_i\pm b_s e_j\).  The full rational PDE remains unsolved.

Evidence: `tmp/degree10_jacobian/REPORT.md`,
`tmp/degree11_jacobian/REPORT.md`, `tmp/degree12_jacobian/REPORT.md`,
`tmp/degree12_jacobian_structural/REPORT.md`, and
`tmp/kproj_arithmetic/REPORT.md`, with the connection circuit in
`tmp/kproj_connection/REPORT.md` and the all-degree reduction in
`tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`.

### 2. Schur source: the degree-six pencil and rational degree-eight frame

The full rational-coefficient degree-six pencil is closed.  After reduction
modulo 23 its primitive landing cubic is a single exponent-one factor of
total degree 21 and pencil degree three over both \(\mathbf F_{23}\) and
\(\mathbf F_{23^3}\).  Independently, a degree-72 discriminant
specialization factors in degrees 12, 21, and 39, all with exponent one, so
it is nonsquare.  This proves that the primitive cubic
\(F(q_0+tq_1)\) is absolutely irreducible after good reduction and hence has
no root even in \(\mathbf C(V_6)\).

This is stronger than a constant-coefficient pencil calculation.  More
importantly, five explicit degree-eight Reynolds covariants, divided by a
degree-eight invariant, form a basis of the descended Klein five-space over

\[
K=\mathbf C(\mathbf P(V_6))^G.
\]

Thus they give an all-degree normal form for every rational Schur-source map:
this Schur-source path is exactly whether one explicit twisted Klein cubic
has a nonzero \(K\)-point, which would solve the headline. All ten coordinate
lines of this frame are excluded by exact good-reduction factorization, so
any such point must use at least three frame coordinates.  The ten ternary
coordinate planes have now been tested for the full invariant-coefficient
spaces in degrees 0, 4, 6, 8, and 10 and for the five-dimensional degree-12
space \(S_{12}=f_4R_8+\langle f_6^2\rangle\); every one is projectively
empty.  All 90 enlargements \(S_{12}+\langle p_j\rangle\), for the nine
fixed quotient directions in \(R_{12}/S_{12}\), are also empty by exact
Artinian leading ideals.  One two-direction gate is empty, but its measured
cost projects all 360 pair gates to 4.73 hours, so the other 359 were not run.
Those other two-direction slices, all larger quotient-support combinations,
the full \(R_{12}\), higher
coefficient degrees, and four- or five-coordinate points remain open.  These
bounded coefficient-support exclusions are not a negative solution.

The separate constant-coefficient degree-twelve filtration is now exhausted
through primitive support two.  Write \(D_{12}^{V_6}\) for its decomposable
sector (called `D_12` in the artifacts).  Then
\(\dim D_{12}^{V_6}=16\) and \(\dim(M_{12}/D_{12}^{V_6})=32\); exact leading
ideals exclude \(D_{12}^{V_6}\), all 32
\(D_{12}^{V_6}+\langle p_i\rangle\) slices, and all 496
\(D_{12}^{V_6}+\langle p_i,p_j\rangle\) slices.  Thus a landing
covariant must use at least three nonzero primitive coordinates in this fixed
quotient basis.  This basis-dependent support theorem is not emptiness of the
full 48-dimensional landing locus.

The justified transformed chart gate has also been run.  In the exact
\(D_{12}^{V_6}\oplus\langle p_0,\ldots,p_{31}\rangle\) coordinates, the chart
\(p_0=1\) retains all 1,124 equations but times out after 600.877 seconds at
a `44328 x 245460` matrix, slightly worse than the old standard-coordinate
gate.  The remaining 31 transformed charts were therefore not launched.
The length-439 decomposable quotient is available for a future relative
elimination, but any such argument must track monic-reduction and rank-drop
exceptional strata.

Evidence: `tmp/projective_source/REPORT.md`,
`tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`, and
`tmp/ed_binary_attack/PROJECTIVE_PENCIL_AUDIT.md`, together with
`tmp/projective_source_degree12_structural/REPORT.md`,
`tmp/projective_source_degree12_primitive_chart/REPORT.md`, and
`tmp/schur_ternary_planes/REPORT.md`.

### 3. Degree-thirteen through degree-fifteen landing self-covariants

The authoritative result is the independent structural proof, not the
partial direct F4 run.  At the split prime 67, 48 necessary cubics restrict
the support of

\[
M_{13}/fM_{10},\qquad \dim(M_{13}/fM_{10})=11,
\]

to the scalar plane.  Writing a lift as \(q=rx+fh\), both possible
\(f\)-adic branches have exact Artinian leading ideals, with Hilbert
functions

```text
[1,10,55,140,6,0]
[1,10,55,116,3,0].
```

Proper specialization therefore proves that no nonzero degree-thirteen
self-covariant lands in the Klein cone. This is now subsumed into the
degree-fourteen cutoff below.

The direct q67 terminal run now independently corroborates this theorem. It
completed normally in 7,458.060 seconds; its hash-verified leading ideal has
21,674 monomials and contains a pure power of every one of the 21 coefficient
variables. The verifier therefore certifies an Artinian affine cone and an
empty projective landing locus. Its quotient Hilbert function begins
`[1,21,231,1569,6408,7303,26]`; the nonzero degree-six value is compatible
with Artinianness. The earlier partial F4 basis, which leaves 26 standard
classes in degrees six and seven, proves no projective emptiness by itself.

Evidence: `tmp/structural_degree13/REPORT.md` and
`tmp/degree13_opt/REPORT.md`; the superseded partial diagnostic is in
`tmp/degree13_step2/REPORT.md`.

Degree fourteen is now closed by its structural successor at the same split
prime 67.  The quotient \(M_{14}/fM_{11}\) has dimension 14, and its complete
rank-64 landing-equation span is supported on the two-dimensional scalar
subspace: all twelve normal-complement Rabinowitsch systems are unit ideals.
For the two lift branches, the degree-11 landing ideal has Hilbert function
`[1,12,78,253,76,0]`, while the normalized tangent image
\(T(h)=fh-A_hx\) has Hilbert function `[1,12,78,233,34,0]`.
Both are Artinian. Proper specialization therefore excludes landing
self-covariants in degree fourteen.

Evidence: `tmp/degree14_structural/REPORT.md`.

Degree fifteen is now closed by the next structural successor.  The quotient
\(M_{15}/fM_{12}\) has dimension 16.  Its landing-coefficient image has
exact rank 75: an explicit 76-element Hironaka basis of
\(R_{45}/fR_{42}\) is independently unisolvent on the same points.  Scalar
classes form a four-dimensional subspace, and all twelve normal affine
charts are unit ideals.  The `f`-divisible lift branch has Hilbert function
`[1,16,136,663,1453,0]`; the normalized tangent branch has Hilbert function
`[1,16,136,618,771,0]`.  Both are Artinian.  Thus landing
self-covariants are excluded through degree fifteen; degree sixteen is the
first unrestricted homogeneous landing degree.

Evidence: `tmp/degree15_structural/REPORT.md`.

### 4. The `xCD` Kummer/3-descent route

The characteristic-zero plane cubic

\[
F(ax+bC+cD)=0
\]

is explicit in ten coefficient polynomials (1,256 terms in total), with exact
universal \(c_4,c_6\) and Jacobian formulas.  The exact rank-12 arithmetic
model of \(K_{\rm proj}\) now decomposes all ten coefficients and computes
the full characteristic-zero discriminant.  Over this field the genuine
rank-nine \(E[3]\) algebra is installed as

\[
\mathcal R=K_{\rm proj}\times
K_{\rm proj}[x,y]/(\psi_3(x),y^2-x^3-Ax-B),
\]

with the group, difference, and normalized Kummer-function formulas kept
distinct from the flex torsor.  The typed Cech construction and its
scalar-cochain normalization now also install a generic-open rational
representative of the torsor's first-Kummer class.  The remaining problem is
the arithmetic `K_proj,C`-point problem on the original projective `xCD`
plane cubic, which is isomorphic as a covering to the distinguished
base-defined component of the assembled first-descent union, not extraction
of the class representative or all 729 components.

At \(s=1\), an independent exact control fiber includes all nine \(E[3]\)
points, the distinct flex torsor, the true degree-12 three-flex-line algebra
with Frobenius orbit degrees `4+8`, its incidence and norm identities, and a
positive cube witness.  That fiber has a rational flex, so its Kummer class is
trivial and it cannot validate a nonzero generic class.  The lower-height
degree-86 non-coordinate specialization has a nonzero flex class; only its
frozen Magma L-function and 2-Selmer jobs remain unrun.  Separately, a low-height
coordinate-line plane over \(\mathbf F_{23}(t)\) has a rational point
\(O=[1:0:1]\) and an absolutely irreducible degree-nine flex cover.  Its flex
class is therefore nonzero but abstractly Kummer, equal to \(\delta(Q)\) for
\(Q=[H-3O]\), where \(H\) is a hyperplane section.  The tangent residual now
gives this \(Q\) explicitly on the saved short Weierstrass Jacobian.  The
irreducible degree-eight field of nonzero \(E[3]\)-points and the values
\(G_T(Q)\) are serialized; exact replay proves that these values are the
genuine nonzero first-Kummer representative of \(\delta(Q)\).  Independent
translation interpolation timed out before producing a matrix or determinant,
but that no longer blocks validation of the control.  This remains a
characteristic-23 conventions check and supplies no generic
characteristic-zero class.  See `tmp/xcd_control_next/REPORT.md`.

The descent audit identifies the remaining conceptual requirements that
cannot be skipped:

1. the flex-torsor algebra is not the coordinate algebra of \(E[3]\).  On the
   generic plane, the rank-nine flex algebra \(F\), universal flex \(P\), Cech
   difference \(c_{12}=P_2-P_1\in E[3](F\otimes_KF)\), triple-overlap
   identity, and induced rank-81 isomorphism
   \(F\otimes_K\mathcal R\simeq F\otimes_KF\) are now installed without a
   splitting field.  The difference coordinates are retained as typed
   `K_proj`-algebra nodes rather than distributed Hironaka vectors.  A
   universal translation matrix is unnecessary.  A unit scalar-cochain
   normalization of the projective lift now descends to the rank-nine group
   algebra and supplies the genuine first-Kummer representative `alpha_R`.
   The affine unit interface for `G(P)=alpha_R*z^3` is assembled; the
   remaining first-descent problem is arithmetic over `K_proj,C`.  The
   distinguished first-descent component is
   \(K_{\mathrm{proj},\mathbf C}\)-isomorphic to
   the original explicit projective plane cubic, so its existing closure—not
   the full 729-component closure—is the correct direct target;
2. the degree-twelve algebra of lines through triples of flexes is certified
   only in the \(s=1\) control.  The generic twisted algebra, line forms, and
   normalization constants are still required for true second descent.

The former invariant-field blocker is closed.  Exact primitive formulas for
all four formerly missing generators are installed, and the following items
are now certified:

```text
algebraic independence of f3,f5,f6,f8,f11
the rank-12 Hironaka basis over
  A = C[f3,f5,f6,f8,f11]
the complete 12 by 12 multiplication table
the tau=f3^2/f5 normalization giving [K_proj:P0] = 12.
```

This supplies honest addition, inversion, trace, and norm in
\(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\).  Factoring in the ambient
660-fold cover \(\mathbf C(\mathbf P(W))\) cannot substitute for it.
Positive-only candidate searches may also proceed directly in the ambient
field: one may
compute in \(\mathbf Q(\zeta_{11})(w_0,\ldots,w_4)\), then certify a proposed
point by checking the coordinate ratios under the exact group generators and
verifying the cleared cubic identity.  What cannot be made there is an
exhaustive negative or a factorization claim over \(K_{\rm proj}\).

Evidence: `tmp/xcd_descent_algebra/REPORT.md`,
`tmp/xcd_descent_math/REPORT.md`, `tmp/kproj_arithmetic/REPORT.md`, and
`tmp/xcd_genuine_descent/REPORT.md`, with the nonzero Kummer control in
`tmp/xcd_nonzero_kummer/REPORT.md` and the reconstructed generators in
`tmp/xcd_invariant_field/f10_probe/REPORT.md`.  The generic flex eliminant,
universal flex point, and diagonal idempotent are in
`tmp/xcd_generic_cech_next/REPORT.md`.

All four attacks now converge on a canonical arithmetic boundary.  For the
generic projective torsor over
\(K_{\rm proj}=\mathbf C(\mathbf P(W))^G\), let \(C_{\rm gen}\) be the Klein
twist.  Then

\[
\operatorname{ed}(G)=3\iff C_{\rm gen}(K_{\rm proj})\ne\varnothing,
\qquad
\operatorname{ed}(G)=4\iff C_{\rm gen}(K_{\rm proj})=\varnothing.
\]

Every Klein twist has index one from the cycle degrees \(60,132,165,220\),
but no audited point theorem applies.  All prime-local essential dimensions
are at most two, and the standard Brauer, Amitsur, and stable-cohomology
packages checked here do not distinguish the two cases.  This strict ledger
is in `tmp/step4_essential_dimension/REPORT.md`.

## Ranking A: best bounded exact next computations

1. **Test two-coordinate first jets in the flat-connection coefficients.**
   The two residue leading systems are solved and positive-dimensional; all
   60 smallest constant simultaneous `P2` families and all 720 one-coordinate,
   one-coefficient-slope `P3` families are empty.  The stronger screen also
   excludes all 240 `P5` families with independent slopes in all three
   coefficients along one common base-coordinate direction.  The next
   controlled enlargement is the `P8` family
   `sum_r (c_r+d_r*u+e_r*v)*s_r`, first for one frame triple with three
   affinely independent regular fibres and a strict Gröbner timeout.  More
   constant coefficient boxes or another one-direction sweep are not
   justified.
2. **Attack the selected genuine first-descent component.**  The rank-nine
   flex and `E[3]` algebras, diagonal, typed `lambdaSharp`, Cech `(X,Y)`, and
   scalar-normalized generic `alpha_R` are serialized and replayed.  The
   normalized functions `G_T` are assembled into `G(P)=alpha_R*z^3` over
   `K_proj,QQ`: ten variables, nine cubics, plus the `R8`-norm unit condition.
   The unit-open scheme has 729 geometric degree-nine components, but its
   distinguished base-defined component is isomorphic as a covering to the
   original projective `xCD` cubic.  Work on that cubic, not the raw union.
   The pure-coefficient divisor families `A=0`, `B=0`, and `C=0` are already
   locally soluble, and the squarefree degree-120 discriminant audit rejects
   every discriminant component as a local-obstruction place.  The next
   negative gate is a relative unramified 3-Selmer calculation or the actual
   residue 3-descent at `f5=0` or `f6=0`.  Both are single smooth-reduction
   primes, but complete invariant-polynomial point searches through total
   degree 15 are empty and give no local verdict.  Number-field primes and
   `QQ`-only Selmer tests cannot prove a negative complex verdict.
   A solution gives a point on this plane; a nonmembership result closes only
   this plane.  Generic second descent still requires the three-flex-line
   algebra.
3. **Certify and compose the degree-12 survivor circuit.**  Generic-open
   emptiness and finite top control are proved, while `mu7` remains only a
   truncation.  The corrected trace and complete division plan already provide
   the circuit interface for the `31,824 x 56,238` top solve.  Implement the
   ambient-polynomial semantic verifier from the completed 721 degree-five
   rows to the remaining 7,846 degree-six/seven rows, with live-row
   reclamation and the audited `478,080,096`-byte all-row plan.  If it passes,
   retain the division composition as a circuit and check `M7 R = I`; do not expand
   the 244,272,637-byte dense selected output or pay its `1.59e12` source-
   coordinate updates.  Then test sparse degree-at-most-two multipliers for a
   full-rank lazy `18,564 x 18,564` reduced multiplication operator.  A
   specialized unit vector is the guaranteed fallback.  Only after those
   finite-field checks should the pivot data be lifted to an integral or
   number-field model.  The direct hyperplane and deterministic line tests
   hit their stop rules; revisit projection dimension only after a sparse or
   block reformulation, and use generalized multiplication matrices only if
   zero-dimensional projection is proved.
4. **Split the degree-16 scalar component before residual elimination.**  Pure
   normal infinity and the common nine-dimensional tangent-kernel slice are
   empty, and no nonzero normal tangent direction admits a second-order lift.
   Do not extend the
   weighted-cokernel calculation: global rank 15 is impossible because the
   matrix has rank five on `P8`.  The `83 x 5` quotient matrix does not live
   on `P6` alone: all nine kernel coordinates remain, and clearing the
   quotient plus Veronese recovery yields 93 high-degree equations in 19
   variables.  Do not expand its 29,034,396 maximal minors.  Instead exploit
   the absence of nonzero second-order lifts to construct a colon/saturation that removes
   the scalar component while retaining the original cubics.  A complete
   `K9+s4` fiber already proves generic-open emptiness over `P6`; now compute
   the scheme-theoretic image/Fitting support of its proper closed exceptional
   direction locus on the six-parameter `t0=1` chart while retaining all nine
   kernel coordinates.  More isolated `t` samples are diagnostics only.  Do
   not sweep fixed scalar charts.
5. **Pfaffian degree sixteen only after a structural reduction.**  The
   existing 80-variable, 1,313-quadratic run timed out without a leading
   ideal.  Repeating the same envelope with a longer clock is less promising
   than changing variables or exploiting the quaternionic-Hermitian model.

The completed q67 degree-thirteen terminal job is not ranked because it has
now corroborated a bounded locus already decided by the structural proof.
The structural degree-fourteen and degree-fifteen quotients and lift branches
are no longer ranked because their exact exclusions are complete.
The 496 degree-twelve two-primitive slices are likewise no longer ranked:
their exact scan is complete and raises the fixed-basis primitive-support
lower bound from two to three.
The unchanged homogeneous degree-twelve solve and the 48 standard-coordinate
chart sweep are also no longer ranked: the terminal audit proves that more
source sampling cannot enlarge the equation span, the saved F4 rounds are not
resumable, and the tested charts retain the same computational bottleneck.

## Ranking B: strategic headline leverage

1. **Attack the exact flat-connection KLS equation.**  The rank-12 Hironaka
   arithmetic and the checked circuit form of the four matrices \(\Gamma_r\)
   are certified.  Seek a rational point of
   \(\mathcal J_\nabla=0\), or a theorem proving universal nonvanishing.
   Degree 12 remains a useful bounded candidate search, not a route to a
   negative conclusion by itself.
2. **Attack the honest generic `xCD` first-descent component.**  The
   off-diagonal tangent inverse, Cech difference, and genuine first-Kummer
   class are complete as typed quotient-algebra circuits, and the normalized
   ten-variable/nine-cubic interface for `G(P)=alpha_R*z^3` is built.  Seek a
   `K_proj,C`-rational point or a genuine geometric-divisor obstruction on
   the original projective plane cubic; the three pure-coefficient divisor
   families have already been rejected.  Then construct
   the twisted three-flex-line algebra, line forms, and constants.  A point in
   this plane immediately solves the headline.  Nonmembership for this one
   plane would close only that plane, so a negative result must not be
   promoted to the full cubic.
3. **Solve a ternary (or larger) support in the rational degree-eight Schur
   frame.**  Any nonzero \(K\)-point on its explicit twisted Klein cubic gives
   a rational equivariant map \(\mathbf P(V_6)\dashrightarrow C\) and solves
   the headline.  The frame is exhaustive in all degrees and its ten binary
   supports are closed.  The bounded ternary coefficient envelopes through
   \(S_{12}+\langle p_j\rangle\) are also closed; the remaining problem is
   an unrestricted invariant-field point, not another low-degree null scan.
4. **Use the Pfaffian Hermitian model structurally.**  A theorem producing a
   common isotropic quaternionic line has headline leverage.  Another finite
   covariant exclusion does not.

## Deprioritized work

- Use the completed hash-verified q67 artifact; the earlier live log and the
  26-class partial degree-thirteen F4 certificate were not proofs by
  themselves.
- Do not spend the next cycle rerunning the same 80-variable Pfaffian solve.
- Do not resample the complete characteristic-23 degree-twelve Schur equation
  span, rerun either homogeneous/transformed 600-second job, or launch the
  remaining standard or primitive affine charts without a structural change.
- Do not launch the remaining 359 Schur ternary two-direction slices: the
  exact gate projects the sweep to 4.73 hours and no symmetry quotient is
  certified.
- Do not launch unchanged mixed degree-twelve Jacobian charts.  The relative
  fiber has already proved generic-open emptiness; work on a
  multiplication-stable relative annihilator instead.  Do not mistake the
  retained degree-seven border truncation for the exceptional image.  The
  three `p3=0` charts already timed out and the tested deterministic
  coordinate-nondegenerate line has the same first matrix profile, so do not
  extend either direct projection test unchanged.
- Do not rerun the bounded `xCD` control translation interpolation.  The
  genuine nonzero Kummer representative and the generic Cech cocycle are
  already explicit; the missing datum is a `K_proj,C`-rational solution of,
  or a scoped nonmembership result on, the original projective `xCD` cubic.
  Do not extract the other 728 components merely to restate that point
  problem.
- Do not pursue the level-11 theta/Schwarz curve as a Klein-cubic
  parametrization: its Klein cubic and all 25 Hessian-minor tests are
  nonzero.
- Do not treat a rank or point result on an \(\mathbf F_{23}(s)\) source line
  as transferring to the characteristic-zero generic plane.
- Do not use the flex-torsor algebra as if it were the \(E[3]\) algebra.
- Do not expect finite generation of covariants to supply an all-degree
  cutoff; the exact module audit and the installed \(S_5\) counterexample
  rule out that shortcut.

## Fast replay

The commands below replay the local research state and require the ignored
about 6.1 GB `tmp/` artifact tree. They are not expected to work in a fresh clone;
use the commands in `certificates/README.md` for the portable checked-in
subset.

```sh
python3 tmp/theta11_test/theta11_test.py
python3 tmp/kls_divisor_ansatz/verify.py
python3 -u tmp/kls_residue_next/verify.py
python3 tmp/kls_first_jet_two_fiber/verify_manifest.py
python3 tmp/kls_first_jet_two_fiber/verify.py --ledger-only
python3 tmp/kls_first_jet_two_fiber/verify_manifest_p5.py
python3 tmp/kls_first_jet_two_fiber/verify_p5.py --ledger-only
python3 tmp/relative_kls_chart/verify.py
python3 tmp/relative_kls_chart/analyze_exceptional.py
python3 tmp/relative_kls_chart/analyze_top_ideal.py
python3 tmp/relative_kls_chart/verify_top_full_gb.py
python3 tmp/relative_kls_chart/verify_degree_lowering_plan.py
python3 tmp/relative_kls_chart/verify_transform_extraction_gate.py
python3 -u tmp/relative_kls_chart/survivor_trace/verify_survivor_trace.py
python3 -u tmp/relative_kls_chart/survivor_trace/evaluator/verify.py \
  --manifest tmp/relative_kls_chart/survivor_trace/evaluator/manifest.json
/opt/homebrew/bin/python3 -u \
  tmp/relative_kls_chart/survivor_trace/semantic_check/verify.py
python3 tmp/relative_kls_chart/bihomogeneous_pilot.py
python3 tmp/relative_kls_hyperplane/verify.py
python3 tmp/relative_kls_hyperplane/verify_line_pilot.py
python3 tmp/xcd_control_next/verify.py
python3 -u tmp/xcd_generic_cech_next/verify.py
python3 -u tmp/xcd_generic_cech_next/verify_generic_dag.py
python3 -u tmp/xcd_generic_cech_next/verify_cech_extension.py
python3 -u tmp/xcd_generic_cech_next/verify_typed_cech.py
python3 -u tmp/xcd_generic_cech_next/verify_alpha_corrected.py
python3 -u tmp/xcd_first_descent_next/verify.py
python3 -u tmp/xcd_arithmetic_next/verify.py
python3 -u tmp/xcd_discriminant_divisor/verify.py
/opt/homebrew/bin/python3 -u tmp/xcd_gauge_divisors/verify.py
python3 tmp/groebnerjl_change_matrix_pilot/verify.py
python3 tmp/degree15_structural/verify.py
python3 -u tmp/degree16_landing_probe/verify.py
python3 tmp/degree16_landing_probe/verify_off_k_residual_audit.py
python3 tmp/degree16_landing_probe/verify_off_k_t_fiber_attack.py
python3 tmp/degree10_jacobian/verify_outputs.py
python3 tmp/degree11_jacobian/verify_outputs.py
python3 tmp/degree12_jacobian/verify_outputs.py --require-gate
python3 tmp/degree12_jacobian_structural/verify.py
python3 tmp/degree12_jacobian_structural/verify_decomposable_cover.py
python3 tmp/degree12_jacobian_structural/verify_mixed_gate.py
python3 tmp/ed_binary_attack/verify_all_degree_module_pde.py
python3 tmp/step4_essential_dimension/verify_reductions.py
python3 tmp/kproj_arithmetic/verify.py
python3 tmp/kproj_connection/verify.py
python3 tmp/projective_source/verify_degree6_geometric_factor.py
python3 tmp/projective_source/degree8_rational_frame.py
python3 tmp/projective_source/degree8_frame_line_probe.py
python3 tmp/projective_source/primitive_degree12/verify.py
python3 tmp/projective_source_degree12_structural/verify_decomposable.py
python3 tmp/projective_source_degree12_structural/verify_primitive_one_slices.py
python3 tmp/projective_source_degree12_structural/verify_primitive_two_slices.py
python3 tmp/projective_source_degree12_extension_independent/verify.py
python3 tmp/projective_source_degree12_extension_independent/landing_verify.py
python3 tmp/projective_source_degree12_extension/verify_landing.py
python3 tmp/projective_source_degree12_chart_probe/audit_and_probe.py --verify
python3 tmp/projective_source_degree12_primitive_chart/verify.py
python3 tmp/projective_source_degree12_primitive_chart/analyze_relative.py
python3 tmp/schur_ternary_planes/verify.py
python3 tmp/schur_ternary_planes/one_primitive/verify.py
python3 tmp/d12_solver_strategy/verify.py
python3 tmp/step4_degree12_solver_terminal/verify_terminal.py
python3 tmp/structural_degree13/verify.py
python3 tmp/degree13_step2/verify_certificate.py
python3 tmp/degree13_opt/verify_q67_terminal.py
python3 tmp/degree11_feasibility/audit.py
python3 tmp/degree14_feasibility/audit.py
python3 tmp/degree14_structural/verify.py
python3 tmp/xcd_invariant_field/presentation_audit.py
python3 tmp/xcd_invariant_field/f10_probe/verify.py
python3 tmp/xcd_descent_algebra/verify_xcd.py
python3 tmp/xcd_descent_math/verify_fiber_flex_algebra.py
python3 tmp/xcd_descent_math/verify_hesse_norms.py
PYTHONPATH=tmp/xcd_genuine_descent python3 tmp/xcd_genuine_descent/verify.py
python3 tmp/xcd_nonzero_kummer/verify.py
python3 tmp/xcd_magma_rank_audit/verify_audit.py
python3 tmp/xcd_low_height/verify.py
```

The terminal degree-thirteen verifier checks the completed output, input and
output hashes, and the pure-power Artinianness certificate.
