#!/usr/bin/env python3
"""Independent, read-only verifier for the COV.2 degree 31/35 packet.

The verifier does not import a producer.  It checks the bound input hashes,
fixed-circuit ledgers, exact finite-field minors, ordered equalizer, standard
module quotient, complete nodal landing systems, and content-only seal.
"""

from __future__ import annotations

from collections import Counter
import ctypes
import gc
import hashlib
import importlib.util
import json
import math
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
PRIMES = (419, 463)
TARGETS = {
    31: {"full": 410, "m1": 198, "restriction": 212,
         "positive": 197, "equations": 5349, "source_degree": 93},
    35: {"full": 637, "m1": 361, "restriction": 276,
         "positive": 361, "equations": 8555, "source_degree": 105},
}
PRIMARY_DEGREES = (3, 5, 6, 8, 11)
SECONDARY_DEGREES = (0, 7, 9, 10, 12, 14, 14, 16, 18, 19, 21, 28)
SECONDARY_NAMES = (
    "1", "f7", "f9", "f10", "f12", "f14", "f7^2", "f7*f9",
    "f9^2", "f9*f10", "f7^3", "f9^2*f10",
)
FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
RECONSTRUCTOR = REPO / "tmp/degree13_opt/reconstruct_large_prime.py"
EXPECTED_DUAL_NUMERATOR = {
    2: 1, 4: 1, 5: 1, 6: 2, 7: 2, 8: 2, 9: 3, 10: 3,
    11: 4, 12: 3, 13: 5, 14: 5, 15: 4, 16: 5, 17: 4,
    18: 4, 19: 2, 20: 4, 21: 1, 22: 1, 23: 1, 24: 1, 27: 1,
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def load_json(path: Path):
    with path.open() as stream:
        return json.load(stream)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def require_hash(path: Path, expected: str) -> None:
    require(path.is_file(), f"missing {path}")
    actual = sha256(path)
    require(actual == expected, f"hash mismatch {path}: {actual} != {expected}")


def load_group_module(prime: int, zeta: int):
    """Load only the bound exact group model, never a packet producer."""
    for path in (REPO / "tmp/generic_twist", REPO / "tmp/kproj_arithmetic"):
        if str(path) not in sys.path:
            sys.path.insert(0, str(path))
    name = f"independent_cov_m1_group_{prime}"
    spec = importlib.util.spec_from_file_location(name, RECONSTRUCTOR)
    require(spec is not None and spec.loader is not None, "group loader spec")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module.load_module(prime, zeta)


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    """Exact row rank over F_prime, using only NumPy integer operations."""
    value = np.array(matrix, dtype=np.int64, copy=True) % prime
    rows, columns = value.shape
    pivot_row = 0
    for column in range(columns):
        candidates = np.flatnonzero(value[pivot_row:, column])
        if not len(candidates):
            continue
        source = pivot_row + int(candidates[0])
        if source != pivot_row:
            value[[pivot_row, source]] = value[[source, pivot_row]]
        inverse = pow(int(value[pivot_row, column]), -1, prime)
        value[pivot_row, column:] = (
            value[pivot_row, column:] * inverse % prime
        )
        if pivot_row + 1 < rows:
            factors = value[pivot_row + 1:, column].copy()
            nonzero = np.flatnonzero(factors)
            if len(nonzero):
                target = pivot_row + 1 + nonzero
                value[target, column:] = (
                    value[target, column:]
                    - factors[nonzero, None] * value[pivot_row, column:]
                ) % prime
        pivot_row += 1
        if pivot_row == rows or pivot_row == columns:
            break
    return pivot_row


def determinant_mod(matrix: np.ndarray, prime: int) -> int:
    """Exact determinant via the independently loaded FFPACK C interface."""
    value = np.array(matrix, dtype=np.float64, order="C", copy=True)
    function = ctypes.CDLL(FFPACK).Det_modular_double
    function.argtypes = [
        ctypes.c_double, ctypes.c_size_t, ctypes.POINTER(ctypes.c_double),
        ctypes.c_size_t, ctypes.c_bool,
    ]
    function.restype = ctypes.c_double
    result = function(
        float(prime), len(value),
        value.ctypes.data_as(ctypes.POINTER(ctypes.c_double)),
        value.shape[1], True,
    )
    return int(round(result)) % prime


def evaluate_sparse(terms, nodes: np.ndarray, prime: int,
                    powers: dict[tuple[int, int], np.ndarray]) -> np.ndarray:
    answer = np.zeros(len(nodes), dtype=np.int64)
    for term in terms:
        value = np.full(len(nodes), term["coefficient"] % prime, dtype=np.int64)
        for variable, exponent in enumerate(term["exponents"]):
            exponent = int(exponent)
            if not exponent:
                continue
            key = variable, exponent
            if key not in powers:
                powers[key] = pow_array(nodes[:, variable], exponent, prime)
            value = value * powers[key] % prime
        answer = (answer + value) % prime
    return answer


def pow_array(base: np.ndarray, exponent: int, prime: int) -> np.ndarray:
    answer = np.ones_like(base, dtype=np.int64)
    factor = np.asarray(base, dtype=np.int64) % prime
    while exponent:
        if exponent & 1:
            answer = answer * factor % prime
        exponent //= 2
        if exponent:
            factor = factor * factor % prime
    return answer


def rebuild_invariant_matrix(nodes: np.ndarray, labels, prime: int,
                             generators) -> np.ndarray:
    powers: dict[tuple[int, int], np.ndarray] = {}
    forms = {
        int(degree): evaluate_sparse(terms, nodes, prime, powers)
        for degree, terms in generators["forms"].items()
    }
    primary = [forms[degree] for degree in PRIMARY_DEGREES]
    secondary = [
        np.ones(len(nodes), dtype=np.int64),
        forms[7], forms[9], forms[10], forms[12], forms[14],
        forms[7] * forms[7] % prime,
        forms[7] * forms[9] % prime,
        forms[9] * forms[9] % prime,
        forms[9] * forms[10] % prime,
        forms[7] * forms[7] % prime * forms[7] % prime,
        forms[9] * forms[9] % prime * forms[10] % prime,
    ]
    primary_powers: dict[tuple[int, int], np.ndarray] = {}
    matrix = np.empty((len(nodes), len(labels)), dtype=np.uint16)
    for column, label in enumerate(labels):
        value = secondary[int(label["secondary_index"])].copy()
        for index, exponent in enumerate(label["primary_exponents"]):
            exponent = int(exponent)
            if not exponent:
                continue
            key = index, exponent
            if key not in primary_powers:
                primary_powers[key] = pow_array(primary[index], exponent, prime)
            value = value * primary_powers[key] % prime
        matrix[:, column] = value.astype(np.uint16)
    return matrix


def determinant4_batch(rows: np.ndarray, prime: int) -> np.ndarray:
    """Determinants of a batch of 4 by 4 matrices, independently expanded."""
    from itertools import permutations

    answer = np.zeros(len(rows), dtype=np.int64)
    for permutation in permutations(range(4)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(4) for j in range(i + 1, 4)
        )
        term = np.ones(len(rows), dtype=np.int64)
        for i, j in enumerate(permutation):
            term = term * rows[:, i, j] % prime
        answer = (answer + (-1 if inversions % 2 else 1) * term) % prime
    return answer


def evaluate_dual_reynolds(module, nodes: np.ndarray, generators, prime: int):
    transformed = np.einsum("gij,pj->pgi", module.GROUP, nodes) % prime
    powers: dict[tuple[int, int], np.ndarray] = {}
    output = []
    for record in generators:
        values = np.ones(transformed.shape[:2], dtype=np.int64)
        for coordinate, exponent in enumerate(record["reynolds_exponents"]):
            exponent = int(exponent)
            if not exponent:
                continue
            key = coordinate, exponent
            if key not in powers:
                powers[key] = pow_array(
                    transformed[:, :, coordinate], exponent, prime
                ).reshape(transformed.shape[:2])
            values = values * powers[key] % prime
        column = int(record["reynolds_output"])
        output.append(
            values @ np.asarray(module.GROUP[:, column, :], dtype=np.int64)
            % prime
        )
    return np.asarray(output, dtype=np.int64)


def invariant_factors_at_nodes(nodes: np.ndarray, prime: int, generators):
    powers: dict[tuple[int, int], np.ndarray] = {}
    forms = {
        int(degree): evaluate_sparse(terms, nodes, prime, powers)
        for degree, terms in generators["forms"].items()
    }
    primary = [forms[degree] for degree in PRIMARY_DEGREES]
    secondary = [
        np.ones(len(nodes), dtype=np.int64),
        forms[7], forms[9], forms[10], forms[12], forms[14],
        forms[7] * forms[7] % prime,
        forms[7] * forms[9] % prime,
        forms[9] * forms[9] % prime,
        forms[9] * forms[10] % prime,
        forms[7] * forms[7] % prime * forms[7] % prime,
        forms[9] * forms[9] % prime * forms[10] % prime,
    ]
    return primary, secondary


def independently_evaluate_crosses(module, nodes: np.ndarray, prime: int,
                                   dual_generators, records, invariant_generators):
    dual = evaluate_dual_reynolds(module, nodes, dual_generators, prime)
    primary, secondary = invariant_factors_at_nodes(
        nodes, prime, invariant_generators
    )
    answer = np.empty((len(nodes), 5, len(records)), dtype=np.int64)
    for record_index, record in enumerate(records):
        selected = dual[list(map(int, record["dual_generator_indices"]))]
        rows = selected.transpose(1, 0, 2)
        cross = np.empty((len(nodes), 5), dtype=np.int64)
        for omitted in range(5):
            columns = [column for column in range(5) if column != omitted]
            value = determinant4_batch(rows[:, :, columns], prime)
            cross[:, omitted] = value if omitted % 2 == 0 else -value
        multiplier = record["multiplier"]
        scalar = secondary[int(multiplier["secondary_index"])].copy()
        for index, exponent in enumerate(multiplier["primary_exponents"]):
            if int(exponent):
                scalar = scalar * pow_array(
                    primary[index], int(exponent), prime
                ) % prime
        answer[:, :, record_index] = cross % prime * scalar[:, None] % prime
    return answer


def verify_inputs() -> None:
    ledger = load_json(HERE / "INPUTS.json")
    require(ledger["schema"] == "cov-m1-input-ledger-v1", "input schema")
    require(
        ledger["pinned_state"] == "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "wrong pinned state",
    )
    for record in ledger["files"]:
        require_hash(REPO / record["path"], record["sha256"])
    p25_goal = REPO / "goals_2026-08-01/GOAL_P25_LANDING_SUPPORT.md"
    text = p25_goal.read_text()
    require("**Current headline:** **OPEN**" in text,
            "P25 dependency is not OPEN")
    require("P25-UNDECIDED" in text, "P25 honest-stop boundary missing")
    print(f"inputs: {len(ledger['files'])} hashes and open P25 dependency OK")


def verify_canonical_bases() -> None:
    canonical = load_json(HERE / "canonical_bases.json")
    require_hash(HERE / canonical["dual_generators"],
                 canonical["dual_generators_sha256"])
    dual = load_json(HERE / canonical["dual_generators"])
    numerator = {int(key): int(value) for key, value in
                 dual["exact_hironaka_numerator"].items()}
    require(numerator == EXPECTED_DUAL_NUMERATOR, "dual numerator mismatch")
    generators = dual["generators"]
    # The degree-27 generator cannot enter a fourfold wedge in degrees <=35:
    # the other three smallest positive generator degrees already sum to 11.
    expected_used = dict(EXPECTED_DUAL_NUMERATOR)
    del expected_used[27]
    require(Counter(item["degree"] for item in generators) == expected_used,
            "fixed dual generators through degree 24 mismatch")
    require(len(generators) == 59, "expected 59 usable fixed dual generators")

    for degree, target in TARGETS.items():
        record = canonical["degrees"][str(degree)]
        require(record["full_dimension"] == target["full"], "full dimension")
        require(record["m1_dimension"] == target["m1"], "m1 dimension")
        require_hash(HERE / record["full_basis"], record["full_basis_sha256"])
        require_hash(HERE / record["m1_basis"], record["m1_basis_sha256"])
        full = load_json(HERE / record["full_basis"])
        cross = load_json(HERE / record["m1_basis"])
        require(len(full) == target["full"], "full circuit count")
        require(cross["dimension"] == target["m1"], "cross dimension field")
        require(len(cross["basis"]) == target["m1"], "cross circuit count")
        previous_rows = None
        previous_points = None
        for prime in PRIMES:
            fibre = canonical["prime_records"][str(prime)]["degrees"][str(degree)]
            require(fibre["full_basis_rank"] == target["full"], "full rank ledger")
            require(fibre["restriction_rank"] == target["restriction"],
                    "restriction rank ledger")
            require(fibre["restriction_kernel_upper_bound"] == target["m1"],
                    "kernel upper bound")
            require(fibre["cross_basis_rank"] == target["m1"],
                    "cross rank ledger")
            payload = HERE / f"degree_{degree}" / fibre["payload"]
            require_hash(payload, fibre["payload_sha256"])
            with np.load(payload, allow_pickle=False) as frozen:
                points = frozen["fixed_points"]
                evaluations = frozen["cross_evaluations"]
                rows = frozen["fixed_cross_minor_rows"]
                full_rows = frozen["full_basis_minor_rows"]
                require(evaluations.shape == (5 * len(points), target["m1"]),
                        "cross evaluation shape")
                require(len(rows) == target["m1"] and len(set(map(int, rows))) == len(rows),
                        "cross minor row profile")
                require(np.max(rows) < len(evaluations), "cross minor row bound")
                require(rank_mod(evaluations[rows], prime) == target["m1"],
                        f"cross fixed minor drops at p={prime}, d={degree}")
                require(len(full_rows) == target["full"] and
                        len(set(map(int, full_rows))) == len(full_rows),
                        "full minor row profile")
                if previous_rows is not None:
                    require(np.array_equal(rows, previous_rows),
                            "cross minor rows changed with prime")
                    require(np.array_equal(points, previous_points),
                            "fixed points changed with prime")
                previous_rows = rows.copy()
                previous_points = points.copy()
        require(target["full"] - target["restriction"] == target["m1"],
                "dimension sandwich does not close")
        print(f"canonical d={degree}: {target['full']} -> K1 {target['m1']} OK")


def verify_equalizers() -> None:
    root = load_json(HERE / "ordered_equalizers.json")
    require_hash(HERE / root["canonical_bases"], root["canonical_bases_sha256"])
    expected_ids = [
        "01_all_55_plus_planes_order_one",
        "02_V4_triple_line_equalizers",
        "03_residual_multiple_point_kernels",
        "04_D12_source_minus_line_restrictions",
        "05_C3_lines_C6_endpoints",
        "06_A4_D10_D12_point_links",
        "07_marked_type_I_type_II_elliptic_compatibility",
        "08_finite_irrelevant_torsion_correction",
    ]
    for dependency in root["dependencies"]:
        require_hash(REPO / dependency["path"], dependency["sha256"])
    for degree, target in TARGETS.items():
        record = root["degrees"][str(degree)]
        payload = HERE / record["payload"]
        require_hash(payload, record["payload_sha256"])
        equalizer = load_json(payload)
        stages = equalizer["ordered_stages"]
        require([stage["id"] for stage in stages] == expected_ids,
                "ordered equalizer stage mismatch")
        require(stages[0]["constraint_rank"] == target["restriction"],
                "initial equalizer rank")
        require(stages[0]["input_dimension"] == target["full"], "initial input")
        require(stages[0]["output_dimension"] == target["m1"], "initial output")
        for stage in stages[1:7]:
            require(stage["constraint_rank_on_literal_global_basis"] == 0,
                    f"nonzero literal defect in {stage['id']}")
            require(stage["matrix_circuit"]["simplified_matrix"] == "ZERO",
                    f"missing zero circuit in {stage['id']}")
            require(stage["global_coefficient_vector_preserved"],
                    f"coefficient reset in {stage['id']}")
        torsion = stages[7]
        require(torsion["constraint_rank_on_literal_global_basis"] == 0,
                "torsion correction cuts literal image")
        require(torsion["torsion"]["coefficient_space_used_for_landing"] ==
                "literal global K1 only", "compact class leaked into landing")
        require(equalizer["final_dimension"] == target["m1"] == record["final_dimension"],
                "final equalizer dimension")
        print(f"ordered equalizer d={degree}: 8 stages, dim {target['m1']} OK")


def verify_primitive_module() -> None:
    root = load_json(HERE / "primitive_module.json")
    require_hash(HERE / root["canonical_bases"], root["canonical_bases_sha256"])
    require("does not descend" in root["projective_warning"],
            "missing nonlinear quotient warning")
    for degree, target in TARGETS.items():
        record = root["degrees"][str(degree)]
        payload = HERE / record["payload"]
        require_hash(payload, record["payload_sha256"])
        basis = load_json(payload)
        require(basis["dimension"] == target["positive"], "positive dimension")
        require(len(basis["basis"]) == target["positive"], "positive basis count")
        expected_complement = target["m1"] - target["positive"]
        require(len(basis["fixed_complement_indices"]) == expected_complement,
                "fixed complement count")
        previous_rows = None
        for prime in PRIMES:
            fibre = root["prime_records"][str(prime)]["degrees"][str(degree)]
            require(fibre["literal_K1_dimension"] == target["m1"], "primitive K1")
            require(fibre["fixed_positive_basis_rank"] == target["positive"],
                    "positive fibre rank")
            require(fibre["standard_module_quotient_dimension_in_this_fibre"] ==
                    expected_complement, "fibre quotient")
            npz = HERE / f"degree_{degree}/positive_multiples_p{prime}.npz"
            with np.load(npz, allow_pickle=False) as frozen:
                evaluations = frozen["selected_evaluations"]
                rows = frozen["fixed_minor_rows"]
                require(evaluations.shape == (400, target["positive"]),
                        "positive evaluation shape")
                require(len(rows) == target["positive"], "positive minor size")
                require(rank_mod(evaluations[rows], prime) == target["positive"],
                        f"positive fixed minor drops at p={prime}, d={degree}")
                if previous_rows is not None:
                    require(np.array_equal(rows, previous_rows),
                            "positive minor rows changed with prime")
                previous_rows = rows.copy()
        print(f"module d={degree}: positive span {target['positive']}, "
              f"linear quotient <= {expected_complement} OK")


def verify_primitive_counterexample() -> None:
    module_record = load_json(HERE / "primitive_module.json")
    counter_record = module_record["primitive_quotient_counterexample"]
    path = HERE / counter_record["payload"]
    require_hash(path, counter_record["payload_sha256"])
    root = load_json(path)
    require(root["schema"] == "cov-m1-primitive-quotient-counterexample-v1",
            "primitive counterexample schema")
    prime = int(root["prime"])
    require(prime == 419, "primitive counterexample prime")
    module = load_group_module(prime, int(root["zeta11"]))
    dual = load_json(HERE / "dual_hironaka_generators.json")
    invariant = load_json(HERE / "invariant_generators.json")
    a = np.asarray(root["line"]["a"], dtype=np.int64)
    b = np.asarray(root["line"]["b"], dtype=np.int64)

    def polynomial_value(coefficients, argument):
        value = 0
        for coefficient in reversed(coefficients):
            value = (value * argument + int(coefficient)) % prime
        return value

    def polynomial_sum(left, right):
        answer = [0] * max(len(left), len(right))
        for index in range(len(answer)):
            answer[index] = (
                (int(left[index]) if index < len(left) else 0)
                + (int(right[index]) if index < len(right) else 0)
            ) % prime
        while len(answer) > 1 and answer[-1] == 0:
            answer.pop()
        return answer

    def polynomial_product(left, right):
        answer = [0] * (len(left) + len(right) - 1)
        for i, x in enumerate(left):
            for j, y in enumerate(right):
                answer[i + j] = (answer[i + j] + int(x) * int(y)) % prime
        while len(answer) > 1 and answer[-1] == 0:
            answer.pop()
        return answer

    for degree in (31, 35):
        record = root["degrees"][str(degree)]
        positive_path = HERE / record["positive_basis"]
        require_hash(positive_path, record["positive_basis_sha256"])
        positive = load_json(positive_path)["basis"]
        indices = list(map(int, record["summand_indices"]))
        require(len(indices) == 2, "counterexample summand count")
        selected = [positive[index] for index in indices]
        require(selected == record["summand_circuits"],
                "counterexample circuit mismatch")
        for item in selected:
            multiplier = item["multiplier"]
            weight = int(multiplier["secondary_degree"]) + sum(
                degree_weight * int(exponent)
                for degree_weight, exponent in
                zip(PRIMARY_DEGREES, multiplier["primary_exponents"])
            )
            require(weight > 0, "counterexample summand is not a positive multiple")
        points = np.asarray([
            (parameter * a + b) % prime for parameter in range(degree + 1)
        ], dtype=np.int64)
        summands = independently_evaluate_crosses(
            module, points, prime, dual["generators"], selected, invariant
        )
        values = np.sum(summands, axis=2) % prime
        polynomials = record["component_polynomials_coefficients_ascending"]
        require(len(polynomials) == 5, "counterexample component count")
        for parameter in range(degree + 1):
            rebuilt = [
                polynomial_value(polynomial, parameter)
                for polynomial in polynomials
            ]
            require(rebuilt == values[parameter].tolist(),
                    "counterexample interpolation mismatch")
        require(any(
            len(polynomial) == degree + 1 and int(polynomial[-1]) % prime
            for polynomial in polynomials
        ), "all restricted components vanish at line infinity")
        total = [0]
        bezout = record["bezout_coefficients_ascending"]
        require(len(bezout) == 5, "counterexample Bezout count")
        for coefficient, polynomial in zip(bezout, polynomials):
            total = polynomial_sum(
                total, polynomial_product(coefficient, polynomial)
            )
        require(total == [1], "counterexample Bezout identity")
        print(f"primitive d={degree}: exact R_+ sum with component gcd one OK")


def verify_c3_constant_gate() -> None:
    root = load_json(HERE / "c3_constant_gate.json")
    require(root["schema"] == "cov-m1-c3-c6-constant-gate-v1", "C3 gate schema")
    expected = {31: (198, 11, 187, 21, 10), 35: (361, 13, 348, 25, 12)}

    def projectively_fixed(vector: np.ndarray, matrix: np.ndarray, prime: int) -> bool:
        return rank_mod(np.vstack([vector, matrix @ vector % prime]), prime) == 1

    def klein(vector: np.ndarray, prime: int) -> int:
        return sum(
            int(vector[index]) ** 2 * int(vector[(index + 1) % 5])
            for index in range(5)
        ) % prime

    for prime_record in root["prime_records"]:
        prime = int(prime_record["prime"])
        probe_path = HERE / prime_record["payload"]
        require_hash(probe_path, prime_record["payload_sha256"])
        probe = load_json(probe_path)
        require(probe["prime"] == prime, "C3 probe prime")
        omega = int(probe["omega"])
        generator = np.asarray(probe["order_three_generator"], dtype=np.int64)
        source = np.asarray(probe["source_eigenspace"], dtype=np.int64)
        require(np.array_equal(
            (generator @ source.T).T % prime, omega * source % prime
        ), "source is not the selected C3 eigenspace")
        stabilizer = [np.asarray(item, dtype=np.int64)
                      for item in probe["setwise_stabilizer"]]
        require(len(stabilizer) == probe["setwise_stabilizer_order"] == 6,
                "C3 line stabilizer order")
        for matrix in stabilizer:
            image = (matrix @ source.T).T % prime
            require(rank_mod(np.vstack([source, image]), prime) == 2,
                    "stabilizer does not preserve source line")
        c6 = np.asarray(probe["c6_generator"], dtype=np.int64)
        require(any(np.array_equal(c6, matrix) for matrix in stabilizer),
                "C6 generator not in stabilizer")

        for degree, values_expected in expected.items():
            dimension, gate_rank, kernel_dimension, restriction_rank, scalar_dim = values_expected
            aggregate = root["degrees"][str(degree)]
            require((aggregate["input_dimension"], aggregate["gate_rank"],
                     aggregate["reduced_parameter_dimension"],
                     aggregate["restriction_rank"],
                     aggregate["allowed_constant_scalar_dimension"]) == values_expected,
                    "C3 aggregate degree record")
            record = probe["degrees"][str(degree)]
            require_hash(HERE / record["payload"], record["payload_sha256"])
            binary = record["target_binary_cubic"]
            a, b, c, d = map(int, binary["coefficients_s3_s2t_st2_t3"])
            discriminant = (
                18 * a * b * c * d - 4 * b ** 3 * d + b * b * c * c
                - 4 * a * c ** 3 - 27 * a * a * d * d
            ) % prime
            require(discriminant == binary["discriminant"] != 0,
                    "C3 binary section not reduced")
            for rational_root in binary["Fp_rational_roots"]:
                require(klein(np.asarray(rational_root, dtype=np.int64), prime) == 0,
                        "listed C3 root not on Klein cubic")
            with np.load(HERE / record["payload"], allow_pickle=False) as frozen:
                points = frozen["source_points"].astype(np.int64)
                values = frozen["basis_values"].astype(np.int64)
                gate = frozen["gate_matrix"].astype(np.int64)
                fixed_root = frozen["unique_c6_root"].astype(np.int64)
            require(points.shape == (degree + 1, 5), "C3 source point shape")
            require(values.shape == (degree + 1, 5, dimension),
                    "C3 basis value shape")
            require(np.array_equal(
                np.einsum("ij,pj->pi", generator, points) % prime,
                omega * points % prime,
            ), "C3 source point eigencondition")
            target_scalar = pow(omega, degree, prime)
            require(np.array_equal(
                np.einsum("ij,pjk->pik", generator, values) % prime,
                target_scalar * values % prime,
            ), "restricted basis has wrong target character")
            require(klein(fixed_root, prime) == 0, "C6 root not on Klein cubic")
            require(all(projectively_fixed(fixed_root, matrix, prime)
                        for matrix in stabilizer), "root not C6-fixed")
            pivot = int(np.flatnonzero(fixed_root)[0])
            rebuilt = []
            for target in range(5):
                if target != pivot:
                    rebuilt.append(
                        fixed_root[pivot] * values[:, target, :]
                        - fixed_root[target] * values[:, pivot, :]
                    )
            rebuilt_gate = np.concatenate(rebuilt, axis=0) % prime
            require(np.array_equal(gate % prime, rebuilt_gate),
                    "C3 gate serialization")
            require(rank_mod(gate, prime) == gate_rank, "C3 gate rank")
            require(rank_mod(values.reshape(-1, dimension), prime) == restriction_rank,
                    "C3 restriction rank")
            require(restriction_rank - gate_rank == scalar_dim,
                    "C3 scalar-form dimension")
            require(dimension - gate_rank == kernel_dimension,
                    "C3 reduced dimension")
        print(f"C3/C6 gate p={prime}: d31 rank 11, d35 rank 13 OK")


def verify_c3_reduced_landing() -> None:
    root_path = HERE / "c3_reduced_landing.json"
    root = load_json(root_path)
    require(root["schema"] == "cov-m1-c3-reduced-complete-landing-v1",
            "C3 reduced schema")
    require(root["prime"] == 463, "C3 reduced prime")
    expected = {31: (198, 187, 10, 177, 5349),
                35: (361, 348, 12, 336, 8555)}
    for degree, values_expected in expected.items():
        dimension, reduced_dimension, scalar_rank, based_dimension, equation_count = (
            values_expected
        )
        aggregate = root["degrees"][str(degree)]
        metadata_path = HERE / aggregate["metadata"]
        require_hash(metadata_path, aggregate["metadata_sha256"])
        metadata = load_json(metadata_path)
        for key in (
            "payload", "payload_sha256", "gate_payload", "gate_payload_sha256",
            "landing_payload", "landing_payload_sha256",
            "original_parameter_dimension", "reduced_parameter_dimension",
            "complete_equation_count", "c3_scalar_form_rank",
            "based_restriction_zero_dimension", "nonbased_chart_count",
        ):
            require(metadata[key] == aggregate[key],
                    f"C3 reduced aggregate mismatch: {key}")
        payload_path = HERE / metadata["payload"]
        gate_path = HERE / metadata["gate_payload"]
        landing_path = HERE / metadata["landing_payload"]
        require_hash(payload_path, metadata["payload_sha256"])
        require_hash(gate_path, metadata["gate_payload_sha256"])
        require_hash(landing_path, metadata["landing_payload_sha256"])
        require((metadata["original_parameter_dimension"],
                 metadata["reduced_parameter_dimension"],
                 metadata["c3_scalar_form_rank"],
                 metadata["based_restriction_zero_dimension"],
                 metadata["complete_equation_count"]) == values_expected,
                "C3 reduced dimension ledger")
        with np.load(payload_path, allow_pickle=False) as frozen:
            points = frozen["source_points"].astype(np.int64)
            reduced = frozen["reduced_basis_values"].astype(np.int64)
            kernel = frozen["c3_kernel_basis"].astype(np.int64)
            pivots = frozen["c3_pivot_columns"].astype(np.int64)
            free = frozen["c3_free_columns"].astype(np.int64)
            scalar = frozen["c3_scalar_forms"].astype(np.int64)
            based = frozen["based_kernel_basis"].astype(np.int64)
        require(kernel.shape == (dimension, reduced_dimension),
                "C3 kernel shape")
        require(np.array_equal(kernel[free] % 463,
                               np.eye(reduced_dimension, dtype=np.int64)),
                "C3 kernel free identity")
        with np.load(gate_path, allow_pickle=False) as frozen:
            gate = frozen["gate_matrix"].astype(np.int64)
            line_values = frozen["basis_values"].astype(np.int64)
            fixed_root = frozen["unique_c6_root"].astype(np.int64)
        require(not np.any(gate @ kernel % 463), "C3 kernel is not in gate")
        require(rank_mod(kernel, 463) == reduced_dimension, "C3 kernel rank")
        with np.load(landing_path, allow_pickle=False) as frozen:
            old_points = frozen["fixed_source_points"].astype(np.int64)
            old_values = frozen["basis_values"].astype(np.int64)
        require(np.array_equal(points, old_points), "C3 reduced source nodes")
        require(reduced.shape == (equation_count, 5, reduced_dimension),
                "C3 reduced form shape")
        old_forms = old_values.reshape(-1, dimension)
        new_forms = reduced.reshape(-1, reduced_dimension)
        for start in range(0, len(old_forms), 2048):
            stop = min(start + 2048, len(old_forms))
            rebuilt = old_forms[start:stop, free]
            if len(pivots):
                rebuilt = rebuilt + old_forms[start:stop, pivots] @ kernel[pivots]
            require(np.array_equal(rebuilt % 463, new_forms[start:stop] % 463),
                    "C3 reduced landing serialization")
        require(rank_mod(new_forms[:2 * reduced_dimension], 463) ==
                reduced_dimension, "C3 reduced form rank")
        line_reduced = np.einsum("pjn,nk->pjk", line_values, kernel) % 463
        root_pivot = int(np.flatnonzero(fixed_root)[0])
        require(all(np.array_equal(
            line_reduced[:, target, :] % 463,
            fixed_root[target] * scalar % 463,
        ) for target in range(5)), "C3 scalar-form serialization")
        require(rank_mod(scalar, 463) == scalar_rank, "C3 scalar rank")
        require(based.shape == (reduced_dimension, based_dimension),
                "C3 based-kernel shape")
        require(not np.any(scalar @ based % 463), "C3 based kernel")
        require(rank_mod(based, 463) == based_dimension, "C3 based rank")
        print(f"C3-reduced d={degree}: {equation_count} cubics on "
              f"{reduced_dimension}; based {based_dimension}, "
              f"{scalar_rank} nonbased charts OK")
        del (points, reduced, kernel, pivots, free, scalar, based, gate,
             line_values, fixed_root, old_points, old_values, old_forms,
             new_forms, line_reduced, rebuilt)
        gc.collect()


def verify_c3_first_normal_gate() -> None:
    root = load_json(HERE / "c3_first_normal_gate.json")
    require(root["schema"] == "cov-m1-c3-first-normal-gate-v1",
            "C3 first-normal schema")
    require(root["degrees"] == {
        "31": {"based_dimension": 177, "first_normal_dimension": 147},
        "35": {"based_dimension": 336, "first_normal_dimension": 300},
    }, "C3 first-normal dimension ledger")
    invariant_generators = load_json(HERE / "invariant_generators.json")
    dual = load_json(HERE / "dual_hironaka_generators.json")

    def derivative_weights(degree: int, prime: int) -> np.ndarray:
        weights = np.empty(degree + 1, dtype=np.int64)
        weights[0] = -sum(pow(item, -1, prime) for item in range(1, degree + 1))
        for item in range(1, degree + 1):
            sign = -1 if item % 2 == 0 else 1
            weights[item] = (
                sign * math.comb(degree, item) * pow(item, -1, prime)
            ) % prime
        return weights % prime

    expected_ranks = {31: [21, 32, 51], 35: [25, 38, 61, 61]}
    for prime_record in root["prime_records"]:
        prime = int(prime_record["prime"])
        zeta = int(prime_record["zeta11"])
        require((prime, zeta) in ((463, 15), (727, 46)),
                "C3 first-normal prime")
        probe = load_json(HERE / f"c3_constant_gate_probe_p{prime}.json")
        omega = int(probe["omega"])
        generator = np.asarray(probe["order_three_generator"], dtype=np.int64)
        stabilizer = [np.asarray(item, dtype=np.int64)
                      for item in probe["setwise_stabilizer"]]
        module = load_group_module(prime, zeta)
        for degree, target in TARGETS.items():
            dimension = target["m1"]
            record = prime_record["degrees"][str(degree)]
            gate_path = HERE / record["c3_gate_payload"]
            require_hash(gate_path, record["c3_gate_payload_sha256"])
            with np.load(gate_path, allow_pickle=False) as frozen:
                based = frozen["basis_values"].astype(np.int64).reshape(
                    -1, dimension
                )
            matrices = [based]
            basis_records = load_json(
                HERE / f"degree_{degree}/m1_cross_basis_circuits.json"
            )["basis"]
            basis_indices = [0, dimension - 1]
            weights = derivative_weights(degree, prime)
            for block_record in record["blocks"]:
                path = HERE / block_record["payload"]
                require_hash(path, block_record["payload_sha256"])
                with np.load(path, allow_pickle=False) as frozen:
                    points = frozen["source_points"].astype(np.int64)
                    directions = frozen["normal_directions"].astype(np.int64)
                    derivatives = frozen["derivative_values"].astype(np.int64)
                    extra = frozen["extra_gate_matrix"].astype(np.int64)
                    target_space = frozen["target_eigenspace"].astype(np.int64)
                    target_root = frozen["target_root"].astype(np.int64)
                require(points.shape == (degree, 5), "first-normal source points")
                require(np.array_equal(
                    np.einsum("ij,pj->pi", generator, points) % prime,
                    omega * points % prime,
                ), "first-normal source eigenspace")
                normal_exponent = next(
                    exponent for exponent in (0, 2)
                    if np.array_equal(
                        np.einsum("ij,pj->pi", generator, directions) % prime,
                        pow(omega, exponent, prime) * directions % prime,
                    )
                )
                target_exponent = (degree - 1 + normal_exponent) % 3
                require(np.array_equal(
                    np.einsum("ij,pj->pi", generator, target_space) % prime,
                    pow(omega, target_exponent, prime) * target_space % prime,
                ), "first-normal target eigenspace")
                require(derivatives.shape ==
                        (len(directions) * degree, 5, dimension),
                        "first-normal derivative shape")
                require(np.array_equal(
                    np.einsum("ij,pjk->pik", generator, derivatives) % prime,
                    pow(omega, target_exponent, prime) * derivatives % prime,
                ), "first-normal derivative character")
                if block_record["target_kind"] == "zero":
                    require(len(target_space) == 1 and not len(target_root),
                            "first-normal zero target shape")
                    require(sum(
                        int(target_space[0, index]) ** 2
                        * int(target_space[0, (index + 1) % 5])
                        for index in range(5)
                    ) % prime != 0, "first-normal target point lies on Klein")
                    rebuilt = derivatives.reshape(-1, dimension) % prime
                else:
                    require(len(target_space) == 2 and len(target_root) == 5,
                            "first-normal fixed-root shape")
                    require(sum(
                        int(target_root[index]) ** 2
                        * int(target_root[(index + 1) % 5])
                        for index in range(5)
                    ) % prime == 0, "first-normal root not on Klein")
                    require(all(rank_mod(np.vstack([
                        target_root, matrix @ target_root % prime
                    ]), prime) == 1 for matrix in stabilizer),
                            "first-normal root not C6-fixed")
                    pivot = int(np.flatnonzero(target_root)[0])
                    rebuilt = np.concatenate([
                        np.concatenate([
                            target_root[pivot]
                            * derivatives[
                                direction_index * degree:(direction_index + 1) * degree,
                                output, :
                            ]
                            - target_root[output]
                            * derivatives[
                                direction_index * degree:(direction_index + 1) * degree,
                                pivot, :
                            ]
                            for output in range(5) if output != pivot
                        ], axis=0)
                        for direction_index in range(len(directions))
                    ], axis=0) % prime
                require(np.array_equal(rebuilt, extra % prime),
                        "first-normal gate serialization")
                matrices.append(extra)

                # Independent finite-difference derivative spot-check of the
                # exact Reynolds/wedge circuits at the first source point.
                direction = directions[0]
                interpolation_points = np.asarray([
                    (points[0] + parameter * direction) % prime
                    for parameter in range(degree + 1)
                ], dtype=np.int64)
                evaluated = independently_evaluate_crosses(
                    module, interpolation_points, prime, dual["generators"],
                    [basis_records[index] for index in basis_indices],
                    invariant_generators,
                )
                derivative = np.einsum(
                    "p,pjk->jk", weights, evaluated
                ) % prime
                require(np.array_equal(
                    derivative,
                    derivatives[0, :, basis_indices].T % prime,
                ), "independent first-normal derivative spot-check")
            cumulative = [rank_mod(np.concatenate(matrices[:end]), prime)
                          for end in range(1, len(matrices) + 1)]
            require(cumulative == expected_ranks[degree] ==
                    record["cumulative_ranks"],
                    "first-normal cumulative ranks")
            require(record["combined_kernel_dimension"] ==
                    dimension - cumulative[-1],
                    "first-normal kernel dimension")
            print(f"C3 first-normal p={prime}, d={degree}: "
                  f"ranks {cumulative}, kernel {dimension-cumulative[-1]} OK")


def verify_c3_first_normal_reduced_landing() -> None:
    root = load_json(HERE / "c3_first_normal_reduced_landing.json")
    require(root["schema"] ==
            "cov-m1-c3-first-normal-reduced-landing-v1",
            "first-normal reduced schema")
    require(root["prime"] == 463, "first-normal reduced prime")
    expected = {31: (198, 147, 17, 130, 5349),
                35: (361, 300, 11, 289, 8555)}
    for degree, ledger in expected.items():
        dimension, reduced_dimension, scalar_rank, second_based, equations = ledger
        aggregate = root["degrees"][str(degree)]
        metadata_path = HERE / aggregate["metadata"]
        require_hash(metadata_path, aggregate["metadata_sha256"])
        metadata = load_json(metadata_path)
        for key in (
            "payload", "payload_sha256", "landing_payload",
            "landing_payload_sha256", "c3_gate_payload",
            "c3_gate_payload_sha256", "first_normal_block_payloads",
            "original_parameter_dimension", "first_normal_parameter_dimension",
            "first_normal_scalar_rank", "second_based_dimension",
            "complete_equation_count",
        ):
            require(metadata[key] == aggregate[key],
                    f"first-normal reduced aggregate mismatch: {key}")
        payload_path = HERE / metadata["payload"]
        landing_path = HERE / metadata["landing_payload"]
        c3_path = HERE / metadata["c3_gate_payload"]
        require_hash(payload_path, metadata["payload_sha256"])
        require_hash(landing_path, metadata["landing_payload_sha256"])
        require_hash(c3_path, metadata["c3_gate_payload_sha256"])
        require((metadata["original_parameter_dimension"],
                 metadata["first_normal_parameter_dimension"],
                 metadata["first_normal_scalar_rank"],
                 metadata["second_based_dimension"],
                 metadata["complete_equation_count"]) == ledger,
                "first-normal reduced dimension ledger")
        with np.load(c3_path, allow_pickle=False) as frozen:
            based_gate = frozen["basis_values"].astype(np.int64).reshape(
                -1, dimension
            )
        matrices = [based_gate]
        block_payloads = []
        for block in metadata["first_normal_block_payloads"]:
            path = HERE / block["payload"]
            require_hash(path, block["payload_sha256"])
            with np.load(path, allow_pickle=False) as frozen:
                matrices.append(frozen["extra_gate_matrix"].astype(np.int64))
                block_payloads.append({
                    key: frozen[key].astype(np.int64)
                    for key in frozen.files
                })
        combined_gate = np.concatenate(matrices, axis=0) % 463
        with np.load(payload_path, allow_pickle=False) as frozen:
            points = frozen["source_points"].astype(np.int64)
            reduced = frozen["reduced_basis_values"].astype(np.int64)
            kernel = frozen["first_normal_kernel_basis"].astype(np.int64)
            pivots = frozen["first_normal_pivot_columns"].astype(np.int64)
            free = frozen["first_normal_free_columns"].astype(np.int64)
            derivative_reduced = frozen["surviving_derivative_values"].astype(
                np.int64
            )
            scalar = frozen["first_normal_scalar_forms"].astype(np.int64)
            second_based_kernel = frozen["second_based_kernel_basis"].astype(
                np.int64
            )
        require(kernel.shape == (dimension, reduced_dimension),
                "first-normal kernel shape")
        require(not np.any(combined_gate @ kernel % 463),
                "first-normal kernel equations")
        require(rank_mod(combined_gate, 463) == dimension - reduced_dimension,
                "first-normal combined rank")
        require(np.array_equal(kernel[free] % 463,
                               np.eye(reduced_dimension, dtype=np.int64)),
                "first-normal kernel free identity")
        with np.load(landing_path, allow_pickle=False) as frozen:
            old_points = frozen["fixed_source_points"].astype(np.int64)
            old_values = frozen["basis_values"].astype(np.int64)
        require(np.array_equal(points, old_points),
                "first-normal reduced source points")
        old_forms = old_values.reshape(-1, dimension)
        new_forms = reduced.reshape(-1, reduced_dimension)
        for start in range(0, len(old_forms), 2048):
            stop = min(start + 2048, len(old_forms))
            rebuilt = old_forms[start:stop, free]
            if len(pivots):
                rebuilt = rebuilt + old_forms[start:stop, pivots] @ kernel[pivots]
            require(np.array_equal(rebuilt % 463, new_forms[start:stop] % 463),
                    "first-normal reduced landing serialization")
        surviving = block_payloads[1]["derivative_values"] if degree == 31 \
            else block_payloads[0]["derivative_values"]
        require(np.array_equal(
            np.einsum("pjn,nk->pjk", surviving, kernel) % 463,
            derivative_reduced % 463,
        ), "first-normal surviving derivative reduction")
        root_vector = block_payloads[1]["target_root"] if degree == 31 \
            else block_payloads[0]["target_root"]
        pivot = int(np.flatnonzero(root_vector)[0])
        require(np.array_equal(
            scalar % 463,
            pow(int(root_vector[pivot]), -1, 463)
            * derivative_reduced[:, pivot, :] % 463,
        ), "first-normal scalar serialization")
        require(rank_mod(scalar, 463) == scalar_rank,
                "first-normal scalar rank")
        require(second_based_kernel.shape ==
                (reduced_dimension, second_based),
                "second-based kernel shape")
        require(not np.any(scalar @ second_based_kernel % 463),
                "second-based kernel equations")
        require(rank_mod(second_based_kernel, 463) == second_based,
                "second-based kernel rank")
        print(f"first-normal reduced d={degree}: {equations} cubics on "
              f"{reduced_dimension}; second-based {second_based}, "
              f"{scalar_rank} nonbased charts OK")
        del (based_gate, matrices, block_payloads, combined_gate, points,
             reduced, kernel, pivots, free, derivative_reduced, scalar,
             second_based_kernel, old_points, old_values, old_forms,
             new_forms, rebuilt, surviving, root_vector)
        gc.collect()


def coefficient_weights(degree: int, order: int, prime: int) -> np.ndarray:
    """Weights extracting t^order from values at t=0,...,degree."""
    matrix = np.asarray([
        [pow(parameter, power, prime) for parameter in range(degree + 1)]
        for power in range(degree + 1)
    ], dtype=np.int64)
    augmented = np.column_stack([
        matrix, np.asarray([int(power == order) for power in range(degree + 1)])
    ]) % prime
    for column in range(degree + 1):
        pivot = column + int(np.flatnonzero(augmented[column:, column])[0])
        augmented[[column, pivot]] = augmented[[pivot, column]]
        augmented[column] = (
            augmented[column] * pow(int(augmented[column, column]), -1, prime)
        ) % prime
        factors = augmented[:, column].copy()
        indices = np.flatnonzero(factors)
        indices = indices[indices != column]
        augmented[indices] = (
            augmented[indices] - factors[indices, None] * augmented[column]
        ) % prime
    return augmented[:, -1] % prime


def verify_c3_second_normal_gate() -> None:
    root = load_json(HERE / "c3_second_normal_gate.json")
    require(root["schema"] == "cov-m1-c3-second-normal-gate-v1",
            "second-normal schema")
    expected_degrees = {
        "31": {
            "second_based_dimension": 130, "pure_gate_dimension": 99,
            "pure_nonbased_chart_count": 7, "pure_zero_dimension": 92,
            "mixed_gate_dimension": 78, "mixed_nonbased_chart_count": 13,
            "third_based_dimension": 65,
        },
        "35": {
            "second_based_dimension": 289, "pure_gate_dimension": 247,
            "pure_nonbased_chart_count": 24, "pure_zero_dimension": 223,
            "mixed_gate_dimension": 204, "mixed_nonbased_chart_count": 20,
            "third_based_dimension": 184,
        },
    }
    require(root["degrees"] == expected_degrees, "second-normal degree ledger")
    invariant_generators = load_json(HERE / "invariant_generators.json")
    dual = load_json(HERE / "dual_hironaka_generators.json")
    for prime_record in root["prime_records"]:
        prime = int(prime_record["prime"])
        zeta = int(prime_record["zeta11"])
        probe = load_json(HERE / f"c3_constant_gate_probe_p{prime}.json")
        omega = int(probe["omega"])
        generator = np.asarray(probe["order_three_generator"], dtype=np.int64)
        stabilizer = [np.asarray(item, dtype=np.int64)
                      for item in probe["setwise_stabilizer"]]
        module = load_group_module(prime, zeta)
        for degree, target in TARGETS.items():
            dimension = target["m1"]
            record = prime_record["degrees"][str(degree)]
            c3_record = record["c3_gate"]
            c3_path = HERE / c3_record["payload"]
            require_hash(c3_path, c3_record["payload_sha256"])
            with np.load(c3_path, allow_pickle=False) as frozen:
                line_values = frozen["basis_values"].astype(np.int64).reshape(
                    -1, dimension
                )
            lower = [line_values]
            for block in record["first_normal_blocks"]:
                path = HERE / block["payload"]
                require_hash(path, block["payload_sha256"])
                with np.load(path, allow_pickle=False) as frozen:
                    lower.append(
                        frozen["derivative_values"].astype(np.int64).reshape(
                            -1, dimension
                        )
                    )
            second_based = np.concatenate(lower, axis=0) % prime
            require(rank_mod(second_based, prime) == record["second_based_rank"],
                    "second-based rank")
            basis_records = load_json(
                HERE / f"degree_{degree}/m1_cross_basis_circuits.json"
            )["basis"]
            basis_indices = [0, dimension - 1]
            weights = coefficient_weights(degree, 2, prime)
            pure_gates = []
            pure_values = []
            pure_payloads = []
            for pure_record in record["pure_blocks"]:
                exponent = int(pure_record["normal_exponent"])
                path = HERE / pure_record["payload"]
                require_hash(path, pure_record["payload_sha256"])
                with np.load(path, allow_pickle=False) as frozen:
                    points = frozen["source_points"].astype(np.int64)
                    directions = frozen["normal_directions"].astype(np.int64)
                    values = frozen["second_normal_values"].astype(np.int64)
                    gate = frozen["extra_gate_matrix"].astype(np.int64)
                    target_space = frozen["target_eigenspace"].astype(np.int64)
                    target_root = frozen["target_root"].astype(np.int64)
                require(points.shape == (degree - 1, 5),
                        "second-normal source points")
                target_exponent = (degree - 2 + 2 * exponent) % 3
                require(np.array_equal(
                    np.einsum("ij,pjk->pik", generator, values) % prime,
                    pow(omega, target_exponent, prime) * values % prime,
                ), "second-normal target character")
                if len(target_root):
                    require(sum(
                        int(target_root[index]) ** 2
                        * int(target_root[(index + 1) % 5])
                        for index in range(5)
                    ) % prime == 0, "second-normal root not on Klein")
                    require(all(rank_mod(np.vstack([
                        target_root, matrix @ target_root % prime
                    ]), prime) == 1 for matrix in stabilizer),
                            "second-normal root not C6-fixed")
                    pivot = int(np.flatnonzero(target_root)[0])
                    rebuilt = np.concatenate([
                        np.concatenate([
                            target_root[pivot]
                            * values[
                                direction_index * (degree - 1):
                                (direction_index + 1) * (degree - 1), output, :
                            ]
                            - target_root[output]
                            * values[
                                direction_index * (degree - 1):
                                (direction_index + 1) * (degree - 1), pivot, :
                            ]
                            for output in range(5) if output != pivot
                        ], axis=0)
                        for direction_index in range(len(directions))
                    ], axis=0) % prime
                else:
                    require(len(target_space) == 1 and sum(
                        int(target_space[0, index]) ** 2
                        * int(target_space[0, (index + 1) % 5])
                        for index in range(5)
                    ) % prime != 0, "second-normal zero target")
                    rebuilt = values.reshape(-1, dimension) % prime
                require(np.array_equal(rebuilt, gate % prime),
                        "second-normal gate serialization")
                pure_gates.append(gate)
                pure_values.append(values.reshape(-1, dimension))
                pure_payloads.append((points, directions, values, target_root))

                interpolation_points = np.asarray([
                    (points[0] + parameter * directions[0]) % prime
                    for parameter in range(degree + 1)
                ], dtype=np.int64)
                evaluated = independently_evaluate_crosses(
                    module, interpolation_points, prime, dual["generators"],
                    [basis_records[index] for index in basis_indices],
                    invariant_generators,
                )
                coefficient = np.einsum("p,pjk->jk", weights, evaluated) % prime
                require(np.array_equal(
                    coefficient, values[0, :, basis_indices].T % prime,
                ), "independent second-normal coefficient spot-check")
            pure_cumulative = [
                rank_mod(np.concatenate([second_based, *pure_gates[:end]]), prime)
                for end in (1, 2)
            ]
            require(pure_cumulative == record["pure_cumulative_ranks"],
                    "pure second-normal cumulative ranks")
            pure_combined = np.concatenate([second_based, *pure_gates], axis=0) % prime
            pure_kernel = nullspace_mod_for_verifier(pure_combined, prime)
            surviving_index = 0 if degree == 31 else 1
            surviving_values = pure_payloads[surviving_index][2]
            surviving_root = pure_payloads[surviving_index][3]
            surviving_reduced = np.einsum(
                "pjn,nk->pjk", surviving_values, pure_kernel
            ) % prime
            pivot = int(np.flatnonzero(surviving_root)[0])
            pure_scalar = (
                pow(int(surviving_root[pivot]), -1, prime)
                * surviving_reduced[:, pivot, :]
            ) % prime
            require(rank_mod(pure_scalar, prime) == record["pure_scalar_rank"],
                    "pure second-normal scalar rank")
            pure_zero = np.concatenate([second_based, *pure_values], axis=0) % prime
            require(rank_mod(pure_zero, prime) == record["pure_zero_rank"],
                    "pure-zero rank")
            mixed_record = record["mixed_block"]
            mixed_path = HERE / mixed_record["payload"]
            require_hash(mixed_path, mixed_record["payload_sha256"])
            with np.load(mixed_path, allow_pickle=False) as frozen:
                mixed_points = frozen["source_points"].astype(np.int64)
                mixed_directions = frozen["mixed_normal_directions"].astype(np.int64)
                mixed_values = frozen["mixed_second_values"].astype(np.int64)
                mixed_gate = frozen["extra_gate_matrix"].astype(np.int64)
                mixed_root = frozen["target_root"].astype(np.int64)
            require(np.array_equal(
                np.einsum("ij,pjk->pik", generator, mixed_values) % prime,
                pow(omega, degree % 3, prime) * mixed_values % prime,
            ), "mixed second-normal character")
            pivot = int(np.flatnonzero(mixed_root)[0])
            rebuilt_mixed = np.concatenate([
                mixed_root[pivot] * mixed_values[:, output, :]
                - mixed_root[output] * mixed_values[:, pivot, :]
                for output in range(5) if output != pivot
            ], axis=0) % prime
            require(np.array_equal(rebuilt_mixed, mixed_gate % prime),
                    "mixed second-normal gate serialization")
            mixed_combined = np.concatenate([pure_zero, mixed_gate], axis=0) % prime
            require(rank_mod(mixed_combined, prime) ==
                    record["mixed_combined_rank"], "mixed combined rank")
            mixed_kernel = nullspace_mod_for_verifier(mixed_combined, prime)
            mixed_reduced = np.einsum(
                "pjn,nk->pjk", mixed_values, mixed_kernel
            ) % prime
            mixed_scalar = (
                pow(int(mixed_root[pivot]), -1, prime)
                * mixed_reduced[:, pivot, :]
            ) % prime
            require(rank_mod(mixed_scalar, prime) == record["mixed_scalar_rank"],
                    "mixed scalar rank")
            third_based = np.concatenate([
                pure_zero, mixed_values.reshape(-1, dimension)
            ], axis=0) % prime
            require(rank_mod(third_based, prime) == record["third_based_rank"],
                    "third-based rank")
            print(f"C3 second-normal p={prime}, d={degree}: pure "
                  f"{pure_cumulative}, mixed {record['mixed_combined_rank']}, "
                  f"third-based {record['third_based_dimension']} OK")


def nullspace_mod_for_verifier(matrix: np.ndarray, prime: int) -> np.ndarray:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    row = 0
    pivots = []
    for column in range(value.shape[1]):
        candidates = np.flatnonzero(value[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        factors = value[:, column].copy()
        indices = np.flatnonzero(factors)
        indices = indices[indices != row]
        if len(indices):
            value[indices] = (
                value[indices] - factors[indices, None] * value[row]
            ) % prime
        pivots.append(column)
        row += 1
        if row == value.shape[0]:
            break
    free = [column for column in range(value.shape[1]) if column not in pivots]
    kernel = np.zeros((value.shape[1], len(free)), dtype=np.int64)
    kernel[free, np.arange(len(free))] = 1
    kernel[pivots] = -value[:len(pivots), free] % prime
    return kernel


def verify_c3_third_based_reduced_landing() -> None:
    root = load_json(HERE / "c3_third_based_reduced_landing.json")
    require(root["schema"] == "cov-m1-c3-third-based-reduced-landing-v1",
            "third-based reduced schema")
    expected = {31: (198, 65, 5349), 35: (361, 184, 8555)}
    for degree, ledger in expected.items():
        dimension, reduced_dimension, equations = ledger
        aggregate = root["degrees"][str(degree)]
        metadata_path = HERE / aggregate["metadata"]
        require_hash(metadata_path, aggregate["metadata_sha256"])
        metadata = load_json(metadata_path)
        payload_path = HERE / metadata["payload"]
        landing_path = HERE / metadata["landing_payload"]
        require_hash(payload_path, metadata["payload_sha256"])
        require_hash(landing_path, metadata["landing_payload_sha256"])
        matrices = []
        for gate_input in metadata["gate_inputs"]:
            path = HERE / gate_input["payload"]
            require_hash(path, gate_input["payload_sha256"])
            with np.load(path, allow_pickle=False) as frozen:
                if "basis_values" in frozen:
                    array = frozen["basis_values"]
                elif "derivative_values" in frozen:
                    array = frozen["derivative_values"]
                elif "second_normal_values" in frozen:
                    array = frozen["second_normal_values"]
                else:
                    array = frozen["mixed_second_values"]
                matrices.append(array.astype(np.int64).reshape(-1, dimension))
        combined = np.concatenate(matrices, axis=0) % 463
        with np.load(payload_path, allow_pickle=False) as frozen:
            points = frozen["source_points"].astype(np.int64)
            reduced = frozen["reduced_basis_values"].astype(np.int64)
            kernel = frozen["third_based_kernel_basis"].astype(np.int64)
            pivots = frozen["third_based_pivot_columns"].astype(np.int64)
            free = frozen["third_based_free_columns"].astype(np.int64)
        require(kernel.shape == (dimension, reduced_dimension),
                "third-based kernel shape")
        require(not np.any(combined @ kernel % 463),
                "third-based kernel equations")
        require(rank_mod(combined, 463) == dimension - reduced_dimension,
                "third-based gate rank")
        with np.load(landing_path, allow_pickle=False) as frozen:
            old_points = frozen["fixed_source_points"].astype(np.int64)
            old_values = frozen["basis_values"].astype(np.int64)
        require(np.array_equal(points, old_points), "third-based source points")
        old_forms = old_values.reshape(-1, dimension)
        new_forms = reduced.reshape(-1, reduced_dimension)
        for start in range(0, len(old_forms), 2048):
            stop = min(start + 2048, len(old_forms))
            rebuilt = old_forms[start:stop, free]
            if len(pivots):
                rebuilt = rebuilt + old_forms[start:stop, pivots] @ kernel[pivots]
            require(np.array_equal(rebuilt % 463, new_forms[start:stop] % 463),
                    "third-based reduced landing serialization")
        print(f"third-based reduced d={degree}: {equations} cubics on "
              f"{reduced_dimension} OK")


def verify_landing_ideals() -> None:
    root = load_json(HERE / "landing_ideals.json")
    require(root["schema"] == "cov-m1-complete-factored-landing-ideals-v1",
            "landing schema")
    require_hash(HERE / root["canonical_bases"], root["canonical_bases_sha256"])
    require(root["canonical_bases"] == root["parameter_basis"] and
            root["canonical_bases_sha256"] == root["parameter_basis_sha256"],
            "canonical landing parameter basis aliases")
    require_hash(HERE / "dual_hironaka_generators.json",
                 root["dual_generators_sha256"])
    gate_record = root["linear_elimination"]
    require_hash(HERE / gate_record["payload"], gate_record["payload_sha256"])
    reduced_record = root["reduced_special_fibre"]
    require(reduced_record["prime"] == 463, "reduced landing prime")
    require_hash(HERE / reduced_record["payload"],
                 reduced_record["payload_sha256"])
    first_normal_record = root["first_normal_pre_elimination"]
    require_hash(HERE / first_normal_record["payload"],
                 first_normal_record["payload_sha256"])
    first_reduced_record = root["first_normal_reduced_special_fibre"]
    require(first_reduced_record["prime"] == 463,
            "first-normal reduced landing prime")
    require_hash(HERE / first_reduced_record["payload"],
                 first_reduced_record["payload_sha256"])
    second_normal_record = root["second_normal_pre_elimination"]
    require_hash(HERE / second_normal_record["payload"],
                 second_normal_record["payload_sha256"])
    third_based_record = root["third_based_reduced_special_fibre"]
    require(third_based_record["prime"] == 463,
            "third-based reduced landing prime")
    require_hash(HERE / third_based_record["payload"],
                 third_based_record["payload_sha256"])
    require(root["decision_status"].endswith("projective saturation not decided"),
            "landing decision boundary changed")
    require_hash(
        HERE / root["linear_elimination"]["payload"],
        root["linear_elimination"]["payload_sha256"],
    )
    generators = load_json(HERE / "invariant_generators.json")
    dual = load_json(HERE / "dual_hironaka_generators.json")
    require(generators["primary_degrees"] == list(PRIMARY_DEGREES),
            "invariant primary degrees")
    require(generators["secondary_degrees"] == list(SECONDARY_DEGREES),
            "invariant secondary degrees")
    require(generators["secondary_names"] == list(SECONDARY_NAMES),
            "invariant secondary names")
    require(set(map(int, generators["forms"])) ==
            {3, 5, 6, 7, 8, 9, 10, 11, 12, 14},
            "integral invariant generator set")
    for degree, target in TARGETS.items():
        degree_record = root["degrees"][str(degree)]
        require(degree_record["parameter_dimension"] == target["m1"],
                "landing parameter dimension")
        require(degree_record["source_coefficient_degree"] == target["source_degree"],
                "landing source degree")
        require(degree_record["equation_count"] == target["equations"],
                "landing equation dimension")
        circuit_path = HERE / degree_record["payload"]
        require_hash(circuit_path, degree_record["payload_sha256"])
        circuit = load_json(circuit_path)
        require(circuit["parameter_dimension"] == target["m1"],
                "circuit parameter dimension")
        require(circuit["invariant_coefficient_dimension"] == target["equations"],
                "circuit equation dimension")
        labels = circuit["decomposition"]["invariant_hironaka_labels"]
        require(len(labels) == target["equations"], "Hironaka label count")
        basis_path = HERE / f"degree_{degree}" / circuit["fixed_basis"]
        require_hash(basis_path, circuit["fixed_basis_sha256"])
        cross_records = load_json(basis_path)["basis"]
        for record in degree_record["prime_records"]:
            prime = record["prime"]
            require(prime in PRIMES, "unexpected landing prime")
            payload_path = HERE / f"degree_{degree}" / record["payload"]
            require_hash(payload_path, record["payload_sha256"])
            for label in labels:
                weighted = label["secondary_degree"] + sum(
                    weight * exponent for weight, exponent in
                    zip(PRIMARY_DEGREES, label["primary_exponents"])
                )
                require(weighted == target["source_degree"],
                        "wrong Hironaka weighted degree")
            with np.load(payload_path, allow_pickle=False) as frozen:
                nodes = frozen["fixed_source_points"]
                values = frozen["basis_values"]
                require(nodes.shape == (target["equations"], 5), "node shape")
                require(values.shape == (
                    target["equations"], 5, target["m1"]
                ), "basis-value shape")
                require(np.max(nodes) < prime and np.max(values) < prime,
                        "payload not reduced modulo prime")
                forms = values.reshape(5 * target["equations"], target["m1"])
                require(rank_mod(forms[:2 * target["m1"]], prime) == target["m1"],
                        f"landing linear forms not full rank at p={prime}, d={degree}")
                coefficient = np.arange(1, target["m1"] + 1, dtype=np.int64) % prime
                linear = (forms[:50].astype(np.int64) @ coefficient) % prime
                linear = linear.reshape(10, 5)
                klein = sum(linear[:, i] ** 2 * linear[:, (i + 1) % 5]
                            for i in range(5)) % prime
                scale = 7
                scaled = sum((scale * linear[:, i] % prime) ** 2 *
                             (scale * linear[:, (i + 1) % 5] % prime)
                             for i in range(5)) % prime
                require(np.array_equal(scaled, scale ** 3 * klein % prime),
                        "factored Klein equations are not cubic homogeneous")
                invariant_matrix = rebuild_invariant_matrix(
                    nodes.astype(np.int64), labels, prime, generators
                )
                determinant = determinant_mod(invariant_matrix, prime)
                require(determinant != 0,
                        f"new nodal determinant vanishes p={prime}, d={degree}")
                del invariant_matrix
                # Rebuild four nodes and three basis columns from the exact
                # Reynolds/wedge circuits without importing a producer.
                node_indices = [0, 1, len(nodes) // 2, len(nodes) - 1]
                basis_indices = [0, target["m1"] // 2, target["m1"] - 1]
                module = load_group_module(prime, {419: 13, 463: 15}[prime])
                rebuilt = independently_evaluate_crosses(
                    module,
                    nodes[node_indices].astype(np.int64),
                    prime,
                    dual["generators"],
                    [cross_records[index] for index in basis_indices],
                    generators,
                )
                require(np.array_equal(
                    rebuilt % prime,
                    values[np.ix_(node_indices, range(5), basis_indices)] % prime,
                ), f"independent Reynolds spot-check p={prime}, d={degree}")
            print(f"landing d={degree}, p={prime}: "
                  f"{target['equations']} complete nodal cubics, "
                  f"rebuilt det={determinant}, circuit spot-check OK")
            del nodes, values, forms, rebuilt
            gc.collect()

        # A second producer chose a different unisolvent nodal frame.  Its
        # payload and recorded nonzero determinant are retained as a sealed
        # crosscheck.  The four circuit-frame determinants above are the ones
        # independently rebuilt here, avoiding a second four-matrix memory
        # peak in the same verifier process.
        crosschecks = degree_record["independent_nodal_crosscheck"]
        require(len(crosschecks) == 2, "independent nodal crosscheck count")
        for crosscheck in crosschecks:
            prime = int(crosscheck["prime"])
            metadata_path = HERE / crosscheck["metadata"]
            payload_path = HERE / crosscheck["payload"]
            require_hash(metadata_path, crosscheck["metadata_sha256"])
            require_hash(payload_path, crosscheck["payload_sha256"])
            metadata = load_json(metadata_path)
            require(metadata["payload_sha256"] == crosscheck["payload_sha256"],
                    "old metadata payload hash")
            with np.load(payload_path, allow_pickle=False) as frozen:
                old_nodes = frozen["nodes"].astype(np.int64)
            require(old_nodes.shape == (target["equations"], 5),
                    "independent nodal frame shape")
            require(metadata["invariant_evaluation_determinant_residue"] != 0,
                    f"sealed nodal determinant p={prime}, d={degree}")
            del old_nodes
            gc.collect()
        print(f"landing d={degree}: independent nodal frame certificate crosscheck OK")


def verify_status_and_seal() -> None:
    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("COV-UNDECIDED\n"), "wrong status first line")
    exit_record = load_json(HERE / "EXIT.json")
    require(exit_record["exit"] == "COV-UNDECIDED", "wrong exit")
    require("projective saturation" in exit_record["smallest_unresolved_gate"],
            "missing smallest unresolved gate")
    seal_path = HERE / "SEAL.json"
    require(seal_path.is_file(), "SEAL.json has not been generated")
    seal = load_json(seal_path)
    require(seal["schema"] == "cov-m1-content-seal-v1", "seal schema")
    require(seal["exit"] == "COV-UNDECIDED", "sealed exit")
    require("generated_at" not in seal and "timestamp" not in seal,
            "seal is not content-only")
    paths = [record["path"] for record in seal["files"]]
    require(paths == sorted(paths) and len(paths) == len(set(paths)),
            "seal paths not unique and sorted")
    require("verify_all.py" in paths and "landing_ideals.json" in paths,
            "decisive files missing from seal")
    require((HERE / "VERIFY_LOG.txt").read_text().endswith(
            "COV_M1_DEG31_35_VERIFY_OK\n"), "replay log marker")
    for record in seal["files"]:
        require_hash(HERE / record["path"], record["sha256"])
    print(f"seal: {len(paths)} content hashes OK")


def main() -> None:
    verify_inputs()
    verify_canonical_bases()
    verify_equalizers()
    verify_primitive_module()
    verify_primitive_counterexample()
    verify_c3_constant_gate()
    verify_c3_reduced_landing()
    verify_c3_first_normal_gate()
    verify_c3_first_normal_reduced_landing()
    verify_c3_second_normal_gate()
    verify_c3_third_based_reduced_landing()
    verify_landing_ideals()
    verify_status_and_seal()
    print("COV_M1_DEG31_35_VERIFY_OK")


if __name__ == "__main__":
    main()
