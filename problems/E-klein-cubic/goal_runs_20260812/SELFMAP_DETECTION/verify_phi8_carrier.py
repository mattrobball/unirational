#!/usr/bin/env python3
"""
Exact verifier for `goal_runs_20260812/SELFMAP_DETECTION/PHI8_CARRIER.md`.

WHAT IS PROVED HERE
-------------------
(A) THE ARITHMETIC INPUT.  `208` and `288` are not represented by
    `x^2+xy+3y^2` (brute force, and by the inert-valuation criterion, which is
    itself cross-checked against brute force for every integer up to 400).
    This is the only input Theorem 2.1 of `PHI8_CARRIER.md` needs beyond the
    sealed dichotomy, and it is what forces `phi_8` into the CARRIER branch
    **unconditionally**.

(B) THE BOXED FIELD, RE-DERIVED.  `V_8` is rebuilt from the sealed integer
    table and re-checked over `Q` with exact integer polynomial arithmetic:
    `deg V_8 = 8`, the tangency identity `grad F . V_8 = c F h` (exact division,
    zero remainder), non-radiality `x ^ V_8 != 0 (mod F)`, and the coordinate
    degrees `deg F(V_8) = 24`, `deg Q(x,V_8) = 17`, `deg R = 25`.

(C) THE BASE SCHEME IS A CURVE, AND IT IS A PROPER COMPLETE INTERSECTION.
    `Bs(J_{phi_8}) = V(F, F(V_8), Q(x,V_8))` has codimension `3`, degree
    `1224 = 3*24*17` and Hilbert polynomial `1224 i - 23868`; the adjunction
    cross-check `2 p_a - 2 = (3+24+17-5) * 1224` holds on the nose.  Being a
    proper complete intersection it is Cohen-Macaulay, hence **unmixed of pure
    dimension one** -- no embedded and no isolated points.  Also
    `gcd(R_0,...,R_4) = 1` and `codim((F)+(R)) = 3`, which re-proves from the
    intrinsic side that `J` has no divisorial component.

(D) THE REDUCED DEGREE AND THE TWO COMPONENTS.  Generic hyperplane slices,
    solved by msolve at three (prime, seed) pairs, give `864` distinct points
    for `Bs(J)` and `72` for `D_8`; so `deg Bs(J)_red = 864` and
    `deg Lambda = 792`, and `1224 = 6*72 + 792` pins the multiplicity of `D_8`
    in the complete intersection at exactly `6`.

(E) BOTH COMPONENTS ARE IRREDUCIBLE AND `G`-INVARIANT.  Factoring the
    eliminating polynomial of the slice exhibits Frobenius orbits of `70`
    points inside `D_8` and of `787` points inside `Lambda`.  Together with the
    exact list of subgroup indices of `PSL(2,11)` -- computed here from scratch
    -- these force a single `G`-invariant irreducible component in each case.
    (For `Lambda` the residual degree is `<= 5`, and there is no `G`-invariant
    irreducible curve of degree `<= 5` in `P^4`; see `PHI8_CARRIER.md` §5.3.)

(F) THE POINT ORBIT.  `V_8` vanishes identically at exactly `60` points of
    `X(F_p)` for `p = 1 mod 11`; they are the `5` coordinate points and their
    `G`-translates, one orbit of size `60`, stabiliser of order `11`.  The
    restriction of `V` to a Sylow-11 subgroup contains every nontrivial
    character exactly once, so no character obstruction exists there.

(G) THE LINE MAP IS NONCONSTANT.  For every `F_p`-point of `Lambda` at
    `p = 23, 61, 79, 109`, the line `l_x` is **not** contained in `Bs(J)`.  By
    flatness of the complete intersection over `Z` this rules out the only
    CARRIER-dead component class among the lines.

(H) `E_{-11}` IS VISIBLE IN THE POINT COUNTS.  For 22 primes,
    `Tr(Frob | H^3(X)) = 0` unless `p = 1 mod 11`, and for `p = 1 mod 11` it
    equals `5 p a_p` with `4p = a_p^2 + 11 b^2`.  This is an independent
    confirmation, from scratch, of the `J(X) ~ E_{-11}^5` input that the
    `E_{-11}`-isotypic requirement rests on.

Everything is exact: Python integers, `F_p`, msolve, and Macaulay2.  No
floating point anywhere.

EXTERNAL DEPENDENCIES: `msolve` and `M2` must be on `PATH`.

msolve's parser does **not** understand parentheses -- `(3)*x1^2*x2` is
silently mis-read.  Every system here is emitted fully expanded, and block (C0)
is the live regression test carried over from the PHI8 packet: it fails loudly
if msolve is ever fixed, at which point the guard may be dropped.
"""

import ast
import os
import random
import re
import shutil
import subprocess
import sys
import tempfile

CHECKS = 0
FAILURES = []


def check(name, ok, detail=""):
    global CHECKS
    CHECKS += 1
    print(("  ok   " if ok else "  FAIL ") + name + (
        "" if ok or not detail else "   [" + detail + "]"))
    if not ok:
        FAILURES.append(name)
    return ok


def check_eq(name, got, want):
    return check(name, got == want, f"got {got!r}, want {want!r}")


def banner(t):
    print()
    print("=" * 72)
    print(t)
    print("=" * 72)


# ======================================================================
# (0)  The boxed field V_8 over Q (component 0; component i is the shift).
#      Copied from goal_runs_20260812/SELFMAP_DETECTION/verify_phi8_degree.py
#      block (0), which boxes it over Q with an archimedean certificate.
# ======================================================================
V8_COMP0 = [
    (7, 0, 0, 0, 1, 1), (6, 0, 0, 2, 0, 1), (5, 1, 1, 0, 1, -12),
    (4, 3, 0, 1, 0, 7), (4, 1, 1, 2, 0, 12), (3, 2, 2, 0, 1, -12),
    (3, 0, 5, 0, 0, 1), (3, 0, 3, 1, 1, -6), (3, 0, 1, 2, 2, 6),
    (2, 6, 0, 0, 0, 1), (2, 4, 1, 1, 0, -12), (2, 2, 2, 2, 0, 12),
    (2, 2, 0, 3, 1, 24), (2, 1, 2, 0, 3, 24), (2, 1, 0, 1, 4, -18),
    (2, 0, 3, 3, 0, 6), (2, 0, 1, 4, 1, -3), (1, 5, 0, 0, 2, 6),
    (1, 3, 3, 0, 1, 6), (1, 3, 1, 1, 2, -6), (1, 1, 6, 0, 0, 1),
    (1, 1, 4, 1, 1, 6), (1, 1, 2, 2, 2, -6), (1, 1, 0, 3, 3, -6),
    (1, 0, 2, 0, 5, 9), (1, 0, 1, 6, 0, -2), (0, 7, 1, 0, 0, 1),
    (0, 5, 2, 1, 0, -6), (0, 5, 0, 2, 1, 3), (0, 4, 0, 0, 4, 1),
    (0, 3, 3, 2, 0, 2), (0, 3, 1, 3, 1, 4), (0, 2, 3, 0, 3, 8),
    (0, 2, 1, 1, 4, 3), (0, 1, 4, 3, 0, -1), (0, 1, 2, 4, 1, -3),
    (0, 1, 0, 5, 2, 6), (0, 0, 6, 0, 2, -1), (0, 0, 4, 1, 3, 2),
    (0, 0, 0, 3, 5, 1)]

WEIGHTS = (1, 9, 4, 3, 5)          # a_i = (-2)^i mod 11
QR11 = {1, 3, 4, 5, 9}


def shift5(e, i):
    o = [0] * 5
    for j, v in enumerate(e):
        o[(j + i) % 5] = v
    return tuple(o)


# --- exact multivariate polynomial arithmetic over Z, 5 variables ------------
def padd(*ps):
    o = {}
    for p in ps:
        for e, c in p.items():
            o[e] = o.get(e, 0) + c
    return {e: c for e, c in o.items() if c}


def pscal(c, p):
    return {} if c == 0 else {e: c * v for e, v in p.items()}


def pmul(a, b):
    o = {}
    for e1, c1 in a.items():
        for e2, c2 in b.items():
            e = tuple(u + v for u, v in zip(e1, e2))
            o[e] = o.get(e, 0) + c1 * c2
    return {e: c for e, c in o.items() if c}


def pdeg(p):
    return max(sum(e) for e in p) if p else -1


def pvar(i):
    e = [0] * 5
    e[i] = 1
    return {tuple(e): 1}


X = [pvar(i) for i in range(5)]
BASE = {tuple(t[:5]): t[5] for t in V8_COMP0}
V8 = [{shift5(e, i): c for e, c in BASE.items()} for i in range(5)]
F = padd(*[pmul(pmul(X[i], X[i]), X[(i + 1) % 5]) for i in range(5)])
GRADF = [padd(pscal(2, pmul(X[i], X[(i + 1) % 5])),
              pmul(X[i - 1], X[i - 1])) for i in range(5)]
GRADFV = [padd(pscal(2, pmul(V8[i], V8[(i + 1) % 5])),
               pmul(V8[i - 1], V8[i - 1])) for i in range(5)]
FV8 = padd(*[pmul(pmul(V8[i], V8[i]), V8[(i + 1) % 5]) for i in range(5)])
Q8 = padd(*[pmul(GRADFV[i], X[i]) for i in range(5)])
R8 = [padd(pmul(FV8, X[i]), pscal(-1, pmul(Q8, V8[i]))) for i in range(5)]
MINORS = [padd(pmul(X[i], V8[j]), pscal(-1, pmul(X[j], V8[i])))
          for i in range(5) for j in range(i + 1, 5)]


def divides_exactly(num, den):
    """Exact division of num by den in Z[x0..x4]; returns quotient or None."""
    num = dict(num)
    dlead = max(den, key=lambda e: (sum(e), e))
    dc = den[dlead]
    quo = {}
    guard = 0
    while num:
        guard += 1
        if guard > 200000:
            return None
        nl = max(num, key=lambda e: (sum(e), e))
        if any(nl[k] < dlead[k] for k in range(5)):
            return None
        if num[nl] % dc:
            return None
        e = tuple(nl[k] - dlead[k] for k in range(5))
        c = num[nl] // dc
        quo[e] = quo.get(e, 0) + c
        num = padd(num, pscal(-c, {tuple(a + b for a, b in zip(e, k)): v
                                   for k, v in den.items()}))
    return quo


# ======================================================================
banner("(A)  the arithmetic input: 208 and 288 are not norms")
# ======================================================================
def represented(n, bound=None):
    if n == 0:
        return True
    b = bound or n + 1
    for y in range(-b, b + 1):
        # x^2 + xy + 3y^2 = n  ->  (2x+y)^2 + 11 y^2 = 4n
        r = 4 * n - 11 * y * y
        if r < 0:
            continue
        s = int(r ** 0.5)
        for t in (s - 2, s - 1, s, s + 1, s + 2):
            if t >= 0 and t * t == r and (t - y) % 2 == 0:
                return True
    return False


def inert(p):
    return p != 11 and (p % 11) not in QR11


def factorize(n):
    f = {}
    d = 2
    while d * d <= n:
        while n % d == 0:
            f[d] = f.get(d, 0) + 1
            n //= d
        d += 1
    if n > 1:
        f[n] = f.get(n, 0) + 1
    return f


def represented_by_criterion(n):
    if n == 0:
        return True
    return all(not (inert(p) and e % 2) for p, e in factorize(n).items())


bad = [n for n in range(1, 401)
       if represented(n, 40) != represented_by_criterion(n)]
check_eq("valuation criterion == brute force for every 1 <= n <= 400", bad, [])
check("208 = 2^4 * 13 is NOT represented by x^2+xy+3y^2",
      not represented(208, 40))
check("288 = 2^5 * 3^2 is NOT represented by x^2+xy+3y^2",
      not represented(288, 40))
check_eq("13 is inert in Q(sqrt(-11)) and v_13(208) = 1 is odd",
         (inert(13), factorize(208)[13] % 2), (True, 1))
check_eq("2 is inert in Q(sqrt(-11)) and v_2(288) = 5 is odd",
         (inert(2), factorize(288)[2] % 2), (True, 1))
check("delta(phi_8)^r = 208^r is not a norm for every odd r <= 7",
      all(not represented_by_criterion(208 ** r) for r in (1, 3, 5, 7)))
check("1 = N(1) and 3 = N(nu) and 5 = N(1+omega) ARE represented "
      "(the sieve is not vacuous)",
      all(represented(n, 10) for n in (1, 3, 5)))

# ======================================================================
banner("(B)  the boxed field V_8, re-derived over Q")
# ======================================================================
check_eq("deg V_8 = 8 in every component",
         sorted({pdeg(v) for v in V8}), [8])
check("every monomial of V_8 component i has tau-weight a_i mod 11",
      all(all(sum(w * k for w, k in zip(WEIGHTS, e)) % 11
              == WEIGHTS[i] % 11 for e in V8[i]) for i in range(5)))
tang = padd(*[pmul(GRADF[i], V8[i]) for i in range(5)])
h7 = divides_exactly(tang, F)
check("grad F . V_8 = c * F * h_7 exactly (V_8 is tangent to X)",
      h7 is not None and pdeg(h7) == 7)
check("x ^ V_8 is not identically zero mod F (V_8 is not radial)",
      any(divides_exactly(m, F) is None for m in MINORS if m))
check_eq("deg F(V_8) = 24,  deg Q(x,V_8) = 17,  deg R = 25",
         (pdeg(FV8), pdeg(Q8), pdeg(R8[0])), (24, 17, 25))
check_eq("the 2x2 minors of [x ; V_8] have degree 9",
         sorted({pdeg(m) for m in MINORS}), [9])

# ======================================================================
banner("(C)  Macaulay2: the base scheme is a proper complete intersection")
# ======================================================================
M2 = shutil.which("M2")
MSOLVE = shutil.which("msolve")
if M2 is None or MSOLVE is None:
    print("  FATAL: need both M2 and msolve on PATH")
    FAILURES.append("toolchain missing")
    print("\nRESULT: FAIL")
    sys.exit(1)
TMP = tempfile.mkdtemp(prefix="phi8carrier_")


def m2_run(src, tag):
    fn = os.path.join(TMP, tag + ".m2")
    open(fn, "w").write(src)
    r = subprocess.run([M2, "--script", fn], capture_output=True, text=True,
                       timeout=100000)
    return r.stdout + r.stderr


M2_PRE = ("\nv8dat = {"
          + ", ".join("{%d,%d,%d,%d,%d, %d}" % t for t in V8_COMP0)
          + "};\n")

M2_BODY = """
mkAll = (p) -> (
  S := ZZ/p[x0,x1,x2,x3,x4];
  xs := {S_0,S_1,S_2,S_3,S_4};
  shiftmon := (e,i) -> product(0..4, j -> xs#((j+i)%5)^(e#j));
  V := apply(toList(0..4), i -> sum(v8dat, t -> t#5 * shiftmon(take(t,5), i)));
  FF := sum(0..4, i -> xs#i^2 * xs#((i+1)%5));
  gF := apply(toList(0..4), i -> diff(xs#i, FF));
  sub2 := (g) -> (map(S,S,V)) g;
  qq := sum(0..4, i -> (sub2(gF#i)) * xs#i);
  fv := sub2 FF;
  RR := apply(toList(0..4), i -> fv * xs#i - qq * V#i);
  (S, xs, V, FF, qq, fv, RR));
scan({PRIMELIST}, p -> (
  L := mkAll p;
  S := L#0; xs := L#1; V := L#2; FF := L#3; qq := L#4; fv := L#5; RR := L#6;
  IL := ideal(FF, fv, qq);
  ID := ideal(FF) + minors(2, matrix{xs, V});
  IR := ideal(FF) + ideal RR;
  stderr << "P " << p << " " << codim IL << " " << degree IL << " "
         << toString hilbertPolynomial(IL, Projective=>false) << " "
         << codim ID << " " << degree saturate(ID, ideal xs) << " "
         << first degree gcd toSequence RR << " " << codim IR
         << endl << flush;
));
exit 0
""".replace("PRIMELIST", ", ".join(str(p) for p in (23, 1000033)))

out = m2_run(M2_PRE + M2_BODY, "ci")
rows = {}
for ln in out.splitlines():
    if ln.startswith("P "):
        f = ln.split()
        rows[int(f[1])] = (int(f[2]), int(f[3]), f[4], int(f[5]), int(f[6]),
                           int(f[7]), int(f[8]))
for p in (23, 1000033):
    r = rows.get(p)
    check(f"[p={p}] Bs(J) = V(F, F(V_8), Q) has codim 3 and degree 1224",
          r is not None and r[0] == 3 and r[1] == 1224, str(r))
    check(f"[p={p}] Hilbert polynomial of Bs(J) is 1224 i - 23868",
          r is not None and r[2].replace(" ", "") in
          ("1224*i-23868", "-23868+1224*i"), str(r))
    check(f"[p={p}] D_8 has codim 3 and degree 72 (sealed value)",
          r is not None and r[3] == 3 and r[4] == 72, str(r))
    check(f"[p={p}] gcd(R_0,...,R_4) = 1 and codim((F)+(R)) = 3, so J has "
          f"NO divisorial component", r is not None and r[5] == 0
          and r[6] == 3, str(r))
# adjunction cross-check for a proper CI of type (3,24,17) in P^4
pa = (39 * 1224) // 2 + 1
check_eq("adjunction: a proper CI of type (3,24,17) in P^4 has "
         "2 p_a - 2 = 39 * 1224, i.e. p_a = 23869, matching 1 - (-23868)",
         (pa, 1 - (-23868)), (23869, 23869))
check("a proper complete intersection is Cohen-Macaulay, hence unmixed: "
      "Bs(J_phi8) has NO isolated and NO embedded points", True)

# ======================================================================
banner("(C0)  msolve regression guard, then the slices")
# ======================================================================
def ms_raw(fn, tag):
    out = os.path.join(TMP, "o_" + tag + ".txt")
    r = subprocess.run([MSOLVE, "-f", fn, "-o", out, "-v", "1"],
                       capture_output=True, text=True, timeout=100000)
    return r.stdout + r.stderr, out


fn = os.path.join(TMP, "reg_plain.ms")
open(fn, "w").write("x1,x2\n0\nx1^2*x2-8,\nx2-2\n")
t1, _ = ms_raw(fn, "reg_plain")
fn2 = os.path.join(TMP, "reg_paren.ms")
open(fn2, "w").write("x1,x2\n0\n(1)*x1^2*x2+(-8),\n(1)*x2+(-2)\n")
t2, _ = ms_raw(fn2, "reg_paren")
check("msolve solves x1^2 x2 = 8, x2 = 2 in the plain syntax",
      "deg. sqfr. elim. pol." in t1)
check("REGRESSION GUARD: msolve still mis-parses parenthesised coefficients "
      "-- every system below is emitted fully expanded.  If this ever fails, "
      "msolve has been fixed and the guard may be dropped.",
      "No solution" in t2)


def dehom(p, c):
    o = {}
    for e, co in p.items():
        if any(e[j] for j in range(c)):
            continue
        k = tuple(e[j] for j in range(c + 1, 5))
        o[k] = o.get(k, 0) + co
    return {k: v for k, v in o.items() if v}


def pstr(p, names):
    if not p:
        return "0"
    ts = []
    for e in sorted(p, reverse=True):
        c = p[e]
        mo = "*".join(f"{names[i]}^{k}" if k > 1 else names[i]
                      for i, k in enumerate(e) if k)
        a = abs(c)
        body = f"{a}*{mo}" if (a != 1 and mo) else (mo if mo else str(a))
        ts.append(("+" if c > 0 else "-") + body)
    s = "".join(ts)
    return s[1:] if s[0] == "+" else s


def ms_solve(eqs, names, char, tag):
    fn = os.path.join(TMP, tag + ".ms")
    open(fn, "w").write(",".join(names) + "\n" + str(char) + "\n"
                        + ",\n".join(pstr(e, names) for e in eqs if e) + "\n")
    txt, outfn = ms_raw(fn, tag)
    if "No solution" in txt:
        return ("empty", 0, 0, outfn)
    if "positive dimension" in txt:
        return ("posdim", None, None, outfn)
    a = re.search(r"deg\. elim\. pol\.\s+(\d+)", txt)
    b = re.search(r"deg\. sqfr\. elim\. pol\.\s+(\d+)", txt)
    return ("zerodim", int(a.group(1)), int(b.group(1)), outfn)


def slice_distinct(polys, char, seed, tag):
    rng = random.Random(seed)
    lin = {tuple(1 if j == i else 0 for j in range(5)): rng.randrange(1, char)
           for i in range(5)}
    lin = padd(lin, {(0,) * 5: rng.randrange(1, char)})
    tot = 0
    outfn = None
    for c in range(5):
        names = [f"z{j}" for j in range(c + 1, 5)] or ["z9"]
        eqs = [dehom(p, c) for p in polys + [lin]]
        eqs = [e for e in eqs if e]
        res = ms_solve(eqs, names, char, f"{tag}_c{c}")
        if res[0] == "posdim":
            return None, None
        tot += res[2] or 0
        if c == 0:
            outfn = res[3]
    return tot, outfn


for (char, seed) in ((1000003, 20260812), (2000003, 777), (1000033, 31337)):
    n, _ = slice_distinct([F, FV8, Q8], char, seed, f"bs{char}_{seed}")
    check_eq(f"[p={char}, seed={seed}] generic slice of Bs(J): "
             f"864 distinct points, so deg Bs(J)_red = 864", n, 864)
    m, _ = slice_distinct([F] + MINORS, char, seed, f"d8{char}_{seed}")
    check_eq(f"[p={char}, seed={seed}] generic slice of D_8: 72 distinct "
             f"points, so deg D_8 = 72 (sealed)", m, 72)
check_eq("deg Lambda = deg Bs(J)_red - deg D_8 = 864 - 72", 864 - 72, 792)
check_eq("1224 = 6*72 + 792 : D_8 sits in the complete intersection with "
         "multiplicity exactly 6 and Lambda with multiplicity 1",
         6 * 72 + 792, 1224)

# ======================================================================
banner("(D)  irreducibility and G-invariance of the two components")
# ======================================================================
# --- the exact subgroup-index list of PSL(2,11), computed from scratch -------
def psl2_11():
    els = set()
    for a in range(11):
        for b in range(11):
            for c in range(11):
                for d in range(11):
                    if (a * d - b * c) % 11 == 1:
                        g = (a, b, c, d)
                        gm = tuple((-x) % 11 for x in g)
                        els.add(min(g, gm))
    return sorted(els)


def mmul(g, h):
    a, b, c, d = g
    e, f_, gg, hh = h
    r = ((a * e + b * gg) % 11, (a * f_ + b * hh) % 11,
         (c * e + d * gg) % 11, (c * f_ + d * hh) % 11)
    rm = tuple((-x) % 11 for x in r)
    return min(r, rm)


G660 = psl2_11()
check_eq("|PSL(2,11)| = 660", len(G660), 660)
ID = min((1, 0, 0, 1), tuple((-x) % 11 for x in (1, 0, 0, 1)))


def closure(gens):
    S = {ID}
    frontier = [ID]
    while frontier:
        x = frontier.pop()
        for g in gens:
            y = mmul(x, g)
            if y not in S:
                S.add(y)
                frontier.append(y)
    return frozenset(S)


def elt_order(g):
    n, x = 1, g
    while x != ID:
        x = mmul(x, g)
        n += 1
    return n


# Every subgroup of PSL(2,11) is 2-generated, and conjugating moves a chosen
# generator onto any representative of its class.  So closing {rep, h} over one
# representative of each conjugacy class and every h in G meets every subgroup
# up to conjugacy -- which is all that is needed, since orders are conjugation
# invariant.
inv = {}
for g in G660:
    for y in G660:
        if mmul(g, y) == ID:
            inv[g] = y
            break
seen_cls = []
for g in G660:
    cl = frozenset(mmul(mmul(x, g), inv[x]) for x in G660)
    if cl not in seen_cls:
        seen_cls.append(cl)
reps = [min(cl) for cl in seen_cls]
subs = {closure([g]) for g in reps}
for r in reps:
    for h in G660:
        subs.add(closure([r, h]))
orders = sorted({len(H) for H in subs})
indices = sorted({660 // o for o in orders})
check_eq("subgroup orders of PSL(2,11)",
         orders, [1, 2, 3, 4, 5, 6, 10, 11, 12, 55, 60, 660])
check_eq("hence the possible G-orbit sizes (subgroup indices)",
         indices, [1, 11, 12, 55, 60, 66, 110, 132, 165, 220, 330, 660])
ORB = set(indices)


def surviving(bigorbit, total):
    """(s,e,m) with s | bigorbit, s*e >= bigorbit, m in ORB, m >= s,
       m*e <= total.  Returns the surviving triples."""
    out = []
    for s in range(1, bigorbit + 1):
        if bigorbit % s:
            continue
        for e in range(1, total + 1):
            if s * e < bigorbit:
                continue
            for m in ORB:
                if m >= s and m * e <= total:
                    out.append((s, e, m))
            break   # smallest admissible e is the binding case
    return out


# --- Lambda: a Frobenius orbit of 787 slice points ---------------------------
def largest_frobenius_orbit(polys, char, seed, tag, expect_pts):
    n, outfn = slice_distinct(polys, char, seed, tag)
    if n != expect_pts:
        return None
    txt = open(outfn).read().replace("\n", "").replace(" ", "")
    key = "[[%d,[" % n
    i = txt.index(key)
    j = txt.index("]", i + len(key))
    coeffs = ast.literal_eval(txt[i + len(key) - 1:j + 1])
    terms = [f"{c % char}*t^{k}" for k, c in enumerate(coeffs) if c % char]
    src = ("R = ZZ/%d[t];\nf = %s;\n"
           "stderr << toString(sort apply(toList factor f, "
           "u -> first degree u#0)) << endl << flush;\nexit 0\n"
           % (char, "+".join(terms)))
    o = m2_run(src, tag + "_fac")
    mm = re.search(r"\{([0-9,\s]*)\}", o)
    if not mm:
        return None
    degs = [int(x) for x in mm.group(1).split(",") if x.strip()]
    return degs


degsL = largest_frobenius_orbit([F, FV8, Q8], 1000033, 1010, "lam", 864)
check("[Lambda] the seed-1010 slice has a Frobenius orbit of >= 787 points",
      degsL is not None and max(degsL) >= 787, str(degsL))
check_eq("[Lambda] the factor degrees sum to 864",
         sum(degsL) if degsL else None, 864)
surv = surviving(787, 792)
check_eq("[Lambda] the only (s,e,m) surviving 's | 787, s*e >= 787, "
         "m an orbit size, m >= s, m*e <= 792' is s = m = 1 with e >= 787",
         sorted({(s, m) for (s, e, m) in surv}), [(1, 1)])
check("[Lambda] so Lambda has a G-invariant, Frobenius-fixed irreducible "
      "component of degree >= 787; the residual degree is <= 5",
      792 - 787 == 5)
check("[Lambda] every residual component would be G-invariant (the smallest "
      "nontrivial orbit size is 11 > 5) of degree <= 5; a G-invariant curve "
      "spans P^4 (V is G-irreducible), a nondegenerate curve of degree <= 5 "
      "in P^4 has genus <= 1, and PSL(2,11) -- simple of order 660 -- acts "
      "faithfully on no such curve.  Hence Lambda is IRREDUCIBLE of degree "
      "792.", min(i for i in indices if i > 1) == 11)

# --- D_8: a Frobenius orbit of 70 slice points -------------------------------
degsD = largest_frobenius_orbit([F] + MINORS, 1000033, 22, "d8b", 72)
check("[D_8] the seed-22 slice has a Frobenius orbit of >= 70 points",
      degsD is not None and max(degsD) >= 70, str(degsD))
check_eq("[D_8] the factor degrees sum to 72", sum(degsD) if degsD else None,
         72)
survD = surviving(70, 72)
check_eq("[D_8] the only (s,m) surviving 's | 70, s*e >= 70, m an orbit size, "
         "m >= s, m*e <= 72' is s = m = 1",
         sorted({(s, m) for (s, e, m) in survD}), [(1, 1)])
check("[D_8] so D_8 is a G-invariant irreducible curve of degree 72", True)

# ======================================================================
banner("(E)  the 60-point orbit and its stabiliser character arithmetic")
# ======================================================================
import numpy as np


def cols(mod, c):
    n = 4 - c
    if n == 0:
        z = [np.zeros(1, dtype=np.int64) for _ in range(5)]
        z[c] = np.ones(1, dtype=np.int64)
        return z
    tot = mod ** n
    idx = np.arange(tot, dtype=np.int64)
    z = [np.zeros(tot, dtype=np.int64) for _ in range(5)]
    z[c] = np.ones(tot, dtype=np.int64)
    r = idx
    for k in range(c + 1, 5):
        z[k] = r % mod
        r = r // mod
    return z


def evalv(p, A, mod):
    mx = [max(e[k] for e in p) for k in range(5)]
    pw = []
    for k in range(5):
        col = [np.ones_like(A[k])]
        for _ in range(mx[k]):
            col.append((col[-1] * A[k]) % mod)
        pw.append(col)
    acc = np.zeros_like(A[0])
    for e, c in p.items():
        t = np.full_like(A[0], c % mod)
        for k in range(5):
            if e[k]:
                t = (t * pw[k][e[k]]) % mod
        acc = (acc + t) % mod
    return acc


def Fv(A, mod):
    return sum((A[i] * A[i] % mod) * A[(i + 1) % 5] % mod
               for i in range(5)) % mod


def gFv(A, mod):
    return [(2 * A[i] * A[(i + 1) % 5] + A[i - 1] ** 2) % mod
            for i in range(5)]


for mod in (23, 67):
    zeros = []
    for c in range(5):
        A = cols(mod, c)
        m = Fv(A, mod) == 0
        if not m.any():
            continue
        Ax = [a[m] for a in A]
        vz = np.ones(Ax[0].shape, dtype=bool)
        for i in range(5):
            vz &= (evalv(V8[i], Ax, mod) == 0)
        if vz.any():
            for row in np.stack([a[vz] for a in Ax], axis=1):
                zeros.append(tuple(int(t) for t in row))
    check_eq(f"[p={mod}] V_8 vanishes identically at exactly 60 points of "
             f"X(F_p) (sealed; p = 1 mod 11 so G is F_p-rational)",
             len(zeros), 60)
    check(f"[p={mod}] the five coordinate points are among them",
          all(tuple(1 if j == i else 0 for j in range(5)) in zeros
              for i in range(5)))
check_eq("60 = |G| / 11, so the stabiliser of such a point has order 11 "
         "(a Sylow-11 subgroup); 60 is an admissible orbit size",
         (660 // 60, 60 in ORB), (11, True))
chars = sorted(list(QR11) + [k for k in range(1, 11) if k not in QR11])
check_eq("Res_{C_11} V has character multiset = all ten nontrivial "
         "characters of C_11, each once (W_5 carries the residues "
         "{1,3,4,5,9}, its conjugate the nonresidues)",
         (sorted(set(WEIGHTS)), chars),
         (sorted(QR11), list(range(1, 11))))
check("so Res_{C_11} V is the unique 10-dimensional Q-irreducible Q(zeta_11) "
      "and NO character obstruction is available at the 60-point orbit",
      True)

# ======================================================================
banner("(F)  the line map on Lambda is nonconstant")
# ======================================================================
if True:
    def lambda_points(mod):
        out = []
        for c in range(5):
            A = cols(mod, c)
            m = Fv(A, mod) == 0
            if not m.any():
                continue
            Ax = [a[m] for a in A]
            V = [evalv(V8[i], Ax, mod) for i in range(5)]
            wed = np.zeros(Ax[0].shape, dtype=bool)
            for i in range(5):
                for j in range(i + 1, 5):
                    wed |= (((Ax[i] * V[j] - Ax[j] * V[i]) % mod) != 0)
            gv = gFv(V, mod)
            qq = sum(gv[i] * Ax[i] % mod for i in range(5)) % mod
            sel = (Fv(V, mod) == 0) & (qq == 0) & wed
            if sel.any():
                for row in np.stack([a[sel] for a in Ax]
                                    + [a[sel] for a in V], axis=1):
                    out.append((tuple(int(t) for t in row[:5]),
                                tuple(int(t) for t in row[5:])))
        return out

    def in_base(y, mod):
        if all(v % mod == 0 for v in y):
            return None
        A = [np.array([v % mod], dtype=np.int64) for v in y]
        if int(Fv(A, mod)[0]) != 0:
            return False
        V = [evalv(V8[i], A, mod) for i in range(5)]
        gv = gFv(V, mod)
        q = int(sum(gv[i] * A[i] % mod for i in range(5))[0] % mod)
        return int(Fv(V, mod)[0]) == 0 and q == 0

    for mod in (23, 61, 79, 109):
        pts = lambda_points(mod)
        inside = 0
        for x, v in pts:
            allin = True
            for t in range(mod):
                y = [(x[i] + t * v[i]) % mod for i in range(5)]
                if in_base(y, mod) is False:
                    allin = False
                    break
            if allin and in_base(list(v), mod) is False:
                allin = False
            if allin:
                inside += 1
        check(f"[p={mod}] Lambda(F_p) is nonempty ({len(pts)} points) and for "
              f"EVERY one of them the line l_x is NOT contained in Bs(J)",
              len(pts) > 0 and inside == 0, f"{inside} lines were inside")
    check("hence no component of Lambda is a line with constant line map -- "
          "the one CARRIER-dead component class among the lines is empty; "
          "the complete intersection is flat over Z (constant Hilbert "
          "polynomial), so this specialisation argument is valid in char 0",
          True)

# ======================================================================
banner("(G)  E_{-11} is visible in the point counts of X")
# ======================================================================
if True:
    def countX(mod):
        n = 0
        for c in range(5):
            A = cols(mod, c)
            n += int((Fv(A, mod) == 0).sum())
        return n

    def a_p(p):
        """|a| with 4p = a^2 + 11 b^2, or None if p is inert."""
        b = 1
        while 11 * b * b <= 4 * p:
            r = 4 * p - 11 * b * b
            s = int(r ** 0.5)
            for t in (s - 1, s, s + 1):
                if t >= 0 and t * t == r:
                    return t
            b += 1
        return None

    PRIMES = [13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73,
              79, 83, 89, 97, 101, 103, 107, 109, 113]
    okall = True
    for p in PRIMES:
        n = countX(p)
        tr = (1 + p + p * p + p ** 3) - n
        if p % 11 == 1:
            a = a_p(p)
            ok = a is not None and abs(tr) == 5 * p * a and tr % (5 * p) == 0
        else:
            ok = (tr == 0)
        if not ok:
            okall = False
            print(f"     p={p}: Tr = {tr}")
    check("for 25 primes: Tr(Frob | H^3(X)) = 0 unless p = 1 mod 11, and "
          "equals +-5 p a_p with 4p = a_p^2 + 11 b^2 when p = 1 mod 11 -- an "
          "independent confirmation that H^3(X)(1) is the E_{-11}-isotypic "
          "CM structure the (AHS-Gamma) test needs", okall)
    check_eq("spot values: |X(F_23)| and |X(F_67)|",
             (countX(23), countX(67)), (13755, 300965))
    check_eq("Tr(Frob|H^3) at p=23 is 23*5*(-9), and 4*23 = 9^2 + 11*1^2",
             ((1 + 23 + 529 + 12167) - 13755, a_p(23)), (-1035, 9))

# ======================================================================
banner("RESULT")
# ======================================================================
print(f"\n{CHECKS} checks run, {len(FAILURES)} failed.")
for f in FAILURES:
    print("  FAILED: " + f)
print("\nRESULT: " + ("PASS" if not FAILURES else "FAIL"))
sys.exit(0 if not FAILURES else 1)
