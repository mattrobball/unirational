#!/usr/bin/env python3
"""Independent polar-system verifier for G3P (does not import produce.py)."""

from __future__ import annotations

import hashlib
import itertools
import json
import sys
from collections import Counter
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"))

from field_api import PARAMETERS, add, eq, scale, zero  # noqa: E402
from phi_api import coefficient_map, load_generic_cubic  # noqa: E402

GENERIC = ROOT / "goals_2026-08-01" / "G_ALL_DEGREE" / "generic_cubic.json"
Q_POINT = (1, 0, 0, 0, 0)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


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


def parse_kproj_json(obj):
    comps = []
    for c in obj["components"]:
        comps.append(sp.sympify(c["str"]))
    return tuple(comps)


def main() -> None:
    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for row in man["inputs"]:
        if row["path"].endswith("generic_cubic.json"):
            require(sha256(GENERIC) == row["sha256"], "generic_cubic hash drift")
        fp = ROOT / row["path"]
        require(fp.is_file(), f"missing {row['path']}")
        require(sha256(fp) == row["sha256"], f"hash drift {row['path']}")

    polar = json.loads((HERE / "polar_system.json").read_text())
    require(polar["schema"] == "g3p-polar-system-v1", "schema")
    require(polar["marker"] == "G3P-POLAR-SYSTEM-PASS", "marker")
    require(polar["ambient_point_q"]["coordinates"] == [1, 0, 0, 0, 0], "q coords")
    require(polar["ambient_point_q"]["on_cubic"] is False, "q not on cubic")

    payload = load_generic_cubic(GENERIC)
    cmap = coefficient_map(payload)
    beta = beta_tensor(cmap)

    phi_q = B(Q_POINT, Q_POINT, Q_POINT, beta)
    # Phi(q) = t3 e0
    require(sp.simplify(phi_q[0] - PARAMETERS[0]) == 0, "Phi(q) secondary0 = t3")
    require(all(phi_q[i] == 0 for i in range(1, 12)), "Phi(q) only e0")
    stored = parse_kproj_json(polar["ambient_point_q"]["Phi_q"])
    require(eq(phi_q, stored), "Phi(q) matches polar_system.json")

    # H_q coefficients
    for i in range(5):
        ei = tuple(1 if r == i else 0 for r in range(5))
        Li = B(Q_POINT, Q_POINT, ei, beta)
        stored_L = parse_kproj_json(polar["H_q"]["coefficients_L_i"][i])
        require(eq(Li, stored_L), f"H coeff {i}")

    # Q_q matrix
    for i in range(5):
        for j in range(5):
            ei = tuple(1 if r == i else 0 for r in range(5))
            ej = tuple(1 if r == j else 0 for r in range(5))
            Mij = B(Q_POINT, ei, ej, beta)
            stored_M = parse_kproj_json(polar["Q_q"]["matrix_M_ij"][i][j])
            require(eq(Mij, stored_M), f"M[{i},{j}]")
            # symmetry
            require(eq(Mij, B(Q_POINT, ej, ei, beta)), f"sym {i}{j}")

    # Polarization identity: Phi(q+tv) expansion
    samples = [
        ((0, 1, 0, 0, 0), 1),
        ((1, 1, 1, 1, 1), -1),
        ((0, 1, -1, 2, 3), 2),
    ]
    for v, t in samples:
        direct = B(
            tuple(Q_POINT[i] + t * v[i] for i in range(5)),
            tuple(Q_POINT[i] + t * v[i] for i in range(5)),
            tuple(Q_POINT[i] + t * v[i] for i in range(5)),
            beta,
        )
        A = B(Q_POINT, Q_POINT, Q_POINT, beta)
        B1 = B(Q_POINT, Q_POINT, v, beta)
        C1 = B(Q_POINT, v, v, beta)
        D = B(v, v, v, beta)
        via = add(A, add(scale(3 * t, B1), add(scale(3 * t * t, C1), scale(t**3, D))))
        via = tuple(map(lambda z: sp.cancel(sp.together(z)), via))
        require(eq(direct, via), f"P_v identity v={v} t={t}")

    # identity checks recorded in JSON all ok
    for row in polar["polarization"]["identity_checks"]:
        require(row["ok"] is True, "recorded identity check")

    require(polar["H_q"]["contains_q"] is False, "q not on H")
    require(polar["Q_q"]["contains_q"] is False, "q not on Q")
    require("I_q" in polar and "D_q" in polar, "D and I present")

    print("G3P_POLARS_VERIFY_OK")


if __name__ == "__main__":
    main()
