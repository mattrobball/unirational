#!/usr/bin/env python3
"""
Exact character-theoretic Molien-series computation for PSL(2,11) acting on
its 5-dimensional Weil representation W.

For d = 0..40 computes the multiplicities in Sym^d(W) of:
    I(d) = multiplicity of the trivial character
    A(d) = multiplicity of W itself
    J(d) = multiplicity of W* (the complex-conjugate 5-dim irrep)

Method
------
For a conjugacy class c with eigenvalue multiset {e_1,...,e_5} of a
representative acting on W, the character of Sym^d(W) on c is the complete
homogeneous symmetric function h_d(e_1,...,e_5): the coefficient of t^d in
the truncated power series product_i 1/(1 - e_i t).

Then, by the standard inner-product / orthogonality formula:
    I(d) = (1/|G|) * sum_c |c| * h_d(eigs_c)
    A(d) = (1/|G|) * sum_c |c| * h_d(eigs_c) * conj(chi_W(c))
    J(d) = (1/|G|) * sum_c |c| * h_d(eigs_c) * chi_W(c)

Exactness
---------
Eigenvalues are carried as exact sympy expressions: sign * exp(2*pi*I*a/n)
for small integers n, a. These are exact algebraic numbers; nothing is
floating point until the very last step. h_d is built by exact truncated
power-series convolution. Because sympy's Mul automatically combines
same-base powers of E, products of these roots of unity collapse back to a
single root of unity term rather than blowing up combinatorially, so the
whole pipeline stays in exact closed form.

The final I/A/J values are evaluated to 60 decimal digits (sympy.N) and
asserted to be within 1e-25 of a real integer -- far tighter than the
mandated 1e-9. Given the bounded algebraic complexity of these numbers
(all lie in Q(zeta_330), with denominators bounded by |G|=660), a 60-digit
numeric match to an integer is conclusive certification, not a heuristic.

As a second, fully independent check, the entire computation is repeated
from scratch with mpmath high-precision floating point (cos/sin based, a
different numeric code path from sympy's exact exp() objects), and all 123
values (41 d's x {I,A,J}) are compared against the sympy-derived integers.

No GAP / Sage / Magma / PARI used anywhere. Pure python3 + sympy + mpmath.
"""

import sys

try:
    import sympy
    from sympy import exp, pi, I, Rational, sqrt, Integer, conjugate as sconj
except ImportError:
    print("ABORT: sympy is required but is not importable in this environment.")
    sys.exit(1)

import mpmath

D_MAX = 40
EVALF_DIGITS = 60
CERT_TOL = 1e-25     # integrality-certification tolerance (mandated minimum: 1e-9)
CHECK_TOL = 1e-25    # sanity / power-map check tolerance

mpmath.mp.dps = EVALF_DIGITS + 10


def fail(msg):
    print("ABORT: " + msg)
    sys.exit(1)


# ----------------------------------------------------------------------
# Exact symbolic roots of unity
# ----------------------------------------------------------------------

def zeta(n, a):
    """Exact sympy value of e^{2 pi i a / n}, a reduced mod n."""
    a = a % n
    if a == 0:
        return Integer(1)
    return exp(2 * pi * I * Rational(a, n))


def eig_pow(eig, k):
    """eig = (sign, n, a) meaning sign * zeta(n, a). Returns eig-value ** k, exact."""
    sign, n, a = eig
    return (sign ** k) * zeta(n, (a * k) % n)


def eig_value(eig):
    return eig_pow(eig, 1)


def eig_values(cname):
    return [eig_value(e) for e in EIGS[cname]]


def eig_powers(cname, k):
    return [eig_pow(e, k) for e in EIGS[cname]]


def hi_prec(expr):
    return sympy.N(expr, EVALF_DIGITS)


def close(a, b, tol=CHECK_TOL):
    return abs(complex(hi_prec(a - b))) < tol


def multiset_matches(list_a, list_b, tol=CHECK_TOL):
    key = lambda z: (round(z.real, 8), round(z.imag, 8))
    va = sorted((complex(hi_prec(v)) for v in list_a), key=key)
    vb = sorted((complex(hi_prec(v)) for v in list_b), key=key)
    if len(va) != len(vb):
        return False
    return all(abs(x - y) < tol for x, y in zip(va, vb))


# ----------------------------------------------------------------------
# Group data (given by the task; not re-derived)
# ----------------------------------------------------------------------

ORDER = 660
CLASS_NAMES = ['1A', '2A', '3A', '5A', '5B', '6A', '11A', '11B']
SIZES = {'1A': 1, '2A': 55, '3A': 110, '5A': 132, '5B': 132, '6A': 110, '11A': 60, '11B': 60}

# Eigenvalues on W, as (sign, n, a) tuples meaning sign * e^{2 pi i a / n}
EIGS = {
    '1A':  [(1, 1, 0)] * 5,
    '2A':  [(1, 1, 0), (1, 1, 0), (1, 1, 0), (-1, 1, 0), (-1, 1, 0)],
    '3A':  [(1, 1, 0), (1, 3, 1), (1, 3, 1), (1, 3, 2), (1, 3, 2)],
    '5A':  [(1, 5, 0), (1, 5, 1), (1, 5, 2), (1, 5, 3), (1, 5, 4)],
    '5B':  [(1, 5, 0), (1, 5, 1), (1, 5, 2), (1, 5, 3), (1, 5, 4)],
    '6A':  [(1, 1, 0), (1, 3, 1), (1, 3, 2), (-1, 3, 1), (-1, 3, 2)],
    '11A': [(1, 11, 1), (1, 11, 3), (1, 11, 4), (1, 11, 5), (1, 11, 9)],
    '11B': [(1, 11, 2), (1, 11, 6), (1, 11, 7), (1, 11, 8), (1, 11, 10)],
}

CHI_W = {
    '1A': Integer(5),
    '2A': Integer(1),
    '3A': Integer(-1),
    '5A': Integer(0),
    '5B': Integer(0),
    '6A': Integer(1),
    '11A': Rational(-1, 2) + I * sqrt(11) / 2,
    '11B': Rational(-1, 2) - I * sqrt(11) / 2,
}

# ----------------------------------------------------------------------
# Sanity checks -- abort loudly if any fails
# ----------------------------------------------------------------------

print("=== Group-data sanity checks ===")

if sum(SIZES.values()) != ORDER:
    fail(f"class sizes sum to {sum(SIZES.values())}, expected {ORDER}")
print(f"[ok] class sizes sum to {ORDER}")

for c in CLASS_NAMES:
    if len(EIGS[c]) != 5:
        fail(f"class {c} has {len(EIGS[c])} eigenvalues, expected 5")
print("[ok] every class has exactly 5 eigenvalues")

for c in CLASS_NAMES:
    tr = sum(eig_value(e) for e in EIGS[c])
    if not close(tr, CHI_W[c]):
        fail(f"trace(eigs[{c}])={hi_prec(tr)} != chi_W({c})={hi_prec(CHI_W[c])}")
    print(f"[ok] trace(eigs[{c}]) == chi_W({c})  (= {hi_prec(tr)})")

if not multiset_matches([eig_value(e) for e in EIGS['11B']],
                         [sconj(eig_value(e)) for e in EIGS['11A']]):
    fail("eigs(11B) is not the multiset of complex conjugates of eigs(11A)")
print("[ok] eigs(11B) == conjugate(eigs(11A)) as multisets")

if not close(CHI_W['11B'], sconj(CHI_W['11A'])):
    fail("chi_W(11B) != conjugate(chi_W(11A))")
print("[ok] chi_W(11B) == conjugate(chi_W(11A))")

POWER_CHECKS = [
    ("6A^2 == 3A (squaring order-6 gives order-3 class)", eig_powers('6A', 2), eig_values('3A')),
    ("6A^3 == 2A (cubing order-6 gives order-2 class)",   eig_powers('6A', 3), eig_values('2A')),
    ("6A^6 == 1A", eig_powers('6A', 6), eig_values('1A')),
    ("3A^2 == 3A", eig_powers('3A', 2), eig_values('3A')),
    ("3A^3 == 1A", eig_powers('3A', 3), eig_values('1A')),
    ("2A^2 == 1A", eig_powers('2A', 2), eig_values('1A')),
    ("5A^2 == 5A", eig_powers('5A', 2), eig_values('5A')),
    ("5A^5 == 1A", eig_powers('5A', 5), eig_values('1A')),
    ("5B^2 == 5B", eig_powers('5B', 2), eig_values('5B')),
    ("5B^5 == 1A", eig_powers('5B', 5), eig_values('1A')),
    ("11A^11 == 1A", eig_powers('11A', 11), eig_values('1A')),
    ("11B^11 == 1A", eig_powers('11B', 11), eig_values('1A')),
]

for label, a, b in POWER_CHECKS:
    if not multiset_matches(a, b):
        fail(f"power-map closure failed: {label}")
    print(f"[ok] {label}")

print("=== All group-data sanity checks passed ===\n")

# ----------------------------------------------------------------------
# h_d(eigenvalues) per class, d = 0..D_MAX, via truncated power-series
# convolution of the 5 geometric series 1/(1 - e_i t)
# ----------------------------------------------------------------------

def class_h(cname):
    eigs = EIGS[cname]
    arrays = [[eig_pow(e, k) for k in range(D_MAX + 1)] for e in eigs]
    acc = arrays[0]
    for arr in arrays[1:]:
        new_acc = []
        for d in range(D_MAX + 1):
            s = 0
            for k in range(d + 1):
                s += acc[k] * arr[d - k]
            new_acc.append(sympy.expand(s))
        acc = new_acc
    return acc


print("=== Computing h_d per class (exact, d=0..40) ===")
H = {}
for c in CLASS_NAMES:
    H[c] = class_h(c)
    print(f"  done: {c}")
print()

# ----------------------------------------------------------------------
# I(d), A(d), J(d), exact, then certified-integer via high precision evalf
# ----------------------------------------------------------------------

I_exact, A_exact, J_exact = [], [], []
for d in range(D_MAX + 1):
    s_I = s_A = s_J = 0
    for c in CLASS_NAMES:
        hd = H[c][d]
        size = SIZES[c]
        chi = CHI_W[c]
        s_I += size * hd
        s_A += size * hd * sconj(chi)
        s_J += size * hd * chi
    I_exact.append(sympy.expand(s_I / ORDER))
    A_exact.append(sympy.expand(s_A / ORDER))
    J_exact.append(sympy.expand(s_J / ORDER))


def certify_integer(expr, label):
    val = complex(hi_prec(expr))
    if abs(val.imag) > CERT_TOL:
        fail(f"{label} has non-negligible imaginary part: {val}")
    r = round(val.real)
    if abs(val.real - r) > CERT_TOL:
        fail(f"{label} is not an integer to {EVALF_DIGITS}-digit precision: {val}")
    return r


print("=== Certifying I(d), A(d), J(d) are integers (60-digit precision) ===")
I_int = [certify_integer(I_exact[d], f"I({d})") for d in range(D_MAX + 1)]
A_int = [certify_integer(A_exact[d], f"A({d})") for d in range(D_MAX + 1)]
J_int = [certify_integer(J_exact[d], f"J({d})") for d in range(D_MAX + 1)]
print("[ok] all 123 values (I,A,J for d=0..40) certified integer to 60 digits\n")

print("=== Non-negativity check (multiplicities must be >= 0) ===")
for label, arr in (("I", I_int), ("A", A_int), ("J", J_int)):
    for d, v in enumerate(arr):
        if v < 0:
            fail(f"{label}({d}) = {v} is negative -- impossible for a multiplicity")
print("[ok] all 123 values are >= 0\n")

# ----------------------------------------------------------------------
# MANDATORY anchors
# ----------------------------------------------------------------------

print("=== Mandatory anchors ===")
ANCHORS = [
    ("I(0)", I_int[0], 1),
    ("I(1)", I_int[1], 0),
    ("I(2)", I_int[2], 0),
    ("I(3)", I_int[3], 1),
    ("A(3)", A_int[3], 0),
    ("A(4)", A_int[4], 2),
    ("A(5)", A_int[5], 1),
    ("A(25)", A_int[25], 189),
    ("A(34)", A_int[34], 576),
    ("J(2)", J_int[2], 1),
    ("J(4)", J_int[4], 1),
]
anchors_ok = True
for name, actual, expected in ANCHORS:
    ok = (actual == expected)
    anchors_ok &= ok
    print(f"[{'ok' if ok else 'FAIL'}] {name} = {actual}  (expected {expected})")
if not anchors_ok:
    fail("one or more MANDATORY anchors failed -- see above")
print("=== All mandatory anchors passed ===\n")

# ----------------------------------------------------------------------
# Independent cross-check: identical computation via mpmath high-precision
# floating point (cos/sin based), a wholly separate numeric code path.
# ----------------------------------------------------------------------

print("=== Independent mpmath cross-check ===")


def mp_zeta(n, a):
    a = a % n
    if a == 0:
        return mpmath.mpc(1, 0)
    ang = 2 * mpmath.pi * a / n
    return mpmath.mpc(mpmath.cos(ang), mpmath.sin(ang))


def mp_eig_pow(eig, k):
    sign, n, a = eig
    return (sign ** k) * mp_zeta(n, (a * k) % n)


def mp_class_h(cname):
    eigs = EIGS[cname]
    arrays = [[mp_eig_pow(e, k) for k in range(D_MAX + 1)] for e in eigs]
    acc = arrays[0]
    for arr in arrays[1:]:
        new_acc = []
        for d in range(D_MAX + 1):
            s = mpmath.mpc(0, 0)
            for k in range(d + 1):
                s += acc[k] * arr[d - k]
            new_acc.append(s)
        acc = new_acc
    return acc


MP_CHI_W = {
    '1A': mpmath.mpc(5, 0), '2A': mpmath.mpc(1, 0), '3A': mpmath.mpc(-1, 0),
    '5A': mpmath.mpc(0, 0), '5B': mpmath.mpc(0, 0), '6A': mpmath.mpc(1, 0),
    '11A': mpmath.mpc(-1, 0) / 2 + mpmath.mpc(0, 1) * mpmath.sqrt(11) / 2,
    '11B': mpmath.mpc(-1, 0) / 2 - mpmath.mpc(0, 1) * mpmath.sqrt(11) / 2,
}

MP_H = {c: mp_class_h(c) for c in CLASS_NAMES}

mismatch = False
for d in range(D_MAX + 1):
    s_I = s_A = s_J = mpmath.mpc(0, 0)
    for c in CLASS_NAMES:
        hd = MP_H[c][d]
        size = SIZES[c]
        chi = MP_CHI_W[c]
        s_I += size * hd
        s_A += size * hd * mpmath.conj(chi)
        s_J += size * hd * chi
    mp_I, mp_A, mp_J = s_I / ORDER, s_A / ORDER, s_J / ORDER
    for label, mpv, sv in (("I", mp_I, I_int[d]), ("A", mp_A, A_int[d]), ("J", mp_J, J_int[d])):
        if abs(mpv.real - sv) > 1e-20 or abs(mpv.imag) > 1e-20:
            print(f"MISMATCH {label}({d}): sympy={sv} mpmath={mpv}")
            mismatch = True

if mismatch:
    fail("sympy and mpmath computations disagree -- see MISMATCH lines above")
print("[ok] mpmath cross-check agrees with sympy computation for all d=0..40, I/A/J\n")

# ----------------------------------------------------------------------
# Final table and summary
# ----------------------------------------------------------------------

print("=== Table: d, I(d), A(d), J(d),  d = 0..40 ===")
print(f"{'d':>3}  {'I(d)':>6}  {'A(d)':>6}  {'J(d)':>6}")
for d in range(D_MAX + 1):
    print(f"{d:>3}  {I_int[d]:>6}  {A_int[d]:>6}  {J_int[d]:>6}")

E = [d for d in range(1, D_MAX + 1) if I_int[d] > 0]
print(f"\nE = {{d in [1,40] : I(d) > 0}} = {E}")

smallest_not_div3 = next((d for d in E if d % 3 != 0), None)
print(f"Smallest element of E not divisible by 3: {smallest_not_div3}")
print(f"4 in E: {4 in E}")
print(f"5 in E: {5 in E}")
print(f"11 in E: {11 in E}")

print("\n=== DONE ===")
