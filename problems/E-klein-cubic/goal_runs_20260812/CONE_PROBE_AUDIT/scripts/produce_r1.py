#!/usr/bin/env python3
"""R1: independent Jacobian rank + Euler control. Own derivative. Two primes."""
import json
import os
import sys

import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import paths
from cell37 import cell37, load_AC
from frame import build_frame
from linalg import rref_rank
from reynolds import covariant_jacobian, covariant_value, eval_at_points

assert "slicelib" not in sys.modules


def one_prime(p, ntrials=5, seed=0xE56A0D17):
    print("== R1 Jacobian, p=%d" % p, flush=True)
    fr = build_frame(p, verbose=True)
    A, C = load_AC()
    cell = cell37(p)
    B = cell["B37"]
    rng = np.random.default_rng(seed + p)
    rec = {
        "p": p,
        "cell_shape": list(B.shape),
        "rank_U": cell["rank_U"],
        "cell_ranks": [],
        "ambient_ranks": [],
        "euler_ok": [],
        "dual_check_ok": [],
        "value_match_ok": [],
    }
    for t in range(ntrials):
        c = rng.integers(1, p, size=37)
        vec = (c @ B) % p
        w = rng.integers(1, p, size=5)
        J = covariant_jacobian(fr, A, C, vec, w)
        Tw = covariant_value(fr, A, C, vec, w)
        r = rref_rank(J, p)
        lhs = (J @ w) % p
        rhs = (paths.DEG * Tw) % p
        euler = bool(np.array_equal(lhs, rhs))
        # Independent value check: Reynolds values contracted vs covariant_value
        V = eval_at_points(fr, A, C, np.array([w]), deg=paths.DEG, batch=1)
        Tw2 = (vec @ V[:, 0, :]) % p
        val_ok = bool(np.array_equal(Tw, Tw2))
        rec["cell_ranks"].append(int(r))
        rec["euler_ok"].append(euler)
        rec["value_match_ok"].append(val_ok)
        print("  cell %d: rank=%d Euler=%s val=%s" % (t, r, euler, val_ok), flush=True)
        if not euler:
            rec["euler_fail"] = {"t": t, "lhs": lhs.tolist(), "rhs": rhs.tolist()}
    for t in range(ntrials):
        vec = rng.integers(0, p, size=paths.NSEED)
        w = rng.integers(1, p, size=5)
        J = covariant_jacobian(fr, A, C, vec, w)
        r = rref_rank(J, p)
        rec["ambient_ranks"].append(int(r))
        print("  ambient %d: rank=%d" % (t, r), flush=True)
    rec["cell_generic_rank"] = max(rec["cell_ranks"]) if rec["cell_ranks"] else None
    rec["all_cell_rank5"] = all(x == 5 for x in rec["cell_ranks"])
    rec["all_euler"] = all(rec["euler_ok"])
    rec["all_ambient_rank5"] = all(x == 5 for x in rec["ambient_ranks"])
    if rec["all_cell_rank5"] and rec["all_euler"]:
        rec["verdict"] = "CONFIRMED"
    elif rec["all_euler"] and rec["cell_generic_rank"] != 5:
        rec["verdict"] = "REFUTED"
    else:
        rec["verdict"] = "CORRECTED"
    print("  verdict", rec["verdict"], flush=True)
    return rec


def main():
    os.makedirs(paths.RES, exist_ok=True)
    out = {"primes": {}, "verdict": None}
    for p in paths.PRIMES:
        rec = one_prime(p)
        out["primes"][str(p)] = rec
        path = os.path.join(paths.RES, "r1_p%d.json" % p)
        with open(path, "w") as f:
            json.dump(rec, f, indent=1)
    vs = [out["primes"][str(p)]["verdict"] for p in paths.PRIMES]
    if vs == ["CONFIRMED", "CONFIRMED"]:
        out["verdict"] = "CONFIRMED"
    elif "REFUTED" in vs:
        out["verdict"] = "REFUTED"
    else:
        out["verdict"] = "CORRECTED"
    with open(os.path.join(paths.RES, "r1_summary.json"), "w") as f:
        json.dump(out, f, indent=1)
    print("R1", out["verdict"], flush=True)
    return out


if __name__ == "__main__":
    main()
