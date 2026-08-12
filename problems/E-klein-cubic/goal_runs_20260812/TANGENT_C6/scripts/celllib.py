"""37-cell, evaluation of T_c, and the polar Jacobian A(c)."""
from __future__ import annotations

import json
import os

import numpy as np

import paths
import slicelib as SL
import polar as P


def cell37(p):
    nul = np.load(os.path.join(paths.PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    we = json.load(open(os.path.join(paths.PAIR_RES, "worked_example_p%d.json" % p)))
    u6 = np.array(we["universal_matrix_6x39"], dtype=np.int64) % p
    k37 = SL.nullspace(u6 % p, p) % p
    if k37.shape[0] != paths.DIM37:
        raise RuntimeError("cell not 37: %s" % (k37.shape,))
    b = (k37 @ nul) % p
    if SL.rref_rank(b, p) != paths.DIM37:
        raise RuntimeError("B37 rank != 37")
    return {
        "p": int(p),
        "B37": b,
        "K37": k37,
        "U6": u6,
        "rank_U": int(SL.rref_rank(u6 % p, p)),
        "null_shape": [int(nul.shape[0]), int(nul.shape[1])],
        "dim_universal_json": we.get("dim_universal"),
    }


def load_AC():
    a = np.load(os.path.join(paths.PAIR_RES, "layer0_A_p331.npy"))
    c = np.load(os.path.join(paths.PAIR_RES, "layer0_C_p331.npy"))
    if a.shape != (paths.NSEED, 5) or c.shape != (paths.NSEED,):
        raise RuntimeError("seed tables shape")
    return a, c


def seed_values(fr, A, C, W):
    y = np.zeros_like(W)
    r = SL.jet_rows(fr, A, C, W, y, 1, deg=paths.DEG)
    return r[:, :, :, 0] % fr["p"]


def tbasis_from_seeds(B37, V, p):
    """T_{e_α}(x_q): shape (37, npts, 5)."""
    return np.tensordot(B37 % p, V % p, axes=(1, 0)) % p


def T_at(c, Tbasis, p):
    """T_c at the sample points: (npts, 5)."""
    return np.tensordot(np.array(c, dtype=np.int64) % p, Tbasis, axes=(0, 0)) % p


def gradF_batch(Y, p):
    g = np.zeros_like(Y)
    for k in range(5):
        g[:, k] = (2 * Y[:, k] * Y[:, (k + 1) % 5] + Y[:, (k - 1) % 5] ** 2) % p
    return g % p


def F_batch(Y, p):
    s = np.zeros(Y.shape[0], dtype=np.int64)
    for k in range(5):
        s = (s + Y[:, k] * Y[:, k] % p * Y[:, (k + 1) % 5]) % p
    return s % p


def A_matrix(c, Tbasis, p):
    """Sampled polar Jacobian: A[q, α] = ∇F(T_c(x_q)) · T_{e_α}(x_q).

    Shape (npts, 37).  Rank equals rank dΦ_c as soon as the samples
    separate a ≤37-dimensional space of degree-105 forms.
    """
    Tc = T_at(c, Tbasis, p)
    g = gradF_batch(Tc, p)
    return np.einsum("qi,aqi->qa", g, Tbasis) % p


def rho(c, Tbasis, p):
    return int(SL.rref_rank(A_matrix(c, Tbasis, p), p))


def euler_residual(c, Tbasis, p):
    """A(c) c  −  3 F(T_c)   at each sample (should be identically 0)."""
    A = A_matrix(c, Tbasis, p)
    lhs = (A @ (np.array(c, dtype=np.int64) % p)) % p
    rhs = (3 * F_batch(T_at(c, Tbasis, p), p)) % p
    return lhs, rhs, bool(np.array_equal(lhs, rhs))


def hess_quad_batch(Y, S, p):
    acc = np.zeros(Y.shape[0], dtype=np.int64)
    for k in range(5):
        acc = (acc + 2 * Y[:, (k + 1) % 5] * S[:, k] % p * S[:, k]) % p
        acc = (acc + 4 * Y[:, k] * S[:, k] % p * S[:, (k + 1) % 5]) % p
    return acc % p


def second_order_sample(c, s, r, Tbasis, p):
    """Sample (25.2) at the x_q: hess_quad(T_c, T_s) + 2 ∇F(T_c)·T_r."""
    Tc = T_at(c, Tbasis, p)
    Ts = T_at(s, Tbasis, p)
    Tr = T_at(r, Tbasis, p)
    g = gradF_batch(Tc, p)
    return (hess_quad_batch(Tc, Ts, p) + 2 * np.einsum("qi,qi->q", g, Tr)) % p
