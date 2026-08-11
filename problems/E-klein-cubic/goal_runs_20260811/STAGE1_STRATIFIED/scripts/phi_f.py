"""Phi_F transport gate and F row data (WORKORDER section F).

F = sum_{i in Z/5} x_i^2 x_{i+1}  (Klein cubic, G-invariant of degree 3).

Anchors (machine-checked):
  * F vanishes on every minus-line L_sigma = P(W^-_sigma)  =>  ord_{L_sigma} F >= 1
  * F is nonvanishing on a generic point of every plus-plane P(W^+_sigma)
  * bihomogeneous decomposition on W = W+ ⊕ W- has terms of bidegree (3,0)
    and (1,2) only (no pure (0,3)), so the lowest order of F along L_sigma is
    exactly 1 (matching FIX_VII / EXCLUSION_TRANSPORT).

The transport inclusion on coherent patterns is operationalised as:
  (1) positivity transport: K(rho) > 0  ==>  K(rho+3) > 0 for all rho
      (the old odd-zero artifact fails this: K(0)>0 but K(3)=0);
  (2) F-row data is recorded for every sweep row (leading multi-degree options
      on full-flag rows; arc-vanishing orders at children where computable).
"""
import sys

import paths  # noqa: F401
from s3sweep import FullSweep  # noqa: E402
from s1recount import sweep_rows  # noqa: E402


def klein_F(x, p):
    return sum((x[i] * x[i] % p) * x[(i + 1) % 5] % p for i in range(5)) % p


def f_row_data(E, verbose=False):
    """per sweep-row data of F: bidegree content on full-flag rows; ord on L."""
    p, m, T = E.p, E.m, E.T
    out = {}
    for rid in sweep_rows(E):
        S = FullSweep(E, rid)
        sig = S.sig
        Wp = list(T.plus[sig])
        Wm = list(T.minus[sig])
        # ord on L_sigma: F|W-
        rnd = 17 + rid
        vals_m = []
        for _ in range(12):
            w = [0] * 5
            for b in Wm:
                rnd = (rnd * 1103515245 + 12345) % (2 ** 31)
                c = rnd % p
                w = [(w[t] + c * b[t]) % p for t in range(5)]
            vals_m.append(klein_F(w, p))
        ord_L = 1 if all(v % p == 0 for v in vals_m) else 0
        # F on W+
        vals_p = []
        for _ in range(12):
            w = [0] * 5
            for b in Wp:
                rnd = (rnd * 1103515245 + 12345) % (2 ** 31)
                c = rnd % p
                w = [(w[t] + c * b[t]) % p for t in range(5)]
            vals_p.append(klein_F(w, p))
        nonvan_plus = any(v % p for v in vals_p)
        rec = dict(
            rid=rid, nslot=S.nslot, dims=S.dims,
            ord_L=ord_L, nonvanishing_on_plus=nonvan_plus,
            sum_dims=sum(S.dims),
        )
        if sum(S.dims) == 5 and S.nslot == 2:
            # bihom coeffs of F(s u + t v)
            u = [0] * 5
            for b in Wp:
                u = [(u[t] + b[t]) % p for t in range(5)]
            v = [0] * 5
            for b in Wm:
                v = [(v[t] + b[t]) % p for t in range(5)]
            # F(s u + t v) = A s^3 + B s^2 t + C s t^2 + D t^3
            pts = [(1, 0), (0, 1), (1, 1), (2, 1)]
            R = []
            for s, t in pts:
                x = [(s * u[i] + t * v[i]) % p for i in range(5)]
                R.append([pow(s, 3, p), (pow(s, 2, p) * t) % p,
                          (s * pow(t, 2, p)) % p, pow(t, 3, p),
                          klein_F(x, p)])
            rr = 0
            for c in range(4):
                pr = next((i for i in range(rr, 4) if R[i][c] % p), None)
                if pr is None:
                    continue
                R[rr], R[pr] = R[pr], R[rr]
                iv = pow(R[rr][c], p - 2, p)
                R[rr] = [x * iv % p for x in R[rr]]
                for i in range(4):
                    if i != rr and R[i][c] % p:
                        f = R[i][c]
                        R[i] = [(x - f * y) % p for x, y in zip(R[i], R[rr])]
                rr += 1
            coefs = [R[i][4] for i in range(4)]
            rec["bihom_s3_s2t_st2_t3"] = coefs
            rec["a_F_options"] = []
            for (a0, a1), c in zip([(3, 0), (2, 1), (1, 2), (0, 3)], coefs):
                if c % p:
                    rec["a_F_options"].append((a0, a1))
            # character shift: F is G-invariant => psi_F = 1
            rec["psi_F"] = 1
            rec["kappa_F_L"] = ord_L
        out[rid] = rec
        if verbose:
            print("  F on #%02d: ord_L=%s a_F=%s"
                  % (rid, ord_L, rec.get("a_F_options")), flush=True)
    return out


def phi_f_positivity(K):
    """K(rho)>0 ==> K(rho+3)>0 for all rho.  Returns (ok, failures)."""
    fails = []
    for rho in range(6):
        if K.get(rho, 0) > 0 and K.get((rho + 3) % 6, 0) == 0:
            fails.append((rho, (rho + 3) % 6))
    return len(fails) == 0, fails


def phi_f_gate(E, K, verbose=False):
    """full Phi_F check group: F-data + positivity transport."""
    fdata = f_row_data(E, verbose=verbose)
    # anchors
    ord_ok = all(fdata[rid]["ord_L"] == 1
                 for rid in fdata if fdata[rid]["sum_dims"] == 5)
    plus_ok = all(fdata[rid]["nonvanishing_on_plus"]
                  for rid in fdata if fdata[rid]["sum_dims"] == 5)
    pos_ok, fails = phi_f_positivity(K)
    if verbose:
        print("  ord_L=1 on full-flag: %s" % ord_ok, flush=True)
        print("  F nonvanishing on plus-planes: %s" % plus_ok, flush=True)
        print("  positivity transport: %s %s" % (pos_ok, fails), flush=True)
    return dict(
        ok=ord_ok and plus_ok and pos_ok,
        ord_L_ok=ord_ok, plus_ok=plus_ok, positivity_ok=pos_ok,
        positivity_fails=fails, fdata=fdata,
    )
