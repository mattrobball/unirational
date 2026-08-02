#!/usr/bin/env python3
"""Produce the canonical C5 input and convention-failure certificates."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

from canonical_algebra import api_descriptor


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


AUTHORITATIVE = {
    "minimal_polynomials": "goals_2026-08-01/C_PFAFFIAN_FANO/c0_minpoly_exact.json",
    "compressed_algebra": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/compressed_algebra.json",
    "involution": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/involution.json",
    "distinguished_five_plane": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/distinguished_five_plane.json",
    "refined_involution_transport": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/c1_involution.json",
    "auxiliary_projector_rur": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/ambient_degree12_rur_char0.json",
    "auxiliary_projector_global_check": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/ambient_degree12_global_exact.json",
    "auxiliary_projector_unisolvent_points": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/degree24_unisolvent_points.json",
    "morita_five_forms": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3/c2_morita.json",
    "alignment_core": "tmp/pfaffian_representation_alignment/core.py",
    "alignment_certificate": "tmp/pfaffian_representation_alignment/certificate.json",
    "kproj_core": "tmp/kproj_arithmetic/core.py",
    "kproj_table": "tmp/kproj_arithmetic/normalized_kproj_table.json",
    "hilbert90_covariants": "tmp/generic_twist/phi_coefficients.py",
    "fano_c3_source": "certificates/fano_c3/produce_c3.py",
    "symmetric_basis_certificate": "tmp/pfaffian_rank2_idempotent_attack/certificate.json",
    "symmetric_basis_builder": "tmp/pfaffian_rank2_idempotent_attack/attack_core.py",
    "full_wedge_source": "tmp/pfaffian_rank2_idempotent_attack/full_wedge.py",
    "modular_seed_fano_source": "tmp/fano14_twist/fano_covariant_scan.py",
    "modular_seed_descent_core": "tmp/pfaffian_25plus11_descent/descent_core.py",
    "modular_seed_descent_certificate": "tmp/pfaffian_25plus11_descent/certificate.json",
    "exact_covariants_replay": "certificates/exact_covariants_check.py",
}

AUDIT_ONLY = {
    "superseded_partial_compressed_algebra": "goals_2026-08-01/C_PFAFFIAN_FANO/compressed_algebra.json",
    "namespace_quarantine_audit": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/MORITA_PROJECTOR_AUDIT.md",
    "corrected_cyclotomic_builder": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/build_ambient_projector_prime.py",
    "symmetric_basis_proof_audit": "tmp/pfaffian_rank2_idempotent_attack/PROOF_AUDIT.md",
    "implementation_quarantine_audit": "goals_after_35fa8f/IMPLEMENTATION_AUDIT.md",
    "lane_a_rank2_attack_core": "tmp/pfaffian_rank2_idempotent_attack/attack_core.py",
    "lane_a_fano_covariant_scan": "tmp/fano14_twist/fano_covariant_scan.py",
    "lane_a_descent_core": "tmp/pfaffian_25plus11_descent/descent_core.py",
    "lane_a_descent_certificate": "tmp/pfaffian_25plus11_descent/certificate.json",
    "lane_a_modular_covariant_scan": "certificates/modular_covariant_scan.py",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def metadata(path: Path) -> dict:
    result = {"path": str(path.relative_to(ROOT)), "sha256": sha256(path), "bytes": path.stat().st_size}
    if path.suffix == ".json":
        payload = json.loads(path.read_text())
        if isinstance(payload, dict):
            result["format"] = payload.get("format")
    return result


def coordinate_frame_is_x(frame: dict) -> bool:
    vectors = frame["hilbert90_frame"]["vectors"]["x"]
    if len(vectors) != 5:
        return False
    for index, polynomial in enumerate(vectors):
        expected = [0] * 5
        expected[index] = 1
        if polynomial != [{"exponents": expected, "coefficient": 1}]:
            return False
    return True


def main() -> None:
    inputs = {name: metadata(ROOT / relative) for name, relative in AUTHORITATIVE.items()}
    audit = {name: metadata(ROOT / relative) for name, relative in AUDIT_ONLY.items()}

    compressed = json.loads((ROOT / AUTHORITATIVE["compressed_algebra"]).read_text())
    involution = json.loads((ROOT / AUTHORITATIVE["involution"]).read_text())
    five_plane = json.loads((ROOT / AUTHORITATIVE["distinguished_five_plane"]).read_text())
    morita = json.loads((ROOT / AUTHORITATIVE["morita_five_forms"]).read_text())
    partial = json.loads((ROOT / AUDIT_ONLY["superseded_partial_compressed_algebra"]).read_text())
    symmetric_basis = json.loads((ROOT / AUTHORITATIVE["symmetric_basis_certificate"]).read_text())

    assert compressed["format"] == "c0-compressed-algebra-lazy-v1"
    assert involution["format"] == "c1-lazy-symplectic-involution-v1"
    assert five_plane["format"] == "c2-distinguished-five-plane-lazy-v1"
    assert morita["format"] == "c2-lazy-exact-morita-v1"
    assert partial["status"] == "C0-PARTIAL"
    sym = symmetric_basis["symmetric_jordan_reduction"]["symmetric_basis"]
    assert sym["dimension"] == 15
    assert sym["frame_indices"] == [*range(14), 15]
    assert sym["minor_determinant"] == 13
    assert five_plane["hilbert90_frame"]["names"] == ["x", "C", "D", "E", "K"]
    assert coordinate_frame_is_x(five_plane)
    assert five_plane["symmetric_elements"]["semantics"] == "S_j(x)=Q(x)^-1*Q(V_j(x))"
    assert morita["distinguished_hermitian_forms"]["names"] == ["x", "C", "D", "E", "K"]
    assert morita["source_sha256"]["compressed_algebra"] == inputs["compressed_algebra"]["sha256"]
    assert morita["source_sha256"]["distinguished_five_plane"] == inputs["distinguished_five_plane"]["sha256"]

    manifest = {
        "format": "c5-canonical-input-manifest-v1",
        "pinned_state": "bd610a032bb9561d2daeb91a2cb60c48c082ca2f",
        "field": compressed["base"]["K_proj"],
        "authoritative_inputs": inputs,
        "audit_only_inputs": audit,
        "canonical_choices": {
            "compressed_algebra": "the complete lazy v1 packet supersedes the C0-PARTIAL progress file",
            "involution": "the root involution is consumed by the exact five-plane; c1_involution is a compatible refined transport audit",
            "five_plane": "the exact x,C,D,E,K packet consumed by c2_morita",
            "auxiliary_projector": "the characteristic-zero RUR whose source hashes are sealed in c2_morita",
            "symmetric_basis": "the exact 15 symmetrizations with frame indices 0,...,13,15 and a nonzero good-fibre minor",
            "unisolvent_points": "the exact point set named by the accepted global Pluecker certificate",
        },
        "quarantine": {
            "consumed_namespace_mutated_rur": False,
            "reason": "the audits record a historical namespace-copy conjugate output, but do not name or retain its blob",
            "historical_bad_blob": "absent or unnamed in the current tracked tree",
            "current_p23_zeta4_status": "corrected tracked copies are valid and differ from zeta2",
            "consumption_rule": "consume no modular RUR except an explicitly hash-bound authoritative input; only the char0 RUR is consumed here",
            "corrected_builder_hash": audit["corrected_cyclotomic_builder"]["sha256"],
        },
        "duplicate_verdict": "no semantic disagreement among the selected authoritative objects; the smaller compressed_algebra file is explicitly C0-PARTIAL",
        "mathematical_input_failure": "the selected five-plane has V_0=x and therefore S_0=Q(x)^-1 Q(x)=1, contradicting the proposed self-adjoint-projector incidence",
        "marker": "C5_CANONICAL_INPUTS_HASHED",
    }
    (HERE / "INPUT_MANIFEST.json").write_text(json.dumps(manifest, indent=2) + "\n")

    api = api_descriptor()
    (HERE / "canonical_algebra_api.json").write_text(json.dumps(api, indent=2) + "\n")
    assert api["S_x_coordinates"] == api["unit_coordinates"]

    incidence = {
        "format": "c5-projector-incidence-convention-failure-v1",
        "field": manifest["field"],
        "characteristic": 0,
        "installed_section": {
            "names": ["x", "C", "D", "E", "K"],
            "definition": "S_i=Q(x)^-1 Q(V_i(x))",
            "first_vector": "V_0=x",
            "first_element": "S_0=1_A",
        },
        "prescribed_system": [
            "e^2-e=0",
            "sigma(e)-e=0",
            "Trd(e)-2=0",
            "e*S_i*e=0 for i=0,...,4",
        ],
        "all_coordinate_equations": {
            "idempotent": [{"source": "e^2-e", "coordinate": k} for k in range(36)],
            "self_adjoint": [{"source": "sigma(e)-e", "coordinate": k} for k in range(36)],
            "trace": [{"source": "Trd(e)-2"}],
            "section": [
                {"source": f"e*S_{i}*e", "coordinate": k}
                for i in range(5) for k in range(36)
            ],
            "discarded_coordinate_equations": 0,
        },
        "unit_ideal_certificate": {
            "notation": "h_k=coord_k(e^2-e), g_k=coord_k(e*S_0*e), tau_k=Trd(r_k)",
            "identities": [
                "S_0=1_A",
                "g_k-h_k=coord_k(e) for every k",
                "sum_k tau_k*(g_k-h_k)=Trd(e)",
                "(-1/2)*((Trd(e)-2)-sum_k tau_k*(g_k-h_k))=1",
            ],
            "conclusion": "the prescribed ideal is the unit ideal over K_proj",
        },
        "why_not_fano_emptiness": {
            "correct_equations": "f^2=f, Trd(f)=2, sigma(f)*S_i*f=0, with no sigma(f)=f condition",
            "right_ideal": "fA",
            "morita_line": "f(Ae_0) inside Ae_0 as a right e_0Ae_0-module",
            "auxiliary_open": "the ambient projector uses s=<Q(x),p> nonzero, while the x-section Fano equation is s=0",
            "correct_symmetric_model": {
                "ambient": "projective nonzero n in Sym(A,sigma)",
                "rank": "right-D rank one, equivalently reduced rank two",
                "equations": ["n^2=0", "Trd(n*S_i)=0 for i=0,...,4"],
                "split_formula": "n=P_U*Q for the decomposable bivector matrix P_U",
            },
            "conclusion": "the self-adjoint projector scheme is disjoint for a convention reason; the genuine Fano scheme is not proved empty",
        },
        "exit": "C5-UNDECIDED",
        "failure_subtype": "C5-CONVENTION-INCONSISTENCY",
        "marker": "C5_CONVENTION_GATE_FAIL",
    }
    (HERE / "projector_incidence.json").write_text(json.dumps(incidence, indent=2) + "\n")
    print("WROTE INPUT_MANIFEST.json")
    print("WROTE canonical_algebra_api.json")
    print("WROTE projector_incidence.json")
    print("C5_CANONICAL_ALGEBRA_OK")
    print("C5-CONVENTION-INCONSISTENCY")


if __name__ == "__main__":
    main()
