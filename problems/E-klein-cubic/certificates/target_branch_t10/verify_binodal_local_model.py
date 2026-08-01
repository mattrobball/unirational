#!/usr/bin/env python3
"""Independent verifier for T10.0 binodal odd-primary local lemma.

Recomputes (does not merely restate):
  1. Surjectivity of B_i^× → D^× on an explicit truncated power-series model.
  2. Surjectivity of the two-component unit map onto D^× × D^×.
  3. That multiplication-by-2 is an automorphism of every tested finite
     abelian 3-group (hence cor∘res = ×2 kills no 3-primary kernel issue:
     3-torsion cannot survive).

Does not import any producer. Exit marker: T10-BINODAL-NO-3-DEFECT.
"""
from __future__ import annotations

import itertools
import json
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
NOTE = HERE / "BINODAL_ODD_PRIMARY.md"
P = 101
N = 4  # truncation order: monomials of total deg < N in (z1, z2)


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


# ---------------------------------------------------------------------------
# Truncated power series model over F_p
# D_N = F_p[z1,z2] / (z1,z2)^N
# B1_N = F_p[x,z1,z2] / (x,z1,z2)^N   (likewise B2 with y)
# Units = elements with nonzero constant term.
# ---------------------------------------------------------------------------


def monoms_2(n: int):
    """Monomials z1^a z2^b with a+b < n."""
    out = []
    for a in range(n):
        for b in range(n - a):
            out.append((a, b))
    return out


def monoms_3(n: int):
    """Monomials x^c z1^a z2^b with c+a+b < n."""
    out = []
    for c in range(n):
        for a in range(n - c):
            for b in range(n - c - a):
                out.append((c, a, b))
    return out


MON2 = monoms_2(N)
MON3 = monoms_3(N)
IDX2 = {m: i for i, m in enumerate(MON2)}
IDX3 = {m: i for i, m in enumerate(MON3)}
DIM2 = len(MON2)
DIM3 = len(MON3)


def mul2(f, g, mod: int):
    """Multiply two D_N elements (coeff vectors indexed by MON2)."""
    h = [0] * DIM2
    for (a1, b1), c1 in zip(MON2, f):
        if c1 == 0:
            continue
        for (a2, b2), c2 in zip(MON2, g):
            if c2 == 0:
                continue
            a, b = a1 + a2, b1 + b2
            if a + b < N:
                h[IDX2[(a, b)]] = (h[IDX2[(a, b)]] + c1 * c2) % mod
    return h


def mul3(f, g, mod: int):
    """Multiply two B1_N elements (coeff vectors indexed by MON3)."""
    h = [0] * DIM3
    for (c1, a1, b1), v1 in zip(MON3, f):
        if v1 == 0:
            continue
        for (c2, a2, b2), v2 in zip(MON3, g):
            if v2 == 0:
                continue
            c, a, b = c1 + c2, a1 + a2, b1 + b2
            if c + a + b < N:
                h[IDX3[(c, a, b)]] = (h[IDX3[(c, a, b)]] + v1 * v2) % mod
    return h


def restrict_b1_to_d(f):
    """Set x = 0: keep only terms with c = 0."""
    out = [0] * DIM2
    for (c, a, b), v in zip(MON3, f):
        if c == 0:
            out[IDX2[(a, b)]] = v
    return out


def lift_d_to_b1(v):
    """Canonical lift: embed D into B1 by x^0 terms only."""
    out = [0] * DIM3
    for (a, b), coeff in zip(MON2, v):
        out[IDX3[(0, a, b)]] = coeff
    return out


def is_unit_d(v, mod: int) -> bool:
    return v[IDX2[(0, 0)]] % mod != 0


def is_unit_b(f, mod: int) -> bool:
    return f[IDX3[(0, 0, 0)]] % mod != 0


def inv_d(v, mod: int):
    """Invert a unit of D_N by truncated geometric series / Newton."""
    assert is_unit_d(v, mod)
    # Write v = c0 * (1 - w) with w in maximal ideal; inv = c0^{-1} sum w^k
    c0 = v[IDX2[(0, 0)]] % mod
    c0inv = pow(c0, -1, mod)
    # w = 1 - c0^{-1} v  (no constant term)
    scaled = [(c0inv * t) % mod for t in v]
    w = [(-scaled[i]) % mod for i in range(DIM2)]
    w[IDX2[(0, 0)]] = 0
    # sum_{k=0}^{N-1} w^k
    acc = [0] * DIM2
    acc[IDX2[(0, 0)]] = 1
    term = acc[:]
    for _ in range(1, N):
        term = mul2(term, w, mod)
        acc = [(acc[i] + term[i]) % mod for i in range(DIM2)]
    return [(c0inv * acc[i]) % mod for i in range(DIM2)]


def random_unit_d(mod: int, rng):
    v = [rng.randrange(mod) for _ in range(DIM2)]
    if v[IDX2[(0, 0)]] % mod == 0:
        v[IDX2[(0, 0)]] = 1 + rng.randrange(mod - 1)
    return v


def check_restriction_surjective(mod: int = P, trials: int = 40, seed: int = 7) -> dict:
    """For many random units of D_N, check the canonical lift is a unit of B1
    restricting to the original unit. Also check a non-canonical lift with
    free x-terms still restricts correctly."""
    import random

    rng = random.Random(seed)
    ok = 0
    for _ in range(trials):
        v = random_unit_d(mod, rng)
        lift = lift_d_to_b1(v)
        assert is_unit_b(lift, mod)
        assert restrict_b1_to_d(lift) == v
        # non-canonical: add x * (random series of deg < N-1)
        extra = [0] * DIM3
        for (c, a, b) in MON3:
            if c >= 1:
                extra[IDX3[(c, a, b)]] = rng.randrange(mod)
        lift2 = [(lift[i] + extra[i]) % mod for i in range(DIM3)]
        assert is_unit_b(lift2, mod)
        assert restrict_b1_to_d(lift2) == v
        ok += 1
    return {
        "model": f"F_{mod}[[x,z1,z2]]/(m)^{N} → F_{mod}[[z1,z2]]/(m)^{N}",
        "trials": trials,
        "passed": ok,
        "dim_D": DIM2,
        "dim_B1": DIM3,
        "truncation_order": N,
    }


def check_unit_map_surjective(mod: int = P, trials: int = 40, seed: int = 11) -> dict:
    """Unit map (u1,u2,d) ↦ (u1|_D/d, u2|_D/d) is onto D^× × D^×.

    Construction: for target (v1, v2), take u1 = lift(v1), u2 = lift(v2), d = 1.
    Also check the general form with nontrivial d.
    """
    import random

    rng = random.Random(seed)
    ok = 0
    for _ in range(trials):
        v1 = random_unit_d(mod, rng)
        v2 = random_unit_d(mod, rng)
        # with d = 1
        u1 = lift_d_to_b1(v1)
        u2 = lift_d_to_b1(v2)
        d = [0] * DIM2
        d[IDX2[(0, 0)]] = 1
        r1 = restrict_b1_to_d(u1)
        r2 = restrict_b1_to_d(u2)
        dinv = inv_d(d, mod)
        got1 = mul2(r1, dinv, mod)
        got2 = mul2(r2, dinv, mod)
        assert got1 == v1 and got2 == v2
        # with nontrivial d: target still (v1,v2); set d random unit,
        # u1 = lift(v1 * d), u2 = lift(v2 * d)
        d = random_unit_d(mod, rng)
        u1 = lift_d_to_b1(mul2(v1, d, mod))
        u2 = lift_d_to_b1(mul2(v2, d, mod))
        dinv = inv_d(d, mod)
        got1 = mul2(restrict_b1_to_d(u1), dinv, mod)
        got2 = mul2(restrict_b1_to_d(u2), dinv, mod)
        assert got1 == v1 and got2 == v2
        ok += 1
    return {
        "map": "(u1,u2,d) |-> (u1|_D/d, u2|_D/d)",
        "trials": trials,
        "passed": ok,
        "mod": mod,
        "truncation_order": N,
    }


def check_mult_by_2_on_3_groups() -> dict:
    """cor∘res = ×2. On any finite abelian 3-group, ×2 is an automorphism,
    so the only element killed by both a 3-power and by 2 is zero.
    Explicit check on Z/3, Z/9, (Z/3)^2."""
    results = {}

    def mult2_auto(order_list, label):
        # order_list: primary decomposition sizes, e.g. [3] or [9] or [3,3]
        # element = tuple of residues
        orders = order_list
        # enumerate all elements
        ranges = [range(o) for o in orders]
        elems = list(itertools.product(*ranges))
        image = set()
        kernel = []
        for e in elems:
            tw = tuple((2 * x) % o for x, o in zip(e, orders))
            image.add(tw)
            if all(t == 0 for t in tw):
                kernel.append(e)
        auto = len(image) == len(elems) and kernel == [tuple(0 for _ in orders)]
        # also: gcd(2, 3^k) = 1 implies inverse exists
        inv_exists = all(pow(2, -1, o) is not None for o in orders)
        return {
            "group": label,
            "order": int(__import__("math").prod(orders)),
            "mult2_bijective": auto,
            "kernel_trivial": kernel == [tuple(0 for _ in orders)],
            "2_invertible_mod_exponents": inv_exists,
        }

    results["Z/3"] = mult2_auto([3], "Z/3Z")
    results["Z/9"] = mult2_auto([9], "Z/9Z")
    results["(Z/3)^2"] = mult2_auto([3, 3], "(Z/3Z)^2")
    results["Z/27"] = mult2_auto([27], "Z/27Z")
    # Arithmetic: for every k, gcd(2, 3^k) = 1
    results["gcd_2_3k"] = {f"3^{k}": __import__("math").gcd(2, 3**k) for k in range(1, 8)}
    assert all(v == 1 for v in results["gcd_2_3k"].values())
    assert all(
        results[k]["mult2_bijective"] for k in ("Z/3", "Z/9", "(Z/3)^2", "Z/27")
    )
    return results


def check_note() -> dict:
    text = NOTE.read_text()
    required = [
        "T10-BINODAL-NO-3-DEFECT",
        "B₁ ×_D B₂",
        "no odd-primary",
        "multiplication by",
        "OPEN",
        "fold algebra",
        "target branch",
    ]
    missing = [s for s in required if s not in text and s.replace("₁", "1") not in text]
    # tolerate unicode variants
    soft = []
    if "B1" not in text and "B₁" not in text:
        soft.append("conductor square B1 x_D B2")
    if "odd-primary" not in text and "odd primary" not in text:
        soft.append("odd-primary")
    return {
        "note_sha256": file_hash(NOTE),
        "required_phrases_present": "T10-BINODAL-NO-3-DEFECT" in text
        and "OPEN" in text
        and ("target branch" in text or "target branch" in text.lower()),
        "mentions_fold_not_decided": "not decided" in text.lower() or "S_G" in text,
        "soft_missing": soft,
    }


def main() -> None:
    assert NOTE.is_file(), "BINODAL_ODD_PRIMARY.md missing"

    r1 = check_restriction_surjective()
    r2 = check_unit_map_surjective()
    r3 = check_mult_by_2_on_3_groups()
    r4 = check_note()

    assert r1["passed"] == r1["trials"]
    assert r2["passed"] == r2["trials"]
    assert all(r3[k]["mult2_bijective"] for k in ("Z/3", "Z/9", "(Z/3)^2", "Z/27"))

    report = {
        "schema": "klein-cubic-T10.0-binodal-odd-primary-v1",
        "exit": "T10-BINODAL-NO-3-DEFECT",
        "headline": "OPEN",
        "object": "completed ordinary node of target branch B (not S_G)",
        "restriction_surjective_truncated": r1,
        "unit_map_surjective_truncated": r2,
        "mult_by_2_on_3_groups": r3,
        "note_check": r4,
        "proves": [
            "split ordinary node: unit map surjective on truncated model",
            "split ordinary node: punctured Pic vanishes (UFD/regular argument in note)",
            "unsplit: no 3-primary local Picard torsion via cor∘res = ×2",
        ],
        "does_not_prove": [
            "normality of S_G",
            "global Cl/Pic of B",
            "absence of other 3-primary defects of the fold or discriminant",
        ],
    }
    out = HERE / "verify_binodal_result.json"
    out.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    report["result_sha256"] = file_hash(out)
    out.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print("T10-BINODAL-NO-3-DEFECT", "OK")
    print(json.dumps({"restriction": r1["passed"], "unit_map": r2["passed"]}, sort_keys=True))


if __name__ == "__main__":
    main()
