"""STAGE1_COMPLEX_MAPS -- Layer 3: the corrected window arithmetic.

The forced sweep of the plus-plane divisor (row #01 = D_{P_sigma}) is realized by
the LEADING TERM of the covariant along P_sigma.  If T is a landing covariant of
degree d (so T in (Sym^d W^* (x) W)^G) and m = ord_{P_sigma}(T^-), then in the
sigma-bigrading W^* = W^{+*} (+) W^{-*} the leading minus-half datum is the
(d-m, m) piece

        T_m  in  Sym^{d-m}(W^{+*}) (x) Sym^{m}(W^{-*}) (x) W^{-} ,

and it is D12-INVARIANT (no character twist), because T is G-invariant and
D12 = C_G(sigma) preserves the bigrading.  So

        N(d, m) := dim ( Sym^{d-m}(W^{+*}) (x) Sym^m(W^{-*}) (x) W^- )^{D12}

is a necessary-nonvanishing invariant of every (d, m): N(d, m) = 0 kills the
pair.  The same bookkeeping on the plus half gives

        N^+(d, m) := dim ( Sym^{d-m}(W^{+*}) (x) Sym^m(W^{-*}) (x) W^+ )^{D12}.

sigma acts by (-1)^m on Sym^m(W^{-*}) and by -1 on W^-, so N(d,m) = 0 for m even
and N^+(d,m) = 0 for m odd: the minus half has ODD order and the plus half EVEN
order -- the character-theoretic form of the sealed parity theorem H0-1.

All traces are computed in F_p (p coprime to |D12| = 12), so the resulting
dimensions are the characteristic-zero ones as long as they stay below p.
"""
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))


def hpoly(m, evals, N):
    """h_0..h_N of the multiset `evals` in F_p (complete homogeneous)."""
    p = m.p
    h = [0] * (N + 1)
    h[0] = 1
    # 1/prod(1 - e t) = sum h_k t^k ; use the recursion of the power series
    den = [1] + [0] * N
    for e in evals:
        new = [0] * (N + 1)
        for k in range(N + 1):
            if den[k] == 0:
                continue
            for j in range(N + 1 - k):
                new[k + j] = (new[k + j] + den[k] * pow(e, j, p)) % p
        den = new
    return den


def eig_multiset(m, g, U):
    """eigenvalues of g on the g-stable subspace U (as a multiset in F_p)."""
    p = m.p
    n = len(U)
    ev = []
    for lam in range(1, p):
        if pow(lam, m.order[g], p) != 1:
            continue
        E = m.eigsp(g, lam)
        I = m.inter(E, U) if E else ()
        if I:
            ev.extend([lam] * len(I))
    assert len(ev) == n, (len(ev), n)
    return ev


def window_table(m, sigma, dmax=60):
    """N(d,m) and N^+(d,m) for the representative involution sigma."""
    p = m.p
    Wp = m.eigsp(sigma, 1)
    Wm = m.eigsp(sigma, p - 1)
    D12 = [g for g in m.G if m.mm(g, sigma) == m.mm(sigma, g)]
    assert len(D12) == 12
    inv = {}
    for g in D12:
        ep = [m.inv(x) for x in eig_multiset(m, g, Wp)]   # on W^{+*}
        em = [m.inv(x) for x in eig_multiset(m, g, Wm)]   # on W^{-*}
        hp = hpoly(m, ep, dmax)
        hm = hpoly(m, em, dmax)
        trm = sum(eig_multiset(m, g, Wm)) % p
        trp = sum(eig_multiset(m, g, Wp)) % p
        inv[g] = (hp, hm, trm, trp)
    twelve = m.inv(12 % p)
    out = {}
    for mm in range(0, dmax + 1):
        for d in range(mm, dmax + 1):
            s = sp = 0
            for g in D12:
                hp, hm, trm, trp = inv[g]
                base = hp[d - mm] * hm[mm] % p
                s = (s + base * trm) % p
                sp = (sp + base * trp) % p
            out[(d, mm)] = (s * twelve % p, sp * twelve % p)
    return out


# ---------------------------------------------------------------------------
# exact version over Z[zeta_6]:  a + b*zeta  with  zeta^2 = zeta - 1
def zmul(x, y):
    a, b = x
    c, d = y
    return (a * c - b * d, a * d + b * c + b * d)


def zadd(x, y):
    return (x[0] + y[0], x[1] + y[1])


ZETA = {0: (1, 0), 1: (0, 1), 2: (-1, 1), 3: (-1, 0), 4: (0, -1), 5: (1, -1)}


def exact_hpoly(exps, N):
    """h_0..h_N of the multiset {zeta^e : e in exps}, exactly in Z[zeta_6]."""
    den = [(1, 0)] + [(0, 0)] * N
    for e in exps:
        new = [(0, 0)] * (N + 1)
        pw = (1, 0)
        pows = []
        for j in range(N + 1):
            pows.append(pw)
            pw = zmul(pw, ZETA[e % 6])
        for k in range(N + 1):
            if den[k] == (0, 0):
                continue
            for j in range(N + 1 - k):
                new[k + j] = zadd(new[k + j], zmul(den[k], pows[j]))
        den = new
    return den


def exact_window(m, sigma, dmax=60):
    """exact N(d,mm) and N^+(d,mm) over Z, via Z[zeta_6] character arithmetic."""
    p = m.p
    Wp = m.eigsp(sigma, 1)
    Wm = m.eigsp(sigma, p - 1)
    D12 = [g for g in m.G if m.mm(g, sigma) == m.mm(sigma, g)]
    z6 = None
    for x in range(2, p):
        if pow(x, 6, p) == 1 and pow(x, 3, p) != 1 and pow(x, 2, p) != 1:
            z6 = x
            break
    zp = {pow(z6, e, p): e for e in range(6)}

    def exps(g, U, inverse):
        out = []
        for lam in zp:
            E = m.eigsp(g, lam)
            I = m.inter(E, U) if E else ()
            if I:
                e = zp[lam]
                out.extend([(-e) % 6 if inverse else e] * len(I))
        assert len(out) == len(U)
        return out

    data = {}
    for g in D12:
        hp = exact_hpoly(exps(g, Wp, True), dmax)
        hm = exact_hpoly(exps(g, Wm, True), dmax)
        trm = (0, 0)
        for e in exps(g, Wm, False):
            trm = zadd(trm, ZETA[e])
        trp = (0, 0)
        for e in exps(g, Wp, False):
            trp = zadd(trp, ZETA[e])
        data[g] = (hp, hm, trm, trp)
    out = {}
    for mm in range(dmax + 1):
        for d in range(mm, dmax + 1):
            s = (0, 0)
            sp = (0, 0)
            for g in D12:
                hp, hm, trm, trp = data[g]
                base = zmul(hp[d - mm], hm[mm])
                s = zadd(s, zmul(base, trm))
                sp = zadd(sp, zmul(base, trp))
            assert s[1] == 0 and sp[1] == 0 and s[0] % 12 == 0 and sp[0] % 12 == 0, (d, mm, s, sp)
            out[(d, mm)] = (s[0] // 12, sp[0] // 12)
    return out
