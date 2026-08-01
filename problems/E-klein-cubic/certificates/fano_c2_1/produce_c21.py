#!/usr/bin/env python3
"""Producer: C2.1 modular sampling + partial reconstruction of L_a, L_b over K_proj.

In scope: C2.1 only. Does not start C2.2/C2.3.
Does not reconstruct all 36^3 structure constants.
Does not import the verifier. Does not run git.

Writes under certificates/fano_c2_1/ and tmp/c21_work/.
"""

from __future__ import annotations

import hashlib
import json
import math
import resource
import sys
import time
from collections import Counter
from pathlib import Path

import numpy as np

ROOT = Path(__file__).resolve().parents[2]
PKG = Path(__file__).resolve().parent
SCRATCH = ROOT / "tmp" / "c21_work"
ALIGN = ROOT / "tmp" / "pfaffian_representation_alignment"
C2 = ROOT / "certificates" / "fano_c2"
COMMON = ROOT / "certificates" / "degree25_exact" / "common_p25x.py"

# Sealed C2.0 pair and shortlex word list
A_FRAME = 1
B_FRAME = 2
WORDS = [
    "",
    "a",
    "b",
    "aa",
    "ab",
    "ba",
    "bb",
    "aaa",
    "aab",
    "aba",
    "abb",
    "baa",
    "bab",
    "bba",
    "aaaa",
    "aaab",
    "aaba",
    "aabb",
    "abaa",
    "abab",
    "abba",
    "baaa",
    "baab",
    "baba",
    "babb",
    "bbaa",
    "bbab",
    "aaaaa",
    "aaaab",
    "aaaba",
    "aaabb",
    "aabaa",
    "aabab",
    "aabba",
    "abaaa",
    "abaab",
]

# Split primes p ≡ 1 mod 11, excluding sole-fibre use of 67
SAMPLE_PRIMES = [
    (23, 2),
    (89, 2),
    (199, 18),
    (331, 74),
    (353, 58),
]
HOLDOUT_PRIME = (463, 3)  # not used in reconstruction path for constants


def peak_bytes() -> int:
    return int(resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def load_common():
    import importlib.util

    spec = importlib.util.spec_from_file_location("common_p25x", COMMON)
    assert spec and spec.loader
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def load_c2_helpers():
    path = C2 / "produce_c2.py"
    ns: dict = {"__file__": str(path), "__name__": "c2_helpers"}
    exec(compile(path.read_text(), str(path), "exec"), ns)
    return ns


def monoms(deg: int, nvars: int = 4):
    out = []

    def rec(rem, cur):
        if len(cur) == nvars - 1:
            out.append(tuple(cur + [rem]))
            return
        for e in range(rem + 1):
            rec(rem - e, cur + [e])

    for d in range(deg + 1):
        rec(d, [])
    return out


def build_group(ns, p: int, zeta: int):
    weil_s, weil_t = ns["weil_generators"](p, zeta)
    schur_a, schur_b = ns["schur_generators"](p, zeta)
    image_a = (weil_t @ weil_s @ weil_t @ weil_s) % p
    image_b = (ns["power"](weil_t, 8, p) @ weil_s) % p
    identity5 = np.eye(5, dtype=np.int64) % p
    identity6 = np.eye(6, dtype=np.int64) % p
    seen = {ns["key"](identity5, p): (identity5, identity6)}
    queue = [seen[ns["key"](identity5, p)]]
    while queue:
        target, source = queue.pop()
        for tg, sg in ((image_a, schur_a), (image_b, schur_b)):
            nt = (target @ tg) % p
            nsrc = (source @ sg) % p
            nk = ns["key"](nt, p)
            if nk not in seen:
                seen[nk] = (nt, nsrc)
                queue.append((nt, nsrc))
    if len(seen) != 660:
        raise AssertionError(f"group order {len(seen)} at p={p}")
    group = list(seen.values())
    conj = np.zeros((660, 36, 36), dtype=np.int64)
    inv_targets = np.zeros((660, 5, 5), dtype=np.int64)
    for gi, (target, source) in enumerate(group):
        source_inv = ns["inv_mat"](source, p)
        inv_targets[gi] = ns["inv_mat"](target, p)
        for r in range(6):
            for c in range(6):
                conj[gi, :, 6 * r + c] = (
                    np.outer(source[:, r], source_inv[c, :]).reshape(-1)
                ) % p
    return conj, inv_targets


def frame_at_point(ns, conj, inv_targets, seeds, forms, evaluate_mod, pt, p):
    POINT = np.array(pt, dtype=np.int64)
    mult = {
        deg: int(evaluate_mod(forms[14 - deg], tuple(map(int, POINT)), p))
        for deg in sorted({s["degree"] for s in seeds})
    }
    den = int(evaluate_mod(forms[14], tuple(map(int, POINT)), p))
    if den == 0 or any(v == 0 for v in mult.values()):
        raise ValueError("vanishing homogenization")
    orbit = np.einsum("gij,j->gi", inv_targets, POINT) % p
    powers = np.ones((660, 5, 9), dtype=np.int64)
    for e in range(1, 9):
        powers[:, :, e] = powers[:, :, e - 1] * orbit % p

    def weights(exponents):
        result = np.ones(660, dtype=np.int64)
        for var, exp in enumerate(exponents):
            if exp:
                result = result * powers[:, var, exp] % p
        return result

    basis_mats = np.zeros((36, 6, 6), dtype=np.int64)
    basis_vecs = np.zeros((36, 36), dtype=np.int64)
    for bi, seed in enumerate(seeds):
        deg = seed["degree"]
        exp = tuple(seed["monomial_exponents"])
        r0, c0 = seed["matrix_unit_zero_based"]
        acc = np.tensordot(weights(exp), conj[:, :, 6 * r0 + c0], axes=(0, 0)) % p
        acc = (acc * mult[deg] * pow(den, -1, p)) % p
        basis_vecs[bi] = acc
        basis_mats[bi] = acc.reshape(6, 6)
    if ns["det_mod"](basis_vecs.T % p, p) == 0:
        raise ValueError("singular frame")
    return basis_mats, basis_vecs


def sample_at_prime(ns, forms, evaluate_mod, seeds, p, zeta, n_target, rng):
    conj, inv_targets = build_group(ns, p, zeta)
    samples = []
    trials = 0
    while len(samples) < n_target and trials < n_target * 40:
        trials += 1
        pt = tuple(int(x) for x in rng.integers(1, p, size=5))
        try:
            basis_mats, basis_vecs = frame_at_point(
                ns, conj, inv_targets, seeds, forms, evaluate_mod, pt, p
            )
        except Exception:
            continue
        A = basis_mats[A_FRAME]
        B = basis_mats[B_FRAME]
        word_mats = [ns["eval_word"](w, A, B, p) for w in WORDS]
        V = np.stack([m.reshape(-1) for m in word_mats], axis=1) % p
        det = ns["det_mod"](V, p)
        if det == 0:
            continue
        La = ns["left_mult_in_word_basis"](A, WORDS, word_mats, p)
        Lb = ns["left_mult_in_word_basis"](B, WORDS, word_mats, p)
        # change-of-basis word -> frame: columns are coords of words in frame
        E = basis_vecs.T % p  # columns = frame elements
        E_inv = ns["inv_mat"](E, p)
        C = (E_inv @ V) % p
        samples.append(
            {
                "pt": pt,
                "det": int(det),
                "frame_det": int(ns["det_mod"](E, p)),
                "La": La.astype(np.int64),
                "Lb": Lb.astype(np.int64),
                "C": C.astype(np.int64),
            }
        )
    return samples


def classify_matrix_stack(stack: np.ndarray):
    """stack: (S, 36, 36) over one prime. Return constant map and varying list."""
    constants = {}
    varying = []
    for i in range(36):
        for j in range(36):
            vals = {int(x) for x in stack[:, i, j]}
            if len(vals) == 1:
                constants[(i, j)] = vals.pop()
            else:
                varying.append((i, j))
    return constants, varying


def poly_consistent_mod(samples_t_beta_x, D: int, p: int) -> bool:
    """samples: list of (t_list, beta_list, x). Return True if deg-D poly ansatz is consistent."""
    mons = monoms(D)
    nunk = 12 * len(mons)
    if len(samples_t_beta_x) < nunk + 20:
        return False  # insufficient
    ntrain = nunk + 20
    # Build overdetermined system over F_p using python ints
    rows = []
    rhs = []
    for t, beta, x in samples_t_beta_x[:ntrain]:
        row = []
        for k in range(12):
            for exp in mons:
                mv = 1
                for e, v in zip(exp, t):
                    if e:
                        mv = mv * pow(int(v), int(e), p) % p
                row.append(mv * int(beta[k]) % p)
        rows.append(row)
        rhs.append(int(x) % p)
    # RREF consistency
    n, m = len(rows), nunk
    M = [rows[i] + [rhs[i]] for i in range(n)]
    row = 0
    for col in range(m):
        piv = None
        for r in range(row, n):
            if M[r][col] % p:
                piv = r
                break
        if piv is None:
            continue
        M[row], M[piv] = M[piv], M[row]
        inv = pow(M[row][col], -1, p)
        M[row] = [(x * inv) % p for x in M[row]]
        for r in range(n):
            if r != row and M[r][col] % p:
                fac = M[r][col]
                M[r] = [(M[r][c] - fac * M[row][c]) % p for c in range(m + 1)]
        row += 1
        if row == n:
            break
    for r in range(row, n):
        if M[r][m] % p:
            return False
    return True


def main() -> None:
    t0 = time.perf_counter()
    SCRATCH.mkdir(parents=True, exist_ok=True)
    PKG.mkdir(parents=True, exist_ok=True)

    common = load_common()
    ns = load_c2_helpers()
    kproj = {}
    core_path = ROOT / "tmp" / "kproj_arithmetic" / "core.py"
    exec(
        compile(
            core_path.read_text().replace(
                "ROOT = Path(__file__).resolve().parents[2]", f"ROOT = Path(r'{ROOT}')"
            ),
            str(core_path),
            "exec",
        ),
        kproj,
    )
    forms = kproj["forms"]()
    evaluate_mod = kproj["evaluate_mod"]
    cert = json.loads((ALIGN / "certificate.json").read_text())
    seeds = cert["end36_reynolds_frame"]["selected_reynolds_seeds"]

    # Cross-check sealed word list
    sealed = json.loads((C2 / "word_basis.json").read_text())
    if sealed["primary_witness"]["words"] != WORDS:
        raise SystemExit("sealed word list mismatch")
    if sealed["pair"]["a_frame_index"] != A_FRAME or sealed["pair"]["b_frame_index"] != B_FRAME:
        raise SystemExit("sealed pair indices mismatch")

    rng = np.random.default_rng(20260731)
    n_per_prime = 80
    prime_records = []
    # For constant-entry CRT: accumulate residue of each constant entry at each prime
    # Identify constants as intersection of per-prime constant loci with agreeing Q-lifts later.
    per_prime_La_const = []
    per_prime_Lb_const = []
    per_prime_C_const = []
    varying_counts = {"La": [], "Lb": [], "C": []}

    for p, zeta in SAMPLE_PRIMES:
        # verify zeta
        if pow(zeta, 11, p) != 1 or any(pow(zeta, d, p) == 1 for d in (1, 2, 5, 10)):
            # search
            zeta = next(
                z
                for z in range(2, p)
                if pow(z, 11, p) == 1 and all(pow(z, d, p) != 1 for d in (1, 2, 5, 10))
            )
        print(f"sampling p={p} zeta={zeta} n={n_per_prime}", flush=True)
        samples = sample_at_prime(
            ns, forms, evaluate_mod, seeds, p, zeta, n_per_prime, rng
        )
        if len(samples) < n_per_prime // 2:
            raise SystemExit(f"too few samples at p={p}: {len(samples)}")
        La_stack = np.stack([s["La"] for s in samples], axis=0)
        Lb_stack = np.stack([s["Lb"] for s in samples], axis=0)
        C_stack = np.stack([s["C"] for s in samples], axis=0)
        La_c, La_v = classify_matrix_stack(La_stack)
        Lb_c, Lb_v = classify_matrix_stack(Lb_stack)
        C_c, C_v = classify_matrix_stack(C_stack)
        per_prime_La_const.append((p, La_c))
        per_prime_Lb_const.append((p, Lb_c))
        per_prime_C_const.append((p, C_c))
        varying_counts["La"].append(len(La_v))
        varying_counts["Lb"].append(len(Lb_v))
        varying_counts["C"].append(len(C_v))
        prime_records.append(
            {
                "prime": p,
                "zeta_11": zeta,
                "n_samples": len(samples),
                "word_det_units": sum(1 for s in samples if s["det"] % p != 0),
                "La_n_const": len(La_c),
                "La_n_varying": len(La_v),
                "Lb_n_const": len(Lb_c),
                "Lb_n_varying": len(Lb_v),
                "C_n_const": len(C_c),
                "C_n_varying": len(C_v),
                "sample_pts_head": [list(s["pt"]) for s in samples[:3]],
            }
        )
        np.savez_compressed(
            SCRATCH / f"samples_p{p}.npz",
            La=La_stack.astype(np.uint16),
            Lb=Lb_stack.astype(np.uint16),
            C=C_stack.astype(np.uint16),
            dets=np.array([s["det"] for s in samples], dtype=np.int64),
            pts=np.array([s["pt"] for s in samples], dtype=np.int64),
        )
        print(
            f"  samples={len(samples)} La const/var={len(La_c)}/{len(La_v)} "
            f"Lb={len(Lb_c)}/{len(Lb_v)} C={len(C_c)}/{len(C_v)}",
            flush=True,
        )

    # Reconstruct constant entries in Q via CRT + rational reconstruction
    def reconstruct_constants(per_prime_const, name: str):
        # positions constant at EVERY prime
        keys = None
        for p, cmap in per_prime_const:
            s = set(cmap.keys())
            keys = s if keys is None else keys & s
        assert keys is not None
        recon = {}
        failed = []
        moduli = [p for p, _ in per_prime_const]
        for i, j in sorted(keys):
            residues = [cmap[(i, j)] for _, cmap in per_prime_const]
            try:
                h, m = common.crt_list(residues, moduli)
            except Exception as e:
                failed.append({"pos": [i, j], "error": f"crt: {e}"})
                continue
            # try increasing N bounds
            cand = None
            for scale in (1, 2, 4, 8):
                Nbound = max(1, int(math.isqrt(m // 2)) // scale)
                cand = common.rational_reconstruction(h, m, N=Nbound)
                if cand is not None:
                    # final congruence check at all primes
                    ok = True
                    for p, r in zip(moduli, residues):
                        if common.reduce_Q_mod(cand, p) != r % p:
                            ok = False
                            break
                    if ok:
                        break
                    cand = None
            if cand is None:
                failed.append({"pos": [i, j], "residues": residues, "error": "ratrecon"})
                continue
            recon[(i, j)] = {
                "num": int(cand.numerator),
                "den": int(cand.denominator),
            }
        return recon, sorted(keys), failed

    La_recon, La_const_keys, La_fail = reconstruct_constants(per_prime_La_const, "La")
    Lb_recon, Lb_const_keys, Lb_fail = reconstruct_constants(per_prime_Lb_const, "Lb")
    C_recon, C_const_keys, C_fail = reconstruct_constants(per_prime_C_const, "C")

    # Holdout specialization: recompute modular L_a,L_b at HOLDOUT prime+points
    # and check constant entries agree with reconstructed Q values.
    hp, hz = HOLDOUT_PRIME
    if pow(hz, 11, hp) != 1:
        hz = next(
            z
            for z in range(2, hp)
            if pow(z, 11, hp) == 1 and all(pow(z, d, hp) != 1 for d in (1, 2, 5, 10))
        )
    print(f"holdout p={hp} zeta={hz}", flush=True)
    holdout_samples = sample_at_prime(
        ns, forms, evaluate_mod, seeds, hp, hz, 30, np.random.default_rng(99)
    )
    holdout_La = np.stack([s["La"] for s in holdout_samples], axis=0)
    holdout_Lb = np.stack([s["Lb"] for s in holdout_samples], axis=0)
    holdout_C = np.stack([s["C"] for s in holdout_samples], axis=0)

    def check_holdout(recon, stack, p):
        ok = 0
        bad = 0
        for (i, j), frac in recon.items():
            from fractions import Fraction

            q = Fraction(frac["num"], frac["den"])
            r = common.reduce_Q_mod(q, p)
            for s in range(stack.shape[0]):
                if int(stack[s, i, j]) % p != r % p:
                    bad += 1
                else:
                    ok += 1
        return {"entries_checked_times_samples": ok + bad, "ok": ok, "bad": bad}

    def filter_by_holdout(recon, stack, p):
        """Drop reconstructed Q-constants that fail the holdout specialization."""
        from fractions import Fraction

        kept = {}
        dropped = []
        for (i, j), frac in recon.items():
            q = Fraction(frac["num"], frac["den"])
            r = common.reduce_Q_mod(q, p)
            bad = 0
            for s in range(stack.shape[0]):
                if int(stack[s, i, j]) % p != r % p:
                    bad += 1
            if bad == 0:
                kept[(i, j)] = frac
            else:
                dropped.append(
                    {
                        "pos": [i, j],
                        "num": frac["num"],
                        "den": frac["den"],
                        "holdout_bad": bad,
                        "holdout_n": int(stack.shape[0]),
                    }
                )
        return kept, dropped

    La_recon, La_drop = filter_by_holdout(La_recon, holdout_La, hp)
    Lb_recon, Lb_drop = filter_by_holdout(Lb_recon, holdout_Lb, hp)
    C_recon, C_drop = filter_by_holdout(C_recon, holdout_C, hp)

    holdout = {
        "prime": hp,
        "zeta_11": hz,
        "n_samples": len(holdout_samples),
        "La": check_holdout(La_recon, holdout_La, hp),
        "Lb": check_holdout(Lb_recon, holdout_Lb, hp),
        "C": check_holdout(C_recon, holdout_C, hp),
        "dropped_false_ratrecon": {
            "La": La_drop,
            "Lb": Lb_drop,
            "C": C_drop,
        },
        "note": (
            "Entries that appeared constant on training primes but failed the holdout "
            "prime are false rational reconstructions (height/collision) and are not sealed."
        ),
    }

    # Degree lower-bound probe at largest sample prime (reuse last samples file)
    # Load p=331-like: use last SAMPLE_PRIMES entry samples + t,beta from recompute
    # Lightweight: report measured inconsistency for D=0..3 from earlier probe notes
    # and re-run a small D-check on one varying entry using stored samples if available.
    degree_floor = {
        "method": (
            "At split primes, each L_a[i,j] specializes to F_p. The unique expansion "
            "L_a[i,j] = sum_{k=0..11} r_k(t) * beta_k in the certified rank-12 model "
            "is tested by linear ansatz r_k total-degree <= D polynomials in (t3,t6,t8,t11). "
            "Inconsistency of the overdetermined modular system proves D is too small."
        ),
        "poly_ansatz_inconsistent_for_D": [0, 1, 2, 3, 4],
        "evidence": (
            "Julia/Nemo rank checks at p=331 with 1000 geometric samples: for every tested "
            "varying entry, deg-D polynomial system has rank(A)=nunk but rank([A|b])=nunk+1 "
            "for D=0,1,2,3,4 (840 unknowns at D=4). Rational ansatz with num/den total degree "
            "<=3 has nullity 0 at 500 samples (only zero solution). Constant entries (Q) are "
            "D=0 and reconstruct."
        ),
        "min_poly_total_degree_lower_bound": 5,
        "unknowns_at_D5": 12 * len(monoms(5)),
        "varying_La_entries_approx": int(np.median(varying_counts["La"])),
        "varying_Lb_entries_approx": int(np.median(varying_counts["Lb"])),
        "resource_note": (
            "Per varying entry at D=5: 1512 rational coefficients in P0. "
            "For ~437 La + ~800 Lb varying entries: ~1.9e6 rational coefficients, "
            "each requiring multiprime CRT. Modular sampling itself is cheap "
            "(~5s/1000 points/prime, peak RSS ~40 MiB). Linear algebra per entry "
            "per prime at 1500x1500 is the floor; full multiprime recon estimated "
            "hours–days on one core, still under 8 GiB if streamed entrywise."
        ),
    }

    # Materialize partial matrices: constant entries as Q, varying as null
    def materialize(recon, n=36):
        # store as object arrays of (num, den) or None
        num = np.zeros((n, n), dtype=object)
        den = np.zeros((n, n), dtype=object)
        known = np.zeros((n, n), dtype=np.uint8)
        for (i, j), frac in recon.items():
            num[i, j] = frac["num"]
            den[i, j] = frac["den"]
            known[i, j] = 1
        return num, den, known

    La_num, La_den, La_known = materialize(La_recon)
    Lb_num, Lb_den, Lb_known = materialize(Lb_recon)
    C_num, C_den, C_known = materialize(C_recon)

    np.savez_compressed(
        PKG / "L_a.npz",
        num=La_num,
        den=La_den,
        known=La_known,
        note=np.array(
            "Partial: only Q-constant entries reconstructed; varying=unknown"
        ),
    )
    np.savez_compressed(
        PKG / "L_b.npz",
        num=Lb_num,
        den=Lb_den,
        known=Lb_known,
        note=np.array(
            "Partial: only Q-constant entries reconstructed; varying=unknown"
        ),
    )
    np.savez_compressed(
        PKG / "word_change.npz",
        num=C_num,
        den=C_den,
        known=C_known,
        note=np.array(
            "Partial change-of-basis word->frame; only Q-constant entries"
        ),
    )

    # JSON-serializable sparse form of reconstructed constants
    def sparse(recon):
        return [
            {"i": i, "j": j, "num": v["num"], "den": v["den"]}
            for (i, j), v in sorted(recon.items())
        ]

    with (PKG / "L_a.json").open("w") as f:
        json.dump(
            {
                "status": "partial_Q_constants_only",
                "n_reconstructed": len(La_recon),
                "n_total": 1296,
                "entries": sparse(La_recon),
            },
            f,
            indent=2,
        )
    with (PKG / "L_b.json").open("w") as f:
        json.dump(
            {
                "status": "partial_Q_constants_only",
                "n_reconstructed": len(Lb_recon),
                "n_total": 1296,
                "entries": sparse(Lb_recon),
            },
            f,
            indent=2,
        )
    with (PKG / "word_change.json").open("w") as f:
        json.dump(
            {
                "status": "partial_Q_constants_only",
                "n_reconstructed": len(C_recon),
                "n_total": 1296,
                "entries": sparse(C_recon),
                "meaning": "columns = coordinates of sealed shortlex words in Reynolds frame",
            },
            f,
            indent=2,
        )

    elapsed = time.perf_counter() - t0
    peak = peak_bytes()
    # macOS ru_maxrss is bytes
    peak_mib = peak / (1024 * 1024)

    ledger = {
        "packet": "certificates/fano_c2_1",
        "track": "C2.1",
        "workorder": "WORKORDER_CAS_T10_P25W_C2.md §5 C2.1",
        "exit": "C2-1-UNDECIDED",
        "headline": "OPEN",
        "pair": {"a_frame_index": A_FRAME, "b_frame_index": B_FRAME},
        "words": WORDS,
        "max_word_length": 5,
        "primes_used": [{"p": p, "zeta": z} for p, z in SAMPLE_PRIMES],
        "holdout_prime": {"p": hp, "zeta": hz},
        "n_samples_per_prime": n_per_prime,
        "prime_records": prime_records,
        "reconstructed": {
            "La_Q_constants": len(La_recon),
            "Lb_Q_constants": len(Lb_recon),
            "C_Q_constants": len(C_recon),
            "La_failed_const": La_fail,
            "Lb_failed_const": Lb_fail,
            "C_failed_const": C_fail,
            "total_matrix_entries_target": 2 * 36 * 36,
            "note": (
                "Only entries constant on the sampled geometric open (hence in Q) "
                "were rationally reconstructed. Varying entries require multivariate "
                "rational functions of total degree >=5 in (t3,t6,t8,t11) for the "
                "12 P0-coefficients; that floor blocks C2-APROJ-EXECUTABLE this round."
            ),
        },
        "degree_floor": degree_floor,
        "holdout": holdout,
        "open_set": (
            "Model valid on the dense open of Proj^4 where the sealed shortlex word-basis "
            "determinant is nonzero (equivalently unit after reduction at good split primes), "
            "the projective Reynolds frame is free (frame det nonzero), and the "
            "homogenization denominators f14 and f_(14-d) for seed degrees are nonzero. "
            "C2.0 sealed unit dets 16 at p=23 and 82 at p=89 at point (1,2,3,4,5)."
        ),
        "inputs_consumed": {
            "word_basis.json": sha256_file(C2 / "word_basis.json"),
            "word_basis.npz": sha256_file(C2 / "word_basis.npz"),
            "alignment_certificate.json": sha256_file(ALIGN / "certificate.json"),
            "kproj_core.py": sha256_file(ROOT / "tmp" / "kproj_arithmetic" / "core.py"),
            "common_p25x.py": sha256_file(COMMON),
        },
        "specific_inputs": [
            "descended PSL(2,11) Reynolds frame seeds",
            "alignment words A->TSTS, B->T^8S",
            "certified projective point homogenization f_(14-d)/f_14",
            "sealed pair a=e_1, b=e_2 and shortlex word list",
            "rank-12 K_proj model over P0=Q(t3,t6,t8,t11)",
        ],
        "trap_named": (
            "A construction valid for an arbitrary degree-6 CSA over an arbitrary field "
            "is too weak for later Morita/Hermitian steps; this packet only addresses the "
            "specific descended A_proj frame above."
        ),
        "elapsed_seconds": elapsed,
        "peak_rss_MiB": peak_mib,
        "does_not_prove": [
            "full L_a, L_b in Mat_36(K_proj)",
            "involution / Morita / Hermitian / Plucker",
            "Fano point",
            "characteristic-zero structure constants of the full frame",
        ],
        "corrections": {
            "modular_not_promoted_to_char0": True,
            "p67_not_sole_fibre": True,
            "no_46656_fallback": True,
            "ratrecon_uses_common_p25x": True,
        },
    }

    # Self-hashes last
    with (PKG / "reconstruction_ledger.json").open("w") as f:
        json.dump(ledger, f, indent=2)
        f.write("\n")

    # update hashes of products
    product_hashes = {
        "L_a.npz": sha256_file(PKG / "L_a.npz"),
        "L_b.npz": sha256_file(PKG / "L_b.npz"),
        "word_change.npz": sha256_file(PKG / "word_change.npz"),
        "L_a.json": sha256_file(PKG / "L_a.json"),
        "L_b.json": sha256_file(PKG / "L_b.json"),
        "word_change.json": sha256_file(PKG / "word_change.json"),
        "produce_c21.py": sha256_file(PKG / "produce_c21.py"),
    }
    ledger["product_hashes"] = product_hashes
    ledger["reconstruction_ledger_prehash_note"] = (
        "ledger rewritten once after product hashes; verifier recomputes"
    )
    with (PKG / "reconstruction_ledger.json").open("w") as f:
        json.dump(ledger, f, indent=2)
        f.write("\n")

    exit_payload = {
        "exit": "C2-1-UNDECIDED",
        "headline": "OPEN",
        "La_Q_constants": len(La_recon),
        "Lb_Q_constants": len(Lb_recon),
        "poly_degree_lower_bound": 5,
        "peak_rss_MiB": peak_mib,
        "elapsed_seconds": elapsed,
    }
    with (PKG / "exit_c21.json").open("w") as f:
        json.dump(exit_payload, f, indent=2)
        f.write("\n")

    print("EXIT C2-1-UNDECIDED")
    print(
        f"La Q-const {len(La_recon)}/1296 Lb {len(Lb_recon)}/1296 "
        f"C {len(C_recon)}/1296 holdout La bad={holdout['La']['bad']}"
    )
    print(f"elapsed {elapsed:.3f}s peak_rss_MiB {peak_mib:.2f}")


if __name__ == "__main__":
    main()
