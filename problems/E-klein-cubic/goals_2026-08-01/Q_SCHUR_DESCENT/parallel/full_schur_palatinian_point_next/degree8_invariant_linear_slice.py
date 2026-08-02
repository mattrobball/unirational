#!/usr/bin/env python3
"""Complete degree-eight invariant-linear test on the canonical C_015 slice.

Let J_0,...,J_3 be a complete degree-eight invariant basis and let

    D = sum d_j J_j,  A = sum a_j J_j,  B = sum b_j J_j.

This script proves, first over the good fibre and then by good reduction,
that I4(D r_0 + A r_1 + B r_5) cannot vanish identically unless all twelve
constant coefficients vanish.
"""
from __future__ import annotations

from collections import Counter
import hashlib
import importlib.util
import json
from math import comb, factorial
from pathlib import Path
import sys

import numpy as np

import degree9_binary_factor_sat as binary
import degree9_binary_factor_sat_exhaustive as exhaustive
import degree9_fast_linear_sat as fast
import degree9_full_landing as landing
import eigenline_rank_one_probe as field


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
OUTPUT = HERE / "degree8_invariant_linear_slice_certificate.json"
EIGENLINES = HERE / "degree9_rank_one_eigenlines_f529.json"
CHARACTER_SOURCE = ROOT / "tmp/projective_source/character_scan.py"
UPSTREAM = (
    ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian"
)
P = 23
AMBIENT = 12
RESIDUAL = 4
SELECTED = (0, 1, 5)
INVARIANT_DEGREE = 8
INVARIANT_DIMENSION = 4
TRAINING_SEED = 2026080161
RESIDUAL_SEED = 2026080171
RESIDUAL_SAMPLE_COUNT = 40


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(name: str, path: Path):
    specification = importlib.util.spec_from_file_location(name, path)
    assert specification and specification.loader
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


def invariant_dimension_certificate():
    characters = load("degree8_linear_invariant_characters", CHARACTER_SOURCE)
    primes = [23, 67, 89]
    residues = []
    roots = []
    for prime in primes:
        roots.append(characters.configure_prime(prime))
        group = characters.paired_schur_group()
        total = 0
        for matrix, _ in group:
            total = (
                total
                + characters.complete_symmetric_traces(
                    characters.FANO.inv(matrix), INVARIANT_DEGREE
                )[INVARIANT_DEGREE]
            ) % prime
        residues.append(total * pow(len(group), -1, prime) % prime)
    dimension, modulus = characters.crt(residues, primes)
    upper_bound = comb(INVARIANT_DEGREE + 5, 5)
    assert modulus > upper_bound and dimension == INVARIANT_DIMENSION
    return {
        "split_primes": primes,
        "zeta11_roots": roots,
        "residues": residues,
        "crt_dimension": int(dimension),
        "crt_modulus": int(modulus),
        "elementary_upper_bound": upper_bound,
    }


def transformed_points(probe, points):
    return [
        np.einsum("gij,j->gi", probe.group, point, optimize=True) % P
        for point in points
    ]


def invariant_values(exponents, transformed):
    answer = []
    for orbit in transformed:
        values = np.ones(len(orbit), dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values = values * np.power(orbit[:, coordinate], exponent) % P
        answer.append(int(np.sum(values, dtype=np.int64) % P))
    return np.asarray(answer, dtype=np.int64)


def add_echelon(echelon, row):
    row = np.asarray(row, dtype=np.int64) % P
    for pivot, old in echelon:
        if row[pivot]:
            row = (row - row[pivot] * old) % P
    nonzero = np.flatnonzero(row)
    if not len(nonzero):
        return False
    pivot = int(nonzero[0])
    row = row * pow(int(row[pivot]), -1, P) % P
    echelon.append((pivot, row))
    return True


def invariant_basis(probe):
    rng = np.random.default_rng(TRAINING_SEED)
    points = [rng.integers(0, P, 6, dtype=np.int64) for _ in range(20)]
    transformed = transformed_points(probe, points)
    echelon = []
    basis = []
    for exponents in landing.probe_core.monomials(INVARIANT_DEGREE, 6):
        if add_echelon(echelon, invariant_values(exponents, transformed)):
            basis.append(exponents)
            if len(basis) == INVARIANT_DIMENSION:
                break
    assert len(basis) == INVARIANT_DIMENSION
    return points, basis


def extension_invariant_values(probe, basis, point):
    transformed = np.stack(
        [
            np.einsum(
                "gij,j->gi", probe.group, point[:, component], optimize=True
            ) % P
            for component in range(2)
        ],
        axis=-1,
    )
    answer = []
    for exponents in basis:
        values = np.zeros((len(transformed), 2), dtype=np.int64)
        values[:, 0] = 1
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values = landing.gf529_multiply(
                    values,
                    landing.gf529_power(transformed[:, coordinate], exponent),
                )
        answer.append(np.sum(values, axis=0) % P)
    return answer


def extension_outputs(probe, frame_basis, invariant_basis_data, point):
    frame = landing.extension_seed_values(probe, frame_basis, point)
    invariants = extension_invariant_values(probe, invariant_basis_data, point)
    return np.stack(
        [
            landing.gf529_multiply(invariants[index], frame[column])
            for column in SELECTED
            for index in range(INVARIANT_DIMENSION)
        ]
    )


def rank_one_constraint(outputs, quartic):
    nonzero = np.argwhere(np.any(outputs != 0, axis=2))
    assert len(nonzero)
    coordinate = int(nonzero[0, 1])
    raw = [tuple(int(value) for value in entry) for entry in outputs[:, coordinate]]
    pivot = next(index for index, entry in enumerate(raw) if not field.is_zero(entry))
    scale = field.inverse(raw[pivot])
    form = tuple(field.mul(scale, entry) for entry in raw)
    direction = np.asarray(
        [
            field.mul(scale, tuple(int(value) for value in entry))
            for entry in outputs[pivot]
        ],
        dtype=np.int64,
    )
    value = landing.gf529_quartic_value(quartic, direction)
    return form if np.any(value) else None


def enumerate_stabilizer_constraints(probe, frame_basis, invariant_basis_data, quartic):
    seed = json.loads(EIGENLINES.read_text())
    eigenspaces = exhaustive.recover_eigenspaces(seed)
    conjugacy_checks = exhaustive.conjugacy_checks(probe)
    assert all(record["covers_complete_type"] for record in conjugacy_checks)
    elements = [(a, b) for a in range(P) for b in range(P)]
    mandatory = []
    clauses = []
    clause_seen = set()
    total = Counter()
    summaries = []
    for space in eigenspaces:
        left = [tuple(value) for value in space["basis"][0]]
        right = [tuple(value) for value in space["basis"][1]]
        points = [right] + [
            exhaustive.vector_add_scaled(left, value, right)
            for value in elements
        ]
        local = Counter()
        for raw_point in points:
            point = np.asarray(raw_point, dtype=np.int64)
            outputs = extension_outputs(
                probe, frame_basis, invariant_basis_data, point
            )
            evaluation_rank = field.rank(outputs.transpose(1, 0, 2))
            local[f"rank_{evaluation_rank}"] += 1
            total[f"rank_{evaluation_rank}"] += 1
            if evaluation_rank == 1:
                form = rank_one_constraint(outputs, quartic)
                assert form is not None
                if form not in mandatory:
                    mandatory.append(form)
                local["nonzero_fourth_power"] += 1
                total["nonzero_fourth_power"] += 1
            elif evaluation_rank == 2:
                u, v, c_form, d_form = binary.image_coordinates(outputs)
                coefficients = binary.binary_quartic(quartic, u, v)
                factors = binary.split_factors(coefficients, c_form, d_form)
                assert factors is not None and len(factors) == 4
                clause = binary.canonical_clause(factors)
                if clause not in clause_seen:
                    clause_seen.add(clause)
                    clauses.append(clause)
                local["split_binary_quartic"] += 1
                total["split_binary_quartic"] += 1
            else:
                assert evaluation_rank == 0
        summaries.append(
            {
                **space,
                "line_count": len(points),
                "counts": dict(sorted(local.items())),
            }
        )
    assert sum(total[f"rank_{rank}"] for rank in (0, 1, 2)) == 3180
    assert total == Counter(
        {
            "rank_0": 2120,
            "rank_2": 1048,
            "split_binary_quartic": 1048,
            "rank_1": 12,
            "nonzero_fourth_power": 12,
        }
    )
    assert len(mandatory) == 3 and len(clauses) == 131
    return mandatory, clauses, summaries, conjugacy_checks, dict(sorted(total.items()))


def encoded_state(forms):
    state = tuple()
    for form in sorted(
        tuple(tuple(fast.encode(entry) for entry in form) for form in forms)
    ):
        state = fast.extend(state, form)
    return state


def collect_terminal_spaces(mandatory, clauses):
    initial = encoded_state(mandatory)
    encoded_clauses = [
        tuple(
            sorted(tuple(fast.encode(entry) for entry in factor) for factor in clause)
        )
        for clause in clauses
    ]
    nodes = 0
    memo = set()
    terminals = set()

    def visit(state, remaining):
        nonlocal nodes
        nodes += 1
        unsatisfied = [
            index for index in remaining
            if not any(fast.in_span(factor, state) for factor in encoded_clauses[index])
        ]
        if not unsatisfied:
            terminals.add(state)
            return
        key = (state, tuple(unsatisfied))
        if key in memo:
            return
        choices = []
        for index in unsatisfied:
            extensions = {
                fast.extend(state, factor) for factor in encoded_clauses[index]
            }
            choices.append((len(extensions), index, tuple(sorted(extensions))))
        _, selected, extensions = min(choices, key=lambda item: (item[0], item[1]))
        remaining_next = tuple(
            index for index in unsatisfied if index != selected
        )
        for extension in extensions:
            visit(extension, remaining_next)
        memo.add(key)

    visit(initial, tuple(range(len(encoded_clauses))))
    assert len(initial) == 3
    assert len(terminals) == 1
    terminal = next(iter(terminals))
    assert len(terminal) == 8
    kernel, free = fast.kernel(terminal, AMBIENT)
    assert len(kernel) == RESIDUAL
    assert all(fast.decode(value)[1] == 0 for row in terminal for value in row)
    assert all(fast.decode(value)[1] == 0 for row in kernel for value in row)
    return {
        "nodes": nodes,
        "memoized_states": len(memo),
        "terminal_count": len(terminals),
        "initial_rank": len(initial),
        "terminal_rank": len(terminal),
        "terminal_rref": [
            [list(fast.decode(value)) for value in row] for row in terminal
        ],
        "terminal_kernel": [
            [list(fast.decode(value)) for value in row] for row in kernel
        ],
        "free_columns": free,
    }


def coefficient_data(dimension):
    monomials = landing.probe_core.monomials(4, dimension)
    indices = []
    factors = []
    for alpha in monomials:
        ordered = []
        for index, exponent in enumerate(alpha):
            ordered.extend([index] * exponent)
        factor = factorial(4)
        for exponent in alpha:
            factor //= factorial(exponent)
        indices.append(ordered)
        factors.append(factor)
    return monomials, np.asarray(indices), np.asarray(factors)


def ordinary_outputs(probe, frame_basis, invariant_basis_data, point):
    transformed = np.einsum(
        "gij,j->gi", probe.group, point, optimize=True
    ) % P
    scalar = np.power(transformed[:, 5], 7) % P
    frame = [
        np.einsum(
            "g,gi->i", scalar, probe.inverse[:, :, output], optimize=True
        ) % P
        for output in SELECTED
    ]
    invariants = []
    for exponents in invariant_basis_data:
        values = np.ones(len(transformed), dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values = values * np.power(
                    transformed[:, coordinate], exponent
                ) % P
        invariants.append(int(np.sum(values, dtype=np.int64) % P))
    return np.stack(
        [
            invariants[index] * frame[column] % P
            for column in range(3)
            for index in range(INVARIANT_DIMENSION)
        ]
    )


def residual_full_rank(probe, frame_basis, invariant_basis_data, quartic, tensor, sat):
    kernel = np.asarray(
        [
            [entry[0] for entry in row]
            for row in sat["terminal_kernel"]
        ],
        dtype=np.int64,
    ).T
    assert kernel.shape == (AMBIENT, RESIDUAL)
    monomials, indices, factors = coefficient_data(RESIDUAL)
    assert len(monomials) == 35
    rng = np.random.default_rng(RESIDUAL_SEED)
    points = [
        rng.integers(0, P, 6, dtype=np.int64)
        for _ in range(RESIDUAL_SAMPLE_COUNT)
    ]
    rows = []
    checks = []
    coefficient_rng = np.random.default_rng(2026080172)
    for point_index, point in enumerate(points):
        ambient_outputs = ordinary_outputs(
            probe, frame_basis, invariant_basis_data, point
        )
        outputs = kernel.T @ ambient_outputs % P
        ordered = np.einsum(
            "rstu,ir,js,kt,lu->ijkl",
            tensor, outputs, outputs, outputs, outputs, optimize=True,
        ) % P
        row = (
            ordered[
                indices[:, 0], indices[:, 1], indices[:, 2], indices[:, 3]
            ]
            * factors
        ) % P
        rows.append(row)
        if point_index in (0, len(points) - 1):
            coefficients = coefficient_rng.integers(
                0, P, RESIDUAL, dtype=np.int64
            )
            monomial_values = landing.coefficient_monomial_values(
                monomials, coefficients
            )
            tensor_value = int(np.dot(row, monomial_values) % P)
            direct_value = landing.quartic_value(
                quartic, coefficients @ outputs % P
            )
            assert tensor_value == direct_value
            checks.append(
                {
                    "point_index": point_index,
                    "coefficient_vector": coefficients.tolist(),
                    "landing_value": tensor_value,
                    "check": "tensor/direct residual I4",
                }
            )
    rows_array = np.asarray(rows, dtype=np.int64)
    rank, library, profile = landing.rank_mod_prime(rows_array, profile=True)
    assert rank == landing.probe_core.fano.rank(rows_array) == 35
    assert len(profile) == 35
    return {
        "point_rng_seed": RESIDUAL_SEED,
        "points": [point.tolist() for point in points],
        "row_count": len(rows),
        "coefficient_quartic_monomials": len(monomials),
        "rows": rows_array.tolist(),
        "row_rank_over_F23": rank,
        "row_rank_profile": profile,
        "ffpack_library": library,
        "direct_checks": checks,
        "projective_emptiness": True,
        "reason": (
            "the residual rows span all 35 quartic coefficient monomials, "
            "so every fourth power of a residual coordinate must vanish"
        ),
    }


def serialize_forms(forms):
    return [
        [[int(a), int(b)] for a, b in form]
        for form in forms
    ]


def serialize_clauses(clauses):
    return [serialize_forms(clause) for clause in clauses]


def produce():
    dimension = invariant_dimension_certificate()
    probe = landing.probe_core.Probe()
    training_points, basis = invariant_basis(probe)
    frame_basis = probe.basis(7, 8)[:6]
    assert frame_basis == [
        (index, (0, 0, 0, 0, 0, 7)) for index in range(6)
    ]
    quartic, _ = landing.pencil_core.reconstruct()
    tensor = landing.symmetric_quartic_tensor(quartic)
    mandatory, clauses, summaries, conjugacy, counts = (
        enumerate_stabilizer_constraints(
            probe, frame_basis, basis, quartic
        )
    )
    sat = collect_terminal_spaces(mandatory, clauses)
    residual = residual_full_rank(
        probe, frame_basis, basis, quartic, tensor, sat
    )
    return {
        "schema": "full-schur-c015-degree8-invariant-linear-exclusion-v1",
        "prime": P,
        "field_extension": "F_23[u]/(u^2-5)",
        "selected_triple": list(SELECTED),
        "coefficient_model": (
            "D,A,B independently range over the complete degree-eight "
            "Schur-invariant polynomial space, and q=D*r0+A*r1+B*r5"
        ),
        "ambient_coefficient_dimension": AMBIENT,
        "result": (
            "no nonzero characteristic-zero triple (D,A,B) of degree-eight "
            "invariants makes I4(D*r0+A*r1+B*r5) vanish identically"
        ),
        "local_source_sha256": {
            "degree8_invariant_linear_slice.py": sha256(
                HERE / "degree8_invariant_linear_slice.py"
            ),
            "degree9_full_landing.py": sha256(HERE / "degree9_full_landing.py"),
            "eigenline_rank_one_probe.py": sha256(
                HERE / "eigenline_rank_one_probe.py"
            ),
            "degree9_binary_factor_sat.py": sha256(
                HERE / "degree9_binary_factor_sat.py"
            ),
            "degree9_binary_factor_sat_exhaustive.py": sha256(
                HERE / "degree9_binary_factor_sat_exhaustive.py"
            ),
            "degree9_fast_linear_sat.py": sha256(
                HERE / "degree9_fast_linear_sat.py"
            ),
            "degree9_rank_one_eigenlines_f529.json": sha256(EIGENLINES),
            "SEAL.json": sha256(HERE / "SEAL.json"),
        },
        "external_source_sha256": {
            "tmp/projective_source/character_scan.py": sha256(CHARACTER_SOURCE),
            "tmp/pfaffian_representation_alignment/core.py": sha256(
                ROOT / "tmp/pfaffian_representation_alignment/core.py"
            ),
            (
                "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/"
                "verify_char0_palatinian_lift.py"
            ): sha256(UPSTREAM / "verify_char0_palatinian_lift.py"),
        },
        "invariant_dimension_certificate": dimension,
        "invariant_basis": {
            "degree": INVARIANT_DEGREE,
            "dimension": INVARIANT_DIMENSION,
            "training_rng_seed": TRAINING_SEED,
            "training_points": [point.tolist() for point in training_points],
            "reynolds_seed_exponents": [list(item) for item in basis],
            "independent_good_reduction": True,
            "complete_characteristic_zero_lift": True,
        },
        "stabilizer_constraints": {
            "eigenspace_summaries": summaries,
            "conjugacy_checks": conjugacy,
            "counts": counts,
            "mandatory_forms": serialize_forms(mandatory),
            "mandatory_form_count": len(mandatory),
            "mandatory_rank": 3,
            "clauses": serialize_clauses(clauses),
            "clause_count": len(clauses),
            "all_binary_quartics_split": True,
        },
        "linear_sat": sat,
        "residual_certificate": residual,
        "special_fibre_projective_landing_locus_empty": True,
        "good_reduction_lift": (
            "a nonzero characteristic-zero coefficient vector scales to an "
            "integral vector with nonzero reduction, contradicting special-fibre emptiness"
        ),
        "strict_scope": [
            "complete only for common degree-eight invariant homogeneous coordinates D,A,B on C_015",
            "not an exclusion for common invariant degree ten or higher",
            "not an exclusion for arbitrary K_Schur-rational coefficients",
            "no K_Schur point and no V14 or X_Schur point is constructed",
            "neither binary Q headline is decided",
        ],
    }


def main():
    payload = produce()
    OUTPUT.write_text(json.dumps(payload, indent=2) + "\n")
    stabilizer = payload["stabilizer_constraints"]
    residual = payload["residual_certificate"]
    print(
        "PASS 3180 stabilizer lines: rank0=2120 rank1=12 rank2=1048, "
        "with all nonzero restrictions completely split"
    )
    print(
        f"PASS linear SAT clauses={stabilizer['clause_count']} "
        f"terminalRank={payload['linear_sat']['terminal_rank']} "
        f"terminalCount={payload['linear_sat']['terminal_count']}"
    )
    print(
        f"PASS residual quartic row rank={residual['row_rank_over_F23']}/"
        f"{residual['coefficient_quartic_monomials']}"
    )
    print("FULL_SCHUR_C015_DEGREE8_INVARIANT_LINEAR_EXCLUSION_OK")
    print("SCOPE: complete common-degree-eight invariant coordinates only; no K_Schur point verdict")


if __name__ == "__main__":
    main()
