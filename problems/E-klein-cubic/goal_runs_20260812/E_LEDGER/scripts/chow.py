#!/usr/bin/env python3
"""
E_LEDGER -- the intersection-theory layer, DERIVED and CALIBRATED.

Nothing in this packet may use a blowup intersection number that is not
produced by `blowup_numbers` below, and `blowup_numbers` is built from the
standard presentation of the Chow ring of a projectivised bundle -- never
from a memorised table.  The calibration anchors of
DATA_SPEC_PIPELINE_FLUSH_20260812.md Lane 1 (`H^3 E = H^2 E^2 = H E^3 = 0`
and `E^4 = -1` on `Bl_pt P^4`) are re-derived, not asserted; if any of them
fails the packet stops.

SETUP (Fulton, Intersection Theory, 3.1 / 4.4; 6.7 for the blowup).
Let `Z subset P^4` be a smooth centre of dimension `delta`, codimension
`r = 4 - delta`, with normal bundle `N = N_{Z/P^4}`.  Let
`pi : Bl_Z P^4 -> P^4`, `E = P(N)` the exceptional divisor, `p : E -> Z`,
`xi = c_1(O_{P(N)}(1))` (Fulton's convention: `O(-1)` is the tautological
subbundle of `p^*N`).  Then

    O(E)|_E = O_{P(N)}(-1),   i.e.   E|_E = -xi                        (1)
    sum_{i=0}^{r} p^*c_i(N) . xi^{r-i} = 0    (Grothendieck relation)  (2)
    p_*(xi^{r-1+k}) = s_k(N)                                          (3)

and therefore, for `a + b = 4` with `b >= 1`,

    deg( H^a . E^b )  =  deg_E( (-xi)^{b-1} . p^*(h^a) ),   h = c_1(O_Z(1)).

CENSUS CENTRES ARE LINEAR.  Every one of the 14 census orbits is an orbit of
LINEAR subspaces of P^4 = P(W) (940 points, 220 lines, 55 planes -- they are
eigenspaces of subgroups of G acting on W; see census.py).  For a linear
`Z = P^delta subset P^4`, `N_{Z/P^4} = O_Z(1)^{oplus r}`, so
`c(N) = (1+h)^r` -- this is the "normal-bundle degree the census/frames
give", and it is the ONLY input to (2) besides `r`.

DISJOINTNESS.  The closed forms exported here are for a tower whose centres
are pairwise disjoint, so `E_j . E_k = 0` for `j != k`.  The actual census
arrangement is NOT disjoint (points sit on lines sit on planes); that is why
E2 groups by CONNECTED COMPONENTS of the base locus and keeps the local
total `s_j` as an unknown integer (see e2.py).  The disjoint closed forms are
used here for exactly two purposes, both legitimate:
  (i)  the calibration anchors and the C1 reproduction, which are identities
       in the Chow ring of a single blowup, and
  (ii) the NONDEGENERATE local value at an isolated point centre, `s = mu^4`,
       which is the hypothesis named in section 3.1's d = 35 corollary.

python3 standard library only; exact Fraction arithmetic.
"""

from fractions import Fraction
from itertools import product


# ======================================================================
#  A minimal exact multivariate polynomial ring over Q
# ======================================================================

class Poly:
    """Sparse multivariate polynomial: {exponent tuple -> Fraction}."""

    __slots__ = ("vars", "terms")

    def __init__(self, variables, terms=None):
        self.vars = tuple(variables)
        self.terms = {}
        if terms:
            for e, c in terms.items():
                c = Fraction(c)
                if c:
                    self.terms[tuple(e)] = c

    # --- constructors ---
    @staticmethod
    def const(variables, c):
        z = tuple(0 for _ in variables)
        return Poly(variables, {z: Fraction(c)})

    @staticmethod
    def var(variables, name):
        i = list(variables).index(name)
        e = [0] * len(variables)
        e[i] = 1
        return Poly(variables, {tuple(e): Fraction(1)})

    # --- arithmetic ---
    def __add__(self, other):
        other = self._coerce(other)
        out = dict(self.terms)
        for e, c in other.terms.items():
            v = out.get(e, Fraction(0)) + c
            if v:
                out[e] = v
            else:
                out.pop(e, None)
        return Poly(self.vars, out)

    def __neg__(self):
        return Poly(self.vars, {e: -c for e, c in self.terms.items()})

    def __sub__(self, other):
        return self + (-self._coerce(other))

    def __mul__(self, other):
        other = self._coerce(other)
        out = {}
        for e1, c1 in self.terms.items():
            for e2, c2 in other.terms.items():
                e = tuple(a + b for a, b in zip(e1, e2))
                v = out.get(e, Fraction(0)) + c1 * c2
                if v:
                    out[e] = v
                else:
                    out.pop(e, None)
        return Poly(self.vars, out)

    __radd__ = __add__
    __rmul__ = __mul__

    def __rsub__(self, other):
        return self._coerce(other) - self

    def __pow__(self, n):
        r = Poly.const(self.vars, 1)
        for _ in range(n):
            r = r * self
        return r

    def __eq__(self, other):
        return self.terms == self._coerce(other).terms

    def is_zero(self):
        return not self.terms

    def _coerce(self, other):
        if isinstance(other, Poly):
            assert other.vars == self.vars, "variable mismatch"
            return other
        return Poly.const(self.vars, other)

    def subs(self, assignment):
        """assignment: {varname: Fraction/int}. Returns Fraction if total."""
        tot = Fraction(0)
        for e, c in self.terms.items():
            t = c
            for i, k in enumerate(e):
                if k:
                    t *= Fraction(assignment[self.vars[i]]) ** k
            tot += t
        return tot

    def __repr__(self):
        if not self.terms:
            return "0"
        out = []
        for e in sorted(self.terms, reverse=True):
            c = self.terms[e]
            mono = "*".join("%s^%d" % (self.vars[i], k) if k > 1 else self.vars[i]
                            for i, k in enumerate(e) if k)
            out.append(("%s" % c) + ("*" + mono if mono else ""))
        return " + ".join(out).replace("+ -", "- ")


# ======================================================================
#  The Chow ring of E = P(N) for a LINEAR centre, and the blowup numbers
# ======================================================================

def _binom(n, k):
    if k < 0 or k > n:
        return 0
    num = den = 1
    for i in range(k):
        num *= n - i
        den *= i + 1
    return num // den


def _reduce_PN(mono, delta, r):
    """
    Reduce a monomial xi^a h^b in A^*(P(N)), N = O(1)^r over Z = P^delta,
    modulo   h^(delta+1) = 0   and   sum_{i=0}^r C(r,i) h^i xi^(r-i) = 0.
    Returns dict {(a,b): Fraction}.
    """
    work = {mono: Fraction(1)}
    changed = True
    while changed:
        changed = False
        out = {}
        for (a, b), c in work.items():
            if b > delta:
                changed = True
                continue                      # h^{delta+1} = 0
            if a >= r:
                changed = True
                # xi^r = - sum_{i=1}^{r} C(r,i) h^i xi^{r-i}
                for i in range(1, r + 1):
                    key = (a - i, b + i)
                    out[key] = out.get(key, Fraction(0)) - c * _binom(r, i)
            else:
                out[(a, b)] = out.get((a, b), Fraction(0)) + c
        work = {k: v for k, v in out.items() if v}
    return work


def _integral_PN(cls, delta, r):
    """
    Integral over E = P(N), dim E = delta + r - 1.  Normalisation (3):
    p_*(xi^{r-1}) = s_0(N) = 1, so int_E xi^{r-1} h^delta = 1 and every other
    reduced monomial of the top degree is zero (there is only one).
    """
    tot = Fraction(0)
    for (a, b), c in cls.items():
        if a + b != delta + r - 1:
            if c:
                raise ValueError("not of top degree: xi^%d h^%d" % (a, b))
        if (a, b) == (r - 1, delta):
            tot += c
        elif c and a + b == delta + r - 1:
            raise ValueError("unreduced top monomial xi^%d h^%d" % (a, b))
    return tot


def blowup_numbers(delta):
    """
    deg(H^(4-b) . E^b) on Bl_Z P^4 for a LINEAR centre Z = P^delta,
    b = 0..4, DERIVED from (1)-(3).  b = 0 is deg H^4 = 1.
    """
    r = 4 - delta
    assert 1 <= r <= 4
    out = {0: Fraction(1)}
    for b in range(1, 5):
        a = 4 - b
        if a > delta:
            out[b] = Fraction(0)              # h^a = 0 on Z = P^delta
            continue
        # (-xi)^(b-1) . h^a
        sign = Fraction((-1) ** (b - 1))
        red = _reduce_PN((b - 1, a), delta, r)
        out[b] = sign * _integral_PN(red, delta, r)
    return out


# ======================================================================
#  The blowup discrepancy  a_E  (needed for C1's genus package)
# ======================================================================

def discrepancy(delta):
    """K_{Bl} = pi^*K + (codim - 1) E, so a_E = 3 - delta."""
    return 3 - delta


# ======================================================================
#  The tower with pairwise-disjoint linear centres
# ======================================================================

class DisjointTower:
    """
    Bl of P^4 at K pairwise disjoint linear centres of dims delta_k.
    Variables: d, m_0, ..., m_{K-1}.
    """

    def __init__(self, deltas):
        self.deltas = list(deltas)
        self.K = len(deltas)
        self.vars = ("d",) + tuple("m%d" % k for k in range(self.K))
        self.d = Poly.var(self.vars, "d")
        self.m = [Poly.var(self.vars, "m%d" % k) for k in range(self.K)]
        self.nums = [blowup_numbers(dl) for dl in deltas]

    def zero(self):
        return Poly.const(self.vars, 0)

    def deg_monomial(self, aH, bE):
        """
        deg( H^aH * prod_k E_k^{bE[k]} ).  Disjoint centres => at most one
        E may appear.  Total degree must be 4.
        """
        used = [k for k, b in enumerate(bE) if b]
        assert aH + sum(bE) == 4
        if len(used) == 0:
            return Fraction(1)                     # deg H^4
        if len(used) > 1:
            return Fraction(0)                     # disjoint centres
        k = used[0]
        return self.nums[k][bE[k]]

    def deg(self, factors):
        """
        factors : list of 4 divisor classes, each given as
                  (coeff_of_H : Poly, [coeff_of_E_k : Poly]).
        Returns the exact Poly degree of their product.
        """
        assert len(factors) == 4
        total = self.zero()
        # expand the product of 4 divisors over the (K+1) basis classes
        for choice in product(range(self.K + 1), repeat=4):
            aH = sum(1 for c in choice if c == 0)
            bE = [0] * self.K
            for c in choice:
                if c:
                    bE[c - 1] += 1
            num = self.deg_monomial(aH, bE)
            if num == 0:
                continue
            coeff = Poly.const(self.vars, num)
            for idx, c in enumerate(choice):
                coeff = coeff * (factors[idx][0] if c == 0 else factors[idx][1][c - 1])
            total = total + coeff
        return total

    # --- the two divisor classes the ledger uses ---
    def qstarH(self):
        """q^*H_X = d H - sum m_k E_k."""
        return (self.d, [-mk for mk in self.m])

    def canonical(self):
        """K_Z = -5 H + sum a_k E_k."""
        return (Poly.const(self.vars, -5),
                [Poly.const(self.vars, discrepancy(dl)) for dl in self.deltas])

    def relative_canonical(self):
        """K_{Z/X} = K_Z - q^*K_X = K_Z + 2 q^*H_X   (K_X = O_X(-2))."""
        kz = self.canonical()
        q = self.qstarH()
        return (kz[0] + 2 * q[0], [kz[1][k] + 2 * q[1][k] for k in range(self.K)])


# ======================================================================
#  Derived closed forms:  the LOCAL contribution of one isolated centre
# ======================================================================

def local_contribution_level4(delta):
    """
    The `s` of E2 for a single centre of dimension delta, in the
    NONDEGENERATE (isolated, transverse, multiplicity-m) local model:
    deg((dH - mE)^4) = d^4 + c(d,m), and s := -c(d,m) is the local total
    subtracted at that component.  Returned as a Poly in ("d","m").
    """
    V = ("d", "m")
    d = Poly.var(V, "d")
    m = Poly.var(V, "m")
    nums = blowup_numbers(delta)
    c = Poly.const(V, 0)
    for b in range(1, 5):
        if nums[b] == 0:
            continue
        c = c + Poly.const(V, _binom(4, b) * nums[b]) * (d ** (4 - b)) * ((-m) ** b)
    return -c        # s, so that  d^4 = sum n_j s_j  reads  d^4 - sum c = 0


def local_contribution_level3(delta):
    """
    The level-3 analogue: deg(H . (dH - mE)^3) = d^3 + c3(d,m); t := -c3.
    Used for the `3 nu = d^3 - sum n_j t_j` row of section 3.1.
    """
    V = ("d", "m")
    d = Poly.var(V, "d")
    m = Poly.var(V, "m")
    nums = blowup_numbers(delta)
    c = Poly.const(V, 0)
    for b in range(1, 4):
        if nums[b] == 0:
            continue
        c = c + Poly.const(V, _binom(3, b) * nums[b]) * (d ** (3 - b)) * ((-m) ** b)
    return -c


# ======================================================================
#  ANCHORS (fatal) and the C1 reproduction (fatal)
# ======================================================================

def run_anchors():
    """Every calibration anchor of the data spec, plus the derived table."""
    res = {}

    # --- A1: Bl_pt P^4 ---------------------------------------------------
    pt = blowup_numbers(0)
    res["A1_point_center"] = {
        "H^4": str(pt[0]), "H^3E": str(pt[1]), "H^2E^2": str(pt[2]),
        "HE^3": str(pt[3]), "E^4": str(pt[4]),
        "expected": {"H^4": "1", "H^3E": "0", "H^2E^2": "0", "HE^3": "0",
                     "E^4": "-1"},
        "pass": (pt[0] == 1 and pt[1] == 0 and pt[2] == 0 and pt[3] == 0
                 and pt[4] == -1),
    }

    # --- A2: line centre (curve centre; normal bundle O(1)^3, deg c_1 = 3)
    ln = blowup_numbers(1)
    res["A2_line_center"] = {
        "H^3E": str(ln[1]), "H^2E^2": str(ln[2]), "HE^3": str(ln[3]),
        "E^4": str(ln[4]),
        "expected": {"H^3E": "0", "H^2E^2": "0", "HE^3": "1", "E^4": "3"},
        "pass": (ln[1] == 0 and ln[2] == 0 and ln[3] == 1 and ln[4] == 3),
        "note": "N = O(1)^3 on P^1: c_1(N) = 3h; E = P^1 x P^2; "
                "xi^3 = -3h xi^2 gives E^4 = 3.",
    }

    # --- A3: plane centre ------------------------------------------------
    pl = blowup_numbers(2)
    res["A3_plane_center"] = {
        "H^3E": str(pl[1]), "H^2E^2": str(pl[2]), "HE^3": str(pl[3]),
        "E^4": str(pl[4]),
        "expected": {"H^3E": "0", "H^2E^2": "-1", "HE^3": "-2", "E^4": "-3"},
        "pass": (pl[1] == 0 and pl[2] == -1 and pl[3] == -2 and pl[4] == -3),
    }

    # --- A4: linear-projection consistency (independent of the above) ----
    # For a linear centre of dim delta, the class H - E is the pullback of
    # O(1) under the projection P^4 --> P^{delta} ... precisely: projection
    # away from Z has image P^{3-delta}, of dimension 3 - delta < 4, hence
    # (H - E)^4 = 0 for delta = 0, 1, 2.  This is a genuine independent
    # identity that the table must satisfy.
    proj = {}
    for delta in (0, 1, 2):
        nums = blowup_numbers(delta)
        val = sum(Fraction((-1) ** b * _binom(4, b)) * nums[b] for b in range(5))
        proj["delta=%d" % delta] = str(val)
    res["A4_projection_identity"] = {
        "(H-E)^4": proj,
        "pass": all(Fraction(v) == 0 for v in proj.values()),
        "note": "(H - E)^4 = 0 because projection away from a linear centre "
                "of dim delta has 3-dimensional-at-most image.",
    }

    # --- A5: Segre cross-check ------------------------------------------
    # Fulton: pi_*(E^b) = (-1)^(b-1) s_{b-r}(N) cap [Z], and for
    # N = O(1)^r on P^delta, s_k(N) = (-1)^k C(r+k-1,k) h^k, so
    # deg(H^{4-b} E^b) = (-1)^(delta+1) C(b-1, b-4+delta).  Independent route.
    ok = True
    seg = {}
    for delta in (0, 1, 2):
        r = 4 - delta
        nums = blowup_numbers(delta)
        for b in range(1, 5):
            if b < r:
                pred = Fraction(0)
            else:
                pred = Fraction((-1) ** (delta + 1) * _binom(b - 1, b - 4 + delta))
            seg["delta=%d,b=%d" % (delta, b)] = [str(nums[b]), str(pred)]
            ok = ok and nums[b] == pred
    res["A5_segre_closed_form"] = {"table": seg, "pass": ok}

    return res


def run_c1_reproduction():
    """
    THE C1 CROSS-CHECK, done at 'degree one lower' (level 3).

    On the disjoint tower, with D = q^*H_X = dH - sum m_k E_k and the fibre
    class defined by  3[C] = D^3  (E1: (q^*H_X)^3 = 3[C]):

        nu    := H . C      = deg(H . D^3)/3
        ebar_k := E_k . C   = deg(E_k . D^3)/3

    Then C1's three sealed relations must come out as POLYNOMIAL IDENTITIES
    of the implementation:

      (C1-a)  K_{Z/X} = (2d - 5) H + sum (a_k - 2 m_k) E_k
      (C1-b)  d . nu - sum_k m_k ebar_k  =  deg(D^4)/3        (=0 when D^4=0)
      (C1-c)  2g - 2 = (2d-5) nu + sum (a_k - 2 m_k) ebar_k,
              with 2g - 2 := deg(K_{Z/X} . D^3)/3

    Any failure is fatal for the packet.
    """
    out = {}
    deltas = [0, 1, 2, 0, 1, 2]          # two of each kind, disjoint
    T = DisjointTower(deltas)
    D = T.qstarH()
    H = (Poly.const(T.vars, 1), [T.zero() for _ in range(T.K)])
    Ecls = []
    for k in range(T.K):
        cf = [T.zero() for _ in range(T.K)]
        cf[k] = Poly.const(T.vars, 1)
        Ecls.append((T.zero(), cf))

    D4 = T.deg([D, D, D, D])
    three_nu = T.deg([H, D, D, D])
    three_e = [T.deg([Ecls[k], D, D, D]) for k in range(T.K)]

    # (C1-a) as a class identity
    KZX = T.relative_canonical()
    lhs_H = KZX[0]
    rhs_H = 2 * T.d - 5
    ok_a = (lhs_H == rhs_H)
    for k in range(T.K):
        ak = discrepancy(deltas[k])
        ok_a = ok_a and (KZX[1][k] == Poly.const(T.vars, ak) - 2 * T.m[k])
    out["C1a_relative_canonical"] = {
        "pass": bool(ok_a),
        "K_{Z/X}_H_coefficient": repr(KZX[0]),
        "a_k": [discrepancy(x) for x in deltas],
    }

    # (C1-b)  3 (d nu - sum m ebar) == deg(D^4)
    lhs = T.d * three_nu
    for k in range(T.K):
        lhs = lhs - T.m[k] * three_e[k]
    out["C1b_projection_pairing"] = {
        "pass": bool(lhs == D4),
        "identity": "3(d.nu - sum m_k ebar_k) == deg(D^4)",
        "deg_D4": repr(D4),
    }

    # (C1-c)  3(2g-2) == deg(K_{Z/X} . D^3) and the expanded form agrees
    three_2gm2 = T.deg([KZX, D, D, D])
    rhs = (2 * T.d - 5) * three_nu
    for k in range(T.K):
        ak = Poly.const(T.vars, discrepancy(deltas[k]))
        rhs = rhs + (ak - 2 * T.m[k]) * three_e[k]
    out["C1c_genus_package"] = {
        "pass": bool(three_2gm2 == rhs),
        "identity": "3(2g-2) == 3[(2d-5)nu + sum (a_k - 2 m_k) ebar_k]",
    }

    # (C1-d) the level-3 row of section 3.1: 3 nu = d^3 - sum t_k(d,m_k)
    V = ("d", "m")
    ok_d = True
    detail = {}
    for k, dl in enumerate(deltas):
        t = local_contribution_level3(dl)
        detail["delta=%d" % dl] = repr(t)
    # rebuild 3nu from the per-centre closed forms and compare
    rebuilt = T.d ** 3
    for k, dl in enumerate(deltas):
        t = local_contribution_level3(dl)
        # substitute m -> m_k
        sub = T.zero()
        for e, c in t.terms.items():
            term = Poly.const(T.vars, c) * (T.d ** e[0]) * (T.m[k] ** e[1])
            sub = sub + term
        rebuilt = rebuilt - sub
    ok_d = (rebuilt == three_nu)
    out["C1d_level3_row"] = {"pass": bool(ok_d),
                             "t(d,m) per centre dimension": detail}

    # (C1-e) the level-4 row: d^4 = sum s_k(d,m_k)  when deg(D^4) = 0
    rebuilt4 = T.d ** 4
    detail4 = {}
    for k, dl in enumerate(deltas):
        s = local_contribution_level4(dl)
        detail4["delta=%d" % dl] = repr(s)
        sub = T.zero()
        for e, c in s.terms.items():
            sub = sub + Poly.const(T.vars, c) * (T.d ** e[0]) * (T.m[k] ** e[1])
        rebuilt4 = rebuilt4 - sub
    out["C1e_level4_row"] = {"pass": bool(rebuilt4 == D4),
                             "s(d,m) per centre dimension": detail4}

    return out


if __name__ == "__main__":
    import json
    print(json.dumps({"anchors": run_anchors(),
                      "c1": run_c1_reproduction()}, indent=1))
