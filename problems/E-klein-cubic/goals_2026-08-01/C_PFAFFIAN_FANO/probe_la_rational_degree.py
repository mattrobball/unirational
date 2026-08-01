#!/usr/bin/env python3
"""Probe total-degree rational ansatzes for one compressed L_a coordinate.

For x in K_proj sampled at the 918 sealed p=353 points, test

    x * q(t) = sum_s p_s(t) beta_s,

with deg(p_s),deg(q) <= D.  This is a feasibility/degree-floor probe only;
it never promotes one-prime data to characteristic zero.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
LOCAL_DATA = HERE / "la_samples_p353.npz"
DATA = LOCAL_DATA if LOCAL_DATA.exists() else ROOT / "tmp" / "c3_work" / "degree_probe_p353.npz"
P = 353


def monoms(degree, nvars=4):
    result = []

    def visit(remaining, prefix):
        if len(prefix) == nvars - 1:
            result.append(tuple(prefix + [remaining]))
            return
        for exponent in range(remaining + 1):
            visit(remaining - exponent, prefix + [exponent])

    for total in range(degree + 1):
        visit(total, [])
    return result


def monomial_values(ts, exponents):
    out = np.ones((len(ts), len(exponents)), dtype=np.int64)
    for column, exponent_tuple in enumerate(exponents):
        value = np.ones(len(ts), dtype=np.int64)
        for variable, exponent in enumerate(exponent_tuple):
            if exponent:
                value = value * np.power(ts[:, variable], exponent, dtype=np.int64) % P
        out[:, column] = value
    return out


def rank_mod(matrix, p=P):
    """Vectorized row echelon rank over F_p."""

    a = np.asarray(matrix, dtype=np.int64).copy() % p
    nrows, ncols = a.shape
    row = 0
    for column in range(ncols):
        candidates = np.flatnonzero(a[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        if pivot != row:
            a[[row, pivot]] = a[[pivot, row]]
        a[row, column:] = a[row, column:] * pow(int(a[row, column]), -1, p) % p
        active = np.flatnonzero(a[row + 1 :, column]) + row + 1
        if len(active):
            factors = a[active, column].copy()
            # Chunk to keep the temporary product comfortably below the RSS fence.
            for start in range(0, len(active), 128):
                rows = active[start : start + 128]
                fac = factors[start : start + 128]
                a[rows, column:] = (a[rows, column:] - fac[:, None] * a[row, column:]) % p
        row += 1
        if row == nrows:
            break
    return row


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--degree", type=int, required=True)
    parser.add_argument("--k", type=int, default=0, help="L_a row k")
    parser.add_argument("--j", type=int, default=1, help="L_a column j")
    parser.add_argument("--i", type=int, default=0, help="E coordinate a^i")
    args = parser.parse_args()

    packet = np.load(DATA)
    ts = packet["ts"].astype(np.int64) % P
    betas = packet["betas"].astype(np.int64) % P
    values = packet["La_E"][:, args.k, args.j, args.i].astype(np.int64) % P
    exponents = monoms(args.degree)
    mv = monomial_values(ts, exponents)
    numerator = np.concatenate([betas[:, s : s + 1] * mv % P for s in range(12)], axis=1)
    denominator = -(values[:, None] * mv) % P
    augmented = np.concatenate([numerator, denominator], axis=1) % P
    rank_numerator = rank_mod(numerator)
    rank_augmented = rank_mod(augmented)
    ncols = augmented.shape[1]
    result = {
        "scope": "one-prime degree probe only",
        "prime": P,
        "entry_k_j_i": [args.k, args.j, args.i],
        "degree": args.degree,
        "samples": len(ts),
        "monomials": len(exponents),
        "numerator_columns": numerator.shape[1],
        "denominator_columns": denominator.shape[1],
        "rank_numerator": rank_numerator,
        "rank_augmented": rank_augmented,
        "augmented_nullity": ncols - rank_augmented,
        "rational_ansatz_feasible": bool(rank_numerator == numerator.shape[1] and rank_augmented < ncols),
    }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
