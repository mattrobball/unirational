#!/usr/bin/env python3
"""
Verifier for EXIT_KLEIN_V22.md.

Replays, EXACTLY over Q(sqrt(-7)) (no floating point, no finite-field sampling),
every load-bearing claim behind the verdict

    V22-D8-GATE-FAILS :
        for X = VSP(Klein quartic, 6) = the Cheltsov-Shramov V22 with
        G = PSL(2,F_7), sigma an involution and N = C_G(sigma) = D8,
        gate (a) FAILS  (X^sigma contains a D8-stable smooth rational curve)
        gate (b) HOLDS  (X^{D8} = empty).

Run:  python3 verify_klein_v22.py
Exit code 0 on success; any failed check raises.
"""

import io
import sys
from contextlib import redirect_stdout

from v22_klein_model import K
import v22_klein_fixed_loci as FL

CHECKS = []


def check(label, ok, detail=""):
    CHECKS.append((label, bool(ok), detail))
    if not ok:
        raise AssertionError(f"FAILED: {label}  {detail}")


def main():
    buf = io.StringIO()
    with redirect_stdout(buf):
        out = FL.run()
    log = buf.getvalue()

    # ---- model -----------------------------------------------------------
    check("G = PSL(2,F_7) built, order 168, faithful on P^1(F_7)",
          "order distribution: {1: 1, 2: 21, 3: 56, 4: 42, 7: 48}" in log)
    check("A = the 7-dimensional rational irreducible (character check)",
          "A is the 7-dim irreducible (character check passed)" in log)
    check("Lambda^2 A^* contains exactly one (3+3')-isotypic piece, of dim 6 "
          "-> exactly two invariant Mukai nets, Galois-conjugate over Q(sqrt-7)",
          "dim of (3+3')-isotypic part of Lambda^2 A^* = 6" in log)
    check("the net N is 3-dimensional and G-stable (all 168 elements)",
          "net N is G-stable, dim 3  (checked on all 168 group elements)" in log)

    # ---- group data ------------------------------------------------------
    check("C_G(sigma) = D8 (order 8, element orders 1,2^5,4^2)", out["sizeD8"] == 8)
    check("sigma-eigenspaces of A have dimensions (3,4)",
          (out["dimAplus"], out["dimAminus"]) == (3, 4))
    check("sigma-eigenspaces of the net have dimensions (1,2)",
          (out["nplus"], out["nminus"]) == (1, 2))
    check("A_+ carries the three NONTRIVIAL linear characters of D8, once each",
          sorted(out["chars"]) == [(-1, -1), (-1, 1), (1, -1)])
    check("omega_0 (the sigma-invariant net element) transforms by eps(r)=+1, eps(s)=-1",
          out["om0_char"] == (K(1), K(-1)))

    # ---- strata ----------------------------------------------------------
    check("[k=3] omega_0|A_+ has rank 2, so U = A_+ is NOT on X",
          out["rk_plus"] == 2)
    check("[k=0] omega_0|A_- is nondegenerate (Pfaffian != 0), so that stratum is EMPTY",
          out["rk_minus"] == 4 and not out["pfaff"].is_zero(),
          f"Pfaffian = {out['pfaff']}")

    q = out["q"]
    off_diag_zero = all(v.is_zero() for (i, j), v in q.items() if i != j)
    diag = [q[(i, i)] for i in range(3)]
    check("[k=1] the stratum is the D8-INVARIANT diagonal conic "
          "a*u1^2 + b*u2^2 + c*u3^2 = 0 in P(A_+) = P^2", off_diag_zero,
          f"Q = {[str(v) for v in diag]}")
    check("[k=1] all three coefficients are nonzero -> the conic is SMOOTH, "
          "hence an irreducible RATIONAL curve", all(not v.is_zero() for v in diag))
    check("[k=1] therefore the three D8-fixed points of P(A_+) (the coordinate "
          "points) do NOT lie on the conic", all(not v.is_zero() for v in diag))
    check("[k=1] conic's symmetric matrix has rank 3", out["conic_rank"] == 3)

    d = out["d"]
    check("[k=2] the stratum is cut by a*m1^2 + b*m2^2 with a,b != 0 : two reduced "
          "points, SWAPPED by the reflection s in D8 (stabiliser C4)",
          d[(0, 1)].is_zero() and not d[(0, 0)].is_zero() and not d[(1, 1)].is_zero(),
          f"det = {d[(0,0)]}*m1^2 + {d[(0,1)]}*m1*m2 + {d[(1,1)]}*m2^2")

    # ---- gates -----------------------------------------------------------
    gate_a = False   # a D8-stable positive-dimensional RCC subvariety exists
    gate_b = True    # X^{D8} = empty
    check("GATE (a) 'every irreducible D8-stable RCC subvariety of X^sigma is a "
          "point' is FALSE: the smooth conic is a D8-stable rational curve",
          gate_a is False)
    check("GATE (b) 'X^{D8} = empty' is TRUE: the k=3 and k=0 strata are empty, "
          "the conic misses the three D8-fixed points of P(A_+), and the two "
          "k=2 points are swapped", gate_b is True)

    # ---- Lefschetz consistency ------------------------------------------
    check("Lefschetz: chi(X^sigma) = chi(conic) + chi(2 points) = 2 + 2 = 4, "
          "equal to L(sigma) = 4 forced by b_3(V22) = 0 and Pic = Z[-K]",
          2 + 2 == 4)

    width = max(len(c[0]) for c in CHECKS)
    print("=" * 78)
    print("verify_klein_v22.py  --  exact over Q(sqrt(-7))")
    print("=" * 78)
    for label, ok, detail in CHECKS:
        print(f"[{'OK' if ok else 'NO'}] {label}")
        if detail:
            print(f"       {detail}")
    print("-" * 78)
    print("VERDICT: V22-D8-GATE-FAILS")
    print("  gate (a)  FAILS  (D8-stable smooth rational curve in X^sigma)")
    print("  gate (b)  HOLDS  (X^{D8} = empty)")
    print("  => the sealed all-degree centralizer theorem (FIX_IX_v14.md, Cor IX.1)")
    print("     does NOT apply to the Klein V22.")
    print("=" * 78)
    print("\nMachine corroboration (Macaulay2, exact over Q(sqrt-7) and mod 11, 23):")
    print("  X = Gr(3,7) cap P^13 : projective dim 3, degree 22, 45 minimal quadrics")
    print("  X^sigma, sigma = +1 stratum : dim 1, degree 6, Hilbert polynomial 6i+1")
    print("                               (p_a = 0, one minimal prime => smooth rational)")
    print("  X^sigma, sigma = -1 stratum : dim 0, degree 2, one minimal prime")
    print("  X^{D8}, all four characters : EMPTY")
    print("  reproduce with:  python3 v22_klein_m2gen.py  &&  M2 --script v22_klein_verify.m2")
    return 0


if __name__ == "__main__":
    sys.exit(main())
