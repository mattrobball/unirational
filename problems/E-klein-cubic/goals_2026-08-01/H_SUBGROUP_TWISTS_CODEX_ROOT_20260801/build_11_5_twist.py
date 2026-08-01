#!/usr/bin/env python3
"""Build an exact-formula Hilbert--90 frame for the maximal 11:5 subgroup."""

from __future__ import annotations

import json
from pathlib import Path
import random

import build_a5_twists as base


HERE = Path(__file__).resolve().parent
P = base.PRIME
DEN = (1, 2, 3, 4, 5)
NUM = (2, 3, 5, 7, 11)


def normalizer(subgroup):
    return frozenset(
        g for g in base.KEYS
        if frozenset(base.conjugate(g, h) for h in subgroup) == subgroup
    )


def frame_at(y, subgroup):
    frame = base.zero_matrix(5)
    denominators = []
    for h in subgroup:
        moved = base.mv(base.rho_mod(base.ginv(h)), y)
        denominator = sum(a * b for a, b in zip(DEN, moved)) % P
        if denominator == 0:
            return None, None
        numerator = sum(a * b for a, b in zip(NUM, moved)) % P
        denominators.append(denominator)
        frame = base.madd(
            frame,
            base.mscale(numerator * pow(denominator, -1, P), base.rho_mod(h)),
        )
    return frame, denominators


def witness(subgroup):
    randomizer = random.Random(115)
    for _ in range(20000):
        y = tuple(randomizer.randrange(P) for _ in range(4)) + (1,)
        frame, denominators = frame_at(y, subgroup)
        if frame is None:
            continue
        determinant = base.determinant(frame)
        if determinant:
            return y, frame, denominators, determinant
    raise AssertionError("no 11:5 frame witness")


def proportional(v, w):
    return all(
        (v[i] * w[j] - v[j] * w[i]) % P == 0
        for i in range(5)
        for j in range(i + 1, 5)
    )


def klein(vector):
    return sum(vector[i] ** 2 * vector[(i + 1) % 5] for i in range(5)) % P


def main():
    c11 = base.closure((base.ew.ft,))
    subgroup = normalizer(c11)
    assert len(c11) == 11 and len(subgroup) == 55
    assert base.character_norm(subgroup) == base.ew.C(1)
    y, frame, denominators, determinant = witness(subgroup)
    generators = [base.ew.ft, next(h for h in subgroup if base.ORDERS[h] == 5)]
    for generator in generators:
        moved_y = base.mv(base.rho_mod(generator), y)
        moved_frame, _ = frame_at(moved_y, subgroup)
        assert moved_frame == base.mmul(base.rho_mod(generator), frame)

    # The five C11 eigenlines are the coordinate points.  The complement C5
    # permutes them transitively, giving an H-orbit of exact degree five on X.
    e0 = [1, 0, 0, 0, 0]
    orbit = []
    for h in subgroup:
        point = base.mv(base.rho_mod(h), e0)
        if not any(proportional(point, old) for old in orbit):
            orbit.append(point)
    assert len(orbit) == 5 and all(klein(point) == 0 for point in orbit)

    payload = {
        "format": "klein-11-5-generic-twist-v1",
        "subgroup": "11:5=N_G(C11)",
        "order": 55,
        "generators_psl2_f11": [list(g) for g in generators],
        "generator_orders": [base.ORDERS[g] for g in generators],
        "restriction_character_norm": 1,
        "generic_torsor": (
            "Spec C(P(W)) -> Spec C(P(W))^(11:5), with W the faithful "
            "irreducible five-dimensional Klein representation"
        ),
        "hilbert90_formula": (
            "A(y)=sum_{h in H} c(rho(h^-1)y)rho(h), "
            "c=(2*y0+3*y1+5*y2+7*y3+11*y4)/"
            "(y0+2*y1+3*y2+4*y3+5*y4)"
        ),
        "twisted_cubic_equation": (
            "F_H(z)=sum_{i mod 5}(A(y)z)_i^2(A(y)z)_{i+1}=0 "
            "over K_H=C(P(W))^H"
        ),
        "index_screen": {
            "hyperplane_zero_cycle_degree": 3,
            "C11_eigenline_orbit_degree": 5,
            "gcd": 1,
            "conclusion": "index one; no index obstruction",
        },
        "good_reduction": {
            "prime": P,
            "zeta11": base.ZETA11,
            "source_point": list(y),
            "denominator_product": __import__("math").prod(denominators) % P,
            "frame_determinant": determinant,
            "frame": frame,
            "specialized_twist_coefficients": base.cubic_coefficients(frame),
        },
    }
    output = HERE / "11_5_twist_payload.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {output}")
    print("det=", determinant, "point=", y, "orbit_degree=", len(orbit))
    print("FROBENIUS_11_5_TWIST_PAYLOAD_OK")


if __name__ == "__main__":
    main()
