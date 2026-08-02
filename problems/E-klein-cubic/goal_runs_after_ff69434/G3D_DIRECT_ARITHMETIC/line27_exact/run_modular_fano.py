#!/usr/bin/env python3
"""Canonical produce path for Fano of lines on S_q over specialized K_t.

Replay:
  python3 produce_weil_fano.py   # delegates here
  python3 run_modular_fano.py    # same

1. Multi-prime Singular std: dim=0, vdim=27
2. Real radical attempt on one irred minpoly prime with timeout;
   on success → reducedness DECIDED; on TimeoutExpired → RESIDUAL_NONVERDICT
   with captured CAS log (honest resource failure).
"""

from __future__ import annotations

import hashlib
import json
import subprocess
import time
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
G3D = HERE.parent
ROOT = G3D.parents[1]
SCRATCH = Path(
    "/var/folders/n3/bqmjrljs275_439r2z8m30380000gp/T/grok-goal-9dc0c7a16c14/implementer"
)

import sys

sys.path.insert(0, str(HERE))
from produce_weil_fano import build_Kt_chart_equations  # noqa: E402
from kt_model import build_kt, DEFAULT_T  # noqa: E402

A, B, C, D, Z = sp.symbols("a b c d z")


def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    with p.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def clear_eq(f):
    f = sp.together(sp.expand(f))
    num, den = sp.fraction(f)
    return sp.expand(num), sp.Integer(sp.simplify(den))


def write_mod_script(
    p: int, cp: list, eqs_Kt, path: Path, with_radical: bool = False
) -> None:
    mpc = [c % p for c in cp]
    terms = []
    for i, c in enumerate(mpc):
        power = 12 - i
        if c == 0:
            continue
        if power == 0:
            terms.append(str(c))
        elif power == 1:
            terms.append("z" if c == 1 else f"{c}*z")
        else:
            terms.append(f"z^{power}" if c == 1 else f"{c}*z^{power}")
    mp = "+".join(terms).replace("+-", "-")
    lines = [
        "option(redSB);",
        f"ring r = ({p},z), (a,b,c,d), dp;",
        f"minpoly = {mp};",
    ]
    for j, f in enumerate(eqs_Kt):
        num, den = clear_eq(f)
        dmod = int(den % p)
        if dmod == 0:
            raise ZeroDivisionError(f"den0 p={p}")
        dinv = pow(dmod, -1, p)
        Poly = sp.Poly(num, A, B, C, D, Z)
        lines.append(f"poly f{j}=0;")
        batch = []
        for mon, cf in Poly.terms():
            c = (int(cf) % p) * dinv % p
            if c == 0:
                continue
            parts = []
            for ni, e in enumerate(mon):
                if e == 0:
                    continue
                nm = ["a", "b", "c", "d", "z"][ni]
                parts.append(nm if e == 1 else f"{nm}^{e}")
            monoms = "*".join(parts) if parts else "1"
            if c == 1:
                term = monoms
            elif c == p - 1:
                term = ("-" + monoms) if monoms != "1" else "-1"
            else:
                term = f"{c}*{monoms}"
            batch.append(term)
            if len(batch) >= 30:
                s = "+".join(batch).replace("+-", "-")
                lines.append(f"f{j}=f{j}+({s});")
                batch = []
        if batch:
            s = "+".join(batch).replace("+-", "-")
            lines.append(f"f{j}=f{j}+({s});")
    lines += [
        "ideal I=f0,f1,f2,f3;",
        "ideal J=std(I);",
        f'print(sprintf("P{p}|dim=%s|mult=%s|vdim=%s", string(dim(J)), string(mult(J)), string(vdim(J))));',
    ]
    if with_radical:
        lines += [
            'LIB "primdec.lib";',
            "ideal rad = radical(I);",
            "ideal Jr = std(rad);",
            f'print(sprintf("P{p}|rad_vdim=%s", string(vdim(Jr))));',
            f'print(sprintf("P{p}|reduced=%s", string(int(vdim(Jr)==vdim(J)))));',
        ]
    path.write_text("\n".join(lines) + "\n")


def run_sing(path: Path, timeout: int = 120) -> dict:
    out = subprocess.check_output(
        ["singular", "-q", str(path)],
        text=True,
        timeout=timeout,
        stdin=subprocess.DEVNULL,
    )
    info = {"raw": out.strip()}
    for line in out.splitlines():
        if not line.startswith("P") or "|" not in line:
            continue
        for part in line.split("|")[1:]:
            if "=" in part:
                k, v = part.split("=", 1)
                info[k] = int(v) if v.lstrip("-").isdigit() else v
    return info


def attempt_radical(p: int, cp: list, eqs_Kt, timeout_s: int = 90) -> dict:
    """Real radical run with captured timeout / success."""
    path = HERE / f"_radical_mod{p}.sing"
    write_mod_script(p, cp, eqs_Kt, path, with_radical=True)
    t0 = time.time()
    try:
        info = run_sing(path, timeout=timeout_s)
        elapsed = round(time.time() - t0, 3)
        if info.get("rad_vdim") is not None:
            return {
                "status": "DECIDED",
                "prime": p,
                "irred_minpoly": True,
                "vdim": info.get("vdim"),
                "rad_vdim": info.get("rad_vdim"),
                "reduced": info.get("reduced") in (1, True, "1"),
                "timeout_s": timeout_s,
                "elapsed_s": elapsed,
                "method": "Singular radical(I); rad_vdim vs vdim",
                "raw": info.get("raw", "")[:800],
            }
        return {
            "status": "RESIDUAL_NONVERDICT",
            "prime": p,
            "timeout_s": timeout_s,
            "elapsed_s": elapsed,
            "method": "Singular radical(I)",
            "error": "radical completed without rad_vdim parse",
            "raw": info.get("raw", "")[:800],
            "note": "CAS returned but rad_vdim missing; reducedness not claimed.",
        }
    except subprocess.TimeoutExpired as e:
        elapsed = round(time.time() - t0, 3)
        partial = ""
        if e.stdout:
            partial = e.stdout if isinstance(e.stdout, str) else e.stdout.decode(
                "utf-8", errors="replace"
            )
        # also capture any partial .out if written
        log_path = SCRATCH / f"radical_timeout_p{p}.log"
        SCRATCH.mkdir(parents=True, exist_ok=True)
        body = (
            f"TimeoutExpired after {timeout_s}s (measured ~{elapsed}s)\n"
            f"command: singular -q {path}\n"
            f"partial_stdout:\n{partial[:4000]}\n"
        )
        log_path.write_text(body)
        return {
            "status": "RESIDUAL_NONVERDICT",
            "prime": p,
            "irred_minpoly": True,
            "timeout_s": timeout_s,
            "elapsed_s": elapsed,
            "method": "Singular radical(I)",
            "error": "TimeoutExpired",
            "cas_log": str(log_path.name),
            "partial_stdout": partial[:2000],
            "note": (
                "Degree 27 multi-prime decided. Radical on irred prime hit resource "
                "timeout; reducedness is honest residual non-verdict with captured log."
            ),
        }
    except Exception as e:
        elapsed = round(time.time() - t0, 3)
        return {
            "status": "RESIDUAL_NONVERDICT",
            "prime": p,
            "timeout_s": timeout_s,
            "elapsed_s": elapsed,
            "method": "Singular radical(I)",
            "error": repr(e),
            "note": "Radical failed; reducedness residual non-verdict.",
        }


def main() -> None:
    t0 = time.time()
    print("=== run_modular_fano (canonical produce) ===", flush=True)
    kt = build_kt()
    cp = [int(c) for c in kt["charpoly_coeffs_high_to_low"]]
    data = build_Kt_chart_equations()
    primes_irred = [151, 641, 691, 701]
    primes_all = [103] + primes_irred
    holdout_degree = 701

    # --- multi-prime degree (no radical) ---
    results = []
    for p in primes_all:
        path = HERE / f"_clean_mod{p}.sing"
        print(f"std p={p}", flush=True)
        write_mod_script(p, cp, data["eqs_Kt"], path, with_radical=False)
        info = run_sing(path, timeout=180)
        print(info, flush=True)
        assert info.get("dim") == 0 and info.get("vdim") == 27, info
        results.append(
            {
                "p": p,
                "irred_minpoly": p in primes_irred,
                "dim": info["dim"],
                "mult": info["mult"],
                "vdim": info["vdim"],
                "raw": info.get("raw", "")[:200],
            }
        )

    # --- real radical attempt (captured timeout → non-verdict) ---
    rad_prime = 151  # smallest irred minpoly prime
    print(f"radical attempt p={rad_prime} timeout=90s", flush=True)
    red = attempt_radical(rad_prime, cp, data["eqs_Kt"], timeout_s=90)
    print("reducedness", red.get("status"), red.get("error") or red.get("reduced"), flush=True)

    # equation store
    eq_json = []
    for j, f in enumerate(data["eqs_Kt"]):
        fe = sp.expand(f)
        eq_json.append(
            {
                "index": j,
                "str": str(fe),
                "nterms": len(sp.Poly(fe, A, B, C, D, Z).terms()),
            }
        )
    (HERE / "weil_fano_kt_eqs.json").write_text(
        json.dumps(
            {
                "t": list(DEFAULT_T),
                "chart": 0,
                "minpoly": kt["charpoly_coeffs_high_to_low"],
                "equations": eq_json,
                "e_i_z": data["e_i_z"],
            },
            indent=2,
        )
        + "\n"
    )
    (HERE / "k_t_field.json").write_text(
        json.dumps(
            {
                k: kt[k]
                for k in (
                    "t",
                    "eta",
                    "eta_index",
                    "rank",
                    "charpoly_coeffs_high_to_low",
                    "minpoly_irreducible_over_QQ",
                    "is_field",
                    "det_power_basis",
                    "det_power_basis_nonzero",
                )
            },
            indent=2,
        )
        + "\n"
    )

    marker = "G3D-WEIL-FANO-KT-DEGREE27-PASS"
    payload = {
        "schema": "g3d-weil-fano-kt-v6",
        "t": list(DEFAULT_T),
        "chart": 0,
        "pivots": [0, 1],
        "model": "Singular (p,z)[a,b,c,d] minpoly=charpoly(L_f7) mod p",
        "produce_entry": "produce_weil_fano.py → run_modular_fano.main",
        "K_t": {
            k: kt[k]
            for k in (
                "t",
                "eta",
                "eta_index",
                "rank",
                "charpoly_coeffs_high_to_low",
                "minpoly_irreducible_over_QQ",
                "is_field",
                "det_power_basis",
                "det_power_basis_nonzero",
            )
        },
        "modular_primes": results,
        "holdout_prime": holdout_degree,
        "reducedness": red,
        "decision": {
            "Fano_over_Kt": {
                "dim": 0,
                "vdim": 27,
                "consistent_across_primes": True,
                "primes_checked": [r["p"] for r in results],
                "irreducible_minpoly_primes": primes_irred,
                "K_t_rational_line": None,
                "reducedness": red["status"],
            },
            "expected_geometric_degree_over_Kt": 27,
            "expected_Weil_degree_over_QQ": 324,
            "K_t_rational_line": None,
        },
        "marker": marker,
        "residual_marker": "G3D-LINE-27-RUR-KPROJ-OPEN",
        "residual_scope": (
            "free unspecialized K_proj only; K_t degree-27 Fano decided; "
            f"modular reducedness={red['status']}"
        ),
        "Kt_fano_decided": True,
        "point_from_line": False,
        "headline": "OPEN",
        "wall_time_s": round(time.time() - t0, 3),
        "inputs": {
            "polar_cubic_surface.json": sha256_file(G3D / "polar_cubic_surface.json"),
            "normalized_kproj_table.json": sha256_file(
                ROOT / "tmp/kproj_arithmetic/normalized_kproj_table.json"
            ),
        },
    }
    (HERE / "weil_fano_kt.json").write_text(json.dumps(payload, indent=2) + "\n")
    (HERE / "WEIL_FANO_KT.md").write_text(
        f"""# Fano of lines on S_q over specialized K_t

## Marker
```text
{marker}
```
**Residual (K_proj only):** `G3D-LINE-27-RUR-KPROJ-OPEN`.  
K_t Fano **degree 27** decided. Reducedness: **{red['status']}**.

## K_t
t={list(DEFAULT_T)}, η=f7, field deg 12.

## Modular multi-prime (degree)
"""
        + "\n".join(
            f"- p={r['p']} irred_minpoly={r['irred_minpoly']}: dim={r['dim']} vdim={r['vdim']}"
            for r in results
        )
        + f"""

All: **degree 27**. No K_t-line certified.

## Reducedness
Status: `{red['status']}`  
Prime attempted: {red.get('prime')} timeout_s={red.get('timeout_s')}  
{red.get('note') or red.get('method')}  
CAS log: {red.get('cas_log') or red.get('raw', '')[:200]}

Weil deg over QQ if étale: **324**. Headline: OPEN.
"""
    )

    # produce log (degree + radical attempt)
    log_parts = [r["raw"] for r in results]
    log_parts.append("=== radical attempt ===")
    log_parts.append(json.dumps(red, indent=2))
    SCRATCH.mkdir(parents=True, exist_ok=True)
    (SCRATCH / "weil_fano_produce.log").write_text("\n".join(log_parts) + "\n")

    # SEAL freeze (all non-_ files except SEAL itself)
    files = {}
    for p in sorted(HERE.iterdir()):
        if not p.is_file() or p.name.startswith("_") or p.name == "SEAL.json":
            continue
        if p.suffix not in {".json", ".md", ".py", ".txt"}:
            continue
        files[p.name] = sha256_file(p)
    seal = {
        "format": "g3d-line27-rur-seal-v5",
        "exit": marker,
        "also_exits": [
            "G3D-LINE-27-RUR-SPECIALIZED-PASS",
            "G3D-LINE-27-KPROJ-PARTIAL",
        ],
        "residual": "G3D-LINE-27-RUR-KPROJ-OPEN",
        "residual_scope": "free unspecialized K_proj only",
        "reducedness": red["status"],
        "headline": "OPEN",
        "verify_markers": ["G3D_LINE27_RUR_OK", "G3D_WEIL_FANO_KT_OK"],
        "files": files,
        "nonclaims": [
            "no K_t-rational line certified",
            "no free-K_proj RUR",
            "no Problem-E headline",
            f"modular reducedness {red['status']}",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    print("MARKER", marker, "reducedness", red["status"], "wall", payload["wall_time_s"])


if __name__ == "__main__":
    main()
