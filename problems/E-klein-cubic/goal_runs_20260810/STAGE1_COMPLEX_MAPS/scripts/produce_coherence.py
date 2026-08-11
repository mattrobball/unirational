"""STAGE1_COMPLEX_MAPS -- producer for the evaluation-coherence layer.

Writes
  results/coherence_<p>.json   the tables, the per-chain surjectivity verdicts,
                               the coherent block structure and the new count
  results/coherence_<p>.txt    the same, human-readable
"""
import itertools
import json
import os
import sys
import time

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from s1enum import Stage1                                    # noqa: E402
from s1label import row_label                                # noqa: E402
from s1recount import build_tables, coherent_count, sweep_rows   # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(HERE, "results")


def verdicts(E, tables):
    out = {}
    for rid in sweep_rows(E):
        tab = tables[rid]
        rows = sorted(set().union(*[set(a) for a in tab]) if tab else set())
        multi = [r for r in rows if len(E.dom[r]) > 1]
        img = set()
        for a in tab:
            ch = [[a[r]] if r in a else list(E.dom[r]) for r in multi]
            for c in itertools.product(*ch):
                img.add(tuple(c))
        prod = set()
        sweepv = [v for v in E.dom[rid] if v[0] == "dom"][0]
        cons = [(x, ta, y, tb) for (x, ta, y, tb) in E.cons
                if x in multi + [rid] and y in multi + [rid]]
        for c in itertools.product(*[list(E.dom[r]) for r in multi]):
            val = dict(zip(multi, c))
            val[rid] = sweepv
            if all(E.img_contains(val[x], ta, val[y], tb)
                   for (x, ta, y, tb) in cons if x in val and y in val):
                prod.add(c)
        out[rid] = dict(children=rows, multi=multi, n_image=len(img),
                        n_arc_consistent=len(prod), surjective=bool(img >= prod),
                        patterns=len(tab))
    return out


def run(p):
    E = Stage1(p, verbose=False)
    t = time.time()
    tables, meta = build_tables(E)
    vd = verdicts(E, tables)
    total, blocks = coherent_count(E, tables)
    lab = {r["id"]: row_label(E, r) for r in E.rows}
    # rows that lose all freedom under coherence
    core = max(blocks, key=lambda b: b["size"])
    o = dict(p=p, coherent_total=total, seconds=round(time.time() - t),
             blocks=blocks, core_block=core,
             verdicts={str(k): v for k, v in vd.items()},
             meta={str(k): v for k, v in meta.items()},
             labels={str(k): v for k, v in lab.items()},
             rigidity_failures=sum(m["rigid_fail"] for m in meta.values()))
    return E, tables, o


def main(ps):
    os.makedirs(RES, exist_ok=True)
    for p in ps:
        E, tables, o = run(p)
        with open(os.path.join(RES, "coherence_%d.json" % p), "w") as f:
            json.dump(o, f, indent=1)
        with open(os.path.join(RES, "coherence_%d.txt" % p), "w") as f:
            f.write("EVALUATION COHERENCE (p = %d)\n\n" % p)
            f.write("rigidity failures over all sweep rows, all components, all "
                    "children: %d\n\n" % o["rigidity_failures"])
            f.write("%-5s %-24s %-6s %-7s %-9s %-9s %s\n" %
                    ("row", "chain", "|Comp|", "usable", "|image|", "|arc|",
                     "surjective"))
            for k in sorted(o["verdicts"], key=int):
                v = o["verdicts"][k]
                m = o["meta"][k]
                f.write("#%-4s %-24s %-6d %-7d %-9d %-9d %s\n" %
                        (k, o["labels"][k], m["ncomp"], m["usable"], v["n_image"],
                         v["n_arc_consistent"], v["surjective"]))
            f.write("\ncoherent blocks:\n")
            for b in o["blocks"]:
                f.write("  %-3d rows -> %d patterns   %s\n"
                        % (b["size"], b["solutions"],
                           b["rows"] if b["size"] < 6 else "(the coupled core)"))
            f.write("\ncoherent total = %d\n" % o["coherent_total"])
        print(json.dumps({k: v for k, v in o.items()
                          if k in ("p", "coherent_total", "rigidity_failures",
                                   "seconds")}, indent=1))


if __name__ == "__main__":
    main([int(x) for x in sys.argv[1:]] or [331, 661])
