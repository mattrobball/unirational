#!/usr/bin/env python3
"""Independent replay of the decisive Stage-B structural certificates.

This verifier does not import ``analyze_structure.py``.  It independently
checks the forced coordinate component in the old r48 packet and the exact
support/coordinate-rank properties of ``support_cover_r43_stageB.npz``.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
LINEAR = P25 / "linear_syzygies.npz"
LINEAR_R48 = P25 / "linear_syzygies_r48_reconstructed.npz"
CONTRACTED_48 = P25 / "syzygy_r48_q0_contracted.npz"
CONTRACTED_256 = P25 / "syzygy_r256_q0_contracted.npz"
SELECTED = HERE / "support_cover_r43_stageB.npz"
CERTIFICATE = HERE / "structure_certificate.json"
P = 89


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            h.update(chunk)
    return h.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    out: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            out.append((first,) + tail)
    return out


def rank_mod(matrix: np.ndarray) -> int:
    a = np.asarray(matrix, dtype=np.int64).copy() % P
    if a.size == 0:
        return 0
    rows, columns = a.shape
    row = 0
    for column in range(columns):
        candidates = np.flatnonzero(a[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        a[[row, pivot]] = a[[pivot, row]]
        a[row] = (a[row] * pow(int(a[row, column]), -1, P)) % P
        for other in range(row + 1, rows):
            if a[other, column]:
                a[other] = (a[other] - a[other, column] * a[row]) % P
        row += 1
        if row == rows:
            break
    return row


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: i for i, monomial in enumerate(target)}
    answer = np.empty((37, len(source)), dtype=np.int32)
    for variable in range(37):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, source_index] = target_index[tuple(exponent)]
    return answer


def direct_syzygy_check(syzygy: np.ndarray, m2: np.ndarray) -> bool:
    raw = (
        syzygy.T.astype(np.int64) @ m2.reshape(690, -1).astype(np.int64)
    ) % P
    raw = raw.reshape(37, 21, 37)
    for u in range(37):
        if np.any(raw[u, :, u]):
            return False
        for v in range(u + 1, 37):
            if np.any((raw[u, :, v] + raw[v, :, u]) % P):
                return False
    return True


def contract_p3(
    syzygy: np.ndarray, block: np.ndarray, product_map: np.ndarray, target: int
) -> np.ndarray:
    coefficients = (
        syzygy.T.astype(np.int64) @ block.astype(np.int64)
    ) % P
    output = np.zeros(target, dtype=np.int64)
    np.add.at(output, product_map.ravel(), coefficients.ravel())
    return (output % P).astype(np.uint8)


def check_json_self_hash() -> dict:
    body = json.loads(CERTIFICATE.read_text())
    claimed = body.pop("self_sha256")
    canonical = json.dumps(body, indent=2, sort_keys=True) + "\n"
    actual = hashlib.sha256(canonical.encode()).hexdigest()
    if claimed != actual:
        raise AssertionError("structure_certificate.json self hash mismatch")
    return body


def main() -> None:
    certificate = check_json_self_hash()
    if certificate["status"] != "PASS":
        raise AssertionError("unexpected certificate status")

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        assert int(frozen["prime"]) == P
    q1 = weak_compositions(1, 37)
    q2 = weak_compositions(2, 37)
    q3 = weak_compositions(3, 37)
    variable_of = [monomial.index(1) for monomial in q1]
    m2 = np.empty((690, 21, 37), dtype=np.uint8)
    for j in range(21):
        block = seeds[:, int(offsets[7 + j]) : int(offsets[8 + j])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, j, variable] = block[:, monomial_index]

    # Independent systematic-form check.
    flatten = m2.reshape(690, 777)
    column_nnz = np.count_nonzero(flatten, axis=0)
    unit = np.flatnonzero(column_nnz == 1)
    free = np.flatnonzero(column_nnz > 1)
    if len(unit) != 690 or len(free) != 87 or np.any(column_nnz == 0):
        raise AssertionError("M2 systematic column census failed")
    free_pairs = [(int(column // 37), int(column % 37)) for column in free]
    expected_pairs = [
        (b2, q)
        for b2 in range(21)
        for q in range(5 if b2 < 3 else 4)
    ]
    if free_pairs != expected_pairs:
        raise AssertionError("unexpected 87 free tensor coordinates")

    # Independently prove the r48 false coordinate component.  On the
    # projective coordinate space q4,...,q11, all C(q), P3(q), and P4(q)
    # vanish, so neither irrelevant saturation can remove the component.
    with np.load(LINEAR_R48, allow_pickle=False) as frozen:
        syzygies48 = frozen["syzygies"].astype(np.uint8)
    support48 = np.any(syzygies48 != 0, axis=(0, 1))
    missing48 = np.flatnonzero(~support48).astype(int).tolist()
    if missing48 != list(range(4, 12)):
        raise AssertionError(f"r48 missing support changed: {missing48}")
    with np.load(CONTRACTED_48, allow_pickle=False) as frozen:
        p3_48 = frozen["p3"].astype(np.uint8)
        p4_48 = frozen["p4"].astype(np.uint8)
    allowed = set(missing48)
    indices3 = [
        index
        for index, exponent in enumerate(q3)
        if all(not power or variable in allowed for variable, power in enumerate(exponent))
    ]
    q4 = weak_compositions(4, 37)
    indices4 = [
        index
        for index, exponent in enumerate(q4)
        if all(not power or variable in allowed for variable, power in enumerate(exponent))
    ]
    if np.count_nonzero(p3_48[:, :, indices3]):
        raise AssertionError("r48 P3 does not vanish on q4..q11")
    if np.count_nonzero(p4_48[:, indices4]):
        raise AssertionError("r48 P4 does not vanish on q4..q11")

    with np.load(LINEAR, allow_pickle=False) as frozen:
        all_syzygies = frozen["syzygies"].astype(np.uint8)
        basis_columns = frozen["selected_basis_columns"].astype(np.int32)
    with np.load(CONTRACTED_256, allow_pickle=False) as frozen:
        p3_256 = frozen["p3"].astype(np.uint8)
        chosen256 = frozen["chosen_syzygies"].astype(np.int32)
    with np.load(SELECTED, allow_pickle=False) as frozen:
        selected_p3 = frozen["p3"].astype(np.uint8)
        selected_syzygies = frozen["syzygies"].astype(np.uint8)
        selected_rows = frozen["contracted_row_indices"].astype(np.int32)
        selected_saved = frozen["saved_syzygy_indices"].astype(np.int32)
        selected_basis = frozen["selected_basis_columns"].astype(np.int32)
        cover_rows = frozen["coordinate_cover_rows"].astype(np.int32)
        lower_bound = int(frozen["coordinate_cover_lower_bound"])
        if int(frozen["prime"]) != P:
            raise AssertionError("selected packet prime mismatch")
        if str(frozen["relation_matrix_sha256"]) != sha256(RELATION):
            raise AssertionError("selected packet relation hash mismatch")
        if str(frozen["linear_syzygies_sha256"]) != sha256(LINEAR):
            raise AssertionError("selected packet syzygy hash mismatch")
        if str(frozen["source_contracted_sha256"]) != sha256(CONTRACTED_256):
            raise AssertionError("selected packet contraction hash mismatch")
    if not np.array_equal(selected_saved, chosen256[selected_rows]):
        raise AssertionError("selected row/source mapping mismatch")
    if not np.array_equal(selected_syzygies, all_syzygies[selected_saved]):
        raise AssertionError("selected syzygies do not match source")
    if not np.array_equal(selected_p3, p3_256[selected_rows]):
        raise AssertionError("selected P3 does not match source")
    if not np.array_equal(selected_basis, basis_columns[selected_saved]):
        raise AssertionError("selected systematic-basis labels mismatch")

    # Rebuild every selected cubic coefficient and every C(q)M2(q) identity.
    map_2_to_3 = multiplication_map(q2, q3)
    rebuilt = np.empty_like(selected_p3)
    for output_row, syzygy in enumerate(selected_syzygies):
        if not direct_syzygy_check(syzygy, m2):
            raise AssertionError(f"selected syzygy {output_row} failed")
        for j in range(6):
            block = seeds[:, int(offsets[1 + j]) : int(offsets[2 + j])]
            rebuilt[output_row, j] = contract_p3(
                syzygy, block, map_2_to_3, len(q3)
            )
    if not np.array_equal(rebuilt, selected_p3):
        raise AssertionError("independent P3 rebuild failed")

    q3_index = {monomial: i for i, monomial in enumerate(q3)}
    pure = []
    for variable in range(37):
        exponent = [0] * 37
        exponent[variable] = 3
        pure.append(q3_index[tuple(exponent)])
    evaluations = p3_256[:, :, pure]
    row_syzygies = all_syzygies[chosen256]
    row_support = np.any(row_syzygies != 0, axis=1)
    q4_family = np.flatnonzero(row_support[:, 4]).astype(int).tolist()
    q5_family = np.flatnonzero(row_support[:, 5]).astype(int).tolist()
    if len(q4_family) != 16 or len(q5_family) != 14:
        raise AssertionError("rare-coordinate family census changed")
    if set(q4_family) & set(q5_family):
        raise AssertionError("q4/q5 families are not disjoint")
    if rank_mod(evaluations[q4_family, :, 6]) != 0:
        raise AssertionError("q4 family unexpectedly contributes at q6")
    if rank_mod(evaluations[q5_family, :, 6]) != 3:
        raise AssertionError("q5 family q6 rank is not three")
    if lower_bound != 15 or len(cover_rows) != 15:
        raise AssertionError("coordinate-cover cardinality mismatch")
    if [rank_mod(evaluations[cover_rows, :, q]) for q in range(37)] != [6] * 37:
        raise AssertionError("15-row coordinate cover is not full rank")
    if [rank_mod(selected_p3[:, :, pure[q]]) for q in range(37)] != [6] * 37:
        raise AssertionError("selected 43-row packet has a coordinate-point kernel")
    if not np.all(np.any(selected_syzygies != 0, axis=(0, 1))):
        raise AssertionError("selected packet misses a q coefficient direction")

    result = {
        "status": "PASS",
        "m2_unit_columns": 690,
        "m2_free_columns": 87,
        "r48_missing_q_coordinates": missing48,
        "r48_false_coordinate_projective_dimension": 7,
        "selected_rows": 43,
        "coordinate_cover_cardinality": 15,
        "coordinate_cover_lower_bound": lower_bound,
        "selected_coordinate_ranks": [6] * 37,
        "selected_artifact_sha256": sha256(SELECTED),
    }
    (HERE / "verify_structure_result.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print("PASS: independent Stage-B structural replay")
    print("r48 has forced P^7_q x P^5_b1 component")
    print("support-cover r43 has rank 6 at all 37 q-coordinate points")


if __name__ == "__main__":
    main()
