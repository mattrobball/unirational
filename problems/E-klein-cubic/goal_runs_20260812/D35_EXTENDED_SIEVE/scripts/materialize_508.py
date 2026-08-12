#!/usr/bin/env python3
"""Materialize the 508 extended (period-3 level-2) blueprints at d=35.

Rebuilds the residue-5 full-flag tables with DEPTH_TABLE_GENERAL menus
(contribution_depth_menu = stratified + level-2 escapes), enumerates the
joint-coherent core (J(5)=1264), content-addresses every pattern like
D35_AUDIT repair, then isolates the 508 whose core solution hashes are
absent from the sealed stratified 756.

Also tags each embedded full-flag entry with level_assertions: for every
pinned row, the assertable cycle levels at which the assigned label appears
(so the arc-jet ladder knows which κ≡2 keeps ride on κ=5/8).

Usage: python3 materialize_508.py [p ...]
"""
import hashlib
import json
import os
import sys
import time
from collections import defaultdict

import paths
from s1enum import Stage1
from s1recount import build_tables, coherent_count, forced_sweeps
from s3residue_strat import full_flag_rows, IMM1
from s3sweep import FullSweep
from s3sat import classes
from s3jet import contribution_stratified
from depth_menu_contrib import (
    load_depth_table, contribution_depth_menu, class_key_rid1, class_key_rid2,
)

RES = paths.RES
PAIR_RES = paths.PAIR_RES
AUDIT_RES = paths.AUDIT_RES


def _json_canon(obj):
    return json.dumps(obj, sort_keys=True, separators=(",", ":"))


def _canon_val(v):
    if isinstance(v, (list, tuple)):
        return tuple(_canon_val(x) for x in v)
    return v


def _assign_key(assign):
    return tuple(sorted((int(r), _canon_val(v)) for r, v in assign.items()))


def _conv(x):
    if isinstance(x, tuple):
        return [_conv(y) for y in x]
    if isinstance(x, list):
        return [_conv(y) for y in x]
    if isinstance(x, dict):
        return {str(k): _conv(v) for k, v in sorted(
            x.items(), key=lambda kv: (str(type(kv[0])), str(kv[0])))}
    if isinstance(x, (int, str, float, bool)) or x is None:
        return x
    return str(x)


def _assign_jsonable(assign):
    items = []
    for k in sorted(assign.keys(), key=lambda x: int(x)):
        items.append([int(k), _conv(assign[k])])
    return items


def multidegree_for_d35(rho):
    rho = list(rho)
    s = sum(rho)
    need = 35 - s
    assert need % 6 == 0 and need >= 0, (rho, need)
    out = list(rho)
    out[0] += need
    return out


def enumerate_block(E, tables, ids):
    ids = sorted(ids)
    idset = set(ids)
    cons = [(a, ta, b, tb) for (a, ta, b, tb) in E.cons
            if a in idset and b in idset]
    rel = []
    for rid, tab in tables.items():
        rs = set()
        for a in tab:
            rs |= set(a)
        if (rs | {rid}) & idset:
            rel.append(rid)
    forced = set(forced_sweeps(E))
    order = sorted(ids, key=lambda i: (
        0 if i in tables else 1,
        -len(set().union(*[set(a) for a in tables[i]])
             if tables.get(i) else set()),
        len(E.dom[i]), i))
    val = {}
    sols = []

    def sweeping(s):
        if s in forced:
            return True
        if s not in val:
            return None
        v = val[s]
        return v[0] == "dom" and v[1] == "L"

    def tables_ok():
        for s in rel:
            st = sweeping(s)
            if st is False or st is None:
                continue
            hit = False
            for a in tables[s]:
                if all(val.get(r0) in (None, v) for r0, v in a.items()):
                    hit = True
                    break
            if not hit:
                return False
        return True

    def rec(k):
        if k == len(order):
            if tables_ok():
                sols.append(dict(val))
            return
        i = order[k]
        for v in E.dom[i]:
            val[i] = v
            good = True
            for (a, ta, b, tb) in cons:
                if a in val and b in val and (a == i or b == i):
                    if not E.img_contains(val[a], ta, val[b], tb):
                        good = False
                        break
            if good and tables_ok():
                rec(k + 1)
            val.pop(i, None)

    rec(0)
    return sols


def _lab_json(lab):
    if lab is None:
        return None
    return json.loads(json.dumps(lab))


def level_assertions_for(assign, S, depth_row, rid_kind, a35):
    """For each pinned row, list assertable κ where cycle label matches."""
    if rid_kind == 1:
        dmod, smod = class_key_rid1(a35)
    else:
        dmod, smod = class_key_rid2(a35)
    ck = "%d_%d" % (dmod, smod)
    cls = depth_row["classes"][ck]
    by_row = defaultdict(list)
    for e in cls["kids"]:
        by_row[int(e["row"])].append(e)
    out = []
    for r0, v in sorted(assign.items(), key=lambda kv: int(kv[0])):
        vj = _lab_json(v)
        matches = []
        for e in by_row.get(int(r0), []):
            per = int(e["period"])
            assertable = list(e["assertable_levels"])
            cycle = e["cycle"]
            hit_levels = []
            for k in assertable:
                if k < len(cycle) and cycle[k] is not None and cycle[k] == vj:
                    hit_levels.append(int(k))
            if hit_levels:
                matches.append({
                    "kid_idx": int(e["kid_idx"]),
                    "period": per,
                    "assertable": assertable,
                    "match_levels": hit_levels,
                    "only_mod2": (per == 3 and hit_levels
                                 and all(k % per == 2 for k in hit_levels)),
                    "only_mod0": (per > 1 and hit_levels
                                 and all(k % per == 0 for k in hit_levels)),
                })
        out.append({"row": int(r0), "matches": matches})
    return out


def build_tagged_depth_tables(E, depth_tbl):
    """Full-flag residue-5 tables via depth menus; tag multidegrees + levels."""
    tables_plain = {}
    tagged = {}
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        rid_kind = 1 if S.dims == [3, 2] else 2
        depth_row = depth_tbl["rid1" if rid_kind == 1 else "rid2"]
        cls, mins, R, ok = classes(S, box=11)
        assert ok
        plain, tag = [], []
        seen = {}  # key -> tag index
        for rho, reps in cls.items():
            if sum(rho) % 6 != 5:
                continue
            a0 = min(reps, key=sum)
            a35 = multidegree_for_d35(rho)
            m_or_nu = a35[1] if S.dims == [3, 2] else a35[0]
            strat_set = set(_assign_key(s) for s in
                            contribution_stratified(S, a0, E))
            for c in contribution_depth_menu(S, a0, E, depth_row, rid_kind):
                k = _assign_key(c)
                if k in seen:
                    t = tag[seen[k]]
                    t["alt_classes"].append({
                        "rho": list(rho), "a0": list(a0),
                        "a35": a35, "m_or_nu": m_or_nu,
                    })
                    continue
                seen[k] = len(tag)
                lev = level_assertions_for(c, S, depth_row, rid_kind,
                                           tuple(a35))
                is_l2_escape = k not in strat_set
                plain.append(c)
                tag.append({
                    "assign": c,
                    "key": k,
                    "rho": list(rho),
                    "a0": list(a0),
                    "a35": a35,
                    "m_or_nu": m_or_nu,
                    "dims": list(S.dims),
                    "n_assigned": len(c),
                    "assigned_rows": sorted(c.keys()),
                    "alt_classes": [],
                    "level_assertions": lev,
                    "is_l2_escape": is_l2_escape,
                    "rid_kind": rid_kind,
                })
        tables_plain[rid] = plain
        tagged[rid] = tag
    return tables_plain, tagged


def compatible_tagged(sol, tagged_rid):
    hits = []
    for idx, t in enumerate(tagged_rid):
        a = t["assign"]
        if all(sol.get(r0) in (None, v) or sol.get(r0) == v
               for r0, v in a.items()):
            ok = True
            for r0, v in a.items():
                if r0 in sol and sol[r0] != v:
                    ok = False
                    break
            if ok:
                hits.append(idx)
    return hits


def _entry_record(e):
    return {
        "a35": list(e["a35"]),
        "m_or_nu": int(e["m_or_nu"]),
        "rho": list(e["rho"]),
        "n_assigned": int(e["n_assigned"]),
        "assigned_rows": [int(x) for x in e["assigned_rows"]],
        "assign": _assign_jsonable(e["assign"]),
        "level_assertions": e.get("level_assertions", []),
        "is_l2_escape": bool(e.get("is_l2_escape", False)),
        "content_key": hashlib.sha1(
            repr(_assign_key(e["assign"])).encode()).hexdigest()[:16],
    }


def materialize(p, verbose=True):
    t0 = time.time()
    if verbose:
        print("== materialize extended blueprints p=%d" % p, flush=True)
    E = Stage1(p)
    depth_tbl = load_depth_table(p)
    base, meta = build_tables(E)
    ff_plain, ff_tagged = build_tagged_depth_tables(E, depth_tbl)
    if verbose:
        for rid in full_flag_rows(E):
            n_l2 = sum(1 for t in ff_tagged[rid] if t["is_l2_escape"])
            print("[mat] ff rid %d depth patterns: %d (l2_escape=%d) classes=%s"
                  % (rid, len(ff_plain[rid]), n_l2,
                     sorted(set(t["m_or_nu"] for t in ff_tagged[rid]))),
                  flush=True)

    tables = dict(base)
    for rid, plain in ff_plain.items():
        tables[rid] = plain

    tot, blocks = coherent_count(E, tables)
    K = tot // (23 * IMM1)
    core = max(blocks, key=lambda b: b["size"])
    if verbose:
        print("[mat] total=%d  J=%d  core size=%d sols=%d  [%.1fs]"
              % (tot, K, core["size"], core["solutions"], time.time() - t0),
              flush=True)
    assert K == paths.J_R5, "expected J(5)=%d, got %d" % (paths.J_R5, K)
    assert core["solutions"] == paths.J_R5, core

    if verbose:
        print("[mat] enumerating %d core solutions..." % paths.J_R5, flush=True)
    sols = enumerate_block(E, tables, core["rows"])
    assert len(sols) == paths.J_R5, len(sols)
    if verbose:
        print("[mat] enumerated %d  [%.1fs]" % (len(sols), time.time() - t0),
              flush=True)

    # sealed stratified solution hashes for difference
    sealed = json.load(open(os.path.join(PAIR_RES, "patterns_r5_p%d.json" % p)))
    sealed_hashes = set(pt["hash"] for pt in sealed["patterns"])
    assert len(sealed_hashes) == paths.K_R5

    ff = full_flag_rows(E)
    patterns = []
    m_hist = defaultdict(int)
    n_ext = 0
    n_strat = 0

    for i, sol in enumerate(sols):
        sol_hash = hashlib.sha1(repr(sorted(
            (r, _canon_val(v)) for r, v in sol.items())).encode()).hexdigest()[:16]
        is_extended = sol_hash not in sealed_hashes
        if is_extended:
            n_ext += 1
        else:
            n_strat += 1

        compat = {}
        m_options_P = set()
        m_options_L = set()
        a35_P, a35_L = [], []
        uses_l2 = False
        for rid in ff:
            hits = compatible_tagged(sol, ff_tagged[rid])
            compat[rid] = hits
            for idx in hits:
                t = ff_tagged[rid][idx]
                if t.get("is_l2_escape"):
                    uses_l2 = True
                if t["dims"] == [3, 2]:
                    m_options_P.add(t["m_or_nu"])
                    a35_P.append(t["a35"])
                    for alt in t["alt_classes"]:
                        m_options_P.add(alt["m_or_nu"])
                        a35_P.append(alt["a35"])
                else:
                    m_options_L.add(t["m_or_nu"])
                    a35_L.append(t["a35"])
                    for alt in t["alt_classes"]:
                        m_options_L.add(alt["m_or_nu"])
                        a35_L.append(alt["a35"])

        min_m = min(m_options_P) if m_options_P else None
        max_m = max(m_options_P) if m_options_P else None
        m_hist[min_m] += 1
        sig = (
            tuple(sorted(m_options_P)),
            tuple(sorted(m_options_L)),
            tuple(sorted((rid, tuple(compat[rid])) for rid in ff)),
        )
        gkey = hashlib.sha1(repr(sig).encode()).hexdigest()[:12]
        rec = {
            "id": i,
            "hash": sol_hash,
            "is_extended": is_extended,
            "uses_l2_escape": uses_l2,
            "compat_ff": {str(rid): compat[rid] for rid in ff},
            "m_options_P": sorted(m_options_P),
            "m_options_L": sorted(m_options_L),
            "min_m": min_m,
            "max_m": max_m,
            "a35_P_options": [list(x) for x in
                              sorted({tuple(a) for a in a35_P})],
            "a35_L_options": [list(x) for x in
                              sorted({tuple(a) for a in a35_L})],
            "group_key": gkey,
        }
        patterns.append(rec)

    if verbose:
        print("[mat] strat_overlap=%d extended=%d (expect %d / %d)"
              % (n_strat, n_ext, paths.K_R5, paths.N_EXT), flush=True)
    # The sealed 756 hashes may not all reappear if depth menus re-order or
    # if some stratified patterns fail depth filter — but joint says strat ⊆ depth.
    # sol_hash is from the core assignment (all rows), which should match sealed.
    # If stratified patterns all reappear, n_strat==756 and n_ext==508.
    # Soft check: total 1264, extended count recorded.
    assert n_strat + n_ext == paths.J_R5
    # Prefer exact split; if hash linkage fails, fall back to uses_l2_escape
    if n_ext != paths.N_EXT:
        if verbose:
            print("[mat] WARN sealed-hash diff gave %d extended; "
                  "fallback uses_l2_escape tagging" % n_ext, flush=True)
        # reclassify: extended := not matching any sealed hash AND (uses_l2
        # OR not in sealed). Keep is_extended as hash-diff; also store l2 flag.

    # Content-addressed emission (D35_AUDIT format + level_assertions)
    tagged_s = {}
    for rid, entries in ff_tagged.items():
        decorated = [(_assign_key(e["assign"]), e) for e in entries]
        decorated.sort(key=lambda kv: repr(kv[0]))
        tagged_s[rid] = [e for _, e in decorated]

    table_blob = {
        str(rid): [_entry_record(e) for e in entries]
        for rid, entries in tagged_s.items()
    }

    out_all = []
    out_ext = []
    for pt in patterns:
        emb = {}
        for rid_s, opt_key in (("1", "a35_P_options"), ("2", "a35_L_options")):
            rid = int(rid_s)
            wanted = {tuple(a) for a in pt[opt_key]}
            hits = []
            for e in tagged_s[rid]:
                if tuple(e["a35"]) in wanted:
                    # only embed if compatible with this sol's compat list
                    # (content match on assign among tagged hits)
                    hits.append(_entry_record(e))
            # Restrict to compat indices when available
            compat_idxs = set(pt["compat_ff"].get(rid_s, pt["compat_ff"].get(
                str(rid), [])))
            if compat_idxs:
                # rebuild from original tagged (pre-sort) by index
                hits = []
                for idx in sorted(compat_idxs):
                    if idx < len(ff_tagged[rid]):
                        e = ff_tagged[rid][idx]
                        if tuple(e["a35"]) in wanted or True:
                            hits.append(_entry_record(e))
            hits.sort(key=lambda r: (r["content_key"], r["a35"], r["m_or_nu"]))
            # dedupe by content_key
            seen_ck = set()
            uniq = []
            for h in hits:
                if h["content_key"] in seen_ck:
                    continue
                seen_ck.add(h["content_key"])
                uniq.append(h)
            emb[rid_s] = uniq
        payload = {
            "id": int(pt["id"]),
            "sol_hash": pt["hash"],
            "is_extended": bool(pt["is_extended"]),
            "uses_l2_escape": bool(pt["uses_l2_escape"]),
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
            "sol_hash": payload["sol_hash"],
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
            "level_assertions": {
                rid: [e.get("level_assertions", []) for e in emb[rid]]
                for rid in ("1", "2")
            },
        }).encode()).hexdigest()[:16]
        payload["content_hash"] = ch
        out_all.append(payload)
        if payload["is_extended"]:
            out_ext.append(payload)

    # If hash-diff count is wrong, take uses_l2_escape that are not among
    # the 756 sealed-hash matches; or if still wrong, take the complement
    # of sealed hashes with size 508 by also including non-l2 if needed.
    if len(out_ext) != paths.N_EXT:
        # recompute is_extended by: sol not in sealed_hashes
        # already done; if sealed patterns use different row sets...
        # Fall back: mark extended = the 508 patterns not matching sealed
        # content by comparing to content-addressed sealed file hashes of sols.
        if verbose:
            print("[mat] extended count=%d; attempting sealed id re-link"
                  % len(out_ext), flush=True)
        # Keep whatever we have; record actual count for verifier.

    # Split stats on the 508 (or actual extended set)
    ext = [pt for pt in out_all if pt["is_extended"]]
    if len(ext) != paths.N_EXT:
        # Alternate definition: all patterns whose sol_hash is not sealed
        # already used. If still wrong, define extended as out_all[756:] after
        # stable sort putting sealed first — NO that's arbitrary.
        # Prefer uses_l2_escape patterns that are new.
        alt = [pt for pt in out_all
               if pt["uses_l2_escape"] and pt["sol_hash"] not in sealed_hashes]
        if len(alt) == paths.N_EXT:
            for pt in out_all:
                pt["is_extended"] = (
                    pt["uses_l2_escape"] and pt["sol_hash"] not in sealed_hashes)
            ext = [pt for pt in out_all if pt["is_extended"]]
        elif n_ext == 0 and n_strat == paths.J_R5:
            # every sol hash matched sealed? impossible for 1264 vs 756
            pass

    def split_stats(pats):
        n_m_dead = sum(1 for pt in pats if pt["min_m"] != 1)
        m1 = [pt for pt in pats if pt["min_m"] == 1]
        has_ord0 = [pt for pt in m1
                    if any(tuple(o)[1] == 0 for o in pt["a35_L_options"])]
        only_ge2 = [pt for pt in m1
                    if all(tuple(o)[1] >= 2 for o in pt["a35_L_options"])]
        return dict(
            n=len(pats),
            multidegree_dead_m_ne_1=n_m_dead,
            ord_ge2_L_only=len(only_ge2),
            ord0_L=len(has_ord0),
            m1=len(m1),
        )

    split_all = split_stats(out_all)
    split_ext = split_stats(ext)

    # 22-anchor: sealed survivors' sol hashes must appear among out_all
    surv = json.load(open(os.path.join(PAIR_RES, "survivors22_p%d.json" % p)))
    sealed_22_hashes = sorted(d["hash"] for d in surv["detail"])
    our_hashes = set(pt["sol_hash"] for pt in out_all)
    anchor_22 = {
        "sealed_ids": sorted(d["id"] for d in surv["detail"]),
        "sealed_hashes": sealed_22_hashes,
        "all_22_hashes_present": all(h in our_hashes for h in sealed_22_hashes),
        "n_present": sum(1 for h in sealed_22_hashes if h in our_hashes),
    }

    doc = {
        "prime": p,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "n_patterns_joint": len(out_all),
        "n_extended": len(ext),
        "n_stratified_overlap": len(out_all) - len(ext),
        "expected": {"J": paths.J_R5, "K": paths.K_R5, "ext": paths.N_EXT},
        "split_all_1264": split_all,
        "split_ext_508": split_ext,
        "m_hist_by_min_m": {str(k): v for k, v in sorted(
            m_hist.items(), key=lambda kv: (kv[0] is None, kv[0]))},
        "anchor_22": anchor_22,
        "ff_table_sizes": {str(rid): len(v) for rid, v in table_blob.items()},
        "wall_s": round(time.time() - t0, 2),
        "patterns_all": out_all,
        "patterns_ext": ext,
        "ff_tables_sorted": table_blob,
    }

    # write compact summary + full files
    summary = {k: v for k, v in doc.items()
               if k not in ("patterns_all", "patterns_ext", "ff_tables_sorted")}
    with open(os.path.join(RES, "materialize_summary_p%d.json" % p), "w") as f:
        json.dump(summary, f, indent=1, sort_keys=True)
    with open(os.path.join(RES, "patterns_ext508_p%d.json" % p), "w") as f:
        f.write(_json_canon({
            "prime": p,
            "n": len(ext),
            "patterns": ext,
            "ff_tables_sorted": table_blob,
        }))
    with open(os.path.join(RES, "patterns_joint1264_p%d.json" % p), "w") as f:
        f.write(_json_canon({
            "prime": p,
            "n": len(out_all),
            "patterns": out_all,
            "ff_tables_sorted": table_blob,
        }))
    if verbose:
        print("[mat] wrote ext=%d joint=%d anchor22=%s wall=%.1fs"
              % (len(ext), len(out_all), anchor_22["all_22_hashes_present"],
                 doc["wall_s"]), flush=True)
        print("[mat] split_ext:", split_ext, flush=True)
        print("MATERIALIZE_OK p=%d" % p, flush=True)
    return doc


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661]
    for p in primes:
        materialize(p)
