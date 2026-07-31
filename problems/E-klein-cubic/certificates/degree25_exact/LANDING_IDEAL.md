# P25X.1 — Exact cubic landing ideal

**Headline: OPEN.**

**Exit: see `exit_p25x1.json`.**

## 1. Object

For the monic Reynolds basis $p_1,\ldots,p_{43}$ of $V_{25}$ from P25X.0 and
coefficients $c\in K^{43}$,

$$
p_c = \sum_{i=1}^{43} c_i p_i,\qquad
I_{\mathrm{land}} = \mathrm{coeff}_x\bigl(F(p_c(x))\bigr)
\subset K[c_1,\ldots,c_{43}]_{3}.
$$

$F$ is the Klein cubic. Every generator is homogeneous of degree 3 in $c$.

## 2. Implementation

**Accepted method (1):** sparse direct coefficient collection via sampling.

At each good prime $p\in\{89,199,331\}$ ($p > 25$, so degree-75 evaluation is
not collapsed by the field size):

1. Rebuild the monic $43\times 189$ basis (P25X.0 circuit).
2. Draw 1600 random points $x\in\mathbf F_p^5$.
3. Expand $F(p_c(x))$ as a cubic form in $c$ (`fast_cubic_row`).
4. Row-reduce over $\mathbf F_p$ to a monic echelon basis of the sample span.

Artifacts: `landing_cubics.npz`, `landing_cubics.json`.

## 3. Sample ranks

| prime | landing sample rank | plateau |
|------:|--------------------:|:-------:|
| 89 | 746 | yes |
| 199 | 746 | yes |
| 331 | 746 | yes |

Historical modular order-four plane basis: **rank 842** at $p=67$ only
(`tmp/m1_full_plane_block_rank/full_cubic_basis.npz`).

## 4. Row-space comparison

See `rowspace_comparison.json`. Holdout primes report the sample ranks above.
Coefficientwise recovery of the historical 842 row space over $K$ is **not**
claimed.

## 5. Equivalence to rank-28 border

See `equivalence_to_border.json`.

**Residual gap (undischarged):** exact ideal containment both ways between the
direct landing ideal and the rank-28 border presentation over $K$ is **not**
proved. Prior P25R sealed the same gap (modular 842 only). This dispatch adds
executable multiprime sample bases but does not close the char-0 containment.

## 6. Exit

```text
P25X1-FAIL
```

**Headline remains OPEN.**
