#!/usr/bin/env python3
"""Produce the load-bearing numerical payload for Goal M.

The script writes JSON to stdout.  It deliberately contains no stored verdict
about the Problem E headline.
"""

from __future__ import annotations

import json


CENTRES = [
    (0, 1, "L_plane", "Fano", "conic_bundle"),
    (1, 3, "L_plane", "Fano", "del_pezzo_3_fibration"),
    (1, 4, "L_plane", "weak_fano_divisorial", "no_small_link"),
    (4, 6, "L_plane", "weak_fano_divisorial", "no_small_link"),
    (0, 2, "L_plane", "weak_fano_small", "del_pezzo_4_fibration"),
    (0, 3, "L_plane", "weak_fano_small", "terminal_rank_one_fano"),
    (0, 4, "L_quadric", "weak_fano_small", "V14_point"),
    (1, 5, "L_quadric", "weak_fano_small", "V14_curve"),
    (0, 5, "L_quadric", "weak_fano_small", "cubic_self_link"),
    (2, 6, "L_quadric", "weak_fano_small", "cubic_self_link"),
]


def curve_volume(g: int, d: int) -> int:
    return 22 - 4 * d + 2 * g


def payload() -> dict:
    centres = [
        {
            "g": g,
            "d": d,
            "family": family,
            "model": model,
            "output": output,
            "volume": curve_volume(g, d),
        }
        for g, d, family, model, output in CENTRES
    ]
    return {
        "schema": "m_sarkisov_weak_fano_centres_v1",
        "source": {
            "title": "On birational maps from cubic threefolds",
            "authors": ["Jeremy Blanc", "Stephane Lamy"],
            "arxiv": "1409.7778",
        },
        "cubic": {"H3": 3, "fano_index": 2, "anticanonical_cube": 24},
        "curve_blowup_formula": {
            "H3": 3,
            "H2E": 0,
            "HE2": "-d",
            "E3": "2-2*d-2*g",
            "minus_K": "2*H-E",
            "minus_K_cube": "22-4*d+2*g",
        },
        "centres": centres,
        "plane_cubic_link": {
            "centre": {"g": 1, "d": 3},
            "plane_choice": (
                "nonempty open of smooth sections disjoint from the "
                "degree-55 line orbit"
            ),
            "picard_basis": ["H", "E"],
            "minus_K": [2, -1],
            "fibre_divisor": [1, -1],
            "mori_rays": {
                "exceptional_fibre": {"H": 0, "E": -1},
                "cubic_surface_curve": {"H": 1, "E": 1},
            },
            "generic_fibre_degree": 3,
            "zero_cycle_degrees": [3, 55],
            "generic_fibre_index": 1,
            "section_frontier": "rational section or degree-4 multisection",
        },
        "scope": (
            "ordinary blowups of smooth geometrically integral curves with "
            "weak-Fano blowup only"
        ),
    }


if __name__ == "__main__":
    print(json.dumps(payload(), indent=2, sort_keys=False))
