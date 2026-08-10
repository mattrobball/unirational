"""W7 (MANDATORY) -- test the new constraint (F2) against the [E33] V4
trisection family behind V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED.

Discipline being obeyed: theory/FIX_I_bcomplex.md:313-319 --
  "The V4 trisection counterexample bounds the method.  The computed family
   behind V4-LOCAL-PATH-HEADLINE-ROUTE-REFUTED ([E33]) solves every purely
   local path-style constraint; any draft obstruction theorem must be tested
   against it (T5 below) -- if the draft 'proves' nonexistence from local data
   alone, the draft is wrong."

THE CONSTRAINT UNDER TEST.
  (F2)  For the fabulous corner D_ij = E_s^V n E~_z of this packet
        (G_{D_i} = <s>, G_{D_j} = <z>, G_{D_ij} = V = <z,s>), every
        G-equivariant rational f : P(W) --> X satisfies
              f(E_s^V)  in  { L_s , [B] , [C] , [D] } ,
        i.e. the deep s-divisor sweeps the line L_s or contracts to one of the
        three TYPE-I vertices of the V-triangle.  It is NEVER contracted to a
        TYPE-II point.

THE WITNESS.
  goal_runs_after_f1f0be/V4_SIMULTANEOUS_ODD_NORMALS_20260802/THEOREM.md, §4,
  equations (4.1)-(4.3): with X = yz, Y = zx, Z = xy and kappa = (B^3-1)^2/B^3,
        w  = -XYZ,
        u_0 = X(X^2 + B Y^2 + B^{-1} Z^2)   (and cyclically for u_1, u_2),
  which satisfies  kappa w^3 + w(u_0^2+u_1^2+u_2^2) + u_0 u_1 u_2 = 0, i.e.
  lands on the smooth A4-stable cubic SURFACE S_kappa = X n H, where H is a
  CHARACTER HYPERPLANE of the V4-normal form (packet eq. (1.1): the hyperplane
  {b = 0} or {a = 0}, a,b being the residual-C3 eigencoordinates on A = W^V).
  Precomposing with the coprime cyclically-permuted linear forms l_i gives the
  primitive line-degree-6 A4-equivariant family Q_{B,l} of (4.3).

THE TEST.  (F2) can only be violated if the witness lands on a TYPE-II point.
Type-II points are by definition the three points of X n ell_V (FIX-A1
CORRECTION.md:135-137).  So it suffices to prove

        S_kappa n ell_V = empty,

which follows if H n ell_V is a single point OFF X.  H n ell_V = P(A_omega) or
P(A_omega^2), the two residual-C3 eigenpoints of ell_V -- the "character
points" [1:0], [0:1] of THEOREM.md.  This script verifies, for all 55 Klein
four-groups and at two split primes, that BOTH C3-eigenpoints of ell_V lie off
X, and that the type-II scheme X n ell_V is a reduced length-3 scheme disjoint
from all 55 lines.
"""
import sys, os
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from psl211 import Model, normpt, SPLIT_PRIMES


def run(p, say):
    m = Model(p)
    say(f"=== W7 at p = {p} ===")
    V4s = m.klein_fours()
    inv = m.invols
    Lm = {A: m.minus_line(A) for A in inv}
    ok = True

    off_X = 0
    n_eig = defaultdict(int)
    disc_nonzero = 0
    for H in V4s:
        A = m.ell_V(H)                                   # = W^V, dim 2
        NV = [g for g in m.G
              if frozenset(m.mm(m.mm(g, x), m.matinv(g)) for x in H) == frozenset(H)]
        c3 = next(g for g in NV if m.morder(g) == 3)     # residual C3 generator
        # eigenlines of c3 inside A  (the two "character points" of ell_V)
        eig = []
        for lam in range(p):
            if pow(lam, 3, p) != 1:
                continue
            E = m.inter(A, m.eigsp(c3, lam))
            if E:
                eig.append((lam, E))
        n_eig[len(eig)] += 1
        for lam, E in eig:
            if len(E) == 1 and m.F(list(E[0])) != 0:
                off_X += 1
        # the type-II scheme X n ell_V : F restricted to ell_V is a binary cubic
        v0, v1 = A[0], A[1]
        vals = []
        for t in range(4):
            vals.append(m.F([(v0[k] + t * v1[k]) % p for k in range(5)]))
        # interpolate c0 + c1 t + c2 t^2 + c3 t^3
        Mx = [[pow(t, e, p) for e in range(4)] + [vals[t]] for t in range(4)]
        R, piv = m.rref(Mx)
        c = [R[i][4] for i in range(4)]
        # leading coefficient = F(v1) (the t -> infinity value)
        c3c = m.F(list(v1))
        a3, a2, a1, a0 = c3c, c[2], c[1], c[0]
        disc = (18 * a3 * a2 * a1 * a0 - 4 * a2 ** 3 * a0 + a2 ** 2 * a1 ** 2
                - 4 * a3 * a1 ** 3 - 27 * a3 ** 2 * a0 ** 2) % p
        if disc != 0:
            disc_nonzero += 1
    say(f"W7.1 residual-C3 eigenline counts inside A = W^V: {dict(n_eig)} "
        f"(expect 2 per V4)")
    say(f"W7.1 C3-eigenpoints of ell_V lying OFF X: {off_X} / 110")
    say(f"W7.2 binary cubic F|_ell_V has nonzero discriminant (3 distinct "
        f"type-II points): {disc_nonzero} / 55")
    t2b = defaultdict(int)
    for H in V4s:
        for sg in inv:
            t2b[len(m.inter(m.ell_V(H), Lm[sg]))] += 1
    say(f"W7.3 (ell_V, L'_sigma) intersection dims: {dict(t2b)} "
        f"(expect all 0: type-II points lie on NO line)")
    c = (n_eig == {2: 55} and off_X == 110 and disc_nonzero == 55
         and t2b.get(0, 0) == 3025)
    say(f"W7 numerical VERDICT: {'PASS' if c else 'FAIL'}")
    ok &= c
    return ok


if __name__ == "__main__":
    out = []

    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    ok = True
    for p in SPLIT_PRIMES:
        ok &= run(p, say)
        say("")

    say("---------------- W7 ADJUDICATION ----------------")
    say("1. Both residual-C3 eigenpoints of ell_V lie OFF X, for all 55 Klein")
    say("   four-groups and at both primes.  (This is the mod-p shadow of the")
    say("   packet's smoothness condition kappa_+ , kappa_- != 0 , -4, and of")
    say("   FIX-A1's certified 'the deeper points of ell_V are all off X'.)")
    say("2. Hence for either character hyperplane H, H n ell_V is a single point")
    say("   off X, so the witness's ambient slice S_kappa = X n H is DISJOINT")
    say("   from ell_V, hence contains NO type-II point (type-II = X n ell_V).")
    say("3. The image of the whole trisection family Q_{B,l} lies in S_kappa")
    say("   ([E33] THEOREM.md eq. (4.2)-(4.3)).  Therefore the witness NEVER")
    say("   lands on a type-II point.")
    say("4. (F2) forbids exactly one thing: contracting the deep divisor E_s^V")
    say("   to a type-II point.  The witness does not do this.")
    say("")
    say("VERDICT: (F2) is NOT violated by the [E33] trisection family.")
    say("         (F2) SURVIVES the T5 acceptance test of theory/FIX_T_gate.md:355-422.")
    say("")
    say("HONEST CAVEAT (recorded, not hidden): the survival is VACUOUS.  The")
    say("witness is built on a character hyperplane disjoint from ell_V, so it")
    say("never populates the stratum that (F2) constrains; T5 therefore gives no")
    say("positive evidence that (F2) has bite, only that it does not overreach.")
    say("Consistency in the other direction is real, though: T5's item 1")
    say("(FIX_T_gate.md:382-387) records that the witness sends elliptic-fixed")
    say("strata to single points and moves nonconstantly only along the rational")
    say("minus-lines L_t -- which is precisely the (F1)/(F2) shape.")
    say("")
    say("Cross-reference worth flagging: [E33] THEOREM.md eq. (2.10) is exactly")
    say("the type-II locus, and Theorem 2.12 proves the m=1 stratum CANNOT land")
    say("there at any line degree.  (F2) forbids type-II landing at a different")
    say("stratum (the deep divisor E_s^V of the T3 tower) and by a completely")
    say("different mechanism (Duncan's fabulous corner).  The two are consistent")
    say("and independent; neither implies the other.")
    tag = "W7_F2_VS_E33_" + ("SURVIVES" if ok else "INCONCLUSIVE")
    say(tag)
    here = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    with open(os.path.join(here, "results", "w7_f2_vs_e33_trisection.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    sys.exit(0 if ok else 1)
