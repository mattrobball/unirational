#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open('rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()

seal = json.loads((HERE / 'SEAL.json').read_text())
for rel, expected in seal['files'].items():
    path = HERE / rel
    assert path.is_file(), rel
    assert sha256(path) == expected, rel

for line in (HERE / 'SHA256SUMS').read_text().splitlines():
    expected, rel = line.split('  ', 1)
    assert sha256(HERE / rel) == expected, rel

assert seal['exit'] == 'DEGREE25-BOUNDARY-EXTENSION-OBSTRUCTED'
assert seal['headline'] == 'OPEN'
print('DEGREE25_MARKED_ELLIPTIC_SEAL_OK')
