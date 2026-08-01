#!/usr/bin/env python3
"""Light exact preflight for normalized Stage C on L8."""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
SOURCE = P25 / "syzygy_r256_q0_contracted.npz"
CLOSED_CERT = P25 / "parallel" / "stageb_strata" / "closed_L_degree6_certificate.json"
CLOSED_VERIFY = P25 / "parallel" / "stageb_strata" / "verify_closed_L_degree6_result.json"
OUTPUT = HERE / "closed_L8_stageC_preflight.json"
P = 89
L8 = tuple(range(4, 12))


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


def restriction_indices(
    degree: int, global_index: dict[tuple[int, ...], int]
) -> np.ndarray:
    answer: list[int] = []
    for local in weak_compositions(degree, len(L8)):
        exponent = [0] * 37
        for variable, power in zip(L8, local):
            exponent[variable] = power
        answer.append(global_index[tuple(exponent)])
    return np.asarray(answer, dtype=np.int32)


def rank_mod_89(matrix: np.ndarray) -> int:
    a = np.asarray(matrix, dtype=np.int64).copy() % P
    row = 0
    for column in range(a.shape[1]):
        candidates = np.flatnonzero(a[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        a[[row, pivot]] = a[[pivot, row]]
        a[row] = a[row] * pow(int(a[row, column]), -1, P) % P
        factors = a[:, column].copy()
        factors[row] = 0
        a = (a - factors[:, None] * a[row]) % P
        row += 1
        if row == a.shape[0]:
            break
    return row


def main() -> None:
    for path in (SOURCE, CLOSED_CERT, CLOSED_VERIFY):
        if not path.is_file():
            raise FileNotFoundError(path)
    q3_global = weak_compositions(3, 37)
    q4_global = weak_compositions(4, 37)
    q3_local = weak_compositions(3, 8)
    q4_local = weak_compositions(4, 8)
    indices3 = restriction_indices(3, {m: i for i, m in enumerate(q3_global)})
    indices4 = restriction_indices(4, {m: i for i, m in enumerate(q4_global)})

    with np.load(SOURCE, allow_pickle=False) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        p4 = frozen["p4"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("r256 packet prime mismatch")
    restricted3_all = p3[:, :, indices3]
    restricted4_all = p4[:, indices4]
    nonzero3 = np.flatnonzero(np.any(restricted3_all != 0, axis=(1, 2)))
    nonzero4 = np.flatnonzero(np.any(restricted4_all != 0, axis=1))
    if nonzero3.tolist() != list(range(142, 256)):
        raise AssertionError("closed-L8 P3 row set changed")
    if not np.array_equal(nonzero3, nonzero4):
        raise AssertionError("closed-L8 P3/P4 row sets differ")
    restricted3 = restricted3_all[nonzero3]
    restricted4 = restricted4_all[nonzero3]

    axis_results = []
    for local_variable, global_variable in enumerate(L8):
        exponent3 = [0] * 8
        exponent4 = [0] * 8
        exponent3[local_variable] = 3
        exponent4[local_variable] = 4
        matrix = restricted3[:, :, q3_local.index(tuple(exponent3))]
        scalar = restricted4[:, q4_local.index(tuple(exponent4))]
        rank_p3 = rank_mod_89(matrix)
        rank_augmented = rank_mod_89(np.column_stack([matrix, scalar]))
        if (rank_p3, rank_augmented) != (6, 7):
            raise AssertionError(f"unexpected Stage-C axis ranks at q{global_variable}")
        axis_results.append(
            {
                "q_coordinate": global_variable,
                "p3_rank": rank_p3,
                "augmented_p3_p4_rank": rank_augmented,
                "stageC_solution": False,
            }
        )

    with CLOSED_VERIFY.open() as handle:
        closed = json.load(handle)
    if closed.get("status") != "PASS" or closed.get("certificate_sha256") != sha256(
        CLOSED_CERT
    ):
        raise AssertionError("closed-L8 Stage-B replay is not bound")

    degree3_source = 114 * math.comb(10, 7)
    degree6_p3_target = 6 * math.comb(13, 7)
    degree7_p4_target = math.comb(14, 7)
    degree3_kernel = degree3_source - degree6_p3_target
    degree8_target = math.comb(15, 7)
    payload = {
        "status": "PASS_CLOSED_L8_STAGEC_PREFLIGHT_NONVERDICT",
        "prime": P,
        "source": {
            "path": str(SOURCE.relative_to(P25)),
            "sha256": sha256(SOURCE),
        },
        "closed_stratum": "L8=P<span(q4,...,q11)>",
        "restricted_rows": nonzero3.astype(int).tolist(),
        "restricted_p3_shape": list(restricted3.shape),
        "restricted_p4_shape": list(restricted4.shape),
        "restricted_p3_nnz": int(np.count_nonzero(restricted3)),
        "restricted_p4_nnz": int(np.count_nonzero(restricted4)),
        "axis_incompatibility": axis_results,
        "compatibility_plan": {
            "degree3_multiplier_source": degree3_source,
            "P3_degree6_target": degree6_p3_target,
            "P3_degree3_multiplier_kernel_dimension": degree3_kernel,
            "P4_compatibility_degree7_target": degree7_p4_target,
            "degree8_scalar_target": degree8_target,
            "degree8_source_from_q_times_compatibilities": degree3_kernel * 8,
            "criterion": (
                "If q times the P4 contractions of the complete degree-3 P3-kernel "
                "span S_8, the normalized Stage-C incidence is empty on L8."
            ),
        },
        "closed_stageB_binding": {
            "certificate_sha256": sha256(CLOSED_CERT),
            "independent_replay_sha256": sha256(CLOSED_VERIFY),
            "degree6_rank": 10296,
        },
        "scope": (
            "All eight coordinate axes are excluded exactly. This does not cover "
            "L8; the prepared compatibility-rank computation is still required."
        ),
    }
    if (
        degree3_source,
        degree6_p3_target,
        degree3_kernel,
        degree7_p4_target,
        degree8_target,
    ) != (13680, 10296, 3384, 3432, 6435):
        raise AssertionError("closed-L8 dimension census changed")
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS: closed-L8 Stage-C preflight; all eight axes incompatible")
    print("global closed-L8 Stage C: UNDECIDED")


if __name__ == "__main__":
    main()

