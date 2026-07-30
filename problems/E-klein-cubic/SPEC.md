# Problem E — PSL(2,11)-unirationality of the Klein cubic threefold

## Convention and status

Work over \(k=\mathbf C\).  Put

\[
G=\operatorname{PSL}_2(\mathbf F_{11})
\]

and let \(W\) be the faithful irreducible five-dimensional complex
representation whose projectivization preserves the Klein cubic

\[
X=\left\{
x_0^2x_1+x_1^2x_2+x_2^2x_3+x_3^2x_4+x_4^2x_0=0
\right\}\subset \mathbf P(W)=\mathbf P^4.
\]

The action is an honest linear action \(G\to\operatorname{GL}(W)\), not
merely a projective action of a central extension.  The variety \(X\) is a
smooth cubic threefold, \(\operatorname{Aut}(X)=G\), and the action is
generically free.

> **Status (checked 2026-07-29).**  The problem is open.  The updated
> July 18, 2026 manuscript of Cheltsov--Tschinkel--Zhang explicitly retains
> the \(G\)-action on the Klein cubic as an exception whose equivariant
> unirationality is unknown.

The portable `certificates/` package and the documentation in this directory
are tracked. The approximately 9.1 GB `tmp/` computation tree cited below is
intentionally ignored; those paths record local provenance for newer solver
outputs and are not artifacts available from a fresh clone.

Older papers sometimes call the property below *linearizability*.  In this
file, *\(G\)-linearizable* is reserved for equivariant birationality to a
linear action; that stronger property is known to fail.  The target here is
only \(G\)-unirationality, also called *very versality*.

## Problem statement

> **Problem E.**  Prove or disprove that the Klein cubic \(X\) is
> \(G\)-unirational.  Equivalently, decide whether there exist a
> finite-dimensional complex linear representation \(U\) of \(G\) and a
> dominant \(G\)-equivariant rational map
> \[
> U\dashrightarrow X.
> \]

This is a binary, unconditional target.  A proof conditional on one of the
conjectures below is not a resolution unless that conjecture is proved in
the required case.

Ordinary unirationality of \(X\) is known and does not address the problem:
the parametrizing map must be \(G\)-equivariant for the specified full
group action.

## Exact equivalent formulations

Let \(K/\mathbf C\) be any field extension, let
\(T\to\operatorname{Spec}K\) be a \(G\)-torsor, and write \({}^{T}X\) for
the twist.  Because the action on \(X\subset\mathbf P(W)\) lifts to
\(\operatorname{GL}(W)\), the twist is again a smooth cubic threefold in
an ordinary \(\mathbf P^4_K\).

Duncan--Reichstein Theorems 1.1, 10.3, and 10.5 give the equivalences

\[
\begin{aligned}
X\text{ is }G\text{-unirational}
&\Longleftrightarrow X\text{ is very versal}\\
&\Longleftrightarrow X\text{ is weakly versal}\\
&\Longleftrightarrow {}^{T}X(K)\ne\varnothing
   \quad\text{for every }(T,K)\\
&\Longleftrightarrow {}^{T}X\text{ is }K\text{-unirational}
   \quad\text{for every }(T,K).
\end{aligned}
\]

The last equivalence uses Kollár's theorem that a smooth cubic hypersurface
of dimension at least two with a rational point is unirational.  In the
other direction, \(K\)-unirationality gives a \(K\)-point because every
field \(K/\mathbf C\) is infinite.  Consequently:

- one \(G\)-torsor twist without a \(K\)-point disproves the headline;
- proving that every twist has a \(K\)-point proves the headline.

There is also a useful single generic-torsor version.  Let

\[
K_{\mathrm{gen}}=\mathbf C(W)^G,
\qquad
T_{\mathrm{gen}}=\operatorname{Spec}\mathbf C(W)
   \longrightarrow\operatorname{Spec}K_{\mathrm{gen}}.
\]

The faithful finite \(G\)-action on \(W\) is generically free, so this is a
\(G\)-torsor.  Then

\[
X\text{ is }G\text{-unirational}
\Longleftrightarrow
{}^{T_{\mathrm{gen}}}X(K_{\mathrm{gen}})\ne\varnothing.
\]

For the nontrivial direction, a rational point on the generic twist is the
same, by twisting adjunction, as a \(G\)-equivariant rational map
\(W\dashrightarrow X\).  Let \(Z\) be the closure of its image.  Then \(Z\)
is very versal.  The kernel of the action \(G\curvearrowright Z\) is normal.
It cannot be all of \(G\), since that would put \(Z\) inside
\(X^G=\varnothing\); simplicity of \(G\) therefore makes the action on \(Z\)
faithful, and a faithful finite-group action on an irreducible variety is
generically free.  The unconditional bound
\(\operatorname{ed}(G)\ge3\) now forces \(\dim Z\ge3\), hence \(Z=X\).
This special argument is what makes one generic twist sufficient here; it
is not a general replacement for the all-torsors criterion.

## Unconditional starting point

The following facts are available at the outset and should not be reproved
except where an explicit model or checker is needed.

1. **Essential-dimension interval.**
   \[
   3\le \operatorname{ed}(G)\le4.
   \]
   The upper bound comes from the generically free action on
   \(\mathbf P(W)\); the lower bound comes from the absence of a faithful
   action of \(G\) on a unirational surface.

2. **No global fixed point.**  Irreducibility of \(W\) implies \(X^G\) is
   empty.  Thus the usual projection-from-a-fixed-point construction is
   unavailable.

3. **Every Sylow restriction is positive.**  For
   \(p\in\{2,3,5,11\}\), every Sylow subgroup \(G_p\subset G\) fixes a point
   of \(X\).  Corollary 10.6 and Theorem 10.5 of Duncan--Reichstein imply
   that the restricted \(G_p\)-action is \(G_p\)-unirational, not merely
   weakly versal.

4. **Condition (A) holds.**  Every abelian subgroup of \(G\) fixes a point
   on \(X\).  All abelian subgroups are cyclic except the Sylow-two subgroup
   \(V_4\), and \(V_4\) also has a fixed point.  Thus the standard abelian
   fixed-point obstruction to equivariant unirationality vanishes.

5. **Every twist already has a zero-cycle of degree one.**  The cubic
   degree gives \(p\)-versality for \(p\ne3\); the Sylow-three fixed point
   gives \(3\)-versality.  Duncan--Reichstein Corollary 8.7 then gives a
   degree-one zero-cycle on every \({}^{T}X\).  The exact missing step is
   therefore
   \[
   \text{zero-cycle of degree one}\quad\Longrightarrow\quad K\text{-point}
   \]
   for these particular twisted cubic threefolds.

6. **Modern classification isolates this as an explicit exception.**  Theorem 5.1
   of Cheltsov--Tschinkel--Zhang proves Condition (A) sufficient for almost
   all generically free finite-group actions on smooth cubic threefolds.
   The actions of \(C_{11}\rtimes C_5\) and \(G\) on the Klein cubic remain
   explicit open exceptions.

7. **Birational rigidity is not a negative answer.**  The full action is
   \(G\)-birationally superrigid.  This rules out an equivariant birational
   linearization, but a dominant map \(U\dashrightarrow X\) may have degree
   greater than one.

8. **The degree-14 Fano bridge is twisted.**  If \(Y\) is the associated
   degree-14 Fano threefold, Tschinkel--Zhang construct
   \[
   X\times\mathbf P^2\times\mathbf P(V)
   \sim_G
   Y\times\mathbf P^2\times\mathbf P(V),
   \]
   where \(G\) acts trivially on \(\mathbf P^2\), while the projective
   action on \(\mathbf P(V)\) comes from a six-dimensional representation
   of the central extension \(\operatorname{SL}_2(\mathbf F_{11})\).  This
   is not stable \(G\)-linearization and does not supply a map from a
   genuine linear \(G\)-representation.

## Conditional forks and stakes

Proposition 10.8 of Duncan--Reichstein is stated numerically, but its proof
and Theorem 10.5 give the stronger implications below.

- Their Conjecture 8.8, asserting that versality on every Sylow subgroup
  implies \(G\)-versality, would prove that \(X\) is \(G\)-unirational and
  that \(\operatorname{ed}(G)=3\).
- The Cassels--Swinnerton-Dyer conjecture that a cubic hypersurface with a
  zero-cycle of degree prime to three has a rational point would likewise
  prove that \(X\) is \(G\)-unirational and
  \(\operatorname{ed}(G)=3\).
- Prokhorov proves \(\operatorname{Crdim}(G)=4\): his work gives the lower
  bound, and the faithful action on \(\mathbf P(W)=\mathbf P^4\) gives the
  upper bound.  Dolgachev's conjecture
  \(\operatorname{ed}(G)\ge\operatorname{Crdim}(G)\) would instead give
  \(\operatorname{ed}(G)=4\), which rules out \(G\)-unirationality of \(X\).

Thus a positive solution would give \(\operatorname{ed}(G)=3\) and a
counterexample to Dolgachev's proposed inequality.  A negative solution,
together with the degree-one zero-cycles above, forces the existence of a
twisted cubic threefold contradicting the relevant
Cassels--Swinnerton-Dyer statement.  It would also refute
Duncan--Reichstein Conjecture 8.8 in this example, because every Sylow
restriction is already versal.  Either direction crosses a recognized open
boundary.

There is a stronger unconditional reduction, proved in `RESOLUTION.md` from
Prokhorov's classification and the Tschinkel--Zhang Pfaffian bridge:

\[
X\text{ is }G\text{-unirational}
\quad\Longleftrightarrow\quad
\operatorname{ed}_{\mathbf C}(G)=3.
\]

Indeed, a three-dimensional compression is birational to either the Klein
cubic or the associated degree-14 Fano threefold.  In the second case, twist
the Pfaffian bridge; its Brauer--Severi factor splits over an extension of
degree at most two, and a point on a cubic over a quadratic extension descends
by the third-intersection construction.  Thus an unconditional proof of
\(\operatorname{ed}(G)=3\) proves the headline, while an unconditional proof
of \(\operatorname{ed}(G)=4\) disproves it.  This exact reduction still does
not choose between the two values, so the headline remains open.

## Current certified progress (2026-07-29)

The durable proofs and checkers are in `RESOLUTION.md`, `certificates/`, and
the indexed audit reports under `tmp/`.  They establish the following,
without resolving the binary headline:

1. exact cyclotomic matrices for the faithful action, the full 660-element
   Cayley check, and exact invariance of the Klein cubic;
2. primitive covariants \(x,C,D,E,K\) of degrees \(1,4,5,6,7\) whose
   determinant is nonzero, giving an explicit Hilbert-90 frame for the
   generic twisted ambient five-space;
3. exact Molien multiplicities and a characteristic-zero exclusion of all
   landing homogeneous self-covariants through degree seven;
4. good-reduction, exact Gröbner, scalar-quotient, and forced-plus-plane
   certificates extending that bounded exclusion through degree twenty-four;
5. exact smoothness of all ten three-column generic-frame plane sections and
   a complete good-reduction exclusion of invariant-polynomial landing ansätze
   in those planes in total degrees eleven through fourteen, together with
   absolute irreducibility of every degree-nine flex cover and hence no
   rational-flex shortcut;
6. an exact subgroup-orbit, secant, and linkage audit: every complex orbit on
   \(X\) has length at least 60, the natural Sylow-fixed configurations cannot
   be reduced by an equivariant binary chord tree, and the 220-point orbit has
   neither a divisor through degree four nor a constant degree-74 residual
   curve shortcut;
7. an all-degree module normal form: after localizing at the frame
   determinant, every self-covariant has unique invariant coordinates on
   \(x,C,D,E,K\), so finite module generation supplies no hidden degree bound.
   After normalizing by \(\tau=f_3^2/f_5\), the degree parameter disappears
   completely: over \(K=\mathbf C(\mathbf P(W))^G\), the generic frame defines
   a flat connection \(\nabla\), and the KLS alternative is exactly whether
   \(\det[a,\nabla_1a,\ldots,\nabla_4a]=0\) has a point
   \([a]\in\mathbf P^4(K)\).  The reduction is exact but neither solvability
   nor universal nonvanishing is known.  The required invariant-field
   arithmetic is now certified: the Hironaka basis has rank 12, its complete
   multiplication table and \(\tau\)-normalized projective model are checked,
   and exact addition, inversion, trace, and norm are implemented.  The four
   matrices \(\Gamma_r\) are compiled as exact arithmetic circuits, with 121
   characteristic-zero reduction identities and a semantic specialization
   check.  Exact rank certificates exclude 440 Hironaka-linear ansätze, and
   a complete projective cover now excludes the entire constant-coefficient
   \(\mathbf P^4\), upgrading the former 121-point sample.  The simultaneous
   constant centralizer of the four labelled connection matrices is exactly
   the scalar line.  The two polar elementary modifications exclude
   all 60 constant three-coordinate planes and, using two regular fibres, all
   720 single-slope projective families obtained by varying one coefficient
   linearly in one base coordinate.  The stronger `P5` screen also excludes
   all 240 families in which all three coefficients acquire independent
   slopes in one common base-coordinate direction.  One canonical
   two-direction `P8` family is also completely projectively empty.  This
   does not scale to an exhaustive negative search: at a regular point the
   KLS rank-drop first-jet hypersurface has dimension 19, whereas even the
   full four-direction jet space with fixed three-coordinate support has
   dimension at most 10.  A finite union of `P3/P5/P8` families therefore
   cannot cover the local equation.  The first full-support one-direction
   `P9` chart reached the 700 MiB stop with no verdict.  The installed
   primitive quartic covariant now gives a finite surjective
   `G`-endomorphism of `P4` of degree 256.  Precomposition preserves KLS rank
   drop and multiplies primitive saturated degree by four, so conditional on
   one solution there are solutions of unbounded degree `4^n d`.  Therefore
   a uniform pole/degree bound on every solution cannot justify a terminal
   calculation.  The same finite map makes the coordinate ring a rank-1,024
   graded free module over the quartic pullback ring, with residue degrees at
   most 15; no Jacobian descent across those residue terms is proved.  The
   global image/foliation theorem now shows that every KLS solution has an
   irreducible invariant unirational hypersurface image `H`; a canonical
   image, or one with no divisorial inverse image of `Sing(H)`, must be the
   Klein cubic.  Quantitatively,
   `deg(h)=r+t+d(deg(H)-5)+4` for the pulled-back-gradient gcd `h`, primitive
   foliation degree `r`, and residual adjugate degree `t`.  Thus every
   non-Klein image carries the precise invariant contracted divisor that a
   negative proof must eliminate.  General rational coefficients, the
   minimal-contraction/canonicity theorem for one minimal solution, and an
   effective bound for that solution remain open;
8. an exact Pfaffian-twist reduction: the nonsplit \(F_{14}\) section is five
   simultaneous quaternionic-Hermitian isotropy equations, and the quaternion
   class persists over its function field, so ambient rationality does not
   produce the missing point; matched polynomial covariants into the
   Pfaffian cone are excluded through degree fifteen;
9. a projective-source theorem for the six-dimensional Schur representation:
   any rational \(G\)-map \(\mathbf P(V_6)\dashrightarrow X\) would be
   dominant and would solve the problem, because every twisted source splits
   over an extension of degree at most two and quadratic points on cubics
   descend by third intersection.  Complete constant-coefficient landing
   loci are empty in degrees \(4,6,8,10\), and the full degree-six pencil has
   no rational-function root. In degree twelve the decomposable sector and
   all 32 one-primitive plus all 496 two-primitive structural slices are
   empty, so any landing covariant needs at least three primitive coordinates
   in the fixed quotient basis; the full 48-dimensional locus remains open.
   The complete characteristic-23 equation span has exact rank 1,124.  Its
   terminal solver audit rules out further source sampling and identical
   retries: no resumable basis was saved, all 48 standard affine charts retain
   1,124 independent cubic leading parts, and exact chart probes reproduce the
   homogeneous degree-four bottleneck.  The exact decomposable-plus-primitive
   chart \(p_0=1\) has now also been run; it times out at a
   `44328 x 245460` matrix on a worse trajectory, so the other 31 transformed
   charts are stopped.  A future bounded continuation requires relative
   elimination with its exceptional strata, not another chart sweep.
   Five explicit degree-eight covariants give a
   generic frame over \(\mathbf C(\mathbf P(V_6))^G\), hence an all-degree
   normal form for rational projective-source maps; all ten coordinate lines
   in that frame are empty.  On its ten ternary coordinate planes, every
   invariant-coefficient ansatz through degrees 0, 4, 6, 8, and 10, the
   five-dimensional space \(S_{12}\), and all 90 spaces
   \(S_{12}+\langle p_j\rangle\) are empty; one two-direction gate is also
   empty and the other 359 were stopped by the measured budget.  Unrestricted
   points using at least three coordinates remain open;
10. the exact Kraft--Loetscher--Schwarz criterion
   \(\operatorname{ed}(G)=3\) iff some nonzero homogeneous self-covariant has
   identically zero Jacobian, together with a complete dominance exclusion
   through degree eleven.  In degree eleven the complete 12-dimensional
   space gives 496 exact Jacobian quintics, and all twelve projective charts
   are unit ideals at the good prime 67.  In degree twelve the complete
   16-dimensional space gives the full rank-721 coefficient system.  Its
   12-dimensional decomposable projective locus and four-dimensional pure
   primitive projective locus are empty.  The genuinely mixed incidence is
   empty over a certified nonempty open of the primitive `P3`, so any survivor
   is confined to a proper closed exceptional subset.  The retained
   degree-seven border map and finite top ideal do not yet present that subset.
   A corrected survivor-only F4 trace and a complete degree-seven division
   plan now give a bounded circuit interface for the top-map solve.  All 721
   degree-five final rows, comprising 2,882 selected roots and 474,949 trace
   operations, are matched coefficientwise to the retained Groebner basis;
   one complete cross-round degree-seven source row is also checked exactly.
   The selected degree-six and remaining degree-seven roots are not yet
   matched, so no full right inverse, relative determinant, or
   characteristic-zero statement follows yet.
   Voisin's current construction makes \(X^{[3]}\)
   \(G\)-very-versal, but after pulling the universal marked cover back along
   her parameterization, the marked source is birationally fibered over \(X\)
   itself and hence does not solve the required point-selection problem. This
   finite dominance exclusion has no all-degree cutoff; and
11. an exact `xCD` ternary-cubic and Jacobian model over the certified
   \(K_{\rm proj}\) arithmetic, together with the genuine rank-nine \(E[3]\)
   algebra \(\mathcal R=\operatorname{Map}_{K_{\rm proj}}
   (E[3],\overline K_{\rm proj})\) and normalized
   group/difference/Kummer-function formulas.  An
   independent \(s=1\) control also certifies the distinct flex torsor and
   true degree-12 three-flex-line algebra, but its rational flex makes the
   class trivial.  A separate low-height coordinate-line control with rational point
   \(O=[1:0:1]\) and irreducible flex cover proves a nonzero class that is
   abstractly Kummer, \(\delta([H-3O])\), where \(H\) is a hyperplane
   section; its genuine nonzero values \(G_T([H-3O])\) are now explicit and
   replayed.  On the generic characteristic-zero side, typed quotient-algebra
   circuits construct the actual Cech difference and a scalar-cochain
   normalization supplies a generic-open rational first-Kummer representative
   \(\alpha_{\mathcal R}=\det(M_0)/\ell(M_0)^3\) modulo cubes.  The geometric
   descent lemma is the proof; the retained finite-field all-coordinate check
   is only corroboration.  After fixing the identity cube root, the genuine
   affine unit chart for `G(P)=alpha_R*z^3` is assembled with ten variables
   and nine cubics.  Its `3^8` sheets split geometrically into 729
   degree-nine 3-covering components.  The saved exact model is over
   `K_proj,QQ`; a point there suffices positively after scalar extension, but
   a negative result must hold over
   \(K_{\mathrm{proj},\mathbf C}=K_{\mathrm{proj},\mathbf Q}
   \otimes_{\mathbf Q}\mathbf C\).  CFOSS identifies a distinguished
   base-defined component that is
   \(K_{\mathrm{proj},\mathbf C}\)-isomorphic as a covering to the original explicit
   projective `xCD` cubic.  The general-slice factoriality theorem now proves
   that this component has no `K_proj,C`-point.  This closes the selected
   plane construction, not the other components or the full generic twisted
   cubic.  The pure-coefficient divisor families
   `A=0`, `B=0`, and `C=0` are exactly locally soluble.  A full-degree
   squarefree line restriction proves that the degree-120 discriminant is
   geometrically reduced and coprime to the gauge forms; valuation one at
   every discriminant component, together with the June 2026 Poonen--Stoll
   theorem, gives a residue-rational node and hence a local point there.  Thus
   no discriminant component obstructs.  The two natural smooth-reduction
   primes `f5=0` and `f6=0` are each geometrically integral and have alternate
   integral gauges; neither admits a coordinate residue point or an
   invariant-polynomial `x,C,D` point of total source degree at most 15.  This
   was only a height lower bound.  The `f6=0` residue is now obstructed by the
   exact horizontal degree image `3Z`; the `f5=0` residue descent and a
   genuinely full-threefold relative obstruction remain open.  For \(f_6=0\), the
   pullback residue is now identified as a relative cubic in
   \(\mathbf P_{H_6}(\mathcal O(-1)\oplus\mathcal O(-4)\oplus
   \mathcal O(-5))\).  Exact reduction modulo 67 excludes every triple-line
   fibre, but the five coordinate fibres are \(a c^2\); thus blanket
   fibrewise geometric reducedness fails and total-space factoriality does
   not follow from the fibres.  The pullback total cubic space is nevertheless proved integral
   and normal: a squarefree full-degree 720-point plane slice proves that
   \(V(f_6,\Delta)\) is geometrically reduced in characteristic zero, a
   separate accepted computation excludes zero cubic fibres, and flatness,
   \(S_2\), generic smoothness, and Poonen--Stoll give \(R_1\).  The exact
   codimension-three class maps are now exact.  The singular locus of
   \(H_6\) is one 60-point orbit of \(A_3\) points, with Jacobian-scheme length
   180.  The July 27 Jung--Saito two-block computation has exact ranks
   `75,2125,2200`, and the characteristic-zero Jacobian quotient has the
   decisive degree-13 value 255.  Hence
   \(\operatorname{def}(H_6)=0\) and

   \[
   \operatorname{Cl}(H_6)=\mathbf Z[\mathcal O_{H_6}(1)].
   \]

   Thus every algebraic base local ring is a UFD, including after extension
   to \(\mathbf C(\lambda)\).  The simple-line completed/henselian class map
   is an isomorphism; at the doubled line there are four henselian branches
   and the completed map \(\mathbf Z\to\mathbf Z^3\) has column
   \((1,1,0)\), hence cokernel \(\mathbf Z^2\).  The actual algebraic base
   class group is zero, so this pair-sum class is created by completion.
   Factoriality of \(H_6\) does not imply factoriality of the total local ring
   \(B\) or fourfold \(C_6\), and neither includes nor excludes a primitive
   horizontal Weil class.  The Picard/Cartier part of the global alternative
   is now proved.  The corrected ample cubic class is
   \(D=3\zeta=15H+3\xi\); relative-duality vanishing and SGA 2 give

   \[
   \operatorname{Pic}(C_6)=\mathbf ZH\oplus\mathbf Z\xi,
   \qquad
   \operatorname{Pic}(C_6)\xrightarrow{\sim}\operatorname{Pic}(Y)
   \]

   for an effective-Cartier \(Y\in|D|_{C_6}\).  Ravindra--Srinivas identifies
   \(\operatorname{Cl}(C_6)\) and \(\operatorname{Cl}(Y)\) for general \(Y\),
   so their Cartier defects agree and every Cartier horizontal degree is in
   \(3\mathbf Z\).  The singular-locus input is now proved.  If a fibre cubic
   is \(L^2M\), its three fibre derivatives span at most two quadrics, so the
   twenty maximal minors of their `6 x 3` coefficient matrix vanish.  On the
   cyclic hyperplane \(w_0+\cdots+w_4=0\), the ideal consisting of these
   minors and \(f_6\) is the unit ideal modulo 67; certified Groebner.jl and
   an independent `msolve` replay agree.  Properness and the projective
   dimension theorem therefore give

   \[
   \dim\operatorname{Sing}(C_6)\le1.
   \]

   The local comparison, general-slice census, and global implication are now
   certified.  The restricted source has actual rank `660+60=720`.  Four
   extra special invariant rank-support branches have squarefree binary
   cubics, while the known-axis projective repeated-factor incidence has
   local length nine over both `QQ` and `F_67`; its full special length and
   known generic contribution are both `60*9=540`.  Properness therefore
   excludes extra generic repeated-factor bases.  Together with the `L=0`
   verticality theorem, the positive-dimensional singular support of
   \(C_6\) is exactly 120 fibre lines.  A genuinely general slice has exactly
   180 `A3` points and 180 four-branch `cA` points, so localization is
   surjective and proves \(\operatorname{def}(Y)=0\).  Hence \(Y\) and
   \(C_6\) are factorial with Weil degree image \(3\mathbf Z\), and the
   projective `xCD` plane cubic has no `K_proj,C`-point.  This is a scoped
   nonpoint theorem for the plane section `F(a*x+b*C+c*D)=0`, not for the
   full generic twisted Klein cubic threefold, so it does not resolve the
   headline.  A pulled-back base hyperplane is
   not ample and
   one fixed-\(\lambda\) specialization is not decisive.  The full stabilizer
   \(C_{11}\) fixes all four branches,
   so the invariant defect retains rank two, while the two within-pair
   differences span only an index-four sublattice.  This refutes the
   completed-local-surjectivity/factoriality shortcut.  Individual Zariski
   branch descent and globalization are not proved by faithful-flat
   contraction.  The exact negative gate remains that the horizontal
   divisor-degree image of the normalized quotient total space, modulo
   vertical classes, be \(3\mathbf Z\).  Its next structural test is the
   global class-group image in the four labelled valuations of the
   equivariant weighted Rees boundary, followed by horizontal degree.  The
   section-preserving weighted Rees deformation and its special equation
   `u*v+g4(t,c)` are now exact; the four primitive branch modules have
   explicit `2 x 2` matrix factorizations.  Individual descent is equivalent
   to a graded, `s`-torsion-free rank-one reflexive Rees lattice with special
   reflexive hull `I1` or `I3`.  The sufficient defect-free `2 x 2` ansatz
   now has an exact all-order formal solution for all four branches: the
   tangent determinant map is surjective in every weight, and determinant
   induction gives `s`-adically homogeneous matrices over
   `K[u,v,t,c][[s]]` with `s`-torsion-free rank-one MCM/reflexive cokernels
   and exact special fibres.  This closes higher formal-obstruction orders,
   but not Zariski descent.  The infinite matrices cannot be evaluated at
   `s=1` and are not finite algebraic `G_m`-graded matrices.  Artin--Popescu
   approximation does promote them to exact factorizations over the
   henselization of the pair along `(s)`, preserving the actual special
   modules.  This proves pair-henselian effectivity but not
   section-preserving Zariski algebraization: `1-s` is a unit there, and
   equivariant coherent completeness reaches only the completed original
   local ring.  The remaining local gate is
   `[I_i] in image(Cl(B) -> Cl(Bhat))`, or a finite graded Rees
   lattice/descent cocycle on an open meeting `s=1`.  General Rees lattices
   may also have finite-length special-fibre defect.  The exact algebraic
   relative critical curve is now cut out by the two Jacobian minors
   `p_y,p_z` and recovers the four henselian branches, but strict-henselian
   residue Galois fixes those branches and supplies no monodromy obstruction.
   A valid conditional exclusion requires an algebraic `u`-like element with
   reduced henselian divisor equal to the four-branch sum and no extras,
   factorial complement, and a contraction partition with no singleton
   block.  The critical-curve component partition alone is insufficient.
   For an actual algebraic standard `cA` equation `u*v+g(t,c)`, this datum is
   exact: the algebraic factors of `g` give `Cl=Z^r/Z*(1,...,1)`, and
   henselian refinement maps them to their block sums, so a primitive branch
   is in the image exactly for a singleton block.  But the fused model
   `u*v+c^4-t^4*(1+t)` and split model `u*v+c^4-t^4` have isomorphic
   four-branch completions with respectively zero and full `Z^3` algebraic
   class image.  Hence completed/special `cA` data and branch tangents cannot
   replace the missing algebraic ruling/incidence comparison or a direct
   reflexive-module descent certificate.
   The natural exact algebraic candidate
   `a0=p_z-(5/2)*lambda^4*p_y`, `b=p_y/6` is now ruled out.  Although
   `(U,a0,b,t,c)` has Jacobian determinant `6` and special initials `(u,v)`,
   the tangent quartic on `U=a0=0` is not `g4`; in particular
   `H4(b,0,0)=-(8235/2)*lambda^10*b^4`, so
   `div_(B^h)(a0) != Q1+...+Q4`.  The unique ordinary cubic correction in
   `(b,t,c)`, `a1=a0+phi3(b,t,c)`, restores the necessary tangent cone but
   is itself refuted by the exact five-jet: the common `b`-axis has order five
   with coefficient `12*lambda^2*(195*lambda^11+2)`, while four reduced
   smooth branches tangent to `C-r_i*T` require order at least eight.  Thus
   `div_(B^h)(a1) != Q1+...+Q4`.  The complete degree-five error
   `H5=(3/8)*b^2*P3` isolates the finite ordinary-quartic candidate
   `a2=a1+H5/b`; its divisor and `B[1/a2]` factoriality remain open.  Do not
   continue the formal jet ladder.  The localized-inverse target is now
   refuted for the entire polar field.  Two distinct unramified points in one
   `F_67` fibre of `(x,y,z,t,c)->(U,a0,b,t,c)`, with Jacobian determinants
   `6` and `38`, give by the off-diagonal etale-locus argument
   `[Q(lambda,x,y,z,t,c):Q(lambda,U,a0,b,t,c)]>=2`.  Since `(a0,b)` and
   `(p_z,p_y)` generate the same field, no birational reparametrization of
   the polar minors and no triangular correction `a0+P(b,t,c)`, including
   `a1,a2`, has a dense-open rational inverse.  This does not refute the
   divisor of `a2`, factoriality of `B[1/a2]` by another method, or the
   primitive class image.  True
   second descent still requires the generic twisted
   three-flex-line algebra, line forms, and constants; and
12. an exact audit of the Problem F involution mechanism.  For every
   involution \(t\), the five-dimensional module splits with dimensions
   \((3,2)\); the plus-plane section is a smooth genus-one cubic, while
   \(F|_{E_-(t)}=0\), so the entire minus-line lies on \(X\).  The
   order-twelve centralizer has no fixed point on \(X\).  Consequently every
   one of the 55 plus-planes is a codimension-two base component of any
   hypothetical primitive landing covariant, its common transverse order is
   odd, and the leading exceptional map dominates the corresponding
   minus-line.  This is an all-degree necessary condition, not an
   obstruction: the rational fixed line invalidates the constant-image step
   in Problem F's surface path proof.  The full \(V_4\) check gives joint
   dimensions \((2,1,1,1)\); the three minus-lines form a triangle, and
   \(X^{V_4}\) is that triangle's three vertices together with three reduced
   points on the common fixed line.  Triangle vertices have stabilizer
   exactly \(V_4\) and tangent representation equal to the sum of its three
   nontrivial characters, so the scalar-differential blowup input also fails.
   On an involution minus-line the exact \(D_{12}\) binary covariant
   dimension is zero in even degree and \(\lfloor(d+2)/3\rfloor\) in odd
   degree.  The six neighboring plus-planes cut out the reflection
   discriminant \(x^6-y^6\); its mandatory odd power conditionally forces
   endpoint swapping, but extra endpoint vanishing realizes all four
   transition ledgers.  The finite transition graph therefore closes rather
   than obstructs.  Only the full symbolic 55-plane arrangement or a new
   invariant of higher-dimensional exceptional centers remains viable from
   this import.  One exact initial-order gain survives: if the common plane
   order is \(m=2r+1\), the order along a common \(V_4\)-fixed line is at
   least \(3r+3\), not the monomial-theoretic minimum \(3r+2\).  At the next
   order trivial and nontrivial character terms can mix, so this does not
   yet iterate to a contradiction.  A sparse initial-module/Fitting
   calculation across all 55 planes, 55 common lines, the 66 five-plane
   `D10` points, and the 55 seven-plane `D12` points is the precise
   successor, partially executed in item 13; and
13. landing structure through degree 25, the ordinary quotient through
   degree 29, and landing exclusion through degree 24.  At the split
   good prime 67, restriction to one involution plus-plane is injective on
   complete self-covariant spaces through degree 16.  The kernels in degrees
   17--24 have dimensions `2,3,7,11,16,25,34,44`; exact landing tests exclude
   every one.  Degrees 17--19 use full coefficient rank, degrees 20--21 use
   complete disjoint chart covers, and degree 22 uses the exact linear ledger
   `25 -> 12 -> 4 -> 0` from common-line and even minus-line conditions.
   Degrees 23 and 24 compress to 20 variables, where independently audited
   392- and 484-cubic systems have unit ideal on all 20 projective charts.
   Projective properness promotes these empty special fibres to
   characteristic zero.  Thus landing self-covariants are excluded through
   degree 24, with degree 25 the first bounded unknown.  Its structural probe
   gives `M25=189`, restriction rank 130, `K25=59`, parity-excludes the
   order-two three-space, and excludes the order-at-least-four six-space by
   full cubic rank `56/56`; the unresolved leading common-line
   order-exactly-three system factors through 37 dimensions and was not sent
   to a nonlinear solver.  Fable's stronger \(V_4\)-line bound at `m=1` is
   exactly this already imposed order-three condition; it contributes no
   additional row to the degree-25 landing ideal.  Since degree 25 is odd,
   no universal minus-line vanishing relation may be added either.  A
   from-scratch audit rebuilt all of these degree-25 ranks, including the
   complete `3124/3124` overlap map.  The reduced scalar
   arrangement has 55 triple lines and 121 multiple points and first acquires
   split-fibre equations in degree 15; this scalar ideal is not the odd
   symbolic equivariant module.  The induced `D12` ordinary/jet blocks and
   first line/point overlap maps are now exact.  At the `D10` and `D12`
   point orbits, the minimal local symbolic layers are presented for every
   `m`; for odd `m` their reflection-sign character forces point order at
   least `3m+1`.  Over split `F_67`, compact induced `W`-block calculations construct actual
   16-dimensional higher-compatibility quotient bases in every degree
   18--29, with all 17 tested multiplication maps by `f3`, `f5`, and `f11`
   invertible over `F_67`; an independent audit agrees.  The ordinary
   support/regularity target is now complete: its defect has scalar length
   13 at each of the 121 multiple points, local `W`-multiplicities 9 and 7,
   and `dim D_d[W]=16` for every `d>=54` in characteristic zero and the split
   good fibre.  The symbolic analogue is not point-supported: the first
   exact normalization cokernel is free over every triple-line coordinate
   ring, with explicit `A4` characters for `m=1,3`.  The sealed symbolic
   packet and independent audit prove the injection into plane normalization
   and the local line-equalizer/residual-point orientation.  The subsequent
   global theorem proves that the iterated kernels give the correct
   associated sheaf, but the naive four-term Cech complex is false and
   low-degree literal graded equality still requires finite irrelevant
   saturation.  Direct plane
   jets give `[(I^(3)/I^(5))_d tensor W]^G=0` for `25<=d<=31`, including
   characteristic zero by full-rank good reduction.  Over split `F_67`, the
   first `m=3` total-degree-19 line stratum is killed by an independently
   audited rank-`8/8` `D12` boundary.  Also over split `F_67`, the compact
   `m=1`, degree-25 complex has ledger `673 --309--> 364 --305--> 59` and recovers the direct global
   `K1/K3`; independent comparison leaves the leading common-line
   exact-order-three quotient at dimension 37.  The remaining graded discrepancy
   is one finite irrelevant-saturation module, with automatic exactness for
   `d>=55m+109`.  Over split `F_67`, its `m=1` `W`-multiplicity space vanishes
   through degree 34 and in every degree at least 164.  The induced
   `f3:D_d->D_(d+3)` maps are injective for `14<=d<=31`, and the quotient
   through degree 34 has dimension 1,459.  In degree 35 the compact saturation
   has dimension 362 while the independently rebuilt literal image has
   dimension 361, so `dim [(T_1)_35 tensor W]^G=1`.  Finite-torsion
   nilpotence gives a nonzero `f3`-colon element in some degree, refuting the
   all-degree split-fibre colon-zero proposal and its target-1,572
   certificate.  The first killed degree is unknown and no
   characteristic-zero saturation statement follows.  The complete second
   split fibre `(89,zeta11-2)` again has compact dimension 362, while the
   full ambient global space has dimension 637 and order-zero restriction
   rank 276, bounding the literal image by 361.  This proves another positive
   special-fibre defect but not generic persistence.  A
   characteristic-zero decision now requires intrinsic compressed
   cyclotomic differentials or an exact cycle/nonboundary certificate; the
   raw number-field matrices exceed the credible memory envelope.
   The complete degree-25 order-four plane equations have exact rank 842 on
   `Q_37 direct_sum K_6`, with filtered ranks `56,833,842,842`.  Their final
   nine normalized equations define a nonempty pure 33-dimensional
   compatibility scheme of degree 835 and generically determine the six
   `K` coordinates, so the other 833 equations remain essential.  The 56
   monic `K^3` relations also give an exact relative rank-28 border module;
   coefficientwise comparison proves that its stable commutator closure
   presents the original 842-cubic quotient.  A deterministic mixed-coordinate
   `P^18` is empty over the algebraic closure of the split fibre, independently
   giving the now-weaker bound `dim Z<=23`.  More strongly, the monic rules
   make the landing scheme finite over `P(Q)=P^36`, with no point in the
   projection centre.  A `P^16` full-rank anchor and two nested Schur
   extensions prove that the degree-four module has rank `19285/19285` on a
   coordinate `P^18`; the three pivot products are `5,14,11 mod 67`.  This
   first gives `dim Z<=17`.  Although `P^19` has fewer candidate rows than
   degree-four columns, it closes in degree five: the curvature-safe
   `29320 x 3220` outer Schur matrix has exact rank 3,220 and supplies the
   three summands of `F_5(20)` directly, without asserting an exact inherited
   rank.  This gives the now-superseded historical bound `dim Z<=16`.
   The next curvature-safe degree-five packet has an exact full-rank
   `4693 x 4693` residual square on `P^20`; its 19-stage full replay peaks at
   `580.828125 MiB`.  After base change to the algebraic
   closure of `F_67`, the projective dimension theorem gives every nonempty
   split-fibre landing locus `dim Z<=15`.  A separate canonical projective-DVR
   family in the 189-dimensional Reynolds lattice promotes the invariant
   conclusion `dim L_25<=15` to
   `Q(zeta_11)` and hence `C`; it does not lift the arbitrary modular `Q/K`
   complement.  The completed coordinate `P^21` degree-five test is a strict
   nonverdict.  Its exact `21407 x 7911` split-`F_67` matrix has 3,933
   independent leading columns and an explicit normalized dependency among
   columns `0,...,3933`, verified in all 21,407 rows.  Thus only
   `3933 <= total rank <= 7910` is certified; the exact total rank was not
   computed.  This fixed family proves no `P^21` emptiness.  Its conditional
   full-rank replay and characteristic-zero DVR/upper-semicontinuity
   promotion to `dim L_25<=14` did not trigger, and no `P^22` run followed.
   Replay the sealed packet with
   `VECLIB_MAXIMUM_THREADS=1 OPENBLAS_NUM_THREADS=1 OMP_NUM_THREADS=1
   /opt/homebrew/bin/python3 -u
   tmp/m1_relative_border_p21_d5_design/verify.py`.  On the full `q0!=0`
   chart, three exact lowest-profile circuit
   tests separate `q0^4 e0` from the 756-row-plus-residual degree-four span,
   `q0^5 e0` from constant combinations of all 821 rows, and `q0^17` from
   constant combinations of 815 independent wedge circuits on one rank-six
   minor chart.  The accepted coordinate-Schur filtration now refutes the
   full 34,355-unknown raw-821 scalar-`Q` degree-five identity by exact
   restriction to `q0,...,q16`, with terminal source/augmented ranks
   `1913/1914`.  This does not refute the `T_i`-stable
   rank-28 kernel/support, and higher cleared degrees remain open.
   A Macaulay2 direct-presentation control closes one sparse `P^10`, but its
   operator-bearing precursor already exceeds the cap, so no global
   saturation or Fitting computation was run.  The global dense border
   closure and raw Gröbner probes both exceed the memory gate.  Hence neither
   degree 25 nor `(ID_m)` is closed.  The split-fibre zero-colon route is now
   refuted at degree 35; the remaining linear targets are
   characteristic-zero/integral saturation and higher symbolic order.  These
   must be paired with uniform relative
   border/Fitting landing detection on
   `[(I^(m)/I^(m+2))_d tensor W]^G`.  See
   `tmp/m1_t1_f3_colon_attack/REPORT.md`,
   `tmp/m1_t1_f3_colon_degree35_audit/REPORT.md`, and
   `tmp/m1_t1_char0_d35_gate/REPORT.md`, together with
   `tmp/m1_rank6_circuit_support/REPORT.md`,
   `tmp/m1_rank6_schur_compression/REPORT.md` and its `PROOF_AUDIT.md`, and
   `tmp/m1_relative_border_p20_d5/REPORT.md`, its `PROOF_AUDIT.md`,
   `tmp/char0_lift_p20_d5/REPORT.md`, and
   `tmp/m1_relative_border_p21_d5_design/REPORT.md` with its
   `PROOF_AUDIT.md`; and
14. degree-independent structural audits which narrow, but do not
   close, the KLS, Fable, and obstruction routes.  For a primitive minimal
   KLS self-covariant with image \(H=V(F)\) and
   \(h=\gcd_iF_i(q)\), the gcd is invariant, every non-stable component
   orbit has length at least eleven, and \(f_3\nmid h\).  Hence
   \(\deg h\leq4\) forces \(h=1\).  The normalized dual Gauss map is a
   primitive rank-four covariant \(W\to W^*\) of degree
   \(m=4d-4-r-t\); returning through the quadratic dual Klein polar gives
   only \(d\leq2m\), or
   \(r+t\leq\lfloor(7d-8)/2\rfloor\), and does not prove \(h=1\).
   Spicer--Tasin makes log canonicity equivalent to nonnilpotence of the
   linear part at every foliation zero and, conditional on log canonicity,
   gives a **reduced** log-canonical divisor of degree \(r+4\).  This is not
   an absolute degree bound.  Order-eleven eigenpoints force
   \(r\bmod11\in\{1,3,4,5,9\}\) in the lc branch; \(V_4\) fixed loci give
   no additional parity constraint.  The KLS route therefore needs both an
   LC-minimality lemma and a vertical-divisor comparison lemma, or direct
   canonicity of one minimal image.  The individually stable part of the
   vertical branch now has a degree-independent obstruction: if `H` is normal
   and `D=V(g)` is an irreducible vertical component individually stable under
   the full group `G`, then

   \[
   q(\widetilde D)=h^1(\widetilde D,\mathcal O_{\widetilde D})\geq26
   \]

   for every resolution.  Hence `D` cannot have rational singularities and,
   in characteristic zero, cannot be smooth, klt, canonical, or plt in
   `P4`.  Proper stabilizers are now completely classified by component-orbit
   lengths `11,12,55,60,66,110,132,165,220,330,660`.  For normal `H`, the
   `11:5` stabilizer (orbit 12) forces a faithful curve of genus at least 12,
   hence `q(Dtilde)>=12` and the same singularity exclusions.  No other
   proper stabilizer forces positive irregularity by curve geometry alone.
   In particular, both orbit-11 `A5` classes admit an exact orbit of eleven
   smooth rational invariant quadrics whose squarefree product is a
   degree-22 `G`-invariant, together with a faithful `P1` image.  This is a
   coarse-geometry survivor, not a KLS gcd construction.  It also refutes
   tangency-only rigidity: if \(P_{22}\) is that product, an exact induced
   degree-25 \(G\)-field is logarithmic along \(P_{22}\) and nonzero modulo
   \(R E+P_{22}\operatorname{Der}R\); dividing its component gcd gives a
   primitive survivor of degree at most 25.  The induced degree-25 field and
   its degree-28 backup have rational integrating factor \(1/P_{22}\).  A
   separate degree-32 Nambu field is nontrivial on the divisor and, after gcd
   removal, is primitive with a polynomial integrating factor and four
   algebraically independent polynomial first integrals.  Thus a genuine
   KLS exclusion must retain the homogeneous \(W^*\)-valued polynomial
   first-integral module producing a generic-rank-four self-covariant,
   together with its adjugate/image and degree identities, minimality, or
   stronger conductor/discrepancy input; ordinary scalar integrability is too
   weak.  The degree-28 induced field and its primitive form are now excluded
   unconditionally.  On the generic quadric surface, the geometrically
   integral \(A_5\)-stable zero divisor of \(d_4\) gives an \(A_5\)-fixed
   rational point on the normal Stein curve of \(d_4^3/f^4\).  A nontrivial
   \(A_5\)-action would be faithful, while the stabilizer of a smooth
   characteristic-zero curve point is cyclic.  Hence the full local Nambu
   constant field is pointwise \(A_5\)-fixed.  Irreducibility and
   nontriviality of \(W^*|_{A_5}\) force a hypothetical homogeneous KLS
   coordinate tuple to vanish modulo the quadric; conjugacy then puts
   \(P_{22}\) into its gcd.  This avoids the false nonproper-Jacobian shortcut
   and does not require the still-unknown Stein degree to equal one.  Degree
   25 remains harder.  Here \(P_{22}\) is the
   divisor name, not the forbidden coordinate-\(\mathbf P^{22}\) slice.
   Smaller stabilizers likewise permit point or rational-curve images.  For
   nonnormal `H`, a
   vertical component may dominate a divisorial conductor surface; rational
   singularities force only `q=p_g=0`.  Thus `h=1` remains open and further
   progress must use differential/minimality or conductor/discrepancy data.

   At one \(V_4\) centre, with normalizer \(A_4\), blowing up the reduced
   three-point base orbit of projection to the triangle plane gives
   equivariant multisection-degree subgroup exactly \(3\mathbf Z\).  Thus an
   \(A_4\)-equivariant map from the triangle plane with dominant projected
   composite has projected degree divisible by three.  The degree-one
   quadratic Cremona transition is impossible, and the complete quadratic
   \(A_4\)-landing scheme is empty in characteristic zero.  Compatible
   symbolic 55-plane jets do lift equivariantly after sufficiently high
   invariant twist, but lifting does not preserve the nonlinear Klein
   equation.  The minimal permitted projected degree is now attained: the
   two genuine \(A_4\)-character hyperplanes cut smooth cubic surfaces
   \(S(a,b,c)\), and an exact cyclic cubic formula gives an
   \(A_4\)-equivariant birational map \(\mathbf P(U)\dashrightarrow S\) with
   projected degree three, six simple basepoints in a new \(A_4\)-orbit, and
   degree-one edge restrictions after cancellation.  Precomposition with
   triangle Cremona gives an exact landing tuple in \(J_3/J_5\).  Its minimal
   character-corrected form fails the split \(D_{12}\) degree-six/seven
   boundary, but high stable factors, simultaneous fat-point conditions at
   both point orbits, and equivariant Serre extension give a nonzero
   high-twist global section of
   \(\widetilde{I^{(3)}/I^{(5)}}(d)\otimes W\) with the prescribed trisection
   at all generic triple lines.  Thus linear all-centre compatibility is
   solved asymptotically.  The independently audited Koszul construction now
   produces one nonzero compatible high-twist class with
   \(F(\sigma)=0\bmod I^{(11)}\).  This solves only the first
   \(I^{(9)}/I^{(11)}\) correction.  A viable Fable construction must next
   solve \(I^{(11)}/I^{(13)}\), then the higher formal corrections,
   effectivity/algebraization, descent, and dominance.  The six edge
   basepoints force
   the displayed \(Q^2/Q\) fixed factors.  In odd orders nine and eleven the
   doubled \(Q^2\) quotient is \(4U\), with no \(A_4\)- or transported
   \(G\)-invariants, so equivariance makes the corresponding divisibility
   automatic.  In even orders ten and twelve a simple \(Q\) quotient remains
   with invariant fibre rank one; along the centre line it is a rank-one
   invariant residue sheaf, not one global scalar.  With the canonical affine
   boundary \(\operatorname{gr}^5=0\),
   \(\operatorname{gr}^6=A_L(q_B\circ C)\), the grade-seven joint-symbolic
   source makes the factor-saturated constrained two-layer differential rank
   two at every generic \(Q\)-root.  Hence no saturated cokernel component
   dominates the six resolved base sections.  The raw order-ten rank-one
   target survives, but its first quadratic residue factors through the
   preceding upper equation and vanishes on the homogeneous kernel.  The
   pure-boundary order-twelve residue vanishes, whereas the first
   post-boundary one is nonautomatic; an exact kernel witness has value
   \(-cy^{12}(B^6-1)\ne0\).  The characteristic-zero old-point interface is
   now complete.  Exact Fourier frames identify all seven tangent branches
   and the three simultaneous Rees flags.  A homogeneous invariant \(H\),
   nonzero generically on every centre line, vanishes to order at least 660
   at all 121 old `D10/D12` points.  Hence for every finite cutoff a power
   \(H^N\) supplies zero old-point Artin jets without changing the generic
   projective trisection.  For the constructed Koszul first-gate class the
   generic-line residue vanishes, so the raw old-point residue is zero, but
   its differential is also
   zero rather than surjective.  Colon saturation annihilates the finite
   cokernel formally and records the whole raw quotient in
   \(B_{\rm desc}\).  The old-point rank problem is therefore retired under
   the arbitrary-high-factor policy.  In the raw point stalk
   \(Q\in\mathfrak m_p^2\), while its exceptional transform is a unit at the
   old flags.  The genuine \(Q=0\) sections elsewhere carry the nonautomatic
   order-twelve equation.  It is locally soluble via
   \(\beta=2zq\), \(h=Bq\), but simultaneous equivariant solvability,
   global \(H^1\)-gluing, later residues, common-factor descent, and higher
   corrections remain open.  This refutes
   only the naive smoothness/Serre implicit-function shortcut, not the
   existence of a nonlinear zero, and no degree is instantiated.

   Finally, honest linearization of \(\mathcal O_X(1)\) makes the
   universal-torsor obstruction and all higher Amitsur groups vanish, also
   for every subgroup, so that branch is exhausted.  No recent
   algebraization theorem supplies the missing surjectivity
   \(\operatorname{Cl}(B)\to\operatorname{Cl}(\widehat B)\) for the local,
   nonproper `xCD` ring.  The exact class-image/finite-Rees-lattice gate is
   unchanged.  The exact relative critical curve supplies a finite
   diagnostic, but its component partition is not the divisor contraction
   partition and residue-Galois invariance supplies no shortcut.  The reports
   and replay scripts are
   `tmp/kls_minimal_contraction_attack/REPORT.md`,
   `tmp/kls_vertical_divisor_geometry/REPORT.md` with its `PROOF_AUDIT.md`,
   `tmp/kls_vertical_divisor_geometry_audit/REPORT.md`,
   `tmp/kls_nonstable_vertical_orbits/REPORT.md` with its
   `INDEPENDENT_AUDIT.md`, and
   `tmp/kls_a5_logarithmic_divisor/REPORT.md` with its `PROOF_AUDIT.md`, and
   `tmp/kls_wstar_first_integrals/REPORT.md` with its `PROOF_AUDIT.md`,
   `tmp/fable_positive_construction/REPORT.md`, and
   `tmp/fable_trisection_attack/REPORT.md`, together with
   `tmp/fable_trisection_compatibility/REPORT.md`,
   `tmp/fable_nonlinear_first_gate/REPORT.md`,
   `tmp/fable_resolved_descent/REPORT.md`, and
   `tmp/fable_constrained_cokernel/REPORT.md` with its `AUDIT_NOTES.md`,
   `tmp/fable_finite_d12_constrained/REPORT.md` with its
   `interface_design.json`, `tmp/fable_d12_char0_bridge/REPORT.md` with
   its `PROOF_AUDIT.md`, and
   `tmp/fable_d12_rees_sigma_interface/REPORT.md` with its `PROOF_AUDIT.md`,
   `tmp/recent_structural_tools_audit/REPORT.md` and
   `tmp/xcd_class_image_attack/REPORT.md` and
   `tmp/xcd_ca_class_group/REPORT.md`, followed by
   `tmp/xcd_algebraic_null_polar/REPORT.md` and
   `tmp/xcd_zariski_morse_chart/REPORT.md`, then
   `tmp/xcd_polar_function_field_degree/REPORT.md` and its
   `PROOF_AUDIT.md`, then `tmp/xcd_actual_class_image/REPORT.md` with its
   `PROOF_AUDIT.md`, then `tmp/xcd_picard_restriction/REPORT.md` with its
   `PROOF_AUDIT.md`, and finally
   `tmp/xcd_singular_locus_bound/REPORT.md` with its `PROOF_AUDIT.md`.

   Replay the null-polar test with
   `/opt/homebrew/bin/python3 -u tmp/xcd_algebraic_null_polar/verify.py`, then
   replay the five-jet refutation with
   `/opt/homebrew/bin/python3 -u tmp/xcd_zariski_morse_chart/verify.py`.

   Replay the polar function-field theorem and its independent audit with
   `/opt/homebrew/bin/python3 -u tmp/xcd_polar_function_field_degree/verify.py`
   and
   `/opt/homebrew/bin/python3 -u tmp/xcd_polar_function_field_degree/verify_audit.py`.

   Replay the standard-`cA` class-group theorem and formal-data
   counterexample with
   `/opt/homebrew/bin/python3 -u tmp/xcd_ca_class_group/verify.py`.

   Replay the Klein-sextic defect/factoriality and actual base-class image
   calculation with
   `/opt/homebrew/bin/python3 -u tmp/xcd_actual_class_image/verify.py`.

   Replay the fixed-member and general-slice Picard restriction theorem with
   `/opt/homebrew/bin/python3 -u tmp/xcd_picard_restriction/verify.py`.

   Replay the exact singular-locus dimension theorem with
   `/opt/homebrew/bin/python3 -u tmp/xcd_singular_locus_bound/verify.py`.

   Replay the local `Gr_V` comparison, global defect bridge, corrected
   invariant-support packet, and sparse census audit with
   `/opt/homebrew/bin/python3 -u tmp/xcd_local_grv_comparison_audit/verify.py`,
   `/opt/homebrew/bin/python3 -u tmp/xcd_global_defect_bridge/verify.py`,
   `/opt/homebrew/bin/python3 -u tmp/xcd_rank_invariant_reduction/verify.py`,
   `/opt/homebrew/bin/python3 -u tmp/xcd_invariant_module_support/verify.py`,
   and
   `/opt/homebrew/bin/python3 -u tmp/xcd_singular_curve_enumeration_audit/verify.py`.

   Replay the completed invariant-branch, repeated-factor, and general-slice
   census with
   `/opt/homebrew/bin/python3 -u tmp/xcd_invariant_fibre_discriminants/verify.py`,
   `/opt/homebrew/bin/python3 -u tmp/xcd_invariant_fibre_discriminants_audit/verify.py`,
   `/opt/homebrew/bin/python3 -u tmp/xcd_repeated_factor_incidence/verify.py`,
   and
   `/opt/homebrew/bin/python3 -u tmp/xcd_general_slice_completion/verify.py`.
   Replay the superseded multiprime reconstruction only for provenance with
   `/opt/homebrew/bin/python3 -u tmp/xcd_invariant_module_multiprime/verify_reconstruction.py`.

   Replay the exact natural-lift refutation and independent audit with
   `/opt/homebrew/bin/python3 -u tmp/xcd_char0_candidate_support/verify.py`
   and
   `/opt/homebrew/bin/python3 -u tmp/xcd_char0_candidate_support_audit/verify.py`.

   Replay the scoped Fable first-gate theorem and independent audit with
   `/opt/homebrew/bin/python3 -u tmp/fable_first_gate_koszul/verify.py` and
   `/opt/homebrew/bin/python3 -u tmp/fable_first_gate_koszul_audit/verify.py`.

   Replay the stable-vertical theorem and its independent audit with
   `/opt/homebrew/bin/python3 -u tmp/kls_vertical_divisor_geometry/verify.py`
   and
   `/opt/homebrew/bin/python3 -u tmp/kls_vertical_divisor_geometry_audit/verify.py`.

   Replay the non-stable/nonnormal extension and its independent finite-group
   audit with
   `/opt/homebrew/bin/python3 -u tmp/kls_nonstable_vertical_orbits/verify.py`
   and
   `/opt/homebrew/bin/python3 -u tmp/kls_nonstable_vertical_orbits/independent_verify.py`.

   Replay the orbit-11 logarithmic counterexample with
   `/opt/homebrew/bin/python3 -u tmp/kls_a5_logarithmic_divisor/verify.py`.

   Replay the \(W^*\)-first-integral boundary, exact nonproperness control,
   and unconditional degree-28 Stein fixed-point exclusion with
   `/opt/homebrew/bin/python3 -u tmp/kls_wstar_first_integrals/verify.py` and
   `/opt/homebrew/bin/python3 -u tmp/kls_degree28_stein_fixed_point/verify.py`.

   Replay the nonlinear gate with
   `/opt/homebrew/bin/python3 -u tmp/fable_nonlinear_first_gate/verify.py`.

   Replay the resolved fixed-factor descent calculation with
   `/opt/homebrew/bin/python3 -u tmp/fable_resolved_descent/verify.py`.

   Replay the constrained base-section and first-even-residue calculation
   with
   `/opt/homebrew/bin/python3 -u tmp/fable_constrained_cokernel/verify.py`.

   Replay the finite-`D12` interface audit with
   `/opt/homebrew/bin/python3 -u tmp/fable_finite_d12_constrained/verify.py`.

   Replay the characteristic-zero flag-noncoincidence bridge with
   `/opt/homebrew/bin/python3 -u tmp/fable_d12_char0_bridge/verify.py`.

   Replay the completed three-flag/high-factor/colon interface with
   `/opt/homebrew/bin/python3 -u tmp/fable_d12_rees_sigma_interface/verify.py`.

   These results preserve the stopping rule: no new bounded degree, support,
   chart, or finite-state sweep is part of the commissioned continuation.
   The one grandfathered coordinate-`P^21` computation is now complete as a
   strict nonverdict; it does not open a successor ladder, and no `P^22` run
   is authorized.

The generic-twist frame reduces E2 to finding a nonzero invariant-field
solution of \(F([x\ C\ D\ E\ K]a)=0\).  The degree bound in item 4 is finite
and therefore cannot support a negative verdict. In degree twelve the full
16-dimensional reduced covariant basis gives 143 independent landing cubics;
an exact finite-field Gröbner basis has Hilbert function zero in degree five.
Degree thirteen is excluded by a separate scalar-quotient reduction: 48
necessary cubics on \(M_{13}/fM_{10}\) force the scalar plane, and exact
degree-ten and tangent leading ideals eliminate both possible lifts. An
independent completed 21-variable q67 Gröbner calculation gives an Artinian
leading ideal and corroborates the same bounded exclusion. Degrees fourteen
and fifteen are excluded by their structural successors.  The forced-plane
arrangement calculation then excludes degrees 16--24 as stated in item 13;
the older 93-row degree-16 residual and its mod-67 hyperplane are retained
only as superseded provenance.  Degree 25 is now the next unrestricted
homogeneous landing degree.  On the projective
Schur source, degree ten is now completely excluded with quotient Hilbert
function \([1,21,231,1301,889,0]\). In degree twelve the decomposable sector
has dimension 16 inside the full 48-dimensional covariant space and is
excluded, as are the 32 spaces obtained by adding one chosen primitive basis
vector. In a fixed complete Reynolds basis all 1,925,356 coordinate supports
of size at most five are excluded. Quadratic-extension unisolvence proves
that the complete characteristic-23 landing-equation span has exact rank
1,124 and supplies a verified 1,124-row base-field solver input. Equation
rank and basis-dependent support statements are not a full degree-twelve
exclusion; the exact complete-input solve timed out in its second
degree-four matrix with no leading output. Its terminal audit proves that the
saved work is not resumable, all standard-chart leading-cubic ranks stay
1,124, and two exact chart probes hit the same first degree-four matrix.
Accordingly more sampling, an identical retry, and an unmodified standard
chart sweep are stopped.  The transformed \(p_0=1\) chart also times out on a
worse terminal matrix, so its other 31 charts are stopped; the degree-twelve
locus remains undecided. The degree-eight rational frame is exhaustive in all
degrees.  Its ten coordinate lines and the bounded ternary coefficient
envelopes through all 90 spaces \(S_{12}+\langle p_j\rangle\) are excluded,
but unrestricted ternary and larger supports remain open. On the Pfaffian target the full
degree-sixteen space has been reconstructed, but its exact solve timed out
without a geometric verdict, so the exclusion remains through degree fifteen.
The three-column bound is likewise finite; a point in one of those planes
would force a landing ansatz in some total degree, but there is no a priori
bound on that degree. The finite-orbit audit does not exclude a continuous
covariant or turn the known degree-one formal zero-cycles into rational
points.

The essential-dimension audit isolates the same unresolved arithmetic object
without a degree parameter.  If \(T_{\rm proj}\) is the generic torsor over

\[
K_{\rm proj}=\mathbf C(\mathbf P(W))^G
\]

and \(C_{\rm gen}={}^{T_{\rm proj}}C\), then

\[
\operatorname{ed}_{\mathbf C}(G)=3
\Longleftrightarrow C_{\rm gen}(K_{\rm proj})\ne\varnothing,
\qquad
\operatorname{ed}_{\mathbf C}(G)=4
\Longleftrightarrow C_{\rm gen}(K_{\rm proj})=\varnothing.
\]

Every Klein twist has index one, certified by the orbit degrees
\(60,132,165,220\), but no theorem upgrades this degree-one zero-cycle to a
rational point.  Prime-local essential dimensions are only \(2,1,1,1\) at
\(2,3,5,11\), and the audited Brauer, Amitsur, and standard stable-cohomology
obstructions do not decide the generic twist.  See
`tmp/step4_essential_dimension/REPORT.md` and
`tmp/ed_binary_attack/ALL_DEGREE_MODULE_AUDIT.md` for the exact boundaries.

## Task list

### E0 — Exact action and twist infrastructure

Fix exact matrices for generators of the faithful representation
\(G\to\operatorname{GL}(W)\), preferably over an explicit number field, and
verify:

1. the group presentation and faithfulness;
2. invariance of the Klein cubic equation;
3. the fixed loci of the Sylow and relevant abelian subgroups;
4. an explicit model of the generic torsor and of
   \({}^{T_{\mathrm{gen}}}X/K_{\mathrm{gen}}\), including every descent or
   Hilbert-90 choice.

This is infrastructure, not a resolution.  Exact Sage, Magma, GAP, or
computer-algebra scripts and logs should accompany any later computation.

### E1 — Direct equivariant parametrization or covariant search

Search for a representation \(U\) and rational covariant

\[
[f_0:\dots:f_4]\colon U\dashrightarrow\mathbf P(W)
\]

such that

\[
f_0^2f_1+f_1^2f_2+f_2^2f_3+f_3^2f_4+f_4^2f_0=0
\]

identically and the image has dimension three.  Polynomial covariants,
ratios of semi-invariants, covariants on sums of small irreducible
representations, and constructions from \(G\)-orbits are all in scope.

A positive certificate must contain exact formulas and verify landing,
\(G\)-equivariance, and dominance.  A finite search finding no covariant up
to specified degrees is only a scoped exclusion, never a negative answer.
Under the current stopping rule, no new bounded degree, support, chart, or
finite-state ladder should be opened without a structural theorem making it
part of an all-degree argument.  The one grandfathered coordinate-`P^21`
calculation has completed as a strict nonverdict; it does not authorize a
successor degree or support slice.

For this simple group, dominance of a nonzero landing self-covariant also
follows from the generic-image argument above: its image is a faithful very
versal subvariety, hence has dimension at least
\(\operatorname{ed}(G)\ge3\), and therefore equals the threefold \(X\).
Moreover, maps from other honest linear sources do not evade this search: a
generic-torsor point lifts to a rational \(W\)-valued covariant; after clearing
an invariant denominator, the highest homogeneous part is itself a nonzero
landing self-covariant.

For the Fable trisection branch, high twist may be used for the already
certified linear plane/line/point extension, but not as a substitute for the
nonlinear landing equation.  A resolved or basepoint-saturated solution must
be accompanied by the exact descent certificate.  The audited Koszul theorem
has solved the order-nine/ten target \(I^{(9)}/I^{(11)}\) for one compatible
class; it does not solve the next order-eleven/twelve target
\(I^{(11)}/I^{(13)}\).  Equivariance clears the relevant odd doubled-\(Q^2\)
residue, but the remaining order-twelve simple-\(Q\) section must vanish.  For
the canonical fixed affine boundary, generic local
solvability of the factor-saturated constrained map is now proved along all
six base sections, and the first order-ten quadratic residue vanishes on the
  preceding linear kernel.  The exact three-flag/high-factor theorem now
  supplies simultaneous zero jets at every old point, where the raw residue
  and raw differential both vanish.  Colon saturation transfers the entire
  finite defect to \(B_{\rm desc}\), so no finite old-point rank sweep is
  relevant.  One must solve the nonautomatic order-twelve equation
  simultaneously on the genuine \(Q=0\) sections and prove regular
  equivariant \(H^1\)-gluing and descent back into the unsaturated symbolic
  sheaf.

### E2 — Generic twist and rational-point route

Work over \(K_{\mathrm{gen}}=\mathbf C(W)^G\), or over an exact field of
definition followed by extension to \(\mathbf C\), and decide whether the
generic twisted cubic has a rational point.  Possible approaches include:

- an explicit point obtained from invariants or covariants of \(W\);
- a rational curve, surface, or fibration on the twist forcing a point;
- a proof of the Cassels--Swinnerton-Dyer implication for this restricted
  family of twists;
- descent through the degree-14 Pfaffian partner, with the central-extension
  and Brauer classes tracked exactly.

A \(K_{\mathrm{gen}}\)-point is a positive solution once the generic-torsor
equivalence above is invoked.  Conversely, one explicit field
\(K/\mathbf C\) and \(G\)-torsor \(T/K\) with
\({}^{T}X(K)=\varnothing\) is a negative
solution.

### E3 — Obstruction and essential-dimension route

For a negative solution, seek either:

1. an explicit twist without a rational point;
2. an unconditional proof that \(\operatorname{ed}(G)=4\); or
3. an invariant that vanishes for every linear \(G\)-representation and is
   functorial under dominant equivariant rational maps, but is nonzero for
   \(X\).

Birational or stable-birational invariants are usable only after proving the
stronger functoriality required for a dominant, possibly generically finite,
map.  The normalizer \(C_{11}\rtimes C_5\) is a useful subsidiary target:
disproving its unirationality on \(X\) disproves the full \(G\)-statement,
whereas proving it positive does not settle the full group.

The universal-torsor and all higher Amitsur obstructions are already zero for
this action, also after subgroup restriction, because the rank-one Picard
generator is honestly \(G\)-linearized.  That branch is closed unless a new
dominance-functorial invariant is introduced.  The `xCD` general-slice route
is also complete at its correct scope.  The exact repeated-factor census and
general-slice transversality activate the rank-720 localization, prove
\(\operatorname{def}(Y)=0\), and force

\[
\operatorname{Cl}(C_6)=\operatorname{Pic}(C_6)
 =\mathbf ZH\oplus\mathbf Z\xi,
\qquad \deg_{\rm horiz}\operatorname{Cl}(C_6)=3\mathbf Z.
\]

Consequently the projective plane cubic
`F(a*x+b*C+c*D)=0` has no `K_proj,C`-point.  This is not a no-point theorem
for the full generic twisted Klein cubic threefold, so it gives no headline
refutation.  The formerly open local class-image/Rees problem is retained as
provenance but is no longer needed for this plane-section conclusion.  A
negative solution now requires a genuinely full-threefold twist obstruction
or a new dominance-functorial invariant.

### E4 — Remove the projective twist in the Pfaffian bridge

Audit whether the known twisted stable birationality with the degree-14
Fano threefold can be upgraded to a construction dominated by a genuine
linear \(G\)-representation.  It is necessary to eliminate, split, or
otherwise control the projective factor arising from
\(\operatorname{SL}_2(\mathbf F_{11})\).  Merely restating the existing
twisted equivalence is not progress on the headline.

There is now one sufficient projective route: the projective-source lemma in
`RESOLUTION.md` proves that any rational
\(G\)-map \(\mathbf P(V_6)\dashrightarrow X\) would solve the headline by
index-at-most-two splitting and quadratic descent, even though
\(\mathbf P(V_6)\) itself is not weakly versal. Constant-coefficient
covariants have been excluded only in degrees \(4,6,8,10\). For rational
coefficients, the complete degree-six pencil and the ten coordinate lines of
the exhaustive degree-eight frame are excluded.  The ten ternary planes also
have exact bounded coefficient exclusions through all 90 spaces
\(S_{12}+\langle p_j\rangle\), but unrestricted ternary and larger frame
supports remain open.

## Verification and evidence standards

An **affirmative resolution by explicit map** must provide:

1. an exact description of \(U\), its \(G\)-action, and the rational map;
2. an identity proving that the map lands in \(X\);
3. equivariance checks for exact generators on a common dense domain;
4. a characteristic-zero dominance proof, for example an exact rank-three
   Jacobian witness or a function-field calculation;
5. clarification that every projective action or central extension used in
   the construction descends to the specified group \(G\).

An **affirmative resolution by twists** must prove the required rational
point statement uniformly for all torsors, or prove it for the generic
torsor and invoke the generic-torsor lemma above.  A proof for split torsors,
number fields only, or selected cohomology classes is partial.

A **negative resolution by counterexample twist** must provide:

1. an explicit field \(K/\mathbf C\) and a certified class in \(H^1(K,G)\);
2. exact equations or an intrinsic construction of \({}^{T}X\);
3. a rigorous obstruction to \(K\)-points;
4. a check that the obstruction does not merely obstruct rationality or
   stable rationality.

Computations over finite fields, floating-point calculations, dimension
counts, or searches through bounded families are discovery tools only.
Any decisive identity, map, torsor, or obstruction must be proved in
characteristic zero.  Put reusable code and exact logs under
`certificates/`; put the mathematical proof and exact verdict in
`RESOLUTION.md`.  If work stops short, record the strongest proved boundary
and a safe re-entry point in `HANDOFF.md`, while leaving the headline status
open.

## Pitfalls and theorem boundaries

None of the following settles Problem E:

- ordinary unirationality or nonrationality of \(X\);
- \(G\)-birational superrigidity or failure of \(G\)-linearizability;
- fixed points, versality, or unirationality after restriction to every
  Sylow or abelian subgroup;
- verification of Condition (A);
- existence of degree-one zero-cycles on all twists;
- the interval \(3\leq\operatorname{ed}(G)\leq4\), or either value only under
  an unproved conjecture (an unconditional proof of either exact value *does*
  settle the problem by the reduction above);
- the known twisted stable birationality using a projective representation
  of \(\operatorname{SL}_2(\mathbf F_{11})\);
- weak versality of the Schur projective source (it fails); the separate
  quadratic-descent lemma is what makes a map from that source sufficient;
- very versality of \(X^{[3]}\) without a rational equivariant operation
  selecting one point of its degree-three cycle;
- a parametrization equivariant only for a proper subgroup or a central
  extension;
- a rational map that is not proved dominant;
- a conditional proof assuming Cassels--Swinnerton-Dyer, Conjecture 8.8, or
  Dolgachev's essential-dimension inequality;
- any finite null search for covariants or rational points.
- log canonicity of the KLS foliation by itself: the resulting
  Spicer--Tasin divisor is reduced of degree \(r+4\), but this does not remove
  the vertical divisor \(V(h)\) or bound \(r\);
- the KLS irregularity bounds by themselves: they exclude rational
  full-`G` and `11:5` vertical components for normal images, but the exact
  orbit-11 `A5` quadric model, smaller-stabilizer rational curves, stable
  non-rational components, and nonnormal conductor surfaces remain.  Even
  primitivity plus equivariant logarithmic tangency does not exclude the
  orbit-11 product: an explicit degree-at-most-25 field survives modulo
  radial and divisor-multiple fields.  Its rational integrating factor, and
  the separate degree-32 primitive-after-gcd Nambu control with polynomial
  integrating factor and four independent first integrals, show that closed
  forms and ordinary scalar algebraic integrability do not exclude it either;
- primitivity of the degree-28 Nambu maximal minors as a proof of relative
  algebraic closedness.  The minors are exactly coprime, but nonproperness
  makes the implication a generalized-Jacobian condition; the replayed
  constant-Jacobian three-point collision is an exact counterexample to this
  shortcut in the stabilized four-form/five-variable format;
- failure of the quadratic \(A_4\) triangle-Cremona model: the theorem forces
  projected degree divisible by three but leaves degree-\(3k\), further-based,
  and non-dominant higher-centre constructions open.
- nonsurjectivity of the unsaturated Fable differential: the audited Koszul
  theorem supplies a zero through \(I^{(9)}/I^{(11)}\); equivariance kills
  the odd doubled-\(Q^2\) fixed-factor residue but leaves an even rank-one
  simple-\(Q\) residue sheaf.  For the canonical boundary the constrained
  factor-saturated map is now generically onto along the six base sections,
  and its first quadratic residue vanishes on the preceding kernel.  The
  exact three-flag/high-factor theorem supplies zero finite old-point jets,
  but the raw differential there is also zero and saturation moves the defect
  to \(B_{\rm desc}\).  The nonautomatic first post-boundary order-twelve
  condition on the genuine \(Q=0\) sections, \(H^1\)-gluing, later residues,
  and unsaturated descent remain, so the first-gate zero gives no ambient
  landing covariant and no positive or negative headline conclusion.
- failure of the `xCD` polar-coordinate chart: generic degree at least two
  rules out that chart and every birational reparametrization of its polar
  field, but it does not imply that `B[1/a2]` is nonfactorial, exclude a
  genuinely different transverse field, or decide the primitive class image.

Preserve theorem boundaries in both directions.  A negative result for one
construction is not non-unirationality; a positive result for a proper
subgroup is not full \(G\)-unirationality.

## Success criteria

Problem E is **closed affirmatively** only by an unconditional proof of a
dominant \(G\)-equivariant rational map from a linear representation to
\(X\), equivalently by the twist criterion above.

Problem E is **closed negatively** only by an unconditional obstruction to
every such map, equivalently by a \(G\)-torsor twist without a rational
point.  A proof that \(\operatorname{ed}(G)=4\) is sufficient.

All other rigorous outcomes are partial results.  They should be retained
with their exact scope, but the headline must remain marked **OPEN**.

## References

- A. Duncan and Z. Reichstein, *Versality of algebraic group actions and
  rational points on twisted varieties*, especially Theorem 1.1,
  Corollaries 8.6--8.7, Theorems 10.3 and 10.5, and Proposition 10.8:
  https://arxiv.org/abs/1109.6093
- A. Beauville, *On finite simple groups of essential dimension 3*,
  especially Section 3:
  https://arxiv.org/abs/1101.1372
- A. Duncan, *Equivariant unirationality of del Pezzo surfaces of degree 3
  and 4*, especially Lemma 7.3:
  https://arxiv.org/abs/1410.8434
- A. Adler, *On the automorphism group of a certain cubic threefold*,
  Amer. J. Math. 100 (1978), 1275--1280.
- J. Kollár, *Unirationality of cubic hypersurfaces*, J. Inst. Math.
  Jussieu 1 (2002), 467--476.
- Yu. Prokhorov, *Simple finite subgroups of the Cremona group of rank 3*:
  https://arxiv.org/abs/0908.0678
- I. Cheltsov, Yu. Tschinkel, and Zh. Zhang, *Equivariant unirationality of
  Fano threefolds*, especially Theorem 5.1; the updated author manuscript is
  dated July 18, 2026:
  https://math.nyu.edu/~tschinke/papers/yuri/25bguni/bguni.pdf
  and https://arxiv.org/abs/2502.19598
- Yu. Tschinkel and Zh. Zhang, *Stable equivariant birationalities of cubic
  and degree 14 Fano threefolds*:
  https://arxiv.org/abs/2409.08392
- I. Dolgachev, *The essential and Cremona dimensions of a group*, version 3
  dated May 1, 2026:
  https://arxiv.org/abs/2507.15096
- H. Kraft, R. Loetscher, and G. W. Schwarz, *Compression of finite group
  actions and covariant dimension II*:
  https://arxiv.org/abs/0807.2016
- C. Voisin, *Rank 2 vector bundles and degrees of points of del Pezzo
  surfaces*, version 2:
  https://arxiv.org/abs/2509.17996
- A. Kresch and Yu. Tschinkel, *Linearizability notions in equivariant
  birational geometry*:
  https://arxiv.org/abs/2606.10965
- I. Cheltsov, I. Krylov, and S. Ma'u, *G-birationally rigid cubic
  threefolds*:
  https://arxiv.org/abs/2604.20426
- C. Spicer and L. Tasin, *Rank one foliations on toroidal varieties*:
  https://arxiv.org/abs/2604.08100
- F. Scavia, Yu. Tschinkel, and Zh. Zhang, *Birational invariance of higher
  Amitsur groups*:
  https://arxiv.org/abs/2605.02763
- S.-J. Jung and M. Saito, *Defect of projective hypersurfaces with isolated
  singularities*, v3, and *Factoriality of normal projective varieties*, v6,
  both revised 2026-07-27:
  https://arxiv.org/abs/2512.23522 and https://arxiv.org/abs/2601.13151
- A. Grothendieck, *SGA 2*, Expose XII, Corollaire 3.6, for the fixed-member
  Picard restriction theorem: https://arxiv.org/abs/math/0511279
- G. V. Ravindra and V. Srinivas, *The Grothendieck--Lefschetz theorem for
  normal projective varieties*, Theorem 1, for the general-slice class-group
  isomorphism: https://arxiv.org/abs/math/0511134
