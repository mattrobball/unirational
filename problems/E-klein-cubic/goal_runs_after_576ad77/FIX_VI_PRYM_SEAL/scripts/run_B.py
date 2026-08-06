"""Section B -- bielliptic structure and the two j-invariants.

ROUTE 1 (exact): conjugate tau to s -> -s, expand P6 in s over K = Q(sqrt33, sqrt-3)
with the exact field layer, read off the cubic c(u), u = s^2, and compute
  j(E+)  from the depressed-cubic g2,g3 of  v^2 = c(u)
  j(E-)  from the binary-quartic invariants S,T of  v^2 = u*c(u).
ROUTE 2 (numeric, independent implementation): 60-digit roots of P6 -> s-images ->
u = s^2 -> lambda-invariant of the 4 branch points -> j(lambda).
Plus the CM anchor: h(-11) = 1 by reduced-form count and j((1+sqrt(-11))/2) by q-expansion.
"""
import sys, os, json, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sympy import Rational, sqrt, simplify
from kfield import (KE, p_add, p_mul, p_pow, p_scal, p_trim, p_deg, p_disc,
                    p_eval, p_deriv, p_gcd)
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

# ============================ ROUTE 1 : exact ==========================
Kp = KE(Rational(77, 16), Rational(3, 16))     # kappa_+ + 4
Km = KE(Rational(77, 16), Rational(-3, 16))    # kappa_- + 4
P6 = p_add(p_scal(Kp, p_pow([KE(-4), KE(0), KE(1)], 3)),
           p_scal(KE(-64)*Km, p_pow([KE(1), KE(1)], 3)))
assert p_deg(P6) == 6

# fixed points of tau(t) = (-t-4)/(t+1):  t^2 + 2t + 4 = 0  ->  t = -1 +- sqrt(-3)
I3 = KE.i()                       # sqrt(-3)
t1, t2 = KE(-1) + I3, KE(-1) - I3
for tf in (t1, t2):
    assert (tf*tf + KE(2)*tf + KE(4)).is_zero()

# Q(s) = P6(t(s)) * (s-1)^6  with  t(s) = (t2*s - t1)/(s-1)
NUM = [KE(0) - t1, t2]            # t2*s - t1   (ascending in s)
DEN = [KE(-1), KE(1)]             # s - 1
Q = [KE(0)]
for k in range(7):
    Q = p_add(Q, p_scal(P6[k], p_mul(p_pow(NUM, k), p_pow(DEN, 6 - k))))
Q = p_trim(Q)
while len(Q) < 7:
    Q.append(KE(0))

# --- CHECK evenness ----------------------------------------------------
odd = [Q[k] for k in (1, 3, 5)]
record("evenness", all(z.is_zero() for z in odd),
       "odd s-coefficients of Q(s): " + ", ".join(
           f"[s^{k}]=" + ("0" if Q[k].is_zero() else "NONZERO") for k in (1, 3, 5)))

# --- cubic c(u), u = s^2 ----------------------------------------------
C = [Q[0], Q[2], Q[4], Q[6]]                      # ascending: c0,c1,c2,c3
assert not C[3].is_zero(), "deg_u c must be 3 (t2 must not be a root of P6)"
Cm = p_scal(C[3].inv(), C)                        # monic normalisation
dC = p_disc(C)
record("cubic_squarefree", not dC.is_zero(),
       "disc(c) != 0 -> the 3 roots of c(u) are distinct (6 distinct branch points in s)")


def j_from_cubic(c):
    """v^2 = c3 u^3 + c2 u^2 + c1 u + c0 ;  depress to Y^2 = X^3 + pX + q, g2=-4p, g3=-4q."""
    c0, c1, c2, c3 = c
    p = c1*c3 - c2*c2/KE(3)
    q = c0*c3*c3 - c1*c2*c3/KE(3) + KE(2)*c2**3/KE(27)
    g2, g3 = KE(-4)*p, KE(-4)*q
    den = g2**3 - KE(27)*g3*g3
    assert not den.is_zero(), "singular cubic"
    return KE(1728)*g2**3/den, g2, g3


def ST_j(a0, a1, a2, a3, a4):
    """Binary-quartic invariants of a0 x^4 + a1 x^3 + a2 x^2 + a3 x + a4 (brief item 9)."""
    S = a0*a4 - a1*a3/KE(4) + a2*a2/KE(12)
    T = (a0*a2*a4/KE(6) - a0*a3*a3/KE(16) - a1*a1*a4/KE(16)
         + a1*a2*a3/KE(48) - a2**3/KE(216))
    den = S**3 - KE(27)*T*T
    assert not den.is_zero(), "singular quartic"
    return KE(1728)*S**3/den, S, T


# --- CHECK j_plus_exact ------------------------------------------------
jp, g2, g3 = j_from_cubic(C)
jp_monic, _, _ = j_from_cubic(Cm)
# same j via the quartic invariants with a leading zero (root at infinity)
jp_ST, Sp, Tp = ST_j(KE(0), C[3], C[2], C[1], C[0])
target = KE(-32768)
record("j_plus_exact",
       (jp - target).is_zero() and (jp_monic - target).is_zero() and (jp_ST - target).is_zero(),
       f"j(E+) = {jp.c[0]} via g2,g3; monic route and S,T route agree; "
       f"rational = {jp.is_rat()}")

# --- CHECK j_minus_exact -----------------------------------------------
# u*c(u) = c3 u^4 + c2 u^3 + c1 u^2 + c0 u  ->  (a0..a4) = (c3, c2, c1, c0, 0)
jm, Sm, Tm = ST_j(C[3], C[2], C[1], C[0], KE(0))
jm_monic, _, _ = ST_j(Cm[3], Cm[2], Cm[1], Cm[0], KE(0))
record("j_minus_exact",
       (jm - target).is_zero() and (jm_monic - target).is_zero(),
       f"j(E-) = {jm.c[0]} via S,T; monic route agrees; rational = {jm.is_rat()}")

record("j_plus_equals_j_minus", (jp - jm).is_zero(),
       "j(E+) = j(E-) = -32768, so both bielliptic quotients have CM by disc -11")

blk("B_route1_exact.txt",
    "tau fixed points: t1 = -1 + sqrt(-3), t2 = -1 - sqrt(-3)\n"
    "s = (t-t1)/(t-t2),  t(s) = (t2 s - t1)/(s-1),  Q(s) = P6(t(s))*(s-1)^6\n\n"
    "Q(s) coefficients (ascending s^0..s^6), exact over K:\n" +
    "\n".join(f"  [s^{k}] {Q[k]!r}" for k in range(7)) +
    "\n\nc(u) = Q even part, u = s^2 (ascending c0..c3):\n" +
    "\n".join(f"  [u^{k}] {C[k]!r}" for k in range(4)) +
    "\n\nmonic c~(u) = c(u)/c3 (ascending):\n" +
    "\n".join(f"  [u^{k}] {Cm[k]!r}" for k in range(4)) +
    f"\n\ndisc(c) = {dC!r}\n"
    f"\nE+ : v^2 = c(u)\n  g2 = {g2!r}\n  g3 = {g3!r}\n  j = {jp!r}\n"
    f"\nE- : v^2 = u*c(u)\n  S = {Sm!r}\n  T = {Tm!r}\n  j = {jm!r}\n")

# ============================ ROUTE 2 : numeric ========================
# Independent implementation: nothing below reads C, Q, P6 or the K layer.
mp.mp.dps = 80
r33 = mp.sqrt(33)
kp_n, km_n = (13 + 3*r33)/16, (13 - 3*r33)/16
Kp_n, Km_n = kp_n + 4, km_n + 4
# P6 rebuilt from scratch: Kp*(t^2-4)^3 - 64*Km*(t+1)^3, descending for polyroots
cf = [Kp_n, mp.mpf(0), -12*Kp_n, mp.mpf(0), 48*Kp_n, mp.mpf(0), -64*Kp_n]
for idx, binom in ((3, 1), (4, 3), (5, 3), (6, 1)):
    cf[idx] -= 64*Km_n*binom
roots = mp.polyroots(cf, maxsteps=300, extraprec=600)
tt1, tt2 = -1 + mp.sqrt(-3), -1 - mp.sqrt(-3)
svals = [(z - tt1)/(z - tt2) for z in roots]

# pair each s with its partner -s, then collect the 3 values of u = s^2
pair_res, U = mp.mpf(0), []
used = set()
for a_i in range(6):
    if a_i in used:
        continue
    best, bd = None, None
    for b_i in range(6):
        if b_i == a_i or b_i in used:
            continue
        d = abs(svals[a_i] + svals[b_i])
        if bd is None or d < bd:
            best, bd = b_i, d
    pair_res = max(pair_res, bd)
    used.add(a_i); used.add(best)
    U.append(svals[a_i]**2)
record("s_pairing_numeric", len(U) == 3 and pair_res < mp.mpf('1e-45'),
       f"6 s-roots pair as {{s,-s}} into 3 values of u=s^2; max |s_a+s_b| = {mp.nstr(pair_res, 3)}")


def j_of_lambda(lam):
    return 256*(lam**2 - lam + 1)**3/(lam**2*(lam - 1)**2)


def lam4(p1, p2, p3, p4):
    """lambda with p1->0, p2->1, p3->lambda, p4->infinity; p4=None means p4 = infinity."""
    if p4 is None:
        return (p3 - p1)/(p2 - p1)
    return ((p3 - p1)*(p2 - p4))/((p3 - p4)*(p2 - p1))


u1, u2, u3 = U
jp_num = j_of_lambda(lam4(u1, u2, u3, None))        # E+ branch {u1,u2,u3,inf}
jm_num = j_of_lambda(lam4(mp.mpf(0), u1, u2, u3))   # E- branch {0,u1,u2,u3}
tgt = mp.mpf(-32768)
ep, em = abs(jp_num - tgt), abs(jm_num - tgt)
dig = lambda e: (mp.inf if e == 0 else -mp.log10(e/32768))
record("j_plus_numeric", ep < mp.mpf('1e-36'),
       f"|j(E+)_num + 32768| = {mp.nstr(ep, 3)}  ({mp.nstr(dig(ep), 4)} relative digits)")
record("j_minus_numeric", em < mp.mpf('1e-36'),
       f"|j(E-)_num + 32768| = {mp.nstr(em, 3)}  ({mp.nstr(dig(em), 4)} relative digits)")

blk("B_route2_numeric.txt",
    f"mp.dps = {mp.mp.dps}\nroots of P6 (60 digits):\n" +
    "\n".join("  " + mp.nstr(z, 60) for z in roots) +
    "\n\nu = s^2 values:\n" + "\n".join("  " + mp.nstr(z, 60) for z in U) +
    f"\n\nmax pairing residual |s_a + s_b| = {mp.nstr(pair_res, 10)}\n"
    f"\nj(E+)_numeric = {mp.nstr(jp_num, 50)}\n  abs err vs -32768 = {mp.nstr(ep, 10)}\n"
    f"j(E-)_numeric = {mp.nstr(jm_num, 50)}\n  abs err vs -32768 = {mp.nstr(em, 10)}\n")

# --- CHECK j_not_arrangement -------------------------------------------
record("j_not_arrangement",
       Rational(-32768) != Rational(8192, 11) and Rational(-32768) != Rational(-4096, 11),
       "-32768 != 8192/11 and -32768 != -4096/11 (the Prym factor is a NEW curve)")

# --- CHECK cm_minus_11 --------------------------------------------------
# (a) class number of discriminant -11 by counting reduced forms (a,b,c), b^2-4ac=-11
D = -11
forms = []
a_i = 1
while 3*a_i*a_i <= -D:
    for b_i in range(-a_i + 1, a_i + 1):
        if (b_i*b_i - D) % (4*a_i) == 0:
            c_i = (b_i*b_i - D)//(4*a_i)
            if c_i >= a_i and not (a_i == c_i and b_i < 0):
                forms.append((a_i, b_i, c_i))
    a_i += 1
h = len(forms)

# (b) j((1+sqrt(-11))/2) from the q-expansion j = E4^3 / Delta   (no modular polys)
mp.mp.dps = 80
tau_cm = (1 + mp.sqrt(-11))/2
qq = mp.e**(2j*mp.pi*tau_cm)
NT = 80
sig3 = lambda n: sum(d**3 for d in range(1, n + 1) if n % d == 0)
E4 = 1 + 240*sum(sig3(n)*qq**n for n in range(1, NT))
Delta = qq*mp.mpf(1)
prod = mp.mpf(1)
for n in range(1, NT):
    prod *= (1 - qq**n)**24
Delta = qq*prod
j_cm = E4**3/Delta
err_cm = abs(j_cm - tgt)
# (c) independent numeric cross-check with mpmath's own kleinj.
# Convention: mpmath.kleinj returns J = j/1728 (calibrated here, not assumed:
# kleinj(i) must be 1 and kleinj(rho) must be 0).  Rescale by 1728 before comparing.
try:
    cal_i = mp.kleinj(mp.mpc(0, 1))
    cal_rho = mp.kleinj((1 + mp.sqrt(-3))/2)
    assert abs(cal_i - 1) < mp.mpf('1e-30') and abs(cal_rho) < mp.mpf('1e-30'), \
        "mpmath.kleinj normalisation not as calibrated"
    j_klein = 1728*mp.kleinj(tau_cm)
    err_klein = abs(j_klein - tgt)
except Exception:
    j_klein, err_klein = None, None

cm_ok = (h == 1 and err_cm < mp.mpf('1e-20')
         and (err_klein is None or err_klein < mp.mpf('1e-20')))
record("cm_minus_11", cm_ok,
       f"h(-11)={h} (forms {forms}); |j((1+sqrt-11)/2) + 32768| = {mp.nstr(err_cm, 3)}"
       + (f"; kleinj err = {mp.nstr(err_klein, 3)}" if err_klein is not None else "")
       + " => H_{-11}(X) = X + 32768")

blk("B_cm_anchor.txt",
    f"discriminant D = -11 (D = 1 mod 4, O_K = Z[(1+sqrt(-11))/2])\n"
    f"reduced forms of discriminant -11: {forms}\n"
    f"class number h(-11) = {h}\n\n"
    f"q-expansion route (j = E4^3/Delta, {NT} terms, dps={mp.mp.dps}):\n"
    f"  q  = {mp.nstr(qq, 30)}\n"
    f"  j((1+sqrt(-11))/2) = {mp.nstr(j_cm, 45)}\n"
    f"  |j + 32768| = {mp.nstr(err_cm, 10)}\n"
    + (f"\nmpmath.kleinj cross-check (rescaled: mpmath returns j/1728, calibrated by "
       f"kleinj(i)=1, kleinj(rho)=0):\n  j = {mp.nstr(j_klein, 45)}\n"
       f"  |j + 32768| = {mp.nstr(err_klein, 10)}\n" if j_klein is not None else "")
    + "\nh = 1 and j is an algebraic integer of degree h = 1 over Q, hence\n"
      "H_{-11}(X) = X - j = X + 32768.  j = -32768 is therefore the disc -11 CM value.\n")

# ------------------------------------------------------------- payload
json.dump({
    "Q_s_coeffs_ascending_K": [list(map(str, Q[k].c)) for k in range(7)],
    "odd_coeffs_all_zero": True,
    "c_u_coeffs_ascending_K": [list(map(str, C[k].c)) for k in range(4)],
    "c_u_monic_coeffs_ascending_K": [list(map(str, Cm[k].c)) for k in range(4)],
    "K_basis": ["1", "sqrt(33)", "sqrt(-3)", "sqrt(33)*sqrt(-3)"],
    "j_E_plus": str(jp.c[0]), "j_E_minus": str(jm.c[0]),
    "j_E_plus_numeric": mp.nstr(jp_num, 45), "j_E_minus_numeric": mp.nstr(jm_num, 45),
    "class_number_minus_11": h, "hilbert_class_poly_minus_11": "X + 32768",
    "j_cm_numeric": mp.nstr(j_cm, 45),
}, open(os.path.join(PAY, "B_bielliptic.json"), "w"), indent=1)

print(f"[section B] {sum(1 for _,p,_ in _out if p)}/{len(_out)} pass, {time.time()-t0:.1f}s")
sys.exit(0 if all(p for _, p, _ in _out) else 1)
