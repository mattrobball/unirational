"""Stage 1: explicit G = PSL(2,11) subset GL5(F_p) preserving the Klein cubic."""
import json, sys, os
import numpy as np
from lib_xring import *

HERE = os.path.dirname(os.path.abspath(__file__))
EXP = (1, 9, 4, 3, 5)          # g11 = diag(zeta^e_i)


def build_generators(p, verbose=True, log=print):
    zeta = nth_root_unity(11, p)
    Z = [pow(zeta, k % 11, p) for k in range(11)]

    g11 = np.diag([Z[e] for e in EXP]).astype(np.int64)
    # s5: (sigma v)_i = v_{i+1 mod 5}  <->  substitution x_i -> x_{i+1}
    s5 = np.zeros((5, 5), dtype=np.int64)
    for i in range(5):
        s5[i, (i + 1) % 5] = 1

    rng = np.random.default_rng(20260806)
    V = rng.integers(1, p, size=(12, 5)).astype(np.int64)

    def preserves_F(M):
        lhs = F_eval((V @ M.T) % p, p)
        rhs = F_eval(V, p)
        cs = set()
        for a, b in zip(lhs, rhs):
            if b == 0:
                continue
            cs.add(int(a) * pow(int(b), p - 2, p) % p)
        return len(cs) == 1, (cs.pop() if len(cs) == 1 else None)

    ok11, c11 = preserves_F(g11)
    ok5, c5 = preserves_F(s5)

    # ---- search for the Weil involution in the antisymmetrised-Fourier family
    import itertools
    hits = []
    for bperm in itertools.permutations(range(1, 6)):
        for t in range(1, 6):
            K = np.array([[(Z[(t * bi * bj) % 11] - Z[(-t * bi * bj) % 11]) % p
                           for bj in bperm] for bi in bperm], dtype=np.int64)
            if det_mod(K, p) == 0:
                continue
            for sgn in itertools.product((1, -1), repeat=5):
                s = np.array(sgn, dtype=np.int64)
                M = (K * np.outer(s, s)) % p
                ok, c = preserves_F(M)
                if ok:
                    hits.append((bperm, t, tuple(sgn), int(c)))
    if verbose:
        log("  S-family hits: %d" % len(hits))

    # pick a canonical hit; verify M^2 is scalar, then normalise to S^2=I, det=1
    S = None
    recipe = None
    for (bperm, t, sgn, c) in hits:
        K = np.array([[(Z[(t * bi * bj) % 11] - Z[(-t * bi * bj) % 11]) % p
                       for bj in bperm] for bi in bperm], dtype=np.int64)
        s = np.array(sgn, dtype=np.int64)
        M = (K * np.outer(s, s)) % p
        M2 = mmul(M, M, p)
        lam = int(M2[0, 0])
        if not np.array_equal(M2, (lam * np.eye(5, dtype=np.int64)) % p):
            continue
        r = sqrt_mod(lam, p)
        if r is None:
            continue
        Sn = (M * pow(r, p - 2, p)) % p          # Sn^2 = I
        if det_mod(Sn, p) != 1:
            Sn = (-Sn) % p                        # (-1)^5 * det = 1, still an involution
        if det_mod(Sn, p) != 1:
            continue
        S = Sn
        recipe = dict(b=list(bperm), t=t, signs=list(sgn), scalar_c=int(c),
                      M2_scalar=lam, sqrt=int(r),
                      negated=bool(not np.array_equal(Sn, (M * pow(r, p - 2, p)) % p)))
        break
    return dict(zeta=zeta, g11=g11, s5=s5, S=S, recipe=recipe,
                ok11=ok11, c11=c11, ok5=ok5, c5=c5, hits=hits,
                preserves_F=preserves_F)


def canon(M, p):
    flat = M.reshape(-1)
    nz = np.nonzero(flat)[0][0]
    inv = pow(int(flat[nz]), p - 2, p)
    return tuple(int(x) for x in (flat * inv) % p)


def bfs_projective(gens, p, cap=1000):
    seen = {}
    start = np.eye(5, dtype=np.int64)
    seen[canon(start, p)] = start
    frontier = [start]
    while frontier:
        nxt = []
        for M in frontier:
            for g in gens:
                N = mmul(M, g, p)
                k = canon(N, p)
                if k not in seen:
                    seen[k] = N
                    nxt.append(N)
                    if len(seen) > cap:
                        return seen, False
        frontier = nxt
    return seen, True


def bfs_linear(gens, p, cap=5000):
    seen = {}
    start = np.eye(5, dtype=np.int64)
    seen[tuple(int(x) for x in start.reshape(-1))] = start
    frontier = [start]
    while frontier:
        nxt = []
        for M in frontier:
            for g in gens:
                N = mmul(M, g, p)
                k = tuple(int(x) for x in N.reshape(-1))
                if k not in seen:
                    seen[k] = N
                    nxt.append(N)
                    if len(seen) > cap:
                        return seen, False
        frontier = nxt
    return seen, True


def elt_order(M, p, cap=100):
    N = M.copy()
    I = np.eye(5, dtype=np.int64)
    for k in range(1, cap + 1):
        if np.array_equal(N, I):
            return k
        N = mmul(N, M, p)
    return None


def run(p, tag, do_checks=True):
    log = lambda *a: print(*a, flush=True)
    log("=== Stage 1, p=%d ===" % p)
    B = build_generators(p, log=log)
    g11, s5, S = B["g11"], B["s5"], B["S"]
    if do_checks:
        check("g11_preserves_F" + tag, B["ok11"], "scalar=%s" % B["c11"])
        check("s5_preserves_F" + tag, B["ok5"], "scalar=%s" % B["c5"])
        check("S_matrix_found" + tag, S is not None,
              json.dumps(B["recipe"]) if B["recipe"] else "no candidate")
    if S is None:
        raise SystemExit("no S found at p=%d" % p)
    log("  recipe: %s" % json.dumps(B["recipe"]))
    okS, cS = B["preserves_F"](S)
    if do_checks:
        check("S_preserves_F" + tag, okS, "scalar=%s" % cS)
    dets = [det_mod(M, p) for M in (g11, s5, S)]
    orders = [elt_order(M, p) for M in (g11, s5, S)]
    log("  dets(g11,s5,S) = %s ; orders = %s" % (dets, orders))
    if do_checks:
        check("generators_in_SL5" + tag, all(d == 1 for d in dets),
              "dets=%s orders=%s" % (dets, orders))

    proj, done = bfs_projective([g11, s5, S], p, cap=1000)
    log("  projective closure: %d (terminated=%s)" % (len(proj), done))
    if do_checks:
        check("group_order_660" + tag, done and len(proj) == 660,
              "|G_proj|=%d" % len(proj))

    lin, ldone = bfs_linear([g11, s5, S], p, cap=5000)
    log("  linear closure: %d (terminated=%s)" % (len(lin), ldone))
    if do_checks:
        check("linear_group_660" + tag, ldone and len(lin) == 660,
              "|G_lin|=%d" % len(lin))

    mats = list(lin.values())
    ords = [elt_order(M, p) for M in mats]
    from collections import Counter
    log("  order profile: %s" % dict(Counter(ords)))

    # triple (2,3,11)
    o2 = [M for M, o in zip(mats, ords) if o == 2]
    o3 = [M for M, o in zip(mats, ords) if o == 3]
    found = None
    for A in o2:
        for Bm in o3:
            if elt_order(mmul(A, Bm, p), p) == 11:
                found = (A, Bm)
                break
        if found:
            break
    if do_checks:
        check("triple_2_3_11" + tag, found is not None,
              "orders present: %s" % sorted(set(ords)))

    payload = dict(p=int(p), zeta=int(B["zeta"]), recipe=B["recipe"],
                   generators=dict(g11=g11.tolist(), s5=s5.tolist(), S=S.tolist()),
                   order_profile={str(k): v for k, v in Counter(ords).items()},
                   projective_order=len(proj), linear_order=len(lin),
                   matrices=[M.tolist() for M in mats])
    if found is not None:
        payload["triple"] = dict(a2=found[0].tolist(), b3=found[1].tolist(),
                                 ab=mmul(found[0], found[1], p).tolist())
    out = os.path.join(HERE, "payload", "G660_p%d.json" % p)
    with open(out, "w") as f:
        json.dump(payload, f)
    log("  wrote %s" % out)
    return payload


if __name__ == "__main__":
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 397
    tag = sys.argv[2] if len(sys.argv) > 2 else ""
    run(p, tag)
