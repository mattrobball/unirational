#!/usr/bin/env python3
"""PHI_SEXTIC_ISOGENY verifier.

Replays, end to end:
  1. the formula self-tests (scripts/selftest.py): the binary-quartic j, the
     Weierstrass j, the whole branch-quartic extraction on known curves, and
     the modular polynomial Phi_2 on genuinely 2-isogenous pairs;
  2. scripts/sextic.py at two FRESH split primes not used in REPORT.md
     (419, 617), including the pointwise verification of the S3-equivariant
     isomorphism C_sigma -> E_sigma;
  3. the independent brute-force point counts (scripts/bruteforce.py):
     the 15 Plucker quadrics swept over P^5(F_23) and the Pfaffian cubic swept
     over P^2(F_p) at every replayed prime;
  4. the EXACT char-0 j computation: the branch quartic R and the Weierstrass
     cubic recorded in results/model_K.json are fed to a fresh, independent
     implementation of Q(zeta_11) arithmetic and of the two j formulas, and
     both must return 8192/11.

  python3 verifier.py            fast replay (uses the stored exact K model)
  python3 verifier.py --full     also recomputes results/model_K.json (~10 min)
"""
import os, sys, json, subprocess
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
SCR = os.path.join(HERE, "scripts")
FRESH = ["419", "617"]
ck = []
def CHECK(name, ok, detail=""):
    ck.append(bool(ok))
    print(f"CHECK {name} {'PASS' if ok else 'FAIL'} {detail}")

def run(args, tag):
    r = subprocess.run([sys.executable] + args, capture_output=True, text=True)
    out = r.stdout + r.stderr
    ok = (r.returncode == 0) and ("ALLGREEN" in out) and ("FAIL" not in out)
    CHECK(tag, ok, "" if ok else out[-1500:])
    return out

# ---- 1. formula self-tests -------------------------------------------------
run([os.path.join(SCR, "selftest.py")], "selftest_formulas")

# ---- 2. fresh primes -------------------------------------------------------
for p in FRESH:
    out = run([os.path.join(SCR, "sextic.py"), p], f"sextic_fresh_prime_{p}")
    for key in ("equivariant_isomorphism_pointwise", "S3_structures_match",
                "j_C_two_routes", "branch_quartic_consistent", "L_sigma_lies_on_X"):
        CHECK(f"{key}_present_{p}", f"CHECK {key}_{p} PASS" in out)

# ---- 3. independent brute-force counts -------------------------------------
run([os.path.join(SCR, "sextic.py"), "23"], "sextic_prime_23")
run([os.path.join(SCR, "bruteforce.py"), "23"] + FRESH, "bruteforce_counts")

# ---- 4. exact char-0 replay, fresh arithmetic ------------------------------
# minimal independent Q(z)/Phi_11 arithmetic
N = 10
def kadd(a, b): return tuple(x + y for x, y in zip(a, b))
def kneg(a): return tuple(-x for x in a)
def ksub(a, b): return kadd(a, kneg(b))
def kmul(a, b):
    c = [Fraction(0)]*19
    for i, x in enumerate(a):
        if x:
            for j, y in enumerate(b):
                if y: c[i+j] += x*y
    for k in range(18, 9, -1):          # z^10 = -(1 + z + ... + z^9)
        if c[k]:
            v = c[k]; c[k] = Fraction(0)
            for t in range(k-10, k): c[t] -= v
    return tuple(c[:10])
def kint(n): return tuple([Fraction(n)] + [Fraction(0)]*9)
def kinv(a):
    # solve a * x = 1 by linear algebra on the Q-basis 1, z, ..., z^9
    cols = []
    for i in range(N):
        e = tuple(Fraction(1) if k == i else Fraction(0) for k in range(N))
        cols.append(kmul(a, e))
    M = [[cols[j][i] for j in range(N)] + [Fraction(1) if i == 0 else Fraction(0)]
         for i in range(N)]
    piv = []; rr = 0
    for c in range(N):
        pr = next((r for r in range(rr, N) if M[r][c] != 0), None)
        if pr is None: continue
        M[rr], M[pr] = M[pr], M[rr]
        iv = Fraction(1)/M[rr][c]; M[rr] = [x*iv for x in M[rr]]
        for r in range(N):
            if r != rr and M[r][c] != 0:
                f = M[r][c]; M[r] = [x - f*y for x, y in zip(M[r], M[rr])]
        piv.append(c); rr += 1
    x = [Fraction(0)]*N
    for r, c in enumerate(piv): x[c] = M[r][N]
    return tuple(x)
def kdiv(a, b): return kmul(a, kinv(b))
def kparse(s): return tuple(Fraction(t) for t in s.strip("[]").split(","))
def krat(a): return a[0] if all(x == 0 for x in a[1:]) else None

with open(os.path.join(HERE, "results", "model_K.json")) as f: mk = json.load(f)
Rc = [kparse(s) for s in mk["branch_quartic_R"]]
a, b, c, d, e = Rc
I = ksub(kadd(kmul(kint(12), kmul(a, e)), kmul(c, c)), kmul(kint(3), kmul(b, d)))
J = kadd(kadd(kmul(kint(72), kmul(a, kmul(c, e))), kmul(kint(9), kmul(b, kmul(c, d)))),
         kneg(kadd(kadd(kmul(kint(27), kmul(a, kmul(d, d))), kmul(kint(27), kmul(e, kmul(b, b)))),
                   kmul(kint(2), kmul(c, kmul(c, c))))))
jC = kdiv(kmul(kint(6912), kmul(I, kmul(I, I))),
          ksub(kmul(kint(4), kmul(I, kmul(I, I))), kmul(J, J)))
rC = krat(jC)
CHECK("exact_jC_replay", rC == Fraction(8192, 11),
      f"j(C_sigma) from the recorded exact branch quartic = {rC}")

c3, c2, c1, c0 = [kparse(s) for s in mk["weierstrass_E_sigma"]]
a2, a4, a6 = c2, kmul(c1, c3), kmul(c0, kmul(c3, c3))
b2, b4, b6 = kmul(kint(4), a2), kmul(kint(2), a4), kmul(kint(4), a6)
C4 = ksub(kmul(b2, b2), kmul(kint(24), b4))
C6 = kadd(ksub(kneg(kmul(b2, kmul(b2, b2))), kmul(kint(216), b6)), kmul(kint(36), kmul(b2, b4)))
jE = kdiv(kmul(kint(1728), kmul(C4, kmul(C4, C4))), ksub(kmul(C4, kmul(C4, C4)), kmul(C6, C6)))
rE = krat(jE)
CHECK("exact_jE_replay", rE == Fraction(8192, 11),
      f"j(E_sigma) from the recorded exact Weierstrass cubic = {rE}")
CHECK("exact_j_equal", rC is not None and rC == rE,
      "j(C_sigma) = j(E_sigma) = 8192/11 exactly over K = Q(zeta_11)")
CHECK("exact_jE_matches_FIX_A0_seal", rE == Fraction(8192, 11),
      "matches the sealed j(E_sigma) of FIX-A0-ARRANGEMENT-PASS")

if "--full" in sys.argv:
    run([os.path.join(SCR, "sextic.py"), "K"], "sextic_exact_K_recompute")

print("ALLGREEN" if all(ck) else "FAILURES PRESENT")
sys.exit(0 if all(ck) else 1)
