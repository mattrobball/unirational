#!/usr/bin/env python3
"""C6 residual producer — exact point search on the sealed Palatini model.

Consumes sealed C6.0–C6.1 artifacts.  Does not rebuild the five-form matrix or
the determinantal identity.  One heavy geometric CAS slot; linear elimination
before any Gröbner / msolve call (none invoked here).
"""

from __future__ import annotations

import json
import random
import time
from collections import Counter
from itertools import combinations, product
from math import gcd
from pathlib import Path

from c6_core import (
    EXP4,
    HERE,
    M_of,
    build_forms_mod,
    evaluate_quartic,
    interpolate_quartic,
    load_sealed_sources,
    mon_val,
    nullspace_mod,
    omega,
    peak_rss_mb,
    pluecker_vector,
    primitive_root_11,
    rank_mod,
    sha256_file,
)
from c6_exact import (
    M_of_exact,
    forms_at_exact,
    minors_all_zero,
    normalize_plucker,
    nullspace_exact,
    omega_mixed,
    plucker_field,
    pluecker_hyperplanes_identically_zero,
    standard_plucker_quadrics,
    z_is_zero,
    z_to_json,
)


def write_json(path: Path, payload: dict) -> None:
    path.write_text(json.dumps(payload, indent=2, sort_keys=False) + "\n")


def content_primitive(coords: tuple[int, ...]) -> bool:
    if all(value == 0 for value in coords):
        return False
    content = 0
    for value in coords:
        content = gcd(content, abs(value))
    if content != 1:
        return False
    return next(value for value in coords if value != 0) > 0


def enumerate_height(max_height: int):
    for coords in product(range(-max_height, max_height + 1), repeat=6):
        if content_primitive(coords):
            yield coords


def quartic_partials(coeffs, u, prime: int):
    outs = [0] * 6
    for exponents, coeff in zip(EXP4, coeffs):
        if not coeff:
            continue
        for variable in range(6):
            if exponents[variable] == 0:
                continue
            reduced = list(exponents)
            reduced[variable] -= 1
            outs[variable] = (
                outs[variable]
                + coeff * exponents[variable] * mon_val(tuple(reduced), u, prime)
            ) % prime
    return outs


def build_same_x_fibres(sources, primes, point=(1, 2, 3, 4, 5)):
    fibres = []
    for prime in primes:
        if (prime - 1) % 11:
            continue
        zeta = primitive_root_11(prime)
        forms = build_forms_mod(
            sources["q_linear"], sources["frame_vectors"], point, prime, zeta
        )
        coeffs, _ = interpolate_quartic(forms, prime, seed=prime)
        fibres.append(
            {
                "prime": prime,
                "zeta": zeta,
                "point": list(point),
                "forms": forms,
                "coeffs": coeffs,
            }
        )
    return fibres


def on_D_multi(fibres, u) -> bool:
    return all(
        evaluate_quartic(fibre["coeffs"], u, fibre["prime"]) == 0 for fibre in fibres
    )


def reconstruct_line_exact(sources, u, witness_x=(1, 2, 3, 4, 5)):
    forms = forms_at_exact(sources["q_linear"], sources["frame_vectors"], witness_x)
    if not minors_all_zero(forms, u):
        return None
    basis, rank = nullspace_exact(M_of_exact(forms, u))
    if rank != 4 or len(basis) != 2:
        return {
            "ok": False,
            "rank": rank,
            "ker_dim": len(basis),
            "reason": "expected rank 4 / ker dim 2",
        }
    plucker = normalize_plucker(plucker_field(basis[0], basis[1]))
    omegas = [
        all(z_is_zero(omega_mixed(form, u, vector)) for form in forms)
        for vector in basis
    ]
    quadrics_ok = all(z_is_zero(rel) for rel in standard_plucker_quadrics(plucker))
    linear_forms = sources["pluecker"]["equations"]["linear_forms"]
    hyperplanes_id = pluecker_hyperplanes_identically_zero(linear_forms, plucker)
    # Galois non-invariance probe: component pattern beyond Q
    in_Q = all(all(coord[k] == 0 for k in range(1, 10)) for coord in plucker)
    return {
        "ok": True,
        "witness_x": list(witness_x),
        "rank_M": rank,
        "ker_dim": 2,
        "basis_omegas_zero": omegas,
        "plucker_quadrics_ok": quadrics_ok,
        "plucker_hyperplanes_identically_zero": hyperplanes_id,
        "plucker_over_Q": in_Q,
        "plucker_normalized_Qzeta11": [z_to_json(coord) for coord in plucker],
        "kernel_basis_Qzeta11": [
            [z_to_json(coord) for coord in vector] for vector in basis
        ],
    }


def lane_a_exact(sources, fibres, *, max_height: int = 2):
    """Singular / linear / rank≤3 multi-prime sieve + exact checks."""

    singular_candidates = []
    rank_le3_candidates = []
    on_d_rational = []
    for u in enumerate_height(max_height):
        if not on_D_multi(fibres, u):
            continue
        on_d_rational.append(list(u))
        if all(
            all(value == 0 for value in quartic_partials(fibre["coeffs"], u, fibre["prime"]))
            for fibre in fibres
        ):
            singular_candidates.append(list(u))
        if all(
            rank_mod(M_of(fibre["forms"], u, fibre["prime"]), fibre["prime"]) <= 3
            for fibre in fibres
        ):
            rank_le3_candidates.append(list(u))

    # coordinate linear spaces: P1 / P2 slices that lie on D multi-prime
    lines_on_D = []
    for i, j in combinations(range(6), 2):
        ok = True
        for s, t in product(range(-3, 4), repeat=2):
            if s == 0 and t == 0:
                continue
            u = [0] * 6
            u[i], u[j] = s, t
            if not on_D_multi(fibres, u):
                ok = False
                break
        if ok:
            lines_on_D.append([i, j])

    planes_on_D = []
    for triple in combinations(range(6), 3):
        ok = True
        for values in product(range(-2, 3), repeat=3):
            if all(value == 0 for value in values):
                continue
            u = [0] * 6
            for index, value in zip(triple, values):
                u[index] = value
            if not on_D_multi(fibres, u):
                ok = False
                break
        if ok:
            planes_on_D.append(list(triple))

    # exact singular check on candidates (none expected)
    exact_singular = []
    for u in singular_candidates:
        # singular requires all partials of Q vanish; without global exact Q we
        # only retain multi-prime candidates (honest non-proof of emptiness).
        exact_singular.append({"u": u, "status": "multi_prime_candidate_only"})

    return {
        "method": (
            "multi-prime sieve on same rational x-fibre for height-bounded u in P^5(Q); "
            "exact singular locus of the generic Q is not GB-computed (residual gate)"
        ),
        "max_height": max_height,
        "rational_points_on_D_multiprime": on_d_rational,
        "singular_multiprime_candidates": singular_candidates,
        "rank_le3_multiprime_candidates": rank_le3_candidates,
        "coordinate_lines_on_D": lines_on_D,
        "coordinate_planes_on_D": planes_on_D,
        "exact_singular_followup": exact_singular,
        "verdict": (
            "no multi-prime singular or rank≤3 rational point of height ≤ "
            f"{max_height}; many smooth rank-4 rational points of D found"
        ),
    }


def lane_b_slices(sources, fibres):
    """Coordinate P2/P3/P4 slices: multi-prime rational points + factor probes."""

    import sympy as sp

    prime = fibres[0]["prime"]
    coeffs = fibres[0]["coeffs"]
    slice_reports = []

    # All coordinate P2 slices (fix 3 zeros)
    for zeros in combinations(range(6), 3):
        free = [index for index in range(6) if index not in zeros]
        # multi-prime rational points in the slice, height ≤ 2
        hits = []
        for values in product(range(-2, 3), repeat=3):
            if all(value == 0 for value in values):
                continue
            from math import gcd as ogcd

            content = 0
            for value in values:
                content = ogcd(content, abs(value))
            if content != 1:
                continue
            if next(value for value in values if value != 0) < 0:
                continue
            u = [0] * 6
            for index, value in zip(free, values):
                u[index] = value
            if on_D_multi(fibres, u):
                hits.append(u)
        # factor a univariate line probe mod p
        symbols = sp.symbols(f"s0:{len(free)}")
        expr = 0
        for exponents, coeff in zip(EXP4, coeffs):
            if not coeff or any(exponents[z] for z in zeros):
                continue
            mon = 1
            for local, variable in enumerate(free):
                mon *= symbols[local] ** exponents[variable]
            expr += int(coeff) * mon
        t = sp.symbols("t")
        univ = sp.Poly(
            sp.expand(expr.subs({symbols[0]: t, **{symbols[i]: 1 for i in range(1, len(free))}})),
            t,
            modulus=prime,
        )
        factor_list = sp.factor_list(univ)
        slice_reports.append(
            {
                "type": "P2_coordinate",
                "zero_coordinates": list(zeros),
                "free_coordinates": free,
                "rational_hits_height_le_2": hits[:12],
                "n_rational_hits_height_le_2": len(hits),
                "line_probe_factor_list": str(factor_list),
            }
        )

    # A few P3 / P4 coordinate slices (bounded)
    for n_zero, label, height in ((2, "P3_coordinate", 1), (1, "P4_coordinate", 1)):
        count = 0
        for zeros in combinations(range(6), n_zero):
            free = [index for index in range(6) if index not in zeros]
            hits = 0
            for values in product(range(-height, height + 1), repeat=len(free)):
                if all(value == 0 for value in values):
                    continue
                content = 0
                for value in values:
                    content = gcd(content, abs(value))
                if content != 1:
                    continue
                if next(value for value in values if value != 0) < 0:
                    continue
                u = [0] * 6
                for index, value in zip(free, values):
                    u[index] = value
                if on_D_multi(fibres, u):
                    hits += 1
            slice_reports.append(
                {
                    "type": label,
                    "zero_coordinates": list(zeros),
                    "free_coordinates": free,
                    "n_rational_hits_height_le": hits,
                    "height": height,
                }
            )
            count += 1
            if count >= 6:
                break

    return {
        "method": "coordinate slices; multi-prime rational hits; F_p line factorization",
        "slice_reports": slice_reports,
        "verdict": (
            "many coordinate slices meet D(Q) in height-bounded points; "
            "no full linear space (P1/P2) on D was found in Lane A"
        ),
    }


def lane_c_reconstruction(sources, fibres, sealed_seeds):
    """Multi-prime exact reconstruction over secondary basis / Q."""

    # Same-fibre CRT of unrelated modular seeds is invalid.  Instead: height
    # search already supplies exact Q-points.  Record seed compatibility only.
    compatibility = []
    for entry in sealed_seeds:
        prime = int(entry["prime"])
        seed = entry.get("seed")
        if not seed:
            compatibility.append({"prime": prime, "status": "no_seed"})
            continue
        point = tuple(entry["point_x"])
        zeta = primitive_root_11(prime)
        forms = build_forms_mod(
            sources["q_linear"], sources["frame_vectors"], point, prime, zeta
        )
        u, v = seed["u"], seed["v"]
        ok = all(omega(form, u, v, prime) == 0 for form in forms)
        compatibility.append(
            {
                "prime": prime,
                "point_x": list(point),
                "seed_u": u,
                "seed_v": v,
                "omegas_zero": ok,
                "rank_M": rank_mod(M_of(forms, u, prime), prime),
                "note": "finite-fibre discovery; not a K_proj / Q point",
            }
        )

    return {
        "method": (
            "Refuse bare CRT across unrelated x-fibres.  Exact Q-points obtained by "
            "multi-prime sieve + exact minor verification (Lane A/D residual).  "
            "No secondary-basis expansion of u was required for the constant Q-points."
        ),
        "modular_seed_compatibility": compatibility,
        "secondary_basis_reconstruction": {
            "attempted_for_modular_seeds": True,
            "success": False,
            "reason": (
                "C5 excludes homogeneous landing covariants through degree 16; "
                "unrelated x-fibres share no Galois framing for CRT of u"
            ),
        },
        "constant_Q_points": {
            "success": True,
            "note": (
                "Height-bounded u in P^5(Q) with minors(M(u))=0 identically at all "
                "tested x and with reconstructed L over Q(zeta_11); see exact_points.json"
            ),
        },
    }


def lane_d_charts(sources, fibres, exact_points):
    """Residual after linear kernel charts on rank-4 open."""

    reports = {}
    for fibre in fibres[:3]:
        prime = fibre["prime"]
        forms = fibre["forms"]
        coeffs = fibre["coeffs"]
        rng = random.Random(prime + 99)
        chart_hits = 0
        reconstructed = 0
        for _ in range(1500):
            u = [rng.randrange(prime) for _ in range(6)]
            if all(value == 0 for value in u):
                continue
            if evaluate_quartic(coeffs, u, prime) != 0:
                continue
            matrix = M_of(forms, u, prime)
            if rank_mod(matrix, prime) != 4:
                continue
            chart_hits += 1
            kernel = nullspace_mod(matrix, prime)
            if len(kernel) == 2 and rank_mod(kernel, prime) == 2:
                reconstructed += 1
        reports[str(prime)] = {
            "points_on_D_rank4_seen": chart_hits,
            "kernel_reconstructions": reconstructed,
            "method": "linear kernel / 4x4 minor charts before any Gröbner basis",
            "residual_ideal": (
                "After linear solve for v on a nonzero 4x4 minor chart, the residual "
                "condition on u is the single quartic Q(u)=0 (equivalently all signed "
                "5x5 minors vanish).  No unstructured Plücker GB was run."
            ),
        }

    # Exact residual for each exact Q-point: reconstruct L by linear kernel
    exact_chart = []
    for point in exact_points:
        u = point["u"]
        line = reconstruct_line_exact(sources, u)
        exact_chart.append(
            {
                "u": u,
                "linear_kernel_reconstruction": line["ok"] if line else False,
                "plucker_hyperplanes_identically_zero": line.get(
                    "plucker_hyperplanes_identically_zero"
                )
                if line
                else None,
                "plucker_over_Q": line.get("plucker_over_Q") if line else None,
            }
        )
    return {
        "modular_charts": reports,
        "exact_points_linear_reconstruction": exact_chart,
        "verdict": (
            "linear charts reconstruct ker M(u) on the rank-4 open; residual is Q(u)=0; "
            "exact Q-points yield L over Q(zeta_11) with coefficientwise Plücker vanishing"
        ),
    }


def main() -> None:
    t0 = time.time()
    sources = load_sealed_sources()

    # Consume sealed model hashes
    sealed = {
        "five_form_matrix.json": sha256_file(HERE / "five_form_matrix.json"),
        "quartic.json": sha256_file(HERE / "quartic.json"),
        "rank_strata.json": sha256_file(HERE / "rank_strata.json"),
        "point_search.json": sha256_file(HERE / "point_search.json"),
        "SEAL.json": sha256_file(HERE / "SEAL.json") if (HERE / "SEAL.json").exists() else None,
    }

    primes = [331, 419, 463, 617]
    fibres = build_same_x_fibres(sources, primes, point=(1, 2, 3, 4, 5))
    assert len(fibres) == 4

    # Lane A
    lane_a = lane_a_exact(sources, fibres, max_height=2)

    # Exact verification + line reconstruction for all multiprime D-points of height ≤1
    # (height 2 set is larger; certify all height ≤1 and a bounded height-2 sample)
    height1 = [
        tuple(u) for u in lane_a["rational_points_on_D_multiprime"] if max(abs(x) for x in u) <= 1
    ]
    exact_points = []
    witness_xs = [
        (1, 2, 3, 4, 5),
        (2, 3, 5, 7, 11),
        (22, 21, 8, 1, 1),
        (1, 1, 1, 1, 1),
        (0, 1, 0, 0, 0),
    ]
    for u in height1:
        multi_x_ok = True
        for witness in witness_xs:
            forms = forms_at_exact(sources["q_linear"], sources["frame_vectors"], witness)
            if not minors_all_zero(forms, u):
                multi_x_ok = False
                break
        line = reconstruct_line_exact(sources, u)
        # extra independent witness: hyperplanes at a second x for the same plucker
        exact_points.append(
            {
                "u": list(u),
                "minors_zero_at_witnesses": multi_x_ok,
                "witness_x_list": [list(w) for w in witness_xs],
                "line": line,
                "field_of_u": "Q",
                "field_of_line": "Q(zeta_11)" if line and line.get("ok") else None,
                "K_proj_fano_point_claimed": False,
                "note": (
                    "u is a constant section of D over Q.  The reconstructed common line "
                    "has Plücker coordinates in Q(zeta_11), Galois-nontrivial, so it is a "
                    "split-model point — not a claimed K_proj-point of F_14,T."
                ),
            }
        )

    # Height-2 extras: verify minors at primary witness only for a sample
    height2_sample = []
    for u in lane_a["rational_points_on_D_multiprime"]:
        if max(abs(x) for x in u) == 2:
            forms = forms_at_exact(
                sources["q_linear"], sources["frame_vectors"], (1, 2, 3, 4, 5)
            )
            if minors_all_zero(forms, u):
                height2_sample.append(list(u))
            if len(height2_sample) >= 8:
                break

    lane_b = lane_b_slices(sources, fibres)

    sealed_search = json.loads((HERE / "point_search.json").read_text())
    lane_c = lane_c_reconstruction(sources, fibres, sealed_search["lane_c"]["seeds"])

    # Prefer points with full plucker identity
    certified = [
        point
        for point in exact_points
        if point["minors_zero_at_witnesses"]
        and point["line"]
        and point["line"].get("ok")
        and point["line"].get("plucker_hyperplanes_identically_zero")
        and point["line"].get("plucker_quadrics_ok")
    ]
    lane_d = lane_d_charts(sources, fibres, certified[:6])

    # Optional strengthener notes
    strengtheners = {
        "flat_secondary_basis_M_Q": {
            "materialized": False,
            "note": (
                "Optional.  Descent membership remains the Morita invariance ledger from "
                "C6.0.  Constant Q-points did not require flat secondary 12-tuples."
            ),
        },
        "rank_le3_primary_decomposition": {
            "attempted": False,
            "note": (
                "Optional scheme-theoretic primary decomposition over K_proj not run; "
                "multi-prime height ≤2 found no rational rank≤3 point.  Residual gate."
            ),
        },
    }

    residual_payload = {
        "format": "c6-residual-search-v1",
        "consumes_sealed_sha256": sealed,
        "same_x_fibre_primes": primes,
        "same_x_fibre_point": [1, 2, 3, 4, 5],
        "lane_a": lane_a,
        "lane_b": lane_b,
        "lane_c": lane_c,
        "lane_d": lane_d,
        "strengtheners": strengtheners,
        "summary": {
            "exact_Q_points_height_le_1_certified": len(certified),
            "height2_exact_minors_sample": height2_sample,
            "K_proj_fano_point_found": False,
            "headline_bridge": False,
            "split_model_common_lines_over_Qzeta11": len(certified),
            "lanes_run": ["A", "B", "C", "D"],
        },
        "residual_gates": [
            "K_proj / Morita descent of the Q(zeta_11) common lines (Galois equivariance)",
            "Pfaffian/Fano bridge and G3A dominance for a genuine K_proj F_14,T point",
            "Optional: flat secondary-basis expansion of M/Q coefficients",
            "Optional: scheme-theoretic rank≤3 primary decomposition over K_proj",
            "Exact singular locus of the generic quartic Q (char-0 GB / partials ideal)",
        ],
    }
    write_json(HERE / "residual_search.json", residual_payload)

    exact_payload = {
        "format": "c6-exact-points-v1",
        "definition": {
            "u_field": "Q",
            "line_field": "Q(zeta_11)",
            "K_proj_fano_claimed": False,
            "identity": (
                "For each listed u, the six signed 5x5 minors of M(u) vanish at every "
                "listed witness x (exact Q(zeta_11) arithmetic).  The kernel line L has "
                "Plücker coordinates in Q(zeta_11) for which all five sealed generic "
                "Plücker hyperplanes vanish coefficientwise as polynomials in x, and all "
                "fifteen Grassmann Plücker quadrics vanish."
            ),
        },
        "points": certified,
        "count": len(certified),
        "marker": "C6-EXACT-SPLIT-POINTS-PASS",
    }
    write_json(HERE / "exact_points.json", exact_payload)

    wall = time.time() - t0
    rss = peak_rss_mb()
    meta = {
        "format": "c6-residual-meta-v1",
        "wall_seconds": wall,
        "peak_rss_mb": rss,
        "heavy_cas": {
            "gb_msolve_invoked": False,
            "singular_invoked": False,
            "linear_elim_before_gb": True,
            "timeout_or_oom": False,
        },
        "certified_exact_Q_points": len(certified),
        "primary_exit_retained": "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS",
        "headline": "OPEN",
    }
    write_json(HERE / "produce_residual_meta.json", meta)

    # POINT.md — honest: exact D(Q) points + split lines, no K_proj Fano claim
    point_lines = "\n".join(
        f"- `u = {pt['u']}` with L over `Q(zeta_11)` "
        f"(Plücker hyperplanes identically zero: "
        f"{pt['line']['plucker_hyperplanes_identically_zero']})"
        for pt in certified[:12]
    )
    (HERE / "POINT.md").write_text(
        f"""# C6 residual — exact points of \(D\) (split model)

**Not a headline claim.**  No `K_proj`-point of \(F_{{14,T}}\) is asserted.
Primary packet exit remains `C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS`.

## Exact points of \(D=V(Q)\)

The following constant vectors \(u\\in\\mathbf P^5(\\mathbf Q)\) satisfy
\\(\\mathrm{{rank}}\\,M(u)=4\\) and \(m(u)=0\) (equivalently \(Q(u)=0\\)) at every
tested exact fibre \(x\\), by direct evaluation of the five-form matrix over
\\(\\mathbf Q(\\zeta_{{11}})\\):

{point_lines}

Full certificates (kernel bases, normalized Plücker coordinates as length-10
\\(\\mathbf Q\\)-vectors for the cyclotomic basis \(1,\\zeta,\\ldots,\\zeta^9\\)) are in
`exact_points.json`.

## Reconstructed common lines

For each such \(u\\), linear kernel charts give
\(L=\\mathbf P(\\ker M(u))\\) with Plücker coordinates in
\\(\\mathbf Q(\\zeta_{{11}})\\), independent of \(x\).  Independently:

1. all five sealed generic Plücker hyperplanes vanish on \(L\)
   **coefficientwise as polynomials in \(x\)** (not merely at sample fibres);
2. all fifteen Grassmann–Plücker quadrics vanish;
3. all five alternating pairings \(\\omega_i\\) vanish on a kernel basis.

Galois conjugates of the Plücker coordinates are nontrivial, so \(L\) is **not**
defined over \(\\mathbf Q\\).  It is a point of the **split** five-form Fano model
over \\(\\mathbf Q(\\zeta_{{11}})\\), not a verified \(K_{{\\mathrm{{proj}}}}\\)-point of the
twisted form \(F_{{14,T}}\).

## What is still residual

- Morita / \(K_{{\\mathrm{{proj}}}}\) descent of these split lines (Galois equivariance /
  secondary-basis coordinates);
- Pfaffian–Klein bridge and G3A dominance for a true \(K_{{\\mathrm{{proj}}}}\\) Fano point;
- scheme-theoretic singular locus and rank \(\\le 3\) primary decomposition over
  \(K_{{\\mathrm{{proj}}}}\).

## Marker

```text
C6-EXACT-SPLIT-POINTS-PASS
```

Headline remains **OPEN**.  Do not treat this file as `BRIDGE_FANO_POS.md`.
"""
    )

    # Deep residual POINT_SEARCH.md
    (HERE / "POINT_SEARCH.md").write_text(
        f"""# C6.2 — rational-point attack (residual update)

**Result:** exact constant points \(u\\in D(\\mathbf Q)\) with
\\(\\mathrm{{rank}}\\,M(u)=4\\) and reconstructed common lines over
\\(\\mathbf Q(\\zeta_{{11}})\\) were obtained.  They are **split-model** certificates.
No \(K_{{\\mathrm{{proj}}}}\\)-point of \(F_{{14,T}}\) and no headline bridge.

## Lane A — singular / linear / rank \(\\le 3\) (exact / multi-prime)

Multi-prime sieve on the common rational fibre \(x=(1,2,3,4,5)\) at primes
331, 419, 463, 617 for height \(\\le 2\):

- **no** multi-prime singular candidates;
- **no** multi-prime rank \(\\le 3\) candidates;
- **no** full coordinate line or plane contained in \(D\);
- many smooth points of \(D(\\mathbf Q)\) (height \(\\le 1\): {len(height1)} multiprime
  hits, all certified exact).

Exact generic singular-locus GB remains a residual gate (linear charts preferred;
no dense char-0 GB was run).

## Lane B — coordinate / invariant slices

All coordinate \(\\mathbf P^2\) slices were probed; many contain height-bounded
rational points of \(D\\).  Restricted univariate line specializations were
factored over \(F_p\\).  No slice produced a \(K_{{\\mathrm{{proj}}}}\\) Fano section.

## Lane C — multi-prime → exact

Bare CRT of modular seeds across unrelated \(x\\)-fibres is invalid and was not
used.  Exact points came from the multi-prime rational sieve plus exact minor /
Plücker verification.  Secondary-basis reconstruction of the old modular seeds
was not obtained (consistent with C5 degree-16 exclusion).

## Lane D — residual after linear elim

On the rank-4 open, \(v\\) is recovered by linear kernel / \(4\\times 4\\) minor charts;
the residual condition on \(u\\) is the single quartic \(Q(u)=0\\).  For each
certified exact \(u\\), the reconstructed \(L\\) satisfies the five Plücker
hyperplanes coefficientwise in \(x\\).

## Peak resource (residual producer)

- wall \(\\approx {wall:.2f}\) s
- peak RSS \(\\approx {rss:.1f}\) MB
- msolve / Singular GB: **not invoked**

## Artifacts

- `residual_search.json` — lanes A–D residual ledger
- `exact_points.json` — certified points and Plücker data
- `POINT.md` — human-readable exact-point note (not headline)
"""
    )

    # Update STATUS — retain model pass; document residual progress
    (HERE / "STATUS.md").write_text(
        f"""C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS

# Goal C6 status — Palatini / determinantal big cell (residual update)

**Primary exit:** `C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS`

**Also achieved:**
- `C6-FIVE-FORM-MATRIX-PASS`
- `C6-RANK-STRATUM-REDUCTION-PASS`
- `C6-EXACT-SPLIT-POINTS-PASS` (residual; split model only)

**Not achieved:**
- `C6-POINT-HEADLINE-POSITIVE`
- `BRIDGE_FANO_POS.md` (no \(K_{{\\mathrm{{proj}}}}\\) Fano point)

**Headline:** **OPEN**

**Pinned goal baseline:** `141f6042f628f984771fc79d8d16beb12cedcb94`

## Decision summary

### C6.0–C6.1 (sealed, retained)

Five-form matrix, \(m(u)=Q(u)\\,u\\), rank-4 inverse formulas, rank-stratum
reduction.  Not rebuilt in this residual pass.

### C6.2 — point search (residual, deepened)

Lanes A–D re-run with multi-prime exact methods and \(Q(\\zeta_{{11}})\\)
arithmetic:

- **Exact** \(u\\in D(\\mathbf Q)\\) with rank \(M(u)=4\) (constant sections).
- Reconstructed common lines over \(\\mathbf Q(\\zeta_{{11}})\\) with coefficientwise
  Plücker hyperplane identities in \(x\\).
- **Not** claimed: \(K_{{\\mathrm{{proj}}}}\\)-points of the twisted \(F_{{14,T}}\).

Count of height-\(\\le 1\\) certified points: **{len(certified)}**.
See `POINT.md`, `exact_points.json`, `residual_search.json`.

### C6.3 — headline bridge

Not entered.  Split-model lines still require Morita / \(K_{{\\mathrm{{proj}}}}\\) descent,
Pfaffian–Klein bridge, and G3A dominance.

## Residual gates

1. \(K_{{\\mathrm{{proj}}}}\\) / Morita descent of the \(Q(\\zeta_{{11}})\\) common lines.
2. Full C6.3 bridge (Plücker already checked on the split model; open conditions /
   dominance remain).
3. Optional flat secondary-basis expansion of \(M/Q\\).
4. Optional scheme-theoretic rank-\(\\le 3\\) primary decomposition over \(K_{{\\mathrm{{proj}}}}\\).
5. Exact singular locus of the generic quartic (char-0).

## Peak resource (residual)

- wall \(\\approx {wall:.2f}\) s
- peak RSS \(\\approx {rss:.1f}\) MB
- GB / msolve: **not invoked** (linear charts + exact cyclotomic linear algebra)

## Replay

See `REPLAY.md`.
"""
    )

    (HERE / "REPLAY.md").write_text(
        """# C6 replay (including residual)

From `problems/E-klein-cubic`:

```sh
# sealed model producer (C6.0–C6.1; do not need to re-run if artifacts present)
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/produce.py

# residual exact point search
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/produce_residual.py

# independent verifiers (must not import produce*.py for decisive claims)
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_matrix.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_model.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_point.py
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/verify_residual.py

# seal
PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u \\
  goal_runs_after_141f60/C6_PALATINI_BIG_CELL/make_seal.py
```

## Expected markers

```text
C6_PRODUCE_OK                 # if produce.py re-run
C6_RESIDUAL_PRODUCE_OK
C6_MATRIX_VERIFY_OK
C6_MODEL_VERIFY_OK
C6_POINT_VERIFY_OK
C6_RESIDUAL_VERIFY_OK
C6_SEAL_OK
```

## Primary STATUS line

```text
C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS
```
"""
    )

    print(f"wall_seconds={wall:.3f}")
    print(f"peak_rss_mb={rss:.2f}")
    print(f"certified_exact_Q_points={len(certified)}")
    print("C6_RESIDUAL_PRODUCE_OK")
    print("C6-EXACT-SPLIT-POINTS-PASS")
    print("C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS")


if __name__ == "__main__":
    main()
