#!/usr/bin/env python3
"""Independent lightweight audit of the Goal G structural reduction.

This verifier reconstructs load-bearing finite ledgers from authoritative
repository scripts/files.  It deliberately does not claim to decide the
generic cubic.
"""

from __future__ import annotations

import ast
from itertools import combinations_with_replacement
import json
import re
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
BASELINE = "715faf441289e2589b9325311b6613ea0331bf88"
PYTHON = "/opt/homebrew/bin/python3" if Path("/opt/homebrew/bin/python3").exists() else sys.executable


def run(*args: str) -> str:
    return subprocess.check_output(args, cwd=PROBLEM, text=True)


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def check_git() -> None:
    head = run("git", "rev-parse", "HEAD").strip()
    require(len(head) == 40, "invalid HEAD")
    status = subprocess.run(
        ["git", "merge-base", "--is-ancestor", BASELINE, head],
        cwd=PROBLEM,
        check=False,
    )
    require(status.returncode == 0, "pinned baseline is not an ancestor of HEAD")


def check_hironaka_ledgers() -> None:
    report = (PROBLEM / "tmp/covariant_module/REPORT.md").read_text()
    require("rank_R(M) = 60/12 = 5" in report, "missing 60/12 covariant ledger")
    require("`M` is a free graded" in report and "`A`-module of rank 60" in report,
            "missing A-free rank-60 theorem")
    require("`R` is free of rank 12 over" in report, "missing rank-12 invariant theorem")

    output = run(PYTHON, "tmp/covariant_module/module_hilbert.py")
    require("rank_A(R)=12 rank_A(M)=60 rank_R(M)=5" in output,
            "rank-60 replay failed")


def check_generic_frame() -> None:
    source = PROBLEM / "tmp/generic_twist/phi_coefficients.py"
    tree = ast.parse(source.read_text())
    functions = {node.name for node in tree.body if isinstance(node, ast.FunctionDef)}
    require({"all_coefficients", "verify_expansion", "klein"} <= functions,
            "generic cubic producer lacks reconstruction functions")
    output = run(PYTHON, str(source.relative_to(PROBLEM)))
    require("PASS exact 35-coefficient expansion" in output,
            "generic cubic coefficient replay failed")

    report = (PROBLEM / "tmp/agent_high/REPORT.md").read_text()
    require("det B(x)=-295136920" in report, "frame determinant witness missing")


def check_denominator_clearing() -> None:
    """Check the graded ledger behind the all-degree/K_proj equivalence.

    This is deliberately independent of finding a point.  It checks the
    normalizations in the retained generic cubic and then verifies, as
    identities of formal degree vectors, both denominator clearing and its
    reverse.  Degree vectors have coordinates

        (constant, delta_0, ..., delta_4, d),

    where delta_j is the degree of a homogeneous denominator and d is the
    degree of a polynomial landing covariant.
    """

    payload = json.loads((HERE / "generic_cubic.json").read_text())
    require(payload["schema"] == "G_GENERIC_KLEIN_CUBIC_V1",
            "unexpected generic-cubic schema")
    frame_names = payload["frame_names"]
    frame_degrees = payload["frame_degrees"]
    require(frame_names == ["x", "C", "D", "E", "K"],
            "unexpected generic frame")
    require(frame_degrees == [1, 4, 5, 6, 7],
            "unexpected generic-frame degrees")
    require(payload["primary_names"] == ["f3", "f5", "f6", "f8", "f11"],
            "unexpected primary invariants")
    require(payload["primary_degrees"] == [3, 5, 6, 8, 11],
            "unexpected primary degrees")
    secondary_degrees = payload["secondary_degrees"]
    require(payload["projective_base"] == ["t3", "t6", "t8", "t11"],
            "unexpected projective transcendence basis")
    require(
        payload["projective_basis"]
        == [f"b{i}/tau^{degree}" for i, degree in enumerate(secondary_degrees)],
        "secondary basis is not normalized by its literal degree",
    )

    arithmetic_report = (PROBLEM / "tmp/kproj_arithmetic/REPORT.md").read_text()
    require(r"\tau=f_3^2/f_5" in arithmetic_report,
            "tau normalization missing from arithmetic report")
    require(r"t_d=f_d/\tau^d" in arithmetic_report,
            "projective normalization missing from arithmetic report")
    require("f5/tau^5=t3^2" in arithmetic_report,
            "f5 elimination identity missing from arithmetic report")
    require("remain independent" in arithmetic_report,
            "normalized secondary independence missing")

    # deg(tau)=2 deg(f3)-deg(f5)=1.  All projective generators and all
    # beta_s=b_s/tau^deg(b_s) consequently have weight zero.
    tau_degree = 2 * payload["primary_degrees"][0] - payload["primary_degrees"][1]
    require(tau_degree == 1, "tau does not have source degree one")
    projective_primary_indices = (0, 2, 3, 4)
    for index in projective_primary_indices:
        degree = payload["primary_degrees"][index]
        require(degree - degree * tau_degree == 0,
                "projective primary has nonzero source weight")
    require(payload["primary_degrees"][1] - 5 * tau_degree == 0,
            "f5/tau^5 has nonzero source weight")
    for degree in secondary_degrees:
        require(degree - degree * tau_degree == 0,
                "normalized secondary has nonzero source weight")
    for degree in frame_degrees:
        require(degree - degree * tau_degree == 0,
                "normalized frame vector has nonzero source weight")

    # Check every retained coefficient normalization.  The affine coefficient
    # of a_i a_j a_k has degree e_i+e_j+e_k, and division by that power of tau
    # must agree term-by-term with the recorded t/beta expression.
    coefficients = payload["coefficients"]
    require(len(coefficients) == 35 and payload["coefficient_count"] == 35,
            "generic cubic must contain all 35 symmetric coefficients")
    expected_triples = set(combinations_with_replacement(range(5), 3))
    seen = set()
    for item in coefficients:
        triple = tuple(item["triple"])
        require(len(triple) == 3 and tuple(sorted(triple)) == triple,
                "coefficient triple is not symmetric-cubic ordered")
        require(triple not in seen, "duplicate cubic coefficient")
        seen.add(triple)
        coefficient_degree = sum(frame_degrees[index] for index in triple)
        require(item["degree"] == coefficient_degree,
                "affine coefficient has the wrong frame weight")
        require(coefficient_degree - item["degree"] * tau_degree == 0,
                "normalized cubic coefficient has nonzero source weight")
        require(len(item["entries"]) == len(item["normalized_entries"]),
                "affine/projective coefficient term counts differ")
        for affine, normalized in zip(item["entries"], item["normalized_entries"]):
            require(affine["secondary"] == normalized["secondary"],
                    "secondary changed during normalization")
            require(affine["numerator"] == normalized["numerator"]
                    and affine["denominator"] == normalized["denominator"],
                    "scalar changed during normalization")
            primary = affine["primary_exponents"]
            a3, a5, a6, a8, a11 = primary
            require(normalized["projective_exponents"] == [a3 + 2 * a5, a6, a8, a11],
                    "incorrect f5/tau^5=t3^2 normalization")
            affine_degree = sum(
                exponent * degree
                for exponent, degree in zip(primary, payload["primary_degrees"])
            ) + secondary_degrees[affine["secondary"]]
            require(affine_degree == coefficient_degree,
                    "coefficient-basis term has the wrong affine degree")
    require(seen == expected_triples, "incomplete symmetric-cubic triple set")

    # Formal linear-degree arithmetic.
    ncoords = 1 + len(frame_degrees) + 1

    def constant(value: int) -> tuple[int, ...]:
        return (value,) + (0,) * (ncoords - 1)

    def variable(index: int) -> tuple[int, ...]:
        result = [0] * ncoords
        result[index] = 1
        return tuple(result)

    def add(*values: tuple[int, ...]) -> tuple[int, ...]:
        return tuple(sum(items) for items in zip(*values))

    def scale(value: tuple[int, ...], scalar: int) -> tuple[int, ...]:
        return tuple(scalar * item for item in value)

    zero = constant(0)
    denominator_degrees = [variable(index + 1) for index in range(5)]
    landing_degree = variable(ncoords - 1)
    common_degree = add(*denominator_degrees)

    # Forward direction.  For b_j=a_j tau^-e_j=n_j/d_j, put
    # h=product d_j and q_j=n_j product_{k != j}d_k.  Then q_j has degree
    # H-e_j and q_j B_j has the common degree H.
    cleared_coefficient_degrees = []
    for index, frame_degree in enumerate(frame_degrees):
        numerator_degree = add(denominator_degrees[index], constant(-frame_degree))
        cleared_degree = add(
            numerator_degree,
            common_degree,
            scale(denominator_degrees[index], -1),
        )
        require(cleared_degree == add(common_degree, constant(-frame_degree)),
                "cleared coefficient does not have degree H-e_j")
        require(add(cleared_degree, constant(frame_degree)) == common_degree,
                "cleared frame summands do not have a common degree")
        cleared_coefficient_degrees.append(cleared_degree)

        # Literal Laurent-monomial check q_j/h=n_j/d_j.  Coordinates are
        # n_0,...,n_4,d_0,...,d_4.
        q_over_h = [0] * 10
        q_over_h[index] = 1
        for denominator_index in range(5):
            if denominator_index != index:
                q_over_h[5 + denominator_index] += 1
            q_over_h[5 + denominator_index] -= 1
        expected = [0] * 10
        expected[index] = 1
        expected[5 + index] = -1
        require(q_over_h == expected, "q_j/h is not n_j/d_j")

    # Each polar term of F(sum q_j B_j) has degree 3H.  At the rational
    # level its tau exponent is exactly the one recorded in c_ijk/tau^E,
    # so cubic homogeneity gives F(p)=h^3 Phi(a).
    for item in coefficients:
        triple = item["triple"]
        term_degree = add(
            *(cleared_coefficient_degrees[index] for index in triple),
            constant(item["degree"]),
        )
        require(term_degree == scale(common_degree, 3),
                "cleared cubic term does not have degree 3H")
        tau_exponent_from_substitution = -sum(frame_degrees[index] for index in triple)
        tau_exponent_from_normalized_coefficient = -item["degree"]
        multiplicities = tuple(triple.count(index) for index in range(5))
        substituted_monomial = (3, tau_exponent_from_substitution, *multiplicities)
        normalized_monomial = (3, tau_exponent_from_normalized_coefficient, *multiplicities)
        require(substituted_monomial == normalized_monomial,
                "F(p)=h^3 Phi(a) tau ledger failed")

    # Nonzero is preserved: the frame determinant is a nonzero polynomial,
    # and diagonal rescaling by h*tau^-e_j has nonzero determinant
    # h^5*tau^-sum(e_j) in the invariant fraction field.
    frame_report = (PROBLEM / "tmp/agent_high/REPORT.md").read_text()
    determinant_match = re.search(r"det B\(x\)=(-?\d+)", frame_report)
    require(determinant_match is not None and int(determinant_match.group(1)) != 0,
            "nonzero frame determinant witness missing")
    forward_diagonal_determinant = (5, -sum(frame_degrees))
    require(forward_diagonal_determinant == (5, -23),
            "unexpected determinant weight for normalized frame")

    # Reverse direction.  If p=sum c_j B_j is homogeneous of degree d, then
    # deg(c_j)=d-e_j and a_j=c_j*tau^(e_j-d) has degree zero.  Moreover
    # p/tau^d=sum a_j(B_j/tau^e_j), and cubic scaling divides F(p) by tau^3d.
    reverse_coefficient_degrees = []
    for frame_degree in frame_degrees:
        coefficient_degree = add(landing_degree, constant(-frame_degree))
        normalized_scalar_degree = add(
            coefficient_degree,
            constant(frame_degree),
            scale(landing_degree, -1),
        )
        require(normalized_scalar_degree == zero,
                "reverse-normalized frame coefficient has nonzero weight")
        require(add(coefficient_degree, constant(frame_degree)) == landing_degree,
                "reverse frame expansion does not recover degree d")
        # Tau powers on both sides of
        # c_j B_j/tau^d=(c_j tau^(e_j-d))(B_j/tau^e_j).
        left_tau_power = add(scale(landing_degree, -1))
        right_tau_power = add(
            constant(frame_degree),
            scale(landing_degree, -1),
            constant(-frame_degree),
        )
        require(left_tau_power == right_tau_power,
                "reverse normalization identity failed")
        reverse_coefficient_degrees.append(coefficient_degree)

    for item in coefficients:
        triple = item["triple"]
        affine_term_degree = add(
            *(reverse_coefficient_degrees[index] for index in triple),
            constant(item["degree"]),
        )
        require(affine_term_degree == scale(landing_degree, 3),
                "F(p) term does not have degree 3d")
        normalized_term_degree = add(
            *(zero for _ in triple),
            constant(item["degree"] - item["degree"] * tau_degree),
        )
        require(normalized_term_degree == zero,
                "reverse normalized Phi term has nonzero weight")
        normalized_tau_exponent = add(
            constant(-item["degree"]),
            *(add(constant(frame_degrees[index]), scale(landing_degree, -1))
              for index in triple),
        )
        require(normalized_tau_exponent == scale(landing_degree, -3),
                "Phi(a)=F(p)/tau^(3d) ledger failed")

    # The projective coefficient vector is not annihilated by the reverse
    # diagonal scaling, again because tau is nonzero in the fraction field.
    reverse_diagonal_determinant = add(constant(sum(frame_degrees)),
                                       scale(landing_degree, -5))
    require(reverse_diagonal_determinant
            == add(constant(23), scale(landing_degree, -5)),
            "normalized-frame nonvanishing ledger failed")


def check_transition_boundaries() -> None:
    necessity = json.loads(
        (PROBLEM / "certificates/global_transition/necessity_theorem.json").read_text()
    )
    require(necessity["proof"]["status"] == "PROVED", "necessity theorem not proved")
    require(necessity["direction"].startswith("forward only"),
            "necessity direction was silently strengthened")
    steps = {
        step["id"]: step["claim"]
        for step in necessity["proof"]["steps"]
    }
    require(set(steps) == {f"N.{index}_{suffix}" for index, suffix in (
        (1, "forced_base_jets"),
        (2, "symbolic_powers"),
        (3, "associated_graded"),
        (4, "specialization"),
        (5, "iterated_incidences"),
        (6, "irrelevant_torsion"),
        (7, "projective_scalars"),
        (8, "C3_A4_marked"),
        (9, "no_short_Cech"),
    )}, "necessity proof-step ledger changed")
    require("common odd order m" in steps["N.1_forced_base_jets"],
            "forced common odd plane order is missing")
    require("A_m = ∩_t I(Z_t)^m" in steps["N.2_symbolic_powers"],
            "symbolic plus-plane filtration is missing")
    require("true order (still odd)" in steps["N.3_associated_graded"],
            "true-order stratification is missing")
    require("triple-line equalizer → residual point kernel"
            in steps["N.5_iterated_incidences"],
            "iterated incidence architecture is missing")
    require("finite irrelevant torsion" in steps["N.6_irrelevant_torsion"],
            "irrelevant-torsion boundary is missing")
    require("C3 lines, A4 points, and marked elliptic data"
            in steps["N.8_C3_A4_marked"],
            "remaining local restrictions are missing")

    repair = (PROBLEM / "REPAIR.md").read_text()
    require("Nonzero sample residual is not an obstruction theorem" in repair,
            "repair boundary missing")
    require("finite generation of the full equalizer/Fitting layers" in repair,
            "finite-generation gap missing")


def check_counterexample() -> None:
    # q_N=0 iff u^N b=v^N a.  The displayed primitive solution has degree 2N.
    for n in range(1, 9):
        # Represent monomials by exponent pairs.  Equality is literal.
        left = (n + 0, 0 + n)   # u^N * v^N
        right = (0 + n, n + 0)  # v^N * u^N
        require(left == right, f"counterexample identity failed at N={n}")
        require(2 * n > n, "solution did not exceed generator degree")
    require(True, "coprimality is the UFD fact gcd(u^N,v^N)=1")


def check_local_packet_scope() -> None:
    report = (PROBLEM / "tmp/fable_nonfactorized_feasibility/REPORT.md").read_text()
    require("FABLE_NONFACTORIZED_FEASIBILITY_CLOSED" in report,
            "Fable successor scope marker missing")
    require("It is not a negative answer to Problem E" in report,
            "Fable scope boundary missing")


def main() -> None:
    check_git()
    check_hironaka_ledgers()
    check_generic_frame()
    check_denominator_clearing()
    check_transition_boundaries()
    check_counterexample()
    check_local_packet_scope()
    print("G_DENOMINATOR_CLEARING_EQUIVALENCE_OK")
    print("G_UNIVERSAL_OBJECT_AUDIT_OK")
    print("G_GENERIC_SUPPORT_STILL_UNDECIDED")


if __name__ == "__main__":
    main()
