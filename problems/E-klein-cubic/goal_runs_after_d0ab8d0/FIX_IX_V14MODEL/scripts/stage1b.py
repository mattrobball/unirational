"""Stage 1b: global smoothness certificate via the Pfaffian cubic; Klein-cubic
identification; random points + Jacobian corank."""
import json
import os
import random
import sys

import sympy as sp

import fp
import geom
import v14lib as V

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
CHK = os.path.join(ROOT, "results", "checks.log")
Z = sp.symbols("z0:5")


def check(name, ok, detail=""):
    line = f"CHECK {name} {'PASS' if ok else 'FAIL'} {detail}".rstrip()
    with open(CHK, "a") as f:
        f.write(line + "\n")
    print(line, flush=True)
    return ok


def ann_basis(model):
    return fp.rowspace_basis(fp.nullspace(model.Mrows, p=model.p), model.p)


def ann_action(model, ann, g15):
    """5x5 matrix of g acting on Ann(M) (contragredient), echelonized basis."""
    p = model.p
    _, piv = fp.rref(ann, p)
    ginv = _matinv(g15, p)
    cols = []
    for r in range(5):
        row = [sum(ann[r][t] * ginv[t][s] for t in range(15)) % p for s in range(15)]
        cols.append([row[c] for c in piv])
    return [[cols[r][i] for r in range(5)] for i in range(5)]


def _matinv(A, p):
    n = len(A)
    aug = [list(A[i]) + [1 if i == j else 0 for j in range(n)] for i in range(n)]
    R, piv = fp.rref(aug, p)
    assert piv == list(range(n))
    return [R[i][n:] for i in range(n)]


def sym_lambda(ann, p):
    """lambda = sum z_r ann[r] as a 15-vector of linear forms."""
    return [sum(int(ann[r][t]) * Z[r] for r in range(5)) for t in range(15)]


def poly_mod(e, p):
    return sp.Poly(sp.expand(e), *Z, modulus=None).set_modulus(p) if e != 0 else None


def to_str(e, names):
    e = sp.expand(e)
    s = str(e)
    for i, nm in enumerate(names):
        s = s.replace(f"z{i}", nm)
    return s.replace("**", "^")


def main(p, tag):
    model = V.Model(p)
    ann = ann_basis(model)
    lam = sym_lambda(ann, p)

    # --- symbolic Pfaffian and Pfaffian adjoint on P(Ann M) = P^4
    W = [[0] * 6 for _ in range(6)]
    for (i, j) in geom.PAIRS:
        W[i][j] = lam[geom.PIDX[(i, j)]]
        W[j][i] = -lam[geom.PIDX[(i, j)]]
    pfz = 0
    for s, prs in geom.MATCH6:
        t = s
        for (i, j) in prs:
            t = t * W[i][j]
        pfz += t
    pfz = sp.expand(pfz)

    om = [0] * 15
    for Q in geom.QUADS:
        i, j, k, l = Q
        val = (lam[geom.PIDX[(i, j)]] * lam[geom.PIDX[(k, l)]]
               - lam[geom.PIDX[(i, k)]] * lam[geom.PIDX[(j, l)]]
               + lam[geom.PIDX[(i, l)]] * lam[geom.PIDX[(j, k)]])
        C, sg = geom.COMP[Q]
        om[geom.PIDX[C]] = sp.expand(sg * val)

    # sanity: numeric agreement with geom.pf / geom.wedge_square
    rng = random.Random(1000 + p)
    zz = [rng.randrange(p) for _ in range(5)]
    lnum = [sum(zz[r] * ann[r][t] for r in range(5)) % p for t in range(15)]
    sub = dict(zip(Z, zz))
    ok = int(pfz.subs(sub)) % p == geom.pf(lnum, p)
    ok = ok and [int(x.subs(sub)) % p for x in om] == geom.wedge_square(lnum, p)
    check(f"pfaffian_symbolic_{tag}", ok, "symbolic pf / adjoint match numeric")

    # sanity: for rank-4 lambda, adjoint spans rad(lambda).  Sample points ON
    # the cubic {pf=0} by solving for the last coordinate.
    tested = good = 0
    for _ in range(2000):
        if tested >= 40:
            break
        base = [rng.randrange(p) for _ in range(4)]
        for z4 in range(p):
            zz = base + [z4]
            lnum = [sum(zz[r] * ann[r][t] for r in range(5)) % p for t in range(15)]
            if geom.pf(lnum, p):
                continue
            w = geom.wedge_square(lnum, p)
            if not any(w):
                continue
            tested += 1
            Wl, Ww = geom.skew(lnum, p), geom.skew(w, p)
            prod = fp.matmul(Wl, Ww, p)
            if not any(any(r) for r in prod):
                good += 1
            break
    check(f"adjoint_is_radical_{tag}", tested >= 20 and good == tested,
          f"{good}/{tested} rank-4 samples: Lambda * adjoint = 0")

    # --- the 5 cubics cutting  omega(lambda) in M
    cubics = []
    for r in range(5):
        cubics.append(sp.expand(sum(int(ann[r][t]) * om[t] for t in range(15))))

    # --- G-invariance of pf; dimension of invariant cubics in S^3(Ann M)*
    gens5 = [ann_action(model, ann, g) for g in model.gens15]
    inv_ok = True
    for E in gens5:
        subs = {Z[i]: sum(int(E[i][j]) * Z[j] for j in range(5)) for i in range(5)}
        d = sp.expand(pfz.subs(subs, simultaneous=True) - pfz)
        d = sp.Poly(d, *Z).set_modulus(p) if d != 0 else None
        inv_ok = inv_ok and (d is None or d.is_zero)
    check(f"pfaffian_G_invariant_{tag}", inv_ok, "pf(lambda) is a G-invariant cubic on P^4")
    dim_inv = invariant_cubic_dim(gens5, p)
    check(f"klein_cubic_unique_{tag}", dim_inv == 1,
          f"dim S^3(5)^G = {dim_inv}  => {{pf=0}} IS the Klein cubic threefold")

    # --- emit M2: smoothness certificate + rank<=2 check
    names = [f"z{i}" for i in range(5)]
    m2 = [f"kk = ZZ/{p};", f"S = kk[{','.join(names)}];",
          f"pf = {to_str(pfz, names)};",
          "Csing = ideal(pf, " + ", ".join(to_str(c, names) for c in cubics) + ");",
          'print("sing_locus_dim " | toString dim Csing);',
          "Krank2 = ideal(" + ", ".join(to_str(x, names) for x in om if x != 0) + ");",
          'print("rank2_locus_dim " | toString dim Krank2);',
          "Kl = ideal(pf);",
          'print("klein_dim " | toString dim Kl);',
          'print("klein_deg " | toString degree Kl);',
          'print("klein_singdim " | toString dim (Kl + ideal jacobian Kl));',
          ]
    with open(os.path.join(HERE, f"m2_stage1b_{tag}.m2"), "w") as f:
        f.write("\n".join(m2) + "\n")

    # --- random points on V14 + Jacobian corank
    quads = model.quadrics()
    rng2 = random.Random(20260806 + p)
    pts = geom.rand_points_V14(model, 30, rng2)
    ranks = []
    for (u, omv, y) in pts:
        vals = V.eval_quads(quads, y, p)
        assert not any(vals), "point not on V14"
        J = V.jac_quads(quads, y, p)
        ranks.append(fp.rank(J, p))
    check(f"jac_corank0_random_{tag}", len(pts) == 30 and set(ranks) == {6},
          f"{len(pts)} random F_p-points, Jacobian ranks {sorted(set(ranks))} (need 6)")

    with open(os.path.join(ROOT, "payload", f"pfaffian_{tag}.json"), "w") as f:
        json.dump(dict(p=p, ann=ann, pf=str(pfz), cubics=[str(c) for c in cubics],
                       gens5=gens5, sample_points=[y for (_, _, y) in pts]), f)
    print(f"stage1b {tag} done")


def invariant_cubic_dim(gens5, p):
    """dim of G-invariants in S^3 of the 5-dim rep (acting by substitution)."""
    monos = [m for m in _monos(5, 3)]
    idx = {m: i for i, m in enumerate(monos)}
    rows = []
    for E in gens5:
        subs = {Z[i]: sum(int(E[i][j]) * Z[j] for j in range(5)) for i in range(5)}
        Mat = [[0] * len(monos) for _ in range(len(monos))]
        for m in monos:
            e = 1
            for i, k in enumerate(m):
                if k:
                    e *= subs[Z[i]] ** k
            po = sp.Poly(sp.expand(e), *Z)
            for mono, c in zip(po.monoms(), po.coeffs()):
                Mat[idx[mono]][idx[m]] = int(c) % p
        for i in range(len(monos)):
            Mat[i][i] = (Mat[i][i] - 1) % p
        rows.extend(Mat)
    return len(fp.nullspace(rows, p))


def _monos(n, d):
    if n == 1:
        yield (d,)
        return
    for k in range(d + 1):
        for rest in _monos(n - 1, d - k):
            yield (k,) + rest


if __name__ == "__main__":
    for p, tag in ((397, "p397"), (199, "p199")):
        main(p, tag)
