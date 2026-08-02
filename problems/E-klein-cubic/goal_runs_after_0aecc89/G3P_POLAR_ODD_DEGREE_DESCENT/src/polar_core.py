#!/usr/bin/env python3
"""Shared polar algebra for G3P (used by produce; verifiers re-derive independently).

Convention (matches goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json and
tmp/generic_twist/phi_coefficients.py):

  Phi(a) = sum_{0<=i<=j<=k<=4} c_ijk * a_i * a_j * a_k

where c_ijk is the stored coefficient (already the multiset monomial coefficient).
The unique symmetric trilinear B with B(x,x,x)=Phi(x) satisfies

  c_iii = B(e_i,e_i,e_i)
  c_iij = 3 B(e_i,e_i,e_j)   (i!=j)
  c_ijk = 6 B(e_i,e_j,e_k)   (distinct)

so beta(i,j,k) := B(e_i,e_j,e_k) is recovered by dividing c by 1, 3, or 6.
"""

from __future__ import annotations

import itertools
import json
from collections import Counter
from pathlib import Path
from typing import Sequence

import sympy as sp

ROOT = Path(__file__).resolve().parents[3]
GENERIC_CUBIC = ROOT / "goals_2026-08-01" / "G_ALL_DEGREE" / "generic_cubic.json"
G3A_SRC = ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"

import sys

if str(G3A_SRC) not in sys.path:
    sys.path.insert(0, str(G3A_SRC))

from field_api import (  # noqa: E402
    PARAMETERS,
    SECONDARY_DEGREES,
    SECONDARY_NAMES,
    add,
    basis,
    eq,
    load_products,
    multiply,
    one,
    scale,
    zero,
)
from phi_api import coefficient_map, load_generic_cubic  # noqa: E402

FRAME_NAMES = ("x", "C", "D", "E", "K_7")
FRAME_DEGREES = (1, 4, 5, 6, 7)
DIM_AMB = 5
DIM_K = 12

# Canonical tautological ambient point: identity covariant x in the normalized frame.
Q_POINT = (1, 0, 0, 0, 0)


def expr_to_json(expr: sp.Expr) -> dict:
    expr = sp.cancel(sp.together(expr))
    num, den = sp.fraction(expr)
    num = sp.expand(num)
    den = sp.expand(den)
    return {
        "num": str(num),
        "den": str(den),
        "str": str(expr),
    }


def kproj_to_json(elem: Sequence) -> dict:
    components = []
    nonzero = []
    for i, c in enumerate(elem):
        c = sp.cancel(sp.together(c))
        components.append(expr_to_json(c))
        if c != 0:
            nonzero.append({"basis": i, "name": SECONDARY_NAMES[i], "degree": SECONDARY_DEGREES[i], **expr_to_json(c)})
    return {
        "components": components,
        "nonzero": nonzero,
        "is_zero": len(nonzero) == 0,
    }


def entry_to_kproj(entries) -> tuple:
    comps = [sp.S.Zero] * DIM_K
    for e in entries:
        mon = sp.Rational(e["numerator"], e["denominator"])
        for p, ex in zip(PARAMETERS, e["projective_exponents"]):
            mon *= p**ex
        comps[e["secondary"]] += mon
    return tuple(map(lambda z: sp.cancel(sp.together(z)), comps))


def load_betas(payload=None, products=None):
    """Return beta[i][j][k] = B(e_i,e_j,e_k) as K_proj 12-tuples."""

    payload = payload or load_generic_cubic(GENERIC_CUBIC)
    cmap = coefficient_map(payload)
    beta = [[[None for _ in range(DIM_AMB)] for _ in range(DIM_AMB)] for _ in range(DIM_AMB)]
    for i, j, k in itertools.product(range(DIM_AMB), repeat=3):
        triple = tuple(sorted((i, j, k)))
        c = entry_to_kproj(cmap[triple]["normalized_entries"])
        cnt = Counter(triple)
        if len(cnt) == 1:
            b = c
        elif len(cnt) == 2:
            b = scale(sp.Rational(1, 3), c)
        else:
            b = scale(sp.Rational(1, 6), c)
        beta[i][j][k] = b
    return beta, payload, cmap


def phi_of_vector(a: Sequence, beta) -> tuple:
    """Phi(a) = B(a,a,a) with a_i in a ground ring commuting with K_proj, or K_proj elems.

    Here a is a length-5 sequence of *scalars in P0/QQ* (sympy exprs), not K_proj vectors.
    Coefficients beta live in K_proj; result is K_proj.
    """

    acc = zero()
    for i, j, k in itertools.product(range(DIM_AMB), repeat=3):
        coeff = a[i] * a[j] * a[k]
        if coeff == 0:
            continue
        acc = add(acc, scale(coeff, beta[i][j][k]))
    return tuple(map(lambda z: sp.cancel(sp.together(z)), acc))


def B_form(u: Sequence, v: Sequence, w: Sequence, beta) -> tuple:
    """B(u,v,w) for scalar coordinate vectors u,v,w over P0/QQ."""

    acc = zero()
    for i, j, k in itertools.product(range(DIM_AMB), repeat=3):
        coeff = u[i] * v[j] * w[k]
        if coeff == 0:
            continue
        acc = add(acc, scale(coeff, beta[i][j][k]))
    return tuple(map(lambda z: sp.cancel(sp.together(z)), acc))


def second_polar_linear_form(beta, q=Q_POINT):
    """Coefficients L_i = B(q,q,e_i) so H_q: sum L_i v_i = 0."""

    return [B_form(q, q, tuple(1 if r == i else 0 for r in range(DIM_AMB)), beta) for i in range(DIM_AMB)]


def first_polar_matrix(beta, q=Q_POINT):
    """Symmetric matrix M_ij = B(q, e_i, e_j); Q_q: v^T M v = 0."""

    M = []
    for i in range(DIM_AMB):
        row = []
        for j in range(DIM_AMB):
            ei = tuple(1 if r == i else 0 for r in range(DIM_AMB))
            ej = tuple(1 if r == j else 0 for r in range(DIM_AMB))
            row.append(B_form(q, ei, ej, beta))
        M.append(row)
    return M


def line_poly_coeffs(v: Sequence, beta, q=Q_POINT):
    """Return (A, B1, C1, D) with P_v(t)= A + 3 B1 t + 3 C1 t^2 + D t^3.

    A=Phi(q), B1=B(q,q,v), C1=B(q,v,v), D=Phi(v).
    """

    A = B_form(q, q, q, beta)
    B1 = B_form(q, q, v, beta)
    C1 = B_form(q, v, v, beta)
    D = B_form(v, v, v, beta)
    return A, B1, C1, D


def specialize_kproj(elem, tvals, svals) -> sp.Expr:
    """Ring hom K_proj -> QQ: sum_i elem[i](tvals)*svals[i]."""

    td = dict(zip(PARAMETERS, tvals))
    total = sp.Integer(0)
    for i, c in enumerate(elem):
        cv = sp.simplify(c.subs(td))
        total += sp.sympify(cv) * svals[i]
    return sp.together(total)


def matrix_specialized(M, tvals, svals) -> sp.Matrix:
    return sp.Matrix(DIM_AMB, DIM_AMB, lambda i, j: specialize_kproj(M[i][j], tvals, svals))


def cubic_discriminant_sym(A, B1, C1, D):
    """Discriminant of P(t)= D t^3 + 3 C1 t^2 + 3 B1 t + A (scalar coeffs)."""

    a, b, c, d = D, 3 * C1, 3 * B1, A
    return sp.simplify(18 * a * b * c * d - 4 * b**3 * d + b**2 * c**2 - 4 * a * c**3 - 27 * a**2 * d**2)


def verify_polarization_identity(beta, samples=None) -> list:
    """Check Phi(q+tv) expansion against direct evaluation on scalar samples."""

    if samples is None:
        samples = [
            ((1, 0, 0, 0, 0), (0, 1, 0, 0, 0), [0, 1, -1, 2]),
            ((1, 0, 0, 0, 0), (1, 1, 1, 1, 1), [0, 1, -2]),
            ((1, 0, 0, 0, 0), (0, 1, -1, 2, 3), [1, -1, 3]),
        ]
    reports = []
    for q, v, ts in samples:
        A, B1, C1, D = line_poly_coeffs(v, beta, q)
        for t in ts:
            direct = phi_of_vector(tuple(q[i] + t * v[i] for i in range(5)), beta)
            via = add(A, add(scale(3 * t, B1), add(scale(3 * t * t, C1), scale(t**3, D))))
            via = tuple(map(lambda z: sp.cancel(sp.together(z)), via))
            ok = eq(direct, via)
            reports.append({"q": list(q), "v": list(v), "t": t, "ok": bool(ok)})
            if not ok:
                raise AssertionError(f"polarization identity fail q={q} v={v} t={t}")
    return reports
