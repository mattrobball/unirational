#!/usr/bin/env python3
"""Emit exact Singular probes for the generic and a rational J2 local chart.

This is an all-orders polynomial probe, not a truncated-jet calculation.  It
uses the reciprocal sextic

    F(v) = v^6 P(1/v)

and its double-root incidence ``F=F_v=0``.  Coordinates are

    x=A-15, y=Y-12, w=2B+Z-133.

The generic script works over QQ(s), with s=Z.  The sample script takes s=0
and additionally feeds the exact target equation to Singular's local
singularity classifier.
"""

from __future__ import annotations

from collections import defaultdict
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P_PATH = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
H_PATH = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"


def monomial(coefficient: int, factors: list[str]) -> str:
    product = "*".join(factors) if factors else "1"
    return f"({coefficient})*{product}"


def reciprocal_expression(generic: bool) -> str:
    pieces = []
    with P_PATH.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            a, b, y, z, upow, coefficient = map(int, line.split())
            factors = []
            if a:
                factors.append(f"(15+x)^{a}")
            if b:
                base = "((133-s+w)/2)" if generic else "((133+w)/2)"
                factors.append(f"{base}^{b}")
            if y:
                factors.append(f"(12+y)^{y}")
            if z and generic:
                factors.append(f"s^{z}")
            elif z:
                continue
            if 6 - upow:
                factors.append(f"v^{6-upow}")
            pieces.append(monomial(coefficient, factors))
    return "+".join(pieces)


def target_sample_expression() -> str:
    pieces = []
    with H_PATH.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tcoefficient"
        for line in stream:
            a, b, y, z, coefficient = map(int, line.split())
            if z:
                continue
            factors = []
            if a:
                factors.append(f"(15+x)^{a}")
            if b:
                factors.append(f"((133+w)/2)^{b}")
            if y:
                factors.append(f"(12+y)^{y}")
            pieces.append(monomial(coefficient, factors))
    return "+".join(pieces)


def generic_script() -> str:
    f = reciprocal_expression(True)
    return f'''option(redSB);
ring R=(0,s),(x,y,w,v),ds;
poly F={f};
poly Fv=diff(F,v);
ideal I=F,Fv;
ideal SI=I+minor(jacob(I),2);
ideal GI=std(I);
ideal GS=std(SI);
print("J2_GENERIC_LOCAL_BEGIN");
print("DIM_I="+string(dim(GI)));
print("MULT_I="+string(mult(GI)));
print("DIM_SING="+string(dim(GS)));
print("VDIM_SING="+string(vdim(GS)));
print("J2_GENERIC_LOCAL_DONE");
quit;
'''


def sample_script() -> str:
    f = reciprocal_expression(False)
    h = target_sample_expression()
    return f'''option(redSB);
LIB "sing.lib";
LIB "classify.lib";
ring R=0,(x,y,w,v),ds;
poly F={f};
poly Fv=diff(F,v);
ideal I=F,Fv;
ideal SI=I+minor(jacob(I),2);
ideal GI=std(I);
ideal GS=std(SI);
print("J2_SAMPLE_INCIDENCE_BEGIN");
print("DIM_I="+string(dim(GI)));
print("MULT_I="+string(mult(GI)));
print("DIM_SING="+string(dim(GS)));
print("VDIM_SING="+string(vdim(GS)));
print("J2_SAMPLE_INCIDENCE_DONE");
ring T=0,(x,y,w),ds;
poly H={h};
ideal JH=jacob(H);
print("J2_SAMPLE_TARGET_BEGIN");
print("MULT_H="+string(mult(std(H))));
print("MILNOR_H="+string(vdim(std(JH))));
print("TJURINA_H="+string(vdim(std(H,JH))));
print("CLASSIFY_H_BEGIN");
classify(H);
print("CLASSIFY_H_END");
print("J2_SAMPLE_TARGET_DONE");
quit;
'''


def main() -> None:
    generic = HERE / "t3_j2_generic_local.sing"
    sample = HERE / "t3_j2_sample_local.sing"
    generic.write_text(generic_script())
    sample.write_text(sample_script())
    print(generic, generic.stat().st_size)
    print(sample, sample.stat().st_size)
    print("T3_J2_EXACT_LOCAL_EMITTED")


if __name__ == "__main__":
    main()
