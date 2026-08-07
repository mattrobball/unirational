#!/usr/bin/env python3
# f55_f2repair_adjudicate.py -- INDEPENDENT ADJUDICATION OF F-1/F-2 AND THE (F2) REPAIR
#
# This probe does NOT reuse f55_f2f3.py's derivations.  Every functional, operator and
# constant is rebuilt from the SOURCE TEXT of Note IX (S8.9-S8.17) and checked against
# the source's own recorded constants.  Sections:
#
#   A. Pin sigma from the source text TWO ways that do not use any code convention:
#        (A1) S8.9's own term formula  T_i = r_{2+i}^{-1} a_i^2 a_{i+1}   [=> sig(r_j)=r_{j+1}]
#        (A2) S8.11/S8.12's sealed relation  sig(b) = r_2^{-11} b^{-2}
#      and confirm the source's recorded constants c = (3,5,1,9,4) [S8.14] and
#      c9 = (4,9,1,5,3) [S8.17] come out right in that pin and wrong in the other.
#   B. F-1: compute lambda.psi and L9.psi in BOTH indices; show the flip is a change of
#      LABEL on a pair of genuinely different functionals, not a change of truth value.
#   C. F-2: Theorem N vs (F2); Theorem O's residue identity for MONOMIAL a, computed
#      from the tame symbol on both sides -- does it collapse to 0 = 0?
#   D. THE REPAIR: exhaust the eigen-decomposition of E*/(E*)^11 as an F_11[C_5]-module.
#      For every sigma-eigenclass beta (eigenvalue eps) compute the factor 2 + eps^{-1}
#      that governs cores(psi(a), beta) = (2 + eps^{-1}) cores(a, beta), and report which
#      choices of beta make cores(phi,beta) independent of a (the only ones that can carry
#      an unconditional unramifiedness statement) and what condition they then yield.
#   E. Theorem R re-derived from scratch, and its 5-weighted twin (which is (F2)).
#   F. WITNESS RE-TEST against the recorded 14 mixed-fan witnesses (loads f55_qpreimage.py
#      exactly as f55_f2f3.py does): checks the identity lambda_w(phi) = 7 lambda_w(div a)
#      - <w,c> at all 460 rays, and evaluates the REPAIRED condition on the witnesses.
#      Skipped with --fast.
#
# Reproduce:  python3 f55_f2repair_adjudicate.py [--fast]
import sys, os, io, time, random, contextlib
import numpy as np

T0 = time.time()
FAST = "--fast" in sys.argv
SEED = 20260808


def hdr(s): print("\n" + "=" * 78 + "\n== " + s + "\n" + "=" * 78)
def sub(s): print("\n--- " + s)


DIAG = np.ones(5, dtype=np.int64)
EB = np.array([2, 1, -4, 4, 0], dtype=np.int64)        # b = r0^2 r1 r2^-4 r3^4   (S8.10)
E2 = np.array([0, 0, 1, 0, 0], dtype=np.int64)         # r_2
W5 = [pow(5, i, 11) for i in range(5)]
W9 = [pow(9, i, 11) for i in range(5)]
FAIL = []


def chk(name, cond, want=True):
    """want=False marks a check that is SUPPOSED to come out false (a negative control)."""
    good = (bool(cond) == want)
    tag = ("ok " if want else "neg") if good else "FAIL"
    print(f"    [{tag}] {name}" + ("" if want else f"   -> {cond}, as it must be"))
    if not good: FAIL.append(name)
    return cond


def shift(v, k):
    """(shift_k v)_i = v_{(i+k) mod 5}."""
    v = np.asarray(v, dtype=np.int64)
    return np.array([v[(i + k) % 5] for i in range(5)], dtype=np.int64)


def is_diag(v):
    return len(set(int(x) for x in np.asarray(v))) == 1


def eqL(u, v):                                          # equality in Lambda = Z^5/Z.diag
    return is_diag(np.asarray(u) - np.asarray(v))


def eqL11(u, v):                                        # equality in Lambda/11
    d = (np.asarray(u) - np.asarray(v)) % 11
    return is_diag(d)


# =============================================================== A. pin sigma
hdr("A. PINNING sigma FROM THE SOURCE TEXT (no code conventions used)")
print("""  sigma_M is the action on monomial exponents: sigma(r^m) = r^{sigma_M m}.
  If sigma(r_j) = r_{j+delta} then sigma_M = shift_{-delta}.  Two independent pins:""")

sub("(A1) S8.9's term formula  T_i = r_{2+i}^{-1} a_i^2 a_{i+1}")
print("""    S8.9 expands Phi(a) = Tr(r_2^{-1} a^2 sigma(a)) over the split algebra with the
    i-th component of x being sigma^i(x).  The i-th term is then
        sigma^i(r_2)^{-1} . sigma^i(a)^2 . sigma^{i+1}(a),
    which the source writes as r_{2+i}^{-1} a_i^2 a_{i+1}.  So sigma^i(r_2) = r_{2+i},
    i.e. sigma(r_j) = r_{j+1}, i.e. sigma_M = shift_{-1}.  Test both candidates:""")
for k, nm in ((-1, "shift_{-1}"), (+1, "shift_{+1}")):
    sig_r2 = shift(E2, k)                                # exponent of sigma(r_2)
    ok = eqL(sig_r2, np.array([0, 0, 0, 1, 0]))          # r_3 = r_{2+1}
    chk(f"sigma_M = {nm:11s}: sigma(r_2) = r_3 (= r_{{2+1}}, as S8.9 requires)", ok,
        want=(k == -1))

sub("(A2) S8.11/S8.12's sealed relation  sigma(b) = r_2^{-11} b^{-2}")
tgt = -11 * E2 - 2 * EB
for k, nm in ((-1, "shift_{-1}"), (+1, "shift_{+1}")):
    chk(f"sigma_M = {nm:11s}: sigma_M(e_b) == -11 e_2 - 2 e_b in Lambda",
        eqL(shift(EB, k), tgt), want=(k == -1))
print("    => BOTH pins agree: sigma_M = shift_{-1}.  Used from here on.")
SIGM = lambda m: shift(m, -1)
SIGMI = lambda m: shift(m, +1)
chk("the two pins are not vacuous (shift_{+1} fails both)",
    not eqL(shift(E2, +1), np.array([0, 0, 0, 1, 0])) and not eqL(shift(EB, +1), tgt))

sub("(A3) the source's own recorded constants reproduce ONLY in this pin")
# c  := sum_i 5^i sigma_M^{-i} e_2   (S8.14 says c = (3,5,1,9,4))
# c9 := sum_i 9^i sigma_M^{-i} e_2   (S8.17 says c9 = (4,9,1,5,3))
for nm, F in (("sigma_M = shift_{-1} (pinned)", SIGMI), ("sigma_M = shift_{+1} (other)", SIGM)):
    cc = np.zeros(5, dtype=np.int64); c9 = np.zeros(5, dtype=np.int64)
    v = E2.copy()
    for i in range(5):
        cc = cc + W5[i] * v; c9 = c9 + W9[i] * v; v = F(v)
    print(f"    {nm}:  c = {tuple(int(z) for z in cc % 11)}   c9 = {tuple(int(z) for z in c9 % 11)}")
    if "pinned" in nm:
        CV, C9V = cc % 11, c9 % 11
chk("c  == (3,5,1,9,4)  [S8.14]", tuple(int(z) for z in CV) == (3, 5, 1, 9, 4))
chk("c9 == (4,9,1,5,3)  [S8.17]", tuple(int(z) for z in C9V) == (4, 9, 1, 5, 3))

sub("(A4) eigenstructure of sigma_M on Lambda tensor F_11")
# shift has 5 distinct eigenvalues on F_11^5 (the 5th roots of 1 mod 11 = {1,3,9,5,4});
# diag is the eigenvalue-1 one and dies in Lambda.
roots = sorted({pow(3, i, 11) for i in range(5)})
print(f"    5th roots of unity mod 11: {roots}")
EIG = {}
for eps in roots:
    # solve (sigma_M - eps) v = 0 mod 11 in Lambda: search the 4-dim space directly
    M = np.zeros((5, 5), dtype=np.int64)
    for j in range(5):
        e = np.zeros(5, dtype=np.int64); e[j] = 1
        M[:, j] = (SIGM(e) - eps * e) % 11
    # kernel mod 11 by brute rref
    A = M.copy() % 11
    piv = []; r0 = 0
    inv = {a: pow(a, 9, 11) for a in range(1, 11)}
    for c in range(5):
        pr = next((i for i in range(r0, 5) if A[i, c] % 11), None)
        if pr is None: continue
        A[[r0, pr]] = A[[pr, r0]]
        A[r0] = (A[r0] * inv[int(A[r0, c])]) % 11
        col = A[:, c].copy(); col[r0] = 0
        A = (A - np.outer(col, A[r0])) % 11
        piv.append(c); r0 += 1
    free = [c for c in range(5) if c not in piv]
    ker = []
    for f in free:
        v = np.zeros(5, dtype=np.int64); v[f] = 1
        for i, c in enumerate(piv): v[c] = (-A[i, f]) % 11
        ker.append(v % 11)
    EIG[eps] = ker
    tags = []
    for v in ker:
        if is_diag(v): tags.append("diag")
        else: tags.append(str(tuple(int(z) for z in v)))
    print(f"    eps = {eps}: eigenvectors {tags}")
chk("eigenvalue 1 eigenline is exactly diag (dies in Lambda)",
    len(EIG[1]) == 1 and is_diag(EIG[1][0]))
chk("e_b is a sigma_M-eigenvector with eigenvalue 9 = -2 mod 11",
    eqL11(SIGM(EB), 9 * EB))
chk("c is a sigma_M-eigenvector with eigenvalue 5", eqL11(SIGM(CV), 5 * CV))
chk("c9 is a sigma_M-eigenvector with eigenvalue 9", eqL11(SIGM(C9V), 9 * C9V))
chk("c9 == 6 e_b in Lambda/11 (same eigenline: the eigenspaces are lines)",
    eqL11(C9V, 6 * EB))
sub("(A5) c is EXACTLY an eigenvector mod 11th powers -- so b' := r^c is legitimate")
D = SIGM(CV.astype(np.int64)) - 5 * CV.astype(np.int64)
print(f"    sigma_M(c) - 5c = {tuple(int(z) for z in D)}")
chk("all entries divisible by 11  =>  sigma(r^c) = (r^c)^5 . (11th power)  EXACTLY",
    not (D % 11).any())

# =============================================================== B. F-1
hdr("B. F-1: THE TWO FUNCTIONALS, IN BOTH INDICES")
print("""  RAY index:        g_i := ord_{sigma^i w}(a).  Since ord_P(sigma f) = ord_{sigma^-1 P}(f),
                    ord_{sigma^i w}(psi a) = 2 g_i + g_{i-1}.        [S8.16]
  COMPONENT index:  s_i := ord_w(sigma^i a) = g_{-i}.
                    ord_w(sigma^i (psi a)) = 2 s_i + s_{i+1}.         [S8.9]
  The two patterns are the SAME tuple read with the index reversed (mu_i = G_{-i}).""")
rr = random.Random(SEED)
res = {}
for _ in range(4000):
    g = [rr.randint(-60, 60) for _ in range(5)]
    s = [g[(-i) % 5] for i in range(5)]
    G = [2 * g[i] + g[(i - 1) % 5] for i in range(5)]       # ray-index psi pattern
    Mu = [2 * s[i] + s[(i + 1) % 5] for i in range(5)]      # component-index psi pattern
    assert all(Mu[i] == G[(-i) % 5] for i in range(5)), "the two indices are not reverses"
    for nm, wts, idx, src, tgt in (
            ("ray/5^i   (lambda)", W5, G, g, 7),
            ("ray/9^i   (L9)    ", W9, G, g, 0),
            ("comp/5^i          ", W5, Mu, s, 0),
            ("comp/9^i          ", W9, Mu, s, 7)):
        a = sum(wts[i] * idx[i] for i in range(5)) % 11
        b = (tgt * sum(wts[i] * src[i] for i in range(5))) % 11
        res.setdefault(nm, 0)
        res[nm] += int(a == b)
for nm, n in res.items():
    tgt = 7 if "5^i   (l" in nm or "comp/9" in nm else 0
    chk(f"{nm} . psi == {tgt} * (same functional)   [{n}/4000]", n == 4000)
print("""    => In EITHER index there are two different functionals: one is killed by psi
       (the transpose kernel) and one is multiplied by 7.  Reversing the index swaps
       which of them is written '5^i'.  The flip is REAL: it is not a relabelling that
       makes a false statement true, it is a relabelling that makes a TRUE statement
       about one functional look like a statement about the OTHER one.""")

sub("which functional does the b-cover force?  (transport, done by hand in the draft)")
print("""    partial_q cores(y,b) = prod_i sigma^{-i}( b|_{sigma^i P} )^{ord_{sigma^i P}(y)}
    and  [sigma^{-1} b] = [b]^5  (S8.12 item 3), so [sigma^{-i} b] = [b]^{5^i} and the
    exponent is  sum_i 5^i ord_{sigma^i P}(y)  --  the RAY index with 5^i weights.""")
chk("[sigma^{-i} b] = [b]^{5^i} in Lambda/11 for i = 0..4   (sigma_M^{-i} = shift_{+i})",
    all(eqL11(shift(EB, i), pow(5, i, 11) * EB) for i in range(5)))
chk("the OTHER direction is 9: [sigma^i b] = [b]^{9^i}",
    all(eqL11(shift(EB, -i), pow(9, i, 11) * EB) for i in range(5)))
chk("lambda(e_b) == 0 (mod 11)  [S8.10's computation 2+5-12+16 = 11]",
    sum(W5[i] * int(EB[i]) for i in range(5)) % 11 == 0)
chk("L9(e_b)     == 7 (mod 11)  [so e_b is NOT in Im(2 + sigma_M)]",
    sum(W9[i] * int(EB[i]) for i in range(5)) % 11 == 7)

# =============================================================== C. F-2
hdr("C. F-2: THEOREM N, AND WHETHER THEOREM O COLLAPSES TO 0 = 0")


def lam(vals, wts):
    return sum(wts[i] * int(vals[i]) for i in range(5)) % 11


sub("(C1) the corrected boundary law, by direct computation on order patterns")
rr2 = random.Random(SEED + 3)
n5 = n9 = 0
for _ in range(4000):
    w = np.array([rr2.randint(-30, 30) for _ in range(5)], dtype=np.int64); w[4] = -int(w[:4].sum())
    g = [rr2.randint(-60, 60) for _ in range(5)]                     # h at the 5 conjugate rays
    # F(sigma^i w) = ord of phi = psi(a)/r_2 at the ray sigma^i w;
    # <sigma^i w, e_2> = <w, sigma_M^{-i} e_2> = <w, shift_{+i} e_2>
    t = [int(w @ shift(E2, i)) for i in range(5)]
    F = [2 * g[i] + g[(i - 1) % 5] - t[i] for i in range(5)]
    n5 += int((lam(F, W5) - (7 * lam(g, W5) - int(w @ CV))) % 11 == 0)
    n9 += int((lam(F, W9) + int(w @ C9V)) % 11 == 0)
chk(f"lambda_w(phi) == 7 lambda_w(div a) - <w,c>   [{n5}/4000]  -- CORRECTED Theorem N", n5 == 4000)
chk(f"L9_w(phi)     ==            - <w,c9>         [{n9}/4000]  -- Theorem R = congruence (3)",
    n9 == 4000)
print("""    => Theorem N as printed (lambda_w(phi) == -<w,c>) is EQUIVALENT, since 7 is a unit
       mod 11, to lambda_w(div a) == 0 -- which is (F2) itself.  It is not an independent
       fact.  The index-correct twin of Theorem N is Theorem R, i.e. congruence (3).""")

sub("(C2) Theorem M implies the same thing, from inside the source")
print("""    Theorem M: N_lambda(x) := prod_i sigma^{-i}(x)^{5^i} satisfies N_lambda(psi a) =
    N_lambda(a)^7.  But ord_{D_w}(N_lambda(x)) = sum_i 5^i ord_{sigma^i w}(x) = lambda_w(x)
    EXACTLY.  Taking ord_{D_w} of Theorem M therefore gives lambda_w(psi a) = 7 lambda_w(a)
    -- the source's own Theorem M contradicts the step Theorem N uses.""")
nM = 0
for _ in range(2000):
    g = [rr2.randint(-60, 60) for _ in range(5)]
    G = [2 * g[i] + g[(i - 1) % 5] for i in range(5)]
    nM += int((lam(G, W5) - 7 * lam(g, W5)) % 11 == 0)
chk(f"ord(N_lambda(psi a)) == 7 ord(N_lambda(a))  [{nM}/2000]", nM == 2000)

sub("(C3) Theorem O for MONOMIAL a: both expressions for A_K, from the tame symbol")
print("""    a = r^u  =>  phi = psi(a)/r_2 = r^{(2+sigma_M)u - e_2}.  For monomials the residue
    of cores(r^v, r^m) at the boundary orbit of w is the character class
        V(v,m) = sum_k [ <sigma^k w, m> shift_k(v) - <sigma^k w, v> shift_k(m) ]  in Lambda/11
    (transport of the tame symbol at sigma^k w by sigma^{-k}).  Test
        V(phi, e_b)  ==  7 V(u, e_b) + V(-e_2, e_b)     (the S8.12 item-4 identity)""")


def coresV(v, m, w):
    V = np.zeros(5, dtype=np.int64)
    wk = np.asarray(w, dtype=np.int64)
    for k in range(5):
        # sigma^k w pairs as <sigma^k w, y> = <w, shift_k y>
        V = V + int(wk @ shift(m, k)) * shift(v, k) - int(wk @ shift(v, k)) * shift(m, k)
    return V


rr3 = random.Random(SEED + 5)
nO = nON = nOK = 0
for _ in range(3000):
    w = np.array([rr3.randint(-25, 25) for _ in range(5)], dtype=np.int64); w[4] = -int(w[:4].sum())
    u = np.array([rr3.randint(-25, 25) for _ in range(5)], dtype=np.int64)
    phi = 2 * u + SIGM(u) - E2
    lhs = coresV(phi, EB, w)
    rhs = 7 * coresV(u, EB, w) + coresV(-E2, EB, w)
    nO += int(eqL11(lhs, rhs))
    # the version with Theorem N IMPOSED: replace phi's lambda-content by -<w,c>, i.e.
    # subtract the 7*lambda_w(u) that Theorem N drops.  lambda_w(r^u) = <w, sum_i 5^i
    # shift_i(u)> because ord_{sigma^i w}(r^u) = <w, shift_i u>.
    # Theorem-N-imposed variant: replacing lambda_w(phi) by -<w,c> drops 7*lambda_w(a)
    # from the exponent of l(b), i.e. ADDS 7*lambda_w(a)*e_b to the residue class.  Only
    # well posed where <w,e_b> == 0 mod 11 (finding F-4).
    if int(w @ EB) % 11 == 0:
        lamu = int(w @ (sum(W5[k] * shift(u, k) for k in range(5)))) % 11
        lhsN = lhs + (7 * lamu) * EB
        nON += int(eqL11(lhsN, rhs) == (lamu % 11 == 0))
        nOK += 1
chk(f"cores identity holds for every monomial a and every ray  [{nO}/3000]", nO == 3000)
chk(f"with Theorem N imposed, the sides differ by 7*lambda_w(a)*e_b -- nonzero EXACTLY "
    f"when (F2) fails  [{nON}/{nOK} well-posed rays]", nON == nOK)
print("""    => the two expressions for A_K have IDENTICAL residues for every u and every w.
       Theorem O's per-ray consistency equation is 0 = 0.  The leftover
       [l_w(b)]^{7 lambda_w(a)} of S8.15 appears only if Theorem N is first imposed as an
       extra input, i.e. only if (F2) is assumed.""")

sub("(C4) Theorem L reproduced (calibration of the residue formula used above)")
nL = 0
for _ in range(2000):
    w = np.array([rr3.randint(-25, 25) for _ in range(5)], dtype=np.int64); w[4] = -int(w[:4].sum())
    V = coresV(-E2, EB, w)
    pred = int(w @ CV) * EB - int(w @ EB) * CV
    nL += int(eqL11(V, pred) and int(w @ V) == 0)
chk(f"d_q(cores(r_2^-1,b)) == [r^{{<w,c> e_b - <w,e_b> c}}] and _|_ w  [{nL}/2000]", nL == 2000)

# =============================================================== D. the repair
hdr("D. THE REPAIR ATTEMPT: exhaust the sigma-eigenclasses of the second slot")
print("""  E*/(E*)^11 is a module over F_11[C_5]; x^5 - 1 splits with distinct roots mod 11, so
  the module is SEMISIMPLE with eigen-decomposition over eps in {1,3,9,5,4}.  cores is
  bilinear, so it is enough to treat beta in a single eigencomponent, [sigma beta] =
  [beta]^eps.  Then, using cores . sigma_* = cores:
      cores(sigma a, beta) = cores(a, sigma^{-1} beta) = eps^{-1} cores(a, beta),
      cores(psi a, beta)   = (2 + eps^{-1}) cores(a, beta),
      cores(phi, beta)     = (2 + eps^{-1}) cores(a, beta) - cores(r_2, beta).
  At a split orbit the residue functional attached to beta is sum_i eps^{-i} ord_{sigma^i P}.
  Table:""")
print(f"\n    {'eps':>4s} {'eps^-1':>7s} {'2+eps^-1':>9s} {'residue functional':>20s}  {'verdict'}")
for eps in roots:
    ei = pow(eps, 9, 11)
    fac = (2 + ei) % 11
    fname = {1: "sum (trivial)", 3: "sum 4^i", 9: "sum 5^i  (= lambda)",
             5: "sum 9^i  (= L9)", 4: "sum 3^i"}[eps]
    if fac == 0:
        v = "a-term DROPS OUT: cores(phi,beta) = -cores(r_2,beta), an explicit class"
    else:
        v = f"factor {fac} is a unit: the identity DEFINES cores(a,beta); no constraint"
    print(f"    {eps:4d} {ei:7d} {fac:9d} {fname:>20s}  {v}")
chk("exactly one eigenvalue gives 2 + eps^{-1} == 0 (mod 11), namely eps = 5",
    [eps for eps in roots if (2 + pow(eps, 9, 11)) % 11 == 0] == [5])
chk("b lies in the eps = 9 component (so its functional is lambda, factor 7)",
    (2 + pow(9, 9, 11)) % 11 == 7 and eqL11(SIGM(EB), 9 * EB))
chk("the eps = 5 component is spanned by c (so beta = r^c is THE unconditional choice)",
    eqL11(SIGM(CV), 5 * CV))
print("""
    CONSEQUENCE (the no-go).  A congruence on div(a) can only come from an evaluation of
    cores(phi,beta) that does NOT go through a.  That happens only for eps = 5.  But for
    eps = 5 the a-term is annihilated (2 + 9 = 11 == 0), so the resulting condition is
    a condition on phi alone:
        interior split orbit:   L9_O(div phi) == 0        (automatic: div phi in Im(2+sigt))
        boundary ray orbit:     L9_w(phi) == -<w,c9>      (= Theorem R = congruence (3))
    Neither mentions lambda.  For eps = 9 (the actual b) the factor is the unit 7, so the
    identity merely computes cores(a,b) from phi and constrains nothing.  There is no
    choice of second slot for which the Brauer layer outputs lambda_O(div a) == 0.""")

sub("(D1) the eps = 5 boundary condition really is congruence (3), computed")
n = 0
for _ in range(3000):
    w = np.array([rr3.randint(-25, 25) for _ in range(5)], dtype=np.int64); w[4] = -int(w[:4].sum())
    u = np.array([rr3.randint(-25, 25) for _ in range(5)], dtype=np.int64)
    phi = 2 * u + SIGM(u) - E2
    lhs = coresV(phi, CV, w)                # cores(phi, r^c)
    rhs = -coresV(E2, CV, w)                # -cores(r_2, r^c);  the a-term must vanish
    n += int(eqL11(lhs, rhs))
chk(f"cores(phi, r^c) == -cores(r_2, r^c) for every monomial a, every ray  [{n}/3000]",
    n == 3000)
print("      (the 11 * cores(a, r^c) term is invisible in Br[11] -- this is the identity")
print("       whose residue is Theorem R, and it holds with NO condition on a.)")

sub("(D2) the eps = 5 class is itself RAMIFIED at the boundary, so 'unramified => 0' fails")
nb = nzz = 0
for _ in range(3000):
    w = np.array([rr3.randint(-25, 25) for _ in range(5)], dtype=np.int64); w[4] = -int(w[:4].sum())
    B = coresV(-E2, EB, w)          # cores(r_2^-1, b)     [Theorem L]
    Bp = coresV(-E2, CV, w)         # cores(r_2^-1, r^c)
    nb += int(eqL11(Bp, -6 * B))
    nzz += int(not is_diag(Bp % 11))
chk(f"d_q(cores(r_2^-1, r^c)) == -6 * d_q(B) at every ray  [{nb}/3000]  (since c9 = 6 e_b)",
    nb == 3000)
print(f"    and it is NONZERO at {nzz}/3000 rays, so the eps=5 class is ramified at the")
print("    boundary: there is no 'unramified everywhere => A_K = 0' conclusion to be had,")
print("    and in any case its a-term has already dropped out.")

# =============================================================== E. Theorem R
hdr("E. THEOREM R RE-DERIVED, AND ITS 5-WEIGHTED TWIN")
print("""  For ANY integer-valued h on the cocharacter lattice, F := 2h + h.sigma^{-1} - e_2^*:
      sum_i 9^i F(sigma^i n) = 11 * sum_i 9^i h(sigma^i n) - <n, c9> == -<n, c9>,
      sum_i 5^i F(sigma^i n) =  7 * sum_i 5^i h(sigma^i n) - <n, c>.
  The first is h-free (2 + 9 = 11); the second is not (2 + 5 = 7).  That single line is
  the whole of F-1/F-2.""")
rr4 = random.Random(SEED + 9)
a9 = a5 = 0
for _ in range(5000):
    n = np.array([rr4.randint(-40, 40) for _ in range(5)], dtype=np.int64); n[4] = -int(n[:4].sum())
    h = [rr4.randint(-99, 99) for _ in range(5)]
    t = [int(n @ shift(E2, i)) for i in range(5)]
    F = [2 * h[i] + h[(i - 1) % 5] - t[i] for i in range(5)]
    a9 += int((lam(F, W9) + int(n @ C9V)) % 11 == 0)
    a5 += int((lam(F, W5) - 7 * lam(h, W5) + int(n @ CV)) % 11 == 0)
chk(f"9-weighted law is h-free  [{a9}/5000]", a9 == 5000)
chk(f"5-weighted law carries 7*lambda(h)  [{a5}/5000]", a5 == 5000)
sub("(E1) S8.9's own W is <w,c9>: the 9-weighted line is coherent from S8.9 to S8.28")
print("""    S8.9 sets mu_i = 2 s_i + s_{i+1} - w_{2+i} with w_{2+i} = <w, e_{2+i}> and gets
    sum_i 5^i mu_i == -W, W := sum_i 5^i w_{2+i}.  The covector sum_i 5^i e_{2+i} has
    j-th coordinate 5^{j-2}, i.e. it IS c9 -- so S8.9's W equals <w,c9> and S8.9's
    congruence is already Theorem R.  Nothing in the 9-weighted line is broken.""")
Wcov = sum(W5[i] * np.eye(5, dtype=np.int64)[(2 + i) % 5] for i in range(5)) % 11
print(f"    sum_i 5^i e_{{2+i}} = {tuple(int(z) for z in Wcov)}")
chk("S8.9's W-covector == c9", eqL11(Wcov, C9V))

sub("(E2) Im(2 + sigma_M) inside Lambda is cut out by L9 alone (index 11, not 33)")
M2 = np.zeros((5, 5), dtype=np.int64)
for j in range(5):
    e = np.zeros(5, dtype=np.int64); e[j] = 1
    M2[:, j] = 2 * e + SIGM(e)
det = int(round(np.linalg.det(M2.astype(float))))
print(f"    det(2 + sigma_M) on Z^5 = {det};  diag is an eigenvector with eigenvalue 3,")
print(f"    so the determinant on Lambda = Z^5/diag is {det}/3 = {det // 3}.")
chk("det = 33 on Z^5", det == 33)
chk("diag is fixed with eigenvalue 3", eqL(2 * DIAG + SIGM(DIAG), 3 * DIAG))
chk("L9 kills diag, so L9 is defined on Lambda", sum(W9) % 11 == 0)
chk("lambda kills diag too", sum(W5) % 11 == 0)
print("""    => corrected Theorem I(iii): the unit part m of phi must satisfy
       L9(m) == -L9(e_2) == -4 == 7 (mod 11)   [the source printed lambda(m) == 8].""")
chk("L9(e_2) == 4 and -L9(e_2) == 7", sum(W9[i] * int(E2[i]) for i in range(5)) % 11 == 4)
chk("(the source's 5-weighted value was lambda(e_2) = 3, -3 == 8)",
    sum(W5[i] * int(E2[i]) for i in range(5)) % 11 == 3)

sub("(E3) F-5: S8.16's 'two distinct 11-covers' -- they are the SAME direction")
print("""    (2+sigma_M) acts on the eps-eigenline of Lambda tensor F_11 by (2+eps), which is 0
    mod 11 exactly for eps = 9 -- the e_b line.  So the denominator-11 direction of the
    crux point (2+sigma)^{-1} e_2 IS the b-cover direction, contradicting S8.16's
    parenthetical 'adj(2+sigma) e_2 !== unit * e_b mod 11'.  Computed:""")
GCo = [16, -8, 4, -2, 1]                       # (2+x) G(x) = 33 in Z[x]/(x^5-1)   [S8.28]
adj = sum(GCo[j] * (E2 if j == 0 else np.linalg.matrix_power(
    np.array([[1 if (i - 1) % 5 == k else 0 for k in range(5)] for i in range(5)],
             dtype=np.int64), j) @ E2) for j in range(5))
print(f"    adj(2+sigma_M) e_2 = G(sigma_M) e_2 = {tuple(int(z) for z in adj)}"
      f"  == {tuple(int(z) for z in adj % 11)} (mod 11)")
chk("(2+sigma_M) . adj = 33 on e_2", eqL(2 * adj + SIGM(adj), 33 * E2))
hit = [t for t in range(1, 11) if eqL11(adj, t * EB)]
print(f"    multiples t of e_b matching adj(2+sigma) e_2 in Lambda/11: {hit}")
chk("adj(2+sigma) e_2 == 8 * e_b in Lambda/11  =>  ONE cover, not two", hit == [8])
v11 = (adj - int(adj[1]) * DIAG) // 3                  # = 11 * (2+sigma_M)^{-1} e_2 in Lambda
chk("adj(2+sigma_M) e_2 is divisible by 3 in Lambda (det on Lambda is 11, not 33)",
    not ((adj - int(adj[1]) * DIAG) % 3).any())
chk("11*(2+sigma_M)^{-1} e_2 = " + str(tuple(int(z) for z in v11)) + " and (2+sigma_M) v11 = 11 e_2",
    eqL(2 * v11 + SIGM(v11), 11 * E2))
hit2 = [t for t in range(1, 11) if eqL11(v11, t * EB)]
chk(f"...and it is {hit2} * e_b mod 11, a UNIT multiple => Lambda + Z v11/11 == Lambda'",
    len(hit2) == 1 and hit2[0] % 11 != 0)
chk("e_b == 8 G9 + 5 diag  [S8.24(iii)], G9 = (1,5,3,4,9)",
    eqL11(EB, 8 * np.array([1, 5, 3, 4, 9], dtype=np.int64)))
chk("c9 == 4 G9  [S8.18]", eqL11(C9V, 4 * np.array([1, 5, 3, 4, 9], dtype=np.int64)))
print("    (the crux's denominator statement itself survives: 2+eps == 0 only at eps = 9,")
print("     and e_2 has a nonzero eps=9 component, so the denominator is exactly 11.)")

nz = 0
for _ in range(500):
    n = np.array([rr4.randint(-40, 40) for _ in range(5)], dtype=np.int64); n[4] = -int(n[:4].sum())
    h = [rr4.randint(-99, 99) for _ in range(5)]
    nz += int(7 * lam(h, W5) % 11 != 0)
chk(f"the 7*lambda(h) term is genuinely nonzero for most h  [{nz}/500 nonzero]", nz > 400)

# =============================================================== F. witnesses
if not FAST:
    hdr("F. WITNESS RE-TEST: the 14 recorded mixed-fan witnesses")
    HERE = os.path.dirname(os.path.abspath(__file__))
    PARENT = os.path.join(HERE, "f55_qpreimage.py")
    MARK = "# ============================================================ 6. run the patterns"
    src = open(PARENT).read(); cut = src.index(MARK)
    ns = {"__name__": "f55_qpreimage_partial", "__file__": PARENT}
    buf = io.StringIO()
    t0 = time.time()
    with contextlib.redirect_stdout(buf):
        exec(compile(src[:cut], PARENT, "exec"), ns)
    NC, CK, ORB = ns["NC"], ns["CK"], ns["ORB"]
    R4, NR, RCELL = ns["R4"], ns["NR"], ns["RCELL"]
    GPERM, GORB, GCELLS = ns["GPERM"], ns["GORB"], ns["GCELLS"]
    pairs, sigN = ns["pairs"], ns["sigN"]
    build_witness, certify_d = ns["build_witness"], ns["certify_d"]
    solve_preimage, verify_preimage = ns["solve_preimage"], ns["verify_preimage"]
    convexify, is_concave = ns["convexify"], ns["is_concave"]
    print(f"    loaded parent: {NC} cells, {NR} rays  [{time.time()-t0:.1f}s]")
    R5 = np.array([[r[0], r[1], r[2], r[3], -int(sum(r))] for r in R4.tolist()], dtype=np.int64)
    RIDX = {tuple(int(z) for z in R4[i]): i for i in range(NR)}
    SIGR = np.array([RIDX[tuple(int(z) for z in
                     np.array(sigN(tuple(int(v) for v in R5[i])))[:4])] for i in range(NR)])
    RORB = []; seen = set()
    for i in range(NR):
        if i in seen: continue
        o = [i]
        for _ in range(4): o.append(int(SIGR[o[-1]]))
        seen.update(o); RORB.append(o)
    assert 5 * len(RORB) == NR

    def sray(i, k):
        for _ in range(k % 5): i = int(SIGR[i])
        return i

    PATTERNS = []
    for P0 in [(3, 4), (0, 1)]:
        Z = [i for i, (pA, pG) in enumerate(CK) if pG.index(0) in P0]
        PATTERNS.append((f"G9-rank P={list(P0)}", Z))
    LAB = {gi: {GPERM[g].index(0): g for g in og} for gi, og in enumerate(GORB)}
    for gi0 in (0, 1, 2):
        for (i0, j0) in pairs:
            if (i0, j0) == (0, 1): continue
            zg = set()
            for gi in range(len(GORB)):
                for t in ({i0, j0} if gi == gi0 else {0, 1}): zg.add(LAB[gi][t])
            Ze = sorted(c for g in zg for c in GCELLS[g])
            if min(sum(1 for c in o if c in set(Ze)) for o in ORB) < 2: continue
            PATTERNS.append((f"(e) G9-orbit {gi0} -> {(i0,j0)}", Ze))
    WIT = []
    for (tag, Z) in PATTERNS:
        with contextlib.redirect_stdout(buf):
            U5d, msg = build_witness(tag, Z)
            if U5d is None: continue
            Uh, Um = solve_preimage(U5d, tag)
            assert Uh is not None
            verify_preimage(Uh, Um, U5d, tag)
            Tk, Ucav = convexify(Uh, tag, -1)
        assert Ucav is not None and is_concave(Ucav) == 0
        WIT.append((tag, Ucav))
    print(f"    rebuilt {len(WIT)} witnesses")
    assert len(WIT) == 14

    def rayvals(U):
        V = U @ R4.T
        return np.array([int(V[RCELL[i][0], i]) for i in range(NR)], dtype=np.int64)

    n_id = n9ok = n5ok = 0; tot = 0
    for (tag, Uc) in WIT:
        hr = rayvals(Uc)
        for oi, o in enumerate(RORB):
            i0 = o[0]
            g = [int(hr[sray(i0, k)]) for k in range(5)]
            w = R5[i0]
            t = [int(R5[sray(i0, k)] @ E2) for k in range(5)]
            F = [2 * g[k] + g[(k - 1) % 5] - t[k] for k in range(5)]
            tot += 1
            n_id += int((lam(F, W5) - (7 * lam(g, W5) - int(w @ CV))) % 11 == 0)
            n9ok += int((lam(F, W9) + int(w @ C9V)) % 11 == 0)
            n5ok += int((lam(F, W5) + int(w @ CV)) % 11 == 0)
    chk(f"lambda_w(phi) = 7 lambda_w(div a) - <w,c> on the real witnesses  [{n_id}/{tot}]",
        n_id == tot)
    chk(f"REPAIRED Brauer condition (= Theorem R / congruence (3)) holds  [{n9ok}/{tot}]",
        n9ok == tot)
    print(f"    [{'--'}] Theorem N as printed / (F2) holds at only {n5ok}/{tot} orbit-witness pairs")
    print("""
    VERDICT ON THE WITNESSES.  The condition the Brauer layer actually outputs is the
    9-weighted one, and the 14 witnesses satisfy it at 100% of boundary ray-orbits -- as
    they must, since it is congruence (3), which they were built to satisfy.  The
    5-weighted condition (F2) fails, but nothing derives it.  THE WITNESSES SURVIVE.""")
else:
    hdr("F. WITNESS RE-TEST -- skipped (--fast)")

hdr("SUMMARY")
print(f"    checks failed: {len(FAIL)}")
for f in FAIL: print("      - " + f)
print(f"\n    runtime {time.time()-T0:.1f}s")
sys.exit(1 if FAIL else 0)
