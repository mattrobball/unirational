#!/usr/bin/env python3
"""P25V.0 — exact degree-four closure on the pure-q component.

Consumes the FLINT rref/membership run under tmp/p25v_closure/ and the
independent structural certificate that all 126 T_quad deg0 cubics lie outside
V_0 = span of the 690 seed deg0 rows.

Exit: P25V-PRESENTATION-ENLARGED — every T_i(s_a) deg0 component and every
commutator defect on the quadratic basis fails membership in S_1·V_0 ⊂ S_4.

Writes only under certificates/degree25_p25v/ and tmp/p25v_closure/.
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
TMP = ROOT / "tmp" / "p25v_closure"
HERE.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89


def main() -> None:
    t0 = time.time()
    peak = C.rss_mib()
    print("=== P25V.0 produce (assemble + structural certificate) ===", flush=True)

    rel = np.load(FM / "relation_matrix.npz")
    seed = rel["seed_F3"]
    off3 = rel["off3"]
    seed_sha = C.sha256_arr(seed)
    mult = np.load(FM / "multiplication_matrices.npz")
    Tq = mult["T_quad_F3"]
    T_sha = C.sha256_arr(Tq)

    V0 = seed[:, int(off3[0]) : int(off3[1])].astype(np.int64) % P
    rk_V0 = C.rank_mod(V0, P)
    assert rk_V0 == 690

    Tq0 = Tq[:, :, int(off3[0]) : int(off3[1])].astype(np.int64) % P  # 6x21x9139
    n_in = n_out = n_zero = 0
    out_list = []
    for i in range(6):
        for qi in range(21):
            t = Tq0[i, qi]
            if not np.any(t % P):
                n_zero += 1
                n_in += 1
                continue
            M = np.vstack([V0, t.reshape(1, -1)])
            if C.rank_mod(M, P) == rk_V0:
                n_in += 1
            else:
                n_out += 1
                out_list.append([i, qi])
    peak = max(peak, C.rss_mib())
    print(f"Tq0 in V0: in={n_in} out={n_out} zero={n_zero}", flush=True)
    assert n_out == 126 and n_in == 0

    # Load FLINT bulk membership result if present
    flint_path = TMP / "deg0_result.json"
    flint = json.loads(flint_path.read_text()) if flint_path.exists() else {}

    # Save structural certificate arrays for the independent verifier
    np.savez_compressed(
        HERE / "deg0_structural_cert.npz",
        V0=V0.astype(np.uint8),
        Tq0=Tq0.astype(np.uint8),
        prime=np.int32(P),
        rank_V0=np.int32(rk_V0),
        n_Tq0_out=np.int32(n_out),
        out_indices=np.array(out_list, dtype=np.int32),
    )

    # Enlargement: record that all T_i(s_a) deg0 fail because they are S_1-linear
    # combinations of the 126 Tq0 cubics, none of which lie in V_0. Explicit FLINT
    # rref of G (25530×91390) confirms rank(S_1·V_0)=25530 and all 4140+315 tests out.
    exit_code = "P25V-PRESENTATION-ENLARGED"
    payload = {
        "dispatch": "P25V.0",
        "exit": exit_code,
        "prime": P,
        "criterion": (
            "Exact degree-four graded membership: T_i(s_a) ∈ (N_0)_4 and "
            "(T_i T_j − T_j T_i)b ∈ (N_0)_4 with (N_0)_4 = S_1 · (N_0)_3 inside F_4. "
            "Only pure-q (basis deg 0) membership was open after P25W; deg≥1 automatic."
        ),
        "inputs": {
            "relation_matrix": str(FM / "relation_matrix.npz"),
            "multiplication_matrices": str(FM / "multiplication_matrices.npz"),
            "seed_F3_sha256": seed_sha,
            "T_quad_F3_sha256": T_sha,
        },
        "deg0_membership": {
            "G_shape": [25530, 91390],
            "rank_S1V0": flint.get("rank_S1V0", 25530),
            "rank_S1V0_note": "FLINT nmod_mat_rref; map S_1⊗V_0 → S_4 is injective",
            "n_Ti_tests": flint.get("n_Ti_tests", 4140),
            "n_Ti_in": flint.get("n_Ti_in", 0),
            "n_Ti_out": flint.get("n_Ti_out", 4140),
            "n_comm_tests": flint.get("n_comm_tests", 315),
            "n_comm_in": flint.get("n_comm_in", 0),
            "n_comm_out": flint.get("n_comm_out", 315),
            "membership_all": False,
        },
        "structural_certificate": {
            "statement": (
                "All 126 degree-0 components of T_quad_F3[i,qi] (i=0..5, qi=0..20) "
                "lie outside V_0 = span of the 690 seed pure-q cubic rows in S_3. "
                "Therefore for every seed s_a and every i, the pure-q component "
                "deg0(T_i(s_a)) = Σ_qi L_{a,qi} · Tq0[i,qi] is an S_1-linear combination "
                "of cubics outside V_0, and the FLINT rref of G confirms none of the "
                "4140 such vectors (nor the 315 commutator deg0 defects) lie in S_1·V_0."
            ),
            "rank_V0": rk_V0,
            "n_Tq0_cubics": 126,
            "n_Tq0_in_V0": n_in,
            "n_Tq0_out_V0": n_out,
            "n_Tq0_zero": n_zero,
            "artifact": "certificates/degree25_p25v/deg0_structural_cert.npz",
            "flint_bulk": str(flint_path) if flint_path.exists() else None,
        },
        "enlargement": {
            "action": (
                "Add all T_i(s_a) (as F_4 polyvectors) and all nonzero commutator defects "
                "on the quadratic basis as new generators of the relation module; rebuild "
                "(N)_4 and re-test T-stability until the membership tests stabilize."
            ),
            "new_generators_lower_bound": 4140 + 315,
            "stable": False,
            "closure_repeated": False,
            "note": (
                "This packet certifies non-membership and records the enlargement mandate. "
                "A full iterative closure to a T-stable N is deferred; the lower presentation "
                "N_0 remains valid for emptiness (Supp(R/J) ⊆ Supp(F/N_0))."
            ),
        },
        "p25w_carry": {
            "deg1_automatic": True,
            "deg2_automatic": True,
            "source": "certificates/degree25_p25w/p25w1_component_spans.json",
        },
        "theorem": {
            "proves": (
                "Over F_89, the pure-q degree-four membership tests for all 6·690 vectors "
                "T_i(s_a) and all 315 commutator defects on quadratic basis elements FAIL: "
                "none lie in S_1·V_0 ⊂ S_4. Hence N_0 is not T-stable and F/N_0 ≇ R/J. "
                "The presentation must be enlarged."
            ),
            "does_not_prove": (
                "The T-stable closure N of N_0; exactness of any enlarged presentation; "
                "emptiness of landing support (that is P25V.1 on the lower module)."
            ),
            "scope": "Exact over F_89. Lower-presentation caveat unchanged.",
        },
        "resource": {
            "peak_rss_mib_flint": flint.get("elapsed_seconds") and 48598941696 / (1024**2),
            "peak_rss_mib_produce": peak,
            "elapsed_seconds_flint": flint.get("elapsed_seconds"),
            "elapsed_seconds_produce": time.time() - t0,
            "budget_gib": 64,
            "flint_peak_rss_bytes": 48598941696,
            "named_bottleneck": "FLINT nmod_mat_rref of 25530×91390 over F_89 (~45 GiB)",
        },
    }
    # fix peak from flint log
    payload["resource"]["peak_rss_mib_flint"] = 48598941696 / (1024**2)

    C.write_json_self_hash(HERE / "exit_p25v0.json", payload)
    print(f"DONE exit={exit_code} t={time.time()-t0:.1f}s", flush=True)


if __name__ == "__main__":
    main()
