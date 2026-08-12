"""Integrality of the forced fibre traces — a GENUS-FREE consequence of L12.

The full twist family k = 0..10 inverts the Vandermonde (z^{-k a_j}) and gives

        tr_j  =  D^X_j * M(a_j)                                          (*)

with M(W) the tower's localization mass at the receiver point of weight W.
tr_j is the trace of g on the (finite-dimensional) cohomology of the derived
fibre, hence an ALGEBRAIC INTEGER of Z[zeta_11].  Since v_pi(D^X_j) = 3 and
every site term has v_pi = -4,

        v_pi(tr_j) >= 0   requires   R_{a_j} := res_pi(pi^4 M(a_j)) = 0,

i.e. exactly the leading-order condition of leading.py — but now with NO
genus-0 hypothesis.  Whatever the fibre genus, a tower with some R_V != 0 is
DEAD at map level for its class.

Deliverables here:
  I1  the mu = 0 branch at d in QR (no blowup over the C11 points) is dead
      for every QR residue: v_pi(tr_j) = -1.
  I2  at d = 35 every tower of blowup depth <= 3 has some R_V != 0.
  I3  the minimal blowup depth at which R == 0 becomes achievable at all
      (a lower bound on the depth of ANY resolution, per mu_1).
"""
import cyclo as C
import l12core as L
import towers as T
import genus0 as G
import leading as LD

N = 11
QRL = sorted(L.QR)


def R_vector(M):
    """(res_pi(pi^4 M(V)))_V in F_11."""
    return {V: C.res_pi(C.mul(LD.PI4, M[V])) for V in QRL}


def trace_valuations(M):
    out = {}
    for V in QRL:
        tr = C.mul(L.D_X(L.WEIGHT_INDEX[V]), M[V])
        x = C.mul(tr, C.prod([C.one_minus_zpow(1)] * 4))
        out[V] = C.val_pi(x) - 4
    return out


# ------------------------------------------------------- minimal-depth search
def psi_by_depth(root_state_sites, maxdepth=10):
    """Achievable Psi = sum_W r_W / W in F_11 as a function of the depth cap."""
    memo = {}

    def rec(site, budget):
        key = (LD.state(site), budget)
        if key in memo:
            return memo[key]
        if site.defined():
            r = frozenset({LD.rho(site) * pow(site.vw, N - 2, N) % N})
            memo[key] = r
            return r
        if site.kind == "comp" or budget <= 0:
            memo[key] = frozenset()
            return frozenset()
        acc = set()
        for mu in range(1, N):
            parts = [rec(k, budget - 1) for k in T.blowup(site, mu)]
            if any(not p for p in parts):
                continue
            cur = {0}
            for p in parts:
                cur = {(x + y) % N for x in cur for y in p}
            acc |= cur
        memo[key] = frozenset(acc)
        return memo[key]

    out = {}
    for dcap in range(0, maxdepth + 1):
        acc = {0}
        ok = True
        for s in root_state_sites:
            p = rec(s, dcap)
            if not p:
                ok = False
                break
            acc = {(x + y) % N for x in acc for y in p}
        out[dcap] = sorted(acc) if ok else None
    return out


def run(d=35, verbose=True):
    out = []
    info = {}

    def chk(name, ok, detail=""):
        out.append({"name": name, "ok": bool(ok), "detail": detail})
        if verbose:
            print(f"  [{'PASS' if ok else 'FAIL'}] {name}"
                  + (f"  ({detail})" if detail else ""))
        return ok

    # ---- I1 : mu = 0 branch at d in QR
    i1 = {}
    for r in QRL:
        M = {w: C.zero() for w in QRL}
        for k in range(5):
            M[(r * L.A[k]) % N] = C.add(M[(r * L.A[k]) % N], C.inv(L.D_P4(k)))
        vals = trace_valuations(M)
        i1[r] = vals
        chk(f"I1 d={r} mod 11 (QR), mu=0: forced tr_j has v_pi = -1 "
            f"(not an algebraic integer) -> branch DEAD",
            all(v == -1 for v in vals.values()), f"v={list(vals.values())}")
    info["I1"] = {str(k): v for k, v in i1.items()}

    # ---- I2 : d = 35, all towers of blowup depth <= 3
    per_mu = {}
    allbad = True
    for mu1 in range(1, N):
        vs, st = G.tower_over_e0(d, mu1, 2)
        nint = 0
        ngenus0 = 0
        for v in vs:
            M, _cnt = G.globalize(v)
            Rv = R_vector(M)
            if all(x == 0 for x in Rv.values()):
                nint += 1
            E, loc = G.residuals(M)
            if all(C.is_zero(E[k]) for k in (1, 2, 3)):
                ngenus0 += 1
        per_mu[mu1] = {"n_towers": len(vs), "n_integral": nint,
                       "n_genus0_pass": ngenus0, "status": st}
        allbad &= (nint == 0)
        chk(f"I2 mu1={mu1}: none of {len(vs)} depth<=3 towers has integral "
            f"fibre traces", nint == 0)
    info["I2"] = per_mu
    chk("I2 SUMMARY: every depth<=3 tower at d=35 is dead (genus-free)",
        allbad)

    # ---- I3 : minimal depth at which R == 0 is achievable
    root = T.Site("pt", L.tangent_P4(0), (d * L.A[0]) % N, ())
    mind = {}
    for mu1 in range(1, N):
        kids = T.blowup(root, mu1)
        for k in kids:
            LD._register(k)
        tab = psi_by_depth(kids, maxdepth=6)
        first = None
        for dc in sorted(tab):
            if tab[dc] and 0 in tab[dc]:
                first = dc
                break
        mind[mu1] = {"psi_by_depth": {str(k): v for k, v in tab.items()},
                     "min_extra_depth_for_R0": first}
        chk(f"I3 mu1={mu1}: R==0 first reachable at extra depth {first} "
            f"(total blowup depth {None if first is None else first + 1})",
            first is not None and first >= 2, f"first={first}")
    info["I3"] = mind

    return out, info


if __name__ == "__main__":
    res, info = run()
    nf = sum(1 for c in res if not c["ok"])
    print(f"integrality: {len(res) - nf}/{len(res)} pass")
