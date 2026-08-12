"""Per-row conormal character tables and admissible (χ ↦ χ′, k) assignments.

Tabulates every sweep-capable row and every coherence-immune row of the
STAGE1 census.  Conormal characters come from:
  * STARRED / B-marked normal slots of the sealed terminus frames, matched
    by (K, dim, n_orbit, setwise), and
  * the STAGE2 IMMUNE_ROWS chain data for the 22 odd-order rows (canonical
    relative weights), and
  * spectrum-relative weights for C2 / V4 sweep rows.

Value options are the Stage-1 target cells (sealed layer1).
"""
from __future__ import annotations

import json
import os
import re
from collections import defaultdict

import paths
from weight_rule import (
    SPECTRUM, QR11, pathA_weight, relative_weights, forbidden_relative_weight,
    tangent_characters_X, admissible_assignment, differential_blocks,
    chi_image_weight, onX_weights, multiplicative_rule_label,
)
from s2pin import IMMUNE_ROWS as S2_IMMUNE  # STAGE2 chain data


# ---------------------------------------------------------------------------
# Parse character tokens like "[3/11]", "[1/2]", "[0/2,1/2]", "1"
# ---------------------------------------------------------------------------

def parse_char_token(tok):
    """Return list of (numerator, denominator) pairs, or [('triv',1)]."""
    if tok == "1" or tok == ".":
        return [("triv", 1)]
    m = re.fullmatch(r"\[([^\]]+)\]", tok)
    if not m:
        return [(tok, None)]
    body = m.group(1)
    parts = []
    for piece in body.split(","):
        a, b = piece.split("/")
        parts.append((int(a), int(b)))
    return parts


def char_to_weight(tok, n_default=None):
    """Map a single cyclic character token to an integer weight mod n.

    Multi-character V4 tokens return a tuple of 0/1 bits (χ_z, χ_s style).
    """
    parts = parse_char_token(tok)
    if parts == [("triv", 1)]:
        return 0 if n_default else 0
    if len(parts) == 1 and parts[0][1] is not None:
        a, b = parts[0]
        return a % b
    if all(p[1] == 2 for p in parts):
        # V4 multi-character: return tuple of bits
        return tuple(p[0] % 2 for p in parts)
    return parts


def extract_conormal_from_frame(frame_row):
    """From a terminus stratum row: B-marked normal characters.

    Returns list of character tokens (strings) that are boundary-normal.
    """
    nc = frame_row.get("normal_chars") or []
    out = []
    for entry in nc:
        # entry is [token, mark] with mark in {'.','B'}
        if isinstance(entry, (list, tuple)) and len(entry) >= 2:
            tok, mark = entry[0], entry[1]
            if mark == "B":
                out.append(tok)
        elif isinstance(entry, (list, tuple)) and len(entry) == 1:
            out.append(entry[0])
    # also B-marked weights (the chain slots themselves)
    for entry in frame_row.get("weights") or []:
        if isinstance(entry, (list, tuple)) and len(entry) >= 2 and entry[1] == "B":
            tok = entry[0]
            if tok not in out:
                out.append(tok)
    return out


def load_layer1(p=331):
    path = os.path.join(paths.COMPLEX_RES, "layer1_%d.json" % p)
    with open(path) as f:
        return json.load(f)


def load_terminus(p=331):
    # prefer STAGE1 inputs copy; fall back to TERMINUS_STRATA_PW
    for cand in (
        os.path.join(paths.COMPLEX, "inputs", "terminus_t2_strata.json"),
        os.path.join(paths.TERMINUS, "t2_strata.json"),
    ):
        if os.path.isfile(cand):
            with open(cand) as f:
                return json.load(f)[str(p)]["3"]
    raise FileNotFoundError("terminus t2_strata.json")


def match_terminus_frames(layer_row, terminus_rows):
    """Match STAGE1 row to terminus frames by (K, dim, n_orbit, setwise).

    May return several (V4/C6 have parallel orbits); we keep all and merge
    conormal character multisets.
    """
    K = layer_row["K"]
    dim = layer_row["dim"]
    n = layer_row["n"]
    sw = layer_row["setwise"]
    hits = []
    for t in terminus_rows:
        if (t["K"] == K and t["dim"] == dim and t["n_orbit"] == n
                and t["setwise"] == sw):
            hits.append(t)
    return hits


# ---------------------------------------------------------------------------
# Value-option → receiver weight labels (for cyclic rows)
# ---------------------------------------------------------------------------

# For cyclic odd-order rows the Stage-1 cells are residual orbits of eigenpoints.
# We label value weights by the SPECTRUM onX list.

VALUE_WEIGHTS = {
    # cell → list of admissible g-weights on X
    "P11": list(QR11),
    "P5a": [1, 4],          # one residual C2-orbit (w ↔ w^{-1}); rep weights
    "P5b": [2, 3],
    "P6": [1, 5],
    "P3": [1, 2],           # exact-C3 on eigenlines of weight 1 or 2
    "PI": None,             # V4 — handled separately
    "PII": None,
    "L(onto)": None,        # positive-dim image; no single weight
    "gen.E": None,
    "gen.L": None,
    "X": None,
}


def cells_of_row(layer_row):
    """Expand cells dict into list of (cell, multiplicity) value options."""
    cells = layer_row["cells"]
    opts = []
    for cell, mult in cells.items():
        for i in range(mult):
            opts.append((cell, i))
    return opts


# ---------------------------------------------------------------------------
# Build one row's table
# ---------------------------------------------------------------------------

def cyclic_order_of(K, setwise):
    """Order n of a generator of the pointwise stabiliser H = K."""
    return {"1": 1, "C2": 2, "C3": 3, "V4": 2, "C5": 5, "C6": 6, "C11": 11,
            "D12": 2, "PSL(2,11)": 1}.get(K, 1)


def conormal_weights_cyclic(n, frame_tokens, s2_chain=None):
    """Integer relative weights for a cyclic group of order n."""
    if s2_chain is not None:
        return list(s2_chain)
    ws = []
    for tok in frame_tokens:
        cw = char_to_weight(tok, n)
        if isinstance(cw, int):
            ws.append(cw % n)
        elif isinstance(cw, tuple):
            # V4 multi-char: encode as bit-pattern integer 0..3
            val = 0
            for b in cw:
                val = (val << 1) | b
            ws.append(val)
        # skip unparsed
    return ws


def s2_chain_for_immune(layer_row, s2_index_map):
    """Look up STAGE2 chain for an immune row by rough identity."""
    return s2_index_map.get(layer_row["id"])


def build_s2_index():
    """Map STAGE1 immune row ids → STAGE2 chain relative weights.

    STAGE1 immune ids (free odd-order blocks):
      C3 dim1: 21,22 ; C3 dim0: 29-34 ; C5: 47-56 ; C11: 76-79
    STAGE2 IMMUNE_ROWS order: 4 C11, 8 C5(a/b), 2 D10, 8 C3.
    We match by (n, base, chain) geometry rather than index.
    """
    # Hand match to STAGE1 ids using STAGE2 names + STAGE1 chains.
    # C11 rows 76-79 ↔ four C11 chains c∈{3,5,6,7} over base 9
    # C5 rows: 47,48 = pt_D10 c=1,2; 49-56 = pt_C5 a/b
    # C3 rows: 21,22 dim1; 29,30 dim0; 31-34 <ell_V
    m = {}
    # C11
    c11 = [r for r in S2_IMMUNE if r["n"] == 11]
    for rid, r in zip([76, 77, 78, 79], c11):
        m[rid] = dict(n=11, base=r["base"], chain=list(r["chain"]),
                      name=r["name"], cell=r["cell"])
    # C5: STAGE2 has 8 pt_C5 + 2 pt_D10
    c5 = [r for r in S2_IMMUNE if r["n"] == 5]
    # STAGE1: 47,48 = pt_D10; 49-56 = pt_C5*
    d10 = [r for r in c5 if "D10" in r["name"]]
    c5ab = [r for r in c5 if "D10" not in r["name"]]
    for rid, r in zip([47, 48], d10):
        m[rid] = dict(n=5, base=r["base"], chain=list(r["chain"]),
                      name=r["name"], cell=r["cell"])
    for rid, r in zip(list(range(49, 57)), c5ab):
        m[rid] = dict(n=5, base=r["base"], chain=list(r["chain"]),
                      name=r["name"], cell=r["cell"])
    # C3
    c3 = [r for r in S2_IMMUNE if r["n"] == 3]
    # STAGE2 order: a dim1 c=1, a dim0 c=2, a ell (1,1), a ell (1,2),
    #               b dim1 c=2, b dim0 c=1, b ell (2,2), b ell (2,1)
    # STAGE1: 21,22 dim1 pt_A4; 29,30 dim0 pt_A4; 31-34 pt_A4<ell_V
    c3_dim1 = [r for r in c3 if r["dim"] == 1]
    c3_dim0 = [r for r in c3 if r["dim"] == 0 and len(r["chain"]) == 1]
    c3_ell = [r for r in c3 if len(r["chain"]) == 2]
    for rid, r in zip([21, 22], c3_dim1):
        m[rid] = dict(n=3, base=r["base"], chain=list(r["chain"]),
                      name=r["name"], cell=r["cell"])
    for rid, r in zip([29, 30], c3_dim0):
        m[rid] = dict(n=3, base=r["base"], chain=list(r["chain"]),
                      name=r["name"], cell=r["cell"])
    for rid, r in zip([31, 32, 33, 34], c3_ell):
        m[rid] = dict(n=3, base=r["base"], chain=list(r["chain"]),
                      name=r["name"], cell=r["cell"])
    return m


def value_weights_for_cell(cell, n):
    """Possible absolute g-weights of a Stage-1 value cell under order-n g."""
    if cell in ("P11",):
        return list(QR11)
    if cell == "P5a":
        return [1, 4]
    if cell == "P5b":
        return [2, 3]
    if cell == "P6":
        return [1, 5]
    if cell == "P3":
        return [1, 2]
    if cell.startswith("P5"):
        return [1, 2, 3, 4]
    return None  # non-cyclic / positive-dim


def build_row_table(layer_row, terminus_rows, s2map, kmax=6, d_list=None):
    """Build the full conormal + admissible assignment table for one row."""
    rid = layer_row["id"]
    K = layer_row["K"]
    n = cyclic_order_of(K, layer_row["setwise"])
    frames = match_terminus_frames(layer_row, terminus_rows)
    frame_tokens = []
    for fr in frames:
        frame_tokens.extend(extract_conormal_from_frame(fr))
    # unique preserve order
    seen = set()
    ft = []
    for t in frame_tokens:
        if t not in seen:
            seen.add(t)
            ft.append(t)

    s2 = s2map.get(rid)
    if s2 is not None:
        conormal_cs = list(s2["chain"])  # relative weights along the chain
        base = s2["base"]
        n = s2["n"]
    else:
        conormal_cs = conormal_weights_cyclic(n, ft)
        base = None
        # for C2: relative weight of the normal is 1 (sign −)
        if K == "C2" and not conormal_cs:
            conormal_cs = [1]
        if K == "V4" and not conormal_cs:
            conormal_cs = [1, 2, 3]  # three nontrivial bit-patterns

    role = ("sweep" if rid in paths.SWEEP_ROWS
            else "immune" if rid in paths.IMMUNE_ROWS
            else "other")

    # value options
    opts = cells_of_row(layer_row)
    # degrees to test: for residue join we use d mod 6; for tables we sample
    if d_list is None:
        d_list = list(range(12))  # 0..11 covers all residues mod 3,5,6,11 lcm-ish

    per_value = []
    for cell, idx in opts:
        vw = value_weights_for_cell(cell, n)
        entry = dict(cell=cell, index=idx, value_weights=vw,
                     admissible_by_d={}, n_admissible_total=0,
                     differential_blocks_by_d={},
                     tc_ok_by_d={})
        if vw is None or base is None or n <= 2:
            # positive-dim image or non-cyclic: record conormal only;
            # admissibility is the existence of some equivariant normal response
            # into the receiver cell's character table (always non-empty for
            # L(onto)/PI when Stage-1 allows the value — no degree-free kill).
            entry["status"] = "noncyclic_or_posdim"
            entry["n_admissible_total"] = 1  # Stage-1 already filters
            per_value.append(entry)
            continue

        total = 0
        for d in d_list:
            w_tang = (d * base) % n
            # any value weight in the cell's residual orbit
            adm_all = []
            dblocks = {}
            tc_ok = {}
            for a_val in vw:
                assigns = admissible_assignment(n, w_tang, conormal_cs, a_val,
                                                kmax=kmax)
                if assigns:
                    adm_all.append(dict(a_value=a_val, n_assigns=len(assigns),
                                        sample=assigns[:3]))
                    total += len(assigns)
                db = differential_blocks(n, base, a_val)
                dblocks[a_val] = db
                tx = tangent_characters_X(n, a_val)
                tc_ok[a_val] = (tx is not None and len(tx) > 0)
            entry["admissible_by_d"][str(d)] = adm_all
            entry["differential_blocks_by_d"][str(d)] = dblocks
            entry["tc_ok_by_d"][str(d)] = tc_ok
        entry["n_admissible_total"] = total
        # degree-free kill: no d in d_list admits any assignment
        entry["status"] = ("DEAD_NO_ASSIGNMENT" if total == 0
                           else "LIVE")
        # TC filter: for special-point cells, require some a_val with tc_ok
        if cell in ("P11", "P5a", "P5b", "P6", "P3"):
            any_tc = any(
                any(v for v in tc.values())
                for tc in entry["tc_ok_by_d"].values()
            )
            entry["tc_any_ok"] = any_tc
            if not any_tc:
                entry["status"] = "DEAD_TC"
        per_value.append(entry)

    return dict(
        id=rid,
        K=K,
        dim=layer_row["dim"],
        n_orbit=layer_row["n"],
        setwise=layer_row["setwise"],
        chain=layer_row["chain"],
        role=role,
        cyclic_order=n,
        base=base,
        conormal_chars_tokens=ft,
        conormal_weights=conormal_cs,
        n_conormal=len(conormal_cs),
        n_value_options=len(opts),
        s2_name=(s2["name"] if s2 else None),
        per_value=per_value,
        n_live_values=sum(1 for e in per_value if e["status"] in
                          ("LIVE", "noncyclic_or_posdim")),
        n_dead_values=sum(1 for e in per_value
                          if e["status"].startswith("DEAD")),
    )


def build_all_tables(p=331, kmax=6):
    layer = load_layer1(p)
    terminus = load_terminus(p)
    s2map = build_s2_index()
    by_id = {r["id"]: r for r in layer["rows"]}
    tables = []
    for rid in paths.TABULATED:
        tables.append(build_row_table(by_id[rid], terminus, s2map, kmax=kmax))
    summary = dict(
        p=p,
        n_sweep=len(paths.SWEEP_ROWS),
        n_immune=len(paths.IMMUNE_ROWS),
        n_tabulated=len(tables),
        per_row=[{
            "id": t["id"], "role": t["role"], "K": t["K"],
            "n_conormal": t["n_conormal"],
            "conormal_weights": t["conormal_weights"],
            "n_value_options": t["n_value_options"],
            "n_live_values": t["n_live_values"],
            "n_dead_values": t["n_dead_values"],
            "s2_name": t["s2_name"],
            "chain": t["chain"],
        } for t in tables],
        total_live_values=sum(t["n_live_values"] for t in tables),
        total_dead_values=sum(t["n_dead_values"] for t in tables),
    )
    return tables, summary
