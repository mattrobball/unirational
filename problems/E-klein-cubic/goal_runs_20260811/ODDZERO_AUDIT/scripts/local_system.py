"""ODDZERO_AUDIT -- the decisive local system over one type-I V4 point.

Prints, for each of the six V4 components over pt = [B]:
  * its divisor parent (D_{P_z} / D_{L-_s} / D_{L-_r}),
  * its sweeping C2 parent,
  * the value ARC CONSISTENCY forces on it (L_z cap L_w),
  * and what the divisor row's OWN sections evaluate to, by degree d.
The odd-d rows are the clash; sec. 3 of THEOREM.md.
"""
import sys, os, pickle, random
from collections import defaultdict
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
os.environ.setdefault('OZ_CACHE', os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), '_cache'))
from sweeps import Sigma
from ozlib import SigmaFrame

p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
MAXD = int(sys.argv[2]) if len(sys.argv) > 2 else 12
S = Sigma(p)
m, amb = S.m, S.amb
W = amb.W

K0 = m.klein_fours()[0]
_, (A4, B4, C4, D4) = m.v4_decomp(K0)
z, s_, r_ = [x for x in K0 if x != m.Id]
NM = {z: 'z', s_: 's', r_: 'r'}
PTLAB = {A4: 'A', B4: 'B', C4: 'C', D4: 'D'}
pt = B4
print("K0 = {1,z,s,r};  pt = [B] = the z-plus type-I vertex")
for nm, X in (('A', A4), ('B', B4), ('C', C4), ('D', D4)):
    print("   %s : dim %d" % (nm, len(X)))
for g in (z, s_, r_):
    print("   W+_%s = A + %s      W-_%s = %s + %s" % (
        NM[g],
        'B' if amb.scalar_value(g, (), B4) == 1 else ('C' if amb.scalar_value(g, (), C4) == 1 else 'D'),
        NM[g],
        *[nm for nm, X in (('B', B4), ('C', C4), ('D', D4))
          if amb.scalar_value(g, (), X) != 1]))

frames = {g: SigmaFrame(amb, g) for g in (z, s_, r_)}


def label_pt(vec5):
    v = tuple(vec5)
    for nm, X in (('A', A4), ('B', B4), ('C', C4), ('D', D4)):
        if amb.sub((v,), X):
            return nm
    return str(v)


def lift(fr, w):
    """(u,v) coordinates of an ambient vector in fr's sigma-adapted frame."""
    x = [sum(fr.Binv[i][j] * w[j] for j in range(5)) % p for i in range(5)]
    return x[:3], x[3:]


def unlift(fr, uv):
    u, v = uv
    x = list(u) + list(v)
    return tuple(sum(fr.B[i][j] * x[j] for j in range(5)) % p for i in range(5))


def evaluate_component(g, kt, kd, a, b):
    """value of child kd under the sweep component kt (a divisor for the
    involution g), computed from EXPLICIT sections of multidegree (a on the
    W+ slot, b on the W- slot), psi = 1.   Returns an ambient point of P(W)."""
    fr = frames[g]
    triv = {x: 1 for x in fr.Gam}
    basis, idx, mu, mv = fr.module(a, b, triv)
    if not basis:
        return "EMPTY"
    U, A = kd
    Ut, = kt[0]
    j = U.index(Ut)
    A0, Alast = A[0], A[j + 1]
    # the W+ coordinate locus and the W- coordinate locus of the attaching pt
    if len(Ut) == 3:                     # D_P : A0 inside W+, Alast/W+ in W-
        upool = [lift(fr, w)[0] for w in A0]
        vv = next(lift(fr, w)[1] for w in Alast if any(t % p for t in lift(fr, w)[1]))
    else:                                # D_L : A0 inside W-, Alast/W- in W+
        vv = [lift(fr, w)[1] for w in A0]
        assert len(vv) == 1
        vv = vv[0]
        upool = [lift(fr, w)[0] for w in Alast if any(t % p for t in lift(fr, w)[0])]
    rnd = random.Random(777)
    seen = set()
    for _ in range(3):
        if len(upool) == 1:
            u = upool[0]
        else:
            cs = [rnd.randrange(1, p) for _ in upool]
            u = [sum(c * x[t] for c, x in zip(cs, upool)) % p for t in range(3)]
        vals = [fr.evaluate(bv, idx, mu, mv, u, vv) for bv in basis]
        nz = [x for x in vals if any(t % p for t in x)]
        if not nz:
            seen.add("DEGEN"); continue
        R = m.canon([list(x) + [0, 0, 0] for x in nz])
        assert len(R) == 1, "rigidity failure"
        seen.add(label_pt(unlift(fr, (( 0, 0, 0), nz[0]))))
    assert len(seen) == 1, seen
    return seen.pop()


kP_z = ((m.plus_plane(z),), (m.plus_plane(z), W))
kL_s = ((m.minus_line(s_),), (m.minus_line(s_), W))
kL_r = ((m.minus_line(r_),), (m.minus_line(r_), W))

over = [k for k in S.keys if k[0] and k[0][0] == pt]
v4comps = [k for k in over if len(S.H[k]) == 4]
c2comps = [k for k in over if len(S.H[k]) == 2]

print("\n--- the six V4 components over pt, their divisor parent, their C2 parent,")
print("--- and the value ARC CONSISTENCY forces on them ---")
rows = []
for k in sorted(v4comps, key=lambda k: -S.dim_of(k)):
    oid = S.orbit_of[S.index[k]]
    dpar = [(nm, kk) for nm, kk in (("P_z", kP_z), ("L_s", kL_s), ("L_r", kL_r))
            if S.closure_le(k, kk)]
    cpar = [kk for kk in c2comps if S.closure_le(k, kk)]
    cw = []
    for kk in cpar:
        w = [x for x in S.H[kk] if x != m.Id][0]
        cw.append(NM[w])
    # arc consistency: the value must lie on L_g for every divisor/C2 parent
    lines = []
    for nm, _ in dpar:
        lines.append(nm[0] == 'P' and NM[z] or nm[-1])
    lines = [nm[-1] for nm, _ in dpar] + cw
    cand = []
    for lb, X in (('B', B4), ('C', C4), ('D', D4)):
        ok = True
        for ln in lines:
            g = {'z': z, 's': s_, 'r': r_}[ln]
            if not amb.sub(X, m.minus_line(g)):
                ok = False
        if ok:
            cand.append(lb)
    rows.append((k, oid, dpar, cw, cand))
    print("  oid=%2d dim=%d  divisor parent=%s  C2 parent sweeps L_%s  -> forced value %s"
          % (oid, S.dim_of(k), [nm for nm, _ in dpar], "".join(cw), cand))

print("\n--- what the divisor row's OWN sections evaluate to, by degree d ---")
for d in range(1, MAXD + 1):
    out = []
    for k, oid, dpar, cw, cand in rows:
        nm, kk = dpar[0]
        if nm == "P_z":
            vals = {evaluate_component(z, kk, k, d - mm, mm)
                    for mm in range(1, d + 1, 2)}
        else:
            g = s_ if nm == "L_s" else r_
            # (a',b') = (nu, d-nu) with d-nu odd
            vals = {evaluate_component(g, kk, k, nu, d - nu)
                    for nu in range(0, d + 1) if (d - nu) % 2 == 1}
        ok = all(v in cand for v in vals)
        out.append("oid%d[%s]%s%s" % (oid, nm, "".join(sorted(vals)),
                                      "" if ok else "  <-- CLASH(need %s)" % cand))
    print("  d=%2d : %s" % (d, "  ".join(out)))
