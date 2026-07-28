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
automorphism group is \(\operatorname{Aut}(S)=G\times\langle\sigma\rangle\),
with \(\sigma\) the Geiser involution \(w\mapsto-w\); this is Type I in
Dolgachev–Iskovskikh, §6.6 and Table 6.

> **Status (resolved 2026-07-28 — RESOLUTION.md).**  **NEGATIVE** for this
> exact \(\operatorname{PSL}_2(\mathbf F_7)\)-action: \(S\) is not
> \(G\)-unirational.  The final proof is the all-degree
> \(V_4\)-exceptional-path obstruction in
> certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md.  Condition (A), index
> one, and the higher-Amitsur tests all pass; the obstruction is strictly
> finer than those necessary conditions.

As in Problem E, *\(G\)-linearizable* is reserved for equivariant
birationality to a linear action.  This \(S\) is not \(G\)-linearizable:
the action is minimal, \(\operatorname{Pic}(S)^G=\mathbf ZK_S\), and the
Klein degree-2 del Pezzo action is \(G\)-birationally superrigid (see
Dolgachev–Iskovskikh, §6.6, and das Dores–Mauri, Theorem 1.5).  The target
here is only \(G\)-unirationality, also called *very versality*.

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

## Equivalent formulations (weak versus very versality)

For a field extension \(K/\mathbf C\) and a \(G\)-torsor
\(T\to\operatorname{Spec}K\), the twist \({}^{T}S\) is again a degree-2
del Pezzo surface over \(K\).  Duncan–Reichstein, Theorem 1.1, makes two
different assertions:

\[
S\ \text{is weakly versal}
\iff {}^{T}S(K)\ne\varnothing\quad\text{for every }(T,K),
\]

whereas

\[
S\ \text{is }G\text{-unirational (very versal)}
\iff {}^{T}S\ \text{is }K\text{-unirational}\quad\text{for every }(T,K).
\]

There is no known theorem that an arbitrary degree-2 del Pezzo surface over
an arbitrary characteristic-zero field is unirational as soon as it has a
rational point.  Salgado–Testa–Várilly-Alvarado prove the implication for a
point satisfying explicit general-position hypotheses; that result cannot
be silently upgraded for an arbitrary twist.

For this particular simple group and surface, however, the single generic
torsor already detects dominance.  Put
\(K_0=\mathbf C(\mathbf P(V))^G\), and let \(T_0\) be the generic
torsor
\(\operatorname{Spec}\mathbf C(\mathbf P(V))\to\operatorname{Spec}K_0\).
By twisting adjunction, a
\(K_0\)-point of \({}^{T_0}S\) is a
\(G\)-equivariant rational map \(\mathbf P(V)\dashrightarrow S\).  Let \(Z\) be
the image closure.  Then:

- \(Z\) cannot be a point, because \(S^G=\varnothing\);
- if \(Z\) is a curve, it is unirational and hence rational.  The kernel
  of the induced action on \(Z\) is normal in the simple group \(G\); it
  cannot be all of \(G\), so the action is faithful.  This would embed
  \(G\) in \(\operatorname{PGL}_2(\mathbf C)\), impossible by the
  classification of finite subgroups of \(\operatorname{PGL}_2\);
- hence \(\dim Z=2\), so the map is dominant.

Consequently the following equivalence is unconditional and specific to
this action:

\[
S\ \text{is }G\text{-unirational}
\iff
{}^{T_0}S(K_0)\ne\varnothing .
\]

It also implies that weak and very versality coincide for this action:
weak versality supplies the generic point, and the preceding argument
makes the resulting map dominant.  This special argument, not a general
"point implies unirational" theorem for degree-2 del Pezzo surfaces, is
the reason the all-twists point criterion is valid here.

### Exhaustive homogeneous form and all-degree obstruction

The generic-map criterion turns the problem into an exact invariant-theory
equation.  Represent the base of a hypothetical
\(G\)-map \(\mathbf P(V)\dashrightarrow S\) by a primitive homogeneous
triple \(p\) of degree \(d\).  Projective equivariance makes
\(p(gv)\) and \(gp(v)\) differ by a constant character of \(G\), hence by
one because \(G\) is perfect.  The weighted coordinate is a rational
\(h\) with \(h^2=q_4(p)\); unique factorization makes \(h\) a polynomial,
and equivariance makes it invariant.  Thus Problem F is equivalent to the
existence of

\[
0\ne p\in\operatorname{Cov}_G(V,V)_d,\qquad
h\in\mathbf C[V]^G_{2d},\qquad q_4(p)=h^2. \tag{*}
\]

This is exhaustive: other source representations do not create an
additional case once the projective generic torsor has been used.

The structural certificate proves that a primitive solution of (*) cannot
have odd degree.  In even degree its Jacobian satisfies

\[
J_p=Xh\,k,\qquad
k\in\mathbf C[F,D,C]_{d-24},
\]

so \(d\ge24\).  The complete degree-24 space is excluded by the exact
Jacobian/support certificate, and degree 26 is impossible because there is
no invariant of degree 2.  The exact degree-28, degree-30, degree-32, and
degree-34 certificates exclude the next four complete spaces.  Before the
all-degree argument, this left \(d=36\) as the first bounded frontier.
That frontier is now superseded.

The final certificate excludes every even degree without further
elimination.  At a quadruple point \(q\) of the 21 involution lines, the
stabilizer is \(D_8\), with central involution \(z\).  For an incident
involution \(s\), put \(K=\langle z,s\rangle\simeq V_4\).  In an
equivariant point-blowup resolution, the central exceptional over \(q\)
maps constantly over \(E_+(z)\), while the strict involution line maps
constantly over the distinct eigenline \(E_+(s)\).  The unique dual-tree
path joining them is fixed componentwise by \(K\).  Every intermediate
component is born from a \(K\)-fixed point, so its projective tangent
action has a nontrivial involution kernel.  Its image lies in that
involution's fixed locus on \(S\), a smooth genus-one curve plus two
points, and is therefore constant.  Adjacency forces every constant on
the path to agree, contradicting the distinct endpoint projections.

Thus (*) has no solution in any degree.  See
certificates/WP3_STRUCTURAL_BOUND.md for the odd-degree theorem and
certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md, checked by
certificates/wp3_all_degree_path_obstruction.py, for the all-even theorem.
The bounded degree-24/28/30/32/34 certificates remain independent
corroboration and historical progress toward this final obstruction.

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

Condition **(A)** — every abelian subgroup has a fixed point — is a
necessary Going-Down condition for \(G\)-unirationality.  Duncan proved it
sufficient for del Pezzo surfaces of degree \(\ge3\), not for degree 2.
Moreover, it is already known not to be sufficient for arbitrary degree-2
actions: Duncan's Remark 1.8 and Example 1.9 use this same surface with the
larger group
\(\langle\sigma\rangle\times(C_7\rtimes C_3)\), and
Tschinkel–Zhang give further \(Q_8\)-examples.  These counterexamples do
not decide the exact simple subgroup \(G\): the Geiser factor is essential
in Duncan's example, and \(G\) contains no \(Q_8\).

WP-1 has now exhaustively verified \(S^A\ne\varnothing\) for every
abelian \(A\le G\); see certificates/WP1_FIXED_LOCI.md.  WP-2 further
shows that every twist has index one and that the universal-torsor and all
higher-Amitsur obstructions vanish.  Those tests did not decide the
problem.  The all-degree exceptional-path theorem now proves that the
exhaustive equation (*) has no solution, providing an obstruction specific
to the projective generic twist and finer than all of those tests.

## Verified starting points

1. \(S^G=\varnothing\): \(V\) irreducible forces
   \(\mathbf P(V)^G=\varnothing\), and \(S\to\mathbf P(V)\) is
   \(G\)-equivariant.
2. The exact WP-1 certificate enumerates every abelian subgroup:
   \(C_2,C_3,C_4,C_7\), and two conjugacy classes of \(V_4\).  Every one
   has a nonempty fixed locus on \(S\), so Condition (A) passes.
3. Dolgachev–Iskovskikh prove that the \(G\)-representation on
   \(K_S^\perp\cong E_7\) is irreducible.  Hence
   \(\operatorname{Pic}(S)^G=\mathbf ZK_S\) and the action is minimal.
4. Every twist has effective zero-cycles of degrees \(2\) and \(21\), so
   every twist has index one.  On the generic twist this yields a closed
   point of degree \(1\), \(3\), or \(7\), but not necessarily a rational
   point.
5. The equivariant universal-torsor class and all higher Amitsur groups
   vanish for this action.
6. The exact Klein arrangement has 21 quadruple points with stabilizer
   \(D_8\).  The \(V_4\)-stable exceptional path at any incident flag gives
   the all-even contradiction; combined with the structural odd-degree
   theorem, it proves that no equivariant map exists.

## What a resolution consists of

Same standard as Problem E: a `certificates/` package containing either a
\(G\)-equivariant dominant rational map from a representation (positive
resolution — explicit polynomials, machine-checkable equivariance and
dominance), or a proof that the generic twist has no
\(K_0\)-point (negative resolution).  Any proposed
cohomological, valuation-theoretic, or other obstruction must be checked
on this exact twist.  Partial results, delimitations of routes, and
failed-construction post-mortems go to RESOLUTION.md with dates, in the
E house style.  The negative alternative is achieved by
certificates/WP3_ALL_DEGREE_PATH_OBSTRUCTION.md and its exact checker.
