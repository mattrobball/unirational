#!/usr/bin/env python3
"""Produce the exact finite payload for Goal J.

The computation is deliberately small.  It recomputes the affine S3
cohomology class on the fixed elliptic, the marked-divisor permutation
characters, and extracts the already-certified subgroup restrictions of
H^{2,1}(X).  It does not import the independent verifier.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parent.parent
SOURCES = {
    "character_screen": PROBLEM / "certificates/hodge_centers/character_screen.json",
    "incidence": PROBLEM / "certificates/strata/incidence_exact.json",
    "marked_s3": PROBLEM / "certificates/strata/marked_s3_geometry.json",
    "normal_characters": PROBLEM / "certificates/strata/normal_characters.json",
    "weil_model": PROBLEM / "certificates/exact_weil_check.py",
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


# Elements (i,e) represent r^i s^e, where r^3=s^2=1 and srs=r^{-1}.
GROUP = tuple((i, e) for e in range(2) for i in range(3))
IDENTITY = (0, 0)


def mul(g: tuple[int, int], h: tuple[int, int]) -> tuple[int, int]:
    i, e = g
    j, f = h
    return ((i + (-1 if e else 1) * j) % 3, (e + f) % 2)


def action(g: tuple[int, int], a: int) -> int:
    """The sign action of S3 on <q> = Z/3."""
    return ((-1 if g[1] else 1) * a) % 3


def is_cocycle(values: tuple[int, ...]) -> bool:
    c = dict(zip(GROUP, values, strict=True))
    if c[IDENTITY] != 0:
        return False
    return all(c[mul(g, h)] == (c[g] + action(g, c[h])) % 3 for g in GROUP for h in GROUP)


def coboundary(a: int) -> tuple[int, ...]:
    return tuple((action(g, a) - a) % 3 for g in GROUP)


def class_representative(values: tuple[int, ...], coboundaries: set[tuple[int, ...]]) -> tuple[int, ...]:
    translates = [tuple((x + b) % 3 for x, b in zip(values, bd, strict=True)) for bd in coboundaries]
    return min(translates)


def decompose_s3_character(values: tuple[int, int, int]) -> dict[str, int]:
    """Decompose values on (1, transposition, 3-cycle)."""
    irreps = {
        "trivial": (1, 1, 1),
        "sign": (1, -1, 1),
        "standard": (2, 0, -1),
    }
    class_sizes = (1, 3, 2)
    return {
        name: sum(n * x * y for n, x, y in zip(class_sizes, values, chi, strict=True)) // 6
        for name, chi in irreps.items()
    }


def body_hash(data: dict) -> str:
    raw = json.dumps(data, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(raw).hexdigest()


def main() -> None:
    screen = json.loads(SOURCES["character_screen"].read_text())
    marked = json.loads(SOURCES["marked_s3"].read_text())

    cocycles = [v for v in itertools.product(range(3), repeat=len(GROUP)) if is_cocycle(v)]
    coboundaries = {coboundary(a) for a in range(3)}
    classes = {class_representative(c, coboundaries) for c in cocycles}

    # c(r)=q and c(s)=0 for r=(1,0), s=(0,1).
    affine = tuple((i if e == 0 else i) % 3 for i, e in GROUP)
    assert is_cocycle(affine)
    affine_class = class_representative(affine, coboundaries)

    perm3 = (3, 1, 0)  # S3/C2
    perm2 = (2, 0, 2)  # S3/C3
    e_marks = tuple(4 * x for x in perm3)  # I + 3 II orbits
    l_marks = tuple(x + 2 * y for x, y in zip(perm2, perm3, strict=True))
    e_div0 = tuple(x - 1 for x in e_marks)
    l_div0 = tuple(x - 1 for x in l_marks)

    subgroup_rows = []
    for row in screen["subgroup_screen"]:
        subgroup_rows.append(
            {
                "label": row["H_label"],
                "id": row["H_id"],
                "order": row["H_order"],
                "conjugate_subgroup_count": row["H_count"],
                "H21_irrep_multiplicities": row["restriction_H21_multiplicities"],
                "invariant_dimension": row["restriction_H21_multiplicities"][0],
            }
        )

    s3_rows = [r for r in subgroup_rows if r["label"].startswith("S3_class")]
    assert all(r["H21_irrep_multiplicities"] == [1, 0, 2] for r in s3_rows)

    payload = {
        "packet": "J_FIXED_CENTRE_PRYM",
        "exit": "J-INVARIANT-TOO-WEAK",
        "overall_problem_headline": "OPEN",
        "consumed_repository_head": "2140419410cfff2f7d7dcca166acef8c16a0d41b",
        "pinned_baseline": "715faf441289e2589b9325311b6613ea0331bf88",
        "source_sha256": {str(path.relative_to(PROBLEM)): sha256(path) for path in SOURCES.values()},
        "affine_S3_class": {
            "presentation": "S3=<r,s | r^3=s^2=1, srs=r^-1>",
            "module": "<q>=Z/3 with r acting +1 and s acting -1",
            "element_order": [list(g) for g in GROUP],
            "cocycle_values_in_element_order": list(affine),
            "number_of_1_cocycles": len(cocycles),
            "number_of_1_coboundaries": len(coboundaries),
            "number_of_H1_classes": len(classes),
            "H1_isomorphism": "Z/3",
            "selected_class_nonzero": affine_class != class_representative(tuple(0 for _ in GROUP), coboundaries),
            "selected_class_order": 3,
            "restriction_to_C3": "generator q",
            "restriction_to_each_reflection_C2": "zero class",
            "period": 3,
            "index": 3,
            "multisection_degree_condition": "3 divides d",
        },
        "linear_actions": {
            "H10_E": "sign: translations act trivially; reflections act by -1",
            "Pic0_pullback": "sign: t_q^*=id and (t_a o [-1])^*=[-1]^*",
            "Alb1": "affine cocycle above; not the Pic0 pullback action",
        },
        "marked_generalized_jacobians": {
            "E_marked_counts": {
                "type_I": 3,
                "type_II": 9,
                "S3_orbits": "4 copies of S3/C2",
            },
            "E_permutation_character": list(e_marks),
            "E_Div0_character": list(e_div0),
            "E_Div0_decomposition": decompose_s3_character(e_div0),
            "L_marked_counts": {
                "type_I": 6,
                "C6": 2,
                "S3_orbits": "2 copies of S3/C2 plus S3/C3",
            },
            "L_permutation_character": list(l_marks),
            "L_Div0_character": list(l_div0),
            "L_Div0_decomposition": decompose_s3_character(l_div0),
            "warning": "Orbit counts do not identify the marked points with E[2]+<q>.",
        },
        "target_hodge": {
            "H21_dimension": 5,
            "G_representation": "W*",
            "subgroup_rows": subgroup_rows,
            "involution_plus_minus_dimensions": [3, 2],
            "S3_restriction": "trivial + 2 standard; sign multiplicity 0",
            "D12_restriction": "trivial + two 2-dimensional irreducibles; all three nontrivial linears have multiplicity 0",
            "fixed_elliptic_differential_character": "sign",
            "fixed_elliptic_channel_multiplicity": 0,
            "JX_isogeny_type": "E_11^5, CM(E_11)=Q(sqrt(-11))",
            "fixed_elliptic_j": marked["E_t"]["j_invariant"]["exact"],
            "fixed_elliptic_has_CM": marked["E_t"]["cm"]["has_CM"],
            "Hom_fixed_elliptic_to_E11": 0,
        },
        "stabilization_countermodel": {
            "fixed_locus_functoriality_gap": "A dominant equivariant morphism need not be dominant on fixed loci.",
            "fixed_locus_counterexample": "For a free 2-torsion translation on an elliptic A and trivial involution on Y, A x Y -> Y is equivariant dominant but (A x Y)^t is empty and Y^t=Y.",
            "fixed_data": "Equivariantly resolve and then blow up the embedded G-arrangement of the actual E_t and L_t inside P(W).",
            "hodge_data": "Blow up a free 660-component G-orbit of a curve C with J(X) an isogeny factor of J(C).",
            "fixed_and_hodge_decouple": True,
            "free_orbit_fixed_loci_for_nontrivial_H": "empty",
            "H3_added": "H1(C,Q)(-1) tensor Q[G]",
            "contains_target": "H3(X,Q) as a split G-Hodge substructure",
            "polarization_scope": "target natural polarization up to positive rational scalar, not an integral principal direct factor",
            "logical_conclusion": "No incompatibility theorem using only the listed refinement-unstable data can separate all admissible source blowup trees from the target data.",
        },
        "upstream_corrections": [
            "Translation on E is not translation on Pic0 under pullback; it is the identity.",
            "With a reflection-fixed origin the three reflections are x->-x, x->q-x, x->2q-x; their constants are not the three nonzero 2-torsion points.",
            "The marked orbit counts alone do not prove marked set E[2]+<q>.",
        ],
    }
    payload["self_sha256"] = body_hash(payload)
    (HERE / "payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("J_FIXED_CENTRE_PRYM_PRODUCE_OK")


if __name__ == "__main__":
    main()
