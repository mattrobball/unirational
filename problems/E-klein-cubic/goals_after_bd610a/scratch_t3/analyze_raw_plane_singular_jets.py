#!/usr/bin/env python3
"""Exact transverse jets of the raw target along J1 and J2 on the plane.

Coordinates are a=A-15, y=Y-12, s=Z and t=B-B0(s).  Coefficients are
computed as exact polynomials in s.  The output is a finite all-source jet
certificate used to select the completed-local normalization calculation.
"""

from __future__ import annotations

import hashlib
import json
from collections import defaultdict
from fractions import Fraction
from math import comb
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
OUT = HERE / "raw_plane_singular_jets.json"
MAX_ORDER = 4


def load_h():
    rows = []
    with H_PATH.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tcoefficient"
        for line in stream:
            rows.append(tuple(map(int, line.split())))
    return rows


def add_linear_power(target, scalar, slope, power, zpower, factor):
    """Add factor*(scalar+slope*s)^power*s^zpower to exponent dictionary."""
    for r in range(power + 1):
        value = factor * comb(power, r) * scalar ** (power - r) * slope**r
        if value:
            target[zpower + r] += value


def jet(rows, scalar: Fraction, slope: Fraction):
    # key=(a-order,y-order,t-order), value=dict s-exponent -> rational
    answer = defaultdict(lambda: defaultdict(Fraction))
    for ae, be, ye, ze, coefficient in rows:
        for ia in range(min(ae, MAX_ORDER) + 1):
            ca = Fraction(comb(ae, ia) * 15 ** (ae - ia))
            for iy in range(min(ye, MAX_ORDER - ia) + 1):
                cay = ca * comb(ye, iy) * 12 ** (ye - iy)
                for it in range(min(be, MAX_ORDER - ia - iy) + 1):
                    factor = Fraction(coefficient) * cay * comb(be, it)
                    add_linear_power(
                        answer[(ia, iy, it)], scalar, slope, be - it, ze, factor
                    )
    return {
        key: {e: c for e, c in value.items() if c}
        for key, value in answer.items()
        if any(value.values())
    }


def primitive_coefficients(value):
    s = sp.symbols("s")
    poly = sp.Poly(sum(sp.Rational(c.numerator, c.denominator) * s**e for e, c in value.items()), s, domain=sp.QQ)
    content, primitive = poly.primitive()
    return {
        "degree_s": primitive.degree(),
        "content": str(content),
        "coefficients_constant_first": [str(primitive.nth(i)) for i in range(primitive.degree() + 1)],
        "factorization": str(sp.factor(primitive.as_expr())),
    }


def summarize(values):
    by_order = defaultdict(list)
    for key, value in values.items():
        by_order[sum(key)].append((key, value))
    first = min(by_order)
    return {
        "first_nonzero_transverse_order": first,
        "terms_through_order": {
            str(order): [
                {"exponents_a_y_t": list(key), "coefficient": primitive_coefficients(value)}
                for key, value in sorted(by_order[order])
            ]
            for order in sorted(by_order)
            if order <= MAX_ORDER
        },
    }


def main():
    rows = load_h()
    data = {
        "schema": "t3-raw-plane-singular-transverse-jets-v1",
        "coordinates": "a=A-15, y=Y-12, s=Z, t=B-B0(s)",
        "max_transverse_order": MAX_ORDER,
        "J1": {
            "equation": "B-10Z+1258=0",
            "B0": "10*s-1258",
            **summarize(jet(rows, Fraction(-1258), Fraction(10))),
        },
        "J2": {
            "equation": "2B+Z-133=0",
            "B0": "(133-s)/2",
            **summarize(jet(rows, Fraction(133, 2), Fraction(-1, 2))),
        },
        "source_sha256": hashlib.sha256(H_PATH.read_bytes()).hexdigest(),
    }
    OUT.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
    print("T3_RAW_PLANE_SINGULAR_JETS_DONE")
    for label in ("J1", "J2"):
        print(label, "first order", data[label]["first_nonzero_transverse_order"])


if __name__ == "__main__":
    main()
