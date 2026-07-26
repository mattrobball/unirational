"""Exact Q(zeta_11) checks for the 5-dimensional Klein representation."""
from fractions import Fraction as Q
from itertools import product

N=10

class C:
    __slots__=('a',)
    def __init__(self,a=0):
        if isinstance(a,C): self.a=a.a
        elif isinstance(a,(int,Q)): self.a=(Q(a),)+(Q(0),)*(N-1)
        else:
            aa=[Q(x) for x in a]+[Q(0)]*N
            # reduce by Phi_11=1+z+...+z^10
            for k in range(len(aa)-1,N-1,-1):
                q=aa[k]
                if q:
                    for j in range(10): aa[k-10+j]-=q
            self.a=tuple(aa[:N])
    def __add__(self,b):
        b=C(b);return C([x+y for x,y in zip(self.a,b.a)])
    __radd__=__add__
    def __neg__(self):return C([-x for x in self.a])
    def __sub__(self,b):return self+(-C(b))
    def __rsub__(self,b):return C(b)-self
    def __mul__(self,b):
        b=C(b);v=[Q(0)]*19
        for i,x in enumerate(self.a):
            for j,y in enumerate(b.a):v[i+j]+=x*y
        return C(v)
    __rmul__=__mul__
    def __truediv__(self,n):return C([x/Q(n) for x in self.a])
    def __pow__(self,n):
        r=C(1);a=self
        while n:
            if n&1:r=r*a
            a=a*a;n//=2
        return r
    def __eq__(self,b):return self.a==C(b).a
    def __repr__(self):return str(self.a)

z=C([0,1]); zp=[z**i for i in range(11)]
qr={1,3,4,5,9}
g=sum((1 if a in qr else -1)*zp[a] for a in range(1,11))
assert g*g == -11

js=[1,3,2,5,4]; signs=[1,1,-1,1,1]
S=[[Q(signs[k],signs[i])*(zp[(9*j*l)%11]-zp[(-9*j*l)%11])*(-g)/11
    for k,l in enumerate(js)] for i,j in enumerate(js)]
T=[[zp[(js[i]*js[i])%11] if i==j else C(0) for j in range(5)] for i in range(5)]
I=[[C(i==j) for j in range(5)] for i in range(5)]

def matmul(A,B):
    return [[sum(A[i][k]*B[k][j] for k in range(5)) for j in range(5)] for i in range(5)]
def mpow(A,n):
    R=I
    while n:
        if n&1:R=matmul(R,A)
        A=matmul(A,A);n//=2
    return R

assert mpow(S,2)==I
assert mpow(T,11)==I
assert mpow(matmul(S,T),3)==I

# P = S T^3 S T^4 S T^3 is the five-cycle v_i -> v_(i+1).
P=matmul(matmul(matmul(matmul(matmul(S,mpow(T,3)),S),mpow(T,4)),S),mpow(T,3))
Pexpected=[[C(1 if i==(j+1)%5 else 0) for j in range(5)] for i in range(5)]
assert P==Pexpected and mpow(P,5)==I

def pmul(A,B):
    out={}
    for ea,ca in A.items():
        for eb,cb in B.items():
            e=tuple(a+b for a,b in zip(ea,eb))
            out[e]=out.get(e,C(0))+ca*cb
    return {e:c for e,c in out.items() if c!=0}
def ppow(A,n):
    R={(0,0,0,0,0):C(1)}
    for _ in range(n):R=pmul(R,A)
    return R
def padd(A,B):
    out=dict(A)
    for e,c in B.items():out[e]=out.get(e,C(0))+c
    return {e:c for e,c in out.items() if c!=0}

def transformed_F(A):
    L=[]
    for i in range(5):
        L.append({tuple(1 if j==k else 0 for j in range(5)):A[i][k]
                  for k in range(5) if A[i][k]!=0})
    out={}
    for i in range(5):out=padd(out,pmul(ppow(L[i],2),L[(i+1)%5]))
    return out

F={tuple(2 if j==i else 1 if j==(i+1)%5 else 0 for j in range(5)):C(1)
   for i in range(5)}
assert transformed_F(S)==F
assert transformed_F(T)==F
assert transformed_F(P)==F

# Exhaustive exact Cayley-graph consistency against PSL_2(F_11).
from collections import deque
def fmul(A,B):
    return tuple(sum(A[2*i+k]*B[2*k+j] for k in range(2))%11
                 for i in range(2) for j in range(2))
def fcanon(A):
    A=tuple(a%11 for a in A);B=tuple((-a)%11 for a in A)
    return min(A,B)
fone=fcanon((1,0,0,1));fs=fcanon((0,2,5,0));ft=fcanon((1,2,0,1))
rho={fone:I};queue=deque([fone])
while queue:
    a=queue.popleft()
    for b,R in ((fs,S),(ft,T)):
        c=fcanon(fmul(a,b));M=matmul(rho[a],R)
        if c in rho: assert rho[c]==M
        else: rho[c]=M;queue.append(c)
assert len(rho)==660

print('PASS g^2=-11')
print('PASS S^2=T^11=(ST)^3=1')
print('PASS ST^3ST^4ST^3=P, P^5=1')
print('PASS F(Sx)=F(Tx)=F(Px)=F(x) exactly in Q(zeta_11)')
print('PASS exact Cayley consistency on all 660 elements of PSL_2(F_11)')
