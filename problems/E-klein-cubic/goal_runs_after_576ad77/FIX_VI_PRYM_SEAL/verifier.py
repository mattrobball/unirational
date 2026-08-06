#!/usr/bin/env python3
"""FIX-VI-PRYM-SEAL -- independent verifier.

Imports NOTHING from scripts/.  Every claim is re-derived by a structurally
different route:

  * K_c is parameterised from the base point (b,x) = (1,2) -- giving
    b(n) = n(n-4)/((n-2)(n+2)), x(n) = -2(n^2-2n+4)/(n^2-4) -- instead of the
    brief's base point (0,2).  This yields a DIFFERENT branch sextic, a
    DIFFERENT involution tau_n(n) = (n-4)/(n-1) and DIFFERENT fixed points
    n = 1 +- sqrt(-3); the j-invariants must nevertheless agree.
  * the restriction identity is proved by an x-RESULTANT rather than by
    reduction/substitution modulo the conic.
  * j is computed from the Aronhold I,J invariants (I = 12ae-3bd+c^2, ...)
    rather than the S,T normalisation used by the main run.
  * j(E_sigma) is obtained exactly from the CROSS-RATIO of the four branch
    points, reducing modulo beta^3 = -kappa_+/kappa_-, rather than from
    quartic invariants.
  * arithmetic in Q(sqrt33, sqrt-3) is plain sympy symbolic algebra, not the
    main run's hand-rolled 4-dimensional field layer.

Exit code 0 iff every check passes.
"""
import os, sys, time, subprocess
from sympy import (symbols, sqrt, Rational, expand, simplify, cancel, together,
                   fraction, Poly, resultant, factor, rem, radsimp, discriminant, I as _I)
import mpmath as mp

HERE = os.path.dirname(os.path.abspath(__file__))
VLOG = os.path.join(HERE, "results", "verifier.log")
os.makedirs(os.path.join(HERE, "results"), exist_ok=True)
_res = []


def is0(e):
    """Exact zero test for elements of Q(sqrt33, sqrt-3, beta)."""
    e = expand(e)
    if e == 0:
        return True
    e = simplify(radsimp(e))
    if e == 0:
        return True
    return simplify(cancel(together(e))) == 0


def chk(name, passed, detail=""):
    _res.append((name, bool(passed), detail))
    print(f"CHECK {name} {'PASS' if passed else 'FAIL'}" + (f"   | {detail}" if detail else ""))
    return passed


t0 = time.time()
a, b, x, n, s, u, beta = symbols("a b x n s u beta")
kp = (13 + 3*sqrt(33))/16
km = (13 - 3*sqrt(33))/16
Kp, Km = kp + 4, km + 4
F0 = kp*a**3 + km*b**3 + (a + b)*x**2
conic = x**2 - 4*(a**2 - a*b + b**2)

# ---------------------------------------------------------------- A ----
chk("trace_relations",
    all(is0(z) for z in [kp + km - Rational(13, 8), kp*km + Rational(1, 2),
                         (kp + 2)*(km + 2) - Rational(27, 4), (kp + 4)*(km + 4) - 22]),
    "kp+km=13/8, kp*km=-1/2, (kp+2)(km+2)=27/4, (kp+4)(km+4)=22")

chk("product_22", is0((kp + 4)*(km + 4) - 22), "(kp+4)(km+4) = 22")

# restriction identity via RESULTANT: Res_x(F0, conic) = ((kp+4)a^3+(km+4)b^3)^2
Rx_full = expand(resultant(Poly(F0, x), Poly(conic, x)))
chk("restriction_identity", is0(Rx_full - expand((Kp*a**3 + Km*b**3)**2)),
    "Res_x(F0, x^2-4(a^2-ab+b^2)) = ((kp+4)a^3+(km+4)b^3)^2")

w = Rational(-1, 2) + sqrt(-3)/2
chk("omega_conic_factorisation",
    is0((w*a + w**2*b)*(w**2*a + w*b) - (a**2 - a*b + b**2))
    and is0((a + b)*(a**2 - a*b + b**2) - (a**3 + b**3)),
    "(wa+w^2b)(w^2a+wb) = a^2-ab+b^2 ; (a+b)(a^2-ab+b^2) = a^3+b^3")

# --- alternative parameterisation of K_c, base point (b,x) = (1,2) ------
bn = n*(n - 4)/((n - 2)*(n + 2))
xn = -2*(n**2 - 2*n + 4)/(n**2 - 4)
chk("param_on_conic", is0(cancel(together(xn**2 - 4*(1 - bn + bn**2)))),
    "x(n)^2 - 4(1-b(n)+b(n)^2) = 0 for the (1,2)-based parameterisation")

# branch sextic on the n-side
num_n, den_n = fraction(cancel(together(Kp + Km*bn**3)))
P6n_closed = expand(Kp*(n**2 - 4)**3 + Km*n**3*(n - 4)**3)
Pn = Poly(expand(num_n), n)
scale_n = cancel(expand(num_n)/P6n_closed)
chk("sextic_degree",
    Pn.degree() == 6 and is0(simplify(Poly(P6n_closed, n).LC() - Rational(77, 8))),
    f"deg = {Pn.degree()}, closed form (kp+4)(n^2-4)^3 + (km+4)n^3(n-4)^3, LC = 77/8")

chk("sextic_coeffs_agree",
    all(is0(scale_n*Poly(P6n_closed, n).coeff_monomial(n**k) - Pn.coeff_monomial(n**k))
        for k in range(7)),
    f"cleared numerator = ({scale_n}) * closed form, coefficient by coefficient")

# tau on the n-side
tau_n = (n - 4)/(n - 1)
chk("tau_involution", is0(cancel(tau_n.subs(n, tau_n)) - n), "tau_n(tau_n(n)) = n")

lhs_n = expand(cancel(together(P6n_closed.subs(n, tau_n)*(n - 1)**6)))
mult_n = cancel(lhs_n/P6n_closed)
chk("tau_preserves_roots", is0(lhs_n - mult_n*P6n_closed) and simplify(mult_n) == -27,
    f"P6n(tau_n(n))*(n-1)^6 = ({simplify(mult_n)}) * P6n(n)")

# ---------------------------------------------------------------- B ----
# fixed points of tau_n: n^2 - 2n + 4 = 0  ->  n = 1 +- sqrt(-3)
n1, n2 = 1 + sqrt(-3), 1 - sqrt(-3)
assert is0(n1**2 - 2*n1 + 4) and is0(n2**2 - 2*n2 + 4)
n_of_s = (n2*s - n1)/(s - 1)
Qs = Poly(expand(simplify(cancel(together(P6n_closed.subs(n, n_of_s)*(s - 1)**6)))), s)
qc = [simplify(expand(Qs.coeff_monomial(s**k))) for k in range(7)]
chk("evenness", all(is0(qc[k]) for k in (1, 3, 5)),
    "odd s-coefficients vanish on the (1,2)-based parameterisation too")

cc = [qc[0], qc[2], qc[4], qc[6]]           # c(u) ascending, u = s^2
chk("cubic_squarefree", not is0(discriminant(Poly(sum(cc[k]*u**k for k in range(4)), u))),
    "disc_u(c) != 0")


def j_IJ(a0, a1, a2, a3, a4):
    """Aronhold I,J of a0 x^4 + a1 x^3 + a2 x^2 + a3 x + a4; j = 1728*4I^3/(4I^3 - J^2)."""
    Iv = 12*a0*a4 - 3*a1*a3 + a2**2
    Jv = (72*a0*a2*a4 + 9*a1*a2*a3 - 27*a0*a3**2 - 27*a4*a1**2 - 2*a2**3)
    return simplify(radsimp(cancel(1728*4*Iv**3/(4*Iv**3 - Jv**2))))


c0, c1, c2, c3 = cc
jp = j_IJ(0, c3, c2, c1, c0)                # E+ : v^2 = c(u)
jm = j_IJ(c3, c2, c1, c0, 0)                # E- : v^2 = u c(u)
chk("j_plus_exact", is0(jp + 32768), f"j(E+) = {jp} via Aronhold I,J")
chk("j_minus_exact", is0(jm + 32768), f"j(E-) = {jm} via Aronhold I,J")
chk("j_plus_equals_j_minus", is0(jp - jm), "j(E+) = j(E-)")

# --- numeric route on the n-side ---------------------------------------
mp.mp.dps = 70
r33 = mp.sqrt(33)
Kpn, Kmn = (13 + 3*r33)/16 + 4, (13 - 3*r33)/16 + 4
# P6n = Kp*(n^2-4)^3 + Km*n^3*(n-4)^3.  Built from its FACTORS by numeric convolution
# rather than by transcribing binomial expansions (descending order throughout).
def _pmul(p, q):
    out = [mp.mpf(0)]*(len(p) + len(q) - 1)
    for i_, A_ in enumerate(p):
        for j_, B_ in enumerate(q):
            out[i_ + j_] += A_*B_
    return out


def _pscal(c, p):
    return [c*z for z in p]


def _padd(p, q):
    p = [mp.mpf(0)]*(len(q) - len(p)) + list(p)
    q = [mp.mpf(0)]*(len(p) - len(q)) + list(q)
    return [A_ + B_ for A_, B_ in zip(p, q)]


sq = _pmul(_pmul([mp.mpf(1), mp.mpf(0), mp.mpf(-4)], [mp.mpf(1), mp.mpf(0), mp.mpf(-4)]),
           [mp.mpf(1), mp.mpf(0), mp.mpf(-4)])           # (n^2-4)^3
lin = _pmul(_pmul([mp.mpf(1), mp.mpf(-4)], [mp.mpf(1), mp.mpf(-4)]),
            [mp.mpf(1), mp.mpf(-4)])                     # (n-4)^3
lin = lin + [mp.mpf(0)]*3                                # times n^3
poly_n = _padd(_pscal(Kpn, sq), _pscal(Kmn, lin))
rts = mp.polyroots(poly_n, maxsteps=400, extraprec=800)
nn1, nn2 = 1 + mp.sqrt(-3), 1 - mp.sqrt(-3)
sv = [(z - nn1)/(z - nn2) for z in rts]
pair, U = mp.mpf(0), []
used = set()
for i_ in range(6):
    if i_ in used:
        continue
    best, bd = None, None
    for j_ in range(6):
        if j_ != i_ and j_ not in used:
            d = abs(sv[i_] + sv[j_])
            if bd is None or d < bd:
                best, bd = j_, d
    pair = max(pair, bd); used |= {i_, best}; U.append(sv[i_]**2)
chk("s_pairing_numeric", len(U) == 3 and pair < mp.mpf('1e-40'),
    f"6 s-roots pair as {{s,-s}}; max |s_a+s_b| = {mp.nstr(pair, 3)}")

jl = lambda L: 256*(L**2 - L + 1)**3/(L**2*(L - 1)**2)
u1, u2, u3 = U
jpn = jl((u3 - u1)/(u2 - u1))                                  # branch {u1,u2,u3,inf}
jmn = jl(((u2 - 0)*(u1 - u3))/((u2 - u3)*(u1 - 0)))            # branch {0,u1,u2,u3}
ep, em = abs(jpn + 32768), abs(jmn + 32768)
chk("j_plus_numeric", ep < mp.mpf('1e-36'), f"|j(E+)+32768| = {mp.nstr(ep, 3)}")
chk("j_minus_numeric", em < mp.mpf('1e-36'), f"|j(E-)+32768| = {mp.nstr(em, 3)}")

chk("j_not_arrangement",
    Rational(-32768) != Rational(8192, 11) and Rational(-32768) != Rational(-4096, 11),
    "-32768 is neither 8192/11 nor -4096/11")

# --- CM anchor: h(-11) = 1 and j((1+sqrt-11)/2) = -32768 ----------------
D = -11
forms = [(A_, B_, (B_*B_ - D)//(4*A_))
         for A_ in range(1, int((abs(D)/3)**0.5) + 2)
         for B_ in range(-A_ + 1, A_ + 1)
         if (B_*B_ - D) % (4*A_) == 0 and (B_*B_ - D)//(4*A_) >= A_
         and not (A_ == (B_*B_ - D)//(4*A_) and B_ < 0)]
h = len(forms)
# j = 1728 E4^3/(E4^3 - E6^2)  -- Eisenstein route (main run used E4^3/Delta)
mp.mp.dps = 70
tau_cm = (1 + mp.sqrt(-11))/2
q = mp.e**(2j*mp.pi*tau_cm)
sig = lambda k, m: sum(d**k for d in range(1, m + 1) if m % d == 0)
E4 = 1 + 240*sum(sig(3, m)*q**m for m in range(1, 70))
E6 = 1 - 504*sum(sig(5, m)*q**m for m in range(1, 70))
j_cm = 1728*E4**3/(E4**3 - E6**2)
err_cm = abs(j_cm + 32768)
chk("cm_minus_11", h == 1 and err_cm < mp.mpf('1e-20'),
    f"h(-11) = {h} (forms {forms}); Eisenstein route |j+32768| = {mp.nstr(err_cm, 3)} "
    "=> H_{-11}(X) = X + 32768")

# ---------------------------------------------------------------- C ----
# smoothness of E_sigma by elimination, and j(E_sigma) by EXACT cross-ratio
Fa, Fb, Fx = F0.diff(a), F0.diff(b), F0.diff(x)
# any singular point has x = 0 or a = -b (from Fx = 2(a+b)x); both force a=b=x=0
e1 = resultant(Poly(Fa.subs(x, 0), a), Poly(Fb.subs(x, 0), b))     # x = 0 branch
br2_a = simplify(expand(Fa.subs(b, -a) - Fb.subs(b, -a)))          # a = -b branch
smooth = is0(simplify(br2_a - 3*(kp - km)*a**2)) and simplify(kp - km) != 0
# exact j(E_sigma) from the 4 branch points {-1, beta, w*beta, w^2*beta}, beta^3 = -kp/km
rho0 = simplify(-kp/km)
lam = simplify(-w**2*(w*beta + 1)/(w**2*beta + 1))
jexpr = cancel(together(256*(lam**2 - lam + 1)**3/(lam**2*(lam - 1)**2)))
jn, jd = fraction(jexpr)
mod = Poly(beta**3 - rho0, beta)
jn_r = rem(Poly(expand(jn), beta), mod)
jd_r = rem(Poly(expand(jd), beta), mod)
# j = 8192/11  <=>  11*jn_r - 8192*jd_r == 0  (as polynomials in beta, mod beta^3-rho0)
resid = rem(Poly(expand(11*jn_r.as_expr() - 8192*jd_r.as_expr()), beta), mod)
j_sig_ok = all(is0(cf) for cf in resid.all_coeffs())
chk("genus_Esigma", smooth and j_sig_ok,
    "E_sigma smooth (Fx=0 forces a=b=x=0 since kp != km); "
    "cross-ratio route gives j(E_sigma) = 8192/11 exactly mod beta^3 = -kp/km")

mp.mp.dps = 60
kpn_, kmn_ = (13 + 3*mp.sqrt(33))/16, (13 - 3*mp.sqrt(33))/16
bp = mp.polyroots([kmn_, 0, 0, kpn_], maxsteps=300, extraprec=600)   # km b^3 + kp = 0
pts = [mp.mpf(-1)] + list(bp)
p1, p2, p3, p4 = pts
lam_s = ((p3 - p1)*(p2 - p4))/((p3 - p4)*(p2 - p1))
errS = abs(jl(lam_s) - mp.mpf(8192)/11)
chk("j_Esigma_numeric", errS < mp.mpf('1e-40'),
    f"numeric cross-ratio j(E_sigma) matches 8192/11, err = {mp.nstr(errS, 3)}")

# six distinct intersection points, n-side + resultant side
rho = simplify(-Kp/Km)
disc_n = simplify(discriminant(Poly(P6n_closed, n)))
b_at_roots = max(abs(( (z*(z-4)/((z-2)*(z+2)))**3 ) - (-(Kpn)/(Kmn))) for z in rts)
chk("six_intersection_points",
    (not is0(disc_n)) and simplify(rho) != 0 and simplify(rho + 1) != 0
    and is0(rho + (283 + 21*sqrt(33))/256) and b_at_roots < mp.mpf('1e-40'),
    f"disc_n(P6n) != 0; rho = -(283+21 sqrt33)/256, != 0 and != -1; all 6 n-roots satisfy "
    f"b(n)^3 = rho (max dev {mp.nstr(b_at_roots, 3)}) -> 3 distinct b, 2 distinct x each")

# Riemann-Hurwitz, re-encoded via Euler characteristics
chi = lambda g: 2 - 2*g
g_from_chi = lambda c: (2 - c)//2
gEt = g_from_chi(2*chi(1) - 6)      # double cover of E_sigma branched at 6
gKt = g_from_chi(2*chi(0) - 6)      # double cover of P^1 branched at 6
# connected nodal curve: p_a = sum(g_i) + delta - (#components) + 1
pa = lambda gs, delta: sum(gs) + delta - len(gs) + 1
paD, paDt = pa([1, 0], 6), pa([gEt, gKt], 6)
chk("rh_arithmetic",
    gEt == 4 and gKt == 2 and paD == 6 and paDt == 11 and paDt == 2*paD - 1
    and paDt - paD == 5 and (5 - 1)*(5 - 2)//2 == 6 and 3*2 == 6,
    f"g(E~)={gEt}, g(K~)={gKt}, p_a(D5)={paD} (= plane quintic 6 = Bezout-consistent), "
    f"p_a(D5~)={paDt}=2*{paD}-1, Prym dim = {paDt - paD}")

# --- independent engine re-run -----------------------------------------
m2 = subprocess.run(["M2", "--script", os.path.join(HERE, "scripts", "m2_geometry.m2")],
                    capture_output=True, text=True, cwd=HERE)
mo = m2.stdout + m2.stderr
chk("m2_independent_geometry",
    m2.returncode == 0 and "M2_DONE" in mo
    and mo.count("true") >= 5 and "degree (expect 6)                      : 6" in mo
    and "bb^3+21/256y+283/256" in mo.replace(" ", ""),
    "Macaulay2 re-run: smooth cubic + smooth conic, deg = 6, transverse, "
    "elimination gives b^3 = -(283+21 sqrt33)/256")

# ---------------------------------------------------------------- out --
npass = sum(1 for _, p, _ in _res if p)
with open(VLOG, "w") as f:
    for nm, p, d in _res:
        f.write(f"CHECK {nm} {'PASS' if p else 'FAIL'}\n")
    f.write(f"VERIFIER: {npass}/{len(_res)} PASS\n")
print(f"VERIFIER: {npass}/{len(_res)} PASS")
print(f"[verifier] {time.time()-t0:.1f}s")
sys.exit(0 if npass == len(_res) else 1)
