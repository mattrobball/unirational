#!/usr/bin/env python3
"""Independent H6.1 torsor verifier (producer-independent)."""
from __future__ import annotations

import hashlib
import json
import random
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H6A = ROOT / "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY"
H4 = ROOT / "goal_runs_after_35fa/H_11_5_TWIST"

A_COEFFS = [2, 1, 0, 0, 0]
B_COEFFS = [5, -3, 1, -1, 0]
KERNEL_C = [5, 3, 4, 9, 1]


def fail(msg: str) -> None:
    print(f"H6_TORSOR_VERIFY_FAIL: {msg}", file=sys.stderr)
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


def main() -> None:
    for name in (
        "INPUT_MANIFEST.json",
        "torsor_class.json",
        "TRACE_HYPERPLANE_TORSOR.md",
        "BOUNDARY_AUDIT.md",
        "STATUS.md",
        "SEAL.json",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    status = (HERE / "STATUS.md").read_text()
    require(status.startswith("H6-TORSOR-CLASS-PASS\n"), "STATUS exit")
    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("exit") == "H6-TORSOR-CLASS-PASS", "SEAL exit")
    require(seal.get("headline") == "OPEN", "headline")

    # H6A sealed
    require(
        (H6A / "STATUS.md").read_text().startswith("H6-PROJECTIVE-11-ISOGENY-PASS\n"),
        "H6A exit",
    )
    require((H4 / "STATUS.md").read_text().startswith("H-11_5-NORM-MODEL-PASS\n"), "H4")

    man = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    require(man.get("h6a_exit") == "H6-PROJECTIVE-11-ISOGENY-PASS", "manifest h6a")
    require(man.get("h4_exit") == "H-11_5-NORM-MODEL-PASS", "manifest h4")
    for item in man["inputs"]:
        if not item.get("required"):
            continue
        path = ROOT / item["path"]
        require(path.is_file(), f"missing input {item['path']}")
        require(item.get("sha256"), f"no hash {item['path']}")
        require(sha256(path) == item["sha256"], f"hash drift {item['path']}")

    # Load H4 models
    fm = json.loads((H4 / "field_model.json").read_text())
    nm = json.loads((H4 / "norm_model.json").read_text())
    require(fm.get("format") == "H-11_5-INVARIANT-FIELD-v1", "field format")
    require(nm.get("format") == "H-11_5-NORM-TOWER-v1", "norm format")

    # Load H6A isogeny
    h6a = json.loads((H6A / "isogeny.json").read_text())
    require(h6a.get("schema") == "h6a-projective-11-isogeny-v1", "h6a schema")
    require(abs(h6a["augmentation_restriction"]["det_A_aug"]) == 11, "det11")
    require(
        h6a["kernel"]["coker_of_A_on_L"]["sigma_action_multiplier_k"] == 9,
        "k=9",
    )

    data = json.loads((HERE / "torsor_class.json").read_text())
    require(data.get("schema") == "h6-trace-hyperplane-11-torsor-v1", "torsor schema")
    require(data.get("marker") == "H6-TORSOR-CLASS-PASS", "marker")
    require(data["c_translation"]["promotion_forbidden"] is True, "no promotion")
    require(data["trace_hyperplane"]["not_a_subtorus"] is True, "not subtorus")
    require("Y(K)" in data["Y_K_equivalence"]["open_torus"]
            or "Y(K)" in str(data["Y_K_equivalence"]), "Y(K) equiv")

    # Rebuild group-ring / dual
    S = cycle_matrix(5)
    A = poly_mat(A_COEFFS, S)
    B = poly_mat(B_COEFFS, S)
    N = poly_mat([1, 1, 1, 1, 1], S)
    require(A * B == 11 * sp.eye(5) - N, "AB identity")
    A_aug = restrict_to_aug(A)
    B_aug = restrict_to_aug(B)
    require(abs(int(A_aug.det())) == 11, "det A_aug")
    require(A_aug * B_aug == 11 * sp.eye(4), "A_aug B_aug = 11I")

    # Dual composition modular
    rng = random.Random(7)
    for p in (23, 67, 89, 101):
        for _ in range(12):
            r = [rng.randrange(1, p) for _ in range(4)]
            r.append(pow(r[0] * r[1] * r[2] * r[3] % p, -1, p))
            m = psi_A_mod(r, p)
            out = psi_B_mod(m, p)
            r11 = [pow(ri, 11, p) for ri in r]
            require(out == r11, f"psi_B o psi_A at p={p}")

    # Order-11 witness exponents
    d_exp = [0, 1, 6, -2, 2]
    Ae = [sum(int(A[i, j]) * d_exp[j] for j in range(5)) for i in range(5)]
    require(all(Ae[i] - (11 if i == 2 else 0) == 2 for i in range(5)), "Ae = 11 e2 + 2")
    for p in (23, 67, 89):
        r = [rng.randrange(1, p) for _ in range(4)]
        r.append(pow(r[0] * r[1] * r[2] * r[3] % p, -1, p))
        require(monom_mod(Ae, r, p) == pow(r[2], 11, p), "psi(d)=r2^11 monom")

    # Kernel geometric action
    require(sum(KERNEL_C) % 11 == 0, "sum c")
    require(
        all(
            sum(int(A[i, j]) * KERNEL_C[j] for j in range(5)) % 11 == 0
            for i in range(5)
        ),
        "A c = 0 mod 11",
    )
    for p in (23, 67):
        if (p - 1) % 11 != 0:
            continue
        zeta = None
        for g in range(2, p):
            z = pow(g, (p - 1) // 11, p)
            if z != 1 and pow(z, 11, p) == 1:
                zeta = z
                break
        require(zeta is not None, "zeta")
        r = [rng.randrange(1, p) for _ in range(4)]
        r.append(pow(r[0] * r[1] * r[2] * r[3] % p, -1, p))
        m = psi_A_mod(r, p)
        r_ker = [(r[i] * pow(zeta, KERNEL_C[i], p)) % p for i in range(5)]
        require(psi_A_mod(r_ker, p) == m, "kernel translate")

    # Stored dual formula matches
    dual = data["kummer_resolvent_invariant"]["dual_multiplicative"]
    require("m_i^5" in dual and "m_{i-1}^{-3}" in dual, "dual formula string")
    require(
        data["fibre_product"]["galois_module"]["C5_action_multiplier"] == 9,
        "C5 *9",
    )
    require(
        data["consumed_h6a"]["exit"] == "H6-PROJECTIVE-11-ISOGENY-PASS",
        "consumed exit",
    )

    # Boundary audit present
    ba = (HERE / "BOUNDARY_AUDIT.md").read_text()
    require("common open" in ba.lower() or "common_open" in ba or "H4" in ba, "boundary")
    require("not" in ba.lower() and "pointless" in ba.lower(), "honesty")

    print("H6_TORSOR_VERIFY_OK")


if __name__ == "__main__":
    main()
