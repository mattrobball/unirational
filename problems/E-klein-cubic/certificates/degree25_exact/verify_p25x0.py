#!/usr/bin/env python3
"""P25X.0 independent verifier.

Does not import produce_p25x0.py. Recomputes decisive ranks and rebuilds
ρ / residual maps at a holdout prime from the circuit; checks stored arrays.
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


def load_json(name: str) -> dict:
    return json.loads((OUT / name).read_text())


def main() -> None:
    errors: list[str] = []
    exit_payload = load_json("exit_p25x0.json")
    rho_meta = load_json("rho_1_to_25.json")
    recon = load_json("recon_audit.json")

    # Free jet total
    if C.free_jet_total() != 868:
        errors.append(f"free jet total {C.free_jet_total()} != 868")
    if rho_meta["shape"] != [868, 43]:
        errors.append(f"rho meta shape {rho_meta['shape']}")

    # Rebuild at holdout prime 353 (or 89 if missing)
    p, z = 353, 58
    print(f"rebuild circuit at p={p}", flush=True)
    reconstructor = C.load_reconstructor()
    seed_data = C.load_seeds()
    module = reconstructor.load_module(p, z)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    g, plus, minus = C.involution_eigenspaces(module, p)
    ker = C.arrangement_kernel(module, seeds, plus, p)
    if ker.shape != (59, 189):
        errors.append(f"arrangement ker shape {ker.shape}")
    strict, sr, order2 = C.strict_from_arrangement(module, seeds, ker, p)
    if strict.shape != (43, 59):
        errors.append(f"strict shape {strict.shape}")
    if C.rank_mod(order2, p) != 16:
        errors.append(f"order2 rank {C.rank_mod(order2, p)}")
    basis43, piv = C.monic_basis_reynolds(sr, p)
    if basis43.shape != (43, 189) or len(piv) != 43:
        errors.append("basis43 shape/pivots")
    # monic check
    if not np.array_equal(basis43[:, list(piv)] % p, np.eye(43, dtype=np.int64) % p):
        errors.append("basis43 not monic on pivots")

    based = C.residual_restriction_map(module, seeds, ker, plus, minus, p)
    res = C.residual_on_strict(based, strict, p)
    if C.rank_mod(res, p) != 7:
        errors.append(f"residual rank {C.rank_mod(res, p)}")

    rho = C.rho_le_25(module, seeds, basis43, plus, minus, p)
    if rho.shape != (868, 43):
        errors.append(f"rho shape {rho.shape}")

    # Compare stored multiprime array if present
    npz_path = OUT / "rho_1_to_25.npz"
    if npz_path.exists():
        with np.load(npz_path) as zfile:
            key = f"p{p}"
            if key in zfile.files:
                stored = zfile[key] % p
                if stored.shape != rho.shape:
                    errors.append("stored rho shape mismatch")
                elif not np.array_equal(stored % p, rho % p):
                    # May differ by GL action if pivot convention drifted — check row space of blocks
                    if not C.same_row_space(stored.T, rho.T, p):
                        # column spaces of maps = image of V_25
                        if C.rank_mod(stored, p) != C.rank_mod(rho, p):
                            errors.append("stored rho rank differs from rebuild")
                        # column-space equality
                        if not C.same_row_space(stored, rho, p):
                            errors.append("stored rho row-space differs from rebuild")
            else:
                errors.append(f"missing {key} in rho npz")
    else:
        errors.append("rho_1_to_25.npz missing")

    basis_npz = OUT / "covariant_basis" / "basis43_multiprime.npz"
    if basis_npz.exists():
        with np.load(basis_npz) as zfile:
            key = f"basis43_p{p}"
            if key in zfile.files:
                sb = zfile[key] % p
                if not C.same_row_space(sb, basis43, p):
                    errors.append("stored basis43 row-space mismatch at holdout")
            else:
                errors.append(f"missing {key} in basis npz")
    else:
        errors.append("basis43_multiprime.npz missing")

    # Residual must not pretend free 52
    for row in exit_payload.get("primes", []):
        if row.get("residual_image_rank") != 7:
            errors.append(f"prime {row.get('prime')} residual rank claim")

    if recon.get("pivots_stable_across_primes") is not True:
        errors.append("recon audit pivots not stable")

    # Required files
    for rel in (
        "COEFFICIENT_MODEL.md",
        "exit_p25x0.json",
        "rho_1_to_25.json",
        "recon_audit.json",
        "covariant_basis/basis_index.json",
        "change_of_basis/change_of_basis.json",
        "residual_and_incidence_maps/residual_and_incidence.json",
    ):
        if not (OUT / rel).exists():
            errors.append(f"missing {rel}")

    if exit_payload.get("exit") == "P25X0-PASS" and errors:
        errors.append("exit claims PASS but checks failed")

    if errors:
        print("P25X0_VERIFY_FAIL")
        for e in errors:
            print(" ", e)
        sys.exit(1)

    print("P25X0_VERIFY_OK")
    print(f"  rebuilt p={p}: basis monic, residual rank 7, rho {rho.shape}")
    print(f"  exit={exit_payload.get('exit')} headline=OPEN")
    print(f"  rss={C.rss_mib():.1f} MiB")


if __name__ == "__main__":
    main()
