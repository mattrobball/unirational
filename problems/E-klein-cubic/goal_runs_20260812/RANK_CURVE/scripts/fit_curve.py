#!/usr/bin/env python3
"""Fit observations for the P3 curve. Every hit is an OBSERVATION, not a theorem.

Usage: python3 scripts/fit_curve.py
Reads results/p3_d*_p331.json plus the sealed 35..38 values.
"""
from __future__ import annotations

import json
import os
import sys

import paths
import lin

# Sealed LANDING_INVARIANT_SIDE values (post-flip cells).
SEALED = {
    35: {"P3": 1380, "K": 37, "I": 8555},
    36: {"P3": 1850, "K": 63, "I": 9545},
    37: {"P3": 2642, "K": 119, "I": 10614},
    38: {"P3": 3285, "K": 151, "I": 11776},
}


def load_curve():
    curve = {}
    for d, rec in SEALED.items():
        curve[d] = {
            "P3": rec["P3"],
            "K": rec["K"],
            "I_3d": rec["I"],
            "source": "LANDING_INVARIANT_SIDE sealed",
            "saturated": True,
        }
    for d in (39, 40, 41, 42):
        path = os.path.join(paths.RES, "p3_d%d_p331.json" % d)
        if not os.path.exists(path):
            continue
        r = json.load(open(path))
        curve[d] = {
            "P3": r.get("P3"),
            "K": r.get("K"),
            "I_3d": r.get("I_3d") or paths.I_3D[d],
            "source": "this packet",
            "saturated": r.get("saturated"),
            "p661": None,
        }
        p661 = os.path.join(paths.RES, "p3_d%d_p661.json" % d)
        if os.path.exists(p661):
            r2 = json.load(open(p661))
            curve[d]["p661"] = r2.get("P3")
            curve[d]["agree"] = r2.get("P3") == r.get("P3")
    return curve


def nmon3(K):
    return (K * (K + 1) * (K + 2)) // 6


def try_integer_poly(ds, ys, deg):
    """Exact integer polynomial of degree `deg` through the points, if any.

    Solves Vandermonde over Q via integer Cramer's rule in python ints.
    Returns coeffs c0..cdeg of sum c_k d^k, or None.
    """
    n = deg + 1
    if len(ds) < n:
        return None
    # Use the first n points to define, test the rest.
    xs = ds[:n]
    zs = ys[:n]
    # Gaussian elimination over rationals with python ints (frac as pairs).
    A = [[xs[i] ** j for j in range(n)] + [zs[i]] for i in range(n)]

    def add(a, b):
        return (a[0] * b[1] + b[0] * a[1], a[1] * b[1])

    def mul(a, b):
        return (a[0] * b[0], a[1] * b[1])

    def div(a, b):
        return (a[0] * b[1], a[1] * b[0])

    def simp(a):
        from math import gcd
        g = gcd(a[0], a[1])
        if g:
            a = (a[0] // g, a[1] // g)
        if a[1] < 0:
            a = (-a[0], -a[1])
        return a

    M = [[(A[i][j], 1) for j in range(n + 1)] for i in range(n)]
    for col in range(n):
        piv = None
        for i in range(col, n):
            if M[i][col][0] != 0:
                piv = i
                break
        if piv is None:
            return None
        M[col], M[piv] = M[piv], M[col]
        inv = div((1, 1), M[col][col])
        M[col] = [simp(mul(x, inv)) for x in M[col]]
        for i in range(n):
            if i == col:
                continue
            fac = M[i][col]
            M[i] = [simp(add(M[i][j], mul((-fac[0], fac[1]), M[col][j]))) for j in range(n + 1)]
    coeffs = [simp(M[i][n]) for i in range(n)]
    # test remaining points
    for d, y in zip(ds, ys):
        val_n, val_d = 0, 1
        for k, c in enumerate(coeffs):
            term = (c[0] * (d ** k), c[1])
            val_n = val_n * term[1] + term[0] * val_d
            val_d = val_d * term[1]
            from math import gcd
            g = gcd(val_n, val_d)
            if g:
                val_n //= g
                val_d //= g
        if val_d != 1 or val_n != y:
            return None
    if any(c[1] != 1 for c in coeffs):
        return [("frac", c[0], c[1]) for c in coeffs]
    return [c[0] for c in coeffs]


def load_molien():
    path = os.path.join(
        paths.ROOT, "goal_runs_20260812", "LANDING_KERNEL_STRUCTURE",
        "results", "molien_ext.json",
    )
    if not os.path.exists(path):
        # director probe script
        alt = os.path.join(paths.PROBE, "molien_ext126.py")
        return None, None, path
    D = json.load(open(path))
    I = D.get("I") or D.get("invariants")
    A = D.get("A") or D.get("covariants")
    return I, A, path


def molien_scans(ds, p3, I):
    """Small signed combinations of I(3d-offset). Observation only."""
    if I is None:
        return []
    def Iv(m):
        if m < 0 or m >= len(I):
            return 0
        return int(I[m])

    hits = []
    OMAX = 80
    # I(3d-a) - I(3d-b)
    for a in range(OMAX):
        for b in range(a + 1, OMAX + 8):
            if all(Iv(3 * d - a) - Iv(3 * d - b) == p3[d] for d in ds):
                hits.append("I(3d-%d)-I(3d-%d)" % (a, b))
    # I(k d - o)
    for mult in (1, 2, 3, 4):
        for o in range(-20, 140):
            if all(Iv(mult * d - o) == p3[d] for d in ds):
                hits.append("I(%dd-%d)" % (mult, o))
    # two-term signed, pruned on first degree
    d0 = ds[0]
    for a in range(0, 70):
        for b in range(a, 80):
            s0 = Iv(3 * d0 - a) + Iv(3 * d0 - b)
            r = s0 - p3[d0]
            if r < 0:
                continue
            for c in range(0, 90):
                if Iv(3 * d0 - c) != r:
                    continue
                if all(Iv(3 * d - a) + Iv(3 * d - b) - Iv(3 * d - c) == p3[d] for d in ds):
                    hits.append("I(3d-%d)+I(3d-%d)-I(3d-%d)" % (a, b, c))
    return hits[:40]


def main():
    curve = load_curve()
    ds = sorted(d for d in curve if curve[d]["P3"] is not None)
    p3 = {d: int(curve[d]["P3"]) for d in ds}
    Ks = {d: int(curve[d]["K"]) for d in ds}
    Is = {d: int(curve[d]["I_3d"]) for d in ds}

    rows = []
    for d in ds:
        P = p3[d]
        K = Ks[d]
        I3 = Is[d]
        rows.append({
            "d": d,
            "K": K,
            "N3": nmon3(K),
            "P3": P,
            "HF3": nmon3(K) - P,
            "I_3d": I3,
            "deficit": I3 - P,
            "P3_over_I": P / I3,
            "source": curve[d]["source"],
            "saturated": curve[d]["saturated"],
        })

    diffs = [p3[ds[i + 1]] - p3[ds[i]] for i in range(len(ds) - 1)]
    def2 = [diffs[i + 1] - diffs[i] for i in range(len(diffs) - 1)]
    def3 = [def2[i + 1] - def2[i] for i in range(len(def2) - 1)]
    defI = [Is[ds[i + 1]] - Is[ds[i]] - (p3[ds[i + 1]] - p3[ds[i]]) for i in range(len(ds) - 1)]

    poly_hits = {}
    ys = [p3[d] for d in ds]
    for deg in (1, 2, 3, 4):
        c = try_integer_poly(ds, ys, deg)
        poly_hits["deg_%d" % deg] = c

    I, A, mpath = load_molien()
    molien_hits = molien_scans(ds, p3, I) if I else []

    # even / odd subsequences
    even = [d for d in ds if d % 2 == 0]
    odd = [d for d in ds if d % 2 == 1]
    even_poly = try_integer_poly(even, [p3[d] for d in even], 2) if len(even) >= 3 else None
    odd_poly = try_integer_poly(odd, [p3[d] for d in odd], 2) if len(odd) >= 3 else None

    obs = {
        "headline": "OBSERVATION only — no closed form is claimed as a theorem",
        "curve": rows,
        "first_differences": diffs,
        "second_differences": def2,
        "third_differences": def3,
        "deficit_first_differences": defI,
        "integer_poly_through_all": poly_hits,
        "even_quadratic": even_poly,
        "odd_quadratic": odd_poly,
        "molien_combo_hits": molien_hits,
        "molien_source": mpath,
        "note": (
            "A unique interpolating polynomial of degree < n through n points "
            "is not evidence of a law. A hit is reported only if it holds at "
            "every computed degree in this packet. Molien combinations are a "
            "finite scan, not an exhaustive classification."
        ),
    }
    lin.dump(os.path.join(paths.RES, "curve_fit.json"), obs)
    print(json.dumps(obs, indent=2)[:4000])
    return 0


if __name__ == "__main__":
    sys.exit(main())
