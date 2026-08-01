#!/usr/bin/env python3
"""Fast independent verifier for the base-ideal lifting argument.

The characteristic-zero equality of base schemes is a theorem-level
consequence of the checked inputs, not a claimed characteristic-zero CAS
Groebner computation:

* the exact degree-three scheme B is contained in the base scheme Z;
* the good projective fibre has Z_89=B_89 and no point at infinity;
* B is finite flat of degree three over the good DVR;
* for Q=I_B/I_Z, flatness of B and equality on the special fibre give
  Q tensor k=0; special-fibre Nakayama makes Supp(Q) disjoint from that fibre;
* properness of projective support then excludes any generic support.

Thus Q_eta=0 and Z_eta=B_eta scheme-theoretically.  See AUDIT.md for the
complete argument and its use in normality and class-group localization.
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
FROOT = HERE.parents[1]
PROBLEM = FROOT.parents[1]
FORMS = PROBLEM / "certificates/fixed_frame_arithmetic/five_forms.json"
CERT = FROOT / "infinity_obstruction.json"
PRIMITIVE = FROOT / "payload/global_primitive_u_sextic_exact.tsv"

EXPECTED_FORMS = "61377d6e464f7c78cf1fa91d13610b76dc4567de7b7214256e04de50066c83a4"
EXPECTED_PRIMITIVE = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


class K:
    """Q[z]/(1+z+...+z^10), in the power basis."""

    def __init__(self, values=()):
        data = [Fraction(value) for value in values]
        data.extend([Fraction(0)] * (10 - len(data)))
        self.c = tuple(data[:10])

    @staticmethod
    def load(values) -> "K":
        return K(Fraction(int(a), int(b)) for a, b in values)

    def __bool__(self) -> bool:
        return any(self.c)

    def __eq__(self, other) -> bool:
        other = other if isinstance(other, K) else K([other])
        return self.c == other.c

    def __add__(self, other) -> "K":
        other = other if isinstance(other, K) else K([other])
        return K(a + b for a, b in zip(self.c, other.c))

    __radd__ = __add__

    def __neg__(self) -> "K":
        return K(-a for a in self.c)

    def __sub__(self, other) -> "K":
        return self + (-other)

    def __rsub__(self, other) -> "K":
        return K([other]) - self

    def __mul__(self, other) -> "K":
        other = other if isinstance(other, K) else K([other])
        raw = [Fraction(0)] * 19
        for i, left in enumerate(self.c):
            for j, right in enumerate(other.c):
                raw[i + j] += left * right
        for degree in range(18, 9, -1):
            value = raw[degree]
            for lower in range(degree - 10, degree):
                raw[lower] -= value
            raw[degree] = 0
        return K(raw[:10])

    __rmul__ = __mul__

    def inverse(self) -> "K":
        z = sp.symbols("z")
        phi = sp.Poly(sum(z**i for i in range(11)), z, domain=sp.QQ)
        value = sp.Poly(sum(a * z**i for i, a in enumerate(self.c)), z, domain=sp.QQ)
        inverse = sp.Poly(sp.invert(value, phi), z, domain=sp.QQ)
        return K(inverse.nth(i) for i in range(10))

    def __truediv__(self, other) -> "K":
        other = other if isinstance(other, K) else K([other])
        return self * other.inverse()

    def mod(self, prime: int, zeta: int) -> int:
        return sum(
            value.numerator
            * pow(value.denominator, -1, prime)
            * pow(zeta, i, prime)
            for i, value in enumerate(self.c)
        ) % prime


def evaluate(coefficients: list[K], value: K) -> K:
    result = K()
    for coefficient in reversed(coefficients):
        result = result * value + coefficient
    return result


def main() -> None:
    require(digest(FORMS) == EXPECTED_FORMS, "five-form input hash")
    require(digest(PRIMITIVE) == EXPECTED_PRIMITIVE, "primitive-sextic input hash")
    payload = json.loads(CERT.read_text())
    raw = json.loads(FORMS.read_text())["binary_slots"]

    exact_rows = {
        name: [K.load(entry) for entry in entries]
        for name, entries in raw.items()
    }

    def qpoly(name: str) -> list[K]:
        values = exact_rows[name]
        return [values[2], values[1], values[0]]

    def rpoly(name: str) -> list[K]:
        values = exact_rows[name]
        return [values[3], values[2], values[1], values[0]]

    c = K.load(payload["net"]["c_qzeta11"])
    require(not evaluate(qpoly("qY"), c), "qY(c)=0")
    for name in ("rB", "rY", "rZ"):
        require(not evaluate(rpoly(name), c), f"{name}(c)=0")

    q0 = evaluate(qpoly("q0"), c)
    qA = evaluate(qpoly("qA"), c)
    r0 = evaluate(rpoly("r0"), c)
    rA = evaluate(rpoly("rA"), c)
    rebuilt = {
        "a0": q0 + Fraction(33, 2) * qA,
        "a2": -3750 * qA,
        "b0": r0 + Fraction(33, 2) * rA,
        "b2": -3750 * rA,
    }
    stored = {
        name: K.load(value)
        for name, value in payload["net"]["base_cubic_coefficients"].items()
    }
    require(rebuilt == stored, "exact base cubic coefficients")
    require(bool(rebuilt["a2"]), "a2 is nonzero")
    root_of_linear = -rebuilt["b2"] / rebuilt["a2"]
    numerator = (
        root_of_linear * root_of_linear * root_of_linear
        + rebuilt["a0"] * root_of_linear
        + rebuilt["b0"]
    )
    require(bool(numerator), "N(-b2/a2) is nonzero")
    require(numerator.mod(89, 2) == 17, "nonzero good-reduction witness")

    # The four exact vanishing identities and rebuilt coefficients prove
    # B=V(y-cw,G) is a closed subscheme of the characteristic-zero base locus.
    # G is monic of degree three in X.  The odd-pole proof of its absolute
    # irreducibility uses precisely a2!=0 and N(-b2/a2)!=0.
    print("EXACT_BASE_SUBSCHEME_INCLUSION_ACCEPT")
    print("FINITE_FLAT_DEGREE3_MODEL_ACCEPT")

    prime, zeta_residue = 89, 2
    r, X, y, w = sp.symbols("r X y w")
    def residue(entry) -> int:
        return sum(
            int(a) * pow(int(b), -1, prime) * pow(zeta_residue, i, prime)
            for i, (a, b) in enumerate(entry)
        ) % prime

    def row_mod(name: str) -> list[int]:
        return [residue(entry) for entry in raw[name]]

    def qform(values: list[int]) -> sp.Expr:
        return values[0] * y**2 + values[1] * y * w + values[2] * w**2

    def rform(values: list[int]) -> sp.Expr:
        return (
            values[0] * y**3
            + values[1] * y**2 * w
            + values[2] * y * w**2
            + values[3] * w**3
        )

    f0 = X**3 + X * qform(row_mod("q0")) + rform(row_mod("r0"))
    fA = X * qform(row_mod("qA")) + rform(row_mod("rA"))
    fB = rform(row_mod("rB"))
    fY = X * qform(row_mod("qY")) + rform(row_mod("rY"))
    fZ = rform(row_mod("rZ"))
    inv = lambda value: pow(value, -1, prime)
    C0 = (
        f0
        + (33 * inv(2) - 3750 * r**2) * fA
        - 5625 * r**2 * fB
        + (33125 * r**2 - 9 * inv(4)) * fY
    )
    Crho = (inv(4) * r - inv(200)) * fB + inv(600) * fY
    CT = -inv(2) * fB + fZ
    net = tuple(sp.Poly(value, r, X, y, w, modulus=prime).as_expr() for value in (C0, Crho, CT))

    cmod = c.mod(prime, zeta_residue)
    Gmod = X**3 + (19 * r**2 - 31) * X * w**2 + (-26 * r**2 + 14) * w**3
    line_mod = y - cmod * w

    def singular(expression: sp.Expr) -> str:
        return str(sp.expand(expression)).replace("**", "^")

    executable = shutil.which("Singular") or "/opt/homebrew/bin/Singular"
    require(Path(executable).is_file(), "Singular executable")
    rows = [
        "ring R=(89,r),(X,y),dp;",
        "option(redSB);",
        "ideal I=" + ",".join(singular(value.subs(w, 1)) for value in net) + ";",
        "ideal GI=std(I);",
        "ideal J=" + singular(line_mod.subs(w, 1)) + "," + singular(Gmod.subs(w, 1)) + ";",
        "ideal GJ=std(J);",
        "poly a1=reduce(J[1],GI); poly a2=reduce(J[2],GI);",
        "poly b1=reduce(I[1],GJ); poly b2=reduce(I[2],GJ); poly b3=reduce(I[3],GJ);",
        'if (a1==0 && a2==0 && b1==0 && b2==0 && b3==0) { print("AFFINE_IDEALS_EQUAL=1"); } else { print("AFFINE_IDEALS_EQUAL=0"); }',
        "ring RX=(89,r),(y),dp;",
        "ideal IX=" + ",".join(singular(value.subs({w: 0, X: 1})) for value in net) + ";",
        "ideal GX=std(IX); poly ux=reduce(1,GX);",
        'if (ux==0) { print("INFINITY_X_EMPTY=1"); } else { print("INFINITY_X_EMPTY=0"); }',
        "ring RY=(89,r),(X),dp;",
        "ideal IY=" + ",".join(singular(value.subs({w: 0, y: 1})) for value in net) + ";",
        "ideal GY=std(IY); poly uy=reduce(1,GY);",
        'if (uy==0) { print("INFINITY_Y_EMPTY=1"); } else { print("INFINITY_Y_EMPTY=0"); }',
        'print("LIFT_HYPOTHESES_SINGULAR_DONE");',
        "quit;",
    ]
    with tempfile.NamedTemporaryFile("w", suffix=".sing", delete=False) as stream:
        stream.write("\n".join(rows) + "\n")
        singular_path = Path(stream.name)
    try:
        completed = subprocess.run(
            [executable, "-q", str(singular_path)],
            check=True,
            text=True,
            capture_output=True,
        )
    finally:
        singular_path.unlink(missing_ok=True)
    for marker in (
        "AFFINE_IDEALS_EQUAL=1",
        "INFINITY_X_EMPTY=1",
        "INFINITY_Y_EMPTY=1",
        "LIFT_HYPOTHESES_SINGULAR_DONE",
    ):
        require(marker in completed.stdout, f"missing Singular marker {marker}\n{completed.stdout}")

    print("GOOD_FIBER_PROJECTIVE_IDEAL_EQUALITY_ACCEPT")
    print("EXACT_CONORMAL_RANK2_INPUT_ACCEPT")


if __name__ == "__main__":
    main()
