#!/usr/bin/env python3
"""verify_d35_cells.py

Decides the two one-dimensional actionable cells of the d = 35 branch table:

    k = 31, d' = 4      and      k = 30, d' = 5

(`D35_BRANCH_TABLE.md` section 3).  Both are decided DEAD, and the killing
condition is one degree earlier in the chain than the sealed dominance
hypothesis: in each cell the space of candidate restricted selfmaps is a single
projective point, and that point does not map X into X.

WHAT IS REPLAYED HERE, all exactly, no floating point:

  (B) Cov_k = (Sym^k W^v (x) W)^G is rebuilt from scratch over Q(zeta_11) as a
      joint kernel over the three generators sigma, tau, iota -- never by
      averaging over the 660 group elements.  iota is imported unmodified from
      the repository's own exact representation core.  Dimensions
      C(1..5) = 1,0,0,2,1 are re-derived and checked against the sealed table.
      The degree-5 generator D_5 is a new named object and is printed in full.

  (C) A SECOND, code-disjoint arithmetic path audits both named tuples D_4 and
      D_5: sigma-covariance by direct substitution, tau-covariance as a weight
      condition, iota-covariance with iota rebuilt from the repository's
      Gauss-sum formula inside Q[z]/(z^11-1) (the same second path that
      `verify_d4_covariant.py` uses for D_4).  Since <sigma,tau,iota> = G, these
      three conditions are exactly G-covariance.

  (D) The candidate space on X is ((S/F)_{d'} (x) W)^G, of dimension
      C(d') - C(d'-3) by exactness of G-invariants in characteristic zero.  The
      kernel of restriction is exhibited explicitly: F*x spans it at d' = 4, and
      it is zero at d' = 5 because Cov_2 = 0.  Both cells therefore have a
      ONE-dimensional candidate space.

  (E) THE KILL.  A restricted selfmap needs F(B) = 0 on X
      (`THEOREM_SOURCE_TANGENCY.md` section 4).  F(B) mod F is computed as a
      genuine Groebner normal form ({F} is a Groebner basis of the principal
      ideal (F)), parametrically over the whole Cov_4 pencil, and it is nonzero
      for every member except the degenerate one that restricts to 0.  The same
      for the Cov_5 generator.  Each nonvanishing is independently certified by
      exact integer evaluation at rational points of X, which needs no ideal
      theory at all: p in X with F(B(p)) != 0 proves F(B) not in (F).

  (F) Positive controls, so that the test is not vacuously always-failing: the
      identity tuple (d' = 1, the retraction branch) and the group element sigma
      both PASS the same test.

  (G) Robustness annex: the same verdict under the outer-automorphism-twisted
      equivariance convention, where the target carries the OTHER 5-dimensional
      irreducible representation of G.  Both twisted cells die too, so the kill
      does not depend on the convention.

Everything is over Q or Q(zeta_11) carried as length-10 Fraction vectors.
"""

from __future__ import annotations

import importlib.util
import sys
import time
from collections import deque
from fractions import Fraction as Fr
from math import factorial, gcd as _gcd, lcm as _lcm
from pathlib import Path

import sympy as sp
from sympy.polys.domains import QQ
from sympy.polys.matrices import DomainMatrix
from sympy.polys.polyclasses import ANP

RESULT_OK = True
NCHECK = 0


def check(label: str, cond: bool) -> bool:
    global RESULT_OK, NCHECK
    NCHECK += 1
    print(f"  {'ok  ' if cond else 'FAIL'}  {label}")
    if not cond:
        RESULT_OK = False
    return bool(cond)


def banner(text: str) -> None:
    print()
    print("=" * 78)
    print(text)
    print("=" * 78)


# ===========================================================================
# Exact Q(zeta_11): element = length-10 tuple of Fractions in the power basis
# 1, z, ..., z^9, reduced by z^11 = 1 and z^10 = -(1 + z + ... + z^9).
# ===========================================================================

FZERO = (Fr(0),) * 10
FONE = (Fr(1),) + (Fr(0),) * 9


def funit(i: int):
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


def fscale(u, s):
    return tuple(a * s for a in u)


def fmul(u, v):
    out = [Fr(0)] * 10
    for i in range(10):
        ui = u[i]
        if ui == 0:
            continue
        for j in range(10):
            vj = v[j]
            if vj == 0:
                continue
            c = ui * vj
            n = i + j
            if n < 10:
                out[n] += c
            elif n == 10:
                for k in range(10):
                    out[k] -= c
            else:
                out[n - 11] += c
    return tuple(out)


def fiszero(u):
    return all(a == 0 for a in u)


def feq(u, v):
    return u == v


def galois_apply(u, k: int):
    """The field automorphism zeta -> zeta^k, k coprime to 11."""
    res = FZERO
    for i in range(10):
        if u[i]:
            res = fadd(res, fscale(funit(k * i), u[i]))
    return res


K11 = QQ.cyclotomic_field(11)
MODLIST = K11.unit.mod
DOM = K11.unit.dom


def anp_to_fast(e):
    raw = list(reversed(e.to_list()))
    raw += [QQ.zero] * (10 - len(raw))
    return tuple(Fr(int(v.numerator), int(v.denominator)) for v in raw)


def fast_to_anp(vec):
    return ANP([QQ(f.numerator, f.denominator) for f in reversed(vec)], MODLIST, DOM)


def fast_inverse(u):
    return anp_to_fast(K11.one / fast_to_anp(u))


def fdiv(u, v):
    return fmul(u, fast_inverse(v))


def k11_nullspace(rows_fast, nrows, ncols):
    if ncols == 0:
        return []
    if nrows == 0:
        out = []
        for i in range(ncols):
            row = [FZERO] * ncols
            row[i] = FONE
            out.append(tuple(row))
        return out
    rows_anp = [[fast_to_anp(rows_fast[r][c]) for c in range(ncols)] for r in range(nrows)]
    ker = DomainMatrix(rows_anp, (nrows, ncols), K11).nullspace()
    return [tuple(anp_to_fast(ker.to_list()[r][c]) for c in range(ncols))
            for r in range(ker.shape[0])]


# ===========================================================================
# Monomial combinatorics
# ===========================================================================

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
    r = factorial(n)
    for p in parts:
        r //= factorial(p)
    return r


def format_monomial(e):
    parts = []
    for i, p in enumerate(e):
        if p == 0:
            continue
        parts.append(f"x{i}" if p == 1 else f"x{i}^{p}")
    return "*".join(parts) if parts else "1"


def format_poly_Q(d):
    terms = []
    for e in sorted(d.keys()):
        c = d[e]
        if c == 0:
            continue
        m = format_monomial(e)
        terms.append(m if c == 1 else ("-" + m if c == -1 else f"{c}*{m}"))
    s = " + ".join(terms).replace("+ -", "- ")
    return s if s else "0"


# ===========================================================================
# SECTION A.  The Klein cubic, and the sealed inputs this packet consumes.
# ===========================================================================

banner("SECTION A.  Setting: the Klein cubic F and the sealed inputs")

xs = sp.symbols("x0 x1 x2 x3 x4")
x0, x1, x2, x3, x4 = xs
F_sym = sum(xs[i] ** 2 * xs[(i + 1) % 5] for i in range(5))
print(f"  F = {F_sym}")

check("F is homogeneous of degree 3 in 5 variables",
      sp.Poly(F_sym, *xs).is_homogeneous and sp.Poly(F_sym, *xs).total_degree() == 3)
check("F is irreducible over Q (so (F) is prime and F(B) in (F) <=> F(B) vanishes on X)",
      len(sp.factor_list(F_sym)[1]) == 1 and sp.factor_list(F_sym)[1][0][1] == 1)

# The sealed covariant-dimension table (FOLIATION_REFORMULATION.md section 2,
# triple-confirmed: verify_covariant_dimensions.py, verify_low_degree_covariants.py,
# verify_d35_dimensions.py).  Re-derived from scratch in section B below.
SEALED_COV = {1: 1, 2: 0, 3: 0, 4: 2, 5: 1, 6: 2, 7: 4, 8: 5}
print(f"  sealed dim Cov_k, k = 1..8:  {[SEALED_COV[k] for k in range(1, 9)]}")


# ===========================================================================
# SECTION B.  Rebuild Cov_k over Q(zeta_11) as a joint kernel; k = 1..5.
# ===========================================================================

banner("SECTION B.  Cov_k = (Sym^k W^v (x) W)^G rebuilt exactly, k = 1..5")

sigma_f = [[FONE if j == (i + 1) % 5 else FZERO for j in range(5)] for i in range(5)]
tau_f = [[funit(WEIGHTS[i]) if i == j else FZERO for j in range(5)] for i in range(5)]

check("2*a_i + a_{i+1} = 0 (mod 11) for all i: every term of F is tau-invariant",
      all((2 * WEIGHTS[i] + WEIGHTS[(i + 1) % 5]) % 11 == 0 for i in range(5)))

SRC_ROOT = Path(__file__).resolve().parents[2]
WEIL_SRC = (SRC_ROOT / "goal_runs_after_35fa" / "Q_SCHUR_INDEX_ONE"
            / "exact_schur_frame" / "exact_representation_core.py")
check(f"reused exact generators exist: {WEIL_SRC.name}", WEIL_SRC.is_file())

_spec = importlib.util.spec_from_file_location("exact_representation_core", WEIL_SRC)
_weil = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_weil)
S_dm, T_dm = _weil.weil_generators()
iota_f = [[anp_to_fast(S_dm.to_list()[i][j]) for j in range(5)] for i in range(5)]
Tchk = [[anp_to_fast(T_dm.to_list()[i][j]) for j in range(5)] for i in range(5)]
check("imported T equals our own tau = diag(z^(1,9,4,3,5)) entry by entry",
      all(feq(tau_f[i][j], Tchk[i][j]) for i in range(5) for j in range(5)))


def mat_mul(A, B):
    out = [[FZERO] * 5 for _ in range(5)]
    for i in range(5):
        for k in range(5):
            if fiszero(A[i][k]):
                continue
            for j in range(5):
                if not fiszero(B[k][j]):
                    out[i][j] = fadd(out[i][j], fmul(A[i][k], B[k][j]))
    return out


def mat_id():
    return [[FONE if i == j else FZERO for j in range(5)] for i in range(5)]


def mat_eq(A, B):
    return all(feq(A[i][j], B[i][j]) for i in range(5) for j in range(5))


def mat_order(A, cap=100):
    cur = A
    for n in range(1, cap + 1):
        if mat_eq(cur, mat_id()):
            return n
        cur = mat_mul(cur, A)
    raise AssertionError("order exceeds cap")


check("order(sigma) = 5", mat_order(sigma_f) == 5)
check("order(tau) = 11", mat_order(tau_f) == 11)
check("order(iota) = 2", mat_order(iota_f) == 2)

_t0 = time.time()
seen = {tuple(tuple(r) for r in mat_id())}
queue = deque([mat_id()])
GENS = [sigma_f, tau_f, iota_f]
while queue and len(seen) <= 2000:
    cur = queue.popleft()
    for g in GENS:
        nxt = mat_mul(cur, g)
        key = tuple(tuple(r) for r in nxt)
        if key not in seen:
            seen.add(key)
            queue.append(nxt)
check(f"|<sigma, tau, iota>| = 660 (enumerated in {time.time() - _t0:.1f}s)", len(seen) == 660)


def F_of_matrix_action(M):
    """F(M x) - F(x), expanded exactly."""
    def lin(l):
        return {tuple(1 if k == m else 0 for k in range(5)): M[l][m]
                for m in range(5) if not fiszero(M[l][m])}

    def pmul(p, q):
        out = {}
        for e1, c1 in p.items():
            for e2, c2 in q.items():
                e = tuple(a + b for a, b in zip(e1, e2))
                out[e] = fadd(out.get(e, FZERO), fmul(c1, c2))
        return out

    total = {}
    for l in range(5):
        Ll = lin(l)
        term = pmul(pmul(Ll, Ll), lin((l + 1) % 5))
        for e, c in term.items():
            total[e] = fadd(total.get(e, FZERO), c)
    for i in range(5):
        e = list((0, 0, 0, 0, 0))
        e[i] += 2
        e[(i + 1) % 5] += 1
        total[tuple(e)] = fsub(total.get(tuple(e), FZERO), FONE)
    return {e: c for e, c in total.items() if not fiszero(c)}


for nm, M in (("sigma", sigma_f), ("tau", tau_f), ("iota", iota_f)):
    check(f"F({nm} x) = F(x) exactly over Q(zeta_11)", len(F_of_matrix_action(M)) == 0)


def build_power_table(M, maxdeg):
    pows = [[None] * 5 for _ in range(5)]
    for l in range(5):
        for m in range(5):
            c, tbl, cur = M[l][m], [FONE], FONE
            for _ in range(maxdeg):
                cur = fmul(cur, c)
                tbl.append(cur)
            pows[l][m] = tbl
    return pows


def linear_form_power(row, e):
    if e == 0:
        return {(0, 0, 0, 0, 0): FONE}
    res = {}
    for comp in compositions(e, 5):
        term, skip = fscale(FONE, Fr(multinomial(e, comp))), False
        for m, n in enumerate(comp):
            if n == 0:
                continue
            cp = row[m][n]
            if fiszero(cp):
                skip = True
                break
            term = fmul(term, cp)
        if skip:
            continue
        res[comp] = fadd(res[comp], term) if comp in res else term
    return res


def poly_mul(p1, p2):
    out = {}
    for e1, c1 in p1.items():
        for e2, c2 in p2.items():
            e = tuple(a + b for a, b in zip(e1, e2))
            out[e] = fadd(out.get(e, FZERO), fmul(c1, c2))
    return {e: c for e, c in out.items() if not fiszero(c)}


def substitute_monomial(exp, pow_table):
    res = {(0, 0, 0, 0, 0): FONE}
    for l, e in enumerate(exp):
        if e:
            res = poly_mul(res, linear_form_power(pow_table[l], e))
    return res


IOTA_POW = build_power_table(iota_f, 6)


def compute_cov(d, iota_target, seed_weight):
    """Joint kernel: sigma- and tau-covariance are imposed combinatorially (the
    seed monomials), then the single linear condition from iota.  `iota_target`
    is the matrix acting on the TARGET copy of W (= iota for the untwisted
    convention, its Galois conjugate for the twisted one)."""
    alphas = [e for e in compositions(d, 5) if hweight(e) == seed_weight]
    m = len(alphas)
    monoms = list(compositions(d, 5))
    Nd = len(monoms)
    idx = {e: i for i, e in enumerate(monoms)}
    cols = []
    for alpha in alphas:
        col = [FZERO] * (5 * Nd)
        for i in range(5):
            for e, c in substitute_monomial(shift(alpha, i), IOTA_POW).items():
                col[i * Nd + idx[e]] = fadd(col[i * Nd + idx[e]], c)
            for j in range(5):
                k = i * Nd + idx[shift(alpha, j)]
                col[k] = fsub(col[k], iota_target[i][j])
        cols.append(col)
    rows = [[cols[c][r] for c in range(m)] for r in range(5 * Nd)]
    return alphas, (k11_nullspace(rows, 5 * Nd, m) if m else [])


def expand_covariant(alphas, vec):
    comps = [dict() for _ in range(5)]
    for a_idx, alpha in enumerate(alphas):
        c = vec[a_idx]
        if fiszero(c):
            continue
        for i in range(5):
            comps[i][shift(alpha, i)] = c
    return comps


def divergence_of_tuple(comps):
    res = {}
    for i in range(5):
        for e, c in comps[i].items():
            if e[i] == 0:
                continue
            ne = list(e)
            ne[i] -= 1
            res[tuple(ne)] = fadd(res.get(tuple(ne), FZERO), fscale(c, Fr(e[i])))
    return {e: c for e, c in res.items() if not fiszero(c)}


QR = {1, 3, 4, 5, 9}
GAUSS = FZERO
for _r in range(1, 11):
    GAUSS = fadd(GAUSS, fscale(funit(_r), Fr(1) if _r in QR else Fr(-1)))
check("Gauss sum g = sum (r|11) z^r satisfies g^2 = -11 exactly",
      feq(fmul(GAUSS, GAUSS), fscale(FONE, Fr(-11))))


def classify_and_normalize(comps):
    """Normalize a covariant (defined up to a Q(zeta_11) scalar) to a primitive
    representative and name its field of definition."""
    flat = [(i, e, comps[i][e]) for i in range(5) for e in sorted(comps[i])]
    assert flat, "empty tuple"
    ratios = [(i, e, fdiv(c, flat[0][2])) for (i, e, c) in flat]
    if all(all(r[k] == 0 for k in range(1, 10)) for (_, _, r) in ratios):
        vals = {(i, e): r[0] for (i, e, r) in ratios}
        L = 1
        for v in vals.values():
            L = _lcm(L, v.denominator)
        ints = {k: int(v * L) for k, v in vals.items()}
        g = 0
        for v in ints.values():
            g = _gcd(g, abs(v))
        g = g or 1
        sgn = 1 if ints[min(ints)] // g >= 0 else -1
        out = [dict() for _ in range(5)]
        for (i, e), v in ints.items():
            out[i][e] = sgn * (v // g)
        return "Q", out
    return "Q(zeta_11) or Q(sqrt(-11))", None


cov = {}
for d in range(1, 6):
    t = time.time()
    alphas, ker = compute_cov(d, iota_f, WEIGHTS[0])
    cov[d] = (alphas, ker)
    check(f"dim Cov_{d} = {SEALED_COV[d]} (seed dim {len(alphas)}, {time.time()-t:.1f}s)",
          len(ker) == SEALED_COV[d])

# The two named generators, printed in full and normalized over Q.
COV4 = [expand_covariant(cov[4][0], v) for v in cov[4][1]]
COV5 = [expand_covariant(cov[5][0], v) for v in cov[5][1]]

f5, D5_norm = classify_and_normalize(COV5[0])
check("the Cov_5 generator D_5 is defined over Q", f5 == "Q")
print()
print("  D_5, the generator of the one-dimensional Cov_5 (normalized, primitive):")
for i in range(5):
    print(f"    D_5[{i}] = {format_poly_Q(D5_norm[i])}")
check("D_5 is divergence-free (forced: divfree(Cov_5) = Cov_5 = 1-dimensional)",
      len(divergence_of_tuple(COV5[0])) == 0)


# ===========================================================================
# SECTION C.  Second arithmetic path: audit D_4 and D_5 as G-covariants.
# ===========================================================================

banner("SECTION C.  Independent audit of D_4 and D_5 (code-disjoint path)")

# D_4 as reported by verify_low_degree_covariants.py and audited by
# verify_d4_covariant.py -- hardcoded here so that section E does not depend on
# section B's linear algebra.
D4_sym = [
    2*x3**4 + 8*x1*x2*x4**2 - x0*x3**2*x4 - 9*x0*x2**2*x3 + 7*x0*x1**2*x2 + 3*x0**2*x4**2 - x0**3*x1,
    2*x4**4 - 9*x1*x3**2*x4 + 7*x1*x2**2*x3 - x1**3*x2 - x0*x1*x4**2 + 8*x0**2*x2*x3 + 3*x0**2*x1**2,
    7*x2*x3**2*x4 - x2**3*x3 + 8*x1**2*x3*x4 + 3*x1**2*x2**2 - 9*x0*x2*x4**2 - x0**2*x1*x2 + 2*x0**4,
    -x3**3*x4 + 3*x2**2*x3**2 - x1**2*x2*x3 + 2*x1**4 + 7*x0*x3*x4**2 + 8*x0*x2**2*x4 - 9*x0**2*x1*x3,
    3*x3**2*x4**2 - x2**2*x3*x4 + 2*x2**4 - 9*x1**2*x2*x4 - x0*x4**3 + 8*x0*x1*x3**2 + 7*x0**2*x1*x4,
]
D4_sym = [sp.expand(f) for f in D4_sym]


def dict_to_sym(d):
    e = sp.Integer(0)
    for exp, c in d.items():
        t = sp.Integer(c)
        for i in range(5):
            t *= xs[i] ** exp[i]
        e += t
    return sp.expand(e)


D5_sym = [dict_to_sym(D5_norm[i]) for i in range(5)]

# ---- (C1) sigma-covariance, by direct substitution -------------------------
subs_sigma = {xs[i]: xs[(i + 1) % 5] for i in range(5)}
for name, T in (("D_4", D4_sym), ("D_5", D5_sym)):
    check(f"{name}: sigma-covariance  T_i(x_{{j+1}}) = T_{{i+1}}(x), all i",
          all(sp.expand(T[i].subs(subs_sigma, simultaneous=True) - T[(i + 1) % 5]) == 0
              for i in range(5)))

# ---- (C2) tau-covariance, as a weight condition ----------------------------
for name, T, deg in (("D_4", D4_sym, 4), ("D_5", D5_sym, 5)):
    bad = []
    for i in range(5):
        P = sp.Poly(T[i], *xs)
        check_deg = P.is_homogeneous and P.total_degree() == deg
        for mon in P.monoms():
            if sum(WEIGHTS[j] * mon[j] for j in range(5)) % 11 != WEIGHTS[i] % 11:
                bad.append((i, mon))
    check(f"{name}: homogeneous of degree {deg} in every component", check_deg)
    check(f"{name}: tau-covariance -- every monomial of component i has weight a_i "
          f"mod 11 ({len(bad)} violations)", not bad)

# ---- (C3) iota-covariance, with iota rebuilt from the repository formula ----
# Q(zeta_11) is re-implemented here as Q[z]/(z^11 - 1) plus 1+z+...+z^10 = 0,
# so this block shares no field arithmetic with sections A/B.
N = 11
ZERO11 = (Fr(0),) * N


def z11(e):
    v = [Fr(0)] * N
    v[e % N] = Fr(1)
    return tuple(v)


ONE11 = z11(0)


def a11(a, b):
    return tuple(a[i] + b[i] for i in range(N))


def s11(a, b):
    return tuple(a[i] - b[i] for i in range(N))


def m11s(c, a):
    return tuple(Fr(c) * a[i] for i in range(N))


def m11(a, b):
    out = [Fr(0)] * N
    for i in range(N):
        if a[i]:
            for j in range(N):
                if b[j]:
                    out[(i + j) % N] += a[i] * b[j]
    return tuple(out)


def eq11(a, b):
    d = s11(a, b)
    return all(d[i] == d[0] for i in range(N))   # equality modulo 1+z+...+z^10


gauss11 = ZERO11
for e in range(1, 11):
    gauss11 = a11(gauss11, m11s(1 if e in QR else -1, z11(e)))
check("second path: Gauss sum squares to -11 in Q[z]/(z^11-1)",
      eq11(m11(gauss11, gauss11), m11s(-11, ONE11)))

_indices = [1, 3, 2, 5, 4]
_signs = [1, 1, -1, 1, 1]
iota11 = []
for row, left in enumerate(_indices):
    r = []
    for col, right in enumerate(_indices):
        t = s11(z11((9 * left * right) % 11), z11((-9 * left * right) % 11))
        t = m11(t, m11s(-1, gauss11))
        t = m11s(Fr(_signs[col], _signs[row]), t)
        t = m11s(Fr(1, 11), t)
        r.append(t)
    iota11.append(r)

prod2 = [[ZERO11] * 5 for _ in range(5)]
for i in range(5):
    for j in range(5):
        s = ZERO11
        for k in range(5):
            s = a11(s, m11(iota11[i][k], iota11[k][j]))
        prod2[i][j] = s
check("second path: iota^2 = identity",
      all(eq11(prod2[i][j], ONE11 if i == j else ZERO11) for i in range(5) for j in range(5)))


def p11_mul(p, q):
    out = {}
    for m1, c1 in p.items():
        for m2, c2 in q.items():
            m = tuple(m1[i] + m2[i] for i in range(5))
            out[m] = a11(out.get(m, ZERO11), m11(c1, c2))
    return out


def p11_add(p, q):
    out = dict(p)
    for m, c in q.items():
        out[m] = a11(out.get(m, ZERO11), c)
    return out


def p11_scal(c, p):
    return {m: m11(c, v) for m, v in p.items()}


def p11_zero(p):
    return all(eq11(v, ZERO11) for v in p.values())


def p11_pow(p, n):
    r = {(0, 0, 0, 0, 0): ONE11}
    for _ in range(n):
        r = p11_mul(r, p)
    return r


_subst11 = []
for j in range(5):
    p = {}
    for k in range(5):
        e = [0] * 5
        e[k] = 1
        p[tuple(e)] = iota11[j][k]
    _subst11.append(p)


def apply_iota11(p):
    out = {}
    for m, c in p.items():
        term = {(0, 0, 0, 0, 0): c}
        for j in range(5):
            if m[j]:
                term = p11_mul(term, p11_pow(_subst11[j], m[j]))
        out = p11_add(out, term)
    return out


def sym_to_p11(expr):
    P = sp.Poly(expr, *xs)
    return {tuple(int(v) for v in mon): m11s(int(c), ONE11)
            for mon, c in zip(P.monoms(), P.coeffs())}


for name, T in (("D_4", D4_sym), ("D_5", D5_sym)):
    P = [sym_to_p11(T[i]) for i in range(5)]
    lhs = [apply_iota11(P[i]) for i in range(5)]
    rhs = []
    for i in range(5):
        s = {}
        for k in range(5):
            s = p11_add(s, p11_scal(iota11[i][k], P[k]))
        rhs.append(s)
    check(f"{name}: IOTA-COVARIANCE  T(iota x) = iota T(x), all five components",
          all(p11_zero(p11_add(lhs[i], p11_scal(m11s(-1, ONE11), rhs[i]))) for i in range(5)))

check("control: F(iota x) = F(x) on the second path",
      p11_zero(p11_add(apply_iota11(sym_to_p11(F_sym)),
                       p11_scal(m11s(-1, ONE11), sym_to_p11(F_sym)))))

print("  => <sigma, tau, iota> = G (660, section B), so C1+C2+C3 are exactly")
print("     G-covariance: D_4 in Cov_4 and D_5 in Cov_5, on a second path.")


# ===========================================================================
# SECTION D.  The candidate space on X is one-dimensional in both cells.
# ===========================================================================

banner("SECTION D.  ((S/F)_{d'} (x) W)^G, the space of candidate restricted maps")

lam, mu = sp.symbols("lambda mu")


def F_of_tuple(B):
    """F(B) = sum B_i^2 B_{i+1}, the condition-defining substitution."""
    return sp.expand(sum(B[i] ** 2 * B[(i + 1) % 5] for i in range(5)))


def normal_form_mod_F(P, gens=None):
    """Groebner normal form modulo the principal ideal (F).  A single polynomial
    is a Groebner basis of the ideal it generates, so nf(P) = 0 <=> P in (F).
    (sympy's `div` is NOT a full multivariate reduction and must not be used.)"""
    gens = gens or list(xs)
    if P == 0:
        return sp.Integer(0)
    _, r = sp.reduced(P, [F_sym], *gens, order="grevlex")
    return sp.expand(r)


check("normal-form sanity: nf(F) = 0", normal_form_mod_F(F_sym) == 0)
check("normal-form sanity: nf(F * x0^7) = 0", normal_form_mod_F(sp.expand(F_sym * x0 ** 7)) == 0)
check("normal-form sanity: nf(x0^3) != 0", normal_form_mod_F(x0 ** 3) != 0)

Fx_sym = [sp.expand(F_sym * xs[i]) for i in range(5)]


def in_span_of_cov(d, T_sym):
    """Solve for T_sym inside the exactly-computed Cov_d; returns the coefficient
    vector over Q(zeta_11), or None."""
    alphas, ker = cov[d]
    # component 0 determines everything (sigma-covariance), and is supported on alphas
    P = sp.Poly(T_sym[0], *xs)
    supp = {tuple(int(v) for v in m): int(c) for m, c in zip(P.monoms(), P.coeffs())}
    if not set(supp) <= set(alphas):
        return None
    target = [fscale(FONE, Fr(supp.get(a, 0))) for a in alphas]
    rows = []
    for r in range(len(alphas)):
        rows.append([ker[i][r] for i in range(len(ker))] + [fscale(target[r], Fr(-1))])
    K = k11_nullspace(rows, len(alphas), len(ker) + 1)
    for v in K:
        if not fiszero(v[-1]):
            inv = fast_inverse(v[-1])
            return tuple(fmul(v[i], inv) for i in range(len(ker)))
    return None


check("F*x lies in Cov_4 (it is the image of the identity tuple x in Cov_1 "
      "under multiplication by F)", in_span_of_cov(4, Fx_sym) is not None)
check("D_4 lies in Cov_4", in_span_of_cov(4, D4_sym) is not None)

# {F*x, D_4} is a basis of Cov_4: both lie in it, dim = 2, and they are
# independent because F*x restricts to 0 on X while D_4 does not.
check("F*x restricts to 0 on X, componentwise",
      all(normal_form_mod_F(Fx_sym[i]) == 0 for i in range(5)))
check("D_4 does not restrict to 0 on X (so {F*x, D_4} is a basis of Cov_4)",
      any(normal_form_mod_F(D4_sym[i]) != 0 for i in range(5)))
check("D_5 does not restrict to 0 on X",
      any(normal_form_mod_F(D5_sym[i]) != 0 for i in range(5)))
check("dim Cov_4 = 2, so Cov_4 = span{F*x, D_4} exactly", len(cov[4][1]) == 2)

check("dim Cov_1 = 1 (the identity tuple x), so ker(Cov_4 -> Cov_4 mod F) = C*(F*x)",
      len(cov[1][1]) == 1)
check("dim Cov_2 = 0, so ker(Cov_5 -> Cov_5 mod F) = F*Cov_2 = 0",
      len(cov[2][1]) == 0)

print()
print("  Multiplication by F is an injective G-map Cov_{d'-3} -> Cov_{d'}, and")
print("  G-invariants are exact in characteristic zero, so")
print("      dim ((S/F)_{d'} (x) W)^G = C(d') - C(d'-3).")
print(f"    d' = 4:  C(4) - C(1) = {len(cov[4][1])} - {len(cov[1][1])} = "
      f"{len(cov[4][1]) - len(cov[1][1])}   spanned by D_4 mod F")
print(f"    d' = 5:  C(5) - C(2) = {len(cov[5][1])} - {len(cov[2][1])} = "
      f"{len(cov[5][1]) - len(cov[2][1])}   spanned by D_5 mod F")
check("cell k = 31 (d' = 4): the candidate space is ONE-dimensional",
      len(cov[4][1]) - len(cov[1][1]) == 1)
check("cell k = 30 (d' = 5): the candidate space is ONE-dimensional",
      len(cov[5][1]) - len(cov[2][1]) == 1)
# and, for the record, the same bookkeeping reproduces the sealed d' = 2, 3 exclusion
check("cross-check: d' = 2 candidate space is C(2) - C(-1) = 0 (independent "
      "re-proof of RESTRICTED-COORDINATE-DEGREE-TWO-EXCLUDED, with no dominance "
      "hypothesis)", len(cov[2][1]) == 0)
check("cross-check: d' = 3 candidate space is C(3) - C(0) = 0 - 0 = 0 (same for d' = 3)",
      len(cov[3][1]) == 0)


# ===========================================================================
# SECTION E.  THE KILL: F(B) is not 0 on X, for every candidate in either cell.
# ===========================================================================

banner("SECTION E.  The kill: F(B) != 0 on X for every candidate")

# ---- (E1) cell k = 31, d' = 4: the whole Cov_4 pencil, parametrically -------
pencil4 = [sp.expand(lam * Fx_sym[i] + mu * D4_sym[i]) for i in range(5)]
nf_pencil4_comp = [normal_form_mod_F(pencil4[i], list(xs) + [lam, mu]) for i in range(5)]
deg_eqs = []
for i in range(5):
    for c in sp.Poly(nf_pencil4_comp[i], *xs).coeffs():
        deg_eqs.append(sp.expand(c))
sol4 = sp.solve(deg_eqs, [lam, mu], dict=True)
check("Cov_4 pencil: the degeneration locus (members restricting to 0 on X) is "
      f"exactly mu = 0, i.e. the member F*x   [solve gave {sol4}]",
      sol4 == [{mu: 0}])

nf4 = normal_form_mod_F(F_of_tuple(pencil4), list(xs) + [lam, mu])
p4 = sp.Poly(nf4, lam, mu)
check("Cov_4 pencil: nf(F(B)) is not identically zero", nf4 != 0)
# mod F the pencil is mu*D_4, so F(B) = mu^3 * F(D_4) mod F: only mu^3 survives
check("Cov_4 pencil: nf(F(B)) = mu^3 * nf(F(D_4)) -- only the mu^3 monomial occurs",
      set(p4.monoms()) == {(0, 3)})
nf4_D4 = normal_form_mod_F(F_of_tuple(D4_sym))
check("Cov_4: nf(F(D_4)) != 0, i.e. F(D_4) is NOT in the ideal (F)", nf4_D4 != 0)
check("Cov_4: the mu^3 coefficient really is nf(F(D_4))",
      sp.expand(p4.coeff_monomial(mu ** 3) - nf4_D4) == 0)
print(f"    nf(F(D_4)) has {len(sp.Poly(nf4_D4, *xs).terms())} terms, "
      f"degree {sp.Poly(nf4_D4, *xs).total_degree()}")

# ---- (E2) cell k = 30, d' = 5 ----------------------------------------------
nf5_D5 = normal_form_mod_F(F_of_tuple(D5_sym))
check("Cov_5: nf(F(D_5)) != 0, i.e. F(D_5) is NOT in the ideal (F)", nf5_D5 != 0)
print(f"    nf(F(D_5)) has {len(sp.Poly(nf5_D5, *xs).terms())} terms, "
      f"degree {sp.Poly(nf5_D5, *xs).total_degree()}")
cc = sp.Symbol("c")
nf5_scaled = normal_form_mod_F(F_of_tuple([sp.expand(cc * D5_sym[i]) for i in range(5)]),
                               list(xs) + [cc])
check("Cov_5: nf(F(c*D_5)) = c^3 * nf(F(D_5)) exactly, so every nonzero member of "
      "the one-dimensional space fails identically",
      sp.expand(nf5_scaled - cc ** 3 * nf5_D5) == 0)

# ---- (E3) independent certificates: exact integer points of X --------------
CAND_PTS = [(1, 1, 1, -2, 0), (0, 1, 1, -1, 0), (1, 1, -1, 0, 0), (2, 1, 1, -5, 0),
            (1, 0, 0, 0, 0), (3, 1, 1, -10, 0), (1, 2, -2, 1, 0)]
X_PTS = [p for p in CAND_PTS if sum(p[i] ** 2 * p[(i + 1) % 5] for i in range(5)) == 0]
check(f"{len(X_PTS)} exact integer points of X found among the candidates",
      len(X_PTS) >= 4)


def eval_tuple(T, p):
    s = dict(zip(xs, p))
    return [int(sp.expand(T[i].subs(s))) for i in range(5)]


def F_int(v):
    return sum(v[i] ** 2 * v[(i + 1) % 5] for i in range(5))


print()
print("  Point certificates (p in X, so F(B) in (F) would force F(B(p)) = 0):")
wit4 = wit5 = None
for p in X_PTS:
    v4, v5 = eval_tuple(D4_sym, p), eval_tuple(D5_sym, p)
    f4, f5v = F_int(v4), F_int(v5)
    print(f"    p = {p}:  F(D_4(p)) = {f4:>16}   F(D_5(p)) = {f5v}")
    if f4 != 0 and wit4 is None:
        wit4 = (p, f4)
    if f5v != 0 and wit5 is None:
        wit5 = (p, f5v)
check(f"certificate for D_4: p = {wit4[0]} in X with F(D_4(p)) = {wit4[1]} != 0",
      wit4 is not None)
check(f"certificate for D_5: p = {wit5[0]} in X with F(D_5(p)) = {wit5[1]} != 0",
      wit5 is not None)
check("each certificate point really lies on X",
      all(sum(p[i] ** 2 * p[(i + 1) % 5] for i in range(5)) == 0 for p in X_PTS))


# ===========================================================================
# SECTION F.  Positive controls -- the test is not vacuously always-failing.
# ===========================================================================

banner("SECTION F.  Positive controls")

check("control: the identity tuple B = x (d' = 1, the retraction branch) PASSES: "
      "nf(F(x)) = 0", normal_form_mod_F(F_of_tuple(list(xs))) == 0)
check("control: B = sigma(x) = (x1,x2,x3,x4,x0), a group element, PASSES: "
      "nf(F(sigma x)) = 0",
      normal_form_mod_F(F_of_tuple([x1, x2, x3, x4, x0])) == 0)
check("control: B = (x0^4, x1^4, x2^4, x3^4, x4^4) (not equivariant) FAILS",
      normal_form_mod_F(F_of_tuple([xs[i] ** 4 for i in range(5)])) != 0)


# ===========================================================================
# SECTION G.  Robustness annex: the outer-twisted equivariance convention.
# ===========================================================================

banner("SECTION G.  Annex: the outer-automorphism-twisted convention")

# PSL(2,11) has two 5-dimensional irreducible representations, swapped by its
# outer automorphism and by complex conjugation.  A tuple could conceivably
# intertwine the two: T(rho(g) x) = rho'(g) T(x).  rho' = gamma o rho for the
# field automorphism gamma : zeta -> zeta^2 (2 is a non-residue mod 11, so gamma
# sends sqrt(-11) to -sqrt(-11)).  F is rho'-invariant too, so this convention is
# self-consistent; the packet's convention is the untwisted one.  We kill the
# twisted cells as well, so the verdict does not depend on the convention.

iota_p = [[galois_apply(iota_f[i][j], 2) for j in range(5)] for i in range(5)]
sigma_p = [[galois_apply(sigma_f[i][j], 2) for j in range(5)] for i in range(5)]
tau_p = [[galois_apply(tau_f[i][j], 2) for j in range(5)] for i in range(5)]
check("twisted: sigma' = sigma (rational entries)", mat_eq(sigma_p, sigma_f))
check("twisted: tau' = tau^2, so the seed tau-weight becomes 2*a_0 = 2",
      all(feq(tau_p[i][i], funit(2 * WEIGHTS[i])) for i in range(5)))
check("twisted: iota' != iota (the two 5-dim irreps are genuinely different)",
      not mat_eq(iota_p, iota_f))
for nm, M in (("sigma'", sigma_p), ("tau'", tau_p), ("iota'", iota_p)):
    check(f"twisted: F({nm} x) = F(x), so rho' also preserves the Klein cubic",
          len(F_of_matrix_action(M)) == 0)

TW_EXPECT = {1: 0, 2: 1, 3: 0, 4: 1, 5: 2}
covt = {}
for d in range(1, 6):
    alphas, ker = compute_cov(d, iota_p, 2)
    covt[d] = (alphas, ker)
    check(f"twisted: dim Cov^theta_{d} = {TW_EXPECT[d]}", len(ker) == TW_EXPECT[d])

print()
print(f"  twisted candidate space at d' = 4:  {len(covt[4][1])} - {len(covt[1][1])} "
      f"= {len(covt[4][1]) - len(covt[1][1])}")
print(f"  twisted candidate space at d' = 5:  {len(covt[5][1])} - {len(covt[2][1])} "
      f"= {len(covt[5][1]) - len(covt[2][1])}")
check("twisted d' = 4 candidate space is one-dimensional",
      len(covt[4][1]) - len(covt[1][1]) == 1)
check("twisted d' = 5 candidate space is one-dimensional",
      len(covt[5][1]) - len(covt[2][1]) == 1)

ft4, Q4n = classify_and_normalize(expand_covariant(covt[4][0], covt[4][1][0]))
check("twisted degree-4 generator is defined over Q", ft4 == "Q")
Q4_sym = [dict_to_sym(Q4n[i]) for i in range(5)]
check("twisted d' = 4: nf(F(Q_4)) != 0 -- the unique candidate does not map X to X",
      normal_form_mod_F(F_of_tuple(Q4_sym)) != 0)

# twisted degree 5 is a pencil; its degeneration locus is F * (twisted Cov_2)
P0s = [dict_to_sym(classify_and_normalize(expand_covariant(covt[5][0], covt[5][1][0]))[1][i])
       for i in range(5)]
P1s = [dict_to_sym(classify_and_normalize(expand_covariant(covt[5][0], covt[5][1][1]))[1][i])
       for i in range(5)]
pencil5t = [sp.expand(lam * P0s[i] + mu * P1s[i]) for i in range(5)]
nf5t = normal_form_mod_F(F_of_tuple(pencil5t), list(xs) + [lam, mu])
p5t = sp.Poly(nf5t, lam, mu)
deg_eqs_t = []
for i in range(5):
    for c in sp.Poly(normal_form_mod_F(pencil5t[i], list(xs) + [lam, mu]), *xs).coeffs():
        deg_eqs_t.append(sp.expand(c))
sol5t = sp.solve(deg_eqs_t, [lam, mu], dict=True)
check(f"twisted d' = 5 pencil: degeneration locus is a single point {sol5t}",
      len(sol5t) == 1)
# identify the degenerate member: it must be F times a twisted quadratic covariant
degen = [sp.expand(pencil5t[i].subs(sol5t[0]).subs({lam: 1, mu: 1})) for i in range(5)]
Q2s = []
for i in range(5):
    q, r = sp.div(sp.Poly(degen[i], *xs), sp.Poly(F_sym, *xs))
    check(f"twisted d' = 5: degenerate member component {i} is divisible by F",
          r.is_zero)
    Q2s.append(sp.expand(q.as_expr()))
Q2_expected = [sp.expand(-(xs[i] ** 2 + 2 * xs[(i + 1) % 5] * xs[(i + 2) % 5]))
               for i in range(5)]
scal = sp.simplify(Q2s[0] / Q2_expected[0])
check("twisted d' = 5: the degenerate member is F * Q_2 with "
      "Q_2[i] = -(x_i^2 + 2 x_{i+1} x_{i+2}), up to one overall scalar",
      scal.is_number and scal != 0
      and all(sp.expand(Q2s[i] - scal * Q2_expected[i]) == 0 for i in range(5)))
check("twisted d' = 5: Q_2 spans the twisted Cov_2 (dim 1), so the degenerate "
      "member is exactly the kernel of restriction", len(covt[2][1]) == 1)

nf5t_P0 = normal_form_mod_F(F_of_tuple(P0s))
check("twisted d' = 5: nf(F(P_0)) != 0 for the generator mod F", nf5t_P0 != 0)
check("twisted d' = 5: nf(F(B)) = (lambda + mu)^3 * nf(F(P_0)) exactly -- the only "
      "member that passes is the degenerate one, which restricts to 0 on X",
      sp.expand(nf5t - (lam + mu) ** 3 * nf5t_P0) == 0)
for p in X_PTS[:3]:
    v = eval_tuple(Q4_sym, p)
    if F_int(v) != 0:
        check(f"twisted d' = 4 point certificate: p = {p}, F(Q_4(p)) = {F_int(v)} != 0", True)
        break
for p in X_PTS[:3]:
    v = eval_tuple(P0s, p)
    if F_int(v) != 0:
        check(f"twisted d' = 5 point certificate: p = {p}, F(P_0(p)) = {F_int(v)} != 0", True)
        break


# ===========================================================================
# SECTION H.  Consequences for the branch table.
# ===========================================================================

banner("SECTION H.  Consequences")

print("""  The argument uses no property of the ambient degree d.  Hence:

    d' = 4 and d' = 5 are impossible in EVERY ambient degree d,
    unconditionally -- no dominance hypothesis, no ed_C(G) >= 3.

  Combined with the sealed invariant-degree lemma (k in {0} u {5,6,...}) and
  the sealed d' in {2,3} exclusion, the surviving restricted-degree set is

        d' = 1  (retraction, k = d-1)
   or   d' in {6,7,...,d-5}
   or   d' = d  (k = 0, necessarily CARRIER).

  At d = 35 the common-factor cells k = 30 and k = 31 are EXCLUDED, joining
  k = 32, 33.  Open cells at d = 35: k = 0, k = 5..29, k = 34 -- 27 in all,
  down from 29.""")

SURV_35 = [0] + list(range(5, 30)) + [34]
check("d = 35: surviving k-set is {0} u {5..29} u {34}, 27 cells",
      len(SURV_35) == 27 and 30 not in SURV_35 and 31 not in SURV_35)
check("d = 35: the two cells this packet decides are k = 30 (d' = 5) and "
      "k = 31 (d' = 4)", 35 - 30 == 5 and 35 - 31 == 4)
print("  (Degree-uniformity is a property of the argument, not a computation: no")
print("   step of sections D or E refers to the ambient degree d.  Recorded as a")
print("   reading of the proof, not asserted as a check.)")

print()
print("  Tests NOT reached, and why: dominance of [B|_X], the ramification")
print("  determinant j_phi and its membership in the 1-dimensional spaces")
print("  H^0(X,O(6))^G / H^0(X,O(8))^G, the restricted base locus, the")
print("  topological degree delta and the CLEAN norm test on delta all presuppose")
print("  a restricted selfmap phi = [B|_X] : X --> X.  In both cells no such phi")
print("  exists, so those quantities are undefined rather than uncomputed.")

banner(f"RESULT: {'PASS' if RESULT_OK else 'FAIL'}   ({NCHECK} checks)")
sys.exit(0 if RESULT_OK else 1)
