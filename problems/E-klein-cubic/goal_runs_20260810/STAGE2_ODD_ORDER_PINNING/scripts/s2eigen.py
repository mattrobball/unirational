"""Stage 2: the eigen-datum layer.

For each cyclic subgroup type C3, C5, C6, C11 (and the composite data at the
A4-points) produce, exactly over F_p:

  * the multiset of weights of a generator on W,
  * for each weight-eigenspace of dimension 1, whether the eigenpoint lies on X,
  * for each weight-eigenspace of dimension 2 (only C3), whether the eigenline
    lies in X and how many points of X it carries,
  * the normal weights at each 1-dimensional eigenspace,
  * the residual (normaliser/centraliser) permutation of the eigenpoints.

Everything is integer arithmetic in Z/n on the weight side and exact F_p
arithmetic on the vector side; no floating point anywhere.
"""
import json
import sys
from s2core import Model, QR11, normpt


def weights_of(m, A, n):
    eb = m.eigenbasis(A, n)
    return eb


def eigen_report(m):
    p = m.p
    rep = {"p": p}

    # ---------------- C11 ----------------
    T = m.T
    assert m.order[T] == 11
    eb11 = weights_of(m, T, 11)
    w11 = sorted(a for a, _ in eb11)
    rep["C11_weights"] = w11
    rep["C11_weights_are_QR"] = (set(w11) == set(QR11) and len(set(w11)) == 5)
    rep["C11_points_onX"] = {str(a): m.onX(v) for a, v in eb11}
    # normal weights at each eigenpoint
    rep["C11_normal_weights"] = {str(a): sorted((b - a) % 11 for b, _ in eb11 if b != a)
                                 for a, _ in eb11}
    # normaliser action: F55 = C11:C5
    N11 = m.normalizer_of_cyc(T)
    rep["C11_normaliser_order"] = len(N11)
    # the C5 acts on weights by multiplication by some u^{-1} in QR
    idx = {a: normpt(m, v) for a, v in eb11}
    perms = set()
    for C in N11:
        if m.order[C] != 5:
            continue
        pm = {}
        for a, v in eb11:
            w = normpt(m, m.act(C, v))
            tgt = [b for b, u in idx.items() if u == w]
            assert len(tgt) == 1
            pm[a] = tgt[0]
        # is it multiplication by a constant?
        cs = {(b * m_inv11(a)) % 11 for a, b in pm.items()}
        perms.add(tuple(sorted(pm.items())))
        rep.setdefault("C11_normaliser_mult_constants", []).append(sorted(cs))
    rep["C11_normaliser_is_multiplicative"] = all(
        len(c) == 1 for c in rep.get("C11_normaliser_mult_constants", []))

    # ---------------- C5 ----------------
    A5 = m.elt_of_order(5)
    eb5 = weights_of(m, A5, 5)
    w5 = sorted(a for a, _ in eb5)
    rep["C5_weights"] = w5
    rep["C5_weights_regular"] = (w5 == [0, 1, 2, 3, 4])
    rep["C5_points_onX"] = {str(a): m.onX(v) for a, v in eb5}
    rep["C5_normal_weights"] = {str(a): sorted((b - a) % 5 for b, _ in eb5 if b != a)
                                for a, _ in eb5}
    N5 = m.normalizer_of_cyc(A5)
    rep["C5_normaliser_order"] = len(N5)
    idx5 = {a: normpt(m, v) for a, v in eb5}
    consts = []
    for C in N5:
        if m.order[C] != 2:
            continue
        pm = {}
        ok = True
        for a, v in eb5:
            w = normpt(m, m.act(C, v))
            tgt = [b for b, u in idx5.items() if u == w]
            if len(tgt) != 1:
                ok = False
                break
            pm[a] = tgt[0]
        if ok:
            consts.append(sorted(pm.items()))
    rep["C5_involution_perms"] = consts
    rep["C5_involution_is_negation"] = all(
        all(b == (-a) % 5 for a, b in pm) for pm in consts) and len(consts) > 0
    # the weight-0 point is the D10 point: its stabiliser has order 10
    v0 = [v for a, v in eb5 if a == 0][0]
    rep["C5_weight0_stab_order"] = len(m.stab_point(v0))

    # ---------------- C6 / C3 ----------------
    A6 = m.elt_of_order(6)
    eb6 = weights_of(m, A6, 6)
    w6 = sorted(a for a, _ in eb6)
    rep["C6_weights"] = w6
    rep["C6_weights_are_01245"] = (w6 == [0, 1, 2, 4, 5])
    rep["C6_points_onX"] = {str(a): m.onX(v) for a, v in eb6}
    rep["C6_normal_weights"] = {str(a): sorted((b - a) % 6 for b, _ in eb6 if b != a)
                                for a, _ in eb6}
    # t = A6^3 eigenvalue on each: (-1)^a
    t = m.mm(m.mm(A6, A6), A6)
    assert m.order[t] == 2
    tw = {}
    for a, v in eb6:
        w = m.act(t, v)
        s = 1 if all((w[i] - v[i]) % p == 0 for i in range(5)) else (
            -1 if all((w[i] + v[i]) % p == 0 for i in range(5)) else 0)
        tw[str(a)] = s
    rep["C6_t_eigenvalues"] = tw

    A3 = m.mm(A6, A6)
    assert m.order[A3] == 3
    eb3 = weights_of(m, A3, 3)
    dims = {}
    for a, _ in eb3:
        dims[a] = dims.get(a, 0) + 1
    rep["C3_weight_multiplicities"] = {str(k): v for k, v in sorted(dims.items())}
    rep["C3_is_1_2_2"] = (sorted(dims.items()) == [(0, 1), (1, 2), (2, 2)])
    v3_0 = [v for a, v in eb3 if a == 0][0]
    rep["C3_weight0_onX"] = m.onX(v3_0)
    rep["C3_weight0_stab_order"] = len(m.stab_point(v3_0))
    # X-points on each eigenline, by brute force over P^1(F_p)
    lines = {}
    for a in (1, 2):
        B = [v for b, v in eb3 if b == a]
        assert len(B) == 2
        pts = []
        for s in range(p):
            v = tuple((B[0][i] + s * B[1][i]) % p for i in range(5))
            if m.onX(v):
                pts.append(("s", s))
        if m.onX(B[1]):
            pts.append(("inf", 0))
        lines[str(a)] = {"num_Fp_points_on_X": len(pts),
                         "line_inside_X": len(pts) == p + 1}
        # which of them are C6-eigenpoints
        c6pts = [b for b, v in eb6 if b % 3 == a]
        lines[str(a)]["C6_weights_on_this_line"] = sorted(c6pts)
        lines[str(a)]["C6_points_onX_here"] = sorted(
            b for b in c6pts if rep["C6_points_onX"][str(b)])
    rep["C3_eigenlines"] = lines

    # ---------------- A4 points ----------------
    # the A4-point data: 1-dim eigenspaces of an A4, their C3-weights, and the
    # C3-weights of the normal space.
    rep["A4"] = a4_report(m, A3)
    return rep


def m_inv11(a):
    return pow(a, 9, 11) if a % 11 else 0


def a4_report(m, A3):
    """Find an A4 containing <A3>; report the two A4-fixed points, their
    C3-weight and the C3-weights of the projective normal space."""
    p = m.p
    invols = [A for A in m.G if m.order[A] == 2]
    # V4 normalised by A3
    A3i = m.matinv(A3)
    v4 = None
    for a in invols:
        b = m.mm(m.mm(A3, a), A3i)
        c = m.mm(m.mm(A3, b), A3i)
        if b != a and m.mm(a, b) == m.mm(b, a) and m.mm(a, b) == c:
            v4 = (a, b, m.mm(a, b))
            break
    assert v4 is not None
    # W^{V4} = ell_V
    E = m.eigsp(v4[0], 1)
    rows = [list(x) for x in E]
    ell = m.nullspace([[0] * 5])  # placeholder
    # intersect +1 eigenspaces
    def inter(U, V):
        pu = m.nullspace([list(u) for u in U])
        pv = m.nullspace([list(v) for v in V])
        return m.nullspace([list(x) for x in pu] + [list(x) for x in pv])
    ell = inter(m.eigsp(v4[0], 1), m.eigsp(v4[1], 1))
    assert len(ell) == 2, len(ell)
    # A3-eigenvectors inside ell
    z3 = m.root(3)
    out = []
    for a in (1, 2):
        lam = pow(z3, a, p)
        rows = [[(A3[i][j] - (lam if i == j else 0)) % p for j in range(5)] for i in range(5)]
        Ea = m.nullspace(rows)
        # intersect with ell
        cand = inter(Ea, ell)
        assert len(cand) == 1, (a, len(cand))
        q = cand[0]
        st = m.stab_point(q)
        # C3-weights on the projective normal space N = Hom(<q>, W/<q>)
        eb3full = m.eigenbasis(A3, 3)
        wts = []
        for b, v in eb3full:
            wts.append(b)
        # remove one copy of weight a (that is q itself)
        wts.remove(a)
        nrm = sorted((b - a) % 3 for b in wts)
        out.append({"C3_weight_of_point": a,
                    "stab_order": len(st),
                    "onX": m.onX(q),
                    "normal_C3_weights": nrm})
    return out


def main():
    res = {}
    for p in (331, 661):
        m = Model(p)
        res[str(p)] = eigen_report(m)
        print(f"[p={p}] eigen report done")
    with open("results/eigen_data.json", "w") as f:
        json.dump(res, f, indent=1, sort_keys=True)
    print("S2_EIGEN_OK")


if __name__ == "__main__":
    main()
