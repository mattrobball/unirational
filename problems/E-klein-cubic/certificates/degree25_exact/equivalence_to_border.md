# Equivalence of landing ideal to rank-28 border presentation

**Headline: OPEN.**

## Status

Exact ideal containment in **both** directions between

- the direct cubic landing ideal of $F(p_c)$ on the monic Reynolds model of $V_{25}$, and
- the classical rank-28 border presentation $F/N$ of the normalized degree-25 landing system,

is **not** established over $K=\mathbf Q(\zeta_{11})$ in this dispatch.

## What is retained

| Object | Status |
|--------|--------|
| Border free module rank 28 | accepted prior (`certificates/border_support/`) |
| Historical modular 842-cubic basis at $p=67$ | discovery / rank bound |
| Sample landing bases at $p\in\{89,199,331\}$ | **rank 746** plateau (this packet) |
| Residual module rank 7 | P25X.0 multiprime |

## Residual gap

```text
GAP: exact char-0 generators of the cubic landing ideal in both the
direct monic-Reynolds presentation and the rank-28 border presentation,
with ideal containment both ways, are not installed.

Additional observation: the sample span of F(p_c) in monic Reynolds
coordinates has multiprime plateau rank 746 at p=89,199,331, while the
historical order-four plane basis has rank 842 at p=67 in (Q|K)
coordinates. Transport / equality of these two modular objects over K
is not proved; they must not be silently identified.
```

Machine-readable twin: `equivalence_to_border.json`.

**Headline remains OPEN.** No P25X.2 support run is authorized from this gap.
