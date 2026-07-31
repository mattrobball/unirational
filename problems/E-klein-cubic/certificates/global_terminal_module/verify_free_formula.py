#!/usr/bin/env python3
"""Independent verifier for G4.1 free-fibre terminal formula.

Does NOT import produce_free_formula.py. Re-derives the recurrence and residual
from common_g4.py and cross-checks sealed JSON + optional common_g3 towers.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
sys.path.insert(0, str(HERE.parent / "global_finite_lifting"))

from common_g4 import (  # noqa: E402
    compute_universal_jets,
    parse_q,
    residual_from_universal,
    sha256_bytes,
    sha256_file,
)
from common_g3 import free_fibre_tower, sample_leading_pure  # noqa: E402


def load(path: Path) -> dict:
    return json.loads(path.read_text())


def check_self_hash(path: Path, obj: dict) -> None:
    stored = obj.get("self_sha256")
    obj2 = dict(obj)
    obj2["self_sha256"] = None
    text = json.dumps(obj2, indent=2, sort_keys=True) + "\n"
    h = sha256_bytes(text.encode())
    if stored != h:
        raise AssertionError(f"self_sha256 mismatch on {path.name}: {stored} vs {h}")


def main() -> int:
    formula_path = HERE / "free_terminal_formula.json"
    rec_path = HERE / "recurrence_certificate.json"
    formula = load(formula_path)
    rec = load(rec_path)
    check_self_hash(formula_path, formula)
    check_self_hash(rec_path, rec)

    r_max = formula["universal_jets"]["r_max"]
    jets = compute_universal_jets(r_max)

    # 1. Sealed alphas/betas match recomputation
    for r, a in jets["alphas"].items():
        assert formula["universal_jets"]["alphas"][r] == a, r
        assert rec["alphas"][r] == a, r
    for r, b in jets["betas"].items():
        assert formula["universal_jets"]["betas"][r] == b, r
        assert rec["betas"][r] == b, r
    print("OK recurrence table matches recomputation")

    # 2. All alpha nonzero + growth through r_max
    alph = {int(r): v for r, v in jets["alphas"].items()}
    assert all(v != 0 for v in alph.values())
    rs = sorted(alph)
    for i in range(1, len(rs)):
        r, prev = rs[i], rs[i - 1]
        if r >= 5:
            assert abs(alph[r]) >= 2 * abs(alph[prev]), (r, alph[r], alph[prev])
    print("OK alpha nonzero and growth |a_r|>=2|a_{r-2}| for r>=5")

    # 3. Structural identity + regression samples
    for m, d, nsq, N in [
        (1, 7, "1296", 10),
        (1, 13, "156816", 16),
        (3, 19, "15968016", 26),
    ]:
        res = residual_from_universal(m, d, jets)
        assert res["N_star"] == N
        assert res["residual_norm_sq"] == nsq
        assert res["structural_identity"]["verified_on_this_bidegree"]
        assert not res["is_zero"]
        # common_g3 independent tower
        a, lab = sample_leading_pure(m)
        t = free_fibre_tower(m, d, a, mode="ker_L1", a_label=lab)
        assert t["first_nonzero_terminal_F_order"] == N
        tr = t["terminal_residuals"][str(N)]
        assert tr["residual_norm_sq"] == nsq
        if tr.get("residual_coeffs"):
            from common_g4 import monoms_bin

            coeffs = [parse_q(x) for x in tr["residual_coeffs"]]
            mon = monoms_bin(N)
            g3_nz = {
                (mon[i][0], mon[i][1]): coeffs[i]
                for i in range(len(coeffs))
                if coeffs[i] != 0
            }
            form_nz = {
                (t0["monom"][0], t0["monom"][1]): parse_q(t0["coeff"])
                for t0 in res["residual_nz"]
            }
            assert g3_nz == form_nz, (m, d, g3_nz, form_nz)
        print(f"OK regression (m,d)=({m},{d})")

    # 4. Sparse extra grid points
    for m, d in [(1, 9), (1, 11), (3, 9), (5, 11), (7, 15)]:
        res = residual_from_universal(m, d, jets)
        assert res["structural_identity"]["verified_on_this_bidegree"]
        assert not res["is_zero"]
        a, lab = sample_leading_pure(m)
        t = free_fibre_tower(m, d, a, mode="ker_L1", a_label=lab)
        assert t["first_nonzero_terminal_F_order"] == res["N_star"]
        assert (
            t["terminal_residuals"][str(res["N_star"])]["residual_norm_sq"]
            == res["residual_norm_sq"]
        )
        print(f"OK sparse (m,d)=({m},{d})")

    # 5. Sealed regression flags
    reg = formula["regression_7_13_19"]["matches_TERMINAL_PATTERN"]
    assert all(reg.values()), reg

    # 6. Input hashes present
    assert "input_hashes" in formula
    for p, h in formula["input_hashes"].items():
        assert len(h) == 64, (p, h)

    print("G41_FREE_FORMULA_VERIFY_OK")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as e:
        print("VERIFY_FAIL", type(e).__name__, e, file=sys.stderr)
        raise
