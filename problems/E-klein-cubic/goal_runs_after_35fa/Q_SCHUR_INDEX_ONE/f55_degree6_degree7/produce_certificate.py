#!/usr/bin/env python3
"""Produce an exact support certificate for degree-6 and degree-7 F55 covariants.

Everything is computed in the split good fibre F_331.  A degree-d covariant
is determined by its weight-one first coordinate; the other coordinates are
cyclic translates, with any of the five projective C5 characters.
"""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

P = 331
WEIGHTS = (1, 9, 4, 3, 5)
HERE = Path(__file__).resolve().parent


def compositions(total: int, length: int):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for tail in compositions(total - first, length - 1):
            yield (first,) + tail


def rotate(e, amount):
    out = [0] * 5
    for i, a in enumerate(e):
        out[(i + amount) % 5] = a
    return tuple(out)


def add3(a, b, c):
    return tuple(x + y + z for x, y, z in zip(a, b, c))


def basis(degree):
    return tuple(
        e for e in compositions(degree, 5)
        if sum(a * w for a, w in zip(e, WEIGHTS)) % 11 == 1
    )


def equations(degree, character):
    monomials = basis(degree)
    root5 = next(a for a in range(2, P) if pow(a, 5, P) == 1 and a != 1)
    scales = [pow(root5, character * i, P) for i in range(5)]
    result = {}
    for i in range(5):
        left = [rotate(e, i) for e in monomials]
        right = [rotate(e, i + 1) for e in monomials]
        scalar = scales[i] * scales[i] * scales[(i + 1) % 5] % P
        for a, ea in enumerate(left):
            for b, eb in enumerate(left):
                for c, ec in enumerate(right):
                    source = add3(ea, eb, ec)
                    term = tuple(sorted((a, b, c)))
                    poly = result.setdefault(source, {})
                    poly[term] = (poly.get(term, 0) + scalar) % P
    return monomials, {
        source: {term: value for term, value in poly.items() if value}
        for source, poly in result.items()
        if any(poly.values())
    }


def term_mask(term):
    return sum(1 << i for i in set(term))


def support_digest(eqs):
    h = hashlib.sha256()
    for source in sorted(eqs):
        h.update((str(source) + ":" + str(sorted(eqs[source])) + "\n").encode())
    return h.hexdigest()


def masked_equations(eqs):
    return [
        (source, [(term_mask(term), term, value) for term, value in sorted(poly.items())])
        for source, poly in sorted(eqs.items())
    ]


def singleton_witness(masked, support):
    for source, terms in masked:
        active = []
        for record in terms:
            if record[0] & support == record[0]:
                active.append(record)
                if len(active) > 1:
                    break
        if len(active) == 1:
            return source, active[0]
    return None


def maximal_no_singleton_supports(masked, number_variables):
    """Deletion tree covering every support with no singleton equation."""
    seen = set()
    leaves = []

    def visit(support):
        if support in seen:
            return
        seen.add(support)
        witness = singleton_witness(masked, support)
        if witness is None:
            if support:
                leaves.append(support)
            return
        _, (_, term, _) = witness
        # At least one distinct variable in the active monomial must vanish.
        for variable in sorted(set(term)):
            visit(support & ~(1 << variable))

    visit((1 << number_variables) - 1)
    return sorted(set(leaves)), len(seen)


def all_no_singleton_subsupports(masked, leaves):
    supports = set()
    for leaf in leaves:
        variables = [i for i in range(leaf.bit_length()) if leaf >> i & 1]
        for local in range(1, 1 << len(variables)):
            support = sum(
                1 << variables[j] for j in range(len(variables)) if local >> j & 1
            )
            if singleton_witness(masked, support) is None:
                supports.add(support)
    return sorted(supports)


def exponent_vector(term, number_variables):
    out = [0] * number_variables
    for i in term:
        out[i] += 1
    return out


def canonical_binomial(term1, coeff1, term2, coeff2, number_variables):
    row = tuple(
        a - b for a, b in zip(
            exponent_vector(term1, number_variables),
            exponent_vector(term2, number_variables),
        )
    )
    rhs = (-coeff2 * pow(coeff1, -1, P)) % P
    first = next(x for x in row if x)
    if first < 0:
        row = tuple(-x for x in row)
        rhs = pow(rhs, -1, P)
    return row, rhs


def binomial_collision(eqs, support, number_variables):
    """Find two equations imposing c^row=r1 and c^row=r2, r1!=r2."""
    prior = {}
    for source, poly in sorted(eqs.items()):
        active = [
            (term, coeff) for term, coeff in sorted(poly.items())
            if term_mask(term) & support == term_mask(term)
        ]
        if len(active) != 2:
            continue
        (term1, coeff1), (term2, coeff2) = active
        row, rhs = canonical_binomial(
            term1, coeff1, term2, coeff2, number_variables
        )
        record = {
            "source": list(source),
            "terms": [list(term1), list(term2)],
            "coefficients_mod_331": [coeff1, coeff2],
            "canonical_row": list(row),
            "rhs_mod_331": rhs,
        }
        if row in prior and prior[row]["rhs_mod_331"] != rhs:
            return {"first": prior[row], "second": record}
        prior[row] = record
    return None


def main():
    all_equations = {}
    term_hashes = {}
    for degree in (6, 7):
        all_equations[degree] = {}
        term_hashes[degree] = {}
        for character in range(5):
            monomials, eqs = equations(degree, character)
            all_equations[degree][character] = eqs
            term_hashes[degree][character] = support_digest(eqs)
        assert len(set(term_hashes[degree].values())) == 1

    b6 = basis(6)
    masked6 = masked_equations(all_equations[6][0])
    h6 = hashlib.sha256()
    singleton_count = 0
    for support in range(1, 1 << len(b6)):
        witness = singleton_witness(masked6, support)
        assert witness is not None
        source, (_, term, coeff) = witness
        h6.update(f"{support}|{source}|{term}|{coeff}\n".encode())
        singleton_count += 1

    b7 = basis(7)
    masked7 = masked_equations(all_equations[7][0])
    leaves, deletion_nodes = maximal_no_singleton_supports(masked7, len(b7))
    supports7 = all_no_singleton_subsupports(masked7, leaves)
    contradictions = []
    for character in range(5):
        eqs = all_equations[7][character]
        for support in supports7:
            collision = binomial_collision(eqs, support, len(b7))
            assert collision is not None
            contradictions.append({
                "character_mod_5": character,
                "support_mask": support,
                "support_indices": [i for i in range(len(b7)) if support >> i & 1],
                "collision": collision,
            })

    payload = {
        "schema": "klein-f55-degree6-degree7-support-certificate-v1",
        "field": {"prime": P, "primitive_fifth_root": 64, "prime_mod_55": P % 55},
        "normal_form": {
            "c11_weights": list(WEIGHTS),
            "c5_action": "cyclic shift",
            "klein_cubic": "sum_i q_i^2*q_(i+1)",
        },
        "degree6": {
            "coefficient_dimension": len(b6),
            "equation_count": len(all_equations[6][0]),
            "equation_term_count": sum(len(p) for p in all_equations[6][0].values()),
            "term_support_hashes_by_character": term_hashes[6],
            "nonempty_supports_checked": singleton_count,
            "expected_nonempty_supports": (1 << len(b6)) - 1,
            "singleton_witness_digest": h6.hexdigest(),
            "conclusion": "every nonzero coefficient support has a singleton landing equation",
        },
        "degree7": {
            "coefficient_dimension": len(b7),
            "equation_count": len(all_equations[7][0]),
            "equation_term_count": sum(len(p) for p in all_equations[7][0].values()),
            "term_support_hashes_by_character": term_hashes[7],
            "deletion_tree_nodes": deletion_nodes,
            "covering_leaf_masks": leaves,
            "covering_leaf_indices": [
                [i for i in range(len(b7)) if leaf >> i & 1] for leaf in leaves
            ],
            "no_singleton_support_count": len(supports7),
            "no_singleton_support_masks": supports7,
            "binomial_collision_count": len(contradictions),
            "binomial_collisions": contradictions,
            "conclusion": "all no-singleton supports have incompatible binomial landing equations for every character",
        },
        "global_conclusion": (
            "All five projective-character homogeneous 11:5 covariant landing "
            "schemes are empty in degrees 6 and 7 over algebraic closure of F_331."
        ),
        "scope": [
            "complete in coefficient space in degrees 6 and 7",
            "not an all-degree exclusion",
            "not a pointlessness theorem for the generic 11:5 twist",
        ],
    }
    output = HERE / "certificate.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("WROTE", output)
    print("D6_SUPPORTS", singleton_count, "D6_SINGLETON_DIGEST", h6.hexdigest())
    print("D7_LEAVES", leaves, "D7_SUPPORTS", len(supports7))
    print("D7_BINOMIAL_COLLISIONS", len(contradictions))
    print("F55_DEGREE6_DEGREE7_SUPPORT_CERTIFICATE_OK")


if __name__ == "__main__":
    main()
