#!/usr/bin/env python3
"""Exact global certificate for full residual-map rigidity in Hesse coordinates.

This script proves two ideal equalities, using exact arithmetic in SymPy and Macaulay2.

1. For arbitrary triples ``P = (P0,P1,P2)`` of bivariate quartics, the coefficient ideal of
   ``P0*Q2-P2*Q0`` and ``P1*Q2-P2*Q1`` is exactly the ideal saying ``P = rho*Q``, where ``rho`` is
   the constant coefficient of ``P2`` and ``Q`` is the normalized Hesse residual-map triple.
   Thus pointwise projective equality, once promoted to polynomial cross-product identities,
   gives one global scalar.  This equality holds already over ``QQ[lambda]``.

2. Let ``R_G`` be the universal residual-map quartic triple of a general ternary cubic ``G``.
   Adjoin ``u*(lambda^3-1)=1`` and impose ``R_G=rho*Q``.  After saturation at ``rho`` the resulting
   ideal is exactly

       b=c=e=h=i=j=0,  d=a,  k=a,  f=-3*lambda*a,
       rho=27*(lambda^3-1)*a^5.

   Hence, uniformly on ``lambda^3 != 1`` and ``rho != 0``, ``G`` is a scalar multiple of the fixed
   Hesse cubic.  Saturation and both ideal containments are checked symbolically; no tangent-space,
   rank-only, numerical, or radical inference is used.

Run from the repository root:

    python3 certificates/hesse_full_residual_map_certificate.py

Requirements: SymPy and Macaulay2 (``M2`` on ``PATH``).
"""

from __future__ import annotations

import shutil
import subprocess
import tempfile
from pathlib import Path

import sympy as sp

from residual_line_pencil_probe import affine_residual_map


def m2(expression: sp.Expr) -> str:
    """Render the small common subset of SymPy/Macaulay2 polynomial syntax."""

    return str(expression).replace("**", "^")


def ideal_definition(name: str, equations: list[sp.Expr]) -> str:
    return f"{name}=ideal(" + ",\n  ".join(m2(equation) for equation in equations) + ");"


def run_macaulay2(label: str, program: str) -> None:
    executable = shutil.which("M2")
    if executable is None:
        raise RuntimeError("Macaulay2 executable `M2` was not found on PATH")

    with tempfile.TemporaryDirectory(prefix="hesse_full_residual_map_") as directory:
        script = Path(directory) / f"{label}.m2"
        script.write_text(program, encoding="utf-8")
        result = subprocess.run(
            [executable, "--script", str(script)],
            check=False,
            capture_output=True,
            text=True,
            timeout=120,
        )
    if result.stdout:
        print(result.stdout, end="")
    if result.returncode != 0:
        if result.stderr:
            print(result.stderr, end="")
        raise RuntimeError(f"Macaulay2 {label} certificate failed with code {result.returncode}")


def hesse_quartics(lam: sp.Symbol, s: sp.Symbol, t: sp.Symbol) -> tuple[sp.Expr, ...]:
    return (
        s**4 - 2 * s * t**3 + 2 * s + 3 * lam * t**2,
        t**4 - 2 * s**3 * t + 2 * t + 3 * lam * s**2,
        1 + 2 * s**3 + 2 * t**3 + 3 * lam * s**2 * t**2,
    )


def scalar_rigidity_program() -> str:
    """Build the exact linear ideal comparison for arbitrary quartic triples."""

    s, t, lam = sp.symbols("s t lam")
    basis = tuple(
        (s_degree, total - s_degree)
        for total in range(5)
        for s_degree in range(total, -1, -1)
    )
    names = tuple(
        tuple(f"x{component}p{s_degree}q{t_degree}" for s_degree, t_degree in basis)
        for component in range(3)
    )
    symbols = tuple(tuple(sp.symbols(name) for name in row) for row in names)
    general = tuple(
        sum(
            coefficient * s**s_degree * t**t_degree
            for coefficient, (s_degree, t_degree) in zip(row, basis)
        )
        for row in symbols
    )
    target = hesse_quartics(lam, s, t)

    cross_products = (
        sp.Poly(sp.expand(general[0] * target[2] - general[2] * target[0]), s, t),
        sp.Poly(sp.expand(general[1] * target[2] - general[2] * target[1]), s, t),
    )
    cross_equations = [value for polynomial in cross_products for _, value in polynomial.terms()]
    assert len(cross_equations) == 88

    rho = symbols[2][basis.index((0, 0))]
    scalar_equations: list[sp.Expr] = []
    for row, target_component in zip(symbols, target):
        target_polynomial = sp.Poly(target_component, s, t)
        scalar_equations.extend(
            coefficient
            - rho * target_polynomial.coeff_monomial(s**s_degree * t**t_degree)
            for coefficient, (s_degree, t_degree) in zip(row, basis)
        )
    assert len(scalar_equations) == 45

    variables = [name for row in names for name in row] + ["lam"]
    return "\n".join(
        (
            "R=QQ[" + ",".join(variables) + ",MonomialOrder=>GRevLex];",
            ideal_definition("I", cross_equations),
            ideal_definition("L", scalar_equations),
            "assert(numgens source gens I == 88);",
            "assert(codim I == 44);",
            "assert(isSubset(I,L));",
            "assert(isSubset(L,I));",
            '<< "SCALAR_RIGIDITY_IDEALS_EQUAL: PASS" << endl;',
        )
    )


def cubic_recovery_program() -> str:
    """Build the uniform localized saturation comparison for general cubic coefficients."""

    coefficients, (s, t), residual = affine_residual_map()
    a, b, c, d, e, f, h, i, j, k = coefficients
    lam, rho, u = sp.symbols("lam rho u")
    target = hesse_quartics(lam, s, t)

    hesse_substitution = {
        a: 1,
        b: 0,
        c: 0,
        d: 1,
        e: 0,
        f: -3 * lam,
        h: 0,
        i: 0,
        j: 0,
        k: 1,
    }
    common = 27 * (lam**3 - 1)
    assert all(
        sp.expand(component.subs(hesse_substitution, simultaneous=True) - common * expected) == 0
        for component, expected in zip(residual, target)
    )

    coefficient_equations: list[sp.Expr] = []
    for component, expected in zip(residual, target):
        difference = sp.Poly(sp.expand(component - rho * expected), s, t)
        coefficient_equations.extend(value for _, value in difference.terms())
    assert len(coefficient_equations) == 45
    localized_equations = coefficient_equations + [u * (lam**3 - 1) - 1]

    triangular_equations = [
        b,
        c,
        e,
        h,
        i,
        j,
        a - d,
        a - k,
        f + 3 * lam * a,
        rho - 27 * (lam**3 - 1) * a**5,
        u * (lam**3 - 1) - 1,
    ]
    return "\n".join(
        (
            "R=QQ[u,rho,a,b,c,d,e,f,h,i,j,k,lam,MonomialOrder=>GRevLex];",
            ideal_definition("I", localized_equations),
            "J=saturate(I,ideal rho);",
            ideal_definition("L", triangular_equations),
            "assert(numgens source gens I == 46);",
            "assert(dim J == 2);",
            "assert(degree J == 20);",
            "assert(isSubset(J,L));",
            "assert(isSubset(L,J));",
            '<< "RECOVERY_SATURATION_EQUALS_TRIANGULAR_IDEAL: PASS" << endl;',
        )
    )


def main() -> None:
    run_macaulay2("scalar_rigidity", scalar_rigidity_program())
    run_macaulay2("cubic_recovery", cubic_recovery_program())
    print("full Hesse residual-map rigidity certificate: PASS")


if __name__ == "__main__":
    main()
