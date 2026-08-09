#!/usr/bin/env python3
"""Packet integrity and replay audit."""

from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent


def main() -> None:
    theorem = (HERE / "THEOREM.md").read_text()
    status = (HERE / "STATUS.md").read_text()
    sources = (HERE / "SOURCES.md").read_text()
    for marker in (
        "SCHUR-QUARTIC-KERNEL-COMPONENT-IS-KLEIN",
        "SCHUR-QUARTIC-RANK20-CHART-EXACT",
        "SCHUR-QUARTIC-NORMAL-O1-O1-GENERIC",
        "HEADLINE-OPEN",
    ):
        assert marker in theorem
        assert marker in status
    for marker in (
        "25 x 21",
        "12 x 5",
        "rank exactly 20",
        "HEADLINE-OPEN",
    ):
        assert marker in theorem or marker in status
    for source in ("Kuznetsov", "Flamini", "Tschinkel"):
        assert source in sources
    for path in (
        HERE.parent / "SCHUR_CONIC_CURVES/THEOREM.md",
        HERE.parent / "SCHUR_QUARTIC_MODULI/THEOREM.md",
        HERE.parents[1] / "tmp/pfaffian_representation_alignment/core.py",
        HERE.parents[1] / "tmp/pfaffian_representation_alignment/certificate.json",
    ):
        assert path.is_file(), path
    for path in HERE.glob("*.md"):
        text = path.read_text()
        assert not any(
            ord(character) < 32 and character not in "\n\t"
            or ord(character) == 127
            for character in text
        ), path
        assert text.count(r"\(") == text.count(r"\)"), path
        assert text.count(r"\[") == text.count(r"\]"), path

    for script, marker in (
        ("verify_exact.py", "SCHUR-QUARTIC-KERNEL-COMPONENT-EXACT-OK"),
        ("verify_good_primes.py", "SCHUR-QUARTIC-RANK20-TWO-GOOD-PRIMES-OK"),
        ("verify_seal.py", "SCHUR-QUARTIC-ARITHMETIC-SEAL-OK"),
    ):
        result = subprocess.run(
            ["/opt/homebrew/bin/python3", script],
            cwd=HERE,
            check=True,
            text=True,
            capture_output=True,
        )
        assert marker in result.stdout
        print(result.stdout, end="")
    print("SCHUR-QUARTIC-ARITHMETIC-AUDIT PASS")


if __name__ == "__main__":
    main()
