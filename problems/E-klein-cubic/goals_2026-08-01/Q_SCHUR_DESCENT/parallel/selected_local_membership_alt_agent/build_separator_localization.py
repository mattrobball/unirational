#!/usr/bin/env python3
"""Build a global p=13 localization probe from the special-fibre separator."""

from __future__ import annotations

from hashlib import sha256
from pathlib import Path


HERE = Path(__file__).resolve().parent
BASE = HERE / "inspect_standard_basis_p13.sing"
LOG = HERE / "special_fibre_min_separator_p13.log"
OUTPUT = HERE / "separator_localization_p13.sing"


def between(text: str, left: str, right: str) -> str:
    _, found, tail = text.partition(left)
    if not found:
        raise SystemExit(f"missing marker {left!r}")
    value, found, _ = tail.partition(right)
    if not found:
        raise SystemExit(f"missing marker {right!r}")
    return value.strip()


def main() -> None:
    base = BASE.read_text()
    prefix, found, _ = base.partition("ideal G=std(J);\n")
    if not found:
        raise SystemExit("base standard-basis anchor missing")
    separator = between(LOG.read_text(), "MIN_SEPARATOR_POLY=\n", "\nSPECIAL_FIBRE_MIN_SEPARATOR_DONE")
    if "\n" in separator:
        raise SystemExit("separator was unexpectedly multiline")
    commands = [
        "ring U=13,(w,a,b,y,z,v),dp;",
        "map chi=S,a,b,y,z,v;",
        "ideal JU=chi(J); poly PU=chi(P0);",
        f"poly q={separator};",
        'print("SEPARATOR_TERMS="); print(size(q));',
        'print("SEPARATOR_AT_ORIGIN="); print(subst(subst(subst(q,a,0),b,0),y,0));',
        "ideal K=JU,w*q-1;",
        "option(noredSB); option(prot);",
        'print("START_SEPARATOR_LOCALIZATION_GB");',
        "ideal GK=groebner(K);",
        'print("SEPARATOR_LOCALIZATION_GB_DONE");',
        'print("SEPARATOR_LOCALIZATION_GB_SIZE="); print(size(GK));',
        'print("START_SEPARATOR_LOCALIZATION_REDUCE");',
        "poly r=reduce(PU,GK);",
        'print("SEPARATOR_LOCALIZATION_REDUCE_DONE");',
        'if (r==0) { print("SEPARATOR_LOCALIZATION_P_ZERO=true"); } else { print("SEPARATOR_LOCALIZATION_P_ZERO=false"); }',
        'print("SEPARATOR_LOCALIZATION_PROBE_DONE");',
        "quit;",
    ]
    OUTPUT.write_text(prefix + "\n".join(commands) + "\n")
    print(f"separator_terms_text={separator.count('+') + separator.count('-') + 1}")
    print(f"output={OUTPUT}")
    print(f"output_sha256={sha256(OUTPUT.read_bytes()).hexdigest()}")


if __name__ == "__main__":
    main()
