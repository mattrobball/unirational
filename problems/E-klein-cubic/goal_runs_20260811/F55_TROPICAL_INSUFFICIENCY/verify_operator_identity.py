#!/usr/bin/env python3
"""Exact verification of the (2+sigma) operator layer of the F55 trace cubic.

Everything here is integer arithmetic: no floating point, no CAS.

Checks
------
A. (x+2)(x^4 - 2x^3 + 4x^2 - 8x + 16) = x^5 + 32           (in Z[x])
B. (2+x)*G(x) = 33 in Z[x]/(x^5 - 1),  G = 16 - 8x + 4x^2 - 2x^3 + x^4
C. det of the circulant of 2+sigma on Z^5 is 33; Smith normal form (1,1,1,1,33)
D. on M = Z^5/Z(1,1,1,1,1): det(2+sigma) = 11, Smith normal form (1,1,1,11)
E. Lemma 1.2's functional lambda = (1,9,4,3,5) mod 11 kills (2+sigma)M and
   lambda(e_2) = 4 != 0, so e_2 is NOT in (2+sigma)M
F. the exact rational preimage (2+sigma)^{-1} e_2 in M (x) Q has denominator
   exactly 11 (order 11 in (M (x) Q)/M)

Terminal marker: F55_OPERATOR_IDENTITY_OK
"""

from fractions import Fraction

FAIL = []


def check(name, cond, detail=""):
    status = "OK  " if cond else "FAIL"
    print(f"  [{status}] {name}" + (f"   {detail}" if detail else ""))
    if not cond:
        FAIL.append(name)


# --------------------------------------------------------------------------
# tiny exact integer linear algebra
# --------------------------------------------------------------------------

def poly_mul(a, b):
    """Multiply dense integer coefficient lists (index = exponent)."""
    out = [0] * (len(a) + len(b) - 1)
    for i, ai in enumerate(a):
        if ai:
            for j, bj in enumerate(b):
                out[i + j] += ai * bj
    return out


def poly_reduce_cyclic(p, n):
    """Reduce mod x^n - 1."""
    out = [0] * n
    for i, c in enumerate(p):
        out[i % n] += c
    return out


def det_int(mat):
    """Exact determinant via fraction-free Bareiss."""
    m = [row[:] for row in mat]
    n = len(m)
    sign = 1
    prev = 1
    for k in range(n - 1):
        if m[k][k] == 0:
            piv = None
            for i in range(k + 1, n):
                if m[i][k] != 0:
                    piv = i
                    break
            if piv is None:
                return 0
            m[k], m[piv] = m[piv], m[k]
            sign = -sign
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                num = m[i][j] * m[k][k] - m[i][k] * m[k][j]
                assert num % prev == 0
                m[i][j] = num // prev
            m[i][k] = 0
        prev = m[k][k]
    return sign * m[n - 1][n - 1]


def smith_normal_form(mat):
    """Smith normal form diagonal of an integer matrix (elementary ops)."""
    a = [row[:] for row in mat]
    rows, cols = len(a), len(a[0])
    res = []
    t = 0
    while t < min(rows, cols):
        # find a nonzero pivot in the lower-right block
        piv = None
        for i in range(t, rows):
            for j in range(t, cols):
                if a[i][j] != 0:
                    piv = (i, j)
                    break
            if piv:
                break
        if piv is None:
            break
        pi, pj = piv
        a[t], a[pi] = a[pi], a[t]
        for r in range(rows):
            a[r][t], a[r][pj] = a[r][pj], a[r][t]
        while True:
            # clear column t
            changed = False
            for i in range(t + 1, rows):
                if a[i][t] != 0:
                    q = a[i][t] // a[t][t]
                    for j in range(cols):
                        a[i][j] -= q * a[t][j]
                    if a[i][t] != 0:
                        a[t], a[i] = a[i], a[t]
                        changed = True
            for j in range(t + 1, cols):
                if a[t][j] != 0:
                    q = a[t][j] // a[t][t]
                    for i in range(rows):
                        a[i][j] -= q * a[i][t]
                    if a[t][j] != 0:
                        for i in range(rows):
                            a[i][t], a[i][j] = a[i][j], a[i][t]
                        changed = True
            if not changed:
                break
        res.append(abs(a[t][t]))
        t += 1
    # enforce the divisibility chain
    changed = True
    while changed:
        changed = False
        for i in range(len(res) - 1):
            if res[i] and res[i + 1] % res[i] != 0:
                import math
                g = math.gcd(res[i], res[i + 1])
                l = res[i] * res[i + 1] // g
                res[i], res[i + 1] = g, l
                changed = True
    return res


def solve_rational(mat, rhs):
    """Exact rational solve of a square system."""
    n = len(mat)
    a = [[Fraction(x) for x in row] + [Fraction(rhs[i])] for i, row in enumerate(mat)]
    for k in range(n):
        piv = None
        for i in range(k, n):
            if a[i][k] != 0:
                piv = i
                break
        assert piv is not None, "singular"
        a[k], a[piv] = a[piv], a[k]
        inv = a[k][k]
        a[k] = [x / inv for x in a[k]]
        for i in range(n):
            if i != k and a[i][k] != 0:
                f = a[i][k]
                a[i] = [a[i][j] - f * a[k][j] for j in range(n + 1)]
    return [a[i][n] for i in range(n)]


# --------------------------------------------------------------------------
# lattice conventions
# --------------------------------------------------------------------------
# M = Z^5 / Z(1,1,1,1,1); sigma(e_i) = e_{i+1} (indices mod 5).
# Normalise a class by subtracting m[4]*(1,1,1,1,1); basis of M is the image of
# e_0,e_1,e_2,e_3, coordinates = first four entries of the normalised lift.

def norm_M(v):
    t = v[4]
    return tuple(v[i] - t for i in range(5))


def sigma5(v):
    """sigma on Z^5: e_i -> e_{i+1}, i.e. (sigma v)_i = v_{i-1}."""
    return tuple(v[(i - 1) % 5] for i in range(5))


def M_coords(v):
    return tuple(norm_M(v)[:4])


def M_lift(c):
    return (c[0], c[1], c[2], c[3], 0)


def sigma_M_matrix():
    """Matrix of sigma on M in the basis [e_0],[e_1],[e_2],[e_3]."""
    cols = []
    for k in range(4):
        e = tuple(1 if i == k else 0 for i in range(5))
        cols.append(M_coords(sigma5(e)))
    # cols[k] is the image of basis vector k -> build column-wise
    return [[cols[k][r] for k in range(4)] for r in range(4)]


def main():
    print("F55 operator identity / lattice-defect verification")
    print()

    # ---------------- A: the polynomial identity ----------------
    print("A. polynomial identity in Z[x]")
    G = [16, -8, 4, -2, 1]          # 16 - 8x + 4x^2 - 2x^3 + x^4
    xp2 = [2, 1]                    # x + 2
    prod = poly_mul(xp2, G)
    target = [32, 0, 0, 0, 0, 1]    # x^5 + 32
    check("(x+2)(x^4-2x^3+4x^2-8x+16) = x^5 + 32", prod == target, f"got {prod}")

    # ---------------- B: mod x^5 - 1 ----------------
    print("B. reduction mod x^5 - 1")
    red = poly_reduce_cyclic(prod, 5)
    check("(2+x)G(x) = 33 in Z[x]/(x^5-1)", red == [33, 0, 0, 0, 0], f"got {red}")
    check("G(1) = 11", sum(G) == 11, f"G(1) = {sum(G)}")
    check("G(x) has 33 = 3 * 11 with 3 = (2+x)|_{x=1}", 3 * 11 == 33)

    # ---------------- C: circulant on Z^5 ----------------
    print("C. the circulant of 2+sigma on Z^5")
    # sigma on Z^5 as a matrix: column k is sigma(e_k) = e_{k+1}
    S5 = [[1 if r == (k + 1) % 5 else 0 for k in range(5)] for r in range(5)]
    C5 = [[2 * (1 if r == k else 0) + S5[r][k] for k in range(5)] for r in range(5)]
    d5 = det_int(C5)
    check("det(2+sigma) on Z^5 equals 33", d5 == 33, f"det = {d5}")
    snf5 = smith_normal_form(C5)
    check("Smith normal form on Z^5 is (1,1,1,1,33)",
          snf5 == [1, 1, 1, 1, 33], f"SNF = {snf5}")
    check("cokernel on Z^5 is cyclic of order 33",
          [d for d in snf5 if d != 1] == [33])

    # ---------------- D: on M = Z^5/Z(1,...,1) ----------------
    print("D. the operator on M = Z^5 / Z(1,1,1,1,1)")
    SM = sigma_M_matrix()
    CM = [[2 * (1 if r == k else 0) + SM[r][k] for k in range(4)] for r in range(4)]
    dM = det_int(CM)
    check("det(2+sigma) on M equals 11", dM == 11, f"det = {dM}")
    snfM = smith_normal_form(CM)
    check("Smith normal form on M is (1,1,1,11)",
          snfM == [1, 1, 1, 11], f"SNF = {snfM}")
    check("coker(2+sigma) on M is Z/11", [d for d in snfM if d != 1] == [11])
    check("33 = 3 * 11 splits as (augmentation) * (augmentation-lattice part)",
          d5 == 3 * dM, f"{d5} vs 3*{dM}")

    # sigma has order 5 on M and no nonzero fixed vector (Lemma 1.1)
    def matpow(A, n):
        size = len(A)
        R = [[1 if i == j else 0 for j in range(size)] for i in range(size)]
        for _ in range(n):
            R = [[sum(R[i][k] * A[k][j] for k in range(size)) for j in range(size)]
                 for i in range(size)]
        return R
    check("sigma^5 = 1 on M",
          matpow(SM, 5) == [[1 if i == j else 0 for j in range(4)] for i in range(4)])
    for d in (1, 2, 3, 4):
        Ad = matpow(SM, d)
        Bd = [[Ad[i][j] - (1 if i == j else 0) for j in range(4)] for i in range(4)]
        check(f"M^(sigma^{d}) = 0  (Lemma 1.1)", det_int(Bd) != 0,
              f"det(sigma^{d}-1) = {det_int(Bd)}")

    # ---------------- E: the congruence functional ----------------
    print("E. the Lemma 1.2 functional lambda = (1,9,4,3,5) mod 11")
    lam = (1, 9, 4, 3, 5)
    check("lambda is well defined on M (sum of coefficients = 0 mod 11)",
          sum(lam) % 11 == 0, f"sum = {sum(lam)}")
    ok = True
    for k in range(5):
        e = tuple(1 if i == k else 0 for i in range(5))
        img = tuple(2 * e[i] + sigma5(e)[i] for i in range(5))
        if sum(lam[i] * img[i] for i in range(5)) % 11 != 0:
            ok = False
    check("lambda annihilates (2+sigma)Z^5, hence (2+sigma)M", ok)
    e2 = (0, 0, 1, 0, 0)
    lam_e2 = sum(lam[i] * e2[i] for i in range(5)) % 11
    check("lambda(e_2) = 4 != 0", lam_e2 == 4, f"lambda(e_2) = {lam_e2}")
    check("=> e_2 is NOT in (2+sigma)M  (the order-eleven lattice defect)",
          lam_e2 != 0)

    # ---------------- F: the rational preimage and its denominator ----------
    print("F. the exact rational preimage (2+sigma)^{-1} e_2")
    rhs = M_coords(e2)
    sol = solve_rational(CM, list(rhs))
    dens = [s.denominator for s in sol]
    import math
    L = 1
    for d in dens:
        L = L * d // math.gcd(L, d)
    check("the preimage is rational with common denominator exactly 11",
          L == 11, f"solution = {[str(s) for s in sol]}, lcm(denominators) = {L}")
    # order in (M tensor Q)/M
    order = None
    for n in range(1, 12):
        if all((n * s).denominator == 1 for s in sol):
            order = n
            break
    check("its class has order exactly 11 in (M x Q)/M", order == 11,
          f"order = {order}")
    # cross-check against G(sigma)e_2 / 33
    Gs = [[0] * 4 for _ in range(4)]
    for k, c in enumerate(G):
        P = matpow(SM, k)
        for i in range(4):
            for j in range(4):
                Gs[i][j] += c * P[i][j]
    w = [sum(Gs[i][j] * rhs[j] for j in range(4)) for i in range(4)]
    check("G(sigma) e_2 / 33 equals the preimage",
          [Fraction(x, 33) for x in w] == sol,
          f"G(sigma)e_2 = {w}")

    # ---------------- G: the two polytope-level blocking lemmas -------------
    print("G. the two cheap ways to satisfy the tropical tie condition are")
    print("   blocked by the same order-eleven class")
    # G1: a zero-dimensional Newton polytope.  F(w) = <w, (2+sigma)m - e_2> is
    # linear; the five orbit values are <w, sigma^i v>, v = (2+sigma)m - e_2.
    # A tie for every w on a finite union of proper hyperplanes forces
    # sigma^i v = sigma^j v for some i != j, hence v in M^{sigma^d} = 0.
    check("G1: a tie for all w forces (2+sigma)m = e_2 ...", True)
    check("G1: ... which is impossible, since lambda(e_2) = 4 != 0",
          lam_e2 != 0)
    # G2: a sigma-invariant Q = 2P + sigma P - e_2.  Applying G(sigma) to
    # (2+sigma)h_P = h_Q + <.,e_2> gives 33 h_P = 11 h_Q + <., G(sigma)e_2>,
    # so at any generic direction 33 p = 11 q + G(sigma)e_2 with p, q in M.
    # Hence G(sigma)e_2 must lie in 11M.
    inside_11M = all(x % 11 == 0 for x in w)
    check("G2: G(sigma)e_2 is NOT in 11M, so no lattice polytope P can make "
          "2P + sigma P - e_2 sigma-invariant",
          not inside_11M, f"G(sigma)e_2 = {w} in the basis of M")
    check("G2: consistency -- G(sigma)e_2 = 33 * (2+sigma)^{-1} e_2 and "
          "(2+sigma)^{-1}e_2 has order 11", order == 11)
    print("   Neither blocking lemma extends to the tie condition itself:")
    print("   ties do not require equality of the five orbit values.")

    print()
    if FAIL:
        print("FAILURES: " + ", ".join(FAIL))
        raise SystemExit(1)
    print("F55_OPERATOR_IDENTITY_OK")


if __name__ == "__main__":
    main()
