#!/usr/bin/env python3
"""Emit Singular inputs for base scheme, generic fibre, and moving degree."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import emit_minor_system as emit
import search


HERE = Path(__file__).resolve().parent
SEC = search.SEC
BASE = search.BASE
P = search.P


def coefficient(value):
    value = SEC.F89x2.coerce(value)
    if not value.b:
        return str(value.a)
    return f"({value.a}+{value.b}*u)"


def q_strings(covariants, parameters):
    polynomials = emit.source_polynomials(covariants, parameters)
    identity = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    return [emit.substitute_string(polynomial, identity) for polynomial in polynomials]


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
    _record, radical_sign, root, label = maps[args.map_index]
    parameters = SEC.parameter_vector(radical_sign, root)
    q = q_strings(covariants, parameters)
    source_point = (1, 2, 3)
    target_point = BASE.canonical_point(source_point, parameters, covariants)
    assert any(target_point)
    pivot = next(index for index, value in enumerate(target_point) if value)
    fibre = [
        f"{coefficient(target_point[pivot])}*{q[index]}"
        f"-{coefficient(target_point[index])}*{q[pivot]}"
        for index in range(5)
        if index != pivot
    ]
    linear1 = "+".join(f"{index + 1}*{q[index]}" for index in range(5))
    weights2 = (2, 5, 7, 11, 13)
    linear2 = "+".join(f"{weights2[index]}*{q[index]}" for index in range(5))
    code = [
        'LIB "elim.lib";',
        "option(redSB);",
        "ring r=(89,u),(c0,c1,c2),dp;",
        "minpoly=u2-65;",
        f"ideal B={','.join(q)}; ideal BG=std(B);",
        'print("BASE_DIM"); print(dim(BG)); print("BASE_HILB"); hilb(BG,2);',
        f"ideal Fib={','.join(fibre)}; ideal FibSat=sat(Fib,B); ideal FibG=std(FibSat);",
        'print("FIBRE_DIM"); print(dim(FibG)); print("FIBRE_HILB"); hilb(FibG,2);',
        f"ideal Mov={linear1},{linear2}; ideal MovSat=sat(Mov,B); ideal MovG=std(MovSat);",
        'print("MOVING_DIM"); print(dim(MovG)); print("MOVING_HILB"); hilb(MovG,2);',
        "exit;",
    ]
    path = HERE / f"map_degree_{label}.sing"
    path.write_text("\n".join(code) + "\n")
    metadata = {
        "label": label,
        "root": SEC.field_to_json(root),
        "parameters": SEC.vector_to_json(parameters),
        "fibre_source_point": list(source_point),
        "fibre_target_point": SEC.vector_to_json(target_point),
        "fibre_pivot": pivot,
        "moving_linear_weights": [[1, 2, 3, 4, 5], list(weights2)],
    }
    (HERE / f"map_degree_{label}.json").write_text(
        json.dumps(metadata, indent=2, sort_keys=True) + "\n"
    )
    print("WROTE", path)


if __name__ == "__main__":
    main()
