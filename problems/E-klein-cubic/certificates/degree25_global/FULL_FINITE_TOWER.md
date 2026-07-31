# P25R.2 — Full finite polar tower (one global c)

**Headline: OPEN.**

**Exit: `P25R2-UNDECIDED`.**

**Requires: `P25R1-PASS`.** Not a covariant. Not a headline claim.

## Binding requirements

1. Order-28 cancellation recomputed inside **genuine residual image** (rank 7).
2. Same coefficients substituted into all later equations (no jet reset).
3. Stagewise elimination retains back-substitution maps to the original 43 coordinates.
4. Sparse polar / residual 7 / based 36 preferred over dense $842\times 14190$.
5. Equivalence to the rank-842 cubic system: **residual gap recorded** (no char-0
   842 matrix).
6. Saturation checklist retained for a future closing computation.

## N_star = 28 — residual family free-path test

On the P25.1 free-fibre particular path (`residual_S3_trivial`, each ker $L_1$
basis vector):

| Object | Free fibre (P25.1) | Genuine residual image |
|--------|--------------------|-------------------------|
| $a_d$ space | dim 52 | rank **7** |
| $A_{ad}$ rank | 27 | **7** (restricted) |
| $R_0 + A_{ad} a_d = 0$ | solvable | **not solvable** |

Multi-prime agreement at $p\in\{89,199,331\}$ with written DVR/denominator
promotion: the free-path residual cancellation **does not lift** to the genuine
residual module. This is exactly the free-fibre error P25R was rewritten to catch.

Scope of this kill: the P25.1 residual-family survivor certificate. Not yet a
proof that every $c\in V_{25}$ has nonzero residual at order 28, because lower
jets of a global $c$ need not match the free particular path.

## Based family

Linear support remains the based kernel of dimension 36. High-order $E_+$
cancellation parameters of P25.1 are free-fibre objects; their membership in
$\operatorname{im}\rho$ from the based kernel is not certified. Support
**UNDECIDED**.

## Equivalence to rank-842 system

Ideal containment in both directions over $\mathbf Q$ is **not** proved.
Gap: modular $842\times 14190$ coefficients only; no char-0 lift of the cubic
basis in this dispatch. Polar tower $\Leftrightarrow$ $F(p)=0$ holds abstractly
by G1 finite truncation.

## Projective support

| Family | Support |
|--------|---------|
| based_minus_lines_odd_m | UNDECIDED |
| residual_e_ge7_generic_swap_both | UNDECIDED (free-path residual image killed) |

## Exit

```text
P25R2-UNDECIDED
```

Smallest unresolved sparse system: `tower_equations/unresolved_sparse_system.json`
(global polar tower on $V_{25}$, 43 variables, simultaneous $F_N$ for
$N=4,6,\ldots,74$). Resource floor: default 8 GiB; dense 842 floor
~0.089 GiB; director gate required
for larger structured jobs.

**Not** `P25-GLOBAL-EMPTY` (based branch not emptied).
**Not** `P25-GLOBAL-SURVIVES` (no certified component).
**Not** a degree-25 exclusion headline.

**Headline remains OPEN.**
