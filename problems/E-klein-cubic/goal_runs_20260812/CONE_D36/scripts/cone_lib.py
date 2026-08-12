#!/usr/bin/env python3
"""Cubic expansion, independent-span extract, msolve emit/parse.

Cubic expansion is the director probe's F = sum_k y_k^2 y_{k+1} formula
(section_deficiency_probe / cone_dimension_probe). msolve format matches
director_probes_20260812/cone_m20_p331.ms.
"""
from __future__ import annotations

import itertools
import json
import os
import re
import subprocess
import time

import numpy as np

import slicelib as SL


def nmon3(m: int) -> int:
    return (m * (m + 1) * (m + 2)) // 6


def jsonable(obj):
    if isinstance(obj, dict):
        return {k: jsonable(v) for k, v in obj.items()}
    if isinstance(obj, (list, tuple)):
        return [jsonable(v) for v in obj]
    if isinstance(obj, (np.integer,)):
        return int(obj)
    if isinstance(obj, (np.floating,)):
        return float(obj)
    if isinstance(obj, np.ndarray):
        return obj.tolist()
    if isinstance(obj, (np.bool_,)):
        return bool(obj)
    return obj


def dump(path, obj):
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "w") as f:
        json.dump(jsonable(obj), f, indent=1, sort_keys=True)
        f.write("\n")


def klein_F(v, p: int) -> int:
    s = 0
    for i in range(5):
        s = (s + int(v[i]) * int(v[i]) % p * int(v[(i + 1) % 5])) % p
    return int(s)


class Echelon:
    def __init__(self, ncols: int, p: int):
        self.p = int(p)
        self.ncols = ncols
        self.basis = np.zeros((0, ncols), dtype=np.int64)
        self.pivots = []

    @property
    def rank(self) -> int:
        return len(self.pivots)

    def reduce(self, v):
        p = self.p
        v = np.array(v, dtype=np.int64, copy=True) % p
        for i, piv in enumerate(self.pivots):
            if v[piv]:
                v = (v - int(v[piv]) * self.basis[i]) % p
        return v

    def try_add(self, v) -> bool:
        p = self.p
        v = self.reduce(v)
        nz = np.nonzero(v)[0]
        if not nz.size:
            return False
        piv = int(nz[0])
        v = (v * pow(int(v[piv]), p - 2, p)) % p
        if self.basis.shape[0]:
            col = self.basis[:, piv].copy()
            nz2 = np.nonzero(col)[0]
            if nz2.size:
                self.basis[nz2] = (self.basis[nz2] - np.outer(col[nz2], v)) % p
        self.basis = (
            np.vstack([self.basis, v]) if self.basis.shape[0] else v.reshape(1, -1)
        )
        self.pivots.append(piv)
        return True


def cubic_rows(V, basis, p):
    """Coefficient rows of F(T_{c(t)}(x)) as cubics in t.

    V: (nseeds, npts, 5); basis: (m, nseeds).
    Returns (npts, C(m+2,3)), monomials.
    Copied from director section_deficiency_probe.cubic_rows.
    """
    m = basis.shape[0]
    v = np.tensordot(basis % p, V % p, axes=(1, 0)) % p
    npts = v.shape[1]
    mons = list(itertools.combinations_with_replacement(range(m), 3))
    idx = {t: n for n, t in enumerate(mons)}
    out = np.zeros((npts, len(mons)), dtype=np.int64)
    for k in range(5):
        Ak = v[:, :, k] % p
        Bk = v[:, :, (k + 1) % 5] % p
        for i in range(m):
            Ai = Ak[i]
            for j in range(i, m):
                base = (Ai * Ak[j]) % p
                mult = 1 if i == j else 2
                for l in range(m):
                    trip = tuple(sorted((i, j, l)))
                    out[:, idx[trip]] = (
                        out[:, idx[trip]] + mult * base * Bk[l]
                    ) % p
    return out % p, mons


def independent_rows(M, p):
    """Original rows that form a basis of the row-span over F_p."""
    A = np.array(M, dtype=np.int64) % p
    n, cols = A.shape
    if n == 0 or cols == 0:
        return A, []
    idx = list(range(n))
    r = 0
    kept = []
    for c in range(cols):
        col = A[r:, c]
        nz = np.nonzero(col)[0]
        if nz.size == 0:
            continue
        piv = r + int(nz[0])
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
            idx[r], idx[piv] = idx[piv], idx[r]
        A[r] = (A[r] * SL.inv_mod(A[r, c], p)) % p
        below = A[r + 1 :, c]
        k = np.nonzero(below)[0]
        if k.size:
            A[r + 1 + k] = (A[r + 1 + k] - np.outer(below[k], A[r])) % p
        kept.append(idx[r])
        r += 1
        if r == n:
            break
    return (np.array(M, dtype=np.int64) % p)[kept], kept


def write_msolve(path, rows, mons, m, p):
    """Director-style msolve input: t1..tm, characteristic, cubics with powers."""
    polys = []
    for r in rows:
        terms = []
        for n, cf in enumerate(r):
            c = int(cf) % p
            if not c:
                continue
            a, b, d = mons[n]
            cnt = {}
            for i in (a, b, d):
                cnt[i] = cnt.get(i, 0) + 1
            mon = "*".join(
                "t%d^%d" % (i + 1, e) if e > 1 else "t%d" % (i + 1)
                for i, e in sorted(cnt.items())
            )
            terms.append("%d*%s" % (c, mon))
        if terms:
            polys.append("+".join(terms))
    header = ",".join("t%d" % (i + 1) for i in range(m))
    with open(path, "w") as f:
        f.write(header + "\n")
        f.write("%d\n" % p)
        f.write(",\n".join(polys) + "\n")
    return len(polys)


def parse_leading_pure_powers(text, m):
    """Zero-dimensional test: every variable has a pure-power leading monomial."""
    body = text
    if "[" in body:
        body = body[body.find("[") :]
    chunks = re.split(r"[,\n\[\]]+", body)
    pures = {}
    for ch in chunks:
        ch = ch.strip()
        if not ch:
            continue
        if "*" in ch:
            continue
        mm = re.fullmatch(r"t(\d+)(?:\^(\d+))?", ch)
        if not mm:
            continue
        var = int(mm.group(1))
        exp = int(mm.group(2) or 1)
        if 1 <= var <= m:
            prev = pures.get(var)
            if prev is None or exp < prev:
                pures[var] = exp
    missing = [i for i in range(1, m + 1) if i not in pures]
    return {
        "pure_powers": {str(k): int(v) for k, v in sorted(pures.items())},
        "n_pure": len(pures),
        "missing": missing,
        "zero_dimensional": len(missing) == 0,
        "exponents_sorted": [pures[i] for i in range(1, m + 1) if i in pures],
    }


def rss_kb(pid=None):
    pid = pid or os.getpid()
    try:
        out = subprocess.check_output(["ps", "-o", "rss=", "-p", str(pid)], text=True)
        return int(out.strip() or 0)
    except Exception:
        return -1


def director_msolve_rss_kb():
    try:
        out = subprocess.check_output(["ps", "aux"], text=True)
    except Exception:
        return 0
    tot = 0
    for line in out.splitlines():
        if "msolve" in line and "cone_full37" in line and "grep" not in line:
            parts = line.split()
            if len(parts) >= 6:
                try:
                    tot += int(parts[5])
                except ValueError:
                    pass
    return tot


def run_msolve_g1(ms_path, out_path, log_path, threads=4, timeout=900):
    cmd = ["msolve", "-g", "1", "-t", str(threads), "-v", "1",
           "-f", ms_path, "-o", out_path]
    t0 = time.time()
    try:
        proc = subprocess.run(
            cmd, capture_output=True, text=True, timeout=timeout
        )
        dt = time.time() - t0
        txt = (proc.stdout or "") + "\n" + (proc.stderr or "")
        with open(log_path, "w") as f:
            f.write(txt)
            f.write("\nEXIT %d SEC %.2f\n" % (proc.returncode, dt))
        lead = ""
        if os.path.exists(out_path):
            lead = open(out_path).read()
        return {
            "ok": proc.returncode == 0 and bool(lead.strip()),
            "returncode": proc.returncode,
            "seconds": dt,
            "timeout": False,
            "cmd": cmd,
            "lead_bytes": len(lead),
            "lead": lead,
            "log": txt[-8000:],
        }
    except subprocess.TimeoutExpired:
        dt = time.time() - t0
        with open(log_path, "a") as f:
            f.write("\nTIMEOUT after %.1fs\n" % dt)
        return {
            "ok": False,
            "returncode": None,
            "seconds": dt,
            "timeout": True,
            "cmd": cmd,
            "lead_bytes": 0,
            "lead": "",
            "log": "TIMEOUT",
        }


def inv_side_p3(fr, A, C, Bcell, d, p, eval_T, n_func=3500, max_c=8000,
                stable_window=400, extra_batches=2, extra_size=500,
                seed=20260812, Iceil=9545):
    """Invariant-side rank of c |-> F(T_c). Same instrument as LANDING_INVARIANT_SIDE."""
    K = int(Bcell.shape[0])
    N3 = nmon3(K)
    t0 = time.time()
    if K == 0:
        return {"d": d, "p": p, "K": 0, "P3": 0, "HF3": 0, "N3": 0,
                "saturated": True, "mode": "empty"}
    rng = np.random.default_rng(seed + 17 * d + p)

    def fresh_funcs(n):
        ys = rng.integers(0, p, size=(n, 5), dtype=np.int64)
        for i in range(n):
            if not ys[i].any():
                ys[i, 0] = 1
        return ys

    ys = fresh_funcs(n_func)
    print("[inv-P3] d=%d p=%d K=%d N3=%d n_func=%d" % (d, p, K, N3, n_func),
          flush=True)
    Mall = eval_T(fr, A, C, Bcell, ys, d)
    ech = Echelon(n_func, p)
    n_tested = 0
    stable = 0
    curve = []
    while n_tested < max_c and stable < stable_window:
        b = 32
        cs = rng.integers(0, p, size=(b, K), dtype=np.int64)
        Tv = np.einsum("tck,bk->btc", Mall, cs) % p
        for q in range(b):
            if n_tested >= max_c or stable >= stable_window:
                break
            row = np.array([klein_F(Tv[q, t], p) for t in range(n_func)],
                           dtype=np.int64)
            n_tested += 1
            if ech.try_add(row):
                stable = 0
            else:
                stable += 1
            if n_tested % 100 == 0:
                curve.append({"n": n_tested, "rank": ech.rank, "stable": stable,
                              "t": time.time() - t0})
                print("  n=%d rank=%d stable=%d (%.1fs)"
                      % (n_tested, ech.rank, stable, time.time() - t0),
                      flush=True)
    extras = []
    for bi in range(extra_batches):
        brng = np.random.default_rng(seed + 10007 * (bi + 1) + 13 * p + d)
        before = ech.rank
        added = 0
        for _ in range(extra_size):
            c = brng.integers(0, p, size=K, dtype=np.int64)
            Tv = np.einsum("tck,k->tc", Mall, c) % p
            row = np.array([klein_F(Tv[t], p) for t in range(n_func)],
                           dtype=np.int64)
            if ech.try_add(row):
                added += 1
            n_tested += 1
        extras.append({"batch": bi, "added": added, "rank_after": ech.rank,
                       "rank_before": before})
        print("  extra %d: +%d -> rank=%d" % (bi, added, ech.rank), flush=True)
    P3 = int(ech.rank)
    sat = (stable >= stable_window and all(e["added"] == 0 for e in extras)
           and P3 < n_func - 1)
    return {
        "d": d, "p": int(p), "K": K, "N3": N3, "I_3d": Iceil,
        "P3": P3, "HF3": N3 - P3, "saturated": sat,
        "P3_is_lower_bound": not sat, "deficit_vs_I": Iceil - P3,
        "n_func": n_func, "npts_c_tested": n_tested,
        "stable_final": stable, "extra_batches": extras,
        "mode": "inv_eval_matrix", "rank_curve": curve[-20:],
        "seconds": time.time() - t0,
    }
