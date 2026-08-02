#!/usr/bin/env python3
"""Prepare one immutable direct-690 job for all 222 degree-five targets.

The weighted module has six M1 components of weight zero and twenty-one M2
components of weight one.  Every one of the 690 sealed rows is homogeneous of
weighted degree two.  Singular computes the degree-five standard basis once
and then reduces all q_i^5 e_j, 0<=i<37 and 0<=j<6.

This producer never launches Singular.  Existing generated files are accepted
only when their bytes agree with a fresh in-memory reconstruction.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
SCRIPT = HERE / "direct_690_all_222_degree5.sing"
RESULT = HERE / "direct_690_all_222_degree5.result"
LOG = HERE / "direct_690_all_222_degree5.log"
MANIFEST = HERE / "direct_690_all_222_degree5.json"
RUNNER = HERE / "run_immutable_singular.py"

P = 89
NQ = 37
WEIGHTS = [0] * 6 + [1] * 21


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def polynomial(coefficients: np.ndarray, monomials: list[tuple[int, ...]]) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        factors = [
            (f"q{variable}" if power == 1 else f"q{variable}^{power}")
            for variable, power in enumerate(exponent)
            if power
        ]
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def build_script() -> str:
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    q2 = weak_compositions(2, NQ)
    q1 = weak_compositions(1, NQ)
    m1 = [
        seeds[:, int(offsets[1 + component]) : int(offsets[2 + component])]
        for component in range(6)
    ]
    m2 = [
        seeds[:, int(offsets[7 + component]) : int(offsets[8 + component])]
        for component in range(21)
    ]
    variables = ",".join(f"q{i}" for i in range(NQ))
    weights = ",".join(map(str, WEIGHTS))
    lines = [
        f"ring R={P},({variables}),(dp,C);",
        "option(prot); option(redSB);",
        "module N=",
    ]
    for row in range(690):
        entries = [polynomial(block[row], q2) for block in m1]
        entries.extend(polynomial(block[row], q1) for block in m2)
        suffix = "," if row < 689 else ";"
        lines.append("[" + ",".join(entries) + "]" + suffix)
    lines.extend(
        [
            f'attrib(N,"isHomog",intvec({weights}));',
            'print("INPUT_GENS="+string(size(N)));',
            "degBound=5; timer=1; module G=std(N); int elapsed=timer;",
            'print("STD_GENS="+string(size(G))+" ELAPSED_MS="+string(elapsed));',
            f'write(":w {RESULT}","status=STD_COMPLETE,degree_bound=5"'
            '+",std_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            "vector target; vector rem; int member; int allMember=1; int passed=0;",
        ]
    )
    for axis in range(NQ):
        for component in range(6):
            lines.extend(
                [
                    f"target=q{axis}^5*gen({component + 1});",
                    "rem=reduce(target,G); member=(rem==0);",
                    "allMember=allMember*member; passed=passed+member;",
                    f'write(":a {RESULT}","axis={axis},component={component},member="'
                    '+string(member));',
                ]
            )
    lines.extend(
        [
            f'write(":a {RESULT}","status=ALL_TARGETS_COMPLETE,total=222,passed="'
            '+string(passed)+",all_member="+string(allMember));',
            'print("ALL_TARGETS_COMPLETE PASSED="+string(passed)'
            '+" ALL_MEMBER="+string(allMember));',
            "quit;",
        ]
    )
    return "\n".join(lines) + "\n"


def write_immutable(path: Path, content: str) -> None:
    encoded = content.encode()
    if path.exists():
        if path.read_bytes() != encoded:
            raise RuntimeError(f"refusing to overwrite nonmatching immutable file {path}")
        return
    path.write_bytes(encoded)


def main() -> None:
    if not RELATION.is_file() or not RUNNER.is_file():
        raise FileNotFoundError("sealed relation or bounded runner missing")
    content = build_script()
    write_immutable(SCRIPT, content)
    payload = {
        "status": "PREPARED_NOT_RUN",
        "prime": P,
        "source": {
            "path": str(RELATION),
            "sha256": sha256(RELATION),
        },
        "script": {
            "file": SCRIPT.name,
            "bytes": SCRIPT.stat().st_size,
            "sha256": sha256(SCRIPT),
            "immutable_rebuild_match": True,
        },
        "result": RESULT.name,
        "log": LOG.name,
        "module": {
            "generators": 690,
            "components": 27,
            "component_weights": WEIGHTS,
            "weighted_generator_degree": 2,
            "term_order": "global (dp,C)",
            "degree_bound": 5,
        },
        "targets": {
            "count": 222,
            "axes": list(range(37)),
            "components": list(range(6)),
            "form": "q_i^5*gen(j+1)",
        },
        "single_standard_basis": True,
        "launched": False,
        "suggested_bounded_command_after_shared_slot_releases": [
            "/opt/homebrew/bin/python3",
            "-u",
            str(RUNNER),
            SCRIPT.name,
            RESULT.name,
            "--timeout",
            "43200",
            "--rss-gib",
            "16",
        ],
        "criterion": (
            "A completed result ending status=ALL_TARGETS_COMPLETE,total=222,"
            "passed=222,all_member=1 proves all 222 exact pure-power memberships."
        ),
        "scope": (
            "Every zero remainder is an exact membership witness computed from "
            "the direct 690-row weighted module. A timeout, crash, absent terminal "
            "marker, or any nonzero remainder is a nonverdict for Stage B."
        ),
    }
    manifest_text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    write_immutable(MANIFEST, manifest_text)
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
