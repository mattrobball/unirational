#!/usr/bin/env python3
"""Independent G7.2 scaling verifier.

Does not import produce.py. Deliberately rescales sample points and checks
projective outputs are unchanged; demonstrates silent-sum failure.
"""
from __future__ import annotations

import hashlib
import json
import random
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT / "certificates"))
import exact_weil_check as ew  # noqa: E402


def fail(msg: str) -> None:
    print(f"G7B_VERIFY_SCALING_FAIL: {msg}", file=sys.stderr)
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


def scale_v(v, lam):
    return [lam * x for x in v]


def invert_C(c: ew.C) -> ew.C:
    a = list(c.a)
    if all(x == 0 for x in a):
        raise ZeroDivisionError("zero")
    M = [[Q(0) for _ in range(10)] for _ in range(10)]
    for j in range(10):
        prod = c * ew.C(tuple(Q(1 if k == j else 0) for k in range(10)))
        for i in range(10):
            M[i][j] = prod.a[i]
    A = [row[:] + [Q(1 if i == 0 else 0)] for i, row in enumerate(M)]
    n = 10
    for col in range(n):
        piv = None
        for r in range(col, n):
            if A[r][col] != 0:
                piv = r
                break
        require(piv is not None, "non-unit")
        A[col], A[piv] = A[piv], A[col]
        pivval = A[col][col]
        A[col] = [x / pivval for x in A[col]]
        for r in range(n):
            if r == col:
                continue
            fac = A[r][col]
            if fac == 0:
                continue
            A[r] = [A[r][k] - fac * A[col][k] for k in range(n + 1)]
    inv = ew.C(tuple(A[i][n] for i in range(n)))
    require(c * inv == ew.C(1), "inv check")
    return inv


def normalize_chart(v):
    for i, x in enumerate(v):
        if x != ew.C(0):
            inv = invert_C(x)
            return [inv * y for y in v], i
    fail("zero vector")


def B_split(u, v, w):
    """Symmetric trilinear polarization of F = sum_i x_i^2 x_{i+1}."""
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
    bpqq = B_split(p, q, q)
    bppq = B_split(p, p, q)
    return [bpqq * p[i] - bppq * q[i] for i in range(5)]


def main() -> None:
    for name in (
        "INPUT_MANIFEST.json",
        "scaling_interface.json",
        "PROJECTIVE_SCALING.md",
        "STATUS.md",
        "verify_scaling.py",
        "produce.py",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    require("produce" not in sys.modules, "must not import produce")

    status = (HERE / "STATUS.md").read_text()
    first = status.splitlines()[0].strip()
    authorized = {
        "G7-PROJECTIVE-SCALING-PASS",
        "G7-INDUCED-DOUBLE-CYCLE-PASS",
        "G7-UNDECIDED",
    }
    require(first in authorized, f"STATUS first line not authorized: {first}")
    require(
        "G7-PROJECTIVE-SCALING-PASS" in status
        or first == "G7-INDUCED-DOUBLE-CYCLE-PASS",
        "STATUS must retain scaling pass when claiming induced pass",
    )

    scaling = json.loads((HERE / "scaling_interface.json").read_text())
    require(scaling.get("marker") == "G7-PROJECTIVE-SCALING-PASS", "scaling marker")
    require(scaling.get("silent_sum_forbidden") is True, "silent sum forbidden")
    require(
        scaling.get("schema") in ("g7b-projective-scaling-v1", "g7b-projective-scaling-v2"),
        "scaling schema",
    )

    samples = scaling["cone_lifts"].get("sample_points")
    if samples is None:
        # legacy path: do not accept induced-cycle binding as scaling authority
        fail("scaling_interface must store sample_points (v2); induced points are not scaling authority")

    n = scaling["cone_lifts"]["n_sample_points"]
    require(n >= 4, "need >=4 sample points")
    require(len(samples) == n, "sample count")

    rng = random.Random(20260802)

    def rand_scalar():
        n_ = rng.randint(1, 20)
        d = rng.randint(1, 20)
        sign = 1 if rng.random() < 0.5 else -1
        return ew.C(Q(sign * n_, d))

    all_points = []
    for sp in samples:
        raw = json_to_v(sp["homogeneous_coordinates_raw"])
        norm = json_to_v(sp["homogeneous_coordinates_normalized"])
        require(eval_F(raw) == ew.C(0), f"F raw sample {sp['sample_index']}")
        require(eval_F(norm) == ew.C(0), f"F norm sample {sp['sample_index']}")
        require(proj_eq(raw, norm), "raw~norm")
        renorm, chart = normalize_chart(raw)
        require(proj_eq(renorm, norm), "renorm match")
        require(
            chart == sp["normalization"]["chart_index"],
            "chart index",
        )
        lam = rand_scalar()
        scaled = scale_v(raw, lam)
        require(eval_F(scaled) == ew.C(0), "F scaled")
        require(proj_eq(scaled, raw), "proj after scale")
        s_norm, _ = normalize_chart(scaled)
        require(proj_eq(s_norm, norm), "chart renorm after scale")
        all_points.append((raw, norm))

    require(len(all_points) == n, "all samples")

    # Third-intersection scale invariance
    pair = None
    for a in range(n):
        for b in range(n):
            if a == b:
                continue
            pa, qb = all_points[a][1], all_points[b][1]
            r = third_intersection(pa, qb)
            if not all(x == ew.C(0) for x in r):
                pair = (pa, qb, r)
                break
        if pair:
            break
    require(pair is not None, "nonzero third sample")
    pa, qb, r = pair
    lam, mu = rand_scalar(), rand_scalar()
    r2 = third_intersection(scale_v(pa, lam), scale_v(qb, mu))
    require(proj_eq(r, r2), "third intersection scale-invariant")

    # Silent-sum failure demonstration
    va, vb = all_points[0][1], all_points[1][1]
    sum_norm = [va[i] + vb[i] for i in range(5)]
    va2, vb2 = scale_v(va, ew.C(2)), scale_v(vb, ew.C(3))
    sum_bad = [va2[i] + vb2[i] for i in range(5)]
    require(not proj_eq(sum_norm, sum_bad), "silent sum must break under unequal scales")

    # Manifest hashes
    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for item in man["inputs"]:
        ipath = ROOT / item["path"]
        require(ipath.is_file(), f"missing input {item['path']}")
        require(sha256(ipath) == item["sha256"], f"hash {item['path']}")

    # Scaling must not claim induced-cycle binding
    require(scaling.get("induced_cycle_binding") is not True, "no induced binding")

    print("G7B_VERIFY_SCALING_OK")
    print("G7-PROJECTIVE-SCALING-PASS")


if __name__ == "__main__":
    main()
