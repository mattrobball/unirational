#!/usr/bin/env python3
"""Orchestrate extract + vanish at p=331 and p=661; write summary.json.

Usage: python3 produce.py
       python3 produce.py 331
"""
from __future__ import annotations

import json
import os
import sys
import time

import paths
import extract_open
import test_vanish

RES = paths.RES


def dump(name, obj):
    path = os.path.join(RES, name)
    with open(path, "w") as f:
        json.dump(obj, f, indent=1)
    return path


def compile_summary(primes):
    rows = []
    for p in primes:
        vpath = os.path.join(RES, "vanish_p%d.json" % p)
        epath = os.path.join(RES, "open_demands_p%d.json" % p)
        if not os.path.isfile(vpath):
            continue
        V = json.load(open(vpath))
        E = json.load(open(epath)) if os.path.isfile(epath) else {}
        rows.append({
            "p": p,
            "n_functionals": V.get("n_functionals"),
            "n_Z37": V.get("n_Z37"),
            "n_I3": V.get("n_I3"),
            "n_NONE": V.get("n_NONE"),
            "n_patterns_dead": V.get("n_patterns_dead"),
            "n_patterns_live": V.get("n_patterns_live"),
            "flag_d35_exclusion": V.get("flag_d35_exclusion"),
            "rigidity": (E.get("level_rigidity") or {}),
            "forced_deeper": E.get("forced_deeper_rows"),
            "rabin_tautology": all(
                r.get("interpretation") == "TAUTOLOGICAL_EMPTY"
                for r in ((V.get("rabinowitsch_control") or {}).get("runs")
                          or [])
            ) if (V.get("rabinowitsch_control") or {}).get("runs") else None,
        })
    both = [r for r in rows if r["p"] in (331, 661)]
    agree = False
    if len(both) == 2:
        a, b = both[0], both[1]
        agree = (a["n_patterns_dead"] == b["n_patterns_dead"]
                 and a["n_patterns_live"] == b["n_patterns_live"]
                 and a["flag_d35_exclusion"] == b["flag_d35_exclusion"])
    out = {
        "primes": [r["p"] for r in rows],
        "rows": rows,
        "cross_prime_agree": agree,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "any_exclusion_claimed": False,
    }
    dump("summary.json", out)
    return out


def main(argv):
    if argv:
        primes = [int(x) for x in argv]
    else:
        primes = [331, 661]
    t0 = time.time()
    for p in primes:
        print("==== prime", p, flush=True)
        extract_open.main(p)
        test_vanish.main(p)
    summ = compile_summary(primes)
    print("==== summary", json.dumps(summ, indent=1))
    print("elapsed %.1fs" % (time.time() - t0))


if __name__ == "__main__":
    main(sys.argv[1:])
