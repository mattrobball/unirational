#!/usr/bin/env python3
"""Assemble character_screen.json from the GAP dump (no self-hash).

Producer path:
  /opt/homebrew/Caskroom/miniforge/base/bin/gap -q certificates/hodge_centers/character_screen.g
  /opt/homebrew/bin/python3 certificates/hodge_centers/assemble_json.py

The sealed self_sha256 is written only after the last non-hash byte by verify.py
(or by this script with --seal).
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DUMP = ROOT / "tmp/wp_h1_hodge/character_screen.dump"
OUT = Path(__file__).resolve().parent / "character_screen.json"

THEOREM_BOUNDARY = (
    "Necessary condition only: certified linear strata and point centres "
    "contribute no H^1, so any equivariant resolution of a dominant map "
    "P^4 --> X must create additional nonlinear positive-genus curve centres "
    "or irregular surface centres supplying H^{2,1}(X) as a G-representation. "
    "Not by itself a contradiction."
)


def parse_kv(s: str) -> dict[str, str]:
    """Parse key=value tokens; values may contain '|' but not spaces."""
    out: dict[str, str] = {}
    for m in re.finditer(r"([A-Za-z0-9_]+)=(\S*)", s):
        out[m.group(1)] = m.group(2)
    return out


def parse_dump(text: str) -> dict:
    meta: dict[str, str] = {}
    h21: dict = {}
    subgroups: list[dict] = []
    pairs: list[dict] = []
    budget: dict = {}
    cur: dict | None = None

    for line in text.splitlines():
        if not line.strip():
            continue
        if line.startswith("META "):
            meta.update(parse_kv(line[5:]))
        elif line.startswith("H21 "):
            kv = parse_kv(line[4:])
            if "dim" in kv:
                h21["dimension"] = int(kv["dim"])
            if "iso" in kv:
                h21["isomorphism"] = kv["iso"]
            if "irr_index" in kv:
                h21["irr_index"] = int(kv["irr_index"])
            if "char" in kv:
                h21["character_values"] = kv["char"].split("|")
        elif line.startswith("W "):
            kv = parse_kv(line[2:])
            if "irr_index" in kv:
                h21["W_irr_index"] = int(kv["irr_index"])
            if "char" in kv:
                h21["W_character_values"] = kv["char"].split("|")
            if "class_orders" in kv:
                h21["conjugacy_class_orders"] = [
                    int(x) for x in kv["class_orders"].split("|")
                ]
        elif line.startswith("JACOBIAN "):
            kv = parse_kv(line[9:])
            h21["jacobian_ring_dims"] = [int(x) for x in kv["dims"].split("|")]
        elif line.startswith("SUBGROUP begin "):
            kv = parse_kv(line[len("SUBGROUP begin ") :])
            cur = {
                "H_label": kv["label"],
                "H_id": [int(x) for x in kv["id"].split(",")],
                "H_order": int(kv["order"]),
                "H_count": int(kv["count"]),
                "orbit_size_if_setwise_stab": int(kv["orbit"]),
                "conjugacy_index": int(kv["conj_index"]),
                "irreps": [],
            }
        elif line.startswith("SUBGROUP H21_mult="):
            assert cur is not None
            cur["restriction_H21_multiplicities"] = [
                int(x) for x in line.split("=", 1)[1].split("|")
            ]
        elif line.startswith("SUBGROUP W_mult="):
            assert cur is not None
            cur["restriction_W_multiplicities"] = [
                int(x) for x in line.split("=", 1)[1].split("|")
            ]
        elif line.startswith("RHO "):
            assert cur is not None
            kv = parse_kv(line[4:])
            entry = {
                "rho_index": int(kv["index"]),
                "degree": int(kv["deg"]),
                "hom_dim": int(kv["mult"]),
                "character_values": kv["char"].split("|"),
                "appears_in_H21": int(kv["mult"]) != 0,
            }
            if "min_genus" in kv:
                entry["min_genus"] = int(kv["min_genus"])
                entry["plane_degree_floor"] = int(kv["plane_deg"])
                entry["min_orbit_degree_plane_model"] = int(kv["orbit_deg"])
                entry["min_cohomological_weight"] = int(kv["coh_weight"])
                entry["min_genus_model"] = kv.get("model", "unknown")
                if "periods" in kv and kv["periods"] != "":
                    entry["periods"] = [int(x) for x in kv["periods"].split(",")]
                else:
                    entry["periods"] = []
                if "gamma" in kv:
                    entry["gamma"] = int(kv["gamma"])
            cur["irreps"].append(entry)
        elif line.startswith("SUBGROUP end"):
            assert cur is not None
            subgroups.append(cur)
            cur = None
        elif line.startswith("PAIR "):
            kv = parse_kv(line[5:])
            pairs.append(
                {
                    "H_label": kv["label"],
                    "H_order": int(kv["order"]),
                    "H_id": [int(x) for x in kv["id"].split(",")],
                    "H_count": int(kv["count"]),
                    "orbit_size": int(kv["orbit"]),
                    "rho_index": int(kv["rho"]),
                    "rho_degree": int(kv["rho_deg"]),
                    "hom_dim": int(kv["mult"]),
                    "rho_character_values": kv["char"].split("|"),
                    "min_genus": int(kv["min_genus"]),
                    "plane_degree_floor": int(kv["plane_deg"]),
                    "min_orbit_degree_plane_model": int(kv["orbit_deg"]),
                    "min_cohomological_weight": int(kv["coh_weight"]),
                }
            )
        elif line.startswith("BUDGET "):
            kv = parse_kv(line[7:])
            budget = {
                "H21_dimension": int(kv["H21_dim"]),
                "min_total_cohomological_weight": int(kv["min_coh_weight"]),
                "numerical_contradiction_found": kv["contradiction"] == "true",
                "numerical_contradiction_note": (
                    "No budget violation certified: high-genus / large-orbit "
                    "centres can in principle supply the five-dimensional "
                    "representation. Necessary condition only."
                ),
            }
        elif line.startswith("END"):
            break

    # Cross-check: sum of positive hom_dims per subgroup equals 5
    for sg in subgroups:
        s = sum(e["hom_dim"] * e["degree"] for e in sg["irreps"])
        assert s == 5, (sg["H_label"], s)

    payload = {
        "work_package": "WP-H1",
        "headline": "OPEN",
        "theorem_boundary": THEOREM_BOUNDARY,
        "group": {
            "name": "PSL_2(F_11)",
            "order": int(meta.get("group_order", 660)),
            "num_conjugacy_classes": int(meta.get("num_element_classes", 8)),
        },
        "H21_representation": {
            "dimension": h21["dimension"],
            "isomorphism": "H^{2,1}(X) ≅ R_1(F) ≅ W^* as G-modules (Griffiths residue)",
            "jacobian_ring_dims_R0_to_R5": h21["jacobian_ring_dims"],
            "character_irr_index": h21["irr_index"],
            "character_values": h21["character_values"],
            "W_character_irr_index": h21["W_irr_index"],
            "W_character_values": h21["W_character_values"],
            "conjugacy_class_orders": h21["conjugacy_class_orders"],
            "note": (
                "chi_W = Irr(G)[2] matched to exact Weil matrices "
                "(tr T = A on class 11a); H^{2,1} ≅ W^* = Irr(G)[3]"
            ),
        },
        "subgroup_screen": subgroups,
        "surviving_pairs": pairs,
        "intersection_budget": budget,
        "tool_versions": {
            "gap": meta.get("gap_version"),
            "CTblLib": meta.get("ctbllib"),
            "AtlasRep": meta.get("atlasrep"),
        },
        "producer": "certificates/hodge_centers/character_screen.g",
        "assembler": "certificates/hodge_centers/assemble_json.py",
        "strata_source": "certificates/strata/strata_exact.json",
        "representation_source": "certificates/exact_weil_check.py",
        "terminal_marker": "WP_H1_CHARACTER_SCREEN_OK",
        "num_surviving_pairs": len(pairs),
    }
    return payload


def canonical_json(obj: dict) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--seal", action="store_true", help="write self_sha256")
    args = ap.parse_args()

    text = DUMP.read_text()
    payload = parse_dump(text)

    if args.seal:
        body = dict(payload)
        raw = canonical_json(body).encode()
        body["self_sha256"] = hashlib.sha256(raw).hexdigest()
        # re-seal: hash of payload without self_sha256
        OUT.write_text(canonical_json(body))
        # verify round-trip
        data = json.loads(OUT.read_text())
        h = data.pop("self_sha256")
        assert hashlib.sha256(canonical_json(data).encode()).hexdigest() == h
        print(f"WROTE sealed {OUT}")
        print(f"self_sha256={h}")
    else:
        OUT.write_text(canonical_json(payload))
        print(f"WROTE unsealed {OUT}")

    print(f"surviving_pairs={payload['num_surviving_pairs']}")
    print("ASSEMBLE_OK")


if __name__ == "__main__":
    main()
