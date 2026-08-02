#!/usr/bin/env python3
"""Independent verification of C6 Morita / K_proj descent residual.

Does not import produce_descent.py.  Rebuilds Galois orbits, Plücker identities,
and the modular (∧²V)^G = 0 obstruction from sealed sources + descent.json claims.
"""

from __future__ import annotations

import json
import runpy
import sys
from collections import deque
from fractions import Fraction
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
C6 = HERE.parent
ROOT = C6.parents[1]
sys.path.insert(0, str(C6))

from c6_core import (  # noqa: E402
    PAIRS,
    build_forms_mod,
    evaluate_quartic,
    interpolate_quartic,
    load_sealed_sources,
    primitive_root_11,
    sha256_file,
)
from c6_exact import (  # noqa: E402
    M_of_exact,
    forms_at_exact,
    minors_all_zero,
    normalize_plucker,
    nullspace_exact,
    omega_mixed,
    plucker_field,
    pluecker_hyperplanes_identically_zero,
    standard_plucker_quadrics,
    z_add,
    z_eq,
    z_from_json,
    z_inv,
    z_is_zero,
    z_mod,
    z_mul,
    z_scal,
    z_zero_list,
)

P_MOD = 23
SQUARES = (1, 3, 4, 5, 9)
QR = set(SQUARES)


def z_galois(a, g: int):
    coeffs = [Fraction(0)] * 11
    for k, c in enumerate(a):
        coeffs[k] = c
    out = [Fraction(0)] * 11
    for k, c in enumerate(coeffs):
        if c:
            out[(k * g) % 11] += c
    if out[10]:
        for i in range(10):
            out[i] -= out[10]
    return out[:10]


def same_projective(p, q) -> bool:
    ratio = None
    for a, b in zip(p, q):
        if z_is_zero(a) and z_is_zero(b):
            continue
        if z_is_zero(a) or z_is_zero(b):
            return False
        r = z_mul(b, z_inv(a))
        if ratio is None:
            ratio = r
        elif not z_eq(r, ratio):
            return False
    return True


def orbit_size(plucker) -> int:
    distinct = []
    for g in range(1, 11):
        gal = [z_galois(c, g) for c in plucker]
        if not any(same_projective(prev, gal) for prev in distinct):
            distinct.append(gal)
    return len(distinct)


def stab_size(plucker) -> int:
    return sum(
        1
        for g in range(1, 11)
        if same_projective(plucker, [z_galois(c, g) for c in plucker])
    )


def gauss_sum():
    gauss = [Fraction(0)] * 10
    for k in range(1, 10):
        gauss[k] += Fraction(1 if k in QR else -1)
    for i in range(10):
        gauss[i] += Fraction(1)
    return gauss


def in_Qsqrt(plucker, gauss) -> bool:
    for c in plucker:
        y = None
        for k in range(1, 10):
            if gauss[k] == 0:
                continue
            yy = c[k] / gauss[k]
            if y is None:
                y = yy
            elif y != yy:
                return False
        if y is None:
            y = Fraction(0)
        x = c[0] - y * gauss[0]
        recon = z_add([x] + [Fraction(0)] * 9, z_scal(gauss, y))
        if not z_eq(recon, c):
            return False
    return True


def generate_group(generators, prime=P_MOD):
    identity = np.eye(6, dtype=np.int64) % prime
    seen = {identity.tobytes(): identity.copy()}
    queue = deque([identity])
    while queue:
        matrix = queue.popleft()
        for gen in generators:
            new = (matrix @ gen) % prime
            key = new.tobytes()
            if key not in seen:
                seen[key] = new
                queue.append(new)
    return list(seen.values())


def act_bivector(rho, pl, prime=P_MOD):
    mat = np.zeros((6, 6), dtype=np.int64)
    for idx, (i, j) in enumerate(PAIRS):
        mat[i, j] = int(pl[idx]) % prime
        mat[j, i] = (-int(pl[idx])) % prime
    transformed = (rho @ mat @ rho.T) % prime
    return np.array([int(transformed[i, j]) % prime for i, j in PAIRS], dtype=np.int64)


def dim_wedge_invariants(group, prime=P_MOD) -> int:
    rows = []
    for basis_index in range(15):
        pl = np.zeros(15, dtype=np.int64)
        pl[basis_index] = 1
        acc = np.zeros(15, dtype=np.int64)
        for rho in group:
            acc = (acc + act_bivector(rho, pl, prime)) % prime
        if np.any(acc):
            rows.append([int(x) for x in acc])
    matrix = [row[:] for row in rows]
    rank = 0
    for col in range(15):
        pivot = next(
            (i for i in range(rank, len(matrix)) if matrix[i][col] % prime),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inv = pow(matrix[rank][col], -1, prime)
        matrix[rank] = [(x * inv) % prime for x in matrix[rank]]
        for i in range(len(matrix)):
            if i != rank and matrix[i][col] % prime:
                factor = matrix[i][col]
                matrix[i] = [
                    (matrix[i][j] - factor * matrix[rank][j]) % prime
                    for j in range(15)
                ]
        rank += 1
    return sum(1 for row in matrix if any(x % prime for x in row))


def dim_V_invariants(group, prime=P_MOD) -> int:
    rows = []
    for basis_index in range(6):
        vec = np.zeros(6, dtype=np.int64)
        vec[basis_index] = 1
        acc = np.zeros(6, dtype=np.int64)
        for rho in group:
            acc = (acc + rho @ vec) % prime
        if np.any(acc):
            rows.append([int(x) for x in acc])
    matrix = [row[:] for row in rows]
    rank = 0
    for col in range(6):
        pivot = next(
            (i for i in range(rank, len(matrix)) if matrix[i][col] % prime),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inv = pow(matrix[rank][col], -1, prime)
        matrix[rank] = [(x * inv) % prime for x in matrix[rank]]
        for i in range(len(matrix)):
            if i != rank and matrix[i][col] % prime:
                factor = matrix[i][col]
                matrix[i] = [
                    (matrix[i][j] - factor * matrix[rank][j]) % prime
                    for j in range(6)
                ]
        rank += 1
    return sum(1 for row in matrix if any(x % prime for x in row))


def plucker_of_basis(b0, b1, prime=P_MOD):
    return np.array(
        [
            (int(b0[i]) * int(b1[j]) - int(b0[j]) * int(b1[i])) % prime
            for i, j in PAIRS
        ],
        dtype=np.int64,
    )


def same_plucker_mod(p, q, prime=P_MOD) -> bool:
    ratio = None
    for a, b in zip(p, q):
        a = int(a)
        b = int(b)
        if a == 0 and b == 0:
            continue
        if a == 0 or b == 0:
            return False
        r = (b * pow(a, -1, prime)) % prime
        if ratio is None:
            ratio = r
        elif r != ratio:
            return False
    return True


def main() -> None:
    descent = json.loads((HERE / "descent.json").read_text())
    exact = json.loads((C6 / "exact_points.json").read_text())
    status = (C6 / "STATUS.md").read_text()
    descent_md = (HERE / "DESCENT.md").read_text()

    assert descent["format"] == "c6-morita-descent-v1"
    assert descent["summary"]["marker"] == "C6-MORITA-DESCENT-OBSTRUCTION"
    assert descent["summary"]["any_K_proj_fano_point"] is False
    assert descent["summary"]["headline_bridge"] is False
    assert descent["summary"]["any_constant_G_equivariant"] is False
    assert "C6-MORITA-DESCENT-OBSTRUCTION" in descent_md
    assert "C6-POINT-HEADLINE-POSITIVE" not in status.splitlines()[0]
    assert not (C6 / "BRIDGE_FANO_POS.md").exists()

    # Hash binding for exact_points
    assert (
        descent["consumes_sha256"]["exact_points.json"]
        == sha256_file(C6 / "exact_points.json")
    )

    sources = load_sealed_sources()
    linear_forms = sources["pluecker"]["equations"]["linear_forms"]
    gauss = gauss_sum()
    assert z_eq(z_mul(gauss, gauss), [Fraction(-11)] + [Fraction(0)] * 9)

    fano = runpy.run_path(str(ROOT / "tmp/fano14_twist/fano_covariant_scan.py"))
    generators = [
        np.array(gen, dtype=np.int64) % P_MOD
        for gen in fano["six_dimensional_generators"]()
    ]
    group = generate_group(generators, P_MOD)
    assert len(group) == descent["group_action"]["group_order_generated"]
    assert dim_wedge_invariants(group) == 0
    assert dim_V_invariants(group) == 0
    assert descent["group_action"]["dim_invariants_wedge2_V"] == 0
    assert descent["group_action"]["dim_invariants_V"] == 0

    zeta = primitive_root_11(P_MOD)
    assert len(descent["lines"]) == len(exact["points"]) == 12

    for report, point in zip(descent["lines"], exact["points"]):
        assert report["u"] == point["u"]
        assert report["K_proj_fano_point_claimed"] is False
        assert report["constant_section_G_equivariant"] is False
        assert report["galois"]["projective_orbit_size"] == 2
        assert report["galois"]["stabilizer_size"] == 5
        assert report["galois"]["fixed_by_squares_subgroup"] is True
        assert report["plucker_in_Q_sqrt_m11"] is True

        u = point["u"]
        forms = forms_at_exact(
            sources["q_linear"], sources["frame_vectors"], (1, 2, 3, 4, 5)
        )
        assert minors_all_zero(forms, u)
        basis, rank = nullspace_exact(M_of_exact(forms, u))
        assert rank == 4 and len(basis) == 2
        plucker = normalize_plucker(plucker_field(basis[0], basis[1]))
        assert pluecker_hyperplanes_identically_zero(linear_forms, plucker)
        assert all(z_is_zero(rel) for rel in standard_plucker_quadrics(plucker))
        assert all(
            z_is_zero(omega_mixed(form, u, vector))
            for form in forms
            for vector in basis
        )
        assert orbit_size(plucker) == 2
        assert stab_size(plucker) == 5
        assert in_Qsqrt(plucker, gauss)

        # modular plane not full-group stable
        b0 = np.array([z_mod(c, P_MOD, zeta) for c in basis[0]], dtype=np.int64)
        b1 = np.array([z_mod(c, P_MOD, zeta) for c in basis[1]], dtype=np.int64)
        pl = plucker_of_basis(b0, b1)
        stab = sum(
            1
            for rho in group
            if same_plucker_mod(
                pl, plucker_of_basis(rho @ b0 % P_MOD, rho @ b1 % P_MOD)
            )
        )
        assert stab == report["modular_G_plane_stabilizer_order_p23"]
        assert stab < len(group)

    # Q(√-11) search residual claims
    qsearch = descent["Qsqrt_point_search"]
    assert qsearch["height1_genuine_count"] == 0
    assert qsearch["random_height2_genuine_count"] == 0
    assert qsearch["height1_projectively_Q_on_D"] >= 12

    # Spot-check: sealed rational u still on D multi-prime
    primes = [331, 419, 463]
    for prime in primes:
        z = primitive_root_11(prime)
        forms = build_forms_mod(
            sources["q_linear"],
            sources["frame_vectors"],
            (1, 2, 3, 4, 5),
            prime,
            z,
        )
        coeffs, _ = interpolate_quartic(forms, prime, seed=prime)
        for point in exact["points"]:
            u = [int(v) % prime for v in point["u"]]
            assert evaluate_quartic(coeffs, u, prime) == 0

    print("C6_MORITA_DESCENT_VERIFY_OK")
    print("C6_MORITA_DESCENT_OBSTRUCTION_CONFIRMED")
    print("C6_NO_KPROJ_FANO_POINT_CLAIMED")


if __name__ == "__main__":
    main()
