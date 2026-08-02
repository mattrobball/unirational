#!/usr/bin/env python3
"""Consume every serialized Morita factor string / split-DAG node at p=23.

This advances G_MORITA_SOURCE_INTERPRETER without expanding L_a or claiming a
K_proj point.  The producer:

1. binds prose source leaves to sealed modular evaluation recipes;
2. walks every ordered_trace_terms.factors list in morita_generic_dag.json;
3. evaluates every node of morita_generic_split_dag.json in dependency order;
4. matches independent Hermitian / corner tables;
5. self-tests that corrupting a single stored factor string fails evaluation.

Replay:

  PYTHONDONTWRITEBYTECODE=1 python3 -u produce_record_interpreter.py
  PYTHONDONTWRITEBYTECODE=1 python3 -u verify_record_interpreter.py
"""

from __future__ import annotations

import hashlib
import json
import re
import runpy
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
C5 = ROOT / "goals_after_bd610a" / "C5_PROJECTOR_INCIDENCE"
A7 = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
CROOT = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT"

P = 23
ZETA = 2
POINT = (1, 2, 3, 4, 5)
SEED = [1, 0, 0, 0, 13, 9, 8, 10, 0, 20, 7, 1]

TRANSPOSE_M = re.compile(r"^transpose\(M\[(\d)\]\)$")
TRANSPOSE_G = re.compile(r"^transpose\(G\[(\d)\]\)$")
M_FACTOR = re.compile(r"^M\[(\d)\]$")
G_FACTOR = re.compile(r"^G\[(\d)\]$")
B_FACTOR = re.compile(r"^B\[(\d)\]$")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inv_mod(matrix: np.ndarray, prime: int = P) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = matrix.shape[0]
    work = np.concatenate((matrix.copy(), np.eye(size, dtype=np.int64)), axis=1)
    for column in range(size):
        candidates = np.flatnonzero(work[column:, column])
        assert len(candidates)
        pivot = column + int(candidates[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = work[column] * pow(int(work[column, column]), -1, prime) % prime
        for row in range(size):
            if row != column and work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % prime
    return work[:, size:] % prime


def det_mod(matrix: np.ndarray, prime: int = P) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % prime
    answer = 1
    for column in range(work.shape[0]):
        candidates = np.flatnonzero(work[column:, column])
        if not len(candidates):
            return 0
        pivot = column + int(candidates[0])
        if pivot != column:
            work[[column, pivot]] = work[[pivot, column]]
            answer = -answer
        value = int(work[column, column]) % prime
        answer = answer * value % prime
        work[column] = work[column] * pow(value, -1, prime) % prime
        for row in range(column + 1, work.shape[0]):
            if work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % prime
    return answer % prime


def rank_mod(columns: list[np.ndarray], prime: int = P) -> int:
    if not columns:
        return 0
    matrix = np.stack([column.reshape(-1) for column in columns], axis=1) % prime
    row = 0
    for column in range(matrix.shape[1]):
        pivots = np.flatnonzero(matrix[row:, column])
        if not len(pivots):
            continue
        pivot = row + int(pivots[0])
        matrix[[row, pivot]] = matrix[[pivot, row]]
        matrix[row] = matrix[row] * pow(int(matrix[row, column]), -1, prime) % prime
        for other in range(matrix.shape[0]):
            if other != row and matrix[other, column]:
                matrix[other] = (
                    matrix[other] - matrix[other, column] * matrix[row]
                ) % prime
        row += 1
        if row == matrix.shape[0]:
            break
    return row


def pfaffian_mod(matrix: np.ndarray, prime: int = P) -> int:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = matrix.shape[0]
    assert matrix.shape == (size, size) and size % 2 == 0
    if size == 0:
        return 1
    answer = 0
    for column in range(1, size):
        keep = [index for index in range(1, size) if index != column]
        sign = 1 if column % 2 else -1
        answer += (
            sign
            * int(matrix[0, column])
            * pfaffian_mod(matrix[np.ix_(keep, keep)], prime)
        )
    return answer % prime


def skew(values, pairs, prime: int = P) -> np.ndarray:
    answer = np.zeros((6, 6), dtype=np.int64)
    for value, (left, right) in zip(values, pairs):
        answer[left, right] = int(value) % prime
        answer[right, left] = -int(value) % prime
    return answer % prime


def load_fibre_context():
    """Bind every Morita source leaf at the accepted p=23 fibre."""

    producer = runpy.run_path(str(A7 / "produce_c2_morita.py"))
    e, Q, domain_basis, pairs, wedge = producer["modular_projector"]()
    P_matrix = producer["skew"](wedge, pairs)
    s = int(np.dot(domain_basis @ np.asarray(POINT, dtype=np.int64) % P, wedge) % P)
    assert s == 3

    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    frame = c3["load_c2_helpers"]()["build_projective_reynolds_frame"](P, ZETA)
    matrices = [value % P for value in frame["basis_mats"]]
    identity = np.eye(6, dtype=np.int64) % P
    a, b = matrices[1], matrices[2]
    M = [identity, matrices[1], matrices[2], matrices[3]]
    G = [identity, matrices[1], matrices[2]]

    names, hilbert = producer["hilbert90_values"]()
    assert names == ["x", "C", "D", "E", "K"]
    B = [
        producer["skew"](
            domain_basis @ np.asarray(vector, dtype=np.int64) % P, pairs
        )
        for vector in hilbert
    ]

    corner = [e @ value @ e % P for value in M]
    assert rank_mod(corner) == 4
    d = corner
    w_matrices = [e] + [a @ e @ d_alpha % P for d_alpha in d] + [
        b @ e @ d_alpha % P for d_alpha in d
    ]
    assert len(w_matrices) == 9

    binding = {
        "prime": P,
        "zeta11": ZETA,
        "source_point": list(POINT),
        "rur_root": 1,
        "leaves": {
            "P": {
                "recipe": "degree12_bivector_matrix_from_modular_projector_wedge",
                "source_path": str(
                    A7 / "ambient_degree12_rur_char0.json"
                ).replace(str(ROOT) + "/", ""),
                "evaluator": "produce_c2_morita.modular_projector -> skew(wedge)",
            },
            "Q": {
                "recipe": "aligned_pfaffian_Q(x)_from_domain_basis",
                "source_path": str(
                    ROOT / "tmp/pfaffian_rank2_idempotent_attack/full_wedge.py"
                ).replace(str(ROOT) + "/", ""),
                "evaluator": "domain_basis @ point",
            },
            "a": {
                "recipe": "projective_reynolds_frame[1]",
                "source_path": "certificates/fano_c3/produce_c3.py",
                "evaluator": "build_projective_reynolds_frame(p,zeta).basis_mats[1]",
            },
            "b": {
                "recipe": "projective_reynolds_frame[2]",
                "source_path": "certificates/fano_c3/produce_c3.py",
                "evaluator": "build_projective_reynolds_frame(p,zeta).basis_mats[2]",
            },
            **{
                f"B{i}": {
                    "recipe": f"Q(V_{name}(x)) via Hilbert-90 frame",
                    "source_path": "tmp/generic_twist/phi_coefficients.py",
                    "evaluator": "skew(domain_basis @ hilbert90[i])",
                    "section_name": name,
                }
                for i, name in enumerate(names)
            },
            "M[0]": {"recipe": "identity_6", "evaluator": "I_6"},
            "M[1]": {"recipe": "frame[1]", "evaluator": "basis_mats[1]"},
            "M[2]": {"recipe": "frame[2]", "evaluator": "basis_mats[2]"},
            "M[3]": {"recipe": "frame[3]", "evaluator": "basis_mats[3]"},
            "G[0]": {"recipe": "identity_6", "evaluator": "I_6"},
            "G[1]": {"recipe": "frame[1]", "evaluator": "basis_mats[1]"},
            "G[2]": {"recipe": "frame[2]", "evaluator": "basis_mats[2]"},
            "s": {
                "recipe": "pairing sum_{i<j} Q_ij P_ij",
                "value_mod_p": s,
            },
            "e": {
                "recipe": "-P Q / s",
                "value_trace_mod_p": int(np.trace(e) % P),
            },
        },
        "open_witnesses": {
            "pfaffian_Q": pfaffian_mod(Q),
            "s": s,
            "f14": int(frame["denominator"]),
            "corner_rank": rank_mod(corner),
        },
    }

    env = {
        "P_matrix": P_matrix,
        "Q": Q,
        "a": a,
        "b": b,
        "B": B,
        "M": M,
        "G": G,
        "s": s,
        "e": e,
        "d": d,
        "w": w_matrices,
        "names": names,
        "pairs": pairs,
        "domain_basis": domain_basis,
        "frame_denominator": int(frame["denominator"]),
        "producer": producer,
    }
    return binding, env


def resolve_factor(token: str, env: dict) -> np.ndarray:
    """Interpret one stored ordered_trace_terms factor string."""

    if token == "P":
        return env["P_matrix"]
    if token == "Q":
        return env["Q"]
    match = TRANSPOSE_M.match(token)
    if match:
        return env["M"][int(match.group(1))].T % P
    match = TRANSPOSE_G.match(token)
    if match:
        return env["G"][int(match.group(1))].T % P
    match = M_FACTOR.match(token)
    if match:
        return env["M"][int(match.group(1))]
    match = G_FACTOR.match(token)
    if match:
        return env["G"][int(match.group(1))]
    match = B_FACTOR.match(token)
    if match:
        return env["B"][int(match.group(1))]
    raise KeyError(f"unbound factor token: {token!r}")


def evaluate_ordered_term(term: dict, env: dict) -> int:
    """Evaluate one stored ordered_trace_terms record by factor walk."""

    assert term["operation"] == "matrix_trace_of_ordered_product"
    assert term["denominator"] == "2*s^3"
    assert term["scalar"] == -1
    product = np.eye(6, dtype=np.int64) % P
    for token in term["factors"]:
        product = product @ resolve_factor(token, env) % P
    numerator = int(np.trace(product) % P)
    den = 2 * pow(env["s"], 3, P) % P
    return (-numerator) * pow(den, -1, P) % P


def evaluate_homogeneous_dag(dag: dict, env: dict) -> dict:
    """Walk every stored homogeneous and chart coefficient record."""

    homogeneous_values = []
    factor_tokens = set()
    term_count = 0
    for form in dag["homogeneous_model"]["forms"]:
        form_row = []
        for record in form["coefficients"]:
            value = 0
            for term in record["ordered_trace_terms"]:
                for token in term["factors"]:
                    factor_tokens.add(token)
                value = (value + evaluate_ordered_term(term, env)) % P
                term_count += 1
            form_row.append(value)
        assert len(form_row) == 78
        homogeneous_values.append(form_row)

    chart_values = []
    for chart in dag["normalized_charts"]:
        chart_forms = []
        for form in chart["forms"]:
            form_row = []
            for record in form["coefficients"]:
                value = 0
                for term in record["ordered_trace_terms"]:
                    for token in term["factors"]:
                        factor_tokens.add(token)
                    value = (value + evaluate_ordered_term(term, env)) % P
                    term_count += 1
                form_row.append(value)
            assert len(form_row) == 45
            chart_forms.append(form_row)
        chart_values.append(chart_forms)

    return {
        "homogeneous_values_mod_p": homogeneous_values,
        "chart_values_mod_p": chart_values,
        "distinct_factor_tokens": sorted(factor_tokens),
        "ordered_terms_evaluated": term_count,
    }


def independent_corner_forms_fixed(env: dict) -> list[list[int]]:
    c2 = json.loads((A7 / "c2_morita.json").read_text())
    witness = c2["good_fibre_witness"]
    table = witness["corner_multiplication_left_right_coordinates"]
    star = np.asarray(witness["corner_star_matrix_columns"], dtype=np.int64) % P
    hermitian = witness["hermitian_matrices_D_coordinates"]
    units = [np.eye(4, dtype=np.int64)[index] for index in range(4)]

    def corner_multiply(left, right):
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

    forms = []
    pairs = [(left, right) for left in range(12) for right in range(left, 12)]
    for matrix in hermitian:
        coefficients = []
        for left, right in pairs:
            left_row, left_basis = divmod(left, 4)
            right_row, right_basis = divmod(right, 4)

            def ordered_fix(row, basis, column, other_basis, matrix=matrix):
                first = corner_multiply(
                    star @ units[basis] % P,
                    np.asarray(matrix[row][column], dtype=np.int64) % P,
                )
                return corner_multiply(first, units[other_basis])

            value = ordered_fix(left_row, left_basis, right_row, right_basis)
            if left != right:
                value = (
                    value + ordered_fix(right_row, right_basis, left_row, left_basis)
                ) % P
            assert not np.any(value[1:])
            coefficients.append(int(value[0]) % P)
        forms.append(coefficients)
    return forms


def seed_residuals(forms: list[list[int]], seed=SEED) -> list[int]:
    pairs = [(left, right) for left in range(12) for right in range(left, 12)]
    residuals = []
    for form in forms:
        value = 0
        for coefficient, (left, right) in zip(form, pairs):
            value += coefficient * seed[left] * seed[right]
        residuals.append(value % P)
    return residuals


def eval_split_dag(nodes: dict, env: dict) -> dict:
    """Evaluate every split-DAG node by walking stored op/args."""

    cache: dict[str, object] = {}

    def eval_node(name: str):
        if name in cache:
            return cache[name]
        spec = nodes[name]
        op = spec["op"]
        args = spec.get("args", [])
        if op == "source":
            source = spec["source"]
            if source == "degree12_bivector_matrix_P":
                value = env["P_matrix"]
            elif source == "aligned_pfaffian_matrix_Q(x)":
                value = env["Q"]
            elif source == "compressed_algebra_generator_a":
                value = env["a"]
            elif source == "compressed_algebra_generator_b":
                value = env["b"]
            elif source.startswith("Q(V_"):
                # Q(V_x(x)) etc.
                name_map = {"x": 0, "C": 1, "D": 2, "E": 3, "K": 4}
                section = source[source.index("V_") + 2 : source.index("(x)")]
                value = env["B"][name_map[section]]
            else:
                raise KeyError(source)
        elif op == "pairing":
            # convention: pairing(P,Q) = sum_{i<j} Q_ij P_ij
            Pmat, Qmat = eval_node("P"), eval_node("Q")
            value = 0
            for i in range(6):
                for j in range(i + 1, 6):
                    value += int(Qmat[i, j]) * int(Pmat[i, j])
            value %= P
        elif op == "matmul":
            left, right = (eval_node(arg) for arg in args)
            value = left @ right % P
        elif op == "scale_by_inverse":
            mat, scalar_name = args
            mat_v = eval_node(mat)
            scalar = int(eval_node(scalar_name)) % P
            value = mat_v * (spec.get("scalar", 1) * pow(scalar, -1, P) % P) % P
        elif op == "alias":
            value = eval_node(args[0])
        elif op == "select_columns":
            mat = eval_node(args[0])
            value = mat[:, list(spec["columns"])] % P
        elif op == "select_rows":
            mat = eval_node(args[0])
            value = mat[list(spec["rows"]), :] % P
        elif op == "inverse":
            value = inv_mod(np.asarray(eval_node(args[0]), dtype=np.int64))
        elif op == "corner_action_representation":
            jminor_inv = eval_node(args[0])
            j = eval_node(args[1])
            cols = []
            for dname in args[2:]:
                dval = eval_node(dname)
                rho = jminor_inv @ (dval @ j % P)[list(spec["pivot_rows"]), :] % P
                cols.append(rho.reshape(-1))
            value = np.stack(cols, axis=1) % P
        elif op == "trace_bilinear_coefficient":
            pmat = eval_node(args[0])
            w_left = eval_node(args[1])
            bmat = eval_node(args[2])
            w_right = eval_node(args[3])
            inside = w_left.T @ bmat @ w_right % P
            if spec.get("symmetrize"):
                inside = (inside + w_right.T @ bmat @ w_left) % P
            value = int(np.trace(pmat @ inside) % P)
        elif op == "quadratic_block_change_coefficient":
            # Evaluate by reconstructing the full changed table entry.
            # args[0] = T_entries_to_corner; args[1:] = 45 original roots in monomial order
            t_inv = np.asarray(eval_node(args[0]), dtype=np.int64) % P
            originals = [int(eval_node(arg)) for arg in args[1:]]
            assert len(originals) == 45
            # rebuild symmetric 9x9 upper table from monomial order
            original = np.zeros((9, 9), dtype=np.int64)
            idx = 0
            for left in range(9):
                for right in range(left, 9):
                    original[left, right] = originals[idx]
                    original[right, left] = originals[idx]
                    idx += 1
            transform = np.zeros((8, 8), dtype=np.int64)
            transform[:4, :4] = t_inv
            transform[4:, 4:] = t_inv
            tl = int(spec["target_left"])
            tr = int(spec["target_right"])
            if tl == 0 and tr == 0:
                value = int(original[0, 0]) % P
            elif tl == 0:
                target = tr - 1
                value = sum(
                    int(original[0, source + 1]) * int(transform[source, target])
                    for source in range(8)
                ) % P
            elif tr == 0:
                target = tl - 1
                value = sum(
                    int(original[0, source + 1]) * int(transform[source, target])
                    for source in range(8)
                ) % P
            else:
                left, right = tl - 1, tr - 1
                if left == right:
                    value = sum(
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
                    value = sum(
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
                value %= P
        elif op == "affine_polynomial":
            # constant + sum slope_i * v_i ; evaluate coefficients only (as nodes)
            coeffs = [int(eval_node(arg)) for arg in args]
            value = {"affine_coeffs": coeffs, "variables": spec.get("variables")}
        elif op == "determinant_polynomial":
            # store coefficient matrices as affine poly nodes; evaluate at v=0 only here
            shape = spec["shape"]
            entries = [eval_node(arg) for arg in args]
            assert len(entries) == shape[0] * shape[1]
            # each entry is affine_coeffs list; take constant term (v=0)
            mat = np.zeros(shape, dtype=np.int64)
            for index, entry in enumerate(entries):
                row, col = divmod(index, shape[1])
                if isinstance(entry, dict):
                    mat[row, col] = int(entry["affine_coeffs"][0]) % P
                else:
                    mat[row, col] = int(entry) % P
            value = det_mod(mat)
        elif op == "determinant":
            shape = spec["shape"]
            entries = [int(eval_node(arg)) % P for arg in args]
            mat = np.asarray(entries, dtype=np.int64).reshape(shape) % P
            value = det_mod(mat)
        else:
            raise KeyError(f"unsupported op {op} on node {name}")
        cache[name] = value
        return value

    # topological: evaluate all nodes
    op_counts: dict[str, int] = {}
    for name, spec in nodes.items():
        eval_node(name)
        op_counts[spec["op"]] = op_counts.get(spec["op"], 0) + 1

    # collect the 225 original roots and Delta_at_v0
    original_roots = []
    for form_index in range(5):
        for index in range(45):
            original_roots.append(int(cache[f"c{form_index}_{index}"]))
    split_roots = []
    for form_index in range(5):
        for index in range(45):
            split_roots.append(int(cache[f"sc{form_index}_{index}"]))

    return {
        "nodes_evaluated": len(cache),
        "op_counts": op_counts,
        "original_roots_mod_p": original_roots,
        "split_roots_mod_p": split_roots,
        "Delta_at_v0": int(cache["Delta_at_v0"]),
        "s": int(cache["s"]),
        "Jminor_det": det_mod(cache["Jminor"]),
        "T_corner_to_entries_det": det_mod(cache["T_corner_to_entries"]),
        "e_trace": int(np.trace(cache["e"]) % P),
    }


def corruption_self_test(dag: dict, env: dict) -> dict:
    """Corrupting one stored factor string must change evaluation or raise."""

    # Deep-copy first homogeneous coefficient of form 0 and corrupt a factor.
    record = json.loads(json.dumps(dag["homogeneous_model"]["forms"][0]["coefficients"][0]))
    original = 0
    for term in record["ordered_trace_terms"]:
        original = (original + evaluate_ordered_term(term, env)) % P
    # Flip P -> Q in the first factor of the first term if present.
    term0 = record["ordered_trace_terms"][0]
    assert "P" in term0["factors"]
    idx = term0["factors"].index("P")
    term0["factors"][idx] = "Q"
    corrupted = 0
    for term in record["ordered_trace_terms"]:
        corrupted = (corrupted + evaluate_ordered_term(term, env)) % P
    # Also test unbound token raises
    raised = False
    try:
        term0["factors"][idx] = "NOT_A_LEAF"
        evaluate_ordered_term(term0, env)
    except KeyError:
        raised = True
    return {
        "original_value_mod_p": original,
        "corrupted_P_to_Q_value_mod_p": corrupted,
        "values_differ": original != corrupted,
        "unbound_token_raises": raised,
        "mechanism": (
            "factor-string walk evaluates stored tokens; structural left/right "
            "metadata alone cannot keep a corrupted factors list silent"
        ),
    }


def main() -> None:
    dag_path = C5 / "morita_generic_dag.json"
    split_path = C5 / "morita_generic_split_dag.json"
    dag = json.loads(dag_path.read_text())
    split = json.loads(split_path.read_text())
    assert dag["format"] == "c5-generic-normalized-morita-dag-v1"
    assert split["format"] == "morita-generic-split-q0-lazy-v1"

    binding, env = load_fibre_context()
    assert binding["open_witnesses"]["pfaffian_Q"] == 17
    assert binding["open_witnesses"]["s"] == 3
    assert binding["open_witnesses"]["f14"] == 17

    homog = evaluate_homogeneous_dag(dag, env)
    independent = independent_corner_forms_fixed(env)
    assert homog["homogeneous_values_mod_p"] == independent
    residuals = seed_residuals(homog["homogeneous_values_mod_p"])
    assert residuals == [0, 0, 0, 0, 0]

    # q0=1 chart values must match the homogeneous restriction with u0..=u3 fixed
    chart0 = homog["chart_values_mod_p"][0]
    # constant term of form i is C_i((0,0),(0,0)) which is homogeneous monomial [0,0]
    pairs = [(left, right) for left in range(12) for right in range(left, 12)]
    pair_index = {pair: index for index, pair in enumerate(pairs)}
    for form_index in range(5):
        assert chart0[form_index][0] == independent[form_index][pair_index[(0, 0)]]

    split_result = eval_split_dag(split["nodes"], env)
    assert split_result["nodes_evaluated"] == 517
    assert split_result["s"] == 3
    assert split_result["e_trace"] == 2
    assert split_result["Delta_at_v0"] == 1  # sealed structural ansatz obstruction

    corruption = corruption_self_test(dag, env)
    assert corruption["values_differ"]
    assert corruption["unbound_token_raises"]

    sources = {
        "morita_generic_dag": {
            "path": str(dag_path.relative_to(ROOT)),
            "sha256": sha256(dag_path),
        },
        "morita_generic_split_dag": {
            "path": str(split_path.relative_to(ROOT)),
            "sha256": sha256(split_path),
        },
        "c2_morita": {
            "path": str((A7 / "c2_morita.json").relative_to(ROOT)),
            "sha256": sha256(A7 / "c2_morita.json"),
        },
        "compressed_algebra": {
            "path": str((CROOT / "compressed_algebra.json").relative_to(ROOT)),
            "sha256": sha256(CROOT / "compressed_algebra.json"),
        },
        "distinguished_five_plane": {
            "path": str((CROOT / "distinguished_five_plane.json").relative_to(ROOT)),
            "sha256": sha256(CROOT / "distinguished_five_plane.json"),
        },
        "char0_rur": {
            "path": str((A7 / "ambient_degree12_rur_char0.json").relative_to(ROOT)),
            "sha256": sha256(A7 / "ambient_degree12_rur_char0.json"),
        },
    }

    # Checksums of interpreted coefficient tables (not the full 390 list dump).
    homog_blob = json.dumps(homog["homogeneous_values_mod_p"], separators=(",", ":")).encode()
    chart_blob = json.dumps(homog["chart_values_mod_p"], separators=(",", ":")).encode()
    split_blob = json.dumps(split_result["original_roots_mod_p"], separators=(",", ":")).encode()

    binding_path = HERE / "source_leaf_binding.json"
    binding_payload = {
        "format": "c5-morita-source-leaf-binding-v1",
        "scope": (
            "prose-leaf binding and modular multiprime recipe table for Morita DAGs; "
            "not a K_proj-point and not full char-0 rational expansion"
        ),
        "field": "K_proj embedded; evaluation fibre F_23",
        "binding": binding,
        "source_sha256": sources,
        "theorem_boundary": (
            "Leaves are bound to sealed modular evaluation recipes at the accepted "
            "good fibre.  Full char-0 expansion into QQ(t3,t6,t8,t11) is not installed."
        ),
    }
    binding_path.write_text(json.dumps(binding_payload, indent=2) + "\n")

    probe = {
        "format": "c5-morita-record-interpreter-probe-v1",
        "exit_marker": "C5-MORITA-RECORD-INTERPRETER-P23-PASS",
        "gate": "G_MORITA_SOURCE_INTERPRETER",
        "status": "partial",
        "claims": {
            "consumes_stored_factor_strings": True,
            "consumes_split_dag_nodes": True,
            "matches_independent_corner_tables_p23": True,
            "seed_line_residuals_zero_p23": True,
            "corruption_self_test": True,
            "char0_K_proj_expansion": False,
            "holdout_prime_generic_P_bivector": False,
            "common_line_over_K_proj": False,
            "executable_full_incidence_exit": False,
        },
        "fibre": {
            "prime": P,
            "zeta11": ZETA,
            "source_point": list(POINT),
            "rur_root": 1,
            "sealed_residue_line": SEED,
            "seed_residuals": residuals,
        },
        "inventory": {
            "homogeneous_coefficients": 390,
            "normalized_chart_coefficients": 675,
            "ordered_terms_evaluated": homog["ordered_terms_evaluated"],
            "distinct_factor_tokens": homog["distinct_factor_tokens"],
            "split_dag_nodes_evaluated": split_result["nodes_evaluated"],
            "split_op_counts": split_result["op_counts"],
            "Delta_at_v0_mod_p": split_result["Delta_at_v0"],
            "Jminor_det_mod_p": split_result["Jminor_det"],
            "T_corner_to_entries_det_mod_p": split_result["T_corner_to_entries_det"],
        },
        "checksums_sha256": {
            "homogeneous_values_mod_p": hashlib.sha256(homog_blob).hexdigest(),
            "chart_values_mod_p": hashlib.sha256(chart_blob).hexdigest(),
            "split_original_roots_mod_p": hashlib.sha256(split_blob).hexdigest(),
            "source_leaf_binding": sha256(binding_path),
        },
        "corruption_self_test": corruption,
        "remaining_for_full_gate": [
            "bind and evaluate P,Q,B_i at a second unused good prime with independent bivector",
            "optional: lower coefficients to preferred length-12 K_proj normal form",
            "then G_HENSEL_ELIMINANT_LINEAR_FACTOR on q0=1 chart",
        ],
        "source_sha256": sources,
        "not_to_do": "see NOT_TO_DO.md (stale RUR quarantine; no L_a expansion; no Magma)",
    }
    (HERE / "interpreter_probe.json").write_text(json.dumps(probe, indent=2) + "\n")

    print("PASS source-leaf binding written")
    print(
        f"PASS evaluated {homog['ordered_terms_evaluated']} ordered terms; "
        f"tokens={homog['distinct_factor_tokens']}"
    )
    print("PASS homogeneous 5x78 matches independent corner tables mod 23")
    print(f"PASS sealed seed residuals={residuals}")
    print(
        f"PASS split DAG nodes={split_result['nodes_evaluated']} "
        f"Delta(v=0)={split_result['Delta_at_v0']} "
        f"Jminor={split_result['Jminor_det']} Tdet={split_result['T_corner_to_entries_det']}"
    )
    print(
        f"PASS corruption self-test differ={corruption['values_differ']} "
        f"raise={corruption['unbound_token_raises']}"
    )
    print("SCOPE modular record interpreter only; no K_proj common line")
    print("C5-MORITA-RECORD-INTERPRETER-P23-PASS")


if __name__ == "__main__":
    main()
