#!/usr/bin/env python3
"""H5 modular residual fibration probe (discovery only).

Consumes the sealed H4/H5 trace-cubic model and samples residual fibrations
obtained by projecting specialized fibres from the degree-five eigenpoint
orbit (index-one geometry).  Records statistics of singular cubics, residual
fibre types, Monte-Carlo / exact point counts, and local solubility over
several primes including holdout 199.

STATUS marker: H5-UNDECIDED.  No pointlessness claim.  No headline.

Stdlib only.  Light memory budget.
"""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path
import random
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H4 = ROOT / "goal_runs_after_35fa" / "H_11_5_TWIST"
H5 = ROOT / "goal_runs_after_bd610a" / "H5_11_5_TRACE_CUBIC"
GOAL = ROOT / "goals_after_bd610a" / "GOAL_H5_11_5_TRACE_CUBIC_DECISION.md"
PINNED = "bd610a032bb9561d2daeb91a2cb60c48c082ca2f"

H4_EXPECTED = {
    "field_model.json": "80fdc908633595d6bb3c292d0027aa66295a850b9b6a12cc473f90e3e373ba1e",
    "twist_model.json": "9a5f69b43de4b33aa0185b4714e23bc177b12f74a529510b0b8b4b9ab5e49a11",
    "norm_model.json": "1f61adc24bc15bf296b7199f4e13dfa5f538691984d6f623efa8feb9531dc49e",
    "decision.json": "2517208d05c71d7493a6b606d8460c13e41bb409077a7dfb385da99eb443a592",
    "SEAL.json": "9b790a67185edc94be385993276ea4b4e35a6cfba4739981c083dd6d9886eb25",
}

# Discovery primes (holdout 199 last).
PRIMES = (31, 41, 61, 71, 89, 101, 131, 151, 181, 199)

# Sample budgets (kept light).
SPECS_PER_PRIME = 24
FIBRE_DIRS_PER_SPEC = 120
POINT_MC_SAMPLES = 4000
SINGULAR_MC_SAMPLES = 2500
EXACT_COUNT_MAX_P = 41
SEED = 20260802


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def write_json(name: str, value: object) -> None:
    (HERE / name).write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def mod_inv(x: int, p: int) -> int:
    return pow(x, -1, p)


def legendre(a: int, p: int) -> int:
    """Legendre symbol (a/p) in {-1,0,1}."""
    return pow(a % p, (p - 1) // 2, p) if a % p else 0


def random_r(p: int, rng: random.Random) -> list[int] | None:
    for _ in range(8000):
        head = [rng.randrange(1, p) for _ in range(4)]
        prod = 1
        for x in head:
            prod = prod * x % p
        r = head + [mod_inv(prod, p)]
        if 0 not in r and len(set(r)) == 5:
            return r
    return None


def coefficients_c(r: list[int], p: int) -> list[int]:
    """c_i = 1/r_{i+2} so G(x)=sum c_i x_i^2 x_{i+1} equals the specialized Phi."""
    return [mod_inv(r[(i + 2) % 5], p) for i in range(5)]


def G(x: list[int], c: list[int], p: int) -> int:
    total = 0
    for i in range(5):
        total = (total + c[i] * (x[i] * x[i] % p) * x[(i + 1) % 5]) % p
    return total


def grad_G(x: list[int], c: list[int], p: int) -> list[int]:
    """Partial derivatives: dG/dx_j = 2 c_j x_j x_{j+1} + c_{j-1} x_{j-1}^2."""
    out = []
    for j in range(5):
        term = (
            (2 * c[j] * x[j] * x[(j + 1) % 5]) % p
            + (c[(j - 1) % 5] * (x[(j - 1) % 5] * x[(j - 1) % 5] % p)) % p
        ) % p
        out.append(term)
    return out


def phi_from_orbit(avals: list[int], r: list[int], p: int) -> int:
    total = 0
    for i in range(5):
        total = (
            total
            + mod_inv(r[(i + 2) % 5], p)
            * (avals[i] * avals[i] % p)
            * avals[(i + 1) % 5]
        ) % p
    return total


def eval_Z_orbit(z: list[int], r: list[int], p: int) -> list[int]:
    return [sum(z[j] * pow(r[i], j, p) for j in range(5)) % p for i in range(5)]


def residual_binary_from_e0(
    direction: list[int], c: list[int], p: int
) -> tuple[int, int, int]:
    """Projection from eigenpoint e0=(1,0,0,0,0).

    Line: x = (s, t*a, t*b, t*c, t*d) with direction (a,b,c,d) in A^4 \\ {0}.
    Residual binary form A s^2 + B s t + C t^2 after factoring the t-root at e0:

        A = c0 * a
        B = c4 * d^2
        C = c1 a^2 b + c2 b^2 c + c3 c^2 d
    """
    a, b, cc, d = direction  # cc avoids shadowing coefficients_c
    A = c[0] * a % p
    B = c[4] * (d * d % p) % p
    C = (
        c[1] * (a * a % p) % p * b
        + c[2] * (b * b % p) % p * cc
        + c[3] * (cc * cc % p) % p * d
    ) % p
    return A, B, C


def residual_binary_from_em(
    m: int, direction: list[int], c: list[int], p: int
) -> tuple[int, int, int]:
    """Cyclically rotate so projection is from e_m; direction is 4-tuple in the
    complementary coordinates (ordered cyclically after m)."""
    # Rotate c so index 0 corresponds to m.
    c_rot = [c[(m + i) % 5] for i in range(5)]
    return residual_binary_from_e0(direction, c_rot, p)


def classify_binary(A: int, B: int, C: int, p: int) -> str:
    if A == 0 and B == 0 and C == 0:
        return "contained_line"
    disc = (B * B - 4 * A * C) % p
    if disc == 0:
        return "singular_double"
    leg = legendre(disc, p)
    if leg == 1:
        return "split"
    return "nonsplit"


def random_direction(p: int, rng: random.Random) -> list[int]:
    for _ in range(100):
        d = [rng.randrange(p) for _ in range(4)]
        if any(d):
            return d
    return [1, 0, 0, 0]


def random_proj_point(dim: int, p: int, rng: random.Random) -> list[int]:
    """Random point in P^{dim} as affine (dim+1)-tuple with not-all-zero."""
    for _ in range(100):
        v = [rng.randrange(p) for _ in range(dim + 1)]
        if any(v):
            return v
    v = [0] * (dim + 1)
    v[0] = 1
    return v


def projective_point_count_exact(c: list[int], p: int) -> int:
    """Exact # of F_p-points of G=0 in P^4.  Only for small p."""
    count = 0
    # Normalize first nonzero coordinate to 1.
    # Chart x0=1
    for x1 in range(p):
        for x2 in range(p):
            for x3 in range(p):
                for x4 in range(p):
                    if G([1, x1, x2, x3, x4], c, p) == 0:
                        count += 1
    # x0=0, x1=1
    for x2 in range(p):
        for x3 in range(p):
            for x4 in range(p):
                if G([0, 1, x2, x3, x4], c, p) == 0:
                    count += 1
    # x0=x1=0, x2=1
    for x3 in range(p):
        for x4 in range(p):
            if G([0, 0, 1, x3, x4], c, p) == 0:
                count += 1
    # x0=x1=x2=0, x3=1
    for x4 in range(p):
        if G([0, 0, 0, 1, x4], c, p) == 0:
            count += 1
    # x0=x1=x2=x3=0, x4=1
    if G([0, 0, 0, 0, 1], c, p) == 0:
        count += 1
    return count


def monte_carlo_point_rate(c: list[int], p: int, rng: random.Random, n: int) -> dict:
    hits = 0
    for _ in range(n):
        x = random_proj_point(4, p, rng)
        if G(x, c, p) == 0:
            hits += 1
    return {
        "samples": n,
        "hits": hits,
        "hit_rate": hits / n if n else None,
        # Unbiased estimator of #X(F_p): rate * #P^4(F_p)
        "estimated_point_count": None
        if n == 0
        else hits / n * (p**4 + p**3 + p**2 + p + 1),
    }


def search_singular_point(
    c: list[int], p: int, rng: random.Random, n: int
) -> dict:
    """Heuristic search for a nonzero x with grad G(x)=0."""
    for _ in range(n):
        x = [rng.randrange(p) for _ in range(5)]
        if not any(x):
            continue
        g = grad_G(x, c, p)
        if all(t == 0 for t in g):
            return {"found": True, "point": x, "method": "monte_carlo"}
    # Also check the five eigenpoints e_m: grad at e_m.
    for m in range(5):
        x = [0] * 5
        x[m] = 1
        g = grad_G(x, c, p)
        if all(t == 0 for t in g):
            return {"found": True, "point": x, "method": "eigenpoint"}
    return {"found": False, "method": "monte_carlo", "samples": n}


def eigenpoints_on_cubic(c: list[int], p: int) -> list[bool]:
    """e_m lies on G=0 for every m when c are from product-one r (always true)."""
    out = []
    for m in range(5):
        x = [0] * 5
        x[m] = 1
        out.append(G(x, c, p) == 0)
    return out


def probe_one_specialization(
    r: list[int], p: int, rng: random.Random
) -> dict:
    c = coefficients_c(r, p)
    # Sanity: specialized Phi via z-orbit equals G on evaluations.
    # Eigenpoints on cubic.
    on_cubic = eigenpoints_on_cubic(c, p)
    assert all(on_cubic), (r, p, on_cubic)

    # Residual fibre census from each of the five eigenpoints.
    fibre_totals = {
        "contained_line": 0,
        "singular_double": 0,
        "split": 0,
        "nonsplit": 0,
    }
    fibre_per_eigen: list[dict] = []
    sample_fibres: list[dict] = []
    for m in range(5):
        counts = {k: 0 for k in fibre_totals}
        for _ in range(FIBRE_DIRS_PER_SPEC):
            direction = random_direction(p, rng)
            A, B, C = residual_binary_from_em(m, direction, c, p)
            kind = classify_binary(A, B, C, p)
            counts[kind] += 1
            fibre_totals[kind] += 1
            if len(sample_fibres) < 8 and kind in ("contained_line", "singular_double"):
                sample_fibres.append(
                    {
                        "eigen_index": m,
                        "direction": direction,
                        "A": A,
                        "B": B,
                        "C": C,
                        "kind": kind,
                    }
                )
        fibre_per_eigen.append(counts)

    # Local solubility + point counts.
    soluble = False
    sample_point = None
    # Quick search for an F_p-point (beyond the five eigenpoints).
    for m in range(5):
        x = [0] * 5
        x[m] = 1
        if G(x, c, p) == 0:
            soluble = True
            sample_point = x
            break
    if not soluble:
        for _ in range(800):
            x = random_proj_point(4, p, rng)
            if G(x, c, p) == 0:
                soluble = True
                sample_point = x
                break

    if p <= EXACT_COUNT_MAX_P:
        pt = {
            "mode": "exact",
            "point_count": projective_point_count_exact(c, p),
            "P4_order": p**4 + p**3 + p**2 + p + 1,
        }
    else:
        mc = monte_carlo_point_rate(c, p, rng, POINT_MC_SAMPLES)
        pt = {"mode": "monte_carlo", **mc, "P4_order": p**4 + p**3 + p**2 + p + 1}

    sing = search_singular_point(c, p, rng, SINGULAR_MC_SAMPLES)

    # z-model cross-check: random z with Phi=0 exists?
    z_hit = None
    for _ in range(400):
        z = [rng.randrange(p) for _ in range(5)]
        if all(t == 0 for t in z):
            continue
        if phi_from_orbit(eval_Z_orbit(z, r, p), r, p) == 0:
            z_hit = z
            break

    return {
        "r": r,
        "c": c,
        "eigenpoints_on_cubic": on_cubic,
        "locally_soluble": soluble,
        "sample_Fp_point": sample_point,
        "sample_z_phi_zero": z_hit,
        "point_stats": pt,
        "singular_search": sing,
        "residual_fibre_totals": fibre_totals,
        "residual_fibre_per_eigenpoint": fibre_per_eigen,
        "residual_dirs_per_eigen": FIBRE_DIRS_PER_SPEC,
        "sample_special_fibres": sample_fibres,
    }


def summarize_prime(p: int, rows: list[dict]) -> dict:
    n = len(rows)
    soluble_n = sum(1 for r in rows if r["locally_soluble"])
    singular_n = sum(1 for r in rows if r["singular_search"]["found"])
    fibre_sum = {
        "contained_line": 0,
        "singular_double": 0,
        "split": 0,
        "nonsplit": 0,
    }
    for r in rows:
        for k, v in r["residual_fibre_totals"].items():
            fibre_sum[k] += v
    total_fibres = sum(fibre_sum.values()) or 1
    fibre_rates = {k: fibre_sum[k] / total_fibres for k in fibre_sum}

    exact_counts = [
        r["point_stats"]["point_count"]
        for r in rows
        if r["point_stats"].get("mode") == "exact"
    ]
    mc_estimates = [
        r["point_stats"]["estimated_point_count"]
        for r in rows
        if r["point_stats"].get("mode") == "monte_carlo"
        and r["point_stats"].get("estimated_point_count") is not None
    ]

    # Mean split rate among non-contained fibres (rough solubility of residual).
    non_contained = total_fibres - fibre_sum["contained_line"]
    residual_split_rate = (
        fibre_sum["split"] / non_contained if non_contained else None
    )

    return {
        "prime": p,
        "specializations": n,
        "locally_soluble_count": soluble_n,
        "locally_soluble_rate": soluble_n / n if n else None,
        "singular_cubic_heuristic_count": singular_n,
        "singular_cubic_heuristic_rate": singular_n / n if n else None,
        "residual_fibre_counts": fibre_sum,
        "residual_fibre_rates": fibre_rates,
        "residual_split_rate_among_noncontained": residual_split_rate,
        "exact_point_counts": exact_counts,
        "exact_point_count_mean": (
            sum(exact_counts) / len(exact_counts) if exact_counts else None
        ),
        "mc_point_count_estimates_mean": (
            sum(mc_estimates) / len(mc_estimates) if mc_estimates else None
        ),
        "P4_order": p**4 + p**3 + p**2 + p + 1,
        "holdout": p == 199,
    }


def build_manifest(h4_hashes: dict[str, str], h5_hashes: dict[str, str]) -> dict:
    return {
        "format": "H5-FIBRATION-PROBE-INPUT-MANIFEST-v1",
        "pinned_state": PINNED,
        "role": "discovery modular residual fibration probe; not a decision packet",
        "inputs": {
            "goal": {
                "path_relative_to_problem": "goals_after_bd610a/GOAL_H5_11_5_TRACE_CUBIC_DECISION.md",
                "sha256": digest(GOAL),
            },
            "h4_seal": {
                "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/SEAL.json",
                "sha256": h4_hashes["SEAL.json"],
                "exit": "H-11_5-NORM-MODEL-PASS",
            },
            "h4_norm_model": {
                "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/norm_model.json",
                "sha256": h4_hashes["norm_model.json"],
                "degree_five_point": "Z0(T)=prod_(k=1)^4(T-r_k) -> eigenpoint orbit",
            },
            "h4_twist_model": {
                "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/twist_model.json",
                "sha256": h4_hashes["twist_model.json"],
            },
            "h4_field_model": {
                "path_relative_to_problem": "goal_runs_after_35fa/H_11_5_TWIST/field_model.json",
                "sha256": h4_hashes["field_model.json"],
            },
            "h5_status": {
                "path_relative_to_problem": "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/STATUS.md",
                "sha256": h5_hashes.get("STATUS.md"),
                "exit": "H5-UNDECIDED",
            },
            "h5_trace_cubic": {
                "path_relative_to_problem": "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/TRACE_CUBIC.json",
                "sha256": h5_hashes.get("TRACE_CUBIC.json"),
            },
        },
        "geometry": {
            "specialized_equation": "G(x)=sum_{i} (1/r_{i+2}) x_i^2 x_{i+1} = 0 in P^4",
            "equivalence": "G(Z(r_0),...,Z(r_4))=Phi(z) on the Vandermonde open",
            "degree_five_orbit": "when r_i in F_p distinct, eigenpoints e_0..e_4 lie on G",
            "residual_fibration": (
                "project from e_m; lines through e_m form P^3; residual is binary "
                "quadratic A s^2 + B s t + C t^2 with disc = B^2-4AC"
            ),
            "fibre_types": [
                "contained_line (A=B=C=0)",
                "singular_double (disc=0, form nonzero)",
                "split (disc nonzero square)",
                "nonsplit (disc nonsquare)",
            ],
        },
        "not_claimed": [
            "K-rational point on the generic trace cubic",
            "pointlessness of the generic 11:5 twist",
            "any Problem E headline",
            "anisotropic completion",
        ],
    }


def main() -> None:
    t0 = time.time()
    h4_hashes = {name: digest(H4 / name) for name in H4_EXPECTED}
    assert h4_hashes == H4_EXPECTED, (h4_hashes, H4_EXPECTED)

    h5_hashes = {}
    for name in ("STATUS.md", "TRACE_CUBIC.json", "decision.json", "SEAL.json"):
        path = H5 / name
        if path.is_file():
            h5_hashes[name] = digest(path)

    norm = json.loads((H4 / "norm_model.json").read_text())
    assert "degree_five_point" in norm
    assert norm["trace_model"]["equation"].startswith("Phi(z)=Tr_E/K")

    rng = random.Random(SEED)
    per_prime_rows: dict[int, list[dict]] = {}
    summaries = []
    holdout_samples = []

    for p in PRIMES:
        rows = []
        for _ in range(SPECS_PER_PRIME):
            r = random_r(p, rng)
            if r is None:
                continue
            rows.append(probe_one_specialization(r, p, rng))
        per_prime_rows[p] = rows
        summaries.append(summarize_prime(p, rows))
        # Keep a few full rows for independent verifier replay (incl. holdout).
        for row in rows[:3]:
            holdout_samples.append(
                {
                    "prime": p,
                    "r": row["r"],
                    "c": row["c"],
                    "sample_Fp_point": row["sample_Fp_point"],
                    "sample_z_phi_zero": row["sample_z_phi_zero"],
                    "sample_special_fibres": row["sample_special_fibres"],
                    "residual_fibre_totals": row["residual_fibre_totals"],
                    "locally_soluble": row["locally_soluble"],
                    "singular_found": row["singular_search"]["found"],
                    "point_stats_mode": row["point_stats"]["mode"],
                    "point_count_or_estimate": row["point_stats"].get("point_count")
                    if row["point_stats"]["mode"] == "exact"
                    else row["point_stats"].get("estimated_point_count"),
                }
            )

    # Aggregate discovery findings (no verdict).
    all_soluble_rates = [s["locally_soluble_rate"] for s in summaries]
    all_split_rates = [
        s["residual_split_rate_among_noncontained"] for s in summaries
    ]
    findings = {
        "format": "H5-FIBRATION-PROBE-FINDINGS-v1",
        "exit": "H5-UNDECIDED",
        "headline": "OPEN",
        "seed": SEED,
        "primes": list(PRIMES),
        "specializations_per_prime": SPECS_PER_PRIME,
        "fibre_dirs_per_eigenpoint": FIBRE_DIRS_PER_SPEC,
        "summaries_by_prime": summaries,
        "global_notes": {
            "all_sampled_specs_locally_soluble": all(
                s["locally_soluble_count"] == s["specializations"] for s in summaries
            ),
            "min_local_solubility_rate": min(all_soluble_rates) if all_soluble_rates else None,
            "max_local_solubility_rate": max(all_soluble_rates) if all_soluble_rates else None,
            "mean_residual_split_rate_noncontained": (
                sum(x for x in all_split_rates if x is not None)
                / max(1, sum(1 for x in all_split_rates if x is not None))
            ),
            "singular_cubics_seen": sum(
                s["singular_cubic_heuristic_count"] for s in summaries
            ),
            "interpretation": (
                "Specialized residual fibrations from the degree-five eigenpoint "
                "orbit are typically locally soluble over F_p, with a positive "
                "density of split residual fibres and rare contained-line / double "
                "fibres.  This is a modular discovery statistic only; it does not "
                "produce a K-point and does not prove emptiness."
            ),
        },
        "holdout_prime": 199,
        "not_proved": [
            "existence of nonzero a in E with Tr(r2^{-1} a^2 sigma(a))=0 over K",
            "pointlessness of the genuine 11:5 twist over K",
            "any positive or negative Problem E headline",
        ],
    }

    manifest = build_manifest(h4_hashes, h5_hashes)
    model = {
        "format": "H5-FIBRATION-PROBE-MODEL-v1",
        "equation_generic": "Phi(a)=Tr_E/K(r2^{-1} a^2 sigma(a))=0",
        "specialized_G": "G(x)=sum_i c_i x_i^2 x_{i+1}, c_i=1/r_{i+2}",
        "degree_five_point_source": norm["degree_five_point"],
        "index_one_note": (
            "degree-five closed point over K plus degree-three linear section "
            "give index one; neither is a K-point"
        ),
        "projection": {
            "centre": "eigenpoint e_m after specialization (Gal-orbit of Z0)",
            "base": "P^3 of lines through e_m",
            "generic_fibre": "two residual points (binary quadratic)",
            "discriminant": "B^2 - 4 A C on residual form",
        },
        "h4_exit": "H-11_5-NORM-MODEL-PASS",
        "h5_exit_consumed": "H5-UNDECIDED",
    }

    write_json("INPUT_MANIFEST.json", manifest)
    write_json("MODEL.json", model)
    write_json("FINDINGS.json", findings)
    write_json(
        "SAMPLES.json",
        {
            "format": "H5-FIBRATION-PROBE-SAMPLES-v1",
            "role": "replay anchors for independent verifier",
            "seed": SEED,
            "rows": holdout_samples,
        },
    )
    write_json(
        "decision.json",
        {
            "format": "H5-FIBRATION-PROBE-DECISION-v1",
            "exit": "H5-UNDECIDED",
            "headline": "OPEN",
            "pinned_state": PINNED,
            "rational_point_over_K": None,
            "pointlessness": None,
            "probe": "modular residual fibration statistics only",
            "elapsed_seconds": round(time.time() - t0, 3),
        },
    )

    # Human-readable summary table.
    lines = [
        "# H5 modular residual fibration probe — summary",
        "",
        "Discovery only.  Exit: **H5-UNDECIDED**.  Headline: **OPEN**.",
        "",
        "## Geometry",
        "",
        "Specialized equation `G(x)=sum_i (1/r_{i+2}) x_i^2 x_{i+1}` on product-one",
        "`r` with distinct coordinates.  Degree-five eigenpoints `e_m` lie on `G`.",
        "Projection from `e_m` yields residual binary quadrics on lines through `e_m`.",
        "",
        "## Summary by prime",
        "",
        "| p | specs | soluble | sing* | cont.line | double | split | nonsplit | split/(non-cont) | #X est/exact |",
        "|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|",
    ]
    for s in summaries:
        fc = s["residual_fibre_counts"]
        if s["exact_point_counts"]:
            pc = f"{s['exact_point_count_mean']:.1f} exact-mean"
        elif s["mc_point_count_estimates_mean"] is not None:
            pc = f"{s['mc_point_count_estimates_mean']:.0f} MC-mean"
        else:
            pc = "—"
        hold = " (holdout)" if s["holdout"] else ""
        lines.append(
            f"| {s['prime']}{hold} | {s['specializations']} | "
            f"{s['locally_soluble_count']}/{s['specializations']} | "
            f"{s['singular_cubic_heuristic_count']} | "
            f"{fc['contained_line']} | {fc['singular_double']} | "
            f"{fc['split']} | {fc['nonsplit']} | "
            f"{s['residual_split_rate_among_noncontained']:.4f} | {pc} |"
        )
    lines += [
        "",
        "\\* `sing` = specializations where a random/eigenpoint search found",
        "`grad G = 0` (heuristic; not a smoothness theorem).",
        "",
        "## Reading",
        "",
        "- Local solubility of specialized fibres is routine (eigenpoints alone).",
        "- Residual fibrations show mixed split/nonsplit fibres; contained lines",
        "  and double fibres appear at low rate.",
        "- No transfer to a `K`-point or to pointlessness is claimed.",
        "",
        f"Elapsed: {time.time() - t0:.2f}s.  Seed={SEED}.",
        "",
    ]
    (HERE / "SUMMARY.md").write_text("\n".join(lines))

    status = """H5-UNDECIDED

# H5 modular residual fibration probe

**Pinned state:** `{pinned}`
**H4 input:** `goal_runs_after_35fa/H_11_5_TWIST/` (`H-11_5-NORM-MODEL-PASS`)
**Parallel peer:** `H5_11_5_TRACE_CUBIC/`, `H5_WAVE2_LAURENT_PROJ/` (different files)
**Headline:** OPEN (Problem E unchanged)

## Exit

```text
H5-UNDECIDED
```

Discovery packet only.  Not a pointlessness claim, not a rational point, not a
Problem E headline.

## What was done

1. Bound H4 norm/twist/field payloads and H5 trace-cubic status by path+hash.
2. Specialized the weighted Klein form
   `G(x)=sum_i (1/r_{{i+2}}) x_i^2 x_{{i+1}}` on random product-one `r` over primes
   `{primes}` (holdout **199**).
3. Used the degree-five eigenpoint orbit `e_0..e_4` (index-one geometry) as
   projection centres.
4. Sampled residual binary quadrics on lines through each eigenpoint; classified
   fibres as contained-line / singular-double / split / nonsplit.
5. Recorded local solubility, heuristic singular-cubic hits, and exact (p≤41)
   or Monte-Carlo point-count estimates.
6. Wrote replay samples for an independent verifier.

## Points found over K

```text
none
```

## Next finite gate (unchanged)

Exact Laurent-support search with coefficients in `K`, or a complete toric
valuation with anisotropic residue, or an exact residual-fibration decision
over `K` (this packet is only modular discovery).

## Replay

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_FIBRATION_PROBE_20260802/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_FIBRATION_PROBE_20260802/verify.py
```

Terminal marker:

```text
H5_FIBRATION_PROBE_VERIFY_OK
```
""".format(pinned=PINNED, primes=list(PRIMES))
    (HERE / "STATUS.md").write_text(status)

    replay = """# Replay — H5 fibration probe

```sh
cd /Users/worker/unirational/problems/E-klein-cubic
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_FIBRATION_PROBE_20260802/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_FIBRATION_PROBE_20260802/verify.py
```

Expected verifier terminal line:

```text
H5_FIBRATION_PROBE_VERIFY_OK
```

The verifier does **not** import `produce.py`.  It reloads H4 hashes, rebuilds
`G` and residual binary forms, and replays every row of `SAMPLES.json`.
"""
    (HERE / "REPLAY.md").write_text(replay)

    readme = """# H5 modular residual fibration probe (2026-08-02)

Parallel discovery track for Goal H5.  Coordinates with
`H5_11_5_TRACE_CUBIC/` and `H5_WAVE2_LAURENT_PROJ/` by writing only under this
directory.

| File | Role |
|---|---|
| `INPUT_MANIFEST.json` | H4/H5 bindings by path+hash |
| `MODEL.json` | residual projection geometry |
| `FINDINGS.json` | per-prime statistics |
| `SAMPLES.json` | replay anchors (incl. holdout 199) |
| `SUMMARY.md` | human summary table |
| `produce.py` / `verify.py` | producer + independent verifier |
| `STATUS.md` / `decision.json` | `H5-UNDECIDED` |

No headline.  No pointlessness claim.
"""
    (HERE / "README.md").write_text(readme)

    print("H5_FIBRATION_PROBE_PRODUCE_OK")
    print(f"elapsed_s={time.time() - t0:.2f}")
    for s in summaries:
        fc = s["residual_fibre_counts"]
        print(
            f"p={s['prime']} soluble={s['locally_soluble_count']}/{s['specializations']} "
            f"sing={s['singular_cubic_heuristic_count']} "
            f"fibres cont/double/split/nonsplit="
            f"{fc['contained_line']}/{fc['singular_double']}/{fc['split']}/{fc['nonsplit']} "
            f"split_rate={s['residual_split_rate_among_noncontained']:.4f}"
        )


if __name__ == "__main__":
    main()
