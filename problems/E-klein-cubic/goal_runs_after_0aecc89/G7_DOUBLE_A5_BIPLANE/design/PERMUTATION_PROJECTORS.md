# G7A — permutation modules and incidence projectors (G7.1)

## Decomposition (both classes)

For either maximal A5 subgroup \(H\) (resp. \(K\)):

\[
\mathrm{Ind}_H^G \mathbf 1 \cong \mathbf 1 \oplus V_{10}
\]

as a \(G\)-module over \(\mathbf Q\) (and over \(\mathbf C\)). Evidence:

- \(\|\chi_{\mathrm{perm}}\|^2 = 2\)
- \(\|\chi_{\mathrm{aug}}\|^2 = 1\)

so the 10-dimensional augmentation is **absolutely irreducible**.

### Correction to the naive shape

The shape \(\mathbf 1 \oplus W \oplus W'\) with \(W,W'\) the two five-dimensional
irreps of \(G\) is **false** for these permutation modules. The Klein and
companion 5-dimensional irreps of \(\mathrm{PSL}_2(\mathbf F_{11})\) have
character field \(\mathbf Q(\sqrt{-11})\) and are Galois conjugates; **neither**
appears in \(\mathrm{Ind}_H^G\mathbf 1\).

Restriction to \(H\cong A_5\) recovers an internal \(1\oplus 5\oplus 5\) of
A5-modules; that A5-internal pair is not the Klein/companion pair of \(G\).

## Projectors over \(\mathbf Q\)

In either coset basis:

\[
P_1 = \tfrac1{11} J,\qquad P_{10} = I - P_1.
\]

Orthogonal idempotents, traces 1 and 10.

## Incidence intertwiner

View \(N\) as a linear map \(\mathbf Q^{11}_K \to \mathbf Q^{11}_H\). Then:

| constituent | action of \(N\) |
|---|---|
| trivial | eigenvalue \(5\) (\(N\mathbf 1 = 5\mathbf 1\)) |
| augmentation | \(N^t N = 3I\) on \(\mathrm{aug}_K\); inverse \(\frac1{3}N^t\) |

No \(\sqrt 3\) extension is required: the rational inverse \(\frac1{3}N^t\) on
augmentation already suffices. Denominator gate: characteristic \(\neq 3\).

Verified identities:

```text
P10 N N^t P10 = 3 P10
P10 N^t N P10 = 3 P10
```

## Marker

**G7-CROSS-CLASS-PROJECTOR-PASS**

Machine data: `projectors.json`.
