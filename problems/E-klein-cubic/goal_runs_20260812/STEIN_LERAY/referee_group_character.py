"""REFEREE spot-check (R5): independent rebuild of PSL(2,11) and the 5-dim character.

Independent of the packet's route: the group is built from SL(2,11) matrices
modulo +-I (the packet used permutations of P^1(F_11)); character arithmetic is
done in F_p with a primitive 330-th root of unity (the packet used Z[x]/(x^N-1)
reduced mod Phi_N).  Ground truth for the restriction table is the classical
character table of PSL(2,11): the 5-dimensional irreducible has values
(5, 1, -1, 0, 0, 1, a, abar) with a = (-1+sqrt(-11))/2, i.e. a^2 + a + 3 = 0.

Also re-runs the packet's uniqueness search with an independent implementation.
Mod-p solutions form a SUPERSET of exact solutions, so a mod-p count of 1 at
two independent primes, together with existence (the Klein representation is a
solution), proves exact uniqueness.
"""
import sys
from itertools import combinations_with_replacement
from math import gcd

P = 11
FAILS = []


def ck(name, cond, detail=""):
    print("%-4s %s%s" % ("PASS" if cond else "FAIL", name,
                         "" if cond else "   <-- %s" % detail))
    if not cond:
        FAILS.append(name)


# ---------------------------------------------------------- group via SL(2,11)
def canon_pm(m):
    """Canonical representative of {m, -m} in PSL(2,11)."""
    a, b, c, d = m
    neg = (11 - a, 11 - b, 11 - c, 11 - d) if False else tuple((-x) % 11 for x in m)
    return min(m, neg)


def mmul(m, n):
    a, b, c, d = m
    e, f, g, h = n
    return ((a * e + b * g) % 11, (a * f + b * h) % 11,
            (c * e + d * g) % 11, (c * f + d * h) % 11)


def minv(m):
    a, b, c, d = m          # det = 1
    return (d % 11, (-b) % 11, (-c) % 11, a % 11)


def build_psl211():
    els = set()
    for a in range(11):
        for b in range(11):
            for c in range(11):
                for d in range(11):
                    if (a * d - b * c) % 11 == 1:
                        els.add(canon_pm((a, b, c, d)))
    return sorted(els)


def elt_order(m):
    e = (1, 0, 0, 1)
    x, n = m, 1
    while canon_pm(x) != e:
        x = mmul(x, m)
        n += 1
    return n


def main():
    els = build_psl211()
    ck("G1 |PSL(2,11)| = 660 (matrix build)", len(els) == 660, len(els))

    idx = {g: i for i, g in enumerate(els)}
    orders = [elt_order(g) for g in els]

    cls = [-1] * 660
    classes = []
    for i, g in enumerate(els):
        if cls[i] != -1:
            continue
        members = set()
        for h in els:
            members.add(idx[canon_pm(mmul(mmul(h, g), minv(h)))])
        c = len(classes)
        for m in members:
            cls[m] = c
        classes.append(sorted(members))
    data = sorted((orders[c[0]], len(c)) for c in classes)
    ck("G2 class (order, size) data",
       data == [(1, 1), (2, 55), (3, 110), (5, 132), (5, 132),
                (6, 110), (11, 60), (11, 60)], data)

    # power map: the two order-11 classes are swapped by squaring, ditto order 5
    def cpow(ci, e):
        g = els[classes[ci][0]]
        x = (1, 0, 0, 1)
        for _ in range(e):
            x = mmul(x, g)
        return cls[idx[canon_pm(x)]]
    c11 = [i for i, c in enumerate(classes) if orders[c[0]] == 11]
    c5 = [i for i, c in enumerate(classes) if orders[c[0]] == 5]
    ck("G3 squaring swaps the two order-11 classes",
       cpow(c11[0], 2) == c11[1] and cpow(c11[1], 2) == c11[0])
    ck("G4 squaring swaps the two order-5 classes",
       cpow(c5[0], 2) == c5[1] and cpow(c5[1], 2) == c5[0])

    # ------------------------------------------- the C11 weight datum, re-derived
    b = [pow(-2, i, P) for i in range(5)]
    ck("G5 2*b_i + b_{i+1} = 0 (mod 11) for all i (F-invariance)",
       all((2 * b[i] + b[(i + 1) % 5]) % P == 0 for i in range(5)))
    QR = sorted({(x * x) % P for x in range(1, P)})
    ck("G6 b = (1,9,4,3,5), the quadratic residues mod 11",
       b == [1, 9, 4, 3, 5] and sorted(b) == QR)
    NQR = sorted(set(range(1, P)) - set(QR))

    # ---------------------------------------------------- F_p character engine
    def is_prime(n):
        if n < 2:
            return False
        for q in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37):
            if n % q == 0:
                return n == q
        d, s = n - 1, 0
        while d % 2 == 0:
            d //= 2
            s += 1
        for a in (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37):
            x = pow(a, d, n)
            if x in (1, n - 1):
                continue
            for _ in range(s - 1):
                x = x * x % n
                if x == n - 1:
                    break
            else:
                return False
        return True

    def find_prime_1mod330(start):
        p = start + (330 - start % 330) + 1
        while not is_prime(p):
            p += 330
        return p

    def root330(p):
        for g in range(2, 500):
            w = pow(g, (p - 1) // 330, p)
            if all(pow(w, 330 // q, p) != 1 for q in (2, 3, 5, 11)):
                return w
        raise RuntimeError

    # class list in a fixed order with (size, order); exponent multisets to be
    # assigned.  Ground truth (ATLAS): trace values (5,1,-1,0,0,1,a,abar).
    CL = [("1", 1, 1), ("2", 55, 2), ("3", 110, 3), ("5a", 132, 5),
          ("5b", 132, 5), ("6", 110, 6), ("11a", 60, 11), ("11b", 60, 11)]
    TRUE = {"1": (0, 0, 0, 0, 0), "2": (0, 0, 0, 1, 1), "3": (0, 1, 1, 2, 2),
            "5a": (0, 1, 2, 3, 4), "5b": (0, 1, 2, 3, 4), "6": (0, 1, 2, 4, 5),
            "11a": tuple(QR), "11b": tuple(NQR)}

    for p in (find_prime_1mod330(2 * 10 ** 9), find_prime_1mod330(3 * 10 ** 9)):
        w = root330(p)

        def zeta(n):
            return pow(w, 330 // n, p)

        def tr(S, n):        # sum of zeta_n^e, e in S
            z = zeta(n)
            return sum(pow(z, e, p) for e in S) % p

        # ATLAS check: traces
        z11 = zeta(11)
        aQR = sum(pow(z11, r, p) for r in QR) % p
        ck("G7 ATLAS@p=%d: sum_QR zeta^r satisfies a^2+a+3=0" % p,
           (aQR * aQR + aQR + 3) % p == 0)
        got = [tr(TRUE[nm], od) for nm, sz, od in CL]
        ck("G8 ATLAS@p=%d: traces (5,1,-1,0,0,1,a,abar)" % p,
           got[:6] == [5 % p, 1, p - 1, 0, 0, 1] and
           got[6] == aQR and got[7] == (p - 1 - aQR) % p)

        # orthogonality of the true character
        def s1s2(assign):
            s1 = s2 = 0
            for nm, sz, od in CL:
                z = zeta(od)
                v = sum(pow(z, e, p) for e in assign[nm]) % p
                vb = sum(pow(z, -e % od, p) for e in assign[nm]) % p
                s1 = (s1 + sz * v) % p
                s2 = (s2 + sz * v * vb) % p
            return s1, s2
        s1, s2 = s1s2(TRUE)
        ck("G9 @p=%d: <chi,1> = 0 and <chi,chi> = 1 for the derived table" % p,
           s1 == 0 and s2 == 660 % p)

        # -------- independent uniqueness re-search (mod-p superset argument)
        def cand(m):
            out = []
            for S in combinations_with_replacement(range(m), 5):
                if sum(S) % m:
                    continue                      # det = 1
                g = 0
                for e in S:
                    g = gcd(g, e)
                if gcd(g, m) != 1:
                    continue                      # exact order m
                out.append(S)
            return out

        def power(S, n, e):
            d = gcd(n, e)
            return tuple(sorted(((x * e) // d) % (n // d) for x in S))

        sols = []
        for S5 in cand(5):
            T5 = power(S5, 5, 2)
            for S6 in cand(6):
                S3, S2c = power(S6, 6, 2), power(S6, 6, 3)
                if gcd(gcd(*S3) if any(S3) else 3, 3) != 1:
                    continue                      # g^2 must have exact order 3
                if all(e == 0 for e in S2c):
                    continue                      # g^3 must have exact order 2
                assign = {"1": (0,) * 5, "2": S2c, "3": S3, "5a": S5,
                          "5b": T5, "6": S6, "11a": tuple(QR), "11b": tuple(NQR)}
                a1, a2 = s1s2(assign)
                if a1 == 0 and a2 == 660 % p:
                    sols.append(assign)
        ck("G10 @p=%d: uniqueness search finds exactly 1 completion" % p,
           len(sols) == 1, len(sols))
        if len(sols) == 1:
            ck("G11 @p=%d: the unique completion is the derived table" % p,
               all(tuple(sorted(sols[0][nm])) == tuple(sorted(TRUE[nm]))
                   for nm, _, _ in CL))

    print()
    if FAILS:
        print("REFEREE_GROUP_CHARACTER_FAILED", FAILS)
        sys.exit(1)
    print("REFEREE_GROUP_CHARACTER_OK")


if __name__ == "__main__":
    main()
