#!/usr/bin/env python3
"""Degree-11 landing covariant Ψ and composition P = Ψ ∘ Y."""

from __future__ import annotations

import json
from fractions import Fraction
from itertools import product
from pathlib import Path
from typing import Sequence

from cubic_compression import EXPS, eval_Y, mon_val
from q5_arith import (
    ONE,
    ZERO,
    q5_from_json,
    q5_to_json,
    qadd,
    qiszero,
    qmul,
    qscale,
    qsub,
)

ROOT = Path(__file__).resolve().parents[3]
H_A5 = ROOT / "goal_runs_after_35fa" / "H_A5_TWISTS"
RAW_COV = H_A5 / "common" / "degree11_covariants_raw_exact.json"


def load_raw_covariants():
    return json.loads(RAW_COV.read_text())


def load_point(class_index: int):
    return json.loads(
        (H_A5 / f"A5_class_{class_index}" / "point.json").read_text()
    )


def parse_sparse_poly(poly_dict: dict) -> dict[tuple[int, int, int], tuple]:
    """Map exponent triple (e0,e1,e2) -> Q5 coeff."""
    out = {}
    for key, val in poly_dict.items():
        e0, e1, e2 = (int(x) for x in key.split(","))
        out[(e0, e1, e2)] = q5_from_json(val)
    return out


def load_C_basis():
    """Five raw degree-11 covariants: C[j][output] = sparse poly in 3 vars."""
    raw = load_raw_covariants()
    basis = []
    for cov in raw["covariants"]:
        # cov is list of 5 sparse polys (one per target coordinate)
        basis.append([parse_sparse_poly(p) for p in cov])
    return basis, raw


def closed_relations_to_q5(point: dict):
    """Interpret closed_point_relations over Q(s,g) reduced to Q5? 

    The sealed point uses alpha over Q(s,g) with g^2=-11. Coefficients of a_i
    are listed as length-4 vectors on basis 1,u,u^2,u^3 of Q(u), u=s+g.

    For evaluation over Q5 alone we keep the parameter vector formal and use
    the triangular chart a0=1, a4=alpha, a_i = -q_i(alpha) from the rref files,
    or evaluate the linear combination with symbolic alpha in the U4 ring.
    """
    rel = point["closed_point_relations"]
    # Each a*_k is 4-vector for basis of Q(u). We return as U4 fractions.
    def u4(key):
        vec = rel[key]
        return tuple(Fraction(int(v.split("/")[0]) if isinstance(v, str) else v[0] if isinstance(v, list) else v,
                              int(v.split("/")[1]) if isinstance(v, str) and "/" in v else (v[1] if isinstance(v, list) else 1))
                     if not isinstance(v, list) else Fraction(v[0], v[1])
                     for v in vec)

    # relations store lists of [num,den] pairs actually as strings in some files
    def parse_vec(vec):
        out = []
        for item in vec:
            if isinstance(item, str):
                if "/" in item:
                    n, d = item.split("/")
                    out.append(Fraction(int(n), int(d)))
                else:
                    out.append(Fraction(item))
            elif isinstance(item, list):
                out.append(Fraction(item[0], item[1]))
            else:
                out.append(Fraction(item))
        return tuple(out)

    return {k: parse_vec(v) for k, v in rel.items()}


def u4_mul(a, b):
    """Multiply in Q[u]/(u^4+12u^2+256)."""
    raw = [Fraction(0)] * 7
    for i in range(4):
        for j in range(4):
            raw[i + j] += a[i] * b[j]
    # reduce u^4 = -12 u^2 - 256; u^5 = -12 u^3 - 256 u; u^6 = -12 u^4 - 256 u^2
    for deg in range(6, 3, -1):
        if raw[deg]:
            c = raw[deg]
            raw[deg] = Fraction(0)
            raw[deg - 4] += c * (-256) if deg - 4 >= 0 else 0
            # u^deg = u^{deg-4} * u^4 = u^{deg-4}*(-12 u^2 - 256)
            # careful rewrite:
    # redo reduction properly
    # Bring degrees >=4 down
    coeffs = list(raw[:4]) + [raw[4], raw[5], raw[6]]
    # actually recompute:
    acc = [Fraction(0)] * 4
    for i in range(4):
        for j in range(4):
            e = i + j
            c = a[i] * b[j]
            # reduce e
            # u^4 = -12 u^2 - 256
            # u^5 = -12 u^3 - 256 u
            # u^6 = -12 u^4 - 256 u^2 = -12(-12u^2-256) - 256 u^2 = 144 u^2 + 3072 - 256 u^2
            if e < 4:
                acc[e] += c
            elif e == 4:
                acc[0] += c * (-256)
                acc[2] += c * (-12)
            elif e == 5:
                acc[1] += c * (-256)
                acc[3] += c * (-12)
            elif e == 6:
                # u^6 = (u^2)(u^4) = u^2(-12 u^2 - 256) = -12 u^4 - 256 u^2
                # = -12(-12 u^2 - 256) - 256 u^2 = 144 u^2 + 3072 - 256 u^2 = 3072 - 112 u^2
                acc[0] += c * 3072
                acc[2] += c * (-112)
            else:
                raise RuntimeError(e)
    return tuple(acc)


def u4_from_int(n):
    return (Fraction(n), Fraction(0), Fraction(0), Fraction(0))


def u4_add(a, b):
    return tuple(a[i] + b[i] for i in range(4))


def u4_scale(s, a):
    return tuple(s * a[i] for i in range(4))


def u4_iszero(a):
    return all(x == 0 for x in a)


# --- Simpler path: evaluate Psi using the triangular chart over Q5(alpha) ---
# From POINT.md: (a0,...,a4) = (1, -q1(theta), -q2(theta), -q3(theta), theta)
# with theta root of J[1]. The sealed point.json gives alpha and a_i in Q(u)[alpha].
# For modular and structural checks we evaluate the linear combination
# Phi = C0 + a1 C1 + a2 C2 + a3 C3 + a4 C4 with a_i from closed_point_relations
# specialized at a concrete embedding Q(u) -> C or F_p.


def eval_sparse_poly(poly: dict, y: Sequence):
    """Evaluate sparse degree-11 poly at y in U^3; coeffs Q5; y coords Q5."""
    acc = ZERO
    for (e0, e1, e2), c in poly.items():
        if qiszero(c):
            continue
        term = c
        for _ in range(e0):
            term = qmul(term, y[0])
        for _ in range(e1):
            term = qmul(term, y[1])
        for _ in range(e2):
            term = qmul(term, y[2])
        acc = qadd(acc, term)
    return acc


def eval_covariant_vector(cov_5, y):
    return [eval_sparse_poly(cov_5[i], y) for i in range(5)]


def scale_cov(cov_5, scalar_q5):
    out = []
    for poly in cov_5:
        out.append({e: qmul(scalar_q5, c) for e, c in poly.items()})
    return out


def add_cov(A, B):
    out = []
    for i in range(5):
        d = dict(A[i])
        for e, c in B[i].items():
            d[e] = qadd(d.get(e, ZERO), c)
            if qiszero(d[e]):
                del d[e]
        out.append(d)
    return out


def build_Phi_basis_combination(basis, a_params_q5):
    """Phi = sum a_j C_j with a_j in Q5 (specialized)."""
    acc = [dict() for _ in range(5)]
    for j, aj in enumerate(a_params_q5):
        if qiszero(aj):
            continue
        scaled = scale_cov(basis[j], aj)
        acc = add_cov(acc, scaled)
    return acc


def F_klein(v):
    """Klein cubic F = sum_i v_i^2 v_{i+1} with coords in Q5."""
    acc = ZERO
    for i in range(5):
        acc = qadd(acc, qmul(qmul(v[i], v[i]), v[(i + 1) % 5]))
    return acc


def specialize_u4_to_q5_via_sqrt5_only(u4_vec, s_sign=1):
    """Project Q(u) vector discarding g = sqrt(-11) parts — only for smoke tests.

    Full evaluation needs Q(s,g). For exact landing we use the independent
    H_A5 verifier path and modular specializations that include g.
    """
    # u = s + g; without g this is meaningless for exactness.
    # Return rational+sqrt5 parts treating u ~ s (invalid for proof; modular only).
    # Kept as placeholder; modular path uses F_p embeddings.
    raise NotImplementedError("use modular embedding or full Q(s,g) ring")


def compose_P_at_point(Phi_cov, Y, w):
    """P(w) = Phi(Y(w)) as length-5 vector over Q5."""
    y = eval_Y(Y, w)
    return eval_covariant_vector(Phi_cov, y)


def klein_F_int(v):
    return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5))
