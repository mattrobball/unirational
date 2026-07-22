#!/usr/bin/env python3
r"""Tangent-residual mechanism on a FULLY UNCONDITIONED random (2,3) form.

Purpose: refute the concern that the codim-4 "conditioning" in
build_explicit_map.py (which only supplies a Q-rational section of the Tsen
surface, so the composite map has rational coefficients) hides anything.
Here NO coefficient is zeroed: all 60 are taken verbatim from /dev/urandom.
There is then no rational point available, so we work where the marked
points actually live: the cubic etale algebra

    K = Q[th] / (g0(th)),    g0(u) = F(x0, (u,1,0)),

whose three roots are the three points of C_{x0} \cap L.  All identities are
verified by exact polynomial reduction mod the FULL cubic g0 -- vanishing
mod g0 proves the statement at all three conjugate marked points at once.

Checks:
  U1  gcd(qU,qV,qW) = 1 for this F (no vertical components in T)
  U2  witness at x0: disc(g0) != 0 (marked points distinct, cubic smooth
      there), covariant line q0 != 0, disc(f0|_{q0=0}) != 0 (three residuals
      distinct), f0(q0 \cap L) != 0 (residuals off L)
  U3  full staged mechanism over K:
       - tangency: coefficients of s^3, s^2 u vanish mod g0
       - residual r in P^2(K): F(x0, r) == 0 mod g0        (r on the cubic)
       - q0(r) == 0 mod g0                    (r on the covariant line)
       - Res(g0, r_W) != 0                    (r off L for ALL three roots)
       - stage 3 chord: x' over K with F(x', r) == 0 mod g0
  U4  fiber over random y0: Res_{x2}(F(x,y0), q_F(x,y0)) squarefree of
      degree 20  (degree of T over P^2_y is 20)

U1-U4 are exactly the load-bearing facts of the construction; none uses the
conditioning.  (What cannot be done over Q without SOME rational point is
only writing the composite parametrization with Q-coefficients -- that is
Tsen non-effectivity over Q, not a gap in the geometry over C.)
"""
import sympy as sp

RAW = [-8, 1, 0, -3, 19, -16, -1, -9, 2, -16, 7, -6, -17, -11, -9, 10, -20,
       -1, 8, -3, -10, -12, -17, 1, -19, -8, 9, -1, 8, -15, -7, -10, -16, 9,
       -6, 18, 6, 16, 0, 14, -13, -8, 3, -1, 16, -20, -8, -7, -11, 10, 6, 9,
       -9, -16, 17, 0, 15, 18, 18, -18]          # /dev/urandom, UNCONDITIONED
Y0 = (3, 13, 19)                                  # spare entropy
x0s, x1s, x2s, U, V, W, th, s, u = sp.symbols('x0 x1 x2 U V W th s u')
XMON = [x0s**2, x0s*x1s, x0s*x2s, x1s**2, x1s*x2s, x2s**2]
YMON = [U**3, U**2*V, U*V**2, V**3, U**2*W, U*V*W, V**2*W, U*W**2, V*W**2, W**3]
F = sp.expand(sum(RAW[10*i + j]*XMON[i]*YMON[j] for i in range(6) for j in range(10)))
print("unconditioned coefficients:", RAW)

# universal covariant q  (independent re-derivation, as in the audit)
a3, a2, a1, a0, b2, b1, b0, ci, cj, ck = sp.symbols('a3 a2 a1 a0 b2 b1 b0 ci cj ck')
uu, vv = sp.symbols('uu vv')
g_uv = a3*uu**3 + a2*uu**2*vv + a1*uu*vv**2 + a0*vv**3
h_uv = b2*uu**2 + b1*uu*vv + b0*vv**2
fU = sp.expand(g_uv.subs({uu: U, vv: V}) + W*h_uv.subs({uu: U, vv: V})
               + W**2*(ci*U + cj*V) + ck*W**3)
P = sp.expand(U*sp.diff(g_uv, uu) + V*sp.diff(g_uv, vv) + W*h_uv)
Rg = sp.expand(sp.resultant(sp.Poly(g_uv.subs(vv, 1), uu), sp.Poly(P.subs(vv, 1), uu)))
Delta = sp.expand(18*a3*a2*a1*a0 - 4*a2**3*a0 + a2**2*a1**2 - 4*a3*a1**3 - 27*a3**2*a0**2)
q_univ = sp.expand(sp.cancel(sp.expand(Rg + Delta*fU)/W**2))
UNIV = [a3, a2, a1, a0, b2, b1, b0, ci, cj, ck]
YIDX = {(3,0,0):0,(2,1,0):1,(1,2,0):2,(0,3,0):3,(2,0,1):4,(1,1,1):5,(0,2,1):6,
        (1,0,2):7,(0,1,2):8,(0,0,3):9}

# ---- U1: primitivity of q_F over Q[x] ----
PFy = sp.Poly(F, U, V, W)
xv = [0]*10
for mono, coef in PFy.terms():
    xv[YIDX[mono]] = sp.expand(coef)
subx = dict(zip(UNIV, xv))
qU_x = sp.expand(q_univ.coeff(U).subs(subx))
qV_x = sp.expand(q_univ.coeff(V).subs(subx))
qW_x = sp.expand(q_univ.coeff(W).subs(subx))
tpar = sp.symbols('tpar')
gcds = []
for line in [{x0s: 1, x1s: tpar, x2s: 3*tpar - 2}, {x0s: tpar, x1s: 1 - 2*tpar, x2s: 1}]:
    gcds.append(sp.gcd(sp.gcd(qU_x.subs(line), qV_x.subs(line)), qW_x.subs(line)))
print("U1 gcd(qU,qV,qW) on two restriction lines:", gcds, "-> primitive:", all(g == 1 for g in gcds))

# ---- U2: witness x0 ----
witness = None
for cand in [(1, 2, 3), (2, -1, 1), (1, 0, 2), (3, 1, -2), (1, 1, 1), (-2, 3, 1)]:
    xd = {x0s: cand[0], x1s: cand[1], x2s: cand[2]}
    f0 = sp.expand(F.subs(xd))
    g0 = sp.Poly(f0.subs({U: th, V: 1, W: 0}), th)
    if g0.degree() != 3:
        continue
    disc_g = sp.discriminant(g0)
    if disc_g == 0:
        continue
    vals = {k: sp.Integer(v.subs(xd)) for k, v in subx.items()}
    q0 = sp.expand(q_univ.subs(vals))
    cU, cV, cW = q0.coeff(U), q0.coeff(V), q0.coeff(W)
    if cU == 0 and cV == 0 and cW == 0:
        continue
    z1 = (-cV, cU, sp.Integer(0)) if (cU != 0 or cV != 0) else (sp.Integer(1), sp.Integer(0), sp.Integer(0))
    z2 = (-cW, sp.Integer(0), cU) if cU != 0 else ((sp.Integer(0), -cW, cV) if cV != 0 else (sp.Integer(0), sp.Integer(1), sp.Integer(0)))
    fline = sp.expand(f0.subs({U: z1[0]*s + z2[0]*u, V: z1[1]*s + z2[1]*u, W: z1[2]*s + z2[2]*u}))
    if sp.Poly(fline, s, u).degree(s) != 3:
        continue
    disc_l = sp.discriminant(sp.Poly(fline.subs(u, 1), s))
    pL = (-cV, cU, sp.Integer(0))
    f_pL = f0.subs({U: pL[0], V: pL[1], W: pL[2]})
    if disc_l != 0 and f_pL != 0:
        witness = (cand, f0, g0, q0, disc_g, disc_l, f_pL)
        break
assert witness, "no witness found among candidates"
cand, f0, g0, q0, disc_g, disc_l, f_pL = witness
print(f"U2 witness x0={cand}: disc(g0)={disc_g}!=0; q0 nonzero; "
      f"disc(f0|q-line)!=0: {disc_l != 0}; residuals off L: {f_pL != 0}")

# ---- U3: staged mechanism over K = Q[th]/(g0) ----
def red(e):
    return sp.rem(sp.expand(e), g0.as_expr(), th)
pstar = (th, sp.Integer(1), sp.Integer(0))
al = red(sp.diff(f0, U).subs({U: th, V: 1, W: 0}))
be = red(sp.diff(f0, V).subs({U: th, V: 1, W: 0}))
ga = red(sp.diff(f0, W).subs({U: th, V: 1, W: 0}))
zst = (ga, sp.Integer(0), -al)
lin = [sp.expand(s*pstar[k] + u*zst[k]) for k in range(3)]
frl = sp.expand(f0.subs({U: lin[0], V: lin[1], W: lin[2]}))
Pl = sp.Poly(frl, s, u)
zero = sp.Integer(0)
c3 = red(Pl.coeff_monomial(s**3) or zero)
c2 = red(Pl.coeff_monomial(s**2*u) or zero)
print("U3 tangency: s^3, s^2u coefficients == 0 mod g0:", c3 == 0, c2 == 0)
A = Pl.coeff_monomial(s*u**2) or zero
B = Pl.coeff_monomial(u**3) or zero
r = tuple(red(B*pstar[k] - A*zst[k]) for k in range(3))
on_cubic = red(f0.subs({U: r[0], V: r[1], W: r[2]}))
on_line  = red(q0.subs({U: r[0], V: r[1], W: r[2]}))
offL = sp.resultant(g0.as_expr(), r[2], th)
print("U3 residual on cubic (F(x0,r)==0 mod g0):", on_cubic == 0)
print("U3 residual on covariant line (q0(r)==0 mod g0):", on_line == 0)
print("U3 Res(g0, r_W) != 0 (off L for all three conjugates):", offL != 0)
d = (sp.Integer(0), sp.Integer(1), sp.Integer(5))
x0v = tuple(sp.Integer(c) for c in cand)
def Q_at(xvv):
    return red(F.subs({U: r[0], V: r[1], W: r[2],
                       x0s: xvv[0], x1s: xvv[1], x2s: xvv[2]}))
Qd = Q_at(d)
Bp = red(Q_at((x0v[0]+d[0], x0v[1]+d[1], x0v[2]+d[2])) - Q_at(x0v) - Qd)
xp = tuple(red(Qd*x0v[k] - Bp*d[k]) for k in range(3))
final = red(F.subs({x0s: xp[0], x1s: xp[1], x2s: xp[2], U: r[0], V: r[1], W: r[2]}))
xp_nz = sp.resultant(g0.as_expr(), xp[0], th) != 0 or sp.resultant(g0.as_expr(), xp[1], th) != 0
print("U3 stage-3 point on X (F(x',r)==0 mod g0):", final == 0, "; x' nondegenerate:", xp_nz)

# ---- U4: degree-20 fiber ----
G10 = sp.expand(Y0[0]*qU_x + Y0[1]*qV_x + Y0[2]*qW_x).subs(x1s, 1)
C2f = sp.expand(F.subs({U: Y0[0], V: Y0[1], W: Y0[2], x1s: 1}))
res1 = sp.Poly(sp.expand(sp.resultant(sp.Poly(C2f, x2s), sp.Poly(G10, x2s))), x0s)
g8 = sp.Poly(sp.gcd(res1, res1.diff(x0s)), x0s)
print("U4 fiber resultant degree:", res1.degree(), "(need 20); squarefree:", g8.degree() == 0)
