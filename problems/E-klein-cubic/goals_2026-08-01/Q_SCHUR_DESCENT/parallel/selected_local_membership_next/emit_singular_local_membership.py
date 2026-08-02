#!/usr/bin/env python3
"""Emit a kernel-aligned Singular local-standard-basis membership probe."""

from __future__ import annotations

import argparse
from hashlib import sha256
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = Path(
    "/Users/worker/unirational/problems/E-klein-cubic/"
    "tmp/target_branch_delta_saturated_singularity/"
    "global_primitive_u_sextic_exact.tsv"
)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def polynomial(prime: int) -> str:
    pieces: list[str] = []
    with SOURCE.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            a, b, y, z, u, coefficient = map(int, line.split())
            coefficient %= prime
            if coefficient == 0:
                continue
            factors = [str(coefficient)]
            for name, exponent in zip(("A", "B", "Y", "Z", "u"), (a, b, y, z, u)):
                if exponent == 1:
                    factors.append(name)
                elif exponent:
                    factors.append(f"{name}^{exponent}")
            pieces.append("*".join(factors))
    return "+".join(pieces)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=13)
    parser.add_argument("--output", type=Path, default=HERE / "singular_local_membership_p13.sing")
    args = parser.parse_args()
    if args.prime != 13:
        raise SystemExit("the affine witness and kernel alignment are currently certified only at p=13")

    p = polynomial(args.prime)
    lines = [
        f'print("SOURCE_SHA256={digest(SOURCE)}");',
        "ring R=13,(A,B,Y,Z,u),dp;",
        f"poly P={p};",
        "poly PA=diff(P,A); poly PB=diff(P,B); poly PY=diff(P,Y);",
        "poly PZ=diff(P,Z); poly Pu=diff(P,u);",
        'print("SINGULAR_PRIMITIVE_LOADED");',
        "ring S=13,(a,b,y,z,v),ds;",
        "map phi=R,a+3*z,b+12*z+9*v+2,y+10*z+11*v+7,z+1,v+10;",
        "poly P0=phi(P); poly PA0=phi(PA); poly PB0=phi(PB); poly PY0=phi(PY);",
        "poly PZ0=phi(PZ); poly Pu0=phi(Pu);",
        "poly g1=8*PA0+3*PB0+3*PY0;",
        "poly g2=3*PA0+8*PB0+7*PY0;",
        "poly g3=3*PA0+7*PB0+7*PY0;",
        'print("SINGULAR_KERNEL_ALIGNED");',
        "ideal tangent=jet(g1,1),jet(g2,1),jet(g3,1);",
        'print("TANGENT_GENERATORS="); print(tangent);',
        "ideal J=g1,g2,g3;",
        "option(redSB);",
        'print("START_SINGULAR_LOCAL_STD");',
        "ideal G=std(J);",
        'print("SINGULAR_LOCAL_STD_DONE");',
        'print("SINGULAR_LOCAL_STD_SIZE="); print(size(G));',
        "poly rP=reduce(P0,G);",
        "poly rPu=reduce(Pu0,G);",
        "poly rPZ=reduce(PZ0,G);",
        'if (rP==0) { print("SINGULAR_LOCAL_P_ZERO=true"); } else { print("SINGULAR_LOCAL_P_ZERO=false"); }',
        'if (rPu==0) { print("SINGULAR_LOCAL_PU_ZERO=true"); } else { print("SINGULAR_LOCAL_PU_ZERO=false"); }',
        'if (rPZ==0) { print("SINGULAR_LOCAL_PZ_ZERO=true"); } else { print("SINGULAR_LOCAL_PZ_ZERO=false"); }',
        'print("SINGULAR_LOCAL_MEMBERSHIP_PROBE_DONE");',
        "quit;",
    ]
    args.output.write_text("\n".join(lines) + "\n")
    print(f"output={args.output}")
    print(f"output_bytes={args.output.stat().st_size}")
    print(f"output_sha256={digest(args.output)}")
    print(f"source_sha256={digest(SOURCE)}")


if __name__ == "__main__":
    main()
