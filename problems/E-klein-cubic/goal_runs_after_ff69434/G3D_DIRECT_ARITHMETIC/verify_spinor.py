#!/usr/bin/env python3
"""Independent verifier for polar quadric / spinor discriminant structural data."""

from __future__ import annotations

import json
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
G3A = ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"
G3P = ROOT / "goal_runs_after_0aecc89" / "G3P_POLAR_ODD_DEGREE_DESCENT" / "src"
sys.path.insert(0, str(G3A))
sys.path.insert(0, str(G3P))

from field_api import load_products  # noqa: E402
from polar_core import (  # noqa: E402
    load_betas,
    first_polar_matrix,
    Q_POINT,
    matrix_specialized,
)


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def binary_cubic_disc(a, b, c, d):
    return (
        162 * a * b * c * d
        - 108 * b**3 * d
        + 81 * b**2 * c**2
        - 108 * a * c**3
        - 27 * a**2 * d**2
    )


def main() -> None:
    w = json.loads((HERE / "polar_quadric_witt.json").read_text())
    spn = json.loads((HERE / "spinor_discriminant.json").read_text())
    require(w["q"] == [1, 0, 0, 0, 0], "q")
    require(len(w["matrix_M_q"]) == 5, "5x5")

    products, _ = load_products()
    beta, _, _ = load_betas(products=products)
    Mq = first_polar_matrix(beta, Q_POINT)

    # Symmetry of Mq
    for i in range(5):
        for j in range(i + 1, 5):
            for k in range(12):
                require(
                    sp.simplify(Mq[i][j][k] - Mq[j][i][k]) == 0,
                    f"Mq sym {i}{j}",
                )

    # Specialized rank 5 at good points
    for tvals in [(2, 3, 5, 7), (3, 5, 7, 11)]:
        Ms = matrix_specialized(Mq, tvals, (1,) + (0,) * 11)
        require(Ms.rank() == 5, f"rank at {tvals}")
        require(sp.simplify(Ms.det()) != 0, f"det at {tvals}")

    # Cross-check stored specializations
    for r in w["specializations"]:
        Ms = matrix_specialized(Mq, tuple(r["t"]), (1,) + (0,) * 11)
        require(int(Ms.rank()) == r["rank"], "stored rank")
        require(str(sp.simplify(Ms.det())) == r["det"] or sp.simplify(Ms.det() - sp.sympify(r["det"])) == 0, "stored det")

    # Discriminant formula self-check on a known binary cubic
    # (s-t)^2 (s+2t) = (s^2 - 2st + t^2)(s+2t) = s^3 + ... 
    s, t = sp.symbols("s t")
    f = sp.expand((s - t) ** 2 * (s + 2 * t))
    poly = sp.Poly(f, s, t)
    A = poly.coeff_monomial(s**3)
    B = poly.coeff_monomial(s**2 * t) / 3
    C = poly.coeff_monomial(s * t**2) / 3
    D = poly.coeff_monomial(t**3)
    disc = binary_cubic_disc(A, B, C, D)
    require(disc == 0, "repeated root => Delta=0")

    require(spn.get("point_produced") is False or spn.get("headline_point") is None, "no false point")
    require(spn["marker"] in {"G3D-SPINOR-DISCRIMINANT-PASS", "G3D-SPINOR-DISCRIMINANT-PARTIAL"}, "spinor marker")

    print("G3D_SPINOR_OK")


if __name__ == "__main__":
    main()
