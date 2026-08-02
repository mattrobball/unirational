#!/usr/bin/env python3
"""Build the exact generic q0=1 Morita split-circuit packet.

The roots are exact invariant rational-function circuits in the ambient
embedding of K_proj.  This builder does not lower them to the optional named
12-vector normal form and does not assert a common right-D-line.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
A7 = REPO / "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
CROOT = REPO / "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT"
FANO = REPO / "goals_2026-08-01/C_PFAFFIAN_FANO"
OUTPUT = HERE / "morita_generic_split_dag.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    nodes: dict[str, dict] = {}

    def node(name: str, op: str, *args: str, **metadata) -> str:
        assert name not in nodes
        nodes[name] = {"op": op, "args": list(args), **metadata}
        return name

    node("P", "source", source="degree12_bivector_matrix_P")
    node("Q", "source", source="aligned_pfaffian_matrix_Q(x)")
    node("a", "source", source="compressed_algebra_generator_a")
    node("b", "source", source="compressed_algebra_generator_b")
    for index, name in enumerate(("x", "C", "D", "E", "K")):
        node(f"B{index}", "source", source=f"Q(V_{name}(x))")
    node("s", "pairing", "P", "Q", convention="sum_{i<j}Q_ij*P_ij")
    node("PQ", "matmul", "P", "Q")
    node("e", "scale_by_inverse", "PQ", "s", scalar=-1)

    # Cramer-free corner basis on the open certified by the p=23 witness.
    node("d0", "alias", "e")
    node("ea", "matmul", "e", "a")
    node("eb", "matmul", "e", "b")
    node("eab", "matmul", "ea", "b")
    node("d1", "matmul", "ea", "e")
    node("d2", "matmul", "eb", "e")
    node("d3", "matmul", "eab", "e")
    node("W0", "alias", "e")
    node("ae", "matmul", "a", "e")
    node("be", "matmul", "b", "e")
    for alpha in range(4):
        node(f"W{alpha + 1}", "matmul", "ae", f"d{alpha}")
        node(f"W{alpha + 5}", "matmul", "be", f"d{alpha}")

    # Exact split chart over Q(zeta11,t)(x), not a K_proj splitting claim.
    node("J", "select_columns", "e", columns=[0, 1])
    node("Jminor", "select_rows", "J", rows=[0, 1])
    node("Jminor_inv", "inverse", "Jminor")
    node(
        "T_corner_to_entries",
        "corner_action_representation",
        "Jminor_inv",
        "J",
        "d0",
        "d1",
        "d2",
        "d3",
        pivot_rows=[0, 1],
        vectorization="row-major (00,01,10,11)",
    )
    node("T_entries_to_corner", "inverse", "T_corner_to_entries")

    monomials = []
    pair_index = {}
    for left in range(9):
        for right in range(left, 9):
            index = len(monomials)
            pair_index[(left, right)] = index
            exponents = [0] * 8
            if left:
                exponents[left - 1] += 1
            if right:
                exponents[right - 1] += 1
            monomials.append(
                {
                    "left_W": left,
                    "right_W": right,
                    "exponents_z0_to_z7": exponents,
                }
            )
    assert len(monomials) == 45

    names = ("x", "C", "D", "E", "K")
    forms = []
    for form_index, form_name in enumerate(names):
        roots = []
        for index, monomial in enumerate(monomials):
            left, right = monomial["left_W"], monomial["right_W"]
            root = f"c{form_index}_{index}"
            node(
                root,
                "trace_bilinear_coefficient",
                "P",
                f"W{left}",
                f"B{form_index}",
                f"W{right}",
                symmetrize=left != right,
            )
            roots.append(root)
        forms.append(
            {
                "name": form_name,
                "coefficient_roots": roots,
                "numerator_equation": f"G_{form_name}=sum_m c_{form_index},m*z^m=0",
                "normalized_relation": f"lambda_{form_name}=-G_{form_name}/(2*s)",
            }
        )

    # Apply z=diag(T^-1,T^-1)y lazily to each quadratic coefficient table.
    split_roots: list[dict[tuple[int, int], str]] = []
    for form_index in range(5):
        table = {}
        originals = forms[form_index]["coefficient_roots"]
        for left in range(9):
            for right in range(left, 9):
                root = f"sc{form_index}_{pair_index[(left, right)]}"
                node(
                    root,
                    "quadratic_block_change_coefficient",
                    "T_entries_to_corner",
                    *originals,
                    target_left=left,
                    target_right=right,
                    global_pair_order="monomial_order",
                )
                table[(left, right)] = root
        split_roots.append(table)

    u_positions = (0, 2, 4, 6)
    v_positions = (1, 3, 5, 7)
    block_forms = []
    for form_index, form_name in enumerate(names):
        split = split_roots[form_index]
        row = []
        for u_index, u_position in enumerate(u_positions):
            slopes = [
                split[tuple(sorted((u_position + 1, v_position + 1)))]
                for v_position in v_positions
            ]
            entry = f"A{form_index}_{u_index}"
            node(
                entry,
                "affine_polynomial",
                split[(0, u_position + 1)],
                *slopes,
                variables=["v0", "v1", "v2", "v3"],
            )
            row.append(entry)
        constant = f"cblock{form_index}"
        node(
            constant,
            "affine_polynomial",
            split[(0, 0)],
            *(split[(0, position + 1)] for position in v_positions),
            variables=["v0", "v1", "v2", "v3"],
        )
        block_forms.append({"name": form_name, "A_row": row, "c": constant})

    augmented = [
        item
        for row in block_forms
        for item in [*row["A_row"], row["c"]]
    ]
    node(
        "Delta",
        "determinant_polynomial",
        *augmented,
        shape=[5, 5],
        variables=["v0", "v1", "v2", "v3"],
        formula="det([A(v)|c(v)])",
    )
    rank_minors = []
    for omitted in range(5):
        root = f"rank4_minor_omit_{omitted}"
        node(
            root,
            "determinant_polynomial",
            *(
                block_forms[row]["A_row"][column]
                for row in range(5)
                if row != omitted
                for column in range(4)
            ),
            shape=[4, 4],
            variables=["v0", "v1", "v2", "v3"],
        )
        rank_minors.append(root)
    node(
        "Delta_at_v0",
        "determinant",
        *(
            item
            for form_index in range(5)
            for item in [
                *(
                    split_roots[form_index][(0, position + 1)]
                    for position in u_positions
                ),
                split_roots[form_index][(0, 0)],
            ]
        ),
        shape=[5, 5],
    )

    source_paths = {
        "char0_rur": A7 / "ambient_degree12_rur_char0.json",
        "global_pluecker": A7 / "ambient_degree12_global_exact.json",
        "c2_morita": A7 / "c2_morita.json",
        "c2_producer": A7 / "produce_c2_morita.py",
        "compressed_algebra": CROOT / "compressed_algebra.json",
        "compressed_algebra_producer": FANO / "produce_compressed_algebra.py",
        "distinguished_five_plane": CROOT / "distinguished_five_plane.json",
        "five_plane_producer": CROOT / "produce_distinguished_five_plane.py",
    }
    payload = {
        "format": "morita-generic-split-q0-lazy-v1",
        "scope": (
            "Exact generic q0=1 equations in the ambient invariant-field embedding; "
            "no named 12-vector lowering, common line, or C5 resolution claimed"
        ),
        "base_field": (
            "K_proj=C(x1,...,x5)^PSL_2(F_11), embedded in "
            "Q(zeta11,t)(x1,...,x5)"
        ),
        "open_conditions": [
            "s=sum_{i<j}Q_ij*P_ij != 0",
            "rank_flatten(d0,d1,d2,d3)=4",
            "rank_flatten({g_r*e*d_alpha:g=(1,a,b),alpha=0..3})=12",
            "det(Jminor)!=0 and det(T_corner_to_entries)!=0",
            "sealed source denominators are nonzero",
        ],
        "open_ledger": {
            "required_opens": [
                "2!=0",
                "Pf(Q)!=0",
                "s!=0",
                "f14!=0",
                "rank_flatten(d0,d1,d2,d3)=4",
                "rank_flatten({g_r*e*d_alpha:g=(1,a,b),alpha=0..3})=12",
                "det(Jminor)!=0",
                "det(T_corner_to_entries)!=0",
                "sealed source denominators are nonzero",
            ],
            "good_fibre_open_witnesses": {
                "prime": 23,
                "zeta11": 2,
                "source_point": [1, 2, 3, 4, 5],
                "rur_root": 1,
                "pfaffian_Q_mod_23": 17,
                "s_mod_23": 3,
                "f14_mod_23": 17,
                "corner_minor": {
                    "flattening": "row-major 6x6 matrices as columns",
                    "basis_order": ["d0", "d1", "d2", "d3"],
                    "rows": [0, 1, 6, 7],
                    "columns": [0, 1, 2, 3],
                    "determinant_mod_23": 13,
                },
                "morita_module_minor": {
                    "flattening": "row-major 6x6 matrices as columns",
                    "basis_order": "g_r*e*d_alpha, lexicographic for g=(1,a,b) and alpha=0..3",
                    "rows": [0, 1, 6, 7, 12, 13, 18, 19, 24, 25, 31, 30],
                    "columns": list(range(12)),
                    "determinant_mod_23": 22,
                },
                "Jminor": {
                    "matrix": "e[rows=(0,1),columns=(0,1)]",
                    "rows": [0, 1],
                    "columns": [0, 1],
                    "determinant_mod_23": 5,
                },
                "T_corner_to_entries": {
                    "vectorization": "row-major (00,01,10,11)",
                    "determinant_mod_23": 18,
                },
            },
        },
        "coordinates": {
            "q0": "e",
            "q1": "z0*d0+z1*d1+z2*d2+z3*d3",
            "q2": "z4*d0+z5*d1+z6*d2+z7*d3",
            "corner_basis": ["e", "e*a*e", "e*b*e", "e*a*b*e"],
            "w": "e+a*e*q1+b*e*q2=W0+sum(z_k*W_(k+1))",
        },
        "derivation": {
            "morita_value": "q^*H_iq=Q^-1*w^T*B_i*w=lambda_i*e",
            "projector_identity": "e=-P*Q/s and e*Q^-1=-P/s",
            "trace_identity": "Tr(e)=2, so lambda_i=-Tr(P*w^T*B_i*w)/(2*s)",
            "zero_equation": "G_i=Tr(P*w^T*B_i*w)=0",
        },
        "invariance": {
            "laws": [
                "P(gx)=rho(g)*P(x)*rho(g)^T",
                "B_i(gx)=rho(g)^(-T)*B_i(x)*rho(g)^(-1)",
                "Q has the same congruence law as B_i",
                "a,b,e,d_alpha,W_k transform by conjugation",
            ],
            "root_identity": (
                "P'*(W_l')^T*B_i'*W_r'=rho(g)*(P*W_l^T*B_i*W_r)*rho(g)^(-1)"
            ),
            "conclusion": (
                "All 225 trace coefficients are invariant and hence exact K_proj "
                "elements in the ambient embedding"
            ),
        },
        "monomial_order": monomials,
        "forms": forms,
        "split_block": {
            "field_scope": (
                "Exact split chart over Q(zeta11,t)(x); no splitting of D over K_proj claimed"
            ),
            "chart": "J=e[:,(0,1)], pivot rows (0,1)",
            "u": ["y0", "y2", "y4", "y6"],
            "v": ["y1", "y3", "y5", "y7"],
            "bilinear_identity": (
                "Alternation kills all u-u and v-v quadratic terms, giving A(v)u+c(v)=0"
            ),
            "block_forms": block_forms,
            "consistency_determinant": "Delta",
            "rank_leq_3_minors": rank_minors,
            "rank_strata": "rank(A)<=r is cut out by all (r+1)-minors",
            "structural_ansatz": {
                "ansatz": "v=0 in this selected ambient split chart",
                "obstruction_root": "Delta_at_v0",
                "scope": "Only this structural ansatz; not an obstruction to all common lines",
            },
        },
        "normal_form_boundary": {
            "membership": "The invariant roots already belong to K_proj.",
            "not_installed": (
                "Expansion/lowering to the preferred length-12 "
                "QQ(t3,t6,t8,t11)-basis"
            ),
            "deterministic_recipe": [
                "Clear sealed denominators and homogenize numerator and denominator.",
                "Solve degreewise against matching installed Hironaka A-basis products on an exact unisolvent orbit set.",
                "Verify each sparse polynomial identity by subtraction.",
                "Reduce secondary products with the installed 12x12 table and verify by multiplying back.",
            ],
        },
        "counts": {
            "variables": 8,
            "forms": 5,
            "coefficients_per_form": 45,
            "coefficient_roots": 225,
            "split_coefficient_roots": 225,
            "dag_nodes": len(nodes),
        },
        "source_files": {
            name: {"path": str(path), "sha256": sha256(path)}
            for name, path in source_paths.items()
        },
        "nodes": nodes,
    }
    assert len(nodes) == 517
    OUTPUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(f"WROTE {OUTPUT}")
    print("DAG_NODES=517 ORIGINAL_ROOTS=225 SPLIT_ROOTS=225")
    print("MORITA-GENERIC-SPLIT-DAG-BUILT")


if __name__ == "__main__":
    main()
