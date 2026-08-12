#!/usr/bin/env python3
"""Collect the 60 C11-points of the Weil frame.

Every order-11 element of the 660-matrix frame has five eigenlines in W.
Those eigenlines fall in 12 frames of 5 (one frame per C11-subgroup).
Projective dedupe of the union is exactly 60 points, all on the Klein cubic.

This is the geometric content of the sealed L12 all-degree C11 base-point
theorem: every landing map vanishes at these 60 points, at every degree.
"""
from __future__ import annotations

import numpy as np

import slicelib as SL
import d34lib as D34


def primitive_11th_root(p):
    for a in range(2, p):
        c = pow(a, (p - 1) // 11, p)
        if c != 1:
            return c
    raise RuntimeError("no primitive 11th root in F_%d" % p)


def normalize_pt(v, p):
    """Scale so the first nonzero coordinate is 1. Returns a 5-tuple."""
    v = np.array(v, dtype=np.int64) % p
    for i in range(5):
        if int(v[i]) % p:
            inv = pow(int(v[i]), p - 2, p)
            return tuple(int(x) * inv % p for x in v)
    raise ValueError("zero vector")


def klein_on_X(pt, p):
    return D34.klein_F(pt, p) % p == 0


def matrix_index_map(fr, p):
    """Flattened RHO[h] -> group index h."""
    RHO = fr["RHO"]
    out = {}
    for h in range(660):
        key = tuple(int(x) for x in (RHO[h] % p).ravel())
        out[key] = h
    return out


def c11_subgroups(fr, p):
    """The 12 cyclic order-11 subgroups (each: 11 group indices, incl. id)."""
    RHO, orders = fr["RHO"], fr["orders"]
    gens = [g for g in range(660) if orders[g] == 11]
    if len(gens) != 120:
        raise AssertionError("expected 120 order-11 elements, got %d" % len(gens))
    mat_to_idx = matrix_index_map(fr, p)
    I5 = np.eye(5, dtype=np.int64)
    used = set()
    groups = []
    for g in gens:
        if g in used:
            continue
        G = RHO[g] % p
        members = []
        M = I5.copy()
        for _ in range(11):
            key = tuple(int(x) for x in M.ravel())
            if key not in mat_to_idx:
                raise AssertionError("C11 power not in the 660-matrix frame")
            idx = mat_to_idx[key]
            members.append(idx)
            if orders[idx] == 11:
                used.add(idx)
            M = (M @ G) % p
        if len(members) != 11:
            raise AssertionError("C11 subgroup size %d" % len(members))
        groups.append({"generator": g, "members": members})
    if len(groups) != 12:
        raise AssertionError("expected 12 C11-subgroups, got %d" % len(groups))
    if len(used) != 120:
        raise AssertionError("order-11 coverage %d" % len(used))
    return groups


def eigenframe_of(fr, g_index, p, z11):
    """The 5 projective eigenpoints of one order-11 matrix."""
    RHO = fr["RHO"]
    I5 = np.eye(5, dtype=np.int64)
    G = RHO[g_index] % p
    pts = []
    weights = []
    for k in range(11):
        ns = SL.nullspace((G - pow(z11, k, p) * I5) % p, p)
        if ns.shape[0] == 0:
            continue
        if ns.shape[0] != 1:
            raise AssertionError("C11 weight %d has dim %d" % (k, ns.shape[0]))
        pts.append(normalize_pt(ns[0], p))
        weights.append(k)
    # unique, preserve order
    uniq = []
    seen = set()
    for pt in pts:
        if pt not in seen:
            seen.add(pt)
            uniq.append(pt)
    if len(uniq) != 5:
        raise AssertionError("eigenframe size %d (weights %s)" % (len(uniq), weights))
    return uniq, weights


def collect_c11_points(fr, p):
    """Return (points, report). points is a list of 60 normalized 5-tuples."""
    orders = fr["orders"]
    n_order11 = sum(1 for g in range(660) if orders[g] == 11)
    z11 = primitive_11th_root(p)
    groups = c11_subgroups(fr, p)

    frames = []
    all_pts = []
    for gi, grp in enumerate(groups):
        pts, weights = eigenframe_of(fr, grp["generator"], p, z11)
        # every non-identity element of the subgroup shares this frame
        for h in grp["members"]:
            if orders[h] != 11:
                continue
            pts_h, _ = eigenframe_of(fr, h, p, z11)
            if set(pts_h) != set(pts):
                raise AssertionError("C11-powers do not share an eigenframe")
        frames.append({
            "index": gi,
            "generator": grp["generator"],
            "points": [list(pt) for pt in pts],
            "weights": weights,
        })
        all_pts.extend(pts)

    unique = []
    seen = set()
    for pt in all_pts:
        if pt not in seen:
            seen.add(pt)
            unique.append(pt)
    if len(unique) != 60:
        raise AssertionError("projective unique count %d, expected 60" % len(unique))

    # frames are pairwise disjoint
    frame_sets = [set(tuple(p_) for p_ in fr_["points"]) for fr_ in frames]
    for i in range(12):
        for j in range(i + 1, 12):
            if frame_sets[i] & frame_sets[j]:
                raise AssertionError("frames %d and %d overlap" % (i, j))
        if len(frame_sets[i]) != 5:
            raise AssertionError("frame %d size %d" % (i, len(frame_sets[i])))

    on_X = [klein_on_X(pt, p) for pt in unique]
    if not all(on_X):
        raise AssertionError("C11-points off X: %d" % on_X.count(False))

    # Match the ladder's one-C11 sample: it must be one of the 12 frames.
    P11, _, _ = __import__("produce_ladder").eig_points(fr, p)
    ladder5 = set(normalize_pt(v, p) for v in P11)
    ladder_is_a_frame = any(ladder5 == fs for fs in frame_sets)
    if not ladder_is_a_frame:
        raise AssertionError("produce_ladder.eig_points is not one of the 12 frames")

    report = {
        "p": p,
        "n_order11_elements": n_order11,
        "n_subgroups": 12,
        "n_frames": 12,
        "frame_size": 5,
        "n_points": 60,
        "all_on_X": True,
        "frames_disjoint": True,
        "ladder_five_is_a_frame": True,
        "z11": z11,
        "points": [list(pt) for pt in unique],
        "frames": frames,
    }
    return unique, report
