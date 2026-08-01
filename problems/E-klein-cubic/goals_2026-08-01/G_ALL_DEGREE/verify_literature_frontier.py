#!/usr/bin/env python3
"""Verify the locally archived July 18, 2026 frontier source and scope note."""

from __future__ import annotations

import hashlib
import shutil
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
SOURCE = PROBLEM / "tmp/pdfs/bguni-author-2026.pdf"
EXPECTED_SHA256 = "3fbc3ae9c55adcef5b61bc49c215c289610202e8943b6ec8cf47761e79967cd3"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    assert SOURCE.is_file(), SOURCE
    assert sha256(SOURCE) == EXPECTED_SHA256
    pdftotext = shutil.which("pdftotext")
    assert pdftotext is not None, "pdftotext is required for the source replay"
    completed = subprocess.run(
        [pdftotext, str(SOURCE), "-"],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    normalized = " ".join(completed.stdout.split())
    assert "Date: July 18, 2026." in normalized
    assert "PSL2 (F11 )" in normalized
    assert "Klein cubic threefold" in normalized
    assert "Their equivariant unirationalities are open." in normalized

    note = " ".join((HERE / "LITERATURE_FRONTIER.md").read_text().split())
    for phrase in (
        "refreshed on 2026-08-01",
        "G-STRUCTURAL-UNDECIDED",
        "do not themselves prove",
        "does not control the intersection",
    ):
        assert phrase in note

    print("G_CURRENT_LITERATURE_FRONTIER_2026_07_18_OPEN_OK")
    print("SCOPE literature status only; no headline theorem inferred")


if __name__ == "__main__":
    main()
