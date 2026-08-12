"""F_{p^2} = F_p[aa] / (aa^2 - s*aa - t)  matching M2 GF(p^2, Variable => aa).

At p=331 M2 uses aa^2 = 5*aa - 3, i.e. (s,t) = (5, -3).
Elements are pairs (a,b) = a + b*aa, stored as int pairs.
"""
from __future__ import annotations

import numpy as np


def minpoly_from_m2(p):
    """Return (s,t) with aa^2 = s*aa + t, by scanning the unique irreducible
    that M2's GF(p^2) uses.  Caller should prefer the dumped quad line."""
    raise RuntimeError("pass explicit (s,t) from M2")


def add(u, v, p):
    return ((u[0] + v[0]) % p, (u[1] + v[1]) % p)


def sub(u, v, p):
    return ((u[0] - v[0]) % p, (u[1] - v[1]) % p)


def mul(u, v, p, st):
    s, t = st
    # (a+bω)(c+dω) = ac + bd t  +  (ad+bc+bd s) ω
    # because ω^2 = s ω + t
    a, b = u
    c, d = v
    re = (a * c + t * b * d) % p
    im = (a * d + b * c + s * b * d) % p
    return (re % p, im % p)


def smul(k, u, p):
    k = int(k) % p
    return ((k * u[0]) % p, (k * u[1]) % p)


def is_zero(u, p):
    return (int(u[0]) % p == 0) and (int(u[1]) % p == 0)


def inv(u, p, st):
    s, t = st
    a, b = int(u[0]) % p, int(u[1]) % p
    # (a+bω)(a+b(s-ω)?).  norm = a^2 + a b s - b^2 t ? 
    # (a+bω)(a + b s - b ω) because conjugate of ω is s-ω (roots sum to s)
    # (a+bω)(c - b ω) with c = a+b s
    # = a c - a b ω + b c ω - b^2 ω^2
    # = a c - b^2 (s ω + t) + (b c - a b) ω
    # = a c - t b^2  +  (-s b^2 + b c - a b) ω
    # want im=0: -s b^2 + b(a+bs) - a b = -s b^2 + a b + s b^2 - a b = 0. good.
    # re = a(a+bs) - t b^2 = a^2 + a b s - t b^2
    nrm = (a * a + s * a * b - t * b * b) % p
    if nrm == 0:
        raise ZeroDivisionError("zero in Fp2")
    ni = pow(nrm, p - 2, p)
    c = (a + s * b) % p
    return ((c * ni) % p, ((-b) * ni) % p)


def pow_el(u, e, p, st):
    r = (1, 0)
    b = (int(u[0]) % p, int(u[1]) % p)
    e = int(e)
    while e:
        if e & 1:
            r = mul(r, b, p, st)
        b = mul(b, b, p, st)
        e >>= 1
    return r


def from_fp(a, p):
    return (int(a) % p, 0)


def parse_aa_coeff(text, p):
    """Parse M2 '121*aa+37' / '-10*aa+52' / '42' / 'aa' / '-aa' into (c0,c1)
    meaning c0 + c1*aa."""
    s = text.replace(" ", "")
    if not s or s == "0":
        return (0, 0)
    # split into terms by + / - keeping sign
    s = s.replace("-", "+-")
    if s.startswith("+"):
        s = s[1:]
    c0, c1 = 0, 0
    for term in s.split("+"):
        if not term:
            continue
        if "aa" in term:
            coef = term.replace("*aa", "").replace("aa", "")
            if coef in ("", "+"):
                c1 += 1
            elif coef == "-":
                c1 -= 1
            else:
                c1 += int(coef)
        else:
            c0 += int(term)
    return (c0 % p, c1 % p)


def normalize_pt(coords, p, st):
    """coords: list of 5 pairs. Scale so first nonzero is 1."""
    for i in range(5):
        if not is_zero(coords[i], p):
            ii = inv(coords[i], p, st)
            return [mul(c, ii, p, st) for c in coords]
    raise ValueError("zero vector")


def matvec_fp(M, v, p, st):
    """M is (5,5) over F_p; v is 5 pairs."""
    out = []
    for i in range(5):
        acc = (0, 0)
        for j in range(5):
            acc = add(acc, smul(int(M[i, j]), v[j], p), p)
        out.append(acc)
    return out


def hess_F_fp2(x, p, st):
    M = [[(0, 0) for _ in range(5)] for _ in range(5)]
    for i in range(5):
        M[i][i] = smul(2, x[(i + 1) % 5], p)
        M[i][(i + 1) % 5] = smul(2, x[i], p)
        M[i][(i - 1) % 5] = smul(2, x[(i - 1) % 5], p)
    return M


def det5_fp2(M, p, st):
    import itertools
    acc = (0, 0)
    for perm in itertools.permutations(range(5)):
        perm = list(perm)
        # sign
        seen = [False] * 5
        sgn = 1
        for i in range(5):
            if seen[i]:
                continue
            j, ln = i, 0
            while not seen[j]:
                seen[j] = True
                j = perm[j]
                ln += 1
            if ln % 2 == 0:
                sgn = -sgn
        term = (1, 0)
        for i in range(5):
            term = mul(term, M[i][perm[i]], p, st)
        acc = add(acc, smul(sgn, term, p), p)
    return acc


def dH_fp2(x, p, st):
    M = hess_F_fp2(x, p, st)
    # cofactors
    import itertools
    perms4 = list(itertools.permutations(range(4)))

    def sgn4(perm):
        perm = list(perm)
        seen = [False] * 4
        s = 1
        for i in range(4):
            if seen[i]:
                continue
            j, ln = i, 0
            while not seen[j]:
                seen[j] = True
                j = perm[j]
                ln += 1
            if ln % 2 == 0:
                s = -s
        return s

    signs4 = [sgn4(pr) for pr in perms4]
    C = [[(0, 0) for _ in range(5)] for _ in range(5)]
    idx = [0, 1, 2, 3, 4]
    for i in range(5):
        for j in range(5):
            rows = [a for a in idx if a != i]
            cols = [b for b in idx if b != j]
            acc = (0, 0)
            for pr, sg in zip(perms4, signs4):
                term = (1, 0)
                for a in range(4):
                    term = mul(term, M[rows[a]][cols[pr[a]]], p, st)
                acc = add(acc, smul(sg, term, p), p)
            C[i][j] = smul((-1) ** (i + j), acc, p)
    out = []
    for k in range(5):
        s = smul(2, C[(k - 1) % 5][(k - 1) % 5], p)
        s = add(s, smul(2, C[k][(k + 1) % 5], p), p)
        s = add(s, smul(2, C[(k + 1) % 5][k], p), p)
        out.append(s)
    return out


def on_C_fp2(x, p, st):
    return all(is_zero(c, p) for c in dH_fp2(x, p, st))


def _mul_arr(U, V, p, st):
    """U,V: (..., 2) -> product in Fp2."""
    s, t = st
    a, b = U[..., 0], U[..., 1]
    c, d = V[..., 0], V[..., 1]
    re = (a * c + t * b * d) % p
    im = (a * d + b * c + s * b * d) % p
    return np.stack([re % p, im % p], axis=-1)


def eval_seeds_fp2(fr, A, C, pts, p, st):
    """Reynolds evaluation of seeds at Fp2 points. Returns (nseeds, npts, 5, 2).

    Vectorized over seeds.  pts: list of 5 pairs, or array (npts,5,2).
    """
    RHO = np.asarray(fr["RHO"], dtype=np.int64) % p
    RHOI = np.asarray(fr["RHOI"], dtype=np.int64) % p
    A = np.asarray(A, dtype=np.int64)
    Cidx = np.asarray(C, dtype=np.int64)
    ns = A.shape[0]
    P = []
    for w in pts:
        if isinstance(w[0], tuple):
            P.append([[int(w[i][0]) % p, int(w[i][1]) % p] for i in range(5)])
        else:
            P.append(w)
    P = np.array(P, dtype=np.int64) % p  # (npts,5,2)
    npts = P.shape[0]
    out = np.zeros((ns, npts, 5, 2), dtype=np.int64)
    mx = [int(A[:, j].max()) for j in range(5)]
    one = np.array([1, 0], dtype=np.int64)
    for q in range(npts):
        Wq = P[q]  # (5,2)
        for g in range(660):
            # u_j = sum_i RHO[g,j,i] Wq[i]
            u = np.zeros((5, 2), dtype=np.int64)
            for j in range(5):
                acc = np.zeros(2, dtype=np.int64)
                for i in range(5):
                    k = int(RHO[g, j, i])
                    if k:
                        acc = (acc + k * Wq[i]) % p
                u[j] = acc
            pw = []
            for j in range(5):
                col = [one.copy()]
                cur = one.copy()
                for e in range(1, mx[j] + 1):
                    cur = _mul_arr(cur, u[j], p, st)
                    col.append(cur)
                pw.append(col)
            mon = np.broadcast_to(one, (ns, 2)).copy()
            for j in range(5):
                E = A[:, j]
                # gather powers; 0 -> 1
                block = np.array([pw[j][int(e)] for e in E], dtype=np.int64)
                mon = _mul_arr(mon, block, p, st)
            for c0 in range(5):
                idx = np.nonzero(Cidx == c0)[0]
                if idx.size == 0:
                    continue
                Mg = RHOI[g, :, c0] % p  # (5,)
                for c in range(5):
                    k = int(Mg[c])
                    if not k:
                        continue
                    out[idx, q, c] = (out[idx, q, c] + k * mon[idx]) % p
    return out % p


def _tmul_fp2(a, b, p, st):
    """Truncated product of Fp2 t-series. a,b: (..., J, 2)."""
    J = a.shape[-2]
    out = np.zeros_like(a)
    for i in range(J):
        if i:
            # out[..., i:, :] += a[..., i, :] * b[..., :J-i, :]
            ai = a[..., i, :]  # (..., 2)
            for k in range(J - i):
                out[..., i + k, :] = (
                    out[..., i + k, :] + _mul_arr(ai, b[..., k, :], p, st)
                ) % p
        else:
            for k in range(J):
                out[..., k, :] = (
                    out[..., k, :] + _mul_arr(a[..., 0, :], b[..., k, :], p, st)
                ) % p
    return out % p


def jet_rows_fp2(fr, A, C, W, Y, J, p, st, deg=35):
    """Exact Fp2 analogue of slicelib.jet_rows.  W,Y: (npair,5,2).

    Returns (nseeds, npair, 5, J, 2).
    """
    RHO = np.asarray(fr["RHO"], dtype=np.int64) % p
    RHOI = np.asarray(fr["RHOI"], dtype=np.int64) % p
    A = np.asarray(A, dtype=np.int64)
    Cidx = np.asarray(C, dtype=np.int64)
    W = np.asarray(W, dtype=np.int64) % p
    Y = np.asarray(Y, dtype=np.int64) % p
    ns = A.shape[0]
    npair = W.shape[0]
    out = np.zeros((ns, npair, 5, J, 2), dtype=np.int64)
    one = np.zeros((J, 2), dtype=np.int64)
    one[0, 0] = 1
    for q in range(npair):
        for g in range(660):
            # u = RHO[g] W[q], up = RHO[g] Y[q]
            u = np.zeros((5, 2), dtype=np.int64)
            up = np.zeros((5, 2), dtype=np.int64)
            for j in range(5):
                acc = np.zeros(2, dtype=np.int64)
                accp = np.zeros(2, dtype=np.int64)
                for i in range(5):
                    k = int(RHO[g, j, i])
                    if k:
                        acc = (acc + k * W[q, i]) % p
                        accp = (accp + k * Y[q, i]) % p
                u[j] = acc
                up[j] = accp
            # POW[j][m] = (u_j + t up_j)^m , shape (deg+1, J, 2)
            POW = []
            for j in range(5):
                base = np.zeros((J, 2), dtype=np.int64)
                base[0] = u[j]
                if J > 1:
                    base[1] = up[j]
                cur = one.copy()
                lst = [cur.copy()]
                for m in range(1, deg + 1):
                    cur = _tmul_fp2(cur, base, p, st)
                    lst.append(cur)
                POW.append(lst)
            # mon_s = prod_j POW[j][A[s,j]]
            mon = np.broadcast_to(one, (ns, J, 2)).copy()
            for j in range(5):
                block = np.array([POW[j][int(e)] for e in A[:, j]],
                                 dtype=np.int64)  # (ns,J,2)
                mon = _tmul_fp2(mon, block, p, st)
            for c0 in range(5):
                idx = np.nonzero(Cidx == c0)[0]
                if idx.size == 0:
                    continue
                Mg = RHOI[g, :, c0] % p
                for c in range(5):
                    k = int(Mg[c])
                    if not k:
                        continue
                    out[idx, q, c] = (out[idx, q, c] + k * mon[idx]) % p
    return out % p


def parse_sextet_points(path, p):
    """Read gen2 lines from sextet_p*.txt.  Each deg-1 component is a point
    in the y4=1 chart: yi + (linear in aa)*y4 = 0."""
    comps = []
    cur = {}
    for line in open(path):
        if line.startswith("comp2 "):
            if cur:
                comps.append(cur)
            cur = {}
        elif line.startswith("gen2 "):
            body = line[len("gen2 "):].strip()
            # yk+(....)*y4   or yk+(....)  if no y4 written? always *y4 here
            # form: y{i}+({aa-poly})*y4
            if not body.startswith("y"):
                continue
            i = int(body[1])
            rest = body[2:]
            if rest.startswith("+"):
                rest = rest[1:]
            rest = rest.replace("*y4", "")
            if rest.startswith("(") and rest.endswith(")"):
                rest = rest[1:-1]
            cur[i] = rest
    if cur:
        comps.append(cur)
    pts = []
    for c in comps:
        # y4 = 1, yi = -coeff
        coords_txt = [c.get(i, "0") for i in range(5)]
        # missing index is the free one (y4)
        missing = [i for i in range(5) if i not in c]
        if missing != [4]:
            # general: set the missing coordinate to 1
            pass
        raw = []
        for i in range(5):
            if i in c:
                coef = parse_aa_coeff(c[i], p)
                raw.append(((-coef[0]) % p, (-coef[1]) % p))
            else:
                raw.append((1, 0))
        pts.append(raw)
    return pts
