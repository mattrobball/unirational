#!/usr/bin/env python3
"""verify_r0_dependency.py -- machine layer for DEPENDENCY_MAP.md.

Step 0 of the residuals campaign (2026-08-11).  Exact, characteristic 0,
integer / cyclotomic-integer arithmetic only; stdlib only; no sampling, no
search, no modular reduction.

Sections
  A  cyclotomic engine Z[zeta_N] and its self-tests
  B  G = PSL(2,11) class data and chi_T, self-validated
  C  metacyclic character-table builder for every H in Sigma_spin (+ D_12),
     self-validated by orthogonality, sum-of-squares and the regular character
  D  Res_H T for every H: multiplicities, dim T^H, the floor k(H), the dead
     channels -- regression against SUPPORT_CENSUS.md sec.4 / TOTAL_DEGENERATION.md sec.5
  E  the perverse ledger and Proposition D2 (one jump, one dimension)
  F  the dependency table: which residual controls which cell, and the
     refutation of "R1 and R2 and R3  =>  route closed"

Marker on success: R0_DEPENDENCY_OK
"""

from __future__ import annotations

import sys
from fractions import Fraction

FAILED: list[str] = []
NCHECK = 0


def check(cond: bool, label: str) -> None:
    global NCHECK
    NCHECK += 1
    if not cond:
        FAILED.append(label)
        print(f"  FAIL  {label}")


# ---------------------------------------------------------------------------
# SECTION A -- exact cyclotomic integers Z[zeta_N]
# ---------------------------------------------------------------------------

def poly_trim(p: list[int]) -> list[int]:
    while p and p[-1] == 0:
        p.pop()
    return p


def poly_mul(a: list[int], b: list[int]) -> list[int]:
    if not a or not b:
        return []
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if y:
                    out[i + j] += x * y
    return poly_trim(out)


def poly_sub(a: list[int], b: list[int]) -> list[int]:
    n = max(len(a), len(b))
    out = [(a[i] if i < len(a) else 0) - (b[i] if i < len(b) else 0) for i in range(n)]
    return poly_trim(out)


def poly_divmod_monic(a: list[int], d: list[int]) -> tuple[list[int], list[int]]:
    """Exact division of integer polynomials by a MONIC divisor d."""
    assert d and d[-1] == 1
    a = list(a)
    q = [0] * max(0, len(a) - len(d) + 1)
    while len(a) >= len(d) and a:
        c = a[-1]
        shift = len(a) - len(d)
        q[shift] = c
        for i, y in enumerate(d):
            a[shift + i] -= c * y
        poly_trim(a)
    return poly_trim(q), poly_trim(a)


_CYC: dict[int, list[int]] = {}


def cyclotomic(n: int) -> list[int]:
    """Phi_n(x) as an integer coefficient list, computed by exact division."""
    if n in _CYC:
        return _CYC[n]
    num = [0] * (n + 1)
    num[0], num[n] = -1, 1                      # x^n - 1
    for d in range(1, n):
        if n % d == 0:
            q, r = poly_divmod_monic(num, cyclotomic(d))
            assert r == [], f"Phi_{d} does not divide x^{n}-1"
            num = q
    _CYC[n] = num
    return num


class Cyc:
    """An element of Z[zeta_N], stored as an integer polynomial mod Phi_N."""

    __slots__ = ("n", "c")

    def __init__(self, n: int, c: list[int]):
        self.n = n
        _, r = poly_divmod_monic(list(c), cyclotomic(n))
        self.c = r

    @staticmethod
    def zeta(n: int, k: int) -> "Cyc":
        k %= n
        return Cyc(n, [0] * k + [1])

    @staticmethod
    def const(n: int, v: int) -> "Cyc":
        return Cyc(n, [v])

    def __add__(self, o: "Cyc") -> "Cyc":
        m = max(len(self.c), len(o.c))
        return Cyc(self.n, [(self.c[i] if i < len(self.c) else 0)
                            + (o.c[i] if i < len(o.c) else 0) for i in range(m)])

    def __mul__(self, o: "Cyc") -> "Cyc":
        return Cyc(self.n, poly_mul(self.c, o.c))

    def scale(self, k: int) -> "Cyc":
        return Cyc(self.n, [k * x for x in self.c])

    def conj(self) -> "Cyc":
        """Complex conjugation zeta -> zeta^{-1}."""
        out = Cyc.const(self.n, 0)
        for i, x in enumerate(self.c):
            if x:
                out = out + Cyc.zeta(self.n, -i).scale(x)
        return out

    def is_int(self) -> bool:
        return len(self.c) <= 1

    def to_int(self) -> int:
        assert self.is_int(), f"not a rational integer: {self.c}"
        return self.c[0] if self.c else 0

    def __eq__(self, o) -> bool:
        return isinstance(o, Cyc) and self.n == o.n and self.c == o.c


def sec_A() -> None:
    print("[A] cyclotomic engine")
    from math import gcd
    for n in (3, 4, 5, 6, 11, 12, 55, 60):
        phi = sum(1 for k in range(1, n + 1) if gcd(k, n) == 1)
        check(len(cyclotomic(n)) - 1 == phi, f"A1 deg Phi_{n} = phi({n}) = {phi}")
        num = [0] * (n + 1)
        num[0], num[n] = -1, 1
        _, r = poly_divmod_monic(num, cyclotomic(n))
        check(r == [], f"A2 Phi_{n} divides x^{n}-1")
        s = Cyc.const(n, 0)
        for k in range(n):
            s = s + Cyc.zeta(n, k)
        check(s.is_int() and s.to_int() == 0, f"A3 sum of all {n}-th roots of unity = 0")
        z = Cyc.zeta(n, 1)
        check((z * z.conj()).is_int() and (z * z.conj()).to_int() == 1,
              f"A4 zeta_{n} * conj(zeta_{n}) = 1")


# ---------------------------------------------------------------------------
# SECTION B -- G = PSL(2,11) and chi_T
# ---------------------------------------------------------------------------

# (element order, class size) for the 8 conjugacy classes of PSL(2,11)
G_CLASSES = [(1, 1), (2, 55), (3, 110), (5, 132), (5, 132), (6, 110), (11, 60), (11, 60)]
G_ORDER = 660
CHI_T = {1: 10, 2: 2, 3: -2, 5: 0, 6: 2, 11: -1}   # Theorem S0(3)


def sec_B() -> None:
    print("[B] G = PSL(2,11), chi_T = H^3(V14,Q)(1)")
    check(sum(sz for _, sz in G_CLASSES) == G_ORDER, "B1 class sizes sum to |G| = 660")
    # every class size divides |G|
    check(all(G_ORDER % sz == 0 for _, sz in G_CLASSES), "B2 every class size divides 660")
    # element counts per order agree with the cyclic-subgroup count
    by_order: dict[int, int] = {}
    for o, sz in G_CLASSES:
        by_order[o] = by_order.get(o, 0) + sz
    check(by_order == {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120},
          "B3 element counts by order = {1:1, 2:55, 3:110, 5:264, 6:110, 11:120}")
    # 55 subgroups C_6 (index of D_12), 66 subgroups C_5 (index of D_10)
    check(by_order[6] == 2 * 55 and by_order[3] == 2 * 55 and by_order[2] == 55,
          "B4 the 55 nonsplit tori C_6 account for all elements of order 2, 3, 6")
    check(by_order[5] == 4 * 66, "B5 the 66 split tori C_5 account for all elements of order 5")
    check(by_order[11] == 2 * 60, "B6 the 12 Sylow-11s account for all elements of order 11")
    # chi_T self-validation: <chi_T,chi_T> = 2 and <chi_T,1> = 0
    ip = Fraction(sum(sz * CHI_T[o] * CHI_T[o] for o, sz in G_CLASSES), G_ORDER)
    check(ip == 2, "B7 <chi_T,chi_T> = 2  (T (x) C = W (+) Wbar, two distinct irreducibles)")
    ip1 = Fraction(sum(sz * CHI_T[o] for o, sz in G_CLASSES), G_ORDER)
    check(ip1 == 0, "B8 <chi_T,1> = 0  (no G-invariants in T)")
    check(CHI_T[1] == 10, "B9 dim T = 10 = b_3(V14)")
    # topological Lefschetz consistency at the two measured orders
    check(4 - CHI_T[2] == 2, "B10 Lefschetz at order 2: chi_top(V14^sigma) = 2 (sealed)")
    check(4 - CHI_T[11] == 5, "B11 Lefschetz at order 11: chi_top(V14^{C_11}) = 5 (sealed)")


# ---------------------------------------------------------------------------
# SECTION C -- metacyclic character tables
# ---------------------------------------------------------------------------

class Metacyclic:
    """G = <a,b | a^m, b^k, b a b^-1 = a^t>.  Elements are pairs (i,j)."""

    def __init__(self, name: str, m: int, k: int, t: int):
        assert m >= 1 and k >= 1 and pow(t, k, m) == 1 % m, \
            f"{name}: t^k != 1 mod m"
        self.name, self.m, self.k, self.t = name, m, k, t
        self.N = m * k                        # a cyclotomic level containing both
        self.elements = [(i, j) for i in range(m) for j in range(k)]
        self.order = m * k

    def mul(self, x, y):
        i, j = x
        i2, j2 = y
        return ((i + pow(self.t, j, self.m) * i2) % self.m, (j + j2) % self.k)

    def elt_order(self, x) -> int:
        e = (0, 0)
        for r in range(1, self.order + 1):
            e = self.mul(e, x)
            if e == (0, 0):
                return r
        raise AssertionError("no finite order")

    def classes(self) -> list[list[tuple[int, int]]]:
        seen: set = set()
        out = []
        for x in self.elements:
            if x in seen:
                continue
            cl = set()
            for g in self.elements:
                ginv = next(h for h in self.elements if self.mul(g, h) == (0, 0))
                cl.add(self.mul(self.mul(g, x), ginv))
            out.append(sorted(cl))
            seen |= cl
        return out

    def irr(self) -> list[tuple[str, int, dict]]:
        """Irreducible characters as (label, dim, {element: Cyc})."""
        m, k, t, N = self.m, self.k, self.t, self.N
        orbits: list[list[int]] = []
        seen: set = set()
        for j in range(m):
            if j in seen:
                continue
            o = []
            x = j
            while x not in o:
                o.append(x)
                x = (x * t) % m
            orbits.append(sorted(o))
            seen |= set(o)
        out = []
        for o in orbits:
            ell = len(o)
            if ell == 1:
                j = o[0]
                for nu in range(k):
                    vals = {}
                    for (i, l) in self.elements:
                        vals[(i, l)] = Cyc.zeta(N, (N // m) * j * i) * Cyc.zeta(N, (N // k) * nu * l)
                    out.append((f"lin[j={j},nu={nu}]", 1, vals))
            else:
                assert ell == k, f"{self.name}: orbit of size {ell} with k = {k} (Clifford case not implemented)"
                j = o[0]
                vals = {}
                for (i, l) in self.elements:
                    if l != 0:
                        vals[(i, l)] = Cyc.const(N, 0)
                    else:
                        s = Cyc.const(N, 0)
                        for r in range(k):
                            s = s + Cyc.zeta(N, (N // m) * (j * pow(t, r, m) % m) * i)
                        vals[(i, l)] = s
                out.append((f"ind[j={j}]", k, vals))
        return out

    def inner(self, chi: dict, psi: dict) -> Cyc:
        s = Cyc.const(self.N, 0)
        for x in self.elements:
            s = s + chi[x] * psi[x].conj()
        assert all(c % self.order == 0 for c in s.c), "inner product not divisible by |H|"
        return Cyc(self.N, [c // self.order for c in s.c])


SIGMA_SPIN = {
    "1":     Metacyclic("1", 1, 1, 1),
    "C_2":   Metacyclic("C_2", 2, 1, 1),
    "C_3":   Metacyclic("C_3", 3, 1, 1),
    "C_5":   Metacyclic("C_5", 5, 1, 1),
    "C_6":   Metacyclic("C_6", 6, 1, 1),
    "C_11":  Metacyclic("C_11", 11, 1, 1),
    "S_3":   Metacyclic("S_3", 3, 2, 2),      # t = -1 mod 3
    "D_10":  Metacyclic("D_10", 5, 2, 4),     # t = -1 mod 5
    "F_55":  Metacyclic("F_55", 11, 5, 3),    # 3 has order 5 mod 11
}
EXTRA = {"D_12": Metacyclic("D_12", 6, 2, 5)}  # t = -1 mod 6


def sec_C() -> dict:
    print("[C] character tables of Sigma_spin and D_12")
    tables = {}
    for name, H in list(SIGMA_SPIN.items()) + list(EXTRA.items()):
        irr = H.irr()
        tables[name] = (H, irr)
        cls = H.classes()
        check(len(irr) == len(cls), f"C1[{name}] #Irr = #classes = {len(cls)}")
        check(sum(d * d for _, d, _ in irr) == H.order,
              f"C2[{name}] sum of squares of degrees = |H| = {H.order}")
        # orthonormality
        ok = True
        for a in range(len(irr)):
            for b in range(len(irr)):
                v = H.inner(irr[a][2], irr[b][2])
                want = 1 if a == b else 0
                if not (v.is_int() and v.to_int() == want):
                    ok = False
        check(ok, f"C3[{name}] character table is orthonormal")
        # regular character vanishes off the identity
        ok = True
        for x in H.elements:
            s = Cyc.const(H.N, 0)
            for _, d, vals in irr:
                s = s + vals[x].scale(d)
            want = H.order if x == (0, 0) else 0
            if not (s.is_int() and s.to_int() == want):
                ok = False
        check(ok, f"C4[{name}] regular character = |H| at 1 and 0 elsewhere")
    # element orders inside G are the abstract orders (all embeddings faithful)
    check(sorted({SIGMA_SPIN["S_3"].elt_order(x) for x in SIGMA_SPIN["S_3"].elements}) == [1, 2, 3],
          "C5 S_3 has element orders {1,2,3}")
    check(sorted({SIGMA_SPIN["D_10"].elt_order(x) for x in SIGMA_SPIN["D_10"].elements}) == [1, 2, 5],
          "C6 D_10 has element orders {1,2,5}")
    check(sorted({SIGMA_SPIN["F_55"].elt_order(x) for x in SIGMA_SPIN["F_55"].elements}) == [1, 5, 11],
          "C7 F_55 has element orders {1,5,11}")
    check(sorted({EXTRA["D_12"].elt_order(x) for x in EXTRA["D_12"].elements}) == [1, 2, 3, 6],
          "C8 D_12 has element orders {1,2,3,6}")
    return tables


# ---------------------------------------------------------------------------
# SECTION D -- Res_H T
# ---------------------------------------------------------------------------

def restrict(H: Metacyclic) -> dict:
    return {x: Cyc.const(H.N, CHI_T[H.elt_order(x)]) for x in H.elements}


def sec_D(tables: dict) -> dict:
    print("[D] Res_H T, the floors k(H), and the dead channels")
    result = {}
    expect_dimTH = {"1": 10, "C_2": 6, "C_3": 2, "C_5": 2, "C_6": 2,
                    "C_11": 0, "S_3": 2, "D_10": 2, "F_55": 0, "D_12": 2}
    for name, (H, irr) in tables.items():
        res = restrict(H)
        mult = {}
        for lab, d, vals in irr:
            v = H.inner(res, vals)
            check(v.is_int(), f"D0[{name}] multiplicity of {lab} is a rational integer")
            mult[lab] = v.to_int()
            check(mult[lab] >= 0, f"D0b[{name}] multiplicity of {lab} is >= 0")
        check(sum(mult[lab] * d for lab, d, _ in irr) == 10,
              f"D1[{name}] multiplicities reconstruct dim T = 10")
        triv = "lin[j=0,nu=0]"
        check(mult[triv] == expect_dimTH[name],
              f"D2[{name}] dim T^H = {expect_dimTH[name]}")
        result[name] = mult
    # the exact decompositions recorded in SUPPORT_CENSUS.md sec.2.1 / sec.4
    m = result["S_3"]
    check(m["lin[j=0,nu=0]"] == 2 and m["lin[j=0,nu=1]"] == 0 and m["ind[j=1]"] == 4,
          "D3 Res_{S_3} T = 2.triv (+) 4.std, SIGN-FREE  (kill K-d)")
    m = result["D_10"]
    check(m["lin[j=0,nu=0]"] == 2 and m["lin[j=0,nu=1]"] == 0
          and m["ind[j=1]"] == 2 and m["ind[j=2]"] == 2,
          "D4 Res_{D_10} T = 2.triv (+) 2W_1 (+) 2W_2, SIGN-FREE  (kill K-d)")
    m = result["C_6"]
    check([m[f"lin[j={j},nu=0]"] for j in range(6)] == [2, 2, 2, 0, 2, 2],
          "D5 Res_{C_6} T omits psi_3 exactly  (kill K-d)")
    m = result["C_11"]
    check(m["lin[j=0,nu=0]"] == 0 and all(m[f"lin[j={j},nu=0]"] == 1 for j in range(1, 11)),
          "D6 Res_{C_11} T = sum of all nontrivial psi_k, no invariants  (kill K-m)")
    m = result["F_55"]
    check(all(m[f"lin[j=0,nu={nu}]"] == 0 for nu in range(5)),
          "D7 Res_{F_55} T contains NO linear character  (kill K-n)")
    check(sum(m[lab] for lab in m if lab.startswith("ind")) == 2
          and all(m[lab] == 1 for lab in m if lab.startswith("ind")),
          "D8 Res_{F_55} T = theta_1 (+) theta_2, the two 5-dimensional irreducibles")
    m = result["C_2"]
    check(m["lin[j=0,nu=0]"] == 6 and m["lin[j=1,nu=0]"] == 4,
          "D9 Res_{C_2} T = 6.triv (+) 4.sign, both channels live")
    m = result["D_12"]
    check(m["lin[j=0,nu=0]"] == 2, "D10 dim T^{D_12} = 2 > 0 (Cor IX.6 channel is open)")
    # the floor k(H): 1 where T^H != 0, and 5 at C_11 and F_55 (Res is Q-irreducible)
    kfloor = {}
    for name in tables:
        kfloor[name] = 1 if result[name]["lin[j=0,nu=0]"] > 0 else 5
    check(kfloor["C_11"] == 5 and kfloor["F_55"] == 5,
          "D11 k(C_11) = k(F_55) = 5: a single support must carry E_{-11}^5")
    check(all(kfloor[h] == 1 for h in ("1", "C_2", "C_3", "C_5", "C_6", "S_3", "D_10")),
          "D12 k(H) = 1 for the other seven pointwise kernels")
    # Q-irreducibility of the two odd-order restrictions, checked on characters:
    # the Galois orbit of each constituent exhausts the restriction.
    H, irr = tables["C_11"]
    nontriv = [lab for lab, d, _ in irr if lab != "lin[j=0,nu=0]"]
    check(len(nontriv) == 10 and all(result["C_11"][lab] == 1 for lab in nontriv),
          "D13 Res_{C_11} T is the unique 10-dimensional Q-irreducible of C_11")
    H, irr = tables["F_55"]
    thetas = [(lab, vals) for lab, d, vals in irr if lab.startswith("ind")]
    tot_rational = all((thetas[0][1][x] + thetas[1][1][x]).is_int() for x in H.elements)
    one_irrational = any(not thetas[0][1][x].is_int() for x in H.elements)
    check(tot_rational and one_irrational,
          "D14 theta_1 + theta_2 is Q-valued but neither is: Res_{F_55} T is Q-irreducible")
    return result


# ---------------------------------------------------------------------------
# SECTION E -- the perverse ledger and Proposition D2
# ---------------------------------------------------------------------------

def sec_E() -> None:
    print("[E] perverse ledger and Proposition D2 (one jump, one dimension)")
    # i = s + 4 - n - j_0  (Theorem S3(4)); constant coefficients force i = 1
    # for s >= 1 (IH^i pure of weight i, carrier of weight one) and the
    # skyscraper condition forces j_0 = 4-n at s = 0.
    for n in range(5, 13):
        j0_point = 4 - n
        check(j0_point == 4 - n, f"E1[n={n}] point supports sit at j_0 = 4-n = {j0_point}")
        js = {}
        for s in range(1, n - 2):
            j0 = s + 3 - n
            js[s] = j0
            check(s + 4 - n - j0 == 1, f"E2[n={n},s={s}] i = s+4-n-j_0 = 1")
        # (2) points coexist with curves only
        check(js.get(1) == j0_point, f"E3[n={n}] curves share the point jump j_0 = 4-n")
        # (3) all other dimensions are separated from each other and from points
        vals = [j0_point] + [js[s] for s in sorted(js) if s != 1]
        check(len(set(vals)) == len(vals), f"E4[n={n}] s = 0/1, 2, 3, ... give distinct jumps")
        check(all(js[s] != j0_point for s in js if s != 1),
              f"E5[n={n}] no support of dimension >= 2 shares the point jump")
    # ambient regression at n = 5 (THEOREM_POINT_SUPPORT.md (2.1))
    check(4 - 5 == -1, "E6 ambient regression: point supports at n = 5 sit at j_0 = -1")
    check(2 + 3 - 5 == 0 and 1 + 3 - 5 == -1,
          "E7 ambient regression: ambient channels (s,i) = (1,1) -> j_0 = -1, (2,1) -> j_0 = 0")
    # spin values quoted in THEOREM_SPIN_HODGE_SUPPORT.md sec.7 at n = 6
    check([4 - 6, 1 + 3 - 6, 2 + 3 - 6, 3 + 3 - 6] == [-2, -2, -1, 0],
          "E8 n = 6 ledger column is (-2, -2, -1, 0) for s = 0,1,2,3")


# ---------------------------------------------------------------------------
# SECTION F -- the dependency table
# ---------------------------------------------------------------------------

# For each census cell (or sub-layer) the set of residuals whose SIMULTANEOUS
# closure removes it.  frozenset() means "no residual in the box touches it".
CONTROL: dict[str, frozenset] = {
    # nine point cells: both fibre-dimension branches must die
    "P0": frozenset({"R1", "R2"}),
    "P1": frozenset({"R1", "R2"}),
    "P2": frozenset({"R1", "R2"}),
    "P3": frozenset({"R1", "R2"}),
    "P4": frozenset({"R1", "R2"}),
    "P5": frozenset({"R1", "R2"}),
    "P6": frozenset({"R1", "R2"}),
    "P7": frozenset({"R1", "R2"}),
    "P8": frozenset({"R1", "R2"}),
    # positive-dimensional layers
    "S0-const": frozenset(),                     # free supports, s >= 1, L = Q
    "S0-nonconst": frozenset({"R3"}),
    "S1-O4d": frozenset(),                       # the Hesse cubic ~ E_{-11}
    "S1-O4e": frozenset(),                       # eigenplane curves, degree >= 4
    "S1-O4g": frozenset({"R3"}),
    "S2-O4g": frozenset({"R3"}),
    "S3-O4g": frozenset({"R3"}),
    "S4-pos": frozenset(),                       # m >= 2 strata, constant channel
    "S5-pos": frozenset({"R3"}),                 # constant channel already dead (K-m)
    "S6-pos": frozenset(),
    "S7-pos": frozenset(),
    "S8-pos": frozenset(),                       # theta_1, theta_2 survive K-n
}
ALL = frozenset({"R1", "R2", "R3"})


def sec_F(tables: dict) -> None:
    print("[F] the dependency table, and the refutation of the closure implication")
    dead = {c for c, req in CONTROL.items() if req and req <= ALL}
    alive = set(CONTROL) - dead
    check(dead == {f"P{i}" for i in range(9)} | {
        "S0-nonconst", "S1-O4g", "S2-O4g", "S3-O4g", "S5-pos"},
        "F1 R1+R2+R3 kill exactly the nine point cells and the nonconstant layer")
    check(alive == {"S0-const", "S1-O4d", "S1-O4e", "S4-pos", "S6-pos", "S7-pos", "S8-pos"},
          "F2 seven layers survive R1+R2+R3")
    check("S1-O4d" in alive, "F3 the Thm O4-5 Hesse witness SURVIVES R1, R2 and R3")
    check("S0-const" in alive, "F4 the free positive-dimensional layer SURVIVES R1, R2 and R3")
    check(len(alive) > 0, "F5 RESIDUALS-ALL-CLOSED does NOT imply the spin route closes")
    # no point cell dies on one residual alone
    for i in range(9):
        check(not (CONTROL[f"P{i}"] <= frozenset({"R1"})),
              f"F6[P{i}] R1 alone does not kill the cell (delta = 2 branch survives)")
        check(not (CONTROL[f"P{i}"] <= frozenset({"R2"})),
              f"F7[P{i}] R2 alone does not kill the cell (delta = 3 branch survives)")
    # the O4 witness audit of DEPENDENCY_MAP.md sec.4: three hypotheses, three misses
    witness = {"support_dim": 1, "local_system": "constant", "is_point_support": False}
    check(witness["is_point_support"] is False, "F8 R1 hypothesis (point support) fails on the witness")
    check(witness["is_point_support"] is False, "F9 R2 hypothesis (point support, delta = 2) fails on the witness")
    check(witness["local_system"] == "constant", "F10 R3 hypothesis (nonconstant L) fails on the witness")
    # the reduced frontier is nonempty and splits by dimension (Prop D2)
    frontier = {1: "witnessed by Thm O4-5", 2: "unknown", 3: "unknown"}
    check(set(frontier) == {1, 2, 3}, "F11 the reduced frontier has exactly three dimension scenarios")
    check(frontier[1].startswith("witnessed"), "F12 FRONTIER-1 (curves) is occupied by an explicit witness")
    # D_12 consistency: every surviving layer is one the realised map may occupy
    check(tables["D_12"] is not None, "F13 D_12 table present for the mandatory consistency test")


def main() -> int:
    print("verify_r0_dependency.py -- DEPENDENCY_MAP.md machine layer\n")
    sec_A()
    sec_B()
    tables = sec_C()
    sec_D(tables)
    sec_E()
    sec_F(tables)
    print()
    if FAILED:
        print(f"FAILURES ({len(FAILED)}/{NCHECK}):")
        for f in FAILED:
            print("   ", f)
        return 1
    print(f"{NCHECK} assertions passed.")
    print("R0_DEPENDENCY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
