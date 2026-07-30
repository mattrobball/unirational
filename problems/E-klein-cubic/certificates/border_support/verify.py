#!/usr/bin/env python3
"""Independent verifier for WP-6 border-support certificates.

Does not import produce.py. Rebuilds the based residual map and the Q|K
reduction from primary degree-25 artifacts, checks sealed JSON self-hashes
and sparse block ranks, and validates the memory-gate STOP formulation
bookkeeping. Does not claim support emptiness or a landing covariant.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import common as C  # noqa: E402

ROOT = C.ROOT
P = C.P
DEGREE = C.DEGREE
CERT = HERE


def load_json(name: str) -> dict:
    return json.loads((CERT / name).read_text())


def check_self_hash(name: str, payload: dict) -> None:
    body = {k: v for k, v in payload.items() if k != "self_sha256"}
    text = json.dumps(body, indent=2, sort_keys=True) + "\n"
    digest = C.sha256_bytes(text.encode())
    assert payload.get("self_sha256") == digest, f"self_sha256 mismatch in {name}"


def rebuild_based_reduced() -> tuple[np.ndarray, int, int]:
    d12 = C.load_module("d12_wp6_verify", ROOT / "tmp" / "d12_block_attack" / "analyze.py")
    audit = d12.audit
    reynolds = audit.load(audit.REYNOLDS, "wp6_verify_reynolds")
    module = reynolds.load_reynolds_module()
    seeds = [
        module.ReynoldsSeed(int(record["output"]), tuple(record["exponents"]))
        for record in json.loads(
            (ROOT / "tmp" / "degree25_structural_probe" / "seeds.json").read_text()
        )
    ]
    kernel = np.load(ROOT / "tmp" / "degree25_structural_probe" / "kernel.npy") % P
    strict = np.load(ROOT / "tmp" / "degree25_structural_probe" / "strict.npy") % P
    strict_reynolds = (strict @ kernel) % P
    (
        _centralizer,
        _positions,
        _rotation,
        _reflection,
        _plus,
        minus,
        basis,
        _basis_inv,
    ) = d12.adapted_d12_basis(module)
    minus = np.asarray(minus, dtype=np.int64) % P
    adapted_inv = C.invert_mod(np.asarray(basis, dtype=np.int64) % P)
    line_points = np.array(
        [(minus[0] + int(t) * minus[1]) % P for t in range(DEGREE + 1)],
        dtype=np.int64,
    )
    values = audit.batch_seed_evaluations(module, seeds, line_points, DEGREE)
    values = values.reshape(len(line_points), 5, 189)
    restriction = np.einsum("pwo,so->spw", values, strict_reynolds) % P
    coords = np.einsum("ij,spj->spi", adapted_inv, restriction) % P
    assert int(np.max(coords[:, :, :3])) == 0
    based_map = coords[:, :, 3:].reshape(43, -1)
    C_based = based_map.T % P
    rank = C.rank_mod(C_based)
    kernel_dim = C.nullspace_rows(C_based).shape[0]
    with np.load(ROOT / "tmp" / "m1_full_plane_block_rank" / "block_matrices.npz") as frozen:
        Qb = frozen["quotient_basis"].astype(np.int64) % P
        Kb = frozen["kernel_basis"].astype(np.int64) % P
    reduced_full, pivots = C.rref(
        np.hstack([(C_based @ Qb.T) % P, (C_based @ Kb.T) % P]) % P
    )
    reduced = (reduced_full[: len(pivots)] % P).astype(np.uint8)
    return reduced, rank, kernel_dim


def main() -> None:
    translation = load_json("translation.json")
    blocks = load_json("c3_a4_c6_blocks.json")
    restricted = load_json("restricted_module.json")
    support = load_json("support_status.json")
    seal = load_json("SEAL.json")

    for name, payload in [
        ("translation.json", translation),
        ("c3_a4_c6_blocks.json", blocks),
        ("restricted_module.json", restricted),
        ("support_status.json", support),
        ("SEAL.json", seal),
    ]:
        check_self_hash(name, payload)

    assert translation["headline"] == "OPEN"
    assert support["headline"] == "OPEN"
    assert support["support_decision"] == "NOT_DECIDED"
    assert support["surviving_point_claimed"] is False
    assert support["covariant_reconstructed"] is False
    assert support["finite_field_points_as_solutions"] is False
    assert support["exit_N3"] == "not reached"
    assert "parametrization" not in support["meaning"].lower() or "not a parametrization" in (
        translation["exit_P_status"] + support["meaning"]
    ).lower()

    # Provenance: cubic coefficients hash (array, not npz wrapper).
    cubic_sha = C.coefficients_sha256_from_npz(
        ROOT / "tmp" / "m1_full_plane_block_rank" / "full_cubic_basis.npz"
    )
    assert cubic_sha == translation["provenance"]["full_cubic_coefficients_sha256"]
    assert cubic_sha == "2fd6a5ad83f17de8826eb1787e062e79c66f6aac681197c24702c65df6135f76"

    with np.load(CERT / "sparse_blocks.npz") as frozen:
        based = frozen["based_reduced_qk"].astype(np.uint8)
        c3 = frozen["c3_optional_reduced_qk"].astype(np.uint8)
        a4 = frozen["a4_reduced_qk"].astype(np.uint8)
        c6 = frozen["c6_reduced_qk"].astype(np.uint8)

    assert based.shape[0] == 7
    assert based.shape[1] == 43
    assert C.rank_mod(based.astype(np.int64)) == 7
    assert C.sha256_arr(based) == translation["based_minus_line"]["reduced_qk_sha256"]
    assert (
        C.sha256_arr(based)
        == blocks["forced_blocks"]["based_minus_lines"]["matrix_sha256"]
    )

    rebuilt, rank, kernel_dim = rebuild_based_reduced()
    assert rank == 7
    assert kernel_dim == 36
    assert rebuilt.shape == based.shape
    assert np.array_equal(rebuilt, based)

    # Optional blocks: ranks match sealed metadata; C3 is not forced.
    assert blocks["optional_discovery_blocks"]["C3_not_forced_base"]["forced_base"] is False
    assert C.rank_mod(c3.astype(np.int64)) == int(
        blocks["optional_discovery_blocks"]["C3_not_forced_base"]["reduced_rank"]
    )
    assert C.sha256_arr(c3) == blocks["optional_discovery_blocks"]["C3_not_forced_base"][
        "matrix_sha256"
    ]
    assert C.rank_mod(a4.astype(np.int64)) == int(
        blocks["optional_discovery_blocks"]["A4_character_values"]["reduced_rank"]
    )
    assert C.sha256_arr(a4) == blocks["optional_discovery_blocks"]["A4_character_values"][
        "matrix_sha256"
    ]
    assert C.rank_mod(c6.astype(np.int64)) == int(
        blocks["optional_discovery_blocks"]["C6_endpoints_on_L_t"]["reduced_rank"]
    )
    assert C.sha256_arr(c6) == blocks["optional_discovery_blocks"]["C6_endpoints_on_L_t"][
        "matrix_sha256"
    ]

    # Family translation boundaries.
    families = translation["families"]
    assert families["based_minus_lines_odd_m"]["live_at_m1_d25"] is True
    assert families["based_minus_lines_odd_m"]["linear_conditions_rank"] == 7
    assert families["residual_e1_swap_both"]["live_at_m1_d25"] is False
    assert families["residual_e_ge7_generic_swap_both"]["linear_cut"] is None

    # Formulation memory gate bookkeeping.
    formulation = restricted["formulation"]
    assert formulation["memory_gate"]["exploratory_ceiling_RSS_GiB"] == 8
    assert formulation["memory_gate"]["classical_global_degree4"]["cannot_be_full_by_row_count"]
    assert formulation["memory_gate"]["earliest_degree_not_excluded_by_raw_row_count"] == 7
    dim7 = C.dim_border_piece(7)
    assert formulation["graded_dimensions"]["7"]["dim_F_d"] == dim7
    assert dim7 > 10**6  # far beyond exploratory dense work
    assert "raw_43_variable_projective_solve" in formulation["forbidden_by_stopping_rule"]
    assert restricted["saturation_fitting_support"]["status"].startswith("NOT_DECIDED")

    # SEAL hashes of artifacts (SEAL self-hash already checked; recompute artifact digests).
    for name, digest in seal["artifacts"].items():
        assert C.sha256_file(CERT / name) == digest, f"SEAL digest mismatch for {name}"
    assert seal["terminal_marker"] == "BORDER_SUPPORT_WP6_SEALED"
    assert seal["headline"] == "OPEN"
    assert seal["gate"] == 5

    # Sparse forced rows: every based row is a genuine degree-1 element of F.
    for row in blocks["forced_blocks"]["based_minus_lines"]["rows"]:
        assert row["forced"] is True
        assert row["degree_in_F"] == 1
        assert row["term_count"] == len(row["terms"])
        assert row["term_count"] > 0
        for term in row["terms"]:
            assert term["component"] in range(7)  # 1 or K_i only at degree 1
            assert term["coeff_mod_67"] % P != 0

    print("BASED_TRANSLATION_OK")
    print("C3_A4_C6_BLOCKS_OK")
    print("RESTRICTED_MODULE_FORMULATION_OK")
    print("SUPPORT_NOT_DECIDED_OK")
    print("BORDER_SUPPORT_WP6_VERIFIED")


if __name__ == "__main__":
    main()
