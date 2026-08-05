#!/usr/bin/env python3
"""FIX-H1 TASK 6: enumerate the leaves of the exact branch-and-reduce for every
(lam, stratum), print their size, and triage them modulo a split prime
(FINDING only -- the verdict comes from the char-0 engines in holes_leaf).
"""
import sys, time, pickle, os
import holes_lib as H, holes_reduce as RD, holes_solve as SV, holes_strata as ST
import n2b_lib as L, n2c_systems as S

P, OMP, KPP = 100057, 1140, 74361


def modp_gens(names, polys, p=P, omp=OMP, kpp=KPP):
    out = []
    for q in polys:
        t = [(k, L.kmod_p(v, p, omp, kpp)) for k, v in q.items()]
        t = [(k, c) for k, c in t if c]
        if t:
            out.append(t)
    return out


def msolve_leaf(tag, names, polys, p=P):
    src = S.emit_ff(names, polys, p, OMP, KPP)
    rc, dt, txt = H.run_msolve(tag, src, flags=['-g', '1'], nthreads='2')
    return rc, dt, txt


def main():
    r = int(sys.argv[1])
    lams = sys.argv[2].split(',') if len(sys.argv) > 2 else ['one','om','om2']
    allleaves = {}
    for lam in lams:
        for which in ('A','B','C','D'):
            t0 = time.time()
            names, polys, _ = ST.stratum(r, lam, which, maxdeg=4, verbose=False)
            if len(polys) == 1 and sum(next(iter(polys[0]))) == 0:
                print('r=%d lam=%-4s %s : IMMEDIATELY EMPTY' % (r,lam,which), flush=True)
                allleaves[(lam,which)] = []
                continue
            leaves = SV.solve(names, polys, maxdeg=6, verbose=False)
            print('r=%d lam=%-4s %s : %d leaves  (%.1f s)'
                  % (r, lam, which, len(leaves), time.time()-t0), flush=True)
            keep = []
            for li, (nm, pl, path) in enumerate(leaves):
                tag = 'lf_r%d_%s_%s_%d' % (r, lam, which, li)
                if not pl:
                    print('   %s : NO EQUATIONS, %d vars -> POPULATED' % (tag, len(nm)), flush=True)
                    keep.append((nm, pl, path, 'NOEQ'))
                    continue
                rc, dt, txt = msolve_leaf(tag, nm, pl)
                v = 'ERR' if txt.startswith('<') else ('UNIT' if H.is_unit_ideal(txt) else 'NONUNIT')
                print('   %s vars=%d gens=%d degs=%s  msolve[F_%d]=%s (%.1fs)'
                      % (tag, len(nm), len(pl), sorted({sum(k) for q in pl for k in q}), P, v, dt), flush=True)
                keep.append((nm, pl, path, v))
            allleaves[(lam,which)] = keep
    with open(os.path.join(H.HERE, 'leaves_r%d.pkl' % r), 'wb') as f:
        pickle.dump(allleaves, f)
    print('saved leaves_r%d.pkl' % r, flush=True)


if __name__ == '__main__':
    main()
