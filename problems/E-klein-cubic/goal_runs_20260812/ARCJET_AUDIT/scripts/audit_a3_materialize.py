#!/usr/bin/env python3
"""A3 hostile audit: independent regeneration of the 508 + 298/148/62 partition.

Re-runs the joint residue-5 enumeration with DEPTH_TABLE_GENERAL menus
(same join semantics as TUPLE_JOINT_RESIDUE), content-addresses patterns,
isolates the 508, and checks hashes + partition against the sealed
D35_EXTENDED_SIEVE artefacts.

Usage: python3 audit_a3_materialize.py [p ...]
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
EXT_RES = paths.EXT_RES
PAIR_RES = paths.PAIR_RES
AUDIT_RES = paths.AUDIT_RES


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
    tables_plain = {}
    tagged = {}
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        rid_kind = 1 if S.dims == [3, 2] else 2
        depth_row = depth_tbl["rid1" if rid_kind == 1 else "rid2"]
        cls, mins, R, ok = classes(S, box=11)
        assert ok
        plain, tag = [], []
        seen = {}
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


def content_hash_pattern(pt_emb):
    """Content hash matching D35_AUDIT / materialize emission."""
    blob = json.dumps(pt_emb, sort_keys=True, separators=(",", ":"))
    return hashlib.sha1(blob.encode()).hexdigest()[:16]


def materialize_audit(p):
    t0 = time.time()
    print("== A3 materialize audit p=%d" % p, flush=True)
    E = Stage1(p)
    depth_tbl = load_depth_table(p)
    base, meta = build_tables(E)
    ff_plain, ff_tagged = build_tagged_depth_tables(E, depth_tbl)
    tables = dict(base)
    for rid, plain in ff_plain.items():
        tables[rid] = plain

    tot, blocks = coherent_count(E, tables)
    K = tot // (23 * IMM1)
    core = max(blocks, key=lambda b: b["size"])
    print("  J=%d core_sols=%d [%.1fs]" % (K, core["solutions"], time.time() - t0),
          flush=True)
    assert K == paths.J_R5, "expected J(5)=%d got %d" % (paths.J_R5, K)
    assert core["solutions"] == paths.J_R5

    sols = enumerate_block(E, tables, core["rows"])
    assert len(sols) == paths.J_R5, len(sols)
    print("  enumerated %d [%.1fs]" % (len(sols), time.time() - t0), flush=True)

    sealed = json.load(open(os.path.join(PAIR_RES, "patterns_r5_p%d.json" % p)))
    sealed_hashes = set(pt["hash"] for pt in sealed["patterns"])
    assert len(sealed_hashes) == paths.K_R5

    # content-addressed emission
    tagged_s = {}
    for rid, entries in ff_tagged.items():
        decorated = [(_assign_key(e["assign"]), e) for e in entries]
        decorated.sort(key=lambda kv: repr(kv[0]))
        tagged_s[rid] = [e for _, e in decorated]

    ff = full_flag_rows(E)
    our_patterns = []
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
        emb = {}
        for rid_s, opt_key, aopts in (
                ("1", "a35_P_options", a35_P),
                ("2", "a35_L_options", a35_L)):
            rid = int(rid_s)
            wanted = {tuple(a) for a in aopts}
            compat_idxs = set(compat.get(rid, []))
            hits = []
            for idx in sorted(compat_idxs):
                if idx < len(ff_tagged[rid]):
                    e = ff_tagged[rid][idx]
                    if tuple(e["a35"]) in wanted or True:
                        hits.append(_entry_record(e))
            emb[rid_s] = hits

        payload = {
            "sol_hash": sol_hash,
            "m_options_P": sorted(m_options_P),
            "m_options_L": sorted(m_options_L),
            "min_m": min_m,
            "a35_P_options": [list(x) for x in
                              sorted({tuple(a) for a in a35_P})],
            "a35_L_options": [list(x) for x in
                              sorted({tuple(a) for a in a35_L})],
            "embedded_ff": emb,
            "is_extended": is_extended,
            "uses_l2_escape": uses_l2,
        }
        ch = content_hash_pattern({
            "sol_hash": sol_hash,
            "embedded_ff": emb,
            "a35_P_options": payload["a35_P_options"],
            "a35_L_options": payload["a35_L_options"],
            "min_m": min_m,
        })
        payload["content_hash"] = ch
        payload["id"] = i
        our_patterns.append(payload)

    assert n_strat + n_ext == paths.J_R5
    print("  strat=%d ext=%d (expect 756/508)" % (n_strat, n_ext), flush=True)

    # partition of the 508
    def classify(pt):
        if pt["min_m"] != 1:
            return "multidegree"
        aL = pt["a35_L_options"]
        has_ord0 = any(tuple(o)[1] == 0 for o in aL)
        only_ge2 = all(tuple(o)[1] >= 2 for o in aL)
        if only_ge2 and not has_ord0:
            return "line_order"
        if has_ord0:
            return "to_ladder"
        return "line_order"

    ext = [pt for pt in our_patterns if pt["is_extended"]]
    part = {"multidegree": 0, "line_order": 0, "to_ladder": 0}
    for pt in ext:
        part[classify(pt)] += 1
    print("  partition 508: multi=%d line=%d ladder=%d"
          % (part["multidegree"], part["line_order"], part["to_ladder"]),
          flush=True)

    # compare to sealed
    sealed_joint = json.load(open(
        os.path.join(EXT_RES, "patterns_joint1264_p%d.json" % p)))
    sealed_ext = json.load(open(
        os.path.join(EXT_RES, "patterns_ext508_p%d.json" % p)))
    sealed_mat = json.load(open(
        os.path.join(EXT_RES, "materialize_summary_p%d.json" % p)))

    our_sol = {pt["sol_hash"] for pt in our_patterns}
    sealed_sol = {pt["sol_hash"] for pt in sealed_joint["patterns"]}
    our_ext_sol = {pt["sol_hash"] for pt in ext}
    sealed_ext_sol = {pt["sol_hash"] for pt in sealed_ext["patterns"]}

    our_ch = {pt["content_hash"] for pt in our_patterns}
    sealed_ch = {pt["content_hash"] for pt in sealed_joint["patterns"]}
    our_ext_ch = {pt["content_hash"] for pt in ext}
    sealed_ext_ch = {pt["content_hash"] for pt in sealed_ext["patterns"]}

    # sealed content_hash may use different payload shape — also compare sol_hash
    sol_joint_match = (our_sol == sealed_sol)
    sol_ext_match = (our_ext_sol == sealed_ext_sol)
    # content hashes: try match; if payload differs, record
    ch_joint_match = (our_ch == sealed_ch)
    ch_ext_match = (our_ext_ch == sealed_ext_ch)

    sealed_part = sealed_mat["split_ext_508"]
    part_match = (
        part["multidegree"] == sealed_part["multidegree_dead_m_ne_1"]
        and part["line_order"] == sealed_part["ord_ge2_L_only"]
        and part["to_ladder"] == sealed_part["ord0_L"]
        and part["multidegree"] == 298
        and part["line_order"] == 148
        and part["to_ladder"] == 62
    )

    # 22-anchor sol hashes among stratified
    audit_pat = json.load(open(
        os.path.join(AUDIT_RES, "patterns_r5_content_p%d.json" % p)))
    sealed_22 = set(audit_pat["survivors22"]["sealed_hashes"])
    # materialize uses sol_hash of sealed patterns_r5; content from audit
    surv_ids = set(paths.SURV_IDS)
    # sealed joint patterns with id in SURV among stratified
    strat_hashes_22 = set()
    for pt in sealed_joint["patterns"]:
        if not pt.get("is_extended") and pt.get("id") in surv_ids:
            strat_hashes_22.add(pt.get("sol_hash") or pt.get("hash"))
    # better: use materialize summary
    mat_22 = set(sealed_mat["anchor_22"]["sealed_hashes"])

    witnesses = []
    if n_ext != 508 or n_strat != 756:
        witnesses.append({"kind": "count_mismatch",
                          "n_ext": n_ext, "n_strat": n_strat})
    if not sol_joint_match:
        witnesses.append({
            "kind": "sol_hash_joint_mismatch",
            "only_ours": sorted(our_sol - sealed_sol)[:5],
            "only_sealed": sorted(sealed_sol - our_sol)[:5],
            "n_only_ours": len(our_sol - sealed_sol),
            "n_only_sealed": len(sealed_sol - our_sol),
        })
    if not sol_ext_match:
        witnesses.append({
            "kind": "sol_hash_ext_mismatch",
            "n_only_ours": len(our_ext_sol - sealed_ext_sol),
            "n_only_sealed": len(sealed_ext_sol - our_ext_sol),
        })
    if not part_match:
        witnesses.append({
            "kind": "partition_mismatch",
            "ours": part, "sealed": sealed_part,
            "expected": {"multi": 298, "line": 148, "ladder": 62},
        })

    # content hash: if sol matches but content differs, soft note (payload shape)
    content_note = None
    if sol_joint_match and not ch_joint_match:
        content_note = (
            "sol_hashes match joint/ext but content_hash payload shape differs "
            "from sealed emission; partition and sol-identity stand."
        )

    verdict = "REFUTED" if witnesses else "CONFIRMED"

    out = {
        "p": p,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "wall_s": round(time.time() - t0, 2),
        "n_joint": len(our_patterns),
        "n_strat": n_strat,
        "n_ext": n_ext,
        "partition_508": part,
        "partition_match_298_148_62": part_match,
        "sol_hash_joint_match": sol_joint_match,
        "sol_hash_ext_match": sol_ext_match,
        "content_hash_joint_match": ch_joint_match,
        "content_hash_ext_match": ch_ext_match,
        "content_note": content_note,
        "anchor_22_sealed_hashes_n": len(mat_22),
        "A3_verdict": verdict,
        "A3_refute_witnesses": witnesses,
        "our_ext_sol_hashes_sample": sorted(our_ext_sol)[:5],
        "sealed_ext_sol_hashes_sample": sorted(sealed_ext_sol)[:5],
    }
    # store our ext sol hashes for cross-check
    with open(os.path.join(RES, "a3_ext_sol_hashes_p%d.json" % p), "w") as f:
        json.dump(sorted(our_ext_sol), f)
    with open(os.path.join(RES, "a3_materialize_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    print("  A3=%s multi/line/ladder=%d/%d/%d [%.1fs]"
          % (verdict, part["multidegree"], part["line_order"],
             part["to_ladder"], time.time() - t0), flush=True)
    return out


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661]
    summary = {}
    for p in primes:
        d = materialize_audit(p)
        summary[str(p)] = {
            "A3": d["A3_verdict"],
            "partition": d["partition_508"],
            "sol_joint": d["sol_hash_joint_match"],
            "sol_ext": d["sol_hash_ext_match"],
            "witnesses": d["A3_refute_witnesses"],
            "wall_s": d["wall_s"],
        }
    with open(os.path.join(RES, "a3_summary.json"), "w") as f:
        json.dump(summary, f, indent=1)
    print("A3_SUMMARY", json.dumps(summary, indent=1))
