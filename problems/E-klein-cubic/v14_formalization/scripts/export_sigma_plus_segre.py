#!/usr/bin/env python3
"""Exact exploratory sigma-plus Segre/plane-cubic certificate over K(i).

Reads the checked exporter results, reconstructs the lift S6=R6^3, splits its
+/-i eigenspaces, and identifies the six-dimensional sigma-plus carrier with a
linear P5 section of Segre P2xP2.

Writes only under --out-dir.  Input JSON files are always read from the
repository root (parent of scripts/).
"""
import argparse
import importlib.util
import json
import hashlib
import sys
from pathlib import Path
from fractions import Fraction

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("snf", str(ROOT / "scripts" / "export_sigma_normal_form.py"))
m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)

# L=K[i], i^2=-1.
LZERO=(m.ZERO,m.ZERO); LONE=(m.ONE,m.ZERO); LI=(m.ZERO,m.ONE)
def la(x,y): return (m.fadd(x[0],y[0]),m.fadd(x[1],y[1]))
def ln(x): return (m.fneg(x[0]),m.fneg(x[1]))
def ls(x,y): return la(x,ln(y))
def lm(x,y): return (m.fsub(m.fmul(x[0],y[0]),m.fmul(x[1],y[1])),m.fadd(m.fmul(x[0],y[1]),m.fmul(x[1],y[0])))
def lz(x): return m.fisz(x[0]) and m.fisz(x[1])
def li(x):
    d=m.fadd(m.fmul(x[0],x[0]),m.fmul(x[1],x[1]))
    di=m.finv(d)
    return (m.fmul(x[0],di),m.fneg(m.fmul(x[1],di)))
def ld(n): return (m.frac(n),m.ZERO)
def lser(x): return {"re":m.fser(x[0]),"im":m.fser(x[1])}
def ldes(x): return (m.fdeser(x["re"]),m.fdeser(x["im"]))

def M(A): return tuple(tuple(x for x in r) for r in A)
def eye(n): return M([[LONE if i==j else LZERO for j in range(n)] for i in range(n)])
def mm(A,B):
    return M([[sumL([lm(A[i][k],B[k][j]) for k in range(len(B))]) for j in range(len(B[0]))] for i in range(len(A))])
def sumL(xs):
    s=LZERO
    for x in xs:s=la(s,x)
    return s
def madd(A,B): return M([[la(A[i][j],B[i][j]) for j in range(len(A[0]))] for i in range(len(A))])
def mscale(c,A): return M([[lm(c,x) for x in r] for r in A])
def tr(A): return M(list(zip(*A)))
def augment(A,B): return M([list(A[i])+list(B[i]) for i in range(len(A))])
def rref(A):
    A=[list(r) for r in A]; nr=len(A); nc=len(A[0]); piv=[]; rr=0
    for c in range(nc):
        p=next((i for i in range(rr,nr) if not lz(A[i][c])),None)
        if p is None: continue
        A[rr],A[p]=A[p],A[rr]
        inv=li(A[rr][c]); A[rr]=[lm(inv,x) for x in A[rr]]
        for i in range(nr):
            if i!=rr and not lz(A[i][c]):
                q=A[i][c]; A[i]=[ls(A[i][j],lm(q,A[rr][j])) for j in range(nc)]
        piv.append(c); rr+=1
        if rr==nr: break
    return M(A),piv
def inv(A):
    n=len(A); R,p=rref(augment(A,eye(n)))
    assert p==list(range(n))
    return M([r[n:] for r in R])
def col_basis(A):
    _,p=rref(tr(A))
    return M([[A[i][j] for j in p] for i in range(len(A))])
def null_left(A):
    # rows n with n*A=0 = nullspace(A^T)
    AT=tr(A); R,p=rref(AT); n=len(AT[0]); free=[j for j in range(n) if j not in p]
    out=[]
    for f in free:
        v=[LZERO]*n; v[f]=LONE
        for row,pc in reversed(list(enumerate(p))):
            v[pc]=ln(sumL([lm(R[row][j],v[j]) for j in free]))
        out.append(v)
    return M(out)
def eq(A,B): return A==B

def liftK(A): return M([[(x,m.ZERO) for x in r] for r in A])
def serMat(A): return [[lser(x) for x in r] for r in A]

def lam2(A):
    ps=list(m.combinations(range(len(A)),2))
    return M([[ls(lm(A[i][k],A[j][l]),lm(A[i][l],A[j][k])) for (k,l) in ps] for (i,j) in ps])

# Symmetric quadrics use exporter monomial order i<=j.
mons=m.monoms(6)
def quadrow(q): return tuple((q.get(ij,m.ZERO),m.ZERO) for ij in mons)
def linprod(a,b):
    vals=[]
    for i,j in mons:
        vals.append(lm(a[i],b[j]) if i==j else la(lm(a[i],b[j]),lm(a[j],b[i])))
    return tuple(vals)
def solve_coeff(basis_rows,target):
    # Find c with c*basis=target.  Solve basis^T c=target^T.
    A=M([list(r) for r in zip(*basis_rows)])
    Aug=M([list(A[i])+[target[i]] for i in range(len(A))])
    R,p=rref(Aug); n=len(basis_rows)
    assert not any(all(lz(R[i][j]) for j in range(n)) and not lz(R[i][n]) for i in range(len(R)))
    c=[LZERO]*n
    for row,pc in enumerate(p):
        if pc<n:c[pc]=R[row][n]
    recon=tuple(sumL([lm(c[k],basis_rows[k][j]) for k in range(n)]) for j in range(len(target)))
    assert recon==target
    return tuple(c)

parser = argparse.ArgumentParser()
parser.add_argument("--out-dir", type=Path, required=True,
                    help="Directory that will receive every generated file")
args = parser.parse_args()
OUT = args.out_dir.resolve()
OUT.mkdir(parents=True, exist_ok=True)

D12_JSON = ROOT / "results" / "d12_lean_K.json"
SIGMA_JSON = ROOT / "results" / "sigma_normal_form_K.json"
with open(D12_JSON) as f:d12=json.load(f)
with open(SIGMA_JSON) as f:sn=json.load(f)
R6=liftK(m.mat_deser(d12["operators"]["R6x6"]))
S6=mm(mm(R6,R6),R6)
assert mm(S6,S6)==mscale(ld(-1),eye(6))

# Projectors (I - iS)/2 and (I + iS)/2.
PA=mscale((m.frac(1,2),m.ZERO),madd(eye(6),mscale(ln(LI),S6)))
PB=mscale((m.frac(1,2),m.ZERO),madd(eye(6),mscale(LI,S6)))
A=col_basis(PA); B=col_basis(PB)
assert len(A[0])==len(B[0])==3
W=M([list(A[i])+list(B[i]) for i in range(6)]); Wi=inv(W)

Bplus=liftK(m.mat_deser(sn["eigenspaces"]["Bplus_15x6"]))
Lplus=liftK(m.mat_deser(sn["eigenspaces"]["Lplus_6x15"]))
LamWi=lam2(Wi)
cross=[k for k,p in enumerate(m.combinations(range(6),2)) if p[0]<3 and p[1]>=3]
H=M([[mm(LamWi,Bplus)[k][j] for j in range(6)] for k in cross])
assert len(H)==9
N=null_left(H); assert len(N)==3

# Complete [L;N] with first six inverse columns H.
# Any left inverse works; row-reduction solve each e_j against H^T.
L=[]
for j in range(6):
    ej=tuple(LONE if k==j else LZERO for k in range(6))
    L.append(solve_coeff(tuple(H),ej))
L=M(L)
assert mm(L,H)==eye(6) and mm(N,H)==M([[LZERO]*6 for _ in range(3)])
T=M(list(L)+list(N)); Ti=inv(T)
assert M([list(r[:6]) for r in Ti])==H
assert mm(H,L)==M([list(r[:]) for r in mm(H,L)])

# Nine 2x2 minors of the 3x3 matrix z_ab=(Hx)_3a+b.
minor_meta=[]; minor_rows=[]
for a0,a1 in m.combinations(range(3),2):
  for b0,b1 in m.combinations(range(3),2):
    minor_meta.append([a0,a1,b0,b1])
    minor_rows.append(linprod(H[3*a0+b0],H[3*a1+b1]))
    minor_rows[-1]=tuple(ls(minor_rows[-1][j],linprod(H[3*a0+b1],H[3*a1+b0])[j]) for j in range(21))
Q=[quadrow(m.deser_quad(q)) for q in sn["restricted_plucker"]["plus_15_quadrics"]]
Q_from_min=[solve_coeff(tuple(minor_rows),q) for q in Q]
min_from_Q=[solve_coeff(tuple(Q),q) for q in minor_rows]

# The 3 bilinear equations N*(u tensor v)=0.  For fixed u, A(u)v=0.
# Store their 3x3 coefficient tensors and determinant cubic coefficients.
Ct=[[[N[r][3*a+b] for b in range(3)] for a in range(3)] for r in range(3)]
cubmons=[]
for a in range(3):
  for b in range(a,3):
    for c in range(b,3):cubmons.append((a,b,c))
def perm_sign(p):
    invs=sum(p[i]>p[j] for i in range(3) for j in range(i+1,3))
    return -1 if invs%2 else 1
import itertools
Fc={u:LZERO for u in cubmons}
for p in itertools.permutations(range(3)):
  sg=ld(perm_sign(p))
  for a0 in range(3):
   for a1 in range(3):
    for a2 in range(3):
      mon=tuple(sorted((a0,a1,a2)))
      term=lm(sg,lm(Ct[0][a0][p[0]],lm(Ct[1][a1][p[1]],Ct[2][a2][p[2]])))
      Fc[mon]=la(Fc[mon],term)
assert any(not lz(x) for x in Fc.values())

out={
 "schema":"v14.fix_ix.sigma_plus_segre.v1",
 "inputs":{"d12_sha256":hashlib.sha256(D12_JSON.read_bytes()).hexdigest(),"sigma_sha256":hashlib.sha256(SIGMA_JSON.read_bytes()).hexdigest()},
 "field":{"base":"Q(zeta_11)","extension":"L=K[i], i^2+1=0"},
 "S6":serMat(S6),"eigenbasis_plus_i_A":serMat(A),"eigenbasis_minus_i_B":serMat(B),"W":serMat(W),"Winv":serMat(Wi),
 "cross_coordinate_H_9x6":serMat(H),"left_inverse_L_6x9":serMat(L),"annihilator_N_3x9":serMat(N),"completion_T_stack_L_N":serMat(T),"completion_T_inv":serMat(Ti),
 "segree_minors":{"order":minor_meta,"quadrics":[[lser(x) for x in q] for q in minor_rows]},
 "span_witnesses":{"Qplus_eq_U_times_minors":[[lser(x) for x in r] for r in Q_from_min],"minors_eq_V_times_Qplus":[[lser(x) for x in r] for r in min_from_Q]},
 "bidegree_11_equations":{"tensor_C_r_a_b":[[[lser(x) for x in rr] for rr in r] for r in Ct]},
 "plane_cubic_F_u":{"monomial_order":[list(x) for x in cubmons],"coefficients":[lser(Fc[x]) for x in cubmons]},
 "checks":{"S6_sq_negI":True,"dims_3_3":True,"L_H_I6":True,"N_H_0":True,"T_invertible":True,"Tinv_first6cols_H":True,"nine_minors_span_equals_fifteen_restricted_pluckers":True,"plane_cubic_nonzero":True},
 "scope":"Exact Segre/plane-cubic carrier certificate over K(i); smoothness and Weierstrass reduction not yet certified. This is not a Veronese GL6 certificate."
}
raw=json.dumps(out,sort_keys=True,separators=(",",":"))
out["payload_sha256"]=hashlib.sha256(raw.encode()).hexdigest()
json_path = OUT / "sigma_plus_segre_Ki.json"
with open(json_path,"w") as f:json.dump(out,f,sort_keys=True,separators=(",",":"))
def km2(a):
    terms=[]
    for j,c in enumerate(a):
        if c:
            q=f"({c.numerator}/{c.denominator})"
            terms.append(q if j==0 else q+f"*z^{j}")
    return "+".join(terms) if terms else "0"
def lm2(a):
    ar,ai=km2(a[0]),km2(a[1])
    return f"({ar})+({ai})*iw"
smooth_path = OUT / "sigma_plus_smooth.m2"
with open(smooth_path,"w") as f:
    f.write("K=toField(QQ[z]/(z^10+z^9+z^8+z^7+z^6+z^5+z^4+z^3+z^2+z+1));\n")
    f.write("iw=symbol iw; L=toField(K[iw]/(iw^2+1));\n")
    f.write("R=L[U,V,W];\n")
    vs=["U","V","W"]
    terms=[]
    for mon in cubmons:
        c=Fc[mon]
        if lz(c): continue
        powers=[mon.count(i) for i in range(3)]
        mm="*".join(vs[i]+(f"^{powers[i]}" if powers[i]>1 else "") for i in range(3) if powers[i])
        terms.append(f"({lm2(c)})*{mm}")
    f.write("F="+"+".join(terms)+";\n")
    f.write("J=ideal(diff(U,F),diff(V,F),diff(W,F));\n")
    f.write('<< "F=" << F << endl;\n')
    f.write("JU=J+ideal(U-1); JV=J+ideal(V-1); JW=J+ideal(W-1);\n")
    f.write("uok=(1_R % gens gb JU == 0_R);\n")
    f.write("vok=(1_R % gens gb JV == 0_R);\n")
    f.write("wok=(1_R % gens gb JW == 0_R);\n")
    f.write("assert(uok and vok and wok);\n")
    f.write("CU=1_R // gens JU; CV=1_R // gens JV; CW=1_R // gens JW;\n")
    f.write("assert(gens JU*CU==matrix{{1_R}}); assert(gens JV*CV==matrix{{1_R}}); assert(gens JW*CW==matrix{{1_R}});\n")
    f.write('<< "chart_smooth=" << {uok,vok,wok} << endl;\n')
    f.write('<< "smooth=" << (uok and vok and wok) << endl;\n')
    f.write('<< "CU=" << CU << endl << "CV=" << CV << endl << "CW=" << CW << endl;\n')
# A good split-prime reduction is a certificate that the characteristic-zero
# cubic discriminant is nonzero.  p=89 is 1 mod 44, hence contains zeta_11,i.
p=89
zr=next(a for a in range(2,p) if pow(a,11,p)==1 and a!=1)
ir=next(a for a in range(2,p) if (a*a+1)%p==0)
def modpK(a):
    return sum((c.numerator%p)*pow(c.denominator,-1,p)*pow(zr,j,p) for j,c in enumerate(a))%p
def modpL(a): return (modpK(a[0])+ir*modpK(a[1]))%p
mod89_path = OUT / "sigma_plus_smooth_mod89.m2"
with open(mod89_path,"w") as f:
    f.write("R=ZZ/89[U,V,W];\n")
    vs=["U","V","W"]; terms=[]
    for mon in cubmons:
        cc=modpL(Fc[mon])
        if not cc: continue
        powers=[mon.count(i) for i in range(3)]
        mm="*".join(vs[i]+(f"^{powers[i]}" if powers[i]>1 else "") for i in range(3) if powers[i])
        terms.append(f"{cc}*{mm}")
    f.write("F="+"+".join(terms)+";\n")
    f.write("J=ideal(diff(U,F),diff(V,F),diff(W,F));\n")
    f.write("JU=J+ideal(U-1); JV=J+ideal(V-1); JW=J+ideal(W-1);\n")
    f.write("uok=(1_R % gens gb JU == 0_R);\n")
    f.write("vok=(1_R % gens gb JV == 0_R);\n")
    f.write("wok=(1_R % gens gb JW == 0_R);\n")
    f.write("assert(uok and vok and wok);\n")
    f.write("CU=1_R // gens JU; CV=1_R // gens JV; CW=1_R // gens JW;\n")
    f.write("assert(gens JU*CU==matrix{{1_R}}); assert(gens JV*CV==matrix{{1_R}}); assert(gens JW*CW==matrix{{1_R}});\n")
    f.write(f'<< "zroot={zr} iroot={ir} F=" << F << endl;\n')
    f.write('<< "chart_smooth=" << {uok,vok,wok} << endl;\n')
    f.write('<< "smooth=" << (uok and vok and wok) << endl;\n')
    f.write('<< "CU=" << CU << endl << "CV=" << CV << endl << "CW=" << CW << endl;\n')
def file_sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()

print("OK",len(raw),out["payload_sha256"])
print("F nonzero terms",sum(not lz(x) for x in Fc.values()))
print("payload_sha256", out["payload_sha256"])
print("json_sha256", file_sha(json_path))
print("smooth_sha256", file_sha(smooth_path))
print("mod89_sha256", file_sha(mod89_path))
print("d12_sha256", file_sha(D12_JSON))
print("sigma_sha256", file_sha(SIGMA_JSON))
print("out_dir", OUT)
