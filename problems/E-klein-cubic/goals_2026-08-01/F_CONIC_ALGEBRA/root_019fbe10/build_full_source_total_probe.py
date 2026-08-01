#!/usr/bin/env python3
"""Build all Jacobian charts for the full source incidence in P2 x P4."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
sys.path.insert(0, str(PARENT))
SPEC = importlib.util.spec_from_file_location(
    "goal_f_source_helpers", PARENT / "build_source_hyperplane_probe.py"
)
assert SPEC is not None and SPEC.loader is not None
h = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(h)

PRIME = 23
h.PRIME = PRIME
h.ZETA = 2
x0, x1, x2, x3, x4 = h.x0, h.x1, h.x2, h.x3, h.x4
X, y, w = h.X, h.y, h.w
SOURCE = (x0, x1, x2, x3, x4)
PLANE = (X, y, w)


def main() -> None:
    raw = h.load_kproj().forms()
    f3, f5, f6, f7, f9, f12 = (
        h.invariant(raw[degree]) for degree in (3, 5, 6, 7, 9, 12)
    )
    F0, FA, FB, FY, FZ = h.plane_forms()
    inv18 = pow(18, -1, PRIME)
    total = sp.Poly(
        f3**4 * F0
        + f6 * f3**2 * FA
        + f5 * f7 * FB
        + f9 * f3 * FY
        + (f12 - 11 * inv18 * f6**2) * FZ,
        *(SOURCE + PLANE),
        modulus=PRIME,
    ).as_expr()
    print(f"total_terms={len(sp.Poly(total, *(SOURCE + PLANE), modulus=PRIME).terms())}")
    manifest = []
    for source_chart in SOURCE:
        for plane_chart in PLANE:
            variables = tuple(
                variable
                for variable in SOURCE + PLANE
                if variable not in (source_chart, plane_chart)
            )
            affine = sp.Poly(
                total.subs({source_chart: 1, plane_chart: 1}),
                *variables,
                modulus=PRIME,
            ).as_expr()
            equations = [affine, *(sp.diff(affine, variable) for variable in variables)]
            stem = f"full_source_total_{source_chart}_{plane_chart}_p{PRIME}"
            sing_path = HERE / f"{stem}.sing"
            sing_path.write_text(
                "\n".join(
                    [
                        f"ring R={PRIME},({','.join(map(str, variables))}),dp;",
                        "option(redSB);",
                        f"poly F={h.singular(affine)};",
                        "ideal I=F," + ",".join(f"diff(F,{variable})" for variable in variables) + ";",
                        "ideal G=slimgb(I);",
                        'print("DIM="+string(dim(G)));',
                        "poly n=reduce(1,G);",
                        'if (n==0) { print("UNIT=1"); } else { print("UNIT=0"); }',
                        f'print("FULL_SOURCE_TOTAL_{source_chart}_{plane_chart}_DONE");',
                        "quit;",
                        "",
                    ]
                )
            )
            ms_path = HERE / f"{stem}.ms"
            ms_path.write_text(
                ",".join(map(str, variables))
                + f"\n{PRIME}\n"
                + ",\n".join(h.msolve_polynomial(eq, variables) for eq in equations)
                + "\n"
            )
            entry = {
                "source_chart": str(source_chart),
                "plane_chart": str(plane_chart),
                "singular_file": sing_path.name,
                "msolve_file": ms_path.name,
                "terms": len(sp.Poly(affine, *variables, modulus=PRIME).terms()),
            }
            manifest.append(entry)
            print(f"built={stem} terms={entry['terms']} ms_bytes={ms_path.stat().st_size}")
    (HERE / "FULL_SOURCE_TOTAL_MANIFEST.json").write_text(
        json.dumps(
            {"prime": PRIME, "zeta": 2, "charts": manifest},
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )
    print("FULL_SOURCE_TOTAL_PROBES_BUILT")


if __name__ == "__main__":
    main()
