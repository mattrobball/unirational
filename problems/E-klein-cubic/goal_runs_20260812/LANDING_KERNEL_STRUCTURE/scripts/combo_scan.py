#!/usr/bin/env python3
"""Scan small signed combinations of Molien values matching P3(d) at all four degrees.
Models scanned (offsets constant in d):
  M1: P3(d) = I(3d-a) - I(3d-b)
  M2: P3(d) = I(3d-a) + I(3d-b) - I(3d-c)
  M3: P3(d) = I(3d-a) + I(3d-b) - I(3d-c) - I(3d-e)
  M4: P3(d) = A(d-a)*? no -- instead: P3(d) = sum of up to 3 signed A(2d-o) / A(3d-o) terms? skip
  M5: P3(d) = I(3d-a) - I(3d-b) - I(3d-c)
Also pure sums up to 3 terms. I(m)=0 for m<0.
"""
import json
D = json.load(open("/Users/worker/unirational/problems/E-klein-cubic/goal_runs_20260812/LANDING_KERNEL_STRUCTURE/results/molien_ext.json"))
I = D["I"]; A = D["A"]
def Iv(m): return I[m] if 0 <= m < len(I) else 0
def Av(m): return A[m] if 0 <= m < len(A) else 0
P3 = {35:1380, 36:1850, 37:2642, 38:3285}
ds = [35,36,37,38]
OMAX = 106
hits = []
# M1
for a in range(OMAX):
    for b in range(a+1, OMAX+10):
        if all(Iv(3*d-a) - Iv(3*d-b) == P3[d] for d in ds):
            hits.append(("I(3d-%d)-I(3d-%d)"%(a,b),))
# pure 2-sum
for a in range(OMAX):
    for b in range(a, OMAX+10):
        if all(Iv(3*d-a) + Iv(3*d-b) == P3[d] for d in ds):
            hits.append(("I(3d-%d)+I(3d-%d)"%(a,b),))
# M2 / M5 with early pruning on d=35
for a in range(OMAX):
    for b in range(a, OMAX+10):
        s35 = Iv(105-a) + Iv(105-b)
        # M2: minus one term
        r = s35 - P3[35]
        if r >= 0:
            cs = [c for c in range(OMAX+10) if Iv(105-c) == r]
            for c in cs:
                if all(Iv(3*d-a)+Iv(3*d-b)-Iv(3*d-c) == P3[d] for d in ds):
                    hits.append(("I(3d-%d)+I(3d-%d)-I(3d-%d)"%(a,b,c),))
for a in range(OMAX):
    s35 = Iv(105-a)
    r = s35 - P3[35]
    if r <= 0: continue
    for b in range(OMAX+10):
        r2 = r - Iv(105-b)
        if r2 < 0: continue
        cs = [c for c in range(b, OMAX+10) if Iv(105-c) == r2]
        for c in cs:
            if all(Iv(3*d-a)-Iv(3*d-b)-Iv(3*d-c) == P3[d] for d in ds):
                hits.append(("I(3d-%d)-I(3d-%d)-I(3d-%d)"%(a,b,c),))
# A-based: P3(d) = c1*A(m1(d)) ... try P3(d) = A(x*d - o) forms
for mult in (1,2,3):
    for o in range(-20, 130):
        if all(Av(mult*d - o) == P3[d] for d in ds):
            hits.append(("A(%dd-%d)"%(mult,o),))
# I at multiples: P3(d) = I(k*d - o)
for mult in (1,2,3,4,5):
    for o in range(-30, 160):
        if all(Iv(mult*d - o) == P3[d] for d in ds):
            hits.append(("I(%dd-%d)"%(mult,o),))
print("HITS:", hits if hits else "NONE")
