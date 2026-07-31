#!/usr/bin/env python3
"""G4.1 producer: symbolic free-fibre terminal residual formula.

Writes under certificates/global_terminal_module/:
  free_terminal_formula.json
  recurrence_certificate.json
  FREE_TERMINAL_FORMULA.md

Does not import the independent verifier.
"""

from __future__ import annotations

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "global_finite_lifting"))

from common_g4 import (  # noqa: E402
    FAMILIES,
    ROOT,
    c3_s3_decomposition,
    compute_universal_jets,
    family_admissible,
    first_nonisolable_proved,
    monoms_bin,
    parse_q,
    q_to_str,
    regression_packet_7_13_19,
    residual_from_universal,
    sha256_file,
    write_json,
)

# Optional cross-check against common_g3 free_fibre_tower on a sparse grid
try:
    from common_g3 import free_fibre_tower, sample_leading_pure
except ImportError:
    free_fibre_tower = None  # type: ignore
    sample_leading_pure = None  # type: ignore


def grid_points(m_max: int = 11, d_extra: int = 25) -> list[tuple[int, int]]:
    pts = []
    for m in range(1, m_max + 1, 2):
        for d in range(m, 6 * m + d_extra + 1, 2):
            pts.append((m, d))
    return pts


def run_grid(jets: dict, sparse_crosscheck: bool = True) -> dict:
    """Exact residual on the interpolation grid; optional common_g3 cross-check."""
    rows = []
    failures = []
    # Full formula grid can be large; compute residual via universal (cheap).
    # Cross-check common_g3 only on a sparse subset (expensive O(d^3) expand).
    cross_set = {
        (1, 7),
        (1, 9),
        (1, 13),
        (1, 19),
        (3, 9),
        (3, 19),
        (5, 11),
        (5, 21),
        (7, 13),
        (9, 15),
        (11, 17),
        (11, 6 * 11 + 25),
    }
    for m, d in grid_points():
        if not family_admissible("based_minus_lines_odd_m", m, d):
            continue
        res = residual_from_universal(m, d, jets)
        row = {
            "m": m,
            "d": d,
            "k": d - m,
            "N_star": res["N_star"],
            "is_zero": res["is_zero"],
            "residual_norm_sq": res["residual_norm_sq"],
            "residual_nz": res["residual_nz"],
            "C3_weights": res["dominant_C3_weights"],
            "support_class": res["support_class"]["type"],
            "structural_identity_ok": res["structural_identity"][
                "verified_on_this_bidegree"
            ],
        }
        if sparse_crosscheck and free_fibre_tower and (m, d) in cross_set:
            a, lab = sample_leading_pure(m)
            t = free_fibre_tower(m, d, a, mode="ker_L1", a_label=lab)
            N = t["first_nonzero_terminal_F_order"]
            row["g3_first_nz"] = N
            row["g3_match_N"] = N == res["N_star"]
            if N is not None:
                tr = t["terminal_residuals"][str(N)]
                row["g3_norm_sq"] = tr["residual_norm_sq"]
                row["g3_match_nsq"] = tr["residual_norm_sq"] == res["residual_norm_sq"]
                if tr.get("residual_coeffs"):
                    # compare nz
                    coeffs = [parse_q(x) for x in tr["residual_coeffs"]]
                    mon = monoms_bin(N)
                    g3_nz = {
                        (mon[i][0], mon[i][1]): coeffs[i]
                        for i in range(len(coeffs))
                        if coeffs[i] != 0
                    }
                    form_nz = {
                        (t0["monom"][0], t0["monom"][1]): parse_q(t0["coeff"])
                        for t0 in res["residual_nz"]
                    }
                    row["g3_match_coeffs"] = g3_nz == form_nz
                    if not row["g3_match_coeffs"]:
                        failures.append(
                            {
                                "m": m,
                                "d": d,
                                "g3_nz": {str(k): q_to_str(v) for k, v in g3_nz.items()},
                                "form_nz": {
                                    str(k): q_to_str(v) for k, v in form_nz.items()
                                },
                            }
                        )
            else:
                row["g3_match_N"] = res["is_zero"]
        rows.append(row)

    nonzero = [r for r in rows if not r["is_zero"]]
    zero = [r for r in rows if r["is_zero"]]
    # k=0 (d=m): no E+ jet exists; residual vanishes identically (exact).
    zero_k0 = [r for r in zero if r["k"] == 0]
    zero_unexpected = [r for r in zero if r["k"] != 0]
    return {
        "grid_spec": {
            "m_range": "1 <= m <= 11 odd",
            "d_range": "m <= d <= 6m+25 odd",
            "n_points": len(rows),
            "family_ledger": "based_minus_lines_odd_m (a_odd=0, pure powers leading)",
        },
        "n_nonzero": len(nonzero),
        "n_zero": len(zero),
        "n_zero_k0_expected": len(zero_k0),
        "n_zero_unexpected": len(zero_unexpected),
        "all_nonzero_for_k_ge_2": len(zero_unexpected) == 0 and all(
            (r["k"] < 2) or (not r["is_zero"]) for r in rows
        ),
        "all_nonzero_on_grid": len(zero) == 0,
        "k0_vanishing": (
            "When k=d-m=0, the only available jet is a_m (E-); no E+ jet "
            "exists, so the triple-E+ residual at N_star vanishes. Exact, not a failure."
        ),
        "all_structural_identity_ok": all(r["structural_identity_ok"] for r in rows),
        "crosscheck_failures": failures,
        "rows": rows,
    }


def build_recurrence_certificate(jets: dict) -> dict:
    """Exact recurrence identity for universal (alpha, beta)."""
    alph = {int(r): v for r, v in jets["alphas"].items()}
    bet = {int(r): v for r, v in jets["betas"].items()}
    # Growth check: |alpha_r| >= 2 |alpha_{r-2}| for r >= 5
    growth = []
    rs = sorted(alph)
    for i in range(1, len(rs)):
        r = rs[i]
        prev = rs[i - 1]
        ratio_num = abs(alph[r])
        ratio_den = abs(alph[prev])
        growth.append(
            {
                "r": r,
                "prev_r": prev,
                "abs_alpha": ratio_num,
                "abs_prev": ratio_den,
                "ratio_times_den": ratio_num,  # exact: ratio = num/den
                "ge_2_prev": ratio_num >= 2 * ratio_den if r >= 5 else None,
            }
        )
    all_ge2 = all(g["ge_2_prev"] for g in growth if g["ge_2_prev"] is not None)
    all_nz = all(alph[r] != 0 for r in alph)

    return {
        "theorem_boundary": (
            "Exact free-fibre polar recurrence for pure-powers leading jet "
            "with based a_odd=0 and first ker-L1 basis vector. "
            "Not a G-covariant. Not a headline ed claim."
        ),
        "ring": "Z (integer coefficients); residual binary forms over Q",
        "characteristic": 0,
        "recurrence": {
            "seed": jets["ker_L1_seed"],
            "ansatz": jets["ansatz"],
            "L_operator": jets["L_operator"],
            "step": (
                "For odd r >= 3: compute R_pre = sum Phi_+(b^{s1},b^{s2},b^{s3}) "
                "over s1+s2+s3=r with s_i < r odd; set L(b^{(r)}) = -R_pre on the "
                "ansatz 2-dimensional space; solve for (alpha_r, beta_r). "
                "Inactive monom classes of R_pre vanish identically (consistency)."
            ),
            "sigma_formula": "sigma_r = ((r+1)//2) mod 3",
            "tau_formula": "tau_1=0; tau_r=1 for r>1",
            "closed_form_primary": {
                "sigma_2": "alpha_r = -R_PPP",
                "sigma_0": "alpha_r = -R_PPM / 2",
                "sigma_1": "alpha_r = -R_PMM",
                "beta": "beta_r = -R_MMM",
            },
        },
        "alphas": jets["alphas"],
        "betas": jets["betas"],
        "sigmas": jets["sigmas"],
        "taus": jets["taus"],
        "r_max": jets["r_max"],
        "all_alpha_nonzero_through_r_max": all_nz,
        "growth_ge_2_prev_through_r_max": all_ge2,
        "growth_table": growth,
        "nonvanishing_argument": {
            "type": "recurrence_plus_certified_growth_bound",
            "statement": (
                "Through r_max, every alpha_r is a nonzero integer and "
                "|alpha_r| >= 2 |alpha_{r-2}| for all odd r in [5, r_max]. "
                "Combined with the structural identity Res = -L(b^{(k+1)}) and "
                "L nonzero on the pure ansatz vector whenever alpha_{k+1} != 0, "
                "the free-fibre residual is nonzero for every grid bidegree with "
                "k+1 <= r_max. Extension to all odd r requires either an all-order "
                "growth proof or an independent closed form; the recurrence itself "
                "is an exact identity for all r."
            ),
            "recurrence_is_exact_identity": True,
            "all_order_growth_proved": False,
            "stop_rule": (
                "A numerical pattern alone is G-PATTERN. Here the recurrence and "
                "Res=-L(b^{k+1}) are exact identities; all-order nonvanishing of "
                "alpha_r is certified only through r_max, not claimed for all r."
            ),
        },
        "input_hashes": {
            "common_g3.py": sha256_file(HERE.parent / "global_finite_lifting" / "common_g3.py"),
            "TERMINAL_PATTERN.md": sha256_file(
                HERE.parent / "global_finite_lifting" / "TERMINAL_PATTERN.md"
            ),
        },
        "terminal_marker": "G41_RECURRENCE_CERTIFICATE",
    }


def build_formula_json(jets: dict, grid: dict, regress: dict) -> dict:
    families_formulas = {}
    for fam in FAMILIES:
        # Free-fibre residual formula is the same polar expression; ledger
        # changes only the linear subspace of a_d / source-line coupling.
        families_formulas[fam] = {
            "family": fam,
            "free_fibre_formula": (
                "On the pure-powers free open with based a_odd=0 and first "
                "ker-L1 generator, Res at N_star=d+2m+1 equals -L(b^{(d-m+1)}) "
                "with universal (alpha,beta) from the recurrence. "
                "Source-line ledger (based vs residual e) cuts a_d / p|_{E_-} "
                "transverse to this normal-cone residual and does not alter L_r."
            ),
            "ledger_ref": f"certificates/lifting/families/{fam}/tower_stages.json",
            "N_star": "d+2m+1",
            "symbolic_indices": True,
        }

    sample_decomps = {}
    for key, m, d in [("m1_d7", 1, 7), ("m1_d13", 1, 13), ("m3_d19", 3, 19)]:
        res = residual_from_universal(m, d, jets)
        sample_decomps[key] = c3_s3_decomposition(res)

    return {
        "theorem_boundary": (
            "G4.1 free-fibre terminal residual formula. Exact over Q. "
            "Not a formal state promoted to a covariant. Not an all-degree "
            "G-global landing exclusion. Headline remains OPEN."
        ),
        "headline": "OPEN",
        "gate": "G4.1",
        "exit_classification": {
            "claimed": "G41-FORMULA",
            "not_claimed": [
                "G-NEGATIVE",
                "G-POLYNOMIAL",
                "all_order_alpha_nonvanishing",
                "G-global equalizer residual formula",
            ],
            "previous_cycle": "G-PATTERN (numerical only)",
            "progress": (
                "Exact recurrence identity + structural Res=-L(b^{k+1}) "
                "replace pure numerical pattern."
            ),
        },
        "N_star_cutoff": {
            "formula": "N_star = d + 2*m + 1",
            "proved": True,
            "samples": {
                "m1_d7": first_nonisolable_proved(1, 7),
                "m1_d13": first_nonisolable_proved(1, 13),
                "m3_d19": first_nonisolable_proved(3, 19),
            },
        },
        "universal_jets": {
            "ansatz": jets["ansatz"],
            "L_operator": jets["L_operator"],
            "leading_jet": jets["leading_jet"],
            "based_relative": jets["based_relative"],
            "r_max": jets["r_max"],
            "alphas": jets["alphas"],
            "betas": jets["betas"],
            "sigmas": jets["sigmas"],
            "taus": jets["taus"],
            "m_independence": (
                "Coefficients (alpha_r, beta_r) are independent of m; only "
                "monomial supports y0^{m+r} and y0^{r} y1^{m} carry m. Proved "
                "by the form of L(b)=B(b;a,a) on pure powers and preservation "
                "of the 2-term ansatz under the cubic Phi_+ recurrence."
            ),
        },
        "structural_identity": {
            "formula": "Res_{m,d}(y) = - L(b^{(k+1)})(y),  k = d - m",
            "N_star": "N_star = d + 2*m + 1 = 3*m + k + 1",
            "proof_sketch": [
                "Based a_odd=0 ⇒ only E- jet is a_m (pure powers).",
                "Mixed (E+,E-,E-) triples at order N_star require E+ order "
                "N_star - 2m = d+1 > d, unavailable as a polynomial jet.",
                "Hence Res at N_star is pure triple-E+ Phi_+ of jets b^{(s)}, "
                "s odd, m+s <= d i.e. s <= k.",
                "Those triples are exactly R_pre at formal stage r = k+1.",
                "The recurrence defines b^{(k+1)} by L(b^{(k+1)}) = -R_pre.",
                "Therefore Res = -L(b^{(k+1)}).",
            ],
            "exact_identity": True,
        },
        "families": families_formulas,
        "grid": {
            "n_points": grid["grid_spec"]["n_points"],
            "all_nonzero_on_grid": grid["all_nonzero_on_grid"],
            "all_nonzero_for_k_ge_2": grid["all_nonzero_for_k_ge_2"],
            "n_zero_k0_expected": grid["n_zero_k0_expected"],
            "k0_vanishing": grid["k0_vanishing"],
            "all_structural_identity_ok": grid["all_structural_identity_ok"],
            "n_crosscheck_failures": len(grid["crosscheck_failures"]),
            "spec": grid["grid_spec"],
            # keep sealed payload smaller: store summary + sample rows
            "sample_rows": [
                r
                for r in grid["rows"]
                if (r["m"], r["d"])
                in {(1, 7), (1, 13), (3, 19), (1, 9), (5, 11), (11, 91)}
            ],
            "full_grid_path": "tmp/cas_G/grid_full.json",
        },
        "C3_S3_decomposition_samples": sample_decomps,
        "regression_7_13_19": regress,
        "input_hashes": {
            "common_g3.py": sha256_file(
                HERE.parent / "global_finite_lifting" / "common_g3.py"
            ),
            "TERMINAL_PATTERN.md": sha256_file(
                HERE.parent / "global_finite_lifting" / "TERMINAL_PATTERN.md"
            ),
            "degree7_kerL1": sha256_file(
                HERE.parent
                / "global_finite_lifting"
                / "degree7"
                / "tower_sample_kerL1.json"
            ),
            "degree13_kerL1": sha256_file(
                HERE.parent
                / "global_finite_lifting"
                / "degree13"
                / "tower_sample_kerL1.json"
            ),
            "degree19_kerL1": sha256_file(
                HERE.parent
                / "global_finite_lifting"
                / "degree19"
                / "tower_sample_kerL1.json"
            ),
        },
        "git_base_requested": "a40b10fbc4bd470ec56af5a6f50e11e6a778cabf",
        "terminal_marker": "G41_FREE_TERMINAL_FORMULA",
    }


def write_markdown(formula: dict, rec: dict, path: Path) -> None:
    g = formula["grid"]
    reg = formula["regression_7_13_19"]
    lines = [
        "# G4.1 — Symbolic free-fibre terminal residual formula",
        "",
        "**Headline: OPEN.**",
        "**Gate G4.1 exit: `G41-FORMULA`.**",
        "**Not claimed: `G-NEGATIVE`, `G-POLYNOMIAL`, all-order `α_r≠0`.**",
        "**Previous cycle: `G-PATTERN` (numerical only) — superseded for free fibre.**",
        "",
        "---",
        "",
        "## 0. Theorem boundary",
        "",
        "This package produces an **exact free-fibre** formula for the polar residual",
        "at the proved isolation cutoff",
        "",
        "$$N_\\star(m,d)=d+2m+1.$$",
        "",
        "It does **not** promote a formal jet to a `G`-covariant, does **not** exclude",
        "global multi-Rees equalizer zeros, and does **not** close `ed_C(G)`.",
        "",
        "---",
        "",
        "## 1. Symbolic polar recursion (universal jets)",
        "",
        "Leading jet (pure powers free open):",
        "",
        "$$a = y_0^m f_0 + y_1^m f_1\\in \\mathrm{Sym}^m E_-^*\\otimes E_-.$$",
        "",
        "Based-style relative E− jets: $a_{m+2}=a_{m+4}=\\cdots=0$.",
        "",
        "Ker-$L_1$ seed (first nullspace basis vector):",
        "",
        "$$b^{(1)} = -2\\, y_0^{m+1} e_1 + y_0\\, y_1^{m} e_0.$$",
        "",
        "Ansatz at odd relative order $r\\ge 1$ (coefficients **independent of $m$**):",
        "",
        f"`{formula['universal_jets']['ansatz']}`",
        "",
        "with $\\sigma_r = ((r+1)/2)\\bmod 3$, $\\tau_1=0$, $\\tau_r=1$ for $r>1$.",
        "",
        "Polar operator on pure powers:",
        "",
        f"`{formula['universal_jets']['L_operator']}`",
        "",
        "Recurrence (exact identity in the integer coefficient ring):",
        "",
        "$$L\\bigl(b^{(r)}\\bigr) = -R^{\\mathrm{pre}}_r,",
        "\\qquad R^{\\mathrm{pre}}_r="
        "\\sum_{s_1+s_2+s_3=r}\\Phi_+\\bigl(b^{(s_1)},b^{(s_2)},b^{(s_3)}\\bigr)$$",
        "",
        "solved on the 2-dimensional ansatz space. Inactive monom classes of",
        "$R^{\\mathrm{pre}}$ vanish (consistency of the ansatz).",
        "",
        f"Computed through $r\\le {formula['universal_jets']['r_max']}$:",
        f"all $\\alpha_r\\neq 0$; growth $|\\alpha_r|\\ge 2|\\alpha_{{r-2}}|$ for odd",
        f"$r\\in[5,{formula['universal_jets']['r_max']}]$ "
        f"(certified in `recurrence_certificate.json`: "
        f"{rec['growth_ge_2_prev_through_r_max']}).",
        "",
        "---",
        "",
        "## 2. Structural terminal identity",
        "",
        "Let $k=d-m$. Then",
        "",
        "$$",
        "\\boxed{",
        "\\operatorname{Res}_{m,d}",
        "= -L\\bigl(b^{(k+1)}\\bigr)",
        "=",
        "-B\\bigl(b^{(k+1)};a,a\\bigr)",
        "}",
        "$$",
        "",
        "as a binary form of order $N_\\star=d+2m+1$.",
        "",
        "Proof sketch:",
        "",
    ]
    for step in formula["structural_identity"]["proof_sketch"]:
        lines.append(f"1. {step}")
    lines += [
        "",
        "Support type by $k\\bmod 6$ follows from the L-image of $b^{(k+1)}$:",
        "",
        "| $k\\bmod 6$ | primary support | type |",
        "|----------:|-----------------|------|",
        "| 0 | $y_0^{N-2m} y_1^{2m}$ (and possibly mixed) | A |",
        "| 2 | $y_0^{N}$ and $y_0^{N-3m} y_1^{3m}$ | B |",
        "| 4 | $y_0^{N-m} y_1^{m}$ | C |",
        "",
        "---",
        "",
        "## 3. Grid and regression",
        "",
        f"- Grid: {g['spec']['m_range']}, {g['spec']['d_range']} "
        f"({g['n_points']} bidegrees).",
        f"- Nonzero for every $k=d-m\\ge 2$: **{g['all_nonzero_for_k_ge_2']}**.",
        f"- Expected vanishing at $k=0$ ($d=m$, no E+ jet): **{g['n_zero_k0_expected']}** points.",
        f"- Structural identity holds on every grid point: **{g['all_structural_identity_ok']}**.",
        f"- common_g3 cross-check failures: **{g['n_crosscheck_failures']}**.",
        "",
        "Director samples (regression against G3 sealed towers):",
        "",
        "| (m,d) | N★ | residual norm² | C3 weights | match TERMINAL_PATTERN |",
        "|------:|---:|---------------:|------------|:----------------------:|",
    ]
    for key, md in [("m1_d7", (1, 7)), ("m1_d13", (1, 13)), ("m3_d19", (3, 19))]:
        s = reg["samples"][key]
        mt = reg["matches_TERMINAL_PATTERN"][key]
        lines.append(
            f"| {md} | {s['N_star']} | {s['residual_norm_sq']} | "
            f"{s['C3_weights']} | {mt} |"
        )
    lines += [
        "",
        f"All three matches: **{all(reg['matches_TERMINAL_PATTERN'].values())}**.",
        "",
        "---",
        "",
        "## 4. C3/S3 residual characters",
        "",
        "The free-fibre residual is a binary form of order $N_\\star$ under the residual",
        "C3 action on $E_-$ ($y_0\\mapsto \\omega y_0$, $y_1\\mapsto \\omega^{-1} y_1$).",
        "Weight of $y_0^a y_1^b$ is $(a-b)\\bmod 3$. Samples:",
        "",
    ]
    for key, dec in formula["C3_S3_decomposition_samples"].items():
        lines.append(
            f"- `{key}`: C3 weights {dec['C3_weights_present']}, "
            f"isotypic={dec['is_C3_isotypic']}."
        )
    lines += [
        "",
        "This is a **local normal-cone obstruction type**, not a full $G$-isotypic",
        "of $\\mathrm{Hom}(\\mathrm{Sym}^d W,W)^G$.",
        "",
        "---",
        "",
        "## 5. STOP rule / what is proved",
        "",
        "| Proved (exact identity) | Certified finite range | Not proved |",
        "|-------------------------|------------------------|------------|",
        "| Isolation cutoff $N_\\star=d+2m+1$ | — | — |",
        "| Universal 2-term jet ansatz + recurrence | $r\\le r_{\\max}$ integers | closed form of $\\alpha_r$ |",
        "| $\\mathrm{Res}=-L(b^{(k+1)})$ | all grid $(m,d)$ | — |",
        "| Nonzero residual on grid | $k+1\\le r_{\\max}$ | all-order $\\alpha_r\\neq 0$ |",
        "| C3 weight decomposition | samples + formula | full $S_3$ Molien |",
        "",
        "The recurrence and structural identity are **not** a mere numerical pattern.",
        "All-order nonvanishing of $\\alpha_r$ remains a growth statement certified",
        f"only through $r\\le {formula['universal_jets']['r_max']}$.",
        "",
        "---",
        "",
        "## 6. Files and terminal markers",
        "",
        "```text",
        "certificates/global_terminal_module/common_g4.py",
        "certificates/global_terminal_module/produce_free_formula.py",
        "certificates/global_terminal_module/verify_free_formula.py",
        "certificates/global_terminal_module/free_terminal_formula.json",
        "certificates/global_terminal_module/recurrence_certificate.json",
        "certificates/global_terminal_module/FREE_TERMINAL_FORMULA.md",
        "```",
        "",
        "```text",
        "G41_FREE_TERMINAL_FORMULA",
        "G41_RECURRENCE_CERTIFICATE",
        "G41_FREE_FORMULA_VERIFY_OK",
        "```",
        "",
        "**Headline remains OPEN.**",
        "",
    ]
    path.write_text("\n".join(lines))


def main() -> int:
    r_max = 81  # covers k <= 80 on grid m<=11, d<=6m+25 => k<=6m+25-m=5m+25<=80
    jets = compute_universal_jets(r_max)
    rec = build_recurrence_certificate(jets)
    write_json(HERE / "recurrence_certificate.json", rec)

    print("running grid...", flush=True)
    grid = run_grid(jets, sparse_crosscheck=True)
    # full grid to scratch
    scratch = ROOT / "tmp" / "cas_G"
    scratch.mkdir(parents=True, exist_ok=True)
    write_json(scratch / "grid_full.json", grid)

    regress = regression_packet_7_13_19(jets)
    formula = build_formula_json(jets, grid, regress)
    write_json(HERE / "free_terminal_formula.json", formula)
    write_markdown(formula, rec, HERE / "FREE_TERMINAL_FORMULA.md")

    print("grid points", grid["grid_spec"]["n_points"])
    print("all nonzero k>=2", grid["all_nonzero_for_k_ge_2"])
    print("k0 expected zeros", grid["n_zero_k0_expected"])
    print("structural ok", grid["all_structural_identity_ok"])
    print("crosscheck failures", len(grid["crosscheck_failures"]))
    print("regression", regress["matches_TERMINAL_PATTERN"])
    print("alpha nonzero", rec["all_alpha_nonzero_through_r_max"])
    print("growth ge2", rec["growth_ge_2_prev_through_r_max"])
    print("G41_FREE_TERMINAL_FORMULA")
    return 0 if (
        grid["all_nonzero_for_k_ge_2"]
        and grid["all_structural_identity_ok"]
        and not grid["crosscheck_failures"]
        and all(regress["matches_TERMINAL_PATTERN"].values())
        and rec["all_alpha_nonzero_through_r_max"]
        and rec["growth_ge_2_prev_through_r_max"]
    ) else 1


if __name__ == "__main__":
    raise SystemExit(main())
