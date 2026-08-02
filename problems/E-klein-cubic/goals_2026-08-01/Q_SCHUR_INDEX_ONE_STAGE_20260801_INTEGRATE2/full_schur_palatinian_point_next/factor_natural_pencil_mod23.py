#!/usr/bin/env python3
"""Factor natural Reynolds pencils in the good Schur fibre.

This is a discovery/audit tool.  Irreducibility in the good fibre can rule
out a rational root in the corresponding exact characteristic-zero pencil
once the exact lift is source-bound; a factor in this output is not itself a
lifted point.
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
import subprocess
import tempfile

import pencil_mod23 as core


def x_polynomial(polynomial) -> str:
    terms = []
    for monomial, coefficient in polynomial.items():
        factors = []
        for index, exponent in enumerate(monomial):
            if exponent == 1:
                factors.append(f"x{index}")
            elif exponent:
                factors.append(f"x{index}^{exponent}")
        terms.append(f"{coefficient}*{'*'.join(factors) or '1'}")
    return "+".join(terms) or "0"


def singular_expand_and_factor(quartic, base, covariant, extension_degree: int) -> str:
    if extension_degree == 1:
        lines = ["ring r=23,(t,x0,x1,x2,x3,x4,x5),dp;"]
    else:
        minpolys = {
            2: "a^2+1",
            3: "a^3+3*a^2+1",
            4: "a^4+4*a^3+1",
        }
        lines = [
            "ring r=(23,a),(t,x0,x1,x2,x3,x4,x5),dp;",
            f"minpoly={minpolys[extension_degree]};",
        ]
    lines.append(f"poly I4={x_polynomial(quartic)};")
    for index, component in enumerate(covariant):
        lines.append(f"poly q{index}={x_polynomial(component)};")
    for index, component in enumerate(base):
        lines.append(f"poly b{index}={x_polynomial(component)};")
    lines.extend(
        [
            "map phi=r,t,b0+t*q0,b1+t*q1,b2+t*q2,b3+t*q3,b4+t*q4,b5+t*q5;",
            "poly f=phi(I4);",
            "list L=factorize(f);",
            "intvec wt=1,0,0,0,0,0,0;",
            'print("EXPANDED_TERMS="+string(size(f)));',
            f'print("CONSTANT_FIELD_DEGREE={extension_degree}");',
            'print("FACTOR_COUNT_WITH_UNIT="+string(size(L[1])));',
            'print("INPUT_TOTAL_DEG="+string(deg(f))+" INPUT_T_DEG="+string(deg(f,wt)));',
            "for (int i=1;i<=size(L[1]);i++)",
            "{",
            '  print("FACTOR="+string(i)+" MULT="+string(L[2][i])+" TOTAL_DEG="+string(deg(L[1][i]))+" T_DEG="+string(deg(L[1][i],wt)));',
            "}",
            "quit;",
        ]
    )
    source = "\n".join(lines) + "\n"
    print(f"SINGULAR_SOURCE_SHA256={hashlib.sha256(source.encode()).hexdigest()}")
    with tempfile.TemporaryDirectory(prefix="full_schur_natural_pencil_") as temporary:
        path = Path(temporary) / "factor.sing"
        path.write_text(source)
        process = subprocess.run(
            ["Singular", "-q", str(path)],
            cwd=temporary,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=False,
        )
    print(process.stdout, end="")
    print(f"SINGULAR_RETURN_CODE={process.returncode}")
    return process.stdout


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("degree", type=int)
    parser.add_argument("seed_output", type=int)
    parser.add_argument("--base-output", type=int)
    parser.add_argument("--base-degree", type=int)
    parser.add_argument("--factor", action="store_true")
    parser.add_argument("--extension-degree", type=int, choices=[1, 2, 3, 4], default=1)
    arguments = parser.parse_args()

    group, inverses = core.group_data()
    quartic = {}
    for element in group:
        quartic = core.add(
            quartic,
            core.linear_power_coefficients(element[5], 4),
        )
    covariant = core.reynolds_seed(
        group,
        inverses,
        arguments.degree,
        arguments.seed_output,
    )
    assert quartic and all(covariant)
    if arguments.base_output is None:
        base = [core.variable(index) for index in range(core.N)]
        base_label = "identity"
    else:
        base_degree = arguments.base_degree or arguments.degree
        base = core.reynolds_seed(
            group,
            inverses,
            base_degree,
            arguments.base_output,
        )
        assert all(base)
        base_label = f"output{arguments.base_output}_x5^{base_degree}"
    print(
        f"BASE={base_label} SEED=output{arguments.seed_output}_x5^{arguments.degree} "
        f"COVARIANT_TERMS={[len(component) for component in covariant]}"
    )
    if arguments.factor:
        singular_expand_and_factor(
            quartic,
            base,
            covariant,
            arguments.extension_degree,
        )


if __name__ == "__main__":
    main()
