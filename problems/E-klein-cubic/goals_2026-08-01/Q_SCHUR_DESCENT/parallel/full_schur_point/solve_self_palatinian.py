#!/usr/bin/env python3
"""Generate and run an exact Singular solve for stored Schur-Palatini rows."""

from __future__ import annotations

import argparse
import json
import re
import subprocess
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent


def monomials(degree: int, variables: int):
    out = []
    def rec(prefix, left, slots):
        if slots == 1:
            out.append(prefix + (left,))
            return
        for x in range(left + 1):
            rec(prefix + (x,), left - x, slots - 1)
    rec((), degree, variables)
    return out


def poly(row: np.ndarray, mons: list[tuple[int, ...]]) -> str:
    terms = []
    for coefficient, alpha in zip(row, mons):
        c = int(coefficient)
        if not c:
            continue
        factors = []
        for i, e in enumerate(alpha):
            if e == 1:
                factors.append(f"a{i}")
            elif e:
                factors.append(f"a{i}^{e}")
        monomial = "*".join(factors) or "1"
        terms.append(f"{c}*{monomial}")
    return "+".join(terms) or "0"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("degree", type=int)
    args = parser.parse_args()
    metadata = json.loads((HERE / f"self_pal_d{args.degree}.json").read_text())
    n = metadata["coefficient_dimension"]
    rows = np.load(HERE / f"self_pal_d{args.degree}_rows.npz")["rows"]
    mons = monomials(4, n)
    equations = [poly(row, mons) for row in rows]
    variables = ",".join(f"a{i}" for i in range(n))
    source = HERE / f"self_pal_d{args.degree}.sing"
    source.write_text("\n".join([
        f"ring r=23,({variables}),dp;",
        f"ideal I={','.join(equations)};",
        "ideal G=std(I);",
        'print("GB_SIZE="+string(size(G)));',
        'print("AFFINE_DIM="+string(dim(G)));',
        'print("VDIM="+string(vdim(G)));',
        "quit;",
    ]) + "\n")
    result = subprocess.run(["Singular", "-q", str(source)], cwd=HERE, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=False)
    log = HERE / f"self_pal_d{args.degree}.sing.log"
    log.write_text(result.stdout)
    print(result.stdout)
    match = re.search(r"AFFINE_DIM=(-?\d+)", result.stdout)
    assert match
    print(f"returncode={result.returncode} affine_dim={match.group(1)}")


if __name__ == "__main__":
    main()
