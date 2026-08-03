#!/usr/bin/env python3
"""Independent H6 push decision verifier (lanes, valuation, seal, no headline)."""
from __future__ import annotations

import hashlib
import json
import random
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
H6A = ROOT / "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY"
H5 = ROOT / "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC"
V3 = ROOT / "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802"
PARENT = HERE.parent


def fail(msg: str) -> None:
    print(f"H6_PUSH_DECISION_VERIFY_FAIL: {msg}", file=sys.stderr)
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


def product_one(rng, p):
    r = [rng.randrange(1, p) for _ in range(4)]
    r.append(pow(r[0] * r[1] * r[2] * r[3] % p, -1, p))
    return r


def Phi_mod(z, r, p: int) -> int:
    def eval_Z(t):
        s, pw = 0, 1
        for c in z:
            s = (s + c * pw) % p
            pw = pw * t % p
        return s

    s = 0
    for i in range(5):
        s = (
            s
            + eval_Z(r[i]) ** 2
            % p
            * eval_Z(r[(i + 1) % 5])
            % p
            * pow(r[(i + 2) % 5], p - 2, p)
        ) % p
    return s


def main() -> None:
    required = [
        "INPUT_MANIFEST.json",
        "torsor_rebuild.json",
        "TORSOR_REBUILD.md",
        "constructive_push.json",
        "CONSTRUCTIVE_PUSH.md",
        "valuation_push.json",
        "VALUATION_PUSH.md",
        "decision_push.json",
        "DECISION.md",
        "POINT.md",
        "produce_push.py",
        "verify_push_torsor.py",
        "verify_push_decision.py",
        "REPLAY.md",
        "SEAL.json",
        "STATUS.md",
        "produce_meta.json",
    ]
    for name in required:
        require((HERE / name).is_file(), f"missing {name}")

    require(not (HERE / "BRIDGE_11_5_NEG.md").is_file(), "unexpected BRIDGE")
    require(not (HERE / "POINTLESSNESS.md").is_file(), "unexpected POINTLESSNESS")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("H6-TORSOR-CLASS-PASS\n"), "STATUS")
    require("OPEN" in status, "open")
    require("H6-POINTLESS-HEADLINE-NEGATIVE" not in status.split("\n")[0], "no pointless")

    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("exit") == "H6-TORSOR-CLASS-PASS", "seal exit")
    require(seal.get("headline") == "OPEN", "seal headline")
    nonclaims = seal.get("nonclaims", [])
    require(any("POINTLESS" in c for c in nonclaims), "nonclaim pointless")
    require(any("RATIONAL-POINT" in c for c in nonclaims), "nonclaim point")
    require(any("VALUATION" in c for c in nonclaims), "nonclaim val")

    for rel, expected in seal.get("files", {}).items():
        path = HERE / rel
        require(path.is_file(), f"seal file missing {rel}")
        require(sha256(path) == expected, f"seal hash drift {rel}")

    dec = json.loads((HERE / "decision_push.json").read_text())
    require(dec.get("primary_exit") == "H6-TORSOR-CLASS-PASS", "dec exit")
    require(dec.get("headline") == "OPEN", "dec headline")
    require(dec.get("point_over_K") is None, "no point")
    require(dec.get("pointlessness") is None, "no pointless")
    require(dec.get("bridge_entered") is False, "no bridge")
    require("H6-RATIONAL-POINT" in dec.get("not_achieved", []), "not achieved point")

    cons = json.loads((HERE / "constructive_push.json").read_text())
    require(cons.get("summary") == "no_K_point_constructed", "cons summary")
    require(cons.get("points_over_K") == [], "points empty")
    a = cons["lanes"]["A_families_in_H_tr"]
    require(a["two_support_laurent"]["survives"] == 0, "two-support")
    require(a["three_support_laurent"]["survives"] == 0, "three-support")
    require(a["k_coeff_power_sum_sparse"]["survives"] == 0, "kcoeff")
    require(
        cons["lanes"]["B_additive_multiplicative_H90"]["cyclic_partial_rational"][
            "survives"
        ]
        == 0,
        "cyclic",
    )
    require(
        cons["lanes"]["C_projection_degree_five"]["skip_one_lines_on_F_modular"] is True,
        "skip-one",
    )
    require(
        cons["lanes"]["D_multiprime"]["stable_rational_component"] is False,
        "multiprime",
    )

    val = json.loads((HERE / "valuation_push.json").read_text())
    require(val.get("marker_valuation_reduction") is None, "no val pass")
    require(val.get("anisotropic_residue") is None, "no aniso")
    require(len(val.get("orbits", [])) >= 6, "orbits")
    for orb in val["orbits"]:
        require(orb.get("residue_anisotropy") == "not_proved", "aniso flag")
        require(sum(orb["representative_v"]) == 0, "sum v")

    point = (HERE / "POINT.md").read_text()
    require("none" in point.lower(), "POINT.md none")

    # inputs exist
    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    for item in man.get("inputs", []):
        if item.get("required"):
            require(item.get("exists") is True, f"input missing {item.get('path')}")
            p = ROOT / item["path"]
            require(p.is_file(), f"path {item['path']}")
            require(sha256(p) == item["sha256"], f"input hash {item['path']}")

    # parent / H5 / V3 status bindings
    require((PARENT / "STATUS.md").read_text().startswith("H6-TORSOR-CLASS-PASS"), "parent")
    require((H5 / "STATUS.md").read_text().startswith("H5-UNDECIDED"), "H5")
    require((V3 / "STATUS.md").read_text().startswith("V-UNDECIDED"), "V3")
    require((H6A / "STATUS.md").read_text().startswith("H6-PROJECTIVE-11-ISOGENY-PASS"), "H6A")

    # modular: specialized fibres nonempty (discovery replay)
    rng = random.Random(7)
    for p in (89, 101):
        found = False
        for _ in range(4000):
            r = product_one(rng, p)
            if len(set(r)) < 5:
                continue
            z = [rng.randrange(p) for _ in range(5)]
            if all(x == 0 for x in z):
                continue
            if Phi_mod(z, r, p) == 0:
                found = True
                break
        require(found, f"fibre nonempty p={p}")

    # skip-one lines on F
    for p in (89, 101):
        for i in range(5):
            x = [0] * 5
            x[i] = 3
            x[(i + 2) % 5] = 5
            F = sum(x[j] * x[j] % p * x[(j + 1) % 5] % p for j in range(5)) % p
            require(F == 0, "skip-one F")

    # meta peak rss reported
    meta = json.loads((HERE / "produce_meta.json").read_text())
    require("peak_rss_mb" in meta, "rss")
    require(meta["peak_rss_mb"] > 0, "rss positive")

    print("H6_PUSH_DECISION_VERIFY_OK")
    print("H6-TORSOR-CLASS-PASS")
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
