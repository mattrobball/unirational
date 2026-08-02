#!/usr/bin/env python3
"""Materialize the exact generic genuine-Fano Pluecker incidence.

The five alternating forms are reconstructed coefficient-by-coefficient as
Q(V_i(x)) from the sealed involution and Hilbert--90 frame.  Coefficients are
stored in the power basis 1,zeta11,...,zeta11^9; no interpolation is used.
"""

from __future__ import annotations

import hashlib
import json
from fractions import Fraction
from itertools import combinations
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PAIRS = tuple(combinations(range(6), 2))
PAIR_INDEX = {pair: index for index, pair in enumerate(PAIRS)}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def zero_coefficient() -> list[Fraction]:
    return [Fraction(0) for _ in range(10)]


def add_q11(target: list[Fraction], source, scalar: int) -> None:
    for power, (numerator, denominator) in enumerate(source):
        target[power] += scalar * Fraction(int(numerator), int(denominator))


def serialize_q11(coefficient: list[Fraction]):
    return [[value.numerator, value.denominator] for value in coefficient]


def exact_form(vector: list[list[dict]], q_coefficients) -> list[dict]:
    """Return <Q(vector(x)),p> as a sparse polynomial in x and p."""

    terms: dict[tuple[int, tuple[int, ...]], list[Fraction]] = {}
    for pair_number, (left, right) in enumerate(PAIRS):
        for coordinate, polynomial in enumerate(vector):
            scalar = q_coefficients[left][right][coordinate]
            for term in polynomial:
                key = (pair_number, tuple(map(int, term["exponents"])))
                coefficient = terms.setdefault(key, zero_coefficient())
                add_q11(coefficient, scalar, int(term["coefficient"]))
    return [
        {
            "pluecker_index": pair_number,
            "pair": list(PAIRS[pair_number]),
            "x_exponents": list(exponents),
            "coefficient_Qzeta11": serialize_q11(coefficient),
        }
        for (pair_number, exponents), coefficient in sorted(terms.items())
        if any(coefficient)
    ]


def chart_descriptor(pair: tuple[int, int]) -> dict:
    left, right = pair
    remaining = [column for column in range(6) if column not in pair]
    variables = []
    columns = []
    next_variable = 0
    for column in range(6):
        if column == left:
            columns.append(["1", "0"])
        elif column == right:
            columns.append(["0", "1"])
        else:
            top = f"u{next_variable}"
            bottom = f"u{next_variable + 1}"
            variables.extend([top, bottom])
            columns.append([top, bottom])
            next_variable += 2
    assert next_variable == 8
    return {
        "pivot_pair": list(pair),
        "normalization": f"p{left}{right}=1",
        "remaining_columns": remaining,
        "variables": variables,
        "two_by_six_columns": columns,
        "pluecker_substitution": "p_ij=top_i*bottom_j-top_j*bottom_i",
        "equations": "substitute this formula in each of the five exact linear_forms",
    }


def main() -> None:
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    involution_entry = manifest["authoritative_inputs"]["involution"]
    five_entry = manifest["authoritative_inputs"]["distinguished_five_plane"]
    involution_path = ROOT / involution_entry["path"]
    five_path = ROOT / five_entry["path"]
    assert sha256(involution_path) == involution_entry["sha256"]
    assert sha256(five_path) == five_entry["sha256"]
    involution = json.loads(involution_path.read_text())
    five_plane = json.loads(five_path.read_text())

    names = five_plane["hilbert90_frame"]["names"]
    vectors = five_plane["hilbert90_frame"]["vectors"]
    assert names == ["x", "C", "D", "E", "K"]
    q_coefficients = involution["Q_linear_coefficients"]
    linear_forms = []
    for name in names:
        terms = exact_form(vectors[name], q_coefficients)
        degrees = {sum(term["x_exponents"]) for term in terms}
        assert len(degrees) == 1
        linear_forms.append(
            {
                "name": name,
                "x_degree": degrees.pop(),
                "terms": terms,
            }
        )

    pluecker_quadrics = []
    for i, j, k, ell in combinations(range(6), 4):
        pluecker_quadrics.append(
            {
                "indices": [i, j, k, ell],
                "terms": [
                    {"coefficient": 1, "factors": [PAIR_INDEX[(i, j)], PAIR_INDEX[(k, ell)]]},
                    {"coefficient": -1, "factors": [PAIR_INDEX[(i, k)], PAIR_INDEX[(j, ell)]]},
                    {"coefficient": 1, "factors": [PAIR_INDEX[(i, ell)], PAIR_INDEX[(j, k)]]},
                ],
            }
        )

    equation_payload = {
        "pluecker_pairs_lexicographic": [list(pair) for pair in PAIRS],
        "linear_forms": linear_forms,
        "pluecker_quadrics": pluecker_quadrics,
    }
    equation_hash = hashlib.sha256(
        json.dumps(equation_payload, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()
    payload = {
        "format": "c5-generic-pluecker-incidence-exact-v1",
        "field": {
            "splitting_field": "Q(zeta11)(x0,x1,x2,x3,x4)",
            "zeta11_minimal_polynomial_ascending": [1] * 11,
            "descent_field": manifest["field"],
        },
        "base_variables": [f"x{index}" for index in range(5)],
        "pluecker_variables": [f"p{left}{right}" for left, right in PAIRS],
        "equations": equation_payload,
        "projective_cover": [chart_descriptor(pair) for pair in PAIRS],
        "opens": [
            "the Hilbert--90 frame determinant is nonzero",
            "Q(x) is nondegenerate",
            "the projective Pluecker vector is nonzero, covered by the fifteen p_ij charts",
        ],
        "descent_semantics": {
            "statement": "the equations are the split realization of the genuine twisted Fano section; a K_proj-point must additionally satisfy the installed descent/equivariance encoded by the twisted Pluecker bundle",
            "warning": "an arbitrary Q(zeta11)(x)-solution is not automatically a K_proj-point",
        },
        "equation_payload_sha256": equation_hash,
        "source_sha256": {
            "involution": involution_entry["sha256"],
            "distinguished_five_plane": five_entry["sha256"],
        },
        "scope": "exact executable generic genuine-Fano equations and all Grassmann charts; no rational section is asserted",
        "marker": "C5_GENERIC_PLUECKER_INCIDENCE_EXACT",
    }
    output = HERE / "generic_pluecker_incidence.json"
    output.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"linearFormTermCounts={[len(row['terms']) for row in linear_forms]}")
    print(f"equationPayloadSha256={equation_hash}")
    print(f"WROTE {output.name}")
    print("C5_GENERIC_PLUECKER_INCIDENCE_EXACT")


if __name__ == "__main__":
    main()
