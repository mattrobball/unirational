"""Shrink the packet: compress the covariant bases, drop bulky msolve inputs.

Keeps every msolve OUTPUT (the certificates) and the smallest input per degree
as a worked example; the inputs are fully regenerable by stage3_land.py.
"""
import os, glob, sys
import numpy as np
HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# 1. covariant bases -> one compressed archive per prime
for p in (67, 199):
    fns = sorted(glob.glob(os.path.join(HERE, 'payload', 'basis_d*_p%d.npy' % p)),
                 key=lambda f: int(f.split('_d')[1].split('_')[0]))
    if not fns:
        continue
    arrs = {}
    for f in fns:
        d = int(f.split('_d')[1].split('_')[0])
        arrs['d%d' % d] = np.load(f).astype(np.int16 if p < 256 else np.int32)
    out = os.path.join(HERE, 'payload', 'covariant_bases_p%d.npz' % p)
    np.savez_compressed(out, **arrs)
    print('wrote %s (%.1f MB) from %d files' % (out, os.path.getsize(out) / 1e6, len(fns)))
    for f in fns:
        os.remove(f)

# 2. superseded intermediate branch files from the plane-only pass
for f in glob.glob(os.path.join(HERE, 'payload', 'branch_d*_*.npy')):
    os.remove(f)
for f in glob.glob(os.path.join(HERE, 'payload', 'branchmax_d*')):
    os.remove(f)

# 3. msolve inputs: keep only those under 200 kB
kept = dropped = 0
for f in glob.glob(os.path.join(HERE, 'results', '*.ms')):
    if os.path.getsize(f) > 200000:
        os.remove(f)
        dropped += 1
    else:
        kept += 1
print('msolve inputs: kept %d, dropped %d oversized' % (kept, dropped))
tot = sum(os.path.getsize(os.path.join(dp, f))
          for dp, _, fs in os.walk(HERE) for f in fs)
print('packet size now %.1f MB' % (tot / 1e6))
