#!/usr/bin/env python3
"""Standalone exact verifier for the two constant five-coordinate trace families."""

from __future__ import annotations

import hashlib
import itertools
import json
import shutil
import subprocess
from fractions import Fraction
from pathlib import Path


PACKET = Path(__file__).resolve().parent
WORKSPACE = PACKET.parents[2]
SOURCE = WORKSPACE.parent / "goal_runs_after_35fa" / "H_11_5_TWIST"
MARKER = "H_TRACE_CONSTANT_FIVE_COORDINATE_TWO_BASIS_EXCLUSION_OK"

SOURCE_HASHES = {
    "field_model.json": "80fdc908633595d6bb3c292d0027aa66295a850b9b6a12cc473f90e3e373ba1e",
    "FIELD_MODEL.md": "a294d808585cb550cfe60c08559f4a8bc027977bf6292d83833a6efb2e22e745",
    "NORM_MODEL.md": "566448f33a3157c0e3ff2a5976b7af27e65440efa408442dd262ff5f933af5fd",
    "TWIST_MODEL.md": "f4c780fefe0dbd32a1f74fe6cad8fc2493b1210ca51e83a552624f05594f9b48",
}

PRODUCER_HASH = "fd76b6f315a60086bac5ac3ee2ed507d02a276eba6b8d54968f75f29ab8f3325"

PROGRAM_HASHES = {
    "constant_kummer_p11.sing": "afff727b049e03693c7dfab89f0997b60e28feb4b1d76cac722fd0411f47707b",
    "constant_kummer_p31.sing": "30da719303760722eb9cd13ec59e6c0653897db7d764f600b4c8736dedb04e41",
    "constant_r_basis_p11.sing": "338b49fec4b37b66d3e93d6bf914d796cc1224ed97d7550f129771ff902c0529",
    "constant_r_basis_p31.sing": "67cf365ec5f620ea4c7e509e954a0f3a3e590e313802a6de07922381908c9433",
}


class Qz:
    """Q[e]/(e^4+e^3+e^2+e+1), using standard-library arithmetic."""

    __slots__ = ("c",)

    def __init__(self, coefficients=(0, 0, 0, 0)):
        self.c = tuple(Fraction(value) for value in coefficients)
        if len(self.c) != 4:
            raise ValueError("Qz needs four coefficients")

    @staticmethod
    def of(value=0):
        return value if isinstance(value, Qz) else Qz((value, 0, 0, 0))

    def __add__(self, other):
        other = Qz.of(other)
        return Qz(tuple(a + b for a, b in zip(self.c, other.c)))

    __radd__ = __add__

    def __neg__(self):
        return Qz(tuple(-value for value in self.c))

    def __sub__(self, other):
        return self + (-Qz.of(other))

    def __mul__(self, other):
        other = Qz.of(other)
        raw = [Fraction(0)] * 7
        for i, left in enumerate(self.c):
            for j, right in enumerate(other.c):
                raw[i + j] += left * right
        for degree in range(6, 3, -1):
            leading = raw[degree]
            for drop in range(1, 5):
                raw[degree - drop] -= leading
        return Qz(raw[:4])

    __rmul__ = __mul__

    def __pow__(self, exponent):
        if exponent < 0:
            raise ValueError("negative powers are not needed")
        answer = Qz.of(1)
        base = self
        while exponent:
            if exponent & 1:
                answer = answer * base
            base = base * base
            exponent //= 2
        return answer

    def __eq__(self, other):
        return self.c == Qz.of(other).c

    def __bool__(self):
        return any(self.c)


ZERO = Qz.of(0)
ONE = Qz.of(1)
EPS = Qz((0, 1, 0, 0))
assert EPS**5 == ONE and EPS != ONE


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def add_term(polynomial, exponent, coefficient):
    coefficient = Qz.of(coefficient)
    polynomial[exponent] = polynomial.get(exponent, ZERO) + coefficient
    if not polynomial[exponent]:
        del polynomial[exponent]


def multiply(left, right):
    answer = {}
    for (a1, u21, u31, u41), c1 in left.items():
        for (a2, u22, u32, u42), c2 in right.items():
            add_term(answer, (a1 + a2, u21 + u22, u31 + u32, u41 + u42), c1 * c2)
    return answer


def R(index: int):
    answer = {}
    for alpha_degree in range(5):
        u = [0, 0, 0]
        if alpha_degree >= 2:
            u[alpha_degree - 2] = 1
        answer[(alpha_degree, *u)] = EPS ** (index * alpha_degree)
    return answer


R_FACTORS = [R(index) for index in range(5)]
H = multiply(R_FACTORS[2], multiply(R_FACTORS[3], R_FACTORS[3]))


def trace_coefficient(alpha_shift: int, scalar=ONE):
    """Tr(H*scalar*alpha^alpha_shift), grouped by U-monomial."""
    answer = {}
    for (alpha_degree, u2, u3, u4), coefficient in H.items():
        total = alpha_degree + alpha_shift
        if total % 5:
            continue
        add_term(answer, (total // 5, u2, u3, u4), 5 * scalar * coefficient)
    return answer


def add_equation_term(equations, exponent, counts, coefficient):
    equation = equations.setdefault(exponent, {})
    equation[counts] = equation.get(counts, ZERO) + coefficient
    if not equation[counts]:
        del equation[counts]


def kummer_equations():
    """Coefficients of Tr(H*b^2*sigma(b)), b=sum c_i alpha^i."""
    equations = {}
    for first, second, shifted in itertools.product(range(5), repeat=3):
        counts = tuple((first, second, shifted).count(index) for index in range(5))
        trace = trace_coefficient(first + second + shifted, EPS**shifted)
        for exponent, coefficient in trace.items():
            add_equation_term(equations, exponent, counts, coefficient)
    return {exponent: equation for exponent, equation in equations.items() if equation}


def trace_general(polynomial):
    answer = {}
    for (alpha_degree, u2, u3, u4), coefficient in polynomial.items():
        if alpha_degree % 5:
            continue
        add_term(answer, (alpha_degree // 5, u2, u3, u4), 5 * coefficient)
    return answer


def r_basis_equations():
    """Coefficients after clearing N*(R3/R2), for a=sum c_i R_i."""
    # N=product_i R_i is invariant and nonzero.  Since r2^-1=R3/R2,
    # N*r2^-1=R0*R1*R3^2*R4.
    cleared = R_FACTORS[0]
    for index in (1, 3, 3, 4):
        cleared = multiply(cleared, R_FACTORS[index])
    equations = {}
    for first, second, shifted in itertools.product(range(5), repeat=3):
        counts = tuple((first, second, shifted).count(index) for index in range(5))
        product = multiply(cleared, R_FACTORS[first])
        product = multiply(product, R_FACTORS[second])
        product = multiply(product, R_FACTORS[(shifted + 1) % 5])
        for exponent, coefficient in trace_general(product).items():
            add_equation_term(equations, exponent, counts, coefficient)
    return {exponent: equation for exponent, equation in equations.items() if equation}


def qz_mod(value: Qz, prime: int, root: int) -> int:
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


def c_monomial(counts):
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
            terms.append(f"{scalar}*{c_monomial(counts)}")
    return "+".join(terms) or "0"


def singular_program(equations, prime: int) -> tuple[str, int, int]:
    root = primitive_fifth_root(prime)
    polynomials = [modular_polynomial(equation, prime, root) for equation in equations.values()]
    polynomials = [polynomial for polynomial in polynomials if polynomial != "0"]
    lines = [
        f"ring r={prime},(c0,c1,c2,c3,c4),dp;",
        f"ideal I={','.join(polynomials)};",
        f'print("PRIME={prime}");',
        f'print("FIFTH_ROOT={root}");',
        f'print("NONZERO_EQUATIONS={len(polynomials)}");',
    ]
    for index in range(5):
        lines.extend(
            [
                f"ideal I{index}=subst(I,c{index},1);",
                f"ideal G{index}=std(I{index});",
                f"poly r{index}=reduce(1,G{index});",
                f'if (r{index}==0) {{ print("CHART_{index}_EMPTY=true"); }} else {{ print("CHART_{index}_EMPTY=false"); }}',
            ]
        )
    lines.append("quit;")
    return "\n".join(lines) + "\n", root, len(polynomials)


def replay_program(path: Path, prime: int, root: int, nonzero_equations: int) -> str:
    singular = shutil.which("Singular")
    assert singular is not None, "Singular is required"
    completed = subprocess.run(
        [singular, "-q", str(path)],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=300,
        check=True,
    )
    output = completed.stdout
    assert f"PRIME={prime}" in output, output
    assert f"FIFTH_ROOT={root}" in output, output
    assert f"NONZERO_EQUATIONS={nonzero_equations}" in output, output
    assert "_EMPTY=false" not in output, output
    for index in range(5):
        assert output.count(f"CHART_{index}_EMPTY=true") == 1, output
    return output


def main() -> None:
    payload = json.loads((PACKET / "payload.json").read_text())
    assert payload["marker"] == MARKER
    assert payload["source_hashes"] == SOURCE_HASHES
    assert payload["program_hashes"] == PROGRAM_HASHES
    assert payload["producer_hash"] == PRODUCER_HASH
    assert payload["verifier_hash"] == sha256(Path(__file__))
    for filename, expected in SOURCE_HASHES.items():
        assert sha256(SOURCE / filename) == expected, filename
    assert sha256(PACKET / "search_constant_five_kummer.py") == PRODUCER_HASH

    families = {"KUMMER": kummer_equations(), "R_BASIS": r_basis_equations()}
    assert len(H) == 35
    assert len(families["KUMMER"]) == 55
    assert sum(len(equation) for equation in families["KUMMER"].values()) == 245
    assert len(families["R_BASIS"]) == 99
    assert sum(len(equation) for equation in families["R_BASIS"].values()) == 3444

    expected_nonzero = {
        ("KUMMER", 11): 52,
        ("KUMMER", 31): 55,
        ("R_BASIS", 11): 99,
        ("R_BASIS", 31): 99,
    }
    outputs = {}
    for family, equations in families.items():
        stem = family.lower()
        for prime in (11, 31):
            program, root, nonzero = singular_program(equations, prime)
            assert nonzero == expected_nonzero[(family, prime)]
            path = PACKET / f"constant_{stem}_p{prime}.sing"
            assert path.read_text() == program, path.name
            assert sha256(path) == PROGRAM_HASHES[path.name], path.name
            if family == "KUMMER":
                duplicate = PACKET / f"constant_five_kummer_p{prime}.sing"
                assert duplicate.read_text() == program
            outputs[(family, prime)] = replay_program(path, prime, root, nonzero)
            print(f"{family}_P{prime}_ALL_5_PROJECTIVE_CHARTS_EMPTY")

    assert payload["families"]["kummer"]["u_coefficient_equations"] == 55
    assert payload["families"]["r_basis"]["u_coefficient_equations"] == 99
    assert all(payload["reductions"][str(prime)][family.lower()]["all_five_charts_empty"]
               for prime in (11, 31) for family in families)

    print("SOURCE_HASHES_OK", len(SOURCE_HASHES))
    print("PRODUCER_HASH_OK", PRODUCER_HASH)
    print("PROGRAM_HASHES_OK", len(PROGRAM_HASHES))
    print("H_TERMS", len(H))
    print("KUMMER_EQUATIONS_TERMS", len(families["KUMMER"]), 245)
    print("R_BASIS_EQUATIONS_TERMS", len(families["R_BASIS"]), 3444)
    print(MARKER)
    print("SCOPE: two constant five-coordinate families only; no generic pointlessness theorem")


if __name__ == "__main__":
    main()
