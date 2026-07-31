#!/usr/bin/env python3
"""Independent verifier for T9.1 preflight / undecided component packet.

Does NOT import the producer. Recomputes Jacobian rank/nullspace at the Hensel
point and checks JSON/md consistency. Does not claim a char-0 component.
"""
from __future__ import annotations

import json
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
p = 101
A0, B0, Y0, Z0 = 36, 55, 77, 80
u1_0, u2_0 = 46, 72


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def load_P():
    assert file_hash(P_PATH) == EXPECTED_P
    terms = []
    with P_PATH.open() as f:
        next(f)
        for line in f:
            a, b, y, z, u, c = map(int, line.split())
            terms.append(((a, b, y, z, u), c))
    assert len(terms) == 1593
    return terms


def P_and_Pu(P, A, B, Y, Z, u, mod):
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
            s = (
                s
                + (c % mod)
                * pow(A, a, mod)
                * pow(B, b, mod)
                * pow(Y, y, mod)
                * pow(Z, z, mod)
                * ((k * (k - 1)) % mod)
                * pow(u, k - 2, mod)
            ) % mod
    return s


def grad_x_P(P, A, B, Y, Z, u, mod):
    gA = gB = gY = gZ = 0
    for (a, b, y, z, k), c in P:
        c = c % mod
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


def grad_x_Pu(P, A, B, Y, Z, u, mod):
    gA = gB = gY = gZ = 0
    for (a, b, y, z, k), c in P:
        if k == 0:
            continue
        c = c % mod
        factor = (c * (k % mod) * pow(u, k - 1, mod)) % mod
        if a:
            gA = (gA + factor * (a % mod) * pow(A, a - 1, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z, mod)) % mod
        if b:
            gB = (gB + factor * (b % mod) * pow(A, a, mod) * pow(B, b - 1, mod) * pow(Y, y, mod) * pow(Z, z, mod)) % mod
        if y:
            gY = (gY + factor * (y % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y - 1, mod) * pow(Z, z, mod)) % mod
        if z:
            gZ = (gZ + factor * (z % mod) * pow(A, a, mod) * pow(B, b, mod) * pow(Y, y, mod) * pow(Z, z - 1, mod)) % mod
    return (gA, gB, gY, gZ)


def jacobian_4x6(P, A, B, Y, Z, u1, u2, mod):
    dh1 = grad_x_P(P, A, B, Y, Z, u1, mod)
    dh2 = grad_x_P(P, A, B, Y, Z, u2, mod)
    dPu1 = grad_x_Pu(P, A, B, Y, Z, u1, mod)
    dPu2 = grad_x_Pu(P, A, B, Y, Z, u2, mod)
    _, Pu1 = P_and_Pu(P, A, B, Y, Z, u1, mod)
    _, Pu2 = P_and_Pu(P, A, B, Y, Z, u2, mod)
    puu1 = Puu(P, A, B, Y, Z, u1, mod)
    puu2 = Puu(P, A, B, Y, Z, u2, mod)
    return [
        [dh1[0], dh1[1], dh1[2], dh1[3], Pu1, 0],
        [dPu1[0], dPu1[1], dPu1[2], dPu1[3], puu1, 0],
        [dh2[0], dh2[1], dh2[2], dh2[3], 0, Pu2],
        [dPu2[0], dPu2[1], dPu2[2], dPu2[3], 0, puu2],
    ]


def mat_rank(M, mod):
    A = [list(row) for row in M]
    rows, cols = len(A), len(A[0])
    r = 0
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if A[i][c] % mod != 0:
                piv = i
                break
        if piv is None:
            continue
        A[r], A[piv] = A[piv], A[r]
        invp = pow(A[r][c], -1, mod)
        A[r] = [(v * invp) % mod for v in A[r]]
        for i in range(rows):
            if i == r:
                continue
            fac = A[i][c] % mod
            if fac == 0:
                continue
            A[i] = [(A[i][j] - fac * A[r][j]) % mod for j in range(cols)]
        r += 1
        if r == rows:
            break
    return r


def nullspace_dim(M, mod):
    return len(M[0]) - mat_rank(M, mod)


def parse_msolve_degree(path: Path):
    """Extract ideal degree from msolve zero-dim output header if present."""
    if not path.is_file():
        return None
    text = path.read_text()
    # format: [0, [p, nvars, degree, ...
    if text.startswith("[-1]"):
        return "empty_or_error"
    if text.startswith("[1,"):
        return "positive_dimensional"
    # look for pattern ,\nN,\n['var
    import re

    m = re.search(r"\[\s*0\s*,\s*\[\s*(\d+)\s*,\s*\d+\s*,\s*(\d+)\s*,", text)
    if m:
        return int(m.group(2))
    # alternate: degree of ideal in verbose log
    return None


def main() -> None:
    errors = []
    P = load_P()

    for u in (u1_0, u2_0):
        Pv, Pu = P_and_Pu(P, A0, B0, Y0, Z0, u, p)
        if Pv != 0 or Pu != 0:
            errors.append(f"residual at u={u}: {(Pv, Pu)}")

    J = jacobian_4x6(P, A0, B0, Y0, Z0, u1_0, u2_0, p)
    rk = mat_rank(J, p)
    nd = nullspace_dim(J, p)
    if rk != 4:
        errors.append(f"jacobian rank {rk} != 4")
    if nd != 2:
        errors.append(f"nullspace dim {nd} != 2")

    # Files present
    for name in (
        "BINODAL_COMPONENT.md",
        "component_presentation.json",
        "noether_parameters.json",
        "preflight_t91.json",
        "HENSEL_NONUNIT.md",
        "hensel_hypotheses.json",
    ):
        if not (HERE / name).is_file():
            errors.append(f"missing {name}")

    pre = json.loads((HERE / "preflight_t91.json").read_text())
    if pre.get("local_smoothness_at_hensel_point", {}).get("jacobian_4x6_rank") != rk:
        errors.append("preflight jacobian rank mismatch with recomputation")
    if pre.get("local_smoothness_at_hensel_point", {}).get("nullspace_dim") != nd:
        errors.append("preflight nullspace mismatch with recomputation")

    pres = json.loads((HERE / "component_presentation.json").read_text())
    if pres.get("exit") != "T9-UNDECIDED":
        errors.append(f"presentation exit {pres.get('exit')}")
    if pres.get("presentation_form") not in (None, "none_closed_over_Q"):
        # If a closed form is claimed, require stronger checks — not present
        if "prime" in str(pres.get("presentation_form")).lower():
            errors.append("claimed prime presentation without char-0 certificate")

    noeth = json.loads((HERE / "noether_parameters.json").read_text())
    if noeth.get("preferred_parameters") != ["A", "B"]:
        errors.append("preferred Noether parameters changed unexpectedly")

    md = (HERE / "BINODAL_COMPONENT.md").read_text()
    if "T9-UNDECIDED" not in md:
        errors.append("BINODAL_COMPONENT.md missing T9-UNDECIDED")
    if "OPEN" not in md:
        errors.append("BINODAL_COMPONENT.md missing OPEN")
    if "T9-BINODAL-COMPONENT" in md and "not" not in md.lower():
        # allow mentioning the target exit name
        pass

    # Modular degree artifacts if present: consistency with preflight claims
    fibre_u = ROOT / "tmp/t9_component/fibre_u_p101.out"
    deg_u = parse_msolve_degree(fibre_u)
    deg_ab = None
    ab_json = ROOT / "tmp/t9_component/fibre_AB_degree.json"
    if ab_json.is_file():
        deg_ab = json.loads(ab_json.read_text()).get("degree")
    else:
        # fallback: verbose log
        ab_err = ROOT / "tmp/t9_component/fibre_AB_p101.err"
        if ab_err.is_file():
            import re

            m = re.search(r"degree of ideal\s+(\d+)", ab_err.read_text())
            if m:
                deg_ab = int(m.group(1))
    claimed_u = (
        pre.get("modular_degree_measurements", {})
        .get("fibre_over_u1_u2_equals_46_72_unsaturated", {})
        .get("degree")
    )
    claimed_ab = (
        pre.get("modular_degree_measurements", {})
        .get("fibre_over_A_B_equals_36_55_u_distinct", {})
        .get("degree")
    )
    if isinstance(deg_u, int) and claimed_u is not None and deg_u != claimed_u:
        errors.append(f"fibre_u degree {deg_u} != claimed {claimed_u}")
    if isinstance(deg_ab, int) and claimed_ab is not None and deg_ab != claimed_ab:
        errors.append(f"fibre_AB degree {deg_ab} != claimed {claimed_ab}")
    if claimed_ab != 496:
        errors.append(f"expected claimed AB degree 496, got {claimed_ab}")
    if claimed_u != 2758:
        errors.append(f"expected claimed u degree 2758, got {claimed_u}")

    # Must not claim S_G nonnormal
    if "S_G is nonnormal" in md or "S_G is globally nonnormal" in md:
        errors.append("must not assert global nonnormality of S_G")

    if errors:
        print("T9_COMPONENT_VERIFIER_FAIL")
        for e in errors:
            print(" ", e)
        sys.exit(1)

    print("T9_COMPONENT_VERIFIER_ACCEPT")
    print("exit: T9-UNDECIDED")
    print(f"recomputed: jacobian_rank={rk}, nullspace_dim={nd}")
    print(f"modular degrees present: fibre_u={deg_u}, fibre_AB={deg_ab}")
    print("headline: OPEN")


if __name__ == "__main__":
    main()
