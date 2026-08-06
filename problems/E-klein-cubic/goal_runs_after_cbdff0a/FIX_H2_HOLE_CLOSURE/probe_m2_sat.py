"""CASE Z, best-conditioned form for Macaulay2.

lowdeg4 still carries the component {B9 = 0} (its generator B0*B9 = 0 cannot be
resolved without knowing B9 != 0), and that component is exactly what the
licence removes -- V(cone) n {B6=1, B9=0} is stratum A, char-0 EMPTY.  So
adjoin the Rabinowitsch inverse B9*w = 1 AND the consequence B0 = 0.  Both are
licensed; together they delete the spurious component the Groebner engine was
carrying.
"""
import h2_final as FF, h2_engines as E, n2b_lib as L, n2c_systems as S, holes_reduce as RD
from n2b_lib import ONE, ZERO
for lam in ('one','om','om2'):
    k, nm, pl = [(k,nm,pl) for c,k,nm,pl in FF.presentations(8,lam) if c=='Z' and k=='lowdeg4'][0]
    nm = list(nm); pl = [dict(q) for q in pl]
    i0 = nm.index('B0')
    pl = [S.p_drop(S.p_setvar(q, i0, ZERO), {i0}) for q in pl]
    pl = [q for q in pl if q]; nm = [x for j,x in enumerate(nm) if j != i0]
    i9 = nm.index('B9'); n = len(nm)
    e = [0]*(n+1); e[i9] = 1; e[n] = 1
    pl = [{tuple(list(kk)+[0]): v for kk,v in q.items()} for q in pl]
    pl.append({tuple(e): ONE, tuple([0]*(n+1)): L.kneg(ONE)})
    nm = nm + ['w']
    pl = RD.dedup(pl)
    print('lam=%-4s CASE Z sat+B0=0 : %d vars %s, %d gens, deg<=%d'
          % (lam, len(nm), nm, len(pl), max(sum(x) for q in pl for x in q)), flush=True)
    v,dt,i = E.m2v('satZ_%s'%lam, nm, pl, timeout=900)
    print('   M2v = %-5s (%.0f s) %s' % (v, dt, '' if v is not None else str(i)[:60]), flush=True)
    v2,dt2,i2 = E.qq('satZ_%s'%lam, nm, pl, timeout=900)
    print('   msolve-qq = %-5s (%.0f s)' % (v2, dt2), flush=True)
