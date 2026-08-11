"""Lever 2: what bounds mult_p(T) at a C11-point?

Geometry established here (exactly, at p = 331 and p = 661):

  * the five C11-eigenpoints of P(W) are the coordinate points, with weights
    Q = {1,3,4,5,9} (the quadratic residues), and F = sum_a x_a^2 x_{9a}
    in that indexing (9 = -2), so the F-successor of the weight a point is
    the weight 9a point;
  * the ten lines L_{jk} = <e_j,e_k> are C11-stable and split under the
    F55-normaliser into TWO orbits of five, indexed by the ratio class
    {r, r^{-1}} of r = k/j in Q\\{1}:  {5,9} and {3,4};
  * ratio in {5,9} ("F-adjacent"):  F|_L = x_j^2 x_k  is non-zero, so
    L meets X exactly in its two endpoints;
  * ratio in {3,4}:  F|_L = 0, so **L is contained in X**.  These are 60 lines
    of the Fano surface of X, none of them a minus-line L_sigma (their
    stabiliser is C11, and Stab(L_sigma) = D12).

Bounds proved in THEOREM.md sec.3 and instrumented here:

  (a)  mu <= d                                                    (always)
  (b)  2 mu <= d   if some C11-coordinate line is not in Bs(T)
  (c)  d^2 >= 3 mu^2 + 55 e^2   if some C11-coordinate 2-plane restriction has
       no fixed component  (e = ord_{P_sigma}(T) >= 1)
  (d)  mu = 1  =>  the leading form is linear with image a linear subspace of
       X, hence of rank <= 2 (a smooth cubic threefold contains no plane), so
       at most TWO of the four exceptional C11-rows carry a value and their two
       targets must span one of the 60 lines above.

and the congruence LOWER bound mu_min(d) is computed for comparison.
"""
import json

from s3core import Model, QR11

Q = set(QR11)


def ratio_classes():
    """the two F55-orbits on the ten lines, by ratio class."""
    cls = {}
    for r in sorted(Q - {1}):
        ri = pow(r, 9, 11)          # r^{-1} mod 11
        cls.setdefault(frozenset({r, ri}), set()).add(r)
    return sorted([sorted(c) for c in cls], key=lambda x: x[0])


def line_geometry(m):
    """for every C11 subgroup and every pair of eigenpoints: is the line in X?"""
    p = m.p
    T = m.T
    eb = m.eigenbasis(T, 11)
    wt = {a: v for a, v in eb}
    out = []
    for j in sorted(wt):
        for k in sorted(wt):
            if k <= j:
                continue
            r = k * pow(j, 9, 11) % 11
            rc = tuple(sorted({r, pow(r, 9, 11)}))
            inX = True
            for s in range(p):
                v = tuple((wt[j][i] + s * wt[k][i]) % p for i in range(5))
                if not m.onX(v):
                    inX = False
                    break
            if inX and not m.onX(wt[k]):
                inX = False
            # stabiliser of the line
            U = (wt[j], wt[k])
            cu = m.rref([list(u) for u in U])[0]
            stab = [A for A in m.G
                    if m.rref([list(m.act(A, u)) for u in U])[0] == cu]
            out.append({"j": j, "k": k, "ratio": r, "ratio_class": list(rc),
                        "line_in_X": bool(inX), "stab_order": len(stab),
                        "orbit_size": 660 // len(stab)})
    return out


def mu_min_table():
    """the smallest jet order the covariance congruence allows at a C11-point:
    the least nu such that some monomial x_k^{d-nu} * (degree nu in the others)
    has an admissible weight."""
    out = {}
    for d in range(11):
        k = 9
        best = None
        for nu in range(0, 12):
            ok = False
            # reachable weight shifts by nu normal directions
            shifts = {0}
            for _ in range(nu):
                shifts = {(s + (j - k)) % 11 for s in shifts for j in Q if j != k}
            for s in shifts:
                if (d * k + s) % 11 in Q:
                    ok = True
                    break
            if ok:
                best = nu
                break
        out[d] = best
    return out


def mu1_rank_table():
    """mu = 1 : which pairs of the four exceptional rows can be simultaneously
    non-zero, given that the image must be a LINE of X (ratio 3 or 4)."""
    k = 9
    cs = [3, 5, 6, 7]
    out = {}
    for d in range(11):
        weights = {c: (d * k + c) % 11 for c in cs}
        onX = {c: w for c, w in weights.items() if w in Q}
        pairs = []
        for i, c1 in enumerate(sorted(onX)):
            for c2 in sorted(onX)[i + 1:]:
                w1, w2 = onX[c1], onX[c2]
                r = w2 * pow(w1, 9, 11) % 11
                if r in (3, 4):
                    pairs.append((c1, c2))
        out[d] = {"weights": weights,
                  "rows_with_target_on_X": sorted(onX),
                  "admissible_rank2_pairs": pairs,
                  "max_rows_with_a_value": (2 if pairs else (1 if onX else 0))}
    return out


def bound_table(dmax=60):
    """the three upper bounds, per degree, with e = 1 (the weakest legal value
    of ord_{P_sigma}(T))."""
    import math
    out = []
    for d in range(1, dmax + 1):
        b_line = d // 2
        arg = d * d - 55
        b_plane = int(math.isqrt(max(arg, 0) // 3)) if arg > 0 else None
        out.append({"d": d, "mu_le_d": d, "mu_le_d_over_2_if_a_line_is_free":
                    b_line, "mu_le_plane_bound_if_no_fixed_component": b_plane})
    return out


def main():
    res = {"ratio_classes": ratio_classes(),
           "mu_min": mu_min_table(),
           "mu1_rank": mu1_rank_table(),
           "bounds": bound_table()}
    for p in (331, 661):
        m = Model(p)
        res["lines_p%d" % p] = line_geometry(m)
    with open("results/lever2.json", "w") as f:
        json.dump(res, f, indent=1, sort_keys=True, default=str)

    with open("results/lever2.txt", "w") as f:
        f.write("LEVER 2 : the C11 line geometry and the multiplicity bounds\n\n")
        f.write("the ten C11-coordinate lines, p = 331 "
                "(j,k = weights of the two endpoints)\n")
        f.write("%-4s %-4s %-6s %-12s %-9s %-6s %s\n"
                % ("j", "k", "ratio", "ratio class", "in X?", "stab", "orbit"))
        for L in res["lines_p331"]:
            f.write("%-4d %-4d %-6d %-12s %-9s %-6d %d\n"
                    % (L["j"], L["k"], L["ratio"], str(L["ratio_class"]),
                       L["line_in_X"], L["stab_order"], L["orbit_size"]))
        f.write("\nmu_min(d) : the least jet order the congruence permits\n")
        for d, v in sorted(res["mu_min"].items()):
            f.write("  d = %2d (mod 11) : mu_min = %s%s\n"
                    % (d, v, "   [d is a QR]" if d in Q else ""))
        f.write("\nmu = 1 : the rank-2 cut on the four C11-rows\n")
        f.write("%-6s %-28s %-22s %s\n"
                % ("d%11", "weights of the 4 rows", "rows with target on X",
                   "max rows with a value"))
        for d, v in sorted(res["mu1_rank"].items()):
            f.write("%-6d %-28s %-22s %d   pairs=%s\n"
                    % (d, str(v["weights"]), str(v["rows_with_target_on_X"]),
                       v["max_rows_with_a_value"], v["admissible_rank2_pairs"]))
        f.write("\nupper bounds (e = 1)\n")
        f.write("%-5s %-8s %-10s %s\n" % ("d", "mu<=d", "2mu<=d", "plane bound"))
        for r in res["bounds"]:
            if r["d"] in (25, 34) or r["d"] % 10 == 0:
                f.write("%-5d %-8d %-10d %s\n"
                        % (r["d"], r["mu_le_d"],
                           r["mu_le_d_over_2_if_a_line_is_free"],
                           r["mu_le_plane_bound_if_no_fixed_component"]))
    print("S3_LEVER2_OK")


if __name__ == "__main__":
    main()
