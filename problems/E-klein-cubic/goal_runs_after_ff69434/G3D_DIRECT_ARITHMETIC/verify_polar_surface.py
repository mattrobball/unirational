#!/usr/bin/env python3
"""Independent verifier for G3D.1A polar cubic surface."""

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
sys.path.insert(0, str(HERE / "src"))

from field_api import load_products, PARAMETERS, multiply, zero  # noqa: E402
from polar_core import load_betas, second_polar_linear_form, Q_POINT  # noqa: E402
from polar_surface import (  # noqa: E402
    eliminate_a0,
    phi_of_k_coords,
    verify_ell_q_vanishes,
    k_add,
    Y,
)


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def main() -> None:
    payload = json.loads((HERE / "polar_cubic_surface.json").read_text())
    require(payload["marker"] == "G3D-POLAR-CUBIC-SURFACE-PASS", "marker")
    require(payload["q"] == [1, 0, 0, 0, 0], "q")
    require(payload["ell_q_vanishes_after_elimination"], "stored ell flag — recheck below")

    products, _ = load_products()
    beta, _, _ = load_betas(products=products)
    Lcoeffs = second_polar_linear_form(beta, Q_POINT)
    # Independent L formula check: L0 = t3, L1 = t6/3, L2 = b7/3, L3 = t8/3, L4 = b9/3
    t3, t6, t8, t11 = PARAMETERS
    require(Lcoeffs[0][0] == t3, "L0")
    require(Lcoeffs[1][0] == t6 / 3, "L1")
    require(Lcoeffs[2][1] == sp.Rational(1, 3), "L2 b7")
    require(Lcoeffs[3][0] == t8 / 3, "L3")
    require(Lcoeffs[4][2] == sp.Rational(1, 3), "L4 b9")

    a = eliminate_a0(products, beta)
    ok, _ = verify_ell_q_vanishes(a, Lcoeffs, products)
    require(ok, "ell_q not zero after elimination")

    Phi = phi_of_k_coords(a, beta, products)
    # Compare nonzero component count
    nz = sum(1 for c in Phi if sp.expand(c) != 0)
    require(nz == payload["G_q"]["nonzero_secondary_components"], "component count")
    require(nz >= 1, "G_q not identically zero")

    # Each nonzero component is homogeneous of degree 3
    for i, c in enumerate(Phi):
        if sp.expand(c) == 0:
            continue
        num, den = sp.fraction(sp.together(c))
        poly = sp.Poly(sp.expand(num), *Y)
        require(poly.total_degree() == 3, f"comp {i} not degree 3")
        require(poly.is_homogeneous, f"comp {i} not homogeneous")
        # den should involve only t-parameters (typically powers of t3) and integers
        dens = sp.factor(den)
        allowed = set(PARAMETERS)
        require(set(dens.free_symbols) <= allowed, f"unexpected den vars {dens.free_symbols}")

    # Stored JSON components must match independent recompute of Phi
    for i, comp in enumerate(payload["G_q"]["components"]):
        c_live = Phi[i]
        if comp.get("zero"):
            require(sp.expand(c_live) == 0, f"stored zero but live nonzero comp {i}")
            continue
        stored = sp.cancel(sp.sympify(comp["num"]) / sp.sympify(comp["den"]))
        require(sp.simplify(stored - c_live) == 0, f"stored vs live G_q comp {i}")

    # Sample evaluation consistency + ell_q at points
    for yvals, tvals in [((1, 0, 0, 0), (2, 3, 5, 7)), ((1, 1, 1, 1), (2, 3, 5, 7))]:
        ys = dict(zip(Y, yvals))
        t_subs = dict(zip(PARAMETERS, tvals))
        a_at = [tuple(sp.cancel(c.subs(ys).subs(t_subs)) for c in ai) for ai in a]
        ell_acc = zero()
        for i in range(5):
            Li = tuple(sp.cancel(c.subs(t_subs)) for c in Lcoeffs[i])
            ell_acc = k_add(ell_acc, multiply(Li, a_at[i], products))
        require(all(sp.simplify(c) == 0 for c in ell_acc), f"ell at {yvals}")

    # Stored reembed checks
    require(payload["reembedding_all_match"], "stored reembed")
    for ch in payload["reembedding_checks"]:
        require(ch["match"], f"reembed match {ch['y']}")
        require(ch.get("ell_q_vanishes_at_point", True), f"ell stored at {ch['y']}")

    print("G3D_POLAR_SURFACE_OK")


if __name__ == "__main__":
    main()
