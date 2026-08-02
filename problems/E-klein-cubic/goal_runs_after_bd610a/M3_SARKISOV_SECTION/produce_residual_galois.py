#!/usr/bin/env python3
"""Produce the residual-Galois certificate for M3.

The group is PSL_2(F_11), represented by determinant-one 2x2 matrices modulo
its central signs.  The 55 involutions form the transitive G-set G/D_12 that
labels the installed involution-line multisection.
"""
from __future__ import annotations

from collections import Counter, deque
from itertools import combinations
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
OUT = HERE / "residual_galois.json"

F2 = tuple[int, int, int, int]


def mul(a: F2, b: F2) -> F2:
    return tuple(
        sum(a[2 * i + k] * b[2 * k + j] for k in range(2)) % 11
        for i in range(2)
        for j in range(2)
    )  # type: ignore[return-value]


def canon(a) -> F2:
    pos = tuple(int(x) % 11 for x in a)
    neg = tuple((-x) % 11 for x in pos)
    return min(pos, neg)  # type: ignore[return-value]


def inv(a: F2) -> F2:
    return canon((a[3], -a[1], -a[2], a[0]))


ONE = canon((1, 0, 0, 1))
S = canon((0, 2, 5, 0))
T = canon((1, 2, 0, 1))


def enumerate_group() -> list[F2]:
    seen = {ONE}
    queue = deque([ONE])
    while queue:
        a = queue.popleft()
        for b in (S, T):
            c = canon(mul(a, b))
            if c not in seen:
                seen.add(c)
                queue.append(c)
    group = sorted(seen)
    assert len(group) == 660
    return group


def order(a: F2) -> int:
    x = ONE
    for n in range(1, 100):
        x = canon(mul(x, a))
        if x == ONE:
            return n
    raise AssertionError("order bound exceeded")


def conjugate(g: F2, x: F2) -> F2:
    return canon(mul(mul(g, x), inv(g)))


def subgroup_generated(generators: set[F2]) -> set[F2]:
    gens = set(generators)
    gens |= {inv(g) for g in gens}
    out = {ONE}
    queue = deque([ONE])
    while queue:
        a = queue.popleft()
        for b in gens:
            c = canon(mul(a, b))
            if c not in out:
                out.add(c)
                queue.append(c)
    return out


def orbits(points, generators, action):
    unseen = set(points)
    answer = []
    while unseen:
        seed = min(unseen)
        orbit = {seed}
        queue = deque([seed])
        while queue:
            x = queue.popleft()
            for g in generators:
                y = action(g, x)
                if y not in orbit:
                    orbit.add(y)
                    queue.append(y)
        unseen -= orbit
        answer.append(sorted(orbit))
    return answer


def digest(value) -> str:
    raw = json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(raw).hexdigest()


def build_payload() -> dict:
    group = enumerate_group()
    by_order = Counter(order(g) for g in group)
    involutions = sorted(g for g in group if order(g) == 2)
    assert len(involutions) == 55

    chosen = involutions[0]
    centralizer = sorted(g for g in group if canon(mul(g, chosen)) == canon(mul(chosen, g)))
    assert len(centralizer) == 12
    assert Counter(order(g) for g in centralizer) == {1: 1, 2: 7, 3: 2, 6: 2}

    index = {x: i for i, x in enumerate(involutions)}
    permutations = {}
    for name, generator in (("S", S), ("T", T)):
        permutations[name] = [index[conjugate(generator, x)] for x in involutions]
        assert len(set(permutations[name])) == 55

    def permute_point(name, i):
        return permutations[name][i]

    # H-subdegrees in the 55-point action.
    h_permutations = []
    for h in centralizer:
        h_permutations.append([index[conjugate(h, x)] for x in involutions])
    unseen = set(range(55))
    h_orbits = []
    while unseen:
        seed = min(unseen)
        orbit = {seed}
        queue = deque([seed])
        while queue:
            i = queue.popleft()
            for perm in h_permutations:
                j = perm[i]
                if j not in orbit:
                    orbit.add(j)
                    queue.append(j)
        unseen -= orbit
        h_orbits.append(sorted(orbit))
    subdegrees = sorted(len(o) for o in h_orbits)
    assert subdegrees == [1, 3, 3, 6, 6, 6, 6, 12, 12]

    # Full G-orbits on unordered pairs and triples of the 55 points.
    pair_points = list(combinations(range(55), 2))
    pair_orbits = orbits(
        pair_points,
        ("S", "T"),
        lambda name, pair: tuple(sorted((permute_point(name, pair[0]), permute_point(name, pair[1])))),
    )
    pair_sizes = sorted(len(o) for o in pair_orbits)
    assert pair_sizes == [165, 165, 165, 330, 330, 330]

    triple_points = list(combinations(range(55), 3))
    triple_orbits = orbits(
        triple_points,
        ("S", "T"),
        lambda name, triple: tuple(sorted(permute_point(name, i) for i in triple)),
    )
    triple_hist = dict(sorted(Counter(len(o) for o in triple_orbits).items()))

    # Direct computational simplicity certificate: the normal closure of one
    # representative of every nontrivial conjugacy class is the full group.
    conjugacy_orbits = orbits(group, (S, T), lambda g, x: conjugate(g, x))
    class_data = []
    for cls in conjugacy_orbits:
        rep = cls[0]
        if rep == ONE:
            continue
        normal_closure = subgroup_generated(set(cls))
        assert len(normal_closure) == 660
        class_data.append({
            "representative": list(rep),
            "element_order": order(rep),
            "class_size": len(cls),
            "normal_closure_order": len(normal_closure),
        })

    payload = {
        "schema": "m3-residual-galois-v1",
        "group": "PSL_2(F_11)",
        "group_order": len(group),
        "element_order_histogram": {str(k): v for k, v in sorted(by_order.items())},
        "simple_certificate": {
            "nonidentity_conjugacy_classes": class_data,
            "conclusion": "every nonidentity normal closure is the full group",
        },
        "line_cover": {
            "points": 55,
            "model": "conjugacy class of involutions = G/C_G(t)",
            "chosen_involution": list(chosen),
            "stabilizer_order": len(centralizer),
            "stabilizer_order_histogram": {
                str(k): v for k, v in sorted(Counter(order(g) for g in centralizer).items())
            },
            "stabilizer_type": "D12",
            "subdegrees": subdegrees,
            "permutation_digest": digest(permutations),
        },
        "pair_orbits": [
            {"seed": list(orbit[0]), "size": len(orbit), "digest": digest(orbit)}
            for orbit in pair_orbits
        ],
        "pair_orbit_sizes": pair_sizes,
        "triple_orbit_histogram": {str(k): v for k, v in triple_hist.items()},
        "index_four": {
            "exists": False,
            "proof": (
                "an index-four subgroup gives a transitive homomorphism G->S4; "
                "simplicity makes the kernel trivial or all of G, while an injection "
                "is impossible because 660>24"
            ),
        },
        "arithmetic_conclusion": {
            "line_splitting_field": "E(q)/K(q) with Gal=G",
            "quartic_subfield_in_line_splitting_field": False,
            "meaning": (
                "a degree-four point supplied by the section-or-quartic theorem, "
                "if the section branch fails, cannot have residue field contained in E(q)"
            ),
        },
    }
    return payload


if __name__ == "__main__":
    payload = build_payload()
    OUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("WROTE", OUT.name)
    print("M3_RESIDUAL_GALOIS_PRODUCER_OK")
