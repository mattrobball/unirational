"""LAND: the landing identity F(T_c) == 0 and its sampled cubic system.

Works over F_p and over an extension F_{p^k} given by a multiplication table
(k x k x k) so that the branch spaces of plane.py can be tested directly.
"""
import itertools, subprocess, os, re
import numpy as np
from a5lib import mm, monmat, monlist, klein_F, rref


# ------------------------------------------------------------ F_{p^k} helpers
def ext_table(Th, k, p):
    """multiplication tensor Mtab[i,j,:] = theta^i * theta^j in basis (1,..,th^{k-1})"""
    P = [np.eye(k)]
    for _ in range(1, k):
        P.append(mm(P[-1], Th, p))
    e0 = np.zeros(k); e0[0] = 1
    pw = [mm(P[i], e0[:, None], p).ravel() for i in range(k)]      # theta^i coords
    tab = np.zeros((k, k, k))
    for i in range(k):
        for j in range(k):
            # theta^i * theta^j  = P[i] applied to theta^j
            tab[i, j] = mm(P[i], pw[j][:, None], p).ravel() % p
    return tab


def emul(a, b, tab, p):
    """product of ext elements given as (..., k) coefficient arrays"""
    return np.einsum('...i,...j,ijl->...l', a, b, tab) % p


# ---------------------------------------------------------- the cubic system
def _mon_index(r):
    """cubic monomials c_u c_v c_w (u<=v<=w) with the symmetrisation weights"""
    monsl = list(itertools.combinations_with_replacement(range(r), 3))
    U = np.array([m[0] for m in monsl])
    V = np.array([m[1] for m in monsl])
    W = np.array([m[2] for m in monsl])
    mult = np.array([1 if len(set(m)) == 3 else (2 if len(set(m)) == 2 else 6)
                     for m in monsl])
    return monsl, U, V, W, mult


def cubic_rows(Bmaps, mons, p, npts, rng, tab=None):
    """Bmaps: (r, 5, N) over F_p (tab=None) or (r, 5, N, k) over F_{p^k}.

    Returns (rows, monsl): rows[e] holds the coefficients of the cubic
    F(sum_l lam_l B_l)(x_e) in the lam's -- scalars over F_p, or length-k
    vectors over F_{p^k} when tab is given (one row per sample point)."""
    r = Bmaps.shape[0]
    monsl, U, V, W, mult = _mon_index(r)
    inv = np.array([pow(int(m), p - 2, p) for m in mult], dtype=np.float64)
    rows = []
    for _ in range(npts):
        x = rng.integers(0, p, size=5).astype(np.float64)
        mx = monmat([x], mons, p)[0]
        if tab is None:
            M = np.tensordot(Bmaps, mx, axes=([2], [0])) % p              # r x 5
            C3 = np.zeros((r, r, r))
            for i in range(5):
                u, v = M[:, i], M[:, (i + 1) % 5]
                C3 = (C3 + np.einsum('u,v,w->uvw', u, u, v)) % p
        else:
            k = Bmaps.shape[3]
            M = np.einsum('linj,n->lij', Bmaps, mx) % p                   # r x 5 x k
            C3 = np.zeros((r, r, r, k))
            for i in range(5):
                u, v = M[:, i, :], M[:, (i + 1) % 5, :]
                uu = emul(u[:, None, :], u[None, :, :], tab, p)
                C3 = (C3 + emul(uu[:, :, None, :], v[None, None, :, :], tab, p)) % p
        S = np.zeros_like(C3)
        for perm in itertools.permutations(range(3)):
            ax = list(perm) + ([3] if tab is not None else [])
            S = (S + np.transpose(C3, ax)) % p
        vals = S[U, V, W] % p
        if tab is None:
            rows.append((vals * inv) % p)
        else:
            rows.append((vals * inv[:, None]) % p)
    return rows, monsl


def write_ms(rows, monsl, r, p, path, extra_gens=()):
    names = ','.join('c%d' % i for i in range(r))
    polys = []
    for row in rows:
        terms = ['%d*c%d*c%d*c%d' % (int(c) % p, u, v, w)
                 for c, (u, v, w) in zip(row, monsl) if int(c) % p]
        if terms:
            polys.append('+'.join(terms))
    polys.extend(extra_gens)
    if not polys:
        polys = ['0']
    src = names + '\n' + str(p) + '\n' + ',\n'.join(polys) + '\n'
    assert '(' not in src, 'msolve parenthesis landmine'
    open(path, 'w').write(src)
    return len(polys)


def minpoly_of(tab, p):
    """minimal polynomial of theta for a single-block subfield with basis
    (1, th, ..., th^{k-1}): th^k = sum_j tab[k-1,1,j] th^j."""
    k = tab.shape[0]
    if k == 1:
        return None
    co = [int(v) % p for v in tab[k - 1, 1]]
    terms = ['1*th^%d' % k] + ['%d*th^%d' % ((-co[j]) % p, j) for j in range(k) if co[j] % p]
    return '+'.join(t if not t.endswith('^0') else t[:-2] for t in terms)


def write_ms_ext(rows, monsl, r, p, tab, path):
    """extension branch: keep theta as a variable with its minimal polynomial,
    so the system has r+1 variables instead of r*k."""
    k = tab.shape[0]
    names = ','.join('c%d' % i for i in range(r)) + ',th'
    polys = []
    for row in rows:                                  # row: (nmons, k)
        terms = []
        for co, (u, v, w) in zip(row, monsl):
            for j in range(k):
                cj = int(co[j]) % p
                if cj:
                    th = '' if j == 0 else ('*th' if j == 1 else '*th^%d' % j)
                    terms.append('%d*c%d*c%d*c%d%s' % (cj, u, v, w, th))
        if terms:
            polys.append('+'.join(terms))
    mp = minpoly_of(tab, p)
    if mp:
        polys.append(mp)
    if not polys:
        polys = ['0']
    src = names + '\n' + str(p) + '\n' + ',\n'.join(polys) + '\n'
    assert '(' not in src, 'msolve parenthesis landmine'
    open(path, 'w').write(src)
    return len(polys)


def run_msolve(path, out, timeout, gb=True, threads=4):
    cmd = ['msolve', '-t', str(threads)] + (['-g', '2'] if gb else []) + \
          ['-f', path, '-o', out]
    try:
        subprocess.run(cmd, check=True, timeout=timeout,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    except subprocess.TimeoutExpired:
        return 'TIMEOUT', ''
    except subprocess.CalledProcessError as e:
        return 'ERROR rc=%s' % e.returncode, ''
    if not os.path.exists(out) or os.path.getsize(out) == 0:
        return 'ERROR 0-byte output', ''
    body = ''.join(l for l in open(out) if not l.startswith('#')).strip()
    if len(body) == 0:
        return 'ERROR empty body', ''
    return 'OK', body


def gb_verdict(body, r):
    """EMPTY iff every c_i occurs in the reduced GB as a bare linear generator
    (so the only solution has c = 0), or the ideal is the unit ideal."""
    b = body.strip().rstrip(':').strip()
    if b in ('[1]', '[-1]'):
        return 'UNIT'
    gens = re.findall(r'(?:\[|,)\s*1\*c(\d+)\^1\s*(?=[,\]])', body)
    if set(map(int, gens)) == set(range(r)):
        return 'EMPTY'
    return 'NONEMPTY-OR-UNRESOLVED'


# -------------------------------------------------------- exact identity test
def _dense(C, d, mons, k=1):
    """(5, N[, k]) monomial coefficients -> dense tensors of shape (5, (d+1)^5[, k])"""
    shape = (5,) + (d + 1,) * 5 + ((k,) if k > 1 else ())
    D = np.zeros(shape)
    for j, m in enumerate(mons):
        D[(slice(None),) + m] = C[:, j] if k == 1 else C[:, j, :]
    return D


def full_identity(C, p, d=None, tab=None, verbose=False):
    """EXACT test of the polynomial identity F(T) == 0.

    F(T) is a form of degree D = 3d with degree <= D in each variable, so it
    vanishes identically iff it vanishes on a grid S^5 with |S| = D+1 <= p
    (combinatorial nullstellensatz / DeMillo-Lipton-Schwartz with |S| > deg_j).
    Grid evaluation is done by tensor contraction, chunked over x_0.

    C = (5, N) over F_p, or (5, N, k) over F_{p^k} with multiplication table
    `tab`.  Returns (is_identity, n_nonzero_grid_values, n_grid_points)."""
    N = C.shape[1]
    k = 1 if tab is None else C.shape[2]
    if d is None:
        d = _degree_from_N(N)
    D = 3 * d
    assert D + 1 <= p, 'grid needs D+1 <= p'
    S = np.arange(D + 1, dtype=np.float64)
    V = np.array([[pow(int(s), e, p) for e in range(d + 1)] for s in S],
                 dtype=np.float64)                                    # |S| x (d+1)
    mons = monlist(d)
    T = _dense(np.asarray(C, dtype=np.float64) % p, d, mons, k)       # 5 x (d+1)^5 [x k]
    nz, npts = 0, (D + 1) ** 5
    for i0 in range(D + 1):
        # contract axis 0 with row i0, then the remaining four axes fully
        A = np.tensordot(T, V[i0], axes=([1], [0])) % p               # 5 x (d+1)^4 [x k]
        for _ax in range(4):
            A = np.tensordot(A, V, axes=([1], [1])) % p
        if k > 1:                       # 5 x k x |S|^4  ->  5 x |S|^4 x k
            A = np.moveaxis(A, 1, -1)
        # A: 5 x |S| x |S| x |S| x |S| [x k]
        if k == 1:
            f = np.zeros(A.shape[1:])
            for i in range(5):
                f = (f + A[i] * A[i] % p * A[(i + 1) % 5]) % p
        else:
            f = np.zeros(A.shape[1:])
            for i in range(5):
                sq = emul(A[i], A[i], tab, p)
                f = (f + emul(sq, A[(i + 1) % 5], tab, p)) % p
        nz += int(np.count_nonzero(f % p))
    return nz == 0, nz, npts


def _degree_from_N(N):
    d = 0
    while (d + 4) * (d + 3) * (d + 2) * (d + 1) // 24 != N:
        d += 1
        assert d < 200
    return d
