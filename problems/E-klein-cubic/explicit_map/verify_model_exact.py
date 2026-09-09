#!/usr/bin/env python3
"""Exact Klein/Weil covariance in Z[zeta_11], with no numerical approximation.

Cyclotomic elements use the basis 1,z,...,z^9. All products below have
integer coefficients; the displayed S_5 matrix is `S5_numerator/11`.
"""
from __future__ import annotations
import json,itertools
from pathlib import Path
from klein_map import matrix
Z=(0,)*10;ONE=(1,)+(0,)*9

def normalize(a):
    b=[0]*11
    for i,x in enumerate(a):b[i%11]+=x
    return tuple(x-b[10] for x in b[:10])
def power(n):
    a=[0]*11;a[n%11]=1;return normalize(a)
def add(a,b):return tuple(x+y for x,y in zip(a,b))
def neg(a):return tuple(-x for x in a)
def scale(a,n):return tuple(n*x for x in a)
def mul(a,b):
    c=[0]*19
    for i,x in enumerate(a):
        if x:
            for j,y in enumerate(b):
                if y:c[i+j]+=x*y
    return normalize(c)
def mm(A,B):
    return [[sumring(mul(x,y) for x,y in zip(row,col)) for col in zip(*B)] for row in A]
def sumring(aa):
    out=Z
    for a in aa:out=add(out,a)
    return out

def pf_terms(ids):
    if not ids:return [(1,())]
    ans=[]
    for j in range(1,len(ids)):
        for s,p in pf_terms(ids[1:j]+ids[j+1:]):ans.append(((-1)**(j+1)*s,((ids[0],ids[j]),)+p))
    return ans

def main():
    H=[[ONE if i==0 else scale(ONE,2) if j==0 else add(power(i*j),power(-i*j)) for j in range(6)] for i in range(6)]
    square=mm(H,H)
    assert square==[[scale(ONE,11) if i==j else Z for j in range(6)] for i in range(6)]
    gauss=sumring(power(j*j) for j in range(11));assert mul(gauss,gauss)==scale(ONE,-11)
    assert sumring(H[i][i] for i in range(6))==Z
    bases=[matrix([int(i==j) for i in range(5)]) for j in range(5)]
    cols=[]
    for A in bases:
        AR=[[scale(ONE,v) for v in row] for row in A]
        raw=mm(mm(list(zip(*H)),AR),H)
        raw=[[neg(v) for v in row] for row in raw]
        x=[neg(raw[1][2]),neg(raw[3][5]),neg(raw[2][4]),raw[1][5],raw[3][4]]
        want=[[sumring(scale(x[k],bases[k][i][j]) for k in range(5)) for j in range(6)] for i in range(6)]
        assert raw==want
        cols.append(x)
    S=list(map(list,zip(*cols)))
    cs={i:add(power(i),power(-i)) for i in range(1,6)}
    specs=((4,3,5),(1,2,4),(3,5,1),(2,4,3),(5,1,2))
    ps=[sumring((scale(ONE,2),scale(cs[a],2),scale(cs[b],-2),neg(cs[c]))) for a,b,c in specs]
    assert S==[[ps[(i+j)%5] for j in range(5)] for i in range(5)]
    assert mm(S,S)==[[scale(ONE,121) if i==j else Z for j in range(5)] for i in range(5)]
    wt=(6,10,2,7,8);uwt=tuple(j*j%11 for j in range(6))
    for k,A in enumerate(bases):
        for i in range(6):
            for j in range(6):
                if A[i][j]:assert (-uwt[i]-uwt[j]-wt[k])%11==0
    terms={}
    for sign,pairs in pf_terms(list(range(6))):
        entries=[]
        for i,j in pairs:
            candidates=[(k,A[i][j]) for k,A in enumerate(bases) if A[i][j]]
            if not candidates:break
            entries.append(candidates)
        else:
            for aa in itertools.product(*entries):
                mon=[0]*5;coef=sign
                for k,c in aa:mon[k]+=1;coef*=c
                mon=tuple(mon);terms[mon]=terms.get(mon,0)+coef
    terms={k:v for k,v in terms.items() if v}
    expected={}
    for i in range(5):m=[0]*5;m[i]=2;m[(i+1)%5]=1;expected[tuple(m)]=1
    assert terms==expected
    result={'ring':'Z[z]/(1+z+...+z^10)','gauss_coefficients':gauss,'S5_denominator':11,
            'S5_numerator':S,'T5_weights':wt,'checks':['H6^2=11 I6','Gauss^2=-11','trace H6=0',
              'S6^{-T} M(y) S6^{-1}=M(S5 y)','T6^{-T} M(y) T6^{-1}=M(T5 y)','S5^2=I5','Pf(M)=sum y_i^2 y_(i+1)']}
    Path('model_exact.json').write_text(json.dumps(result,indent=2)+'\n')
    print('Exact cyclotomic model and Pfaffian identities: PASS')
    for row in S:
        print(['('+' '.join(f'{c:+d}z^{i}' for i,c in enumerate(x) if c)+')/11' for x in row])
if __name__=='__main__':main()
