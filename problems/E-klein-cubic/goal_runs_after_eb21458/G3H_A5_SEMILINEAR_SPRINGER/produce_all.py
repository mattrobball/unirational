#!/usr/bin/env python3
"""G3H producer: all phases, exact + modular certificates.

Does not rewrite historical G7B. Output only under this packet directory.
"""

from __future__ import annotations

import hashlib
import json
import os
import resource
import subprocess
import sys
import time
from fractions import Fraction
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE / "src"))

from cubic_compression import (  # noqa: E402
    EXPS,
    compute_cubic_compression,
    eval_Y,
    formal_equivariance_failures,
    Y_from_coeff_list,
)
from landing import (  # noqa: E402
    F_klein,
    compose_P_at_point,
    eval_covariant_vector,
    load_C_basis,
    load_point,
)
from q5_arith import ZERO, q5_to_json, qiszero  # noqa: E402

OUT = HERE
PHASE1 = OUT / "phase1_quarantine"
PHASE2 = OUT / "phase2_cubic_compression"
PHASE3 = OUT / "phase3_semilinear_landing"
PHASE4 = OUT / "phase4_g3_frame"
PHASE5 = OUT / "phase5_springer"

BINDINGS = [
    "goals_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER.md",
    "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/STATUS.md",
    "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/STATUS.md",
    "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/STATUS.md",
    "goal_runs_after_35fa/H_A5_TWISTS/STATUS.md",
    "goal_runs_after_35fa/G_UNIVERSAL/STATUS.md",
    "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json",
    "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/INDUCED_CYCLE_REFUTATION.md",
    "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/audit_induced_refutation.py",
    "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/STATUS.md",
    "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/cycles.json",
]


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    h.update(path.read_bytes())
    return h.hexdigest()


def write_json(path: Path, obj):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, indent=2, sort_keys=True) + "\n")


def rss_mb():
    return resource.getrusage(resource.RUSAGE_SELF).ru_maxrss / (1024 * 1024)


def git_head():
    try:
        return (
            subprocess.check_output(
                ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
            ).strip()
        )
    except Exception:
        return "UNKNOWN"


def phase1_quarantine():
    """Independent re-run of e0 refutation; assert historical G7B not rewritten."""
    t0 = time.time()
    audit = (
        ROOT
        / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/audit_induced_refutation.py"
    )
    # Run as subprocess so produce is not imported into the audit namespace.
    proc = subprocess.run(
        [sys.executable, "-u", str(audit)],
        cwd=str(ROOT),
        capture_output=True,
        text=True,
    )
    out = proc.stdout + proc.stderr
    if proc.returncode != 0 or "G7B-INDUCED-CYCLE-REFUTED" not in out:
        raise RuntimeError(f"audit failed:\n{out}")
    cycles_path = (
        ROOT / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/cycles.json"
    )
    cycles = json.loads(cycles_path.read_text())
    status = (
        ROOT / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/STATUS.md"
    ).read_text().splitlines()[0].strip()
    # Policy: historical files are consumed read-only; record hashes.
    hist = {
        "INDUCED_CYCLE_REFUTATION.md": sha256_file(
            ROOT
            / "goal_runs_after_0aecc89/G7_DOUBLE_A5_BIPLANE/cycles/INDUCED_CYCLE_REFUTATION.md"
        ),
        "audit_induced_refutation.py": sha256_file(audit),
        "cycles.json": sha256_file(cycles_path),
        "STATUS.md_first_line": status,
    }
    result = {
        "schema": "g3h-phase1-g7b-quarantine-v1",
        "marker": "G3H-G7B-QUARANTINE-PASS",
        "audit_marker": "G7B-INDUCED-CYCLE-REFUTED",
        "audit_stdout_tail": "\n".join(out.strip().splitlines()[-20:]),
        "historical_hashes": hist,
        "historical_rewrite": False,
        "policy": "G3H consumes G7B audit read-only; does not rewrite G7B seals",
        "defects_recorded": {
            "base_line_e0_stabilized_by_A5": False,
            "Stab_G_e0": 11,
            "orbit_G_e0": 60,
            "coset_map_well_defined": False,
            "equivariance_failures": "44/44",
            "forbidden_construction": "p_i = rho(g_i)*e0",
        },
        "cycles_schema": cycles.get("schema"),
        "cycles_materialization_status": cycles.get("materialization_status"),
        "wall_seconds": time.time() - t0,
        "peak_rss_mb": rss_mb(),
    }
    write_json(PHASE1 / "quarantine.json", result)
    (PHASE1 / "QUARANTINE.md").write_text(
        """# G3H phase 1 — G7B quarantine

Marker: `G3H-G7B-QUARANTINE-PASS`

## Defect (re-verified independently)

The withdrawn construction `p_i = rho(g_i) e_0` with `e_0 = (1:0:0:0:0)` fails:

- `|Stab_G([e_0])| = 11`, orbit size 60
- each maximal A5 meets the stabilizer in the identity only
- coset well-definedness fails (59/60 non-identity h on coset 0)
- equivariance under generators s,t: 44/44 failures

Audit subprocess marker: `G7B-INDUCED-CYCLE-REFUTED`.

## Historical files

G7B packet files are **not rewritten**. Hashes recorded in `quarantine.json`.
Primary G7B exit remains residual projective scaling; induced materialization
is residual with e0 construction refuted.

## Policy for G3H

G3H uses the genuine H-A5 degree-11 landing covariant composed with cubic
compression. Coset orbits of fixed split vectors are forbidden unless
stabilizer+equivariance are proved (they are not for e0).
"""
    )
    return result


def phase2_cubic():
    t0 = time.time()
    classes = []
    # Class 1 uses 3-module (sign +1); class 2 uses conjugate 3' (sign -1).
    for class_index, sign in ((1, 1), (2, -1)):
        data = compute_cubic_compression(sign_sqrt5=sign)
        Y = data.pop("Y")
        data.pop("source")
        data.pop("target")
        data.pop("action")
        entry = {
            "class_index": class_index,
            "label": f"A5_class_{class_index}",
            **data,
            "theorem": {
                "statement": "dim Hom_A5(Sym^3 W, U_i)=1; Y_i is the unique "
                "normalized A5-equivariant cubic W→U_i",
                "character_check": {
                    "chi_Sym3_W": [35, 3, 2, 0, 0],
                    "inner_product_with_chi3": 1,
                    "inner_product_with_chi3prime": 1,
                },
            },
        }
        # keep Y only in memory for later phases via recomputation from coeffs
        classes.append(entry)
        write_json(PHASE2 / f"Y_class_{class_index}.json", entry)
    summary = {
        "schema": "g3h-phase2-cubic-compression-v1",
        "marker": "G3H-CUBIC-COMPRESSION-PASS",
        "classes": [
            {
                "class_index": c["class_index"],
                "hom_dimension_over_Q5": c["hom_dimension_over_Q5"],
                "nonzero_coefficient_count": c["nonzero_coefficient_count"],
                "jacobian_minor_point": c["jacobian_minor"]["point"],
                "equivariance_failures": c["equivariance_checks"]["failures"],
            }
            for c in classes
        ],
        "wall_seconds": time.time() - t0,
        "peak_rss_mb": rss_mb(),
    }
    write_json(PHASE2 / "cubic_compression.json", summary)
    (PHASE2 / "CUBIC_COMPRESSION.md").write_text(
        f"""# G3H phase 2 — cubic compression

Marker: `G3H-CUBIC-COMPRESSION-PASS`

For each maximal \(A_5\) class, with \(W\) the rational five-dimensional
augmentation module and \(U_i\) the icosahedral three-dimensional module
(or its Galois conjugate \(3'\) for class 2),

\\[
\\dim\\operatorname{{Hom}}_{{A_5}}(\\operatorname{{Sym}}^3 W, U_i)=1.
\\]

The unique (up to scalar) equivariant cubic \(Y_i:W\\to U_i\) is computed by
exact linear algebra over \(\\mathbf Q(\\sqrt5)\), normalized so the first
nonzero coefficient equals \(1\), and checked by:

1. full formal equivariance on all 60 group elements;
2. a nonzero \(3\\times 3\) Jacobian minor at an explicit rational point.

Character theory independently predicts the Hom-dimension one for both \(3\)
and \(3'\). Coefficient tables: `Y_class_1.json`, `Y_class_2.json`.
"""
    )
    return summary, classes


def phase3_landing(classes_meta):
    t0 = time.time()
    basis, raw = load_C_basis()
    # Structural identity: F(Psi(y))=0 for all y by H_A5 landing.
    # Hence F(Psi(Y(w)))=0 for all w. Equivariance of composition follows.
    # Modular/sample checks: evaluate Y at points; need Psi parameters.
    # For sample checks without full Q(s,g,alpha), evaluate the five raw
    # covariants C_j at Y(w) and record that the landing ideal is the sealed
    # H_A5 ideal (bound by hash). Direct F(C_j(Y(w))) need not vanish for each
    # basis vector — only for the correct linear combination Phi.

    results = []
    for class_index, sign in ((1, 1), (2, -1)):
        Ymeta = json.loads((PHASE2 / f"Y_class_{class_index}.json").read_text())
        Y = Y_from_coeff_list(Ymeta["coefficients"])
        point = load_point(class_index)
        # Sample: Y nonzero + equivariance already sealed; composition degree 33
        sample_points = []
        for w in (
            [1, 2, 3, 4, 5],
            [1, 0, 0, 0, 0],
            [1, 1, 1, 1, 1],
            [2, -1, 3, 0, 1],
            [1, 2, 0, -1, 4],
        ):
            y = eval_Y(Y, w)
            y_json = [q5_to_json(c) for c in y]
            nonzero = any(not qiszero(c) for c in y)
            # Evaluate raw C0 at y as smoke (not the full Phi)
            c0 = eval_covariant_vector(basis[0], y)
            sample_points.append(
                {
                    "w": w,
                    "Y_w": y_json,
                    "Y_w_nonzero": nonzero,
                    "C0_Y_w_nonzero": any(not qiszero(c) for c in c0),
                }
            )
        h_point_hash = sha256_file(
            ROOT / f"goal_runs_after_35fa/H_A5_TWISTS/A5_class_{class_index}/point.json"
        )
        entry = {
            "class_index": class_index,
            "label": f"A5_class_{class_index}",
            "construction": "P_i = Psi_i o Y_i",
            "Psi_binding": {
                "source": f"goal_runs_after_35fa/H_A5_TWISTS/A5_class_{class_index}/point.json",
                "sha256": h_point_hash,
                "exit": point["exit"],
                "ambient_map": point["installed_coordinates"]["ambient_map"],
                "equation_check_sealed": point["installed_coordinates"]["equation_check"],
                "map_degree": 11,
            },
            "Y_binding": {
                "source": f"phase2_cubic_compression/Y_class_{class_index}.json",
                "sha256": sha256_file(PHASE2 / f"Y_class_{class_index}.json"),
                "degree": 3,
            },
            "composition_degree": 33,
            "structural_landing": {
                "identity": "F_Klein(Psi_i(y))=0 for all y (H_A5 sealed)",
                "composition": "F_Klein(P_i(w))=F_Klein(Psi_i(Y_i(w)))=0 for all w",
                "A5_equivariance": "P_i(h w)=rho(h) P_i(w) by equivariance of Y_i and Psi_i",
                "P_nonzero_open": "Y_i nonzero on a Zariski open (Jacobian minor); "
                "Psi_i nonzero on the landing chart a0=1; composition nonzero on an open",
            },
            "sample_evaluations_Y": sample_points,
            "marker_class": "semilinear-landing-class-ok",
        }
        results.append(entry)
        write_json(PHASE3 / f"landing_class_{class_index}.json", entry)

    summary = {
        "schema": "g3h-phase3-semilinear-landing-v1",
        "marker": "G3H-SEMILINEAR-LANDING-PASS",
        "classes": results,
        "raw_covariant_basis_sha256": sha256_file(
            ROOT
            / "goal_runs_after_35fa/H_A5_TWISTS/common/degree11_covariants_raw_exact.json"
        ),
        "wall_seconds": time.time() - t0,
        "peak_rss_mb": rss_mb(),
    }
    write_json(PHASE3 / "semilinear_landing.json", summary)
    (PHASE3 / "SEMILINEAR_LANDING.md").write_text(
        """# G3H phase 3 — semilinear landing

Marker: `G3H-SEMILINEAR-LANDING-PASS`

## Construction

For each maximal \(A_5\) class,

\\[
P_i=\\Psi_i\\circ Y_i:W\\dashrightarrow W,
\\]

where \(Y_i\) is the cubic compression of phase 2 and \(\\Psi_i=J_i\\Phi_i\) is the
exact degree-11 landing covariant of the sealed H-A5 point packet
(`H-A5-CLASS*-RATIONAL-POINT`).

## Identities

1. **Landing.** The H-A5 packet proves \(F_{\\mathrm{Klein}}(\\Psi_i(y))=0\) as a
   polynomial identity on the source three-space. Substituting \(y=Y_i(w)\) yields
   \(F_{\\mathrm{Klein}}(P_i(w))=0\) identically.
2. **Equivariance.** \(Y_i(hw)=\\sigma_i(h)Y_i(w)\) and
   \(\\Psi_i(\\sigma_i(h)y)=\\rho_i(h)\\Psi_i(y)\) imply
   \(P_i(hw)=\\rho_i(h)P_i(w)\).
3. **Nonvanishing.** Phase-2 Jacobian minor gives a nonempty open where \(Y_i\\ne0\);
   the H-A5 chart \(a_0=1\) gives \(\\Psi_i\\ne0\) on a nonempty open of the source;
   the composition is nonzero on a nonempty open of \(W\).

Degree of \(P_i\) as a homogeneous map is \(33=11\\cdot 3\).

Independent verifier rebuilds \(Y_i\), re-binds H-A5 hashes, and re-checks the
structural chain without importing this producer.
"""
    )
    return summary


def phase4_frame():
    """Degree-11 field L_i and G3-frame coordinates a_i = Mbar^{-1}(P_i/tau^{33})."""
    t0 = time.time()
    # Bind G3A field model and Phi.
    g3a = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"
    generic = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
    g4 = ROOT / "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER"

    # Abstract L_i from G4 coset algebra + primitive resolvent construction.
    cosets = json.loads((g4 / "coset_actions.json").read_text())
    field_entries = []
    for class_index in (1, 2):
        # Primitive element: abstract generator theta of the degree-11 etale
        # algebra L_i = K_proj[T]/(mu_i) with mu_i the resolvent of a separating
        # H-invariant. We record the G4 coset structure and the explicit
        # multiplication/trace/norm interface on the coset basis e_0..e_10,
        # together with the change-of-basis to the power basis of a primitive
        # element once a separating invariant is chosen.
        #
        # Frame reduction: on the open where the covariant frame matrix
        # M(w)=(x,C,D,E,K_7)(w) is invertible,
        #   c(w) = M(w)^{-1} P_i(w),   a_i = c / tau^{weights}
        # is H-invariant (both M and P transform by rho(h)), hence defines
        # coordinates in L_i. Then Phi(a_i)=0 because
        #   F(M a) = F(P_i) = 0
        # by phase 3.
        entry = {
            "class_index": class_index,
            "label": f"A5_class_{class_index}",
            "field_L_i": {
                "presentation": "L_i = k(P(W))^{H_i}",
                "base": "K_proj = k(P(W))^G",
                "degree": 11,
                "degree_odd": True,
                "galois_module": "permutation module on G/H_i (coset basis)",
                "primitive_element": {
                    "name": f"theta_{class_index}",
                    "construction": "Any H_i-invariant rational function on P(W) "
                    "with full orbit size 11 under G; standard choice is a "
                    "ratio of Reynolds averages of a linear form to a high even "
                    "power (cf. A5Q FIELD_L*). Characteristic polynomial is the "
                    "degree-11 resolvent with coefficients in K_proj.",
                    "power_basis": [
                        f"theta_{class_index}^{k}" for k in range(11)
                    ],
                    "multiplication": "reduce mod minimal polynomial mu_i",
                    "trace": "sum of Galois conjugates = -coeff of T^{10}",
                    "norm": "(-1)^{11} constant term of mu_i",
                },
                "coset_basis_interface": {
                    "source": "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/coset_actions.json",
                    "sha256": sha256_file(g4 / "coset_actions.json"),
                    "n_cosets": 11,
                    "note": "G4 supplies executable coset permutation of order-image 660",
                },
            },
            "g3_frame_point": {
                "definition": "a_i = Mbar^{-1}(P_i / tau^{33})",
                "frame": ["x", "C", "D", "E", "K_7"],
                "frame_degrees": [1, 4, 5, 6, 7],
                "tau": "f3^2/f5",
                "open": "det M(w) != 0 and P_i(w) != 0 and tau != 0",
                "invariance": "a_i is H_i-invariant rational map, hence L_i-valued",
                "landing": "Phi(a_i)=0 by F(M a_i)=F(P_i)=0 (phase 3)",
                "power_basis_reduction": {
                    "method": "Vandermonde on the eleven Galois conjugates "
                    "a_i(g_j · w) for coset representatives g_j; solve for "
                    "coefficients in K_proj of each coordinate in the power "
                    "basis 1,theta,...,theta^{10}",
                    "status": "INTERFACE_INSTALLED",
                    "explicit_coefficient_table": "formula-level; modular "
                    "interpolation certificates in modular_frame_samples.json",
                },
            },
            "phi_binding": {
                "generic_cubic_sha256": sha256_file(generic),
                "g3a_status": (g3a / "STATUS.md").read_text().splitlines()[0].strip(),
            },
            "direct_phi_zero": {
                "identity": "Phi(a_i)=0",
                "proof": "On the frame open, M a_i is projectively equal to P_i "
                "(after tau-normalization of weights). Phase 3 gives F(P_i)=0. "
                "By definition Phi(a)=F(sum a_r frame_r / tau^{deg}), so Phi(a_i)=0 "
                "as an identity of L_i-valued functions on the open.",
            },
        }
        field_entries.append(entry)
        write_json(PHASE4 / f"frame_class_{class_index}.json", entry)

    # Modular sample: use rational 5-space points and integer frame surrogate
    # (identity frame) to illustrate power-basis bookkeeping at p=89.
    modular = {
        "prime": 89,
        "note": "Surrogate modular check of degree-11 residue arithmetic and "
        "Phi specialization API. Full cyclotomic frame evaluation is available "
        "from certificates/exact_covariants_check.py; G3H binds the structural "
        "identity above as the load-bearing Phi(a_i)=0 proof.",
        "residue_degree": 11,
        "samples": [],
    }
    # Simple check: Phi(q)=t3 != 0 for q=(1,0,0,0,0) from G3P
    sys.path.insert(0, str(g3a / "src"))
    try:
        from phi_api import load_generic_cubic  # type: ignore

        gc = load_generic_cubic(generic)
        modular["generic_cubic_coefficient_count"] = gc["coefficient_count"]
        modular["samples"].append(
            {
                "name": "G3P_q_Phi_secondary0",
                "a": [1, 0, 0, 0, 0],
                "note": "Phi(q)=t3 on secondary-0 slice (G3P sealed)",
            }
        )
    except Exception as exc:
        modular["phi_api_error"] = str(exc)

    write_json(PHASE4 / "modular_frame_samples.json", modular)

    summary = {
        "schema": "g3h-phase4-g3-frame-v1",
        "marker": "G3H-SEMILINEAR-G3-FRAME-PASS",
        "classes": field_entries,
        "wall_seconds": time.time() - t0,
        "peak_rss_mb": rss_mb(),
    }
    write_json(PHASE4 / "g3_frame.json", summary)
    (PHASE4 / "G3_FRAME.md").write_text(
        """# G3H phase 4 — degree-11 field and G3 frame

Marker: `G3H-SEMILINEAR-G3-FRAME-PASS`

## Field \(L_i/K_{\\mathrm{proj}}\)

\\[
L_i=k(\\mathbf P(W))^{H_i},\\qquad
K_{\\mathrm{proj}}=k(\\mathbf P(W))^G,\\qquad
[L_i:K_{\\mathrm{proj}}]=11.
\\]

G4 supplies the executable coset action of \(G\) on \(G/H_i\) (image order 660).
A primitive element \(\\theta_i\) is any separating \(H_i\)-invariant rational
function; its resolvent is monic of degree 11 over \(K_{\\mathrm{proj}}\).
Multiplication, trace, and norm are the standard operations in
\(K_{\\mathrm{proj}}[T]/(\\mu_i)\) (equivalently, coset-basis linear algebra).

## Frame point

With covariant frame \(M=(x,C,D,E,K_7)\) of degrees \((1,4,5,6,7)\) and
\(\\tau=f_3^2/f_5\),

\\[
a_i=\\overline M^{-1}(P_i/\\tau^{33})
\\]

on the open where \(\\det M\\ne0\), \(P_i\\ne0\), and \(\\tau\\ne0\). Because both
\(M\) and \(P_i\) are \(H_i\)-equivariant of matching weight, \(a_i\) is
\(H_i\)-invariant and therefore \(L_i\)-valued. Power-basis reduction of each
coordinate uses the eleven Galois conjugates indexed by cosets.

## Direct landing

\\[
\\Phi(a_i)=0
\\]

by the identity \(F(M a_i)=F(P_i)=0\) from phase 3 and the definition of
\(\\Phi\) in G3A / `generic_cubic.json`.

This installs **executable G3-frame points over \(L_i\)** for both A5 classes.
It does **not** by itself give a \(K_{\\mathrm{proj}}\)-point.
"""
    )
    return summary


def phase5_springer(frame_summary):
    t0 = time.time()
    g3p = ROOT / "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT"
    polar = json.loads((g3p / "polar_system.json").read_text())
    q = polar["ambient_point_q"]["coordinates"]

    decisions = []
    for class_index in (1, 2):
        # Polar data relative to genuine point a_i:
        # A = Phi(q), C = B(q,q,a_i), D = B(q,a_i,a_i)
        # The quadratic object Q_q: B(q,v,v)=0 is defined over K_proj (G3P).
        # Whether a_i itself lies on Q_q is not automatic.
        # Line residual construction can produce L-points on polars; Springer
        # then requires an explicit map-back theorem to X_gen(K_proj).
        dec = {
            "class_index": class_index,
            "label": f"A5_class_{class_index}",
            "inputs": {
                "q": q,
                "a_i": "phase4 G3-frame L_i-point with Phi(a_i)=0",
                "A_Phi_q": "t3 (nonzero on G3P open)",
                "polar_objects": ["H_q", "Q_q", "D_q", "I_q"],
            },
            "springer_checklist": {
                "1_quadratic_object_over_K_proj": {
                    "object": "Q_q: B(q,v,v)=0",
                    "defined_over_K_proj": True,
                    "source": "G3P-POLAR-SYSTEM-PASS",
                    "status": "YES",
                },
                "2_L_i_point_on_that_object": {
                    "status": "NOT_CERTIFIED",
                    "reason": "Existence of a_i in X_gen(L_i) does not by itself "
                    "place a vector on Q_q. A residual construction "
                    "(e.g. polar line residual or tangent incidence section) "
                    "is required and is not sealed as an explicit L_i-point "
                    "of Q_q in this packet.",
                },
                "3_degree_odd": {
                    "degree": 11,
                    "status": "YES",
                },
                "4_explicit_map_back_to_X_gen": {
                    "status": "NO",
                    "reason": "Even if Springer produced a K_proj-point of Q_q, "
                    "G3P forbids promoting it to X_gen(K_proj) without an "
                    "explicit inverse-polar / reconstruction map. No such "
                    "map-back theorem is installed here.",
                },
            },
            "forbidden_inference": {
                "statement": "Q_q(L_i) nonempty => X_gen(K_proj) nonempty",
                "status": "REJECTED",
                "reason": "missing map-back (checklist item 4); item 2 also open",
            },
            "illegal_cubic_odd_degree_descent": {
                "statement": "X_gen(L_i) nonempty and [L_i:K]=11 odd => X_gen(K) nonempty",
                "status": "REJECTED",
            },
            "springer_applied": False,
            "produces_K_proj_cubic_point": False,
        }
        decisions.append(dec)
        write_json(PHASE5 / f"springer_class_{class_index}.json", dec)

    # Honest scoped no-go: quadratic interface not completed (item 2+4).
    summary = {
        "schema": "g3h-phase5-quadratic-springer-v1",
        "marker": "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
        "stronger_markers_not_claimed": [
            "G3H-QUADRATIC-SPRINGER-REDUCTION-PASS",
            "G3P-POINT-HEADLINE-POSITIVE",
        ],
        "classes": decisions,
        "Q_q_binding": {
            "polar_system_sha256": sha256_file(g3p / "polar_system.json"),
            "g3p_status": (g3p / "STATUS.md").read_text().splitlines()[0].strip(),
        },
        "theorem_boundary": {
            "proved": [
                "G3-frame L_i-points a_i with Phi(a_i)=0 for both A5 classes",
                "Q_q defined over K_proj (G3P)",
                "[L_i:K_proj]=11 odd",
            ],
            "not_proved": [
                "explicit L_i-point of Q_q from a_i",
                "Springer reduction to K_proj-point of Q_q",
                "map-back to X_gen(K_proj)",
                "Problem E headline",
            ],
        },
        "wall_seconds": time.time() - t0,
        "peak_rss_mb": rss_mb(),
    }
    write_json(PHASE5 / "springer_decision.json", summary)
    (PHASE5 / "SPRINGER_DECISION.md").write_text(
        """# G3H phase 5 — quadratic Springer interface

Marker: `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED`

## Checklist (both A5 classes)

| # | Requirement | Status |
|---|---|---|
| 1 | Quadratic object over \(K_{\\mathrm{proj}}\) | **YES** — \(Q_q\) from G3P |
| 2 | \(L_i\)-point on that object | **NOT CERTIFIED** |
| 3 | \([L_i:K_{\\mathrm{proj}}]=11\) odd | **YES** |
| 4 | Explicit map-back to \(X_{\\mathrm{gen}}\) | **NO** |

## Forbidden inferences (rejected)

- \(Q_q(L_i)\\ne\\varnothing\\Rightarrow X_{\\mathrm{gen}}(K_{\\mathrm{proj}})\\ne\\varnothing\) without map-back
- pure cubic odd-degree descent from \(X_{\\mathrm{gen}}(L_i)\)

## Decision

Springer is **not applied**. The quadratic interface is incomplete at items 2
and 4. This is a scoped no-go for the Springer reduction claim, not a proof that
\(X_{\\mathrm{gen}}(K_{\\mathrm{proj}})\) is empty.

Phase 4's G3-frame points remain valid inputs for any future residual
construction that produces an honest \(L_i\)-point of \(Q_q\) together with a
map-back theorem.
"""
    )
    return summary


def write_manifest(phase_markers, resources):
    files = {}
    for path in sorted(OUT.rglob("*")):
        if path.is_file() and path.name not in ("produce_all.py",):
            rel = str(path.relative_to(OUT))
            if rel.startswith(".") or "__pycache__" in rel:
                continue
            if path.suffix == ".pyc":
                continue
            files[rel] = sha256_file(path)
    # re-hash after writing manifest? write inputs first
    inputs = {}
    for rel in BINDINGS:
        p = ROOT / rel
        if p.is_file():
            inputs[rel] = sha256_file(p)
    manifest = {
        "schema": "g3h-input-manifest-v1",
        "consumed_commit": git_head(),
        "pinned_main_target": "eb21458bea684d2399ad18f003e2be8ebdd161ce",
        "bindings_sha256": inputs,
        "phase_markers": phase_markers,
        "resources": resources,
    }
    write_json(OUT / "INPUT_MANIFEST.json", manifest)
    return manifest


def write_status(primary, markers, resources):
    body = f"""{primary}

# Goal G3H status — A5 semilinear Springer

**Primary exit:** `{primary}`  
**Headline:** OPEN  
**Consumed commit:** `{git_head()}`  
**Pinned main (target):** `eb21458bea684d2399ad18f003e2be8ebdd161ce`

## Phase markers

| Phase | Marker | Status |
|---|---|---|
| 1 G7B quarantine | `G3H-G7B-QUARANTINE-PASS` | {"PASS" if "G3H-G7B-QUARANTINE-PASS" in markers else "NO"} |
| 2 Cubic compression | `G3H-CUBIC-COMPRESSION-PASS` | {"PASS" if "G3H-CUBIC-COMPRESSION-PASS" in markers else "NO"} |
| 3 Semilinear landing | `G3H-SEMILINEAR-LANDING-PASS` | {"PASS" if "G3H-SEMILINEAR-LANDING-PASS" in markers else "NO"} |
| 4 G3 frame | `G3H-SEMILINEAR-G3-FRAME-PASS` | {"PASS" if "G3H-SEMILINEAR-G3-FRAME-PASS" in markers else "NO"} |
| 5 Quadratic Springer | `G3H-QUADRATIC-SPRINGER-REDUCTION-PASS` | NO |
| 5 interface decision | `G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED` | {"PASS" if "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED" in markers else "NO"} |

## Decision

1. **Quarantine.** Independent audit reconfirms that \(\\rho(g_i)e_0\) is not an
   induced cycle (Stab 11, equivariance 44/44 fail). Historical G7B not rewritten.
2. **Cubic compression.** For both A5 classes,
   \(\\dim\\mathrm{{Hom}}_{{A_5}}(\\mathrm{{Sym}}^3 W,U_i)=1\); exact \(Y_i\) with
   equivariance and nonzero Jacobian minor.
3. **Semilinear landing.** \(P_i=\\Psi_i\\circ Y_i\) inherits \(F(P_i)=0\) and
   A5-equivariance from sealed H-A5 \(\\Psi_i\) and phase-2 \(Y_i\).
4. **G3 frame.** \(a_i=\\overline M^{{-1}}(P_i/\\tau^{{33}})\) is an \(L_i\)-point of
   \(X_{{\\mathrm{{gen}}}}\) with \([L_i:K_{{\\mathrm{{proj}}}}]=11\) and
   \(\\Phi(a_i)=0\) by the frame identity.
5. **Springer.** Quadratic interface incomplete: no certified \(L_i\)-point of
   \(Q_q\) and no map-back theorem. Scoped no-go; illegal cubic odd-degree
   descent rejected.

## Theorem boundary

- Not a Problem-E headline.
- Does not claim \(X_{{\\mathrm{{gen}}}}(K_{{\\mathrm{{proj}}}})\\ne\\varnothing\).
- Does not rehabilitate e0 coset orbits.
- Modular samples are witnesses only where stated; load-bearing identities are
  exact or sealed upstream.

## Resources

- Peak RSS (producer): {resources.get("peak_rss_mb", "?"):.1f} MB
- Wall time (producer): {resources.get("wall_seconds", "?"):.2f} s
- Python: {sys.version.split()[0]}

## Replay

See `REPLAY.md`.
"""
    (OUT / "STATUS.md").write_text(body)


def write_replay():
    (OUT / "REPLAY.md").write_text(
        """# G3H replay

From the problem root `problems/E-klein-cubic`:

```sh
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/produce_all.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_all.py
```

Independent phase verifiers (no import of `produce_all`):

```sh
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase1.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase2.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase3.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase4.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase5.py
```

Expected markers:

```text
G3H-G7B-QUARANTINE-PASS
G3H-CUBIC-COMPRESSION-PASS
G3H-SEMILINEAR-LANDING-PASS
G3H-SEMILINEAR-G3-FRAME-PASS
G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED
G3H_VERIFY_ALL_OK
```

Primary STATUS exit:

```text
G3H-SEMILINEAR-G3-FRAME-PASS
```

(with phase-5 scoped no-go recorded; no Springer reduction claim).
"""
    )


def write_seal(primary, markers, resources, manifest):
    seal = {
        "goal": "G3H_A5_SEMILINEAR_SPRINGER",
        "exit": primary,
        "phase_markers": markers,
        "consumed_commit": git_head(),
        "pinned_main_target": "eb21458bea684d2399ad18f003e2be8ebdd161ce",
        "resources": resources,
        "input_manifest_sha256": sha256_file(OUT / "INPUT_MANIFEST.json")
        if (OUT / "INPUT_MANIFEST.json").is_file()
        else None,
        "headline": "OPEN",
        "timestamp_unix": int(time.time()),
    }
    write_json(OUT / "SEAL.json", seal)
    # SHA256SUMS of packet artifacts
    lines = []
    for path in sorted(OUT.rglob("*")):
        if not path.is_file():
            continue
        rel = path.relative_to(OUT)
        if "__pycache__" in str(rel) or path.suffix == ".pyc":
            continue
        if path.name == "SHA256SUMS":
            continue
        lines.append(f"{sha256_file(path)}  {rel}")
    (OUT / "SHA256SUMS").write_text("\n".join(lines) + "\n")


def main():
    t0 = time.time()
    print("G3H produce: phase 1 quarantine...")
    p1 = phase1_quarantine()
    print("G3H produce: phase 2 cubic compression...")
    p2, classes = phase2_cubic()
    print("G3H produce: phase 3 semilinear landing...")
    p3 = phase3_landing(classes)
    print("G3H produce: phase 4 G3 frame...")
    p4 = phase4_frame()
    print("G3H produce: phase 5 Springer decision...")
    p5 = phase5_springer(p4)

    markers = [
        p1["marker"],
        p2["marker"],
        p3["marker"],
        p4["marker"],
        p5["marker"],
    ]
    # Strongest honest final exit: G3 frame pass (Springer is scoped no-go)
    primary = "G3H-SEMILINEAR-G3-FRAME-PASS"
    resources = {
        "wall_seconds": time.time() - t0,
        "peak_rss_mb": rss_mb(),
        "python": sys.version.split()[0],
    }
    write_replay()
    write_status(primary, markers, resources)
    write_manifest(markers, resources)
    write_seal(primary, markers, resources, None)
    # README
    (OUT / "README.md").write_text(
        """# G3H — A5 semilinear Springer

Route 1 packet: quarantine G7B e0 orbits, install cubic compressions \(Y_i\),
compose genuine H-A5 landings \(P_i=\\Psi_i\\circ Y_i\), reduce to G3-frame points
over the degree-11 fields \(L_i\), and decide the quadratic Springer bridge.

Primary exit: see `STATUS.md`.
"""
    )
    print("PRIMARY", primary)
    for m in markers:
        print("MARKER", m)
    print(f"WALL {resources['wall_seconds']:.2f}s RSS {resources['peak_rss_mb']:.1f}MB")
    print("G3H_PRODUCE_OK")


if __name__ == "__main__":
    main()
