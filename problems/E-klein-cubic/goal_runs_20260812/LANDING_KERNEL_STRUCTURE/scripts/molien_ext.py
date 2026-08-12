#!/usr/bin/env python3
"""Extended exact Molien table for PSL(2,11) on W (5-dim Weil rep).
I(m) = mult of trivial in Sym^m W, A(m) = mult of W, J(m) = mult of W*.
Exact in Q(sqrt(-11)). Extends director_probes_20260811/molien_director.py to DMAX=130.
Then: match search P3(d) in {1380,1850,2642,3285} against I(m) values and
small +/- combinations."""
from fractions import Fraction as Fr
import json, sys

DMAX = 135

class Q11:
    __slots__ = ("a", "b")
    def __init__(self, a, b=0):
        self.a, self.b = Fr(a), Fr(b)
    def __add__(s, o): return Q11(s.a + o.a, s.b + o.b)
    def __mul__(s, o): return Q11(s.a*o.a - 11*s.b*o.b, s.a*o.b + s.b*o.a)
    def conj(s): return Q11(s.a, -s.b)
    def scal(s, r): return Q11(s.a*r, s.b*r)

LAM = Q11(Fr(-1,2), Fr(1,2)); LBR = LAM.conj()
QR11 = {1,3,4,5,9}
SIZES = [1,55,110,132,132,110,60,60]
CHI_W = [Q11(5),Q11(1),Q11(-1),Q11(0),Q11(0),Q11(1),LAM,LBR]

def power_sum(ci,k):
    if ci==0: return Q11(5)
    if ci==1: return Q11(5) if k%2==0 else Q11(1)
    if ci==2: return Q11(5) if k%3==0 else Q11(-1)
    if ci in (3,4): return Q11(5) if k%5==0 else Q11(0)
    if ci==5:
        return [Q11(5),Q11(1),Q11(-1),Q11(1),Q11(-1),Q11(1)][k%6]
    r=k%11
    if r==0: return Q11(5)
    same=(r in QR11)
    if ci==6: return LAM if same else LBR
    return LBR if same else LAM

def h_series(ci):
    h=[Q11(1)]
    for d in range(1,DMAX+1):
        acc=Q11(0)
        for k in range(1,d+1):
            acc=acc+power_sum(ci,k)*h[d-k]
        h.append(acc.scal(Fr(1,d)))
    return h

H=[h_series(ci) for ci in range(8)]

def mult(d,weight):
    acc=Q11(0)
    for ci in range(8):
        acc=acc+(H[ci][d]*weight[ci]).scal(SIZES[ci])
    acc=acc.scal(Fr(1,660))
    assert acc.b==0 and acc.a.denominator==1,(d,acc.a,acc.b)
    return int(acc.a)

TRIV=[Q11(1)]*8
W_CONJ=[c.conj() for c in CHI_W]
I=[mult(d,TRIV) for d in range(DMAX+1)]
A=[mult(d,W_CONJ) for d in range(DMAX+1)]

# anchors from sealed record
anch = {"I(3)":(I[3],1),"I(105)":(I[105],8555),"I(108)":(I[108],9545),
        "I(111)":(I[111],10614),"I(114)":(I[114],11776),
        "A(34)":(A[34],576),"A(35)":(A[35],637),"A(36)":(A[36],706),
        "A(37)":(A[37],784),"A(38)":(A[38],867),"A(42)":(A[42],1271),
        "I(117)":(I[117],13026),"I(120)":(I[120],14379),
        "I(123)":(I[123],15828),"I(126)":(I[126],17391)}
bad={k:v for k,v in anch.items() if v[0]!=v[1]}
print("anchors:", "ALL PASS" if not bad else bad)

P3={35:1380,36:1850,37:2642,38:3285}
# single-term match: P3(d) == I(m)?
print("\nsingle-term matches P3(d)=I(m):")
for d,v in P3.items():
    ms=[m for m in range(DMAX+1) if I[m]==v]
    print(" d=%d P3=%d  I(m)=v at m=%s  (3d=%d, offsets e=3d-m: %s)"%(d,v,ms,3*d,[3*d-m for m in ms]))

# print table around interest
print("\n m : I(m) for m=60..130")
print(" ".join("%d:%d"%(m,I[m]) for m in range(60,131)))
json.dump({"I":I,"A":A}, open(sys.argv[1] if len(sys.argv)>1 else
  "/Users/worker/unirational/problems/E-klein-cubic/goal_runs_20260812/LANDING_KERNEL_STRUCTURE/results/molien_ext.json","w"))
