#!/usr/bin/env python3
"""Interpolate the X-coordinate for the surviving direction screen.

Discovery only.  The direction is

    y/w = (1+u*v)/(t^2*u).

Unique finite-field roots are sampled and compared with Laurent-polynomial
ansatzes in `(t,u,v)` whose coefficients are small polynomial functions of
the base parameters.
"""

from __future__ import annotations

import itertools
import json
import random
from pathlib import Path

import sympy as sp

from model import specialized_cubic, specialized_field
from screen_direction_roots import FF, P, cubic_root, vector


HERE = Path(__file__).resolve().parent
PRIMITIVE = HERE / "payload/global_primitive_u_sextic_exact.tsv"
TARGET_UNIQUE_ROOTS = 140


def primitive_terms():
    with PRIMITIVE.open() as stream:
        next(stream)
        return [tuple(map(int, line.split())) for line in stream]


def irreducible(sample, terms) -> bool:
    u = sp.symbols("u")
    coefficients = [0] * 7
    for a, b, y, z, eu, coefficient in terms:
        coefficients[eu] += (
            coefficient
            * pow(sample["A"], a, P)
            * pow(sample["B"], b, P)
            * pow(sample["Y"], y, P)
            * pow(sample["Z"], z, P)
        )
    polynomial = sp.Poly(sum((value % P) * u**index for index, value in enumerate(coefficients)), u, modulus=P)
    if polynomial.degree() != 6:
        return False
    factors = sp.factor_list(polynomial.as_expr(), modulus=P)[1]
    return len(factors) == 1 and sp.Poly(factors[0][0], u, modulus=P).degree() == 6


def scale(value: int, element):
    return tuple(value * coefficient % P for coefficient in element)


def survivor_root(sample):
    model = specialized_field(sample, P)
    modulus = tuple(int(model.modulus.nth(index)) % P for index in range(7))
    if len(modulus) != 7 or modulus[-1] != 1:
        return None
    field = FF(modulus)
    t, u, v = map(vector, (model.t_element, model.u_element, model.v_element))
    denominator = field.mul(field.mul(t, t), u)
    if denominator == field.zero:
        return None
    direction = field.div(field.add(field.one, field.mul(u, v)), denominator)
    q, r = specialized_cubic(sample, P, 9)
    s2, s3 = field.mul(direction, direction), field.pow(direction, 3)
    linear = field.add(field.add(scale(q[0], s2), scale(q[1], direction)), field.scalar(q[2]))
    constant = field.add(
        field.add(scale(r[0], s3), scale(r[1], s2)),
        field.add(scale(r[2], direction), field.scalar(r[3])),
    )
    has_root, root = cubic_root(field, linear, constant)
    if not has_root or root is None:
        return None
    return field, t, u, v, root


def laurent_exponents(degree: int):
    monomials = [entry for entry in itertools.product(range(degree + 1), repeat=3) if sum(entry) <= degree]
    return sorted({tuple(left[i] - right[i] for i in range(3)) for left in monomials for right in monomials})


def power(field: FF, value, exponent: int):
    return field.pow(value, exponent) if exponent >= 0 else field.pow(field.inv(value), -exponent)


def laurent_values(field: FF, t, u, v, exponents):
    cache = [{e: power(field, value, e) for e in range(-6, 7)} for value in (t, u, v)]
    return [field.mul(cache[0][a], field.mul(cache[1][b], cache[2][c])) for a, b, c in exponents]


def base_monomials(sample, degree: int):
    result = []
    for total in range(degree + 1):
        for a in range(total + 1):
            for b in range(total - a + 1):
                for y in range(total - a - b + 1):
                    z = total - a - b - y
                    value = pow(sample["A"], a, P) * pow(sample["B"], b, P)
                    value *= pow(sample["Y"], y, P) * pow(sample["Z"], z, P)
                    result.append(((a, b, y, z), value % P))
    return result


def solve_incremental(rows, variable_count: int):
    pivots: dict[int, list[int]] = {}
    inconsistent = False
    for original in rows:
        row = list(original)
        for column in sorted(pivots):
            if row[column]:
                scalar = row[column]
                pivot = pivots[column]
                row = [(left - scalar * right) % P for left, right in zip(row, pivot)]
        pivot_column = next((index for index in range(variable_count) if row[index]), None)
        if pivot_column is None:
            if row[-1]:
                inconsistent = True
                break
            continue
        inverse = pow(row[pivot_column], -1, P)
        row = [inverse * value % P for value in row]
        for column, pivot in list(pivots.items()):
            if pivot[pivot_column]:
                scalar = pivot[pivot_column]
                pivots[column] = [(left - scalar * right) % P for left, right in zip(pivot, row)]
        pivots[pivot_column] = row
    solution = None
    if not inconsistent and len(pivots) == variable_count:
        solution = [0] * variable_count
        for column, row in pivots.items():
            solution[column] = row[-1]
    return {"inconsistent": inconsistent, "rank": len(pivots), "solution": solution}


def fit(records, laurent_degree: int, base_degree: int):
    exponents = laurent_exponents(laurent_degree)
    base_labels = [label for label, _ in base_monomials(records[0][0], base_degree)]
    feature_labels = [(base, exponent) for base in base_labels for exponent in exponents]
    rows = []
    for sample, field, t, u, v, root in records:
        lvalues = laurent_values(field, t, u, v, exponents)
        bvalues = dict(base_monomials(sample, base_degree))
        features = [scale(bvalues[base], lvalues[exponents.index(exponent)]) for base, exponent in feature_labels]
        for coordinate in range(6):
            rows.append([feature[coordinate] for feature in features] + [root[coordinate]])
    result = solve_incremental(rows, len(feature_labels))
    payload = {
        "laurent_degree": laurent_degree,
        "base_degree": base_degree,
        "feature_count": len(feature_labels),
        "equation_count": len(rows),
        "rank": result["rank"],
        "inconsistent": result["inconsistent"],
    }
    if result["solution"] is not None:
        payload["nonzero_terms"] = [
            {"base_exponents": base, "tuv_exponents": exponent, "coefficient_mod_67": coefficient}
            for (base, exponent), coefficient in zip(feature_labels, result["solution"])
            if coefficient
        ]
    return payload


def main() -> None:
    terms = primitive_terms()
    generator = random.Random(20260801)
    records = []
    attempts = 0
    while len(records) < TARGET_UNIQUE_ROOTS:
        attempts += 1
        sample = {name: generator.randrange(1, P) for name in ("A", "B", "Y", "Z")}
        if not irreducible(sample, terms):
            continue
        try:
            result = survivor_root(sample)
        except (AssertionError, ZeroDivisionError):
            continue
        if result is None:
            continue
        field, t, u, v, root = result
        records.append((sample, field, t, u, v, root))
        if len(records) % 10 == 0:
            print(f"unique_roots={len(records)} attempts={attempts}", flush=True)

    fits = [fit(records, 3, 0), fit(records, 3, 1), fit(records, 2, 2)]
    payload = {
        "scope": "discovery only",
        "prime": P,
        "direction": "(1+u*v)/(t^2*u)",
        "attempts": attempts,
        "unique_root_samples": [
            {"parameters": sample, "root_u_basis": list(root)}
            for sample, _, _, _, _, root in records
        ],
        "fits": fits,
    }
    (HERE / "survivor_reconstruction_p67.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(fits, indent=2, sort_keys=True))
    print("SURVIVOR_RECONSTRUCTION_SCREEN_DONE")


if __name__ == "__main__":
    main()
