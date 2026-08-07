#!/usr/bin/env python3
# f55_f2f3.py -- DO (F2) AND (F3) KILL THE 14 MIXED-FAN WITNESSES?
#
# THE SITUATION (Note IX S8.15, S8.26-S8.28).  The campaign reduced F55-NO to the
# four-part system (F1)-(F4) on the single divisor datum D = div(a).  S8.28 closed
# (F1)+(F4) AFFIRMATIVELY: 14 nonnegative integral value-form witnesses on the mixed
# fan lift to genuine Theorem-Q objects with an explicit lattice polytope Q.  The two
# untested layers are
#   (F2) = (iv') of Theorem O:  lambda_O(div a) == 0 (mod 11) at EVERY orbit except
#         the b-split locus;
#   (F3) = Theorem P:  the transpose-layer relations obtained by computing
#         cores(a,b) a second time with the monomial second slot r^x.
# This probe derives both conditions from scratch in a PINNED convention, calibrates
# the machinery against facts the witnesses satisfy by construction, and tests them.
#
# ---------------------------------------------------------------------------------
# 0. THE CONVENTION, PINNED (this is where the source text is ambiguous; see S8.9 vs
#    S8.16 -- the index convention silently flips between them, and the whole test
#    turns on it, so nothing here is taken on trust).
#
#    N = {n in Z^5 : sum n = 0}   cocharacters / rays,  (sig n)_j = n_{j-1};
#    M = Lambda = Z^5 / Z(1,1,1,1,1)   monomial exponents,  <U, n> = sum_j U_j n_j.
#    sig_M := the action on monomial exponents induced by  sig(r^m).
#
#    sig_M is pinned TWICE, independently:
#      (a) by the sealed relation  sig(b) = r_2^{-11} b^{-2}  (S8.11/S8.12), i.e.
#          sig_M(e_b) = -11 e_2 - 2 e_b   in Lambda.  Only shift_{-1} satisfies it.
#      (b) by compatibility with the ray frame that f55_qpreimage.py verified
#          pointwise:  ord_v(sig f) = ord_{sig^{-1} v}(f)  forces sig_M = shift_{-1}.
#    Consequently  psi(a) = a^2 sig(a)  acts on exponents as  2 + sig_M = 2 + shift_{-1},
#    and on order patterns as  ord_{sig^i w}(psi a) = 2 h(sig^i w) + h(sig^{i-1} w)
#    -- exactly S8.16's (2 g_i + g_{i-1}) and exactly the F of the verified code.
#
#    THE TWO WEIGHT SYSTEMS.  In the RAY index (i = the index of the ray sig^i w):
#      lambda_w(y) := sum_i 5^i ord_{sig^i w}(y)     "lambda", S8.12/S8.14
#      L9_w(y)     := sum_i 9^i ord_{sig^i w}(y)     the transpose-kernel functional
#    They are NOT the same functional, and each has exactly one job:
#      * lambda is forced by the b-cover:  [sig^{-i} b] = [b]^{5^i}, and the
#        corestriction transports the residue at sig^i P by sig^{-i}.  It reproduces
#        Theorem M (N_lambda(r_2) = r^c, c = (3,5,1,9,4)) and Theorem L on the nose
#        (verified below at all 460 rays).
#      * L9 is the transpose kernel of (2 + sig_M):  L9 . (2+sigt) = 11 L9 == 0.  It is
#        Theorem R / congruence (3), the h-free law the witnesses satisfy.
#      * lambda is NOT in the transpose kernel:  lambda . (2+sigt) = 7 lambda.
#    (In S8.9's COMPONENT index the two swap names -- 5^i there is 9^i here, because
#    the component index runs opposite to the ray index.  That flip is the source of
#    the ambiguity; see the FINDINGS block at the end.)
#
# 1. (F2) AT A BOUNDARY RAY-ORBIT, DERIVED.
#    phi = psi(a)/r_2, so  ord_{sig^i w}(phi) = F(sig^i w) = 2h(sig^i w)+h(sig^{i-1}w)
#    - <sig^i w, e_2>, with h(w) := v_w(a) = min_{v in Q} <v, w>  (MIN convention: the
#    order of vanishing of a Laurent polynomial along D_w).  Applying lambda:
#
#        lambda_w(phi) = 7 * lambda_w(div a) - <w, c>,     c = sum_i 5^i sig_M^{-i} e_2.
#
#    Theorem N asserts lambda_w(phi) == -<w,c>; since 7 is a unit mod 11 this is
#    EXACTLY  lambda_w(div a) == 0 (mod 11), i.e. Theorem N at the boundary IS (F2)
#    at the boundary.  It is not an independent calibration fact.  Two equivalent
#    computable forms (all three routes are evaluated and cross-checked below):
#        lambda_w(div a) == 8 * ( lambda_w(d) + <w,c> )   (8 = 7^{-1} mod 11),
#        lambda_w(d) := sum_i 5^i d(sig^i w)   -- d the shadow witness; legitimate
#        because F = d + m with m sigma-invariant and lambda kills sigma-invariants:
#        sum_i 5^i = 781 = 11*71 == 0 (mod 11).
#    The same fact makes the test INDEPENDENT of (i) the h -> h + (sigma-invariant k)
#    freedom of the lift (S8.28: the general solution is h_0 + k, m = D + 3k), and
#    (ii) the min/max support-function convention (they differ by T*Phi, Phi
#    sigma-invariant).  Base-point rotation gives lambda_{sig w} == 9 * lambda_w, so
#    the VALUE is not an orbit invariant (Correction IX-d is right) but the VANISHING
#    is -- which is all (F2) asserts.
#
# 2. (F3), DERIVED.  The alignment S8.10 says e_b lies in the image of the psi-operator
#    so that b = const * psi(r^x).  In the pinned convention that is FALSE:
#    L9(e_b) = 7 != 0, and (2+sig_M) x = e_b has no solution in Lambda.  What IS true
#    is the transpose statement:  lambda(e_b) = 11 == 0, and
#        (2 + sig_M^{-1}) x = e_b   with   x = (0, 2, -3, 2, 0)   EXACTLY,
#    i.e. b = const * psi*(r^x) with psi* = 2 + sig^{-1}.  Adjunction then gives
#        cores(a, b) = cores(psi(a), r^x)      (psi and psi* swap roles vs. S8.15).
#    Computing both residues with the corestricted tame symbol
#        d_q(cores(r^u, r^m)) = r^{ sum_i [ <sig^i w, m> shift_i(u)
#                                          - <sig^i w, u> shift_i(m) ] }
#    (validated below by reproducing Theorem L exactly), the two computations agree
#    TERM BY TERM: the leading-unit exponents match because
#        2<sig^i w, x> + <sig^{i+1} w, x> = <sig^i w, e_b>   (exact, all i, all w),
#    and the monomial parts match because, for every integer order pattern (g_i),
#        sum_i g_i shift_i(e_b) = sum_i (2 g_i + g_{i-1}) shift_i(x)   (exact),
#        sum_i g_i <sig^i w, e_b> = sum_i (2 g_i + g_{i-1}) <sig^i w, x>  (exact).
#    So (F3) is an IDENTITY, not a constraint.  Both identities are tested over Z on
#    every witness at every ray, and broken on demand by perturbing x.
#
# 3. WHAT THE WITNESS DETERMINES.  Only the BOUNDARY of div(a): v_w(a) = h_Q(w) at the
#    460 rays.  The interior part of div(a) is not determined by Q, so every verdict
#    below is scoped to the boundary.
#
# ---------------------------------------------------------------------------------
# RESULT (details, controls and caveats in sections 5-9).
#   * CALIBRATION: the 9-weighted law (Theorem R / congruence (3)) is clean at 92/92
#     boundary ray-orbits on 14/14 witnesses through this probe's own machinery, and
#     its ray-orbit rows are IMPLIED by the parent probe's independent cell-level
#     congruence encoding.  Theorem L is reproduced exactly at all 460 rays.
#   * (F2) FAILS on all 14 witnesses (77-78 of 92 orbits each; every passing orbit is
#     b-split-exempt anyway), and is INFEASIBLE on their entire solution families --
#     with Farkas certificates, including one-row ones.  Mechanism: at 52 of the 92
#     orbits d is divisible by 11 at all five conjugate rays for every family member,
#     so both lambda-functionals vanish and each law collapses to its covector; c9 is
#     orthogonal to those rays (congruence (3) survives) and c is not (F2 dies).
#   * (F3) is an IDENTITY and kills nothing.
#   * CAVEAT F-2: in the pinned convention Theorem N is EQUIVALENT to (F2), not
#     independent of it, so the source's boundary derivation of (F2) is circular.  The
#     kill is therefore conditional on (F2) being repairable; it does NOT establish
#     Lemma S, F55-NO or ed = 4.
#
# Reproduce:  python3 f55_f2f3.py        (deterministic; seeds fixed; ~2 min)
import os, sys, io, time, random, contextlib
import numpy as np
from fractions import Fraction as Fr
from math import gcd
from itertools import combinations

T00 = time.time()
SEED = 20260808
HERE = os.path.dirname(os.path.abspath(__file__))
PARENT = os.path.join(HERE, "f55_qpreimage.py")
MARK = "# ============================================================ 6. run the patterns"


def hdr(s): print("\n" + "=" * 78 + "\n== " + s + "\n" + "=" * 78)
def sub(s): print("\n--- " + s)


# ============================================================ load the parent probe
# f55_witness_dump.py uses exactly this pattern (exec the probe with its driver
# truncated) so that the objects under test are the RECORDED ones, not a re-derivation.
hdr("0. machinery: mixed fan + the 14 witnesses, from f55_qpreimage.py sections 0-5")
t0 = time.time()
src = open(PARENT).read()
cut = src.index(MARK)
ns = {"__name__": "f55_qpreimage_partial", "__file__": PARENT}
_buf = io.StringIO()
with contextlib.redirect_stdout(_buf):
    exec(compile(src[:cut], PARENT, "exec"), ns)
NC, CK, PTS, SC = ns["NC"], ns["CK"], ns["PTS"], ns["SC"]
SIG, SIGI, ORB, KIDX, OIDX = ns["SIG"], ns["SIGI"], ns["ORB"], ns["KIDX"], ns["OIDX"]
WALLS, WNU = ns["WALLS"], ns["WNU"]
RAYS, R4, NR, RCELL, INCID = ns["RAYS"], ns["R4"], ns["NR"], ns["RCELL"], ns["INCID"]
S, SP, SM, PHI_S = ns["S"], ns["SP"], ns["SM"], ns["PHI_S"]
GPERM, GIDX, GORB, GCELLS = ns["GPERM"], ns["GIDX"], ns["GORB"], ns["GCELLS"]
E2, E24, C9_PAR, G9 = ns["E2"], ns["E24"], ns["c9"], ns["G9"]
pairs, INV11 = ns["pairs"], ns["INV11"]
sigN, nf4, lift5, to4, imatmul = ns["sigN"], ns["nf4"], ns["lift5"], ns["to4"], ns["imatmul"]
cell_of_mixed, phi_slopes = ns["cell_of_mixed"], ns["phi_slopes"]
op_2plus, op_N, op_G, op_sigt = ns["op_2plus"], ns["op_N"], ns["op_G"], ns["op_sigt"]
CONST_E2 = ns["CONST_E2"]
build_witness, certify_d = ns["build_witness"], ns["certify_d"]
solve_preimage, verify_preimage = ns["solve_preimage"], ns["verify_preimage"]
convexify, is_convex, is_concave = ns["convexify"], ns["is_convex"], ns["is_concave"]
ray_consistent = ns["ray_consistent"]
integer_solution_lattice = ns["integer_solution_lattice"]
farkas_or_interior, exact_rref_frac = ns["farkas_or_interior"], ns["exact_rref_frac"]
echelon_p, kernel_from_rref = ns["echelon_p"], ns["kernel_from_rref"]
_FANCACHE = ns["_FANCACHE"]
print(f"loaded: {NC} cells, {len(WALLS)} walls, {NR} rays, {len(ORB)} cell-orbits "
      f"[{time.time()-t0:.1f}s]")
assert (NC, len(WALLS), NR, len(ORB)) == (1090, 2570, 460, 218)

# ============================================================ 1. conventions, pinned
hdr("1. CONVENTIONS PINNED INDEPENDENTLY (sig_M, psi, the two weight systems)")
EB = np.array([2, 1, -4, 4, 0], dtype=np.int64)          # b = r0^2 r1 r3^4 r2^-4
E2v = np.array([0, 0, 1, 0, 0], dtype=np.int64)          # r_2
DIAG = np.ones(5, dtype=np.int64)
W5 = [pow(5, i, 11) for i in range(5)]                   # lambda weights (ray index)
W9 = [pow(9, i, 11) for i in range(5)]                   # transpose-kernel weights
NN = np.array([1, 1, -2, 2, 0], dtype=np.int64)          # the n of S8.12 item 3


def shift(v, k):
    """(shift_k v)_i = v_{(i+k) mod 5}.  shift_{-1} = S = sig_M ; shift_{+k} = sig_M^{-k}."""
    return np.array([v[(i + k) % 5] for i in range(5)], dtype=np.int64)


def is_diag_multiple(v):
    return len(set(int(x) for x in v)) == 1


def eq_lambda(u, v):                                     # equality in Lambda = Z^5/diag
    return is_diag_multiple(np.asarray(u) - np.asarray(v))


sub("(a) sig_M from the sealed relation sig(b) = r_2^{-11} b^{-2}")
tgt = -11 * E2v - 2 * EB
for k, nm in ((-1, "shift_{-1}"), (+1, "shift_{+1}")):
    ok = eq_lambda(shift(EB, k), tgt)
    print(f"    sig_M = {nm:12s}: sig_M(e_b) == -11 e_2 - 2 e_b in Lambda: {ok}"
          + ("   <== PINNED" if ok else ""))
assert eq_lambda(shift(EB, -1), tgt) and not eq_lambda(shift(EB, +1), tgt)
print(f"    (difference for shift_{{-1}}: {tuple(int(z) for z in shift(EB,-1)-tgt)} "
      f"= 4*diag, i.e. equality in Lambda)")
print("    consequence: [sig b] = [b]^-2 = [b]^9 and [sig^{-1} b] = [b]^5  (S8.12 item 3):",
      eq_lambda(shift(EB, +1) % 11, (5 * EB) % 11) or
      is_diag_multiple((shift(EB, +1) - 5 * EB) % 11))
assert is_diag_multiple((shift(EB, +1) - 5 * EB) % 11)
print(f"    exact form sig^{{-1}}(b) = b^5 n^{{-11}}, n = r^{tuple(int(z) for z in NN)}: "
      f"{eq_lambda(shift(EB, +1), 5 * EB - 11 * NN)}")
assert eq_lambda(shift(EB, +1), 5 * EB - 11 * NN)

sub("(b) sig_M from the ray frame that f55_qpreimage.py verified pointwise")
# <sig^k w, U> = <w, shift_k U>  (parent, 8000 trials).  ord_v(sig f) = ord_{sig^{-1}v}(f)
# therefore for f = r^m: <v, sig_M m> = <sig^{-1} v, m> = <v, shift_{-1} m>.
rr = random.Random(SEED)
bad = 0
for _ in range(2000):
    n = [rr.randint(-40, 40) for _ in range(5)]; n[4] = -sum(n[:4]); n = np.array(n)
    m = np.array([rr.randint(-40, 40) for _ in range(5)])
    ni = n
    for _ in range(4): ni = np.array(sigN(tuple(int(z) for z in ni)))   # sig^{-1} n
    bad += int(int(ni @ m) != int(n @ shift(m, -1)))
print(f"    <sig^{{-1}} v, m> == <v, shift_{{-1}} m> on 2000 random pairs: {bad} failures"
      f"  =>  sig_M = shift_{{-1}} = S  (agrees with (a))")
assert bad == 0
print(f"    parent's S (sigma_* on Lambda, normalized coords) == shift_{{-1}}: "
      f"{all((S @ nf4(np.array([rr.randint(-9,9) for _ in range(5)]))).shape == (4,) for _ in range(1))}"
      f" (structural; parent verified it on 2000 random U)")

sub("(c) the two weight systems on order patterns")
# pattern of psi(a) at the ray sig^i w is 2 g_i + g_{i-1}; apply each functional.
rr2 = random.Random(SEED + 1)
c5 = c9c = 0
for _ in range(4000):
    g = [rr2.randint(-50, 50) for _ in range(5)]
    pat = [2 * g[i] + g[(i - 1) % 5] for i in range(5)]
    l5g = sum(W5[i] * g[i] for i in range(5))
    l9g = sum(W9[i] * g[i] for i in range(5))
    c5 += int((sum(W5[i] * pat[i] for i in range(5)) - 7 * l5g) % 11 == 0)
    c9c += int((sum(W9[i] * pat[i] for i in range(5))) % 11 == 0)
print(f"    lambda(2 g_i + g_{{i-1}}) == 7 * lambda(g)  (mod 11): {c5}/4000")
print(f"    L9  (2 g_i + g_{{i-1}}) ==      0        (mod 11): {c9c}/4000   [2 + 9 = 11]")
assert c5 == 4000 and c9c == 4000
print(f"    sum_i 5^i = {sum(5**i for i in range(5))} = 11*71 == 0 (mod 11)  "
      f"=> lambda kills sigma-invariant patterns")
print(f"    sum_i 9^i = {sum(9**i for i in range(5))} = 11*671 == 0 (mod 11)")
print("    ==> lambda is NOT the transpose kernel of psi in the ray index; L9 is.")

sub("(d) c, c9, and the alignment exponent x")
Cv = sum(W5[i] * shift(E2v, i) for i in range(5)) % 11
C9v = sum(W9[i] * shift(E2v, i) for i in range(5)) % 11
print(f"    c  = sum_i 5^i sig_M^{{-i}} e_2 = {tuple(int(z) for z in Cv)}  (S8.14: (3,5,1,9,4))")
print(f"    c9 = sum_i 9^i sig_M^{{-i}} e_2 = {tuple(int(z) for z in C9v)}  (S8.17: (4,9,1,5,3))")
assert tuple(int(z) for z in Cv) == (3, 5, 1, 9, 4)
assert tuple(int(z) for z in C9v) == (4, 9, 1, 5, 3) == tuple(C9_PAR), \
    "c9 disagrees with the parent probe's own constant"
lam5_eb = sum(W5[i] * int(EB[i]) for i in range(5)) % 11
lam9_eb = sum(W9[i] * int(EB[i]) for i in range(5)) % 11
print(f"    lambda(e_b) == {lam5_eb} (mod 11)   [S8.10: 2+5-12+16 = 11 == 0]")
print(f"    L9(e_b)     == {lam9_eb} (mod 11)")
GCo = [16, -8, 4, -2, 1]


def solve_2plus(target, sgn):
    """solve (2 + shift_{sgn}) x = target in Lambda = Z^5/diag; return x or None.
       Uses (2+t)G(t) = 33 with G = 16-8t+4t^2-2t^3+t^4, and G(1) = 11 for the diag
       correction: (2+t)(x + s*diag/?) -- diag is an eigenvector with eigenvalue 3."""
    for s in range(-33, 34):                       # target + s*diag, s the diag freedom
        tt = np.asarray(target) + s * DIAG
        Gt = sum(GCo[j] * shift(tt, sgn * j) for j in range(5))
        if not (Gt % 33).any():
            x = Gt // 33
            assert eq_lambda(2 * x + shift(x, sgn), target)
            return x
    return None


def norm_diag(v):
    """canonical representative in Lambda = Z^5/diag: last coordinate 0."""
    return np.asarray(v) - int(v[4]) * DIAG


xs = solve_2plus(EB, -1)
xt = solve_2plus(EB, +1)
if xt is not None: xt = norm_diag(xt)
if xs is not None: xs = norm_diag(xs)
print(f"    (2 + sig_M)  x = e_b  [S8.10's literal claim b = const*psi(r^x)]: "
      f"{'x = ' + str(tuple(int(z) for z in xs)) if xs is not None else 'NO SOLUTION'}")
print(f"    (2 + sig_M^-1) x = e_b [the transpose statement b = const*psi*(r^x)]: "
      f"{'x = ' + str(tuple(int(z) for z in xt)) if xt is not None else 'NO SOLUTION'}")
assert xs is None and xt is not None
XV = xt
print(f"    ==> x = {tuple(int(z) for z in XV)}, EXACTLY: 2x + sig_M^{{-1}}x = "
      f"{tuple(int(z) for z in (2*XV + shift(XV, +1)))} = e_b: "
      f"{tuple(int(z) for z in (2*XV + shift(XV,+1))) == tuple(int(z) for z in EB)}")
assert (2 * XV + shift(XV, +1) == EB).all()
print("    ==> S8.10/Theorem P have psi and psi* interchanged relative to the pinned")
print("        convention; the layer survives with cores(a,b) = cores(psi(a), r^x).")

# ============================================================ 2. residue machinery
hdr("2. the corestricted tame symbol, and Theorem L reproduced at all 460 rays")
R5 = np.array([[r[0], r[1], r[2], r[3], -int(sum(r))] for r in R4.tolist()], dtype=np.int64)
assert not R5.sum(1).any()
RIDX = {tuple(int(z) for z in R4[i]): i for i in range(NR)}
SIGR = np.array([RIDX[tuple(int(z) for z in np.array(sigN(tuple(int(v) for v in R5[i])))[:4])]
                 for i in range(NR)], dtype=np.int64)
RORB = []; seen = set()
for i in range(NR):
    if i in seen: continue
    o = [i]
    for _ in range(4): o.append(int(SIGR[o[-1]]))
    assert len(set(o)) == 5 and int(SIGR[o[-1]]) == i, "ray orbit not free of size 5"
    seen.update(o); RORB.append(o)
print(f"the {NR} rays are sigma-stable and form {len(RORB)} FREE orbits of size 5 "
      f"(N^sigma = 0, S8.14): {5*len(RORB) == NR}")
assert 5 * len(RORB) == NR


def sig_ray(i, k):
    for _ in range(k % 5): i = int(SIGR[i])
    return i


def cores_symbol(u, m, i):
    """exponent V of  d_q(cores(r^u, r^m))  at the boundary orbit of ray i, as an
       element of Lambda (well-defined mod diag), by transporting the tame symbol at
       sig^k w by sig^{-k}:  V = sum_k [ <sig^k w, m> shift_k(u) - <sig^k w, u> shift_k(m) ]."""
    V = np.zeros(5, dtype=np.int64)
    for k in range(5):
        wk = R5[sig_ray(i, k)]
        V = V + int(wk @ m) * shift(u, k) - int(wk @ u) * shift(m, k)
    return V


badperp = badL = 0
for i in range(NR):
    V = cores_symbol(-E2v, EB, i)
    if int(R5[i] @ V) != 0: badperp += 1
    w = R5[i]
    pred = (int(w @ Cv)) * EB - (int(w @ EB)) * Cv
    if not is_diag_multiple((V - pred) % 11): badL += 1
print(f"V is orthogonal to w at every ray (exact): {NR - badperp}/{NR}")
print(f"THEOREM L reproduced: d_q(cores(r_2^-1, b)) == [ r^{{<w,c> e_b - <w,e_b> c}} ] "
      f"in Lambda/11 at every ray: {NR - badL}/{NR}")
assert badperp == 0 and badL == 0
print("   (this is the calibration of the residue machinery itself: an independent")
print("    formula from the source, reproduced from the tame symbol + [sig^-i b]=[b]^{5^i})")
kc = np.array([int(R5[i] @ Cv) % 11 for i in range(NR)])
kb = np.array([int(R5[i] @ EB) % 11 for i in range(NR)])
print(f"rays with <w,c>   == 0 (mod 11): {int((kc == 0).sum())}/{NR}")
print(f"rays with <w,e_b> == 0 (mod 11): {int((kb == 0).sum())}/{NR}")
print(f"rays with BOTH == 0 (Theorem L: residue of B vanishes): "
      f"{int(((kc == 0) & (kb == 0)).sum())}/{NR}")

# ============================================================ 3. the b-split locus
hdr("3. THE b-SPLIT LOCUS: which boundary orbits are exempt from (F2)")
print("""  What (F2)'s exemption means at a BOUNDARY ray.  With a uniformizer t = r^pi,
  <w,pi> = 1, the residue of 7*cores(a,b) at the orbit of w is
      [ prod_i L_i^{<sig^i w, e_b>} ] * [ r^{-A + alpha*pi} ]^7,
      L_i := sig^{-i}(leading unit of a along D_{sig^i w}),
      A := sum_i g_i shift_i(e_b) == lambda_w(a) * e_b,
      alpha := sum_i g_i <sig^i w, e_b> == lambda_w(a) * <w, e_b>   (mod 11).
  Changing pi by u in w-perp multiplies the monomial factor by r^{alpha*u} and the
  L-factor by r^{-alpha*u}: the TOTAL is well defined, the SPLIT is not.  Hence:
    * if <w, e_b> == 0 (mod 11): alpha == 0, the L-factor exponents <sig^i w, e_b> ==
      5^i <w,e_b> == 0 are all divisible by 11 so the L-factor is an 11th power
      (TRIVIAL), and the residue is exactly the character class -7*lambda_w(a)*e_b.
      Since e_b is not 0 in Lambda/11 and w-perp is a direct summand, this vanishes
      IFF lambda_w(div a) == 0 (mod 11).  Here (F2) is well posed and has teeth.
    * if <w, e_b> != 0 (mod 11): the b-factor is not separately defined and the
      residue depends on the leading forms of a, which div(a) does not determine.
  Criteria reported below:
    E1  = the brief's / Theorem L's:  <w,c> == 0 AND <w,e_b> == 0 (mod 11);
    E2  = the strict one ("b|_{D_w} is an 11th power in kappa(D_w)^*"): needs
          <w,e_b> = 0 exactly AND e_b in 11*Lambda -- and e_b mod 11 = (2,1,7,4,0)
          is not a multiple of diag, so E2 is EMPTY at the boundary;
    E3  = the orbits where the b-factor IS well posed: <w,e_b> == 0 (mod 11).  On the
          complement of E3, (F2) is not a statement about div(a) alone (it needs the
          leading forms of a), so it is on E3 that (F2) has genuine teeth.""")
E1 = [o for o in RORB if kc[o[0]] == 0 and kb[o[0]] == 0]
E3 = [o for o in RORB if kb[o[0]] == 0]
for o in RORB:                                   # the criteria are orbit functions
    assert len(set(int(kb[j] == 0) for j in o)) == 1
    assert len(set(int(kc[j] == 0) for j in o)) == 1
e2_is_11th = is_diag_multiple(EB % 11)
print(f"  b-split-exempt orbits:  E1: {len(E1)}/{len(RORB)}   E2: "
      f"{0 if not e2_is_11th else len(RORB)}/{len(RORB)}   |   orbits where (F2) is well "
      f"posed (E3): {len(E3)}/{len(RORB)}")
print(f"  (e_b mod 11 = {tuple(int(z) for z in EB % 11)} is a multiple of diag: {e2_is_11th})")
print(f"  PRIMARY criterion used for the headline table: E1 (the brief's).  The E3 column")
print(f"  is reported alongside because it is the one the derivation actually supports.")

# ============================================================ 4. the witnesses
hdr("4. THE 14 WITNESSES, rebuilt, and their boundary lambda-data")
PATTERNS = []
for P0 in [(3, 4), (0, 1)]:
    Z = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P0]
    PATTERNS.append((f"G9-rank P={list(P0)}", Z))
LAB = {}
for gi, og in enumerate(GORB):
    LAB[gi] = {GPERM[g].index(0): g for g in og}
for gi0 in (0, 1, 2):
    for (i0, j0) in pairs:
        if (i0, j0) == (0, 1): continue
        zg = set()
        for gi in range(len(GORB)):
            for t in ({i0, j0} if gi == gi0 else {0, 1}): zg.add(LAB[gi][t])
        Ze = sorted(c for g in zg for c in GCELLS[g])
        if min(sum(1 for c in o if c in set(Ze)) for o in ORB) < 2: continue
        PATTERNS.append((f"(e) G9-orbit {gi0} -> {(i0,j0)}", Ze))
print(f"pattern list: {len(PATTERNS)} candidates (2 rank patterns + "
      f"{len(PATTERNS)-2} one-orbit (e)-variants)")


def ray_values(U):
    """value of the PL function with slope field U at each of the 460 rays."""
    V = U @ R4.T
    for i in range(NR):
        assert len(set(int(V[c, i]) for c in RCELL[i])) == 1, "ray value cell-dependent"
    return np.array([int(V[RCELL[i][0], i]) for i in range(NR)], dtype=np.int64)


def wsum(vals, wts, i):
    return sum(wts[k] * int(vals[sig_ray(i, k)]) for k in range(5))


def F_at_rays(hr):
    """F(sig^i w) = 2h(sig^i w) + h(sig^{i-1} w) - <sig^i w, e_2>, at every ray."""
    out = np.zeros(NR, dtype=np.int64)
    for i in range(NR):
        out[i] = 2 * int(hr[i]) + int(hr[sig_ray(i, 4)]) - int(R5[i] @ E2v)
    return out


WIT = []
for (tag, Z) in PATTERNS:
    with contextlib.redirect_stdout(_buf):
        U5d, msg = build_witness(tag, Z)
    if U5d is None:
        print(f"  {tag:28s}: no witness ({msg})")
        continue
    with contextlib.redirect_stdout(_buf):
        certify_d(U5d, Z, tag, npts=1200)
        Uh, Um = solve_preimage(U5d, tag)
        assert Uh is not None
        verify_preimage(Uh, Um, U5d, tag)
        Tk, Ucav = convexify(Uh, tag, -1)
        Tc, Ucvx = convexify(Uh, tag, +1)
    assert Ucav is not None and is_concave(Ucav) == 0
    WIT.append(dict(tag=tag, Z=Z, Ud=U5d, Uh=Uh, Um=Um, Ucav=Ucav, Ucvx=Ucvx, Tk=Tk, Tc=Tc))
    print(f"  {tag:28s}: witness ok (max|U_d| = {int(np.abs(U5d).max()):4d}), lifts "
          f"(max|U_h| = {int(np.abs(Uh).max()):4d}), concave at T = {Tk}, convex at T = {Tc}")
print(f"\n{len(WIT)} witnesses rebuilt and re-certified (expected 14: {len(WIT) == 14})")
assert len(WIT) == 14

sub("v_w(a) = h_Q(w): THREE independent evaluations, at all 460 rays, per witness")
print("  (1) slope field of the lifted h_0;  (2) the min-support (concave) realization")
print("      h_0 - T*Phi;  (3) BRUTE FORCE over the lattice points of Q = conv{U(C)},")
print("      no fan, no cells: h_Q(w) = min_{v in Q} <v, w>.  (1) and (2) differ by the")
print("      sigma-invariant T*Phi, so lambda mod 11 must agree for all three.")
for W in WIT:
    hr0 = ray_values(W["Uh"])
    hrc = ray_values(W["Ucav"])
    V = np.array(sorted(set(map(tuple, W["Ucav"].tolist()))), dtype=np.int64)
    hrQ = (V @ R4.T).min(0)
    W["hr"] = hrc; W["hrQ"] = hrQ; W["hr0"] = hr0
    W["dr"] = ray_values(W["Ud"])
    same = int((hrc != hrQ).sum())
    l_c = [wsum(hrc, W5, o[0]) % 11 for o in RORB]
    l_Q = [wsum(hrQ, W5, o[0]) % 11 for o in RORB]
    l_0 = [wsum(hr0, W5, o[0]) % 11 for o in RORB]
    W["lam"] = l_c
    assert l_c == l_Q == l_0, "lambda depends on the convention -- STOP"
    if W is WIT[0] or W is WIT[1]:
        print(f"  [{W['tag']}] fan-free h_Q == slope-field h at rays: {NR-same}/{NR}; "
              f"lambda agrees for all three evaluations at all {len(RORB)} orbits: "
              f"{l_c == l_Q == l_0}")
print(f"  (all {len(WIT)} witnesses: 0 disagreements between the three evaluations)")

# ============================================================ 5. CALIBRATION GATE
hdr("5. CALIBRATION GATE")
print("""  The brief asks for Theorem N (lambda_w(phi) == -<w,c>) as a gate that 'must come
  out clean because it is equivalent to congruence (3)'.  It is NOT equivalent:
  congruence (3) is the 9-weighted law (Theorem R), and the derivation of section 1(c)
  gives lambda_w(phi) = 7 lambda_w(div a) - <w,c>, so Theorem N is EXACTLY (F2).  The
  gate is therefore run in BOTH weightings through the SAME code path: the 9-weighted
  law is the true calibration (the witnesses satisfy it by construction, so it must be
  clean); the 5-weighted law is the (F2) test itself.""")
rows = []
for W in WIT:
    Fr_ = F_at_rays(W["hr"])
    W["Fr"] = Fr_
    g9 = sum(1 for o in RORB if (wsum(Fr_, W9, o[0]) + int(R5[o[0]] @ C9v)) % 11 == 0)
    g5 = sum(1 for o in RORB if (wsum(Fr_, W5, o[0]) + int(R5[o[0]] @ Cv)) % 11 == 0)
    # the same two laws read off the shadow d (F = d + m, m sigma-invariant)
    d9 = sum(1 for o in RORB if (wsum(W["dr"], W9, o[0]) + int(R5[o[0]] @ C9v)) % 11 == 0)
    d5 = sum(1 for o in RORB if (wsum(W["dr"], W5, o[0]) + int(R5[o[0]] @ Cv)) % 11 == 0)
    rows.append((W["tag"], g9, d9, g5, d5))
    W["N5"] = g5
print(f"\n  {'pattern':30s} {'R/(3): 9-wtd on F':>18s} {'on d':>6s} {'N/(F2): 5-wtd on F':>20s} {'on d':>6s}")
for (t, g9, d9, g5, d5) in rows:
    print(f"  {t:30s} {g9:14d}/92 {d9:5d} {g5:16d}/92 {d5:5d}")
allg9 = all(r[1] == len(RORB) and r[2] == len(RORB) for r in rows)
print(f"\n  GATE (9-weighted Theorem R / congruence (3)) clean at every orbit of every "
      f"witness: {allg9}")
assert allg9, "calibration failed -- the machinery or the convention is wrong"
print("  ==> the lambda-machinery, the ray orbits, the transport and the c-covectors are")
print("      validated: with the transpose-kernel weights the law is exact, 92/92, 14/14.")
print(f"  The SAME code with the b-cover weights 5^i gives "
      f"{sum(r[3] for r in rows)}/{92*len(WIT)} orbit-passes in total.")

# ============================================================ 6. (F2) on the witnesses
hdr("6. (F2) = (iv') AT EVERY BOUNDARY RAY-ORBIT, ON ALL 14 WITNESSES")
print("  condition: lambda_O(div a) = sum_i 5^i v_{sig^i w}(a) == 0 (mod 11)")
print("  cross-check: lambda_O(div a) == 8 * ( lambda_O(d) + <w,c> )   [8 = 7^-1 mod 11]")
E1set = set(o[0] for o in E1); E3set = set(o[0] for o in E3)
print(f"\n  {'pattern':30s} {'pass':>5s} {'fail':>5s} {'pass in E1':>11s} "
      f"{'pass off E1':>12s} {'fail in E3':>11s}")
for W in WIT:
    xchk = 0
    pas = fail = 0; pin = poff = 0; f3 = 0
    for oi, o in enumerate(RORB):
        i0 = o[0]
        lam = W["lam"][oi]
        alt = (8 * ((wsum(W["dr"], W5, i0) + int(R5[i0] @ Cv)) % 11)) % 11
        xchk += int(lam == alt)
        if lam == 0:
            pas += 1
            if i0 in E1set: pin += 1
            else: poff += 1
        else:
            fail += 1
            if i0 in E3set: f3 += 1
    assert xchk == len(RORB), "the two routes to lambda_O(div a) disagree"
    W["pass"] = pas; W["fail"] = fail; W["pin"] = pin; W["failE3"] = f3
    print(f"  {W['tag']:30s} {pas:5d} {fail:5d} {pin:11d} {poff:12d} {f3:11d}")
print(f"\n  every witness: the two independent routes to lambda_O(div a) agree at all "
      f"{len(RORB)} orbits.")
print(f"  the {len(E1)} b-split-exempt (E1) orbits absorb NO failures for any witness "
      f"({all(W['pin'] == len(E1) for W in WIT)}): every E1 orbit passes (F2) outright,")
print("  so the exemption is inert -- it exempts exactly the orbits that did not need it.")
print(f"  overall pass rate {sum(W['pass'] for W in WIT)}/{92*len(WIT)} = "
      f"{sum(W['pass'] for W in WIT)/(92*len(WIT)):.3f}; OFF the E1 orbits it is "
      f"{sum(W['pass']-W['pin'] for W in WIT)}/{(92-len(E1))*len(WIT)} = "
      f"{sum(W['pass']-W['pin'] for W in WIT)/((92-len(E1))*len(WIT)):.3f} "
      f"(chance = 1/11 = {1/11:.3f}).")

# ============================================================ 7. (F3)
hdr("7. (F3) = Theorem P: the transpose layer, tested over Z")
print("  identity 1 (leading-unit exponents): 2<sig^i w,x> + <sig^{i+1} w,x> == <sig^i w,e_b>")
b1 = 0
for i in range(NR):
    for k in range(5):
        wk = R5[sig_ray(i, k)]; wk1 = R5[sig_ray(i, k + 1)]
        if 2 * int(wk @ XV) + int(wk1 @ XV) != int(wk @ EB): b1 += 1
print(f"    at all {NR} rays x 5 indices: {5*NR - b1}/{5*NR} exact")
assert b1 == 0
print("  identity 2 (monomial parts): sum_i g_i shift_i(e_b) == sum_i (2g_i+g_{i-1}) shift_i(x)")
print("  identity 3 (scalar parts):   sum_i g_i <sig^i w,e_b> == sum_i (2g_i+g_{i-1}) <sig^i w,x>")


def f3_check(hr, XX):
    b2 = b3 = 0
    for oi, o in enumerate(RORB):
        i0 = o[0]
        g = [int(hr[sig_ray(i0, k)]) for k in range(5)]
        G = [2 * g[k] + g[(k - 1) % 5] for k in range(5)]
        L = sum(g[k] * shift(EB, k) for k in range(5))
        Rr = sum(G[k] * shift(XX, k) for k in range(5))
        if not eq_lambda(L, Rr): b2 += 1
        ls = sum(g[k] * int(R5[sig_ray(i0, k)] @ EB) for k in range(5))
        rs = sum(G[k] * int(R5[sig_ray(i0, k)] @ XX) for k in range(5))
        if ls != rs: b3 += 1
    return b2, b3


tot2 = tot3 = 0
for W in WIT:
    b2, b3 = f3_check(W["hr"], XV)
    tot2 += b2; tot3 += b3
    W["F3"] = (b2, b3)
print(f"    over all {len(WIT)} witnesses x {len(RORB)} orbits: identity 2 fails "
      f"{tot2}/{len(WIT)*len(RORB)}, identity 3 fails {tot3}/{len(WIT)*len(RORB)}")
assert tot2 == 0 and tot3 == 0
sub("collapse: the S8.15 form of the monomial part")
b4 = 0
for W in WIT[:3]:
    for oi, o in enumerate(RORB):
        i0 = o[0]
        g = [int(W["hr"][sig_ray(i0, k)]) for k in range(5)]
        L = sum(g[k] * shift(EB, k) for k in range(5))
        if not is_diag_multiple((L - W["lam"][oi] * EB) % 11): b4 += 1
print(f"    sum_i g_i shift_i(e_b) == lambda_w(div a) * e_b in Lambda/11: "
      f"{3*len(RORB)-b4}/{3*len(RORB)}   (Theorem O's collapse, reproduced)")
assert b4 == 0
sub("CONTROL: the identities are not vacuous -- perturb x")
rr3 = random.Random(SEED + 7)
nb = 0
for trial in range(6):
    dl = np.array([rr3.randint(-2, 2) for _ in range(5)], dtype=np.int64)
    if is_diag_multiple(dl): dl[0] += 1
    b2, b3 = f3_check(WIT[0]["hr"], XV + dl)
    nb += int(b2 > 0 or b3 > 0)
    print(f"    x + {tuple(int(z) for z in dl)}: identity-2 failures {b2}/{len(RORB)}, "
          f"identity-3 failures {b3}/{len(RORB)}")
print(f"    perturbed x breaks the identities in {nb}/6 trials (the test is live)")
assert nb == 6
print("\n  ==> (F3) holds identically for EVERY integer order pattern, for the exact")
print("      reason that e_b = (2 + sig^{-1}) x.  It is an identity, not a constraint,")
print("      so it cannot kill anything.")

# ============================================================ 8. CONTROLS for (F2)
hdr("8. CONTROLS FOR (F2)")
sub("(a1) configurations that PASS: every sigma-invariant h passes at every orbit")
# the 20 arrangement forms fall into sigma-orbits; equal coefficients on an orbit give
# a sigma-invariant PL function sum_t co_t |<l_t, .>|.
FORMS = ns["FORMS"]; FNAME = ns["FNAME"]
FI = {}
for t, v in enumerate(FORMS):
    FI[tuple(int(z) for z in nf4(np.array(v)))] = t
    FI[tuple(int(-z) for z in nf4(np.array(v)))] = t
sigform = []
for t, v in enumerate(FORMS):
    sv = shift(np.array(v, dtype=np.int64), -1)          # sigma_* on Lambda
    sigform.append(FI[tuple(int(z) for z in nf4(sv))])
sigform = np.array(sigform)
forb = []; sn = set()
for t in range(20):
    if t in sn: continue
    o = [t]
    while int(sigform[o[-1]]) != t: o.append(int(sigform[o[-1]]))
    sn.update(o); forb.append(o)
print(f"    the 20 forms fall into {len(forb)} sigma-orbits of sizes "
      f"{sorted(len(o) for o in forb)}")
rr4 = random.Random(SEED + 11)
okinv = 0; okinv_lin = 0; ninv = 40
for _ in range(ninv):
    co = [0] * 20
    for o in forb:
        v = rr4.randint(-8, 8)
        for t in o: co[t] = v
    U = phi_slopes(co)
    hr = ray_values(U)
    # sigma-invariance of the value, checked directly at the rays
    assert all(int(hr[i]) == int(hr[int(SIGR[i])]) for i in range(NR))
    okinv += int(all(wsum(hr, W5, o[0]) % 11 == 0 for o in RORB))
    lin = np.array([rr4.randint(-9, 9) for _ in range(4)], dtype=np.int64)
    hrl = ray_values(U + lin[None, :])
    okinv_lin += int(all(wsum(hrl, W5, o[0]) % 11 == 0 for o in RORB))
print(f"    {ninv} random SIGMA-INVARIANT integral-sloped PL h: {okinv}/{ninv} satisfy "
      f"(F2) at all {len(RORB)} orbits")
assert okinv == ninv
print("    (structural reason: lambda of a sigma-invariant pattern is h(w)*sum_i 5^i =")
print("     781 h(w) == 0 (mod 11).  So the test is very far from unsatisfiable.)")
print(f"    the same h with an arbitrary LINEAR term added: {okinv_lin}/{ninv} -- adding")
print("    lin_u (i.e. translating Q by u) shifts lambda_w by <w, sum_i 5^i shift_i(u)>,")
print("    so (F2) is not translation-invariant; and translation is not a free move,")
print("    because it changes F by lin_{(2+sig)u}, which breaks the twice-min structure.")

sub("(a2) pass rate of unstructured configurations (calibrates the difficulty)")
rr5 = random.Random(SEED + 12)
per_orbit = 0; tot_orbit = 0; allpass = 0; NRAND = 60
for _ in range(NRAND):
    co = [rr5.randint(-6, 6) for _ in range(20)]
    U = phi_slopes(co) + np.array([rr5.randint(-9, 9) for _ in range(4)], dtype=np.int64)[None, :]
    hr = ray_values(U)
    good = sum(1 for o in RORB if wsum(hr, W5, o[0]) % 11 == 0)
    per_orbit += good; tot_orbit += len(RORB); allpass += int(good == len(RORB))
print(f"    {NRAND} random (non-invariant) PL h: per-orbit pass rate "
      f"{per_orbit}/{tot_orbit} = {per_orbit/tot_orbit:.3f} (1/11 = {1/11:.3f}); all-92 "
      f"passes: {allpass}/{NRAND}")

sub("(a3) THE DECISIVE CONTROL: can a Theorem-Q witness of the SAME family satisfy (F2)?")
print("""    The witness family for a zero-pattern is  U_d = EXPR . (K_i t), t ranging over
    the integer solutions of the mod-11 congruence layer; positivity cuts a
    FULL-DIMENSIONAL cone K+ (f55_mixedpos.py; build_witness re-derives an interior
    point of it every time it runs), and a full-dimensional cone contains lattice
    points in every class of every finite-index sublattice.  So 'does some nonnegative
    integral Theorem-Q witness of this family also satisfy (F2)?' is a mod-11 LINEAR
    FEASIBILITY question on t, decided exactly -- with a Farkas certificate demanded
    for every infeasibility and a positive control that must come out FEASIBLE.""")


def rref11(A, b, want_cert=False):
    """solve A t == b over F_11.  Returns (feasible, particular solution) and, when
       infeasible and want_cert, a Farkas vector y with y.A == 0, y.b != 0 (mod 11),
       obtained by carrying the row operations on an identity block."""
    m = len(A); n = len(A[0]) if m else 0
    M = np.zeros((m, n + 1 + (m if want_cert else 0)), dtype=np.int64)
    M[:, :n] = np.array(A, dtype=np.int64) % 11
    M[:, n] = np.array(b, dtype=np.int64) % 11
    if want_cert: M[:, n + 1:] = np.eye(m, dtype=np.int64)
    piv = []; r0 = 0
    for c in range(n):
        pr = None
        for i in range(r0, m):
            if M[i, c] % 11: pr = i; break
        if pr is None: continue
        if pr != r0: M[[r0, pr]] = M[[pr, r0]]
        M[r0] = (M[r0] * INV11[int(M[r0, c]) % 11]) % 11
        col = M[:, c].copy(); col[r0] = 0
        M = (M - np.outer(col, M[r0])) % 11
        piv.append(c); r0 += 1
        if r0 == m: break
    for i in range(r0, m):
        if int(M[i, n]) % 11 and not M[i, :n].any():
            y = M[i, n + 1:].copy() if want_cert else None
            return False, None, y
    t0 = np.zeros(n, dtype=np.int64)
    for i, c in enumerate(piv): t0[c] = M[i, n]
    return True, t0, None


def rank11(A):
    A = np.array(A, dtype=np.int64) % 11
    m, n = A.shape; r0 = 0
    for c in range(n):
        pr = None
        for i in range(r0, m):
            if A[i, c] % 11: pr = i; break
        if pr is None: continue
        if pr != r0: A[[r0, pr]] = A[[pr, r0]]
        A[r0] = (A[r0] * INV11[int(A[r0, c]) % 11]) % 11
        col = A[:, c].copy(); col[r0] = 0
        A = (A - np.outer(col, A[r0])) % 11
        r0 += 1
        if r0 == m: break
    return r0


sub("    solver validation: 400 planted systems + brute force on small ones")
rq = np.random.default_rng(SEED + 31)
okf = okinf = okbrute = nplant = ninf = 0
for _ in range(400):
    m_, n_ = int(rq.integers(2, 9)), int(rq.integers(1, 6))
    A_ = rq.integers(0, 11, size=(m_, n_)).astype(np.int64)
    if rq.random() < 0.5:                       # planted feasible
        ts = rq.integers(0, 11, size=n_).astype(np.int64)
        b_ = (A_ @ ts) % 11; nplant += 1
        f, t0, _ = rref11(A_.tolist(), b_.tolist())
        okf += int(f and not ((A_ @ t0 - b_) % 11).any())
    else:
        b_ = rq.integers(0, 11, size=m_).astype(np.int64)
        f, t0, y = rref11(A_.tolist(), b_.tolist(), want_cert=True)
        # brute force over F_11^n for small n
        hits = any(not (((A_ @ np.array(np.unravel_index(k, (11,) * n_))) - b_) % 11).any()
                   for k in range(11 ** n_)) if n_ <= 4 else None
        if hits is not None: okbrute += int(hits == f)
        if not f:
            ninf += 1
            okinf += int(not ((y @ A_) % 11).any() and int(y @ b_) % 11 != 0)
        else:
            okf += int(not ((A_ @ t0 - b_) % 11).any())
print(f"      planted-feasible solved correctly: {okf}; infeasible cases with a VERIFIED "
      f"Farkas vector (y.A == 0, y.b != 0): {okinf}/{ninf}; brute-force agreement on "
      f"small systems: {okbrute}")
assert okinf == ninf and okbrute > 0

KEY = ("mixed",)
E1o = set(i for i, o in enumerate(RORB) if o[0] in E1set)
E3o = set(i for i, o in enumerate(RORB) if o[0] in E3set)
SUBSETS = [("all 92", list(range(len(RORB)))),
           ("off E1 (78)", [i for i in range(len(RORB)) if i not in E1o]),
           ("E3 \\ E1 (72)", [i for i in range(len(RORB)) if i in E3o and i not in E1o])]
feas_rows = []
for W in WIT:
    P, H, CM, RHS, Ki, x1, cinfo = integer_solution_lattice(KEY, NC, WALLS, SIG, ORB,
                                                            sorted(W["Z"]))
    EXPR = _FANCACHE[KEY][0]
    dd = Ki.shape[1]
    Gm = imatmul(EXPR.reshape(-1, P), Ki).reshape(NC, 4, dd)
    DL = np.zeros((NR, dd), dtype=np.int64)          # d(ray i) as a functional of t
    for i in range(NR):
        vals = set(tuple(int(z) for z in (R4[i].astype(np.int64) @ Gm[c])) for c in RCELL[i])
        assert len(vals) == 1
        DL[i] = np.array(vals.pop(), dtype=np.int64)
    LAMROW = np.zeros((len(RORB), dd), dtype=np.int64)
    LAMRHS = np.zeros(len(RORB), dtype=np.int64)
    L9ROW = np.zeros((len(RORB), dd), dtype=np.int64)
    L9RHS = np.zeros(len(RORB), dtype=np.int64)
    for oi, o in enumerate(RORB):
        LAMROW[oi] = sum(W5[k] * DL[sig_ray(o[0], k)] for k in range(5)) % 11
        LAMRHS[oi] = (-int(R5[o[0]] @ Cv)) % 11
        L9ROW[oi] = sum(W9[k] * DL[sig_ray(o[0], k)] for k in range(5)) % 11
        L9RHS[oi] = (-int(R5[o[0]] @ C9v)) % 11
    CKm = imatmul(CM % 11, Ki % 11) % 11
    W.update(dd=dd, Ki=Ki, EXPR=EXPR, P=P, DL=DL, CM=CM, RHS=RHS, CKm=CKm,
             LAMROW=LAMROW, LAMRHS=LAMRHS, L9ROW=L9ROW, L9RHS=L9RHS)
    ok_base, _, _ = rref11(CKm.tolist(), (RHS % 11).tolist())
    res = []
    for (nm, idx) in SUBSETS:
        A = np.concatenate([CKm, LAMROW[idx]], axis=0)
        bb = np.concatenate([RHS % 11, LAMRHS[idx]])
        f, t0, y = rref11(A.tolist(), bb.tolist(), want_cert=True)
        cert = None
        if not f:
            assert not ((y @ A) % 11).any() and int(y @ bb) % 11 != 0, "bad certificate"
            sup = [k for k in range(len(y)) if int(y[k]) % 11]
            # a one-row certificate exists exactly when some (F2) row is identically
            # zero on the family while its right-hand side is not
            units = [k for k in range(A.shape[0]) if not A[k].any() and int(bb[k]) % 11]
            cert = (len(sup), all(k >= CKm.shape[0] for k in sup), len(units),
                    all(k >= CKm.shape[0] for k in units))
        res.append((f, cert))
    # POSITIVE CONTROL: the same rows with the 9-weights (= congruence (3) at the rays),
    # which the recorded witness satisfies -- the solver must call this FEASIBLE.
    A9 = np.concatenate([CKm, L9ROW], axis=0)
    b9 = np.concatenate([RHS % 11, L9RHS])
    f9, _, _ = rref11(A9.tolist(), b9.tolist())
    feas_rows.append((W["tag"], dd, ok_base, [r[0] for r in res], [r[1] for r in res], f9))
    W["feas"] = res
print(f"\n    {'pattern':28s} {'dimker':>6s} {'base':>5s} {'+F2 all':>8s} {'+F2 offE1':>10s} "
      f"{'+F2 E3\\E1':>10s} {'9-wt ctrl':>10s}")
for (t, dd, a, fs, cs, f9) in feas_rows:
    print(f"    {t:28s} {dd:6d} {str(a):>5s} {str(fs[0]):>8s} {str(fs[1]):>10s} "
          f"{str(fs[2]):>10s} {str(f9):>10s}")
nfeas = sum(1 for r in feas_rows if r[3][1])
n9 = sum(1 for r in feas_rows if r[5])
print(f"\n    (F1)+(F2) mod-11 feasible: {nfeas}/{len(feas_rows)} families "
      f"(all 92: {sum(1 for r in feas_rows if r[3][0])}, E3\\E1: "
      f"{sum(1 for r in feas_rows if r[3][2])}).")
print(f"    POSITIVE CONTROL, identical code path with the 9-weights: "
      f"{n9}/{len(feas_rows)} FEASIBLE -- so the infeasibility above is not the solver.")
assert n9 == len(feas_rows)
certs = [r[4][1] for r in feas_rows if r[4][1] is not None]
print(f"    every infeasibility carries a Farkas certificate y (y.A == 0, y.b != 0,")
print(f"    verified by multiplication).  Elimination certificates have support "
      f"{sorted(set(c[0] for c in certs))}; in addition {min(c[2] for c in certs)}-"
      f"{max(c[2] for c in certs)} ONE-ROW certificates exist per family, all of them on")
print(f"    (F2) rows: {all(c[3] for c in certs)}  (a single (F2) row that is identically")
print("    zero on the whole family with a nonzero right-hand side -- see (a3b)).")

sub("    how the two weight systems sit relative to the base congruence system")
print(f"    {'pattern':28s} {'rk(base)':>9s} {'rk(base+9wt)':>13s} {'rk(base+5wt)':>13s} "
      f"{'rk(lambda map)':>15s} {'single-row bad':>15s}")
for W, r in zip(WIT, feas_rows):
    rb = rank11(W["CKm"])
    r9 = rank11(np.concatenate([W["CKm"], W["L9ROW"]], axis=0))
    r5 = rank11(np.concatenate([W["CKm"], W["LAMROW"]], axis=0))
    rl = rank11(W["LAMROW"])
    nsingle = sum(1 for oi in range(len(RORB))
                  if not rref11(np.concatenate([W["CKm"], W["LAMROW"][[oi]]]).tolist(),
                                np.concatenate([W["RHS"] % 11, W["LAMRHS"][[oi]]]).tolist())[0])
    W["nsingle"] = nsingle
    print(f"    {W['tag']:28s} {rb:9d} {r9:13d} {r5:13d} {rl:15d} {nsingle:15d}")
print("    rk(base + 9-weighted ray rows) == rk(base) for every family: the 9-weighted")
print("    ray-orbit rows are IMPLIED by the parent's independently built cell-level")
print("    congruence encoding -- an end-to-end check of the ray/orbit/transport")
print("    bookkeeping against machinery this probe did not write.  The 5-weighted rows")
print("    are not in that span, and are inconsistent with it.")

sub("(a3b) THE MECHANISM: ray-orbits that lie entirely in the zero locus")
print("""    A ray whose whole sigma-orbit lies in closures of ZERO cells has d = 0 at all
    five conjugates for EVERY member of the family (the zero cells are part of the
    family's defining equations).  There lambda_O(d) = 0 identically, so
        congruence (3) forces  <w, c9> == 0   (satisfied -- it is already imposed),
        (F2)            forces  <w, c>  == 0   (not imposed anywhere).
    Every ray with <w,c> != 0 in that locus is a one-row Farkas certificate.""")
print(f"\n    {'pattern':28s} {'orbits with d==0 on the orbit':>30s} {'of which <w,c> != 0':>21s}")
for W in WIT:
    zrows = [oi for oi in range(len(RORB))
             if not W["DL"][[sig_ray(RORB[oi][0], k) for k in range(5)]].any()]
    bad = [oi for oi in zrows if int(R5[RORB[oi][0]] @ Cv) % 11]
    bad9 = [oi for oi in zrows if int(R5[RORB[oi][0]] @ C9v) % 11]
    assert not bad9, "congruence (3) would already be infeasible -- machinery error"
    W["zrows"] = zrows; W["badrows"] = bad
    for oi in zrows:                       # the recorded witness must vanish there too
        assert all(int(W["dr"][sig_ray(RORB[oi][0], k)]) == 0 for k in range(5))
    print(f"    {W['tag']:28s} {len(zrows):30d} {len(bad):21d}")
print(f"\n    (the <w,c9> != 0 count is 0 for every family, as it must be, since these")
print("     witnesses satisfy congruence (3): the same structure, opposite verdict.)")

sub("(a3c) the wider mechanism: orbits where the lambda-ROW itself vanishes")
print("    A weaker and much more common degeneracy: the functional t -> lambda_O(d) can")
print("    vanish identically on the family without d vanishing on the orbit.  There the")
print("    condition degenerates to a statement about the covector alone:")
print("        5-weights:  0 == -<w, c>    |    9-weights:  0 == -<w, c9>.")
print(f"\n    {'pattern':28s} {'#orbits lam5-row == 0':>22s} {'of which <w,c> != 0':>20s} "
      f"{'#lam9-row == 0':>15s} {'of which <w,c9> != 0':>21s}")
for W in WIT:
    z5 = [oi for oi in range(len(RORB)) if not (W["LAMROW"][oi] % 11).any()]
    z9 = [oi for oi in range(len(RORB)) if not (W["L9ROW"][oi] % 11).any()]
    b5 = [oi for oi in z5 if int(R5[RORB[oi][0]] @ Cv) % 11]
    b9 = [oi for oi in z9 if int(R5[RORB[oi][0]] @ C9v) % 11]
    assert not b9
    W["z5"] = z5; W["b5"] = b5
    print(f"    {W['tag']:28s} {len(z5):22d} {len(b5):20d} {len(z9):15d} {len(b9):21d}")
sub("(a3d) what the degeneracy IS, and one certificate written out by hand")
neq = 0
for W in WIT:
    z5 = set(W["z5"])
    z9 = set(oi for oi in range(len(RORB)) if not (W["L9ROW"][oi] % 11).any())
    r11 = [i for i in range(NR) if not (W["DL"][i] % 11).any()]
    o11 = set(oi for oi in range(len(RORB))
              if all(not (W["DL"][sig_ray(RORB[oi][0], k)] % 11).any() for k in range(5)))
    assert all(int(W["dr"][i]) % 11 == 0 for i in r11)
    neq += int(z5 == z9 == o11)
    W["r11"] = r11
print(f"    at {len(WIT[0]['r11'])} of the {NR} rays the value d(w) is divisible by 11 for")
print(f"    EVERY member of the family (forced by the zero cells + the wall-jump lattice,")
print(f"    whose normals are the mod-11 G9-differences); {len(WIT[0]['z5'])} of the "
      f"{len(RORB)} ray-ORBITS have this at all five conjugates.")
print(f"    on exactly those orbits BOTH lambda-rows vanish identically, for all "
      f"{len(WIT)} families: {neq == len(WIT)}")
assert neq == len(WIT)
print("    => there each law collapses to a statement about its covector alone:")
print("         congruence (3):  <w, c9> == 0     (holds -- the witnesses exist)")
print("         (F2)          :  <w, c>  == 0     (fails at 44 of them)")
W0c = WIT[0]
oi0 = W0c["b5"][0]
w0 = R5[RORB[oi0][0]]
print(f"\n    HAND-CHECKABLE CERTIFICATE [{W0c['tag']}], ray-orbit index {oi0}:")
print(f"      ray w = {tuple(int(z) for z in w0)}   (primitive, sum 0, orbit size 5)")
print(f"      d at the five conjugate rays, recorded witness: "
      f"{[int(W0c['dr'][sig_ray(RORB[oi0][0], k)]) for k in range(5)]}")
print(f"      all divisible by 11: "
      f"{all(int(W0c['dr'][sig_ray(RORB[oi0][0], k)]) % 11 == 0 for k in range(5))}; and "
      f"divisible by 11 for every member of the family (rows == 0 mod 11): True")
print(f"      so lambda_O(d) == 0 and L9_O(d) == 0 identically on the family")
print(f"      <w, c9> mod 11 = {int(w0 @ C9v) % 11}   -> congruence (3) reads 0 == 0: OK")
print(f"      <w, c>  mod 11 = {int(w0 @ Cv) % 11}   -> (F2) reads 0 == "
      f"{(-int(w0 @ Cv)) % 11} (mod 11): IMPOSSIBLE")
# direct confirmation, bypassing the linear-functional derivation entirely: sample
# random members of the family and evaluate d at the five rays of the certificate orbit
rqs = np.random.default_rng(SEED + 77)
o5 = [sig_ray(RORB[oi0][0], k) for k in range(5)]
bad_div = bad_lam = 0
for _ in range(25):
    t = rqs.integers(-40, 41, size=W0c["dd"]).astype(np.int64)
    y = imatmul(W0c["Ki"], t[:, None])[:, 0]
    U = (W0c["EXPR"].reshape(-1, W0c["P"]).astype(object) @ y.astype(object)).reshape(NC, 4)
    U = np.array([[int(v) for v in row] for row in U], dtype=np.int64)
    dv = [int(U[RCELL[i][0]] @ R4[i]) for i in o5]
    bad_div += int(any(v % 11 for v in dv))
    bad_lam += int((sum(W5[k] * dv[k] for k in range(5)) + int(w0 @ Cv)) % 11 == 0)
print(f"      DIRECT CONFIRMATION on 25 random members of the family (slope fields built")
print(f"      from scratch, d evaluated at the five rays): members whose d is NOT")
print(f"      divisible by 11 there: {bad_div}/25; members satisfying (F2) at this "
      f"orbit: {bad_lam}/25")
assert bad_div == 0 and bad_lam == 0

print("\n    THIS IS THE KILL IN ONE LINE: on every one of the 14 families the boundary")
print("    lambda-functional degenerates at a large set of ray-orbits, and on that set the")
print("    9-weighted covector c9 is orthogonal to the ray (so congruence (3) is")
print("    consistent) while the 5-weighted covector c is not (so (F2) is not).  It is a")
print("    compatibility statement between the zero-pattern and c vs c9 -- not a")
print("    numerical accident, and not repairable inside the family.")

sub("(a4) an EXPLICIT nonnegative integral witness satisfying (F1) AND (F2)")


def build_witness_F2(W, idx):
    """build_witness's recipe with the (F2) rows at the orbits idx adjoined."""
    dd, Ki, EXPR, P = W["dd"], W["Ki"], W["EXPR"], W["P"]
    A = np.concatenate([W["CKm"], W["LAMROW"][idx]], axis=0)
    bvec = np.concatenate([W["RHS"] % 11, W["LAMRHS"][idx]])
    ok, t0, _ = rref11(A.tolist(), bvec.tolist())
    if not ok: return None
    ded = {}
    for i in range(NR):
        v = tuple(int(z) for z in W["DL"][i])
        if any(v):
            g = 0
            for z in v: g = gcd(g, abs(z))
            ded[tuple(z // g for z in v)] = 1
    AA = sorted(ded.keys())
    st, wv = farkas_or_interior([list(r) for r in AA])
    if st != 'INTERIOR': return None
    L0 = 1
    for z in wv: L0 = L0 * z.denominator // gcd(L0, z.denominator)
    ui = np.array([int(z * L0) for z in wv], dtype=np.int64)
    dU = [sum(int(AA[i][j]) * int(ui[j]) for j in range(dd)) for i in range(len(AA))]
    assert min(dU) > 0
    dX = [sum(int(AA[i][j]) * int(t0[j]) for j in range(dd)) for i in range(len(AA))]
    Nn = 1
    while Nn <= 10 ** 9:
        if min(dX[i] + 11 * Nn * dU[i] for i in range(len(AA))) >= 0: break
        Nn *= 2
    y = imatmul(Ki, (t0 + 11 * Nn * ui)[:, None])[:, 0]
    U4 = (EXPR.reshape(-1, P).astype(object) @ y.astype(object)).reshape(NC, 4)
    return np.array([[int(v) for v in row] for row in U4], dtype=np.int64)


nnew = 0
for W in WIT[:4]:
    made = False
    for (nm, idx) in SUBSETS:
        Ud2 = build_witness_F2(W, idx)
        if Ud2 is None:
            print(f"    [{W['tag']}] ({nm}): no (F2)-feasible member of the family")
            continue
        made = True
        with contextlib.redirect_stdout(_buf):
            certify_d(Ud2, W["Z"], W["tag"] + "/F2", npts=1500)
            Uh2, Um2 = solve_preimage(Ud2, W["tag"] + "/F2")
            assert Uh2 is not None
            verify_preimage(Uh2, Um2, Ud2, W["tag"] + "/F2")
            Tk2, Ucav2 = convexify(Uh2, W["tag"] + "/F2", -1)
            bt2, nb2 = ns["theoremQ_check"](Uh2, W["tag"] + "/F2", npts=2500)
        hr2 = ray_values(Ucav2)
        V2 = np.array(sorted(set(map(tuple, Ucav2.tolist()))), dtype=np.int64)
        lam2 = [wsum(hr2, W5, o[0]) % 11 for o in RORB]
        lamQ2 = [wsum((V2 @ R4.T).min(0), W5, o[0]) % 11 for o in RORB]
        b2, b3 = f3_check(hr2, XV)
        nnew += int(all(lam2[i] == 0 for i in idx) and bt2 == 0)
        print(f"    [{W['tag']}] ({nm}) NEW witness: max|U_d| = {int(np.abs(Ud2).max())}, "
              f"Theorem Q failures {bt2}/{nb2}, (F2) at "
              f"{sum(1 for i in idx if lam2[i] == 0)}/{len(idx)} required orbits, "
              f"fan-free agreement {lam2 == lamQ2}, (F3) failures {b2+b3}")
print(f"\n    ==> {nnew} explicit witnesses satisfy (F1) AND (F2) AND (F3) simultaneously.")
if nnew == 0:
    print("    The construction is the SAME one that produced the 14 recorded witnesses;")
    print("    only the mod-11 row set changed.  It returns nothing because the linear")
    print("    system is infeasible, with the verified certificates above -- not because")
    print("    the construction failed.")

sub("(b) the test CAN fail: perturb a witness")
W0 = WIT[0]
Ki = W0["Ki"]; EXPR = W0["EXPR"]; P = W0["P"]
nbrk9 = nbrk5 = 0
for j in range(min(6, W0["dd"])):
    y = imatmul(Ki, np.eye(W0["dd"], dtype=np.int64)[:, j][:, None])[:, 0]
    dU = (EXPR.reshape(-1, P).astype(object) @ y.astype(object)).reshape(NC, 4)
    dU = np.array([[int(v) for v in row] for row in dU], dtype=np.int64)
    Ud2 = W0["Ud"] + dU                       # still satisfies walls + zero cells
    dr2 = ray_values(Ud2)
    g9 = sum(1 for o in RORB if (wsum(dr2, W9, o[0]) + int(R5[o[0]] @ C9v)) % 11 == 0)
    g5 = sum(1 for o in RORB if (wsum(dr2, W5, o[0]) + int(R5[o[0]] @ Cv)) % 11 == 0)
    lam2 = [(8 * ((wsum(dr2, W5, o[0]) + int(R5[o[0]] @ Cv)) % 11)) % 11 for o in RORB]
    moved = sum(1 for oi in range(len(RORB)) if lam2[oi] != W0["lam"][oi])
    nbrk9 += int(g9 < len(RORB)); nbrk5 += int(moved > 0)
    print(f"    + kernel direction {j}: congruence (3) holds at {g9:3d}/92 orbits, "
          f"(F2) at {g5:3d}/92, lambda changed at {moved:3d}/92 orbits")
print(f"    perturbations that break the 9-weighted law: {nbrk9}/6; that move the "
      f"lambda-pattern: {nbrk5}/6")
assert nbrk9 > 0, "the calibration gate is trivially true -- it proves nothing"
print("    ==> the gate is NOT vacuously true: legal PL perturbations do break it.")

sub("(c) sigma-equivariance and base-point independence of lambda")
bad_rot = 0; nonconst = 0
for W in WIT:
    for oi, o in enumerate(RORB):
        v = [wsum(W["hr"], W5, sig_ray(o[0], k)) % 11 for k in range(5)]
        if any((v[(k + 1) % 5] - 9 * v[k]) % 11 for k in range(5)): bad_rot += 1
        if len(set(v)) > 1: nonconst += 1
print(f"    lambda_{{sig w}} == 9 * lambda_w = 5^{{-1}} lambda_w (mod 11) at all "
      f"{len(WIT)}x{len(RORB)} orbits: {len(WIT)*len(RORB)-bad_rot} clean")
assert bad_rot == 0
print(f"    the VALUE really does move with the base point ({nonconst} of "
      f"{len(WIT)*len(RORB)} orbits have a non-constant 5-tuple), so no numerical")
print("    per-orbit pairing exists (Correction IX-d stands); but 9 is a unit, so the")
print("    VANISHING lambda_O == 0 is a well-defined property of the ORBIT -- which is")
print("    all (F2) asserts.  No anchoring by the b-cocycle is needed for this test.")
inv_ok = 0
for W in WIT:
    for T in (1, 7, 128):
        hr = ray_values(W["Uh"] + T * PHI_S)
        inv_ok += int([wsum(hr, W5, o[0]) % 11 for o in RORB] == W["lam"])
print(f"    invariance under h -> h + T*Phi (the sigma-invariant freedom of the lift, "
      f"and the min<->max convention): {inv_ok}/{3*len(WIT)} unchanged")
assert inv_ok == 3 * len(WIT)

# ============================================================ 9. verdict
hdr("9. VERDICT")
print(f"""  (F2) KILLS ALL 14 WITNESSES AT THE BOUNDARY -- AND THEIR ENTIRE FAMILIES.
  * Pointwise: each witness satisfies lambda_O(div a) == 0 (mod 11) at only
    {min(W['pass'] for W in WIT)}-{max(W['pass'] for W in WIT)} of the 92 boundary ray-orbits,
    and every passing orbit is one of the {len(E1)} b-split-exempt (E1) ones, so the
    exemption absorbs nothing: {sum(W['fail'] for W in WIT)} failures across
    {92*len(WIT)} witness-orbit pairs, {sum(W['failE3'] for W in WIT)} of them at orbits
    where the condition is well posed (<w,e_b> == 0 mod 11).
  * Family-wide: (F2) is a mod-11 linear condition on the SAME solution lattice that
    produced the witnesses, and it is INFEASIBLE for {len(feas_rows)-nfeas} of
    {len(feas_rows)} families -- under all three readings of the exemption (all 92
    orbits, off-E1, E3\\E1).  Each infeasibility carries a Farkas certificate verified by
    multiplication, including {min(c[2] for c in certs)}+ ONE-ROW certificates per family.
  * Mechanism (not a numerical accident): at {len(WIT[0]['z5'])} of the 92 orbits the
    functional t -> lambda_O(d) vanishes identically on the family, so (F2) degenerates
    to <w, c> == 0 -- and c is NOT orthogonal to {len(WIT[0]['b5'])} of those rays.  The
    identical computation with the 9-weights (congruence (3)) degenerates on the same
    kind of set, but there c9 IS orthogonal, which is exactly why the witnesses exist.
    The kill is a compatibility statement between the mixed fan's zero-patterns and the
    covector c.
  * Positive controls all pass: the 9-weighted law is clean 92/92 on 14/14 witnesses;
    the same feasibility code with 9-weights returns FEASIBLE 14/14; sigma-invariant h
    satisfies (F2) at 92/92 orbits (40/40 trials); random h passes at the 1/11 rate.
    So the test is neither vacuous nor uniformly unsatisfiable.

  (F3) KILLS NOTHING -- IT IS AN IDENTITY.  With e_b = (2 + sig^{{-1}}) x,
  x = {tuple(int(z) for z in XV)}, the transpose computation of cores(a,b) agrees with
  the first one term by term for EVERY integer order pattern: 0 failures over
  {len(WIT)}x{len(RORB)} witness-orbits for both the monomial and the scalar identity,
  and 6/6 perturbations of x break them.

  WHAT THIS DOES AND DOES NOT RESTORE -- READ BEFORE QUOTING.
   * This is a kill at the BOUNDARY LAYER ONLY, of the 14 recorded families on the
     MIXED FAN, and ONLY MODULO the correctness of (F2) as a condition.  It is NOT a
     proof of Lemma S, NOT F55-NO, NOT ed = 4.  The interior part of div(a) is not
     determined by Q at all, and other zero-patterns / other sigma-stable fans were not
     enumerated here.
   * The load-bearing caveat is finding F-2 below: in the pinned convention Theorem N
     is EQUIVALENT to (F2) rather than independent of it, so the source's derivation of
     (F2) AT THE BOUNDARY is circular, and its interior derivation (Theorem K) uses the
     same step.  What this probe establishes is therefore conditional and sharp:
        IF (F2) is a genuine condition, THEN the 14 witnesses and their families are
        dead at the boundary, and S8.28's 'Theorem Q = YES' does not by itself defeat
        the programme;
        IF (F2) cannot be repaired, the Brauer layer contributes nothing and the
        witnesses stand as recorded.
     Deciding which is a derivation task, not a computation: it needs an independent
     reason for the residue of A_K = cores(phi,b) to vanish at split orbits.""")

hdr("FINDINGS ABOUT THE SOURCE (ambiguities, reported not guessed)")
print("""  F-1.  THE INDEX FLIP.  S8.9 works in the COMPONENT index (mu_i = 2 s_i + s_{i+1}),
        where the transpose kernel of the psi-operator is 5^i (Correction IX-c is right
        there).  S8.14-S8.16 and all the verified code work in the RAY index
        (2 g_i + g_{i-1}), where the transpose kernel is 9^i (Theorem R, S8.17) and 5^i
        is the b-cover functional.  The two are different functionals in one index:
        lambda . psi = 7 lambda, L9 . psi = 0.  Every statement of the form 'pattern in
        Im(2+sigt) forces lambda == 0' -- Theorem I(ii)'s per-orbit reading, Theorem K,
        the 'second-order congruence' of S8.13 (index 33 -> 363) and Theorem N -- uses
        the transpose-kernel property for lambda, which holds only in the other index.

  F-2.  CONSEQUENCE FOR (F2).  In the pinned convention lambda_w(phi) = 7 lambda_w(div a)
        - <w,c> identically.  Therefore Theorem N is not an independent fact: it IS
        (F2) at the boundary.  Substituting the true lambda_w(phi) into Theorem O's
        per-ray equation makes it 0 = 0 -- the leftover [l_w(b)]^{7 lambda_w(a)} of
        S8.15 appears only because Theorem N was imposed as an extra input.  So the
        Brauer/corestriction layer produces NO boundary condition of its own; and the
        interior (iv) rests on the same step (the residue of A_K at a split interior
        orbit is [b|_P]^{-lambda_O(phi)} = [b|_P]^{-7 lambda_O(div a)}, matching the
        right-hand side identically -- Theorem K's 'Theorem-I(ii) forces lambda_O == 0'
        is the same slip).  This is a derivation finding, not a numerical one, and it
        is why the (F2) table above is reported at FACE VALUE and separately as a
        family-feasibility question.

  F-3.  THE ALIGNMENT IS TRANSPOSED.  S8.10 states e_b in Im(2+sig), i.e.
        b = const*psi(r^x).  In the pinned convention L9(e_b) = 7 != 0 and no such x
        exists; what is true is lambda(e_b) = 0 and e_b = (2+sig^{-1})x with
        x = (0,2,-3,2,0).  Theorem P survives with psi and psi* interchanged
        (cores(a,b) = cores(psi(a), r^x)), which is what was tested.

  F-4.  WELL-POSEDNESS AT THE BOUNDARY.  The factor [l_w(b)]^{...} of Theorem O is
        uniformizer-dependent unless <w, e_b> == 0 (mod 11); on the complement the
        residue genuinely involves the leading forms of a, which div(a) does not
        determine.  The strict b-split criterion ('b|_{D_w} is an 11th power') is EMPTY
        at the boundary, so the exemption in (iv') as written never fires there; the
        brief's Theorem-L criterion exempts %d of 92 orbits.""" % len(E1))

print(f"\nreproduce:  python3 {os.path.basename(__file__)}   (deterministic, seed {SEED})")
print(f"total runtime {time.time()-T00:.1f}s")
