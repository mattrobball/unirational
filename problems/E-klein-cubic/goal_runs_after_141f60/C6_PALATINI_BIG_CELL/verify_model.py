#!/usr/bin/env python3
"""Independent verification of the C6 determinantal / Palatini model.

Does not import produce.py.  Rebuilds modular quartics, checks the identity
minors = Q(u)*u, rank-4 kernel reconstruction, and inverse-formula ledger.
"""

from __future__ import annotations

import json
import random
from pathlib import Path

from c6_core import (
    EXP4,
    HERE,
    M_of,
    build_forms_mod,
    evaluate_quartic,
    interpolate_quartic,
    lambda_from_minors,
    load_sealed_sources,
    nullspace_mod,
    omega,
    primitive_root_11,
    rank_mod,
    signed_max_minors,
)


def main() -> None:
    sources = load_sealed_sources()
    quartic = json.loads((HERE / "quartic.json").read_text())
    strata = json.loads((HERE / "rank_strata.json").read_text())
    five = json.loads((HERE / "five_form_matrix.json").read_text())

    assert quartic["marker"] == "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS"
    assert quartic["definition"]["degree"] == 4
    assert strata["marker"] == "C6-RANK-STRATUM-REDUCTION-PASS"
    assert "inverse_formulas" in quartic["birational_model"]
    inv = quartic["birational_model"]["inverse_formulas"]
    assert "kernel" in inv["rank4_open"]
    assert "reconstruction" in inv["rank4_open"]
    assert inv["pointed_incidence_inverse"]["to_line"]
    assert inv["minor_charts"][0]["linear_first"] is True

    for specialization in quartic["modular_specializations"]:
        prime = int(specialization["prime"])
        point = tuple(specialization["point"])
        zeta = primitive_root_11(prime)
        forms = build_forms_mod(
            sources["q_linear"], sources["frame_vectors"], point, prime, zeta
        )
        stored = specialization["coefficients"]
        assert len(stored) == len(EXP4)
        # Rebuild Q independently
        rebuilt, solve_rank = interpolate_quartic(forms, prime, seed=prime + 7)
        assert solve_rank == len(EXP4)
        # Q unique up to the identity: compare via evaluation on random points
        rng = random.Random(prime + 99)
        for _ in range(40):
            u = [rng.randrange(prime) for _ in range(6)]
            if all(value == 0 for value in u):
                continue
            matrix = M_of(forms, u, prime)
            minors = signed_max_minors(matrix, prime)
            q_stored = evaluate_quartic(stored, u, prime)
            q_rebuilt = evaluate_quartic(rebuilt, u, prime)
            assert q_stored == q_rebuilt
            predicted = [q_stored * int(u[j]) % prime for j in range(6)]
            assert minors == predicted
            scale = lambda_from_minors(u, minors, prime)
            assert scale == q_stored
            # rank vs Q
            rank = rank_mod(matrix, prime)
            if rank <= 4:
                assert q_stored == 0
            if q_stored != 0:
                assert rank == 5
        # rank-4 reconstruction on a seed if present
        for report in five["modular_certificates"]:
            if int(report["prime"]) != prime:
                continue
            seed = report.get("common_line_seed")
            if not seed:
                continue
            u, v = seed["u"], seed["v"]
            matrix = M_of(forms, u, prime)
            assert rank_mod(matrix, prime) <= 4
            assert evaluate_quartic(stored, u, prime) == 0
            kernel = nullspace_mod(matrix, prime)
            assert len(kernel) >= 2
            # L = ker contains u and v
            assert all(omega(form, u, v, prime) == 0 for form in forms)
            # unique line on rank-4 open
            if rank_mod(matrix, prime) == 4:
                assert len(kernel) == 2
                # v is in span of kernel
                # check rank of [k0,k1,v] <= 2
                assert rank_mod(kernel + [v], prime) == 2
                assert rank_mod(kernel + [u], prime) == 2

    # strata histograms present for all modular primes in five_form
    for report in five["modular_certificates"]:
        key = str(report["prime"])
        assert key in strata["modular_histograms"]
        hist = strata["modular_histograms"][key]
        assert "5" in hist  # rank 5 dominates random samples

    print("C6_MODEL_VERIFY_OK")
    print("C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS")
    print("C6-RANK-STRATUM-REDUCTION-PASS")


if __name__ == "__main__":
    main()
