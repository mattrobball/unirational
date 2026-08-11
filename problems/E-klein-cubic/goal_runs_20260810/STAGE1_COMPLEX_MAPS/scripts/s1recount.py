"""STAGE1_COMPLEX_MAPS -- the coherent recount (audit repair).

Layer 1 as first published imposed value-SET consistency (arc consistency).  A
single morphism forces more: if row S sweeps its line via a Layer-2 morphism phi
lying in a connected component of M_S, then the value of every deeper row R in
cl(S) at which phi is defined is the EVALUATION phi|_R, not a free choice.
`s1coherence` shows those evaluations are constant on each component (rigidity)
and computes them; this module transports them into each child row's own frame,
drops the components that are not restrictions of any global section, and
recounts.

Vocabulary used below and in THEOREM.md section 15:
  * Comp(S)   -- the components of M_S, each carrying a partial assignment
                 {child row -> value}; a child omitted from the assignment is one
                 along which that component's germ is identically zero
                 ("degenerate"), so the complex-level value there is pinned only
                 by arc consistency.
  * usable    -- a component whose evaluations all land in the arc-consistent
                 domains.  A non-usable component is a legal equivariant sweep of
                 L_sigma that cannot be the restriction of any global section.
"""
import itertools
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from s1coherence import SweepRow      # noqa: E402


def sweep_rows(E):
    return [r["id"] for r in E.rows
            if any(v[0] == "dom" and v[1] == "L" for v in E.dom[r["id"]])]


def forced_sweeps(E):
    return [r["id"] for r in E.rows
            if len(E.dom[r["id"]]) == 1 and E.dom[r["id"]][0][0] == "dom"
            and E.dom[r["id"]][0][1] == "L"]


def build_tables(E, maxdeg=None, verbose=False):
    md = maxdeg or {}
    tables, meta = {}, {}
    for rid in sweep_rows(E):
        S = SweepRow(E, rid)
        d = md.get(rid, 4 if S.nslot > 1 else 6)
        cl = S.classes(d)
        byidx = {k["idx"]: k for k in S.kids}
        out, drop_inc, drop_dom = [], 0, 0
        for key, vals in cl.items():
            assign, bad = {}, False
            for idx, v in vals.items():
                if v == "DEGENERATE":
                    continue
                if v in ("NONRIGID", "NONCONST"):
                    bad = True
                    break
                kid = byidx[idx]
                cell, lab = v
                if cell == "gen":
                    bad = True
                    break
                own = E.T.act(E.m.matinv(kid["tr"]), cell, lab)
                r0 = kid["row"]
                if r0 in assign and assign[r0] != ("pt", cell, own):
                    bad = True
                    break
                assign[r0] = ("pt", cell, own)
            if bad:
                drop_inc += 1
                continue
            if any(v not in E.dom[r0] for r0, v in assign.items()):
                drop_dom += 1
                continue
            out.append((key, assign))
        pats = sorted(set(tuple(sorted(a.items())) for _k, a in out))
        tables[rid] = [dict(p) for p in pats]
        meta[rid] = dict(rows=sorted(set(k["row"] for k in S.kids)),
                         nkids=len(S.kids), ncomp=len(cl), maxdeg=d,
                         nslot=S.nslot, gamma=len(S.Gam),
                         rigid_fail=len(S.rigid_fail), usable=len(out),
                         dropped_noncoherent=drop_dom + drop_inc,
                         patterns=len(pats))
        if verbose:
            print("  Comp(#%02d): %d components, %d usable, %d distinct child "
                  "patterns over rows %s" % (rid, len(cl), len(out), len(pats),
                                             meta[rid]["rows"]), flush=True)
    return tables, meta


# ---------------------------------------------------------------- the count
def coherent_count(E, tables, verbose=False):
    """exact number of coherent order-0 boundary patterns, as a product over the
    connected components of the AUGMENTED constraint graph."""
    multi = [r["id"] for r in E.rows if len(E.dom[r["id"]]) > 1]
    mset = set(multi)
    par = {i: i for i in multi}

    def find(x):
        while par[x] != x:
            par[x] = par[par[x]]
            x = par[x]
        return x

    def uni(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            par[ra] = rb

    for (a, ta, b, tb) in E.cons:
        if a in mset and b in mset:
            uni(a, b)
    for rid, tab in tables.items():
        rs = set()
        for a in tab:
            rs |= set(a)
        rs = sorted((rs | {rid}) & mset)
        for r0 in rs[1:]:
            uni(rs[0], r0)
    groups = defaultdict(list)
    for i in multi:
        groups[find(i)].append(i)

    total = 1
    blocks = []
    for g in sorted(groups.values(), key=lambda x: (len(x), x)):
        n = count_block(E, tables, g)
        blocks.append(dict(rows=sorted(g), size=len(g), solutions=n))
        total *= n
        if verbose:
            print("  block %s -> %d coherent patterns" % (sorted(g), n), flush=True)
    return total, blocks


def count_block(E, tables, ids):
    ids = sorted(ids)
    idset = set(ids)
    cons = [(a, ta, b, tb) for (a, ta, b, tb) in E.cons if a in idset and b in idset]
    # sweeping rows relevant to this block: those whose table touches it
    rel = []
    for rid, tab in tables.items():
        rs = set()
        for a in tab:
            rs |= set(a)
        if (rs | {rid}) & idset:
            rel.append(rid)
    # a sweeping row outside the block whose children lie inside still constrains
    forced = set(forced_sweeps(E))
    order = sorted(ids, key=lambda i: (0 if i in tables else 1, -len(
        set().union(*[set(a) for a in tables[i]]) if tables.get(i) else set()),
        len(E.dom[i]), i))
    val = {}
    sols = 0

    def sweeping(s):
        if s in forced:
            return True
        if s not in val:
            return None
        v = val[s]
        return v[0] == "dom" and v[1] == "L"

    def tables_ok(justset):
        for s in rel:
            st = sweeping(s)
            if st is False:
                continue
            if st is None:
                continue                       # s not yet decided: no pruning
            hit = False
            for a in tables[s]:
                if all(val.get(r0) in (None, v) for r0, v in a.items()):
                    hit = True
                    break
            if not hit:
                return False
        return True

    def rec(k):
        nonlocal sols
        if k == len(order):
            if tables_ok(None):
                sols += 1
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
            if good and tables_ok(i):
                rec(k + 1)
            val.pop(i, None)

    rec(0)
    return sols
