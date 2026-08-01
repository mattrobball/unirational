#!/usr/bin/env python3
"""Build a five-column A5 covariant frame and factor all ten frame lines.

The primitive degrees are 2,4,5,6,7.  Multipliers of degrees
20,18,17,16,15 make a common homogeneous degree 22 frame.  Every binary
frame section is then factored over F_89[y0,y1,y2]; a t-linear factor would
give a rational-function point on that line.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path
import re
import subprocess

import build_a5_twists as base
import low_degree_search as low


HERE = Path(__file__).resolve().parent
P = base.PRIME
DEGREES = (2, 4, 5, 6, 7)


def invariant_basis(degree, generators, amap, source):
    mons = low.monomials(degree)
    count = len(mons)
    equations = []
    for generator in generators:
        transform = low.monomial_transform(source[amap[generator]], degree)
        for monomial in range(count):
            row = [transform[i][monomial] for i in range(count)]
            row[monomial] = (row[monomial] - 1) % P
            equations.append(row)
    return low.nullspace_mod(equations)


def scalar_polynomial(vector, degree):
    return {
        exponent: coefficient
        for exponent, coefficient in zip(low.monomials(degree), vector)
        if coefficient
    }


def evaluate(polynomial, point):
    return sum(
        coefficient
        * __import__("math").prod(value**power for value, power in zip(point, exponent))
        for exponent, coefficient in polynomial.items()
    ) % P


def evaluate_covariant(covariant, degree, point):
    return [evaluate(component, point) for component in low.output_polynomials(covariant, degree)]


def common_frame(a, b):
    amap = base.abstract_isomorphism(a, b)
    source = base.source_representation()
    spaces = {
        degree: low.covariant_basis(degree, (a, b), amap, source)
        for degree in DEGREES
    }
    assert {degree: len(space) for degree, space in spaces.items()} == {
        2: 1, 4: 2, 5: 1, 6: 3, 7: 2
    }
    q_space = invariant_basis(2, (a, b), amap, source)
    f15_space = invariant_basis(15, (a, b), amap, source)
    assert len(q_space) == len(f15_space) == 1
    q = scalar_polynomial(q_space[0], 2)
    f15 = scalar_polynomial(f15_space[0], 15)

    selected = None
    witness = None
    for choices in itertools.product(*(range(len(spaces[d])) for d in DEGREES)):
        for y0 in range(1, 12):
            for y1 in range(1, 12):
                point = (y0, y1, 1)
                if not evaluate(q, point) or not evaluate(f15, point):
                    continue
                columns = [evaluate_covariant(spaces[d][choice], d, point) for d, choice in zip(DEGREES, choices)]
                matrix = [[columns[column][row] for column in range(5)] for row in range(5)]
                det = base.determinant(matrix)
                if det:
                    selected = choices
                    witness = (point, det)
                    break
            if selected is not None:
                break
        if selected is not None:
            break
    assert selected is not None

    q_powers = {power: low.ppow(q, power) for power in (1, 8, 9, 10)}
    multipliers = (
        q_powers[10],
        q_powers[9],
        low.pmul(f15, q_powers[1]),
        q_powers[8],
        f15,
    )
    frame = []
    for degree, choice, multiplier in zip(DEGREES, selected, multipliers):
        components = low.output_polynomials(spaces[degree][choice], degree)
        common = [low.pmul(multiplier, component) for component in components]
        assert all({sum(exponent) for exponent in component} <= {22} for component in common)
        frame.append(common)
    return frame, selected, witness, q, f15


def line_coefficients(first, second):
    coefficients = [dict() for _ in range(4)]
    for i in range(5):
        j = (i + 1) % 5
        u, v, uj, vj = first[i], second[i], first[j], second[j]
        terms = (
            low.pmul(low.pmul(u, u), uj),
            low.padd(low.pscale(2, low.pmul(low.pmul(u, v), uj)), low.pmul(low.pmul(u, u), vj)),
            low.padd(low.pmul(low.pmul(v, v), uj), low.pscale(2, low.pmul(low.pmul(u, v), vj))),
            low.pmul(low.pmul(v, v), vj),
        )
        for power, term in enumerate(terms):
            coefficients[power] = low.padd(coefficients[power], term)
    return coefficients


def singular_expression(coefficients):
    terms = []
    for t_power, polynomial in enumerate(coefficients):
        for exponent, coefficient in sorted(polynomial.items()):
            coefficient %= P
            signed = coefficient if coefficient <= P // 2 else coefficient - P
            factors = []
            if t_power:
                factors.append("t" if t_power == 1 else f"t^{t_power}")
            for name, power in zip(("y0", "y1", "y2"), exponent):
                if power:
                    factors.append(name if power == 1 else f"{name}^{power}")
            monomial = "*".join(factors) if factors else "1"
            terms.append(f"({signed})*{monomial}")
    return "+".join(terms) if terms else "0"


def t_degree(expression):
    powers = [int(value) for value in re.findall(r"t\^(\d+)", expression)]
    stripped = re.sub(r"t\^\d+", "", expression)
    if re.search(r"(^|[^A-Za-z0-9_])t([^A-Za-z0-9_]|$)", stripped):
        powers.append(1)
    return max(powers, default=0)


def factor_line(label, left, right, coefficients):
    expression = singular_expression(coefficients)
    input_path = HERE / f"{label}.sing"
    input_path.write_text(
        "ring r=89,(t,y0,y1,y2),dp;\n"
        f"poly f={expression};\n"
        "ideal fac=factorize(f,1);\n"
        "fac;\n"
        "quit;\n"
    )
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
        check=True,
        capture_output=True,
        text=True,
    )
    output_path = HERE / f"{label}.txt"
    output_path.write_text(result.stdout)
    def parsed_factors(output):
        factors = []
        for line in output.splitlines():
            match = re.match(r"\s*fac\[(\d+)\]=(.*)", line)
            if match:
                factors.append(match.group(2))
        return factors

    factors = parsed_factors(result.stdout)
    assert factors
    degrees = [t_degree(factor) for factor in factors]
    assert sorted(degree for degree in degrees if degree) == [3]

    extension_input = HERE / f"{label}_f89cubic.sing"
    extension_input.write_text(
        "ring r=(89,a),(t,y0,y1,y2),dp;\n"
        "minpoly=a^3+a+4;\n"
        f"poly f={expression};\n"
        "ideal fac=factorize(f,1);\n"
        "fac;\n"
        "quit;\n"
    )
    extension_result = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q", str(extension_input)],
        check=True,
        capture_output=True,
        text=True,
    )
    extension_output = HERE / f"{label}_f89cubic.txt"
    extension_output.write_text(extension_result.stdout)
    extension_factors = parsed_factors(extension_result.stdout)
    assert extension_factors
    extension_degrees = [t_degree(factor) for factor in extension_factors]
    return {
        "left_column": left,
        "right_column": right,
        "total_terms": sum(len(polynomial) for polynomial in coefficients),
        "factor_count": len(factors),
        "factor_t_degrees": degrees,
        "has_f89_t_linear_factor": 1 in degrees,
        "f89_cubic_extension_factor_count": len(extension_factors),
        "f89_cubic_extension_factor_t_degrees": extension_degrees,
        "has_geometric_t_linear_factor": 1 in extension_degrees,
        "input": input_path.name,
        "input_sha256": hashlib.sha256(input_path.read_bytes()).hexdigest(),
        "transcript": output_path.name,
        "transcript_sha256": hashlib.sha256(output_path.read_bytes()).hexdigest(),
        "extension_input": extension_input.name,
        "extension_input_sha256": hashlib.sha256(extension_input.read_bytes()).hexdigest(),
        "extension_transcript": extension_output.name,
        "extension_transcript_sha256": hashlib.sha256(extension_output.read_bytes()).hexdigest(),
    }


def main():
    assert all((value**3 + value + 4) % P for value in range(P))
    summaries = []
    for class_index, (a, b, subgroup) in enumerate(base.two_a5_classes(), 1):
        frame, selected, witness, q, f15 = common_frame(a, b)
        line_records = []
        for left, right in itertools.combinations(range(5), 2):
            label = f"a5c{class_index}_line_{left}_{right}"
            record = factor_line(label, left, right, line_coefficients(frame[left], frame[right]))
            line_records.append(record)
            print(label, "t_degrees=", record["factor_t_degrees"], flush=True)
        summaries.append({
            "label": f"A5_class_{class_index}",
            "primitive_degrees": list(DEGREES),
            "selected_basis_indices": list(selected),
            "raw_frame_witness": {"point": list(witness[0]), "determinant_mod_89": witness[1]},
            "common_degree": 22,
            "multiplier_degrees": [20, 18, 17, 16, 15],
            "invariant_q_terms": len(q),
            "invariant_f15_terms": len(f15),
            "lines": line_records,
            "geometric_line_rational_function_points_found": sum(
                record["has_geometric_t_linear_factor"] for record in line_records
            ),
        })
    payload = {
        "format": "klein-a5-covariant-line-search-v2",
        "scope": (
            "all ten coordinate lines in a full five-column degree-22 A5 covariant frame; "
            "the unique t-cubic factor is retested over F_89^3, the only possible "
            "constant-field orbit size for an absolute t-linear factor"
        ),
        "records": summaries,
    }
    (HERE / "a5_covariant_line_search.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("A5_COVARIANT_LINE_SEARCH_OK")


if __name__ == "__main__":
    main()
