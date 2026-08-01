#!/usr/bin/env python3
"""Exact projective landing search in the full A5 covariant spaces, d=5,6,7.

At d=6 the parameter space is P2.  Projective emptiness is checked on the
three standard affine charts by exact Groebner bases over F_89.  At d=5 and
d=7 the parameter spaces are respectively P0 and P1.
"""

from __future__ import annotations

from functools import reduce
import hashlib
import json
from pathlib import Path
import subprocess

import sympy as sp

import build_a5_twists as base
import low_degree_search as low


HERE = Path(__file__).resolve().parent
P = base.PRIME


def landing_equations(space, degree):
    """Return coefficients in y of F(sum a_k C_k), as cubics in the a_k."""
    outputs = [low.output_polynomials(covariant, degree) for covariant in space]
    dimension = len(outputs)
    equations = {}
    for i in range(5):
        j = (i + 1) % 5
        for first in range(dimension):
            for second in range(dimension):
                product = low.pmul(outputs[first][i], outputs[second][i])
                for third in range(dimension):
                    term = low.pmul(product, outputs[third][j])
                    parameter_exponent = tuple(
                        int(first == k) + int(second == k) + int(third == k)
                        for k in range(dimension)
                    )
                    for source_exponent, coefficient in term.items():
                        target = equations.setdefault(source_exponent, {})
                        target[parameter_exponent] = (
                            target.get(parameter_exponent, 0) + coefficient
                        ) % P
    return {
        source: {parameter: coefficient for parameter, coefficient in polynomial.items() if coefficient}
        for source, polynomial in equations.items()
        if any(polynomial.values())
    }


def evaluate_parameter_polynomial(polynomial, values):
    total = 0
    for exponent, coefficient in polynomial.items():
        monomial = coefficient
        for value, power in zip(values, exponent):
            monomial = monomial * pow(value, power, P) % P
        total = (total + monomial) % P
    return total


def expression_on_chart(polynomial, zero_prefix, variables):
    # Chart r has a_0=...=a_{r-1}=0, a_r=1.
    terms = []
    for exponent, coefficient in polynomial.items():
        if any(exponent[index] for index in range(zero_prefix)):
            continue
        coefficient %= P
        if not coefficient:
            continue
        signed = coefficient if coefficient <= P // 2 else coefficient - P
        factors = []
        for name, power in zip(variables, exponent[zero_prefix + 1:]):
            if power:
                factors.append(name if power == 1 else f"{name}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(f"({signed})*{monomial}")
    return "+".join(terms) if terms else "0"


def singular_chart(label, equations, dimension, chart):
    variable_names = [f"a{index}" for index in range(chart + 1, dimension)]
    nonzero = []
    for polynomial in equations.values():
        expression = expression_on_chart(polynomial, chart, variable_names)
        if expression != "0":
            nonzero.append(expression)
    if not variable_names:
        point = tuple([0] * chart + [1])
        unit = any(
            evaluate_parameter_polynomial(polynomial, point)
            for polynomial in equations.values()
        )
        return {
            "chart": chart,
            "unit_ideal": unit,
            "equation_count": len(nonzero),
            "input": None,
            "transcript": None,
        }
    input_path = HERE / f"{label}_chart_{chart}.sing"
    output_path = HERE / f"{label}_chart_{chart}.txt"
    input_path.write_text(
        f"ring r={P},({','.join(variable_names)}),dp;\n"
        f"ideal I={','.join(nonzero) if nonzero else '0'};\n"
        "ideal J=std(I);\n"
        'if (reduce(1,J)==0) { print("UNIT"); } else { print("NONUNIT"); J; }\n'
        "quit;\n"
    )
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True,
        capture_output=True,
        text=True,
    )
    output_path.write_text(result.stdout)
    first = result.stdout.splitlines()[0].strip()
    assert first in {"UNIT", "NONUNIT"}, result.stdout[:1000]
    return {
        "chart": chart,
        "unit_ideal": first == "UNIT",
        "equation_count": len(nonzero),
        "input": input_path.name,
        "input_sha256": hashlib.sha256(input_path.read_bytes()).hexdigest(),
        "transcript": output_path.name,
        "transcript_sha256": hashlib.sha256(output_path.read_bytes()).hexdigest(),
    }


def p1_gcd(equations):
    t = sp.symbols("t")
    polynomials = []
    for polynomial in equations.values():
        expression = sum(
            coefficient * t ** exponent[1]
            for exponent, coefficient in polynomial.items()
        )
        candidate = sp.Poly(expression, t, modulus=P)
        if not candidate.is_zero:
            polynomials.append(candidate)
    affine_gcd = reduce(sp.gcd, polynomials).monic()
    infinity_nonzero = any(
        evaluate_parameter_polynomial(polynomial, (0, 1))
        for polynomial in equations.values()
    )
    return [int(value) % P for value in affine_gcd.all_coeffs()], bool(infinity_nonzero)


def class_record(label, a, b):
    amap = base.abstract_isomorphism(a, b)
    source = base.source_representation()
    spaces = {
        degree: low.covariant_basis(degree, (a, b), amap, source)
        for degree in (5, 6, 7)
    }
    dimensions = {str(degree): len(space) for degree, space in spaces.items()}
    assert dimensions == {"5": 1, "6": 3, "7": 2}

    degree5_equations = landing_equations(spaces[5], 5)
    degree5_lands = not degree5_equations

    degree6_equations = landing_equations(spaces[6], 6)
    charts = [
        singular_chart(f"{label.lower()}_degree6", degree6_equations, 3, chart)
        for chart in range(3)
    ]

    degree7_equations = landing_equations(spaces[7], 7)
    gcd, infinity_nonzero = p1_gcd(degree7_equations)

    return {
        "label": label,
        "covariant_dimensions": dimensions,
        "degree_5_lands_on_X": degree5_lands,
        "degree_5_landing_equation_count": len(degree5_equations),
        "degree_6_parameter_space": "P2",
        "degree_6_chart_certificates": charts,
        "degree_6_geometric_landing_scheme_empty_mod_89": all(chart["unit_ideal"] for chart in charts),
        "degree_6_landing_equation_count": len(degree6_equations),
        "degree_7_parameter_space": "P1",
        "degree_7_affine_landing_gcd_mod_89": gcd,
        "degree_7_point_at_infinity_lands": not infinity_nonzero,
        "degree_7_geometric_landing_scheme_empty_mod_89": gcd == [1] and infinity_nonzero,
        "degree_7_landing_equation_count": len(degree7_equations),
    }


def main():
    records = [
        class_record(f"A5_class_{index}", a, b)
        for index, (a, b, _subgroup) in enumerate(base.two_a5_classes(), 1)
    ]
    payload = {
        "format": "klein-a5-degree5-7-landing-v1",
        "prime": P,
        "scope": "complete homogeneous A5-covariant parameter spaces in degrees 5, 6, and 7",
        "characteristic_zero_transfer": (
            "Maschke base change at p=89 and properness of each projective landing scheme: "
            "geometric emptiness of the special fibre implies emptiness in characteristic zero"
        ),
        "records": records,
    }
    output = HERE / "a5_degree5_7_search.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    for record in records:
        print(record["label"], {
            "d5_lands": record["degree_5_lands_on_X"],
            "d6_empty": record["degree_6_geometric_landing_scheme_empty_mod_89"],
            "d7_empty": record["degree_7_geometric_landing_scheme_empty_mod_89"],
        })
    print("A5_DEGREE5_7_SEARCH_OK")


if __name__ == "__main__":
    main()
