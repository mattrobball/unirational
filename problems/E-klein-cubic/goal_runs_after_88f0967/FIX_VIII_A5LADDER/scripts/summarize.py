"""Assemble payload/verdicts.json: the per-degree ladder verdict at both primes."""
import json, os, glob, sys
HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
P = os.path.join(HERE, 'payload')

out = {}
for p in (67, 199):
    s1 = os.path.join(P, 'stage1_p%d.json' % p)
    if not os.path.exists(s1):
        continue
    st1 = json.load(open(s1))
    loci = json.load(open(os.path.join(P, 'loci_p%d.json' % p))) \
        if os.path.exists(os.path.join(P, 'loci_p%d.json' % p)) else {'per_degree': {}}
    land = {}
    for fn in glob.glob(os.path.join(P, 'land_p%d_*.json' % p)):
        land.update(json.load(open(fn)))
    per = {}
    for d in range(2, 13):
        e = {'K': st1['dims'].get(str(d), st1['dims'].get(d)),
             'molien': st1['molien'][d]}
        ld = loci['per_degree'].get(str(d), loci['per_degree'].get(d))
        if ld:
            e['branch_max_dim'] = ld['max_dim']
            e['branch_nonzero'] = ld['n_nonzero']
        la = land.get(str(d), land.get(d))
        if la:
            vs = {}
            for k, v in la['verdicts'].items():
                vs[v['verdict']] = vs.get(v['verdict'], 0) + 1
            e['land'] = vs
            e['unresolved'] = la['unresolved']
            e['verdict'] = 'EMPTY' if not la['unresolved'] else 'UNRESOLVED'
        elif ld and ld['max_dim'] == 0:
            e['verdict'] = 'EMPTY (linear certificate: every branch space is 0)'
        per[d] = e
    out[p] = {'A5_gens': st1['A5_gens'], 'molien': st1['molien'],
              'dims': st1['dims'], 'per_degree': per}
json.dump(out, open(os.path.join(P, 'verdicts.json'), 'w'), indent=1)
for p in out:
    print('p =', p)
    for d, e in out[p]['per_degree'].items():
        print('  d=%2d K=%3d  %s  %s' % (d, e['K'], e.get('verdict', '(pending)'),
                                         e.get('land', '')))
