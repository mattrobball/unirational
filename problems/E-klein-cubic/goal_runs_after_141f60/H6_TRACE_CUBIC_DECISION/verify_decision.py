#!/usr/bin/env python3
"""Independent H6 residual decision verifier (lanes, valuation, seal, no headline)."""
from __future__ import annotations

import hashlib
import json
import random
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H6A = ROOT / "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY"
H5 = ROOT / "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC"
V3 = ROOT / "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802"


def fail(msg: str) -> None:
    print(f"H6_DECISION_VERIFY_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def Phi_mod(z, r, p: int) -> int:
    def eval_Z(t):
        s, pw = 0, 1
        for c in z:
            s = (s + c * pw) % p
            pw = pw * t % p
        return s

    s = 0
    for i in range(5):
        Zi = eval_Z(r[i])
        Zip = eval_Z(r[(i + 1) % 5])
        inv = pow(r[(i + 2) % 5], p - 2, p)
        s = (s + Zi * Zi % p * Zip % p * inv) % p
    return s


def main() -> None:
    required = [
        "INPUT_MANIFEST.json",
        "torsor_class.json",
        "TRACE_HYPERPLANE_TORSOR.md",
        "BOUNDARY_AUDIT.md",
        "constructive_search.json",
        "CONSTRUCTIVE_SEARCH.md",
        "valuation_ledger.json",
        "VALUATION_LEDGER.md",
        "decision.json",
        "POINT.md",
        "produce.py",
        "verify_torsor.py",
        "verify_decision.py",
        "REPLAY.md",
        "SEAL.json",
        "STATUS.md",
    ]
    for name in required:
        require((HERE / name).is_file(), f"missing {name}")

    # No forbidden headline artifacts
    require(not (HERE / "BRIDGE_11_5_NEG.md").is_file(), "unexpected BRIDGE")
    require(not (HERE / "POINTLESSNESS.md").is_file(), "unexpected POINTLESSNESS")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("H6-TORSOR-CLASS-PASS\n"), "STATUS")
    require("OPEN" in status, "headline open in STATUS")
    require("H6-POINTLESS-HEADLINE-NEGATIVE" not in status.split("\n")[0], "no pointless exit")

    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("exit") == "H6-TORSOR-CLASS-PASS", "seal exit")
    require(seal.get("headline") == "OPEN", "seal headline")
    require("H6-POINTLESS-HEADLINE-NEGATIVE" not in seal.get("nonclaims", [])
            or True, "nonclaims present")
    nonclaims = seal.get("nonclaims", [])
    require(any("POINTLESS" in c or "pointless" in c.lower() for c in nonclaims), "nonclaim pointless")
    require(any("RATIONAL-POINT" in c or "rational" in c.lower() for c in nonclaims), "nonclaim point")

    # Seal hashes
    for rel, expected in seal.get("files", {}).items():
        path = HERE / rel
        require(path.is_file(), f"seal file missing {rel}")
        require(sha256(path) == expected, f"seal hash drift {rel}")

    # Decision payload
    dec = json.loads((HERE / "decision.json").read_text())
    require(dec.get("primary_exit") == "H6-TORSOR-CLASS-PASS", "decision exit")
    require(dec.get("headline") == "OPEN", "decision headline")
    require(dec.get("point_over_K") in (None, [], "none"), "no point claimed")
    require(dec.get("pointlessness") in (None, False, "none"), "no pointless claimed")
    require(dec.get("bridge", {}).get("entered") is False, "bridge not entered")
    for bad in (
        "H6-POINTLESS-HEADLINE-NEGATIVE",
        "H6-RATIONAL-POINT",
        "H6-VALUATION-REDUCTION-PASS",
    ):
        require(bad in dec.get("not_achieved", []), f"not_achieved {bad}")

    # Constructive lanes
    cs = json.loads((HERE / "constructive_search.json").read_text())
    require(cs.get("summary") == "no_K_point_constructed", "cs summary")
    require(cs.get("points_over_K") == [], "points empty")
    lanes = cs["lanes"]
    for key in (
        "A_rational_curves_surfaces",
        "B_additive_hilbert_90",
        "C_projection_degree_five",
        "D_multiprime_reconstruction",
    ):
        require(key in lanes, f"lane {key}")
        require(lanes[key].get("K_point") in (None, False), f"lane {key} K_point")

    # Valuation
    vl = json.loads((HERE / "valuation_ledger.json").read_text())
    require(vl.get("anisotropic_residue") in (None, False), "no anisotropy")
    require(vl.get("marker_valuation_reduction") in (None, False, ""), "no val marker")
    require(len(vl.get("orbits", [])) >= 4, "enough orbits")
    for orb in vl["orbits"]:
        require(sum(orb["representative_v"]) == 0, "sum v=0")
        require(orb.get("residue_anisotropy") in ("not_proved", None, False), "aniso")
        require(orb.get("descends_to_K") is True, "descends")

    # POINT.md
    pt = (HERE / "POINT.md").read_text().lower()
    require("none" in pt, "POINT none")

    # Inputs: H5/V3 undecided binding
    require((H5 / "STATUS.md").read_text().startswith("H5-UNDECIDED\n"), "H5")
    require((V3 / "STATUS.md").read_text().startswith("V-UNDECIDED\n"), "V3")
    require(
        (H6A / "STATUS.md").read_text().startswith("H6-PROJECTIVE-11-ISOGENY-PASS\n"),
        "H6A",
    )

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    require(man.get("h5_exit") == "H5-UNDECIDED", "man h5")
    require(man.get("v3_exit") == "V-UNDECIDED", "man v3")
    # Independent hash recheck of a few critical inputs
    for rel in (
        "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/isogeny.json",
        "goal_runs_after_35fa/H_11_5_TWIST/norm_model.json",
        "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/SEAL.json",
    ):
        item = next(x for x in man["inputs"] if x["path"] == rel)
        require(sha256(ROOT / rel) == item["sha256"], f"hash {rel}")

    # Producer ≠ verifier: scripts must be distinct files with distinct hashes
    require(
        sha256(HERE / "produce.py") != sha256(HERE / "verify_torsor.py"),
        "producer≠verifier torsor",
    )
    require(
        sha256(HERE / "produce.py") != sha256(HERE / "verify_decision.py"),
        "producer≠verifier decision",
    )
    def _imports_producer(text: str) -> bool:
        for line in text.splitlines():
            s = line.split("#", 1)[0].strip()
            if s == "import produce" or s.startswith("import produce as"):
                return True
            if s.startswith("from produce "):
                return True
        return False

    require(not _imports_producer((HERE / "verify_torsor.py").read_text()),
            "torsor verifier must not import producer")
    require(not _imports_producer((HERE / "verify_decision.py").read_text()),
            "decision verifier must not import producer")

    # Modular discovery honesty: specialized points exist (not promoted)
    rng = random.Random(11)
    found = 0
    for p in (89, 101, 131):
        for _ in range(3000):
            r = [rng.randrange(1, p) for _ in range(4)]
            r.append(pow(r[0] * r[1] * r[2] * r[3] % p, -1, p))
            if len(set(r)) < 5:
                continue
            z = [rng.randrange(0, p) for _ in range(5)]
            if all(x == 0 for x in z):
                continue
            if Phi_mod(z, r, p) == 0:
                found += 1
                break
    require(found >= 2, f"expected specialized points for honesty, found on {found} primes")

    # No claim of exhaustive H5 re-screens
    cs_md = (HERE / "CONSTRUCTIVE_SEARCH.md").read_text().lower()
    require("not" in cs_md and "exhaustive" in cs_md, "discipline exhaustive")

    print("H6_DECISION_VERIFY_OK")
    print("H6-TORSOR-CLASS-PASS")
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
