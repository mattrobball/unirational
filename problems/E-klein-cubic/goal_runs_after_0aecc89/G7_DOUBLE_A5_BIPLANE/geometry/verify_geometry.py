#!/usr/bin/env python3
"""Independent G7C geometry verifier.

Does not import produce_geometry.py. Recomputes polarization, third intersections,
operation-space landing constraints, and residual census from sealed G7A/G7B
inputs and the geometry packet JSON.
"""
from __future__ import annotations

import hashlib
import json
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402

DESIGN = ROOT / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/design"
CYCLES = ROOT / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles"
G3A = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"


def fail(msg: str) -> None:
    print(f"G7C_VERIFY_GEOMETRY_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            h.update(c)
    return h.hexdigest()


def json_to_c(coords10):
    return ew.C(tuple(Q(n, d) for n, d in coords10))


def json_to_v(homog):
    return [json_to_c(c) for c in homog]


def eval_F(v):
    total = ew.C(0)
    for i in range(5):
        total = total + v[i] * v[i] * v[(i + 1) % 5]
    return total


def proj_eq(u, v) -> bool:
    for i in range(5):
        for j in range(i + 1, 5):
            if u[i] * v[j] != u[j] * v[i]:
                return False
    return True


def is_zero_v(v) -> bool:
    return all(x == ew.C(0) for x in v)


def is_rational_v(v) -> bool:
    return all(all(c.a[k] == 0 for k in range(1, 10)) for c in v)


def invert_C(c: ew.C) -> ew.C:
    M = [[Q(0) for _ in range(10)] for _ in range(10)]
    for j in range(10):
        prod = c * ew.C(tuple(Q(1 if k == j else 0) for k in range(10)))
        for i in range(10):
            M[i][j] = prod.a[i]
    A = [row[:] + [Q(1 if i == 0 else 0)] for i, row in enumerate(M)]
    for col in range(10):
        piv = next((r for r in range(col, 10) if A[r][col] != 0), None)
        require(piv is not None, "non-unit")
        A[col], A[piv] = A[piv], A[col]
        pivval = A[col][col]
        A[col] = [x / pivval for x in A[col]]
        for r in range(10):
            if r == col:
                continue
            fac = A[r][col]
            if fac:
                A[r] = [A[r][k] - fac * A[col][k] for k in range(11)]
    inv = ew.C(tuple(A[i][10] for i in range(10)))
    require(c * inv == ew.C(1), "inv")
    return inv


def B_split(u, v, w):
    total = ew.C(0)
    for i in range(5):
        ip = (i + 1) % 5
        total = total + (
            u[i] * v[i] * w[ip]
            + u[i] * w[i] * v[ip]
            + v[i] * w[i] * u[ip]
        )
    return total / 3


def third_intersection(p, q):
    return [B_split(p, q, q) * p[i] - B_split(p, p, q) * q[i] for i in range(5)]


def main() -> None:
    # produce must not be required as import
    require("produce_geometry" not in sys.modules, "producer imported")

    for name in (
        "INPUT_MANIFEST.json",
        "operations.json",
        "residual_cycles.json",
        "effective_cycles.json",
        "CROSS_OPERATIONS.md",
        "THIRD_INTERSECTIONS.md",
        "EFFECTIVE_CYCLES.md",
        "STATUS.md",
        "REPLAY.md",
        "produce_geometry.py",
        "verify_geometry.py",
        "verify_point.py",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("G7-RESIDUAL-GEOMETRY-PASS"), "STATUS exit")
    require("OPEN" in status, "headline open")
    require("G7-POINT-HEADLINE-POSITIVE" not in status.splitlines()[0], "no point headline")
    require(
        "G7-EFFECTIVE-DEGREE2-HEADLINE-POSITIVE" not in status.splitlines()[0],
        "no deg2 headline",
    )

    # binding inputs
    require(
        (DESIGN / "STATUS.md").read_text().startswith("G7-CROSS-CLASS-PROJECTOR-PASS")
        or (DESIGN / "STATUS.md").read_text().startswith("G7-PALEY-BIPLANE-IDENTIFIED"),
        "design exit",
    )
    require(
        (CYCLES / "STATUS.md").read_text().startswith("G7-INDUCED-DOUBLE-CYCLE-PASS"),
        "cycles exit",
    )
    require(
        (G3A / "STATUS.md").read_text().startswith("G3A-ARITHMETIC-DOMINANCE-PASS"),
        "g3a exit",
    )

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for item in man["inputs"]:
        ipath = ROOT / item["path"]
        require(ipath.is_file(), f"missing input {item['path']}")
        require(sha256(ipath) == item["sha256"], f"hash {item['path']}")

    cycles = json.loads((CYCLES / "cycles.json").read_text())
    incidence = json.loads((CYCLES / "incidence_correspondence.json").read_text())
    N = incidence["incidence_matrix_N_coset"]
    require(sum(sum(r) for r in N) == 55, "55 incident")

    P, Qpts = [], []
    for cl in cycles["classes"]:
        pts = [
            json_to_v(c["G3_frame_coordinates"]["homogeneous_coordinates_normalized"])
            for c in cl["conjugates"]
        ]
        for p in pts:
            require(eval_F(p) == ew.C(0), "F(p)=0")
        if cl["class_index"] == 1:
            P = pts
        else:
            Qpts = pts
    require(len(P) == 11 and len(Qpts) == 11, "11+11")

    # polarization identity B(x,x,x)=F
    for p in (P[0], P[3], Qpts[2], Qpts[7]):
        require(B_split(p, p, p) == eval_F(p), "B(x,x,x)=F")

    # third intersection formula vs parametric root
    p, q = P[1], Qpts[4]
    if not proj_eq(p, q):
        r = third_intersection(p, q)
        bppq, bpqq = B_split(p, p, q), B_split(p, q, q)
        if bpqq != ew.C(0) and not is_zero_v(r):
            u = ew.C(0) - bppq * invert_C(bpqq)
            alt = [p[k] + u * q[k] for k in range(5)]
            require(proj_eq(r, alt), "third formula")
            require(eval_F(r) == ew.C(0), "F(r)=0")

    # full residual census independent of producer JSON
    status_counts = {
        "ok": 0,
        "line_on_cubic": 0,
        "coincide_pq": 0,
        "coincide_r_p": 0,
        "coincide_r_q": 0,
    }
    n_inc = n_non = 0
    n_rat = 0
    n_line_inc = 0
    for i in range(11):
        for j in range(11):
            inc = bool(N[i][j])
            if inc:
                n_inc += 1
            else:
                n_non += 1
            pi, qj = P[i], Qpts[j]
            if proj_eq(pi, qj):
                status_counts["coincide_pq"] += 1
                continue
            bppq, bpqq = B_split(pi, pi, qj), B_split(pi, qj, qj)
            if bppq == ew.C(0) and bpqq == ew.C(0):
                status_counts["line_on_cubic"] += 1
                if inc:
                    n_line_inc += 1
                continue
            r = third_intersection(pi, qj)
            require(not is_zero_v(r), f"zero r {i},{j}")
            require(eval_F(r) == ew.C(0), f"F(r) {i},{j}")
            if proj_eq(r, pi):
                status_counts["coincide_r_p"] += 1
            elif proj_eq(r, qj):
                status_counts["coincide_r_q"] += 1
            else:
                status_counts["ok"] += 1
            if is_rational_v(r):
                n_rat += 1

    require(n_inc == 55 and n_non == 66, "55+66")
    require(n_rat == 0, "no Q-rational residual thirds")

    residual = json.loads((HERE / "residual_cycles.json").read_text())
    require(residual["n_incident"] == 55, "json incident")
    require(residual["n_nonincident"] == 66, "json nonincident")
    require(residual["n_rational_residual_Q"] == 0, "json rat")
    require(residual["status_counts"]["line_on_cubic"] == status_counts["line_on_cubic"],
            "line count match")
    require(residual["status_counts"]["coincide_pq"] == status_counts["coincide_pq"],
            "coincide match")
    require(
        residual["status_counts"]["ok"] + residual["status_counts"].get("coincide_r_p", 0)
        + residual["status_counts"].get("coincide_r_q", 0)
        == status_counts["ok"] + status_counts["coincide_r_p"] + status_counts["coincide_r_q"],
        "residual ok total",
    )
    require(residual["search"]["effective_degree_two_subscheme"] is False, "no eff deg2")
    require(residual["search"]["K_proj_rational_residual_component"] is False, "no K_proj res")

    # operations landing
    ops = json.loads((HERE / "operations.json").read_text())
    require(ops["summary"]["n_nonzero_on_cubic"] == 0, "no op on cubic")
    require(ops["summary"]["n_rational_on_cubic"] == 0, "no rat op on cubic")
    require(ops["landing"]["K_proj_point_from_ops"] is False, "no point from ops")
    require(ops["n_operations"] >= 80, "op space size")
    require(ops["projector_correction"].startswith("1+10"), "1+10 projectors")

    # independent recompute of a few ops: incidence sum landing
    for i in (0, 5, 10):
        s = [ew.C(0)] * 5
        for j in range(11):
            if N[i][j]:
                for k in range(5):
                    s[k] = s[k] + Qpts[j][k]
        require(not is_zero_v(s), f"inc sum {i} nonzero")
        require(eval_F(s) != ew.C(0), f"inc sum {i} off cubic")

    # sum_P off cubic
    sumP = [sum((P[i][k] for i in range(11)), ew.C(0)) for k in range(5)]
    require(eval_F(sumP) != ew.C(0), "sumP off cubic")

    # effective / bridge
    eff = json.loads((HERE / "effective_cycles.json").read_text())
    require(eff["K_proj_point_of_X_gen"] is False, "no K_proj point")
    require(eff["effective_length_two_over_K_proj"] is False, "no eff2")
    require(eff["bridge"]["BRIDGE_DOUBLE_A5_POS"] is False, "no bridge")
    require(not (HERE / "BRIDGE_DOUBLE_A5_POS.md").is_file(), "bridge file absent")
    require(not (HERE / "POINT.md").is_file(), "POINT.md absent")

    # scale-safety: third intersection invariant under rescale
    p, q = P[2], Qpts[3]
    if not proj_eq(p, q):
        r1 = third_intersection(p, q)
        r2 = third_intersection(
            [ew.C(3) * x for x in p],
            [ew.C(Q(2, 5)) * x for x in q],
        )
        if not is_zero_v(r1):
            require(proj_eq(r1, r2), "third scale invariant")

    # silent sum failure demo (same as G7B contract)
    va, vb = P[0], P[1]
    sum_n = [va[i] + vb[i] for i in range(5)]
    sum_b = [ew.C(2) * va[i] + ew.C(3) * vb[i] for i in range(5)]
    require(not proj_eq(sum_n, sum_b), "silent sum breaks")

    print("G7C_VERIFY_GEOMETRY_OK")
    print("G7-RESIDUAL-GEOMETRY-PASS")


if __name__ == "__main__":
    main()
