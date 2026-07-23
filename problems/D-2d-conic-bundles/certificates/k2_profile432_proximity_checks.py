#!/usr/bin/env python3
"""Exact proximity/parity census for the squarefree k=2 profile [4,3,2]."""

from collections import Counter
from itertools import permutations, product


ESSENTIAL = (4, 3, 2)


def ordered_proximity_diagrams(size):
    """Generate chronological Enriques diagrams on ``range(size)``.

    A nonroot point is free over its immediate predecessor, or satellite to
    that predecessor and one exceptional through it.  Two satellite points
    cannot blow up the same exceptional intersection.
    """

    parent = [None] * size
    proximate = [()] * size

    def recurse(index):
        if index == size:
            satellite_pairs = [
                tuple(sorted(parents))
                for parents in proximate
                if len(parents) == 2
            ]
            if len(satellite_pairs) == len(set(satellite_pairs)):
                yield tuple(parent), tuple(proximate)
            return

        parent[index] = None
        proximate[index] = ()
        yield from recurse(index + 1)

        for predecessor in range(index):
            parent[index] = predecessor
            proximate[index] = (predecessor,)
            yield from recurse(index + 1)

            for older in proximate[predecessor]:
                proximate[index] = (predecessor, older)
                yield from recurse(index + 1)

    yield from recurse(0)


def lies_in_essential_span(labels, parent):
    ancestors = set()
    for essential in ESSENTIAL:
        node = essential
        while parent[node] is not None:
            node = parent[node]
            ancestors.add(node)
    return all(label in ESSENTIAL or label in ancestors for label in labels)


def enumerate_realizations(negligible_count, deduplicate=True):
    negligible = tuple(-index for index in range(1, negligible_count + 1))
    labels = ESSENTIAL + negligible
    size = len(labels)
    realizations = {}
    raw_count = 0

    for chronological_labels in permutations(labels):
        for raw_parent, raw_proximate in ordered_proximity_diagrams(size):
            parent = {
                chronological_labels[index]: (
                    None
                    if raw_parent[index] is None
                    else chronological_labels[raw_parent[index]]
                )
                for index in range(size)
            }
            proximate = {
                chronological_labels[index]: tuple(
                    chronological_labels[older]
                    for older in raw_proximate[index]
                )
                for index in range(size)
            }
            if not lies_in_essential_span(labels, parent):
                continue

            for parity_tuple in product((0, 1), repeat=size):
                parity = dict(zip(chronological_labels, parity_tuple))
                weight = {
                    label: label if label in ESSENTIAL else 1
                    for label in labels
                }
                corrected = {
                    label: 2 * weight[label] + parity[label]
                    for label in labels
                }
                exceptional_count = {
                    label: sum(parity[older] for older in proximate[label])
                    for label in labels
                }
                strict = {
                    label: corrected[label] - exceptional_count[label]
                    for label in labels
                }
                load = {
                    label: sum(
                        strict[child]
                        for child in labels
                        if label in proximate[child]
                    )
                    for label in labels
                }

                if any(strict[label] < load[label] for label in labels):
                    continue
                if any(
                    parent[label] is not None and strict[label] <= 0
                    for label in labels
                ):
                    continue

                raw_count += 1
                if not deduplicate:
                    continue

                # With zero or one negligible point all labels are distinct,
                # so this is an isomorphism-invariant exact key.
                key = tuple(
                    (
                        label,
                        parent[label],
                        proximate[label][1]
                        if len(proximate[label]) == 2
                        else None,
                        corrected[label],
                    )
                    for label in labels
                )
                realizations[key] = {
                    "parent": parent,
                    "proximate": proximate,
                    "corrected": corrected,
                    "exceptional_count": exceptional_count,
                    "strict": strict,
                    "load": load,
                }

    return realizations, raw_count


def origin(node, parent):
    while parent[node] is not None:
        node = parent[node]
    return node


def classify(realization):
    parent = realization["parent"]
    proximate = realization["proximate"]

    if origin(4, parent) != origin(3, parent):
        if parent[3] is None:
            return "D43"
        assert parent[3] == 2 and parent[2] is None
        return "D4_23"

    if parent[3] == 4:
        return "A43"
    if parent[4] == 3:
        return "A34"
    assert parent[3] == 2 and parent[2] == 4
    return "S423" if len(proximate[3]) == 2 else "F423"


without_negligible, _ = enumerate_realizations(0)
with_one_negligible, _ = enumerate_realizations(1)
assert len(without_negligible) == 55
assert len(with_one_negligible) == 30
print("essential spans with zero/one negligible center: 55 + 30 = 85: PASS")

# Two negligible centers already have no numerical realization.  The
# structural lemma in the note shows that longer spans are consequently
# impossible as well.  No isomorphism reduction is needed for this zero test.
_, two_negligible_raw = enumerate_realizations(2, deduplicate=False)
assert two_negligible_raw == 0
print("two-negligible essential spans: none: PASS")

realizations = list(without_negligible.values()) + list(
    with_one_negligible.values()
)
class_counts = Counter(classify(realization) for realization in realizations)
assert class_counts == Counter(
    {
        "D43": 40,
        "D4_23": 2,
        "A43": 34,
        "A34": 7,
        "F423": 1,
        "S423": 1,
    }
)
print("six exhaustive high-core classes with counts 40,2,34,7,1,1: PASS")

for realization in realizations:
    kind = classify(realization)
    r = realization["corrected"]
    e = realization["exceptional_count"]
    m = realization["strict"]
    parent = realization["parent"]
    proximate = realization["proximate"]

    if kind == "D43":
        assert parent[4] is None and parent[3] is None
        assert m[4] >= 8 and m[3] >= 6
        assert m[4] + m[3] > 12
        assert (m[4] - 1) + (m[3] - 1) > 11

    elif kind == "D4_23":
        assert parent[4] is None and parent[2] is None and parent[3] == 2
        assert (r[2], r[3]) == (5, 6)
        assert (e[2], e[3]) == (0, 1)
        assert (m[2], m[3]) == (5, 5)
        assert m[4] + m[2] > 12
        assert m[2] - 1 < m[3]
        assert (m[4] - 1) + (m[2] - 1) + (m[3] - 1) > 11

    elif kind == "A43":
        assert parent[4] is None and parent[3] == 4
        assert m[4] + m[3] in (14, 15)
        assert (m[4] - 1) + (m[3] - 1) > 11

    elif kind == "A34":
        assert parent[3] is None and parent[4] == 3
        assert (r[3], r[4]) == (7, 8)
        assert (e[3], e[4]) == (0, 1)
        assert (m[3], m[4]) == (7, 7)
        assert (m[3] - 1) + (m[4] - 1) > 11

    elif kind == "F423":
        assert parent[4] is None and parent[2] == 4 and parent[3] == 2
        assert len(proximate[3]) == 1
        assert (r[4], r[2], r[3]) == (8, 5, 6)
        assert (e[4], e[2], e[3]) == (0, 0, 1)
        assert (m[4], m[2], m[3]) == (8, 5, 5)
        assert m[4] + m[2] > 12
        assert m[2] - 1 < m[3]
        assert (m[4] - 1) + (m[2] - 1) + (m[3] - 1) > 11

    else:
        assert kind == "S423"
        assert parent[4] is None and parent[2] == 4 and parent[3] == 2
        assert set(proximate[3]) == {4, 2}
        assert (r[4], r[2], r[3]) == (9, 5, 6)
        assert (e[4], e[2], e[3]) == (0, 1, 2)
        assert (m[4], m[2], m[3]) == (9, 4, 4)
        assert m[4] + m[2] > 12
        assert m[2] - 1 < m[3]

print("parity jumps, free/satellite chains, and line obstructions: PASS")
print("squarefree [4,3,2] proximity exclusion: PASS")
