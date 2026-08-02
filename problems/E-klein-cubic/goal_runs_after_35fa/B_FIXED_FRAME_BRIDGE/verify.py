#!/opt/homebrew/bin/python3
"""Independent verifier for the Goal B fixed-frame bridge audit.

This verifier does not import the producer.  It reloads and hash-checks the
authoritative packets, replays Goal F, directly checks the current repaired
target simple-fold payload, checks the output seal, and verifies the formal
section counterexample.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]

SOURCES = {
    "goal": REPO / "goals_after_35fa8f/GOAL_B_FIXED_FRAME_TO_GENERIC_BRIDGE.md",
    "implementation_audit": REPO / "goals_after_35fa8f/IMPLEMENTATION_AUDIT.md",
    "goal_f_seal": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/SEAL.json",
    "field_presentation": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/field_presentation.json",
    "primitive_sextic": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/payload/global_primitive_u_sextic_exact.tsv",
    "goal_f_infinity": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/infinity_obstruction.json",
    "fixed_five_forms": REPO / "certificates/fixed_frame_arithmetic/five_forms.json",
    "fixed_frame_seal": REPO / "certificates/fixed_frame_arithmetic/SEAL.json",
    "pfaffian_seal": REPO / "certificates/pfaffian_point/SEAL.json",
    "idempotent_dictionary": REPO / "certificates/pfaffian_point/IDEMPOTENT_TO_KLEIN_POINT.md",
    "quaternion_corner": REPO / "certificates/pfaffian_point/quaternion_corner.json",
    "projector_proof_audit": REPO / "tmp/pfaffian_rank2_idempotent_attack/PROOF_AUDIT.md",
    "fold_payload": REPO / "certificates/fold_normalization/payload.json",
    "fold_seal": REPO / "certificates/fold_normalization/SEAL.json",
    "target_H": REPO / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv",
    "target_seal": REPO / "certificates/target_branch_global/SEAL.json",
    "target_mod3_report": REPO / "certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md",
    "target_mod3_payload": REPO / "certificates/target_branch_mod3/payload.json",
    "target_mod3_seal": REPO / "certificates/target_branch_mod3/SEAL.json",
    "fano_c0_model": REPO / "certificates/fano_interface_c0/C0_MODEL.md",
    "fano_c0_seal": REPO / "certificates/fano_interface_c0/SEAL.json",
}

EXPECTED_SOURCE_SHA256 = {
    "goal": "634855e1ba8e9cb803ae9ab72c2df3530b9c804f1531f725a628c2bd1f8ec2cc",
    "implementation_audit": "9bfe6898b624a659aa72cec25c58f9e5d7c799bad15ef470be5ec68f73eb5444",
    "goal_f_seal": "31d8863087fa8f4977b328921a57ed916fe1b334ad3761e3426092a24bf77394",
    "field_presentation": "6f8c7930a71dbf1125f5003ee39b241e7cfbf006499eccbecb24312025c50dde",
    "primitive_sextic": "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344",
    "goal_f_infinity": "00316341a4d5207d8630e3d8d4411113b8fa2df5f6b3db42b48aa3003e094405",
    "fixed_five_forms": "61377d6e464f7c78cf1fa91d13610b76dc4567de7b7214256e04de50066c83a4",
    "fixed_frame_seal": "cd19d977638509297b52e16526c983bc5b13f80a5d9486d8bf678c1ca902fd85",
    "pfaffian_seal": "817e3cb37478a02dca81ecbc77486f466f7e7b5953727b1f5b155721eed36643",
    "idempotent_dictionary": "d1194af309c13b46ce1c4d5d9c3d24a17ab5308b619559ea82a0bcea79fdefd8",
    "quaternion_corner": "9ca99aa07b642c6a083149372f5aa605236fb967597b84273510576cb15d60e9",
    "projector_proof_audit": "b0584719496cfff69bfe89c0188774f14f8b2cf18dd98ccaaa6c88bf5e9cb790",
    "fold_payload": "60a46087754830702ffee0bf13f6bc0445f0bf78ad4817cba1bde5847c29f33b",
    "fold_seal": "e2208a67bc3d90709f31cf2c5b6ef00a32b7d7b5c00b6633744c987b5d2d0c71",
    "target_H": "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501",
    "target_seal": "3b95f92c3e25144df234d593332bd79c765cdfc1d67b52540e89337f7c655c97",
    "target_mod3_report": "35b036e67dda0f0f62f89881e28ea10e54ab4edf30f459da9c853babc726e2e1",
    "target_mod3_payload": "981b4d1c5bf7c618b4110560278a7e3f07598b432897c57aae839cda2de3360d",
    "target_mod3_seal": "1490b24006a0d0bbb6070d2aa6524a3f62458028b97d81234e7dcde745f1c8e5",
    "fano_c0_model": "a425d373c5ecbf2c879b9703e63345a5ce249c705ee7a44eab3f40fa07f7bb2e",
    "fano_c0_seal": "d7260754e55ba1d7efdf30dadb93ce51287cbb9befa1dd724ab3ec2a566cac85",
}

EXPECTED_ARTIFACTS = {
    "BRANCH_COMPARISON.md", "BRIDGE_THEOREM.md", "INCIDENCE_DIAGRAM.md",
    "INPUTS.md", "OBJECT_DICTIONARY.md", "REMAINING_GATE.md", "REPLAY.md",
    "REQUIREMENTS.md", "STATUS.md", "WORKLOG.md", "bridge_payload.json",
    "counterexample_payload.json", "exact/field_presentation.json",
    "exact/five_forms.json", "exact/global_primitive_u_sextic_exact.tsv",
    "produce.py", "produce_seal.py", "verify.py", "verify_counterexample.py",
    "verify_projector_dictionary.py",
}


def digest(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def run_verifier(path: Path, markers: tuple[str, ...]) -> None:
    result = subprocess.run(
        [sys.executable, str(path)], cwd=path.parent, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, check=True,
    ).stdout
    for marker in markers:
        require(marker in result, f"upstream marker missing: {marker}")


def main() -> None:
    actual_sources = {name: digest(path) for name, path in SOURCES.items()}
    require(actual_sources == EXPECTED_SOURCE_SHA256, "authoritative input hash drift")

    goal = SOURCES["goal"].read_text()
    for marker in ("B0", "B1", "B2", "B3", "B-BRIDGE-REFUTED", "B-UNDECIDED"):
        require(marker in goal, f"goal contract marker missing: {marker}")

    goal_f = json.loads(SOURCES["goal_f_seal"].read_text())
    field_presentation = json.loads(SOURCES["field_presentation"].read_text())
    fixed_forms = json.loads(SOURCES["fixed_five_forms"].read_text())
    fixed_frame_seal = json.loads(SOURCES["fixed_frame_seal"].read_text())
    infinity = json.loads(SOURCES["goal_f_infinity"].read_text())
    pfaffian = json.loads(SOURCES["pfaffian_seal"].read_text())
    corner = json.loads(SOURCES["quaternion_corner"].read_text())
    fold = json.loads(SOURCES["fold_payload"].read_text())
    target = json.loads(SOURCES["target_seal"].read_text())
    target_mod3 = json.loads(SOURCES["target_mod3_payload"].read_text())
    target_mod3_seal = json.loads(SOURCES["target_mod3_seal"].read_text())

    require(goal_f["exit"] == "F-CONIC-CRITERION-EMPTY", "Goal F exit drift")
    require("pointlessness of the genuine generic Klein twist" in goal_f["not_proved"],
            "Goal F scope fence missing")
    require(infinity["leading_coefficient"]["factorization"] ==
            "c6=38263752*B^2*(A-15)*D", "Goal F factor drift")
    require(field_presentation["primitive_equation"] == "P(A,B,Y,Z,u)=0",
            "field equation drift")
    require(field_presentation["selected_embedding"]["u"] == "class of u modulo P",
            "ordered embedding drift")
    require(fixed_forms["kappa_equals"] == "-11/18", "fixed-frame kappa drift")
    require(set(fixed_forms["forms"]) == {"F0", "FA", "FB", "FY", "FZ"},
            "fixed-frame form set drift")
    require(fixed_frame_seal["files"]["five_forms.json"] ==
            EXPECTED_SOURCE_SHA256["fixed_five_forms"], "fixed-frame seal mismatch")
    require(field_presentation["payload_sha256"]["global_primitive_u_sextic_exact.tsv"] ==
            EXPECTED_SOURCE_SHA256["primitive_sextic"], "primitive sextic seal mismatch")
    witness = infinity["leading_coefficient"]["c5_nondivisibility_witness"]
    require(witness["c5"] != "0", "c5 unit witness vanished")

    require(pfaffian["gate1_decision"] == "FAIL-SCOPE", "Pfaffian gate drift")
    require(corner["equivalence_with_installed_cubic"]["abstract_cubic_soluble_over_K"] is True,
            "auxiliary nonemptiness drift")
    require(corner["equivalence_with_installed_cubic"]["systems_equivalent"] is False,
            "auxiliary/Fano scope collapse")
    require(corner["five_hermitian_forms"]["common_line"] == "open",
            "genuine common-line gate was silently closed")
    require("rank two after splitting" in SOURCES["projector_proof_audit"].read_text(),
            "primary projector rank proof drift")

    require(fold["claims"]["selected_component_is_mult1_simple_fold"] is True,
            "target simple-fold claim drift")
    require(fold["claims"]["generic_rank"] == 1, "target generic rank drift")
    require(fold["lc_u"]["H_does_not_divide_lc"] is True, "target lc gate drift")
    require("lc_u(P)" in fold["accepted_inputs"]["simple_fold_gates"], "lc gate missing")
    require("P_uu" in fold["accepted_inputs"]["simple_fold_gates"], "Puu gate missing")
    require(target["H_primitive_sha256"] == EXPECTED_SOURCE_SHA256["target_H"],
            "target H seal drift")
    require(target_mod3["accepted_theory"]["residue_degree_m"] == 1,
            "BR-T-NEG residue degree drift")
    require(target_mod3["accepted_theory"]["generic_cubic_smooth_on_branch"] is True,
            "BR-T-NEG smoothness drift")
    require(target_mod3["verdict"]["three_primary_defect"] == "NOT_DECIDED",
            "BR-T-NEG mod-three boundary drift")
    require(target_mod3["verdict"]["horizontal_degree_subgroup"] == "NOT_DECIDED",
            "BR-T-NEG horizontal degree boundary drift")
    require(target_mod3_seal["payload_sha256"] ==
            EXPECTED_SOURCE_SHA256["target_mod3_payload"], "target mod-three seal mismatch")
    require(json.loads(SOURCES["fold_seal"].read_text())["gate_T2"].startswith("T2-UNDECIDED"),
            "repaired fold T2 boundary drift")

    payload = json.loads((HERE / "bridge_payload.json").read_text())
    require(payload["exit"] == "B-UNDECIDED", "payload exit overclaim")
    require(payload["headline"] == "OPEN", "payload headline overclaim")
    require(payload["source_sha256"] == actual_sources, "payload source hashes drift")
    for name, record in payload["exact_payloads"].items():
        local = HERE / record["local_path"]
        require(digest(local) == record["local_sha256"] == record["source_sha256"],
                f"exact payload copy drift: {name}")
    primitive_lines = (HERE / "exact/global_primitive_u_sextic_exact.tsv").read_text().splitlines()
    require(len(primitive_lines) == 1594, "primitive sextic term count drift")
    require(max(int(line.split()[4]) for line in primitive_lines[1:]) == 6,
            "primitive payload is not sextic in u")
    require(json.loads((HERE / "exact/field_presentation.json").read_text()) == field_presentation,
            "local field payload differs structurally")
    require(json.loads((HERE / "exact/five_forms.json").read_text()) == fixed_forms,
            "local fixed forms differ structurally")
    require(payload["fields"] == {
        "base": "F=C(A,B,Y,Z)",
        "degree": 6,
        "extension": "K_proj=Frac(F[u]/(P(A,B,Y,Z,u)))",
        "ordered_embedding": "u maps to the class of u modulo the exact primitive sextic P",
        "primitive_sextic_payload": "exact/global_primitive_u_sextic_exact.tsv",
    }, "field dictionary drift")
    objects = payload["objects"]
    require(set(objects) == {"generic_twist", "fano_section",
                             "auxiliary_characteristic_cubic", "fixed_ternary_cubic"},
            "object dictionary key drift")
    require(objects["generic_twist"]["expanded_K_proj_frame_installed"] is False,
            "generic-twist executable-frame overclaim")
    require(objects["generic_twist"]["scheme"].startswith("X_gen=T_proj times^G X"),
            "generic contracted-product scheme drift")
    require("faithfully flat splitting cover" in objects["generic_twist"]["functor"],
            "generic twist functor descent drift")
    require(objects["generic_twist"]["equation_scope"].startswith("splitting-frame"),
            "generic-twist equation scope drift")
    require(objects["fano_section"]["explicit_quaternion_symbol_and_H_i_matrices_installed"] is False,
            "Fano executable-matrix overclaim")
    require("locally direct-summand" in objects["fano_section"]["functor"],
            "Fano functor line-bundle drift")
    require(objects["auxiliary_characteristic_cubic"]["section"] ==
            "line projector p maps to a=1-p", "projector section drift")
    require(objects["auxiliary_characteristic_cubic"]["full_projective_cubic"] ==
            "Z_aux={[a] in P(Sym):c3(a)=0}", "full auxiliary cubic missing")
    require(objects["auxiliary_characteristic_cubic"]["projective_spectral_open"] ==
            "P_aux=Z_aux cap D(c2)", "auxiliary spectral open drift")
    require(objects["fixed_ternary_cubic"]["coefficient_payload"] == "exact/five_forms.json",
            "fixed coefficient payload drift")
    arrows = {(entry["source"], entry["target"]): entry for entry in payload["arrows"]}
    require(arrows[("fixed_ternary_cubic", "Z_aux")]["class"] ==
            "closed projective linear slice", "full fixed slice arrow drift")
    require(arrows[("auxiliary_characteristic_open", "Z_aux")]["class"].startswith("open immersion"),
            "full cubic/open boundary collapse")
    require(arrows[("structure_projectors", "P^2_D")]["class"].startswith("open immersion"),
            "projector ambient arrow drift")
    require("not necessarily contained" in arrows[("F14_T", "P^2_D")]["class"],
            "Fano/projector-open collapse")
    require(arrows[("structure_projector", "F14_T common line")]["class"].startswith("no implication"),
            "auxiliary-to-Fano implication overclaim")
    require(payload["gauge"]["distinguished_rational_gauge"] ==
            "Gamma=PGU(h_struct) cap Stab_{PGL_3(D)}(H_T)", "gauge group drift")
    require(payload["gauge"]["splitting_field_change_sufficient"] is False,
            "splitting-field gauge overclaim")
    dictionary_text = (HERE / "OBJECT_DICTIONARY.md").read_text()
    for phrase in ("fppf contracted product", "locally direct-summand",
                   "Z_aux =", "P_aux = Z_aux cap D(c2)",
                   "P_aux_aff/G_m", "p` is a line projector", "a=1-p",
                   "Gamma = PGU(h_struct)", "No expanded full-group frame",
                   "does not install explicit"):
        require(phrase in dictionary_text, f"object dictionary phrase missing: {phrase}")
    require(payload["B1"]["auxiliary_slice_nonexhaustive"] is True,
            "auxiliary conclusion missing")
    require(payload["B1"]["genuine_F14_missed_K_orbit_proved"] is False,
            "genuine rational-orbit overclaim")
    require(payload["B1"]["geometric_or_scheme_image_nonexhaustive_proved"] is False,
            "geometric image overclaim")
    require(payload["B1"]["exhaustiveness_on_F14"] == "UNDECIDED",
            "B1 boundary drift")
    require(payload["B2"]["infinity"]["ramification_index"] == 1,
            "infinity ramification drift")
    require(payload["B2"]["target"]["ramification_index"] == 2,
            "target ramification drift")
    require(payload["B2"]["target"]["residual_index"] == "OPEN",
            "target residual index overclaim")
    require(payload["B2"]["target"]["generic_residual_cubic_smooth"] is True,
            "target residual smoothness drift")
    require(payload["B2"]["same_base_valuation"] is False,
            "distinct valuations incorrectly identified")
    gate = payload["smallest_live_gate"]
    require(gate["status"] == "UNDECIDED", "remaining gate status overclaim")
    require("C(K_proj)=empty => F14_T(K_proj)=empty" in gate["implication"],
            "remaining implication drift")
    require(gate["ledger"] == "REMAINING_GATE.md", "remaining gate ledger drift")
    require(payload["goal_f_scope_consistency"]["upstream_exit"] ==
            "F-CONIC-CRITERION-EMPTY", "F scope consistency exit drift")
    require(payload["goal_f_scope_consistency"]["enlarged_to_F14_or_X_gen"] is False,
            "F scope illegally enlarged")
    require(payload["goal_f_scope_consistency"]["headline_claimed_from_F"] is False,
            "headline claimed from fixed-frame emptiness")
    remaining = (HERE / "REMAINING_GATE.md").read_text()
    for phrase in ("C(K) = ∅   ⇒   F14_T(K) = ∅",
                   "common isotropic right `D`-line",
                   "Γ = PGU(h_struct)",
                   "F-CONIC-CRITERION-EMPTY",
                   "B-UNDECIDED"):
        require(phrase in remaining, f"REMAINING_GATE phrase missing: {phrase}")
    print("B_OBJECT_DICTIONARY_ACCEPT")
    print("B_AUXILIARY_SCOPE_BOUNDARY_ACCEPT")
    print("B_BRANCH_VALUATIONS_DISTINCT_ACCEPT")
    print("B_TARGET_FOLD_SEALED_INPUT_ACCEPT")
    print("B_REMAINING_GATE_AND_F_SCOPE_ACCEPT")

    run_verifier(
        HERE / "verify_projector_dictionary.py",
        ("B_PROJECTOR_COMPLEMENT_SECTION_ACCEPT",
         "B_PROJECTOR_PROJECTIVIZATION_ACCEPT"),
    )
    print("B_PROJECTOR_COMPLEMENT_SECTION_ACCEPT")
    print("B_PROJECTOR_PROJECTIVIZATION_ACCEPT")

    run_verifier(
        HERE / "verify_counterexample.py",
        ("B_FORMAL_SECTION_EXACT_ALGEBRA_ACCEPT",
         "B_FORMAL_SECTION_INDEX_PROOF_LEDGER_ACCEPT"),
    )
    print("B_FORMAL_SECTION_EXACT_ALGEBRA_ACCEPT")
    print("B_FORMAL_SECTION_INDEX_PROOF_LEDGER_ACCEPT")

    for filename in ("STATUS.md", "BRIDGE_THEOREM.md", "REQUIREMENTS.md"):
        text = (HERE / filename).read_text()
        require("B-UNDECIDED" in text, f"terminal boundary missing from {filename}")
    require((HERE / "STATUS.md").read_text().splitlines()[0] == "B-UNDECIDED",
            "wrong status first line")
    require("actual implication" in (HERE / "BRIDGE_THEOREM.md").read_text(),
            "actual-implication scope fence missing")

    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal["exit"] == "B-UNDECIDED", "seal exit overclaim")
    require(seal["source_sha256"] == actual_sources, "seal input hashes drift")
    disk_artifacts = {
        str(path.relative_to(HERE)) for path in HERE.rglob("*")
        if path.is_file() and path.name != "SEAL.json"
    }
    require(disk_artifacts == EXPECTED_ARTIFACTS, "packet disk inventory drift")
    require(set(seal["artifact_sha256"]) == EXPECTED_ARTIFACTS,
            "seal artifact inventory drift")
    for relative, expected in seal["artifact_sha256"].items():
        require(digest(HERE / relative) == expected, f"sealed artifact drift: {relative}")

    run_verifier(
        REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/verify.py",
        ("GOAL_F_EXACT_FIELD_LAYER_ACCEPT", "GOAL_F_CONIC_CRITERION_EMPTY_ACCEPT"),
    )
    print("B_GOAL_F_UPSTREAM_REPLAY_ACCEPT")
    print("B_UNDECIDED_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
