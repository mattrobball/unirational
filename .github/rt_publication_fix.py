#!/usr/bin/env python3
from __future__ import annotations

import re
import subprocess
from pathlib import Path

ROOT = Path("problems/E-klein-cubic")
NOTEBOOK = ROOT / "NOTEBOOK.md"
THEOREM = ROOT / "goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md"


def main() -> None:
    head = subprocess.check_output(["git", "rev-parse", "HEAD"], text=True).strip()

    notebook = NOTEBOOK.read_text(encoding="utf-8")
    notebook, count = re.subn(
        r"(notebook parent head: `)[0-9a-f]{7,40}(`)",
        lambda match: match.group(1) + head + match.group(2),
        notebook,
        count=1,
    )
    if count != 1:
        raise SystemExit("could not update notebook parent-head pin")

    old_pr = "Draft PR: **#16**."
    new_pr = "Initial packet PR: **#16**; continuation draft PR: **#18**."
    if old_pr not in notebook:
        raise SystemExit("expected final RT notebook PR marker not found")
    notebook = notebook.replace(old_pr, new_pr, 1)
    NOTEBOOK.write_text(notebook, encoding="utf-8")

    theorem = THEOREM.read_text(encoding="utf-8")
    if r"u_\varphi" not in theorem:
        raise SystemExit("expected u_phi notation not found")
    if r"\nu_\varphi" in theorem:
        raise SystemExit("unexpected Greek-nu notation found")

    print(f"NOTEBOOK_PR_REFERENCE_CORRECTED_OK ({old_pr} -> {new_pr})")
    print("U_PHI_NOTATION_ALREADY_CORRECT_OK")


if __name__ == "__main__":
    main()
