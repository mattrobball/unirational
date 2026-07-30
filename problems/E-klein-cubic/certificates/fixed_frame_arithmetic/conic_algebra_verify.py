#!/usr/bin/env python3
"""Independent verifier for Path F F1-P conic-algebra interface.

Does not import the producer under tmp/pathF_frame/. Replays five-form
reconstruction and the fixed-direction residual identity from accepted
upstream certificates only.
"""

from __future__ import annotations

import importlib.util
import json
import os
import resource
import sys
from hashlib import sha256
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
CERTIFICATE = HERE / "conic_algebra_inputs.json"
CEILING = 2 * 1024**3
CAP_ENV = "PATHF_CONIC_ALGEBRA_VERIFY_MIB"


def enforce_limit() -> str:
    try:
        resource.setrlimit(resource.RLIMIT_AS, (CEILING, CEILING))
        return "RLIMIT_AS=2147483648"
    except (OSError, ValueError):
        if sys.platform != "darwin":
            raise
        if os.environ.get(CAP_ENV) == "2048":
            return "taskpolicy -m 2048"
        environment = dict(os.environ)
        environment[CAP_ENV] = "2048"
        os.execve(
            "/usr/sbin/taskpolicy",
            ["taskpolicy", "-m", "2048", sys.executable, *sys.argv],
            environment,
        )
        raise AssertionError("taskpolicy exec unexpectedly returned")


CAP_BACKEND = enforce_limit()


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> None:
    cert = json.loads(CERTIFICATE.read_text())
    assert cert["format"] == "pathF-F1P-conic-algebra-inputs-v1"
    assert cert["fork"] == "F1-P"
    assert cert["headline"] == "OPEN"

    # Independent load of accepted torsor/valuation arithmetic (same as global
    # fixed-frame hostile audit), not the pathF producer.
    source = load_module(
        "pathf_conic_upstream",
        ROOT / "tmp/pfaffian_torsor_valuation_attack/verify.py",
    )
    al = source.alignment
    K = al.K11
    ZERO = al.KZERO
    ONE = al.KONE

    def ser(value):
        return [[int(a), int(b)] for a, b in source.serialize(value)]

    def from_ser(coords):
        return al.from_coefficients(coords, K)

    primary = json.loads(source.PRIMARY.read_text())
    rows = source.normalized_rows(primary)

    q_a = [rows[i]["f3*f6"] for i in (3, 4, 5)]
    q_0 = [rows[i]["f3^3"] for i in (3, 4, 5)]
    q_y = [rows[i]["f9"] for i in (3, 4, 5)]
    r_a2 = [rows[i]["f6^2"] for i in (6, 7, 8, 9)]
    r_a = [rows[i]["f3^2*f6"] for i in (6, 7, 8, 9)]
    r_0 = [rows[i]["f3^4"] for i in (6, 7, 8, 9)]
    r_b = [rows[i]["f7*f5"] for i in (6, 7, 8, 9)]
    r_y = [rows[i]["f9*f3"] for i in (6, 7, 8, 9)]
    r_z = [rows[i]["f12"] for i in (6, 7, 8, 9)]

    kappa = r_a2[0] / r_z[0]
    assert kappa == K(-11) / K(18)
    assert all(left == kappa * right for left, right in zip(r_a2, r_z))
    assert ser(kappa) == cert["curve_over_F"]["kappa"]
    assert cert["curve_over_F"]["kappa_equals"] == "-11/18"
    assert cert["curve_over_F"]["index"] == 3
    assert cert["curve_over_F"]["F_point"] is False
    assert cert["curve_over_F"]["Pic0_F"] == 0
    assert cert["extension"]["K_proj_over_F"] == 6
    assert cert["extension"]["no_proper_intermediate_fields"] is True

    def ternary(q, r, include_x3=False):
        return [ONE if include_x3 else ZERO, ZERO, ZERO, *q, *r]

    forms = {
        "F0": ternary(q_0, r_0, True),
        "FA": ternary(q_a, r_a),
        "FB": ternary([ZERO] * 3, r_b),
        "FY": ternary(q_y, r_y),
        "FZ": ternary([ZERO] * 3, r_z),
    }
    for name, coeffs in forms.items():
        assert [ser(c) for c in coeffs] == cert["five_forms"][name]

    def matrix_rank(matrix):
        work = [list(row) for row in matrix]
        rows_n, cols = len(work), len(work[0])
        pivot_row = 0
        for column in range(cols):
            pivot = next(
                (r for r in range(pivot_row, rows_n) if work[r][column] != ZERO),
                None,
            )
            if pivot is None:
                continue
            work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
            value = work[pivot_row][column]
            for j in range(column, cols):
                work[pivot_row][j] /= value
            for r in range(rows_n):
                if r == pivot_row or work[r][column] == ZERO:
                    continue
                sc = work[r][column]
                for j in range(column, cols):
                    work[r][j] -= sc * work[pivot_row][j]
            pivot_row += 1
            if pivot_row == rows_n:
                break
        return pivot_row

    assert matrix_rank(list(forms.values())) == 5

    # Fixed-direction residual identity (D5 constant direction).
    d5 = json.loads(
        (ROOT / "tmp/pfaffian_d5_constant_point/certificate.json").read_text()
    )
    t1 = from_ser(d5["binary_coordinates"]["t1_qzeta11"])
    x_pt = from_ser(d5["constant_point"]["original_X_qzeta11"])

    def eval_q(q, t):
        return q[0] * t * t + q[1] * t + q[2]

    def eval_r(r, t):
        return r[0] * t**3 + r[1] * t * t + r[2] * t + r[3]

    q0 = eval_q(q_0, t1)
    qa = eval_q(q_a, t1)
    qy = eval_q(q_y, t1)
    r0 = eval_r(r_0, t1)
    ra = eval_r(r_a, t1)
    rb = eval_r(r_b, t1)
    ry = eval_r(r_y, t1)
    rz = eval_r(r_z, t1)

    val_const = x_pt**3 + x_pt * q0 + r0
    val_a = x_pt * qa + ra
    val_y = x_pt * qy + ry
    val_b = rb
    val_z = rz
    assert val_const == ZERO
    assert val_a == ZERO
    assert val_y == ZERO
    assert val_z == ZERO
    assert val_b != ZERO
    assert qy != ZERO

    fd = cert["fixed_direction_exclusion"]
    assert ser(x_pt) == fd["point_X"]
    assert ser(t1) == fd["t1"]
    assert ser(val_const) == fd["residuals_at_point"]["const"]
    assert ser(val_a) == fd["residuals_at_point"]["A"]
    assert ser(val_y) == fd["residuals_at_point"]["Y"]
    assert ser(val_z) == fd["residuals_at_point"]["Z"]
    assert ser(val_b) == fd["residuals_at_point"]["B_coeff_RB"]

    # Scheme conditions: four numbered structural requirements present.
    conditions = {c["id"]: c for c in cert["scheme_conditions"]}
    assert set(conditions) == {1, 2, 3, 4}
    assert conditions[2]["not_unstructured_six_point_solve"] is True
    assert "mult-table" in conditions[2]["expression"]
    assert "traces" in conditions[2]["expression"]

    # Source hash pins (independent recompute).
    for rel, expected in cert["source_hashes"].items():
        path = ROOT / rel
        assert path.is_file(), rel
        assert file_hash(path) == expected, rel

    # Terminality audit and scheme writeup must exist beside this verifier.
    assert (HERE / "TERMINALITY_AUDIT.md").is_file()
    assert (HERE / "conic_algebra_scheme.md").is_file()
    audit = (HERE / "TERMINALITY_AUDIT.md").read_text()
    assert "F1-P" in audit
    assert "FAIL-SCOPE" in audit
    assert "conic-algebra solution" in audit
    assert "C(K_proj)" in audit
    assert "CFOSS I, Lemma 3.1" in audit
    assert "P^2_D" in audit or "P²_D" in audit

    peak = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    peak_bytes = int(peak if sys.platform == "darwin" else peak * 1024)
    print(f"cap_backend={CAP_BACKEND}")
    print(f"peak_bytes={peak_bytes}")
    print("FIXED_DIRECTION_RESIDUAL_IS_B_TIMES_RB_EXACT")
    print("PATH_F_F1P_CONIC_ALGEBRA_INTERFACE_ACCEPT")


if __name__ == "__main__":
    main()
