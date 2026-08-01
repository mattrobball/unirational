#!/usr/bin/env python3
"""Probe polynomial degrees for the rectangle determinant and Cramer products."""

from __future__ import annotations

import argparse
import json

import numpy as np

from probe_la_rational_degree import DATA, P, monomial_values, monoms, rank_mod


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--degree", type=int, required=True)
    parser.add_argument("--series", choices=("rect_det", "la_times_rect"), required=True)
    parser.add_argument("--k", type=int, default=0)
    parser.add_argument("--j", type=int, default=1)
    parser.add_argument("--i", type=int, default=0)
    args = parser.parse_args()

    packet = np.load(DATA)
    ts = packet["ts"].astype(np.int64) % P
    betas = packet["betas"].astype(np.int64) % P
    rect = packet["rect_dets"].astype(np.int64) % P
    if args.series == "rect_det":
        values = rect
    else:
        values = packet["La_E"][:, args.k, args.j, args.i].astype(np.int64) * rect % P

    exponents = monoms(args.degree)
    mv = monomial_values(ts, exponents)
    design = np.concatenate([betas[:, s : s + 1] * mv % P for s in range(12)], axis=1)
    rank_design = rank_mod(design)
    rank_with_value = rank_mod(np.concatenate([design, values[:, None]], axis=1))
    print(json.dumps({
        "scope": "one-prime polynomial degree probe only",
        "prime": P,
        "series": args.series,
        "entry_k_j_i": [args.k, args.j, args.i] if args.series == "la_times_rect" else None,
        "degree": args.degree,
        "samples": len(ts),
        "unknowns": design.shape[1],
        "rank_design": rank_design,
        "rank_with_value": rank_with_value,
        "polynomial_ansatz_consistent": bool(rank_design == rank_with_value),
    }, indent=2))


if __name__ == "__main__":
    main()
