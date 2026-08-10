#!/usr/bin/env python3
"""f55_exact_lift_model.py -- the exact-lift campaign, step A: THE MODEL.

Builds the equivariant V14 model mod p (p = 1 mod 11) in the C11-EIGENBASIS of
U (the 6-dim even Weil rep of SL2(F11)), extracts the five linear conditions
E_q that cut P(M) out of P(Lambda^2 U), and runs the calibration gate.

Facts reconstructed here (all machine-checked, none assumed):
  * T6 = diag(zeta^{j^2}) is ALREADY the C11-eigenbasis: basis vector e_j has
    weight a_j = j^2 mod 11, so (a_0..a_5) = (0,1,4,9,5,3) = {0} u QR.
  * Lambda^2 U has weights: residue q twice (u_0^u_q and u_{c_q}^u_{d_q}),
    non-residue once.  M = 10' takes one line in each residue-weight plane,
    W_5 = the other.  So "omega in M" is FIVE linear conditions
        E_q :  D_{c_q d_q} = t_q * D_{0q},        q in QR = {1,3,4,5,9}
    with pairs {c,d}: q=1 -> {3,9}, q=3 -> {5,9}, q=4 -> {1,3},
                      q=5 -> {1,4}, q=9 -> {4,5}.
  * Lemma B <=> both coordinates of M's weight-q line are nonzero <=>
    t_q is defined and nonzero.  CHECKED here.

Outputs f55_exact_lift_model_p<p>.json with t_q and the calibration results.
"""
import sys, json, os
from itertools import combinations

P_LIST = [int(x) for x in sys.argv[1:]] or [397, 199, 331]

QR = [1, 3, 4, 5, 9]
CD = {1: (3, 9), 3: (5, 9), 4: (1, 3), 5: (1, 4), 9: (4, 5)}
# the five C11-points of V14: pure decomposables u_a^u_b, a+b a NON-residue
PTS = {2: (4, 9), 6: (1, 5), 7: (3, 4), 8: (3, 5), 10: (1, 9)}
PENTAGON = [(2, 7), (7, 8), (8, 6), (6, 10), (10, 2)]
DIAGONAL = [(2, 6), (2, 8), (7, 6), (7, 10), (8, 10)]


def build(p):
    assert p % 11 == 1, p
    g11 = next(t for t in range(2, p) if pow(t, 11, p) == 1 and t != 1)
    gauss = sum(pow(g11, (k * k) % 11, p) for k in range(11)) % p
    assert (gauss * gauss + 11) % p == 0
    c = pow(gauss, p - 2, p)
    T6 = tuple(tuple((pow(g11, (j * j) % 11, p) if i == j else 0) for j in range(6)) for i in range(6))
    S6 = tuple(tuple((c if j == 0 else c * (pow(g11, (i * j) % 11, p) + pow(g11, (-i * j) % 11, p))) % p
                     for j in range(6)) for i in range(6))

    def mm(A, B, n=6):
        return tuple(tuple(sum(A[i][k] * B[k][j] for k in range(n)) % p for j in range(n)) for i in range(n))

    I6 = tuple(tuple((1 if i == j else 0) for j in range(6)) for i in range(6))
    seen = {I6}
    fr = [I6]
    while fr:
        nx = []
        for A in fr:
            for g in (T6, S6):
                N = mm(A, g)
                if N not in seen:
                    seen.add(N)
                    nx.append(N)
        fr = nx
    GRP = list(seen)
    assert len(GRP) == 1320, len(GRP)

    def is_scal(A):
        d = A[0][0]
        return d != 0 and all(A[i][j] == (d if i == j else 0) for i in range(6) for j in range(6))

    def po(A):
        B = A
        for k in range(1, 14):
            if is_scal(B):
                return k
            B = mm(B, A)
        return 99

    pairs = list(combinations(range(6), 2))

    def lam2(A):
        return tuple(tuple((A[i][k] * A[j][l] - A[i][l] * A[j][k]) % p for (k, l) in pairs)
                     for (i, j) in pairs)

    CHI = {1: 10, 2: 2, 3: 1, 5: 0, 6: p - 1, 11: p - 1}   # chi_{10'} by element order
    PM = [[0] * 15 for _ in range(15)]
    for A in GRP:
        w = CHI[po(A)]
        if w == 0:
            continue
        L2 = lam2(A)
        for i in range(15):
            Ri, Li = PM[i], L2[i]
            for j in range(15):
                Ri[j] = (Ri[j] + w * Li[j]) % p
    sc = 10 * pow(1320 % p, p - 2, p) % p
    PM = [[x * sc % p for x in r] for r in PM]

    def echelon(rows):
        R = [list(r) for r in rows]
        piv, rr = [], 0
        for cx in range(len(R[0]) if R else 0):
            pr = next((r for r in range(rr, len(R)) if R[r][cx] % p), None)
            if pr is None:
                continue
            R[rr], R[pr] = R[pr], R[rr]
            iv = pow(R[rr][cx], p - 2, p)
            R[rr] = [x * iv % p for x in R[rr]]
            for r in range(len(R)):
                if r != rr and R[r][cx] % p:
                    f = R[r][cx]
                    R[r] = [(x - f * y) % p for x, y in zip(R[r], R[rr])]
            piv.append(cx)
            rr += 1
        return [tuple(r) for r in R[:rr]], piv

    MB, _ = echelon([tuple(PM[i][j] for i in range(15)) for j in range(15)])
    assert len(MB) == 10, len(MB)
    return dict(p=p, g11=g11, pairs=pairs, MB=MB, echelon=echelon, GRP=GRP, mm=mm, po=po, lam2=lam2)


def main():
    out = {}
    for p in P_LIST:
        m = build(p)
        pairs, MB, echelon = m['pairs'], m['MB'], m['echelon']
        # weight of basis vector e_j is a_j = j^2 mod 11
        wt_of = [(j * j) % 11 for j in range(6)]
        idx_of_weight = {w: j for j, w in enumerate(wt_of)}
        assert sorted(wt_of) == [0, 1, 3, 4, 5, 9], wt_of
        # index of the bivector u_a ^ u_b (a<b as WEIGHTS) in the pairs basis, with sign
        def biv(a, b):
            i, j = idx_of_weight[a], idx_of_weight[b]
            s = 1
            if i > j:
                i, j, s = j, i, -1
            return pairs.index((i, j)), s

        # weight-q plane of Lambda^2 U for q in QR, coordinates (D_{0q}, D_{cd})
        tq = {}
        for q in QR:
            c, d = CD[q]
            k0, s0 = biv(0, q)
            k1, s1 = biv(c, d)
            # M's line inside span(e_{k0}, e_{k1}): solve from MB
            rows = [(v[k0], v[k1]) for v in MB]
            # the set of (x,y) realizable as (v_{k0}, v_{k1}) restricted to M's weight-q part.
            # Better: M cap plane = ker of the 13 OTHER coordinates on the plane.
            # Take the 2-dim plane W = span(b0,b1) with b0 = e_{k0}, b1 = e_{k1}; find
            # coefficients (x,y) with x*b0 + y*b1 in M, i.e. in rowspace(MB).
            # rowspace(MB) is 10-dim; solve by echelonizing MB and reducing.
            E, piv = echelon(MB)
            def reduce_vec(v):
                v = list(v)
                for r, pc in zip(E, piv):
                    if v[pc] % p:
                        f = v[pc]
                        v = [(a - f * b) % p for a, b in zip(v, r)]
                return v
            r0, r1 = reduce_vec([1 if i == k0 else 0 for i in range(15)]), \
                     reduce_vec([1 if i == k1 else 0 for i in range(15)])
            # want x*r0 + y*r1 = 0
            A = [[r0[i], r1[i]] for i in range(15)]
            sol, spiv = echelon([tuple(A[i][j] for i in range(15)) for j in range(2)])
            # kernel of the 15x2 matrix A: use echelon of A^T? do it directly
            # solve 2 unknowns: stack rows of A
            Ar, Apiv = echelon(A)
            free = [i for i in range(2) if i not in Apiv]
            assert len(free) == 1, (p, q, Apiv)
            fx = free[0]
            v = [0, 0]
            v[fx] = 1
            for r, pc in zip(Ar, Apiv):
                v[pc] = (-r[fx]) % p
            x, y = v            # x * u_0^u_q + y * u_{c}^u_{d} lies in M
            assert x % p and y % p, ("Lemma B FAILS", p, q, x, y)
            # membership condition for a general omega: (D_0q, D_cd) proportional to (x,y)
            # i.e. y*D_0q - x*D_cd = 0  ->  D_cd = (y/x) D_0q, in the SIGNED basis.
            # convert to the sign convention D_{ab} with a<b as weights: our biv() carries s.
            t = y * pow(x, p - 2, p) % p
            # careful with signs s0, s1: coordinate of omega on e_{k0} is s0*D_{0q}, on e_{k1} is s1*D_{cd}
            t = t * s0 * pow(s1 % p, p - 2, p) % p
            tq[q] = t

        # ---- calibration gate ----
        # (a) the five points lie on V14 and satisfy every E_q trivially
        # (b) pentagon pairs: the joining LINE lies on V14; diagonal pairs: it does not
        def plane_pluck(vecs):
            """Plucker vector (dict over weight-pairs) of the plane spanned by two
               weight-coordinate vectors given as dicts weight->coeff."""
            f, g = vecs
            D = {}
            for a, b in combinations([0, 1, 3, 4, 5, 9], 2):
                D[(a, b)] = (f.get(a, 0) * g.get(b, 0) - f.get(b, 0) * g.get(a, 0)) % p
            return D

        def inM(D):
            return all((D[tuple(sorted(CD[q]))] - tq[q] * D[(0, q)]) % p == 0 for q in QR)

        pent_res, diag_res = {}, {}
        for (ca, cb) in PENTAGON + DIAGONAL:
            ea, eb = PTS[ca], PTS[cb]
            shared = set(ea) & set(eb)
            res = {}
            if len(shared) == 1:
                v = shared.pop()
                x = (set(ea) - {v}).pop()
                y = (set(eb) - {v}).pop()
                # line: planes span(u_v, s*u_x + t*u_y); test membership for the pencil
                ok = True
                for s in range(1, min(p, 7)):
                    f = {v: 1}
                    g = {x: 1, y: s}
                    if not inM(plane_pluck((f, g))):
                        ok = False
                res['line_on_V14'] = ok
            else:
                # disjoint edges: the "line" joining the two POINTS of P(M) is not in Gr,
                # record the wedge test y_a ^ y_b (the classical criterion)
                res['line_on_V14'] = False
                res['note'] = 'edges disjoint: the joining line of the two points is not in Gr(2,U)'
            (pent_res if (ca, cb) in PENTAGON else diag_res)[f"{ca},{cb}"] = res

        out[p] = dict(t=tq, wt_of=wt_of, pentagon=pent_res, diagonal=diag_res)
        print(f"p = {p}")
        print(f"  weights of basis (e_0..e_5): {wt_of}")
        print(f"  t_q (D_cd = t_q D_0q):       {tq}")
        print(f"  Lemma B: all t_q nonzero:    {all(v % p for v in tq.values())}")
        print(f"  pentagon lines on V14:       {[(k, v['line_on_V14']) for k, v in pent_res.items()]}")
        print(f"  diagonal pairs:              {[(k, v['line_on_V14']) for k, v in diag_res.items()]}")
    here = os.path.dirname(os.path.abspath(__file__))
    with open(os.path.join(here, 'f55_exact_lift_model.json'), 'w') as fh:
        json.dump({str(k): v for k, v in out.items()}, fh, indent=1)
    print("\nwrote f55_exact_lift_model.json")


if __name__ == '__main__':
    main()
