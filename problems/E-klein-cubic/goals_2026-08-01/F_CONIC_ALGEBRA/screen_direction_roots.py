#!/usr/bin/env python3
"""Screen low-complexity binary directions for a generic cubic root.

For each formula `s=y/w` built from monomials in `(t,u,v)`, test whether
`X^3+q(s,1)X+r(s,1)` has a root in four irreducible degree-six finite-field
specializations.  This is discovery only; survivors require a symbolic
characteristic-zero factorization.
"""

from __future__ import annotations

import itertools
import json
from dataclasses import dataclass
from pathlib import Path

from model import specialized_cubic, specialized_field


HERE = Path(__file__).resolve().parent
P = 67
SAMPLES = tuple(
    {"A": A, "B": B, "Y": Y, "Z": Z}
    for A, B, Y, Z in (
        (58, 13, 41, 1), (66, 1, 5, 10), (53, 33, 55, 49),
        (18, 49, 9, 34), (45, 36, 22, 19), (28, 66, 5, 3),
        (40, 10, 57, 60), (49, 4, 49, 46), (60, 37, 53, 60),
        (46, 65, 36, 66), (11, 19, 33, 18), (6, 18, 37, 48),
        (17, 58, 16, 8), (7, 34, 16, 5), (5, 64, 14, 29),
        (59, 29, 36, 61), (33, 41, 8, 33), (60, 38, 2, 38),
        (49, 1, 52, 39), (6, 10, 42, 14), (47, 64, 60, 9),
        (13, 18, 52, 50), (2, 50, 64, 38), (39, 25, 64, 21),
    )
)


@dataclass(frozen=True)
class FF:
    modulus: tuple[int, ...]  # monic degree six, low coefficients first

    @property
    def zero(self):
        return (0,) * 6

    @property
    def one(self):
        return (1, 0, 0, 0, 0, 0)

    def scalar(self, value: int):
        return (value % P, 0, 0, 0, 0, 0)

    def add(self, left, right):
        return tuple((a + b) % P for a, b in zip(left, right))

    def neg(self, value):
        return tuple((-a) % P for a in value)

    def sub(self, left, right):
        return self.add(left, self.neg(right))

    def mul(self, left, right):
        work = [0] * 11
        for i, a in enumerate(left):
            for j, b in enumerate(right):
                work[i + j] = (work[i + j] + a * b) % P
        for degree in range(10, 5, -1):
            leading = work[degree]
            if not leading:
                continue
            for index in range(6):
                work[degree - 6 + index] = (
                    work[degree - 6 + index] - leading * self.modulus[index]
                ) % P
        return tuple(work[:6])

    def pow(self, value, exponent: int):
        answer, base = self.one, value
        while exponent:
            if exponent & 1:
                answer = self.mul(answer, base)
            base = self.mul(base, base)
            exponent >>= 1
        return answer

    def inv(self, value):
        assert value != self.zero
        def trim_int(poly):
            result = list(poly)
            while result and result[-1] % P == 0:
                result.pop()
            return [entry % P for entry in result]

        def divmod_int(left, right):
            left, right = trim_int(left), trim_int(right)
            quotient = [0] * max(0, len(left) - len(right) + 1)
            inverse = pow(right[-1], -1, P)
            while len(left) >= len(right):
                degree = len(left) - len(right)
                scalar = left[-1] * inverse % P
                quotient[degree] = scalar
                for index, coefficient in enumerate(right):
                    left[degree + index] = (left[degree + index] - scalar * coefficient) % P
                left = trim_int(left)
            return trim_int(quotient), left

        def mul_int(left, right):
            answer = [0] * (len(left) + len(right) - 1) if left and right else []
            for i, a in enumerate(left):
                for j, b in enumerate(right):
                    answer[i + j] = (answer[i + j] + a * b) % P
            return trim_int(answer)

        def sub_int(left, right):
            size = max(len(left), len(right))
            return trim_int([
                ((left[i] if i < len(left) else 0) - (right[i] if i < len(right) else 0)) % P
                for i in range(size)
            ])

        old_r, current_r = trim_int(self.modulus), trim_int(value)
        old_t, current_t = [], [1]
        while current_r:
            quotient, remainder = divmod_int(old_r, current_r)
            old_r, current_r = current_r, remainder
            old_t, current_t = current_t, sub_int(old_t, mul_int(quotient, current_t))
        assert len(old_r) == 1
        scalar = pow(old_r[0], -1, P)
        reduced = divmod_int([(scalar * entry) % P for entry in old_t], list(self.modulus))[1]
        return tuple(reduced + [0] * (6 - len(reduced)))

    def div(self, left, right):
        return self.mul(left, self.inv(right))


def trim(poly, zero):
    result = list(poly)
    while result and result[-1] == zero:
        result.pop()
    return result


def poly_add(field: FF, left, right):
    size = max(len(left), len(right))
    return trim([
        field.add(left[i] if i < len(left) else field.zero,
                  right[i] if i < len(right) else field.zero)
        for i in range(size)
    ], field.zero)


def poly_mul(field: FF, left, right):
    if not left or not right:
        return []
    answer = [field.zero] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            answer[i + j] = field.add(answer[i + j], field.mul(a, b))
    return trim(answer, field.zero)


def poly_divmod(field: FF, left, right):
    left, right = trim(left, field.zero), trim(right, field.zero)
    quotient = [field.zero] * max(0, len(left) - len(right) + 1)
    inverse = field.inv(right[-1])
    while len(left) >= len(right):
        degree = len(left) - len(right)
        scalar = field.mul(left[-1], inverse)
        quotient[degree] = scalar
        for index, coefficient in enumerate(right):
            left[degree + index] = field.sub(left[degree + index], field.mul(scalar, coefficient))
        left = trim(left, field.zero)
    return trim(quotient, field.zero), left


def poly_mod(field: FF, left, modulus):
    return poly_divmod(field, left, modulus)[1]


def poly_powmod(field: FF, base, exponent: int, modulus):
    answer = [field.one]
    while exponent:
        if exponent & 1:
            answer = poly_mod(field, poly_mul(field, answer, base), modulus)
        base = poly_mod(field, poly_mul(field, base, base), modulus)
        exponent >>= 1
    return answer


def poly_gcd(field: FF, left, right):
    while right:
        left, right = right, poly_divmod(field, left, right)[1]
    if not left:
        return []
    inverse = field.inv(left[-1])
    return [field.mul(value, inverse) for value in left]


def cubic_root(field: FF, linear: tuple, constant: tuple):
    cubic = [constant, linear, field.zero, field.one]
    frobenius = poly_powmod(field, [field.zero, field.one], P**6, cubic)
    difference = poly_add(field, frobenius, [field.zero, field.neg(field.one)])
    divisor = poly_gcd(field, cubic, difference)
    if len(divisor) == 2:
        return True, field.neg(divisor[0])  # monic linear divisor X-a
    return len(divisor) > 1, None


def vector(poly) -> tuple[int, ...]:
    return tuple(int(poly.nth(index)) % P for index in range(6))


def monomials(field: FF, t, u, v):
    result, labels = [], []
    for total in range(4):
        for et in range(total + 1):
            for eu in range(total - et + 1):
                ev = total - et - eu
                value = field.mul(field.pow(t, et), field.mul(field.pow(u, eu), field.pow(v, ev)))
                result.append(value)
                labels.append((et, eu, ev))
    return result, labels


def direction_value(field: FF, monomial_values, inverse_values, candidate):
    kind, i, j, k, sign = candidate
    numerator = monomial_values[i]
    if kind == "sum":
        numerator = field.add(numerator, monomial_values[j] if sign == 1 else field.neg(monomial_values[j]))
    inverse = inverse_values[k]
    if inverse is None:
        return None
    return field.mul(numerator, inverse)


def root_for_direction(field: FF, q, r, s):
    s2, s3 = field.mul(s, s), field.mul(field.mul(s, s), s)
    linear = field.add(field.add(field.mul(field.scalar(q[0]), s2), field.mul(field.scalar(q[1]), s)), field.scalar(q[2]))
    constant = field.add(
        field.add(field.mul(field.scalar(r[0]), s3), field.mul(field.scalar(r[1]), s2)),
        field.add(field.mul(field.scalar(r[2]), s), field.scalar(r[3])),
    )
    return cubic_root(field, linear, constant)


def main() -> None:
    sample_data = []
    labels = None
    for sample in SAMPLES:
        model = specialized_field(sample, P)
        modulus = tuple(int(model.modulus.nth(index)) % P for index in range(7))
        assert modulus[-1] == 1
        field = FF(modulus)
        values, current_labels = monomials(field, vector(model.t_element), vector(model.u_element), vector(model.v_element))
        labels = current_labels
        inverses = [None if value == field.zero else field.inv(value) for value in values]
        sample_data.append((field, values, inverses, specialized_cubic(sample, P, 9)))

    # Ratios m_i/m_k and two-term numerators (m_i +/- m_j)/m_k.
    candidates = [("ratio", i, i, k, 1) for i in range(20) for k in range(20)]
    candidates += [
        ("sum", i, j, k, sign)
        for i in range(20) for j in range(i + 1, 20)
        for k in range(20) for sign in (1, -1)
    ]
    survivors = []
    for candidate in candidates:
        roots = []
        for field, values, inverses, (q, r) in sample_data:
            direction = direction_value(field, values, inverses, candidate)
            if direction is None:
                break
            has_root, root = root_for_direction(field, q, r, direction)
            if not has_root:
                break
            roots.append(None if root is None else list(root))
        if len(roots) == len(sample_data):
            kind, i, j, k, sign = candidate
            record = {
                "kind": kind,
                "numerator": [labels[i]] if kind == "ratio" else [labels[i], labels[j]],
                "sign": sign,
                "denominator": labels[k],
                "roots": roots,
            }
            survivors.append(record)

    output = HERE / "direction_root_screen_p67.json"
    output.write_text(json.dumps({
        "scope": "discovery only",
        "prime": P,
        "samples": SAMPLES,
        "candidate_count": len(candidates),
        "survivors": survivors,
    }, indent=2, sort_keys=True) + "\n")
    print(f"candidate_count={len(candidates)} survivor_count={len(survivors)}")
    print("DIRECTION_ROOT_SCREEN_DONE")


if __name__ == "__main__":
    main()
