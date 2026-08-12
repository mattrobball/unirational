"""Proposition PIN: which G-invariant divisors on X can miss a pinned point.

Everything is done in the Klein normal form F = sum_i x_i^2 x_{i+1} (i mod 5),
in which

  * the order-11 element tau : x_i -> zeta_11^{b_i} x_i with b_i = (-2)^i is a
    symmetry of F (derived, not assumed: 2 b_i + b_{i+1} = 0);
  * the order-5 element sigma : x_i -> x_{i+1} is a symmetry of F;
  * the five C11-fixed points of P(W) are the coordinate points [e_c], all five
    of which lie on X;
  * the five C5-fixed points of P(W) are [v_j], v_j = sum_i zeta_5^{-ij} e_i,
    of which [v_0] is OFF X and [v_1..v_4] are ON X (verified below) -- exactly
    the sealed 4-point count with weights 1,2,3,4.

Output: the weight obstruction (Proposition PIN), and, at the minimal degree
k = 5 where a_k > 0, the explicit unique invariant and its values at the pinned
points.
"""

import json
import os
import sys
from itertools import product

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import cyclo  # noqa: E402

P11, P5 = 11, 5
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "results")

B = [pow(-2, i, P11) for i in range(5)]           # tau-weights of x_0..x_4


def monomials(k):
    for a in product(range(k + 1), repeat=5):
        if sum(a) == k:
            yield a


def tau_weight(a):
    return sum(ai * bi for ai, bi in zip(a, B)) % P11


def shift(a):
    """sigma: x_i -> x_{i+1} sends x^a to x^{shift(a)}."""
    return tuple(a[(i - 1) % 5] for i in range(5))


def sigma_orbits(mons):
    seen, orbs = set(), []
    for m in mons:
        if m in seen:
            continue
        o, cur = [], m
        for _ in range(5):
            o.append(cur)
            seen.add(cur)
            cur = shift(cur)
        orbs.append(sorted(set(o)))
    return orbs


def eval_at_v(orbit, j, N=P5):
    """Value of the orbit-sum invariant at v_j = (1, z^-j, ..., z^-4j),
    exactly in Z[zeta_5].  Each monomial contributes zeta_5^{-j*sum(i*a_i)}."""
    v = [0] * N
    for a in orbit:
        e = (-j * sum(i * ai for i, ai in enumerate(a))) % N
        v[e] += 1
    return v


def main():
    log = {"tau_weights_b": B}

    # --- F itself: degree 3, weight 0, sigma-stable
    m3 = [a for a in monomials(3) if tau_weight(a) == 0]
    o3 = sigma_orbits(m3)
    log["deg3_weight0_monomials"] = len(m3)
    log["deg3_C11C5_invariant_dim"] = len(o3)
    log["deg3_orbit"] = [list(a) for a in o3[0]] if o3 else []
    assert len(o3) == 1, o3
    assert sorted(o3[0]) == sorted(
        tuple(2 * (t == i) + (t == (i + 1) % 5) for t in range(5)) for i in range(5)), o3[0]

    # --- the C5-fixed points: which lie on X
    onX = {}
    for j in range(5):
        val = eval_at_v(o3[0], j)
        onX[j] = (cyclo.to_int(val, P5) == 0) or (
            all(c == 0 for c in cyclo.canon(val, P5)))
    log["C5_eigenpoints_on_X"] = {str(j): bool(onX[j]) for j in range(5)}
    assert onX[0] is False and all(onX[j] for j in (1, 2, 3, 4)), onX

    # --- Proposition PIN, the weight obstruction
    # x_c^k has tau-weight k*b_c, b_c != 0 (mod 11): a C11-invariant form of
    # degree k has zero x_c^k coefficient unless 11 | k.
    log["PIN_C11"] = {str(k): all((k * bc) % P11 != 0 for bc in B)
                      for k in range(1, 60)}
    # v_j has C5-weight j != 0 for the four on-X points; the same argument in
    # the sigma-eigenbasis gives vanishing unless 5 | k.
    log["PIN_C5"] = {str(k): all((k * j) % P5 != 0 for j in (1, 2, 3, 4))
                     for k in range(1, 60)}
    log["PIN_min_degree_missing_all_pinned_points"] = min(
        k for k in range(1, 200) if k % 11 == 0 and k % 5 == 0)

    # --- degree 5: a_5 = i_5 = 1, so the invariant quintic is unique.
    m5 = [a for a in monomials(5) if tau_weight(a) == 0]
    o5 = sigma_orbits(m5)
    log["deg5_weight0_monomials"] = len(m5)
    log["deg5_C11C5_invariant_dim"] = len(o5)
    log["deg5_orbits"] = [[list(a) for a in o] for o in o5]
    # the coordinate-point coefficients x_c^5 must be absent (Proposition PIN)
    pure = [tuple(5 * (t == c) for t in range(5)) for c in range(5)]
    log["deg5_contains_pure_power"] = any(p in m5 for p in pure)
    assert not log["deg5_contains_pure_power"]

    # The C11:C5-invariant quintics are 3-dimensional while i_5 = 1, so the
    # G-invariant quintic is NOT pinned by the torus normaliser alone.  It is
    # pinned classically instead: for F cubic in 5 variables the Hessian
    # determinant has degree 5 and transforms by det(A)^2, so it is invariant
    # under G subset SL(W).  Since i_5 = 1 it IS (up to scale) the invariant
    # quintic, provided it is nonzero -- checked below.
    #   d^2F/dx_j^2 = 2 x_{j+1},  d^2F/dx_j dx_{j+1} = 2 x_j,  else 0.
    M = [[None] * 5 for _ in range(5)]
    for j in range(5):
        for k in range(5):
            e = [0] * 5
            if k == j:
                e[(j + 1) % 5] = 1
            elif k == (j + 1) % 5:
                e[j] = 1
            elif k == (j - 1) % 5:
                e[(j - 1) % 5] = 1
            else:
                M[j][k] = {}
                continue
            M[j][k] = {tuple(e): 1}
    # symmetry check
    for j in range(5):
        for k in range(5):
            assert M[j][k] == M[k][j], (j, k)

    def pmul(a, bdict):
        out = {}
        for ea, ca in a.items():
            for eb, cb in bdict.items():
                e = tuple(x + y for x, y in zip(ea, eb))
                out[e] = out.get(e, 0) + ca * cb
        return {e: c for e, c in out.items() if c}

    from itertools import permutations
    Q = {}
    for perm in permutations(range(5)):
        sgn = 1
        pl = list(perm)
        for i in range(5):
            for j in range(i + 1, 5):
                if pl[i] > pl[j]:
                    sgn = -sgn
        term = {(0, 0, 0, 0, 0): sgn}
        dead = False
        for j in range(5):
            if not M[j][perm[j]]:
                dead = True
                break
            term = pmul(term, M[j][perm[j]])
        if dead:
            continue
        for e, c in term.items():
            Q[e] = Q.get(e, 0) + c
    Q = {e: c for e, c in Q.items() if c}
    log["quintic_Q_nonzero"] = bool(Q)
    log["quintic_Q_terms"] = sorted([list(e), c] for e, c in Q.items())
    assert Q, "det Hess F vanishes identically -- would contradict i_5 = 1"
    # Q must be C11-invariant (all monomials of tau-weight 0) and sigma-invariant
    assert all(tau_weight(e) == 0 for e in Q), "Q is not C11-invariant"
    Qs = {}
    for e, c in Q.items():
        Qs[shift(e)] = Qs.get(shift(e), 0) + c
    assert Qs == Q, "Q is not sigma-invariant"
    log["quintic_Q_is_C11C5_invariant"] = True
    # Proposition PIN, machine instance: no pure fifth power occurs
    log["quintic_Q_at_C11_points"] = {str(c): Q.get(
        tuple(5 * (t == c) for t in range(5)), 0) for c in range(5)}
    assert all(v == 0 for v in log["quintic_Q_at_C11_points"].values())
    # values at the four on-X C5-fixed points
    vals = {}
    for j in (1, 2, 3, 4):
        v = [0] * P5
        for e, c in Q.items():
            v[(-j * sum(i * ei for i, ei in enumerate(e))) % P5] += c
        r = cyclo.canon(v, P5)
        vals[str(j)] = {"canonical_rep_mod_Phi5": r,
                        "is_zero": all(c == 0 for c in r)}
    log["quintic_values_at_C5_points"] = vals
    log["quintic_vanishes_at_C5_points"] = all(
        vals[str(j)]["is_zero"] for j in (1, 2, 3, 4))

    os.makedirs(OUT, exist_ok=True)
    with open(os.path.join(OUT, "pinned_points.json"), "w") as f:
        json.dump(log, f, indent=1, sort_keys=True)

    print("tau-weights b            :", B)
    print("deg-3 C11:C5 invariants  :", len(o3), "(= i_3 = 1, so it is F)")
    print("C5 eigenpoints on X      :", log["C5_eigenpoints_on_X"])
    print("deg-5 weight-0 monomials :", len(m5), " sigma-orbits:", len(o5))
    print("invariant quintic Q = det Hess F : %d monomials" % len(Q))
    print("Q at the five C11-points :", log["quintic_Q_at_C11_points"])
    print("Q at the four C5-points  :",
          {j: log["quintic_values_at_C5_points"][str(j)]["canonical_rep_mod_Phi5"]
           for j in (1, 2, 3, 4)},
          " all zero:", log["quintic_vanishes_at_C5_points"])
    print("min degree able to miss every pinned point:",
          log["PIN_min_degree_missing_all_pinned_points"])
    print("PINNED_POINTS_OK")


if __name__ == "__main__":
    main()
