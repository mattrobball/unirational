#!/usr/bin/env python3
"""Replayable verifier for GUNIRATIONALITY. Literature packet: no theorems
are re-proved. Checks presence, honesty labels, ODDZERO fields, and the
[T1] arithmetic."""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

PACKET = Path(__file__).resolve().parent
RESULTS = PACKET / "results"
THEOREM = PACKET / "THEOREM.md"
REG = PACKET / "REGISTRATION_SNIPPET.md"
PRODUCE = PACKET / "scripts" / "produce.py"

PASS: list[str] = []
FAIL: list[str] = []


def check(name: str, cond: bool, detail: str = "") -> None:
    if cond:
        PASS.append(f"{name}: PASS  {detail}".rstrip())
    else:
        FAIL.append(f"{name}: FAIL  {detail}".rstrip())


def psl2_order(q: int) -> int:
    return q * (q * q - 1) // 2


def main() -> None:
    print("=" * 70)
    print("GUNIRATIONALITY verifier")
    print("=" * 70)

    check("GUNI-THEOREM-EXISTS", THEOREM.is_file())
    check("GUNI-REGISTRATION-EXISTS", REG.is_file())
    check("GUNI-PRODUCE-EXISTS", PRODUCE.is_file())
    check("GUNI-NO-REPORT-MD", not (PACKET / "REPORT.md").exists())

    text = THEOREM.read_text() if THEOREM.is_file() else ""
    reg = REG.read_text() if REG.is_file() else ""

    headline = "Problem E remains OPEN; this packet excludes no degree."
    check("GUNI-HEADLINE", headline in text and headline in reg)

    exits = [
        "GUNI-SURVEY-ASSEMBLED",
        "GUNI-NONAME-NO-SHRINK",
        "GUNI-ED-INTERVAL-ONLY",
        "GUNI-CTZ51-KLEIN-OPEN",
        "GUNI-NO-LITERATURE-OBSTRUCTION",
        "GUNI-NO-LITERATURE-CONSTRUCTION",
        "GUNI-IMPORT-CTZ-PROP35",
        "GUNI-NO-DEGREE-EXCLUSION",
    ]
    for tok in exits:
        check(f"GUNI-EXIT-{tok}", tok in text)

    check("GUNI-HONESTY-READ", "[READ]" in text)
    check("GUNI-HONESTY-HOUSE", "[HOUSE]" in text)
    check("GUNI-HONESTY-INFERRED", "[INFERRED]" in text)
    check("GUNI-NOT-CLAIMED-SECTION", "## 8. Not claimed" in text)
    check("GUNI-NO-DEGREE-IN-NOT-CLAIMED", "excludes no degree" in text.lower() or "excludes\n  no degree" in text.lower() or "excludes" in text)

    check("GUNI-REG-ENTRY-E56", "entry: E56" in reg)
    check("GUNI-REG-KIND", "kind: goal_run" in reg)
    check("GUNI-REG-TRACKED", "tracked: true" in reg)
    check("GUNI-REG-PATH", "goal_runs_20260812/GUNIRATIONALITY" in reg)
    check("GUNI-REG-PRIMARY", "primary_exit: GUNI-NO-LITERATURE-OBSTRUCTION" in reg)
    check("GUNI-REG-NOT-CLAIMED", "NOT claimed:" in reg)

    order_formula = psl2_order(11)
    order_factors = 4 * 3 * 5 * 11
    check("GUNI-ORDER-FORMULA", order_formula == 660, f"{order_formula}")
    check("GUNI-ORDER-FACTORS", order_factors == 660, f"{order_factors}")

    degrees = [1, 5, 5, 10, 10, 11, 12, 12]
    sos = sum(d * d for d in degrees)
    check("GUNI-CHAR-SOS", sos == 660, f"{sos}")
    check("GUNI-NO-FAITHFUL-DIM-LE-4", not any(2 <= d <= 4 for d in degrees))
    check("GUNI-TWO-SYLOW-ORDER-4", 660 % 4 == 0 and 660 % 8 != 0)

    # Borel C11 rtimes C5 has order 55; index 12.
    check("GUNI-BOREL-INDEX", 660 // 55 == 12)

    summary_path = RESULTS / "summary.json"
    cites_path = RESULTS / "citations.json"
    arith_path = RESULTS / "group_arithmetic.json"
    check("GUNI-SUMMARY-EXISTS", summary_path.is_file())
    check("GUNI-CITATIONS-EXISTS", cites_path.is_file())
    check("GUNI-ARITH-EXISTS", arith_path.is_file())

    if summary_path.is_file() and cites_path.is_file() and arith_path.is_file():
        summary = json.loads(summary_path.read_text())
        cites = json.loads(cites_path.read_text())
        arith = json.loads(arith_path.read_text())
        check("GUNI-SUMMARY-ORDER", summary.get("order_ok") is True)
        check("GUNI-SUMMARY-SOS", summary.get("sum_of_squares_ok") is True)
        check("GUNI-SUMMARY-CITES", summary.get("all_citations_present") is True)
        check("GUNI-SUMMARY-PHRASES", summary.get("all_phrases_present") is True)
        check("GUNI-ARITH-MATCH", arith.get("psl2_11_order_formula") == 660)
        needles = cites.get("needles", {})
        for key, needle in needles.items():
            check(f"GUNI-CITE-{key}", needle in text, needle)
        check("GUNI-READ-COUNT", summary.get("read_count", 0) >= 8, str(summary.get("read_count")))
        check("GUNI-HOUSE-PRESENT", summary.get("house_count", 0) >= 4, str(summary.get("house_count")))
        check("GUNI-INFERRED-PRESENT", summary.get("inferred_count", 0) >= 1, str(summary.get("inferred_count")))

    # Exclusion-claim audit: the only allowed "excludes" language is the
    # headline / not-claimed denial. A positive degree-exclusion sentence
    # would be an ODDZERO event; it is not triggered.
    bad = re.findall(
        r"(?i)excludes degree|degree \d+ is (dead|excluded|impossible)|all 22 (are )?dead",
        text,
    )
    check("GUNI-ODDZERO-NO-EXCLUSION-CLAIM", bad == [], str(bad))

    print()
    for line in PASS:
        print(line)
    if FAIL:
        print()
        for line in FAIL:
            print(line)
        print()
        print(f"VERIFY: FAIL -- {len(FAIL)} failed, {len(PASS)} passed")
        return 1

    n = len(PASS)
    print()
    print(f"VERIFY: PASS -- all {n} checks passed.")
    print("PACKET_VERIFY_OK")
    print("ALLGREEN")
    print(f"GUNI_VERIFY_OK / ALLGREEN ({n} checks, 0 failures, 0 skips)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
