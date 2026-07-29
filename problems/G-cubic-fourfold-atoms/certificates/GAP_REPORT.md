# Referee gap report — KKPY Theorem 6.8 as printed

**Date:** 2026-07-29  
**Text audited:** Katzarkov–Kontsevich–Pantev–Yu (KKPY), *Birational
Invariants from Hodge Structures and Quantum Multiplication*,
arXiv:2508.05105v2, Theorem 6.8, printed pp. 69–71.  
**Scope:** the five defects specified in `WORKORDER_0.5_REPAIR.md`.  
**Status:** all five occur in the printed proof. They show that the proof is
not valid verbatim; they do not constitute a counterexample to the theorem.
The corrected argument is recorded separately in
[`REPAIRED_PROOF.md`](REPAIRED_PROOF.md).

## 1. Source identification

The primary PDF is
[`tmp/pdfs/2508.05105v2.pdf`](../tmp/pdfs/2508.05105v2.pdf):

```text
SHA-256  2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64
```

The theorem statement and proof are at TeX source lines 3911–4005 in
[`tmp/sources/v2/brinv.tex`](../tmp/sources/v2/brinv.tex). The v1 and v2
theorem blocks are byte-for-byte identical; the finding is therefore not a
text-extraction artifact and was not changed in v2.

| Repair | Printed issue | Effect | Repair status |
|---|---|---|---|
| R1 | \(q=1\) is outside the defined ample-cone tube | The chosen evaluation point is inadmissible | Repaired by \(q_0=\boldsymbol y^a\), \(a>0\) |
| R2 | Theorem 4.1 is applied after a non-maximal fixed-locus restriction | The cited decomposition theorem’s main hypothesis fails | Repaired by full-base decomposition, a new uniqueness/equivariance lemma, and cover-native pointwise localization |
| R3 | An atom is bounded by the minimum of all cluster ranks | The displayed inequality is false | Repaired by the particular containing cluster |
| R4 | Existence of one NL-general cubic is used for a very-general theorem | The countable-union implication is absent | Repaired by Hassett Theorem 3.1.2 |
| R5 | The surface list is not exhaustive and nefness is applied before minimalization | Lemma 5.24 is not justified for the surface as given | Repaired by passing to the minimal model; no classification list is needed |

## 2. R1 — inadmissible base point

### Printed text

The domain is defined on printed p. 29 (TeX lines 1454–1457):

> “\(B_{X,q}\) … is the preimage of the ample cone in
> \(\operatorname{NS}(X,\mathbf R)\) under the valuation map.”

The proof then says on printed p. 69 (lines 3929–3930):

> “Let \(b\in B_X\) be the rigid point with coordinates \(q=1\), and
> \(t_i=0\), for all \(i\ne2\). Then
> \(b\in\widehat B_X\subset B_X^{\mathsf{Hod}}\subset B_X\).”

It subsequently specializes the ambient operator to
\(\mathbf K|_{q=1}\) (lines 3938, 3952–3961, and 3982).

### Diagnosis

For a Picard-rank-one cubic, \(\operatorname{val}(1)=0\), while the open
ample cone consists of positive multiples of the hyperplane class and does
not contain zero. Therefore the asserted point is not in \(B_{X,q}\) as
defined. The invocation of Lemma 5.19 and the spectrum calculation are made
at a point outside the stated analytic domain.

### Repair

Choose \(a\in\mathbf Q_{>0}\) and
\(q_0=\boldsymbol y^a\). Then \(\operatorname{val}(q_0)=a>0\), and

\[
\det(\lambda I-K(q_0))
=\lambda^2(\lambda^3-729q_0).
\]

The eigenvalues are

\[
0,\quad 9q_0^{1/3},\quad 9q_0^{1/3}\zeta,\quad
9q_0^{1/3}\zeta^2,
\]

with invariant generalized-eigenspace dimensions \(2,1,1,1\). Thus the
needed rank data survives unchanged.

For downstream consistency, Lemma 6.11 must use the repaired \(b\), and
Corollary 6.12 must use these three scaled nonzero eigenvalues and replace
both occurrences of \(K|_{q=1}\) by \(K(q_0)\).

## 3. R2 — maximality is lost on the Hodge-fixed base

### Printed text and failed hypothesis

Definition 3.8 (printed p. 20) requires maximality at \(b\): evaluation on
a cyclic vector must give an isomorphism

\[
T_{B,b}\xrightarrow{\sim}\mathcal H_{(b,0)}.
\]

Theorem 4.1 (printed p. 43, lines 2577–2588), restating HYZZ Theorem
1.2/3.42, explicitly assumes that the F-bundle is maximal at \(b\).

Theorem 6.8 instead says on printed p. 70 (lines 3963–3969):

> “By the spectral decomposition theorem Theorem 4.1 … over some
> admissible open neighborhood \(b\in U\subset B_X^{\mathsf{Hod}}\) the
> A-model F-bundle \((\mathcal H,\nabla)/B_X^{\mathsf{Hod}}\) decomposes
> into an external direct sum of maximal F-bundles.”

For an NL-general cubic, the unchanged fiber has dimension \(27\), whereas
the fixed base has tangent dimension \(5\). The required isomorphism cannot
hold. Theorem 4.1 therefore does not apply to this restricted bundle, and
the restricted factors cannot be called maximal on dimension grounds.

### Exact status of the proposed repair

HYZZ Theorem 3.42 states existence of the separated spectral decomposition;
it does not contain the “uniqueness clause” sometimes attributed to it.
Nevertheless, uniqueness is provable. If two connection-stable splittings
lift the same primary blocks, compare their projection idempotents. At the
first nonzero \(u\)-coefficient, horizontality makes the coefficient commute
with the leading operator. Disjoint spectra make it block diagonal (HYZZ
Lemma 3.25), while the idempotent equation forces every diagonal block to
vanish. Induction gives equality of the splittings.

Consequently the valid route is:

1. apply HYZZ Theorem 3.42 to the **full** maximal F-bundle over \(B_X\);
2. use the added uniqueness argument to make the factors canonical and
   Hodge-equivariant;
3. use the polynomial primary projectors and exactness of invariants for the
   proreductive Hodge group to obtain
   \((H_b^\lambda)^{\mathsf{Hod}}
   =(H_b^{\mathsf{Hod}})^\lambda\);
4. pull the factors back to \(B_X^{\mathsf{Hod}}\), without claiming that
   these pullbacks are maximal;
5. localize each atom at a point of its spectral-cover component lying over
   the resulting neighborhood.

### Global-component precision

The last step requires care. A connected global finite étale cover can
become disconnected over a small neighborhood. For example,

\[
z^2=t:\mathbf G_m^{\mathrm{an}}\longrightarrow\mathbf G_m^{\mathrm{an}}
\]

is connected globally but splits near \(t=1\) into branches near
\(z=1\) and \(z=-1\). Thus it is false in general that one global connected
component “lies in one” local cluster.

The weaker statement needed by Theorem 6.8 is valid. Under Definition
5.10’s component-as-cover convention, every component is surjective to
\(U_X\), so it has a point over the local neighborhood. At that point its
atomic germ lies in one cluster. The representation is cleanly defined on
the component itself by the tautological generalized-eigenbundle

\[
\mathcal A_\alpha
=\ker((\pi^*\kappa-\ell_\alpha)^N),
\qquad N=\operatorname{rank}\mathcal H.
\]

Its Hodge-representation type is constant on the connected component by
semisimplicity. This cover-native definition also resolves a manuscript
ambiguity: the paragraph preceding Definition 5.26 describes a bundle on
\(U_X\) attached to all sheets of a component, while Remark 5.29 identifies
the atom representation with a single point-local factor. A pushforward sum
over a degree-\(>1\) component could have larger invariant rank; the
tautological bundle on the component has the single-fiber meaning used by
Remark 5.29.

With this correction, the R2 conclusion required for Theorem 6.8 is proved.
The stronger global-cluster label is not part of the repaired claim.

## 4. R3 — the displayed minimum is invalid

### Printed text

On printed p. 70 (lines 3976–3987), after saying that an atom belongs to one
of four spectral pieces, the proof displays

\[
\dim(E^\alpha)^{\mathsf{Hod}}
\le
\min_\lambda\operatorname{rank}
(\mathcal H^\lambda_{u=0})^{\mathsf{Hod}}
\le
\min_\lambda\dim\widehat{\mathcal H}_{(b,0)}^\lambda,
\]

and then concludes \(\rho_\alpha\le2\).

### Diagnosis and repair

Membership in one cluster gives a bound by that cluster, not by every
cluster simultaneously. The ranks are \(2,1,1,1\), so the displayed minimum
is \(1\); an atom in the two-dimensional zero cluster is not bounded by a
different one-dimensional cluster.

After R2, the correct statement is

\[
\rho_\alpha
\le
\dim_{\mathbb K}
\left(\bigoplus_{i=0}^4\mathbb K h^i\right)^{\lambda(\alpha)}
\le2.
\]

This is exactly the coarse bound used later.

## 5. R4 — the very-general implication is omitted

### Printed text

The statement on printed p. 69 is for a “very general” cubic. The proof
begins (line 3915):

> “Assume that \(X\) is Noether–Lefschetz general … Such cubic fourfolds
> exist e.g. by Voisin’s proof … of the Torelli theorem for cubic
> fourfolds.”

### Diagnosis

Existence of an NL-general point does not show that the complement of the
NL-general locus is a countable union of proper closed subsets. That
quantifier change is required by “very general.”

### Repair

Hassett, [*Special Cubic Fourfolds*](https://www.math.brown.edu/bhassett/papers/cubics/cubic.pdf),
Theorem 3.1.2 (published version, printed pp. 6–7), proves that every special
cubic lies on an irreducible algebraic divisor \(\mathcal C[K]\). There are
only countably many integral rank-two saturated sublattices \(K\) of the
fixed cohomology lattice. Hence the special/NL locus is a countable union of
proper divisors. Theorem 3.2.3 (printed p. 8) says that each
discriminant-indexed \(\mathcal C_d\) is irreducible and possibly empty;
Theorem 4.3.1 (printed p. 11) says it is nonempty exactly when
\(d>6\) and \(d\equiv0,2\pmod6\).

No additional Torelli or transcendental-representation irreducibility locus
is used by Theorem 6.8. That irreducibility input first appears in Corollary
6.12 and should not be added to the exceptional set for Theorem 6.8.

## 6. R5 — the printed surface paragraph is false

### Printed text

On printed p. 71 (lines 4000–4004), the proof says:

> “\(S\) must be either an abelian surface, a K3 surface, an elliptic
> surface with \(\kappa=1\) and \(p_g=1\), or a surface of general type.
> But every such surface has a nef \(K_S\).”

### Counterexample to the list

Let \(E\) be an elliptic curve and \(C\) a smooth projective curve of genus
\(g\ge2\). For

\[
S=E\times C
\]

projection to \(C\) is an elliptic fibration, and

\[
K_S=\operatorname{pr}_C^*K_C,
\qquad \kappa(S)=1,
\qquad p_g(S)=h^{1,0}(E)h^{1,0}(C)=g>1.
\]

This is a minimal elliptic surface omitted by the printed \(p_g=1\) clause.
Separately, a point blowup of a minimal surface of general type remains of
general type but its canonical class is not nef on the exceptional curve.
Thus the nefness sentence is also not valid for an arbitrary surface \(S\)
in the proof.

### Repair without classification

If an atom of \(S\) has \(\operatorname{Coeff}_{t^2}P_\alpha=1\), then
\(p_g(S)>0\). Peters' definitions of \(p_g\) and \(P_1\), together with
Serre duality, Theorem 4.3 (printed pp. 5, 7, and 12), give
\(P_1(S)=p_g(S)>0\), so \(\kappa(S)\ge0\). Pass to the minimal model
\(S_{\min}\). Peters, *An Introduction to the Theory of Compact Complex
Surfaces*, Proposition 2.1 and the discussion after Proposition 2.2
(printed pp. 8–9), imply that \(K_{S_{\min}}\) is nef.

The surface blowup formula adds only point atoms. A point atom has Hodge
polynomial \(1\), so the atom with nonzero \(t^2\)-coefficient descends to
\(S_{\min}\). KKPY Lemma 5.24 then gives the single atom
\(\boldsymbol\eta(S_{\min})\), whose Hodge-invariant space contains the
independent degree \(0,2,4\) algebraic classes. Hence its invariant dimension
is at least \(3\), contradicting the cubic bound \(\rho_\alpha\le2\).

The counterexample \(E\times C\) is included here only to document the
printed defect. It is not needed in the repaired proof.

## 7. Neutral conclusion

The five findings are use-site errors or omitted lemmas in the printed
argument. R1, R3, R4, and R5 have short exact corrections. R2 requires a
substantive but local refinement: apply spectral decomposition before
restriction, prove uniqueness and equivariance, and formulate atom
representations on their spectral-cover components. With that refinement,
the numerical atom bound used by Theorem 6.8 follows.

This report makes no claim about author intent, priority, or a counterexample
to irrationality. Any communication outside this repository remains the
owner’s decision.
