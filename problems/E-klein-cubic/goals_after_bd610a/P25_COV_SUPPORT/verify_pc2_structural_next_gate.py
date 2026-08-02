#!/usr/bin/env python3
"""Replay the scoped PC.2 structural next-gate audit without Singular."""

from __future__ import annotations

import ctypes
import hashlib
import json
from itertools import combinations
from math import comb
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROJECT = HERE.parent
HISTORICAL = PROJECT.parent / "goals_2026-08-01" / "P25_LANDING_SUPPORT" / "parallel"
GLOBAL = HISTORICAL / "stageb_global_basis"
ENLARGED = HISTORICAL / "enlarged_closure"
LEDGER = HERE / "PC2_STRUCTURAL_NEXT_GATE.json"
FULL_P3 = GLOBAL / "full_p3_contractions.npy"
P = 89
NQ = 37
NULLITY = 10767
NQ3 = 9139


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def rank_fflas(matrix: np.ndarray) -> int:
    """Exact modular rank; entries and modulus are safely below 2^53."""
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.Rank_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rows, columns = dense.shape
    return int(function(float(P), rows, columns, dense, columns, False))


def target_dimension(degree: int) -> int:
    return comb(degree + 36, 36) + 6 * comb(degree + 35, 36)


def source_dimension(rows: int, degree: int) -> int:
    return rows * comb(degree + 32, 36)


def first_possible_degree(rows: int) -> int:
    degree = 4
    while source_dimension(rows, degree) < target_dimension(degree):
        degree += 1
    return degree


def main() -> None:
    ledger = json.loads(LEDGER.read_text())
    assert ledger["status"] == "PC2-STRUCTURAL-NEXT-GATE-SCOPED"
    assert ledger["global_status"] == "PC-UNDECIDED"

    paths = {
        "../goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/lt_cover_analysis.json": GLOBAL
        / "lt_cover_analysis.json",
        "../goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/lt_cover_nonpure_minor.npz": GLOBAL
        / "lt_cover_nonpure_minor.npz",
        "../goals_2026-08-01/P25_LANDING_SUPPORT/parallel/stageb_global_basis/support_balanced_r43_stageBC.npz": GLOBAL
        / "support_balanced_r43_stageBC.npz",
        "../goals_2026-08-01/P25_LANDING_SUPPORT/parallel/enlarged_closure/support_balanced_r64_stageBC.npz": ENLARGED
        / "support_balanced_r64_stageBC.npz",
        "../goals_2026-08-01/P25_LANDING_SUPPORT/parallel/enlarged_closure/augmented_module_jobs.json": ENLARGED
        / "augmented_module_jobs.json",
        "pc2_coordinate_plane_summary.json": HERE / "pc2_coordinate_plane_summary.json",
        "pc2_coordinate_plane_certificate.npz": HERE
        / "pc2_coordinate_plane_certificate.npz",
    }
    assert set(paths) == set(ledger["inputs"])
    for label, path in paths.items():
        assert path.is_file(), path
        assert sha256_file(path) == ledger["inputs"][label], path

    thresholds = ledger["raw_macaulay_dimension_obstruction"]["thresholds"]
    for label, record in thresholds.items():
        rows = int(record["rows"])
        first = first_possible_degree(rows)
        assert first == int(record["first_dimensionally_possible_degree"]), label
        assert first - 1 == int(record["last_impossible_degree"]), label
        assert source_dimension(rows, first - 1) == int(
            record["source_at_last_impossible"]
        )
        assert target_dimension(first - 1) == int(
            record["target_at_last_impossible"]
        )
        assert source_dimension(rows, first) == int(record["source_at_first_possible"])
        assert target_dimension(first) == int(record["target_at_first_possible"])
        assert source_dimension(rows, first - 1) < target_dimension(first - 1)
        assert source_dimension(rows, first) >= target_dimension(first)
    assert ledger["ambient"]["maximal_minor_degree"] == 4 + 6 * 3 == 22

    lt_analysis = json.loads((GLOBAL / "lt_cover_analysis.json").read_text())
    assert lt_analysis["prime"] == P
    assert lt_analysis["nonpure_projection_injective"] is True
    assert lt_analysis["tested_minor"]["rank"] == NULLITY
    assert lt_analysis["pure_cube_module_columns"] == 6 * NQ == 222

    with np.load(GLOBAL / "lt_cover_nonpure_minor.npz", allow_pickle=False) as frozen:
        minor_columns = frozen["minor_columns"].astype(np.int32)
        pure_columns = frozen["pure_columns"].astype(np.int32)
        assert int(frozen["prime"]) == P
        assert int(frozen["minor_rank"]) == NULLITY
        assert str(frozen["full_p3_sha256"]) == lt_analysis["full_p3"]["sha256"]
    assert minor_columns.shape == (NULLITY,)
    assert pure_columns.shape == (6 * NQ,)
    assert np.intersect1d(minor_columns, pure_columns).size == 0
    assert len(np.unique(minor_columns)) == NULLITY

    with np.load(HERE / "pc2_coordinate_plane_certificate.npz", allow_pickle=False) as frozen:
        selected412 = frozen["selected_full_basis_rows"].astype(np.int32)
        selected412_p3_sha = str(frozen["selected_p3_sha256"])
        triples = frozen["coordinate_triples"].astype(np.uint8)
        profiles = frozen["row_rank_profiles"].astype(np.int32)
        ranks = frozen["ranks"].astype(np.int32)
        determinants = frozen["determinants_mod89"].astype(np.int32)
        assert int(frozen["prime"]) == P
    expected_triples = np.asarray(list(combinations(range(NQ), 3)), dtype=np.uint8)
    assert np.array_equal(triples, expected_triples)
    assert profiles.shape == (7770, 75)
    assert np.all(ranks == 75)
    assert np.all(determinants != 0)
    assert all(len(np.unique(profile)) == 75 for profile in profiles)

    with np.load(GLOBAL / "support_balanced_r43_stageBC.npz", allow_pickle=False) as frozen:
        selected43 = frozen["full_basis_columns"].astype(np.int32)
        packet43_p3 = frozen["p3"].copy()
        assert int(frozen["prime"]) == P
    with np.load(ENLARGED / "support_balanced_r64_stageBC.npz", allow_pickle=False) as frozen:
        selected64 = frozen["full_basis_columns"].astype(np.int32)
        packet64_p3 = frozen["p3"].copy()
        assert int(frozen["prime"]) == P
    assert len(np.unique(selected43)) == 43
    assert len(np.unique(selected64)) == 64
    assert set(map(int, selected43)) <= set(map(int, selected64))
    assert len(np.unique(selected412)) == 412
    assert set(map(int, selected412)).isdisjoint(set(map(int, selected64)))

    full_p3 = np.load(FULL_P3, mmap_mode="r")
    assert full_p3.shape == (NULLITY, 6, NQ3)
    assert full_p3.dtype == np.uint8
    assert sha256_array(np.asarray(full_p3[selected412])) == selected412_p3_sha
    assert np.array_equal(packet43_p3, np.asarray(full_p3[selected43]))
    assert np.array_equal(packet64_p3, np.asarray(full_p3[selected64]))

    union = np.asarray(
        sorted(set(map(int, selected412)) | set(map(int, selected64))), dtype=np.int32
    )
    assert union.shape == (476,)
    projection = np.ascontiguousarray(
        full_p3.reshape(NULLITY, 6 * NQ3)[union][:, minor_columns], dtype=np.uint8
    )
    projection_rank = rank_fflas(projection)
    assert projection_rank == len(union) == 476
    selected_record = ledger["degree4_pure_term_obstruction"][
        "selected_families_checked"
    ]
    assert selected_record["union_rows"] == len(union)
    assert selected_record["union_nonpure_projection_rank"] == projection_rank

    jobs = json.loads((ENLARGED / "augmented_module_jobs.json").read_text())
    assert jobs["not_run"] is True
    assert jobs["no_singular_launched"] is True
    assert jobs["jobs"]["r43"]["rows"] == 43
    assert jobs["jobs"]["r64"]["rows"] == 64

    assert ledger["safe_schur_complement"]["numerator_degree"] == 22
    compression = ledger["constant_row_compression"]
    assert compression["stageB_P3_r_by_6_minimum_rows_for_projective_emptiness"] == 37 + 6 - 1 == 42
    assert compression["augmented_M_r_by_7_minimum_rows_for_projective_emptiness"] == 37 + 7 - 1 == 43
    assert compression["augmented_r42_height_upper_bound"] == 42 - 7 + 1 == 36
    assert compression["augmented_r43_height_upper_bound"] == 43 - 7 + 1 == 37
    assert compression["augmented_r64_height_upper_bound"] == 64 - 7 + 1 == 58

    print("PASS_PC2_STRUCTURAL_DIMENSION_OBSTRUCTION")
    print("PASS_PC2_SELECTED_NONPURE_PROJECTION_RANK_476")
    print("PASS_PC2_SCHUR_GATE_SCOPED")


if __name__ == "__main__":
    main()
