#!/usr/bin/env python3
"""Lightweight exact audit for the complement-strategy inputs over F_89.

This binds the r48/r64 contraction packets and both closed-L8 certificates,
checks the known r48 false component directly, and checks augmented coordinate
axis ranks.  Axis ranks are only a guard/preflight, never a global verdict.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
P = 89
L8 = tuple(range(4, 12))
H8 = tuple(range(4)) + tuple(range(12, 37))

OLD = P25 / "syzygy_r48_q0_contracted.npz"
R64 = P25 / "parallel" / "enlarged_closure" / "support_balanced_r64_stageBC.npz"
R64_REPLAY = P25 / "parallel" / "enlarged_closure" / "verify_augmented_module_jobs_result.json"
B_CERT = P25 / "parallel" / "stageb_strata" / "closed_L_degree6_certificate.json"
B_REPLAY = P25 / "parallel" / "stageb_strata" / "verify_closed_L_degree6_result.json"
C_CERT = P25 / "parallel" / "stageb_stratified_cas" / "closed_L8_stageC_certificate.json"
C_REPLAY = P25 / "parallel" / "stageb_stratified_cas" / "verify_closed_L8_stageC_result.json"
C_ART = P25 / "parallel" / "stageb_stratified_cas" / "closed_L8_stageC_compatibility.npz"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def rank_mod_p(raw: np.ndarray) -> int:
    matrix = np.asarray(raw, dtype=np.int64).copy() % P
    rows, columns = matrix.shape
    rank = 0
    for column in range(columns):
        pivots = np.flatnonzero(matrix[rank:, column])
        if not len(pivots):
            continue
        pivot = rank + int(pivots[0])
        if pivot != rank:
            matrix[[rank, pivot]] = matrix[[pivot, rank]]
        matrix[rank] = matrix[rank] * pow(int(matrix[rank, column]), -1, P) % P
        other = np.flatnonzero(matrix[:, column])
        other = other[other != rank]
        if len(other):
            matrix[other] = (
                matrix[other] - matrix[other, column, None] * matrix[rank]
            ) % P
        rank += 1
        if rank == rows:
            break
    return rank


def json_read(path: Path) -> dict:
    return json.loads(path.read_text())


def axis_ranks(p4: np.ndarray, p3: np.ndarray, q4, q3) -> tuple[list[int], list[int]]:
    index3 = {exponent: i for i, exponent in enumerate(q3)}
    index4 = {exponent: i for i, exponent in enumerate(q4)}
    p3_ranks = []
    augmented_ranks = []
    for axis in range(37):
        pure3 = tuple(3 if i == axis else 0 for i in range(37))
        pure4 = tuple(4 if i == axis else 0 for i in range(37))
        stage_b = p3[:, :, index3[pure3]]
        augmented = np.column_stack([p4[:, index4[pure4]], stage_b])
        p3_ranks.append(rank_mod_p(stage_b))
        augmented_ranks.append(rank_mod_p(augmented))
    return p3_ranks, augmented_ranks


def main() -> None:
    q3 = weak_compositions(3, 37)
    q4 = weak_compositions(4, 37)
    outside = set(H8)
    l3 = np.array(
        [all(exponent[i] == 0 for i in outside) for exponent in q3], dtype=bool
    )
    l4 = np.array(
        [all(exponent[i] == 0 for i in outside) for exponent in q4], dtype=bool
    )
    assert int(l3.sum()) == 120 and int(l4.sum()) == 330

    old = np.load(OLD, allow_pickle=False)
    old_p3, old_p4 = old["p3"], old["p4"]
    assert old_p3.shape == (48, 6, 9139)
    assert old_p4.shape == (48, 91390)
    old_vanishes = bool(
        np.count_nonzero(old_p3[:, :, l3]) == 0
        and np.count_nonzero(old_p4[:, l4]) == 0
    )
    assert old_vanishes
    old_p3_ranks, old_ranks = axis_ranks(old_p4, old_p3, q4, q3)
    assert old_p3_ranks[12] == 4 and old_ranks[12] == 4
    index3 = {exponent: i for i, exponent in enumerate(q3)}
    index4 = {exponent: i for i, exponent in enumerate(q4)}
    e12_3 = tuple(3 if i == 12 else 0 for i in range(37))
    e12_4 = tuple(4 if i == 12 else 0 for i in range(37))
    old_e12_p3 = old_p3[:, :, index3[e12_3]].astype(np.int64)
    old_e12_p4 = old_p4[:, index4[e12_4]].astype(np.int64)
    old_stageb_witness = np.array([54, 14, 19, 35, 1, 0], dtype=np.int64)
    old_stagec_witness = np.array([74, 51, 64, 74, 0, 0], dtype=np.int64)
    assert np.count_nonzero(old_e12_p3 @ old_stageb_witness % P) == 0
    assert (
        np.count_nonzero((old_e12_p4 + old_e12_p3 @ old_stagec_witness) % P)
        == 0
    )

    r64 = np.load(R64, allow_pickle=False)
    p3, p4 = r64["p3"], r64["p4"]
    assert p3.shape == (64, 6, 9139)
    assert p4.shape == (64, 91390)
    r64_p3_ranks, r64_ranks = axis_ranks(p4, p3, q4, q3)
    assert all(r64_p3_ranks[i] == 6 for i in H8)
    assert all(r64_ranks[i] == 7 for i in H8)

    r64_replay = json_read(R64_REPLAY)
    assert r64_replay["status"] == "PASS_AUGMENTED_MODULE_JOBS_REPLAY"
    assert r64_replay["r64_p3_total_rank"] == 64
    assert r64_replay["r64_p3_component_ranks"] == [64] * 6
    assert r64_replay["r64_p4_recomputed_byte_equal"] is True

    b_cert = json_read(B_CERT)
    b_replay = json_read(B_REPLAY)
    assert b_cert["degree_six_map"]["rank_over_F89"] == 10296
    assert b_cert["degree_six_map"]["full_target_rank"] is True
    assert b_replay["status"] == "PASS"
    assert b_replay["determinant_mod_89"] == 28
    assert b_replay["determinant_nonzero"] is True

    c_cert = json_read(C_CERT)
    c_replay = json_read(C_REPLAY)
    assert c_cert["status"] == "PASS_CLOSED_L8_STAGEC_EMPTY"
    assert c_cert["degree6_P3_map"]["kernel_dimension"] == 3384
    assert c_cert["degree8_map"]["rank"] == 6435
    assert c_cert["degree8_map"]["full_target_rank"] is True
    assert c_replay["status"] == "PASS_INDEPENDENT_CLOSED_L8_STAGEC_EMPTY"
    assert c_replay["closed_L8_stageC_empty"] is True
    assert c_replay["selected_minor_rank"] == 6435
    assert c_replay["artifact_sha256"] == sha256(C_ART)

    payload = {
        "prime": P,
        "H8_coordinates": list(H8),
        "L8_coordinates": list(L8),
        "inputs": {
            "old_r48": {"sha256": sha256(OLD), "shape_p3": list(old_p3.shape)},
            "r64": {"sha256": sha256(R64), "shape_p3": list(p3.shape)},
            "r64_replay": {"sha256": sha256(R64_REPLAY)},
            "closed_stageB_certificate": {"sha256": sha256(B_CERT)},
            "closed_stageB_replay": {"sha256": sha256(B_REPLAY)},
            "closed_stageC_certificate": {"sha256": sha256(C_CERT)},
            "closed_stageC_replay": {"sha256": sha256(C_REPLAY)},
            "closed_stageC_artifact": {"sha256": sha256(C_ART)},
        },
        "exact_checks": {
            "old_r48_P3_and_P4_vanish_identically_on_L8": old_vanishes,
            "old_r48_P3_axis_ranks": old_p3_ranks,
            "old_r48_augmented_axis_ranks": old_ranks,
            "old_r48_has_forced_H8_complement_defect_at_e12": (
                old_p3_ranks[12] == 4 and old_ranks[12] == 4
            ),
            "old_r48_e12_stageB_kernel_witness_b1": old_stageb_witness.tolist(),
            "old_r48_e12_normalized_stageC_witness_b1": (
                old_stagec_witness.tolist()
            ),
            "old_r48_H8_jobs_forced_nonunit": ["StageB", "StageC", "combined"],
            "r64_P3_axis_ranks": r64_p3_ranks,
            "r64_augmented_axis_ranks": r64_ranks,
            "r64_all_H8_coordinate_axes_have_rank_7": all(
                r64_ranks[i] == 7 for i in H8
            ),
            "r64_L8_axis_ranks": [r64_ranks[i] for i in L8],
            "closed_L8_stageB_exact_empty": True,
            "closed_L8_stageC_exact_empty": True,
        },
        "scope_guard": (
            "The axis ranks and old-r48 support check are exact but do not cover "
            "D(H8).  Only 29 unit-module chart certificates (or equivalent "
            "H8-power identities) would close the complement."
        ),
        "status": "PASS_EXACT_INPUT_AUDIT_NONVERDICT",
    }
    output = HERE / "audit_result.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS_EXACT_INPUT_AUDIT_NONVERDICT")


if __name__ == "__main__":
    main()
