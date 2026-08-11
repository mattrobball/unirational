#!/usr/bin/env python3
"""Exact per-support decision procedure for the F55 cyclic trace cubic.

Object (F55_POLAR_CIRCUIT_PROOF_REDUCTION_20260808.md, sections 1--3):

    M = Z^5 / Z(1,1,1,1,1),  R = C[M],  sigma(e_i) = e_{i+1},
    Phi(a) = sum_{i=0}^4 sigma^i( chi^{-e_2} a^2 sigma(a) ).

For a finite support S subset M and a = sum_{s in S} A_s chi^s, Proposition 3.1
compiles Phi(a) = sum_gamma F_gamma(A) chi^gamma with

    F_gamma = sum_{i, p <= q, r in S, T_i(p,q;r) = gamma} mu(p,q) A_p A_q A_r,
    T_i(p,q;r) = sigma^i(p + q + sigma r - e_2),  mu(p,q) = 1 if p = q else 2.

Theorem 3.2 (the gate): a trace-cubic zero with support exactly S exists over C
iff I_S : m_S^infty != (1), where I_S = (F_gamma) and m_S = prod_{s in S} A_s.
Equivalently, nonexistence is certified by one identity m_S^N = sum H_gamma
F_gamma.

What this script does
---------------------
C0  rebuilds every row twice -- once by the Proposition 3.1 formula, once by
    direct Laurent expansion in the group algebra -- and compares them.
C2  decides I_S : m_S^infty = (1) exactly, by the Rabinowitsch test
    1 in I_S + (1 - t*m_S) over Q, with a self-contained Buchberger engine.
BOTH DIRECTIONS.  For every worked support the script extracts a minimal
    subset of rows that is already unit after saturation (a cancellation core),
    and then deletes one row of that core and exhibits an EXPLICIT exact torus
    point of the remainder -- so the gate is shown returning a proper ideal as
    well as the unit ideal, on real F55 data.
The substantive support is S16, the deletion-minimal 16-point core of
    F55_COVERAGE_C_ADJUDICATION_20260808.md section 2.  This script rebuilds
    its rows from scratch and re-derives the repo's monomial identity (2.2)
    independently.

Terminal marker: F55_SATURATION_SUPPORTS_OK
"""

from fractions import Fraction
from itertools import combinations_with_replacement
import itertools

# ==========================================================================
# lattice M = Z^5 / Z(1,1,1,1,1), normalised by making the last entry zero
# ==========================================================================

def norm(v):
    t = v[4]
    return tuple(v[i] - t for i in range(5))


def sigma(v):
    """sigma on Z^5: e_i -> e_{i+1}, i.e. (sigma v)_i = v_{i-1}."""
    return norm(tuple(v[(i - 1) % 5] for i in range(5)))


def add(*vs):
    return norm(tuple(sum(v[i] for v in vs) for i in range(5)))


def neg(v):
    return norm(tuple(-v[i] for i in range(5)))


def sigma_pow(v, k):
    for _ in range(k % 5):
        v = sigma(v)
    return v


def e(i):
    v = [0] * 5
    v[i] = 1
    return norm(tuple(v))


E2 = e(2)
ZERO = norm((0, 0, 0, 0, 0))


# ==========================================================================
# multivariate polynomials over Q:  dict {exponent tuple: Fraction}
# ==========================================================================

def p_zero():
    return {}


def p_add(f, g):
    out = dict(f)
    for m, c in g.items():
        nc = out.get(m, Fraction(0)) + c
        if nc:
            out[m] = nc
        else:
            out.pop(m, None)
    return out


def p_scale(f, c):
    if c == 0:
        return {}
    return {m: v * c for m, v in f.items()}


def p_mul(f, g):
    out = {}
    for m1, c1 in f.items():
        for m2, c2 in g.items():
            m = tuple(a + b for a, b in zip(m1, m2))
            nc = out.get(m, Fraction(0)) + c1 * c2
            if nc:
                out[m] = nc
            else:
                out.pop(m, None)
    return out


def p_var(n, i):
    return {tuple(1 if j == i else 0 for j in range(n)): Fraction(1)}


def p_const(n, c):
    if c == 0:
        return {}
    return {tuple(0 for _ in range(n)): Fraction(c)}


class GQ:
    """Exact Gaussian rationals a + b*i, for exhibiting torus points."""

    __slots__ = ("a", "b")

    def __init__(self, a, b=0):
        self.a = Fraction(a)
        self.b = Fraction(b)

    def _c(self, o):
        return o if isinstance(o, GQ) else GQ(o)

    def __add__(self, o):
        o = self._c(o)
        return GQ(self.a + o.a, self.b + o.b)

    __radd__ = __add__

    def __neg__(self):
        return GQ(-self.a, -self.b)

    def __sub__(self, o):
        return self + (-self._c(o))

    def __rsub__(self, o):
        return self._c(o) + (-self)

    def __mul__(self, o):
        o = self._c(o)
        return GQ(self.a * o.a - self.b * o.b, self.a * o.b + self.b * o.a)

    __rmul__ = __mul__

    def __pow__(self, n):
        r = GQ(1)
        for _ in range(n):
            r = r * self
        return r

    def __eq__(self, o):
        try:
            o = self._c(o)
        except (TypeError, ValueError):
            return NotImplemented
        return self.a == o.a and self.b == o.b

    def __hash__(self):
        return hash((self.a, self.b))

    def __bool__(self):
        return bool(self.a) or bool(self.b)

    def __repr__(self):
        if self.b == 0:
            return str(self.a)
        if self.a == 0:
            return f"{self.b}i" if self.b != 1 else "i"
        return f"{self.a}{'+' if self.b > 0 else '-'}{abs(self.b)}i"


def _key(m):
    """degrevlex."""
    return (sum(m), tuple(-x for x in reversed(m)))


def lead(f):
    return max(f, key=_key)


def p_str(f, names):
    if not f:
        return "0"
    parts = []
    for m in sorted(f, key=_key, reverse=True):
        c = f[m]
        mono = "*".join((names[i] if x == 1 else f"{names[i]}^{x}")
                        for i, x in enumerate(m) if x)
        if not mono:
            parts.append(str(c))
        elif c == 1:
            parts.append(mono)
        elif c == -1:
            parts.append("-" + mono)
        else:
            parts.append(f"{c}*{mono}")
    return " + ".join(parts).replace("+ -", "- ")


def p_eval(f, pt):
    tot = 0
    for m, c in f.items():
        term = c
        for k, ex in enumerate(m):
            if ex:
                term = term * pt[k] ** ex
        tot = tot + term
    return tot


# ==========================================================================
# Buchberger (degrevlex, coefficients in Q)
# ==========================================================================

def _divides(a, b):
    return all(x <= y for x, y in zip(a, b))


def normal_form(f, G):
    f = dict(f)
    out = {}
    while f:
        m = lead(f)
        c = f[m]
        red = False
        for g in G:
            lg = lead(g)
            if _divides(lg, m):
                q = tuple(x - y for x, y in zip(m, lg))
                f = p_add(f, p_scale(p_mul({q: Fraction(1)}, g), -c / g[lg]))
                red = True
                break
        if not red:
            out[m] = c
            f = dict(f)
            f.pop(m)
    return out


def spoly(f, g):
    lf, lg = lead(f), lead(g)
    L = tuple(max(a, b) for a, b in zip(lf, lg))
    qf = tuple(a - b for a, b in zip(L, lf))
    qg = tuple(a - b for a, b in zip(L, lg))
    return p_add(p_scale(p_mul({qf: Fraction(1)}, f), Fraction(1) / f[lf]),
                 p_scale(p_mul({qg: Fraction(1)}, g), Fraction(-1) / g[lg]))


def groebner(F, budget=400000):
    G = [dict(f) for f in F if f]
    for f in G:
        if len(f) == 1 and all(x == 0 for x in lead(f)):
            return [f]
    pairs = [(i, j) for i in range(len(G)) for j in range(i)]
    steps = 0
    while pairs:
        pairs.sort(key=lambda ij: _key(tuple(
            max(a, b) for a, b in zip(lead(G[ij[0]]), lead(G[ij[1]])))))
        i, j = pairs.pop(0)
        li, lj = lead(G[i]), lead(G[j])
        if all(min(a, b) == 0 for a, b in zip(li, lj)):
            continue
        h = normal_form(spoly(G[i], G[j]), G)
        steps += 1
        if steps > budget:
            raise RuntimeError("Buchberger budget exceeded")
        if h:
            lh = lead(h)
            h = p_scale(h, Fraction(1) / h[lh])
            if all(x == 0 for x in lh):
                return [h]
            G.append(h)
            k = len(G) - 1
            pairs.extend((k, t) for t in range(k))
    return G


def sat_is_unit(polys, nvars, sat_vars=None):
    """Decide  (polys) : (prod_{k in sat_vars} x_k)^infty  = (1)."""
    sat_vars = list(range(nvars)) if sat_vars is None else list(sat_vars)
    N = nvars + 1
    F = [{tuple(list(m) + [0]): c for m, c in f.items()} for f in polys if f]
    prod = p_const(N, 1)
    for k in sat_vars:
        prod = p_mul(prod, p_var(N, k))
    F.append(p_add(p_const(N, 1), p_scale(p_mul(p_var(N, nvars), prod), -1)))
    G = groebner(F)
    return any(len(g) == 1 and all(x == 0 for x in lead(g)) for g in G)


# ==========================================================================
# the trace compiler
# ==========================================================================

def compile_rows(S, twist=E2):
    n = len(S)
    idx = {s: k for k, s in enumerate(S)}
    rows = {}
    for i in range(5):
        for p, q in combinations_with_replacement(S, 2):
            mu = 1 if p == q else 2
            for r in S:
                gam = sigma_pow(add(p, q, sigma(r), neg(twist)), i)
                mono = [0] * n
                mono[idx[p]] += 1
                mono[idx[q]] += 1
                mono[idx[r]] += 1
                cur = rows.setdefault(gam, {})
                key = tuple(mono)
                nc = cur.get(key, Fraction(0)) + mu
                if nc:
                    cur[key] = nc
                else:
                    cur.pop(key, None)
    return {g: r for g, r in rows.items() if r}


def compile_rows_direct(S, twist=E2):
    """Independent rebuild: literal Laurent expansion in the group algebra."""
    n = len(S)
    a = {s: p_var(n, k) for k, s in enumerate(S)}

    def lmul(f, g):
        out = {}
        for m1, c1 in f.items():
            for m2, c2 in g.items():
                ex = add(m1, m2)
                out[ex] = p_add(out.get(ex, p_zero()), p_mul(c1, c2))
        return {ex: c for ex, c in out.items() if c}

    def lsig(f):
        return {sigma(ex): c for ex, c in f.items()}

    body = lmul(lmul(lmul(a, a), lsig(a)), {neg(twist): p_const(n, 1)})
    total = {}
    cur = body
    for _ in range(5):
        for ex, c in cur.items():
            total[ex] = p_add(total.get(ex, p_zero()), c)
        cur = lsig(cur)
    return {ex: c for ex, c in total.items() if c}


# ==========================================================================
# reporting
# ==========================================================================

FAIL = []


def check(name, cond, detail=""):
    print(f"  [{'OK  ' if cond else 'FAIL'}] {name}" + (f"   {detail}" if detail else ""))
    if not cond:
        FAIL.append(name)


def minimal_core(rows, n):
    """A subset of rows already unit after saturation, minimal under deletion."""
    keys = sorted(rows, key=lambda g: (len(rows[g]), g))
    core = list(keys)
    if not sat_is_unit([rows[g] for g in core], n):
        return None
    changed = True
    while changed:
        changed = False
        for g in list(core):
            trial = [x for x in core if x != g]
            if trial and sat_is_unit([rows[x] for x in trial], n):
                core = trial
                changed = True
                break
    return core


def torus_point(polys, n, grid=None):
    """Exact torus point of a small system, by Gaussian-rational grid search."""
    if grid is None:
        grid = [GQ(a) for a in (1, -1, 2, -2, 3, -3)] + \
               [GQ(0, 1), GQ(0, -1), GQ(1, 1), GQ(1, -1), GQ(-1, 1),
                GQ(Fraction(1, 2)), GQ(Fraction(-1, 2))]
    free = sorted({k for f in polys for m in f for k in range(n) if m[k]})
    if not free:
        return tuple(GQ(1) for _ in range(n))
    for vals in itertools.product(grid, repeat=len(free)):
        pt = [GQ(1)] * n
        for k, v in zip(free, vals):
            pt[k] = v
        if all(p_eval(f, pt) == 0 for f in polys):
            return tuple(pt)
    return None


def run_support(label, S, twist=E2, show_rows=False, do_core=True):
    n = len(S)
    print(f"\n  {label}")
    print(f"    S = {[list(s) for s in S]}   twist exponent = {list(twist)}")
    r1 = compile_rows(S, twist)
    r2 = compile_rows_direct(S, twist)
    same = set(r1) == set(r2) and all(r1[g] == r2[g] for g in r1)
    check(f"C0 compiler regression [{label}]", same,
          f"{len(r1)} rows agree with direct Laurent expansion")
    names = [f"A{k}" for k in range(n)]
    if show_rows:
        for g in sorted(r1):
            print(f"        F[{list(g)}] = {p_str(r1[g], names)}")
    unit = sat_is_unit(list(r1.values()), n)
    check(f"C2 gate [{label}]: I_S : m_S^inf = (1)", unit is True,
          f"got {unit}")
    if do_core and unit:
        core = minimal_core(r1, n)
        check(f"a deletion-minimal unit core exists [{label}]", core is not None,
              f"|core| = {len(core) if core else 0} of {len(r1)} rows")
        if core:
            for g in core:
                print(f"        core row F[{list(g)}] = {p_str(r1[g], names)}")
            # THE GATE THE OTHER WAY: drop one core row
            g0 = core[0]
            rest = [r1[g] for g in core if g != g0]
            unit2 = sat_is_unit(rest, n) if rest else False
            check(f"gate returns a PROPER ideal after deleting one core row "
                  f"[{label}]", unit2 is False, f"got unit={unit2}")
            pt = torus_point(rest, n)
            check(f"explicit exact torus point of the reduced system [{label}]",
                  pt is not None and all(c != 0 for c in pt), f"point = {pt}")
            if pt is not None:
                check(f"the point annihilates every retained row [{label}]",
                      all(p_eval(f, pt) == 0 for f in rest))
                check(f"the deleted row is nonzero at that point [{label}]",
                      p_eval(r1[g0], pt) != 0,
                      f"F[{list(g0)}] = {p_eval(r1[g0], pt)}")
    return r1


# ==========================================================================
# main
# ==========================================================================

def main():
    print("F55 exact per-support saturation criterion  (Theorem 3.2 gate)")
    print("=" * 72)

    print("\nPART 1 -- small supports, authoritative twist exponent e_2")

    r1 = run_support("S1 = {0}  (a single monomial)", (ZERO,), show_rows=True)
    orb = {sigma_pow(neg(E2), i) for i in range(5)}
    check("S1: exactly five rows, the sigma-orbit of -e_2, each = A0^3",
          set(r1) == orb and len(orb) == 5
          and all(list(r.values()) == [Fraction(1)] for r in r1.values()),
          f"{len(r1)} rows")
    print("        (Lemma 2.3: the orbit has size 5 because M^sigma = 0, and")
    print("         every coefficient is positive, so no monomial is a zero.)")

    run_support("S2 = {0, e_0}", (ZERO, e(0)))
    run_support("S3 = {0, e_0 - e_1}", (ZERO, add(e(0), neg(e(1)))))
    run_support("S4 = {e_0, e_1}  (the r_0 - r_1 pentagon-chain segment)",
                (e(0), e(1)))
    run_support("S5 = {0, e_0, e_1}", (ZERO, e(0), e(1)))

    print("\nPART 2 -- the substantive support: Coverage-C's 16-point core")
    print("  Source: F55_COVERAGE_C_ADJUDICATION_20260808.md, (2.1).")
    S16_raw = [(0, 1, 0, 0, 3), (0, 1, 3, 0, 0), (0, 2, 0, 0, 2),
               (0, 2, 0, 1, 1), (0, 2, 1, 0, 1), (0, 2, 2, 0, 0),
               (0, 3, 0, 1, 0), (1, 1, 0, 0, 2), (1, 1, 0, 2, 0),
               (1, 1, 2, 0, 0), (1, 2, 0, 0, 1), (1, 2, 0, 1, 0),
               (1, 2, 1, 0, 0), (1, 3, 0, 0, 0), (2, 1, 0, 0, 1),
               (2, 1, 1, 0, 0)]
    S16 = tuple(norm(p) for p in S16_raw)
    check("the 16 listed points stay distinct in M", len(set(S16)) == 16)
    rows16 = compile_rows(S16)
    rows16d = compile_rows_direct(S16)
    check("C0 compiler regression [S16]",
          set(rows16) == set(rows16d)
          and all(rows16[g] == rows16d[g] for g in rows16),
          f"{len(rows16)} rows agree with direct Laurent expansion")

    # Coverage-C filter results 1 and 2, re-derived independently
    singles = [g for g, r in rows16.items() if len(r) == 1]
    check("Coverage-C (1): no nonzero row of S16 is a singleton",
          len(singles) == 0, f"{len(singles)} singleton rows")
    all_del_singleton = True
    for k in range(16):
        Sd = tuple(s for j, s in enumerate(S16) if j != k)
        rd = compile_rows(Sd)
        if not any(len(r) == 1 for r in rd.values()):
            all_del_singleton = False
            break
    check("Coverage-C (2): deleting any one point of S16 creates a singleton "
          "row", all_del_singleton)

    names16 = [f"A{k}" for k in range(16)]
    want = {
        "f1": "A0^2*A8 + A6^2*A15",
        "f2": "A0^2*A11 + 2*A3*A6*A15",
        "f3": "2*A0*A2*A8 + A6^2*A9",
        "h":  "2*A0*A2*A11 + 2*A0*A4*A8 + 2*A3*A6*A9",
    }
    got = {}
    for lab, tgt in want.items():
        tgtset = set(tgt.replace(" ", "").split("+"))
        hits = [g for g, r in rows16.items()
                if set(p_str(r, names16).replace(" ", "").split("+")) == tgtset]
        check(f"row {lab} of Coverage-C (2.2) is reproduced by this compiler",
              len(hits) == 5, f"{len(hits)} occurrences (one per sigma-orbit)")
        if hits:
            got[lab] = rows16[hits[0]]

    if len(got) == 4:
        A = lambda k: p_var(16, k)
        lhs = p_add(
            p_add(p_mul(p_mul(A(0), A(6)), got["h"]),
                  p_scale(p_mul(p_mul(A(2), A(6)), got["f2"]), Fraction(-2))),
            p_add(p_scale(p_mul(p_mul(A(0), A(3)), got["f3"]), Fraction(-2)),
                  p_scale(p_mul(p_mul(A(2), A(3)), got["f1"]), Fraction(4))))
        rhs = p_scale(p_mul(p_mul(p_mul(p_mul(A(0), A(0)), A(4)),
                                  p_mul(A(6), A(8))), p_const(16, 1)),
                      Fraction(2))
        check("Coverage-C identity (2.2) holds exactly: "
              "A0A6h - 2A2A6f2 - 2A0A3f3 + 4A2A3f1 = 2A0^2A4A6A8",
              lhs == rhs, f"lhs - rhs = {p_str(p_add(lhs, p_scale(rhs, -1)), names16)}")
        check("its right-hand side is a monomial, hence a unit on the "
              "coefficient torus => I_S16 : m_S16^inf = (1) by Theorem 3.2",
              len(rhs) == 1)

        # ---- THE GATE THE OTHER WAY, on the same four rows ----
        print("\n  the gate the other way, on the same real F55 rows:")
        sub = [got["f1"], got["f2"], got["f3"]]
        pt = [Fraction(0)] * 16
        # A0 = A6 = 1, A15 = 1, A2 = 1, A3 = 1, A4 = 1 forces the rest
        pt[0] = Fraction(1); pt[6] = Fraction(1); pt[15] = Fraction(1)
        pt[2] = Fraction(1); pt[3] = Fraction(1); pt[4] = Fraction(1)
        pt[8] = Fraction(-1)                       # f1: A0^2 A8 = -A6^2 A15
        pt[11] = Fraction(-2)                      # f2: A0^2 A11 = -2 A3 A6 A15
        pt[9] = Fraction(2)                        # f3: A6^2 A9 = -2 A0 A2 A8
        for k in range(16):
            if pt[k] == 0:
                pt[k] = Fraction(1)
        pt = tuple(pt)
        print(f"    exhibited point: {[str(x) for x in pt]}")
        check("the point lies on the coefficient torus", all(c != 0 for c in pt))
        check("{f1,f2,f3} vanishes there, so (f1,f2,f3) : m^inf != (1)",
              all(p_eval(f, pt) == 0 for f in sub))
        hv = p_eval(got["h"], pt)
        check("the fourth row h does NOT vanish there: h is the load-bearing "
              "row of the circuit", hv != 0, f"h = {hv}")

    print("\nPART 3 -- scope, stated honestly")
    print("  Every support run here with the authoritative twist e_2 saturates")
    print("  to (1).  No support with I_S : m_S^inf != (1) is known for that")
    print("  twist, and producing one would BE a K-point of the F55 trace")
    print("  cubic -- it would settle Problem E positively, not negatively.")
    print("  The gate is an exact per-support decision procedure.  It is NOT a")
    print("  classification of supports: the universally quantified statement")
    print("  'I_S : m_S^inf = (1) for every primitive finite support S' is")
    print("  equivalent to the F55 headline itself (COVERAGE_RELATION.md).")

    print()
    if FAIL:
        print("FAILURES: " + ", ".join(FAIL))
        raise SystemExit(1)
    print("F55_SATURATION_SUPPORTS_OK")


if __name__ == "__main__":
    main()
