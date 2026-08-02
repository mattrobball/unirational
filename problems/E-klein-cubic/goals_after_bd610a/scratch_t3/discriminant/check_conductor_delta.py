#!/usr/bin/env python3
"""Exact nonvanishing witness for Delta on the candidate conductor RUR prime.

The generic candidate is
  QZ(A,u,Z)=0, B*QZ_Z=NB(A,u,Z), Y*QZ_Z=NY(A,u,Z).
At exact rational specializations with squarefree degree-six QZ, reduce the
authoritative fixed-frame discriminant modulo QZ.  Any nonzero remainder (or
norm) proves the generic remainder/norm is not the zero rational function.

This packet depends on, but does not itself prove, the RUR prime and conductor
identification supplied by the normalization worker.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
SCRATCH = HERE.parent
Q_PATH = SCRATCH / "generic_singular_rur_QZ.tsv"
NB_PATH = SCRATCH / "generic_singular_rur_NB.tsv"
NY_PATH = SCRATCH / "generic_singular_rur_NY.tsv"
D_PATH = HERE / "fixed_frame_discriminant_Z.tsv"
Z = sp.symbols("Z")


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def specialize_tsv(path: Path, a_value: int, u_value: int):
    expression = 0
    with path.open() as stream:
        assert next(stream).strip() == "A\tu\tZ\tcoefficient"
        for line in stream:
            aa, uu, zz, coefficient = map(int, line.split())
            expression += coefficient * a_value**aa * u_value**uu * Z**zz
    return sp.Poly(expression, Z, domain=sp.QQ)


def reduce_delta(a_value, q, b_rep, y_rep):
    answer = sp.Poly(0, Z, domain=sp.QQ)
    b_powers = [sp.Poly(1, Z, domain=sp.QQ)]
    y_powers = [sp.Poly(1, Z, domain=sp.QQ)]
    for _ in range(6):
        b_powers.append((b_powers[-1] * b_rep).rem(q))
    for _ in range(9):
        y_powers.append((y_powers[-1] * y_rep).rem(q))
    with D_PATH.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tcoefficient"
        for line in stream:
            aa, bb, yy, zz, coefficient = map(int, line.split())
            term = b_powers[bb] * y_powers[yy] * sp.Poly(Z**zz, Z, domain=sp.QQ)
            term = term.mul_ground(coefficient * a_value**aa).rem(q)
            answer = (answer + term).rem(q)
    return answer


def primitive_coefficients(poly):
    denominator, cleared = poly.clear_denoms(convert=True)
    _content, primitive = cleared.primitive()
    if primitive.LC() < 0:
        primitive = -primitive
    return int(denominator), [int(value) for value in primitive.all_coeffs()]


def witness(a_value, u_value):
    q = specialize_tsv(Q_PATH, a_value, u_value)
    nb = specialize_tsv(NB_PATH, a_value, u_value)
    ny = specialize_tsv(NY_PATH, a_value, u_value)
    assert q.degree() == 6
    derivative = q.diff()
    assert sp.gcd(q, derivative).degree() == 0
    inverse = sp.invert(derivative, q)
    b_rep = (nb * inverse).rem(q)
    y_rep = (ny * inverse).rem(q)
    remainder = reduce_delta(a_value, q, b_rep, y_rep)
    assert remainder and remainder.degree() < 6
    norm = sp.resultant(q.as_expr(), remainder.as_expr(), Z)
    assert norm != 0
    q_denominator, q_coefficients = primitive_coefficients(q)
    remainder_denominator, remainder_coefficients = primitive_coefficients(remainder)
    norm_numerator, norm_denominator = sp.fraction(sp.cancel(norm))
    return {
        "A": a_value,
        "u": u_value,
        "QZ_degree": q.degree(),
        "QZ_squarefree": True,
        "QZ_primitive_coefficients_descending": q_coefficients,
        "QZ_clear_denominator": q_denominator,
        "Delta_remainder_degree": remainder.degree(),
        "Delta_remainder_nonzero": True,
        "Delta_remainder_primitive_coefficients_descending": remainder_coefficients,
        "Delta_remainder_clear_denominator": remainder_denominator,
        "Delta_norm_nonzero": True,
        "Delta_norm_numerator": str(norm_numerator),
        "Delta_norm_denominator": str(norm_denominator),
    }


def main():
    specializations = [(-6, -6), (1, 2)]
    payload = {
        "schema": "t3-candidate-conductor-delta-nonvanishing-v1",
        "candidate_prime": "(QZ, B*QZ_Z-NB, Y*QZ_Z-NY) over QQ(A,u)",
        "interpretation": "Nonzero exact specializations prove the generic Delta remainder and norm are nonzero, conditional on the candidate RUR prime/conductor identification.",
        "witnesses": [witness(a, u) for a, u in specializations],
        "sources": {
            str(Q_PATH.relative_to(SCRATCH)): file_hash(Q_PATH),
            str(NB_PATH.relative_to(SCRATCH)): file_hash(NB_PATH),
            str(NY_PATH.relative_to(SCRATCH)): file_hash(NY_PATH),
            str(D_PATH.relative_to(HERE)): file_hash(D_PATH),
        },
        "scope": "exact noncontainment/norm nonvanishing; does not certify the RUR equations or prove that this prime is the full conductor",
    }
    (HERE / "conductor_delta_payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, indent=2, sort_keys=True))
    print("T3_CONDUCTOR_DELTA_NONZERO_DONE")


if __name__ == "__main__":
    main()
