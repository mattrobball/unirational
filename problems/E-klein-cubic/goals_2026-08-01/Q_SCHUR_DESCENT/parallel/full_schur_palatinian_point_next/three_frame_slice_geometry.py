#!/usr/bin/env python3
"""Exact geometry and invariant-ratio probe for the canonical frame 3-slice.

The selected indices (0,1,5) are the output indices independently selected
by the complete degree-five Reynolds basis.  The calculations here are exact
in the good fibre.  The smooth-fibre test has a characteristic-zero generic
consequence; the finite invariant-ratio search does not.
"""
from __future__ import annotations

import hashlib
import importlib.util
import json
from math import comb
from pathlib import Path
import subprocess
import sys
import tempfile

import numpy as np

import degree9_full_landing as landing
import three_frame_slice_probe as survey


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
SURVEY = HERE / "three_frame_slice_specializations_f23.json"
OUTPUT = HERE / "three_frame_slice_certificate.json"
CHARACTER_SOURCE = ROOT / "tmp/projective_source/character_scan.py"
EXACT_CORE = ROOT / "tmp/pfaffian_representation_alignment/core.py"
UPSTREAM = (
    ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian"
)
P = 23
SELECTED = (0, 1, 5)
INVARIANT_DEGREES = (8, 10, 12, 14)
MIN_DEFINED_SPECIALIZATIONS = 6


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(name: str, path: Path):
    specification = importlib.util.spec_from_file_location(name, path)
    assert specification and specification.loader
    module = importlib.util.module_from_spec(specification)
    sys.modules[specification.name] = module
    specification.loader.exec_module(module)
    return module


def invariant_dimensions() -> dict[int, dict]:
    """Prove the four invariant dimensions by split-prime CRT."""
    characters = load("three_frame_invariant_characters", CHARACTER_SOURCE)
    primes = (23, 67, 89)
    scans = []
    for prime in primes:
        characters.configure_prime(prime)
        group = characters.paired_schur_group()
        inverse_order = pow(len(group), -1, prime)
        totals = [0] * (max(INVARIANT_DEGREES) + 1)
        for matrix, _ in group:
            traces = characters.complete_symmetric_traces(
                characters.FANO.inv(matrix), max(INVARIANT_DEGREES)
            )
            for degree, value in enumerate(traces):
                totals[degree] = (totals[degree] + value) % prime
        scans.append([value * inverse_order % prime for value in totals])
    answer = {}
    for degree in INVARIANT_DEGREES:
        residues = [row[degree] for row in scans]
        dimension, modulus = characters.crt(residues, list(primes))
        upper_bound = comb(degree + 5, 5)
        assert modulus > upper_bound
        answer[degree] = {
            "dimension": int(dimension),
            "residues": residues,
            "crt_modulus": int(modulus),
            "elementary_upper_bound": upper_bound,
        }
    assert [answer[d]["dimension"] for d in INVARIANT_DEGREES] == [4, 4, 14, 16]
    return answer


def transformed_points(probe, points):
    return [
        np.einsum("gij,j->gi", probe.group, point, optimize=True) % P
        for point in points
    ]


def invariant_values(exponents, transformed):
    values = []
    for orbit in transformed:
        row = np.ones(len(orbit), dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            for _ in range(exponent):
                row = row * orbit[:, coordinate] % P
        values.append(int(np.sum(row, dtype=np.int64) % P))
    return np.asarray(values, dtype=np.int64)


def add_echelon(echelon, row):
    row = np.asarray(row, dtype=np.int64) % P
    for pivot, old in echelon:
        if row[pivot]:
            row = (row - row[pivot] * old) % P
    nonzero = np.flatnonzero(row)
    if not len(nonzero):
        return False
    pivot = int(nonzero[0])
    row = row * pow(int(row[pivot]), -1, P) % P
    echelon.append((pivot, row))
    return True


def invariant_bases(probe, base_points, dimensions):
    rng = np.random.default_rng(2026080161)
    training_points = [
        rng.integers(0, P, 6, dtype=np.int64) for _ in range(20)
    ]
    training = transformed_points(probe, training_points)
    testing = transformed_points(probe, base_points)
    records = {}
    for degree in INVARIANT_DEGREES:
        expected = dimensions[degree]["dimension"]
        echelon = []
        exponents = []
        for candidate in landing.probe_core.monomials(degree, 6):
            if add_echelon(echelon, invariant_values(candidate, training)):
                exponents.append(candidate)
                if len(exponents) == expected:
                    break
        assert len(exponents) == expected
        values = np.stack(
            [invariant_values(candidate, testing) for candidate in exponents],
            axis=1,
        )
        records[degree] = {
            "reynolds_seed_exponents": [list(item) for item in exponents],
            "training_rank": len(echelon),
            "values": values,
        }
    return training_points, records


def smoothness_patterns(polynomials):
    lines = ["ring r=23,(z0,z1,z2),dp;"]
    for polynomial_index, polynomial in enumerate(polynomials):
        lines.append(f"poly f{polynomial_index}={polynomial};")
        for chart in range(3):
            generators = [
                f"subst(f{polynomial_index},z{chart},1)",
                *[
                    f"subst(diff(f{polynomial_index},z{variable}),z{chart},1)"
                    for variable in range(3)
                ],
            ]
            lines.extend(
                [
                    f"ideal J{polynomial_index}_{chart}=" + ",".join(generators) + ";",
                    f"ideal G{polynomial_index}_{chart}=std(J{polynomial_index}_{chart});",
                    (
                        f"if (reduce(1,G{polynomial_index}_{chart})==0) "
                        f'{{ print("SMOOTH={polynomial_index},{chart},1"); }} '
                        f'else {{ print("SMOOTH={polynomial_index},{chart},0"); }}'
                    ),
                ]
            )
    lines.append("quit;")
    with tempfile.TemporaryDirectory(prefix="three_frame_smooth_") as temporary:
        source = Path(temporary) / "smooth.sing"
        source.write_text("\n".join(lines) + "\n")
        process = subprocess.run(
            ["Singular", "-q", str(source)], cwd=temporary,
            text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            check=False,
        )
    assert process.returncode == 0, process.stdout
    result = [[False] * 3 for _ in polynomials]
    for line in process.stdout.splitlines():
        if not line.startswith("SMOOTH="):
            continue
        polynomial_index, chart, unit = map(int, line.split("=")[1].split(","))
        result[polynomial_index][chart] = bool(unit)
    assert all(all(charts) for charts in result), process.stdout
    return result


def add_candidate(candidates, mask, values, description):
    key = (tuple(bool(value) for value in mask), tuple(int(value) for value in values))
    candidates.setdefault(key, description)


def quotient_candidates(coefficient_rows, invariant_records):
    sample_count = len(coefficient_rows)
    candidates = {}
    for constant in range(P):
        add_candidate(
            candidates, [True] * sample_count, [constant] * sample_count,
            {"kind": "constant", "value": constant},
        )

    def add_ratios(values, family, degree):
        for numerator in range(values.shape[1]):
            for denominator in range(values.shape[1]):
                raw_denominator = values[:, denominator]
                mask = raw_denominator != 0
                inverse = np.asarray(
                    [pow(int(value), -1, P) if value else 0
                     for value in raw_denominator], dtype=np.int64,
                )
                base = values[:, numerator] * inverse % P
                for scalar in range(1, P):
                    add_candidate(
                        candidates, mask, scalar * base % P,
                        {
                            "kind": "single_basis_quotient",
                            "family": family,
                            "degree": degree,
                            "scalar": scalar,
                            "numerator_index": numerator,
                            "denominator_index": denominator,
                        },
                    )

    for degree in INVARIANT_DEGREES:
        add_ratios(
            invariant_records[degree]["values"],
            "complete_reynolds_invariant_basis", degree,
        )
    # Each plane-quartic coefficient is itself a degree-28 invariant.
    add_ratios(
        coefficient_rows, "selected_plane_quartic_coefficients", 28,
    )
    return candidates


def low_complexity_search(coefficient_rows, invariant_records):
    candidates = quotient_candidates(coefficient_rows, invariant_records)
    keys = list(candidates)
    masks = np.asarray([key[0] for key in keys], dtype=bool)
    values = np.asarray([key[1] for key in keys], dtype=np.int64)
    monomials = landing.probe_core.monomials(4, 3)
    allowed = np.zeros((len(coefficient_rows), P, P), dtype=bool)
    for sample, row in enumerate(coefficient_rows):
        for a in range(P):
            for b in range(P):
                value = sum(
                    int(coefficient)
                    * pow(a, alpha[1], P)
                    * pow(b, alpha[2], P)
                    for coefficient, alpha in zip(row, monomials)
                ) % P
                allowed[sample, a, b] = value == 0

    eligible_pairs = 0
    hits = []
    for left_index, (left_mask, left_values) in enumerate(zip(masks, values)):
        defined = masks & left_mask
        eligible = defined.sum(axis=1) >= MIN_DEFINED_SPECIALIZATIONS
        eligible_pairs += int(np.count_nonzero(eligible))
        valid = eligible.copy()
        for sample in range(len(coefficient_rows)):
            valid &= (
                (~defined[:, sample])
                | allowed[sample, int(left_values[sample]), values[:, sample]]
            )
        for right_index in np.flatnonzero(valid):
            hits.append(
                {
                    "a": candidates[keys[left_index]],
                    "b": candidates[keys[int(right_index)]],
                    "defined_specializations": int(defined[right_index].sum()),
                }
            )
    assert not hits
    return {
        "candidate_function_behaviors_after_deduplication": len(keys),
        "ordered_candidate_pairs": len(keys) ** 2,
        "eligible_pairs_defined_on_at_least_six_common_samples": eligible_pairs,
        "minimum_required_common_samples": MIN_DEFINED_SPECIALIZATIONS,
        "survivor_count": len(hits),
        "survivors": hits,
        "ansatz": (
            "a and b are each a constant or a scalar times one basis invariant "
            "divided by another of the same degree; degrees 8,10,12,14 and "
            "the fifteen degree-28 plane-quartic coefficients are tested"
        ),
    }


def produce():
    frozen = json.loads(SURVEY.read_text())
    probe = landing.probe_core.Probe()
    frame_basis = probe.basis(7, 8)[:6]
    degree_five_basis = probe.basis(5, 3)
    assert tuple(output for output, _ in degree_five_basis) == SELECTED
    assert all(
        exponents == (0, 0, 0, 0, 0, 7)
        for _, exponents in frame_basis
    )
    assert frozen["frame_basis"] == [
        [int(output), list(exponents)] for output, exponents in frame_basis
    ]

    base_points = [
        np.asarray(point, dtype=np.int64) for point in frozen["base_points"]
    ]
    quartic, _ = landing.pencil_core.reconstruct()
    tensor = landing.symmetric_quartic_tensor(quartic)
    monomials, indices, factors = survey.coefficient_data()
    rows = []
    for point in base_points:
        all_values = landing.fast_seed_values(probe, frame_basis, point)
        values = np.stack([all_values[index] for index in SELECTED])
        rows.append(survey.plane_row(tensor, values, indices, factors))
    coefficient_rows = np.stack(rows)
    selected_records = [
        record for record in frozen["records"]
        if record["triple"] == list(SELECTED)
    ]
    assert len(selected_records) == len(base_points) == 12
    assert coefficient_rows.tolist() == [
        record["coefficient_row"] for record in selected_records
    ]

    polynomials = [
        survey.polynomial_text(row, monomials) for row in coefficient_rows
    ]
    factorizations = survey.factor_patterns(polynomials)
    irreducible = []
    for pattern in factorizations:
        nonunits = [factor for factor in pattern if factor["degree"] > 0]
        irreducible.append(
            len(nonunits) == 1
            and nonunits[0] == {"degree": 4, "multiplicity": 1}
        )
    assert all(irreducible)
    smoothness = smoothness_patterns(polynomials)
    assert all(record["irreducible"] for record in frozen["records"])

    dimensions = invariant_dimensions()
    training_points, invariant_records = invariant_bases(
        probe, base_points, dimensions
    )
    search = low_complexity_search(coefficient_rows, invariant_records)
    point_counts = [
        record["F23_projective_point_count"] for record in selected_records
    ]
    return {
        "schema": "full-schur-canonical-three-frame-slice-v1",
        "prime": P,
        "selected_triple": list(SELECTED),
        "selection_reason": (
            "the independently selected complete degree-five Reynolds basis "
            "has output indices 0,1,5; this is a canonical tie-break among "
            "the six same-seed degree-seven frame columns"
        ),
        "degree_five_basis": [
            [int(output), list(exponents)] for output, exponents in degree_five_basis
        ],
        "degree_seven_frame_basis": [
            [int(output), list(exponents)] for output, exponents in frame_basis
        ],
        "local_source_sha256": {
            "three_frame_slice_probe.py": sha256(HERE / "three_frame_slice_probe.py"),
            "three_frame_slice_geometry.py": sha256(HERE / "three_frame_slice_geometry.py"),
            "three_frame_slice_specializations_f23.json": sha256(SURVEY),
            "degree9_full_landing.py": sha256(HERE / "degree9_full_landing.py"),
            "SEAL.json": sha256(HERE / "SEAL.json"),
            "source_manifest.json": sha256(HERE / "source_manifest.json"),
        },
        "external_source_sha256": {
            "tmp/projective_source/character_scan.py": sha256(CHARACTER_SOURCE),
            "tmp/pfaffian_representation_alignment/core.py": sha256(EXACT_CORE),
            (
                "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/"
                "probe_self_covariants_palatinian.py"
            ): sha256(UPSTREAM / "probe_self_covariants_palatinian.py"),
            (
                "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/"
                "verify_char0_palatinian_lift.py"
            ): sha256(UPSTREAM / "verify_char0_palatinian_lift.py"),
        },
        "all_coordinate_triples": {
            "count": 20,
            "specializations_per_triple": 12,
            "irreducible_over_F23": sum(
                bool(record["irreducible"]) for record in frozen["records"]
            ),
            "total_specializations": len(frozen["records"]),
        },
        "selected_slice": {
            "coefficient_rows": coefficient_rows.tolist(),
            "factorizations_with_unit": factorizations,
            "irreducible_specializations": sum(irreducible),
            "projectively_smooth_over_algebraic_closure": [
                all(charts) for charts in smoothness
            ],
            "smooth_specializations": sum(all(charts) for charts in smoothness),
            "F23_projective_point_counts": point_counts,
            "point_count_min": min(point_counts),
            "point_count_max": max(point_counts),
            "witness_base_point": base_points[0].tolist(),
            "witness_quartic": polynomials[0],
            "witness_specialized_point": [1, 0, 0],
        },
        "invariant_dimensions": {
            str(degree): dimensions[degree] for degree in INVARIANT_DEGREES
        },
        "invariant_reynolds_bases": {
            str(degree): {
                "reynolds_seed_exponents": invariant_records[degree]["reynolds_seed_exponents"],
                "training_rank": invariant_records[degree]["training_rank"],
            }
            for degree in INVARIANT_DEGREES
        },
        "invariant_basis_training_rng_seed": 2026080161,
        "invariant_basis_training_points": [point.tolist() for point in training_points],
        "low_complexity_invariant_ratio_search": search,
        "proved_generic_geometry": (
            "the characteristic-zero generic selected plane section is a "
            "smooth geometrically integral plane quartic of genus 3, hence "
            "it has no rational parametrization"
        ),
        "strict_scope": [
            "no K_Schur-rational point is found or excluded",
            "the displayed F23 point is specialized and is not a rational section",
            "the finite quotient search excludes only its stated single-basis-term ansatz",
            "smooth genus three excludes parametrizing the whole generic plane curve, not a K_Schur point",
            "no V14(K_Schur), X_Schur(K_Schur), or binary Q verdict",
        ],
    }


def main():
    payload = produce()
    OUTPUT.write_text(json.dumps(payload, indent=2) + "\n")
    search = payload["low_complexity_invariant_ratio_search"]
    print(
        "PASS all 240 F23 quartics irreducible and all 12 canonical-slice "
        "quartics geometrically smooth"
    )
    print(
        f"PASS invariant-ratio probe candidates={search['candidate_function_behaviors_after_deduplication']} "
        f"eligible_pairs={search['eligible_pairs_defined_on_at_least_six_common_samples']} "
        "survivors=0"
    )
    print("FULL_SCHUR_CANONICAL_THREE_FRAME_SLICE_PROBE_OK")
    print("SCOPE: generic genus-three nonparametrization and bounded ratio search; no K_Schur point verdict")


if __name__ == "__main__":
    main()
