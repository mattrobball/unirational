#!/usr/bin/env python3
"""Produce and exactly check the small invariant model for Goal H2.

This script uses the *installed* A4 source representation only to compute the
constant source change P.  All invariant-field and adapted-frame identities
are then checked symbolically over Q(sqrt(5), omega), omega^2+omega+1=0.
"""

from __future__ import annotations

from collections import deque
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
REPO = next(
    parent for parent in HERE.parents
    if (parent / "certificates" / "exact_weil_check.py").is_file()
    and (parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json").is_file()
)
INSTALLED = REPO / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json"


def pc(a, b):
    return tuple(a[b[i]] for i in range(5))


def pinv(a):
    out = [0] * len(a)
    for i, value in enumerate(a):
        out[value] = i
    return tuple(out)


def exact_icosahedral_source():
    """The characteristic-zero version of produce.py:source_a5()."""
    r = sp.sqrt(5)
    alpha = -(1 + r) / 2
    g5, g3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    m5 = sp.Matrix([[alpha, -alpha, -1], [alpha, 1, 0], [alpha, -alpha, 0]])
    m3 = sp.Matrix([[0, -1, -alpha], [0, 0, 1], [-1, -alpha, 0]])
    identity = tuple(range(5))
    reps = {identity: sp.eye(3)}
    queue = deque([identity])
    while queue:
        x = queue.popleft()
        for generator, matrix in ((g5, m5), (g3, m3)):
            y = pc(x, generator)
            candidate = reps[x] * matrix
            if y in reps:
                assert all(sp.simplify(value) == 0 for value in reps[y] - candidate)
            else:
                reps[y] = candidate.applyfunc(sp.simplify)
                queue.append(y)
    assert len(reps) == 60
    return reps


def source_intertwiner(installed_generators):
    canonical = (
        sp.diag(-1, -1, 1),
        sp.Matrix([[0, 1, 0], [0, 0, 1], [1, 0, 0]]),
    )
    unknowns = sp.symbols("P0:9")
    p = sp.Matrix(3, 3, unknowns)
    equations = []
    for installed, standard in zip(installed_generators, canonical):
        equations.extend(list(installed * p - p * standard))
    coefficient_matrix, rhs = sp.linear_eq_to_matrix(equations, unknowns)
    assert rhs == sp.zeros(len(equations), 1)
    kernel = coefficient_matrix.nullspace()
    assert len(kernel) == 1
    vector = kernel[0]
    first = next(value for value in vector if value != 0)
    p = sp.Matrix(3, 3, [sp.simplify(value / first) for value in vector])
    assert sp.simplify(p.det()) != 0
    for installed, standard in zip(installed_generators, canonical):
        assert all(sp.simplify(value) == 0 for value in installed * p - p * standard)
    return canonical, p


def s(value):
    return str(sp.factor(value)).replace("**", "^")


def main():
    installed_payload = json.loads(INSTALLED.read_text())
    record = next(row for row in installed_payload["records"] if row["label"] == "A4")
    source_map = {
        tuple(row["h"]): tuple(row["permutation"])
        for row in record["source_map"]
    }
    representations = exact_icosahedral_source()
    installed_generators = tuple(
        representations[source_map[tuple(generator)]]
        for generator in record["generators"]
    )
    canonical, p = source_intertwiner(installed_generators)

    x, y, z, omega = sp.symbols("x y z omega")
    relation = {omega**2: -omega - 1}

    def reduce_omega(value):
        numerator, denominator = sp.fraction(sp.cancel(value))
        numerator = sp.rem(sp.Poly(numerator, omega), sp.Poly(omega**2 + omega + 1, omega)).as_expr()
        denominator = sp.rem(sp.Poly(denominator, omega), sp.Poly(omega**2 + omega + 1, omega)).as_expr()
        return sp.cancel(numerator / denominator)

    variables = sp.Matrix([x, y, z])
    S = x**2 + y**2 + z**2
    L = x**2 + omega * y**2 + omega**2 * z**2
    M = x**2 + omega**2 * y**2 + omega * z**2
    ell, emm = L / S, M / S
    u, v = ell**3, ell * emm
    q = x * y * z
    delta = (x**2 - y**2) * (x**2 - z**2) * (y**2 - z**2)
    Q = sp.Matrix([
        [S * x / q, y * z / S, x**3 / q],
        [S * y / q, z * x / S, y**3 / q],
        [S * z / q, x * y / S, z**3 / q],
    ])

    substitutions = []
    for matrix in canonical:
        transformed = matrix * variables
        substitutions.append({x: transformed[0], y: transformed[1], z: transformed[2]})
    expected = (
        (1, 1, 1, 1),
        (1, omega**2, omega, 1),
    )
    for matrix, substitution, (s_scale, l_scale, m_scale, invariant_scale) in zip(
        canonical, substitutions, expected
    ):
        assert reduce_omega(S.subs(substitution, simultaneous=True) - s_scale * S) == 0
        assert reduce_omega(L.subs(substitution, simultaneous=True) - l_scale * L) == 0
        assert reduce_omega(M.subs(substitution, simultaneous=True) - m_scale * M) == 0
        assert reduce_omega(u.subs(substitution, simultaneous=True) - invariant_scale * u) == 0
        assert reduce_omega(v.subs(substitution, simultaneous=True) - invariant_scale * v) == 0
        transformed_Q = Q.applyfunc(lambda value: value.subs(substitution, simultaneous=True))
        assert all(reduce_omega(value) == 0 for value in transformed_Q - matrix * Q)

    determinant_Q = sp.factor(Q.det())
    assert sp.cancel(determinant_Q - delta / q**2) == 0

    # DFT inversion proves that l,m generate the V4 quotient on S != 0.
    inverse_fourier = (
        (1 + ell + emm) / 3,
        (1 + omega**2 * ell + omega * emm) / 3,
        (1 + omega * ell + omega**2 * emm) / 3,
    )
    for left, right in zip((x**2 / S, y**2 / S, z**2 / S), inverse_fourier):
        assert reduce_omega(left - right) == 0

    # Record every installed seed denominator after y_inst=P*y.  This makes
    # the intersection open with the original Hilbert--90 chart explicit.
    installed_denominators = []
    ell_row = sp.Matrix([[1, 2, 3]])
    for element in record["subgroup_elements"]:
        permutation = source_map[tuple(element)]
        inverse_source = representations[pinv(permutation)]
        linear_form = (ell_row * inverse_source * p * variables)[0]
        installed_denominators.append({
            "h": element,
            "linear_form": s(linear_form),
        })

    payload = {
        "format": "H2-A4-CANONICAL-MODEL-v1",
        "installed_input": "H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json:A4",
        "installed_generators": record["generators"],
        "canonical_source_generators": [
            [[int(value) for value in row] for row in matrix.tolist()]
            for matrix in canonical
        ],
        "source_intertwiner_direction": "y_inst=P*y_can; S_inst(g)P=P*S_can(g)",
        "source_intertwiner_P": [[s(value) for value in row] for row in p.tolist()],
        "source_intertwiner_determinant": s(p.det()),
        "invariant_field": {
            "S": "x^2+y^2+z^2",
            "L": "x^2+omega*y^2+omega^2*z^2",
            "M": "x^2+omega^2*y^2+omega*z^2",
            "ell": "L/S",
            "m": "M/S",
            "u": "ell^3",
            "v": "ell*m",
            "presentation": "K_A4=C(u,v); m^3=v^3/u",
            "inverse_fourier": [
                "x^2/S=(1+ell+m)/3",
                "y^2/S=(1+omega^2*ell+omega*m)/3",
                "z^2/S=(1+omega*ell+omega^2*m)/3",
            ],
        },
        "adapted_frame_in_decomposition_basis": {
            "character_columns": ["(L/S)e_U", "(M/S)e_V"],
            "standard_block_columns": [
                "S*(x,y,z)^T/(xyz)",
                "(yz,zx,xy)^T/S",
                "(x^3,y^3,z^3)^T/(xyz)",
            ],
            "standard_block_determinant": "Delta/(x*y*z)^2",
            "Delta": "(x^2-y^2)*(x^2-z^2)*(y^2-z^2)",
            "full_determinant_up_to_nonzero_constant": "L*M*Delta/(S^2*(x*y*z)^2)",
        },
        "canonical_open": "S*x*y*z*L*M*Delta != 0",
        "installed_seed_denominators_after_P": installed_denominators,
        "installed_open": "product_h d_h(y)*det(A_inst(P*y)) != 0",
        "frame_equivalence": (
            "B(y)=D*diag_blocks(L/S,M/S,Q(y)); "
            "T(y)=A_inst(P*y)^(-1)*B(y) is A4-invariant and "
            "F(A_inst(P*y)*T(y)*w)=F(B(y)*w)"
        ),
        "twist_point": (
            "For a parameter root p of exact_degree3_map.json, the adapted coordinate vector "
            "z(y)=B(y)^(-1)*Phi_p(y) satisfies z(g*y)=chi(g)z(y).  The actual degree-zero "
            "K_A4-vector is (M/S)*z(y)/(xyz), because chi(gb)=omega^2 and M(gb*y)=omega*M(y)."
        ),
    }
    (HERE / "canonical_model.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("H2_A4_CANONICAL_MODEL_OK")


if __name__ == "__main__":
    main()
