#!/usr/bin/env python3
"""P25V.1 — deterministic compressed kernel incidence over F_89.

Builds C @ seed_F3 for compression ranks 64, 72, 84 with fixed seed
2026073189, writes Macaulay2 / msolve inputs, and drives multihomogeneous
saturation. Stops at the first empty compressed incidence with an accepted
certificate form.

Writes only under certificates/degree25_p25v/ and tmp/p25v_incidence/.
"""
from __future__ import annotations

import json
import subprocess
import sys
import time
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
FM = ROOT / "certificates" / "degree25_finite_module"
TMP = ROOT / "tmp" / "p25v_incidence"
HERE.mkdir(parents=True, exist_ok=True)
TMP.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89
SEED_RNG = 2026073189
M2 = "/opt/homebrew/bin/M2"
MSOLVE = "/opt/homebrew/bin/msolve"


def compression_matrix(r: int) -> np.ndarray:
    rng = np.random.default_rng(SEED_RNG)
    Cmat = rng.integers(0, P, size=(r, 690), dtype=np.int64)
    if C.rank_mod(Cmat, P) < r:
        Cmat = np.eye(r, 690, dtype=np.int64)
        Cmat = (Cmat + rng.integers(0, P, size=(r, 690))) % P
    assert C.rank_mod(Cmat, P) == r
    return Cmat % P


def monom_str(exps: tuple[int, ...], names: list[str]) -> str:
    parts = []
    for e, n in zip(exps, names):
        if e == 0:
            continue
        if e == 1:
            parts.append(n)
        else:
            parts.append(f"{n}^{e}")
    return "*".join(parts) if parts else "1"


def write_m2_system(r: int, compressed: np.ndarray, off3: np.ndarray, path: Path) -> None:
    """Write a Macaulay2 script for bihomogeneous saturation of r equations."""
    qnames = [f"q{i}" for i in range(37)]
    bnames = [f"b{i}" for i in range(28)]
    # Bidegrees for ring
    # q: {1,0}, b0: {0,1}, b1: {1,1}, b2: {2,1}
    deg_list = []
    for i in range(37):
        deg_list.append("{1,0}")
    deg_list.append("{0,1}")  # b0
    for _ in range(6):
        deg_list.append("{1,1}")
    for _ in range(21):
        deg_list.append("{2,1}")

    m1 = C.weak_compositions(1, 37)
    m2 = C.weak_compositions(2, 37)
    m3 = C.weak_compositions(3, 37)

    lines = []
    lines.append(f"-- P25V.1 compressed incidence r={r}, p={P}")
    lines.append(f"p = {P};")
    lines.append(
        "R = (ZZ/p)["
        + ",".join(qnames + bnames)
        + ", Degrees => {"
        + ",".join(deg_list)
        + "}, MonomialOrder => GRevLex];"
    )
    lines.append("qideal = ideal(" + ",".join(qnames) + ");")
    lines.append("bideal = ideal(" + ",".join(bnames) + ");")

    # Build equations as strings — each eq is sum over basis components
    # compressed[a, :] is F3 polyvector length 14134
    eqs = []
    for a in range(r):
        terms = []
        row = compressed[a].astype(np.int64) % P
        # b0 component: S_3 coeffs * b0
        block = row[int(off3[0]) : int(off3[1])]
        for mi, coeff in enumerate(block):
            coeff = int(coeff) % P
            if not coeff:
                continue
            ms = monom_str(m3[mi], qnames)
            if coeff == 1:
                terms.append(f"({ms})*b0")
            else:
                terms.append(f"{coeff}*({ms})*b0")
        # b1 components
        for bi in range(6):
            block = row[int(off3[1 + bi]) : int(off3[2 + bi])]
            bn = f"b{1+bi}"
            for mi, coeff in enumerate(block):
                coeff = int(coeff) % P
                if not coeff:
                    continue
                ms = monom_str(m2[mi], qnames)
                if coeff == 1:
                    terms.append(f"({ms})*{bn}")
                else:
                    terms.append(f"{coeff}*({ms})*{bn}")
        # b2 components
        for bi in range(21):
            block = row[int(off3[7 + bi]) : int(off3[8 + bi])]
            bn = f"b{7+bi}"
            for mi, coeff in enumerate(block):
                coeff = int(coeff) % P
                if not coeff:
                    continue
                ms = monom_str(m1[mi], qnames)
                if coeff == 1:
                    terms.append(f"({ms})*{bn}")
                else:
                    terms.append(f"{coeff}*({ms})*{bn}")
        if not terms:
            eqs.append("0")
        else:
            eqs.append(" + ".join(terms))

    lines.append("eqs = {")
    for i, e in enumerate(eqs):
        comma = "," if i + 1 < len(eqs) else ""
        lines.append(f"  {e}{comma}")
    lines.append("};")
    lines.append("I = ideal eqs;")
    lines.append(f'load "{TMP / f"saturate_r{r}.m2"}";')
    path.write_text("\n".join(lines) + "\n")
    print(f"wrote M2 generators {path} ({path.stat().st_size/1e6:.1f} MB)", flush=True)


def write_m2_saturate(r: int) -> Path:
    """Driver that saturates and writes a certificate JSON."""
    out_json = TMP / f"sat_r{r}_result.json"
    out_m2 = TMP / f"saturate_r{r}.m2"
    # Use stepwise saturation; record dims / whether unit ideal.
    # Also try chart b0=1 (survivors must have b0≠0 or b1≠0; Stage A kills b0=b1=0).
    script = f"""
-- saturation driver r={r}
setRandomSeed 2026073189;
t0 = cpuTime();
-- Full multiprojective saturation by product of irrelevants
try (
  J = saturate(I, qideal * bideal);
  isUnit = (J == ideal(1_R));
  -- also record gens count
  nGens = numgens J;
  codimJ = codim J;
) else (
  isUnit = false;
  nGens = -1;
  codimJ = -1;
);

-- Chart A: b0 = 1 (affine in b, still multi in q-projective via saturate qideal)
try (
  R1 = (ZZ/{P})[q0..q36, b1..b27, MonomialOrder => GRevLex];
  phi1 = map(R1, R, gens R1 | {{1_R1}} | drop(gens R1, 37));
  -- careful: R has q0..q36,b0..b27; R1 has q0..q36,b1..b27
  -- substitute b0=>1
  subs1 = apply(gens R, g -> if toString g == "b0" then 1_R1 else sub(g, R1));
  phi1 = map(R1, R, subs1);
  I1 = phi1 I;
  J1 = saturate(I1, ideal(q0..q36));
  unit1 = (J1 == ideal(1_R1));
  n1 = numgens J1;
) else (
  unit1 = false; n1 = -1;
);

-- Chart B: b0=0, b1=1
try (
  R2 = (ZZ/{P})[q0..q36, b2..b27, MonomialOrder => GRevLex];
  subs2 = apply(gens R, g -> (
    s = toString g;
    if s == "b0" then 0_R2
    else if s == "b1" then 1_R2
    else sub(g, R2)
  ));
  phi2 = map(R2, R, subs2);
  I2 = phi2 I;
  J2 = saturate(I2, ideal(q0..q36));
  unit2 = (J2 == ideal(1_R2));
  n2 = numgens J2;
) else (
  unit2 = false; n2 = -1;
);

elapsed = cpuTime() - t0;
f = openOut "{out_json}";
f << "{{\\"r\\": {r}, \\"prime\\": {P}, \\"is_unit_saturated\\": " << (if isUnit then "true" else "false")
  << ", \\"n_gens_sat\\": " << nGens
  << ", \\"codim_sat\\": " << codimJ
  << ", \\"chart_b0_1_unit\\": " << (if unit1 then "true" else "false")
  << ", \\"chart_b0_1_ngens\\": " << n1
  << ", \\"chart_b0_0_b1_1_unit\\": " << (if unit2 then "true" else "false")
  << ", \\"chart_b0_0_b1_1_ngens\\": " << n2
  << ", \\"elapsed_cpu\\": " << elapsed
  << "}}" << endl;
close f;
<<"RESULT isUnit="<<isUnit<<" unit1="<<unit1<<" unit2="<<unit2<<" t="<<elapsed<<endl;
"""
    out_m2.write_text(script)
    return out_m2


def write_chart_msolve(r: int, compressed: np.ndarray, off3: np.ndarray) -> list[Path]:
    """Write msolve inputs for affine charts (b0=1) and (b0=0,b1=1), dehomogenized q0=1."""
    paths = []
    m1 = C.weak_compositions(1, 37)
    m2 = C.weak_compositions(2, 37)
    m3 = C.weak_compositions(3, 37)

    def poly_terms(row, b0_val, b1_val, fix_q0_one: bool):
        """Return list of monomial strings in remaining variables.
        Variables order for msolve: remaining q's then remaining b's.
        """
        # Variable naming for msolve: x0.. 
        # Chart b0=1: vars = q0..q36 (37) + b1..b27 (27) = 64 vars; or q1..q36 if q0=1
        terms = []  # list of (coeff, exp_tuple on full remaining var list)
        return terms  # filled below in specialized writers

    # --- Chart A: b0=1, keep all q projective via several dehomogenizations ---
    # Use q0=1 dehomogenization as one affine chart of P^36
    # vars: q1..q36 (36) + b1..b27 (27) = 63
    for chart_name, b0v, bfix_fixed in [("b0eq1_q0eq1", 1, None), ("b0eq0_b1eq1_q0eq1", 0, 1)]:
        # remaining b indices
        if b0v == 1:
            b_remain = list(range(1, 28))  # b1..b27
            n_b = 27
        else:
            b_remain = list(range(2, 28))  # b2..b27
            n_b = 26
        # q1..q36 (q0=1)
        n_q = 36
        nvars = n_q + n_b
        # Build polynomials as coeff dicts
        polys = []
        for a in range(r):
            row = compressed[a].astype(np.int64) % P
            acc: dict[tuple[int, ...], int] = {}

            def add_term(coeff: int, qexp: tuple[int, ...], b_idx_in_remain: int | None, b_coeff_one: bool = True):
                # qexp is length-37; with q0=1 drop q0 power into coeff (q0=1 so ignore)
                if qexp[0] < 0:
                    return
                # remaining q exp: q1..q36
                e_q = list(qexp[1:])
                e_b = [0] * n_b
                if b_idx_in_remain is not None:
                    e_b[b_idx_in_remain] = 1
                key = tuple(e_q + e_b)
                acc[key] = (acc.get(key, 0) + coeff) % P

            # b0 component
            block = row[int(off3[0]) : int(off3[1])]
            for mi, coeff in enumerate(block):
                coeff = int(coeff) % P
                if not coeff:
                    continue
                if b0v == 0:
                    continue  # term has b0=0
                # coeff * m3 * b0, b0=1
                add_term(coeff, m3[mi], None)
            # b1 components
            for bi in range(6):
                block = row[int(off3[1 + bi]) : int(off3[2 + bi])]
                for mi, coeff in enumerate(block):
                    coeff = int(coeff) % P
                    if not coeff:
                        continue
                    b_global = 1 + bi
                    if b0v == 0 and bfix_fixed == 1 and b_global == 1:
                        # b1=1
                        add_term(coeff, m2[mi], None)
                    elif b0v == 1:
                        # b1..b27 are variables; b_global 1..6 → remain index bi
                        add_term(coeff, m2[mi], bi)
                    elif b0v == 0 and b_global >= 2:
                        # remain: b2..b27 → index b_global-2
                        add_term(coeff, m2[mi], b_global - 2)
                    # if b0v==0 and b_global==1: already handled
            # b2
            for bi in range(21):
                block = row[int(off3[7 + bi]) : int(off3[8 + bi])]
                for mi, coeff in enumerate(block):
                    coeff = int(coeff) % P
                    if not coeff:
                        continue
                    b_global = 7 + bi
                    if b0v == 1:
                        # remain b1..b27: index = b_global - 1
                        add_term(coeff, m1[mi], b_global - 1)
                    else:
                        # remain b2..b27: index = b_global - 2
                        add_term(coeff, m1[mi], b_global - 2)
            # convert acc to msolve poly
            poly_terms = []
            for exps, coeff in acc.items():
                coeff = coeff % P
                if not coeff:
                    continue
                # msolve format: coeff*x0^e0*... or just list
                poly_terms.append((coeff, exps))
            polys.append(poly_terms)

        # Write msolve input (ms format)
        ms_path = TMP / f"chart_{chart_name}_r{r}.ms"
        with ms_path.open("w") as f:
            f.write("#msolve file\n")
            f.write(f"{nvars}\n")  # nvars
            f.write(f"{P}\n")  # field char
            # variable names optional in some versions — use plain poly list
            for pi, poly in enumerate(polys):
                if not poly:
                    f.write("0")
                else:
                    parts = []
                    for coeff, exps in poly:
                        mon = "*".join(
                            f"x{k}" if e == 1 else f"x{k}^{e}"
                            for k, e in enumerate(exps)
                            if e
                        )
                        if not mon:
                            mon = "1"
                        if coeff == 1:
                            parts.append(mon)
                        else:
                            parts.append(f"{coeff}*{mon}")
                    f.write("+".join(parts) if parts else "0")
                if pi + 1 < len(polys):
                    f.write(",\n")
                else:
                    f.write("\n")
        paths.append(ms_path)
        print(f"wrote msolve {ms_path} nvars={nvars} neq={r} size={ms_path.stat().st_size/1e6:.2f}MB", flush=True)
    return paths


def run_m2(r: int, gen_file: Path, timeout: int = 7200) -> dict:
    sat = write_m2_saturate(r)
    # Combine: load generators then saturate
    driver = TMP / f"run_r{r}.m2"
    driver.write_text(
        f"""
load "{gen_file}";
load "{sat}";
"""
    )
    log = TMP / f"m2_r{r}.log"
    cmd = [M2, "--no-prompts", "--stop", "-e", f'load "{driver}"']
    print(f"running M2 r={r}: {' '.join(cmd)}", flush=True)
    t0 = time.time()
    try:
        proc = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=timeout,
            cwd=str(ROOT),
        )
        log.write_text(proc.stdout + "\n--- STDERR ---\n" + proc.stderr)
        print(f"M2 exit={proc.returncode} t={time.time()-t0:.1f}s", flush=True)
        print(proc.stdout[-2000:] if proc.stdout else "", flush=True)
    except subprocess.TimeoutExpired as e:
        log.write_text(f"TIMEOUT after {timeout}s\n{e}")
        return {"error": "timeout", "r": r}
    out_json = TMP / f"sat_r{r}_result.json"
    if out_json.exists():
        return json.loads(out_json.read_text())
    return {"error": "no_result_json", "r": r, "log": str(log)}


def main() -> None:
    t0 = time.time()
    peak = C.rss_mib()
    print("=== P25V.1 compressed incidence produce ===", flush=True)

    rel = np.load(FM / "relation_matrix.npz")
    seed = rel["seed_F3"].astype(np.int64) % P
    off3 = rel["off3"]
    seed_sha = C.sha256_arr(rel["seed_F3"])

    # Preflight based on compressed incidence (not forbidden 43-var matrix)
    preflight = {
        "dispatch": "P25V.1-preflight",
        "prime": P,
        "compression_seed_rng": SEED_RNG,
        "order": [64, 72, 84],
        "system": {
            "bidegree": [3, 1],
            "n_q": 37,
            "n_b": 28,
            "full_seed_equations": 690,
            "stageA": "P25W-STAGEA-EMPTY (b0=b1=0 empty; survivors need b0≠0 or b1≠0)",
        },
        "resource": {
            "budget_gib": 64,
            "measured_floor_gib_r64": 16,
            "method": "M2 multihomogeneous saturate + affine charts; msolve chart backup",
            "forbidden": "43-variable degree-four F4/Macaulay",
        },
        "inputs": {
            "seed_F3_sha256": seed_sha,
            "relation_matrix": str(FM / "relation_matrix.npz"),
        },
    }
    C.write_json_self_hash(HERE / "preflight_incidence.json", preflight)
    print("wrote preflight_incidence.json", flush=True)

    results = {}
    for r in (64, 72, 84):
        print(f"\n=== compression r={r} ===", flush=True)
        Cmat = compression_matrix(r)
        compressed = (Cmat @ seed) % P  # r × 14134
        assert compressed.shape == (r, 14134)
        csha = C.sha256_arr(compressed.astype(np.uint8))
        np.savez_compressed(
            TMP / f"compression_r{r}.npz",
            C=Cmat.astype(np.uint8),
            compressed=compressed.astype(np.uint8),
            seed_rng=np.int64(SEED_RNG),
            prime=np.int32(P),
        )
        print(f"compressed sha={csha} rss={C.rss_mib():.0f}", flush=True)

        gen_file = TMP / f"gens_r{r}.m2"
        write_m2_system(r, compressed, off3, gen_file)
        write_chart_msolve(r, compressed, off3)

        # Run M2 saturation (heavy)
        res = run_m2(r, gen_file, timeout=10800)
        res["compressed_sha256"] = csha
        res["C_sha256"] = C.sha256_arr(Cmat.astype(np.uint8))
        results[str(r)] = res
        peak = max(peak, C.rss_mib())

        # Stop at first empty certificate
        if res.get("is_unit_saturated") or (
            res.get("chart_b0_1_unit") and res.get("chart_b0_0_b1_1_unit")
        ):
            print(f"EMPTY certificate at r={r}", flush=True)
            break
        print(f"r={r} not yet empty: {res}", flush=True)

    elapsed = time.time() - t0
    peak = max(peak, C.rss_mib())
    payload = {
        "dispatch": "P25V.1",
        "prime": P,
        "compression_seed_rng": SEED_RNG,
        "results": results,
        "resource": {
            "peak_rss_mib": peak,
            "elapsed_seconds": elapsed,
            "budget_gib": 64,
        },
        "inputs": {
            "seed_F3_sha256": seed_sha,
        },
    }
    C.write_json_self_hash(HERE / "incidence_raw_results.json", payload)
    print(f"DONE incidence raw results t={elapsed:.1f}s peak={peak:.0f} MiB", flush=True)


if __name__ == "__main__":
    main()
