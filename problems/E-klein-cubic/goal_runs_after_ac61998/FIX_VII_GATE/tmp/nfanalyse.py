import sys
import numpy as np

HERE = '/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_ac61998/FIX_VII_GATE'
sys.path.insert(0, HERE)
from stage4_carrier import parse_nf
from gatelib import rank_mod

for p in (67, 199):
    zero, terms = parse_nf(HERE + '/results/NF_p%d.txt' % p, 16)
    sup = sorted({e for (t, j, i), d in terms.items() if t == 'NF' for e in d})
    si = {e: k for k, e in enumerate(sup)}
    Mfull = np.zeros((16, 5 * len(sup)), dtype=np.int64)
    per = []
    for i in range(5):
        Mi = np.zeros((16, len(sup)), dtype=np.int64)
        for j in range(16):
            for e, c in terms.get(('NF', j, i), {}).items():
                Mi[j, si[e]] = c % p
        Mfull[:, i * len(sup):(i + 1) * len(sup)] = Mi
        per.append(rank_mod(Mi, p))
    degs = sorted({sum(e) for e in sup})
    sizes = [len(d) for (t, j, i), d in terms.items() if t == 'NF']
    print("p=%d support=%d degrees=%s per-component ranks=%s total=%d "
          "terms/NF min=%d max=%d"
          % (p, len(sup), degs, per, rank_mod(Mfull, p), min(sizes), max(sizes)))
