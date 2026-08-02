#!/usr/bin/env python3
"""Generate an exact Singular audit of the Schur--Palatini quartic mod 23.

The polynomial and the five-plane of alternating forms are reconstructed from
the source-bound representation code already used by the full-Schur packet.
This script only emits the good-fibre geometry input; it makes no automatic
characteristic-zero inference beyond what good reduction justifies.
"""

from __future__ import annotations

import importlib.util
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
CORE_PATH = (
    ROOT
    / "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/"
    "full_schur_palatinian_point_next/pencil_mod23.py"
)


def load_core():
    spec = importlib.util.spec_from_file_location("palatini_geometry_core", CORE_PATH)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def singular_polynomial(polynomial: dict[tuple[int, ...], int]) -> str:
    terms: list[str] = []
    for monomial, coefficient in sorted(polynomial.items()):
        factors = [str(coefficient)]
        for index, exponent in enumerate(monomial):
            if exponent == 1:
                factors.append(f"x{index}")
            elif exponent:
                factors.append(f"x{index}^{exponent}")
        terms.append("*".join(factors))
    return "+".join(terms) or "0"


def main() -> None:
    core = load_core()
    quartic, _ = core.reconstruct()
    assert len(quartic) == 126
    source = "\n".join(
        [
            "ring r=23,(x0,x1,x2,x3,x4,x5),dp;",
            f"poly I4={singular_polynomial(quartic)};",
            "ideal J=diff(I4,x0),diff(I4,x1),diff(I4,x2),diff(I4,x3),diff(I4,x4),diff(I4,x5);",
            'print("RAW_JACOBIAN_GENERATORS="+string(size(J)));',
            'print("RAW_JACOBIAN_FIRST_TERMS="+string(size(J[1])));',
            "ideal Graw=std(J);",
            'print("RAW_JACOBIAN_AFFINE_DIM="+string(dim(Graw)));',
            "ideal G=Graw;",
            'print("PALATINI_I4_TERMS="+string(size(I4)));',
            'print("SINGULAR_IDEAL_GENERATORS="+string(size(J)));',
            'print("SINGULAR_AFFINE_DIM="+string(dim(G)));',
            'print("SINGULAR_PROJECTIVE_DIM="+string(dim(G)-1));',
            'print("SINGULAR_PROJECTIVE_DEGREE_BEGIN");',
            "degree(G);",
            'print("SINGULAR_PROJECTIVE_DEGREE_END");',
            'print("SINGULAR_HILBERT_FIRST="+string(hilb(G,1)));',
            'print("SINGULAR_HILBERT_SECOND="+string(hilb(G,2)));',
            "list FL=factorize(I4);",
            'print("I4_FACTOR_COUNT_WITH_UNIT="+string(size(FL[1])));',
            "for (int i=1;i<=size(FL[1]);i++)",
            "{",
            '  print("I4_FACTOR="+string(i)+" MULT="+string(FL[2][i])+" DEG="+string(deg(FL[1][i])));',
            "}",
            "quit;",
        ]
    ) + "\n"
    output = HERE / "palatini_geometry_mod23.sing"
    output.write_text(source)
    smooth_source = "\n".join(
        [
            "ring r=23,(x0,x1,x2,x3,x4,x5),dp;",
            f"poly I4={singular_polynomial(quartic)};",
            "ideal J=diff(I4,x0),diff(I4,x1),diff(I4,x2),diff(I4,x3),diff(I4,x4),diff(I4,x5);",
            "ideal G=std(J);",
            "matrix H=jacob(J);",
            "ideal M4=minor(H,4,G);",
            "ideal K=std(J+M4);",
            'print("HESSIAN_SIZE="+string(nrows(H))+"x"+string(ncols(H)));',
            'print("FOUR_BY_FOUR_MINORS="+string(size(M4)));',
            'print("CURVE_SINGULAR_CONE_DIM="+string(dim(K)));',
            'print("CURVE_SINGULAR_CONE_VDIM="+string(vdim(K)));',
            "quit;",
        ]
    ) + "\n"
    smooth_output = HERE / "palatini_singular_curve_smooth_mod23.sing"
    smooth_output.write_text(smooth_source)
    print(f"WROTE={output}")
    print(f"WROTE={smooth_output}")
    print(f"I4_TERMS={len(quartic)}")


if __name__ == "__main__":
    main()
