#!/usr/bin/env python3
"""Independent verifier for Track C2.0 (two-generator modular word basis).

Does NOT import produce_c2.py. Recomputes the decisive invariants:
  - at p=23: rebuild or load sealed frame; form a=e_i, b=e_j; shortlex words;
    independence rank 36; word-basis determinant is a unit;
  - at p=89: same pair generates with unit word-basis determinant;
  - sealed words in word_basis.json match recomputed shortlex basis;
  - exit claim is C2-TWO-GENERATORS-MODULAR; headline OPEN;
  - preflight exists and does not claim C2-APROJ-EXECUTABLE / C-FANO-POINT;
  - artifact self-hashes if present.

House rule: for every number reported, recompute it.
"""

from __future__ import annotations

import hashlib
import json
import resource
import sys
import time
from itertools import product
from pathlib import Path

import numpy as np
import runpy

ROOT = Path(__file__).resolve().parents[2]
PKG = Path(__file__).resolve().parent
ALIGN = ROOT / "tmp" / "pfaffian_representation_alignment"
C1_STRUCT = ROOT / "tmp" / "c1_preflight" / "structure_constants_f23.npz"

PRIMARY_P = 23
PRIMARY_ZETA = 2
SECONDARY_P = 89
SECONDARY_ZETA = 2
POINT = np.array([1, 2, 3, 4, 5], dtype=np.int64)
JS = (1, 3, 2, 5, 4)
SIGNS = (1, 1, -1, 1, 1)
QUADRATIC_RESIDUES = {1, 3, 4, 5, 9}


def fail(msg: str) -> None:
    print(f"VERIFY_C2_FAIL: {msg}", file=sys.stderr)
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


def row_rank(vecs: list[np.ndarray], p: int) -> int:
    if not vecs:
        return 0
    m = np.stack(vecs, axis=0).astype(np.int64) % p
    r = 0
    rows, cols = m.shape
    for c in range(cols):
        if r >= rows:
            break
        cands = np.flatnonzero(m[r:, c] % p)
        if not len(cands):
            continue
        piv = r + int(cands[0])
        if piv != r:
            m[[r, piv]] = m[[piv, r]]
        inv_p = pow(int(m[r, c]) % p, -1, p)
        m[r] = (m[r] * inv_p) % p
        for i in range(rows):
            if i != r and m[i, c] % p:
                m[i] = (m[i] - m[i, c] * m[r]) % p
        r += 1
    return r


def eval_word(word: str, A: np.ndarray, B: np.ndarray, p: int) -> np.ndarray:
    M = np.eye(6, dtype=np.int64) % p
    for ch in word:
        M = (M @ (A if ch == "a" else B)) % p
    return M


def shortlex_words(max_len: int):
    yield ""
    for length in range(1, max_len + 1):
        for tup in product("ab", repeat=length):
            yield "".join(tup)


def word_basis(A: np.ndarray, B: np.ndarray, p: int, max_len: int = 10):
    words: list[str] = []
    vecs: list[np.ndarray] = []
    for w in shortlex_words(max_len):
        v = eval_word(w, A, B, p).reshape(-1) % p
        if row_rank(vecs + [v], p) > len(vecs):
            words.append(w)
            vecs.append(v)
            if len(words) == 36:
                break
    if len(words) < 36:
        return words, vecs, 0
    return words, vecs, det_mod(np.stack(vecs, axis=1) % p, p)


def build_frame(p: int, zeta: int) -> tuple[np.ndarray, int]:
    assert pow(zeta, 11, p) == 1
    assert all(pow(zeta, d, p) != 1 for d in range(1, 11))
    gamma = sum(
        (1 if e in QUADRATIC_RESIDUES else -1) * pow(zeta, e, p)
        for e in range(1, 11)
    ) % p
    assert gamma * gamma % p == (-11) % p
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
    c = sum(pow(zeta, e, p) for e in (9, 5, 4, 3, 1)) % p
    schur_a = (
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
    schur_b = (
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
        fail(f"homogenization vanishes at p={p}")

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
        acc = np.tensordot(weights(exp), conj[:, :, 6 * r0 + c0], axes=(0, 0)) % p
        scale = (mult[deg] * pow(den, -1, p)) % p
        acc = (acc * scale) % p
        basis_vecs[bi] = acc
        basis_mats[bi] = acc.reshape(6, 6)

    frame_det = det_mod(basis_vecs.T % p, p)
    if frame_det == 0:
        fail(f"frame singular at p={p}")
    return basis_mats, frame_det


def main() -> None:
    t0 = time.perf_counter()
    required = [
        "C2_WORD_BASIS.md",
        "word_basis.json",
        "word_basis.npz",
        "preflight_c21.json",
        "produce_c2.py",
        "verify_c2.py",
    ]
    for name in required:
        if not (PKG / name).is_file():
            fail(f"missing deliverable {name}")

    meta = json.loads((PKG / "word_basis.json").read_text())
    pre = json.loads((PKG / "preflight_c21.json").read_text())
    npz = np.load(PKG / "word_basis.npz")

    if meta.get("exit") != "C2-TWO-GENERATORS-MODULAR":
        fail(f"bad exit {meta.get('exit')}")
    if meta.get("headline") != "OPEN":
        fail("headline must remain OPEN")
    if pre.get("next_exit_target") != "C2-APROJ-EXECUTABLE":
        fail("preflight next target wrong")
    if pre.get("compressed_route_viable") is not True:
        fail("preflight must record compressed route viability")
    # Must not claim later exits
    for bad in ("C2-APROJ-EXECUTABLE", "C2-FANO-MODEL", "C-FANO-POINT"):
        if meta.get("exit") == bad:
            fail(f"premature exit {bad}")

    i = int(meta["pair"]["a_frame_index"])
    j = int(meta["pair"]["b_frame_index"])
    sealed_words = meta["primary_witness"]["words"]
    claimed_det23 = int(meta["primary_witness"]["word_basis_det"])
    claimed_det89 = int(meta["secondary_witness"]["word_basis_det"])

    if not (0 <= i < 36 and 0 <= j < 36 and i != j):
        fail("bad frame indices")

    # --- primary p=23 from sealed C1 structure + rebuild cross-check ---
    sealed = np.load(C1_STRUCT)
    sealed_mats = sealed["basis_vecs"].astype(np.int64).reshape(36, 6, 6) % PRIMARY_P
    rebuilt23, frame_det23 = build_frame(PRIMARY_P, PRIMARY_ZETA)
    if not np.array_equal(rebuilt23 % PRIMARY_P, sealed_mats):
        fail("rebuilt p=23 frame != sealed C1 basis_vecs")
    if frame_det23 != int(meta["primary_witness"]["frame_det"]):
        fail(
            f"frame_det23 mismatch: recomputed {frame_det23} claimed "
            f"{meta['primary_witness']['frame_det']}"
        )

    A23, B23 = sealed_mats[i], sealed_mats[j]
    words23, vecs23, det23 = word_basis(A23, B23, PRIMARY_P, max_len=8)
    if len(words23) != 36:
        fail(f"primary rank {len(words23)} < 36")
    if det23 == 0:
        fail("primary word-basis det = 0")
    if det23 != claimed_det23:
        fail(f"primary det mismatch: recomputed {det23} claimed {claimed_det23}")
    if words23 != sealed_words:
        fail("primary shortlex word list mismatch vs word_basis.json")
    if not np.array_equal(A23.astype(np.uint8), npz["a_matrix_f23"]):
        fail("npz a_matrix_f23 mismatch")
    if not np.array_equal(B23.astype(np.uint8), npz["b_matrix_f23"]):
        fail("npz b_matrix_f23 mismatch")
    V23 = np.stack(vecs23, axis=1) % PRIMARY_P
    if not np.array_equal(V23.astype(np.uint8), npz["word_basis_matrix_f23"]):
        fail("npz word_basis_matrix_f23 mismatch")

    # Spot-check: each sealed word evaluates to the corresponding column
    for idx, w in enumerate(words23):
        M = eval_word(w, A23, B23, PRIMARY_P)
        if not np.array_equal(M.reshape(-1) % PRIMARY_P, vecs23[idx]):
            fail(f"word eval mismatch at index {idx} word={w!r}")

    # --- secondary p=89 ---
    mats89, frame_det89 = build_frame(SECONDARY_P, SECONDARY_ZETA)
    if frame_det89 != int(meta["secondary_witness"]["frame_det"]):
        fail(
            f"frame_det89 mismatch: recomputed {frame_det89} claimed "
            f"{meta['secondary_witness']['frame_det']}"
        )
    A89, B89 = mats89[i], mats89[j]
    words89, vecs89, det89 = word_basis(A89, B89, SECONDARY_P, max_len=8)
    if len(words89) != 36:
        fail(f"secondary rank {len(words89)} < 36")
    if det89 == 0:
        fail("secondary word-basis det = 0")
    if det89 != claimed_det89:
        fail(f"secondary det mismatch: recomputed {det89} claimed {claimed_det89}")

    # p=67 must not be the sole decision fibre
    if meta["secondary_witness"]["prime"] == 67 and meta["primary_witness"]["prime"] == 67:
        fail("p=67 sole decision fibre forbidden")
    if SECONDARY_P == 67:
        fail("verifier secondary is 67")

    # Narrative must name the trap / scope
    md = (PKG / "C2_WORD_BASIS.md").read_text()
    for needle in (
        "C2-TWO-GENERATORS-MODULAR",
        "OPEN",
        "Not proved",
        "Trap named",
        "e_1",
        "e_2",
    ):
        if needle not in md:
            fail(f"C2_WORD_BASIS.md missing {needle!r}")

    # Self-hashes if SEAL present
    seal_path = PKG / "SEAL.json"
    if seal_path.is_file():
        seal = json.loads(seal_path.read_text())
        for rel, expected in seal.get("file_sha256", {}).items():
            path = PKG / rel
            if not path.is_file():
                fail(f"SEAL references missing {rel}")
            got = sha256_file(path)
            if got != expected:
                fail(f"SEAL hash mismatch for {rel}")

    elapsed = time.perf_counter() - t0
    peak = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    print("VERIFY_C2_PASS")
    print(f"exit=C2-TWO-GENERATORS-MODULAR pair=e_{i},e_{j}")
    print(f"det23={det23} det89={det89} frame_det23={frame_det23} frame_det89={frame_det89}")
    print(f"words={len(words23)} max_len={max(len(w) for w in words23)}")
    print(f"elapsed_s={elapsed:.3f} peak_rss_MiB={peak/(1024*1024):.2f}")
    print("headline=OPEN")


if __name__ == "__main__":
    main()
