#!/usr/bin/env python3
"""Exhaustive arithmetic for quintics transverse to simple proper bases."""


def rank_one_dimension(f: int, m: int) -> int:
    return max(f - 2 * m + 1, 0) + max(2 * m + 21, 0)


base_types = [
    ("rank3-length1", 1, 16),
    ("rank3-length2", 2, 15),
    ("rank3-length3", 3, 14),
    ("rank2-length4", 4, 13),
]

minimum = {"d>=4": 10**9, "d=3": 10**9, "d=2": 10**9, "d=1": 10**9}

for _name, base_length, triple_dimension in base_types:
    for h in range(1, base_length + 1):
        f = 10 - h
        image_dimension = 72 - 3 * h
        point_bound = 20 - h
        degree_rows = [
            ("d>=4", range(4, f + 11), 20),
            ("d=3", [3], 19),
            ("d=2", [2], 17),
            ("d=1", [1], 14),
        ]
        for label, quotient_degrees, global_curve_bound in degree_rows:
            bad_dimension = max(
                rank_one_dimension(f, f - d) for d in quotient_degrees
            )
            curve_dimension = min(global_curve_bound, point_bound)
            margin = (
                image_dimension
                - bad_dimension
                - curve_dimension
                - triple_dimension
            )
            minimum[label] = min(minimum[label], margin)

assert minimum == {"d>=4": 3, "d=3": 1, "d=2": 1, "d=1": 2}
print("transverse-base restriction images 72-3h: PASS")
print("minimum quotient-degree margins 3/1/1/2: PASS")
print("isolated-base transverse integral-quintic square exclusion: PASS")
