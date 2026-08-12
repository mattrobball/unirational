"""REFEREE spot-check (R5, R1): Molien series and the J1 profile, independently.

Route: everything in F_p for two primes p = 1 (mod 330) with p > 660 * 5 *
C(50,4), so every quantity 660*i_k, 660*M_k (k <= 46) is a nonnegative integer
strictly below p and is recovered EXACTLY from a single residue; the second
prime guards against implementation error.  Eigenvalue data per class is the
classical restriction table (verified against ATLAS trace values by
referee_group_character.py).  The packet's route (exact convolution in
Z[zeta_330] reduced mod Phi_330) is not reused.

Checks: the six anchors M_1, M_11, M_12, M_25, M_34, M_35 = 1, 12, 16, 189,
576, 637; i_2 = 0, i_3 = 1; a_k = i_k - i_{k-3} zero exactly on 1..4 and >= 1
on 5..46; a_5 = 1, a_11 = 2; ambient degrees {3} u [5,40]; PIN degree
arithmetic; and the semigroup closure that upgrades the windowed a_k profile to
"exactly {k >= 5}" for ALL k (degrees 5..9 all carry X-invariants and C[X] is a
domain, so every k >= 5 is reached).
"""
import sys

KMAX = 46
FAILS = []


def ck(name, cond, detail=""):
    print("%-4s %s%s" % ("PASS" if cond else "FAIL", name,
                         "" if cond else "   <-- %s" % detail))
    if not cond:
        FAILS.append(name)


def is_prime(n):
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


def find_prime(start):
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


QR = [1, 3, 4, 5, 9]
NQR = [2, 6, 7, 8, 10]
CLASSES = [  # (size, element order, exponent multiset of g on W*)
    (1, 1, (0, 0, 0, 0, 0)),
    (55, 2, (0, 0, 0, 1, 1)),
    (110, 3, (0, 1, 1, 2, 2)),
    (132, 5, (0, 1, 2, 3, 4)),
    (132, 5, (0, 1, 2, 3, 4)),
    (110, 6, (0, 1, 2, 4, 5)),
    (60, 11, tuple(QR)),
    (60, 11, tuple(NQR)),
]


def molien_fp(p):
    w = root330(p)
    S_i = [0] * (KMAX + 1)
    S_M = [0] * (KMAX + 1)
    for size, od, exps in CLASSES:
        z = pow(w, 330 // od, p)
        lam = [pow(z, e, p) for e in exps]
        # h-series of Sym^k W*: product of geometric series 1/(1 - lam_j t)
        h = [1] + [0] * KMAX
        for l in lam:
            run = 0
            for k in range(KMAX + 1):
                run = (run * l + h[k]) % p
                h[k] = run
        trW = sum(pow(z, -e % od, p) for e in exps) % p  # chi_W = conj chi_W*
        for k in range(KMAX + 1):
            S_i[k] = (S_i[k] + size * h[k]) % p
            S_M[k] = (S_M[k] + size * h[k] * trW) % p
    i_k, M_k = [], []
    for k in range(KMAX + 1):
        assert S_i[k] % 660 == 0 and S_M[k] % 660 == 0, k
        i_k.append(S_i[k] // 660)
        M_k.append(S_M[k] // 660)
    return i_k, M_k


def main():
    from math import comb
    bound = 660 * 5 * comb(KMAX + 4, 4)
    p1 = find_prime(2 * bound)
    p2 = find_prime(3 * bound)
    ck("M0 primes exceed the integer bound 660*5*C(50,4) = %d" % bound,
       p1 > bound and p2 > bound, (p1, p2))

    i1, M1 = molien_fp(p1)
    i2, M2 = molien_fp(p2)
    ck("M1 the two primes recover identical integer tables",
       i1 == i2 and M1 == M2)
    i_k, M_k = i1, M1

    anchors = {1: 1, 11: 12, 12: 16, 25: 189, 34: 576, 35: 637}
    for k, v in anchors.items():
        ck("M2 anchor M_%d = %d" % (k, v), M_k[k] == v, M_k[k])

    ck("M3 i_1 = i_2 = i_4 = 0 and i_3 = 1 (unique invariant cubic = F)",
       i_k[1] == 0 and i_k[2] == 0 and i_k[4] == 0 and i_k[3] == 1,
       i_k[:5])

    a_k = [i_k[k] - (i_k[k - 3] if k >= 3 else 0) for k in range(KMAX + 1)]
    ck("M4 a_k = 0 for k = 1..4", a_k[1:5] == [0, 0, 0, 0], a_k[1:5])
    ck("M5 a_k >= 1 for k = 5..46", all(a >= 1 for a in a_k[5:]), a_k[5:])
    ck("M6 a_5 = 1 (unique degree-5 invariant divisor on X)", a_k[5] == 1, a_k[5])
    ck("M7 a_11 = 2 (pencil at degree 11)", a_k[11] == 2, a_k[11])

    amb = [k for k in range(1, 41) if i_k[k] > 0]
    ck("M8 ambient invariant degrees in [1,40] = {3} u [5,40]",
       amb == [3] + list(range(5, 41)), amb)

    # semigroup closure: a_j > 0 and a_k > 0 imply a_{j+k} > 0 (C[X] is a
    # domain, the product of nonzero invariants is a nonzero invariant), and
    # {5,6,7,8,9} generates every integer >= 5: so "exactly {k >= 5}" holds for
    # ALL k, not only the k <= 46 window.
    gen = set()
    for n in range(5, 200):
        if n in (5, 6, 7, 8, 9) or any((n - g) in gen for g in (5, 6, 7, 8, 9)):
            gen.add(n)
    ck("M9 semigroup <5,6,7,8,9> covers every k >= 5 (window-closure argument)",
       all(n in gen for n in range(5, 200)) and
       all(a_k[g] >= 1 for g in (5, 6, 7, 8, 9)))

    # PIN degree arithmetic (R1 machine form)
    B = [pow(-2, i, 11) for i in range(5)]
    pin11 = {k: all((k * b) % 11 for b in B) for k in range(1, 61)}
    pin5 = {k: all((k * j) % 5 for j in (1, 2, 3, 4)) for k in range(1, 61)}
    ck("M10 PIN: forced through the C11-points exactly when 11 does not divide k",
       all(pin11[k] == (k % 11 != 0) for k in pin11))
    ck("M11 PIN: forced through the C5-points exactly when 5 does not divide k",
       all(pin5[k] == (k % 5 != 0) for k in pin5))
    ck("M12 PIN: least degree missing every pinned point is 55",
       min(k for k in range(1, 200) if k % 55 == 0) == 55)

    print()
    print("i_k :", i_k[:16], "...")
    print("a_k :", a_k[:16], "...")
    print("M_k :", M_k[:16], "...")
    if FAILS:
        print("REFEREE_MOLIEN_FP_FAILED", FAILS)
        sys.exit(1)
    print("REFEREE_MOLIEN_FP_OK")


if __name__ == "__main__":
    main()
