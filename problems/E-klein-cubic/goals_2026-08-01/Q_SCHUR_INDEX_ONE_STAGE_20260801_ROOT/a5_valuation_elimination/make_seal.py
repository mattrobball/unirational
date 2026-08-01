#!/usr/bin/env python3
"""Write the recursive nonterminal packet seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def main():
    files = {
        str(path.relative_to(HERE)): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in sorted(HERE.rglob("*"))
        if path.is_file() and path.name != "SEAL.json" and "__pycache__" not in path.parts
    }
    seal = {
        "schema": "q-schur-a5-valuation-elimination-seal-v1",
        "governing_status": "Q-UNDECIDED",
        "theorem": "both maximal A5 classes are absent from an unramified henselian nonpoint",
        "surviving_decomposition_groups": ["PSL(2,11)", "11:5"],
        "strict_scope": "No global K_Schur point and no pointlessness obstruction is proved.",
        "files": files,
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print(f"WROTE SEAL.json files={len(files)}")


if __name__ == "__main__":
    main()
