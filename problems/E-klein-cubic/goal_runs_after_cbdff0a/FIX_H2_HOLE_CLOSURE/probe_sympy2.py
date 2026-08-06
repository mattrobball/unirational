import time, h2_final as FF, h2_split as SP, h2_face as F, holes_track as TR, h2_engines as E
lam='one'
# (a) the small N-leaves
for c,k,nm,pl in FF.presentations(8,lam):
    if c=='N' and k in ('reduced0','reduced1','reduced2'):
        v,dt,i = E.sp(nm,pl); print('N %s (%d vars): sympy=%s (%.1fs)'%(k,len(nm),v,dt), flush=True)
# (b) the Z split pieces
names, fpolys, allp, b, vs = F.face(8, lam)
br = TR.start(names, [dict(q) for q in allp]); br = TR.do_setzero(br, br.names.index('Y0'))
s = [x for x in TR.solve(br) if x.env.get('B9')][0]
pcs = SP.pieces(list(s.names), [dict(q) for q in s.polys], maxvars=5, maxdepth=6)
print('Z split -> %d pieces %s' % (len(pcs), [(len(n),len(p)) for n,p,_ in pcs]), flush=True)
for i,(nm,pl,t) in enumerate(pcs):
    v,dt,ii = E.sp(nm,pl); print('  Z piece %d (%d vars): sympy=%s (%.1fs)'%(i,len(nm),v,dt), flush=True)
