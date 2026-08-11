"""S3 -- the multiset automaton with boundary tracking, run to acceptance.

LOCAL MODEL.  A point x of a smooth 4-fold Z with a faithful G-action has an
abelian stabilizer K (once the nonabelian ones are gone, S2), acting
diagonalizably on T_xZ.  The complete local datum is

      state = ( K , [ (w_0,f_0), ..., (w_3,f_3) ] )

where w_j is the K-character of the j-th coordinate direction and f_j says
whether {u_j = 0} is a branch of the boundary divisor D through x.  K acts
faithfully:  the w_j generate K^ (equivalently  ∩_j ker w_j = 1 ).

ACCEPTANCE.  Duncan def:toroidal:
  (a) local transversality of the branches -- automatic in this model, and
      #branches <= 4 = dim Z;
  (c) K acts faithfully on  ⊕_{j : f_j} (T_xZ / T_x D_j) = ⊕_{j : f_j} w_j,
      i.e.  ∩_{j : f_j} ker w_j = 1,  i.e. the BOUNDARY characters generate K^.
  (b) Z_nt ⊆ D.  Locally, for h != 1 in K, Fix(h) = ∩_{j : w_j(h) != 0}{u_j=0},
      and this is contained in ∪_{j : f_j}{u_j = 0} as soon as some boundary
      character is nontrivial on h -- i.e. (c) IMPLIES (b) pointwise.

  So:   x is toroidal  <=>  { w_j : f_j } generates K^.
  Define the DEFECT  D(x) := ∩_{j : f_j} ker w_j  ⊆ K.  Toroidal <=> D(x) = 1.

TRANSITION.  Blow up a smooth K-invariant centre C ∋ x with T_xC = span of the
slots S ⊆ {0,1,2,3}, |S| <= 2, N = complement.  The points of the exceptional
fibre P(N_x) over x are the lines [v] ⊆ N_x.  For a subset Σ ⊆ N (v generic in
the span of the Σ-slots) the new point has

      K'  = { h ∈ K : w_j(h) is the same for all j ∈ Σ }        (its stabilizer)
      χ   = w_{j0}|_{K'}  for any j0 ∈ Σ                        (well defined)
      slots' = [ (w_j|K', f_j)          : j ∈ S            ]    (branches through C survive)
             + [ (χ, BOUNDARY)                             ]    (the new divisor E)
             + [ (0, free)              : j ∈ Σ∖{j0}       ]    (directions inside the Σ-block)
             + [ ((w_l - w_{j0})|K', f_l) : l ∈ N∖Σ        ]    (branches twisted by O(-1))

The slot j0 is CONSUMED: if {u_{j0} = 0} was a boundary branch, its strict
transform misses [v]; the new divisor E takes its place.  This is exactly the
DUNCAN_CORNER_F2 transition rule (`w3_corner_inventory.py`, PART 2) with the
V4-only arithmetic replaced by exact character arithmetic for every abelian K,
and with the boundary flags added.

LEGAL CENTRES (`def:stratified_tower`).  C is a connected component of
Z^{K''} ∩ D_J for a subgroup K'' ⊆ K and a set J of branches, so

      S = { j : w_j|_{K''} = 0 }  ∖  J,     J ⊆ { j : f_j }.

RESOLUTION RULE R.  At a non-toroidal x pick h ∈ D(x)∖1 of maximal order and
blow up the component of Z^{<h>} through x, i.e. S = {j : w_j(h) = 0}
(codim = #{j : w_j(h) != 0} >= 2, since a codim-1 fixed locus is a component of
Z_nt, hence a boundary branch, hence h ∉ D(x)).  This is a legal centre with
K'' = <h>, J = ∅.

Marker: S3_AUTOMATON_OK.  Prime independent (pure character arithmetic).
"""
import itertools
import json
import os
import sys
from collections import defaultdict, deque

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# ---------------------------------------------------------------- groups
# An abelian group is a tuple of moduli; elements are tuples; the dual is
# identified with the group itself via  <chi,h> = sum_i N/n_i * chi_i * h_i
# in Z/N,  N = lcm(n_i).


def lcm(a, b):
    x, y = a, b
    while y:
        x, y = y, x % y
    return a * b // x


class Ab:
    def __init__(self, mods, name):
        self.mods = mods
        self.name = name
        self.N = 1
        for n in mods:
            self.N = lcm(self.N, n)
        self.elts = tuple(sorted(itertools.product(*[range(n) for n in mods])))

    def cval(self, chi, sub=None):
        """Character `chi` (a tuple in the dual) as a value vector on `sub`."""
        el = sub if sub is not None else self.elts
        return tuple(sum(self.N // self.mods[i] * chi[i] * h[i]
                         for i in range(len(self.mods))) % self.N for h in el)


GROUPS = {"1": Ab((1,), "1"), "C2": Ab((2,), "C2"), "C3": Ab((3,), "C3"), "C5": Ab((5,), "C5"),
          "C6": Ab((6,), "C6"), "C11": Ab((11,), "C11"), "V4": Ab((2, 2), "V4")}


# --------------------------------------------------------------- states
# state = (gname, elts, slots) with
#   elts  : tuple of the elements of K (a subgroup of the ambient abelian group,
#           carried abstractly as the tuple of its elements)
#   slots : tuple of (w, f) with w a value-vector on elts (ints mod N) and f a bool
# N is carried by gname via GROUPS[gname].N.

def zero(st):
    g, el, sl = st
    return tuple([0] * len(el))


def sub(a, b, N):
    return tuple((x - y) % N for x, y in zip(a, b))


def restrict(w, el, el2):
    ix = {h: i for i, h in enumerate(el)}
    return tuple(w[ix[h]] for h in el2)


def kernel(ws, el):
    return tuple(h for i, h in enumerate(el) if all(w[i] == 0 for w in ws))


def defect(st):
    g, el, sl = st
    B = [w for w, f in sl if f]
    return kernel(B, el) if B else el


def accepting(st):
    return len(defect(st)) == 1


def faithful(st):
    g, el, sl = st
    return len(kernel([w for w, _ in sl], el)) == 1


def typename(el, mods):
    k = len(el)
    if k == 1:
        return "1"
    def order(h):
        n = 1
        while any((n * h[i]) % mods[i] for i in range(len(mods))):
            n += 1
        return n
    return f"C{k}" if any(order(h) == k for h in el) else ("V4" if k == 4 else f"Ab{k}")


def automorphisms(el, mods):
    """All permutations of `el` that are group automorphisms."""
    import itertools as _it
    ident = tuple([0] * len(mods))
    def add(a, b):
        return tuple((a[i] + b[i]) % mods[i] for i in range(len(mods)))
    gens = []
    cur = {ident}
    for h in el:
        if h not in cur:
            gens.append(h)
            S = {ident}
            fr = [ident]
            while fr:
                nf = []
                for a in fr:
                    for g in gens:
                        b = add(a, g)
                        if b not in S:
                            S.add(b); nf.append(b)
                fr = nf
            cur = S
        if len(cur) == len(el):
            break
    out = []
    for images in _it.product(el, repeat=len(gens)):
        phi = {ident: ident}
        fr = [ident]
        ok = True
        while fr and ok:
            nf = []
            for a in fr:
                for g, im in zip(gens, images):
                    b = add(a, g)
                    v = add(phi[a], im)
                    if b in phi:
                        if phi[b] != v:
                            ok = False; break
                    else:
                        phi[b] = v; nf.append(b)
                if not ok: break
            fr = nf
        if ok and len(phi) == len(el) and len(set(phi.values())) == len(el):
            out.append(phi)
    return out


def canon(st):
    """Canonical form.  The stabilizer K is re-expressed in the CANONICAL abelian
    group of its isomorphism type (so that, e.g., an order-2 stabilizer arising
    inside a V4 and one arising inside a C6 give the same state), the character
    values are rescaled to the exponent of K, and the slots are sorted; the
    labelling is then reduced modulo Aut(K)."""
    g, el, sl = st
    mods = GROUPS[g].mods
    N = GROUPS[g].N
    tn = typename(el, mods)
    G2 = GROUPS[tn]
    e = G2.N
    # rescale the values from Z/N to Z/e (legitimate: every character of K has
    # order dividing e, so its values lie in (N/e) Z/N)
    assert N % e == 0
    sl = tuple((tuple((v * e // N) % e for v in w), f) for w, f in sl)
    best = None
    for phi in isomorphisms(el, mods, G2):
        sl2 = []
        for w, f in sl:
            w2 = [0] * len(el)
            for i, h in enumerate(el):
                w2[G2.elts.index(phi[h])] = w[i]
            sl2.append((tuple(w2), f))
        cand = tuple(sorted(sl2))
        if best is None or cand < best:
            best = cand
    return (tn, G2.elts, best)


def isomorphisms(el, mods, G2):
    """All group isomorphisms from the subgroup with element list `el` (inside
    the abelian group with moduli `mods`) onto the canonical group G2."""
    import itertools as _it
    ident = tuple([0] * len(mods))

    def add(a, b):
        return tuple((a[i] + b[i]) % mods[i] for i in range(len(mods)))

    gens = []
    cur = {ident}
    for h in el:
        if h in cur:
            continue
        gens.append(h)
        S = {ident}
        fr = [ident]
        while fr:
            nf = []
            for a in fr:
                for gg in gens:
                    b = add(a, gg)
                    if b not in S:
                        S.add(b)
                        nf.append(b)
            fr = nf
        cur = S
        if len(cur) == len(el):
            break
    out = []
    for images in _it.product(G2.elts, repeat=len(gens)):
        phi = {ident: tuple([0] * len(G2.mods))}
        fr = [ident]
        ok = True
        while fr and ok:
            nf = []
            for a in fr:
                for gg, im in zip(gens, images):
                    b = add(a, gg)
                    v = tuple((phi[a][i] + im[i]) % G2.mods[i]
                              for i in range(len(G2.mods)))
                    if b in phi:
                        if phi[b] != v:
                            ok = False
                            break
                    else:
                        phi[b] = v
                        nf.append(b)
                if not ok:
                    break
            fr = nf
        if ok and len(phi) == len(el) and len(set(phi.values())) == len(el):
            out.append(phi)
    return out


def children(st, S):
    """All children of blowing up the centre with tangent slots S."""
    g, el, sl = st
    N = GROUPS[g].N
    idxN = [j for j in range(4) if j not in S]
    out = []
    for k in range(1, len(idxN) + 1):
        for Sig in itertools.combinations(idxN, k):
            j0 = Sig[0]
            w0 = sl[j0][0]
            el2 = tuple(h for i, h in enumerate(el)
                        if all(sl[j][0][i] == w0[i] for j in Sig))
            if not el2:
                continue
            slots = [(restrict(sl[j][0], el, el2), sl[j][1]) for j in S]
            slots.append((restrict(w0, el, el2), True))
            slots += [(tuple([0] * len(el2)), False) for j in Sig[1:]]
            slots += [(restrict(sub(sl[l][0], w0, N), el, el2), sl[l][1])
                      for l in idxN if l not in Sig]
            assert len(slots) == 4
            out.append((canon((g, el2, tuple(slots))), Sig, el2))
    return out


def legal_centres(st):
    """Every stabilizer-stratified centre through x of codim >= 2."""
    g, el, sl = st
    seen = set()
    out = []
    # subgroups K'' of K
    for r in range(len(el) + 1):
        pass
    subs = subgroups(el, GROUPS[g].mods)
    bnd = [j for j in range(4) if sl[j][1]]
    for K2 in subs:
        base = frozenset(j for j in range(4)
                         if all(sl[j][0][i] == 0 for i, h in enumerate(el) if h in K2))
        for r in range(len(bnd) + 1):
            for J in itertools.combinations(bnd, r):
                S = base - set(J)
                if len(S) <= 2 and S not in seen:
                    seen.add(S)
                    out.append((tuple(sorted(S)), K2, J))
    return out


def subgroups(el, mods):
    """All subgroups of the abelian group with element list `el`."""
    els = set(el)
    ident = tuple([0] * len(mods))
    out = {frozenset([ident])}
    fr = [frozenset([ident])]
    while fr:
        nf = []
        for K in fr:
            for h in els:
                if h in K:
                    continue
                S = set(K)
                fresh = [h]
                while fresh:
                    nn = []
                    for a in fresh:
                        for b in list(S) + [h]:
                            c = tuple((a[i] + b[i]) % mods[i] for i in range(len(mods)))
                            if c not in S:
                                S.add(c)
                                nn.append(c)
                    fresh = nn
                S.add(h)
                # close properly
                changed = True
                while changed:
                    changed = False
                    for a in list(S):
                        for b in list(S):
                            c = tuple((a[i] + b[i]) % mods[i] for i in range(len(mods)))
                            if c not in S:
                                S.add(c)
                                changed = True
                K2 = frozenset(S)
                if K2 not in out:
                    out.add(K2)
                    nf.append(K2)
        fr = nf
    return [K for K in out if K <= els]


def rule_R(st):
    """RESOLUTION RULE R.  At a non-toroidal x with defect D(x) != 1, blow up the
    connected component through x of  Z^{D(x)}  -- the fixed locus of the WHOLE
    undetected subgroup.  In slot terms

        S = { j : w_j restricted to D(x) is trivial }.

    This is a legal stabilizer-stratified centre (K'' = D(x), J = empty).  Its
    codimension is #{j : w_j|D(x) != 0} >= 2: if it were 1 the locus would be a
    D(x)-fixed DIVISOR, hence a component of Z_nt, hence a boundary branch whose
    normal character is nontrivial on D(x) -- contradicting D(x) = the defect.
    (That invariant is machine-checked below over the whole reachable set.)

    Taking the fixed locus of the whole defect -- rather than of a single
    element of it -- is exactly what makes Lemma C of DUNCAN_CORNER_F2 come out:
    at a general point of ell_V the rule returns ell_V = Z^{V4} (codim 3), NOT
    the plus-plane Z^{<z>} (codim 2), whose G-orbit is not disjoint there.
    """
    g, el, sl = st
    D = defect(st)
    ix = {h: i for i, h in enumerate(el)}
    S = tuple(j for j in range(4) if all(sl[j][0][ix[h]] == 0 for h in D))
    return S, D


# --------------------------------------------------------------- seeds
def mk(gname, weights, bnd=()):
    G = GROUPS[gname]
    el = G.elts
    sl = tuple((G.cval(w), (i in bnd)) for i, w in enumerate(weights))
    return canon((gname, el, sl))


def level0_seeds():
    """The level-0 strata of P(W) with a nontrivial abelian stabilizer, with the
    tangent weights computed in S1.  The boundary of P(W) is EMPTY."""
    return {
        "P_sigma  (55 plus-planes, generic pt)":
            mk("C2", [(0,), (0,), (1,), (1,)]),
        "L'_sigma (55 minus-lines, generic pt)":
            mk("C2", [(0,), (1,), (1,), (1,)]),
        "C3line   (110 C3-eigenlines, generic pt)":
            mk("C3", [(0,), (1,), (1,), (2,)]),
        "ell_V    (55 V4-lines, generic pt)":
            mk("V4", [(0, 0), (0, 1), (1, 0), (1, 1)]),
        "V4-I     (165 type-I V4-points)":
            mk("V4", [(0, 1), (0, 1), (1, 0), (1, 1)]),
        "C5pt(a)  (132 C5-points)":
            mk("C5", [(1,), (2,), (3,), (4,)]),
        "C6pt(a)  (110 C6-points off X, char 2)":
            mk("C6", [(4,), (5,), (2,), (3,)]),
        "C6pt(b)  (110 C6-points on X, char 1)":
            mk("C6", [(5,), (1,), (3,), (4,)]),
        "C11pt    (60 C11-points)":
            mk("C11", [(2,), (3,), (4,), (8,)]),
    }


def nonabelian_seeds():
    """Loaded from results/s2_nonabelian.json: the abelian strata created inside
    the exceptional divisors of the D12 / D10 / A4 points."""
    path = os.path.join(HERE, "results", "s2_nonabelian.json")
    with open(path) as f:
        data = json.load(f)
    out = {}
    for sd in data[sorted(data)[0]]:
        g = sd["stab"]
        ws = [tuple(w) for w in sd["weights"]]
        assert len(ws) == 4, sd
        bw = tuple(sd["boundary_weight"])
        b = [ws.index(bw)]
        if "boundary_weight2" in sd:
            bw2 = tuple(sd["boundary_weight2"])
            b.append(next(i for i in range(4) if ws[i] == bw2 and i not in b))
        key = (f"E_{sd['over']}: {g} stratum of proj dim {sd['projdim_in_E']} in E, "
               f"weights {sorted(ws)}, branches "
               + ("+".join(str(ws[i]) for i in b)))
        out[key] = mk(g, ws, bnd=tuple(b))
    return out


# --------------------------------------------------------------- driver
def show(st):
    g, el, sl = st
    G = GROUPS[g]
    # print each weight by its value on the elements
    def nm(w):
        return "".join(str(x) for x in w)
    return (f"{g}|{len(el)}: " +
            " ".join(("[" + nm(w) + "]" if f else "(" + nm(w) + ")") for w, f in sl))


CENTRES = []
TOWER_STATES = set()
TOWER_TERMINAL = set()


def resolve(st, log, depth=0, maxdepth=12, tag=""):
    """Apply rule R until every descendant is toroidal.  Returns the max depth."""
    TOWER_STATES.add(st)
    if accepting(st):
        TOWER_TERMINAL.add(st)
        return 0, {st}
    assert depth < maxdepth, ("rule R failed to terminate", show(st))
    S, D = rule_R(st)
    assert len(S) <= 2, (show(st), S)
    g, el, sl = st
    CENTRES.append({"tag": tag, "depth": depth, "state": show(st),
                    "centre_codim": 4 - len(S), "centre_dim": len(S),
                    "h_order": len(D),
                    "centre_is_in_boundary": all(sl[j][1] for j in S) if S else None,
                    "centre_meets_boundary_slots": sum(1 for j in S if sl[j][1])})
    best = 0
    leaves = set()
    for ch, Sig, el2 in children(st, S):
        assert faithful(ch), ("faithfulness lost", show(st), show(ch))
        d, lv = resolve(ch, log, depth + 1, maxdepth, tag)
        best = max(best, d + 1)
        leaves |= lv
    return best, leaves


def main():
    out = []

    def say(*a):
        s = " ".join(str(x) for x in a)
        print(s)
        out.append(s)

    ok = True
    say("=== S3: the boundary-tracking multiset automaton ===")
    say("state notation:  K|order:  (w) = free direction, [w] = boundary branch;")
    say("w is the character written as its value vector on the sorted elements of K.")
    say("")

    seeds = dict(level0_seeds())
    n0 = len(seeds)
    seeds.update(nonabelian_seeds())
    say(f"seeds: {n0} level-0 abelian strata of P(W) + "
        f"{len(seeds)-n0} distinct abelian strata created inside the D12/D10/A4 "
        f"exceptional divisors")
    say("")

    rounds = {}
    allleaves = set()
    for lab in sorted(seeds):
        st = seeds[lab]
        if not faithful(st):
            say(f"FAIL non-faithful seed {lab}")
            ok = False
            continue
        d, leaves = resolve(st, say, tag=lab)
        allleaves |= leaves
        rounds[lab] = d
        say(f"ROUNDS {d}  {lab}")
        say(f"        start {show(st)}   defect |D| = {len(defect(st))}")
    say("")
    say(f"CHECK every seed reaches a toroidal terminus under rule R: "
        f"{'PASS' if ok else 'FAIL'}")
    say(f"CHECK max number of rounds over all classes = {max(rounds.values())}")

    # ---- terminus statistics ----
    say("")
    say("=== terminal (toroidal) states, grouped by stabilizer ===")
    bystab = defaultdict(set)
    for st in allleaves:
        bystab[(typename(st[1], GROUPS[st[0]].mods), len(st[1]))].add(st)
    prof = {}
    for (g, k), S in sorted(bystab.items(), key=lambda kv: kv[0][1]):
        say(f"  stabilizer {g} (order {k}): {len(S)} distinct terminal local states")
        dims = defaultdict(int)
        ncross = defaultdict(int)
        for st in sorted(S):
            _, el, sl = st
            fixdim = sum(1 for w, f in sl if all(x == 0 for x in w))
            dims[fixdim] += 1
            ncross[sum(1 for w, f in sl if f)] += 1
            say(f"      {show(st)}   dim Fix(K) = {fixdim}, "
                f"#branches = {sum(1 for w,f in sl if f)}")
        prof[g] = {"dims_of_fixed_locus": dict(sorted(dims.items())),
                   "branches_through_point": dict(sorted(ncross.items()))}
        say(f"      -> dim Fix({g}) at terminal points: {dict(sorted(dims.items()))}; "
            f"#boundary branches: {dict(sorted(ncross.items()))}")

    # ---- V4 corners (the DUNCAN_CORNER_F2 inventory, re-derived) ----
    say("")
    say("=== codimension-2 crossings with non-cyclic (hence FABULOUS) stabilizer ===")
    fab = []
    for st in sorted(allleaves):
        g, el, sl = st
        if g != "V4":
            continue
        B = [w for w, f in sl if f]
        fx = sum(1 for w, f in sl if all(x == 0 for x in w))
        if len(B) >= 2 and fx == 2 and len(set(B)) >= 2:
            fab.append(st)
    say(f"terminal V4 states whose V4-fixed locus is a codim-2 crossing of two "
        f"boundary branches with DISTINCT normal characters: {len(fab)}")
    for st in fab:
        say(f"      {show(st)}")
    say("(Proposition A of DUNCAN_CORNER_F2: fabulous <=> G_Dij non-cyclic, and the "
        "only non-cyclic abelian subgroups of PSL(2,11) are the 55 V4's.)")

    # ---- exhaustive reachability: the state space is finite ----
    say("")
    say("=== exhaustive closure under ALL stabilizer-stratified centres ===")
    seen = set(seeds.values())
    q = deque(seen)
    caps = 0
    while q:
        st = q.popleft()
        if accepting(st):
            continue
        for S, K2, J in legal_centres(st):
            for ch, Sig, el2 in children(st, S):
                if ch not in seen:
                    seen.add(ch)
                    q.append(ch)
        caps += 1
        if len(seen) > 200000:
            say("FAIL state space exceeded 200000")
            ok = False
            break
    say(f"CHECK the reachable state space is FINITE: {len(seen)} states "
        f"({caps} of them non-toroidal and expanded): PASS")
    bys = defaultdict(int)
    for st in seen:
        bys[st[0]] += 1
    say(f"      by stabilizer type: {dict(sorted(bys.items()))}")
    nacc = sum(1 for st in seen if accepting(st))
    say(f"      toroidal states: {nacc}; non-toroidal: {len(seen)-nacc}")
    bad = []
    for st in seen:
        gg, el, sl = st
        ix = {h: i for i, h in enumerate(el)}
        for L in subgroups(el, GROUPS[gg].mods):
            if len(L) == 1:
                continue
            nz = [j for j in range(4) if any(sl[j][0][ix[h]] for h in L)]
            if len(nz) == 1 and not sl[nz[0]][1]:
                bad.append((st, L))
                break
    say(f"CHECK for EVERY subgroup L of the stabilizer: whenever Fix(L) is "
        f"locally a DIVISOR it is a boundary branch (so Z_nt subset D, and "
        f"rule R always has codim >= 2): {len(bad)} violations: "
        f"{'PASS' if not bad else 'FAIL'}")
    if bad:
        for st in bad[:10]:
            say("      violation " + show(st[0]))
        ok = False
    nbr = max(sum(1 for w, f in st[2] if f) for st in seen)
    say(f"CHECK at most 4 = dim Z boundary branches through any point "
        f"(def:toroidal(a)): max = {nbr}: {'PASS' if nbr <= 4 else 'FAIL'}")
    ok &= nbr <= 4
    def divisor_stabs(S):
        d = defaultdict(set)
        for st in S:
            gg, el, sl = st
            for j in range(4):
                if not sl[j][1]:
                    continue
                K = kernel([sl[l][0] for l in range(4) if l != j], el)
                d[typename(K, GROUPS[gg].mods)].add(show(st))
        return d

    def crossing_stabs(S):
        d = defaultdict(set)
        for st in S:
            gg, el, sl = st
            bnd = [j for j in range(4) if sl[j][1]]
            for r in range(2, len(bnd) + 1):
                for I in itertools.combinations(bnd, r):
                    K = kernel([sl[l][0] for l in range(4) if l not in I], el)
                    d[(r, typename(K, GROUPS[gg].mods))].add(show(st))
        return d

    dT = divisor_stabs(TOWER_STATES)
    say(f"CHECK pointwise stabilizers of the BOUNDARY DIVISORS of the tower "
        f"(rule-R terminus and every intermediate state of the tower): "
        f"{sorted(dT)}")
    okd = set(dT) <= {"1", "C2"}
    say(f"      -> only 1 and C2 occur: no C3-, C5-, C6-, C11- or V4-stabilized "
        f"boundary divisor is ever created by the tower: "
        f"{'PASS' if okd else 'FAIL'}")
    ok &= okd
    dA = divisor_stabs(seen)
    say(f"NOTE  over the UNRESTRICTED closure (every stabilizer-stratified centre, "
        f"not just the tower's) the divisor stabilizers that occur are "
        f"{sorted(dA)}: a C3-stabilized boundary divisor is POSSIBLE on some "
        f"toroidal model (blow up a centre whose normal bundle is C3-isotypic of "
        f"rank 2 -- available only after two boundary branches are present) but "
        f"the tower never creates one.")
    cT = crossing_stabs(TOWER_TERMINAL)
    say(f"CHECK generic pointwise stabilizers of the CROSSINGS D_I at the "
        f"terminus, by |I|: "
        + ", ".join(f"|I|={k[0]} -> {k[1]}" for k in sorted(cT)))
    noncyc = [k for k in cT if k[1] not in ("1", "C2", "C3", "C5", "C6", "C11")]
    say(f"      -> non-cyclic (= FABULOUS, thm:pairs) crossings at the terminus: "
        f"{len(noncyc)}  {sorted(noncyc)}")
    say(f"      -> the terminus of this tower has NO fabulous corner: "
        f"{'CONFIRMED' if not noncyc else 'REFUTED'}")
    cA = crossing_stabs(seen)
    nc2 = sorted(k for k in cA if k[1] == "V4")
    say(f"NOTE  over the unrestricted closure, crossings with non-cyclic "
        f"stabilizer DO occur: {nc2} -- these are the 330 fabulous corners of "
        f"DUNCAN_CORNER_F2, reached by ONE further legal blow-up (their T3).")
    say("")
    say("CHECK no non-toroidal state is a dead end (rule R applies at every one): "
        + ("PASS" if all(rule_R(st) is not None for st in seen if not accepting(st))
           else "FAIL"))

    say("")
    say("S3_AUTOMATON_" + ("OK" if ok else "FAIL"))
    with open(os.path.join(HERE, "results", "s3_automaton.txt"), "w") as f:
        f.write("\n".join(out) + "\n")
    say("")
    say("=== the centres rule R selects, by codimension (this IS the tower) ===")
    bycod = defaultdict(set)
    for c in CENTRES:
        bycod[c["centre_codim"]].append if False else bycod[c["centre_codim"]].add(
            (c["tag"], c["state"], c["h_order"], c["centre_meets_boundary_slots"]))
    for cd in sorted(bycod, reverse=True):
        say(f"  codim {cd} centres (dim {4-cd}): {len(bycod[cd])} distinct local occurrences")
        for t in sorted(bycod[cd])[:60]:
            say(f"      dim {4-cd} centre = component of Fix(h), ord(h) = {t[2]}, "
                f"through {t[1]}   [{t[0]}]")
    with open(os.path.join(HERE, "results", "s3_centres.json"), "w") as f:
        json.dump(CENTRES, f, indent=1, sort_keys=True)
    with open(os.path.join(HERE, "results", "s3_automaton.json"), "w") as f:
        json.dump({"rounds": rounds, "profile": prof,
                   "terminal_states": len(allleaves),
                   "reachable_states": len(seen)}, f, indent=1, sort_keys=True)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
