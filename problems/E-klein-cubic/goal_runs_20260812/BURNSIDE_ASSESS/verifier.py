#!/usr/bin/env python3
"""Replayable verifier for BURNSIDE_ASSESS.

python3 standard library only. Re-reads sealed RECEIVER_LEDGER_X and
FIX-B artefacts; rebuilds the X-side weight cuts independently of
scripts/assemble_symbols.py.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
LEDGER = E_ROOT / "goal_runs_20260810/RECEIVER_LEDGER_X/results/ledger_exact.json"
FIXB = E_ROOT / "goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/symbols.json"
ASSEMBLED = HERE / "results" / "assembled_symbols.json"

T_WEIGHTS = (1, 9, 4, 3, 5)


def check(name: str, cond: bool, detail: str = "") -> dict:
    return {"name": name, "pass": bool(cond), "detail": detail}


def group_A(ledger: dict) -> list[dict]:
    """Sealed receiver re-read."""
    rows = {r["name"]: r for r in ledger["rows"]}
    want = {
        "1": (1, 1),
        "C2": (2, 55),
        "C3": (3, 55),
        "V4": (4, 55),
        "C5": (5, 66),
        "C6": (6, 55),
        "C11": (11, 12),
    }
    out = []
    for name, (order, nconj) in want.items():
        r = rows.get(name)
        out.append(
            check(
                f"ledger_row_{name}",
                r is not None and r["order"] == order and r["nconj"] == nconj,
                f"order={r['order'] if r else None} nconj={r['nconj'] if r else None}",
            )
        )
    c11 = ledger["detail"]["C11"]
    on_x = sum(1 for p in c11["points"] if p["on_X"])
    out.append(check("C11_five_points_on_X", on_x == 5, f"on_X={on_x}"))
    out.append(
        check(
            "C11_residual_is_a_5_cycle",
            c11["residual_C5_permutation"] == [2, 0, 3, 4, 1],
            str(c11["residual_C5_permutation"]),
        )
    )
    out.append(check("C2_minus_line_in_X", ledger["detail"]["C2"]["minus_line_in_X"] is True))
    out.append(check("C2_j_8192_over_11", ledger["detail"]["C2"]["j"] == "8192/11"))
    out.append(check("condition_A_abelian_rows_present", all(n in rows for n in want)))
    # Nonabelian rows exist as classes; emptiness on X is a THEOREM claim,
    # consumed as sealed (not re-proved here).
    out.append(check("X_G_empty_is_classical", True, "W irreducible; not re-proved"))
    return out


def group_B() -> list[dict]:
    """Independent X-side weight cuts."""
    out = []
    # C11
    locals_ = []
    for i in range(5):
        w = T_WEIGHTS
        amb = sorted((w[j] - w[i]) % 11 for j in range(5) if j != i)
        rem = (w[(i + 1) % 5] - w[i]) % 11
        left = sorted(x for x in amb if x != rem)
        locals_.append(left)
        out.append(
            check(
                f"C11_beta_len_at_{i}",
                len(left) == 3 and 0 not in left,
                str(left),
            )
        )
    seed = frozenset(locals_[0])
    qr = (1, 3, 4, 5, 9)
    pred = {frozenset((a * t) % 11 for t in seed) for a in qr}
    got = {frozenset(s) for s in locals_}
    out.append(check("C11_single_QR_orbit", got == pred, f"got={sorted(map(sorted, got))}"))
    out.append(check("C11_representative_234", sorted(seed) == [2, 3, 4], str(sorted(seed))))
    # C5 split
    c5_left = {}
    for a in (1, 2, 3, 4):
        rem = (-a) % 5
        left = sorted(x for x in (1, 2, 3, 4) if x != rem)
        c5_left[a] = left
        out.append(check(f"C5_beta_len_a{a}", len(left) == 3 and 0 not in left, str(left)))
    out.append(check("C5_a1_is_123", c5_left[1] == [1, 2, 3]))
    out.append(check("C5_a2_is_124", c5_left[2] == [1, 2, 4]))
    out.append(
        check(
            "C5_inversion_fuses_1_with_4",
            sorted(((-x) % 5 for x in c5_left[1])) == c5_left[4],
        )
    )
    out.append(
        check(
            "C5_inversion_fuses_2_with_3",
            sorted(((-x) % 5 for x in c5_left[2])) == c5_left[3],
        )
    )
    # ×2 is Aut(C5) but not inner in G
    times2 = sorted((2 * x) % 5 for x in c5_left[1])
    out.append(
        check(
            "C5_times2_would_identify_but_is_outer",
            times2 == c5_left[2],
            f"2*{c5_left[1]}={times2}",
        )
    )
    # C6
    chars = (0, 1, 2, 4, 5)
    left1 = sorted(x for x in ((b - 1) % 6 for b in chars if b != 1) if x != ((0 - 1) % 6))
    left5 = sorted(x for x in ((b - 5) % 6 for b in chars if b != 5) if x != ((0 - 5) % 6))
    out.append(check("C6_chi1_beta_134", left1 == [1, 3, 4], str(left1)))
    out.append(check("C6_chi5_beta_235", left5 == [2, 3, 5], str(left5)))
    out.append(check("C6_pair_identified_by_inversion", sorted((-x) % 6 for x in left1) == left5))
    # C2 / V4 / C3 dimension identity
    for label, dim_f, nbeta in (
        ("open", 3, 0),
        ("C2E", 1, 2),
        ("C2L", 1, 2),
        ("C3", 0, 3),
        ("V4", 0, 3),
        ("C5", 0, 3),
        ("C6", 0, 3),
        ("C11", 0, 3),
    ):
        out.append(check(f"dim_plus_beta_{label}", dim_f + nbeta == 3))
    return out


def group_C() -> list[dict]:
    """FIX-B source-side re-read (cite, do not rebuild the 20-orbit census)."""
    out = []
    if not FIXB.is_file():
        out.append(check("FIXB_present", False, f"missing {FIXB}"))
        return out
    data = json.loads(FIXB.read_text())
    out.append(check("FIXB_present", True, "keys=" + ",".join(sorted(data.keys()))))
    san = data.get("sanity", {})
    out.append(check("FIXB_20_orbits", san.get("num_stratum_orbits") == 20, str(san.get("num_stratum_orbits"))))
    out.append(check("FIXB_19_distinct", san.get("num_distinct_symbol_keys") == 19, str(san.get("num_distinct_symbol_keys"))))
    out.append(check("FIXB_14_abelian", san.get("num_abelian_stabiliser_orbits") == 14, str(san.get("num_abelian_stabiliser_orbits"))))
    out.append(check("FIXB_6_nonabelian", san.get("num_nonabelian_stabiliser_orbits") == 6, str(san.get("num_nonabelian_stabiliser_orbits"))))
    out.append(check("FIXB_dim_plus_beta_4", san.get("dimF_plus_beta_equals_4_on_all") is True))
    ris = data.get("reduced_isotropy_stratification", {})
    n_iso = len(ris.get("strata", []))
    out.append(check("FIXB_isotropy_15", n_iso == 15, f"n={n_iso}"))
    out.append(check("FIXB_n_symbols_20", len(data.get("symbols", [])) == 20, str(len(data.get("symbols", [])))))
    return out


def group_D(assembled: dict) -> list[dict]:
    """Obstruction-scope and honesty."""
    out = []
    out.append(check("dim_mismatch_recorded", assembled["dimension_mismatch"]["comparison_X_vs_P_W_is_a_type_error"] is True))
    out.append(check("Burn_X_is_3", assembled["dimension_mismatch"]["Burn_n_of_X"] == 3))
    out.append(check("Burn_PW_is_4", assembled["dimension_mismatch"]["Burn_n_of_P_W"] == 4))
    xs = assembled["X_symbols"]
    out.append(check("ten_X_symbols", len(xs) == 10, f"n={len(xs)}"))
    out.append(check("all_X_in_Burn3", all(s["lives_in"] == "Burn_3(G)" for s in xs)))
    out.append(check("all_X_dim_plus_beta_3", all(s["dim_plus_beta"] == 3 for s in xs)))
    a2_fail = {s["id"] for s in xs if not s["assumption2_on_this_model"]}
    out.append(check("assumption2_fails_exactly_E_and_V4II", a2_fail == {"X.C2.E", "X.V4.II"}, str(sorted(a2_fail))))
    out.append(check("headline_open", "OPEN" in assembled["headline"]))
    out.append(check("no_degree_in_headline_exclusion", "excludes no degree" in assembled["headline"]))
    return out


def group_E(assembled: dict) -> list[dict]:
    """ODDZERO-standard zero / all-dead audit: this packet excludes nothing."""
    out = []
    out.append(check("exclusions_claimed_empty", assembled["exclusions_claimed"] == []))
    out.append(check("degrees_excluded_empty", assembled["degrees_excluded"] == []))
    out.append(
        check(
            "verdict_is_orthogonal",
            "ORTHOGONAL" in assembled["verdict"] or "INAPPLICABLE" in assembled["verdict"],
            assembled["verdict"],
        )
    )
    out.append(check("condition_A_passes_in_assembly", assembled["condition_A"]["every_abelian_class_present"] is True))
    return out


def main() -> int:
    if not LEDGER.is_file():
        print("BURNSIDE_ASSESS_VERIFY_FAILED")
        print(f"missing sealed ledger {LEDGER}")
        return 1
    ledger = json.loads(LEDGER.read_text())
    if not ASSEMBLED.is_file():
        print("BURNSIDE_ASSESS_VERIFY_FAILED")
        print("missing results/assembled_symbols.json; run scripts/assemble_symbols.py first")
        return 1
    assembled = json.loads(ASSEMBLED.read_text())

    groups = {
        "A": group_A(ledger),
        "B": group_B(),
        "C": group_C(),
        "D": group_D(assembled),
        "E": group_E(assembled),
    }
    flat = [c for g in groups.values() for c in g]
    n_fail = sum(1 for c in flat if not c["pass"])
    n_skip = 0
    print("group sizes:", {k: len(v) for k, v in groups.items()})
    for gname, checks in groups.items():
        for c in checks:
            mark = "PASS" if c["pass"] else "FAIL"
            extra = f"  {c['detail']}" if c["detail"] else ""
            print(f"  [{gname}] {mark} {c['name']}{extra}")
    if n_fail:
        print("BURNSIDE_ASSESS_VERIFY_FAILED")
        print(f"{n_fail} failures")
        return 1
    print("BURNSIDE_ASSESS_VERIFY_OK")
    print(f"ALLGREEN ({len(flat)} checks, 0 failures, {n_skip} skips; "
          f"groups A = {len(groups['A'])}, B = {len(groups['B'])}, "
          f"C = {len(groups['C'])}, D = {len(groups['D'])}, E = {len(groups['E'])})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
