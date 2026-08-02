#!/usr/bin/env python3
"""Independent verification of the Morita record interpreter packet.

Does not import produce_record_interpreter.  Rebuilds the accepted fibre,
walks stored factor strings and split-DAG nodes, checks sealed hashes, and
re-runs the corruption self-test.
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


def pfaffian_mod(matrix: np.ndarray, prime: int = P) -> int:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = matrix.shape[0]
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


def resolve_factor(token: str, env: dict) -> np.ndarray:
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
    raise KeyError(token)


def evaluate_term(term: dict, env: dict) -> int:
    assert term["operation"] == "matrix_trace_of_ordered_product"
    product = np.eye(6, dtype=np.int64) % P
    for token in term["factors"]:
        product = product @ resolve_factor(token, env) % P
    den = 2 * pow(env["s"], 3, P) % P
    return (-int(np.trace(product) % P)) * pow(den, -1, P) % P


def main() -> None:
    binding = json.loads((HERE / "source_leaf_binding.json").read_text())
    probe = json.loads((HERE / "interpreter_probe.json").read_text())
    assert binding["format"] == "c5-morita-source-leaf-binding-v1"
    assert probe["format"] == "c5-morita-record-interpreter-probe-v1"
    assert probe["exit_marker"] == "C5-MORITA-RECORD-INTERPRETER-P23-PASS"
    assert probe["claims"]["common_line_over_K_proj"] is False
    assert probe["claims"]["executable_full_incidence_exit"] is False

    dag_path = C5 / "morita_generic_dag.json"
    split_path = C5 / "morita_generic_split_dag.json"
    assert probe["source_sha256"]["morita_generic_dag"]["sha256"] == sha256(dag_path)
    assert probe["source_sha256"]["morita_generic_split_dag"]["sha256"] == sha256(
        split_path
    )
    assert probe["source_sha256"]["c2_morita"]["sha256"] == sha256(A7 / "c2_morita.json")
    assert probe["checksums_sha256"]["source_leaf_binding"] == sha256(
        HERE / "source_leaf_binding.json"
    )

    dag = json.loads(dag_path.read_text())
    split = json.loads(split_path.read_text())

    producer = runpy.run_path(str(A7 / "produce_c2_morita.py"))
    e, Q, domain_basis, pairs, wedge = producer["modular_projector"]()
    P_matrix = producer["skew"](wedge, pairs)
    s = int(np.dot(domain_basis @ np.asarray(POINT, dtype=np.int64) % P, wedge) % P)
    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    frame = c3["load_c2_helpers"]()["build_projective_reynolds_frame"](P, ZETA)
    mats = [value % P for value in frame["basis_mats"]]
    identity = np.eye(6, dtype=np.int64) % P
    M = [identity, mats[1], mats[2], mats[3]]
    G = [identity, mats[1], mats[2]]
    names, hilbert = producer["hilbert90_values"]()
    B = [
        producer["skew"](domain_basis @ np.asarray(v, dtype=np.int64) % P, pairs)
        for v in hilbert
    ]
    env = {
        "P_matrix": P_matrix,
        "Q": Q,
        "a": mats[1],
        "b": mats[2],
        "B": B,
        "M": M,
        "G": G,
        "s": s,
        "e": e,
    }
    assert pfaffian_mod(Q) == 17 and s == 3 and frame["denominator"] == 17
    assert binding["binding"]["open_witnesses"]["pfaffian_Q"] == 17

    # Walk every stored homogeneous factor string.
    homogeneous = []
    term_count = 0
    tokens = set()
    for form in dag["homogeneous_model"]["forms"]:
        row = []
        for record in form["coefficients"]:
            value = 0
            for term in record["ordered_trace_terms"]:
                tokens.update(term["factors"])
                value = (value + evaluate_term(term, env)) % P
                term_count += 1
            row.append(value)
        homogeneous.append(row)
    assert term_count > 0
    assert len(homogeneous) == 5 and all(len(r) == 78 for r in homogeneous)

    # Independent corner tables from sealed c2 witness.
    c2 = json.loads((A7 / "c2_morita.json").read_text())
    witness = c2["good_fibre_witness"]
    table = witness["corner_multiplication_left_right_coordinates"]
    star = np.asarray(witness["corner_star_matrix_columns"], dtype=np.int64) % P
    hermitian = witness["hermitian_matrices_D_coordinates"]
    units = [np.eye(4, dtype=np.int64)[i] for i in range(4)]

    def corner_mul(left, right):
        answer = np.zeros(4, dtype=np.int64)
        for i, lc in enumerate(left):
            for j, rc in enumerate(right):
                if lc and rc:
                    answer += int(lc) * int(rc) * np.asarray(table[i][j], dtype=np.int64)
        return answer % P

    independent = []
    pairs12 = [(i, j) for i in range(12) for j in range(i, 12)]
    for matrix in hermitian:
        coeffs = []
        for left, right in pairs12:
            lr, lb = divmod(left, 4)
            rr, rb = divmod(right, 4)

            def ord_pair(row, basis, col, obasis, matrix=matrix):
                first = corner_mul(
                    star @ units[basis] % P,
                    np.asarray(matrix[row][col], dtype=np.int64) % P,
                )
                return corner_mul(first, units[obasis])

            value = ord_pair(lr, lb, rr, rb)
            if left != right:
                value = (value + ord_pair(rr, rb, lr, lb)) % P
            assert not np.any(value[1:])
            coeffs.append(int(value[0]) % P)
        independent.append(coeffs)
    assert homogeneous == independent

    residuals = []
    for form in homogeneous:
        value = 0
        for coeff, (i, j) in zip(form, pairs12):
            value += coeff * SEED[i] * SEED[j]
        residuals.append(value % P)
    assert residuals == [0, 0, 0, 0, 0]

    homog_blob = json.dumps(homogeneous, separators=(",", ":")).encode()
    assert (
        hashlib.sha256(homog_blob).hexdigest()
        == probe["checksums_sha256"]["homogeneous_values_mod_p"]
    )

    # Walk every normalized chart record (675).
    chart_term_count = 0
    chart_values = []
    for chart in dag["normalized_charts"]:
        chart_forms = []
        for form in chart["forms"]:
            row = []
            for record in form["coefficients"]:
                value = 0
                for term in record["ordered_trace_terms"]:
                    tokens.update(term["factors"])
                    value = (value + evaluate_term(term, env)) % P
                    chart_term_count += 1
                row.append(value)
            chart_forms.append(row)
        chart_values.append(chart_forms)
    chart_blob = json.dumps(chart_values, separators=(",", ":")).encode()
    assert (
        hashlib.sha256(chart_blob).hexdigest()
        == probe["checksums_sha256"]["chart_values_mod_p"]
    )
    assert term_count + chart_term_count == probe["inventory"]["ordered_terms_evaluated"]
    assert sorted(tokens) == probe["inventory"]["distinct_factor_tokens"]

    # Evaluate split DAG source and structural nodes (full walk of 517).
    nodes = split["nodes"]
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
                value = P_matrix
            elif source == "aligned_pfaffian_matrix_Q(x)":
                value = Q
            elif source == "compressed_algebra_generator_a":
                value = mats[1]
            elif source == "compressed_algebra_generator_b":
                value = mats[2]
            else:
                section = source[source.index("V_") + 2 : source.index("(x)")]
                value = B[{"x": 0, "C": 1, "D": 2, "E": 3, "K": 4}[section]]
        elif op == "pairing":
            value = 0
            for i in range(6):
                for j in range(i + 1, 6):
                    value += int(Q[i, j]) * int(P_matrix[i, j])
            value %= P
        elif op == "matmul":
            value = eval_node(args[0]) @ eval_node(args[1]) % P
        elif op == "scale_by_inverse":
            mat_v = eval_node(args[0])
            scalar = int(eval_node(args[1])) % P
            value = mat_v * (spec.get("scalar", 1) * pow(scalar, -1, P) % P) % P
        elif op == "alias":
            value = eval_node(args[0])
        elif op == "select_columns":
            value = eval_node(args[0])[:, list(spec["columns"])] % P
        elif op == "select_rows":
            value = eval_node(args[0])[list(spec["rows"]), :] % P
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
            t_inv = np.asarray(eval_node(args[0]), dtype=np.int64) % P
            originals = [int(eval_node(arg)) for arg in args[1:]]
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
            elif tl == 0 or tr == 0:
                target = (tr if tl == 0 else tl) - 1
                value = sum(
                    int(original[0, source + 1]) * int(transform[source, target])
                    for source in range(8)
                ) % P
            else:
                left, right = tl - 1, tr - 1
                if left == right:
                    value = sum(
                        int(original[s + 1, s + 1]) * int(transform[s, left]) ** 2
                        for s in range(8)
                    )
                    value += sum(
                        int(original[s + 1, o + 1])
                        * int(transform[s, left])
                        * int(transform[o, left])
                        for s in range(8)
                        for o in range(s + 1, 8)
                    )
                else:
                    value = sum(
                        2
                        * int(original[s + 1, s + 1])
                        * int(transform[s, left])
                        * int(transform[s, right])
                        for s in range(8)
                    )
                    value += sum(
                        int(original[s + 1, o + 1])
                        * (
                            int(transform[s, left]) * int(transform[o, right])
                            + int(transform[s, right]) * int(transform[o, left])
                        )
                        for s in range(8)
                        for o in range(s + 1, 8)
                    )
                value %= P
        elif op == "affine_polynomial":
            value = {
                "affine_coeffs": [int(eval_node(arg)) for arg in args],
                "variables": spec.get("variables"),
            }
        elif op == "determinant_polynomial":
            shape = spec["shape"]
            entries = [eval_node(arg) for arg in args]
            mat = np.zeros(shape, dtype=np.int64)
            for index, entry in enumerate(entries):
                row, col = divmod(index, shape[1])
                mat[row, col] = (
                    int(entry["affine_coeffs"][0])
                    if isinstance(entry, dict)
                    else int(entry)
                ) % P
            value = det_mod(mat)
        elif op == "determinant":
            shape = spec["shape"]
            entries = [int(eval_node(arg)) % P for arg in args]
            value = det_mod(np.asarray(entries, dtype=np.int64).reshape(shape))
        else:
            raise KeyError(op)
        cache[name] = value
        return value

    for name in nodes:
        eval_node(name)
    assert len(cache) == 517
    assert int(cache["s"]) == 3
    assert int(cache["Delta_at_v0"]) == 1
    assert det_mod(cache["Jminor"]) == 5
    assert det_mod(cache["T_corner_to_entries"]) == 18
    assert int(np.trace(cache["e"]) % P) == 2
    roots = [int(cache[f"c{f}_{i}"]) for f in range(5) for i in range(45)]
    roots_blob = json.dumps(roots, separators=(",", ":")).encode()
    assert (
        hashlib.sha256(roots_blob).hexdigest()
        == probe["checksums_sha256"]["split_original_roots_mod_p"]
    )

    # Corruption self-test on stored factors.
    record = json.loads(
        json.dumps(dag["homogeneous_model"]["forms"][0]["coefficients"][0])
    )
    original = sum(evaluate_term(t, env) for t in record["ordered_trace_terms"]) % P
    term0 = record["ordered_trace_terms"][0]
    term0["factors"][term0["factors"].index("P")] = "Q"
    corrupted = sum(evaluate_term(t, env) for t in record["ordered_trace_terms"]) % P
    assert original != corrupted
    raised = False
    try:
        term0["factors"][0] = "NOT_A_LEAF"
        evaluate_term(term0, env)
    except KeyError:
        raised = True
    assert raised
    assert probe["corruption_self_test"]["values_differ"] is True
    assert probe["corruption_self_test"]["unbound_token_raises"] is True

    # Binding leaf inventory completeness.
    leaves = binding["binding"]["leaves"]
    for key in [
        "P",
        "Q",
        "a",
        "b",
        "B0",
        "B1",
        "B2",
        "B3",
        "B4",
        "M[0]",
        "M[1]",
        "M[2]",
        "M[3]",
        "G[0]",
        "G[1]",
        "G[2]",
        "s",
        "e",
    ]:
        assert key in leaves

    print("PASS sealed source hashes and binding checksum")
    print(
        f"PASS walked {term_count} homogeneous + {chart_term_count} chart ordered terms "
        f"with tokens={sorted(tokens)}"
    )
    print("PASS factor-string evaluation equals independent corner Hermitian tables mod 23")
    print(f"PASS sealed seed residuals={residuals}")
    print(
        "PASS split DAG 517-node walk: s=3 e_tr=2 Delta(0)=1 "
        f"Jminor=5 Tdet=18"
    )
    print("PASS corruption self-test (P->Q differs; unbound raises)")
    print("SCOPE G_MORITA_SOURCE_INTERPRETER partial at p=23; no K_proj point")
    print("C5-MORITA-RECORD-INTERPRETER-P23-PASS")


if __name__ == "__main__":
    main()
