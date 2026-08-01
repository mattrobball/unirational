#!/usr/bin/env python3
"""Build and optionally run the full generic fold-singular fibre in Singular.

This is a discovery/preflight program, not a characteristic-zero certificate.
It uses the *full* ideal

    (P, P_u, P_A, P_B, P_Y, P_Z) in k(A,u)[B,Y,Z]

and applies localization factors one at a time.  In particular it does not use
the refuted assertion that (P_B,P_Y,P_Z) is a chart, and it never expands a
product of all gates.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import resource
import subprocess
from collections import defaultdict
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
P_PATH = PROBLEM / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
FACTOR_DIR = PROBLEM / "certificates/fold_normalization_t2r/saturation_factors"
F27_101 = PROBLEM / "tmp/t2r45/G_modp/F27_p101.tsv"
EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_tsv(path: Path, arity: int) -> dict[tuple[int, ...], int]:
    out: dict[tuple[int, ...], int] = defaultdict(int)
    with path.open() as fh:
        next(fh)
        for line in fh:
            row = tuple(map(int, line.split()))
            if len(row) != arity + 1:
                raise ValueError((path, row))
            out[row[:-1]] += row[-1]
    return {e: c for e, c in out.items() if c}


def derivative(poly: dict[tuple[int, ...], int], axis: int) -> dict[tuple[int, ...], int]:
    out: dict[tuple[int, ...], int] = defaultdict(int)
    for exps, coeff in poly.items():
        if exps[axis]:
            e = list(exps)
            out[tuple(e[:axis] + [e[axis] - 1] + e[axis + 1 :])] += coeff * e[axis]
    return {e: c for e, c in out.items() if c}


def to_five(poly: dict[tuple[int, ...], int]) -> dict[tuple[int, ...], int]:
    """Embed (A,B,Y,Z)-exponents as (A,B,Y,Z,u)."""
    return {(a, b, y, z, 0): c for (a, b, y, z), c in poly.items()}


def singular_expr(poly: dict[tuple[int, ...], int], prime: int) -> str:
    """Serialize a sparse polynomial for k(A,u)[B,Y,Z]."""
    terms = []
    for (a, b, y, z, uu), coeff0 in sorted(poly.items(), reverse=True):
        coeff = coeff0 % prime if prime else coeff0
        if coeff == 0:
            continue
        if prime and coeff > prime // 2:
            coeff -= prime
        factors = []
        if coeff != 1 or not any((a, b, y, z, uu)):
            factors.append(str(coeff))
        for name, exponent in (("A", a), ("u", uu), ("B", b), ("Y", y), ("Z", z)):
            if exponent == 1:
                factors.append(name)
            elif exponent > 1:
                factors.append(f"{name}^{exponent}")
        terms.append("*".join(factors) if factors else "1")
    return "+".join(terms).replace("+-", "-") if terms else "0"


def build(prime: int, stages: list[str]) -> tuple[Path, dict]:
    if sha256(P_PATH) != EXPECTED_P:
        raise RuntimeError("primitive P hash mismatch")
    P = load_tsv(P_PATH, 5)
    polys = {
        "P": P,
        "Pu": derivative(P, 4),
        "PA": derivative(P, 0),
        "PB": derivative(P, 1),
        "PY": derivative(P, 2),
        "PZ": derivative(P, 3),
        "Bgate": {(0, 1, 0, 0, 0): 1},
        "ell": to_five(load_tsv(FACTOR_DIR / "ell_lc_u.tsv", 4)),
        "Q4": to_five(load_tsv(FACTOR_DIR / "G_factor_Q4.tsv", 4)),
        "Puu": load_tsv(FACTOR_DIR / "P_uu.tsv", 5),
        "Cgate": to_five(load_tsv(FACTOR_DIR / "C_content.tsv", 4)),
        "delta": load_tsv(FACTOR_DIR / "delta_Cramer.tsv", 5),
    }
    if prime == 101 and F27_101.exists():
        polys["F27"] = to_five(load_tsv(F27_101, 4))
    missing = [s for s in stages if s not in polys]
    if missing:
        raise RuntimeError(f"unavailable stages for p={prime}: {missing}")

    tag = "qq" if prime == 0 else f"p{prime}"
    stem = f"generic_full_{tag}_" + ("_".join(stages) if stages else "raw")
    script = HERE / f"{stem}.sing"
    output = HERE / f"{stem}.out"
    characteristic = str(prime) if prime else "0"
    lines = [
        f"ring r=({characteristic},A,u),(B,Y,Z),dp;",
        'option(redSB);',
        'LIB "elim.lib";',
    ]
    for name in ["P", "Pu", "PA", "PB", "PY", "PZ"] + stages:
        lines.append(f"poly {name}={singular_expr(polys[name], prime)};")
    lines += [
        "ideal I=P,Pu,PA,PB,PY,PZ;",
        'print("STAGE raw");',
        "ideal G=std(I);",
        'print("SIZE "+string(size(G)));',
        'print("DIM "+string(dim(G)));',
        'if (dim(G)==0) { print("VDIM "+string(vdim(G))); }',
    ]
    for idx, stage in enumerate(stages, 1):
        lines += [
            f"list sat{idx}=sat(G,ideal({stage}));",
            f"G=std(sat{idx}[1]);",
            f'print("STAGE {stage}");',
            'print("SIZE "+string(size(G)));',
            'print("DIM "+string(dim(G)));',
            'if (dim(G)==0) { print("VDIM "+string(vdim(G))); }',
        ]
    lines += ["exit;"]
    script.write_text("\n".join(lines) + "\n")
    meta = {
        "schema": "klein-t-generic-full-fibre-probe-v1",
        "claim_scope": "discovery/preflight only",
        "coefficient_field": "QQ(A,u)" if prime == 0 else f"GF({prime})(A,u)",
        "variables": ["B", "Y", "Z"],
        "ideal": ["P", "P_u", "P_A", "P_B", "P_Y", "P_Z"],
        "factorwise_stages": stages,
        "primitive_P_sha256": EXPECTED_P,
        "term_counts": {k: len(v) for k, v in polys.items()},
        "script": script.name,
        "output": output.name,
    }
    (HERE / f"{stem}.json").write_text(json.dumps(meta, indent=2, sort_keys=True) + "\n")
    return script, meta


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--prime", type=int, default=101, help="0 means QQ(A,u)")
    ap.add_argument(
        "--stages",
        default="Bgate,ell,Q4,Puu,Cgate,delta,F27",
        help="comma-separated factorwise saturations; use empty string for raw",
    )
    ap.add_argument("--run", action="store_true")
    ap.add_argument("--timeout", type=int, default=1800)
    args = ap.parse_args()
    stages = [s for s in args.stages.split(",") if s]
    script, meta = build(args.prime, stages)
    print(json.dumps(meta, indent=2, sort_keys=True))
    if args.run:
        output = HERE / meta["output"]
        with output.open("w") as fh:
            proc = subprocess.run(
                ["/opt/homebrew/bin/Singular", "-q", str(script)],
                stdout=fh,
                stderr=subprocess.STDOUT,
                timeout=args.timeout,
                check=False,
            )
        print(f"exit={proc.returncode} output={output}")
        print(f"peak_rss_raw={resource.getrusage(resource.RUSAGE_CHILDREN).ru_maxrss}")


if __name__ == "__main__":
    main()
