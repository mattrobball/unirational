#!/usr/bin/env python3
"""G3D master producer — builds all structural artifacts under this packet."""

from __future__ import annotations

import hashlib
import json
import sys
import time
import traceback
from pathlib import Path

HERE = Path(__file__).resolve().parent
SRC = HERE / "src"
sys.path.insert(0, str(SRC))

from k_simple import build_payload as build_k_simple  # noqa: E402
from polar_surface import build_polar_surface  # noqa: E402
from hessian_spinor import build_hessian_and_spinor  # noqa: E402
from lines_a5 import build_lines_packet, build_a5_descent  # noqa: E402


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def write_json(name: str, payload: dict) -> None:
    path = HERE / name
    path.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"  wrote {name} ({path.stat().st_size} bytes)")


def write_md(name: str, body: str) -> None:
    path = HERE / name
    path.write_text(body if body.endswith("\n") else body + "\n")
    print(f"  wrote {name}")


def main() -> None:
    t0 = time.time()
    print("=== G3D produce_all ===")
    meta = {"phases": {}, "errors": []}

    # --- G3D.0 simple field ---
    print("[1/6] k_simple model")
    try:
        ks = build_k_simple()
        write_json("k_simple_model.json", ks)
        write_md(
            "K_SIMPLE_MODEL.md",
            (
                "# G3D.0 — simple field model for `K_proj`\n\n"
                "## Choice of primitive element\n\n"
                "eta = f7 = b_1 (secondary basis element of degree 7).\n\n"
                "## Left multiplication and minimal polynomial\n\n"
                "L_eta is the 12x12 matrix of left multiplication by eta on the G3A "
                "secondary basis over P0 = QQ(t3,t6,t8,t11). The monic minimal "
                "polynomial is m_eta(T) = det(T I - L_eta) in P0[T].\n\n"
                "## Degree 12\n\n"
                "The power-basis matrix P has constant integer denominators only. "
                "Good specializations:\n\n"
                + "\n".join(
                    f"- t = {s['t']}: det P = {s['det_P']}"
                    for s in ks["specializations"]
                )
                + "\n\n"
                "Hence det P is not identically zero, and on the principal open "
                "det P != 0 the set {1, eta, ..., eta^11} is a P0-basis. "
                "Thus [P0(eta):P0] = 12 and deg m_eta = 12.\n\n"
                "## Two-way maps\n\n"
                "- Power to secondary: sum c_k * (column k of P).\n"
                "- Secondary to power: P^{-1} * secondary_vector on det P != 0.\n"
                "- Multiplication: convert to secondary, apply the certified 78 "
                "structure constants (field_api.multiply), convert back.\n\n"
                "Trace, norm, and inversion are delegated to field_api on the "
                "secondary model and transported by P.\n\n"
                "## Marker\n\n```text\n"
                f"{ks['marker']}\n"
                "```\n\n"
                "This is an arithmetic interface, not a headline exit.\n"
            ),
        )
        meta["phases"]["k_simple"] = ks["marker"]
    except Exception as e:
        meta["errors"].append({"phase": "k_simple", "error": repr(e), "tb": traceback.format_exc()})
        print("  FAIL", e)

    # --- G3D.1A polar surface ---
    print("[2/6] polar cubic surface")
    polar = None
    try:
        polar = build_polar_surface()
        write_json("polar_cubic_surface.json", polar)
        write_md(
            "POLAR_CUBIC_SURFACE.md",
            (
                "# G3D.1A — canonical second-polar cubic surface\n\n"
                "## Setup\n\n"
                "Ambient point q = [1:0:0:0:0], Phi(q) = t3 != 0. Second-polar "
                "hyperplane ell_q(a) = t3 a0 + (t6/3) a1 + (b7/3) a2 + (t8/3) a3 + "
                "(b9/3) a4 with b7=f7, b9=f9. Elimination on t3 != 0:\n\n"
                "a0 = -(t6 y1 + b7 y2 + t8 y3 + b9 y4)/(3 t3).\n\n"
                "## Surface equation\n\n"
                f"G_q(y) := Phi(a(y)) is a single K-valued cubic form, stored as "
                f"**{polar['G_q']['nonzero_secondary_components']}** nonzero secondary "
                "components over P0[y1,y2,y3,y4].\n\n"
                f"- ell_q vanishes after elimination: **{polar['ell_q_vanishes_after_elimination']}**\n"
                f"- Re-embedding secondary-0 checks: **{polar['reembedding_all_match']}**\n"
                f"- Smooth point on specialized secondary-0 slice: "
                f"**{polar['smoothness']['smooth_point_found_on_slice']}**\n\n"
                "## Singular locus\n\n"
                "No K-rational singular point certified. Specialized singular points "
                "on the secondary-0 slice (if any) are discovery data only.\n\n"
                "## Marker\n\n```text\n"
                f"{polar['marker']}\n"
                "```\n\n"
                f"Wall time: {polar['wall_time_s']} s.\n"
            ),
        )
        meta["phases"]["polar_surface"] = polar["marker"]
    except Exception as e:
        meta["errors"].append({"phase": "polar", "error": repr(e), "tb": traceback.format_exc()})
        print("  FAIL", e)

    # --- G3D.1B/C lines + sixers ---
    print("[3/6] 27-line / sixer probes")
    try:
        lines = build_lines_packet(polar)
        write_json("line_27_algebra.json", lines)
        write_json("sixer_descent.json", lines["sixer_descent"])
        write_json(
            "surface_determinantal.json",
            {
                "schema": "g3d-surface-determinantal-v1",
                "status": "NO_DETERMINANTAL_MATRIX_OVER_K",
                "reason": "no certified K-sixer with vanishing Brauer class",
                "sixer_link": "sixer_descent.json",
            },
        )
        write_md(
            "LINE_27_ALGEBRA.md",
            f"""# G3D.1B — 27-line algebra of `S_q`

## Scope

Exact six-chart Gr(2,4) containment for lines on the **specialized secondary-0
slice** of `G_q` at `t = (2,3,5,7)`, plus multi-component checks for candidate
rational lines. Full zero-dimensional RUR of the line scheme over
`K = K_proj` is residual (resource-scoped CAS).

## Results

- Charts installed: 6 (all pivot pairs in `P³`)
- Affine solution counts (summed): {lines['total_affine_solutions_summed_over_charts']}
- Secondary-0 rational lines found in box search: {len(lines['rational_lines_secondary0_slice'])}
- Lines with all 12 secondary components vanishing: {
    sum(1 for h in lines['rational_lines_all_components'] if h.get('all_secondary_components_vanish'))
}
- **K-rational line:** {lines['K_rational_line']}
- Exact geometric degree-27 ledger over `K`: residual

## Marker

```text
{lines['marker']}
```

Not a headline point.
""",
        )
        write_md(
            "SIXER_DESCENT.md",
            f"""# G3D.1C — sixers and determinantal descent

{lines['sixer_descent']['note']}

Status: `{lines['sixer_descent']['status']}`

No honest `3×3` linear matrix `A(y)` over `K` with `det A = λ G_q` is claimed.
""",
        )
        write_md(
            "DETERMINANTAL_SURFACE.md",
            """# Determinantal surface

No `K`-determinantal representation of `G_q` is installed. The Severi–Brauer
obstruction for sixer contraction remains open pending an exact `K`-sixer.
""",
        )
        meta["phases"]["lines"] = lines["marker"]
    except Exception as e:
        meta["errors"].append({"phase": "lines", "error": repr(e), "tb": traceback.format_exc()})
        print("  FAIL", e)

    # --- G3D.2/3 hessian + spinor ---
    print("[4/6] hessian + spinor")
    try:
        h, st, cu, w, spn = build_hessian_and_spinor()
        write_json("hessian_matrix.json", h)
        write_json("hessian_rank_strata.json", st)
        write_json("hessian_cube_cover.json", cu)
        write_json("polar_quadric_witt.json", w)
        write_json(
            "spinor_model.json",
            {
                "schema": "g3d-spinor-model-v1",
                "witt_link": "polar_quadric_witt.json",
                "F_q": "OGr(2, Q_q)",
                "split_status": "undecided over K; specialized isotropic lines on secondary-0 slices",
                "marker": w["marker"],
            },
        )
        write_json("spinor_discriminant.json", spn)
        write_md(
            "HESSIAN_MATRIX.md",
            f"""# G3D.2A — Hessian matrix

Symmetric polar matrix `M(z)_ij = B(z, e_i, e_j)` built from the exact G3A/G3P
polarization (`generic_cubic.json` coefficients via `load_betas`).

Symmetry verified: **{h['symmetric']}**

Marker: `{h['marker']}`
""",
        )
        write_md(
            "HESSIAN_RANK_STRATA.md",
            f"""# Hessian rank strata

Specialized rank histograms (secondary-0 slices) are recorded in
`hessian_rank_strata.json`. Exact primary decomposition of the rank-≤3 ideal
over `K` is residual.

Sample rank histogram at t=(2,3,5,7): `{st['specializations'][0]['rank_histogram']}`
""",
        )
        write_md(
            "HESSIAN_CUBE_COVER.md",
            (
                "# G3D.2B — cube cover\n\n"
                "On Gamma = {M(z)v = 0} the identity "
                "Phi(sz+tv) = s^3 Phi(z) + t^3 Phi(v) holds. The ratio cube-class "
                "test in the function field of Hessian components is installed as a "
                "structural reduction; no generic cube root and no K-point were "
                "produced from this lane.\n\n"
                f"Marker: `{cu['marker']}`\n"
            ),
        )
        write_md(
            "POLAR_QUADRIC_WITT.md",
            f"""# G3D.3A — polar quadric Witt model

First-polar matrix `M_q,ij = B(q, e_i, e_j)` exact over `K`. Specializations:

{chr(10).join('- t=' + str(r['t']) + ': rank=' + str(r['rank']) + ', det=' + r['det'] + ', smooth=' + str(r['smooth_quadric_3fold']) for r in w['specializations'])}

Full even Clifford algebra over `Frac(K_proj)` is residual.

Marker: `{w['marker']}`
""",
        )
        write_md(
            "SPINOR_MODEL.md",
            """# Spinor model of lines on `Q_q`

`F_q = OGr(2, Q_q)` is the Severi–Brauer variety attached to the even Clifford
algebra of the five-dimensional quadratic form. Split status over `K` is
undecided; specialized isotropic lines exist on secondary-0 slices.
""",
        )
        write_md(
            "SPINOR_DISCRIMINANT.md",
            f"""# G3D.3B — spinor discriminant

Binary-cubic discriminant `Δ_L` on lines of specialized `Q_q` is computed from
the displayed formula. Nontrivial `Δ = 0` loci (if any) and gcd extractions of
repeated roots are recorded in `spinor_discriminant.json`.

No headline `K`-point was promoted from this specialized probe.

Marker: `{spn['marker']}`
""",
        )
        meta["phases"]["hessian"] = h["marker"]
        meta["phases"]["cube"] = cu["marker"]
        meta["phases"]["witt"] = w["marker"]
        meta["phases"]["spinor"] = spn["marker"]
    except Exception as e:
        meta["errors"].append({"phase": "hessian_spinor", "error": repr(e), "tb": traceback.format_exc()})
        print("  FAIL", e)

    # --- G3D.4 A5 ---
    print("[5/6] A5 structured descent")
    try:
        a5 = build_a5_descent()
        write_json("a5_structured_descent_class_1.json", a5["classes"][0])
        write_json("a5_structured_descent_class_2.json", a5["classes"][1])
        write_json("A5_structured_descent_meta.json", a5)
        write_md(
            "A5_STRUCTURED_DESCENT.md",
            f"""# G3D.4 — exact A5 accelerator and odd-degree descent

## Authorized uses only

1. Quadratic forms / anisotropic kernel (odd degree preserves it).
2. Two-primary Clifford classes (`11α = 0 ⇒ α = 0` on 2-primary torsion).
3. Three-primary sixer / Severi–Brauer Brauer classes.
4. Finite component identification after base change to `L_i`.

## Forbidden

- `X(L_i) ≠ ∅ ⇒ X(K) ≠ ∅`
- odd-degree point of the line scheme ⇒ `K`-point of the line scheme
- sixer over `L_i` ⇒ honest `K` determinantal matrix

Illegal pure-cubic odd-degree descent is **rejected**.

Both A5 classes consume sealed H_A5 + G4 degree-11 data; G3H is optional
accelerator (frame PASS, Springer residual).

Marker: `{a5['marker']}`
""",
        )
        meta["phases"]["a5"] = a5["marker"]
    except Exception as e:
        meta["errors"].append({"phase": "a5", "error": repr(e), "tb": traceback.format_exc()})
        print("  FAIL", e)

    # --- Status / decision ---
    print("[6/6] STATUS / decision")
    headline_point = False
    structural_exits = []
    for key in ("k_simple", "polar_surface", "hessian", "cube", "spinor", "a5"):
        if key in meta["phases"]:
            structural_exits.append(meta["phases"][key])

    # Primary exit: structural multi-pass with residual UNDECIDED for full 27-line/sixer over K
    # Not STRUCTURED-NO-GO (requires all three lanes fully decided)
    # Not POINT-HEADLINE-POSITIVE
    if meta["errors"]:
        primary = "G3D-UNDECIDED"
    elif headline_point:
        primary = "G3D-POINT-HEADLINE-POSITIVE"
    else:
        # We installed structural reductions but did not fully decide 27-line RUR over K
        # nor cube-class nor exact Clifford — honest residual:
        primary = "G3D-UNDECIDED"

    also = [
        m
        for m in structural_exits
        if m
        in {
            "G3D-K-SIMPLE-MODEL-PASS",
            "G3D-POLAR-CUBIC-SURFACE-PASS",
            "G3D-HESSIAN-KERNEL-PASS",
            "G3D-HESSIAN-CUBE-REDUCTION-PASS",
            "G3D-SPINOR-DISCRIMINANT-PASS",
            "G3D-A5-STRUCTURED-DESCENT-PASS",
            "G3D-POLAR-CLIFFORD-PASS",
        }
    ]

    status = f"""# Goal G3D status — structured direct arithmetic on V(Φ)

**Primary exit:** `{primary}`  
**Also achieved (structural):** {', '.join(f'`{m}`' for m in also) if also else '(see phases)'}  
**Headline:** **OPEN**  
**Consumed commit:** see `INPUT_MANIFEST.json`  
**Pinned goal state:** `ff69434ffa49062402234c0661fef69e07416dd7`

## Decision

1. **G3D.0 simple field.** `η = f7` power basis of degree 12 over `P0` with
   exact secondary↔power maps via `P` (constant dens; good-reduction
   nonvanishing of `det P`). Marker `G3D-K-SIMPLE-MODEL-PASS`.
2. **G3D.1A polar surface.** Exact elimination of `a0` from `ℓ_q`; `G_q` as
   K-valued cubic (12 secondary components); `ℓ_q` vanishes; re-embedding
   checks pass; specialized smoothness witnesses. Marker
   `G3D-POLAR-CUBIC-SURFACE-PASS`. No K-rational singular point.
3. **G3D.1B/C lines/sixers.** Six Gr(2,4) charts installed on specialized
   secondary-0 slice; no certified `K`-line or sixer; determinantal descent
   not obtained. Residual: exact RUR over `K`.
4. **G3D.2 Hessian.** Exact symmetric `M(z)`; specialized rank strata; cube
   cover identity/reduction installed; no cube root / no point.
5. **G3D.3 spinor.** Exact first-polar matrix; specialized Witt rank 5; binary
   cubic discriminants on specialized lines; exact even Clifford / SB form
   residual.
6. **G3D.4 A5.** Structured odd-degree descent protocol for both classes;
   illegal pure-cubic descent rejected; no headline from A5 path.

## Why not STRUCTURED-NO-GO

`G3D-STRUCTURED-NO-GO-SCOPED` requires the exact polar-surface line/sixer
route, Hessian rank strata and cube cover, **and** spinor discriminant to be
fully decided on the stated opens. Exact 27-line RUR over `K`, function-field
cube class, and even Clifford class remain residual ⇒ primary exit is
`G3D-UNDECIDED`.

## Why not headline positive

No exact `K_proj`-point of `V(Φ)` was produced and promoted through G2/G3A.

## Phase ledger

```json
{json.dumps(meta['phases'], indent=2)}
```

## Errors

```json
{json.dumps([{{'phase': e['phase'], 'error': e['error']}} for e in meta['errors']], indent=2)}
```

## Resources

- Wall time (produce_all): see meta
- Peak RSS: process-local (expected envelope < 8 GiB for Phase A work)

## Theorem boundary

- Structural / residual packet only.
- Does **not** claim `X_gen(K_proj) ≠ ∅` or emptiness.
- Does **not** rehabilitate G7B coset orbits or illegal odd-degree cubic descent.
"""
    write_md("STATUS.md", status)
    write_json(
        "produce_meta.json",
        {
            "primary_exit": primary,
            "also_exits": also,
            "phases": meta["phases"],
            "errors": [{"phase": e["phase"], "error": e["error"]} for e in meta["errors"]],
            "wall_time_s": round(time.time() - t0, 3),
            "headline": "OPEN",
        },
    )

    # SHA256SUMS for artifacts
    names = [
        "INPUT_MANIFEST.json",
        "k_simple_model.json",
        "polar_cubic_surface.json",
        "line_27_algebra.json",
        "sixer_descent.json",
        "surface_determinantal.json",
        "hessian_matrix.json",
        "hessian_rank_strata.json",
        "hessian_cube_cover.json",
        "polar_quadric_witt.json",
        "spinor_model.json",
        "spinor_discriminant.json",
        "a5_structured_descent_class_1.json",
        "a5_structured_descent_class_2.json",
        "STATUS.md",
        "produce_meta.json",
    ]
    lines_sum = []
    for n in names:
        p = HERE / n
        if p.exists():
            lines_sum.append(f"{sha256(p)}  {n}")
    (HERE / "SHA256SUMS").write_text("\n".join(lines_sum) + "\n")
    print("wrote SHA256SUMS")

    write_md(
        "REPLAY.md",
        f"""# G3D replay

```bash
cd problems/E-klein-cubic/goal_runs_after_ff69434/G3D_DIRECT_ARITHMETIC
python3 produce_all.py
python3 verify_all.py
```

Primary exit: `{primary}`  
Marker line: `G3D_VERIFY_ALL_OK` from `verify_all.py`.
""",
    )

    print("=== done in", round(time.time() - t0, 2), "s primary", primary, "===")
    if meta["errors"]:
        print("ERRORS:", meta["errors"])
        sys.exit(1)


if __name__ == "__main__":
    main()
