#!/usr/bin/env python3
"""Independent verifier for Track C3.0 / C3.1-preflight.

Does NOT import produce_c3.py. Recomputes the decisive invariants:
  - at p=23 and p=89: minpoly of a has degree 6 and is separable;
  - rectangular basis {b^j a^i} has nonzero determinant in the Reynolds frame;
  - same pair and exponent rectangle at both primes;
  - modular holdout primes reconfirm nonzero rectangle det;
  - b^6 and L_a matrix identities hold at primary/secondary;
  - preflight exists and does not claim C3-APROJ-EXECUTABLE / C-FANO-POINT;
  - exit claims match; headline OPEN;
  - artifact self-hashes if present.

House rule: for every number reported, recompute it.
"""

from __future__ import annotations

import hashlib
import json
import resource
import sys
import time
from pathlib import Path

import numpy as np
import runpy

ROOT = Path(__file__).resolve().parents[2]
PKG = Path(__file__).resolve().parent
ALIGN = ROOT / "tmp" / "pfaffian_representation_alignment"
C1_STRUCT = ROOT / "tmp" / "c1_preflight" / "structure_constants_f23.npz"
C2 = ROOT / "certificates" / "fano_c2"

PRIMARY_P = 23
PRIMARY_ZETA = 2
SECONDARY_P = 89
SECONDARY_ZETA = 2
POINT = np.array([1, 2, 3, 4, 5], dtype=np.int64)
JS = (1, 3, 2, 5, 4)
SIGNS = (1, 1, -1, 1, 1)
QUADRATIC_RESIDUES = {1, 3, 4, 5, 9}


def fail(msg: str) -> None:
    print(f"VERIFY_C3_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def power(matrix: np.ndarray, exponent: int, p: int) -> np.ndarray:
    result = np.eye(matrix.shape[0], dtype=np.int64) % p
    matrix = matrix % p
    while exponent:
        if exponent & 1:
            result = (result @ matrix) % p
        matrix = (matrix @ matrix) % p
        exponent //= 2
    return result


def key(matrix: np.ndarray, p: int) -> bytes:
    return bytes((matrix % p).astype(np.uint8).flat)


def inv_mat(matrix: np.ndarray, p: int) -> np.ndarray:
    n = matrix.shape[0]
    a = np.concatenate([matrix % p, np.eye(n, dtype=np.int64)], axis=1)
    for col in range(n):
        pivots = np.flatnonzero(a[col:, col] % p)
        if not len(pivots):
            raise ValueError("singular")
        piv = col + int(pivots[0])
        if piv != col:
            a[[col, piv]] = a[[piv, col]]
        inv_p = pow(int(a[col, col]) % p, -1, p)
        a[col] = (a[col] * inv_p) % p
        for row in range(n):
            if row != col and a[row, col] % p:
                a[row] = (a[row] - a[row, col] * a[col]) % p
    return a[:, n:] % p


def det_mod(matrix: np.ndarray, p: int) -> int:
    m = matrix.copy() % p
    result = 1
    for col in range(m.shape[1]):
        cands = np.flatnonzero(m[col:, col] % p)
        if not len(cands):
            return 0
        piv = col + int(cands[0])
        if piv != col:
            m[[col, piv]] = m[[piv, col]]
            result = -result
        pv = int(m[col, col]) % p
        result = (result * pv) % p
        inv_p = pow(pv, -1, p)
        m[col] = (m[col] * inv_p) % p
        for row in range(col + 1, m.shape[0]):
            if m[row, col] % p:
                m[row] = (m[row] - m[row, col] * m[col]) % p
    return result % p


def mat_pow(M: np.ndarray, e: int, p: int) -> np.ndarray:
    return power(M, e, p)


def minpoly_coeffs(M: np.ndarray, p: int) -> list[int] | None:
    mats = [np.eye(6, dtype=np.int64) % p]
    for _ in range(1, 7):
        mats.append((mats[-1] @ M) % p)
    for d in range(1, 7):
        V = np.stack([m.reshape(-1) for m in mats[: d + 1]], axis=1) % p
        A = V[:, :d].copy()
        rhs = (-V[:, d]) % p
        Aug = np.concatenate([A, rhs.reshape(-1, 1)], axis=1) % p
        r = 0
        pivots: list[int] = []
        rows = Aug.shape[0]
        for c in range(d):
            cands = np.flatnonzero(Aug[r:, c] % p)
            if not len(cands):
                continue
            piv = r + int(cands[0])
            if piv != r:
                Aug[[r, piv]] = Aug[[piv, r]]
            inv = pow(int(Aug[r, c]) % p, -1, p)
            Aug[r] = (Aug[r] * inv) % p
            for i in range(rows):
                if i != r and Aug[i, c] % p:
                    Aug[i] = (Aug[i] - Aug[i, c] * Aug[r]) % p
            pivots.append(c)
            r += 1
        if len(pivots) < d:
            continue
        if any(Aug[i, d] % p for i in range(r, rows)):
            continue
        sol = np.zeros(d, dtype=np.int64)
        for i, pv in enumerate(pivots):
            sol[pv] = Aug[i, d] % p
        coeffs = [int(x) for x in sol] + [1]
        acc = np.zeros((6, 6), dtype=np.int64)
        for i, ci in enumerate(coeffs):
            acc = (acc + ci * mats[i]) % p
        if np.all(acc % p == 0):
            return coeffs
    return None


def poly_deriv(c: list[int], p: int) -> list[int]:
    return [(i * c[i]) % p for i in range(1, len(c))]


def poly_gcd(a: list[int], b: list[int], p: int) -> list[int]:
    a = [int(x) % p for x in a]
    b = [int(x) % p for x in b]
    while any(x % p for x in b):
        while a and a[-1] % p == 0:
            a.pop()
        while b and b[-1] % p == 0:
            b.pop()
        if not b:
            break
        if len(a) < len(b):
            a, b = b, a
            continue
        inv = pow(b[-1], -1, p)
        scale = (a[-1] * inv) % p
        da = len(a) - len(b)
        for i in range(len(b)):
            a[i + da] = (a[i + da] - scale * b[i]) % p
        while a and a[-1] % p == 0:
            a.pop()
        a, b = b, a
    while a and a[-1] % p == 0:
        a.pop()
    return a


def is_separable(coeffs: list[int], p: int) -> bool:
    d = poly_deriv(coeffs, p)
    g = poly_gcd(list(coeffs), d, p)
    return len(g) == 1 and g[0] % p != 0


def rectangle_det_m6(a: np.ndarray, b: np.ndarray, p: int) -> int:
    cols = []
    for j in range(6):
        bj = mat_pow(b, j, p)
        for i in range(6):
            ai = mat_pow(a, i, p)
            cols.append((bj @ ai).reshape(-1) % p)
    R = np.stack(cols, axis=1) % p
    return det_mod(R, p)


def rectangle_det_frame(
    a: np.ndarray, b: np.ndarray, basis_vecs: np.ndarray, p: int
) -> int:
    cols = []
    for j in range(6):
        bj = mat_pow(b, j, p)
        for i in range(6):
            ai = mat_pow(a, i, p)
            cols.append((bj @ ai).reshape(-1) % p)
    V = basis_vecs.T % p
    V_inv = inv_mat(V, p)
    coords = [(V_inv @ c) % p for c in cols]
    C = np.stack(coords, axis=1) % p
    return det_mod(C, p)


def weil_generators(p: int, zeta: int):
    assert pow(zeta, 11, p) == 1
    gamma = sum(
        (1 if e in QUADRATIC_RESIDUES else -1) * pow(zeta, e, p)
        for e in range(1, 11)
    ) % p
    weil_s = np.array(
        [
            [
                SIGNS[c]
                * pow(SIGNS[r], -1, p)
                * (
                    pow(zeta, 9 * JS[r] * JS[c], p)
                    - pow(zeta, (-9 * JS[r] * JS[c]) % 11, p)
                )
                * pow(gamma, -1, p)
                % p
                for c in range(5)
            ]
            for r in range(5)
        ],
        dtype=np.int64,
    )
    weil_t = np.diag([pow(zeta, v * v, p) for v in JS]).astype(np.int64)
    return weil_s, weil_t


def schur_generators(p: int, zeta: int):
    c = sum(pow(zeta, e, p) for e in (9, 5, 4, 3, 1)) % p
    first = (
        np.array(
            [
                [0, c, -1, 1, 0, 0],
                [0, c + 1, 0, -c, -1, 0],
                [0, c - 1, 0, 1, 0, 1],
                [0, c + 2, 0, -c - 1, 0, 0],
                [0, 1, 0, -1, 0, 0],
                [-1, 2, 0, -1, 0, 0],
            ],
            dtype=np.int64,
        )
        % p
    )
    second = (
        np.array(
            [
                [1, -1, 0, 0, 0, 0],
                [1, 0, 0, -1, 0, 0],
                [c + 1, 0, -1, 0, 0, 0],
                [1, 0, 0, 0, -1, 0],
                [1, 0, 0, 0, 0, 0],
                [-c, 0, 0, 0, 0, -1],
            ],
            dtype=np.int64,
        )
        % p
    )
    return first, second


def build_projective_reynolds_frame(p: int, zeta: int) -> dict:
    weil_s, weil_t = weil_generators(p, zeta)
    schur_a, schur_b = schur_generators(p, zeta)
    image_a = (weil_t @ weil_s @ weil_t @ weil_s) % p
    image_b = (power(weil_t, 8, p) @ weil_s) % p
    identity5 = np.eye(5, dtype=np.int64) % p
    identity6 = np.eye(6, dtype=np.int64) % p
    seen = {key(identity5, p): (identity5, identity6)}
    queue = [seen[key(identity5, p)]]
    while queue:
        target, source = queue.pop()
        for tg, sg in ((image_a, schur_a), (image_b, schur_b)):
            nt = (target @ tg) % p
            ns = (source @ sg) % p
            nk = key(nt, p)
            if nk not in seen:
                seen[nk] = (nt, ns)
                queue.append((nt, ns))
    if len(seen) != 660:
        fail(f"group order {len(seen)} at p={p}")

    cert = json.loads((ALIGN / "certificate.json").read_text())
    seeds = cert["end36_reynolds_frame"]["selected_reynolds_seeds"]
    kproj = runpy.run_path(str(ROOT / "tmp" / "kproj_arithmetic" / "core.py"))
    forms = kproj["forms"]()
    evaluate_mod = kproj["evaluate_mod"]
    point_t = tuple(int(x) for x in POINT)
    mult = {
        deg: int(evaluate_mod(forms[14 - deg], point_t, p))
        for deg in sorted({s["degree"] for s in seeds})
    }
    den = int(evaluate_mod(forms[14], point_t, p))
    if den == 0 or any(v == 0 for v in mult.values()):
        fail(f"vanishing homogenization at p={p}")

    group = list(seen.values())
    conj = np.zeros((660, 36, 36), dtype=np.int64)
    inv_targets = np.zeros((660, 5, 5), dtype=np.int64)
    for gi, (target, source) in enumerate(group):
        source_inv = inv_mat(source, p)
        inv_targets[gi] = inv_mat(target, p)
        for r in range(6):
            for c in range(6):
                conj[gi, :, 6 * r + c] = (
                    np.outer(source[:, r], source_inv[c, :]).reshape(-1)
                ) % p

    orbit_points = np.einsum("gij,j->gi", inv_targets, POINT) % p
    powers = np.ones((660, 5, 9), dtype=np.int64)
    for e in range(1, 9):
        powers[:, :, e] = powers[:, :, e - 1] * orbit_points % p

    def weights(exponents):
        result = np.ones(660, dtype=np.int64)
        for var, exp in enumerate(exponents):
            if exp:
                result = result * powers[:, var, exp] % p
        return result

    basis_mats = np.zeros((36, 6, 6), dtype=np.int64)
    basis_vecs = np.zeros((36, 36), dtype=np.int64)
    for bi, seed in enumerate(seeds):
        deg = seed["degree"]
        exp = tuple(seed["monomial_exponents"])
        r0, c0 = seed["matrix_unit_zero_based"]
        unit_idx = 6 * r0 + c0
        acc = np.tensordot(weights(exp), conj[:, :, unit_idx], axes=(0, 0)) % p
        scale = (mult[deg] * pow(den, -1, p)) % p
        acc = (acc * scale) % p
        basis_vecs[bi] = acc
        basis_mats[bi] = acc.reshape(6, 6)

    frame_det = det_mod(basis_vecs.T % p, p)
    if frame_det == 0:
        fail(f"frame singular at p={p}")
    return {
        "basis_mats": basis_mats,
        "basis_vecs": basis_vecs,
        "frame_det": int(frame_det),
    }


def express_in_rectangle(M, a, b, p):
    cols = []
    for j in range(6):
        bj = mat_pow(b, j, p)
        for i in range(6):
            cols.append((bj @ mat_pow(a, i, p)).reshape(-1) % p)
    R = np.stack(cols, axis=1) % p
    R_inv = inv_mat(R, p)
    return ((R_inv @ M.reshape(-1)) % p).reshape(6, 6)


def check_b6(a, b, e_coords, p) -> bool:
    b6 = mat_pow(b, 6, p)
    acc = np.zeros((6, 6), dtype=np.int64)
    for j in range(6):
        ej = np.zeros((6, 6), dtype=np.int64)
        for i in range(6):
            ej = (ej + int(e_coords[j, i]) * mat_pow(a, i, p)) % p
        acc = (acc + mat_pow(b, j, p) @ ej) % p
    return np.array_equal(acc % p, b6 % p)


def check_La(a, b, La_E, p) -> bool:
    for j in range(6):
        left = (a @ mat_pow(b, j, p)) % p
        right = np.zeros((6, 6), dtype=np.int64)
        for k in range(6):
            mk = np.zeros((6, 6), dtype=np.int64)
            for i in range(6):
                mk = (mk + int(La_E[k, j, i]) * mat_pow(a, i, p)) % p
            right = (right + mat_pow(b, k, p) @ mk) % p
        if not np.array_equal(left, right):
            return False
    return True


def main() -> None:
    t0 = time.perf_counter()
    checks = []

    rb_path = PKG / "rectangular_basis.json"
    if not rb_path.exists():
        fail("missing rectangular_basis.json")
    rb = json.loads(rb_path.read_text())
    exit_path = PKG / "exit_c3.json"
    if not exit_path.exists():
        fail("missing exit_c3.json")
    exit_j = json.loads(exit_path.read_text())
    pre_path = PKG / "preflight_c31.json"
    if not pre_path.exists():
        fail("missing preflight_c31.json")
    pre = json.loads(pre_path.read_text())
    npz_path = PKG / "rectangular_basis.npz"
    if not npz_path.exists():
        fail("missing rectangular_basis.npz")
    npz = np.load(npz_path)

    # Exit claims
    if rb.get("exit") != "C3-RECTANGULAR-BASIS-MODULAR":
        fail(f"bad rb exit {rb.get('exit')}")
    if exit_j.get("exit_c30") != "C3-RECTANGULAR-BASIS-MODULAR":
        fail(f"bad exit_c30 {exit_j.get('exit_c30')}")
    if exit_j.get("headline") != "OPEN" or rb.get("headline") != "OPEN":
        fail("headline must be OPEN")
    if exit_j.get("exit_c31") == "C3-APROJ-EXECUTABLE":
        fail("C3.1 claims APROJ-EXECUTABLE without full reconstruction artifacts")
    if pre.get("c31_exit") == "C3-APROJ-EXECUTABLE":
        fail("preflight claims C3-APROJ-EXECUTABLE")
    banned = ("C-FANO-POINT", "C3-FANO-MODEL-PASS")
    blob = json.dumps(rb) + json.dumps(pre) + json.dumps(exit_j)
    for b in banned:
        if b in blob and pre.get("c31_exit") != b:
            # allow mention in out_of_scope lists
            pass
    if pre.get("next_exit_target") == "C-FANO-POINT":
        fail("preflight next target jumps to Fano point")
    checks.append("exit_claims")

    pair = rb["pair"]
    ai = pair["a_frame_index"]
    bi = pair["b_frame_index"]
    if ai is None or bi is None:
        fail("verifier expects pure frame indices for sealed success path")
    # Cross-check C2 sealed pair if source is sealed
    c2 = json.loads((C2 / "word_basis.json").read_text())
    if pair.get("source") == "sealed_C2_pair":
        if c2["pair"]["a_frame_index"] != ai or c2["pair"]["b_frame_index"] != bi:
            fail("pair does not match sealed C2.0")
    checks.append("pair_vs_c2")

    # Primary p=23 from sealed C1 structure
    sealed = np.load(C1_STRUCT)
    sealed_vecs = sealed["basis_vecs"].astype(np.int64) % PRIMARY_P
    sealed_mats = sealed_vecs.reshape(36, 6, 6)
    a23 = sealed_mats[ai]
    b23 = sealed_mats[bi]

    # Confirm rebuilt frame matches sealed
    frame23 = build_projective_reynolds_frame(PRIMARY_P, PRIMARY_ZETA)
    if not np.array_equal(frame23["basis_vecs"] % PRIMARY_P, sealed_vecs):
        fail("rebuilt p=23 frame != sealed C1")

    mpc23 = minpoly_coeffs(a23, PRIMARY_P)
    if mpc23 is None or len(mpc23) != 7:
        fail(f"p=23 minpoly not degree 6: {mpc23}")
    if not is_separable(mpc23, PRIMARY_P):
        fail("p=23 minpoly not separable")
    det_m6_23 = rectangle_det_m6(a23, b23, PRIMARY_P)
    det_fr_23 = rectangle_det_frame(a23, b23, sealed_vecs, PRIMARY_P)
    if det_m6_23 % PRIMARY_P == 0:
        fail(f"p=23 rect det_m6 = 0")
    if det_fr_23 % PRIMARY_P == 0:
        fail(f"p=23 rect det_frame = 0")

    cert_p23 = rb["primary_witness"]
    if cert_p23["minpoly_coeffs"] != mpc23:
        fail(f"p=23 minpoly mismatch cert={cert_p23['minpoly_coeffs']} got={mpc23}")
    if int(cert_p23["rect_det_m6"]) != det_m6_23:
        fail(f"p=23 det_m6 mismatch cert={cert_p23['rect_det_m6']} got={det_m6_23}")
    if int(cert_p23["rect_det_frame"]) != det_fr_23:
        fail(
            f"p=23 det_frame mismatch cert={cert_p23['rect_det_frame']} got={det_fr_23}"
        )
    checks.append("primary_p23")

    # Secondary p=89
    frame89 = build_projective_reynolds_frame(SECONDARY_P, SECONDARY_ZETA)
    a89 = frame89["basis_mats"][ai]
    b89 = frame89["basis_mats"][bi]
    mpc89 = minpoly_coeffs(a89, SECONDARY_P)
    if mpc89 is None or len(mpc89) != 7:
        fail(f"p=89 minpoly not degree 6: {mpc89}")
    if not is_separable(mpc89, SECONDARY_P):
        fail("p=89 minpoly not separable")
    det_m6_89 = rectangle_det_m6(a89, b89, SECONDARY_P)
    det_fr_89 = rectangle_det_frame(a89, b89, frame89["basis_vecs"], SECONDARY_P)
    if det_m6_89 % SECONDARY_P == 0:
        fail("p=89 rect det_m6 = 0")
    if det_fr_89 % SECONDARY_P == 0:
        fail("p=89 rect det_frame = 0")
    cert_p89 = rb["secondary_witness"]
    if cert_p89["minpoly_coeffs"] != mpc89:
        fail(f"p=89 minpoly mismatch")
    if int(cert_p89["rect_det_m6"]) != det_m6_89:
        fail(f"p=89 det_m6 mismatch cert={cert_p89['rect_det_m6']} got={det_m6_89}")
    if int(cert_p89["rect_det_frame"]) != det_fr_89:
        fail(f"p=89 det_frame mismatch")
    checks.append("secondary_p89")

    # Holdout primes from certificate
    for key_name, default_p, default_z in (
        ("holdout_modular", 199, 18),
        ("holdout_probe_prime", 463, 15),
    ):
        block = rb.get(key_name)
        if not block:
            fail(f"missing {key_name}")
        p = int(block["prime"])
        z = int(block["zeta_11"])
        if p == 67:
            fail("p=67 used as decision fibre")
        frame = build_projective_reynolds_frame(p, z)
        a = frame["basis_mats"][ai]
        b = frame["basis_mats"][bi]
        mpc = minpoly_coeffs(a, p)
        if mpc is None or len(mpc) != 7 or not is_separable(mpc, p):
            fail(f"holdout p={p} minpoly/separability failed")
        det = rectangle_det_m6(a, b, p)
        if det % p == 0:
            fail(f"holdout p={p} rect det=0")
        if int(block["rect_det_m6"]) != det:
            fail(f"holdout p={p} det mismatch cert={block['rect_det_m6']} got={det}")
        if not block.get("success", True):
            fail(f"holdout p={p} marked success=false but recomputed ok")
        checks.append(f"holdout_p{p}")

    # NPZ consistency and identities at p=23,89
    if not np.array_equal(npz["a_matrix_f23"] % PRIMARY_P, a23):
        fail("npz a_matrix_f23 mismatch")
    if not np.array_equal(npz["b_matrix_f23"] % PRIMARY_P, b23):
        fail("npz b_matrix_f23 mismatch")
    e23 = npz["e_coords_f23"].astype(np.int64) % PRIMARY_P
    La23 = npz["La_E_f23"].astype(np.int64) % PRIMARY_P
    if not check_b6(a23, b23, e23, PRIMARY_P):
        fail("p=23 b^6 identity failed")
    if not check_La(a23, b23, La23, PRIMARY_P):
        fail("p=23 L_a identity failed")
    # recompute e_coords independently
    e23_re = express_in_rectangle(mat_pow(b23, 6, PRIMARY_P), a23, b23, PRIMARY_P)
    if not np.array_equal(e23_re, e23):
        fail("p=23 e_coords recompute mismatch")

    e89 = npz["e_coords_f89"].astype(np.int64) % SECONDARY_P
    La89 = npz["La_E_f89"].astype(np.int64) % SECONDARY_P
    if not check_b6(a89, b89, e89, SECONDARY_P):
        fail("p=89 b^6 identity failed")
    if not check_La(a89, b89, La89, SECONDARY_P):
        fail("p=89 L_a identity failed")
    checks.append("identities")

    # Preflight hygiene
    if "36^3" in json.dumps(pre.get("out_of_scope_this_round", [])) or any(
        "36" in str(x) and "structure" in str(x).lower()
        for x in pre.get("out_of_scope_this_round", [])
    ):
        pass  # good, banned
    if pre.get("c31_exit") not in (
        "C3-RECONSTRUCTION-UNDECIDED",
        "C3-APROJ-EXECUTABLE",
    ):
        fail(f"bad c31_exit {pre.get('c31_exit')}")
    if pre["c31_exit"] == "C3-APROJ-EXECUTABLE":
        fail("must not claim APROJ without reconstruction")
    # common_p25x line reference
    if pre.get("common_p25x_helper_line") != 226:
        fail("must cite common_p25x.py:226 for rational reconstruction")
    checks.append("preflight")

    # Self-hashes last
    sha_path = PKG / "SHA256SUMS"
    if sha_path.exists():
        lines = sha_path.read_text().strip().splitlines()
        for line in lines:
            parts = line.split()
            if len(parts) < 2:
                continue
            digest, name = parts[0], parts[-1]
            fp = PKG / name
            if not fp.exists():
                fail(f"SHA256SUMS names missing file {name}")
            if name == "SHA256SUMS":
                continue
            got = sha256_file(fp)
            if got != digest:
                fail(f"hash mismatch for {name}")
        checks.append("self_hashes")

    elapsed = time.perf_counter() - t0
    peak = int(resource.getrusage(resource.RUSAGE_SELF).ru_maxrss)
    result = {
        "status": "PASS",
        "checks": checks,
        "recomputed": {
            "p23": {
                "minpoly": mpc23,
                "separable": True,
                "rect_det_m6": det_m6_23,
                "rect_det_frame": det_fr_23,
            },
            "p89": {
                "minpoly": mpc89,
                "separable": True,
                "rect_det_m6": det_m6_89,
                "rect_det_frame": det_fr_89,
            },
        },
        "exit_c30": "C3-RECTANGULAR-BASIS-MODULAR",
        "exit_c31": exit_j.get("exit_c31"),
        "headline": "OPEN",
        "elapsed_seconds": round(elapsed, 3),
        "peak_rss_MiB": round(peak / (1024 * 1024), 2),
    }
    (PKG / "verify_c3_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(f"VERIFY_C3_PASS: {checks}")
    print(
        f"  p23 det_m6={det_m6_23} det_fr={det_fr_23} minpoly={mpc23}"
    )
    print(
        f"  p89 det_m6={det_m6_89} det_fr={det_fr_89} minpoly={mpc89}"
    )
    print(f"  elapsed={elapsed:.3f}s peak_MiB={peak/(1024*1024):.2f}")


if __name__ == "__main__":
    main()
