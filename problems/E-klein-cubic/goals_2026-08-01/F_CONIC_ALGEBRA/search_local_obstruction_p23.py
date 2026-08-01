#!/usr/bin/env python3
"""Search mod 23 for a specialization with no smooth residue point.

This is a discovery screen.  A candidate is useful only after a chosen
23-adic lift is proved locally pointless and the specialized sextic has a
simple linear factor defining a degree-one completion.
"""

from __future__ import annotations

import itertools
import json
from pathlib import Path

import numpy as np

from model import FORMS, _cyclotomic_residue


HERE = Path(__file__).resolve().parent
PRIMITIVE = HERE / "payload/global_primitive_u_sextic_exact.tsv"
P = 23
ZETA = 2


def projective_points() -> list[tuple[int, int, int]]:
    points = [(x, y, 1) for x in range(P) for y in range(P)]
    points += [(x, 1, 0) for x in range(P)]
    points += [(1, 0, 0)]
    return points


def form_coefficients() -> list[list[int]]:
    slots = json.loads(FORMS.read_text())["binary_slots"]

    def row(name: str) -> list[int]:
        return [_cyclotomic_residue(item, P, ZETA) for item in slots[name]]

    q0, qA, qY = row("q0"), row("qA"), row("qY")
    r0, rA, rB, rY, rZ = row("r0"), row("rA"), row("rB"), row("rY"), row("rZ")
    # X^3, X^2y, X^2w, Xy^2, Xyw, Xw^2, y^3, y^2w, yw^2, w^3.
    return [
        [1, 0, 0, *q0, *r0],
        [0, 0, 0, *qA, *rA],
        [0, 0, 0, 0, 0, 0, *rB],
        [0, 0, 0, *qY, *rY],
        [0, 0, 0, 0, 0, 0, *rZ],
    ]


def evaluations():
    points = projective_points()
    coefficients = form_coefficients()
    values = np.zeros((5, len(points)), dtype=np.int16)
    gradients = np.zeros((5, 3, len(points)), dtype=np.int16)
    exponents = (
        (3, 0, 0), (2, 1, 0), (2, 0, 1), (1, 2, 0), (1, 1, 1),
        (1, 0, 2), (0, 3, 0), (0, 2, 1), (0, 1, 2), (0, 0, 3),
    )
    for form, row in enumerate(coefficients):
        for point_index, point in enumerate(points):
            for coefficient, powers in zip(row, exponents):
                monomial = coefficient
                for coordinate, power in zip(point, powers):
                    monomial *= pow(coordinate, power, P)
                values[form, point_index] += monomial % P
                for derivative in range(3):
                    if not powers[derivative]:
                        continue
                    term = coefficient * powers[derivative]
                    for index, (coordinate, power) in enumerate(zip(point, powers)):
                        term *= pow(coordinate, power - (index == derivative), P)
                    gradients[form, derivative, point_index] += term % P
    return values % P, gradients % P


def primitive_roots(A: int, B: int, Y: int, Z: int) -> list[int]:
    coefficients = [0] * 7
    with PRIMITIVE.open() as stream:
        next(stream)
        for line in stream:
            eA, eB, eY, eZ, eu, coefficient = map(int, line.split())
            coefficients[eu] += (
                coefficient
                * pow(A, eA, P)
                * pow(B, eB, P)
                * pow(Y, eY, P)
                * pow(Z, eZ, P)
            )
    coefficients = [value % P for value in coefficients]

    def value(u: int) -> int:
        return sum(coefficient * pow(u, exponent, P) for exponent, coefficient in enumerate(coefficients)) % P

    def derivative(u: int) -> int:
        return sum(exponent * coefficient * pow(u, exponent - 1, P) for exponent, coefficient in enumerate(coefficients) if exponent) % P

    return [u for u in range(P) if value(u) == 0 and derivative(u) != 0]


def main() -> None:
    values, gradients = evaluations()
    candidates = []
    batch_size = 4096
    all_parameters = itertools.product(range(P), repeat=4)
    inv18 = pow(18, -1, P)
    while True:
        batch = list(itertools.islice(all_parameters, batch_size))
        if not batch:
            break
        parameters = np.asarray(batch, dtype=np.int16)
        coefficients = np.column_stack((np.ones(len(batch), dtype=np.int16), parameters))
        fibre_values = (coefficients @ values) % P
        fibre_gradients = np.einsum("bf,fdp->bdp", coefficients, gradients) % P
        smooth = (fibre_values == 0) & np.any(fibre_gradients != 0, axis=1)
        for index in np.flatnonzero(~np.any(smooth, axis=1)):
            A, B, Y, T = map(int, parameters[index])
            Z = (T + 11 * inv18 * A * A) % P
            roots = primitive_roots(A, B, Y, Z)
            if roots:
                candidates.append({"A": A, "B": B, "Y": Y, "T": T, "Z": Z, "simple_u_roots": roots})
                print(json.dumps(candidates[-1], sort_keys=True), flush=True)
    output = HERE / "local_obstruction_candidates_p23.json"
    output.write_text(json.dumps({"prime": P, "zeta": ZETA, "candidates": candidates}, indent=2, sort_keys=True) + "\n")
    print(f"candidate_count={len(candidates)}")
    print("LOCAL_OBSTRUCTION_MOD23_SCREEN_DONE")


if __name__ == "__main__":
    main()
