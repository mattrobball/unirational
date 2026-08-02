#!/usr/bin/env python3
"""Specialized K_t = (rank-12 secondary model at fixed t) for Weil-Fano work.

K_t is the QQ-algebra obtained by specializing P0→QQ at a good t-point in the
G3A secondary basis. At t=(2,3,5,7), left mult by η=f7 has irreducible monic
charpoly of degree 12, so K_t is a field QQ(η).
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Sequence

import sympy as sp

ROOT = Path(__file__).resolve().parents[3]
G3A = ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"
sys.path.insert(0, str(G3A))

from field_api import (  # noqa: E402
    PARAMETERS,
    basis,
    load_products,
    multiplication_matrix,
    multiply,
    one,
    zero,
    eq,
    add,
    scale,
)

DEFAULT_T = (2, 3, 5, 7)
DIM = 12
ETA_INDEX = 1


def specialize_products(products, tvals=DEFAULT_T):
    subs = dict(zip(PARAMETERS, tvals))
    out = {}
    for key, val in products.items():
        out[key] = tuple(
            sp.Integer(sp.simplify(c.subs(subs))) for c in val
        )
    return out


def specialize_elem(elem, tvals=DEFAULT_T):
    subs = dict(zip(PARAMETERS, tvals))
    return tuple(sp.Integer(sp.simplify(c.subs(subs))) for c in elem)


def charpoly_eta(products_sp) -> list:
    L = multiplication_matrix(basis(ETA_INDEX), products_sp)
    cp = L.charpoly(sp.symbols("T"))
    return [sp.Integer(c) for c in cp.all_coeffs()]


def build_kt(tvals=DEFAULT_T) -> dict:
    products, _ = load_products()
    products_sp = specialize_products(products, tvals)
    cp = charpoly_eta(products_sp)
    T = sp.symbols("T")
    poly = sum(int(cp[i]) * T ** (12 - i) for i in range(13))
    factors = sp.factor_list(poly)
    irreducible = (
        len(factors[1]) == 1
        and sp.degree(factors[1][0][0], T) == 12
        and factors[1][0][1] == 1
    )
    # power basis of η
    powers = [one()]
    cur = one()
    for _ in range(11):
        cur = multiply(cur, basis(ETA_INDEX), products_sp)
        powers.append(cur)
    P = sp.Matrix.hstack(*[sp.Matrix(list(p)) for p in powers])
    det_P = P.det()
    return {
        "t": list(tvals),
        "eta": "f7",
        "eta_index": ETA_INDEX,
        "rank": DIM,
        "charpoly_coeffs_high_to_low": [str(int(c)) for c in cp],
        "minpoly_irreducible_over_QQ": irreducible,
        "is_field": irreducible,
        "det_power_basis": str(det_P),
        "det_power_basis_nonzero": det_P != 0,
        "products_sp": products_sp,
        "powers": powers,
        "P_matrix": P,
    }


def products_mod_p(products_sp, p: int) -> dict:
    out = {}
    for key, val in products_sp.items():
        out[key] = tuple(int(sp.Integer(c) % p) for c in val)
    return out


def mul_mod(u, v, products_p, p: int):
    acc = [0] * DIM
    for i, ui in enumerate(u):
        if ui == 0:
            continue
        for j, vj in enumerate(v):
            if vj == 0:
                continue
            sc = (ui * vj) % p
            key = tuple(sorted((i, j)))
            for k, pk in enumerate(products_p[key]):
                if pk:
                    acc[k] = (acc[k] + sc * pk) % p
    return tuple(acc)


def main():
    kt = build_kt()
    # drop non-json
    payload = {k: v for k, v in kt.items() if k not in ("products_sp", "powers", "P_matrix")}
    out = Path(__file__).resolve().parent / "k_t_field.json"
    out.write_text(json.dumps(payload, indent=2) + "\n")
    print("wrote", out)
    print("field", payload["is_field"], "detP nonzero", payload["det_power_basis_nonzero"])


if __name__ == "__main__":
    main()
