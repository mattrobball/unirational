#!/usr/bin/env python3
"""Exact homogeneous Klein-covariant landing search.

For a homogeneous G-equivariant polynomial map ``p : V -> V`` of
degree d, a lift ``P(V) --> S`` exists precisely when

    q4(p(x, y, z)) = h(x, y, z)^2

for a G-invariant polynomial h of degree 2d.  The invariant ring of the
order-336 reflection extension is Q[F,D,C], in degrees 4, 6, and 14.
The G-covariant module splits by parity and is freely generated over
Q[F,D,C] in degrees

    odd:  1, 9, 11,
    even: 8, 16, 18.

This script constructs the complete covariant space in a requested degree,
equates the landing identity coefficient by coefficient, and checks every
projective coefficient patch by an exact Groebner basis.  A unit ideal in
every patch proves that there is no nonzero homogeneous landing covariant in
that degree.  A non-unit patch is reported as OPEN, not as a solution; any
component would still need an explicit point and a dominance check.

SymPy is the only non-standard dependency.

Examples:

    python3 certificates/klein_covariant_landing_search.py odd 13
    python3 certificates/klein_covariant_landing_search.py even 16
"""

from __future__ import annotations

import argparse
from functools import lru_cache

import sympy as sp


x, y, z = sp.symbols("x y z")
XYZ = (x, y, z)
F0, D0, C0 = sp.symbols("F D C")
u0, u1, u2 = sp.symbols("u0 u1 u2")


F = x**3 * y + y**3 * z + z**3 * x
D = x**5 * z - 5 * x**2 * y**2 * z**2 + x * y**5 + y * z**5
C = (
    x**14 - 34*x**11*y**2*z - 250*x**9*y*z**4
    + 375*x**8*y**4*z**2 + 18*x**7*y**7 + 18*x**7*z**7
    - 126*x**6*y**3*z**5 - 126*x**5*y**6*z**3
    - 250*x**4*y**9*z + 375*x**4*y**2*z**8
    - 126*x**3*y**5*z**6 + 375*x**2*y**8*z**4
    - 34*x**2*y*z**11 - 34*x*y**11*z**2 - 250*x*y**4*z**9
    + y**14 + 18*y**7*z**7 + z**14
)


# The primitive odd covariants.  Overall nonzero scalar factors are omitted;
# they do not alter the complete coefficient spaces or their landing loci.
g9 = sp.Matrix([
    -(x**7*y**2 + 38*x**5*y*z**3 - 25*x**4*y**4*z - 2*x**3*z**6
      - 25*x**2*y**3*z**4 + 19*x*y**6*z**2 - y**9 - 9*y**2*z**7),
    9*x**7*z**2 + 2*x**6*y**3 + 25*x**4*y**2*z**3
    - 38*x**3*y**5*z - 19*x**2*y*z**6 + 25*x*y**4*z**4
    - y**7*z**2 + z**9,
    x**9 - 19*x**6*y**2*z + 25*x**4*y*z**4
    + 25*x**3*y**4*z**2 + 9*x**2*y**7 - x**2*z**7
    - 38*x*y**3*z**5 + 2*y**6*z**3,
])

g11 = sp.Matrix([
    -(12*x**9*y*z + 23*x**7*z**4 - 114*x**6*y**3*z**2
      - 10*x**5*y**6 - 37*x**4*y**2*z**5 + 40*x**3*y**5*z**3
      + 34*x**2*y**8*z + x**2*y*z**8 + 67*x*y**4*z**6
      - 11*y**7*z**4 - z**11),
    x**11 - x**8*y**2*z - 67*x**6*y*z**4 + 37*x**5*y**4*z**2
    - 23*x**4*y**7 + 11*x**4*z**7 - 40*x**3*y**3*z**5
    + 114*x**2*y**6*z**3 - 12*x*y**9*z - 34*x*y**2*z**8
    + 10*y**5*z**6,
    -(34*x**8*y*z**2 - 11*x**7*y**4 - 10*x**6*z**5
      + 40*x**5*y**3*z**3 + 67*x**4*y**6*z - 114*x**3*y**2*z**6
      - 37*x**2*y**5*z**4 + x*y**8*z**2 + 12*x*y*z**9
      - y**11 + 23*y**4*z**7),
])


grad_F = sp.Matrix([sp.diff(F, variable) for variable in XYZ])
grad_D = sp.Matrix([sp.diff(D, variable) for variable in XYZ])
grad_C = sp.Matrix([sp.diff(C, variable) for variable in XYZ])


SECTORS = {
    "odd": ((1, sp.Matrix(XYZ)), (9, g9), (11, g11)),
    "even": (
        (8, grad_F.cross(grad_D)),
        (16, grad_F.cross(grad_C)),
        (18, grad_D.cross(grad_C)),
    ),
}


def invariant_monomials(weight: int) -> list[tuple[int, int, int]]:
    """Return (a,b,c) with 4a+6b+14c=weight."""
    if weight < 0:
        return []
    answer = []
    for c in range(weight // 14 + 1):
        for b in range(weight // 6 + 1):
            remainder = weight - 14*c - 6*b
            if remainder >= 0 and remainder % 4 == 0:
                answer.append((remainder // 4, b, c))
    return answer


@lru_cache(maxsize=None)
def invariant_basis(weight: int) -> tuple[sp.Poly, ...]:
    return tuple(
        sp.Poly(sp.expand(F**a * D**b * C**c), *XYZ, domain=sp.QQ)
        for a, b, c in invariant_monomials(weight)
    )


def express_in_invariants(expression: sp.Expr, weight: int) -> sp.Expr:
    """Express a known reflection invariant in Q[F,D,C], exactly."""
    monomials = invariant_monomials(weight)
    basis = invariant_basis(weight)
    polynomial = sp.Poly(sp.expand(expression), *XYZ, domain=sp.QQ)
    keys = sorted(set(polynomial.monoms()).union(*(set(item.monoms()) for item in basis)))
    matrix = sp.MutableSparseMatrix(len(keys), len(basis), {})
    target = sp.zeros(len(keys), 1)
    for row, key in enumerate(keys):
        target[row] = polynomial.coeff_monomial(key)
        for column, item in enumerate(basis):
            value = item.coeff_monomial(key)
            if value:
                matrix[row, column] = value
    solutions = list(sp.linsolve((matrix, target)))
    if len(solutions) != 1:
        raise AssertionError(f"invariant expression in weight {weight} is not unique")
    coefficients = solutions[0]
    if any(value.free_symbols for value in coefficients):
        raise AssertionError(f"underdetermined invariant expression in weight {weight}")
    return sp.expand(sum(
        value * F0**a * D0**b * C0**c
        for value, (a, b, c) in zip(coefficients, monomials)
    ))


def q4(vector: sp.Matrix) -> sp.Expr:
    return sp.expand(vector[0]**3*vector[1] + vector[1]**3*vector[2]
                     + vector[2]**3*vector[0])


@lru_cache(maxsize=None)
def quartic_tensor(sector: str) -> sp.Expr:
    """q4(u0*g0+u1*g1+u2*g2), written over Q[F,D,C]."""
    generators = SECTORS[sector]
    vector = u0*generators[0][1] + u1*generators[1][1] + u2*generators[2][1]
    polynomial = sp.Poly(q4(vector), u0, u1, u2)
    answer = 0
    degrees = tuple(item[0] for item in generators)
    for powers, coefficient in polynomial.terms():
        weight = sum(power*degree for power, degree in zip(powers, degrees))
        answer += (
            express_in_invariants(coefficient, weight)
            * u0**powers[0] * u1**powers[1] * u2**powers[2]
        )
    return sp.expand(answer)


def complete_covariant(degree: int, sector: str):
    """Return coefficient polynomials u_i and all scalar parameters."""
    parameters = []
    coefficients = []
    next_index = 0
    for generator_degree, _ in SECTORS[sector]:
        terms = []
        for a, b, c in invariant_monomials(degree - generator_degree):
            parameter = sp.Symbol(f"p{next_index}")
            next_index += 1
            parameters.append(parameter)
            terms.append(parameter * F0**a * D0**b * C0**c)
        coefficients.append(sum(terms, sp.S.Zero))
    return tuple(coefficients), tuple(parameters)


def landing_equations(degree: int, sector: str):
    coefficients, parameters = complete_covariant(degree, sector)
    root_monomials = invariant_monomials(2*degree)
    roots = sp.symbols(f"r0:{len(root_monomials)}")
    root = sum(
        parameter * F0**a * D0**b * C0**c
        for parameter, (a, b, c) in zip(roots, root_monomials)
    )
    landing = quartic_tensor(sector).subs(dict(zip((u0, u1, u2), coefficients)))
    difference = sp.Poly(sp.expand(landing - root**2), F0, D0, C0)
    equations = tuple(sp.factor(value) for value in difference.coeffs() if value != 0)
    return equations, parameters, roots, coefficients, root_monomials


def patch_is_empty(equations, variables, substitutions):
    specialized = [sp.factor(value.subs(substitutions)) for value in equations]
    if any(value.is_number and value != 0 for value in specialized):
        return True, (sp.S.One,)
    specialized = [value for value in specialized if value != 0]
    remaining = [variable for variable in variables if variable not in substitutions]
    if not specialized:
        return False, ()
    if not remaining:
        return False, tuple(specialized)
    basis = sp.groebner(specialized, *remaining, order="grevlex")
    expressions = tuple(item.as_expr() for item in basis.polys)
    return any(value == 1 for value in expressions), expressions


def check_degree(degree: int, sector: str) -> bool:
    expected_parity = 1 if sector == "odd" else 0
    if degree % 2 != expected_parity:
        raise ValueError(f"degree {degree} does not belong to the {sector} sector")
    equations, parameters, roots, coefficients, root_monomials = landing_equations(
        degree, sector
    )
    print(f"sector={sector} degree={degree}")
    print(f"covariant_parameters={len(parameters)} root_parameters={len(roots)} "
          f"equations={len(equations)}")
    print(f"coefficient_blocks={coefficients}")
    print(f"root_monomials={root_monomials}")
    if not parameters:
        print("NO_COVARIANTS")
        return True

    variables = (*parameters, *roots)
    all_empty = True
    for index, pivot in enumerate(parameters):
        substitutions = {parameter: 0 for parameter in parameters[:index]}
        substitutions[pivot] = 1
        empty, basis = patch_is_empty(equations, variables, substitutions)
        print(f"patch={index} pivot={pivot} status={'EMPTY' if empty else 'OPEN'} "
              f"groebner_size={len(basis)}")
        if not empty:
            all_empty = False
            print(f"patch_basis={basis}")
    if all_empty:
        print("NO_NONZERO_LANDING_COVARIANT")
    else:
        print("LANDING_LOCUS_OPEN_REQUIRES_POINT_AND_DOMINANCE_CHECK")
    return all_empty


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("sector", choices=sorted(SECTORS))
    parser.add_argument("degree", type=int, nargs="+")
    args = parser.parse_args()
    empty = True
    for degree in args.degree:
        empty = check_degree(degree, args.sector) and empty
    print("KLEIN_COVARIANT_SEARCH_OK" if empty else "KLEIN_COVARIANT_SEARCH_OPEN")


if __name__ == "__main__":
    main()
