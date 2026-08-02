#!/usr/bin/env python3
"""Intersect the exact generic conductor RUR with A=15, Y=12.

This is an exact characteristic-zero calculation.  It eliminates ``u`` from
QZ(15,u,Z) and 12*dQZ/dZ-NY(15,u,Z), then compares the resulting support in
Z with the three raw-target singular curves on the plane after recovering B
from B*dQZ/dZ=NB.
"""

from __future__ import annotations

import hashlib
import json
from collections import defaultdict
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
OUT = HERE / "conductor_plane_result.json"
A0 = 15


def load_tsv(name: str):
    bucket = defaultdict(int)
    path = HERE / name
    with path.open() as stream:
        assert next(stream).strip() == "A\tu\tZ\tcoefficient"
        for line in stream:
            a, upow, zpow, coefficient = map(int, line.split())
            bucket[(upow, zpow)] += coefficient * A0**a
    return path, bucket


def as_expr(bucket, u, z):
    return sum(c * u**i * z**j for (i, j), c in bucket.items())


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def factor_summary(poly: sp.Poly):
    content, primitive = poly.primitive()
    unit, factors = sp.factor_list(primitive)
    return {
        "content": str(content),
        "unit": str(unit),
        "degree": primitive.degree(),
        "factors": [
            {
                "degree": f.degree(),
                "exponent": e,
                "coefficients_constant_first": [str(f.nth(i)) for i in range(f.degree() + 1)],
            }
            for f, e in factors
        ],
    }


def main():
    u, z = sp.symbols("u z")
    q_path, qd = load_tsv("generic_singular_rur_QZ.tsv")
    nb_path, nbd = load_tsv("generic_singular_rur_NB.tsv")
    ny_path, nyd = load_tsv("generic_singular_rur_NY.tsv")
    q = sp.Poly(as_expr(qd, u, z), u, z, domain=sp.QQ)
    nb = sp.Poly(as_expr(nbd, u, z), u, z, domain=sp.QQ)
    ny = sp.Poly(as_expr(nyd, u, z), u, z, domain=sp.QQ)
    qp = sp.Poly(sp.diff(q.as_expr(), z), u, z, domain=sp.QQ)
    ry = sp.Poly(12 * qp.as_expr() - ny.as_expr(), u, z, domain=sp.QQ)
    print("RESULTANT_BEGIN", flush=True)
    res = sp.Poly(sp.resultant(q.as_expr(), ry.as_expr(), u), z, domain=sp.QQ)
    print("RESULTANT_DONE degree", res.degree(), flush=True)
    summary = factor_summary(res)
    payload = {
        "schema": "t3-conductor-plane-intersection-v1",
        "specialization": {"A": 15, "Y": 12},
        "resultant_QZ_12QZprime_minus_NY": summary,
        "source_sha256": {p.name: sha(p) for p in (q_path, nb_path, ny_path)},
        "scope": "Exact eliminant support only; branch recovery and saturation still required.",
    }
    OUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, indent=2, sort_keys=True))
    print("T3_CONDUCTOR_PLANE_RESULTANT_DONE")


if __name__ == "__main__":
    main()
