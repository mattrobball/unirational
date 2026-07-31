#!/usr/bin/env python3
"""P25X.1 producer: exact cubic landing ideal of F(p_c) on V_25.

Samples F(p_c)(x) as cubic forms in the monic 43-coordinates at good primes
p > 25 (faithful evaluation of degree-75 forms), row-reduces to a monic basis
of the sample span, compares ranks to the historical modular 842 system, and
records the residual gap for char-0 ideal equivalence with the rank-28 border.

Does not import verify_p25x1.py. Headline remains OPEN.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import common_p25x as C  # noqa: E402

OUT = HERE
TMP = C.TMP
TMP.mkdir(parents=True, exist_ok=True)


def build_basis43(p: int, z: int):
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    module = recon.load_module(p, z)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    g, plus, minus = C.involution_eigenspaces(module, p)
    ker = C.arrangement_kernel(module, seeds, plus, p)
    strict, sr, _ = C.strict_from_arrangement(module, seeds, ker, p)
    basis43, piv = C.monic_basis_reynolds(sr, p)
    return module, seeds, basis43, piv, plus, minus, strict, ker


def sample_landing_basis(
    module, seeds, basis43: np.ndarray, prime: int, n_samples: int, seed: int
) -> tuple[np.ndarray, dict]:
    """Return monic RREF basis of sample cubics (rank × 14190) and meta."""
    rng = np.random.default_rng(seed)
    points = rng.integers(0, prime, size=(n_samples, 5), dtype=np.int64)
    R = C.batch_seed_evaluations(module, seeds, points, prime).reshape(
        n_samples, 5, C.MOLIEN_DIM
    )
    vals = np.einsum("nsw,bw->nbs", R, basis43) % prime
    echelon: list = []
    last_increase = 0
    for i in range(n_samples):
        row = C.fast_cubic_row(vals[i], prime)
        if C.add_echelon_row(echelon, row, prime):
            last_increase = i + 1
        if (i + 1) % 200 == 0:
            print(f"    sample {i+1}/{n_samples} rank={len(echelon)}", flush=True)
    if not echelon:
        basis = np.zeros((0, C.CUBIC_MONOM_DIM), dtype=np.int64)
    else:
        basis = np.stack([row for _, row in echelon]).astype(np.int64) % prime
    meta = {
        "n_samples": n_samples,
        "rank": int(basis.shape[0]),
        "last_rank_increase_at_sample": last_increase,
        "cubic_ambient_dim": C.CUBIC_MONOM_DIM,
        "plateau": last_increase < n_samples - 50,
    }
    return basis, meta


def compare_to_842(p: int) -> dict:
    """Compare to historical full_cubic_basis at p=67 only (sealed)."""
    path = (
        C.ROOT
        / "tmp"
        / "m1_full_plane_block_rank"
        / "full_cubic_basis.npz"
    )
    if not path.exists():
        return {"available": False}
    data = np.load(path)
    coeffs = data["coefficients"]
    return {
        "available": True,
        "historical_prime": 67,
        "historical_shape": list(coeffs.shape),
        "historical_rank": int(coeffs.shape[0]),
        "historical_sha256": C.sha256_arr(coeffs),
        "note": (
            "Historical 842×14190 basis is the order-four plane block system in "
            "(Q|K) coordinates over F_67. Direct sample span of F(p_c) in monic "
            "Reynolds coordinates is compared by rank only at p>25; coefficientwise "
            "identity over Q remains open (same residual gap as P25R equivalence_to_842)."
        ),
        "comparison_at_this_prime": p,
    }


def border_equivalence_gap() -> dict:
    return {
        "border_rank": C.BORDER_RANK,
        "border_reference": "certificates/border_support/",
        "historical_842_reference": "tmp/m1_full_plane_block_rank/full_cubic_basis.npz",
        "direction_landing_to_border": (
            "Not proved coefficientwise over K in this dispatch. The rank-28 border "
            "presentation F/N ≅ R/I for the normalized 842-cubic ideal is the accepted "
            "prior modular package; sample landing here is built in monic Reynolds "
            "coordinates without transporting to the border free module over K."
        ),
        "direction_border_to_landing": (
            "Same gap. Modular recovery of rank-842 row spaces at p=67 is retained "
            "as discovery; holdout primes report sample ranks of F(p_c)."
        ),
        "row_ideal_containment_both_directions_over_K": False,
        "residual_gap": (
            "GAP: exact char-0 generators of the cubic landing ideal in both the "
            "direct monic-Reynolds presentation and the rank-28 border presentation, "
            "with ideal containment both ways, are not installed. Sample bases at "
            "p∈{89,199,331} give an executable lower bound on the landing row space "
            "(plateau rank recorded per prime). Historical 842 is modular at p=67 only."
        ),
    }


def main() -> None:
    print("P25X.1 producer starting", flush=True)
    preflight = C.preflight_record(
        matrix_module_dimensions={
            "cubic_ambient": C.CUBIC_MONOM_DIM,
            "variables": C.STRICT_DIM,
        },
        sparse_dense=(
            "Prefer sample cubics + echelon (no dense global Macaulay). "
            "Each sample row is dense (~14k nnz) but only rank-many rows stored."
        ),
        expected_exact_certificate=(
            "sample monic cubic bases at p=89,199,331; rowspace_comparison; "
            "equivalence_to_border residual gap"
        ),
    )
    C.write_json_self_hash(OUT / "preflight_p25x1.json", preflight)

    n_samples = 1600
    prime_results = []
    all_bases = {}
    for p, z in C.LANDING_PRIMES:
        print(f"  landing p={p}", flush=True)
        module, seeds, basis43, piv, plus, minus, strict, ker = build_basis43(p, z)
        print(f"    basis43 monic pivots={piv[:5]}...", flush=True)
        land, meta = sample_landing_basis(
            module, seeds, basis43, p, n_samples=n_samples, seed=20260731 + p
        )
        tag = f"p{p}"
        np.save(TMP / f"landing_cubics_{tag}.npy", land.astype(np.uint64))
        all_bases[tag] = land.astype(np.uint8) if land.size and land.max() < 256 else land
        hist = compare_to_842(p)
        row = {
            "prime": p,
            "zeta": z,
            "basis43_pivots_prefix": list(piv[:10]),
            "landing_rank": meta["rank"],
            "landing_sha256": C.sha256_arr(land.astype(np.uint64)) if land.size else None,
            "meta": meta,
            "historical_842": hist,
            "rss_mib": C.rss_mib(),
        }
        prime_results.append(row)
        print(
            f"    landing rank={meta['rank']} plateau={meta['plateau']} "
            f"rss={row['rss_mib']:.1f} MiB",
            flush=True,
        )
        if row["rss_mib"] > 8 * 1024:
            raise RuntimeError("crossed 8 GiB exploratory ceiling")

    # Store landing cubics
    np.savez_compressed(OUT / "landing_cubics.npz", **all_bases)
    landing_json = {
        "coordinate_convention": (
            "monic RREF of V_25 in original Reynolds seed coordinates; "
            "cubic monomials = weak compositions of degree 3 in 43 variables"
        ),
        "method": (
            "sparse-direct sample: evaluate F(p_c)(x) at random x∈F_p^5, expand as "
            "cubic in c via polarized Klein form (fast_cubic_row), row-reduce"
        ),
        "n_samples_per_prime": n_samples,
        "primes": prime_results,
        "headline": "OPEN",
    }
    C.write_json_self_hash(OUT / "landing_cubics.json", landing_json)

    ranks = {r["prime"]: r["landing_rank"] for r in prime_results}
    rowspace = {
        "coordinate_convention": landing_json["coordinate_convention"],
        "sample_ranks": ranks,
        "historical_842_mod_67": {
            "rank": 842,
            "source": "tmp/m1_full_plane_block_rank/full_cubic_basis.npz",
            "sha256": "2fd6a5ad83f17de8826eb1787e062e79c66f6aac681197c24702c65df6135f76",
            "field": "F_67",
        },
        "recovery_at_holdouts": {
            "89": ranks.get(89),
            "199": ranks.get(199),
            "331": ranks.get(331),
            "note": (
                "Sample span ranks of F(p_c) in monic Reynolds coordinates. "
                "These are lower bounds on the true landing row rank; plateau "
                "observed under 1600 samples. Historical 842 is a different "
                "(Q|K, order-four plane) modular basis at p=67 only."
            ),
        },
        "rank_842_rowspaces_recovered_as_historical_object": False,
        "sample_plateau_consistent": len(set(ranks.values())) == 1,
        "headline": "OPEN",
    }
    C.write_json_self_hash(OUT / "rowspace_comparison.json", rowspace)

    border = border_equivalence_gap()
    border["sample_landing_ranks"] = ranks
    border["headline"] = "OPEN"
    C.write_json_self_hash(OUT / "equivalence_to_border.json", border)

    # Markdown
    md = f"""# P25X.1 — Exact cubic landing ideal

**Headline: OPEN.**

**Exit: see `exit_p25x1.json`.**

## 1. Object

For the monic Reynolds basis $p_1,\\ldots,p_{{43}}$ of $V_{{25}}$ from P25X.0 and
coefficients $c\\in K^{{43}}$,

$$
p_c = \\sum_{{i=1}}^{{43}} c_i p_i,\\qquad
I_{{\\mathrm{{land}}}} = \\mathrm{{coeff}}_x\\bigl(F(p_c(x))\\bigr)
\\subset K[c_1,\\ldots,c_{{43}}]_{{3}}.
$$

$F$ is the Klein cubic. Every generator is homogeneous of degree 3 in $c$.

## 2. Implementation

**Accepted method (1):** sparse direct coefficient collection via sampling.

At each good prime $p\\in\\{{89,199,331\\}}$ ($p > 25$, so degree-75 evaluation is
not collapsed by the field size):

1. Rebuild the monic $43\\times 189$ basis (P25X.0 circuit).
2. Draw {n_samples} random points $x\\in\\mathbf F_p^5$.
3. Expand $F(p_c(x))$ as a cubic form in $c$ (`fast_cubic_row`).
4. Row-reduce over $\\mathbf F_p$ to a monic echelon basis of the sample span.

Artifacts: `landing_cubics.npz`, `landing_cubics.json`.

## 3. Sample ranks

| prime | landing sample rank | plateau |
|------:|--------------------:|:-------:|
"""
    for r in prime_results:
        md += (
            f"| {r['prime']} | {r['landing_rank']} | "
            f"{'yes' if r['meta']['plateau'] else 'no'} |\n"
        )
    md += f"""
Historical modular order-four plane basis: **rank 842** at $p=67$ only
(`tmp/m1_full_plane_block_rank/full_cubic_basis.npz`).

## 4. Row-space comparison

See `rowspace_comparison.json`. Holdout primes report the sample ranks above.
Coefficientwise recovery of the historical 842 row space over $K$ is **not**
claimed.

## 5. Equivalence to rank-28 border

See `equivalence_to_border.json`.

**Residual gap (undischarged):** exact ideal containment both ways between the
direct landing ideal and the rank-28 border presentation over $K$ is **not**
proved. Prior P25R sealed the same gap (modular 842 only). This dispatch adds
executable multiprime sample bases but does not close the char-0 containment.

## 6. Exit

```text
"""
    # Exit: PASS if sample bases produced with consistent plateau and gap documented;
    # FAIL only if ranks zero or inconsistent construction.
    ok = all(r["landing_rank"] > 0 for r in prime_results) and all(
        r["meta"]["plateau"] for r in prime_results
    )
    # Workorder requires recovering historical rank-842 at 89,199,331 — we did not
    # recover 842, so exit is carefully not a full PASS on that check.
    exit_code = "P25X1-PASS" if ok else "P25X1-FAIL"
    # Actually re-read: "recover the historical rank-842 row spaces at good primes 89,199,331"
    # We failed that. So should be FAIL or PASS with documented partial?
    # Honest: the check is not met → do not claim full PASS on 842 recovery.
    # But we delivered landing cubics and residual gap. Use PASS only if 842 recovered.
    exit_code = "P25X1-FAIL"  # 842 not recovered; residual gap open
    # Wait - if we mark FAIL, later stages blocked. The workorder says P25X1-FAIL.
    # Partial delivery with FAIL is correct when 842 recovery fails.
    # But also "or stop before support and state the residual gap" for border —
    # that's allowed within a PASS on landing construction.
    # Required checks:
    # 1. sparse row-reduced char-0 basis — we have multiprime sample, not char-0 entries
    # 2. recover 842 at 89,199,331 — NO
    # 3. border containment or residual gap — gap stated
    # 4. fixed coordinates — yes monic Reynolds
    # So FAIL is correct for check 2.
    md += exit_code + "\n```\n\n**Headline remains OPEN.**\n"
    (OUT / "LANDING_IDEAL.md").write_text(md)

    # Soften: if sample ranks are consistent and gap documented, still FAIL on 842
    # but record partial_success for director.
    exit_payload = {
        "exit": exit_code,
        "partial_success": {
            "sample_landing_bases_at_89_199_331": True,
            "sample_ranks": ranks,
            "historical_842_recovered_at_holdouts": False,
            "border_containment_both_ways_over_K": False,
            "residual_gap_documented": True,
        },
        "headline": "OPEN",
        "dispatch": "P25X.1",
        "primes": prime_results,
        "artifacts": [
            "LANDING_IDEAL.md",
            "landing_cubics.npz",
            "landing_cubics.json",
            "rowspace_comparison.json",
            "equivalence_to_border.json",
            "produce_p25x1.py",
            "verify_p25x1.py",
        ],
        "rss_mib_peak": max(r["rss_mib"] for r in prime_results),
    }
    C.write_json_self_hash(OUT / "exit_p25x1.json", exit_payload)
    print(exit_code, flush=True)
    print("sample ranks", ranks, flush=True)


if __name__ == "__main__":
    main()
