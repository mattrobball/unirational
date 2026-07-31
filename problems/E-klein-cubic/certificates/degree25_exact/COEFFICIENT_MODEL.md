# P25X.0 — Executable characteristic-zero coefficient model

**Headline: OPEN.**

**Exit: `P25X0-PASS`.**

**Dispatch: P25X.0 then P25X.1 only.** Not a covariant. Not a headline claim.

## 1. Field and integral model

Work over the minimal cyclotomic field

$$
K = \mathbf Q(\zeta_{11}).
$$

Integral model: $\mathcal O_K$ localised at good primes $\mathfrak p = (p,\zeta_{11}-\zeta)$
with $p\nmid 660$. Reynolds factor $1/660$ is a unit. The group matrices and
Reynolds seeds are the standard Klein representation specialisations.

## 2. Strict global coefficient space $V_{25}$

$$
\dim M_{25} = 189,\qquad
\dim\mathrm{Arr} = 59,\qquad
\dim V_{25} = 43 = 37 + 6 = \dim Q + \dim K.
$$

Construction circuit (replayable over $K$, executed here at good primes):

1. Arrangement kernel = nullspace of evaluation of the 189 Reynolds seeds on a
   unisolvent triangular grid of the plus-plane of a fixed involution.
2. Strict space = kernel of the common-line order-2 map of rank 16 on the
   arrangement kernel (joint $D_{12}$ eigenbasis chart).
3. Monic RREF of the strict image in Reynolds coordinates = basis
   $p_1,\ldots,p_{43}$.
4. $K$ = kernel of the common-order-3 linear map on the strict space (rank 37);
   $Q$ = monic complement; frame $Q\oplus K$.

## 3. Materialized objects

| Object | Shape | Status |
|--------|------:|--------|
| monic Reynolds basis | $43\times 189$ | multiprime arrays + circuit |
| arrangement kernel | $59\times 189$ | multiprime |
| strict $\leftarrow$ arrangement | $43\times 59$ | multiprime |
| $Q\mid K$ frame | $43\times 43$ | multiprime |
| $\rho_{\le 25}$ | $868\times 43$ | **materialized** multiprime (`rho_1_to_25.npz`) |
| residual forms | $7\times 43$ | multiprime |
| border rank-28 | 28 | reference to `certificates/border_support/` |

Free jet total $\sum_{r=1}^{25}(r+1)\dim E_\pm = 868$.

## 4. Characteristic-zero entry audit

Monic RREF pivots stable; free entries Galois-fixed at each split prime (embedding-independent). Entrywise rational reconstruction with uniqueness bound √(M/2) does not pass holdouts on sampled positions. Exact model is the multimodular monic lattice plus the replayable arithmetic circuit over K (group + Reynolds + nullspaces). Not a claim that entries fail to lie in K — only that the monic Q-RREF was not recovered within the stated height bound.

Sample reconstruction audit (see `recon_audit.json`):

- pivots stable: True
- holdout OK / fail / mismatch: 0 / 4 / 1

## 5. Primes executed

- p=67, ζ=64: residual rank 7, K_dim=6, ρ sha 296855dd6d2b21ab…
- p=89, ζ=78: residual rank 7, K_dim=6, ρ sha 622c615e12306cae…
- p=199, ζ=61: residual rank 7, K_dim=6, ρ sha 3cf824ec49773674…
- p=331, ζ=270: residual rank 7, K_dim=6, ρ sha 16c7b3ad66ad4da8…
- p=353, ζ=58: residual rank 7, K_dim=6, ρ sha 9315610193b989cc…

## 6. What is *not* claimed

- No landing covariant.
- No free-fibre object is called global (residual rank 7 ≠ free 52).
- Metadata is not a substitute for the stored matrices / circuit.
- Full entrywise $K$-expansion of every seed coefficient tensor is not stored;
  the circuit evaluates seeds on demand.

## 7. Exit

```text
P25X0-PASS
```

**Headline remains OPEN.**
