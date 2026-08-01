#!/usr/bin/env python3
"""Exact verifier for the ten three-Kummer plane-cubic restrictions."""

from __future__ import annotations

import hashlib
import json
import shutil
import subprocess
from fractions import Fraction
from itertools import combinations, product
from pathlib import Path


PACKET = Path(__file__).resolve().parent
WORKSPACE = PACKET.parents[2]
SOURCE = WORKSPACE.parent / "goal_runs_after_35fa" / "H_11_5_TWIST"
PAIR_PACKET = PACKET.parent / "h_trace_fourier_pair_k"
MARKER = "H_TRACE_THREE_KUMMER_TEN_GENERIC_SMOOTH_OK"

SOURCE_HASHES = {
    "field_model.json": "80fdc908633595d6bb3c292d0027aa66295a850b9b6a12cc473f90e3e373ba1e",
    "FIELD_MODEL.md": "a294d808585cb550cfe60c08559f4a8bc027977bf6292d83833a6efb2e22e745",
    "NORM_MODEL.md": "566448f33a3157c0e3ff2a5976b7af27e65440efa408442dd262ff5f933af5fd",
    "TWIST_MODEL.md": "f4c780fefe0dbd32a1f74fe6cad8fc2493b1210ca51e83a552624f05594f9b48",
}

PAIR_HASHES = {
    "REPORT.md": "5e7f4ad62d0235b5fa1377b128fc08c5ab4f13d31c0f9ebf97fc13fc6fbe4cb0",
    "payload.json": "afb11e06e285115bb71d62cc44343aff79e72ff9a00f871960f453659f900f0a",
    "verify.py": "1068c216d66e6e09c09301f7d5e6e4d9aa5d9afb78f4bdadde50561ea93b39fd",
    "REPLAY.md": "92841184e306ef0572dbb64efc85116988c1455b9302aecb760295af99da2f1f",
}


class Qz:
    """Q[e]/(e^4+e^3+e^2+e+1), reconstructed with stdlib Fractions."""

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

    def __repr__(self):
        return f"Qz{self.c!r}"


ZERO = Qz.of(0)
ONE = Qz.of(1)
EPS = Qz((0, 1, 0, 0))
assert EPS ** 5 == ONE and EPS != ONE


def sha256(path):
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


def R(index):
    answer = {}
    for alpha_degree in range(5):
        u = [0, 0, 0]
        if alpha_degree >= 2:
            u[alpha_degree - 2] = 1
        answer[(alpha_degree, *u)] = EPS ** (index * alpha_degree)
    return answer


H = multiply(R(2), multiply(R(3), R(3)))


def trace_coefficient(alpha_shift, scalar=ONE):
    """Return Tr(H*scalar*alpha^alpha_shift) as a U-polynomial."""
    answer = {}
    for (alpha_degree, u2, u3, u4), coefficient in H.items():
        total = alpha_degree + alpha_shift
        if total % 5:
            continue
        add_term(answer, (total // 5, u2, u3, u4), 5 * scalar * coefficient)
    return answer


def add_polynomial(target, source):
    for exponent, coefficient in source.items():
        add_term(target, exponent, coefficient)


def scale_polynomial(polynomial, scalar):
    return {exponent: scalar * coefficient for exponent, coefficient in polynomial.items()
            if scalar * coefficient}


def compact_components(triple):
    """Ten coefficients from the stated compact ternary-cubic formula."""
    answer = {}
    for counts in product(range(4), repeat=3):
        if sum(counts) != 3:
            continue
        used = [i for i, count in enumerate(counts) if count]
        total_degree = sum(count * triple[i] for i, count in enumerate(counts))
        if len(used) == 1:
            scalar = EPS ** triple[used[0]]
        elif len(used) == 2:
            repeated = next(i for i in used if counts[i] == 2)
            single = next(i for i in used if counts[i] == 1)
            scalar = 2 * EPS ** triple[repeated] + EPS ** triple[single]
        else:
            scalar = 2 * sum((EPS ** triple[i] for i in used), ZERO)
        answer[counts] = scale_polynomial(trace_coefficient(total_degree), scalar)
    return answer


def direct_components(triple):
    """Independent 27-ordered-term expansion of Tr(H*b^2*sigma(b))."""
    answer = {}
    for first in range(3):
        for second in range(3):
            for shifted in range(3):
                counts = [0, 0, 0]
                for index in (first, second, shifted):
                    counts[index] += 1
                counts = tuple(counts)
                alpha_shift = triple[first] + triple[second] + triple[shifted]
                piece = trace_coefficient(alpha_shift, EPS ** triple[shifted])
                add_polynomial(answer.setdefault(counts, {}), piece)
    return answer


def serialize_trace(polynomial):
    return [
        {"u": list(exponent), "c": [str(value) for value in coefficient.c]}
        for exponent, coefficient in sorted(polynomial.items())
    ]


def specialize(polynomial, values):
    answer = ZERO
    for exponent, coefficient in polynomial.items():
        monomial = 1
        for value, degree in zip(values, exponent):
            monomial *= value ** degree
        answer += monomial * coefficient
    return answer


def singular_qz(value):
    pieces = []
    for degree, coefficient in enumerate(value.c):
        if not coefficient:
            continue
        rational = (str(coefficient.numerator) if coefficient.denominator == 1
                    else f"({coefficient.numerator}/{coefficient.denominator})")
        monomial = "1" if degree == 0 else ("e" if degree == 1 else f"e^{degree}")
        pieces.append(f"({rational})*({monomial})")
    return "+".join(pieces) if pieces else "0"


def singular_cubic(components, values):
    pieces = []
    for counts, coefficient in sorted(components.items()):
        xyz = []
        for variable, degree in zip(("X", "Y", "Z"), counts):
            if degree:
                xyz.append(variable if degree == 1 else f"{variable}^{degree}")
        pieces.append(f"({singular_qz(specialize(coefficient, values))})*({'*'.join(xyz)})")
    return "+".join(pieces)


def singular_program(all_components, values):
    lines = [
        "ring r=(0,e),(X,Y,Z),dp;",
        "minpoly=e^4+e^3+e^2+e+1;",
    ]
    for triple, components in all_components.items():
        tag = "".join(map(str, triple))
        lines.extend([
            f"poly f{tag}={singular_cubic(components, values)};",
            f"if (f{tag}==0) {{ \"BAD_ZERO_{tag}\"; }}",
            f"ideal j{tag}=diff(f{tag},X),diff(f{tag},Y),diff(f{tag},Z);",
        ])
        for variable in ("X", "Y", "Z"):
            chart = variable.lower()
            lines.extend([
                f"ideal j{tag}{chart}=subst(j{tag},{variable},1);",
                f"ideal g{tag}{chart}=std(j{tag}{chart});",
                f"poly r{tag}{chart}=reduce(1,g{tag}{chart});",
                f"if (r{tag}{chart}!=0) {{ \"BAD_CHART_{tag}_{variable}\"; }}",
            ])
        lines.append(f'"SMOOTH_{tag}";')
    lines.extend(['"ALL_TEN_SPECIALIZED_PLANE_CUBICS_SMOOTH";', "quit;"])
    return "\n".join(lines) + "\n"


def main():
    payload = json.loads((PACKET / "payload.json").read_text())
    assert payload["marker"] == MARKER
    assert payload["source_hashes"] == SOURCE_HASHES

    for filename, expected in SOURCE_HASHES.items():
        actual = sha256(SOURCE / filename)
        assert actual == expected, (filename, actual)
    for filename, expected in PAIR_HASHES.items():
        actual = sha256(PAIR_PACKET / filename)
        assert actual == expected, (filename, actual)

    assert len(H) == 35
    base_traces = {str(index): serialize_trace(trace_coefficient(index)) for index in range(5)}
    assert base_traces == payload["trace_coefficients"]
    assert all(len(trace_coefficient(index)) == 7 for index in range(5))
    for index in range(8):
        shifted = {(u1 + 1, u2, u3, u4): coefficient
                   for (u1, u2, u3, u4), coefficient in trace_coefficient(index).items()}
        assert trace_coefficient(index + 5) == shifted

    triples = list(combinations(range(5), 3))
    assert [list(triple) for triple in triples] == payload["triples"]
    all_components = {}
    for triple in triples:
        compact = compact_components(triple)
        direct = direct_components(triple)
        assert compact == direct
        assert len(compact) == 10
        assert all(len(coefficient) == 7 for coefficient in compact.values())
        all_components[triple] = compact

    values = tuple(payload["smooth_specialization"]["U"])
    singular = shutil.which("Singular")
    assert singular is not None, "Singular is required for the geometric-smoothness certificate"
    completed = subprocess.run(
        [singular, "-q"],
        input=singular_program(all_components, values),
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=60,
        check=True,
    )
    output = completed.stdout
    assert "BAD_" not in output, output
    for triple in triples:
        assert f"SMOOTH_{''.join(map(str, triple))}" in output, output
    assert "ALL_TEN_SPECIALIZED_PLANE_CUBICS_SMOOTH" in output, output

    pair_completed = subprocess.run(
        ["python3", str(PAIR_PACKET / "verify.py")],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=60,
        check=True,
    )
    assert "H_TRACE_FOURIER_TWO_BASIS_FULL_K_NEWTON_EXCLUSION_OK" in pair_completed.stdout

    print("SOURCE_HASHES_OK", len(SOURCE_HASHES))
    print("PAIR_PACKET_HASHES_OK", len(PAIR_HASHES))
    print("H_TERMS", len(H))
    print("BASE_TRACE_COMPONENTS", ",".join(str(len(trace_coefficient(i))) for i in range(5)))
    print("COMPACT_EQUALS_ORDERED_EXPANSION", len(triples))
    print("SMOOTH_SPECIALIZATION", ",".join(map(str, values)))
    print("SMOOTH_GEOMETRIC_PLANE_CUBICS", len(triples))
    print("PAIR_BOUNDARY_IMPORTED", 10)
    print(MARKER)


if __name__ == "__main__":
    main()
