#!/usr/bin/env python3
"""Independent verifier for Fano/Weil-K_t packet.

Recomputes K_t minpoly irreducibility, rebuilds chart equations from polar G_q,
re-runs Singular mod holdout primes, checks ledger honesty.
"""

from __future__ import annotations

import json
import subprocess
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
G3D = HERE.parent
ROOT = G3D.parents[1]
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"))
sys.path.insert(0, str(HERE))

from field_api import basis, load_products, multiplication_matrix, multiply, one, eq  # noqa: E402
from kt_model import DEFAULT_T, ETA_INDEX, build_kt, specialize_products  # noqa: E402
from produce_weil_fano import build_Kt_chart_equations  # noqa: E402
from run_modular_fano import write_mod_script, run_sing  # noqa: E402

A, B, C, D, Z = sp.symbols("a b c d z")


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def main() -> None:
    payload = json.loads((HERE / "weil_fano_kt.json").read_text())
    require(payload["headline"] == "OPEN", "headline")
    require(payload.get("point_from_line") is False, "point")
    require(payload["decision"]["K_t_rational_line"] is None, "no line")
    require(payload["marker"] == "G3D-WEIL-FANO-KT-DEGREE27-PASS", "marker")

    tvals = tuple(payload["t"])
    require(tvals == DEFAULT_T, "t")

    # K_t
    products, _ = load_products()
    products_sp = specialize_products(products, tvals)
    L = multiplication_matrix(basis(ETA_INDEX), products_sp)
    cp = [sp.Integer(c) for c in L.charpoly(sp.symbols("T")).all_coeffs()]
    require(len(cp) - 1 == 12 and cp[0] == 1, "charpoly")
    T = sp.symbols("T")
    poly = sum(int(cp[i]) * T ** (12 - i) for i in range(13))
    fac = sp.factor_list(poly)
    require(len(fac[1]) == 1 and sp.degree(fac[1][0][0], T) == 12, "irred")
    kt = build_kt(tvals)
    require(kt["is_field"] and kt["det_power_basis_nonzero"], "field+detP")
    require(
        [str(int(c)) for c in cp] == payload["K_t"]["charpoly_coeffs_high_to_low"],
        "minpoly match",
    )
    # Structure-constant mult samples at specialized t
    e0 = one()
    e1 = basis(ETA_INDEX)
    require(eq(multiply(e0, e1, products_sp), e1), "unit*eta")
    e1sq = multiply(e1, e1, products_sp)
    # Cayley–Hamilton: m(eta)=0 using charpoly coeffs
    acc = zero = tuple(0 for _ in range(12))
    # build powers and check charpoly annihilation
    pows = [e0]
    cur = e0
    for _ in range(12):
        cur = multiply(cur, e1, products_sp)
        pows.append(cur)
    # monic charpoly: eta^12 + c11 eta^11 + ... + c0 = 0
    total = list(pows[12])
    for i in range(1, 13):
        c = int(cp[i])
        for j in range(12):
            total[j] = total[j] + c * pows[12 - i][j]
    require(all(sp.Integer(t) == 0 for t in total), "Cayley-Hamilton eta")

    # rebuild eqs vs store
    data = build_Kt_chart_equations(tvals)
    eqs_file = json.loads((HERE / "weil_fano_kt_eqs.json").read_text())
    for j, f in enumerate(data["eqs_Kt"]):
        st = sp.expand(sp.sympify(eqs_file["equations"][j]["str"]))
        require(sp.expand(f - st) == 0, f"eq{j}")

    # re-run Singular on two irred-minpoly primes (degree only)
    cp_int = [int(c) for c in cp]
    for p in (151, payload["holdout_prime"]):
        path = HERE / f"_verify_mod{p}.sing"
        write_mod_script(p, cp_int, data["eqs_Kt"], path, with_radical=False)
        info = run_sing(path, timeout=180)
        require(info.get("dim") == 0, f"dim p={p}")
        require(info.get("vdim") == 27, f"vdim p={p} got {info.get('vdim')}")

    # stored modular ledger consistent
    for r in payload["modular_primes"]:
        require(r["dim"] == 0 and r["vdim"] == 27, f"stored p={r['p']}")

    # Reducedness: DECIDED (rad_vdim==vdim) or honest RESIDUAL_NONVERDICT
    # with real TimeoutExpired / error capture (not a hardcoded claim).
    red = payload.get("reducedness") or {}
    require(
        red.get("status") in ("DECIDED", "RESIDUAL_NONVERDICT"),
        f"reducedness status {red.get('status')}",
    )
    if red.get("status") == "DECIDED":
        require(red.get("rad_vdim") == 27 and red.get("reduced") is True, "reduced claim")
    else:
        require(
            red.get("error") in ("TimeoutExpired",) or "error" in red,
            "non-verdict must record CAS error/timeout",
        )
        require(
            red.get("cas_log") or red.get("partial_stdout") is not None or red.get("raw"),
            "non-verdict must carry CAS capture",
        )
        # if cas_log named, file must exist under scratch or packet
        if red.get("cas_log"):
            logp = (
                Path(
                    "/var/folders/n3/bqmjrljs275_439r2z8m30380000gp/T/grok-goal-9dc0c7a16c14/implementer"
                )
                / red["cas_log"]
            )
            require(logp.exists() or (HERE / red["cas_log"]).exists(), "cas log missing")

    # Residual language: K_proj only
    require(
        "K_proj" in (payload.get("residual_scope") or "")
        or payload.get("residual_marker") == "G3D-LINE-27-RUR-KPROJ-OPEN",
        "residual scope",
    )

    print("G3D_WEIL_FANO_KT_OK")


if __name__ == "__main__":
    main()
