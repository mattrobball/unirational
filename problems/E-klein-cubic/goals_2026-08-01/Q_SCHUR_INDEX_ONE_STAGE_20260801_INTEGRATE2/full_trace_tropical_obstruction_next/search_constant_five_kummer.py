#!/usr/bin/env python3
"""Exact projective search for b=sum c_i alpha^i in Tr(H b^2 sigma(b))=0."""

from __future__ import annotations

import importlib.util
import itertools
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "h_trace_three_kummer_planes" / "verify.py"
SPEC = importlib.util.spec_from_file_location("three_kummer", SOURCE)
THREE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(THREE)


def qz_mod(value, prime: int, root: int) -> int:
    total = 0
    power = 1
    for coefficient in value.c:
        total += coefficient.numerator * pow(coefficient.denominator, -1, prime) * power
        power = power * root % prime
    return total % prime


def primitive_fifth_root(prime: int) -> int:
    for root in range(2, prime):
        if pow(root, 5, prime) == 1 and root != 1:
            return root
    raise ValueError(f"no fifth root modulo {prime}")


def full_coefficient_equations():
    """Group the 125 ordered contributions by U-monomial and c-monomial."""
    equations = {}
    for first, second, shifted in itertools.product(range(5), repeat=3):
        counts = [0] * 5
        counts[first] += 1
        counts[second] += 1
        counts[shifted] += 1
        counts = tuple(counts)
        trace = THREE.trace_coefficient(first + second + shifted, THREE.EPS ** shifted)
        for exponent, coefficient in trace.items():
            equation = equations.setdefault(exponent, {})
            equation[counts] = equation.get(counts, THREE.ZERO) + coefficient
            if not equation[counts]:
                del equation[counts]
    return {exponent: equation for exponent, equation in equations.items() if equation}


def trace_general(polynomial):
    answer = {}
    for (alpha_degree, u2, u3, u4), coefficient in polynomial.items():
        if alpha_degree % 5:
            continue
        exponent = (alpha_degree // 5, u2, u3, u4)
        answer[exponent] = answer.get(exponent, THREE.ZERO) + 5 * coefficient
        if not answer[exponent]:
            del answer[exponent]
    return answer


def constant_r_basis_equations():
    """For a=sum c_i R_i, clear Norm(R2) and group Tr by U-monomials."""
    factors = [THREE.R(i) for i in range(5)]
    cleared_coefficient = factors[0]
    for index in (1, 3, 3, 4):
        cleared_coefficient = THREE.multiply(cleared_coefficient, factors[index])
    equations = {}
    for first, second, shifted in itertools.product(range(5), repeat=3):
        counts = [0] * 5
        counts[first] += 1
        counts[second] += 1
        counts[shifted] += 1
        counts = tuple(counts)
        product = THREE.multiply(cleared_coefficient, factors[first])
        product = THREE.multiply(product, factors[second])
        product = THREE.multiply(product, factors[(shifted + 1) % 5])
        for exponent, coefficient in trace_general(product).items():
            equation = equations.setdefault(exponent, {})
            equation[counts] = equation.get(counts, THREE.ZERO) + coefficient
            if not equation[counts]:
                del equation[counts]
    return {exponent: equation for exponent, equation in equations.items() if equation}


def monomial(counts):
    factors = []
    for index, degree in enumerate(counts):
        if degree == 1:
            factors.append(f"c{index}")
        elif degree:
            factors.append(f"c{index}^{degree}")
    return "*".join(factors) or "1"


def modular_polynomial(equation, prime: int, root: int) -> str:
    terms = []
    for counts, coefficient in sorted(equation.items()):
        scalar = qz_mod(coefficient, prime, root)
        if scalar:
            terms.append(f"{scalar}*{monomial(counts)}")
    return "+".join(terms) or "0"


def singular_program(equations, prime: int) -> str:
    root = primitive_fifth_root(prime)
    polynomials = [modular_polynomial(eq, prime, root) for eq in equations.values()]
    polynomials = [poly for poly in polynomials if poly != "0"]
    lines = [
        f"ring r={prime},(c0,c1,c2,c3,c4),dp;",
        f"ideal I={','.join(polynomials)};",
        'print("PRIME=' + str(prime) + '");',
        'print("FIFTH_ROOT=' + str(root) + '");',
        'print("NONZERO_EQUATIONS=' + str(len(polynomials)) + '");',
    ]
    for index in range(5):
        lines += [
            f"ideal I{index}=subst(I,c{index},1);",
            f"ideal G{index}=std(I{index});",
            f"poly r{index}=reduce(1,G{index});",
            f'if (r{index}==0) {{ print("CHART_{index}_EMPTY=true"); }} else {{ print("CHART_{index}_EMPTY=false"); }}',
        ]
    lines += ["quit;"]
    return "\n".join(lines) + "\n"


def main():
    families = {
        "KUMMER": full_coefficient_equations(),
        "R_BASIS": constant_r_basis_equations(),
    }
    for family, equations in families.items():
        assert equations
        print(f"{family}_U_COEFFICIENT_EQUATIONS={len(equations)}")
        print(f"{family}_TOTAL_CUBIC_TERMS={sum(len(eq) for eq in equations.values())}")
        for prime in (11, 31):
            program = singular_program(equations, prime)
            source = HERE / f"constant_{family.lower()}_p{prime}.sing"
            source.write_text(program)
            completed = subprocess.run(
                ["Singular", "-q", str(source)],
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                timeout=300,
                check=False,
            )
            print(f"FAMILY={family}")
            print(completed.stdout, end="")
            if completed.returncode:
                raise SystemExit(completed.returncode)


if __name__ == "__main__":
    main()
