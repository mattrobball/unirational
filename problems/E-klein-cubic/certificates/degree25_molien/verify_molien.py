#!/usr/bin/env python3
"""Independent verifier for P25Y-M Molien bound.

Does NOT import produce_molien.py. Recomputes the decisive invariant m_75 by a
route distinct from the producer's modular Newton/CRT pipeline:

  Route V (this file): embed the project's exact Q(ζ_11) generators S,T into C
  via ζ = exp(2πi/11), enumerate all 660 matrices by the same Cayley graph as
  exact_weil_check.py, expand 1/det(I − t g) by the eigenvalue product
  ∏_j (1 − λ_j t)^{−1} in complex floating point, average, and round to the
  nearest integer. Cross-check m_3 = 1 and m_25 = 43 (project seals), and
  check that the sealed molien_values.json reports the same m_75.

Also recomputes the special-fibre claim at p = 89 by a modular group sum that
is coded here (not imported from the producer), and checks the V_25 audit
fields for internal consistency.
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
import time
from collections import deque
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent

GROUP_ORDER = 660
DEGREE_MAX = 75
# Absolute residual bound for rounding complex Molien coefficients.
ROUND_TOL = 1e-6


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_json(obj) -> str:
    return json.dumps(obj, indent=2, sort_keys=True) + "\n"


def build_complex_group() -> list[np.ndarray]:
    """Exact project generators S,T of exact_weil_check, embedded in C."""
    zeta = np.exp(2j * np.pi / 11)
    zp = [zeta**i for i in range(11)]
    qr = {1, 3, 4, 5, 9}
    g = sum((1 if a in qr else -1) * zp[a] for a in range(1, 11))
    # g^2 = -11 in exact arithmetic; floating residual should be tiny
    assert abs(g * g + 11) < 1e-10, abs(g * g + 11)

    js = [1, 3, 2, 5, 4]
    signs = [1, 1, -1, 1, 1]
    S = np.array(
        [
            [
                (signs[k] / signs[i])
                * (zp[(9 * j * l) % 11] - zp[(-9 * j * l) % 11])
                * (-g)
                / 11
                for k, l in enumerate(js)
            ]
            for i, j in enumerate(js)
        ],
        dtype=np.complex128,
    )
    T = np.diag([zp[(js[i] * js[i]) % 11] for i in range(5)]).astype(np.complex128)
    I = np.eye(5, dtype=np.complex128)

    # Cayley graph on PSL_2(F_11), same as exact_weil_check
    def fmul(A, B):
        return tuple(
            sum(A[2 * i + k] * B[2 * k + j] for k in range(2)) % 11
            for i in range(2)
            for j in range(2)
        )

    def fcanon(A):
        A = tuple(a % 11 for a in A)
        B = tuple((-a) % 11 for a in A)
        return min(A, B)

    fone = fcanon((1, 0, 0, 1))
    fs = fcanon((0, 2, 5, 0))
    ft = fcanon((1, 2, 0, 1))
    rho = {fone: I.copy()}
    queue = deque([fone])
    while queue:
        a = queue.popleft()
        for b, R in ((fs, S), (ft, T)):
            c = fcanon(fmul(a, b))
            M = rho[a] @ R
            if c not in rho:
                rho[c] = M
                queue.append(c)
            # floating equality not asserted elementwise
    assert len(rho) == GROUP_ORDER, len(rho)
    return list(rho.values())


def series_from_eigenvalues(eigs: np.ndarray, max_deg: int) -> np.ndarray:
    """h = ∏_j sum_{k≥0} (λ_j t)^k  through degree max_deg."""
    h = np.zeros(max_deg + 1, dtype=np.complex128)
    h[0] = 1.0
    for lam in eigs:
        new = np.zeros(max_deg + 1, dtype=np.complex128)
        pw = 1.0 + 0.0j
        for k in range(max_deg + 1):
            new[k:] += h[: max_deg + 1 - k] * pw
            pw *= lam
        h = new
    return h


def complex_molien(group: list[np.ndarray], max_deg: int) -> tuple[list[int], list[float]]:
    """Return (rounded invariant dimensions, residual magnitudes)."""
    acc = np.zeros(max_deg + 1, dtype=np.complex128)
    for mat in group:
        eigs = np.linalg.eigvals(mat)
        acc += series_from_eigenvalues(eigs, max_deg)
    acc /= GROUP_ORDER
    rounded: list[int] = []
    residuals: list[float] = []
    for d in range(max_deg + 1):
        val = acc[d]
        # coefficient must be real (character average)
        r = float(val.real)
        nearest = int(round(r))
        resid = abs(val - nearest)
        assert resid < ROUND_TOL, f"degree {d}: value {val} not near-integer (resid={resid})"
        # non-negative bound
        assert 0 <= nearest <= math.comb(d + 4, 4)
        rounded.append(nearest)
        residuals.append(float(resid))
    return rounded, residuals


def modular_molien_p89(max_deg: int = 75) -> list[int]:
    """Independent modular group-sum at p=89 (special fibre).

    Reimplements Newton power-trace series; does not import the producer.
    Returns residues mod 89 of the invariant Molien coefficients.
    """
    sys.path.insert(0, str(CERT / "degree25_exact"))
    import common_p25x as C  # library only; not the producer

    recon = C.load_reconstructor()
    mod = recon.load_module(89, 78)
    group = np.asarray(mod.GROUP, dtype=np.int64)
    assert group.shape == (GROUP_ORDER, 5, 5)
    prime = 89
    inv_acc = np.zeros(max_deg + 1, dtype=np.int64)
    inv_g = pow(GROUP_ORDER, -1, prime)
    for g in group:
        g = g % prime
        # power traces
        power = np.eye(5, dtype=np.int64)
        traces = np.zeros(max_deg + 1, dtype=np.int64)
        for k in range(1, max_deg + 1):
            power = (power @ g) % prime
            traces[k] = int(np.trace(power) % prime)
        # complete homogeneous
        h = np.zeros(max_deg + 1, dtype=np.int64)
        h[0] = 1
        for n in range(1, max_deg + 1):
            acc = 0
            for k in range(1, n + 1):
                acc = (acc + int(traces[k]) * int(h[n - k])) % prime
            h[n] = (acc * pow(n, -1, prime)) % prime
        inv_acc = (inv_acc + h) % prime
    inv = (inv_acc * inv_g) % prime
    return [int(x) for x in inv]


def main() -> None:
    t0 = time.time()
    values_path = HERE / "molien_values.json"
    assert values_path.is_file(), f"missing {values_path}"
    sealed = json.loads(values_path.read_text())

    # Self-hash check
    body = {k: v for k, v in sealed.items() if k != "self_sha256"}
    text = canonical_json(body)
    digest = hashlib.sha256(text.encode()).hexdigest()
    assert digest == sealed["self_sha256"], "self_sha256 mismatch"

    print("building complex group from exact project generators...", flush=True)
    group = build_complex_group()
    print(f"  |G|={len(group)}; expanding Molien series to degree {DEGREE_MAX}...", flush=True)
    inv, residuals = complex_molien(group, DEGREE_MAX)

    m3, m25, m43, m75 = inv[3], inv[25], inv[43], inv[75]
    print(f"  complex route: m_3={m3}, m_25={m25}, m_43={m43}, m_75={m75}")
    print(f"  max residual={max(residuals):.2e}")

    assert m3 == 1, m3
    assert m25 == 43, m25
    assert m43 == 289, m43
    assert m75 == 2343, m75

    # Sealed values must match the recomputed decisive invariant
    assert sealed["invariants"]["m_3"] == m3
    assert sealed["invariants"]["m_25"] == m25
    assert sealed["invariants"]["m_43"] == m43
    assert sealed["invariants"]["m_75"] == m75
    assert sealed["P25Y_FULL_ROWSPACE_746"] == "NOT_SEALED"
    assert m75 != 746

    # Special fibre recomputation
    print("special fibre Molien sum at p=89...", flush=True)
    inv89 = modular_molien_p89(DEGREE_MAX)
    assert inv89[3] == m3 % 89
    assert inv89[25] == m25 % 89
    assert inv89[75] == m75 % 89
    assert sealed["special_fibre_p89"]["m_75"] == m75
    assert sealed["special_fibre_p89"]["check_m75_mod"] is True
    assert inv89[75] == sealed["special_fibre_p89"]["m_75_mod_89"]

    # V_25 audit consistency
    v25 = sealed["v25_invariants_vs_covariants"]
    assert v25["same_object"] is False
    assert v25["m_25_invariants"] == 43
    assert v25["c_25_self_covariants"] == 189
    assert v25["project_M_25"] == 189
    assert v25["project_V_25"] == 43
    assert v25["identification"] == "equal_dimension_only"
    assert sealed["self_covariants"]["c_25"] == 189
    assert sealed["self_covariants"]["matches_project_M_25"] is True

    # Bound justification present
    assert "rank(row space)" in sealed["row_rank_bound"]["rank_bound"]
    assert sealed["row_rank_bound"]["seal"]["P25Y-FULL-ROWSPACE-746"] == "NOT_SEALED"

    # Dual note
    assert "Galois" in sealed["representation"]["note"]["statement"]

    elapsed = time.time() - t0
    print("PASS verify_molien")
    print(f"  m_75={m75} confirms 2343; seal does not fire")
    print(f"  special fibre m_75 ≡ {inv89[75]} (mod 89) = 2343 mod 89")
    print(f"  V_25 vs invariants: equal dimension only (c_25=M_25=189)")
    print(f"  elapsed_s={elapsed:.2f}")


if __name__ == "__main__":
    main()
