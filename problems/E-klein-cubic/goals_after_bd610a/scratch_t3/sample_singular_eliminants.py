#!/usr/bin/env python3
"""Sample exact lex eliminants of the gate-open fold singular locus.

This is a discovery tool for Goal T3.  For every requested integer pair
``(A,u)`` it reconstructs the primitive sextic from the accepted TSV,
forms

    (P, P_u, P_A, P_B, P_Y, P_Z),

performs the T11 factor-by-factor saturation, and converts the resulting
zero-dimensional algebra to lexicographic order.  It records the monic
degree-six eliminant in ``Z``.  The output is exact over QQ; no modular or
floating-point computation is used.

Generated Macaulay2 inputs and outputs are kept under ``scratch_t3`` so this
script never mutates an accepted certificate packet.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import re
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "certificates/fold_t11/verify_specialized_exact.py"
M2 = "/opt/homebrew/bin/M2"
WORK = HERE / "sample_work"
MARKER = re.compile(
    r"SAMPLE A=(-?\d+) u=(-?\d+) dim=(-?\d+) degree=(-?\d+) coeffs=([^\n]*)"
)
Y_MARKER = re.compile(r"YREL A=(-?\d+) u=(-?\d+) coeffs=([^\n]*)")
B_MARKER = re.compile(r"BREL A=(-?\d+) u=(-?\d+) coeffs=([^\n]*)")


def load_source():
    spec = importlib.util.spec_from_file_location("fold_t11_specialized", SOURCE)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load {SOURCE}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def parse_int_list(spec: str) -> list[int]:
    """Parse comma-separated integers and inclusive ``lo:hi`` ranges."""

    answer: list[int] = []
    for item in spec.split(","):
        item = item.strip()
        if not item:
            continue
        if ":" in item:
            lo_text, hi_text = item.split(":", 1)
            lo, hi = int(lo_text), int(hi_text)
            step = 1 if hi >= lo else -1
            answer.extend(range(lo, hi + step, step))
        else:
            answer.append(int(item))
    return list(dict.fromkeys(answer))


def m2_block(src, primitive, gates, a0: int, u0: int, with_relations: bool) -> str:
    lines = ["R=QQ[B,Y,Z,MonomialOrder=>GRevLex];"]
    for name, deriv in zip(
        ("P", "Pu", "PA", "PB", "PY", "PZ"),
        (None, "u", "A", "B", "Y", "Z"),
    ):
        terms = src.specialize_Z(primitive, a0, u0, deriv)
        lines.append(f"{name}={src.sstr(terms)};")
    lines.extend(
        [
            f"ell={src.sstr(src.prim_ufree(gates['ell'], a0))};",
            f"Cgate={src.sstr(src.prim_ufree(gates['C'], a0))};",
            f"Q4={src.sstr(src.prim_ufree(gates['Q4'], a0))};",
            f"Puu={src.sstr(src.prim_u(gates['P_uu'], a0, u0))};",
            f"delta={src.sstr(src.prim_u(gates['delta'], a0, u0))};",
            "I=ideal(P,Pu,PA,PB,PY,PZ);",
            "scan({B,ell,Q4,Puu,Cgate,delta}, g -> I=saturate(I,g));",
            "d=dim I; e=if I==ideal(1_R) then -1 else degree I;",
            "cs={};",
            "if d==0 and e==6 then (",
            "  S=QQ[B,Y,Z,MonomialOrder=>Lex];",
            "  J=fglm(gb I,S);",
            "  gs=flatten entries gens J;",
            "  g=gs#0;",
            "  cs=apply(0..6, j -> coefficient(Z^j,g));",
            ");",
            f'<< "SAMPLE A={a0} u={u0} dim=" << d << " degree=" << e << " coeffs=";',
            'scan(cs, c -> << toExternalString c << ",");',
            '<< endl;',
        ]
    )
    if with_relations:
        lines.extend(
            [
                "if d==0 and e==6 then (",
                "  gy=gs#1; bg=gs#2;",
                "  cy=coefficient(Y,gy); cb=coefficient(B,bg);",
                "  ys=apply(0..5, j -> coefficient(Z^j,gy)/cy);",
                "  bs=apply(0..5, j -> coefficient(Z^j,bg)/cb);",
                f'  << "YREL A={a0} u={u0} coeffs=";',
                '  scan(ys, c -> << toExternalString c << ",");',
                '  << endl;',
                f'  << "BREL A={a0} u={u0} coeffs=";',
                '  scan(bs, c -> << toExternalString c << ",");',
                '  << endl;',
                ");",
            ]
        )
    return "\n".join(lines)


def prepare_script(a0: int, us: list[int], with_relations: bool) -> Path:
    src = load_source()
    primitive = src.load_P()
    factors = src.FACTORS
    gates = {
        "ell": src.load_tsv(factors / "ell_lc_u.tsv"),
        "C": src.load_tsv(factors / "C_content.tsv"),
        "P_uu": src.load_tsv(factors / "P_uu.tsv", with_u=True),
        "delta": src.load_tsv(factors / "delta_Cramer.tsv", with_u=True),
        "Q4": src.load_tsv(factors / "G_factor_Q4.tsv"),
    }
    WORK.mkdir(exist_ok=True)
    path = WORK / f"samples_A{a0}.m2"
    body = ['needsPackage "FGLM";']
    for u0 in us:
        body.append(m2_block(src, primitive, gates, a0, u0, with_relations))
    body.append("exit 0;")
    path.write_text("\n".join(body) + "\n")
    return path


def run_one(job: tuple[int, list[int], int, bool, bool]) -> tuple[int, str]:
    a0, us, timeout, reuse_existing, with_relations = job
    script = prepare_script(a0, us, with_relations)
    output = script.with_suffix(".out")
    if reuse_existing and output.is_file():
        old_text = output.read_text()
        enough_relations = not with_relations or (
            len(Y_MARKER.findall(old_text)) == len(us)
            and len(B_MARKER.findall(old_text)) == len(us)
        )
        if len(MARKER.findall(old_text)) == len(us) and enough_relations:
            return a0, old_text
    with output.open("w") as stream:
        result = subprocess.run(
            [M2, "--script", str(script)],
            stdout=stream,
            stderr=subprocess.STDOUT,
            check=False,
            timeout=timeout,
        )
    if result.returncode:
        raise RuntimeError(
            f"M2 failed for A={a0} with exit {result.returncode}: "
            + output.read_text()[-2000:]
        )
    return a0, output.read_text()


def decode(text: str) -> list[dict]:
    rows: list[dict] = []
    for match in MARKER.finditer(text):
        a0, u0, dim, degree = map(int, match.group(1, 2, 3, 4))
        raw = [part for part in match.group(5).split(",") if part]
        row: dict = {"A": a0, "u": u0, "dim": dim, "degree": degree}
        if dim == 0 and degree == 6:
            if len(raw) != 7:
                raise RuntimeError(f"bad coefficient count at {(a0, u0)}: {raw}")
            coeffs = [Fraction(value) for value in raw]
            if not coeffs[6]:
                raise RuntimeError(f"zero leading coefficient at {(a0, u0)}")
            row["coeffs"] = [str(value) for value in coeffs]
            row["monic"] = [str(value / coeffs[6]) for value in coeffs]
        rows.append(row)
    by_key = {(row["A"], row["u"]): row for row in rows}
    for field, pattern in (("Y_as_Z", Y_MARKER), ("B_as_Z", B_MARKER)):
        for match in pattern.finditer(text):
            key = (int(match.group(1)), int(match.group(2)))
            values = [part for part in match.group(3).split(",") if part]
            if key not in by_key or len(values) != 6:
                raise RuntimeError(f"bad {field} relation at {key}: {values}")
            by_key[key][field] = [str(Fraction(value)) for value in values]
    return rows


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--A", dest="a_values", default="-3:-2")
    parser.add_argument("--u", dest="u_values", default="-6:-1,1:9")
    parser.add_argument("--workers", type=int, default=2)
    parser.add_argument("--timeout-per-A", type=int, default=900)
    parser.add_argument("--reuse-existing", action="store_true")
    parser.add_argument("--with-relations", action="store_true")
    parser.add_argument("--output", type=Path, default=HERE / "singular_eliminant_samples.json")
    args = parser.parse_args()

    a_values = parse_int_list(args.a_values)
    u_values = parse_int_list(args.u_values)
    jobs = [
        (
            a0,
            u_values,
            args.timeout_per_A,
            args.reuse_existing,
            args.with_relations,
        )
        for a0 in a_values
    ]
    rows: list[dict] = []
    # Threads are sufficient because each worker spends its time in an external
    # Macaulay2 process.  They also avoid Python's semaphore-limit probe, which
    # is unavailable in the managed workspace sandbox on macOS.
    with ThreadPoolExecutor(max_workers=args.workers) as pool:
        futures = {pool.submit(run_one, job): job[0] for job in jobs}
        for future in as_completed(futures):
            a0, text = future.result()
            decoded = decode(text)
            if len(decoded) != len(u_values):
                raise RuntimeError(
                    f"A={a0}: found {len(decoded)} markers, expected {len(u_values)}"
                )
            if args.with_relations:
                for row in decoded:
                    if row["dim"] == 0 and row["degree"] == 6:
                        if "Y_as_Z" not in row or "B_as_Z" not in row:
                            raise RuntimeError(
                                f"A={a0}, u={row['u']}: missing lex relations"
                            )
            rows.extend(decoded)
            print(f"A={a0}: {len(decoded)} exact fibres", flush=True)

    rows.sort(key=lambda row: (row["A"], row["u"]))
    payload = {
        "schema": "klein-t3-singular-eliminant-samples-v1",
        "scope": "discovery, not a T3 certificate",
        "A_values": a_values,
        "u_values": u_values,
        "rows": rows,
    }
    args.output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    good = sum(row["dim"] == 0 and row["degree"] == 6 for row in rows)
    print(f"wrote {args.output}: {good}/{len(rows)} degree-six fibres")


if __name__ == "__main__":
    main()
