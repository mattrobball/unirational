#!/usr/bin/env python3
"""Independent verifier for P25Z.1 finite S-module presentation.

Does not import produce_presentation.py. Recomputes decisive invariants:
  - monic K³ rules from the 746-row QK matrix RREF
  - T_i structure from those rules
  - residual seed polyvectors and their rank
  - specialized fibre rank / T-stability / commutator-in-span
  - agreement of sealed artifacts with recomputation
"""
from __future__ import annotations

import hashlib
import json
import sys
import time
from itertools import combinations_with_replacement
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
TMP_BORDER = ROOT / "tmp" / "p25yf4_border"
TMP_PROBE = ROOT / "tmp" / "p25z1_probe"
TMP_BUILD = ROOT / "tmp" / "p25z1_build"

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89
Q_DIM, K_DIM, ORDER, N_ROWS = 37, 6, 28, 746
SEED_PM = 2026073189


def sha256_arr(a: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(a).tobytes()).hexdigest()


def order_B():
    B = [tuple([0] * K_DIM)]
    for i in range(K_DIM):
        e = [0] * K_DIM
        e[i] = 1
        B.append(tuple(e))
    for i, j in combinations_with_replacement(range(K_DIM), 2):
        e = [0] * K_DIM
        e[i] += 1
        e[j] += 1
        B.append(tuple(e))
    Bdeg = [sum(b) for b in B]
    Bindex = {b: i for i, b in enumerate(B)}
    return B, Bdeg, Bindex


def load_rref():
    for cache in (TMP_BUILD / "rref_A.npz", TMP_PROBE / "rref_A.npz", HERE / "rref_A.npz"):
        if cache.exists():
            z = np.load(cache)
            return (
                z["A"].astype(np.int64) % P,
                z["pivots"].astype(np.int32).tolist(),
                z["perm"].astype(np.int32),
            )
    # recompute
    rows = np.load(TMP_BORDER / "rows_qk.npz")["rows"].astype(np.int64) % P
    monoms = C.cubic_monomials()

    def kw(m):
        return int(sum(m[Q_DIM:]))

    buckets = {3: [], 2: [], 1: [], 0: []}
    for i, m in enumerate(monoms):
        buckets[kw(m)].append(i)
    perm = np.array(buckets[3] + buckets[2] + buckets[1] + buckets[0], dtype=np.int32)
    A = rows[:, perm].copy() % P
    pivots = []
    row = 0
    nrows, ncols = A.shape
    for col in range(ncols):
        piv = None
        for r in range(row, nrows):
            if A[r, col] % P != 0:
                piv = r
                break
        if piv is None:
            continue
        if piv != row:
            A[[row, piv]] = A[[piv, row]]
        inv = int(C.inv_mod(int(A[row, col]) % P, P))
        A[row] = (A[row] * inv) % P
        col_data = A[:, col].copy()
        for r in range(nrows):
            if r == row:
                continue
            f = int(col_data[r]) % P
            if f:
                A[r] = (A[r] - f * A[row]) % P
        pivots.append(col)
        row += 1
        if row >= nrows:
            break
    return A, pivots, perm


def main() -> int:
    t0 = time.time()
    checks = []
    failures = []

    def ok(name: str, cond: bool, detail: str = ""):
        checks.append({"name": name, "pass": bool(cond), "detail": detail})
        if not cond:
            failures.append(name)
            print(f"FAIL {name}: {detail}", flush=True)
        else:
            print(f"PASS {name}: {detail}", flush=True)

    # Load sealed artifacts
    rules = np.load(HERE / "rewrite_rules.npz")
    mul = np.load(HERE / "multiplication_matrices.npz")
    rel = np.load(HERE / "relation_matrix.npz")
    exit_j = json.loads((HERE / "exit_p25z1.json").read_text())
    ledger = json.loads((HERE / "closure_ledger.json").read_text())
    rules_j = json.loads((HERE / "rewrite_rules.json").read_text())
    mul_j = json.loads((HERE / "multiplication_matrices.json").read_text())
    rel_j = json.loads((HERE / "relation_matrix.json").read_text())

    B, Bdeg, Bindex = order_B()
    monoms = C.cubic_monomials()
    A, pivots, perm = load_rref()
    ordered = [monoms[int(i)] for i in perm]

    n_k3 = sum(1 for c in pivots if c < 56)
    n_qk2 = sum(1 for c in pivots if 56 <= c < 56 + 777)
    ok("rref_profile", n_k3 == 56 and n_qk2 == 690 and len(pivots) == 746,
       f"K3={n_k3} QK2={n_qk2} rank={len(pivots)}")

    qmonoms = {
        d: ([tuple([0] * Q_DIM)] if d == 0 else C.weak_compositions(d, Q_DIM))
        for d in range(0, 4)
    }
    qindex = {d: {m: i for i, m in enumerate(qmonoms[d])} for d in range(0, 4)}
    off3 = [0]
    for d in Bdeg:
        off3.append(off3[-1] + len(qmonoms[3 - d]))

    # Recompute monic rules
    rec_tails = {}
    monic_ok = True
    for r, c in enumerate(pivots):
        if c >= 56:
            continue
        k_exp = ordered[c][Q_DIM:]
        row = A[r]
        if int(row[c]) % P != 1:
            monic_ok = False
        for c2 in range(56):
            if c2 != c and int(row[c2]) % P != 0:
                monic_ok = False
        v = np.zeros(14134, dtype=np.int64)
        for col in range(56, 14190):
            coeff = int(row[col]) % P
            if not coeff:
                continue
            m = ordered[col]
            bi = Bindex[m[Q_DIM:]]
            dd = 3 - Bdeg[bi]
            v[off3[bi] + qindex[dd][m[:Q_DIM]]] = coeff
        rec_tails[k_exp] = v
    ok("monic_K3", monic_ok and len(rec_tails) == 56, f"n={len(rec_tails)} monic_ok={monic_ok}")

    # Compare sealed rules
    sealed_k = [tuple(int(x) for x in row) for row in rules["k_exp"]]
    sealed_tail = rules["tail_F3"].astype(np.int64) % P
    ok("sealed_rules_count", len(sealed_k) == 56, f"n={len(sealed_k)}")
    match = 0
    for i, ke in enumerate(sealed_k):
        if ke in rec_tails and np.array_equal(sealed_tail[i] % P, rec_tails[ke] % P):
            match += 1
    ok("sealed_rules_match_recompute", match == 56, f"match={match}/56")
    ok("rewrite_rules_sha", rules_j["tail_F3_sha256"] == sha256_arr(rules["tail_F3"]),
       rules_j["tail_F3_sha256"][:16])

    # Recompute seeds
    seed_rows = [r for r, c in enumerate(pivots) if c >= 56]
    rec_seed = np.zeros((len(seed_rows), 14134), dtype=np.int64)
    for si, r in enumerate(seed_rows):
        row = A[r]
        for col in range(56, 14190):
            coeff = int(row[col]) % P
            if not coeff:
                continue
            m = ordered[col]
            bi = Bindex[m[Q_DIM:]]
            dd = 3 - Bdeg[bi]
            rec_seed[si, off3[bi] + qindex[dd][m[:Q_DIM]]] = coeff
    sealed_seed = rel["seed_F3"].astype(np.int64) % P
    ok("seed_shape", sealed_seed.shape == (690, 14134), str(sealed_seed.shape))
    ok("seed_match_recompute", np.array_equal(sealed_seed, rec_seed % P), "byte match")
    seed_rank = int(C.rank_mod(sealed_seed, P))
    ok("seed_rank_690", seed_rank == 690, f"rank={seed_rank}")
    ok("relation_sha", rel_j["seed_F3_sha256"] == sha256_arr(rel["seed_F3"]),
       rel_j["seed_F3_sha256"][:16])

    # T_i from sealed vs recompute
    T_quad = mul["T_quad_F3"].astype(np.int64) % P
    low_target = mul["low_target"]
    quad_indices = mul["quad_indices"].tolist()

    def kprod(i, bi):
        b = list(B[bi])
        b[i] += 1
        return tuple(b)

    t_match = True
    for i in range(K_DIM):
        for qi, bi in enumerate(quad_indices):
            prod = kprod(i, bi)
            expect = (-rec_tails[prod]) % P
            if not np.array_equal(T_quad[i, qi] % P, expect):
                t_match = False
    ok("T_quad_match_recompute", t_match, "all 6*21 tails")
    # low targets
    low_ok = True
    for i in range(K_DIM):
        for bi in range(ORDER):
            if Bdeg[bi] <= 1:
                if int(low_target[i, bi]) != Bindex[kprod(i, bi)]:
                    low_ok = False
            else:
                if int(low_target[i, bi]) != -1:
                    low_ok = False
    ok("low_target_match", low_ok, "deg<=1 multiplications")

    # Specialized decisive invariant: relation rank 28, T-stable, empty fibre
    def eval_monom(qe, q0):
        v = 1
        for t, e in enumerate(qe):
            if e:
                v = v * pow(int(q0[t]), int(e), P) % P
                if v == 0:
                    return 0
        return v

    def monvals(q0):
        out = {}
        for d in range(4):
            mv = np.empty(len(qmonoms[d]), dtype=np.int64)
            for i, m in enumerate(qmonoms[d]):
                mv[i] = eval_monom(m, q0)
            out[d] = mv
        return out

    def eval_seeds(mv):
        S = np.zeros((690, ORDER), dtype=np.int64)
        for bi in range(ORDER):
            dd = 3 - Bdeg[bi]
            S[:, bi] = (
                sealed_seed[:, off3[bi] : off3[bi + 1]] @ mv[dd]
            ) % P
        return S

    def Ti_mat(i, mv):
        Mti = np.zeros((ORDER, ORDER), dtype=np.int64)
        for bi in range(ORDER):
            if Bdeg[bi] <= 1:
                Mti[int(low_target[i, bi]), bi] = 1
        for qi, bi in enumerate(quad_indices):
            row = T_quad[i, qi]
            for bj in range(ORDER):
                dd = 3 - Bdeg[bj]
                Mti[bj, bi] = int(np.dot(row[off3[bj] : off3[bj + 1]], mv[dd])) % P
        return Mti

    rng = np.random.default_rng(SEED_PM)
    n_trials = 25
    all_full = True
    all_stable = True
    all_comm = True
    for _ in range(n_trials):
        q0 = rng.integers(0, P, size=Q_DIM)
        mv = monvals(q0)
        Smat = eval_seeds(mv)
        rk = int(C.rank_mod(Smat, P))
        if rk != 28:
            all_full = False
        Ts = [Ti_mat(i, mv) for i in range(K_DIM)]
        for i in range(K_DIM):
            extras = (Smat @ Ts[i].T) % P
            if int(C.rank_mod(np.vstack([Smat, extras]), P)) > rk:
                all_stable = False
        # sample commutator columns
        for i in range(K_DIM):
            for j in range(i + 1, K_DIM):
                Comm = (Ts[i] @ Ts[j] - Ts[j] @ Ts[i]) % P
                if np.any(Comm % P != 0):
                    Cmat = Comm.T
                    nz = np.any(Cmat % P != 0, axis=1)
                    if nz.any():
                        if int(C.rank_mod(np.vstack([Smat, Cmat[nz]]), P)) > rk:
                            all_comm = False
    ok("specialized_rank_28", all_full, f"trials={n_trials}")
    ok("specialized_T_stable", all_stable, f"trials={n_trials}")
    ok("specialized_comm_in_span", all_comm, f"trials={n_trials}")

    # Exit consistency
    ok("exit_marker", exit_j.get("exit") == "P25Z-FINITE-PRESENTATION",
       str(exit_j.get("exit")))
    ok("presentation_shape", exit_j.get("presentation_shape") == [690, 28],
       str(exit_j.get("presentation_shape")))
    ok("closure_stabilized", ledger.get("stabilized") is True,
       f"round={ledger.get('stabilized_round')}")
    ok("headline_still_open", exit_j.get("headline") == "OPEN", "")

    # Sample product reduction: reduce k_0^3 via sealed rule and check monic
    k000 = (3, 0, 0, 0, 0, 0)
    # find in sealed
    found = False
    for i, ke in enumerate(sealed_k):
        if ke == k000:
            # leading monom rewrite: k0^3 ≡ -tail
            found = True
            ok("sample_rule_k0^3_present", True, f"tail_nnz={int(np.count_nonzero(sealed_tail[i]))}")
            break
    if not found:
        ok("sample_rule_k0^3_present", False, "missing")

    # Independent product check: T_0(k_0^2) should equal -tail(k_0^3)
    # k_0^2 is basis index
    b_k0sq = Bindex[(2, 0, 0, 0, 0, 0)]
    qi = quad_indices.index(b_k0sq)
    # T_0 column for this basis = T_quad[0,qi]
    rid = None
    for i, ke in enumerate(sealed_k):
        if ke == (3, 0, 0, 0, 0, 0):
            rid = i
            break
    if rid is not None:
        expect = (-sealed_tail[rid]) % P
        got = T_quad[0, qi] % P
        ok("T0(k0^2)_equals_-tail(k0^3)", np.array_equal(got, expect), "")

    elapsed = time.time() - t0
    result = {
        "verifier": "verify_presentation.py",
        "imports_producer": False,
        "n_checks": len(checks),
        "n_pass": sum(1 for c in checks if c["pass"]),
        "n_fail": len(failures),
        "failures": failures,
        "checks": checks,
        "elapsed_s": round(elapsed, 3),
        "rss_mib": C.rss_mib(),
        "verdict": "PASS" if not failures else "FAIL",
    }
    out = HERE / "verify_presentation_result.json"
    body = {k: v for k, v in result.items() if k != "self_sha256"}
    text = json.dumps(body, indent=2, sort_keys=True) + "\n"
    body["self_sha256"] = hashlib.sha256(text.encode()).hexdigest()
    out.write_text(json.dumps(body, indent=2, sort_keys=True) + "\n")
    print(json.dumps({k: result[k] for k in ("verdict", "n_pass", "n_fail", "failures")}, indent=2))
    return 0 if not failures else 1


if __name__ == "__main__":
    sys.exit(main())
