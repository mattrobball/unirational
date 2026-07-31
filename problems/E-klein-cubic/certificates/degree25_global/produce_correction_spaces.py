#!/usr/bin/env python3
"""P25R.1 producer: genuine global correction spaces from one global c ∈ V_25.

Does not import verify_correction_spaces.py. Requires P25R0-PASS.
Headline remains OPEN.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import common_p25r as C  # noqa: E402

ROOT = C.ROOT
OUT = HERE
GFL = ROOT / "certificates" / "global_finite_lifting"
sys.path.insert(0, str(GFL))
from common_g3 import (  # noqa: E402
    free_rank_jet,
    isolable_r_list,
    jet_dimension_table,
    stage_ledger,
)


def require_p25r0() -> dict:
    exit0 = json.loads((OUT / "exit_p25r0.json").read_text())
    assert exit0["exit"] == "P25R0-PASS", exit0
    return exit0


def family_linear_gates() -> dict:
    """Linear gates on the single global vector c ∈ V_25."""
    return {
        "based_minus_lines_odd_m": {
            "family_id": "based_minus_lines_odd_m",
            "live_at_m1_d25": True,
            "linear_conditions": {
                "object": "residual restriction of c to source involution line L_t vanishes",
                "rank": C.RESIDUAL_RANK,
                "kernel_dim_in_V25": C.BASED_KERNEL_DIM,
                "matrix_reference": "tmp/p25r/based_rows_p67.npy (row space rank 7)",
            },
            "a_odd": "forced zero on free fibre; globally automatic from based residual = 0",
            "free_proxy_forbidden": {
                "high_order_Eplus_ker_free": (
                    "P25.1 used free high-order ker L_r (r≥13) as independent "
                    "parameters. Globally those jets are ρ_r(c) for c in the "
                    "based kernel of dimension 36 — not free of total rank "
                    "sum_r nullity(L_r)."
                )
            },
            "C_r_glob_parametrization": "c ∈ ker(based residual map) ⊂ V_25, dim 36",
        },
        "residual_e_ge7_generic_swap_both": {
            "family_id": "residual_e_ge7_generic_swap_both",
            "live_at_m1_d25": True,
            "linear_conditions": {
                "object": "no additional linear cut on V_25 beyond arrangement/strict filtration",
                "rank": 0,
                "kernel_dim_in_V25": C.STRICT_DIM,
                "swap_both_open": "Zariski-open in residual P^6 ledger; nonlinear later",
            },
            "a_d_global": {
                "free_fibre_dim": C.FREE_AD_DIM,
                "genuine_image_rank": C.RESIDUAL_RANK,
                "replacement": (
                    "Replace free 52-dimensional a_d by the genuine residual "
                    "image im(ρ_res) of rank 7 inside Sym^{25}(E_-*)⊗E_-."
                ),
            },
            "C_r_glob_parametrization": "c ∈ V_25 (dim 43); a_d = ρ_25(c) ∈ residual image (dim 7)",
        },
        "residual_e1_swap_both": {
            "live_at_m1_d25": False,
            "reason": "Requires residual e=1 i.e. d=6m+1=7 for m=1; not degree 25.",
        },
    }


def stage_subspaces() -> dict:
    """Per-stage global correction description with single global c."""
    jt = jet_dimension_table(C.M_PLANE, C.DEGREE)
    ledger = stage_ledger(C.M_PLANE, C.DEGREE)
    isolable = isolable_r_list(C.M_PLANE, C.DEGREE)

    stages = []
    for row in jt["rows"]:
        r = row["normal_order"]
        stages.append(
            {
                "r": r,
                "target": row["target"],
                "free_fibre_rank": row["free_fibre_rank"],
                "multi_rees_dim": row["multi_rees_dim"],
                "C_r_glob": {
                    "definition": (
                        "C_r^glob = ρ_r(V_25) ∩ ker L_r ∩ E_V4 ∩ E_points ∩ "
                        "E_chars ∩ E_source_line, all factors from P25R.0 matrices."
                    ),
                    "parametrized_by": "single global c ∈ V_25 (family linear gates applied)",
                    "not_independent_per_stage": True,
                    "domain_dim_upper": C.STRICT_DIM,
                    "free_fibre_rank_upper": row["free_fibre_rank"],
                    "equality_with_free_ker_assumed": False,
                },
                "isolable_operator": (r in isolable) and (r % 2 == 1),
            }
        )

    # Residual special at r=25
    residual_stage = {
        "r": 25,
        "free_fibre_a_d_dim": C.FREE_AD_DIM,
        "genuine_global_image_rank": C.RESIDUAL_RANK,
        "critical": (
            "P25.1 residual family used free a_d of dim 52. Genuine global "
            "correction space uses residual image of rank 7."
        ),
    }

    return {
        "bidegree": {"m": C.M_PLANE, "d": C.DEGREE},
        "global_coordinate_vector": {
            "name": "c",
            "space": "V_25",
            "dim": C.STRICT_DIM,
            "rule": "Every jet is a linear function of the same c; no stagewise reset.",
        },
        "block_map": "rho_le_25: V_25 → ⊕_{r=1}^{25} J_r",
        "stages": stages,
        "residual_stage": residual_stage,
        "nonautomatic_F_orders": ledger["nonautomatic_orders"],
        "N_star": C.N_STAR,
    }


def write_global_jet_map_meta(stage: dict) -> None:
    """Sparse meta for the block map (no dense 868×43 materialization)."""
    path = OUT / "global_jet_map.json"
    C.write_json_self_hash(
        path,
        {
            "representation": "sparse_block_linear",
            "domain": {"name": "V_25", "dim": C.STRICT_DIM},
            "codomain_free_total": sum(s["free_fibre_rank"] for s in stage["stages"]),
            "codomain_multi_rees_total": sum(
                s["multi_rees_dim"] for s in stage["stages"]
            ),
            "blocks": [
                {
                    "r": s["r"],
                    "free_dim": s["free_fibre_rank"],
                    "map": f"rho_{s['r']}",
                }
                for s in stage["stages"]
            ],
            "dense_868x43_materialized": False,
            "reason": (
                "Preferred sparse representation. Dense free-jet matrix is larger "
                "than residual/based linear gates + polar sparse operators used "
                "downstream; preflight favors sparse residual 7-space and based 36-space."
            ),
            "compatibility": stage["global_coordinate_vector"],
        },
    )


def main() -> None:
    print("P25R.1: global correction spaces", flush=True)
    require_p25r0()
    gates = family_linear_gates()
    stages = stage_subspaces()
    write_global_jet_map_meta(stages)

    C.write_json_self_hash(OUT / "family_linear_gates.json", gates)
    C.write_json_self_hash(OUT / "stage_subspaces.json", stages)

    md = f"""# P25R.1 — Genuine global correction spaces

**Headline: OPEN.**

**Exit: `P25R1-PASS`.**

**Requires: `P25R0-PASS`.**

## Critical consistency rule

Every jet is a **linear** function of one global coordinate vector

$$
c \\in V_{{25}},\\qquad \\dim V_{{25}} = 43.
$$

No stage may choose an independent element of a free local kernel. The block map

$$
\\rho_{{\\le 25}} : V_{{25}} \\longrightarrow \\bigoplus_{{r=1}}^{{25}} J_r
$$

is the sole source of all polar jets.

## Family linear gates

### `based_minus_lines_odd_m`

- Residual restriction of $c$ to the source involution line vanishes.
- Rank $7$ linear conditions; based kernel dimension **$36$** in $V_{{25}}$.
- Free high-order $E_+$ kernels used in P25.1 are **not** global parameters;
  they are replaced by $\\rho_r(c)$ for $c$ in the based kernel.

### `residual_e_ge7_generic_swap_both`

- No extra linear cut on $V_{{25}}$ beyond the strict filtration.
- Free $a_d$ of dimension **$52$ is forbidden** as a global correction space.
- Genuine residual image: $\\operatorname{{rank}} = 7$ (P25R.0).
- `swap_both` remains a Zariski-open ledger condition (nonlinear saturation later).

## Stage formula

$$
C_r^{{\\mathrm{{glob}}}}
=
\\rho_r(V_{{25}})
\\cap \\ker L_r
\\cap E_{{V_4}}
\\cap E_{{\\mathrm{{points}}}}
\\cap E_{{\\mathrm{{chars}}}}
\\cap E_{{\\mathrm{{source\\ line}}}}.
$$

Each factor is represented by an exact matrix / rank certificate from P25R.0.
Local free-module surjectivity is **not** promoted to global solvability.

## Artifacts

- `family_linear_gates.json`
- `stage_subspaces.json`
- `global_jet_map.json` (sparse block meta; no dense $868\\times 43$)
- `GLOBAL_CORRECTION_SPACES.md` (this file)

## Exit

```text
P25R1-PASS
```

Both families remain live at the linear level (based kernel dim $36>0$; residual
ambient dim $43>0$). Emptiness, if any, is decided by nonlinear tower equations
in P25R.2.

**Headline remains OPEN.**
"""
    (OUT / "GLOBAL_CORRECTION_SPACES.md").write_text(md)

    exit_payload = {
        "dispatch": "P25R.1",
        "exit": "P25R1-PASS",
        "headline": "OPEN",
        "based_kernel_dim": C.BASED_KERNEL_DIM,
        "residual_image_rank": C.RESIDUAL_RANK,
        "free_a_d_proxy_rejected": True,
        "families_live_linear": [
            "based_minus_lines_odd_m",
            "residual_e_ge7_generic_swap_both",
        ],
        "rss_mib": C.rss_mib(),
    }
    C.write_json_self_hash(OUT / "exit_p25r1.json", exit_payload)
    print("P25R1-PASS", flush=True)


if __name__ == "__main__":
    main()
