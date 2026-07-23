#!/usr/bin/env python3
"""Factor-degree replay for the base-point-free e=3,4,5 reduction."""


def partitions(n, cap=None):
    """Nonincreasing integer partitions of n."""
    if n == 0:
        yield ()
        return
    if cap is None or cap > n:
        cap = n
    for first in range(cap, 0, -1):
        for tail in partitions(n - first, first):
            yield (first,) + tail


def route(shape):
    if 4 in shape:
        return "integral quartic component"
    if 3 in shape:
        return "integral cubic component"
    if shape == (5,):
        return "integral quintic survivor"
    # Every remaining shape has either a quadratic factor or two linears.
    assert 2 in shape or shape.count(1) >= 2
    return "degree-two square divisor"


expected = {
    3: {
        (3,): "integral cubic component",
        (2, 1): "degree-two square divisor",
        (1, 1, 1): "degree-two square divisor",
    },
    4: {
        (4,): "integral quartic component",
        (3, 1): "integral cubic component",
        (2, 2): "degree-two square divisor",
        (2, 1, 1): "degree-two square divisor",
        (1, 1, 1, 1): "degree-two square divisor",
    },
    5: {
        (5,): "integral quintic survivor",
        (4, 1): "integral quartic component",
        (3, 2): "integral cubic component",
        (3, 1, 1): "integral cubic component",
        (2, 2, 1): "degree-two square divisor",
        (2, 1, 1, 1): "degree-two square divisor",
        (1, 1, 1, 1, 1): "degree-two square divisor",
    },
}

for degree, wanted in expected.items():
    actual_shapes = set(partitions(degree))
    assert actual_shapes == set(wanted)
    actual = {shape: route(shape) for shape in actual_shapes}
    assert actual == wanted
    survivors = [shape for shape, destination in actual.items() if "survivor" in destination]
    print(f"e={degree}: {len(actual)} shapes; survivors={survivors}: PASS")

print("base-point-free e=3,4 exclusion and e=5 reduction: PASS")
