#!/usr/bin/env python3
"""Bounded good-fibre discovery for sparse degree-nine self-covariants.

The output is not a characteristic-zero point certificate.  A survivor must
be lifted over Q(zeta_11) and checked symbolically before it has arithmetic
meaning.
"""
from __future__ import annotations

import argparse
import importlib.util
from itertools import combinations, product
from pathlib import Path
import sys

import numpy as np


ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
PACKET = ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian"


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


probe_core = load("full_schur_degree9_probe", PACKET / "probe_self_covariants_palatinian.py")
pencil_core = load(
    "full_schur_pencil_core",
    Path(__file__).resolve().parent / "pencil_mod23.py",
)

P = 23


def evaluate_quartic_batch(quartic, points: np.ndarray) -> np.ndarray:
    answer = np.zeros(points.shape[0], dtype=np.int64)
    for monomial, coefficient in quartic.items():
        term = np.full(points.shape[0], coefficient, dtype=np.int64)
        for coordinate, exponent in enumerate(monomial):
            if exponent:
                term = term * np.power(points[:, coordinate], exponent) % P
        answer = (answer + term) % P
    return answer


def candidate_batches(support_size: int, dimension: int, batch_size: int):
    rows = []
    for support in combinations(range(dimension), support_size):
        # Projectively normalize the first support coefficient to one.
        for tail in product(range(1, P), repeat=support_size - 1):
            row = np.zeros(dimension, dtype=np.int64)
            row[support[0]] = 1
            row[np.asarray(support[1:], dtype=np.int64)] = tail
            rows.append(row)
            if len(rows) == batch_size:
                yield np.stack(rows)
                rows = []
    if rows:
        yield np.stack(rows)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-support", type=int, default=3)
    parser.add_argument("--samples", type=int, default=18)
    parser.add_argument("--batch-size", type=int, default=4096)
    arguments = parser.parse_args()

    probe = probe_core.Probe()
    basis = probe.basis(9, 19)
    quartic, _ = pencil_core.reconstruct()
    rng = np.random.default_rng(2026080110)
    sample_points = [
        rng.integers(0, P, 6, dtype=np.int64)
        for _ in range(arguments.samples)
    ]
    values = [
        np.stack([probe.eval_seed(*seed, point) for seed in basis])
        for point in sample_points
    ]
    print(f"DEGREE9_BASIS={basis}")
    print(f"SAMPLES={len(values)}")

    total = 0
    survivors = []
    for support_size in range(1, arguments.max_support + 1):
        support_total = 0
        support_survivors = []
        for batch in candidate_batches(support_size, len(basis), arguments.batch_size):
            total += len(batch)
            support_total += len(batch)
            live = batch
            for evaluation in values:
                outputs = live @ evaluation % P
                mask = evaluate_quartic_batch(quartic, outputs) == 0
                live = live[mask]
                if not len(live):
                    break
            support_survivors.extend(live.tolist())
        print(
            f"SUPPORT={support_size} TESTED={support_total} "
            f"SAMPLE_SURVIVORS={len(support_survivors)}"
        )
        survivors.extend(support_survivors)

    # A sampled survivor is tested at 200 fresh points, still only in F_23.
    verified = []
    for raw in survivors:
        coefficients = np.asarray(raw, dtype=np.int64)
        good = True
        for _ in range(200):
            point = rng.integers(0, P, 6, dtype=np.int64)
            output = sum(
                int(coefficients[index]) * probe.eval_seed(*seed, point)
                for index, seed in enumerate(basis)
            ) % P
            if evaluate_quartic_batch(quartic, output[None, :])[0]:
                good = False
                break
        if good:
            verified.append(raw)
    print(f"TOTAL_TESTED={total}")
    print(f"FRESH_200_POINT_SURVIVORS={verified}")
    print("SCOPE=bounded sparse discovery over F_23 only")


if __name__ == "__main__":
    main()
