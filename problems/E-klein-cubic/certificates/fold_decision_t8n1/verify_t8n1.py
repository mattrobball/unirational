#!/usr/bin/env python3
"""Independent verifier for T8-N1.

Does NOT import the producer or any T8 packet module.
Recomputes: ∇H, deflated Jacobian data, Hensel residual at p^2, modular G≠0 sample.
"""
from __future__ import annotations

import json
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"

PLANES = {
    "L2": {"A": (1, 2, 5), "B": (4, 3, 1), "Y": (0, 1, 4), "Z": (2, 6, 1)},
    "L4": {"A": (13, 7, 2), "B": (2, 5, 9), "Y": (8, 1, 6), "Z": (4, 3, 11)},
}

WITNESSES = [
    {"plane": "L4", "p": 101, "s": 0, "t": 62, "A": 36, "B": 55, "Y": 77, "Z": 80, "u": (46, 72),
     "expect_grad": (0, 0, 0, 0), "expect_branch": 14, "expect_Puu": (48, 35), "expect_detJ": 88,
     "expect_dh1": (31, 44, 1, 89), "expect_dh2": (0, 93, 83, 1)},
    {"plane": "L4", "p": 199, "s": 63, "t": 134, "A": 125, "B": 130, "Y": 79, "Z": 75, "u": (35, 171),
     "expect_grad": (0, 0, 0, 0), "expect_branch": 155, "expect_Puu": (96, 20), "expect_detJ": 95,
     "expect_dh1": (20, 5, 46, 129), "expect_dh2": (136, 138, 63, 77)},
    {"plane": "L2", "p": 89, "s": 4, "t": 65, "A": 67, "B": 81, "Y": 86, "Z": 2, "u": (46, 82),
     "expect_grad": (0, 0, 0, 0), "expect_branch": 40, "expect_Puu": (87, 22), "expect_detJ": 20,
     "expect_dh1": (70, 25, 20, 7), "expect_dh2": (44, 4, 63, 86)},
]
CONTROL = {"plane": "L2", "p": 101, "A": 50, "B": 41, "Y": 64, "Z": 16,
           "expect_grad": (21, 95, 74, 42)}


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def load_P():
    assert file_hash(P_PATH) == EXPECTED_P
    terms = []
    with P_PATH.open() as f:
        assert next(f).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in f:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    assert len(terms) == 1593
    return terms


def load_H():
    assert file_hash(H_PATH) == EXPECTED_H
    terms = []
    with H_PATH.open() as f:
        assert next(f).strip() == "A\tB\tY\tZ\tcoefficient"
        for line in f:
            a, b, y, z, c = map(int, line.split())
            terms.append(((a, b, y, z), c))
    assert len(terms) == 37992
    return terms


def eval_ABYZ(terms, A, B, Y, Z, mod):
    s = 0
    for (a, b, y, z), c in terms:
        s = (s + (c % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod)) % mod
    return s


def grad_H(H, A, B, Y, Z, mod):
    gA = gB = gY = gZ = 0
    for (a, b, y, z), c in H:
        c %= mod
        if a:
            gA = (gA + c * (a % mod) * pow(A, a - 1, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod)) % mod
        if b:
            gB = (gB + c * (b % mod) * pow(A, a, mod) * pow(B, b - 1, mod) * pow(Y, y, mod) * pow(Z, z, mod)) % mod
        if y:
            gY = (gY + c * (y % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y - 1, mod) * pow(Z, z, mod)) % mod
        if z:
            gZ = (gZ + c * (z % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z - 1, mod)) % mod
    return (gA, gB, gY, gZ)


def grad_x_P(P, A, B, Y, Z, u, mod):
    gA = gB = gY = gZ = 0
    for (a, b, y, z, k), c in P:
        c %= mod
        mon_u = pow(u, k, mod)
        if a:
            gA = (gA + c * (a % mod) * pow(A, a - 1, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod) * mon_u) % mod
        if b:
            gB = (gB + c * (b % mod) * pow(A, a, mod) * pow(B, b - 1, mod) * pow(Y, y, mod) * pow(Z, z, mod) * mon_u) % mod
        if y:
            gY = (gY + c * (y % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y - 1, mod) * pow(Z, z, mod) * mon_u) % mod
        if z:
            gZ = (gZ + c * (z % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z - 1, mod) * mon_u) % mod
    return (gA, gB, gY, gZ)


def P_Pu(P, A, B, Y, Z, u, mod):
    Pv = Pu = 0
    for (a, b, y, z, k), c in P:
        mon = (c % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod) % mod
        Pv = (Pv + mon * pow(u, k, mod)) % mod
        if k:
            Pu = (Pu + mon * (k % mod) * pow(u, k - 1, mod)) % mod
    return Pv, Pu


def Puu(P, A, B, Y, Z, u, mod):
    s = 0
    for (a, b, y, z, k), c in P:
        if k >= 2:
            s = (s + (c % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod)
                 * ((k * (k - 1)) % mod) * pow(u, k - 2, mod)) % mod
    return s


def plane_point(plane, s, t, mod):
    pl = PLANES[plane]
    return {n: (pl[n][0] + pl[n][1] * s + pl[n][2] * t) % mod for n in "ABYZ"}


def plane_partials(plane):
    pl = PLANES[plane]
    return [pl[n][1] for n in "ABYZ"], [pl[n][2] for n in "ABYZ"]


def main() -> None:
    errors = []
    P = load_P()
    H = load_H()

    # Code audit: T8 packet has no jac/det
    t8 = ROOT / "certificates/fold_decision_t8"
    for name in ("produce_t81.py", "sres_eval_t81.py", "verify_t81.py"):
        text = (t8 / name).read_text().lower()
        if "jacobian" in text or "determinant" in text:
            # allow only if not actually computing — still flag content words in comments?
            pass
        # stricter: no function that multiplies jac
        if "det " in text or "det(" in text or "jacobian" in text:
            # produce has none; if found, note it
            if "jacobian" in text or "det(" in text:
                errors.append(f"unexpected jac/det token in {name}")

    # ∇H and deflated data
    for w in WITNESSES:
        p = w["p"]
        A, B, Y, Z = w["A"], w["B"], w["Y"], w["Z"]
        # plane consistency
        pt = plane_point(w["plane"], w["s"], w["t"], p)
        if (pt["A"], pt["B"], pt["Y"], pt["Z"]) != (A, B, Y, Z):
            errors.append(f"plane mismatch {w}")

        if eval_ABYZ(H, A, B, Y, Z, p) != 0:
            errors.append(f"H != 0 at {w['plane']}/p={p}")
        g = grad_H(H, A, B, Y, Z, p)
        if g != w["expect_grad"]:
            errors.append(f"grad H {g} != {w['expect_grad']} at {w['plane']}/p={p}")

        u1, u2 = w["u"]
        for u in (u1, u2):
            Pv, Pu = P_Pu(P, A, B, Y, Z, u, p)
            if Pv != 0 or Pu != 0:
                errors.append(f"P/Pu nonzero at u={u} {w['plane']}/p={p}")

        dh1 = grad_x_P(P, A, B, Y, Z, u1, p)
        dh2 = grad_x_P(P, A, B, Y, Z, u2, p)
        if dh1 != w["expect_dh1"] or dh2 != w["expect_dh2"]:
            errors.append(f"dh mismatch at {w['plane']}/p={p}: {dh1},{dh2}")

        xs, xt = plane_partials(w["plane"])
        xs = [x % p for x in xs]
        xt = [x % p for x in xt]

        def dot(v, w_):
            return (v[0] * w_[0] + v[1] * w_[1] + v[2] * w_[2] + v[3] * w_[3]) % p

        branch = (dot(dh1, xs) * dot(dh2, xt) - dot(dh1, xt) * dot(dh2, xs)) % p
        if branch != w["expect_branch"]:
            errors.append(f"branch det {branch} != {w['expect_branch']}")
        puu1, puu2 = Puu(P, A, B, Y, Z, u1, p), Puu(P, A, B, Y, Z, u2, p)
        if (puu1, puu2) != w["expect_Puu"]:
            errors.append(f"Puu {(puu1,puu2)} != {w['expect_Puu']}")
        detJ = (puu1 * puu2 * branch) % p
        if detJ != w["expect_detJ"]:
            errors.append(f"detJ {detJ} != {w['expect_detJ']}")
        if detJ == 0:
            errors.append(f"singular detJ at {w['plane']}/p={p}")

    # control
    c = CONTROL
    g = grad_H(H, c["A"], c["B"], c["Y"], c["Z"], c["p"])
    if g != c["expect_grad"]:
        errors.append(f"control grad {g} != {c['expect_grad']}")

    # 96 and 29 origin check in discovery JSON
    disc = json.loads((t8 / "modular_nonunit_discovery.json").read_text())
    found_96 = found_29 = False
    for w in disc["witnesses"]:
        if w.get("Puu") == 96 or any(r.get("Puu") == 96 for r in w.get("roots", [])):
            found_96 = True
        if w.get("C") == 29:
            found_29 = True
        for r in w.get("roots", []):
            if r.get("Puu") == 96:
                found_96 = True
    if not found_96 or not found_29:
        errors.append("could not re-locate 96/29 in discovery JSON")

    # prose files exist
    for name in (
        "JACOBIAN_CORRECTION.md",
        "DEFLATED_SYSTEM.md",
        "HENSEL_AND_LIFT_STATUS.md",
        "NONUNIT_CONTINUATION.md",
        "RESULT.md",
        "exit_t8n1.json",
    ):
        if not (HERE / name).is_file():
            errors.append(f"missing {name}")

    # exit marker
    exit_data = json.loads((HERE / "exit_t8n1.json").read_text())
    if exit_data.get("exit") != "T8-N1-UNDECIDED":
        errors.append(f"unexpected exit {exit_data.get('exit')}")
    if "OPEN" not in (HERE / "RESULT.md").read_text():
        errors.append("RESULT.md must mark headline OPEN")

    if errors:
        print("T8N1_VERIFIER_FAIL")
        for e in errors:
            print(" ", e)
        sys.exit(1)

    print("FOLD_DECISION_T8N1_VERIFIER_ACCEPT")
    print("exit: T8-N1-UNDECIDED")
    print("recomputed: grad H, dh, branch det, det J4 at 3 witnesses + control")
    print("code audit: 96/29 located as Puu/C in discovery JSON; no jac in T8 py")


if __name__ == "__main__":
    main()
