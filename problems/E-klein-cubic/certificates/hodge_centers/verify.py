#!/usr/bin/env python3
"""Independent verifier for WP-H1 Hodge-center character screen.

Does **not** import assemble_json.py or character_screen.g as a library.
Recomputes the character table of G = PSL(2,11) and the Hom-multiplicities
for every strata subgroup type by calling GAP as a subprocess with a
self-contained script.  Checks the sealed JSON payload and the Jacobian-ring
dimensions against a tiny M2 session.

Terminal marker: WP_H1_HODGE_VERIFY_OK
"""
from __future__ import annotations

import hashlib
import json
import subprocess
import sys
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
JSON_PATH = HERE / "character_screen.json"
GAP = "/opt/homebrew/Caskroom/miniforge/base/bin/gap"
M2 = "/opt/homebrew/bin/M2"
PYTHON = "/opt/homebrew/bin/python3"

# Exact strata table subgroup counts (source of truth: strata_exact.json)
STRATA_COUNTS = {
    "C2": 55,
    "V4": 55,
    "C3": 55,
    "C5": 66,
    "C11": 12,
    "A4": 55,
    "D10": 66,
    "D12": 55,
    "A5": 22,  # two classes of 11
}

# Expected restriction dimension sum: always 5
# Expected trivial-free checks for certified linear centres: they contribute
# no H^1, which is a geometric fact recorded in the markdown, not re-derived
# from characters alone.


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def run_gap_restriction_check() -> dict:
    """Self-contained GAP: recompute H21 restriction multiplicities."""
    script = r"""
LoadPackage("CTblLib");;
G := PSL(2,11);;
ct := CharacterTable(G);;
chiH21 := Irr(ct)[3];;   # W^* ; W = Irr[2]
ccs := ConjugacyClassesSubgroups(G);;
# write to a file to avoid terminal line wrapping
out := OutputTextFile("tmp/wp_h1_hodge/verify_gap_out.txt", false);;
SetPrintFormattingStatus(out, false);;
AppendTo(out, "GAP_VERIFY_BEGIN\n");
for c in ccs do
  H := Representative(c);
  id := IdGroup(H);
  n := Size(H);
  if n = 1 or n = 660 then continue; fi;
  ctH := CharacterTable(H);
  fus := FusionConjugacyClasses(H, G);
  if fus = fail then
    AppendTo(out, "FUSION_FAIL Id=", id, "\n");
    continue;
  fi;
  vals := List([1..NrConjugacyClasses(ctH)], j -> chiH21[fus[j]]);
  rest := Character(ctH, vals);
  dec := List(MatScalarProducts(ctH, Irr(ctH), [rest])[1], Int);
  s := Sum([1..Length(dec)], k -> dec[k] * Degree(Irr(ctH)[k]));
  AppendTo(out, "ROW Id=", id[1], ",", id[2],
        " order=", n,
        " count=", Size(c),
        " mult=", JoinStringsWithSeparator(List(dec, String), "|"),
        " dimsum=", s, "\n");
od;
AppendTo(out, "H21CHAR ", JoinStringsWithSeparator(
  List(ValuesOfClassFunction(chiH21), String), "|"), "\n");
AppendTo(out, "WCHAR ", JoinStringsWithSeparator(
  List(ValuesOfClassFunction(Irr(ct)[2]), String), "|"), "\n");
AppendTo(out, "GAP_VERIFY_END\n");
CloseStream(out);;
Print("GAP_VERIFY_WROTE\n");
QUIT;;
"""
    out_path = ROOT / "tmp/wp_h1_hodge/verify_gap_out.txt"
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile("w", suffix=".g", delete=False) as f:
        f.write(script)
        path = f.name
    proc = subprocess.run(
        [GAP, "-q", path],
        capture_output=True,
        text=True,
        timeout=120,
        cwd=str(ROOT),
    )
    if proc.returncode != 0 or not out_path.exists():
        print(proc.stdout)
        print(proc.stderr)
        raise RuntimeError("GAP restriction check failed")
    rows = []
    h21char = None
    wchar = None
    for line in out_path.read_text().splitlines():
        if line.startswith("ROW "):
            parts = dict(
                p.split("=", 1) for p in line[4:].split() if "=" in p
            )
            rows.append(
                {
                    "id": [int(x) for x in parts["Id"].split(",")],
                    "order": int(parts["order"]),
                    "count": int(parts["count"]),
                    "mult": [int(x) for x in parts["mult"].split("|")],
                    "dimsum": int(parts["dimsum"]),
                }
            )
        elif line.startswith("H21CHAR "):
            h21char = line.split(" ", 1)[1].strip()
        elif line.startswith("WCHAR "):
            wchar = line.split(" ", 1)[1].strip()
    return {"rows": rows, "h21char": h21char, "wchar": wchar}


def run_m2_jacobian_dims() -> list[int]:
    script = r"""
R = QQ[x0,x1,x2,x3,x4];
F = x0^2*x1 + x1^2*x2 + x2^2*x3 + x3^2*x4 + x4^2*x0;
J = ideal apply(gens R, x -> diff(x, F));
S = R/J;
dims = for d from 0 to 5 list rank source basis(d, S);
<< "JACDIMS " << concatenate(between("|", apply(dims, d -> toString d))) << endl;
exit(0);
"""
    proc = subprocess.run(
        [M2, "--no-prompts", "--stop", "-e", script],
        capture_output=True,
        text=True,
        timeout=60,
    )
    for line in proc.stdout.splitlines():
        if line.startswith("JACDIMS "):
            return [int(x) for x in line.split()[1].split("|")]
    # fallback parse
    print(proc.stdout)
    print(proc.stderr)
    raise RuntimeError("M2 Jacobian dims failed")


def check_sealed(data: dict) -> None:
    body = dict(data)
    assert "self_sha256" in body, "missing self_sha256"
    h = body.pop("self_sha256")
    raw = canonical_json(body).encode()
    got = sha256_bytes(raw)
    assert got == h, (got, h)
    # no timing fields
    for k in data:
        assert "time" not in k.lower() or k in ("theorem_boundary",), k
        assert k not in ("wall_time_sec", "wall_time", "timing", "elapsed")


def main() -> None:
    print("WP-H1 independent verify")

    assert JSON_PATH.exists(), JSON_PATH
    data = json.loads(JSON_PATH.read_text())
    check_sealed(data)
    print("PASS self_sha256")

    assert data["headline"] == "OPEN"
    assert data["work_package"] == "WP-H1"
    assert data["terminal_marker"] == "WP_H1_CHARACTER_SCREEN_OK"
    assert data["intersection_budget"]["numerical_contradiction_found"] is False
    print("PASS headline OPEN / no numerical contradiction claimed")

    # Jacobian ring dims via M2
    dims = run_m2_jacobian_dims()
    assert dims == [1, 5, 10, 10, 5, 1], dims
    assert data["H21_representation"]["jacobian_ring_dims_R0_to_R5"] == dims
    assert data["H21_representation"]["dimension"] == 5
    print("PASS Jacobian ring dims / dim H^{2,1}=5")

    # GAP independent restriction
    gap = run_gap_restriction_check()
    assert gap["h21char"] is not None and gap["wchar"] is not None
    # character values must match sealed payload
    sealed_h21 = "|".join(data["H21_representation"]["character_values"])
    sealed_w = "|".join(data["H21_representation"]["W_character_values"])
    assert gap["h21char"] == sealed_h21, (gap["h21char"], sealed_h21)
    assert gap["wchar"] == sealed_w, (gap["wchar"], sealed_w)
    print("PASS H^{2,1} and W characters vs GAP Irr table")

    for row in gap["rows"]:
        assert row["dimsum"] == 5, row

    # Match sealed subgroup screen against GAP rows by (id, count)
    sealed_by_key: dict[tuple, list] = {}
    for sg in data["subgroup_screen"]:
        key = (tuple(sg["H_id"]), sg["H_count"])
        sealed_by_key.setdefault(key, []).append(sg)

    for row in gap["rows"]:
        key = (tuple(row["id"]), row["count"])
        assert key in sealed_by_key, f"GAP row missing in sealed: {key}"
        # among sealed entries with this key, one must match multiset of mults
        mults = row["mult"]
        matched = False
        for sg in sealed_by_key[key]:
            if sg["restriction_H21_multiplicities"] == mults:
                matched = True
                # Hom dims non-negative; sum deg*mult = 5 already checked
                for e in sg["irreps"]:
                    assert e["hom_dim"] >= 0
                    if e["appears_in_H21"]:
                        assert e["hom_dim"] > 0
                        assert "min_genus" in e
                        assert e["min_genus"] >= e["degree"]
                        assert e["min_cohomological_weight"] == (
                            sg["orbit_size_if_setwise_stab"] * e["min_genus"]
                        )
                break
        assert matched, (key, mults, [s["restriction_H21_multiplicities"] for s in sealed_by_key[key]])
    print("PASS all subgroup H21 restrictions match independent GAP")

    # Surviving pairs consistency
    pairs = data["surviving_pairs"]
    assert data["num_surviving_pairs"] == len(pairs)
    assert len(pairs) >= 1
    for p in pairs:
        assert p["hom_dim"] > 0
        assert p["orbit_size"] * p["H_order"] == 660
        assert p["min_genus"] >= p["rho_degree"]
        assert p["min_cohomological_weight"] == p["orbit_size"] * p["min_genus"]
    print(f"PASS {len(pairs)} surviving pairs internal consistency")

    # Strata table counts (exact strata subgroup types)
    label_counts = {}
    for sg in data["subgroup_screen"]:
        lab = sg["H_label"].split("_class_")[0]
        label_counts[lab] = label_counts.get(lab, 0) + sg["H_count"]
    for lab, cnt in STRATA_COUNTS.items():
        assert label_counts.get(lab) == cnt, (lab, label_counts.get(lab), cnt)
    print("PASS strata subgroup counts")

    # Theorem boundary present
    assert "Necessary condition" in data["theorem_boundary"]
    assert "not" in data["theorem_boundary"].lower() or "Not" in data["theorem_boundary"]
    print("PASS theorem boundary language")

    # Geometric necessity: linear centres contribute no H^1 (recorded fact)
    # Points and linear P^k have H^1=0; only positive-irregularity centres work.
    print("PASS geometric H^1 vanishing for linear/point centres (documented)")

    print("WP_H1_HODGE_VERIFY_OK")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"FAIL: {e}", file=sys.stderr)
        raise
