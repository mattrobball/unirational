#!/usr/bin/env python3
"""Verify the full-G restriction-dominance theorem packet and its sources."""

from __future__ import annotations

import hashlib
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PACKET = Path(__file__).resolve().parent

PINNED = {
    "tmp/pdfs/duncan-reichstein-1109.6093.txt":
        "86248770200401a3874ee7c128b1aaf8246b106b65405b7f10804d037c4dab42",
    "tmp/pdfs/cheltsov-krylov-mau-2604.20426.txt":
        "01a6eef59c618ac120fb60b4ccf84e90210ba117694b1539a05fcd3201e427e9",
    "goals_2026-08-01/D_EQUIVARIANT_MOTIVE/BLOWUP_CLOSURE.md":
        "59ba39953c81e1275b057b5d417af20e02f9d6b37dd4ca78877e4b26b5b0164d",
    "goals_2026-08-01/KLS_MINIMALITY/INTERFACE_AUDIT.md":
        "3d18edebfdb7e6c0f4563abf089d953d7a7e06cec80736c4dac47cc51215e084",
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


for relative, expected in PINNED.items():
    path = ROOT / relative
    assert path.is_file(), f"missing source: {relative}"
    assert digest(path) == expected, f"source hash drift: {relative}"

dr = (ROOT / "tmp/pdfs/duncan-reichstein-1109.6093.txt").read_text(
    encoding="utf-8", errors="replace"
)
assert "3 ⩽ ed(PSL2 (F11 )) ⩽ 4" in dr
assert "cannot act faithfully on a unirational surface" in dr
assert "Since φ is irreducible, no point of X can be fixed by G" in dr

ckm = (ROOT / "tmp/pdfs/cheltsov-krylov-mau-2604.20426.txt").read_text(
    encoding="utf-8", errors="replace"
)
assert "X is said to be G-birationally superrigid" in ckm
assert "X is the Klein cubic" in ckm
assert "G ≃ PSL2 (F11 ), A5" in ckm
assert "[CS14, Theorem A.5]" in ckm

blowup = (
    ROOT / "goals_2026-08-01/D_EQUIVARIANT_MOTIVE/BLOWUP_CLOSURE.md"
).read_text(encoding="utf-8")
assert r"exactly \(660\) components" in blowup
assert "does not assert that this centre occurs in the base locus" in blowup
assert "Neither condition follows from dominance alone" in blowup

quartic = (
    ROOT / "goals_2026-08-01/KLS_MINIMALITY/INTERFACE_AUDIT.md"
).read_text(encoding="utf-8")
assert "defines a finite surjective" in quartic
assert "endomorphism of `P(W)` of degree `256`" in quartic
assert "has saturated degree" in quartic
assert "`4^n d`" in quartic

theorem = (PACKET / "THEOREM.md").read_text(encoding="utf-8")
status = (PACKET / "STATUS.md").read_text(encoding="utf-8")
for marker in (
    "FULL-G-RESTRICTION-DOMINANT",
    "FULL-G-DEGREE-ONE-IMPLIES-RATIONAL-RETRACTION",
    "FULL-G-AMBIENT-RATIONAL-DEGREE-GREATER-ONE-GATE-OPEN",
    "FULL-G-GLOBAL-QUESTION-OPEN",
):
    assert marker in theorem
    assert marker in status

assert "degree one is not proved" in theorem
assert "Nothing in this packet decides that gate" in theorem
assert "No audited" in status

print("FULL-G-RESTRICTION-DOMINANCE-PACKET-OK")
