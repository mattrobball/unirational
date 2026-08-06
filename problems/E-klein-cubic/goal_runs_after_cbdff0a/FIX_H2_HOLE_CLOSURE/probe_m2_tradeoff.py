import h2_final as FF, holes_reduce as RD, h2_engines as E
lam = 'one'
base = [(k,nm,pl) for c,k,nm,pl in FF.presentations(8,lam) if c=='Z' and k=='lowdeg4'][0]
k, nm, pl = base
cands = [('md0', nm, pl)]
for md in (3,4):
    n2,p2,_ = RD.eliminate_all(list(nm), [dict(q) for q in pl], verbose=False, maxdeg=md)
    cands.append(('md%d'%md, n2, p2))
for tag, n2, p2 in cands:
    v,dt,i = E.m2v('tradeoff_Z_%s'%tag, n2, p2, timeout=420)
    print('CASE Z %-5s : %2d vars deg<=%2d %4d terms -> M2v = %-5s (%.0f s) %s'
          % (tag, len(n2), max(sum(x) for q in p2 for x in q), sum(len(q) for q in p2), v, dt,
             '' if v is not None else str(i)[:50]), flush=True)
