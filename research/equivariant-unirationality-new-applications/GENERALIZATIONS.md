# Residual-RCC central and centralizer obstruction

## 1. Binding repository input

The proof uses the accepted fixed-stratum survivor construction in
`problems/E-klein-cubic/theory/FIX_IX_v14.md`, not the superseded claim that arbitrary rationally connected strata survive every birational model.

Let `V` be a faithful linear representation of a finite group `G`, let `σ∈G`, and put

\[
N=C_G(\sigma).
\]

Choose any eigenvalue `λ` of `σ` on `V`. Then

\[
F_0=\mathbf P(V_\lambda)
\]

is nonempty, irreducible, rationally connected, pointwise fixed by `σ`, and `N`-stable. This remains true when `σ` acts as a scalar: then `F_0=P(V)`. The accepted equivariant-resolution argument follows one such stratum through a chosen functorial equivariant resolution of a rational map. It produces an irreducible, `N`-stable, pointwise-`σ`-fixed rationally chain connected subvariety on the resolved source.

The point is existence of one controlled survivor. No assertion is made about all fixed components or all resolutions.

## 2. The generalized theorem

> **Theorem (residual-RCC centralizer obstruction).**  
> Let a finite group `G` act faithfully on a smooth projective variety `Y` over an algebraically closed field of characteristic zero. Let `σ∈G\setminus{1}`, and put `N=C_G(σ)`. Assume:
>
> 1. every irreducible `N`-stable rationally chain connected closed subvariety of `Y^σ` is zero-dimensional; and
> 2. `Y^N=∅`.
>
> Then there is no `G`-equivariant rational map
> \[
> \mathbf P(V)\dashrightarrow Y
> \]
> from any faithful linear representation `V` of `G`. The same holds for an affine linear source. If `Y` is complete, it is not weakly `G`-versal, hence not `G`-unirational.

### Proof

Assume that

\[
f:\mathbf P(V)\dashrightarrow Y
\]

is equivariant. Resolve its indeterminacy by a functorial sequence of smooth `G`-equivariant blowups

\[
\pi:\widetilde P\longrightarrow\mathbf P(V)
\]

and write `\widetilde f:\widetilde P→Y` for the resulting morphism.

Start with `F_0=P(V_λ)`. At each blowup apply the controlled survivor construction.

- If the current survivor is not contained in the center, take its strict transform.
- If it is contained in the center, decompose the normal bundle into `σ`-eigenbundles and take the projectivization of one nonzero eigenbundle over the survivor.

The final subvariety `F⊂\widetilde P` is irreducible, `N`-stable, rationally chain connected, and pointwise fixed by `σ`.

Its image

\[
Z=\widetilde f(F)
\]

is irreducible, `N`-stable, rationally chain connected, and contained in `Y^σ`. Hypothesis 1 forces `Z={y}`. Since `F` is `N`-stable and `\widetilde f` is equivariant, `y` is fixed by `N`, contradicting Hypothesis 2.

Now suppose instead that an equivariant rational map is given on an affine faithful representation `V`. It extends to a rational map from

\[
\mathbf P(V\oplus\mathbf1),
\]

where the added line has trivial `G`-action. The representation `V⊕1` is still faithful, so the projective case gives the same contradiction.

Finally, take a faithful generically free representation `W`. A rational point on the twist of `Y` by the generic torsor of `W` is equivalent to a `G`-equivariant rational map from a nonempty invariant open of `W` to `Y`. The affine-source conclusion excludes that point. Thus the generic torsor already violates weak versality. `\square`

### Remarks

1. Dominance is never used. The theorem excludes constant and nondominant equivariant maps as well as dominant ones.
2. Completeness of `Y` is used only in the standard weak-versality/twist dictionary and to extend maps across codimension-one issues; the fixed-image contradiction itself is local to the resolved graph.
3. The theorem is strictly residual: rational curves may exist in `Y^σ`; they are harmless unless one is stable under the whole centralizer survivor.

## 3. Central form

If `z∈Z(G)\setminus{1}`, then `N=G`. It is enough that

\[
\text{every }G\text{-stable irreducible RCC subvariety of }Y^z
\text{ is a point},
\qquad
Y^G=\varnothing.
\]

This is strictly weaker than requiring `Y^z` to contain no rational curve.

## 4. Useful criteria for Hypothesis 1

### 4.1 Surface fixed locus

Suppose an irreducible component `S⊂Y^σ` is a smooth non-uniruled surface. Any positive-dimensional proper RCC subvariety of `S` is a rational curve, while `S` itself is not RCC. It is therefore enough to show that `S` contains no `N`-stable rational curve.

This is the form used for the smooth quartic double solid: the deck-fixed component is a K3 surface.

### 4.2 Normal-subgroup test for stable rational curves

Let a finite group `N` act on a variety `S`, and let `C⊂S` be an `N`-stable irreducible rational curve. The induced action on the normalization gives

\[
N/K\hookrightarrow\operatorname{PGL}_2
\]

for a normal subgroup `K\triangleleft N`. Therefore no such curve exists if, for every normal subgroup `K` with `N/K` isomorphic to a finite subgroup of `PGL2`, the fixed locus `S^K` is zero-dimensional.

Finite subgroups of `PGL2(C)` are cyclic, dihedral, `A4`, `S4`, and `A5`.

For `N=C7:C3`, the only normal subgroups are `1`, `C7`, and `N`. The faithful case is impossible because the nonabelian group of order 21 is not a finite subgroup of `PGL2`; the other cases force the curve into `S^{C7}` or `S^N`.

### 4.3 Equivariant MRC form

Let `F` be an `N`-stable component of `Y^σ`, and let

\[
F\dashrightarrow R(F)
\]

be its maximal rationally connected fibration. Any RCC image of the source survivor lies in one MRC fiber. Hypothesis 1 follows if no MRC fiber contains an `N`-stable positive-dimensional subvariety. This is useful when `F` contains many rational curves but the residual group moves every fiber or every rational curve.

The MRC statement is a criterion, not a claim that the rational map is everywhere regular; one resolves the MRC map equivariantly before applying it.

### 4.4 Finite-normal-quotient checklist

For a fixed surface component `S`, the stable-rational-curve test can often be reduced to a finite table:

| normal subgroup `K◁N` | can `N/K` act on `P1`? | dimension of `S^K` | consequence |
|---|---|---:|---|
| `K=1` | finite-subgroup classification | — | faithful case allowed or excluded |
| proper nontrivial `K` | test quotient type | 0 or positive | zero-dimensional fixed locus excludes the curve |
| `K=N` | trivial quotient | `dim S^N` | empty/finite excludes pointwise-fixed curves |

This is the exact finite mechanism behind the quartic-double-solid theorem and is the recommended first test for Kummer and other deck-fixed K3 surfaces.

## 5. Conic-bundle discriminant criterion

Suppose a central fiberwise involution `z` on a smooth conic bundle fixes a finite cover `D→B` of the base, or a smooth compactification thereof. If that fixed variety is non-uniruled and the residual group preserves no rational curve in it, the central form applies as soon as the full-group fixed locus is empty.

This criterion explains both outcomes in the packet:

- on the exceptional conic-bundle surfaces, the fixed cover is a hyperelliptic curve and the theorem fires immediately;
- on Mori–Mukai No. 2.18, the deck-fixed surface is a rational degree-2 del Pezzo surface, so it is itself an allowed RCC image and the criterion does not fire.

## 6. Three-dimensional network extension still missing

The theorem follows one RCC survivor. It does not control connected exceptional fibers containing several surfaces and curves. For the rational Fano conic bundles of family No. 2.18, the deck-fixed surface is itself rational. A genuinely new theorem must retain:

- the incidence graph or dual complex of fixed surfaces and curves;
- residual stabilizers of rational curves in the deck-fixed surface;
- normal characters at their intersections;
- connectedness of the exceptional fiber carrying the source eigenstratum;
- compatibility of different fixed surface slices inside one exceptional divisor.

This is the precise three-dimensional analogue of the Problem-F exceptional path that remains to be developed.

## Exit

```text
FIXED-LOCUS-OBSTRUCTION-GENERALIZED
```