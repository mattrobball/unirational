#!/usr/bin/env python3
"""Independent G5 model verifier (does not import produce_residues).

Checks G5.0 valuation/torsor claims and G5.1 residue cubic specialization
against the sealed generic cubic.
"""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
PRIMARY = ["f3", "f5", "f6", "f8", "f11"]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def reduce_generic_entries(entries: list[dict], drop: int) -> list[dict]:
    return [e for e in entries if e["primary_exponents"][drop] == 0]


def verify_input_manifest() -> dict:
    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    require(man["goal"] == "G5_FULL_RESIDUE_CUBICS", "goal id")
    for row in man["inputs"]:
        path = ROOT / row["path"]
        if not row["exists"]:
            # optional table may be present; hard-require binding inputs
            if "generic_cubic" in row["path"] or "V3_VALUATION" in row["path"] or "G_UNIVERSAL" in row["path"]:
                raise AssertionError(f"missing binding input {row['path']}")
            continue
        require(path.is_file(), f"missing {row['path']}")
        actual = sha256(path)
        require(actual == row["sha256"], f"hash drift {row['path']}")
    # hard binds
    gsha = sha256(GENERIC)
    require(
        gsha == "2573277995d439011c9051f01c3412519059c505a729def80cde58aa2ca09d53",
        "generic cubic hash mismatch vs known seal",
    )
    v3 = (ROOT / "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/STATUS.md").read_text()
    require(v3.startswith("V-UNDECIDED"), "V3 status")
    require("V3-RESIDUE-NORMAL-FORM-PASS" in v3, "V3 scoped exit")
    g2 = (ROOT / "goal_runs_after_35fa/G_UNIVERSAL/STATUS.md").read_text()
    require(g2.startswith("G2-FINITE-GENERATION-PASS"), "G2 status")
    return man


def verify_valuation_models() -> None:
    vm = json.loads((HERE / "valuation_models.json").read_text())
    require(vm["schema"] == "g5-valuation-models-v1", "valuation schema")
    require(vm["marker"] == "G5-RESIDUE-TORSOR-MODEL-PASS", "torsor marker")
    for site in ("f5", "f6"):
        s = vm["sites"][site]
        require(s["ramification"].startswith("e = 1") or s["ramification"] == "e = 1", f"{site} ramified")
        require("trivial" in s["inertia"].lower(), f"{site} inertia")
        require("full G" in s["decomposition_group"], f"{site} decomp")
        require(s["residue_transcendence_degree_K_proj"] == 3, f"{site} trdeg")
        require("genuine" in s["residue_G_torsor"].lower() or "G-torsor" in s["residue_G_torsor"], f"{site} torsor")
    text = (HERE / "VALUATION_MODELS.md").read_text()
    require("G5-RESIDUE-TORSOR-MODEL-PASS" in text, "VALUATION_MODELS marker")
    require("f5" in text and "f6" in text, "both sites documented")
    require("inertia" in text.lower(), "inertia discussed")


def verify_residue_cubic(site: str, drop: int) -> dict:
    generic = json.loads(GENERIC.read_text())
    path = HERE / site / "residue_cubic.json"
    payload = json.loads(path.read_text())
    require(payload["schema"] == f"g5-residue-cubic-{site}-v1", "schema")
    require(payload["drop_primary_index"] == drop, "drop index")
    require(payload["source_sha256"] == sha256(GENERIC), "source hash in residue")
    require(payload["coefficient_count"] == 35, "35 coeffs")
    require(len(payload["coefficients"]) == 35, "coeff list length")

    # rebuild reduction independently and compare term multisets
    for gc, rc in zip(generic["coefficients"], payload["coefficients"]):
        require(gc["label"] == rc["label"], "label order")
        require(list(gc["triple"]) == list(rc["triple"]), "triple")
        red = reduce_generic_entries(gc["entries"], drop)
        require(len(red) == rc["residue_term_count"], f"{site} {gc['label']} term count")
        # compare as sorted (secondary, primary, num, den)
        def key(e):
            return (
                e["secondary"],
                tuple(e["primary_exponents"] if "primary_exponents" in e else e["primary_exponents_full"]),
                e["numerator"],
                e["denominator"],
            )

        left = sorted(
            [
                (
                    e["secondary"],
                    tuple(e["primary_exponents"]),
                    e["numerator"],
                    e["denominator"],
                )
                for e in red
            ]
        )
        right = sorted(
            [
                (
                    e["secondary"],
                    tuple(e["primary_exponents_full"]),
                    e["numerator"],
                    e["denominator"],
                )
                for e in rc["entries"]
            ]
        )
        require(left == right, f"{site} {gc['label']} term mismatch")

    # no common uniformizer content: every nonzero coeff has a term with drop-power 0 (by construction)
    # and at least one coefficient is nonzero
    nonzero = sum(1 for c in payload["coefficients"] if c["residue_term_count"] > 0)
    require(nonzero == 35 or (site == "f6" and nonzero == 34), f"{site} nonzero count {nonzero}")
    if site == "f5":
        require(payload["vanishing_coefficients"] == [], "f5 no vanishing")
    if site == "f6":
        require(payload["vanishing_coefficients"] == ["x*x*C"], "f6 vanishes only x*x*C")

    # pure cubes survive
    labels = {c["label"]: c for c in payload["coefficients"]}
    for lab in ("x*x*x", "C*C*C", "D*D*D", "E*E*E", "K*K*K"):
        require(labels[lab]["residue_term_count"] > 0, f"{site} pure cube {lab}")

    # index-one ledger present without claiming a point
    require(payload["index_one"]["effective_cycle_degrees"] == [60, 132, 165, 220], "cycles")
    require("does not supply a point" in payload["index_one"]["note"], "index nonclaim")
    return payload


def verify_smoothness_doc(f5: dict, f6: dict) -> None:
    text = (HERE / "SMOOTHNESS.md").read_text()
    require("smooth" in text.lower(), "smoothness discussed")
    require("f5" in text and "f6" in text, "both sites")
    # modular evidence is in point_search; require nonclaim about global singularity classification if singular
    require("index one" in text.lower() or "index-one" in text.lower() or "60" in text, "index note")


def main() -> None:
    verify_input_manifest()
    verify_valuation_models()
    f5 = verify_residue_cubic("f5", 1)
    f6 = verify_residue_cubic("f6", 2)
    verify_smoothness_doc(f5, f6)
    # structural markers
    status = (HERE / "STATUS.md").read_text().splitlines()[0].strip()
    require(
        status
        in {
            "G5-F5-CUBIC-MODEL-PASS",
            "G5-F6-CUBIC-MODEL-PASS",
            "G5-RESIDUE-TORSOR-MODEL-PASS",
            "G5-F5-RESIDUE-POINT",
            "G5-F6-RESIDUE-POINT",
            "G5-F5-POINTLESS-HEADLINE-NEGATIVE",
            "G5-F6-POINTLESS-HEADLINE-NEGATIVE",
            "G5-UNDECIDED",
            "G5-CANONICAL-INPUT-FAIL",
        },
        f"bad primary exit line {status!r}",
    )
    require("G5-F5-CUBIC-MODEL-PASS" in (HERE / "STATUS.md").read_text(), "f5 model in status")
    require("G5-F6-CUBIC-MODEL-PASS" in (HERE / "STATUS.md").read_text(), "f6 model in status")
    require("G5-RESIDUE-TORSOR-MODEL-PASS" in (HERE / "STATUS.md").read_text(), "torsor in status")
    print("G5_MODELS_VERIFY_OK")
    print(f"f5_terms={f5['statistics']['total_residue_terms']} f6_terms={f6['statistics']['total_residue_terms']}")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:  # noqa: BLE001
        print(f"G5_MODELS_VERIFY_FAIL: {exc}", file=sys.stderr)
        raise
