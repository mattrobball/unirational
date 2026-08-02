#!/usr/bin/env python3
"""Derive small exact Singular probes from the kernel-aligned p=13 input.

The large polynomial payload is inherited byte-for-byte from the root probe;
only the commands after construction of the local standard basis vary.
"""

from __future__ import annotations

from hashlib import sha256
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "selected_local_membership_next" / "singular_local_membership_p13.sing"
ANCHOR = "ideal G=std(J);\n"


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def emit(name: str, commands: list[str]) -> None:
    text = SOURCE.read_text()
    prefix, separator, _ = text.partition(ANCHOR)
    if not separator:
        raise SystemExit("standard-basis anchor not found")
    output = HERE / name
    output.write_text(prefix + separator + "\n".join(commands) + "\nquit;\n")
    print(f"{name} bytes={output.stat().st_size} sha256={digest(output)}")


def emit_unreduced(name: str, commands: list[str]) -> None:
    text = SOURCE.read_text().replace("option(redSB);", "option(noredSB);")
    prefix, separator, _ = text.partition(ANCHOR)
    if not separator:
        raise SystemExit("standard-basis anchor not found")
    output = HERE / name
    output.write_text(prefix + separator + "\n".join(commands) + "\nquit;\n")
    print(f"{name} bytes={output.stat().st_size} sha256={digest(output)}")


def main() -> None:
    common = [
        'print("SINGULAR_LOCAL_STD_DONE");',
        'print("SINGULAR_LOCAL_STD_SIZE="); print(size(G));',
    ]
    emit_unreduced(
        "unreduced_basis_reduce_p13.sing",
        common
        + [
            'print("UNREDUCED_G1_TERMS="); print(size(G[1])); print("UNREDUCED_G2_TERMS="); print(size(G[2])); print("UNREDUCED_G3_TERMS="); print(size(G[3]));',
            'print("UNREDUCED_G_LEADS="); print(lead(G));',
            'print("START_UNREDUCED_REDUCE");',
            "poly r=reduce(P0,G,8);",
            'print("UNREDUCED_REDUCE_DONE");',
            'if (r==0) { print("UNREDUCED_REDUCE_ZERO=true"); } else { print("UNREDUCED_REDUCE_ZERO=false"); }',
            'print("UNREDUCED_BASIS_REDUCE_PROBE_DONE");',
        ],
    )
    emit_unreduced(
        "inspect_unreduced_basis_p13.sing",
        common
        + [
            'print("UNREDUCED_G1_TERMS="); print(size(G[1])); print("UNREDUCED_G2_TERMS="); print(size(G[2])); print("UNREDUCED_G3_TERMS="); print(size(G[3]));',
            'print("UNREDUCED_G_LEADS="); print(lead(G));',
            'print("UNREDUCED_BASIS_INSPECTION_DONE");',
        ],
    )
    emit(
        "inspect_standard_basis_p13.sing",
        common
        + [
            'print("G1_TERMS="); print(size(G[1]));',
            'print("G2_TERMS="); print(size(G[2]));',
            'print("G3_TERMS="); print(size(G[3]));',
            'print("G_LEADS="); print(lead(G));',
            'print("G_DEGREES="); print(deg(G[1]),deg(G[2]),deg(G[3]));',
            'print("STANDARD_BASIS_INSPECTION_DONE");',
        ],
    )
    emit(
        "augmented_standard_basis_p13.sing",
        common
        + [
            'print("START_AUGMENTED_STD");',
            "ideal GP=std(J+ideal(P0));",
            'print("AUGMENTED_STD_DONE");',
            'print("GP_SIZE="); print(size(GP));',
            'print("G_LEADS="); print(lead(G));',
            'print("GP_LEADS="); print(lead(GP));',
            'print("AUGMENTED_STANDARD_BASIS_PROBE_DONE");',
        ],
    )
    emit(
        "incremental_standard_basis_p13.sing",
        common
        + [
            'print("START_INCREMENTAL_STD");',
            "option(noredSB);",
            "ideal GI=std(G,P0);",
            'print("INCREMENTAL_STD_DONE");',
            'print("GI_SIZE="); print(size(GI));',
            'print("G_LEADS="); print(lead(G));',
            'print("GI_LEADS="); print(lead(GI));',
            'print("INCREMENTAL_STANDARD_BASIS_PROBE_DONE");',
        ],
    )
    emit(
        "lift_augmented_p13.sing",
        common
        + [
            'print("START_LIFTSTD_AUGMENTED");',
            "matrix T; ideal GL=liftstd(J+ideal(P0),T);",
            'print("LIFTSTD_AUGMENTED_DONE");',
            'print("GL_SIZE="); print(size(GL));',
            'print("GL_LEADS="); print(lead(GL));',
            'print("TRANSFORM_ROWS_COLS="); print(nrows(T),ncols(T));',
            'print("LIFT_AUGMENTED_PROBE_DONE");',
        ],
    )
    emit(
        "lift_membership_p13.sing",
        common
        + [
            'print("START_LIFT_MEMBERSHIP");',
            "matrix U; matrix T=lift(G,ideal(P0),U);",
            'print("LIFT_MEMBERSHIP_DONE");',
            'print("LIFT_UNIT="); print(U);',
            'print("LIFT_ROWS_COLS="); print(nrows(T),ncols(T));',
            'print("LIFT_MEMBERSHIP_PROBE_DONE");',
        ],
    )
    for mode in (2, 4, 10):
        emit(
            f"reduce_option{mode}_p13.sing",
            common
            + [
                f'print("START_REDUCE_OPTION_{mode}");',
                f"poly r=reduce(P0,G,{mode});",
                f'print("REDUCE_OPTION_{mode}_DONE");',
                f'if (r==0) {{ print("REDUCE_OPTION_{mode}_ZERO=true"); }} else {{ print("REDUCE_OPTION_{mode}_ZERO=false"); }}',
                f'print("REDUCE_OPTION_{mode}_PROBE_DONE");',
            ],
        )
    emit(
        "division_p13.sing",
        common
        + [
            'print("START_DIVISION");',
            "list D=division(ideal(P0),G);",
            'print("DIVISION_DONE");',
            "ideal DR=D[2]; matrix DU=D[3];",
            'if (DR[1]==0) { print("DIVISION_ZERO=true"); } else { print("DIVISION_ZERO=false"); }',
            'print("DIVISION_UNIT="); print(DU);',
            'print("DIVISION_PROBE_DONE");',
        ],
    )
    emit(
        "special_fibre_global_p13.sing",
        common
        + [
            'print("START_SPECIAL_FIBRE_GLOBAL");',
            "ring T=13,(a,b,y),dp;",
            "map psi=S,a,b,y,0,0;",
            "ideal J0=psi(J);",
            "option(noredSB); option(prot);",
            "ideal G0=slimgb(J0);",
            'print("SPECIAL_FIBRE_GLOBAL_DONE");',
            'print("SPECIAL_FIBRE_DIM="); print(dim(G0));',
            'print("SPECIAL_FIBRE_VDIM="); print(vdim(G0));',
            'print("SPECIAL_FIBRE_GB_SIZE="); print(size(G0));',
            'print("SPECIAL_FIBRE_GLOBAL_PROBE_DONE");',
        ],
    )
    emit(
        "special_fibre_separator_p13.sing",
        common
        + [
            'print("START_SPECIAL_FIBRE_SEPARATOR");',
            "ring T=13,(a,b,y),dp;",
            "map psi=S,a,b,y,0,0;",
            "ideal J0=psi(J); ideal m=a,b,y;",
            "option(noredSB);",
            "ideal Q=quotient(J0,m);",
            "ideal GQ=slimgb(Q);",
            'print("SPECIAL_FIBRE_SEPARATOR_DONE");',
            'print("SEPARATOR_IDEAL_SIZE="); print(size(GQ));',
            'print("SEPARATOR_IDEAL="); print(GQ);',
            'print("SPECIAL_FIBRE_SEPARATOR_PROBE_DONE");',
        ],
    )
    emit(
        "special_fibre_min_separator_p13.sing",
        common
        + [
            'print("START_SPECIAL_FIBRE_MIN_SEPARATOR");',
            "ring T=13,(a,b,y),dp;",
            "map psi=S,a,b,y,0,0;",
            "ideal J0=psi(J); ideal m=a,b,y;",
            "option(noredSB);",
            "ideal GQ=slimgb(quotient(J0,m));",
            "int best=0; int bestterms=1000000000; int i; poly c;",
            "for (i=1; i<=size(GQ); i=i+1) { c=subst(subst(subst(GQ[i],a,0),b,0),y,0); if ((c!=0) && (size(GQ[i])<bestterms)) { best=i; bestterms=size(GQ[i]); } }",
            'print("MIN_SEPARATOR_INDEX="); print(best);',
            'print("MIN_SEPARATOR_TERMS="); print(bestterms);',
            'print("MIN_SEPARATOR_POLY="); print(GQ[best]);',
            'print("SPECIAL_FIBRE_MIN_SEPARATOR_DONE");',
        ],
    )
    emit(
        "ab_slice_global_p13.sing",
        common
        + [
            'print("START_AB_SLICE_GLOBAL");',
            "ring T=13,(y,z,v),dp;",
            # A=a+3z=0 and B=b+12z+9v+2=2.
            "map psi=S,10z,z+4v,y,z,v;",
            "ideal JS=psi(J);",
            "option(noredSB); option(prot);",
            "ideal GS=slimgb(JS);",
            'print("AB_SLICE_GLOBAL_DONE");',
            'print("AB_SLICE_DIM="); print(dim(GS));',
            'print("AB_SLICE_VDIM="); print(vdim(GS));',
            'print("AB_SLICE_GB_SIZE="); print(size(GS));',
            'print("AB_SLICE_GLOBAL_PROBE_DONE");',
        ],
    )
    emit(
        "ab_slice_equidim_p13.sing",
        common
        + [
            'print("START_AB_SLICE_EQUIDIM");',
            "ring T=13,(y,z,v),dp;",
            "map psi=S,10z,z+4v,y,z,v;",
            "ideal JS=psi(J);",
            'LIB "primdec.lib";',
            "list EQ=equidim(JS);",
            'print("AB_SLICE_EQUIDIM_DONE");',
            'print("EQ_COMPONENT_COUNT="); print(size(EQ));',
            "int i; ideal EI;",
            "for (i=1; i<=size(EQ); i=i+1) { EI=std(EQ[i]); print(\"EQ_INDEX_DIM_DEGREE_SIZE=\"); print(i,dim(EI),degree(EI),size(EI)); }",
            'print("AB_SLICE_EQUIDIM_PROBE_DONE");',
        ],
    )


if __name__ == "__main__":
    main()
