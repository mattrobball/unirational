"""Landing-cone section ladder: cubic expansion, span, msolve emit/parse.

Cubic expansion is the director's (cone_dimension_probe / section_deficiency_probe):
F = sum_k y_k^2 y_{k+1} applied to T_{c(t)}(x) = sum_i t_i v_i(x).
"""
from __future__ import annotations

import itertools
import json
import os
import re
import subprocess
import time

import numpy as np

import paths
import slicelib as SL

DEG = paths.DEG
DIM37 = paths.DIM37
P3_SEALED = paths.P3_SEALED


def inv_mod(a, p):
    return pow(int(a) % p, p - 2, p)


def nmon3(m):
    return m * (m + 1) * (m + 2) // 6


def cell37(p):
    """37 x 637 basis of the post-flip cell. Fatal if not 37."""
    nul = np.load(os.path.join(paths.PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    we = json.load(open(os.path.join(paths.PAIR_RES, "worked_example_p%d.json" % p)))
    u6 = np.array(we["universal_matrix_6x39"], dtype=np.int64) % p
    k37 = SL.nullspace(u6 % p, p) % p
    assert k37.shape[0] == DIM37, ("cell not 37", k37.shape)
    b = (k37 @ nul) % p
    assert SL.rref_rank(b, p) == DIM37
    return {
        "p": p,
        "B37": b,
        "K37": k37,
        "U6": u6,
        "rank_U": int(SL.rref_rank(u6, p)),
        "null_shape": list(nul.shape),
        "dim_universal_json": we.get("dim_universal"),
    }


def load_AC():
    a = np.load(os.path.join(paths.PAIR_RES, "layer0_A_p331.npy"))
    c = np.load(os.path.join(paths.PAIR_RES, "layer0_C_p331.npy"))
    assert a.shape == (paths.NSEED, 5) and c.shape == (paths.NSEED,)
    return a, c


def seed_values(fr, A, C, W):
    """T_seed(x) for every seed and sample point: (nseeds, npts, 5)."""
    y = np.zeros_like(W)
    r = SL.jet_rows(fr, A, C, W, y, 1, deg=DEG)
    return r[:, :, :, 0] % fr["p"]


def cubic_rows(V, basis, p):
    """Coefficient rows of F(T_{c(t)}(x)) as cubics in the section parameters.

    V: (nseeds, npts, 5); basis: (m, nseeds).
    Returns (npts, C(m+2,3)) and the monomial list (triples, 0-based).
    """
    m = basis.shape[0]
    v = np.tensordot(basis % p, V % p, axes=(1, 0)) % p  # (m, npts, 5)
    npts = v.shape[1]
    mons = list(itertools.combinations_with_replacement(range(m), 3))
    idx = {t: n for n, t in enumerate(mons)}
    out = np.zeros((npts, len(mons)), dtype=np.int64)
    for k in range(5):
        ak = v[:, :, k] % p
        bk = v[:, :, (k + 1) % 5] % p
        for i in range(m):
            for j in range(i, m):
                base = (ak[i] * ak[j]) % p
                mult = 1 if i == j else 2
                for ell in range(m):
                    t = tuple(sorted((i, j, ell)))
                    out[:, idx[t]] = (out[:, idx[t]] + mult * base * bk[ell]) % p
    return out % p, mons


def row_basis_indices(M, p):
    """Indices of a row-basis of M over F_p (single RREF pass)."""
    a = np.array(M, dtype=np.int64) % p
    rows, cols = a.shape
    selected = []
    r = 0
    row_idx = list(range(rows))
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if a[i, c]:
                piv = i
                break
        if piv is None:
            continue
        if piv != r:
            a[[r, piv]] = a[[piv, r]]
            row_idx[r], row_idx[piv] = row_idx[piv], row_idx[r]
        a[r] = (a[r] * inv_mod(a[r, c], p)) % p
        below = a[r + 1:, c]
        nz = np.nonzero(below)[0]
        if nz.size:
            a[r + 1 + nz] = (a[r + 1 + nz] - np.outer(below[nz], a[r])) % p
        selected.append(row_idx[r])
        r += 1
        if r == rows:
            break
    return selected


def mon_name(triple):
    cnt = {}
    for i in triple:
        cnt[i] = cnt.get(i, 0) + 1
    parts = []
    for i in sorted(cnt):
        e = cnt[i]
        name = "t%d" % (i + 1)
        parts.append(name if e == 1 else "%s^%d" % (name, e))
    return "*".join(parts)


def write_msolve(path, rows, mons, m, p):
    """Write msolve input. Full independent span, no subset."""
    os.makedirs(os.path.dirname(path), exist_ok=True)
    n = 0
    with open(path, "w") as f:
        f.write(",".join("t%d" % (i + 1) for i in range(m)) + "\n")
        f.write("%d\n" % p)
        first = True
        for row in rows:
            terms = []
            for k, cf in enumerate(row):
                c = int(cf) % p
                if c:
                    terms.append("%d*%s" % (c, mon_name(mons[k])))
            if not terms:
                continue
            if not first:
                f.write(",\n")
            f.write("+".join(terms))
            first = False
            n += 1
        f.write("\n")
    return n


_PURE = re.compile(r"^t(\d+)(?:\^(\d+))?$")


def parse_leading_ideal(path):
    """Parse msolve -g 1 output. Zero-dim iff every variable has a pure power."""
    if not os.path.isfile(path) or os.path.getsize(path) == 0:
        return {"ok": False, "reason": "missing_or_empty", "path": path}
    text = open(path).read()
    if "[-1]:" in text and "length of basis" not in text:
        return {"ok": False, "reason": "no_solution_marker", "path": path}
    if "[" not in text or "]" not in text:
        return {"ok": False, "reason": "no_basis_block", "path": path}
    header = {}
    for line in text.splitlines():
        if "field characteristic:" in line:
            header["char"] = int(line.split(":")[1].strip())
        elif "variable order:" in line:
            vs = line.split(":", 1)[1].strip()
            header["vars"] = [v.strip() for v in vs.split(",") if v.strip()]
        elif "length of basis:" in line:
            header["length"] = int(line.split(":")[1].strip().split()[0])
    body = text.split("[", 1)[1].rsplit("]", 1)[0]
    mons = []
    for raw in body.split("\n"):
        s = raw.strip().strip(",").strip()
        if s:
            mons.append(s)
    vars_ = header.get("vars") or []
    n = len(vars_)
    # fallback: infer n from t-indices
    if n == 0:
        ids = []
        for mon in mons:
            ids.extend(int(x) for x in re.findall(r"t(\d+)", mon))
        n = max(ids) if ids else 0
        vars_ = ["t%d" % i for i in range(1, n + 1)]
        header["vars"] = vars_
    pure = {}
    for mon in mons:
        mm = _PURE.fullmatch(mon)
        if not mm:
            continue
        i = int(mm.group(1))
        e = int(mm.group(2) or 1)
        pure[i] = min(e, pure.get(i, 10 ** 9))
    missing = [i for i in range(1, n + 1) if i not in pure]
    return {
        "ok": True,
        "path": path,
        "nvars": n,
        "nlead": len(mons),
        "header": header,
        "pure_powers": {str(i): int(e) for i, e in sorted(pure.items())},
        "missing_pure": missing,
        "zero_dimensional": len(missing) == 0 and n > 0,
    }


def rss_kb(pid):
    try:
        out = subprocess.check_output(["ps", "-o", "rss=", "-p", str(pid)], text=True)
        return int(out.strip() or 0)
    except Exception:
        return -1


def msolve_running():
    """List live msolve processes (pid, rss_kb, cmd)."""
    try:
        out = subprocess.check_output(["ps", "aux"], text=True)
    except Exception:
        return []
    found = []
    for line in out.splitlines():
        if "msolve" not in line or "grep" in line:
            continue
        parts = line.split(None, 10)
        if len(parts) < 11:
            continue
        try:
            pid = int(parts[1])
            rss = int(parts[5])
        except ValueError:
            continue
        found.append({"pid": pid, "rss_kb": rss, "cmd": parts[10]})
    return found


def run_msolve(ms_path, out_path, log_path, threads=4, timeout=7200):
    """msolve -g 1 -t <threads>. Returns meta dict; never guesses a verdict."""
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    cmd = ["msolve", "-g", "1", "-t", str(threads), "-v", "1",
           "-f", ms_path, "-o", out_path]
    t0 = time.time()
    meta = {
        "cmd": cmd,
        "ms": ms_path,
        "out": out_path,
        "log": log_path,
        "threads": threads,
        "timeout": timeout,
    }
    try:
        proc = subprocess.run(
            cmd, capture_output=True, text=True, timeout=timeout,
        )
        dt = time.time() - t0
        log = (proc.stdout or "") + (proc.stderr or "")
        with open(log_path, "w") as f:
            f.write(log)
        meta.update({
            "returncode": proc.returncode,
            "seconds": dt,
            "timed_out": False,
            "log_tail": "\n".join(log.splitlines()[-40:]),
        })
    except subprocess.TimeoutExpired as e:
        dt = time.time() - t0
        log = ""
        if e.stdout:
            log += e.stdout if isinstance(e.stdout, str) else e.stdout.decode()
        if e.stderr:
            log += e.stderr if isinstance(e.stderr, str) else e.stderr.decode()
        with open(log_path, "w") as f:
            f.write(log)
            f.write("\nTIMEOUT after %s s\n" % timeout)
        meta.update({
            "returncode": None,
            "seconds": dt,
            "timed_out": True,
            "verdict": "NO_VERDICT_TIMEOUT",
        })
        return meta
    lead = parse_leading_ideal(out_path)
    meta["lead"] = lead
    if meta["timed_out"]:
        meta["verdict"] = "NO_VERDICT_TIMEOUT"
    elif not lead.get("ok"):
        meta["verdict"] = "NO_VERDICT_PARSE"
    elif lead.get("zero_dimensional"):
        meta["verdict"] = "ZERO_DIM"
    else:
        meta["verdict"] = "NOT_ZERO_DIM"
        meta["missing_pure"] = lead.get("missing_pure")
    return meta
