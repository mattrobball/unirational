#!/usr/bin/env python3
"""Extract one deterministic Hensel witness for each raw derivative triple."""
from __future__ import annotations

import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
SOURCE = HERE / "all_chart_triples_p101.json"
OUT = HERE / "chart_triple_obstructions.json"


def main() -> None:
    source = json.loads(SOURCE.read_text())
    witnesses = {}
    for row in source["rows"]:
        key = "/".join(row["triple"])
        examples = row["gate_open_extraneous_examples"]
        if key not in witnesses and examples:
            witnesses[key] = {
                "triple": row["triple"],
                "fixed_parameters": {"A": row["A"], "u": row["u"]},
                **examples[0],
            }
    expected = 10
    if len(witnesses) != expected:
        raise RuntimeError(f"expected {expected} triples, found {len(witnesses)}")
    payload = {
        "schema": "klein-t-chart-triple-hensel-obstructions-v1",
        "prime": 101,
        "primitive_P_sha256": source["primitive_P_sha256"],
        "coefficient_pair": ["A", "u"],
        "fibre_variables": ["B", "Y", "Z"],
        "candidate_generators": ["Pu", "PA", "PB", "PY", "PZ"],
        "witnesses": witnesses,
        "theorem": (
            "For every three-subset T of (Pu,PA,PB,PY,PZ), a nonsingular "
            "F_101 point of V(T) has P and every named gate nonzero. "
            "Formal multivariate Hensel over Z_101[[s,t]], with "
            "A=A0+s and u=u0+t, gives a two-parameter characteristic-zero "
            "point of the localized triple outside the full singular scheme, "
            "so no such raw triple is a "
            "valid chart in the (A,u;B,Y,Z) coordinate pair."
        ),
        "scope_exclusions": [
            "linear combinations of singular generators",
            "a different parameter/fibre coordinate pair",
            "the direct full six-generator finite algebra",
        ],
    }
    OUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("CHART_TRIPLE_OBSTRUCTION_PRODUCER_SEALED")


if __name__ == "__main__":
    main()
