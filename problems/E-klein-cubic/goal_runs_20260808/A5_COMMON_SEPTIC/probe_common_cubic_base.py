#!/usr/bin/env python3
"""Build the common 22-point A5 configuration and its cubic base ideal.

This is a discovery probe.  It reconstructs both exact degree-eleven cycles
at the common good specialization used by the independently replayed A5Q
variant, computes the complete vector space of cubics through their union,
and emits a Singular script for the scheme-theoretic base locus.
"""

from __future__ import annotations

import argparse
import importlib.util
import itertools
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
A5Q = ROOT / "goals_after_bd610a" / "A5Q_QUARTIC_RESCUE_WORK"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


sys.path.insert(0, str(A5Q))
core = load_module("a5q_verify_all", A5Q / "verify_all.py")

P = 89
COMMON_V = [71, 10, 17, 18, 13, 44]
SELECTED_ALPHA = {"A5_class_1": 80, "A5_class_2": 49}
SPECIALIZATIONS = {
    89: {
        "v": [71, 10, 17, 18, 13, 44],
        "alpha": {"A5_class_1": 80, "A5_class_2": 49},
    },
    199: {
        "v": [141, 180, 170, 70, 138, 170],
        "alpha": {"A5_class_1": 76, "A5_class_2": 120},
    },
}


def nullspace_mod(matrix: list[list[int]], p: int) -> list[list[int]]:
    """Return a row basis of the right nullspace over F_p."""
    a = [[x % p for x in row] for row in matrix]
    rows = len(a)
    cols = len(a[0])
    pivots: list[int] = []
    r = 0
    for c in range(cols):
        pivot = next((i for i in range(r, rows) if a[i][c]), None)
        if pivot is None:
            continue
        a[r], a[pivot] = a[pivot], a[r]
        inv = pow(a[r][c], -1, p)
        a[r] = [(inv * x) % p for x in a[r]]
        for i in range(rows):
            if i != r and a[i][c]:
                q = a[i][c]
                a[i] = [(x - q * y) % p for x, y in zip(a[i], a[r])]
        pivots.append(c)
        r += 1
        if r == rows:
            break
    free = [c for c in range(cols) if c not in pivots]
    basis: list[list[int]] = []
    for f in free:
        v = [0] * cols
        v[f] = 1
        for i, c in enumerate(pivots):
            v[c] = (-a[i][f]) % p
        basis.append(v)
    return basis


def weak_compositions(total: int, length: int):
    if length == 1:
        yield (total,)
        return
    for first in range(total, -1, -1):
        for tail in weak_compositions(total - first, length - 1):
            yield (first,) + tail


def eval_monomials(point: list[int], exponents, p: int) -> list[int]:
    return [
        __import__("functools").reduce(
            lambda z, pair: z * pow(pair[0], pair[1], p) % p,
            zip(point, exponent),
            1,
        )
        for exponent in exponents
    ]


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
    representatives = core.decode_coset_representatives(
        class_record, words, group, subgroup
    )
    map_record = core.extract_map_record(class_record)
    degree, coordinate = core.parse_seed(map_record)
    assert (degree, coordinate) == (4, 5)

    b_frame = core.hilbert_frame(
        COMMON_V, subgroup, sigma, source, degree, coordinate, P
    )
    assert core.determinant(b_frame, P)
    intertwiner = core.reconstruct_intertwiner(
        record, subgroup, h_to_perm, target, augmentation, P
    )
    point_payload = json.loads((core.A5_ROOT / label / "point.json").read_text())
    relations = core.constant_relations(point_payload, sqrt5, sqrt_minus11, P)
    assert alpha in core.alpha_roots(relations, P)
    parameters = core.landing_parameters(relations, alpha, P)

    points = []
    for representative in representatives:
        moved_v = core.mat_vec(source[representative], COMMON_V, P)
        moved_b = core.hilbert_frame(
            moved_v, subgroup, sigma, source, degree, coordinate, P
        )
        source_point = [moved_b[row][0] for row in range(3)]
        canonical_point = core.evaluate_landing(
            covariants, source_point, parameters, P
        )
        installed_point = core.mat_vec(intertwiner, canonical_point, P)
        common_upstairs = core.mat_vec(
            target_inverse[representative], installed_point, P
        )
        descended_point = core.mat_vec(q_inverse, common_upstairs, P)
        point = list(core.projective(descended_point, P))
        assert core.klein(core.mat_vec(q_frame, point, P), P) == 0
        points.append(point)
    assert len(set(map(tuple, points))) == 11
    return points


def polynomial(vector: list[int], exponents) -> str:
    terms = []
    for coefficient, exponent in zip(vector, exponents):
        coefficient %= P
        if coefficient == 0:
            continue
        factors = []
        for i, power in enumerate(exponent):
            if power == 1:
                factors.append(f"x{i}")
            elif power > 1:
                factors.append(f"x{i}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(f"{coefficient}*{monomial}")
    return "+".join(terms) or "0"


def main() -> None:
    global P, COMMON_V, SELECTED_ALPHA
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, choices=sorted(SPECIALIZATIONS), default=89)
    args = parser.parse_args()
    P = args.prime
    COMMON_V = SPECIALIZATIONS[P]["v"]
    SELECTED_ALPHA = SPECIALIZATIONS[P]["alpha"]

    payload = json.loads(core.RANK_PATH.read_text())
    core.verify_input_hashes(payload)
    prime_record = next(record for record in payload["primes"] if record["p"] == P)
    coset_record = next(record for record in payload["primes"] if record["p"] == 89)
    zeta = int(prime_record["zeta11"]) % P
    sqrt5 = int(prime_record["sqrt5"]) % P
    sqrt_minus11 = int(prime_record["sqrt_minus11"]) % P

    frame = json.loads(core.SCHUR_PATH.read_text())
    twists = json.loads(core.TWISTS_PATH.read_text())
    raw_covariants = json.loads(core.RAW_COVARIANTS_PATH.read_text())
    group, words = core.abstract_group()
    source, target = core.reconstruct_representations(
        frame, group, words, zeta, P
    )
    target_inverse = {g: core.mat_inverse(target[g], P) for g in group}
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
    assert schur_invariant and core.determinant(q_frame, P)
    q_inverse = core.mat_inverse(q_frame, P)

    cycles = {}
    for label in ("A5_class_1", "A5_class_2"):
        cycles[label] = reconstruct_cycle(
            label,
            SELECTED_ALPHA[label],
            records[label],
            coset_record["classes"][label],
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
    points = cycles["A5_class_1"] + cycles["A5_class_2"]
    assert len(set(map(tuple, points))) == 22

    exponents = list(weak_compositions(3, 5))
    assert len(exponents) == 35
    evaluation = [eval_monomials(point, exponents, P) for point in points]
    rank = core.matrix_rank(evaluation, P)
    cubics = nullspace_mod(evaluation, P)
    assert rank + len(cubics) == 35

    data = {
        "prime": P,
        "points": points,
        "cubic_exponents": exponents,
        "evaluation_rank": rank,
        "cubic_kernel_dimension": len(cubics),
        "cubic_kernel": cubics,
    }
    (HERE / f"common_cubics_p{P}.json").write_text(
        json.dumps(data, indent=2) + "\n"
    )

    ideal = ",\n  ".join(polynomial(vector, exponents) for vector in cubics)
    singular = f"""ring r={P},(x0,x1,x2,x3,x4),dp;
ideal I=
  {ideal};
ideal J=std(I);
print(\"A5_COMMON_CUBIC_BASE\");
print(\"generator_count\"); print(size(I));
print(\"dimension\"); print(dim(J));
print(\"degree\"); print(degree(J));
print(\"hilbert=\");
hilb(J,1);
quit;
"""
    (HERE / f"common_cubic_base_p{P}.sing").write_text(singular)
    print(
        f"A5_COMMON_CUBICS_READY points=22 eval_rank={rank} "
        f"kernel_dim={len(cubics)}"
    )


if __name__ == "__main__":
    main()
