#!/usr/bin/env python3
"""Test whether the singular-image meets the base hyperplane ``h=0``.

Let ``Sigma`` be the singular locus of the projective complete intersection
``T_g=(D_g,c)`` in ``P^4 x P^2``.  Its image in ``P^4`` is projective.  If
``Sigma`` has no point over the hyperplane ``h=0``, then that image is finite:
every positive-dimensional projective subvariety meets every hyperplane.

Crucially, the full six-variable Jacobian minors are formed *before* setting
``h=0``.  Thus the scripts test ``Sigma intersect {h=0}``, not singularity of
the hyperplane section itself.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import sympy as sp

from build_projective_residue_probe import (
    BASE,
    DEFAULT_PRIME,
    DEFAULT_ZETA,
    POINT,
    cubic,
    homogenize,
    primitive_affine,
    singular,
)


HERE = Path(__file__).resolve().parent
BASE_AT_INFINITY = tuple(item for item in BASE if str(item) != "h")


def emit(
    g: int,
    prime: int,
    zeta: int,
    selected_base: str | None = None,
    selected_point: str | None = None,
) -> dict:
    D, degree = homogenize(primitive_affine(g, prime), prime)
    c = cubic(prime, zeta)
    records = []
    for base_chart in BASE_AT_INFINITY:
        if selected_base is not None and str(base_chart) != selected_base:
            continue
        for point_chart in POINT:
            if selected_point is not None and str(point_chart) != selected_point:
                continue
            chart_substitutions = {base_chart: 1, point_chart: 1}
            full_variables = [
                item for item in (*BASE, *POINT) if item not in chart_substitutions
            ]
            Dchart = sp.Poly(
                D.as_expr().subs(chart_substitutions), *full_variables, modulus=prime
            ).as_expr()
            cchart = sp.Poly(
                c.as_expr().subs(chart_substitutions), *full_variables, modulus=prime
            ).as_expr()
            jacobian = [
                [sp.diff(Dchart, variable) for variable in full_variables],
                [sp.diff(cchart, variable) for variable in full_variables],
            ]
            full_generators = [Dchart, cchart]
            for left in range(len(full_variables)):
                for right in range(left + 1, len(full_variables)):
                    value = (
                        jacobian[0][left] * jacobian[1][right]
                        - jacobian[0][right] * jacobian[1][left]
                    )
                    if value != 0:
                        full_generators.append(value)

            h_variable = next(item for item in full_variables if str(item) == "h")
            variables = [item for item in full_variables if item != h_variable]
            generators = []
            for value in full_generators:
                reduced = sp.Poly(value.subs({h_variable: 0}), *variables, modulus=prime)
                if not reduced.is_zero:
                    generators.append(reduced.as_expr())

            label = f"{base_chart}_{point_chart}"
            singular_path = HERE / f"infinity_image_g{g}_p{prime}_{label}.sing"
            singular_rows = [
                f"ring R={prime},({','.join(map(str, variables))}),dp;",
                "option(redSB);",
                "short=0;",
                "ideal J=" + ",".join(singular(item) for item in generators) + ";",
                "ideal G=std(J);",
                f'print("INFINITY_IMAGE_CHART_{label}_NF1="+string(reduce(1,G)));',
                f'print("INFINITY_IMAGE_CHART_{label}_DIM="+string(dim(G)));',
                f'print("INFINITY_IMAGE_CHART_{label}_DONE");',
                "quit;",
            ]
            singular_path.write_text("\n".join(singular_rows) + "\n")

            msolve_path = HERE / f"infinity_image_g{g}_p{prime}_{label}.ms"
            msolve_rows = [",".join(map(str, variables)), str(prime)]
            for index, generator in enumerate(generators):
                suffix = "," if index + 1 < len(generators) else ""
                msolve_rows.append(singular(generator) + suffix)
            msolve_path.write_text("\n".join(msolve_rows) + "\n")
            records.append(
                {
                    "base_chart": str(base_chart),
                    "point_chart": str(point_chart),
                    "variables": list(map(str, variables)),
                    "equations": len(generators),
                    "singular_script": singular_path.name,
                    "msolve_input": msolve_path.name,
                }
            )
    payload = {
        "scope": "singular-image intersection with h=0 over a finite residue field",
        "logical_use": "empty intersection implies the characteristic-zero singular image is finite",
        "g": g,
        "prime": prime,
        "zeta11_residue": zeta,
        "D_degree": degree,
        "charts": records,
    }
    (HERE / f"infinity_image_g{g}_p{prime}.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    return payload


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--g", type=int, default=1)
    parser.add_argument("--prime", type=int, default=DEFAULT_PRIME)
    parser.add_argument("--zeta", type=int, default=DEFAULT_ZETA)
    parser.add_argument("--base-chart", choices=[str(item) for item in BASE_AT_INFINITY])
    parser.add_argument("--point-chart", choices=[str(item) for item in POINT])
    args = parser.parse_args()
    payload = emit(
        args.g,
        args.prime,
        args.zeta,
        selected_base=args.base_chart,
        selected_point=args.point_chart,
    )
    print(json.dumps(payload, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
