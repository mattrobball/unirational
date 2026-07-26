"""Exact formulas through degree 7, landing witnesses, and a generic frame."""
exec(open(__file__.replace('exact_covariants_check.py','exact_weil_check.py')).read().split("print('PASS")[0])

from itertools import permutations

def shift_exp(e,i): return tuple(e[(j-i)%5] for j in range(5))
def cyclic_vector(p0):
    return [{shift_exp(e,i):c for e,c in p0.items()} for i in range(5)]
def pscale(p,c):return {e:C(c)*a for e,a in p.items() if C(c)*a!=0}
def compose(p,A):
    L=[]
    for i in range(5):
        L.append({tuple(1 if j==k else 0 for j in range(5)):A[i][k]
                  for k in range(5) if A[i][k]!=0})
    out={}
    for e,c in p.items():
        term={(0,0,0,0,0):c}
        for i,n in enumerate(e):term=pmul(term,ppow(L[i],n))
        out=padd(out,term)
    return out
def lincomb(cs,ps):
    out={}
    for c,p in zip(cs,ps):out=padd(out,pscale(p,c))
    return out
def check_cov(V,A):
    return all(compose(V[i],A)==lincomb(A[i],V) for i in range(5))
def evalp(p,x):
    return sum(c*Cprod(xi**ei for xi,ei in zip(x,e)) for e,c in p.items())
def Cprod(xs):
    r=C(1)
    for x in xs:r=r*x
    return r
def evalv(V,x):return [evalp(p,x) for p in V]
def evalF(x):return sum(x[i]*x[i]*x[(i+1)%5] for i in range(5))

# Quartic C = grad(F_dual)(grad(F)); C0 coefficients.
C0={(0,0,0,4,0):1,(0,1,1,0,2):4,(1,0,0,2,1):4,
    (1,0,2,1,0):0,(1,2,1,0,0):8,(2,0,0,0,2):6,(3,1,0,0,0):4}
C0={e:C(c) for e,c in C0.items() if c}
CV=cyclic_vector(C0)
assert check_cov(CV,S) and check_cov(CV,T) and check_cov(CV,P)

# Unique quintic self-covariant D, normalized integrally.
D0co={
 (0,0,2,0,3):-5,(0,1,0,3,1):-5,(0,3,1,1,0):5,(0,5,0,0,0):-1,
 (1,1,0,1,2):10,(1,1,2,0,1):-5,(2,0,1,2,0):-5,(2,2,0,1,0):-5,
 (3,0,1,0,1):5}
DV=cyclic_vector({e:C(c) for e,c in D0co.items()})
assert check_cov(DV,S) and check_cov(DV,T) and check_cov(DV,P)

# Sextic basis: H*x and E. Here H=det Hess(F)/32.
H0co={(3,0,2,0,0):1,(3,0,0,1,1):-1,(2,0,0,3,0):1,
 (1,3,0,0,1):-1,(1,1,3,0,0):-1,(1,1,1,1,1):3,
 (0,3,0,2,0):1,(0,2,0,0,3):1,(0,1,1,3,0):-1,
 (0,0,3,0,2):1,(0,0,1,1,3):-1}
H={e:C(c) for e,c in H0co.items()}
xpol=[{tuple(1 if j==i else 0 for j in range(5)):C(1)} for i in range(5)]
Hx=[pmul(H,p) for p in xpol]
assert check_cov(Hx,S) and check_cov(Hx,T) and check_cov(Hx,P)

Eparams=[(0,0,1,3,2),(0,0,3,2,1),(0,0,5,1,0),(0,1,0,0,5),
 (0,2,0,2,2),(0,2,2,1,1),(0,2,4,0,0),(0,4,1,0,1),
 (1,0,1,1,3),(1,0,3,0,2),(1,1,1,3,0),(1,2,0,0,3),
 (1,3,0,2,0),(2,1,1,1,1),(2,1,3,0,0),(2,3,0,0,1),
 (3,0,0,3,0),(4,0,0,1,1),(4,0,2,0,0)]
Eco=[-2,1,0,1,3,3,-1,-1,0,0,4,2,1,0,3,-3,-1,-1,0]
EV=cyclic_vector({e:C(c) for e,c in zip(Eparams,Eco) if c})
assert check_cov(EV,S) and check_cov(EV,T) and check_cov(EV,P)

# Primitive septic K; together with F*C, F^2*x and J*x it spans degree 7.
Kparams=[(0,0,0,6,1),(0,0,1,0,6),(0,0,2,5,0),(0,1,1,2,3),
 (0,1,3,1,2),(0,1,5,0,1),(0,2,1,4,0),(0,3,0,1,3),(0,3,2,0,2),
 (0,4,0,3,0),(1,0,0,4,2),(1,0,2,3,1),(1,0,4,2,0),(1,1,1,0,4),
 (1,2,1,2,1),(1,2,3,1,0),(1,4,0,1,1),(1,4,2,0,0),(2,0,0,2,3),
 (2,0,2,1,2),(2,0,4,0,1),(2,1,0,4,0),(2,2,1,0,2),(3,0,0,0,4),
 (3,1,0,2,1),(3,1,2,1,0),(3,3,1,0,0),(4,1,0,0,2),(5,0,1,1,0),
 (5,2,0,0,0)]
Kco=[0,-1,-1,-4,0,-2,-1,-4,2,-1,0,0,3,-16,28,0,-18,0,-6,22,
 -11,-10,16,3,20,12,-8,-9,-12,4]
KV=cyclic_vector({e:C(c) for e,c in zip(Kparams,Kco) if c})
assert all(sum(e[i]*[1,9,4,3,5][i] for i in range(5))%11==1
           for e in KV[0])
assert check_cov(KV,S)

# Exact witnesses for non-landing; together with exact dimensions, these exclude d<=6.
x4=[C(a) for a in (1,1,-1,0,0)]
assert evalF(x4)==0 and evalF(evalv(CV,x4))==50
x5=[C(-1)]*5
assert evalF(evalv(DV,x5))==1080
x6=[C(a) for a in (-2,-2,-2,0,0)]
assert evalp(H,x6)==0 and evalF(evalv(EV,x6))==-786432

# The five primitive covariants form a basis over C(W).  Equivariance then
# makes this an explicit Hilbert--90 frame for the generic twisted W.
frame_point=[C(a) for a in (-2,-2,-2,-2,-1)]
frame_columns=[evalv(V,frame_point) for V in (xpol,CV,DV,EV,KV)]
frame_det=C(0)
for permutation in permutations(range(5)):
    inversions=sum(permutation[i]>permutation[j]
                   for i in range(5) for j in range(i+1,5))
    term=Cprod(frame_columns[column][permutation[column]]
               for column in range(5))
    frame_det=frame_det+(-term if inversions%2 else term)
assert frame_det==-295136920

print('PASS C,D,Hx,E equivariant under exact S,T,P')
print('PASS quartic witness F=0, F(C)=50')
print('PASS quintic witness F(D)=1080')
print('PASS sextic witness H=0, F(E)=-786432')
print('PASS primitive septic K equivariant under exact S,T,P')
print('PASS det[x,C,D,E,K](-2,-2,-2,-2,-1)=-295136920')
