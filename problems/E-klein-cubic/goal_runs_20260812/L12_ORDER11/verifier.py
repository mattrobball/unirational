#!/usr/bin/env python3
"""L12_ORDER11 — replayable verifier.

python3 only, standard library only, exact Fraction / Q(zeta_11) arithmetic,
no floating point, no gap/gp/sage/magma.

Replays:
  A   the fatal anchors (frame, untwisted total on P^4, random test towers,
      P^4 and X twisted totals against the Sym^k W* characters, the local
      blowup mass identity incl. positive-dimensional components, and the
      Sec.8 convention audit);
  K   the k = 0 localized sum rule and its complete mod-pi content;
  I   the genus-free integrality consequence (mu = 0 branch at d in QR;
      d = 35 towers; the forced depth lower bounds);
  G   the genus-0 closed test over the full depth<=3 tower menu at d = 35;
  M   the fibre-trace menu criterion, validated against brute-force menus;
  X   cross-checks against the SEALED record: the C11 value menu of
      vectors_d35.json, STAGE2 Thm 2.1, Smith Lemma U(b) (constancy of n_x),
      and the absence of order-11 content in the canonical 22 cells.
"""
from __future__ import annotations

import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "scripts"))
RESULTS = os.path.join(HERE, "results")
os.makedirs(RESULTS, exist_ok=True)
PROBLEM = os.path.abspath(os.path.join(HERE, "..", ".."))

import cyclo as C          # noqa: E402
import l12core as L        # noqa: E402
import towers as T         # noqa: E402
import genus0 as G         # noqa: E402
import integrality as I    # noqa: E402
import menus as MN         # noqa: E402
import menus2 as M2        # noqa: E402
import anchors             # noqa: E402
import k0rule              # noqa: E402

CHECKS = []
FAILURES = []


def check(name, ok, detail=""):
    CHECKS.append({"name": name, "ok": bool(ok), "detail": detail})
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}" + (f"  ({detail})" if detail else ""))
    if not ok:
        FAILURES.append(name)
    return ok


def main() -> int:
    print("L12_ORDER11 verifier — order-11 global localization identity")
    print("Headline: Problem E remains OPEN; this packet excludes no degree.")
    print()

    print("--- A: fatal anchors ---")
    for c in anchors.run(verbose=False):
        check("A " + c["name"], c["ok"], c["detail"] if not c["ok"] else "")

    print("--- K: the k = 0 localized sum rule ---")
    kres, dbar = k0rule.run(verbose=False)
    for c in kres:
        check("K " + c["name"], c["ok"], c["detail"] if not c["ok"] else "")

    print("--- I: integrality (genus-free) and forced depth ---")
    ires, iinfo = I.run(35, verbose=False)
    for r in sorted(L.QR):
        v = iinfo["I1"][str(r)]
        check(f"I1 d={r} (QR), mu=0 branch: all five forced traces have "
              f"v_pi = -1 -> DEAD", all(x == -1 for x in v.values()))
    for mu in range(1, 11):
        f = iinfo["I3"][mu]["min_extra_depth_for_R0"]
        check(f"I3 mu1={mu}: integrality forces total blowup depth >= {f + 1}",
              f is not None and f >= 2, f"min extra depth {f}")

    print("--- G: genus-0 closed test, d = 35, all depth<=3 towers ---")
    tot = ntow = nint = nmenu = 0
    nx_const = True
    menu_from_engine = {}
    for mu1 in range(1, 11):
        vs, st = G.tower_over_e0(35, mu1, 2)
        npass = ni = nm = 0
        for v in vs:
            M, cnt = G.globalize(v)
            E, _ = G.residuals(M)
            if not C.is_zero(E[0]):
                check(f"G mu1={mu1}: k=0 identity automatic", False)
            nx_const &= (len(set(cnt.values())) == 1)
            if all(C.is_zero(E[k]) for k in (1, 2, 3)):
                npass += 1
            R = I.R_vector(M)
            if all(x == 0 for x in R.values()):
                ni += 1
                trs = [C.mul(L.D_X(L.WEIGHT_INDEX[W]), M[W])
                       for W in sorted(L.QR)]
                if all(M2.in_menu(t, b_required=cnt[sorted(L.QR)[0]])[0]
                       for t in trs):
                    nm += 1
        check(f"G mu1={mu1}: 0 of {len(vs)} towers pass the genus-0 test "
              f"(k=1,2,3)", npass == 0)
        ntow += len(vs)
        nint += ni
        nmenu += nm
        # engine's own C11 value row, to be matched against the sealed menu
        base = (35 * L.A[1]) % 11
        menu_from_engine[mu1] = {
            (L.A[i] - L.A[1]) % 11:
                ("eigpt(w=%d)" % ((base + mu1 * ((L.A[i] - L.A[1]) % 11)) % 11)
                 if (base + mu1 * ((L.A[i] - L.A[1]) % 11)) % 11 in L.QR
                 else "UNDEF")
            for i in range(5) if i != 1}
    check(f"G TOTAL: 0 of {ntow} depth<=3 towers pass the genus-0 test",
          True, f"towers={ntow}")
    check(f"G integrality survivors: {nint} of {ntow}", nint > 0)
    check(f"G bounded-menu pass: {nmenu} of {nint} integrality survivors",
          nmenu == 0)
    check("G Smith Lemma U(b) reproduced: n_x is constant over the five "
          "receiver points in EVERY enumerated tower", nx_const)

    print("--- M: fibre-trace menu criterion ---")
    bad = 0
    n = 0
    for b in range(2, 6):
        for k in MN.menu_cached(b):
            n += 1
            ok, bb, _ = M2.in_menu(list(k))
            if not ok or bb != b:
                bad += 1
    check(f"M exact criterion agrees with brute-force MENU_b, b=2..5 "
          f"({n} entries)", bad == 0)
    check("M tr = 1 forces b = 2 (a smooth rational fibre with two fixed "
          "points)", M2.in_menu(C.one())[1] == 2)

    print("--- X: cross-checks against the sealed record ---")
    vp = os.path.join(PROBLEM, "goal_runs_20260811", "GLOBAL_COHERENCE",
                      "results", "vectors_d35.json")
    if os.path.exists(vp):
        sealed = json.load(open(vp))["per_center"]["C11"]
        rows = [int(nm.split("c=")[1]) for nm in sealed["row_names"]]
        sealed_set = {tuple(v) for v in sealed["vectors"]}
        mine = {tuple(menu_from_engine[mu][c] for c in rows)
                for mu in range(1, 11)}
        check(f"X C11 value menu reproduced from Stage-2 Thm 1.2: "
              f"{len(mine)} entries", mine == sealed_set,
              f"sealed={len(sealed_set)} mine={len(mine)}")
    else:
        check("X vectors_d35.json present", False, vp)

    # STAGE2 Thm 2.1
    for dd, want in ((1, 4), (2, 3), (0, 2)):
        mx = 0
        for mu in range(0, 11):
            base = (dd * L.A[1]) % 11
            mx = max(mx, sum(1 for i in range(5) if i != 1
                             and (base + mu * ((L.A[i] - L.A[1]) % 11)) % 11
                             in L.QR))
        check(f"X STAGE2 Thm 2.1 reproduced: d={dd} mod 11 -> at most {want} "
              f"of the four C11 rows carry a value", mx == want, f"got {mx}")

    cp = os.path.join(PROBLEM, "goal_runs_20260811", "D35_AUDIT", "results",
                      "patterns_r5_content_p331.json")
    if os.path.exists(cp):
        s = open(cp).read()
        check("X the canonical 22 cells carry NO order-11 content (no "
              "C11/P11/pt_C11 token), so every order-11 verdict is constant "
              "across the 22 cells",
              ("C11" not in s) and ("P11" not in s))
    else:
        check("X D35_AUDIT patterns file present", False, cp)

    print()
    nf = len(FAILURES)
    print(f"Checks: {len(CHECKS) - nf} passed, {nf} failed, {len(CHECKS)} total")
    payload = {
        "packet": "L12_ORDER11",
        "headline": "Problem E remains OPEN; this packet excludes no degree",
        "d": 35,
        "n_checks": len(CHECKS),
        "n_passed": len(CHECKS) - nf,
        "n_failed": nf,
        "failures": FAILURES,
        "checks": CHECKS,
    }
    with open(os.path.join(RESULTS, "verifier_output.json"), "w") as f:
        json.dump(payload, f, indent=2)
        f.write("\n")
    if nf == 0:
        print("L12_ORDER11_VERIFY_OK")
        print("ALLGREEN")
        return 0
    print("L12_ORDER11_VERIFY_FAIL")
    return 1


if __name__ == "__main__":
    sys.exit(main())
