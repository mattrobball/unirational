#!/usr/bin/env python3
"""Exact/director-grade d=7 F55 landing-cone obstruction.

The support universe is certified by a binary MILP and then rechecked with
exact integer combinatorics.  The final obstruction is characteristic zero:
every support-admissible coefficient set contains a clean polar diamond whose
two landing equations differ by the multiplicity 2 coming from the squared
slot in T_i^2 T_{i+1}.

Requires scipy only for the finite support-universe MILP.  All returned MILP
supports and all polynomial identities are checked exactly over Z[mu_5].
"""
from __future__ import annotations

from collections import Counter, defaultdict

import numpy as np
from scipy.optimize import Bounds, LinearConstraint, milp
from scipy.sparse import csr_matrix, lil_matrix

WEIGHTS = (1, 9, 4, 3, 5)
D = 7
EXPECTED_MAX_SUPPORT = frozenset(
    (0, 2, 3, 6, 7, 9, 10, 11, 13, 14, 16, 18, 19, 21, 22, 23, 24, 27)
)
EXPECTED_FEASIBLE_COUNT = 32
EXPECTED_SIZE_DISTRIBUTION = Counter({16: 12, 15: 10, 17: 6, 14: 3, 18: 1})
DIAMOND_INDICES = frozenset((0, 2, 3, 23))
ROW1_EXP = (0, 0, 0, 14, 7)
ROW2_EXP = (0, 1, 1, 10, 9)
ROW1_KEYS = {(0, 0, 2), (0, 23, 23)}
ROW2_KEYS = {(0, 2, 3), (3, 23, 23)}


def monomials(d: int):
    out = []
    for e0 in range(d + 1):
        for e1 in range(d + 1 - e0):
            for e2 in range(d + 1 - e0 - e1):
                for e3 in range(d + 1 - e0 - e1 - e2):
                    e4 = d - e0 - e1 - e2 - e3
                    out.append((e0, e1, e2, e3, e4))
    return out


def weight(m):
    return sum(e * a for e, a in zip(m, WEIGHTS)) % 11


def shift(m):
    return (m[4], m[0], m[1], m[2], m[3])


def build_universal_rows():
    """Return base monomials and coefficient phase profiles.

    A profile c[0..4] represents sum_q c[q] zeta_5^q before applying the
    projective C5 twist s.  Coefficient triples are fully commutativized.
    """
    base = [m for m in monomials(D) if weight(m) == WEIGHTS[0]]
    assert len(base) == 30
    rows = defaultdict(lambda: defaultdict(lambda: [0] * 5))
    shifted = base
    for i in range(5):
        if i:
            shifted = [shift(m) for m in shifted]
        shifted_next = [shift(m) for m in shifted]
        phase = (3 * i + 1) % 5
        for k1 in range(len(base)):
            for k2 in range(len(base)):
                for k3 in range(len(base)):
                    out_exp = tuple(
                        shifted[k1][j] + shifted[k2][j] + shifted_next[k3][j]
                        for j in range(5)
                    )
                    key = tuple(sorted((k1, k2, k3)))
                    rows[out_exp][key][phase] += 1
    return base, rows


def cyclotomic_coeff(profile, s: int):
    """Exact coefficient in Z[zeta_5], basis 1,z,z^2,z^3.

    z^4 = -(1+z+z^2+z^3).  The zero test is therefore exact.
    """
    d = [0] * 5
    for q, c in enumerate(profile):
        d[(s * q) % 5] += c
    return tuple(d[j] - d[4] for j in range(4))


def rows_for_twist(universal_rows, s: int):
    out = {}
    for exp, row in universal_rows.items():
        rr = {key: cyclotomic_coeff(prof, s) for key, prof in row.items()}
        rr = {key: cf for key, cf in rr.items() if any(cf)}
        if rr:
            out[exp] = rr
    return out


def support_signature(rows):
    """Signature relevant to the no-singleton support condition."""
    return sorted(
        tuple(sorted(tuple(sorted(set(key))) for key in row))
        for row in rows.values()
    )


def build_support_milp(rows, n: int, extra_rows=None):
    """MILP for nonempty S with every landing row having 0 or >=2 terms."""
    row_counters = []
    all_masks = set()
    for row in rows.values():
        ctr = Counter()
        for key in row:
            mask = 0
            for k in set(key):
                mask |= 1 << k
            ctr[mask] += 1
            all_masks.add(mask)
        row_counters.append(ctr)

    all_masks = sorted(all_masks)
    mask_index = {m: i for i, m in enumerate(all_masks)}
    nm = len(all_masks)
    nr = len(row_counters)
    total_variables = n + nm + nr
    specs = []
    lower = []
    upper = []

    # y_m = AND_{i in m} x_i.
    for j, mask in enumerate(all_masks):
        y = n + j
        ids = [i for i in range(n) if (mask >> i) & 1]
        for i in ids:
            specs.append({y: 1, i: -1})
            lower.append(-np.inf)
            upper.append(0)
        row = {y: 1}
        for i in ids:
            row[i] = row.get(i, 0) - 1
        specs.append(row)
        lower.append(-(len(ids) - 1))
        upper.append(np.inf)

    # count_e = 0 or >=2, selected by binary z_e.
    for e, ctr in enumerate(row_counters):
        z = n + nm + e
        big_m = sum(ctr.values())
        row = {n + mask_index[m]: c for m, c in ctr.items()}
        row[z] = -big_m
        specs.append(row)
        lower.append(-np.inf)
        upper.append(0)
        row = {n + mask_index[m]: c for m, c in ctr.items()}
        row[z] = -2
        specs.append(row)
        lower.append(0)
        upper.append(np.inf)

    # Nonempty support.
    specs.append({i: 1 for i in range(n)})
    lower.append(1)
    upper.append(np.inf)

    if extra_rows:
        for row, lo, hi in extra_rows:
            specs.append(dict(row))
            lower.append(lo)
            upper.append(hi)

    matrix = lil_matrix((len(specs), total_variables), dtype=float)
    for r, spec in enumerate(specs):
        for c, value in spec.items():
            matrix[r, c] = value
    return (
        csr_matrix(matrix),
        np.array(lower, dtype=float),
        np.array(upper, dtype=float),
        total_variables,
        row_counters,
    )


def solve_support_milp(rows, n: int, maximize=True, extra_rows=None):
    matrix, lo, hi, total_variables, row_counters = build_support_milp(
        rows, n, extra_rows
    )
    objective = np.zeros(total_variables)
    if maximize:
        objective[:n] = -1
    integrality = np.ones(total_variables, dtype=np.int8)
    result = milp(
        objective,
        integrality=integrality,
        bounds=Bounds(np.zeros(total_variables), np.ones(total_variables)),
        constraints=LinearConstraint(matrix, lo, hi),
        options={"presolve": True, "mip_rel_gap": 0.0, "time_limit": 180},
    )
    if result.x is None:
        return None, result, row_counters
    support = frozenset(i for i in range(n) if result.x[i] > 0.5)
    return support, result, row_counters


def exact_support_ok(support, row_counters):
    support_mask = sum(1 << i for i in support)
    for counter in row_counters:
        active = sum(
            multiplicity
            for mask, multiplicity in counter.items()
            if mask & ~support_mask == 0
        )
        if active == 1:
            return False
    return bool(support)


def enumerate_subsupports(max_support, row_counters):
    ids = sorted(max_support)
    local_rows = []
    global_mask = sum(1 << i for i in ids)
    position = {value: j for j, value in enumerate(ids)}
    for counter in row_counters:
        row = Counter()
        for mask, multiplicity in counter.items():
            if mask & ~global_mask:
                continue
            local_mask = 0
            for i in ids:
                if (mask >> i) & 1:
                    local_mask |= 1 << position[i]
            row[local_mask] += multiplicity
        if row:
            local_rows.append(tuple(row.items()))

    feasible = []
    for support_mask in range(1, 1 << len(ids)):
        ok = True
        for row in local_rows:
            active = 0
            for mask, multiplicity in row:
                if mask & ~support_mask == 0:
                    active += multiplicity
            if active == 1:
                ok = False
                break
        if ok:
            feasible.append(
                frozenset(
                    ids[j] for j in range(len(ids)) if (support_mask >> j) & 1
                )
            )
    return feasible


def active_keys(row, support):
    return {key for key in row if set(key) <= support}


def monomial_text(key):
    counts = Counter(key)
    factors = []
    for i in sorted(counts):
        factors.append(f"A{i}" if counts[i] == 1 else f"A{i}^{counts[i]}")
    return "*".join(factors)


def main():
    base, universal = build_universal_rows()
    twisted = [rows_for_twist(universal, s) for s in range(5)]

    # Exact support structure is the same for all five projective twists.
    signatures = [support_signature(rows) for rows in twisted]
    assert all(signature == signatures[0] for signature in signatures[1:])
    rows = twisted[0]

    max_support, result, row_counters = solve_support_milp(
        rows, len(base), maximize=True
    )
    assert max_support is not None, result.message
    assert exact_support_ok(max_support, row_counters)
    assert max_support == EXPECTED_MAX_SUPPORT, sorted(max_support)

    # Ask for any feasible support using an index outside the maximal support.
    # HiGHS returns infeasible; all finite objects returned by the solver are
    # subsequently rechecked over the integers.
    outside = [i for i in range(len(base)) if i not in max_support]
    extra = [({i: 1 for i in outside}, 1, np.inf)]
    escaped, escape_result, _ = solve_support_milp(
        rows, len(base), maximize=False, extra_rows=extra
    )
    assert escaped is None, sorted(escaped) if escaped else escape_result.message

    feasible = enumerate_subsupports(max_support, row_counters)
    assert len(feasible) == EXPECTED_FEASIBLE_COUNT
    assert Counter(map(len, feasible)) == EXPECTED_SIZE_DISTRIBUTION
    intersection = set.intersection(*(set(support) for support in feasible))
    assert DIAMOND_INDICES <= intersection

    for rows_s in twisted:
        row1 = rows_s[ROW1_EXP]
        row2 = rows_s[ROW2_EXP]
        for support in feasible:
            assert active_keys(row1, support) == ROW1_KEYS
            assert active_keys(row2, support) == ROW2_KEYS

        assert universal[ROW1_EXP][(0, 0, 2)] == [0, 1, 0, 0, 0]
        assert universal[ROW1_EXP][(0, 23, 23)] == [0, 0, 0, 1, 0]
        assert universal[ROW2_EXP][(0, 2, 3)] == [0, 2, 0, 0, 0]
        assert universal[ROW2_EXP][(3, 23, 23)] == [0, 0, 0, 1, 0]

    print("d=7 coefficient space dimension:", len(base))
    print("unique maximal support:", sorted(max_support))
    print("all support-admissible subsets:", len(feasible))
    print("size distribution:", dict(sorted(EXPECTED_SIZE_DISTRIBUTION.items())))
    print("common support indices:", sorted(intersection))
    print("diamond coefficient monomials:")
    print("  row 1:", monomial_text((0, 0, 2)), "+", monomial_text((0, 23, 23)))
    print(
        "  row 2:",
        "2*" + monomial_text((0, 2, 3)),
        "+",
        monomial_text((3, 23, 23)),
    )
    print("for twist s, the exact equations are")
    print("  zeta^s A0^2 A2 + zeta^(3s) A0 A23^2 = 0")
    print("  2 zeta^s A0 A2 A3 + zeta^(3s) A3 A23^2 = 0")
    print("the saturated-ideal certificate is")
    print("  A0*(row 2) - 2*A3*(row 1) = -zeta^(3s) A0*A3*A23^2")
    print("so the landing ideal contains a monomial on every admissible support torus")
    print("F55_D7_PHASE_HOLONOMY_OK")


if __name__ == "__main__":
    main()
