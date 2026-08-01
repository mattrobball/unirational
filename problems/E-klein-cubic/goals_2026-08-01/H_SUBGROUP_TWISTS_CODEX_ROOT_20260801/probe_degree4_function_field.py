#!/usr/bin/env python3
"""Factor the complete degree-four two-covariant landing cubic over F_89(y)."""

from __future__ import annotations

from pathlib import Path
import hashlib
import json
import subprocess

import sympy as sp

import build_a5_twists as base
import low_degree_search as low


HERE = Path(__file__).resolve().parent


def landing_expression(first, second):
    compositions = [
        low.klein_composition(low.combine(first, second, value), 4)
        for value in range(4)
    ]
    exponents = sorted(set().union(*(item.keys() for item in compositions)))
    t, y0, y1, y2 = sp.symbols("t y0 y1 y2")
    ys = (y0, y1, y2)
    expression = 0
    for exponent in exponents:
        coefficients = low.interpolate_cubic([
            item.get(exponent, 0) for item in compositions
        ])
        coefficient = sum(value * t**power for power, value in enumerate(coefficients))
        expression += coefficient * sp.prod(y**power for y, power in zip(ys, exponent))
    return (t, y0, y1, y2), sp.Poly(expression, t, y0, y1, y2, modulus=base.PRIME)


def main():
    assert all((value**3 + value + 4) % base.PRIME for value in range(base.PRIME))
    records = []
    for index, (a, b, subgroup) in enumerate(base.two_a5_classes(), 1):
        amap = base.abstract_isomorphism(a, b)
        source = base.source_representation()
        space = low.covariant_basis(4, (a, b), amap, source)
        assert len(space) == 2
        variables, polynomial = landing_expression(*space)
        expression = str(polynomial.as_expr()).replace("**", "^")
        singular_input = HERE / f"degree4_class{index}_factor.sing"
        singular_input.write_text(
            "ring r=89,(t,y0,y1,y2),dp;\n"
            f"poly f={expression};\n"
            "list fac=factorize(f,1);\n"
            "fac;\n"
            "quit;\n"
        )
        result = subprocess.run(
            ["/opt/homebrew/bin/Singular", "-q", str(singular_input)],
            check=True,
            capture_output=True,
            text=True,
        )
        transcript = HERE / f"degree4_class{index}_factor.txt"
        transcript.write_text(result.stdout)
        # factorize(f,1) returns the ideal of irreducible factors.  A single
        # generator and no second entry certify absolute factor count one
        # over the finite base field used by Singular.
        assert result.stdout.startswith("[1]:")
        assert "_[2]=" not in result.stdout
        extension_input = HERE / f"degree4_class{index}_factor_f89cubic.sing"
        extension_input.write_text(
            "ring r=(89,a),(t,y0,y1,y2),dp;\n"
            "minpoly=a^3+a+4;\n"
            f"poly f={expression};\n"
            "list fac=factorize(f,1);\n"
            "fac;\n"
            "quit;\n"
        )
        extension_result = subprocess.run(
            ["/opt/homebrew/bin/Singular", "-q", str(extension_input)],
            check=True,
            capture_output=True,
            text=True,
        )
        extension_transcript = HERE / f"degree4_class{index}_factor_f89cubic.txt"
        extension_transcript.write_text(extension_result.stdout)
        assert extension_result.stdout.startswith("[1]:")
        assert "_[2]=" not in extension_result.stdout
        print(f"class={index} total_terms={len(polynomial.terms())}")
        print("irreducible_factor_count=1")
        records.append({
            "label": f"A5_class_{index}",
            "prime": base.PRIME,
            "total_terms": len(polynomial.terms()),
            "t_degree": polynomial.degree(variables[0]),
            "irreducible_factor_count": 1,
            "f89_cubic_extension_factor_count": 1,
            "geometrically_irreducible": True,
            "singular_input": singular_input.name,
            "singular_input_sha256": hashlib.sha256(singular_input.read_bytes()).hexdigest(),
            "singular_transcript": transcript.name,
            "singular_transcript_sha256": hashlib.sha256(transcript.read_bytes()).hexdigest(),
            "extension_input": extension_input.name,
            "extension_input_sha256": hashlib.sha256(extension_input.read_bytes()).hexdigest(),
            "extension_transcript": extension_transcript.name,
            "extension_transcript_sha256": hashlib.sha256(extension_transcript.read_bytes()).hexdigest(),
        })
    summary = {
        "format": "klein-a5-degree4-function-field-v1",
        "scope": (
            "the complete two-dimensional degree-four covariant frame; a base-field "
            "irreducible t-cubic can only acquire a t-linear factor in the cubic constant "
            "extension, where it remains irreducible"
        ),
        "records": records,
    }
    (HERE / "degree4_function_field.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n"
    )
    print("A5_DEGREE4_FUNCTION_FIELD_PROBE_OK")


if __name__ == "__main__":
    main()
