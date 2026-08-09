# Adversarial checks

The existence theorem was tested against the failure modes listed in the
mission. None permits promotion to an ambient theorem, and none invalidates
the intrinsic selfmap construction.

## 1. Normalized graph noncanonical

**Check.** The proof never assumes that the normalized graph is canonical,
terminal, \(\mathbf Q\)-factorial, or Fano. It constructs the rational map on
an open set and then takes its graph.

**Consequence.** For the resulting degree-\(>1\) maps, at least one conditional
Mori hypothesis must fail. This is a conclusion, not a defect in the proof.

## 2. Deckless non-Galois cubic maps

**Check.** The construction does not infer a deck transformation and does not
claim a Galois extension. The accepted degree-two theorem is used only after
the map has been constructed, to show \(\delta\ne2\).

**Consequence.** The map may be deckless and could have degree three; its
monodromy is deliberately left undetermined.

## 3. Singular or nonreduced branch divisors

**Check.** No smoothness, reducedness, or normal-crossing assumption is made
about the branch divisor. Dominance is proved by a differential at a point of
the projective bundle before Stein factorization.

**Consequence.** Hurwitz lower bounds cannot be used backward to rule out the
construction.

## 4. Exceptional divisors outside the initial stratum census

**Check.** The rational section is chosen over the free quotient and can be
indeterminate along the entire nonfree locus. Its principalization may create
exceptional divisors over centres not present in the initial linear-stratum
census.

**Consequence.** The theorem explicitly allows such divisors. A claimed fixed
network classification that omitted them would not apply.

## 5. Elliptic translations

**Check.** No assertion is made that the strict fixed elliptics survive or
that their maps have zero translation. If an elliptic carrier appears, the
correct classification permits

\[
P\mapsto[n]P+a,
\qquad a\in E_t[2].
\]

**Consequence.** The older erroneous reflection formula is not used.

## 6. High-degree \(S_3\)-equivariant line maps

**Check.** The strict line centralizer is the infinite family

\[
R(z)=zA(z^3),
\qquad A(u)A(u^{-1})=1.
\]

**Consequence.** No bounded line-degree claim enters the selfmap theorem.

## 7. Constant strict fixed-stratum restrictions

**Check.** A generically finite global map may be undefined at the generic
point of every strict fixed curve, or may contract a strict component while an
exceptional component carries the horizontal map.

**Consequence.** Global dominance is established on the free quotient and is
independent of strict fixed-locus behavior.

## 8. Iterates introduce new base components

**Check.** Iteration is used only at the function-field level. For dominant
generically finite rational maps,

\[
\deg(\varphi^m)=(\deg\varphi)^m
\]

regardless of how the base ideals of chosen homogeneous representatives
change or acquire new components.

**Consequence.** No algebraic-stability assumption on divisor pullbacks is
needed for the unbounded-degree conclusion.

## 9. Intermediate-Jacobian correspondence is not an honest pullback map

**Check.** The packet defines

\[
u=p_*q^*
\]

from a resolved graph. It does not identify this with the pullback of a
regular morphism and does not assert \(u^\dagger u=[\delta]\).

**Consequence.** Exceptional curve-centre summands remain available, as they
must for the constructed maps.

## 10. Relative-MMP outputs are unexpected

**Check.** No MMP is used in the existence proof. The MMP audit states only a
conditional implication after terminality, \(\mathbf Q\)-factoriality, Fano
ampleness, and invariant rank one have all been proved.

**Consequence.** A conic bundle, higher-rank model, noncanonical finite model,
or other unexpected output does not contradict the theorem.

## 11. Does the descended section really lift equivariantly?

Let \(\alpha:U\to B\) be the free quotient. Étale descent gives

\[
\mathbf P(T_U)\simeq U\times_B\mathbf P(T_B).
\]

A rational section \(s:B\dashrightarrow\mathbf P(T_B)\) therefore pulls back
to the graph

\[
\widetilde s(u)=(u,s(\alpha(u))),
\]

which is manifestly \(G\)-equivariant because \(G\) acts only on the first
factor over \(B\).

## 12. Could the descended residual map equal the bundle projection?

If \(\bar\rho=\pi\), then for each general \(x\in U\) every residual point
\(\rho(x,[v])\) would lie over the same quotient point as \(x\), hence in the
finite orbit \(Gx\). But the fibre map is birational onto the two-dimensional
tangent hyperplane section \(X\cap T_xX\). Contradiction.

## 13. Does the first-jet section exist algebraically?

Near a smooth point of \(B\), trivialize the projective bundle and choose an
affine fibre chart. A local section is the graph of regular functions.
Their values and first derivatives can be prescribed in a regular system of
parameters. Such a local section is a rational section on the irreducible
base. Thus the common-complement differential argument is algebraic, not
analytic.

## 14. Could the composite be dominant but equal to the identity rationally?

The selected point \(z\) satisfies \(h(z)\ne\pi(z)\), and the section passes
through \(z\). Hence \((h\circ s)(\pi(z))\ne\pi(z)\) at a point where all maps
are defined. The rational maps are not equal.

## 15. Ambient overclaim

**Check.** Lifting the five coordinate sections to \(\mathbf P(W_5)\) gives
only

\[
F(P)=F(x)A(x).
\]

The proof never asserts \(A=0\).

**Consequence.** The theorem refutes Targets A and B for arbitrary selfmaps but
does not decide the ambient-extendable theorem or the headline Problem E.

## Verdict

The adversarial audit supports the intrinsic existence theorem and its
unbounded-degree corollary. It also confirms the strict stopping boundary:
ambient landing remains a separate normalized-Rees and nonlinear
normal-extension problem.
