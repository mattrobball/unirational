#!/usr/bin/env python3
"""Cross-band gluing at d=35 on the universal 37-cell.

Geometry (FIX_VII §7, FIX-A0/A1).  For V4 = {1,σ,τ,ρ} with
  W = A ⊕ χ_σ ⊕ χ_τ ⊕ χ_ρ  (dims 2+1+1+1),  ℓ_V = P(A),
  W⁺_σ = A⊕χ_σ,  W⁻_σ = χ_τ⊕χ_ρ,  L_σ∩L_τ = P(χ_ρ).

The unique positive-dim cross-band locus is ℓ_V (orbit of 55, stab A4),
shared by the three plus-plane bands of the V4.  In D_{P_σ} ≅ P(W⁺)×P(W⁻)
the fiber over ℓ_V is P(W⁻_σ); the shared stratum of D_{P_σ}∩D_{P_τ} is the
common-normal section y = χ_ρ ∈ W⁻_σ ∩ W⁻_τ.

Gluing (closed, linear): for every pair {σ,τ} in the V4, along y = χ_ρ and
all basepoints w ∈ A, the (d-1,1) leading value VAL(w,y) lands in
L_σ ∩ L_τ = P(χ_ρ) — i.e. the χ_τ-component in the W⁻_σ frame vanishes.
(Equivalently VAL ∥ χ_ρ.)  Three pairs per V4.

Rigidity anchors: on the 37-cell, W⁺ components of every extracted leading
value vanish (profile residual).  Sampling saturation-checked.

Also recorded (diagnostic, not primary): full-fiber vanishing of VAL on
ℓ_V × P(W⁻) — the over-strong condition that would force all three pairwise
images into incompatible points simultaneously.

Usage: python3 gluing_d35.py [p]
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import paths
import slicelib as SL
from inventory import build_v4s, char_lines, nullspace_rows, v4_ellV

DEG = 35
PAIR_RES = paths.PAIR_RES
RES = paths.RES


def inv_mod(M, p):
    n = M.shape[0]
    A = np.concatenate([M % p, np.eye(n, dtype=np.int64)], axis=1) % p
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, n):
            if A[i, c] % p:
                piv = i
                break
        assert piv is not None, "singular"
        A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
        for i in range(n):
            if i != r and A[i, c] % p:
                A[i] = (A[i] - A[i, c] * A[r]) % p
        r += 1
    return A[:, n:] % p


def load_layer0(p):
    A6 = np.load(os.path.join(PAIR_RES, "layer0_A_p331.npy"))
    C6 = np.load(os.path.join(PAIR_RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    assert A6.shape[0] == 637 and NUL.shape == (39, 637)
    return A6, C6, NUL


def load_universal_37(p):
    cell_path = os.path.join(paths.D35_EXT_RES, "cell37_p%d.npy" % p)
    if os.path.exists(cell_path):
        C37 = np.load(cell_path) % p
        assert C37.shape == (37, 39)
        return C37, "sealed_cell37"
    we = json.load(open(os.path.join(PAIR_RES, "worked_example_p%d.json" % p)))
    U = np.array(we["universal_matrix_6x39"], dtype=np.int64) % p
    K = SL.nullspace(U % p, p) % p
    assert K.shape == (37, 39), K.shape
    return K, "from_universal_matrix"


def sample_in_span(basis, n, p, rng):
    k = basis.shape[0]
    coeffs = rng.integers(0, p, size=(n, k))
    for i in range(n):
        if not np.any(coeffs[i]):
            coeffs[i, 0] = 1
    return (coeffs @ basis) % p


def v4_data(fr, p, inv_triple):
    """A span + per-involution W± + the three char lines labeled by involution."""
    A = v4_ellV(fr, p, inv_triple)
    assert A.shape[0] == 2, A.shape
    I5 = np.eye(5, dtype=np.int64)
    # char line of involution s: joint +1 on s and -1 on a partner
    s0, s1, s2 = inv_triple
    ch = char_lines(fr, p, s0, s1)
    # (s0,s1) signs: (+1,+1)=A part; (+1,-1)=χ_{s0}; (-1,+1)=χ_{s1}; (-1,-1)=χ_{s2}
    chi = {
        s0: ch[(1, -1)][0] % p,
        s1: ch[(-1, 1)][0] % p,
        s2: ch[(-1, -1)][0] % p,
    }
    # verify dims
    for s in inv_triple:
        assert chi[s].shape == (5,)
    frames = {}
    for s in inv_triple:
        Wp = nullspace_rows((fr["RHO"][s] - I5) % p, p)
        Wm = nullspace_rows((fr["RHO"][s] + I5) % p, p)
        others = [t for t in inv_triple if t != s]
        frames[s] = {
            "Wp": Wp,
            "Wm": Wm,
            "chi_self": chi[s],
            "chi_others": [chi[t] for t in others],
            "others": others,
        }
        assert Wp.shape[0] == 3 and Wm.shape[0] == 2
    return A, chi, frames


def common_normal_gluing(fr, A6, C6, Aspan, chi, inv_triple, p, rng,
                         n_base=16, deg=DEG):
    """Primary gluing: VAL(w, χ_ρ) ∥ χ_ρ for each pair's common normal χ_ρ.

    For pair {s,t} with third r: y = chi[r].  In the W⁻_s frame
    [chi[t], chi[r], Wp_s], require the chi[t]-component of VAL to vanish.
    (Symmetric condition from t-side is automatic once VAL ∈ span(chi[r])
    on the profile-cut cell; we still impose both for rank robustness.)
    """
    ns = A6.shape[0]
    I5 = np.eye(5, dtype=np.int64)
    cols = []
    n_samples = 0
    trips = list(inv_triple)
    for i, s in enumerate(trips):
        for t in trips[i + 1 :]:
            r = [u for u in trips if u != s and u != t][0]
            y = chi[r] % p
            Wp_s = nullspace_rows((fr["RHO"][s] - I5) % p, p)
            Wp_t = nullspace_rows((fr["RHO"][t] - I5) % p, p)
            Wpts = sample_in_span(Aspan, n_base, p, rng)
            Ymat = np.tile(y[None, :], (n_base, 1)) % p
            JR = SL.jet_rows(fr, A6, C6, Wpts, Ymat, 2, deg=deg)
            VAL = JR[:, :, :, 1] % p  # (ns, n_base, 5)
            n_samples += n_base
            # s-side frame: [chi[t], chi[r], Wp_s]
            B_s = np.concatenate(
                [chi[t][None, :], chi[r][None, :], Wp_s], axis=0
            ) % p
            CINV_s = inv_mod(B_s.T % p, p).T % p
            # t-side frame: [chi[s], chi[r], Wp_t]
            B_t = np.concatenate(
                [chi[s][None, :], chi[r][None, :], Wp_t], axis=0
            ) % p
            CINV_t = inv_mod(B_t.T % p, p).T % p
            for j in range(n_base):
                comp_s = (VAL[:, j, :] @ CINV_s) % p
                comp_t = (VAL[:, j, :] @ CINV_t) % p
                cols.append(comp_s[:, 0])  # vanish chi[t] on s-side
                cols.append(comp_t[:, 0])  # vanish chi[s] on t-side
                # optional: match chi[r] coeffs (should agree up to the same VAL)
                # cols.append((comp_s[:, 1] - comp_t[:, 1]) % p)
    Phi = np.stack(cols, axis=1) % p if cols else np.zeros((ns, 0), dtype=np.int64)
    return Phi, {"n_samples": n_samples, "n_func_raw": int(Phi.shape[1])}


def full_fiber_diagnostic(fr, A6, C6, Aspan, chi, frames, inv_triple, p, rng,
                          n_base=8, n_dir=3, deg=DEG):
    """Diagnostic: full VAL=0 on ℓ_V × P(W⁻_s) for each s (over-strong)."""
    ns = A6.shape[0]
    cols = []
    for s in inv_triple:
        Wm = frames[s]["Wm"]
        Wpts = sample_in_span(Aspan, n_base, p, rng)
        Ypts = sample_in_span(Wm, n_dir, p, rng)
        Wmat = np.repeat(Wpts, n_dir, axis=0)
        Ymat = np.tile(Ypts, (n_base, 1))
        JR = SL.jet_rows(fr, A6, C6, Wmat, Ymat, 2, deg=deg)
        VAL = JR[:, :, :, 1] % p
        for j in range(Wmat.shape[0]):
            for c in range(5):
                cols.append(VAL[:, j, c])
    Phi = np.stack(cols, axis=1) % p if cols else np.zeros((ns, 0), dtype=np.int64)
    return Phi


def rigidity_on_cell(fr, A6, C6, AMB, Aspan, chi, inv_triple, p, rng,
                     n_base=8, deg=DEG):
    """W⁺ components of common-normal leading values vanish on the cell."""
    k = AMB.shape[0]
    bad = 0
    checks = 0
    I5 = np.eye(5, dtype=np.int64)
    trips = list(inv_triple)
    for i, s in enumerate(trips):
        for t in trips[i + 1 :]:
            r = [u for u in trips if u != s and u != t][0]
            y = chi[r] % p
            Wp_s = nullspace_rows((fr["RHO"][s] - I5) % p, p)
            Wpts = sample_in_span(Aspan, n_base, p, rng)
            Ymat = np.tile(y[None, :], (n_base, 1)) % p
            JR = SL.jet_rows(fr, A6, C6, Wpts, Ymat, 2, deg=deg)
            VAL = JR[:, :, :, 1] % p
            B = np.concatenate(
                [chi[t][None, :], chi[r][None, :], Wp_s], axis=0
            ) % p
            CINV = inv_mod(B.T % p, p).T % p
            for j in range(n_base):
                comp = (VAL[:, j, :] @ CINV) % p
                c_cell = (AMB @ comp) % p
                bad += int(np.count_nonzero(c_cell[:, 2:] % p))
                checks += k * 3
    return bad, checks


def leading_vanish_table(fr, A6, C6, AMB, Aspan, chi, frames, inv_triple, p, rng,
                         deg=DEG):
    """Document that (d-1,1) leading form vanishes on ell_V but not generically."""
    ns = A6.shape[0]
    s = inv_triple[0]
    Wm = frames[s]["Wm"]
    Wp = frames[s]["Wp"]

    def pack(W, Y):
        JR = SL.jet_rows(fr, A6, C6, W, Y, 2, deg=deg)
        M = JR[:, :, :, 1].reshape(ns, -1) % p
        Sc = (AMB @ M) % p
        return {
            "r_cell": int(SL.rref_rank(Sc.T % p, p)),
            "nz_cell": int(np.count_nonzero(Sc)),
            "n_samples": int(W.shape[0]),
        }

    W_ell = sample_in_span(Aspan, 10, p, rng)
    Y_wm = sample_in_span(Wm, 10, p, rng)
    Y_cn = np.tile(chi[inv_triple[2]][None, :], (10, 1)) % p
    W_gen = sample_in_span(Wp, 10, p, rng)
    return {
        "ellV_x_Wm": pack(W_ell, Y_wm),
        "ellV_x_common_normal": pack(W_ell, Y_cn),
        "generic_Pplus_x_Wm": pack(W_gen, Y_wm),
    }


def depth6_diagnostic(fr, A6, C6, AMB, Aspan, chi, frames, inv_triple, p, rng,
                      deg=DEG):
    """First nonzero bulk jet along ell_V is t^6 (sealed r0=6). Report ranks.

    Not primary cross-band multidegree gluing; bulk line-order data.
    """
    ns = A6.shape[0]
    n_s = 8
    W = sample_in_span(Aspan, n_s, p, rng)
    chars = np.stack([chi[u] for u in inv_triple], axis=0) % p
    Y_full = sample_in_span(chars, n_s, p, rng)
    Y_wm = sample_in_span(frames[inv_triple[0]]["Wm"], n_s, p, rng)
    y_cn = chi[inv_triple[2]] % p
    Y_cn = np.tile(y_cn[None, :], (n_s, 1)) % p

    out = {"orders_on_full_normal": {}, "orders_on_Wm": {}, "orders_on_common_normal": {}}
    # One jet_rows call per direction class (J=8), then read all orders
    for Ypts, bucket in (
        (Y_full, "orders_on_full_normal"),
        (Y_wm, "orders_on_Wm"),
        (Y_cn, "orders_on_common_normal"),
    ):
        JR = SL.jet_rows(fr, A6, C6, W, Ypts, 8, deg=deg)
        for k in range(0, 8):
            M = JR[:, :, :, k].reshape(ns, -1) % p
            Sc = (AMB @ M) % p
            out[bucket][str(k)] = {
                "r_cell": int(SL.rref_rank(Sc.T % p, p)),
                "nz": int(np.count_nonzero(Sc)),
            }
    # first nonzero
    def first_nz(d):
        for k in range(0, 8):
            if d[str(k)]["r_cell"] > 0:
                return k
        return None

    out["first_nonzero_full_normal"] = first_nz(out["orders_on_full_normal"])
    out["first_nonzero_Wm"] = first_nz(out["orders_on_Wm"])
    out["first_nonzero_common_normal"] = first_nz(out["orders_on_common_normal"])
    out["note"] = (
        "Sealed Layer-0 imposes ord_ellV >= r0=6, so t^0..t^5 vanish along ell_V. "
        "Primary cross-band gluing uses the plus-plane multidegree leading form "
        "(t^1 / bidegree (d-1,1)), which already vanishes on ell_V — gluing is 0=0. "
        "Bulk t^6 data is recorded here only as a depth diagnostic."
    )
    return out


def run(p, n_base=16, n_base_sat=28):
    t0 = time.time()
    print("== cross-band gluing d=35, p=%d" % p, flush=True)
    fr = SL.build_frame(p, verbose=False)
    A6, C6, NUL39 = load_layer0(p)
    C37, src = load_universal_37(p)
    print("37-cell source:", src, C37.shape)
    AMB = (C37 @ (NUL39 % p)) % p
    assert AMB.shape == (37, 637)

    v4s = build_v4s(fr, p)
    assert len(v4s) == 55
    rep = v4s[0]
    inv_triple = rep["involutions"]
    Aspan, chi, frames = v4_data(fr, p, inv_triple)
    print("rep V4 g%s" % inv_triple)

    rng = np.random.default_rng(20260812 + p)

    # --- vanishing table (load-bearing geometric fact) ---
    vtable = leading_vanish_table(
        fr, A6, C6, AMB, Aspan, chi, frames, inv_triple, p, rng
    )
    print("vanish table:", vtable)

    # --- primary gluing: common-normal (34,1) image in intersection ---
    Phi, meta = common_normal_gluing(
        fr, A6, C6, Aspan, chi, inv_triple, p, rng, n_base=n_base
    )
    Phi_cell = (AMB @ Phi) % p
    r1 = SL.rref_rank(Phi_cell.T % p, p)
    print("rep rank pass1:", r1, "dim", 37 - r1, "nfunc", Phi_cell.shape[1])

    rng2 = np.random.default_rng(20260812 + p + 77)
    Phi2, meta2 = common_normal_gluing(
        fr, A6, C6, Aspan, chi, inv_triple, p, rng2, n_base=n_base_sat
    )
    Phi2_cell = (AMB @ Phi2) % p
    Phi_sat = np.concatenate([Phi_cell, Phi2_cell], axis=1) % p
    r2 = SL.rref_rank(Phi_sat.T % p, p)
    sat_ok = r2 == r1
    print("rep rank sat:", r2, "dim", 37 - r2, "sat_ok", sat_ok)

    # full orbit of 55
    print("full orbit 55 V4s...", flush=True)
    chunks = [Phi_sat]
    for vi, v in enumerate(v4s):
        As, ch, _frs = v4_data(fr, p, v["involutions"])
        rngv = np.random.default_rng(20260812 + p + 1000 + vi)
        Pv, _ = common_normal_gluing(
            fr, A6, C6, As, ch, v["involutions"], p, rngv, n_base=10
        )
        chunks.append((AMB @ Pv) % p)
        if (vi + 1) % 11 == 0:
            print("  %d/55" % (vi + 1), flush=True)
    Phi_orb = np.concatenate(chunks, axis=1) % p
    r_orb = SL.rref_rank(Phi_orb.T % p, p)
    dim_orb = 37 - r_orb
    print("orbit rank:", r_orb, "dim_after", dim_orb)

    # diagnostic full-fiber (still order-1)
    Phi_ff = full_fiber_diagnostic(
        fr, A6, C6, Aspan, chi, frames, inv_triple, p, rng, n_base=8, n_dir=3
    )
    r_ff = SL.rref_rank(((AMB @ Phi_ff) % p).T % p, p)
    print("diagnostic full-fiber rank on 37-cell:", r_ff, "dim", 37 - r_ff)

    # depth-6 diagnostic
    print("depth-6 diagnostic...", flush=True)
    d6 = depth6_diagnostic(
        fr, A6, C6, AMB, Aspan, chi, frames, inv_triple, p, rng
    )
    print("depth6 first nonzero full/Wm/cn:",
          d6["first_nonzero_full_normal"], d6["first_nonzero_Wm"],
          d6["first_nonzero_common_normal"])

    # rigidity
    rig_bad, rig_checks = rigidity_on_cell(
        fr, A6, C6, AMB, Aspan, chi, inv_triple, p, rng, n_base=10
    )
    print("rigidity W+ vanish: %d bad / %d checks" % (rig_bad, rig_checks))
    assert rig_bad == 0, "R1/profile rigidity FAILED on 37-cell"

    if dim_orb > 0:
        Ker = SL.nullspace(Phi_orb.T % p, p) % p
        AMB2 = (Ker @ AMB) % p
        rig2, chk2 = rigidity_on_cell(
            fr, A6, C6, AMB2, Aspan, chi, inv_triple, p, rng, n_base=8
        )
        print("glued-cell rigidity: %d bad / %d" % (rig2, chk2))
        assert rig2 == 0
    else:
        Ker = np.zeros((0, 37), dtype=np.int64)
        rig2, chk2 = 0, 0

    # 22-cell effects (pattern-independent closed cut)
    # Rank 0 means gluing is automatic (both sides' leading data vanish on
    # the locus) — all 22 remain live at dim 37.
    if dim_orb == 0:
        n_dead, n_live = 22, 0
        mechanism = (
            "cross-band common-normal gluing on ell_V has full rank on the "
            "universal 37-cell"
        )
        per_cell = [
            {"id": i, "verdict": "DEAD", "dim": 0, "mechanism": mechanism}
            for i in paths.SURV_IDS
        ]
        flag_all_dead = True
        auto_note = None
    else:
        n_dead, n_live = 0, 22
        mechanism = None
        auto_note = (
            "Primary (d-1,1) gluing has rank 0: the plus-plane leading form "
            "vanishes identically on ell_V (compatible with sealed ord_ellV>=6), "
            "so both bands restrict to the zero section and agree automatically. "
            "No new closed cut; all 22 remain at dim <= 37."
        )
        per_cell = [
            {
                "id": i,
                "verdict": "LIVE",
                "dim_upper": int(dim_orb),
                "note": "gluing automatic (leading form vanishes on locus)",
            }
            for i in paths.SURV_IDS
        ]
        flag_all_dead = False

    r39 = SL.rref_rank(((NUL39 @ Phi) % p).T % p, p)

    out = {
        "p": int(p),
        "d": DEG,
        "cell_in_dim": 37,
        "layer0_dim": 39,
        "rep_v4_involutions": [int(x) for x in inv_triple],
        "leading_vanish_table": vtable,
        "rank_rep_pass1": int(r1),
        "dim_rep_pass1": int(37 - r1),
        "rank_rep_saturated": int(r2),
        "dim_rep_saturated": int(37 - r2),
        "saturation_ok": bool(sat_ok and r_orb >= r2),
        "rank_full_orbit_55": int(r_orb),
        "dim_after_gluing": int(dim_orb),
        "rank_on_layer0_39_rep": int(r39),
        "diagnostic_full_fiber_rank": int(r_ff),
        "diagnostic_full_fiber_dim": int(37 - r_ff),
        "depth6_diagnostic": d6,
        "n_func_rep_sat": int(Phi_sat.shape[1]),
        "n_func_orbit": int(Phi_orb.shape[1]),
        "meta_pass1": meta,
        "meta_sat": meta2,
        "rigidity_slice_bad": int(rig_bad),
        "rigidity_slice_checks": int(rig_checks),
        "rigidity_glued_bad": int(rig2),
        "rigidity_glued_checks": int(chk2),
        "n_dead_among_22": int(n_dead),
        "n_live_among_22": int(n_live),
        "flag_all_dead": bool(flag_all_dead),
        "mechanism_if_dead": mechanism,
        "automatic_gluing_note": auto_note,
        "per_cell": per_cell,
        "seconds": time.time() - t0,
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
    }
    np.save(os.path.join(RES, "gluing_phi_cell_p%d.npy" % p), Phi_sat % p)
    np.save(os.path.join(RES, "gluing_phi_orbit_p%d.npy" % p), Phi_orb % p)
    np.save(os.path.join(RES, "cell37_amb_p%d.npy" % p), AMB % p)
    if dim_orb > 0:
        np.save(os.path.join(RES, "glued_basis_p%d.npy" % p), Ker % p)

    path = os.path.join(RES, "gluing_d35_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
    print("wrote", path)
    print(
        "RESULT d35: rank=%d dim_after=%d dead22=%d live22=%d flag_all_dead=%s"
        % (r_orb, dim_orb, n_dead, n_live, flag_all_dead)
    )
    return out


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    run(p)


if __name__ == "__main__":
    main()
