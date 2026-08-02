#!/usr/bin/env python3

from hashlib import sha256
import json
from pathlib import Path


HERE=Path(__file__).resolve().parent
files={
    path.relative_to(HERE).as_posix():sha256(path.read_bytes()).hexdigest()
    for path in HERE.rglob("*")
    if path.is_file() and path.name!="SEAL.json" and "__pycache__" not in path.parts
}
(HERE/"SEAL.json").write_text(json.dumps({
    "format":"Q-11_5-FOUR-KUMMER-SEAL-v1",
    "status":"Q-UNDECIDED",
    "files":files,
},indent=2,sort_keys=True)+"\n")
print(f"Q_11_5_FOUR_KUMMER_SEAL_WRITTEN files={len(files)}")
