# Problem F — resolution log

> **Final status (2026-07-28): RESOLVED — NEGATIVE.**  The exact
> \(\operatorname{PSL}_2(\mathbf F_7)\)-surface is not \(G\)-unirational.
> Earlier “open” and “first surviving degree \(36\)” statements below are
> retained as a chronological audit record and are superseded by the final
> all-degree exceptional-path theorem at the end of this file.  The
> earlier correction to the all-twists point criterion remains in force.

## 2026-07-28 — WP-0 literature triage (director; primary sources read, not search summaries)

### Preliminary verdict: the broad degree-2 class is open

**1. The class is explicitly open.**  Cheltsov–Tschinkel–Zhang, *Equivariant
unirationality of Fano threefolds* (manuscript dated July 18, 2026; arXiv
2502.19598 lineage), p. 2, read verbatim:

> "Duncan proved that Condition **(A)** is also sufficient for
> \(G\)-unirationality of del Pezzo surfaces of degree \(\ge 3\), with
> generically free actions [17, Theorem 1.4]. The cases of del Pezzo
> surfaces of degree 2 and 1 remain open."

Same source, p. 1–2: their (U) \(G\)-unirationality (dominant equivariant
\(\mathbf P(V)\dashrightarrow X\)) is equivalent to *very versality* in
Duncan–Reichstein terminology; \((L)\Rightarrow(SL)\Rightarrow(U)\);
**Condition (A)** — for every abelian subgroup \(A\subseteq G\),
\(X^A\ne\varnothing\) — is necessary for \(G\)-unirationality.  P. 3:
their smooth-cubic-threefold theorem retains
\(\operatorname{PSL}_2(\mathbf F_{11})\) on the Klein cubic among the
possible exceptions — consistent with Problem E's status.

This is a class-level statement, not by itself proof that the exact Klein
action is open.  The exact reference is A. Duncan, *Equivariant
unirationality of del Pezzo surfaces of degree 3 and 4*, Eur. J. Math.
**2** (2016), 897--916, arXiv:1410.8434, Theorem 1.4.  The later targeted
search recorded below found no source deciding the exact simple action.

**2. The essential-dimension invariant is already known — SPEC's
"expected reduction" was wrong and is corrected.**  Beauville, *Finite
simple groups of small essential dimension* (Trends in Contemporary
Mathematics, 2014), read directly:

- Proposition 16.3 (p. 223): *the simple finite groups of essential
  dimension 2 are \(\mathfrak A_5\) and
  \(\operatorname{PSL}_2(\mathbf F_7)\)* — via Duncan's classification
  (Comment. Math. Helv. **88** (2013), 555–585); the
  \(\operatorname{PSL}_2(\mathbf F_7)\) upper bound is realized by
  \(\mathbf P(V)\) for the 3-dimensional representation
  \(H^0(C,K_C)\), \(C\) the Klein quartic (p. 224).
- Beauville's "\(G\)-linearizable" = our \(G\)-unirational; so
  \(\mathbf P(V)\) itself is \(G\)-unirational, trivially, and it is the
  ed-2 witness.

Consequence: \(\operatorname{ed}_{\mathbf C}(G)=2\) carries NO leverage
on Problem F.  E's equivalence (problem ⟺ ed computation) rested on
Prokhorov's theorem that only two rationally connected threefolds carry
the \(\operatorname{PSL}_2(\mathbf F_{11})\)-action and they are
birational to each other; here the two minimal
\(\operatorname{PSL}_2(\mathbf F_7)\)-surfaces — \(\mathbf P(V)\) and
\(S\) (Cheltsov–Shramov: \(S\) is one of only two del Pezzo surfaces
with a faithful Klein-group action) — are NOT \(G\)-birational
(\(S\) non-linearizable by rigidity, to be re-cited in WP-1), so no
transfer exists.  SPEC's "expected reduction" section is superseded.
Condition (A) is a first necessary test, but not the governing equivalence:

> **Corrected frame.**  Condition (A) is necessary, and WP-1 below proves
> it for this action.  Duncan's own Example 1.9 already shows that the
> converse fails for a different group on the same degree-2 surface.
> The exact simple action therefore requires either a construction or an
> obstruction on its generic twist; neither essential dimension nor
> Condition (A) decides it.

**3. Adjacent literature collected for WP-2/WP-3** (from the same
sweep; to be read before use): CTZ §3 "general unirationality
constructions in the equivariant context" (the toolbox; their double-cover
constructions are the closest to \(S\)); Cheltsov–Shramov, *Nonrational
del Pezzo fibrations admitting an action of the Klein simple group*
(arXiv 1506.05564) and *On conjugacy classes of the Klein simple group in
the Cremona group* (arXiv 1310.5548) — background on the two minimal
models and rigidity; Salgado–Testa–Várilly-Alvarado (arXiv 1304.6798) for
the good-point unirationality theorem.  It is not an unconditional
arbitrary-point substitute for Kollár's cubic theorem.

### Status after triage

- WP-0 outcome gate: **(b) no literature resolution of the exact action
  found** — proceed.  Duncan's \(d\ge3\) theorem and CTZ's broad
  degree-\(2,1\) status delimit the class, while Duncan Example 1.9 rules
  out treating Condition (A) as a general degree-2 equivalence.
- SPEC corrected in the same commit (expected-reduction section replaced
  by the Condition-(A) frame).
- Next: WP-1 (action model + abelian fixed-point audit = Condition (A)
  for \((S,G)\)) is the first exact necessary-condition computation.

## 2026-07-28 — WP-1 exact action and abelian fixed-locus audit

### Verdict: Condition (A) PASSES; this is not a resolution of Problem F

The exact certificate
[`certificates/wp1_fixed_loci.py`](certificates/wp1_fixed_loci.py), with
proof note
[`certificates/WP1_FIXED_LOCI.md`](certificates/WP1_FIXED_LOCI.md), fixes
matrices \(D,P,J\in\operatorname{SL}_3(\mathbf Q(\zeta_7))\), verifies
\(q_4=x^3y+y^3z+z^3x\) is invariant on the nose, and enumerates their
168-element simple closure.  Its element-order census is

\[
1^1,\qquad 2^{21},\qquad 3^{56},\qquad 4^{42},\qquad 7^{48}.
\]

An exhaustive centralizer-adjunction enumeration finds precisely the
abelian subgroup types \(C_2,C_3,C_4,C_7,V_4\).  The cyclic types each form
one conjugacy class.  There are 14 Klein four subgroups in **two**
conjugacy classes of 7 each; merging these two classes would make the audit
incomplete.

For the honest lift fixing \(w\), an \(A\)-eigenline with character
\(\chi\) contributes its branch point if \(q_4=0\), while an off-branch
fiber is fixed exactly when \(\chi^2=1\).  Applying this criterion, with
exact branch evaluations, gives:

- \(S^{C_2}\): a smooth genus-one curve and two isolated points;
- \(S^{C_3}\): four points (two branch, two over the \(1\)-eigenline);
- \(S^{C_4}\): two points over the \(1\)-eigenline; the off-branch
  \(i\)- and \(-i\)-eigenline fibers are exchanged, not fixed;
- \(S^{C_7}\): three branch points;
- \(S^{V_4}\): six points for each of the two \(V_4\)-classes.

Thus \(S^A\ne\varnothing\) for every abelian \(A\leq G\).  Duncan,
*Equivariant unirationality of del Pezzo surfaces of degree 3 and 4*,
Eur. J. Math. **2** (2016), Proposition 2.5 and Corollary 2.6, supplies the
Going-Down necessary condition.  The calculation eliminates the proposed
quick negative route but supplies no converse in degree 2; Problem F
remains open at this boundary.

Replay (Python standard library only):

```text
$ python3 certificates/wp1_fixed_loci.py
...
Condition (A): PASS
WP1_FIXED_LOCI_OK
```

## 2026-07-28 — WP-3 exact low-degree Klein-covariant exclusions

### Verdict: five complete landing spaces excluded; Problem F remains open

The exact certificate
[`certificates/wp3_covariant_exclusions.py`](certificates/wp3_covariant_exclusions.py),
with proof note
[`certificates/WP3_COVARIANT_EXCLUSIONS.md`](certificates/WP3_COVARIANT_EXCLUSIONS.md),
constructs the classical invariants \(F,D,C,X\) and basic covariants
\(\mathrm{id},\psi,g_9,g_{11},\phi,f\).  It reconstructs \(g_9,g_{11}\)
from exact divisibility by \(X=\Phi_{21}\), and verifies

\[
7X\,\mathrm{id}=7C\psi-3D\phi+2Ff.
\]

Using the classical Molien statement that these six covariants freely
generate over \(\mathbf Q[F,D,C]\), the checker expands every pullback and
proves over characteristic zero that the **complete** homogeneous covariant
spaces in degrees

\[
d=9,11,15,18,22
\]

contain no nonzero \(p:V\to V\) with
\(q_4(p)=h^2\), \(h\) invariant of degree \(2d\).  The degree-22 elimination
uses four impossible-support coefficients; their common zero locus reduces
to the already-excluded degree-18 family and one isolated direction.  The
isolated pullback has leading term
\(4129544208384F^{19}D^2\), impossible for a square.

The same script then performs a clearly separated \(\mathbf F_{11}\) search
of every complete covariant space through degree 22 and finds no
\(\mathbf F_{11}\)-rational landing vector.  This finite-field result is
search guidance only: it does not exclude characteristic-zero coefficient
vectors over extensions or higher degrees.  The later structural entry
shows that every positive map can be returned to the homogeneous
\(V\)-covariant model, but higher even degrees remain.  Accordingly this
entry is a delimited negative, **not** a resolution of Problem F.

Replay (Python 3 plus SymPy; about 25 seconds on the recorded checkout):

```text
$ python3 certificates/wp3_covariant_exclusions.py
...
EXACT_EXCLUSIONS_OK degrees=9,11,15,18,22
...
MOD11_SCREEN_OK degrees<=22
WP3_COVARIANT_EXCLUSIONS_OK
```

## 2026-07-28 — WP-0/WP-2 correction: exact frontier and twist criterion

### Verdict: the exact action is open; two broader claims are withdrawn

The preliminary WP-0 framing was too strong in two independent ways.

First, Duncan's Theorem 1.4 proves Condition-(A) sufficiency only for
del Pezzo surfaces of degree at least 3.  It does **not** leave a viable
general degree-2 conjecture: Remark 1.8 and Example 1.9 of the same paper
use the Klein degree-2 surface with

\[
\langle\sigma\rangle\times(C_7\rtimes C_3)
\]

and show that every abelian subgroup has a fixed point although the action
is not unirational.  The essential-dimension obstruction uses the Geiser
factor, so it does not settle restriction to the exact simple subgroup
\(G=\operatorname{PSL}_2(\mathbf F_7)\).  The \(Q_8\) counterexamples of
Tschinkel–Zhang likewise do not restrict to \(G\), which contains no
quaternion subgroup.  Thus the correct literature verdict is: **OPEN for
this exact action**, not “the first unresolved degree-2 instance of a
general Condition-(A) conjecture.”

Second, Duncan–Reichstein Theorem 1.1 distinguishes:

\[
\text{weakly versal}\iff\text{every twist has a rational point},
\qquad
\text{very versal}\iff\text{every twist is unirational}.
\]

There is no unconditional arbitrary-field theorem upgrading every rational
point on every degree-2 del Pezzo surface to unirationality.  The
Salgado–Testa–Várilly-Alvarado theorem imposes a good-position hypothesis.
The blanket upgrade suggested in the preliminary entry is withdrawn.

For this exact \((S,G)\), a shorter group-specific argument recovers the
needed criterion.  Let \(V\) be the faithful irreducible
three-dimensional representation,
\(K_0=\mathbf C(\mathbf P(V))^G\), and let \(T_0\) be the projective
generic torsor.  Twisting adjunction identifies a \(K_0\)-point of
\({}^{T_0}S\) with a \(G\)-equivariant rational map
\(f:\mathbf P(V)\dashrightarrow S\).  For its image closure \(Z\):

- \(\dim Z\ne0\), since \(S^G=\varnothing\);
- if \(\dim Z=1\), then \(Z\) is a rational curve.  The action kernel is
  normal in the simple group \(G\), and it is not all of \(G\); hence
  \(G\hookrightarrow\operatorname{PGL}_2(\mathbf C)\), contradicting
  the classification of finite subgroups of \(\operatorname{PGL}_2\);
- therefore \(\dim Z=2\), and \(f\) is dominant.

Hence

\[
S\text{ is }G\text{-unirational}
\iff{}^{T_0}S(K_0)\ne\varnothing.
\]

In particular, weak and very versality happen to coincide for this exact
action, but by this image-dimension proof rather than a general theorem
about pointed degree-2 del Pezzo surfaces.

Additional geometry pinned in the same audit: Dolgachev–Iskovskikh §6.6,
Table 6 identifies this as Type I with
\(\operatorname{Aut}(S)=\langle\sigma\rangle\times G\) and
\(\operatorname{Pic}(S)^G=\mathbf ZK_S\); das Dores–Mauri, Theorem 1.5,
gives the relevant birational superrigidity.  These facts explain
non-linearizability but do not obstruct unirationality.

Primary references:

1. A. Duncan, *Equivariant unirationality of del Pezzo surfaces of degree
   3 and 4*, arXiv:1410.8434, Theorem 1.4, Remark 1.8, Example 1.9.
2. A. Duncan and Z. Reichstein, *Versality of algebraic group actions and
   rational points on twisted varieties*, arXiv:1109.6093, Theorem 1.1.
3. C. Salgado, D. Testa, and A. Várilly-Alvarado, *On the unirationality
   of del Pezzo surfaces of degree two*, arXiv:1304.6798, Theorem 1.2.
4. I. Dolgachev and V. Iskovskikh, *Finite subgroups of the plane Cremona
   group*, arXiv:math/0610595, §6.6 and Table 6.
5. T. das Dores and M. Mauri, *G-birational superrigidity of del Pezzo
   surfaces of degree 2 and 3*, arXiv:1808.05023, Theorem 1.5.
6. Y. Tschinkel and K. Zhang, arXiv:2504.10204v2, Theorem 3 and
   Table 4 (the separate \(Q_8\) degree-2 counterexamples).
7. I. Cheltsov, Y. Tschinkel, and K. Zhang, *Equivariant
   unirationality of Fano threefolds*, author manuscript dated
   2026-07-18, p. 2 (the broad degree-2/degree-1 status statement).

### Exact current boundary

At this stage WP-1 proved Condition (A), while the first WP-3 certificate
excluded five complete homogeneous covariant degrees.  The later entries
below sharpen this to an exhaustive homogeneous model with all degrees
through \(34\) excluded.

## 2026-07-28 — WP-3 structural all-degree parity theorem

### Verdict: odd degrees excluded; primitive even degree is at least 24

The proof note
[`certificates/WP3_STRUCTURAL_BOUND.md`](certificates/WP3_STRUCTURAL_BOUND.md)
strengthens the direct \(V\)-covariant audit without resolving the headline
problem.

For an involution \(t\), the fixed source line is
\(L_t=\mathbf P(E_-)\).  Its inverse image in \(S^t\) is a smooth elliptic
curve.  An odd-degree landing map would restrict to a constant
\(\mathbf P^1\to S^t\); equivariance would make that constant fixed by
\(C_G(t)\simeq D_8\).  But the two-dimensional \(D_8\)-module \(E_-\) has no
invariant line, so all primitive odd degrees are impossible.

In even degree, every one of the 21 involution lines is contracted to the
corresponding \(+1\)-eigenpoint.  Consequently their degree-21 product
\(X\) divides the Jacobian determinant \(J_p\).  If
\(F(p)=h^2\), a local chain-rule calculation along every irreducible factor
of \(h\) proves \(h\mid J_p\), including multiplicities.  The exact fixed
locus calculation gives \(F|_{E_+}\ne0\), so no involution line divides
\(h\); hence \(Xh\mid J_p\).  Degree comparison gives

\[
3(d-1)=\deg J_p\ge \deg X+\deg h=21+2d,
\]

so \(d\ge24\).  At \(d=24\), necessarily \(J_p=cXh\).

The homogeneous model is exhaustive.  Indeed, any dominant
\(G\)-map \(\mathbf P(V)\dashrightarrow S\) has a primitive homogeneous
base triple \(p\).  Equivariance makes \(p(gv)\) and \(gp(v)\) differ by a
constant character of \(G\), hence by \(1\) because \(G\) is perfect.
The weighted coordinate is a rational \(h\) with \(h^2=F(p)\); unique
factorization makes \(h\) polynomial, and perfectness makes it invariant.
Thus this excludes every possible landing degree \(d\le23\), not just the
five spaces checked in the low-degree script.  Higher even degrees remain
open; this is a structural bound, not a binary resolution of Problem F.

## 2026-07-28 — WP-3 exact degree-24 Jacobian exclusion

### Verdict: degree 24 excluded; first surviving homogeneous degree is 28

At degree 24 the complete even covariant space is

\[
p=AF^4\psi+BFD^2\psi+QF^2\phi+RDf.
\]

The structural identity specializes to \(J_p=\kappa Xh\).  The exact
checker
[certificates/wp3_degree24_jacobian.py](certificates/wp3_degree24_jacobian.py),
with proof note
[certificates/WP3_DEGREE24_EXCLUSION.md](certificates/WP3_DEGREE24_EXCLUSION.md),
fully reconstructs \(J_p/X\) in \(\mathbf Q[F,D,C]\) and verifies

\[
[DC^3](J_p/X)=0.
\]

Therefore \(h\) has no \(DC^3\) term, and its square has no
\(D^9C^3\) term.  The independent exact pullback decomposition gives

\[
[D^9C^3]F(p)=-2919616R^4,
\]

so \(R=0\).  The remaining covariant has a common factor \(F\); removing
it gives a primitive degree-20 landing identity, contradicting the
structural lower bound \(d\ge24\).  Hence the full degree-24 space is
excluded.

Degree 26 is impossible directly from \(J_p=Xhk\): the quotient \(k\)
would be a nonzero \(G\)-invariant of degree 2, while the Klein invariant
ring has no such element.  Since every odd degree is already excluded, the
first homogeneous \(V\)-covariant degree not yet ruled out is \(d=28\).
At that stage this was the full remaining generic-twist frontier; the next
entry excludes degree 28 as well.  Ruling out every surviving even degree
would resolve Problem F negatively, while finding one dominant landing
covariant would resolve it positively.

## 2026-07-28 — WP-3 exact degree-28 exclusion

### Verdict: degree 28 excluded; next homogeneous degree at this stage was 30

The exact checker
[certificates/wp3_degree28_exclusion.py](certificates/wp3_degree28_exclusion.py),
with proof note
[certificates/WP3_DEGREE28_EXCLUSION.md](certificates/WP3_DEGREE28_EXCLUSION.md),
handles the complete family

\[
p=AF^5\psi+BF^2D^2\psi+QDC\psi
 +RF^3\phi+SD^2\phi+TFDf.
\]

Here \(J_p=Xhk\) forces \(k\) to be a scalar multiple of \(F\), so
\(F\mid J_p/X\).  The two \(F\)-free Jacobian coefficients and the unique
impossible square-support coefficient split the family into a common-\(F\)
branch and four normalized branches.  With lexicographic variable order
\(C>D>F\), three branches have respective leading exponents

\[
(0,7,5),\qquad(3,5,5),\qquad(1,4,6),
\]

which cannot lead a square because an exponent coordinate is odd.  On the
last branch, three successive odd leading exponents force

\[
B=116/21,\qquad R=A=0.
\]

The resulting covariant is

\[
42p=D(42C\psi+232F^2D\psi-18D\phi+9Ff),
\]

so it has common factor \(D\) and reduces to the already excluded
degree-22 identity.  This exhausts degree 28.

Since all odd degrees and degrees 24, 26, and 28 are excluded, the first
homogeneous degree open at this stage was \(30\).  The homogeneous model is
exhaustive, so this was the full generic-twist frontier, not merely a
construction-method boundary.  The next two entries exclude degrees 30
and 32 as well.

## 2026-07-28 — WP-3 exact degree-30 exclusion

### Verdict: degree 30 excluded by exact residue and quotient-field elimination

The exact checker
[certificates/wp3_degree30_exclusion.py](certificates/wp3_degree30_exclusion.py),
with proof note
[certificates/WP3_DEGREE30_EXCLUSION.md](certificates/WP3_DEGREE30_EXCLUSION.md),
handles the complete seven-parameter family

\[
p=AF^4D\psi+BFD^3\psi+QF^2C\psi+RC\phi
  +SF^2D\phi+TF^3f+UD^2f.
\]

The structural identity has residual invariant \(k\) of degree 6, hence
\(k\) is a scalar multiple of \(D\).  Exact reduction modulo \(D\)
forces \(T=0\), and the remaining square discriminant factors as

\[
(Q-48R)^4
\cdot(Q^2-320QR+19328R^2)
\cdot(9Q^2-192QR+19840R^2).
\]

If \(R=0\), primitive reduction gives a common \(D\); otherwise normalize
\(R=1\).  The surviving ratios are \(48\) and the roots of the two
displayed quadratics.

Put \(K=J_p/(XD)\).  Six exact high-\(C\) coefficients of \(K\) and seven
of \(F(p)\) give cross-multiplied consequences of
\(K^2=\rho F(p)\).  The coefficient of \(FC^4\) in \(K\) excludes the
exceptional value \(U=-3\).  On the ratio-48 branch, a rational
substitution reduces the last equations to three polynomials whose exact
Gröbner basis is \([1]\).  On each quadratic pair, reduction in
\(\mathbf Q[Q]/(r(Q))\), with every denominator checked coprime to
\(r(Q)\), again gives the unit ideal.  This exhausts degree 30 over
characteristic zero.

The Jacobian coefficients are reconstructed by exact interpolation in the
known 18-dimensional invariant space of weight 66.  The checker asserts
the evaluation matrix invertible, so this is coefficient reconstruction,
not numerical sampling.  Replay ends with

```text
WP3_DEGREE30_EXCLUSION_OK
```

## 2026-07-28 — WP-3 exact degree-32 exclusion

### Verdict: degree 32 excluded; first surviving homogeneous degree is 34

The exact checker
[certificates/wp3_degree32_landing.py](certificates/wp3_degree32_landing.py),
with proof note
[certificates/WP3_DEGREE32_EXCLUSION.md](certificates/WP3_DEGREE32_EXCLUSION.md),
reduces the complete degree-32 family modulo \(F\).  Only the directions
\(PD^4\psi+UCf\) remain.  The three exact \(F\)-free coefficients of
the pullback show that its two forbidden outer support coefficients have
no common projective zero, hence \(P=U=0\).  Every remaining coordinate
has a common factor \(F\), and removing it gives the already-excluded
complete degree-28 family.

Thus all odd degrees and every even degree through 32 are excluded.  The
first homogeneous degree still open at that stage is \(34\).  This was
still a bounded result rather than a negative resolution of Problem F; the
next entry excludes degree 34 as well.

## 2026-07-28 — WP-3 exact degree-34 exclusion

### Verdict: degree 34 excluded; first surviving homogeneous degree is 36

The exact checker
[certificates/wp3_degree34_exclusion.py](certificates/wp3_degree34_exclusion.py),
with proof note
[certificates/WP3_DEGREE34_EXCLUSION.md](certificates/WP3_DEGREE34_EXCLUSION.md),
handles the complete nine-parameter family

\[
\begin{aligned}
p={}&AF^5D\psi+BF^2D^3\psi+QF^3C\psi+RD^2C\psi\\
 &+SF^3D\phi+TD^3\phi+UFC\phi+VF^4f+WFD^2f.
\end{aligned}
\]

Here \(J_p=Xh\,k\), and the degree-\(10\) residual invariant is a scalar
multiple of \(FD\).  Writing \(J_p=XFDK\), the landing equation therefore
forces \(K^2=\rho F(p)\) with \(\rho\ne0\).

Reduction modulo \(D\) first forces \(V=0\) and leaves either \(Q=U=0\) or
the five ratios encoded by

\[
(Q-48U)^4
(Q^2-320QU+19328U^2)
(9Q^2-192QU+19840U^2).
\]

The branch \(Q=U=0\) has a common factor \(D\) and reduces to the excluded
degree-28 family.  On every nonzero-ratio branch, the top \(C^8\)-support
forces \(R=0\).  The \(F\)-free Jacobian coefficient

\[
[D^{13}](J_p/X)=2239104T(6R+13T)(T+2W)
\]

then either produces a common factor \(F\), reducing to the excluded
degree-30 family, or gives \(W=-T/2\).  A further \(D\)-free coefficient
is

\[
[F^9C^3](J_p/X)
=102(Q-48U)(-14AU+5Q^2+14QS-312QU-2816U^2).
\]

The checker reconstructs \(J_p/X\) from an exact full-rank
\(24\times24\) invariant evaluation matrix.  On the ratio-\(48\) branch
and the two quadratic conjugate branch types, it saturates by adjoining
\(\rho Z-1\).  Exact Gröbner bases become the unit ideal after respectively
\(10\), \(13\), and \(13\) coefficient equations.  This exhausts degree 34
over characteristic zero.

The universal even quartic pullback used by the checker is stored in
[certificates/even_quartic_tensor.json](certificates/even_quartic_tensor.json);
[certificates/generate_even_quartic_tensor_cache.py](certificates/generate_even_quartic_tensor_cache.py)
reconstructs it exactly from the defining Klein covariants.  The replay
markers are

    EVEN_QUARTIC_TENSOR_CACHE_LOAD_OK terms=15
    WP3_DEGREE34_EXCLUSION_OK

Thus all odd degrees and every even degree through 34 are excluded.  At
that stage the first homogeneous degree still open was \(36\), and this
was the full generic-twist frontier.  It remained a bounded result; the
final all-degree entry below supersedes that frontier.

## 2026-07-28 — WP-2 index-one and higher-obstruction audit

### Verdict: index one and all Amitsur obstructions vanish; the rational point remains open

The full proof note is
[`certificates/WP2_TWIST_OBSTRUCTION_AUDIT.md`](certificates/WP2_TWIST_OBSTRUCTION_AUDIT.md).
It sharpens the earlier affine generic-torsor formulation to the projective
one

\[
L_0=\mathbf C(\mathbf P(V)),\qquad K_0=L_0^G,
\qquad T_0=\operatorname{Spec}L_0\longrightarrow\operatorname{Spec}K_0.
\]

The action on \(\mathbf P(V)\) is generically free and very versal because
it lifts to the honest representation \(V\) (Duncan--Reichstein,
Proposition 9.1).  Twisting adjunction and the simple-group image-dimension
argument give the exact two-parameter test

\[
S\text{ is }G\text{-unirational}
\iff({}^{T_0}S)(K_0)\ne\varnothing.
\]

For every field extension \(K/\mathbf C\) and every \(G\)-torsor \(T/K\),
the twist \(X={}^T S\) has two explicit effective zero-cycles:

- degree \(2\), by taking a \(K\)-point off the branch quartic in the split
  twisted anticanonical plane
  \({}^T\mathbf P(V)=\mathbf P(T\times^G V)\simeq\mathbf P^2_K\);
- degree \(21\), because a Sylow \(2\)-subgroup \(D_8\) fixes a point of
  \(S\), and \(T/D_8\to{}^T S\) has degree \([G:D_8]=21\).

The \(D_8\)-fixed point is uniform and elementary: the restriction of the
three-dimensional representation has a character line, every \(D_8\)
character squares to one, and the corresponding eigenline lifts through
the weighted double cover whether it lies on or off the branch quartic.
Thus

\[
\operatorname{ind}({}^T S)\mid\gcd(2,21)=1
\]

for **every** twist.  This is not a claim of Sylow-unirationality.

Colliot-Thélène Theorem 4.1 then supplies a closed point of degree \(1\),
\(3\), or \(7\) on each twist.  Remark 4.3 gives other degree-2 del Pezzo
surfaces of index one with a degree-3 point but no rational point, so this
cannot be upgraded formally to degree one.  Although the projective generic
field \(K_0\) is \(C_2\), the \(C_2\) variable bound does not force a point
on this weighted quartic.  In fact, the proof note shows that
Colliot-Thélène's degree-\(3/5\) counterexample may be chosen over the
rational \(C_2\) field \(\mathbf C(u,t)\), so \(C_2\) plus index one is
insufficient without using the special Klein torsor.

There is also no remaining universal-torsor or higher-Amitsur obstruction.
WP-1 gives fixed points for Sylow \(C_3\) and \(C_7\), and the preceding
argument gives one for Sylow \(D_8\).  Naturality followed by
restriction--corestriction gives
\(21\beta=56\beta=24\beta=0\).  Since these three indices have gcd one,
this proves

\[
\beta(S\righttoleftarrow G)=0.
\]

Scavia--Tschinkel--Zhang Theorem 1.2 therefore gives

\[
\operatorname{Am}^{n}(S\righttoleftarrow G,R)=0
\quad(n\ge2)
\]

for every split \(G\)-torus \(R\); the same conclusion follows directly
from their Theorem 5.1(2)--(3) by the Sylow fixed points.  The degree-3/7
Galois-closure audit in the proof note explains why simplicity and subgroup
indices do not finish the argument.  At that stage, the exact live boundary
was a degree-one point on \({}^{T_0}S\), or an obstruction finer than all
of the invariants just eliminated.  The final entry below supplies that
finer obstruction.

## 2026-07-28 — WP-3 all-degree exceptional-path obstruction

### Final verdict: RESOLVED — NEGATIVE

The full proof is
[certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md](certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md),
with exact finite inputs checked by
[certificates/wp3_all_degree_path_obstruction.py](certificates/wp3_all_degree_path_obstruction.py).
It proves

\[
\boxed{\text{The Klein degree-two del Pezzo surface is not }
G\text{-unirational}.}
\]

The proof closes the full generic-twist problem, not merely a bounded
covariant space.

**1. Exhaustive reduction and parity.**  The generic-torsor argument
identifies a point on \({}^{T_0}S\) with a \(G\)-equivariant rational map
\(\mathbf P(V)\dashrightarrow S\), and the image-dimension argument makes
every such map dominant.  Clearing factors yields the exhaustive primitive
identity

\[
p\in\operatorname{Cov}_G(V,V)_d,\qquad
h\in\mathbf C[V]^G_{2d},\qquad F(p)=h^2.
\]

WP3_STRUCTURAL_BOUND already excludes every odd \(d\).  It remains only
to rule out even \(d\), with no upper bound.

**2. Exact quadruple-point geometry.**  The 21 involution lines have 21
quadruple points and 28 triple points.  At a quadruple point \(q\), its
stabilizer \(H\) is \(D_8\).  Its unique central involution \(z\) satisfies
\(q=\mathbf P(E_+(z))\), and \(H\) has no invariant line in \(E_-(z)\).
For each of the four incident involutions \(s\), the four lines
\(\mathbf P(E_+(s))\) are pairwise distinct from one another and from
\(q\).  The checker verifies these statements over the exact
\(\mathbf Q(\zeta_7)\)-representation.

**3. The two endpoint values.**  In even degree, primitivity makes the
rational map generically defined on every involution line
\(L_s=\mathbf P(E_-(s))\), and homogeneity gives
\(p|_{E_-(s)}=a_s e_s\).  The landing equation then shows that the full
map is constant on \(L_s\), at one of the two points over
\(\mathbf P(E_+(s))\).  The four distinct incident values make \(q\) a
mandatory basepoint.

Blow the 21-point \(G\)-orbit.  The central exceptional
\(A_q=\mathbf P(T_q\mathbf P(V))\) is pointwise fixed by \(z\).  Every
involution fixed locus on \(S\) is a smooth genus-one curve plus two
isolated points, so the eventual morphism maps \(A_q\) constantly.
\(H\)-equivariance makes the constant \(H\)-fixed.  The commutator identity
\([H,H]=\{1,z\}\), together with the action of \(z\) as \(-1\) on
\(E_-(z)\), shows that the unique \(H\)-invariant projective line is
\(E_+(z)\).  Thus the central exceptional and the incident line have
distinct projected values.

**4. Equivariant point resolution.**  Compose the rational map with the
closed bicanonical embedding of \(S\), represented on the source by
\(p_i p_j\) and \(h\), all of degree \(2d\).  Primitivity makes the common
base scheme zero-dimensional and \(G\)-stable.  Functorial
principalization gives a \(G\)-equivariant sequence of point blowups and a
morphism \(f:X\to S\).  The same conclusion follows from the surface
transformed-basepoint algorithm applied to full \(G\)-orbits.

Fix an incident flag and put \(K=\langle z,s\rangle\simeq V_4\).  On the
first blowup the central exceptional and the strict involution line meet
at a \(K\)-fixed point \(r\).  In the reduced local total transform over
\(r\), the dual graph is a tree.  Its unique endpoint-to-endpoint path is
fixed componentwise by \(K\).

**5. Every path component is constant.**  An intermediate stable
component is an exceptional \(\mathbf P^1\).  Its final \(K\)-stability
descends through later equivariant blowdowns to its birth.  Its birth
center is therefore \(K\)-fixed, and the honest tangent representation
splits as \(\chi_1\oplus\chi_2\).  The exceptional action factors through
the single character \(\chi_1\chi_2^{-1}\), so some nonidentity involution
acts pointwise.  This is the special exceptional-born argument; an
abstract \(V_4\) can act faithfully on \(\mathbf P^1\).

Equivariance sends each path component into the fixed locus of its
pointwise involution.  That fixed locus contains no rational curve, so
the component maps constantly.  The same holds at the endpoints, using
\(z\) on \(A_q\) and \(s\) on \(L_s\).  Adjacent components meet, hence
their constant images agree.  Propagation along the path equates the two
endpoint values, contradicting their distinct projections.

Therefore no even-degree primitive landing identity exists.  Together
with the odd-degree theorem, no identity exists in any degree.  By the
generic-torsor equivalence,

\[
({}^{T_0}S)(K_0)=\varnothing,
\]

and Problem F has a negative answer.  The former degree-\(36\) frontier
and all earlier “open” statements are superseded by this theorem.

Replay from the repository root:

~~~text
PYTHONPATH=certificates python3 certificates/wp3_all_degree_path_obstruction.py
~~~

The exact output ends with:

~~~text
EXACT fixed loci: every involution has elliptic curve plus two points
EXACT flags: 21 D8 quadruple points and 84 incident V4 flags
EXACT endpoints: central and incident plus-eigenlines are distinct
EXACT near lines: all 84 central-incident lines are squarefree
WP3_ALL_DEGREE_PATH_OBSTRUCTION_OK
~~~

## 2026-07-28 — adversarial audit: SURVIVES; resolution ACCEPTED

Independent hostile audit (fresh-context reviewer, instructed to break the
proof; scratch verifications under `/private/tmp/audit_f/`) plus a full
director read.  Every finite input was RE-DERIVED from scratch in
independent `Q(ζ₇)` code rather than trusted from the shipped checkers;
two independent replays agree.  Highlights of what was independently
established, beyond re-verification:

- **The reduction needs less than advertised.**  The negative direction
  uses only weak versality (Duncan arXiv:1410.8434 §2.2's own chain), and
  was ALSO derived citation-free: replace `U` by `U ⊕ V` (generically
  free), twist by `T₀`, trivialize by Hilbert 90, land a `K₀`-point in the
  domain.  No pointed-dP2 theorem, no DR Thm 1.1 on the negative path.
- **The mandatory-basepoint step has a one-line proof the note omits:**
  for even degree, `p(e_z) ∈ V^H = 0` since `V|_{D₈} = δ ⊕ W` with `δ`
  nontrivial.  Verified live on the genuine degree-8 covariant
  `ψ = ∇F × ∇Hess F`, which contracts all 21 lines to their eigenpoints
  and vanishes at all 21 quadruple and 28 triple points.
- **The endpoint-forcing does real work:** in the local `K`-adapted model,
  a generic even covariant maps `A_q` ONTO the line `L_z`; it is the
  landing equation plus "no rational curve in `S^z`" that pins the value
  over `q`.  The path lemma's three elided steps (SNC preservation,
  centers over `r` lie on the divisor, connectedness of `μ⁻¹(r)`) were
  checked; the birth-center character argument covers both the trivial and
  nontrivial `χ₁χ₂` cases; the single conjugacy class of involutions
  (sizes 1, 21, 56, 42, 24, 24) was recomputed, so fixed-locus fact (2)
  applies to every `t_C ∈ {z, s, zs}`.
- **Literature cross-checks:** Duncan's Example 1.9 read verbatim — group
  `C₂ × (C₇⋊C₃)` with the Geiser factor, no containment either way, no
  interaction; Duncan's ed-2 "degree 2" case only pushes versality down to
  `P²` and does not decide this surface.  The problem really was open.

**Strengthening recorded:** the proof never uses dominance, so it shows
there is NO nonconstant `G`-equivariant rational map `P(V) ⇢ S` — `S` is
not even `G`-weakly versal, and the generic twist has no `K₀`-point at
all.

Soft spots noted, none load-bearing: the principalization phrasing is glib
(fine here because the base scheme is 0-dimensional, and the orbit-blowup
alternative is supplied); the tree lemma's elided steps (verified); one
stale frontier line in `WP3_STRUCTURAL_BOUND.md` §5 (fixed editorially in
this commit).  The degree-24/28/30/32/34 certificates are retained as
historical scaffolding and are logically redundant.

**Problem F is closed: the Klein degree-2 del Pezzo surface is not
`PSL₂(𝔽₇)`-unirational.**  This is the first decided case of degree-2
equivariant unirationality, against the direction Duncan's `d ≥ 3`
sufficiency theorem might have suggested.  Write-up positioning (novelty
of the path-obstruction mechanism vs. antecedents) is under a separate
literature sweep and will be logged when it lands.
