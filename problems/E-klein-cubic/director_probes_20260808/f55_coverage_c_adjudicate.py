#!/usr/bin/env python3
"""Exact Coverage-C adjudication verifier; no MILP input is trusted."""
from collections import Counter, defaultdict
from fractions import Fraction
import sympy as sp
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ

e2=(0,0,1,0)
S16=[(-3,-2,-3,-3),(0,1,3,0),(-2,0,-2,-2),(-1,1,-1,0),
(-1,1,0,-1),(0,2,2,0),(0,3,0,1),(-1,-1,-2,-2),
(1,1,0,2),(1,1,2,0),(0,1,-1,-1),(1,2,0,1),
(1,2,1,0),(1,3,0,0),(1,0,-1,-1),(2,1,1,0)]
S26=[(-3,-2,-3,-3),(-2,-1,-2,-1),(-2,-1,-1,-2),(-1,0,0,0),
(0,1,1,2),(-1,0,1,-1),(0,1,2,1),(0,1,3,0),
(-2,0,-2,-2),(-1,1,-1,0),(-1,1,0,-1),(0,2,1,1),
(0,2,2,0),(0,3,0,1),(-1,-1,-2,-2),(0,0,-1,0),
(1,1,0,2),(0,0,0,-1),(1,1,1,1),(1,1,2,0),
(0,1,-1,-1),(1,2,0,1),(1,2,1,0),(1,3,0,0),
(1,0,-1,-1),(2,1,1,0)]

def sig(v):
    a,b,c,d=v; return (-d,a-d,b-d,c-d)
def spow(v,k):
    for _ in range(k%5): v=sig(v)
    return v
def add(*vs): return tuple(sum(x) for x in zip(*vs))
def scl(k,v): return tuple(k*x for x in v)

def compile_rows(S):
    rows=defaultdict(Counter)
    for i in range(5):
      for p in range(len(S)):
       for q in range(p,len(S)):
        mu=1 if p==q else 2
        for r in range(len(S)):
          g=spow(add(S[p],S[q],sig(S[r]),scl(-1,e2)),i)
          rows[g][tuple(sorted((p,q,r)))]+=mu
    return dict(rows)

def singleton(rows): return any(len(r)==1 for r in rows.values())

def deletion_minimal(S):
    return all(singleton(compile_rows(S[:j]+S[j+1:])) for j in range(len(S)))

def clean_count(rows,n):
    pairs=defaultdict(list)
    for g,r in rows.items():
        if len(r)==2: pairs[frozenset(r)].append((g,r))
    ans=set()
    for gf,f in rows.items():
      if len(f)!=2: continue
      x=list(f)
      for ma,mb in ((x[0],x[1]),(x[1],x[0])):
       ca,cb=Counter(ma),Counter(mb)
       for u in range(n):
        if ca[u]!=2 or cb[u]!=1: continue
        ra=list((ca-Counter({u:2})).elements())
        rb=list((cb-Counter({u:1})).elements())
        if len(ra)!=1 or len(rb)!=2 or rb[0]!=rb[1]: continue
        v,w=ra[0],rb[0]
        for z in range(n):
         if z==u: continue
         m3=tuple(sorted((u,v,z))); m4=tuple(sorted((z,w,w)))
         if m3==m4: continue
         for gg,h in pairs.get(frozenset((m3,m4)),[]):
          if set(h)!={m3,m4}: continue
          D=f[ma]*h[m4]-h[m3]*f[mb]
          if D: ans.add((gf,gg,u,v,w,z,D))
    return len(ans)

def mv(mon,n):
    c=Counter(mon); return tuple(c[i] for i in range(n))

def binomial_data(rows,n):
    eq={}
    for r in rows.values():
      if len(r)!=2: continue
      (m1,c1),(m2,c2)=list(r.items())
      d=tuple(a-b for a,b in zip(mv(m1,n),mv(m2,n)))
      rho=Fraction(-c2,c1)
      if next(x for x in d if x)<0: d=tuple(-x for x in d); rho=1/rho
      eq[(d,rho)]=1
    M=sp.Matrix([d for d,rho in eq])
    D=smith_normal_form(M,domain=ZZ)
    diag=[abs(int(D[i,i])) for i in range(min(D.shape)) if D[i,i]]
    return len(eq),M.rank(),diag

def find(rows,wanted):
    hits=[r for r in rows.values() if dict(r)==wanted]
    assert hits; return hits[0]

def poly(row,n): return Counter({mv(m,n):c for m,c in row.items()})
def mon(n,**kw):
    e=[0]*n
    for k,v in kw.items(): e[int(k[1:])]=v
    return tuple(e)
def mul(P,m,c=1):
    return Counter({tuple(a+b for a,b in zip(e,m)):c*v for e,v in P.items()})
def plus(*Ps):
    R=Counter()
    for P in Ps: R.update(P)
    return Counter({e:c for e,c in R.items() if c})

def verify16(rows):
    assert not singleton(rows) and deletion_minimal(S16)
    assert clean_count(rows,16)==0
    assert binomial_data(rows,16)==(11,11,[1]*11)
    f1=find(rows,{(0,0,8):1,(6,6,15):1})
    f2=find(rows,{(0,0,11):1,(3,6,15):2})
    f3=find(rows,{(0,2,8):2,(6,6,9):1})
    h=find(rows,{(0,2,11):2,(0,4,8):2,(3,6,9):2})
    L=plus(mul(poly(h,16),mon(16,A0=1,A6=1)),
           mul(poly(f2,16),mon(16,A2=1,A6=1),-2),
           mul(poly(f3,16),mon(16,A0=1,A3=1),-2),
           mul(poly(f1,16),mon(16,A2=1,A3=1),4))
    assert L==Counter({mon(16,A0=2,A4=1,A6=1,A8=1):2})

def verify26(rows):
    assert not singleton(rows) and clean_count(rows,26)==0
    assert binomial_data(rows,26)==(6,6,[1]*6)
    B=find(rows,{(7,7,23):1,(23,23,24):1})
    R=find(rows,{(7,7,10):1,(10,23,24):2,(21,23,23):1})
    H=find(rows,{(10,13,24):2,(10,23,25):2,(13,21,23):2})
    L=plus(mul(poly(H,26),mon(26,A23=2)),
           mul(poly(R,26),mon(26,A13=1,A23=1),-2),
           mul(poly(B,26),mon(26,A10=1,A13=1),2))
    assert L==Counter({mon(26,A10=1,A23=3,A25=1):2})

def universal():
    a,b,c,d,e,f,p,q,r=sp.symbols("a b c d e f p q r")
    f00=a*a*p+b*b*q; f10=a*a*r+2*b*c*q
    f01=2*a*d*p+b*b*e; f11=2*a*d*r+2*a*f*p+2*b*c*e
    assert sp.expand(a*b*f11-2*d*b*f10-2*a*c*f01+4*d*c*f00)==2*a*a*b*f*p
    B=a*a*p+p*p*b; R=a*a*c+2*c*p*b+d*p*p
    H=2*c*e*b+2*c*p*f+2*e*d*p
    assert sp.expand(p*p*H-2*e*p*R+2*e*c*B)==2*c*p**3*f

r16=compile_rows(S16); r26=compile_rows(S26)
verify16(r16); verify26(r26); universal()
print("S16 deletion-minimal / cheap filters / four-row certificate: PASS")
print("S26 cheap filters / three-row completion certificate: PASS")
print("F55_COVERAGE_C_ADJUDICATION_OK")
