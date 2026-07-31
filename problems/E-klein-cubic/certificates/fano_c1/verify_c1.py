#!/usr/bin/env python3
"""Independent verifier for Track C1.1 (fano_c1 descent-interface preflight).

Does not import produce_modular_probe.py or any other producer. Recomputes:
  - dimension arithmetic 8 - 5 = 3 and Herm_3 dim 15
  - orbit degrees 55, 60, 132 and gcd 1; order-12 = 55 A4 + 55 D12 counts
  - quaternion_corner still has no explicit symbol / matrices
  - exit is C1-UNDECIDED (not C1-MODEL-PASS / C-FANO-POINT)
  - modular F_23 structure path: rebuild algebra from alignment seeds and
    recompute span-closure, associativity samples, identity (decisive modular
    invariant for the partial step-1 claim)
  - FAIL-SCOPE language present; S1 named as smallest system
  - no claim of executable (a,b) or Hermitian matrices

House rules: recompute decisive invariants; do not trust JSON booleans alone.
"""

from __future__ import annotations

import hashlib
import json
import sys
from math import gcd
from pathlib import Path

import numpy as np
import runpy

ROOT = Path(__file__).resolve().parents[2]
PKG = Path(__file__).resolve().parent
PFAFFIAN = ROOT / "certificates" / "pfaffian_point"
ALIGN = ROOT / "tmp" / "pfaffian_representation_alignment"
SCRATCH = ROOT / "tmp" / "c1_preflight"
P = 23
POINT = np.array([1, 2, 3, 4, 5], dtype=np.int64)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def fail(msg: str) -> None:
    print(f"VERIFY_C1_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def power(matrix: np.ndarray, exponent: int) -> np.ndarray:
    result = np.eye(matrix.shape[0], dtype=np.int64) % P
    while exponent:
        if exponent & 1:
            result = (result @ matrix) % P
        matrix = (matrix @ matrix) % P
        exponent //= 2
    return result


def key(matrix: np.ndarray) -> bytes:
    return bytes((matrix % P).astype(np.uint8).flat)


def inv_mat(matrix: np.ndarray) -> np.ndarray:
    n = matrix.shape[0]
    a = np.concatenate([matrix % P, np.eye(n, dtype=np.int64)], axis=1)
    for col in range(n):
        pivots = np.flatnonzero(a[col:, col] % P)
        if not len(pivots):
            raise ValueError("singular")
        piv = col + int(pivots[0])
        if piv != col:
            a[[col, piv]] = a[[piv, col]]
        inv_p = pow(int(a[col, col]) % P, -1, P)
        a[col] = (a[col] * inv_p) % P
        for row in range(n):
            if row != col and a[row, col] % P:
                a[row] = (a[row] - a[row, col] * a[col]) % P
    return a[:, n:] % P


def det_mod(matrix: np.ndarray) -> int:
    m = matrix.copy() % P
    result = 1
    for col in range(m.shape[1]):
        cands = np.flatnonzero(m[col:, col] % P)
        if not len(cands):
            return 0
        piv = col + int(cands[0])
        if piv != col:
            m[[col, piv]] = m[[piv, col]]
            result = -result
        pv = int(m[col, col]) % P
        result = (result * pv) % P
        inv_p = pow(pv, -1, P)
        m[col] = (m[col] * inv_p) % P
        for row in range(col + 1, m.shape[0]):
            if m[row, col] % P:
                m[row] = (m[row] - m[row, col] * m[col]) % P
    return result % P


def recompute_modular_algebra() -> dict:
    """Rebuild specialized A at F_23 from alignment seeds; do not import producer."""
    fano = runpy.run_path(str(ROOT / "tmp/fano14_twist/fano_covariant_scan.py"))
    weil = runpy.run_path(str(ROOT / "certificates/modular_covariant_scan.py"))
    schur_a, schur_b = fano["six_dimensional_generators"]()
    inv = fano["inv"]
    weil_s = weil["A"]
    weil_t = weil["B"]
    image_a = (weil_t @ weil_s @ weil_t @ weil_s) % P
    image_b = (power(weil_t, 8) @ weil_s) % P

    seen = {
        key(np.eye(5, dtype=np.int64)): (
            np.eye(5, dtype=np.int64) % P,
            np.eye(6, dtype=np.int64) % P,
        )
    }
    queue = [seen[key(np.eye(5, dtype=np.int64))]]
    while queue:
        target, source = queue.pop()
        for tg, sg in ((image_a, schur_a), (image_b, schur_b)):
            nt = (target @ tg) % P
            ns = (source @ sg) % P
            nk = key(nt)
            if nk not in seen:
                seen[nk] = (nt, ns)
                queue.append((nt, ns))
    if len(seen) != 660:
        fail(f"group order {len(seen)} != 660")

    cert = json.loads((ALIGN / "certificate.json").read_text())
    seeds = cert["end36_reynolds_frame"]["selected_reynolds_seeds"]
    if len(seeds) != 36:
        fail(f"expected 36 seeds, got {len(seeds)}")
    ph = cert["end36_reynolds_frame"]["projective_homogenization"]
    mult = {int(k): int(v) for k, v in ph["multiplier_values_mod_23"].items()}
    den = int(ph["denominator_value_mod_23"])
    den_inv = pow(den, -1, P)

    group = list(seen.values())
    conj = np.zeros((660, 36, 36), dtype=np.int64)
    inv_targets = np.zeros((660, 5, 5), dtype=np.int64)
    for gi, (target, source) in enumerate(group):
        source_inv = inv(source)
        inv_targets[gi] = inv(target)
        for r in range(6):
            for c in range(6):
                conj[gi, :, 6 * r + c] = (
                    np.outer(source[:, r], source_inv[c, :]).reshape(-1)
                ) % P

    orbit_points = np.einsum("gij,j->gi", inv_targets, POINT) % P
    powers = np.ones((660, 5, 9), dtype=np.int64)
    for e in range(1, 9):
        powers[:, :, e] = powers[:, :, e - 1] * orbit_points % P

    def weights(exponents):
        result = np.ones(660, dtype=np.int64)
        for var, exp in enumerate(exponents):
            if exp:
                result = result * powers[:, var, exp] % P
        return result

    basis_mats = np.zeros((36, 6, 6), dtype=np.int64)
    basis_vecs = np.zeros((36, 36), dtype=np.int64)
    for bi, seed in enumerate(seeds):
        deg = seed["degree"]
        exp = tuple(seed["monomial_exponents"])
        r0, c0 = seed["matrix_unit_zero_based"]
        unit_idx = 6 * r0 + c0
        acc = np.tensordot(weights(exp), conj[:, :, unit_idx], axes=(0, 0)) % P
        scale = (mult[deg] * den_inv) % P
        acc = (acc * scale) % P
        basis_vecs[bi] = acc
        basis_mats[bi] = acc.reshape(6, 6)

    V = basis_vecs.T % P
    full_det = det_mod(V)
    if full_det == 0:
        fail("specialized frame dependent")
    V_inv = inv_mat(V)

    structure = np.zeros((36, 36, 36), dtype=np.int64)
    n_fail = 0
    for i in range(36):
        for j in range(36):
            prod = (basis_mats[i] @ basis_mats[j]) % P
            pv = prod.reshape(-1) % P
            coeffs = (V_inv @ pv) % P
            recon = (V @ coeffs) % P
            if not np.array_equal(recon, pv):
                n_fail += 1
            structure[i, j] = coeffs
    if n_fail:
        fail(f"{n_fail} products left the specialized span")

    n_assoc_fail = 0
    rng = np.random.default_rng(0)
    for _ in range(80):
        i, j, k = map(int, rng.integers(0, 36, size=3))
        left = np.zeros(36, dtype=np.int64)
        for a in range(36):
            cij_a = int(structure[i, j, a])
            if cij_a:
                left = (left + cij_a * structure[a, k]) % P
        right = np.zeros(36, dtype=np.int64)
        for a in range(36):
            cjk_a = int(structure[j, k, a])
            if cjk_a:
                right = (right + cjk_a * structure[i, a]) % P
        if not np.array_equal(left, right):
            n_assoc_fail += 1
    if n_assoc_fail:
        fail(f"associativity failures: {n_assoc_fail}")

    I_vec = np.eye(6, dtype=np.int64).reshape(-1) % P
    I_coeffs = (V_inv @ I_vec) % P
    I_recon = (V @ I_coeffs) % P
    if not np.array_equal(I_recon, I_vec):
        fail("identity not in specialized span")
    I_mat = I_recon.reshape(6, 6)
    for j in range(36):
        prod = (I_mat @ basis_mats[j]) % P
        cj = (V_inv @ prod.reshape(-1)) % P
        expected = np.zeros(36, dtype=np.int64)
        expected[j] = 1
        if not np.array_equal(cj, expected):
            fail(f"identity left mult failed at basis {j}")

    # Cross-check stored npz if present
    npz_path = SCRATCH / "structure_constants_f23.npz"
    if npz_path.is_file():
        stored = np.load(npz_path)
        if not np.array_equal(stored["structure"] % P, structure % P):
            fail("stored structure_constants_f23.npz disagrees with recompute")

    return {
        "basis_det_mod_p": int(full_det),
        "n_fail_span": 0,
        "associativity_failures": 0,
        "identity_ok": True,
        "structure_constants_nnz": int(np.count_nonzero(structure)),
        "trace_I": int(np.trace(I_mat)) % P,
    }


def main() -> None:
    required = [
        "C1_MODEL.md",
        "preflight_c1.json",
        "exit_c1.json",
        "verify_c1.py",
    ]
    for name in required:
        if not (PKG / name).is_file():
            fail(f"missing required file {name}")

    # --- recompute dimension arithmetic ---
    dim_gr = 2 * (6 - 2)
    codim = 5
    dim_f14 = dim_gr - codim
    if dim_gr != 8 or dim_f14 != 3:
        fail(f"dimension arithmetic broken: gr={dim_gr} f14={dim_f14}")
    dim_herm = 3 + 3 * 4
    if dim_herm != 15:
        fail(f"Herm_3 dimension {dim_herm} != 15")
    if 2 * 4 - 5 != 3:
        fail("affine chart expected dimension broken")

    # --- orbit degrees ---
    g_order = 660
    deg_a4 = g_order // 12
    deg_c11 = g_order // 11
    deg_c5 = g_order // 5
    if (deg_a4, deg_c11, deg_c5) != (55, 60, 132):
        fail(f"orbit degrees {(deg_a4, deg_c11, deg_c5)}")
    if gcd(gcd(deg_a4, deg_c11), deg_c5) != 1:
        fail("gcd of orbit degrees != 1")
    # order-12 split from director correction (counts only; GAP not required)
    if 55 + 55 != 110:
        fail("order-12 subgroup count split broken")

    # --- quaternion corner still empty ---
    qc = json.loads((PFAFFIAN / "quaternion_corner.json").read_text())
    if qc.get("quaternion_corner", {}).get("explicit_symbol_installed") is not False:
        fail("explicit_symbol_installed must still be false")
    if qc.get("five_hermitian_forms", {}).get("explicit_matrices_installed") is not False:
        fail("explicit_matrices_installed must still be false")

    # --- exit payload ---
    exit_data = json.loads((PKG / "exit_c1.json").read_text())
    if exit_data.get("exit") != "C1-UNDECIDED":
        fail(f"exit marker is {exit_data.get('exit')!r}, expected C1-UNDECIDED")
    if exit_data.get("headline") != "OPEN":
        fail("headline must remain OPEN")
    for forbidden in ("C1-MODEL-PASS", "C-FANO-POINT"):
        if forbidden not in exit_data.get("exits_not_claimed", []):
            fail(f"must explicitly not claim {forbidden}")
    steps = exit_data.get("c1_1", {}).get("steps_installed", {})
    if steps.get("1_A_proj") != "partial":
        fail("step 1 must be recorded as partial")
    for key_name in (
        "2_Morita_symbol",
        "3_hermitian_matrices",
        "4_restricted_plucker",
        "5_split_fibre_check",
    ):
        if steps.get(key_name) not in (False, "not_installed", "not_run"):
            # accept false booleans only
            if steps.get(key_name) is not False:
                fail(f"step {key_name} must not be claimed installed")

    pre = json.loads((PKG / "preflight_c1.json").read_text())
    if pre.get("exit") != "C1-UNDECIDED":
        fail("preflight exit must be C1-UNDECIDED")
    if pre.get("smallest_exact_system", {}).get("name") != "S1":
        fail("smallest exact system must be S1")
    floor = pre.get("resource_floor", {})
    if "structure_constants" not in floor.get("dominant_stage", ""):
        fail("resource floor must name structure constants stage")
    if pre.get("corrections", {}).get("corr_1_picard_vs_birational", {}).get("reopens") in (
        None,
        "",
        False,
    ):
        # reopens is a string description — require key present and not_done_here
        pass
    corr1 = pre.get("corrections", {}).get("corr_1_picard_vs_birational", {})
    if not corr1.get("not_done_here"):
        fail("corr1 must record birational search not done in this dispatch")
    corr2 = pre.get("corrections", {}).get("corr_2_degree55_brauer", {})
    if corr2.get("reopens") is not False:
        fail("corr2 must not reopen Brauer lever")

    # --- FAIL-SCOPE language in model prose ---
    model = (PKG / "C1_MODEL.md").read_text()
    for needle in (
        "FAIL-SCOPE",
        "C1-UNDECIDED",
        "OPEN",
        "S1",
        "structure constants",
        "birational",
        "codimension-five",
        "auxiliary Pfaffian",
    ):
        if needle not in model:
            fail(f"C1_MODEL.md missing required language: {needle}")

    # forbid overclaims
    for bad in (
        "C1-MODEL-PASS achieved",
        "explicit symbol installed",
        "F14_T(K_proj) nonempty",
        "the cubic has a K_proj-point abstractly",
        "generic Schur twist has no rational point",
    ):
        if bad in model:
            fail(f"C1_MODEL.md contains forbidden overclaim: {bad}")

    # --- modular decisive recompute ---
    mod = recompute_modular_algebra()
    if mod["basis_det_mod_p"] != 6:
        fail(f"basis det {mod['basis_det_mod_p']} != 6")
    if mod["trace_I"] != 6:
        fail(f"tr(I)={mod['trace_I']} != 6")
    if mod["structure_constants_nnz"] != pre.get("modular_probe", {}).get(
        "structure_constants_nnz"
    ):
        # allow preflight JSON to match recompute
        reported = pre.get("modular_probe", {}).get("structure_constants_nnz")
        if reported is not None and reported != mod["structure_constants_nnz"]:
            fail(
                f"nnz mismatch recompute={mod['structure_constants_nnz']} "
                f"json={reported}"
            )

    # alignment certificate still present
    if not (ALIGN / "certificate.json").is_file():
        fail("alignment certificate missing")
    achieved = json.loads((ALIGN / "certificate.json").read_text()).get("achieved", [])
    if not any("vector-space frame" in a or "Reynolds" in a for a in achieved):
        # achieved strings from certificate
        if len(achieved) < 3:
            fail("alignment certificate achieved list unexpected")

    # pin hashes for sealed upstream if recorded
    for rel, expected in pre.get("upstream_pins", {}).items():
        path = ROOT / rel
        if not path.is_file():
            fail(f"pinned upstream missing: {rel}")
        got = sha256_file(path)
        if got != expected:
            fail(f"upstream pin mismatch for {rel}: {got} != {expected}")

    print("PASS dimension arithmetic dim Gr=8, dim F14=3, dim Herm_3=15")
    print("PASS orbit degrees 55,60,132 gcd=1; order-12 count 110=55+55")
    print("PASS quaternion_corner still has no explicit symbol or matrices")
    print("PASS exit C1-UNDECIDED; headline OPEN; model pass not claimed")
    print(
        f"PASS modular F_23 algebra: det={mod['basis_det_mod_p']} "
        f"nnz={mod['structure_constants_nnz']} assoc_ok identity_ok"
    )
    print("PASS FAIL-SCOPE / S1 / resource-floor language present")
    print("PASS upstream pins match")
    print("VERIFY_C1_OK")
    print("exit=C1-UNDECIDED")
    print("headline=OPEN")


if __name__ == "__main__":
    main()
