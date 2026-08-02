#!/usr/bin/env python3
"""Independent verification of the C6 five-form matrix packet.

Does not import produce.py.  Rebuilds A_i from sealed Codex sources and checks
skew-symmetry, M(u)u=0, Plücker agreement, and C5 seed cross-check.
"""

from __future__ import annotations

import json
import random
from pathlib import Path

from c6_core import (
    HERE,
    ROOT,
    SECTION_NAMES,
    M_of,
    build_forms_mod,
    expand_form_sparse,
    form_to_pluecker,
    load_sealed_sources,
    omega,
    pluecker_vector,
    primitive_root_11,
    q11_mod,
    rank_mod,
    sha256_file,
)


def main() -> None:
    sources = load_sealed_sources()
    payload = json.loads((HERE / "five_form_matrix.json").read_text())
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())

    # Hash binding inputs against manifest
    for key, entry in manifest["binding_inputs"].items():
        path = ROOT / entry["path"]
        assert sha256_file(path) == entry["sha256"], key

    assert payload["section_names"] == list(SECTION_NAMES)
    assert payload["marker"] == "C6-FIVE-FORM-MATRIX-PASS"
    assert manifest["retired_equations_forbidden"] == [
        "e^2=e",
        "Trd(e)=2",
        "e*S_0*e=0",
    ]

    # Rebuild exact sparse forms and compare term supports / sample coeffs
    for index, name in enumerate(SECTION_NAMES):
        rebuilt = expand_form_sparse(sources["q_linear"], sources["frame_vectors"][name])
        stored = payload["forms"][index]["matrix"]
        assert payload["forms"][index]["name"] == name
        for row in range(6):
            for column in range(6):
                assert rebuilt[row][column] == stored[row][column], (name, row, column)
        # skew of sparse matrices: A[r,c] + A[c,r] = 0 as polys
        for row in range(6):
            for column in range(row, 6):
                # evaluate at a modular fibre
                pass

    # Modular multi-prime certificates
    for report in payload["modular_certificates"]:
        prime = int(report["prime"])
        point = tuple(report["point"])
        zeta = primitive_root_11(prime)
        forms = build_forms_mod(
            sources["q_linear"], sources["frame_vectors"], point, prime, zeta
        )
        # skew
        for form in forms:
            for row in range(6):
                for column in range(6):
                    assert (form[row][column] + form[column][row]) % prime == 0
        # Mu=0
        rng = random.Random(prime + 1)
        for _ in range(25):
            u = [rng.randrange(prime) for _ in range(6)]
            matrix = M_of(forms, u, prime)
            product = [
                sum(matrix[row][column] * u[column] for column in range(6)) % prime
                for row in range(5)
            ]
            assert product == [0] * 5
        # Plücker agreement vs sealed hyperplanes
        linear_forms = sources["pluecker"]["equations"]["linear_forms"]
        for _ in range(20):
            u = [rng.randrange(prime) for _ in range(6)]
            v = [rng.randrange(prime) for _ in range(6)]
            pvec = pluecker_vector(u, v, prime)
            for form_index, form in enumerate(forms):
                direct = omega(form, u, v, prime)
                value = 0
                for term in linear_forms[form_index]["terms"]:
                    coeff = q11_mod(term["coefficient_Qzeta11"], prime, zeta)
                    mon = coeff
                    for exponent, coordinate in zip(term["x_exponents"], point):
                        mon = (
                            mon
                            * pow(int(coordinate) % prime, int(exponent), prime)
                            % prime
                        )
                    mon = mon * int(pvec[int(term["pluecker_index"])]) % prime
                    value = (value + mon) % prime
                assert direct == value
                assert (
                    sum(
                        form_to_pluecker(form, prime)[k] * pvec[k] for k in range(15)
                    )
                    % prime
                    == direct
                )
        assert report["M_u_u_zero"] is True
        assert report["pluecker_agreement"]["ok"] is True

    # C5 seed
    seed = payload["c5_seed_cross_check_p23"]
    forms23 = build_forms_mod(
        sources["q_linear"],
        sources["frame_vectors"],
        (22, 21, 8, 1, 1),
        23,
        primitive_root_11(23),
    )
    u, v = seed["u"], seed["v"]
    assert all(omega(form, u, v, 23) == 0 for form in forms23)
    assert rank_mod(M_of(forms23, u, 23), 23) == 4
    assert seed["all_omega_zero"] is True
    assert seed["rank_M"] == 4

    # Morita target ledger present
    ledger = payload["kproj_coefficient_ledger"]
    assert ledger["morita_generic_dag_sha256"] == sources["hashes"]["morita_generic_dag"]
    assert (
        ledger["morita_generic_split_dag_sha256"]
        == sources["hashes"]["morita_generic_split_dag"]
    )

    print("C6_MATRIX_VERIFY_OK")
    print("C6-FIVE-FORM-MATRIX-PASS")


if __name__ == "__main__":
    main()
