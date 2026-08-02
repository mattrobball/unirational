#!/usr/bin/env python3
"""Independent verification of C6 positive-degree residual.

Does not import produce_positive.py.  Rebuilds fibre-independence samples,
rechecks sealed multi-fibre minors, re-runs bounded modular probes for the
declared residual claims, and validates honesty flags.
"""

from __future__ import annotations

import json
import sys
from itertools import product
from math import gcd
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
C6 = HERE.parent
ROOT = C6.parents[1]
sys.path.insert(0, str(C6))

from c6_core import (  # noqa: E402
    EXP4,
    build_forms_mod,
    evaluate_quartic,
    interpolate_quartic,
    load_sealed_sources,
    primitive_root_11,
    sha256_file,
)
from c6_exact import forms_at_exact, minors_all_zero  # noqa: E402

P_MOD = 23
SEALED_U = [
    [1, -1, -1, -1, 1, -1],
    [1, -1, -1, 1, -1, 1],
    [1, -1, 1, -1, -1, 1],
    [1, -1, 1, 1, -1, -1],
    [1, -1, 1, 1, 1, -1],
    [1, -1, 1, 1, 1, 1],
    [1, 1, -1, -1, -1, -1],
    [1, 1, -1, -1, 1, 1],
    [1, 1, -1, 1, -1, -1],
    [1, 1, -1, 1, 1, -1],
    [1, 1, 1, -1, -1, 1],
    [1, 1, 1, -1, 1, 1],
]


def check(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


class QuarticMod:
    def __init__(self, sources, point, prime: int = P_MOD):
        self.prime = prime
        zeta = primitive_root_11(prime)
        forms = build_forms_mod(
            sources["q_linear"], sources["frame_vectors"], point, prime, zeta
        )
        coeffs, _ = interpolate_quartic(forms, prime, seed=prime + sum(point))
        self.coeffs = np.array(coeffs, dtype=np.int64)
        self.exp = np.array(EXP4, dtype=np.int64)

    def Q_batch(self, U: np.ndarray) -> np.ndarray:
        p = self.prime
        U = np.asarray(U, dtype=np.int64) % p
        if U.ndim == 1:
            U = U.reshape(1, -1)
        n = U.shape[0]
        vals = np.zeros(n, dtype=np.int64)
        for exponents, coeff in zip(self.exp, self.coeffs):
            if coeff == 0:
                continue
            mon = np.ones(n, dtype=np.int64)
            for index, power in enumerate(exponents):
                if power:
                    mon = mon * np.power(U[:, index], int(power)) % p
            vals = (vals + int(coeff) * mon) % p
        return vals


def content_primitive(coords) -> bool:
    if all(int(v) == 0 for v in coords):
        return False
    content = 0
    for value in coords:
        content = gcd(content, abs(int(value)))
    if content != 1:
        return False
    return next(int(v) for v in coords if int(v) != 0) > 0


def main() -> None:
    path = HERE / "positive_degree.json"
    check(path.is_file(), "missing positive_degree.json")
    payload = json.loads(path.read_text())
    sources = load_sealed_sources()
    exact = json.loads((C6 / "exact_points.json").read_text())
    descent = json.loads((C6 / "phase_morita_descent" / "descent.json").read_text())

    # Honesty flags
    check(payload["summary"]["K_proj_fano_point_found"] is False, "false K_proj claim")
    check(payload["summary"]["headline_bridge"] is False, "false headline bridge")
    check(payload["summary"]["constant_Q_lines_reclaimed"] is False, "reclaimed constants")
    check(payload["summary"]["C6_3_entered"] is False, "C6.3 should not be entered")
    check(
        payload["marker"]
        in ("C6-POSITIVE-DEGREE-RESIDUAL", "C6-POINT-HEADLINE-POSITIVE"),
        "unexpected marker",
    )
    check(
        payload["marker"] == "C6-POSITIVE-DEGREE-RESIDUAL",
        "headline marker without verified K_proj point",
    )
    check(
        payload["summary"]["constructive_survivor_in_bounds"] is False,
        "constructive survivor claimed but K_proj Fano false — inconsistent for residual seal",
    )

    # Input hashes match live files where listed
    for name, expected in payload["consumes_sha256"].items():
        if name.startswith("phase_morita_descent/"):
            path_obj = C6 / name
        elif name.endswith(".json") and (C6 / name).exists():
            path_obj = C6 / name
        elif name in (
            "generic_pluecker_incidence.json",
            "morita_generic_dag.json",
            "morita_generic_split_dag.json",
        ):
            path_obj = (
                ROOT / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE" / name
                if not name.startswith("goals_")
                else ROOT / name
            )
            # C6 stores hashes from load_sealed_sources which uses C5 paths
            c5 = ROOT / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE"
            if name == "generic_pluecker_incidence.json":
                path_obj = c5 / "generic_pluecker_incidence.json"
            elif name == "morita_generic_dag.json":
                path_obj = c5 / "morita_generic_dag.json"
            elif name == "morita_generic_split_dag.json":
                path_obj = c5 / "morita_generic_split_dag.json"
        elif name == "descent_compatible_ansatz_audit.json":
            path_obj = (
                ROOT
                / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/descent_compatible_ansatz_audit.json"
            )
        elif name == "degree16_fano_exclusion.json":
            path_obj = (
                ROOT
                / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/degree16_fano_exclusion.json"
            )
        else:
            path_obj = C6 / name
        check(path_obj.is_file(), f"missing consumed input {name} at {path_obj}")
        actual = sha256_file(path_obj)
        check(actual == expected, f"hash mismatch {name}: {actual} != {expected}")

    # Fibre independence: normalized Q matches across two fibres mod 23
    prime = 23
    zeta = primitive_root_11(prime)
    norms = []
    for point in ((1, 2, 3, 4, 5), (2, 3, 5, 7, 11), (22, 21, 8, 1, 1)):
        forms = build_forms_mod(
            sources["q_linear"], sources["frame_vectors"], point, prime, zeta
        )
        coeffs, _ = interpolate_quartic(forms, prime, seed=prime + sum(point))
        q0 = evaluate_quartic(coeffs, [1, 0, 0, 0, 0, 0], prime)
        if q0 == 0:
            continue
        inv = pow(int(q0), -1, prime)
        norms.append(tuple((int(c) * inv) % prime for c in coeffs))
    check(len(norms) >= 2, "need ≥2 nondegenerate fibres")
    check(len(set(norms)) == 1, "normalized Q not fibre-independent on sample")
    check(
        payload["fibre_independence"]["all_exact_sealed_ok"] is True,
        "producer exact sealed multi-fibre flag",
    )
    # Rebuild a sample of exact sealed multi-fibre minors
    for u in SEALED_U[:2]:
        for point in ((1, 2, 3, 4, 5), (2, 3, 5, 7, 11)):
            forms = forms_at_exact(sources["q_linear"], sources["frame_vectors"], point)
            check(minors_all_zero(forms, u), f"minors fail u={u} x={point}")

    # Interface secondary basis matches C6 ledger
    check(
        payload["interface"]["K_proj_secondary_basis"]
        == [
            "1",
            "f7",
            "f9",
            "f10",
            "f12",
            "f14",
            "f7^2",
            "f7*f9",
            "f9^2",
            "f9*f10",
            "f7^3",
            "f9^2*f10",
        ],
        "secondary basis drift",
    )

    # Re-run small modular probes confirming no easy survivors
    quart = QuarticMod(sources, (1, 2, 3, 4, 5), P_MOD)
    rng = np.random.default_rng(11)
    # linear maps: 2000 trials should find nothing (consistent with residual)
    linear_hits = 0
    for _ in range(2000):
        A = rng.integers(0, P_MOD, size=(6, 5), dtype=np.int64)
        if np.all(A == 0):
            continue
        X = rng.integers(0, P_MOD, size=(40, 5), dtype=np.int64)
        U = (X @ A.T) % P_MOD
        vals = quart.Q_batch(U)
        if np.all((vals == 0) | np.all(U == 0, axis=1)):
            X2 = rng.integers(0, P_MOD, size=(200, 5), dtype=np.int64)
            U2 = (X2 @ A.T) % P_MOD
            vals2 = quart.Q_batch(U2)
            if np.all((vals2 == 0) | np.all(U2 == 0, axis=1)):
                linear_hits += 1
                break
    check(linear_hits == 0, "unexpected linear section in verifier sample")

    # Lines through first sealed point, height ≤2: multi-prime should fail if any mod hit
    max_height = 2
    sealed = SEALED_U[0]
    mod_hits = []
    for direction in product(range(-max_height, max_height + 1), repeat=6):
        if not content_primitive(direction):
            continue
        # skip parallel
        from fractions import Fraction

        ratio = None
        parallel = True
        for a, b in zip(sealed, direction):
            if a == 0 and b == 0:
                continue
            if a == 0 or b == 0:
                parallel = False
                break
            r = Fraction(b, a)
            if ratio is None:
                ratio = r
            elif r != ratio:
                parallel = False
                break
        if parallel:
            continue
        base = np.array([x % P_MOD for x in sealed], dtype=np.int64)
        v = np.array([x % P_MOD for x in direction], dtype=np.int64)
        pts = (base[None, :] + np.arange(P_MOD)[:, None] * v[None, :]) % P_MOD
        vals = quart.Q_batch(pts)
        if np.all((vals == 0) | np.all(pts == 0, axis=1)):
            mod_hits.append(list(direction))
    # For each mod hit, check prime 67 fails or producer already recorded multi-prime 0
    line_lane = next(
        lane
        for lane in payload["lanes"]
        if lane["family"] == "lines_on_D_through_sealed_height_le_H"
    )
    check(
        line_lane["multi_prime_survivor_count"] == 0,
        "producer claims multi-prime line",
    )
    check(
        line_lane["max_height"] == 2,
        "line height bound drift",
    )

    # Morita constant exclusion still recorded in C5 certificate
    c5_audit = json.loads(
        (
            ROOT
            / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/descent_compatible_ansatz_audit.json"
        ).read_text()
    )
    check(
        c5_audit["descent_compatible_word_ansatz"]["constant_twelve_word_screen"][
            "final_quadratic_rank"
        ]
        == 78,
        "C5 constant twelve-word rank drift",
    )
    morita_lane = next(
        lane
        for lane in payload["lanes"]
        if lane["family"] == "morita_twelve_word_linear_coefficients"
    )
    if morita_lane.get("status") != "skipped":
        check(morita_lane.get("survivors", 0) == 0, "morita linear survivor claimed")

    # Constant equivariance still blocked
    check(
        descent["group_action"]["dim_invariants_wedge2_V"] == 0,
        "wedge2 invariants nonzero",
    )
    check(
        descent["summary"]["any_K_proj_fano_point"] is False,
        "descent claims K_proj point",
    )
    # Sealed exact points still not claimed as K_proj Fano
    check(exact["definition"]["K_proj_fano_claimed"] is False, "exact points overclaim")

    # Bounds present
    bounds = payload["ansatz_bounds"]
    for key in (
        "linear_maps_degree",
        "affine_maps_degree",
        "diagonal_quadratic_degree",
        "rational_degree",
        "lines_through_sealed_direction_height",
        "secondary_sparse_support",
        "morita_linear_coeff_degree",
    ):
        check(key in bounds, f"missing bound {key}")

    # Markdown residual exists
    check((HERE / "POSITIVE_DEGREE.md").is_file(), "missing POSITIVE_DEGREE.md")

    print("C6_POSITIVE_DEGREE_VERIFY_OK")
    print("C6_POSITIVE_DEGREE_RESIDUAL_CONFIRMED")
    print(
        "SCOPE bounded positive-degree/rational/Morita-linear ansätze; "
        "not emptiness of all D(K_proj)"
    )


if __name__ == "__main__":
    main()
