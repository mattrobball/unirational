#!/usr/bin/env python3
"""Assemble Burnside-style symbols for X and P(W) from sealed ledgers.

No group reconstruction. Exact integer arithmetic only. Writes
results/assembled_symbols.json. Citations for every constant are in
THEOREM.md §4.
"""

from __future__ import annotations

import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
PKT = HERE.parent
E_ROOT = PKT.parents[1]
LEDGER = E_ROOT / "goal_runs_20260810/RECEIVER_LEDGER_X/results/ledger_exact.json"
FIXB = E_ROOT / "goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/symbols.json"
OUT = PKT / "results" / "assembled_symbols.json"

# Sealed T-weights on the Klein coordinate basis (RECEIVER_LEDGER_X THEOREM §1).
T_WEIGHTS = (1, 9, 4, 3, 5)
# F = sum_i x_i^2 x_{i+1}  (indices mod 5). At e_i, dF = dx_{i+1}.
F_NEIGHBOR = tuple((i + 1) % 5 for i in range(5))


def c11_local_beta(i: int) -> dict:
    w = T_WEIGHTS
    amb = sorted((w[j] - w[i]) % 11 for j in range(5) if j != i)
    rem = (w[F_NEIGHBOR[i]] - w[i]) % 11
    left = sorted(x for x in amb if x != rem)
    return {
        "point_index": i,
        "T_weight": w[i],
        "ambient_beta_mod_11": amb,
        "removed_by_dF": rem,
        "X_beta_mod_11": left,
    }


def c11_orbit() -> dict:
    locals_ = [c11_local_beta(i) for i in range(5)]
    seed = frozenset(locals_[0]["X_beta_mod_11"])
    qr = (1, 3, 4, 5, 9)
    orbit = []
    for a in qr:
        orbit.append(sorted((a * t) % 11 for t in seed))
    got = {frozenset(row["X_beta_mod_11"]) for row in locals_}
    pred = {frozenset(s) for s in orbit}
    return {
        "locals": locals_,
        "qr_orbit_of_first": orbit,
        "single_N_orbit": got == pred,
        "representative": sorted(seed),
    }


def c5_split() -> dict:
    """Regular C5; trivial eigenpoint off X; dF removes weight -a at chi^a."""
    rows = []
    for a in (1, 2, 3, 4):
        amb = [1, 2, 3, 4]
        rem = (-a) % 5
        left = sorted(x for x in amb if x != rem)
        rows.append({"character": a, "removed": rem, "X_beta_mod_5": left})
    inv = {a: (-a) % 5 for a in (1, 2, 3, 4)}
    orbits = []
    seen = set()
    for a in (1, 2, 3, 4):
        if a in seen:
            continue
        partner = inv[a]
        seen.add(a)
        seen.add(partner)
        orbits.append(
            {
                "residual_C2_orbit": sorted([a, partner]),
                "betas": [rows[a - 1]["X_beta_mod_5"], rows[partner - 1]["X_beta_mod_5"]],
            }
        )
    return {"rows": rows, "two_residual_orbits": orbits, "n_distinct_symbols": 2}


def c6_cut() -> dict:
    """C6 characters on W: {0,1,2,4,5}; X-points are chi^1 and chi^5 (t = -1)."""
    chars = (0, 1, 2, 4, 5)
    out = {}
    for a in (1, 5):
        amb = sorted((b - a) % 6 for b in chars if b != a)
        rem = (0 - a) % 6
        left = sorted(x for x in amb if x != rem)
        out[str(a)] = {"ambient": amb, "removed_triv_line": rem, "X_beta_mod_6": left}
    return out


def assemble_X(ledger: dict) -> list[dict]:
    c11 = c11_orbit()
    c5 = c5_split()
    c6 = c6_cut()
    rows_by_name = {r["name"]: r for r in ledger["rows"]}
    assert rows_by_name["C11"]["nconj"] == 12
    symbols = [
        {
            "id": "X.1",
            "H": "1",
            "dim_F": 3,
            "residual": "G = PSL(2,11) on k(X)",
            "k_F": "function field of the Klein cubic (unirational, not rational)",
            "beta": [],
            "pic_pairing": "triv",
            "assumption2_on_this_model": True,
            "note": "open symbol of Burn_3(G)",
        },
        {
            "id": "X.C2.E",
            "H": "C2",
            "dim_F": 1,
            "residual": "S3 = D12/C2 on k(E_sigma)",
            "k_F": "function field of the Hesse cubic j=8192/11, non-CM",
            "beta": ["sgn", "sgn"],
            "pic_pairing": "triv (E subset P(W^+))",
            "assumption2_on_this_model": False,
            "note": "O(1) pairing is trivial along E; divisorialification required",
        },
        {
            "id": "X.C2.L",
            "H": "C2",
            "dim_F": 1,
            "residual": "S3 = D12/C2 on k(P^1)",
            "k_F": "k(P^1), residual std 2-dim irrep on W^-",
            "beta": ["sgn", "sgn"],
            "pic_pairing": "sgn (L = P(W^-))",
            "assumption2_on_this_model": True,
            "note": "the unique positive-dimensional rational receiver stratum",
        },
        {
            "id": "X.C3",
            "H": "C3",
            "dim_F": 0,
            "residual": "V4 = D12/C3 freely on 4 exact-C3 points (k^4)",
            "k_F": "k x k x k x k",
            "beta": [1, 1, 2],
            "pic_pairing": "omega or omega^2, fused by residual C2",
            "assumption2_on_this_model": True,
            "note": "C6-points excluded (generic stab C6, not C3)",
        },
        {
            "id": "X.V4.I",
            "H": "V4",
            "dim_F": 0,
            "residual": "C3 = A4/V4 freely on 3 type-I vertices (k^3)",
            "k_F": "k x k x k",
            "beta": ["chi1", "chi2", "chi3"],
            "pic_pairing": "chi_i (the character line of the point)",
            "assumption2_on_this_model": True,
            "note": "same normal weights as type-II; distinguished by Pic pairing",
        },
        {
            "id": "X.V4.II",
            "H": "V4",
            "dim_F": 0,
            "residual": "C3 = A4/V4 freely on 3 type-II points of ell_V (k^3)",
            "k_F": "k x k x k",
            "beta": ["chi1", "chi2", "chi3"],
            "pic_pairing": "triv (points on P(W^{V4}))",
            "assumption2_on_this_model": False,
            "note": "trivial Pic pairing: Assumption 2 fails on this orbit",
        },
        {
            "id": "X.C5.a",
            "H": "C5",
            "dim_F": 0,
            "residual": "C2 = D10/C5 on the orbit {chi, chi^4}",
            "k_F": "k x k",
            "beta": c5["two_residual_orbits"][0]["betas"][0],
            "pic_pairing": "chi or chi^4",
            "assumption2_on_this_model": True,
            "note": "splits from the sibling orbit; ambient P(W) had a collision",
        },
        {
            "id": "X.C5.b",
            "H": "C5",
            "dim_F": 0,
            "residual": "C2 = D10/C5 on the orbit {chi^2, chi^3}",
            "k_F": "k x k",
            "beta": c5["two_residual_orbits"][1]["betas"][0],
            "pic_pairing": "chi^2 or chi^3",
            "assumption2_on_this_model": True,
            "note": "the second C5 symbol; not G-conjugate to X.C5.a",
        },
        {
            "id": "X.C6",
            "H": "C6",
            "dim_F": 0,
            "residual": "C2 = D12/C6 swapping chi^1 and chi^5 (k x k)",
            "k_F": "k x k",
            "beta": c6["1"]["X_beta_mod_6"],
            "pic_pairing": "chi^1 or chi^5",
            "assumption2_on_this_model": True,
            "note": "chi^2 and chi^4 points lie off X",
        },
        {
            "id": "X.C11",
            "H": "C11",
            "dim_F": 0,
            "residual": "C5 = F55/C11, one 5-cycle on the five coordinate points",
            "k_F": "k^5",
            "beta": c11["representative"],
            "pic_pairing": "a QR character (all generate C11^vee)",
            "assumption2_on_this_model": True,
            "note": "single N-orbit; QR-orbit of {2,3,4} mod 11",
        },
    ]
    for s in symbols:
        s["dim_plus_beta"] = s["dim_F"] + len(s["beta"])
        s["lives_in"] = "Burn_3(G)"
    return symbols


def assemble_PW(fixb: dict | None) -> dict:
    """Cite FIX-B; do not re-derive the 20-orbit list."""
    info = {
        "source": "goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/",
        "lives_in": "Burn_4(G)",
        "n_G_orbits_of_strata": 20,
        "n_distinct_symbols": 19,
        "abelian_generic_stab_orbits": 14,
        "nonabelian_point_orbits_need_standard_form": 6,
        "collision": "C5/chi and C5/chi^2 share (C5; 1 on k; {1,2,3,4})",
        "note": "FIX-B computed the source-side list; this packet does not re-run it.",
    }
    if fixb is None:
        info["fixb_present"] = False
        return info
    info["fixb_present"] = True
    info["fixb_top_keys"] = sorted(fixb.keys())
    san = fixb.get("sanity", {})
    info["fixb_sanity"] = {
        "num_stratum_orbits": san.get("num_stratum_orbits"),
        "num_distinct_symbol_keys": san.get("num_distinct_symbol_keys"),
        "num_abelian_stabiliser_orbits": san.get("num_abelian_stabiliser_orbits"),
        "num_nonabelian_stabiliser_orbits": san.get("num_nonabelian_stabiliser_orbits"),
        "dimF_plus_beta_equals_4_on_all": san.get("dimF_plus_beta_equals_4_on_all"),
    }
    return info


def condition_A(ledger: dict) -> dict:
    nonempty_abelian = []
    for name in ("C2", "C3", "V4", "C5", "C6", "C11"):
        # Presence of a row with this name is the sealed conjugacy class.
        hits = [r for r in ledger["rows"] if r["name"] == name]
        nonempty_abelian.append({"H": name, "n_rows": len(hits), "nconj": hits[0]["nconj"] if hits else None})
    return {
        "every_abelian_class_present": all(x["n_rows"] == 1 for x in nonempty_abelian),
        "rows": nonempty_abelian,
        "X_G_empty": True,
        "note": "Condition (A) is existence of H-fixed points for abelian H, not G-fixed points.",
    }


def main() -> None:
    ledger = json.loads(LEDGER.read_text())
    fixb = json.loads(FIXB.read_text()) if FIXB.is_file() else None
    payload = {
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "verdict": "ORTHOGONAL / INAPPLICABLE as a new dominance obstruction",
        "X_symbols": assemble_X(ledger),
        "P_W": assemble_PW(fixb),
        "c11_weight_cut": c11_orbit(),
        "c5_split": c5_split(),
        "c6_cut": c6_cut(),
        "condition_A": condition_A(ledger),
        "dimension_mismatch": {
            "Burn_n_of_X": 3,
            "Burn_n_of_P_W": 4,
            "comparison_X_vs_P_W_is_a_type_error": True,
        },
        "exclusions_claimed": [],
        "degrees_excluded": [],
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("ASSEMBLE_BURNSIDE_OK")
    print(f"wrote {OUT}")
    print(f"X symbols: {len(payload['X_symbols'])}")
    print(f"C11 representative beta: {payload['c11_weight_cut']['representative']}")
    print(f"C5 symbols: {[o['betas'][0] for o in payload['c5_split']['two_residual_orbits']]}")


if __name__ == "__main__":
    main()
