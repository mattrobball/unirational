#!/usr/bin/env python3
"""Deterministic good-reduction audit of residual discriminant tangencies.

This is a discovery/audit packet, not a replacement for the exact
characteristic-zero normalization ledger.  It restricts the exact projective
complete intersection Hbar=Delta_bar=0 to one explicit P2.  The plane is
adapted so that the affine contact plane S=(A-15L,Y-12L) meets it at
[x:y:z]=[0:0:1], while the sole common infinity plane E=(L,A) meets it at
[0:1:0].
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
from collections import defaultdict
from fractions import Fraction
from math import comb
from pathlib import Path

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
H_PATH = PROBLEM / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
D_PATH = HERE / "fixed_frame_discriminant_T.tsv"


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def modq(value: Fraction, prime: int) -> int:
    return value.numerator * pow(value.denominator, -1, prime) % prime


def load_projective_terms():
    affine_h = defaultdict(Fraction)
    with H_PATH.open() as stream:
        next(stream)
        for line in stream:
            a, b, y, z, coefficient = map(int, line.split())
            for j in range(z + 1):
                aa = a + 2 * (z - j)
                tt = j
                affine_h[(aa, b, y, tt)] += (
                    Fraction(coefficient) * comb(z, j) * Fraction(11, 18) ** (z - j)
                )
    affine_h = {monomial: coefficient for monomial, coefficient in affine_h.items() if coefficient}
    assert max(sum(monomial) for monomial in affine_h) == 39
    h = {
        (39 - sum(monomial), *monomial): coefficient
        for monomial, coefficient in affine_h.items()
    }
    assert h and all(sum(monomial) == 39 for monomial in h)

    d = {}
    with D_PATH.open() as stream:
        next(stream)
        for line in stream:
            a, b, y, t, coefficient = map(int, line.split())
            monomial = (11 - a - b - y - t, a, b, y, t)
            assert monomial[0] >= 0
            d[monomial] = Fraction(coefficient)
    assert d and all(sum(monomial) == 11 for monomial in d)
    return h, d


def poly_string(terms, names, prime):
    parts = []
    for monomial, coefficient in sorted(terms.items(), reverse=True):
        reduced = modq(coefficient, prime)
        if not reduced:
            continue
        factors = []
        if reduced != 1:
            factors.append(str(reduced))
        for name, exponent in zip(names, monomial):
            if exponent == 1:
                factors.append(name)
            elif exponent:
                factors.append(f"{name}^{exponent}")
        parts.append("*".join(factors) if factors else "1")
    return "+".join(parts)


def singular_source(prime, h, d):
    hp = poly_string(h, ("L", "A", "B", "Y", "T"), prime)
    dp = poly_string(d, ("L", "A", "B", "Y", "T"), prime)
    return f'''// Deterministic reduction of exact Hbar and fixed-frame Delta_bar.
option(redSB);
ring R={prime},(L,A,B,Y,T),dp;
poly H={hp};
poly D={dp};
ring S={prime},(x,y,z),dp;
map phi=R,
  z,
  x+15*z,
  2*x+3*y+5*z,
  y+12*z,
  7*x+11*y+13*z;
poly h=phi(H);
poly d=phi(D);
print("RESTRICTED_H_TERMS="+string(size(h)));
print("RESTRICTED_D_TERMS="+string(size(d)));
ideal I=h,d;
ideal GI=std(I);
print("CI_DIM="+string(dim(GI)));
print("CI_DEGREE="+degree(GI));
LIB "elim.lib";
ideal IoffS=sat(I,ideal(x,y));
ideal GIoffS=std(IoffS);
print("CI_OFF_S_DEGREE="+degree(GIoffS));
ideal IoffE=sat(I,ideal(x,z));
ideal GIoffE=std(IoffE);
print("CI_OFF_E_DEGREE="+degree(GIoffE));
ideal Ires=sat(IoffS,ideal(x,z));
ideal GIres=std(Ires);
print("CI_RESIDUAL_DEGREE="+degree(GIres));
poly hx=diff(h,x); poly hy=diff(h,y); poly hz=diff(h,z);
poly dx=diff(d,x); poly dy=diff(d,y); poly dz=diff(d,z);
ideal J=h,d,hx*dy-hy*dx,hx*dz-hz*dx,hy*dz-hz*dy;
ideal GJ=std(J);
print("JAC_DEGREE="+degree(GJ));
ideal JoffS=sat(J,ideal(x,y));
ideal GJoffS=std(JoffS);
print("JAC_OFF_S_DEGREE="+degree(GJoffS));
ideal JoffE=sat(J,ideal(x,z));
ideal GJoffE=std(JoffE);
print("JAC_OFF_E_DEGREE="+degree(GJoffE));
ideal Jres=sat(JoffS,ideal(x,z));
ideal GJres=std(Jres);
print("JAC_RESIDUAL_DIM="+string(dim(GJres)));
print("JAC_RESIDUAL_SIZE="+string(size(GJres)));
print("JAC_RESIDUAL_FIRST="+string(GJres[1]));
print("T3_PROJECTIVE_SLICE_DONE");
exit;
'''


def marker_int(output, label):
    match = re.search(rf"{re.escape(label)}=(-?\d+)", output)
    if not match:
        raise AssertionError(f"missing {label}")
    return int(match.group(1))


def degree_after(output, label):
    match = re.search(
        rf"{re.escape(label)}=// dimension \(proj\.\)\s*=\s*-?\d+\s*\n// degree \(proj\.\)\s*=\s*(\d+)",
        output,
    )
    if not match:
        raise AssertionError(f"missing degree {label}")
    return int(match.group(1))


def run_prime(prime, h, d, timeout):
    source = singular_source(prime, h, d)
    script_path = HERE / f"projective_slice_p{prime}.sing"
    log_path = HERE / f"projective_slice_p{prime}.out"
    script_path.write_text(source)
    result = subprocess.run(
        ["/opt/homebrew/bin/Singular", str(script_path)],
        capture_output=True,
        text=True,
        timeout=timeout,
    )
    output = result.stdout + result.stderr
    log_path.write_text(output)
    assert result.returncode == 0 and "T3_PROJECTIVE_SLICE_DONE" in output
    parsed = {
        "prime": prime,
        "restricted_H_terms": marker_int(output, "RESTRICTED_H_TERMS"),
        "restricted_D_terms": marker_int(output, "RESTRICTED_D_TERMS"),
        "ci_dimension_affine_cone": marker_int(output, "CI_DIM"),
        "ci_degree": degree_after(output, "CI_DEGREE"),
        "ci_off_S_degree": degree_after(output, "CI_OFF_S_DEGREE"),
        "ci_off_E_degree": degree_after(output, "CI_OFF_E_DEGREE"),
        "ci_residual_degree": degree_after(output, "CI_RESIDUAL_DEGREE"),
        "jacobian_degree": degree_after(output, "JAC_DEGREE"),
        "jacobian_off_S_degree": degree_after(output, "JAC_OFF_S_DEGREE"),
        "jacobian_off_E_degree": degree_after(output, "JAC_OFF_E_DEGREE"),
        "jacobian_residual_dimension": marker_int(output, "JAC_RESIDUAL_DIM"),
        "jacobian_residual_size": marker_int(output, "JAC_RESIDUAL_SIZE"),
        "jacobian_residual_first": marker_int(output, "JAC_RESIDUAL_FIRST"),
        "script_sha256": file_hash(script_path),
        "log_sha256": file_hash(log_path),
    }
    assert parsed["ci_dimension_affine_cone"] == 1
    assert parsed["ci_degree"] == 429
    assert parsed["ci_off_S_degree"] == 427
    assert parsed["ci_off_E_degree"] == 385
    assert parsed["ci_residual_degree"] == 383
    assert parsed["jacobian_degree"] == 44
    assert parsed["jacobian_off_S_degree"] == 43
    assert parsed["jacobian_off_E_degree"] == 1
    assert parsed["jacobian_residual_dimension"] == -1
    assert parsed["jacobian_residual_size"] == 1
    assert parsed["jacobian_residual_first"] == 1
    return parsed


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--primes", nargs="+", type=int, default=[1009, 10007])
    parser.add_argument("--timeout", type=int, default=1200)
    args = parser.parse_args()
    h, d = load_projective_terms()
    results = [run_prime(prime, h, d, args.timeout) for prime in args.primes]
    payload = {
        "schema": "t3-fixed-frame-projective-slice-audit-v1",
        "scope": "good-reduction audit only; not a characteristic-zero normalization or exhaustive factorization certificate",
        "plane_map": {
            "L": "z",
            "A": "x+15*z",
            "B": "2*x+3*y+5*z",
            "Y": "y+12*z",
            "T": "7*x+11*y+13*z",
            "affine_contact_point_S": "[0:0:1]",
            "boundary_point_E": "[0:1:0]",
        },
        "expected_cycle": {
            "complete_intersection_degree": 429,
            "S_intersection_multiplicity": 2,
            "E_intersection_multiplicity": 44,
            "residual_degree": 383,
            "tangency_lengths": {"S": 1, "E": 43, "residual": 0},
        },
        "results": results,
        "sources": {
            str(H_PATH.relative_to(PROBLEM)): file_hash(H_PATH),
            str(D_PATH.relative_to(HERE)): file_hash(D_PATH),
        },
    }
    (HERE / "projective_slice_payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, indent=2, sort_keys=True))
    print("T3_PROJECTIVE_SLICE_AUDIT_DONE")


if __name__ == "__main__":
    main()
