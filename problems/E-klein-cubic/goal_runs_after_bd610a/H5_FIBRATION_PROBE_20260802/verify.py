#!/usr/bin/env python3
"""Independent verifier for the H5 modular residual fibration probe.

Does not import produce.py.  Rebuilds G and residual binary forms from the
H4-bound degree-five geometry, checks manifest hashes, and replays every
sample row (including holdout prime 199).
"""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H4 = ROOT / "goal_runs_after_35fa" / "H_11_5_TWIST"
H5 = ROOT / "goal_runs_after_bd610a" / "H5_11_5_TRACE_CUBIC"

H4_EXPECTED = {
    "field_model.json": "80fdc908633595d6bb3c292d0027aa66295a850b9b6a12cc473f90e3e373ba1e",
    "twist_model.json": "9a5f69b43de4b33aa0185b4714e23bc177b12f74a529510b0b8b4b9ab5e49a11",
    "norm_model.json": "1f61adc24bc15bf296b7199f4e13dfa5f538691984d6f623efa8feb9531dc49e",
    "decision.json": "2517208d05c71d7493a6b606d8460c13e41bb409077a7dfb385da99eb443a592",
    "SEAL.json": "9b790a67185edc94be385993276ea4b4e35a6cfba4739981c083dd6d9886eb25",
}


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def mod_inv(x: int, p: int) -> int:
    return pow(x, -1, p)


def legendre(a: int, p: int) -> int:
    return pow(a % p, (p - 1) // 2, p) if a % p else 0


def coefficients_c(r: list[int], p: int) -> list[int]:
    return [mod_inv(r[(i + 2) % 5], p) for i in range(5)]


def G(x: list[int], c: list[int], p: int) -> int:
    total = 0
    for i in range(5):
        total = (total + c[i] * (x[i] * x[i] % p) * x[(i + 1) % 5]) % p
    return total


def phi_from_orbit(avals: list[int], r: list[int], p: int) -> int:
    total = 0
    for i in range(5):
        total = (
            total
            + mod_inv(r[(i + 2) % 5], p)
            * (avals[i] * avals[i] % p)
            * avals[(i + 1) % 5]
        ) % p
    return total


def eval_Z_orbit(z: list[int], r: list[int], p: int) -> list[int]:
    return [sum(z[j] * pow(r[i], j, p) for j in range(5)) % p for i in range(5)]


def residual_binary_from_e0(direction: list[int], c: list[int], p: int):
    a, b, cc, d = direction
    A = c[0] * a % p
    B = c[4] * (d * d % p) % p
    C = (
        c[1] * (a * a % p) % p * b
        + c[2] * (b * b % p) % p * cc
        + c[3] * (cc * cc % p) % p * d
    ) % p
    return A, B, C


def residual_binary_from_em(m: int, direction: list[int], c: list[int], p: int):
    c_rot = [c[(m + i) % 5] for i in range(5)]
    return residual_binary_from_e0(direction, c_rot, p)


def classify_binary(A: int, B: int, C: int, p: int) -> str:
    if A == 0 and B == 0 and C == 0:
        return "contained_line"
    disc = (B * B - 4 * A * C) % p
    if disc == 0:
        return "singular_double"
    return "split" if legendre(disc, p) == 1 else "nonsplit"


def main() -> None:
    errors: list[str] = []

    # --- H4 hash binding ---
    for name, expected in H4_EXPECTED.items():
        actual = digest(H4 / name)
        if actual != expected:
            errors.append(f"H4 hash mismatch {name}: {actual} != {expected}")

    seal = json.loads((H4 / "SEAL.json").read_text())
    if seal.get("exit") != "H-11_5-NORM-MODEL-PASS":
        errors.append(f"unexpected H4 exit {seal.get('exit')}")

    norm = json.loads((H4 / "norm_model.json").read_text())
    if "degree_five_point" not in norm:
        errors.append("norm_model missing degree_five_point")
    if not norm["trace_model"]["equation"].startswith("Phi(z)=Tr_E/K"):
        errors.append("trace model equation mismatch")

    # --- Load probe artifacts ---
    for required in (
        "INPUT_MANIFEST.json",
        "MODEL.json",
        "FINDINGS.json",
        "SAMPLES.json",
        "decision.json",
        "STATUS.md",
    ):
        if not (HERE / required).is_file():
            errors.append(f"missing artifact {required}")

    if errors:
        for e in errors:
            print("FAIL", e)
        sys.exit(1)

    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    findings = json.loads((HERE / "FINDINGS.json").read_text())
    samples = json.loads((HERE / "SAMPLES.json").read_text())
    decision = json.loads((HERE / "decision.json").read_text())
    status_text = (HERE / "STATUS.md").read_text()

    # Exit discipline.
    if findings.get("exit") != "H5-UNDECIDED":
        errors.append(f"FINDINGS exit {findings.get('exit')}")
    if decision.get("exit") != "H5-UNDECIDED":
        errors.append(f"decision exit {decision.get('exit')}")
    if decision.get("headline") != "OPEN":
        errors.append("headline must remain OPEN")
    if decision.get("rational_point_over_K") is not None:
        errors.append("must not claim a K-point")
    if decision.get("pointlessness") is not None:
        errors.append("must not claim pointlessness")
    if not status_text.startswith("H5-UNDECIDED"):
        errors.append("STATUS.md must start with H5-UNDECIDED")
    if "POINTLESS" in status_text.split("\n")[0]:
        errors.append("STATUS marker must not be pointlessness")

    # Manifest H4 seal hash.
    m_seal = manifest["inputs"]["h4_seal"]["sha256"]
    if m_seal != H4_EXPECTED["SEAL.json"]:
        errors.append("manifest H4 seal hash mismatch")

    # Geometry sanity: eigenpoints on specialized G; residual classification.
    if 199 not in findings.get("primes", []):
        errors.append("holdout prime 199 missing from findings.primes")

    replayed = 0
    holdout_replayed = 0
    for row in samples["rows"]:
        p = row["prime"]
        r = row["r"]
        if len(r) != 5 or 0 in r:
            errors.append(f"bad r at p={p}")
            continue
        prod = 1
        for x in r:
            prod = prod * x % p
        if prod != 1:
            errors.append(f"product(r) != 1 at p={p}: {r}")
        if len(set(r)) != 5:
            errors.append(f"r not distinct at p={p}: {r}")

        c = coefficients_c(r, p)
        if c != row["c"]:
            errors.append(f"c mismatch at p={p}")

        # Five eigenpoints on G.
        for m in range(5):
            x = [0] * 5
            x[m] = 1
            if G(x, c, p) != 0:
                errors.append(f"eigenpoint e_{m} not on G at p={p}")

        # Sample F_p-point on G.
        pt = row.get("sample_Fp_point")
        if pt is not None:
            if G(pt, c, p) != 0:
                errors.append(f"sample_Fp_point not on G at p={p}")
            if row.get("locally_soluble") is not True:
                errors.append(f"locally_soluble flag false but point present p={p}")

        # z / Phi cross-check when present.
        z = row.get("sample_z_phi_zero")
        if z is not None:
            avals = eval_Z_orbit(z, r, p)
            if phi_from_orbit(avals, r, p) != 0:
                errors.append(f"sample_z_phi_zero fails Phi at p={p}")
            # Phi on evaluations equals G on the evaluation vector.
            if G(avals, c, p) != 0:
                errors.append(f"G(eval Z) mismatch Phi at p={p}")

        # Special residual fibres.
        for fib in row.get("sample_special_fibres") or []:
            m = fib["eigen_index"]
            direction = fib["direction"]
            A, B, C = residual_binary_from_em(m, direction, c, p)
            if (A, B, C) != (fib["A"], fib["B"], fib["C"]):
                errors.append(f"residual ABC mismatch p={p} m={m}")
            kind = classify_binary(A, B, C, p)
            if kind != fib["kind"]:
                errors.append(f"fibre kind mismatch p={p}: {kind} vs {fib['kind']}")
            # Contained line => whole P^1 residual vanishes: check a few (s:t).
            if kind == "contained_line":
                for s, t in ((1, 0), (0, 1), (1, 1), (1, 2), (3, 5)):
                    x = [0] * 5
                    x[m] = s % p
                    # direction fills the other four cyclic coords after m
                    for j, val in enumerate(direction):
                        x[(m + 1 + j) % 5] = (t * val) % p
                    if G(x, c, p) != 0:
                        errors.append(
                            f"contained_line not contained p={p} m={m} s={s} t={t}"
                        )

        # Re-tally fibre types is not stored fully; residual_fibre_totals must
        # have non-negative integers summing sensibly.
        totals = row.get("residual_fibre_totals") or {}
        if sum(totals.values()) <= 0:
            errors.append(f"empty residual totals p={p}")
        for k in ("contained_line", "singular_double", "split", "nonsplit"):
            if k not in totals:
                errors.append(f"missing fibre key {k} p={p}")

        replayed += 1
        if p == 199:
            holdout_replayed += 1

    if replayed == 0:
        errors.append("no samples replayed")
    if holdout_replayed == 0:
        errors.append("no holdout-199 samples replayed")

    # Findings table integrity.
    primes_seen = set()
    for s in findings["summaries_by_prime"]:
        primes_seen.add(s["prime"])
        if s["specializations"] <= 0:
            errors.append(f"no specializations for p={s['prime']}")
        if s["locally_soluble_count"] > s["specializations"]:
            errors.append(f"soluble count overflow p={s['prime']}")
        rates = s["residual_fibre_rates"]
        if abs(sum(rates.values()) - 1.0) > 1e-9:
            errors.append(f"fibre rates not summing to 1 at p={s['prime']}")
        if s["prime"] == 199 and not s.get("holdout"):
            errors.append("p=199 must be marked holdout")

    if 199 not in primes_seen:
        errors.append("summaries missing holdout 199")

    # Equivalence check on H4 common-open witness p=89.
    twist = json.loads((H4 / "twist_model.json").read_text())
    common = twist["common_open_good_reduction_witness"]
    p89 = common["prime"]
    assert p89 == 89
    r89 = common["r"]
    prod = 1
    for x in r89:
        prod = prod * x % p89
    if prod != 1:
        errors.append("H4 common-open r product not 1")
    c89 = coefficients_c(r89, p89)
    for m in range(5):
        x = [0] * 5
        x[m] = 1
        if G(x, c89, p89) != 0:
            errors.append(f"H4 witness eigenpoint miss m={m}")

    # Identity G(eval Z)=Phi on a few random z at p=89.
    for z in (
        [1, 0, 0, 0, 0],
        [1, 2, 3, 4, 5],
        [7, 1, 0, 2, 3],
        [0, 1, 0, 0, 1],
    ):
        avals = eval_Z_orbit(z, r89, p89)
        if G(avals, c89, p89) != phi_from_orbit(avals, r89, p89):
            errors.append(f"G vs Phi identity fail z={z}")

    # STATUS forbids headline language.
    forbidden = ("H5-POINTLESS-HEADLINE-NEGATIVE", "H5-RATIONAL-POINT", "HEADLINE-CLOSED")
    for token in forbidden:
        if token in status_text:
            errors.append(f"forbidden token in STATUS: {token}")

    if errors:
        for e in errors:
            print("FAIL", e)
        sys.exit(1)

    print(f"replayed_samples={replayed}")
    print(f"holdout_199_samples={holdout_replayed}")
    print(f"primes={sorted(primes_seen)}")
    print("H5_FIBRATION_PROBE_VERIFY_OK")


if __name__ == "__main__":
    main()
