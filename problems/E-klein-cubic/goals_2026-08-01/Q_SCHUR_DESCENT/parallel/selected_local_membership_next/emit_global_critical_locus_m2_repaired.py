#!/usr/bin/env python3
"""Emit a bounded direct global critical-ideal feasibility probe.

The emitted M2 job reconstructs E=det(M)/u from the compact source matrix,
prints exact finite-field term counts, and then tries the deliberately naive
global Groebner basis J=(E_A,E_B,E_Y).  It is a scale test, not a localized
membership certificate.
"""

from __future__ import annotations

import argparse
from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = Path(
    "/Users/worker/unirational/problems/E-klein-cubic/"
    "tmp/full_scaled_frame_degree_attack/sparse_bkk_certificate.json"
)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def monomial(exponents: tuple[int, int, int, int, int]) -> str:
    pieces = []
    for name, exponent in zip(("A", "B", "Y", "Z", "u"), exponents):
        if exponent == 1:
            pieces.append(name)
        elif exponent:
            pieces.append(f"{name}^{exponent}")
    return "*".join(pieces) or "1"


def entry(records: list[dict], cell: tuple[int, int], prime: int) -> str:
    pieces = []
    for record in records:
        e_a, e_b, e_y, e_z, e_t, e_u, e_v = map(int, record["exponents"])
        if (e_t, e_v) != cell:
            continue
        if int(record["denominator"]) != 1:
            raise ValueError("source coefficient is not integral")
        coefficient = int(record["numerator"]) % prime
        if coefficient:
            pieces.append(
                f"{coefficient}*{monomial((e_a, e_b, e_y, e_z, e_u))}"
            )
    if not pieces:
        raise ValueError("matrix cell vanished modulo the selected prime")
    return "+".join(pieces)


def emit(prime: int, output: Path) -> None:
    payload = json.loads(SOURCE.read_text())
    rows = payload["consequences"]["serialized"]
    columns = ((0, 0), (0, 1), (1, 0))
    matrix = [[entry(row, column, prime) for column in columns] for row in rows]
    checkpoint = f"global_critical_locus_p{prime}.checkpoint"
    lines = [
        f'print "SOURCE_SHA256={digest(SOURCE)}";',
        f"R=GF({prime})[A,B,Y,Z,u,MonomialOrder=>GRevLex];",
    ]
    for row in range(3):
        for column in range(3):
            lines.append(f"m{row}{column}={matrix[row][column]};")
    lines.extend(
        [
            'print "GLOBAL_MATRIX_LOADED";',
            f'checkpointFile=openOut "{checkpoint}";',
            'checkpointFile << "GLOBAL_MATRIX_LOADED" << close;',
            "detM=m00*m11*m22+m01*m12*m20+m02*m10*m21-m02*m11*m20-m01*m10*m22-m00*m12*m21;",
            'print "GLOBAL_DETERMINANT_BUILT";',
            f'checkpointFile=openOut "{checkpoint}";',
            'checkpointFile << "GLOBAL_DETERMINANT_BUILT" << close;',
            "E=detM//u;",
            "assert(detM==u*E);",
            "EA=diff(A,E);",
            "EB=diff(B,E);",
            "EY=diff(Y,E);",
            "EZ=diff(Z,E);",
            "Eu=diff(u,E);",
            'print "GLOBAL_DERIVATIVES_BUILT";',
            f'checkpointFile=openOut "{checkpoint}";',
            'checkpointFile << "GLOBAL_DERIVATIVES_BUILT" << close;',
            "J=ideal(EA,EB,EY);",
            'print "START_GLOBAL_J_GB";',
            f'checkpointFile=openOut "{checkpoint}";',
            'checkpointFile << "START_GLOBAL_J_GB" << close;',
            "G=gb J;",
            'print "GLOBAL_J_GB_DONE";',
            f'checkpointFile=openOut "{checkpoint}";',
            'checkpointFile << "GLOBAL_J_GB_DONE" << close;',
            'print("GLOBAL_J_GB_SIZE="|toString numgens source gens G);',
            'print "START_GLOBAL_REMAINDERS";',
            f'checkpointFile=openOut "{checkpoint}";',
            'checkpointFile << "START_GLOBAL_REMAINDERS" << close;',
            "rems=apply({E,Eu,EZ},f->f%G);",
            'print("GLOBAL_REMAINDERS_ZERO="|toString apply(rems,f->f==0_R));',
            'print "GLOBAL_CRITICAL_LOCUS_DIRECT_PROBE_DONE";',
            f'checkpointFile=openOut "{checkpoint}";',
            'checkpointFile << "GLOBAL_CRITICAL_LOCUS_DIRECT_PROBE_DONE" << close;',
            "exit 0;",
        ]
    )
    output.write_text("\n".join(lines) + "\n")
    print(f"output={output}")
    print(f"output_bytes={output.stat().st_size}")
    print(f"output_sha256={digest(output)}")
    print(f"source_sha256={digest(SOURCE)}")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=13)
    parser.add_argument("--output", type=Path, default=HERE / "global_critical_locus_p13.m2")
    arguments = parser.parse_args()
    if arguments.prime <= 7:
        raise SystemExit("choose a prime greater than seven")
    emit(arguments.prime, arguments.output)


if __name__ == "__main__":
    main()
