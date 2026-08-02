#!/usr/bin/env python3
"""H6A producer: projective degree-11 torus isogeny + kernel/Galois (H6.0)."""
from __future__ import annotations

import json
import random
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H4 = ROOT / "goal_runs_after_35fa/H_11_5_TWIST"


def cycle_matrix(n: int = 5) -> sp.Matrix:
    M = sp.zeros(n)
    for i in range(n):
        M[i, (i - 1) % n] = 1
    return M


def poly_mat(coeffs, S):
    acc = sp.zeros(S.rows)
    Sk = sp.eye(S.rows)
    for c in coeffs:
        if c:
            acc = acc + c * Sk
        Sk = Sk * S
    return acc


def restrict(op, basis):
    cols = []
    for j in range(4):
        w = op * sp.Matrix(basis[j])
        xs = [int(w[i]) for i in range(4)]
        assert int(w[4]) == -sum(xs)
        cols.append(xs)
    return sp.Matrix(cols).T


def denom_vec(v):
    d = 1
    for i in range(v.rows):
        den = int(sp.fraction(sp.together(v[i]))[1])
        d = int(sp.ilcm(d, abs(den)))
    return d


def modular_kernel_witness(c_exp, p: int) -> dict:
    zeta = None
    for g in range(2, p):
        z = pow(g, (p - 1) // 11, p)
        if z != 1 and pow(z, 11, p) == 1:
            zeta = z
            break
    assert zeta is not None
    a = [pow(zeta, c_exp[i] % 11, p) for i in range(5)]
    prod = 1
    for x in a:
        prod = (prod * x) % p
    assert prod == 1
    for i in range(5):
        assert (pow(a[i], 2, p) * a[(i - 1) % 5]) % p == 1
    return {"prime": p, "zeta11": zeta, "a": a, "psi_a_equals_1": True}


def main() -> None:
    S = cycle_matrix(5)
    A = poly_mat([2, 1, 0, 0, 0], S)
    B = poly_mat([5, -3, 1, -1, 0], S)
    N = poly_mat([1, 1, 1, 1, 1], S)
    assert A * B == 11 * sp.eye(5) - N
    assert B * A == 11 * sp.eye(5) - N

    basis = [
        [1 if j == i else (-1 if j == 4 else 0) for j in range(5)] for i in range(4)
    ]
    A_aug = restrict(A, basis)
    B_aug = restrict(B, basis)
    S_aug = restrict(S, basis)
    det_A = int(A_aug.det())
    assert abs(det_A) == 11
    assert A_aug * B_aug == 11 * sp.eye(4)

    Ainv = A_aug.inv()
    e0 = sp.Matrix(4, 1, [1, 0, 0, 0])
    assert denom_vec(Ainv * e0) == 11
    Se = S_aug * e0
    k_act = next(
        k for k in range(11) if denom_vec(Ainv * (Se - k * e0)) == 1
    )
    x, o = k_act % 11, 1
    while x != 1:
        x = (x * k_act) % 11
        o += 1
    assert o == 5

    c_exp = [5, 3, 4, 9, 1]
    assert sum(c_exp) % 11 == 0
    assert all(
        sum(int(A[i, j]) * c_exp[j] for j in range(5)) % 11 == 0 for i in range(5)
    )
    c_shift = [c_exp[(i - 1) % 5] for i in range(5)]
    lam = next(
        L
        for L in range(11)
        if all((c_shift[i] - L * c_exp[i]) % 11 == 0 for i in range(5))
    )
    assert lam == k_act

    samples = []
    for vec in (
        [1, -1, 0, 0, 0],
        [1, 0, -1, 0, 0],
        [1, 1, 1, 1, -4],
        [2, -1, -1, 0, 0],
    ):
        v = sp.Matrix(vec)
        assert B * (A * v) == 11 * v
        samples.append(
            {
                "v": vec,
                "A_v": [int(x) for x in A * v],
                "B_A_v": [int(x) for x in B * (A * v)],
                "equals_11v": True,
            }
        )

    fm = json.loads((H4 / "field_model.json").read_text())
    nm = json.loads((H4 / "norm_model.json").read_text())
    ff = fm.get("finite_field_inverse_map_witness", {})
    cic = nm.get("coefficient_isogeny_class", {})

    rng = random.Random(0)
    samples_mult = []
    for p in (89, 67, 23):
        r = [rng.randrange(1, p) for _ in range(4)]
        r.append(pow(r[0] * r[1] * r[2] * r[3] % p, -1, p))
        psi = [(pow(r[i], 2, p) * r[(i - 1) % 5]) % p for i in range(5)]
        samples_mult.append(
            {"p": p, "r": r, "psi_componentwise": psi, "prod_r": 1}
        )

    payload = {
        "schema": "h6a-projective-11-isogeny-v1",
        "group": "C5=<sigma>",
        "group_ring_identity": {
            "left": "(2+sigma)*(5-3*sigma+sigma^2-sigma^3)",
            "right": "11-(1+sigma+sigma^2+sigma^3+sigma^4)",
            "verified_as_matrices": True,
        },
        "operators": {
            "sigma_cycle_matrix": [[int(S[i, j]) for j in range(5)] for i in range(5)],
            "A_2_plus_sigma": [[int(A[i, j]) for j in range(5)] for i in range(5)],
            "B_dual": [[int(B[i, j]) for j in range(5)] for i in range(5)],
            "N_norm": [[int(N[i, j]) for j in range(5)] for i in range(5)],
            "A_coeffs_sigma_powers": [2, 1, 0, 0, 0],
            "B_coeffs_sigma_powers": [5, -3, 1, -1, 0],
        },
        "projective_torus": {
            "description": (
                "Product-one torus with sigma(r_i)=r_{i+1} (H4); character lattice "
                "L={m in Z^5: sum m_i=0}"
            ),
            "character_lattice_basis": basis,
            "map_phi_on_characters": "A = 2I + sigma",
            "dual_on_characters": "B = 5I - 3 sigma + sigma^2 - sigma^3",
            "multiplicative_psi": "psi(r)_i = r_i^2 * r_{i-1}",
        },
        "augmentation_restriction": {
            "A_aug": [[int(A_aug[i, j]) for j in range(4)] for i in range(4)],
            "B_aug": [[int(B_aug[i, j]) for j in range(4)] for i in range(4)],
            "S_aug": [[int(S_aug[i, j]) for j in range(4)] for i in range(4)],
            "det_A_aug": det_A,
            "A_B_equals_11_I": True,
            "isogeny_degree": 11,
            "smith_normal_form_diagonal": [1, 1, 1, 11],
        },
        "kernel": {
            "group_scheme": (
                "etale mu_11 (order-11 multiplicative kernel of phi on the "
                "projective/norm-1 torus over alg closed fields)"
            ),
            "galois_module": (
                "Z/11Z with C5-action by multiplication by unit k in (Z/11Z)* "
                "of order 5"
            ),
            "coker_of_A_on_L": {
                "group": "Z/11Z",
                "generator_class": (
                    "class of e0=(1,0,0,0) in Z^4 / A_aug(Z^4) (augmentation coords)"
                ),
                "order_of_generator": 11,
                "sigma_action_multiplier_k": k_act,
                "order_of_k_in_F11_star": o,
                "check": "S_aug [e0] = k [e0] in coker",
            },
            "geometric_kernel_exponents": {
                "description": (
                    "Over alg closed field, a_i=zeta^{c_i} for primitive 11th root "
                    "zeta lies in ker psi on the product-one torus and generates "
                    "the order-11 etale kernel."
                ),
                "c": c_exp,
                "sum_c_mod_11": sum(c_exp) % 11,
                "A_c_mod_11": [0, 0, 0, 0, 0],
                "sigma_action_on_exponents": {
                    "rule": "(sigma.a)_i = a_{i-1} => c |-> (c_{i-1})_i",
                    "multiplier_lambda": lam,
                    "c_shifted": c_shift,
                },
            },
            "resolvent": {
                "presentation": (
                    "X^11 - 1 = 0 for the mu_11 coordinate on the kernel "
                    "(after choosing zeta)"
                ),
                "C5_semidirect": (
                    f"sigma(X) = X^{lam} on the mu_11 generator X=zeta"
                ),
                "note": (
                    "Resolvent of the torsor class over the trace hyperplane is "
                    "H6.1, not H6.0"
                ),
            },
            "modular_kernel_witnesses": [
                modular_kernel_witness(c_exp, 23),
                modular_kernel_witness(c_exp, 67),
            ],
        },
        "scalar_vs_projective": {
            "det_A_on_Z5": int(A.det()),
            "factorization": "33 = 3 * 11",
            "projective_degree": 11,
            "scalar_diagonal_factor": 3,
            "note": (
                "Full map d |-> d^2 sigma(d) on E^* has degree 33; projectivized "
                "torus isogeny degree is 11."
            ),
        },
        "inverse_up_to_11": {
            "statement": "B o A = A o B = [11] on the projective/augmentation torus",
            "samples": samples,
        },
        "h4_field_binding": {
            "field_model_path": "goal_runs_after_35fa/H_11_5_TWIST/field_model.json",
            "norm_model_path": "goal_runs_after_35fa/H_11_5_TWIST/norm_model.json",
            "format_field": fm.get("format"),
            "format_norm": nm.get("format"),
            "E": fm["fields"]["E"],
            "K": fm["fields"]["K"],
            "sigma_action_r": fm["C11_invariants"]["sigma_action"],
            "r_formula": fm["C11_invariants"]["formula"],
            "product_relation": fm["C11_invariants"]["product_relation"],
            "r_exponent_vectors": fm["C11_invariants"]["exponent_vectors"],
            "four_by_four_exponent_determinant": fm["C11_invariants"][
                "four_by_four_exponent_determinant"
            ],
            "trace_coefficient_c": nm["cyclic_coefficient"],
            "coefficient_isogeny_class": {
                "degree": cic.get("degree"),
                "order_11_witness": cic.get("order_11_witness"),
                "conclusion": cic.get("conclusion"),
            },
            "finite_field_witness_prime": ff.get("prime"),
            "multiplicative_psi_samples": samples_mult,
        },
        "multiplicative_formulas": {
            "phi": "[a] |-> [a^2 * sigma(a)]",
            "component_on_product_one_torus": "psi(r)_i = r_i^2 * r_{i-1}",
            "dual_from_group_ring": "B = 5 - 3 sigma + sigma^2 - sigma^3",
        },
        "scope": "H6.0 structural isogeny only; no torsor decision, no point/pointless",
    }
    (HERE / "isogeny.json").write_text(json.dumps(payload, indent=2) + "\n")
    print("H6A_PRODUCE_ISOGENY_OK")
    print("det_A_aug", det_A, "k_act", k_act, "lam", lam)


if __name__ == "__main__":
    main()
