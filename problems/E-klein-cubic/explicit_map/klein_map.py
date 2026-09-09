#!/usr/bin/env python3
"""Evaluate an explicit rational map (Q^5)^4 ---> the Klein cubic.

The implementation uses only the Python standard library and exact arithmetic.
The map is specified by a fixed determinantal chart; OutsideChart is not a
nonexistence verdict. See the accompanying LaTeX notes for its intrinsic,
PSL(2,11)-equivariant interpretation and proof of dominance.

CLI: python klein_map.py                  # exact worked example
     python klein_map.py input.json       # four rows of five rational entries
Rational entries may be integers or strings such as "3/7".
"""
from __future__ import annotations
import itertools
import json
import math
import sys
from fractions import Fraction
from typing import Any, Sequence

TRIPLES = tuple(itertools.combinations(range(6), 3))
INDEX = {v: i for i, v in enumerate(TRIPLES)}
WITNESS = ((1,1,0,0,1),(0,1,-1,1,0),(-1,-1,1,-1,-1),(-1,1,-1,0,0))

class OutsideChart(ValueError):
    """The input lies outside the stated fixed chart of the rational map."""

def klein_form(x: Sequence[Any]) -> Any:
    return sum(x[i]*x[i]*x[(i+1)%5] for i in range(5))

def polar_derivative(v: Sequence[Any], u: Sequence[Any]) -> Any:
    """dF_v(u), the coefficient of s*t^2 in F(s*u+t*v)."""
    return sum((2*v[i]*v[(i+1)%5]+v[(i-1)%5]**2)*u[i] for i in range(5))

def matrix(x: Sequence[Any]) -> list[list[Any]]:
    if len(x)!=5:
        raise ValueError('A Klein coordinate vector has five entries.')
    a,b,c,d,e=x
    zero=0*a
    return [[zero,-b,-d,-c,-a,-e], [b,zero,-a,zero,zero,d],
            [d,a,zero,zero,-c,zero], [c,zero,zero,zero,e,-b],
            [a,zero,c,-e,zero,zero], [e,-d,zero,b,zero,zero]]

def contract(A: Sequence[Sequence[Any]]) -> list[list[Any]]:
    zero=0*A[0][1]
    C=[[zero for _ in range(20)] for _ in range(6)]
    for n,(i,j,k) in enumerate(TRIPLES):
        C[i][n]=A[j][k]
        C[j][n]=-A[i][k]
        C[k][n]=A[i][j]
    return C

def solve_square(A: Sequence[Sequence[Any]], B: Sequence[Sequence[Any]]):
    """Exact Gauss elimination: return A^{-1}B and det(A)."""
    n=len(A)
    rows=[list(a)+list(b) for a,b in zip(A,B)]
    determinant=1+0*A[0][0]
    for j in range(n):
        k=next((i for i in range(j,n) if rows[i][j]!=0),None)
        if k is None:
            raise OutsideChart('The first 18 contraction columns are singular.')
        if k!=j:
            rows[j],rows[k]=rows[k],rows[j]
            determinant=-determinant
        pivot=rows[j][j]
        determinant=determinant*pivot
        rows[j]=[v/pivot for v in rows[j]]
        for i in range(n):
            if i==j:continue
            t=rows[i][j]
            rows[i]=[v-t*w for v,w in zip(rows[i],rows[j])]
    return [r[n:] for r in rows],determinant

class Quadratic:
    """a+b*z in K[z]/(z^2+B*z+C); a scalar extension, not a chosen root."""
    __slots__=('a','b','B','C')
    def __init__(self,a,b,B,C): self.a,self.b,self.B,self.C=a,b,B,C
    def lift(self,v):
        if isinstance(v,Quadratic):return v
        return Quadratic(v,0*v,self.B,self.C)
    def __add__(self,v):
        v=self.lift(v);return Quadratic(self.a+v.a,self.b+v.b,self.B,self.C)
    __radd__=__add__
    def __neg__(self):return Quadratic(-self.a,-self.b,self.B,self.C)
    def __sub__(self,v):return self+-self.lift(v)
    def __rsub__(self,v):return self.lift(v)+-self
    def __mul__(self,v):
        v=self.lift(v)
        return Quadratic(self.a*v.a-self.C*self.b*v.b,
                         self.a*v.b+self.b*v.a-self.B*self.b*v.b,self.B,self.C)
    __rmul__=__mul__
    def conjugate(self):return Quadratic(self.a-self.B*self.b,-self.b,self.B,self.C)
    def norm(self):return self.a*self.a-self.B*self.a*self.b+self.C*self.b*self.b
    def inverse(self):
        n=self.norm()
        if n==0:raise OutsideChart('The selected quadratic-algebra element is not a unit.')
        t=self.conjugate()
        return Quadratic(t.a/n,t.b/n,self.B,self.C)
    def __truediv__(self,v):return self*self.lift(v).inverse()
    def __rtruediv__(self,v):return self.lift(v)*self.inverse()
    def __pow__(self,n):
        if n<0:return self.inverse()**(-n)
        r=self.lift(1);a=self
        while n:
            if n%2:r=r*a
            a=a*a;n//=2
        return r
    def __eq__(self,v):
        v=self.lift(v);return self.a==v.a and self.b==v.b
    def __repr__(self):return f'({self.a})+({self.b})*z'

def det3(A):
    a,b,c=A
    return a[0]*(b[1]*c[2]-b[2]*c[1])-a[1]*(b[0]*c[2]-b[2]*c[0])+a[2]*(b[0]*c[1]-b[1]*c[0])

def triple_coordinate(w,I):
    if len(set(I))<3:return 0*w[0]
    sign=(-1)**sum(I[i]>I[j] for i in range(3) for j in range(i+1,3))
    return sign*w[INDEX[tuple(sorted(I))]]

def evaluate_generic(inputs: Sequence[Sequence[Any]], check: bool=True):
    """The fixed formula over any exact field-like coefficient type.

    Returns a homogeneous five-vector and diagnostic scalars. No root is chosen.
    The `check` path also verifies all restricted Plucker equations, the four-column
    kernel identity, the intermediate Pfaffian zero, and the final Klein zero.
    """
    if len(inputs)!=4 or any(len(v)!=5 for v in inputs):
        raise ValueError('Expected four vectors of length five.')
    A=[matrix(v) for v in inputs]
    C=sum((contract(a) for a in A[:3]),[])
    uv,det=solve_square([r[:18] for r in C],[[-r[18],-r[19]] for r in C])
    zero=0*det;one=1+zero
    w0=[r[0] for r in uv]+[one,zero]
    w1=[r[1] for r in uv]+[zero,one]
    def prod(i,j):
        i,j=INDEX[i],INDEX[j]
        return (w0[i]*w0[j],w0[i]*w1[j]+w1[i]*w0[j],w1[i]*w1[j])
    polys=[prod((0,1,2),(0,3,4)),prod((0,1,3),(0,2,4)),prod((0,1,4),(0,2,3))]
    q0,q1,q2=[polys[0][i]-polys[1][i]+polys[2][i] for i in range(3)]
    if q2==0:raise OutsideChart('The selected Plucker relation has zero z^2 coefficient.')
    B,D=q1/q2,q0/q2
    discriminant=B*B-4*D
    if discriminant==0:raise OutsideChart('The isotropic quadratic pencil is ramified.')
    w=[Quadratic(a,b,B,D) for a,b in zip(w0,w1)]
    if check:
        for I in itertools.combinations(range(6),2):
            for J in itertools.combinations(range(6),4):
                value=sum((-1)**j*triple_coordinate(w,I+(k,))*triple_coordinate(w,J[:j]+J[j+1:]) for j,k in enumerate(J))
                if value!=0:raise OutsideChart('The kernel pencil does not have the specified degree-two Plucker scheme.')
    rad=[sum(c*x for c,x in zip(row,w)) for row in contract(A[3])]
    columns=[[sum(A[j][i][k]*rad[k] for k in range(6)) for j in range(4)] for i in range(6)]
    cof=[(-1)**j*det3([[columns[i][k] for k in range(4) if k!=j] for i in range(3)]) for j in range(4)]
    cofactor_norm=cof[1].norm()
    xs=[x/cof[1] for x in cof]
    if check and any(sum(row[i]*xs[i] for i in range(4))!=0 for row in columns):
        raise OutsideChart('The selected three-row cofactor is not the full relation.')
    Y=[sum(xs[i]*inputs[i][j] for i in range(4)) for j in range(5)]
    if check and klein_form(Y)!=0:raise ArithmeticError('Intermediate Pfaffian identity failed.')
    V=[y.b for y in Y]
    U=[y.a-B*y.b/2 for y in Y]
    f=klein_form(V);polar=polar_derivative(V,U)
    R=[f*u-polar*v for u,v in zip(U,V)]
    if all(x==0 for x in R):raise OutsideChart('The secant residual formula vanishes on this input.')
    if check and klein_form(R)!=0:raise ArithmeticError('Final Klein identity failed.')
    return R,{'pivot_determinant':det,'q':(D,B,one),'discriminant':discriminant,
              'cofactor_norm':cofactor_norm,'w0':w0,'w1':w1,'radical':rad,
              'cofactors':cof,'relation':xs,'Y':Y,'U':U,'V':V,'F_V':f,'dF_V_U':polar}

def evaluate(inputs: Sequence[Sequence[Any]],check:bool=True):
    """Evaluate over Q. All inputs are converted to fractions."""
    return evaluate_generic([[Fraction(x) for x in row] for row in inputs],check)

def primitive_integer_point(x):
    den=math.lcm(*(v.denominator for v in x))
    a=[int(v*den) for v in x];g=math.gcd(*a)
    a=[v//g for v in a]
    if next(v for v in a if v)!=abs(next(v for v in a if v)):a=[-v for v in a]
    return a

def main():
    if len(sys.argv)>2:raise SystemExit('Usage: python klein_map.py [input.json]')
    inputs=WITNESS
    if len(sys.argv)==2:
        with open(sys.argv[1],encoding='utf8') as f:inputs=json.load(f)
    try:
        R,a=evaluate(inputs)
    except (ValueError,ZeroDivisionError) as e:raise SystemExit(str(e)) from e
    point=primitive_integer_point(R)
    print(json.dumps({'input':inputs,'point':point,'Klein_value':int(klein_form(point)),
                      'pivot_determinant':str(a['pivot_determinant']),
                      'quadratic_coefficients_constant_first':[str(x) for x in a['q']],
                      'discriminant':str(a['discriminant'])},indent=2))
if __name__=='__main__':main()
