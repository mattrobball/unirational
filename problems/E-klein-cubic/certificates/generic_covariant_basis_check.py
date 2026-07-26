#!/usr/bin/env python3
"""Exact witness that x,C,D,E,K frame the generic twisted 5-space.

The covariants have respective degrees 1, 4, 5, 6, and 7.  Their determinant
is therefore a degree-23 invariant.  One nonzero integer evaluation proves
that it is not the zero polynomial, hence the five descended vectors form a
basis over C(W)^G on the generic torsor.
"""

from itertools import product
import math
import sympy as s

from septic_landing_check import covC, covK


D0co={
 (0,0,2,0,3):-5,(0,1,0,3,1):-5,(0,3,1,1,0):5,(0,5,0,0,0):-1,
 (1,1,0,1,2):10,(1,1,2,0,1):-5,(2,0,1,2,0):-5,(2,2,0,1,0):-5,
 (3,0,1,0,1):5}
Eparams=[(0,0,1,3,2),(0,0,3,2,1),(0,0,5,1,0),(0,1,0,0,5),
 (0,2,0,2,2),(0,2,2,1,1),(0,2,4,0,0),(0,4,1,0,1),
 (1,0,1,1,3),(1,0,3,0,2),(1,1,1,3,0),(1,2,0,0,3),
 (1,3,0,2,0),(2,1,1,1,1),(2,1,3,0,0),(2,3,0,0,1),
 (3,0,0,3,0),(4,0,0,1,1),(4,0,2,0,0)]
Eco=[-2,1,0,1,3,3,-1,-1,0,0,4,2,1,0,3,-3,-1,-1,0]


def monomial(x,e):return math.prod(x[i]**e[i] for i in range(5))
def cyclic_covariant(x,terms):
    terms=tuple(terms)
    def p0(y):return sum(c*monomial(y,e) for e,c in terms)
    return [p0(tuple(x[(j+i)%5] for j in range(5))) for i in range(5)]
def covD(x):return cyclic_covariant(x,D0co.items())
def covE(x):return cyclic_covariant(x,tuple(zip(Eparams,Eco)))
def determinant(x):
    columns=[list(x),covC(x),covD(x),covE(x),covK(x)]
    return int(s.det(s.Matrix.hstack(*(s.Matrix(v) for v in columns))))


def main():
    # First lexicographic nonzero witness in {-2,-1,0,1,2}^5.
    witness=None
    for x in product((-2,-1,0,1,2),repeat=5):
        if x!=(0,0,0,0,0):
            value=determinant(x)
            if value:
                witness=(x,value);break
    assert witness == ((-2,-2,-2,-2,-1),-295136920)
    print('witness =',witness[0])
    print('det[x,C,D,E,K] =',witness[1])
    print('columns =')
    x=witness[0]
    for name,v in zip(('x','C','D','E','K'),(x,covC(x),covD(x),covE(x),covK(x))):
        print(name,'=',v)
    print('PASS determinant polynomial is nonzero over Z')


if __name__=='__main__':
    main()
