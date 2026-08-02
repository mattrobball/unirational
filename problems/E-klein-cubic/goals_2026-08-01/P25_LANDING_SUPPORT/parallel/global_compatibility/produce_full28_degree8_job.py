#!/usr/bin/env python3
"""Prepare the immutable direct full-690/full-28 degree-eight module job.

The 28 components have weights [0,1^6,2^21], making every sealed row
homogeneous of total weighted degree three.  One degree-eight standard basis
is reused to reduce, for every q-axis, the 28 chartwise annihilator targets

    q_i^8 e_0, q_i^7 e_1,...,q_i^7 e_6,
    q_i^6 e_7,...,q_i^6 e_27.

All 1,036 zero remainders prove the complete lower-presentation support empty.
The producer writes but never launches the Singular input.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
SCRIPT = HERE / "direct_full690_all28_degree8.sing"
RESULT = HERE / "direct_full690_all28_degree8.result"
LOG = HERE / "direct_full690_all28_degree8.log"
MANIFEST = HERE / "direct_full690_all28_degree8.json"
RUNNER = HERE / "run_immutable_singular.py"

P = 89
NQ = 37
WEIGHTS = [0] + [1] * 6 + [2] * 21
EXPONENTS = [8] + [7] * 6 + [6] * 21


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            answer.append((first,) + tail)
    return answer


def polynomial(coefficients: np.ndarray, monomials: list[tuple[int, ...]]) -> str:
    terms: list[str] = []
    for raw, exponent in zip(coefficients, monomials):
        coefficient = int(raw) % P
        if not coefficient:
            continue
        factors = []
        for variable, power in enumerate(exponent):
            if power:
                factors.append(f"q{variable}" if power == 1 else f"q{variable}^{power}")
        monomial = "*".join(factors) if factors else "1"
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def build_script() -> str:
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    monomials = {
        degree: weak_compositions(degree, NQ) for degree in (1, 2, 3)
    }
    blocks = [
        seeds[:, int(offsets[component]) : int(offsets[component + 1])]
        for component in range(28)
    ]
    if [block.shape[1] for block in blocks] != [9139] + [703] * 6 + [37] * 21:
        raise AssertionError("graded block layout mismatch")
    variables = ",".join(f"q{i}" for i in range(NQ))
    weights = ",".join(map(str, WEIGHTS))
    lines = [
        f"ring R={P},({variables}),(dp,C);",
        "option(prot); option(redSB);",
        "module N=",
    ]
    for row in range(690):
        entries = [polynomial(blocks[0][row], monomials[3])]
        entries.extend(polynomial(block[row], monomials[2]) for block in blocks[1:7])
        entries.extend(polynomial(block[row], monomials[1]) for block in blocks[7:])
        lines.append("[" + ",".join(entries) + "]" + ("," if row < 689 else ";"))
    lines.extend(
        [
            f'attrib(N,"isHomog",intvec({weights}));',
            'print("INPUT_GENS="+string(size(N)));',
            "degBound=8; timer=1; module G=std(N); int elapsed=timer;",
            'print("STD_GENS="+string(size(G))+" ELAPSED_MS="+string(elapsed));',
            f'write(":w {RESULT}","status=STD_COMPLETE,weighted_degree_bound=8"'
            '+",std_gens="+string(size(G))+",elapsed_ms="+string(elapsed));',
            "vector target; vector rem; int member; int allMember=1; int passed=0;",
        ]
    )
    for axis in range(NQ):
        for component, exponent in enumerate(EXPONENTS):
            lines.extend(
                [
                    f"target=q{axis}^{exponent}*gen({component + 1});",
                    "rem=reduce(target,G); member=(rem==0);",
                    "allMember=allMember*member; passed=passed+member;",
                    f'write(":a {RESULT}","axis={axis},component={component},weight={WEIGHTS[component]},exponent={exponent},member="'
                    '+string(member));',
                ]
            )
    lines.extend(
        [
            f'write(":a {RESULT}","status=ALL_TARGETS_COMPLETE,total=1036,passed="'
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
    for required in (RELATION, RUNNER):
        if not required.is_file():
            raise FileNotFoundError(required)
    write_immutable(SCRIPT, build_script())
    payload = {
        "status": "PREPARED_NOT_RUN",
        "prime": P,
        "source": {"path": str(RELATION), "sha256": sha256(RELATION)},
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
            "components": 28,
            "component_weights": WEIGHTS,
            "weighted_generator_degree": 3,
            "term_order": "global (dp,C)",
            "weighted_degree_bound": 8,
        },
        "targets": {
            "count": 1036,
            "axes": list(range(37)),
            "component_exponents": EXPONENTS,
            "total_weighted_degree": 8,
            "forms": [
                "q_i^8*gen(1)",
                "q_i^7*gen(2..7)",
                "q_i^6*gen(8..28)",
            ],
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
            "32",
        ],
        "decisive_criterion": (
            "A completed result ending status=ALL_TARGETS_COMPLETE,total=1036,"
            "passed=1036,all_member=1 proves the direct 690-row lower module has "
            "empty projective q-support."
        ),
        "safe_implication": (
            "Empty lower-presentation support implies empty support of the true "
            "746-row landing quotient, without exact T-closure."
        ),
        "scope": (
            "Any nonzero remainder, timeout, crash, or missing terminal marker is "
            "a nonverdict and does not prove a projective point."
        ),
    }
    write_immutable(MANIFEST, json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

