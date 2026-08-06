import h2_final as FF, h2_engines as E
for lam in ('one',):
    for c,k,nm,pl in FF.presentations(8, lam):
        if not k.startswith('reduced'): continue
        v,dt,i = E.m2v('m2v_%s_%s_%s'%(lam,c,k), nm, pl, timeout=600)
        print('%s %-10s %2d vars deg<=%2d : M2v = %-5s (%.0f s) %s' % (c,k,len(nm),
              max(sum(x) for q in pl for x in q), v, dt, '' if v is not None else str(i)[:60]), flush=True)
