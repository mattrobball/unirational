#!/usr/bin/env python3
"""Independent verifier for Path F restricted étale algebra F1.

Does not import produce_restricted_algebra.py. Replays:
  - source hash pins
  - structural claims in restricted_algebra.json
  - one exact Q(zeta_11) specialization proving L is a degree-8 field
  - K_proj rigidity pin and linear-disjointness logic checklist
  - CFOSS pin presence

Does not decide res(xi)=0 and does not run F2/F3 heavy jobs.
"""

from __future__ import annotations

import json
import os
import resource
import subprocess
import sys
import tempfile
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PAYLOAD = HERE / "restricted_algebra.json"
MD = HERE / "RESTRICTED_ETALE_ALGEBRA.md"
SPEC_RESULTS = ROOT / "tmp/postelo_F/R8_specialization_results.json"
FIVE = ROOT / "certificates/fixed_frame_arithmetic/five_forms.json"
CFOSS = ROOT / "certificates/pfaffian_point/CFOSS_W1_INPUT.md"
MINIMAL = ROOT / "tmp/pfaffian_minimal_ternary_model/certificate.json"
ALPHA_CERT = ROOT / "tmp/pfaffian_depressed_alpha_r/certificate.json"
JULIA = Path("/opt/homebrew/bin/julia")
CEILING = 2 * 1024**3
CAP_ENV = "PATHF_RESTRICTED_E3_VERIFY_MIB"
MARKER = "PATH_F_RESTRICTED_ETALE_ALGEBRA_ACCEPT"


def enforce_limit() -> str:
    try:
        resource.setrlimit(resource.RLIMIT_AS, (CEILING, CEILING))
        return "RLIMIT_AS=2147483648"
    except (OSError, ValueError):
        if sys.platform != "darwin":
            raise
        if os.environ.get(CAP_ENV) == "2048":
            return "taskpolicy -m 2048"
        environment = dict(os.environ)
        environment[CAP_ENV] = "2048"
        os.execve(
            "/usr/sbin/taskpolicy",
            ["taskpolicy", "-m", "2048", sys.executable, *sys.argv],
            environment,
        )
        raise AssertionError("taskpolicy exec unexpectedly returned")


CAP_BACKEND = enforce_limit()


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def check_sources(payload: dict) -> None:
    src = payload["sources_sha256"]
    mapping = {
        "five_forms.json": FIVE,
        "CFOSS_W1_INPUT.md": CFOSS,
        "minimal_ternary_certificate.json": MINIMAL,
        "alpha_r_certificate.json": ALPHA_CERT,
        "R8_specialization_results.json": SPEC_RESULTS,
    }
    for key, path in mapping.items():
        assert path.is_file(), f"missing {path}"
        assert src[key] == file_hash(path), f"hash mismatch {key}"


def check_structure(payload: dict) -> None:
    assert payload["format"] == "pathF-restricted-etale-algebra-v1"
    assert payload["headline"] == "OPEN"
    assert payload["binary_status"] == "UNDECIDED"
    assert payload["base_fields"]["K_proj"]["degree_over_F"] == 6
    assert payload["base_fields"]["K_proj"]["proper_intermediate_fields"] is False
    assert payload["R_over_F"]["rank"] == 9
    assert payload["R_over_F"]["presentation"]["nonzero_factor"]["is_field"] is True
    assert payload["R_over_F"]["presentation"]["nonzero_factor"]["rank_over_F"] == 8
    assert payload["R_K"]["rank_over_K_proj"] == 9
    assert payload["R_K"]["factorization"]["nonzero_factor"]["is_field"] is True
    assert payload["R_K"]["factorization"]["nonzero_factor"]["degree_over_K_proj"] == 8
    assert payload["R_over_F"]["galois_module"]["Aut_L_over_F"]["status"] == "NOT_COMPUTED_IN_CHAR0"
    # CFOSS pin must be specific
    inj = payload["alpha_R_image"]["cfoss_identification"]["injectivity"]
    assert "Lemma 3.1" in inj
    assert "86f5b9a156c9afffdb3434670012b48bbfdb058ca22f4b2fefac493d5d7d1e01" in inj
    assert "Corollary 3.12" in payload["alpha_R_image"]["cfoss_identification"]["class_identification"]
    cfoss_text = CFOSS.read_text()
    assert "Lemma 3.1" in cfoss_text
    assert "86f5b9a156c9afffdb3434670012b48bbfdb058ca22f4b2fefac493d5d7d1e01" in cfoss_text


def check_saved_specializations(payload: dict) -> None:
    saved = json.loads(SPEC_RESULTS.read_text())
    assert len(saved) >= 3
    for row in saved:
        assert row["delta_zero"] is False
        assert row["psi_degree_type"] == [4]
        assert row["primitive8_u"] == 1
        assert row["best_chi_degs"] == [8]
    # payload must mirror the same witnesses
    wit = payload["specialization_witnesses"]["points"]
    assert len(wit) == len(saved)
    for a, b in zip(wit, saved):
        assert a["point"] == b["point"]
        assert a["primitive8_u"] == 1


def replay_one_specialization() -> None:
    """Independent Julia/Hecke replay at (1,2,3,4); does not import the producer."""
    script = r"""
using Pkg
Pkg.activate("/tmp/nemo_test")
using Hecke
using JSON

cert = JSON.parsefile("tmp/pfaffian_minimal_ternary_model/certificate.json")
iface = cert["universal_genus_one_interface"]
c4_terms = iface["c4_terms"]
c6_terms = iface["c6_terms"]
ff = JSON.parsefile("certificates/fixed_frame_arithmetic/five_forms.json")
K, z = cyclotomic_field(11, "z")

function parse_cyc(pairs)
    s = zero(K)
    for (i, pr) in enumerate(pairs)
        n = BigInt(pr[1]); d = BigInt(pr[2])
        s += K(QQ(n)//QQ(d)) * z^(i-1)
    end
    return s
end
slots = Dict{String,Vector{elem_type(K)}}()
for name in keys(ff["binary_slots"])
    slots[String(name)] = [parse_cyc(p) for p in ff["binary_slots"][name]]
end
A,B,Y,Z = 1,2,3,4
AA,BB,YY,ZZ = K(A),K(B),K(Y),K(Z)
qs = [slots["q0"][i] + AA*slots["qA"][i] + YY*slots["qY"][i] for i in 1:3]
rs = [slots["r0"][i] + AA*slots["rA"][i] + BB*slots["rB"][i] + YY*slots["rY"][i] + ZZ*slots["rZ"][i] for i in 1:4]
vals = vcat(qs, rs)
function eval_terms(terms, vals)
    s = zero(K)
    for t in terms
        mon = one(K)
        for (v,e) in zip(vals, t["exponents"])
            ee = Int(e)
            if ee != 0; mon *= v^ee; end
        end
        s += K(Int(t["coefficient"])) * mon
    end
    return s
end
c4 = eval_terms(c4_terms, vals)
c6 = eval_terms(c6_terms, vals)
Delta = (c4^3 - c6^2) * inv(K(1728))
@assert !iszero(Delta)
AE = -27*c4; BE = -54*c6
RK, Xk = polynomial_ring(K, "X")
psiK = 3*Xk^4 + 6*AE*Xk^2 + 12*BE*Xk - AE^2
facpsi = Hecke.factor(psiK)
pairs = collect(facpsi)
@assert length(pairs) == 1
f,e = pairs[1]
@assert e == 1 && degree(f) == 4
Ru, Tu = polynomial_ring(K, "T")
Rx, Xx = polynomial_ring(Ru, "X")
psi2 = 3*Xx^4 + 6*AE*Xx^2 + 12*BE*Xx - AE^2
RY2 = (Tu - Xx)^2 - K(1)^2 * (Xx^3 + AE*Xx + BE)
chi = resultant(psi2, RY2)
fac2 = Hecke.factor(chi)
pairs2 = collect(fac2)
@assert degree(chi) == 8
@assert length(pairs2) == 1
f2,e2 = pairs2[1]
@assert e2 == 1 && degree(f2) == 8
println("INDEPENDENT_SPEC_1234_FIELD8_OK")
"""
    with tempfile.NamedTemporaryFile("w", suffix=".jl", delete=False) as fh:
        fh.write(script)
        path = fh.name
    try:
        r = subprocess.run(
            [str(JULIA), "--project=/tmp/nemo_test", path],
            cwd=str(ROOT),
            capture_output=True,
            text=True,
            timeout=300,
        )
    finally:
        os.unlink(path)
    if r.returncode != 0:
        sys.stderr.write(r.stdout)
        sys.stderr.write(r.stderr)
        raise AssertionError("independent specialization replay failed")
    assert "INDEPENDENT_SPEC_1234_FIELD8_OK" in r.stdout


def check_markdown() -> None:
    text = MD.read_text()
    for needle in [
        "R_K = R",
        "K_proj",
        "Lemma 3.1",
        "Corollary 3.12",
        "degree-8",
        "linearly disjoint",
        "OPEN",
        "UNDECIDED",
    ]:
        assert needle in text, f"missing {needle} in markdown"


def main() -> None:
    assert PAYLOAD.is_file(), f"missing {PAYLOAD}"
    assert MD.is_file(), f"missing {MD}"
    payload = json.loads(PAYLOAD.read_text())
    check_sources(payload)
    check_structure(payload)
    check_saved_specializations(payload)
    replay_one_specialization()
    check_markdown()

    print(f"CAP_BACKEND={CAP_BACKEND}")
    print("PASS restricted etale algebra structure")
    print("PASS specialization field witnesses")
    print("PASS independent (1,2,3,4) degree-8 replay")
    print("PASS CFOSS I Lemma 3.1 / Cor 3.12 pin")
    print("STRICT BOUNDARY binary res(xi) undecided; F2/F3 not executed")
    print(MARKER)


if __name__ == "__main__":
    main()
