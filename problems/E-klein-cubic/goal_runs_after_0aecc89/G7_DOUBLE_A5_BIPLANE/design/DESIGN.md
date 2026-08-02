# G7A — exact two-class A5 design (G7.0)

## Group

\(G = \mathrm{PSL}_2(\mathbf F_{11})\), order 660, reconstructed from Möbius
generators

```text
S = [[0,-1],[1,0]],  T = [[1,1],[0,1]]
```

acting on the 12 points of \(\mathbf P^1(\mathbf F_{11})\).

## Two conjugacy classes of maximal A5

Exactly 22 subgroups isomorphic to A5; they form **two** conjugacy classes
\(\mathcal H = \{H_0,\ldots,H_{10}\}\) and
\(\mathcal K = \{K_0,\ldots,K_{10}\}\), each of size 11
(index \([G:A5]=11\)).

Labels in artifacts: `A5_class_H`, `A5_class_K` (both nonconjugate maximal classes).

## Cross-intersections (all 121 pairs)

| \(|H_i \cap K_j|\) | count | isomorphism type | role |
|---:|---:|---|---|
| 12 | 55 | A4 (orders: 1×1, 2×3, 3×8) | **incident** |
| 10 | 66 | D5 (orders: 1×1, 2×5, 5×4) | nonincident |

**Derived incidence rule** (not assumed):

\[
H_i \mathrel{I} K_j \iff |H_i \cap K_j| = 12 \iff H_i \cap K_j \cong A_4.
\]

## G-orbits on \(\mathcal H \times \mathcal K\)

Exactly two orbits:

- size **55** — the A4-intersection (incident) pairs;
- size **66** — the D5-intersection (nonincident) pairs.

The unique nontrivial cross-relation is 5-regular on each side.

## Incidence matrix and biplane identities

The 11×11 zero-one matrix \(N\) satisfies, by direct reconstruction:

```text
row sums = column sums = 5
any two rows meet in 2 columns
any two columns meet in 2 rows
N N^t = 3 I + 2 J
N^t N = 3 I + 2 J
```

Hence \(N\) is the incidence matrix of the symmetric design

\[
2-(11,5,2)
\]

(the **Paley biplane** of order 11). This is a derived identity, not a
literature assumption.

## Automorphisms

Conjugation by the installed generators \(S,T\) induces permutations of
\(\mathcal H\) and of \(\mathcal K\) that preserve \(N\), and the joint
image has order 660. Thus the installed \(G\) is exactly \(\mathrm{Aut}\) of
this design.

## Marker

**G7-PALEY-BIPLANE-IDENTIFIED**

Machine data: `design.json`, `incidence_N.json`, `cross_intersections.json`.
