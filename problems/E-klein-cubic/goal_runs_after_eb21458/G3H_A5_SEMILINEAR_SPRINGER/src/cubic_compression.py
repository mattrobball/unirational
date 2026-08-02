#!/usr/bin/env python3
"""Unique A5-equivariant cubic compression Y: W → U (dim Hom = 1)."""

from __future__ import annotations

from fractions import Fraction
from itertools import combinations, product
from typing import Sequence

from a5_modules import (
    PERMS,
    all_target_matrices,
    base,
    exact_source_representation,
)
from q5_arith import (
    ONE,
    ZERO,
    q5_to_json,
    qadd,
    qinv,
    qiszero,
    qmul,
    qscale,
    qsub,
    sum_q5,
)

# Exponent vectors of degree-3 monomials in 5 variables (lex).
EXPS: list[tuple[int, ...]] = sorted(
    e for e in product(range(4), repeat=5) if sum(e) == 3
)
assert len(EXPS) == 35
N_MON = 35
N_OUT = 3
N_Q5 = N_OUT * N_MON
N = 2 * N_Q5  # Q-dimension of coefficient space


def idx(out: int, mon: int, part: int) -> int:
    return 2 * (out * N_MON + mon) + part


def expand_monomial_at_linear(exp: Sequence[int], M: Sequence[Sequence[int]]):
    """Expand ∏_i (∑_j M[i][j] w_j)^{exp[i]} as {exponent: int_coeff}."""
    poly = {(0, 0, 0, 0, 0): 1}
    for i in range(5):
        e = exp[i]
        if e == 0:
            continue
        lin = {}
        for j in range(5):
            if M[i][j]:
                bas = [0] * 5
                bas[j] = 1
                lin[tuple(bas)] = M[i][j]
        pw = {(0, 0, 0, 0, 0): 1}
        for _ in range(e):
            new = {}
            for ea, ca in pw.items():
                for eb, cb in lin.items():
                    ec = tuple(ea[k] + eb[k] for k in range(5))
                    new[ec] = new.get(ec, 0) + ca * cb
            pw = new
        newp = {}
        for ea, ca in poly.items():
            for eb, cb in pw.items():
                ec = tuple(ea[k] + eb[k] for k in range(5))
                newp[ec] = newp.get(ec, 0) + ca * cb
        poly = newp
    return poly


def build_action_tables(target):
    return {
        g: [expand_monomial_at_linear(EXPS[m], target[g]) for m in range(N_MON)]
        for g in PERMS
    }


def rref(mat: list[list[Fraction]]):
    A = [row[:] for row in mat]
    m = len(A)
    if m == 0:
        return A, []
    n = len(A[0])
    pivots = []
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, m):
            if A[i][c] != 0:
                piv = i
                break
        if piv is None:
            continue
        A[r], A[piv] = A[piv], A[r]
        pv = A[r][c]
        A[r] = [x / pv for x in A[r]]
        for i in range(m):
            if i != r and A[i][c] != 0:
                f = A[i][c]
                A[i] = [A[i][j] - f * A[r][j] for j in range(n)]
        pivots.append(c)
        r += 1
        if r == m:
            break
    A = [row for row in A if any(x for x in row)]
    return A, pivots


def equivariance_rows(source, action, gens):
    rows: list[list[Fraction]] = []
    for g in gens:
        sigma = source[g]
        rho_act = action[g]
        for e_idx in range(N_MON):
            for r in range(N_OUT):
                row0 = [Fraction(0)] * N
                row1 = [Fraction(0)] * N

                def add_q5_times_var(out, mon, qcoef, sign=1, row0=row0, row1=row1):
                    qa, qb = qcoef
                    ia = idx(out, mon, 0)
                    ib = idx(out, mon, 1)
                    s = sign
                    row0[ia] += s * qa
                    row0[ib] += s * 5 * qb
                    row1[ia] += s * qb
                    row1[ib] += s * qa

                for m in range(N_MON):
                    A = rho_act[m].get(EXPS[e_idx], 0)
                    if A:
                        add_q5_times_var(r, m, (Fraction(A), Fraction(0)), 1)
                for s in range(N_OUT):
                    sig = sigma[r][s]
                    if not qiszero(sig):
                        add_q5_times_var(s, e_idx, sig, -1)
                if any(x for x in row0):
                    rows.append(row0)
                if any(x for x in row1):
                    rows.append(row1)
    return rows


def nullspace(R, pivots):
    free = [c for c in range(N) if c not in pivots]
    basis = []
    for f in free:
        vec = [Fraction(0)] * N
        vec[f] = Fraction(1)
        for row in R:
            pc = next(i for i, x in enumerate(row) if x != 0)
            s = sum((row[j] * vec[j] for j in free), Fraction(0))
            vec[pc] = -s
        basis.append(vec)
    return free, basis


def vec_to_Y(vec):
    Y = []
    for out in range(N_OUT):
        row = []
        for mon in range(N_MON):
            a = vec[idx(out, mon, 0)]
            b = vec[idx(out, mon, 1)]
            row.append((a, b))
        Y.append(row)
    return Y


def first_nonzero(Y):
    for o in range(N_OUT):
        for m in range(N_MON):
            if not qiszero(Y[o][m]):
                return o, m, Y[o][m]
    return None


def normalize_Y(Y):
    loc = first_nonzero(Y)
    if loc is None:
        raise ValueError("zero map")
    inv = qinv(loc[2])
    return [[qmul(inv, Y[o][m]) for m in range(N_MON)] for o in range(N_OUT)]


def mon_val(exp, w):
    v = ONE
    for i in range(5):
        for _ in range(exp[i]):
            wi = w[i] if isinstance(w[i], tuple) else (Fraction(w[i]), Fraction(0))
            v = qmul(v, wi)
    return v


def eval_Y(Y, w):
    out = []
    for r in range(N_OUT):
        s = ZERO
        for m, e in enumerate(EXPS):
            if not qiszero(Y[r][m]):
                s = qadd(s, qmul(Y[r][m], mon_val(e, w)))
        out.append(s)
    return out


def jacobian_Y(Y, w):
    J = [[ZERO] * 5 for _ in range(3)]
    for r in range(3):
        for i in range(5):
            s = ZERO
            for m, e in enumerate(EXPS):
                if e[i] == 0 or qiszero(Y[r][m]):
                    continue
                ep = list(e)
                ep[i] -= 1
                s = qadd(s, qmul(qscale(e[i], Y[r][m]), mon_val(tuple(ep), w)))
            J[r][i] = s
    return J


def det3(A):
    def mul(a, b):
        return qmul(a, b)

    def add(a, b):
        return qadd(a, b)

    def sub(a, b):
        return qsub(a, b)

    return add(
        mul(A[0][0], sub(mul(A[1][1], A[2][2]), mul(A[1][2], A[2][1]))),
        add(
            mul(A[0][1], sub(mul(A[1][2], A[2][0]), mul(A[1][0], A[2][2]))),
            mul(A[0][2], sub(mul(A[1][0], A[2][1]), mul(A[1][1], A[2][0]))),
        ),
    )


def find_nonzero_minor(Y, trials=30):
    for trial in range(trials):
        w = [trial + 1, trial * 2 + 3, trial * 3 + 1, trial + 7, trial * 5 + 2]
        J = jacobian_Y(Y, w)
        for cols in combinations(range(5), 3):
            minor = [[J[r][c] for c in cols] for r in range(3)]
            d = det3(minor)
            if not qiszero(d):
                return {
                    "point": w,
                    "columns": list(cols),
                    "determinant": q5_to_json(d),
                }
    return None


def formal_equivariance_failures(Y, source, action, sample_g=None):
    gs = sample_g if sample_g is not None else list(PERMS)
    bad = 0
    checks = 0
    for g in gs:
        sigma = source[g]
        rho_act = action[g]
        for e_idx in range(N_MON):
            e = EXPS[e_idx]
            for r in range(N_OUT):
                checks += 1
                acc = ZERO
                for m in range(N_MON):
                    A = rho_act[m].get(e, 0)
                    if A:
                        acc = qadd(acc, qscale(A, Y[r][m]))
                for s in range(N_OUT):
                    acc = qsub(acc, qmul(sigma[r][s], Y[s][e_idx]))
                if not qiszero(acc):
                    bad += 1
    return bad, checks


def compute_cubic_compression(sign_sqrt5: int = 1):
    source = exact_source_representation(sign_sqrt5=sign_sqrt5)
    target = all_target_matrices()
    action = build_action_tables(target)
    gens = [base.PA, base.PB]
    rows = equivariance_rows(source, action, gens)
    R, pivots = rref(rows)
    free, null = nullspace(R, pivots)
    if len(null) != 2:
        raise RuntimeError(f"expected Q-nullity 2 (Hom dim 1 over Q5), got {len(null)}")
    Y = normalize_Y(vec_to_Y(null[0]))
    # If first basis vector vanishes after projection issues, try linear combo
    if first_nonzero(Y) is None:
        Y = normalize_Y(vec_to_Y(null[1]))
    minor = find_nonzero_minor(Y)
    if minor is None:
        raise RuntimeError("no nonzero Jacobian minor found")
    bad, checks = formal_equivariance_failures(Y, source, action, sample_g=list(PERMS))
    if bad:
        raise RuntimeError(f"equivariance failed on {bad}/{checks}")
    nnz = sum(1 for o in range(3) for m in range(35) if not qiszero(Y[o][m]))
    coeffs = []
    for o in range(3):
        for m, e in enumerate(EXPS):
            if not qiszero(Y[o][m]):
                coeffs.append(
                    {
                        "output": o,
                        "exponents": list(e),
                        "coeff": q5_to_json(Y[o][m]),
                    }
                )
    return {
        "sign_sqrt5": sign_sqrt5,
        "hom_dimension_over_Q5": 1,
        "q_rank_of_constraints": len(pivots),
        "q_nullity": len(null),
        "free_variables": free,
        "normalization": "first nonzero coefficient scaled to 1 in Q(sqrt(5))",
        "nonzero_coefficient_count": nnz,
        "coefficients": coeffs,
        "jacobian_minor": minor,
        "equivariance_checks": {"failures": bad, "checks": checks, "group_order": 60},
        "source_module": "icosahedral 3 over Q(sqrt(5))"
        + (" (conjugate 3')" if sign_sqrt5 == -1 else ""),
        "target_module": "rational A5-augmentation 5 (six Sylow-5s)",
        "monomial_basis_exponents": [list(e) for e in EXPS],
        "Y": Y,  # in-memory only; strip before JSON
        "source": source,
        "target": target,
        "action": action,
    }


def Y_from_coeff_list(coeffs, exps=None):
    exps = exps or EXPS
    exp_index = {tuple(e): i for i, e in enumerate(exps)}
    Y = [[ZERO for _ in range(N_MON)] for _ in range(N_OUT)]
    for item in coeffs:
        m = exp_index[tuple(item["exponents"])]
        c = item["coeff"]
        Y[item["output"]][m] = (
            Fraction(c["rational"][0], c["rational"][1]),
            Fraction(c["sqrt5"][0], c["sqrt5"][1]),
        )
    return Y
