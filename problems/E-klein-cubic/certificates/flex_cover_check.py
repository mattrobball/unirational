#!/usr/bin/env python3
"""Exact finite-field certificate for the ten generic flex covers.

For each coordinate-frame plane, restrict the source to the fixed affine
line in ``flex_line_scan.source_line(0, s)``, reduce modulo 23, form the
Hessian flex intersection, and eliminate one plane coordinate.  The degree-9
eliminant is factored over GF(23^3) with Macaulay2.

The accompanying REPORT explains why irreducibility over GF(23^3), together
with degree 9 and coefficients in GF(23), proves absolute irreducibility and
why this rules out a rational flex without ruling out an ordinary point.
"""

from __future__ import annotations

import os
from pathlib import Path
import re
import subprocess
import tempfile

import sympy as sp

from flex_line_scan import P, flex_eliminant, write_m2_factor_file


ROOT = Path(__file__).resolve().parents[1]


def projectively_smooth_at(f, variables, s_value: int) -> bool:
    s, a, b, c = variables
    fs = sp.Poly(f.subs(s, s_value), a, b, c, modulus=P).as_expr()
    derivatives = [sp.diff(fs, variable) for variable in (a, b, c)]
    for variable in (a, b, c):
        others = tuple(v for v in (a, b, c) if v != variable)
        equations = [q.subs(variable, 1) for q in (fs, *derivatives)]
        basis = sp.groebner(equations, *others, modulus=P)
        if not basis.contains(sp.Integer(1)):
            return False
    return True


def m2_factor_summary(script: Path, m2home: Path) -> str:
    m2home.mkdir(parents=True, exist_ok=True)
    environment = dict(os.environ)
    environment["HOME"] = str(m2home)
    run = subprocess.run(
        ["M2", "--no-readline", "--silent", str(script)],
        cwd=ROOT,
        env=environment,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
    )
    assert re.search(r"nonconstant_factors, 1,", run.stdout), run.stdout
    assert re.search(r"exponents, \{1\}", run.stdout), run.stdout
    return " ".join(line.strip() for line in run.stdout.splitlines() if line.strip())


def main():
    rows = []
    with tempfile.TemporaryDirectory(prefix="klein-flex-") as temp:
        temporary = Path(temp)
        m2home = temporary / "home"
        for index in range(10):
            variables, triple, f, h, eliminant, infinity = flex_eliminant(0, index)
            s, a, b, c = variables
            assert eliminant.degree(a) == 9
            assert not infinity.is_zero
            assert not sp.Poly(f.subs({a: 1, b: 0, c: 0}), s, modulus=P).is_zero
            assert not sp.Poly(f.subs({a: 0, b: 1, c: 0}), s, modulus=P).is_zero
            assert not sp.Poly(h.subs({a: 0, b: 1, c: 0}), s, modulus=P).is_zero

            smooth_value = next(
                value for value in (0, 1) if projectively_smooth_at(f, variables, value)
            )
            script = temporary / f"factor_{index}.m2"
            write_m2_factor_file(script, eliminant)
            summary = m2_factor_summary(script, m2home)
            assert "nonconstant_factors, 1" in summary
            rows.append(
                (
                    "".join(triple),
                    eliminant.degree(s),
                    len(eliminant.terms()),
                    infinity.degree(),
                    smooth_value,
                )
            )
            print(
                "case", "".join(triple),
                "degree_a", eliminant.degree(a),
                "degree_s", eliminant.degree(s),
                "terms", len(eliminant.terms()),
                "infinity_degree", infinity.degree(),
                "smooth_at_s", smooth_value,
                "GF(23^3)_factors", 1,
                "factor_exponent", 1,
                flush=True,
            )

    assert len(rows) == 10
    print("PASS ten degree-9 flex eliminants remain irreducible over GF(23^3)")


if __name__ == "__main__":
    main()
