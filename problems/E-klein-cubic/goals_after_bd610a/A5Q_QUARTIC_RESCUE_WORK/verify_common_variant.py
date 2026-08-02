#!/usr/bin/env python3
"""Replay the two A5Q degree-eleven cycles at one common mod-89 point.

The sibling ``verify_all.py`` supplies only elementary finite-field and exact
input decoding routines.  This script reconstructs both subgroup transports
from the sealed representation/covariant inputs at the *same* Schur vector
and in the same full-twist frame.  It does not read serialized point rows or
stored rank assertions.
"""

from __future__ import annotations

import json

import verify_all as core


P = 89
COMMON_V = [71, 10, 17, 18, 13, 44]
SELECTED_ALPHA = {
    "A5_class_1": 80,
    "A5_class_2": 49,
}
EXPECTED_COMBINED_MINOR_DET = 83


def reconstruct_cycle(
    label,
    alpha,
    record,
    class_record,
    group,
    words,
    source,
    target,
    target_inverse,
    a5_rep,
    augmentation,
    covariants,
    sqrt5,
    sqrt_minus11,
    q_frame,
    q_inverse,
):
    subgroup, h_to_perm, sigma = core.subgroup_source(record, a5_rep, P)
    assert len(subgroup) == 60
    representatives = core.decode_coset_representatives(
        class_record, words, group, subgroup
    )
    assert len(representatives) == 11

    map_record = core.extract_map_record(class_record)
    degree, coordinate = core.parse_seed(map_record)
    assert (degree, coordinate) == (4, 5)

    source_orbit = {
        core.projective(core.mat_vec(source[g], COMMON_V, P), P) for g in group
    }
    assert len(source_orbit) == 660

    b_frame = core.hilbert_frame(
        COMMON_V, subgroup, sigma, source, degree, coordinate, P
    )
    assert core.determinant(b_frame, P)
    source_point = [b_frame[row][0] for row in range(3)]
    assert len(
        {
            core.projective(core.mat_vec(sigma[h], source_point, P), P)
            for h in subgroup
        }
    ) == 60

    intertwiner = core.reconstruct_intertwiner(
        record, subgroup, h_to_perm, target, augmentation, P
    )
    point_payload = json.loads((core.A5_ROOT / label / "point.json").read_text())
    relations = core.constant_relations(
        point_payload, sqrt5, sqrt_minus11, P
    )
    assert alpha in core.alpha_roots(relations, P)
    parameters = core.landing_parameters(relations, alpha, P)

    points = []
    for representative in representatives:
        moved_v = core.mat_vec(source[representative], COMMON_V, P)
        moved_b = core.hilbert_frame(
            moved_v, subgroup, sigma, source, degree, coordinate, P
        )
        moved_source_point = [moved_b[row][0] for row in range(3)]
        canonical_point = core.evaluate_landing(
            covariants, moved_source_point, parameters, P
        )
        assert any(canonical_point)
        installed_point = core.mat_vec(intertwiner, canonical_point, P)
        assert any(installed_point)
        assert core.klein(installed_point, P) == 0

        common_upstairs = core.mat_vec(
            target_inverse[representative], installed_point, P
        )
        descended_point = core.mat_vec(q_inverse, common_upstairs, P)
        assert any(descended_point)
        assert core.klein(core.mat_vec(q_frame, descended_point, P), P) == 0
        points.append(list(core.projective(descended_point, P)))

    assert len(set(map(tuple, points))) == 11
    assert core.matrix_rank(points, P) == 5
    monomials, quadratic_evaluations = core.quadratic_rows(points, P)
    assert core.matrix_rank(quadratic_evaluations, P) == 11
    print(
        f"PASS common-v {label} alpha={alpha} "
        f"point_rank=5 quadratic_rank=11"
    )
    return monomials, quadratic_evaluations


def main() -> None:
    payload = json.loads(core.RANK_PATH.read_text())
    core.verify_input_hashes(payload)
    prime_record = core.extract_prime_record(payload)
    assert int(prime_record.get("p", prime_record.get("prime"))) == P
    zeta = int(prime_record["zeta11"]) % P
    sqrt5 = int(prime_record["sqrt5"]) % P
    sqrt_minus11 = int(prime_record["sqrt_minus11"]) % P
    assert pow(zeta, 11, P) == 1
    assert all(pow(zeta, exponent, P) != 1 for exponent in range(1, 11))
    assert sqrt5 * sqrt5 % P == 5
    assert sqrt_minus11 * sqrt_minus11 % P == -11 % P

    frame = json.loads(core.SCHUR_PATH.read_text())
    twists = json.loads(core.TWISTS_PATH.read_text())
    raw_covariants = json.loads(core.RAW_COVARIANTS_PATH.read_text())
    assert frame["format"] == "q-schur-exact-degree8-frame-v1"
    assert twists["format"] == "H-SUBGROUP-GENERIC-TWISTS-v1"
    assert raw_covariants["format"] == "a5-degree11-raw-reynolds-covariants-v1"

    group, words = core.abstract_group()
    assert len(group) == 660
    assert frame["projective_words"] == [words[g] for g in group]
    source, target = core.reconstruct_representations(
        frame, group, words, zeta, P
    )
    target_inverse = {g: core.mat_inverse(target[g], P) for g in group}
    assert all(matrix is not None for matrix in target_inverse.values())

    a5_rep = core.exact_a5_representation(sqrt5, P)
    sylow5 = core.sylow_five_subgroups(a5_rep)
    augmentation = {
        permutation: core.augmentation_matrix(permutation, sylow5, P)
        for permutation in a5_rep
    }
    covariants = core.reduce_raw_covariants(raw_covariants, sqrt5, P)
    records = {record["label"]: record for record in twists["records"]}

    q_frame, schur_invariant = core.schur_frame(
        COMMON_V, group, source, target_inverse, P
    )
    assert schur_invariant
    assert core.determinant(q_frame, P)
    q_inverse = core.mat_inverse(q_frame, P)
    assert q_inverse is not None

    cycle_rows = {}
    monomial_order = None
    for label in ("A5_class_1", "A5_class_2"):
        monomials, rows = reconstruct_cycle(
            label,
            SELECTED_ALPHA[label],
            records[label],
            prime_record["classes"][label],
            group,
            words,
            source,
            target,
            target_inverse,
            a5_rep,
            augmentation,
            covariants,
            sqrt5,
            sqrt_minus11,
            q_frame,
            q_inverse,
        )
        if monomial_order is None:
            monomial_order = monomials
        else:
            assert monomials == monomial_order
        cycle_rows[label] = rows

    combined = cycle_rows["A5_class_1"] + cycle_rows["A5_class_2"]
    assert len(combined) == 22
    assert all(len(row) == 15 for row in combined)
    assert core.matrix_rank(combined, P) == 15
    leading_minor = combined[:15]
    determinant = core.determinant(leading_minor, P)
    assert determinant == EXPECTED_COMBINED_MINOR_DET
    print(
        "PASS common-cycle combined_quadratic_rank=15 "
        f"rows=0..14 columns=0..14 det={determinant} mod {P}"
    )
    print("A5Q_COMMON_CYCLE_QUADRATIC_RANK15_OK")


if __name__ == "__main__":
    main()
