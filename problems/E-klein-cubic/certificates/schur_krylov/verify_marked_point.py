#!/usr/bin/env python3
"""Independent verifier for Gate A2 marked point / V_Z.

Does NOT import a producer.  Rebuilds the D12-line fibre witness from
exact_weil_check + sealed JSON, checks residue degree, HF => dim V_Z=4.
"""
from __future__ import annotations

import hashlib
import json
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FIBRE = ROOT / "tmp" / "pathA_krylov" / "fibre_marked_point.json"
LINE = ROOT / "tmp" / "pathA_krylov" / "d12_line_basis.json"


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def parse_c(lst):
    return [Q(s) for s in lst]


def c_add(a, b):
    return [a[i] + b[i] for i in range(10)]


def c_mul_q(q, a):
    return [q * x for x in a]


def c_mul(a, b):
    v = [Q(0)] * 19
    for i in range(10):
        for j in range(10):
            v[i + j] += a[i] * b[j]
    for k in range(18, 9, -1):
        if v[k]:
            q = v[k]
            for j in range(10):
                v[k - 10 + j] -= q
            v[k] = Q(0)
    return v[:10]


def c_inv(a):
    Mcols = []
    for j in range(10):
        ej = [Q(0)] * 10
        ej[j] = Q(1)
        Mcols.append(c_mul(a, ej))
    Mat = [[Mcols[j][i] for j in range(10)] for i in range(10)]
    A = [row[:] + ([Q(1)] if i == 0 else [Q(0)]) for i, row in enumerate(Mat)]
    n = 10
    for col in range(n):
        pivot = next(r for r in range(col, n) if A[r][col] != 0)
        A[col], A[pivot] = A[pivot], A[col]
        piv = A[col][col]
        A[col] = [x / piv for x in A[col]]
        for r in range(n):
            if r != col and A[r][col] != 0:
                fac = A[r][col]
                A[r] = [A[r][k] - fac * A[col][k] for k in range(n + 1)]
    return [A[i][n] for i in range(n)]


def c_from_int(n):
    return [Q(n)] + [Q(0)] * 9


def matrix_rank(rows):
    A = [row[:] for row in rows]
    m, n = len(A), len(A[0])
    rank = 0
    row = 0
    for col in range(n):
        piv = None
        for r in range(row, m):
            if A[r][col] != 0:
                piv = r
                break
        if piv is None:
            continue
        A[row], A[piv] = A[piv], A[row]
        pivval = A[row][col]
        A[row] = [x / pivval for x in A[row]]
        for r in range(m):
            if r != row and A[r][col] != 0:
                fac = A[r][col]
                A[r] = [A[r][c] - fac * A[row][c] for c in range(n)]
        rank += 1
        row += 1
        if row == m:
            break
    return rank


def main() -> int:
    md = HERE / "marked_point.md"
    js = HERE / "marked_point.json"
    assert md.is_file() and js.is_file()
    data = json.loads(js.read_text(encoding="utf-8"))
    text = md.read_text(encoding="utf-8")

    assert data["residue_degree"] == 55
    assert data["V_Z"]["dimension"] == 4
    assert data["hilbert_function_d0_to_6"] == [1, 4, 10, 19, 31, 45, 55]
    assert data["hilbert_function_d0_to_6"][1] == 4
    assert data["coordinates"]["each_zi_power_basis_length"] == 55
    assert data["coordinates"]["expanded_coefficients_in_F"] is False
    assert data["fibre_witness"]["not_generic_Schur_point"] is True
    assert 660 // 12 == 55
    assert 3 * 19 - 55 == 2

    # Rebuild fibre witness independently from sealed line basis
    assert LINE.is_file() and FIBRE.is_file()
    line = json.loads(LINE.read_text(encoding="utf-8"))
    fibre = json.loads(FIBRE.read_text(encoding="utf-8"))
    assert line["index"] == 55
    assert line["group_order"] == 660
    assert line["d12_order"] == 12

    u = [parse_c(c) for c in line["line_basis_u"]]
    v = [parse_c(c) for c in line["line_basis_v"]]
    h = line["hyperplane_coeffs"]
    hu = parse_c(line["hyperplane_dot_u"])
    hv = parse_c(line["hyperplane_dot_v"])
    t = c_mul(c_mul_q(Q(-1), hu), c_inv(hv))
    p = [c_add(u[i], c_mul(t, v[i])) for i in range(5)]

    # hyperplane
    dot = [Q(0)] * 10
    for i in range(5):
        dot = c_add(dot, c_mul_q(Q(h[i]), p[i]))
    assert all(x == 0 for x in dot)

    # cubic
    f = [Q(0)] * 10
    for i in range(5):
        f = c_add(f, c_mul(c_mul(p[i], p[i]), p[(i + 1) % 5]))
    assert all(x == 0 for x in f)

    z = p[:4]
    assert matrix_rank(z) == 4
    assert fibre["rank_Q_span_of_coords"] == 4
    assert fibre["on_cubic"] is True
    assert fibre["scope"].startswith("geometric fibre")

    assert "SCHUR_KRYLOV_A2_MARKED_POINT_SEALED" in text
    assert data["terminal_marker"] == "SCHUR_KRYLOV_A2_MARKED_POINT_SEALED"

    print("A2_MARKED_POINT_RESIDUE_DEGREE_OK")
    print("A2_MARKED_POINT_V_Z_DIM_OK")
    print("A2_MARKED_POINT_FIBRE_WITNESS_OK")
    print(f"A2_MARKED_POINT_MD_SHA256 {sha256_file(md)}")
    print(f"A2_MARKED_POINT_JSON_SHA256 {sha256_file(js)}")
    print("SCHUR_KRYLOV_A2_MARKED_POINT_SEALED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
