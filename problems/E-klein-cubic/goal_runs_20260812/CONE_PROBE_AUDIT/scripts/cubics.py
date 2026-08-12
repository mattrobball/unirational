"""Independent expansion of F(sum_i t_i v_i) as a cubic in t.

F = sum_{k=0..4} y_k^2 y_{k+1}.  The coefficient of the monomial
t_a t_b t_c (written as a product, no multinomial denominator) is
collected from the full (i,j,ell) tensor of the two A-slots and one B-slot.
This is a different loop order from the director's i<=j / multiplicity code.
"""
import itertools
import numpy as np

from frame import klein_F


def nmon3(m):
    return m * (m + 1) * (m + 2) // 6


def monomials3(m):
    return list(itertools.combinations_with_replacement(range(m), 3))


def cubic_rows(V, basis, p):
    """Rows: one sample point. Columns: combinations_with_replacement monomials.

    V: (nseeds, npts, 5); basis: (m, nseeds).
    """
    m = basis.shape[0]
    v = np.tensordot(basis % p, V % p, axes=(1, 0)) % p  # (m, npts, 5)
    npts = v.shape[1]
    mons = monomials3(m)
    idx = {t: n for n, t in enumerate(mons)}
    out = np.zeros((npts, len(mons)), dtype=np.int64)
    for k in range(5):
        Ak = v[:, :, k] % p
        Bk = v[:, :, (k + 1) % 5] % p
        for i in range(m):
            for j in range(m):
                base = (Ak[i] * Ak[j]) % p
                for ell in range(m):
                    trip = tuple(sorted((i, j, ell)))
                    out[:, idx[trip]] = (out[:, idx[trip]] + base * Bk[ell]) % p
    return out % p, mons


def eval_form(row, mons, t, p):
    s = 0
    t = np.array(t, dtype=np.int64) % p
    for n, (a, b, c) in enumerate(mons):
        cf = int(row[n]) % p
        if cf:
            s += cf * int(t[a]) * int(t[b]) * int(t[c])
    return s % p


def F_linear_combo(v_at_x, t, p):
    """v_at_x: (m, 5); y = sum t_i v_i; return F(y)."""
    y = (np.array(t, dtype=np.int64) % p) @ (v_at_x % p)
    return klein_F(y % p, p)


def mon_name(triple):
    cnt = {}
    for i in triple:
        cnt[i] = cnt.get(i, 0) + 1
    parts = []
    for i in sorted(cnt):
        e = cnt[i]
        name = "t%d" % (i + 1)
        parts.append(name if e == 1 else "%s^%d" % (name, e))
    return "*".join(parts)


def write_msolve(path, rows, mons, m, p):
    n = 0
    with open(path, "w") as f:
        f.write(",".join("t%d" % (i + 1) for i in range(m)) + "\n")
        f.write("%d\n" % p)
        first = True
        for row in rows:
            terms = []
            for k, cf in enumerate(row):
                c = int(cf) % p
                if c:
                    terms.append("%d*%s" % (c, mon_name(mons[k])))
            if not terms:
                continue
            if not first:
                f.write(",\n")
            f.write("+".join(terms))
            first = False
            n += 1
        f.write("\n")
    return n
