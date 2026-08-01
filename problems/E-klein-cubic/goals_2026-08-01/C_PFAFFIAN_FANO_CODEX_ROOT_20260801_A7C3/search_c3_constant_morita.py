#!/usr/bin/env python3
"""Search the constant-coordinate chart of the exact C2 Morita model.

This is a discovery calculation over F_23.  A positive vector must still be
lifted and globally verified; an empty result excludes only this 12-constant
ansatz, not the genuine common-line scheme over K_proj.
"""

from __future__ import annotations

import argparse
import json
import runpy
import subprocess
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P = 23
ZETA = 2


def inv(matrix):
    n = matrix.shape[0]
    work = np.concatenate([matrix.copy() % P, np.eye(n, dtype=np.int64)], axis=1)
    for column in range(n):
        options = np.flatnonzero(work[column:, column])
        if not len(options):
            raise ValueError("singular")
        pivot = column + int(options[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = work[column] * pow(int(work[column, column]), -1, P) % P
        for row in range(n):
            if row != column and work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % P
    return work[:, n:]


def rank(entries):
    if not entries:
        return 0
    work = np.stack([entry.reshape(-1) for entry in entries], axis=1) % P
    row = 0
    for column in range(work.shape[1]):
        options = np.flatnonzero(work[row:, column])
        if not len(options):
            continue
        pivot = row + int(options[0])
        work[[row, pivot]] = work[[pivot, row]]
        work[row] = work[row] * pow(int(work[row, column]), -1, P) % P
        for other in range(work.shape[0]):
            if other != row and work[other, column]:
                work[other] = (work[other] - work[other, column] * work[row]) % P
        row += 1
        if row == work.shape[0]:
            break
    return row


def add_echelon(echelon, raw):
    row = np.array(raw, dtype=np.int64) % P
    for pivot, basis in echelon:
        if row[pivot]:
            row = (row - row[pivot] * basis) % P
    nonzero = np.flatnonzero(row)
    if not len(nonzero):
        return False
    pivot = int(nonzero[0])
    row = row * pow(int(row[pivot]), -1, P) % P
    for index, (other_pivot, basis) in enumerate(echelon):
        if basis[pivot]:
            echelon[index] = (other_pivot, (basis - basis[pivot] * row) % P)
    echelon.append((pivot, row))
    echelon.sort(key=lambda entry: entry[0])
    return True


def skew(values, pairs):
    result = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(values, pairs):
        result[left, right] = int(value) % P
        result[right, left] = -int(value) % P
    return result


class AlgebraFrameEvaluator:
    def __init__(self, c2):
        weil_s, weil_t = c2["weil_generators"](P, ZETA)
        schur_a, schur_b = c2["schur_generators"](P, ZETA)
        image_a = weil_t @ weil_s @ weil_t @ weil_s % P
        image_b = c2["power"](weil_t, 8, P) @ weil_s % P
        identity5 = np.eye(5, dtype=np.int64) % P
        identity6 = np.eye(6, dtype=np.int64) % P
        seen = {c2["key"](identity5, P): (identity5, identity6)}
        queue = list(seen.values())
        while queue:
            target, source = queue.pop()
            for target_generator, source_generator in (
                (image_a, schur_a), (image_b, schur_b)
            ):
                new_target = target @ target_generator % P
                new_source = source @ source_generator % P
                key = c2["key"](new_target, P)
                if key not in seen:
                    seen[key] = (new_target, new_source)
                    queue.append((new_target, new_source))
        assert len(seen) == 660
        certificate = json.loads(
            (ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json").read_text()
        )
        self.seeds = certificate["end36_reynolds_frame"]["selected_reynolds_seeds"]
        group = list(seen.values())
        self.conjugation = np.zeros((660, 36, 36), dtype=np.int64)
        self.inverse_targets = np.zeros((660, 5, 5), dtype=np.int64)
        for group_index, (target, source) in enumerate(group):
            source_inverse = inv(source)
            self.inverse_targets[group_index] = inv(target)
            for row in range(6):
                for column in range(6):
                    self.conjugation[group_index, :, 6 * row + column] = np.outer(
                        source[:, row], source_inverse[column, :]
                    ).reshape(-1) % P
        kproj = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))
        self.forms = kproj["forms"]()
        self.evaluate_mod = kproj["evaluate_mod"]

    def evaluate(self, point_tuple):
        point = np.array(point_tuple, dtype=np.int64) % P
        orbit = np.einsum("gij,j->gi", self.inverse_targets, point) % P
        powers = np.ones((660, 5, 9), dtype=np.int64)
        for exponent in range(1, 9):
            powers[:, :, exponent] = powers[:, :, exponent - 1] * orbit % P
        denominator = int(self.evaluate_mod(self.forms[14], tuple(map(int, point)), P))
        if not denominator:
            raise ValueError("frame denominator vanishes")
        answer = []
        for seed in self.seeds:
            weights = np.ones(660, dtype=np.int64)
            for variable, exponent in enumerate(seed["monomial_exponents"]):
                if exponent:
                    weights = weights * powers[:, variable, exponent] % P
            row, column = seed["matrix_unit_zero_based"]
            accumulated = np.tensordot(
                weights, self.conjugation[:, :, 6 * row + column], axes=(0, 0)
            ) % P
            multiplier = int(
                self.evaluate_mod(
                    self.forms[14 - seed["degree"]], tuple(map(int, point)), P
                )
            )
            answer.append(
                (accumulated * multiplier * pow(denominator, -1, P) % P).reshape(6, 6)
            )
        if rank(answer) != 36:
            raise ValueError("Reynolds frame is singular at this point")
        return answer


def coefficient_pairs(dimension=12):
    return [(left, right) for left in range(dimension) for right in range(left, dimension)]


def quadratic_matrix_rows(module_basis, sigma, section):
    pairs = coefficient_pairs(len(module_basis))
    coefficient_matrices = []
    for left, right in pairs:
        if left == right:
            value = sigma(module_basis[left]) @ section @ module_basis[right] % P
        else:
            value = (
                sigma(module_basis[left]) @ section @ module_basis[right]
                + sigma(module_basis[right]) @ section @ module_basis[left]
            ) % P
        coefficient_matrices.append(value)
    matrix = np.stack([entry.reshape(-1) for entry in coefficient_matrices], axis=1) % P
    return [matrix[row] for row in range(36)]


def polynomial(row, pairs):
    terms = []
    for coefficient, (left, right) in zip(row, pairs):
        coefficient = int(coefficient) % P
        if not coefficient:
            continue
        variable = f"z{left}^2" if left == right else f"z{left}*z{right}"
        terms.append(variable if coefficient == 1 else f"{coefficient}*{variable}")
    assert terms
    return "+".join(terms)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--function-count",
        type=int,
        choices=(1, 2, 3, 4, 5),
        default=1,
        help="use 1 and the first function-count-1 low-height invariant ratios",
    )
    parser.add_argument("--stagnant", type=int, default=15)
    args = parser.parse_args()
    c2_payload = json.loads((HERE / "c2_morita.json").read_text())
    root_vector = json.loads((HERE / "ambient_degree12_points_p23.json").read_text())["checks"][0]["coefficient_vector"]
    fw = runpy.run_path(
        str(ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "full_wedge.py")
    )
    scanner = fw["FullWedgeScanner"]()
    ambient_seeds = [
        (int(output), tuple(exponents))
        for output, exponents in json.loads((HERE / "ambient_degree12_a47_chart.json").read_text())["seeds"]
    ]
    fano = fw["fano"]
    six = fano["six_dimensional_generators"]()
    dual = tuple(fano["inv"](generator).T % P for generator in six)
    dual_wedge = tuple(fano["exterior_square"](generator) for generator in dual)
    domain_basis, _ = fano["invariant_summands"](dual_wedge)
    pairs6 = tuple(fano["PAIR_INDEX"])

    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    algebra_evaluator = AlgebraFrameEvaluator(c2)
    kproj = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))
    invariant_forms = kproj["forms"]()
    evaluate_invariant = kproj["evaluate_mod"]
    phi = runpy.run_path(str(ROOT / "tmp" / "generic_twist" / "phi_coefficients.py"))
    names, hilbert_frame, _ = phi["all_coefficients"]()
    assert list(names) == ["x", "C", "D", "E", "K"]

    corner_labels = c2_payload["corner"]["basis_circuits"]
    generator_labels = c2_payload["morita"]["basis_generator_circuits"]
    rng = np.random.default_rng(20260801)
    points = [(1, 2, 3, 4, 5)] + [
        tuple(int(value) for value in rng.integers(0, P, size=5)) for _ in range(1200)
    ]
    echelon = []
    used_points = []
    stagnant = 0
    for point_tuple in points:
        point = np.array(point_tuple, dtype=np.int64) % P
        ambient_values = np.stack(
            [scanner.evaluate_seed(output, exponents, point) for output, exponents in ambient_seeds]
        )
        wedge = np.array(root_vector, dtype=np.int64) @ ambient_values % P
        q_values = domain_basis @ point % P
        q = skew(q_values, pairs6)
        try:
            qinv = inv(q)
        except ValueError:
            continue
        pairing = int(np.dot(q_values, wedge) % P)
        if not pairing:
            continue
        e = -skew(wedge, pairs6) @ q * pow(pairing, -1, P) % P
        if not np.array_equal(e @ e % P, e):
            continue
        try:
            matrices = algebra_evaluator.evaluate(point_tuple)
        except ValueError:
            continue
        corner = []
        for label in corner_labels:
            corner.append(e if label["kind"] == "projector" else e @ matrices[label["frame_index"]] @ e % P)
        if rank(corner) != 4:
            continue
        identity = np.eye(6, dtype=np.int64) % P
        generators = [
            identity if label["kind"] == "identity" else matrices[label["frame_index"]]
            for label in generator_labels
        ]
        bare_module_basis = [generator @ e @ d % P for generator in generators for d in corner]
        if rank(bare_module_basis) != 12:
            continue
        f = {
            degree: int(evaluate_invariant(invariant_forms[degree], point_tuple, P))
            for degree in (3, 5, 6, 8, 11)
        }
        try:
            scalar_functions = [
                1,
                f[6] * pow(f[3], -2, P),
                f[3] * f[8] * pow(f[11], -1, P),
                f[5] * f[6] * pow(f[11], -1, P),
                f[3] * f[5] * pow(f[8], -1, P),
            ][: args.function_count]
        except ValueError:
            continue
        scalar_functions = [value % P for value in scalar_functions]
        module_basis = [
            scalar * value % P
            for scalar in scalar_functions
            for value in bare_module_basis
        ]
        sigma = lambda matrix: qinv @ matrix.T @ q % P
        old_rank = len(echelon)
        for vector in hilbert_frame:
            value = np.array(
                [int(phi["evaluate"](component, point_tuple)) % P for component in vector],
                dtype=np.int64,
            )
            section = qinv @ skew(domain_basis @ value % P, pairs6) % P
            assert np.array_equal(sigma(section), section)
            for row in quadratic_matrix_rows(module_basis, sigma, section):
                add_echelon(echelon, row)
        used_points.append(point_tuple)
        stagnant = stagnant + 1 if len(echelon) == old_rank else 0
        print(f"point={len(used_points):02d} quadraticRank={len(echelon)} stagnant={stagnant}", flush=True)
        variable_count = 12 * args.function_count
        monomial_count = variable_count * (variable_count + 1) // 2
        if len(echelon) == monomial_count or stagnant >= args.stagnant:
            break
    assert used_points and len(echelon) > 0
    rows = [row for _pivot, row in echelon]
    variable_count = 12 * args.function_count
    pairs12 = coefficient_pairs(variable_count)
    suffix = "constant" if args.function_count == 1 else f"invariant_m{args.function_count}"
    source = HERE / f"c3_{suffix}_morita_p23.in"
    source.write_text(
        ",".join(f"z{index}" for index in range(variable_count))
        + f"\n{P}\n"
        + ",\n".join(polynomial(row, pairs12) for row in rows)
        + "\n"
    )
    answer = HERE / f"c3_{suffix}_morita_p23.leading"
    command = [
        "msolve", "-f", str(source), "-o", str(answer), "-t", "4", "-v", "1",
        "-g", "1", "-l", "2", "--random-seed", "0",
    ]
    completed = subprocess.run(command, cwd=HERE, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False)
    print(completed.stdout, end="")
    assert completed.returncode == 0 and answer.is_file()
    leading = answer.read_text()
    result = {
        "format": "c3-invariant-morita-search-p23-v1",
        "scope": "coordinates in the selected finite span of low-height projective invariant ratios",
        "prime": P,
        "zeta11": ZETA,
        "points_used": [list(point) for point in used_points],
        "scalar_function_count": args.function_count,
        "scalar_functions": ["1", "f6/f3^2", "f3*f8/f11", "f5*f6/f11", "f3*f5/f8"][: args.function_count],
        "quadratic_variable_count": variable_count,
        "quadratic_monomial_count": len(pairs12),
        "quadratic_row_rank": len(rows),
        "leading_output": answer.name,
        "solver_stdout": completed.stdout,
        "theorem_boundary": "positive residues require lifting and global checking; emptiness excludes only this ansatz",
    }
    output = HERE / f"c3_{suffix}_morita_p23.json"
    output.write_text(json.dumps(result, indent=2) + "\n")
    print(f"WROTE {output}")
    print("C3-CONSTANT-MORITA-MODULAR-SEARCH-COMPLETED")


if __name__ == "__main__":
    main()
