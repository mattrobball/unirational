#!/usr/bin/env python3
"""Exact reciprocal-root incidence jets at generic J2.

Coordinates are

    a=A-15, y=Y-12, s=2B+Z-133, z=Z, v=1/u,

so B=(133-z+s)/2.  For the authoritative primitive sextic P, put
q=v^6 P(1/v).  We work over QQ(z), solve q_v=0 formally for a, and print
the reduced fold equation q|_(q_v=0) through a requested local order.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from collections import defaultdict
from fractions import Fraction
from math import comb
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"

a, y, s, v, z = sp.symbols("a y s v z")
LOCAL = (a, y, s, v)
REDUCED = (y, s, v)


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def truncate(expression, variables, bound):
    expression = sp.cancel(expression)
    numerator, denominator = sp.fraction(expression)
    # This helper is used only after coefficients have entered QQ(z); the
    # denominator is independent of the local variables.
    assert not any(variable in denominator.free_symbols for variable in variables)
    poly = sp.Poly(sp.expand(numerator), *variables, domain=sp.QQ.frac_field(z))
    kept = sum(
        coefficient * sp.prod(variable**exponent for variable, exponent in zip(variables, monomial))
        for monomial, coefficient in poly.terms()
        if sum(monomial) <= bound
    )
    return sp.cancel(kept / denominator)


def homogeneous(expression, variables, degree):
    poly = sp.Poly(sp.cancel(expression), *variables, domain=sp.QQ.frac_field(z))
    return sp.factor(
        sum(
            coefficient * sp.prod(variable**exponent for variable, exponent in zip(variables, monomial))
            for monomial, coefficient in poly.terms()
            if sum(monomial) == degree
        )
    )


def build_q_jet(bound):
    answer = defaultdict(lambda: sp.Poly(0, z, domain=sp.QQ))
    with P_PATH.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            Aexp, Bexp, Yexp, Zexp, uexp, coefficient = map(int, line.split())
            vexp = 6 - uexp
            assert 0 <= vexp <= 6
            for aexp in range(Aexp + 1):
                for yexp in range(Yexp + 1):
                    for sexp in range(Bexp + 1):
                        if aexp + yexp + sexp + vexp > bound:
                            continue
                        scalar = (
                            Fraction(coefficient)
                            * comb(Aexp, aexp)
                            * 15 ** (Aexp - aexp)
                            * comb(Yexp, yexp)
                            * 12 ** (Yexp - yexp)
                            * comb(Bexp, sexp)
                            * Fraction(1, 2) ** Bexp
                        )
                        base = sp.Poly((133 - z) ** (Bexp - sexp) * z**Zexp, z, domain=sp.QQ)
                        answer[(aexp, yexp, sexp, vexp)] += scalar * base
    return {
        monomial: coefficient.as_expr()
        for monomial, coefficient in answer.items()
        if not coefficient.is_zero
    }


def derivative_v(poly):
    answer = {}
    for (ea, ey, es, ev), coefficient in poly.items():
        if ev:
            answer[(ea, ey, es, ev - 1)] = coefficient * ev
    return answer


def multiply3(left, right, bound):
    answer = defaultdict(lambda: sp.Integer(0))
    for m1, c1 in left.items():
        for m2, c2 in right.items():
            monomial = tuple(i + j for i, j in zip(m1, m2))
            if sum(monomial) <= bound:
                answer[monomial] += c1 * c2
    return {monomial: sp.cancel(value) for monomial, value in answer.items() if value != 0}


def power3(poly, exponent, bound):
    answer = {(0, 0, 0): sp.Integer(1)}
    for _ in range(exponent):
        answer = multiply3(answer, poly, bound)
    return answer


def substitute_a(poly, a_series, bound):
    answer = defaultdict(lambda: sp.Integer(0))
    powers = {exponent: power3(a_series, exponent, bound) for exponent in {row[0] for row in poly}}
    for (ea, ey, es, ev), coefficient in poly.items():
        base_degree = ey + es + ev
        for (ay, ass, av), a_coefficient in powers[ea].items():
            monomial = (ay + ey, ass + es, av + ev)
            if sum(monomial) <= bound and sum(monomial) >= base_degree:
                answer[monomial] += coefficient * a_coefficient
    return {monomial: sp.cancel(value) for monomial, value in answer.items() if value != 0}


def dict_piece(poly, degree):
    return {
        monomial: value
        for monomial, value in poly.items()
        if sum(monomial) == degree and value != 0
    }


def dict_expression(poly, variables):
    return sum(
        value * sp.prod(variable**exponent for variable, exponent in zip(variables, monomial))
        for monomial, value in poly.items()
    )


def implicit_a_series(qv, bound):
    lam = sp.cancel(qv[(1, 0, 0, 0)])
    assert lam != 0
    series = {}
    pieces = []
    for degree in range(1, bound + 1):
        residual = dict_piece(substitute_a(qv, series, degree), degree)
        correction = {monomial: sp.cancel(-value / lam) for monomial, value in residual.items()}
        for monomial, value in correction.items():
            series[monomial] = sp.cancel(series.get(monomial, 0) + value)
        check = dict_piece(substitute_a(qv, series, degree), degree)
        assert not check
        pieces.append(correction)
    return lam, series, pieces


def factor_coefficient(value):
    value = sp.factor(value)
    numerator, denominator = sp.fraction(value)
    return {"numerator": str(sp.factor(numerator)), "denominator": str(sp.factor(denominator))}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--order", type=int, default=6)
    args = parser.parse_args()
    assert args.order >= 4

    q = build_q_jet(args.order + 1)
    qv = derivative_v(q)
    assert q.get((0, 0, 0, 0), 0) == 0 and qv.get((0, 0, 0, 0), 0) == 0
    lam, a_series, corrections = implicit_a_series(qv, args.order)
    reduced = substitute_a(q, a_series, args.order)

    q_pieces = {}
    qv_pieces = {}
    reduced_pieces = {}
    for degree in range(1, args.order + 1):
        q_piece = dict_expression(dict_piece(q, degree), LOCAL)
        qv_piece = dict_expression(dict_piece(qv, degree), LOCAL)
        red_piece = dict_expression(dict_piece(reduced, degree), REDUCED)
        if q_piece != 0:
            q_pieces[str(degree)] = str(sp.factor(q_piece))
        if qv_piece != 0:
            qv_pieces[str(degree)] = str(sp.factor(qv_piece))
        if red_piece != 0:
            reduced_pieces[str(degree)] = str(sp.factor(red_piece))

    payload = {
        "schema": "t3-j2-reciprocal-incidence-jets-v1",
        "coordinates": {
            "a": "A-15",
            "y": "Y-12",
            "s": "2B+Z-133",
            "z": "Z",
            "v": "1/u",
            "B": "(133-z+s)/2",
        },
        "field": "QQ(z)",
        "order": args.order,
        "q_homogeneous_pieces": q_pieces,
        "qv_homogeneous_pieces": qv_pieces,
        "qv_a_at_origin": factor_coefficient(lam),
        "a_solution_homogeneous_pieces": {
            str(index): str(sp.factor(dict_expression(piece, REDUCED)))
            for index, piece in enumerate(corrections, start=1)
            if piece
        },
        "reduced_fold_homogeneous_pieces": reduced_pieces,
        "source_sha256": {P_PATH.name: sha(P_PATH)},
    }
    (HERE / "j2_incidence_jets.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, indent=2, sort_keys=True))
    print("T3_J2_RECIPROCAL_INCIDENCE_JETS_DONE")


if __name__ == "__main__":
    main()
