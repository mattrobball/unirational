import time, h2_final as FF, h2_engines as E
lam='one'
pres = FF.presentations(8, lam)
for c,k,nm,pl in pres:
    if not k.startswith('reduced'): continue
    for eng,fn in (('M2K',E.m2),('M2v',E.m2v)):
        v,dt,i = fn('probe_%s_%s_%s_%s'%(lam,c,k,eng), nm, pl, timeout=420)
        print('%s %-10s %d vars deg<=%2d : %-3s = %-5s (%.0f s) %s' % (c,k,len(nm),
              max(sum(x) for q in pl for x in q), eng, v, dt, '' if v is not None else str(i)[:60]), flush=True)
        if v is True: break
