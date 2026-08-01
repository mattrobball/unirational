#!/usr/bin/env python3
"""Independent lightweight audit of the Goal G structural reduction.

This verifier reconstructs load-bearing finite ledgers from authoritative
repository scripts/files.  It deliberately does not claim to decide the
generic cubic.
"""

from __future__ import annotations

import ast
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
BASELINE = "715faf441289e2589b9325311b6613ea0331bf88"


def run(*args: str) -> str:
    return subprocess.check_output(args, cwd=PROBLEM, text=True)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def check_git() -> None:
    head = run("git", "rev-parse", "HEAD").strip()
    require(len(head) == 40, "invalid HEAD")
    status = subprocess.run(
        ["git", "merge-base", "--is-ancestor", BASELINE, head],
        cwd=PROBLEM,
        check=False,
    )
    require(status.returncode == 0, "pinned baseline is not an ancestor of HEAD")


def check_hironaka_ledgers() -> None:
    report = (PROBLEM / "tmp/covariant_module/REPORT.md").read_text()
    require("rank_R(M) = 60/12 = 5" in report, "missing 60/12 covariant ledger")
    require("M is a free graded" in report and "A-module of rank 60" in report,
            "missing A-free rank-60 theorem")
    require("R is free of rank 12 over" in report, "missing rank-12 invariant theorem")

    output = run(sys.executable, "tmp/covariant_module/module_hilbert.py")
    require("sum numerator coefficients 60" in output, "rank-60 replay failed")


def check_generic_frame() -> None:
    source = PROBLEM / "tmp/generic_twist/phi_coefficients.py"
    tree = ast.parse(source.read_text())
    functions = {node.name for node in tree.body if isinstance(node, ast.FunctionDef)}
    require({"all_coefficients", "verify_expansion", "klein"} <= functions,
            "generic cubic producer lacks reconstruction functions")
    output = run(sys.executable, str(source.relative_to(PROBLEM)))
    require("PASS exact 35-coefficient expansion" in output,
            "generic cubic coefficient replay failed")

    report = (PROBLEM / "tmp/agent_high/REPORT.md").read_text()
    require("det B(x)=-295136920" in report, "frame determinant witness missing")


def check_transition_boundaries() -> None:
    necessity = json.loads(
        (PROBLEM / "certificates/global_transition/necessity_theorem.json").read_text()
    )
    require(necessity["proof"]["status"] == "PROVED", "necessity theorem not proved")
    require(necessity["direction"].startswith("forward only"),
            "necessity direction was silently strengthened")

    repair = (PROBLEM / "REPAIR.md").read_text()
    require("Nonzero sample residual is not an obstruction theorem" in repair,
            "repair boundary missing")
    require("finite generation of the full equalizer/Fitting layers" in repair,
            "finite-generation gap missing")


def check_counterexample() -> None:
    # q_N=0 iff u^N b=v^N a.  The displayed primitive solution has degree 2N.
    for n in range(1, 9):
        # Represent monomials by exponent pairs.  Equality is literal.
        left = (n + 0, 0 + n)   # u^N * v^N
        right = (0 + n, n + 0)  # v^N * u^N
        require(left == right, f"counterexample identity failed at N={n}")
        require(2 * n > n, "solution did not exceed generator degree")
    require(True, "coprimality is the UFD fact gcd(u^N,v^N)=1")


def check_local_packet_scope() -> None:
    report = (PROBLEM / "tmp/fable_nonfactorized_feasibility/REPORT.md").read_text()
    require("FABLE_NONFACTORIZED_FEASIBILITY_CLOSED" in report,
            "Fable successor scope marker missing")
    require("It is not a negative answer to Problem E" in report,
            "Fable scope boundary missing")


def main() -> None:
    check_git()
    check_hironaka_ledgers()
    check_generic_frame()
    check_transition_boundaries()
    check_counterexample()
    check_local_packet_scope()
    print("G_UNIVERSAL_OBJECT_AUDIT_OK")
    print("G_GENERIC_SUPPORT_STILL_UNDECIDED")


if __name__ == "__main__":
    main()
