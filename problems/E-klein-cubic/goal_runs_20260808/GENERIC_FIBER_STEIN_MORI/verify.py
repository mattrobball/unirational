#!/usr/bin/env python3
"""Static replay for the generic-fibre/Stein-Mori theorem packet.

This checks the installed formulas and the finite arithmetic in the explicit
weighted-projective counterexample.  It does not pretend to machine-check the
birational-geometric implications in THEOREM.md.
"""

import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent
BASE = ROOT.parent.parent
THEOREM = (ROOT / "THEOREM.md").read_text()
STATUS = (ROOT / "STATUS.md").read_text()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise SystemExit(f"FAIL: {message}")


markers = [
    "FULL-G-QUOTIENT-DEGREE-EQUALS-RESTRICTION-DEGREE",
    "FULL-G-GENERIC-FIBRE-THREE-EXACT-IDENTITIES",
    "FULL-G-STEIN-MORI-CONDITIONAL-DEGREE-ONE",
    "FULL-G-GALOIS-CANONICAL-GRAPH-DEGREE-ONE",
    "FULL-G-DEGREE-TWO-EXCLUDED-BY-DECK-INVOLUTION",
    "FULL-G-GALOIS-DEGREES-TWO-THROUGH-ELEVEN-EXCLUDED",
    "FULL-G-STEIN-MORI-HYPOTHESES-NOT-FORCED",
    "HEADLINE-OPEN",
]

for marker in markers:
    require(marker in THEOREM, f"THEOREM missing {marker}")

for marker in markers[2:]:
    require(marker in STATUS, f"STATUS missing {marker}")

# Replay the low-degree invariant input used for the branch bound.  The
# certified Hironaka presentation is free over primaries of degrees
# (3,5,6,8,11), and every nontrivial secondary starts in degree seven.
generic = json.loads(
    (BASE / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json").read_text()
)
require(generic["primary_degrees"] == [3, 5, 6, 8, 11],
        "unexpected primary invariant degrees")
require(generic["secondary_degrees"][0] == 0,
        "the unit secondary is missing")
require(min(generic["secondary_degrees"][1:]) >= 7,
        "a nontrivial secondary occurs below degree seven")

# The first branch-orbit has integral degree at least five and every Galois
# orbifold coefficient is at least one half, so K_X + Delta has coefficient
# at least -2 + 5/2 = 1/2 against H.
require(-2 + 5 / 2 > 0, "Galois branch canonical coefficient is not positive")

# In P(1,1,1,n), the chart map (a,b,c) -> (a^n,b^n,c) has degree n^2,
# and the vertex age 3/n is below one from n=4 onward.
for n in range(4, 13):
    require(n * n > 1, f"weighted-projective cover degree failed at n={n}")
    require(3 / n < 1, f"weighted-projective age failed at n={n}")

# The nonequivariant cubic sanity check is 3a = delta + correction with
# (a, delta, correction) = (2, 4, 2).
require(3 * 2 == 4 + 2, "ambient cubic intersection sanity check failed")

print("FULL-G-GENERIC-FIBER-STEIN-MORI-PACKET-OK")
print("CAVEAT-STATIC-REPLAY-NOT-A-MACHINE-PROOF-OF-BIRATIONAL-GEOMETRY")
