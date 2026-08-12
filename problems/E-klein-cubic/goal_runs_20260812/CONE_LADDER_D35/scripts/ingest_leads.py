#!/usr/bin/env python3
"""Ingest any completed msolve -g 1 outputs into rung_*.json and summary.json."""
from __future__ import annotations

import json
import os
import re
import sys

import conelib as C
import paths

RES = paths.RES


def seconds_from_log(path):
    if not os.path.isfile(path):
        return None
    t = open(path).read()
    mm = re.search(r"msolve overall time\s+([0-9.]+) sec", t)
    return float(mm.group(1)) if mm else None


def ingest_one(m, p):
    rec_path = os.path.join(RES, "rung_m%d_p%d.json" % (m, p))
    if not os.path.isfile(rec_path):
        return None
    rec = json.load(open(rec_path))
    if rec.get("free_rung"):
        return rec
    out = os.path.join(RES, "cone_m%d_p%d_lead.out" % (m, p))
    log = os.path.join(RES, "cone_m%d_p%d_msolve.log" % (m, p))
    if not os.path.isfile(out) or os.path.getsize(out) == 0:
        return rec
    lead = C.parse_leading_ideal(out)
    sec = seconds_from_log(log)
    rec["verdict"] = (
        "ZERO_DIM" if lead.get("zero_dimensional")
        else ("NOT_ZERO_DIM" if lead.get("ok") else "NO_VERDICT_PARSE")
    )
    rec["clears"] = bool(lead.get("zero_dimensional"))
    if rec["clears"]:
        rec["V_cap_L"] = "{0}"
        rec["bound"] = 37 - m
    rec["msolve"] = {
        "returncode": 0,
        "seconds": sec,
        "timed_out": False,
        "verdict": rec["verdict"],
        "threads": 4,
        "lead": lead,
    }
    with open(rec_path, "w") as f:
        json.dump(rec, f, indent=1)
    print("ingested m=%d p=%d %s bound=%s nlead=%s sec=%s"
          % (m, p, rec["verdict"], rec.get("bound"), lead.get("nlead"), sec))
    return rec


def main():
    ms = [18, 19, 20, 22, 24, 28, 32, 34, 36, 37]
    for p in (331, 661):
        for m in ms:
            ingest_one(m, p)


if __name__ == "__main__":
    main()
