#!/usr/bin/env python3
"""Independent replay of the F55 degree-6/7 coefficient-support certificate."""
from __future__ import annotations

import hashlib
from itertools import product
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
P = 331
W = (1, 9, 4, 3, 5)


def monomial_basis(degree):
    # Independent enumeration: a Cartesian box filtered by degree and C11 weight.
    return tuple(
        e for e in product(range(degree + 1), repeat=5)
        if sum(e) == degree and sum(a * w for a, w in zip(e, W)) % 11 == 1
    )


def translated(e, step):
    # Pull the exponent on x_j to x_(j+step).
    return tuple(e[(j - step) % 5] for j in range(5))


def add_exponents(a, b, c):
    return tuple(a[j] + b[j] + c[j] for j in range(5))


def expand_landing(degree, character):
    B = monomial_basis(degree)
    zeta = 64
    assert pow(zeta, 5, P) == 1 and zeta != 1
    coordinates = []
    for i in range(5):
        scalar = pow(zeta, character * i, P)
        coordinates.append([(translated(e, i), index, scalar) for index, e in enumerate(B)])
    landing = {}
    for i in range(5):
        for ea, a, sa in coordinates[i]:
            for eb, b, sb in coordinates[i]:
                for ec, c, sc in coordinates[(i + 1) % 5]:
                    source = add_exponents(ea, eb, ec)
                    coefficient_monomial = tuple(sorted((a, b, c)))
                    poly = landing.setdefault(source, {})
                    poly[coefficient_monomial] = (
                        poly.get(coefficient_monomial, 0) + sa * sb * sc
                    ) % P
    return B, {
        source: {term: a for term, a in poly.items() if a}
        for source, poly in landing.items() if any(poly.values())
    }


def mask(term):
    value = 0
    for index in term:
        value |= 1 << index
    return value


def support_hash(equations):
    h = hashlib.sha256()
    for source in sorted(equations):
        h.update((str(source) + ":" + str(sorted(equations[source])) + "\n").encode())
    return h.hexdigest()


_ORDER_CACHE = {}


def first_singleton(equations, support, reverse=False):
    key = (id(equations), reverse)
    items = _ORDER_CACHE.get(key)
    if items is None:
        items = [
            (source, sorted(poly.items(), reverse=reverse))
            for source, poly in sorted(equations.items(), reverse=reverse)
        ]
        _ORDER_CACHE[key] = items
    for source, terms in items:
        only = None
        count = 0
        for term, coeff in terms:
            if mask(term) & support == mask(term):
                count += 1
                only = (term, coeff)
                if count > 1:
                    break
        if count == 1:
            return source, only
    return None


def independent_cover(equations, n):
    # Different branching heuristic from the producer: inspect equations and
    # terms in reverse order, and delete coefficient indices in reverse order.
    visited = set()
    leaves = []
    def walk(support):
        if support in visited:
            return
        visited.add(support)
        witness = first_singleton(equations, support, reverse=True)
        if witness is None:
            if support:
                leaves.append(support)
            return
        term = witness[1][0]
        for index in sorted(set(term), reverse=True):
            walk(support & ~(1 << index))
    walk((1 << n) - 1)
    return sorted(set(leaves)), len(visited)


def vector(term, n):
    answer = [0] * n
    for i in term:
        answer[i] += 1
    return answer


def normalized_relation(term1, a1, term2, a2, n):
    row = tuple(x - y for x, y in zip(vector(term1, n), vector(term2, n)))
    rhs = -a2 * pow(a1, -1, P) % P
    if next(x for x in row if x) < 0:
        row = tuple(-x for x in row)
        rhs = pow(rhs, -1, P)
    return row, rhs


def verify_collision(record, equations, support, n):
    normalized = []
    for side_name in ("first", "second"):
        side = record[side_name]
        source = tuple(side["source"])
        terms = [tuple(t) for t in side["terms"]]
        coefficients = side["coefficients_mod_331"]
        assert source in equations
        active = [
            (term, coeff) for term, coeff in sorted(equations[source].items())
            if mask(term) & support == mask(term)
        ]
        assert active == list(zip(terms, coefficients))
        assert len(active) == 2
        row, rhs = normalized_relation(
            terms[0], coefficients[0], terms[1], coefficients[1], n
        )
        assert list(row) == side["canonical_row"]
        assert rhs == side["rhs_mod_331"]
        normalized.append((row, rhs))
    assert normalized[0][0] == normalized[1][0]
    assert normalized[0][1] != normalized[1][1]


def main():
    data = json.loads((HERE / "certificate.json").read_text())
    assert data["schema"] == "klein-f55-degree6-degree7-support-certificate-v1"
    assert data["field"] == {"prime": 331, "prime_mod_55": 1, "primitive_fifth_root": 64}
    assert all(W[(i + 1) % 5] == -2 * W[i] % 11 for i in range(5))

    expanded = {6: {}, 7: {}}
    for degree in (6, 7):
        for character in range(5):
            B, equations = expand_landing(degree, character)
            expanded[degree][character] = equations
            stored_hash = data[f"degree{degree}"]["term_support_hashes_by_character"][str(character)]
            assert support_hash(equations) == stored_hash
        assert len({support_hash(e) for e in expanded[degree].values()}) == 1

    # Exhaustive degree-six replay over all 524287 nonzero supports.
    B6 = monomial_basis(6)
    equations6 = expanded[6][0]
    assert len(B6) == data["degree6"]["coefficient_dimension"] == 19
    assert len(equations6) == data["degree6"]["equation_count"] == 640
    h6 = hashlib.sha256()
    count = 0
    for support in range(1, 1 << len(B6)):
        witness = first_singleton(equations6, support)
        assert witness is not None
        source, (term, coeff) = witness
        h6.update(f"{support}|{source}|{term}|{coeff}\n".encode())
        count += 1
    assert count == data["degree6"]["nonempty_supports_checked"] == 524287
    assert h6.hexdigest() == data["degree6"]["singleton_witness_digest"]

    # Independently cover every degree-seven no-singleton support.
    B7 = monomial_basis(7)
    equations7 = expanded[7][0]
    assert len(B7) == data["degree7"]["coefficient_dimension"] == 30
    assert len(equations7) == data["degree7"]["equation_count"] == 1125
    leaves, nodes = independent_cover(equations7, len(B7))
    stored_leaf = data["degree7"]["covering_leaf_masks"]
    # The node count is heuristic-dependent and intentionally need not match.
    assert nodes > 0 and data["degree7"]["deletion_tree_nodes"] > 0
    candidates = set()
    # Different deletion orders can produce different covering leaves.  What
    # is canonical is the union of their no-singleton subsupports.
    for leaf in leaves:
        indices = [i for i in range(len(B7)) if leaf >> i & 1]
        for local in range(1, 1 << len(indices)):
            support = sum(
                1 << indices[j] for j in range(len(indices)) if local >> j & 1
            )
            if first_singleton(equations7, support) is None:
                candidates.add(support)
    candidates = sorted(candidates)
    assert candidates == data["degree7"]["no_singleton_support_masks"]
    # Also verify the producer's leaves cover the same canonical set.
    producer_candidates = set()
    for leaf in stored_leaf:
        indices = [i for i in range(len(B7)) if leaf >> i & 1]
        for local in range(1, 1 << len(indices)):
            support = sum(1 << indices[j] for j in range(len(indices)) if local >> j & 1)
            if first_singleton(equations7, support) is None:
                producer_candidates.add(support)
    assert sorted(producer_candidates) == candidates
    assert len(candidates) == data["degree7"]["no_singleton_support_count"] == 32

    records = data["degree7"]["binomial_collisions"]
    assert len(records) == data["degree7"]["binomial_collision_count"] == 160
    keyed = {(r["character_mod_5"], r["support_mask"]): r for r in records}
    assert set(keyed) == {(k, s) for k in range(5) for s in candidates}
    for (character, support), record in keyed.items():
        assert record["support_indices"] == [i for i in range(len(B7)) if support >> i & 1]
        verify_collision(record["collision"], expanded[7][character], support, len(B7))

    print("PASS independent cyclic-weight basis and complete landing expansion")
    print("PASS 524287/524287 degree-six supports have singleton equations")
    print("PASS independent degree-seven deletion tree covers all supports")
    print("PASS exactly 32 no-singleton supports and 160 incompatible binomial pairs")
    print("F55_DEGREE6_DEGREE7_CERTIFICATE_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
