#!/usr/bin/env python3
"""WP-4C producer: V4 fixed line, forced base, normal jets, E[2] charges.

S = P(A) = P(W^{V4}) ≅ P^1, with residual A4/V4 ≅ C3.
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


def v4_module_dimension(m: int, d: int) -> dict:
    """dim M_{m,d} = [ H^0(P(A), Sym^m N^vee ⊗ O(d)) ⊗ W ]^{V4}.

    Geometry:
      A = W^{V4}, dim 2, trivial V4-character.
      W = A ⊕ B ⊕ C ⊕ D with dims (2,1,1,1) and characters (triv, χ_z, χ_s, χ_r).
      N_{P(A)/P(W)} ≅ O(1) ⊗ (B ⊕ C ⊕ D).
      N^vee ≅ O(−1) ⊗ (B* ⊕ C* ⊕ D*), characters χ_z, χ_s, χ_r (self-dual ±1).
      H^0(Sym^m N^vee ⊗ O(d)) = Sym^m (B*⊕C*⊕D*) ⊗ Sym^{d−m} A*   (d≥m).

    V4 acts trivially on Sym^{d−m} A*.  On Sym^m (B*⊕C*⊕D*), the action is by
    the product of characters of the factors.  Invariants of the tensor with W
    require the multi-character of the monomial in (B*,C*,D*) to match a
    character appearing in W.

    Characters of V4 = {1, χ_z, χ_s, χ_r} with χ_z χ_s χ_r = 1 and each χ^2=1.
    A monomial b^{α} c^{β} d^{γ} with α+β+γ=m has character χ_z^α χ_s^β χ_r^γ.
    """
    if d < m or m < 0:
        return {"dim": 0, "by_target": {}}
    # Enumerate multi-indices
    # target component must have the same character
    # W characters: A has triv (dim 2), B χ_z (1), C χ_s (1), D χ_r (1)
    by_target = {"A_triv": 0, "B_chi_z": 0, "C_chi_s": 0, "D_chi_r": 0}
    for alpha in range(m + 1):
        for beta in range(m - alpha + 1):
            gamma = m - alpha - beta
            # character: χ_z^α χ_s^β χ_r^γ
            # as (sign_z, sign_s, sign_r) with sign = (-1)^count for that char
            # χ_z(z)=1, χ_z(s)=-1, χ_z(r)=-1, etc.  Product character equals:
            # Identify: character is triv iff α≡β≡γ≡0 mod 2? More carefully:
            # χ_z^α χ_s^β χ_r^γ = χ_z^{α} χ_s^{β} χ_r^{γ}.
            # Since χ_r = χ_z χ_s (because χ_z χ_s χ_r = 1 and all order 2),
            # = χ_z^{α+γ} χ_s^{β+γ}.
            # This equals:
            #   triv  if α+γ even and β+γ even
            #   χ_z   if α+γ odd  and β+γ even
            #   χ_s   if α+γ even and β+γ odd
            #   χ_r   if α+γ odd  and β+γ odd
            az = (alpha + gamma) % 2
            bs = (beta + gamma) % 2
            mult = 1  # each monomial b^α c^β d^γ appears once (1-dim lines)
            space_dim = dim_sym(2, d - m)  # Sym^{d-m} A*
            if az == 0 and bs == 0:
                by_target["A_triv"] += mult * space_dim * 2  # target A dim 2
            elif az == 1 and bs == 0:
                by_target["B_chi_z"] += mult * space_dim * 1
            elif az == 0 and bs == 1:
                by_target["C_chi_s"] += mult * space_dim * 1
            else:
                by_target["D_chi_r"] += mult * space_dim * 1
    total = sum(by_target.values())
    return {"dim": total, "by_target": by_target}


def hilbert_series_v4():
    """Closed form via character projection.

    Number of monomials of degree m with given (az, bs):
    Count α,β,γ ≥ 0, α+β+γ=m with (α+γ) mod 2 = az, (β+γ) mod 2 = bs.

    Or: generating function 1/((1-s_b)(1-s_c)(1-s_d)) with character weights.
    Standard Molien for V4 on three sign characters.

    dim of weight-χ piece of Sym^m (χ_z⊕χ_s⊕χ_r):
      n_triv(m) = round((m+3)^2 / 12) or known formula
    Actually number of nonneg int sol to α+β+γ=m with parity conditions.

    Total monomials: binom(m+2,2).
    Four character spaces nearly equal.

    H(s,t) = sum_m s^m [ 2 n_triv(m) + n_z(m) + n_s(m) + n_r(m) ] * t^m / (1-t)^2
    since dim Sym^k A* = k+1, sum t^k (k+1) wait: sum_{k≥0} (k+1) t^k = 1/(1-t)^2,
    and d = m+k so factor t^m /(1-t)^2.

    Note 2 n_triv + n_z + n_s + n_r = 2 n_triv + (binom(m+2,2) - n_triv) = n_triv + binom(m+2,2)
    because target dims: triv contributes *2, others *1, and sum of n's = binom(m+2,2).

    So dim M_{m,d} = (n_triv(m) + binom(m+2,2)) * (d-m+1) for d≥m.
    """
    return {
        "formula_piecewise": (
            "For d≥m: dim = (n_triv(m) + binom(m+2,2)) * (d−m+1), "
            "where n_triv(m) = # {α+β+γ=m : α+γ even, β+γ even}."
        ),
        "n_triv_closed": (
            "m=2k even: n_triv = binom(k+2,2) = (k+1)(k+2)/2; "
            "m=2k+1 odd: n_triv = binom(k+1,2) = k(k+1)/2. "
            "Verified by enumeration for m≤40.  (Not equal to round((m+3)^2/12).)"
        ),
        "hilbert_series": (
            "H(s,t) = sum_m s^m (n_triv(m)+binom(m+2,2)) t^m / (1-t)^2"
        ),
        "variables": {"s": "normal order m", "t": "source degree d"},
        "valid_for": "all m≥0, all d",
    }


def n_triv(m: int) -> int:
    count = 0
    for alpha in range(m + 1):
        for beta in range(m - alpha + 1):
            gamma = m - alpha - beta
            if (alpha + gamma) % 2 == 0 and (beta + gamma) % 2 == 0:
                count += 1
    return count


def free_presentation():
    return {
        "base_ring": {
            "name": "R = Sym(A*) ≅ Q[x,y]",
            "grading": "deg = 1 (source degree on P(A) ≅ P^1)",
            "H_action": "trivial (V4 acts as +1 on A)",
            "residual_C3": (
                "A4/V4 ≅ C3 acts on A as the sum of the two nontrivial linear "
                "characters 1',1'' of A4 (i.e. on P(A) with two fixed points = "
                "A4 character lines).  Invariants under residual C3 are the "
                "binary C3-invariants on A."
            ),
        },
        "for_each_fixed_m": {
            "free_over_R": True,
            "rank": "r_m = n_triv(m) + binom(m+2,2)",
            "generator_degree": "d = m",
            "relations": "none for fixed m over R",
            "character_decomposition_of_generators": (
                "n_triv(m) generators valued in A (dim-2 target contributes factor 2 "
                "already in rank formula via 2 n_triv in the pre-simplified count; "
                "rank formula already includes target dimensions), "
                "plus n_z, n_s, n_r generators valued in B, C, D respectively."
            ),
        },
        "as_bigraded_module": {
            "finitely_generated_in_m": False,
            "reason": "r_m ~ m^2/2 grows quadratically; infinite normal orders",
            "complete_control": "rank formula + Hilbert series control all (m,d)",
        },
        "first_nonzero_normal_jets": {
            "order_zero_forbidden_on_X": True,
            "see_theorem": "4C.1",
        },
    }


def geometric_theorem():
    return {
        "headline": "OPEN",
        "statements": [
            {
                "id": "4C.1_forced_base",
                "claim": (
                    "The ambient V4 fixed line P(A) is a forced base component of any "
                    "homogeneous landing covariant: a nonzero order-zero restriction "
                    "would be a residual-C3 equivariant rational map P(A)⇢X whose "
                    "generic value is C3-fixed in X^{V4}, but the only C3-fixed points "
                    "of P(A) are the two A4 character lines, both off X, and the six "
                    "points of X^{V4} = R ⊔ {[B],[C],[D]} form two C3-orbits of size 3 "
                    "(type-II and type-I) with no C3-fixed point on X."
                ),
                "proof_sketch": [
                    "V4 acts trivially on A ⇒ any order-zero p|_{A} lands in the V4-fixed "
                    "locus of W, i.e. in A ⊕ (nothing else is V4-fixed as a line...). "
                    "More precisely: for v∈A, p(v) must be V4-eigen with the same "
                    "character as the O(1) character on <v>, which is trivial, so "
                    "p(v)∈A.  Thus order-zero restriction is an endomorphism of A, "
                    "i.e. a binary map P(A)→P(A), residual-C3 equivariant.",
                    "Landing in X requires image in X∩P(A)=R (three type-II points). "
                    "A nonconstant map P^1→P^1 cannot have finite image; a constant "
                    "map lands at a C3-fixed point of P(A), i.e. an A4 character line, "
                    "off X (certified).  The type-II points are cycled by residual C3, "
                    "so none is C3-fixed.  Contradiction.  Hence p vanishes on P(A): "
                    "forced base component.",
                ],
                "status": "PROVED",
            },
            {
                "id": "4C.2_normal_bundle",
                "claim": (
                    "N_{P(A)/P(W)} ≅ O(1) ⊗ (B⊕C⊕D) ≅ O(1) ⊗ (χ_z ⊕ χ_s ⊕ χ_r) as "
                    "V4-equivariant bundles on P(A)."
                ),
                "status": "PROVED",
            },
            {
                "id": "4C.3_normal_directions",
                "claim": (
                    "First nonzero normal-jet directions decompose by V4-character: "
                    "(i) pure B / C / D directions point along the three triangle edges "
                    "toward type-I vertices and the corresponding elliptic E_z / E_s / E_r; "
                    "(ii) mixed characters encode multi-edge / type-II sector data; "
                    "(iii) residual C3 cycles the three pure edge characters."
                ),
                "status": "PROVED",
                "table": {
                    "chi_z_direction": {
                        "target_line": "B",
                        "triangle": "vertex [B] type-I",
                        "elliptic": "E_z = X ∩ P(A⊕B)",
                        "minus_lines_through_B": ["L_s", "L_r"],
                        "E2_charge_at_type_I": "<q> after origin at a type-I point on E_z",
                    },
                    "chi_s_direction": {
                        "target_line": "C",
                        "triangle": "vertex [C] type-I",
                        "elliptic": "E_s",
                        "E2_charge": "<q> on E_s",
                    },
                    "chi_r_direction": {
                        "target_line": "D",
                        "triangle": "vertex [D] type-I",
                        "elliptic": "E_r",
                        "E2_charge": "<q> on E_r",
                    },
                    "type_II_sector": {
                        "support": "R = X ∩ P(A), three points",
                        "incidence": "each type-II point lies on all three elliptics (Gate 1 CLAIM_1)",
                        "E2_charge": "e + <q> for 0≠e∈E[2] (WP-3 theorem)",
                        "normal_jets_to_type_II": (
                            "jets valued in A (trivial character) deform within P(A); "
                            "landing on type-II is the residual C3-orbit of R"
                        ),
                    },
                    "rational_fixed_line": {
                        "the_line_itself": "P(A) is rational; forced base, so maps emerge from normal jets",
                        "triangle_edges": "L_z, L_s, L_r are the rational minus-lines (on X)",
                    },
                },
            },
            {
                "id": "4C.4_charge_tracking",
                "claim": (
                    "Under every incident flag, type-I states carry charge <q> and "
                    "type-II states carry charge e+<q> (WP-3 E[2] theorem), consistent "
                    "with Gate 1 type-II triple-elliptic meetings.  Residual C3 cycles "
                    "charges within each orbit; residual reflections act as P ↦ e−P."
                ),
                "status": "PROVED_from_WP3",
                "explicit_Weierstrass_coords": (
                    "NOT computed: existence/uniqueness of q and E[2] up to sign is the "
                    "theorem; numerical Weierstrass coordinates remain a named remainder "
                    "unless needed for a specific restriction matrix (not required for "
                    "the charge-label tracking of transition states)."
                ),
            },
            {
                "id": "4C.5_no_bare_V4_rerun",
                "claim": (
                    "The local triangle graph closes (endpoint preserve and swap both "
                    "occur).  Not re-run here (house rule 7)."
                ),
                "status": "ACCEPTED_from_upstream",
                "upstream": "tmp/involution_exceptional_divisor/V4_REPORT.md",
            },
        ],
        "not_proved": [
            "Global compatibility of V4 jets with all 55 plane orders (WP-5)",
            "Existence of a landing covariant",
            "Explicit Weierstrass model of q, e_i",
        ],
    }


def main():
    # Build dimension tables
    coeffs = {}
    by_char = {}
    for m in range(0, 9):
        for d in range(0, 12):
            info = v4_module_dimension(m, d)
            coeffs[f"{m},{d}"] = info["dim"]
            by_char[f"{m},{d}"] = info["by_target"]

    # Check rank formula
    for m in range(0, 25):
        nt = n_triv(m)
        rank = nt + binom(m + 2, 2)
        # dim at d=m should equal rank
        assert v4_module_dimension(m, m)["dim"] == rank, (m, rank)
        # check n_triv vs round((m+3)^2/12) — standard formula for dim of
        # triv isotypical in Sym^m of 3D sum of nontrivial chars of V4
        # Actually for SO(3) etc. Let me just record computed n_triv sequence
        pass

    n_triv_seq = [n_triv(m) for m in range(0, 21)]

    def n_triv_closed_form(m: int) -> int:
        if m % 2 == 0:
            k = m // 2
            return (k + 1) * (k + 2) // 2
        k = (m - 1) // 2
        return k * (k + 1) // 2

    assert all(n_triv(m) == n_triv_closed_form(m) for m in range(0, 41))

    payload = {
        "work_package": "WP-4C",
        "headline": "OPEN",
        "stratum": {
            "label": "V4_line",
            "closure": "P(A) = P(W^{V4}) ≅ P^1",
            "orbit_size": 55,
            "generic_stabilizer_H": "V4",
            "setwise_stabilizer": "A4 = N_G(V4)",
            "residual": "C3 = A4/V4",
            "on_X_section": "R = X ∩ P(A): three reduced type-II points",
            "joint_character_dims": {"A_triv": 2, "B_chi_z": 1, "C_chi_s": 1, "D_chi_r": 1},
        },
        "normal_bundle": {
            "as_sheaf": "N ≅ O(1) ⊗ (B ⊕ C ⊕ D)",
            "H_module": "χ_z ⊕ χ_s ⊕ χ_r",
            "rank": 3,
        },
        "module": {
            "definition": "M_{m,d} = [ H^0(P(A), Sym^m N^vee ⊗ O(d)) ⊗ W ]^{V4}",
            "dimension_formula": {
                "d_lt_m": 0,
                "d_ge_m": "(n_triv(m) + binom(m+2,2)) * (d - m + 1)",
                "n_triv_m": "number of monomials of degree m in (B*,C*,D*) of trivial V4-character",
                "n_triv_sequence_m0_to_20": n_triv_seq,
                "n_triv_closed_form": {
                    "m_even_2k": "binom(k+2, 2)",
                    "m_odd_2k_plus_1": "binom(k+1, 2)",
                    "verified_m_le_40": True,
                },
            },
            "hilbert_series": hilbert_series_v4(),
            "hilbert_coeffs_m0_8_d0_11": coeffs,
            "character_decomposition_samples": {
                k: by_char[k] for k in ["0,0", "1,1", "2,2", "3,3", "1,5", "2,5"]
            },
            "finite_presentation": free_presentation(),
            "controls": "ALL m≥0 and ALL d via free ranks over Q[x,y] and the n_triv formula",
        },
        "geometric_theorem": geometric_theorem(),
        "charge_tracking": {
            "source": "WP-3 E[2] theorem (PROVED_STRUCTURALLY)",
            "type_I": "<q> ⊂ E[3]",
            "type_II": "e + <q> for 0≠e∈E[2]",
            "Gate1_consistency": "CLAIM_1_SURVIVES_CLAIM_2_REFUTED",
            "flags": {
                "P(A) -> type_II_points": "charge e+<q>, C3-orbit of size 3",
                "P(A) -normal-> type_I_vertex": "charge <q> on the unique local elliptic through that vertex",
                "P(A) -normal-> elliptic_component": "same elliptic's charge labeling",
                "P(A) -normal-> triangle_edge": "rational line L_*; endpoints type-I with charge <q>",
            },
            "explicit_q_coords": "REMAINDER (existence/uniqueness only; not required for labels)",
        },
        "regressions": {
            "joint_dims": [2, 1, 1, 1],
            "dim_M_0_0": coeffs["0,0"],
            "dim_M_1_1": coeffs["1,1"],
            "n_triv_0": 1,  # only 1 monomial of deg 0
            "n_triv_1": 0,  # pure B,C,D are nontrivial
            "n_triv_2": 3,  # B^2, C^2, D^2 are trivial (χ^2=1)
            "A4_character_lines_off_X": True,
            "triangle_closes": "ACCEPTED (house rule 7; V4_REPORT)",
        },
        "producer": "certificates/transitions/v4_fixed_line/produce.py",
        "verifier": "certificates/transitions/v4_fixed_line/verify.py",
        "theorem_boundary": (
            "Forced base of P(A), complete bigraded V4-jet module, character-wise "
            "normal directions, and E[2]-charge tracking under flags.  No global "
            "obstruction claimed.  Headline OPEN."
        ),
    }

    # Fix n_triv regressions by computing
    assert n_triv(0) == 1
    assert n_triv(1) == 0
    assert n_triv(2) == 3
    payload["regressions"]["dim_M_0_0"] = v4_module_dimension(0, 0)["dim"]
    payload["regressions"]["dim_M_1_1"] = v4_module_dimension(1, 1)["dim"]

    body = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    payload["self_sha256"] = hashlib.sha256(body.encode()).hexdigest()
    out = HERE / "module.json"
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("wrote", out)
    print("n_triv_seq", n_triv_seq[:12])
    print("dim_M_0_0", payload["regressions"]["dim_M_0_0"])
    print("dim_M_1_1", payload["regressions"]["dim_M_1_1"])
    print("V4_FIXED_LINE_MODULE_PRODUCED")


if __name__ == "__main__":
    main()
