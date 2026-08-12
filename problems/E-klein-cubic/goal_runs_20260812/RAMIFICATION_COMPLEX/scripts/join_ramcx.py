"""Join the ramification layer onto the tuple-level J census.

Semantics (TUPLE_JOINT_RESIDUE):
  J(ρ) = sealed joint count at d ≡ ρ (mod 6).
  J_ram(ρ) = count after removing patterns that use a value option declared
             DEAD by the degree-free ramification filter, OR (for cyclic
             immune rows) that have no admissible (χ→χ′,k) assignment for
             ANY d ≡ ρ (mod 6).

Discipline:
  * A class ZERO is FLAG, never claim; ODDZERO-standard audit is the gate.
  * STAGE2 map-level pinning is NOT re-imposed (tuple level only).
  * Anchor: J_ram ≤ J; triv without ram = sealed J.

Because the sealed J count normalises out the immune factor IMM1, a kill on
an immune row multiplies the reported J by (live_values/n_values) only when
the kill is uniform across the free block.  Sweep-row kills in the σ-band
would require a coherent re-count; this packet records:

  (A) degree-free dead values (no d admits an assignment) — structural
  (B) per-residue dead values on cyclic immune rows (no d≡ρ admits)
  (C) the resulting multiplicative upper bound J_ram_bound(ρ) ≤ J(ρ)

If no structural kill fires, J_ram = J (ramification free on the J census).
"""
from __future__ import annotations

import json
import os
from collections import defaultdict

import paths
from weight_rule import admissible_assignment, SPECTRUM, onX_weights
from conormal_tables import (
    load_layer1, build_s2_index, value_weights_for_cell, cells_of_row,
)


def residue_class_has_assignment(n, base, conormal_cs, a_values, rho, kmax=8,
                                  modulus=6, dmax=66):
    """True iff some d ≡ rho (mod modulus), d ≤ dmax, and some a_val in
    a_values admits a weight-rule assignment.
    """
    for d in range(rho, dmax + 1, modulus):
        w_tang = (d * base) % n
        for a_val in a_values:
            if admissible_assignment(n, w_tang, conormal_cs, a_val, kmax=kmax):
                return True
    return False


def per_residue_immune_status(s2map, kmax=8):
    """For each immune cyclic row and each ρ mod 6: which value cells live."""
    layer = load_layer1(331)
    by_id = {r["id"]: r for r in layer["rows"]}
    out = {}
    for rid in paths.IMMUNE_ROWS:
        s2 = s2map[rid]
        n, base, chain = s2["n"], s2["base"], list(s2["chain"])
        row = by_id[rid]
        per_rho = {}
        for rho in range(6):
            live_cells = []
            dead_cells = []
            for cell, idx in cells_of_row(row):
                vw = value_weights_for_cell(cell, n)
                if vw is None:
                    live_cells.append(cell)
                    continue
                ok = residue_class_has_assignment(
                    n, base, chain, vw, rho, kmax=kmax)
                if ok:
                    live_cells.append("%s#%d" % (cell, idx))
                else:
                    dead_cells.append("%s#%d" % (cell, idx))
            n_opts = row["nvals"]
            n_live = n_opts - len(dead_cells)
            # free-block factor for this row
            per_rho[rho] = dict(
                n_opts=n_opts,
                n_live=n_live,
                n_dead=len(dead_cells),
                dead_cells=dead_cells,
                live_cells=live_cells,
                factor_live=n_live,   # replaces n_opts in the free product
                factor_all=n_opts,
            )
        out[rid] = dict(
            n=n, base=base, chain=chain, name=s2["name"],
            per_rho={str(r): per_rho[r] for r in range(6)},
        )
    return out


def immune_factor_ratio(status, rho):
    """∏_rows (n_live / n_opts) over immune rows at residue rho.

    Sealed J already divides by IMM1 = ∏ n_opts; if some values die, the
    surviving immune contribution is ∏ n_live, so
        J_ram_bound = J * ∏ (n_live / n_opts).
    """
    num, den = 1, 1
    detail = []
    for rid, info in status.items():
        pr = info["per_rho"][str(rho)]
        n_live, n_opts = pr["n_live"], pr["n_opts"]
        num *= max(n_live, 0)
        den *= n_opts
        if n_live < n_opts:
            detail.append(dict(rid=rid, n_live=n_live, n_opts=n_opts,
                               dead=pr["dead_cells"]))
    return num, den, detail


def join_counts(status):
    """Per residue: sealed J, ram-bound, cut, zero flag."""
    rows = []
    zeros = []
    for rho in range(6):
        J = paths.J_TABLE[rho]
        num, den, detail = immune_factor_ratio(status, rho)
        # exact rational J * num/den ; keep integer when divisible
        assert den > 0
        if (J * num) % den == 0:
            J_ram = (J * num) // den
        else:
            # should not happen: J is integer count of patterns already
            # normalised by full IMM1; num/den is the surviving fraction
            J_ram = (J * num) // den  # floor; flag if not exact
        cut = J - J_ram
        zero = (J_ram == 0)
        if zero:
            zeros.append(rho)
        rows.append(dict(
            d_mod6=rho,
            J_sealed=J,
            K_sealed=paths.K_TABLE[rho],
            J_ram=J_ram,
            cut=cut,
            immune_live_product=num,
            immune_all_product=den,
            ratio_num=num,
            ratio_den=den,
            killed_rows=detail,
            zero=zero,
            FLAG_zero=("FLAG: class-at-infinity zero — never claim; "
                       "ODDZERO-standard audit is the promotion gate"
                       if zero else None),
        ))
    return rows, zeros


def run_join(kmax=8):
    s2map = build_s2_index()
    status = per_residue_immune_status(s2map, kmax=kmax)
    rows, zeros = join_counts(status)
    # structural degree-free dead values across all d
    structural_dead = []
    for rid, info in status.items():
        # dead at EVERY residue?
        if all(info["per_rho"][str(r)]["n_live"] == 0 for r in range(6)):
            structural_dead.append(rid)
    summary = dict(
        headline="Problem E remains OPEN; this packet excludes no degree.",
        J_sealed=list(paths.J_TABLE),
        K_sealed=list(paths.K_TABLE),
        per_class=rows,
        zeros=zeros,
        any_zero=bool(zeros),
        structural_dead_rows=structural_dead,
        ramification_free=all(r["cut"] == 0 for r in rows),
        anchor_J_reproduced=all(r["J_ram"] <= r["J_sealed"] for r in rows),
        note=("J_ram is the sealed J census multiplied by the surviving "
              "fraction of immune-row value options under the tuple-level "
              "weight rule per residue mod 6.  Sweep-band values have no "
              "degree-free kill (Stage-1 already character-filters them). "
              "No STAGE2 map-level pinning is re-imposed."),
    )
    return status, summary
