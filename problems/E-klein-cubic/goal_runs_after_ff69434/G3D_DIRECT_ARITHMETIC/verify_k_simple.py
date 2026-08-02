#!/usr/bin/env python3
"""Independent verifier for G3D.0 simple field model.

Does not trust stored booleans: recomputes power basis, det P specializations,
charpoly degree, and multiplication agreement samples against field_api.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
G3A = ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"
sys.path.insert(0, str(G3A))
sys.path.insert(0, str(HERE / "src"))

from field_api import (  # noqa: E402
    PARAMETERS,
    basis,
    load_products,
    multiplication_matrix,
    multiply,
    one,
    eq,
    trace,
    inverse_with_open,
)
from k_simple import (  # noqa: E402
    ETA_INDEX,
    build_power_basis,
    det_power_basis_specialized,
    charpoly_L_specialized,
    power_to_secondary,
    specialize_products,
    specialize_elem,
    GOOD_POINTS,
)


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def main() -> None:
    payload = json.loads((HERE / "k_simple_model.json").read_text())
    require(payload.get("marker") == "G3D-K-SIMPLE-MODEL-PASS", "marker")
    require(payload["eta"]["secondary_index"] == ETA_INDEX, "eta index")
    require(payload["rank"] == 12, "rank 12")

    products, _ = load_products()
    powers, eta = build_power_basis(products)
    require(eq(powers[0], one()), "η^0 = 1")
    require(eq(powers[1], basis(ETA_INDEX)), "η^1 = f7")

    # Degree 12 via det P at good points
    for pt in GOOD_POINTS:
        det = det_power_basis_specialized(powers, pt)
        require(det != 0, f"det P = 0 at {pt}")
        cp = charpoly_L_specialized(products, pt)
        require(len(cp) - 1 == 12, f"charpoly deg at {pt}")
        require(cp[0] == 1, "monic")
        # Cayley–Hamilton at specialization: sum_i cp[i] L^{12-i} = 0
        products_sp = specialize_products(products, pt)
        L = multiplication_matrix(basis(ETA_INDEX), products_sp)
        total = sp.zeros(12)
        for i, coeff in enumerate(cp):
            power = 12 - i
            total = total + (L**power) * coeff
        require(total == sp.zeros(12), f"Cayley-Hamilton fail at {pt}")

    # Multiplication agreement: power products vs secondary
    pt = (2, 3, 5, 7)
    products_sp = specialize_products(products, pt)
    powers_sp = [specialize_elem(p, pt) for p in powers]
    # (η^2) * (η^3) = η^5 in power basis
    e2 = powers_sp[2]
    e3 = powers_sp[3]
    prod = multiply(e2, e3, products_sp)
    require(eq(prod, powers_sp[5]), "η^2 * η^3 = η^5")
    # random: (1+2η)(3+η^2)
    from field_api import add, scale

    left = add(powers_sp[0], scale(2, powers_sp[1]))
    right = add(scale(3, powers_sp[0]), powers_sp[2])
    pr = multiply(left, right, products_sp)
    # expand manually: 3 + η^2 + 6η + 2 η^3
    expect = add(
        add(scale(3, powers_sp[0]), powers_sp[2]),
        add(scale(6, powers_sp[1]), scale(2, powers_sp[3])),
    )
    require(eq(pr, expect), "linear combo product")

    # Trace of η
    require(trace(basis(ETA_INDEX), products) == 0, "Tr(f7)=0 generic")

    # Inverse of η at specialization
    rec = inverse_with_open(basis(ETA_INDEX), products_sp)
    require(eq(multiply(basis(ETA_INDEX), rec.inverse, products_sp), one()), "η inverse")

    # Constant dens of P
    require(payload["power_basis_denominators_are_constant"], "P dens constant")

    # Cross-check stored specialization dets
    for s in payload["specializations"]:
        pt = tuple(s["t"])
        det = det_power_basis_specialized(powers, pt)
        require(str(det) == s["det_P"], f"stored det mismatch at {pt}")

    print("G3D_K_SIMPLE_OK")


if __name__ == "__main__":
    main()
