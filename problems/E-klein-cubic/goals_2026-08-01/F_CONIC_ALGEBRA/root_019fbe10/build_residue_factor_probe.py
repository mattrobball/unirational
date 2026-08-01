#!/usr/bin/env python3
"""Build a modular factorization probe for the residue hypersurface."""

from __future__ import annotations

import argparse
from pathlib import Path

from build_projective_residue_probe import homogenize, primitive_affine, singular


HERE = Path(__file__).resolve().parent


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--g", type=int, default=1)
    parser.add_argument("--prime", type=int, default=67)
    args = parser.parse_args()
    D, _ = homogenize(primitive_affine(args.g, args.prime), args.prime)
    output = HERE / f"residue_factor_g{args.g}_p{args.prime}.sing"
    output.write_text(
        "\n".join(
            [
                f"ring R={args.prime},(h,A,B,Y,T),dp;",
                f"poly D={singular(D.as_expr())};",
                "list L=factorize(D,1);",
                "L;",
                f'print("RESIDUE_FACTOR_G={args.g}_P={args.prime}_DONE");',
                "quit;",
            ]
        )
        + "\n"
    )
    print(output)


if __name__ == "__main__":
    main()
