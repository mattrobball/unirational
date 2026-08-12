#!/usr/bin/env python3
"""Compile results/summary.json from per-degree artefacts."""
from __future__ import annotations

import json
import os

import paths
import lin


def loadj(name):
    path = os.path.join(paths.RES, name)
    if not os.path.exists(path):
        return None
    return json.load(open(path))


def main():
    curve = []
    for d, P3 in paths.SEALED_P3.items():
        K = paths.POST_FLIP_K[d]
        I3 = paths.I_3D[d]
        N3 = (K * (K + 1) * (K + 2)) // 6
        curve.append({
            "d": d,
            "K": K,
            "N3": N3,
            "P3": P3,
            "HF3": N3 - P3,
            "I_3d": I3,
            "deficit": I3 - P3,
            "source": "LANDING_INVARIANT_SIDE",
            "saturated": True,
            "primes_agree": True,
        })
    for d in (39, 40, 41, 42):
        r331 = loadj("p3_d%d_p331.json" % d)
        r661 = loadj("p3_d%d_p661.json" % d)
        if r331 is None:
            continue
        P3 = r331.get("P3")
        K = r331.get("K")
        I3 = r331.get("I_3d") or paths.I_3D[d]
        N3 = r331.get("N3")
        agree = (r661 is not None) and (r661.get("P3") == P3)
        sat = bool(r331.get("saturated")) and (
            r661 is None or bool(r661.get("saturated"))
        )
        curve.append({
            "d": d,
            "K": K,
            "N3": N3,
            "P3": P3,
            "HF3": (N3 - P3) if (N3 is not None and P3 is not None) else None,
            "I_3d": I3,
            "deficit": (I3 - P3) if P3 is not None else None,
            "source": "this packet",
            "saturated": sat,
            "primes_agree": agree,
            "p331": {"P3": r331.get("P3"), "sat": r331.get("saturated"),
                     "K": r331.get("K"), "seconds": r331.get("seconds")},
            "p661": None if r661 is None else {
                "P3": r661.get("P3"), "sat": r661.get("saturated"),
                "K": r661.get("K"), "seconds": r661.get("seconds"),
            },
            "qr_cut": r331.get("qr_cut"),
            "qr_cut_p3": r331.get("qr_cut_p3"),
        })

    control = {
        "331": loadj("control_d35_p331.json"),
        "661": loadj("control_d35_p661.json"),
    }
    semireg = {
        "331": loadj("semireg_d35_p331.json"),
        "661": loadj("semireg_d35_p661.json"),
    }
    fit = loadj("curve_fit.json")
    out = {
        "packet": "RANK_CURVE",
        "headline": "Problem E remains OPEN; this packet excludes no degree.",
        "curve": curve,
        "control": control,
        "semireg": {
            p: None if rec is None else {
                "largest_independent_subset": rec.get("largest_independent_subset"),
                "verdict": rec.get("verdict"),
                "no_dependency_found": rec.get("no_dependency_found"),
                "n_products": rec.get("n_products"),
                "P3": rec.get("P3"),
            }
            for p, rec in semireg.items()
        },
        "fit": fit,
    }
    lin.dump(os.path.join(paths.RES, "summary.json"), out)
    print("[compile_summary] wrote results/summary.json (%d curve rows)" % len(curve))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
