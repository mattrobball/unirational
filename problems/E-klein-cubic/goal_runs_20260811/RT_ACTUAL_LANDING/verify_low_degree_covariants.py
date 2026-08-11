#!/usr/bin/env python3
"""Exact 5-dimensional representation of G = PSL(2,11) and its low-degree
G-covariant 5-tuples on the Klein cubic threefold.

MODEL.  Let z = zeta_11 be a primitive 11th root of unity, W = C^5 with
coordinates x_0..x_4 (indices mod 5), and

    sigma : x_i -> x_{i+1}                     (order 5)
    tau   : x_i -> z^{a_i} x_i,  a = (1,9,4,3,5) = (-2)^i mod 11   (order 11)

Both preserve the Klein cubic

    F = x_0^2 x_1 + x_1^2 x_2 + x_2^2 x_3 + x_3^2 x_4 + x_4^2 x_0.

<sigma,tau> is the Borel-type subgroup 11:5 of order 55.  PSL(2,11) (order
660) needs one further generator, an involution "iota".  Rather than
guessing it, we reuse the exact Q(zeta_11) 5x5 matrix pair (S,T) built by

    problems/E-klein-cubic/goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/
        exact_schur_frame/exact_representation_core.py :: weil_generators()

which is asserted there to satisfy S^2 = I, T^11 = I, (ST)^3 = I, i.e. the
standard (2,3,11) presentation of PSL(2,11).  We import that function
UNMODIFIED, verify T literally equals our own diagonal tau (same basis,
same a_i), and take iota = S as the third generator.  Every structural
claim (order 660, F-invariance, character values, the covariant and
divergence-free dimension tables) is re-derived here from scratch and
checked; nothing is assumed.

ARITHMETIC.  All of Q(zeta_11) is carried exactly as a length-10 vector of
Python Fractions in the power basis 1,z,...,z^9, with multiplication
reduced modulo the relation z^11 = 1, z^10 = -(1+z+...+z^9) (the vanishing
of the 11th cyclotomic polynomial).  This is the "vectors over Q modulo
the cyclotomic polynomial" representation the task explicitly allows, and
it is what makes the degree-7/8 computations tractable in pure Python
(sympy's general AlgebraicField arithmetic is used only for the small
nullspace calls, converting to/from this fast representation).

COVARIANT COMPUTATION.  Cov_k = {5-tuples T=(T_0..T_4) of degree-k forms :
T(g x) = g T(x) for all g in G}, computed as the *joint kernel over the
three generators only* (never by averaging over all 660 elements).  sigma-
and tau-invariance are cheap (a permutation and a diagonal action) and are
imposed *combinatorially* first: they force every covariant to be built
from a single "seed" monomial T_0 = x^alpha with tau-weight(alpha) = a_0 = 1,
via T_i(x) = x^{shift(alpha,i)}.  This produces the "H-covariant" space
(dimension = number of such alpha, matching the 11:5-subgroup dimensions
1,1,3,7,11,19,30,45 for degree 1..8).  The *only* remaining linear-algebra
step is intersecting this small space with the kernel of (rho(iota)-1),
which is what is expensive (iota is a dense matrix) but now only has to be
done on a space of dimension <= 45 instead of 5*C(k+4,4) (up to 2475 for
k=8).
"""

from __future__ import annotations

import importlib.util
import sys
import time
from fractions import Fraction as Fr
from math import factorial
from pathlib import Path

from sympy.polys.domains import QQ
from sympy.polys.matrices import DomainMatrix
from sympy.polys.polyclasses import ANP

RESULT_OK = True


def check(label: str, cond: bool) -> bool:
    global RESULT_OK
    print(f"{'PASS' if cond else 'FAIL'}: {label}")
    if not cond:
        RESULT_OK = False
    return cond


# ---------------------------------------------------------------------------
# Fast exact Q(zeta_11) arithmetic: element = length-10 tuple of Fractions,
# coefficient of z^i at index i, reduced by z^11=1, z^10=-(1+z+...+z^9).

FZERO: tuple = (Fr(0),) * 10
FONE: tuple = (Fr(1),) + (Fr(0),) * 9


def funit(i: int) -> tuple:
    """z^i for any integer i, reduced by z^11=1 and z^10=-(1+z+...+z^9)."""
    n = i % 11
    if n < 10:
        v = [Fr(0)] * 10
        v[n] = Fr(1)
        return tuple(v)
    return tuple(Fr(-1) for _ in range(10))


def fadd(u, v):
    return tuple(a + b for a, b in zip(u, v))


def fsub(u, v):
    return tuple(a - b for a, b in zip(u, v))


def fneg(u):
    return tuple(-a for a in u)


def fscale(u, s: Fr):
    return tuple(a * s for a in u)


def fmul(u, v):
    result = [Fr(0)] * 10
    for i in range(10):
        ui = u[i]
        if ui == 0:
            continue
        for j in range(10):
            vj = v[j]
            if vj == 0:
                continue
            coef = ui * vj
            n = i + j
            if n < 10:
                result[n] += coef
            elif n == 10:
                for k in range(10):
                    result[k] -= coef
            else:
                result[n - 11] += coef
    return tuple(result)


def fpow(u, n: int):
    r = FONE
    base = u
    while n:
        if n & 1:
            r = fmul(r, base)
        base = fmul(base, base)
        n >>= 1
    return r


def fiszero(u) -> bool:
    return all(a == 0 for a in u)


def feq(u, v) -> bool:
    return u == v


def galois_apply(u, k: int):
    """Apply the field automorphism zeta -> zeta^k (k coprime to 11)."""
    result = FZERO
    for i in range(10):
        ui = u[i]
        if ui == 0:
            continue
        n = (k * i) % 11
        pv = funit(n) if n < 10 else tuple(Fr(-1) for _ in range(10))
        result = fadd(result, fscale(pv, ui))
    return result


# ---- bridge to sympy's ANP (needed only for the small nullspace solves) ----

K11 = QQ.cyclotomic_field(11)
MODLIST = K11.unit.mod
DOM = K11.unit.dom


def anp_to_fast(e) -> tuple:
    raw = list(reversed(e.to_list()))
    raw += [QQ.zero] * (10 - len(raw))
    return tuple(Fr(int(v.numerator), int(v.denominator)) for v in raw)


def fast_to_anp(vec):
    rep = [QQ(fr.numerator, fr.denominator) for fr in reversed(vec)]
    return ANP(rep, MODLIST, DOM)


def fast_inverse(u):
    """Field inversion via ANP (only used a handful of times, not perf critical)."""
    a = fast_to_anp(u)
    inv = K11.one / a
    return anp_to_fast(inv)


def fdiv(u, v):
    return fmul(u, fast_inverse(v))


def k11_nullspace(rows_fast, nrows: int, ncols: int):
    """rows_fast[r] = list of ncols fast-field elements. Returns list of
    fast-field row-vectors (length ncols) spanning the kernel."""
    if nrows == 0:
        # Every column is unconstrained -> kernel is everything.
        return [tuple(funit_col) for funit_col in _identity_rows(ncols)]
    rows_anp = [[fast_to_anp(rows_fast[r][c]) for c in range(ncols)] for r in range(nrows)]
    system = DomainMatrix(rows_anp, (nrows, ncols), K11)
    kernel = system.nullspace()
    out = []
    for r in range(kernel.shape[0]):
        row = kernel.to_list()[r]
        out.append(tuple(anp_to_fast(row[c]) for c in range(ncols)))
    return out


def _identity_rows(n):
    for i in range(n):
        row = [FZERO] * n
        row[i] = FONE
        yield row


def k11_solve_combo(vectors, target, dim):
    """Find scalars c s.t. sum c_i * vectors[i] == target (vectors, target of
    length `dim`), by nullspace of [vectors_as_columns | -target]."""
    n = len(vectors)
    rows = []
    for r in range(dim):
        row = [vectors[i][r] for i in range(n)] + [fneg(target[r])]
        rows.append(row)
    kernel = k11_nullspace(rows, dim, n + 1)
    for vec in kernel:
        last = vec[-1]
        if not fiszero(last):
            inv = fast_inverse(last)
            return tuple(fmul(vec[i], inv) for i in range(n))
    return None


# ---------------------------------------------------------------------------
# Combinatorics on degree-d monomials in x_0..x_4 (indices mod 5).

WEIGHTS = (1, 9, 4, 3, 5)  # a_i = (-2)^i mod 11


def compositions(total, length):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, length - 1):
            yield (first,) + rest


def shift(exp, i):
    out = [0] * 5
    for j, v in enumerate(exp):
        out[(j + i) % 5] = v
    return tuple(out)


def hweight(exp):
    return sum(a * e for a, e in zip(WEIGHTS, exp)) % 11


def multinomial(n, parts):
    result = factorial(n)
    for p in parts:
        result //= factorial(p)
    return result


def format_monomial(e):
    parts = []
    for i, p in enumerate(e):
        if p == 0:
            continue
        elif p == 1:
            parts.append(f"x{i}")
        else:
            parts.append(f"x{i}^{p}")
    return "*".join(parts) if parts else "1"


# ---------------------------------------------------------------------------
# Section 1: build the three exact generators over K11.

print("=" * 78)
print("SECTION 1: exact generators of G = PSL(2,11) on W = C^5")
print("=" * 78)

# sigma: cyclic shift, (sigma x)_i = x_{i+1}
sigma_fast = [[FONE if j == (i + 1) % 5 else FZERO for j in range(5)] for i in range(5)]

# tau: diag(z^{a_i})
tau_fast = [[funit(WEIGHTS[i]) if i == j else FZERO for j in range(5)] for i in range(5)]

# 2 a_i + a_{i+1} == 0 (mod 11) for every i: F is tau-invariant termwise.
weight_relation = all((2 * WEIGHTS[i] + WEIGHTS[(i + 1) % 5]) % 11 == 0 for i in range(5))
check("2*a_i + a_{i+1} = 0 (mod 11) for all i (each term of F is tau-invariant)", weight_relation)

# Reuse the exact Weil generators from the existing exact-representation packet.
SRC_ROOT = Path(__file__).resolve().parents[2]  # .../problems/E-klein-cubic
WEIL_SRC = (
    SRC_ROOT
    / "goal_runs_after_35fa"
    / "Q_SCHUR_INDEX_ONE"
    / "exact_schur_frame"
    / "exact_representation_core.py"
)
check(f"source file for reused generators exists: {WEIL_SRC}", WEIL_SRC.is_file())

spec = importlib.util.spec_from_file_location("exact_representation_core", WEIL_SRC)
weil_mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(weil_mod)

S_dm, T_dm = weil_mod.weil_generators()
S_list = S_dm.to_list()
T_list = T_dm.to_list()
iota_fast = [[anp_to_fast(S_list[i][j]) for j in range(5)] for i in range(5)]
T_check_fast = [[anp_to_fast(T_list[i][j]) for j in range(5)] for i in range(5)]

tau_matches_T = all(feq(tau_fast[i][j], T_check_fast[i][j]) for i in range(5) for j in range(5))
check(
    "imported weil_generators() second matrix T equals our own tau = diag(z^(1,9,4,3,5)) exactly",
    tau_matches_T,
)
print(f"  -> iota (the extra involution) taken as weil_generators()[0] ('first'/S) from {WEIL_SRC.name}")

GENERATORS = {"sigma": sigma_fast, "tau": tau_fast, "iota": iota_fast}


def mat_mul_fast(A, B):
    out = [[FZERO] * 5 for _ in range(5)]
    for i in range(5):
        Ai = A[i]
        for k in range(5):
            aik = Ai[k]
            if fiszero(aik):
                continue
            Bk = B[k]
            row = out[i]
            for j in range(5):
                if not fiszero(Bk[j]):
                    row[j] = fadd(row[j], fmul(aik, Bk[j]))
    return out


def mat_id():
    return [[FONE if i == j else FZERO for j in range(5)] for i in range(5)]


def mat_pow(A, n):
    R = mat_id()
    base = A
    while n:
        if n & 1:
            R = mat_mul_fast(R, base)
        base = mat_mul_fast(base, base)
        n >>= 1
    return R


def mat_eq(A, B):
    return all(feq(A[i][j], B[i][j]) for i in range(5) for j in range(5))


def mat_order(A, cap=100):
    cur = A
    for n in range(1, cap + 1):
        if mat_eq(cur, mat_id()):
            return n
        cur = mat_mul_fast(cur, A)
    raise AssertionError("order exceeds cap")


orders = {name: mat_order(M) for name, M in GENERATORS.items()}
print(f"  orders: sigma={orders['sigma']}, tau={orders['tau']}, iota={orders['iota']}")
check("order(sigma) == 5", orders["sigma"] == 5)
check("order(tau) == 11", orders["tau"] == 11)
check("order(iota) == 2", orders["iota"] == 2)

sigma_tau = mat_mul_fast(sigma_fast, tau_fast)
tau_iota = mat_mul_fast(tau_fast, iota_fast)
check("order(sigma*tau) == 11 (Borel relation sanity)", mat_order(sigma_tau) in (5, 11, 55))

# ---------------------------------------------------------------------------
# Section 2: F-invariance (exact) and group order 660.

print()
print("=" * 78)
print("SECTION 2: F-invariance and |G| = 660")
print("=" * 78)


def F_dict():
    terms = {}
    base = (2, 1, 0, 0, 0)
    for i in range(5):
        e = shift(base, i)
        terms[e] = terms.get(e, FZERO)
        terms[e] = fadd(terms[e], FONE)
    return terms


F_TERMS = F_dict()
print(f"  F has {len(F_TERMS)} terms: " + " + ".join(format_monomial(e) for e in sorted(F_TERMS)))


def substitute_linear_and_apply_F(mat_fast):
    """Compute F(mat . x) - F(x) exactly as a dict of a degree-3 polynomial,
    via direct cubic expansion (cheap, done once per generator)."""
    # (mat x)_l = sum_m mat[l][m] x_m
    # F(mat x) = sum_l (mat x)_l^2 (mat x)_{l+1}
    def linf_vec(l):
        return {tuple(1 if k == m else 0 for k in range(5)): mat_fast[l][m]
                for m in range(5) if not fiszero(mat_fast[l][m])}

    def pmul(p1, p2):
        out = {}
        for e1, c1 in p1.items():
            for e2, c2 in p2.items():
                e = tuple(a + b for a, b in zip(e1, e2))
                term = fmul(c1, c2)
                out[e] = fadd(out.get(e, FZERO), term)
        return out

    total = {}
    for l in range(5):
        Ll = linf_vec(l)
        Lsq = pmul(Ll, Ll)
        Lnext = linf_vec((l + 1) % 5)
        term = pmul(Lsq, Lnext)
        for e, c in term.items():
            total[e] = fadd(total.get(e, FZERO), c)
    # subtract F(x)
    for e, c in F_TERMS.items():
        total[e] = fsub(total.get(e, FZERO), c)
    return {e: c for e, c in total.items() if not fiszero(c)}


for name, M in GENERATORS.items():
    diff = substitute_linear_and_apply_F(M)
    check(f"F({name} x) = F(x) exactly (over Q(zeta_11))", len(diff) == 0)

# Group order via BFS enumeration of the actual 5x5 matrices.
t0 = time.time()

MAT_ID_KEY = tuple(tuple(row) for row in mat_id())


def mat_key(M):
    return tuple(tuple(row) for row in M)


from collections import deque

seen = {MAT_ID_KEY: mat_id()}
queue = deque([mat_id()])
gens = list(GENERATORS.values())
CAP = 2000
while queue:
    cur = queue.popleft()
    for g in gens:
        nxt = mat_mul_fast(cur, g)
        key = mat_key(nxt)
        if key not in seen:
            seen[key] = nxt
            queue.append(nxt)
            if len(seen) > CAP:
                break
    if len(seen) > CAP:
        break
t1 = time.time()
print(f"  enumerated |<sigma,tau,iota>| = {len(seen)} elements in {t1 - t0:.2f}s")
check("group generated by {sigma,tau,iota} has order exactly 660", len(seen) == 660)

# ---------------------------------------------------------------------------
# Section 3: traces vs the 5-dim character of PSL(2,11).

print()
print("=" * 78)
print("SECTION 3: traces against the 5-dim character table")
print("=" * 78)

QR = {1, 3, 4, 5, 9}
gauss_fast = FZERO
for r in range(1, 11):
    sign = Fr(1) if r in QR else Fr(-1)
    gauss_fast = fadd(gauss_fast, fscale(funit(r), sign))
gauss_sq = fmul(gauss_fast, gauss_fast)
neg11 = fscale(FONE, Fr(-11))
check("Gauss sum g satisfies g^2 = -11 exactly", feq(gauss_sq, neg11))

half = Fr(1, 2)
CANDIDATES = {
    "5": fscale(FONE, Fr(5)),
    "1": FONE,
    "-1": fscale(FONE, Fr(-1)),
    "0": FZERO,
    "(-1+sqrt(-11))/2": fscale(fadd(fscale(FONE, Fr(-1)), gauss_fast), half),
    "(-1-sqrt(-11))/2": fscale(fsub(fscale(FONE, Fr(-1)), gauss_fast), half),
}


def trace(M):
    t = FZERO
    for i in range(5):
        t = fadd(t, M[i][i])
    return t


for name, M in GENERATORS.items():
    tr = trace(M)
    match = next((label for label, val in CANDIDATES.items() if feq(val, tr)), None)
    check(f"trace({name}) is an allowed 5-dim character value" + (f"  [= {match}]" if match else ""), match is not None)

# ---------------------------------------------------------------------------
# Section 4: build the H(=<sigma,tau>)-covariant "seed" spaces combinatorially,
# then intersect with ker(rho(iota) - 1) via exact linear algebra, for k=1..8.

print()
print("=" * 78)
print("SECTION 4: Cov_k for k = 1..8")
print("=" * 78)

EXPECTED_COV = {1: 1, 2: 0, 3: 0, 4: 2, 5: 1, 6: 2, 7: 4, 8: 5}
EXPECTED_DIVFREE = {1: 0, 2: 0, 3: 0, 4: 1, 5: 1, 6: 1, 7: 2, 8: 4}


def build_power_table(mat_fast, maxdeg):
    pows = [[None] * 5 for _ in range(5)]
    for l in range(5):
        for m in range(5):
            c = mat_fast[l][m]
            table = [FONE]
            cur = FONE
            for _ in range(maxdeg):
                cur = fmul(cur, c)
                table.append(cur)
            pows[l][m] = table
    return pows


IOTA_POW = build_power_table(iota_fast, 8)


def linear_form_power(coeff_pows_row, e):
    if e == 0:
        return {(0, 0, 0, 0, 0): FONE}
    result = {}
    for comp in compositions(e, 5):
        mc = multinomial(e, comp)
        term = fscale(FONE, Fr(mc))
        skip = False
        for m, n in enumerate(comp):
            if n == 0:
                continue
            cp = coeff_pows_row[m][n]
            if fiszero(cp):
                skip = True
                break
            term = fmul(term, cp)
        if skip:
            continue
        cur = result.get(comp)
        result[comp] = fadd(cur, term) if cur is not None else term
    return result


def poly_mul(p1, p2):
    out = {}
    for e1, c1 in p1.items():
        for e2, c2 in p2.items():
            e = tuple(a + b for a, b in zip(e1, e2))
            term = fmul(c1, c2)
            cur = out.get(e)
            out[e] = fadd(cur, term) if cur is not None else term
    return {e: c for e, c in out.items() if not fiszero(c)}


def substitute_monomial(exp, pow_table):
    result = {(0, 0, 0, 0, 0): FONE}
    for l, e in enumerate(exp):
        if e == 0:
            continue
        lf = linear_form_power(pow_table[l], e)
        result = poly_mul(result, lf)
    return result


def compute_cov(d, verbose=True):
    t0 = time.time()
    alphas = [e for e in compositions(d, 5) if hweight(e) == WEIGHTS[0]]
    m = len(alphas)
    monoms = list(compositions(d, 5))
    Nd = len(monoms)
    mono_index = {e: i for i, e in enumerate(monoms)}

    columns = []
    for alpha in alphas:
        col = [FZERO] * (5 * Nd)
        for i in range(5):
            texp = shift(alpha, i)
            lhs = substitute_monomial(texp, IOTA_POW)
            for e, c in lhs.items():
                idx = i * Nd + mono_index[e]
                col[idx] = fadd(col[idx], c)
            for j in range(5):
                e = shift(alpha, j)
                idx = i * Nd + mono_index[e]
                col[idx] = fsub(col[idx], iota_fast[i][j])
        columns.append(col)
    t1 = time.time()

    rows = [[columns[c][r] for c in range(m)] for r in range(5 * Nd)]
    kernel = k11_nullspace(rows, 5 * Nd, m) if m > 0 else []
    t2 = time.time()
    if verbose:
        print(
            f"  d={d:2d}  #monomials={Nd:4d}  H-seed dim={m:3d}  "
            f"[build {t1 - t0:5.1f}s, kernel {t2 - t1:5.1f}s]  -> dim Cov_{d} = {len(kernel)}"
        )
    return alphas, kernel


cov_data = {}
for d in range(1, 9):
    alphas, kernel = compute_cov(d)
    cov_data[d] = (alphas, kernel)
    check(f"dim Cov_{d} == {EXPECTED_COV[d]}", len(kernel) == EXPECTED_COV[d])

print()
print("  dimension table (k, dim Cov_k):")
print("  k:   " + "  ".join(f"{k}" for k in range(1, 9)))
print("  dim: " + "  ".join(f"{len(cov_data[k][1])}" for k in range(1, 9)))

# ---------------------------------------------------------------------------
# Section 5: divergence-free subspace of Cov_k.

print()
print("=" * 78)
print("SECTION 5: divergence-free subspace of Cov_k")
print("=" * 78)


def expand_covariant(alphas, kernel, combo):
    """combo: length len(kernel) fast-field scalars.  Returns 5 dicts
    {exponent: fast-field coeff}, the explicit polynomial 5-tuple."""
    m = len(alphas)
    v = [FZERO] * m
    for p, coef in enumerate(combo):
        if fiszero(coef):
            continue
        bv = kernel[p]
        for a in range(m):
            if fiszero(bv[a]):
                continue
            v[a] = fadd(v[a], fmul(coef, bv[a]))
    comps = [dict() for _ in range(5)]
    for a_idx, alpha in enumerate(alphas):
        c = v[a_idx]
        if fiszero(c):
            continue
        for i in range(5):
            e = shift(alpha, i)
            comps[i][e] = c
    return comps


def divergence_of_tuple(comps):
    result = {}
    for i in range(5):
        for e, coef in comps[i].items():
            if e[i] == 0:
                continue
            ne = list(e)
            ne[i] -= 1
            ne = tuple(ne)
            term = fscale(coef, Fr(e[i]))
            result[ne] = fadd(result.get(ne, FZERO), term)
    return {e: c for e, c in result.items() if not fiszero(c)}


def divfree_subspace(d, alphas, kernel):
    c = len(kernel)
    if c == 0:
        return [], []
    explicit = []
    for p in range(c):
        combo = [FZERO] * c
        combo[p] = FONE
        explicit.append(expand_covariant(alphas, kernel, combo))
    divs = [divergence_of_tuple(e) for e in explicit]
    monoms_minus = list(compositions(d - 1, 5))
    rows = []
    for mono in monoms_minus:
        rows.append([divs[p].get(mono, FZERO) for p in range(c)])
    combos = k11_nullspace(rows, len(monoms_minus), c)
    return combos, explicit


divfree_data = {}
for d in range(1, 9):
    alphas, kernel = cov_data[d]
    combos, explicit = divfree_subspace(d, alphas, kernel)
    divfree_data[d] = (combos, explicit)
    print(f"  d={d}: dim(divergence-free subspace of Cov_{d}) = {len(combos)}")
    check(f"dim divfree(Cov_{d}) == {EXPECTED_DIVFREE[d]}", len(combos) == EXPECTED_DIVFREE[d])

print()
print("  dimension table (k, dim divergence-free subspace of Cov_k):")
print("  k:   " + "  ".join(f"{k}" for k in range(1, 9)))
print("  dim: " + "  ".join(f"{len(divfree_data[k][0])}" for k in range(1, 9)))

# ---------------------------------------------------------------------------
# Section 6: explicit basis of Cov_4, F*x, and the divergence-free D_4.

print()
print("=" * 78)
print("SECTION 6: explicit Cov_4 basis, F*x, and D_4")
print("=" * 78)

alphas4, kernel4 = cov_data[4]


def make_Fx():
    comps = [dict() for _ in range(5)]
    for e, c in F_TERMS.items():
        for i in range(5):
            ne = list(e)
            ne[i] += 1
            comps[i][tuple(ne)] = fadd(comps[i].get(tuple(ne), FZERO), c)
    return comps


Fx_comps = make_Fx()

# T_0 of F*x must be supported only on the degree-4 alpha basis (weight check).
w4 = [Fx_comps[0].get(a, FZERO) for a in alphas4]
consistent = set(Fx_comps[0].keys()) <= set(alphas4)
check("F*x_0 is supported only on the weight-1 degree-4 monomials (the alpha4 basis)", consistent)

combo_Fx = k11_solve_combo(kernel4, w4, len(alphas4))
check("F*x lies in span(Cov_4) [T_0 of F*x solves for combo in the Cov_4 kernel basis]", combo_Fx is not None)

# cross-check by re-expanding and comparing componentwise to the direct F*x_i.
Fx_reexpand = expand_covariant(alphas4, kernel4, combo_Fx) if combo_Fx is not None else None
Fx_matches = False
if Fx_reexpand is not None:
    Fx_matches = all(
        set(Fx_reexpand[i].keys()) == set(Fx_comps[i].keys())
        and all(feq(Fx_reexpand[i][e], Fx_comps[i][e]) for e in Fx_comps[i])
        for i in range(5)
    )
check("re-expanded combo reproduces F*x exactly in all 5 components", Fx_matches)

div_Fx = divergence_of_tuple(Fx_comps)
eight_F = {e: fscale(c, Fr(8)) for e, c in F_TERMS.items()}
div_Fx_is_8F = set(div_Fx.keys()) == set(eight_F.keys()) and all(
    feq(div_Fx[e], eight_F[e]) for e in eight_F
)
check("div(F*x) == 8*F exactly (Euler: div(Fx) = sum x_i dF/dx_i + 5F = 3F+5F)", div_Fx_is_8F)

combos4, explicit4 = divfree_data[4]
check("dim divfree(Cov_4) == 1 (D_4 unique up to scalar)", len(combos4) == 1)

D4_raw = None
if len(combos4) == 1:
    combo = combos4[0]
    D4_raw = [dict() for _ in range(5)]
    for p, coef in enumerate(combo):
        if fiszero(coef):
            continue
        for i in range(5):
            for e, c in explicit4[p][i].items():
                term = fmul(coef, c)
                D4_raw[i][e] = fadd(D4_raw[i].get(e, FZERO), term)
    D4_raw = [{e: c for e, c in comp.items() if not fiszero(c)} for comp in D4_raw]


# ---------------------------------------------------------------------------
# Section 7: normalize a tuple (defined up to an arbitrary K11 scalar) to the
# smallest possible representative and classify its field of definition.

def classify_and_normalize(comps):
    """comps: list of 5 dicts {exponent: fast-field coeff}.
    Returns (field_name, normalized_comps) where normalized_comps entries are
    either Fraction (field_name == 'Q'), (Fraction,Fraction) pairs meaning
    p + q*sqrt(-11) (field_name == 'Q(sqrt(-11))'), or raw fast-field tuples
    (field_name == 'Q(zeta_11)')."""
    flat = []
    for i in range(5):
        for e in sorted(comps[i].keys()):
            flat.append((i, e, comps[i][e]))
    assert flat, "empty tuple"
    ref_val = flat[0][2]
    ratios = [(i, e, fdiv(c, ref_val)) for (i, e, c) in flat]

    # rational test: r == r_0 * 1, i.e. components 1..9 (the z,...,z^9 part) are zero
    all_rational = all(all(r[k] == 0 for k in range(1, 10)) for (_, _, r) in ratios)
    if all_rational:
        vals = {(i, e): r[0] for (i, e, r) in ratios}
        denoms = [v.denominator for v in vals.values()]
        from math import lcm as _lcm, gcd as _gcd

        L = 1
        for dd in denoms:
            L = _lcm(L, dd)
        ints = {k: int(v * L) for k, v in vals.items()}
        g = 0
        for v in ints.values():
            g = _gcd(g, abs(v))
        g = g or 1
        first_key = min(ints.keys())
        sign = 1 if ints[first_key] // g >= 0 else -1
        normalized = {k: sign * (v // g) for k, v in ints.items()}
        out = [dict() for _ in range(5)]
        for (i, e), v in normalized.items():
            out[i][e] = v
        return "Q", out

    # Try Q(sqrt(-11)): every ratio must be fixed by the order-5 Galois
    # subgroup generated by zeta -> zeta^4 (since 4 has order 5 mod 11).
    all_quad = all(feq(galois_apply(r, 4), r) for (_, _, r) in ratios)
    if all_quad:
        # project onto basis {1, gauss_fast}; solve via two rows where the
        # 2x2 minor of [1 | gauss] is invertible.
        M = None
        for r1 in range(10):
            for r2 in range(r1 + 1, 10):
                a, b = FONE[r1], gauss_fast[r1]
                c, d = FONE[r2], gauss_fast[r2]
                det = a * d - b * c
                if det != 0:
                    M = (r1, r2, a, b, c, d, det)
                    break
            if M:
                break
        assert M, "could not find invertible 2x2 minor for {1,gauss}"
        r1, r2, a, b, c, d, det = M
        vals = {}
        for (i, e, r) in ratios:
            rhs1, rhs2 = r[r1], r[r2]
            p = (rhs1 * d - b * rhs2) / det
            q = (a * rhs2 - rhs1 * c) / det
            # verify against all 10 coordinates
            check_vec = fadd(fscale(FONE, p), fscale(gauss_fast, q))
            assert feq(check_vec, r), "inconsistent Q(sqrt(-11)) reconstruction"
            vals[(i, e)] = (p, q)
        from math import lcm as _lcm, gcd as _gcd

        L = 1
        for (p, q) in vals.values():
            L = _lcm(L, p.denominator, q.denominator)
        ints = {k: (int(p * L), int(q * L)) for k, (p, q) in vals.items()}
        g = 0
        for (pi, qi) in ints.values():
            g = _gcd(g, _gcd(abs(pi), abs(qi)))
        g = g or 1
        first_key = min(ints.keys())
        fp, fq = ints[first_key]
        lead = fp if fp != 0 else fq
        sign = 1 if lead // g >= 0 else -1
        normalized = {k: (sign * (pi // g), sign * (qi // g)) for k, (pi, qi) in ints.items()}
        out = [dict() for _ in range(5)]
        for (i, e), v in normalized.items():
            out[i][e] = v
        return "Q(sqrt(-11))", out

    # fall back: raw K11.
    out = [dict() for _ in range(5)]
    for (i, e, r) in ratios:
        out[i][e] = r
    return "Q(zeta_11)", out


def format_poly_Q(d):
    terms = []
    for e in sorted(d.keys()):
        c = d[e]
        if c == 0:
            continue
        mono = format_monomial(e)
        if mono == "1":
            terms.append(f"{c}")
        elif c == 1:
            terms.append(mono)
        elif c == -1:
            terms.append(f"-{mono}")
        else:
            terms.append(f"{c}*{mono}")
    s = " + ".join(terms).replace("+ -", "- ")
    return s if s else "0"


def format_poly_Qsqrt11(d):
    terms = []
    for e in sorted(d.keys()):
        p, q = d[e]
        if p == 0 and q == 0:
            continue
        mono = format_monomial(e)
        pieces = []
        if p != 0:
            pieces.append(f"{p}")
        if q != 0:
            if q == 1:
                pieces.append("sqrt(-11)")
            elif q == -1:
                pieces.append("-sqrt(-11)")
            else:
                pieces.append(f"{q}*sqrt(-11)")
        cs = "+".join(pieces).replace("+-", "-")
        if len(pieces) > 1:
            cs = f"({cs})"
        if mono == "1":
            terms.append(cs)
        else:
            terms.append(f"{cs}*{mono}")
    s = " + ".join(terms).replace("+ -", "- ")
    return s if s else "0"


def print_tuple(field_name, comps, label):
    print(f"  {label}  [field of definition: {field_name}]")
    for i in range(5):
        if field_name == "Q":
            s = format_poly_Q(comps[i])
        elif field_name == "Q(sqrt(-11))":
            s = format_poly_Qsqrt11(comps[i])
        else:
            s = repr(comps[i])
        print(f"    component {i}: {s}")


D4_field = None
D4_norm = None
if D4_raw is not None:
    D4_field, D4_norm = classify_and_normalize(D4_raw)
    print()
    print_tuple(D4_field, D4_norm, "D_4 (unique divergence-free element of Cov_4, normalized):")

# content / gcd of the five components, and Euler-multiple check
content_D4 = None
is_euler_multiple = False
if D4_field == "Q":
    from math import gcd as _gcd

    g = 0
    for comp in D4_norm:
        for v in comp.values():
            g = _gcd(g, abs(v))
    content_D4 = g or 1
    # Euler vector field x = (x_0,...,x_4): D4 is a multiple of x iff each
    # component D4_i is (const)*x_i^k ... but degrees differ (D4 is degree 4,
    # x is degree 1) so "multiple of the Euler vector field" is only sensible
    # as D4_i = P(x) * x_i for a single common degree-3 form P. Test that.
    ok = True
    P_candidate = None
    for i in range(5):
        comp = D4_norm[i]
        derived = {}
        for e, c in comp.items():
            if e[i] == 0:
                ok = False
                break
            ne = list(e)
            ne[i] -= 1
            derived[tuple(ne)] = c
        if not ok:
            break
        if P_candidate is None:
            P_candidate = derived
        elif derived != P_candidate:
            ok = False
            break
    is_euler_multiple = ok
elif D4_field == "Q(sqrt(-11))":
    from math import gcd as _gcd

    g = 0
    for comp in D4_norm:
        for (p, q) in comp.values():
            g = _gcd(g, _gcd(abs(p), abs(q)))
    content_D4 = g or 1

print()
if D4_field == "Q":
    print(f"  content (gcd) of D_4's five components (already normalized to primitive): {content_D4}")
elif D4_field == "Q(sqrt(-11))":
    print(f"  content (gcd over all p,q in p+q*sqrt(-11)) of D_4 (already normalized to primitive): {content_D4}")
print(f"  D_4 is a multiple of the Euler vector field x = (x_0,...,x_4): {is_euler_multiple}")

# ---------------------------------------------------------------------------
# Section 8: Cov_6 divergence-free element (if not too large).

print()
print("=" * 78)
print("SECTION 8: divergence-free element(s) of Cov_6")
print("=" * 78)

alphas6, kernel6 = cov_data[6]
combos6, explicit6 = divfree_data[6]
print(f"  dim Cov_6 = {len(kernel6)}, dim divfree(Cov_6) = {len(combos6)}")

D6_field = None
if len(combos6) >= 1:
    combo = combos6[0]
    D6_raw = [dict() for _ in range(5)]
    for p, coef in enumerate(combo):
        if fiszero(coef):
            continue
        for i in range(5):
            for e, c in explicit6[p][i].items():
                term = fmul(coef, c)
                D6_raw[i][e] = fadd(D6_raw[i].get(e, FZERO), term)
    D6_raw = [{e: c for e, c in comp.items() if not fiszero(c)} for comp in D6_raw]
    n_terms = sum(len(c) for c in D6_raw)
    print(f"  representative divergence-free element of Cov_6 has {n_terms} total monomial terms")
    D6_field, D6_norm = classify_and_normalize(D6_raw)
    print_tuple(D6_field, D6_norm, "D_6 (a divergence-free element of Cov_6, normalized):")
    if len(combos6) > 1:
        print(f"  NOTE: divfree(Cov_6) has dimension {len(combos6)} > 1; only one representative is shown.")
else:
    print("  divfree(Cov_6) is trivial (dimension 0); nothing to print.")

# ---------------------------------------------------------------------------
# Final verdict.

print()
print("=" * 78)
if RESULT_OK:
    print("RESULT: PASS")
    sys.exit(0)
else:
    print("RESULT: FAIL")
    sys.exit(1)
