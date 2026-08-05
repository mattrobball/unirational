import sys, subprocess, itertools
sys.path.insert(0,'/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_fa02f05/FIX_N2B_M1_ROW')
import n2b_lib as L, modular as MD
from n2b_lib import ONE
p, omp, kpp = MD.P, MD.OMP, MD.KPP
om = omp; om2 = om*om % p
b = L.Block(7,1,ONE); N = b.n
idx = {n:i for i,n in enumerate(b.names)}
def pmul(A,B):
    o={}
    for ka,va in A.items():
        for kb,vb in B.items():
            k=tuple(x+y for x,y in zip(ka,kb)); o[k]=(o.get(k,0)+va*vb)%p
    return {k:v for k,v in o.items() if v}
def padd(*Ps):
    o={}
    for A in Ps:
        for k,v in A.items(): o[k]=(o.get(k,0)+v)%p
    return {k:v for k,v in o.items() if v}
def scal(A,c): return {k:v*c%p for k,v in A.items() if v*c%p}
def mono(**kw):
    e=[0]*N
    for k,v in kw.items(): e[idx[k]]=v
    return tuple(e)
def subst(t,var,expr):
    i=idx[var]; out={}
    for k,v in t.items():
        e=k[i]
        base=list(k); base[i]=0
        term={tuple(base):v}
        for _ in range(e): term=pmul(term,expr)
        out=padd(out,term)
    return out
i5=idx['B5']
E=[]
for pc in L.equations(b, orbit_reduce=False):
    t={}
    for pm,c in pc.items():
        cc=L.kmod_p(c,p,omp,kpp)
        if cc==0: continue
        key=list(pm); key[i5]=0; key=tuple(key)
        t[key]=(t.get(key,0)+cc)%p
    t={k:v for k,v in t.items() if v}
    if t: E.append(t)
P0e=padd({mono(B1=1,B8=1):(-om)%p},{mono(R0=1):(-om2)%p})
B0e=padd({mono(B8=1,R0=1):(1-om2)%p},{mono(B1=1,B8=2):om2%p})
E=[subst(subst(t,'P0',P0e),'B0',B0e) for t in E]
E=[t for t in E if t]
# find an equation linear in R1 with a CONSTANT coefficient, and solve for R1
iR1=idx['R1']
best=None
for t in E:
    lin={}; rest={}
    ok=True
    for k,v in t.items():
        if k[iR1]==0: rest[k]=v
        elif k[iR1]==1:
            kk=list(k); kk[iR1]=0; lin[tuple(kk)]=v
        else: ok=False; break
    if ok and lin and len(lin)==1 and list(lin.keys())[0]==tuple([0]*N):
        best=(lin,rest); break
assert best, 'no unit-coefficient equation in R1'
c=list(best[0].values())[0]
R1e=scal(best[1], (-pow(c,p-2,p))%p)
E=[subst(t,'R1',R1e) for t in E]
E=[t for t in E if t]
keep=[n for n in b.names if n not in ('B5','P0','B0','R1')]
ki=[idx[n] for n in keep]
def s(t):
    return '+'.join('%d%s'%(v,''.join('*%s^%d'%(keep[j],k[i]) if k[i]>1 else '*%s'%keep[j]
                    for j,i in enumerate(ki) if k[i])) for k,v in sorted(t.items()))
src='%s\n%d\n%s\n'%(','.join(keep),p,',\n'.join(s(t) for t in E))
inp='/Users/worker/unirational/problems/E-klein-cubic/goal_runs_after_fa02f05/FIX_N2B_M1_ROW/msolve/elim2_r7_one_B5.ms'
open(inp,'w').write(src)
print('vars',keep,'#eqs',len(E),'maxdeg',max(sum(k) for t in E for k in t))
out=inp[:-3]+'.out'
subprocess.run(['/opt/homebrew/bin/msolve','-t','4','-f',inp,'-o',out],timeout=4000)
print(open(out).read()[:2000])
