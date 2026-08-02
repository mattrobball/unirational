#!/usr/bin/env python3
"""Independent quadratic-invariant verifier for G3P (recomputes rank probes)."""

from __future__ import annotations

import itertools
import json
import random
import sys
from collections import Counter
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"))

from field_api import PARAMETERS, scale, zero, add  # noqa: E402
from phi_api import coefficient_map, load_generic_cubic  # noqa: E402

GENERIC = ROOT / "goals_2026-08-01" / "G_ALL_DEGREE" / "generic_cubic.json"
Q_POINT = (1, 0, 0, 0, 0)


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def entry_to_kproj(entries):
    comps = [sp.S.Zero] * 12
    for e in entries:
        mon = sp.Rational(e["numerator"], e["denominator"])
        for p, ex in zip(PARAMETERS, e["projective_exponents"]):
            mon *= p**ex
        comps[e["secondary"]] += mon
    return tuple(map(lambda z: sp.cancel(sp.together(z)), comps))


def beta_tensor(cmap):
    beta = [[[None] * 5 for _ in range(5)] for _ in range(5)]
    for i, j, k in itertools.product(range(5), repeat=3):
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
    return beta


def B(u, v, w, beta):
    acc = zero()
    for i, j, k in itertools.product(range(5), repeat=3):
        coeff = u[i] * v[j] * w[k]
        if coeff == 0:
            continue
        acc = add(acc, scale(coeff, beta[i][j][k]))
    return tuple(map(lambda z: sp.cancel(sp.together(z)), acc))


def specialize(elem, tvals, svals):
    td = dict(zip(PARAMETERS, tvals))
    total = sp.Integer(0)
    for i, c in enumerate(elem):
        total += sp.sympify(sp.simplify(c.subs(td))) * svals[i]
    return sp.together(total)


def main() -> None:
    qi = json.loads((HERE / "quadratic_invariants.json").read_text())
    require(qi["schema"] == "g3p-quadratic-invariants-v1", "schema")
    require(qi["Q_q_rank_generic"] == 5, "rank claim")
    require(qi["Q_q_smooth"] is True, "smooth claim")
    require(qi["H_q_cap_Q_q_rank_generic"] == 4, "restricted rank claim")
    require(qi["constructions_summary"]["K_proj_section_found"] is False, "no false section")

    payload = load_generic_cubic(GENERIC)
    beta = beta_tensor(coefficient_map(payload))
    M = [[B(Q_POINT, tuple(1 if r == i else 0 for r in range(5)),
            tuple(1 if r == j else 0 for r in range(5)), beta)
          for j in range(5)] for i in range(5)]
    L = [B(Q_POINT, Q_POINT, tuple(1 if r == i else 0 for r in range(5)), beta) for i in range(5)]

    random.seed(99)
    ranks = set()
    rest_ranks = set()
    for _ in range(10):
        tvals = [random.randint(1, 17) for _ in range(4)]
        svals = [1] + [random.randint(-12, 12) for _ in range(11)]
        Ms = sp.Matrix(5, 5, lambda i, j: specialize(M[i][j], tvals, svals))
        ranks.add(int(Ms.rank()))
        require(Ms.det() != 0, "det nonzero on probe")
        Lspec = [specialize(Li, tvals, svals) for Li in L]
        # find a coordinate with L_i != 0
        pivot = next(i for i in range(5) if Lspec[i] != 0)
        free = [i for i in range(5) if i != pivot]
        w = sp.symbols(f"w0:{4}")
        coeffs = []
        vv = [None] * 5
        # v_pivot = -sum L_free w / L_pivot
        expr_pivot = -sum(Lspec[free[j]] * w[j] for j in range(4)) / Lspec[pivot]
        vv[pivot] = expr_pivot
        for j, idx in enumerate(free):
            vv[idx] = w[j]
        Qe = sp.expand(sum(Ms[i, j] * vv[i] * vv[j] for i in range(5) for j in range(5)))
        Rm = sp.Matrix(4, 4, lambda a, b: sp.diff(sp.diff(Qe, w[a]), w[b]) / 2)
        rest_ranks.add(int(Rm.rank()))

    require(ranks == {5}, f"ranks {ranks}")
    require(rest_ranks == {4}, f"restricted ranks {rest_ranks}")

    # Reconcile with stored probe ranks
    stored_ranks = set(qi["probes"]["ranks_seen_under_specialization"])
    require(stored_ranks == {5}, "stored ranks")
    require(qi["probes"]["section_search"]["Q_q_section"] is False, "no Q section claim")

    # constructions ledger consistency
    cons = json.loads((HERE / "constructions.json").read_text())
    require(cons["K_proj_point_found"] is False, "constructions no point")
    require(cons["summary"]["K_proj_section_found"] is False, "summary no section")

    print("G3P_QUADRICS_VERIFY_OK")


if __name__ == "__main__":
    main()
