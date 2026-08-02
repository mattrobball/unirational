#!/usr/bin/env python3
"""Exact contact of Delta_cub with H along A=15, Y=12.

Writes only t3_disc_plane_* discovery artifacts beside this script.
"""

from __future__ import annotations

import gzip
import hashlib
import importlib.util
import json
from pathlib import Path

from sympy.polys.domains import QQ
from sympy.polys.rings import ring


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
DELTA_PATH = HERE / "t3_disc_delta_cub_qzeta11.json.gz"
OUTPUT_GZ = HERE / "t3_disc_plane_contact_qzeta11.json.gz"
SUMMARY = HERE / "t3_disc_plane_summary.json"
A0 = 15
Y0 = 12


def load_build_module():
    path = HERE / "t3_disc_build.py"
    spec = importlib.util.spec_from_file_location("t3_disc_build_for_plane", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


disc = load_build_module()
K = disc.K
BR, B, Z = ring("B,Z", K)


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_hash(value) -> str:
    return hashlib.sha256(
        json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()


def falling(value: int, order: int) -> int:
    answer = 1
    for offset in range(order):
        answer *= value - offset
    return answer


def restricted_h_derivative(order_a: int, order_y: int):
    answer = BR.zero
    with H_PATH.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tcoefficient"
        for line in stream:
            a, b, y, z, coefficient = map(int, line.split())
            if a < order_a or y < order_y:
                continue
            coefficient *= falling(a, order_a) * falling(y, order_y)
            coefficient *= A0 ** (a - order_a) * Y0 ** (y - order_y)
            if coefficient:
                answer += BR(K(coefficient)) * B**b * Z**z
    return answer


def restricted_delta_derivative(delta_terms, order_a: int, order_y: int):
    answer = BR.zero
    for term in delta_terms:
        a, b, y, z = term["exponents"]
        if a < order_a or y < order_y:
            continue
        coefficient = disc.deserialize_k11(term["coefficient_qzeta11"])
        coefficient *= K(falling(a, order_a) * falling(y, order_y))
        coefficient *= K(A0) ** (a - order_a) * K(Y0) ** (y - order_y)
        if coefficient:
            answer += BR(coefficient) * B**b * Z**z
    return answer


def stats(poly):
    terms = poly.terms()
    return {
        "terms": len(terms),
        "total_degree_BZ": max((sum(monomial) for monomial, _ in terms), default=-1),
        "degrees_BZ": [
            max((monomial[index] for monomial, _ in terms), default=-1)
            for index in range(2)
        ],
    }


def serialize(poly):
    return [
        {"exponents_BZ": list(monomial), "coefficient_qzeta11": disc.serialize_k11(coefficient)}
        for monomial, coefficient in poly.terms()
    ]


def evaluate_mod67(poly, b_value=37, z_value=56):
    answer = 0
    for (b, z), coefficient in poly.terms():
        reduced = disc.reduce_coefficient(coefficient, 67, 9)
        answer += reduced * pow(b_value, b, 67) * pow(z_value, z, 67)
    return answer % 67


def main():
    with gzip.open(DELTA_PATH, "rt") as stream:
        delta_payload = json.load(stream)
    delta_terms = delta_payload["delta_terms"]

    h0 = restricted_h_derivative(0, 0)
    h_a = restricted_h_derivative(1, 0)
    h_y = restricted_h_derivative(0, 1)
    h_yy = restricted_h_derivative(0, 2)
    d0 = restricted_delta_derivative(delta_terms, 0, 0)
    d_a = restricted_delta_derivative(delta_terms, 1, 0)
    d_y = restricted_delta_derivative(delta_terms, 0, 1)
    d_yy = restricted_delta_derivative(delta_terms, 0, 2)

    assert not h0
    assert h_a
    assert not h_y
    assert not d0
    assert d_a
    assert not d_y

    numerator = d_yy * h_a - d_a * h_yy
    assert numerator

    named = {"H_A": h_a, "H_YY": h_yy, "Delta_A": d_a, "Delta_YY": d_yy, "N": numerator}
    serialized = {name: serialize(poly) for name, poly in named.items()}
    sample = {name: evaluate_mod67(poly) for name, poly in named.items()}
    print("mod67_sample", sample, flush=True)
    assert sample == {"H_A": 34, "H_YY": 29, "Delta_A": 17, "Delta_YY": 1, "N": 10}
    reference_delta_scale = sample["Delta_A"] * pow(10, -1, 67) % 67
    assert reference_delta_scale == 62
    assert sample["Delta_YY"] == reference_delta_scale * 40 % 67
    assert sample["N"] == reference_delta_scale * 65 % 67
    difference = (sample["Delta_YY"] - sample["Delta_A"] * pow(sample["H_A"], -1, 67) * sample["H_YY"]) % 67
    quadratic_coefficient = sample["N"] * pow(2 * sample["H_A"], -1, 67) % 67
    assert difference == 20
    assert quadratic_coefficient == 10

    payload = {
        "schema": "klein-cubic-t3-plane-contact-exact-v1",
        "field": "QQ(zeta11)(B,Z)",
        "plane": ["A-15", "Y-12"],
        "identities": {
            "H_on_plane": 0,
            "H_Y_on_plane": 0,
            "Delta_on_plane": 0,
            "Delta_Y_on_plane": 0,
            "H_A_nonzero": True,
            "Delta_A_nonzero": True,
            "N_nonzero": True,
        },
        "normal_expansion": {
            "coordinates": "a=A-15, y=Y-12",
            "H_solution": "a=-(H_YY/(2*H_A))*y^2+O(y^3)",
            "Delta_on_H": "(N/(2*H_A))*y^2+O(y^3)",
            "N": "Delta_YY*H_A-Delta_A*H_YY",
            "generic_contact_multiplicity": 2,
            "normalization_note": "H_A is generically nonzero, so H is smooth at the generic point of the plane and normalization is an isomorphism there.",
        },
        "polynomial_stats": {name: stats(poly) for name, poly in named.items()},
        "polynomial_sha256": {name: canonical_hash(value) for name, value in serialized.items()},
        "polynomials": serialized,
        "mod67_witness": {
            "embedding": "zeta11=9",
            "point_BZ": [37, 56],
            "values": sample,
            "normalization_ratio_to_worker_M2_discriminant": reference_delta_scale,
            "worker_M2_values": {"Delta_A": 10, "Delta_YY": 40, "N": 65},
            "Delta_YY_minus_Delta_A_over_H_A_times_H_YY": difference,
            "quadratic_coefficient_N_over_2H_A": quadratic_coefficient,
        },
        "source_sha256": {
            str(H_PATH.relative_to(ROOT)): file_hash(H_PATH),
            str(DELTA_PATH.relative_to(HERE)): file_hash(DELTA_PATH),
            "scratch_t3/t3_disc_build.py": file_hash(HERE / "t3_disc_build.py"),
        },
        "scope": (
            "Exact generic contact on the plane component only; no exhaustive "
            "normalization/conductor/infinity contact ledger."
        ),
    }
    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    OUTPUT_GZ.write_bytes(gzip.compress(encoded, compresslevel=9, mtime=0))
    summary = {
        key: payload[key]
        for key in (
            "schema",
            "field",
            "plane",
            "identities",
            "normal_expansion",
            "polynomial_stats",
            "polynomial_sha256",
            "mod67_witness",
            "source_sha256",
            "scope",
        )
    }
    summary.update(
        {
            "payload": OUTPUT_GZ.name,
            "payload_sha256": file_hash(OUTPUT_GZ),
            "payload_uncompressed_bytes": len(encoded),
            "payload_gzip_bytes": OUTPUT_GZ.stat().st_size,
        }
    )
    SUMMARY.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print(json.dumps(summary, indent=2, sort_keys=True))
    print("T3_DISC_PLANE_CONTACT_EXACT_2")


if __name__ == "__main__":
    main()
