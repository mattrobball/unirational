"""Section A -- restriction identity and branch data.  Exact, char 0.

Route: sympy symbolic algebra over Q(sqrt(33)) for the polynomial identities
(checks 1,3,5), plus the exact K-field layer for the sextic coefficients.
Writes results/A_*.txt and appends CHECK lines to results/checks.log.
"""
import sys, os, json, time
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sympy import (symbols, sqrt, Rational, expand, simplify, cancel, together,
                   fraction, Poly, rem, div, factor, degree, srepr)
from kfield import KE, p_trim, p_mul, p_pow, p_add, p_scal, p_eval, p_deg

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(HERE, "results")
PAY = os.path.join(HERE, "payload")
LOG = os.path.join(RES, "checks.log")
os.makedirs(RES, exist_ok=True); os.makedirs(PAY, exist_ok=True)

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
a, b, x, t = symbols("a b x t")

# ---------------------------------------------------------------- frame
kp = (13 + 3*sqrt(33)) / 16
km = (13 - 3*sqrt(33)) / 16

# --- CHECK 1(pre): trace relations -------------------------------------
rel = {
    "kp+km = 13/8":        simplify(kp + km - Rational(13, 8)),
    "kp*km = -1/2":        simplify(kp*km + Rational(1, 2)),
    "(kp+2)(km+2) = 27/4": simplify((kp + 2)*(km + 2) - Rational(27, 4)),
    "(kp+4)(km+4) = 22":   simplify((kp + 4)*(km + 4) - 22),
}
record("trace_relations", all(v == 0 for v in rel.values()),
       "; ".join(f"{k} -> {v}" for k, v in rel.items()))
blk("A_trace_relations.txt",
    "kappa_pm = (13 +- 3*sqrt(33))/16\n" +
    "\n".join(f"{k}:  residual = {v}" for k, v in rel.items()) + "\n")

# --- CHECK 2: product_22 (recorded separately per brief item 2) ---------
record("product_22", simplify((kp + 4)*(km + 4) - 22) == 0,
       f"(kp+4)(km+4) = {simplify((kp+4)*(km+4))}")

# --- CHECK 1: restriction identity on K_c ------------------------------
F0 = kp*a**3 + km*b**3 + (a + b)*x**2
conic = x**2 - 4*(a**2 - a*b + b**2)
target = (kp + 4)*a**3 + (km + 4)*b**3
# genuine reduction modulo the conic, as polynomials in x
r_ = rem(Poly(expand(F0 - target), x), Poly(conic, x))
r_ = expand(simplify(r_.as_expr()))
record("restriction_identity", r_ == 0,
       f"rem(F0 - [(kp+4)a^3+(km+4)b^3], x^2-4(a^2-ab+b^2)) = {r_}")
# supporting identity (a+b)(a^2-ab+b^2) = a^3+b^3
supp = expand((a + b)*(a**2 - a*b + b**2) - (a**3 + b**3))
# and the omega factorisation (w a + w^2 b)(w^2 a + w b) = a^2 - ab + b^2
w = Rational(-1, 2) + sqrt(-3)/2
omega_id = expand(simplify((w*a + w**2*b)*(w**2*a + w*b) - (a**2 - a*b + b**2)))
blk("A_restriction_identity.txt",
    f"F0        = {F0}\nconic K_c = {conic} = 0\n"
    f"target    = {target}\n"
    f"rem_x(F0 - target, conic) = {r_}\n"
    f"support: (a+b)(a^2-ab+b^2)-(a^3+b^3) = {supp}\n"
    f"support: (wa+w^2b)(w^2a+wb)-(a^2-ab+b^2) = {omega_id}\n")
record("omega_conic_factorisation", omega_id == 0 and supp == 0,
       "(wa+w^2b)(w^2a+wb) = a^2-ab+b^2 and (a+b)(a^2-ab+b^2) = a^3+b^3")

# --- CHECK 3: parameterisation lies on the conic -----------------------
bt = -4*(t + 1) / ((t - 2)*(t + 2))
xt = 2 + t*bt
resid = cancel(together(xt**2 - 4*(1 - bt + bt**2)))
record("param_on_conic", simplify(resid) == 0,
       f"x(t)^2 - 4(1-b+b^2) = {resid}")
# projective form (a:b:x) with common denominator cleared
a_p, b_p, x_p = expand((t - 2)*(t + 2)), expand(-4*(t + 1)), expand(cancel(xt*(t**2 - 4)))
blk("A_param.txt",
    f"b(t) = {bt}\nx(t) = {cancel(xt)}\n"
    f"projective (a:b:x) = ({a_p} : {b_p} : {x_p})\n"
    f"residual on conic = {resid}\n")

# --- CHECK 4: branch sextic --------------------------------------------
expr = (kp + 4) + (km + 4)*bt**3
num, den = fraction(cancel(together(expr)))
num = expand(num)
P6_sym = Poly(num, t)
deg = P6_sym.degree()
lead = simplify(P6_sym.LC())
# closed form claimed by the brief's construction
P6_closed = expand((kp + 4)*(t**2 - 4)**3 - 64*(km + 4)*(t + 1)**3)
ratio = simplify(cancel(num / P6_closed))
record("sextic_degree", deg == 6 and simplify(lead) != 0,
       f"deg = {deg}, LC = {lead}, num/closed_form = {ratio} (denominator = {factor(den)})")

# exact coefficients in K, normalised to the closed form (κ₊+4)(t²−4)³ − 64(κ₋+4)(t+1)³
Kp = KE(Rational(77, 16), Rational(3, 16))          # kp + 4 = (77 + 3 sqrt33)/16
Km = KE(Rational(77, 16), Rational(-3, 16))         # km + 4
assert (Kp*Km - KE(22)).is_zero()
t2m4 = [KE(-4), KE(0), KE(1)]                       # t^2 - 4
tp1 = [KE(1), KE(1)]                                # t + 1
P6 = p_add(p_scal(Kp, p_pow(t2m4, 3)), p_scal(KE(-64)*Km, p_pow(tp1, 3)))
assert p_deg(P6) == 6
# Cross-check exact K coefficients against the sympy expansion.  sympy's cancel()
# clears the 1/16 in kappa_pm, so its numerator is the overall nonzero constant
# multiple 16 * P6_closed; roots (hence every downstream claim) are unaffected.
P6c_sym = Poly(P6_closed, t)
coeff_ok = all(simplify(P6[k].to_sympy() - P6c_sym.coeff_monomial(t**k)) == 0 for k in range(7))
scale_ok = ratio == 16 and all(
    simplify(16*P6[k].to_sympy() - P6_sym.coeff_monomial(t**k)) == 0 for k in range(7))
record("sextic_coeffs_agree", coeff_ok and scale_ok,
       f"K coeffs match closed form exactly; sympy cleared numerator = {ratio} * closed form")

blk("A_sextic.txt",
    "P6(t) = (kp+4)*(t^2-4)^3 - 64*(km+4)*(t+1)^3\n"
    f"degree = {deg}\nleading coeff = {lead}\n\n"
    "exact coefficients over K = Q(sqrt33, sqrt-3), t^k ascending:\n" +
    "\n".join(f"  [t^{k}] {P6[k]!r}" for k in range(7)) +
    f"\n\nsympy expansion:\n  {num}\n"
    f"num / closed_form = {ratio}\n")

# --- CHECK 5: tau preserves the root set -------------------------------
tau = (-t - 4) / (t + 1)
lhs = expand(cancel(together(num.subs(t, tau) * (t + 1)**6)))
c_ratio = simplify(cancel(lhs / num))
record("tau_preserves_roots", simplify(expand(lhs + 27*num)) == 0 and c_ratio == -27,
       f"P6(tau(t))*(t+1)^6 = ({c_ratio}) * P6(t)")
# tau is an involution and its fixed points are t = -1 +- sqrt(-3)
tau_inv = simplify(cancel(tau.subs(t, tau)) - t)
fixed = simplify(expand(cancel(together(tau - t))*(t + 1)))
blk("A_tau.txt",
    f"tau(t) = {tau}\ntau(tau(t)) - t = {tau_inv}\n"
    f"fixed-point equation (numerator): {fixed}  ->  t = -1 +- sqrt(-3)\n"
    f"P6(tau(t))*(t+1)^6 / P6(t) = {c_ratio}\n"
    "geometric content: tau is the deck involution x -> -x of K_c -> P^1_(a:b);\n"
    "F0 is even in x, hence E_sigma (and so the 6 intersection points) is tau-stable.\n")
record("tau_involution", tau_inv == 0, "tau(tau(t)) = t")

# ------------------------------------------------------------- payload
json.dump({
    "kappa_plus": "(13 + 3*sqrt(33))/16",
    "kappa_minus": "(13 - 3*sqrt(33))/16",
    "P6_closed_form": "(kappa_plus+4)*(t^2-4)^3 - 64*(kappa_minus+4)*(t+1)^3",
    "P6_degree": int(deg),
    "P6_normalisation": "coefficients below are of the closed form; sympy's cleared numerator is 16x this",
    "P6_coeffs_ascending_sympy": [str(simplify(P6c_sym.coeff_monomial(t**k))) for k in range(7)],
    "P6_coeffs_ascending_K": [list(map(str, P6[k].c)) for k in range(7)],
    "K_basis": ["1", "sqrt(33)", "sqrt(-3)", "sqrt(33)*sqrt(-3)"],
    "tau": "(-t-4)/(t+1)",
    "tau_multiplier": -27,
    "param": {"a": "(t-2)(t+2)", "b": "-4(t+1)", "x": str(x_p)},
}, open(os.path.join(PAY, "A_sextic.json"), "w"), indent=1)

print(f"[section A] {sum(1 for _,p,_ in _out if p)}/{len(_out)} pass, {time.time()-t0:.1f}s")
sys.exit(0 if all(p for _, p, _ in _out) else 1)
