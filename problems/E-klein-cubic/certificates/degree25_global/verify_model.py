#!/usr/bin/env python3
"""Independent verifier for P25R.0 coefficient model.

Does not import produce_model.py. Checks ranks, sealed digests, and the
residual-module multi-prime claim by replaying evaluations at one holdout.
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


def load_json(name: str) -> dict:
    return json.loads((HERE / name).read_text())


def check_self_hash(path: Path) -> None:
    data = json.loads(path.read_text())
    claimed = data.get("self_sha256")
    body = {k: v for k, v in data.items() if k != "self_sha256"}
    text = C.canonical_json(body)
    actual = C.sha256_bytes(text.encode())
    assert claimed == actual, f"self_sha256 mismatch in {path.name}"


def main() -> None:
    print("verify_model: start", flush=True)
    for name in (
        "bases.json",
        "residual_module_char0.json",
        "restriction_maps/rho_abstract.json",
        "exit_p25r0.json",
    ):
        check_self_hash(HERE / name)
        print("  self_hash OK", name, flush=True)

    bases = load_json("bases.json")
    residual = load_json("residual_module_char0.json")
    abstract = load_json("restriction_maps/rho_abstract.json")
    exit0 = load_json("exit_p25r0.json")

    assert exit0["exit"] == "P25R0-PASS"
    assert bases["V25"]["total_dim"] == 43
    assert bases["V25"]["Q_dim"] == 37
    assert bases["V25"]["K_dim"] == 6
    assert residual["rank"] == 7
    assert residual["free_local_a_d_dim"] == 52
    assert residual["must_not_substitute_free_52"] is True
    assert abstract["source_normal_target_distinct"] is True
    assert len(abstract["rows"]) == 25

    # Replay modular bases at p=67
    p = 67
    strict = np.load(ROOT / "tmp/degree25_structural_probe/strict.npy") % p
    kernel = np.load(ROOT / "tmp/degree25_structural_probe/kernel.npy") % p
    assert strict.shape == (43, 59)
    assert kernel.shape == (59, 189)
    assert C.sha256_arr(strict) == bases["change_of_basis"]["arrangement_to_strict_43"]["sha256_mod_67"]
    assert C.sha256_arr(kernel) == bases["change_of_basis"]["original_to_arrangement_kernel"]["sha256_mod_67"]
    with np.load(ROOT / "tmp/m1_full_plane_block_rank/block_matrices.npz") as frozen:
        Qb = frozen["quotient_basis"].astype(np.int64) % p
        Kb = frozen["kernel_basis"].astype(np.int64) % p
    assert C.rank_mod(np.vstack([Qb, Kb]), p) == 43
    assert C.sha256_arr(Qb) == bases["change_of_basis"]["strict_to_QK_frame"]["Q_sha256_mod_67"]
    assert C.sha256_arr(Kb) == bases["change_of_basis"]["strict_to_QK_frame"]["K_sha256_mod_67"]

    # Holdout residual rank replay at p=89
    recon = C.load_reconstructor()
    module = recon.load_module(89, 78)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in C.load_seeds()
    ]
    _invol, plus, minus = C.involution_eigenspaces(module, 89)
    ker = C.arrangement_kernel(module, seeds, plus, 89)
    assert ker.shape[0] == 59
    based = C.residual_restriction_map(module, seeds, ker, plus, minus, 89)
    rk = C.rank_mod(based.T, 89)
    assert rk == 7, f"residual rank {rk} at p=89"
    print("  residual rank 7 at p=89 OK", flush=True)

    # Sealed multi-prime table
    assert all(row["residual_image_rank"] == 7 for row in residual["primes"])
    assert bases["based_minus_line"]["based_kernel_dim"] == 36
    assert bases["based_minus_line"]["residual_image_rank"] == 7

    # COEFFICIENT_MODEL.md present
    assert (HERE / "COEFFICIENT_MODEL.md").is_file()
    print("P25R0_MODEL_VERIFIED", flush=True)


if __name__ == "__main__":
    main()
