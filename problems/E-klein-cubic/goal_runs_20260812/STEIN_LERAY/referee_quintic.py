"""REFEREE spot-check (R1): the unique invariant quintic det Hess F and its
incidence with the pinned points, independently.

The Hessian entries are re-derived by hand from F = sum_i x_i^2 x_{i+1}:
  dF/dx_j        = 2 x_j x_{j+1} + x_{j-1}^2
  d2F/dx_j^2     = 2 x_{j+1};  d2F/dx_j dx_{j+1} = 2 x_j;
  d2F/dx_j dx_{j-1} = 2 x_{j-1};  all other second partials = 0.
(The packet worked with M = Hess/2; here the honest factor 2 is kept, so
det Hess F = 32 * Q_packet.)

Symbolic expansion by Leibniz over exponent dictionaries (own code); numeric
cross-validation of the expansion at 100 random points over F_p; values at the
C5 eigenpoints computed numerically in F_p at TWO primes with an order-5 root
of unity (nonzero mod p proves nonzero in Z[zeta_5]), and compared against the
packet's stored canonical representatives mod Phi_5.  Values at the C11 points
are the pure-power coefficients, absent symbolically (this is Proposition PIN's
forced half: 11 does not divide 5).
"""
import json
import os
import sys
from itertools import permutations, product

HERE = os.path.dirname(os.path.abspath(__file__))
FAILS = []


def ck(name, cond, detail=""):
    print("%-4s %s%s" % ("PASS" if cond else "FAIL", name,
                         "" if cond else "   <-- %s" % detail))
    if not cond:
        FAILS.append(name)


def hess_entry(j, k):
    """Second partial d2F/dx_j dx_k as {exponent: coeff}; indices mod 5."""
    if k == j:
        e = [0] * 5
        e[(j + 1) % 5] = 1
        return {tuple(e): 2}
    if k == (j + 1) % 5:
        e = [0] * 5
        e[j] = 1
        return {tuple(e): 2}
    if k == (j - 1) % 5:
        e = [0] * 5
        e[(j - 1) % 5] = 1
        return {tuple(e): 2}
    return {}


def pmul(a, b):
    out = {}
    for ea, ca in a.items():
        for eb, cb in b.items():
            e = tuple(x + y for x, y in zip(ea, eb))
            out[e] = out.get(e, 0) + ca * cb
    return out


def sign(perm):
    s = 1
    for i in range(len(perm)):
        for j in range(i + 1, len(perm)):
            if perm[i] > perm[j]:
                s = -s
    return s


def main():
    # symmetry of the hand-derived Hessian
    ck("Q1 hand-derived Hessian is symmetric",
       all(hess_entry(j, k) == hess_entry(k, j)
           for j in range(5) for k in range(5)))

    # symbolic determinant
    Q = {}
    for perm in permutations(range(5)):
        term = {(0, 0, 0, 0, 0): sign(perm)}
        dead = False
        for j in range(5):
            ent = hess_entry(j, perm[j])
            if not ent:
                dead = True
                break
            term = pmul(term, ent)
        if dead:
            continue
        for e, c in term.items():
            Q[e] = Q.get(e, 0) + c
    Q = {e: c for e, c in Q.items() if c}

    ck("Q2 det Hess F is nonzero with 11 monomials", len(Q) == 11, len(Q))
    ck("Q3 every monomial has degree 5", all(sum(e) == 5 for e in Q))

    B = [pow(-2, i, 11) for i in range(5)]
    ck("Q4 every monomial has tau-weight 0 (C11-invariance)",
       all(sum(a * b for a, b in zip(e, B)) % 11 == 0 for e in Q))
    Qs = {}
    for e, c in Q.items():
        Qs[tuple(e[(i - 1) % 5] for i in range(5))] = c
    ck("Q5 sigma-invariance (cyclic shift of exponents)", Qs == Q)
    pure = [tuple(5 * (t == c) for t in range(5)) for c in range(5)]
    ck("Q6 no pure fifth power x_c^5 occurs => Q(e_c) = 0 at all five "
       "C11-pinned points (PIN instance, 11 does not divide 5)",
       all(pp not in Q for pp in pure))

    # packet comparison: their Q (factor 2 dropped) must satisfy Q = 32*Q_packet
    PJ = json.load(open(os.path.join(HERE, "results", "pinned_points.json")))
    theirs = {tuple(e): c for e, c in PJ["quintic_Q_terms"]}
    ck("Q7 symbolic expansion = 32 * packet's Q (they dropped Hess = 2*M)",
       Q == {e: 32 * c for e, c in theirs.items()})

    def eval_poly(poly, pt, p):
        tot = 0
        for e, c in poly.items():
            t = c % p
            for xi, ei in zip(pt, e):
                t = t * pow(xi, ei, p) % p
            tot = (tot + t) % p
        return tot

    def num_det(pt, p):
        """Numeric det of the hand Hessian at pt, via Leibniz in F_p."""
        H = [[eval_poly(hess_entry(j, k), pt, p) if hess_entry(j, k) else 0
              for k in range(5)] for j in range(5)]
        tot = 0
        for perm in permutations(range(5)):
            t = sign(perm)
            for j in range(5):
                t = t * H[j][perm[j]] % p
            tot = (tot + t) % p
        return tot % p

    F = {}
    for i in range(5):
        e = [0] * 5
        e[i] += 2
        e[(i + 1) % 5] += 1
        F[tuple(e)] = 1

    import random
    random.seed(20260812)
    for p in (2000000641, 3000001621):  # both = 1 mod 330, hence = 1 mod 5
        # 100 random points: symbolic Q agrees with the numeric determinant
        ok = True
        for _ in range(100):
            pt = [random.randrange(p) for _ in range(5)]
            if eval_poly(Q, pt, p) != num_det(pt, p):
                ok = False
                break
        ck("Q8@p=%d symbolic expansion matches numeric det at 100 random points"
           % p, ok)

        # order-5 root of unity
        eta = pow(random.randrange(2, p), (p - 1) // 5, p)
        while eta == 1:
            eta = pow(random.randrange(2, p), (p - 1) // 5, p)
        # eigenpoints v_j = (eta^{-ij})_i
        vals = {}
        for j in range(5):
            pt = [pow(eta, (-i * j) % 5, p) for i in range(5)]
            vals[j] = (eval_poly(F, pt, p), eval_poly(Q, pt, p))
        ck("Q9@p=%d F(v_0) = 5 and F(v_j) = 0 for j = 1..4 (4 points on X)" % p,
           vals[0][0] == 5 and all(vals[j][0] == 0 for j in (1, 2, 3, 4)))
        ck("Q10@p=%d det Hess F nonzero at ALL FOUR on-X C5-points" % p,
           all(vals[j][1] != 0 for j in (1, 2, 3, 4)),
           {j: vals[j][1] for j in (1, 2, 3, 4)})
        # compare with the packet's stored Z[zeta_5] canonical representatives
        agree = True
        for j in (1, 2, 3, 4):
            rep = PJ["quintic_values_at_C5_points"][str(j)]["canonical_rep_mod_Phi5"]
            packed = sum(c * pow(eta, i, p) for i, c in enumerate(rep)) % p
            if vals[j][1] != 32 * packed % p:
                agree = False
        ck("Q11@p=%d packet's canonical reps map to the same values (x32)" % p,
           agree)
        # C11 coordinate points: numeric consistency of the PIN vanishing
        ck("Q12@p=%d det Hess F = 0 at the five coordinate points" % p,
           all(num_det([1 if t == c else 0 for t in range(5)], p) == 0
               for c in range(5)))

    # divisibility guard: Q is not divisible by F (needs no invariant quadric:
    # i_2 = 0 from referee_molien_fp).  Cheap direct check: F has the monomial
    # x_0^2 x_1 while Q has no monomial with x-support of size <= 2... instead
    # check directly that no quadric q with Q = F*q exists by linear algebra
    # over Q on the 15 quadric monomials.
    from fractions import Fraction
    quad_mons = [tuple(sum(1 for t in c if t == i) for i in range(5))
                 for c in [(i, j) for i in range(5) for j in range(i, 5)]]
    rows = {}
    for qi, qm in enumerate(quad_mons):
        for fe, fc in F.items():
            e = tuple(x + y for x, y in zip(fe, qm))
            rows.setdefault(e, {})[qi] = rows.get(e, {}).get(qi, 0) + fc
    mons = sorted(set(rows) | set(Q))
    A = [[Fraction(rows.get(m, {}).get(qi, 0)) for qi in range(15)] for m in mons]
    bvec = [Fraction(Q.get(m, 0)) for m in mons]
    # least-squares-free exact test: solve A x = b by elimination, detect inconsistency
    aug = [row + [bv] for row, bv in zip(A, bvec)]
    r = 0
    for col in range(15):
        piv = next((i for i in range(r, len(aug)) if aug[i][col]), None)
        if piv is None:
            continue
        aug[r], aug[piv] = aug[piv], aug[r]
        pr = aug[r]
        for i in range(len(aug)):
            if i != r and aug[i][col]:
                f = aug[i][col] / pr[col]
                aug[i] = [a - f * b for a, b in zip(aug[i], pr)]
        r += 1
    inconsistent = any(all(x == 0 for x in row[:15]) and row[15] != 0
                       for row in aug)
    ck("Q13 det Hess F is NOT divisible by F (restriction to X is nonzero)",
       inconsistent)

    print()
    if FAILS:
        print("REFEREE_QUINTIC_FAILED", FAILS)
        sys.exit(1)
    print("REFEREE_QUINTIC_OK")


if __name__ == "__main__":
    main()
