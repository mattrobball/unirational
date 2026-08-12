"""J1 re-derivation, in-packet and from scratch (STEIN_LERAY, Lane 2).

Fatal gate of the lane: the degrees carrying a G-invariant effective divisor on
the Klein cubic threefold X = {F = 0} subset P(W), G = PSL(2,11), are exactly
{k >= 5}; and the Molien anchors M_1 = 1, M_11 = 12, M_12 = 16, M_25 = 189,
M_34 = 576, M_35 = 637 must reproduce.

Nothing is imported from the scratch reference
tmp/scheme_map_20260812/molien_branch.py: that implementation uses sympy with a
power-sum recurrence over Q(sqrt(-11)); this one is a from-scratch integer
computation

  * PSL(2,11) built explicitly as permutations of P^1(F_11) (12 points),
    conjugacy classes / sizes / orders / power maps by brute force;
  * the C11 weight datum DERIVED from invariance of the Klein cubic;
  * the 5-dimensional character DERIVED by exhaustive search over eigenvalue
    multisets subject to det = 1, power-map coherence and the two orthogonality
    relations (uniqueness up to the Galois swap is part of the output);
  * Molien coefficients by exact convolution in Z[zeta_n] per class, summed in
    Z[zeta_330] and reduced modulo Phi_330.

No floats anywhere.  python3 standard library only.
"""

import json
import os
import sys
from itertools import combinations_with_replacement

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import cyclo  # noqa: E402

P = 11
KMAX = 46
NBIG = 330  # lcm of the element orders 1,2,3,5,6,11

OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "results")


# ---------------------------------------------------------------- the group

def psl211():
    """PSL(2,11) as permutations of P^1(F_11) = {0..10} u {inf=11}."""
    pts = list(range(12))

    def act(m, x):
        a, b, c, d = m
        if x == 11:
            num, den = a, c
        else:
            num, den = (a * x + b) % P, (c * x + d) % P
        if den % P == 0:
            return 11
        return (num * pow(den, P - 2, P)) % P

    seen = {}
    for a in range(P):
        for b in range(P):
            for c in range(P):
                for d in range(P):
                    if (a * d - b * c) % P != 1:
                        continue
                    perm = tuple(act((a, b, c, d), x) for x in pts)
                    seen[perm] = True
    return sorted(seen)


def compose(s, t):
    """(s*t)(x) = s(t(x))."""
    return tuple(s[t[x]] for x in range(len(t)))


def order_of(g):
    e = tuple(range(len(g)))
    h, n = g, 1
    while h != e:
        h = compose(g, h)
        n += 1
    return n


def build_group():
    els = psl211()
    idx = {g: i for i, g in enumerate(els)}
    n = len(els)
    orders = [order_of(g) for g in els]
    # conjugacy classes
    cls = [-1] * n
    classes = []
    for i, g in enumerate(els):
        if cls[i] != -1:
            continue
        c = len(classes)
        members = set()
        for h in els:
            hi = idx[h]
            # h g h^{-1}
            hinv = h
            k = 1
            while compose(hinv, h) != tuple(range(12)) and k < 100:
                hinv = compose(hinv, h)
                k += 1
            members.add(idx[compose(compose(h, g), hinv)])
        for m in members:
            cls[m] = c
        classes.append(sorted(members))
    return els, idx, orders, cls, classes


def build_group_fast():
    els = psl211()
    idx = {g: i for i, g in enumerate(els)}
    n = len(els)
    e = tuple(range(12))
    inv = [0] * n
    for i, g in enumerate(els):
        h = g
        while compose(g, h) != e:
            h = compose(g, h)
        inv[i] = idx[h]
    orders = [order_of(g) for g in els]
    cls = [-1] * n
    classes = []
    for i in range(n):
        if cls[i] != -1:
            continue
        c = len(classes)
        members = set()
        for j in range(n):
            members.add(idx[compose(compose(els[j], els[i]), els[inv[j]])])
        for m in members:
            cls[m] = c
        classes.append(sorted(members))
    return els, idx, inv, orders, cls, classes


# ------------------------------------------------- eigenvalue-multiset search

def multisets(nvals, size):
    return list(combinations_with_replacement(range(nvals), size))


def power_multiset(S, n, e):
    """Exponent multiset of g^e (in Z/n'), given that of g (in Z/n)."""
    T = sorted((x * e) % n for x in S)
    from math import gcd
    d = gcd(n, e) if e % n else n
    npr = n // d
    if npr == 1:
        return tuple([0] * len(S)), 1
    assert all(x % d == 0 for x in T), (S, n, e, T, d)
    return tuple(sorted((x // d) % npr for x in T)), npr


def chi_value(S, n, N=NBIG):
    """sum of zeta_n^e over the multiset S, as an element of Z[x]/(x^N-1)."""
    v = [0] * N
    s = N // n
    for e in S:
        v[(e * s) % N] += 1
    return v


def conj(v, N=NBIG):
    out = [0] * N
    for j, c in enumerate(v):
        if c:
            out[(-j) % N] += c
    return out


# ---------------------------------------------------------------- main

def main():
    els, idx, inv, orders, cls, classes = build_group_fast()
    n = len(els)
    assert n == 660, n
    csize = [len(c) for c in classes]
    corder = [orders[c[0]] for c in classes]
    # canonical ordering of classes by (order, size, index)
    order_pairs = sorted(range(len(classes)), key=lambda c: (corder[c], csize[c], c))
    log = {}
    log["group_order"] = n
    log["class_sizes"] = [csize[c] for c in order_pairs]
    log["class_orders"] = [corder[c] for c in order_pairs]
    assert sum(csize) == 660
    assert sorted(zip((corder[c] for c in order_pairs), (csize[c] for c in order_pairs))) == \
        [(1, 1), (2, 55), (3, 110), (5, 132), (5, 132), (6, 110), (11, 60), (11, 60)]

    # power map on classes: pw[c][e] = class of g^e for g in class c
    def cls_pow(c, e):
        g = els[classes[c][0]]
        h = tuple(range(12))
        for _ in range(e):
            h = compose(g, h)
        return cls[idx[h]]

    # ---- the C11 weight datum, derived from invariance of the Klein cubic
    # F = sum_i x_i^2 x_{i+1} (indices mod 5) is invariant under the diagonal
    # torus element x_i -> zeta^{b_i} x_i iff 2 b_i + b_{i+1} = 0 (mod 11) for
    # every i, i.e. b_{i+1} = -2 b_i, i.e. b_i = (-2)^i b_0.
    b = [pow(-2, i, P) for i in range(5)]
    assert (-2) ** 5 % P == 1, "the 5-periodicity that makes the datum consistent"
    QR = sorted({(x * x) % P for x in range(1, P)})
    log["klein_weights_b"] = b
    log["QR_mod_11"] = QR
    assert sorted(b) == QR, (b, QR)
    NQR = sorted(set(range(1, P)) - set(QR))
    log["NQR_mod_11"] = NQR

    # ---- derive the 5-dimensional character
    # candidate eigenvalue multisets per class: size 5, det 1, exact order,
    # power-map coherent, and satisfying <chi,chi> = 1 and <chi,1> = 0.
    cand = {}
    for c in range(len(classes)):
        m = corder[c]
        ok = []
        for S in multisets(m, 5):
            if sum(S) % m != 0:
                continue  # det = 1 (G perfect => G in SL(W))
            from math import gcd
            g = 0
            for e in S:
                g = gcd(g, e)
            g = gcd(g, m)
            if m // g != m:
                continue  # the element must act with exact order m
            ok.append(S)
        cand[c] = ok
    # power-map coherence
    def coherent(assign):
        for c, S in assign.items():
            m = corder[c]
            for e in range(2, m):
                T, npr = power_multiset(S, m, e)
                c2 = cls_pow(c, e)
                if c2 in assign:
                    if npr != corder[c2] and not (npr == 1 and corder[c2] == 1):
                        return False
                    if tuple(sorted(assign[c2])) != tuple(sorted(T)):
                        return False
        return True

    # The order-11 datum is DERIVED (F-invariance above), not searched: the
    # coordinates x_0..x_4 span W^* and carry the C11-weights b = QR.  Its
    # square lands in the other order-11 class (2 is a non-residue), which
    # therefore carries NQR.  Everything else is then searched.
    c11a = None
    for c in order_pairs:
        if corder[c] == 11:
            if c11a is None:
                c11a = c
    c11b = cls_pow(c11a, 2)
    assert corder[c11b] == 11 and c11b != c11a, "g^2 lies in the other 11-class"
    fixed11 = {c11a: tuple(sorted(b)), c11b: tuple(sorted((2 * x) % P for x in b))}
    assert sorted(fixed11[c11b]) == NQR, fixed11[c11b]
    # their exact contributions to the two orthogonality sums (rational)
    v11 = [chi_value(fixed11[c], P, P) for c in (c11a, c11b)]
    s1_11 = [0] * P
    s2_11 = [0] * P
    for c, v in zip((c11a, c11b), v11):
        cyclo.add_into(s1_11, v, csize[c])
        cyclo.add_into(s2_11, cyclo.mul(v, conj(v, P), P), csize[c])
    i1_11 = cyclo.to_int(s1_11, P)
    i2_11 = cyclo.to_int(s2_11, P)
    assert i1_11 is not None and i2_11 is not None, (i1_11, i2_11)
    log["order11_orthogonality_contributions"] = [i1_11, i2_11]

    # search the remaining classes: pick one class of order 5 (the other is the
    # class of its square) and the class of order 6 (which powers onto the
    # classes of order 3 and 2).
    ident = [c for c in range(len(classes)) if corder[c] == 1][0]
    c5a = min(c for c in range(len(classes)) if corder[c] == 5)
    c5b = cls_pow(c5a, 2)
    assert corder[c5b] == 5 and c5b != c5a, "g^2 lies in the other 5-class"
    c6 = [c for c in range(len(classes)) if corder[c] == 6][0]
    N30 = 30
    sols = []
    for S5 in cand[c5a]:
        T5, n5 = power_multiset(S5, 5, 2)
        if n5 != 5 or tuple(sorted(T5)) not in set(map(tuple, cand[c5b])):
            continue
        for S6 in cand[c6]:
            assign = {ident: (0, 0, 0, 0, 0), c5a: S5, c5b: T5, c6: S6}
            okd = True
            for e, tgt in ((2, 3), (3, 2)):
                T, npr = power_multiset(S6, 6, e)
                c2 = cls_pow(c6, e)
                if corder[c2] != tgt or npr != tgt:
                    okd = False
                    break
                assign[c2] = T
            if not okd or len(assign) != len(classes) - 2:
                continue
            full = dict(assign)
            full.update(fixed11)
            if not coherent(full):
                continue
            # orthogonality, exactly: the non-11 part in Z[zeta_30], the
            # 11-part already reduced to the integers above.
            s1 = [0] * N30
            s2 = [0] * N30
            for c, S in assign.items():
                v = chi_value(S, corder[c], N30)
                cyclo.add_into(s1, v, csize[c])
                cyclo.add_into(s2, cyclo.mul(v, conj(v, N30), N30), csize[c])
            i1 = cyclo.to_int(s1, N30)
            i2 = cyclo.to_int(s2, N30)
            if i1 is None or i2 is None:
                continue
            if i1 + i1_11 == 0 and i2 + i2_11 == 660:
                sols.append(full)
    log["n_character_solutions_given_derived_C11_datum"] = len(sols)
    assert len(sols) == 1, ("expected a unique completion", len(sols))
    chosen = sols[0]
    # record the character table row
    row = []
    for c in order_pairs:
        S = chosen[c]
        row.append({"order": corder[c], "size": csize[c], "eigen_exponents": list(S)})
    log["character_row"] = row
    # the two order-11 classes must carry QR and NQR respectively
    e11 = sorted([sorted(chosen[c]) for c in order_pairs if corder[c] == 11])
    assert e11 == sorted([QR, NQR]), e11

    # ---------------------------------------------------------- Molien
    # h_k(c) = chi_{Sym^k W^*}(c) as an element of Z[zeta_{order}]
    series = {}
    for c in range(len(classes)):
        m = corder[c]
        S = chosen[c]
        cur = [[0] * m for _ in range(KMAX + 1)]
        cur[0][0] = 1
        for e in S:
            nxt = [[0] * m for _ in range(KMAX + 1)]
            run = [0] * m
            for k in range(KMAX + 1):
                # run_k = zeta^e * run_{k-1} + cur_k
                new = [0] * m
                for j, x in enumerate(run):
                    if x:
                        new[(j + e) % m] += x
                for j, x in enumerate(cur[k]):
                    if x:
                        new[j] += x
                run = new
                nxt[k] = list(run)
            cur = nxt
        series[c] = cur

    # chi_{W^*}(c) and its complex conjugate = chi_W(c)
    chiW = {c: chi_value(chosen[c], corder[c]) for c in range(len(classes))}

    i_k, M_k = [], []
    for k in range(KMAX + 1):
        s_i = [0] * NBIG
        s_M = [0] * NBIG
        for c in range(len(classes)):
            h = cyclo.embed(series[c][k], corder[c], NBIG)
            cyclo.add_into(s_i, h, csize[c])
            w = conj(chiW[c], NBIG)  # chi_{W}(c) = conj chi_{W^*}(c)
            cyclo.add_into(s_M, cyclo.mul(h, w, NBIG), csize[c])
        vi = cyclo.to_int(s_i, NBIG)
        vM = cyclo.to_int(s_M, NBIG)
        assert vi is not None and vi % 660 == 0, (k, vi)
        assert vM is not None and vM % 660 == 0, (k, vM)
        i_k.append(vi // 660)
        M_k.append(vM // 660)

    a_k = [0] * (KMAX + 1)
    for k in range(KMAX + 1):
        a_k[k] = i_k[k] - (i_k[k - 3] if k >= 3 else 0)

    log["i_k"] = i_k
    log["a_k"] = a_k
    log["M_k"] = M_k

    # ---- the fatal anchors
    anchors = {1: 1, 11: 12, 12: 16, 25: 189, 34: 576, 35: 637}
    anchor_report = {}
    for k, v in anchors.items():
        anchor_report[str(k)] = {"expected": v, "got": M_k[k], "pass": M_k[k] == v}
    log["anchors_M"] = anchor_report
    assert all(r["pass"] for r in anchor_report.values()), anchor_report

    # ---- J1's statement
    log["a_k_zero_below_5"] = [a_k[k] for k in range(1, 5)]
    assert all(a_k[k] == 0 for k in range(1, 5)), a_k[:5]
    assert all(a_k[k] >= 1 for k in range(5, KMAX + 1)), \
        [(k, a_k[k]) for k in range(5, KMAX + 1) if a_k[k] < 1]
    log["J1_invariant_divisor_degrees"] = "exactly {k >= 5} on 1..%d" % KMAX
    log["i_3"] = i_k[3]
    assert i_k[3] == 1, "the invariant cubic F is unique up to scale"

    # ---- independent cross-check: the director probe E n [1,40] = {3} u [5,40]
    amb = sorted(k for k in range(1, 41) if i_k[k] > 0)
    log["ambient_invariant_degrees_1_40"] = amb
    log["probe_E_match"] = (amb == [3] + list(range(5, 41)))

    # ---- Proposition PIN (pinned-point vanishing), machine form.
    # x_j^k has C11-weight k*b_j with b_j != 0 (mod 11); a C11-invariant form of
    # degree k therefore has zero x_j^k coefficient unless 11 | k.  Same for the
    # four C5-fixed points of X, whose C5-weights are the nonzero residues.
    pin11 = {k: all((k * bj) % P != 0 for bj in b) for k in range(1, 61)}
    c5w = [1, 2, 3, 4]  # the on-X C5 eigenpoint weights (sealed; nonzero)
    pin5 = {k: all((k * w) % 5 != 0 for w in c5w) for k in range(1, 61)}
    log["forced_vanishing_at_C11_points_k_1_60"] = sorted(k for k, v in pin11.items() if v)
    log["forced_vanishing_at_C5_points_k_1_60"] = sorted(k for k, v in pin5.items() if v)
    log["escape_degrees_1_60"] = sorted(
        k for k in range(1, 61) if not pin11[k] and not pin5[k])
    log["min_escape_degree"] = min(
        [k for k in range(1, 1000) if k % 11 == 0 and k % 5 == 0])

    # degrees at which an invariant divisor may miss the C11 points (11 | k)
    # and at which one exists at all (a_k > 0)
    log["deg_11_divisible_with_invariants"] = [k for k in range(1, KMAX + 1)
                                               if k % 11 == 0 and a_k[k] > 0]
    log["deg_5_divisible_with_invariants"] = [k for k in range(1, KMAX + 1)
                                              if k % 5 == 0 and a_k[k] > 0]

    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "j1_molien.json"), "w") as f:
        json.dump(log, f, indent=1, sort_keys=True)
    print("class sizes :", log["class_sizes"])
    print("class orders:", log["class_orders"])
    print("character completions given the derived C11 datum (expect 1):", len(sols))
    print("i_k[0:16] :", i_k[:16])
    print("a_k[0:16] :", a_k[:16])
    print("M_k[0:16] :", M_k[:16])
    print("anchors    :", {k: (v["got"], v["pass"]) for k, v in anchor_report.items()})
    print("ambient invariant degrees in [1,40]:", amb)
    print("probe {3} u [5,40] match:", log["probe_E_match"])
    print("J1: a_k = 0 for k<5, a_k >= 1 for 5<=k<=%d : PASS" % KMAX)
    print("min degree of an invariant divisor missing every pinned point:",
          log["min_escape_degree"])
    print("J1_MOLIEN_OK")


if __name__ == "__main__":
    main()
