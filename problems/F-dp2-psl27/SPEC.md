# Problem F — PSL(2,7)-unirationality of the degree-2 del Pezzo surface

## Convention and status

Work over \(k=\mathbf C\).  Put

\[
G=\operatorname{PSL}_2(\mathbf F_7)\;(\cong\operatorname{GL}_3(\mathbf F_2)),
\qquad |G|=168,
\]

and let \(V\) be one of the two (complex-conjugate) faithful irreducible
three-dimensional representations of \(G\).  The choice between the two
conjugate representations is immaterial to every statement below; fix one
once and record the choice in any computation.  The classical ring of
invariants \(\mathbf C[V]^G\) is generated in degrees \(4, 6, 14\) (and
\(21\)); write \(q_4\) for the degree-4 generator, unique up to scalar.  In
suitable coordinates

\[
q_4 = x^3y + y^3z + z^3x,
\]

the Klein quartic, with \(\operatorname{Aut}\{q_4=0\}=G\) acting through
\(\mathbf P(V)\).

Let \(S\) be the del Pezzo surface of degree 2 obtained as the double cover
of \(\mathbf P(V)\) branched over the Klein quartic:

\[
S=\{w^2=q_4(x,y,z)\}\subset\mathbf P(1,1,1,2).
\]

Because \(G\) is simple, \(q_4\) is invariant on the nose (no character
twist), so the action of \(G\) on \(V\oplus\mathbf C\,w\) (trivial action
on \(w\)) restricts to an honest action \(G\curvearrowright S\) — an
action of the group itself, not of a central extension.  The full
automorphism group is \(\operatorname{Aut}(S)=G\times\langle\sigma\rangle\)
with \(\sigma\) the Geiser involution \(w\mapsto-w\).  **(verify:** the
`Aut` computation is classical — Dolgachev–Iskovskikh tables — but re-cite
it before relying on it.**)**

> **Status (WP-0 triage on record, 2026-07-28 — `RESOLUTION.md`).**  OPEN.
> Cheltsov–Tschinkel–Zhang (July 18, 2026, p. 2) state verbatim that for
> equivariant unirationality "the cases of del Pezzo surfaces of degree 2
> and 1 remain open"; Duncan's Condition-(A) sufficiency stops at degree
> \(\ge 3\).  See "The governing frame" below.

As in Problem E, *\(G\)-linearizable* is reserved for equivariant
birationality to a linear action.  For this \(S\) linearizability is
expected to FAIL for the classical rigidity reason (minimal del Pezzo
surface of degree \(\le 3\) with \(G\)-invariant Picard rank 1 —
**verify** \(\operatorname{rk}\operatorname{Pic}(S)^G=1\) and the
Dolgachev–Iskovskikh/Cheltsov rigidity citation as part of WP-1).  The
target here is only \(G\)-unirationality, also called *very versality*.

## Problem statement

> **Problem F.**  Prove or disprove that the degree-2 del Pezzo surface
> \(S\) above is \(G\)-unirational for
> \(G=\operatorname{PSL}_2(\mathbf F_7)\): decide whether there exist a
> finite-dimensional complex linear representation \(U\) of \(G\) and a
> dominant \(G\)-equivariant rational map
> \[
> U\dashrightarrow S.
> \]

Binary, unconditional target, same standard as Problem E: a proof
conditional on an unproved conjecture is not a resolution unless that
conjecture is proved in the required case.

Ordinary unirationality of \(S\) is classical (a del Pezzo surface over
\(\mathbf C\) is rational) and does not address the problem.

## Equivalent formulations (mirror of Problem E, with one genuine change)

The Duncan–Reichstein equivalences (their Theorems 1.1, 10.3, 10.5) apply
to \(S\) exactly as to the Klein cubic: for \(K/\mathbf C\) a field
extension and \(T\to\operatorname{Spec}K\) a \(G\)-torsor, the twist
\({}^{T}S\) is again a degree-2 del Pezzo surface over \(K\) (the action
lifts to the weighted-linear action on \(V\oplus\mathbf C w\)), and

\[
S\ \text{is } G\text{-unirational}
\iff S\ \text{very versal}
\iff {}^{T}S(K)\ne\varnothing\ \ \forall\,(T,K).
\]

**The genuine change from E:** the final upgrade "twist has a point
\(\Rightarrow\) twist is \(K\)-unirational" used Kollár's cubic
hypersurface theorem in Problem E.  For del Pezzo surfaces of degree 2 the
corresponding statement is the Salgado–Testa–Várilly-Alvarado /
Festi–van Luijk circle of results (unirationality of a dP2 with a rational
point, with hypotheses on the position of the point in the earlier papers
and unconditional statements in the later literature — **verify the exact
unconditional statement over an arbitrary field of characteristic 0**
before using it; every \(K/\mathbf C\) here is infinite of characteristic
0, the friendly case).  Whether this step is available unconditionally
changes the shape of WP-2 and must be pinned first.

The single generic-torsor reduction of Problem E carries over verbatim in
one direction and with one open verification in the other:
\(K_{\mathrm{gen}}=\mathbf C(V)^G\), \(T_{\mathrm{gen}}\) the generic
torsor; a rational point on \({}^{T_{\mathrm{gen}}}S\) over
\(K_{\mathrm{gen}}\) is, by twisting adjunction, a \(G\)-equivariant
rational map \(V\dashrightarrow S\), whose image closure \(Z\) is very
versal with faithful \(G\)-action (simplicity of \(G\) plus
\(S^G=\varnothing\), as in E).  The E-argument then used
\(\operatorname{ed}(G)\ge3\) to force \(Z=X\); here the analogous fork is
the heart of the problem:

- if \(\dim Z=2\) then \(Z=S\) and \(S\) is \(G\)-unirational;
- if \(\dim Z\le1\): a faithful \(G\)-action on a rational or unirational
  curve is impossible for noncyclic nonpolyhedral \(G\) — \(G\) is not a
  subgroup of \(\operatorname{PGL}_2(\mathbf C)\) (**verify:** the finite
  subgroups of \(\operatorname{PGL}_2\) are cyclic, dihedral, \(A_4\),
  \(S_4\), \(A_5\); \(\operatorname{PSL}_2(\mathbf F_7)\) is none of
  these), so \(\dim Z\ne1\) and \(\dim Z\ne0\) (no fixed point).

Hence, unconditionally once the listed verifications are recorded:

\[
S\ \text{is }G\text{-unirational}
\iff
{}^{T_{\mathrm{gen}}}S(K_{\mathrm{gen}})\ne\varnothing .
\]

## The governing frame (corrected by WP-0 triage, 2026-07-28 — see RESOLUTION.md)

The originally drafted "expected reduction" to an essential-dimension
computation is WRONG and is withdrawn: Duncan's classification (Comment.
Math. Helv. 88 (2013); simple-group case restated in Beauville,
Proposition 16.3) already gives \(\operatorname{ed}_{\mathbf C}(G)=2\),
realized by \(\mathbf P(V)\) — which is trivially \(G\)-unirational and is
NOT \(G\)-birational to \(S\).  Unlike Problem E (where Prokhorov's
classification makes the two candidate threefolds birational, welding the
problem to the open ed computation), the known ed value carries no
leverage on \(S\).

The correct frame is Duncan's Condition-(A) frontier, quoted in
Cheltsov–Tschinkel–Zhang (July 18, 2026, p. 2): Condition **(A)** — every
abelian subgroup has a fixed point — is necessary for
\(G\)-unirationality; Duncan proved it sufficient for del Pezzo surfaces
of degree \(\ge3\) [CTZ's ref. 17, Theorem 1.4]; **"the cases of del
Pezzo surfaces of degree 2 and 1 remain open."**  Problem F is that open
case at its most symmetric instance:

- if the WP-1 audit finds an abelian \(A\subseteq G\) with
  \(S^A=\varnothing\), Problem F is resolved NEGATIVELY on the spot;
- if (A) holds for \((S,G)\), Problem F becomes a sharp test of whether
  Duncan's sufficiency extends to degree 2 — a positive resolution is the
  first degree-2 case, a negative one refutes the natural conjecture at
  its hardest instance.

Either outcome is a publishable unit and neither disturbs a major
conjecture — the precise cash value of the motivating suggestion.

## Unconditional starting points (to be re-verified before first use)

1. \(S^G=\varnothing\): \(V\) irreducible forces
   \(\mathbf P(V)^G=\varnothing\), and \(S\to\mathbf P(V)\) is
   \(G\)-equivariant.
2. Sylow and abelian fixed points: for each
   \(p\in\{2,3,7\}\) and each abelian \(A\subseteq G\)
   (\(\mathbf Z/7,\ \mathbf Z/4,\ \mathbf Z/3,\ \mathbf Z/2\times\mathbf
   Z/2,\dots\)), decide whether \(S^{A}\ne\varnothing\).  A single abelian
   subgroup with \(S^A=\varnothing\) DISPROVES very versality outright
   (Reichstein–Youssin-type necessary condition — cite the exact statement
   when used) and resolves the problem negatively.  Note the order-7 and
   order-3 elements act on the two \(w\)-preimages of a fixed point of
   \(\mathbf P(V)\) trivially (odd order), so their fixed points lift; the
   2-groups are where a surprise could hide.
3. The 56 exceptional curves of \(S\) carry a \(G\)-action; its orbit
   structure (and \(\operatorname{rk}\operatorname{Pic}(S)^G\)) is
   computable exactly and is WP-1 material.

## What a resolution consists of

Same standard as Problem E: a `certificates/` package containing either a
\(G\)-equivariant dominant rational map from a representation (positive
resolution — explicit polynomials, machine-checkable equivariance and
dominance), or a proof that some twist has no \(K\)-point / some abelian
subgroup has empty fixed locus / \(\operatorname{ed}(G)=3\) together with
the reduction (negative resolution).  Partial results, delimitations of
routes, and failed-construction post-mortems go to `RESOLUTION.md` with
dates, in the E house style.
