#!/usr/bin/env python3
"""Exact finite checks for the toric and V4 local Rees models."""
from __future__ import annotations
from math import gcd
Vec3=tuple[int,int,int]
Poly=dict[tuple[int,...],int]

def det3(a:Vec3,b:Vec3,c:Vec3)->int:
    return a[0]*(b[1]*c[2]-b[2]*c[1])-b[0]*(a[1]*c[2]-a[2]*c[1])+c[0]*(a[1]*b[2]-a[2]*b[1])

def primitive(v:tuple[int,...])->bool:
    g=0
    for x in v:g=gcd(g,abs(x))
    return g==1

def mon(*e:int)->Poly:return {tuple(e):1}
def mul(p:Poly,q:Poly)->Poly:
    out:Poly={}
    for a,ca in p.items():
        for b,cb in q.items():
            m=tuple(x+y for x,y in zip(a,b));out[m]=out.get(m,0)+ca*cb
    return {m:c for m,c in out.items() if c}
def sub(p:Poly,q:Poly)->Poly:
    out=dict(p)
    for m,c in q.items():
        out[m]=out.get(m,0)-c
        if out[m]==0:del out[m]
    return out
def det2(a:Poly,b:Poly,c:Poly,d:Poly)->Poly:return sub(mul(a,d),mul(b,c))

def main()->None:
    ex,ey,et=(1,0,0),(0,1,0),(0,0,1)
    rS,rT=(1,1,0),(1,1,1)
    cones=((ex,rS,rT),(ey,rS,rT),(ex,rT,et),(ey,rT,et))
    assert all(primitive(v) for v in (ex,ey,et,rS,rT))
    assert [abs(det3(*c)) for c in cones]==[1,1,1,1]
    assert not any(rS in c and et in c for c in cones)
    assert any(rT in c and et in c for c in cones)
    E=((2,0,0),(1,1,0),(0,2,0),(1,0,1),(0,1,1))
    assert min(a+b for a,b,c in E)==1
    assert min(a+b+c for a,b,c in E)==2
    assert tuple(e for e in E if e[2]==0)==((2,0,0),(1,1,0),(0,2,0))
    for m in range(1,13):
        ray=(m,1)
        assert primitive(ray)
        assert abs((1,0)[0]*ray[1]-(1,0)[1]*ray[0])==1
        assert abs(ray[0]*(0,1)[1]-ray[1]*(0,1)[0])==m
    v2,w2=mon(2,0),mon(0,2)
    assert det2(w2,v2,v2,w2)=={(0,4):1,(4,0):-1}
    u2v,u2w,uw,uv=mon(2,1,0),mon(2,0,1),mon(1,0,1),mon(1,1,0)
    assert det2(u2v,u2w,uw,uv)=={(3,2,0):1,(3,0,2):-1}
    print("CT1_TORIC_MODEL=I_(x,y)*(x,y,t)")
    print("CT1_FAN_UNIMODULAR=PASS")
    print("CT1_SEPARATION=r_S_AND_e_t_SHARE_NO_CONE")
    print("RANK_TWO_REES_RAY=(m,1)_PASS")
    print("V4_LINE_DETERMINANT=W^4-V^4")
    print("V4_CONIC_DETERMINANT=u^3*(v^2-w^2)")
    print("LOCAL_REES_EXACT_CHECKS=PASS")

if __name__=="__main__":
    main()
