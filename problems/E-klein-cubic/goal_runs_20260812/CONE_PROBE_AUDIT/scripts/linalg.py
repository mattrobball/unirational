"""Own F_p linear algebra. No slicelib."""
import numpy as np


def inv_mod(a, p):
    return pow(int(a) % p, p - 2, p)


def rref_rank(M, p):
    A = np.array(M, dtype=np.int64) % p
    rows, cols = A.shape
    r = 0
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if A[i, c]:
                piv = i
                break
        if piv is None:
            continue
        A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * inv_mod(A[r, c], p)) % p
        col = A[r + 1:, c].copy()
        nz = np.nonzero(col)[0]
        if nz.size:
            A[r + 1 + nz] = (A[r + 1 + nz] - np.outer(col[nz], A[r])) % p
        r += 1
        if r == rows:
            break
    return r


def row_basis_indices(M, p):
    A = np.array(M, dtype=np.int64) % p
    rows, cols = A.shape
    selected = []
    r = 0
    row_idx = list(range(rows))
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if A[i, c]:
                piv = i
                break
        if piv is None:
            continue
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
            row_idx[r], row_idx[piv] = row_idx[piv], row_idx[r]
        A[r] = (A[r] * inv_mod(A[r, c], p)) % p
        below = A[r + 1:, c]
        nz = np.nonzero(below)[0]
        if nz.size:
            A[r + 1 + nz] = (A[r + 1 + nz] - np.outer(below[nz], A[r])) % p
        selected.append(row_idx[r])
        r += 1
        if r == rows:
            break
    return selected


def nullspace(M, p):
    """Right-null basis as rows."""
    A = np.array(M, dtype=np.int64) % p
    rows, cols = A.shape
    piv_cols = []
    r = 0
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if A[i, c]:
                piv = i
                break
        if piv is None:
            continue
        A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * inv_mod(A[r, c], p)) % p
        col = A[:, c].copy()
        col[r] = 0
        nz = np.nonzero(col)[0]
        if nz.size:
            A[nz] = (A[nz] - np.outer(col[nz], A[r])) % p
        piv_cols.append(c)
        r += 1
        if r == rows:
            break
    free = [c for c in range(cols) if c not in piv_cols]
    basis = []
    for f in free:
        v = np.zeros(cols, dtype=np.int64)
        v[f] = 1
        for i, c in enumerate(piv_cols):
            v[c] = (-A[i, f]) % p
        basis.append(v % p)
    if not basis:
        return np.zeros((0, cols), dtype=np.int64)
    return np.array(basis, dtype=np.int64)


def mat_inv(A, p):
    n = A.shape[0]
    M = np.concatenate([A % p, np.eye(n, dtype=np.int64)], axis=1)
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, n):
            if M[i, c]:
                piv = i
                break
        assert piv is not None, "singular"
        M[[r, piv]] = M[[piv, r]]
        M[r] = (M[r] * inv_mod(M[r, c], p)) % p
        col = M[:, c].copy()
        col[r] = 0
        nz = np.nonzero(col)[0]
        if nz.size:
            M[nz] = (M[nz] - np.outer(col[nz], M[r])) % p
        r += 1
    return M[:, n:] % p
