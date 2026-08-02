#!/usr/bin/env python3
"""Independent replay of the generic normalized Morita trace DAG.

The replay reconstructs the accepted p=23 fibre from upstream sources, checks
all 225 denominator-minimal trace coefficients against the independently
rebuilt quaternion multiplication/Hermitian tables, and certifies that the
split 4+4 determinantal trick does not descend in the installed corner basis.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import runpy
from pathlib import Path

import numpy as np


P = 23
ZETA = 2
POINT = (1, 2, 3, 4, 5)
HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
A7 = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
CROOT = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT"

SOURCES = {
    "c2_morita": A7 / "c2_morita.json",
    "char0_rur": A7 / "ambient_degree12_rur_char0.json",
    "global_pluecker": A7 / "ambient_degree12_global_exact.json",
    "rur_seed_frame": A7 / "ambient_degree12_a47_chart.json",
    "compressed_algebra": CROOT / "compressed_algebra.json",
    "involution": CROOT / "involution.json",
    "distinguished_five_plane": CROOT / "distinguished_five_plane.json",
    "alignment_core": ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py",
    "alignment_certificate": ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json",
    "hilbert90_frame": ROOT / "tmp" / "generic_twist" / "phi_coefficients.py",
    "projective_reynolds_api": ROOT / "certificates" / "fano_c2" / "produce_c2.py",
    "index_two_certificate": ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "certificate.json",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inv_mod(matrix: np.ndarray) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % P
    size = matrix.shape[0]
    work = np.concatenate((matrix.copy(), np.eye(size, dtype=np.int64)), axis=1)
    for column in range(size):
        candidates = np.flatnonzero(work[column:, column])
        assert len(candidates)
        pivot = column + int(candidates[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = work[column] * pow(int(work[column, column]), -1, P) % P
        for row in range(size):
            if row != column and work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % P
    return work[:, size:] % P


def det_mod(matrix: np.ndarray) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % P
    determinant = 1
    for column in range(work.shape[0]):
        candidates = np.flatnonzero(work[column:, column])
        if not len(candidates):
            return 0
        pivot = column + int(candidates[0])
        if pivot != column:
            work[[column, pivot]] = work[[pivot, column]]
            determinant = -determinant
        value = int(work[column, column]) % P
        determinant = determinant * value % P
        work[column] = work[column] * pow(value, -1, P) % P
        for row in range(column + 1, work.shape[0]):
            if work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % P
    return determinant % P


def pfaffian_mod(matrix: np.ndarray) -> int:
    """Recursive Pfaffian, used only on the independently rebuilt 6 by 6 Q."""

    matrix = np.asarray(matrix, dtype=np.int64) % P
    size = matrix.shape[0]
    assert matrix.shape == (size, size) and size % 2 == 0
    if size == 0:
        return 1
    answer = 0
    for column in range(1, size):
        keep = [index for index in range(1, size) if index != column]
        sign = 1 if column % 2 else -1
        answer += sign * int(matrix[0, column]) * pfaffian_mod(matrix[np.ix_(keep, keep)])
    return answer % P


def skew(values, pairs) -> np.ndarray:
    answer = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(values, pairs):
        answer[left, right] = int(value) % P
        answer[right, left] = -int(value) % P
    return answer % P


def corner_multiply(table, left, right) -> np.ndarray:
    answer = np.zeros(4, dtype=np.int64)
    for left_index, left_coefficient in enumerate(left):
        for right_index, right_coefficient in enumerate(right):
            if left_coefficient and right_coefficient:
                answer += (
                    int(left_coefficient)
                    * int(right_coefficient)
                    * np.asarray(table[left_index][right_index], dtype=np.int64)
                )
    return answer % P


def table_forms(c2):
    witness = c2["good_fibre_witness"]
    table = witness["corner_multiplication_left_right_coordinates"]
    star = np.asarray(witness["corner_star_matrix_columns"], dtype=np.int64) % P
    hermitian = witness["hermitian_matrices_D_coordinates"]
    units = [np.eye(4, dtype=np.int64)[index] for index in range(4)]
    pairs = [(left, right) for left in range(12) for right in range(left, 12)]
    forms = []
    for matrix in hermitian:
        coefficients = []
        for left, right in pairs:
            left_row, left_basis = divmod(left, 4)
            right_row, right_basis = divmod(right, 4)

            def ordered(row, basis, column, other_basis):
                first = corner_multiply(
                    table, star @ units[basis] % P, matrix[row][column]
                )
                return corner_multiply(table, first, units[other_basis])

            value = ordered(left_row, left_basis, right_row, right_basis)
            if left != right:
                value = (
                    value + ordered(right_row, right_basis, left_row, left_basis)
                ) % P
            assert not np.any(value[1:])
            coefficients.append(int(value[0]))
        forms.append(coefficients)
    return pairs, forms


def independently_expected_descriptors():
    all_variables = list(range(12))
    labels = {
        index: {"morita_row": index // 4, "corner_basis": index % 4}
        for index in all_variables
    }

    def ordered_term(form, left, right):
        return {
            "scalar": -1,
            "denominator": "2*s^3",
            "operation": "matrix_trace_of_ordered_product",
            "factors": [
                "P",
                f"transpose(M[{left['corner_basis']}])",
                "Q",
                "P",
                f"transpose(G[{left['morita_row']}])",
                f"B[{form}]",
                f"G[{right['morita_row']}]",
                "P",
                "Q",
                f"M[{right['corner_basis']}]",
            ],
            "left": left,
            "right": right,
        }

    def homogeneous_record(form, monomial):
        left, right = (labels[index] for index in monomial)
        terms = [ordered_term(form, left, right)]
        if monomial[0] != monomial[1]:
            terms.append(ordered_term(form, right, left))
        return {"monomial": monomial, "ordered_trace_terms": terms}

    def chart_record(form, monomial, base):
        if not monomial:
            pairs = [(base, base)]
        elif len(monomial) == 1:
            value = labels[monomial[0]]
            pairs = [(base, value), (value, base)]
        else:
            left, right = (labels[index] for index in monomial)
            pairs = [(left, right)]
            if monomial[0] != monomial[1]:
                pairs.append((right, left))
        return {
            "monomial": monomial,
            "ordered_trace_terms": [
                ordered_term(form, left, right) for left, right in pairs
            ],
        }

    homogeneous = [
        [left, right]
        for left in all_variables
        for right in all_variables
        if left <= right
    ]
    names = ["x", "C", "D", "E", "K"]
    homogeneous_forms = [
        {
            "index": form,
            "name": name,
            "coefficients": [
                homogeneous_record(form, monomial) for monomial in homogeneous
            ],
        }
        for form, name in enumerate(names)
    ]
    chart_descriptors = []
    normalized_charts = []
    for pivot_row in range(3):
        pivot = 4 * pivot_row
        variables = [index for index in all_variables if index // 4 != pivot_row]
        monomials = [[]] + [[index] for index in variables]
        monomials += [
            [left, right]
            for left in variables
            for right in variables
            if left <= right
        ]
        chart_descriptors.append((pivot_row, variables, monomials))
        normalized_charts.append(
            {
                "pivot_row": pivot_row,
                "normalization": f"q_{pivot_row}=1_D=d_0=e",
                "fixed_homogeneous_coordinates": {
                    f"u{pivot + offset}": 1 if offset == 0 else 0
                    for offset in range(4)
                },
                "variables": [f"u{index}" for index in variables],
                "forms": [
                    {
                        "index": form,
                        "name": name,
                        "coefficients": [
                            chart_record(form, monomial, labels[pivot])
                            for monomial in monomials
                        ],
                    }
                    for form, name in enumerate(names)
                ],
            }
        )
    return (
        labels,
        homogeneous,
        homogeneous_forms,
        chart_descriptors,
        normalized_charts,
    )


def independently_expected_denominator_ledger():
    return {
        "explicit_trace_denominator": "2*s^3",
        "frame_denominator": "each nonidentity M or G uses the installed f_(14-d)/f14 normalization",
        "uniform_frame_bound": "f14^4 clears every product of the four possible nonidentity frame factors",
        "constant_denominators": "the rational Q(zeta11)-coefficients sealed in the RUR and Reynolds circuits",
        "required_opens": [
            "2!=0",
            "Pf(Q)!=0",
            "s!=0",
            "f14!=0",
            "the selected 4-column corner minor is nonzero",
            "the selected 12-column Morita-module minor is nonzero",
        ],
        "good_fibre_open_witnesses": {
            "prime": 23,
            "zeta11": 2,
            "source_point": [1, 2, 3, 4, 5],
            "rur_root": 1,
            "pfaffian_Q_mod_23": 17,
            "s_mod_23": 3,
            "f14_mod_23": 17,
            "corner_minor": {
                "flattening": "row-major 6x6 matrices as columns",
                "rows": [0, 1, 6, 7],
                "columns": [0, 1, 2, 3],
                "determinant_mod_23": 16,
            },
            "morita_module_minor": {
                "flattening": "row-major 6x6 matrices as columns",
                "basis_order": "G_r*e*d_alpha, lexicographic (r,alpha)",
                "rows": [0, 1, 6, 7, 12, 13, 18, 19, 24, 25, 31, 30],
                "columns": list(range(12)),
                "determinant_mod_23": 19,
            },
        },
    }


def main() -> None:
    dag = json.loads((HERE / "morita_generic_dag.json").read_text())
    assert dag["format"] == "c5-generic-normalized-morita-dag-v1"
    assert dag["source_sha256"] == {name: sha256(path) for name, path in SOURCES.items()}
    assert dag["inventory"] == {
        "form_count": 5,
        "homogeneous_coefficients_per_form": 78,
        "homogeneous_total_coefficients": 390,
        "normalized_chart_count": 3,
        "normalized_coefficients_per_form": 45,
        "normalized_coefficients_per_chart": 225,
        "normalized_total_coefficient_records": 675,
        "constant_coefficients": 5,
        "linear_coefficients": 40,
        "quadratic_coefficients": 180,
        "discarded_algebra_coordinates": 0,
    }

    (
        labels,
        homogeneous_monomials,
        expected_homogeneous_forms,
        chart_descriptors,
        expected_normalized_charts,
    ) = independently_expected_descriptors()
    assert dag["homogeneous_model"]["variable_semantics"] == {
        f"u{index}": labels[index] for index in range(12)
    }
    homogeneous_forms = dag["homogeneous_model"]["forms"]
    assert homogeneous_forms == expected_homogeneous_forms
    assert dag["normalized_charts"] == expected_normalized_charts
    assert dag["denominator_ledger"] == independently_expected_denominator_ledger()

    c2 = json.loads(SOURCES["c2_morita"].read_text())
    witness = c2["good_fibre_witness"]
    assert (witness["prime"], witness["zeta11"], tuple(witness["point"])) == (
        P,
        ZETA,
        POINT,
    )

    # Rebuild Q(x), P, the normalized projective frame, and B_i=Q(V_i).
    fw = runpy.run_path(
        str(ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "full_wedge.py")
    )
    fano = fw["fano"]
    six = fano["six_dimensional_generators"]()
    dual = tuple(fano["inv"](generator).T % P for generator in six)
    dual_wedge = tuple(fano["exterior_square"](generator) for generator in dual)
    domain_basis, _ = fano["invariant_summands"](dual_wedge)
    pairs = tuple(fano["PAIR_INDEX"])
    q_values = domain_basis @ np.asarray(POINT, dtype=np.int64) % P
    Q = skew(q_values, pairs)
    P_matrix = skew(np.asarray(witness["bivector"], dtype=np.int64), pairs)
    s = int(np.dot(q_values, np.asarray(witness["bivector"], dtype=np.int64)) % P)
    assert s == witness["pairing"] == 3
    e = -P_matrix @ Q * pow(s, -1, P) % P
    assert np.array_equal(e, np.asarray(witness["corner_basis_values"][0], dtype=np.int64) % P)

    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    frame = c3["load_c2_helpers"]()["build_projective_reynolds_frame"](P, ZETA)
    matrices = [value % P for value in frame["basis_mats"]]
    identity = np.eye(6, dtype=np.int64) % P
    M = [identity, matrices[1], matrices[2], matrices[3]]
    G = [identity, matrices[1], matrices[2]]

    open_witnesses = dag["denominator_ledger"]["good_fibre_open_witnesses"]
    assert pfaffian_mod(Q) == open_witnesses["pfaffian_Q_mod_23"] == 17
    assert s == open_witnesses["s_mod_23"] == 3
    assert frame["denominator"] == open_witnesses["f14_mod_23"] == 17

    d = [e @ value @ e % P for value in M]
    corner_minor = open_witnesses["corner_minor"]
    corner_flattening = np.stack([value.reshape(-1) for value in d], axis=1) % P
    assert corner_minor["columns"] == list(range(4))
    assert (
        det_mod(corner_flattening[corner_minor["rows"]][:, corner_minor["columns"]])
        == corner_minor["determinant_mod_23"]
        == 16
    )
    module_basis = [generator @ e @ value % P for generator in G for value in d]
    module_minor = open_witnesses["morita_module_minor"]
    module_flattening = np.stack(
        [value.reshape(-1) for value in module_basis], axis=1
    ) % P
    assert module_minor["columns"] == list(range(12))
    assert (
        det_mod(module_flattening[module_minor["rows"]][:, module_minor["columns"]])
        == module_minor["determinant_mod_23"]
        == 19
    )

    phi = runpy.run_path(str(ROOT / "tmp" / "generic_twist" / "phi_coefficients.py"))
    names, hilbert90, _ = phi["all_coefficients"]()
    assert list(names) == [form["name"] for form in homogeneous_forms]
    B = []
    for vector in hilbert90:
        values = np.asarray(
            [int(phi["evaluate"](component, POINT)) % P for component in vector],
            dtype=np.int64,
        )
        B.append(skew(domain_basis @ values % P, pairs))

    Q_inverse = inv_mod(Q)

    def star(value):
        return Q_inverse @ value.T @ Q % P

    S = [Q_inverse @ value % P for value in B]
    def ordered_original_matrix(form, left, right):
        row, alpha = left["morita_row"], left["corner_basis"]
        column, beta = right["morita_row"], right["corner_basis"]
        value = (
            star(d[alpha])
            @ e
            @ star(G[row])
            @ S[form]
            @ G[column]
            @ e
            @ d[beta]
        ) % P
        return value

    def symmetrized_original(form, vectors):
        value = sum(
            (ordered_original_matrix(form, *pair) for pair in vectors),
            np.zeros((6, 6), dtype=np.int64),
        ) % P
        scalar = int(np.trace(value) % P) * pow(2, -1, P) % P
        assert np.array_equal(value, scalar * e % P)
        return scalar

    def ordered_reduced(form, left, right):
        row, alpha = left["morita_row"], left["corner_basis"]
        column, beta = right["morita_row"], right["corner_basis"]
        product = (
            P_matrix
            @ M[alpha].T
            @ Q
            @ P_matrix
            @ G[row].T
            @ B[form]
            @ G[column]
            @ P_matrix
            @ Q
            @ M[beta]
        ) % P
        return -int(np.trace(product) % P) * pow(2 * pow(s, 3, P) % P, -1, P) % P

    table_pairs, expected_forms = table_forms(c2)
    assert table_pairs == [tuple(row) for row in homogeneous_monomials]
    pair_index = {pair: index for index, pair in enumerate(table_pairs)}
    finite_homogeneous = []
    for form_index, form in enumerate(homogeneous_forms):
        rows = []
        for record in form["coefficients"]:
            monomial = record["monomial"]
            left, right = (labels[index] for index in monomial)
            vectors = [(left, right)]
            if monomial[0] != monomial[1]:
                vectors.append((right, left))
            original = symmetrized_original(form_index, vectors)
            reduced = sum(ordered_reduced(form_index, *pair) for pair in vectors) % P
            expected = expected_forms[form_index][pair_index[tuple(monomial)]] % P
            assert original == reduced == expected
            rows.append(original)
        finite_homogeneous.append(rows)
    assert len(finite_homogeneous) == 5 and all(len(row) == 78 for row in finite_homogeneous)

    finite_charts = []
    for chart, (pivot_row, variables, monomials) in zip(
        dag["normalized_charts"], chart_descriptors
    ):
        base_index = 4 * pivot_row
        base = labels[base_index]
        chart_values = []
        for form_index, form in enumerate(chart["forms"]):
            rows = []
            for record in form["coefficients"]:
                monomial = record["monomial"]
                if not monomial:
                    vectors = [(base, base)]
                    expected_pair = (base_index, base_index)
                elif len(monomial) == 1:
                    value = labels[monomial[0]]
                    vectors = [(base, value), (value, base)]
                    expected_pair = tuple(sorted((base_index, monomial[0])))
                else:
                    left, right = (labels[index] for index in monomial)
                    vectors = [(left, right)]
                    if monomial[0] != monomial[1]:
                        vectors.append((right, left))
                    expected_pair = tuple(monomial)
                original = symmetrized_original(form_index, vectors)
                reduced = sum(ordered_reduced(form_index, *pair) for pair in vectors) % P
                expected = expected_forms[form_index][pair_index[expected_pair]] % P
                assert original == reduced == expected
                rows.append(original)
            chart_values.append(rows)
        assert len(chart_values) == 5 and all(len(row) == 45 for row in chart_values)
        finite_charts.append(chart_values)

    # Recover the sealed q0=1 common line from the rebuilt homogeneous forms.
    seed = [1, 0, 0, 0, 13, 9, 8, 10, 0, 20, 7, 1]
    seed_residuals = []
    for form in expected_forms:
        value = 0
        for coefficient, (left, right) in zip(form, table_pairs):
            value += coefficient * seed[left] * seed[right]
        seed_residuals.append(value % P)
    assert seed_residuals == [0] * 5
    jacobian = []
    for form in expected_forms:
        row = []
        for variable in range(4, 12):
            value = 0
            for coefficient, (left, right) in zip(form, table_pairs):
                if left == variable:
                    value += coefficient * seed[right]
                if right == variable:
                    value += coefficient * seed[left]
            row.append(value % P)
        jacobian.append(row)
    jacobian = np.asarray(jacobian, dtype=np.int64)
    jacobian_minor = det_mod(jacobian[:, :5])
    assert jacobian_minor == dag["hensel_lift_gate"]["jacobian_minor_mod_23"] == 11
    assert dag["hensel_lift_gate"]["sealed_residue_line"] == seed

    # A nonzero square coefficient at a good specialization proves that the
    # corresponding generic square coefficient is not identically zero.
    square_witnesses = {}
    q0_monomials = chart_descriptors[0][2]
    q0_values = finite_charts[0]
    for variable in range(4, 12):
        monomial_position = q0_monomials.index([variable, variable])
        hits = [
            [form, q0_values[form][monomial_position]]
            for form in range(5)
            if q0_values[form][monomial_position]
        ]
        assert hits
        square_witnesses[f"u{variable}"] = hits
    assert set(square_witnesses) == {f"u{index}" for index in range(4, 12)}

    index_certificate = json.loads(SOURCES["index_two_certificate"].read_text())
    theorem = index_certificate["brauer_exponent_index_theorem"]
    assert theorem["only_possible_index"] == 2 and theorem["period"] == 2
    assert "nonzero" in theorem["period_reason"]
    assert "quaternion division algebra" in theorem["conclusion"]

    print("PASS all source hashes and the independent homogeneous 5x78 plus three-chart inventory")
    print("PASS all ordered trace dictionaries, fixed chart coordinates, and open-ledger schema reconstructed exactly")
    print("PASS open witnesses Pf(Q)=17 s=3 f14=17 cornerDet=16 moduleDet=19 mod 23")
    print("PASS all 390 homogeneous and 675 normalized-chart trace records equal the original Morita tables mod 23")
    print(
        f"PASS recovered sealed q0=1 line={seed} with residuals={seed_residuals} "
        f"and old-coordinate Jacobian minor={jacobian_minor}"
    )
    print(f"PASS denominator-minimal ordered trace identity with s={s}")
    print(f"PASS generic old-coordinate square witnesses={square_witnesses}")
    print("PASS generic D is nonsplit (period=index=2); the split 4+4 determinant is not a K_proj descent")
    print("SCOPE exact generic Morita coefficient DAG only; no K_proj common line")
    print("C5-MORITA-GENERIC-390-COEFFICIENT-DAG-INDEPENDENTLY-VERIFIED")


if __name__ == "__main__":
    main()
