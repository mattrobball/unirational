#!/usr/bin/env python3
"""Compare `#print axioms` output against a permitted axiom SET.

    python3 scripts/check_axiom_sets.py <permitted> <audited> <lean-output-file>

`permitted` and `audited` are comma-separated. Both lists come from
`comparator.json` by way of `scripts/check_module_invariants.sh`; nothing here
knows a theorem name or an axiom name.

Why this is not a `grep`: `#print axioms` wraps its list over several lines and
makes no promise about the order it prints them in, so the previous gate
compared the whole flattened string against one fixed spelling
(`[propext,Classical.choice,Quot.sound]`). That passes and fails for the wrong
reasons — a reordering fails a correct tree, and a *fourth* axiom appended in a
line the flattening dropped would have passed a wrong one.

Exit 0 iff every audited name printed an axiom set exactly equal to the
permitted set.
"""
from __future__ import annotations

import re
import sys

DEPENDS = re.compile(r"'([^']+)' depends on axioms: \[(.*?)\]", re.S)
NO_AXIOMS = re.compile(r"'([^']+)' does not depend on any axioms")


def main(argv: list[str]) -> int:
    if len(argv) != 4:
        print(__doc__)
        return 2
    permitted = {a for a in argv[1].split(",") if a}
    audited = [n for n in argv[2].split(",") if n]
    text = open(argv[3], encoding="utf8").read()

    if "error:" in text:
        print("  lean reported an error while printing axioms")
        return 1

    seen: dict[str, set[str]] = {}
    for m in DEPENDS.finditer(text):
        seen[m.group(1)] = {a.strip() for a in m.group(2).split(",") if a.strip()}
    for m in NO_AXIOMS.finditer(text):
        seen.setdefault(m.group(1), set())

    rc = 0
    for name in audited:
        if name not in seen:
            print(f"  {name}: NO AXIOM LINE")
            rc = 1
            continue
        got = seen[name]
        if got == permitted:
            print(f"  {name}: OK")
        else:
            print(f"  {name}: MISMATCH  unexpected={sorted(got - permitted)} "
                  f"missing={sorted(permitted - got)}")
            rc = 1
    return rc


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
