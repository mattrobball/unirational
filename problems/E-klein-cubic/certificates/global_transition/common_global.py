#!/usr/bin/env python3
"""Shared helpers for WP-5 global transition diagram.

Does not import produce.py.  Absolute-path safe.
Exact arithmetic only; no timing fields in sealed payloads.
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
TRANS = CERT / "transitions"
STRATA = CERT / "strata"

sys.path.insert(0, str(TRANS))
sys.path.insert(0, str(CERT))


def sha256_file(path: Path | str) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def canonical_json(obj) -> str:
    """Stable JSON for hashing: sorted keys, 2-space indent, trailing newline."""
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def load_json(path: Path) -> dict:
    return json.loads(Path(path).read_text())


def binom(n: int, k: int) -> int:
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


# ---------------------------------------------------------------------------
# Local module dimensions (from accepted WP-4 closed forms; char 0)
# ---------------------------------------------------------------------------

def dim_plane(m: int, d: int) -> int:
    """Involution plus-plane M_{m,d} (C2-invariants)."""
    if m < 0 or d < m:
        return 0
    base = (m + 1) * binom(d - m + 2, 2)
    return base * (3 if m % 2 == 0 else 2)


def n_triv(m: int) -> int:
    """V4 trivial-character count in Sym^m (B*⊕C*⊕D*)."""
    if m < 0:
        return 0
    if m % 2 == 0:
        k = m // 2
        return binom(k + 2, 2)
    k = (m - 1) // 2
    return binom(k + 1, 2)


def dim_v4_line(m: int, d: int) -> int:
    """V4 fixed-line / arrangement triple-line module."""
    if m < 0 or d < m:
        return 0
    return (n_triv(m) + binom(m + 2, 2)) * (d - m + 1)


def dim_d12_ordinary(d: int) -> int:
    """Ordinary binary D12 covariant dim Hom_{D12}(Sym^d V, V)."""
    if d < 0 or d % 2 == 0:
        return 0
    return (d + 2) // 3


def dim_d12_twisted(e: int) -> int:
    """Det-twisted residual module (same Hilbert series as ordinary)."""
    return dim_d12_ordinary(e)


def residual_e(m: int, d: int) -> int | None:
    """Residual degree e = d - 6m for odd plane order; None if forced zero."""
    if m % 2 == 0:
        return None
    return d - 6 * m


def plane_line_coupling_dim(m: int, d: int) -> dict:
    """Dimension of the forced minus-line residual for odd m."""
    if m % 2 == 0:
        return {"defined": False, "reason": "even plane order excluded by 4A.2"}
    e = d - 6 * m
    if e < 0:
        return {
            "defined": True,
            "e": e,
            "forced_zero_restriction": True,
            "dim": 0,
            "reason": "deg Δ^m = 6m > d",
        }
    if e % 2 == 0:
        return {
            "defined": True,
            "e": e,
            "forced_zero_restriction": True,
            "dim": 0,
            "reason": "even residual: det-twisted module vanishes",
        }
    return {
        "defined": True,
        "e": e,
        "forced_zero_restriction": False,
        "dim": dim_d12_twisted(e),
        "mandatory_factor": "Delta_t^m",
    }


# ---------------------------------------------------------------------------
# Endpoint ledger classification (from WP-4B; discrete)
# ---------------------------------------------------------------------------

def endpoint_ledgers(e: int) -> dict:
    if e < 0:
        return {"defined": False, "all_ledgers": [], "reason": "negative e"}
    if e % 2 == 0:
        return {
            "defined": False,
            "all_ledgers": [],
            "reason": "even residual degree",
            "dim": 0,
        }
    dim = dim_d12_twisted(e)
    if e in (1, 3):
        return {
            "defined": True,
            "e": e,
            "dim": dim,
            "all_ledgers": ["swap_both"],
            "generic_ledger": "swap_both",
        }
    if e == 5:
        return {
            "defined": True,
            "e": e,
            "dim": dim,
            "all_ledgers": [
                "swap_both",
                "plus_fixed_minus_to_plus",
                "plus_to_minus_minus_fixed",
            ],
            "generic_ledger": "swap_both",
            "preserve_both_absent": True,
        }
    return {
        "defined": True,
        "e": e,
        "dim": dim,
        "all_ledgers": [
            "swap_both",
            "plus_fixed_minus_to_plus",
            "plus_to_minus_minus_fixed",
            "preserve_both",
        ],
        "generic_ledger": "swap_both",
    }


# ---------------------------------------------------------------------------
# Accepted input hashes (content only)
# ---------------------------------------------------------------------------

ACCEPTED_INPUTS = [
    "certificates/strata/strata_exact.json",
    "certificates/strata/incidence_exact.json",
    "certificates/strata/normal_characters.json",
    "certificates/strata/marked_s3_geometry.json",
    "certificates/transitions/involution_plane/module.json",
    "certificates/transitions/d12_binary_line/module.json",
    "certificates/transitions/v4_fixed_line/module.json",
    "certificates/transitions/c3_lines/module.json",
    "certificates/transitions/point_links/module.json",
    "certificates/transitions/SEAL.json",
]


def input_hashes() -> dict:
    out = {}
    for rel in ACCEPTED_INPUTS:
        p = ROOT / rel
        out[rel] = sha256_file(p) if p.exists() else None
    return out
