"""CASE N second engine: the cube-root branches, which are the shape M2 likes
(13 variables, but carrying two Rabinowitsch inverses, so the spurious
{Y0=0} and {B9=0} components are already gone).  Branch k0 for lam=1 was
decided by M2 in 11 s; try all three branches in the other two blocks."""
import h2_cuberoot as CR, h2_engines as E
for lam in ('om','om2','one'):
    for tag, nm, pl in CR.branches(8, lam):
        v,dt,i = E.m2v('cr_%s_%s' % (lam, tag), nm, pl, timeout=600)
        print('lam=%-4s CASE N cube-root %s : %d vars deg<=%d -> M2v = %-5s (%.0f s) %s'
              % (lam, tag, len(nm), max(sum(x) for q in pl for x in q), v, dt,
                 '' if v is not None else str(i)[:50]), flush=True)
