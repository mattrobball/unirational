#!/usr/bin/env python3
"""Independent H6 push torsor verifier (does not import produce_push)."""
from __future__ import annotations

import hashlib
import json
import random
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
H6A = ROOT / "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY"
H4 = ROOT / "goal_runs_after_35fa/H_11_5_TWIST"

A_COEFFS = [2, 1, 0, 0, 0]
B_COEFFS = [5, -3, 1, -1, 0]
KERNEL_C = [5, 3, 4, 9, 1]


def fail(msg: str) -> None:
    print(f"H6_PUSH_TORSOR_VERIFY_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def cycle_matrix(n: int = 5) -> sp.Matrix:
    M = sp.zeros(n)
    for i in range(n):
        M[i, (i - 1) % n] = 1
    return M


def poly_mat(coeffs, S):
    acc = sp.zeros(S.rows)
    Sk = sp.eye(S.rows)
    for c in coeffs:
        if c:
            acc = acc + int(c) * Sk
        Sk = Sk * S
    return acc


def restrict_to_aug(op: sp.Matrix) -> sp.Matrix:
    cols = []
    for j in range(4):
        v = [0] * 5
        v[j] = 1
        v[4] = -1
        w = op * sp.Matrix(v)
        xs = [int(w[i]) for i in range(4)]
        require(int(w[4]) == -sum(xs), "aug")
        cols.append(xs)
    return sp.Matrix(cols).T


def psi_A_mod(r, p: int):
    return [(pow(r[i], 2, p) * r[(i - 1) % 5]) % p for i in range(5)]


def psi_B_mod(m, p: int):
    out = []
    for i in range(5):
        val = 1
        for j, e in enumerate(B_COEFFS):
            idx = (i - j) % 5
            if e == 0:
                continue
            factor = pow(m[idx], abs(e), p)
            if e < 0:
                factor = pow(factor, p - 2, p)
            val = (val * factor) % p
        out.append(val)
    return out


def monom_mod(exp, r, p: int) -> int:
    val = 1
    for i, e in enumerate(exp):
        if e == 0:
            continue
        factor = pow(r[i], abs(e), p)
        if e < 0:
            factor = pow(factor, p - 2, p)
        val = val * factor % p
    return val


def product_one(rng, p):
    r = [rng.randrange(1, p) for _ in range(4)]
    r.append(pow(r[0] * r[1] * r[2] * r[3] % p, -1, p))
    return r


def main() -> None:
    for name in (
        "torsor_rebuild.json",
        "TORSOR_REBUILD.md",
        "INPUT_MANIFEST.json",
        "STATUS.md",
        "SEAL.json",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("H6-TORSOR-CLASS-PASS\n"), "STATUS exit")
    require("OPEN" in status, "headline open")

    h6a_status = (H6A / "STATUS.md").read_text()
    require(h6a_status.startswith("H6-PROJECTIVE-11-ISOGENY-PASS\n"), "H6A")
    h6a = json.loads((H6A / "isogeny.json").read_text())
    require((H4 / "field_model.json").is_file(), "field_model")
    require((H4 / "norm_model.json").is_file(), "norm_model")

    tr = json.loads((HERE / "torsor_rebuild.json").read_text())
    require(tr.get("marker") == "H6-TORSOR-CLASS-PASS", "torsor marker")
    require(tr["c_translation"]["promotion_forbidden"] is True, "promotion")
    require(tr["lattice"]["det_A_aug"] == 11, "det")
    require(tr["lattice"]["sigma_on_coker"] == 9, "sigma coker")
    require(tr["lattice"]["kernel_exponents"] == KERNEL_C, "kernel c")

    S = cycle_matrix(5)
    A = poly_mat(A_COEFFS, S)
    B = poly_mat(B_COEFFS, S)
    N = poly_mat([1, 1, 1, 1, 1], S)
    require(A * B == 11 * sp.eye(5) - N, "AB identity")
    A_aug = restrict_to_aug(A)
    B_aug = restrict_to_aug(B)
    require(abs(int(A_aug.det())) == 11, "det aug")
    require(A_aug * B_aug == 11 * sp.eye(4), "Aaug Baug")

    require(
        h6a["kernel"]["coker_of_A_on_L"]["sigma_action_multiplier_k"] == 9,
        "h6a sigma",
    )
    require(h6a["kernel"]["geometric_kernel_exponents"]["c"] == KERNEL_C, "h6a c")

    rng = random.Random(424242)
    for p in (23, 67, 89, 101):
        for _ in range(8):
            r = product_one(rng, p)
            m = psi_A_mod(r, p)
            out = psi_B_mod(m, p)
            r11 = [pow(r[i], 11, p) for i in range(5)]
            require(out == r11, f"dual p={p}")

    d_exp = [0, 1, 6, -2, 2]
    Ae = [sum(int(A[i, j]) * d_exp[j] for j in range(5)) for i in range(5)]
    require(all(Ae[i] - (11 if i == 2 else 0) == 2 for i in range(5)), "Ae")
    for p in (23, 89):
        r = product_one(rng, p)
        require(monom_mod(Ae, r, p) == pow(r[2], 11, p), "c class monom")

    # geometric kernel
    p = 23
    zeta = None
    for g in range(2, p):
        z = pow(g, (p - 1) // 11, p)
        if z != 1 and pow(z, 11, p) == 1:
            zeta = z
            break
    require(zeta is not None, "zeta")
    r = product_one(rng, p)
    m = psi_A_mod(r, p)
    r_ker = [(r[i] * pow(zeta, KERNEL_C[i], p)) % p for i in range(5)]
    require(psi_A_mod(r_ker, p) == m, "kernel translate")

    e0_obs = [int(x) % 11 for x in (B_aug * sp.Matrix(4, 1, [1, 0, 0, 0]))]
    require(any(x != 0 for x in e0_obs), "e0 obs")
    require(tr["lattice"]["e0_obstruction_B_aug_mod_11"] == e0_obs, "obs match")

    # seal hashes for torsor-related files
    seal = json.loads((HERE / "SEAL.json").read_text())
    for rel in (
        "torsor_rebuild.json",
        "TORSOR_REBUILD.md",
        "INPUT_MANIFEST.json",
    ):
        require(rel in seal.get("files", {}), f"seal lists {rel}")
        require(sha256(HERE / rel) == seal["files"][rel], f"hash {rel}")

    print("H6_PUSH_TORSOR_VERIFY_OK")
    print("H6-TORSOR-CLASS-PASS")


if __name__ == "__main__":
    main()
