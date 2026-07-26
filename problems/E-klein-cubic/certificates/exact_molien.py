"""Exact class-character and Hironaka-series computation."""
exec(open(__file__.replace('exact_molien.py','exact_weil_check.py')).read().split("print('PASS")[0])

from math import comb

D=100

def inv_series(den):
    # den[0]=1; coefficients of 1/den through D
    h=[Q(0)]*(D+1);h[0]=Q(1)
    for n in range(1,D+1):
        h[n]=-sum((den[k] if k<len(den) else 0)*h[n-k]
                  for k in range(1,min(n,len(den)-1)+1))
    return h

def polymul(a,b):
    c=[Q(0)]*(len(a)+len(b)-1)
    for i,x in enumerate(a):
        for j,y in enumerate(b):c[i+j]+=x*y
    return c

d1=polymul(polymul([1,-1],[1,-1]),polymul(polymul([1,-1],[1,-1]),[1,-1]))
d2=polymul(polymul(polymul([1,-1],[1,-1]),[1,-1]),polymul([1,1],[1,1]))
d3=polymul([1,-1],polymul([1,1,1],[1,1,1]))
d5=[1,0,0,0,0,-1]
d6=[1,-1,1,-1,1,-1]
h1,h2,h3,h5,h6=map(inv_series,[d1,d2,d3,d5,d6])

def complete(eigs):
    h=[C(0)]*(D+1);h[0]=C(1)
    for a in eigs:
        new=[C(0)]*(D+1);pw=C(1)
        for k in range(D+1):
            for n in range(D+1-k):new[n+k]=new[n+k]+h[n]*pw
            pw=pw*a
        h=new
    return h

hq=complete([zp[a] for a in sorted(qr)])
hn=complete([zp[a] for a in range(1,11) if a not in qr])
lam=sum(zp[a] for a in qr);lambar=sum(zp[a] for a in range(1,11) if a not in qr)

cov=[];invs=[]
for d in range(D+1):
    m=(C(5*h1[d]+55*h2[d]-110*h3[d]+110*h6[d])
       +60*lambar*hq[d]+60*lam*hn[d])/660
    iv=(C(h1[d]+55*h2[d]+110*h3[d]+264*h5[d]+110*h6[d])
        +60*hq[d]+60*hn[d])/660
    assert all(x.denominator==1 for x in m.a+iv.a)
    assert all(x==0 for x in m.a[1:]+iv.a[1:])
    cov.append(int(m.a[0]));invs.append(int(iv.a[0]))

assert cov[:14]==[0,1,0,0,2,1,2,4,5,6,10,12,16,21]
assert invs[:14]==[1,0,0,1,0,1,2,1,2,3,3,4,6,5]
print('d  self-covariants  invariants')
for d in range(14):print(f'{d:2d} {cov[d]:16d} {invs[d]:11d}')
print('PASS exact class average')

# Cohen--Macaulay numerator over Adler's hsop degrees 3,5,6,8,11.
num=cov[:]
for e in (3,5,6,8,11):
    num=[num[d]-(num[d-e] if d>=e else 0) for d in range(len(num))]
support=[(d,a) for d,a in enumerate(num) if a]
print('covariant hsop numerator:',support)
assert all(a>0 for d,a in support)
assert sum(a for d,a in support)==60

invnum=invs[:]
for e in (3,5,6,8,11):
    invnum=[invnum[d]-(invnum[d-e] if d>=e else 0)
            for d in range(len(invnum))]
invsupport=[(d,a) for d,a in enumerate(invnum) if a]
assert invsupport==[
    (0,1),(7,1),(9,1),(10,1),(12,1),(14,2),
    (16,1),(18,1),(19,1),(21,1),(28,1),
]
assert sum(a for d,a in invsupport)==12

# Formal series division H_M/H_R=P_M/P_R.  A negative coefficient proves
# that M cannot be a free graded module over the full invariant ring R.
quotient=[]
for d in range(30):
    value=num[d]-sum(invnum[e]*quotient[d-e]
                     for e in range(1,d+1))
    quotient.append(value)
assert quotient[:18]==[
    0,1,0,0,1,1,1,1,3,2,3,2,4,1,2,-2,-2,-5,
]
print('invariant hsop numerator:',invsupport)
print('rank_A(R)=12 rank_A(M)=60 rank_R(M)=5')
print('H_M/H_R through degree 29:',quotient)
print('PASS exact Hironaka numerators and non-freeness over R')
