#!/usr/bin/env python3
"""Shared exact helpers for G4.1 free-fibre terminal formula and G4.2 module gate.

Exact Fraction / integer arithmetic only. Independent of produce/verify.
Polar model matches certificates/global_finite_lifting/common_g3.py.
"""

from __future__ import annotations

import hashlib
import json
import math
from collections import defaultdict
from fractions import Fraction as Q
from itertools import product
from pathlib import Path
from typing import Any

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
GFL = CERT / "global_finite_lifting"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path | str) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def canonical_json(obj: Any) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def write_json(path: Path, obj: dict) -> str:
    obj = dict(obj)
    obj["self_sha256"] = None
    text = canonical_json(obj)
    h = sha256_bytes(text.encode())
    obj["self_sha256"] = h
    path.write_text(canonical_json(obj))
    return h


def q_to_str(x: Q | int) -> str:
    if isinstance(x, int):
        return str(x)
    if x.denominator == 1:
        return str(x.numerator)
    return f"{x.numerator}/{x.denominator}"


def parse_q(s: str | int) -> Q:
    if isinstance(s, int):
        return Q(s)
    if isinstance(s, Q):
        return s
    if "/" in str(s):
        a, b = str(s).split("/")
        return Q(int(a), int(b))
    return Q(int(s))


def binom(n: int, k: int) -> int:
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def monoms_bin(deg: int) -> list[tuple[int, int]]:
    return [(deg - k, k) for k in range(deg + 1)]


# ---------------------------------------------------------------------------
# Polar cubic Phi_plus on E+ and B on (E+, E-, E-)
# ---------------------------------------------------------------------------

def phi_plus_coeff(i: int, j: int, k: int) -> Q:
    """Phi_+(e_i, e_j, e_k) on the abstract E+ cubic model."""
    if i == j == k:
        return Q(1)
    s = sorted((i, j, k))
    if s == [0, 1, 2]:
        return Q(-1, 2)
    return Q(0)


PHI_PLUS_TABLE: dict[tuple[int, int, int], Q] = {
    (i, j, k): phi_plus_coeff(i, j, k)
    for i, j, k in product(range(3), repeat=3)
    if phi_plus_coeff(i, j, k) != 0
}


def sigma_of(r: int) -> int:
    """E+ basis index of the pure-y0 term of the universal ker-L1 jet at relative order r."""
    assert r % 2 == 1 and r >= 1
    return ((r + 1) // 2) % 3


# ---------------------------------------------------------------------------
# Universal free-fibre jets for pure powers a = y0^m f0 + y1^m f1
# ---------------------------------------------------------------------------

def compute_universal_jets(r_max: int) -> dict:
    """Compute (alpha_r, beta_r, sigma_r, tau_r) for odd r = 1..r_max by the exact recurrence.

    Ansatz (m-independent coefficients):
      b^{(r)} = alpha_r * y0^{m+r} e_{sigma_r}
              + beta_r  * y0^{r} y1^{m} e_{tau_r}

    with sigma_r = ((r+1)//2) mod 3, tau_1 = 0, tau_r = 1 for r > 1.

    L_r(b) = B(b; a, a) = 2 b0 y0^m y1^m + b1 y1^{2m} + b2 y0^{2m}.
    The four monom classes of L(b) / R_pre of order 3m+r are:
      PPP: y0^{3m+r}         (hit by pure sigma=2)
      PPM: y0^{2m+r} y1^{m}  (hit by pure sigma=0, factor 2)
      PMM: y0^{m+r} y1^{2m}  (hit by pure sigma=1)
      MMM: y0^{r} y1^{3m}    (hit by mixed tau=1)
    """
    if r_max < 1:
        return {"alphas": {}, "betas": {}, "sigmas": {}, "taus": {}}

    alph: dict[int, int] = {1: -2}
    bet: dict[int, int] = {1: 1}
    sig: dict[int, int] = {1: 1}
    tau: dict[int, int] = {1: 0}

    def R_classes(r: int) -> dict[str, Q]:
        odds = [s for s in alph if s < r]
        acc = {"PPP": Q(0), "PPM": Q(0), "PMM": Q(0), "MMM": Q(0)}
        for s1, s2, s3 in product(odds, repeat=3):
            if s1 + s2 + s3 != r:
                continue
            opts = []
            for s in (s1, s2, s3):
                o = [("P", sig[s], alph[s])]
                if bet[s] != 0:
                    o.append(("M", tau[s], bet[s]))
                opts.append(o)
            for t1, t2, t3 in product(*opts):
                nM = (t1[0] == "M") + (t2[0] == "M") + (t3[0] == "M")
                phi = PHI_PLUS_TABLE.get((t1[1], t2[1], t3[1]), Q(0))
                if phi == 0:
                    continue
                c = phi * t1[2] * t2[2] * t3[2]
                if nM == 0:
                    acc["PPP"] += c
                elif nM == 1:
                    acc["PPM"] += c
                elif nM == 2:
                    acc["PMM"] += c
                else:
                    acc["MMM"] += c
        return acc

    for r in range(3, r_max + 1, 2):
        s = sigma_of(r)
        R = R_classes(r)
        # Primary equation: L(b) = -R on the pure monom class of sigma s.
        if s == 2:
            alpha = -R["PPP"]  # factor 1
        elif s == 0:
            assert R["PPM"] % 2 == 0, (r, R["PPM"])
            alpha = -R["PPM"] / 2  # factor 2
        else:  # s == 1
            alpha = -R["PMM"]
        beta = -R["MMM"]  # tau=1 factor 1
        # Consistency: inactive classes must vanish in R (exact identity check).
        inactive = {
            2: ("PPM", "PMM"),
            0: ("PPP", "PMM"),
            1: ("PPP", "PPM"),
        }[s]
        for name in inactive:
            if R[name] != 0:
                raise RuntimeError(
                    f"ansatz consistency fail r={r} sigma={s}: R[{name}]={R[name]}"
                )
        alph[r] = int(alpha)
        bet[r] = int(beta)
        sig[r] = s
        tau[r] = 1

    return {
        "alphas": {str(r): alph[r] for r in sorted(alph)},
        "betas": {str(r): bet[r] for r in sorted(bet)},
        "sigmas": {str(r): sig[r] for r in sorted(sig)},
        "taus": {str(r): tau[r] for r in sorted(tau)},
        "r_max": r_max,
        "ker_L1_seed": {
            "r": 1,
            "alpha": -2,
            "beta": 1,
            "sigma": 1,
            "tau": 0,
            "note": (
                "First nullspace basis vector of L_1 on pure powers "
                "a=y0^m f0 + y1^m f1: b = -2 y0^{m+1} e1 + y0 y1^m e0 "
                "(m=1: monoms match common_g3 ker[0])."
            ),
        },
        "ansatz": (
            "b^{(r)} = alpha_r y0^{m+r} e_{sigma_r} + beta_r y0^{r} y1^{m} e_{tau_r}"
        ),
        "L_operator": "L(b)=B(b;a,a)=2 b0 y0^m y1^m + b1 y1^{2m} + b2 y0^{2m}",
        "leading_jet": "pure_powers_y0^m_f0_plus_y1^m_f1",
        "based_relative": "a_{m+2}=a_{m+4}=...=0 (based-style relative E- jets)",
    }


def residual_from_universal(
    m: int, d: int, jets: dict | None = None
) -> dict:
    """Exact free-fibre residual at N_star = d+2m+1 from universal jets.

    Structural identity (proved by polar expansion with a_odd=0):
      Res_{m,d} = - L(b^{(k+1)})   where k = d - m,
    i.e. the residual is the RHS that the missing isolator b_{d+1} would cancel.
    Equivalent computational form: sum of Phi_+ over triples of E+ jets with
    relative orders s1+s2+s3 = k+1 and 1 <= s_i <= k.
    """
    assert m % 2 == 1 and d % 2 == 1 and d >= m
    k = d - m
    N = d + 2 * m + 1  # = 3m + k + 1
    r_need = k + 1  # formal next relative order (may exceed d-m if k+1 > k)
    # For residual via triples with s_i <= k we need jets through r=k (not k+1).
    r_max = max(k, 1)
    if jets is None:
        jets = compute_universal_jets(r_max if r_max % 2 == 1 else r_max + 1)
        # ensure all odd r <= k present
        while int(max(jets["alphas"], key=int)) < k:
            jets = compute_universal_jets(int(max(jets["alphas"], key=int)) + 20)

    alph = {int(r): v for r, v in jets["alphas"].items()}
    bet = {int(r): v for r, v in jets["betas"].items()}
    sig = {int(r): v for r, v in jets["sigmas"].items()}
    tau = {int(r): v for r, v in jets["taus"].items()}

    odds = [s for s in alph if 1 <= s <= k and s % 2 == 1]
    acc: dict[tuple[int, int], Q] = defaultdict(lambda: Q(0))
    target = k + 1
    n_triples = 0
    for s1, s2, s3 in product(odds, repeat=3):
        if s1 + s2 + s3 != target:
            continue
        n_triples += 1
        terms = []
        for s in (s1, s2, s3):
            ts = []
            ts.append(((m + s, 0), sig[s], alph[s]))
            if bet[s] != 0:
                ts.append(((s, m), tau[s], bet[s]))
            terms.append(ts)
        for t1, t2, t3 in product(*terms):
            mon = (
                t1[0][0] + t2[0][0] + t3[0][0],
                t1[0][1] + t2[0][1] + t3[0][1],
            )
            phi = PHI_PLUS_TABLE.get((t1[1], t2[1], t3[1]), Q(0))
            if phi == 0:
                continue
            acc[mon] += phi * t1[2] * t2[2] * t3[2]

    # Also via -L(b^{k+1}) if we extend jets one step
    jets_ext = compute_universal_jets(k + 1 if (k + 1) % 2 == 1 else k + 2)
    r_next = k + 1
    assert r_next % 2 == 1
    a_next = jets_ext["alphas"][str(r_next)]
    b_next = jets_ext["betas"][str(r_next)]
    s_next = jets_ext["sigmas"][str(r_next)]
    t_next = jets_ext["taus"][str(r_next)]
    L_acc: dict[tuple[int, int], Q] = defaultdict(lambda: Q(0))
    # pure term alpha y0^{m+r} e_sigma
    if s_next == 0:
        L_acc[(2 * m + r_next, m)] += 2 * a_next
    elif s_next == 1:
        L_acc[(m + r_next, 2 * m)] += a_next
    else:
        L_acc[(3 * m + r_next, 0)] += a_next
    # mixed beta y0^r y1^m e_tau
    if b_next != 0:
        if t_next == 0:
            L_acc[(m + r_next, 2 * m)] += 2 * b_next
        elif t_next == 1:
            L_acc[(r_next, 3 * m)] += b_next
        else:
            L_acc[(2 * m + r_next, m)] += b_next
    # Res should equal -L
    res_via_L = {mon: -c for mon, c in L_acc.items() if c != 0}

    monoms = monoms_bin(N)
    coeffs = [Q(0)] * (N + 1)
    for i, mon in enumerate(monoms):
        coeffs[i] = acc.get(mon, Q(0))

    # C3 weights: monom y0^a y1^b has weight (a-b) mod 3
    weights: dict[int, list] = {0: [], 1: [], 2: []}
    for mon, c in acc.items():
        if c == 0:
            continue
        a, b = mon
        w = (a - b) % 3
        weights[w].append({"monom": [a, b], "coeff": q_to_str(c)})

    nsq = sum(c * c for c in coeffs)
    via_L_match = all(
        acc.get(mon, Q(0)) == res_via_L.get(mon, Q(0))
        for mon in set(acc) | set(res_via_L)
    )

    return {
        "m": m,
        "d": d,
        "k_equals_d_minus_m": k,
        "N_star": N,
        "formula_N_star": "d + 2*m + 1",
        "residual_coeffs": [q_to_str(c) for c in coeffs],
        "residual_nz": [
            {"monom": [a, b], "coeff": q_to_str(c)}
            for (a, b), c in sorted(acc.items())
            if c != 0
        ],
        "residual_norm_sq": q_to_str(nsq),
        "is_zero": nsq == 0,
        "C3_weight_components": {
            str(w): {"n_terms": len(weights[w]), "terms": weights[w]}
            for w in (0, 1, 2)
        },
        "dominant_C3_weights": [w for w in (0, 1, 2) if weights[w]],
        "structural_identity": {
            "statement": "Res_{m,d} = -L(b^{(k+1)}) with k=d-m",
            "verified_on_this_bidegree": via_L_match,
            "next_jet": {
                "r": r_next,
                "alpha": a_next,
                "beta": b_next,
                "sigma": s_next,
                "tau": t_next,
            },
            "minus_L_nz": [
                {"monom": [a, b], "coeff": q_to_str(c)}
                for (a, b), c in sorted(res_via_L.items())
            ],
        },
        "support_class": residual_support_class(k, m, N),
        "n_relative_triples_enumerated": n_triples,
    }


def residual_support_class(k: int, m: int, N: int) -> dict:
    """Monomial support type by k mod 6 (proved by L-image of next jet)."""
    r = k + 1
    s = sigma_of(r)
    if k % 6 == 0:
        # sigma of r=k+1: k=6t => r=6t+1 => sigma=((6t+2)//2)%3=(3t+1)%3
        return {
            "k_mod_6": 0,
            "type": "A_pure_sigma_cycle",
            "expected_monoms": [[N - 2 * m, 2 * m]],
            "note": "Primary support y0^{N-2m} y1^{2m} when next sigma hits PMM class",
        }
    if k % 6 == 2:
        return {
            "k_mod_6": 2,
            "type": "B_two_term",
            "expected_monoms": [[N, 0], [N - 3 * m, 3 * m]],
            "note": "y0^N from pure sigma=2; y0^{N-3m} y1^{3m} from mixed beta",
        }
    if k % 6 == 4:
        return {
            "k_mod_6": 4,
            "type": "C_mixed_or_PPM",
            "expected_monoms": [[N - m, m]],
            "note": "Primary support y0^{N-m} y1^m",
        }
    return {"k_mod_6": k % 6, "type": "unexpected_parity", "expected_monoms": []}


def c3_s3_decomposition(res: dict) -> dict:
    """Residual C3/S3 character report for a free-fibre residual binary form."""
    N = res["N_star"]
    weights = res["dominant_C3_weights"]
    # S3: residual binary forms; weight-0 component is the C3-invariants.
    return {
        "F_order": N,
        "C3_weights_present": weights,
        "is_C3_isotypic": len(weights) == 1,
        "C3_isotype": weights[0] if len(weights) == 1 else None,
        "S3_note": (
            "Binary form of order N under residual D12/C3 on E_-. "
            "Weight 0 is the C3-trivial summand; weights {1,2} are the "
            "nontrivial C3 characters (swapped by the residual S3 transposition)."
        ),
        "support": res["residual_nz"],
        "not_a_G_covariant": True,
    }


# ---------------------------------------------------------------------------
# Isolation cutoff (proved combinatorics)
# ---------------------------------------------------------------------------

def N_star(m: int, d: int) -> int:
    return d + 2 * m + 1


def first_nonisolable_proved(m: int, d: int) -> dict:
    """Proved isolation cutoff: last E+ isolator order d-1 at F-order (d-1)+2m."""
    last_iso = (d - 1) + 2 * m
    first_non = d + 2 * m + 1
    return {
        "m": m,
        "d": d,
        "last_isolable_Eplus_F_order": last_iso,
        "first_nonisolable_F_order": first_non,
        "formula": "N_star = d + 2*m + 1",
        "proved": True,
        "proof_ref": "certificates/global_finite_lifting/TERMINAL_PATTERN.md §2.1",
    }


# ---------------------------------------------------------------------------
# Family ledger predicates
# ---------------------------------------------------------------------------

FAMILIES = (
    "based_minus_lines_odd_m",
    "residual_e1_swap_both",
    "residual_e_ge7_generic_swap_both",
)


def family_admissible(family: str, m: int, d: int, e: int | None = None) -> bool:
    """Parity and source-line ledger constraints for Level-1 families."""
    if m < 1 or d < m or m % 2 == 0 or d % 2 == 0:
        return False
    if family == "based_minus_lines_odd_m":
        # based: p|_{E_-}=0; odd plane order m
        return True
    if family == "residual_e1_swap_both":
        # e=1 det-twisted residual swap_both
        return e is None or e == 1
    if family == "residual_e_ge7_generic_swap_both":
        # generic residual with e >= 7, e ≡ d (source-line degree)
        # ledger: e = d - something; accepted: e >= 7, e odd typically
        if e is None:
            # default residual ledger uses e related to d; allow all odd d>=7 for grid
            return d >= 7
        return e >= 7
    return False


def admissible_semigroup_generators() -> dict:
    """Hilbert generators for admissible (m, d, family_flag) cone.

    Lattice points: m odd >=1, d odd >= m. Encode as
      m = 1 + 2 a,  d = m + 2 b = 1 + 2a + 2b,  a>=0, b>=0.
    So (a,b) in N^2 is free — Hilbert basis is the two rays.
    Family flags are finite (3 families) — product is still finitely generated.
    """
    return {
        "lattice_coordinates": {
            "a": "m = 1 + 2a, a >= 0",
            "b": "d = m + 2b = 1 + 2a + 2b, b >= 0",
            "family_index": "f in {0,1,2} for the three Level-1 families",
        },
        "cone": "N^2 x {0,1,2}",
        "hilbert_basis": [
            {"a": 1, "b": 0, "f": 0, "meaning": "increment m by 2"},
            {"a": 0, "b": 1, "f": 0, "meaning": "increment d-m by 2"},
            {"a": 0, "b": 0, "f": 1, "meaning": "family residual_e1 (flag unit)"},
            {"a": 0, "b": 0, "f": 2, "meaning": "family residual_e_ge7 (flag unit)"},
            {
                "a": 0,
                "b": 0,
                "f": 0,
                "m": 1,
                "d": 1,
                "meaning": "origin of based family (m,d)=(1,1) minimal odd",
            },
        ],
        "normaliz_input": {
            "ambient_dim": 3,
            "cone_generators": [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
            "note": (
                "The pure (m,d) odd cone is free of rank 2 after the affine "
                "change (a,b). Finite family flags do not destroy finite generation."
            ),
        },
        "finite": True,
    }


def regression_packet_7_13_19(jets: dict | None = None) -> dict:
    """Recover sealed free-fibre residuals at director bidegrees (1,7),(1,13),(3,19)."""
    samples = [(1, 7), (1, 13), (3, 19)]
    out = {}
    for m, d in samples:
        res = residual_from_universal(m, d, jets)
        out[f"m{m}_d{d}"] = {
            "m": m,
            "d": d,
            "N_star": res["N_star"],
            "first_nonzero": res["N_star"] if not res["is_zero"] else None,
            "residual_norm_sq": res["residual_norm_sq"],
            "residual_nz": res["residual_nz"],
            "C3_weights": res["dominant_C3_weights"],
            "structural_identity_ok": res["structural_identity"][
                "verified_on_this_bidegree"
            ],
            "is_zero": res["is_zero"],
        }
    return {
        "samples": out,
        "matches_TERMINAL_PATTERN": {
            "m1_d7": out["m1_d7"]["residual_norm_sq"] == "1296"
            and out["m1_d7"]["N_star"] == 10,
            "m1_d13": out["m1_d13"]["residual_norm_sq"] == "156816"
            and out["m1_d13"]["N_star"] == 16,
            "m3_d19": out["m3_d19"]["residual_norm_sq"] == "15968016"
            and out["m3_d19"]["N_star"] == 26,
        },
    }
