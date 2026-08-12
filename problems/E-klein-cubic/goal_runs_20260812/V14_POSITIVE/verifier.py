#!/usr/bin/env python3
"""V14_POSITIVE verifier. Pure python3. Replay: python3 verifier.py

Re-runs scripts/produce.py (exact ATLAS characters + two-prime Weil traces
+ sealed-packet marker ledger), then checks the logical and numerical
invariants recorded in THEOREM.md.
"""
from __future__ import annotations

import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RESULTS = os.path.join(HERE, "results")
os.makedirs(RESULTS, exist_ok=True)

LOG = []


def note(name, ok, detail):
    print("CHECK %s %s %s" % (name, "PASS" if ok else "FAIL", detail))
    LOG.append((name, bool(ok), detail))
    return bool(ok)


def main():
    prod = os.path.join(HERE, "scripts", "produce.py")
    r = subprocess.run([sys.executable, prod], cwd=HERE, capture_output=True, text=True)
    note(
        "produce_ran",
        r.returncode == 0,
        "produce.py exit %d; tail=%r" % (r.returncode, (r.stdout or r.stderr)[-240:]),
    )
    path = os.path.join(RESULTS, "character_dims.json")
    if not os.path.isfile(path):
        note("json_present", False, "missing " + path)
        return finish()
    data = json.load(open(path))
    exact = data["exact"]
    traces = data["traces"]
    ledger = data["sealed_ledger"]

    note(
        "control_C_d",
        exact["control_d0_to_5_C"] == [0, 0, 1, 2, 7, 18],
        "dim C_d(A) d=0..5 = %s (sealed V14MAP_DEGREE345)" % exact["control_d0_to_5_C"],
    )
    note(
        "control_inv",
        exact["control_d0_to_5_inv"] == [1, 0, 1, 2, 4, 8],
        "invariants of Sym^d M d=0..5 = %s" % exact["control_d0_to_5_inv"],
    )
    note(
        "C6_is_43",
        exact["dim_C_d_A"][6] == 43,
        "dim Hom_G(Sym^6 M*, A) = %d" % exact["dim_C_d_A"][6],
    )
    note(
        "HF6_is_650",
        exact["hilbert_V14_classical"][6] == 650,
        "classical h^0(V14, O(6)) = %d" % exact["hilbert_V14_classical"][6],
    )
    t23, t67 = traces["23"], traces["67"]
    note(
        "two_prime_spin_agree",
        t23["Hom_SL_Sym_d_Ustar_M"] == t67["Hom_SL_Sym_d_Ustar_M"],
        "spin Hom @23=%s @67=%s" % (t23["Hom_SL_Sym_d_Ustar_M"], t67["Hom_SL_Sym_d_Ustar_M"]),
    )
    note(
        "two_prime_five_agree",
        t23["Hom_G_Sym_d_five_M"] == t67["Hom_G_Sym_d_five_M"],
        "five->M Hom @23=%s @67=%s" % (t23["Hom_G_Sym_d_five_M"], t67["Hom_G_Sym_d_five_M"]),
    )
    spin = t23["Hom_SL_Sym_d_Ustar_M"]
    note(
        "spin_d2_zero",
        spin[2] == 0,
        "Hom_SL(Sym^2 U*, M) = %d (no quadratic spin map P(U)-->P(M))" % spin[2],
    )
    note(
        "spin_first_at_d4",
        spin[4] == 3 and spin[0] == 0 and spin[1] == 0 and spin[3] == 0,
        "first spin ambient is d=4, dim %d; odds vanish" % spin[4],
    )
    note(
        "sl_order_1320",
        t23["sl_order"] == 1320 and t67["sl_order"] == 1320,
        "SL(2,11) closure 1320 at both primes",
    )
    bad = [row["name"] for row in ledger if not row["all_hits"]]
    note(
        "sealed_markers",
        not bad,
        "all cited packets present with required strings; misses=%s" % (bad or "none"),
    )
    th = open(os.path.join(HERE, "THEOREM.md"), encoding="utf-8").read()
    note(
        "headline_line",
        "Problem E remains OPEN; this packet excludes no degree." in th,
        "required headline sentence present in THEOREM.md",
    )
    note(
        "no_report_md",
        not os.path.isfile(os.path.join(HERE, "REPORT.md")),
        "harness-forbidden REPORT.md is absent",
    )
    note(
        "not_claimed_section",
        "Not claimed" in th and th.find("## 6. Not claimed") >= 0,
        "Not claimed section present",
    )
    note(
        "no_degree_exclusion_claimed",
        "excludes no degree" in th and "FLAGGED" in th,
        "no degree exclusion is claimed; any exclusion language is flagged",
    )
    log = data["logical"]
    note(
        "logical_block",
        log["linear_P_to_V14_impossible"]
        and log["spin_plus_Phi_not_headline"]
        and log["Phi_dominance_not_sealed"],
        "composition cannot settle the headline; Phi dominance unsealed; spin not sufficient",
    )
    return finish()


def finish():
    n = len(LOG)
    fails = sum(1 for _, ok, _ in LOG if not ok)
    allgreen = fails == 0
    print("V14_POSITIVE_VERIFY_OK" if allgreen else "V14_POSITIVE_VERIFY_FAIL")
    print("ALLGREEN" if allgreen else "FAILED", "(%d checks, %d failures)" % (n, fails))
    out = {
        "n_checks": n,
        "n_failures": fails,
        "allgreen": allgreen,
        "checks": [{"name": a, "ok": b, "detail": c} for a, b, c in LOG],
    }
    with open(os.path.join(RESULTS, "verifier_output.json"), "w") as f:
        json.dump(out, f, indent=2)
        f.write("\n")
    with open(os.path.join(RESULTS, "verifier_stdout.txt"), "w") as f:
        for a, b, c in LOG:
            f.write("CHECK %s %s %s\n" % (a, "PASS" if b else "FAIL", c))
        f.write("ALLGREEN\n" if allgreen else "FAILED\n")
    return 0 if allgreen else 1


if __name__ == "__main__":
    sys.exit(main())
