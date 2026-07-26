#!/usr/bin/env python3
"""Explore flex eliminants on one-parameter source lines modulo 23.

This is an exploratory helper for the generic-frame plane cubics.  It keeps
one source parameter ``s``, forms the ternary cubic and its Hessian, and
eliminates one plane coordinate.  The resulting bivariate polynomial is
written as Macaulay2 syntax for factorization over GF(23^3).
"""

from __future__ import annotations

import argparse
from itertools import combinations
from pathlib import Path
import sys

import sympy as sp

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from certificates.generic_frame_planes_specialization import (
    cov_c,
    cov_d,
    cov_e,
    cov_k,
    klein,
)


P = 23
NAMES = ("x", "C", "D", "E", "K")


def reduced(expr, *gens):
    return sp.Poly(sp.expand(expr), *gens, modulus=P).as_expr()


def source_line(index: int, s):
    """A short deterministic list of reasonably generic affine lines."""
    lines = (
        ((1, 3, 7, 9, 14), (2, 5, 8, 11, 17)),
        ((4, 6, 10, 15, 19), (1, 7, 12, 16, 21)),
        ((2, 9, 13, 18, 22), (3, 4, 11, 14, 20)),
    )
    u, v = lines[index]
    return tuple((u[i] + v[i] * s) for i in range(5))


def plane_data(line_index: int, triple_index: int):
    s, a, b, c = sp.symbols("s a b c")
    x = source_line(line_index, s)
    named = {
        "x": x,
        "C": cov_c(x),
        "D": cov_d(x),
        "E": cov_e(x),
        "K": cov_k(x),
    }
    triple = tuple(combinations(NAMES, 3))[triple_index]
    cols = [named[name] for name in triple]
    y = [a * cols[0][i] + b * cols[1][i] + c * cols[2][i] for i in range(5)]
    f = reduced(klein(y), s, a, b, c)
    matrix = sp.Matrix([[sp.diff(f, u, v) for v in (a, b, c)] for u in (a, b, c)])
    h = reduced(matrix.det(), s, a, b, c)
    return (s, a, b, c), triple, f, h


def m2(expr) -> str:
    # SymPy uses **; Macaulay2 uses ^.  Coefficients are already centered
    # representatives modulo 23, which Macaulay2 accepts.
    return str(sp.expand(expr)).replace("**", "^")


def flex_eliminant(line_index: int, triple_index: int):
    """Return the primitive affine flex eliminant and infinity diagnostic."""
    (s, a, b, c), triple, f, h = plane_data(line_index, triple_index)
    fa = reduced(f.subs(c, 1), s, a, b)
    ha = reduced(h.subs(c, 1), s, a, b)
    resultant = sp.resultant(fa, ha, b)
    resultant = sp.Poly(resultant, s, a, modulus=P)
    _, primitive = sp.Poly(resultant, a, domain=sp.GF(P).poly_ring(s)).primitive()
    primitive = sp.Poly(primitive.as_expr(), s, a, modulus=P)

    infinity = sp.resultant(
        reduced(f.subs({c: 0, b: 1}), s, a),
        reduced(h.subs({c: 0, b: 1}), s, a),
        a,
    )
    infinity = sp.Poly(infinity, s, modulus=P)
    return (s, a, b, c), triple, f, h, primitive, infinity


def write_m2_factor_file(output: Path, primitive):
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(
        "R=GF(23^3)[s,a,MonomialOrder=>GRevLex];\n"
        f"q={m2(primitive.as_expr())};\n"
        "print (\"terms\", # terms q);\n"
        "fac=factor q;\n"
        "powers=select(toList fac,z->class z===Power and degree(first toList z)=!={0});\n"
        "print (\"nonconstant_factors\", length powers, apply(powers,z->degree first toList z), \"exponents\", apply(powers,z->last toList z));\n"
        "exit 0;\n"
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--line", type=int, default=0)
    parser.add_argument("--triple", type=int, default=0)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()

    (s, a, b, c), triple, f, h, primitive, infinity = flex_eliminant(
        args.line, args.triple
    )

    print(
        "triple", "".join(triple),
        "f_terms", len(sp.Poly(f, s, a, b, c, modulus=P).terms()),
        "h_terms", len(sp.Poly(h, s, a, b, c, modulus=P).terms()),
        "elim_degree_s", primitive.degree(s),
        "elim_degree_a", primitive.degree(a),
        "elim_terms", len(primitive.terms()),
        "infinity_zero", infinity.is_zero,
        "infinity_degree_s", infinity.degree() if not infinity.is_zero else -1,
    )

    output = args.output or Path("tmp/plane_genus_one/flex_factor.m2")
    write_m2_factor_file(output, primitive)
    print("wrote", output)


if __name__ == "__main__":
    main()
