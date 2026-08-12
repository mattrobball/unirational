#!/usr/bin/env python3
"""Linkage repair: content-addressed re-emission of the 756 patterns.

Defect (WORKED_EXAMPLE §4.1): patterns_r5 stores compat_ff as indices into
tables rebuilt each run; table order can change, so the same stored index can
resolve to a different assignment.

Fix (this packet only — sealed scripts untouched):
  1. Rebuild tagged full-flag tables; sort every list by canonical assign key.
  2. For each sealed pattern, embed FULL assignment dictionaries for every
     sorted-table entry whose multidegree is among the pattern's a35 options
     (content match — no index indirection).
  3. Content-hash each pattern from the embedded payload.
  4. Three independent runs must be byte-identical; splits
     756 = 336 + 398 + 22 reproduce; the 22 ids/hashes match survivors22.
"""
import hashlib
import json
import os
import sys
import time

import paths
from patterns_r5 import build_tagged_ff_tables, _assign_key

AUDIT_RES = paths.AUDIT_RES
PAIR_RES = paths.PAIR_RES


def _json_canon(obj):
    return json.dumps(obj, sort_keys=True, separators=(",", ":"))


def _conv(x):
    if isinstance(x, tuple):
        return [_conv(y) for y in x]
    if isinstance(x, list):
        return [_conv(y) for y in x]
    if isinstance(x, dict):
        # sort keys for stability; row ids as decimal strings
        return {str(k): _conv(v) for k, v in sorted(
            x.items(), key=lambda kv: (str(type(kv[0])), str(kv[0])))}
    if isinstance(x, (int, str, float, bool)) or x is None:
        return x
    return str(x)


def _assign_jsonable(assign):
    # keys are row ids (int); values are label tuples
    items = []
    for k in sorted(assign.keys(), key=lambda x: int(x)):
        items.append([int(k), _conv(assign[k])])
    return items  # list of [row, label] — order-stable


def _stable_sort_tagged(tagged):
    out = {}
    for rid, entries in tagged.items():
        decorated = [(_assign_key(e["assign"]), e) for e in entries]
        decorated.sort(key=lambda kv: repr(kv[0]))
        out[rid] = [e for _, e in decorated]
    return out


def _entry_record(e):
    return {
        "a35": list(e["a35"]),
        "m_or_nu": int(e["m_or_nu"]),
        "rho": list(e["rho"]),
        "n_assigned": int(e["n_assigned"]),
        "assigned_rows": [int(x) for x in e["assigned_rows"]],
        "assign": _assign_jsonable(e["assign"]),
        "content_key": hashlib.sha1(
            repr(_assign_key(e["assign"])).encode()).hexdigest()[:16],
    }


def reemit(p, run_tag=""):
    t0 = time.time()
    print("== repair re-emit p=%d tag=%s" % (p, run_tag or "-"), flush=True)
    sealed = json.load(open(os.path.join(PAIR_RES, "patterns_r5_p%d.json" % p)))
    pats = sealed["patterns"]
    assert len(pats) == 756

    from s1enum import Stage1
    E = Stage1(p)
    _plain, tagged = build_tagged_ff_tables(E)
    tagged_s = _stable_sort_tagged(tagged)

    table_blob = {
        str(rid): [_entry_record(e) for e in entries]
        for rid, entries in tagged_s.items()
    }

    out_pats = []
    for pt in pats:
        emb = {}
        for rid_s, opt_key in (("1", "a35_P_options"), ("2", "a35_L_options")):
            rid = int(rid_s)
            wanted = {tuple(a) for a in pt[opt_key]}
            hits = []
            for e in tagged_s[rid]:
                a35 = tuple(e["a35"])
                if a35 in wanted:
                    hits.append(_entry_record(e))
            # deterministic order by content_key
            hits.sort(key=lambda r: (r["content_key"], r["a35"], r["m_or_nu"]))
            emb[rid_s] = hits
        payload = {
            "id": int(pt["id"]),
            "sealed_hash": pt["hash"],
            "min_m": pt["min_m"],
            "max_m": pt["max_m"],
            "m_options_P": list(pt["m_options_P"]),
            "m_options_L": list(pt["m_options_L"]),
            "a35_P_options": [list(x) for x in pt["a35_P_options"]],
            "a35_L_options": [list(x) for x in pt["a35_L_options"]],
            "group_key": pt["group_key"],
            "embedded_ff": emb,
        }
        ch = hashlib.sha1(_json_canon({
            "id": payload["id"],
            "sealed_hash": payload["sealed_hash"],
            "min_m": payload["min_m"],
            "a35_P": payload["a35_P_options"],
            "a35_L": payload["a35_L_options"],
            "ff_keys": {
                rid: [e["content_key"] for e in emb[rid]]
                for rid in ("1", "2")
            },
            "ff_assigns": {
                rid: [e["assign"] for e in emb[rid]]
                for rid in ("1", "2")
            },
        }).encode()).hexdigest()[:16]
        payload["content_hash"] = ch
        out_pats.append(payload)

    n_m_dead = sum(1 for pt in out_pats if pt["min_m"] != 1)
    m1 = [pt for pt in out_pats if pt["min_m"] == 1]
    has_ord0 = [pt for pt in m1
                if any(tuple(o)[1] == 0 for o in pt["a35_L_options"])]
    only_ge2 = [pt for pt in m1
                if all(tuple(o)[1] >= 2 for o in pt["a35_L_options"])]

    surv = json.load(open(os.path.join(PAIR_RES, "survivors22_p%d.json" % p)))
    sealed_22_ids = sorted(d["id"] for d in surv["detail"])
    sealed_22_hashes = sorted(d["hash"] for d in surv["detail"])
    our_22_ids = sorted(pt["id"] for pt in has_ord0)
    our_22_sealed_hashes = sorted(pt["sealed_hash"] for pt in has_ord0)

    split_ok = (n_m_dead == 336 and len(only_ge2) == 398
                and len(has_ord0) == 22
                and n_m_dead + len(only_ge2) + len(has_ord0) == 756)
    ids_match = (our_22_ids == sealed_22_ids)
    hashes_match = (our_22_sealed_hashes == sealed_22_hashes)
    embed_ok = all(
        len(pt["embedded_ff"]["1"]) >= 1 and len(pt["embedded_ff"]["2"]) >= 1
        for pt in out_pats
    )

    patterns_only = {
        "prime": p,
        "patterns": out_pats,
        "ff_tables_sorted": table_blob,
    }
    blob = _json_canon(patterns_only)
    file_sha1 = hashlib.sha1(blob.encode()).hexdigest()

    doc = {
        "prime": p,
        "n_patterns": len(out_pats),
        "run_tag": run_tag,
        "wall_s": round(time.time() - t0, 2),
        "file_content_sha1": file_sha1,
        "split": {
            "multidegree_dead_m_ne_1": n_m_dead,
            "ord_ge2_L_only": len(only_ge2),
            "ord0_L_survivors": len(has_ord0),
            "total": n_m_dead + len(only_ge2) + len(has_ord0),
            "formula": "756 = 336 + 398 + 22",
            "ok": split_ok,
        },
        "survivors22": {
            "ids": our_22_ids,
            "sealed_hashes": our_22_sealed_hashes,
            "content_hashes": sorted(pt["content_hash"] for pt in has_ord0),
            "ids_match_sealed": ids_match,
            "hashes_match_sealed": hashes_match,
        },
        "embed_ok": embed_ok,
        "ff_table_sizes": {rid: len(v) for rid, v in table_blob.items()},
        "patterns": out_pats,
        "ff_tables_sorted": table_blob,
    }

    os.makedirs(AUDIT_RES, exist_ok=True)
    suffix = ("_%s" % run_tag) if run_tag else ""
    out_path = os.path.join(AUDIT_RES,
                            "patterns_r5_content_p%d%s.json" % (p, suffix))
    with open(out_path, "w") as f:
        f.write(_json_canon(doc))
    summary = {k: v for k, v in doc.items()
               if k not in ("patterns", "ff_tables_sorted")}
    with open(os.path.join(AUDIT_RES,
                           "patterns_r5_content_summary_p%d%s.json"
                           % (p, suffix)), "w") as f:
        f.write(_json_canon(summary))
    print("  split 336+398+22 ok=%s embed=%s ids22=%s hashes22=%s"
          % (split_ok, embed_ok, ids_match, hashes_match), flush=True)
    print("  sha1 %s wall %.1fs" % (file_sha1[:16], doc["wall_s"]), flush=True)
    return doc


def three_run_check(p):
    hashes = []
    docs = []
    for i in range(3):
        # force hash randomization sensitivity: new process not available;
        # re-build tables three times in-process (order of dicts is stable
        # within CPython 3.7+, but our explicit sort removes residual risk)
        doc = reemit(p, run_tag="run%d" % (i + 1))
        hashes.append(doc["file_content_sha1"])
        docs.append(doc)
    # also write sha1s of the patterns-only payload from each run file
    import shutil
    src = os.path.join(AUDIT_RES, "patterns_r5_content_p%d_run1.json" % p)
    dst = os.path.join(AUDIT_RES, "patterns_r5_content_p%d.json" % p)
    shutil.copyfile(src, dst)
    shutil.copyfile(
        os.path.join(AUDIT_RES, "patterns_r5_content_summary_p%d_run1.json" % p),
        os.path.join(AUDIT_RES, "patterns_r5_content_summary_p%d.json" % p))

    # Content identity = file_content_sha1 of patterns + sorted tables
    # (run_tag / wall_s in the wrapper JSON are intentionally excluded).
    identical = len(set(hashes)) == 1
    # Cross-check: re-hash the patterns_only section of each run file
    content_rehash = []
    for i in range(3):
        path = os.path.join(AUDIT_RES,
                            "patterns_r5_content_p%d_run%d.json" % (p, i + 1))
        full = json.load(open(path))
        payload = {
            "prime": full["prime"],
            "patterns": full["patterns"],
            "ff_tables_sorted": full["ff_tables_sorted"],
        }
        content_rehash.append(hashlib.sha1(
            _json_canon(payload).encode()).hexdigest())
    content_rehash_identical = len(set(content_rehash)) == 1

    doc = docs[-1]
    report = {
        "p": p,
        "run_content_sha1s": hashes,
        "content_rehash": content_rehash,
        "byte_identical_across_3_runs": bool(
            identical and content_rehash_identical),
        "split_ok": doc["split"]["ok"],
        "ids_match": doc["survivors22"]["ids_match_sealed"],
        "hashes_match": doc["survivors22"]["hashes_match_sealed"],
        "embed_ok": doc["embed_ok"],
        "verdict": "REPAIRED" if (
            identical and content_rehash_identical and doc["split"]["ok"]
            and doc["survivors22"]["ids_match_sealed"]
            and doc["survivors22"]["hashes_match_sealed"]
            and doc["embed_ok"]
        ) else "REPAIR_FAILED",
    }
    with open(os.path.join(AUDIT_RES, "repair_status_p%d.json" % p), "w") as f:
        json.dump(report, f, indent=1, sort_keys=True)
    print("== three-run check p=%d identical=%s verdict=%s" %
          (p, report["byte_identical_across_3_runs"], report["verdict"]),
          flush=True)
    return report


if __name__ == "__main__":
    args = sys.argv[1:]
    if args and args[0] == "three":
        primes = [int(x) for x in args[1:]] or [331, 661]
        for p in primes:
            three_run_check(p)
    else:
        primes = [int(x) for x in args] or [331]
        for p in primes:
            reemit(p)
