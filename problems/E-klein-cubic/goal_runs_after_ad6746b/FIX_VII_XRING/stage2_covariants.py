"""Stage 2: G-equivariant covariant spaces, map / polar / trivial type, d=1..12."""
import json, os, sys, time
import numpy as np
from lib_xring import *
import stage1_group as S1

HERE = os.path.dirname(os.path.abspath(__file__))

BANKED_MAP = [1, 0, 0, 2, 1, 2, 4, 5, 6, 10, 12, 16]     # d = 1..12
BANKED_POLAR = [0, 1, 0, 1, 2, 2, 4, 5, 6, 10, 12, 15]
BANKED_TRIV = {3: 1, 4: 0, 5: 1, 6: 2, 7: 1}


def matmul_mod(A, B, p):
    """int64-safe modular matmul via float64 BLAS (exact while p^2*K < 2^53)."""
    A = np.asarray(A, dtype=np.int64) % p
    B = np.asarray(B, dtype=np.int64) % p
    K = A.shape[-1]
    if (p - 1) ** 2 * K < (1 << 52):
        return (A.astype(np.float64) @ B.astype(np.float64)).astype(np.int64) % p
    return (A @ B) % p


_SYMCACHE = {}


def sym_cached(g, d, p):
    key = (p, d, g.tobytes())
    if key not in _SYMCACHE:
        _SYMCACHE[key] = sym_power_matrix(g, d, p)
    return _SYMCACHE[key]


def contragredient(g, p):
    return matinv(g, p).T % p


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
    """Carr: (nc, m, N).  Returns rho_t @ C - C @ Sd, shape (nc, m, N)."""
    nc, m, N = Carr.shape
    left = np.einsum('kj,cjn->ckn', rho_t.astype(np.int64), Carr) % p
    flat = Carr.reshape(nc * m, N)
    if is_monomial(Sd):
        # C@Sd : column beta gets sum_a C[a]*Sd[a,beta]; one nonzero per row a
        right = np.zeros_like(flat)
        rows, cols = np.nonzero(Sd)
        vals = Sd[rows, cols].astype(np.int64)
        right[:, cols] = (flat[:, rows] * vals[None, :]) % p
    else:
        right = matmul_mod(flat, Sd, p)
    return (left - right.reshape(nc, m, N)) % p


def covariant_space(gens, kind, d, p, verbose=False):
    """Basis of {C in F_p^{m x N_d} : rho_t(g) C = C S_d(g) for all generators}.
    Returns array (dim, m, N_d)."""
    rt = target_reps(gens, kind, p)
    m = rt[0].shape[0]
    mons, _ = monomials(d)
    N = len(mons)
    Sds = [sym_cached(g, d, p) for g in gens]

    # --- step A: the diagonal generator g11 gives a support condition
    Sd0, r0 = Sds[0], rt[0]
    assert np.array_equal(Sd0, np.diag(np.diag(Sd0))), "g11 sym-power not diagonal"
    assert np.array_equal(r0, np.diag(np.diag(r0))), "g11 target rep not diagonal"
    allowed = [(j, a) for j in range(m) for a in range(N)
               if int(r0[j, j]) == int(Sd0[a, a])]
    if verbose:
        print("    d=%d %-6s support after g11: %d / %d" % (d, kind, len(allowed), m * N))
    if not allowed:
        return np.zeros((0, m, N), dtype=np.int64)
    B = np.zeros((len(allowed), m, N), dtype=np.int64)
    for c, (j, a) in enumerate(allowed):
        B[c, j, a] = 1

    # --- steps B, C: impose the remaining generators
    for gi in (1, 2):
        R = apply_cond(B, rt[gi], Sds[gi], p).reshape(len(B), m * N).T   # (mN, nb)
        nzrows = np.nonzero(R.any(axis=1))[0]
        R = R[nzrows]
        ker = nullspace(R, p) if R.shape[0] else np.eye(len(B), dtype=np.int64)
        if ker.shape[1] == 0:
            return np.zeros((0, m, N), dtype=np.int64)
        B = np.tensordot(ker.T % p, B, axes=(1, 0)) % p
        if verbose:
            print("    d=%d %-6s after gen%d: dim %d" % (d, kind, gi, len(B)))
    return B % p


def echelonize(B, p):
    if len(B) == 0:
        return B
    nc, m, N = B.shape
    R, piv = rref(B.reshape(nc, m * N), p)
    return R[:len(piv)].reshape(-1, m, N) % p


def run(p, tag, dmax=12, save_bases=True):
    t0 = time.time()
    print("=== Stage 2, p=%d ===" % p, flush=True)
    G = S1.build_generators(p)
    gens = [G["g11"], G["s5"], G["S"]]

    # conjugate-convention check
    zeta = G["zeta"]
    gauss = sum(pow(zeta, a, p) * (1 if pow(a, 5, 11) == 1 else -1)
                for a in range(1, 11)) % p
    inv2 = pow(2, p - 2, p)
    lam = (-1 + gauss) * inv2 % p
    lambar = (-1 - gauss) * inv2 % p
    ct = [contragredient(g, p) for g in gens]
    tr = [int(np.trace(g)) % p for g in gens]
    trc = [int(np.trace(g)) % p for g in ct]
    ok = (tr[0] == lam and trc[0] == lambar and trc[1] == tr[1] and trc[2] == tr[2])
    check("conjugate_convention" + tag, ok,
          "tr(rho)=%s tr(rho_bar)=%s lambda=%d lambdabar=%d" % (tr, trc, lam, lambar))
    print("  gauss=%d lambda=%d lambdabar=%d traces=%s conj-traces=%s"
          % (gauss, lam, lambar, tr, trc), flush=True)

    dims = {"map": [], "polar": [], "triv": {}}
    bases = {}
    for d in range(1, dmax + 1):
        for kind in ("map", "polar"):
            B = echelonize(covariant_space(gens, kind, d, p), p)
            dims[kind].append(len(B))
            bases["%s_%d" % (kind, d)] = B
            print("  d=%2d %-6s dim=%d   (%.1fs)" % (d, kind, len(B), time.time() - t0),
                  flush=True)
    for d in sorted(BANKED_TRIV):
        B = echelonize(covariant_space(gens, "triv", d, p), p)
        dims["triv"][d] = len(B)
        bases["triv_%d" % d] = B
        print("  d=%2d %-6s dim=%d" % (d, "triv", len(B)), flush=True)

    ok_map = dims["map"] == BANKED_MAP[:dmax]
    ok_pol = dims["polar"] == BANKED_POLAR[:dmax]
    ok_tri = all(dims["triv"][d] == BANKED_TRIV[d] for d in BANKED_TRIV)
    check("dims_match_banked" + tag, ok_map and ok_pol,
          "map=%s polar=%s" % (dims["map"], dims["polar"]))
    check("invariant_dims_match_banked" + tag, ok_tri,
          "triv=%s" % dims["triv"])

    with open(os.path.join(HERE, "payload", "cov_dims_p%d.json" % p), "w") as f:
        json.dump({"p": p, "map": dims["map"], "polar": dims["polar"],
                   "triv": {str(k): v for k, v in dims["triv"].items()},
                   "banked_map": BANKED_MAP[:dmax], "banked_polar": BANKED_POLAR[:dmax]},
                  f, indent=1)
    if save_bases:
        np.savez_compressed(os.path.join(HERE, "payload", "cov_bases_p%d.npz" % p),
                            **{k: v for k, v in bases.items()})
    print("  total %.1fs" % (time.time() - t0), flush=True)
    return dims, bases


if __name__ == "__main__":
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 397
    tag = sys.argv[2] if len(sys.argv) > 2 else ""
    run(p, tag)
