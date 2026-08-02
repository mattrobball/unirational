#!/usr/bin/env python3
"""Independent verifier for line_27_rur.json — recomputes chart ideals in Singular."""

from __future__ import annotations

import json
import subprocess
import sys
from functools import reduce
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
G3D = HERE.parent
ROOT = G3D.parents[1]
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"))

from field_api import PARAMETERS  # noqa: E402

Y = sp.symbols("y1 y2 y3 y4")
A, B, C, D, S, T = sp.symbols("a b c d s t")


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def primitive_G(tvals):
    polar = json.loads((G3D / "polar_cubic_surface.json").read_text())
    num0 = sp.sympify(polar["G_q"]["components"][0]["num"])
    g = sp.expand(num0.subs(dict(zip(PARAMETERS, tvals))))
    G = sp.Poly(g, *Y)
    coeffs = [int(cf) for _, cf in G.terms()]
    c0 = int(reduce(sp.gcd, coeffs))
    return sp.Poly(sp.expand(G.as_expr() / c0), *Y)


def chart_eqs(Gprim, piv):
    free = [k for k in range(4) if k not in piv]
    p0, p1 = piv
    f0, f1 = free
    u = [0, 0, 0, 0]
    v = [0, 0, 0, 0]
    u[p0] = 1
    u[f0] = A
    u[f1] = B
    v[p1] = 1
    v[f0] = C
    v[f1] = D
    pt = [S * u[i] + T * v[i] for i in range(4)]
    f = sp.expand(Gprim.as_expr().subs(dict(zip(Y, pt))))
    poly = sp.Poly(f, S, T)
    return [
        sp.expand(poly.coeff_monomial(m))
        for m in (S**3, S**2 * T, S * T**2, T**3)
    ]


def sing_vdim(eqs) -> tuple[int, int, int]:
    lines = ["option(redSB);", "ring r = 0, (a,b,c,d), dp;"]
    for i, e in enumerate(eqs):
        lines.append(f"poly f{i} = {str(e).replace('**', '^')};")
    lines += [
        "ideal I=f0,f1,f2,f3;",
        "ideal J=std(I);",
        'print(sprintf("%s %s %s", string(dim(J)), string(mult(J)), string(vdim(J))));',
    ]
    p = HERE / "_verify_tmp.sing"
    p.write_text("\n".join(lines) + "\n")
    out = subprocess.check_output(["singular", "-q", str(p)], text=True)
    parts = out.strip().split()
    return int(parts[0]), int(parts[1]), int(parts[2])


def main() -> None:
    payload = json.loads((HERE / "line_27_rur.json").read_text())
    require(payload["marker"] == "G3D-LINE-27-RUR-SPECIALIZED-PASS", "marker")
    require(payload["K_rational_line"] is None, "false K-line")
    require(payload["point_from_line"] is False, "false point")
    require(payload["rur_chart0"]["minpoly_d"]["degree"] == 27, "deg 27")
    require(payload["rur_chart0"]["minpoly_d"]["irreducible_over_QQ"], "irred")

    # Recompute chart 0 and chart 3 at base t
    t = tuple(payload["base_specialization"]["t"])
    Gprim = primitive_G(t)
    for idx in (0, 3, 5):
        piv = tuple(payload["charts"][str(idx)]["pivots"])
        eqs = chart_eqs(Gprim, piv)
        # stored eqs must match
        stored = payload["charts"][str(idx)]["equations"]
        for e_live, e_st in zip(eqs, stored):
            require(sp.expand(e_live - sp.sympify(e_st)) == 0, f"eq drift chart {idx}")
        dim, mult, vdim = sing_vdim(eqs)
        require(dim == 0 and mult == 27 and vdim == 27, f"chart {idx} degree {dim,mult,vdim}")

    # Multi-spec sample
    for tv in [(3, 5, 7, 11), (1, 1, 1, 1)]:
        Gp = primitive_G(tv)
        eqs = chart_eqs(Gp, (0, 1))
        dim, mult, vdim = sing_vdim(eqs)
        require(dim == 0 and vdim == 27, f"multi {tv}")

    # minpoly file exists and degree 27
    md = (HERE / "minpoly_d.txt").read_text().strip().rstrip(",")
    require("d27" in md or "d^27" in md, "minpoly d27 term")
    require((HERE / "rur_G4_a.txt").exists(), "rur a file")

    # modular claim honesty
    mod = payload["modular_verify"]
    require(mod.get("vdim") == 27 or mod.get("dim") == 0, "mod vdim")
    require(
        mod.get("chart_equations_vanish")
        or (mod.get("e0") == 0 and mod.get("e1") == 0),
        "mod chart eqs",
    )

    print("G3D_LINE27_RUR_OK")


if __name__ == "__main__":
    main()
