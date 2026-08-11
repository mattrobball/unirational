"""STAGE1_STRATIFIED -- order-stratified degeneracy semantics (the repair).

Old path (STAGE1_TIGHTEN s3sat.contribution / s3sweep.explicit):
  rank of the evaluation of a BASIS of the whole module V(a,psi) at child q;
  rk==0 => child marked degenerate (free).

Corrected path (WORKORDER B, ODDZERO_AUDIT Prop B):
  for section s and child j, k_j(s) = ord along the attaching arc at q_j;
  value at level kappa = Lambda-eigenline of
      psi^{-1} * prod_r mu_{j,r}^{a_r} * chi_arc,j^{kappa}.
  Contribution of a class = value assignments over attainable joint level
  vectors kappa (child omitted when kappa_j = infinity).

Implementation
--------------
* Level-0 values come from explicit evaluation of the module (same as the old
  path) -- reliable and row-consistent.
* Level >=1 values come from the character rule with chi_arc^kappa, where
  chi_arc is the attaching-arc character (trivial-weight transverse direction
  in the attachment slot gives chi_arc = mu^{-1}; at order-2 characters this
  recovers Prop B(iii): chi_B^{a+k} mu_1).
* Attainable flip sets: the kids with period(chi_arc) > 1 are the "flippable"
  ones (six V4-children over a type-I plus-plane point on D_P -- ODDZERO).
  Every subset Z of them defines a linear vanishing condition; on the kernel
  those kids sit at level >=1 and the others keep their generic level.
* Whole-module rank-0 kids are at level >=1 for every section.
"""
import itertools
import sys

import paths  # noqa: F401
from s1coherence import nullspace, rank2, monomials, matmul_inv  # noqa: E402
from s3sweep import FullSweep  # noqa: E402
from s3sat import contribution as contribution_old  # noqa: E402


# ---------------------------------------------------------------------------
# Module basis
# ---------------------------------------------------------------------------
def module_basis(S, a, psi=None):
    p, m = S.p, S.m
    mons = [list(monomials(S.dims[i], a[i])) for i in range(S.nslot)]
    mon_basis, idx = [], {}
    for tup in itertools.product(*mons):
        for w in range(2):
            idx[(tup, w)] = len(mon_basis)
            mon_basis.append((tup, w))
    n = len(mon_basis)
    mats = {}
    for g in S.Gam:
        Minv = [matmul_inv(m, S.Mg[i][g]) for i in range(S.nslot)]
        A = [[0] * n for _ in range(n)]
        for col, (tup, w) in enumerate(mon_basis):
            poly = {(): 1}
            for i in range(S.nslot):
                dd = S.dims[i]
                cur = {tuple([0] * dd): 1}
                for jv in range(dd):
                    for _ in range(tup[i][jv]):
                        nw = {}
                        for mon, co in cur.items():
                            for l in range(dd):
                                c2 = Minv[i][jv][l]
                                if c2 % p == 0:
                                    continue
                                k = list(mon)
                                k[l] += 1
                                nw[tuple(k)] = (nw.get(tuple(k), 0) + co * c2) % p
                        cur = nw
                poly = {pm + (mon,): (poly[pm] * co) % p
                        for pm in poly for mon, co in cur.items()}
            for pm, pc in poly.items():
                for w2 in range(2):
                    c3 = S.Mw[g][w2][w] * pc % p
                    if c3:
                        A[idx[(pm, w2)]][col] = (A[idx[(pm, w2)]][col] + c3) % p
        mats[g] = A
    rows = []
    for g, M in mats.items():
        lam = 1 if psi is None else psi[g]
        for i in range(n):
            rows.append([(M[i][j] - (lam if i == j else 0)) % p
                         for j in range(n)])
    return mon_basis, nullspace(p, rows, n)


# ---------------------------------------------------------------------------
# Arc character (chi_arc)
# ---------------------------------------------------------------------------
def chi_arc_of(S, kid):
    """chi_arc dict and its period.

    Prefer transverse trivial-weight direction (ell_V); then chi_arc = mu^{-1}.
    """
    p, m = S.p, S.m
    Lam = kid["Lam"]
    chi = {h: 1 for h in Lam}
    if kid["mu"] is None or len(Lam) < 2:
        return chi, 1
    used = False
    for i in range(S.nslot):
        q = kid["qs"][i][0]
        d = len(q)
        if d <= 1:
            continue
        mu = kid["mu"][i]
        # common +1 eigenspace of Lam, transverse to q
        space = None
        for h0 in Lam:
            if h0 == m.Id:
                continue
            M = S.Mg[i][h0]
            rows = [[(M[x][y] - (1 if x == y else 0)) % p for y in range(d)]
                    for x in range(d)]
            ns = [v for v in nullspace(p, rows, d) if any(x % p for x in v)]
            j0 = next(t for t in range(d) if q[t] % p)
            ns = [v for v in ns
                  if any((v[t] * q[j0] - v[j0] * q[t]) % p for t in range(d))]
            if space is None:
                space = ns
            else:
                if not ns:
                    space = []
                    break
                new = []
                for v in space:
                    nns = len(ns)
                    R = [[ns[j][ii] for j in range(nns)] + [v[ii]]
                         for ii in range(d)]
                    rr = 0
                    for c in range(nns):
                        pr = next((ii for ii in range(rr, d) if R[ii][c] % p),
                                  None)
                        if pr is None:
                            continue
                        R[rr], R[pr] = R[pr], R[rr]
                        iv = pow(R[rr][c], p - 2, p)
                        R[rr] = [x * iv % p for x in R[rr]]
                        for ii in range(d):
                            if ii != rr and R[ii][c] % p:
                                f = R[ii][c]
                                R[ii] = [(x - f * y) % p
                                         for x, y in zip(R[ii], R[rr])]
                        rr += 1
                    good = True
                    for ii in range(d):
                        if (all(R[ii][c] % p == 0 for c in range(nns))
                                and R[ii][nns] % p):
                            good = False
                    if good:
                        new.append(v)
                space = new
        if space:
            for h in Lam:
                chi[h] = chi[h] * m.inv(mu[h]) % p
            used = True
            break
        # fallback: any transverse eigen-direction
        for h0 in Lam:
            if h0 == m.Id:
                continue
            M = S.Mg[i][h0]
            for lam in range(1, p):
                if pow(lam, m.order[h0], p) != 1:
                    continue
                rows = [[(M[x][y] - (lam if x == y else 0)) % p
                         for y in range(d)] for x in range(d)]
                for v in nullspace(p, rows, d):
                    if not any(x % p for x in v):
                        continue
                    j0 = next(t for t in range(d) if q[t] % p)
                    if all((v[t] * q[j0] - v[j0] * q[t]) % p == 0
                           for t in range(d)):
                        continue
                    nu = {}
                    ok = True
                    for h in Lam:
                        Mh = S.Mg[i][h]
                        img = [sum(Mh[aa][b] * v[b] for b in range(d)) % p
                               for aa in range(d)]
                        j1 = next(t for t in range(d) if v[t] % p)
                        nuv = img[j1] * m.inv(v[j1]) % p
                        if any((img[t] - nuv * v[t]) % p for t in range(d)):
                            ok = False
                            break
                        nu[h] = nuv
                    if not ok:
                        continue
                    for h in Lam:
                        chi[h] = chi[h] * nu[h] % p * m.inv(mu[h]) % p
                    used = True
                    break
                if used:
                    break
            if used:
                break
        if used:
            break
    per = 1
    for P in range(1, 13):
        if all(pow(chi[h], P, p) == 1 for h in chi):
            per = P
            break
    return chi, per


def value_at_level(S, a, kid, kappa, psi=None, chi_arc=None):
    p, m = S.p, S.m
    if kid["mu"] is None or len(kid["Lam"]) < 2:
        return None
    if chi_arc is None:
        chi_arc, _ = chi_arc_of(S, kid)
    target = {}
    for h in kid["Lam"]:
        v = 1 if psi is None else m.inv(psi[h])
        for i in range(S.nslot):
            v = v * pow(kid["mu"][i][h], a[i], p) % p
        if kappa:
            v = v * pow(chi_arc[h], kappa, p) % p
        target[h] = v
    for ch, U in kid["lines"]:
        if all(ch[h] == target[h] for h in kid["Lam"]):
            return U
    return None


# ---------------------------------------------------------------------------
# Vanishing forms and explicit level-0 pins
# ---------------------------------------------------------------------------
def vanishing_forms(S, mon_basis, V, kid):
    """independent linear forms on coeff space for s(q)=0."""
    p = S.p
    nV = len(V)
    q = [kid["qs"][i][0] for i in range(S.nslot)]
    evs = [S._eval(mon_basis, v, q) for v in V]
    forms = []
    for c in range(2):
        f = [evs[b][c] for b in range(nV)]
        if any(x % p for x in f):
            forms.append(f)
    if not forms:
        return []
    R = [list(f) for f in forms]
    rr = 0
    for c in range(nV):
        pr = next((i for i in range(rr, len(R)) if R[i][c] % p), None)
        if pr is None:
            continue
        R[rr], R[pr] = R[pr], R[rr]
        iv = pow(R[rr][c], p - 2, p)
        R[rr] = [x * iv % p for x in R[rr]]
        for i in range(len(R)):
            if i != rr and R[i][c] % p:
                fac = R[i][c]
                R[i] = [(x - fac * y) % p for x, y in zip(R[i], R[rr])]
        rr += 1
        if rr == len(R):
            break
    return [R[i] for i in range(rr)]


def kernel_of_forms(forms, nV, p):
    if not forms:
        return [[1 if i == j else 0 for i in range(nV)] for j in range(nV)]
    return nullspace(p, forms, nV)


def explicit_level0_pins(S, mon_basis, V, E, psi=None):
    """old-style pins: {row -> value} from rank-1 evaluations; omit rank 0."""
    p, m = S.p, S.m
    nV = len(V)
    out = {}
    for kid in S.kids:
        q = [kid["qs"][i][0] for i in range(S.nslot)]
        evs = [S._eval(mon_basis, v, q) for v in V]
        rk = rank2(p, evs)
        if rk == 0:
            continue
        if rk != 1:
            return None  # nonrigid
        w = next(v for v in evs if any(x % p for x in v))
        U = m.canon([list(tuple(
            sum(w[i] * S.Wm[i][c] for i in range(2)) % p for c in range(5)))])
        v = S.own_frame(kid, U)
        if v is None:
            return None
        r0 = kid["row"]
        if r0 in out and out[r0] != v:
            return None
        out[r0] = v
    return out


def subspace_vanishes_at(basis_rows, forms, nV, p):
    """True if every vector of the subspace is killed by every form."""
    if not forms:
        return True  # whole module already vanishes
    if not basis_rows:
        return True
    for row in basis_rows:
        for f in forms:
            if sum(f[b] * row[b] for b in range(nV)) % p:
                return False
    return True


# ---------------------------------------------------------------------------
# Main: attainable assignments
# ---------------------------------------------------------------------------
def attainable_value_assignments(S, a, E, psi=None):
    """set of attainable value-assignment tuples for class (a, psi)."""
    p = S.p
    mon_basis, V = module_basis(S, a, psi)
    nV = len(V)
    if nV == 0:
        return set()

    # per-kid metadata
    meta = []
    for kid in S.kids:
        chi, per = chi_arc_of(S, kid)
        forms = vanishing_forms(S, mon_basis, V, kid)
        meta.append(dict(
            kid=kid, row=kid["row"], chi_arc=chi, period=per,
            forms=forms, whole_vanishes=(len(forms) == 0),
        ))

    # baseline: explicit level-0 pins (old semantics for non-vanishing kids)
    base = explicit_level0_pins(S, mon_basis, V, E, psi)
    results = set()
    if base is not None:
        results.add(tuple(sorted(base.items())))

    # flippable kids: period > 1 (the six type-I-plus-plane V4 on D_P)
    flip_idx = [j for j, md in enumerate(meta) if md["period"] > 1]
    # also kids that whole-module-vanish: always at level >=1
    always_hi = [j for j, md in enumerate(meta) if md["whole_vanishes"]]

    def build_assignment(basis_rows, high_set):
        """level-0 explicit pins on non-high kids; character-rule level-1 on high."""
        # start from explicit pins on the SUBSPACE for non-high kids
        assign = {}
        # for non-high kids: evaluate subspace at q; need rank 1
        for j, md in enumerate(meta):
            kid = md["kid"]
            if j in high_set:
                continue
            if md["whole_vanishes"]:
                continue
            # evaluation of subspace
            q = [kid["qs"][i][0] for i in range(S.nslot)]
            evs = []
            for row in basis_rows:
                # section = sum row[b] V[b]
                w = [0, 0]
                for b, cb in enumerate(row):
                    if cb % p == 0:
                        continue
                    wb = S._eval(mon_basis, V[b], q)
                    w[0] = (w[0] + cb * wb[0]) % p
                    w[1] = (w[1] + cb * wb[1]) % p
                evs.append(w)
            rk = rank2(p, evs)
            if rk == 0:
                # this kid also vanishes on the subspace -- treat as high
                high_set = high_set | {j}
                continue
            if rk != 1:
                return None
            w0 = next(v for v in evs if any(x % p for x in v))
            U = S.m.canon([list(tuple(
                sum(w0[i] * S.Wm[i][c] for i in range(2)) % p
                for c in range(5)))])
            v = S.own_frame(kid, U)
            if v is None:
                return None
            r0 = kid["row"]
            if r0 in assign and assign[r0] != v:
                return None
            assign[r0] = v
        # high kids: character-rule level 1 (or period-reduced)
        for j in high_set:
            md = meta[j]
            kid = md["kid"]
            # use level = 1 mod period if period>1, else try level 1 then skip
            lev = 1 if md["period"] > 1 else 1
            U = value_at_level(S, a, kid, lev, psi, md["chi_arc"])
            if U is None:
                # free if no eigenline
                continue
            v = S.own_frame(kid, U)
            if v is None:
                continue
            r0 = kid["row"]
            if r0 in assign and assign[r0] != v:
                return None
            assign[r0] = v
        return assign

    # Enumerate flip subsets.  With nf <= 6 (ODDZERO's six special V4 kids)
    # a full 2^nf pass is fine; for larger nf (other rows) only do empty + all.
    nf = len(flip_idx)
    if nf <= 8:
        masks = range(1 << nf)
    else:
        masks = [0, (1 << nf) - 1]

    for mask in masks:
        Z = [flip_idx[b] for b in range(nf) if mask & (1 << b)]
        forms = []
        for j in Z:
            forms.extend(meta[j]["forms"])
        bas = kernel_of_forms(forms, nV, p)
        if not bas:
            continue
        high = set(Z) | set(always_hi)
        # promote kids that vanish on this subspace
        for j, md in enumerate(meta):
            if j in high:
                continue
            if subspace_vanishes_at(bas, md["forms"], nV, p):
                if md["period"] > 1 or md["whole_vanishes"]:
                    high.add(j)
        asn = build_assignment(bas, high)
        if asn is not None:
            results.add(tuple(sorted(asn.items())))

    return results


def contribution_stratified(S, a, E, psi=None):
    """usable (arc-consistent) assignments for class (a, psi)."""
    raw = attainable_value_assignments(S, a, E, psi=psi)
    out = []
    for items in raw:
        asn = dict(items)
        if any(v not in E.dom[r0] for r0, v in asn.items()):
            continue
        out.append(asn)
    return out


def contribution_stratified_any(S, a, E, psi=None):
    us = contribution_stratified(S, a, E, psi=psi)
    return us[0] if us else None
