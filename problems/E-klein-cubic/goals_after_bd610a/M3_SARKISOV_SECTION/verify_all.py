#!/usr/bin/env python3
"""Independent top-level replay for the durable M3 packet."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import resource
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PYTHON = "/opt/homebrew/bin/python3"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(
    path: Path,
    marker: str,
    *,
    arguments: tuple[str, ...] = (),
    timeout: int = 900,
) -> None:
    completed = subprocess.run(
        [PYTHON, "-u", str(path), *arguments],
        cwd=PROBLEM,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=timeout,
        check=True,
        env={**__import__("os").environ, "PYTHONDONTWRITEBYTECODE": "1"},
    )
    if marker not in completed.stdout:
        raise AssertionError(
            f"missing marker {marker} from {path}:\n{completed.stdout}"
        )
    print(f"PASS {path.relative_to(PROBLEM)} :: {marker}", flush=True)


def compare_json_producer(path: Path, stored: Path, timeout: int = 300) -> None:
    completed = subprocess.run(
        [PYTHON, "-u", str(path)],
        cwd=PROBLEM,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=timeout,
        check=True,
        env={**__import__("os").environ, "PYTHONDONTWRITEBYTECODE": "1"},
    )
    fresh = json.loads(completed.stdout)
    installed = json.loads(stored.read_text())
    assert fresh == installed, f"{stored.name} differs from {path.name}"
    print(f"PASS reproducible {stored.name}", flush=True)


def verify_manifest() -> None:
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    assert manifest["schema"] == "m3-sarkisov-section-input-manifest-v1"
    assert manifest["base_field"] == "K_Schur=C(P(V6))^PSL2(F11)"
    assert manifest["pinned_state"] == "bd610a032bb9561d2daeb91a2cb60c48c082ca2f"
    for entry in manifest["inputs"]:
        path = PROBLEM / entry["path"]
        assert path.is_file(), path
        assert digest(path) == entry["sha256"], entry["path"]
    drift = manifest["binding_replay_audit"]
    assert drift["top_level_exit"] == "FAIL_STALE_UPSTREAM_HASH"
    assert drift["current_marker"] == "C-UNDECIDED"
    assert drift["classification"].startswith("non-load-bearing")
    compare_json_producer(
        HERE / "produce_manifest.py", HERE / "INPUT_MANIFEST.json"
    )
    print(f"PASS input hashes count={len(manifest['inputs'])}", flush=True)


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def verify_quartic_slices() -> None:
    emitter = load_module("m3_verify_quartic_slice_emitter", HERE / "emit_quartic_slice.py")
    for prime in (23, 67):
        fresh_input, fresh_manifest = emitter.build(prime)
        installed_input = (HERE / f"quartic_slice_p{prime}.in").read_text()
        installed_manifest = json.loads(
            (HERE / f"quartic_slice_p{prime}.json").read_text()
        )
        assert fresh_input == installed_input, f"quartic_slice_p{prime}.in drift"
        assert fresh_manifest == installed_manifest, (
            f"quartic_slice_p{prime}.json drift"
        )
        assert fresh_manifest["schema"] == (
            "m3-degree4-section-fixed-b-square-slice-v1"
        )
        assert fresh_manifest["scope"] == "modular discovery only"
        assert fresh_manifest["dimension_status"] == (
            "unresolved; square equation count does not imply dimension zero"
        )
        assert len(fresh_manifest["unknowns"]) == 13
        assert fresh_manifest["equation_count"] == 13
    print("PASS reproducible quartic slices p=23,67", flush=True)


def verify_packet_semantics() -> None:
    required = {
        "COMPLETION_AUDIT.md",
        "DEGREE4.md",
        "FIBRATION_MODEL.md",
        "INPUT_MANIFEST.json",
        "INPUT_REPLAY.md",
        "LINE_FROBENIUS_SPECIALIZATIONS.md",
        "LINE_MONODROMY.md",
        "QUARTIC_MULTISECTIONS.md",
        "RESIDUAL_CONSTRUCTIONS.md",
        "SECTION_CLASSES.json",
        "SECTION_SEARCH.md",
        "STATUS.md",
        "fibration_model.json",
        "line_frobenius_specializations.json",
        "line_monodromy.json",
        "line_pair_residuals.json",
        "modular_residual_section_p23.json",
        "modular_residual_section_p67.json",
        "modular_section_boundary_p23.json",
        "modular_section_boundary_p67.json",
        "quartic_branch.json",
        "quartic_slice_p23.in",
        "quartic_slice_p23.json",
        "quartic_slice_p67.in",
        "quartic_slice_p67.json",
        "SEAL.json",
    }
    assert all((HERE / name).is_file() for name in required)
    assert not (HERE / "POINT.md").exists()
    assert not (HERE / "BRIDGE_SARKISOV_POS.md").exists()

    status = (HERE / "STATUS.md").read_text()
    assert status.splitlines()[0] == "M3-INTEGRAL-DEGREE4-MULTISECTION"
    assert "section_question: UNDECIDED" in status
    assert "headline: OPEN" in status
    assert "M3-UNDECIDED" not in status

    quartic = json.loads((HERE / "quartic_branch.json").read_text())
    assert quartic["verdict"]["terminal_exit"] == "M3-INTEGRAL-DEGREE4-MULTISECTION"
    assert quartic["verdict"]["section_question"] == "UNDECIDED"
    assert quartic["verdict"]["headline"] == "OPEN"
    assert quartic["verdict"]["integral_degree_four_multisection_exists"] is True
    assert quartic["verdict"]["selects_section_alternative"] is False

    model = json.loads((HERE / "fibration_model.json").read_text())
    assert model["scope"]["rational_section_produced"] is False
    assert model["scope"]["headline"] == "OPEN"

    monodromy = json.loads((HERE / "line_monodromy.json").read_text())
    assert "exit_label" not in monodromy
    assert monodromy["component_status"] == (
        "LEFSCHETZ-AND-CONDITIONAL-WEYL-REDUCTION-CERTIFIED"
    )
    assert monodromy["obstruction_ledger"][
        "actual_geometric_27_line_monodromy"
    ] == "UNRESOLVED"

    frobenius = json.loads(
        (HERE / "line_frobenius_specializations.json").read_text()
    )
    assert frobenius["schema"] == "m3-27-line-frobenius-specializations-v1"
    assert len(frobenius["specializations"]) == 6
    assert frobenius["strict_scope"]["status_marker"] == (
        "ACTUAL_GENERIC_27_LINE_MONODROMY_UNRESOLVED"
    )
    assert frobenius["modular_arithmetic_monodromy_constraints"][
        "meaning"
    ].startswith("For each characteristic separately")

    residual = json.loads((HERE / "line_pair_residuals.json").read_text())
    assert residual["checks"]["unordered_pairs"] == 1485
    assert residual["checks"]["pair_orbit_sizes"] == [165, 330, 165, 330, 165, 330]
    assert "finite-field" in residual["theorem_boundary"]
    assert "characteristic-zero" in residual["theorem_boundary"]

    for prime in (23, 67):
        boundary = json.loads(
            (HERE / f"modular_section_boundary_p{prime}.json").read_text()
        )
        assert boundary["scope"] == "modular discovery only"
        assert boundary["degree4_common_zero_free"] is False

        modular_residual = json.loads(
            (HERE / f"modular_residual_section_p{prime}.json").read_text()
        )
        assert modular_residual["schema"] == (
            "m3-two-prime-gcd-free-residual-section-v1"
        )
        assert modular_residual["scope"] == (
            "split good-reduction component evidence only"
        )
        assert modular_residual["residual_H_degree"] == 4
        assert modular_residual["residual_common_gcd_degree"] == 0
        assert modular_residual["jacobian_rank_of_13_equations"] == 13
        assert modular_residual["projective_local_dimension_if_smooth"] == 5
        assert modular_residual["section_equations_zero"] is True
        assert modular_residual["graph_identity_zero"] is True

        slice_data = json.loads((HERE / f"quartic_slice_p{prime}.json").read_text())
        assert slice_data["schema"] == "m3-degree4-section-fixed-b-square-slice-v1"
        assert slice_data["scope"] == "modular discovery only"
        assert len(slice_data["unknowns"]) == slice_data["equation_count"] == 13

    print("PASS packet exit and theorem-boundary semantics", flush=True)


def sealed_files() -> dict[str, str]:
    return {
        str(path.relative_to(HERE)): digest(path)
        for path in sorted(HERE.rglob("*"))
        if path.is_file()
        and path.name != "SEAL.json"
        and "__pycache__" not in path.parts
        and path.suffix != ".pyc"
    }


def verify_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "m3-sarkisov-section-seal-v1"
    assert seal["terminal_exit"] == "M3-INTEGRAL-DEGREE4-MULTISECTION"
    assert seal["section_question"] == "UNDECIDED"
    assert seal["headline"] == "OPEN"
    assert seal["theorem_ledger"][
        "integral_finite_flat_degree_four_multisection"
    ] is True
    assert all(value is False for value in seal["strict_boundaries"].values())
    expected = sealed_files()
    assert expected == seal["files"]
    assert seal["input_manifest_sha256"] == digest(HERE / "INPUT_MANIFEST.json")
    print(f"PASS recursive durable seal files={len(expected)}", flush=True)


def main() -> None:
    verify_manifest()

    run(
        PROBLEM
        / "goal_runs_after_35fa/M_SARKISOV/links/schur_plane_012_dp3/verify_link.py",
        "M2_SCHUR_PLANE_LINK_INDEPENDENT_VERIFY_OK",
    )
    run(
        PROBLEM / "goal_runs_after_35fa/M_SARKISOV/verify_census.py",
        "M2_CENTRE_CENSUS_INDEPENDENT_VERIFY_OK",
    )
    run(
        PROBLEM
        / "goals_2026-08-01/Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D/verify_all.py",
        "Q_SCHUR_EXACT_FRAME_PACKET_VERIFY_ALL_OK",
    )
    run(
        PROBLEM
        / "goals_2026-08-01/Q_SCHUR_DESCENT/verify_quartic_frontier.py",
        "Q_SCHUR_QUARTIC_FRONTIER_EXACT",
    )
    run(
        PROBLEM
        / "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/quartic_descent/verify_field_certificate.py",
        "Q_SCHUR_QUARTIC_FIELD_INDEPENDENCE_EXACT",
    )
    run(
        PROBLEM
        / "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/root_secant/verify_resolvent_geometry.py",
        "Q_SCHUR_RESOLVENT_GEOMETRY_INDEPENDENT_REPLAY_OK",
    )

    compare_json_producer(
        HERE / "produce_fibration_model.py", HERE / "fibration_model.json"
    )
    compare_json_producer(
        HERE / "produce_section_classes.py", HERE / "SECTION_CLASSES.json"
    )
    run(
        HERE / "verify_fibration_sections.py",
        "M3_FIBRATION_AND_SECTION_BOUNDARY_INDEPENDENT_VERIFY_OK",
    )
    verify_quartic_slices()
    run(
        HERE / "verify_quartic_branch.py",
        "M3_QUARTIC_BRANCH_INDEPENDENT_VERIFY_OK",
    )
    run(
        HERE / "produce_line_monodromy.py",
        "M3_LINE_MONODROMY_REDUCTION_CERTIFICATE_OK",
        arguments=("--check",),
    )
    run(
        HERE / "verify_line_monodromy.py",
        "M3_LINE_MONODROMY_INDEPENDENT_VERIFY_OK",
    )
    run(
        HERE / "produce_line_frobenius.py",
        "M3_27_LINE_FROBENIUS_SPECIALIZATIONS_EXACT",
    )
    run(
        HERE / "verify_line_frobenius.py",
        "M3_27_LINE_FROBENIUS_SPECIALIZATIONS_EXACT",
    )
    run(
        HERE / "verify_line_pair_residuals.py",
        "M3_LINE_PAIR_RESIDUALS_INDEPENDENT_VERIFY_OK",
    )

    verify_packet_semantics()
    compare_json_producer(HERE / "produce_seal.py", HERE / "SEAL.json")
    verify_seal()
    self_rss = int(resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)
    child_rss = int(resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss)
    rss_unit = "bytes" if sys.platform == "darwin" else "kilobytes"
    print(
        f"RESOURCE_MAXRSS_SELF={self_rss} "
        f"RESOURCE_MAXRSS_CHILDREN={child_rss} UNIT={rss_unit}",
        flush=True,
    )
    print("M3_SARKISOV_SECTION_PACKET_VERIFY_ALL_OK")


if __name__ == "__main__":
    main()
