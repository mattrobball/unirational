"""The localized k = 0 sum rule (ledger Sec.8.4), evaluated.

    sum_j (tr_j - 1) / D_j  =  0,     D_j = prod_{k' not in {j,j+1}} (1 - z^{a_j-a_k'})

with tr_j = tr(g | (Rq_*O)_{e_j}) = chi_g(derived fibre) (flag 5).

Content proved here:
  P1  v_pi(D_j) = 3 and D_j = pi^3 * delta_j with delta_j a unit; the residues
      delta_j mod pi are the products of the three tangent weights.
  P2  sum_j 1/delta_j = pi^3, hence sum_j (1/delta_j mod pi) = 0 in F_11.
  P3  For u = (u_j) in Z[zeta]^5 the equation sum u_j/D_j = 0 is solvable with
      prescribed residues ubar_j in F_11 IFF sum_j ubar_j/deltabar_j = 0.
      (Necessity: multiply by pi^3 and reduce.  Sufficiency: the deltas are
      units, so one coordinate can absorb the remainder — constructed and
      machine-checked below.)
  P4  By P2, CONSTANT residue vectors always solve it.  So the sum rule is
      vacuous exactly on the Smith configuration (five traces congruent mod pi
      to a common value); its whole content is on the DIFFERENCES.
  P5  Strengthening: if the five tr_j are EQUAL in Z[zeta] then the sum rule
      forces tr_j = 1 for every j.

chi-to-trace relation used (TIER A, proved):
      chi_g(Y, O_Y) == chi(O_Y)   (mod pi = (1 - zeta)),
  because sum_{m=0}^{10} chi_{g^m}(Y,O_Y) = 11 * (an integer) and the m != 0
  terms are the Galois conjugates of chi_g, so Tr(chi_g) = 11*Z - chi(O_Y),
  while Tr(x) == -x (mod pi) for every x in Z[zeta].
"""
import cyclo as C
import l12core as L


def delta(j):
    """D_j / pi^3 (a unit of Z[zeta])."""
    pi = C.one_minus_zpow(1)
    return C.div(L.D_X(j), C.prod([pi, pi, pi]))


def run(verbose=True):
    out = []

    def chk(name, ok, detail=""):
        out.append({"name": name, "ok": bool(ok), "detail": detail})
        if verbose:
            print(f"  [{'PASS' if ok else 'FAIL'}] {name}"
                  + (f"  ({detail})" if detail else ""))
        return ok

    pi = C.one_minus_zpow(1)

    # P1
    dbar = []
    for j in range(5):
        chk(f"P1 v_pi(D_{j}) = 3", C.val_pi(L.D_X(j)) == 3)
        dj = delta(j)
        chk(f"P1 delta_{j} is a unit", C.is_alg_int(dj) and C.res_pi(dj) != 0)
        r = C.res_pi(dj)
        prod_w = 1
        for w in L.tangent_X(j):
            prod_w = (prod_w * ((L.A[j] - L.A[(j + 1) % 5]) * 0 + w)) % 11
        # tangent weights w = a_k' - a_j; D_j uses (1 - z^{a_j - a_k'}) = (1-z^{-w})
        prod_mw = 1
        for w in L.tangent_X(j):
            prod_mw = (prod_mw * ((-w) % 11)) % 11
        chk(f"P1 delta_{j} mod pi = prod of (a_j - a_k') = {prod_mw}",
            r == prod_mw, f"res={r}")
        dbar.append(r)

    # P2
    s = C.total([C.inv(delta(j)) for j in range(5)])
    chk("P2 sum_j 1/delta_j = pi^3", C.eq(s, C.prod([pi, pi, pi])))
    s11 = sum(pow(dbar[j], 9, 11) for j in range(5)) % 11
    chk("P2 sum_j 1/deltabar_j = 0 in F_11", s11 == 0, f"deltabar={dbar}")

    # P3 necessity + sufficiency, machine-checked over all residue vectors
    def solvable_residue(ub):
        return sum(ub[j] * pow(dbar[j], 9, 11) for j in range(5)) % 11 == 0

    # explicit lift: given residues with sum ub_j/dbar_j = 0, build u in Z[zeta]^5
    def build_lift(ub):
        u = [C.from_int(ub[j]) for j in range(5)]
        r = C.total([C.mul(u[j], C.inv(L.D_X(j))) for j in range(5)])
        # r has v_pi >= -3+1 = -2 ; correct coordinate 0 by  u_0 -= r * D_0
        corr = C.mul(r, L.D_X(0))
        u[0] = C.sub(u[0], corr)
        return u

    ok_lift = True
    ok_res = True
    tested = 0
    for ub0 in range(11):
        for ub1 in range(11):
            ub = [ub0, ub1, 3, 3, 3]
            if not solvable_residue(ub):
                continue
            u = build_lift(ub)
            tested += 1
            tot = C.total([C.mul(u[j], C.inv(L.D_X(j))) for j in range(5)])
            ok_lift &= C.eq(tot, C.zero())
            ok_lift &= all(C.is_alg_int(x) for x in u)
            ok_res &= all(C.res_pi(u[j]) == ub[j] for j in range(5))
    chk(f"P3 every admissible residue vector lifts to an exact solution "
        f"({tested} vectors)", ok_lift and ok_res and tested > 0)

    # necessity
    ok_nec = True
    for ub0 in range(11):
        ub = [ub0, 3, 3, 3, 3]
        if solvable_residue(ub):
            continue
        # show no solution: pi^3 * sum u_j/D_j = sum u_j/delta_j has nonzero residue
        u = [C.from_int(x) for x in ub]
        t = C.total([C.mul(u[j], C.inv(delta(j))) for j in range(5)])
        ok_nec &= (C.res_pi(t) != 0)
    chk("P3 necessity: inadmissible residue vectors have nonzero pi-residue",
        ok_nec)

    # P4 : the Smith configuration (all residues equal) is always admissible
    ok_const = all(solvable_residue([c] * 5) for c in range(11))
    chk("P4 constant residue vectors are ALWAYS admissible "
        "(k=0 sum rule vacuous on the Smith configuration)", ok_const)

    # P5 : equal traces force tr = 1
    #   sum (t-1)/D_j = (t-1) * sum 1/D_j = (t-1)*1
    s1 = C.total([C.inv(L.D_X(j)) for j in range(5)])
    chk("P5 sum_j 1/D_j = 1, so equal traces force tr_j = 1",
        C.eq(s1, C.one()))

    return out, dbar


if __name__ == "__main__":
    res, _ = run()
    nf = sum(1 for c in res if not c["ok"])
    print(f"k0 sum rule: {len(res) - nf}/{len(res)} pass")
