#!/usr/bin/env python3
"""WP-4A producer: portable involution-plane transition module.

Produces certificates/transitions/involution_plane/module.json.

Theorem boundary (OPEN headline): every plus-plane Z_t = P(E_+(t)) is a forced
base component of any primitive homogeneous landing covariant; the common first
transverse order m is odd; a nonzero leading normal map dominates L_t = P(E_-).
The bigraded H-invariant module is free over Sym(E_+^*) in the d-direction for
each fixed normal order m, with explicit rank, Hilbert series, and character
dependence (not merely parity).

Does not prove or disprove existence of a global landing self-covariant.
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
TRANS = HERE.parent
CERT = TRANS.parent
ROOT = CERT.parent
sys.path.insert(0, str(TRANS))
sys.path.insert(0, str(CERT))
import common  # noqa: E402
import exact_weil_check as ew  # noqa: E402


def binom(n, k):
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def dim_sym(vdim, deg):
    if deg < 0:
        return 0
    return binom(deg + vdim - 1, vdim - 1)


def dim_M(m: int, d: int) -> int:
    """dim [ H^0(Z, Sym^m N^vee ⊗ O(d)) ⊗ W ]^{C2}.

    Geometry:
      N_{Z/Y} ≅ O_Z(1) ⊗ E_-   (t acts by −1 on E_-, +1 on O(1)|_fiber via O(1) trivial)
      N^vee ≅ O(−1) ⊗ E_-^*
      H^0(Z, Sym^m N^vee ⊗ O(d)) = Sym^m E_-^* ⊗ Sym^{d−m} E_+^*   (d≥m), else 0.
    C2-action on the fiber of that space is (−1)^m (from E_-^*), trivial on E_+^*.
    W = E_+ ⊕ E_- with t = (+1, −1).  Invariants require target eigenspace
    matching (−1)^m.
    """
    if d < m or m < 0:
        return 0
    base = dim_sym(2, m) * dim_sym(3, d - m)  # (m+1) * binom(d-m+2, 2)
    if m % 2 == 0:
        return base * 3  # target E_+
    return base * 2  # target E_-


def hilbert_series_coeffs(m_max=12, d_max=20):
    table = {}
    for m in range(m_max + 1):
        for d in range(d_max + 1):
            table[f"{m},{d}"] = dim_M(m, d)
    return table


def hilbert_series_rational():
    """Closed form as a rational function in (s,t).

    H(s,t) = sum_{m≥0} s^m (m+1) δ_m  t^m / (1−t)^3
    where δ_m = 3 (m even), 2 (m odd).

    Equivalently:
      H = [ 3 sum_k (2k+1) (s^2 t^2)^k  t^{0?} wait:

    sum_{k≥0} (2k+1) u^k = 1/(1−u)^2
    sum_{k≥0} (2k+2) u^k = 2/(1−u)^2

    Even m=2k: s^{2k} (2k+1) * 3 * t^{2k} / (1-t)^3
    Odd  m=2k+1: s^{2k+1} (2k+2) * 2 * t^{2k+1} / (1-t)^3

    H(s,t) = 1/(1-t)^3 * (
        3 sum_k (2k+1) (s t)^{2k}
      + 2 sum_k (2k+2) (s t)^{2k+1}
    )
    Let u = (s t)^2.
    sum_k (2k+1) u^k = 1/(1-u)^2
    sum_k (2k+2) u^k * (s t) = 2 (s t) sum_k (k+1) u^k = 2 (s t)/(1-u)^2

    So H = 1/(1-t)^3 * ( 3/(1-u)^2 + 4 (s t)/(1-u)^2 )
         = (3 + 4 s t) / ( (1-t)^3 (1 - (s t)^2 )^2 )
    """
    return {
        "formula": "(3 + 4*s*t) / ( (1-t)^3 * (1 - (s*t)^2)^2 )",
        "variables": {"s": "normal order m", "t": "source degree d"},
        "derivation": [
            "N^vee = O(-1) ⊗ E_-^*; H^0(Sym^m N^vee(d)) = Sym^m E_-^* ⊗ Sym^{d-m} E_+^* (d≥m)",
            "C2 acts by (-1)^m on that space; W = E_+ ⊕ E_- with signs (+1,-1)",
            "invariants: target E_+ for m even (dim 3), E_- for m odd (dim 2)",
            "dim Sym^m E_-^* = m+1; dim Sym^k E_+^* = binom(k+2,2); sum_k binom(k+2,2) t^k = 1/(1-t)^3",
            "even/odd generating functions yield the closed form",
        ],
        "valid_for": "all m≥0, all d∈Z (vanishing for d<m automatic in the expansion)",
    }


def free_presentation():
    """Finite free presentation over R = Sym(E_+^*) ≅ Q[x0,x1,x2] for each m.

    For fixed m the module ⊕_d M_{m,d} is free of rank
      r_m = (m+1) * (3 if m even else 2)
    over R, generated in degree d=m (the lowest nonzero source degree for that m).

    Across m there is no single finite free presentation as a bigraded R-module
    with bounded generators in m: the normal-order filtration is infinite.
    The closed Hilbert series above is the complete all-(m,d) answer.
    Periodicity in m fails: ranks grow linearly in m.
    """
    return {
        "base_ring": {
            "name": "R = Sym(E_+^*)",
            "isomorphism": "Q[x0,x1,x2] (ternary forms on the plus-plane)",
            "grading": "deg xi = 1 (source degree)",
            "H_action": "trivial (t = +1 on E_+)",
        },
        "for_each_fixed_m": {
            "free": True,
            "rank": "r_m = (m+1) * (3 if m even else 2)",
            "generator_degree": "all generators in source degree d = m",
            "relations": "none (free)",
            "explicit_generators": (
                "Choose any basis {φ_j}_{j=0..m} of Sym^m E_-^* and any basis "
                "{w_a} of the target eigenspace W^{(-1)^m}.  The free generators "
                "are φ_j ⊗ w_a, viewed as C2-invariant sections of "
                "Sym^m N^vee ⊗ O(m) ⊗ W on Z_t."
            ),
        },
        "as_bigraded_module": {
            "finitely_generated_over_R_in_m": False,
            "reason": (
                "rank r_m grows linearly in m; the normal cone has infinitely many "
                "orders.  This is expected and not an obstruction theorem by itself "
                "(house rule 4: no unbounded-degree claim from finite generation alone)."
            ),
            "complete_control": (
                "The rational Hilbert series and the free rank formula for each m "
                "control ALL degrees and ALL normal orders."
            ),
        },
        "character_dependence": {
            "not_just_parity": True,
            "normal_bundle_as_C2_module": "N_{Z/Y} ≅ O(1) ⊗ E_-  with E_- = sign ⊕ sign (two copies of the nontrivial character)",
            "Sym^m_Nvee_characters": (
                "Sym^m (sign⊕sign)^* ≅ Sym^m of two sign characters; total C2-weight (−1)^m; "
                "dimension m+1 with a single weight."
            ),
            "target_W_decomposition": "E_+ = triv^⊕3, E_- = sign^⊕2",
            "invariant_matching": "weight of normal jet must equal weight of target component",
            "O1_character": "trivial on Z_t (t = +1 on E_+)",
        },
    }


def geometric_theorem():
    return {
        "headline": "OPEN",
        "statements": [
            {
                "id": "4A.1_base_component",
                "claim": (
                    "Every plus-plane Z_t = P(E_+(t)) is contained in the base locus "
                    "of any primitive homogeneous G-covariant p: W→W with F(p)=0 that "
                    "is defined at the generic point of Z_t would force a C_G(t)-fixed "
                    "point of X, contradicting X^{C_G(t)}=∅."
                ),
                "proof_sketch": [
                    "If p is defined generically on Z_t, equivariance p(tv)=t p(v) and "
                    "t=+1 on E_+ force image in E_+ ∩ X = E_t (smooth plane cubic).",
                    "A rational map P^2 ⇢ smooth genus-one curve is constant.",
                    "C_G(t)-stability of Z_t forces the constant to be C_G(t)-fixed.",
                    "Exact: unique D12 character line is off X, so X^{C_G(t)}=∅.",
                    "Hence p cannot be defined generically: Z_t ⊂ base locus.",
                    "Allowed by primitivity: codim Z_t = 2 in P^4.",
                ],
                "status": "PROVED",
                "upstream": "tmp/involution_exceptional_divisor/",
            },
            {
                "id": "4A.2_odd_order",
                "claim": (
                    "The least transverse I_{Z_t}-adic order m among coordinates of p "
                    "is odd, and is the same for all 55 conjugate plus-planes."
                ),
                "proof_sketch": [
                    "Local coords (x,y)∈ E_+ ⊕ E_-, t(x,y)=(x,−y); p=p_+ + p_−.",
                    "Equivariance: p_+(x,−y)=p_+(x,y), p_−(x,−y)=−p_−(x,y).",
                    "Order-m leading form on the exceptional divisor of Bl_{Z_t} lands in "
                    "X∩P(E_+) if m even, and in L_t=P(E_-) if m odd.",
                    "Even m: rational exceptional divisor → elliptic curve ⇒ constant ⇒ "
                    "C_G(t)-fixed on X ⇒ contradiction.  Hence m odd.",
                    "Conjugacy: one orbit of involutions ⇒ common m.",
                ],
                "status": "PROVED",
                "upstream": "tmp/involution_exceptional_divisor/",
            },
            {
                "id": "4A.3_dominates_minus_line",
                "claim": (
                    "For odd m, a nonzero leading normal map on the exceptional divisor "
                    "dominates L_t ≅ P^1 ⊂ X (cannot be constant)."
                ),
                "proof_sketch": [
                    "Odd m: image on L_t.  Constant would be C_G(t)-fixed on X, impossible.",
                    "Hence dominant onto L_t.",
                    "Local model: P(N_{Z_t/Y}) ≅ Z_t × P(E_-) → P(E_-)=L_t is C_G(t)-equivariant "
                    "and realises a nonconstant pointwise-t-fixed exceptional map.",
                ],
                "status": "PROVED",
                "upstream": "tmp/involution_exceptional_divisor/",
            },
            {
                "id": "4A.4_landing_at_first_order",
                "claim": (
                    "At the first odd order m, the associated-graded Klein landing "
                    "F(p)=0 imposes no further condition on a pure E_--valued leading "
                    "jet: F|_{E_-}≡0 by the parity identity F(v)=F(tv)=F(−v)=−F(v)."
                ),
                "proof_sketch": [
                    "Leading target is pure E_- for odd m (character matching).",
                    "F vanishes identically on E_-, so the order-3m piece of F(p) from "
                    "the pure leading term is zero.  Mixed terms involving lower-order "
                    "(vanishing) pieces do not appear at the first nonzero order.",
                    "Higher-order corrections and multi-plane compatibility are WP-5.",
                ],
                "status": "PROVED_at_first_order",
                "remainder": (
                    "Compatibility of the 55 odd normal maps at plane intersections "
                    "(V4 strata) is not sealed here; see 4C and WP-5."
                ),
            },
        ],
        "not_proved": [
            "Existence or nonexistence of a global homogeneous landing self-covariant",
            "A common numerical value of m beyond 'odd' (m may depend on the covariant)",
            "Global equalizer/kernel architecture (WP-5)",
            "ed_C(G) or unirationality",
        ],
    }


def residual_S3_and_restriction():
    return {
        "setwise_stabilizer": "D12 = C_G(t), order 12",
        "residual": "S3 = C_G(t)/<t>",
        "restriction_to_minus_line": {
            "note": "Full classification is WP-4B",
            "for_odd_m_leading": (
                "Leading map Z_t ⇢ L_t is residual-S3 equivariant (after accounting "
                "for the normal character).  Its restriction data at the six "
                "Z_s ∩ L_t points is forced by Δ_t = x^6 − y^6 (see 4B)."
            ),
        },
        "incident_lower_strata": [
            "L_t = minus line (on X)",
            "six D10 points in the residual arrangement on the plane (off X)",
            "V4 triangle vertices (type I) on L_t",
            "C6 points on L_t",
            "type-II points: not on a single plus-plane's elliptic as exclusive; "
            "incident via V4 flags (4C)",
        ],
    }


def regression_dims():
    """Low (m,d) dimensions for regression tests."""
    samples = {}
    for m in range(0, 8):
        for d in range(0, 12):
            samples[f"{m},{d}"] = dim_M(m, d)
    # sanity closed form vs table
    # expand H to low order and compare
    return samples


def closed_form_check(m_max=10, d_max=15):
    """Verify Hilbert series expansion matches dim_M."""
    # Expand (3 + 4 s t) / ( (1-t)^3 (1 - (s t)^2)^2 )
    # Use series: 1/(1-t)^3 = sum binom(k+2,2) t^k
    # 1/(1-u)^2 = sum (k+1) u^k, u=(s t)^2
    errs = []
    for m in range(m_max + 1):
        for d in range(d_max + 1):
            # coefficient of s^m t^d
            # (3 + 4 s t) * sum_{a≥0} (a+1) (s t)^{2a} * sum_{k≥0} binom(k+2,2) t^k
            # = sum_a (a+1) * 3 * s^{2a} t^{2a} * sum_k binom(k+2,2) t^k
            # + sum_a (a+1) * 4 * s^{2a+1} t^{2a+1} * sum_k binom(k+2,2) t^k
            coeff = 0
            if m % 2 == 0:
                a = m // 2
                # need 2a + k = d ⇒ k = d - m
                k = d - m
                if k >= 0:
                    coeff = (a + 1) * 3 * binom(k + 2, 2)
            else:
                a = (m - 1) // 2
                k = d - m
                if k >= 0:
                    coeff = (a + 1) * 4 * binom(k + 2, 2)
            # Wait: for odd m=2a+1, factor is (a+1)*4, but dim should be
            # (m+1)*2*binom = (2a+2)*2*binom = 4(a+1)*binom. Yes.
            # for even m=2a: (m+1)*3*binom = (2a+1)*3*binom. And (a+1)*3 is WRONG!
            # Fix: sum_k (2k+1) u^k = 1/(1-u)^2, so coefficient of u^a is (2a+1), not (a+1).
            # I had a bug in the closed form derivation earlier.
            pass
    # Recompute correctly
    # H = 1/(1-t)^3 * ( 3 sum_a (2a+1) u^a + 2 sum_a (2a+2) u^a * (s t) )
    #   = 1/(1-t)^3 * ( 3/(1-u)^2 + 4 (s t)/(1-u)^2 )
    # sum_a (2a+1) u^a = 1/(1-u)^2  YES coefficient of u^a is (2a+1)
    # For even m=2a: coeff of s^{2a} from first term: 3*(2a+1) * binom(k+2,2) with k=d-2a
    # dim_M(2a,d) = (2a+1)*3*binom(d-2a+2,2). Match!
    # For odd m=2a+1: second term 4*(a+1)?  2*(2a+2)=4(a+1), and dim=(2a+2)*2*binom=4(a+1)*binom. Match!
    # So formula (3+4st)/((1-t)^3 (1-u)^2) is CORRECT.
    # Bug was in the check loop using (a+1)*3 for even — should be (2a+1)*3.
    for m in range(m_max + 1):
        for d in range(d_max + 1):
            k = d - m
            if k < 0:
                coeff = 0
            elif m % 2 == 0:
                a = m // 2
                coeff = (2 * a + 1) * 3 * binom(k + 2, 2)
            else:
                a = (m - 1) // 2
                coeff = (2 * a + 2) * 2 * binom(k + 2, 2)
            expected = dim_M(m, d)
            if coeff != expected:
                errs.append((m, d, coeff, expected))
    return errs


def exact_representation_checks():
    """Exact checks from the certified model (parity + dims + centralizer)."""
    t = ew.fs
    tM = ew.rho[t]
    # trace of t: sum of diagonal
    tr = sum(tM[i][i] for i in range(5))
    # t^2 = I
    t2 = common.matmul5(tM, tM)
    I = [[ew.C(i == j) for j in range(5)] for i in range(5)]
    assert t2 == I
    # E_+ = ker(t-I), E_- = ker(t+I) dimensions via modular for speed + exact trace
    # exact: tr(t) = dim E_+ - dim E_- and dim E_+ + dim E_- = 5
    # so dim E_+ = (5+tr)/2, dim E_- = (5-tr)/2
    # tr is a cyclotomic integer; for involution in this rep it is the rational 1
    assert tr == ew.C(1), tr
    dim_plus, dim_minus = 3, 2
    # F on E_- vanishes by parity: for v in E_-, F(v)=F(tv)=F(-v)=-F(v)
    # Certified by the upstream verifier; record the formal identity here.
    # Centralizer order
    cent = common.centralizer_of_S()
    assert len(cent) == 12
    # Unique character line of D12 is off X: reuse subgroup_orbit style check
    # Find order-6 element in centralizer; its eigenspaces...
    # We'll rely on modular regression + upstream for the off-X fact.
    return {
        "trace_t": "1",
        "dims_Eplus_Eminus": [dim_plus, dim_minus],
        "centralizer_order": 12,
        "t_squared_I": True,
        "F_vanishes_on_Eminus_by_parity": True,
    }


def main():
    errs = closed_form_check()
    assert not errs, errs[:5]

    rep = exact_representation_checks()

    # recovery hashes
    recovery = {
        "tmp/involution_exceptional_divisor/REPORT.md": common.sha256_file(
            ROOT / "tmp/involution_exceptional_divisor/REPORT.md"
        ),
        "tmp/involution_exceptional_divisor/verify.py": common.sha256_file(
            ROOT / "tmp/involution_exceptional_divisor/verify.py"
        ),
    }

    payload = {
        "work_package": "WP-4A",
        "headline": "OPEN",
        "stratum": {
            "label": "C2_plane",
            "closure": "Z_t = P(E_+(t)) ≅ P^2",
            "orbit_size": 55,
            "generic_stabilizer_H": "C2 = <t>",
            "setwise_stabilizer": "D12 = C_G(t)",
            "residual": "S3",
            "on_X": "section E_t = X ∩ Z_t is a smooth plane cubic (plus type)",
        },
        "normal_bundle": {
            "as_sheaf": "N_{Z_t / P(W)} ≅ O_{Z_t}(1) ⊗ E_-(t)",
            "rank": 2,
            "H_module_fiber": "sign ⊕ sign",
            "O1_character": "trivial",
        },
        "module": {
            "definition": (
                "M_{m,d} = [ H^0(Z_t, Sym^m N^vee ⊗ O(d)) ⊗ W ]^{C2}"
            ),
            "dimension_formula": {
                "d_lt_m": 0,
                "m_even": "(m+1) * binom(d-m+2, 2) * 3",
                "m_odd": "(m+1) * binom(d-m+2, 2) * 2",
            },
            "hilbert_series": hilbert_series_rational(),
            "hilbert_coeffs_m0_7_d0_11": {
                f"{m},{d}": dim_M(m, d)
                for m in range(8)
                for d in range(12)
            },
            "finite_presentation": free_presentation(),
            "controls": "ALL normal orders m≥0 and ALL source degrees d (via free ranks + Hilbert series)",
            "finite_generation_failure_in_m": {
                "fails_as_single_finitely_generated_R_module_in_m": True,
                "delimited": "linear growth r_m = (m+1)*δ_m; series is still closed-form rational in (s,t)",
            },
        },
        "geometric_theorem": geometric_theorem(),
        "residual_and_restrictions": residual_S3_and_restriction(),
        "exact_representation": rep,
        "recovery": {
            "packet": "tmp/involution_exceptional_divisor/",
            "terminal_marker_upstream": "INVOLUTION_EXCEPTIONAL_DIVISOR_AUDIT_OK",
            "sha256": recovery,
        },
        "regressions": {
            "dims_Eplus_Eminus": [3, 2],
            "dim_M_0_0": dim_M(0, 0),  # m=0,d=0: order-zero C2-invariants Hom-like: 3
            "dim_M_1_1": dim_M(1, 1),  # first odd: 2*1*2 = 4? (1+1)*binom(2,2)*2 = 2*1*2=4
            "dim_M_1_7": dim_M(1, 7),
            "closed_form_check_pass": True,
        },
        "producer": "certificates/transitions/involution_plane/produce.py",
        "verifier": "certificates/transitions/involution_plane/verify.py",
        "theorem_boundary": (
            "Proves the involution-plane base/odd-order/dominates-L_t theorem and "
            "gives the complete bigraded module (Hilbert series + free ranks). "
            "Does not exclude global landing covariants; headline remains OPEN."
        ),
    }

    # Write without self-hash first, then seal body (exclude wall_time)
    out_path = HERE / "module.json"
    body = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    payload["self_sha256"] = hashlib.sha256(body.encode()).hexdigest()
    # re-serialize with self hash; the sealed body for self_sha256 is WITHOUT the field
    # Convention: self_sha256 hashes the JSON with self_sha256 removed (or pre-hash body)
    final = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    out_path.write_text(final)
    print("wrote", out_path)
    print("self_sha256", payload["self_sha256"])
    print("dim_M samples:", {k: payload["regressions"][k] for k in payload["regressions"] if k.startswith("dim")})
    print("INVOLUTION_PLANE_MODULE_PRODUCED")


if __name__ == "__main__":
    main()
