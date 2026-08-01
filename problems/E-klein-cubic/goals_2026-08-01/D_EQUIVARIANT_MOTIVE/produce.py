#!/usr/bin/env python3
"""Produce the exact Goal D payload and deterministic seal."""

from __future__ import annotations

import hashlib
import json
from math import comb, gcd
from pathlib import Path


ROOT = Path(__file__).resolve().parent
PAYLOAD = ROOT / "invariants.json"
SEAL = ROOT / "SEAL.json"


def truncated_mul(a: list[int], b: list[int], degree: int) -> list[int]:
    out = [0] * (degree + 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            if i + j <= degree:
                out[i + j] += x * y
    return out


def target_payload() -> dict:
    # c(T_X)=(1+H)^5/(1+3H), truncated in degree 3.
    numerator = [comb(5, i) for i in range(4)]
    reciprocal = [(-3) ** i for i in range(4)]
    chern = truncated_mul(numerator, reciprocal, 3)
    _, c1, c2, c3 = chern
    h3_degree = 3

    c1_cubed = c1**3 * h3_degree
    c1_c2 = c1 * c2 * h3_degree
    c3_number = c3 * h3_degree
    p1_coefficient = c1**2 - 2 * c2
    p1_h = p1_coefficient * h3_degree
    s3 = c1_cubed - 3 * c1_c2 + 3 * c3_number

    bezout_coefficients = [-13, 3, 1, 1]
    orbit_degrees = [60, 132, 165, 220]
    bezout_value = sum(a * b for a, b in zip(bezout_coefficients, orbit_degrees))

    group_order = 11 * (11**2 - 1) // 2
    prym_base_genus = (5 - 1) * (5 - 2) // 2
    prym_cover_genus = 2 * prym_base_genus - 1
    target_h3_rank = 10
    centre_h1_rank = 2 * prym_cover_genus

    return {
        "schema": "D_EQUIVARIANT_MOTIVE.v1",
        "exit": "D-INVARIANT-REPRODUCIBLE",
        "headline_problem": "OPEN",
        "repository": {
            "pinned_baseline": "715faf441289e2589b9325311b6613ea0331bf88",
            "initial_inspection_commit": "2140419410cfff2f7d7dcca166acef8c16a0d41b",
            "consumed_commit": "80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c",
            "produced_commit": None,
        },
        "group": {
            "name": "PSL(2,11)",
            "order": group_order,
            "prime_divisors": [2, 3, 5, 11],
            "prime_local_essential_dimension": {"2": 2, "3": 1, "5": 1, "11": 1},
        },
        "target": {
            "complex_dimension": 3,
            "degree": h3_degree,
            "chern_class_coefficients_in_H": chern,
            "chern_numbers": {
                "c1^3": c1_cubed,
                "c1*c2": c1_c2,
                "c3": c3_number,
                "p1*H": p1_h,
                "s3": s3,
                "s3_tangent/2": s3 // 2,
                "rost_half_number_minus_tangent": (-s3) // 2,
                "todd_genus": c1_c2 // 24,
            },
            "betti_numbers": [1, 0, 1, 10, 1, 0, 1],
            "euler_characteristic": c3_number,
            "integral_cohomology_torsion_free": True,
            "H3_rank": target_h3_rank,
            "Hodge_H21_dimension": 5,
            "Hodge_H21_G_representation": "W*",
        },
        "index_certificate": {
            "effective_cycle_degrees": orbit_degrees,
            "bezout_coefficients": bezout_coefficients,
            "bezout_value": bezout_value,
            "gcd": gcd(gcd(gcd(*orbit_degrees[:2]), orbit_degrees[2]), orbit_degrees[3]),
        },
        "steenrod_on_H3": {
            "2": {"Sq1": 0, "Sq2": 0, "Sq3": 0, "reason": "torsion_free_H5_zero_square_lifts"},
            "3": {"beta": 0, "P1": 0, "reason": "torsion_free_and_above_dimension"},
            "5": {"beta": 0, "P1": 0, "reason": "torsion_free_and_above_dimension"},
            "11": {"beta": 0, "P1": 0, "reason": "torsion_free_and_above_dimension"},
        },
        "bridge": {
            "relative_dimension": 1,
            "identity": "f_*(eta*f^*(-))=n*(-)",
            "integral_projector_forced": False,
            "split_coefficients": "Z[1/n]",
        },
        "closure_model": {
            "curve": "etale Prym double cover of a smooth plane quintic",
            "base_curve_genus": prym_base_genus,
            "centre_component_genus": prym_cover_genus,
            "component_stabilizer_order": 1,
            "orbit_components": group_order,
            "H1_rank_per_component": centre_h1_rank,
            "H1_total_rank": group_order * centre_h1_rank,
            "regular_ZG_copies": centre_h1_rank,
            "target_lattice_rank": target_h3_rank,
            "primitive_lattice_capacity": centre_h1_rank >= target_h3_rank,
            "rational_motive_split": True,
            "integral_motive_split_claimed": False,
            "motive_denominators": [2, group_order],
        },
    }


def canonical_json(data: dict) -> str:
    return json.dumps(data, indent=2, sort_keys=True) + "\n"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    PAYLOAD.write_text(canonical_json(target_payload()), encoding="utf-8")

    sealed_names = [
        "STATUS.md",
        "THEOREM_AUDIT.md",
        "TARGET_INVARIANTS.md",
        "BLOWUP_CLOSURE.md",
        "COMPLETION_AUDIT.md",
        "produce.py",
        "seal.py",
        "verify.py",
        "invariants.json",
    ]
    missing = [name for name in sealed_names if not (ROOT / name).is_file()]
    if missing:
        raise SystemExit(f"cannot seal; missing: {missing}")

    seal = {
        "schema": "D_EQUIVARIANT_MOTIVE.SEAL.v1",
        "self_hash_included": False,
        "source_commit": "80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c",
        "produced_commit": None,
        "files": {name: sha256(ROOT / name) for name in sealed_names},
    }
    SEAL.write_text(canonical_json(seal), encoding="utf-8")
    print("D_EQUIVARIANT_MOTIVE_PRODUCE_OK")


if __name__ == "__main__":
    main()
