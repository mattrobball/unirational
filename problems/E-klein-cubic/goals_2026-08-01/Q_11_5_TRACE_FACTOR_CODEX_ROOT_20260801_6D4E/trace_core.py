#!/usr/bin/env python3
"""Self-contained exact Q(epsilon) core for the 11:5 Fourier trace cubic."""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction


@dataclass(frozen=True)
class Qz:
    coefficients: tuple[Fraction, Fraction, Fraction, Fraction]

    @staticmethod
    def of(value=0):
        if isinstance(value, Qz):
            return value
        return Qz((Fraction(value), Fraction(0), Fraction(0), Fraction(0)))

    def __bool__(self):
        return any(self.coefficients)

    def __add__(self, other):
        other = Qz.of(other)
        return Qz(tuple(a+b for a, b in zip(self.coefficients, other.coefficients)))

    __radd__ = __add__

    def __neg__(self):
        return Qz(tuple(-entry for entry in self.coefficients))

    def __sub__(self, other):
        return self + (-Qz.of(other))

    def __mul__(self, other):
        other = Qz.of(other)
        raw = [Fraction(0)]*7
        for i, left in enumerate(self.coefficients):
            for j, right in enumerate(other.coefficients):
                raw[i+j] += left*right
        for degree in range(6, 3, -1):
            leading = raw[degree]
            for step in range(1, 5):
                raw[degree-step] -= leading
        return Qz(tuple(raw[:4]))

    __rmul__ = __mul__

    def __pow__(self, exponent: int):
        if exponent < 0:
            return self.inverse()**(-exponent)
        answer = Qz.of(1)
        base = self
        while exponent:
            if exponent & 1:
                answer *= base
            base *= base
            exponent //= 2
        return answer

    def inverse(self):
        if not self:
            raise ZeroDivisionError
        columns = []
        for j in range(4):
            basis = Qz(tuple(Fraction(int(i == j)) for i in range(4)))
            columns.append((self*basis).coefficients)
        augmented = [
            [columns[j][i] for j in range(4)] + [Fraction(int(i == 0))]
            for i in range(4)
        ]
        for column in range(4):
            pivot = next(row for row in range(column, 4) if augmented[row][column])
            augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
            scale = augmented[column][column]
            augmented[column] = [entry/scale for entry in augmented[column]]
            for row in range(4):
                if row == column:
                    continue
                scale = augmented[row][column]
                augmented[row] = [
                    x-scale*y for x, y in zip(augmented[row], augmented[column])
                ]
        answer = Qz(tuple(augmented[i][4] for i in range(4)))
        assert self*answer == Qz.of(1)
        return answer


ZERO = Qz.of(0)
ONE = Qz.of(1)
Z = Qz((Fraction(0), Fraction(1), Fraction(0), Fraction(0)))
assert Z**4+Z**3+Z**2+Z+ONE == ZERO
assert Z**5 == ONE and Z != ONE


def add_term(polynomial, exponent, coefficient):
    polynomial[exponent] = polynomial.get(exponent, ZERO)+coefficient
    if not polynomial[exponent]:
        del polynomial[exponent]


def multiply(left, right):
    answer = {}
    for exponent1, coefficient1 in left.items():
        for exponent2, coefficient2 in right.items():
            exponent = tuple(a+b for a, b in zip(exponent1, exponent2))
            add_term(answer, exponent, coefficient1*coefficient2)
    return answer


def fourier_coordinate(index):
    # Exponents are (alpha,U2,U3,U4).
    answer = {}
    for alpha_degree in range(5):
        invariant_exponents = [0, 0, 0]
        if alpha_degree >= 2:
            invariant_exponents[alpha_degree-2] = 1
        answer[(alpha_degree, *invariant_exponents)] = Z**(index*alpha_degree)
    return answer


H = multiply(
    fourier_coordinate(2),
    multiply(fourier_coordinate(3), fourier_coordinate(3)),
)
assert len(H) == 35


def trace_component(alpha_shift, scalar):
    # Returned exponents are (U1,U2,U3,U4).
    answer = {}
    for (alpha_degree, u2, u3, u4), coefficient in H.items():
        total_degree = alpha_degree+alpha_shift
        if total_degree % 5:
            continue
        add_term(answer, (total_degree//5, u2, u3, u4), 5*scalar*coefficient)
    return answer


def components(p, q):
    alpha_shifts = (3*p, 2*p+q, p+2*q, 3*q)
    scalars = (Z**p, Z**q+2*Z**p, 2*Z**q+Z**p, Z**q)
    answer = [trace_component(shift, scalar)
              for shift, scalar in zip(alpha_shifts, scalars)]
    assert all(len(part) == 7 for part in answer)
    return answer
