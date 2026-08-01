#!/usr/bin/env python3
"""Standalone replay for the bounded 11:5 Klein-covariant certificate.

This verifier deliberately does not import any file from the packet.  It
reconstructs the formal generators T and P, the Klein cubic F, every complete
covariant matrix M(d,k) for 1 <= d <= 5 and k in Z/5, and the landing
equations over Z[t]/(t^4+t^3+t^2+t+1).  It then specializes t to 64 in F_331,
compares the resulting Singular programs byte-for-byte with the packet, and
reruns Singular on the independently generated files.

The certificate is bounded: it excludes only homogeneous projective
11:5-covariants of degrees 1 through 5.  It proves neither an all-degree
statement nor pointlessness of any generic twist.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile
from typing import Iterable


PRIME = 331
ROOT5 = 64
ROOT11 = 74
WEIGHTS = (1, 9, 4, 3, 5)
DEGREES = range(1, 6)
CHARACTERS = range(5)
EXPECTED_COVARIANT_DIMS = {1: 1, 2: 1, 3: 3, 4: 7, 5: 11}
EXPECTED_VDIMS = {
    (d, k): (
        3 if d in (1, 2)
        else 10 if d == 3
        else 96 if d == 4
        else 541 if k == 0
        else 553
    )
    for d in DEGREES
    for k in CHARACTERS
}

# An element of Z[t]/Phi_5 is stored in the basis 1,t,t^2,t^3.
Cyclo = tuple[int, int, int, int]
ZERO: Cyclo = (0, 0, 0, 0)
ONE: Cyclo = (1, 0, 0, 0)
T_POWERS: tuple[Cyclo, ...] = (
    ONE,
    (0, 1, 0, 0),
    (0, 0, 1, 0),
    (0, 0, 0, 1),
    (-1, -1, -1, -1),
)

Exponent = tuple[int, int, int, int, int]
CoeffMonomial = tuple[int, int, int]
CycloPolynomial = dict[CoeffMonomial, Cyclo]
LandingSystem = dict[Exponent, CycloPolynomial]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cadd(a: Cyclo, b: Cyclo) -> Cyclo:
    return tuple(x + y for x, y in zip(a, b))  # type: ignore[return-value]


def cmul(a: Cyclo, b: Cyclo) -> Cyclo:
    out = ZERO
    for i, ai in enumerate(a):
        for j, bj in enumerate(b):
            if ai and bj:
                term = tuple(ai * bj * x for x in T_POWERS[(i + j) % 5])
                out = cadd(out, term)  # type: ignore[arg-type]
    return out


def tpower(n: int) -> Cyclo:
    return T_POWERS[n % 5]


def ceval(a: Cyclo, root: int = ROOT5, prime: int = PRIME) -> int:
    return sum(value * pow(root, i, prime) for i, value in enumerate(a)) % prime


def compositions(total: int, length: int) -> Iterable[tuple[int, ...]]:
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, length - 1):
            yield (first,) + rest


def add_exp(*values: Exponent) -> Exponent:
    return tuple(sum(v[i] for v in values) for i in range(5))  # type: ignore[return-value]


def shift_exp(e: Exponent, amount: int) -> Exponent:
    """The exponent vector after replacing x_j by x_(j+amount)."""
    out = [0] * 5
    for j, value in enumerate(e):
        out[(j + amount) % 5] = value
    return tuple(out)  # type: ignore[return-value]


def tweight(e: Exponent) -> int:
    return sum(a * w for a, w in zip(e, WEIGHTS)) % 11


def matrix_multiply(a: list[list[int]], b: list[list[int]]) -> list[list[int]]:
    return [
        [sum(a[i][r] * b[r][j] for r in range(len(b))) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def matrix_power(a: list[list[int]], n: int) -> list[list[int]]:
    out = [[int(i == j) for j in range(len(a))] for i in range(len(a))]
    while n:
        if n & 1:
            out = matrix_multiply(out, a)
        a = matrix_multiply(a, a)
        n //= 2
    return out


def matrix_multiply_mod(a: list[list[int]], b: list[list[int]], prime: int) -> list[list[int]]:
    return [
        [sum(a[i][r] * b[r][j] for r in range(len(b))) % prime
         for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def matrix_power_mod(a: list[list[int]], n: int, prime: int) -> list[list[int]]:
    out = [[int(i == j) for j in range(len(a))] for i in range(len(a))]
    while n:
        if n & 1:
            out = matrix_multiply_mod(out, a, prime)
        a = matrix_multiply_mod(a, a, prime)
        n //= 2
    return out


def verify_t_p_f() -> None:
    """Reconstruct the formal 11:5 representation and invariant cubic."""
    # T is diag(zeta_11^WEIGHTS[i]).  P(e_j)=e_(j+1).
    p_matrix = [[int(i == (j + 1) % 5) for j in range(5)] for i in range(5)]
    identity = [[int(i == j) for j in range(5)] for i in range(5)]
    assert matrix_power(p_matrix, 5) == identity

    # P T P^-1 = T^5 is checked at the level of diagonal exponents.
    conjugated_weights = tuple(WEIGHTS[(i - 1) % 5] for i in range(5))
    assert conjugated_weights == tuple(5 * w % 11 for w in WEIGHTS)
    assert len(set(WEIGHTS)) == 5 and all(w % 11 for w in WEIGHTS)

    # Reconstruct the same matrices in the split good fibre.  This also
    # checks that the formal presentation has exactly 55 elements there.
    assert pow(ROOT11, 11, PRIME) == 1 and ROOT11 != 1
    t_matrix = [
        [pow(ROOT11, WEIGHTS[i], PRIME) if i == j else 0 for j in range(5)]
        for i in range(5)
    ]
    p_inverse = matrix_power_mod(p_matrix, 4, PRIME)
    conjugated = matrix_multiply_mod(
        matrix_multiply_mod(p_matrix, t_matrix, PRIME), p_inverse, PRIME
    )
    assert matrix_power_mod(t_matrix, 11, PRIME) == identity
    assert matrix_power_mod(p_matrix, 5, PRIME) == identity
    assert conjugated == matrix_power_mod(t_matrix, 5, PRIME)
    group = {
        tuple(value for row in matrix_multiply_mod(
            matrix_power_mod(t_matrix, a, PRIME),
            matrix_power_mod(p_matrix, b, PRIME),
            PRIME,
        ) for value in row)
        for a in range(11)
        for b in range(5)
    }
    assert len(group) == 55

    # In the abelianization the conjugacy relation gives T=T^5.  Together
    # with T^11=1 this kills T, leaving precisely the five P-characters.
    assert 3 * 4 - 11 == 1  # gcd(4,11)=1 certificate

    # F=sum_i x_i^2*x_(i+1) is T- and P-invariant, and is the unique
    # C5-invariant line in the T-invariant cubics.
    f_terms = {
        shift_exp((2, 1, 0, 0, 0), i)
        for i in range(5)
    }
    t_invariant_cubics = {
        e for e in compositions(3, 5) if tweight(e) == 0
    }
    assert t_invariant_cubics == f_terms
    assert all(2 * WEIGHTS[i] + WEIGHTS[(i + 1) % 5] == 0
               or (2 * WEIGHTS[i] + WEIGHTS[(i + 1) % 5]) % 11 == 0
               for i in range(5))
    assert {shift_exp(e, 1) for e in f_terms} == f_terms


def basis_for_degree(degree: int) -> tuple[Exponent, ...]:
    # The first target coordinate has T-weight one.
    return tuple(
        e  # type: ignore[misc]
        for e in compositions(degree, 5)
        if tweight(e) == WEIGHTS[0]
    )


def covariant_matrix(degree: int, character: int):
    """Return M(d,k) as five rows of (c-index, x-exponent, coefficient).

    If the first coordinate is sum_a c_a*x^e_a, the i-th coordinate is
    t^(k*i) sum_a c_a*x^shift_i(e_a).  Thus q(Px)=t^k Pq(x), while
    q(Tx)=Tq(x).  This is the complete homogeneous projective-character
    covariant space because T fixes the first row's weight and P determines
    the other four rows.
    """
    basis = basis_for_degree(degree)
    rows = tuple(
        tuple((a, shift_exp(e, i), tpower(character * i))
              for a, e in enumerate(basis))
        for i in range(5)
    )
    assert len(basis) == EXPECTED_COVARIANT_DIMS[degree]

    # T covariance of each target coordinate.
    for i, row in enumerate(rows):
        assert all(tweight(e) == WEIGHTS[i] for _, e, _ in row)

    # P covariance: pulling row i back by P changes shift_i to shift_(i-1),
    # and its coefficient is t^k times the coefficient in row i-1.
    for i, row in enumerate(rows):
        previous = rows[(i - 1) % 5]
        for (a, e, scalar), (b, old_e, old_scalar) in zip(row, previous):
            assert a == b
            assert shift_exp(e, -1) == old_e
            assert scalar == cmul(tpower(character), old_scalar)
    return basis, rows


def landing_system(degree: int, character: int) -> tuple[tuple[Exponent, ...], LandingSystem]:
    """Expand F(M(d,k)c) over Z[t]/Phi_5 without a producer import."""
    basis, rows = covariant_matrix(degree, character)
    equations: LandingSystem = {}
    for i in range(5):
        for a, ea, ca in rows[i]:
            for b, eb, cb in rows[i]:
                for c, ec, cc in rows[(i + 1) % 5]:
                    source = add_exp(ea, eb, ec)
                    coefficient_monomial = tuple(sorted((a, b, c)))
                    poly = equations.setdefault(source, {})
                    scalar = cmul(cmul(ca, cb), cc)
                    poly[coefficient_monomial] = cadd(
                        poly.get(coefficient_monomial, ZERO), scalar
                    )
    equations = {
        source: {term: value for term, value in poly.items() if value != ZERO}
        for source, poly in equations.items()
    }
    equations = {source: poly for source, poly in equations.items() if poly}
    return basis, equations


def specialize(system: LandingSystem) -> dict[Exponent, dict[CoeffMonomial, int]]:
    out = {}
    for source, poly in system.items():
        reduced = {term: ceval(value) for term, value in poly.items()}
        reduced = {term: value for term, value in reduced.items() if value}
        if reduced:
            out[source] = reduced
    return out


def singular_polynomial(poly: dict[CoeffMonomial, int]) -> str:
    terms = []
    for indices, value in sorted(poly.items()):
        monomial = "*".join(f"c{i}" for i in indices)
        terms.append(f"{value}*{monomial}")
    return "+".join(terms) or "0"


def singular_text(basis: tuple[Exponent, ...], equations) -> str:
    variables = ",".join(f"c{i}" for i in range(len(basis)))
    entries = [singular_polynomial(poly) for poly in equations.values()] or ["0"]
    return (
        f"ring r={PRIME},({variables}),dp;\n"
        f"ideal I={','.join(entries)};\n"
        "option(redSB);\n"
        "ideal G=std(I);\n"
        'print("BASIS_SIZE="+string(size(G)));\n'
        'print("DIM="+string(dim(G)));\n'
        'print("VDIM="+string(vdim(G)));\n'
        "quit;\n"
    )


def parse_singular(output: str) -> dict[str, int]:
    parsed = {}
    for key in ("BASIS_SIZE", "DIM", "VDIM"):
        match = re.search(rf"^{key}=(-?\d+)$", output, re.MULTILINE)
        assert match, (key, output)
        parsed[key.lower()] = int(match.group(1))
    return parsed


def verify_packet_seal(packet: Path) -> None:
    seal = json.loads((packet / "SEAL.json").read_text())
    actual = {
        path.relative_to(packet).as_posix(): sha256(path)
        for path in sorted(packet.rglob("*"))
        if path.is_file()
        and path.name != "SEAL.json"
        and "__pycache__" not in path.parts
    }
    assert seal["schema"] == "q-schur-index-one-seal-v1"
    assert seal["exit"] == "Q-UNDECIDED"
    assert seal["files"] == actual

    manifest = json.loads((packet / "SOURCE_MANIFEST.json").read_text())
    for name, record in manifest["imports"].items():
        assert sha256(packet / "imports" / name) == record["sha256"]


def verify_source_binding(source_root: Path) -> dict[str, str]:
    """Bind the asserted normal form to the installed authoritative packets."""
    expected = {
        "goals_after_35fa8f/GOAL_Q_SCHUR_INDEX_ONE_DECISION.md":
            "e5600e7f41e0744e05c5dd961a0eda9f7a26f5d908b71d590a343b5c0b1446d9",
        "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json":
            "e97a32d6f22a8028528bc2b4d27ee009901caeb047fd2ffe5ac2bdd1fab743cd",
        "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/BRIDGE.md":
            "660577dd5848eb5f9acb747b4c82877968d3ba5c59181581eb4ba8907d8aa2f8",
        "goal_runs_after_35fa/H_11_5_TWIST/SOURCE_BINDING.md":
            "9be0358c6d95a9ed32fcd6f1b09334abbeac0b05dce5e736da8479ebbe1ae226",
        "goal_runs_after_35fa/H_11_5_TWIST/field_model.json":
            "80fdc908633595d6bb3c292d0027aa66295a850b9b6a12cc473f90e3e373ba1e",
        "goal_runs_after_35fa/H_11_5_TWIST/SEAL.json":
            "9b790a67185edc94be385993276ea4b4e35a6cfba4739981c083dd6d9886eb25",
    }
    for relative, digest in expected.items():
        assert sha256(source_root / relative) == digest

    # The H4 packet is the installed derivation of the change from the
    # authoritative PSL2 generators to the T/P eigenbasis used here.
    h4 = source_root / "goal_runs_after_35fa/H_11_5_TWIST"
    h4_seal = json.loads((h4 / "SEAL.json").read_text())
    h4_actual = {
        path.relative_to(h4).as_posix(): sha256(path)
        for path in sorted(h4.rglob("*"))
        if path.is_file()
        and path.name != "SEAL.json"
        and path.suffix != ".pyc"
        and "__pycache__" not in path.parts
        and path.name != ".DS_Store"
    }
    assert h4_seal["files"] == h4_actual
    field = json.loads((h4 / "field_model.json").read_text())
    assert tuple(field["group"]["T_weights"]) == WEIGHTS
    assert field["group"]["P_action"] == "P(e_i)=e_(i+1), hence (P y)_i=y_(i-1)"
    assert field["group"]["presentation"] == "H=<T,P | T^11=P^5=1, P*T*P^-1=T^5>"
    return expected


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "packet",
        type=Path,
        nargs="?",
        default=Path(__file__).resolve().parent,
        help="packet directory (defaults to the verifier's own directory)",
    )
    parser.add_argument("--singular", default="/opt/homebrew/bin/Singular")
    parser.add_argument("--source-root", type=Path)
    parser.add_argument("--report", type=Path)
    args = parser.parse_args()
    packet = args.packet.resolve()

    # Cyclotomic specialization is a literal ring map.
    phi5 = ZERO
    for power in T_POWERS:
        phi5 = cadd(phi5, power)
    assert phi5 == ZERO
    assert cmul(tpower(2), tpower(4)) == tpower(6)
    assert pow(ROOT5, 5, PRIME) == 1 and ROOT5 != 1
    assert sum(pow(ROOT5, i, PRIME) for i in range(5)) % PRIME == 0
    assert (PRIME - 1) % 55 == 0

    verify_t_p_f()
    verify_packet_seal(packet)
    # The packet lives at <source-root>/goal_runs_after_35fa/Q_SCHUR_INDEX_ONE.
    # Infer that root by default so the ordinary packet replay also checks the
    # authoritative T/P normal-form derivation rather than silently skipping it.
    source_root = (
        args.source_root.resolve()
        if args.source_root
        else Path(os.environ["Q_SCHUR_SOURCE_ROOT"]).resolve()
        if "Q_SCHUR_SOURCE_ROOT" in os.environ
        else packet.parents[1]
    )
    source_hashes = verify_source_binding(source_root)

    payload = json.loads((packet / "f55_covariant_results.json").read_text())
    records = {(r["degree"], r["character_mod_5"]): r for r in payload["records"]}
    assert set(records) == {(d, k) for d in DEGREES for k in CHARACTERS}

    report_records = []
    with tempfile.TemporaryDirectory(prefix="f55_standalone_") as temp_name:
        temp = Path(temp_name)
        for degree in DEGREES:
            for character in CHARACTERS:
                basis, integral = landing_system(degree, character)
                reduced = specialize(integral)
                text = singular_text(basis, reduced)
                name = f"f55_degree{degree}_chi{character}_p{PRIME}.sing"
                installed = packet / name
                regenerated = temp / name
                regenerated.write_text(text)

                # Strong canonical comparison: the independently reconstructed
                # equations and all ordering conventions agree byte-for-byte.
                assert regenerated.read_bytes() == installed.read_bytes(), name

                record = records[(degree, character)]
                assert record["covariant_dimension"] == len(basis)
                assert record["basis"] == [list(e) for e in basis]
                assert record["coefficient_equations"] == len(reduced)
                assert record["input_sha256"] == sha256(installed)

                process = subprocess.run(
                    [args.singular, "-q", str(regenerated)],
                    check=True,
                    text=True,
                    stdout=subprocess.PIPE,
                    stderr=subprocess.STDOUT,
                )
                parsed = parse_singular(process.stdout)
                # A homogeneous affine cone of dimension zero has no nonzero
                # geometric point, so the associated projective scheme is empty.
                assert parsed["dim"] == 0
                assert parsed["vdim"] == EXPECTED_VDIMS[(degree, character)]
                assert parsed["basis_size"] == record["basis_size"]
                assert parsed["vdim"] == record["vdim"]
                assert process.stdout.encode() == (packet / record["transcript"]).read_bytes()
                assert record["transcript_sha256"] == sha256(packet / record["transcript"])
                assert record["projective_landing_scheme_empty"] is True

                report_records.append({
                    "degree": degree,
                    "character_mod_5": character,
                    "covariant_dimension": len(basis),
                    "coefficient_equations": len(reduced),
                    "integral_coefficient_terms": sum(len(p) for p in integral.values()),
                    "input_sha256": sha256(regenerated),
                    **parsed,
                })
                print(
                    f"PASS d={degree} k={character} Mdim={len(basis)} "
                    f"equations={len(reduced)} dim={parsed['dim']} vdim={parsed['vdim']}"
                )

    report = {
        "schema": "f55-standalone-repair-v1",
        "packet": str(packet),
        "producer_imported": False,
        "formal_group": {
            "T": "diag(zeta11^(1,9,4,3,5))",
            "P": "P(e_i)=e_(i+1)",
            "relation": "P*T*P^-1=T^5",
        },
        "klein_cubic": "sum_i x_i^2*x_(i+1)",
        "integral_coefficient_ring": "Z[t]/(t^4+t^3+t^2+t+1)",
        "specialization": {"prime": PRIME, "t_zeta5": ROOT5, "zeta11": ROOT11},
        "source_hashes": source_hashes,
        "records": report_records,
        "conclusion": "all 25 degree-1-through-5 projective landing schemes are empty",
        "strict_nonclaims": [
            "no all-degree exclusion",
            "no pointlessness theorem for the 11:5 generic twist",
            "no point or pointlessness theorem for the genuine Schur twist",
        ],
    }
    if args.report:
        args.report.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print("Q_F55_ALL_PROJECTIVE_CHARACTERS_INDEPENDENT_REPLAY_OK")
    print("F55_STANDALONE_CYCLOTOMIC_REPAIR_OK")


if __name__ == "__main__":
    main()
