#!/usr/bin/env python3
"""P25W.1 — exact degree-four closure criterion for the sealed lower presentation.

Constructs the graded piece (N_0)_4 = S_1 · (N_0)_3 inside F_4 and records the
exact finite-dimensional membership problem for:

  1. all 6·690 elements T_i(s_a);
  2. all commutator defects (T_i T_j − T_j T_i)b on the 28 basis vectors.

Component analysis (exact over F_89):
  - For every quadratic basis component bi (deg 2): V_bi = S_1, so S_1·V_bi = S_2
    and every degree-4 test is automatic on those 21 components.
  - For every linear basis component bi (deg 1): dim V_bi = 690 and
    S_1·V_bi = S_3 (full), so every degree-4 test is automatic on those 6 components.
  - For the pure-q component bi = 0 (deg 0): V_0 ⊂ S_3 has rank 690 in dimension
    9139, and membership in S_1·V_0 ⊂ S_4 (dim 91390) is a genuine
    91390 × (690·37) linear-algebra problem. That is the remaining bottleneck.

Exit this round: P25W-PRESENTATION-UNDECIDED with exact matrix dimensions and
measured resource floor. A specialized fibre test is not used as an exit.

Writes only under certificates/degree25_p25w/ and tmp/p25w_closure/.
"""
from __future__ import annotations

import json
import sys
import time
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
FM = ROOT / "certificates" / "degree25_finite_module"
TMP = ROOT / "tmp" / "p25w_closure"
HERE.mkdir(parents=True, exist_ok=True)
TMP.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89


def mul_maps(qmonoms, qindex, k: int):
    maps = []
    src = qmonoms[k]
    dst_index = qindex[k + 1]
    for j in range(37):
        mp = np.empty(len(src), dtype=np.int32)
        for i, m in enumerate(src):
            mm = list(m)
            mm[j] += 1
            mp[i] = dst_index[tuple(mm)]
        maps.append(mp)
    return maps


def rref_rows(M: np.ndarray):
    A = M.copy() % P
    pivots: list[int] = []
    r = 0
    rows, cols = A.shape
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if A[i, c] % P:
                piv = i
                break
        if piv is None:
            continue
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
        inv = pow(int(A[r, c]) % P, -1, P)
        A[r] = (A[r] * inv) % P
        col = A[:, c].copy()
        for i in range(rows):
            if i != r and col[i] % P:
                A[i] = (A[i] - col[i] * A[r]) % P
        pivots.append(c)
        r += 1
        if r == rows:
            break
    return A[:r], pivots


def dim_S1V_full_S3(Vb: np.ndarray, maps) -> int:
    """Incremental echelon image of S_1·V inside S_3 (dim 9139)."""
    r = Vb.shape[0]
    echelon: list[tuple[int, np.ndarray]] = []
    rank_img = 0
    for j in range(37):
        mp = maps[j]
        G = np.zeros((r, 9139), dtype=np.int64)
        for ii in range(Vb.shape[1]):
            G[:, mp[ii]] = (G[:, mp[ii]] + Vb[:, ii]) % P
        for vi in range(r):
            row = G[vi].copy()
            for piv, erow in echelon:
                c = int(row[piv]) % P
                if c:
                    row = (row - c * erow) % P
            nz = np.flatnonzero(row % P)
            if len(nz) == 0:
                continue
            piv = int(nz[0])
            inv = pow(int(row[piv]) % P, -1, P)
            row = (row * inv) % P
            echelon.append((piv, row))
            echelon.sort(key=lambda x: x[0])
            rank_img += 1
            if rank_img == 9139:
                return 9139
    return rank_img


def main() -> None:
    t0 = time.time()
    peak = C.rss_mib()
    print("=== P25W.1 degree-four closure ===", flush=True)

    rel = np.load(FM / "relation_matrix.npz")
    seed = rel["seed_F3"].astype(np.int64) % P
    off3 = rel["off3"]
    Bdeg = list(rel["Bdeg"])
    seed_sha = C.sha256_arr(rel["seed_F3"])

    mult = np.load(FM / "multiplication_matrices.npz")
    low_target = mult["low_target"]
    T_quad = mult["T_quad_F3"]
    T_sha = C.sha256_arr(T_quad)

    qmonoms = {
        d: ([(0,) * 37] if d == 0 else C.weak_compositions(d, 37))
        for d in range(0, 5)
    }
    qindex = {d: {m: i for i, m in enumerate(qmonoms[d])} for d in range(0, 5)}
    maps2 = mul_maps(qmonoms, qindex, 2)

    # Dimensions of graded pieces.
    dim_F3 = 14134
    dim_F4 = len(qmonoms[4]) + 6 * len(qmonoms[3]) + 21 * len(qmonoms[2])
    assert dim_F3 == 14134
    assert dim_F4 == 160987

    component = {}
    # deg-0 component
    t1 = time.time()
    Vb0, piv0 = rref_rows(seed[:, off3[0] : off3[1]])
    component[0] = {
        "Bdeg": 0,
        "rank_V": int(Vb0.shape[0]),
        "ambient_seed_deg": 3,
        "ambient_seed_dim": 9139,
        "ambient_target_deg": 4,
        "ambient_target_dim": 91390,
        "S1V_max_dim": min(91390, Vb0.shape[0] * 37),
        "membership_automatic": False,
        "seconds": time.time() - t1,
    }
    print(f"bi=0 rank_V={Vb0.shape[0]} S1V_max≤{component[0]['S1V_max_dim']}", flush=True)

    # deg-1 components: prove S_1·V = S_3
    for bi in range(1, 7):
        t1 = time.time()
        Vb, _ = rref_rows(seed[:, off3[bi] : off3[bi + 1]])
        dim_img = dim_S1V_full_S3(Vb, maps2)
        component[bi] = {
            "Bdeg": 1,
            "rank_V": int(Vb.shape[0]),
            "ambient_seed_dim": 703,
            "ambient_target_dim": 9139,
            "dim_S1V": dim_img,
            "membership_automatic": dim_img == 9139,
            "seconds": time.time() - t1,
        }
        peak = max(peak, C.rss_mib())
        print(
            f"bi={bi} rank_V={Vb.shape[0]} dim_S1V={dim_img}/9139 "
            f"auto={dim_img == 9139} t={component[bi]['seconds']:.1f}s rss={peak:.0f}",
            flush=True,
        )
        assert dim_img == 9139

    # deg-2 components: V = full S_1
    for bi in range(7, 28):
        rk = C.rank_mod(seed[:, off3[bi] : off3[bi + 1]], P)
        component[bi] = {
            "Bdeg": 2,
            "rank_V": int(rk),
            "ambient_seed_dim": 37,
            "ambient_target_dim": 703,
            "membership_automatic": rk == 37,
        }
        assert rk == 37
    print("deg2: all 21 components have V=S_1 (membership automatic)", flush=True)

    # Test inventory
    n_Ti = 6 * 690
    n_comm_pairs = 15  # C(6,2)
    # Exact deg≤1 commutators vanish (monomial identity); nonzero defects only on deg-2 basis.
    n_comm_quad = n_comm_pairs * 21  # upper bound on defect columns
    tests_remaining = {
        "T_i_sa": {
            "count": n_Ti,
            "all_nonzero_deg0_component": True,  # measured earlier: 4140/4140
            "remaining_membership": "deg0 component only (91390-dim)",
        },
        "commutator_defects": {
            "operator_pairs": n_comm_pairs,
            "quad_basis_columns_upper_bound": n_comm_quad,
            "deg_le_1_exact_zero": True,
            "remaining_membership": "deg0 component of defects on quadratic basis",
        },
    }

    # Exact matrix dimensions for the remaining deg0 membership engine.
    n_gen = 690 * 37  # generators of S_1 · V_0
    deg0_matrix = {
        "description": (
            "Membership of f ∈ S_4 in S_1·V_0, V_0 = span of the 690 seed "
            "degree-0 cubic coefficient rows. Columns of the generator matrix G "
            "are q_j · v_a for a=1..690, j=0..36."
        ),
        "G_shape": [91390, n_gen],
        "G_shape_note": "rows = monoms of deg 4 in 37 vars; cols = 690 seeds × 37 vars",
        "n_test_vectors_Ti": n_Ti,
        "storage_uint8_GiB": 91390 * n_gen / (1024**3),
        "naive_RREF_ops_estimate": float(n_gen) ** 2 * 91390,
        "measured_component_peak_rss_mib": peak,
        "resource_floor_gib": 16,
        "resource_floor_reason": (
            "Dense GE on a 25530-column subspace of S_4 (dim 91390) over F_89; "
            "uint8 storage of G alone is ~2.2 GiB; full RREF peak exceeds the "
            "8 GiB exploratory fence. Black-box Wiedemann needs O(n) matvecs of "
            "cost ~2e8 each (hours). Not a specialized-fibre substitute."
        ),
        "forbidden": "raw 43-variable degree-four F4/Macaulay (54.6 GiB historical)",
    }

    peak = max(peak, C.rss_mib())
    elapsed = time.time() - t0

    # Persist component table for the verifier.
    comp_path = HERE / "p25w1_component_spans.json"
    C.write_json_self_hash(
        comp_path,
        {
            "prime": P,
            "seed_F3_sha256": seed_sha,
            "components": {str(k): v for k, v in component.items()},
            "summary": {
                "deg0_automatic": False,
                "deg1_all_automatic": all(
                    component[bi]["membership_automatic"] for bi in range(1, 7)
                ),
                "deg2_all_automatic": all(
                    component[bi]["membership_automatic"] for bi in range(7, 28)
                ),
            },
        },
    )

    exit_code = "P25W-PRESENTATION-UNDECIDED"
    payload = {
        "dispatch": "P25W.1",
        "exit": exit_code,
        "prime": P,
        "criterion": (
            "Exact degree-four graded membership: T_i(s_a) ∈ (N_0)_4 and "
            "(T_i T_j − T_j T_i)b ∈ (N_0)_4 for all seeds/basis vectors, with "
            "(N_0)_4 = S_1 · (N_0)_3 inside the finite-dimensional F_89-space F_4."
        ),
        "inputs": {
            "relation_matrix": str(FM / "relation_matrix.npz"),
            "multiplication_matrices": str(FM / "multiplication_matrices.npz"),
            "seed_F3_sha256": seed_sha,
            "T_quad_F3_sha256": T_sha,
            "low_target_shape": list(low_target.shape),
        },
        "graded_dimensions": {
            "dim_F3": dim_F3,
            "dim_F4": dim_F4,
            "layout_F3": "9139 + 6*703 + 21*37",
            "layout_F4": "91390 + 6*9139 + 21*703",
            "n_seeds": 690,
            "n_basis_B": 28,
        },
        "component_analysis": {
            "artifact": str(comp_path.relative_to(ROOT)),
            "deg1_S1V_full_S3": True,
            "deg2_V_full_S1": True,
            "deg0_remaining": True,
        },
        "tests": tests_remaining,
        "deg0_membership_matrix": deg0_matrix,
        "theorem": {
            "proves": (
                "On every basis component of degree 1 or 2, the degree-four piece "
                "(N_0)_4 fills the whole ambient S_{4−deg b}·e_b. Consequently every "
                "T_i(s_a) and every commutator defect automatically lies in (N_0)_4 "
                "on those components. The only open membership is the pure-q "
                "(degree-0) component inside S_4."
            ),
            "does_not_prove": (
                "Full T_i-stability of N_0 over S; commutator defects in N_0 over S; "
                "exactness F/N_0 ≅ R/J. Specialized fibre T-stability from the "
                "P25Z packet is not reused as a proof over S."
            ),
            "scope": (
                "All ranks and spans are exact over F_89. Empty special fibre would "
                "still imply empty generic fibre by the sealed DVR properness theorem; "
                "that direction does not require presentation exactness."
            ),
        },
        "resource": {
            "peak_rss_mib": peak,
            "elapsed_seconds": elapsed,
            "exploratory_ceiling_gib": 8,
            "named_bottleneck": "deg0 membership GE in S_4 (91390 × 25530 over F_89)",
            "floor_gib": 16,
        },
    }
    C.write_json_self_hash(HERE / "exit_p25w1.json", payload)
    print(
        f"DONE exit={exit_code} peak_rss={peak:.0f} MiB t={elapsed:.1f}s",
        flush=True,
    )


if __name__ == "__main__":
    main()
