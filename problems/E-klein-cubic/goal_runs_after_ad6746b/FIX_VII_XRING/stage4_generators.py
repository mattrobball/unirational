"""Stage 4: canonical explicit covariants, identities, the d=6 map-type pair."""
import itertools, json, os, sys
import numpy as np
from lib_xring import *
import stage1_group as S1
import stage2_covariants as S2

HERE = os.path.dirname(os.path.abspath(__file__))
ONE = tuple([0] * 5)


def pconst(c, p):
    c %= p
    return {ONE: c} if c else {}


def poly_pow(a, n, p):
    r = pconst(1, p)
    for _ in range(n):
        r = poly_mul(r, a, p)
    return r


def poly_subst(f, subs, p):
    """f(y0..y4) with y_j := subs[j] (polys in x)."""
    deg = max((sum(m) for m in f), default=0)
    powers = [[pconst(1, p)] for _ in range(5)]
    for j in range(5):
        for _ in range(deg):
            powers[j].append(poly_mul(powers[j][-1], subs[j], p))
    out = {}
    for m, c in f.items():
        t = pconst(c, p)
        for j, e in enumerate(m):
            if e:
                t = poly_mul(t, powers[j][e], p)
        out = poly_add(out, t, p)
    return out


def matvec(M, v, p):
    return [poly_add({}, sum_polys([poly_mul(M[i][j], v[j], p) for j in range(len(v))], p), p)
            for i in range(len(M))]


def sum_polys(lst, p):
    out = {}
    for a in lst:
        out = poly_add(out, a, p)
    return out


def cofactor_matrix(M, p):
    """adj(M)^T entries: C[i][j] = (-1)^{i+j} minor(i,j). adj = transpose(C)."""
    n = len(M)
    C = [[None] * n for _ in range(n)]
    for i in range(n):
        for j in range(n):
            sub = [[M[a][b] for b in range(n) if b != j] for a in range(n) if a != i]
            C[i][j] = poly_scale(det_poly(sub, p), (-1) ** (i + j), p)
    adj = [[C[j][i] for j in range(n)] for i in range(n)]
    return adj


def tuple_to_vec(T, d, p):
    return np.concatenate([poly_to_vec(t, d, p) for t in T])


def basis_pivots(B, p):
    """B: (k, m, N) echelonized. Returns (flat (k, m*N), pivot columns)."""
    k = len(B)
    flat = B.reshape(k, -1) % p
    R, piv = rref(flat, p)
    assert len(piv) == k
    return R[:k] % p, piv


def coords_in(Bflat, piv, vec, p):
    """Coordinates of vec in the rref-rowspace Bflat, or None if not a member."""
    c = np.array([int(vec[j]) % p for j in piv], dtype=np.int64)
    resid = (vec - (c @ Bflat)) % p
    if np.any(resid):
        return None
    return c


def relations(vecs, p):
    """Left nullspace: coefficient vectors r with sum r_i vecs_i = 0."""
    A = np.array(vecs, dtype=np.int64) % p
    return nullspace(A.T % p, p).T % p       # rows = relations


def bal(c, p):
    """Balanced representative, plus a small-rational reading if there is one."""
    from math import gcd, isqrt
    c = int(c) % p
    N = isqrt(p // 2)
    r0, r1, s0, s1 = p, c, 0, 1
    while r1 > N:
        q = r0 // r1
        r0, r1, s0, s1 = r1, r0 - q * r1, s1, s0 - q * s1
    num, den = r1, s1
    if den < 0:
        num, den = -num, -den
    if den and den <= N and gcd(abs(num), den) == 1 and (num - c * den) % p == 0:
        return str(num) if den == 1 else "%d/%d" % (num, den)
    return str(c - p if c > p // 2 else c)


def fmt_relation(names, r, p):
    return " + ".join("(%s)*[%s]" % (bal(r[i], p), names[i])
                      for i in range(len(names)) if int(r[i]) % p) + " = 0"


def m2_reduce_mod_IC(p, polys):
    """True/False per polynomial: does it reduce to 0 modulo I_C?"""
    import subprocess
    from stage3_restrict import poly_m2
    outfile = os.path.join(HERE, "results", "vanish_p%d.txt" % p)
    L = ["pp = %d;" % p, "kk = ZZ/pp;", "R = kk[x0,x1,x2,x3,x4];",
         "F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0;",
         "H = det diff(transpose vars R, diff(vars R, F));",
         "IC = saturate(ideal(H) + ideal jacobian ideal H);",
         "GB = gb IC;", "out = openOut %s;" % ('"%s"' % outfile)]
    for q in polys:
        d = max(sum(m) for m in q) if q else 0
        s = poly_m2(poly_to_vec(q, d, p), d, p) if q else "0_R"
        L.append('out << "ZERO " << (if ((%s) %% GB) == 0 then 1 else 0) << endl;' % s)
    L += ['out << "END" << endl;', "close out;", "exit 0"]
    os.makedirs(os.path.join(HERE, "tmp"), exist_ok=True)
    script = os.path.join(HERE, "tmp", "vanish%d.m2" % p)
    open(script, "w").write("\n".join(L))
    r = subprocess.run(["M2", "--script", script], capture_output=True, text=True)
    if r.returncode != 0:
        print(r.stdout[-2000:]); print(r.stderr[-2000:])
        raise SystemExit("M2 vanishing check failed")
    return [line.split()[1] == "1" for line in open(outfile) if line.startswith("ZERO ")]


def run(p=397, tag=""):
    print("=== Stage 4, p=%d ===" % p, flush=True)
    G = S1.build_generators(p)
    gens = [G["g11"], G["s5"], G["S"]]
    dgens = [S2.contragredient(g, p) for g in gens]
    bases = dict(np.load(os.path.join(HERE, "payload", "cov_bases_p%d.npz" % p)))
    out = {"p": p}

    def space(kind, d):
        B = bases["%s_%d" % (kind, d)]
        return basis_pivots(B, p) if len(B) else (None, None)

    def member(kind, d, T, label):
        Bf, piv = space(kind, d)
        if Bf is None:
            return None
        c = coords_in(Bf, piv, tuple_to_vec(T, d, p), p)
        print("    %-26s %s%s" % (label, "IN " + kind + "-%d" % d if c is not None
                                  else "NOT in " + kind + "-%d" % d,
                                  ("  coords=" + str(list(map(int, c)))) if c is not None else ""),
              flush=True)
        return c

    # ---------------------------------------------------------------- basics
    F = dict(KLEIN)
    gradF = [poly_diff(F, i, p) for i in range(5)]
    HessF = [[poly_diff(gradF[i], j, p) for j in range(5)] for i in range(5)]
    H = det_poly(HessF, p)
    gradH = [poly_diff(H, i, p) for i in range(5)]
    HessH = [[poly_diff(gradH[i], j, p) for j in range(5)] for i in range(5)]
    adjHF = cofactor_matrix(HessF, p)
    print("  H (deg %d) has %d terms" % (max(sum(m) for m in H), len(H)), flush=True)
    out["H"] = poly_str(H)

    # invariant ladder: check F, H sit in the trivial-type spaces
    for d, obj, nm in ((3, F, "F"), (5, H, "H")):
        B = bases["triv_%d" % d]
        Bf, piv = basis_pivots(B, p)
        c = coords_in(Bf, piv, poly_to_vec(obj, d, p), p)
        check("invariant_%s_d%d" % (nm, d) + tag, c is not None,
              "coords=%s" % (None if c is None else list(map(int, c))))

    check("gradF_is_polar2" + tag, member("polar", 2, gradF, "gradF") is not None)
    cH = member("polar", 4, gradH, "gradH")
    check("gradH_is_polar4" + tag, cH is not None)

    # ------------------------------------------------- J6 (new deg-6 invariant)
    B6 = bases["triv_6"]
    F2 = poly_mul(F, F, p)
    M = np.vstack([poly_to_vec(F2, 6, p)[None, :], B6.reshape(len(B6), -1)])
    R, piv = rref(M, p)
    assert len(piv) == 2, "trivial-6 space is not 2-dimensional with F^2 inside"
    J6vec = R[1] % p
    J6 = vec_to_poly(J6vec, 6, p)
    print("  J6: %d terms, echelon complement of F^2 in Inv_6" % len(J6), flush=True)
    out["J6"] = poly_str(J6)
    gradJ6 = [poly_diff(J6, i, p) for i in range(5)]

    # ------------------------------------- dual cubic Fdual and the composition
    Bd3 = S2.echelonize(S2.covariant_space(dgens, "triv", 3, p), p)
    check("dual_cubic_exists" + tag, len(Bd3) == 1, "dim Inv_3(W-bar) = %d" % len(Bd3))
    Fdual = vec_to_poly(Bd3[0].reshape(-1), 3, p)
    out["Fdual"] = poly_str(Fdual, names=("y0", "y1", "y2", "y3", "y4"))
    print("  Fdual: %s" % poly_str(Fdual, names=("y0", "y1", "y2", "y3", "y4")), flush=True)
    pent = set(KLEIN)
    check("dual_cubic_pentagonal" + tag, set(Fdual) == pent or len(Fdual) == 5,
          "monomials=%s" % sorted(Fdual))

    gradFdual = [poly_diff(Fdual, i, p) for i in range(5)]
    comp = [poly_subst(gradFdual[i], gradF, p) for i in range(5)]     # deg 4, map-type
    cComp = member("map", 4, comp, "gradFdual o gradF")
    check("dual_polar_composition" + tag, cComp is not None)

    Fx = [poly_mul(F, {tuple(1 if k == i else 0 for k in range(5)): 1}, p) for i in range(5)]
    cFx = member("map", 4, Fx, "F * x")
    out["map4"] = {"gradFdual_o_gradF": None if cComp is None else list(map(int, cComp)),
                   "F_times_x": None if cFx is None else list(map(int, cFx))}
    if cComp is not None and cFx is not None:
        rel = relations([tuple_to_vec(comp, 4, p), tuple_to_vec(Fx, 4, p)], p)
        check("map4_pair_independent" + tag, len(rel) == 0,
              "relations=%s" % rel.tolist())

    # ------------------------------------------------- d = 5 polar candidates
    print("  d=5 polar candidates:", flush=True)
    cands5 = {
        "F*gradF": [poly_mul(F, g, p) for g in gradF],
        "gradJ6": gradJ6,
        "HessF*gradH": matvec(HessF, gradH, p),
        "HessH*gradF": matvec(HessH, gradF, p),
        "HessF*(gradFdual o gradF)": matvec(HessF, comp, p),
    }
    good5, coords5 = [], {}
    for nm, T in cands5.items():
        c = member("polar", 5, T, nm)
        coords5[nm] = None if c is None else list(map(int, c))
        if c is not None:
            good5.append(nm)
    out["polar5"] = coords5
    if len(good5) >= 2:
        vecs = [tuple_to_vec(cands5[nm], 5, p) for nm in good5]
        rels = relations(vecs, p)
        out["polar5_relations"] = [{"members": good5, "coeffs": list(map(int, r)),
                                    "balanced": fmt_relation(good5, r, p)} for r in rels]
        for r in rels:
            print("    identity: " + fmt_relation(good5, r, p), flush=True)
        check("polar5_spanned_by_candidates" + tag,
              rank_mod(np.array(vecs, dtype=np.int64), p) == 2,
              "span rank = %d of dim 2" % rank_mod(np.array(vecs, dtype=np.int64), p))

    # -------------------------------------------------- d = 6 map-type pair
    print("  d=6 map-type candidates:", flush=True)
    Hx = [poly_mul(H, {tuple(1 if k == i else 0 for k in range(5)): 1}, p) for i in range(5)]
    cands6 = {
        "H*x": Hx,
        "adj(HessF)*gradF": matvec(adjHF, gradF, p),
    }
    # bilinear polarisation Fdual(gradF, gradH, -): d^2 Fdual applied to (gradF,gradH)
    bil = []
    for i in range(5):
        s = {}
        for j in range(5):
            for k in range(5):
                cjk = poly_diff(poly_diff(poly_diff(Fdual, i, p), j, p), k, p)
                if not cjk:
                    continue
                s = poly_add(s, poly_mul(poly_scale(cjk, pow(2, p - 2, p), p),
                                         poly_mul(gradF[j], gradH[k], p), p), p)
        bil.append(s)
    cands6["Fdual''(gradF,gradH)"] = bil

    good6, coords6 = [], {}
    for nm, T in cands6.items():
        deg = max((max(sum(m) for m in t) if t else 0) for t in T)
        if deg != 6:
            print("    %-26s skipped (degree %d, not 6)" % (nm, deg), flush=True)
            coords6[nm] = "degree %d" % deg
            continue
        c = member("map", 6, T, nm)
        coords6[nm] = None if c is None else list(map(int, c))
        if c is not None:
            good6.append(nm)
    out["map6"] = coords6
    B6m = bases["map_6"]
    Bf6, piv6 = basis_pivots(B6m, p)
    if len(good6) >= 2:
        vecs = [tuple_to_vec(cands6[nm], 6, p) for nm in good6]
        rk = rank_mod(np.array(vecs, dtype=np.int64), p)
        rels = relations(vecs, p)
        out["map6_relations"] = [{"members": good6, "coeffs": list(map(int, r)),
                                  "balanced": fmt_relation(good6, r, p)} for r in rels]
        for r in rels:
            print("    identity: " + fmt_relation(good6, r, p), flush=True)
        check("map6_spanned_by_candidates" + tag, rk == 2,
              "span rank = %d of dim 2; members=%s" % (rk, good6))
    else:
        check("map6_spanned_by_candidates" + tag, False,
              "only %d candidate(s) matched: %s" % (len(good6), good6))

    # express the echelonised pair back in terms of the two independent candidates
    span_nm = [nm for nm in good6 if nm in ("H*x", "Fdual''(gradF,gradH)")]
    if len(span_nm) == 2:
        from fractions import Fraction
        Cm = np.array([coords6[nm] for nm in span_nm], dtype=np.int64) % p   # 2x2
        Cb = [[int(c) - p if int(c) > p // 2 else int(c) for c in row] for row in Cm]
        det = Cb[0][0] * Cb[1][1] - Cb[0][1] * Cb[1][0]
        assert det % p, "candidate pair is degenerate"
        Q = [[Fraction(Cb[1][1], det), Fraction(-Cb[0][1], det)],
             [Fraction(-Cb[1][0], det), Fraction(Cb[0][0], det)]]
        # rows of Q give  e_t = sum_s Q[t][s] * cand_s   (exact over Q)
        ok = all((Q[t][s].numerator * pow(Q[t][s].denominator, p - 2, p)
                  - int(matinv(Cm, p)[t, s])) % p == 0 for t in range(2) for s in range(2))
        check("pair_change_of_basis_exact" + tag, ok, "det=%d" % det)
        out["pair_in_terms_of_candidates"] = {
            "candidates": span_nm,
            "matrix_cand_to_echelon_balanced": Cb,
            "readable": ["e%d = %s" % (t, " + ".join(
                "(%s)*[%s]" % (Q[t][s], span_nm[s]) for s in range(2) if Q[t][s]))
                for t in range(2)]}
        for line in out["pair_in_terms_of_candidates"]["readable"]:
            print("    " + line, flush=True)

    mons6, _ = monomials(6)
    pairpoly = [[vec_to_poly(Bf6[t][j * len(mons6):(j + 1) * len(mons6)], 6, p)
                 for j in range(5)] for t in range(len(Bf6))]
    pair = [[poly_str(q) for q in row] for row in pairpoly]
    zeros = m2_reduce_mod_IC(p, [q for row in pairpoly for q in row])
    check("pair_vanishes_on_C" + tag, all(zeros),
          "%d/%d components reduce to 0 mod I_C" % (sum(zeros), len(zeros)))
    doc = {"p": p, "type": "map-type (target P(W)) degree 6, dim 2, echelonised",
           "monomial_order": "grlex-by-construction; polys given explicitly",
           "pair": pair, "candidate_coords": coords6,
           "identification": out.get("pair_in_terms_of_candidates"),
           "note": "coords are w.r.t. this echelonised pair"}
    names = ["pair_d6_p%d.json" % p] + (["pair_d6.json"] if p == 397 else [])
    for nm in names:
        with open(os.path.join(HERE, "payload", nm), "w") as f:
            json.dump(doc, f, indent=1)

    with open(os.path.join(HERE, "payload", "stage4_p%d.json" % p), "w") as f:
        json.dump(out, f, indent=1)
    print("  wrote payload/%s, payload/stage4_p%d.json" % (", payload/".join(names), p),
          flush=True)
    return out


if __name__ == "__main__":
    run(int(sys.argv[1]) if len(sys.argv) > 1 else 397,
        sys.argv[2] if len(sys.argv) > 2 else "")
