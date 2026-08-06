import h2_engines as E, h2_final as FF, holes_lib as H, json, os
res = {}
for lam in ('one','om','om2'):
    done = None
    for c,k,nm,pl in FF.presentations(8, lam):
        if c != 'Z' or done: continue
        v,dt,i = E.m2v('h2Mz_%s_%s' % (lam,k), nm, pl, timeout=900)
        print('lam=%-4s CASE Z %-12s vars=%2d gens=%2d deg<=%2d  M2v = %-5s (%.0f s) %s'
              % (lam,k,len(nm),len(pl),max(sum(x) for q in pl for x in q), v, dt,
                 '' if v is not None else str(i)[:60]), flush=True)
        if v is True: done = k
        elif v is False: done = 'NONEMPTY'
    res[lam] = ('EMPTY-by-M2v (%s)' % done) if done and done!='NONEMPTY' else (done or 'NOT-DECIDED')
    print(' => lam=%s CASE Z : %s' % (lam, res[lam]), flush=True)
p = os.path.join(H.HERE,'payloads','taskA_m2_caseZ_r8.json')
json.dump(res, open(p,'w'), indent=1, sort_keys=True)
print('\nCASE Z Macaulay2 side: %s' % res, flush=True)
