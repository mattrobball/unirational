"""CHECK 4 -- the weighted-blowup severing of prop:cyclic_not_fabulous (Duncan 4.5).

The tex's local computation at a general x in D_ij, in analytic coordinates with
D_i = {u_1 = 0}, D_j = {u_2 = 0}:

    J = (u_1^b, u_2^a)^e     or     (u_1^b, u_2^a)^e (u_2^b, u_1^a)^e

"the Newton polyhedron of (u_1^b, u_2^a) has an edge with inner normal
v := (a,b), and passing to a product of ideals replaces Newton polyhedra by
their Minkowski sum and normal fans by their common refinement, so this fan
contains the ray spanned by v."

Then Phi = pi^{-1}(x) is the chain of E_{v_l} over the interior rays v_l ordered
by slope, with D_i-tilde meeting the e_1-end and D_j-tilde the e_2-end, the
subgroup acting trivially on E_{v_l} is ker(chi_1^{b_l} chi_2^{-a_l}), and
E_v (v = (a,b)) is free away from its two nodes, so Phi \\cap W_nt is severed.

This script:
  (1) computes the Newton polyhedron / normal fan of those ideals from scratch
      and checks (a,b) is a ray, in both the one-factor and the two-factor case,
      and that raising to the e-th power does not change the fan;
  (2) replays the chain-severing combinatorics: which E_{v_l} lie in W_nt, and
      whether the two ends land in different connected components;
  (3) contrasts it with a non-cyclic H, where rem:toric_criterion(a) predicts
      every wall survives and the chain stays connected.
"""

import sys, os
from math import gcd
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from abelian import elements, kernel, is_cyclic, char_word, generate_dual, order
from chk2_number_theory_lemma import construct


# ---------------------------------------------------------------- geometry ---
def pareto_min(pts):
    out = []
    for p in pts:
        if not any(q != p and q[0] <= p[0] and q[1] <= p[1] for q in pts):
            out.append(p)
    return sorted(set(out))


def newton_vertices(gens):
    """vertices of conv(gens) + R^2_{>=0}, ordered by increasing x"""
    pts = pareto_min(gens)
    pts.sort(key=lambda p: (p[0], -p[1]))
    hull = []
    for p in pts:
        while len(hull) >= 2:
            (x1, y1), (x2, y2) = hull[-2], hull[-1]
            # keep p only if the chain stays convex (turning left/anticlockwise)
            cross = (x2 - x1) * (p[1] - y1) - (y2 - y1) * (p[0] - x1)
            # the boundary staircase, read left to right, must turn counter-
            # clockwise (slopes strictly increasing); cross <= 0 means the
            # middle point is not a vertex of conv(gens) + R^2_{>=0}
            if cross <= 0:
                hull.pop()
            else:
                break
        hull.append(p)
    return hull


def normal_fan_rays(gens):
    """primitive inner normals: (1,0), the edge normals, (0,1)"""
    V = newton_vertices(gens)
    rays = {(1, 0), (0, 1)}
    for (x1, y1), (x2, y2) in zip(V, V[1:]):
        n = (y1 - y2, x2 - x1)
        g = gcd(abs(n[0]), abs(n[1]))
        rays.add((n[0] // g, n[1] // g))
    return sorted(rays, key=lambda r: (r[1] * 1.0 / r[0]) if r[0] else float("inf"))


def minkowski(g1, g2):
    return pareto_min([(p[0] + q[0], p[1] + q[1]) for p in g1 for q in g2])


def scale(gens, e):
    return [(e * p[0], e * p[1]) for p in gens]


# ------------------------------------------------------------ chain severing --
def sever(rays, c1, c2, n):
    """rays: interior rays ordered by slope.  Returns (marks, components,
    ends_separated) for Phi \\cap W_nt, where the nodes always lie in W_nt
    (maximal cones have H_sigma = H != 1)."""
    marks = []
    for (a, b) in rays:
        H_v = kernel(char_word(c1, c2, b, -a, n), n)
        marks.append(len(H_v) > 1)          # True  <=>  E_v is inside W_nt
    # nodes 0..s ; node_{l-1} -- E_l -- node_l ; E_l is a bridge iff marks[l]
    s = len(rays)
    comp = list(range(s + 1))
    for l in range(s):
        if marks[l]:
            hi, lo = max(comp[l], comp[l + 1]), min(comp[l], comp[l + 1])
            comp = [lo if c == hi else c for c in comp]
    return marks, comp, comp[0] != comp[s]


def main():
    fails = []

    # ---------------- (1) Newton polyhedra / normal fans
    geo_cases = 0
    for a in range(1, 13):
        for b in range(1, 13):
            if gcd(a, b) != 1:
                continue
            geo_cases += 1
            g1 = [(b, 0), (0, a)]                 # (u_1^b, u_2^a)
            g2 = [(0, b), (a, 0)]                 # (u_2^b, u_1^a)
            r1 = normal_fan_rays(g1)
            if (a, b) not in r1:
                fails.append(("(a,b) missing from normal fan of (u1^b,u2^a)", a, b, r1))
            for e in (1, 2, 3):
                if normal_fan_rays(scale(g1, e)) != r1:
                    fails.append(("e-th power changed the fan", a, b, e))
            r12 = normal_fan_rays(minkowski(scale(g1, 2), scale(g2, 2)))
            if (a, b) not in r12:
                fails.append(("(a,b) missing from the two-factor fan", a, b, r12))
            if (b, a) not in r12:
                fails.append(("(b,a) missing from the two-factor fan", a, b, r12))
            # all rays of each factor survive in the common refinement
            for r in normal_fan_rays(g1) + normal_fan_rays(g2):
                if r not in r12:
                    fails.append(("common refinement lost a ray", a, b, r, r12))
    print(f"(a,b) coprime pairs tested for the Newton/normal-fan claims: {geo_cases}")

    # ---------------- (2) severing, cyclic H
    cyc_cases = 0
    for m in range(2, 41):
        for c1 in range(m):
            for c2 in range(m):
                n = (m,)
                if len(generate_dual([(c1,), (c2,)], n)) != m:
                    continue            # chi_1, chi_2 must generate the dual
                if len(kernel((c1,), n)) == 1 or len(kernel((c2,), n)) == 1:
                    continue            # standing convention G_{D_i}, G_{D_j} != 1
                cyc_cases += 1
                a, b = construct(m, c1, c2)
                g1 = [(b, 0), (0, a)]
                g2 = [(0, b), (a, 0)]
                for gens in (scale(g1, 3), minkowski(scale(g1, 3), scale(g2, 3))):
                    rays = [r for r in normal_fan_rays(gens)
                            if r[0] > 0 and r[1] > 0]
                    if (a, b) not in rays:
                        fails.append(("severing ray absent", m, c1, c2, a, b, rays))
                        continue
                    marks, comp, sepd = sever(rays, (c1,), (c2,), n)
                    if not sepd:
                        fails.append(("cyclic H: ends NOT separated", m, c1, c2, a, b,
                                      rays, marks))
                    if marks[rays.index((a, b))]:
                        fails.append(("E_v was not free", m, c1, c2, a, b))
    print(f"cyclic (H, chi_1, chi_2) configurations severed, m <= 40: {cyc_cases}")

    # ---------------- (3) contrast: non-cyclic H, every wall survives
    noncyc_cases = 0
    from abelian import all_groups
    for n in all_groups(36, max_factors=3):
        if is_cyclic(n):
            continue
        els = elements(n)
        for c1 in els:
            for c2 in els:
                if len(generate_dual([c1, c2], n)) != order(n):
                    continue
                if len(kernel(c1, n)) == 1 or len(kernel(c2, n)) == 1:
                    continue
                noncyc_cases += 1
                rays = [(x, y) for x in range(1, 7) for y in range(1, 7)
                        if gcd(x, y) == 1]
                rays.sort(key=lambda r: r[1] / r[0])
                marks, comp, sepd = sever(rays, c1, c2, n)
                if not all(marks):
                    fails.append(("non-cyclic H: a wall was free", n, c1, c2))
                if sepd:
                    fails.append(("non-cyclic H: chain severed", n, c1, c2))
    print(f"non-cyclic (H, chi_1, chi_2) configurations checked: {noncyc_cases}")

    # ---------------- worked instance: the tex's own Z/6 example
    print()
    print("worked instance -- ex:not_a_complex, H = Z/6, (chi_1,chi_2) = (2,3)")
    n = (6,)
    for (a, b) in [(1, 1), construct(6, 2, 3)]:
        gens = [(b, 0), (0, a)]
        rays = [r for r in normal_fan_rays(gens) if r[0] > 0 and r[1] > 0]
        marks, comp, sepd = sever(rays, (2,), (3,), n)
        print(f"   (a,b) = {(a,b)}: interior rays {rays}, "
              f"E_v inside W_nt? {marks}, ends separated: {sepd}")

    print()
    print(f"failures: {len(fails)}")
    for f in fails[:20]:
        print("  FAIL", f)
    print("RESULT:", "PASS" if not fails else "FAIL")
    return 0 if not fails else 1


if __name__ == "__main__":
    sys.exit(main())
