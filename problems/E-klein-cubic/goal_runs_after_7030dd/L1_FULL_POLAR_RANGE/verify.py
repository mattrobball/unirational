#!/usr/bin/env python3
"""Independent verifier for L1_FULL_POLAR_RANGE.

This file does not import produce.py.  It independently reconstructs the exact
Klein polarization, every full-range coefficient stage, the isolator/terminal
split, and all regression digests in FULL_RANGE.json.
"""

from __future__ import annotations

import hashlib
import json
import sys
from fractions import Fraction
from itertools import permutations
from pathlib import Path
from typing import Any, Iterable

HERE = Path(__file__).resolve().parent
DATA = HERE / "FULL_RANGE.json"


def canonical_json(obj: Any) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_self_hashed(path: Path) -> dict[str, Any]:
    data = json.loads(path.read_text())
    sealed = data["self_sha256"]
    body = {k: v for k, v in data.items() if k != "self_sha256"}
    assert sha256_bytes(canonical_json(body).encode()) == sealed
    return data


def assert_no_timing_fields(obj: Any, path: str = "root") -> None:
    forbidden = {"wall_time", "wall_time_sec", "elapsed", "runtime", "timing"}
    if isinstance(obj, dict):
        for key, value in obj.items():
            assert key.lower() not in forbidden, f"timing field at {path}.{key}"
            assert_no_timing_fields(value, f"{path}.{key}")
    elif isinstance(obj, list):
        for i, value in enumerate(obj):
            assert_no_timing_fields(value, f"{path}[{i}]")


# ---------------------------------------------------------------------------
# Independent exact polarization
# ---------------------------------------------------------------------------

def F(v: Iterable[int | Fraction]) -> Fraction:
    x = [Fraction(a) for a in v]
    return sum(x[i] * x[i] * x[(i + 1) % 5] for i in range(5))


def phi(u: Iterable[int | Fraction], v: Iterable[int | Fraction], w: Iterable[int | Fraction]) -> Fraction:
    a = [Fraction(x) for x in u]
    b = [Fraction(x) for x in v]
    c = [Fraction(x) for x in w]
    total = Fraction(0)
    for i in range(5):
        j = (i + 1) % 5
        total += (a[i] * b[i] * c[j] + a[i] * c[i] * b[j] + b[i] * c[i] * a[j]) / 3
    return total


def phi_ie(u: list[int], v: list[int], w: list[int]) -> Fraction:
    def add(*xs: list[int]) -> list[int]:
        return [sum(x[i] for x in xs) for i in range(5)]

    return (F(add(u, v, w)) - F(add(u, v)) - F(add(u, w)) - F(add(v, w)) + F(u) + F(v) + F(w)) / 6


def verify_polarization() -> None:
    for a in range(5):
        for b in range(5):
            for c in range(5):
                ea = [int(i == a) for i in range(5)]
                eb = [int(i == b) for i in range(5)]
                ec = [int(i == c) for i in range(5)]
                assert phi(ea, eb, ec) == phi_ie(ea, eb, ec)
    for x in ([1, 0, 0, 0, 0], [1, 2, 3, 4, 5], [2, -1, 0, 3, -4]):
        assert phi(x, x, x) == F(x)


# ---------------------------------------------------------------------------
# Independent full-range ledger
# ---------------------------------------------------------------------------

def target(offset: int) -> str:
    return "E_minus" if offset % 2 == 0 else "E_plus"


def label(m: int, offset: int) -> str:
    return f"{'a' if offset % 2 == 0 else 'b'}_{{{m + offset}}}"


def multiplicity(t: tuple[int, int, int]) -> int:
    return len(set(permutations(t)))


def triples(delta: int, q: int) -> list[tuple[int, int, int]]:
    out = []
    for a in range(min(q, delta) + 1):
        for b in range(a, min(q, delta - a) + 1):
            c = delta - a - b
            if b <= c <= q:
                out.append((a, b, c))
    return out


def term(m: int, t: tuple[int, int, int]) -> dict[str, Any]:
    mult = multiplicity(t)
    types = [target(x) for x in t]
    labs = [label(m, x) for x in t]
    nminus = types.count("E_minus")
    rec: dict[str, Any] = {
        "offsets": list(t),
        "orders": [m + x for x in t],
        "targets": types,
        "ordered_multiplicity": mult,
        "labels": labs,
    }
    if nminus in (1, 3):
        rec.update({"live": False, "kind": "VANISHES_BY_INVOLUTION_PARITY", "formula": "0"})
    elif nminus == 2:
        pp = types.index("E_plus")
        mm = [i for i, z in enumerate(types) if z == "E_minus"]
        assert mult % 3 == 0
        coeff = mult // 3
        rec.update(
            {
                "live": True,
                "kind": "B",
                "coefficient": coeff,
                "formula": f"{coeff}*B({labs[pp]}; {labs[mm[0]]}, {labs[mm[1]]})",
                "raw_phi_formula": f"{mult}*Phi({labs[0]}, {labs[1]}, {labs[2]})",
            }
        )
    elif t[0] == t[1] == t[2]:
        rec.update(
            {
                "live": True,
                "kind": "F_plus",
                "coefficient": 1,
                "formula": f"F_+({labs[0]})",
                "raw_phi_formula": f"Phi({labs[0]}, {labs[0]}, {labs[0]})",
            }
        )
    else:
        rec.update(
            {
                "live": True,
                "kind": "Phi_plus",
                "coefficient": mult,
                "formula": f"{mult}*Phi({labs[0]}, {labs[1]}, {labs[2]})",
                "raw_phi_formula": f"{mult}*Phi({labs[0]}, {labs[1]}, {labs[2]})",
            }
        )
    return rec


def live_terms(m: int, d: int, delta: int) -> list[dict[str, Any]]:
    q = d - m
    return [r for r in (term(m, t) for t in triples(delta, q)) if r["live"]]


def stage(m: int, d: int, delta: int, include_terms: bool) -> dict[str, Any]:
    q = d - m
    N = 3 * m + delta
    terms = live_terms(m, d, delta)
    terms_hash = sha256_bytes(canonical_json(terms).encode())
    if delta % 2 == 0:
        assert not terms
        rec: dict[str, Any] = {
            "delta": delta,
            "F_order": N,
            "mode": "AUTOMATIC_ODD_ORDER",
            "equation": "0=0",
            "term_count": 0,
            "terms_sha256": terms_hash,
        }
        if include_terms:
            rec["terms"] = []
        return rec

    if delta <= q:
        newest = (0, 0, delta)
        iso = [x for x in terms if tuple(x["offsets"]) == newest]
        assert len(iso) == 1 and iso[0]["kind"] == "B" and iso[0]["coefficient"] == 1
        residual = [x for x in terms if tuple(x["offsets"]) != newest]
        rec = {
            "delta": delta,
            "F_order": N,
            "mode": "ISOLATE_NEW_EPLUS_CORRECTION",
            "new_correction_offset": delta,
            "new_correction_order": m + delta,
            "new_correction": label(m, delta),
            "operator": f"L_{delta}(u)=B(u; a_{{{m}}}, a_{{{m}}})",
            "equation": f"L_{delta}({label(m, delta)})=-R_{delta}",
            "obstruction": f"omega_{delta}=[R_{delta}] in coker(L_{delta})",
            "isolator": iso[0],
            "residual_term_count": len(residual),
            "term_count": len(terms),
            "terms_sha256": terms_hash,
            "residual_terms_sha256": sha256_bytes(canonical_json(residual).encode()),
        }
        if include_terms:
            rec["terms"] = terms
            rec["residual_terms"] = residual
        return rec

    assert terms and all(max(x["offsets"]) <= q for x in terms)
    rec = {
        "delta": delta,
        "F_order": N,
        "mode": "TERMINAL_COMPATIBILITY",
        "equation": f"T_{delta}=0",
        "new_correction": None,
        "term_count": len(terms),
        "terms_sha256": terms_hash,
        "note": (
            "All degree-d coefficients already exist; this coefficient of F(p) "
            "must vanish without introducing a new jet."
        ),
    }
    if include_terms:
        rec["terms"] = terms
    return rec


def verify_ordered_sorted() -> None:
    for q in range(0, 25):
        for delta in range(0, 3 * q + 1):
            ordered = 0
            for a in range(q + 1):
                for b in range(q + 1):
                    c = delta - a - b
                    ordered += int(0 <= c <= q)
            assert ordered == sum(multiplicity(t) for t in triples(delta, q))


def verify_universal_ranges() -> None:
    # Exhaust all q through 40 and several odd m.  The offset theorem is
    # independent of m, but varying m checks absolute-order labels and parity.
    for m in (1, 3, 5, 9):
        for q in range(0, 41):
            d = m + q
            iso = []
            terminal = []
            for delta in range(0, 3 * q + 1):
                s = stage(m, d, delta, include_terms=False)
                assert 3 * m <= s["F_order"] <= 3 * d
                if delta % 2 == 0:
                    assert s["mode"] == "AUTOMATIC_ODD_ORDER"
                elif delta <= q:
                    assert s["mode"] == "ISOLATE_NEW_EPLUS_CORRECTION"
                    assert s["new_correction_order"] <= d
                    iso.append(delta)
                    # No residual term may contain the newest correction.
                    full = stage(m, d, delta, include_terms=True)
                    for r in full["residual_terms"]:
                        assert max(r["offsets"]) < delta
                else:
                    assert s["mode"] == "TERMINAL_COMPATIBILITY"
                    terminal.append(delta)
                    assert s["new_correction"] is None
            assert iso == list(range(1, q + 1, 2))
            assert terminal == [x for x in range(q + 1, 3 * q + 1) if x % 2 == 1]


def verify_first_equations() -> None:
    s1 = stage(1, 7, 1, include_terms=True)
    assert [x["formula"] for x in s1["terms"]] == ["1*B(b_{2}; a_{1}, a_{1})"]
    s3 = stage(1, 7, 3, include_terms=True)
    assert [x["formula"] for x in s3["terms"]] == [
        "1*B(b_{4}; a_{1}, a_{1})",
        "2*B(b_{2}; a_{1}, a_{3})",
        "F_+(b_{2})",
    ]


def verify_regression_case(saved: dict[str, Any]) -> None:
    m, d, q = saved["m"], saved["d"], saved["q"]
    assert q == d - m
    summaries = [stage(m, d, delta, include_terms=False) for delta in range(3 * q + 1)]
    assert sha256_bytes(canonical_json(summaries).encode()) == saved["stage_summaries_sha256"]
    assert sha256_bytes(canonical_json([s["term_count"] for s in summaries]).encode()) == saved["stage_term_counts_sha256"]
    assert saved["mode_counts"] == {
        "automatic": len(saved["automatic_deltas"]),
        "isolation": len(saved["isolation_deltas"]),
        "terminal": len(saved["terminal_deltas"]),
    }
    assert saved["number_of_coefficients_in_range"] == 3 * q + 1
    assert saved["normal_F_order_range"] == [3 * m, 3 * d]



def verify_packet_files() -> None:
    manifest = load_self_hashed(HERE / "INPUT_MANIFEST.json")
    assert manifest["packet"] == "L1_FULL_POLAR_RANGE"
    assert manifest["cas"]["external_CAS_required"] is False
    assert manifest["preservation_policy"]["historical_sealed_files_modified"] is False

    status = (HERE / "STATUS.md").read_text().splitlines()
    assert status and status[0] == "L1-FULL-RANGE-PASS"
    theorem = (HERE / "THEOREM.md").read_text()
    assert "## 5. Terminal compatibility tail" in theorem
    assert "No external CAS is required or used" in theorem
    replay = (HERE / "REPLAY.md").read_text()
    assert "python3 produce.py" in replay and "python3 verify.py" in replay

    seal_path = HERE / "SEAL.json"
    assert seal_path.exists()
    seal = load_self_hashed(seal_path)
    assert seal["exit"] == "L1-FULL-RANGE-PASS"
    assert seal["headline"] == "OPEN"
    assert seal["cas"]["external_CAS_required"] is False
    for name, expected in seal["files_sha256"].items():
        assert sha256_file(HERE / name) == expected, name


def main() -> int:
    data = load_self_hashed(DATA)
    assert_no_timing_fields(data)
    assert data["packet"] == "L1_FULL_POLAR_RANGE"
    assert data["exit"] == "L1-FULL-RANGE-PASS"
    assert data["headline"] == "OPEN"
    assert data["cas"]["external_CAS_required"] is False
    assert data["theorem_boundary"]["not_proved"]

    verify_polarization()
    print("PASS exact Klein polarization over Q")

    verify_ordered_sorted()
    print("PASS ordered/sorted coefficient identity")

    verify_first_equations()
    print("PASS 3m+1 and 3m+3 equations")

    verify_universal_ranges()
    print("PASS all-range isolator/terminal theorem for exhaustive q<=40 regression")

    for saved in data["regression_cases"]:
        verify_regression_case(saved)
    print("PASS sealed full-range regression ledgers")

    ft = data["full_range_theorem"]
    assert "terminal" in ft["terminal_tail"].lower()
    assert "iff" in ft["completeness"]
    assert data["incidence_compatibility"]["status"] == "PRESERVED"
    assert any("not a global covariant" in x for x in data["incidence_compatibility"]["claims"])

    verify_packet_files()
    print("PASS manifest, theorem boundary, status, replay, and seal hashes")

    print("L1_FULL_RANGE_VERIFY_OK")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except AssertionError as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        raise
