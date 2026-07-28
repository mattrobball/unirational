# Problem E — resolution status and proved boundary

## Verdict

**OPEN.** No unconditional affirmative or negative answer is proved here.
As checked on 2026-07-28, the author version of
Cheltsov–Tschinkel–Zhang dated 2026-07-18 still explicitly lists the
\(\operatorname{PSL}_2(\mathbf F_{11})\)-action on the Klein cubic among the
two open Klein-cubic cases (Theorem 5.1 and the discussion on printed page
23).

What is proved below is an exact reduction to the remaining essential-
dimension dichotomy, an explicit generic-twist presentation, and a certified
bounded covariant exclusion. None of the bounded computations is a negative
solution.

Artifact scope matters when replaying the ledger: the tracked
`certificates/` directory is the portable verification subset. The approximately 6.1 GB
`tmp/` tree containing newer solver outputs and intermediate matrices is
intentionally ignored, so `tmp/...` citations below are local provenance
pointers rather than remotely published files.

## 2026-07-28 exact advances

The headline remains open, but the proof boundary is now sharper in six
places.

1. The homogeneous landing-covariant exclusion extends through degree
   **15**.  The degree-15 proof uses the exact quotient
   \(M_{15}/fM_{12}\), complete rank-75 landing equations inside the
   independently verified 76-dimensional ambient invariant quotient, twelve
   unit normal charts, and two Artinian lift branches.  See
   `tmp/degree15_structural/REPORT.md`.
2. In degree 12, the mixed Jacobian-zero incidence is empty over a nonempty
   open subset of its primitive \(\mathbf P^3\), in characteristic 67 and
   characteristic zero.  Any survivor lies on a proper closed exceptional
   locus.  With \(A=\mathbf F_{67}[p_1,p_2,p_3]\), the retained degree-seven
   border map \(A^{65,611}\to A^{50,388}\) is only a truncation, not a presentation of
   that locus: specialized unit membership does not automatically lift to a
   relative annihilator.  Its parameter-independent degree-five block has a
   certified \(721\times721\) minor of determinant \(18\bmod67\).  The fixed
   top ideal has Hilbert function
   `[1,12,78,364,1365,3647,3726,0,0]`, colength `9,193`, and a fully audited
   15,283,769-term reduced Groebner basis.  This proves finite top control,
   not full degree-12 emptiness or an explicit exceptional equation.  A
   checked determinant lemma shows that a right inverse for the
   `31,824 x 56,238` degree-seven top map plus any degree-at-most-two
   multiplier whose rank-18,564 reduced multiplication operator is invertible
   at the sample point produces a determinant killing the full relative
   quotient over \(\mathbf F_{67}\).  A characteristic-zero determinant would
   additionally require lifting the pivot minors and replaying the solves over
   an integral or number-field model.  A length-65,611 specialized unit vector guarantees such a
   multiplier, but a sparse one may suffice.  The required right inverse and
   full-rank operator have not been certified.  The survivor-only,
   ancestor-pruned replay now completes under the `768 MiB` trace-allocation
   gate: `55,966` roots, `45,751,159` committed operations, `479,691,384`
   discarded zero-row operations, and `372,506,624` allocated bytes.  The
   corrected trace maps every sorted and normalized leaf back to the original
   721 generators.  Structural replay passes.  An exact semantic evaluator
   checks all 721 degree-five final rows coefficientwise in 4,368 ambient
   monomials: all 2,882 selected roots and 474,949 trace operations replay
   with zero mismatches at a planned live footprint of 19,111,096 bytes.  One
   complete cross-round degree-seven row with 48,255 nonzero transform entries
   independently multiplies the original forms to exactly `d11^7`.  A compact
   verified division plan covers
   all 31,824 degree-seven targets using 8,181 basis rows and 72,484,088 lower-
   tail edges.  It makes a right-inverse circuit constructible, but the
   selected degree-six and remaining degree-seven roots still need
   coefficientwise semantic comparison with the retained basis; no full right
   inverse or `M7 R = I` check has been emitted.
   Dense expansion is rejected (`782,526,535` live bytes before overhead and
   about `1.59e12` scalar updates).  The exact next gate is to extend the
   ambient-polynomial semantic verifier from the completed 721 degree-five
   rows to the remaining 7,846 degree-six/seven rows.  The audited all-row
   plan uses `478,080,096` peak bytes and about `1.05e12` updates.  Everything remains over `F_67`.  See
   `tmp/relative_kls_chart/REPORT.md`,
   `tmp/relative_kls_chart/TOP_IDEAL_REPORT.md`, and
   `tmp/relative_kls_chart/DEGREE_LOWERING_DETERMINANT.md`; the extraction
   measurement is in `tmp/relative_kls_chart/TRANSFORM_EXTRACTION_GATE.md`;
   the completed trace and its strict evaluator boundary are in
   `tmp/relative_kls_chart/survivor_trace/REPORT.md`,
   `tmp/relative_kls_chart/survivor_trace/evaluator/REPORT.md`, and
   `tmp/relative_kls_chart/survivor_trace/semantic_check/REPORT.md`.
   The separate `p3=0` hyperplane cover produced three exact degree-seven
   timeouts (14, 13, and 12 variables), and a deterministic
   coordinate-nondegenerate projective line has the same first-round size
   profile, so no direct dimension test is being extended.  The line was not
   proved generic relative to the unknown exceptional image.  This proves no
   hyperplane emptiness, finite projection, or
   exceptional-image dimension bound.  See
   `tmp/relative_kls_hyperplane/REPORT.md` and `LINE_PILOT.md` there.
3. For the exact flat connection, the horizontal determinant has only the
   frame and trace-branch polar divisors away from \(t_3=0\):
   \[
   N(\det A)=\frac{2^{10}3^8 11^{12}}{5^4t_3^{24}}D\Delta.
   \]
   The two simple residue spectra are computed.  Their general leading
   systems are rational determinant hypersurfaces of dimensions 19 and 24,
   so neither is a local obstruction.  Beyond 140 one-parameter families,
   all 60 smallest constant simultaneous `P2` modifications are excluded.
   The full constant-coefficient `P4` is empty, upgrading the former 121-point
   sample, and the simultaneous constant centralizer is exactly scalar.  A
   complete two-fibre screen also excludes all 720 projective families in
   which one coefficient in those three-section planes has one affine slope
   in one base coordinate.  A stronger complete screen excludes all 240 `P5`
   families in which the three coefficients have independent slopes in one
   common base-coordinate direction.  One canonical `P8` family with two
   base directions and three regular fibres is completely projectively empty
   as well.  This sequence is not exhaustive: the local determinant
   hypersurface has dimension 19, while the full first-jet space with fixed
   three-coordinate support has dimension at most 10.  The first
   full-support `P9` chart reached the 700 MiB stop without a verdict.  A
   negative theorem now needs global foliation or bounded-pole control.
   See `tmp/kls_divisor_ansatz/REPORT.md`,
   `tmp/kls_residue_next/REPORT.md`, and
   `tmp/kls_first_jet_two_fiber/REPORT.md` and `REPORT_P5.md`,
   `tmp/kls_first_jet_three_fiber/REPORT.md`, and
   `tmp/kls_structural_audit/REPORT.md`.
4. On the soluble characteristic-23 `xCD` control, the point
   \(Q=[H-3O]\), the irreducible degree-eight nonzero \(E[3]\) field, and the
   genuine nonzero Kummer representative \(G(Q)\) are explicit.  The
   translation-matrix interpolation remains a strict timeout.  On the
   generic characteristic-zero side, replay-locked DAGs now install the
   monic degree-nine flex eliminant, its first subresultants and inverse, the
   universal rank-nine flex point, and all 81 coordinates of the diagonal
   idempotent.  A typed nested-etale-algebra circuit executes the
   off-diagonal tangent inverse and constructs the actual Cech `X,Y`
   coordinates; exact rank-81 replay checks the short curve, 3-division,
   diagonal, and factor-swap identities without a splitting field.  The
   outputs are typed whole-`K_proj` algebra nodes rather than distributed
   Hironaka vectors.  The raw determinant ratio is exactly not in the
   rank-nine group algebra (rank `108`, augmented rank `109`).  Dividing the
   projective translation lift by the unit scalar cochain `ell(M0)` corrects
   it: the generic descent lemma and an exact selected `9 x 9` solve produce
   a generic-open rational representative
   `alpha_R=det(M0)/ell(M0)^3` modulo cubes.  The geometric lemma, not the one
   finite-field membership sheet, proves generic descent; the full-81 replay
   corroborates it.  Cubic scaling and orientation agree, while
   `alpha_R(O)=71^-3` is a cube rather than literally one.  The affine unit
   chart for `G(P)=alpha_R*z^3` is now assembled exactly.  After
   fixing `z_O=71`, it has ten variables and nine cubics over `K_proj,QQ`,
   with `Norm_R8(z_star)!=0`.  Its `3^8` sheets split geometrically into
   `3^6=729` degree-nine 3-covering components, so geometric nonemptiness is
   automatic and irrelevant.  The CFOSS distinguished base-defined component
   is \(K_{\mathrm{proj},\mathbf C}\)-isomorphic as a covering to the original explicit
   projective `xCD` plane cubic; it need not be literally the same embedded
   component.  Thus the direct arithmetic target is that existing plane
   cubic, not extraction or projective closure of the raw 729-component
   union.  A `K_proj,QQ` point suffices positively after scalar extension,
   but a negative result must hold over
   \(K_{\mathrm{proj},\mathbf C}=K_{\mathrm{proj},\mathbf Q}
   \otimes_{\mathbf Q}\mathbf C\); arithmetic primes and a `QQ`-only Selmer
   result are insufficient.  The exact gauge `q=f6/f5` proves that every
   prime component of `A=0`, `B=0`, and `C=0` has a smooth coordinate residue
   point, so those three divisor families cannot obstruct.  A full-degree
   squarefree `F_23` line restriction now proves that the degree-120
   discriminant is geometrically squarefree in characteristic zero and
   coprime to `f5*f6`.  The normalized discriminant has valuation one at every
   component on the normal quotient.  Poonen--Stoll's 2026-06-30 theorem then
   gives one residue-rational nondegenerate node, so projection and Hensel
   lifting give a local point at every discriminant component.  This closes
   the discriminant as a negative local route, not the `xCD` point problem or
   the headline.  The two motivated smooth-reduction primes `f5=0` and
   `f6=0` are geometrically integral and admit alternate unit gauges.  Their
   three coordinate vertices and every complete invariant-polynomial
   `x,C,D` ansatz of total source degree at most 15 are empty.  This is only a
   height lower bound: their residue 3-descents and relative unramified
   descent remain open.
   See
   `tmp/xcd_control_next/REPORT.md`,
   `tmp/xcd_generic_cech_next/REPORT.md`,
   `tmp/xcd_first_descent_next/REPORT.md`,
   `tmp/xcd_arithmetic_next/REPORT.md`,
   `tmp/xcd_discriminant_divisor/REPORT.md`, and
   `tmp/xcd_gauge_divisors/REPORT.md`.
5. The July 2026 level-11 theta/Schwarz construction is exactly identified
   with the correct projective representation, but
   \(F(H\Phi_{11})=\xi_{44}^5u^{11}+O(u^{99})\ne0\), and all 25 classical
   Hessian-minor tests are nonzero.  This particular recent modular lead is
   therefore closed.  See `tmp/theta11_test/REPORT.md`.
6. Degree 16 is not excluded, but its complete landing system is reduced to
   a finite-over-`P3` relative incidence.  The quotient dimension is 20 and landing rank
   is 93.  The pure-normal ideal is Artinian of length `6,169`, giving finite
   projection to the scalar `P3`; the scalar locus has a common
   nine-dimensional tangent kernel, and that full straight slice is empty by
   a weighted cokernel of length `713`.  The weighted-projective second-order
   lifting incidence is empty, so no nonzero normal tangent direction admits
   a second-order lift.  The global rank-15 shortcut is exactly refuted: the `93 x 15`
   matrix has rank five on the tangent-kernel `P8`, although that kernel does
   not meet the required `y=(Sym^2(s),s,1)` locus.  The remaining exact
   question is the constrained Veronese-affine residual incidence.  Off
   `P8`, the quotient subspace depends only on `P(im T)=P6`, but the projected
   `Q(n),C(n)` retain all nine kernel coordinates; the honest base is the
   blowup of `P15` along `P8`, not `P6`.  Clearing the quotient and Veronese
   recovery gives 93 equations of degrees 12 and 13 in 19 variables, so this
   is not a smaller solve.  The first relative image equation is now exact in
   characteristic 67.  A normal linear form
   `L=(1,38,20,6,8,2,25,56,9,25,34,21,38,12,54,64)` annihilates the common
   kernel, and a fixed combination of the 93 original cubics is exactly
   `59*L^3`.  Thus every residual special-fibre point lies above
   `t0+38*t1+20*t2+6*t3+8*t4+2*t5+25*t6=0` in `P6`.  The generic row rank
   on this hyperplane is 91.  All 264 retained full-fibre solves there are
   unit ideals, but they are finite tests; the first complete 18-variable
   hyperplane chart reached the 700 MiB watchdog without output in both
   four-thread and one-thread runs.  The deeper hyperplane support and any
   characteristic-zero lift of this equation remain open.  See
   `tmp/degree16_landing_probe/REPORT.md` and
   `tmp/degree16_exceptional_search/REPORT.md`.

## Exact reduction to essential dimension

Let

\[
G=\operatorname{PSL}_2(\mathbf F_{11}),
\]

let \(C\) be the Klein cubic with its faithful five-dimensional action, and
let \(F_{14}\) be the associated genus-eight Fano threefold.

### Theorem

The following are equivalent:

1. \(C\) is \(G\)-unirational;
2. \(\operatorname{ed}_{\mathbf C}(G)=3\).

Since \(3\leq \operatorname{ed}_{\mathbf C}(G)\leq4\), it follows as well
that

\[
C\text{ is not }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=4.
\]

### Proof

Suppose first that \(C\) is \(G\)-unirational. A dominant equivariant map
from a representation to the faithful threefold \(C\) is a three-dimensional
compression. Hence \(\operatorname{ed}(G)\leq3\), and the known lower bound
gives equality.

Conversely, assume \(\operatorname{ed}(G)=3\). Duncan–Reichstein Remark 2.6
gives a faithful, generically free, three-dimensional very versal
\(G\)-variety \(Z\). It is dominated by a linear representation. Equivariant
compactification and resolution preserve that dominance and give a smooth
projective unirational, hence rationally connected, model.

Because \(G\) does not embed into \(\operatorname{Cr}_2(\mathbf C)\),
Prokhorov Theorem 1.1 and the equivariant MMP in §4.2 reduce to a Fano–Mori
model; Theorem 1.5 classifies it as
\(G\)-birational to one of the two \(\operatorname{PSL}_2(11)\) models,
namely \(C\) or the Pfaffian \(F_{14}\) of Example 2.9. This identification
may precompose the action by
an automorphism of the abstract group \(G\). That is harmless: very
versality and the all-torsors criterion are unchanged by relabeling \(G\),
and the equivariant bridge below may be precomposed by the same automorphism.
Thus either \(C\) or \(F_{14}\) is very versal.

If it is \(C\), the conclusion follows. Assume that \(F_{14}\) is very
versal. Let \(K/\mathbf C\) be any extension and \(T/K\) any \(G\)-torsor.
Twisting Tschinkel–Zhang Proposition 4.1 gives a \(K\)-birational map

\[
{}^T C\times\mathbf P^2\times S_T
\dashrightarrow
{}^T F_{14}\times\mathbf P^2\times S_T,
\]

where \(S_T\) is the Brauer–Severi twist of the projective five-space coming
from the six-dimensional representation of
\(\operatorname{SL}_2(\mathbf F_{11})\).

Write \(\alpha_T=[S_T]\in\operatorname{Br}(K)\). It is the boundary of
\(T\) for

\[
1\longrightarrow\mu_2\longrightarrow
\operatorname{SL}_2(\mathbf F_{11})\longrightarrow G\longrightarrow1,
\]

so \(\exp(\alpha_T)\mid2\). The associated central simple algebra has degree
six, hence \(\operatorname{ind}(\alpha_T)\mid6\). Index and exponent have
the same prime divisors, so the index is one or two. In the index-two case,
the underlying division algebra has a separable quadratic maximal subfield.
Consequently \(S_T\) splits over a separable extension \(L/K\) of degree at
most two.

Very versality of \(F_{14}\) implies that \({}^T F_{14}\) is
\(K\)-unirational. After base change to \(L\), the right-hand product above
has Zariski-dense \(L\)-points, so one may choose a point in the domain of the
inverse birational map. Projection to the first factor gives

\[
{}^T C(L)\ne\varnothing.
\]

We now use an elementary descent lemma.

> **Quadratic descent for cubics.** Let \(D\subset\mathbf P^n_K\) be a cubic
> hypersurface and let \(L/K\) be separable of degree at most two. If
> \(D(L)\ne\varnothing\), then \(D(K)\ne\varnothing\).

For a quadratic extension, join a point \(P\) to its conjugate. Their line is
defined over \(K\). If it lies in \(D\), it is a \(K\)-line and supplies a
\(K\)-point. Otherwise the conjugate pair accounts for two points in the
degree-three intersection with \(D\), and the residual degree-one subscheme
is a \(K\)-point.

The honest five-dimensional linear representation is crucial here: it makes
\({}^T\mathbf P(W)=\mathbf P({}^T W)\) a split \(\mathbf P^4_K\), so
\({}^T C\) is an ordinary cubic hypersurface in split projective space. The
lemma gives \({}^T C(K)\ne\varnothing\). This holds for every \(T/K\), hence
\(C\) is weakly versal; Duncan–Reichstein Theorems 1.1 and 10.5 make it very
versal, equivalently \(G\)-unirational. This proves the theorem.

### Consequence and limitation

The headline is now exactly the still-open dichotomy

\[
\operatorname{ed}_{\mathbf C}
\bigl(\operatorname{PSL}_2(\mathbf F_{11})\bigr)\in\{3,4\}.
\]

An unconditional proof of the value three settles Problem E positively; an
unconditional proof of the value four settles it negatively. Current
conditional routes point in opposite directions: Cassels–Swinnerton-Dyer or
Duncan–Reichstein Conjecture 8.8 would give three, while Dolgachev's proposed
inequality \(\operatorname{Crdim}(G)\leq\operatorname{ed}(G)\) would give
four. Here \(\operatorname{Crdim}(G)=4\): Prokhorov gives the lower bound and
the faithful action on \(\mathbf P(W)=\mathbf P^4\) gives the upper bound.

## Exact action

Put \(\zeta=\zeta_{11}\) and

\[
\gamma=
\sum_{a\in\{1,3,4,5,9\}}\zeta^a-
\sum_{a\in\{2,6,7,8,10\}}\zeta^a,
\qquad \gamma^2=-11.
\]

Let

\[
(j_0,\ldots,j_4)=(1,3,2,5,4),
\qquad
(\epsilon_0,\ldots,\epsilon_4)=(1,1,-1,1,1).
\]

Exact generators on coordinate columns are

\[
T_{ik}=\delta_{ik}\zeta^{j_i^2},
\qquad
S_{ik}=\frac{\epsilon_k}{\epsilon_i}
       \frac{\zeta^{9j_i j_k}-\zeta^{-9j_i j_k}}{\gamma}.
\]

The certificate checks in \(\mathbf Q(\zeta_{11})\) that

\[
S^2=T^{11}=(ST)^3=1,
\]

traverses the complete 660-element Cayley graph of
\(\operatorname{PSL}_2(\mathbf F_{11})\), and verifies

\[
F(Sx)=F(Tx)=F(x),
\qquad
F(x)=\sum_{i\in\mathbf Z/5}x_i^2x_{i+1}.
\]

This is an exact faithful honest linear action, not a projective action of the
double cover.

## Explicit generic-twist frame

Let \(x,C,D,E,K:W\to W\) be the primitive covariants of degrees
\(1,4,5,6,7\) constructed and checked in `certificates/`. Their determinant

\[
\Delta(x)=\det[x,C,D,E,K]
\]

is a degree-23 invariant. The exact integer witness

\[
x=(-2,-2,-2,-2,-1),
\qquad
\Delta(x)=-295136920
\]

proves that it is not the zero polynomial.

Let \(L=\mathbf C(W)\) and \(K_0=L^G\). At the generic point, each covariant
is a semilinear invariant vector and hence descends to the twisted vector
space \({}^{T_{\rm gen}}W\). Since \(\Delta\in K_0^\times\), the matrix

\[
M=[x\ C\ D\ E\ K]
\]

is an explicit Hilbert-90 trivialization: its columns descend to a
\(K_0\)-basis. In coordinates \(a=(a_0,\ldots,a_4)\), the generic twisted
Klein cubic is therefore

\[
\Phi(a)=F(Ma)=0,
\qquad
\Phi\in K_0[a_0,\ldots,a_4].
\]

This completes the generic ambient-space descent explicitly. It does **not**
produce a nonzero \(a\in K_0^5\) with \(\Phi(a)=0\); that is precisely the
remaining generic-twist point problem.

The field can be reduced by one transcendence degree. Put

\[
K_{\mathrm{proj}}=\mathbf C(\mathbf P(W))^G.
\]

The affine generic torsor is the base change of the projective generic torsor
and \(K_0\simeq K_{\mathrm{proj}}(u)\). Since the twisted cubic is proper, a
point over the purely transcendental extension specializes to a
\(K_{\mathrm{proj}}\)-point. Thus the generic point problem is already over a
transcendence-degree-four field. Tsen--Lang makes this a \(C_4\)-field, but
the automatic cubic-form bound requires more than \(3^4=81\) variables, not
the five variables available here.

Let \(T_{\mathrm{proj}}\) be the generic torsor of the free locus of
\(\mathbf P(W)\), and put \(C_{\mathrm{gen}}={}^{T_{\mathrm{proj}}}C\).
Twisting adjunction and the lower bound \(\operatorname{ed}(G)\ge3\) show
that any \(K_{\mathrm{proj}}\)-point gives an automatically dominant rational
map \(\mathbf P(W)\dashrightarrow C\). Hence the remaining dichotomy is the
single exact point problem

\[
\boxed{
\operatorname{ed}(G)=3\iff C_{\mathrm{gen}}(K_{\mathrm{proj}})\ne\varnothing,
\qquad
\operatorname{ed}(G)=4\iff C_{\mathrm{gen}}(K_{\mathrm{proj}})=\varnothing.}
\]

The subgroup-fixed orbit cycles have degrees \(60,132,165,220\) and gcd one,
so every Klein twist has index one.  This is not a point theorem: the missing
implication is precisely the relevant index-one cubic-threefold boundary.
The prime-local essential dimensions are \(2\) at 2 and \(1\) at 3, 5, and
11, while the honestly linearized hyperplane class kills the audited Brauer,
Amitsur, and standard stable-cohomology obstructions.  The full theorem and
obstruction ledger are in `tmp/step4_essential_dimension/REPORT.md`.

### Why homogeneous self-covariants are exhaustive

Searching maps \(W\dashrightarrow C\) loses no generality. If any honest
linear representation \(U\) dominates \(C\) equivariantly, then \(C\) is
very versal, so the generic \(W\)-torsor twist has a \(K_0\)-point. Because
the twisted ambient vector space \({}^{T_{\rm gen}}W\) is split, a vector on
the corresponding \(K_0\)-line lifts this point to a rational
\(W\)-valued covariant \(f\in\mathbf C(W)\otimes W\). Explicitly, if
\(d\in\mathbf C[W]\) clears its coordinate denominators, then

\[
D=\prod_{g\in G}(g\cdot d)\in\mathbf C[W]^G
\]

is divisible by \(d\), so \(Df=(D/d)(df)\) is a polynomial covariant.

Write the resulting nonzero polynomial covariant as
\(f=f_0+\cdots+f_d\) by ordinary degree. Linearity of the action makes every
\(f_i\) a covariant. Since \(F(f)=0\), its top-degree term is
\(F(f_d)=0\). Thus any positive solution from any honest linear source forces
a nonzero **homogeneous self-covariant** \(f_d:W\to W\) landing in \(C\).

Conversely, every such nonzero landing covariant is automatically dominant
here. The closure of its projective image is very versal. Its action has a
normal kernel; the kernel is not all of the simple group \(G\), since
\(C^G=\varnothing\), so it is trivial. The image is therefore a faithful very
versal variety and has dimension at least \(\operatorname{ed}(G)\geq3\).
Since \(\dim C=3\), the image is all of \(C\).

There is one further exact scoped exclusion in these coordinates. For every
unordered pair \(U,V\in\{x,C,D,E,K\}\), the checker forms

\[
F(U+tV)\in\mathbf Z[x_0,\ldots,x_4,t].
\]

All ten polynomials retain \(t\)-degree three after reduction modulo two and
are irreducible over both \(\mathbf F_2\) and \(\mathbf F_8\). This certifies
absolute irreducibility: if an \(\mathbf F_2\)-irreducible cubic in \(t\)
split geometrically, its absolute factors would be a three-element Frobenius
orbit and the splitting would already occur over \(\mathbf F_8\). A
degree-preserving absolutely irreducible reduction is absolutely irreducible
in characteristic zero. Hence none of these ten binary cubics has a root in
\(L=\mathbf C(W)\), and no coordinate line of the frame supplies a
\(K_0\)-point. Any point found in this frame must involve at least three
coordinates. This remains only a coordinate-plane search boundary, not a
point obstruction for \(\Phi\).

### Three-coordinate frame planes

The ten planes spanned by triples from \(x,C,D,E,K\) have also been audited.
At the exact specialization

\[
x=(-1,-1,-1,-1,0),\qquad \det[x,C,D,E,K]=-4400,
\]

each specialized ternary cubic has all ten monomials and its singular ideal
is the unit ideal on every standard projective chart. Consequently every
generic plane section is a smooth geometrically integral genus-one curve.
This rules out a factorization or singular-point parametrization, but
smoothness does not rule out a \(K_0\)-point.

There is a further bounded exclusion. For each triple and each total source
degree \(N=11,12,13,14\), the checker constructs the complete ansatz

\[
A_UU+A_VV+A_WW,\qquad A_Z\in\mathbf C[W]^G_{N-\deg Z}.
\]

It uses the exact invariant Hilbert series and Reynolds averaging at the good
prime \((23,\zeta_{11}-2)\). The selected reductions have the full
characteristic-zero dimensions, and the reduced frame has determinant
\(3\ne0\) at an explicit point. In all 40 triple-degree cases, necessary
landing cubics already generate an ideal whose affine cone has Macaulay2
dimension zero. Projective properness over the cyclotomic DVR therefore
excludes the corresponding characteristic-zero ansätze.

Any \(K_0\)-point in one of these planes can have its invariant rational
coordinates cleared to invariant polynomials; the highest homogeneous part
would be one of these landing ansätze in some total degree. There is no bound
on that degree, so the calculation through fourteen remains a scoped
exclusion. Degree fifteen has no verdict.

There is also an unbounded but narrower flex exclusion. For each of the ten
smooth plane cubics, intersecting with its Hessian gives the degree-nine flex
scheme. An exact specialization to one source line modulo 23 produces a
degree-nine eliminant which remains irreducible over
\(\mathbf F_{23^3}\). Degree preservation, the nonzero infinity resultant,
and good-reduction lifting prove that the generic flex scheme is a single
Galois orbit even over \(\mathbf C(W)\). Thus none of the ten planes has a
\(K_0\)-rational flex. This closes the rational-flex/Hesse-normal-form
shortcut, but not the ordinary point problem: a pointed plane cubic need not
have a rational flex for its chosen degree-three line bundle.

## The `xCD` flex and 3-descent audit

For the plane spanned by the first three frame columns, the ternary cubic

\[
F(ax+bC+cD)=0
\]

is retained exactly in ten coefficient polynomials, with 1,256 terms in
total. Universal integral formulas for the 25-term invariant \(c_4\), the
103-term invariant \(c_6\), and

\[
E:\ y^2=x^3-27c_4x-54c_6
\]

give an exact compositional model of its Jacobian in characteristic zero.

On one certified source line over \(\mathbf F_{23}(s)\), elimination of the
cubic and its Hessian gives a degree-nine flex algebra together with the
missing flex coordinate by a linear subresultant. The flex eliminant remains
irreducible after the cubic constant extension, so its flex-torsor class is
nonzero. Over \(\mathbf F_{23}(s)\) this is an exact primitive-element
presentation; serialization of the full multiplication table stalled during
denominator inversion. The only completed \(9\)-by-\(9\) multiplication,
trace, norm, and tangent packet is the \(s=1\) control fiber, where the algebra
factors as \(1+8\) and the rational flex \([9:16:1]\) makes that fiber's class
trivial. It is not evidence for generic Kummer membership. The line model is
nevertheless everywhere locally soluble: all
finite bad fibers are transverse geometrically integral nodal cubics, and
infinity is good. At \(s=1\), the Jacobian has 28 points, proving that its
function-field Mordell--Weil group has no 3-torsion. Thus a genuine rank-zero
certificate would prove that this one plane cubic has no
\(\mathbf F_{23}(s)\)-point. The public L-function run timed out after its
setup marker, and the independent 2-Selmer submission returned HTTP 504, so
both are strict nonverdicts.

An exhaustive bounded line search found a lower-height prototype

\[
x=e_0+s(1,1,1,1,1)
\]

whose expected L-polynomial degree is 86 instead of 116. Its degree-nine flex
class is still nonzero and a good fiber again excludes 3-torsion. Frozen
L-function and 2-Selmer inputs exist but have not been run. Even a completed
rank-zero calculation would concern only this characteristic-23,
codimension-four specialization; no theorem currently transfers it to the
generic characteristic-zero plane.

A separate low-height coordinate-line plane over \(\mathbf F_{23}(t)\) has
the rational point \(O=[1:0:1]\), while its degree-nine flex eliminant remains
one exponent-one factor over the cubic constant extension.  Hence this
distinct flex torsor is nonzero but abstractly Kummer:

\[
\operatorname{Flex}(C)=[3]^{-1}(Q),\qquad Q=[H-3O],
\]

where \(H\) is a hyperplane section.

This is a positive control for the cohomological statement, not an explicit
generic descent computation.  The tangent residual gives exact coordinates
for \(Q\) on the saved short Weierstrass Jacobian.  The irreducible
degree-eight nonzero \(E[3]\) field and the values \(G_T(Q)\) are serialized,
and exact replay verifies that they form the genuine nonzero first-Kummer
representative of \(\delta(Q)\).  Independent translation interpolation
timed out before producing a matrix or determinant, but is not needed for
this verification.  No theorem transfers the characteristic-23
function-field control to the generic characteristic-zero plane.  See
`tmp/xcd_nonzero_kummer/REPORT.md` and
`tmp/xcd_control_next/REPORT.md`.

The implementation audit also separates genuine from fake descent. If
\(F_{\rm flex}\) is the coordinate algebra of the nine flexes, tangent forms
give only the fake map to

\[
F_{\rm flex}^{\times}/K^{\times}F_{\rm flex}^{\times3}.
\]

The genuine first-Kummer equation instead uses the distinct algebra

\[
\mathcal R=\operatorname{Map}_{K_{\rm proj}}
  (E[3],\overline K_{\rm proj})
\]

together with a representative \(\alpha_{\mathcal R}\) and normalized functions
\(G_T\).  This algebra is now installed generically over the projective
invariant field as

\[
K_{\rm proj}\times
K_{\rm proj}[x,y]/(\psi_3(x),y^2-x^3-Ax-B),
\]

with exact group, difference, and normalized Kummer-function formulas.  The
determinant-free circuit is implemented for the rank-nine flex algebra \(F\),
its universal flex \(P\), and

\[
c_{12}=P_2-P_1\in E[3](F\otimes_KF).
\]

It has passed its structural checks: the triple-overlap identity
\(c_{13}=c_{12}+c_{23}\) holds, and the circuit induces a rank-81 isomorphism
\(F\otimes_K\mathcal R\simeq F\otimes_KF\) on a certified generic open.
Replay-locked `K_proj` DAGs now contain the monic degree-nine flex
eliminant, its first subresultants and inverse, the universal flex point, and
all 81 coordinates of the divided-difference diagonal idempotent.  The
typed nested-etale circuit also executes

\[
\lambda^\#=(\lambda+e_\Delta)^{-1}(1-e_\Delta),
\]

and the saved short-Weierstrass `X,Y` formulas.  Exact replay checks the curve,
3-torsion, diagonal, and factor-swap identities.  The raw determinant ratio
does not descend to \(\mathcal R\) (coefficient rank `108`, augmented rank
`109`).  Dividing the projective translation lift \(M_0\) by the generically
invertible scalar cochain \(c=\ell(M_0)\) corrects it: the geometric descent
lemma gives the generic-open rational representative
\(\alpha_{\mathcal R}=\det(M_0)/c^3\) modulo cubes.  The retained `GF(101)`
all-coordinate computation is a replay check, not the proof of generic
descent.  The saved representative retains the identity coefficient
`71^-3` and fixes `z_O=71`; the equivalent cube-normalized gauge instead has
identity coefficient one and `z_O=1`.  The exact remaining first-descent
boundary is a `K_proj,C` point or scoped nonmembership result on the original
projective `xCD` cubic, equivalently on the distinguished base-defined
component of `G(P)=alpha_R*z^3`.  The saved ten-variable affine unit chart is
over the exact `QQ`-model and has 729 geometric degree-nine components; the
raw union is provenance, not the smallest arithmetic target.  A negative
result over `QQ` or at an arithmetic prime is insufficient after extending
constants to `C`.  The pure-coefficient divisors `A=0`, `B=0`, and `C=0` are
locally soluble.  The geometric degree-120 discriminant divisor is now closed
as a local-obstruction route too: it is geometrically squarefree and
gauge-coprime, and every normalized component has discriminant valuation one,
so Poonen--Stoll gives a residue-rational node and hence a local point.  At
the smooth-reduction primes `f5=0` and `f6=0`, alternate gauges are integral
and all invariant-polynomial residue points through total degree 15 are
excluded, without proving a local obstruction.  The remaining negative
boundary is their residue 3-descent or relative unramified 3-descent.
A true second 3-descent then needs the degree-twelve algebra of the twelve
lines through triples of flexes, its line
forms, and the fixed curve constants.
See `tmp/xcd_generic_cech_next/REPORT.md`,
`tmp/xcd_first_descent_next/REPORT.md`,
`tmp/xcd_arithmetic_next/REPORT.md`,
`tmp/xcd_discriminant_divisor/REPORT.md`, and
`tmp/xcd_gauge_divisors/REPORT.md`.

Honest arithmetic in the projective invariant field is now complete. Exact
primitive integral invariants of degrees 10, 11, 12, and 14 are installed.
Their constructions are

\[
\langle df_5,E\rangle,\quad
\tfrac12\langle df_7,D\rangle,\quad F(C),\quad
\langle df_8,K\rangle,
\]

and exact indecomposable-rank and invariance certificates are in
`tmp/xcd_invariant_field/f10_probe/REPORT.md`.  The primaries
\(f_3,f_5,f_6,f_8,f_{11}\) are certified algebraically independent; Adler's
twelve secondaries form a certified free Hironaka basis; the complete
12-by-12 multiplication table is checked; and normalization by
\(\tau=f_3^2/f_5\) gives a degree-twelve model over a rational four-variable
field with exact addition, inversion, trace, and norm.

All ten generic `xCD` coefficients, and the universal \(c_4,c_6,\Delta\),
have been evaluated exactly in this model.  At the independent \(s=1\)
control fiber, the genuine \(E[3]\) algebra, distinct flex torsor, and true
three-flex-line algebra with Frobenius orbit degrees `4+8` satisfy all group,
incidence, norm, and Frobenius identities.  Its rational flex makes the class
trivial, so it does not validate a nonzero generic
\(\alpha_{\mathcal R}\).  The generic twisted line algebra, line forms, and
constants also remain open.  See
`tmp/kproj_arithmetic/REPORT.md`, `tmp/xcd_genuine_descent/REPORT.md`, and
`tmp/xcd_descent_math/REPORT.md`.  The separate nonzero-Kummer control above
is the exact conventions check in `tmp/xcd_control_next/REPORT.md`; it is not
a specialization of the generic characteristic-zero torsor.

## Certified covariant exclusion through degree 15

The exact Molien calculation gives

\[
\dim\operatorname{Hom}_G(\operatorname{Sym}^d W,W)
=0,1,0,0,2,1,2,4,5,6,10,12,16,21,26
\]

for \(d=0,\ldots,14\). Characteristic-zero formulas and rational Gröbner
bases exclude every homogeneous self-covariant landing in \(C\) through
degree seven.

Independent good-reduction certificates extend this through degree twelve.
They reduce the same cyclotomic matrices at
\((23,\zeta_{11}-2)\). Since \(23\nmid660\), the Reynolds idempotent is
integral and formation of covariants commutes with base change. In every
degree, the script constructs as many independent Reynolds covariants as the
exact characteristic-zero Molien multiplicity, hence a full reduced basis.

For degrees seven through nine, exact Gröbner bases on every projective
coefficient chart give the unit ideal. In degree ten, the covariant space has
dimension ten and sampled evaluations give 80 independent necessary cubic
landing equations in ten coefficient variables. Macaulay2 computes

```text
generators=80
dimension=0
hilbertFunction[3]=140
hilbertFunction[4]=6
hilbertFunction[5]=0
```

In degree eleven, the complete reduced covariant space has dimension twelve.
Fresh reconstruction gives 108 independent sampled necessary cubic landing
equations, and a second Macaulay2 calculation gives

```text
basisRank=12
generators=108
dimension=0
hilbertFunction[4]=76
hilbertFunction[5]=0
```

In degree twelve, the complete reduced covariant space has dimension sixteen.
Fresh direct-Weil reconstruction gives 143 independent sampled necessary
landing equations in sixteen coefficient variables. The exact finite-field
solver
`msolve` computes a homogeneous Gröbner basis with 3840 leading monomials,
distributed by degree as

```text
degree 3: 143
degree 4: 813
degree 5: 2884
```

Independent monomial-ideal enumeration gives the quotient Hilbert function

```text
1, 16, 136, 673, 1589, 0
```

in degrees zero through five. Thus the leading ideal contains every
degree-five monomial and the projective landing locus is empty.

Because the ideal is homogeneous, dimension zero of its affine cone is
equivalent to emptiness of its projective zero locus. Properness of projective
coefficient space over the DVR transfers this emptiness back to
characteristic zero.

Degree thirteen is excluded by a separate structural calculation at the
split prime \((67,\zeta_{11}-64)\). Write \(M_d\) for the degree-\(d\)
self-covariants and \(f\) for the source Klein cubic. The quotient

\[
M_{13}/fM_{10}
\]

has dimension \(21-10=11\). Forty-eight sampled necessary landing cubics in
this quotient have geometric support equal to the scalar plane
\(\mathbf P(R_{12}/fR_9)\simeq\mathbf P^2\). This support statement is
certified by eight expanded Rabinowitsch unit-ideal calculations;
completeness of the sampled equations is not needed because every genuine
landing class satisfies them.

Thus a landing covariant can be written \(q=rx+fh\). Polarizing \(f\) gives
\(f(x+th)=f+A_ht+B_ht^2+f(h)t^3\), and reduction of \(f(q)=0\) modulo the
geometrically integral source cubic gives \(r^2(r+A_h)=0\). If \(f\mid r\),
then \(q=fh'\) for a degree-ten landing covariant; 80 necessary cubics have
leading-ideal Hilbert function \([1,10,55,140,6,0]\). Otherwise the gauge
\((r,h)\mapsto(r-fu,h+ux)\) puts

\[
q=T(h)=fh-A_hx.
\]

The map \(T\) is injective, and 104 necessary tangent-landing cubics have
leading-ideal Hilbert function \([1,10,55,116,3,0]\). Both projective
branches are therefore empty. Proper specialization of the original
projective landing locus transfers this empty special fiber to
characteristic zero. Full details and the replay checker are in
`tmp/structural_degree13/REPORT.md`.

An independent direct calculation on the full 21-dimensional coefficient
space reaches the same bounded conclusion. At the same split prime 67, 202
necessary landing cubics have a completed exact Gröbner basis with 21,674
leading monomials. The hash-verified leading ideal contains a pure power of
every coefficient variable (with exponents between 3 and 7), hence is
Artinian. The run completed with return code zero after 7,458.060 seconds;
its verifier and strict provenance are in `tmp/degree13_opt/REPORT.md`. The
earlier partial F4 basis by itself remains a noncertificate.

Degree fourteen is excluded by the structural successor at the same split
prime 67. Exact dimensions give

\[
\dim M_{14}=26,\qquad \dim M_{11}=12,\qquad
\dim(M_{14}/fM_{11})=14.
\]

The quotient landing equations have rank 64, equal to the exact ambient
bound \(\dim(R_{42}/fR_{39})=64\). Scalar classes form the two-dimensional
subspace \(R_{13}/fR_{10}\). Twelve independent normal forms cut out this
subspace, and all twelve corresponding Rabinowitsch systems are unit ideals.
Thus every landing lift has the form \(q=rx+fh\).

Reduction modulo the geometrically integral source cubic gives the same two
branches as in degree thirteen. The branch \(f\mid r\) reduces to a
degree-eleven landing covariant; its 111 necessary cubics have 711 leading
monomials and Hilbert function

```text
[1,12,78,253,76,0].
```

In the other branch the gauge normalizes the lift to
\(T(h)=fh-A_hx\). This map is injective, and 131 necessary residual cubics
have 642 leading monomials and Hilbert function

```text
[1,12,78,233,34,0].
```

Both branch ideals are Artinian. A verifier reconstructs the quotient and
both branch row spaces, rematerializes every solver input, checks the twelve
unit outputs, and recomputes both Hilbert functions. Projective properness
transfers the empty special fiber to characteristic zero. Full details are
in `tmp/degree14_structural/REPORT.md`.

Degree fifteen is excluded by the next structural calculation at the same
split prime 67.  Exact dimensions give

\[
\dim M_{15}=32,\qquad \dim M_{12}=16,\qquad
\dim(M_{15}/fM_{12})=16.
\]

The quotient landing-coefficient image has exact rank 75.  Completeness here
does not come from assuming the ambient bound is attained: an explicit
76-element Hironaka basis of \(R_{45}/fR_{42}\) has evaluation rank 76 on the
same source points, and the landing rows on those unisolvent points still
have rank 75.  Scalar quotient classes form the four-dimensional space
\(R_{14}/fR_{11}\).  Twelve independent normal linear forms cut out this
space, and every homogeneous affine chart \(\ell_i=1\) has literal `msolve`
output `[-1]:`.  Thus the geometric support of the complete quotient landing
ideal is exactly the scalar \(\mathbf P^3\).

Writing a lift as \(q=rx+fh\) again yields
\(r^2(r+A_h)=0\bmod f\).  In the \(f\mid r\) branch, 153 necessary
degree-12 landing cubics have 3,528 leading monomials and Hilbert function

```text
[1,16,136,663,1453,0].
```

In the normalized branch \(q=T(h)=fh-A_hx\), 198 necessary residual cubics
have 2,346 leading monomials and Hilbert function

```text
[1,16,136,618,771,0].
```

Both leading ideals contain a pure power of every coefficient variable and
are Artinian.  A single verifier reconstructs the quotient and ambient
unisolvence ranks, all twelve chart inputs and outputs, both branch row
spaces, and both Hilbert functions.  The degree-15 projective landing scheme
therefore has empty special fiber, and properness transfers emptiness to
characteristic zero.  Full details are in
`tmp/degree15_structural/REPORT.md`.

Consequently:

> No nonzero homogeneous polynomial \(G\)-covariant \(W\to W\) of degree at
> most **15** has image contained in the Klein cubic.

The degree-16 successor is not decided, but its complete quotient has now
been put in scalar/normal coordinates.  The 93 complete landing cubics have
bidegree ranks `0,66,77,93`.  Their pure-normal cubic ideal is Artinian of
length `6,169`, so the full degree-16 scheme projects finitely to the scalar
`P3`.  Its linear normal part has constant rank seven with a common
nine-dimensional kernel, and the restriction to that kernel is empty by an
exact weighted cokernel of length `713`.  The weighted-projective
second-order lifting incidence is empty as well: no nonzero normal tangent
direction admits a second-order lift.  The old global rank-15 target is
false: the `93 x 15` matrix has rank exactly five on the kernel `P8`, so its
weighted cokernel necessarily has positive-dimensional support.  This does
not give a landing point because the matrix kernel misses the constrained
`y=(Sym^2(s),s,1)` locus there.  The actual residual problem is this
Veronese-affine incidence on the blowup of `P15` along `P8`.  Although the
injective ten-column block defines an `83 x 5` quotient matrix whose quotient
subspace is controlled by `P6`, the projected `Q(n),C(n)` still vary in all
nine kernel coordinates.  The cleared quotient plus Veronese equations are
93 equations of degrees 12 and 13 in 19 variables, so they do not reduce the
original cubic solve.  The absence of nonzero second-order lifts instead suggests splitting
or saturating away the scalar component first.  A complete 13-variable fiber
at `t=[1,2,30,32,60,2,48]` has a saved 93-row combination equal to one, so
the residual image is already known to be a proper closed subset of `P6`.
The next relative calculation should target that exceptional image rather
than sample more isolated directions.  See
`tmp/degree16_landing_probe/REPORT.md`.

This is a bounded exclusion only. Clearing denominators of a rational
equivariant map gives a polynomial covariant, but there is no degree bound;
therefore this calculation supplies no negative answer. The next unrestricted
homogeneous degree is sixteen. The earlier interrupted partial-basis package
is retained only as a diagnostic: its exact partial leading ideal leaves 26
standard monomials in degrees six and seven and, by itself, proves no
emptiness statement (`tmp/degree13_step2/REPORT.md`).

## Six-dimensional projective-source route

Let

\[
1\longrightarrow\mu _2\longrightarrow
\widetilde G=\operatorname{SL}_2(\mathbf F_{11})
\longrightarrow G\longrightarrow1
\]

and let \(V_6\) be the six-dimensional Schur representation. Its central
involution acts as \(-1\), while it acts trivially on the Klein module \(W\).
Thus \(\mathbf P(V_6)\) carries an honest projective \(G\)-action, and every
homogeneous \(\widetilde G\)-covariant \(V_6\to W\) has even degree.

### Projective-source lemma

If there is any rational \(G\)-equivariant map

\[
\mathbf P(V_6)\dashrightarrow C,
\]

then it is dominant and \(C\) is \(G\)-unirational.

Indeed, the map cannot be constant because \(C^G=\varnothing\). The kernel
on the closure of its image is normal and hence, by simplicity, trivial. A
proper image would be a faithful unirational curve or surface; after taking a
trivial product in the curve case, this contradicts the known exclusion of
faithful \(G\)-actions on rational surfaces. Hence the image is all of the
threefold.

For the all-torsors assertion, twist the source by an arbitrary \(G\)-torsor
\(T/K\). The result is the Brauer--Severi variety of a degree-six central
simple algebra \(A_T\). Its class comes from the displayed central extension,
so \(\exp(A_T)\mid2\); also \(\operatorname{ind}(A_T)\mid6\). Index and
exponent have the same prime divisors, hence the index is one or two and the
source splits over a separable extension \(L/K\) of degree at most two. A
point in the open domain of the twisted map gives \({}^T C(L)\ne\varnothing\).
The honest action on \(W\) puts \({}^T C\) in a split \(\mathbf P^4_K\), so
the line joining a quadratic point to its conjugate supplies the residual
\(K\)-point of the cubic. Thus every twist has a \(K\)-point, proving the
lemma by the twist criterion.

The exact characteristic-zero multiplicities of \(W\) in
\(\operatorname{Sym}^d(V_6^*)\) for even \(d=0,2,\ldots,20\) are

\[
0,0,1,2,11,21,48,85,158,249,408.
\]

Good-reduction calculations at split primes give the following complete
bounded exclusions:

- the unique degree-four covariant does not land;
- the full two-dimensional degree-six constant-coefficient locus is empty;
- the full eleven-dimensional degree-eight locus is empty; and
- the full twenty-one-dimensional degree-ten locus is empty. In degree ten,
  470 independent necessary cubics over \(\mathbf F_{23}\) have a leading
  ideal with 5,516 generators and quotient Hilbert function
  \([1,21,231,1301,889,0]\). It contains every degree-five monomial, so
  projective properness transfers geometric emptiness to characteristic zero.

There is one stronger rational-coefficient result in the complete
degree-six pencil. The primitive cubic \(F(q_0+tq_1)\) is absolutely
irreducible after good reduction: direct factorization over
\(\mathbf F_{23^3}\) leaves one factor of \(t\)-degree three, and an
independent discriminant specialization is nonsquare. Hence the pencil has
no root over \(\mathbf C(V_6)\). This statement does not exclude rational
combinations in the degree-eight or degree-ten spaces.

There is now an exact all-degree normal form for the rational-coefficient
problem. Five explicit degree-eight Reynolds covariants \(q_0,\ldots,q_4\),
divided by a degree-eight invariant \(I_8\), form a basis over

\[
K=\mathbf C(\mathbf P(V_6))^G
\]

of the descended Klein five-space. Thus every rational equivariant
projective-source map has the form

\[
\left[\sum_{i=0}^4 a_iq_i/I_8\right],\qquad a_i\in K,
\]

and landing is exactly the existence of a nonzero \(K\)-point on the
resulting generic twisted Klein cubic. Exact good-reduction factorization
over both \(\mathbf F_{23}(s)\) and \(\mathbf F_{23^3}(s)\) proves that none
of the ten coordinate lines \(Kq_i+Kq_j\) contains such a point. Any solution
in this frame must use at least three coordinates. This support exclusion is
not an exclusion of ternary or larger rational combinations.

There is nevertheless a substantial bounded ternary exclusion.  On each of
the ten coordinate planes, the full invariant-coefficient ansätze in degrees
0, 4, 6, 8, and 10 are projectively empty.  In degree 12 put

\[
S_{12}=f_4R_8+\langle f_6^2\rangle,\qquad
\dim S_{12}=5,\quad \dim(R_{12}/S_{12})=9.
\]

All ten \(S_{12}\) systems and all 90 enlargements
\(S_{12}+\langle p_j\rangle\) have exact Artinian leading ideals at the good
prime 23 and are therefore empty in characteristic zero.  The single tested
two-direction slice \(L(012,S_{12}+\langle p_0,p_1\rangle)\) is also empty.
Its 47.288-second gate projects all 360 such slices to 4.73 hours, beyond the
authorized 20-minute budget, so the other 359 were not run.  Those other
two-direction slices, all combinations of three or more quotient directions, the full
\(R_{12}\), higher coefficient degrees, and unrestricted ternary
\(K\)-points remain open.  See `tmp/schur_ternary_planes/REPORT.md` and
`tmp/schur_ternary_planes/one_primitive/REPORT.md`.

The full degree-twelve constant-coefficient space has dimension 48. Its
decomposable part

\[
D_{12}^{V_6}=R_4M_8+R_6M_6+R_8M_4=(R_+M)_{12}
\]

has exact dimension 16, leaving a 32-dimensional primitive quotient. Exact
leading ideals exclude the complete projective landing locus in \(D_{12}^{V_6}\)
and in each of the 32 spaces \(D_{12}^{V_6}+\langle p_j\rangle\) for one explicit
primitive quotient basis. A separate complete 48-vector Reynolds basis first
gave 1,093 independent necessary cubics on the saved prime-field evaluations.
Restricting those equations to every coordinate support of size at most five
gives full cubic-monomial rank: all 1,925,356 such supports are empty. This
last statement is basis-dependent.

Quadratic-extension evaluation now removes the equation-span ambiguity. The
old base-field points together with 48 deterministic \(\mathbf F_{23^2}\)
points are unisolvent on the full 1,157-dimensional degree-36 invariant
space. The corresponding landing rows have exact rank 1,124, so a retained
1,124-row base-field matrix spans **every** degree-twelve landing coefficient
polynomial in the characteristic-23 fiber. Its 48-variable `msolve` input is
hash-verified. This proves only the complete special-fiber equation rank; it
does not prove projective emptiness, nonemptiness, or equality with the
characteristic-zero equation rank. The earlier 1,093-row Gröbner run timed
out in degree four after 600.67 seconds with an empty leading-output file and
therefore supplies no geometric verdict. The complete 1,124-row run likewise
timed out after 600.591 seconds during its second degree-four matrix
\(39399\mathbin{\times}245608\), with return code \(-15\) and a zero-byte
leading-output file. It also supplies no Gröbner, Hilbert-function, or
geometric verdict.

The complete solve has now been carried to a terminally justified stopping
rule.  All four upstream rank/unisolvence verifiers pass, the two copies of
the 287,747,633-byte input are byte-identical, and its metadata pointer to the
landing certificate has been repaired and hash-checked.  The recorded F4
rounds contain only aggregate timings: no reduced rows, leading monomials,
basis, PBM data, or checkpoint were saved, so they cannot be resumed or used
geometrically.  Exact restriction to every coordinate hyperplane
\(a_i=0\) has rank 1,124 on the 18,424 surviving cubic monomials.  Thus none
of the 48 standard dehomogenizations gains a quadratic or lower equation by
constant row reduction.  Independent 120-second probes on the charts
\(a_0=1\) and \(a_{47}=1\) both stop with empty outputs on the same first
degree-four matrix \(36595\mathbin{\times}244805\) as the homogeneous run.

There is also a rigorous size bound.  If \(I\) is generated by these 1,124
cubics in 48 variables, then

\[
\dim(S/I)_d\geq \dim S_d-1124\dim S_{d-3}.
\]

The resulting lower bounds in degrees zero through six are
\(1,48,1176,18476,195948,1277136,927080\); degree seven is only the first
degree where Hilbert-function vanishing is numerically possible.  This count
does not rule out a lower-degree pure-power leading-ideal certificate, but no
such leading data were emitted.  Consequently no further
characteristic-23 sampling, identical 600-second retry, or sweep of the
remaining standard charts is justified.  Resume only after a certified
coordinate/elimination reduction, a solver that preserves checkable
intermediate data, or a materially larger resource-and-certificate plan.
The exact terminal state and verifier are in
`tmp/step4_degree12_solver_terminal/REPORT.md`.

Degree twelve, all higher degrees, and
general rational maps remain open; the projective-source route is not a
resolution. See
`tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md`,
`tmp/projective_source_degree12_structural/REPORT.md`, and
`tmp/projective_source_degree12_extension/REPORT.md`.

The first structural audit of degree twelve is also exact. Products of the
degree-four, -six, and -eight covariants with source invariants of complementary
degrees give 17 displayed old generators. Their forced overlap
\(R_4^2M_4\) bounds the span by 16, and a nonzero rank-16 minor modulo 23
proves that this bound is attained in characteristic zero. Consequently the
48-dimensional degree-twelve space has a 16-dimensional lower-invariant part
and a 32-dimensional primitive quotient. This filtration by itself is not a
landing theorem: old directions can cancel the landing equations in a mixed
covariant, so one cannot delete those 16 variables. The subsequent leading-
ideal calculations above separately exclude the old sector, each selected
old-plus-one-primitive slice, and all 496 selected
old-plus-two-primitive slices.  Hence a landing covariant needs at least
three primitive coordinates in this fixed quotient basis.  This still does
not justify a general quotient, arbitrary-plane exclusion, or mixed-variable
elimination.  It does, however, give the exact next chart cover: any landing
point has a nonzero primitive quotient coordinate, so the 32 opens
\(p_j\ne0\) cover the full locus.  The complete 1,124 equations have now been
transformed to the \(D_{12}^{V_6},p_0,\ldots,p_{31}\) basis and the authorized gate
\(p_0=1\) has been run.  It timed out after 600.877 seconds with zero leading
output at a `44328 x 245460` matrix, a worse trajectory than the original
standard chart.  The other 31 charts were therefore not launched.  The
decomposable quotient has Hilbert function `[1,16,136,286,0]` and length 439,
but using it for relative elimination requires monic reductions and explicit
control of determinant, Fitting, and rank-drop exceptional strata.  It is not
a flatness theorem and cannot simply be imposed on mixed charts.  See
`tmp/projective_source_degree12_primitive_chart/REPORT.md`.

## Covariant-dimension criterion and the third symmetric power

Kraft--Loetscher--Schwarz prove for this centerless group that
\(\operatorname{covdim}(G)=\operatorname{ed}(G)+1\), and their placement and
homogeneity results allow a minimal covariant to be taken as a homogeneous
self-covariant of \(W\). Since every nonzero such covariant is faithful, the
essential-dimension dichotomy has the exact reformulation

\[
\begin{aligned}
\operatorname{ed}(G)=3
&\Longleftrightarrow
\text{some nonzero homogeneous }f:W\to W
\text{ has }\det Df\equiv0,\\
\operatorname{ed}(G)=4
&\Longleftrightarrow
\det Df\not\equiv0
\text{ for every nonzero polynomial self-covariant }f.
\end{aligned}
\]

This criterion is broader than landing in the Klein cone. Exact complete
good-reduction calculations prove that every nonzero homogeneous
self-covariant through degree eleven has nonzero Jacobian and is dominant.
In degree ten, 338 independent necessary determinant quintics return the unit
ideal on all ten triangular charts of \(\mathbf P^9\). In degree eleven, the
complete covariant space has dimension 12. The same 640 source points are
unisolvent on the full 509-dimensional degree-50 invariant space, so the 496
retained Jacobian quintics span the complete determinant-coefficient space.
Exact `msolve` calculations return the unit ideal on all twelve triangular
charts of \(\mathbf P^{11}\); the two hardest charts take 85.89 and 18.57
seconds. Proper specialization transfers both exclusions to characteristic
zero.

Degree twelve has also been reconstructed completely.  The covariant space
has dimension 16, the determinant has source degree 55, and 728 deterministic
source points produce the full rank-721 universal coefficient span inside
the 721-dimensional invariant space \(R_{55}\).  In the exact splitting

\[
M_{12}^{W}=D_{12}^{W}\oplus P_{12}^{W},\qquad \dim D_{12}^{W}=12,
\quad \dim P_{12}^{W}=4,
\]

the pure primitive restriction has rank 56, all quintics in four variables,
and hence empty projective locus.  All twelve triangular charts of
\(\mathbf P(D_{12}^{W})\) are unit ideals.  The original genuinely mixed
chart \(p_0=1\) timed out at a degree-seven matrix
`104836 x 166810`.  Relative specialization has since completed the fiber
\([p_0:p_1:p_2:p_3]=[1:1:1:1]\) with a unit ideal.  Because the
decomposable projection center is empty, proper projection proves that the
mixed incidence is empty over a nonempty open subset of primitive
\(\mathbf P^3\), also in characteristic zero.  Degree twelve remains open
only over a proper closed exceptional subset of the mixed parameter space,
not on either pure stratum and not generically on the mixed locus.  See
`tmp/degree12_jacobian/REPORT.md`,
`tmp/degree12_jacobian_structural/REPORT.md`, and
`tmp/relative_kls_chart/REPORT.md`.

Neither the KLS theorem nor finite generation of the covariant module gives
an all-degree cutoff; an explicit \(S_5\)-module counterexample rules out that
shortcut. All higher degrees also remain open for this Jacobian test.

Voisin's current construction is equivariant for every projective
automorphism of a smooth cubic threefold and gives a dominant map from a
product of Grassmannians to \(C^{[3]}\). The Grassmannian source is itself
dominated equivariantly by a linear representation, so unconditionally

\[
C^{[3]}\text{ is }G\text{-very-versal}.
\]

This nine-dimensional variety does not improve the essential-dimension
bound and does not select one of the three points. Pulling back the universal
marked family replaces the rational Grassmannian source by a variety
rationally fibered over \(C\) itself; after twisting it is a projective bundle
over \({}^T C\). A rational point on that marked cover is therefore already
the missing rational point, so the apparent selection step is circular.

## All-degree self-covariant normal form

Let \(S=\mathbf C[W]\), \(R=S^G\), and
\(M=(S\otimes W)^G\). Adler's invariant-ring presentation makes

\[
A=\mathbf C[f_3,f_5,f_6,f_8,f_{11}]
\]

a polynomial parameter subring over which \(R\) is free of rank 12. The exact
Molien series shows that \(M\) is free of rank 60 over \(A\), hence has generic
rank five over \(R\), but \(M\) is not globally free over \(R\).

This finite module structure does not impose a degree bound on a landing
covariant. Put \(B=[x\ C\ D\ E\ K]\) and \(\Delta=\det B\). Since the exact
witness above proves \(\Delta\ne0\), Cramer's rule and equivariance give

\[
M[1/\Delta]=R[1/\Delta]x\oplus R[1/\Delta]C\oplus
R[1/\Delta]D\oplus R[1/\Delta]E\oplus R[1/\Delta]K.
\]

Consequently, over \(K_0=\operatorname{Frac}(R)\), the all-degree landing
problem is exactly the same single cubic

\[
\Phi(a)=F(a_0x+a_1C+a_2D+a_3E+a_4K)=0
\]

in five variables. A global module presentation supplies coordinates for
this equation but neither forces nor obstructs a nonzero zero. Equivalently,
restriction of scalars along the rank-12 extension
\(\operatorname{Frac}(R)/\operatorname{Frac}(A)\) gives 12 cubics in 60
variables, still far outside any applicable automatic point theorem.

As a further finite check, all 15 generalized cross products of four
gradients among the six explicit invariants of degrees 3 through 9 are
self-covariants of degrees 17 through 26. Exact evaluation at
\((-2,-2,-2,-2,-1)\) shows that none lands in the Klein cubic. This structured
family is not an all-degree exclusion.

### Degree-free Jacobian equation

The same frame gives an exact all-degree form of the KLS criterion.  Put

\[
\tau=\frac{f_3^2}{f_5},\qquad
P=\mathbf C(t_3,t_6,t_8,t_{11}),\qquad
K=\mathbf C(\mathbf P(W))^G,
\]

where \(t_d=f_d/\tau^d\).  The monomial coordinate change is unimodular,
Adler's Hironaka decomposition gives \([K:P]=12\), and the normalized frame

\[
\overline B=[\tau^{-1}x,\tau^{-4}C,\tau^{-5}D,
              \tau^{-6}E,\tau^{-7}K]
\]

defines, for the four extensions of the coordinate derivations of \(P\),

\[
\Gamma_r=\overline B^{-1}\partial_r\overline B\in\operatorname{Mat}_5(K),
\qquad \nabla_r=\partial_r+\Gamma_r.
\]

This connection is flat.  Clearing denominators and using the Euler
derivation proves the exact equivalence

\[
\det Dq=0
\Longleftrightarrow
\mathcal J_\nabla(a):=
\det[a,\nabla_1a,\nabla_2a,\nabla_3a,\nabla_4a]=0,
\]

with \([a]\in\mathbf P^4(K)\); the gauge law
\(\mathcal J_\nabla(ha)=h^5\mathcal J_\nabla(a)\) makes this projective.
Thus \(\operatorname{ed}(G)=3\) iff this first-order determinant equation has
a rational point, and \(\operatorname{ed}(G)=4\) iff it is nonzero at every
point. Equivalently, one seeks a \(K\)-line preserved by the connection along
one nonzero rational vector field. Irreducibility only forbids preservation
in all four directions and therefore does not settle this condition.

The finite infrastructure is now complete.  The rank-12 Hironaka basis and
all 78 products are certified, and the four \(\Gamma_r\) are compiled as
exact arithmetic circuits over that field.  Their inputs comprise 101 exact
frame/structure reductions and 20 secondary-derivative reductions over
\(\mathbf Q\).  At the regular specialization
\((t_3,t_6,t_8,t_{11})=(1,2,3,4)\), the horizontal operator has rank 48,
the frame determinant has an exact inverse, all 100 matrix entries and all
twelve basis derivatives are reconstructed, and Leibniz is checked on all 78
products.

The executable circuit gives two sound bounded exclusions.  A good-prime
rank-60 certificate for the 60-by-60 regular block determinant excludes all
121 projective constant directions in \(\{-1,0,1\}^5\) and all 440 ordered
directions \(e_i\pm b_s e_j\), with no survivor.  These are exactly 561
literal ansätze, not an exhaustive subset of the infinite field.  Rational
solvability or universal nonvanishing of the PDE remains a new theorem, not a
finite-degree Gröbner calculation.  The exact derivation and certificates are
in `tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md`,
`tmp/kproj_arithmetic/REPORT.md`, and `tmp/kproj_connection/REPORT.md`.

## Finite-orbit and secant audit

The subgroup-fixed configurations do not yield a positive map by iterated
third intersection. Using the standard maximal-subgroup list
\(A_5,11{:}5,D_{12}\), exact character-line checks prove that every complex
\(G\)-orbit on \(C\) has length at least 60. Indeed, the restrictions to
\(A_5\) and \(11{:}5\) are irreducible; the only relevant proper
order-greater-than-11 case inside \(A_5\) is \(A_4\), whose two character
lines are off \(C\); and the unique character line for \(D_{12}\) is also off
\(C\). A coordinate point has stabilizer \(C_{11}\), so the bound 60 is
sharp.

The Sylow-fixed constructions give effective cycles of degrees

\[
60,132,165,220,
\qquad -13\cdot60+3\cdot132+165+220=1.
\]

This is a degree-one formal zero-cycle, not an effective point. Exact secant
calculations show that the five diagonals of the \(C_{11}\) coordinate
pentagon are contained in \(C\), while its five sides are tangent and return
an endpoint. The normalizer pairs the four \(C_5\)-eigenpoints by inversion,
but both paired chords are contained in \(C\).

Finally, a \(G\)-invariant pairing of an orbit \(G/H\) is equivalent to an
index-two overgroup of \(H\). Exact subgroup enumeration gives: no step from
\(C_{11}\) or \(V_4\); \(C_5<D_{10}\) and then no further step; and three
order-six choices above \(C_3\) (one \(C_6\), two \(S_3\)), all folding to
\(D_{12}\) and then stopping. The \(D_{12}\)-character-line calculation also
forces the last paired chord to be contained or degenerate. Thus no such
binary chord tree reaches a singleton or a two-point orbit.

This excludes only finite-orbit binary folding. It does not exclude a
continuous covariant mixing an entire orbit at once. Likewise
\(\operatorname{Sym}^2(C)\) is \(G\)-birational to the \(\mathbf P^3\)-bundle
of lines through a point over \(C\), so the residual-intersection map merely
repackages the original problem.

The 220-point \(C_3\)-orbit also resists the most direct higher-arity
linkage. Exact good reduction at 331 gives its evaluation ranks on
\(H^0(C,\mathcal O_C(d))\)

```text
1, 5, 15, 34, 65, 110, 165, 220     (d=0,...,7).
```

Hence no divisor of degree at most four contains the orbit, and its space of
containing quintics is one-dimensional. A three-divisor complete intersection
containing it must start in degrees at least \((5,6,6)\), whose residual has
degree at least \(3\cdot5\cdot6\cdot6-220=320\). A constant
\(G\)-invariant curve of degree 74 cannot do better: if it contained the
orbit simply, its intersection with the cubic would leave a constant
\(G\)-invariant effective cycle of degree two, contradicting the minimum
orbit length 60. A torsor-dependent semilinear degree-74 interpolation curve
would evade this argument and would solve the problem, but constructing it is
another form of the unresolved varying-covariant problem.

## Other audited boundaries

- The generic twist contains no \(K_0\)-rational line. Let \(S(C)\) be the
  Fano surface of lines. A point of \({}^{T_{\rm gen}}S(C)(K_0)\) would, by
  twisting adjunction, give a rational \(G\)-equivariant map
  \(W\dashrightarrow S(C)\). The closure of its image cannot have trivial
  \(G\)-action: that would give a \(G\)-invariant line in \(C\), hence a
  two-dimensional invariant subspace of the irreducible representation
  \(W\). Simplicity of \(G\) therefore makes the image faithful and very
  versal. But it has dimension at most two, contradicting
  \(\operatorname{ed}(G)\ge3\). Thus a line-based parametrization of the
  generic twist is unavailable even if the cubic ultimately has a point. The
  twist contains no \(K_0\)-defined conic either: its span is a
  \(K_0\)-plane, and the residual component of the cubic plane section would
  be a \(K_0\)-line.
- Gross--Popescu identify the level-structure moduli space
  \(\mathcal A^{\mathrm{lev}}_{11}\) birationally with the Klein cubic, and
  the natural change-of-level action is the same \(G\)-action. This does not
  furnish an equivariant parametrization: their unirationality conclusion at
  this point uses only the ordinary unirationality of a smooth cubic
  threefold. No linear or already very versal source for the deck action is
  produced, so the modular interpretation restates rather than solves the
  current problem.
- The projective factor in the Pfaffian bridge is genuinely nonsplit. The
  inverse image of a Sylow \(V_4\subset G\) in
  \(\operatorname{SL}_2(11)\) is \(Q_8\), and the central element acts as
  \(-I\) on the six-dimensional representation. Thus its projective action
  has no \(V_4\)-fixed point and is not itself weakly versal.
- In contrast, every twist of the ambient
  \(\operatorname{Gr}(2,6)\) is rational. It is
  \(\operatorname{SB}_2(A_T)\), where \(A_T\) has degree six and index one or
  two. In the index-two case \(A_T=M_3(D)\) for a quaternion algebra \(D\),
  and this generalized Severi--Brauer variety is the \(D\)-projective plane
  with affine chart \(D^2\). Intrinsically, the distinguished \(F_{14}\)
  section asks for a common isotropic \(D\)-line in \(D^3\) for five
  quaternionic Hermitian forms, equivalently a common zero of five scalar
  quadrics on the eight-dimensional chart \(D^2\). No point theorem for this
  simultaneous-isotropy problem applies. Moreover
  \(\operatorname{Br}({}^T F_{14})=\operatorname{Br}(K)\), so a nonsplit
  quaternion class remains nonsplit over the function field of the section;
  the tautological reduced-dimension-two ideal does not split it. Exact
  good-reduction calculations also exclude matched polynomial covariants
  into the Pfaffian cone through degree fifteen. In degree sixteen the full
  80-dimensional covariant space and 1,313 independent necessary Pluecker
  quadrics have been reconstructed, but a 1,800-second exact Gröbner run
  timed out in a \(105039\times88559\) degree-three matrix without emitting a
  leading ideal. Thus degree sixteen remains the next unchecked geometric
  locus, not an exclusion; see `tmp/fano14_degree16/REPORT.md`.
- Kresch--Tschinkel's equivariant integral decomposition of the diagonal does
  not furnish a new obstruction here. Their proved implication starts from
  stable linearizability, whereas the target is only dominance from a linear
  representation; failure of decomposition would not obstruct mere
  \(G\)-unirationality. Conversely, its existence would not prove
  \(G\)-unirationality. The relevant Amitsur and universal-torsor necessary
  conditions already vanish for the honestly linearized hyperplane class.
- The ordinary and all higher Amitsur obstructions vanish, even after
  restriction to subgroups: \(\mathcal O_C(1)\) is honestly linearized, so
  the equivariant universal-torsor obstruction is zero and
  Scavia--Tschinkel--Zhang Theorem 1.2 applies. Likewise every twist \(Y\)
  satisfies \(\operatorname{Br}(Y)=\operatorname{Br}(K)\). These are
  necessary-condition checks, not point theorems.
- Prime-local essential dimension cannot force the value four: the local
  values are two at \(2\) and one at \(3,5,11\).
- Equivariant birational superrigidity excludes birational linearization, not
  a dominant equivariant map of higher degree.

## Current open boundary

A complete solution must still do at least one of the following:

- find a landing self-covariant in degree at least 16, or another dominant
  equivariant parametrization;
- find a landing covariant into the associated \(F_{14}\) Pfaffian cone in
  degree at least 16;
- find a projective-source map \(\mathbf P(V_6)\dashrightarrow C\), on the
  genuinely mixed/large-primitive-support part of the degree-twelve
  constant-coefficient space or on an unrestricted ternary-or-larger support
  in the exhaustive degree-eight rational frame;
- find a Jacobian-zero self-covariant over the proper closed exceptional
  locus in the degree-twelve primitive parameter space, or in a higher
  degree, equivalently a four-dimensional faithful covariant image;
- solve the equivalent degree-free connection equation
  \(\mathcal J_\nabla(a)=0\) over \(K=\mathbf C(\mathbf P(W))^G\), or prove
  its universal nonvanishing;
- find a \(K_0\)-point on the explicit generic twisted cubic \(\Phi=0\);
- for an exhaustive generic `xCD` descent, find a `K_proj,C`-rational point on
  the original projective `xCD` cubic (equivalently on the distinguished
  component of `G(P)=alpha_R*z^3`), or compute a relative unramified 3-Selmer
  obstruction or a smooth-reduction local obstruction there; then construct
  the generic twisted three-flex-line
  algebra, line forms, and constants required for true second descent;
- construct a torsor-dependent semilinear degree-74 curve through the
  degree-220 orbit point, leaving a quadratic residual cycle;
- find such a point in a three-column frame plane in total degree at least 15;
- for one frame plane, decide whether its nontrivial flex class in
  \(H^1(K_0,E[3])\) lies in the Kummer image \(E(K_0)/3E(K_0)\);
- prove \(\operatorname{ed}_{\mathbf C}(G)=3\) by another compression;
- prove \(\operatorname{ed}_{\mathbf C}(G)=4\), or exhibit a twist with no
  rational point.

## Primary references

- A. Duncan and Z. Reichstein, *Versality of algebraic group actions and
  rational points on twisted varieties*, especially Remark 2.6, Theorems 1.1,
  10.3, 10.5, and Proposition 10.8:
  <https://arxiv.org/abs/1109.6093>.
- Yu. Prokhorov, *Simple finite subgroups of the Cremona group of rank 3*,
  Theorems 1.1 and 1.5: <https://arxiv.org/abs/0908.0678>.
- Yu. Tschinkel and Zh. Zhang, *Stable equivariant birationalities of cubic
  and degree 14 Fano threefolds*, Proposition 4.1 and Remark 3.4:
  <https://arxiv.org/abs/2409.08392>.
- I. Cheltsov, Yu. Tschinkel, and Zh. Zhang, *Equivariant unirationality of
  Fano threefolds*, author manuscript dated 2026-07-18, Theorem 5.1 and
  printed page 23:
  <https://math.nyu.edu/~tschinke/papers/yuri/25bguni/bguni.pdf>.
- B. Poonen and M. Stoll, *The valuation of the discriminant of a
  hypersurface*, Theorem 1.1 and Corollaries 10.1--10.2, dated 2026-06-30:
  <https://math.mit.edu/~poonen/papers/discriminant.pdf>.  Valuation one is
  the theorem-level bridge from the exact `xCD` divisor calculation to a
  residue-rational nondegenerate node.
- M. Bender, L. Busé, Y. Checa, and E. Tsigaridas, *Solving bihomogeneous
  polynomial systems with a zero-dimensional projection*, for the
  conditional admissible-bidegree/multiplication-matrix test on the
  degree-12 exceptional incidence: <https://arxiv.org/abs/2502.07048>.
- Y. Kopeliovich and C. Sanabria Malagón, *Schwarz maps for modular curves*:
  <https://arxiv.org/abs/2607.06900>.  Its level-11 theta model was tested
  directly; the paper gives an explicit ODE only at level 9.
- V. Chestnov and G. Crisanti, *Sampling Polynomial Rational Remainders with
  SPQR*: <https://arxiv.org/abs/2511.14875>, for candidate reconstruction by
  elimination orders even in positive-dimensional systems; its
  companion-matrix route is the zero-dimensional branch, and every candidate
  here would still need exact verification.  A. Demin and F. Rouillier,
  *Fast Rational Univariate Representation via Gaussian Elimination*:
  <https://arxiv.org/abs/2607.06397>, is instead conditional on first obtaining
  a zero-dimensional ideal.
- A. Demin and S. Gowda, *Groebner.jl: Fast Groebner Tracing in Julia*:
  <https://arxiv.org/abs/2607.06372>, and the current
  [change-matrix interface](https://sumiya11.github.io/Groebner.jl/interface/).
  The latter was tested under `tmp/groebnerjl_change_matrix_pilot/`: exact
  small identities pass, but the two-row fixed-input change calculation and
  512-row parsing already cross the `768 MiB` RSS gate, so the public
  high-level route is not viable for all 721 rows under that bound.
- Yu. Tschinkel and Zh. Zhang, *Cohomological obstructions to equivariant
  unirationality*: <https://arxiv.org/abs/2504.10204>.  Its degree-two and
  degree-three obstructions vanish for the present honestly linearized
  Picard-rank-one action, so it supplies no headline obstruction here.
- I. Dolgachev, *The essential and Cremona dimensions of a group*, version 3:
  <https://arxiv.org/abs/2507.15096>.
- H. Kraft, R. Loetscher, and G. W. Schwarz, *Compression of finite group
  actions and covariant dimension II*, especially Theorem 3.1,
  Corollary 3.5, Proposition 2.1, and Theorem 2.4:
  <https://arxiv.org/abs/0807.2016>.
- J. E. Cremona, T. A. Fisher, C. O'Neil, D. Simon, and M. Stoll,
  *Explicit n-descent on elliptic curves. I. Algebra*:
  <https://arxiv.org/abs/math/0606580>, and
  *III. Algorithms*:
  <https://arxiv.org/abs/1107.3516>, for the genuine and fake descent
  algebras and Kummer equations used in the `xCD` audit.
- T. A. Fisher, *The Hessian of a genus one curve*:
  <https://arxiv.org/abs/math/0610403>, for the ternary-cubic Hessian and
  Jacobian invariant normalization.
- C. Voisin, *Rank 2 vector bundles and degrees of points of del Pezzo
  surfaces*, version 2, especially Theorem 1.1 and Section 2:
  <https://arxiv.org/abs/2509.17996>.
- A. Kresch and Yu. Tschinkel, *Invariants in equivariant birational
  geometry*, especially the higher Amitsur obstruction and the scope of
  equivariant Burnside invariants: <https://arxiv.org/abs/2602.23998>.
- A. Kresch and Yu. Tschinkel, *Linearizability notions in equivariant
  birational geometry*, especially Theorems 2.5, 4.4, 4.6 and Proposition
  5.1: <https://arxiv.org/abs/2606.10965>.
- A. Adler, *Invariants of* \(\operatorname{SL}_2(\mathbf F_q)\cdot
  \operatorname{Aut}(\mathbf F_q)\) *acting on* \(\mathbf C^n\), especially
  the Klein cubic and Hessian discussion:
  <https://library.slmath.org/books/Book35/files/inv.pdf>.
- A. Adler, *Invariants of* \(\operatorname{PSL}_2(\mathbf F_{11})\)
  *acting on* \(\mathbf C^5\), Comm. Algebra 20 (1992), 2837--2862, for the
  invariant-ring Hironaka presentation.
- F. Scavia, Yu. Tschinkel, and Zh. Zhang, *Birational invariance of higher
  Amitsur groups*, especially Theorem 1.2:
  <https://arxiv.org/abs/2605.02763>.
- ATLAS of Finite Group Representations, maximal subgroups of
  \(\operatorname{PSL}_2(11)\):
  <https://brauer.maths.qmul.ac.uk/Atlas/v3/lin/L211/>.
- M. Gross and S. Popescu, *The moduli space of (1,11)-polarized abelian
  surfaces is unirational*, especially Theorem 0.1 and the discussion after
  it: <https://arxiv.org/abs/math/9902017>.

## 2026-07-28 — director review and synthesis of the generic Cech-circuit packet

Reviewed: `tmp/xcd_generic_cech_next/`, `tmp/xcd_first_descent_next/`, and
`tmp/xcd_arithmetic_next/` (reports dated 2026-07-28).  The frozen typed,
corrected-alpha, first-descent, and arithmetic-gate verifiers replay their
stated PASS and strict-status lines.

**Verdict: sound, correctly scoped, and it closes the four structural gates
of the determinant-free generic first descent.**

*Inference pattern checked.*  The pre-alpha flex/Cech generic-open rank and
unit claims rest on nonvanishing of a literal integer or `GF(67)`
specialization of a universal formula — the correct direction (nonvanishing
reflects along specialization).  Verified at each load-bearing site: smoothness
(`c_4, c_6, Δ`), the flex resultant plus the `a^3`-coefficient (all nine
flexes affine), the unit markers `N_F(g) = 31`, `N_F(d) = 3`, square-freeness
of the degree-nine eliminant (so the divided-difference idempotent
`e_Δ` is legitimate), and the `81×81` determinant (so rank 81 holds on a
nonempty generic open, not on one split fiber).  By contrast, membership of
the corrected `alpha_R` in the rank-nine group algebra is proved by the
geometric scalar-cochain descent lemma.  The `GF(101)` sheet proves that the
chosen `ell` chart and selected `9 x 9` subsystem are generically
nonempty/invertible and corroborates all-coordinate reconstruction; it is not
the proof of generic `R`-membership.

*The two convention traps are closed properly.*  The differential
alignment `ρ = −g⁻¹` with the `c_4/c_6` weight check pins the sign/scale
ambiguity that a bare Weierstrass-equation check would leave — exactly the
failure mode the characteristic-23 control (`tmp/xcd_control_next/`) was
built to catch.  And the repeated-point components of the triple-overlap
identity are NOT claimed via collinearity (tautological there); the report
derives them from the formal definition `c_{ij} = P_j − P_i` and claims no
stronger expanded triple packet.

*Geometric inputs.*  `λ_{12}` unit-off-diagonal rests on smooth-cubic
flex-tangent geometry (tangent at a flex meets the cubic only there, with
multiplicity three) plus certified étaleness — both in place.

*Consequence for the queue.*  The "Best re-entry points → Generic twist"
needs list (rank-nine flex algebra `F`, Cech difference
`c_{12} ∈ E[3](F⊗F)`, triple-overlap identity, rank-81 isomorphism) is now
satisfied AT CIRCUIT LEVEL; the former circuit-construction gate is done.
The current arithmetic covering-curve attack remains open.  The subsequent
coefficient pass implemented the length-twelve Hironaka DAG through the
generic flex point and diagonal
idempotent; a typed nested-etale-algebra continuation now also supplies the
off-diagonal inverse `lambdaSharp` and its actual `X,Y` packet, with the full
rank-81 identities replayed.  The subsequent scalar-cochain normalization
also supplies a generic-open rational first-Kummer representative `alpha_R`
modulo cubes; the raw
determinant ratio is explicitly shown not to descend.  What still blocks
generic first descent is the arithmetic point problem on the original
projective `xCD` plane cubic: CFOSS identifies a distinguished component of
the 729-component first-descent union that is base-defined and isomorphic as
a covering to this cubic.  The pure-coefficient places `A=0`, `B=0`, and
`C=0` are exactly locally soluble.  The geometric degree-120 discriminant is
now also closed as a local-obstruction route by the squarefree line
certificate and Poonen--Stoll's valuation-one theorem.  At the two motivated
smooth-reduction primes, invariant-polynomial residue points through degree
15 are excluded but local solubility is undecided.  The next negative gate is
relative unramified 3-descent or the actual residue 3-descent at `f5=0` or
`f6=0` over `K_proj,C`, not arithmetic primes of the saved `QQ`-model.  True second
descent needs the
twelve-flex-lines algebra as before.  The engineering directive
(no five-variable resultant expansion, no splitting field, hash-consed DAG)
remains in force.

The sibling `tmp/kls_residue_next/` packet has also been replayed: its general
residue systems are positive-dimensional determinant hypersurfaces, and its
60 simultaneous constant `P2` families are empty.  The follow-up
`tmp/kls_first_jet_two_fiber/` packet excludes all 720 one-slope first-jet
families and all 240 stronger `P5` families with independent slopes in all
three coefficients along one common base direction.  Its next bounded step
is a `P8` two-coordinate pilot at three affinely independent regular fibres,
not another constant or one-direction sweep.

Headline unchanged: this installs descent infrastructure; it does not
decide `ed_C(PSL_2(F_11))`.
