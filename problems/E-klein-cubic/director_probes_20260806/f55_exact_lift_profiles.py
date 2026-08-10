#!/usr/bin/env python3
"""f55_exact_lift_profiles.py -- the exact-lift campaign, step B: THE PROFILES.

Reconstructs, verifies and enumerates the degeneration profiles that pin the
exact algebraic system of FIX_IX_v14 sec 8.7 (Lemma G).

  leaves        L = {0,1,3,4,5,9}   (the C11-weights of U)
  Plucker       D_ab  (a<b in L), binary forms of degree e in z
  V14 membership   D_{c_q d_q} = t_q * D_{0q}   for q in QR = {1,3,4,5,9},
                   (c,d) = {3,9},{5,9},{1,3},{1,4},{4,5};  t = (1/2,-1/2,1/2,-1/2,-1/2)
  equivariance  supp(D_ab) subset { k : k = sigma*(a+b-2) mod 11 }
                (normalisation: the z=0 corner is the point y_{49}, weight 2)
  z=0 corner    w_ab   := ord_0 D_ab,  w_49 = 0
  z=oo corner   w'_ab  := ord_oo D_ab = e - deg_z D_ab,  w'_15 = 0
  => e = 4*sigma mod 11 and w'_ab = e - sigma(a+b-2) mod 11.

Necessary tropical conditions on BOTH w and w': tropical Plucker (4-point),
the five proportionality equalities (from the E_q), non-negativity, and the
budget w_ab + w'_ab <= e (slack = number of roots of D_ab away from 0, oo;
slack is automatically a multiple of 11).
"""
import sys, json
from itertools import combinations

L = [0, 1, 3, 4, 5, 9]
PAIRS = [tuple(sorted(c)) for c in combinations(L, 2)]
QUADS = [tuple(sorted(c)) for c in combinations(L, 4)]
QR = [1, 3, 4, 5, 9]
CD = {1: (3, 9), 3: (5, 9), 4: (1, 3), 5: (1, 4), 9: (4, 5)}
# the five proportionality equalities D_{cd} = t_q D_{0q} => equal valuations
PROP = [(tuple(sorted(CD[q])), (0, q)) for q in QR]

# ---- Lemma G certificate at z = 0 (FIX_IX_v14 sec 8.7), sigma = 7 --------
SIGMA = 7
LEMMA_G = dict(p0=5, p1=12, p3=15, p5=18, q0=25, q1=10, q3=13, q5=5,
               w15=17, w35=20)   # w15 = A', w35 = E'' (forced, see below)


def w_from_pq(p, q, w15, w35):
    """assemble the 15-vector at z=0 from the corner-normalised data.
       p_x = w_{9x}, q_x = w_{4x} (x in {0,1,3,5}), w_49 = 0, and the four
       proportionality-pinned non-corner entries."""
    w = {(4, 9): 0}
    for x in (0, 1, 3, 5):
        w[tuple(sorted((9, x)))] = p[x]
        w[tuple(sorted((4, x)))] = q[x]
    # proportionality: w_01 = w_39 = p3 ; w_03 = w_59 = p5 ;
    #                  w_13 = w_04 = q0 ; w_05 = w_14 = q1 ; w_45 = w_09 (q5 = p0)
    w[(0, 1)] = p[3]
    w[(0, 3)] = p[5]
    w[(1, 3)] = q[0]
    w[(0, 5)] = q[1]
    w[(1, 5)] = w15
    w[(3, 5)] = w35
    return w


def four_point_ok(w):
    bad = []
    for (a, b, c, d) in QUADS:
        S = [w[(a, b)] + w[(c, d)], w[(a, c)] + w[(b, d)], w[(a, d)] + w[(b, c)]]
        mn = min(S)
        if S.count(mn) < 2:
            bad.append(((a, b, c, d), tuple(S)))
    return bad


def cong_ok(w, sigma, shift):
    """w_ab = sigma*(a+b-shift) mod 11 for all pairs."""
    bad = []
    for (a, b) in PAIRS:
        if (w[(a, b)] - sigma * (a + b - shift)) % 11:
            bad.append(((a, b), w[(a, b)], sigma * (a + b - shift) % 11))
    return bad


def prop_ok(w):
    return [(x, y) for (x, y) in PROP if w[x] != w[y]]


def main():
    p = {0: LEMMA_G['p0'], 1: LEMMA_G['p1'], 3: LEMMA_G['p3'], 5: LEMMA_G['p5']}
    q = {0: LEMMA_G['q0'], 1: LEMMA_G['q1'], 3: LEMMA_G['q3'], 5: LEMMA_G['q5']}
    w = w_from_pq(p, q, LEMMA_G['w15'], LEMMA_G['w35'])
    print("=== Lemma G certificate at z = 0, sigma =", SIGMA, "===")
    for pr in PAIRS:
        print(f"   w_{pr[0]}{pr[1]} = {w[pr]:3d}   (class {w[pr]%11}, "
              f"required {SIGMA*(pr[0]+pr[1]-2)%11})")
    print("  congruence violations :", cong_ok(w, SIGMA, 2) or "NONE")
    print("  proportionality viol. :", prop_ok(w) or "NONE")
    fb = four_point_ok(w)
    print("  four-point violations :", fb or "NONE")
    print("  all 15 quadruple triples:")
    for (a, b, c, d) in QUADS:
        S = (w[(a, b)] + w[(c, d)], w[(a, c)] + w[(b, d)], w[(a, d)] + w[(b, c)])
        print(f"     {{{a},{b},{c},{d}}} -> {S}")
    assert not cong_ok(w, SIGMA, 2) and not prop_ok(w) and not fb

    # ---------- enumerate compatible infinity data ----------
    print("\n=== compatible z = oo vectors w' (same curve, budget e) ===")
    maxw = max(w.values())
    e0 = 4 * SIGMA % 11
    found = []
    ecands = [e for e in range(0, 200) if e % 11 == e0 % 11 and e >= maxw]
    for e in ecands[:6]:
        # per-pair candidate values for w'
        cands = {}
        ok = True
        for pr in PAIRS:
            cls = (e - SIGMA * (pr[0] + pr[1] - 2)) % 11
            hi = e - w[pr]                       # budget
            vals = [v for v in range(0, hi + 1) if v % 11 == cls]
            if pr == (1, 5):
                vals = [v for v in vals if v == 0]
            if not vals:
                ok = False
                break
            cands[pr] = vals
        if not ok:
            print(f"  e = {e}: no candidate value for some pair -> INFEASIBLE")
            continue
        # brute force with early pruning via proportionality
        keys = PAIRS
        sols = []
        def rec(i, cur):
            if i == len(keys):
                if prop_ok(cur):
                    return
                if four_point_ok(cur):
                    return
                sols.append(dict(cur))
                return
            k = keys[i]
            for v in cands[k]:
                cur[k] = v
                # prune with proportionality as soon as both members are set
                bad = False
                for (x, y) in PROP:
                    if x in cur and y in cur and cur[x] != cur[y]:
                        bad = True
                if not bad:
                    rec(i + 1, cur)
                del cur[k]
        rec(0, {})
        tot = 1
        for k in keys:
            tot *= len(cands[k])
        print(f"  e = {e}: search space {tot}, valid w' vectors: {len(sols)}")
        for s in sols:
            slack = {pr: e - w[pr] - s[pr] for pr in PAIRS}
            nunk = sum(v // 11 + 1 for v in slack.values())
            print(f"      w' = { {f'{a}{b}': s[(a,b)] for (a,b) in PAIRS} }")
            print(f"      slack = { {f'{a}{b}': slack[(a,b)] for (a,b) in PAIRS} }  "
                  f"(total coefficients over all 15 forms = {nunk})")
            found.append(dict(e=e, wp={f"{a}{b}": s[(a, b)] for (a, b) in PAIRS},
                              slack={f"{a}{b}": slack[(a, b)] for (a, b) in PAIRS}))
    with open('f55_exact_lift_profiles.json', 'w') as fh:
        json.dump(dict(sigma=SIGMA, w={f"{a}{b}": w[(a, b)] for (a, b) in PAIRS},
                       profiles=found), fh, indent=1)
    print("\nwrote f55_exact_lift_profiles.json ;  profiles found:", len(found))


if __name__ == '__main__':
    main()
