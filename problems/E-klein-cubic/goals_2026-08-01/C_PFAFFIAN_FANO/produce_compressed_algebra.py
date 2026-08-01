#!/usr/bin/env python3
"""Produce the exact lazy C0 compressed-algebra interface.

The 36 rectangle columns and the six ``a*b^j`` targets are kept as a rational
straight-line program.  Thus every entry of ``L_a`` is defined exactly by
``R^-1 v`` over K_proj without expanding the enormous determinant of R.
"""

from __future__ import annotations

import hashlib
import json
import math
import runpy
from itertools import product
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "compressed_algebra.json"


def sha256(path):
    digest = hashlib.sha256()
    with Path(path).open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def degree_three_exponents():
    answer = []
    for exponents in product(range(4), repeat=5):
        if sum(exponents) == 3:
            answer.append(exponents)
    return answer


def multinomial_three(exponents):
    value = math.factorial(3)
    for exponent in exponents:
        value //= math.factorial(exponent)
    return value


def expand_reynolds(orbit_data, matrix_unit, pf):
    K = pf["K11"]
    exponents = degree_three_exponents()
    matrices = [[{} for _ in range(6)] for _ in range(6)]
    for linear, n00, n01 in orbit_data:
        block = n00 if matrix_unit == 0 else n01
        scalar_terms = []
        for exponent in exponents:
            coefficient = K(multinomial_three(exponent))
            for value, power in zip(linear, exponent):
                if power:
                    coefficient *= value ** power
            if coefficient != K.zero:
                scalar_terms.append((exponent, coefficient))
        for row in range(6):
            for column in range(6):
                multiplier = block[row][column]
                if multiplier == K.zero:
                    continue
                target = matrices[row][column]
                for exponent, coefficient in scalar_terms:
                    target[exponent] = target.get(exponent, K.zero) + coefficient * multiplier
    for row in matrices:
        for polynomial in row:
            for exponent in list(polynomial):
                if polynomial[exponent] == K.zero:
                    del polynomial[exponent]
    return matrices


def serialize_matrix(matrix, pf):
    return [
        [
            [
                {"exponents": list(exponents), "coefficient_Qzeta11": pf["coefficients"](coefficient, 10)}
                for exponents, coefficient in sorted(polynomial.items())
            ]
            for polynomial in row
        ]
        for row in matrix
    ]


def reduce_coefficient(data, p, zeta):
    answer = 0
    for exponent, (numerator, denominator) in enumerate(data):
        answer = (answer + numerator * pow(denominator, -1, p) * pow(zeta, exponent, p)) % p
    return answer


def evaluate_serialized_matrix(data, point, p, zeta):
    answer = np.zeros((6, 6), dtype=np.int64)
    for row in range(6):
        for column in range(6):
            value = 0
            for term in data[row][column]:
                monomial = 1
                for coordinate, exponent in zip(point, term["exponents"]):
                    monomial = monomial * pow(int(coordinate), int(exponent), p) % p
                value = (value + reduce_coefficient(term["coefficient_Qzeta11"], p, zeta) * monomial) % p
            answer[row, column] = value
    return answer


def modular_alignment_checks(serialized_a, serialized_b):
    c3 = runpy.run_path(str(ROOT / "certificates" / "fano_c3" / "produce_c3.py"))
    c2 = c3["load_c2_helpers"]()
    namespace = {}
    core = ROOT / "tmp" / "kproj_arithmetic" / "core.py"
    exec(compile(core.read_text().replace("ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"), str(core), "exec"), namespace)
    forms = namespace["forms"]()
    point = (1, 2, 3, 4, 5)
    checks = []
    for p, zeta in ((23, 2), (89, 2), (199, 18)):
        frame = c2["build_projective_reynolds_frame"](p, zeta)
        ca = evaluate_serialized_matrix(serialized_a, point, p, zeta)
        cb = evaluate_serialized_matrix(serialized_b, point, p, zeta)
        f11 = namespace["evaluate_mod"](forms[11], point, p)
        f14 = namespace["evaluate_mod"](forms[14], point, p)
        scale = f11 * pow(f14, -1, p) % p
        assert np.array_equal(ca * scale % p, frame["basis_mats"][1] % p)
        assert np.array_equal(cb * scale % p, frame["basis_mats"][2] % p)
        compressed = c3["compressed_data_at"](ca * scale % p, cb * scale % p, p)
        assert compressed is not None
        checks.append({
            "prime": p,
            "zeta11": zeta,
            "point": list(point),
            "rectangular_determinant": compressed["rect_det_m6"],
            "minpoly_degree": len(compressed["minpoly"]) - 1,
        })
    return checks


def main():
    helper = runpy.run_path(str(HERE / "produce_c0_minpoly.py"))
    pf, _kp = helper["load_inputs"]()
    orbit_data = helper["exact_orbit_data"](pf)
    polynomial_a = expand_reynolds(orbit_data, 0, pf)
    polynomial_b = expand_reynolds(orbit_data, 1, pf)
    serialized_a = serialize_matrix(polynomial_a, pf)
    serialized_b = serialize_matrix(polynomial_b, pf)

    payload = {
        "format": "c0-compressed-algebra-lazy-v1",
        "base": {
            "K_proj": "Q(zeta11)(P(W))^PSL_2(F_11)",
            "splitting_field": "Q(zeta11)(x0,x1,x2,x3,x4)",
            "cyclotomic_relation": "1+zeta11+...+zeta11^10=0",
        },
        "generator_alignment": {"A": "TSTS", "B": "T^8S"},
        "generators": {
            "a": {"formula": "(f11/f14)*C_a", "C_a": serialized_a},
            "b": {"formula": "(f11/f14)*C_b", "C_b": serialized_b},
        },
        "maximal_etale_model": {
            "E": "K_proj[a]",
            "E_basis": ["1", "a", "a^2", "a^3", "a^4", "a^5"],
            "right_E_basis": ["1", "b", "b^2", "b^3", "b^4", "b^5"],
            "rectangle_order": [f"b^{j}*a^{i}" for j in range(6) for i in range(6)],
            "rectangle_matrix_R": "column_stack(vec(b^j*a^i), j=0..5, i=0..5)",
            "generic_open": "f14*f11*det(R)!=0 and discriminant(m_a)!=0",
        },
        "compressed_multiplication_interface": {
            "L_a_columns": [f"reshape_6x6(R^-1*vec(a*b^{j}))" for j in range(6)],
            "L_a_entry_semantics": "L_a[k,j,i] is coordinate (k,i) of R^-1*vec(a*b^j)",
            "L_b": "companion matrix over E from b^6 relation in c0_minpoly_exact.json",
            "arbitrary_product": "embed rectangle coordinates as a 6x6 splitting matrix, multiply ordinarily, return R^-1*vec(product)",
            "invariance_proof": "simultaneous conjugation sends R and every target v equivariantly, so uniqueness of R^-1*v makes every coordinate G-invariant and hence an element of K_proj",
            "associativity_proof": "the interface is transported ordinary 6x6 matrix multiplication",
            "unit": "the rectangle element b^0*a^0",
            "central_scalars": "G-invariant scalar rational functions K_proj",
        },
        "exact_scalar_blocks": {
            "m_a_and_m_b": "c0_minpoly_exact.json",
            "b6": "Cayley-Hamilton mapping recorded in c0_minpoly_exact.json:b6_relation",
        },
        "degree_probe": {
            "prime": 353,
            "samples": 7500,
            "entry": [0, 1, 0],
            "rational_total_degrees_rejected": [4, 5, 6, 7, 8],
            "interpretation": "justifies the lazy exact DAG instead of a false low-degree expanded interpolation",
        },
        "modular_alignment_checks": modular_alignment_checks(serialized_a, serialized_b),
        "source_hashes": {
            "pfaffian_alignment_core.py": sha256(ROOT / "tmp" / "pfaffian_representation_alignment" / "core.py"),
            "pfaffian_alignment_certificate.json": sha256(ROOT / "tmp" / "pfaffian_representation_alignment" / "certificate.json"),
            "kproj_core.py": sha256(ROOT / "tmp" / "kproj_arithmetic" / "core.py"),
            "kproj_table.json": sha256(ROOT / "tmp" / "kproj_arithmetic" / "normalized_kproj_table.json"),
            "fano_c3_producer.py": sha256(ROOT / "certificates" / "fano_c3" / "produce_c3.py"),
            "exact_minpolys": sha256(HERE / "c0_minpoly_exact.json"),
        },
        "theorem_boundary": {
            "proved": "an exact complete lazy multiplication interface for the specific aligned A_proj on its maximal-etale generic open",
            "not_proved": "an expanded named-invariant formula for L_a, the involution, Morita corner, Hermitian five-plane, common line, or headline",
        },
    }
    OUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"WROTE {OUT}")
    print("C3-APROJ-LAZY-EXECUTABLE")


if __name__ == "__main__":
    main()
