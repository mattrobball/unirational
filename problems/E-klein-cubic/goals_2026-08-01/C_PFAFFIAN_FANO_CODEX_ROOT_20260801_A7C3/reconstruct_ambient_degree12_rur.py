#!/usr/bin/env python3
"""Reconstruct the degree-12 ambient RUR over Q(c), c^2+c+3=0.

Each modular coefficient is evaluated at both roots of the Gaussian-period
polynomial.  The conjugate pair determines its two coordinates in F_p[c].
Those coordinates are CRT-combined and rationally reconstructed separately.
No characteristic-zero artifact is written unless every coefficient passes.
"""

from __future__ import annotations

import ast
import json
import math
from fractions import Fraction
from pathlib import Path

from sympy import ZZ
from sympy.ntheory.modular import crt
from sympy.polys.modulargcd import _integer_rational_reconstruction


HERE = Path(__file__).resolve().parent
PAIRS = (
    (23, 2, 4, "ambient_degree12_a47_chart.rur", "ambient_degree12_zeta04_a47.rur"),
    (89, 2, 4, "ambient_degree12_p89_zeta002_a47.rur", "ambient_degree12_p89_zeta004_a47.rur"),
    (199, 18, 125, "ambient_degree12_p199_zeta018_a47.rur", "ambient_degree12_p199_zeta125_a47.rur"),
    (331, 74, 180, "ambient_degree12_p331_zeta074_a47.rur", "ambient_degree12_p331_zeta180_a47.rur"),
    (353, 58, 187, "ambient_degree12_p353_zeta058_a47.rur", "ambient_degree12_p353_zeta187_a47.rur"),
)
PERIOD_EXPONENTS = (9, 5, 4, 3, 1)


def load_rur(filename: str):
    outer = ast.literal_eval((HERE / filename).read_text().strip().rstrip(":"))
    assert outer[0] == 0
    data = outer[1]
    prime, variable_count, degree, names = data[:4]
    assert variable_count == 48 and degree == 3 and len(names) == 48
    assert names[-1] == "a0" and names[0] == "a47"
    body = data[5][1]
    eliminant, denominator, blocks = body
    assert denominator == [0, [1]] and len(blocks) == 47
    eliminant_coefficients = list(eliminant[1])
    assert len(eliminant_coefficients) == 4 and eliminant_coefficients[-1] == 1
    flattened = eliminant_coefficients[:]
    lengths = []
    for block in blocks:
        coefficients = list(block[0][1])
        assert len(coefficients) <= 3
        lengths.append(len(coefficients))
        flattened.extend(coefficients + [0] * (3 - len(coefficients)))
    assert len(flattened) == 145
    return int(prime), names, flattened, lengths


def period(prime: int, zeta: int) -> int:
    assert pow(zeta, 11, prime) == 1 and zeta % prime != 1
    value = sum(pow(zeta, exponent, prime) for exponent in PERIOD_EXPONENTS) % prime
    assert (value * value + value + 3) % prime == 0
    return value


def split_pair(left: int, right: int, c_left: int, c_right: int, prime: int):
    b = (left - right) * pow((c_left - c_right) % prime, -1, prime) % prime
    a = (left - b * c_left) % prime
    assert (a + b * c_left - left) % prime == 0
    assert (a + b * c_right - right) % prime == 0
    return a, b


def rational_reconstruct(residues, primes):
    value, modulus = crt(primes, residues, check=True)
    value, modulus = int(value), int(modulus)
    reconstructed = _integer_rational_reconstruction(ZZ(value), ZZ(modulus), ZZ)
    if reconstructed is None:
        return None, modulus
    numerator = int(reconstructed.numerator)
    denominator = int(reconstructed.denominator)
    candidate = Fraction(numerator, denominator)
    for residue, prime in zip(residues, primes):
        if denominator % prime == 0:
            return None, modulus
        if (numerator * pow(denominator, -1, prime) - residue) % prime:
            return None, modulus
    return candidate, modulus


def encode_fraction(value: Fraction):
    return [value.numerator, value.denominator]


def main():
    primes = []
    period_roots = []
    modular_coefficients = []
    canonical_names = None
    for prime, left_zeta, right_zeta, left_file, right_file in PAIRS:
        left_prime, left_names, left_values, left_lengths = load_rur(left_file)
        right_prime, right_names, right_values, right_lengths = load_rur(right_file)
        assert left_prime == right_prime == prime
        assert left_names == right_names
        if canonical_names is None:
            canonical_names = left_names
        else:
            assert left_names == canonical_names
        c_left = period(prime, left_zeta)
        c_right = period(prime, right_zeta)
        assert c_left != c_right
        primes.append(prime)
        period_roots.append([c_left, c_right])
        modular_coefficients.append([
            split_pair(left, right, c_left, c_right, prime)
            for left, right in zip(left_values, right_values)
        ])

    modulus = math.prod(primes)
    reconstructed = []
    unresolved = []
    max_numerator = 0
    max_denominator = 0
    for index in range(145):
        pair = []
        for component in range(2):
            residues = [row[index][component] for row in modular_coefficients]
            value, checked_modulus = rational_reconstruct(residues, primes)
            assert checked_modulus == modulus
            pair.append(value)
        if None in pair:
            unresolved.append({
                "index": index,
                "a_residues": [row[index][0] for row in modular_coefficients],
                "b_residues": [row[index][1] for row in modular_coefficients],
                "failed_components": [name for name, value in zip(("a", "b"), pair) if value is None],
            })
            reconstructed.append(None)
        else:
            max_numerator = max(max_numerator, *(abs(value.numerator) for value in pair))
            max_denominator = max(max_denominator, *(value.denominator for value in pair))
            reconstructed.append([encode_fraction(pair[0]), encode_fraction(pair[1])])

    report = {
        "field": "Q(c), c^2+c+3=0",
        "primes": primes,
        "period_roots": period_roots,
        "modulus": modulus,
        "rational_reconstruction_bound_floor": math.isqrt(modulus // 2),
        "coefficient_count": 145,
        "resolved_count": 145 - len(unresolved),
        "unresolved_count": len(unresolved),
        "max_abs_numerator": max_numerator,
        "max_denominator": max_denominator,
        "unresolved": unresolved,
    }
    (HERE / "ambient_degree12_crt_report.json").write_text(json.dumps(report, indent=2) + "\n")
    print(f"modulus={modulus} bound={report['rational_reconstruction_bound_floor']}")
    print(f"resolved={report['resolved_count']} unresolved={report['unresolved_count']}")
    print(f"maxAbsNumerator={max_numerator} maxDenominator={max_denominator}")
    if unresolved:
        print("AMBIENT-D12-RUR-RECONSTRUCTION-INCOMPLETE")
        return

    assert canonical_names is not None
    artifact = {
        "field": {"generator": "c", "minimal_polynomial_ascending": [3, 1, 1]},
        "source_primes": primes,
        "period_roots": period_roots,
        "variable_names": canonical_names,
        "parameter": "a0",
        "chart": "a47=1",
        "coordinate_block_width": 3,
        "raw_rur_coefficients_a_plus_b_c": reconstructed,
        "layout": {
            "eliminant": [0, 4],
            "coordinate_numerators": [4, 145],
            "coordinate_stride": 3,
            "coordinate_sign": -1,
            "denominator": [1],
        },
    }
    (HERE / "ambient_degree12_rur_char0.json").write_text(json.dumps(artifact, indent=2) + "\n")
    print("AMBIENT-D12-RUR-QC-RECONSTRUCTED")


if __name__ == "__main__":
    main()
