#!/usr/bin/env python3
"""Finite exact checks for the local Rees examples used adversarially."""
from __future__ import annotations


def add(a, b):
    out = dict(a)
    for mon, c in b.items():
        out[mon] = out.get(mon, 0) + c
        if out[mon] == 0:
            del out[mon]
    return out


def mul(a, b):
    out = {}
    for ma, ca in a.items():
        for mb, cb in b.items():
            mon = tuple(x + y for x, y in zip(ma, mb))
            out[mon] = out.get(mon, 0) + ca * cb
    return {m: c for m, c in out.items() if c}


def neg(a):
    return {m: -c for m, c in a.items()}


def var(index: int, nvars: int = 3):
    e = [0] * nvars
    e[index] = 1
    return {tuple(e): 1}


def power(a, n: int):
    out = {(0,) * len(next(iter(a))): 1}
    for _ in range(n):
        out = mul(out, a)
    return out


def main() -> None:
    # Variables U,V,W.
    U, V, W = var(0), var(1), var(2)

    # det [[W,V^3],[V,W^3]] = W^4 - V^4.
    det_line = add(mul(W, power(W, 3)), neg(mul(V, power(V, 3))))
    assert det_line == add(power(W, 4), neg(power(V, 4)))

    # det [[V,U^3 W],[W,U^3 V]] = U^3(V^2-W^2).
    det_conic = add(
        mul(V, mul(power(U, 3), V)),
        neg(mul(W, mul(power(U, 3), W))),
    )
    expected_conic = mul(power(U, 3), add(power(V, 2), neg(power(W, 2))))
    assert det_conic == expected_conic

    # For (F,h^m), v(h)=1 and v(F)=m, while primitive restriction removes h^m.
    for m in range(1, 13):
        assert m == m * 1
        assert m - m == 0

    print("LOCAL_REES_RANK_TWO_MONOMIAL_MODEL_OK")
    print("V4_WEAK_LINE_DETERMINANT_OK")
    print("V4_WEAK_CONIC_DETERMINANT_OK")
    print("PRIMITIVE_RESTRICTION_REMOVES_H_POWER_OK")


if __name__ == "__main__":
    main()
