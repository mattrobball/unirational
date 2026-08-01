#!/usr/bin/env python3
"""Full-rank interpolation and holdout test for the nontrivial direction.

The concurrent discovery packet found

    y/w = (1 + u*v)/(t^2*u).

This script fits the X-coordinate in the feature box

    base degree <= 1, Laurent (t,u,v) degree-difference <= 3,

using enough unique-root fibres to exceed all 735 features, then validates
the fitted formula on disjoint fibres.  The calculation is discovery over
GF(67); a successful result still needs characteristic-zero reconstruction.
"""

from __future__ import annotations

import json
import random
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
sys.path.insert(0, str(PARENT))

from reconstruct_survivor import (  # noqa: E402
    P,
    base_monomials,
    fit,
    irreducible,
    laurent_exponents,
    laurent_values,
    primitive_terms,
    scale,
    survivor_root,
)


TRAINING = 145
HOLDOUT = 40


def evaluate_formula(record, nonzero_terms):
    sample, field, t, u, v, root = record
    exponent_list = [tuple(item["tuv_exponents"]) for item in nonzero_terms]
    unique_exponents = list(dict.fromkeys(exponent_list))
    values = dict(zip(unique_exponents, laurent_values(field, t, u, v, unique_exponents)))
    base_values = dict(base_monomials(sample, 1))
    predicted = field.zero
    for item in nonzero_terms:
        coefficient = item["coefficient_mod_67"]
        base = tuple(item["base_exponents"])
        exponent = tuple(item["tuv_exponents"])
        term = scale(coefficient * base_values[base] % P, values[exponent])
        predicted = field.add(predicted, term)
    return predicted == root


def main() -> None:
    terms = primitive_terms()
    generator = random.Random(2026080102)
    records = []
    attempts = 0
    target = TRAINING + HOLDOUT
    while len(records) < target:
        attempts += 1
        sample = {name: generator.randrange(1, P) for name in ("A", "B", "Y", "Z")}
        if not irreducible(sample, terms):
            continue
        try:
            result = survivor_root(sample)
        except (AssertionError, ZeroDivisionError):
            continue
        if result is None:
            continue
        field, t, u, v, root = result
        records.append((sample, field, t, u, v, root))
        if len(records) % 10 == 0:
            print(f"unique_roots={len(records)} attempts={attempts}", flush=True)

    fitted = fit(records[:TRAINING], 3, 1)
    holdout_passes = None
    if "nonzero_terms" in fitted:
        holdout_passes = sum(
            evaluate_formula(record, fitted["nonzero_terms"])
            for record in records[TRAINING:]
        )
    payload = {
        "scope": "discovery over GF(67); characteristic-zero reconstruction required",
        "direction": "(1+u*v)/(t^2*u)",
        "prime": P,
        "training_samples": TRAINING,
        "holdout_samples": HOLDOUT,
        "attempts": attempts,
        "fit": fitted,
        "holdout_passes": holdout_passes,
        "expected_holdout_passes": HOLDOUT,
        "feature_count_check": len(laurent_exponents(3)) * len(base_monomials(records[0][0], 1)),
    }
    output = HERE / "survivor_extended_p67.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps({key: value for key, value in payload.items() if key != "fit"}, indent=2, sort_keys=True))
    print(json.dumps({key: value for key, value in fitted.items() if key != "nonzero_terms"}, indent=2, sort_keys=True))
    if "nonzero_terms" in fitted:
        print(f"nonzero_terms={len(fitted['nonzero_terms'])}")
    print("SURVIVOR_EXTENDED_P67_DONE")


if __name__ == "__main__":
    main()
