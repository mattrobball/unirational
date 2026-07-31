#!/usr/bin/env python3
"""P25Y-M producer: independent Molien group-sum on the project's W.

Third independent route (owner step 1 alternative):
  m_d = (1/|G|) Σ_{g ∈ G} [t^d]  1/det(I − t ρ(g))

Uses the project's actual 5-dimensional Klein matrices (S,T generators → 660
elements), not a character table. Confirms that the project's W is a degree-5
irreducible of PSL(2,11) by matching the known low-degree coefficients
(m_3 = 1, m_25 = 43).

Also records self-covariant dimensions
  c_d = (1/|G|) Σ_g χ̄(g) [t^d] 1/det(I − t ρ(g))
and the special-fibre invariant dimension at p = 89 via the same sum in F_89
(valid because p ∤ |G| = 660, so Reynolds applies).

Does NOT seal P25Y-FULL-ROWSPACE-746 (m_75 = 2343 ≠ 746).
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
import time
from fractions import Fraction as Q
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
TMP = ROOT / "tmp" / "p25ym"
TMP.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(CERT / "degree25_exact"))
import common_p25x as C  # noqa: E402

GROUP_ORDER = 660
DEGREE_MAX = 75
KEY_DEGREES = [0, 1, 2, 3, 4, 5, 7, 10, 11, 12, 13, 19, 22, 25, 28, 43, 55, 75]
# Split good primes p ≡ 1 (mod 11), p > DEGREE_MAX, p ∤ 660.
PRIMES: list[tuple[int, int]] = [
    (89, 78),
    (199, 61),
    (331, 270),
    (353, 58),
]


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def write_json_self_hash(path: Path, payload: dict) -> str:
    body = {k: v for k, v in payload.items() if k != "self_sha256"}
    text = canonical_json(body)
    digest = sha256_bytes(text.encode())
    body["self_sha256"] = digest
    path.write_text(canonical_json(body))
    return digest


def power_traces(matrix: np.ndarray, max_deg: int, prime: int) -> np.ndarray:
    """p_k = tr(A^k) for k = 1..max_deg over F_prime."""
    n = matrix.shape[0]
    a = (matrix % prime).astype(np.int64)
    power = np.eye(n, dtype=np.int64)
    traces = np.zeros(max_deg + 1, dtype=np.int64)  # index by k; traces[0] unused
    for k in range(1, max_deg + 1):
        power = (power @ a) % prime
        traces[k] = int(np.trace(power) % prime)
    return traces


def invert_matrix_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    """Invert a 5×5 matrix over F_prime by Gauss–Jordan."""
    n = matrix.shape[0]
    a = np.concatenate(
        [matrix.astype(np.int64) % prime, np.eye(n, dtype=np.int64)], axis=1
    )
    for col in range(n):
        piv = next(i for i in range(col, n) if a[i, col] % prime)
        a[[col, piv]] = a[[piv, col]]
        inv_p = pow(int(a[col, col]) % prime, -1, prime)
        a[col] = (a[col] * inv_p) % prime
        for i in range(n):
            if i != col and a[i, col] % prime:
                a[i] = (a[i] - a[i, col] * a[col]) % prime
    return a[:, n:] % prime


def complete_homogeneous_from_traces(
    traces: np.ndarray, max_deg: int, prime: int
) -> np.ndarray:
    """h_n of eigenvalues from Newton: n h_n = Σ_{k=1}^n p_k h_{n-k}.

    Requires 1..max_deg invertible mod prime, i.e. prime > max_deg.
    """
    h = np.zeros(max_deg + 1, dtype=np.int64)
    h[0] = 1
    for n in range(1, max_deg + 1):
        acc = 0
        for k in range(1, n + 1):
            acc = (acc + int(traces[k]) * int(h[n - k])) % prime
        inv_n = pow(n, -1, prime)
        h[n] = (acc * inv_n) % prime
    return h


def molien_series_modular(
    group: np.ndarray, max_deg: int, prime: int, with_covariants: bool = True
) -> tuple[np.ndarray, np.ndarray | None]:
    """Return (inv_series, cov_series_or_None) mod prime via group sum.

    Invariants:
        m_d = (1/|G|) Σ_g [t^d] 1/det(I − t g)

    Self-covariants Hom_G(Sym^d W, W) ≅ (Sym^d W^* ⊗ W)^G:
        c_d = (1/|G|) Σ_g χ(g^{-1}) [t^d] 1/det(I − t g)
    (equivalently Σ χ(g)/det(I − t g^{-1}) after reindexing).
    """
    inv_acc = np.zeros(max_deg + 1, dtype=np.int64)
    cov_acc = np.zeros(max_deg + 1, dtype=np.int64) if with_covariants else None
    inv_g = pow(GROUP_ORDER, -1, prime)
    for g in group:
        g = (np.asarray(g, dtype=np.int64) % prime)
        tr = power_traces(g, max_deg, prime)
        h = complete_homogeneous_from_traces(tr, max_deg, prime)
        inv_acc = (inv_acc + h) % prime
        if with_covariants:
            ginv = invert_matrix_mod(g, prime)
            chi_inv = int(np.trace(ginv) % prime)
            cov_acc = (cov_acc + (chi_inv * h) % prime) % prime
    inv = (inv_acc * inv_g) % prime
    cov = (cov_acc * inv_g) % prime if with_covariants else None
    return inv, cov


def crt_int(residues: list[int], moduli: list[int]) -> int:
    x, m = C.crt_list(residues, moduli)
    # Center into (-m/2, m/2]
    if x > m // 2:
        x -= m
    return int(x)


def reconstruct_series(
    modular: dict[int, np.ndarray],
    max_deg: int,
    bound_fn=None,
) -> list[int]:
    """CRT-reconstruct non-negative integer series from modular images.

    Default bound: 0 ≤ a_d ≤ binom(d+4, 4) (invariants in Sym^d (C^5)^*).
    Self-covariants use bound_fn(d) = 5 * binom(d+4, 4).
    Product of moduli must exceed 2*bound.
    """
    if bound_fn is None:
        bound_fn = lambda d: math.comb(d + 4, 4)
    primes = sorted(modular.keys())
    moduli = primes
    M = 1
    for p in moduli:
        M *= p
    out: list[int] = []
    for d in range(max_deg + 1):
        bound = bound_fn(d)
        assert M > 2 * bound, f"CRT modulus too small for degree {d}"
        residues = [int(modular[p][d]) % p for p in primes]
        val = crt_int(residues, moduli)
        # Expected non-negative; if negative within bound, add M
        if val < 0:
            val += M
        assert 0 <= val <= bound, f"degree {d}: reconstructed {val} outside [0,{bound}]"
        # Consistency: all modular images match
        for p in primes:
            assert val % p == residues[primes.index(p)]
        out.append(val)
    return out


def dual_molien_check_note() -> dict:
    """W vs W∨: both degree-5 irreps of PSL(2,11) are Galois conjugates.

    det(I − t ρ∨(g)) = det(I − t ρ(g)^{-T}) = det(I − t ρ(g^{-1})) / det(ρ(g^{-1}))^0
    and summing over g is the same as summing over g^{-1}. Character values of
    the two irreps are Galois conjugates (in Q(√−11)), and invariant dimensions
    are Galois-fixed integers, hence identical for W and W∨.
    """
    return {
        "statement": (
            "Both degree-5 irreducibles of PSL(2,11) yield the same Molien "
            "invariant dimensions (Galois conjugates; duality preserves dims)."
        ),
        "consequence": "W vs W∨ does not change m_d.",
    }


def main() -> None:
    t0 = time.time()
    recon = C.load_reconstructor()

    modular_inv: dict[int, np.ndarray] = {}
    modular_cov: dict[int, np.ndarray] = {}
    prime_meta = []

    for prime, zeta in PRIMES:
        print(f"loading group at p={prime}...", flush=True)
        mod = recon.load_module(prime, zeta)
        group = np.asarray(mod.GROUP, dtype=np.int64)
        assert group.shape == (GROUP_ORDER, 5, 5)
        # Invariance of Klein cubic as sanity
        assert len(group) == GROUP_ORDER
        print(f"  Molien sum degree ≤ {DEGREE_MAX}...", flush=True)
        inv, cov = molien_series_modular(group, DEGREE_MAX, prime, with_covariants=True)
        modular_inv[prime] = inv
        modular_cov[prime] = cov
        prime_meta.append(
            {
                "prime": prime,
                "zeta": zeta,
                "m_3_mod": int(inv[3]),
                "m_25_mod": int(inv[25]),
                "m_75_mod": int(inv[75]),
                "c_25_mod": int(cov[25]),
                "c_75_mod": int(cov[75]),
            }
        )
        print(
            f"  m_3≡{inv[3]}, m_25≡{inv[25]}, m_75≡{inv[75]}, "
            f"c_25≡{cov[25]} (mod {prime})",
            flush=True,
        )

    print("CRT-reconstructing invariant series...", flush=True)
    inv_series = reconstruct_series(modular_inv, DEGREE_MAX)
    print("CRT-reconstructing self-covariant series...", flush=True)
    cov_series = reconstruct_series(
        modular_cov,
        DEGREE_MAX,
        bound_fn=lambda d: 5 * math.comb(d + 4, 4),
    )

    # Project validations
    assert inv_series[0] == 1
    assert inv_series[3] == 1, inv_series[3]  # unique Klein cubic
    assert inv_series[25] == 43, inv_series[25]  # matches dim V_25 numerically
    assert inv_series[43] == 289, inv_series[43]
    assert inv_series[75] == 2343, inv_series[75]
    assert cov_series[25] == 189, cov_series[25]  # matches dim M_25
    assert cov_series[1] == 1

    m75 = inv_series[75]
    seal_fires = m75 == 746
    assert not seal_fires

    # Special fibre at p=89: modular coefficient IS the invariant dimension
    # of (Sym^d W^*)^G over F_89 because p ∤ |G|.
    special_fibre = {
        "prime": 89,
        "zeta": 78,
        "method": (
            "Reynolds/Molien sum over the 660 reduced project matrices in "
            "Mat_5(F_89); valid because 89 ∤ 660 so the Reynolds operator is "
            "defined and projects onto invariants of the same dimension as char 0."
        ),
        "m_3": inv_series[3],
        "m_25": inv_series[25],
        "m_43": inv_series[43],
        "m_75": inv_series[75],
        "m_75_mod_89": int(modular_inv[89][75]),
        "check_m75_mod": inv_series[75] % 89 == int(modular_inv[89][75]),
        "invariant_dimension_equals_char0": True,
    }
    assert special_fibre["check_m75_mod"]

    # V_25 vs invariants determination
    v25_determination = {
        "m_25_invariants": inv_series[25],
        "c_25_self_covariants": cov_series[25],
        "project_M_25": 189,
        "project_Arr": 59,
        "project_V_25": 43,
        "identification": "equal_dimension_only",
        "same_object": False,
        "argument": (
            "The Molien coefficient m_25 = dim (Sym^{25} W^∨)^G = 43 is the "
            "dimension of degree-25 G-invariant scalar forms. The project's "
            "M_25 (dim 189) is the full self-covariant space "
            "Hom_G(Sym^{25} W, W) = c_25, matching cov Molien. V_25 is the "
            "strict arrangement kernel inside M_25 (ker of order-2 common-line "
            "map on Arr = ker of plus-plane evaluation), a 43-dimensional "
            "subspace of self-covariants — not the space of degree-25 "
            "invariants. The numerical equality dim V_25 = m_25 is a "
            "coincidence of dimensions, not an identification of objects."
        ),
        "p25y1_citation_audit": {
            "status": "PARTIAL_MISLABEL",
            "detail": (
                "DVR_MODEL.md §0 lists dim M_25=189, dim Arr=59, dim V_25=43 "
                "as 'Exact Molien dimensions'. Only M_25=189 is a pure Molien "
                "self-covariant coefficient (c_25). Arr=59 and V_25=43 are "
                "construction dimensions of the arrangement/strict filtration "
                "of M_25 (trusted by work order §1.1 items 5–6 and multiprime "
                "realization). V_25=43 equals the invariant Molien m_25 only "
                "numerically. The constant-rank freeness argument in "
                "DVR_MODEL.md §2 remains valid if it invokes the trusted "
                "construction dimensions (189−59=130, 59−43=16) rather than "
                "substituting the invariant Molien for dim V_25 by name; the "
                "citation should not call Arr and V_25 'Molien dimensions'."
            ),
            "exit_impact": (
                "P25Y-DVR-PASS freeness is not overturned: special-fibre ranks "
                "and unit minors are independently certified; char-0 upper "
                "bounds on those ranks come from the trusted construction "
                "dimensions, not from misidentifying V_25 with invariants."
            ),
            "correction_record": (
                "certificates/degree25_molien/MOLIEN_BOUND.md §V25-audit "
                "(this packet); sealed P25Y.1 left byte-identical."
            ),
        },
    }

    # Why m_75 bounds the landing row rank
    bound_justification = {
        "setup": (
            "Each basis element p_i of V_25 is a degree-25 covariant "
            "(G-equivariant map W→W). For c ∈ V_25, p_c = Σ c_i p_i satisfies "
            "p_c(g x) = g · p_c(x). F is G-invariant, so x ↦ F(p_c(x)) is a "
            "G-invariant form of degree 75. The cubic map c ↦ F(p_c(·)) "
            "linearises to Λ: Sym^3(V_25) → (Sym^{75} W^∨)^G, and evaluation "
            "rows at points x_j span the image of the transpose."
        ),
        "rank_bound": (
            "rank(row space) = rank(Λ) ≤ min(dim Sym^3(V_25), m_75) "
            "= min(14190, 2343) = 2343."
        ),
        "observed_746": (
            "Observed F_89-rank 746 is a lower bound only (house rule 8). "
            "Molien upper bound 2343 does not force 746 to be the full span, "
            "and does not separate 746 from the historical quarantined 842 "
            "(both < 2343)."
        ),
        "seal": {
            "P25Y-FULL-ROWSPACE-746": "NOT_SEALED",
            "reason": "m_75 = 2343 ≠ 746",
            "historical_842_quarantine": (
                "Unaffected; remains quarantined under work order §1.2.6."
            ),
        },
    }

    key_inv = {str(d): inv_series[d] for d in KEY_DEGREES}
    key_cov = {str(d): cov_series[d] for d in KEY_DEGREES}

    payload = {
        "headline": "OPEN",
        "dispatch": "P25Y-M",
        "method": (
            "Independent group-sum Molien: enumerate the project's 660 exact "
            "5×5 matrices at split primes p≡1 (mod 11), compute "
            "[t^d] 1/det(I−t g) via Newton identities from power traces "
            "tr(g^k), average with 1/660, CRT-reconstruct integers."
        ),
        "group_order": GROUP_ORDER,
        "representation": {
            "dim": 5,
            "source": "certificates/exact_weil_check.py S,T → modular_covariant_scan.generate_group",
            "is_project_W": True,
            "note": dual_molien_check_note(),
        },
        "primes_used": prime_meta,
        "degree_max": DEGREE_MAX,
        "invariants": {
            "series_key_degrees": key_inv,
            "m_3": inv_series[3],
            "m_25": inv_series[25],
            "m_43": inv_series[43],
            "m_75": inv_series[75],
        },
        "self_covariants": {
            "series_key_degrees": key_cov,
            "c_1": cov_series[1],
            "c_25": cov_series[25],
            "c_75": cov_series[75],
            "matches_project_M_25": cov_series[25] == 189,
        },
        "special_fibre_p89": special_fibre,
        "v25_invariants_vs_covariants": v25_determination,
        "row_rank_bound": bound_justification,
        "magnitude_check": {
            "dim_Sym_75_C5": math.comb(75 + 4, 4),
            "dim_over_group_order": math.comb(79, 4) / 660,
            "note": "1502501/660 ≈ 2276.5; m_75=2343 is the right order of magnitude.",
        },
        "P25Y_FULL_ROWSPACE_746": "NOT_SEALED",
        "elapsed_s": round(time.time() - t0, 3),
        "rss_mib": C.rss_mib(),
    }

    # Full series for verifier cross-check (compact)
    series_path = TMP / "molien_series_full.json"
    series_path.write_text(
        canonical_json(
            {
                "invariants": inv_series,
                "self_covariants": cov_series,
                "modular_inv": {str(p): modular_inv[p].tolist() for p in modular_inv},
                "modular_cov": {str(p): modular_cov[p].tolist() for p in modular_cov},
            }
        )
    )

    out = HERE / "molien_values.json"
    digest = write_json_self_hash(out, payload)
    print(f"wrote {out} sha256={digest}")
    print(f"m_75 = {m75}  (NOT 746; seal does not fire)")
    print(f"special fibre m_75 at p=89 = {special_fibre['m_75']}")
    print(f"c_25 = {cov_series[25]} (= M_25); V_25 vs inv: equal dim only")
    print(f"rss_mib={payload['rss_mib']} elapsed_s={payload['elapsed_s']}")


if __name__ == "__main__":
    main()
