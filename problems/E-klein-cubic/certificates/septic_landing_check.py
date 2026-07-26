"""Exact four-point Groebner exclusion for degree-7 self-covariants."""
import math
import sympy as s

A,B,C,D=s.symbols('A B C D')
pars=(A,B,C,D)

Kparams=[(0,0,0,6,1),(0,0,1,0,6),(0,0,2,5,0),(0,1,1,2,3),
 (0,1,3,1,2),(0,1,5,0,1),(0,2,1,4,0),(0,3,0,1,3),(0,3,2,0,2),
 (0,4,0,3,0),(1,0,0,4,2),(1,0,2,3,1),(1,0,4,2,0),(1,1,1,0,4),
 (1,2,1,2,1),(1,2,3,1,0),(1,4,0,1,1),(1,4,2,0,0),(2,0,0,2,3),
 (2,0,2,1,2),(2,0,4,0,1),(2,1,0,4,0),(2,2,1,0,2),(3,0,0,0,4),
 (3,1,0,2,1),(3,1,2,1,0),(3,3,1,0,0),(4,1,0,0,2),(5,0,1,1,0),
 (5,2,0,0,0)]
Kco=[0,-1,-1,-4,0,-2,-1,-4,2,-1,0,0,3,-16,28,0,-18,0,-6,22,
 -11,-10,16,3,20,12,-8,-9,-12,4]

def F(x):return sum(x[i]**2*x[(i+1)%5] for i in range(5))
def q(x):return [2*x[i]*x[(i+1)%5]+x[(i-1)%5]**2 for i in range(5)]
def covC(x):
    y=q(x);return [2*y[i]*y[(i+1)%5]+y[(i-1)%5]**2 for i in range(5)]
def J(x):
    y=q(x);z=covC(x);return sum(y[i]*z[i] for i in range(5))//3
def K0(x):
    return sum(c*math.prod(x[i]**e[i] for i in range(5))
               for e,c in zip(Kparams,Kco))
def covK(x):return [K0(tuple(x[(j+i)%5] for j in range(5))) for i in range(5)]
def equation(x):
    fx=F(x);cx=covC(x);kx=covK(x);jx=J(x)
    y=[A*kx[i]+B*fx*cx[i]+(C*fx*fx+D*jx)*x[i] for i in range(5)]
    return s.Poly(s.expand(F(y)),*pars,domain=s.QQ).as_expr()

points=[(-1,2,-2,0,-2),(1,1,1,1,-1),(-2,1,-2,1,1),(2,-2,1,0,-1)]

if __name__=='__main__':
    equations=[equation(x) for x in points]
    for v in pars:
        variables=tuple(w for w in pars if w!=v)
        G=s.groebner([f.subs(v,1) for f in equations],*variables,order='grevlex',domain=s.QQ)
        assert G.contains(s.Integer(1))
    print(points)
    print('PASS every projective chart A=1,B=1,C=1,D=1 has Groebner basis [1]')
