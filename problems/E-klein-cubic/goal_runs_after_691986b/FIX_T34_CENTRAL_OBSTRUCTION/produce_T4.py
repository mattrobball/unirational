#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
FIX-T34, CASE T4 -- PRODUCER.

Target: the Fermat cubic threefold  X : x1^3 + ... + x5^3 = 0  in P^4.

Aut(X) = Lin(X) = (mu_3^5/mu_3) : S_5, of order 3^4 * 120 = 9720 (classical:
every automorphism of a smooth cubic threefold is linear, and the linear
automorphisms of a Fermat hypersurface of degree d in P^n form
mu_d^{n+1}/mu_d : S_{n+1}).

Encoding: an element is (e, sigma) with e in (Z/3)^5 normalised by e[0] = 0
and sigma in S_5, acting by  (g.x)_i = zeta_3^{e_i} x_{sigma^{-1}(i)};
equivalently the matrix M has M[sigma(j)][j] = zeta_3^{e_{sigma(j)}}.
Every such matrix satisfies C(Mx) = C(x) for the Fermat cubic C, exactly.

Task: classify all subgroups G isomorphic to C9 : C3 (the modular group M27
of order 27 and exponent 9, i.e. <a,b | a^9 = b^3 = 1, bab^{-1} = a^4>) up to
conjugacy, and for each decide

  (a) every positive-dimensional component of X^z has genus >= 1, for the
      central z (Z(G) = <a^3> has order 3);
  (b) X^G = empty.

Exact arithmetic in Q(zeta_9) = Q[t]/(t^6 + t^3 + 1); all matrix entries are
in mu_3 = <zeta_9^3> and all eigenvalues of elements of such a G are in mu_9
(permutation parts inside M27 are 3-cycles or the identity).

Outputs T4_payload.json.
"""

import json
import os
from fractions import Fraction as Fr
from itertools import permutations

HERE = os.path.dirname(os.path.abspath(__file__))
N5 = 5

# ----------------------------------------------------------------------
# 1. Exact arithmetic in Q(zeta_9) = Q[t]/(t^6 + t^3 + 1)
# ----------------------------------------------------------------------
D = 6
FZERO = (Fr(0),) * D
FONE = (Fr(1),) + (Fr(0),) * (D - 1)


def fadd(a, b):
    return tuple(x + y for x, y in zip(a, b))


def fsub(a, b):
    return tuple(x - y for x, y in zip(a, b))


def fneg(a):
    return tuple(-x for x in a)


def fmul(a, b):
    c = [Fr(0)] * (2 * D - 1)
    for i in range(D):
        if a[i]:
            ai = a[i]
            for j in range(D):
                if b[j]:
                    c[i + j] += ai * b[j]
    # t^6 = -t^3 - 1  =>  t^k = -t^{k-3} - t^{k-6}
    for k in range(2 * D - 2, D - 1, -1):
        ck = c[k]
        if ck:
            c[k - 3] -= ck
            c[k - 6] -= ck
            c[k] = Fr(0)
    return tuple(c[:D])


def fiszero(a):
    return all(x == 0 for x in a)


def finv(a):
    assert not fiszero(a)
    cols = []
    for j in range(D):
        e = [Fr(0)] * D
        e[j] = Fr(1)
        cols.append(fmul(a, tuple(e)))
    M = [[cols[j][i] for j in range(D)] for i in range(D)]
    rhs = [Fr(1)] + [Fr(0)] * (D - 1)
    for col in range(D):
        piv = next(r for r in range(col, D) if M[r][col] != 0)
        M[col], M[piv] = M[piv], M[col]
        rhs[col], rhs[piv] = rhs[piv], rhs[col]
        pv = M[col][col]
        M[col] = [v / pv for v in M[col]]
        rhs[col] /= pv
        for r in range(D):
            if r != col and M[r][col] != 0:
                f = M[r][col]
                M[r] = [u - f * v for u, v in zip(M[r], M[col])]
                rhs[r] -= f * rhs[col]
    return tuple(rhs)


_T = tuple([Fr(0), Fr(1)] + [Fr(0)] * (D - 2))
_ZP = [FONE]
for _k in range(1, 9):
    _ZP.append(fmul(_ZP[-1], _T))


def zeta(k):
    """zeta_9^k."""
    return _ZP[k % 9]


assert fmul(zeta(3), fmul(zeta(3), zeta(3))) == FONE
assert zeta(3) != FONE


# ----------------------------------------------------------------------
# 2. Linear algebra over Q(zeta_9) in K^5
# ----------------------------------------------------------------------
def rref(rows, ncols):
    rows = [list(r) for r in rows]
    piv, r = [], 0
    for c in range(ncols):
        pr = None
        for k in range(r, len(rows)):
            if not fiszero(rows[k][c]):
                pr = k
                break
        if pr is None:
            continue
        rows[r], rows[pr] = rows[pr], rows[r]
        iv = finv(rows[r][c])
        rows[r] = [fmul(iv, v) for v in rows[r]]
        for k in range(len(rows)):
            if k != r and not fiszero(rows[k][c]):
                f = rows[k][c]
                rows[k] = [fsub(u, fmul(f, v)) for u, v in zip(rows[k], rows[r])]
        piv.append(c)
        r += 1
        if r == len(rows):
            break
    rows = [row for row in rows if any(not fiszero(v) for v in row)]
    return rows, piv


def nullspace(rows, ncols):
    R, piv = rref(rows, ncols)
    free = [c for c in range(ncols) if c not in piv]
    out = []
    for fc in free:
        v = [FZERO] * ncols
        v[fc] = FONE
        for i, pc in enumerate(piv):
            v[pc] = fneg(R[i][fc])
        out.append(tuple(v))
    return out


def intersect(U, V):
    if not U or not V:
        return []
    p, q = len(U), len(V)
    rows = []
    for i in range(N5):
        rows.append([U[j][i] for j in range(p)] + [fneg(V[j][i]) for j in range(q)])
    ker = nullspace(rows, p + q)
    out = []
    for k in ker:
        vec = [FZERO] * N5
        for j in range(p):
            for i in range(N5):
                vec[i] = fadd(vec[i], fmul(k[j], U[j][i]))
        if any(not fiszero(c) for c in vec):
            out.append(tuple(vec))
    R, _ = rref(out, N5) if out else ([], [])
    return [tuple(r) for r in R]


# ----------------------------------------------------------------------
# 3. The group Aut(X)
# ----------------------------------------------------------------------
def canon(e, s):
    k = e[0] % 3
    return (tuple((x - k) % 3 for x in e), tuple(s))


def gmul(g, h):
    e, s = g
    f, t = h
    si = [0] * N5
    for j in range(N5):
        si[s[j]] = j
    ne = tuple((e[i] + f[si[i]]) % 3 for i in range(N5))
    ns = tuple(s[t[j]] for j in range(N5))
    return canon(ne, ns)


def ginv(g):
    e, s = g
    si = [0] * N5
    for j in range(N5):
        si[s[j]] = j
    si = tuple(si)
    ne = tuple((-e[s[i]]) % 3 for i in range(N5))
    return canon(ne, si)


ID = canon((0,) * N5, tuple(range(N5)))


def gorder(g):
    k, x = 1, g
    while x != ID:
        x = gmul(x, g)
        k += 1
    return k


def matrix_of(g):
    """5x5 matrix over Q(zeta_9); M[sigma(j)][j] = zeta_3^{e_{sigma(j)}}."""
    e, s = g
    M = [[FZERO] * N5 for _ in range(N5)]
    for j in range(N5):
        M[s[j]][j] = zeta(3 * e[s[j]])
    return M


def apply_mat(M, v):
    out = []
    for i in range(N5):
        acc = FZERO
        for j in range(N5):
            if not fiszero(M[i][j]) and not fiszero(v[j]):
                acc = fadd(acc, fmul(M[i][j], v[j]))
        out.append(acc)
    return tuple(out)


GENS = [canon((0, 1, 0, 0, 0), tuple(range(N5))),          # diag(1,z,1,1,1)
        canon((0,) * N5, (1, 0, 2, 3, 4)),                  # (12)
        canon((0,) * N5, (1, 2, 3, 4, 0))]                  # (12345)


def closure(gens, mul=gmul, ident=ID):
    S = {ident}
    fr = [ident]
    while fr:
        x = fr.pop()
        for g in gens:
            y = mul(x, g)
            if y not in S:
                S.add(y)
                fr.append(y)
    return S


ALL = closure(GENS)
assert len(ALL) == 9720, len(ALL)
ALL = sorted(ALL)


def conjugate(x, c):
    return gmul(gmul(ginv(c), x), c)


# ----------------------------------------------------------------------
# 4. Eigen-decomposition and fixed loci
# ----------------------------------------------------------------------
def cycles_of(s):
    seen, out = set(), []
    for j in range(N5):
        if j in seen:
            continue
        cyc = [j]
        seen.add(j)
        k = s[j]
        while k != j:
            cyc.append(k)
            seen.add(k)
            k = s[k]
        out.append(cyc)
    return out


def eigendata(g):
    """{u : [eigenvectors]} with eigenvalue zeta_9^u.  Only defined when all
    cycles have length 1 or 3 (true inside any C9:C3)."""
    e, s = g
    a = [3 * e[s[j]] % 9 for j in range(N5)]     # column entries as zeta_9 exponents
    out = {}
    for cyc in cycles_of(s):
        k = len(cyc)
        assert k in (1, 3), "unexpected cycle length %d" % k
        c = sum(a[j] for j in cyc) % 9
        for u in range(9):
            if (u * k - c) % 9 != 0:
                continue
            v = [FZERO] * N5
            ex = 0
            for m in range(k):
                j = cyc[m]
                v[j] = zeta(ex)
                ex = (ex + a[j] - u) % 9
            assert ex % 9 == 0
            out.setdefault(u, []).append(tuple(v))
    assert sum(len(v) for v in out.values()) == N5
    M = matrix_of(g)
    for u, vs in out.items():
        for v in vs:
            assert apply_mat(M, v) == tuple(fmul(zeta(u), c) for c in v)
    return out


def _pw(a, k):
    r = FONE
    for _ in range(k):
        r = fmul(r, a)
    return r


def cubic_val(v):
    tot = FZERO
    for c in v:
        tot = fadd(tot, fmul(c, fmul(c, c)))
    return tot


def fixed_locus_diagonal(g):
    """X^g for a *diagonal* g (sigma = id): a disjoint union of Fermat cubics
    in the coordinate eigen-subspaces.  Returns the component list."""
    e, s = g
    assert s == tuple(range(N5))
    blocks = {}
    for i in range(N5):
        blocks.setdefault(e[i] % 3, []).append(i + 1)
    comps = []
    for val, coords in sorted(blocks.items()):
        d = len(coords)
        if d == 1:
            comps.append({"eigenvalue": "zeta_3^%d" % val, "linear_space": "point %s" % coords,
                          "dim_linear": 0, "X_cap": "empty (x^3 = 0 has no projective solution)",
                          "dim": -1, "npoints": 0})
        elif d == 2:
            comps.append({"eigenvalue": "zeta_3^%d" % val,
                          "linear_space": "P^1 spanned by coordinates %s" % coords,
                          "dim_linear": 1,
                          "X_cap": "x_%d^3 + x_%d^3 = 0 : 3 distinct points" % tuple(coords),
                          "dim": 0, "npoints": 3})
        else:
            comps.append({"eigenvalue": "zeta_3^%d" % val,
                          "linear_space": "P^%d spanned by coordinates %s" % (d - 1, coords),
                          "dim_linear": d - 1,
                          "X_cap": "Fermat cubic %s = 0 in P^%d"
                                   % (" + ".join("x_%d^3" % c for c in coords), d - 1),
                          "dim": d - 2,
                          "genus": 1 if d == 3 else None,
                          "smooth": True})
    return comps


def hyp_a_diag(comps):
    """(a): every positive-dimensional component of X^z has genus >= 1.
    For diagonal z the components are Fermat cubics in coordinate subspaces:
    dimension 0 (3 points on a line), dimension 1 (smooth plane cubic, genus 1),
    dimension >= 2 (a cubic surface or threefold -- rational, would fail)."""
    for c in comps:
        if c["dim"] >= 2:
            return False
        if c["dim"] == 1 and c.get("genus") != 1:
            return False
    return True


def joint_eigenspaces(H, gens):
    cur = None
    for g in gens:
        ed = eigendata(g)
        pieces = [([tuple(v) for v in vs], {g: u}) for u, vs in ed.items()]
        if cur is None:
            cur = [(list(B), dict(lab)) for B, lab in pieces]
        else:
            nxt = []
            for B, lab in cur:
                for B2, lab2 in pieces:
                    W = intersect(B, B2)
                    if W:
                        d = dict(lab)
                        d.update(lab2)
                        nxt.append((W, d))
            cur = nxt
    return cur


def fixed_points_of_group(H, gens):
    """Description of X^H; empty list means X^H = empty."""
    out = []
    for B, lab in joint_eigenspaces(H, gens):
        dimW = len(B)
        # sanity: the whole group acts by scalars on B
        for h in H:
            M = matrix_of(h)
            v = B[0]
            piv = next(i for i in range(N5) if not fiszero(v[i]))
            lam = fmul(apply_mat(M, v)[piv], finv(v[piv]))
            for b in B:
                assert apply_mat(M, b) == tuple(fmul(lam, c) for c in b)
        if dimW >= 2:
            rec = {"dimW": dimW,
                   "note": "P(W) has dimension >= 1 and therefore meets the cubic X",
                   "W_basis": [vec_str(b) for b in B]}
            if dimW == 2:
                # explicit: restrict the cubic to the line s*B0 + t*B1
                from math import comb
                co = [FZERO] * 4
                for i in range(N5):
                    for m in range(4):
                        term = tuple(Fr(comb(3, m)) * x for x in
                                     fmul(_pw(B[0][i], 3 - m), _pw(B[1][i], m)))
                        co[m] = fadd(co[m], term)
                pts = []
                for sgn in (1, -1):    # roots live in mu_18 = <-1, mu_9>
                    for k in range(9):
                        t = zeta(k) if sgn == 1 else fneg(zeta(k))
                        val, tp = FZERO, FONE
                        for m in range(4):
                            val = fadd(val, fmul(co[m], tp))
                            tp = fmul(tp, t)
                        if fiszero(val):
                            pts.append("[s:t] = [1:%sz9^%d]" % ("" if sgn == 1 else "-", k))
                rec["cubic_on_line"] = [vec_str([c]) for c in co]
                rec["some_points_of_X_cap_P(W)"] = pts
            out.append(rec)
        else:
            if fiszero(cubic_val(B[0])):
                out.append({"dimW": 1, "note": "the G-fixed point of P^4 lies on X",
                            "point": vec_str(B[0])})
    return out


def vec_str(v):
    out = []
    for c in v:
        if fiszero(c):
            out.append("0")
        else:
            k = next((k for k in range(9) if zeta(k) == c), None)
            out.append("z9^%d" % k if k is not None else "?")
    return "(" + ",".join(out) + ")"


def elt_str(g):
    e, s = g
    return "diag(%s) o perm(%s)" % (
        ",".join("z3^%d" % x for x in e),
        ",".join(str(x + 1) for x in s))


# ----------------------------------------------------------------------
# 5. Classification of the C9:C3 subgroups
# ----------------------------------------------------------------------
def subgroup_from(gens):
    return frozenset(closure(gens))


def is_M27(H):
    if len(H) != 27:
        return False
    orders = sorted(gorder(x) for x in H)
    if max(orders) != 9:
        return False
    # nonabelian
    Hl = sorted(H)
    for a in Hl:
        for b in Hl:
            if gmul(a, b) != gmul(b, a):
                return True
    return False


def centre(H):
    return [x for x in H if all(gmul(x, y) == gmul(y, x) for y in H)]


def main():
    payload = {}
    payload["variety"] = "X : x1^3+x2^3+x3^3+x4^3+x5^3 = 0 in P^4 (Fermat cubic threefold)"
    payload["aut_order"] = len(ALL)

    # ---- the pinned candidate of the work order -------------------------
    # a = 3-cycle (123) composed with diag(zeta,1,1,1,1);  a^3 = diag(z,z,z,1,1)
    cand = {}
    a_naive = canon((1, 0, 0, 0, 0), (1, 2, 0, 3, 4))
    b_naive = canon((0, 1, 2, 0, 0), tuple(range(N5)))
    for tag, (aa, bb) in [("naive", (a_naive, b_naive)),
                          ("separated", (canon((1, 0, 0, 0, 1), (1, 2, 0, 3, 4)), b_naive))]:
        H = subgroup_from([aa, bb])
        z = gmul(gmul(aa, aa), aa)
        rec = {
            "a": elt_str(aa), "b": elt_str(bb),
            "order_a": gorder(aa), "order_b": gorder(bb),
            "|G|": len(H), "is_M27": is_M27(H),
            "exponent": max(gorder(x) for x in H),
            "centre": [elt_str(x) for x in sorted(centre(H))],
            "centre_order": len(centre(H)),
            "z = a^3": elt_str(z), "order_z": gorder(z),
            "b a b^-1": elt_str(conjugate(aa, ginv(bb))),
            "a^4": elt_str(gmul(gmul(gmul(aa, aa), aa), aa)),
            "b a b^-1 == a^4": conjugate(aa, ginv(bb)) == gmul(gmul(gmul(aa, aa), aa), aa),
            "Z(G) == <a^3>": sorted(centre(H)) == sorted(closure([z])),
            "X^z": fixed_locus_diagonal(z),
            "hyp_a": hyp_a_diag(fixed_locus_diagonal(z)),
            "X^G": fixed_points_of_group(H, [aa, bb]),
        }
        rec["hyp_b"] = (len(rec["X^G"]) == 0)
        cand[tag] = rec
    payload["pinned_candidates"] = cand

    # ---- all elements of order 9, up to conjugacy ------------------------
    ord9 = [g for g in ALL if gorder(g) == 9]
    payload["num_order9_elements"] = len(ord9)
    seen = set()
    reps9 = []
    for g in ord9:
        if g in seen:
            continue
        orb = {g}
        fr = [g]
        while fr:
            x = fr.pop()
            for c in GENS:
                y = conjugate(x, c)
                if y not in orb:
                    orb.add(y)
                    fr.append(y)
        seen |= orb
        reps9.append((g, len(orb)))
    payload["order9_classes"] = [{"rep": elt_str(g), "class_size": n} for g, n in reps9]

    # ---- all M27 subgroups containing one of those representatives -------
    found = set()
    for a, _ in reps9:
        cyc = frozenset(closure([a]))
        Nrm = [c for c in ALL if frozenset(conjugate(x, c) for x in cyc) == cyc]
        for b in Nrm:
            if b in cyc:
                continue
            H = subgroup_from([a, b])
            if len(H) == 27 and is_M27(H):
                found.add(H)
    payload["num_M27_containing_a_representative"] = len(found)

    # ---- conjugacy classes of those subgroups ---------------------------
    classes = []
    left = set(found)
    while left:
        H = next(iter(left))
        orb = {H}
        fr = [H]
        while fr:
            K = fr.pop()
            for c in GENS:
                Lc = frozenset(conjugate(x, c) for x in K)
                if Lc not in orb:
                    orb.add(Lc)
                    fr.append(Lc)
        classes.append((H, len(orb)))
        left -= orb
    # total number of M27 subgroups in Aut(X) = sum of the class sizes
    payload["num_M27_subgroups_total"] = sum(n for _, n in classes)
    payload["num_M27_classes"] = len(classes)

    out = []
    for ci, (H, orbsize) in enumerate(classes):
        Zc = sorted(centre(H))
        gens = []
        cur = {ID}
        for x in sorted(H):
            if x in cur:
                continue
            gens.append(x)
            cur = closure(gens)
            if len(cur) == 27:
                break
        a = next(x for x in sorted(H) if gorder(x) == 9)
        z = gmul(gmul(a, a), a)
        assert sorted(Zc) == sorted(closure([z]))
        cents = []
        for zz in Zc:
            if zz == ID:
                continue
            assert zz[1] == tuple(range(N5)), "central element must be diagonal"
            comps = fixed_locus_diagonal(zz)
            cents.append({"z": elt_str(zz), "order": gorder(zz),
                          "X^z": comps, "hyp_a": hyp_a_diag(comps)})
        fx = fixed_points_of_group(H, gens)
        rec = {
            "class_id": "T4-C%02d" % (ci + 1),
            "class_size": orbsize,
            "generators": [elt_str(g) for g in gens],
            "generators_raw": [[list(g[0]), list(g[1])] for g in gens],
            "order": len(H),
            "exponent": max(gorder(x) for x in H),
            "centre_order": len(Zc),
            "is_M27": True,
            "central_elements": cents,
            "hyp_a": all(c["hyp_a"] for c in cents),
            "X^G": fx,
            "hyp_b": len(fx) == 0,
        }
        rec["corollary_applies"] = rec["hyp_a"] and rec["hyp_b"]
        out.append(rec)
    payload["M27_classes"] = out
    payload["classes_satisfying_a_and_b"] = [c["class_id"] for c in out if c["corollary_applies"]]

    # locate the pinned candidates among the conjugacy classes
    for tag, rec in cand.items():
        aa = a_naive if tag == "naive" else canon((1, 0, 0, 0, 1), (1, 2, 0, 3, 4))
        H = subgroup_from([aa, b_naive])
        where = None
        for (K, _), c in zip(classes, out):
            orb = {K}
            fr = [K]
            while fr:
                Kk = fr.pop()
                for cc in GENS:
                    Lc = frozenset(conjugate(x, cc) for x in Kk)
                    if Lc not in orb:
                        orb.add(Lc)
                        fr.append(Lc)
            if H in orb:
                where = c["class_id"]
                break
        rec["conjugacy_class"] = where

    with open(os.path.join(HERE, "T4_payload.json"), "w") as fh:
        json.dump(payload, fh, indent=1)

    # ---- report ----------------------------------------------------------
    print("Aut(X) order:", len(ALL))
    print("elements of order 9:", len(ord9), "in", len(reps9), "conjugacy classes")
    print("C9:C3 subgroups:", payload["num_M27_subgroups_total"],
          "in", len(classes), "conjugacy classes")
    print()
    for tag, rec in cand.items():
        print("pinned candidate [%s]: a = %s, b = %s" % (tag, rec["a"], rec["b"]))
        print("   |G| = %d, exponent %d, |Z| = %d, Z = <a^3>: %s, b a b^-1 = a^4: %s"
              % (rec["|G|"], rec["exponent"], rec["centre_order"],
                 rec["Z(G) == <a^3>"], rec["b a b^-1 == a^4"]))
        print("   z = a^3 = %s ; X^z components:" % rec["z = a^3"])
        for c in rec["X^z"]:
            print("      ", c["linear_space"], "->", c["X_cap"])
        print("   (a):", rec["hyp_a"], "  (b) X^G empty:", rec["hyp_b"], rec["X^G"])
    print()
    for c in out:
        print("%s |class|=%-4d exponent %d |Z| %d  (a) %s  (b) %s  => Cor T3.1: %s"
              % (c["class_id"], c["class_size"], c["exponent"], c["centre_order"],
                 c["hyp_a"], c["hyp_b"], c["corollary_applies"]))
        print("     gens:", c["generators"])
        for z in c["central_elements"]:
            print("     z = %s :" % z["z"],
                  " | ".join("%s -> %s" % (x["linear_space"], x["X_cap"]) for x in z["X^z"]))
        if c["X^G"]:
            print("     X^G:", c["X^G"])
    print()
    print("classes with (a)+(b):", payload["classes_satisfying_a_and_b"])


if __name__ == "__main__":
    main()
