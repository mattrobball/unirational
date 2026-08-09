# Residual-RCC central and centralizer obstruction

## 1. Binding repository input

The proof uses the accepted fixed-stratum survivor construction in
`problems/E-klein-cubic/theory/FIX_IX_v14.md`, not the superseded claim that arbitrary rationally connected strata survive every birational model.

Let \(V\) be a faithful linear representation of a finite group \(G\), let \(\sigma\in G\), and put

\[
N=C_G(\sigma).
\]

Choose any eigenvalue \(\lambda\) of \(\sigma\) on \(V\). Then

\[
F_0=\mathbf P(V_\lambda)
\]

is nonempty, irreducible, rationally connected, pointwise fixed by \(\sigma\), and \(N\)-stable. The accepted equivariant-resolution argument follows one such stratum through a chosen functorial equivariant resolution of a rational map. It produces an irreducible, \(N\)-stable, pointwise-\(\sigma\)-fixed rationally chain connected subvariety on the resolved source.

The point is existence of one controlled survivor. No assertion is made about all fixed components or all resolutions.

## 2. The generalized theorem

> **Theorem (residual-RCC centralizer obstruction).**  
> Let a finite group \(G\) act faithfully on a smooth projective variety \(Y\) over an algebraically closed field of characteristic zero. Let \(\sigma\in G\setminus\{1\}\), and put \(N=C_G(\sigma)\). Assume:
>
> 1. every irreducible \(N\)-stable rationally chain connected closed subvariety of \(Y^\sigma\) is zero-dimensional; and
> 2. \(Y^N=\varnothing\).
>
> Then there is no \(G\)-equivariant rational map
> \[
> \mathbf P(V)\dashrightarrow Y
> \]
> from any faithful linear representation \(V\) of \(G\). The same holds with an affine linear source. If \(Y\) is complete, it is not weakly \(G\)-versal, hence not \(G\)-unirational.

### Proof

Assume that \(f:\mathbf P(V)\dashrightarrow Y\) is equivariant. Resolve its indeterminacy by a functorial sequence of smooth \(G\)-equivariant blowups

\[
\pi:\widetilde P\longrightarrow\mathbf P(V)
\]

and write \(\widetilde f:\widetilde P\to Y\) for the resulting morphism.

Start with \(F_0=\mathbf P(V_\lambda)\). At each blowup, apply the survivor construction.

- If the current survivor is not contained in the center, take its strict transform.
- If it is contained in the center, decompose the normal bundle into \(\sigma\)-eigenbundles and take the projectivization of one nonzero eigenbundle over the survivor.

The resulting final subvariety \(F\subset\widetilde P\) is irreducible, \(N\)-stable, rationally chain connected, and pointwise fixed by \(\sigma\).

Its image

\[
Z=\widetilde f(F)
\]

is irreducible, \(N\)-stable, rationally chain connected, and contained in \(Y^\sigma\). Hypothesis 1 forces \(Z=\{y\}\). Since \(F\) is \(N\)-stable and \(\widetilde f\) is equivariant, the point \(y\) is fixed by \(N\). This contradicts Hypothesis 2. \(\square\)

## 3. Central form

If \(z\in Z(G)\setminus\{1\}\), then \(N=G\). Thus it is enough that

\[
\text{every }G\text{-stable irreducible RCC subvariety of }Y^z
\text{ is a point},
\qquad
Y^G=\varnothing.
\]

This is strictly weaker than requiring \(Y^z\) to contain no rational curve.

## 4. Useful criteria for Hypothesis 1

### 4.1 Surface fixed locus

Suppose an irreducible component \(S\subset Y^\sigma\) is a smooth non-uniruled surface. Any positive-dimensional RCC subvariety of \(S\) is then a rational curve. It is enough to show that \(S\) contains no \(N\)-stable rational curve.

This is the form used for the smooth quartic double solid: the deck-fixed component is a K3 surface.

### 4.2 Normal-subgroup test for stable rational curves

Let a finite group \(N\) act on a variety \(S\), and let \(C\subset S\) be an \(N\)-stable irreducible rational curve. The induced action on the normalization gives

\[
N/K\hookrightarrow\operatorname{PGL}_2
\]

for a normal subgroup \(K\triangleleft N\). Therefore no such curve exists if, for every normal subgroup \(K\) with \(N/K\) isomorphic to a finite subgroup of \(\operatorname{PGL}_2\), the fixed locus \(S^K\) is zero-dimensional.

Recall that finite subgroups of \(\operatorname{PGL}_2(\mathbf C)\) are cyclic, dihedral, \(A_4\), \(S_4\), and \(A_5\).

For \(N=C_7\rtimes C_3\), the only kernels possible for an action on a rational curve are \(1\), \(C_7\), and \(N\). The faithful case is impossible because the nonabelian group of order \(21\) is not a finite subgroup of \(\operatorname{PGL}_2\); the other cases force the curve into \(S^{C_7}\) or \(S^N\).

### 4.3 Equivariant MRC form

More generally, let \(F\) be an \(N\)-stable component of \(Y^\sigma\), and let

\[
F\dashrightarrow R(F)
\]

be its maximal rationally connected fibration. Any RCC image of the source survivor lies in one MRC fiber. Thus Hypothesis 1 follows if no MRC fiber contains an \(N\)-stable positive-dimensional subvariety. This formulation is useful when \(F\) contains many rational curves but the residual group moves every fiber or every rational curve.

The MRC statement is a criterion, not a claim that the rational map is everywhere regular; one applies it after resolving the MRC map equivariantly.

## 5. Three-dimensional network extension still missing

The theorem above follows one RCC survivor. It does not control connected exceptional fibers containing several surfaces and curves. For the rational Fano conic bundles of family No. 2.18, the deck-fixed surface is itself rational and hence is an allowed RCC image. A genuinely new theorem must retain:

- the incidence graph or dual complex of the fixed surfaces and curves;
- residual stabilizers of rational curves in the deck-fixed surface;
- normal characters at their intersections;
- connectedness of the exceptional fiber carrying the source eigenstratum.

This is the precise three-dimensional analogue of the Problem-F exceptional path that remains to be developed.

## Exit

```text
FIXED-LOCUS-OBSTRUCTION-GENERALIZED
```
