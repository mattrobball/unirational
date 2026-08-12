#!/usr/bin/env python3
"""Test whether extracted open-demand functionals vanish on V.

Vanishing certificates (strongest first):
  Z37  — the linear form is the zero form on the 37-cell (hence on V)
  I3   — λ^3 lies in the sealed landing-cubic span I3 (so λ ∈ rad(I)
         at cubic degree)
  RAB  — Rabinowitsch on a cleared section L (V ∩ L = {0}):
         1 ∈ I(L) + (u·(λ|L) − 1). This is AUTOMATIC for every
         linear form once V ∩ L = {0}, so a positive is not evidence
         that λ vanishes on V. A negative would prove non-vanishing;
         it cannot occur on a cleared section. The control (one open
         demand + one random linear) documents the tautology.

A functional that is not Z37 and not I3 is NOT proved to vanish on V.

Usage: python3 test_vanish.py [p]
"""
from __future__ import annotations

import json
import os
import shutil
import subprocess
import sys
import time

import numpy as np

import paths
import slicelib as SL
from framelib import i3_contains, lam3_row

RES = paths.RES
LADDER_RES = paths.LADDER_RES
D35L_RES = paths.D35L_RES


def loadj(path):
    with open(path) as f:
        return json.load(f)


def load_I3(p):
    basis = np.load(os.path.join(D35L_RES, "I3_echelon_p%d.npy" % p)) % p
    pivs = np.load(os.path.join(D35L_RES, "I3_pivots_p%d.npy" % p))
    assert basis.shape == (paths.P3, paths.N3), basis.shape
    assert len(pivs) == paths.P3
    return basis, [int(x) for x in pivs]


def i3_anchor(basis, pivs, p):
    """Sealed I3 is monic at its pivots and has rank 1380."""
    ok_piv = True
    for i, piv in enumerate(pivs):
        if int(basis[i, piv]) % p != 1:
            ok_piv = False
            break
    rk = int(SL.rref_rank(basis % p, p))
    return {"pivots_monic": ok_piv, "rank": rk, "rank_ok": rk == paths.P3}


def classify_fun(vec, zero37, basis, pivs, p):
    if zero37:
        return {
            "vanishes_on_V": True,
            "certificate": "Z37",
            "I3_contains_lam3": True,
            "note": "zero form on the 37-cell, hence on V",
        }
    row = lam3_row(vec, p)
    in_i3 = i3_contains(row, basis, pivs, p)
    if in_i3:
        return {
            "vanishes_on_V": True,
            "certificate": "I3",
            "I3_contains_lam3": True,
            "note": "lam^3 in I3 => lam in rad(I)",
        }
    return {
        "vanishes_on_V": False,
        "certificate": "NONE",
        "I3_contains_lam3": False,
        "note": "nonzero on 37-cell; lam^3 not in I3; no vanishing proof",
    }


def write_rabinowitsch_ms(src_ms, dst_ms, mu, p):
    """Copy a cleared section system and append u*(mu·t) - 1."""
    text = open(src_ms).read()
    # first line: variables
    lines = text.split("\n", 2)
    assert lines[0].startswith("t1")
    assert lines[1].strip() == str(p)
    vars_ = lines[0].strip() + ",u"
    body = lines[2].rstrip()
    # mu is 0-based, t_i is 1-based
    terms = []
    for i, c in enumerate(mu):
        c = int(c) % p
        if c:
            terms.append("%d*u*t%d" % (c, i + 1))
    if not terms:
        rab = "%d" % ((p - 1) % p)  # -1, mu=0:  -1 = 0, unit ideal
    else:
        rab = "+".join(terms) + ("+%d" % ((p - 1) % p))
    with open(dst_ms, "w") as f:
        f.write(vars_ + "\n")
        f.write("%d\n" % p)
        f.write(body)
        if not body.endswith("\n"):
            f.write("\n")
        # msolve wants comma-separated generators
        if body.rstrip().endswith(","):
            f.write(rab + "\n")
        else:
            f.write(",\n" + rab + "\n")


def parse_msolve_empty(out_path):
    if not os.path.isfile(out_path) or os.path.getsize(out_path) == 0:
        return {"ok": False, "reason": "missing_or_empty"}
    text = open(out_path).read()
    # msolve: [-1]: no solution; or Groebner basis contains 1
    no_sol = "[-1]:" in text or "no solution" in text.lower()
    has1 = False
    for line in text.splitlines():
        s = line.strip().strip(",").strip()
        if s == "1" or s == "[1]:" or s.startswith("[1]:"):
            has1 = True
    # msolve -g 1 writes the leading monomial 1 as the block "[1]:"
    if "length of basis:" in text and "[1]:" in text:
        has1 = True
    return {
        "ok": True,
        "no_solution_marker": no_sol,
        "basis_contains_1": has1,
        "empty": bool(no_sol or has1),
        "bytes": os.path.getsize(out_path),
        "head": text[:400],
    }


def run_msolve(ms_path, out_path, log_path, threads=2, timeout=180):
    cmd = ["msolve", "-g", "1", "-t", str(threads),
           "-f", ms_path, "-o", out_path]
    t0 = time.time()
    try:
        proc = subprocess.run(
            cmd, capture_output=True, text=True, timeout=timeout)
        rc = proc.returncode
        timed_out = False
        tail = (proc.stdout or "")[-500:] + "\n" + (proc.stderr or "")[-500:]
    except subprocess.TimeoutExpired:
        rc = -1
        timed_out = True
        tail = "TIMEOUT"
    open(log_path, "w").write(tail)
    lead = parse_msolve_empty(out_path)
    return {
        "returncode": rc, "seconds": time.time() - t0,
        "timed_out": timed_out, "lead": lead,
    }


def section_rabinowitsch_control(p, vecs, labels):
    """Run Rabinowitsch on the sealed m=20 section for a few linear forms.

    V ∩ L_20 = {0} (CONE_LADDER_D35). Every linear form vanishes on that
    intersection. A positive empty-chart answer is tautological.
    """
    S_path = os.path.join(LADDER_RES, "section_S_m20_p%d.npy" % p)
    ms_src = os.path.join(LADDER_RES, "cone_m20_p%d.ms" % p)
    if not (os.path.isfile(S_path) and os.path.isfile(ms_src)):
        return {"ok": False, "reason": "missing_ladder_section"}
    S = np.load(S_path) % p  # (20, 37)
    assert S.shape == (20, 37), S.shape
    out = {
        "ok": True,
        "m": 20,
        "source_ms": ms_src,
        "section": os.path.relpath(S_path, paths.EROOT) if False else S_path,
        "tautology_reason": (
            "CONE_LADDER_D35: V ∩ L_20 = {0} (leading ideal, both primes). "
            "Every linear form vanishes on {0}. Rabinowitsch on L_20 is "
            "therefore automatic and does not test vanishing on V."
        ),
        "runs": [],
    }
    for lab, vec in zip(labels, vecs):
        mu = (S @ (np.array(vec, dtype=np.int64) % p)) % p
        dst = os.path.join(RES, "rabin_m20_%s_p%d.ms" % (lab, p))
        op = os.path.join(RES, "rabin_m20_%s_p%d.out" % (lab, p))
        lg = os.path.join(RES, "rabin_m20_%s_p%d.log" % (lab, p))
        write_rabinowitsch_ms(ms_src, dst, mu, p)
        meta = run_msolve(dst, op, lg, threads=2, timeout=180)
        rec = {
            "label": lab,
            "mu_zero": not bool(np.any(mu % p)),
            "mu_nnz": int(np.count_nonzero(mu % p)),
            "msolve": {
                "seconds": meta["seconds"],
                "timed_out": meta["timed_out"],
                "returncode": meta["returncode"],
                "empty": (meta.get("lead") or {}).get("empty"),
                "no_solution_marker": (meta.get("lead") or {}).get(
                    "no_solution_marker"),
                "basis_contains_1": (meta.get("lead") or {}).get(
                    "basis_contains_1"),
            },
            "interpretation": (
                "TAUTOLOGICAL_EMPTY" if (meta.get("lead") or {}).get("empty")
                else "UNEXPECTED_NONEMPTY_OR_FAIL"
            ),
        }
        out["runs"].append(rec)
        print("  rabin %s empty=%s taut=%s (%.1fs)"
              % (lab, rec["msolve"]["empty"], rec["interpretation"],
                 rec["msolve"]["seconds"]), flush=True)
        # drop the 28MB copy after the run; keep .out/.log
        try:
            os.remove(dst)
        except OSError:
            pass
    return out


def demand_vanishes(d, fun_class):
    """Does this one open demand vanish on V?"""
    rule = d.get("kill_rule")
    if rule == "unmatched_dead":
        return True, "unmatched_label"
    if rule == "untested":
        return False, "untested"
    if rule == "all_of_these":
        # used only in aggregate; a single demand of this role
        fid = d.get("fid")
        if fid is None:
            return False, "no_fid"
        return bool(fun_class[fid]["vanishes_on_V"]), fun_class[fid]["certificate"]
    if rule == "this_one":
        fid = d.get("fid")
        if fid is None:
            return False, "no_fid"
        return bool(fun_class[fid]["vanishes_on_V"]), fun_class[fid]["certificate"]
    if rule == "all_components":
        fids = d.get("fids") or []
        certs = [fun_class[i]["certificate"] for i in fids]
        allv = all(fun_class[i]["vanishes_on_V"] for i in fids)
        return allv, ("ALL5:" + ",".join(certs))
    fid = d.get("fid")
    if fid is None:
        return False, "no_fid"
    return bool(fun_class[fid]["vanishes_on_V"]), fun_class[fid]["certificate"]


def branch_dead(opens, fun_class):
    """A branch dies if some required-nonzero reading vanishes on V.

    period1_deeper_all_vanish: the keep dies only if EVERY listed
    deeper jet vanishes (they are packed as several demands sharing
    the all_of_these rule). We group by (kid_idx, role).
    """
    groups = {}
    singles = []
    for d in opens:
        role = d.get("role")
        if role == "period1_deeper_all_vanish":
            groups.setdefault(("p1", d["kid_idx"]), []).append(d)
        else:
            singles.append(d)
    vanished = []
    surviving = []
    for d in singles:
        v, cert = demand_vanishes(d, fun_class)
        rec = dict(d)
        rec["vanishes_on_V"] = v
        rec["certificate"] = cert
        if v:
            vanished.append(rec)
        else:
            surviving.append(rec)
    for key, ds in groups.items():
        flags = [demand_vanishes(d, fun_class) for d in ds]
        allv = all(v for v, _ in flags)
        rec = {
            "role": "period1_deeper_all_vanish",
            "kid_idx": ds[0]["kid_idx"],
            "row": ds[0]["row"],
            "n_levels": len(ds),
            "vanishes_on_V": allv,
            "certificate": "ALL_DEEPER_Z37" if allv else "SOME_DEEPER_LIVE",
        }
        if allv:
            vanished.append(rec)
        else:
            surviving.append(rec)
    dead = len(vanished) > 0
    return dead, vanished, surviving


def pattern_verdict(pt, fun_class):
    """Pattern dies iff every rid-1 branch dies AND (if present) rid-2
    does not independently keep it alive.

    A point of V realizes the pattern only if it realizes some rid-1
    branch AND all rid-2 open keeps. So:
      - any vanishing rid-2 keep kills the whole pattern;
      - otherwise the pattern dies iff every rid-1 branch dies.
    """
    rid2_vanished = []
    rid2_surviving = []
    for d in pt.get("rid2_open") or []:
        v, cert = demand_vanishes(d, fun_class)
        rec = {"role": d["role"], "kid_idx": d["kid_idx"], "row": d["row"],
               "vanishes_on_V": v, "certificate": cert}
        if v:
            rid2_vanished.append(rec)
        else:
            rid2_surviving.append(rec)
    bres = []
    n_live_b = 0
    for b in pt["rid1_branches"]:
        dead, vanished, surviving = branch_dead(b["open_demands"], fun_class)
        if not dead:
            n_live_b += 1
        bres.append({
            "branch": b["branch"],
            "content_key": b.get("content_key"),
            "dead": dead,
            "n_vanished_opens": len(vanished),
            "n_surviving_opens": len(surviving),
            "vanished": vanished,
            "surviving_roles": [s.get("role") for s in surviving],
        })
    if rid2_vanished:
        verdict = "DEAD"
        why = "rid2_keep_vanishes_on_V"
    elif n_live_b == 0:
        verdict = "DEAD"
        why = "all_rid1_branches_dead"
    else:
        verdict = "LIVE"
        why = "some_open_demands_not_proved_to_vanish"
    return {
        "id": pt["id"],
        "content_hash": pt["content_hash"],
        "verdict": verdict,
        "why": why,
        "rid1_branches": bres,
        "n_rid1_live": n_live_b,
        "rid2_vanished": rid2_vanished,
        "rid2_n_surviving": len(rid2_surviving),
    }


def main(p):
    print("== test vanish p=%d" % p, flush=True)
    ext = loadj(os.path.join(RES, "open_demands_p%d.json" % p))
    V = np.load(os.path.join(RES, "functionals_p%d.npy" % p)) % p
    assert V.shape[0] == ext["n_functionals"]
    basis, pivs = load_I3(p)
    anc = i3_anchor(basis, pivs, p)
    print("  I3 anchor rank=%d monic=%s" % (anc["rank"], anc["pivots_monic"]),
          flush=True)
    assert anc["rank_ok"] and anc["pivots_monic"]

    fun_class = []
    n_z37 = n_i3 = n_none = 0
    for f in ext["functionals"]:
        fid = f["fid"]
        cl = classify_fun(V[fid], f["zero_on_37cell"], basis, pivs, p)
        cl["fid"] = fid
        cl["kind"] = f["kind"]
        fun_class.append(cl)
        if cl["certificate"] == "Z37":
            n_z37 += 1
        elif cl["certificate"] == "I3":
            n_i3 += 1
        else:
            n_none += 1
    print("  funs: Z37=%d I3=%d NONE=%d / %d"
          % (n_z37, n_i3, n_none, len(fun_class)), flush=True)

    # Rabinowitsch control: one vanishing (if any), one surviving, one random
    rng = np.random.default_rng(20260812 + p)
    rand = rng.integers(0, p, size=37)
    labels, vecs = ["random"], [rand]
    # first Z37 if any, first NONE if any
    for cl, tag in (
        (next((c for c in fun_class if c["certificate"] == "Z37"), None),
         "z37"),
        (next((c for c in fun_class if c["certificate"] == "NONE"), None),
         "none"),
    ):
        if cl is not None:
            labels.append(tag)
            vecs.append(V[cl["fid"]])
    print("  Rabinowitsch control on m=20 ...", flush=True)
    rab = section_rabinowitsch_control(p, vecs, labels)

    verdicts = [pattern_verdict(pt, fun_class) for pt in ext["patterns"]]
    n_dead = sum(1 for v in verdicts if v["verdict"] == "DEAD")
    n_live = 22 - n_dead
    # if all 22 die, FLAG an exclusion — never claim
    flag_exclusion = (n_dead == 22)
    out = {
        "p": p,
        "I3_anchor": anc,
        "n_functionals": len(fun_class),
        "n_Z37": n_z37,
        "n_I3": n_i3,
        "n_NONE": n_none,
        "functionals": fun_class,
        "rabinowitsch_control": rab,
        "n_patterns_dead": n_dead,
        "n_patterns_live": n_live,
        "flag_d35_exclusion": flag_exclusion,
        "flag_note": (
            "FLAGGED, not claimed: all 22 unrealizable on V would exclude "
            "d=35 without deciding emptiness of V. Requires ODDZERO audit."
            if flag_exclusion else
            "No exclusion: at least one pattern has an open demand not "
            "proved to vanish on V."
        ),
        "patterns": verdicts,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
    }
    path = os.path.join(RES, "vanish_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1)
    print("  wrote", path)
    print("  PATTERNS dead=%d live=%d flag_exclusion=%s"
          % (n_dead, n_live, flag_exclusion))
    return out


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331)
