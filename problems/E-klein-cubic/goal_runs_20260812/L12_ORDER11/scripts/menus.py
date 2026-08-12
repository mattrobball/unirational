"""The bounded fibre-trace menu at order 11 (C7 / Riemann-Hurwitz), and the pass.

For a fibre C_j that is a smooth projective curve with a faithful C11 action,
holomorphic Lefschetz on the curve gives

        tr_j = chi_g(C_j, O) = sum_{y in C_j^g} 1 / (1 - zeta^{-u_y})

with u_y the rotation number at y and b = #C_j^g the number of fixed points.
Riemann-Hurwitz (C7) for an 11-curve: 2p_a - 2 = 11(2*gamma' - 2) + 10 b, so
p_a = 11*gamma' - 10 + 5b; the menu is FINITE once b is bounded, and b is
bounded by the sealed Smith count n_x (equal at all five points, = 4 on the
sealed 20-point model, = 4 + Delta/5 on a refinement).  This is why the menu
is presented as MENU_b for each b, with the Smith constraint "b the same at
all five receiver points" imposed.

The menu is NOT finite without such a bound: MENU_b grows with b, and C1's
genus identity at d = 35 (2g-2 = 65 nu + sum (a_E - 2 m_E) e_E) bounds the
GENERIC fibre genus, not the genus of the five special C11-fibres.  Stated,
not papered over (FLAG-M).

TIER: B.  Smooth-fibre holomorphic Lefschetz is a MODEL for the derived fibre
of flag 5; reducible / non-reduced / derived fibres need the full
chi_g(Z_x, O) and are carried as unknowns, not assumed away.
"""
from itertools import combinations_with_replacement

import cyclo as C
import l12core as L

N = 11


def menu(b):
    """MENU_b as a set of canonical tuples, plus the map back to weights."""
    terms = {u: C.inv(C.one_minus_zpow(-u)) for u in range(1, N)}
    out = {}
    for combo in combinations_with_replacement(range(1, N), b):
        s = C.total([terms[u] for u in combo])
        out.setdefault(tuple(s), []).append(combo)
    return out


_CACHE = {}


def menu_cached(b):
    if b not in _CACHE:
        _CACHE[b] = menu(b)
    return _CACHE[b]


def admissible_b(traces, bmax=8):
    """b values for which ALL five traces lie in MENU_b (Smith: b constant)."""
    ok = []
    for b in range(1, bmax + 1):
        m = menu_cached(b)
        if all(tuple(t) in m for t in traces):
            ok.append(b)
    return ok


def integral_menu(b):
    """The sub-menu of algebraic integers (necessary for a genuine trace)."""
    m = menu_cached(b)
    return {k: v for k, v in m.items() if C.is_alg_int(k)}
