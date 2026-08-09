#!/usr/bin/env python3
"""Generate the exact covariant-slice equations for a finite-field fibre.

This imports the audited Hermite construction from OSCULATING_GENERAL_H,
sets A_k=r_k and f_k=1, and emits an msolve input.  The roots are supplied
as four nonzero pairwise-distinct residues; r_4 is forced by product r_i=1.
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
GENERAL_H = HERE.parent / "OSCULATING_GENERAL_H"
sys.path.insert(0, str(GENERAL_H))

from probe_normalized_slice import (  # noqa: E402
    build_system,
    polynomial_mod_prime,
    term_to_string,
    write_msolve,
)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("output", type=Path)
    parser.add_argument("--prime", type=int, required=True)
    parser.add_argument("--roots", required=True,
                        help="four comma-separated residues r0,r1,r2,r3")
    parser.add_argument("--gfan-output", type=Path,
                        help="also write the ten Newton supports for gfan")
    parser.add_argument("--singular-output", type=Path,
                        help="also write a Singular dimension/degree job")
    parser.add_argument("--julia-output", type=Path,
                        help="also write a HomotopyContinuation.jl solve job")
    parser.add_argument("--saturate-leading", action="store_true",
                        help="invert the product of the five H_i leading terms")
    parser.add_argument("--separate-inverses", action="store_true",
                        help="use five sparse inverse equations instead of one product")
    args = parser.parse_args()

    first_four = tuple(map(int, args.roots.split(",")))
    if len(first_four) != 4:
        parser.error("--roots must contain exactly four residues")
    prime = args.prime
    if any(value % prime == 0 for value in first_four):
        parser.error("roots must be nonzero modulo the prime")
    r4 = pow(__import__("math").prod(first_four) % prime, -1, prime)
    roots_mod = tuple(value % prime for value in first_four) + (r4,)
    if len(set(roots_mod)) != 5:
        parser.error(f"roots are not distinct modulo {prime}: {roots_mod}")

    # Integral representatives are legitimate because write_msolve reduces
    # all rational coefficients modulo prime.  Product one is required over
    # QQ by build_system, so use r4=1/product there rather than its residue.
    import sympy as sp
    roots_q = tuple(map(sp.Rational, first_four)) + (
        sp.Rational(1, __import__("math").prod(first_four)),
    )
    variables, equations, _roots, H, *_ = build_system(
        roots_q, A_values=roots_q, f_values=(1,) * 5
    )
    if args.saturate_leading:
        T = sp.Symbol("T")
        leading_terms = [
            sp.Poly(polynomial, T).coeff_monomial(T**4) for polynomial in H
        ]
        inverse_variables = (
            sp.symbols("z0:5") if args.separate_inverses else (sp.Symbol("z"),)
        )
        variables = variables + tuple(inverse_variables)
        equations = [
            sp.Poly(polynomial.as_expr(), *variables, domain=sp.QQ)
            for polynomial in equations
        ]
        if args.separate_inverses:
            equations.extend(
                sp.Poly(z * leading - 1, *variables, domain=sp.QQ)
                for z, leading in zip(inverse_variables, leading_terms)
            )
        else:
            equations.append(sp.Poly(
                inverse_variables[0] * sp.prod(leading_terms) - 1,
                *variables,
                domain=sp.QQ,
            ))
    write_msolve(args.output, variables, equations, prime)
    if args.gfan_output:
        names = [str(variable) for variable in variables]
        rendered = []
        for polynomial in equations:
            terms = []
            for monomial, _coefficient in polynomial.terms():
                factors = []
                for name, exponent in zip(names, monomial):
                    if exponent == 1:
                        factors.append(name)
                    elif exponent:
                        factors.append(f"{name}^{exponent}")
                terms.append("*".join(factors) if factors else "1")
            rendered.append("+".join(terms))
        args.gfan_output.write_text(
            "Q[" + ",".join(names) + "]\n{" + ",\n".join(rendered) + "}\n"
        )
    if args.singular_output:
        names = [str(variable) for variable in variables]
        rendered = []
        for polynomial in equations:
            terms = polynomial_mod_prime(polynomial, prime)
            rendered.append("+".join(
                term_to_string(monomial, coefficient, names)
                for monomial, coefficient in terms
            ) or "0")
        args.singular_output.write_text(
            f"ring R={prime},({','.join(names)}),dp;\n"
            "option(redSB);\n"
            "ideal I=" + ",\n".join(rendered) + ";\n"
            "ideal G=slimgb(I);\n"
            'print("DIM="+string(dim(G)));\n'
            'print("VDIM="+string(vdim(G)));\n'
            'print("SIZE="+string(size(G)));\n'
            "quit;\n"
        )
    if args.julia_output:
        names = [str(variable) for variable in variables]

        def float_polynomial(polynomial):
            coefficient_scale = max(abs(coefficient) for _, coefficient in polynomial.terms())
            terms = []
            for monomial, coefficient in polynomial.terms():
                scalar = float(coefficient / coefficient_scale)
                factors = []
                for name, exponent in zip(names, monomial):
                    if exponent == 1:
                        factors.append(name)
                    elif exponent:
                        factors.append(f"{name}^{exponent}")
                monomial_text = "*".join(factors)
                coefficient_text = format(scalar, ".17g")
                terms.append(
                    f"({coefficient_text})*{monomial_text}"
                    if monomial_text else f"({coefficient_text})"
                )
            return "+".join(terms)

        args.julia_output.write_text(
            "using HomotopyContinuation\n"
            "@var " + " ".join(names) + "\n"
            "F = [\n    " + ",\n    ".join(
                float_polynomial(polynomial) for polynomial in equations
            ) + "\n]\n"
            'println("VARIABLES=", length(variables(F)))\n'
            'println("EQUATIONS=", length(F))\n'
            "result = solve(F; start_system=:polyhedral, threading=true, "
            "show_progress=false)\n"
            'println("RESULT_BEGIN")\n'
            "show(stdout, MIME(\"text/plain\"), result)\n"
            'println("\\nRESULT_END")\n'
            'println("NONSINGULAR_SOLUTIONS=", length(solutions(result; only_nonsingular=true)))\n'
            'println("ALL_SOLUTIONS=", length(solutions(result)))\n'
        )
    print("prime", prime)
    print("roots_mod", roots_mod)
    print("variables", len(variables))
    print("equations", len(equations))
    print("term_counts", [len(poly.terms()) for poly in equations])
    print("output", args.output)
    print("saturated_leading", args.saturate_leading)
    if args.gfan_output:
        print("gfan_output", args.gfan_output)
    if args.singular_output:
        print("singular_output", args.singular_output)
    if args.julia_output:
        print("julia_output", args.julia_output)


if __name__ == "__main__":
    main()
