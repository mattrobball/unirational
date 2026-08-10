"""W2 -- orbit disjointness at each level of the T0..T3 tower.

Checks, for a given split prime:

  W2.1  the 55 V4-lines ell_V pairwise meet exactly in the 55 D12-points,
        with exactly 3 lines through each, and all of them off X;
        hence after T0 (blow up all point strata) the 55 strict transforms
        are pairwise DISJOINT.
  W2.2  the 55 plus-planes: P_z n P_s = ell_V (dim 2) for commuting z,s and a
        single point for non-commuting z,s, the latter being TRANSVERSE
        (dim(W_z^+ n W_s^+) = 1 for linear subspaces of dim 3 in dim 5 means
        the two planes meet transversally in P^4, so their tangent planes at
        the meeting point intersect in 0); each such point is a D12- or
        D10-point.  Hence after T0 + T1 the 55 strict transforms P~_sigma are
        pairwise DISJOINT.
  W2.3  the 660 (ell_V, P_sigma) incidences with sigma not in V meet in a
        single point which is again a D12/D10 point (so T0 separates them and
        P~_sigma stays smooth after T1).
  W2.4  same-V separation data for the 165 surfaces M_tau^V, done by
        character bookkeeping in the V4-character group: M_z n M_s = S_r and
        the normal directions N_{S_r/M_z}, N_{S_r/M_s} carry DIFFERENT
        characters of V, so blowing up P~_r (whose exceptional divisor
        restricts to P(N_{P~_r}) over S_r) separates them.  Hence after T2 the
        165 strict transforms M~_tau^V are pairwise DISJOINT.

Everything is exact linear algebra over F_p on the reduced Klein matrices.
"""
import sys, json, os
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from psl211 import Model, normpt, SPLIT_PRIMES


def run(p, out):
    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    m = Model(p)
    say(f"=== W2 at p = {p} ===")
    say(f"|G| = {len(m.G)}, involutions = {len(m.invols)}")
    V4s = m.klein_fours()
    say(f"Klein four-subgroups: {len(V4s)}")
    ell = [m.ell_V(H) for H in V4s]
    ok = True

    # ---------------- W2.1 ----------------
    meet = defaultdict(list)
    dims = defaultdict(int)
    for i in range(55):
        for j in range(i + 1, 55):
            I = m.inter(ell[i], ell[j])
            dims[len(I)] += 1
            if len(I) == 1:
                meet[normpt(m, I[0])].append((i, j))
    say(f"W2.1 ell_V pairwise intersection dims: {dict(sorted(dims.items()))}")
    say(f"W2.1 distinct meeting points: {len(meet)}")
    stab_orders = defaultdict(int)
    lines_through = defaultdict(int)
    offX = 0
    for q in meet:
        st = sum(1 for A in m.G if normpt(m, m.act(A, q)) == q)
        stab_orders[st] += 1
        lines_through[sum(1 for i in range(55) if m.contains_pt(ell[i], q))] += 1
        if m.F(list(q)) != 0:
            offX += 1
    say(f"W2.1 projective stabilizer orders of meeting points: {dict(stab_orders)}")
    say(f"W2.1 #ell_V through each meeting point: {dict(lines_through)}")
    say(f"W2.1 meeting points off X: {offX} / {len(meet)}")
    c1 = (dims.get(1, 0) == 165 and dims.get(0, 0) == 1320 and len(meet) == 55
          and stab_orders == {12: 55} and lines_through == {3: 55} and offX == 55)
    say(f"W2.1 VERDICT (ell_V meet only at the 55 D12-points, 3 each, all off X): {'PASS' if c1 else 'FAIL'}")
    ok &= c1
    # distinct lines through a common point have distinct tangent directions,
    # so blowing up the point separates their strict transforms.
    say("W2.1 => after T0 the 55 strict transforms ell~_V are pairwise disjoint "
        "(distinct lines through a blown-up point separate).")

    # ---------------- W2.2 ----------------
    Pp = {A: m.plus_plane(A) for A in m.invols}
    Lm = {A: m.minus_line(A) for A in m.invols}
    tally = defaultdict(int)
    ncpts = defaultdict(list)
    for i in range(55):
        for j in range(i + 1, 55):
            a, b = m.invols[i], m.invols[j]
            comm = m.mm(a, b) == m.mm(b, a)
            I = m.inter(Pp[a], Pp[b])
            tally[(comm, len(I))] += 1
            if not comm:
                ncpts[normpt(m, I[0])].append((i, j))
    say(f"W2.2 (commuting?, dim(W_a^+ n W_b^+)) tally: {dict(sorted(tally.items()))}")
    st2 = defaultdict(int)
    for q in ncpts:
        st = sum(1 for A in m.G if normpt(m, m.act(A, q)) == q)
        st2[st] += 1
    say(f"W2.2 non-commuting meeting points: {len(ncpts)}, stabilizer orders: {dict(st2)}")
    c2 = (tally.get((True, 2), 0) == 165 and tally.get((False, 1), 0) == 1320
          and set(st2) <= {10, 12})
    say(f"W2.2 VERDICT (commuting -> line ell_V; non-commuting -> one transverse "
        f"D12/D10 point): {'PASS' if c2 else 'FAIL'}")
    ok &= c2
    # commuting case: P~_z n E_V = S_z = P^1 x {[B]}, pairwise disjoint sections
    H = V4s[0]
    (z, s, r), (A, B, C, D) = m.v4_decomp(H)
    sec = {"z": B, "s": C, "r": D}
    disj = all(len(m.inter(sec[x], sec[y])) == 0 for x in sec for y in sec if x < y)
    say(f"W2.2 sections S_z,S_s,S_r of E_V = P(B+C+D) pairwise disjoint: {disj}")
    ok &= disj
    say("W2.2 => after T0+T1 the 55 strict transforms P~_sigma are pairwise disjoint.")

    # ---------------- W2.3 ----------------
    t3 = defaultdict(int)
    pts3 = set()
    for i in range(55):
        for sg in m.invols:
            I = m.inter(ell[i], Pp[sg])
            t3[len(I)] += 1
            if len(I) == 1:
                pts3.add(normpt(m, I[0]))
    say(f"W2.3 (ell_V, P_sigma) intersection dims: {dict(sorted(t3.items()))}")
    st3 = defaultdict(int)
    for q in pts3:
        st = sum(1 for AA in m.G if normpt(m, m.act(AA, q)) == q)
        st3[st] += 1
    say(f"W2.3 distinct point-incidences: {len(pts3)}, stabilizer orders: {dict(st3)}")
    c3 = (t3.get(2, 0) == 165 and t3.get(1, 0) == 660 and set(st3) <= {10, 12})
    say(f"W2.3 VERDICT (ell_V inside P_sigma iff sigma in V; otherwise one "
        f"D12/D10 point, blown up at T0): {'PASS' if c3 else 'FAIL'}")
    ok &= c3
    # ell_V never meets a minus-line (used for the type-II exclusion in (F2))
    t3b = defaultdict(int)
    for i in range(55):
        for sg in m.invols:
            t3b[len(m.inter(ell[i], Lm[sg]))] += 1
    say(f"W2.3b (ell_V, L'_sigma) intersection dims: {dict(sorted(t3b.items()))}  "
        f"[expect all 0: type-II points lie on NO line]")
    c3b = t3b.get(0, 0) == 3025
    ok &= c3b

    # ---------------- W2.4 ----------------
    # characters of V on the fibre P(B+C+D) of E_V, and the separation data.
    # chi_z = the character with kernel <z>; B carries chi_z, C carries chi_s,
    # D carries chi_r.  M_z = P(C+D), M_s = P(B+D), M_r = P(B+C).
    # S_r = P~_r n E_V = P^1 x {[D]}.
    def chi(space, g):
        v = space[0]
        w = m.act(g, v)
        # w = lam * v
        for k in range(5):
            if v[k] % p:
                return w[k] * m.inv(v[k]) % p
        raise RuntimeError
    chars = {"B": tuple(chi(B, g) for g in (z, s, r)),
             "C": tuple(chi(C, g) for g in (z, s, r)),
             "D": tuple(chi(D, g) for g in (z, s, r)),
             "A": tuple(chi(A, g) for g in (z, s, r))}
    say(f"W2.4 V4-characters of (A,B,C,D) evaluated at (z,s,r) "
        f"[{p-1} == -1]: {chars}")
    cA = (chars["A"] == (1, 1, 1) and chars["B"] == (1, p - 1, p - 1)
          and chars["C"] == (p - 1, 1, p - 1) and chars["D"] == (p - 1, p - 1, 1))
    say(f"W2.4 character table (triv, chi_z, chi_s, chi_r) as expected: {cA}")
    ok &= cA
    # N_{S_r/M_z} = the C-direction seen from D; N_{S_r/M_s} = the B-direction from D
    # as characters of V these are chi_s*chi_r = chi_z  and  chi_z*chi_r = chi_s.
    nz = tuple(chars["C"][i] * chars["D"][i] % p for i in range(3))
    ns = tuple(chars["B"][i] * chars["D"][i] % p for i in range(3))
    say(f"W2.4 char(N_{{S_r/M_z}}) = {nz}   char(N_{{S_r/M_s}}) = {ns}")
    c4 = nz != ns and nz != (1, 1, 1) and ns != (1, 1, 1)
    say(f"W2.4 VERDICT (the two normal characters at S_r differ, so blowing up "
        f"P~_r separates M~_z from M~_s): {'PASS' if c4 else 'FAIL'}")
    ok &= c4
    say("W2.4 => after T2 the 165 strict transforms M~_tau^V are pairwise disjoint "
        "(different V: different E_V, disjoint by W2.1; same V: separated here).")

    say(f"=== W2 OVERALL at p={p}: {'PASS' if ok else 'FAIL'} ===")
    return ok


if __name__ == "__main__":
    out = []
    allok = True
    for p in SPLIT_PRIMES:
        allok &= run(p, out)
        out.append("")
    print("W2_ORBIT_DISJOINTNESS_" + ("OK" if allok else "FAIL"))
    out.append("W2_ORBIT_DISJOINTNESS_" + ("OK" if allok else "FAIL"))
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    with open(os.path.join(here, "results", "w2_orbit_disjointness.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    sys.exit(0 if allok else 1)
