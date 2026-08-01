#!/usr/bin/env python3
"""Exact projective landing search in the full A5 covariant spaces, d=8,9."""

from __future__ import annotations

import json
from pathlib import Path

import build_a5_twists as base
import low_degree_search as low
from a5_degree5_7_search import landing_equations, singular_chart


HERE = Path(__file__).resolve().parent
P = base.PRIME


def class_record(label, a, b):
    amap = base.abstract_isomorphism(a, b)
    source = base.source_representation()
    records = {}
    for degree, expected_dimension in ((8, 5), (9, 3)):
        space = low.covariant_basis(degree, (a, b), amap, source)
        assert len(space) == expected_dimension
        equations = landing_equations(space, degree)
        charts = [
            singular_chart(
                f"{label.lower()}_degree{degree}",
                equations,
                expected_dimension,
                chart,
            )
            for chart in range(expected_dimension)
        ]
        records[str(degree)] = {
            "covariant_dimension": expected_dimension,
            "parameter_space": f"P{expected_dimension - 1}",
            "landing_equation_count": len(equations),
            "chart_certificates": charts,
            "geometric_landing_scheme_empty_mod_89": all(
                chart["unit_ideal"] for chart in charts
            ),
        }
        print(
            label,
            f"degree_{degree}",
            "empty=",
            records[str(degree)]["geometric_landing_scheme_empty_mod_89"],
            flush=True,
        )
    return {"label": label, "degrees": records}


def main():
    records = [
        class_record(f"A5_class_{index}", a, b)
        for index, (a, b, _subgroup) in enumerate(base.two_a5_classes(), 1)
    ]
    payload = {
        "format": "klein-a5-degree8-9-landing-v1",
        "prime": P,
        "scope": "complete homogeneous A5-covariant parameter spaces in degrees 8 and 9",
        "characteristic_zero_transfer": (
            "Maschke base change at p=89 and properness of each projective landing scheme: "
            "geometric emptiness of the special fibre implies emptiness in characteristic zero"
        ),
        "records": records,
    }
    output = HERE / "a5_degree8_9_search.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("A5_DEGREE8_9_SEARCH_OK")


if __name__ == "__main__":
    main()
