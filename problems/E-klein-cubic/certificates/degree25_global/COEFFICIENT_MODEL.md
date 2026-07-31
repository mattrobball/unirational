# P25R.0 — Exact characteristic-zero global coefficient model

**Headline: OPEN.**

**Exit: `P25R0-PASS`.**

**Dispatch: P25R.0 only.** Not a covariant. Not a headline claim.

## 1. Strict global coefficient space

$$
V_{25} = Q \oplus K, \qquad \dim Q = 37,\ \dim K = 6,\ \dim V_{25} = 43.
$$

- Ambient self-covariant space: $\dim M_{25} = 189$ (exact Molien).
- Arrangement kernel (plus-plane vanishing): dimension $59$.
- Common-line order $\ge 3$ (strict space): dimension $43$.
- Order-$\ge 4$ kernel $K$: dimension $6$; complement $Q$: dimension $37$.

Integral model: $R = \mathcal O_{\mathbf Q(\zeta_{11})}$ localized at a good
prime $\mathfrak p = (p,\zeta_{11}-\zeta)$ with $p\nmid 660$. Reynolds factor
$1/660$ is a unit in $R$. Evaluation rank $189$ of the frozen Reynolds seeds
identifies them with an $R$-basis of the covariant lattice (Nakayama).

## 2. Change-of-basis matrices

Frozen modular frames at $p=67$ (unit minors; lift as $R$-bases):

| Map | Shape | Role |
|-----|------:|------|
| arrangement $\leftarrow M_{25}$ | $59\times 189$ | plus-plane kernel |
| strict $\leftarrow$ arrangement | $43\times 59$ | common-line order $\ge 3$ |
| $Q\mid K$ frame on strict | $43\times 43$ | normalized coordinates |
| border module | rank $28$ | $\{1\}\oplus K\oplus$ quadratic |

SHA-256 digests of the modular arrays are sealed in `bases.json`
(`0e08a4716ea8152a…`). Good reduction at the stated primes recovers every
modular matrix used by the border-support and compact-degree-25 packets.

## 3. Restriction maps $\rho_r$

For $1\le r\le 25$,

$$
\rho_r : V_{25} \longrightarrow \mathrm{Sym}^r(E_-^*)\otimes E_\pm
$$

with free codomain dimension $(r+1)\cdot \dim E_\pm$. The multi-Rees ambient
$\mathrm{Sym}^{d-r}E_+^*\otimes\mathrm{Sym}^r E_-^*\otimes E_\pm$ is recorded
in `restriction_maps/rho_abstract.json`.

**Critical:** the image of each global map is compared with the free local
kernel; equality is **not** assumed. In particular at $r=25$ the free $a_d$
space has dimension $52$, while the genuine residual image has rank $7$.

Source / normal / target copies of $\mathbf P(E_-)$ remain distinct
(repaired transition category). Equalizer targets (source line, exceptional
normal line, target line, $V_4$ triple-line, point kernels, character blocks)
are listed in the restriction map ledger.

## 4. Residual module (characteristic zero)

The residual module of $V_{25}$ on the source involution line has

$$
\mathrm{rank}_{\mathbf Q} = 7.
$$

Confirmed by multi-prime residual restriction ranks
$\mathrm{rank}_{\mathbf F_p} = 7$ at $p\in\{89,199,331\}$ (and the sealed
$p=67$ strict-space computation), with DVR promotion recorded in
`residual_module_char0.json` (`bf81066034f18dff…`).

The seven based-minus-line rows are reconstructed by evaluation at $p=67$
(not imported as characteristic-zero entries from a static $\mathbf F_{67}$
table). Based kernel dimension in $V_{25}$: $36 = 43-7$.

## 5. Required checks (P25R.0)

| Check | Status |
|-------|--------|
| Every rank claim exact in char 0 (direct or DVR) | PASS |
| Modular matrices recovered by good reduction | PASS |
| Source / normal / target $\mathbf P(E_-)$ distinct | PASS |
| Seven based rows reconstructed | PASS |
| Global image $\neq$ free local kernel assumed | PASS (explicit residual 7 vs free 52) |

## 6. Exit

```text
P25R0-PASS
```

All downstream P25R stages must reference this single model. No re-derivation
of bases or parallel coordinate conventions.

**Headline remains OPEN.**
