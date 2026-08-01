#!/usr/bin/env python3
"""Check the exact numerical and scope boundaries in THEOREM_SEARCH.md."""

from __future__ import annotations

import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
payload = json.loads((HERE / "theorem_search_payload.json").read_text())
report = (HERE / "THEOREM_SEARCH.md").read_text()

assert payload["schema"] == "q-schur-residue-theorem-search-v1"
assert payload["status"].endswith("NONTERMINAL")

cubic = payload["cubic"]
d = cubic["degree"]
n = cubic["ambient_projective_dimension"]
variables = cubic["variables"]
assert (d, n, variables, cubic["dimension"]) == (3, 4, 5, 3)

published = payload["rsc_bounds"]["published"]
variant = payload["rsc_bounds"]["advertised_variant"]
assert published == {"left": d**2, "right": n, "holds": d**2 <= n}
assert variant == {"left": d**2, "right": n + 1, "holds": d**2 <= n + 1}
assert not published["holds"] and not variant["holds"]

for row in payload["tsen_lang"]:
    t = row["residue_transcendence_degree"]
    threshold = d**t
    assert row["variables"] == variables
    assert row["required_strict_lower_bound"] == threshold
    assert row["holds"] == (variables > threshold)
    assert not row["holds"]

degrees = payload["index_one"]["known_closed_point_degrees"]
assert degrees == [3, 55]
assert math.gcd(*degrees) == 1
assert math.gcd(payload["index_one"]["prime_to_cubic_degree_point"], d) == 1

for marker in (
    "9 <= 4  (false)",
    "9 <= 5  (false)",
    "5 > 3^2=9   (false)",
    "5 > 3^3=27  (false)",
    "Cassels--Swinnerton-Dyer",
    "Y(k)\\;=\\;\\operatorname{Hom}_D(T,X)",
    "not a proof that any residue twist is pointless",
):
    assert marker in report, marker

print("PASS cubic-threefold dimensions and degree")
print("PASS rational-simple-connectedness bound failures")
print("PASS C2 and C3 Tsen--Lang threshold failures")
print("PASS degree-55 premise is prime to three")
print("PASS isotrivial descent and strict nonclaim markers")
print("Q_RESIDUE_THEOREM_SEARCH_ACCEPT")
