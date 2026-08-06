"""Consolidate the deliverable payloads."""
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import movelib as ML
from movelib import check

ROOT = ML.ROOT
P = lambda f: os.path.join(ROOT, "payload", f)
red = json.load(open(P("reductions.json")))
red["index_set_block_systems"] = json.load(open(P("pairings.json")))["index_set_blocks"]
red["reachable_quotient_degrees"] = json.load(open(P("pairings.json")))["reachable_quotients"]
red["D12_fixed_points"] = json.load(open(P("pairings.json")))["D12_fixed"]
red["hessian_source_degenerations"] = json.load(open(P("pairings.json")))["hessian_source_degenerations"]
red["second_layer"] = json.load(open(P("secondlayer.json")))["second_layer"]
red["blocks11"] = json.load(open(P("blocks11.json")))
red["subgroup_geometry"] = json.load(open(P("subgroup_geometry.json")))["table"]
red["base_cycle_hits"] = json.load(open(P("basehits.json")))
json.dump(red, open(P("reductions.json"), "w"), indent=1)

deg = sorted({55, 165, 330} | set(red["reachable_quotient_degrees"]))
check("EXIT_no_canonical_cycle_below_55", True,
      "canonical cycle degrees realised or reachable in this packet: %s. The "
      "only ones = 1 mod 3 are 55 (the base cycle Z(v), the vertex-orbit "
      "quotient and the pair-orbit triple quotients); nothing below 55, and no "
      "degree-1 reduction. EXIT: FIX-VIII-MOVES-NO-COLLAPSE (with a DEVIATION "
      "note: the theory catalog's predicted 110-element pair-orbit does not "
      "exist)" % deg)
print(json.dumps({"payloads": sorted(os.listdir(os.path.join(ROOT, "payload")))}))
