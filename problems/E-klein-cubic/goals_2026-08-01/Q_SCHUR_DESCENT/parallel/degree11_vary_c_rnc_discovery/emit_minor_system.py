#!/usr/bin/env python3
"""Emit a small necessary-minor system for geometric rank <= 9.

Three 10x10 minors are enough for an exclusion if their projective common
zero locus is empty.  This is an attempted exact upgrade of the F_89 scan;
failure or timeout has no mathematical consequence.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import search


HERE = Path(__file__).resolve().parent
SEC = search.SEC
BASE = search.BASE
P = search.P


def add_polynomial(left, right, scalar=(1, 0)):
    out = dict(left)
    for exponent, coefficient in right.items():
        product = search.fp2_mul(coefficient, scalar)
        old = out.get(exponent, (0, 0))
        value = ((old[0] + product[0]) % P, (old[1] + product[1]) % P)
        if value == (0, 0):
            out.pop(exponent, None)
        else:
            out[exponent] = value
    return out


def source_polynomials(covariants, parameters):
    parameters = [SEC.F89x2.coerce(value) for value in parameters]
    answer = []
    for output in range(5):
        polynomial = {}
        for scalar, covariant in zip(parameters, covariants):
            coefficients = {
                exponent: (coefficient, 0)
                for exponent, coefficient in covariant[output].items()
            }
            polynomial = add_polynomial(
                polynomial, coefficients, (scalar.a, scalar.b)
            )
        answer.append(polynomial)
    return answer


def target_polynomials(source, transform):
    answer = []
    for output in range(5):
        polynomial = {}
        for index in range(5):
            polynomial = add_polynomial(
                polynomial, source[index], (transform[output][index] % P, 0)
            )
        answer.append(polynomial)
    return answer


def coefficient_string(coefficient):
    a, b = coefficient
    if not b:
        return str(a)
    return f"({a}+{b}*u)"


def linear_string(row):
    terms = [f"{value % P}*c{index}" for index, value in enumerate(row) if value % P]
    return "(" + "+".join(terms or ["0"]) + ")"


def substitute_string(polynomial, frame):
    linear = [linear_string(row) for row in frame]
    terms = []
    for exponent, coefficient in sorted(polynomial.items()):
        factors = [coefficient_string(coefficient)]
        factors += [f"{linear[index]}^{degree}" for index, degree in enumerate(exponent) if degree]
        terms.append("*".join(factors))
    return "(" + "+".join(terms or ["0"]) + ")"


def map_expressions(record, parameters, covariants):
    subgroup = tuple(tuple(value) for value in record["subgroup_elements"])
    generators = tuple(tuple(value) for value in record["generators"])
    abstract_map = {
        tuple(row["h"]): tuple(row["permutation"]) for row in record["source_map"]
    }
    intertwiner = BASE.ambient_intertwiner(generators, abstract_map)
    representatives = BASE.right_coset_representatives(subgroup)
    vector = (1, 4, 5, 5, 6)
    source = source_polynomials(covariants, parameters)
    expressions = []
    for representative in representatives:
        moved = BASE.mat_vec(
            BASE.PRODUCE.RHO[BASE.PRODUCE.ginv(representative)], vector
        )
        frame = BASE.transfer_frame(moved, subgroup, abstract_map)
        transform = BASE.mat_mul(BASE.PRODUCE.RHO[representative], intertwiner)
        target = target_polynomials(source, transform)
        expressions.append([substitute_string(polynomial, frame) for polynomial in target])
    return expressions


def numeric_points(record, parameters, covariants, constant=(1, 0, 0)):
    subgroup = tuple(tuple(value) for value in record["subgroup_elements"])
    generators = tuple(tuple(value) for value in record["generators"])
    abstract_map = {
        tuple(row["h"]): tuple(row["permutation"]) for row in record["source_map"]
    }
    intertwiner = BASE.ambient_intertwiner(generators, abstract_map)
    representatives = BASE.right_coset_representatives(subgroup)
    vector = (1, 4, 5, 5, 6)
    points = []
    for representative in representatives:
        moved = BASE.mat_vec(
            BASE.PRODUCE.RHO[BASE.PRODUCE.ginv(representative)], vector
        )
        frame = BASE.transfer_frame(moved, subgroup, abstract_map)
        source_point = BASE.mat_vec(frame, constant)
        canonical = BASE.canonical_point(source_point, parameters, covariants)
        raw = BASE.mat_vec(intertwiner, canonical)
        points.append(BASE.mat_vec(BASE.PRODUCE.RHO[representative], raw))
    return points


def quadric_numeric_rows(points):
    return [BASE.quadric_row(point) for point in points]


def pivot_columns(matrix):
    work = [[SEC.F89x2.coerce(value) for value in row] for row in matrix]
    pivot_row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next((row for row in range(pivot_row, len(work)) if work[row][column]), None)
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = work[pivot_row][column].inverse()
        work[pivot_row] = [value * inverse for value in work[pivot_row]]
        for row in range(pivot_row + 1, len(work)):
            scalar = work[row][column]
            if scalar:
                work[row] = [a - scalar * b for a, b in zip(work[row], work[pivot_row])]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(work):
            break
    return pivots


def matrix_assignment(name, entries):
    flattened = [entry for row in entries for entry in row]
    return f"matrix {name}[10][10]={','.join(flattened)};"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--map-index", type=int, default=0, choices=range(5))
    args = parser.parse_args()
    twists = json.loads((BASE.SUBGROUP / "twists.json").read_text())
    covariants = BASE.load_covariants()
    maps = [
        (twists["records"][0], -1, SEC.class1_roots()[0], "class1_root0"),
        (twists["records"][0], -1, SEC.class1_roots()[1], "class1_root1_fp2"),
        (twists["records"][1], 1, SEC.class2_roots()[0], "class2_root0"),
        (twists["records"][1], 1, SEC.class2_roots()[1], "class2_root1"),
        (twists["records"][1], 1, SEC.class2_roots()[2], "class2_root2"),
    ]
    record, radical_sign, root, label = maps[args.map_index]
    parameters = SEC.parameter_vector(radical_sign, root)
    expressions = map_expressions(record, parameters, covariants)
    points = numeric_points(record, parameters, covariants)
    rows = quadric_numeric_rows(points)
    quadratic_expressions = [
        [expressions[orbit][i] + "*" + expressions[orbit][j] for i in range(5) for j in range(i, 5)]
        for orbit in range(11)
    ]
    minors = []
    metadata = []
    for minor_index, dropped_row in enumerate((0, 1, 2)):
        selected_rows = [index for index in range(11) if index != dropped_row]
        selected_numeric = [rows[index] for index in selected_rows]
        columns = pivot_columns(selected_numeric)
        assert len(columns) == 10
        entries = [[quadratic_expressions[row][column] for column in columns] for row in selected_rows]
        name = f"M{minor_index}"
        minors.append(matrix_assignment(name, entries) + f" poly f{minor_index}=det({name});")
        metadata.append({"dropped_row": dropped_row, "columns": columns})
    code = [
        "option(redSB);",
        "ring r=(89,u),(c0,c1,c2),dp;",
        "minpoly=u2-65;",
        *minors,
        'print("MINOR0_TERMS"); print(size(f0));',
        'print("MINOR1_TERMS"); print(size(f1));',
        'print("MINOR2_TERMS"); print(size(f2));',
        "ideal I=f0,f1,f2;",
        'ideal C0=I,c0-1; ideal G0=std(C0); print("CHART0_DIM"); print(dim(G0)); print("CHART0_VDIM"); print(vdim(G0));',
        'ideal C1=I,c0,c1-1; ideal G1=std(C1); print("CHART1_DIM"); print(dim(G1)); print("CHART1_VDIM"); print(vdim(G1));',
        'ideal C2=I,c0,c1,c2-1; ideal G2=std(C2); print("CHART2_DIM"); print(dim(G2)); print("CHART2_VDIM"); print(vdim(G2));',
        "exit;",
    ]
    output = HERE / f"minor_system_{label}.sing"
    output.write_text("\n".join(code) + "\n")
    metadata_payload = {
        "label": label,
        "map_index": args.map_index,
        "root": SEC.field_to_json(root),
        "parameters": SEC.vector_to_json(parameters),
        "minors": metadata,
        "necessary_condition": "rank<=9 implies f0=f1=f2=0",
    }
    (HERE / f"minor_system_{label}.json").write_text(
        json.dumps(metadata_payload, indent=2, sort_keys=True) + "\n"
    )
    print("WROTE", output)


if __name__ == "__main__":
    main()
