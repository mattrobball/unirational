"""ODDZERO_AUDIT -- the clash and the escape, side by side.

For each (d, m):  the generic section of V((d-m,m),1) (order k=0) versus a
generic section of V0 (order k=1).  At odd d the first is the FORBIDDEN vertex
and the second is the REQUIRED one; at even d it is the other way round.
sec. 5 of THEOREM.md.
"""
import sys, os, random
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('OZ_CACHE', os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), '_cache'))
from sweeps import Sigma
from ozlib import SigmaFrame, nullspace

p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
MAXD = int(sys.argv[2]) if len(sys.argv) > 2 else 11
S = Sigma(p)
m, amb = S.m, S.amb

K0 = m.klein_fours()[0]
z = [x for x in K0 if x != m.Id][0]
fr = SigmaFrame(amb, z)
triv = {g: 1 for g in fr.Gam}


def lift(w):
    x = [sum(fr.Binv[i][j] * w[j] for j in range(5)) % p for i in range(5)]
    return x[:3], x[3:]


def norm(v):
    for t in v:
        if t % p:
            iv = pow(t, p - 2, p)
            return tuple(x * iv % p for x in v)
    return None


# --- the V4 K containing z, its type-I point B_K in W+_z, and the two
#     vertices C_K, D_K in W-_z ; and which one each C2-row over B_K pins.
K = K0
trio = [X for X in m.v4_decomp(K)[1] if len(X) == 1]
B = [X for X in trio if amb.sub(X, m.plus_plane(z))][0]
CD = [X for X in trio if amb.sub(X, m.minus_line(z))]
# identify each of CD by which involution of K it is the +1 eigenline of
inv = {}
for X in CD:
    g = [x for x in K if x != m.Id and amb.scalar_value(x, (), X) == 1][0]
    inv[X] = g
print("pt B_K in P(W+_z);  W-_z contains the two type-I vertices:")
for X in CD:
    print("   %s   = v_%s   (the +1-eigenline of that involution)" %
          (norm(lift(X[0])[1]), "t" if inv[X] != z else "z"))

# the six components of the two (pt_V4I, P_sigma) rows under D_{P_z}
kP = ((m.plus_plane(z),), (m.plus_plane(z), amb.W))
kids = [k for k in S.keys if S.closure_le(k, kP)
        and len(S.H[k]) == 4 and S.dim_of(k) == 1
        and len(k[0][0]) == 1]          # chain (point, plus-plane)
print("\n(pt_V4I, P_sigma) V4-rows under D_{P_z}: %d components" % len(kids))

c2over = {}
for k in kids:
    ptk = k[0][0]
    par = [q for q in S.keys if q[0] and q[0][0] == ptk and len(S.H[q]) == 2
           and S.closure_le(k, q)]
    assert len(par) == 1
    w = [x for x in S.H[par[0]] if x != m.Id][0]
    c2over[k] = w

recs = []
for k in kids:
    Kk = S.H[k]                       # the V4 of THIS component
    triok = [X for X in m.v4_decomp(Kk)[1] if len(X) == 1]
    A0, Alast = k[1][0], k[1][k[0].index(m.plus_plane(z)) + 1]
    u = lift(A0[0])[0]
    v = next(lift(w)[1] for w in Alast if any(t % p for t in lift(w)[1]))
    w2 = c2over[k]
    # arc consistency: value must be on L_z (from D_{P_z}) and on L_{w2}
    # (from the sweeping C2 parent)
    need = None
    for X in triok:
        if amb.sub(X, m.minus_line(z)) and amb.sub(X, m.minus_line(w2)):
            need = norm(lift(X[0])[1])
    recs.append((k, u, v, need))
    print("   comp: attaches at (u=[B_K],v=%s)  C2-parent sweeps L_w  ->"
          " arc consistency needs %s" % (norm(v), need))
assert all(r[3] is not None for r in recs)
alph_of = {}
for (k, u, v, need) in recs:
    alph_of[id(k)] = [lift(w)[0] for w in m.v4_decomp(S.H[k])[1][0]]


def module_and_conds(a, b):
    basis, idx, mu, mv = fr.module(a, b, triv)
    if not basis:
        return None
    rows = []
    for (k, u, v, need) in recs:
        vals = [fr.evaluate(bv, idx, mu, mv, u, v) for bv in basis]
        for c in range(2):
            rows.append([x[c] for x in vals])
    ns = nullspace(p, rows, len(basis))
    return basis, idx, mu, mv, ns


def leading_value(fvec, idx, mu, mv, u, v, alpha, a):
    """the first non-zero coefficient of t in f(u + t*alpha, v), and its order."""
    pts = list(range(a + 1))
    ys = []
    for t in pts:
        uu = [(u[i] + t * alpha[i]) % p for i in range(3)]
        ys.append(fr.evaluate(fvec, idx, mu, mv, uu, v))
    # Newton / Lagrange -> full coefficient list
    coef = [[0, 0] for _ in pts]
    for i, ti in enumerate(pts):
        poly, den = [1], 1
        for j, tj in enumerate(pts):
            if j == i:
                continue
            newp = [0] * (len(poly) + 1)
            for k2, ck in enumerate(poly):
                newp[k2 + 1] = (newp[k2 + 1] + ck) % p
                newp[k2] = (newp[k2] - ck * tj) % p
            poly = newp
            den = den * (ti - tj) % p
        ivd = pow(den % p, p - 2, p)
        for k2 in range(len(poly)):
            for c in range(2):
                coef[k2][c] = (coef[k2][c] + ys[i][c] * poly[k2] % p * ivd) % p
    for k2 in range(len(coef)):
        if any(x % p for x in coef[k2]):
            return k2, norm(tuple(coef[k2]))
    return None, None



print("\n d   m   N(d,m)  dim V0  |  child 1: generic k / value  ->  needed   "
      "|  V0-section: k / value  -> needed")
for d in range(2, MAXD + 1):
    for mm in range(1, d + 1, 2):
        a, b = d - mm, mm
        r = module_and_conds(a, b)
        if r is None:
            continue
        basis, idx, mu, mv, ns = r
        n = len(basis[0])
        rnd = random.Random(9000 + 31 * d + mm)
        alph_basis = alph_of[id(recs[0][0])]
        al = [sum(c * x[t] for c, x in zip([rnd.randrange(1, p) for _ in alph_basis],
                                           alph_basis)) % p for t in range(3)]
        # generic section of the full module
        cs = [rnd.randrange(1, p) for _ in basis]
        fgen = [sum(c * bv[t] for c, bv in zip(cs, basis)) % p for t in range(n)]
        k0, v0 = leading_value(fgen, idx, mu, mv, recs[0][1], recs[0][2], al, a)
        # generic section of V0
        if ns:
            cs2 = [rnd.randrange(1, p) for _ in ns]
            f0 = [0] * n
            for c, sol in zip(cs2, ns):
                comb = [sum(sol[i] * basis[i][t] for i in range(len(basis))) % p
                        for t in range(n)]
                f0 = [(f0[t] + c * comb[t]) % p for t in range(n)]
            k1, v1 = leading_value(f0, idx, mu, mv, recs[0][1], recs[0][2], al, a)
        else:
            k1, v1 = None, None
        need = recs[0][3]
        tag = lambda kk, vv: ("k=%s val=%s %s" % (kk, vv,
                              "OK" if vv == need else "CLASH")) if vv else "-"
        print(" %2d  %2d   %4d     %4d  |  %-28s |  %s"
              % (d, mm, len(basis), len(ns), tag(k0, v0), tag(k1, v1)))
