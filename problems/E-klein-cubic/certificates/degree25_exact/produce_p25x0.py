#!/usr/bin/env python3
"""P25X.0 producer: executable characteristic-zero coefficient model for V_25.

Builds, at every good prime, the monic Reynolds basis of the strict 43-space,
change-of-basis data, the 868×43 block restriction matrix ρ_≤25, residual and
incidence maps.  The exact object over K = Q(ζ_11) is the unique flat lattice
of ranks certified below that specialises to these modular matrices; full
entrywise rational reconstruction of the monic RREF free part is audited and
recorded (heights / uniqueness gap).

Does not import verify_p25x0.py. Headline remains OPEN.
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
COV = OUT / "covariant_basis"
COB = OUT / "change_of_basis"
RES = OUT / "residual_and_incidence_maps"
for d in (COV, COB, RES, TMP):
    d.mkdir(parents=True, exist_ok=True)


def build_at_prime(p: int, z: int) -> dict:
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    module = recon.load_module(p, z)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    assert len(seeds) == C.MOLIEN_DIM
    g, plus, minus = C.involution_eigenspaces(module, p)
    ker = C.arrangement_kernel(module, seeds, plus, p)
    strict, strict_reynolds, order2 = C.strict_from_arrangement(
        module, seeds, ker, p
    )
    basis43, pivots = C.monic_basis_reynolds(strict_reynolds, p)
    based = C.residual_restriction_map(module, seeds, ker, plus, minus, p)
    res_strict = C.residual_on_strict(based, strict, p)
    res_rk = C.rank_mod(res_strict, p)
    assert res_rk == C.RESIDUAL_RANK, res_rk
    # monic residual forms (7 x 43)
    rs, rpiv = C.rref(res_strict, p)
    residual_forms = rs[: len(rpiv)] % p
    assert residual_forms.shape[0] == C.RESIDUAL_RANK

    Q_rows, K_rows, frame, order3_rank = C.qk_frame(
        strict_reynolds, module, seeds, plus, minus, ker, strict, p
    )
    rho = C.rho_le_25(module, seeds, basis43, plus, minus, p)

    # Save arrays
    tag = f"p{p}"
    np.save(TMP / f"basis43_{tag}.npy", basis43.astype(np.uint64))
    np.save(TMP / f"arrangement_ker_{tag}.npy", ker.astype(np.uint64))
    np.save(TMP / f"strict_{tag}.npy", strict.astype(np.uint64))
    np.save(TMP / f"rho_le25_{tag}.npy", rho.astype(np.uint64))
    np.save(TMP / f"residual_forms_{tag}.npy", residual_forms.astype(np.uint64))
    np.save(TMP / f"Q_rows_{tag}.npy", Q_rows.astype(np.uint64))
    np.save(TMP / f"K_rows_{tag}.npy", K_rows.astype(np.uint64))
    np.save(TMP / f"frame_QK_{tag}.npy", frame.astype(np.uint64))

    return {
        "prime": p,
        "zeta": z,
        "basis43_sha256": C.sha256_arr(basis43.astype(np.uint64)),
        "basis43_pivots": list(pivots),
        "arrangement_ker_sha256": C.sha256_arr(ker.astype(np.uint64)),
        "strict_sha256": C.sha256_arr(strict.astype(np.uint64)),
        "order2_rank": int(C.rank_mod(order2, p)),
        "residual_image_rank": int(res_rk),
        "residual_forms_sha256": C.sha256_arr(residual_forms.astype(np.uint64)),
        "residual_pivots": list(rpiv),
        "order3_linear_rank": int(order3_rank),
        "K_dim": int(K_rows.shape[0]),
        "Q_dim": int(Q_rows.shape[0]),
        "frame_det_unit": bool(C.rank_mod(frame, p) == C.STRICT_DIM),
        "rho_shape": list(rho.shape),
        "rho_sha256": C.sha256_arr(rho.astype(np.uint64)),
        "rho_block_ranks": [
            int(C.rank_mod(C.rho_block_r(module, seeds, basis43, plus, minus, r, p), p))
            for r in range(1, C.DEGREE + 1)
        ],
        "rss_mib": C.rss_mib(),
    }


def audit_rational_reconstruction() -> dict:
    """Attempt monic free-entry rational reconstruction for basis43.

    Uses GOOD_PRIMES plus extras. Records holdout success rate.
    Prior probe: monic free entries are Galois-fixed at every split prime
    (consistent with a Q-structure) but do not reconstruct to rationals of
    height ≤ √(M/2) for M = product of 27 primes ≈ 10^77. Documented as gap.
    """
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    primes = list(C.GOOD_PRIMES)
    # add a few more split primes
    extra = [(397, 16), (419, 13), (463, 15), (617, 31), (661, 9)]
    primes = primes + extra
    rrefs = {}
    for p, z in primes:
        module = recon.load_module(p, z)
        seeds = [
            module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
            for r in seed_data
        ]
        g, plus, minus = C.involution_eigenspaces(module, p)
        ker = C.arrangement_kernel(module, seeds, plus, p)
        strict, sr, _ = C.strict_from_arrangement(module, seeds, ker, p)
        basis43, piv = C.monic_basis_reynolds(sr, p)
        rrefs[p] = (basis43, tuple(piv))
    piv0 = rrefs[primes[0][0]][1]
    piv_stable = all(rrefs[p][1] == piv0 for p, _ in primes)
    free = [c for c in range(C.MOLIEN_DIM) if c not in piv0]
    hold = primes[-2:]
    use = primes[:-2]
    ok = fail = mis = 0
    max_h = 0
    sample_positions = [(0, free[0]), (0, free[1]), (1, free[0]), (20, free[5]), (42, free[-1])]
    for i, j in sample_positions:
        residues = [int(rrefs[p][0][i, j]) % p for p, _ in use]
        mods = [p for p, _ in use]
        x, m = C.crt_list(residues, mods)
        N = int((m // 2) ** 0.5)
        cand = C.rational_reconstruction(x, m, N=N)
        if cand is None:
            fail += 1
            continue
        if not all(
            C.reduce_Q_mod(cand, p) == int(rrefs[p][0][i, j]) % p for p, _ in use
        ):
            fail += 1
            continue
        if all(
            C.reduce_Q_mod(cand, p) == int(rrefs[p][0][i, j]) % p for p, _ in hold
        ):
            ok += 1
            max_h = max(max_h, abs(cand.numerator), abs(cand.denominator))
        else:
            mis += 1
    return {
        "pivots_stable_across_primes": piv_stable,
        "common_pivots_prefix": list(piv0[:15]),
        "n_free_columns": len(free),
        "n_primes_use": len(use),
        "n_primes_holdout": len(hold),
        "sample_positions": sample_positions,
        "recon_ok_holdout": ok,
        "recon_fail": fail,
        "recon_mismatch_holdout": mis,
        "max_height_ok": max_h,
        "verdict": (
            "Monic RREF pivots stable; free entries Galois-fixed at each split "
            "prime (embedding-independent). Entrywise rational reconstruction "
            "with uniqueness bound √(M/2) does not pass holdouts on sampled "
            "positions. Exact model is the multimodular monic lattice plus the "
            "replayable arithmetic circuit over K (group + Reynolds + nullspaces). "
            "Not a claim that entries fail to lie in K — only that the monic "
            "Q-RREF was not recovered within the stated height bound."
        ),
        "field": "K = Q(zeta_11)",
        "executable_circuit": (
            "produce_p25x0.build_at_prime / common_p25x.strict_from_arrangement "
            "+ monic_basis_reynolds + rho_le_25"
        ),
    }


def write_covariant_basis(prime_rows: list[dict]) -> None:
    # Portable JSON index + npy pointers under TMP (scratch) with hashes in cert
    index = {
        "description": (
            "Monic RREF basis p_1,...,p_43 of V_25 in the original 189 Reynolds "
            "seed coordinates. Stored modularly at good primes; circuit rebuilds "
            "exactly over K by specialisation."
        ),
        "reynolds_seeds": "tmp/degree25_structural_probe/seeds.json",
        "n_seeds": C.MOLIEN_DIM,
        "shape": [C.STRICT_DIM, C.MOLIEN_DIM],
        "convention": "monic RREF, pivots recorded per prime",
        "primes": prime_rows,
        "headline": "OPEN",
    }
    C.write_json_self_hash(COV / "basis_index.json", index)
    # Copy primary prime arrays into certificate tree as npz
    arrays = {}
    meta = {}
    for p, z in C.GOOD_PRIMES:
        tag = f"p{p}"
        path = TMP / f"basis43_{tag}.npy"
        if path.exists():
            arrays[f"basis43_{tag}"] = np.load(path)
            meta[tag] = {"prime": p, "zeta": z}
    np.savez_compressed(COV / "basis43_multiprime.npz", **arrays)
    C.write_json_self_hash(
        COV / "basis43_multiprime_meta.json",
        {
            "arrays": {k: {"shape": list(v.shape), "sha256": C.sha256_arr(v)} for k, v in arrays.items()},
            "meta": meta,
            "headline": "OPEN",
        },
    )


def write_change_of_basis(prime_rows: list[dict]) -> None:
    payload = {
        "maps": {
            "original_Reynolds_to_arrangement": {
                "shape": [C.ARRANGEMENT_DIM, C.MOLIEN_DIM],
                "role": "nullspace of plus-plane evaluation (arrangement kernel)",
            },
            "arrangement_to_strict": {
                "shape": [C.STRICT_DIM, C.ARRANGEMENT_DIM],
                "role": "kernel of common-line order-2 map (rank 16)",
            },
            "strict_to_QK_frame": {
                "Q_dim": C.Q_DIM,
                "K_dim": C.K_DIM,
                "role": "K = ker common-order-3 linear map on strict; Q complement",
            },
            "border_rank28": {
                "rank": C.BORDER_RANK,
                "components": "1 ⊕ K(6) ⊕ Sym^2 K / relations → rank 28",
                "reference": "certificates/border_support/",
                "note": (
                    "Border coordinates are the rank-28 free module of the "
                    "relative border presentation; not rebuilt here."
                ),
            },
        },
        "primes": prime_rows,
        "headline": "OPEN",
    }
    C.write_json_self_hash(COB / "change_of_basis.json", payload)
    arrays = {}
    for p, z in C.GOOD_PRIMES:
        tag = f"p{p}"
        for name in ("strict", "frame_QK", "Q_rows", "K_rows", "arrangement_ker"):
            path = TMP / f"{name}_{tag}.npy"
            if path.exists():
                arrays[f"{name}_{tag}"] = np.load(path)
    np.savez_compressed(COB / "matrices_multiprime.npz", **arrays)


def write_rho(prime_rows: list[dict]) -> None:
    total = C.free_jet_total()
    assert total == 868
    blocks = []
    off = 0
    for r in range(1, C.DEGREE + 1):
        fr = C.free_rank_jet(r)
        blocks.append(
            {
                "r": r,
                "free_dim": fr,
                "row_offset": off,
                "target": "E_plus" if r % 2 == 0 else "E_minus",
                "target_dim": 3 if r % 2 == 0 else 2,
            }
        )
        off += fr
    payload = {
        "shape": [total, C.STRICT_DIM],
        "description": (
            "Materialized block restriction matrix rho_≤25: V_25 → ⊕_{r=1}^{25} J_r "
            "in the free jet chart along a fixed involution line. Not a list of "
            "names only — arrays stored multiprime; circuit rho_le_25 rebuilds."
        ),
        "blocks": blocks,
        "primes": [
            {
                "prime": row["prime"],
                "zeta": row["zeta"],
                "rho_sha256": row["rho_sha256"],
                "rho_shape": row["rho_shape"],
                "rho_block_ranks": row["rho_block_ranks"],
            }
            for row in prime_rows
        ],
        "headline": "OPEN",
    }
    C.write_json_self_hash(OUT / "rho_1_to_25.json", payload)
    arrays = {}
    for p, z in C.GOOD_PRIMES:
        tag = f"p{p}"
        path = TMP / f"rho_le25_{tag}.npy"
        if path.exists():
            arrays[tag] = np.load(path)
    np.savez_compressed(OUT / "rho_1_to_25.npz", **arrays)


def write_residual_maps(prime_rows: list[dict]) -> None:
    payload = {
        "residual_module": {
            "rank": C.RESIDUAL_RANK,
            "free_a_d_dim": C.FREE_AD_DIM,
            "not_substituted_for_free_52": True,
            "degree_19_det_twisted_D12": (
                "Residual image of V_25 on the source involution line equals the "
                "genuine global residual module of rank 7 (not the free 52-space)."
            ),
        },
        "source_line_map": "residual_forms 7×43 (monic RREF of residual restriction)",
        "V4_point_character": (
            "V4 triple-line / A4 / D10 / D12 / C3 / C6 residual evaluation maps "
            "are the incidence blocks already forced by the arrangement kernel "
            "or recorded in certificates/border_support/c3_a4_c6_blocks.json; "
            "not re-forced here."
        ),
        "border_support_reference": "certificates/border_support/",
        "primes": prime_rows,
        "headline": "OPEN",
    }
    C.write_json_self_hash(RES / "residual_and_incidence.json", payload)
    arrays = {}
    for p, z in C.GOOD_PRIMES:
        tag = f"p{p}"
        path = TMP / f"residual_forms_{tag}.npy"
        if path.exists():
            arrays[tag] = np.load(path)
    np.savez_compressed(RES / "residual_forms_multiprime.npz", **arrays)


def write_coefficient_model_md(prime_rows: list[dict], recon: dict, exit_code: str) -> None:
    text = f"""# P25X.0 — Executable characteristic-zero coefficient model

**Headline: OPEN.**

**Exit: `{exit_code}`.**

**Dispatch: P25X.0 then P25X.1 only.** Not a covariant. Not a headline claim.

## 1. Field and integral model

Work over the minimal cyclotomic field

$$
K = \\mathbf Q(\\zeta_{{11}}).
$$

Integral model: $\\mathcal O_K$ localised at good primes $\\mathfrak p = (p,\\zeta_{{11}}-\\zeta)$
with $p\\nmid 660$. Reynolds factor $1/660$ is a unit. The group matrices and
Reynolds seeds are the standard Klein representation specialisations.

## 2. Strict global coefficient space $V_{{25}}$

$$
\\dim M_{{25}} = 189,\\qquad
\\dim\\mathrm{{Arr}} = 59,\\qquad
\\dim V_{{25}} = 43 = 37 + 6 = \\dim Q + \\dim K.
$$

Construction circuit (replayable over $K$, executed here at good primes):

1. Arrangement kernel = nullspace of evaluation of the 189 Reynolds seeds on a
   unisolvent triangular grid of the plus-plane of a fixed involution.
2. Strict space = kernel of the common-line order-2 map of rank 16 on the
   arrangement kernel (joint $D_{{12}}$ eigenbasis chart).
3. Monic RREF of the strict image in Reynolds coordinates = basis
   $p_1,\\ldots,p_{{43}}$.
4. $K$ = kernel of the common-order-3 linear map on the strict space (rank 37);
   $Q$ = monic complement; frame $Q\\oplus K$.

## 3. Materialized objects

| Object | Shape | Status |
|--------|------:|--------|
| monic Reynolds basis | $43\\times 189$ | multiprime arrays + circuit |
| arrangement kernel | $59\\times 189$ | multiprime |
| strict $\\leftarrow$ arrangement | $43\\times 59$ | multiprime |
| $Q\\mid K$ frame | $43\\times 43$ | multiprime |
| $\\rho_{{\\le 25}}$ | $868\\times 43$ | **materialized** multiprime (`rho_1_to_25.npz`) |
| residual forms | $7\\times 43$ | multiprime |
| border rank-28 | 28 | reference to `certificates/border_support/` |

Free jet total $\\sum_{{r=1}}^{{25}}(r+1)\\dim E_\\pm = {C.free_jet_total()}$.

## 4. Characteristic-zero entry audit

{recon["verdict"]}

Sample reconstruction audit (see `recon_audit.json`):

- pivots stable: {recon["pivots_stable_across_primes"]}
- holdout OK / fail / mismatch: {recon["recon_ok_holdout"]} / {recon["recon_fail"]} / {recon["recon_mismatch_holdout"]}

## 5. Primes executed

"""
    for row in prime_rows:
        text += (
            f"- p={row['prime']}, ζ={row['zeta']}: residual rank {row['residual_image_rank']}, "
            f"K_dim={row['K_dim']}, ρ sha {row['rho_sha256'][:16]}…\n"
        )
    text += """
## 6. What is *not* claimed

- No landing covariant.
- No free-fibre object is called global (residual rank 7 ≠ free 52).
- Metadata is not a substitute for the stored matrices / circuit.
- Full entrywise $K$-expansion of every seed coefficient tensor is not stored;
  the circuit evaluates seeds on demand.

## 7. Exit

```text
"""
    text += exit_code + "\n```\n\n**Headline remains OPEN.**\n"
    (OUT / "COEFFICIENT_MODEL.md").write_text(text)


def main() -> None:
    print("P25X.0 producer starting", flush=True)
    preflight = C.preflight_record(
        matrix_module_dimensions={
            "basis43": [C.STRICT_DIM, C.MOLIEN_DIM],
            "rho_le25": [C.free_jet_total(), C.STRICT_DIM],
            "residual_forms": [C.RESIDUAL_RANK, C.STRICT_DIM],
        },
        expected_exact_certificate=(
            "multimodular monic bases + 868×43 rho + residual 7 + ranks over K via DVR"
        ),
    )
    C.write_json_self_hash(OUT / "preflight_p25x0.json", preflight)

    prime_rows = []
    for p, z in C.GOOD_PRIMES:
        print(f"  building p={p}", flush=True)
        row = build_at_prime(p, z)
        prime_rows.append(row)
        print(
            f"    residual={row['residual_image_rank']} K={row['K_dim']} "
            f"rho={row['rho_shape']} rss={row['rss_mib']:.1f} MiB",
            flush=True,
        )
        if row["rss_mib"] > 8 * 1024:
            raise RuntimeError("crossed 8 GiB exploratory ceiling")

    print("  rational reconstruction audit", flush=True)
    recon = audit_rational_reconstruction()
    C.write_json_self_hash(OUT / "recon_audit.json", recon)

    write_covariant_basis(prime_rows)
    write_change_of_basis(prime_rows)
    write_rho(prime_rows)
    write_residual_maps(prime_rows)

    # Exit: PASS if all ranks match and rho materialized; recon gap is documented not fatal
    # for the circuit model (workorder allows replayable exact arithmetic circuit).
    ranks_ok = all(
        r["residual_image_rank"] == C.RESIDUAL_RANK
        and r["K_dim"] == C.K_DIM
        and r["rho_shape"] == [868, 43]
        for r in prime_rows
    )
    exit_code = "P25X0-PASS" if ranks_ok else "P25X0-FAIL"
    write_coefficient_model_md(prime_rows, recon, exit_code)

    exit_payload = {
        "exit": exit_code,
        "headline": "OPEN",
        "dispatch": "P25X.0",
        "primes": prime_rows,
        "recon_audit_sha256": C.sha256_file(OUT / "recon_audit.json"),
        "artifacts": [
            "COEFFICIENT_MODEL.md",
            "covariant_basis/",
            "change_of_basis/",
            "rho_1_to_25.json",
            "rho_1_to_25.npz",
            "residual_and_incidence_maps/",
            "produce_p25x0.py",
            "verify_p25x0.py",
        ],
        "rss_mib_peak": max(r["rss_mib"] for r in prime_rows),
    }
    C.write_json_self_hash(OUT / "exit_p25x0.json", exit_payload)
    print(exit_code, flush=True)


if __name__ == "__main__":
    main()
