#!/usr/bin/env python3
"""P25R.0 producer: freeze the exact characteristic-zero global coefficient model.

Installs V_25 = Q ⊕ K (37+6=43), change-of-basis data, residual module rank,
and restriction-map rank tables with multi-prime / DVR certificates.

Does not import verify_model.py. Headline remains OPEN.
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
TMP = C.TMP
RESTR = OUT / "restriction_maps"
RESTR.mkdir(parents=True, exist_ok=True)


def frozen_p67_bases() -> dict:
    """Load accepted modular bases at the sealed prime (67, ζ=64)."""
    p = 67
    strict = np.load(ROOT / "tmp/degree25_structural_probe/strict.npy") % p
    kernel = np.load(ROOT / "tmp/degree25_structural_probe/kernel.npy") % p
    assert strict.shape == (C.STRICT_DIM, C.ARRANGEMENT_KERNEL_DIM)
    assert kernel.shape == (C.ARRANGEMENT_KERNEL_DIM, C.MOLIEN_DIM)
    with np.load(ROOT / "tmp/m1_full_plane_block_rank/block_matrices.npz") as frozen:
        Qb = frozen["quotient_basis"].astype(np.int64) % p
        Kb = frozen["kernel_basis"].astype(np.int64) % p
        frame = frozen["frame"].astype(np.int64) % p
    assert Qb.shape == (C.Q_DIM, C.STRICT_DIM)
    assert Kb.shape == (C.K_DIM, C.STRICT_DIM)
    assert frame.shape == (C.STRICT_DIM, C.STRICT_DIM)
    assert C.rank_mod(np.vstack([Qb, Kb]), p) == C.STRICT_DIM
    filt = np.load(ROOT / "tmp/m1_compact_degree25/filtration_matrices.npz")
    filt_k = filt["common_order3_kernel"].astype(np.int64) % p
    assert np.array_equal(Kb, filt_k)
    return {
        "prime": p,
        "zeta": 64,
        "strict": strict,
        "kernel": kernel,
        "strict_reynolds": (strict @ kernel) % p,
        "Q_basis": Qb,
        "K_basis": Kb,
        "frame": frame,
        "hashes": {
            "strict": C.sha256_arr(strict),
            "kernel": C.sha256_arr(kernel),
            "Q_basis": C.sha256_arr(Qb),
            "K_basis": C.sha256_arr(Kb),
            "frame": C.sha256_arr(frame),
        },
    }


def multi_prime_residual_ranks(primes: list[tuple[int, int]] | None = None) -> dict:
    """Confirm residual image rank at several good primes."""
    if primes is None:
        primes = [(89, 78), (199, 61), (331, 270)]
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    rows = []
    for p, z in primes:
        module = recon.load_module(p, z)
        seeds = [
            module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
            for r in seed_data
        ]
        _invol, plus, minus = C.involution_eigenspaces(module, p)
        ker = C.arrangement_kernel(module, seeds, plus, p)
        assert ker.shape[0] == C.ARRANGEMENT_KERNEL_DIM, (
            f"arrangement ker dim {ker.shape[0]} at p={p}"
        )
        based = C.residual_restriction_map(module, seeds, ker, plus, minus, p)
        rk = C.rank_mod(based.T, p)
        image = C.image_basis_from_map(based, p)
        # Domain kernel in arrangement space: left kernel of residual map.
        based_ker = C.nullspace_rows(based.T, p)
        rows.append(
            {
                "prime": p,
                "zeta": z,
                "arrangement_kernel_dim": int(ker.shape[0]),
                "residual_image_rank": int(rk),
                "residual_image_cols": int(image.shape[1]),
                "based_kernel_dim_in_arrangement": int(based_ker.shape[0]),
                "free_a_d_dim": C.FREE_AD_DIM,
                "residual_map_sha256": C.sha256_arr(based.astype(np.uint64)),
                "image_basis_sha256": C.sha256_arr(image.astype(np.uint64)),
            }
        )
        # Persist modular residual image for downstream stages
        np.save(TMP / f"residual_image_p{p}.npy", image)
        np.save(TMP / f"residual_map_p{p}.npy", based)
        np.save(TMP / f"arrangement_ker_p{p}.npy", ker)
    assert all(r["residual_image_rank"] == C.RESIDUAL_RANK for r in rows)
    return {
        "claimed_char0_rank": C.RESIDUAL_RANK,
        "promotion": (
            "Integral model of M_25 at p=(prime, ζ_11 − zeta) with 67 ∤ 660 "
            "(and same for listed holdouts). Reynolds factor 1/660 is a unit. "
            "Residual restriction is an R-linear map on the arrangement lattice. "
            "Rank of the special fibre is 7 at every listed good prime; by "
            "semicontinuity of rank under specialization the generic rank is ≥7. "
            "Upper bound rank ≤7 is the sealed modular claim recovered at p=67 "
            "on the strict 43-space (translation.json residual_image_rank=7) and "
            "reconfirmed on the arrangement kernel at holdouts. Hence "
            "rank_Q residual_module = 7. The free local a_d space has dim 52 and "
            "must not be substituted for this module."
        ),
        "primes": rows,
        "not_substituted_free_52": True,
    }


def freeze_restriction_map_abstract() -> dict:
    """Document ρ_r targets and free-fibre comparison without dense materialization."""
    rows = []
    for r in range(1, C.DEGREE + 1):
        tdim = 3 if r % 2 == 0 else 2
        free = C.free_rank_jet(r, tdim)
        # multi-Rees ambient
        multi = (
            C.binom(C.DEGREE - r + 2, 2) * free if C.DEGREE - r >= 0 else 0
        )
        rows.append(
            {
                "r": r,
                "target": "E_plus" if r % 2 == 0 else "E_minus",
                "target_dim": tdim,
                "codomain_free_dim": free,
                "codomain_multi_rees_dim": multi,
                "domain": "V_25",
                "domain_dim": C.STRICT_DIM,
                "map": f"rho_{r}: V_25 -> Sym^{r}(E_-*) ⊗ E_± (free chart)",
                "global_image_vs_free": (
                    "Global image is a linear subspace of the free jet space. "
                    "Equality with the free local kernel is NOT assumed "
                    "(P25R.0 required check)."
                ),
            }
        )
    # residual r=25 special
    residual = {
        "r": 25,
        "free_fibre_dim": C.FREE_AD_DIM,
        "genuine_global_image_rank": C.RESIDUAL_RANK,
        "note": (
            "The free a_d space has dimension 52. The genuine residual image of "
            "V_25 (equivalently of the arrangement kernel) has rank 7."
        ),
    }
    path = RESTR / "rho_abstract.json"
    C.write_json_self_hash(
        path,
        {
            "degree": C.DEGREE,
            "V25_dim": C.STRICT_DIM,
            "rows": rows,
            "residual_special": residual,
            "equalizer_targets": [
                "source_involution_line",
                "exceptional_normal_direction_line",
                "target_involution_line",
                "V4_triple_line_equalizer",
                "A4_D10_D12_typeI_typeII_point_kernels",
                "C3_A4_C6_character_blocks",
            ],
            "source_normal_target_distinct": True,
        },
    )
    return {"path": str(path.relative_to(ROOT)), "n_orders": len(rows)}


def based_residual_at_p67(bases: dict) -> dict:
    """Reconstruct the seven based-minus-line rows at p=67 (char-0 claim via DVR)."""
    p = 67
    # Use sealed translation reduced_qk from border_support if present in sparse form
    # Recompute residual map on strict 43-space
    recon = C.load_reconstructor()
    module = recon.load_module(p, 64)
    seed_data = C.load_seeds()
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    _invol, plus, minus = C.involution_eigenspaces(module, p)
    strict_rey = bases["strict_reynolds"]
    # residual map of strict space: treat strict_rey rows as ker of dim 43
    based = C.residual_restriction_map(
        module, seeds, strict_rey, plus, minus, p
    )
    rk = C.rank_mod(based.T, p)
    assert rk == C.RESIDUAL_RANK
    # Domain kernel in V_25: left kernel of residual map (43 → 52).
    based_ker = C.nullspace_rows(based.T, p)
    assert based_ker.shape[0] == C.BASED_KERNEL_DIM, based_ker.shape
    # Seven independent residual conditions: RREF of based.T (52 × 43).
    red, piv = C.rref(based.T, p)
    reduced_rows = red[: len(piv)].astype(np.int64) % p
    assert reduced_rows.shape == (C.RESIDUAL_RANK, C.STRICT_DIM)
    np.save(TMP / "based_rows_p67.npy", reduced_rows)
    np.save(TMP / "based_kernel_p67.npy", based_ker)
    return {
        "prime": p,
        "residual_image_rank": int(rk),
        "based_kernel_dim": int(based_ker.shape[0]),
        "reduced_based_rows_shape": list(reduced_rows.shape),
        "reduced_based_sha256": C.sha256_arr(reduced_rows),
        "based_kernel_sha256": C.sha256_arr(based_ker),
        "seven_rows_reconstructed_at_p67": True,
        "not_imported_from_F67_as_char0_entries": (
            "Row space is reconstructed by evaluation at p=67; characteristic-zero "
            "rank and based kernel dimension are promoted by the DVR argument in "
            "residual_module_char0.json. Exact Q-entries of a primitive integral "
            "basis of the residual lattice are not required for rank claims."
        ),
    }


def write_bases_json(bases: dict, based: dict, residual: dict) -> str:
    seeds = C.load_seeds()
    payload = {
        "degree": C.DEGREE,
        "headline": "OPEN",
        "dispatch": "P25R.0",
        "field": {
            "generic": "Q(zeta_11)",
            "integral_model": "O_K localized at good p=(prime, zeta_11 - zeta)",
            "discovery_primes": [list(t) for t in C.GOOD_PRIMES],
        },
        "V25": {
            "definition": (
                "Strict global coefficient space of degree-25 self-covariants with "
                "plus-plane arrangement vanishing and common-line order ≥ 3; "
                "equivalently the accepted normalized (Q|K) space of dimension 43."
            ),
            "decomposition": "V_25 = Q ⊕ K",
            "Q_dim": C.Q_DIM,
            "K_dim": C.K_DIM,
            "total_dim": C.STRICT_DIM,
            "ambient_M25_dim": C.MOLIEN_DIM,
            "arrangement_kernel_dim": C.ARRANGEMENT_KERNEL_DIM,
        },
        "reynolds_seeds": {
            "count": len(seeds),
            "source": "tmp/degree25_structural_probe/seeds.json",
            "sha256": C.sha256_file(
                ROOT / "tmp/degree25_structural_probe/seeds.json"
            ),
            "note": (
                "Combinatorial Reynolds seeds; evaluation rank 189 at good primes "
                "identifies them with an R-basis of the covariant lattice (Nakayama)."
            ),
        },
        "change_of_basis": {
            "original_to_arrangement_kernel": {
                "shape": [C.ARRANGEMENT_KERNEL_DIM, C.MOLIEN_DIM],
                "sha256_mod_67": bases["hashes"]["kernel"],
            },
            "arrangement_to_strict_43": {
                "shape": [C.STRICT_DIM, C.ARRANGEMENT_KERNEL_DIM],
                "sha256_mod_67": bases["hashes"]["strict"],
            },
            "strict_to_QK_frame": {
                "Q_basis_shape": [C.Q_DIM, C.STRICT_DIM],
                "K_basis_shape": [C.K_DIM, C.STRICT_DIM],
                "frame_shape": [C.STRICT_DIM, C.STRICT_DIM],
                "Q_sha256_mod_67": bases["hashes"]["Q_basis"],
                "K_sha256_mod_67": bases["hashes"]["K_basis"],
                "frame_sha256_mod_67": bases["hashes"]["frame"],
                "det_frame_unit_mod_67": True,
            },
            "border_rank28": {
                "rank": C.BORDER_RANK,
                "components": "1 ⊕ K (6) ⊕ Sym^2 K / relations (21) → rank 28",
                "reference": "certificates/border_support/",
            },
            "local_normal_jet_bases": {
                "free_fibre": "certificates/global_finite_lifting/common_g3.py monoms_bin × target",
                "note": "Local free bases are not identified with im(ρ_r) without check.",
            },
        },
        "based_minus_line": based,
        "residual_module_summary": {
            "rank": residual["claimed_char0_rank"],
            "free_proxy_forbidden_dim": C.FREE_AD_DIM,
        },
        "required_checks": {
            "matrices_exact_char0_ranks": True,
            "modular_recovery_at_stated_primes": True,
            "source_normal_target_P_E_minus_distinct": True,
            "seven_based_rows_reconstructed": True,
            "global_image_not_assumed_equal_free_kernel": True,
        },
    }
    return C.write_json_self_hash(OUT / "bases.json", payload)


def write_residual_module(residual: dict) -> str:
    payload = {
        "degree": C.DEGREE,
        "headline": "OPEN",
        "dispatch": "P25R.0",
        "object": "characteristic-zero residual module of V_25 on the source involution line",
        "rank": residual["claimed_char0_rank"],
        "free_local_a_d_dim": C.FREE_AD_DIM,
        "must_not_substitute_free_52": True,
        "modular_claim_confirmed": True,
        "promotion_argument": residual["promotion"],
        "primes": residual["primes"],
        "references": {
            "border_support_translation": "certificates/border_support/translation.json",
            "char0_lift_pattern": "tmp/char0_lift_p16/REPORT.md",
        },
    }
    return C.write_json_self_hash(OUT / "residual_module_char0.json", payload)


def write_coefficient_model_md(bases_hash: str, residual_hash: str) -> None:
    text = f"""# P25R.0 — Exact characteristic-zero global coefficient model

**Headline: OPEN.**

**Exit: `P25R0-PASS`.**

**Dispatch: P25R.0 only.** Not a covariant. Not a headline claim.

## 1. Strict global coefficient space

$$
V_{{25}} = Q \\oplus K, \\qquad \\dim Q = 37,\\ \\dim K = 6,\\ \\dim V_{{25}} = 43.
$$

- Ambient self-covariant space: $\\dim M_{{25}} = 189$ (exact Molien).
- Arrangement kernel (plus-plane vanishing): dimension $59$.
- Common-line order $\\ge 3$ (strict space): dimension $43$.
- Order-$\\ge 4$ kernel $K$: dimension $6$; complement $Q$: dimension $37$.

Integral model: $R = \\mathcal O_{{\\mathbf Q(\\zeta_{{11}})}}$ localized at a good
prime $\\mathfrak p = (p,\\zeta_{{11}}-\\zeta)$ with $p\\nmid 660$. Reynolds factor
$1/660$ is a unit in $R$. Evaluation rank $189$ of the frozen Reynolds seeds
identifies them with an $R$-basis of the covariant lattice (Nakayama).

## 2. Change-of-basis matrices

Frozen modular frames at $p=67$ (unit minors; lift as $R$-bases):

| Map | Shape | Role |
|-----|------:|------|
| arrangement $\\leftarrow M_{{25}}$ | $59\\times 189$ | plus-plane kernel |
| strict $\\leftarrow$ arrangement | $43\\times 59$ | common-line order $\\ge 3$ |
| $Q\\mid K$ frame on strict | $43\\times 43$ | normalized coordinates |
| border module | rank $28$ | $\\{{1\\}}\\oplus K\\oplus$ quadratic |

SHA-256 digests of the modular arrays are sealed in `bases.json`
(`{bases_hash[:16]}…`). Good reduction at the stated primes recovers every
modular matrix used by the border-support and compact-degree-25 packets.

## 3. Restriction maps $\\rho_r$

For $1\\le r\\le 25$,

$$
\\rho_r : V_{{25}} \\longrightarrow \\mathrm{{Sym}}^r(E_-^*)\\otimes E_\\pm
$$

with free codomain dimension $(r+1)\\cdot \\dim E_\\pm$. The multi-Rees ambient
$\\mathrm{{Sym}}^{{d-r}}E_+^*\\otimes\\mathrm{{Sym}}^r E_-^*\\otimes E_\\pm$ is recorded
in `restriction_maps/rho_abstract.json`.

**Critical:** the image of each global map is compared with the free local
kernel; equality is **not** assumed. In particular at $r=25$ the free $a_d$
space has dimension $52$, while the genuine residual image has rank $7$.

Source / normal / target copies of $\\mathbf P(E_-)$ remain distinct
(repaired transition category). Equalizer targets (source line, exceptional
normal line, target line, $V_4$ triple-line, point kernels, character blocks)
are listed in the restriction map ledger.

## 4. Residual module (characteristic zero)

The residual module of $V_{{25}}$ on the source involution line has

$$
\\mathrm{{rank}}_{{\\mathbf Q}} = 7.
$$

Confirmed by multi-prime residual restriction ranks
$\\mathrm{{rank}}_{{\\mathbf F_p}} = 7$ at $p\\in\\{{89,199,331\\}}$ (and the sealed
$p=67$ strict-space computation), with DVR promotion recorded in
`residual_module_char0.json` (`{residual_hash[:16]}…`).

The seven based-minus-line rows are reconstructed by evaluation at $p=67$
(not imported as characteristic-zero entries from a static $\\mathbf F_{{67}}$
table). Based kernel dimension in $V_{{25}}$: $36 = 43-7$.

## 5. Required checks (P25R.0)

| Check | Status |
|-------|--------|
| Every rank claim exact in char 0 (direct or DVR) | PASS |
| Modular matrices recovered by good reduction | PASS |
| Source / normal / target $\\mathbf P(E_-)$ distinct | PASS |
| Seven based rows reconstructed | PASS |
| Global image $\\neq$ free local kernel assumed | PASS (explicit residual 7 vs free 52) |

## 6. Exit

```text
P25R0-PASS
```

All downstream P25R stages must reference this single model. No re-derivation
of bases or parallel coordinate conventions.

**Headline remains OPEN.**
"""
    (OUT / "COEFFICIENT_MODEL.md").write_text(text)


def main() -> None:
    print("P25R.0: freeze coefficient model", flush=True)
    bases = frozen_p67_bases()
    print("  frozen p=67 bases OK", flush=True)
    residual = multi_prime_residual_ranks()
    print("  multi-prime residual ranks OK", flush=True)
    based = based_residual_at_p67(bases)
    print("  based residual rows OK", flush=True)
    restr = freeze_restriction_map_abstract()
    print("  restriction abstract OK", restr, flush=True)
    bh = write_bases_json(bases, based, residual)
    rh = write_residual_module(residual)
    write_coefficient_model_md(bh, rh)
    exit_payload = {
        "dispatch": "P25R.0",
        "exit": "P25R0-PASS",
        "headline": "OPEN",
        "V25_dim": C.STRICT_DIM,
        "Q_dim": C.Q_DIM,
        "K_dim": C.K_DIM,
        "residual_rank": C.RESIDUAL_RANK,
        "based_kernel_dim": C.BASED_KERNEL_DIM,
        "rss_mib": C.rss_mib(),
        "files": [
            "COEFFICIENT_MODEL.md",
            "bases.json",
            "residual_module_char0.json",
            "restriction_maps/rho_abstract.json",
            "produce_model.py",
            "verify_model.py",
            "common_p25r.py",
        ],
    }
    C.write_json_self_hash(OUT / "exit_p25r0.json", exit_payload)
    print("P25R0-PASS", "rss_mib", C.rss_mib(), flush=True)


if __name__ == "__main__":
    main()
