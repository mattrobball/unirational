#!/usr/bin/env python3
"""Compute all degree-five projective A4 landing schemes over F_331.

This extends the installed degree-1..4 producer without writing to its
directory.  Each of the three possible projective character multipliers is
covered by all eight standard affine charts of its P7 coefficient space.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
UPSTREAM = PARENT / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
sys.path.insert(0, str(UPSTREAM))

import a4_direct_search as search  # noqa: E402
import produce as base  # noqa: E402


P = search.P


def a4_data():
    first, _ = base.two_a5_classes()
    a, b, a5 = first
    mapping = base.iso(a, b, a5)
    involutions = [g for g in a5 if base.ORDERS[g] == 2]
    v4 = next(
        frozenset({base.ew.fone, x, y, base.gmul(x, y)})
        for index, x in enumerate(involutions)
        for y in involutions[index + 1:]
        if base.gmul(x, y) == base.gmul(y, x)
    )
    a4 = base.normalizer(v4, a5)
    ga, gb = base.gens(a4)
    source = [search.SOURCE_A5[mapping[g]] for g in (ga, gb)]
    quotient_generator = next(g for g in a4 if base.ORDERS[g] == 3)
    cosets = [
        frozenset(base.gmul(v, base.gpow(quotient_generator, exponent)) for v in v4)
        for exponent in range(3)
    ]
    character_exponent = {
        g: next(exponent for exponent, coset in enumerate(cosets) if g in coset)
        for g in a4
    }
    return (ga, gb), source, character_exponent


def chart_expression(polynomial, fixed, dimension):
    terms = []
    for exponent, coefficient in polynomial.items():
        coefficient %= P
        if not coefficient:
            continue
        signed = coefficient if coefficient <= P // 2 else coefficient - P
        factors = []
        for index, power in enumerate(exponent):
            if index == fixed or not power:
                continue
            factors.append(f"p{index}" if power == 1 else f"p{index}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(f"({signed})*{monomial}")
    return "+".join(terms) if terms else "0"


def run_chart(character, fixed, coefficients, dimension):
    variables = [f"p{index}" for index in range(dimension) if index != fixed]
    equations = []
    for polynomial in coefficients:
        expression = chart_expression(polynomial, fixed, dimension)
        if expression != "0":
            equations.append(expression)
    input_path = HERE / f"degree5_character{character}_chart{fixed}.sing"
    output_path = HERE / f"degree5_character{character}_chart{fixed}.txt"
    input_path.write_text(
        f"ring r={P},({','.join(variables)}),dp;\n"
        f"ideal I={','.join(equations) if equations else '0'};\n"
        "ideal J=std(I);\n"
        'if (reduce(1,J)==0) { print("UNIT"); } '
        'else { print("NONUNIT"); print("DIM"); dim(J); print("SIZE"); size(J); }\n'
        "quit;\n"
    )
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True,
        capture_output=True,
        text=True,
    )
    output_path.write_text(result.stdout)
    lines = result.stdout.splitlines()
    assert lines and lines[0] in {"UNIT", "NONUNIT"}, result.stdout[:1000]
    return {
        "chart": fixed,
        "unit_ideal": lines[0] == "UNIT",
        "equation_count": len(equations),
        "input": input_path.name,
        "input_sha256": hashlib.sha256(input_path.read_bytes()).hexdigest(),
        "transcript": output_path.name,
        "transcript_sha256": hashlib.sha256(output_path.read_bytes()).hexdigest(),
        "transcript_lines": lines,
    }


def main():
    generators, source, character_exponent = a4_data()
    records = []
    for character in range(3):
        target = [
            [
                [
                    pow(search.OMEGA, character * character_exponent[g], P) * value % P
                    for value in row
                ]
                for row in search.RHO[g]
            ]
            for g in generators
        ]
        monomials, basis = search.covariant_basis(source, target, 5)
        assert len(basis) == 8
        coefficients = search.landing_coefficients(monomials, basis)
        charts = []
        for fixed in range(len(basis)):
            record = run_chart(character, fixed, coefficients, len(basis))
            charts.append(record)
            print(
                f"character={character} chart={fixed} unit={record['unit_ideal']}",
                flush=True,
            )
        records.append({
            "character_exponent": character,
            "covariant_dimension": len(basis),
            "parameter_space": "P7",
            "source_monomials": len(monomials),
            "landing_coefficient_count": len(coefficients),
            "geometrically_empty_mod_331": all(chart["unit_ideal"] for chart in charts),
            "charts": charts,
        })
    payload = {
        "format": "H2-A4-DEGREE5-GATE-v1",
        "prime": P,
        "zeta11": search.ZETA11,
        "sqrt5": search.SQRT5,
        "omega3": search.OMEGA,
        "scope": "complete degree-five projective A4-equivariant landing schemes for all three character multipliers",
        "records": records,
    }
    (HERE / "degree5_gate.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("H2_A4_DEGREE5_GATE_OK")


if __name__ == "__main__":
    main()
