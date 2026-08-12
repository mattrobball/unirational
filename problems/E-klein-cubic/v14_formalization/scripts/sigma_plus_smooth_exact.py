#!/usr/bin/env python3
"""Emit and optionally run an exact characteristic-zero M2 smoothness script."""
from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def kdec(x):
    return [Fraction(int(a), int(b)) for a, b in x]


def poly_m2(a, var="z"):
    terms = []
    for i, c in enumerate(a):
        if c == 0:
            continue
        if c.denominator == 1:
            coeff = str(c.numerator)
        else:
            coeff = f"({c.numerator}/{c.denominator})"
        if i == 0:
            terms.append(coeff)
        elif i == 1:
            terms.append(f"{coeff}*{var}")
        else:
            terms.append(f"{coeff}*{var}^{i}")
    return " + ".join(terms) if terms else "0"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    data = json.loads((ROOT / "results" / "sigma_plus_segre_Ki.json").read_text())
    Fc = data["plane_cubic_F_u"]["coefficients"]
    mons = data["plane_cubic_F_u"]["monomial_order"]
    names = ["U", "V", "W"]
    terms = []
    for idx, mon in enumerate(mons):
        re, im = kdec(Fc[idx]["re"]), kdec(Fc[idx]["im"])
        counts = [mon.count(0), mon.count(1), mon.count(2)]
        parts = []
        for v, e in zip(names, counts):
            if e == 1:
                parts.append(v)
            elif e > 1:
                parts.append(f"{v}^{e}")
        monom = "*".join(parts) if parts else "1"
        re_s = poly_m2(re)
        im_s = poly_m2(im)
        terms.append(f"(({re_s}) + ({im_s})*I)*({monom})")
    Fexpr = " + ".join(terms)
    script = f"""-- Exact smoothness of Fplus over Q(zeta_11)[i].
-- Ki = toField(QQ[z,I]/(Phi11, I^2+1)); work in Ki[U,V,W].
R0 = QQ[z,I];
A = R0 / ideal(z^10+z^9+z^8+z^7+z^6+z^5+z^4+z^3+z^2+z+1, I^2+1);
Ki = toField A;
R = Ki[U,V,W];
F = {Fexpr};
Fu = diff(U,F); Fv = diff(V,F); Fw = diff(W,F);
JU = ideal(Fu,Fv,Fw,U-1);
JV = ideal(Fu,Fv,Fw,V-1);
JW = ideal(Fu,Fv,Fw,W-1);
uok = (1_R % gens gb JU == 0_R);
vok = (1_R % gens gb JV == 0_R);
wok = (1_R % gens gb JW == 0_R);
<< "chart_smooth=" << {{uok, vok, wok}} << endl;
if uok then (CU = 1_R // gens JU; << "CU=" << toString CU << endl;);
if vok then (CV = 1_R // gens JV; << "CV=" << toString CV << endl;);
if wok then (CW = 1_R // gens JW; << "CW=" << toString CW << endl;);
assert(uok and vok and wok);
"""
    args.out.write_text(script)
    print("wrote", args.out)


if __name__ == "__main__":
    main()
