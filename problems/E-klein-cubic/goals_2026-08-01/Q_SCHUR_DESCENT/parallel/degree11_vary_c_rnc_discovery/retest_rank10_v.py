#!/usr/bin/env python3
"""Retest rare rank-10 constant columns at independent full-source points."""

from __future__ import annotations

import itertools
import json
from pathlib import Path

import search


HERE = Path(__file__).resolve().parent
SEC = search.SEC
BASE = search.BASE
P = search.P


def class_setup(record):
    subgroup = tuple(tuple(value) for value in record["subgroup_elements"])
    generators = tuple(tuple(value) for value in record["generators"])
    abstract_map = {
        tuple(row["h"]): tuple(row["permutation"]) for row in record["source_map"]
    }
    intertwiner = BASE.ambient_intertwiner(generators, abstract_map)
    representatives = BASE.right_coset_representatives(subgroup)
    return subgroup, abstract_map, intertwiner, representatives


def admissible(vector, subgroup, abstract_map, representatives):
    for representative in representatives:
        moved = BASE.mat_vec(
            BASE.PRODUCE.RHO[BASE.PRODUCE.ginv(representative)], vector
        )
        frame = BASE.transfer_frame(moved, subgroup, abstract_map)
        if frame is None or not BASE.determinant(frame):
            return False
    return True


def find_vectors(setup, count=6):
    subgroup, abstract_map, _intertwiner, representatives = setup
    original = (1, 4, 5, 5, 6)
    vectors = [original]
    for vector in itertools.product(range(1, 14), repeat=5):
        if vector == original:
            continue
        if admissible(vector, subgroup, abstract_map, representatives):
            vectors.append(vector)
            if len(vectors) == count:
                break
    assert len(vectors) == count
    return vectors


def orbit_points(vector, constant, parameters, covariants, setup):
    subgroup, abstract_map, intertwiner, representatives = setup
    points = []
    for representative in representatives:
        moved = BASE.mat_vec(
            BASE.PRODUCE.RHO[BASE.PRODUCE.ginv(representative)], vector
        )
        frame = BASE.transfer_frame(moved, subgroup, abstract_map)
        assert frame is not None and BASE.determinant(frame)
        source_point = BASE.mat_vec(frame, constant)
        canonical = BASE.canonical_point(source_point, parameters, covariants)
        raw = BASE.mat_vec(intertwiner, canonical)
        point = BASE.mat_vec(BASE.PRODUCE.RHO[representative], raw)
        if not any(point):
            return None
        assert BASE.klein(point) == 0
        points.append(point)
    return points


def main():
    discovery = json.loads((HERE / "results.json").read_text())
    twists = json.loads((BASE.SUBGROUP / "twists.json").read_text())
    covariants = BASE.load_covariants()
    map_data = {
        "A5_class_1_root_0": (twists["records"][0], -1, SEC.class1_roots()[0]),
        "A5_class_2_root_0": (twists["records"][1], 1, SEC.class2_roots()[0]),
        "A5_class_2_root_1": (twists["records"][1], 1, SEC.class2_roots()[1]),
        "A5_class_2_root_2": (twists["records"][1], 1, SEC.class2_roots()[2]),
    }
    setups = {
        0: class_setup(twists["records"][0]),
        1: class_setup(twists["records"][1]),
    }
    vectors = {
        class_index: find_vectors(setup)
        for class_index, setup in setups.items()
    }
    records = []
    for result in discovery["results"]:
        label = result["label"]
        if not result["rank_10_points"]:
            continue
        record, radical_sign, root = map_data[label]
        class_index = 0 if label.startswith("A5_class_1") else 1
        setup = setups[class_index]
        parameters = SEC.parameter_vector(radical_sign, root)
        for constant in result["rank_10_points"]:
            ranks = []
            for vector in vectors[class_index]:
                points = orbit_points(
                    tuple(vector), tuple(constant), parameters, covariants, setup
                )
                rank = (
                    None
                    if points is None
                    else BASE.matrix_rank([BASE.quadric_row(point) for point in points])
                )
                ranks.append(rank)
            assert ranks[0] == 10
            assert any(rank == 11 for rank in ranks[1:])
            row = {
                "label": label,
                "constant_c": constant,
                "full_source_vectors": [list(vector) for vector in vectors[class_index]],
                "quadric_ranks": ranks,
                "generic_rank_10_identity": False,
            }
            records.append(row)
            print(label, "c", constant, "ranks", ranks)
    assert len(records) == 10
    payload = {
        "format": "A5-RANK10-INDEPENDENT-V-RETEST-v1",
        "prime": P,
        "records": records,
        "conclusion": (
            "Every rare rank-10 value at v=(1,4,5,5,6) becomes rank 11 at "
            "an admissible independent v, so none is a generic rational-function "
            "rank-10 identity for its fixed constant c."
        ),
        "scope": (
            "A nonzero rank-11 minor modulo 89 proves nonidentity in characteristic "
            "zero for each listed fixed c; it does not exclude a nonconstant c(v) "
            "or an algebraic point of the full determinantal locus."
        ),
    }
    (HERE / "rank10_retest.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("A5_RANK10_CASES_FAIL_GENERIC_V_IDENTITY_OK")


if __name__ == "__main__":
    main()
