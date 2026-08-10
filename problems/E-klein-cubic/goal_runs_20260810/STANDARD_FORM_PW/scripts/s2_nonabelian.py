"""S2 -- the three nonabelian point strata, and how many rounds each needs.

For a point x with (nonabelian) stabilizer H, Duncan `def:toroidal`(c) can never
hold: it forces G_x to be abelian.  So every nonabelian stabilizer must be
DESTROYED by the tower.  The mechanism is elementary:

  ELIMINATION LEMMA.  Let C be a smooth H-invariant centre through x with
  T_xC = S (an H-submodule) and N = T_xZ / S of rank >= 2.  The fibre of the
  exceptional divisor over x is P(N), and the points of P(N) fixed by H are
  exactly the 1-dimensional H-submodules of N.  Hence the H-fixed point at x
  is removed by this blow-up  <=>  N has NO 1-dimensional H-subrepresentation.

This script computes, for each of the three nonabelian point strata of P(W),

  * the tangent representation T_x P(W) = lam^{-1} (x) (W/lam) and its
    decomposition (via <chi_T, chi_T> and the linear-character fixed spaces);
  * every H-submodule, hence every legal centre, and which ones eliminate;
  * the stratification of the exceptional P^3 by exact pointwise stabilizer,
    together with the local state (weights + boundary flag) each stratum hands
    to the abelian automaton of S3.

Runs at both split primes.  Marker S2_NONABELIAN_OK.
"""
import json
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from sfcore import Core, Rep, rref, nullspace              # noqa: E402
from psl211 import SPLIT_PRIMES                            # noqa: E402

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

EXPECT = {
    #  H     : (constituents, #1-dim H-submodules of T, rounds needed)
    "D12": (2, 0, 1),
    "D10": (2, 0, 1),
    "A4":  (2, 1, 2),
}


def dlog(base, x, n, p):
    for k in range(n):
        if pow(base, k, p) == x:
            return k
    raise ValueError


def encode_char(C, K, val, p):
    """Character of an abelian K as a tuple of exponents w.r.t. C.generators."""
    m = C.m
    gens = C.generators(K)
    if len(K) == 4 and max(C.ordr[g] for g in K) == 2:      # V4
        z, s = gens
        return (0 if val[z] == 1 else 1, 0 if val[s] == 1 else 1), (2, 2)
    if len(K) == 1:
        return (), ()
    g = gens[0]
    n = C.ordr[g]
    zt = m._root(n)
    return (dlog(zt, val[g], n, p),), (n,)


LAST = {}


def run(p, say):
    ok = True
    C = Core(p)
    m = C.m
    reps = C.subgroup_classes()
    say(f"--- p = {p} ---")
    seeds = []
    for H in reps:
        nm = C.name(H)
        if nm not in EXPECT:
            continue
        Hl = sorted(H)
        # representation of H on W
        RW = Rep({i: C.G[i] for i in Hl}, 5, p, keys=Hl)
        for val, U in C.char_subspaces(H):
            if C.pstab(U) != H:
                continue
            v = U[0]
            T = RW.quot_rep([list(v)]).twist(val)
            assert T.n == 4
            # character of T and <chi,chi>
            chi = {i: sum(T.mats[i][k][k] for k in range(4)) % p for i in Hl}
            invmap = {i: C.inv[i] for i in Hl}
            ip = sum(chi[i] * chi[invmap[i]] for i in Hl) % p
            ip = ip * pow(len(H), p - 2, p) % p
            nconst = next(k for k in range(1, 20) if k % p == ip)
            # linear characters of H with a nonzero fixed space in T
            gens, lchars = C.linear_characters(H)
            lin = []
            for lams, lv in lchars:
                F = T.fixed_space(gens, [lv[g] for g in gens])
                if F:
                    lin.append((lams, len(F)))
            n1 = sum(d for _, d in lin)
            e_const, e_n1, e_rounds = EXPECT[nm]
            good = (nconst == e_const and n1 == e_n1)
            say(f"CHECK {nm:<4} point: T_x is a sum of {nconst} distinct irreducibles, "
                f"with {n1} one-dimensional H-submodule(s) "
                f"(expect {e_const}, {e_n1}): {'PASS' if good else 'FAIL'}")
            ok &= good

            # ---- H-submodules of T and the elimination lemma ----
            # <chi,chi> = 2 with distinct constituents  =>  the submodule lattice
            # is {0, A, B, T} with A, B the two isotypic pieces.
            pieces = []
            if n1:
                for lams, d in lin:
                    lv = dict(zip(gens, lams))
                    F = T.fixed_space(gens, list(lams))
                    pieces.append(("linear " + str(lams), F))
            # the complementary piece: kernel of the projector onto the linear part
            say(f"      submodules of T: 0, {'the 1-dim linear piece, ' if n1 else ''}"
                f"the complementary {4-n1}-dim irreducible, T  "
                f"(forced by <chi,chi> = {nconst} with distinct constituents)")
            cands = []
            cands.append(("S = 0  (blow up the point itself)", 0, 4))
            if n1:
                cands.append((f"S = the 1-dim linear piece (a curve through x)", 1, 3))
            # S = the big irreducible has codim 4-n1 <= 1 when n1 <= 1, illegal
            for lab, ds, dn in cands:
                # does N = T/S have a 1-dim H-submodule?
                if ds == 0:
                    has1 = n1 > 0
                else:
                    has1 = False   # N is the irreducible of dim 4-n1 >= 3
                say(f"      centre {lab:<48} codim {dn}: N has a 1-dim "
                    f"H-submodule = {has1}  ->  "
                    f"{'REGENERATES the H-fixed point' if has1 else 'ELIMINATES H'}")
            rounds = 1 if n1 == 0 else 2
            say(f"CHECK {nm:<4} point: rounds of blow-up until no H-fixed point "
                f"remains = {rounds} (expect {e_rounds}): "
                f"{'PASS' if rounds == e_rounds else 'FAIL'}")
            ok &= rounds == e_rounds
            if n1:
                say(f"      RIGIDITY: for {nm} the ONLY eliminating centre is a smooth "
                    f"H-invariant CURVE through x tangent to the 1-dim piece.")

            # ---- stratification of the exceptional P(T) by exact stabilizer ----
            #      (this is what seeds the abelian automaton)
            strata = {}
            for K in [frozenset(x) for x in _subgroups(C, H)]:
                kn = C.name(K)
                gk, lch = C.linear_characters(K)
                for lams, lv in lch:
                    F = T.fixed_space(gk, list(lams))
                    if not F:
                        continue
                    # exact pointwise stabilizer of P(F) in H
                    ps = frozenset(i for i in Hl if _acts_scalar(T, i, F, p))
                    key = tuple(sorted(F))
                    if key in strata and len(strata[key][0]) >= len(ps):
                        continue
                    strata[key] = (ps, F, lv)
            LAST["T"] = T; LAST["H"] = H
            say(f"      exceptional divisor E = P(T) = P^3; its strata "
                f"(by exact pointwise stabilizer):")
            for key, (ps, F, lv) in sorted(strata.items(), key=lambda kv: -len(kv[1][1])):
                if len(ps) == 1:
                    continue
                pn = C.name(ps)
                sset = frozenset(i for i in Hl if _preserves(T, i, F, p))
                say(f"        P(F) of proj dim {len(F)-1} in E: pointwise stab {pn} "
                    f"(order {len(ps)}), setwise stab in H order {len(sset)}, "
                    f"G-orbit size {660*len(orbitpts(C,H))//(len(sset)*len(H)) if False else 660//len(sset)}")
                if C.is_abelian(ps) and len(ps) > 1:
                    st = _seed_state(C, T, ps, F, p)
                    if st is not None:
                        wts, chi, mod = st
                        seeds.append({"over": nm, "stab": C.name(ps), "modulus": list(mod),
                                      "weights": [list(w) for w in wts],
                                      "boundary_weight": list(chi),
                                      "projdim_in_E": len(F) - 1})
                        LAST["T"] = T; LAST["H"] = H
                        say(f"           -> abelian seed: H={C.name(ps)} mod {mod} "
                            f"weights {sorted(wts)} with the E-branch carrying {chi}")
            if nm == "A4":
                ok &= a4_round2(C, T, H, p, say, seeds)
    return ok, seeds


def orbitpts(C, H):
    return [0]


def _subgroups(C, H):
    """All subgroups of H (as frozensets of indices)."""
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


def _acts_scalar(T, i, F, p):
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


def _preserves(T, i, F, p):
    M = T.mats[i]
    R = rref([list(b) for b in F], T.n, p)[0]
    img = []
    for b in F:
        img.append([sum(M[r][s] * b[s] for s in range(T.n)) % p for r in range(T.n)])
    return rref(img, T.n, p)[0] == R


def _seed_state2(C, T, K, F, p, S_wts):
    """As _seed_state, but for a blow-up whose centre has tangent weights S_wts
    (a list of (character-dict-on-K, is_boundary)) -- the extra slots that
    survive.  Only the quotient N = T/S is projectivised."""
    st = _seed_state(C, T, K, F, p, keep=len(S_wts))
    return st


def _seed_state(C, T, K, F, p, keep=0):
    """The local state at a generic point of P(F) inside the blow-up.

    K abelian, acting on F by the character chi.  T_y(Bl) has weights
    (F-directions: trivial) + {chi} (normal to E, the exceptional divisor)
    + {nu - chi : nu in (T|_K minus one copy of chi)} ... but careful: the
    F-directions inside E already carry trivial weight, and the whole of
    T|_K enters.  Concretely, with v in F a K-eigenvector of weight chi,

        T_y(Bl) = <v> (x) chi^{-1}  ⊕  Hom(<v>, T/<v>)
                = {chi}  ∪  {nu - chi : nu in T|_K minus one copy of chi}.
    """
    Kl = sorted(K)
    gk = C.generators(K)
    if not gk:
        return None
    # chi = character of K on F
    v = F[0]
    chi = {}
    for i in Kl:
        M = T.mats[i]
        w = tuple(sum(M[r][s] * v[s] for s in range(T.n)) % p for r in range(T.n))
        j = next(t for t in range(T.n) if v[t] % p)
        chi[i] = w[j] * pow(v[j], p - 2, p) % p
    # decompose T|_K into characters
    _, lch = C.linear_characters(K)
    wts = []
    for lams, lv in lch:
        Fk = T.fixed_space(gk, list(lams))
        for _ in range(len(Fk)):
            wts.append(lv)
    assert len(wts) == T.n
    # remove one copy of chi, twist the rest by chi^{-1}, then add {chi}
    rem = next(k for k, lv in enumerate(wts) if all(lv[i] == chi[i] for i in Kl))
    rest = wts[:rem] + wts[rem + 1:]
    enc = []
    for lv in rest:
        d = {i: lv[i] * pow(chi[i], p - 2, p) % p for i in Kl}
        e, mod = encode_char(C, K, d, p)
        enc.append(e)
    ce, mod = encode_char(C, K, chi, p)
    return tuple(sorted(enc + [ce])), ce, mod


def a4_round2(C, T, H, p, say, seeds):
    """The A4 point regenerates once (S2 elimination lemma).  Its second round
    blows up the unique A4-invariant CURVE through the residual fixed point q,
    whose tangent is the 1-dimensional linear piece -- and that direction is the
    normal direction of E_{A4}, i.e. the curve is the strict transform of ell_V.
    T_q = 1' (+) 3 with the 1'-slot carrying the E_{A4} branch; the centre is
    S = the 1'-slot, N = 3.  Enumerate the abelian strata of the fibre P(3)."""
    m = C.m
    Hl = sorted(H)
    gens, lchars = C.linear_characters(H)
    lin = None
    for lams, lv in lchars:
        Fx = T.fixed_space(gens, list(lams))
        if Fx:
            lin = (lv, Fx)
    assert lin is not None
    lv, Fx = lin
    N = T.quot_rep([list(b) for b in Fx])        # the 3-dimensional irreducible
    say("      A4 ROUND 2: blow up the A4-invariant curve through q (tangent = the "
        "1-dim piece = the E_A4 normal direction = T_q(ell_V~)); the fibre is "
        "P(3), and P(3)^{A4} is EMPTY, so the A4 stabilizer is gone.")
    nfix = 0
    for lams2, lv2 in lchars:
        if N.fixed_space(gens, list(lams2)):
            nfix += 1
    say(f"CHECK P(3) has {nfix} A4-fixed points (expect 0): "
        f"{'PASS' if nfix == 0 else 'FAIL'}")
    done = set()
    for K in [frozenset(x) for x in _subgroups(C, H)]:
        if len(K) == 1 or not C.is_abelian(K):
            continue
        gk, lch = C.linear_characters(K)
        for lams2, lv2 in lch:
            Fk = N.fixed_space(gk, list(lams2))
            if not Fk:
                continue
            ps = frozenset(i for i in Hl if _acts_scalar(N, i, Fk, p))
            if not C.is_abelian(ps):
                continue
            stt = _seed_state(C, N, ps, Fk, p)
            if stt is None:
                continue
            wts, chi, mod = stt
            # the surviving S-slot: the 1'-character restricted to ps, a BOUNDARY
            e1, mod1 = encode_char(C, ps, {i: lv[i] for i in ps}, p)
            wts3 = tuple(sorted(list(wts) + [e1]))   # 3 fibre slots + the S-slot
            key = (C.name(ps), wts3, chi, e1)
            if key in done:
                continue
            done.add(key)
            seeds.append({"over": "A4r2", "stab": C.name(ps), "modulus": list(mod),
                          "weights": [list(w) for w in wts3],
                          "boundary_weight": list(chi),
                          "boundary_weight2": list(e1),
                          "projdim_in_E": len(Fk) - 1})
            say(f"           -> abelian seed (round 2): H={C.name(ps)} mod {mod} "
                f"weights {sorted(wts3)}; branches: E_new carries {chi}, "
                f"E_A4 carries {e1}")
    return nfix == 0


if __name__ == "__main__":
    out, allseeds = [], {}

    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    ok = True
    for p in SPLIT_PRIMES:
        r, sd = run(p, say)
        ok &= r
        allseeds[str(p)] = sd
        say("")
    say("S2_NONABELIAN_" + ("OK" if ok else "FAIL"))
    with open(os.path.join(HERE, "results", "s2_nonabelian.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    with open(os.path.join(HERE, "results", "s2_nonabelian.json"), "w") as f:
        json.dump(allseeds, f, indent=1, sort_keys=True)
    sys.exit(0 if ok else 1)
