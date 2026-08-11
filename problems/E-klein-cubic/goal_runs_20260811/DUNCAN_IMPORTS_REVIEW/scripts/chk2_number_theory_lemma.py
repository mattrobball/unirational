"""CHECK 2 -- lem:number_theory (Duncan 4.4), the weight arithmetic that feeds
the weighted blowup of prop:cyclic_not_fabulous (4.5).

Statement: H finite cyclic, chi_1, chi_2 characters generating the dual group.
Then there are COPRIME integers a, b > 0 with chi_1^b chi_2^{-a} injective.

The tex's construction, replayed verbatim:
  identify dual(H) = Z/m, chi_1 = c_1, chi_2 = c_2;  hypothesis: c_1, c_2
  generate Z/m, i.e. gcd(c_1, c_2, m) = 1.
  choose s, t with s c_1 + t c_2 = 1 (mod m)   [possible since gcd(c1,c2,m)=1]
  a > 0 with a = -t (mod m)
  b > 0 with b = s (mod m) and b = 1 (mod q) for every prime q | a, q not | m
  claim: gcd(a,b) = 1 and b c_1 - a c_2 is prime to m (hence the character is
  injective).

This script runs that construction for EVERY (m, c_1, c_2) with m <= 120 and
gcd(c_1, c_2, m) = 1, and checks both conclusions.  It also checks the
*statement* independently by brute-force search over small coprime (a,b), and
records the standing-convention consequence that in the fabulous-pair setting a
cyclic H can never have prime order.
"""

import sys
from math import gcd
from sympy_free_crt import crt_solve, prime_factors   # local helper below


def ext_gcd(a, b):
    if b == 0:
        return (a, 1, 0)
    g, x, y = ext_gcd(b, a % b)
    return (g, y, x - (a // b) * y)


def bezout3(c1, c2, m):
    """s, t with s*c1 + t*c2 = 1 (mod m), assuming gcd(c1,c2,m)=1"""
    g1, x, y = ext_gcd(c1, c2)          # x*c1 + y*c2 = g1
    g2, u, v = ext_gcd(g1, m)           # u*g1 + v*m  = g2 = 1
    # u*(x*c1 + y*c2) + v*m = 1
    return (u * x) % m, (u * y) % m


def construct(m, c1, c2):
    """the tex's construction; returns (a, b)"""
    s, t = bezout3(c1, c2, m)
    assert (s * c1 + t * c2 - 1) % m == 0
    a = (-t) % m
    if a == 0:
        a = m
    # b = s (mod m), b = 1 (mod q) for primes q | a with q not | m
    mods = [(m, s % m)]
    for q in prime_factors(a):
        if m % q != 0:
            mods.append((q, 1 % q))
    b = crt_solve(mods)
    while b <= 0:
        b += 1  # (crt_solve already returns the least positive solution)
    return a, b


def main():
    fails = []
    tested = 0
    for m in range(1, 121):
        for c1 in range(m if m > 1 else 1):
            for c2 in range(m if m > 1 else 1):
                if gcd(gcd(c1, c2), m) != 1:
                    continue
                tested += 1
                a, b = construct(m, c1, c2)
                w = (b * c1 - a * c2) % m
                ok = (a > 0 and b > 0 and gcd(a, b) == 1 and gcd(w, m) == 1)
                if not ok:
                    fails.append((m, c1, c2, a, b, w))
    print(f"(m, c1, c2) triples tested with gcd(c1,c2,m)=1, m <= 120: {tested}")
    print(f"failures of the tex's construction: {len(fails)}")
    for f in fails[:20]:
        print("  FAIL", f)

    # independent brute-force confirmation of the STATEMENT for small m
    bf_fail = []
    for m in range(1, 61):
        for c1 in range(m if m > 1 else 1):
            for c2 in range(m if m > 1 else 1):
                if gcd(gcd(c1, c2), m) != 1:
                    continue
                found = None
                for a in range(1, 4 * m + 2):
                    for b in range(1, 4 * m + 2):
                        if gcd(a, b) == 1 and gcd((b * c1 - a * c2) % m, m) == 1:
                            found = (a, b)
                            break
                    if found:
                        break
                if found is None:
                    bf_fail.append((m, c1, c2))
    print(f"brute-force existence check (m <= 60): missing witnesses = {len(bf_fail)}")

    # the tex's own example: H = Z/6 with weights chi_1 = 2, chi_2 = 3
    # (ex:not_a_complex, tex line 664)
    a, b = construct(6, 2, 3)
    print(f"ex:not_a_complex  H = Z/6, (chi_1,chi_2) = (2,3): "
          f"construction gives (a,b) = ({a},{b}), weight b*c1-a*c2 = "
          f"{(b*2 - a*3) % 6} mod 6, gcd with 6 = {gcd((b*2-a*3) % 6, 6)}")
    print("  tex's own choice there is (a,b) = (1,1), weight 2-3 = -1: "
          f"gcd(-1 mod 6, 6) = {gcd((2-3) % 6, 6)}  (both are legal witnesses)")

    # standing-convention consequence: in the fabulous-pair setting the tex has
    # G_{D_i} = ker chi_2 != 1 and G_{D_j} = ker chi_1 != 1, so for cyclic
    # H = Z/m neither chi is injective while together they generate; this forces
    # m to be non-prime (and m > 1).
    bad_prime = []
    for m in [2, 3, 5, 7, 11, 13]:
        for c1 in range(m):
            for c2 in range(m):
                if gcd(gcd(c1, c2), m) == 1 and gcd(c1, m) != 1 and gcd(c2, m) != 1:
                    bad_prime.append((m, c1, c2))
    print(f"cyclic H of prime order with both ker(chi_i) != 1 and <chi_1,chi_2> = dual(H): "
          f"{len(bad_prime)} cases (expected 0)")

    ok = not fails and not bf_fail and not bad_prime
    print("RESULT:", "PASS" if ok else "FAIL")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
