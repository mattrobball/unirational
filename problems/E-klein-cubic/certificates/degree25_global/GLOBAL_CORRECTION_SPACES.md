# P25R.1 — Genuine global correction spaces

**Headline: OPEN.**

**Exit: `P25R1-PASS`.**

**Requires: `P25R0-PASS`.**

## Critical consistency rule

Every jet is a **linear** function of one global coordinate vector

$$
c \in V_{25},\qquad \dim V_{25} = 43.
$$

No stage may choose an independent element of a free local kernel. The block map

$$
\rho_{\le 25} : V_{25} \longrightarrow \bigoplus_{r=1}^{25} J_r
$$

is the sole source of all polar jets.

## Family linear gates

### `based_minus_lines_odd_m`

- Residual restriction of $c$ to the source involution line vanishes.
- Rank $7$ linear conditions; based kernel dimension **$36$** in $V_{25}$.
- Free high-order $E_+$ kernels used in P25.1 are **not** global parameters;
  they are replaced by $\rho_r(c)$ for $c$ in the based kernel.

### `residual_e_ge7_generic_swap_both`

- No extra linear cut on $V_{25}$ beyond the strict filtration.
- Free $a_d$ of dimension **$52$ is forbidden** as a global correction space.
- Genuine residual image: $\operatorname{rank} = 7$ (P25R.0).
- `swap_both` remains a Zariski-open ledger condition (nonlinear saturation later).

## Stage formula

$$
C_r^{\mathrm{glob}}
=
\rho_r(V_{25})
\cap \ker L_r
\cap E_{V_4}
\cap E_{\mathrm{points}}
\cap E_{\mathrm{chars}}
\cap E_{\mathrm{source\ line}}.
$$

Each factor is represented by an exact matrix / rank certificate from P25R.0.
Local free-module surjectivity is **not** promoted to global solvability.

## Artifacts

- `family_linear_gates.json`
- `stage_subspaces.json`
- `global_jet_map.json` (sparse block meta; no dense $868\times 43$)
- `GLOBAL_CORRECTION_SPACES.md` (this file)

## Exit

```text
P25R1-PASS
```

Both families remain live at the linear level (based kernel dim $36>0$; residual
ambient dim $43>0$). Emptiness, if any, is decided by nonlinear tower equations
in P25R.2.

**Headline remains OPEN.**
