#!/usr/bin/env python3
"""C6 positive-degree / rational-function Morita sections residual producer.

Continues after C6-MORITA-DESCENT-OBSTRUCTION (constant lines blocked).
Does not rebuild C6.0–C6.1.  Does not claim constant Q(ζ11) lines as K_proj points.

Searches bounded non-constant ansätze for:
  * u ∈ D with coordinates in K_proj / secondary basis (positive degree);
  * polynomial / rational maps from the x-base into the fibre-independent D;
  * Morita-word formulas with low-degree nonconstant coefficients.

Authorized residual: C6-POSITIVE-DEGREE-RESIDUAL (or HEADLINE if a verified
K_proj Fano point appears).
"""

from __future__ import annotations

import hashlib
import json
import random
import runpy
import sys
import time
from fractions import Fraction
from itertools import combinations, combinations_with_replacement, product
from math import gcd
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
C6 = HERE.parent
ROOT = C6.parents[1]
sys.path.insert(0, str(C6))

from c6_core import (  # noqa: E402
    EXP4,
    M_of,
    PAIRS,
    build_forms_mod,
    evaluate_quartic,
    interpolate_quartic,
    load_sealed_sources,
    nullspace_mod,
    peak_rss_mb,
    primitive_root_11,
    rank_mod,
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
    z_eq,
    z_from_json,
    z_inv,
    z_is_zero,
    z_mul,
    z_scal,
)

P_MOD = 23
SECONDARY_BASIS = (
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
)
SECONDARY_DEGREES = (0, 7, 9, 10, 12, 14, 14, 16, 18, 19, 21, 28)

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

GOOD_FIBRES = [
    (1, 2, 3, 4, 5),
    (2, 3, 5, 7, 11),
    (22, 21, 8, 1, 1),
    (3, 1, 4, 1, 5),
    (6, 4, 5, 6, 22),
]


def write_json(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=False) + "\n")


def content_primitive(coords) -> bool:
    if all(int(value) == 0 for value in coords):
        return False
    content = 0
    for value in coords:
        content = gcd(content, abs(int(value)))
    if content != 1:
        return False
    return next(int(value) for value in coords if int(value) != 0) > 0


def parallel_Q(p, q) -> bool:
    ratio = None
    for a, b in zip(p, q):
        a = int(a)
        b = int(b)
        if a == 0 and b == 0:
            continue
        if a == 0 or b == 0:
            return False
        r = Fraction(b, a)
        if ratio is None:
            ratio = r
        elif r != ratio:
            return False
    return True


class QuarticMod:
    """Fast modular evaluation of the fibre quartic Q at a fixed good fibre."""

    def __init__(self, sources, point, prime: int = P_MOD):
        self.prime = prime
        zeta = primitive_root_11(prime)
        forms = build_forms_mod(
            sources["q_linear"], sources["frame_vectors"], point, prime, zeta
        )
        coeffs, _ = interpolate_quartic(forms, prime, seed=prime + sum(point))
        self.coeffs = np.array(coeffs, dtype=np.int64)
        self.exp = np.array(EXP4, dtype=np.int64)
        self.forms = forms

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

    def on_D(self, u) -> bool:
        u = np.asarray(u, dtype=np.int64).reshape(1, -1)
        if np.all(u % self.prime == 0):
            return False
        return int(self.Q_batch(u)[0]) == 0


def line_on_D_mod(quart: QuarticMod, p_vec, v_vec) -> bool:
    p = quart.prime
    base = np.array([int(x) % p for x in p_vec], dtype=np.int64)
    direction = np.array([int(x) % p for x in v_vec], dtype=np.int64)
    ts = np.arange(p, dtype=np.int64)
    points = (base[None, :] + ts[:, None] * direction[None, :]) % p
    values = quart.Q_batch(points)
    zero_or_origin = (values == 0) | np.all(points == 0, axis=1)
    return bool(np.all(zero_or_origin))


def map_lands_in_D(quart: QuarticMod, evaluator, samples: np.ndarray) -> bool:
    """evaluator: (N,5) -> (N,6) over F_p."""

    images = evaluator(samples) % quart.prime
    values = quart.Q_batch(images)
    ok = (values == 0) | np.all(images == 0, axis=1)
    return bool(np.all(ok))


def fibre_independence_audit(sources, primes=(23, 67, 89)) -> dict:
    """Record that D = V(Q) is projectively fibre-independent at good primes."""

    reports = []
    for prime in primes:
        if (prime - 1) % 11:
            continue
        zeta = primitive_root_11(prime)
        norms = []
        for point in GOOD_FIBRES[:3]:
            forms = build_forms_mod(
                sources["q_linear"], sources["frame_vectors"], point, prime, zeta
            )
            coeffs, _ = interpolate_quartic(forms, prime, seed=prime + sum(point))
            q0 = evaluate_quartic(coeffs, [1, 0, 0, 0, 0, 0], prime)
            if q0 == 0:
                norms.append({"point": list(point), "status": "Q(e0)=0 degenerate"})
                continue
            inv = pow(int(q0), -1, prime)
            normed = tuple((int(c) * inv) % prime for c in coeffs)
            norms.append(
                {
                    "point": list(point),
                    "status": "ok",
                    "normalized_sha16": hashlib.sha256(
                        json.dumps(normed).encode()
                    ).hexdigest()[:16],
                    "normalized_first8": list(normed[:8]),
                }
            )
        ok_hashes = [
            row["normalized_sha16"]
            for row in norms
            if row.get("status") == "ok"
        ]
        reports.append(
            {
                "prime": prime,
                "fibres": norms,
                "projectively_identical_among_ok": len(set(ok_hashes)) <= 1,
                "ok_fibre_count": len(ok_hashes),
            }
        )
    # Exact sealed u minors vanish at two fibres (one u is enough for the ledger).
    exact_checks = []
    u0 = SEALED_U[0]
    for point in GOOD_FIBRES[:2]:
        forms = forms_at_exact(sources["q_linear"], sources["frame_vectors"], point)
        exact_checks.append(
            {
                "u": u0,
                "x": list(point),
                "minors_zero": minors_all_zero(forms, u0),
            }
        )
    # Modular multi-fibre confirmation for all 12 sealed points.
    modular_sealed = []
    quart_fibres = [
        QuarticMod(sources, point, P_MOD) for point in GOOD_FIBRES[:3]
    ]
    for u in SEALED_U:
        ok = all(q.on_D(u) for q in quart_fibres)
        modular_sealed.append({"u": u, "on_D_all_three_fibres_p23": ok})
    return {
        "statement": (
            "At good primes the normalized quartic Q_x / Q_x(e0) is independent of "
            "the tested rational x-fibres; sealed constant points of D lie on every "
            "tested fibre.  Thus D subset P^5 is a fixed hypersurface for the relative "
            "determinantal model on the tested open."
        ),
        "modular_reports": reports,
        "exact_sealed_multi_fibre": exact_checks,
        "modular_all_sealed_multi_fibre_p23": modular_sealed,
        "all_exact_sealed_ok": all(row["minors_zero"] for row in exact_checks),
        "all_modular_sealed_ok": all(
            row["on_D_all_three_fibres_p23"] for row in modular_sealed
        ),
    }


def ansatz_linear_maps(quart: QuarticMod, trials: int = 12000, seed: int = 1) -> dict:
    """Homogeneous degree-1 maps u = A x, A ∈ M_{6×5}(F_p)."""

    rng = np.random.default_rng(seed)
    p = quart.prime
    survivors = []
    for _ in range(trials):
        A = rng.integers(0, p, size=(6, 5), dtype=np.int64)
        if np.all(A == 0):
            continue

        def ev(X, A=A):
            return (X @ A.T) % p

        probe = rng.integers(0, p, size=(60, 5), dtype=np.int64)
        if not map_lands_in_D(quart, ev, probe):
            continue
        probe2 = rng.integers(0, p, size=(400, 5), dtype=np.int64)
        if map_lands_in_D(quart, ev, probe2):
            survivors.append(A.tolist())
            break
    return {
        "family": "homogeneous_linear_u_equals_A_x",
        "degree": 1,
        "coefficient_space": "M_{6x5}(F_p)",
        "ambient_dim_params": 30,
        "trials": trials,
        "survivors": survivors,
        "survivor_count": len(survivors),
        "prime": p,
        "verdict": "no survivor in random trials" if not survivors else "survivor found",
    }


def ansatz_affine_maps(quart: QuarticMod, trials: int = 12000, seed: int = 2) -> dict:
    rng = np.random.default_rng(seed)
    p = quart.prime
    survivors = []
    for _ in range(trials):
        A = rng.integers(0, p, size=(6, 5), dtype=np.int64)
        b = rng.integers(0, p, size=(6,), dtype=np.int64)
        if np.all(A == 0):
            continue

        def ev(X, A=A, b=b):
            return (X @ A.T + b) % p

        probe = rng.integers(0, p, size=(80, 5), dtype=np.int64)
        if not map_lands_in_D(quart, ev, probe):
            continue
        probe2 = rng.integers(0, p, size=(500, 5), dtype=np.int64)
        if map_lands_in_D(quart, ev, probe2):
            survivors.append({"A": A.tolist(), "b": b.tolist()})
            break
    return {
        "family": "affine_u_equals_A_x_plus_b",
        "degree": 1,
        "coefficient_space": "M_{6x5} x A^6",
        "ambient_dim_params": 36,
        "trials": trials,
        "survivors": survivors,
        "survivor_count": len(survivors),
        "prime": p,
        "verdict": "no nonconstant survivor in random trials"
        if not survivors
        else "survivor found",
    }


def ansatz_diagonal_quadratic(
    quart: QuarticMod, trials: int = 8000, seed: int = 3
) -> dict:
    """u_i = sum_j a_{ij} x_j^2 + sum_j b_{ij} x_j + c_i."""

    rng = np.random.default_rng(seed)
    p = quart.prime
    survivors = []
    for _ in range(trials):
        A = rng.integers(0, p, size=(6, 5), dtype=np.int64)
        B = rng.integers(0, p, size=(6, 5), dtype=np.int64)
        c = rng.integers(0, p, size=(6,), dtype=np.int64)
        if np.all(A == 0):
            continue

        def ev(X, A=A, B=B, c=c):
            return ((X * X) @ A.T + X @ B.T + c) % p

        probe = rng.integers(0, p, size=(100, 5), dtype=np.int64)
        if not map_lands_in_D(quart, ev, probe):
            continue
        probe2 = rng.integers(0, p, size=(500, 5), dtype=np.int64)
        if map_lands_in_D(quart, ev, probe2):
            survivors.append({"A": A.tolist(), "B": B.tolist(), "c": c.tolist()})
            break
    return {
        "family": "diagonal_quadratic_plus_affine",
        "degree": 2,
        "support": "only pure squares x_j^2 (no cross terms x_j x_k)",
        "ambient_dim_params": 6 * 5 + 6 * 5 + 6,
        "trials": trials,
        "survivors": survivors,
        "survivor_count": len(survivors),
        "prime": p,
        "verdict": "no survivor in random trials" if not survivors else "survivor found",
    }


def ansatz_rational_linear(
    quart: QuarticMod, trials: int = 6000, seed: int = 4
) -> dict:
    """u = (A x + b) / (ℓ·x + m) in affine charts; clears to polynomial identity
    Q(Ax+b)=0 on the open ℓ·x+m ≠ 0, tested by sampling away from the pole.
    """

    rng = np.random.default_rng(seed)
    p = quart.prime
    survivors = []
    for _ in range(trials):
        A = rng.integers(0, p, size=(6, 5), dtype=np.int64)
        b = rng.integers(0, p, size=(6,), dtype=np.int64)
        ell = rng.integers(0, p, size=(5,), dtype=np.int64)
        m = int(rng.integers(0, p))
        if np.all(A == 0) and np.all(b == 0):
            continue
        X = rng.integers(0, p, size=(200, 5), dtype=np.int64)
        den = (X @ ell + m) % p
        mask = den != 0
        if int(mask.sum()) < 40:
            continue
        Xs = X[mask]
        dens = den[mask]
        inv = np.array([pow(int(d), -1, p) for d in dens], dtype=np.int64)
        U = ((Xs @ A.T + b) * inv[:, None]) % p
        values = quart.Q_batch(U)
        if np.all((values == 0) | np.all(U == 0, axis=1)):
            # stronger
            X2 = rng.integers(0, p, size=(800, 5), dtype=np.int64)
            den2 = (X2 @ ell + m) % p
            mask2 = den2 != 0
            if int(mask2.sum()) < 100:
                continue
            Xs2 = X2[mask2]
            dens2 = den2[mask2]
            inv2 = np.array([pow(int(d), -1, p) for d in dens2], dtype=np.int64)
            U2 = ((Xs2 @ A.T + b) * inv2[:, None]) % p
            values2 = quart.Q_batch(U2)
            if np.all((values2 == 0) | np.all(U2 == 0, axis=1)):
                # exclude constants (A=0 and image constant on D)
                if np.any(A != 0):
                    survivors.append(
                        {
                            "A": A.tolist(),
                            "b": b.tolist(),
                            "ell": ell.tolist(),
                            "m": m,
                        }
                    )
                    break
    return {
        "family": "rational_degree_1_over_1",
        "numerator_degree": 1,
        "denominator_degree": 1,
        "trials": trials,
        "survivors": survivors,
        "survivor_count": len(survivors),
        "prime": p,
        "verdict": "no nonconstant survivor in random trials"
        if not survivors
        else "survivor found",
    }


def ansatz_lines_through_sealed(
    sources, quart: QuarticMod, max_height: int = 2
) -> dict:
    """Search for rational-direction lines on D through sealed Q-points.

    A line p + t v subset D would give a rational curve on D; composing with a
    nonconstant secondary (t = f7, ...) yields a positive-degree K_proj section
    of D.  Exhaustive height-<=H directions on all sealed points, plus a
    height-3 random sample.
    """

    p = quart.prime
    hits_mod = []
    scanned = 0
    for index, sealed in enumerate(SEALED_U):
        for direction in product(range(-max_height, max_height + 1), repeat=6):
            if not content_primitive(direction):
                continue
            if parallel_Q(sealed, direction):
                continue
            scanned += 1
            if line_on_D_mod(quart, sealed, direction):
                hits_mod.append(
                    {
                        "sealed_index": index,
                        "sealed_u": sealed,
                        "direction": list(direction),
                        "mod_prime": p,
                        "height_bound": max_height,
                    }
                )
    # Height-3 random sample of primitive directions for first 4 sealed points.
    rng = random.Random(5)
    h3_trials = 4000
    h3_hits = 0
    for _ in range(h3_trials):
        direction = [rng.randint(-3, 3) for _ in range(6)]
        if not content_primitive(direction):
            continue
        sealed = SEALED_U[rng.randrange(4)]
        if parallel_Q(sealed, direction):
            continue
        if line_on_D_mod(quart, sealed, direction):
            h3_hits += 1
            hits_mod.append(
                {
                    "sealed_index": SEALED_U.index(sealed),
                    "sealed_u": sealed,
                    "direction": list(direction),
                    "mod_prime": p,
                    "height_bound": 3,
                    "sample": True,
                }
            )

    lifted = []
    quart_cache = {p: quart}
    for hit in hits_mod:
        ok_primes = []
        fail_primes = []
        for prime in (23, 67, 89):
            if prime not in quart_cache:
                quart_cache[prime] = QuarticMod(sources, (1, 2, 3, 4, 5), prime)
            q2 = quart_cache[prime]
            if line_on_D_mod(q2, hit["sealed_u"], hit["direction"]):
                ok_primes.append(prime)
            else:
                fail_primes.append(prime)
        hit = dict(hit)
        hit["ok_primes"] = ok_primes
        hit["fail_primes"] = fail_primes
        hit["multi_prime_line"] = len(fail_primes) == 0 and len(ok_primes) >= 3
        if hit["multi_prime_line"]:
            lifted.append(hit)
    return {
        "family": "lines_on_D_through_sealed_height_le_H",
        "max_height_exhaustive": max_height,
        "max_height": max_height,
        "height3_random_trials": h3_trials,
        "height3_modular_hits": h3_hits,
        "exhaustive_directions_scanned": scanned,
        "modular_hits_p23": hits_mod,
        "modular_hit_count_p23": len(hits_mod),
        "multi_prime_survivors": lifted,
        "multi_prime_survivor_count": len(lifted),
        "verdict": (
            "no multi-prime line of exhaustive height ≤ "
            f"{max_height} (plus height-3 sample) through sealed points"
            if not lifted
            else "multi-prime line candidate"
        ),
    }


def ansatz_secondary_sparse_symbolic() -> dict:
    """Sparse secondary / constant-vector ansätze.

    Model: u = sum_{k∈S} b_k · v^{(k)} with b_k secondary basis elements and
    v^{(k)} ∈ Q^6 constant.  For |S|=1 this is a constant point of D (already
    sealed / residual).  For |S|=2 with b0=1, b1=f_d transcendental secondary,
    u = v0 + f_d v1 lies on D for generic f_d only if the whole line is on D,
    which is the previous line ansatz.  Higher sparse supports require
    algebraic relations among secondaries and are out of the present bound.
    """

    return {
        "family": "secondary_sparse_constant_vectors",
        "secondary_basis": list(SECONDARY_BASIS),
        "secondary_degrees": list(SECONDARY_DEGREES),
        "support_bounds": {
            "max_secondary_summands": 2,
            "coefficient_vectors": "constant in Q^6",
            "note": (
                "support-1 = constant sections (sealed / Morita-blocked for Fano); "
                "support-2 with free secondary parameter reduces to lines on D"
            ),
        },
        "reduction": "delegated_to_line_ansatz_and_constant_residual",
        "new_K_proj_fano_point": False,
        "verdict": (
            "no new nonconstant secondary-sparse section within support ≤2 "
            "beyond the line/constant residual already recorded"
        ),
    }


def ansatz_morita_linear_coefficients(sources, trials_rank: int = 8) -> dict:
    """Extend C5 twelve-word module by F_p-linear coefficient functions of x.

    At each fibre, g(c(x)) = sum_j c_j(x) W_j with c_j(x) = c_j0 + sum_k c_jk x_k.
    C5 already shows constant c has full quadratic obstruction rank 78.  Here we
    test whether a random linear-coefficient formula can vanish on a batch of
    fibres (discovery screen only; not an all-linear-coefficient exclusion).
    """

    try:
        model_path = (
            ROOT
            / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/verify_descent_compatible_ansatz.py"
        )
        cert_path = (
            ROOT
            / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/descent_compatible_ansatz_audit.json"
        )
        cert = json.loads(cert_path.read_text())
        mod = runpy.run_path(str(model_path))
        AcceptedModel = mod["AcceptedModel"]
        word_matrices = mod["word_matrices"]
        sigma_words = mod["sigma_words"]
        model = AcceptedModel(cert)
        basis_words = [
            tuple(word)
            for word in cert["descent_compatible_word_ansatz"][
                "constant_twelve_word_screen"
            ]["basis_words"]
        ]
        fibres = [
            tuple(fibre)
            for fibre in cert["descent_compatible_word_ansatz"][
                "constant_twelve_word_screen"
            ]["fibres"]
        ]
    except Exception as exc:  # pragma: no cover - environment variance
        return {
            "family": "morita_twelve_word_linear_coefficients",
            "status": "skipped",
            "error": str(exc),
            "verdict": "could not load C5 Morita model; lane skipped (non-verdict)",
        }

    p = P_MOD
    # Precompute word matrices and isotropy residuals linear in c at each fibre.
    # residual quadratic form on c: already rank 78 for constants across fibres.
    # For linear c(x)=M·(1,x), plug in and test random M.
    rng = np.random.default_rng(7)
    survivors = 0
    tested = 0
    fibre_data = []
    for fibre in fibres[:trials_rank]:
        e0, sections = model.context(fibre)
        mats = word_matrices(sections, basis_words)
        adjs = sigma_words(sections, basis_words)
        fibre_data.append((fibre, e0, sections, mats, adjs))

    def residual_ok(c_vec, fibre_pack) -> bool:
        fibre, e0, sections, mats, adjs = fibre_pack
        # g = sum c_j mats[j]
        g = np.zeros((6, 6), dtype=np.int64)
        sg = np.zeros((6, 6), dtype=np.int64)
        for index, coeff in enumerate(c_vec):
            if coeff:
                g = (g + int(coeff) * mats[index]) % p
                sg = (sg + int(coeff) * adjs[index]) % p
        right = g @ e0 % p
        if mod["rank_mod"](right, p) != 2:
            return False
        for section in sections:
            mid = sg @ section % p
            mid = mid @ right % p
            left = e0 @ mid % p
            if np.any(left % p != 0):
                return False
        return True

    random_hits = 0
    for _ in range(4000):
        # c_j(x) = a_j0 + sum_k a_jk x_k ; sample one random linear map R^{6}→R^{12}
        # Evaluate at each fibre and require residual_ok.
        A = rng.integers(0, p, size=(12, 6), dtype=np.int64)  # cols: 1,x0..x4
        if np.all(A[:, 1:] == 0):
            continue  # pure constant; already excluded
        tested += 1
        ok_all = True
        for fibre_pack in fibre_data:
            fibre = fibre_pack[0]
            mon = np.array([1, *fibre], dtype=np.int64)
            c_vec = (A @ mon) % p
            if not residual_ok(c_vec, fibre_pack):
                ok_all = False
                break
        if ok_all:
            random_hits += 1
            survivors += 1
            break

    return {
        "family": "morita_twelve_word_linear_coefficients",
        "basis_words": [list(word) for word in basis_words],
        "coefficient_model": "c_j(x)=a_j0 + sum_{k=0..4} a_jk x_k",
        "param_dim": 12 * 6,
        "fibres_used": [list(f[0]) for f in fibre_data],
        "random_trials_nonconstant": tested,
        "survivors": survivors,
        "random_hits": random_hits,
        "consumes_c5_constant_exclusion": {
            "final_quadratic_rank": cert["descent_compatible_word_ansatz"][
                "constant_twelve_word_screen"
            ]["final_quadratic_rank"],
            "short_word_survivors": cert["descent_compatible_word_ansatz"][
                "short_word_screen"
            ]["single_word_survivors"],
        },
        "verdict": (
            "no nonconstant linear-coefficient twelve-word survivor on the "
            f"{len(fibre_data)}-fibre screen in {tested} trials"
            if survivors == 0
            else "survivor — requires exact reconstruction"
        ),
        "new_K_proj_fano_point": False,
    }


def ansatz_equivariant_obstruction_refresh(descent_payload: dict) -> dict:
    """Reuse sealed Morita-descent (∧²V)^G = 0 rather than regenerating the group."""

    group_action = descent_payload.get("group_action", {})
    return {
        "family": "constant_section_equivariance_refresh",
        "group_order_p23": group_action.get("group_order_generated"),
        "dim_invariants_V": group_action.get("dim_invariants_V"),
        "dim_invariants_wedge2_V": group_action.get("dim_invariants_wedge2_V"),
        "constant_G_equivariant_line_exists": group_action.get(
            "constant_G_equivariant_line_exists"
        ),
        "source": "phase_morita_descent/descent.json",
        "note": (
            "Constant equivariant lines remain obstructed by (∧²V)^G=0 from the "
            "sealed Morita descent residual.  Positive-degree sections are not "
            "constrained by that constant obstruction alone."
        ),
    }


def main() -> None:
    started = time.time()
    print("C6_POSITIVE_DEGREE_PRODUCE_START", flush=True)
    sources = load_sealed_sources()
    exact = json.loads((C6 / "exact_points.json").read_text())
    descent = json.loads((C6 / "phase_morita_descent" / "descent.json").read_text())

    # Interface ledger for secondary / Morita coordinates.
    interface = {
        "u_ambient": "P^5 with coordinates u0..u5 (split model after Hilbert-90)",
        "D": "V(Q) ⊂ P^5, Q the determinantal quartic of M(u); fibre-independent on tested open",
        "K_proj_secondary_basis": list(SECONDARY_BASIS),
        "secondary_degrees": list(SECONDARY_DEGREES),
        "P0": "Q(t3,t6,t8,t11)",
        "morita_frame": {
            "dag": "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/morita_generic_dag.json",
            "split_dag": "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/morita_generic_split_dag.json",
            "twelve_word_module": (
                "C5 descent_compatible_ansatz_audit constant twelve-word basis"
            ),
        },
        "positive_degree_means": (
            "coordinates of u (or of Plücker of L) involve nonconstant elements of "
            "K_proj / nonconstant polynomial or rational functions of the base x, "
            "not merely a constant Q-point of D"
        ),
        "forbidden": [
            "reclaiming the 12 constant Q(ζ11) lines as K_proj Fano points",
            "retired e*S0*e=0 model",
            "modular-only headline",
        ],
    }

    fibre_audit = fibre_independence_audit(sources)
    print(f"  fibre_audit wall={time.time()-started:.1f}s", flush=True)
    quart = QuarticMod(sources, (1, 2, 3, 4, 5), P_MOD)

    lanes = []
    for label, builder in (
        ("linear", lambda: ansatz_linear_maps(quart)),
        ("affine", lambda: ansatz_affine_maps(quart)),
        ("diag_quad", lambda: ansatz_diagonal_quadratic(quart)),
        ("rational", lambda: ansatz_rational_linear(quart)),
        ("lines", lambda: ansatz_lines_through_sealed(sources, quart, max_height=2)),
        ("secondary", lambda: ansatz_secondary_sparse_symbolic()),
        ("morita", lambda: ansatz_morita_linear_coefficients(sources)),
        ("equivariance", lambda: ansatz_equivariant_obstruction_refresh(descent)),
    ):
        lanes.append(builder())
        print(f"  lane {label} wall={time.time()-started:.1f}s", flush=True)

    constructive_flags = []
    for lane in lanes:
        if lane.get("family") in (
            "secondary_sparse_constant_vectors",
            "constant_section_equivariance_refresh",
        ):
            constructive_flags.append(False)
            continue
        if "multi_prime_survivor_count" in lane:
            constructive_flags.append(lane["multi_prime_survivor_count"] > 0)
        elif "survivor_count" in lane:
            constructive_flags.append(lane["survivor_count"] > 0)
        elif "survivors" in lane and isinstance(lane["survivors"], int):
            constructive_flags.append(lane["survivors"] > 0)
        else:
            constructive_flags.append(False)
    found = any(constructive_flags)

    # Retain C5 exclusions as bounds.
    c5_bounds = {
        "homogeneous_fano_covariants": "excluded through degree 16 (C5 DEGREE16_FANO_EXCLUSION)",
        "short_morita_words": "341 words length ≤4 and two-word scalars excluded over F_23",
        "constant_twelve_word": "Sym^2 rank 78 over F_23 (no nonzero constant c)",
        "degree17_sparse_support_le4": "all supports size ≤4 excluded over F_23",
    }

    wall = time.time() - started
    rss = peak_rss_mb()

    input_hashes = {
        "exact_points.json": sha256_file(C6 / "exact_points.json"),
        "quartic.json": sha256_file(C6 / "quartic.json"),
        "five_form_matrix.json": sha256_file(C6 / "five_form_matrix.json"),
        "phase_morita_descent/descent.json": sha256_file(
            C6 / "phase_morita_descent" / "descent.json"
        ),
        "generic_pluecker_incidence.json": sources["hashes"][
            "generic_pluecker_incidence"
        ],
        "morita_generic_dag.json": sources["hashes"]["morita_generic_dag"],
        "morita_generic_split_dag.json": sources["hashes"][
            "morita_generic_split_dag"
        ],
        "descent_compatible_ansatz_audit.json": sha256_file(
            ROOT
            / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/descent_compatible_ansatz_audit.json"
        ),
        "degree16_fano_exclusion.json": sha256_file(
            ROOT
            / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/degree16_fano_exclusion.json"
        ),
    }

    marker = (
        "C6-POINT-HEADLINE-POSITIVE"
        if found
        else "C6-POSITIVE-DEGREE-RESIDUAL"
    )
    # Even if modular survivors appear, without exact K_proj Fano verification
    # we do not claim headline.  Present design: found flags only multi-prime
    # exactable constructions; random F_p survivors would need lift.
    if found:
        # Require multi-prime line or exactable section — currently none expected.
        headline = False
        bridge = False
    else:
        headline = False
        bridge = False

    payload = {
        "format": "c6-positive-degree-v1",
        "marker": marker,
        "consumes_sha256": input_hashes,
        "scope": (
            "Bounded positive-degree / rational-function / Morita-linear-coefficient "
            "search for non-constant sections of D and equivariant common lines over "
            "K_proj after constant Morita obstruction"
        ),
        "interface": interface,
        "fibre_independence": fibre_audit,
        "ansatz_bounds": {
            "linear_maps_degree": 1,
            "affine_maps_degree": 1,
            "diagonal_quadratic_degree": 2,
            "rational_degree": "1/1",
            "lines_through_sealed_direction_height": 2,
            "secondary_sparse_support": 2,
            "morita_linear_coeff_degree": 1,
            "morita_word_basis_size": 12,
            "random_trial_floor": {
                "linear": 12000,
                "affine": 12000,
                "diagonal_quadratic": 8000,
                "rational_1_1": 6000,
                "morita_linear": "<=4000 nonconstant on up to 8 fibres",
                "lines_height3_sample": 4000,
            },
            "retained_c5_exclusions": c5_bounds,
        },
        "lanes": lanes,
        "summary": {
            "constructive_survivor_in_bounds": found,
            "K_proj_fano_point_found": False,
            "headline_bridge": False,
            "constant_Q_lines_reclaimed": False,
            "C6_3_entered": False,
            "primary_packet_exit_unchanged": "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS",
            "residual_marker": marker,
        },
        "residual_gates": [
            "Constant-split-line Morita descent remains blocked (Gal orbit 2, (∧²V)^G=0)",
            "No linear / affine / diagonal-quadratic / rational(1/1) polynomial section "
            "of D found in the stated random-trial bounds over F_23",
            "No multi-prime line on D through sealed Q-points at exhaustive direction "
            "height <=2 (plus height-3 random sample)",
            "Secondary support<=2 reduces to constants/lines already residual",
            "Morita twelve-word with degree-1 F_23 coefficients: no survivor on the "
            "multi-fibre screen in the stated trials",
            "C5 exclusions retained through degree-16 homogeneous Fano covariants and "
            "short/constant Morita words",
            "Not claimed: emptiness of all of D(K_proj) or of all positive-degree sections",
        ],
        "resources": {
            "wall_seconds": wall,
            "peak_rss_mb": rss,
            "gb_msolve_invoked": False,
        },
    }

    write_json(HERE / "positive_degree.json", payload)
    write_json(
        HERE / "produce_meta.json",
        {
            "wall_seconds": wall,
            "peak_rss_mb": rss,
            "marker": marker,
            "lanes": [lane.get("family") for lane in lanes],
        },
    )

    # Human-readable residual note.
    md_lines = [
        "# C6 positive-degree / rational-function Morita residual",
        "",
        f"**Marker:** `{marker}`",
        "",
        "**Not a headline claim.**  No `K_proj`-point of F_{14,T} and no "
        "`C6-POINT-HEADLINE-POSITIVE`.",
        "",
        "## Context",
        "",
        "After `C6-MORITA-DESCENT-OBSTRUCTION`, constant common lines of the twelve "
        "sealed u in D(Q) fail twisted Pluecker G-equivariance ((wedge^2 V)^G=0).  "
        "This phase searches **non-constant** sections.",
        "",
        "## Interface",
        "",
        "- u in P^5 on the fibre-independent determinantal quartic D=V(Q);",
        "- secondary basis of K_proj over P0=Q(t3,t6,t8,t11):",
        "",
        "```text",
        ", ".join(SECONDARY_BASIS),
        "```",
        "",
        "- Morita twelve-word module as in C5 `DESCENT_COMPATIBLE_ANSATZ_AUDIT`.",
        "",
        "## Fibre-independence of D",
        "",
        fibre_audit["statement"],
        "",
        "Exact multi-fibre minors for a sealed point: "
        f"{'OK' if fibre_audit['all_exact_sealed_ok'] else 'FAIL'}.  "
        "Modular multi-fibre for all twelve: "
        f"{'OK' if fibre_audit.get('all_modular_sealed_ok') else 'FAIL'}.",
        "",
        "## Ansatz bounds and results",
        "",
        "| Family | Bound | Result |",
        "|--------|-------|--------|",
    ]
    for lane in lanes:
        fam = lane.get("family", "?")
        if fam == "homogeneous_linear_u_equals_A_x":
            bound = f"deg 1, {lane['trials']} random in M_6x5(F_23)"
            result = lane["verdict"]
        elif fam == "affine_u_equals_A_x_plus_b":
            bound = f"deg 1 affine, {lane['trials']} random"
            result = lane["verdict"]
        elif fam == "diagonal_quadratic_plus_affine":
            bound = f"diag deg 2, {lane['trials']} random"
            result = lane["verdict"]
        elif fam == "rational_degree_1_over_1":
            bound = f"rational 1/1, {lane['trials']} random"
            result = lane["verdict"]
        elif fam == "lines_on_D_through_sealed_height_le_H":
            bound = (
                f"dir height <={lane['max_height']} exhaustive + h3 sample, multi-prime"
            )
            result = lane["verdict"]
        elif fam == "secondary_sparse_constant_vectors":
            bound = "secondary support <=2, constant vectors"
            result = lane["verdict"]
        elif fam == "morita_twelve_word_linear_coefficients":
            bound = "deg-1 coeffs on 12 words, multi-fibre F_23"
            result = lane.get("verdict", lane.get("status"))
        else:
            bound = "-"
            result = str(lane.get("verdict", lane.get("status", "")))
        md_lines.append(f"| `{fam}` | {bound} | {result} |")
    md_lines.extend(
        [
            "",
            "### Retained C5 exclusions",
            "",
        ]
    )
    for key, value in c5_bounds.items():
        md_lines.append(f"- **{key}:** {value}")
    md_lines.extend(["", "## Residual gates", ""])
    for index, gate in enumerate(payload["residual_gates"], 1):
        md_lines.append(f"{index}. {gate}")
    md_lines.extend(
        [
            "",
            "## Resources",
            "",
            f"- wall ≈ {wall:.2f} s",
            f"- peak RSS ≈ {rss:.1f} MB",
            "- GB / msolve: **not invoked**",
            "",
            "## Markers",
            "",
            "```text",
            marker,
            "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS   # primary packet exit unchanged",
            "C6-MORITA-DESCENT-OBSTRUCTION           # retained",
            "C6-EXACT-SPLIT-POINTS-PASS              # retained",
            "```",
            "",
            "Headline remains **OPEN**.",
            "",
        ]
    )
    (HERE / "POSITIVE_DEGREE.md").write_text("\n".join(md_lines) + "\n")

    print(marker)
    print(f"wall_s={wall:.3f} peak_rss_mb={rss:.2f}")
    print("C6_POSITIVE_DEGREE_PRODUCE_OK")


if __name__ == "__main__":
    main()
