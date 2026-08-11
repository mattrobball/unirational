#!/usr/bin/env python3
"""
Exact character-theoretic dimension table for G = PSL(2,11) acting on its
5-dimensional complex irreducible representation W.

Data used (as supplied, not looked up elsewhere):
  |G| = 660.  Eight conjugacy classes with sizes
      1A:1, 2A:55, 3A:110, 5A:132, 5B:132, 6A:110, 11A:60, 11B:60
  and eigenvalue multisets of a class representative acting on W:
      1A : (1,1,1,1,1)
      2A : (1,1,1,-1,-1)
      3A : (1, w3, w3, w3^2, w3^2)
      5A : all five 5th roots of unity, each once
      5B : same as 5A
      6A : derived below from the power-map character values
           chi(g^j), j=0..5 = (5,1,-1,1,-1,1) via the discrete Fourier formula
      11A: (z^1, z^3, z^4, z^5, z^9)   z = primitive 11th root of unity
      11B: (z^2, z^6, z^7, z^8, z^10)

EXACT ARITHMETIC STRATEGY
--------------------------
Every element order occurring above (1,2,3,5,6,11) divides
    N = lcm(1,2,3,5,6,11) = 330.
So every eigenvalue of every class representative can be written as an exact
power of a single primitive 330th root of unity Z = exp(2*pi*i/330).  We do
all algebra inside the single number field

    Q(zeta_330) = Q[z] / (Phi_330(z))      (Phi_330 = 330th cyclotomic
                                             polynomial, degree phi(330)=80)

represented as sympy Poly objects over QQ, reduced modulo Phi_330(z) after
every multiplication.  Because z is forced to satisfy exactly the minimal
polynomial of a primitive 330th root of unity (no smaller-order relation is
imposed), this is fully exact -- no floating point enters the computation of
I(k), C(k), DF(k).  Inversion of a root of unity is trivial and exact:
1/Z^e = Z^(-e mod 330), so no field inversion algorithm is even needed.

A final result is "rational" (an actual dimension) exactly when its reduced
Poly representative has degree 0 (no z-dependence at all); we check this
explicitly for every reported number, which doubles as a strong internal
correctness check of the whole computation.

mpmath high-precision floating point (mp.dps = 40) is used ONLY as an
independent cross-check at the very end (k <= 8), never as the source of
truth for the exact table.
"""

import sys
import sympy as sp
from sympy import symbols, Poly, Rational, cyclotomic_poly
import mpmath

mpmath.mp.dps = 40


def mp_root_of_unity(e_, n=330):
    """exp(2*pi*i*e_/n) computed entirely at mpmath working precision (no
    Python double-precision float ever enters this computation: e_ and n are
    combined as an exact mpmath fraction before the transcendental call)."""
    return mpmath.expjpi(2 * mpmath.mpf(e_) / mpmath.mpf(n))

# ---------------------------------------------------------------------
# 0. The cyclotomic field Q(zeta_330) as Q[z]/(Phi_330(z))
# ---------------------------------------------------------------------
z = symbols('z')
N = 330  # lcm(1,2,3,5,6,11)
Phi = Poly(cyclotomic_poly(N, z), z, domain='QQ')
DEG = Phi.degree()
print(f"# Working in Q(zeta_{N}) = Q[z]/(Phi_{N}(z)), deg Phi_{N} = {DEG}")

_zpow_cache = {}


def zpow(e):
    """Exact reduced Poly representative of z**e (mod Phi_330), e any integer."""
    e = e % N
    if e in _zpow_cache:
        return _zpow_cache[e]
    if e == 0:
        p = Poly(1, z, domain='QQ')
    else:
        p = (zpow(e - 1) * Poly(z, z, domain='QQ')).rem(Phi)
    _zpow_cache[e] = p
    return p


for _e in range(N):
    zpow(_e)  # precompute / warm cache


def const_poly(c):
    return Poly(Rational(c), z, domain='QQ')


ZERO = const_poly(0)
ONE = const_poly(1)


def pmul(a, b):
    return (a * b).rem(Phi)


def pscale(c, a):
    return (a * Rational(c)).rem(Phi)


def to_rational(p):
    """Convert a reduced Poly that MUST be a pure rational number (no z
    dependence) into a sympy Rational. Raises if it actually has nontrivial
    z-dependence (i.e. is not in fact rational)."""
    p = p.rem(Phi)
    expr = sp.nsimplify(p.as_expr())
    if expr.free_symbols:
        raise ValueError(f"Expected a rational number, got a genuine element "
                          f"of Q(zeta_{N}): {expr}")
    return sp.Rational(expr)


def esym(vals):
    """Elementary symmetric polynomials e_0..e_5 of a length-5 list of Poly
    values, via the standard incremental product-expansion algorithm."""
    e = [ONE] + [ZERO] * 5
    for v in vals:
        for k in range(5, 0, -1):
            e[k] = e[k] + pmul(v, e[k - 1])
    return e


def hseries(e, kmax):
    """Complete homogeneous symmetric functions h_0..h_kmax of the 5 values
    whose elementary symmetric functions are e[1..5], via the classical
    recurrence h_k = sum_{i=1}^{min(k,5)} (-1)^(i+1) e_i h_{k-i}."""
    h = [ONE]
    for k in range(1, kmax + 1):
        acc = ZERO
        for i in range(1, min(k, 5) + 1):
            term = pmul(e[i], h[k - i])
            if i % 2 == 0:
                term = pscale(-1, term)
            acc = acc + term
        h.append(acc.rem(Phi))
    return h


KMAX = 24

# ---------------------------------------------------------------------
# 1. Conjugacy class data: eigenvalue exponents as powers of Z = zeta_330
# ---------------------------------------------------------------------
# 330/1=330 330/2=165 330/3=110 330/5=66 330/6=55 330/11=30
classes = [
    dict(name="1A", size=1, exps=[0, 0, 0, 0, 0], chiW_expected=5),
    dict(name="2A", size=55, exps=[0, 0, 0, 165, 165], chiW_expected=1),
    dict(name="3A", size=110, exps=[0, 110, 110, 220, 220], chiW_expected=-1),
    dict(name="5A", size=132, exps=[0, 66, 132, 198, 264], chiW_expected=0),
    dict(name="5B", size=132, exps=[0, 66, 132, 198, 264], chiW_expected=0),
    dict(name="6A", size=110, exps=None, chiW_expected=1),          # derived below
    dict(name="11A", size=60, exps=[30, 90, 120, 150, 270], chiW_expected=None),  # (-1+sqrt(-11))/2
    dict(name="11B", size=60, exps=[60, 180, 210, 240, 300], chiW_expected=None),  # (-1-sqrt(-11))/2
]

assert sum(c['size'] for c in classes) == 660, "class sizes must sum to |G|=660"
print(f"# sum of class sizes = {sum(c['size'] for c in classes)}  (must be 660)  OK")

# ---------------------------------------------------------------------
# 2. Derive the 6A eigenvalues from the power-map character values via the
#    discrete Fourier formula:  mult(w6^m) = (1/6) sum_j chi(g^j) w6^(-m j)
# ---------------------------------------------------------------------
chi_powers_6A = [5, 1, -1, 1, -1, 1]  # chi(g^j), j = 0..5   (given)
w6_step = N // 6  # = 55 ;  w6 = Z^55

print("\n# --- Deriving 6A eigenvalues from power-map character values ---")
mult6 = []
for m in range(6):
    acc = ZERO
    for j in range(6):
        term = pscale(chi_powers_6A[j], zpow(-w6_step * m * j))
        acc = acc + term
    acc = pscale(Rational(1, 6), acc)
    val = to_rational(acc)
    mult6.append(val)
    print(f"  mult(w6^{m}) = {val}")

assert all(v == int(v) and v >= 0 for v in mult6), "multiplicities must be nonnegative integers"
assert sum(mult6) == 5, f"multiplicities must sum to 5, got {sum(mult6)}"
print("  sum of multiplicities = 5   OK")

exps_6A = []
label_6A = []
for m in range(6):
    cnt = int(mult6[m])
    exps_6A += [w6_step * m] * cnt
    label_6A += [f"zeta6^{m}"] * cnt
assert len(exps_6A) == 5
classes[5]['exps'] = exps_6A
print(f"  derived 6A eigenvalue multiset (as powers of primitive 6th root zeta6): {label_6A}")

# Print numeric (mpmath) values of the derived 6A eigenvalues for readability
num_6A = [mp_root_of_unity(e_, N) for e_ in exps_6A]
print("  numeric values: " + ", ".join(
    f"{complex(v).real:+.6f}{complex(v).imag:+.6f}i" for v in num_6A))

# ---------------------------------------------------------------------
# 3. Per-class exact algebra: L_i (eigenvalues on W), M_i = 1/L_i
#    (eigenvalues on W^dual), chi_W(g), e_i(M), h_k(M)
# ---------------------------------------------------------------------
print("\n# --- Per-class exact data ---")
for c in classes:
    Lp = [zpow(e_) for e_ in c['exps']]
    Mp = [zpow(-e_) for e_ in c['exps']]  # exact inverses: 1/Z^e = Z^(-e)
    chiW = ZERO
    for L in Lp:
        chiW = chiW + L
    chiW = chiW.rem(Phi)
    chiWdual = ZERO
    for M in Mp:
        chiWdual = chiWdual + M
    chiWdual = chiWdual.rem(Phi)

    c['Lp'] = Lp
    c['Mp'] = Mp
    c['chiW_poly'] = chiW
    c['chiWdual_poly'] = chiWdual
    c['e_of_M'] = esym(Mp)
    c['h_of_M'] = hseries(c['e_of_M'], KMAX)

    # sanity check: sum of eigenvalues == known chi_W value, for the classes
    # where that value is rational
    if c['chiW_expected'] is not None:
        got = to_rational(chiW)
        status = "PASS" if got == c['chiW_expected'] else "FAIL"
        print(f"  {c['name']}: chi_W = {got}  (expected {c['chiW_expected']})  [{status}]")
        assert status == "PASS", f"chi_W mismatch for class {c['name']}"
    else:
        print(f"  {c['name']}: chi_W is a genuine element of Q(zeta_11) "
              f"(checked exactly below via (2*chi_W+1)^2 = -11, and numerically)")

# ---------------------------------------------------------------------
# 4. Exact sanity check for 11A / 11B:  (2*chi_W(g)+1)^2 == -11
#    (this is the exact algebraic identity behind chi_W = (-1 +/- sqrt(-11))/2)
# ---------------------------------------------------------------------
print("\n# --- Exact quadratic identity check for 11A / 11B ---")
for c in classes:
    if c['name'] not in ("11A", "11B"):
        continue
    val = pscale(2, c['chiW_poly']) + ONE
    sq = pmul(val, val)
    got = to_rational(sq)
    status = "PASS" if got == -11 else "FAIL"
    print(f"  {c['name']}: (2*chi_W+1)^2 = {got}  (expected -11)  [{status}]")
    assert status == "PASS"

# Numeric (mpmath) sign check to confirm the 11A/11B <-> +/-sqrt(-11) labeling
print("\n# --- Numeric (mpmath, sanity only) sign check for 11A / 11B ---")
sqrt_m11 = mpmath.sqrt(mpmath.mpc(-11))  # principal branch, positive imaginary part
expected_11A = (-1 + sqrt_m11) / 2
expected_11B = (-1 - sqrt_m11) / 2
for c in classes:
    if c['name'] not in ("11A", "11B"):
        continue
    numval = mpmath.mpc(0)
    for e_ in c['exps']:
        numval += mp_root_of_unity(e_, N)
    exp_val = expected_11A if c['name'] == "11A" else expected_11B
    diff = abs(numval - exp_val)
    status = "PASS" if diff < mpmath.mpf(10) ** -30 else "FAIL"
    print(f"  {c['name']}: numeric chi_W = {complex(numval)!r}, "
          f"expected {complex(exp_val)!r}, |diff| = {mpmath.nstr(diff, 5)}  [{status}]")
    assert status == "PASS"

# ---------------------------------------------------------------------
# 5. Orthonormality:  (1/660) * sum_classes |C| * |chi_W(g)|^2 == 1
# ---------------------------------------------------------------------
print("\n# --- Orthonormality check ---")
orth_acc = ZERO
for c in classes:
    term = pmul(c['chiW_poly'], c['chiWdual_poly'])
    term = pscale(c['size'], term)
    orth_acc = orth_acc + term
orth_acc = pscale(Rational(1, 660), orth_acc)
orth_val = to_rational(orth_acc)
status = "PASS" if orth_val == 1 else "FAIL"
print(f"  (1/660) * sum |C| * |chi_W|^2 = {orth_val}  [{status}]")
assert status == "PASS"

# ---------------------------------------------------------------------
# 6. I(k) and C(k), k = 0..KMAX, exact
# ---------------------------------------------------------------------
print("\n# --- Computing I(k), C(k) exactly for k = 0..%d ---" % KMAX)
I = []
C = []
for k in range(KMAX + 1):
    Iacc = ZERO
    Cacc = ZERO
    for c in classes:
        hk = c['h_of_M'][k]
        Iacc = Iacc + pscale(c['size'], hk)
        Cacc = Cacc + pscale(c['size'], pmul(hk, c['chiW_poly']))
    Iacc = pscale(Rational(1, 660), Iacc)
    Cacc = pscale(Rational(1, 660), Cacc)
    Ik = to_rational(Iacc)
    Ck = to_rational(Cacc)
    assert Ik.is_Integer and Ik >= 0, f"I({k}) = {Ik} is not a nonnegative integer!"
    assert Ck.is_Integer and Ck >= 0, f"C({k}) = {Ck} is not a nonnegative integer!"
    I.append(int(Ik))
    C.append(int(Ck))

DF = []
for k in range(KMAX + 1):
    if k == 0:
        DF.append(C[0])
    else:
        DF.append(C[k] - I[k - 1])

# ---------------------------------------------------------------------
# 7. Targeted cross-checks required by spec
# ---------------------------------------------------------------------
print("\n# --- Targeted cross-checks ---")
checks = []
checks.append(("I(0)==1", I[0] == 1))
checks.append(("I(1)==0", I[1] == 0))
checks.append(("I(2)==0", I[2] == 0))
checks.append(("I(3)==1", I[3] == 1))
checks.append(("C(0)==0", C[0] == 0))
checks.append(("C(1)==1", C[1] == 1))
for name, ok in checks:
    print(f"  {name}: {'PASS' if ok else 'FAIL'}")
all_targeted_ok = all(ok for _, ok in checks)

# ---------------------------------------------------------------------
# 8. Independent high-precision mpmath cross-check for k <= 8
# ---------------------------------------------------------------------
print("\n# --- Independent mpmath (mp.dps=40) cross-check, k = 0..8 ---")


def hseries_mp(e, kmax):
    h = [mpmath.mpc(1)]
    for k in range(1, kmax + 1):
        acc = mpmath.mpc(0)
        for i in range(1, min(k, 5) + 1):
            term = e[i] * h[k - i]
            if i % 2 == 0:
                term = -term
            acc += term
        h.append(acc)
    return h


def esym_mp(vals):
    e = [mpmath.mpc(1)] + [mpmath.mpc(0)] * 5
    for v in vals:
        for k in range(5, 0, -1):
            e[k] = e[k] + v * e[k - 1]
    return e


mp_data = []
for c in classes:
    Lmp = [mp_root_of_unity(e_, N) for e_ in c['exps']]
    Mmp = [1 / L for L in Lmp]
    chiW_mp = sum(Lmp)
    e_mp = esym_mp(Mmp)
    h_mp = hseries_mp(e_mp, 8)
    mp_data.append((c['size'], chiW_mp, h_mp))

max_err_I = mpmath.mpf(0)
max_err_C = mpmath.mpf(0)
print(f"  {'k':>2}  {'I(k) exact':>10}  {'I(k) mpmath':>28}  {'C(k) exact':>10}  {'C(k) mpmath':>28}")
for k in range(9):
    Iacc_mp = mpmath.mpc(0)
    Cacc_mp = mpmath.mpc(0)
    for size, chiW_mp, h_mp in mp_data:
        Iacc_mp += size * h_mp[k]
        Cacc_mp += size * h_mp[k] * chiW_mp
    Iacc_mp /= 660
    Cacc_mp /= 660
    err_I = abs(Iacc_mp - I[k])
    err_C = abs(Cacc_mp - C[k])
    max_err_I = max(max_err_I, err_I)
    max_err_C = max(max_err_C, err_C)
    print(f"  {k:>2}  {I[k]:>10d}  {mpmath.nstr(Iacc_mp, 25):>28}  "
          f"{C[k]:>10d}  {mpmath.nstr(Cacc_mp, 25):>28}")

tol = mpmath.mpf(10) ** -25
mp_status = "PASS" if (max_err_I < tol and max_err_C < tol) else "FAIL"
print(f"  max|I_exact-I_mpmath| = {mpmath.nstr(max_err_I, 5)}, "
      f"max|C_exact-C_mpmath| = {mpmath.nstr(max_err_C, 5)}  [{mp_status}]")

# ---------------------------------------------------------------------
# 9. Final table
# ---------------------------------------------------------------------
print("\n# --- Final table ---\n")
print("| k  | I(k) | C(k) | DF(k) |")
print("|----|------|------|-------|")
for k in range(KMAX + 1):
    print(f"| {k:<2} | {I[k]:<4} | {C[k]:<4} | {DF[k]:<5} |")

# ---------------------------------------------------------------------
# 10. Extra requested values
# ---------------------------------------------------------------------
smallest_k_gt1_Cpos = None
for k in range(2, KMAX + 1):
    if C[k] > 0:
        smallest_k_gt1_Cpos = k
        break

smallest_k_beyond3_Ipos = None
for k in range(4, KMAX + 1):
    if I[k] > 0:
        smallest_k_beyond3_Ipos = k
        break

print("\n# --- Extra requested values ---")
print(f"  smallest k>1 with C(k)>0: {smallest_k_gt1_Cpos}")
print(f"  smallest k with I(k)>0 beyond k=3: {smallest_k_beyond3_Ipos}")
for k in [2, 4, 6, 8, 10, 12, 14, 16]:
    print(f"  k={k:2d}:  C(k)={C[k]:4d}  DF(k)={DF[k]:4d}")

# ---------------------------------------------------------------------
# 11. RESULT
# ---------------------------------------------------------------------
overall_ok = all_targeted_ok and (mp_status == "PASS")
print()
if overall_ok:
    print("RESULT: PASS")
    sys.exit(0)
else:
    print("RESULT: FAIL")
    sys.exit(1)
