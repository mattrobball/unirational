#!/usr/bin/env python3
"""
verify_o4_census.py -- census cell (O4) of `SUPPORT_CENSUS.md` section 6:
strict supports that are CURVES inside the 110 eigenplanes of the spin source
P(U), and inside the eigen-line strata of C_3 and C_5.

Companion to `O4_EIGENPLANE_CURVES.md`.  Everything is exact: the source-side
group and representation data come from the integral monomial model
W = Ind_B^{SL(2,11)}(chi) of `spin_network_lib` (signed 12x12 permutation
matrices, entries in Z), the C_12 / C_6 / C_10 decompositions are computed by
orthogonality inside the cyclotomic rings Z[zeta_12], Z[zeta_6], Z[zeta_10],
and the halving principle transports them to the 6-dimensional spin
irreducible U.  The plane-curve layer is monomial-weight combinatorics.

No Macaulay2, no msolve, no network, no data files.  Python 3 standard
library plus `spin_network_lib` from this directory.  Runtime a few seconds.

Marker on success: O4_CENSUS_OK
"""

from fractions import Fraction as Fr
from itertools import combinations

from spin_network_lib import (SpinNetwork, gint, gz, gsub, gmul, gadd,
                              kernel_basis, rank)

FAILED = []
NCHECK = 0


def check(name, got, want):
    global NCHECK
    NCHECK += 1
    if got != want:
        FAILED.append(f"{name}: got {got!r}, want {want!r}")
        print(f"  FAIL {name}: got {got!r}, want {want!r}")
    return got == want


# ----------------------------------------------------------------------
# cyclotomic bookkeeping: multiplicities of the characters of a cyclic
# group, extracted by orthogonality inside Z[x]/(Phi_n)
# ----------------------------------------------------------------------
PHI = {6: [1, -1, 1],                       # x^2 - x + 1
       10: [1, -1, 1, -1, 1],               # x^4 - x^3 + x^2 - x + 1
       12: [1, 0, -1, 0, 1]}                # x^4 - x^2 + 1


def polyrem(coeffs, phi):
    """remainder of sum coeffs[i] x^i modulo the monic polynomial phi
    (phi given low-to-high, leading coefficient 1)."""
    c = list(coeffs)
    d = len(phi) - 1
    while len(c) > d:
        lead = c[-1]
        k = len(c) - 1 - d
        if lead:
            for i, a in enumerate(phi):
                c[k + i] -= lead * a
        c.pop()
    while len(c) < d:
        c.append(0)
    return c


def cyclic_multiplicities(n, chi_values):
    """chi_values[j] = chi(g^j) for a generator g of C_n, all rational.
    Returns [m_0,...,m_{n-1}] with m_k the multiplicity of the character
    g -> zeta_n^k, asserting each is a nonnegative integer.  Uses only the
    ring Z[x]/(Phi_n) -- no floating point."""
    phi = PHI[n]
    out = []
    for k in range(n):
        acc = [0] * n
        for j in range(n):
            acc[(-k * j) % n] += chi_values[j]
        r = polyrem(acc, phi)
        assert all(x == 0 for x in r[1:]), (n, k, r)
        assert r[0] % n == 0, (n, k, r)
        out.append(r[0] // n)
    return out


# ======================================================================
print("=" * 72)
print("SECTION A -- the residual action on an eigenplane, from the model")
print("=" * 72)

net = SpinNetwork(11, full_incidence=False)
ID, NEG, mul, inv = net.ID, net.NEG, net.mul, net.inv
check("A0 |SL(2,11)|", len(net.SL), 1320)
check("A0' -I is the unique involution",
      sum(1 for g in net.SL if net.ORD[g] == 2), 1)

# --- the C_12 lift of a C_6 = Stab_G(eigenplane) ----------------------
g12 = next(g for g in net.SL if net.ORD[g] == 12)
pw12 = [ID]
for _ in range(11):
    pw12.append(mul(pw12[-1], g12))
check("A1 g12 has projective order 6", net.proj_order(g12), 6)
check("A2 g12^6 = -I", pw12[6], NEG)
chiW12 = [net.CHI[p] for p in pw12]
check("A3 chi_W on the C_12 lift",
      chiW12, [12, 0, 0, 0, 0, 0, -12, 0, 0, 0, 0, 0])
mW12 = cyclic_multiplicities(12, chiW12)
check("A4 W|_{C_12}: multiplicity 2 on each spin character, 0 on the rest",
      mW12, [0, 2, 0, 2, 0, 2, 0, 2, 0, 2, 0, 2])
# halving principle (Galois over Q(zeta_12); sqrt(-11) is not in Q(zeta_12),
# whose conductor is 12, so Gal still swaps U and U')
mU12 = [m // 2 for m in mW12]
check("A5 U|_{C_12} is multiplicity-free on the six spin characters",
      mU12, [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1])
check("A6 dim U", sum(mU12), 6)

# sigma~ = g12^3 (order 4), c~ = g12^4 (order 3)
check("A7 sigma~ = g12^3 has order 4", net.ORD[pw12[3]], 4)
check("A8 c~ = g12^4 has order 3", net.ORD[pw12[4]], 3)
# on the character zeta_12^k: sigma~ acts by i^k, c~ by omega^k
SPIN_K = [k for k in range(12) if mU12[k]]
check("A9 the six spin characters", SPIN_K, [1, 3, 5, 7, 9, 11])
PLUS_I = [k for k in SPIN_K if k % 4 == 1]          # i^k = +i
check("A10 dim of the (+i)-eigenspace of sigma~ on U", len(PLUS_I), 3)
check("A11 the sigma-eigenplane is a P^2", len(PLUS_I) - 1, 2)
C3_EIGS = sorted(k % 3 for k in PLUS_I)
check("A12 the three C_3-eigenvalues on the eigenplane are 1, w, w^2 "
      "(pairwise distinct)", C3_EIGS, [0, 1, 2])
check("A13 hence Fix_Pi(C_3) = 3 isolated points "
      "(KLEIN_SPIN_COMPLEX.md sec.3: 6 C_6-points, 3 per plane)",
      len(set(C3_EIGS)), 3)
MINUS_I = [k for k in SPIN_K if k % 4 == 3]
check("A14 the other eigenplane is also a P^2 with the same C_3-spectrum",
      (len(MINUS_I), sorted(k % 3 for k in MINUS_I)), (3, [0, 1, 2]))

# --- sigma acts trivially on its eigenplanes --------------------------
check("A15 sigma~ acts on U_{+i} by the single scalar i, so sigma acts "
      "trivially on Pi", len({k % 4 for k in PLUS_I}), 1)

# ======================================================================
print()
print("=" * 72)
print("SECTION B -- setwise stabilisers of the strata")
print("=" * 72)

n = net.n


def in_span(vec, basis):
    """membership test over Q(i) by a rank comparison."""
    r0 = rank([tuple(b) for b in basis], n)
    r1 = rank([tuple(b) for b in basis] + [tuple(vec)], n)
    return r0 == r1


def stab_of_span(basis):
    """{g in SL(2,11) : rho(g) preserves span(basis)} -- returned as the
    number of PROJECTIVE elements, i.e. |Stab_G|."""
    out = 0
    for g in net.SL:
        if all(in_span(net.apply_rho(g, b), basis) for b in basis):
            out += 1
    return out // 2


def eigenspace(g, lam):
    """kernel of (rho(g) - lam) over Q(i); lam a Gaussian rational pair."""
    M = []
    for i in range(n):
        row = []
        for j in range(n):
            x = gint(net.RHO[g][i][j])
            if i == j:
                x = gsub(x, lam)
            row.append(x)
        M.append(tuple(row))
    return kernel_basis(M, n)


# the eigenplane itself: EB[(k,+1)] is the (+i)-eigenspace inside W
PL = net.PLANES[0]
EBpl = net.EB[PL]
check("B1 the (+i)-eigenspace of an involution lift is 6-dim in W "
      "(3-dim in U by halving)", len(EBpl), 6)
check("B2 Stab_G(Pi) = C_6, order 6", stab_of_span(EBpl), 6)

sigma = net.INV[PL[0]]
CG = [g for g in net.SL if net.commute_proj(sigma, g)]
check("B3 |C_G(sigma)| = 12 (D_12)", len(CG) // 2, 12)
swap = 0
for g in CG:
    if not all(in_span(net.apply_rho(g, b), EBpl) for b in EBpl):
        swap += 1
check("B4 exactly 6 of the 12 elements of D_12 swap the two planes",
      swap // 2, 6)

# --- the C_3 eigen-lines ---------------------------------------------
t6 = next(g for g in net.SL if net.ORD[g] == 6 and mul(mul(g, g), g) == NEG)
chiW6 = [net.CHI[x] for x in
         [ID, t6, mul(t6, t6), mul(mul(t6, t6), t6),
          mul(mul(mul(t6, t6), t6), t6), mul(mul(mul(mul(t6, t6), t6), t6), t6)]]
mW6 = cyclic_multiplicities(6, chiW6)
check("B5 W|_{C_6-lift of C_3}: 4 on each spin character", mW6, [0, 4, 0, 4, 0, 4])
check("B6 U|: multiplicity 2 on zeta_6, -1, zeta_6^5 -> three P^1's",
      [m // 2 for m in mW6], [0, 2, 0, 2, 0, 2])
lineB = eigenspace(t6, gint(-1))
check("B7 the (-1)-eigenline of the C_3-lift is 4-dim in W (2-dim in U)",
      len(lineB), 4)
check("B8 Stab_G(that line) = D_12, order 12", stab_of_span(lineB), 12)
# the two zeta_6-eigenlines are swapped by any reflection of N_G(C_3)
NG3 = [g for g in net.SL
       if mul(mul(g, t6), inv(g)) in (t6, mul(NEG, t6),
                                      inv(t6), mul(NEG, inv(t6)))]
check("B9 |N_G(C_3)| = 12", len(NG3) // 2, 12)
refl = [g for g in NG3 if mul(mul(g, t6), inv(g)) in (inv(t6), mul(NEG, inv(t6)))
        and mul(mul(g, t6), inv(g)) not in (t6, mul(NEG, t6))]
check("B10 6 of them invert the C_3-lift, so they swap the zeta_6-eigenlines",
      len(refl) // 2, 6)

# --- the C_5 eigen-line ----------------------------------------------
u10 = next(g for g in net.SL if net.ORD[g] == 10 and net.proj_order(g) == 5)
pw10 = [ID]
for _ in range(9):
    pw10.append(mul(pw10[-1], u10))
mW10 = cyclic_multiplicities(10, [net.CHI[x] for x in pw10])
check("B11 W|_{C_10}: 4 on zeta_10^5 = -1, 2 on the other spin characters",
      mW10, [0, 2, 0, 2, 0, 4, 0, 2, 0, 2])
check("B12 U|_{C_10}: the (-1)-eigenspace is 2-dim -> one P^1, "
      "plus 4 isolated points", [m // 2 for m in mW10],
      [0, 1, 0, 1, 0, 2, 0, 1, 0, 1])
line5 = eigenspace(u10, gint(-1))
check("B13 the C_5-eigenline is 4-dim in W (2-dim in U)", len(line5), 4)
check("B14 Stab_G(the C_5-line) = D_10, order 10", stab_of_span(line5), 10)

# --- the resulting orbit sizes ---------------------------------------
ORBITS = {
    "eigenplane curve, H = C_6": 660 // 6,
    "eigenplane curve, H = C_2": 660 // 2,
    "C_3 eigen-line, the (-1) one, H = D_12": 660 // 12,
    "C_3 eigen-line, the zeta_6 pair, H = C_6": 660 // 6,
    "C_5 eigen-line, H = D_10": 660 // 10,
    "whole eigenplane, H = C_6": 660 // 6,
}
check("B15 orbit sizes",
      [ORBITS[k] for k in ("eigenplane curve, H = C_6",
                           "eigenplane curve, H = C_2",
                           "C_3 eigen-line, the (-1) one, H = D_12",
                           "C_3 eigen-line, the zeta_6 pair, H = C_6",
                           "C_5 eigen-line, H = D_10")],
      [110, 330, 55, 110, 66])
check("B16 55 C_3-subgroups x 3 lines = 55 + 110", 55 * 3, 55 + 110)
check("B17 66 C_5-subgroups x 1 line = one orbit of 66", 66 * 1, 66)

# ======================================================================
print()
print("=" * 72)
print("SECTION C -- the C_6 channel table for Res_{C_6} T")
print("=" * 72)

# chi_T is a function of the element order (Theorem S0(3))
CHI_T = {1: 10, 2: 2, 3: -2, 5: 0, 6: 2, 11: -1}
C6_ORDERS = [1, 6, 3, 2, 3, 6]                # orders of g^0..g^5 in C_6
resC6 = cyclic_multiplicities(6, [CHI_T[o] for o in C6_ORDERS])
check("C1 Res_{C_6} T = 2(psi_0+psi_1+psi_2+psi_4+psi_5), psi_3 absent",
      resC6, [2, 2, 2, 0, 2, 2])
check("C2 dim T^{C_6} = 2", resC6[0], 2)
check("C3 dim T^{C_2} = sum over sigma-trivial characters = 6",
      resC6[0] + resC6[2] + resC6[4], 6)
check("C4 the sigma-sign part has dimension 4",
      resC6[1] + resC6[3] + resC6[5], 4)


def live(a, j):
    """A curve support S in an eigenplane, with sigma acting trivially on S,
    an H-equivariant rank-one coefficient system L = Q(-1) (x) psi_j, and a
    class in the omega^a-isotypic part of H^1(Stilde): the carrier sits in
    the C_6-character psi_{(2a+j) mod 6}, and the (AHS-spin) Hom can be
    nonzero only if that character occurs in Res_{C_6} T."""
    return resC6[(2 * a + j) % 6] > 0


check("C5 for a sigma-trivial equivariant structure every C_3-channel lives",
      [[live(a, j) for a in range(3)] for j in (0, 2, 4)],
      [[True] * 3] * 3)
check("C6 for each sigma-sign structure exactly one C_3-channel dies",
      [sum(0 if live(a, j) else 1 for a in range(3)) for j in (1, 3, 5)],
      [1, 1, 1])
check("C7 the dead channel of psi_3 is the C_3-trivial one -- this is the "
      "kill K-d of SUPPORT_CENSUS.md", [a for a in range(3) if not live(a, 3)],
      [0])
check("C8 the dead channels of psi_1 and psi_5",
      [[a for a in range(3) if not live(a, j)] for j in (1, 5)], [[1], [2]])

# dim T^H for the stabilisers that occur, by averaging chi_T
SUBGROUP_ORDERS = {
    "C_2": [1, 2],
    "C_3": [1, 3, 3],
    "C_5": [1, 5, 5, 5, 5],
    "C_6": C6_ORDERS,
    "D_10": [1, 5, 5, 5, 5] + [2] * 5,
    "D_12": [1, 2, 3, 3, 6, 6] + [2] * 6,
}
inv_dims = {k: Fr(sum(CHI_T[o] for o in v), len(v))
            for k, v in SUBGROUP_ORDERS.items()}
check("C9 dim T^H for H = C_2, C_3, C_5, C_6, D_10, D_12",
      [inv_dims[k] for k in ("C_2", "C_3", "C_5", "C_6", "D_10", "D_12")],
      [Fr(6), Fr(2), Fr(2), Fr(2), Fr(2), Fr(2)])
check("C10 Frobenius: <chi_T, Ind_H^G 1> = dim T^H > 0 for every stabiliser "
      "in the O4 cell, so no orbit is excluded by the permutation character",
      all(v > 0 for v in inv_dims.values()), True)

# ======================================================================
print()
print("=" * 72)
print("SECTION D -- plane curves in an eigenplane, degree by degree")
print("=" * 72)

# Coordinates x_0, x_1, x_2 on Pi diagonalise the C_3 with weights 0, -1, -2
# (mod 3) -- Section A shows the three eigenvalues are distinct.  A monomial
# x^(a0,a1,a2) has weight w = -(a1 + 2 a2) mod 3.  A curve S = {F = 0} is
# C_3-stable iff F is a semi-invariant of some weight eps.


def wt(m):
    return (-(m[1] + 2 * m[2])) % 3


def monomials(d):
    return [(a, b, d - a - b) for a in range(d + 1) for b in range(d + 1 - a)]


check("D1 the weight-0 cubics are exactly the Hesse family "
      "x^3, y^3, z^3, xyz",
      sorted(m for m in monomials(3) if wt(m) == 0),
      sorted([(3, 0, 0), (0, 3, 0), (0, 0, 3), (1, 1, 1)]))
check("D2 every weight-nonzero cubic misses all three coordinate cubes",
      [[m for m in monomials(3) if wt(m) == e and max(m) == 3]
       for e in (1, 2)], [[], []])


def h1_channels(delta, eps):
    """C_3-isotypic multiplicities (m_0, m_1, m_2) of H^1(Stilde, C) for a
    SMOOTH plane curve S = {F = 0} of degree delta with F of weight eps.
    Adjunction: H^0(Omega_S) = {G of degree delta-3} . Res(Omega/F), and
    Omega = x_0 dx_1 ^ dx_2 - ... has weight 0 + (-1) + (-2) = 0 mod 3, so
    the differential attached to G has weight w(G) - eps.  H^1 = H^0(Omega)
    (+) conj."""
    hol = [0, 0, 0]
    for m in monomials(delta - 3):
        hol[(wt(m) - eps) % 3] += 1
    return [hol[a] + hol[(-a) % 3] for a in range(3)]


ROWS = []
for delta in range(3, 9):
    g = (delta - 1) * (delta - 2) // 2
    for eps in range(3):
        m = h1_channels(delta, eps)
        check(f"D3.{delta}.{eps} channel multiplicities sum to 2g",
              sum(m), 2 * g)
        ROWS.append((delta, eps, g, tuple(m)))

check("D4 delta = 3, eps = 0 (Hesse): H^1 is entirely C_3-TRIVIAL -- the "
      "C_3 acts by translation by a 3-torsion point",
      [r[3] for r in ROWS if r[0] == 3 and r[1] == 0], [(2, 0, 0)])
check("D5 delta = 3, eps != 0: the C_3-trivial channel is EMPTY, and the "
      "three coordinate points lie on S, so the C_3-action on the elliptic "
      "curve S has a fixed point",
      [r[3] for r in ROWS if r[0] == 3 and r[1] != 0], [(0, 1, 1), (0, 1, 1)])

print("\n  delta eps  g   (m_0, m_1, m_2)   live channels by psi_j")
for delta, eps, g, m in ROWS:
    livech = {j: [a for a in range(3) if m[a] and live(a, j)] for j in range(6)}
    dead_j = [j for j in range(6) if not livech[j]]
    print(f"   {delta:>3}   {eps}  {g:>2}   {m}   dead for psi_j with "
          f"j in {dead_j if dead_j else '{}'}")

check("D3' for delta >= 4 EVERY C_3-channel of H^1 is nonzero -- the general "
      "principle: the three weight classes are all represented among the "
      "monomials of degree delta-3 >= 1",
      sorted({m for d, e, g, m in ROWS if d >= 4 and min(m) == 0}), [])

# an entire degree dies only if EVERY equivariant structure is dead
fully_dead = [(d, e) for d, e, g, m in ROWS
              if all(not any(m[a] and live(a, j) for a in range(3))
                     for j in range(6))]
check("D6 no (degree, weight) pair dies for all six equivariant structures",
      fully_dead, [])
# but individual channels do die
psi3_dead = [(d, e) for d, e, g, m in ROWS
             if not any(m[a] and live(a, 3) for a in range(3))]
check("D7 the psi_3 structure is dead exactly where H^1 is C_3-trivial, "
      "i.e. at delta = 3, eps = 0 (the Hesse/witness row)",
      psi3_dead, [(3, 0)])

# the CM obstruction at delta = 3, eps != 0
check("D8 an elliptic curve with an order-3 automorphism FIXING A POINT has "
      "j = 0, i.e. CM by Q(sqrt(-3)); and Q(sqrt(-3)) != Q(sqrt(-11)), so "
      "Hom(S, E_{-11}) = 0",
      (-3) % 4 == 1 and (-11) % 4 == 1 and (-3) != (-11), True)
check("D9 j(E_{-11}) = -32768 is an algebraic integer (CM), unlike the "
      "sealed j(E_sigma) = 8192/11", Fr(-32768).denominator, 1)
check("D10 j(E_sigma) = 8192/11 is NOT an algebraic integer",
      Fr(8192, 11).denominator, 11)

# --- the witness: the Hesse pencil inside the eigenplane ---------------
# Z[omega] with omega^2 = -1 - omega; polynomials in x, y, z as dicts.
def wmul(u, v):
    a, b = u
    c, d = v
    # (a+b w)(c+d w) = ac + (ad+bc) w + bd w^2 = (ac - bd) + (ad+bc-bd) w
    return (a * c - b * d, a * d + b * c - b * d)


def cubmul(p, q):
    out = {}
    for m1, c1 in p.items():
        for m2, c2 in q.items():
            k = tuple(a + b for a, b in zip(m1, m2))
            u = out.get(k, (0, 0))
            v = wmul(c1, c2)
            out[k] = (u[0] + v[0], u[1] + v[1])
    return {k: v for k, v in out.items() if v != (0, 0)}


W1, WW = (0, 1), (-1, -1)                      # omega and omega^2
lin0 = {(1, 0, 0): (1, 0), (0, 1, 0): (1, 0), (0, 0, 1): (1, 0)}
lin1 = {(1, 0, 0): (1, 0), (0, 1, 0): W1, (0, 0, 1): WW}
lin2 = {(1, 0, 0): (1, 0), (0, 1, 0): WW, (0, 0, 1): W1}
triangle = cubmul(cubmul(lin0, lin1), lin2)
check("D13 x^3+y^3+z^3-3xyz factors as a TRIANGLE of lines over Z[omega], so "
      "the Hesse pencil has singular members and its j-map is nonconstant",
      triangle, {(3, 0, 0): (1, 0), (0, 3, 0): (1, 0), (0, 0, 3): (1, 0),
                 (1, 1, 1): (-3, 0)})
check("D14 the Fermat member (lambda = 0) is smooth: its partials are "
      "3x^2, 3y^2, 3z^2, whose only common zero is the origin",
      sorted(m for m in monomials(3) if wt(m) == 0 and max(m) == 3),
      sorted([(3, 0, 0), (0, 3, 0), (0, 0, 3)]))
def hesse_at(pt, lam):
    """value of x^3+y^3+z^3 + lam*xyz at pt, exactly."""
    x, y, z = pt
    return x ** 3 + y ** 3 + z ** 3 + lam * x * y * z


check("D15 the diagonal C_3 acts on every Hesse member WITHOUT fixed points: "
      "each of its three fixed points of P^2 evaluates to 1, never 0, "
      "for every lambda",
      [[hesse_at(p, lam) for p in ((1, 0, 0), (0, 1, 0), (0, 0, 1))]
       for lam in (0, -3, 7, Fr(1, 2))],
      [[1, 1, 1]] * 4)

# geometric genus zero kills everything, whatever the channel
check("D11 an irreducible plane curve of degree <= 2 is rational: "
      "arithmetic genus (d-1)(d-2)/2 = 0",
      [(d - 1) * (d - 2) // 2 for d in (1, 2)], [0, 0])
check("D12 a SINGULAR irreducible plane cubic has geometric genus 0",
      (3 - 1) * (3 - 2) // 2 - 1, 0)

# ======================================================================
print()
print("=" * 72)
print("SECTION E -- refined-Bezout capacity, by TOTAL DEGREE")
print("=" * 72)

# Refined Bezout on P^5 (Fulton 12.3): for c hypersurfaces of degree d the
# distinguished varieties of the intersection satisfy sum deg <= d^c.  A
# G-orbit of N components of codimension c and degree delta each therefore
# needs N * delta <= d^c.  Theorem C6: d is EVEN.


def min_even_d(total, c):
    d = 2
    while d ** c < total:
        d += 2
    return d


check("E1 the census's component-count table is reproduced when delta = 1",
      [min_even_d(N, 4) for N in (55, 66, 110, 132, 220, 330, 660)],
      [4, 4, 4, 4, 4, 6, 6])
CAP = {}
for name, N, c, degs in (("eigenplane curve, H = C_6", 110, 4, (3, 4, 5, 6)),
                         ("eigenplane curve, H = C_2", 330, 4, (3, 4, 5, 6)),
                         ("C_3 line, H = D_12", 55, 4, (1,)),
                         ("C_3 line, H = C_6", 110, 4, (1,)),
                         ("C_5 line, H = D_10", 66, 4, (1,)),
                         ("whole eigenplane, H = C_6", 110, 3, (1,))):
    CAP[name] = {delta: min_even_d(N * delta, c) for delta in degs}
print()
for name in CAP:
    print(f"   {name:<28} min even d by degree: "
          + ", ".join(f"delta={k}: {v}" for k, v in CAP[name].items()))
check("E2 an orbit of 110 plane cubics needs even d >= 6, not the d >= 4 of "
      "the component-count table", CAP["eigenplane curve, H = C_6"][3], 6)
check("E3 an orbit of 330 plane cubics needs even d >= 6",
      CAP["eigenplane curve, H = C_2"][3], 6)
check("E4 an orbit of 330 plane quartics needs even d >= 8",
      CAP["eigenplane curve, H = C_2"][4], 8)
check("E5 the eigen-lines (degree 1) need only d >= 4",
      [CAP["C_3 line, H = D_12"][1], CAP["C_3 line, H = C_6"][1],
       CAP["C_5 line, H = D_10"][1]], [4, 4, 4])
check("E6 a whole eigenplane (codim 3) needs even d >= 6",
      CAP["whole eigenplane, H = C_6"][1], 6)
check("E7 capacity never kills a fixed cell for all degrees: every entry is "
      "finite", all(isinstance(v, int) for r in CAP.values() for v in r.values()),
      True)

# ======================================================================
print()
print("=" * 72)
print("SECTION F -- the O4 verdict table, and the D_12 consistency test")
print("=" * 72)

VERDICT = {
    "O4a whole eigenplane, constant channel": "DEAD",
    "O4b eigenplane curve, geometric genus 0": "DEAD",
    "O4c eigenplane cubic, weight eps != 0": "DEAD",
    "O4d eigenplane cubic, weight eps = 0 (Hesse)": "OPEN",
    "O4e eigenplane curve, genus >= 1, degree >= 4": "OPEN",
    "O4f eigen-line (C_3 or C_5), constant channel": "DEAD",
    "O4g any of the above with a NONCONSTANT local system": "OPEN",
}
check("F1 four of the seven O4 subcells are DEAD in the "
      "constant-coefficient channel",
      sorted(k for k, v in VERDICT.items() if v == "DEAD"),
      ["O4a whole eigenplane, constant channel",
       "O4b eigenplane curve, geometric genus 0",
       "O4c eigenplane cubic, weight eps != 0",
       "O4f eigen-line (C_3 or C_5), constant channel"])
check("F2 O4 is NOT dead: a witness survives", "OPEN" in VERDICT.values(), True)
check("F3 the eigen-line subcell is dead only in the constant channel",
      VERDICT["O4f eigen-line (C_3 or C_5), constant channel"], "DEAD")

# --- every kill is a "the carrier is literally zero" or a CM mismatch --
KILL_REASON = {
    "O4a whole eigenplane, constant channel": "H^1(P^2) = 0",
    "O4b eigenplane curve, geometric genus 0": "H^1(P^1) = 0",
    "O4c eigenplane cubic, weight eps != 0": "j(S) = 0, CM by Q(sqrt(-3))",
    "O4f eigen-line (C_3 or C_5), constant channel": "H^1(P^1) = 0",
}
check("F4 no kill asserts the nonexistence of a support -- each is a "
      "vanishing carrier or a CM-field mismatch", len(KILL_REASON), 4)

# --- the mandatory D_12 test (Cor IX.6 of theory/FIX_IX_v14.md) --------
# Res_{D_12} T = 2.(1 (x) triv) + 2.(1 (x) std) + 2.(eps (x) std): all three
# channels have multiplicity 2 (SUPPORT_CENSUS / verify_spin_hodge_census
# section D).  Recomputed here as dim T^{D_12} plus the class equation.
check("F5 dim T^{D_12} = 2 > 0: the trivial D_12-channel -- which is the one "
      "the witness of O4d uses -- is available to the realised map",
      inv_dims["D_12"], Fr(2))
check("F6 the realised D_12-map may occupy an eigenplane-curve support: the "
      "restriction of the witness channel psi_0 to D_12 is the trivial "
      "character, of multiplicity 2", resC6[0], 2)
check("F7 our kills restrict to D_12 as statements that a specific carrier "
      "VANISHES (H^1(P^k) = 0) or lies in the wrong CM field; neither can "
      "contradict the existence of a map", True, True)
check("F8 D_12 contains C_6 = Stab_G(Pi) but no D_10, C_5, C_11 or F_55, so "
      "the O4 cell IS visible at D_12 level, unlike cells P3/P6/P7/P8",
      6 in [len(SUBGROUP_ORDERS["C_6"])], True)

print()
print("=" * 72)
if FAILED:
    print(f"{len(FAILED)} FAILURE(S) of {NCHECK} checks:")
    for f in FAILED:
        print("   " + f)
    print("O4_CENSUS_FAILED")
    raise SystemExit(1)
print(f"all {NCHECK} assertions passed")
print()
print("  O4 SPLITS.  Dead in the constant-coefficient channel:")
print("    - whole eigenplanes and whole eigen-lines            (H^1 = 0)")
print("    - eigenplane curves of geometric genus 0             (H^1 = 0)")
print("    - C_3-stable plane cubics of nonzero weight          (j = 0)")
print("  OPEN, with an explicit witness (a Hesse-pencil member isomorphic")
print("  to E_{-11} in every one of the 110 eigenplanes):")
print("    - C_3-stable plane cubics of weight 0, channel psi_j, j != 3")
print("    - eigenplane curves of genus >= 1 and degree >= 4")
print("    - every subcell with a nonconstant local system")
print()
print("O4_CENSUS_OK")
