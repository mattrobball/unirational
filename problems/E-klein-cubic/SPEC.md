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

> **Status (checked 2026-07-26).**  The problem is open.  The updated
> July 18, 2026 manuscript of Cheltsov--Tschinkel--Zhang explicitly retains
> the \(G\)-action on the Klein cubic as an exception whose equivariant
> unirationality is unknown.

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

## Current certified progress (2026-07-26)

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
4. good-reduction, exact Gröbner, and scalar-quotient certificates extending
   that bounded exclusion through degree fourteen;
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
   nor universal nonvanishing is known;
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
   homogeneous degree-four bottleneck.  A future bounded continuation must
   first use the decomposable-plus-primitive coordinate splitting or a
   checkpoint-capable solver; a standard chart sweep is stopped.
   Five explicit degree-eight covariants give a
   generic frame over \(\mathbf C(\mathbf P(V_6))^G\), hence an all-degree
   normal form for rational projective-source maps; all ten coordinate lines
   in that frame are empty, but points using at least three coordinates remain
   open;
10. the exact Kraft--Loetscher--Schwarz criterion
   \(\operatorname{ed}(G)=3\) iff some nonzero homogeneous self-covariant has
   identically zero Jacobian, together with a complete dominance exclusion
   through degree eleven.  In degree eleven the complete 12-dimensional
   space gives 496 exact Jacobian quintics, and all twelve projective charts
   are unit ideals at the good prime 67.  Voisin's current construction makes \(X^{[3]}\)
   \(G\)-very-versal, but after pulling the universal marked cover back along
   her parameterization, the marked source is birationally fibered over \(X\)
   itself and hence does not solve the required point-selection problem. This
   finite dominance exclusion has no all-degree cutoff; and
11. an exact `xCD` ternary-cubic and Jacobian model, a certified
   finite-field flex-torsor presentation, and a genuine-versus-fake descent
   audit. The finite-field rank computations are nonverdicts and do not
   transfer to the generic characteristic-zero plane. Exhaustive generic
   descent now has exact formulas for all ten invariant generators, but still
   requires the certified Hironaka basis and invariant-field multiplication
   table, followed by the distinct \(E[3]\) Kummer algebra or the
   three-flex-line algebra for true second descent.

The generic-twist frame reduces E2 to finding a nonzero invariant-field
solution of \(F([x\ C\ D\ E\ K]a)=0\).  The degree bound in item 4 is finite
and therefore cannot support a negative verdict. In degree twelve the full
16-dimensional reduced covariant basis gives 143 independent landing cubics;
an exact finite-field Gröbner basis has Hilbert function zero in degree five.
Degree thirteen is excluded by a separate scalar-quotient reduction: 48
necessary cubics on \(M_{13}/fM_{10}\) force the scalar plane, and exact
degree-ten and tangent leading ideals eliminate both possible lifts. An
independent completed 21-variable q67 Gröbner calculation gives an Artinian
leading ideal and corroborates the same bounded exclusion. The next
unrestricted homogeneous degree is fourteen. On the projective
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
chart sweep are stopped; the degree-twelve locus remains undecided. The degree-eight rational
frame is exhaustive in all degrees, but only its ten coordinate lines are
excluded; its ternary and larger supports remain open. On the Pfaffian target the full
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

For this simple group, dominance of a nonzero landing self-covariant also
follows from the generic-image argument above: its image is a faithful very
versal subvariety, hence has dimension at least
\(\operatorname{ed}(G)\ge3\), and therefore equals the threefold \(X\).
Moreover, maps from other honest linear sources do not evade this search: a
generic-torsor point lifts to a rational \(W\)-valued covariant; after clearing
an invariant denominator, the highest homogeneous part is itself a nonzero
landing self-covariant.

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
the exhaustive degree-eight frame are excluded; ternary and larger frame
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
