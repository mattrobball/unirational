#!/opt/homebrew/bin/python3
"""Replay the all-degree projective reduction for Pfaffian/Fano covariants.

This does not scan another homogeneous degree.  It verifies, at the sealed
good prime, the finite moving-frame model underlying *every* rational
projective covariant.  The mathematical proof that a projective map has a
primitive homogeneous representative is recorded in the companion note.
"""

from __future__ import annotations

import importlib.util
import itertools
import json
import random
import runpy
import sys
from pathlib import Path

import numpy as np


P = 23
ZETA = 2
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
FANO_PATH = ROOT / "tmp/fano14_twist/fano_covariant_scan.py"
PHI_PATH = ROOT / "tmp/generic_twist/phi_coefficients.py"
ALIGN_CERT = ROOT / "tmp/pfaffian_representation_alignment/certificate.json"
QUAD_CERT = ROOT / "tmp/quadratic_grassmannian_covariant/certificate.json"
PAIR15 = tuple(itertools.combinations(range(6), 2))
PAIR5 = tuple(itertools.combinations_with_replacement(range(5), 2))
DEGREES = (1, 4, 5, 6, 7)


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def rank(matrix: np.ndarray) -> int:
    value = np.array(matrix, dtype=np.int64, copy=True) % P
    row = 0
    for column in range(value.shape[1]):
        pivot = next((r for r in range(row, value.shape[0]) if value[r, column]), None)
        if pivot is None:
            continue
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, P) % P
        for other in range(value.shape[0]):
            if other != row and value[other, column]:
                value[other] = (value[other] - value[other, column] * value[row]) % P
        row += 1
        if row == value.shape[0]:
            break
    return row


def inv(matrix: np.ndarray) -> np.ndarray:
    n = matrix.shape[0]
    value = np.concatenate(
        [np.array(matrix, dtype=np.int64) % P, np.eye(n, dtype=np.int64)], axis=1
    )
    for column in range(n):
        pivot = next(r for r in range(column, n) if value[r, column])
        value[[column, pivot]] = value[[pivot, column]]
        value[column] = value[column] * pow(int(value[column, column]), -1, P) % P
        for other in range(n):
            if other != column and value[other, column]:
                value[other] = (
                    value[other] - value[other, column] * value[column]
                ) % P
    return value[:, n:] % P


def determinant(matrix: np.ndarray) -> int:
    value = np.array(matrix, dtype=np.int64, copy=True) % P
    answer = 1
    for column in range(value.shape[0]):
        pivot = next((r for r in range(column, value.shape[0]) if value[r, column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            value[[column, pivot]] = value[[pivot, column]]
            answer = -answer
        entry = int(value[column, column])
        answer = answer * entry % P
        value[column] = value[column] * pow(entry, -1, P) % P
        for other in range(column + 1, value.shape[0]):
            if value[other, column]:
                value[other] = (
                    value[other] - value[other, column] * value[column]
                ) % P
    return answer % P


def matrix_key(matrix: np.ndarray) -> bytes:
    return bytes((matrix % P).astype(np.uint8).flat)


def generated_group(generators: tuple[np.ndarray, ...]) -> dict[bytes, np.ndarray]:
    identity = np.eye(generators[0].shape[0], dtype=np.int64)
    seen = {matrix_key(identity): identity}
    queue = [identity]
    while queue:
        current = queue.pop()
        for generator in generators:
            candidate = current @ generator % P
            key = matrix_key(candidate)
            if key not in seen:
                seen[key] = candidate
                queue.append(candidate)
    return seen


def left_coordinates(basis: np.ndarray, vectors: np.ndarray) -> np.ndarray:
    rows = next(
        rows
        for rows in itertools.combinations(range(basis.shape[0]), basis.shape[1])
        if determinant(basis[np.array(rows), :])
    )
    answer = inv(basis[np.array(rows), :]) @ vectors[np.array(rows), :] % P
    assert np.array_equal(basis @ answer % P, vectors % P)
    return answer


def frame_values(phi, frame, point) -> np.ndarray:
    # Columns are x,C,D,E,K.
    return np.array(
        [
            [phi["evaluate"](component, point) % P for component in vector]
            for vector in frame
        ],
        dtype=np.int64,
    ).T % P


def sym2_values(vector: np.ndarray) -> np.ndarray:
    return np.array(
        [vector[i] * vector[j] % P for i, j in PAIR5], dtype=np.int64
    )


def polar_quadratic(evaluate, left: np.ndarray, right: np.ndarray) -> np.ndarray:
    if np.array_equal(left, right):
        return evaluate(left)
    return (
        evaluate((left + right) % P) - evaluate(left) - evaluate(right)
    ) * pow(2, -1, P) % P


def independent_columns(matrix: np.ndarray, wanted: int) -> tuple[int, ...]:
    chosen: list[int] = []
    old = 0
    for column in range(matrix.shape[1]):
        candidate = chosen + [column]
        new = rank(matrix[:, candidate])
        if new > old:
            chosen.append(column)
            old = new
        if old == wanted:
            break
    assert old == wanted
    return tuple(chosen)


def permutation_sign(sequence: tuple[int, ...]) -> int:
    inversions = sum(
        sequence[i] > sequence[j]
        for i in range(len(sequence))
        for j in range(i + 1, len(sequence))
    )
    return -1 if inversions % 2 else 1


def pluecker_pairing(p: np.ndarray, z: np.ndarray) -> int:
    """Coefficient of (p wedge p) wedge z in e0 wedge ... wedge e5."""
    lookup = {pair: index for index, pair in enumerate(PAIR15)}
    answer = 0
    for four in itertools.combinations(range(6), 4):
        i, j, k, ell = four
        q = (
            p[lookup[(i, j)]] * p[lookup[(k, ell)]]
            - p[lookup[(i, k)]] * p[lookup[(j, ell)]]
            + p[lookup[(i, ell)]] * p[lookup[(j, k)]]
        ) % P
        complement = tuple(index for index in range(6) if index not in four)
        answer += permutation_sign(four + complement) * q * z[lookup[complement]]
    return answer % P


def tensor_at(
    point: tuple[int, ...],
    phi,
    frame,
    change: np.ndarray,
    target_basis: np.ndarray,
    fano_scanner,
    degree2_seed,
    full_quadratic: np.ndarray,
    selected: tuple[int, ...],
    f3,
    f5,
):
    raw_frame = frame_values(phi, frame, point)
    domain_frame = change @ raw_frame % P
    assert determinant(domain_frame)
    f3_value = phi["evaluate"](f3, point) % P
    f5_value = phi["evaluate"](f5, point) % P
    assert f3_value and f5_value
    tau = f3_value * f3_value * pow(f5_value, -1, P) % P

    def u_quadratic(vector):
        return fano_scanner.evaluate_seed(degree2_seed, vector) % P

    def full_evaluate(vector):
        return full_quadratic @ sym2_values(vector) % P

    u_all = np.stack(
        [
            polar_quadratic(
                u_quadratic, domain_frame[:, left], domain_frame[:, right]
            )
            for left, right in PAIR5
        ],
        axis=1,
    ) % P
    z_all = np.stack(
        [
            polar_quadratic(
                full_evaluate, domain_frame[:, left], domain_frame[:, right]
            )
            for left, right in PAIR5
        ],
        axis=1,
    ) % P
    assert rank(u_all) == 10 and determinant(z_all)

    u_degrees = [DEGREES[left] + DEGREES[right] for left, right in PAIR5]
    u = u_all[:, selected]
    selected_degrees = [u_degrees[index] for index in selected]
    u_normalized = np.stack(
        [u[:, column] * pow(tau, -degree, P) % P for column, degree in enumerate(selected_degrees)],
        axis=1,
    )
    z_normalized = np.stack(
        [z_all[:, column] * pow(tau, -degree, P) % P for column, degree in enumerate(u_degrees)],
        axis=1,
    )
    assert determinant(u_normalized) and determinant(z_normalized)
    ambient_u = target_basis @ u_normalized % P

    tensor = np.zeros((15, 55), dtype=np.int64)
    quadratic_pairs = tuple(itertools.combinations_with_replacement(range(10), 2))
    for relation, z in enumerate(z_normalized.T):
        diagonal = [pluecker_pairing(ambient_u[:, i], z) for i in range(10)]
        for column, (left, right) in enumerate(quadratic_pairs):
            if left == right:
                tensor[relation, column] = diagonal[left]
            else:
                tensor[relation, column] = (
                    pluecker_pairing(
                        (ambient_u[:, left] + ambient_u[:, right]) % P, z
                    )
                    - diagonal[left]
                    - diagonal[right]
                ) % P
    return {
        "raw_frame": raw_frame,
        "domain_frame": domain_frame,
        "tau": tau,
        "u_all": u_all,
        "z_all": z_all,
        "u_normalized": u_normalized,
        "z_normalized": z_normalized,
        "tensor": tensor,
        "selected_degrees": selected_degrees,
    }


def main() -> None:
    fano = load_module("c5_mixed_fano", FANO_PATH)
    phi = runpy.run_path(str(PHI_PATH))
    scanner = fano.Scanner()
    target_basis = scanner.target_basis % P
    domain_basis = scanner.domain_basis % P

    alignment = json.loads(ALIGN_CERT.read_text())["exact_intertwiner"]
    exact_embedding_mod = np.array(alignment["good_reduction"]["matrix"], dtype=np.int64) % P
    change = left_coordinates(domain_basis, exact_embedding_mod)
    assert determinant(change)

    # PSL_2(F_11) has no character twist: independently recover perfectness
    # from the sealed two-generator modular realization.  In a two-generator
    # group, the normal closure of [s,t] is the derived subgroup.
    six_first, six_second = fano.six_dimensional_generators()
    dual_generators = tuple(inv(generator).T % P for generator in (six_first, six_second))
    dual_exterior = tuple(fano.exterior_square(generator) for generator in dual_generators)
    domain_generators = tuple(
        fano.restrict(generator, domain_basis) for generator in dual_exterior
    )
    assert len(generated_group(domain_generators)) == 660
    first, second = domain_generators
    commutator = inv(first) @ inv(second) @ first @ second % P
    conjugates = tuple(
        inv(group) @ commutator @ group % P for group in scanner.domain_group
    )
    derived = generated_group(conjugates)
    assert len(derived) == 660

    names, frame, coefficients = phi["all_coefficients"]()
    assert tuple(names) == ("x", "C", "D", "E", "K")
    f3 = coefficients[(0, 0, 0)]
    f5 = phi["load_source"]().H

    degree2 = scanner.covariant_basis(2)
    assert len(degree2) == 1
    degree2_seed = degree2[0]

    quad = json.loads(QUAD_CERT.read_text())["modular_covariant_data"]["2"]
    full_quadratic = np.array(quad["basis_matrices_mod_23"][0], dtype=np.int64) % P
    assert determinant(full_quadratic)

    rng = random.Random(20260801)
    point = None
    initial = None
    selected = None
    for _ in range(1000):
        candidate = tuple(rng.randrange(P) for _ in range(5))
        try:
            raw_frame = frame_values(phi, frame, candidate)
            if not determinant(raw_frame):
                continue
            f3_value = phi["evaluate"](f3, candidate) % P
            f5_value = phi["evaluate"](f5, candidate) % P
            if not (f3_value and f5_value):
                continue
            domain_frame = change @ raw_frame % P

            def u_eval(vector):
                return scanner.evaluate_seed(degree2_seed, vector) % P

            u_all = np.stack(
                [
                    polar_quadratic(
                        u_eval, domain_frame[:, left], domain_frame[:, right]
                    )
                    for left, right in PAIR5
                ],
                axis=1,
            ) % P
            if rank(u_all) != 10:
                continue
            selected = independent_columns(u_all, 10)
            point = candidate
            break
        except (AssertionError, ValueError, StopIteration):
            continue
    assert point is not None and selected is not None

    initial = tensor_at(
        point,
        phi,
        frame,
        change,
        target_basis,
        scanner,
        degree2_seed,
        full_quadratic,
        selected,
        f3,
        f5,
    )
    assert rank(initial["tensor"]) == 15

    # Scalar invariance is the role of tau normalization.
    scale = 7
    scaled_point = tuple(scale * value % P for value in point)
    scaled = tensor_at(
        scaled_point,
        phi,
        frame,
        change,
        target_basis,
        scanner,
        degree2_seed,
        full_quadratic,
        selected,
        f3,
        f5,
    )
    assert np.array_equal(initial["tensor"], scaled["tensor"])
    assert np.array_equal(initial["u_normalized"], scaled["u_normalized"])
    assert np.array_equal(initial["z_normalized"], scaled["z_normalized"])

    # Directly re-evaluate at two nontrivial group translates.  Equality of
    # the invariant tensor is stronger than checking only frame ranks.
    checked = 0
    for group_index in range(1, len(scanner.domain_group)):
        domain_action = scanner.domain_group[group_index]
        repo_action = inv(change) @ domain_action @ change % P
        moved_point = tuple(int(value) for value in repo_action @ np.array(point) % P)
        try:
            moved = tensor_at(
                moved_point,
                phi,
                frame,
                change,
                target_basis,
                scanner,
                degree2_seed,
                full_quadratic,
                selected,
                f3,
                f5,
            )
        except AssertionError:
            continue
        assert np.array_equal(initial["tensor"], moved["tensor"])
        checked += 1
        if checked == 2:
            break
    assert checked == 2

    payload = {
        "format": "c5-projective-mixed-reduction-p23-v1",
        "prime": P,
        "zeta": ZETA,
        "point": list(point),
        "tau": int(initial["tau"]),
        "hilbert90_degrees": list(DEGREES),
        "selected_pair_indices": list(selected),
        "selected_pairs": [list(PAIR5[index]) for index in selected],
        "selected_degrees": initial["selected_degrees"],
        "target_frame_determinant": determinant(initial["u_normalized"]),
        "relation_test_frame_determinant": determinant(initial["z_normalized"]),
        "pluecker_tensor_shape": list(initial["tensor"].shape),
        "pluecker_tensor_rank_at_point": rank(initial["tensor"]),
        "scalar_translate_checked": scale,
        "group_translates_checked": checked,
        "commutator_normal_closure_order": len(derived),
        "exact_scope": (
            "the nonzero good-fibre minors prove that the polarized degree-two "
            "covariant applied to the exact x,C,D,E,K frame gives a 10-vector "
            "K_proj basis after tau-normalization; the 15-pair full quadratic "
            "frame gives invariant scalar Pluecker equations"
        ),
        "not_proved": "a K_proj solution of the resulting 15 quadrics",
    }
    output = Path(__file__).with_name("projective_mixed_reduction.json")
    output.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"POINT={point} TAU={initial['tau']}")
    print(f"TARGET_BASIS_PAIRS={[PAIR5[index] for index in selected]}")
    print(f"TARGET_BASIS_DEGREES={initial['selected_degrees']}")
    print(f"TARGET_FRAME_DET={payload['target_frame_determinant']}")
    print(f"RELATION_FRAME_DET={payload['relation_test_frame_determinant']}")
    print(f"COMMUTATOR_NORMAL_CLOSURE_ORDER={len(derived)}")
    print("PLUECKER_SYSTEM=15 invariant quadrics in 10 K_proj coordinates")
    print("PASS tau normalization is scalar-invariant")
    print("PASS direct group-translate tensor invariance")
    print("C5_PROJECTIVE_MIXED_REDUCTION_OK")


if __name__ == "__main__":
    main()
