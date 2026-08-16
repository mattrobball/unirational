#!/usr/bin/env python3
"""Drive the shipped D12 piece-vec generators and reduced_mul."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(Path(__file__).resolve().parent))

from export_d12_nonzero_piece_vec_lean import emit_entry
from export_d12_piece_vec_lean import (
    DEFAULT_JSON, as_fractions, emit_pa_entry, lcm_denoms, reduced_mul,
    scale_ints,
)

OLD_PRODUCT = "mul, conv, coeffAt, Fin.sum_univ_succ"


def load_payload():
    raw = DEFAULT_JSON.read_bytes()
    return json.loads(raw), hashlib.sha256(raw).hexdigest()


def piece_cells(payload, piece):
    p = payload["pieces"][piece]
    cells = []
    for row in p["X10x20"]:
        for entry in row:
            cells.append(as_fractions(entry))
    for row in p["A20x10"]:
        for entry in row:
            cells.append(as_fractions(entry))
    if p["dim"]:
        for row in p["K10xd"]:
            for entry in row:
                cells.append(as_fractions(entry))
        for row in p["Ydx10"]:
            for entry in row:
                cells.append(as_fractions(entry))
    return cells


def test_lcm_clears_at_132(payload):
    for piece in ("PA", "AP", "AA", "PP"):
        scale = lcm_denoms(piece_cells(payload, piece))
        assert scale <= 132, f"{piece} LCM {scale} exceeds 132"
        assert scale > 0


def test_scale_commutes_with_reduced_mul(payload):
    samples = [
        ("PA", 0, 0),
        ("AP", 7, 9),
        ("AA", 3, 4),
        ("PP", 2, 5),
    ]
    for piece, row, col in samples:
        p = payload["pieces"][piece]
        left = as_fractions(p["X10x20"][row][0])
        right = as_fractions(p["A20x10"][0][col])
        scale = lcm_denoms([left, right])
        prod = reduced_mul(left, right)
        scaled = reduced_mul(
            [x * scale for x in left],
            [x * scale for x in right],
        )
        expect = [x * scale * scale for x in prod]
        assert scaled == expect, f"{piece}({row},{col}) scale did not commute"
        for value in scale_ints(left, scale) + scale_ints(right, scale):
            assert isinstance(value, int)


def test_emit_uses_decide_not_norm_num_product(payload, sha):
    texts = {
        "PA": emit_pa_entry(payload, sha, 0, 1),
        "AP": emit_entry(payload, sha, "AP", 7, 9),
        "AA": emit_entry(payload, sha, "AA", 3, 4),
        "PP": emit_entry(payload, sha, "PP", 2, 5),
    }
    for piece, text in texts.items():
        assert "decide" in text, f"{piece} emit missing decide"
        assert "mulZ" in text and "sumFin" in text, f"{piece} emit missing integer mul"
        assert OLD_PRODUCT not in text, f"{piece} emit still has old product norm_num"
        assert "norm_num [xaProduct" not in text
        assert "norm_num [product" not in text




def test_challenge_solution_signatures_match():
    """Comparator compares exported ConstantVal; private abbrevs in the
    two modules become different constants. The type text must match."""
    root = Path(__file__).resolve().parents[1]
    def sigs(text: str) -> list[str]:
        out = []
        lines = text.splitlines()
        i = 0
        while i < len(lines):
            if lines[i].startswith("theorem noEquivariant"):
                chunk = [lines[i]]
                i += 1
                while i < len(lines) and not lines[i].startswith("theorem ") and not lines[i].startswith("end "):
                    chunk.append(lines[i])
                    if ":=" in lines[i]:
                        break
                    i += 1
                # drop proof
                joined = "\n".join(chunk)
                joined = joined.split(":=")[0].strip()
                out.append(joined)
            else:
                i += 1
        return out
    ch = sigs((root / "V14Challenge.lean").read_text())
    so = sigs((root / "V14Solution.lean").read_text())
    assert ch, "no challenge theorems"
    assert ch == so, f"challenge vs solution signatures differ:\n{ch}\n{so}"
    for s in ch:
        assert "V14SchemeModel.k" in s and "V14SchemeModel.G" in s
        assert "[Module k V]" not in s


def main() -> int:
    payload, sha = load_payload()
    test_lcm_clears_at_132(payload)
    print("pass: Piece-family LCMs <= 132 (shipped lcm_denoms)")
    test_scale_commutes_with_reduced_mul(payload)
    print("pass: scale commutes with shipped reduced_mul")
    test_emit_uses_decide_not_norm_num_product(payload, sha)
    print("pass: emit_entry/emit_pa_entry use decide, not old product norm_num")
    test_challenge_solution_signatures_match()
    print("pass: challenge/solution theorem types are identical")
    print("ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
