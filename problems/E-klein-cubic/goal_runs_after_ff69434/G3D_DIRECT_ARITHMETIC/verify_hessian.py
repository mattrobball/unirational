#!/usr/bin/env python3
"""Independent verifier for Hessian matrix / cube-cover structural claims."""

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

from field_api import load_products, add, scale  # noqa: E402
from polar_core import load_betas, B_form, phi_of_vector, specialize_kproj  # noqa: E402


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def main() -> None:
    h = json.loads((HERE / "hessian_matrix.json").read_text())
    st = json.loads((HERE / "hessian_rank_strata.json").read_text())
    cu = json.loads((HERE / "hessian_cube_cover.json").read_text())
    require(h["marker"] == "G3D-HESSIAN-KERNEL-PASS", "hessian marker")
    require(h["symmetric"], "stored symmetry — recheck")
    require(cu["marker"] == "G3D-HESSIAN-CUBE-REDUCTION-PASS", "cube marker")
    require(cu.get("point_produced") is False, "no false point claim")

    products, _ = load_products()
    beta, _, _ = load_betas(products=products)

    # Symmetry B(z,ei,ej)=B(z,ej,ei)
    for i in range(5):
        for j in range(i + 1, 5):
            for r in range(5):
                d = add(beta[r][i][j], scale(-1, beta[r][j][i]))
                require(all(sp.simplify(c) == 0 for c in d), f"sym beta r={r} {i}{j}")

    # Mixed-term identity: Phi(sz+tv) - s^3 Phi(z) - t^3 Phi(v)
    # = 3 s^2 t B(z,z,v) + 3 s t^2 B(z,v,v)
    tvals = (2, 3, 5, 7)
    svals = (1,) + (0,) * 11
    z = (1, 1, 0, 0, 0)
    v = (0, 0, 1, 1, 0)
    s, t = 2, 3
    w = tuple(s * z[i] + t * v[i] for i in range(5))

    def phi_n(vec):
        return specialize_kproj(phi_of_vector(vec, beta), tvals, svals)

    def B_n(u, vv, ww):
        return specialize_kproj(B_form(u, vv, ww, beta), tvals, svals)

    left = phi_n(w)
    right = s**3 * phi_n(z) + t**3 * phi_n(v) + 3 * s**2 * t * B_n(z, z, v) + 3 * s * t**2 * B_n(z, v, v)
    require(sp.simplify(left - right) == 0, "polarization identity")

    # Rank strata: histogram keys present
    require("specializations" in st and len(st["specializations"]) >= 1, "strata")
    hist = st["specializations"][0]["rank_histogram"]
    total = sum(int(v) for v in hist.values())
    require(total == st["specializations"][0]["n_samples"], "hist sum")

    print("G3D_HESSIAN_OK")


if __name__ == "__main__":
    main()
