#!/usr/bin/env python3
"""Test whether the rectangular determinant clears an L_a coordinate.

This is a modular degree probe at p=353.  It tests whether

    rect_det * (L_a)_{k,j,i}

is a polynomial K_proj element of bounded total degree in the certified
rank-12 basis.  A pass remains modular and needs characteristic-zero
reconstruction plus holdout verification.
"""

from __future__ import annotations

import argparse
import json

import numpy as np

from probe_la_rational_degree import DATA, P, monomial_values, monoms, rank_mod


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--degree", type=int, required=True)
    parser.add_argument("--k", type=int, default=0)
    parser.add_argument("--j", type=int, default=1)
    parser.add_argument("--i", type=int, default=0)
    args = parser.parse_args()

    packet = np.load(DATA)
    ts = packet["ts"].astype(np.int64) % P
    betas = packet["betas"].astype(np.int64) % P
    values = packet["La_E"][:, args.k, args.j, args.i].astype(np.int64) % P
    determinant = packet["rect_dets"].astype(np.int64) % P
    exponents = monoms(args.degree)
    mv = monomial_values(ts, exponents)
    design = np.concatenate([betas[:, s : s + 1] * mv % P for s in range(12)], axis=1)
    rhs = (values * determinant % P)[:, None]
    rank_design = rank_mod(design)
    rank_augmented = rank_mod(np.concatenate([design, rhs], axis=1))
    print(json.dumps({
        "scope": "one-prime known-denominator probe only",
        "prime": P,
        "entry_k_j_i": [args.k, args.j, args.i],
        "degree": args.degree,
        "samples": len(ts),
        "numerator_columns": design.shape[1],
        "rank_design": rank_design,
        "rank_augmented": rank_augmented,
        "rectangular_determinant_clears_at_degree": bool(rank_augmented == rank_design),
    }, indent=2))


if __name__ == "__main__":
    main()
