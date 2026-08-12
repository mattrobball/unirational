"""Depth-menu filter + level-2 extension on stratified full-flag contributions.

Discipline (ODDZERO + DEPTH_TABLE_GENERAL):
  * Start from STAGE1_STRATIFIED contribution_stratified (levels 0 and 1).
  * Depth table assertable_levels = which κ produce arc-consistent labels.
  * Domain checks in stratified already enforce assertability for the levels
    it tries.  Depth menus therefore cannot drop a stratified pattern whose
    values sit on assertable cycle entries — they can only ADD patterns from
    levels stratified never tried (period-3 κ=2).
  * No module-level degeneracy shortcuts.
"""
import itertools
import json
import os
from collections import defaultdict

import paths  # noqa: F401
from s3jet import (  # noqa: E402
    module_basis, chi_arc_of, value_at_level, contribution_stratified,
    vanishing_forms, kernel_of_forms, subspace_vanishes_at,
)
from s1coherence import rank2  # noqa: E402


def load_depth_table(p):
    path = os.path.join(paths.DEPTH_RES, "depth_table_p%d.json" % p)
    with open(path) as f:
        return json.load(f)


def class_key_rid1(a):
    return (sum(a) % 6, a[1] % 6)


def class_key_rid2(a):
    return (sum(a) % 6, a[1] % 6)


def _menu_and_cycles(depth_row, dmod, smod):
    """kid_idx -> {assertable_levels, cycle_labels_by_level}."""
    ck = "%d_%d" % (dmod, smod)
    cls = depth_row["classes"][ck]
    out = {}
    for e in cls["kids"]:
        # cycle entries are JSON labels; rebuild comparable tuples via json
        cycle = e["cycle"]  # list of json-ish labels or None
        out[int(e["kid_idx"])] = dict(
            period=int(e["period"]),
            assertable=list(e["assertable_levels"]),
            cycle=cycle,
            row=int(e["row"]),
        )
    return out


def _lab_json(lab):
    if lab is None:
        return None
    return json.loads(json.dumps(lab))


def pattern_ok_for_menu(asn, S, menu, a, psi=None):
    """True if every pinned value equals the depth-cycle entry at some assertable κ."""
    # map row -> list of kids on that row
    by_row = defaultdict(list)
    for kid in S.kids:
        by_row[kid["row"]].append(kid)
    for r0, v in asn.items():
        kids = by_row.get(r0, [])
        if not kids:
            continue
        ok_one = False
        for kid in kids:
            info = menu.get(int(kid["idx"]))
            if info is None:
                ok_one = True
                break
            vj = _lab_json(v)
            for k in info["assertable"]:
                # compare to stored cycle or recompute
                cyc = info["cycle"]
                if k < len(cyc) and cyc[k] is not None:
                    if cyc[k] == vj:
                        ok_one = True
                        break
                else:
                    chi, _ = chi_arc_of(S, kid)
                    U = value_at_level(S, a, kid, k, psi, chi)
                    if U is None:
                        continue
                    lab = S.own_frame(kid, U)
                    if lab is not None and _lab_json(lab) == vj:
                        ok_one = True
                        break
            if ok_one:
                break
        if not ok_one:
            return False
    return True


def level2_escape_patterns(S, a, E, menu, psi=None):
    """Extra assignments using period-3 assertable levels that include κ=2.

    Mirrors contribution_stratified's flip logic but allows high-level κ=2
    when the depth menu lists it.
    """
    p = S.p
    mon_basis, V = module_basis(S, a, psi)
    nV = len(V)
    if nV == 0:
        return []

    meta = []
    needs_l2 = []
    for j, kid in enumerate(S.kids):
        chi, per = chi_arc_of(S, kid)
        forms = vanishing_forms(S, mon_basis, V, kid)
        info = menu.get(int(kid["idx"]), dict(assertable=[0], period=per))
        meta.append(dict(
            kid=kid, row=kid["row"], chi_arc=chi, period=per,
            forms=forms, whole_vanishes=(len(forms) == 0),
            assertable=info.get("assertable", [0]),
        ))
        if per >= 3 and 2 in info.get("assertable", []):
            needs_l2.append(j)

    if not needs_l2:
        return []

    flip_idx = [j for j, md in enumerate(meta) if md["period"] > 1]
    always_hi = [j for j, md in enumerate(meta) if md["whole_vanishes"]]
    nf = len(flip_idx)
    masks = range(1 << nf) if nf <= 8 else [0, (1 << nf) - 1]

    results = set()
    for mask in masks:
        Z = [flip_idx[b] for b in range(nf) if mask & (1 << b)]
        # require at least one needs_l2 kid to be high
        if not any(j in Z or j in always_hi for j in needs_l2):
            # force each needs_l2 kid high one at a time
            extra_sets = [Z + [j] for j in needs_l2 if j not in Z]
        else:
            extra_sets = [Z]
        for Z2 in extra_sets:
            forms = []
            for j in Z2:
                forms.extend(meta[j]["forms"])
            bas = kernel_of_forms(forms, nV, p)
            if not bas:
                continue
            high = set(Z2) | set(always_hi)
            for j, md in enumerate(meta):
                if j in high:
                    continue
                if subspace_vanishes_at(bas, md["forms"], nV, p):
                    if md["period"] > 1 or md["whole_vanishes"]:
                        high.add(j)
            # build assignment: level 0 on non-high; menu level on high
            assign = {}
            bad = False
            # non-high
            for j, md in enumerate(meta):
                if j in high:
                    continue
                kid = md["kid"]
                q = [kid["qs"][i][0] for i in range(S.nslot)]
                evs = []
                for row in bas:
                    w = [0, 0]
                    for b, cb in enumerate(row):
                        if cb % p == 0:
                            continue
                        wb = S._eval(mon_basis, V[b], q)
                        w[0] = (w[0] + cb * wb[0]) % p
                        w[1] = (w[1] + cb * wb[1]) % p
                    evs.append(w)
                rk = rank2(p, evs)
                if rk == 0:
                    high.add(j)
                    continue
                if rk != 1:
                    bad = True
                    break
                w0 = next(v for v in evs if any(x % p for x in v))
                U = S.m.canon([list(tuple(
                    sum(w0[i] * S.Wm[i][c] for i in range(2)) % p
                    for c in range(5)))])
                v = S.own_frame(kid, U)
                if v is None:
                    bad = True
                    break
                r0 = kid["row"]
                if r0 in assign and assign[r0] != v:
                    bad = True
                    break
                assign[r0] = v
            if bad:
                continue
            # high kids: prefer κ=2 if assertable, else κ=1
            for j in high:
                md = meta[j]
                kid = md["kid"]
                levels = [k for k in md["assertable"] if k >= 1] or md["assertable"]
                pinned = False
                for lev in sorted(levels, reverse=True):  # try 2 before 1
                    U = value_at_level(S, a, kid, lev, psi, md["chi_arc"])
                    if U is None:
                        continue
                    v = S.own_frame(kid, U)
                    if v is None:
                        continue
                    r0 = kid["row"]
                    if r0 in assign and assign[r0] != v:
                        continue
                    assign[r0] = v
                    pinned = True
                    break
            if any(v not in E.dom[r0] for r0, v in assign.items()):
                continue
            results.add(tuple(sorted(assign.items())))
    return [dict(t) for t in results]


def contribution_depth_menu(S, a, E, depth_row, rid_kind, psi=None):
    """Stratified patterns that pass the depth menu, plus level-2 escapes."""
    if rid_kind == 1:
        dmod, smod = class_key_rid1(a)
    else:
        dmod, smod = class_key_rid2(a)
    menu = _menu_and_cycles(depth_row, dmod, smod)

    out = []
    seen = set()
    for asn in contribution_stratified(S, a, E, psi=psi):
        if not pattern_ok_for_menu(asn, S, menu, a, psi):
            continue
        k = tuple(sorted(asn.items()))
        if k not in seen:
            seen.add(k)
            out.append(asn)

    for asn in level2_escape_patterns(S, a, E, menu, psi=psi):
        if not pattern_ok_for_menu(asn, S, menu, a, psi):
            continue
        k = tuple(sorted(asn.items()))
        if k not in seen:
            seen.add(k)
            out.append(asn)
    return out
