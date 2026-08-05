"""EXTRA (not the primary evidence): a fully independent modular cross-check.

Everything is rebuilt from scratch over F_p for primes p = 1 mod 11 (so that
zeta_11 exists in F_p): the Weil representation, the group, the involutions,
the eigensplit, F|_{W-}, the plane cubic E_sigma, and -- by a THIRD algorithm,
different from both char-0 routes -- its j-invariant, computed by brute-force
flex search followed by Weierstrass reduction.  The result is compared with
the char-0 answer 8192/11 reduced mod p.

This is a consistency cross-check only; the char-0 exact computation in
produce_fix_a0.py / verify_fix_a0.py is the actual certificate.
"""
import sys
from collections import Counter

PRIMES = [23, 67, 89]
QR11 = {1, 3, 4, 5, 9}
JS = [1, 3, 2, 5, 4]
SIGNS = [1, 1, -1, 1, 1]
FAIL = []


def check(name, cond):
    if not cond:
        FAIL.append(name)
    print(('  PASS  ' if cond else '  FAIL  ') + name, flush=True)
    return cond


def run(p):
    print('p = %d' % p)
    inv = lambda a: pow(a % p, p - 2, p)

    # a primitive 11th root of unity in F_p
    w = None
    for g in range(2, p):
        cand = pow(g, (p - 1) // 11, p)
        if cand != 1:
            w = cand
            break
    assert w is not None and pow(w, 11, p) == 1

    def zeta(k):
        return pow(w, k % 11, p)

    gs = sum((zeta(a) if a in QR11 else -zeta(a)) for a in range(1, 11)) % p
    check('Gauss sum g^2 = -11 in F_%d' % p, gs * gs % p == (-11) % p)

    S = [[SIGNS[k] * inv(SIGNS[i]) % p * ((zeta(9 * j * l) - zeta(-9 * j * l))
                                          * (-gs) % p) % p * inv(11) % p
          for k, l in enumerate(JS)] for i, j in enumerate(JS)]
    T = [[zeta(JS[i] * JS[i]) if i == j else 0 for j in range(5)] for i in range(5)]

    def mm(A, B):
        return [[sum(A[i][k] * B[k][j] for k in range(5)) % p for j in range(5)]
                for i in range(5)]
    Id = [[1 if i == j else 0 for j in range(5)] for i in range(5)]

    def mpow(A, n):
        R = Id
        while n:
            if n & 1:
                R = mm(R, A)
            A = mm(A, A)
            n >>= 1
        return R
    check('S^2 = T^11 = (ST)^3 = 1', mpow(S, 2) == Id and mpow(T, 11) == Id
          and mpow(mm(S, T), 3) == Id)

    key = lambda A: tuple(x for r in A for x in r)
    seen = {key(Id): Id}
    fr = [Id]
    while fr:
        nx = []
        for A in fr:
            for gmat in (S, T):
                B = mm(A, gmat)
                k = key(B)
                if k not in seen:
                    seen[k] = B
                    nx.append(B)
        fr = nx
    G = list(seen.values())
    check('group order 660 mod %d' % p, len(G) == 660)

    def order(A):
        B, n = A, 1
        while B != Id:
            B = mm(B, A)
            n += 1
        return n
    INV = [A for A in G if order(A) == 2]
    check('55 involutions', len(INV) == 55)
    check('all involution traces = 1',
          set(sum(A[i][i] for i in range(5)) % p for A in INV) == {1})

    # linear algebra over F_p
    def rref(rows):
        M = [r[:] for r in rows]
        piv = []
        r = 0
        nc = len(M[0]) if M else 0
        for c in range(nc):
            pr = next((rr for rr in range(r, len(M)) if M[rr][c] % p), None)
            if pr is None:
                continue
            M[r], M[pr] = M[pr], M[r]
            iv = inv(M[r][c])
            M[r] = [x * iv % p for x in M[r]]
            for rr in range(len(M)):
                if rr != r and M[rr][c] % p:
                    f = M[rr][c]
                    M[rr] = [(x - f * y) % p for x, y in zip(M[rr], M[r])]
            piv.append(c)
            r += 1
            if r == len(M):
                break
        return M[:r], piv

    def nullsp(rows, nc):
        R, piv = rref(rows)
        out = []
        for fc in [c for c in range(nc) if c not in piv]:
            v = [0] * nc
            v[fc] = 1
            for i, pc in enumerate(piv):
                v[pc] = (-R[i][fc]) % p
            out.append(v)
        return out

    def eigsp(A, sgn):
        M = [[(A[i][j] - (sgn if i == j else 0)) % p for j in range(5)]
             for i in range(5)]
        return rref(nullsp(M, 5))[0]

    dims = set()
    fzero = True
    cubics = []
    for A in INV:
        Wp, Wm = eigsp(A, 1), eigsp(A, p - 1)
        dims.add((len(Wp), len(Wm)))
        # F restricted to W- : evaluate at 5 distinct points of the line
        for (s, t) in [(1, 0), (0, 1), (1, 1), (1, 2), (1, 3)]:
            v = [(Wm[0][k] * s + Wm[1][k] * t) % p for k in range(5)]
            if sum(v[i] * v[i] % p * v[(i + 1) % 5] for i in range(5)) % p:
                fzero = False
        cubics.append((Wp, Wm))
    check('all eigensplits (3,2)', dims == {(3, 2)})
    check('F vanishes on every L_sigma (5 points => the binary cubic is 0)', fzero)

    # ---- j of E_sigma by flex + Weierstrass (a third, independent algorithm)
    def ternary_cubic(Wp):
        """coefficients of F(sum t_i u_i) as a dict (i,j,k) -> F_p."""
        C = Counter()
        for a in range(5):
            b = (a + 1) % 5
            for i in range(3):
                for j in range(3):
                    for k in range(3):
                        coef = Wp[i][a] * Wp[j][a] % p * Wp[k][b] % p
                        if coef:
                            ex = [0, 0, 0]
                            ex[i] += 1
                            ex[j] += 1
                            ex[k] += 1
                            C[tuple(ex)] = (C[tuple(ex)] + coef) % p
        return {e: v % p for e, v in C.items() if v % p}

    def ev(C, pt):
        s = 0
        for (i, j, k), v in C.items():
            s += v * pow(pt[0], i, p) * pow(pt[1], j, p) * pow(pt[2], k, p)
        return s % p

    def partial(C, var):
        D = Counter()
        for e, v in C.items():
            if e[var]:
                ne = list(e)
                ne[var] -= 1
                D[tuple(ne)] = (D[tuple(ne)] + v * e[var]) % p
        return {e: v for e, v in D.items() if v % p}

    def substitute(C, M):
        """C(M . t) where M is 3x3, rows give the new variables' images."""
        # build (sum_j M[0][j] t_j) etc. as polys
        def polymul(A, B):
            out = Counter()
            for e1, v1 in A.items():
                for e2, v2 in B.items():
                    e = tuple(x + y for x, y in zip(e1, e2))
                    out[e] = (out[e] + v1 * v2) % p
            return {e: v for e, v in out.items() if v}
        lin = []
        for r in range(3):
            lin.append({tuple(1 if q == cix else 0 for q in range(3)): M[r][cix] % p
                        for cix in range(3) if M[r][cix] % p})
        out = Counter()
        for (i, j, k), v in C.items():
            term = {(0, 0, 0): v}
            for _ in range(i):
                term = polymul(term, lin[0])
            for _ in range(j):
                term = polymul(term, lin[1])
            for _ in range(k):
                term = polymul(term, lin[2])
            for e, vv in term.items():
                out[e] = (out[e] + vv) % p
        return {e: v for e, v in out.items() if v}

    def proj_points():
        for x in range(p):
            for y in range(p):
                yield (1, x, y)
        for y in range(p):
            yield (0, 1, y)
        yield (0, 0, 1)

    def j_of_plane_cubic(C):
        # flexes: C = 0 and det(Hessian) = 0
        H = [[partial(partial(C, a), b) for b in range(3)] for a in range(3)]

        def hess(pt):
            m = [[ev(H[a][b], pt) for b in range(3)] for a in range(3)]
            return (m[0][0] * (m[1][1] * m[2][2] - m[1][2] * m[2][1])
                    - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0])
                    + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0])) % p
        flexes = [pt for pt in proj_points() if ev(C, pt) == 0 and hess(pt) == 0]
        if not flexes:
            return None, 0
        P0 = flexes[0]
        gr = [ev(partial(C, a), P0) for a in range(3)]
        if not any(gr):
            return None, len(flexes)
        # new coordinates: Zn = tangent, Xn = another form vanishing at P0,
        # Yn = a form not vanishing at P0
        rowsZ = gr
        # forms vanishing at P0 : nullspace of the 1x3 matrix P0
        van = nullsp([list(P0)], 3)
        cand = [v for v in van
                if rref([rowsZ, v])[1] and len(rref([rowsZ, v])[0]) == 2]
        if not cand:
            return None, len(flexes)
        rowsX = cand[0]
        rowsY = None
        for e in ([1, 0, 0], [0, 1, 0], [0, 0, 1]):
            if len(rref([rowsZ, rowsX, e])[0]) == 3:
                rowsY = e
                break
        if rowsY is None:
            return None, len(flexes)
        # M sends new coords -> old:  we need C(x) written in Xn,Yn,Zn.
        # Solve for the inverse of the matrix whose rows are (Xn,Yn,Zn) forms.
        Mfw = [rowsX, rowsY, rowsZ]
        aug = [Mfw[r][:] + [1 if r == c else 0 for c in range(3)] for r in range(3)]
        R, piv = rref(aug)
        if piv[:3] != [0, 1, 2]:
            return None, len(flexes)
        Minv = [[R[r][3 + c] for c in range(3)] for r in range(3)]
        # old coords = Minv . new coords -> substitute
        Cn = substitute(C, Minv)
        A_ = Cn.get((0, 2, 1), 0)
        B_ = Cn.get((1, 1, 1), 0)
        C_ = Cn.get((0, 1, 2), 0)
        D_ = Cn.get((3, 0, 0), 0)
        E_ = Cn.get((2, 0, 1), 0)
        F_ = Cn.get((1, 0, 2), 0)
        Gq = Cn.get((0, 0, 3), 0)
        if Cn.get((0, 3, 0), 0) or Cn.get((1, 2, 0), 0) or Cn.get((2, 1, 0), 0):
            return None, len(flexes)
        if A_ % p == 0 or D_ % p == 0:
            return None, len(flexes)
        i4 = inv(4)
        al = (-A_ * D_) % p
        be = (B_ * B_ * i4 - A_ * E_) % p
        ga = (2 * B_ * C_ * i4 - A_ * F_) % p
        de = (C_ * C_ * i4 - A_ * Gq) % p
        a2, a4, a6 = be, al * ga % p, al * al % p * de % p
        b2, b4, b6 = 4 * a2 % p, 2 * a4 % p, 4 * a6 % p
        c4 = (b2 * b2 - 24 * b4) % p
        c6 = (-b2 ** 3 + 36 * b2 * b4 - 216 * b6) % p
        Dl = (c4 ** 3 - c6 ** 2) % p * inv(1728) % p
        if Dl == 0:
            return None, len(flexes)
        return pow(c4, 3, p) * inv(Dl) % p, len(flexes)

    jexp = 8192 * inv(11) % p
    js = set()
    nflex = set()
    for (Wp, Wm) in cubics[:6]:
        C = ternary_cubic(Wp)
        jv, nf = j_of_plane_cubic(C)
        js.add(jv)
        nflex.add(nf)
    # NB: only the F_p-rational flexes are visible; the other flexes live over
    # an extension.  A successful reduction with Delta != 0 already exhibits an
    # isomorphism of E_sigma with a smooth Weierstrass cubic, hence smoothness.
    check('every tested E_sigma admits an F_p-rational flex and a Weierstrass '
          'model with Delta != 0 (rational-flex counts seen: %s)'
          % sorted(nflex), None not in js)
    check('j(E_sigma) mod %d = 8192/11 mod %d = %d (flex+Weierstrass route)'
          % (p, p, jexp), js == {jexp})
    print()


for p in PRIMES:
    run(p)

if FAIL:
    print('MODULAR CROSS-CHECK: FAIL')
    for f in FAIL:
        print('  -', f)
    sys.exit(1)
print('MODULAR CROSS-CHECK: PASS for p in %s' % PRIMES)
