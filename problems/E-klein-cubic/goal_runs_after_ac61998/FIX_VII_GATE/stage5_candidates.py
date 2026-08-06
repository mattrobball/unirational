"""Stage 5: the n2-dimensional carrier space -- explicit candidates + controls.

  * the kernel of the Stage-4 normal-form map, materialised as explicit
    degree-34 tuples (payload/candidates_p*/);
  * an ORDER-INDEPENDENT re-verification in M2: everything is redone in the
    ring with the variables in the opposite order (a different monomial order,
    hence a different Groebner basis and different normal forms).  There,
      - all 5 components of all 13 candidates must reduce to 0     => n2 >= 13
      - 3 profile tuples must have normal forms of rank 3          => n2 <= 13
  * per candidate: T != 0, whether T vanishes identically on X = V(F),
    <T, x> = sum T_i x_i (degree 35), and whether F(T) = 0 mod (F).

F(T) has degree 102; `F(T) = 0 mod (F)` is tested by evaluating F(T(v)) at
F_p-points v of X.  A single nonzero value is a decisive NO; the report states
exactly what was and was not certified.
"""
import json
import os
import subprocess
import sys
import time

import numpy as np

import gatelib as GL
from gatelib import check, matmul_mod, monomials, nmon, poly_m2, rank_mod
from stage4_carrier import parse_nf
import verifier as VF

HERE = os.path.dirname(os.path.abspath(__file__))
DTOP = 34


def nf_matrix(p, n1):
    zero, terms = parse_nf(os.path.join(HERE, "results", "NF_p%d.txt" % p), n1)
    sup = sorted({e for (t, j, i), d in terms.items() if t == "NF" for e in d})
    si = {e: k for k, e in enumerate(sup)}
    M = np.zeros((n1, 5 * len(sup)), dtype=np.int64)
    for (t, j, i), d in terms.items():
        if t != "NF":
            continue
        for e, c in d.items():
            M[j, i * len(sup) + si[e]] = c % p
    return M


def points_on_X(p, n, rng):
    """F_p-points of X = V(F): solve x1 x0^2 + x4^2 x0 + c = 0 for x0."""
    out = []
    while len(out) < n:
        v = rng.integers(0, p, size=(4096, 4)) % p          # x1,x2,x3,x4
        x1, x2, x3, x4 = v[:, 0], v[:, 1], v[:, 2], v[:, 3]
        a = x1 % p
        b = (x4 * x4) % p
        c = (x1 * x1 % p * x2 + x2 * x2 % p * x3 + x3 * x3 % p * x4) % p
        disc = (b * b - 4 * a * c) % p
        ok = np.nonzero((a != 0) & (pow_mod(disc, (p - 1) // 2, p) != p - 1))[0]
        for k in ok:
            s = GL.sqrt_mod(int(disc[k]), p)
            if s is None:
                continue
            x0 = (int(s) - int(b[k])) * pow(2 * int(a[k]), p - 2, p) % p
            pt = [x0, int(x1[k]), int(x2[k]), int(x3[k]), int(x4[k])]
            if any(pt):
                out.append(pt)
            if len(out) >= n:
                break
    return np.array(out[:n], dtype=np.int64)


def pow_mod(A, e, p):
    R = np.ones_like(A)
    B = A % p
    while e:
        if e & 1:
            R = (R * B) % p
        B = (B * B) % p
        e >>= 1
    return R


def inner_with_x(T, p):
    """<T, x> = sum_i T_i x_i, a degree-35 invariant."""
    N35 = nmon(DTOP + 1)
    out = np.zeros((T.shape[0], N35), dtype=np.int64)
    mons1, _ = monomials(1)
    for i in range(5):
        row = GL.shift_row(mons1[i], DTOP)
        out[:, row] = (out[:, row] + T[:, i, :]) % p
    return out % p


def m2_reverify(p, CAND, TSEL, outfile):
    L = ["pp = %d;" % p,
         "kk = ZZ/pp;",
         "R = kk[x4,x3,x2,x1,x0];",         # opposite variable order
         "F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0;",
         "Hess = diff(transpose vars R, diff(vars R, F));",
         "H = det Hess;",
         "IC = saturate(ideal(H) + ideal jacobian ideal H);",
         "GB = gb IC;",
         "out = openOut %s;" % ('"%s"' % outfile),
         'out << "ICDEG " << (dim IC - 1) << " " << (degree IC) << " " '
         '<< (hilbertFunction(34, R^1/IC)) << endl;',
         "emit = (tag, j, i, f) -> (",
         "  nf = f % GB;",
         '  out << "NFZ " << tag << " " << j << " " << i << " " '
         '<< (if nf == 0 then 1 else 0) << endl;',
         "  if nf != 0 then (",
         "    (mm, cc) = coefficients nf;",
         "    for k from 0 to numColumns mm - 1 do (",
         "      e = (exponents(mm_(0,k)))#0;",
         '      out << "NFT " << tag << " " << j << " " << i << " " << e#0 '
         '<< " " << e#1 << " " << e#2 << " " << e#3 << " " << e#4 << " " '
         "<< toString(cc_(k,0)) << endl;));",
         "  );",
         ]
    for j in range(CAND.shape[0]):
        for i in range(5):
            L.append('emit("CAND", %d, %d, %s);'
                     % (j, i, poly_m2(CAND[j, i], DTOP, p)))
    for j in range(TSEL.shape[0]):
        for i in range(5):
            L.append('emit("SEL", %d, %d, %s);'
                     % (j, i, poly_m2(TSEL[j, i], DTOP, p)))
    L += ['out << "END" << endl;', "close out;", "exit 0"]
    return "\n".join(L)


def run(p, tag=""):
    t0 = time.time()
    log = lambda *a: print(*a, flush=True)
    log("=== Stage 5, p=%d ===" % p)
    T = np.load(os.path.join(HERE, "payload", "profile_basis_p%d" % p,
                             "coeffs.npz"))["T"].astype(np.int64)
    n1 = T.shape[0]
    M = nf_matrix(p, n1)
    rk = rank_mod(M, p)
    n2 = n1 - rk
    ker = GL.nullspace(M.T % p, p).T % p                     # (n2, n1)
    assert ker.shape[0] == n2
    check("carrier_kernel_dim" + tag, n2 == n1 - rk,
          "n1=%d rank=%d n2=%d" % (n1, rk, n2))

    CAND = np.tensordot(ker, T, axes=(1, 0)) % p             # (n2,5,N_34)
    log("  %d candidates materialised (%.0fs)" % (n2, time.time() - t0))

    # 3 profile tuples whose normal forms are independent (witnesses rank >= 3)
    sel, cur = [], np.zeros((0, M.shape[1]), dtype=np.int64)
    for j in range(n1):
        t = np.concatenate([cur, M[j][None, :]], axis=0)
        if rank_mod(t, p) > cur.shape[0]:
            cur, sel = t, sel + [j]
        if len(sel) == rk:
            break
    TSEL = T[np.array(sel)]
    log("  rank witnesses: profile tuples %s" % sel)

    outfile = os.path.join(HERE, "results", "NFREV_p%d.txt" % p)
    sc = os.path.join(HERE, "tmp", "rev%d.m2" % p)
    src = m2_reverify(p, CAND, TSEL, outfile)
    open(sc, "w").write(src)
    log("  M2 re-verification (opposite variable order), %.1f MB source ..."
        % (len(src) / 1e6))
    r = subprocess.run(["M2", "--script", sc], capture_output=True, text=True)
    if r.returncode:
        print(r.stdout[-3000:], r.stderr[-3000:])
        raise SystemExit("M2 re-verification failed at p=%d" % p)
    zero, terms = parse_nf(outfile, n2)
    icline = [l.split() for l in open(outfile) if l.startswith("ICDEG")][0]
    cz = [zero[("CAND", j, i)] for j in range(n2) for i in range(5)]
    check("candidates_in_IC_revorder" + tag, all(cz),
          "all %d components of the %d candidates reduce to 0 mod I_C in "
          "kk[x4..x0] (I_C there: dim %s degree %s HF(34)=%s)"
          % (len(cz), n2, icline[1], icline[2], icline[3]))
    sup = sorted({e for (t, j, i), d in terms.items() if t == "SEL"
                  for e in d})
    si = {e: k for k, e in enumerate(sup)}
    S = np.zeros((len(sel), 5 * max(1, len(sup))), dtype=np.int64)
    for (t, j, i), d in terms.items():
        if t != "SEL":
            continue
        for e, c in d.items():
            S[j, i * len(sup) + si[e]] = c % p
    rk2 = rank_mod(S, p)
    check("carrier_rank_order_independent" + tag, rk2 == rk,
          "rank of the %d witness tuples under the opposite order = %d "
          "(default order gave rank %d)" % (len(sel), rk2, rk))

    # --- per-candidate reports
    rng = np.random.default_rng(31337 + p)
    XP = points_on_X(p, 4000, rng)
    fx = GL.F_eval(XP, p)
    assert not np.any(fx), "point construction off X"
    vals = VF.eval_tuples(CAND, XP, p)                       # (n2,5,npts)
    FT = np.zeros((n2, XP.shape[0]), dtype=np.int64)
    for i in range(5):
        FT = (FT + vals[:, i] ** 2 % p * vals[:, (i + 1) % 5]) % p
    IX = inner_with_x(CAND, p)
    rows = []
    for j in range(n2):
        nzT = int(np.count_nonzero(CAND[j]))
        nz_on_X = int(np.count_nonzero(vals[j]))
        ft_nz = int(np.count_nonzero(FT[j]))
        rows.append({"candidate": j, "nonzero_coeffs": nzT,
                     "T_not_identically_zero": nzT > 0,
                     "T_nonzero_somewhere_on_X": nz_on_X > 0,
                     "inner_T_x_deg35_nonzero_coeffs":
                         int(np.count_nonzero(IX[j])),
                     "inner_T_x_is_zero": bool(not np.any(IX[j])),
                     "F_of_T_nonzero_at_points_of_X": ft_nz,
                     "F_of_T_mod_F_is_zero":
                         (False if ft_nz else "not-nonzero-on %d sampled "
                          "points of X (not certified)" % XP.shape[0])})
    check("candidates_nonzero" + tag,
          all(r["nonzero_coeffs"] > 0 for r in rows),
          "every candidate is a nonzero tuple; nonzero on X: %s"
          % [r["T_nonzero_somewhere_on_X"] for r in rows])

    d = os.path.join(HERE, "payload", "candidates_p%d" % p)
    os.makedirs(d, exist_ok=True)
    np.savez_compressed(os.path.join(d, "coeffs.npz"),
                        T=CAND.astype(np.uint8), ker=ker.astype(np.int64),
                        inner_T_x=IX.astype(np.uint8))
    mons, _ = monomials(DTOP)
    for j in range(n2):
        with open(os.path.join(d, "C%02d.txt" % j), "w") as f:
            f.write("# FIX-VII-GATE candidate %d, p=%d: degree-34 "
                    "G-equivariant tuple\n" % (j, p))
            f.write("# (1,6)-profile along the arrangement AND vanishing on "
                    "the Hessian curve C_20\n")
            f.write("# format: <component 0..4> <e0 e1 e2 e3 e4> <coefficient>\n")
            for i in range(5):
                for k in np.nonzero(CAND[j, i])[0]:
                    f.write("%d %d %d %d %d %d %d\n"
                            % (i, mons[k][0], mons[k][1], mons[k][2],
                               mons[k][3], mons[k][4], int(CAND[j, i, k])))
    with open(os.path.join(d, "REPORT.json"), "w") as f:
        json.dump({"p": p, "n1": n1, "rank": int(rk), "n2": int(n2),
                   "kernel_over_profile_basis": ker.tolist(),
                   "rank_witness_tuples": sel,
                   "per_candidate": rows,
                   "X_points_sampled": int(XP.shape[0])}, f, indent=1)
    log("  Stage 5 total %.0fs" % (time.time() - t0))
    return {"p": p, "n1": n1, "rank": int(rk), "n2": int(n2), "rows": rows}


if __name__ == "__main__":
    res = {}
    for pp in [int(a) for a in (sys.argv[1:] or ["67", "199"])]:
        res[pp] = run(pp, tag="_p%d" % pp)
    if len(res) > 1:
        check("candidates_n2_both_primes",
              len({r["n2"] for r in res.values()}) == 1,
              "n2 = %s" % {p: r["n2"] for p, r in res.items()})
    with open(os.path.join(HERE, "payload", "stage5_summary.json"), "w") as f:
        json.dump({str(k): v for k, v in res.items()}, f, indent=1)
