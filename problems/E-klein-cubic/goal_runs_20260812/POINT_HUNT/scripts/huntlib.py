"""Landing-cone point hunt: full-span cubics, msolve extract, Jacobian rank.

Cubic expansion matches director_probes_20260812/cone_dimension_probe.py
and CONE_LADDER_D35/scripts/conelib.py. Jacobian matches
director_probes_20260812/jacobian_rank_probe.py (Euler control is fatal).
"""
from __future__ import annotations

import itertools
import json
import os
import re
import signal
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


def npts_for(m):
    span = min(P3_SEALED, nmon3(m))
    return int(1.4 * span) + 40


def cell37(p):
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
    }


def load_AC():
    a = np.load(os.path.join(paths.PAIR_RES, "layer0_A_p331.npy"))
    c = np.load(os.path.join(paths.PAIR_RES, "layer0_C_p331.npy"))
    assert a.shape == (paths.NSEED, 5) and c.shape == (paths.NSEED,)
    return a, c


def seed_values(fr, A, C, W):
    y = np.zeros_like(W)
    r = SL.jet_rows(fr, A, C, W, y, 1, deg=DEG)
    return r[:, :, :, 0] % fr["p"]


def cubic_rows(V, basis, p):
    """Coefficient rows of F(T_{c(t)}(x)) as cubics in the section parameters."""
    m = basis.shape[0]
    v = np.tensordot(basis % p, V % p, axes=(1, 0)) % p
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


def write_msolve(path, rows, mons, m, p, extras=None):
    """Write msolve input. Full independent span, then optional extra polys."""
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    n = 0
    extras = extras or []
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
        for ex in extras:
            if not first:
                f.write(",\n")
            f.write(ex)
            first = False
            n += 1
        f.write("\n")
    return n


def eval_cubic_rows(rows, mons, t, p):
    """Evaluate restricted cubics at a section point t."""
    t = np.array(t, dtype=np.int64) % p
    out = np.zeros(rows.shape[0], dtype=np.int64)
    for k, triple in enumerate(mons):
        mon = 1
        for i in triple:
            mon = (mon * int(t[i])) % p
        if mon:
            out = (out + (rows[:, k] % p) * mon) % p
    return out % p


# ---------------------------------------------------------------------------
# msolve I/O
# ---------------------------------------------------------------------------

_PURE = re.compile(r"^t(\d+)(?:\^(\d+))?$")


def parse_leading_ideal(path):
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


def _parse_nested(text):
    text = text.strip()
    if text.endswith(":"):
        text = text[:-1]
    i = 0
    n = len(text)

    def skip():
        nonlocal i
        while i < n and text[i] in " \n\t\r":
            i += 1

    def parse():
        nonlocal i
        skip()
        if i >= n:
            return None
        if text[i] == "[":
            i += 1
            out = []
            while True:
                skip()
                if i < n and text[i] == "]":
                    i += 1
                    return out
                if i >= n:
                    return out
                out.append(parse())
                skip()
                if i < n and text[i] == ",":
                    i += 1
        if text[i] == "'":
            i += 1
            j = text.find("'", i)
            s = text[i:j]
            i = j + 1
            return s
        j = i
        if text[j] == "-":
            j += 1
        while j < n and text[j].isdigit():
            j += 1
        if j == i or (j == i + 1 and text[i] == "-"):
            raise ValueError("bad token at %d: %r" % (i, text[i:i + 20]))
        val = int(text[i:j])
        i = j
        return val

    return parse()


def eval_univariate(coeffs, x, p):
    acc = 0
    for c in reversed(coeffs):
        acc = (acc * int(x) + int(c)) % p
    return acc % p


def roots_fp(coeffs, p):
    coeffs = [int(c) % p for c in coeffs]
    while len(coeffs) > 1 and coeffs[-1] == 0:
        coeffs.pop()
    if not coeffs:
        return list(range(p))
    if len(coeffs) == 1:
        return list(range(p)) if coeffs[0] == 0 else []
    return [x for x in range(p) if eval_univariate(coeffs, x, p) == 0]


def parse_msolve_solutions(path, p):
    """Parse msolve prime-field output: empty / positive-dim / F_p points."""
    if not os.path.isfile(path) or os.path.getsize(path) == 0:
        return {"kind": "missing", "points": [], "path": path}
    raw = open(path).read().strip()
    rec = {"path": path, "raw_head": raw[:200], "points": []}
    if raw.startswith("[-1]"):
        rec["kind"] = "empty"
        return rec
    flat = re.sub(r"\s+", "", raw)
    if re.match(r"\[1,\d+,-1", flat):
        rec["kind"] = "positive_dim"
        return rec
    try:
        tree = _parse_nested(raw)
    except Exception as e:
        rec["kind"] = "parse_error"
        rec["error"] = str(e)
        return rec
    # Expected: [0, [p, nvars, nsols, vars, linform, [1, [elim, denom, nums]]]]
    if not (isinstance(tree, list) and tree and tree[0] == 0
            and isinstance(tree[1], list) and len(tree[1]) >= 6):
        rec["kind"] = "unrecognized"
        rec["tree_head"] = str(tree)[:200]
        return rec
    body = tree[1]
    rec["char"] = body[0]
    rec["nvars"] = body[1]
    rec["nsols"] = body[2]
    vars_ = body[3]
    linform = [int(x) % p for x in body[4]]
    rec["vars"] = vars_
    rec["linform"] = linform
    blob = body[5]
    if not (isinstance(blob, list) and blob):
        rec["kind"] = "unrecognized"
        return rec
    data = blob[1] if blob[0] == 1 and len(blob) > 1 else blob
    if not (isinstance(data, list) and len(data) >= 3):
        rec["kind"] = "unrecognized"
        return rec
    elim_pack, den_pack, nums = data[0], data[1], data[2]
    elim = [int(c) % p for c in elim_pack[1]]
    den = [int(c) % p for c in den_pack[1]]
    rec["elim"] = elim
    rec["denom"] = den
    rec["elim_degree"] = max(0, len(elim) - 1)
    t_index = None
    if sum(1 for a in linform if a) == 1:
        t_index = next(i for i, a in enumerate(linform) if a)
        if linform[t_index] != 1:
            # T = a * t_k; rescale later
            pass
    rec["t_index"] = t_index
    roots = roots_fp(elim, p)
    rec["n_fp_roots"] = len(roots)
    points = []
    nvars = int(body[1])
    num_list = nums if isinstance(nums, list) else []
    for T in roots:
        denT = eval_univariate(den, T, p)
        if denT == 0:
            continue
        invd = inv_mod(denT, p)
        coords = [0] * nvars
        if t_index is not None:
            a = linform[t_index]
            # T = a * t_k  =>  t_k = T * a^{-1}
            coords[t_index] = (int(T) * inv_mod(a, p)) % p
            others = [i for i in range(nvars) if i != t_index]
        else:
            others = list(range(nvars - 1))
            coords[nvars - 1] = int(T) % p
        if len(num_list) != len(others):
            rec["kind"] = "param_len_mismatch"
            rec["n_nums"] = len(num_list)
            rec["n_others"] = len(others)
            return rec
        ok = True
        for slot, i in enumerate(others):
            pack = num_list[slot]
            # msolve wraps each numerator as [[deg, [coeffs]]]
            while (isinstance(pack, list) and len(pack) == 1
                   and isinstance(pack[0], list)):
                pack = pack[0]
            if not (isinstance(pack, list) and len(pack) >= 2
                    and isinstance(pack[1], list)):
                rec["kind"] = "bad_numerator"
                rec["bad_pack"] = pack
                return rec
            coeffs = [int(c) % p for c in pack[1]]
            numT = eval_univariate(coeffs, T, p)
            coords[i] = ((-numT) * invd) % p
        if t_index is None:
            # enforce T = linform · t
            got = 0
            for i, a in enumerate(linform):
                got = (got + a * coords[i]) % p
            if got != int(T) % p:
                ok = False
        if ok:
            points.append(coords)
    rec["points"] = points
    rec["kind"] = "zero_dim"
    rec["n_fp_points"] = len(points)
    return rec


def rss_kb(pid):
    try:
        out = subprocess.check_output(["ps", "-o", "rss=", "-p", str(pid)], text=True)
        return int(out.strip() or 0)
    except Exception:
        return -1


def msolve_running():
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


def run_msolve(ms_path, out_path, log_path, threads=2, timeout=1200,
               mode="solve", rss_limit_kb=None):
    """Run msolve; kill on timeout or RSS cap. Never guesses a verdict."""
    if rss_limit_kb is None:
        rss_limit_kb = paths.RSS_LIMIT_KB
    os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)
    if os.path.isfile(out_path):
        os.remove(out_path)
    cmd = ["msolve", "-t", str(threads), "-v", "1", "-f", ms_path, "-o", out_path]
    if mode == "lead":
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
        "rss_limit_kb": rss_limit_kb,
        "mode": mode,
        "max_rss_kb": 0,
    }
    with open(log_path, "w") as logf:
        logf.write("CMD %s\n" % " ".join(cmd))
        logf.flush()
        try:
            proc = subprocess.Popen(
                cmd, stdout=logf, stderr=subprocess.STDOUT,
                start_new_session=True,
            )
        except Exception as e:
            meta.update({
                "returncode": None, "seconds": 0, "timed_out": False,
                "killed_memory": False, "verdict": "NO_VERDICT_SPAWN",
                "error": str(e),
            })
            return meta
        killed_mem = False
        timed_out = False
        while True:
            ret = proc.poll()
            rss = rss_kb(proc.pid)
            if rss > 0:
                meta["max_rss_kb"] = max(int(meta["max_rss_kb"]), rss)
            if rss > rss_limit_kb:
                killed_mem = True
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except Exception:
                    proc.kill()
                break
            if time.time() - t0 > timeout:
                timed_out = True
                try:
                    os.killpg(proc.pid, signal.SIGKILL)
                except Exception:
                    proc.kill()
                break
            if ret is not None:
                break
            time.sleep(1.0)
        try:
            proc.wait(timeout=5)
        except Exception:
            pass
        dt = time.time() - t0
        if killed_mem:
            logf.write("\nKILLED_MEMORY rss_kb=%s limit=%s after %.1fs\n"
                       % (meta["max_rss_kb"], rss_limit_kb, dt))
        if timed_out:
            logf.write("\nTIMEOUT after %.1fs\n" % dt)
    meta.update({
        "returncode": proc.returncode,
        "seconds": dt,
        "timed_out": timed_out,
        "killed_memory": killed_mem,
    })
    if timed_out:
        meta["verdict"] = "NO_VERDICT_TIMEOUT"
        return meta
    if killed_mem:
        meta["verdict"] = "NO_VERDICT_MEMORY"
        return meta
    if mode == "lead":
        lead = parse_leading_ideal(out_path)
        meta["lead"] = lead
        if not lead.get("ok"):
            meta["verdict"] = "NO_VERDICT_PARSE"
        elif lead.get("zero_dimensional"):
            meta["verdict"] = "ZERO_DIM"
        else:
            meta["verdict"] = "NOT_ZERO_DIM"
            meta["missing_pure"] = lead.get("missing_pure")
        return meta
    sol = parse_msolve_solutions(out_path, int(open(ms_path).read().splitlines()[1]))
    meta["sol"] = {k: v for k, v in sol.items() if k != "points"}
    meta["n_points"] = len(sol.get("points") or [])
    meta["points"] = sol.get("points") or []
    kind = sol.get("kind")
    if kind == "empty":
        meta["verdict"] = "EMPTY_CHART"
    elif kind == "positive_dim":
        meta["verdict"] = "POSITIVE_DIM"
    elif kind == "zero_dim":
        meta["verdict"] = "POINTS" if meta["n_points"] else "ZERO_DIM_NO_FP_POINT"
    else:
        meta["verdict"] = "NO_VERDICT_PARSE"
        meta["parse_kind"] = kind
    return meta


# ---------------------------------------------------------------------------
# Jacobian / dominance (director probe, fatal Euler)
# ---------------------------------------------------------------------------

def rank_mod(M, p):
    return SL.rref_rank(np.array(M, dtype=np.int64) % p, p)


def jacobian_at(fr, A, C, vec, w, p):
    J = np.zeros((5, 5), dtype=np.int64)
    W = np.array([w], dtype=np.int64) % p
    for j in range(5):
        Y = np.zeros((1, 5), dtype=np.int64)
        Y[0, j] = 1
        R = SL.jet_rows(fr, A, C, W, Y, 2, deg=DEG)
        d1 = R[:, 0, :, 1] % p
        J[:, j] = (vec @ d1) % p
    return J % p


def value_at(fr, A, C, vec, w, p):
    W = np.array([w], dtype=np.int64) % p
    R = SL.jet_rows(fr, A, C, W, np.zeros_like(W), 1, deg=DEG)
    return (vec @ R[:, 0, :, 0]) % p


def klein_F(y, p):
    y = np.array(y, dtype=np.int64) % p
    acc = 0
    for k in range(5):
        acc = (acc + y[k] * y[k] * y[(k + 1) % 5]) % p
    return acc % p


def dominance_test(fr, A, C, vec, p, ntrials=8, seed=20260812):
    """Generic Jacobian rank of T_vec. Euler failure is fatal."""
    rng = np.random.default_rng(seed)
    ranks = []
    euler = []
    for t in range(ntrials):
        w = rng.integers(1, p, size=5) % p
        J = jacobian_at(fr, A, C, vec, w, p)
        r = int(rank_mod(J, p))
        lhs = (J @ w) % p
        rhs = (DEG * value_at(fr, A, C, vec, w, p)) % p
        ok = bool(np.array_equal(lhs, rhs))
        if not ok:
            raise AssertionError("Euler relation failed -- derivative extraction is wrong")
        ranks.append(r)
        euler.append(ok)
    mx = max(ranks) if ranks else 0
    if mx <= 3:
        verdict = "NOT_DOMINANT"
    elif mx == 4:
        verdict = "DOMINANT_OPEN"
    else:
        verdict = "RANK5_GENERIC"
    return {
        "ranks": ranks,
        "max_rank": mx,
        "euler_ok": euler,
        "ntrials": ntrials,
        "verdict": verdict,
        "note": ("rank <= 3 is not dominant onto the 3-fold; "
                 "rank 4 is the dominance-open condition; "
                 "rank 5 means det J is not forced at this point"),
    }


def lift_section_point(t, S, B37, p):
    t = np.array(t, dtype=np.int64) % p
    c = (t @ (S % p)) % p
    vec = (c @ (B37 % p)) % p
    return {"t": [int(x) for x in t],
            "c37": [int(x) for x in c],
            "vec637": [int(x) for x in vec],
            "c_nonzero": int(np.count_nonzero(c)),
            "vec_nonzero": int(np.count_nonzero(vec))}


def landing_check(fr, A, C, vec, p, npts=40, seed=20260812):
    """Independent check: F(T_vec(x)) == 0 at random x."""
    rng = np.random.default_rng(seed)
    W = rng.integers(1, p, size=(npts, 5)) % p
    V = seed_values(fr, A, C, W)
    # V: (nseeds, npts, 5); T = vec @ V
    T = np.tensordot(vec % p, V % p, axes=(0, 0)) % p  # (npts, 5)
    vals = [int(klein_F(T[i], p)) for i in range(npts)]
    return {
        "npts": npts,
        "n_nonzero": int(sum(1 for v in vals if v)),
        "max_abs": int(max(vals) if vals else 0),
        "lands": all(v == 0 for v in vals),
    }
