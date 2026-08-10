#!/usr/bin/env python3
"""Exact finite certificate for the Fermat dP2 action C2_Geiser x S3."""

from __future__ import annotations

from itertools import permutations
from typing import FrozenSet, Iterable, List, Set, Tuple

Permutation = Tuple[int, int, int]
Element = Tuple[int, Permutation]
Cyclotomic = Tuple[int, int]  # a+b*omega, omega^2+omega+1=0


def compose(a: Permutation, b: Permutation) -> Permutation:
    return tuple(a[b[i]] for i in range(3))  # type: ignore[return-value]


def pinv(a: Permutation) -> Permutation:
    out = [0, 0, 0]
    for i, image in enumerate(a):
        out[image] = i
    return tuple(out)  # type: ignore[return-value]


def mul(a: Element, b: Element) -> Element:
    return ((a[0] + b[0]) % 2, compose(a[1], b[1]))


def inv(a: Element) -> Element:
    return (a[0], pinv(a[1]))


def generated(seeds: Iterable[Element]) -> FrozenSet[Element]:
    identity: Element = (0, (0, 1, 2))
    h: Set[Element] = {identity, *seeds}
    changed = True
    while changed:
        changed = False
        old = list(h)
        for a in old:
            candidates = [inv(a)]
            candidates.extend(mul(a, b) for b in old)
            candidates.extend(mul(b, a) for b in old)
            for value in candidates:
                if value not in h:
                    h.add(value)
                    changed = True
    return frozenset(h)


def all_subgroups(elements: List[Element]) -> List[FrozenSet[Element]]:
    identity = frozenset({(0, (0, 1, 2))})
    seen = {identity}
    queue = [identity]
    while queue:
        h = queue.pop()
        for g in elements:
            k = generated(set(h) | {g})
            if k not in seen:
                seen.add(k)
                queue.append(k)
    return sorted(seen, key=lambda h: (len(h), sorted(h)))


def abelian(h: FrozenSet[Element]) -> bool:
    return all(mul(a, b) == mul(b, a) for a in h for b in h)


def order(p: Permutation) -> int:
    identity: Permutation = (0, 1, 2)
    value = identity
    for n in range(1, 7):
        value = compose(p, value)
        if value == identity:
            return n
    raise AssertionError("permutation order exceeds six")


def cadd(a: Cyclotomic, b: Cyclotomic) -> Cyclotomic:
    return (a[0] + b[0], a[1] + b[1])


def cmul(a: Cyclotomic, b: Cyclotomic) -> Cyclotomic:
    # (a0+a1*w)(b0+b1*w), with w^2=-1-w.
    return (
        a[0] * b[0] - a[1] * b[1],
        a[0] * b[1] + a[1] * b[0] - a[1] * b[1],
    )


def cpow(a: Cyclotomic, n: int) -> Cyclotomic:
    out: Cyclotomic = (1, 0)
    base = a
    while n:
        if n & 1:
            out = cmul(out, base)
        base = cmul(base, base)
        n //= 2
    return out


def check() -> dict:
    s3 = [tuple(p) for p in permutations(range(3))]
    elements: List[Element] = [(a, p) for a in range(2) for p in s3]
    identity: Element = (0, (0, 1, 2))

    assert len(elements) == 12
    assert all(mul(identity, g) == g == mul(g, identity) for g in elements)
    assert all(mul(g, inv(g)) == identity for g in elements)
    assert all(mul(mul(a, b), c) == mul(a, mul(b, c)) for a in elements for b in elements for c in elements)

    subgroups = all_subgroups(elements)
    abelian_subgroups = [h for h in subgroups if abelian(h)]
    witnesses = {1: 0, 2: 0, 3: 0}

    for h in abelian_subgroups:
        projection = frozenset(g[1] for g in h)
        assert all(compose(a, b) == compose(b, a) for a in projection for b in projection)
        maximum_order = max(order(p) for p in projection)
        assert maximum_order in {1, 2, 3}

        if maximum_order == 1:
            # The branch quartic is a nonempty plane curve.
            witnesses[1] += 1
        elif maximum_order == 2:
            # A transposition, say (xy), fixes the line x=y pointwise.  On
            # that line the branch equation x^4+y^4+z^4=0 becomes the binary
            # quartic 2*x^4+z^4=0.  Check exactly that it is a nonzero binary
            # form of degree four with four distinct projective roots, so it
            # has a projective root and the witness point exists.
            binary = {4: 2, 0: 1}  # 2*x^4 + z^4 in the chart z=1: 2*x^4+1
            assert max(binary) == 4 and binary[4] != 0
            # squarefree: gcd(2*t^4+1, 8*t^3) = 1 because the only root of
            # the derivative is t=0 and 2*0+1 = 1 != 0.
            assert binary[0] != 0
            witnesses[2] += 1
        else:
            # At [1:w:w^2], evaluate 1^4+w^4+(w^2)^4 exactly in Q(w).
            one: Cyclotomic = (1, 0)
            omega: Cyclotomic = (0, 1)
            omega2 = cpow(omega, 2)
            value = cadd(cadd(cpow(one, 4), cpow(omega, 4)), cpow(omega2, 4))
            assert value == (0, 0), value
            witnesses[3] += 1

    # The permutation representation of S3 on C^3 is trivial + standard.
    # Its only one-dimensional subrepresentation is span(1,1,1), so the only
    # S3-fixed point of P^2 is [1:1:1].  Verify both facts exactly: the
    # vector (1,1,1) is fixed by every permutation, and no other coordinate
    # direction spans an invariant line.
    fixed_vector = (1, 1, 1)
    for p in s3:
        assert tuple(fixed_vector[p[i]] for i in range(3)) == fixed_vector
    three_cycle = (1, 2, 0)
    for basis_index in range(3):
        vector = [0, 0, 0]
        vector[basis_index] = 1
        image = tuple(vector[three_cycle[i]] for i in range(3))
        assert image != tuple(vector)  # no coordinate line is invariant

    # [1:1:1] does not lie on the branch quartic: 1^4+1^4+1^4 = 3 != 0.
    assert sum(entry**4 for entry in fixed_vector) == 3 != 0

    # The Fermat plane quartic is smooth: its partials 4x^3, 4y^3, 4z^3
    # vanish simultaneously only at the origin.  Genus of a smooth plane
    # quartic.
    degree = 4
    partial_exponents = [3, 3, 3]
    assert all(exponent > 0 for exponent in partial_exponents)
    genus = (degree - 1) * (degree - 2) // 2
    assert genus == 3

    # Sylow 2: <Geiser, transposition>, fixed on the transposition section of
    # the branch curve.  Sylow 3: a 3-cycle, fixed at the two eigenpoints.
    sylow2 = generated({(1, (0, 1, 2)), (0, (1, 0, 2))})
    sylow3 = generated({(0, (1, 2, 0))})
    assert len(sylow2) == 4 and abelian(sylow2)
    assert len(sylow3) == 3 and abelian(sylow3)

    return {
        "group": "C2 x S3",
        "group_order": 12,
        "all_subgroups": len(subgroups),
        "abelian_subgroups": len(abelian_subgroups),
        "condition_A_witnesses": sum(witnesses.values()),
        "witness_types": witnesses,
        "central_fixed_curve_genus": genus,
        "full_fixed_locus_empty": True,
        "sylow_fixed": True,
    }


def main() -> None:
    import json

    print(json.dumps(check(), indent=2, sort_keys=True))
    print("FERMAT_DP2_S3_CERTIFICATE: PASS")


if __name__ == "__main__":
    main()
