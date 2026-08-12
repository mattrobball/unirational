"""Referee spot-check R2: the genus-free integrality kill of the mu = 0
branch in every QR degree class.  Fully independent re-derivation:

  (1) the anchors it rests on (P^4/X twisted totals, Koszul shift), replayed
      with the referee's own arithmetic and character DP;
  (2) the Vandermonde step: the 11 twist equations force
      tr_j = D^X_j * M(a_j)  (5x5 determinant nonzero);
  (3) the valuations: v_pi(1 - z^w) = 1, v_pi(D^X) = 3, v_pi(D^P4) = 4,
      hence v_pi(tr_j) = -1 on the mu = 0 branch for EVERY d in a QR class;
  (4) a direct sanity check of the value bookkeeping at mu = 0: the source
      AB sum with values d*a_j equals chi_g(P^4, O(k*d)) = chi_{Sym^{kd}W*}
      (q^*O_X(k) = O_{P^4}(kd) when T is a morphism near the points);
  (5) delta_bar and the k = 0 sum-rule residues (P1/P2) recomputed."""
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import referee_lib as R  # noqa: E402

FAIL = []


def chk(name, ok, detail=""):
    print(f"  [{'PASS' if ok else 'FAIL'}] {name}" + (f" ({detail})" if detail else ""))
    if not ok:
        FAIL.append(name)


def main():
    # (1) anchors
    chk("R2.1 untwisted P^4 total = 1",
        R.eq(R.total([R.inv(R.D_P4(j)) for j in range(5)]), R.ONE))
    ok = all(R.eq(R.total([R.mul(R.zpow(-k * R.A[j]), R.inv(R.D_P4(j)))
                           for j in range(5)]), R.chi_sym(k))
             for k in range(0, 7))
    chk("R2.1 P^4 twisted totals = chi_{Sym^k W*}(g), k = 0..6", ok)
    ok = all(R.eq(R.total([R.mul(R.zpow(-k * R.A[j]), R.inv(R.D_X(j)))
                           for j in range(5)]), R.chi_OX(k))
             for k in range(0, 7))
    chk("R2.1 X twisted totals = Koszul chi_g(X, O(k)), k = 0..6 "
        "(k=3 shift = -1 reproduced)", ok
        and R.eq(R.chi_OX(3), R.sub(R.chi_sym(3), R.ONE)))

    # (2) Vandermonde: det (z^{-k a_j})_{k,j=0..4} != 0
    Mv = [[R.zpow(-k * R.A[j]) for j in range(5)] for k in range(5)]
    det = _det5(Mv)
    chk("R2.2 5x5 Vandermonde in the twists is invertible (det != 0), so "
        "k = 0..4 already force tr_j = D^X_j * M(a_j)", not R.is_zero(det))

    # (3) valuations
    chk("R2.3 v_pi(1 - z^w) = 1 for every w != 0",
        all(R.val_pi(R.one_minus_zpow(w)) == 1 for w in range(1, 11)))
    chk("R2.3 v_pi(D^X_j) = 3, v_pi(D^P4_j) = 4 for all j",
        all(R.val_pi(R.D_X(j)) == 3 and R.val_pi(R.D_P4(j)) == 4
            for j in range(5)))

    # the kill, for every QR residue class d
    for d in sorted(R.QR):
        M = {w: R.ZERO for w in R.QRL}
        for j in range(5):
            w = (d * R.A[j]) % 11
            M[w] = R.add(M[w], R.inv(R.D_P4(j)))
        chk(f"R2.3 d = {d} (mod 11): receiver map j -> d*a_j is a bijection "
            f"onto QR", sorted((d * R.A[j]) % 11 for j in range(5)) == R.QRL)
        tr = R.forced_traces(M)
        vals = {w: R.val_pi(tr[w]) for w in R.QRL}
        chk(f"R2.3 d = {d}: v_pi(forced tr_j) = -1 at ALL five points -> "
            f"mu = 0 branch DEAD (traces not algebraic integers)",
            all(v == -1 for v in vals.values()), f"v = {sorted(vals.values())}")
        chk(f"R2.3 d = {d}: none of the five forced traces is an algebraic "
            f"integer", all(not R.is_alg_int(tr[w]) for w in R.QRL))

    # (4) value bookkeeping sanity at mu = 0, d = 35 would be QR-free; use
    # d = 12 (12 = 1 mod 11, QR) and d = 14 (3 mod 11): the source AB total
    # with numerators z^{-k*d*a_j} must equal chi_{Sym^{kd} W*}(g), because
    # q^* O_X(k) = O_{P^4}(kd) on that branch.
    for d in (12, 14):
        ok = True
        for k in (1, 2):
            lhs = R.total([R.mul(R.zpow(-k * d * R.A[j]), R.inv(R.D_P4(j)))
                           for j in range(5)])
            ok &= R.eq(lhs, R.chi_sym(k * d))
        chk(f"R2.4 mu = 0 value bookkeeping: source total = "
            f"chi_{{Sym^{{kd}} W*}}(g) for d = {d}, k = 1,2 (exact Sym DP)", ok)

    # (5) delta_bar and P1/P2 of the k = 0 rule
    dbar = []
    for j in range(5):
        dj = R.div(R.D_X(j), R.prod([R.PI] * 3))
        chk(f"R2.5 D^X_{j} = pi^3 * unit", R.is_alg_int(dj) and R.res_pi(dj) != 0)
        dbar.append(R.res_pi(dj))
        hand = 1
        for w in R.tangent_X(j):
            hand = (hand * (-w)) % 11
        chk(f"R2.5 delta_bar_{j} = prod(a_j - a_k') mod 11 = {hand}",
            dbar[j] == hand)
    chk("R2.5 delta_bar = (9,5,4,1,3)", dbar == [9, 5, 4, 1, 3])
    chk("R2.5 sum 1/delta_bar_j = 0 in F_11",
        sum(pow(x, 9, 11) for x in dbar) % 11 == 0)
    chk("R2.5 sum_j 1/D^X_j = 1 (P5 basis)",
        R.eq(R.total([R.inv(R.D_X(j)) for j in range(5)]), R.ONE))

    print()
    print("referee R2: " + ("ALL GREEN" if not FAIL else f"FAILURES: {FAIL}"))
    return 0 if not FAIL else 1


def _det5(M):
    import itertools
    det = R.ZERO
    for p in itertools.permutations(range(5)):
        sgn = 1
        for i in range(5):
            for j in range(i + 1, 5):
                if p[i] > p[j]:
                    sgn = -sgn
        t = R.ONE
        for i in range(5):
            t = R.mul(t, M[i][p[i]])
        det = R.add(det, R.smul(sgn, t))
    return det


if __name__ == "__main__":
    sys.exit(main())
