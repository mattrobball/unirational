#!/usr/bin/env python3
"""Write the recursive seal for this child packet."""

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
files = {
    path.relative_to(HERE).as_posix(): sha256(path.read_bytes()).hexdigest()
    for path in HERE.rglob("*")
    if path.is_file() and path.name != "SEAL.json" and "__pycache__" not in path.parts
}
payload = {"format": "Q-11_5-TRACE-SPARSE-SEAL-v1", "files": files}
(HERE/"SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True)+"\n")
print(f"Q_11_5_TRACE_SPARSE_SEAL_WRITTEN files={len(files)}")
