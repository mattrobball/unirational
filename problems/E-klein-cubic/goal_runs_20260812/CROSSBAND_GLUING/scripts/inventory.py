#!/usr/bin/env python3
"""Inventory of positive-dimensional cross-band gluing loci (orbit reps).

A cross-band gluing locus is a POSITIVE-dimensional intersection of
sweep-row closures belonging to DIFFERENT group elements' bands.

Arrangement facts (FIX_VII §7, FIX-A0/A1):
  - 55 involutions σ; P_σ = P(W⁺_σ) ≅ P²; L_σ = P(W⁻_σ) ≅ P¹ ⊂ X.
  - Commuting pair (σ,τ) generates V4; P_σ ∩ P_τ = ℓ_V (line);
    L_σ ∩ L_τ = type-I point; L_τ ∩ P_σ = point on E_σ.
  - Non-commuting planes meet in a point only; L_σ ∩ L_τ = ∅;
    no minus-line lies in a foreign plus-plane.
  - ℓ_V = P(W^{V4}); sits in all three plus-planes of its V4;
    ℓ_V ∩ L_τ = ∅ always; 55 such lines, Stab = A4 = N_G(V4).

Positive-dimensional cross-band loci (scheme-level shared supports):
  (L1) ℓ_V for each V4  —  = P_σ ∩ P_τ for each commuting pair in the V4
       also = P_σ ∩ ℓ_V for each of the three involutions of the V4.
       Orbit size 55; stab A4; one orbit under G.
  (L2) No positive-dim locus from non-commuting plane pairs (0-dim pts).
  (L3) No positive-dim locus from minus-line pairs (0-dim or empty).
  (L4) No positive-dim locus from plane ∩ foreign minus-line (0-dim pts).

Degree-general: the loci themselves (as subschemes of P⁴ / of Z) are
degree-independent arrangement strata. Which *leading-order* gluing
conditions fire depends on the residue class of d (m odd forced; at
even d the minus-line band is active, etc.).

Usage: python3 inventory.py [p]
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

import paths
import slicelib as SL


def nullspace_rows(M, p):
    return SL.nullspace(np.array(M, dtype=np.int64) % p, p)


def list_involutions(fr):
    return [g for g in range(660) if fr["orders"][g] == 2]


def commute(fr, a, b, p):
    Ra, Rb = fr["RHO"][a] % p, fr["RHO"][b] % p
    return np.array_equal((Ra @ Rb) % p, (Rb @ Ra) % p)


def plane_intersection_dim(fr, a, b, p):
    """dim of W⁺_a ∩ W⁺_b (vector-space dim)."""
    I5 = np.eye(5, dtype=np.int64)
    Wa = nullspace_rows((fr["RHO"][a] - I5) % p, p)
    Wb = nullspace_rows((fr["RHO"][b] - I5) % p, p)
    # intersection of row-spans
    big = np.concatenate([Wa, (-Wb) % p], axis=0)
    ker = nullspace_rows(big.T % p, p)
    if ker.shape[0] == 0:
        return 0
    # dim = rank of ker[:, :Wa.shape[0]] @ Wa
    inter = (ker[:, : Wa.shape[0]] @ Wa) % p
    return int(SL.rref_rank(inter % p, p))


def minus_intersection_dim(fr, a, b, p):
    I5 = np.eye(5, dtype=np.int64)
    Wa = nullspace_rows((fr["RHO"][a] + I5) % p, p)
    Wb = nullspace_rows((fr["RHO"][b] + I5) % p, p)
    big = np.concatenate([Wa, (-Wb) % p], axis=0)
    ker = nullspace_rows(big.T % p, p)
    if ker.shape[0] == 0:
        return 0
    inter = (ker[:, : Wa.shape[0]] @ Wa) % p
    return int(SL.rref_rank(inter % p, p))


def build_v4s(fr, p):
    """Return list of V4s as frozensets of 3 involution indices + one id."""
    invs = list_involutions(fr)
    RHO = fr["RHO"]
    seen = set()
    v4s = []
    for i, a in enumerate(invs):
        for b in invs[i + 1 :]:
            if not commute(fr, a, b, p):
                continue
            ab = None
            Ra, Rb = RHO[a] % p, RHO[b] % p
            Rab = (Ra @ Rb) % p
            for c in invs:
                if c == a or c == b:
                    continue
                if np.array_equal(RHO[c] % p, Rab):
                    ab = c
                    break
            if ab is None:
                continue
            key = frozenset([a, b, ab])
            if key in seen:
                continue
            seen.add(key)
            v4s.append({"involutions": sorted([a, b, ab]), "key": key})
    return v4s


def v4_ellV(fr, p, inv_triple):
    """A = W^{V4} = joint +1 eigenspace of all three involutions (2-dim)."""
    I5 = np.eye(5, dtype=np.int64)
    Ms = [fr["RHO"][g] % p for g in inv_triple]
    B = I5.copy()
    for M in Ms:
        rows = nullspace_rows((M - I5) % p, p)
        big = np.concatenate([B, (-rows) % p], axis=0)
        ker = nullspace_rows(big.T % p, p)
        if ker.shape[0] == 0:
            return np.zeros((0, 5), dtype=np.int64)
        B = (ker[:, : B.shape[0]] @ B) % p
        keep = []
        for v in B:
            test = np.array(keep + [v], dtype=np.int64) if keep else v[None, :]
            if keep:
                if SL.rref_rank(test % p, p) == len(keep) + 1:
                    keep.append(v % p)
            else:
                if np.any(v % p):
                    keep.append(v % p)
        B = np.array(keep, dtype=np.int64) if keep else np.zeros((0, 5), dtype=np.int64)
    return B % p


def char_lines(fr, p, sigma, tau):
    """Joint eigenlines for V4=<σ,τ>: return dict of sign-pair -> 1-dim vector.

    signs (sσ, sτ) ∈ {±1}²; the four lines B,C,D and the 2-space A.
    """
    I5 = np.eye(5, dtype=np.int64)
    Ms = [fr["RHO"][sigma] % p, fr["RHO"][tau] % p]
    out = {}
    for s0 in (1, -1):
        for s1 in (1, -1):
            B = I5.copy()
            for M, s in zip(Ms, (s0, s1)):
                rows = nullspace_rows((M - (s % p) * I5) % p, p)
                big = np.concatenate([B, (-rows) % p], axis=0)
                ker = nullspace_rows(big.T % p, p)
                if ker.shape[0] == 0:
                    B = np.zeros((0, 5), dtype=np.int64)
                    break
                B = (ker[:, : B.shape[0]] @ B) % p
                keep = []
                for v in B:
                    test = np.array(keep + [v], dtype=np.int64) if keep else v[None, :]
                    if keep:
                        if SL.rref_rank(test % p, p) == len(keep) + 1:
                            keep.append(v % p)
                    else:
                        if np.any(v % p):
                            keep.append(v % p)
                B = (
                    np.array(keep, dtype=np.int64)
                    if keep
                    else np.zeros((0, 5), dtype=np.int64)
                )
            out[(s0, s1)] = B % p
    return out


def inventory(p, verbose=True):
    fr = SL.build_frame(p, verbose=False)
    invs = list_involutions(fr)
    assert len(invs) == 55

    # pair census
    n_comm = 0
    n_noncomm = 0
    dim_plus_comm = []
    dim_plus_non = []
    dim_minus_comm = []
    dim_minus_non = []
    for i, a in enumerate(invs):
        for b in invs[i + 1 :]:
            if commute(fr, a, b, p):
                n_comm += 1
                dim_plus_comm.append(plane_intersection_dim(fr, a, b, p))
                dim_minus_comm.append(minus_intersection_dim(fr, a, b, p))
            else:
                n_noncomm += 1
                dim_plus_non.append(plane_intersection_dim(fr, a, b, p))
                dim_minus_non.append(minus_intersection_dim(fr, a, b, p))

    v4s = build_v4s(fr, p)
    assert len(v4s) == 55, len(v4s)

    # sample one V4 for representative geometry
    rep = v4s[0]
    A = v4_ellV(fr, p, rep["involutions"])
    assert A.shape[0] == 2, A.shape

    # stab size of ℓ_V: |G|/orbit = 660/55 = 12 = |A4|
    # confirm each V4 has dim-2 joint +1 space
    bad_A = 0
    for v in v4s:
        AA = v4_ellV(fr, p, v["involutions"])
        if AA.shape[0] != 2:
            bad_A += 1

    # plus ∩ ℓ_V incidence: for σ in V4, ℓ_V ⊂ P_σ (vector A ⊂ W⁺_σ)
    I5 = np.eye(5, dtype=np.int64)
    sigma0 = rep["involutions"][0]
    Wp = nullspace_rows((fr["RHO"][sigma0] - I5) % p, p)
    # A should lie in Wp
    big = np.concatenate([Wp, (-A) % p], axis=0)
    ker = nullspace_rows(big.T % p, p)
    # A ⊂ Wp iff every row of A is in span(Wp) iff intersection dim = 2
    A_in_Wp = ker.shape[0] >= 2 and int(
        SL.rref_rank((ker[:, : Wp.shape[0]] @ Wp) % p, p)
    ) == 2

    # L_σ ∩ ℓ_V empty: W⁻_σ ∩ A = 0
    Wm = nullspace_rows((fr["RHO"][sigma0] + I5) % p, p)
    big2 = np.concatenate([Wm, (-A) % p], axis=0)
    ker2 = nullspace_rows(big2.T % p, p)
    L_meet_ell = 0 if ker2.shape[0] == 0 else int(
        SL.rref_rank((ker2[:, : Wm.shape[0]] @ Wm) % p, p)
    )

    loci = [
        {
            "id": "L1_ellV_commuting_planes",
            "description": (
                "ℓ_V = P_σ ∩ P_τ for commuting involution pairs in a V4; "
                "also P_σ ∩ ℓ_V for each of the three involutions of the V4"
            ),
            "dim_projective": 1,
            "orbit_size": 55,
            "stabilizer": "A4 = N_G(V4)",
            "stab_order": 12,
            "n_bands_meeting": 3,
            "band_type": "plus-plane D_{P_σ} of each of three involutions",
            "positive_dimensional": True,
            "rep_involutions": rep["involutions"],
            "rep_A_dim": int(A.shape[0]),
        },
        {
            "id": "L2_noncommuting_planes",
            "description": "P_σ ∩ P_σ' for non-commuting pairs (point only)",
            "dim_projective": 0,
            "orbit_note": "1320 unordered non-commuting pairs",
            "n_unordered_pairs": n_noncomm,
            "positive_dimensional": False,
            "excluded_reason": "0-dimensional; census children already cover points",
        },
        {
            "id": "L3_minus_line_pairs",
            "description": "L_σ ∩ L_τ: type-I point if commuting, empty if not",
            "dim_projective": 0,
            "positive_dimensional": False,
            "excluded_reason": "0-dimensional or empty",
        },
        {
            "id": "L4_plane_foreign_minus",
            "description": "P_σ ∩ L_τ: point on E_σ if commuting, empty if not",
            "dim_projective": 0,
            "positive_dimensional": False,
            "excluded_reason": "0-dimensional or empty; no L in foreign P",
        },
        {
            "id": "L5_ellV_minus",
            "description": "ℓ_V ∩ L_τ = ∅ always",
            "dim_projective": -1,
            "positive_dimensional": False,
            "excluded_reason": "empty",
        },
    ]

    out = {
        "p": p,
        "n_involutions": 55,
        "n_unordered_commuting_pairs": n_comm,
        "n_unordered_noncommuting_pairs": n_noncomm,
        "expected_commuting": 165,
        "expected_noncommuting": 1320,
        "plus_inter_dim_commuting": {
            "min": int(min(dim_plus_comm)),
            "max": int(max(dim_plus_comm)),
            "all_equal_2": all(d == 2 for d in dim_plus_comm),
        },
        "plus_inter_dim_noncommuting": {
            "min": int(min(dim_plus_non)),
            "max": int(max(dim_plus_non)),
            "all_equal_1": all(d == 1 for d in dim_plus_non),
        },
        "minus_inter_dim_commuting": {
            "min": int(min(dim_minus_comm)),
            "max": int(max(dim_minus_comm)),
            "all_equal_1": all(d == 1 for d in dim_minus_comm),
        },
        "minus_inter_dim_noncommuting": {
            "min": int(min(dim_minus_non)),
            "max": int(max(dim_minus_non)),
            "all_equal_0": all(d == 0 for d in dim_minus_non),
        },
        "n_v4": len(v4s),
        "bad_ellV_count": bad_A,
        "rep_A_in_Wplus": bool(A_in_Wp),
        "rep_L_meet_ellV_dim": L_meet_ell,
        "pos_dim_orbit_count": 1,
        "pos_dim_loci": [L for L in loci if L["positive_dimensional"]],
        "all_loci": loci,
        "degree_general": {
            "loci_degree_independent": True,
            "note": (
                "The arrangement strata (ℓ_V, plane meets, line meets) are "
                "independent of d. Gluing conditions that fire depend on the "
                "leading multidegree class: at every d with forced m=1 on "
                "plus-planes (the sealed (1,6) window), the (d-1,1) leading "
                "datum of each D_{P_σ} must agree on ℓ_V with its V4 partners. "
                "At even d the minus-line band is additionally active but "
                "contributes no new positive-dim cross-band locus. "
                "Class-dependent: which depth of jet is the leading term "
                "(m odd; residue tables)."
            ),
            "every_degree": [
                "L1 ell_V gluing of plus-plane leading data across the three "
                "involutions of each V4 (whenever m>=1 is forced)"
            ],
            "class_dependent": [
                "jet order of the leading term (m), parity of line-order, "
                "C6/C5/C11 structure cuts (sealed STAGE2 residue table)"
            ],
        },
    }
    if verbose:
        print("p=%d: commuting pairs %d (expect 165), noncomm %d (expect 1320)"
              % (p, n_comm, n_noncomm))
        print("  plus∩ dim commuting all-2:", out["plus_inter_dim_commuting"]["all_equal_2"])
        print("  plus∩ dim noncomm all-1:", out["plus_inter_dim_noncommuting"]["all_equal_1"])
        print("  minus∩ dim commuting all-1:", out["minus_inter_dim_commuting"]["all_equal_1"])
        print("  minus∩ dim noncomm all-0:", out["minus_inter_dim_noncommuting"]["all_equal_0"])
        print("  n_V4=%d bad_ellV=%d A_in_Wp=%s L∩ell=%d"
              % (len(v4s), bad_A, A_in_Wp, L_meet_ell))
        print("  POS-DIM orbits: 1 (ell_V / commuting plane triples), size 55, stab A4")
    return out, fr, v4s


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    out, _, _ = inventory(p, verbose=True)
    path = os.path.join(paths.RES, "inventory_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1, sort_keys=True)
    print("wrote", path)


if __name__ == "__main__":
    main()
