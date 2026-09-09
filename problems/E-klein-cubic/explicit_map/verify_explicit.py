#!/usr/bin/env python3
"""Exact certificates for the explicit Klein maps (standard library).

The four-copy differential uses dual numbers, not finite differences. The
fixed standard-source minors are exact nonvanishing certificates. Additional
finite-field sample tests are corroboration; universal landing and equivariance
are proved geometrically in the notes.
"""
from __future__ import annotations
import itertools as it, json, math, random, time
from fractions import Fraction as Q
from pathlib import Path
from klein_map import *

class Dual:
    __slots__=('v','d')
    def __init__(self,v,d):self.v,self.d=v,tuple(d)
    def lift(self,w):return w if isinstance(w,Dual) else Dual(w,[0 for _ in self.d])
    def __add__(self,w):
        w=self.lift(w);return Dual(self.v+w.v,[a+b for a,b in zip(self.d,w.d)])
    __radd__=__add__
    def __neg__(self):return Dual(-self.v,[-a for a in self.d])
    def __sub__(self,w):return self+-self.lift(w)
    def __rsub__(self,w):return self.lift(w)+-self
    def __mul__(self,w):
        if isinstance(w,Quadratic):return NotImplemented
        w=self.lift(w);return Dual(self.v*w.v,[a*w.v+self.v*b for a,b in zip(self.d,w.d)])
    __rmul__=__mul__
    def __truediv__(self,w):
        w=self.lift(w)
        return Dual(self.v/w.v,[(a*w.v-self.v*b)/(w.v*w.v) for a,b in zip(self.d,w.d)])
    def __rtruediv__(self,w):return self.lift(w)/self
    def __pow__(self,n):
        if n==0:return self.lift(1)
        return Dual(self.v**n,[n*self.v**(n-1)*a for a in self.d])
    def __eq__(self,w):return self.v==(w.v if isinstance(w,Dual) else w)
    def __repr__(self):return f'Dual({self.v},{self.d})'

class Fp(int):
    p=1000033
    def __new__(cls,v):return int.__new__(cls,int(v)%cls.p)
    def __add__(self,w):return Fp(int(self)+int(w)) if isinstance(w,int) else NotImplemented
    __radd__=__add__
    def __neg__(self):return Fp(-int(self))
    def __sub__(self,w):return Fp(int(self)-int(w)) if isinstance(w,int) else NotImplemented
    def __rsub__(self,w):return Fp(int(w)-int(self)) if isinstance(w,int) else NotImplemented
    def __mul__(self,w):return Fp(int(self)*int(w)) if isinstance(w,int) else NotImplemented
    __rmul__=__mul__
    def __truediv__(self,w):return self*Fp(pow(int(w),-1,self.p)) if isinstance(w,int) else NotImplemented
    def __rtruediv__(self,w):return Fp(w)/self if isinstance(w,int) else NotImplemented
    def __pow__(self,n):return Fp(pow(int(self),n,self.p))

def rref(A):
    A=[list(r) for r in A];piv=[];k=0
    for j in range(len(A[0])):
        z=next((i for i in range(k,len(A)) if A[i][j]!=0),None)
        if z is None:continue
        A[k],A[z]=A[z],A[k];t=A[k][j];A[k]=[x/t for x in A[k]]
        for i in range(len(A)):
            if i!=k:
                t=A[i][j];A[i]=[x-t*y for x,y in zip(A[i],A[k])]
        piv.append(j);k+=1
        if k==len(A):break
    return A,piv

def mm(A,B,p):return tuple(tuple(sum(a*b for a,b in zip(row,col))%p for col in zip(*B)) for row in A)
def mv(A,x,p):return tuple(sum(a*b for a,b in zip(row,x))%p for row in A)
def trans(A):return tuple(zip(*A))
def inv(A,p):
    R,_=rref([[Fp(x) for x in row]+[Fp(i==j) for j in range(len(A))] for i,row in enumerate(A)])
    return tuple(tuple(map(int,row[len(A):])) for row in R)

def generators(p):
    z=next(a for a in range(2,p) if pow(a,11,p)==1)
    gauss=sum(pow(z,j*j%11,p) for j in range(11))%p
    assert (gauss*gauss+11)%p==0
    H=tuple(tuple((1 if i==0 else 2 if j==0 else pow(z,i*j%11,p)+pow(z,-i*j%11,p))%p for j in range(6)) for i in range(6))
    S6=tuple(tuple(x*pow(gauss,-1,p)%p for x in r) for r in H)
    S=[]
    for j in range(5):
        a=matrix([int(i==j) for i in range(5)])
        b=mm(mm(trans(S6),a,p),S6,p)
        x=tuple(v%p for v in (-b[1][2],-b[3][5],-b[2][4],b[1][5],b[3][4]))
        assert tuple(tuple(v%p for v in row) for row in matrix(x))==b
        S.append(x)
    S=trans(S)
    T=tuple(tuple(pow(z,(6,10,2,7,8)[i],p) if i==j else 0 for j in range(5)) for i in range(5))
    E=tuple(tuple(int(i==j) for i in range(5)) for j in range(5));els=[E];seen={E};k=0
    while k<len(els):
        a=els[k];k+=1
        for h in (T,S):
            b=mm(a,h,p)
            if b not in seen:seen.add(b);els.append(b)
        assert len(els)<=660
    assert len(els)==660
    return z,T,S,els

def standard_data(p):
    Fp.p=p;z,T,S,G=generators(p);x=(1,2,3,4,5);ell=x
    inverses=[inv(g,p) for g in G]
    def reynolds(y):
        weights=[pow(sum(a*b for a,b in zip(ell,mv(gi,y,p)))%p,8,p) for gi in inverses]
        return tuple(tuple(sum(c*g[i][j] for c,g in zip(weights,G))%p for j in range(5)) for i in range(5))
    B=reynolds(x)
    Bi=inv(B,p)
    seeds=[mv(Bi,b,p) for b in WITNESS]
    def frame(y):
        R=reynolds(y)
        return [list(mv(R,b,p)) for b in seeds]
    assert frame(x)==[[v%p for v in r] for r in WITNESS]
    _,piv=rref([[Fp(v) for v in row] for row in B]);assert len(piv)==5
    BM=[[Fp(v) for v in row] for row in B];det=Fp(1)
    for j in range(5):
        r=next(i for i in range(j,5) if BM[i][j])
        if r!=j:BM[r],BM[j]=BM[j],BM[r];det=-det
        v=BM[j][j];det=det*v;BM[j]=[t/v for t in BM[j]]
        for i in range(j+1,5):
            v=BM[i][j];BM[i]=[t-v*u for t,u in zip(BM[i],BM[j])]
    return z,T,S,G,inverses,B,seeds,frame,int(det)

def projective(x,p):
    t=next(int(v) for v in x if v);return tuple(int(v)*pow(t,-1,p)%p for v in x)

def main():
    start=time.time();result={}
    r,a=evaluate(WITNESS);assert primitive_integer_point(r)==[3,-2,2,-1,2]
    assert a['pivot_determinant']==1 and a['discriminant']==5
    assert tuple(a['q'])==(1,3,1)
    result['rational_example']={'input':WITNESS,'point':primitive_integer_point(r),'q':[1,3,1],'det':1,
                                 'cofactor_norm':str(a['cofactor_norm'])}
    dv=[[Dual(Q(v),[Q(k==5*i+j) for k in range(20)]) for j,v in enumerate(row)] for i,row in enumerate(WITNESS)]
    dr,_=evaluate_generic(dv,check=False)
    assert klein_form(dr).v==0 and all(t==0 for t in klein_form(dr).d)
    chart=[v/dr[0] for v in dr[1:]];J=[list(v.d) for v in chart]
    _,piv=rref(J);assert len(piv)==3
    minor=det3([[J[i][j] for j in piv] for i in range(3)])
    if minor==0:
        for rows in it.combinations(range(4),3):
            minor=det3([[J[i][j] for j in piv] for i in rows])
            if minor:break
    else:rows=(0,1,2)
    result['differential_Q']={'rank':3,'columns_zero_based':piv,'rows_zero_based':rows,
                             'minor':str(minor),'Jacobian':[[str(t) for t in row] for row in J]}
    print('Exact rational example and rank-three differential: PASS',flush=True)
    assert minor==Q(-221,27)
    p=1000033
    assert all(p%d for d in range(2,math.isqrt(p)+1))
    data=standard_data(p)
    z,T,S,G,inverses,B,seeds,frame,Bdet=data
    assert z==53999 and Bdet==797218
    x=(1,2,3,4,5);ell=x;dframe=[[0]*5 for _ in range(20)]
    for gi,g in zip(inverses,G):
        yy=mv(gi,x,p);weight=sum(a*b for a,b in zip(ell,yy))%p
        ellgi=[sum(ell[k]*gi[k][j] for k in range(5))%p for j in range(5)]
        grad=[8*pow(weight,7,p)*t%p for t in ellgi]
        translates=[mv(g,b,p) for b in seeds]
        for i in range(4):
            for k in range(5):
                for j in range(5):dframe[5*i+k][j]=(dframe[5*i+k][j]+translates[i][k]*grad[j])%p
    Jmod=[[Fp(t.numerator)/Fp(t.denominator) for t in row] for row in J]
    chain=[[sum(Jmod[i][k]*Fp(dframe[k][j]) for k in range(20)) for j in range(5)] for i in range(4)]
    chain=[r[1:] for r in chain];_,cp=rref(chain);assert len(cp)==3
    cminor=0
    for cr in it.combinations(range(4),3):
        cminor=det3([[chain[i][j] for j in cp] for i in cr])
        if cminor:break
    assert int(cminor)==546830
    result['standard_source']={'p':p,'zeta':z,'group_order':660,
        'frame_degree':8,'basepoint':x,'linear_form':ell,'Reynolds_at_basepoint':B,
        'determinant_Reynolds':Bdet,'differential_rank':3,'minor':int(cminor),
        'rows_zero_based':cr,'columns_in_y1_to_y4_zero_based':cp,
        'Jacobian_mod_p':[[int(t) for t in r] for r in chain]}
    print('Degree-eight Reynolds frame and standard-source rank-three differential: PASS',flush=True)
    rng=random.Random(82026);tests=[]
    for n in range(4):
        yy=tuple(rng.randrange(1,p) for _ in range(5));ff=frame(yy)
        try:rr,_=evaluate_generic([[Fp(t) for t in r] for r in ff],check=True)
        except OutsideChart:continue
        for gen in (T,S):
            transformed=frame(mv(gen,yy,p))
            assert transformed==[list(mv(gen,r,p)) for r in ff]
            rt,_=evaluate_generic([[Fp(t) for t in r] for r in transformed],check=True)
            assert projective(rt,p)==projective(mv(gen,rr,p),p)
        tests.append({'input':yy,'point':projective(rr,p)})
    assert tests
    result['standard_source_sample_checks']=tests
    result['seconds']=round(time.time()-start,3)
    Path('verification.json').write_text(json.dumps(result,indent=2)+'\n')
    print('All intermediate Plucker, radical, relation, landing and equivariance checks: PASS')
    print(json.dumps({k:v for k,v in result.items() if k not in ['differential_Q','standard_source_sample_checks']},indent=2))
if __name__=='__main__':main()
