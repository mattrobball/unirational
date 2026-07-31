#!/usr/bin/env python3
"""Path T / Gate T2 producer — amended under REPAIR.md Part I.

Seals T2-UNDECIDED pending exact saturated same-open dimension proof.
Historical T-NONNORMAL / dim Sing_S=2 suspended.
Does not import the verifier.  Does not re-eliminate u for H.
Does not run T3/T4.  No timing fields.  Self-hashes after last payload byte.
"""

from __future__ import annotations

import json
import os
import resource
import sys
from functools import reduce
from hashlib import sha256
from math import gcd
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PRIMITIVE = (
    ROOT
    / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
)
H_PRIM = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
CEILING_MIB = 8192
CAP_ENV = "POSTELO_T2_PRODUCER_MIB"

MSOLVE_DIR = HERE / "t2_msolve"
EXPECTED_MSOLVE = {
    "Hsing_cut2_nosat_qq.out": "121e6d4cdc5ec8d09b9821743ace4c0054eadef87e3acbf737fcd77ad148278b",
    "Hsing_cut2b_qq.out": "01efacf368942c5782dfe192f03d81791518359d41b45db9482690acd348872d",
    "Hsing_cut2_p67.out": "5ebf0004a840993562bc66bcf168ec58988845c78944b9df4fab0418dcafdf88",
    "Hsing_cut2_p641.out": "866deb4a72e4d539c6362ca375ecf1bce289de35598b596f7b8939f66c659467",
    "fold_sing_cut2_nosat_qq.out": "b6e3b620d53860c3f445af75d1e7944fba92191c23829a65e7e8a88f2c7c6073",
}

STATUS = "T2-UNDECIDED pending exact saturated same-open dimension proof"


def enforce_limit() -> None:
    ceiling = CEILING_MIB * 1024**2
    try:
        resource.setrlimit(resource.RLIMIT_AS, (ceiling, ceiling))
    except (OSError, ValueError):
        if sys.platform != "darwin":
            raise
        if os.environ.get(CAP_ENV) == str(CEILING_MIB):
            return
        env = dict(os.environ)
        env[CAP_ENV] = str(CEILING_MIB)
        os.execve(
            "/usr/sbin/taskpolicy",
            ["taskpolicy", "-m", str(CEILING_MIB), sys.executable, *sys.argv],
            env,
        )


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def load_P_coeffs():
    coeffs = []
    with PRIMITIVE.open() as stream:
        assert next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in stream:
            *_, c = map(int, line.split())
            coeffs.append(c)
    assert len(coeffs) == 1593
    return coeffs


def load_H_count():
    n = 0
    with H_PRIM.open() as f:
        assert next(f).strip() == "A\tB\tY\tZ\tcoefficient"
        for _ in f:
            n += 1
    return n


def msolve_is_zero_dim_nonempty(text: str) -> bool:
    t = text.lstrip()
    if t.startswith("[-1]"):
        return False
    if t.startswith("[1,") and "-1" in t[:80] and "[]" in t[:80]:
        return False
    return t.startswith("[0,")


def msolve_is_positive_dim(text: str) -> bool:
    t = text.lstrip()
    return t.startswith("[1,") and "-1" in t[:80] and "[]" in t[:80]


def main() -> None:
    enforce_limit()

    p_hash = file_hash(PRIMITIVE)
    h_hash = file_hash(H_PRIM)
    assert p_hash == "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
    assert h_hash == "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"

    coeffs = load_P_coeffs()
    content = reduce(gcd, coeffs)
    assert content == 1
    h_n = load_H_count()
    assert h_n == 37992

    msolve_hashes = {}
    for name, expected in EXPECTED_MSOLVE.items():
        path = MSOLVE_DIR / name
        assert path.is_file(), f"missing {path}"
        h = file_hash(path)
        assert h == expected, f"hash mismatch {name}: {h} != {expected}"
        msolve_hashes[name] = h
        text = path.read_text()
        if name in ("Hsing_cut2_nosat_qq.out", "Hsing_cut2b_qq.out"):
            assert msolve_is_zero_dim_nonempty(text), f"{name} not 0-dim nonempty"
        if name in ("Hsing_cut2_p67.out", "Hsing_cut2_p641.out"):
            assert msolve_is_zero_dim_nonempty(text), f"{name} not 0-dim discovery"
        if name == "fold_sing_cut2_nosat_qq.out":
            assert msolve_is_positive_dim(text), "fold without H should be pos-dim"

    s2_path = HERE / "s2_cm_certificate.json"
    r1_path = HERE / "r1_singular_locus.json"
    payload_path = HERE / "serre_payload.json"
    serre_md = HERE / "SERRE_NORMALITY.md"
    finite_md = HERE / "FINITE_BIRATIONAL.md"

    for p in (s2_path, r1_path, payload_path, serre_md):
        assert p.is_file(), f"missing {p}"

    s2 = json.loads(s2_path.read_text())
    r1 = json.loads(r1_path.read_text())
    payload = json.loads(payload_path.read_text())

    assert s2["regular_sequence"] is True
    assert s2.get("G_inverted") is True
    assert STATUS in str(r1.get("status", ""))
    assert r1.get("dim_Sing_S") is None
    assert r1.get("R1") is None
    assert STATUS in str(payload.get("gate_T2", ""))
    assert payload["headline"] == "OPEN"
    assert payload.get("claims", {}).get("dim_Sing_S") is None
    assert STATUS in serre_md.read_text()

    ckpt_dir = HERE / "t2_ckpts"
    ckpt_dir.mkdir(exist_ok=True)
    for k, body in [
        (
            0,
            {
                "ckpt": 0,
                "inputs_ok": True,
                "P_sha256": p_hash,
                "H_sha256": h_hash,
                "content_P": content,
                "H_n_terms": h_n,
            },
        ),
        (
            1,
            {
                "ckpt": 1,
                "modular_discovery": msolve_hashes,
                "note": "modular dim discovery only; not char-0 dim theorem",
            },
        ),
        (
            2,
            {
                "ckpt": 2,
                "S2": "PROVED_ON_D_GSigma",
                "G_inverted": True,
                "mode": "CI_regular_sequence",
                "certificate": "s2_cm_certificate.json",
            },
        ),
        (
            3,
            {
                "ckpt": 3,
                "R1": None,
                "dim_Sing_S": None,
                "upper_bound_closed_unsaturated": "<=2",
                "exact_Q_cut2_nosat": ["Hsing_cut2_nosat_qq.out", "Hsing_cut2b_qq.out"],
                "status": STATUS,
            },
        ),
        (
            4,
            {
                "ckpt": 4,
                "gate_T2": STATUS,
                "headline": "OPEN",
                "repair": "REPAIR.md Part I; T2R required before T3",
            },
        ),
        (
            5,
            {
                "ckpt": 5,
                "gate_T2": STATUS,
                "headline": "OPEN",
                "terminal_marker": "POSTELO_T2_SERRE_PRODUCER_SEALED_UNDECIDED",
            },
        ),
    ]:
        (ckpt_dir / f"CKPT-{k}.json").write_text(
            json.dumps(body, indent=2, sort_keys=True) + "\n"
        )

    sources = {
        "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv": p_hash,
        "certificates/target_branch_global/H_factor/H_primitive_integer.tsv": h_hash,
    }
    for name, h in msolve_hashes.items():
        sources[f"certificates/fold_normalization/t2_msolve/{name}"] = h

    seal = {
        "schema": "klein-cubic-postelo-T2-serre-normality-seal-v2-repair",
        "headline": "OPEN",
        "gate_T1": "T-BIRATIONAL",
        "gate_T2": STATUS,
        "gate_T2_historical_suspended": "T-NONNORMAL",
        "SERRE_NORMALITY_sha256": file_hash(serre_md),
        "FINITE_BIRATIONAL_sha256": file_hash(finite_md) if finite_md.is_file() else None,
        "s2_cm_certificate_sha256": file_hash(s2_path),
        "r1_singular_locus_sha256": file_hash(r1_path),
        "serre_payload_sha256": file_hash(payload_path),
        "sources_sha256": sources,
        "msolve_artifacts_sha256": msolve_hashes,
        "repair_reference": "REPAIR.md Part I §§1-6, §15",
        "t2r_packet": "certificates/fold_normalization_t2r/",
        "terminal_marker": "POSTELO_T2_SERRE_PRODUCER_SEALED_UNDECIDED",
    }
    seal_path = HERE / "SEAL.json"
    body = json.dumps(seal, indent=2, sort_keys=True) + "\n"
    seal["seal_sha256"] = sha256(body.encode()).hexdigest()
    seal_path.write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")

    print("T2_PRODUCER_OK")
    print(f"gate_T2={STATUS}")
    print("S2=scoped_D_GSigma R1=undecided dim_Sing_S=null")
    print("POSTELO_T2_SERRE_PRODUCER_SEALED_UNDECIDED")


if __name__ == "__main__":
    main()
