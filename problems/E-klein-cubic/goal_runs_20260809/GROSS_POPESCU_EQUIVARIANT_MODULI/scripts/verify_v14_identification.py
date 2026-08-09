#!/usr/bin/env python3
"""Exact GP/repository V14 basis-conjugacy check over Q(zeta_11)."""
from __future__ import annotations
from fractions import Fraction as F
from itertools import combinations

D=10

def q(x=0): return (F(x),)+(F(0),)*(D-1)
Z=q(); O=q(1)

def add(a,b): return tuple(x+y for x,y in zip(a,b))
def neg(a): return tuple(-x for x in a)
def sub(a,b): return add(a,neg(b))
def scale(a,c): return tuple(F(c)*x for x in a)

def zp(n):
    n%=11
    if n<10:
        a=[F(0)]*10; a[n]=F(1); return tuple(a)
    return (F(-1),)*10

def mul(a,b):
    out=Z
    for i,x in enumerate(a):
        if x:
            for j,y in enumerate(b):
                if y: out=add(out,scale(zp(i+j),x*y))
    return out

def mm(a,b):
    out=[[Z for _ in b[0]] for _ in a]
    for i in range(len(a)):
        for k,x in enumerate(a[i]):
            if x!=Z:
                for j,y in enumerate(b[k]):
                    if y!=Z: out[i][j]=add(out[i][j],mul(x,y))
    return out

def eye(n): return [[O if i==j else Z for j in range(n)] for i in range(n)]
def mpow(a,n):
    r=eye(len(a))
    while n:
        if n&1:r=mm(r,a)
        a=mm(a,a); n//=2
    return r

def smat(n,c): return [[c if i==j else Z for j in range(n)] for i in range(n)]

P=list(combinations(range(6),2)); PI={p:i for i,p in enumerate(P)}
def wedge(a):
    w=[[Z]*15 for _ in range(15)]
    for c,(i,j) in enumerate(P):
        for r,(s,t) in enumerate(P):
            w[r][c]=sub(mul(a[s][i],a[t][j]),mul(a[t][i],a[s][j]))
    return w

def rv(r,a):
    out=[Z]*len(a[0])
    for i,x in enumerate(r):
        if x!=Z:
            for j,y in enumerate(a[i]):
                if y!=Z:out[j]=add(out[j],mul(x,y))
    return out

def erow(terms):
    r=[Z]*15
    for c,(i,j) in terms:
        k=PI[tuple(sorted((i-1,j-1)))]
        r[k]=add(r[k],q(c))
    return r

def rows(scaled):
    es=([
      [(2,(2,3)),(1,(1,5))],[(2,(2,6)),(-1,(1,3))],
      [(1,(1,4)),(2,(3,5))],[(1,(1,6)),(-2,(4,5))],
      [(2,(4,6)),(1,(1,2))]] if scaled else [
      [(1,(2,3)),(1,(1,5))],[(1,(2,6)),(-1,(1,3))],
      [(1,(1,4)),(1,(3,5))],[(1,(1,6)),(-1,(4,5))],
      [(1,(4,6)),(1,(1,2))]])
    return [erow(e) for e in es]

def contains(rs,v):
    used=set()
    for r in rs:
        s=[i for i,x in enumerate(r) if x!=Z]
        assert len(s)==2 and not used.intersection(s); used.update(s)
        a,b=s
        if mul(v[a],r[b])!=mul(v[b],r[a]): return False
    return all(v[i]==Z for i in range(15) if i not in used)

def stable(rs,a): return all(contains(rs,rv(r,a)) for r in rs)

def main():
    gauss=Z
    for x in range(11):gauss=add(gauss,zp(x*x))
    assert mul(gauss,gauss)==q(-11)
    c=scale(gauss,F(-1,11)) # 1/gauss
    T=[[Z]*6 for _ in range(6)]
    S=[[Z]*6 for _ in range(6)]
    for i in range(6):
        T[i][i]=zp(i*i); S[i][0]=c
        for j in range(1,6):S[i][j]=mul(c,add(zp(i*j),zp(-i*j)))
    assert mpow(T,11)==eye(6)
    assert mpow(S,2)==smat(6,q(-1))
    WT,WS=wedge(T),wedge(S)
    assert mpow(WS,2)==eye(15)
    corrected,raw=rows(True),rows(False)
    assert stable(corrected,WT) and stable(corrected,WS)
    assert stable(raw,WT) and not stable(raw,WS)
    print('field=Q(zeta_11); gauss^2=-11')
    print('even_Weil: T^11=I, S^2=-I, (Lambda^2 S)^2=I')
    print('scaled_GP_hyperplanes: T-stable=True, S-stable=True, kernel_dimension=10')
    print('unscaled_GP_hyperplanes: T-stable=True, S-stable=False')
    print('V14_IDENTIFICATION_PASS')
if __name__=='__main__':main()
