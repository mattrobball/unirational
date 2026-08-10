#!/usr/bin/env python3
"""Exact replay for the universal rational rank-two landing exclusion."""

import sympy as sp

import derive_rank2_quadratic_landing as cyclic
import derive_rank2_spectral_landing as spectral


def main():
    # Cyclic-factor normal form.  Replay the four exact evaluations used in
    # the proof; the 80 coefficient equations are counted only as an
    # independent completeness check, with no Groebner calculation needed.
    landing, equations = cyclic.coefficient_equations()
    assert sp.Poly(landing, *cyclic.L).total_degree() == 6
    assert len(equations) == 80
    x, y, t, u = sp.symbols("x y t u")
    a0, a1, a2, a3 = cyclic.a
    first_slice = sp.factor(
        landing.subs(dict(zip(cyclic.L, (x, y, 0, -x - y))))
    )
    first_expected = (
        x**2
        * y
        * ((a0 - a3) * x + (a1 - a3) * y) ** 2
        * (-a2 * x + (a0 - a2) * y)
    )
    assert sp.expand(first_slice - first_expected) == 0

    second_slice = landing.subs(dict(zip(cyclic.L, (x, y, -x - y, 0))))
    case_i = sp.factor(second_slice.subs({a0: 0, a2: 0}))
    case_i_expected = -a1**2 * x * y**2 * (x + y) * (
        a1 * x * y + a3 * (x + y) ** 2
    )
    assert sp.expand(case_i - case_i_expected) == 0
    case_ii = sp.factor(
        second_slice.subs({a0: t, a1: t, a3: t, a2: u})
    )
    case_ii_expected = -t * x**2 * y * (x + y) * (
        (t - u) ** 2 * x * (x + y) - t**2 * y**2
    )
    assert sp.expand(case_ii - case_ii_expected) == 0

    last_i = landing.subs({a0: 0, a1: 0, a2: 0}).subs(
        dict(zip(cyclic.L, (1, 1, 0, 1)))
    )
    last_ii = landing.subs({a0: 0, a1: 0, a3: 0}).subs(
        dict(zip(cyclic.L, (1, 1, 1, -3)))
    )
    assert sp.expand(last_i + 3 * a3**3) == 0
    assert sp.expand(last_ii + 3 * a2**3) == 0

    # Absolute-Galois zero-pattern combinatorics.
    weights = {1, 2, 3, 4}
    tau = lambda support: {(2 * q) % 5 for q in support}
    tau2 = lambda support: {(4 * q) % 5 for q in support}
    orbit = {1}
    for _ in range(3):
        orbit |= tau(orbit)
    assert orbit == weights
    negation_orbits = {
        frozenset({q, (-q) % 5}) for q in weights
    }
    assert negation_orbits == {frozenset({1, 4}), frozenset({2, 3})}
    assert tau({1, 4}) == {2, 3}
    assert tau({2, 3}) == {1, 4}
    assert tau2({1, 4}) == {1, 4}
    assert tau2({2, 3}) == {2, 3}

    # Neither-cyclic spectral normal form: verify the complete four-row
    # expansion and the nonvanishing of every cyclotomic constant.
    rows = spectral.landing_equations()
    z = spectral.z
    a, b, c, d = spectral.a, spectral.b, spectral.c, spectral.d
    expected = {
        (3, 2, 1, 0): 5 * a**3 * c**2 * d * (z**3 - z**2 - z - 1),
        (2, 0, 3, 1): -5
        * a**2
        * b
        * d**3
        * (2 * z**3 + z**2 + 2 * z + 2),
        (1, 3, 0, 2): 5 * a * b**2 * c**3 * z * (z**2 + 2),
        (0, 1, 2, 3): 5 * b**3 * c * d**2 * z * (2 * z + 1),
    }
    assert set(rows) == set(expected)
    assert all(
        spectral.reduce_z(rows[powers] - coefficient) == 0
        for powers, coefficient in expected.items()
    )
    constants = (
        z**3 - z**2 - z - 1,
        2 * z**3 + z**2 + 2 * z + 2,
        z * (z**2 + 2),
        z * (2 * z + 1),
    )
    phi = sp.Poly(spectral.phi5, z, domain=sp.QQ)
    assert all(sp.gcd(sp.Poly(value, z, domain=sp.QQ), phi).degree() == 0 for value in constants)

    print("RANK2_CYCLIC_COEFFICIENT_EQUATIONS", len(equations))
    print("RANK2_CYCLIC_EXACT_EVALUATIONS", 4)
    print("GALOIS_TAU_WEIGHT_ORBIT", sorted(orbit))
    print("GALOIS_TAU2_SUPPORT_PAIRS", sorted(map(tuple, negation_orbits)))
    for powers in expected:
        print("SPECTRAL_RANK2_ROW", powers, rows[powers])
    print("SPECTRAL_RANK2_NONZERO_ROWS", len(rows))
    print("F55-TRACE-RATIONAL-RANK2-QUADRATIC-LANDING-EXCLUSION-OK")


if __name__ == "__main__":
    main()
