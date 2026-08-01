#!/usr/bin/env python3
"""Build and run all modular singular-locus charts for the normalized net."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
SPEC = importlib.util.spec_from_file_location(
    "goal_f_independent_infinity_verifier",
    PARENT / "verify_infinity_obstruction.py",
)
assert SPEC is not None and SPEC.loader is not None
verified = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(verified)

r, X, y, w = sp.symbols("r X y w")
l0, l1, l2 = sp.symbols("l0 l1 l2")
PLANE = (X, y, w)
LAMBDA = (l0, l1, l2)


def sing(expression: sp.Expr) -> str:
    return str(sp.expand(expression)).replace("**", "^")


def main() -> None:
    _, net = verified.modular_forms(89, 2)
    total = l0 * net[0] + l1 * net[1] + l2 * net[2]
    records = []
    for plane_chart in PLANE:
        for lambda_chart in LAMBDA:
            substitutions = {plane_chart: 1, lambda_chart: 1}
            variables = tuple(
                value
                for value in PLANE + LAMBDA
                if value not in (plane_chart, lambda_chart)
            )
            affine = sp.Poly(
                total.subs(substitutions), r, *variables, modulus=89
            ).as_expr()
            equations = [affine, *(sp.diff(affine, value) for value in variables)]
            stem = f"net_normality_{plane_chart}_{lambda_chart}_p89"
            script = HERE / f"{stem}.sing"
            output_path = HERE / f"{stem}.out"
            script.write_text(
                "\n".join(
                    [
                        f"ring R=(89,r),({','.join(map(str, variables))}),dp;",
                        "option(redSB);",
                        "ideal I=" + ",".join(sing(value) for value in equations) + ";",
                        "ideal G=std(I);",
                        'print("DIM="+string(dim(G)));',
                        "poly n=reduce(1,G);",
                        'if (n==0) { print("UNIT=1"); } else { print("UNIT=0"); }',
                        f'print("NET_NORMALITY_{plane_chart}_{lambda_chart}_P89_DONE");',
                        "quit;",
                        "",
                    ]
                )
            )
            output = subprocess.run(
                ["/opt/homebrew/bin/Singular", "-q", str(script)],
                cwd=HERE,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                check=True,
                timeout=180,
            ).stdout
            output_path.write_text(output)
            dimension = None
            for line in output.splitlines():
                if line.startswith("DIM="):
                    dimension = int(line.split("=", 1)[1])
            assert "UNIT=1" in output or (dimension is not None and dimension <= 0), output
            records.append(
                {
                    "plane_chart": str(plane_chart),
                    "lambda_chart": str(lambda_chart),
                    "dimension": dimension,
                    "unit": "UNIT=1" in output,
                    "script": script.name,
                    "output": output_path.name,
                }
            )
            print(f"{stem}: unit={records[-1]['unit']} dim={dimension}")
    (HERE / "NET_NORMALITY_CERTIFICATE.json").write_text(
        json.dumps(
            {
                "prime": 89,
                "zeta": 2,
                "scope": "good-reduction upper bound for the universal net singular locus",
                "charts": records,
            },
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )
    print("NET_UNIVERSAL_INCIDENCE_SINGULAR_LOCUS_FINITE_ACCEPT")


if __name__ == "__main__":
    main()
