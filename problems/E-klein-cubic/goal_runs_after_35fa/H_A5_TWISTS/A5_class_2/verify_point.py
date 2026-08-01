#!/usr/bin/env python3
"""Class-specific replay of the exact A5_class_2 point certificate."""

from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
result = subprocess.run(
    [sys.executable, str(ROOT / "independent" / "verify_points.py"), "--class", "2"],
    cwd=ROOT,
    check=True,
    capture_output=True,
    text=True,
)
print(result.stdout, end="")
assert "H3_A5_CLASS2_POINT_VERIFY_OK" in result.stdout
