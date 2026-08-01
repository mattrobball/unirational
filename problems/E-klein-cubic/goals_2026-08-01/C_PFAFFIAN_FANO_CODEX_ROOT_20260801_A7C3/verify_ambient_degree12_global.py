#!/usr/bin/env python3
"""Global exact verification of the reconstructed ambient degree-12 RUR.

Each Pluecker residual is a degree-24 invariant in the five source variables.
The integral invariant module has dimension 40.  We independently verify that
the sealed 40-point evaluation matrix has rank 40 modulo 23, then check all 15
residuals exactly in the cubic RUR quotient at every point.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import multiprocessing
import runpy
from itertools import combinations
from pathlib import Path

import probe_ambient_degree12_char0_lift as exact_probe


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P = 23
PAIRS = tuple(combinations(range(6), 2))
PAIR_INDEX = {pair: index for index, pair in enumerate(PAIRS)}

WORKER_PF = None
WORKER_W = None
WORKER_COEFFICIENTS = None
WORKER_SEEDS = None
WORKER_RECORDS = None


def sha256_file(path):
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def rank_mod(matrix, prime):
    work = [list(map(lambda value: int(value) % prime, row)) for row in matrix]
    rows = len(work)
    columns = len(work[0])
    rank = 0
    pivot_product = 1
    for column in range(columns):
        pivot = next((row for row in range(rank, rows) if work[row][column]), None)
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        pivot_product = pivot_product * work[rank][column] % prime
        inverse = pow(work[rank][column], -1, prime)
        work[rank] = [value * inverse % prime for value in work[rank]]
        for row in range(rows):
            if row != rank and work[row][column]:
                scalar = work[row][column]
                work[row] = [
                    (left - scalar * right) % prime
                    for left, right in zip(work[row], work[rank])
                ]
        rank += 1
        if rank == rows:
            break
    return rank, pivot_product


def point_cache_path(index):
    return HERE / f"ambient_degree12_global_point_{index:02d}.json"


def verify_point(task):
    index, point = task
    assert WORKER_PF is not None
    assert WORKER_W is not None
    assert WORKER_COEFFICIENTS is not None
    assert WORKER_SEEDS is not None
    assert WORKER_RECORDS is not None
    pf = WORKER_PF
    K = pf["K11"]
    values = exact_probe.evaluate_covariants(
        tuple(point), WORKER_SEEDS, WORKER_RECORDS, pf
    )
    wedge = [[K.zero, K.zero, K.zero] for _ in range(15)]
    for coefficient, value in zip(WORKER_COEFFICIENTS, values):
        for row in range(15):
            wedge[row] = exact_probe.qadd(
                wedge[row], exact_probe.qscale(value[row], coefficient)
            )
    residuals = []
    for i, j, k, ell in combinations(range(6), 4):
        residuals.append(exact_probe.qadd(
            exact_probe.qadd(
                exact_probe.qmul(
                    wedge[PAIR_INDEX[(i, j)]], wedge[PAIR_INDEX[(k, ell)]], WORKER_W, K
                ),
                exact_probe.qscale(
                    -K.one,
                    exact_probe.qmul(
                        wedge[PAIR_INDEX[(i, k)]], wedge[PAIR_INDEX[(j, ell)]], WORKER_W, K
                    ),
                ),
            ),
            exact_probe.qmul(
                wedge[PAIR_INDEX[(i, ell)]], wedge[PAIR_INDEX[(j, k)]], WORKER_W, K
            ),
        ))
    nonzero = [residual_index for residual_index, value in enumerate(residuals) if value != [K.zero] * 3]
    result = {
        "format": "ambient-degree12-global-point-v1",
        "index": index,
        "point": point,
        "cubic_quotient_residual_count": 15,
        "nonzero_residual_indices": nonzero,
        "all_zero": not nonzero,
    }
    path = point_cache_path(index)
    path.write_text(json.dumps(result, indent=2) + "\n")
    print(f"point={index} allZero={not nonzero} cache={path.name}", flush=True)
    if nonzero:
        raise AssertionError(f"point {index} has nonzero residuals {nonzero}")
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--workers", type=int, default=4)
    args = parser.parse_args()
    assert 1 <= args.workers <= 4

    unisolvent_path = HERE / "degree24_unisolvent_points.json"
    unisolvent = json.loads(unisolvent_path.read_text())
    assert unisolvent["format"] == "degree24-invariant-unisolvent-p23-v1"
    assert unisolvent["prime"] == P and len(unisolvent["points"]) == 40

    core = runpy.run_path(str(ROOT / "tmp/kproj_arithmetic/core.py"))
    columns = core["module_columns"](24)
    assert len(columns) == 40
    polynomials = [column[2] for column in columns]
    recomputed_matrix = [
        [core["evaluate_mod"](polynomial, tuple(point), P) for polynomial in polynomials]
        for point in unisolvent["points"]
    ]
    assert recomputed_matrix == unisolvent["evaluation_matrix_mod_23"]
    rank, pivot_product = rank_mod(recomputed_matrix, P)
    assert rank == 40 and pivot_product != 0
    print(f"degree24InvariantDimension=40 evaluationRank={rank}", flush=True)

    pf = runpy.run_path(str(ROOT / "tmp/pfaffian_representation_alignment/core.py"))
    fw = runpy.run_path(str(ROOT / "tmp/pfaffian_rank2_idempotent_attack/full_wedge.py"))
    states = exact_probe.word_states(pf, fw["fano"])
    basis = exact_probe.source_basis(states, pf)
    records = exact_probe.group_records(states, basis, pf)
    w, coefficient_polynomials = exact_probe.lift_rur(pf)
    seeds = [
        (int(output), tuple(exponents))
        for output, exponents in json.loads((HERE / "ambient_degree12_a47_chart.json").read_text())["seeds"]
    ]
    assert len(states) == len(records) == 660 and len(seeds) == 48
    print("exactRecords=660 seeds=48", flush=True)

    global WORKER_PF, WORKER_W, WORKER_COEFFICIENTS, WORKER_SEEDS, WORKER_RECORDS
    WORKER_PF = pf
    WORKER_W = w
    WORKER_COEFFICIENTS = coefficient_polynomials
    WORKER_SEEDS = seeds
    WORKER_RECORDS = records

    results_by_index = {}
    missing = []
    for index, point in enumerate(unisolvent["points"]):
        path = point_cache_path(index)
        if path.is_file():
            cached = json.loads(path.read_text())
            if (
                cached.get("format") == "ambient-degree12-global-point-v1"
                and cached.get("index") == index
                and cached.get("point") == point
                and cached.get("all_zero") is True
                and cached.get("nonzero_residual_indices") == []
            ):
                results_by_index[index] = cached
                print(f"reusedPointCache={path.name}", flush=True)
                continue
        missing.append((index, point))
    if missing and args.workers == 1:
        fresh = [verify_point(task) for task in missing]
    elif missing:
        context = multiprocessing.get_context("fork")
        with context.Pool(min(args.workers, len(missing))) as pool:
            fresh = pool.map(verify_point, missing)
    else:
        fresh = []
    for result in fresh:
        results_by_index[result["index"]] = result
    ordered = [results_by_index[index] for index in range(40)]
    assert all(result["all_zero"] for result in ordered)

    report = {
        "format": "ambient-degree12-global-exact-v1",
        "theorem": "all 15 degree-24 invariant Pluecker residuals vanish identically in the cubic RUR quotient",
        "reason": "40 integral degree-24 invariant basis columns and a rank-40 evaluation matrix; exact zero at all 40 points",
        "group_order": 660,
        "covariant_degree": 12,
        "residual_degree": 24,
        "invariant_dimension": 40,
        "unisolvent_rank_mod_23": rank,
        "unisolvent_pivot_product_mod_23": pivot_product,
        "points_checked": 40,
        "residuals_per_point": 15,
        "all_exact_zero": True,
        "source_sha256": {
            "char0_rur": sha256_file(HERE / "ambient_degree12_rur_char0.json"),
            "unisolvent_points": sha256_file(unisolvent_path),
        },
    }
    output = HERE / "ambient_degree12_global_exact.json"
    output.write_text(json.dumps(report, indent=2) + "\n")
    print(f"WROTE {output}")
    print("AMBIENT-D12-GLOBAL-EXACT-PLUECKER-VERIFIED")


if __name__ == "__main__":
    main()
