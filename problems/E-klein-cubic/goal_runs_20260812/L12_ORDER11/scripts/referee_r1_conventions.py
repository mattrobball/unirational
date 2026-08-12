"""Referee spot-check R1 (FLAG-A): the sign pairing of the Atiyah-Bott
numerator/denominator in ledger Sec.8, the two-completions claim, the Galois
conjugacy, and whether convention-independence actually covers the downstream
verdicts.  Independent implementation (referee_lib), no packet imports."""
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import referee_lib as R  # noqa: E402

FAIL = []


def chk(name, ok, detail=""):
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}" + (f" ({detail})" if detail else ""))
    if not ok:
        FAIL.append(name)


def main():
    # ---- 0. the ordering claim: which orderings of the QR set make
    # F = sum x_i^2 x_{i+1} semi-invariant?
    import itertools
    good = []
    for perm in itertools.permutations(sorted(R.QR)):
        cs = {(2 * perm[i] + perm[(i + 1) % 5]) % 11 for i in range(5)}
        if len(cs) == 1:
            good.append((perm, cs.pop()))
    chk("R1.0 exactly the 5 cyclic rotations of (1,9,4,3,5) make F "
        "semi-invariant, all with weight 0",
        len(good) == 5 and all(c == 0 for _, c in good)
        and all(p in {tuple(R.A[(i + s) % 5] for i in range(5))
                      for s in range(5)} for p, _ in good))
    chk("R1.0 literal ledger tuple (1,3,4,5,9) does NOT make F semi-invariant",
        len({(2 * t[0] + t[1]) % 11
             for t in [((1, 3, 4, 5, 9)[i], (1, 3, 4, 5, 9)[(i + 1) % 5])
                       for i in range(5)]}) > 1)

    # ---- 1. all four sign pairings on P^4 and on X, against both characters.
    # pairing (en, ed): numerator z^{en * k * a_j}, denominator
    # prod (1 - z^{ed * w}) over tangent weights w.
    def total_P4(k, en, ed):
        return R.total([R.mul(R.zpow(en * k * R.A[j]),
                              R.inv(R.prod([R.one_minus_zpow(ed * w)
                                            for w in R.tangent_P4(j)])))
                        for j in range(5)])

    def total_X(k, en, ed):
        return R.total([R.mul(R.zpow(en * k * R.A[j]),
                              R.inv(R.prod([R.one_minus_zpow(ed * w)
                                            for w in R.tangent_X(j)])))
                        for j in range(5)])

    results = {}
    for en, ed in [(-1, -1), (+1, +1), (-1, +1), (+1, -1)]:
        okA = all(R.eq(total_P4(k, en, ed), R.chi_sym(k, dual=True))
                  for k in range(1, 7))
        okB = all(R.eq(total_P4(k, en, ed), R.chi_sym(k, dual=False))
                  for k in range(1, 7))
        okXA = all(R.eq(total_X(k, en, ed), R.chi_OX(k, dual=True))
                   for k in range(1, 7))
        okXB = all(R.eq(total_X(k, en, ed), R.chi_OX(k, dual=False))
                   for k in range(1, 7))
        results[(en, ed)] = (okA, okB, okXA, okXB)
    chk("R1.1 (-,-) pairing = chi_{Sym^k W*} on P^4 and X (adopted (A))",
        results[(-1, -1)] == (True, False, True, False))
    chk("R1.1 (+,+) pairing = chi_{Sym^k W} on P^4 and X (completion (B))",
        results[(+1, +1)] == (False, True, False, True))
    chk("R1.1 the Sec.8 literal pairing (-,+) matches NEITHER character on "
        "P^4 nor on X", results[(-1, +1)] == (False, False, False, False))
    chk("R1.1 the fourth pairing (+,-) matches NEITHER character",
        results[(+1, -1)] == (False, False, False, False))

    # ---- 2. Galois conjugacy of the two consistent completions
    ok = True
    for k in range(0, 7):
        ok &= R.eq(total_P4(k, +1, +1), R.sigma(total_P4(k, -1, -1), -1))
        ok &= R.eq(total_X(k, +1, +1), R.sigma(total_X(k, -1, -1), -1))
        ok &= R.eq(R.chi_sym(k, dual=False), R.sigma(R.chi_sym(k, dual=True), -1))
    chk("R1.2 completion (B) = sigma_{-1}(completion (A)), targets included",
        ok)

    # ---- 3. does convention-independence cover the downstream verdicts?
    # Machine check on closed towers at d = 35: enumerate all depth<=2-closed
    # towers plus a slice of depth-3 towers, and compare, verdict by verdict:
    # genus-0 E_k = 0, integrality R_V = 0, trace integrality, menu data.
    import referee_r345_lib as T
    memoA = {}
    checked = 0
    ok_all = True
    for mu1 in range(1, 11):
        vecs = R.towers_over_e0(35, mu1, 2, tuple(range(1, 11)), memoA)
        # depth<=3 closed towers, up to 12 per mu1
        for v in sorted(vecs)[:12]:
            MA, cntA = R.globalize(v)
            # convention B: rebuild the SAME tower's masses with conv=-1
            vB = tuple((R.sigma(x, -1), n) for (x, n) in v)
            MB = {w: R.sigma(MA[w], -1) for w in MA}
            EA = R.residual_Ek(MA, 3, +1)
            EB = R.residual_Ek(MB, 3, -1)
            ok_all &= all(R.is_zero(a) == R.is_zero(b) for a, b in zip(EA, EB))
            ok_all &= all(R.eq(b, R.sigma(a, -1)) for a, b in zip(EA, EB))
            RA, RB = R.R_vector(MA), R.R_vector(MB)
            ok_all &= (all(x == 0 for x in RA.values())
                       == all(x == 0 for x in RB.values()))
            trA = R.forced_traces(MA, +1)
            trB = R.forced_traces(MB, -1)
            for w in R.QRL:
                ok_all &= (R.is_alg_int(trA[w]) == R.is_alg_int(trB[w]))
                ok_all &= R.eq(trB[w], R.sigma(trA[w], -1))
                mA = T.in_menu(trA[w])
                mB = T.in_menu(trB[w])
                ok_all &= (mA[0] == mB[0]) and (mA[1] == mB[1])
            checked += 1
    chk(f"R1.3 verdict-level convention independence on {checked} "
        f"depth<=3-closed towers (E_k, R_V, integrality, menu b)",
        ok_all and checked >= 100)

    # component terms: direct conv=-1 evaluation equals sigma_{-1}(conv=+1)
    ok = True
    ncomp = 0
    seen = set()
    root = R.site_pt(R.tangent_P4(0), 35)
    frontier = [root]
    for _ in range(3):
        nxt = []
        for s in frontier:
            if s[0] != "pt":
                continue
            for mu in range(0, 11):
                for k in R.blowup(s, mu):
                    if k[0] == "comp" and (k[1], k[2]) not in seen:
                        seen.add((k[1], k[2]))
                        a = R.ab_comp(k[1], k[2], +1)
                        b = R.ab_comp(k[1], k[2], -1)
                        ok &= R.eq(b, R.sigma(a, -1))
                        ncomp += 1
                    if k[0] == "pt":
                        nxt.append(k)
        frontier = list(set(nxt))
    chk(f"R1.3 component AB terms: conv B = sigma_{{-1}}(conv A) on {ncomp} "
        f"distinct component types", ok and ncomp > 0)

    print()
    print("referee R1: " + ("ALL GREEN" if not FAIL else f"FAILURES: {FAIL}"))
    return 0 if not FAIL else 1


if __name__ == "__main__":
    sys.exit(main())
