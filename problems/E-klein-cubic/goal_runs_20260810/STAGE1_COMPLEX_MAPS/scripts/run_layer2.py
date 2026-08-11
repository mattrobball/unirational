import sys, os, pickle, time, json
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__))))
from s1layer2 import sweep_moduli
from s1label import row_label

CACHE = sys.argv[1]
OUT = sys.argv[2]
E = pickle.load(open(CACHE, 'rb'))
sweeps = [r["id"] for r in E.rows if any(v[0] == "dom" and v[1] == "L" for v in E.dom[r["id"]])]
res = {}
with open(OUT, 'w') as f:
    f.write("LAYER 2 -- moduli of the equivariant dominant maps  F --> L_sigma = P^1\n")
    f.write("p = %d.  dim of the space of equivariant multiforms, per multidegree and\n" % E.p)
    f.write("per linear character psi of Gamma = Stab_G(F); the map is that space\n")
    f.write("projectivized, minus the (proper closed) non-dominant locus.\n\n")
    for rid in sweeps:
        md = 5 if rid in (1, 2, 8) else 4
        t = time.time()
        out, dims, ng = sweep_moduli(E, rid, maxdeg=md)
        r = [q for q in E.rows if q["id"] == rid][0]
        hdr = ("row #%02d  H=%s dim=%d  #comp=%d  Stab=%s  chain=%s\n"
               "        F = %s   |Gamma| = %d   (maxdeg %d, %.0fs)\n"
               % (rid, r["K"], r["dim"], r["n_orbit"], r["setwise"], row_label(E, r),
                  " x ".join("P^%d" % (d - 1) for d in dims), ng, md, time.time() - t))
        f.write(hdr)
        best = {}
        for k in sorted(out):
            f.write("    %-12s  %s\n" % (str(k), {str(a): b for a, b in sorted(out[k].items())}))
            best[str(k)] = max(out[k].values())
        f.write("\n")
        f.flush()
        res[str(rid)] = {"dims": dims, "gamma": ng, "table": best}
        print("done", rid, flush=True)
json.dump(res, open(OUT.replace('.txt', '.json'), 'w'), indent=1)
print("ALL DONE")
