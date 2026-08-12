"""Depth-INDEPENDENT leading-order (mod pi) form of the genus-0 closed test.

Every localization site z in a 4-fold tower has v_pi(AB(z)) = -4 (isolated
points AND the positive-dimensional components alike, machine-checked), so

        rho(z) := res_pi( pi^4 * AB(z) )  in  F_11

is defined, and the exact blowup mass identity forces
        sum_{children} rho = rho(parent)          (rho is CONSERVED).

The genus-0 branch demands M(W) = 1/D^X_{j(W)}, whose pi-valuation is -3.
Multiplying by pi^4 and reducing kills the right side, so a NECESSARY
condition is, for every receiver weight V,

        R_V := sum over all sites with value V of rho  ==  0   in F_11.

Transport by N_G(C11): the tower over the weight-s point is the s-multiple of
the tower over e_0, and rho scales by s^{-4} = s (s^5 = 1 on QR).  Hence
R_V = sum_{s in QR} s * r_{V/s} with r_W the value-graded rho over e_0.
This is a convolution on QR = Z/5 by c_m = 3^m, whose only nonvanishing
Fourier coefficient is at the character 3^m -> 3^{-m}.  Therefore

    (R_V = 0 for all V)   <==>   Psi := sum_{W in QR} r_W * W^{-1} == 0 (F_11).

Psi ranges over a FINITE set computed by a fixed-point iteration over the
(finite) set of tower states, so the verdict holds at EVERY depth.
"""
import cyclo as C
import l12core as L
import towers as T

N = 11
QRL = sorted(L.QR)
PI4 = C.prod([C.one_minus_zpow(1)] * 4)


def rho(site):
    return C.res_pi(C.mul(PI4, site.term()))


def state(site):
    if site.kind == "pt":
        return ("pt", tuple(sorted(site.data)), site.vw)
    return ("comp", tuple(sorted(site.data[0])), site.data[1], site.vw)


_SITE_OF = {}


def _register(site):
    st = state(site)
    _SITE_OF.setdefault(st, site)
    return st


def psi_sets(root_states, max_iter=200):
    """Fixed-point iteration: for each undefined state, the set of achievable
    values of  sum_{terminal z in the sub-tower} rho(z) / value(z)  in F_11."""
    # explore the reachable state graph
    states = {}
    frontier = list(root_states)
    while frontier:
        st = frontier.pop()
        if st in states:
            continue
        site = _SITE_OF[st]
        if site.defined():
            states[st] = ("terminal", rho(site) * pow(site.vw, N - 2, N) % N)
            continue
        if site.kind == "comp":
            states[st] = ("blocked", None)
            continue
        trans = []
        for mu in range(1, N):
            kids = T.blowup(site, mu)
            ks = [_register(k) for k in kids]
            trans.append(ks)
            for k in ks:
                if k not in states:
                    frontier.append(k)
        states[st] = ("branch", trans)

    S = {st: (frozenset({v}) if kind == "terminal" else frozenset())
         for st, (kind, v) in states.items()}
    for _ in range(max_iter):
        changed = False
        for st, (kind, data) in states.items():
            if kind != "branch":
                continue
            acc = set(S[st])
            for ks in data:
                parts = [S[k] for k in ks]
                if any(not p for p in parts):
                    continue
                cur = {0}
                for p in parts:
                    cur = {(x + y) % N for x in cur for y in p}
                acc |= cur
            if acc != S[st]:
                S[st] = frozenset(acc)
                changed = True
        if not changed:
            break
    else:
        raise RuntimeError("psi fixed point did not converge")
    return S, states


def run(d=35, verbose=True):
    out = []

    def chk(name, ok, detail=""):
        out.append({"name": name, "ok": bool(ok), "detail": detail})
        if verbose:
            print(f"  [{'PASS' if ok else 'FAIL'}] {name}"
                  + (f"  ({detail})" if detail else ""))
        return ok

    root = T.Site("pt", L.tangent_P4(0), (d * L.A[0]) % N, ())
    chk("LO rho(root over e_0) = 9", rho(root) == 9, f"rho={rho(root)}")

    # conservation spot-check
    ok = True
    for mu in range(0, N):
        kids = T.blowup(root, mu)
        ok &= (sum(rho(k) for k in kids) % N == rho(root))
        for kd in kids:
            if kd.kind != "pt":
                continue
            for mu2 in range(0, N):
                g = T.blowup(kd, mu2)
                ok &= (sum(rho(x) for x in g) % N == rho(kd))
    chk("LO rho is conserved under blowup (2 levels, all mu)", ok)

    per_mu = {}
    for mu1 in range(1, N):
        kids = T.blowup(root, mu1)
        rs = [_register(k) for k in kids]
        S, states = psi_sets(rs)
        parts = [S[r] for r in rs]
        if any(not p for p in parts):
            per_mu[mu1] = {"psi": [], "note": "some branch never closes"}
            continue
        cur = {0}
        for p in parts:
            cur = {(x + y) % N for x in cur for y in p}
        per_mu[mu1] = {"psi": sorted(cur),
                       "genus0_possible": 0 in cur}
        chk(f"LO mu1={mu1}: Psi never 0 (genus-0 branch dead at ALL depths)",
            0 not in cur, f"Psi in {sorted(cur)}")
    return out, per_mu


if __name__ == "__main__":
    res, per = run()
    nf = sum(1 for c in res if not c["ok"])
    print(f"leading-order: {len(res) - nf}/{len(res)} pass")
    for mu, v in sorted(per.items()):
        print(mu, v)
