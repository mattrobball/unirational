"""Section C -- cover/genus arithmetic, exact.

13. E_sigma smooth and j(E_sigma) = 8192/11.
14. E_sigma ∩ K_c is 6 distinct points (exact resultant + exact discriminant).
15. Riemann-Hurwitz / arithmetic-genus consistency for the admissible cover.
"""
import sys, os, json, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sympy import (symbols, sqrt, Rational, expand, simplify, factor, resultant,
                   Poly, groebner, solve, cancel, together, fraction, nsimplify)
from kfield import KE, p_disc, p_deg, p_gcd, p_add, p_scal, p_pow, p_mul, p_deriv
import mpmath as mp

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES, PAY = os.path.join(HERE, "results"), os.path.join(HERE, "payload")
LOG = os.path.join(RES, "checks.log")
_out = []


def record(name, passed, detail=""):
    line = f"CHECK {name} {'PASS' if passed else 'FAIL'}"
    print(line + ("   | " + detail if detail else ""))
    with open(LOG, "a") as f:
        f.write(line + "\n")
    _out.append((name, passed, detail))
    return passed


def blk(fname, text):
    with open(os.path.join(RES, fname), "w") as f:
        f.write(text)


t0 = time.time()
a, b, x = symbols("a b x")
kp = (13 + 3*sqrt(33))/16
km = (13 - 3*sqrt(33))/16
F0 = kp*a**3 + km*b**3 + (a + b)*x**2
conic = x**2 - 4*(a**2 - a*b + b**2)

# ================== 13. E_sigma smooth, j = 8192/11 ====================
# (i) smoothness: the Jacobian ideal has no zero in P^2.
Fa, Fb, Fx = [expand(F0.diff(v)) for v in (a, b, x)]
# Fx = 2(a+b)x = 0  =>  x = 0 or a = -b; handle both branches exactly.
br1 = solve([Fa.subs(x, 0), Fb.subs(x, 0)], [a, b], dict=True)          # x = 0 branch
br2 = solve([expand(Fa.subs(b, -a)), expand(Fb.subs(b, -a))], [a, x], dict=True)  # a=-b branch
# a projective point needs (a,b,x) != (0,0,0)
def nontrivial(sols, extra):
    out = []
    for s in sols:
        vals = {**extra, **s}
        va = simplify(vals.get(a, a)); vb = simplify(vals.get(b, b)); vx = simplify(vals.get(x, x))
        if not (va == 0 and vb == 0 and vx == 0):
            out.append(s)
    return out
sing1 = nontrivial(br1, {x: 0})
sing2 = nontrivial([{a: s.get(a, a), b: -s.get(a, a), x: s.get(x, x)} for s in br2], {})
smooth_sympy = (len(sing1) == 0 and len(sing2) == 0)

# (ii) quartic model on the chart a = 1:  X^2 = -(1+b)(kp + km b^3),  X = x(1+b)
q4 = expand(-(1 + b)*(kp + km*b**3))
P4 = Poly(q4, b)
a0, a1, a2, a3, a4 = [simplify(P4.coeff_monomial(b**k)) for k in (4, 3, 2, 1, 0)]
S = simplify(a0*a4 - a1*a3/4 + a2**2/12)
T = simplify(a0*a2*a4/6 - a0*a3**2/16 - a1**2*a4/16 + a1*a2*a3/48 - a2**3/216)
disc_q = simplify(S**3 - 27*T**2)
j_sigma = simplify(1728*S**3/disc_q)
record("genus_Esigma",
       smooth_sympy and disc_q != 0 and j_sigma == Rational(8192, 11),
       f"Jacobian ideal has no projective zero; S = {S}, T = {T}, "
       f"S^3-27T^2 = {disc_q} != 0, j(E_sigma) = {j_sigma}")

# independent numeric route for j(E_sigma): lambda-invariant of the 4 branch points
mp.mp.dps = 60
kpn, kmn = (13 + 3*mp.sqrt(33))/16, (13 - 3*mp.sqrt(33))/16
rts = mp.polyroots([kmn, kmn, mp.mpf(0), kpn, kpn], maxsteps=300, extraprec=600)
p1, p2, p3, p4 = rts
lam = ((p3 - p1)*(p2 - p4))/((p3 - p4)*(p2 - p1))
j_num = 256*(lam**2 - lam + 1)**3/(lam**2*(lam - 1)**2)
err_s = abs(j_num - mp.mpf(8192)/11)
record("j_Esigma_numeric", err_s < mp.mpf('1e-40'),
       f"lambda-route j(E_sigma) matches 8192/11, abs err = {mp.nstr(err_s, 3)}")

blk("C_Esigma.txt",
    f"F0 = {F0}\npartials: dF/da = {Fa}\n          dF/db = {Fb}\n          dF/dx = {Fx}\n"
    "dF/dx = 2(a+b)x = 0 splits into x = 0 and a = -b:\n"
    f"  x = 0  branch -> 3*kp*a^2 = 3*km*b^2 = 0 -> a = b = 0 (not a projective point). "
    f"nontrivial solutions: {sing1}\n"
    f"  a = -b branch -> 3(kp-km)a^2 = 0 -> a = 0 -> x = 0 (not a point). "
    f"nontrivial solutions: {sing2}\n"
    "=> E_sigma is a SMOOTH plane cubic.\n\n"
    f"quartic model (chart a=1, X = x(1+b)):  X^2 = {q4}\n"
    f"  = -(1+b)(kp + km b^3), roots b = -1 and the three cube roots of -kp/km (all distinct)\n"
    f"binary-quartic invariants: S = {S}   T = {T}\n"
    f"  (both RATIONAL: S = (3/4)*kp*km, T = kp*km*(kp+km)/16 -- j depends only on the\n"
    f"   trace relations kp+km = 13/8, kp*km = -1/2)\n"
    f"S^3 - 27T^2 = {disc_q} = -729*11/65536   <- the 11 enters here\n"
    f"j(E_sigma) = 1728 S^3/(S^3-27T^2) = {j_sigma}\n"
    f"numeric lambda-route: j = {mp.nstr(j_num, 45)}, err vs 8192/11 = {mp.nstr(err_s, 6)}\n")

# ============ 14. six distinct intersection points ====================
# Route (a): exact resultant in x on the chart a = 1 -- eliminates x entirely.
Rx = simplify(factor(resultant(F0.subs(a, 1), conic.subs(a, 1), x)))
claimed = expand(((kp + 4) + (km + 4)*b**3)**2)
res_ok = simplify(expand(Rx - claimed)) == 0
# the b-coordinates are the 3 cube roots of rho = -(kp+4)/(km+4)
rho = simplify(-(kp + 4)/(km + 4))
rho_closed = simplify(rho - (-(283 + 21*sqrt(33))/256))
# distinctness: rho != 0 gives 3 distinct cube roots; x = 0 would need b^2-b+1 = 0 i.e. b^3 = -1,
# and rho != -1 since kp != km.  Hence each of the 3 b's gives 2 distinct x = +-2 sqrt(1-b+b^2).
rho_nonzero = simplify(rho) != 0
rho_not_m1 = simplify(rho + 1) != 0

# Route (b): exact discriminant of P6 over K (parameter side)
Kp, Km = KE(Rational(77, 16), Rational(3, 16)), KE(Rational(77, 16), Rational(-3, 16))
P6 = p_add(p_scal(Kp, p_pow([KE(-4), KE(0), KE(1)], 3)),
           p_scal(KE(-64)*Km, p_pow([KE(1), KE(1)], 3)))
dP6 = p_disc(P6)
g = p_gcd(P6, p_deriv(P6))
sqfree = (p_deg(g) == 0)
# the parameterisation misses only (a:b:x) = (0:1:2), (0:1:-2) on K_c; neither is on E_sigma
off1 = simplify(F0.subs({a: 0, b: 1, x: 2}))
off2 = simplify(F0.subs({a: 0, b: 1, x: -2}))
record("six_intersection_points",
       res_ok and rho_nonzero and rho_not_m1 and (not dP6.is_zero()) and sqfree
       and off1 != 0 and off2 != 0,
       f"Res_x = ((kp+4)+(km+4)b^3)^2 (exact); rho = -(kp+4)/(km+4) != 0, != -1; "
       f"disc(P6) != 0 and gcd(P6,P6') = 1; the 2 points of K_c off the chart are not on "
       f"E_sigma -> exactly 6 distinct points")

blk("C_intersection.txt",
    f"Res_x( F0|a=1 , (x^2-4(1-b+b^2)) )  =  {Rx}\n"
    f"claimed closed form ((kp+4)+(km+4)b^3)^2 : residual = "
    f"{simplify(expand(Rx - claimed))}\n"
    "  (Res of two quadratics in x; the square reflects the tau-pairing x -> -x,\n"
    "   so the 6 points sit over 3 distinct b-values.)\n\n"
    f"rho = -(kp+4)/(km+4) = {rho} = -(283+21*sqrt(33))/256  (residual {rho_closed})\n"
    f"rho numerically = {mp.nstr(mp.mpf(-1)*(kpn+4)/(kmn+4), 30)}\n"
    "b^3 = rho has 3 distinct roots (rho != 0); for each, x^2 = 4(1-b+b^2) has 2 distinct\n"
    "roots because x = 0 would force b^2-b+1 = 0, hence b^3 = -1, but rho != -1 (kp != km).\n"
    "=> |E_sigma ∩ K_c| = 6, transverse.  Bezout: deg 3 * deg 2 = 6 confirms the count.\n\n"
    f"parameter-side confirmation: disc(P6) = {dP6!r}\n"
    f"gcd(P6, P6') has degree {p_deg(g)} (0 = squarefree)\n"
    f"K_c points off the a=1 chart: F0(0,1,2) = {off1}, F0(0,1,-2) = {off2} (both nonzero)\n")

# ==================== 15. Riemann-Hurwitz arithmetic ===================
def genus_double_cover(g_base, r):
    """2 g~ - 2 = 2(2 g - 2) + r  ->  g~"""
    assert r % 2 == 0
    return (2*(2*g_base - 2) + r + 2)//2


def pa_nodal_union(g1, g2, nodes):
    return g1 + g2 + nodes - 1


g_Etilde = genus_double_cover(1, 6)      # double cover of E_sigma branched at the 6 nodes
g_Ktilde = genus_double_cover(0, 6)      # double cover of K_c = P^1 branched at the 6 nodes
pa_D5 = pa_nodal_union(1, 0, 6)          # Delta_5 = E_sigma ∪ K_c
pa_D5_plane = (5 - 1)*(5 - 2)//2         # independent: Delta_5 is a plane quintic
pa_D5t = pa_nodal_union(g_Etilde, g_Ktilde, 6)
prym_dim = pa_D5t - pa_D5
bezout = 3*2

rh = {
    "g(E~) = 4 (double cover of genus-1 branched at 6)": g_Etilde == 4,
    "g(K~) = 2 (double cover of P^1 branched at 6)": g_Ktilde == 2,
    "p_a(Delta_5) = 1+0+6-1 = 6": pa_D5 == 6,
    "p_a(Delta_5) = plane quintic (5-1)(5-2)/2 = 6": pa_D5_plane == 6 and pa_D5 == pa_D5_plane,
    "Bezout 3*2 = 6 nodes": bezout == 6,
    "p_a(Delta~_5) = 4+2+6-1 = 11": pa_D5t == 11,
    "11 = 2*p_a(Delta_5) - 1 = 2*6-1": pa_D5t == 2*pa_D5 - 1,
    "Prym dim = 11 - 6 = 5": prym_dim == 5,
}
record("rh_arithmetic", all(rh.values()),
       "; ".join(f"{k}: {'ok' if v else 'BAD'}" for k, v in rh.items()))

blk("C_rh_arithmetic.txt",
    "Riemann-Hurwitz for a double cover:  2*g~ - 2 = 2*(2g - 2) + r\n"
    f"  base E_sigma, g = 1, r = 6  ->  g(E~) = {g_Etilde}\n"
    f"  base K_c = P^1, g = 0, r = 6 ->  g(K~) = {g_Ktilde}\n\n"
    "arithmetic genus of a nodal union: p_a = g1 + g2 + #nodes - 1\n"
    f"  p_a(Delta_5 = E_sigma ∪ K_c) = 1 + 0 + 6 - 1 = {pa_D5}\n"
    f"  cross-check, Delta_5 is a plane quintic: (5-1)(5-2)/2 = {pa_D5_plane}\n"
    f"  cross-check, #nodes by Bezout: deg(E_sigma)*deg(K_c) = 3*2 = {bezout}\n"
    f"  p_a(Delta~_5) = {g_Etilde} + {g_Ktilde} + 6 - 1 = {pa_D5t}\n"
    f"  consistency: 2*p_a(Delta_5) - 1 = {2*pa_D5 - 1} = {pa_D5t}\n"
    f"  Prym dimension = p_a(Delta~_5) - p_a(Delta_5) = {pa_D5t} - {pa_D5} = {prym_dim}\n\n"
    "NOTE: this is the arithmetic only.  The Prym isogeny decomposition itself\n"
    "(Beauville admissible-cover theory), Kollar's theorem and Roulleau Thm 2 are\n"
    "cited anchors, NOT verified here.\n")

json.dump({
    "j_E_sigma": str(j_sigma), "S_quartic": str(S), "T_quartic": str(T),
    "disc_quartic": str(disc_q),
    "E_sigma_smooth": bool(smooth_sympy),
    "resultant_x": str(Rx),
    "rho": "-(283 + 21*sqrt(33))/256",
    "intersection_points": 6,
    "genus_E_tilde": g_Etilde, "genus_K_tilde": g_Ktilde,
    "pa_Delta5": pa_D5, "pa_Delta5_tilde": pa_D5t, "prym_dimension": prym_dim,
}, open(os.path.join(PAY, "C_covers.json"), "w"), indent=1)

print(f"[section C] {sum(1 for _,p,_ in _out if p)}/{len(_out)} pass, {time.time()-t0:.1f}s")
sys.exit(0 if all(p for _, p, _ in _out) else 1)
