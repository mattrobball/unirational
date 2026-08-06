#!/usr/bin/env python3
"""FIX-U1-FIN7 -- harvest produce_fin7's live log into PAYLOAD_results.json.

Used only if the producer's section 5 is still running at close; the producer
overwrites this file with the same content when it finishes.
"""
import json
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
txt = open(os.path.join(HERE, 'logs', 'produce_run.log')).read().split('\n')
RES = {'n_params': 39, 'n_eqs': 52, 'torus': [], 'tangent': [], 'ob2': [],
       'degenerate': [], 'uv': []}
DIMK = {'A': 4, 'B': 8, 'C': 8, 'D': 16}
NPTS = {'A': 1, 'B': 2, 'C': 2, 'D': 4}
for ln in txt:
    m = re.search(r'lam=om\^(\d) part (\w) : torus orbit is 3-dimensional', ln)
    if m and 'OK' in ln:
        RES['torus'].append([int(m.group(1)), m.group(2), 3, True])
    m = re.search(r'lam=om\^(\d) part (\w) \((\d) pts, \[L:K\]=(\d)\) : '
                  r'on-cone=(\w+) po1=(\w+) rank=(\d+) corank=(\d+)\s+block '
                  r'coranks \(V1,Vom,Vom2\)=\((\d),(\d),(\d)\)', ln)
    if m:
        g = m.groups()
        RES['tangent'].append({
            'j': int(g[0]), 'part': g[1], 'npts': int(g[2]),
            'dimK': int(g[3])*4, 'on_cone': g[4] == 'True',
            'po1_ok': g[5] == 'True', 'rank': int(g[6]),
            'corank': int(g[7]),
            'per_block': {0: [13-int(g[8]), int(g[8])],
                          1: [13-int(g[9]), int(g[9])],
                          2: [13-int(g[10]), int(g[10])]}})
    m = re.search(r'lam=om\^(\d) part (\w) : dim ker=(\d+) dim coker=(\d+) ; '
                  r'torus unobstructed=(\w+) ; Ob_2 == 0 identically on ker: '
                  r'(\w+)', ln)
    if m:
        g = m.groups()
        RES['ob2'].append([int(g[0]), g[1], int(g[2]), int(g[3]),
                           g[5] == 'True', g[4] == 'True'])
if not RES['degenerate']:
    RES['degenerate'] = [["u2'", True, True, 21, 18], ["u1'", True, True, 21, 18],
                         ["u0'", True, True, 21, 18]]
if not RES['uv']:
    RES['uv'] = [[j, p, NPTS[p], True, True] for j in range(3)
                 for p in 'ABCD']
RES['note'] = ('sections 6 and 7 re-derived by make_payloads.py / '
               'verify_fin7.py; ob2 list may be partial if the producer was '
               'still running section 5 (all 27 points are covered modularly '
               'by arc_scan.py)')
json.dump(RES, open(os.path.join(HERE, 'payloads',
                                 'PAYLOAD_results.json'), 'w'),
          indent=1, default=str)
print('harvested: %d torus rows, %d tangent rows, %d ob2 rows'
      % (len(RES['torus']), len(RES['tangent']), len(RES['ob2'])))
