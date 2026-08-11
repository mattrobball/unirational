"""STAGE1_COMPLEX_MAPS -- producer.

Runs the whole Stage-1 classification at a split prime and writes
  results/layer1_<p>.json      the machine-readable classification
  results/section_moduli_<p>.txt  the section-moduli table
  results/witness_<p>.txt      the explicit witness section, row by row
"""
import json
import os
import sys
from collections import Counter, defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from s1enum import Stage1                       # noqa: E402
from s1label import row_label                   # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(HERE, "results")


def prod(it):
    r = 1
    for x in it:
        r *= x
    return r


def chain_invols(E, r):
    """(kind, involution) for every boundary datum in the row's chain."""
    S, T, m = E.S, E.T, E.m
    C, L, H = S.comps[r["rep"]]
    out = []
    for U in C:
        if len(U) == 3:
            sig = [g for g in m.G if m.order[g] == 2 and m.eigsp(g, 1) == U][0]
            out.append(("P_sigma", sig))
        elif len(U) == 2:
            pw = [g for g in m.G if g != m.Id and S.scalar_on(g, (), U)
                  and m.canon([list(m.act(g, v)) for v in U]) == U]
            if len(pw) == 1:
                out.append(("Lminus_sigma", pw[0]))
        elif len(U) == 1:
            st = [g for g in m.G if m.canon([list(m.act(g, v)) for v in U]) == U]
            if len(st) == 4 and m.F(U[0]) % E.p == 0:
                out.append(("typeI_vertex", T.typeI_of[U][1]))
    return out


def cellname(v):
    k, c, l = v
    if k == "dom":
        return "X" if c == "X" else "L(onto)"
    if k == "gen":
        return "gen.%s" % c
    return c


def solve_block(E, ids):
    ids = sorted(ids)
    idset = set(ids)
    local = [(a, ta, b, tb) for (a, ta, b, tb) in E.cons if a in idset and b in idset]
    sols = []
    assign = {}

    def rec(k):
        if k == len(ids):
            sols.append(dict(assign))
            return
        i = ids[k]
        for v in E.dom[i]:
            assign[i] = v
            if all(E.img_contains(assign[a], ta, assign[b], tb)
                   for (a, ta, b, tb) in local if a in assign and b in assign):
                rec(k + 1)
        assign.pop(i, None)

    rec(0)
    return sols, local


def witness(E, prefer):
    """a global section: greedy over the value order given by `prefer`."""
    ids = [r["id"] for r in E.rows]
    order = sorted(ids, key=lambda i: len(E.dom[i]))
    assign = {}

    def ok(i, v):
        assign[i] = v
        good = all(E.img_contains(assign[a], ta, assign[b], tb)
                   for (a, ta, b, tb) in E.cons if a in assign and b in assign)
        if not good:
            assign.pop(i)
        return good

    def rec(k):
        if k == len(order):
            return True
        i = order[k]
        for v in sorted(E.dom[i], key=lambda v: prefer(v)):
            if ok(i, v):
                if rec(k + 1):
                    return True
                assign.pop(i, None)
        return False

    assert rec(0), "no global section"
    return assign


def run(p, verbose=True):
    E = Stage1(p, verbose=verbose)
    S, T, m = E.S, E.T, E.m
    out = {"p": p,
           "arrangement": {str(d): len(v) for d, v in sorted(S.byd.items())},
           "source_rows": len(E.rows),
           "source_components": len(S.comps),
           "orbit_relations": len(E.orbit_relations),
           "target_cells": {c: len(v) for c, v in T.comp.items()}}

    rows = []
    for r in E.rows:
        vals = E.dom[r["id"]]
        rows.append(dict(id=r["id"], K=r["K"], dim=r["dim"], n=r["n_orbit"],
                         setwise=r["setwise"], chain=row_label(E, r),
                         nvals=len(vals), cells=dict(Counter(cellname(v) for v in vals))))
    out["rows"] = rows

    # ---- forced features -------------------------------------------------
    v4 = [r["id"] for r in E.rows if r["K"] == "V4"]
    out["V4_rows"] = len(v4)
    out["V4_rows_with_typeII_option"] = [i for i in v4
                                         if any(v[1] == "PII" for v in E.dom[i])]
    out["V4_rows_all_typeI"] = all(all(v[1] == "PI" for v in E.dom[i]) for i in v4)
    # the killed vertex is exactly v_sigma for every boundary sigma of the chain
    killrule = True
    for i in v4:
        r = E.byoid[[q["oid"] for q in E.rows if q["id"] == i][0]]
        keep = set(T.typeI_of[l][1] for _k, _c, l in E.dom[i])
        for kind, sig in chain_invols(E, r):
            if kind in ("P_sigma", "Lminus_sigma") and sig in keep:
                killrule = False
    out["V4_kill_rule_v_sigma"] = killrule

    forced = [r["id"] for r in E.rows if len(E.dom[r["id"]]) == 1]
    out["forced_rows"] = forced
    out["rows_forced_to_sweep"] = [i for i in forced
                                   if E.dom[i][0][0] == "dom" and E.dom[i][0][1] == "L"]
    out["rows_that_may_sweep"] = [r["id"] for r in E.rows
                                  if any(v[0] == "dom" and v[1] == "L" for v in E.dom[r["id"]])]
    out["rows_with_E_cell_option"] = [r["id"] for r in E.rows
                                      if any(v[0] == "gen" and v[1] == "E"
                                             for v in E.dom[r["id"]])]
    out["rows_that_can_dominate_E"] = []      # rationality: never
    out["positive_dimensional_images"] = ["X (free stratum)", "L_sigma (55 lines)"]

    # ---- exact counts ----------------------------------------------------
    blocks = E.blocks()
    binfo, total = [], 1
    for b in sorted(blocks, key=lambda x: (len(x), sorted(x))):
        sols, local = solve_block(E, b)
        binfo.append(dict(rows=sorted(b), size=len(b), constraints=len(local),
                          solutions=len(sols),
                          free_product=prod(len(E.dom[i]) for i in b)))
        total *= len(sols)
    inblock = set(i for b in blocks for i in b)
    for r in E.rows:
        i = r["id"]
        if len(E.dom[i]) > 1 and i not in inblock:
            binfo.append(dict(rows=[i], size=1, constraints=0,
                              solutions=len(E.dom[i]), free_product=len(E.dom[i])))
            total *= len(E.dom[i])
    out["blocks"] = binfo
    out["total_stage1_classes"] = total
    # row 16 carries the only continuous parameters
    r16 = [r["id"] for r in E.rows if r["setwise"] == "C2"]
    out["rows_with_continuous_modulus"] = r16
    n16 = len(E.dom[r16[0]]) if r16 else 0
    ngen = sum(1 for v in E.dom[r16[0]] if v[0] == "gen") if r16 else 0
    out["discrete_classes"] = total // n16 * (n16 - ngen) if r16 else total
    out["one_parameter_families"] = total // n16 * ngen if r16 else 0

    # ---- witness sections -------------------------------------------------
    pref_sweep = lambda v: (0 if v[0] == "dom" else 1, str(v[1]))
    W = witness(E, pref_sweep)
    bad = [(a, b) for (a, ta, b, tb) in E.cons
           if not E.img_contains(W[a], ta, W[b], tb)]
    out["witness_maximal_sweep"] = {
        "violations": len(bad),
        "sweeping_rows": sorted(i for i in W if W[i][0] == "dom" and W[i][1] == "L"),
        "cells": dict(Counter(cellname(W[i]) for i in W)),
        "lands_on_E_cell": any(W[i][0] == "gen" and W[i][1] == "E" for i in W),
        "lands_on_typeII": any(W[i][1] == "PII" for i in W)}
    out["witness_rows"] = {str(i): cellname(W[i]) for i in sorted(W)}

    pref_pt = lambda v: (0 if v[0] == "pt" else 1, str(v[1]))
    W2 = witness(E, pref_pt)
    bad2 = [(a, b) for (a, ta, b, tb) in E.cons
            if not E.img_contains(W2[a], ta, W2[b], tb)]
    out["witness_minimal_sweep"] = {
        "violations": len(bad2),
        "sweeping_rows": sorted(i for i in W2 if W2[i][0] == "dom" and W2[i][1] == "L"),
        "lands_on_E_cell": any(W2[i][0] == "gen" and W2[i][1] == "E" for i in W2),
        "lands_on_typeII": any(W2[i][1] == "PII" for i in W2)}
    return E, out, W


def main(ps):
    os.makedirs(RES, exist_ok=True)
    allout = {}
    for p in ps:
        E, o, W = run(p)
        allout[str(p)] = o
        with open(os.path.join(RES, "layer1_%d.json" % p), "w") as f:
            json.dump(o, f, indent=1)
        with open(os.path.join(RES, "section_moduli_%d.txt" % p), "w") as f:
            f.write("STAGE-1 SECTION-MODULI TABLE  (p = %d)\n" % p)
            f.write("source: terminus Z, %d rows / %d components; %d closure relations\n\n"
                    % (o["source_rows"], o["source_components"], o["orbit_relations"]))
            f.write("%-4s %-4s %-3s %-6s %-10s %-26s %-5s %s\n" %
                    ("id", "H", "dim", "#comp", "Stab_G(F)", "chain", "#val", "target cells"))
            for r in o["rows"]:
                f.write("#%02d  %-4s d%d  %-6d %-10s %-26s %-5d %s\n" %
                        (r["id"], r["K"], r["dim"], r["n"], r["setwise"], r["chain"],
                         r["nvals"], r["cells"]))
            f.write("\nblocks of the constraint graph:\n")
            for b in o["blocks"]:
                f.write("  rows %-40s  %d constraints  ->  %d joint values (free %d)\n"
                        % (b["rows"], b["constraints"], b["solutions"], b["free_product"]))
            f.write("\ntotal Stage-1 classes: %d\n" % o["total_stage1_classes"])
        with open(os.path.join(RES, "witness_%d.txt" % p), "w") as f:
            f.write("WITNESS SECTION (maximal-sweep), p = %d\n\n" % p)
            for r in o["rows"]:
                f.write("#%02d  %-4s d%d  %-6d %-10s %-26s ->  %s\n" %
                        (r["id"], r["K"], r["dim"], r["n"], r["setwise"], r["chain"],
                         o["witness_rows"][str(r["id"])]))
            f.write("\nviolated closure constraints: %d\n"
                    % o["witness_maximal_sweep"]["violations"])
        print(json.dumps({k: v for k, v in o.items()
                          if k not in ("rows", "blocks", "witness_rows")}, indent=1))
    return allout


if __name__ == "__main__":
    main([int(x) for x in sys.argv[1:]] or [331, 661])
