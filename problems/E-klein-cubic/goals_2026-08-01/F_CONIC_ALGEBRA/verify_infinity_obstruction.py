#!/usr/bin/env python3
"""Independent verifier for the Goal F infinity-valuation obstruction.

This verifier does not import the producer or any of its arithmetic helpers.
It rebuilds the leading coefficient from the sealed sextic, checks the
normalization formulas, replays the cyclotomic base-scheme identities, and
asks Singular to recompute the good-reduction ideal equality and a smooth
member of the normalized net.
"""

from __future__ import annotations

from fractions import Fraction
from hashlib import sha256
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PRIMITIVE = HERE / "payload/global_primitive_u_sextic_exact.tsv"
FORMS = PROBLEM / "certificates/fixed_frame_arithmetic/five_forms.json"
CERT = HERE / "infinity_obstruction.json"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_FORMS = "61377d6e464f7c78cf1fa91d13610b76dc4567de7b7214256e04de50066c83a4"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


class K:
    """Q[z]/Phi_11 in the power basis, implemented independently."""

    def __init__(self, values=()):
        data = [Fraction(value) for value in values]
        data += [Fraction(0)] * (10 - len(data))
        self.c = tuple(data[:10])

    @staticmethod
    def load(values) -> "K":
        return K(Fraction(int(a), int(b)) for a, b in values)

    def __bool__(self):
        return any(self.c)

    def __eq__(self, other):
        other = other if isinstance(other, K) else K([other])
        return self.c == other.c

    def __add__(self, other):
        other = other if isinstance(other, K) else K([other])
        return K(a + b for a, b in zip(self.c, other.c))

    __radd__ = __add__

    def __neg__(self):
        return K(-a for a in self.c)

    def __sub__(self, other):
        return self + (-other)

    def __rsub__(self, other):
        return K([other]) - self

    def __mul__(self, other):
        other = other if isinstance(other, K) else K([other])
        raw = [Fraction(0)] * 19
        for i, a in enumerate(self.c):
            for j, b in enumerate(other.c):
                raw[i + j] += a * b
        for degree in range(18, 9, -1):
            value = raw[degree]
            for lower in range(degree - 10, degree):
                raw[lower] -= value
            raw[degree] = 0
        return K(raw[:10])

    __rmul__ = __mul__

    def inverse(self):
        z = sp.symbols("z")
        phi = sp.Poly(sum(z**i for i in range(11)), z, domain=sp.QQ)
        value = sp.Poly(sum(a * z**i for i, a in enumerate(self.c)), z, domain=sp.QQ)
        inverse = sp.Poly(sp.invert(value, phi), z, domain=sp.QQ)
        return K(inverse.nth(i) for i in range(10))

    def __truediv__(self, other):
        other = other if isinstance(other, K) else K([other])
        return self * other.inverse()

    def mod(self, prime: int, zeta: int) -> int:
        return sum(
            a.numerator * pow(a.denominator, -1, prime) * pow(zeta, i, prime)
            for i, a in enumerate(self.c)
        ) % prime


def evaluate(coefficients: list[K], value: K) -> K:
    answer = K()
    for coefficient in reversed(coefficients):
        answer = answer * value + coefficient
    return answer


def load_exact_forms() -> dict[str, list[K]]:
    raw = json.loads(FORMS.read_text())["binary_slots"]
    return {
        name: [K(Fraction(int(a), int(b)) for a, b in entry) for entry in entries]
        for name, entries in raw.items()
    }


def qpoly(row: list[K]) -> list[K]:
    return [row[2], row[1], row[0]]


def rpoly(row: list[K]) -> list[K]:
    return [row[3], row[2], row[1], row[0]]


def rebuild_sextic_coefficients() -> dict[int, sp.Expr]:
    A, B, Y, Z = sp.symbols("A B Y Z")
    result = {i: 0 for i in range(7)}
    with PRIMITIVE.open() as stream:
        require(next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient", "primitive header")
        for line in stream:
            a, b, yy, zz, uu, coefficient = map(int, line.split())
            result[uu] += coefficient * A**a * B**b * Y**yy * Z**zz
    return result


def modular_forms(prime: int, zeta: int):
    raw = json.loads(FORMS.read_text())["binary_slots"]
    r, X, y, w = sp.symbols("r X y w")

    def row(name):
        values = []
        for entry in raw[name]:
            values.append(
                sum(
                    int(a) * pow(int(b), -1, prime) * pow(zeta, i, prime)
                    for i, (a, b) in enumerate(entry)
                )
                % prime
            )
        return values

    def q(values):
        return values[0] * y**2 + values[1] * y * w + values[2] * w**2

    def cubic(values):
        return values[0] * y**3 + values[1] * y**2 * w + values[2] * y * w**2 + values[3] * w**3

    f0 = X**3 + X * q(row("q0")) + cubic(row("r0"))
    fA = X * q(row("qA")) + cubic(row("rA"))
    fB = cubic(row("rB"))
    fY = X * q(row("qY")) + cubic(row("rY"))
    fT = cubic(row("rZ"))
    A0 = -3 * pow(2, -1, prime) * (2500 * r**2 - 11)
    B0 = -5625 * r**2
    Y0 = 33125 * r**2 - 9 * pow(4, -1, prime)
    values = (
        f0 + A0 * fA + B0 * fB + Y0 * fY,
        (pow(4, -1, prime) * r - pow(200, -1, prime)) * fB + pow(600, -1, prime) * fY,
        -pow(2, -1, prime) * fB + fT,
    )
    return (r, X, y, w), tuple(sp.Poly(value, r, X, y, w, modulus=prime).as_expr() for value in values)


def sing(expression) -> str:
    return str(sp.expand(expression)).replace("**", "^")


def run_singular(net) -> str:
    executable = shutil.which("Singular") or "/opt/homebrew/bin/Singular"
    require(Path(executable).is_file(), "Singular executable")
    r, X, y, w = sp.symbols("r X y w")
    C0, Crho, CT = net
    Gbase = X**3 + (19 * r**2 - 31) * X + (-26 * r**2 + 14)
    rows = [
        "ring R=(89,r),(X,y),dp;",
        "ideal I=" + ",".join(sing(value.subs({w: 1})) for value in net) + ";",
        "ideal GI=std(I);",
        "poly n1=reduce(y-2,GI);",
        f"poly n2=reduce({sing(Gbase)},GI);",
        'if (n1==0 && n2==0) { print("BASE_REVERSE_INCLUSION=1"); } else { print("BASE_REVERSE_INCLUSION=0"); }',
        f"ideal J=y-2,{sing(Gbase)};",
        "ideal GJ=std(J);",
        "poly m1=reduce(I[1],GJ); poly m2=reduce(I[2],GJ); poly m3=reduce(I[3],GJ);",
        'if (m1==0 && m2==0 && m3==0) { print("BASE_FORWARD_INCLUSION=1"); } else { print("BASE_FORWARD_INCLUSION=0"); }',
        "ring RX=(89,r),(y),dp;",
        "ideal IX=" + ",".join(sing(value.subs({w: 0, X: 1})) for value in net) + ";",
        "ideal GX=std(IX); poly ux=reduce(1,GX);",
        'if (ux==0) { print("BASE_INFINITY_X_UNIT=1"); } else { print("BASE_INFINITY_X_UNIT=0"); }',
        "ring RY=(89,r),(X),dp;",
        "ideal IY=" + ",".join(sing(value.subs({w: 0, y: 1})) for value in net) + ";",
        "ideal GY=std(IY); poly uy=reduce(1,GY);",
        'if (uy==0) { print("BASE_INFINITY_Y_UNIT=1"); } else { print("BASE_INFINITY_Y_UNIT=0"); }',
    ]
    smooth = C0.subs({r: 1})
    for chart in (X, y, w):
        variables = [variable for variable in (X, y, w) if variable != chart]
        name = "S" + str(chart)
        rows.extend(
            [
                f"ring R{name}=89,({','.join(map(str, variables))}),dp;",
                f"ideal I{name}=" + ",".join(sing(sp.diff(smooth, variable).subs({chart: 1})) for variable in (X, y, w)) + ";",
                f"ideal G{name}=std(I{name}); poly u{name}=reduce(1,G{name});",
                f'if (u{name}==0) {{ print("SMOOTH_{chart}=1"); }} else {{ print("SMOOTH_{chart}=0"); }}',
            ]
        )
    rows += ['print("INFINITY_OBSTRUCTION_MODULAR_REPLAY_DONE");', "quit;"]
    with tempfile.NamedTemporaryFile("w", suffix=".sing", delete=False) as stream:
        stream.write("\n".join(rows) + "\n")
        path = Path(stream.name)
    try:
        completed = subprocess.run([executable, "-q", str(path)], check=True, text=True, capture_output=True)
    finally:
        path.unlink(missing_ok=True)
    return completed.stdout


def main() -> None:
    require(digest(PRIMITIVE) == EXPECTED_P, "primitive hash")
    require(digest(FORMS) == EXPECTED_FORMS, "five-forms hash")
    data = json.loads(CERT.read_text())
    require(data["primitive_sha256"] == EXPECTED_P, "certificate primitive binding")
    require(data["forms_sha256"] == EXPECTED_FORMS, "certificate forms binding")

    A, B, Y, Z, T, r, rho = sp.symbols("A B Y Z T r rho")
    coeffs = rebuild_sextic_coefficients()
    D = sum(
        coefficient * A**a * B**b * Y**yy * T**tt
        for a, b, yy, tt, coefficient in data["leading_coefficient"]["D_sparse"]
    )
    constant = int(data["leading_coefficient"]["factorization"].split("=")[1].split("*")[0])
    shifted_c6 = sp.expand(coeffs[6].subs({Z: T + sp.Rational(11, 18) * A**2}))
    require(sp.expand(shifted_c6 - constant * B**2 * (A - 15) * D) == 0, "leading factor identity")

    Aparam = sp.Rational(33, 2) - 3750 * r**2
    Yparam = 33125 * r**2 - sp.Rational(9, 4) + rho / 600
    Bparam = -5625 * r**2 - T / 2 + (r / 4 - sp.Rational(1, 200)) * rho
    require(sp.expand(D.subs({A: Aparam, B: Bparam, Y: Yparam})) == 0, "D parameterization")
    p = 100 * A + 4 * B + 2 * T + 12 * Y - 1623
    q = 212 * B + 106 * T + 36 * Y + 81
    require(sp.factor(p.subs({A: Aparam, B: Bparam, Y: Yparam})) == rho * r, "inverse p")
    require(sp.factor(q.subs({A: Aparam, B: Bparam, Y: Yparam})) == rho * (53 * r - 1), "inverse q")
    require(sp.factor((53 * p - q).subs({A: Aparam, B: Bparam, Y: Yparam})) == rho, "inverse rho")

    witness = data["leading_coefficient"]["c5_nondivisibility_witness"]
    substitutions = {A: sp.Rational(witness["A"]), B: sp.Rational(witness["B"]), Y: sp.Rational(witness["Y"]), Z: sp.Rational(witness["Z"])}
    require(sp.factor(coeffs[5].subs(substitutions)) == sp.Rational(witness["c5"]), "c5 witness")
    require(sp.Rational(witness["c5"]) != 0, "c5 nonzero")

    forms = load_exact_forms()
    c = K.load(data["net"]["c_qzeta11"])
    require(not evaluate(qpoly(forms["qY"]), c), "qY(c)")
    for name in ("rB", "rY", "rZ"):
        require(not evaluate(rpoly(forms[name]), c), f"{name}(c)")
    q0 = evaluate(qpoly(forms["q0"]), c)
    qA = evaluate(qpoly(forms["qA"]), c)
    r0 = evaluate(rpoly(forms["r0"]), c)
    rA = evaluate(rpoly(forms["rA"]), c)
    rebuilt = {
        "a0": q0 + Fraction(33, 2) * qA,
        "a2": -3750 * qA,
        "b0": r0 + Fraction(33, 2) * rA,
        "b2": -3750 * rA,
    }
    for name, value in rebuilt.items():
        require(value == K.load(data["net"]["base_cubic_coefficients"][name]), f"base cubic {name}")
    linear_root = -rebuilt["b2"] / rebuilt["a2"]
    numerator = linear_root * linear_root * linear_root + rebuilt["a0"] * linear_root + rebuilt["b0"]
    require(numerator, "geometric irreducibility simple pole")
    require(c.mod(89, 2) == 2 and numerator.mod(89, 2) == 17, "good reduction values")

    _, net = modular_forms(89, 2)
    output = run_singular(net)
    for marker in (
        "BASE_REVERSE_INCLUSION=1",
        "BASE_FORWARD_INCLUSION=1",
        "BASE_INFINITY_X_UNIT=1",
        "BASE_INFINITY_Y_UNIT=1",
        "SMOOTH_X=1",
        "SMOOTH_y=1",
        "SMOOTH_w=1",
        "INFINITY_OBSTRUCTION_MODULAR_REPLAY_DONE",
    ):
        require(marker in output, f"Singular marker {marker}\n{output}")

    require(data["class_group"]["generic_degrees"] == [3, 0, 3], "degree generators")
    require(data["class_group"]["index"] == 3, "residue index")
    require(data["valuation"]["ramification_index"] == 1, "e=1")
    require(data["valuation"]["residue_degree"] == 1, "f=1")
    require(data["exit"] == "F-CONIC-CRITERION-EMPTY", "exit")
    print("GOAL_F_INFINITY_EXACT_IDENTITIES_ACCEPT")
    print("GOAL_F_INFINITY_MODULAR_LIFT_ACCEPT")
    print("GOAL_F_CONIC_CRITERION_EMPTY_ACCEPT")


if __name__ == "__main__":
    main()
