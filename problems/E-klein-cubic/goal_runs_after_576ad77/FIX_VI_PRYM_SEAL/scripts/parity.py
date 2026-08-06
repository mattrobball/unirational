"""Parity gate: the verifier must cover every CHECK the main run recorded, and
both must be all-PASS.  Prints the packet exit name.
"""
import os, sys, json

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(HERE, "results")


def load(fn):
    d = {}
    for ln in open(os.path.join(RES, fn)):
        p = ln.split()
        if len(p) >= 3 and p[0] == "CHECK":
            d[p[1]] = p[2]
    return d


main = load("checks.log")
ver = load("verifier.log")

missing = sorted(set(main) - set(ver))
extra = sorted(set(ver) - set(main))
fail_main = sorted(k for k, v in main.items() if v != "PASS")
fail_ver = sorted(k for k, v in ver.items() if v != "PASS")

ok = not missing and not fail_main and not fail_ver
print(f"main run   : {sum(1 for v in main.values() if v=='PASS')}/{len(main)} PASS")
print(f"verifier   : {sum(1 for v in ver.values() if v=='PASS')}/{len(ver)} PASS")
print(f"uncovered by verifier : {missing or 'none'}")
print(f"verifier-only checks  : {extra or 'none'}")
print(f"failing (main)        : {fail_main or 'none'}")
print(f"failing (verifier)    : {fail_ver or 'none'}")

exit_name = "FIX-VI-PRYM-SEAL-ALLGREEN" if ok else "FIX-VI-PRYM-SEAL-DEVIATION"
print(f"EXIT: {exit_name}")
json.dump({
    "main_checks": main, "verifier_checks": ver,
    "uncovered_by_verifier": missing, "verifier_only": extra,
    "failing_main": fail_main, "failing_verifier": fail_ver,
    "exit": exit_name,
}, open(os.path.join(HERE, "payload", "checks_summary.json"), "w"), indent=1)
sys.exit(0 if ok else 1)
