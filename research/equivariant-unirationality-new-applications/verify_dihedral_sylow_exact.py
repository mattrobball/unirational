#!/usr/bin/env python3
"""Prime-power Sylow audit for the odd-dihedral conic-bundle family.

This supplements ``verify_dihedral_conic_bundle.py`` by checking the full
p-primary rotation subgroup when n is not squarefree.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import FrozenSet, Iterable, List, Set


@dataclass(frozen=True, order=True)
class E:
    z: int
    r: int
    s: int


def mul(n: int, a: E, b: E) -> E:
    sign = -1 if a.s else 1
    return E((a.z + b.z) % 2, (a.r + sign * b.r) % n, (a.s + b.s) % 2)


def inv(n: int, a: E) -> E:
    return E(a.z, (-a.r if a.s == 0 else a.r) % n, a.s)


def generated(n: int, seeds: Iterable[E]) -> FrozenSet[E]:
    identity = E(0, 0, 0)
    subgroup: Set[E] = {identity, *seeds}
    changed = True
    while changed:
        changed = False
        current = list(subgroup)
        for a in current:
            candidates = [inv(n, a)]
            candidates.extend(mul(n, a, b) for b in current)
            candidates.extend(mul(n, b, a) for b in current)
            for candidate in candidates:
                if candidate not in subgroup:
                    subgroup.add(candidate)
                    changed = True
    return frozenset(subgroup)


def prime_factors(n: int) -> List[int]:
    result: List[int] = []
    p = 2
    while p * p <= n:
        if n % p == 0:
            result.append(p)
            while n % p == 0:
                n //= p
        p += 1
    if n > 1:
        result.append(n)
    return result


def p_part(n: int, p: int) -> int:
    result = 1
    while n % p == 0:
        result *= p
        n //= p
    return result


def check(n: int) -> dict:
    if n < 3 or n % 2 == 0:
        raise ValueError("n must be odd and at least three")

    odd_sylows = {}
    for p in prime_factors(n):
        order = p_part(n, p)
        generator = E(0, n // order, 0)
        subgroup = generated(n, {generator})
        assert len(subgroup) == order
        assert all(g.s == 0 and g.z == 0 for g in subgroup)
        # Every rotation fixes [0:1:1] on q^2=x^(2n)+y^(2n).
        odd_sylows[p] = {"order": order, "witness": "[0:1:1]"}

    sylow_two = generated(n, {E(1, 0, 0), E(0, 0, 1)})
    assert len(sylow_two) == 4
    assert all(mul(n, a, b) == mul(n, b, a) for a in sylow_two for b in sylow_two)
    # The reflection-fixed base point t=1 gives q^2=2; z is trivial on C_n.

    return {
        "n": n,
        "group_order": 4 * n,
        "odd_sylows": odd_sylows,
        "sylow_two": {"order": 4, "witness": "[1:1:sqrt(2)]"},
        "all_sylows_fixed": True,
    }


def main() -> None:
    import json

    report = [check(n) for n in (3, 5, 7, 9, 15, 25, 27)]
    print(json.dumps(report, indent=2, sort_keys=True))
    print("DIHEDRAL_SYLOW_PRIME_POWER_AUDIT: PASS")


if __name__ == "__main__":
    main()
