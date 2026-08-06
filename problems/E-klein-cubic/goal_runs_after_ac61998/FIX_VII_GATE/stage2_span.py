"""Stage 2: explicit, self-certified spanning of M_34.

  * map / polar / trivial covariant generator bases for d <= 12, by the
    generator-equivariance null-space (same recipe as FIX-VII-XRING stage 2);
  * the invariant ring to degree 33, built multiplicatively (+ contractions
    <map_e, polar_k>), certified degree by degree against the exact Molien
    dimensions;
  * M_34 = span{ inv[34-e] * map[e] : e <= 12 }, certified by an evaluation
    rank of exactly 576 = dim M_34.

CERTIFICATION SEMANTICS.  Ranks are computed from values at random points of
F_p^5.  Since every form here has degree <= 34 < p, a nonzero form is a
nonzero function on F_p^5, and rank(evaluation) <= dim(span) always.  So
`rank(evaluation) == Molien dimension` forces span = the whole space: it is a
decisive equality, not a sampling estimate.
"""
import json
import os
import sys
import time

import numpy as np

import gatelib as GL
from gatelib import (check, matmul_mod, monomials, nmon, nullspace, rref,
                     shift_row, sym_power_matrix)
import stage1_group as S1

HERE = os.path.dirname(os.path.abspath(__file__))
DMAX_GEN = 12
DMAX_MAP = 16          # map-type generators are extended past 12 if needed
DTOP = 34
NPTS_SEL = 620

BANKED_MAP = [1, 0, 0, 2, 1, 2, 4, 5, 6, 10, 12, 16]
BANKED_POLAR = [0, 1, 0, 1, 2, 2, 4, 5, 6, 10, 12, 15]
BANKED_INV = [1, 0, 1, 2, 1, 2, 3, 3, 4, 6, 5, 8, 10, 10, 13, 17, 17, 22, 26,
              28, 33, 40, 43, 50, 58, 63, 72, 84, 89, 102, 115]   # d = 3..33
DIM_M34 = 576


def molien():
    fn = os.path.join(HERE, "p2copy", "payloads", "MOLIEN.json")
    j = json.load(open(fn))
    inv = {int(k): v for k, v in j["dim_invariants_Sym_d"].items()}
    cov = {int(k): v for k, v in j["dim_covariant_module_M_d"].items()}
    return inv, cov


# ----------------------------------------------- covariant spaces (d <= 12)

_SYMCACHE = {}


def sym_cached(g, d, p):
    key = (p, d, g.tobytes())
    if key not in _SYMCACHE:
        _SYMCACHE[key] = sym_power_matrix(g, d, p)
    return _SYMCACHE[key]


def contragredient(g, p):
    return GL.matinv(g, p).T % p


def target_reps(gens, kind, p):
    if kind == "map":
        return [g.copy() for g in gens]
    if kind == "polar":
        return [contragredient(g, p) for g in gens]
    if kind == "triv":
        return [np.ones((1, 1), dtype=np.int64) for _ in gens]
    raise ValueError(kind)


def is_monomial(M):
    return all(np.count_nonzero(M[i]) <= 1 for i in range(M.shape[0])) and \
        all(np.count_nonzero(M[:, j]) <= 1 for j in range(M.shape[1]))


def apply_cond(Carr, rho_t, Sd, p):
    nc, m, N = Carr.shape
    left = np.einsum('kj,cjn->ckn', rho_t.astype(np.int64), Carr) % p
    flat = Carr.reshape(nc * m, N)
    if is_monomial(Sd):
        right = np.zeros_like(flat)
        rows, cols = np.nonzero(Sd)
        vals = Sd[rows, cols].astype(np.int64)
        right[:, cols] = (flat[:, rows] * vals[None, :]) % p
    else:
        right = matmul_mod(flat, Sd, p)
    return (left - right.reshape(nc, m, N)) % p


def covariant_space(gens, kind, d, p):
    rt = target_reps(gens, kind, p)
    m = rt[0].shape[0]
    N = nmon(d)
    Sds = [sym_cached(g, d, p) for g in gens]
    Sd0, r0 = Sds[0], rt[0]
    assert np.array_equal(Sd0, np.diag(np.diag(Sd0)))
    assert np.array_equal(r0, np.diag(np.diag(r0)))
    allowed = [(j, a) for j in range(m) for a in range(N)
               if int(r0[j, j]) == int(Sd0[a, a])]
    if not allowed:
        return np.zeros((0, m, N), dtype=np.int64)
    B = np.zeros((len(allowed), m, N), dtype=np.int64)
    for c, (j, a) in enumerate(allowed):
        B[c, j, a] = 1
    for gi in (1, 2):
        Rm = apply_cond(B, rt[gi], Sds[gi], p).reshape(len(B), m * N).T
        nz = np.nonzero(Rm.any(axis=1))[0]
        Rm = Rm[nz]
        ker = nullspace(Rm, p) if Rm.shape[0] else np.eye(len(B), dtype=np.int64)
        if ker.shape[1] == 0:
            return np.zeros((0, m, N), dtype=np.int64)
        B = np.tensordot(ker.T % p, B, axes=(1, 0)) % p
    return echelonize(B % p, p)


def echelonize(B, p):
    if len(B) == 0:
        return B
    nc, m, N = B.shape
    R, piv = rref(B.reshape(nc, m * N), p)
    return R[:len(piv)].reshape(-1, m, N) % p


# -------------------------------------------------- monomial value recursion

_STEPCACHE = {}


def step_tables(d):
    """(piv, src): degree-d monomial a = e_{piv[a]} + mon_{d-1}[src[a]]."""
    if d in _STEPCACHE:
        return _STEPCACHE[d]
    mons, _ = monomials(d)
    _, previdx = monomials(d - 1)
    piv = np.empty(len(mons), dtype=np.int64)
    src = np.empty(len(mons), dtype=np.int64)
    for a, mm in enumerate(mons):
        i = next(k for k in range(5) if mm[k] > 0)
        aa = list(mm)
        aa[i] -= 1
        piv[a] = i
        src[a] = previdx[tuple(aa)]
    _STEPCACHE[d] = (piv, src)
    return piv, src


def mon_step(prev_vals, d, PTSt, p):
    piv, src = step_tables(d)
    return (PTSt[piv] * prev_vals[src]) % p


# ------------------------------------------------------- polynomial products

def mul_rows(u_vec, a, V, b, p):
    """(single degree-a poly u) * (rows of V, each a degree-b poly)."""
    Nc = nmon(a + b)
    out = np.zeros((V.shape[0], Nc), dtype=np.int64)
    mons_a, _ = monomials(a)
    nz = np.nonzero(np.asarray(u_vec) % p)[0]
    Vi = V.astype(np.int64) % p
    for i in nz:
        c = int(u_vec[i]) % p
        row = shift_row(mons_a[i], b)
        out[:, row] = (out[:, row] + c * Vi) % p
    return out


def contract(U, V, e, k, p):
    """<map_e, polar_k> for every pair: returns (nu*nv, N_{e+k})."""
    Nc = nmon(e + k)
    mons_e, _ = monomials(e)
    out = np.zeros((U.shape[0] * V.shape[0], Nc), dtype=np.int64)
    for iu in range(U.shape[0]):
        acc = np.zeros((V.shape[0], Nc), dtype=np.int64)
        for comp in range(5):
            u = U[iu, comp]
            nz = np.nonzero(u % p)[0]
            Vc = V[:, comp, :].astype(np.int64) % p
            for i in nz:
                c = int(u[i]) % p
                row = shift_row(mons_e[i], k)
                acc[:, row] = (acc[:, row] + c * Vc) % p
        out[iu * V.shape[0]:(iu + 1) * V.shape[0]] = acc
    return out % p


# --------------------------------------------------------------------- main

def run(p, tag=""):
    t0 = time.time()
    log = lambda *a: print(*a, flush=True)
    log("=== Stage 2, p=%d ===" % p)
    MOL_INV, MOL_COV = molien()
    ok = ([MOL_INV[d] for d in range(3, 34)] == BANKED_INV and
          [MOL_COV[d] for d in range(1, 13)] == BANKED_MAP and
          MOL_COV[34] == DIM_M34)
    check("molien_matches_banked" + tag, ok,
          "invariant ladder d=3..33, map ladder d=1..12, dim M_34=%d"
          % MOL_COV[34])

    G = S1.build_group(p, tag=tag, do_checks=False)
    gens = [G["g11"], G["s5"], G["S"]]

    rng = np.random.default_rng(4242 + p)
    PTS = rng.integers(1, p, size=(NPTS_SEL, 5)).astype(np.int64)
    PTSt = np.ascontiguousarray(PTS.T)                       # (5, npts)

    # --- generator bases, d <= 12
    MAPC, POLC, INVC = {}, {}, {}
    dims = {"map": [], "polar": [], "triv": []}
    for d in range(1, DMAX_GEN + 1):
        MAPC[d] = covariant_space(gens, "map", d, p)
        POLC[d] = covariant_space(gens, "polar", d, p)
        Tv = covariant_space(gens, "triv", d, p)
        INVC[d] = Tv.reshape(len(Tv), nmon(d)) if len(Tv) else \
            np.zeros((0, nmon(d)), dtype=np.int64)
        dims["map"].append(len(MAPC[d]))
        dims["polar"].append(len(POLC[d]))
        dims["triv"].append(len(INVC[d]))
        log("  d=%2d  map %2d  polar %2d  triv %d   (%.0fs)"
            % (d, len(MAPC[d]), len(POLC[d]), len(INVC[d]), time.time() - t0))
    check("gen_dims_match_banked" + tag,
          dims["map"] == BANKED_MAP and dims["polar"] == BANKED_POLAR and
          dims["triv"] == [MOL_INV[d] for d in range(1, 13)],
          "map=%s polar=%s triv=%s" % (dims["map"], dims["polar"],
                                       dims["triv"]))
    INVC[0] = np.ones((1, 1), dtype=np.int64)

    # --- monomial values, degree by degree; invariant ladder on the way up
    vals = np.ones((1, NPTS_SEL), dtype=np.int64)            # degree 0
    INVV, MAPV = {0: np.ones((1, NPTS_SEL), dtype=np.int64)}, {}
    VCACHE = {}
    ladder, short = [], []
    for d in range(1, DTOP):
        vals = mon_step(vals, d, PTSt, p)
        if DMAX_GEN < d <= DMAX_MAP:
            VCACHE[d] = vals.copy()
        if d <= DMAX_GEN:
            if len(MAPC[d]):
                MAPV[d] = matmul_mod(MAPC[d].reshape(-1, nmon(d)), vals,
                                     p).reshape(len(MAPC[d]), 5, NPTS_SEL)
            if len(INVC[d]):
                INVV[d] = matmul_mod(INVC[d], vals, p)
            else:
                INVV[d] = np.zeros((0, NPTS_SEL), dtype=np.int64)
            ladder.append((d, len(INVC[d]), MOL_INV[d]))
            continue
        if d == DTOP:
            break
        # ---- degree d > 12: build invariants multiplicatively
        target = MOL_INV[d]
        bas = GL.RowBasis(NPTS_SEL, p)
        chosen = []
        sources = []
        # cheapest first: multiply by the low-degree invariant bases
        for g in range(3, DMAX_GEN + 1):
            if bas.rank >= target:
                break
            if len(INVC.get(g, [])) == 0 or len(INVC.get(d - g, [])) == 0:
                continue
            for iu in range(len(INVC[g])):
                if bas.rank >= target:
                    break
                cand = mul_rows(INVC[g][iu], g, INVC[d - g], d - g, p)
                cv = matmul_mod(cand, vals, p)
                before = bas.rank
                bas.add_block(cv, [(g, iu, a) for a in range(len(cand))])
                for tg in bas.keep[before:]:
                    chosen.append(cand[tg[2]])
                    sources.append(("prod", g, iu, tg[2]))
        # if still short, add contractions <map_e, polar_k>, e + k = d
        if bas.rank < target:
            for e in range(1, DMAX_GEN + 1):
                k = d - e
                if k < 1 or k > DMAX_GEN or bas.rank >= target:
                    continue
                if len(MAPC[e]) == 0 or len(POLC[k]) == 0:
                    continue
                cand = contract(MAPC[e], POLC[k], e, k, p)
                cv = matmul_mod(cand, vals, p)
                before = bas.rank
                bas.add_block(cv, [("ctr", e, k, a) for a in range(len(cand))])
                for tg in bas.keep[before:]:
                    chosen.append(cand[tg[3]])
                    sources.append(("ctr", e, k, tg[3]))
        INVC[d] = (np.array(chosen, dtype=np.int64) % p if chosen else
                   np.zeros((0, nmon(d)), dtype=np.int64))
        INVV[d] = matmul_mod(INVC[d], vals, p) if len(INVC[d]) else \
            np.zeros((0, NPTS_SEL), dtype=np.int64)
        ladder.append((d, len(INVC[d]), target))
        if len(INVC[d]) != target:
            short.append((d, len(INVC[d]), target))
        log("  d=%2d  invariants %3d / %3d %s  (%.0fs)"
            % (d, len(INVC[d]), target, "" if len(INVC[d]) == target
               else "*** SHORT ***", time.time() - t0))
    check("invariant_ladder_full" + tag, not short,
          "dims match Molien at every d<=33" if not short
          else "shortfalls (d,got,want)=%s" % short)

    # --- the degree-34 spanning set
    log("  spanning M_34 ...")
    bas = GL.RowBasis(5 * NPTS_SEL, p)
    ncand = 0
    ext_map = []
    for e in list(sorted(MAPV)) + list(range(DMAX_GEN + 1, DMAX_MAP + 1)):
        if bas.rank >= DIM_M34:
            break
        if e not in MAPV:                       # lazy generator extension
            MAPC[e] = covariant_space(gens, "map", e, p)
            ext_map.append((e, len(MAPC[e]), MOL_COV[e]))
            log("    [extend] map d=%d dim %d (Molien %d)  (%.0fs)"
                % (e, len(MAPC[e]), MOL_COV[e], time.time() - t0))
            if len(MAPC[e]) == 0:
                continue
            MAPV[e] = matmul_mod(MAPC[e].reshape(-1, nmon(e)), VCACHE[e],
                                 p).reshape(len(MAPC[e]), 5, NPTS_SEL)
        a = DTOP - e
        if len(INVC.get(a, [])) == 0:
            continue
        nu, na = MAPV[e].shape[0], INVV[a].shape[0]
        rows = (INVV[a][:, None, None, :] * MAPV[e][None, :, :, :]) % p
        rows = rows.reshape(na * nu, 5 * NPTS_SEL)
        tags = [(e, u, aa) for aa in range(na) for u in range(nu)]
        ncand += len(tags)
        bas.add_block(rows, tags)
        log("    e=%2d  inv(%d)=%3d x map=%2d -> rank %d  (%.0fs)"
            % (e, a, na, nu, bas.rank, time.time() - t0))
        if bas.rank >= DIM_M34:
            break
    if ext_map:
        check("map_extension_dims" + tag,
              all(g == w for _, g, w in ext_map),
              "d>12 map dims (d,got,Molien)=%s" % ext_map)
    check("span_576" + tag, bas.rank == DIM_M34,
          "evaluation rank %d of %d candidates (dim M_34 = %d); "
          "map degrees used up to %d"
          % (bas.rank, ncand, DIM_M34, max(t[0] for t in bas.keep)))

    basis_tags = [list(map(int, t)) for t in bas.keep]
    np.savez_compressed(os.path.join(HERE, "payload", "invC_p%d.npz" % p),
                        **{"d%d" % d: INVC[d].astype(np.uint8)
                           for d in sorted(INVC) if len(INVC[d])})
    np.savez_compressed(os.path.join(HERE, "payload", "covC_p%d.npz" % p),
                        **{("map_%d" % d): MAPC[d] for d in MAPC},
                        **{("polar_%d" % d): POLC[d] for d in POLC})
    with open(os.path.join(HERE, "payload", "m34_basis_p%d.json" % p), "w") as f:
        json.dump({"p": p, "dim_M34": DIM_M34, "rank": bas.rank,
                   "n_candidates": ncand,
                   "basis": basis_tags,
                   "encoding": "each entry [e,u,a]: inv[34-e][a] * map[e][u]",
                   "invariant_ladder": [[int(x) for x in t] for t in ladder]},
                  f, indent=1)
    with open(os.path.join(HERE, "results", "ladder_p%d.txt" % p), "w") as f:
        for d, got, want in ladder:
            f.write("INV %2d %3d %3d %s\n" % (d, got, want,
                                              "OK" if got == want else "SHORT"))
    log("  total %.0fs" % (time.time() - t0))
    return dict(INVC=INVC, MAPC=MAPC, POLC=POLC, basis=basis_tags)


if __name__ == "__main__":
    for pp in [int(a) for a in (sys.argv[1:] or ["67", "199"])]:
        run(pp, tag="_p%d" % pp)
