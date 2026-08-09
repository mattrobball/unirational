#!/usr/bin/env python3
"""Verify the SHA-256 manifest for this isolated packet."""

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def main():
    manifest = json.loads((HERE / "SEAL.json").read_text())
    assert manifest["packet"] == "CHAR5_THREE_RESIDUE_LIFTS_N8"
    for relative, expected in sorted(manifest["sha256"].items()):
        path = HERE / relative
        assert path.is_file(), f"missing sealed file: {relative}"
        actual = sha256(path.read_bytes()).hexdigest()
        assert actual == expected, (relative, expected, actual)
        print("SHA256_OK", relative, actual)
    print("CHAR5-THREE-RESIDUE-LIFTS-N8-SEAL-OK")


if __name__ == "__main__":
    main()
