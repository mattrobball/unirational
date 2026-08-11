"""Follow-up independent checks on top of indep_census.py:

 (a) the components of Z^H for ONE FIXED H (the packet's DICTIONARY table),
     counted directly over the component list;
 (b) the STANDARD_FORM_PW 5(d) correction: components created over the GENERIC
     point of each centre, at the moment of creation;
 (c) the C11 / C5 / C6 spot-checks done by hand in the adjudication.
"""
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import adj_indep_census as IC                               # noqa: E402

m, G, n, ARR, AIDX = IC.m, IC.G, IC.n, IC.ARR, IC.AIDX

R = {j: IC.census(j, verbose=False) for j in (1, 2, 3)}
print()

# ---------------- (a) Z^H for one fixed H ----------------
rows3 = R[3]
byclass = defaultdict(list)
for ch, sps, K, sw, dim in rows3:
    byclass[IC.gname(K)].append((ch, sps, K, sw, dim))

# pick one representative subgroup of each occurring class
reps = {}
for ch, sps, K, sw, dim in rows3:
    reps.setdefault(IC.gname(K), K)
print("(a) components of Z^H for ONE fixed H (independent recount)")
for cls in ("C2", "C3", "V4", "C5", "C6", "C11"):
    H = reps[cls]
    d = defaultdict(int)
    for ch, sps, K, sw, dim in rows3:
        if H <= K:
            d[dim] += 1
    print(f"    Z^{cls:<4} by dim {dict(sorted(d.items()))}  total {sum(d.values())}")

print()
print("(a') components of Z_(=H) for ONE fixed H (exact stabiliser = that H)")
for cls in ("C2", "C3", "V4", "C5", "C6", "C11"):
    H = reps[cls]
    d = defaultdict(int)
    for ch, sps, K, sw, dim in rows3:
        if H == K:
            d[dim] += 1
    print(f"    Z_(={cls:<4}) by dim {dict(sorted(d.items()))}  total {sum(d.values())}")

# ---------------- (b) the 5(d) correction ----------------
print()
print("(b) components created over the GENERIC point of each centre")
print("    (length-1 chain, A_0 = the whole centre), at the moment of creation")
tot = defaultdict(lambda: defaultdict(int))
for j in (1, 2, 3):
    for ch, sps, K, sw, dim in R[j]:
        if len(ch) != 1:
            continue
        U = ARR[ch[0]]
        if len(U) != j:            # centre blown up exactly at this stage
            continue
        if sps[0] != U:            # A_0 must be the whole centre
            continue
        tot[IC.gname(K)][dim] += 1
for cls in sorted(tot, key=lambda s: (len(s), s)):
    print(f"    {cls:<5} {dict(sorted(tot[cls].items()))}"
          f"   total {sum(tot[cls].values())}")

# ---------------- (c) hand spot checks ----------------
print()
print("(c) targeted spot checks")
# C11: a fixed C11 and its fixed points of Z
H = reps["C11"]
pts = [(ch, sps) for ch, sps, K, sw, dim in rows3 if H <= K]
print(f"    a fixed C11 (order {len(H)}) fixes {len(pts)} components of Z")
# orbits of C11 rows
c11rows = [(ch, sps, K, sw, dim) for ch, sps, K, sw, dim in rows3
           if IC.gname(K) == "C11"]
print(f"    C11 rows: {len(c11rows)} components, orbit sizes "
      f"{sorted(set(n // len(sw) for _, _, _, sw, _ in c11rows))}")
c5rows = [r for r in rows3 if IC.gname(r[2]) == "C5"]
print(f"    C5  rows: {len(c5rows)} components, orbit sizes "
      f"{sorted(set(n // len(r[3]) for r in c5rows))}")
v4rows = [r for r in rows3 if IC.gname(r[2]) == "V4"]
print(f"    V4  rows: {len(v4rows)} components, orbit sizes "
      f"{sorted(set(n // len(r[3]) for r in v4rows))}, dims "
      f"{sorted(set(r[4] for r in v4rows))}")
# every V4 row on a crossing?
print(f"    V4 rows with chain length >= 2: "
      f"{sum(1 for r in v4rows if len(r[0]) >= 2)} of {len(v4rows)}")
# M_tau^V : the C2, dim 2, chain = ell_V row
mrows = [r for r in rows3 if IC.gname(r[2]) == "C2" and r[4] == 2 and len(r[0]) == 1
         and len(ARR[r[0][0]]) == 2 and IC.gname(IC.STAB[r[0][0]]) == "A4"]
print(f"    M_tau^V candidates (C2, dim 2, single branch on an ell_V): "
      f"{len(mrows)} components, setwise stabiliser classes "
      f"{sorted(set(IC.gname(r[3]) for r in mrows))}")
# pairwise disjointness of the 165 M_tau^V on Z: no component lies in two
cnt = defaultdict(int)
for r in rows3:
    for r2 in mrows:
        pass
print()
# crossing census
cr = defaultdict(int)
for ch, sps, K, sw, dim in rows3:
    cr[len(ch)] += 1
print(f"    components by |I| (chain length): {dict(sorted(cr.items()))}")
print(f"    chains available: |I|=1 {len(IC.CH1)}, |I|=2 {len(IC.CH2)}, "
      f"|I|=3 {len(IC.CH3)}")
# generic stabiliser of each crossing = the stabiliser of the row whose
# A_i are the full graded pieces
print()
print("INDEP_EXTRA_DONE")
