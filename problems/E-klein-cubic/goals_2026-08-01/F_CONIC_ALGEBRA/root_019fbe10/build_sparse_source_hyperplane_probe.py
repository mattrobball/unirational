#!/usr/bin/env python3
"""Build Jacobian charts for the sparse hyperplane x0+x1=0.

The exact stabilizer verifier certifies that this hyperplane has trivial
setwise stabilizer in PSL(2,11).  This producer uses the accepted invariant
forms and fixed-frame plane forms, reduces at the good prime 23, and writes
all twelve affine product charts plus msolve inputs.
"""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
sys.path.insert(0, str(PARENT))
SPEC = importlib.util.spec_from_file_location(
    "goal_f_source_probe_helpers", PARENT / "build_source_hyperplane_probe.py"
)
assert SPEC is not None and SPEC.loader is not None
helpers = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(helpers)

PRIME = 331
ZETA = 74
helpers.PRIME = PRIME
helpers.ZETA = ZETA
x0, x1, x2, x3, x4 = helpers.x0, helpers.x1, helpers.x2, helpers.x3, helpers.x4
X, y, w = helpers.X, helpers.y, helpers.w


def main() -> None:
    raw = helpers.load_kproj().forms()
    f3, f5, f6, f7, f9, f12 = (
        helpers.invariant(raw[degree]) for degree in (3, 5, 6, 7, 9, 12)
    )
    F0, FA, FB, FY, FZ = helpers.plane_forms()
    inv18 = pow(18, -1, PRIME)
    total = (
        f3**4 * F0
        + f6 * f3**2 * FA
        + f5 * f7 * FB
        + f9 * f3 * FY
        + (f12 - 11 * inv18 * f6**2) * FZ
    )
    source = (x0, x2, x3, x4)
    plane = (X, y, w)
    total = sp.Poly(
        total.subs(x1, -x0), *source, *plane, modulus=PRIME
    ).as_expr()
    total_terms = len(sp.Poly(total, *source, *plane, modulus=PRIME).terms())
    print(f"total_terms={total_terms}")

    manifest = []
    for plane_chart in plane:
        for source_chart in source:
            variables = tuple(
                variable
                for variable in (*source, *plane)
                if variable not in (plane_chart, source_chart)
            )
            chart = sp.Poly(
                total.subs({plane_chart: 1, source_chart: 1}),
                *variables,
                modulus=PRIME,
            ).as_expr()
            equations = (chart, *(sp.diff(chart, variable) for variable in variables))
            stem = f"sparse_H01_{plane_chart}_{source_chart}_p{PRIME}"
            sing_path = HERE / f"{stem}.sing"
            rows = [
                f"ring R={PRIME},({','.join(map(str, variables))}),dp;",
                "option(redSB);",
                f"poly F={helpers.singular(chart)};",
                "ideal J=F," + ",".join(f"diff(F,{variable})" for variable in variables) + ";",
                "ideal G=slimgb(J);",
                f'print("CHART={plane_chart}_{source_chart}");',
                'print("SING_NF1="+string(reduce(1,G)));',
                'print("SING_DIM="+string(dim(G)));',
                'print("SING_DEG="+string(deg(G)));',
                'print("SPARSE_SOURCE_HYPERPLANE_CHART_DONE");',
                "quit;",
            ]
            sing_path.write_text("\n".join(rows) + "\n")
            ms_path = HERE / f"{stem}.ms"
            ms_path.write_text(
                ",".join(map(str, variables))
                + f"\n{PRIME}\n"
                + ",\n".join(
                    helpers.msolve_polynomial(equation, variables)
                    for equation in equations
                )
                + "\n"
            )
            entry = {
                "plane_chart": str(plane_chart),
                "source_chart": str(source_chart),
                "singular_file": sing_path.name,
                "msolve_file": ms_path.name,
                "terms": len(sp.Poly(chart, *variables, modulus=PRIME).terms()),
            }
            manifest.append(entry)
            print(
                f"built={stem} terms={entry['terms']} "
                f"sing_bytes={sing_path.stat().st_size} ms_bytes={ms_path.stat().st_size}"
            )

    (HERE / "sparse_source_hyperplane_manifest.json").write_text(
        json.dumps(
            {
                "scope": "exact chosen divisor plus good-reduction smoothness certificate",
                "prime": PRIME,
                "zeta": ZETA,
                "hyperplane": "x0+x1=0",
                "total_terms": total_terms,
                "charts": manifest,
            },
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )
    print("SPARSE_SOURCE_HYPERPLANE_PROBES_BUILT")


if __name__ == "__main__":
    main()
