#!/usr/bin/env python3
"""Run the M2 calibration matrix and write auditable JSONL/Markdown logs."""

from __future__ import annotations

import argparse
import datetime as dt
import json
import pathlib
import subprocess
import sys
import time


FIELDS = [
    "candidate",
    "field",
    "projectively_smooth",
    "affine_singular_ideal_dimension",
    "smoothness_cpu_seconds",
    "pivot_chart",
    "line_u",
    "line_v",
    "active_chart_equations",
    "fixture_line_on_hypersurface",
    "chart_jacobian_rank",
    "chart_tangent_dimension",
    "krull_local_dimension_lower_bound",
    "local_certificate_status",
    "certified_local_dimension",
    "chart_jacobian_cpu_seconds",
    "global_fano_dimension_status",
]

BOOL_FIELDS = {"projectively_smooth", "fixture_line_on_hypersurface"}
INT_FIELDS = {
    "affine_singular_ideal_dimension",
    "active_chart_equations",
    "chart_jacobian_rank",
    "chart_tangent_dimension",
    "krull_local_dimension_lower_bound",
    "certified_local_dimension",
}
FLOAT_FIELDS = {"smoothness_cpu_seconds", "chart_jacobian_cpu_seconds"}


def parse_scalar(field: str, value: str):
    if field in BOOL_FIELDS:
        if value not in {"true", "false"}:
            raise ValueError(f"bad Boolean for {field}: {value!r}")
        return value == "true"
    if field in INT_FIELDS:
        return int(value)
    if field in FLOAT_FIELDS:
        return float(value)
    return value


def parse_results(stdout: str) -> list[dict]:
    rows: list[dict] = []
    for line in stdout.splitlines():
        if not line.startswith("CAL|"):
            continue
        values = line.split("|")[1:]
        if len(values) != len(FIELDS):
            raise ValueError(
                f"expected {len(FIELDS)} result fields, got {len(values)}: {line}"
            )
        rows.append(
            {field: parse_scalar(field, value) for field, value in zip(FIELDS, values)}
        )
    if len(rows) != 12:
        raise ValueError(f"expected 12 calibration rows, got {len(rows)}")
    return rows


def classify(row: dict) -> str:
    if not row["projectively_smooth"]:
        return "ineligible_singular_hypersurface"
    if row["local_certificate_status"] != "certified_regular_local_dimension":
        return "local_dimension_not_certified"
    local_dim = row["certified_local_dimension"]
    if row["field"] == "QQ":
        return (
            "certified_local_excess_over_Q"
            if local_dim >= 7
            else "fixture_component_has_expected_local_dimension_only"
        )
    return (
        "certified_positive_characteristic_excess_no_QQ_implication"
        if local_dim >= 7
        else "positive_characteristic_expected_local_dimension_only"
    )


def validate_calibrations(rows: list[dict]) -> None:
    def require(condition: bool, message: str) -> None:
        if not condition:
            raise ValueError(f"calibration validation failed: {message}")

    by_key = {(row["candidate"], row["field"]): row for row in rows}
    candidates = {"fermat", "klein_10_cycle", "five_2_cycles", "chain"}
    fields = {"QQ", "F2", "F7"}
    expected_keys = {(candidate, field) for candidate in candidates for field in fields}

    require(len(by_key) == len(rows), "duplicate candidate/field row")
    require(set(by_key) == expected_keys, "candidate/field matrix is incomplete")

    for candidate in candidates:
        q = by_key[candidate, "QQ"]
        require(q["projectively_smooth"], f"{candidate}/QQ is not smooth")
        require(
            (q["active_chart_equations"], q["chart_jacobian_rank"]) == (10, 10),
            f"{candidate}/QQ does not have the expected full-rank chart fixture",
        )
        require(
            q["certified_local_dimension"] == 6,
            f"{candidate}/QQ local dimension is not 6",
        )

        f2 = by_key[candidate, "F2"]
        require(
            (f2["active_chart_equations"], f2["chart_jacobian_rank"]) == (4, 4),
            f"{candidate}/F2 does not have the expected rank-four chart fixture",
        )
        require(
            f2["certified_local_dimension"] == 12,
            f"{candidate}/F2 local dimension is not 12",
        )

        f7 = by_key[candidate, "F7"]
        require(
            (f7["active_chart_equations"], f7["chart_jacobian_rank"]) == (6, 6),
            f"{candidate}/F7 does not have the expected rank-six chart fixture",
        )
        require(
            f7["certified_local_dimension"] == 10,
            f"{candidate}/F7 local dimension is not 10",
        )

        for field in fields:
            row = by_key[candidate, field]
            require(
                0 <= row["chart_jacobian_rank"] <= row["active_chart_equations"] <= 10,
                f"{candidate}/{field} has impossible equation/rank counts",
            )
            require(
                row["chart_tangent_dimension"] == 16 - row["chart_jacobian_rank"],
                f"{candidate}/{field} tangent dimension is inconsistent with rank",
            )
            require(
                row["krull_local_dimension_lower_bound"]
                == 16 - row["active_chart_equations"],
                f"{candidate}/{field} Krull lower bound is inconsistent",
            )
            require(
                row["fixture_line_on_hypersurface"],
                f"{candidate}/{field} fixture is not a line on the hypersurface",
            )
            require(
                row["local_certificate_status"] == "certified_regular_local_dimension",
                f"{candidate}/{field} local dimension is not certified",
            )
            require(
                row["chart_jacobian_rank"] == row["active_chart_equations"]
                and row["certified_local_dimension"] == row["chart_tangent_dimension"],
                f"{candidate}/{field} regular-local certificate is internally inconsistent",
            )
            require(
                row["projectively_smooth"]
                == (row["affine_singular_ideal_dimension"] == 0),
                f"{candidate}/{field} smoothness flag and singular-cone dimension disagree",
            )
            require(
                row["interpretation"] == classify(row),
                f"{candidate}/{field} interpretation is inconsistent",
            )
            require(
                row["global_fano_dimension_status"] == "not_checked",
                f"{candidate}/{field} unexpectedly claims a global Fano dimension",
            )

    expected_smooth = {
        ("fermat", "F2"),
        ("klein_10_cycle", "F2"),
        ("five_2_cycles", "F2"),
        ("fermat", "F7"),
        ("chain", "F7"),
    }
    for candidate in candidates:
        for field in {"F2", "F7"}:
            require(
                by_key[candidate, field]["projectively_smooth"]
                == ((candidate, field) in expected_smooth),
                f"{candidate}/{field} smoothness differs from the calibration fixture",
            )


def tool_version(command: list[str]) -> str:
    try:
        completed = subprocess.run(
            command, check=False, capture_output=True, text=True, timeout=10
        )
    except (OSError, subprocess.TimeoutExpired) as exc:
        return f"unavailable ({exc})"
    text = (completed.stdout + completed.stderr).strip()
    return text.splitlines()[0] if text else f"exit {completed.returncode}"


def write_markdown(
    path: pathlib.Path,
    rows: list[dict],
    driver_command_display: str,
    m2_command_display: str,
    generated_at: str,
    wall_seconds: float,
    m2_version: str,
    msolve_version: str,
) -> None:
    lines = [
        "# Degree-9 Fano-line calibration run",
        "",
        f"Generated: `{generated_at}`",
        "",
        f"Driver command: `{driver_command_display}`",
        "",
        f"Macaulay2 command invoked by the driver: `{m2_command_display}`",
        "",
        f"Harness wall time: `{wall_seconds:.6f}` seconds",
        "",
        f"Macaulay2: `{m2_version}`",
        "",
        f"msolve: `{msolve_version}` (inventoried only; this local certificate run does not invoke it)",
        "",
        "| candidate | field | smooth | active eqs | Jacobian rank | tangent dim | Krull lower bound | certified local dim | interpretation | global Fano dim |",
        "|---|---:|:---:|---:|---:|---:|---:|---:|---|---|",
    ]
    for row in rows:
        certified = (
            str(row["certified_local_dimension"])
            if row["certified_local_dimension"] >= 0
            else "not certified"
        )
        lines.append(
            "| {candidate} | {field} | {smooth} | {eqs} | {rank} | {tangent} | "
            "{lower} | {certified} | {interpretation} | {global_status} |".format(
                candidate=row["candidate"],
                field=row["field"],
                smooth="yes" if row["projectively_smooth"] else "no",
                eqs=row["active_chart_equations"],
                rank=row["chart_jacobian_rank"],
                tangent=row["chart_tangent_dimension"],
                lower=row["krull_local_dimension_lower_bound"],
                certified=certified,
                interpretation=row["interpretation"],
                global_status=row["global_fano_dimension_status"],
            )
        )

    lines += [
        "",
        "## Scope of the certificates",
        "",
        "`projectively_smooth=yes` is certified by saturating the homogeneous singular ideal "
        "`(F, partial F)` by the irrelevant ideal. Including `F` keeps the test correct even "
        "when the characteristic divides the degree.",
        "",
        "A reported local dimension is exact because the explicitly supplied line lies on the "
        "hypersurface and the chart Jacobian rank equals the number of active chart equations. "
        "The tangent-space upper bound and Krull lower bound therefore coincide.",
        "",
        "No row certifies a global upper bound for `dim F_1(X)`. The 45 standard pivot charts "
        "`U_ij` cover `G(1,9)`; all 45 (or an equivalent rank-two Stiefel saturation) must be "
        "checked to certify a global null result. One exact chart with local dimension at least "
        "7 would suffice for a lower-bound/refutation certificate over `QQ`.",
        "",
        "The smooth `F2` and `F7` excess rows are genuine positive-characteristic "
        "counterexamples to a field-free statement. They are not counterexamples over `QQ` "
        "and imply no characteristic-zero excess; their equation-count collapse is "
        "characteristic-induced.",
        "",
    ]
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output-dir",
        type=pathlib.Path,
        default=pathlib.Path("results"),
        help="output directory relative to the workspace (default: results)",
    )
    args = parser.parse_args()

    root = pathlib.Path(__file__).resolve().parents[1]
    script = root / "calibration" / "calibrate.m2"
    output_dir = args.output_dir
    if not output_dir.is_absolute():
        output_dir = root / output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    command = ["M2", "--script", str(script)]
    driver_command_display = "python3 tools/run_calibrations.py"
    m2_command_display = "M2 --script calibration/calibrate.m2"
    started = time.perf_counter()
    completed = subprocess.run(
        command, cwd=root, check=False, capture_output=True, text=True
    )
    wall_seconds = time.perf_counter() - started
    if completed.returncode != 0:
        sys.stderr.write(completed.stdout)
        sys.stderr.write(completed.stderr)
        return completed.returncode

    rows = parse_results(completed.stdout)
    for row in rows:
        row["interpretation"] = classify(row)
    validate_calibrations(rows)

    generated_at = dt.datetime.now(dt.timezone.utc).isoformat()
    m2_version = tool_version(["M2", "--version"])
    msolve_version = tool_version(["msolve", "-V"])

    common = {
        "generated_at_utc": generated_at,
        "driver_command": driver_command_display,
        "macaulay2_command": m2_command_display,
        "harness_wall_seconds": wall_seconds,
        "macaulay2_version": m2_version,
        "msolve_version": msolve_version,
    }
    jsonl_path = output_dir / "calibration.jsonl"
    with jsonl_path.open("w", encoding="utf-8") as handle:
        for row in rows:
            handle.write(json.dumps(common | row, sort_keys=True) + "\n")

    markdown_path = output_dir / "calibration.md"
    write_markdown(
        markdown_path,
        rows,
        driver_command_display,
        m2_command_display,
        generated_at,
        wall_seconds,
        m2_version,
        msolve_version,
    )

    print(f"wrote {jsonl_path}")
    print(f"wrote {markdown_path}")
    print(f"validated {len(rows)} calibration rows")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
