#!/usr/bin/env python3
"""A5 source (icosahedral 3) and target (rational 5) modules for G3H."""

from __future__ import annotations

import importlib.util
from collections import deque
from fractions import Fraction
from pathlib import Path

from q5_arith import (
    ONE,
    ZERO,
    mid_q5,
    mmul_q5,
    mpow_q5,
    q5,
    qadd,
    qmul,
    qneg,
    qscale,
)

ROOT = Path(__file__).resolve().parents[3]
H_A5 = ROOT / "goal_runs_after_35fa" / "H_A5_TWISTS"


def _load_canonical():
    path = H_A5 / "canonical_a5_pencil.py"
    spec = importlib.util.spec_from_file_location("g3h_canonical_a5", path)
    assert spec and spec.loader
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


canonical = _load_canonical()
base = canonical.base
PERMS = base.PERMS


def exact_source_representation(sign_sqrt5: int = 1):
    """Faithful icosahedral 3-space over Q(sqrt(5)).

    sign_sqrt5 = +1 uses s with s^2=5; sign_sqrt5 = -1 uses the conjugate
    3' module (s |-> -s on structure constants of alpha).
    """
    # alpha = (-1 - s)/2 for sign +1; for -1 use (-1 + s)/2
    if sign_sqrt5 == 1:
        alpha = q5(Fraction(-1, 2), Fraction(-1, 2))
    elif sign_sqrt5 == -1:
        alpha = q5(Fraction(-1, 2), Fraction(1, 2))
    else:
        raise ValueError("sign_sqrt5 must be ±1")
    m5 = [
        [alpha, qneg(alpha), q5(-1)],
        [alpha, ONE, ZERO],
        [alpha, qneg(alpha), ZERO],
    ]
    m3 = [
        [ZERO, q5(-1), qneg(alpha)],
        [ZERO, ZERO, ONE],
        [q5(-1), qneg(alpha), ZERO],
    ]
    p5 = (1, 2, 3, 4, 0)
    p3 = (0, 1, 3, 4, 2)
    gens = (
        (p5, m5),
        (p3, m3),
        (canonical.p_inverse(p5), mpow_q5(m5, 4)),
        (canonical.p_inverse(p3), mpow_q5(m3, 2)),
    )
    mapping = {base.PID: mid_q5(3)}
    queue = deque([base.PID])
    while queue:
        perm = queue.popleft()
        mat = mapping[perm]
        for gen, gm in gens:
            cand = base.pc(perm, gen)
            cm = mmul_q5(mat, gm)
            if cand in mapping:
                assert mapping[cand] == cm
            else:
                mapping[cand] = cm
                queue.append(cand)
    assert len(mapping) == 60
    return mapping


def exact_target_matrix(g) -> list[list[int]]:
    """Integer matrix of the rational 5-dim augmentation module."""
    qperm = canonical.six_permutation(g)
    inverse = [0] * 6
    for src, img in enumerate(qperm):
        inverse[img] = src
    matrix = []
    for row in range(5):
        source = inverse[row]
        if source < 5:
            matrix.append([int(col == source) for col in range(5)])
        else:
            matrix.append([-1] * 5)
    return matrix


def all_target_matrices():
    return {g: exact_target_matrix(g) for g in PERMS}


def matvec_int(M, v):
    return [sum(M[i][j] * v[j] for j in range(len(v))) for i in range(len(M))]


def matvec_q5(M, v):
    out = []
    for i in range(len(M)):
        s = ZERO
        for j in range(len(v)):
            entry = M[i][j]
            if isinstance(entry, tuple):
                s = qadd(s, qmul(entry, v[j]))
            else:
                s = qadd(s, qscale(entry, v[j]))
        out.append(s)
    return out
