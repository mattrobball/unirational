#!/usr/bin/env python3
"""Exact specialization/factor-pattern probe for degree-seven frame triples.

This is discovery for invariant-rational coefficients.  It evaluates every
three-coordinate slice at deterministic base points in the good fibre,
factors the resulting projective plane quartics exactly over F_23, and counts
their F_23-points.  No specialized point is promoted to a K_Schur point.
"""
from __future__ import annotations

from itertools import combinations
import importlib.util
import json
from math import factorial
from pathlib import Path
import subprocess
import sys
import tempfile

import numpy as np

import degree9_full_landing as landing


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
PROBE_SOURCE = (
    ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/"
    "probe_self_covariants_palatinian.py"
)
OUTPUT = HERE / "three_frame_slice_specializations_f23.json"
P = 23


def multinomial(alpha):
    answer = factorial(sum(alpha))
    for exponent in alpha:
        answer //= factorial(exponent)
    return answer


def coefficient_data():
    monomials = landing.probe_core.monomials(4, 3)
    indices = []
    factors = []
    for alpha in monomials:
        ordered = []
        for index, exponent in enumerate(alpha):
            ordered.extend([index] * exponent)
        indices.append(ordered)
        factors.append(multinomial(alpha))
    assert len(monomials) == 15
    return monomials, np.asarray(indices), np.asarray(factors)


def plane_row(tensor, values, indices, factors):
    ordered = np.einsum(
        "rstu,ir,js,kt,lu->ijkl",
        tensor, values, values, values, values, optimize=True,
    ) % P
    return (
        ordered[indices[:, 0], indices[:, 1], indices[:, 2], indices[:, 3]]
        * factors
    ) % P


def polynomial_text(row, monomials):
    terms = []
    for coefficient, alpha in zip(row, monomials):
        coefficient = int(coefficient)
        if not coefficient:
            continue
        factors = []
        for index, exponent in enumerate(alpha):
            if exponent == 1:
                factors.append(f"z{index}")
            elif exponent:
                factors.append(f"z{index}^{exponent}")
        terms.append(f"{coefficient}*{'*'.join(factors)}")
    return "+".join(terms) or "0"


def factor_patterns(polynomials):
    lines = ["ring r=23,(z0,z1,z2),dp;"]
    for index, polynomial in enumerate(polynomials):
        lines.extend(
            [
                f"poly f{index}={polynomial};",
                f"list L{index}=factorize(f{index});",
                f'print("BEGIN={index}");',
                f'print("COUNT="+string(size(L{index}[1])));',
                f"for (int j=1;j<=size(L{index}[1]);j++)",
                "{",
                f' print("FACTOR_DEG="+string(deg(L{index}[1][j]))+" MULT="+string(L{index}[2][j]));',
                "}",
            ]
        )
    lines.append("quit;")
    with tempfile.TemporaryDirectory(prefix="three_frame_factor_") as temporary:
        source = Path(temporary) / "factor.sing"
        source.write_text("\n".join(lines) + "\n")
        process = subprocess.run(
            ["Singular", "-q", str(source)], cwd=temporary,
            text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            check=False,
        )
    assert process.returncode == 0, process.stdout
    blocks = process.stdout.split("BEGIN=")[1:]
    assert len(blocks) == len(polynomials)
    patterns = []
    for expected, block in enumerate(blocks):
        raw_lines = block.strip().splitlines()
        assert int(raw_lines[0]) == expected
        count = int(raw_lines[1].split("=")[1])
        factors = []
        for line in raw_lines[2:]:
            if not line.startswith("FACTOR_DEG="):
                continue
            pieces = line.replace("FACTOR_DEG=", "").replace("MULT=", "").split()
            factors.append({"degree": int(pieces[0]), "multiplicity": int(pieces[1])})
        assert len(factors) == count
        patterns.append(factors)
    return patterns


def projective_points():
    points = []
    for first_nonzero in range(3):
        prefix = [0] * first_nonzero + [1]
        tail_count = 2 - first_nonzero
        for raw in np.ndindex(*(P,) * tail_count):
            points.append(tuple(prefix + list(raw)))
    assert len(points) == P * P + P + 1
    return points


def evaluate_row(row, monomials, point):
    answer = 0
    for coefficient, alpha in zip(row, monomials):
        term = int(coefficient)
        for value, exponent in zip(point, alpha):
            term = term * pow(value, exponent, P) % P
        answer += term
    return answer % P


def main():
    probe = landing.probe_core.Probe()
    basis = probe.basis(7, 8)[:6]
    quartic, _ = landing.pencil_core.reconstruct()
    tensor = landing.symmetric_quartic_tensor(quartic)
    monomials, indices, factors = coefficient_data()
    rng = np.random.default_rng(2026080159)
    base_points = [
        np.asarray([9, 18, 15, 18, 2, 19], dtype=np.int64)
    ] + [rng.integers(0, P, 6, dtype=np.int64) for _ in range(11)]
    triples = list(combinations(range(6), 3))
    rows = []
    descriptors = []
    for triple in triples:
        for point_index, point in enumerate(base_points):
            values = np.stack(
                [landing.fast_seed_values(probe, basis, point)[index]
                 for index in triple]
            )
            row = plane_row(tensor, values, indices, factors)
            assert np.any(row)
            rows.append(row)
            descriptors.append((triple, point_index))
    patterns = factor_patterns(
        [polynomial_text(row, monomials) for row in rows]
    )
    projective = projective_points()
    records = []
    for row, pattern, (triple, point_index) in zip(rows, patterns, descriptors):
        point_count = sum(
            evaluate_row(row, monomials, point) == 0 for point in projective
        )
        nonunit = [factor for factor in pattern if factor["degree"] > 0]
        records.append(
            {
                "triple": list(triple),
                "base_point_index": point_index,
                "base_point": base_points[point_index].tolist(),
                "coefficient_row": row.tolist(),
                "factorization_with_unit": pattern,
                "irreducible": len(nonunit) == 1 and nonunit[0] == {"degree": 4, "multiplicity": 1},
                "F23_projective_point_count": point_count,
            }
        )
    summaries = []
    for triple in triples:
        selected = [record for record in records if record["triple"] == list(triple)]
        summaries.append(
            {
                "triple": list(triple),
                "irreducible_specializations": sum(record["irreducible"] for record in selected),
                "sample_count": len(selected),
                "point_count_min": min(record["F23_projective_point_count"] for record in selected),
                "point_count_max": max(record["F23_projective_point_count"] for record in selected),
                "point_count_mean": sum(record["F23_projective_point_count"] for record in selected) / len(selected),
            }
        )
    payload = {
        "field": "F_23",
        "scope": "exact specialized discovery only; no K_Schur point",
        "frame_basis": [[int(output), list(exponents)] for output, exponents in basis],
        "base_point_rng_seed": 2026080159,
        "base_points": [point.tolist() for point in base_points],
        "summaries": summaries,
        "records": records,
    }
    OUTPUT.write_text(json.dumps(payload, indent=2) + "\n")
    print("SPECIALIZATION_SUMMARIES")
    for summary in summaries:
        print(summary)
    assert all(
        summary["irreducible_specializations"] == summary["sample_count"]
        for summary in summaries
    )
    canonical = next(
        summary for summary in summaries if summary["triple"] == [0, 1, 5]
    )
    print("ALL_240_SPECIALIZED_PLANE_QUARTICS_IRREDUCIBLE_OVER_F23")
    print(f"CANONICAL_DEGREE5_ALIGNED_TRIPLE={canonical}")
    print("SCOPE=exact F_23 specializations only; no invariant-rational point")


if __name__ == "__main__":
    main()
