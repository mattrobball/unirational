#!/usr/bin/env python3
"""Exact checks for the clean CM norm equation over Q(sqrt(-11)).

Only Python integer arithmetic is used.  The ring basis is
    O_K = Z[omega], omega^2 = omega - 3.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import isqrt


@dataclass(frozen=True)
class OK:
    x: int
    y: int

    def __mul__(self, other: "OK") -> "OK":
        # (x+y*w)(a+b*w), with w^2=w-3.
        return OK(
            self.x * other.x - 3 * self.y * other.y,
            self.x * other.y + self.y * other.x + self.y * other.y,
        )

    def __pow__(self, n: int) -> "OK":
        if n < 0:
            raise ValueError("negative powers are not integral checks")
        out = OK(1, 0)
        base = self
        k = n
        while k:
            if k & 1:
                out = out * base
            base = base * base
            k >>= 1
        return out

    def norm(self) -> int:
        return self.x * self.x + self.x * self.y + 3 * self.y * self.y


def representations(n: int) -> list[OK]:
    if n < 0:
        return []
    # Completing the square: 4N=(2x+y)^2+11y^2, so |y|<=sqrt(4n/11).
    y_bound = isqrt((4 * n) // 11) + 1
    x_bound = isqrt(4 * n) + y_bound + 2
    ans: list[OK] = []
    for y in range(-y_bound, y_bound + 1):
        for x in range(-x_bound, x_bound + 1):
            z = OK(x, y)
            if z.norm() == n:
                ans.append(z)
    return ans


def represented(n: int) -> bool:
    return bool(representations(n))


def main() -> None:
    omega = OK(0, 1)
    nu = OK(-1, 1)

    assert omega * omega == OK(-3, 1)
    assert nu.norm() == 3
    assert OK(1, 1).norm() == 5
    assert OK(5, 0).norm() == 25

    assert represented(1)
    assert not represented(2)
    assert represented(3)
    assert represented(5)

    # Classification consistency: identity, degree two, and clean iterates.
    assert OK(1, 0).norm() == 1
    assert not represented(2)
    for u in (nu, OK(1, 1), OK(2, 1), OK(3, -1)):
        delta = u.norm()
        for m in range(1, 9):
            assert (u**m).norm() == delta**m

    # The elliptic multiplier [-5] is the scalar -5, so its norm is 25.
    assert OK(-5, 0).norm() == 25
    assert OK(-5, 0).norm() != 5

    represented_through_40 = [n for n in range(1, 41) if represented(n)]
    print("CM_NORM_FORM=x^2+x*y+3*y^2")
    print("REPRESENTED_THROUGH_40=" + ",".join(map(str, represented_through_40)))
    print("CHECK_2=NOT_REPRESENTED")
    print("CHECK_3=REPRESENTED_BY_(-1,1)")
    print("CHECK_5=REPRESENTED_BY_(1,1)")
    print("ELLIPTIC_MINUS5_SCALAR_NORM=25")
    print("CLASSIFICATION_CONSISTENCY=PASS")
    print("CLEAN_ITERATE_NORMS=PASS")


if __name__ == "__main__":
    main()
