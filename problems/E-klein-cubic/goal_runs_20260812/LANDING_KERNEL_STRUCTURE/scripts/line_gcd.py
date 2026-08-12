#!/usr/bin/env python3
"""Fixed-divisor measurement for the landing system on the window cells.

For each degree d in {35,36,37,38} and prime p:
  - load the sealed post-flip cell basis Bcell (K x ns) and seed data (A, C)
    cached by LANDING_INVARIANT_SIDE/scripts/produce_p3.py;
  - restrict the landing cubics  y -> F(T_c(y))  to random affine lines
    y(t) = w + t v, evaluated at ALL t in F_p (exact, 3d < p);
  - interpolate each F(T_c(y(t))) as a univariate polynomial of degree <= 3d
    (validated against every remaining point of the line);
  - gcd over many random c  =  the fixed divisor of the landing system
    restricted to the line;  deg gcd = e(d) for a generic line;
  - factor structure: multiplicity profile via repeated gcd with derivative;
  - at common-zero t in F_p: rank of the evaluation matrix E_y (5 x K),
    and whether y is on the Klein cubic F.

Usage: python3 line_gcd.py [d ...] [p ...]   (d < 100 <= p)
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
ROOT = os.path.abspath(os.path.join(PACKET, "..", ".."))
D34 = os.path.join(ROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
LIS_RES = os.path.join(ROOT, "goal_runs_20260812", "LANDING_INVARIANT_SIDE", "results")
sys.path.insert(0, D34)

import slicelib as SL  # noqa: E402

os.makedirs(RES, exist_ok=True)


# ------------------------------------------------------------- poly helpers
def poly_trim(a, p):
    a = [x % p for x in a]
    while a and a[-1] == 0:
        a.pop()
    return a


def poly_divmod(a, b, p):
    a = a[:]
    db, lb = len(b) - 1, b[-1]
    inv = pow(lb, p - 2, p)
    q = [0] * max(0, len(a) - db)
    while len(a) - 1 >= db and a:
        c = a[-1] * inv % p
        s = len(a) - 1 - db
        q[s] = c
        for i, bc in enumerate(b):
            a[s + i] = (a[s + i] - c * bc) % p
        a = poly_trim(a, p)
        if not a:
            break
    return q, a


def poly_gcd(a, b, p):
    a, b = poly_trim(a, p), poly_trim(b, p)
    while b:
        _, r = poly_divmod(a, b, p)
        a, b = b, r
    if a:
        inv = pow(a[-1], p - 2, p)
        a = [x * inv % p for x in a]
    return a


def poly_deriv(a, p):
    return poly_trim([i * a[i] % p for i in range(1, len(a))], p)


def interpolate(ts, vs, p):
    """Newton interpolation through (ts, vs) over F_p."""
    n = len(ts)
    coef = list(vs)
    for j in range(1, n):
        for i in range(n - 1, j - 1, -1):
            num = (coef[i] - coef[i - 1]) % p
            den = (ts[i] - ts[i - j]) % p
            coef[i] = num * pow(den, p - 2, p) % p
    # expand newton form
    poly = [0] * n
    poly[0] = coef[n - 1]
    deg = 0
    for k in range(n - 2, -1, -1):
        # poly <- poly * (x - ts[k]) + coef[k]
        new = [0] * (deg + 2)
        for i in range(deg + 1):
            new[i + 1] = (new[i + 1] + poly[i]) % p
            new[i] = (new[i] - poly[i] * ts[k]) % p
        new[0] = (new[0] + coef[k]) % p
        poly = new
        deg += 1
    return poly_trim(poly, p)


def poly_eval(a, t, p):
    r = 0
    for c in reversed(a):
        r = (r * t + c) % p
    return r


def klein_F_vec(V, p):
    """V: (..., 5) -> F values."""
    s = np.zeros(V.shape[:-1], dtype=np.int64)
    for i in range(5):
        s = (s + V[..., i] * V[..., i] % p * V[..., (i + 1) % 5]) % p
    return s


def eval_cell_at_points(fr, A, C, Bcell, pts, d):
    p = fr["p"]
    seeds = SL.jet_rows(fr, A, C, pts % p, np.zeros_like(pts), 1, deg=d)[:, :, :, 0] % p
    T = np.einsum("js,sqc->jqc", Bcell, seeds) % p
    return np.transpose(T, (1, 2, 0)) % p  # (npts, 5, K)


def rank_mod(M, p):
    return SL.rref_rank(np.array(M, dtype=np.int64) % p, p)


def run_one(d, p, n_lines=2, n_c=12, seed=20260812):
    fr = SL.build_frame(p, verbose=False)
    A = np.load(os.path.join(LIS_RES, "A_d%d_p%d.npy" % (d, p)))
    C = np.load(os.path.join(LIS_RES, "C_d%d_p%d.npy" % (d, p)))
    B = np.load(os.path.join(LIS_RES, "Bcell_d%d_p%d.npy" % (d, p)))
    K = B.shape[0]
    rng = np.random.default_rng(seed + 1000 * d + p)
    out = {"d": d, "p": p, "K": K, "lines": []}
    for li in range(n_lines):
        t0 = time.time()
        w = rng.integers(0, p, size=5, dtype=np.int64)
        v = rng.integers(0, p, size=5, dtype=np.int64)
        ts = np.arange(p, dtype=np.int64)
        pts = (w[None, :] + ts[:, None] * v[None, :]) % p
        Mall = eval_cell_at_points(fr, A, C, B, pts, d)  # (p, 5, K)
        # generic rank of E_y along the line
        ranks_generic = [rank_mod(Mall[t], p) for t in rng.integers(0, p, size=5)]
        cs = rng.integers(0, p, size=(n_c, K), dtype=np.int64)
        Tv = np.einsum("tck,qk->qtc", Mall, cs) % p  # (n_c, p, 5)
        vals = klein_F_vec(Tv, p)  # (n_c, p)
        polys = []
        ok_deg = True
        for q in range(n_c):
            poly = interpolate(
                [int(t) for t in ts[: 3 * d + 1]],
                [int(x) for x in vals[q, : 3 * d + 1]],
                p,
            )
            # validate on all other points
            for t in range(3 * d + 1, p):
                if poly_eval(poly, t, p) != int(vals[q, t]):
                    ok_deg = False
                    break
            polys.append(poly)
        g = polys[0]
        for q in range(1, n_c):
            g = poly_gcd(g, polys[q], p)
            if len(g) <= 1:
                break
        deg_g = len(g) - 1 if g else -1
        # multiplicity profile of the gcd: squarefree decomposition degrees
        mult_profile = []
        h = g[:]
        while h and len(h) > 1:
            hp = poly_deriv(h, p)
            r = poly_gcd(h, hp, p) if hp else h
            sf, _ = poly_divmod(h, r, p) if len(r) > 1 else (h, [])
            mult_profile.append(len(poly_trim(sf, p)) - 1)
            h = r
            if len(mult_profile) > 12:
                break
        # common zeros in F_p straight from the value table
        common0 = [int(t) for t in range(p) if not vals[:, t].any()]
        cz = []
        for t in common0:
            y = pts[t]
            cz.append(
                {
                    "t": t,
                    "rankE": int(rank_mod(Mall[t], p)),
                    "F(y)": int(klein_F_vec(y[None, :], p)[0]),
                    "gcd_mult": None,
                }
            )
        # multiplicity of each common zero in the gcd
        for e in cz:
            m, h = 0, g[:]
            while len(h) > 1 and poly_eval(h, e["t"], p) == 0:
                h, _ = poly_divmod(h, [(-e["t"]) % p, 1], p)
                m += 1
            e["gcd_mult"] = m
        rec = {
            "line": li,
            "deg_gcd": deg_g,
            "deg_each": [len(q) - 1 for q in polys],
            "degree_valid_all_points": ok_deg,
            "ranks_at_random_t": ranks_generic,
            "n_common_zeros_Fp": len(common0),
            "common_zeros": cz,
            "squarefree_profile(deg of mult>=k part)": mult_profile,
            "seconds": time.time() - t0,
        }
        out["lines"].append(rec)
        print(
            "d=%d p=%d line=%d  deg_gcd=%d  ranks@rand=%s  #common0(Fp)=%d  %s  (%.1fs)"
            % (d, p, li, deg_g, ranks_generic, len(common0),
               "DEGVALID" if ok_deg else "DEGFAIL", time.time() - t0),
            flush=True,
        )
        for e in cz[:12]:
            print("   t=%d rankE=%d F(y)=%d mult_in_gcd=%d" % (e["t"], e["rankE"], e["F(y)"], e["gcd_mult"]))
    with open(os.path.join(RES, "line_gcd_d%d_p%d.json" % (d, p)), "w") as f:
        json.dump(out, f, indent=1)
    return out


def main():
    args = [int(a) for a in sys.argv[1:]]
    ds = [a for a in args if a < 100] or [35, 36, 37, 38]
    ps = [a for a in args if a >= 100] or [331]
    for d in ds:
        for p in ps:
            run_one(d, p)


if __name__ == "__main__":
    main()
