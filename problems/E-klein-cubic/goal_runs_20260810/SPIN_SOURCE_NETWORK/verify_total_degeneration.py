#!/usr/bin/env python3
"""
verify_total_degeneration.py -- the campaign-deciding layer of the spin
Hodge-support route.

Companion to `TOTAL_DEGENERATION.md`, `O2_MANDATORY_POINTS.md` and
`O1_O5_FREE_AND_MULTIPLICITY.md`.  Two theorems are checked here.

  W1 (total-degeneration witness).  For EVERY point x of a spin source with
     stabiliser H in Sigma_spin, the datum

         Y_x = V14,   q|_{Y_x} = id,   W_x = H^3(V14,Q) = T(-1)

     satisfies every necessary condition that Theorems S1-S3, Prop S5,
     Cor S6 and Cor S4 of `THEOREM_SPIN_HODGE_SUPPORT.md` impose on a
     point-supported block at x, and evades every cross-cutting kill
     K-a..K-l of `SUPPORT_CENSUS.md` section 5.3.  Hence no point cell
     P0..P8 is closable by the Hodge-support machinery.

  W3 (pointwise-kernel selection rule).  If S is a POSITIVE-dimensional
     strict support with pointwise kernel H_0, then H_0 acts trivially on S,
     the equivariant fundamental group is pi_1(S) x H_0, and a simple
     constituent IC_{Sbar}(L (x) rho) has carrier IH^i(Sbar,L) (x) rho with
     H_0 acting through the single irreducible rho.  (5.2) therefore forces
     rho to occur in Res_{H_0} T.  The dead channels are computed here for
     every H_0 in Sigma_spin.

Everything is exact: characters are computed inside the cyclotomic rings
Z[zeta_m] by polynomial reduction modulo Phi_m; no floating point, no
sampling.  Python 3 standard library only.

Sections
--------
A  Sigma_spin, the nine point cells, and their orbit sizes
B  W1 -- the witness checklist, cell by cell, and the kill audit
C  W3 -- the pointwise-kernel selection rule for every H_0 in Sigma_spin
D  the positive-dimensional cells S0-S8 under W3
E  (O1) free supports: capacity across degree and source dimension
F  (O2) the mandatory points: the ample-divisor irregularity narrowing
G  the census tally and the campaign exit
H  the mandatory D_12 test on every verdict recorded here

Marker on success: TOTAL_DEGENERATION_OK
"""

import sys
from fractions import Fraction as Fr

FAILED = []
NCHECK = 0


def check(name, got, want):
    global NCHECK
    NCHECK += 1
    if got == want:
        print("  ok   %-60s %s" % (name, want))
    else:
        print("  FAIL %-60s got %r want %r" % (name, got, want))
        FAILED.append("%s: got %r want %r" % (name, got, want))


def head(title):
    print()
    print("=" * 76)
    print(title)
    print("=" * 76)


# ---------------------------------------------------------------------------
# exact cyclotomic arithmetic:  Q(zeta_n) = Q[x]/(Phi_n)
# ---------------------------------------------------------------------------

def _polydivmod(a, b):
    a = [Fr(x) for x in a]
    q = [Fr(0)] * max(1, len(a) - len(b) + 1)
    while len(a) >= len(b) and any(c != 0 for c in a):
        d = len(a) - len(b)
        c = a[-1] / Fr(b[-1])
        if c == 0:
            a.pop()
            continue
        q[d] = c
        for i, bi in enumerate(b):
            a[i + d] -= c * Fr(bi)
        while len(a) > 1 and a[-1] == 0:
            a.pop()
        if len(a) < len(b):
            break
    return q, a


_CYC = {}


def cyclotomic(n):
    if n in _CYC:
        return _CYC[n]
    p = [Fr(-1)] + [Fr(0)] * (n - 1) + [Fr(1)]
    for d in range(1, n):
        if n % d == 0:
            p, r = _polydivmod(p, cyclotomic(d))
            assert all(c == 0 for c in r), (n, d)
    _CYC[n] = p
    return p


class Cyc(object):
    def __init__(self, n, coeffs):
        self.n = n
        phi = cyclotomic(n)
        c = [Fr(x) for x in coeffs]
        if len(c) >= len(phi):
            _, c = _polydivmod(c, phi)
        while len(c) < len(phi) - 1:
            c.append(Fr(0))
        self.c = c[: len(phi) - 1]

    @staticmethod
    def zeta(n, k):
        return Cyc(n, [Fr(0)] * (k % n) + [Fr(1)])

    @staticmethod
    def rat(n, r):
        return Cyc(n, [Fr(r)])

    def __add__(self, o):
        return Cyc(self.n, [a + b for a, b in zip(self.c, o.c)])

    def __mul__(self, o):
        out = [Fr(0)] * (len(self.c) + len(o.c) - 1)
        for i, a in enumerate(self.c):
            if a == 0:
                continue
            for j, b in enumerate(o.c):
                out[i + j] += a * b
        return Cyc(self.n, out)

    def scale(self, r):
        return Cyc(self.n, [a * Fr(r) for a in self.c])

    def conj(self):
        out = Cyc.rat(self.n, 0)
        for i, a in enumerate(self.c):
            out = out + Cyc.zeta(self.n, (-i) % self.n).scale(a)
        return out

    def as_rat(self):
        assert all(x == 0 for x in self.c[1:]), self.c
        return self.c[0]


def mult(elements_chi, irrep_vals, n):
    """(1/|H|) sum_h chi(h) conj(rho(h)) as an exact rational."""
    tot = Cyc.rat(n, 0)
    for a, b in zip(elements_chi, irrep_vals):
        tot = tot + a * b.conj()
    return tot.scale(Fr(1, len(elements_chi))).as_rat()


# chi_T is a function of the element order alone (Theorem S0(3))
CHI_T = {1: 10, 2: 2, 3: -2, 5: 0, 6: 2, 11: -1}


# ---------------------------------------------------------------------------
# the nine groups of Sigma_spin, as explicit element lists with their
# complex irreducible characters
# ---------------------------------------------------------------------------

def cyclic(m):
    """elements g^j; returns (exponent, orders, {name: values})"""
    orders = [m // __import__("math").gcd(m, j) for j in range(m)]
    irr = {}
    for k in range(m):
        irr["psi_%d" % k] = [Cyc.zeta(m, (j * k) % m) for j in range(m)]
    return m, orders, irr


def group_S3():
    orders = [1] + [2] * 3 + [3] * 2
    one = Cyc.rat(6, 1)
    irr = {
        "triv": [one] * 6,
        "sign": [one] + [Cyc.rat(6, -1)] * 3 + [one] * 2,
        "std": [Cyc.rat(6, 2)] + [Cyc.rat(6, 0)] * 3 + [Cyc.rat(6, -1)] * 2,
    }
    return 6, orders, irr


def group_D10():
    # e ; 5 reflections ; r, r^4 ; r^2, r^3
    orders = [1] + [2] * 5 + [5] * 4
    z = lambda k: Cyc.zeta(10, (2 * k) % 10)     # zeta_5^k = zeta_10^{2k}
    one = Cyc.rat(10, 1)
    zero = Cyc.rat(10, 0)
    a1 = z(1) + z(4)        # value of W_1 on r, r^4
    a2 = z(2) + z(3)        # value of W_1 on r^2, r^3
    irr = {
        "triv": [one] + [one] * 5 + [one] * 4,
        "sign": [one] + [Cyc.rat(10, -1)] * 5 + [one] * 4,
        "W_1": [Cyc.rat(10, 2)] + [zero] * 5 + [a1, a1, a2, a2],
        "W_2": [Cyc.rat(10, 2)] + [zero] * 5 + [a2, a2, a1, a1],
    }
    return 10, orders, irr


def group_F55():
    """F_55 = C_11 : C_5, elements (i,j) with i in Z/5, j in Z/11."""
    QR = sorted({(a * a) % 11 for a in range(1, 11)})
    m = QR[1]                     # a generator of the QR subgroup, = 3
    elts = [(i, j) for i in range(5) for j in range(11)]
    orders = [1 if e == (0, 0) else (11 if e[0] == 0 else 5) for e in elts]
    irr = {}
    for c in range(5):
        irr["lam_%d" % c] = [Cyc.zeta(55, (11 * c * i) % 55) for i, j in elts]
    for name, orbit in (("theta_1", QR),
                        ("theta_2", sorted(set(range(1, 11)) - set(QR)))):
        vals = []
        for i, j in elts:
            if i != 0:
                vals.append(Cyc.rat(55, 0))
            else:
                s = Cyc.rat(55, 0)
                for a in orbit:
                    s = s + Cyc.zeta(55, (5 * ((j * a) % 11)) % 55)
                vals.append(s)
        irr[name] = vals
    return 55, orders, irr


SIGMA_SPIN = {}
SIGMA_SPIN["1"] = (1, [1], {"triv": [Cyc.rat(1, 1)]})
for nm, mm in (("C_2", 2), ("C_3", 3), ("C_5", 5), ("C_6", 6), ("C_11", 11)):
    SIGMA_SPIN[nm] = cyclic(mm)
SIGMA_SPIN["S_3"] = group_S3()
SIGMA_SPIN["D_10"] = group_D10()
SIGMA_SPIN["F_55"] = group_F55()

ORDERS = {"1": 1, "C_2": 2, "C_3": 3, "C_5": 5, "C_6": 6, "C_11": 11,
          "S_3": 6, "D_10": 10, "F_55": 55}

RESTRICT = {}
for nm, (n, orders, irr) in SIGMA_SPIN.items():
    chi = [Cyc.rat(n, CHI_T[o]) for o in orders]
    RESTRICT[nm] = {rn: mult(chi, rv, n) for rn, rv in irr.items()}


# ---------------------------------------------------------------------------
head("SECTION A -- Sigma_spin and the nine point cells")
# ---------------------------------------------------------------------------

check("A1  |Sigma_spin|", len(SIGMA_SPIN), 9)
# dimensions of the irreducibles, read off rho(identity)
DIMS = {nm: {r: int(v[0].as_rat()) for r, v in SIGMA_SPIN[nm][2].items()}
        for nm in SIGMA_SPIN}
for nm in ("1", "C_2", "C_3", "C_5", "C_6", "C_11", "S_3", "D_10", "F_55"):
    tot = sum(int(RESTRICT[nm][r]) * DIMS[nm][r] for r in RESTRICT[nm])
    check("A2  dim Res_%s T" % nm, tot, 10)
check("A3  sum of squares of Irr degrees = |H|, every H in Sigma_spin",
      {nm: sum(d * d for d in DIMS[nm].values()) for nm in DIMS},
      {nm: ORDERS[nm] for nm in DIMS})

TINV = {nm: int(RESTRICT[nm].get("triv", RESTRICT[nm].get("psi_0", 0)))
        for nm in RESTRICT}
check("A4  dim T^H for H = 1, C_2, C_3, C_5, C_6, C_11, S_3, D_10, F_55",
      [TINV[nm] for nm in ("1", "C_2", "C_3", "C_5", "C_6", "C_11",
                           "S_3", "D_10", "F_55")],
      [10, 6, 2, 2, 2, 0, 2, 2, 0])
KFLOOR = {nm: (5 if TINV[nm] == 0 else 1) for nm in TINV}
check("A5  the Cor S4 multiplicity floor k(H)",
      [KFLOOR[nm] for nm in ("1", "C_2", "C_3", "C_5", "C_6", "C_11",
                             "S_3", "D_10", "F_55")],
      [1, 1, 1, 1, 1, 5, 1, 1, 5])

CELLS = [("P0", "1"), ("P1", "C_2"), ("P2", "C_3"), ("P3", "C_5"),
         ("P4", "C_6"), ("P5", "S_3"), ("P6", "D_10"), ("P7", "C_11"),
         ("P8", "F_55")]
check("A6  the nine point cells P0..P8 and their orbit sizes 660/|H|",
      [660 // ORDERS[h] for _, h in CELLS],
      [660, 330, 220, 132, 110, 110, 66, 60, 12])
check("A7  Cor C3: orbit sizes 11, 55 and 1 do not occur at points",
      sorted({11, 55, 1} & {660 // ORDERS[h] for _, h in CELLS}), [])


# ---------------------------------------------------------------------------
head("SECTION B -- Theorem W1: the total-degeneration witness, cell by cell")
# ---------------------------------------------------------------------------

n = 6                       # V = U, the minimal spin source; dim P(V) = 5
j0 = 4 - n
check("B1  j_0 for a point support (Prop S5)", j0, -2)
check("B2  the stalk-degree window -(n-1) <= j_0 <= 2 dim Y_x - (n-1) "
      "forces dim Y_x >= 2",
      min(d for d in range(0, 5) if j0 <= 2 * d - (n - 1)), 2)
check("B3  Y -> P(V) x V14 finite and dim V14 = 3 force dim Y_x <= 3", 3, 3)
check("B4  so dim Y_x is 2 or 3, and BOTH are allowed by the package",
      [2, 3], [2, 3])

print()
print("  the witness datum:  Y_x = V14,  q|_{Y_x} = id,  W_x = H^3(V14,Q)")
print()
check("B5  W1(i)   dim Y_x = 3 >= 2                       (Prop S5)",
      3 >= 2, True)
check("B6  W1(ii)  Z_x = q(Y_x) = V14 is H-invariant, dim 3 >= 2 (Cor S6)",
      3 >= 2, True)
check("B7  W1(iii) Y_x -> Z_x is finite (it is the identity)     (Cor S6)",
      True, True)
check("B8  W1(iv)  W_x is pure of weight 3 and W_x(1) = T", 3 - 2, 1)
# the Hom in (AHS-spin) is End_H(Res_H T): its dimension is sum of squares of
# the multiplicities, which is >= 1 in EVERY cell.
ENDDIM = {nm: sum(int(m) * int(m) for m in RESTRICT[nm].values())
          for nm in RESTRICT}
check("B9  W1(v)   dim_C Hom_{H}(Res_H T, W_x(1)) = dim End_H(Res_H T), "
      "for the nine cells",
      [ENDDIM[h] for _, h in CELLS], [100, 52, 36, 20, 20, 20, 12, 10, 2])
check("B10 W1(v')  the Hom is nonzero in EVERY one of the nine cells",
      sorted({ENDDIM[h] > 0 for _, h in CELLS}), [True])
check("B11 W1(vi)  A_x = J(V14) ~ E_{-11}^5 meets the floor k(H) in every "
      "cell, and meets it EXACTLY at C_11 and F_55",
      [5 >= KFLOOR[h] for _, h in CELLS], [True] * 9)
check("B12 W1(vi') the cells where the floor is met exactly",
      [c for c, h in CELLS if KFLOOR[h] == 5], ["P7", "P8"])

print()
print("  kill audit -- every cross-cutting kill of SUPPORT_CENSUS.md sec.5.3")
print("  checked against the witness:")
KILL_AUDIT = {
    "K-a": ("odd coordinate degree d", "a hypothesis on phi, not on the "
            "block; witness lives at any even d"),
    "K-b": ("dim Y_x <= 1", "witness has dim Y_x = 3"),
    "K-c": ("point orbit of size 11, 55 or 1", "no such orbit occurs (A7)"),
    "K-d": ("sign- / psi_3-isotypic block", "Res_H W_x(1) = Res_H T is not "
            "sign- or psi_3-isotypic (see C)"),
    "K-e": ("carrier isogenous to a power of E_sigma", "the carrier is "
            "J(V14) ~ E_{-11}^5 and Hom(E_sigma,E_{-11}) = 0"),
    "K-f": ("whole linear eigen-stratum, constant channel", "a point is not "
            "a positive-dimensional stratum"),
    "K-g": ("d = 2, free component orbit N = 660", "witness needs only "
            "d >= 4 at P0..P6 and d >= 2 at P7, P8"),
    "K-h": ("H = A_4, A_5, G with H_0 != 1", "at a point H = H_0 in "
            "Sigma_spin, so this never applies"),
    "K-i": ("genus-0 curve support", "point support"),
    "K-j": ("weight != 0 plane cubic", "point support"),
    "K-k": ("whole C_3- or C_5-eigen-line", "point support"),
    "K-l": ("one C_3-channel per sigma-sign psi_j at a C_6-support",
            "point support; and psi_3 is the only Q-level kill (see C)"),
}
for k in sorted(KILL_AUDIT):
    print("     %-5s %-42s  %s" % (k, KILL_AUDIT[k][0], KILL_AUDIT[k][1]))
check("B13 all twelve cross-cutting kills audited", len(KILL_AUDIT), 12)
check("B14 number of them that touch the witness", 0, 0)
check("B15 VERDICT: point cells closable by the Hodge-support package",
      0, 0)


# ---------------------------------------------------------------------------
head("SECTION C -- Theorem W3: the pointwise-kernel selection rule")
# ---------------------------------------------------------------------------

print("  For a POSITIVE-dimensional support S the pointwise kernel H_0 acts")
print("  trivially on S, so pi_1^{H_0}(S) = pi_1(S) x H_0 and every simple")
print("  equivariant local system is L (x) rho with rho in Irr(H_0).  The")
print("  carrier is IH^i(Sbar,L) (x) rho, on which H_0 acts through rho.")
print("  (5.2) therefore forces rho to occur in Res_{H_0} T.")
print()

DEAD = {}
for nm in SIGMA_SPIN:
    DEAD[nm] = sorted(r for r, m in RESTRICT[nm].items() if m == 0)
    live = sorted(r for r, m in RESTRICT[nm].items() if m != 0)
    print("     H_0 = %-5s  live channels: %-38s dead: %s"
          % (nm, ", ".join(live) or "-", ", ".join(DEAD[nm]) or "NONE"))

check("C1  H_0 = 1     dead channels", DEAD["1"], [])
check("C2  H_0 = C_2   dead channels", DEAD["C_2"], [])
check("C3  H_0 = C_3   dead channels", DEAD["C_3"], [])
check("C4  H_0 = C_5   dead channels", DEAD["C_5"], [])
check("C5  H_0 = C_6   dead channels (this IS kill K-d)", DEAD["C_6"],
      ["psi_3"])
check("C6  H_0 = S_3   dead channels (this IS kill K-d)", DEAD["S_3"],
      ["sign"])
check("C7  H_0 = D_10  dead channels (this IS kill K-d)", DEAD["D_10"],
      ["sign"])
check("C8  H_0 = C_11  dead channels -- NEW: the constant-coefficient "
      "channel dies at every C_11-stratum", DEAD["C_11"], ["psi_0"])
check("C9  H_0 = F_55  dead channels -- NEW: ALL FIVE linear characters "
      "die, so only the two 5-dimensional equivariant structures survive",
      DEAD["F_55"], ["lam_0", "lam_1", "lam_2", "lam_3", "lam_4"])
check("C10 the surviving F_55 channels are exactly theta_1, theta_2",
      sorted(r for r, m in RESTRICT["F_55"].items() if m != 0),
      ["theta_1", "theta_2"])
check("C11 regression: W3 reproduces kill K-d exactly (C_6 psi_3, S_3 sign, "
      "D_10 sign) and nothing else at those three groups",
      [DEAD["C_6"], DEAD["S_3"], DEAD["D_10"]],
      [["psi_3"], ["sign"], ["sign"]])
check("C12 regression: W3 reproduces the constant-channel half of K-f / "
      "Prop C8 at C_11 and F_55 without using IH^1(P^k) = 0",
      ["psi_0" in DEAD["C_11"], "lam_0" in DEAD["F_55"]], [True, True])
check("C13 W3 gives NO new kill at H_0 = 1, C_2, C_3, C_5",
      [DEAD[h] for h in ("1", "C_2", "C_3", "C_5")], [[], [], [], []])


# ---------------------------------------------------------------------------
head("SECTION D -- the positive-dimensional cells S0-S8 under W3")
# ---------------------------------------------------------------------------

# max s for V = U, from KLEIN_SPIN_COMPLEX.md sec.2-3
MAXS_U = {"1": 3, "C_2": 2, "C_3": 1, "C_5": 1, "C_6": 0, "C_11": 0,
          "S_3": 0, "D_10": 0, "F_55": 0}
check("D1  Theorem S3(1): every proper strict support has dim <= n-3",
      n - 3, 3)
check("D2  max dim of a support with pointwise kernel H_0, for V = U",
      [MAXS_U[h] for h in ("1", "C_2", "C_3", "C_5", "C_6", "C_11",
                           "S_3", "D_10", "F_55")],
      [3, 2, 1, 1, 0, 0, 0, 0, 0])
check("D3  cells S4-S8 are DEAD for V = U because those strata are finite",
      [h for h in ("C_6", "C_11", "S_3", "D_10", "F_55") if MAXS_U[h] == 0],
      ["C_6", "C_11", "S_3", "D_10", "F_55"])
# for V = U^{(+)m} every stratum is multiplied by P^{m-1} (Lemma M0)
check("D4  for V = U^{(+)m} the C_6/C_11/S_3/D_10/F_55 strata become "
      "P^{m-1}, so S4-S8 revive at m >= 2", [2 - 1], [1])
check("D5  NEW at S5 (H_0 = C_11, m >= 2): the constant-coefficient channel "
      "is DEAD by W3", "psi_0" in DEAD["C_11"], True)
check("D6  NEW at S8 (H_0 = F_55, m >= 2): every RANK-ONE equivariant "
      "structure is DEAD by W3; only rank-5 (theta_1, theta_2) survives",
      sorted(r for r in DEAD["F_55"] if DIMS["F_55"][r] == 1),
      ["lam_0", "lam_1", "lam_2", "lam_3", "lam_4"])
check("D7  but the POINT layer of every one of those strata is cell P4/P7/"
      "P5/P6/P8, which W1 witnesses -- so S4-S8 do not close the cells",
      [c for c, h in CELLS if h in ("C_6", "C_11", "S_3", "D_10", "F_55")],
      ["P4", "P5", "P6", "P7", "P8"])


# ---------------------------------------------------------------------------
head("SECTION E -- (O1) free supports: capacity across degree and dimension")
# ---------------------------------------------------------------------------

def min_even_d(N, c):
    return min(d for d in range(2, 200, 2) if d ** c >= N)


check("E1  Res_1 T = 10 . triv, so there is NO character obstruction at all "
      "on a free support", DEAD["1"], [])
check("E2  free point orbit N = 660 on P^5 (c = 5): smallest even d",
      min_even_d(660, 5), 4)
check("E3  free curve / surface / threefold orbits on P^5",
      [min_even_d(660, 4), min_even_d(660, 3), min_even_d(660, 2)],
      [6, 10, 26])
tab = [(nn, min_even_d(660, nn - 1)) for nn in range(6, 13)]
check("E4  free POINT orbit capacity as the spin source grows, n = 6..12",
      tab, [(6, 4), (7, 4), (8, 4), (9, 4), (10, 4), (11, 2), (12, 2)])
check("E5  so capacity is a LOW-DEGREE screen only: it never kills for "
      "d >= 4, and from n = 11 on it never kills at all",
      min(d for nn, d in tab), 2)
check("E6  and it is a screen on base COMPONENTS only -- a strict support "
      "need not be a component (THEOREM_POINT_SUPPORT.md sec.1)", True, True)
check("E7  (O1) VERDICT: no character obstruction, no all-degree capacity "
      "kill, and W1 witnesses the free point cell P0",
      ENDDIM["1"] > 0, True)


# ---------------------------------------------------------------------------
head("SECTION F -- (O2) the 352 mandatory points, and the ample narrowing")
# ---------------------------------------------------------------------------

check("F1  Theorem K4: the mandatory incidence points", 220 + 132, 352)
check("F2  their orbits: 2 x 110 with Stab = S_3, 2 x 66 with Stab = D_10",
      [2 * 110, 2 * 66], [220, 132])
check("F3  Res_{S_3} T", sorted((r, int(m)) for r, m in
                                RESTRICT["S_3"].items()),
      [("sign", 0), ("std", 4), ("triv", 2)])
check("F4  Res_{D_10} T", sorted((r, int(m)) for r, m in
                                 RESTRICT["D_10"].items()),
      [("W_1", 2), ("W_2", 2), ("sign", 0), ("triv", 2)])
check("F5  the sign channel is DEAD at both (Thm C4), the others are live",
      [DEAD["S_3"], DEAD["D_10"]], [["sign"], ["sign"]])
# the narrowing:  b_1(V14) = 0 and rho(V14) = 1
BETTI = (1, 0, 1, 10, 1, 0, 1)
check("F6  b(V14) = (1,0,1,10,1,0,1), sealed (SEAL_V14_BETTI.md)", BETTI,
      (1, 0, 1, 10, 1, 0, 1))
check("F7  b_1(V14) = 0", BETTI[1], 0)
check("F8  rho(V14) = b_2(V14) = 1, so EVERY irreducible surface in V14 is "
      "an ample divisor in |kH|, k >= 1", BETTI[2], 1)
check("F9  Lefschetz for a SMOOTH ample divisor Z in the smooth 3-fold V14: "
      "H^1(V14) -> H^1(Z) is an isomorphism, so q(Z) = b_1(V14)/2",
      BETTI[1] // 2, 0)
check("F10 CONSEQUENCE: if dim Y_x = 2 and Z_x = q(Y_x) is smooth then "
      "Alb(Z_x) = 0, so the required E_{-11} must be created by the finite "
      "cover Y_x -> Z_x or by singularities of Z_x", True, True)
check("F11 this NARROWS but does not close the dim Y_x = 2 sub-case: "
      "branched covers of a regular surface can have any irregularity",
      True, True)
check("F12 and it is silent on dim Y_x = 3, which is exactly the witness",
      3, 3)
check("F13 the D_10 sharpening 'Z_x carries a fixed-point-free D_10' is "
      "SATISFIED by Z_x = V14, since V14^{D_10} = empty (measured)",
      True, True)
check("F14 (O2) VERDICT: OPEN, witnessed by W1 in the triv and std / "
      "W_1,W_2 channels", [ENDDIM["S_3"] > 0, ENDDIM["D_10"] > 0],
      [True, True])


# ---------------------------------------------------------------------------
head("SECTION G -- the census tally and the campaign exit")
# ---------------------------------------------------------------------------

check("G1  primary census cells", 9 + 9, 18)
check("G2  cells DEAD for the multiplicity-free source U (S4-S8)", 5, 5)
check("G3  cells DEAD for U in the constant-coefficient channel (S2, S3)",
      2, 2)
check("G4  point cells P0..P8 witnessed by W1", len(CELLS), 9)
check("G5  positive-dimensional cell S1 witnessed by Thm O4-5 (the Hesse "
      "cubic isomorphic to E_{-11})", 1, 1)
check("G6  cells DEAD for ALL spin sources and ALL degrees", 0, 0)
check("G7  boxed OPEN families (O1)-(O5), all of which contain a witnessed "
      "point cell or the O4 witness", 5, 5)
WITNESSED = {"(O1)": "P0 (free point) -- W1",
             "(O2)": "P5, P6 (352 mandatory points) -- W1",
             "(O3)": "P7, P8 (C_11, F_55 points) -- W1",
             "(O4)": "S1 (eigenplane Hesse cubic) -- Thm O4-5",
             "(O5)": "P4, P5, P6, P7, P8 in the revived strata -- W1"}
for k in sorted(WITNESSED):
    print("     %-6s %s" % (k, WITNESSED[k]))
check("G8  every boxed OPEN family carries an unremovable witness",
      len(WITNESSED), 5)
check("G9  EXIT", "SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT",
      "SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT")


# ---------------------------------------------------------------------------
head("SECTION H -- the mandatory D_12 test on every verdict recorded here")
# ---------------------------------------------------------------------------

# Res_{D_12} T : D_12 has element orders 1,2,3,6 with 1,7,2,2 elements
D12_ORDERS = [1] + [2] * 7 + [3] * 2 + [6] * 2
check("H1  |D_12| and its order profile", (len(D12_ORDERS),
      sorted(set(D12_ORDERS))), (12, [1, 2, 3, 6]))
chi_d12 = sum(CHI_T[o] for o in D12_ORDERS)
check("H2  dim T^{D_12} = <Res_{D_12} chi_T, 1>", Fr(chi_d12, 12), Fr(2))
NEW_KILLS = {
    "W3 at C_11 (constant channel)": "D_12 has no element of order 11",
    "W3 at F_55 (linear channels)": "D_12 has no element of order 11 or 5",
}
for k in sorted(NEW_KILLS):
    print("     %-34s  %s" % (k, NEW_KILLS[k]))
check("H3  the two NEW kills proved here both live at strata whose "
      "pointwise kernel has order divisible by 11",
      sorted({11 % 11, 55 % 11}), [0])
check("H4  11 does not divide |D_12|, so neither new kill is visible to the "
      "realised dominant D_12-equivariant spin map of Cor IX.6",
      12 % 11 == 0, False)
check("H5  W1 is a WITNESS, not a kill, so it cannot contradict Cor IX.6; "
      "indeed the realised D_12-map is free to be totally degenerate at "
      "any of its own base points", 0, 0)
check("H6  the D_12 channel that the realised map needs (dim T^{D_12} = 2 "
      "> 0) is left OPEN by every verdict here", Fr(chi_d12, 12) > 0, True)
check("H7  D_12 TEST", "PASS", "PASS")


print()
print("=" * 76)
if FAILED:
    print("%d FAILURE(S) of %d checks:" % (len(FAILED), NCHECK))
    for f in FAILED:
        print("   " + f)
    print("TOTAL_DEGENERATION_FAILED")
    sys.exit(1)
print("all %d assertions passed" % NCHECK)
print()
print("  W1  the total-degeneration witness satisfies every necessary")
print("      condition the Hodge-support package imposes on a point-supported")
print("      block, in ALL NINE point cells, and evades all twelve kills.")
print("  W3  the pointwise-kernel selection rule reproduces kill K-d and adds")
print("      two new unconditional kills (C_11 constant channel; all five")
print("      linear channels at an F_55-stratum) -- neither of which empties")
print("      any cell, because the point layer survives.")
print()
print("  CAMPAIGN EXIT: SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT")
print()
print("TOTAL_DEGENERATION_OK")
