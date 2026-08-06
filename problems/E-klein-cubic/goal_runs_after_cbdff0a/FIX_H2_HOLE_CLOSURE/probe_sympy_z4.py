import time, h2_face as F, holes_track as TR, h2_engines as E
for lam in ('one','om','om2'):
    names, fpolys, allp, b, vs = F.face(8, lam)
    br = TR.start(names, [dict(q) for q in allp]); br = TR.do_setzero(br, br.names.index('Y0'))
    s = [x for x in TR.solve(br) if x.env.get('B9')][0]
    t0=time.time(); v,dt,i = E.sp(s.names, s.polys)
    print('CASE Z reduced lam=%-4s (%d vars): sympy = %s (%.1f s) %s' % (lam, len(s.names), v, dt, i), flush=True)
