"""S5 -- the terminus tables.

(a) every boundary-divisor class of the terminus, with its cyclic pointwise
    stabilizer (Lemma B), its orbit count and what it lies over;
(b) the point-stabilizer classes that occur;
(c) the new fixed strata created inside each exceptional divisor -- the
    eigen-subbundle pieces of the normal bundle, with their characters,
    dimensions, generic pointwise stabilizers and orbit counts;
(d) the per-class dimension profile of the fixed loci.

Runs at both split primes.  Marker S5_TERMINUS_OK.
"""
import json
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sfcore import Core, Rep                                # noqa: E402
from psl211 import SPLIT_PRIMES                             # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# the tower, as (stage, label, projective dim of the centre)
STAGES = [("T0", "D12pt", 0), ("T0", "A4pt", 0), ("T0", "C11pt", 0),
          ("T0", "D10pt", 0), ("T0", "C6pt", 0), ("T0", "C5pt", 0),
          ("T0", "V4-I", 0),
          ("T1", "ell_V", 1), ("T1", "C3line", 1), ("T1", "L'_sigma", 1),
          ("T2", "P_sigma", 2)]


def label_of(pname, d):
    return {("C2", 3): "P_sigma", ("C2", 2): "L'_sigma", ("C3", 2): "C3line",
            ("V4", 2): "ell_V", ("V4", 1): "V4-I", ("C5", 1): "C5pt",
            ("C6", 1): "C6pt", ("C11", 1): "C11pt", ("D10", 1): "D10pt",
            ("D12", 1): "D12pt", ("A4", 1): "A4pt"}.get((pname, d))


def run(p, say):
    ok = True
    C = Core(p)
    m = C.m
    say(f"--- p = {p} ---")

    # collect one representative of every centre class, with its orbit
    seeds = defaultdict(list)
    for H in C.subgroup_classes():
        if len(H) in (1, 660):
            continue
        for val, U in C.char_subspaces(H):
            ps = C.pstab(U)
            lab = label_of(C.name(ps), len(U))
            if lab:
                seeds[lab].append((U, ps))

    # ---------------- (a) the boundary divisors ----------------
    say("")
    say("=== (a) BOUNDARY DIVISOR CLASSES OF THE TERMINUS ===")
    say(f"{'stage':<6}{'centre':<10}{'#centres':>9}{'H_C':>6}"
        f"{'normal rep as H_C-module':>34}{'G_E':>6}{'Stab_G(E)':>11}{'#E':>6}")
    ndiv = 0
    rows = []
    seen = set()
    for stage, lab, d in STAGES:
        done = set()
        for U, ps in seeds[lab]:
            key = frozenset(m.canon([list(m.act(C.G[g], v)) for v in U])
                            for g in range(C.n))
            if key in done:
                continue
            done.add(key)
            ss = C.sstab(U)
            orb = 660 // len(ss)
            H = ps
            iso = None
            gE = "1"
            desc = "-"
            if C.is_abelian(H):
                N = C.normal_weights(H, U)
                kk = [tuple(t[i] for i in sorted(H)) for t in N]
                iso = len(set(kk)) == 1
                gE = C.name(H) if iso else "1"
                desc = ("isotypic " + C.name(H) + "-character^{+" + str(len(N)) + "}"
                        if iso else f"{len(set(kk))} distinct characters, "
                                    f"multiplicities {sorted(__import__('collections').Counter(kk).values(), reverse=True)}")
            else:
                # nonabelian: T_x is a sum of two distinct irreducibles (S2)
                desc = {"D12": "2 (+) eps.2 (two 2-dim irreps)",
                        "D10": "2_a (+) 2_b (two 2-dim irreps)",
                        "A4": "1' (+) 3"}[C.name(H)]
                gE = "1"
            rows.append((stage, lab, orb, C.name(H), desc, gE, C.name(ss)))
            say(f"{stage:<6}{lab:<10}{orb:>9}{C.name(H):>6}{desc:>34}"
                f"{gE:>6}{C.name(ss):>11}{orb:>6}")
            ndiv += orb
    say(f"TOTAL boundary divisors on the terminus: {ndiv} in {len(rows)} G-orbits")
    ok &= ndiv == 1215
    say(f"CHECK total = 1215 = 940 (T0) + 220 (T1) + 55 (T2): "
        f"{'PASS' if ndiv == 1215 else 'FAIL'}")
    c2div = sum(r[2] for r in rows if r[5] == "C2")
    say(f"CHECK boundary divisors with NONTRIVIAL pointwise stabilizer: "
        f"{c2div} in {sum(1 for r in rows if r[5] == 'C2')} orbits, all with "
        f"G_E = C2 (expect 110 in 2 orbits): "
        f"{'PASS' if c2div == 110 else 'FAIL'}")
    ok &= c2div == 110
    other = sorted(set(r[5] for r in rows) - {"1", "C2"})
    say(f"CHECK no C3-, C5-, C6-, C11- or V4-stabilized boundary divisor: "
        f"{'PASS' if not other else 'FAIL ' + str(other)}")
    ok &= not other

    # ---------------- (c) new fixed strata inside each exceptional divisor ----
    say("")
    say("=== (c) NEW FIXED STRATA CREATED INSIDE EACH EXCEPTIONAL DIVISOR ===")
    say("for a centre C with generic pointwise stabilizer H and normal bundle N,")
    say("E = P(N) and, over the generic point of C, Fix(A) cap E = P(N^{A,lam})")
    say("for each character lam of A <= H occurring in N|_A.")
    census = defaultdict(list)
    for stage, lab, d in STAGES:
        done = set()
        for U, ps in seeds[lab]:
            key = frozenset(m.canon([list(m.act(C.G[g], v)) for v in U])
                            for g in range(C.n))
            if key in done:
                continue
            done.add(key)
            H = ps
            Hl = sorted(H)
            # the normal bundle fibre as an H-representation
            v = U[0]
            j0 = next(t for t in range(5) if v[t] % p)
            lam = {}
            for i in Hl:
                w = m.act(C.G[i], v)
                lam[i] = w[j0] * m.inv(v[j0]) % p
            RW = Rep({i: C.G[i] for i in Hl}, 5, p, keys=Hl)
            NB = RW.quot_rep([list(b) for b in U]).twist(lam)
            say(f"  centre {lab:<9} (H = {C.name(H)}, dim {d}, "
                f"normal rank {NB.n}):")
            subs = _subgroups(C, H)
            shown = set()
            gU = C.sstab(U)
            for A in sorted(subs, key=len):
                if len(A) == 1 or not C.is_abelian(A):
                    continue
                ga, lch = C.linear_characters(A)
                for lams, lv in lch:
                    F = NB.fixed_space(ga, list(lams))
                    if not F:
                        continue
                    pst = frozenset(i for i in Hl if _scal(NB, i, F, p))
                    if not C.is_abelian(pst):
                        continue
                    # lift F to a subspace V of W containing U: the eigen-piece
                    # of W/U.  Its setwise stabilizer in G gives the orbit count.
                    Vsp = _lift(C, U, F, p)
                    ss2 = frozenset(g for g in gU
                                    if m.canon([list(m.act(C.G[g], b)) for b in Vsp])
                                    == m.canon(Vsp))
                    dimF = len(Vsp) - 2
                    orb = 660 // len(ss2)
                    kk = (C.name(pst), dimF, len(F), orb)
                    if kk in shown:
                        continue
                    shown.add(kk)
                    census[C.name(pst)].append((lab, dimF, orb, len(F)))
                    say(f"        Fix({C.name(pst):<4}) piece: normal eigen-piece of "
                        f"rank {len(F)} -> a locus of dim {dimF} inside E, "
                        f"setwise stab order {len(ss2)}, G-orbit size {orb}")

    # ---------------- (b)/(d) profile ----------------
    say("")
    say("=== (b)/(d) FIXED-LOCUS DIMENSION PROFILE, BY ABELIAN CLASS ===")
    for A in ("C2", "C3", "V4", "C5", "C6", "C11"):
        dd = defaultdict(int)
        for lab, dimF, orb, rk in census.get(A, []):
            dd[dimF] += orb
        say(f"  A = {A:<4} loci created inside exceptional divisors: "
            f"dim -> number of components {dict(sorted(dd.items()))}")
    say("")
    say("(the level-0 components of Fix(A) are all themselves centres of the "
        "tower, so on the terminus they have been replaced by the exceptional "
        "divisors of the table in (a); the loci listed here are the ones the "
        "tower CREATES.)")
    return ok


def _lift(C, U, F, p):
    """Lift a subspace F of W/U (in the quot_rep coordinates) back to W."""
    from sfcore import rref
    m = C.m
    B, piv = rref([list(b) for b in U], 5, p)
    free = [c for c in range(5) if c not in piv]
    rows = [list(b) for b in U]
    for f in F:
        v = [0] * 5
        for k, c in enumerate(free):
            v[c] = f[k]
        for i, c in enumerate(piv):
            v[c] = 0
        rows.append(v)
    return m.canon(rows)


def _subgroups(C, H):
    out = {frozenset([C.e])}
    fr = [frozenset([C.e])]
    while fr:
        nf = []
        for K in fr:
            for g in H:
                if g in K:
                    continue
                L = C.gen(list(K) + [g])
                if L <= H and L not in out:
                    out.add(L)
                    nf.append(L)
        fr = nf
    return out


def _scal(T, i, F, p):
    M = T.mats[i]
    c = None
    for b in F:
        w = tuple(sum(M[r][s] * b[s] for s in range(T.n)) % p for r in range(T.n))
        j = next(t for t in range(T.n) if b[t] % p)
        if w[j] % p == 0:
            return False
        cc = w[j] * pow(b[j], p - 2, p) % p
        if c is None:
            c = cc
        elif cc != c:
            return False
        if any((w[t] - c * b[t]) % p for t in range(T.n)):
            return False
    return True


def _pres(T, i, F, p):
    from sfcore import rref
    M = T.mats[i]
    R = rref([list(b) for b in F], T.n, p)[0]
    img = [[sum(M[r][s] * b[s] for s in range(T.n)) % p for r in range(T.n)]
           for b in F]
    return rref(img, T.n, p)[0] == R


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
    say("S5_TERMINUS_" + ("OK" if ok else "FAIL"))
    with open(os.path.join(HERE, "results", "s5_terminus.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    sys.exit(0 if ok else 1)
