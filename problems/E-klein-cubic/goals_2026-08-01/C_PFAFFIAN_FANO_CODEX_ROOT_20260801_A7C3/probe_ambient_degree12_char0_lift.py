#!/usr/bin/env python3
"""Exactly verify the reconstructed degree-12 projector RUR.

This consumer reconstructs the exact six-dimensional group over Q(zeta_11),
the deterministic five-dimensional source summand, and the 48 Reynolds maps
at one exact point.  The independently produced RUR is accepted only if all
fifteen Pluecker identities vanish in the cubic quotient.
"""

from __future__ import annotations

import json
import runpy
from collections import deque
from itertools import combinations
from pathlib import Path

import numpy as np
from sympy.polys.matrices import DomainMatrix


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PAIRS = tuple(combinations(range(6), 2))
PAIR_INDEX = {pair: index for index, pair in enumerate(PAIRS)}


def lift_rur(pf):
    artifact = json.loads((HERE / "ambient_degree12_rur_char0.json").read_text())
    assert artifact["format"] == "ambient-degree12-rur-char0-qzeta11-v1"
    assert artifact["field"]["minimal_polynomial_ascending"] == [1] * 11
    assert artifact["layout"] == {
        "eliminant": [0, 4],
        "coordinate_numerators": [4, 145],
        "coordinate_stride": 3,
        "coordinate_sign": -1,
        "denominator": [1],
    }
    K = pf["K11"]
    zeta = pf["ZETA11"]
    names = artifact["variable_names"]
    assert names == ["a47", *[f"a{index}" for index in range(1, 47)], "a0"]

    def decode(coefficients):
        assert len(coefficients) == 10
        value = K.zero
        for power, (numerator, denominator) in enumerate(coefficients):
            value += (K(int(numerator)) / K(int(denominator))) * zeta**power
        return value

    flattened = [decode(coefficients) for coefficients in artifact["raw_rur_coefficients_power_basis"]]
    assert len(flattened) == 145
    w = flattened[:4]
    assert len(w) == 4 and w[3] == K.one
    coordinate_polynomials = {}
    for block_index, name in enumerate(names[:-1]):
        raw = flattened[4 + 3 * block_index: 7 + 3 * block_index]
        coordinate_polynomials[name] = [-value for value in raw]
    coordinate_polynomials[names[-1]] = [K.zero, K.one, K.zero]
    coefficients = [coordinate_polynomials[f"a{index}"] for index in range(48)]
    return w, coefficients


def wedge_matrix(matrix, K):
    entries = matrix.to_list() if isinstance(matrix, DomainMatrix) else matrix
    rows = []
    for a, b in PAIRS:
        rows.append([
            entries[a][i] * entries[b][j] - entries[a][j] * entries[b][i]
            for i, j in PAIRS
        ])
    return DomainMatrix(rows, (15, 15), K)


def word_states(pf, fano):
    modular_six = fano["six_dimensional_generators"]()
    modular_dual = tuple(fano["inv"](generator).T % 23 for generator in modular_six)
    modular_generators = tuple(fano["exterior_square"](generator) for generator in modular_dual)
    exact_generators = pf["schur_generators"]()
    exact_inverses = tuple(generator.inv() for generator in exact_generators)
    identity_mod = np.eye(15, dtype=np.int64) % 23
    identity_exact = pf["identity"](6)
    seen = {fano["matrix_key"](identity_mod): (identity_mod, identity_exact, identity_exact)}
    queue = deque([seen[fano["matrix_key"](identity_mod)]])
    while queue:
        modular, exact, exact_inverse = queue.popleft()
        for modular_generator, exact_generator, exact_generator_inverse in zip(
            modular_generators, exact_generators, exact_inverses
        ):
            new_modular = modular @ modular_generator % 23
            key = fano["matrix_key"](new_modular)
            if key not in seen:
                new_state = (
                    new_modular,
                    exact.matmul(exact_generator),
                    exact_generator_inverse.matmul(exact_inverse),
                )
                seen[key] = new_state
                queue.append(new_state)
    assert len(seen) == 660
    return list(seen.values())


def source_basis(states, pf):
    K = pf["K11"]
    zero = K.zero
    commuting = [[zero for _ in range(15)] for _ in range(15)]
    for _modular, exact, exact_inverse in states:
        dual = wedge_matrix(exact_inverse.transpose(), K).to_list()
        dual_inverse = wedge_matrix(exact.transpose(), K).to_list()
        column = [dual[row][0] for row in range(15)]
        row = dual_inverse[0]
        for i in range(15):
            for j in range(15):
                commuting[i][j] += column[i] * row[j]
    C = DomainMatrix(commuting, (15, 15), K)
    left = DomainMatrix([row[:10] for row in commuting[:10]], (10, 10), K)
    right = DomainMatrix([row[10:] for row in commuting[:10]], (10, 5), K)
    top = -(left.inv().matmul(right))
    basis = DomainMatrix(
        top.to_list()
        + [[K.one if row == column else K.zero for column in range(5)] for row in range(5)],
        (15, 5), K,
    )
    assert C.matmul(basis) == DomainMatrix([[K.zero] * 5 for _ in range(15)], (15, 5), K)
    return basis


def group_records(states, basis, pf):
    K = pf["K11"]
    records = []
    for _modular, exact, exact_inverse in states:
        dual = wedge_matrix(exact_inverse.transpose(), K)
        transformed_basis = dual.matmul(basis).to_list()
        domain = DomainMatrix(transformed_basis[10:], (5, 5), K)
        target_inverse = wedge_matrix(exact_inverse, K)
        records.append((domain.to_list(), target_inverse.to_list()))
    return records


def qmul(left, right, w, K):
    raw = [K.zero] * 5
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            raw[i + j] += a * b
    for degree in (4, 3):
        value = raw[degree]
        if value != K.zero:
            for index in range(3):
                raw[degree - 3 + index] -= value * w[index]
    return raw[:3]


def qadd(left, right):
    return [a + b for a, b in zip(left, right)]


def qscale(scalar, value):
    return [scalar * entry for entry in value]


def evaluate_covariants(point, seeds, records, pf):
    K = pf["K11"]
    result = [[K.zero] * 15 for _ in seeds]
    for domain, target_inverse in records:
        transformed = [
            sum((domain[row][column] * K(point[column]) for column in range(5)), K.zero)
            for row in range(5)
        ]
        for seed_index, (output, exponents) in enumerate(seeds):
            scalar = K.one
            for coordinate, exponent in zip(transformed, exponents):
                scalar *= coordinate ** int(exponent)
            for row in range(15):
                result[seed_index][row] += scalar * target_inverse[row][output]
    return result


def main():
    pf = runpy.run_path(str(ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py"))
    fw = runpy.run_path(str(ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "full_wedge.py"))
    fano = fw["fano"]
    w, coefficient_polynomials = lift_rur(pf)
    states = word_states(pf, fano)
    basis = source_basis(states, pf)
    records = group_records(states, basis, pf)
    seeds = [
        (int(output), tuple(exponents))
        for output, exponents in json.loads((HERE / "ambient_degree12_a47_chart.json").read_text())["seeds"]
    ]
    values = evaluate_covariants((1, 2, 3, 4, 5), seeds, records, pf)
    K = pf["K11"]
    wedge = [[K.zero, K.zero, K.zero] for _ in range(15)]
    for coefficient, value in zip(coefficient_polynomials, values):
        for row in range(15):
            wedge[row] = qadd(wedge[row], qscale(value[row], coefficient))
    residuals = []
    for i, j, k, ell in combinations(range(6), 4):
        residual = qadd(
            qadd(
                qmul(wedge[PAIR_INDEX[(i, j)]], wedge[PAIR_INDEX[(k, ell)]], w, K),
                qscale(-K.one, qmul(wedge[PAIR_INDEX[(i, k)]], wedge[PAIR_INDEX[(j, ell)]], w, K)),
            ),
            qmul(wedge[PAIR_INDEX[(i, ell)]], wedge[PAIR_INDEX[(j, k)]], w, K),
        )
        residuals.append(residual)
    nonzero = [index for index, residual in enumerate(residuals) if residual != [K.zero] * 3]
    print(f"exactGroupOrder={len(states)} reconstructedRurDegree={len(w)-1}")
    print(f"nonzeroPlueckerResiduals={nonzero}")
    if nonzero:
        first = residuals[nonzero[0]]
        print("EXACT-RUR-REJECTED", [pf["coefficients"](entry, 10) for entry in first])
        raise SystemExit(2)
    print("AMBIENT-D12-RUR-PASSES-ONE-EXACT-POINT")


if __name__ == "__main__":
    main()
