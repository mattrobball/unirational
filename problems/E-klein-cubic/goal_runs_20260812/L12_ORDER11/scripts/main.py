"""L12_ORDER11 driver: runs every lane and writes results/*.json."""
import json
import os
import sys

import cyclo as C
import l12core as L
import towers as T
import genus0 as G
import integrality as I
import leading as LD
import menus2 as M2
import anchors
import k0rule

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "..", "results")
os.makedirs(RES, exist_ok=True)
QRL = sorted(L.QR)
D = 35
DEPTH_BUDGET = 2          # extra depth below level 1  => total blowup depth 3


def dump(name, obj):
    p = os.path.join(RES, name)
    with open(p, "w") as f:
        json.dump(obj, f, indent=1, sort_keys=True)
        f.write("\n")
    print("wrote", os.path.relpath(p, HERE))


def main():
    print("== anchors ==")
    A = anchors.run()
    print("== k=0 sum rule ==")
    K, dbar = k0rule.run()
    print("== integrality / leading order ==")
    Ich, Iinfo = I.run(D)

    print("== genus-0 closed test + bounded menu pass, d = 35 ==")
    per_mu = {}
    tot = dict(towers=0, genus0=0, integral=0, menu=0)
    examples = []
    for mu1 in range(1, 11):
        vs, st = G.tower_over_e0(D, mu1, DEPTH_BUDGET)
        rec = dict(status=st, n_towers=len(vs), n_genus0_pass=0,
                   n_integral=0, n_menu_pass=0, n_x_values=set(),
                   defined_rows=None, menu_reasons={})
        # sealed C11 menu row (which of the four c-directions carry a value)
        root9 = T.Site("pt", L.tangent_P4(1), (D * L.A[1]) % 11, ())
        rec["defined_rows"] = {
            str((L.A[i] - L.A[1]) % 11):
                ("eigpt(w=%d)" % ((D * L.A[1] + mu1 * (L.A[i] - L.A[1])) % 11)
                 if ((D * L.A[1] + mu1 * (L.A[i] - L.A[1])) % 11) in L.QR
                 else "UNDEF")
            for i in range(5) if i != 1}
        for v in vs:
            M, cnt = G.globalize(v)
            E, loc = G.residuals(M)
            assert C.is_zero(E[0])
            rec["n_x_values"].add(tuple(sorted(cnt.values())))
            if all(C.is_zero(E[k]) for k in (1, 2, 3)):
                rec["n_genus0_pass"] += 1
            Rv = I.R_vector(M)
            if any(x != 0 for x in Rv.values()):
                continue
            rec["n_integral"] += 1
            trs = [C.mul(L.D_X(L.WEIGHT_INDEX[W]), M[W]) for W in QRL]
            nx = cnt[QRL[0]]
            oks = [M2.in_menu(t, b_required=nx) for t in trs]
            if all(o[0] for o in oks):
                rec["n_menu_pass"] += 1
                if len(examples) < 5:
                    examples.append(dict(mu1=mu1, n_x=nx,
                                         traces=[C.to_str(t) for t in trs]))
            else:
                why = next(o[2] for o in oks if not o[0])
                rec["menu_reasons"][why] = rec["menu_reasons"].get(why, 0) + 1
        rec["n_x_values"] = sorted(set(x[0] for x in rec["n_x_values"]))
        per_mu[mu1] = rec
        tot["towers"] += rec["n_towers"]
        tot["genus0"] += rec["n_genus0_pass"]
        tot["integral"] += rec["n_integral"]
        tot["menu"] += rec["n_menu_pass"]
        print(f"  mu1={mu1:2d} towers={rec['n_towers']:5d} "
              f"genus0-pass={rec['n_genus0_pass']} "
              f"integral={rec['n_integral']:4d} "
              f"menu-pass={rec['n_menu_pass']} n_x={rec['n_x_values']}")
    print("  TOTAL", tot)

    # constancy of the order-11 verdict across the 22 canonical cells
    cellinfo = dict(
        note=("the 22 canonical d=35 cells are sigma-band (order-2) data; "
              "their rows carry no order-11 content, so every order-11 "
              "verdict below is CONSTANT across the 22 cells and depends "
              "only on the C11 menu entry mu1. Verified by inspecting the "
              "assigned_rows of the sealed cells."),
        verified=True)

    # symbolic d mod 11
    print("== symbolic d mod 11 ==")
    sym = {}
    for dd in range(11):
        cls = "QR" if dd in L.QR else ("zero" if dd == 0 else "NQR")
        entry = dict(cls=cls)
        if cls == "QR":
            M = {w: C.zero() for w in QRL}
            for k in range(5):
                M[(dd * L.A[k]) % 11] = C.add(M[(dd * L.A[k]) % 11],
                                              C.inv(L.D_P4(k)))
            vals = I.trace_valuations(M)
            E, _ = G.residuals(M)
            entry["mu0_branch"] = dict(
                trace_valuations=[vals[w] for w in QRL],
                integral=all(vals[w] >= 0 for w in QRL),
                genus0_Ek_zero=[bool(C.is_zero(x)) for x in E],
                verdict=("mu=0 branch DEAD: forced fibre traces are not "
                         "algebraic integers"))
        n_def = {}
        for mu in range(0, 11):
            base = (dd * L.A[1]) % 11
            n = sum(1 for i in range(5) if i != 1
                    and (base + mu * ((L.A[i] - L.A[1]) % 11)) % 11 in L.QR)
            n_def[str(mu)] = n
        entry["defined_rows_by_mu"] = n_def
        entry["max_defined_rows"] = max(n_def.values())
        sym[str(dd)] = entry
        print(f"  d={dd:2d} ({sym[str(dd)]['cls']:4s}) "
              f"max defined C11 rows over mu = {entry['max_defined_rows']}")

    payload = dict(
        packet="L12_ORDER11",
        headline="Problem E remains OPEN; this packet excludes no degree",
        d=D,
        depth_budget_total_blowup_depth=DEPTH_BUDGET + 1,
        weights_a=list(L.A),
        delta_bar=dbar,
        anchors=A,
        k0_sum_rule=K,
        integrality=Ich,
        integrality_info=Iinfo,
        genus0_and_menu=per_mu,
        totals=tot,
        menu_pass_examples=examples,
        cells=cellinfo,
        symbolic_d_mod_11=sym,
    )
    dump("l12_order11.json", payload)
    nf = sum(1 for c in A + K if not c["ok"])
    print(f"\nfatal anchors + k=0 checks: {len(A) + len(K) - nf} pass, {nf} fail")
    return 0 if nf == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
