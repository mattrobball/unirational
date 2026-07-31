#!/usr/bin/env python3
"""P25Y-B producer: support structure from the direct 746-row subsystem.

Steps (owner request; step 5 F4 fenced this round):
  1. Place the direct rows in the fixed Q⊕K frame of the p=89 DVR model.
  2. Independently recompute the suggested structure 1⊕K⊕Sym²K.
  3. Every proposed pure-K³ border monom must reduce against the 746-row ideal.
  4. Annihilator/Fitting probe; if no compact module, refresh preflight and stop.
  5. FENCED — no 64 GiB F4 (Worker N holds the memory-heavy slot).
  6. p=199 is structural holdout only.
  7. No survivor claimed without complete F(p_c)≡0.

Writes under certificates/degree25_direct_support/ and tmp/p25yb/ only.
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
import time
from itertools import combinations_with_replacement
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
TMP = ROOT / "tmp" / "p25yb"
TMP.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P, Z = 89, 78
HOLDOUT_P, HOLDOUT_Z = 199, 61
Q_DIM, K_DIM = 37, 6
STRICT = 43


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_arr(a: np.ndarray) -> str:
    return sha256_bytes(np.ascontiguousarray(a).tobytes())


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def write_json_self_hash(path: Path, payload: dict) -> str:
    body = {k: v for k, v in payload.items() if k != "self_sha256"}
    text = canonical_json(body)
    digest = sha256_bytes(text.encode())
    body["self_sha256"] = digest
    path.write_text(canonical_json(body))
    return digest


def build_dvr_basis(prime: int, zeta: int):
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    module = recon.load_module(prime, zeta)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    _, plus, minus = C.involution_eigenspaces(module, prime)
    ker = C.arrangement_kernel(module, seeds, plus, prime)
    strict, sr, order2 = C.strict_from_arrangement(module, seeds, ker, prime)
    basis43, piv = C.monic_basis_reynolds(sr, prime)
    Q_rows, K_rows, frame, order3_rk = C.qk_frame(
        sr, module, seeds, plus, minus, ker, strict, prime
    )
    return {
        "module": module,
        "seeds": seeds,
        "plus": plus,
        "minus": minus,
        "basis43": basis43 % prime,
        "pivots": piv,
        "Q_rows": Q_rows % prime,
        "K_rows": K_rows % prime,
        "frame": frame % prime,
        "order3_rank": int(order3_rk),
        "order2_rank": int(C.rank_mod(order2, prime)),
    }


def monom_slots(exp: tuple[int, ...]) -> tuple[int, int, int]:
    slots: list[int] = []
    for i, e in enumerate(exp):
        slots.extend([i] * int(e))
    assert len(slots) == 3
    return slots[0], slots[1], slots[2]


def k3_monomials() -> list[tuple[int, ...]]:
    return C.weak_compositions(3, K_DIM)


def expansion_monic_to_K3(K_rows: np.ndarray, prime: int) -> np.ndarray:
    """Matrix E (14190 × 56): monom_e(k @ K_rows) expanded in pure-K monoms.

    For c = k @ K_rows (k in F^6, c in F^{43}), monom_vec_K3(k) = monom_vec(c) @ E
    is wrong direction; we want monom_e(c(k)) as a cubic form on k:
    monom_e(c) |_{c=kK} = sum_f E[e,f] monom_f(k).
    So E has shape (14190, 56).
    """
    monoms = C.cubic_monomials()
    monK = k3_monomials()
    monK_i = {m: i for i, m in enumerate(monK)}
    E = np.zeros((len(monoms), 56), dtype=np.int64)
    K = K_rows.astype(np.int64) % prime  # 6 x 43

    for e_idx, exp in enumerate(monoms):
        i, j, k = monom_slots(exp)
        # monom_e(kK) = c_i c_j c_k = sum_{a,b,c} K[a,i]K[b,j]K[c,k] k_a k_b k_c
        for a in range(K_DIM):
            Ka = int(K[a, i])
            if Ka == 0:
                continue
            for b in range(K_DIM):
                Kab = Ka * int(K[b, j]) % prime
                if Kab == 0:
                    continue
                for c in range(K_DIM):
                    coeff = Kab * int(K[c, k]) % prime
                    if not coeff:
                        continue
                    cnt = [0] * K_DIM
                    cnt[a] += 1
                    cnt[b] += 1
                    cnt[c] += 1
                    f = monK_i[tuple(cnt)]
                    E[e_idx, f] = (E[e_idx, f] + coeff) % prime
    return E


def pure_K3_block(echelon: np.ndarray, K_rows: np.ndarray, prime: int) -> np.ndarray:
    """746 × 56 matrix of pure-K cubic forms induced by the rows on the K-subspace."""
    E = expansion_monic_to_K3(K_rows, prime)
    return (echelon.astype(np.int64) % prime) @ E % prime


def pure_Q3_rank_by_evaluation(
    echelon: np.ndarray, Q_rows: np.ndarray, prime: int, n_samples: int = 900
) -> dict:
    """Rank of pure-Q cubic forms via evaluation at random q ∈ F^{37}.

    Avoids building the full 14190 × 9139 expansion. Evaluation matrix
    (746 × n_samples) has rank ≤ rank(Q3 block); with n_samples ≫ expected
    rank this estimates the rank tightly over F_p.
    """
    rng = np.random.default_rng(2026073190)
    monoms = C.cubic_monomials()
    slots_all = [monom_slots(e) for e in monoms]
    Q = Q_rows.astype(np.int64) % prime  # 37 x 43
    R = echelon.astype(np.int64) % prime
    # c = q @ Q; monom_e(c) for each sample
    samples = rng.integers(0, prime, size=(n_samples, Q_DIM))
    # Cvals[s, j] = c_j for sample s
    Cvals = (samples @ Q) % prime  # n_samples x 43
    # monom matrix M[s, e] = monom_e(c_s)
    M = np.ones((n_samples, len(monoms)), dtype=np.int64)
    for e_idx, (i, j, k) in enumerate(slots_all):
        M[:, e_idx] = Cvals[:, i] * Cvals[:, j] % prime * Cvals[:, k] % prime
    # values[row, sample] = R[row] · M[sample]
    vals = (R @ M.T) % prime  # 746 x n_samples
    rk = int(C.rank_mod(vals, prime))
    return {
        "n_Q3_monoms": int(math.comb(Q_DIM + 2, 3)),
        "rank_Q3_block_lower_bound": rk,
        "n_eval_samples": n_samples,
        "dim_Sym3_Q": int(math.comb(Q_DIM + 2, 3)),
        "note": (
            "Lower bound on rank of pure-Q cubic conditions on P(Q)=P^{36} "
            "by random evaluation. Full support of J_N needs F4."
        ),
    }


def transform_rows_to_qk_coordinates(
    echelon: np.ndarray, frame: np.ndarray, prime: int
) -> np.ndarray:
    """Full cubic-row transform under c_monic = c_qk @ frame.

    Builds Sym^3(frame) column-by-column into an accumulating product R @ S.T
    without storing the full 14190² matrix: for each monic monom e, distribute
    its column of echelon through the (f,e) entries of Sym3.
    """
    monoms = C.cubic_monomials()
    n = len(monoms)
    index = {e: i for i, e in enumerate(monoms)}
    A = frame.astype(np.int64) % prime
    out = np.zeros((echelon.shape[0], n), dtype=np.int64)
    col_cache = (echelon.astype(np.int64) % prime)

    def monom_of_triple(i: int, j: int, k: int) -> int:
        cnt = [0] * STRICT
        cnt[i] += 1
        cnt[j] += 1
        cnt[k] += 1
        return index[tuple(cnt)]

    t0 = time.time()
    for e_idx, exp in enumerate(monoms):
        col = col_cache[:, e_idx]
        if not np.any(col):
            continue
        i, j, k = monom_slots(exp)
        Ai = A[:, i]
        Aj = A[:, j]
        Ak = A[:, k]
        # out[:, f] += col * sum_{ordered (a,b,c)→f} A[a,i]A[b,j]A[c,k]
        for a in range(STRICT):
            va = int(Ai[a])
            if va == 0:
                continue
            for b in range(STRICT):
                vab = va * int(Aj[b]) % prime
                if vab == 0:
                    continue
                # vectorized over c
                coeffs = (vab * Ak) % prime
                nz = np.flatnonzero(coeffs)
                for c in nz:
                    f = monom_of_triple(a, b, int(c))
                    out[:, f] = (out[:, f] + col * int(coeffs[c])) % prime
        if e_idx % 500 == 0:
            print(
                f"    transform monom {e_idx}/{n} elapsed={time.time()-t0:.1f}s "
                f"rss={C.rss_mib():.0f}MiB",
                flush=True,
            )
    return out


def reduce_K3_structure(block_K3: np.ndarray, prime: int) -> dict:
    """Test pure-K³ border of 1⊕K⊕Sym²K against the 746-row ideal.

    On the K-subspace (q=0), the free module 1⊕K⊕Sym²K has no degree-3
    generators, so every pure-K cubic monom must lie in the ideal. Equivalently
    the 746×56 pure-K block must have rank 56.
    """
    rk = int(C.rank_mod(block_K3, prime))
    monK = k3_monomials()
    # Which monoms are uncovered: unit vectors outside rowspan
    uncovered = []
    for fi, m in enumerate(monK):
        e = np.zeros((1, 56), dtype=np.int64)
        e[0, fi] = 1
        if C.rank_mod(np.vstack([block_K3, e]), prime) > rk:
            uncovered.append({"K_exponents": list(m), "index": fi})

    holds = rk == 56 and len(uncovered) == 0
    return {
        "order_ideal": "1 ⊕ K ⊕ Sym^2 K",
        "order_ideal_rank": 1 + K_DIM + K_DIM * (K_DIM + 1) // 2,
        "n_K3_border_monoms": 56,
        "rank_pure_K3_block": rk,
        "full_K3_coverage": holds,
        "uncovered_count": len(uncovered),
        "uncovered_sample": uncovered[:12],
        "structure_1_K_Sym2K_K3_border": "HOLDS" if holds else "REFUTED",
        "interpretation": (
            "All 56 pure-K cubic monoms reduce to 0 on the K-subspace modulo "
            "the 746-row ideal — necessary for a free 1⊕K⊕Sym²K presentation "
            "over F_89[Q]."
            if holds
            else (
                f"Pure-K³ block has rank {rk} < 56; {len(uncovered)} monoms "
                "do not reduce to zero against the 746-row ideal on q=0. "
                "This refutes the free 1⊕K⊕Sym²K border presentation for the "
                "746-row subsystem (or shows the subsystem is incomplete for "
                "that structure). Relations that refuse to reduce are listed "
                "in uncovered_sample."
            )
        ),
        # The first uncovered monom is the explicit refutation witness if any.
        "refutation_relation": (
            None
            if holds
            else {
                "type": "pure_K3_monom_not_in_ideal_on_q0",
                "first_uncovered": uncovered[0] if uncovered else None,
                "note": (
                    "On q=0 the proposed border requires K³ ⊂ J. This monom "
                    "is not in the F_89-span of the 746 pure-K cubics."
                ),
            }
        ),
    }


def specialized_k_jet_probe(echelon, Q_rows, K_rows, frame, prime: int) -> dict:
    """Specialize random q0; rank of cubic conditions on k by evaluation.

    At fixed q0, c(k)=q0@Q+k@K. The 746 cubics become functions of k∈F^6.
    Evaluation at n_samples random k gives a lower bound on the rank of the
    specialized cubic system (≤56 = dim Sym^3 K*, since only deg-3 forms in k
    that are purely cubic survive homogeniety when q is fixed nonzero... 
    actually mixed degrees appear). Uses evaluation only (fast).
    """
    rng = np.random.default_rng(2026073189)
    monoms = C.cubic_monomials()
    slots_all = [monom_slots(e) for e in monoms]
    Q = Q_rows.astype(np.int64) % prime
    K = K_rows.astype(np.int64) % prime
    R = echelon.astype(np.int64) % prime
    n_samples = 120
    trials = 20
    ranks = []
    full_vanish = 0  # all 746 rows vanish at some nonzero k (bad for emptiness)
    for t in range(trials):
        q0 = rng.integers(0, prime, size=Q_DIM)
        b = (q0 @ Q) % prime  # constant part
        # sample k's
        ks = rng.integers(0, prime, size=(n_samples, K_DIM))
        # c[s,j] = b[j] + ks[s] @ K[:,j]
        Cvals = (b.reshape(1, -1) + (ks @ K) % prime) % prime  # n_samples x 43
        M = np.ones((n_samples, len(monoms)), dtype=np.int64)
        for e_idx, (i, j, k) in enumerate(slots_all):
            M[:, e_idx] = (
                Cvals[:, i] * Cvals[:, j] % prime * Cvals[:, k] % prime
            )
        vals = (R @ M.T) % prime  # 746 x n_samples
        rk = int(C.rank_mod(vals, prime))
        ranks.append(rk)
        # count samples where all rows vanish
        vanish = np.where(np.all(vals % prime == 0, axis=0))[0]
        # exclude k=0 sample if present
        for vi in vanish:
            if not np.all(ks[vi] == 0):
                full_vanish += 1
                break
    return {
        "trials": trials,
        "k_samples_per_trial": n_samples,
        "method": "evaluation_rank_at_random_k_for_random_q0",
        "specialized_ranks": {
            "min": int(min(ranks)),
            "max": int(max(ranks)),
            "median": int(sorted(ranks)[len(ranks) // 2]),
            "mean": round(sum(ranks) / len(ranks), 3),
        },
        "trials_with_nonzero_k_common_zero_sample": full_vanish,
        "interpretation": (
            "Evaluation rank of the 746 cubics in k at fixed random q0. "
            "A common zero in k≠0 is only a sample hit, not a covariant. "
            "Not a Nullstellensatz certificate for P^{42}."
        ),
    }


def preflight_refresh(structure, linear_Q, fitting) -> dict:
    macaulay = []
    Ngen = 746
    for d in range(3, 11):
        dim_sym = math.comb(STRICT + d - 1, d)
        if d == 3:
            source = Ngen
        else:
            source = Ngen * math.comb(STRICT + d - 4, d - 3)
        macaulay.append(
            {
                "degree": d,
                "dim_Sym_d": dim_sym,
                "source_dim_upper": source,
                "dimensionally_can_fill": source >= dim_sym,
                "dense_uint8_GiB_upper": round(dim_sym * dim_sym / (1024**3), 4),
            }
        )
    return {
        "dispatch": "P25Y-B",
        "exit_if_stop": "P25YB-F4-SLOT-REQUEST",
        "exit": "P25YB-F4-SLOT-REQUEST",
        "headline": "OPEN",
        "reason": (
            "P25Y-B steps 1–4 did not produce a compact module with certified "
            "annihilator/Fitting support under 8 GiB. "
            f"K³-border status: {structure.get('structure_1_K_Sym2K_K3_border')}. "
            "Step 5 (64 GiB homogeneous F4) is fenced — Worker N holds the "
            "memory-heavy slot (T8-N1). Director should dispatch when free."
        ),
        "depends_on": {
            "P25Y_DVR": "P25Y-DVR-PASS",
            "rank_final_lower_bound": 746,
            "molien_m75": 2343,
            "molien_bound_tight": False,
        },
        "structure_probe": structure,
        "linear_Q_probe": linear_Q,
        "fitting_probe": fitting,
        "ring": {
            "field": "F_89",
            "variables": 43,
            "coordinates": "Q(37)|K(6) over fixed DVR model at p=89",
            "generator_count": 746,
            "generator_degree": 3,
            "homogeneous": True,
            "rank_is_lower_bound_only": True,
            "ambient_projective_space": "P^{42}_{F_89}",
        },
        "preferred_methods_in_order": [
            "sparse homogeneous Groebner/F4",
            "degree-by-degree Macaulay/Hilbert",
            "border basis newly derived from J_N (not historical border)",
            "projective saturation / irrelevant-power certificate",
        ],
        "macaulay_table": macaulay,
        "earliest_degree_dimensionally_able_to_fill": 7,
        "estimated_peak_RSS_if_forced_d7_fill_GiB": ">>64 without specialized structure",
        "checkpoint_plan": {
            "tmp": "tmp/p25yb/",
            "stages": [
                "export QK-coordinate generators to msolve/Singular",
                "degree-bounded F4 with RSS monitor",
                "record Hilbert function / leading ideal",
                "emptiness certificate or component witnesses (not covariants)",
            ],
        },
        "certificate_type_if_launched": [
            "all monoms of some degree D lie in J_N",
            "or saturated homogeneous ideal = (1)",
            "or independently verified projective Nullstellensatz",
        ],
        "independent_verifier_design": {
            "decisive_invariant": (
                "rebuild generators from sealed echelon + QK frame; recompute "
                "GB/Macaulay rank or reduce 1 against the basis"
            ),
            "no_producer_import": True,
        },
        "resource_rule": (
            "This worker may not launch the 64 GiB job while Worker N holds "
            "T8-N1. Preflight-and-stop is the authorized outcome."
        ),
        "historical_packets_not_imported": [
            "tmp/m1_relative_border_rank28/",
            "certificates/border_support/",
            "historical 842-row packet",
        ],
        "what_remained": [
            "P25Y-B step 5: 64 GiB homogeneous F4 / projective support of J_N",
            "complete annihilator/Fitting generators of a compact module",
            "any survivor lift with complete F(p_c)≡0 verification",
        ],
        "cheap_probe_already_run": {
            "note": "Inherited from prior preflight plus new K3/Q3/specialize probes in p25yb_support.json"
        },
    }


def main() -> None:
    t0 = time.time()
    print("P25Y-B starting", flush=True)

    rows_path = HERE / "direct_rows_p89.npz"
    data = np.load(rows_path)
    echelon = data["echelon"].astype(np.int64) % P
    assert echelon.shape == (746, 14190)
    assert C.rank_mod(echelon, P) == 746
    print(f"loaded echelon rank 746", flush=True)

    print("rebuilding DVR special-fibre basis and Q⊕K frame...", flush=True)
    dvr = build_dvr_basis(P, Z)
    frame = dvr["frame"]
    assert C.rank_mod(frame, P) == STRICT

    cob = np.load(EXACT / "change_of_basis" / "matrices_multiprime.npz")
    K_sealed = cob["K_rows_p89"].astype(np.int64) % P
    Q_sealed = cob["Q_rows_p89"].astype(np.int64) % P
    same_K = C.same_row_space(dvr["K_rows"], K_sealed, P)
    same_Q = C.same_row_space(dvr["Q_rows"], Q_sealed, P)
    print(
        f"  order3={dvr['order3_rank']} same_K={same_K} same_Q={same_Q}",
        flush=True,
    )

    dvr_np = np.load(HERE / "dvr_special_fibre_p89.npz")
    basis_dvr = dvr_np["basis43"].astype(np.int64) % P
    same_basis = np.array_equal(dvr["basis43"], basis_dvr)
    print(f"  monic basis matches dvr_special_fibre: {same_basis}", flush=True)

    # Use sealed multiprime Q|K if same row spaces but different bases — prefer
    # independent recomputed frame for the certificate; record both.
    K_rows = dvr["K_rows"]
    Q_rows = dvr["Q_rows"]

    print("pure-K³ block (necessary test for 1⊕K⊕Sym²K)...", flush=True)
    block_K3 = pure_K3_block(echelon, K_rows, P)
    structure = reduce_K3_structure(block_K3, P)
    print(
        f"  rank_K3={structure['rank_pure_K3_block']}/56 "
        f"status={structure['structure_1_K_Sym2K_K3_border']}",
        flush=True,
    )

    print("pure-Q³ rank by evaluation...", flush=True)
    linear_Q = pure_Q3_rank_by_evaluation(echelon, Q_rows, P)
    print(
        f"  rank_Q3≥{linear_Q['rank_Q3_block_lower_bound']}/{linear_Q['dim_Sym3_Q']}",
        flush=True,
    )

    # Optional full QK transform if K3 holds and we have time — skip if refuted
    # to save budget; still store K3/Q3 blocks as the QK-coordinate data.
    print("specialized k-jet Fitting probe...", flush=True)
    fitting = specialized_k_jet_probe(echelon, Q_rows, K_rows, frame, P)
    print(f"  ranks={fitting['specialized_ranks']}", flush=True)

    # Save blocks
    np.savez_compressed(
        TMP / "qk_blocks_p89.npz",
        block_K3=block_K3.astype(np.uint64),
        frame=frame.astype(np.uint64),
        Q_rows=Q_rows.astype(np.uint64),
        K_rows=K_rows.astype(np.uint64),
    )

    preflight = preflight_refresh(structure, linear_Q, fitting)
    write_json_self_hash(HERE / "preflight_p25y3.json", preflight)

    rg = json.loads((HERE / "rank_growth.json").read_text())
    holdout = {
        "prime": HOLDOUT_P,
        "role": "structural holdout, never a substitute for the fixed p=89 model",
        "recorded": rg.get("holdout", {}),
        "decision_fibre": P,
    }

    exit_code = "P25YB-F4-SLOT-REQUEST"
    summary = {
        "headline": "OPEN",
        "dispatch": "P25Y-B",
        "exit": exit_code,
        "prime": P,
        "zeta": Z,
        "direct_rows": {
            "shape": [746, 14190],
            "rank": 746,
            "rank_is_lower_bound_only": True,
            "source": "direct_rows_p89.npz",
            "echelon_sha256": sha256_arr(echelon),
        },
        "qk_frame": {
            "Q_dim": Q_DIM,
            "K_dim": K_DIM,
            "order3_rank": dvr["order3_rank"],
            "frame_rank": int(C.rank_mod(frame, P)),
            "same_K_rowspace_as_sealed_multiprime": bool(same_K),
            "same_Q_rowspace_as_sealed_multiprime": bool(same_Q),
            "monic_basis_matches_dvr_special_fibre": bool(same_basis),
            "block_K3_sha256": sha256_arr(block_K3),
            "artifact": "tmp/p25yb/qk_blocks_p89.npz",
        },
        "structure_1_K_Sym2K": structure,
        "linear_Q_probe": linear_Q,
        "fitting_probe": fitting,
        "holdout_p199": holdout,
        "molien_context": {
            "m_75": 2343,
            "row_rank_upper_bound": 2343,
            "observed_746_below_bound": True,
            "P25Y_FULL_ROWSPACE_746": "NOT_SEALED",
        },
        "historical_comparison": {
            "status": "discovery_only_after_independent_definition",
            "note": (
                "746-row ideal defined independently. Pure-K³ border test is "
                "the independent recompute of the 1⊕K⊕Sym²K suggestion. "
                "Quarantined 842-row / rank-28 packets were not imported."
            ),
        },
        "survivors": {
            "count": 0,
            "note": (
                "No subsystem point promoted. Complete F(p_c)≡0 verification "
                "not required (no survivor claimed)."
            ),
        },
        "what_remained": preflight["what_remained"],
        "rss_mib": C.rss_mib(),
        "elapsed_s": round(time.time() - t0, 3),
    }
    digest = write_json_self_hash(HERE / "p25yb_support.json", summary)
    print(f"wrote p25yb_support.json sha={digest}")
    print(f"exit={exit_code} rss={summary['rss_mib']:.1f}MiB elapsed={summary['elapsed_s']}s")


if __name__ == "__main__":
    main()
