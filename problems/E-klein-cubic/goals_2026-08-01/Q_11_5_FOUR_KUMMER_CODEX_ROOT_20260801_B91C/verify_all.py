#!/usr/bin/env python3
"""Independent replay for the four-Kummer all-exponent support theorem."""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = next(parent for parent in (HERE, *HERE.parents)
               if parent.name == "E-klein-cubic")


def verify_sources():
    manifest = json.loads((HERE/"source_manifest.json").read_text())
    assert manifest["format"] == "Q-11_5-FOUR-KUMMER-SOURCE-MANIFEST-v1"
    for record in manifest["sources"]:
        path = PROBLEM/record["repo_relative_path"]
        assert path.is_file(), path
        assert sha256(path.read_bytes()).hexdigest() == record["sha256"]
    print("PASS immutable trace-model sources")


def run(script, marker):
    result = subprocess.run(
        [sys.executable,"-u",str(HERE/script)], cwd=HERE, text=True,
        capture_output=True, check=True,
    )
    print(result.stdout,end="")
    assert marker in result.stdout


def verify_docs():
    theorem=(HERE/"THEOREM.md").read_text()
    status=(HERE/"STATUS.md").read_text()
    assert "177365" in theorem and "37770" in theorem and "605" in theorem
    assert "all five nonzero Kummer coordinates" in theorem
    assert status.startswith("Q-UNDECIDED")
    assert "No `K`-point" in status
    print("PASS theorem scope and strict nonclaims")


def verify_seal():
    seal=json.loads((HERE/"SEAL.json").read_text())
    assert seal["format"]=="Q-11_5-FOUR-KUMMER-SEAL-v1"
    files={
        path.relative_to(HERE).as_posix():sha256(path.read_bytes()).hexdigest()
        for path in HERE.rglob("*")
        if path.is_file() and path.name!="SEAL.json" and "__pycache__" not in path.parts
    }
    assert seal["files"]==files
    print(f"PASS recursive packet seal files={len(files)}")


def main():
    verify_sources()
    run("screen_four_modular.py","H_TRACE_FOUR_KUMMER_UNIQUE_MOD3_SUPPORT_CLASSES_OK")
    run("exact_four_rank3.py","H_TRACE_FOUR_KUMMER_RANK3_EXCLUSION_OK")
    run("exact_four_low_rank.py","H_TRACE_FOUR_KUMMER_RANK1_RANK2_EXCLUSION_OK")
    verify_docs()
    verify_seal()
    print("Q_11_5_FOUR_KUMMER_PACKET_VERIFY_ALL_OK")


if __name__=="__main__":
    main()
