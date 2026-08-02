#!/usr/bin/env python3
"""Verify the generic split Morita DAG at its bound good specialization.

The p=23 computation is used only for circuit wiring and nonvanishing of the
selected generic minors.  It is not a characteristic-zero common line.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import runpy
from pathlib import Path

import numpy as np


P = 23
HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
A7 = REPO / "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
DAG = HERE / "morita_generic_split_dag.json"
OLD_SEED = [1, 0, 0, 0, 13, 9, 8, 10, 0, 20, 7, 1]


def rank_mod(matrix: np.ndarray) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % P
    row = 0
    for column in range(work.shape[1]):
        pivots = np.flatnonzero(work[row:, column])
        if not len(pivots):
            continue
        pivot = row + int(pivots[0])
        work[[row, pivot]] = work[[pivot, row]]
        work[row] = work[row] * pow(int(work[row, column]), -1, P) % P
        for other in range(work.shape[0]):
            if other != row and work[other, column]:
                work[other] = (work[other] - work[other, column] * work[row]) % P
        row += 1
        if row == work.shape[0]:
            break
    return row


def determinant_mod(matrix: np.ndarray) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % P
    assert work.shape[0] == work.shape[1]
    answer = 1
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row, column]),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[[column, pivot]] = work[[pivot, column]]
            answer = -answer
        answer = answer * int(work[column, column]) % P
        inverse = pow(int(work[column, column]), -1, P)
        for row in range(column + 1, len(work)):
            factor = int(work[row, column]) * inverse % P
            work[row] = (work[row] - factor * work[column]) % P
    return answer % P


def pfaffian_mod(matrix: np.ndarray) -> int:
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


def independently_expected_open_schema():
    open_conditions = [
        "s=sum_{i<j}Q_ij*P_ij != 0",
        "rank_flatten(d0,d1,d2,d3)=4",
        "rank_flatten({g_r*e*d_alpha:g=(1,a,b),alpha=0..3})=12",
        "det(Jminor)!=0 and det(T_corner_to_entries)!=0",
        "sealed source denominators are nonzero",
    ]
    open_ledger = {
        "required_opens": [
            "2!=0",
            "Pf(Q)!=0",
            "s!=0",
            "f14!=0",
            "rank_flatten(d0,d1,d2,d3)=4",
            "rank_flatten({g_r*e*d_alpha:g=(1,a,b),alpha=0..3})=12",
            "det(Jminor)!=0",
            "det(T_corner_to_entries)!=0",
            "sealed source denominators are nonzero",
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
                "basis_order": ["d0", "d1", "d2", "d3"],
                "rows": [0, 1, 6, 7],
                "columns": [0, 1, 2, 3],
                "determinant_mod_23": 13,
            },
            "morita_module_minor": {
                "flattening": "row-major 6x6 matrices as columns",
                "basis_order": "g_r*e*d_alpha, lexicographic for g=(1,a,b) and alpha=0..3",
                "rows": [0, 1, 6, 7, 12, 13, 18, 19, 24, 25, 31, 30],
                "columns": list(range(12)),
                "determinant_mod_23": 22,
            },
            "Jminor": {
                "matrix": "e[rows=(0,1),columns=(0,1)]",
                "rows": [0, 1],
                "columns": [0, 1],
                "determinant_mod_23": 5,
            },
            "T_corner_to_entries": {
                "vectorization": "row-major (00,01,10,11)",
                "determinant_mod_23": 18,
            },
        },
    }
    return open_conditions, open_ledger


def independently_expected_circuit_schema():
    """Reconstruct every serialized node and every public root reference."""

    expected_nodes = {}

    def add(name, op, *args, **metadata):
        assert name not in expected_nodes
        expected_nodes[name] = {"op": op, "args": list(args), **metadata}

    for name, source in (
        ("P", "degree12_bivector_matrix_P"),
        ("Q", "aligned_pfaffian_matrix_Q(x)"),
        ("a", "compressed_algebra_generator_a"),
        ("b", "compressed_algebra_generator_b"),
    ):
        add(name, "source", source=source)
    for index, form_name in enumerate(("x", "C", "D", "E", "K")):
        add(f"B{index}", "source", source=f"Q(V_{form_name}(x))")
    add("s", "pairing", "P", "Q", convention="sum_{i<j}Q_ij*P_ij")
    add("PQ", "matmul", "P", "Q")
    add("e", "scale_by_inverse", "PQ", "s", scalar=-1)
    add("d0", "alias", "e")
    add("ea", "matmul", "e", "a")
    add("eb", "matmul", "e", "b")
    add("eab", "matmul", "ea", "b")
    add("d1", "matmul", "ea", "e")
    add("d2", "matmul", "eb", "e")
    add("d3", "matmul", "eab", "e")
    add("W0", "alias", "e")
    add("ae", "matmul", "a", "e")
    add("be", "matmul", "b", "e")
    for alpha in range(4):
        add(f"W{alpha + 1}", "matmul", "ae", f"d{alpha}")
        add(f"W{alpha + 5}", "matmul", "be", f"d{alpha}")
    add("J", "select_columns", "e", columns=[0, 1])
    add("Jminor", "select_rows", "J", rows=[0, 1])
    add("Jminor_inv", "inverse", "Jminor")
    add(
        "T_corner_to_entries",
        "corner_action_representation",
        "Jminor_inv",
        "J",
        "d0",
        "d1",
        "d2",
        "d3",
        pivot_rows=[0, 1],
        vectorization="row-major (00,01,10,11)",
    )
    add("T_entries_to_corner", "inverse", "T_corner_to_entries")

    monomials = []
    pair_index = {}
    for left in range(9):
        for right in range(left, 9):
            pair_index[(left, right)] = len(monomials)
            exponents = [0] * 8
            if left:
                exponents[left - 1] += 1
            if right:
                exponents[right - 1] += 1
            monomials.append(
                {
                    "left_W": left,
                    "right_W": right,
                    "exponents_z0_to_z7": exponents,
                }
            )

    names = ("x", "C", "D", "E", "K")
    forms = []
    for form_index, form_name in enumerate(names):
        roots = []
        for coefficient_index, monomial in enumerate(monomials):
            left, right = monomial["left_W"], monomial["right_W"]
            root = f"c{form_index}_{coefficient_index}"
            add(
                root,
                "trace_bilinear_coefficient",
                "P",
                f"W{left}",
                f"B{form_index}",
                f"W{right}",
                symmetrize=left != right,
            )
            roots.append(root)
        forms.append(
            {
                "name": form_name,
                "coefficient_roots": roots,
                "numerator_equation": f"G_{form_name}=sum_m c_{form_index},m*z^m=0",
                "normalized_relation": f"lambda_{form_name}=-G_{form_name}/(2*s)",
            }
        )

    split_roots = []
    for form_index in range(5):
        table = {}
        originals = forms[form_index]["coefficient_roots"]
        for left in range(9):
            for right in range(left, 9):
                root = f"sc{form_index}_{pair_index[(left, right)]}"
                add(
                    root,
                    "quadratic_block_change_coefficient",
                    "T_entries_to_corner",
                    *originals,
                    target_left=left,
                    target_right=right,
                    global_pair_order="monomial_order",
                )
                table[(left, right)] = root
        split_roots.append(table)

    u_positions = (0, 2, 4, 6)
    v_positions = (1, 3, 5, 7)
    block_forms = []
    for form_index, form_name in enumerate(names):
        split = split_roots[form_index]
        row = []
        for u_index, u_position in enumerate(u_positions):
            root = f"A{form_index}_{u_index}"
            add(
                root,
                "affine_polynomial",
                split[(0, u_position + 1)],
                *(split[tuple(sorted((u_position + 1, v_position + 1)))] for v_position in v_positions),
                variables=["v0", "v1", "v2", "v3"],
            )
            row.append(root)
        constant = f"cblock{form_index}"
        add(
            constant,
            "affine_polynomial",
            split[(0, 0)],
            *(split[(0, position + 1)] for position in v_positions),
            variables=["v0", "v1", "v2", "v3"],
        )
        block_forms.append({"name": form_name, "A_row": row, "c": constant})

    augmented = [root for row in block_forms for root in [*row["A_row"], row["c"]]]
    add(
        "Delta",
        "determinant_polynomial",
        *augmented,
        shape=[5, 5],
        variables=["v0", "v1", "v2", "v3"],
        formula="det([A(v)|c(v)])",
    )
    rank_minors = []
    for omitted in range(5):
        root = f"rank4_minor_omit_{omitted}"
        add(
            root,
            "determinant_polynomial",
            *(
                block_forms[row]["A_row"][column]
                for row in range(5)
                if row != omitted
                for column in range(4)
            ),
            shape=[4, 4],
            variables=["v0", "v1", "v2", "v3"],
        )
        rank_minors.append(root)
    add(
        "Delta_at_v0",
        "determinant",
        *(
            root
            for form_index in range(5)
            for root in [
                *(split_roots[form_index][(0, position + 1)] for position in u_positions),
                split_roots[form_index][(0, 0)],
            ]
        ),
        shape=[5, 5],
    )

    split_block = {
        "field_scope": "Exact split chart over Q(zeta11,t)(x); no splitting of D over K_proj claimed",
        "chart": "J=e[:,(0,1)], pivot rows (0,1)",
        "u": ["y0", "y2", "y4", "y6"],
        "v": ["y1", "y3", "y5", "y7"],
        "bilinear_identity": "Alternation kills all u-u and v-v quadratic terms, giving A(v)u+c(v)=0",
        "block_forms": block_forms,
        "consistency_determinant": "Delta",
        "rank_leq_3_minors": rank_minors,
        "rank_strata": "rank(A)<=r is cut out by all (r+1)-minors",
        "structural_ansatz": {
            "ansatz": "v=0 in this selected ambient split chart",
            "obstruction_root": "Delta_at_v0",
            "scope": "Only this structural ansatz; not an obstruction to all common lines",
        },
    }
    return expected_nodes, monomials, forms, split_block


def coefficient_table(pmat, bmat, w_matrices):
    table = np.zeros((9, 9), dtype=np.int64)
    for left in range(9):
        for right in range(left, 9):
            inside = w_matrices[left].T @ bmat @ w_matrices[right]
            if left != right:
                inside += w_matrices[right].T @ bmat @ w_matrices[left]
            table[left, right] = int(np.trace(pmat @ inside) % P)
    return table


def polynomial_value(table, variables):
    values = [1, *map(int, variables)]
    return sum(
        int(table[left, right]) * values[left] * values[right]
        for left in range(9)
        for right in range(left, 9)
    ) % P


def build_w(e, a, b, corner):
    return [e, *[a @ e @ d % P for d in corner], *[b @ e @ d % P for d in corner]]


def block_change(original, entries_to_corner):
    transform = np.zeros((8, 8), dtype=np.int64)
    transform[:4, :4] = entries_to_corner
    transform[4:, 4:] = entries_to_corner
    changed = np.zeros((9, 9), dtype=np.int64)
    changed[0, 0] = original[0, 0]
    for target in range(8):
        changed[0, target + 1] = sum(
            int(original[0, source + 1]) * int(transform[source, target])
            for source in range(8)
        ) % P
    for left in range(8):
        for right in range(left, 8):
            value = 0
            if left == right:
                value += sum(
                    int(original[source + 1, source + 1])
                    * int(transform[source, left]) ** 2
                    for source in range(8)
                )
                value += sum(
                    int(original[source + 1, other + 1])
                    * int(transform[source, left])
                    * int(transform[other, left])
                    for source in range(8)
                    for other in range(source + 1, 8)
                )
            else:
                value += sum(
                    2
                    * int(original[source + 1, source + 1])
                    * int(transform[source, left])
                    * int(transform[source, right])
                    for source in range(8)
                )
                value += sum(
                    int(original[source + 1, other + 1])
                    * (
                        int(transform[source, left]) * int(transform[other, right])
                        + int(transform[source, right]) * int(transform[other, left])
                    )
                    for source in range(8)
                    for other in range(source + 1, 8)
                )
            changed[left + 1, right + 1] = value % P
    return changed


def main() -> None:
    packet = json.loads(DAG.read_text())
    assert packet["format"] == "morita-generic-split-q0-lazy-v1"
    assert packet["counts"] == {
        "variables": 8,
        "forms": 5,
        "coefficients_per_form": 45,
        "coefficient_roots": 225,
        "split_coefficient_roots": 225,
        "dag_nodes": 517,
    }
    nodes = packet["nodes"]
    assert len(nodes) == 517
    expected_nodes, expected_monomials, expected_forms, expected_split_block = (
        independently_expected_circuit_schema()
    )
    expected_open_conditions, expected_open_ledger = independently_expected_open_schema()
    assert nodes == expected_nodes
    assert packet["monomial_order"] == expected_monomials
    assert packet["forms"] == expected_forms
    assert packet["split_block"] == expected_split_block
    assert packet["open_conditions"] == expected_open_conditions
    assert packet["open_ledger"] == expected_open_ledger
    assert sum(node["op"] == "trace_bilinear_coefficient" for node in nodes.values()) == 225
    assert sum(node["op"] == "quadratic_block_change_coefficient" for node in nodes.values()) == 225
    assert not [
        (name, argument)
        for name, specification in nodes.items()
        for argument in specification.get("args", [])
        if argument not in nodes
    ]
    for record in packet["source_files"].values():
        path = Path(record["path"])
        assert hashlib.sha256(path.read_bytes()).hexdigest() == record["sha256"]

    producer = runpy.run_path(str(A7 / "produce_c2_morita.py"))
    e, qmat, domain_basis, pairs, wedge = producer["modular_projector"]()
    pmat = producer["skew"](wedge, pairs)
    c3 = runpy.run_path(
        str(producer["ROOT"] / "certificates/fano_c3/produce_c3.py")
    )
    c2 = c3["load_c2_helpers"]()
    frame = c2["build_projective_reynolds_frame"](P, 2)
    matrices = [matrix % P for matrix in frame["basis_mats"]]
    a, b = matrices[1], matrices[2]
    corner = [e, e @ a @ e % P, e @ b @ e % P, e @ a @ b @ e % P]
    assert producer["rank_mod"](corner) == 4
    open_witnesses = packet["open_ledger"]["good_fibre_open_witnesses"]
    assert pfaffian_mod(qmat) == open_witnesses["pfaffian_Q_mod_23"] == 17
    s = int(np.dot(domain_basis @ np.asarray(producer["POINT"]) % P, wedge) % P)
    assert s == open_witnesses["s_mod_23"] == 3
    assert frame["denominator"] == open_witnesses["f14_mod_23"] == 17
    corner_minor = open_witnesses["corner_minor"]
    corner_flattening = np.stack(
        [value.reshape(-1) for value in corner], axis=1
    ) % P
    assert corner_minor["columns"] == list(range(4))
    assert (
        determinant_mod(
            corner_flattening[corner_minor["rows"]][:, corner_minor["columns"]]
        )
        == corner_minor["determinant_mod_23"]
        == 13
    )
    identity = np.eye(6, dtype=np.int64) % P
    module_basis = [
        generator @ e @ value % P
        for generator in (identity, a, b)
        for value in corner
    ]
    module_minor = open_witnesses["morita_module_minor"]
    module_flattening = np.stack(
        [value.reshape(-1) for value in module_basis], axis=1
    ) % P
    assert module_minor["columns"] == list(range(12))
    assert (
        determinant_mod(
            module_flattening[module_minor["rows"]][:, module_minor["columns"]]
        )
        == module_minor["determinant_mod_23"]
        == 22
    )
    w_matrices = build_w(e, a, b, corner)
    names, values = producer["hilbert90_values"]()
    b_matrices = [
        producer["skew"](
            domain_basis @ np.asarray(value, dtype=np.int64) % P, pairs
        )
        for value in values
    ]
    tables = [coefficient_table(pmat, bmat, w_matrices) for bmat in b_matrices]

    # Interpret every serialized original root and check its exact wiring.
    for form_index, form in enumerate(packet["forms"]):
        assert form["name"] == names[form_index]
        for root, monomial in zip(form["coefficient_roots"], packet["monomial_order"]):
            left, right = monomial["left_W"], monomial["right_W"]
            specification = nodes[root]
            assert specification["args"] == [
                "P",
                f"W{left}",
                f"B{form_index}",
                f"W{right}",
            ]
            inside = w_matrices[left].T @ b_matrices[form_index] @ w_matrices[right]
            if left != right:
                inside += w_matrices[right].T @ b_matrices[form_index] @ w_matrices[left]
            assert int(np.trace(pmat @ inside) % P) == int(tables[form_index][left, right])

    # The trace numerator agrees with the actual scalar Morita self-pairing.
    q_inverse = producer["inv_mod"](qmat)
    rng = np.random.default_rng(20260801)
    for _ in range(8):
        z = rng.integers(0, P, size=8, dtype=np.int64)
        q1 = sum(
            (int(z[index]) * corner[index] for index in range(4)),
            np.zeros((6, 6), dtype=np.int64),
        ) % P
        q2 = sum(
            (int(z[4 + index]) * corner[index] for index in range(4)),
            np.zeros((6, 6), dtype=np.int64),
        ) % P
        w = (e + a @ e @ q1 + b @ e @ q2) % P
        for table, bmat in zip(tables, b_matrices):
            numerator = polynomial_value(table, z)
            assert numerator == int(np.trace(pmat @ w.T @ bmat @ w) % P)
            morita = q_inverse @ w.T @ bmat @ w % P
            scalar = int(np.trace(morita) * pow(2, -1, P) % P)
            assert np.array_equal(morita, scalar * e % P)
            assert numerator == -2 * s * scalar % P

    # Rebuild the exact ambient split chart selected in the DAG.
    image_basis = e[:, [0, 1]] % P
    pivot = image_basis[[0, 1], :] % P
    assert (
        determinant_mod(pivot)
        == open_witnesses["Jminor"]["determinant_mod_23"]
        == 5
    )
    pivot_inverse = producer["inv_mod"](pivot)
    representation_columns = []
    for value in corner:
        rho = pivot_inverse @ (value @ image_basis % P)[[0, 1], :] % P
        assert np.array_equal(value @ image_basis % P, image_basis @ rho % P)
        representation_columns.append(rho.reshape(-1))
    corner_to_entries = np.stack(representation_columns, axis=1) % P
    assert (
        determinant_mod(corner_to_entries)
        == open_witnesses["T_corner_to_entries"]["determinant_mod_23"]
        == 18
    )
    entries_to_corner = producer["inv_mod"](corner_to_entries)
    assert entries_to_corner.tolist() == [
        [11, 2, 17, 13],
        [11, 10, 13, 12],
        [22, 9, 10, 1],
        [13, 8, 0, 10],
    ]
    split_tables = [block_change(table, entries_to_corner) for table in tables]
    u_positions = (0, 2, 4, 6)
    v_positions = (1, 3, 5, 7)
    for table in split_tables:
        for left, right in itertools.combinations_with_replacement(u_positions, 2):
            assert table[left + 1, right + 1] == 0
        for left, right in itertools.combinations_with_replacement(v_positions, 2):
            assert table[left + 1, right + 1] == 0

    # A(v)u+c(v) equals the full changed quadratic.
    for _ in range(8):
        y = rng.integers(0, P, size=8, dtype=np.int64)
        u, v = y[list(u_positions)], y[list(v_positions)]
        z = np.concatenate(
            (entries_to_corner @ y[:4], entries_to_corner @ y[4:])
        ) % P
        for original, split in zip(tables, split_tables):
            block_value = int(split[0, 0]) + sum(
                int(split[0, position + 1]) * int(v[column])
                for column, position in enumerate(v_positions)
            )
            for row, position in enumerate(u_positions):
                affine = int(split[0, position + 1])
                affine += sum(
                    int(split[min(position, v_position) + 1, max(position, v_position) + 1])
                    * int(v[column])
                    for column, v_position in enumerate(v_positions)
                )
                block_value += affine * int(u[row])
            assert block_value % P == polynomial_value(split, y)
            assert polynomial_value(split, y) == polynomial_value(original, z)

    # Only the selected structural ansatz v=0 is obstructed here.
    A0 = np.asarray(
        [[table[0, position + 1] for position in u_positions] for table in split_tables],
        dtype=np.int64,
    ) % P
    c0 = np.asarray([table[0, 0] for table in split_tables], dtype=np.int64) % P
    assert rank_mod(A0) == 4
    rank4_minors = [
        determinant_mod(np.delete(A0, omitted, axis=0)) for omitted in range(5)
    ]
    assert rank4_minors == [13, 10, 4, 5, 10]
    delta0 = determinant_mod(np.column_stack((A0, c0)))
    assert delta0 == 1

    # The earlier finite seed checks compatibility of the new basis only.
    old_packet = json.loads((A7 / "c2_morita.json").read_text())
    old_corner = [
        np.asarray(value, dtype=np.int64) % P
        for value in old_packet["good_fibre_witness"]["corner_basis_values"]
    ]
    _rows, coordinates = producer["left_inverse_coordinates"](corner)
    converted = []
    for block in range(3):
        value = sum(
            (OLD_SEED[4 * block + index] * old_corner[index] for index in range(4)),
            np.zeros((6, 6), dtype=np.int64),
        ) % P
        converted.extend(map(int, coordinates(value)))
    assert converted[:4] == [1, 0, 0, 0]
    assert all(polynomial_value(table, converted[4:]) == 0 for table in tables)

    # Algebraic conjugation replay of invariance for all 225 roots.
    full_wedge = runpy.run_path(
        str(producer["ROOT"] / "tmp/pfaffian_rank2_idempotent_attack/full_wedge.py")
    )
    for rho in full_wedge["fano"]["six_dimensional_generators"]()[:2]:
        rho = np.asarray(rho, dtype=np.int64) % P
        rho_inverse = producer["inv_mod"](rho)
        p_prime = rho @ pmat @ rho.T % P
        e_prime = rho @ e @ rho_inverse % P
        a_prime = rho @ a @ rho_inverse % P
        b_prime = rho @ b @ rho_inverse % P
        corner_prime = [rho @ value @ rho_inverse % P for value in corner]
        w_prime = build_w(e_prime, a_prime, b_prime, corner_prime)
        for original, bmat in zip(tables, b_matrices):
            b_prime = rho_inverse.T @ bmat @ rho_inverse % P
            assert np.array_equal(
                coefficient_table(p_prime, b_prime, w_prime), original
            )

    print("sourceHashes=8 dagNodes=517 originalRoots=225 splitRoots=225")
    print("allNodeSpecsAndPublicRoots=FULL_DICT_MATCH openLedger=FULL_DICT_MATCH")
    print("openWitnesses=PfQ17,s3,f14=17,cornerDet13,moduleDet22,JminorDet5,Tdet18")
    print("cornerRank=4 splitChangeDet=18")
    print(f"convertedKnownSeed={converted}")
    print(f"A0Rank=4 rank4Minors={rank4_minors} DeltaAtV0={delta0}")
    print("SCOPE=selected-v0-ansatz-only;no-common-line;no-12-vector-lowering")
    print("MORITA-GENERIC-SPLIT-DAG-VERIFIED")


if __name__ == "__main__":
    main()
