#!/usr/bin/env python3
"""Deliverable 1 — the general depth-value table.

For both full-flag rows (rid 1 = plus-row D_{P_σ}, rid 2 = line-row D_{L⁻_σ})
and every child, tabulate as a function of the multidegree class mod 6:

  * arc character period;
  * value CYCLE by depth level κ = 0, …, period−1 (own_frame labels);
  * which cycle entries are arc-consistent (in the child row's domain).

Sources: STAGE1_STRATIFIED s3jet.chi_arc_of / value_at_level, STAGE1_TIGHTEN
FullSweep, D35_AUDIT T4 period data as anchor.

Verification: both primes 331 and 661; two distinct degree-class residues
(representative of d ≡ 35 (mod 6) and d ≡ 34 (mod 6)).

Usage: python3 build_depth_table.py [p ...]
"""
import json
import os
import sys
from collections import Counter

import paths
from s1enum import Stage1
from s3sweep import FullSweep
from s3jet import chi_arc_of, value_at_level

RES = paths.RES
os.makedirs(RES, exist_ok=True)

# Representative absolute multidegrees for each mod-6 class.
# rid 1: a = (d − m, m); class key (d mod 6, m mod 6).
# rid 2: a = (d − ν, ν); class key (d mod 6, ν mod 6).
# Lift into a safe range so character powers are well-defined and typical
# eigenlines exist (a_i around 30).


def representatives_rid1():
    """Map (d_mod6, m_mod6) -> concrete a = (d-m, m)."""
    out = {}
    for dmod in range(6):
        for mmod in range(6):
            # pick d ≡ dmod (mod 6), d >= 30; m ≡ mmod, 0 <= m <= d
            d = 30 + dmod
            m = mmod
            if m > d:
                m = mmod + 6
            a = (d - m, m)
            out[(dmod, mmod)] = a
    return out


def representatives_rid2():
    out = {}
    for dmod in range(6):
        for numod in range(6):
            d = 30 + dmod
            nu = numod
            if nu > d:
                nu = numod + 6
            a = (d - nu, nu)
            out[(dmod, numod)] = a
    return out


def lab_json(lab):
    if lab is None:
        return None
    # ("pt", cell, ((coords),)) — make JSON-safe
    return json.loads(json.dumps(lab))


def label_at(S, a, kid, kappa, chi_arc):
    U = value_at_level(S, a, kid, kappa, None, chi_arc)
    if U is None:
        return None
    return S.own_frame(kid, U)


def chi_arc_json(chi, m):
    # chi maps group elements (matrices or ids) -> F_p; stringify keys
    out = {}
    for h, v in chi.items():
        if hasattr(h, "__iter__") and not isinstance(h, (str, bytes)):
            # matrix-like: use a short stable repr
            key = "g:" + repr(h)[:80]
        else:
            key = str(h)
        out[key] = int(v) % m.p
    return out


def build_for_row(E, rid, class_reps, verify_classes):
    S = FullSweep(E, rid)
    p = E.m.p
    # period is class-independent (depends only on the child / Lam)
    kid_meta = []
    period_hist = Counter()
    for kid in S.kids:
        chi, per = chi_arc_of(S, kid)
        period_hist[per] += 1
        kid_meta.append({
            "kid_idx": int(kid["idx"]),
            "row": int(kid["row"]),
            "period": int(per),
            "chi_arc": chi_arc_json(chi, E.m),
            "_chi": chi,  # not serialised
            "_kid": kid,
        })

    # per-class cycles
    classes = {}
    for ckey, a in class_reps.items():
        dmod, smod = ckey
        entries = []
        for md in kid_meta:
            kid = md["_kid"]
            chi = md["_chi"]
            per = md["period"]
            cycle = []
            consistent = []
            for kappa in range(per):
                lab = label_at(S, a, kid, kappa, chi)
                cycle.append(lab_json(lab))
                if lab is None:
                    consistent.append(False)
                else:
                    dom = E.dom.get(kid["row"], set())
                    consistent.append(lab in dom)
            # levels a coherent blueprint may assert: κ with consistent[κ]
            assertable = [k for k, ok in enumerate(consistent) if ok]
            # which labels appear at which residues mod period
            by_lab = {}
            for k, lab in enumerate(cycle):
                if lab is None:
                    continue
                key = json.dumps(lab, sort_keys=True)
                by_lab.setdefault(key, []).append(k)
            entries.append({
                "kid_idx": md["kid_idx"],
                "row": md["row"],
                "period": per,
                "cycle": cycle,
                "arc_consistent": consistent,
                "assertable_levels": assertable,
                "levels_by_label": {k: v for k, v in by_lab.items()},
            })
        classes["%d_%d" % (dmod, smod)] = {
            "d_mod6": dmod,
            "slot1_mod6": smod,
            "representative_a": list(a),
            "kids": entries,
        }

    # verification at two degree classes (explicit character-rule evaluation)
    verify = []
    for ckey in verify_classes:
        a = class_reps[ckey]
        # also a second lift in the same class (a_i += 6) — cycles must match
        a2 = (a[0] + 6, a[1] + 6) if rid == 1 else (a[0] + 6, a[1] + 6)
        n_match = 0
        n_cmp = 0
        n_domain_ok = 0
        n_domain = 0
        varies = 0
        for md in kid_meta:
            kid = md["_kid"]
            chi = md["_chi"]
            per = md["period"]
            cyc1 = [label_at(S, a, kid, k, chi) for k in range(per)]
            cyc2 = [label_at(S, a2, kid, k, chi) for k in range(per)]
            if any(x is not None for x in cyc1):
                n_cmp += 1
                if cyc1 == cyc2:
                    n_match += 1
                if any(cyc1[0] is not None and cyc1[k] is not None
                       and cyc1[k] != cyc1[0] for k in range(per)):
                    varies += 1
            for lab in cyc1:
                if lab is None:
                    continue
                n_domain += 1
                if lab in E.dom.get(kid["row"], set()):
                    n_domain_ok += 1
        verify.append({
            "class": list(ckey),
            "representative_a": list(a),
            "lift_a": list(a2),
            "n_kids_compared": n_cmp,
            "n_cycle_match_same_class_lift": n_match,
            "n_depth_varies": varies,
            "n_domain_labels": n_domain,
            "n_domain_consistent": n_domain_ok,
            "same_class_lift_ok": (n_match == n_cmp),
        })

    # strip private fields
    kids_public = [{k: v for k, v in md.items() if not k.startswith("_")}
                   for md in kid_meta]

    return {
        "p": p,
        "rid": rid,
        "n_kids": len(S.kids),
        "dims": list(S.dims),
        "period_histogram": {str(k): int(v)
                             for k, v in sorted(period_hist.items())},
        "kids": kids_public,
        "classes": classes,
        "verify": verify,
    }


def run(p):
    print("== general depth-value table  p=%d" % p, flush=True)
    E = Stage1(p)
    # verify classes: residue of 35 (d≡5) and of 34 (d≡4), m/ν = 1
    v1 = [(5, 1), (4, 1)]   # rid1: (d mod 6, m mod 6) — residues of 35, 34
    v2 = [(5, 0), (4, 1)]   # rid2: (d mod 6, ν mod 6) — (35,0) and (34−1,1)=(33,1)
                             # (ν even on even d often has no eigenline; ν≡1 works)

    r1 = build_for_row(E, 1, representatives_rid1(), v1)
    print("  rid1 period hist", r1["period_histogram"],
          "verify", [v["same_class_lift_ok"] for v in r1["verify"]])
    r2 = build_for_row(E, 2, representatives_rid2(), v2)
    print("  rid2 period hist", r2["period_histogram"],
          "verify", [v["same_class_lift_ok"] for v in r2["verify"]])

    # T4 anchor: rid1 histogram must be 36/6/12
    hist = r1["period_histogram"]
    t4_anchor_ok = (hist.get("1") == 36 and hist.get("2") == 6
                    and hist.get("3") == 12)
    print("  T4 anchor 36/6/12:", t4_anchor_ok)

    # class (5,1) on rid1 is the d=35 working class — also emit a concrete
    # (34,1) evaluation (absolute, not just the mod-6 representative)
    S1 = FullSweep(E, 1)
    a35 = (34, 1)
    concrete_35 = []
    for kid in S1.kids:
        chi, per = chi_arc_of(S1, kid)
        cycle = [lab_json(label_at(S1, a35, kid, k, chi)) for k in range(per)]
        consistent = []
        for lab in cycle:
            if lab is None:
                consistent.append(False)
            else:
                consistent.append(lab in E.dom.get(kid["row"], set()))
        concrete_35.append({
            "kid_idx": int(kid["idx"]),
            "row": int(kid["row"]),
            "period": int(per),
            "cycle": cycle,
            "arc_consistent": consistent,
            "assertable_levels": [k for k, ok in enumerate(consistent) if ok],
        })

    out = {
        "p": p,
        "rid1": r1,
        "rid2": r2,
        "t4_anchor_histogram_ok": bool(t4_anchor_ok),
        "concrete_class_d35_a_34_1": {
            "a": [34, 1],
            "d_mod6": 5,
            "m_mod6": 1,
            "kids": concrete_35,
        },
        "headline": ("Problem E remains OPEN; this packet excludes no degree."),
    }
    path = os.path.join(RES, "depth_table_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1)
    print("  wrote", path)
    return out


if __name__ == "__main__":
    primes = [int(x) for x in sys.argv[1:]] or [331, 661]
    for p in primes:
        run(p)
