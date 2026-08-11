#!/usr/bin/env python3
"""Independent replay of every decisive check of the STANDARD_FORM_PW packet.

    scripts/s1_level0.py       the level-0 atlas of P(W): stratification,
                               tangent/normal characters, Lemma B, incidences
                               -- both split primes
    scripts/s2_nonabelian.py   the three nonabelian point strata: tangent
                               representations, the elimination lemma, the
                               rounds each needs, and the abelian strata their
                               exceptional divisors create -- both split primes
    scripts/s3_automaton.py    the boundary-tracking multiset automaton, run to
                               acceptance for every class; the exhaustive
                               reachability closure; the terminus statistics
                               -- exact character arithmetic, prime independent
    scripts/s4_legality.py     smoothness/disjointness of the centre of every
                               stage, over the whole of P(W) -- both primes
    scripts/s5_terminus.py     the terminus tables (a), (c), (b)/(d)
                               -- both split primes
    scripts/s6_charts.m2       exact Macaulay2 chart verification, one
                               representative per stage genre -- exact over QQ

Terminal marker on success:  STANDARD_FORM_PW_VERIFY_OK  (and ALLGREEN)
"""
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PY = sys.executable or "/opt/homebrew/bin/python3"
M2 = "/opt/homebrew/bin/M2"

STEPS = [
    ("S1 level-0 atlas of P(W)        (both primes)",
     [PY, "scripts/s1_level0.py"], "S1_LEVEL0_OK"),
    ("S2 nonabelian point strata      (both primes)",
     [PY, "scripts/s2_nonabelian.py"], "S2_NONABELIAN_OK"),
    ("S3 automaton run to acceptance  (exact characters)",
     [PY, "scripts/s3_automaton.py"], "S3_AUTOMATON_OK"),
    ("S4 legality of every stage      (both primes)",
     [PY, "scripts/s4_legality.py"], "S4_LEGALITY_OK"),
    ("S5 terminus tables              (both primes)",
     [PY, "scripts/s5_terminus.py"], "S5_TERMINUS_OK"),
    ("S6 Macaulay2 charts             (exact over QQ)",
     [M2, "--script", "scripts/s6_charts.m2"], "S6_CHARTS_OK"),
]


def main():
    if not os.path.exists(M2):
        print("FAIL: Macaulay2 not found at " + M2)
        return 1
    failures = []
    ncheck = 0
    for name, cmd, marker in STEPS:
        print("-" * 74)
        print("RUN  " + name)
        try:
            r = subprocess.run(cmd, cwd=HERE, capture_output=True, text=True,
                               timeout=7200)
        except Exception as exc:                                   # noqa: BLE001
            print(f"FAIL {name}: {exc}")
            failures.append(name)
            continue
        text = r.stdout + r.stderr
        n = text.count("CHECK ") + text.count("  ok   ")
        ncheck += n
        bad = ("FAIL" in text.replace("FAIL COUNT 0", "")
               .replace("S3_AUTOMATON_FAIL", "").replace("' else 'FAIL'", ""))
        if marker in text and not bad:
            print(f"OK   {name}  [{marker}]  ({n} CHECK lines)")
        else:
            print(f"FAIL {name}  (marker {marker} missing, or a check failed)")
            print(text[-4000:])
            failures.append(name)
    print("=" * 74)
    if failures:
        print("FAILURES: " + ", ".join(failures))
        print("STANDARD_FORM_PW_VERIFY_FAIL")
        return 1
    print(f"all steps passed; {ncheck} CHECK lines, 0 failures")
    print("group and geometry at the two split primes 331 and 661;")
    print("the automaton is exact character arithmetic (prime independent);")
    print("the Macaulay2 charts are exact over QQ.")
    print("ALLGREEN")
    print("STANDARD_FORM_PW_VERIFY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
