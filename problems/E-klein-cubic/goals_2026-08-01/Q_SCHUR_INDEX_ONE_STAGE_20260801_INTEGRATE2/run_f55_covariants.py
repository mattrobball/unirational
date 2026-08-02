#!/usr/bin/env python3
"""Produce the exact all-character 11:5 landing-scheme certificate."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import re
import subprocess
import time

import probe_f55_covariants as model


HERE = Path(__file__).resolve().parent
PRIME = 331
DEGREES = range(1, 6)
CHARACTERS = range(5)
SINGULAR = "/opt/homebrew/bin/Singular"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def parse(output: str) -> dict[str, int]:
    values = {}
    for key in ("BASIS_SIZE", "DIM", "VDIM"):
        match = re.search(rf"^{key}=(-?\d+)$", output, re.MULTILINE)
        if not match:
            raise RuntimeError(f"missing {key} in Singular output")
        values[key.lower()] = int(match.group(1))
    return values


def main() -> None:
    records = []
    for degree in DEGREES:
        for character in CHARACTERS:
            input_path = HERE / f"f55_degree{degree}_chi{character}_p{PRIME}.sing"
            summary = model.write_singular(
                degree, input_path, character=character, prime=PRIME
            )
            start = time.monotonic()
            process = subprocess.run(
                [SINGULAR, "-q", str(input_path)],
                check=True,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
            )
            elapsed = time.monotonic() - start
            transcript_path = input_path.with_suffix(".out")
            transcript_path.write_text(process.stdout)
            parsed = parse(process.stdout)
            if parsed["dim"] != 0:
                raise RuntimeError(
                    f"nonempty affine cone in degree {degree}, character {character}"
                )
            records.append(
                {
                    **summary,
                    **parsed,
                    "projective_landing_scheme_empty": True,
                    "input": input_path.name,
                    "input_sha256": sha256(input_path),
                    "transcript": transcript_path.name,
                    "transcript_sha256": sha256(transcript_path),
                    "elapsed_seconds": round(elapsed, 6),
                }
            )
            print(
                f"degree={degree} character={character} "
                f"covariants={summary['covariant_dimension']} "
                f"dim={parsed['dim']} vdim={parsed['vdim']}"
            )

    payload = {
        "schema": "klein-f55-all-projective-characters-v1",
        "subgroup": "11:5 = C11 semidirect C5",
        "normal_form": {
            "c11_weights": list(model.WEIGHTS),
            "c5_action": "cyclic coordinate shift",
            "klein_cubic": "sum_i x_i^2*x_(i+1)",
        },
        "prime": PRIME,
        "prime_is_split": (PRIME - 1) % 55 == 0,
        "degrees": list(DEGREES),
        "projective_characters_mod_5": list(CHARACTERS),
        "records": records,
        "conclusion": (
            "Every complete homogeneous projective 11:5-covariant landing "
            "scheme in degrees 1 through 5 is empty in the split good fibre, "
            "hence empty in characteristic zero by proper specialization."
        ),
        "strict_nonclaims": [
            "no all-degree exclusion",
            "no pointlessness theorem for the 11:5 generic twist",
            "no point or pointlessness theorem for the genuine Schur twist",
        ],
    }
    output = HERE / "f55_covariant_results.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("Q_F55_ALL_PROJECTIVE_CHARACTERS_DEGREE_LE_5_EXACT")


if __name__ == "__main__":
    main()
