#!/usr/bin/env python3
"""FIX-B (program FIX, [E56]) -- producer.

Three durable objects for X = P(W) = P^4, G = PSL(2,11) acting by the exact
5-dimensional Weil representation:

  1. symbols.json      -- the symbol list of [P(W)] in Burn_4(G): for each of the
                          20 G-orbits of strata of F(P(W)) (FIX-A2), the triple
                          ([H]_G ; W(H,F) acting on k(F) ; beta = normal weights),
                          with the abelian/nonabelian split of the Kresch-Tschinkel
                          symbol formalism made explicit, and the refinement of the
                          nonabelian point-strata along their abelian subgroups.
  2. removability.json -- the removability audit: the enumeration of admissible
                          smooth G-stable centers among strata closures, the EXACT
                          symbol-level delta of each blowup computed from
                          theory/FIX_I_bcomplex.md Theorem 2.1 only, and the
                          rigid/removable verdict table.
  3. c11_weights.json  -- the 60 poset-isolated C11 points with their explicit
                          weight quadruples mod 11.

Input: goal_runs_after_bc93561/FIX_A2_SOURCE_COMPLEX/source_complex.json
       (the sealed, ALGEBRAIC-RECOMPUTE-verified source complex).
No other repository file is read.  Nothing outside this packet is written.

Toolchain: python3 standard library only (fractions, json, itertools, collections).
Exact arithmetic throughout in Q(zeta_330) = Q(zeta_3) (x) Q(zeta_5) (x) Q(zeta_11).
"""

import json
import os
from fractions import Fraction as Q
from itertools import product as iproduct
from collections import defaultdict

HERE = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.abspath(os.path.join(HERE, "..", ".."))
PAYLOAD = os.path.join(
    REPO, "goal_runs_after_bc93561", "FIX_A2_SOURCE_COMPLEX", "source_complex.json"
)

# ---------------------------------------------------------------------------
# 1.  Exact arithmetic in Q(zeta_330)
#
#     zeta_330 = zeta_2 * zeta_3 * zeta_5 * zeta_11 with zeta_2 = -1.
#     Basis  { zeta_3^b zeta_5^c zeta_11^d : 0<=b<2, 0<=c<4, 0<=d<10 }, 80 = phi(330).
#     Reduction rules  zeta_3^2 = -1-zeta_3,  zeta_5^4 = -(1+z+z^2+z^3),
#                      zeta_11^10 = -(1+...+zeta_11^9).
#     A field element is a dict {(b,c,d): Fraction} in reduced form (b<2,c<4,d<10).
# ---------------------------------------------------------------------------

N_CYC = 330


def _expand(idx, mod, top):
    """zeta_m^idx as a list of (exponent<top, coefficient) in the reduced basis."""
    idx %= mod
    if idx < top:
        return [(idx, 1)]
    # idx == top == mod-1 :  zeta^top = -(1 + zeta + ... + zeta^{top-1})
    assert idx == top, (idx, mod, top)
    return [(j, -1) for j in range(top)]


def cyc_monomial(k, coeff=Q(1)):
    """coeff * zeta_330^k, reduced."""
    k %= N_CYC
    a = k % 2                      # zeta_2 exponent   (165*a term)
    b = (2 * k) % 3                # zeta_3 exponent
    c = k % 5                      # zeta_5 exponent
    d = (7 * k) % 11               # zeta_11 exponent
    s = Q(coeff) * (-1 if a else 1)
    out = {}
    for bb, cb in _expand(b, 3, 2):
        for cc, cc_ in _expand(c, 5, 4):
            for dd, cd in _expand(d, 11, 10):
                key = (bb, cc, dd)
                out[key] = out.get(key, Q(0)) + s * cb * cc_ * cd
    return {k2: v for k2, v in out.items() if v}


_MONO_CACHE = {}


def mono(k):
    k %= N_CYC
    if k not in _MONO_CACHE:
        _MONO_CACHE[k] = cyc_monomial(k)
    return _MONO_CACHE[k]


def cadd(x, y):
    out = dict(x)
    for k, v in y.items():
        nv = out.get(k, Q(0)) + v
        if nv:
            out[k] = nv
        else:
            out.pop(k, None)
    return out


def cscale(x, q):
    q = Q(q)
    if q == 0:
        return {}
    return {k: v * q for k, v in x.items()}


def cmul_root(x, k, coeff=Q(1)):
    """x * coeff * zeta_330^k."""
    m = mono(k)
    out = {}
    for (b1, c1, d1), v1 in x.items():
        for (b2, c2, d2), v2 in m.items():
            for bb, cb in _expand(b1 + b2, 3, 2):
                for cc, ccf in _expand(c1 + c2, 5, 4):
                    for dd, cd in _expand(d1 + d2, 11, 10):
                        key = (bb, cc, dd)
                        nv = out.get(key, Q(0)) + v1 * v2 * cb * ccf * cd * Q(coeff)
                        if nv:
                            out[key] = nv
                        else:
                            out.pop(key, None)
    return out


CZERO = {}
CONE = mono(0)


def cis_rational_int(x):
    """Return the integer if x is a rational integer, else None."""
    if not x:
        return 0
    if set(x.keys()) != {(0, 0, 0)}:
        return None
    v = x[(0, 0, 0)]
    return int(v) if v.denominator == 1 else None


def cconj_root(k):
    return (-k) % N_CYC


def cencode(x):
    """JSON encoding: sparse basis-exponent triples with Fraction coefficients."""
    return {
        "basis": "zeta_3^b * zeta_5^c * zeta_11^d, 0<=b<2, 0<=c<4, 0<=d<10",
        "terms": sorted(
            [[b, c, d, str(v)] for (b, c, d), v in x.items()]
        ),
    }


def ckey(x):
    """Hashable canonical key of a field element."""
    return tuple(sorted((b, c, d, v.numerator, v.denominator)
                        for (b, c, d), v in x.items()))


def cstr(x):
    """Short human string (integers and simple values only)."""
    n = cis_rational_int(x)
    if n is not None:
        return str(n)
    if len(x) == 1 and list(x.values())[0] == 1:
        (b, c, d) = list(x.keys())[0]
        return "z3^%d*z5^%d*z11^%d" % (b, c, d)
    return "(%d terms)" % len(x)


# ---------------------------------------------------------------------------
# 2.  PSL(2,11)
# ---------------------------------------------------------------------------

def fcanon(m):
    m = tuple(x % 11 for x in m)
    n = tuple((-x) % 11 for x in m)
    return min(m, n)


def fmul(a, b):
    return fcanon((
        (a[0] * b[0] + a[1] * b[2]) % 11,
        (a[0] * b[1] + a[1] * b[3]) % 11,
        (a[2] * b[0] + a[3] * b[2]) % 11,
        (a[2] * b[1] + a[3] * b[3]) % 11,
    ))


def finv(a):
    # det = 1
    return fcanon((a[3], (-a[1]) % 11, (-a[2]) % 11, a[0]))


ONE = fcanon((1, 0, 0, 1))


def build_group():
    els = []
    for a, b, c, d in iproduct(range(11), repeat=4):
        if (a * d - b * c) % 11 == 1:
            els.append(fcanon((a, b, c, d)))
    els = sorted(set(els))
    assert len(els) == 660
    return els


def elt_order(g):
    n, x = 1, g
    while x != ONE:
        x = fmul(x, g)
        n += 1
    return n


def closure(gens):
    S = {ONE}
    frontier = [ONE]
    gens = list(gens)
    while frontier:
        nf = []
        for x in frontier:
            for g in gens:
                y = fmul(x, g)
                if y not in S:
                    S.add(y)
                    nf.append(y)
        frontier = nf
    return frozenset(S)


def conj(g, x):
    return fmul(fmul(g, x), finv(g))


def conj_set(g, H):
    return frozenset(conj(g, x) for x in H)


# ---------------------------------------------------------------------------
# 3.  Payload reader
# ---------------------------------------------------------------------------

def decode_field(e):
    """{'f':n,'num':[...],'den':d}  ->  element of Q(zeta_330)."""
    f, num, den = e["f"], e["num"], e["den"]
    assert N_CYC % f == 0, f
    step = N_CYC // f
    out = {}
    for i, c in enumerate(num):
        if c:
            out = cadd(out, cscale(mono(step * i), Q(int(c), int(den))))
    return out


def decode_class_values(cv):
    return [(c["element_order"], c["class_size"], decode_field(c["value"])) for c in cv]


# ---------------------------------------------------------------------------
# 4.  Small-group utilities
# ---------------------------------------------------------------------------

def all_subgroups(H):
    """All subgroups of a small group H (frozenset of PSL elements)."""
    subs = {frozenset({ONE})}
    frontier = [frozenset({ONE})]
    Hl = sorted(H)
    while frontier:
        nf = []
        for K in frontier:
            for g in Hl:
                if g in K:
                    continue
                L = closure(list(K) + [g])
                if L not in subs:
                    subs.add(L)
                    nf.append(L)
        frontier = nf
    return sorted(subs, key=lambda S: (len(S), sorted(S)))


def derived_subgroup(H):
    comms = set()
    for a in H:
        for b in H:
            comms.add(fmul(fmul(a, b), finv(fmul(b, a))))
    return closure(sorted(comms))


def abelian_basis(elts, quotient_rep):
    """Independent generators of a small abelian group given as a set of
    coset representatives with a multiplication given by quotient_rep."""
    # elts: list of canonical coset labels; quotient_rep: (mul, one, order)
    mul, one, order_of = quotient_rep
    gens = []
    span = {one}
    while len(span) < len(elts):
        best = None
        for x in elts:
            if x in span:
                continue
            o = order_of(x)
            if best is None or o > best[1]:
                best = (x, o)
        g, o = best
        # generated subgroup of g
        cyc = {one}
        y = g
        while y != one:
            cyc.add(y)
            y = mul(y, g)
        assert cyc & span == {one}, "greedy abelian decomposition failed"
        newspan = set()
        for s in span:
            for c in cyc:
                newspan.add(mul(s, c))
        assert len(newspan) == len(span) * len(cyc)
        span = newspan
        gens.append((g, o))
    return gens


def linear_characters(H):
    """All linear characters of H, as dicts {element -> exponent e mod 330}
    meaning chi(h) = zeta_330^e.  Returned with a canonical label."""
    D = derived_subgroup(H)
    # cosets of D in H
    coset_of = {}
    reps = []
    for h in sorted(H):
        if h in coset_of:
            continue
        rep = h
        reps.append(rep)
        for d in D:
            coset_of[fmul(h, d)] = rep
    # abelian quotient multiplication on reps
    def qmul(x, y):
        return coset_of[fmul(x, y)]

    qone = coset_of[ONE]

    def qorder(x):
        n, y = 1, x
        while y != qone:
            y = qmul(y, x)
            n += 1
        return n

    gens = abelian_basis(reps, (qmul, qone, qorder))
    # express every coset in terms of gens
    exps = {qone: tuple(0 for _ in gens)}
    frontier = [qone]
    while frontier:
        nf = []
        for x in frontier:
            for i, (g, o) in enumerate(gens):
                y = qmul(x, g)
                if y not in exps:
                    e = list(exps[x])
                    e[i] = (e[i] + 1) % o
                    exps[y] = tuple(e)
                    nf.append(y)
        frontier = nf
    assert len(exps) == len(reps)
    chars = []
    for key in iproduct(*[range(o) for (g, o) in gens]):
        chi = {}
        for h in H:
            r = coset_of[h]
            e = 0
            for i, (g, o) in enumerate(gens):
                e += key[i] * exps[r][i] * (N_CYC // o)
            chi[h] = e % N_CYC
        chars.append((key, chi))
    assert len(chars) == len(reps)
    return [(g, o) for (g, o) in gens], chars


def inner_product(chi_exp, classfn, H):
    """(1/|H|) sum_h conj(chi(h)) * f(h)   for chi given by exponents."""
    acc = CZERO
    for h in H:
        acc = cadd(acc, cmul_root(classfn[h], cconj_root(chi_exp[h])))
    acc = cscale(acc, Q(1, len(H)))
    n = cis_rational_int(acc)
    assert n is not None and n >= 0, ("non-integral multiplicity", acc)
    return n


# ---------------------------------------------------------------------------
# 5.  Load payload and build the ambient data
# ---------------------------------------------------------------------------

def main():
    with open(PAYLOAD) as fh:
        P = json.load(fh)

    ELS = build_group()
    ELSET = set(ELS)
    assert set(tuple(x) for x in [tuple(e) for e in ELS]) == ELSET

    # chi_W on all 660 elements, from the payload's exact class values
    cls_reps = []
    for c in P["group"]["element_conjugacy_classes"]:
        cls_reps.append((tuple(c["representative_psl"]), c["element_order"], c["size"],
                         decode_field(c["chi_W"])))
    chiW = {}
    for rep, o, size, val in cls_reps:
        orb = set()
        for g in ELS:
            orb.add(conj(g, rep))
        assert len(orb) == size, (rep, len(orb), size)
        for x in orb:
            chiW[x] = val
    assert len(chiW) == 660

    # subgroup -> G-class id, from the payload's 620 subgroups
    sub_class = {}
    for s in P["subgroups"]:
        sub_class[frozenset(tuple(e) for e in s["elements_psl"])] = s["class"]
    assert len(sub_class) == 620
    class_name = [c["name"] for c in P["subgroup_classes"]]
    # disambiguate the two S3 and the two A5 classes
    seen = defaultdict(int)
    class_label = []
    counts = defaultdict(int)
    for c in P["subgroup_classes"]:
        counts[c["name"]] += 1
    for c in P["subgroup_classes"]:
        n = c["name"]
        if counts[n] > 1:
            seen[n] += 1
            class_label.append("%s(%s)" % (n, "AB"[seen[n] - 1]))
        else:
            class_label.append(n)

    def gclass(H):
        return sub_class[frozenset(H)]

    NORM = {}

    def normalizer(H):
        H = frozenset(H)
        if H not in NORM:
            NORM[H] = frozenset(g for g in ELS if conj_set(g, H) == H)
        return NORM[H]

    # ---------------------------------------------------------------------
    # 6.  The 20 stratum orbits: rebuild (H, chi) and every decoration
    # ---------------------------------------------------------------------
    orbits = []
    for o in P["stratum_orbits"]:
        H = frozenset(tuple(e) for e in o["subgroup_elements_psl"])
        cls = o["subgroup_class"]
        abgens = [tuple(g) for g in P["subgroup_classes"][cls]["abelianization"]["generators_psl"]]
        invf = P["subgroup_classes"][cls]["abelianization"]["invariant_factors"]
        key = tuple(o["character_key"])
        gens, chars = linear_characters(H)
        # locate the payload character: it is the one whose values on abgens
        # are zeta_{invf[i]}^{key[i]}
        target = {}
        for g, n, k in zip(abgens, invf, key):
            target[g] = (k * (N_CYC // n)) % N_CYC
        cand = [ch for (_, ch) in chars if all(ch[g] == e for g, e in target.items())]
        assert len(cand) == 1, (o["label"], len(cand))
        chi = cand[0]
        dimWchi = inner_product(chi, chiW, H)
        assert dimWchi == o["delta_dim"] + 1, (o["label"], dimWchi, o["delta_dim"])
        # delta_nr as a class function on H:  nu = conj(chi)*chi_W - dim W_chi
        nu = {}
        for h in H:
            nu[h] = cadd(cmul_root(chiW[h], cconj_root(chi[h])),
                         cscale(CONE, -dimWchi))
        assert cis_rational_int(nu[ONE]) == 4 - o["delta_dim"]
        # cross-check nu against the payload's stored delta_nr class values
        pay = decode_class_values(o["delta_nr"]["character_values"])
        got = defaultdict(int)
        for h in H:
            got[(elt_order(h), ckey(nu[h]))] += 1
        want = defaultdict(int)
        for (eo, sz, val) in pay:
            want[(eo, ckey(val))] += sz
        assert got == want, ("delta_nr mismatch", o["label"])
        # residual group
        NH = normalizer(H)
        stab = frozenset(g for g in NH
                         if all(chi[conj(finv(g), h)] == chi[h] for h in H))
        assert len(stab) == o["delta_res"]["stabiliser_order"], o["label"]
        orbits.append(dict(
            oid=o["orbit_id"], label=o["label"], H=H, cls=cls, chi=chi,
            dim=o["delta_dim"], nu=nu, stab=stab, NH=NH,
            orbit_size=o["orbit_size"],
            W_name=o["delta_res"]["W_name"], W_order=o["delta_res"]["W_order"],
            ptstab=frozenset(tuple(e) for e in o["pointwise_stabiliser"]["elements_psl"]),
            ptstab_name=o["pointwise_stabiliser"]["name"],
            payload=o,
        ))
        assert len(orbits[-1]["stab"]) * orbits[-1]["orbit_size"] == 660

    print("[1/6] 20 stratum orbits rebuilt from (H,chi); delta_nr cross-check PASS")

    # ---------------------------------------------------------------------
    # 7.  Symbol machinery
    # ---------------------------------------------------------------------
    CLASS_REP = {}
    for s in P["subgroups"]:
        c = s["class"]
        if c not in CLASS_REP:
            pass
    for c, cd in enumerate(P["subgroup_classes"]):
        rid = cd["representative_subgroup_id"]
        CLASS_REP[c] = frozenset(tuple(e) for e in P["subgroups"][rid]["elements_psl"])

    def conjugator_to_rep(H):
        H = frozenset(H)
        R = CLASS_REP[gclass(H)]
        for g in ELS:
            if conj_set(g, H) == R:
                return g
        raise AssertionError("no conjugator")

    def res_character(H, chi, stab, base):
        """g |-> tr(g | (base)_chi) = (1/|H|) sum_h conj(chi(h)) base(g h).
        `base` is chi_W (for strata of P(W)) or nu (for exceptional strata)."""
        out = {}
        for g in stab:
            acc = CZERO
            for h in H:
                acc = cadd(acc, cmul_root(base[fmul(g, h)], cconj_root(chi[h])))
            out[g] = cscale(acc, Q(1, len(H)))
        return out

    _LINCHAR_CACHE = {}

    def lin_chars(K):
        K = frozenset(K)
        if K not in _LINCHAR_CACHE:
            _LINCHAR_CACHE[K] = linear_characters(K)
        return _LINCHAR_CACHE[K]

    def canonical_symbol(H, dim, nu, stab, res):
        """Conjugation-invariant canonical key of the symbol
        ( [H]_G ; W(H,F)=stab/H acting on k(F) ; beta=nu ).

        The symbol records the action of W(H,F) on the residual FUNCTION FIELD
        k(F) = k(P(W_chi)), i.e. the PROJECTIVE action.  A linear lift of it to
        W_chi is well defined only up to a linear character of Stab_{N_G(H)}(F),
        so the residual key is minimised over that twist as well as over
        N_G(H_0)-conjugacy.  beta is NOT twisted: normal weights are intrinsic."""
        c = conjugator_to_rep(H)
        H0 = conj_set(c, H)
        nu0 = {conj(c, h): v for h, v in nu.items()}
        st0 = conj_set(c, stab)
        res0 = {conj(c, g): v for g, v in res.items()}
        N0 = sorted(normalizer(H0))
        if len(H0) == 1:
            # H = 1: N_G(H) = G, Stab = G, beta is empty and res = chi_W is a
            # class function on G, so conjugation moves nothing: one n suffices.
            N0 = [ONE]
        st0s = sorted(st0)
        H0s = sorted(H0)
        nid = {h: ckey(nu0[h]) for h in H0s}
        twists = [psi for (_, psi) in lin_chars(st0)[1]]
        rid = [{g: ckey(cmul_root(res0[g], psi[g])) for g in st0s} for psi in twists]
        best = None
        for n in N0:
            ni = finv(n)
            bkey = tuple(sorted((h, nid[conj(ni, h)]) for h in H0s))
            cg = {g: conj(n, g) for g in st0s}
            skey = tuple(sorted(cg.values()))
            rbest = None
            for r in rid:
                rkey = tuple(sorted((cg[g], r[g]) for g in st0s))
                if rbest is None or rkey < rbest:
                    rbest = rkey
            cand = (dim, bkey, skey, rbest)
            if best is None or cand < best:
                best = cand
        return (class_label[gclass(H)], len(stab) // len(H)) + best

    def beta_labels(H, nu):
        """Human-readable beta.  For abelian H: multiset of linear characters as
        exponent vectors relative to an independent generating set.  For every H:
        the multiplicities of all linear characters plus the non-linear residue."""
        gens, chars = lin_chars(H)
        mults = []
        lin_total = 0
        for key, chi in chars:
            m = inner_product(chi, nu, H)
            lin_total += m
            if m:
                mults.append({"exponents": list(key), "multiplicity": m})
        total = cis_rational_int(nu[ONE])
        return {
            "generators_psl": [list(g) for (g, o) in gens],
            "generator_orders": [o for (g, o) in gens],
            "linear_characters": mults,
            "linear_part_dim": lin_total,
            "total_dim": total,
            "nonlinear_part_dim": total - lin_total,
            "beta_is_all_linear": lin_total == total,
        }

    def beta_multiset_cyclic(H, nu, gen):
        """For cyclic H=<gen> of order n: beta as a sorted multiset of residues mod n."""
        n = len(H)
        gens, chars = lin_chars(H)
        out = []
        for key, chi in chars:
            m = inner_product(chi, nu, H)
            if m:
                # exponent j with chi(gen) = zeta_n^j
                e = chi[gen]
                j = (e * n) // N_CYC
                assert (e * n) % N_CYC == 0
                out.extend([j] * m)
        return sorted(out)

    def nu_class_values(H, nu):
        # conjugacy classes of H
        cls = []
        seen = set()
        for h in sorted(H):
            if h in seen:
                continue
            o = frozenset(conj(x, h) for x in H)
            seen |= o
            cls.append((elt_order(h), len(o), sorted(o)[0]))
        cls.sort()
        return [{"element_order": eo, "class_size": sz,
                 "representative_psl": list(r), "value": cencode(nu[r])}
                for (eo, sz, r) in cls]

    def group_name(K):
        """Name a small subgroup by its G-class label when possible."""
        if frozenset(K) in sub_class:
            return class_label[sub_class[frozenset(K)]]
        return "order%d" % len(K)

    # ---- build the 20 symbols -------------------------------------------
    ABELIAN_CLASSES = set()
    for c, cd in enumerate(P["subgroup_classes"]):
        if cd["abelian"]:
            ABELIAN_CLASSES.add(c)

    symbol_records = []
    for ob in orbits:
        H, chi, nu, stab = ob["H"], ob["chi"], ob["nu"], ob["stab"]
        res = res_character(H, chi, stab, chiW)
        key = canonical_symbol(H, ob["dim"], nu, stab, res)
        ab = ob["cls"] in ABELIAN_CLASSES
        gens, chars = lin_chars(H)
        rec = {
            "orbit_id": ob["oid"],
            "fix_a2_label": ob["label"],
            "H_class": class_label[ob["cls"]],
            "H_order": len(H),
            "H_abelian": ab,
            "H_elements_psl": [list(h) for h in sorted(H)],
            "stratum": {
                "dim_F": ob["dim"],
                "F": "P^%d (linear subspace of P^4)" % ob["dim"],
                "residual_function_field": ("k" if ob["dim"] == 0
                                            else "k(%s)" % ",".join(
                                                "x%d" % i for i in range(1, ob["dim"] + 1))),
                "G_orbit_size": ob["orbit_size"],
            },
            "residual_group": {
                "W(H,F)": ob["W_name"],
                "order": ob["W_order"],
                "Stab_{N_G(H)}(F)_order": len(stab),
                "Stab_elements_psl": [list(g) for g in sorted(stab)],
                "action_on_W_chi_character": [
                    {"g_psl": list(g), "order": elt_order(g),
                     "trace_on_W_chi": cencode(res[g])} for g in sorted(stab)],
                "action_matrices_from_FIX_A2": ob["payload"]["delta_res"]["action_on_F"],
            },
            "beta": beta_labels(H, nu),
            "beta_class_values": nu_class_values(H, nu),
            "sanity_dimF_plus_beta": ob["dim"] + cis_rational_int(nu[ONE]),
            "pointwise_stabiliser": ob["ptstab_name"],
            "canonical_symbol_key": repr(key),
        }
        if ab and len(gens) == 1:
            rec["beta_residues_mod_n"] = beta_multiset_cyclic(H, nu, gens[0][0])
            rec["beta_n"] = gens[0][1]
        if not ab:
            rec["KT_note"] = ("outside the abelian-symbol subgroup; enters via "
                              "standard form")
        symbol_records.append((key, rec, ob))
        assert rec["sanity_dimF_plus_beta"] == 4

    print("[2/6] 20 symbols built; dim F + |beta| = 4 on all of them")

    # ---- the reduced isotropy stratification ----------------------------
    # 0-dimensional orbits with H = full pointwise stabiliser are the 10
    # distinct G-orbits of special points.
    POINT_ORBITS = [ob for ob in orbits
                    if ob["dim"] == 0 and ob["ptstab"] == ob["H"]]
    assert len(POINT_ORBITS) == 10, len(POINT_ORBITS)
    POS_ORBITS = [ob for ob in orbits if ob["dim"] > 0]
    assert len(POS_ORBITS) == 5

    # ---- abelian refinement of the nonabelian point-strata ---------------
    ORBIT_INDEX = {}

    def find_orbit(H, chi):
        """Locate the G-orbit of the stratum (H,chi)."""
        kk = (frozenset(H), tuple(sorted(chi.items())))
        if kk in ORBIT_INDEX:
            return ORBIT_INDEX[kk]
        cl = gclass(H)
        for ob in orbits:
            if ob["cls"] != cl:
                continue
            for g in ELS:
                if conj_set(g, H) != ob["H"]:
                    continue
                if all(chi[conj(finv(g), h)] == ob["chi"][h] for h in ob["H"]):
                    ORBIT_INDEX[kk] = ob["oid"]
                    return ob["oid"]
        raise AssertionError("stratum not located")

    refinements = []
    for ob in orbits:
        if ob["cls"] in ABELIAN_CLASSES:
            continue
        S, chiS = ob["H"], ob["chi"]
        entries = []
        subs = all_subgroups(S)
        # up to S-conjugacy
        reps, seen = [], set()
        for K in subs:
            if K in seen:
                continue
            orb = set(conj_set(g, K) for g in S)
            seen |= orb
            reps.append((K, len(orb)))
        for K, nconj in reps:
            if not sub_class.get(frozenset(K)) in ABELIAN_CLASSES:
                continue
            chiK = {h: chiS[h] for h in K}
            d = inner_product(chiK, chiW, K) - 1
            oid = find_orbit(K, chiK)
            nuK = {h: cadd(cmul_root(chiW[h], cconj_root(chiK[h])),
                           cscale(CONE, -(d + 1))) for h in K}
            gensK, _ = lin_chars(K)
            ent = {
                "A_class": class_label[gclass(K)],
                "A_order": len(K),
                "num_S_conjugates": nconj,
                "stratum_of_A_through_the_point": {
                    "dim_F_A": d,
                    "orbit_id": oid,
                    "fix_a2_label": [o2["label"] for o2 in orbits if o2["oid"] == oid][0],
                },
                "beta_A_on_N_{F_A}": beta_labels(K, nuK),
                "A_weights_on_T_p": beta_labels(
                    K, {h: cadd(cmul_root(chiW[h], cconj_root(chiK[h])),
                                cscale(CONE, -1)) for h in K}),
            }
            if len(gensK) == 1 and len(K) > 1:
                ent["beta_A_residues_mod_n"] = beta_multiset_cyclic(K, nuK, gensK[0][0])
                ent["T_p_weights_residues_mod_n"] = beta_multiset_cyclic(
                    K, {h: cadd(cmul_root(chiW[h], cconj_root(chiK[h])),
                                cscale(CONE, -1)) for h in K}, gensK[0][0])
                ent["n"] = gensK[0][1]
            entries.append(ent)
        refinements.append({
            "orbit_id": ob["oid"], "H_class": class_label[ob["cls"]],
            "fix_a2_label": ob["label"],
            "note": ("KT symbols are indexed by ABELIAN stabilisers; this stratum "
                     "enters Burn_4(G) only after standard form.  The abelian "
                     "subgroups A <= H below are the strata of F(P(W)) through the "
                     "same point, with their own symbols."),
            "abelian_subgroup_strata": entries,
        })

    print("[3/6] abelian refinements of the %d nonabelian-stabiliser orbits built"
          % len(refinements))

    # ---------------------------------------------------------------------
    # 8.  Admissible smooth G-stable centers (the enumeration)
    # ---------------------------------------------------------------------
    # A center must be (a) smooth, (b) G-stable, (c) of codimension >= 2
    # (blowing up a smooth divisor is an isomorphism).  Restricted, per the
    # brief, to centers that are unions of G-orbits of strata closures of
    # F(P(W)).  Every stratum is a linear subspace = its own closure (FIX-A2),
    # so such a union is smooth iff its members are pairwise disjoint, and by
    # Remark 1.2 two strata meet iff a common lower stratum exists.  For a
    # single orbit O that is: some lower orbit has up-multiplicity >= 2 into O.
    up_mult = defaultdict(dict)
    for r in P["poset"]["orbit_level"]:
        up_mult[r["upper_orbit"]][r["lower_orbit"]] = r["up_multiplicity"]

    center_enum = []
    for ob in orbits:
        oid = ob["oid"]
        selfmeet = [(lo, m) for lo, m in sorted(up_mult[oid].items()) if m >= 2]
        if ob["dim"] == 4:
            verdict, reason = "not-a-center", "codimension 0"
        elif ob["dim"] > 0 and selfmeet:
            verdict = "singular"
            reason = ("distinct members of the orbit meet: orbit %d lies in %d "
                      "members of this orbit" % (selfmeet[0][0], selfmeet[0][1]))
        elif ob["dim"] > 0:
            verdict, reason = "smooth", "members pairwise disjoint"
        else:
            verdict, reason = "smooth", "finite set of distinct points"
        center_enum.append({
            "orbit_id": oid, "fix_a2_label": ob["label"], "dim": ob["dim"],
            "orbit_size": ob["orbit_size"],
            "union_of_the_orbit_is": verdict, "reason": reason,
            "self_intersection_witnesses": [
                {"lower_orbit": lo, "lower_label":
                 [o2["label"] for o2 in orbits if o2["oid"] == lo][0],
                 "up_multiplicity": m} for lo, m in selfmeet],
        })
    smooth_pos = [c for c in center_enum if c["dim"] > 0 and c["union_of_the_orbit_is"] == "smooth"]
    assert not smooth_pos, smooth_pos

    # the 10 distinct point-orbit centers
    centers = []
    for ob in POINT_ORBITS:
        centers.append(ob)

    # ---------------------------------------------------------------------
    # 9.  Theorem 2.1, implemented exactly, for each point-orbit center
    # ---------------------------------------------------------------------
    def symbol_of_new_stratum(H, chi, nu_Tp, S):
        """Thm 2.1(ii) for F_Z = {p}, N_{Z/X}|_p = T_p with character nu_Tp."""
        m = inner_product(chi, nu_Tp, H)
        assert m >= 1
        dim = m - 1
        # raw(h) = conj(chi(h)) * ( nu_Tp(h) - chi(h) )   =  conj(chi)*nu_Tp - 1
        raw = {h: cadd(cmul_root(nu_Tp[h], cconj_root(chi[h])), cscale(CONE, -1))
               for h in H}
        triv = {h: 0 for h in H}
        t = inner_product(triv, raw, H)
        assert t == m - 1, (t, m)
        # delta_nr = raw - t*triv + chi
        newnu = {h: cadd(cadd(raw[h], cscale(CONE, -t)), mono(chi[h])) for h in H}
        assert cis_rational_int(newnu[ONE]) == 5 - m
        NH = normalizer(H)
        stab = frozenset(g for g in NH if g in S
                         and all(chi[conj(finv(g), h)] == chi[h] for h in H))
        assert all(h in stab for h in H)
        res = res_character(H, chi, stab, nu_Tp)
        key = canonical_symbol(H, dim, newnu, stab, res)
        return dim, newnu, stab, res, key, m

    blowups = []
    SYM_MULT = defaultdict(int)
    for key, rec, ob in symbol_records:
        SYM_MULT[key] += 1

    KEY2LABEL = {}
    for key, rec, ob in symbol_records:
        KEY2LABEL.setdefault(key, []).append(ob["label"])

    for ob in centers:
        S, chiS, nuS = ob["H"], ob["chi"], ob["nu"]
        subs = all_subgroups(S)
        # --- destroyed: the 0-dimensional strata sitting at the points of Z
        destroyed = {}
        for K in subs:
            chiK = {h: chiS[h] for h in K}
            d = inner_product(chiK, chiW, K) - 1
            if d == 0:
                oid = find_orbit(K, chiK)
                destroyed[oid] = True
        dest_ids = sorted(destroyed)
        # --- created: S-orbits of pairs (H<=S, chi nontrivial with N^chi != 0)
        pairs = []
        for K in subs:
            _, chars = lin_chars(K)
            for _, chiK in chars:
                if all(e == 0 for e in chiK.values()):
                    continue                       # trivial character: Thm 2.1(iii)
                if inner_product(chiK, nuS, K) == 0:
                    continue
                pairs.append((K, chiK))
        # group into S-orbits
        seen = set()
        created = []
        for K, chiK in pairs:
            tag = (K, tuple(sorted(chiK.items())))
            if tag in seen:
                continue
            orb = set()
            for s in S:
                si = finv(s)
                K2 = conj_set(s, K)
                chi2 = {h: chiK[conj(si, h)] for h in K2}
                orb.add((K2, tuple(sorted(chi2.items()))))
            seen |= orb
            dim, newnu, stab, res, key, m = symbol_of_new_stratum(K, chiK, nuS, S)
            created.append({
                "H_class": class_label[gclass(K)],
                "H_order": len(K),
                "H_elements_psl": [list(h) for h in sorted(K)],
                "chi": {"exponents_zeta330": {str(list(h)): chiK[h] for h in sorted(K)}},
                "multiplicity_of_chi_in_T_p": m,
                "dim_F_new": dim,
                "beta_new": beta_labels(K, newnu),
                "beta_new_class_values": nu_class_values(K, newnu),
                "residual_group": {
                    "Stab_order": len(stab), "W_order": len(stab) // len(K),
                    "W_name": group_name(stab) if len(K) == 1 else "order%d" % (len(stab)//len(K)),
                    "action_character": [
                        {"g_psl": list(g), "order": elt_order(g),
                         "trace_on_N_chi": cencode(res[g])} for g in sorted(stab)],
                },
                "sanity_dimF_plus_beta": dim + (5 - m),
                "num_S_orbit_members": len(orb),
                "G_orbit_size_of_new_stratum": 660 // len(stab),
                "canonical_symbol_key": repr(key),
                "_key": key,
            })
            assert created[-1]["sanity_dimF_plus_beta"] == 4
        blowups.append({
            "center_orbit_id": ob["oid"],
            "center_label": ob["label"],
            "center_description": "the G-orbit of %d points with stabiliser %s"
                                  % (ob["orbit_size"], ob["ptstab_name"]),
            "center_size": ob["orbit_size"],
            "destroyed_orbit_ids": dest_ids,
            "destroyed_labels": [o2["label"] for o2 in orbits if o2["oid"] in destroyed],
            "created": created,
            "_dest_keys": [k for (k, r, o2) in symbol_records if o2["oid"] in destroyed],
            "_new_keys": [c["_key"] for c in created],
        })

    print("[4/6] Theorem 2.1 deltas computed for the %d point-orbit centers"
          % len(blowups))

    # ---- the 15 isotropy strata (built from the same data) ---------------
    SYMBYID = {ob["oid"]: (k, r) for (k, r, ob) in symbol_records}
    ISOTROPY_STRATA = []
    for ob in orbits:
        if ob["dim"] == 4 or (ob["dim"] > 0 and ob["ptstab"] == ob["H"]):
            k, r = SYMBYID[ob["oid"]]
            ISOTROPY_STRATA.append({
                "dim": ob["dim"], "generic_stabiliser": ob["ptstab_name"],
                "abelian": sub_class[ob["ptstab"]] in ABELIAN_CLASSES,
                "family_size": ob["orbit_size"],
                "carrying_stratum_orbits": [ob["label"]],
                "symbol_orbit_id": ob["oid"], "symbol_key": repr(k),
            })
    for b in blowups:
        ob = [o2 for o2 in orbits if o2["oid"] == b["center_orbit_id"]][0]
        k, r = SYMBYID[ob["oid"]]
        ISOTROPY_STRATA.append({
            "dim": 0, "generic_stabiliser": ob["ptstab_name"],
            "abelian": sub_class[ob["ptstab"]] in ABELIAN_CLASSES,
            "family_size": ob["orbit_size"],
            "carrying_stratum_orbits": sorted(b["destroyed_labels"]),
            "symbol_orbit_id": ob["oid"], "symbol_key": repr(k),
        })
    assert len(ISOTROPY_STRATA) == 15, len(ISOTROPY_STRATA)
    assert sum(len(st["carrying_stratum_orbits"]) for st in ISOTROPY_STRATA) == 20

    # ---------------------------------------------------------------------
    # 10.  Removability verdicts over all unions of admissible centers
    # ---------------------------------------------------------------------
    n = len(blowups)
    all_keys = sorted(SYM_MULT, key=repr)
    removable_witness = {}
    for mask in range(1, 1 << n):
        mult = dict(SYM_MULT)
        for i in range(n):
            if not (mask >> i) & 1:
                continue
            for k in blowups[i]["_dest_keys"]:
                mult[k] = mult.get(k, 0) - 1
            for k in blowups[i]["_new_keys"]:
                mult[k] = mult.get(k, 0) + 1
        for k in all_keys:
            if mult.get(k, 0) == 0 and k not in removable_witness:
                removable_witness[k] = mask
            elif mult.get(k, 0) == 0:
                # prefer the witness with fewest components
                if bin(mask).count("1") < bin(removable_witness[k]).count("1"):
                    removable_witness[k] = mask
    for k in all_keys:
        assert SYM_MULT[k] > 0

    verdicts = []
    for key, rec, ob in symbol_records:
        oid = ob["oid"]
        contained = [b for b in blowups if oid in b["destroyed_orbit_ids"]]
        entry = {
            "orbit_id": oid, "fix_a2_label": ob["label"],
            "H_class": rec["H_class"], "H_abelian": rec["H_abelian"],
            "dim_F": ob["dim"],
            "symbol_multiplicity_in_F(P(W))": SYM_MULT[key],
            "carried_also_by": [l for l in KEY2LABEL[key] if l != ob["label"]],
            "contained_in_admissible_centers":
                [b["center_label"] for b in contained],
        }
        if key in removable_witness:
            mask = removable_witness[key]
            entry["verdict"] = "REMOVABLE"
            entry["witness"] = {
                "move": "single blowup of P(W) along the smooth G-stable center Z",
                "Z": [blowups[i]["center_label"] for i in range(n) if (mask >> i) & 1],
                "Z_size": sum(blowups[i]["center_size"] for i in range(n) if (mask >> i) & 1),
                "justification": "theory/FIX_I_bcomplex.md Thm 2.1(i)+(ii), computed exactly",
            }
        elif not contained:
            entry["verdict"] = "RIGID-IN-CLASS"
            entry["reason"] = ("no admissible smooth G-stable center in the "
                               "enumerated class contains this stratum, so by "
                               "Thm 2.1(i) its strict transform survives every "
                               "such blowup with all decorations unchanged")
        else:
            entry["verdict"] = "RIGID-UNDER-BLOWUP"
            entry["reason"] = ("the stratum IS contained in admissible centers, "
                               "but every such blowup re-creates the same symbol "
                               "among the exceptional strata of Thm 2.1(ii)")
            recreators = []
            for b in contained:
                for c in b["created"]:
                    if c["_key"] == key:
                        recreators.append({
                            "center": b["center_label"],
                            "recreating_exceptional_stratum": {
                                "H_class": c["H_class"], "dim_F_new": c["dim_F_new"],
                                "multiplicity_of_chi_in_T_p":
                                    c["multiplicity_of_chi_in_T_p"]},
                        })
            entry["recreated_by"] = recreators
        # unconditional strengthening for positive-dimensional strata
        if ob["dim"] == 4:
            entry["verdict"] = "RIGID-UNCONDITIONAL"
            entry["reason"] = ("X^1 = X is the whole model for every model; the "
                               "open symbol (1, k(P^4) with G, empty beta) is "
                               "present in every G-model of P(W)")
        elif ob["dim"] == 2:
            entry["verdict"] = "RIGID-UNCONDITIONAL"
            entry["reason"] = (
                "Let Z be a smooth G-stable center of P(W) containing one "
                "plus-plane.  A center has codimension >= 2, so dim Z <= 2.  Z "
                "smooth means its connected components are irreducible of pure "
                "dimension; the component containing the plane is irreducible of "
                "dimension <= 2 and contains a 2-dimensional irreducible closed "
                "subvariety, hence EQUALS that plane.  So each plus-plane would "
                "be a connected component of Z, and G-stability puts all 55 in "
                "Z as pairwise DISJOINT components -- contradicting the verified "
                "incidence that each V4-line l_V lies in 3 plus-planes (orbit 5 "
                "has up-multiplicity 3 into orbit 1).  Hence no smooth G-stable "
                "center of ANY kind contains a plus-plane, and Thm 2.1(i) "
                "preserves the symbol under every blowup of P(W).")
        elif ob["dim"] == 1:
            entry["scope_note"] = (
                "RIGID-IN-CLASS is scoped to the enumerated centers.  The only "
                "escape not excluded in-repo is a smooth G-stable SURFACE in P^4 "
                "containing this whole orbit of 55/110 lines; the existence of "
                "such a surface is not settled here.  GEOMETRY-DEPENDENT.")
        if entry["verdict"] == "REMOVABLE":
            entry["verdict_coarse"] = "removable"
        elif entry["verdict"] == "RIGID-UNCONDITIONAL":
            entry["verdict_coarse"] = "rigid"
        else:
            entry["verdict_coarse"] = "rigid-in-class"
            entry["beyond_class"] = (
                "CONDITIONAL beyond the enumerated move set.  To destroy this "
                "symbol at all, Thm 2.1(i) forces a smooth G-stable center Z "
                "with the whole stratum orbit inside Z; no such Z exists among "
                "unions of strata closures.  Ruling out every other smooth "
                "G-stable Z of dimension <= 2 (necessarily carrying a faithful "
                "PSL(2,11)-action) is a geometric input NOT established in this "
                "repository, and no Kresch-Tschinkel relation is invoked.")
        verdicts.append(entry)

    core = [v for v in verdicts if v["verdict_coarse"] != "removable"]
    rem_core = {
        "definition": ("the non-removable core = the symbols that survive every "
                       "blowup of P(W) along an admissible smooth G-stable "
                       "center of the enumerated class"),
        "size": len(core),
        "symbols": [{"orbit_id": v["orbit_id"], "fix_a2_label": v["fix_a2_label"],
                     "H_class": v["H_class"], "H_abelian": v["H_abelian"],
                     "dim_F": v["dim_F"], "verdict": v["verdict"]} for v in core],
        "unconditional_subset": [v["fix_a2_label"] for v in core
                                 if v["verdict_coarse"] == "rigid"],
        "abelian_subset": [v["fix_a2_label"] for v in core if v["H_abelian"]],
    }

    print("[5/6] removability verdicts computed over all %d unions of centers"
          % ((1 << n) - 1))

    # ---------------------------------------------------------------------
    # 11.  C11 margin-note data
    # ---------------------------------------------------------------------
    c11_subs = [frozenset(tuple(e) for e in s["elements_psl"])
                for s in P["subgroups"] if s["class"] == 9]
    assert len(c11_subs) == 12
    QR = sorted({(x * x) % 11 for x in range(1, 11)})
    c11_rows = []
    c11_groups = []
    for idx, K in enumerate(sorted(c11_subs, key=lambda S: sorted(S))):
        gen = min(h for h in K if h != ONE)
        # powers of gen
        pw, y = {}, ONE
        for i in range(11):
            pw[i] = y
            y = fmul(y, gen)
        assert y == ONE
        J = []
        for j in range(11):
            chi = {pw[i]: (30 * ((i * j) % 11)) % N_CYC for i in range(11)}
            if inner_product(chi, chiW, K) == 1:
                J.append(j)
        assert len(J) == 5, (idx, J)
        pts = []
        for a in J:
            beta = sorted((b - a) % 11 for b in J if b != a)
            pairs = sorted([(a, b) for b in J if b != a])
            pts.append({
                "character_exponent_a": a,
                "beta_weights_mod_11": beta,
                "beta_as_ordered_pairs_(a,b)_weight_b_minus_a":
                    [{"a": a, "b": b, "weight": (b - a) % 11} for (a, b) in pairs],
                "plus_minus_pairing": sorted(
                    [sorted({w, (-w) % 11}) for w in beta]),
                "weight_sum_mod_11": sum(beta) % 11,
                "num_distinct_weights": len(set(beta)),
            })
            c11_rows.append({
                "c11_index": idx,
                "generator_psl": list(gen),
                "character_exponent_set_J": sorted(J),
                "character_exponent_a": a,
                "beta_weights_mod_11": beta,
                "beta_as_pairs_(a,b)": [[a, b] for b in sorted(J) if b != a],
                "plus_minus_pairing": sorted(
                    [sorted({w, (-w) % 11}) for w in beta]),
                "weight_sum_mod_11": sum(beta) % 11,
                "QR_orbit_of_beta": sorted(
                    sorted((l * w) % 11 for w in beta) for l in QR),
            })
        c11_groups.append({
            "c11_index": idx,
            "elements_psl": [list(h) for h in sorted(K)],
            "canonical_generator_psl": list(gen),
            "character_exponent_set_J": sorted(J),
            "J_is_a_quadratic_residue_coset": any(
                sorted({(l * q) % 11 for q in QR}) == sorted(J) for l in range(1, 11)),
            "J_coset_multiplier_lambda": [l for l in range(1, 11)
                                          if sorted({(l * q) % 11 for q in QR}) == sorted(J)],
            "points": pts,
        })
    assert len(c11_rows) == 60

    print("[6/6] C11 weight table: %d points, %d subgroups" % (len(c11_rows), 12))

    # ---------------------------------------------------------------------
    # 12.  Write the payloads
    # ---------------------------------------------------------------------
    META = {
        "packet": "FIX_B_BURNSIDE_SYMBOLS",
        "program": "FIX ([E56])",
        "object": "the equivariant Burnside symbol list of X = P(W) = P^4, "
                  "G = PSL(2,11) acting by the exact 5-dimensional Weil representation",
        "source": "goal_runs_after_bc93561/FIX_A2_SOURCE_COMPLEX/source_complex.json",
        "definitions": "theory/FIX_I_bcomplex.md Definition 1.1 (decorations), "
                       "Theorem 2.1 (blowup calculus), section 7 (Burnside comparison)",
        "characteristic": 0,
        "field": "Q(zeta_330) = Q(zeta_3) (x) Q(zeta_5) (x) Q(zeta_11); "
                 "field elements are encoded in the basis "
                 "zeta_3^b zeta_5^c zeta_11^d, 0<=b<2, 0<=c<4, 0<=d<10",
        "symbol_convention": (
            "s = ( [H]_G ; W(H,F) = Stab_{N_G(H)}(F)/H acting on k(F) ; "
            "beta = the multiset of NONTRIVIAL characters of H on N_{F/X} at the "
            "generic point of F ).  F is always a linear P^d here, so "
            "k(F) = k(x_1,...,x_d) with the projective linear W(H,F)-action recorded "
            "both as FIX-A2's action matrices and, basis-freely, as the character of "
            "Stab_{N_G(H)}(F) on W_chi."),
        "scope_line": ("the unrelativized class-level shadow carries no "
                       "map-compatibility information -- relativization is Note III"),
        "headline": "Problem E headline: OPEN",
    }

    sym_out = {
        "meta": META,
        "sanity": {
            "num_stratum_orbits": len(symbol_records),
            "dimF_plus_beta_equals_4_on_all": all(
                r["sanity_dimF_plus_beta"] == 4 for (_, r, _) in symbol_records),
            "num_distinct_symbol_keys": len(SYM_MULT),
            "symbol_key_multiplicities": sorted(
                [{"symbol_carried_by": sorted(KEY2LABEL[k]), "multiplicity": v}
                 for k, v in SYM_MULT.items()], key=lambda d: d["symbol_carried_by"]),
            "num_abelian_stabiliser_orbits": sum(
                1 for (_, r, _) in symbol_records if r["H_abelian"]),
            "num_nonabelian_stabiliser_orbits": sum(
                1 for (_, r, _) in symbol_records if not r["H_abelian"]),
        },
        "symbols": [r for (_, r, _) in symbol_records],
        "reduced_isotropy_stratification": {
            "note": ("the 20 stratum orbits sit on only 15 distinct isotropy strata "
                     "of P^4 (FIX-A2 FINDING 9): the open stratum, 4 "
                     "positive-dimensional families and 10 G-orbits of special "
                     "points.  The class [P(W)] in Burn_4(G) is assembled from "
                     "these, and only the ones with ABELIAN generic stabiliser are "
                     "abelian symbols."),
            "strata": ISOTROPY_STRATA,
            "abelian_part_of_the_class": {
                "num_symbols": sum(1 for st in ISOTROPY_STRATA if st["abelian"]),
                "symbols": [st["symbol_orbit_id"] for st in ISOTROPY_STRATA
                            if st["abelian"]],
                "num_distinct": len(set(
                    st["symbol_key"] for st in ISOTROPY_STRATA if st["abelian"])),
            },
            "outside_the_abelian_subgroup": [
                {"generic_stabiliser": st["generic_stabiliser"],
                 "family_size": st["family_size"],
                 "carrying_stratum_orbits": st["carrying_stratum_orbits"],
                 "status": "outside the abelian-symbol subgroup; enters via "
                           "standard form"}
                for st in ISOTROPY_STRATA if not st["abelian"]],
        },
        "abelian_refinements_of_nonabelian_strata": refinements,
    }

    rem_out = {
        "meta": META,
        "move_set_enumeration": {
            "definition": (
                "A center Z for a blowup in Mod_G(P(W)) must be (a) smooth, "
                "(b) G-stable, (c) of codimension >= 2 (blowing up a smooth divisor "
                "is an isomorphism, so dim Z <= 2 in P^4).  Per the brief the "
                "enumeration is restricted to centers that are unions of G-orbits "
                "of strata closures of F(P(W)).  Every stratum of F(P(W)) is a "
                "linear subspace equal to its own closure (FIX-A2 FINDING 6), so "
                "such a Z is smooth iff its members are pairwise disjoint; by "
                "Remark 1.2 two strata meet iff some stratum lies below both, i.e. "
                "iff some lower orbit has up-multiplicity >= 2 into the orbit."),
            "per_orbit": center_enum,
            "conclusion": (
                "every positive-dimensional stratum orbit self-intersects, so the "
                "admissible centers in this class are exactly the non-empty unions "
                "of the 10 distinct G-orbits of special points (2^10 - 1 = 1023 "
                "centers); their blowup deltas are additive because the point "
                "orbits are pairwise disjoint and Thm 2.1 is local."),
            "point_orbit_centers": [
                {"orbit_id": ob["oid"], "label": ob["label"],
                 "num_points": ob["orbit_size"], "stabiliser": ob["ptstab_name"]}
                for ob in centers],
            "num_admissible_centers": (1 << n) - 1,
        },
        "blowup_deltas": [
            {k: v for k, v in b.items() if not k.startswith("_")} for b in blowups],
        "verdicts": verdicts,
        "non_removable_core": rem_core,
        "honesty": {
            "relations_used": [
                "theory/FIX_I_bcomplex.md Theorem 2.1 (i) strict transforms, "
                "(ii) exceptional strata P(N^chi) with the Euler-sequence weight "
                "computation, (iii) the trivial character adds nothing new, "
                "(iv) residual-action update -- implemented verbatim and exactly."],
            "relations_NOT_used": [
                "the Kresch-Tschinkel relation set (conjugation / blow-up / "
                "vanishing) is NOT verified in this repository and is NOT applied. "
                "No symbol is declared zero, and no symbol identity beyond exact "
                "G-conjugacy of the decorated data is used."],
            "literature_dependent_configurations": [],
        },
    }

    # record where a KT vanishing relation would be the natural next move
    litdep = []
    for b in blowups:
        for c in b["created"]:
            reps = [e for e in c["beta_new"]["linear_characters"]
                    if e["multiplicity"] >= 2]
            if reps:
                litdep.append({
                    "center": b["center_label"], "H_class": c["H_class"],
                    "dim_F_new": c["dim_F_new"],
                    "configuration": "exceptional symbol with a REPEATED normal weight "
                                     "(multiplicity >= 2 in beta)",
                    "repeated_weights": reps,
                    "status": "LITERATURE-DEPENDENT: a KT vanishing relation would "
                              "be the natural move here; not applied, not assumed.",
                })
    rem_out["honesty"]["literature_dependent_configurations"] = litdep
    rem_out["honesty"]["literature_dependent_note"] = (
        "In the Kresch-Tschinkel calculus symbols whose beta has a repeated weight "
        "(and, in other normalisations, symbols with a weight relation) are killed "
        "by vanishing relations.  %d exceptional configurations of that shape occur "
        "in the deltas above.  They are RECORDED, not used: every verdict in this "
        "packet is derived from Thm 2.1 alone." % len(litdep))

    c11_out = {
        "meta": META,
        "note": ("the 60 poset-isolated C11-points of FIX-A2 FINDING 4: 12 Sylow-11 "
                 "subgroups x 5 fixed points each, one G-orbit, trivial residual "
                 "group, related in F(P(W)) to nothing but (1, P^4).  For each "
                 "subgroup a canonical generator g is fixed (the lexicographically "
                 "least non-identity element of the subgroup in the (a,b,c,d) mod 11 "
                 "encoding); characters are chi_j : g -> zeta_11^j; J is the set of "
                 "j with W_{chi_j} != 0; the point p_a has normal weights "
                 "beta(a) = { b - a mod 11 : b in J, b != a }.  No interpretation."),
        "quadratic_residues_mod_11": QR,
        "subgroups": c11_groups,
        "flat_table": c11_rows,
        "sanity": {
            "num_points": len(c11_rows),
            "all_beta_have_4_distinct_weights": all(
                len(set(r["beta_weights_mod_11"])) == 4 for r in c11_rows),
            "all_J_are_QR_cosets": all(g["J_is_a_quadratic_residue_coset"]
                                       for g in c11_groups),
        },
    }

    for name, obj in (("symbols.json", sym_out),
                      ("removability.json", rem_out),
                      ("c11_weights.json", c11_out)):
        with open(os.path.join(HERE, name), "w") as fh:
            json.dump(obj, fh, indent=1, sort_keys=True)
            fh.write("\n")

    # ---------------------------------------------------------------------
    # summary
    # ---------------------------------------------------------------------
    print()
    print("SYMBOL TABLE ([P(W)] in Burn_4(G), 20 stratum orbits)")
    print("%-3s %-14s %-4s %-6s %-8s %-9s %s" %
          ("id", "label", "dim", "|orbit|", "H", "W(H,F)", "beta"))
    for key, rec, ob in symbol_records:
        b = rec.get("beta_residues_mod_n")
        bs = (str(b) if b is not None else
              "+".join("%d*chi%s" % (e["multiplicity"], "".join(map(str, e["exponents"])))
                       for e in rec["beta"]["linear_characters"]) +
              (" + %d-dim nonlinear" % rec["beta"]["nonlinear_part_dim"]
               if rec["beta"]["nonlinear_part_dim"] else ""))
        print("%-3d %-14s %-4d %-6d %-8s %-9s %s%s" %
              (rec["orbit_id"], rec["fix_a2_label"], ob["dim"], ob["orbit_size"],
               rec["H_class"], rec["residual_group"]["W(H,F)"], bs,
               "" if rec["H_abelian"] else "   [nonabelian H]"))
    print()
    print("REMOVABILITY VERDICTS")
    for v in verdicts:
        extra = ""
        if v["verdict"] == "REMOVABLE":
            extra = "   Z = " + " u ".join(v["witness"]["Z"])
        print("%-3d %-14s %-22s%s" % (v["orbit_id"], v["fix_a2_label"],
                                      v["verdict"], extra))
    print()
    ncreated = sum(len(b["created"]) for b in blowups)
    newkeys = set()
    for b in blowups:
        for c in b["created"]:
            newkeys.add(repr(c["_key"]))
    oldkeys = set(repr(k) for k in SYM_MULT)
    print("HEADLINE NUMBERS")
    print("  %d stratum orbits, %d distinct symbols, dim F + |beta| = 4 on all of them"
          % (len(symbol_records), len(SYM_MULT)))
    print("  %d abelian-stabiliser orbits, %d nonabelian (standard form)"
          % (sum(1 for (_, r, _) in symbol_records if r["H_abelian"]),
             sum(1 for (_, r, _) in symbol_records if not r["H_abelian"])))
    print("  %d isotropy strata: %d abelian (%d distinct symbols) + %d nonabelian"
          % (len(ISOTROPY_STRATA),
             sum(1 for st in ISOTROPY_STRATA if st["abelian"]),
             len(set(st["symbol_key"] for st in ISOTROPY_STRATA if st["abelian"])),
             sum(1 for st in ISOTROPY_STRATA if not st["abelian"])))
    print("  %d admissible point-orbit centers, %d admissible unions"
          % (n, (1 << n) - 1))
    print("  %d new G-orbits of strata across the ten blowups, %d distinct symbols "
          "(%d already present)" % (ncreated, len(newkeys), len(newkeys & oldkeys)))
    print("  %d REMOVABLE symbols, %d in the non-removable core (%d unconditional)"
          % (sum(1 for v in verdicts if v["verdict_coarse"] == "removable"),
             rem_core["size"], len(rem_core["unconditional_subset"])))
    print("  %d C11 points, 12 subgroups, %d distinct weight quadruples mod 11"
          % (len(c11_rows),
             len(set(tuple(r["beta_weights_mod_11"]) for r in c11_rows))))
    print()
    print("PRODUCE_FIX_B_OK")

    return dict(P=P, symbol_records=symbol_records, blowups=blowups,
                verdicts=verdicts, c11_rows=c11_rows)


if __name__ == "__main__":
    main()
