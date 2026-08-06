"""CASE N second engine, done right: Macaulay2 on the REDUCED cube-root leaf
(13 vars) -- the exact shape it decided in 11 s for lam = 1.  The earlier
probe mistakenly used the un-reduced 16-variable branch."""
import h2_cuberoot as CR, h2_engines as E, holes_track as TR
for lam in ('om','om2'):
    for tag, nm, pl in CR.branches(8, lam):
        br = TR.Branch(list(nm), [dict(q) for q in pl], {x: {} for x in nm}, '')
        for li, s in enumerate(TR.solve(br)):
            if not s.polys: continue
            v,dt,i = E.m2v('crr_%s_%s_%d' % (lam, tag, li), s.names, s.polys, timeout=900)
            print('lam=%-4s CASE N %s leaf%d : %d vars deg<=%d -> M2v = %-5s (%.0f s) %s'
                  % (lam, tag, li, len(s.names), max(sum(x) for q in s.polys for x in q),
                     v, dt, '' if v is not None else str(i)[:40]), flush=True)
