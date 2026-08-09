# Full-group graph localization and the first `V4` exceptional state

**Date:** 2026-08-08

**Field:** \(\mathbf C\)

**Group:** \(G=\operatorname {PSL}_2(\mathbf F_{11})\)

**Verdict:** the isolated fixed-point degree equations are formally
surjective; the first `V4` exceptional layer has one locally regular type-I
state; neither statement produces a genuine graph or decides the headline

Let \(X\) be the Klein cubic threefold.  Suppose only for the purpose of
deriving necessary conditions that

\[
 \varphi:X\dashrightarrow X
\]

is a dominant `G`-equivariant rational selfmap of degree \(\delta>0\), and
let \(\Gamma\subset X\times X\) be the closure of its graph.  Thus

\[
 (\operatorname {pr}_1)_*[\Gamma]=[X],\qquad
 (\operatorname {pr}_2)_*[\Gamma]=\delta[X].
 \tag{0.1}
\]

This packet records what follows from the fixed restrictions of the cycle
class \([\Gamma]\).  It deliberately does **not** assert that the formal
fixed restrictions constructed below are realized by an irreducible graph,
a rational selfmap, an ambient landing covariant, or a base ideal.

## 1. The `C11` graph equations

Fix \(P=C_{11}\) and write its five fixed points as \(p_i\), with weights

\[
 q_i=9^i=(1,9,4,3,5)\in\mathbf F_{11}^{*}.
\]

At \(p_i\), the tangent weights of \(X\) are

\[
 q_i(q_2-1),\quad q_i(q_3-1),\quad q_i(q_4-1),
\]

so, for \(t=c_1(\chi_1)\),

\[
 e(T_{p_i}X)=2q_i^3t^3,\qquad
 c_1^P(\mathcal O_X(1))|_{p_i}=-q_it.
 \tag{1.1}
\]

The sign in the second formula is important: it gives

\[
 \sum_i\frac{(-q_it)^3}{2q_i^3t^3}=3
 \quad\text{in }\mathbf F_{11},
\]

as required by \(H^3=3\).

The normalizer quotient \(N_G(P)/P=C_5\) acts regularly on the five fixed
points.  Hence the restriction of the codimension-three class
\([\Gamma]\) at the pair \((p_i,p_{i+s})\) has the form

\[
 i_{i,i+s}^{*}[\Gamma]=q_i^3k_st^3,
 \qquad k_s\in\mathbf F_{11}.
 \tag{1.2}
\]

Applying fixed-point pushforward to the two projections in (0.1) gives the
two exact equations

\[
 \boxed{\quad
  \sum_{s=0}^{4}k_sq_s^{-3}=2,
  \qquad
  \sum_{s=0}^{4}k_s=2\delta
  \quad}\pmod {11}.
 \tag{1.3}
\]

Indeed, the first row sum divides (1.2) by
\(e(T_{p_{i+s}}X)=2q_i^3q_s^3t^3\), while a fixed target column divides by
\(e(T_{p_i}X)\), making every summand \(k_s/2\).

### Theorem 1.1: no degree congruence modulo eleven

For every \(\delta\in\mathbf F_{11}\), equations (1.3) have the two-channel
solution

\[
 k_0=3-\delta,\qquad
 k_1=8(1-\delta),\qquad
 k_2=k_3=k_4=0.
 \tag{1.4}
\]

Thus arbitrary-resolution `C11` graph localization imposes no congruence on
\(\delta\).

This remains compatible with all twelve Sylow-eleven presentations.  The
union of the Sylow-fixed points is the transitive `G`-set \(G/P\).  The five
channels in (1.2) are precisely the five `G`-orbitals

\[
 (gP,gnP),\qquad n\in N_G(P)/P,
\]

whose two entries have the same Sylow stabilizer.  Conjugating \(P\) merely
transports the same five orbital coefficients; it adds no new linear
equation.

## 2. An explicit formal degree-two counterconfiguration

Take \(\delta=2\).  Equation (1.4) becomes

\[
 (k_0,k_1,k_2,k_3,k_4)=(1,3,0,0,0).
 \tag{2.1}
\]

Let

\[
 a_b=\int_{\Gamma}H_1^{3-b}H_2^b,
 \qquad 0\le b\le3.
\]

Localization on \(X\times X\) gives

\[
 a_b\equiv
 -\frac54\sum_sk_sq_s^{b-3}
 =7\sum_sk_sq_s^{b-3}\pmod {11}.
 \tag{2.2}
\]

For (2.1), this is

\[
 (a_0,a_1,a_2,a_3)\equiv(3,4,2,6)\pmod {11}.
 \tag{2.3}
\]

The residue vector has the positive integral lift

\[
 (a_0,a_1,a_2,a_3)=(3,81,24,6).
 \tag{2.4}
\]

It satisfies every immediate numerical condition:

\[
 a_1=3d\text{ with }d=27,\qquad a_3=3\delta,
\]

and the Khovanskii--Teissier inequalities

\[
 81^2\ge3\cdot24,\qquad 24^2\ge81\cdot6.
\]

Consequently, fixed restrictions, projection multiplicities, positivity,
integrality, and log-concavity do not rule out \(\delta=2\).  The datum
(2.1)--(2.4) is a **formal equivariant-Chow counterconfiguration only**.
It is not claimed to be the localization of an effective irreducible graph.

## 3. The `V4` parity equation is also formally soluble

Fix \(V\cong V_4\).  The exact target fixed locus is six reduced points,
split into two free orbits under \(N_G(V)/V=C_3\):

\[
 X^V=I_0\sqcup I_1\sqcup I_2\sqcup
      II_0\sqcup II_1\sqcup II_2.
\]

At every one of the six points,

\[
 T_xX=\chi_1\oplus\chi_2\oplus\chi_3,
\]

so over \(\mathbf F_2\) all tangent Euler classes equal

\[
 e=uv(u+v).
\]

After dividing a graph fixed restriction by \(e\), the two projection
conditions are simply: every source row sums to one and every target column
sums to \(\delta\pmod2\).

For even \(\delta\), the residual-`C3`-equivariant matrix

\[
 I_i\longmapsto I_i,\qquad II_i\longmapsto I_i
 \tag{3.1}
\]

has every row sum one and every column sum zero.  For odd \(\delta\), use
the identity on both three-point orbits.  Since both target orbits are
`G`-sets isomorphic to \(G/V\), these matrices transport over the full
`G`-orbits.  Hence isolated `V4` graph localization gives no parity
constraint on \(\delta\).

Again, (3.1) is a formal fixed-restriction matrix, not a graph.

## 4. The theorem-forced first exceptional layer over a `V4` line

The ambient source has

\[
 \operatorname {Fix}(V,\mathbf P(W))
 =\ell_V\sqcup\{B,C,D\},
\]

where \(\ell_V\cong\mathbf P^1\) is pointwise fixed and

\[
 N_{\ell_V/\mathbf P(W)}
 =\chi_B\oplus\chi_C\oplus\chi_D.
 \tag{4.1}
\]

The residual `C3` cycles \(B,C,D\) and acts on \(\ell_V\) with two fixed
`A4` endpoints.  On the target, \(X^V\) consists of the two free residual
orbits `I` and `II`, with no residual fixed point.  Therefore a hypothetical
ambient landing map is undefined at the generic point of every
\(\ell_V\): a regular restriction would be constant in the finite set
\(X^V\), and residual equivariance would require a fixed target point.

Blowing up \(\ell_V\) produces three `V`-fixed exceptional sections

\[
 S_B,S_C,S_D,
\]

cycled by the residual `C3`.  If the lifted map is regular at their generic
points, equivariance gives two orbit types, `I` or `II`, and three possible
cyclic phases.

### Theorem 4.1: one first-layer state survives

Label the three involutions in \(V\) by \(z,s,r\) so that the plus section
is respectively

\[
 S_B,\quad S_C,\quad S_D.
\]

For each involution, the other two sections lie in one connected rational
\(\mathbf P^1\)-bundle component of the involution-fixed exceptional locus.
The type-I vertices have the identical incidence labeling:

\[
 P_B\in E_z,\qquad P_C\in E_s,
 \qquad P_D\in E_r,
\]

and each lies on the other two rational lines \(L_\sigma\).

Among the three residual-equivariant bijections
\(S_i\mapsto P_{\rho^ki}\), only \(k=0\) can be regular on the first
involution-fixed exceptional components.  For \(k=1,2\), the connected
minus component for some involution contains two sections whose images lie
in the two disjoint components \(E_\sigma\) and \(L_\sigma\) of
\(X^\sigma\).  Thus those phases force another base layer.

For a type-II assignment, all three target points lie on every relevant
elliptic curve \(E_\sigma\).  The two minus sections for a fixed involution
would map to two distinct points of \(E_\sigma\).  A morphism from the
connected rational exceptional \(\mathbf P^1\)-bundle to an elliptic curve
is constant, so every type-II phase also forces another base layer.

The unique state not forced deeper at this stage is therefore

\[
 \boxed{S_B\mapsto P_B,\quad S_C\mapsto P_C,\quad S_D\mapsto P_D.}
 \tag{4.2}
\]

It is the incidence-preserving type-I state.

## 5. `D12` and `A4` do not kill the surviving state

The 55 `V4` lines meet three at a time at the 55 `D12` points.  Blow up the
`D12` orbit first.  At such a point,

\[
 W|_{D12}=\mathbf1\oplus\mathrm{std}
             \oplus(\varepsilon\otimes\mathrm{std}),
\]

so the projective tangent representation is

\[
 \mathrm{std}\oplus(\varepsilon\otimes\mathrm{std}).
\]

It has no one-dimensional `D12` subrepresentation.  Hence the exceptional
\(\mathbf P^3\) has no `D12`-fixed point, and the three strict `V4` lines
are separated.

At either `A4` endpoint of \(\ell_V\),

\[
 W|_{A4}=\chi\oplus\chi^2\oplus\mathbf3,
\]

and the normal representation of \(\ell_V\) is the irreducible
three-dimensional representation.  Blowing up \(\ell_V\) replaces the
endpoint by \(\mathbf P(\mathbf3)\), which has no `A4`-fixed point.

Thus the standard stratified blowup order removes the empty-target `D12`
and `A4` fixed strata without imposing a further binary condition.  The
state (4.2) transports compatibly under both stabilizers.  This explains why
the finite first-layer CSP is nonempty and why any negative proof must use
the higher landing jets and the actual base ideal.

## 6. Exact boundary

The proved statements are:

```text
FULL-G-C11-GRAPH-DEGREE-EQUATIONS
FULL-G-C11-GRAPH-DEGREE-RESIDUES-FORMALLY-SURJECTIVE
FULL-G-C11-DELTA2-FORMAL-COUNTERCONFIGURATION
FULL-G-V4-GRAPH-PARITY-FORMALLY-SURJECTIVE
FULL-G-V4-LINE-FORCED-IN-AMBIENT-BASE
FULL-G-V4-FIRST-LAYER-UNIQUE-TYPEI-SURVIVOR
FULL-G-V4-TYPEII-FORCES-DEEPER-BASE
FULL-G-D12-A4-FIRST-LAYER-COMPATIBLE
FORMAL-LOCALIZATION-CSP-DATA-NOT-A-GENUINE-GRAPH
PSL-KLEIN-QUESTION-OPEN
```

No bounded CAS run on the equations in this packet can close the headline:
the equations have explicit solutions.  A decisive finite computation would
need a theorem reducing the higher base-ideal/landing-jet tower to a finite
set of realizability conditions.  No such reduction is asserted here.
