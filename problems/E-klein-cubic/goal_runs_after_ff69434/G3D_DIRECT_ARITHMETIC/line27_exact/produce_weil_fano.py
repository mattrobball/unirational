#!/usr/bin/env python3
"""Weil/Fano of lines on S_q over specialized field K_t = QQ(η), η=f7.

Primary CAS model (Singular algebraic coefficients):
  ring r = (0,z), (a,b,c,d), dp;
  minpoly = m_η(z);   # deg 12 irreducible over QQ at t=(2,3,5,7)
  Four equations = binary-cubic vanishing of G_q on chart-0 line params a,b,c,d
  with coefficients in QQ(z) ≅ K_t.

This is the Fano chart over K_t (4 vars). Degree 27 expected if smooth.
Weil degree over QQ would be 27*[K_t:QQ]=324 for the residue algebra;
the K_t-model already decides K_t-points (deg-1 factors over K_t).

Modular holdouts over F_p algebras recorded when useful.
"""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
import time
from functools import reduce
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
G3D = HERE.parent
ROOT = G3D.parents[1]
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"))
sys.path.insert(0, str(HERE))

from field_api import PARAMETERS, basis, one, multiply  # noqa: E402
from kt_model import DEFAULT_T, DIM, ETA_INDEX, build_kt  # noqa: E402

A, B, C, D, S, T = sp.symbols("a b c d s t")
Y = sp.symbols("y1 y2 y3 y4")
Z = sp.symbols("z")


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def secondary_to_power_matrix(kt) -> sp.Matrix:
    """P^{-1}: secondary coords -> power coords of η."""
    return kt["P_matrix"].inv()


def e_i_as_z_poly(i: int, Pinv: sp.Matrix) -> sp.Expr:
    """Express secondary basis e_i as polynomial in z=η of degree <12."""
    # secondary vector e_i
    v = sp.Matrix([1 if j == i else 0 for j in range(DIM)])
    coeffs = Pinv * v
    return sum(sp.simplify(coeffs[k, 0]) * Z**k for k in range(DIM))


def load_G_components_QQ(tvals):
    polar = json.loads((G3D / "polar_cubic_surface.json").read_text())
    subs = dict(zip(PARAMETERS, tvals))
    comps = []
    for item in polar["G_q"]["components"]:
        if item.get("zero"):
            comps.append(sp.Integer(0))
        else:
            g = sp.cancel(sp.sympify(item["num"]) / sp.sympify(item["den"]))
            comps.append(sp.expand(g.subs(subs)))
    return comps


def binary_coeffs_of_G_comp(Gexpr, u, v):
    """Restrict G(s*u+t*v); return 4 coeffs of s^3,s^2t,st^2,t^3 as QQ[a,b,c,d]."""
    pt = [S * u[i] + T * v[i] for i in range(4)]
    f = sp.expand(Gexpr.subs(dict(zip(Y, pt))))
    poly = sp.Poly(f, S, T)
    return [
        sp.expand(poly.coeff_monomial(m))
        for m in (S**3, S**2 * T, S * T**2, T**3)
    ]


def build_Kt_chart_equations(tvals=DEFAULT_T):
    """Four equations in K_t[a,b,c,d] as polys in (a,b,c,d,z) with deg_z < 12."""
    kt = build_kt(tvals)
    Pinv = secondary_to_power_matrix(kt)
    e_z = [e_i_as_z_poly(i, Pinv) for i in range(DIM)]
    comps = load_G_components_QQ(tvals)

    # chart 0: u=(1,0,a,b), v=(0,1,c,d)
    u = [1, 0, A, B]
    v = [0, 1, C, D]

    # Each binary slot j: sum_i e_i(z) * bin_ij(a,b,c,d) = 0 in K_t[a,b,c,d]
    # Store as single poly in a,b,c,d,z (coeffs of powers of z must each vanish
    # when working over QQ, but over K_t one poly per slot).
    eq_polys = [sp.Integer(0) for _ in range(4)]
    for i, G in enumerate(comps):
        if G == 0:
            continue
        bins = binary_coeffs_of_G_comp(G, u, v)
        for j in range(4):
            if bins[j] == 0:
                continue
            eq_polys[j] = sp.expand(eq_polys[j] + e_z[i] * bins[j])

    # Also expand to 48 QQ equations (coeff of each z^k in each of 4 eqs)
    weil_48 = []
    for j, f in enumerate(eq_polys):
        # treat as poly in z
        pz = sp.Poly(sp.expand(f), Z)
        for k in range(DIM):
            ck = sp.expand(pz.coeff_monomial(Z**k))
            if ck != 0:
                weil_48.append({"bin": j, "z_power": k, "poly": ck})

    return {
        "kt": {
            k: kt[k]
            for k in kt
            if k not in ("products_sp", "powers", "P_matrix")
        },
        "e_i_z": [str(sp.together(e)) for e in e_z],
        "eqs_Kt": [sp.together(f) for f in eq_polys],
        "weil_48_count": len(weil_48),
        "weil_48": weil_48,
        "minpoly_coeffs": kt["charpoly_coeffs_high_to_low"],
    }


def minpoly_singular_str(coeffs_high_to_low) -> str:
    """Monic minpoly string for Singular: z^12+..."""
    terms = []
    for i, c in enumerate(coeffs_high_to_low):
        c = sp.Integer(c)
        power = 12 - i
        if c == 0:
            continue
        if power == 0:
            terms.append(f"({c})" if c < 0 else str(c))
        elif power == 1:
            if c == 1:
                terms.append("z")
            elif c == -1:
                terms.append("-z")
            else:
                terms.append(f"({c})*z")
        else:
            if c == 1:
                terms.append(f"z^{power}")
            elif c == -1:
                terms.append(f"-z^{power}")
            else:
                terms.append(f"({c})*z^{power}")
    # Singular wants sum; ensure leading monic z^12
    return "+".join(terms).replace("+-", "-")


def poly_to_sing(expr) -> str:
    s = str(sp.expand(expr)).replace("**", "^")
    return s


def run_singular_Kt(eqs_Kt, minpoly_str, tag="Kt"):
    """std in (0,z)[a,b,c,d] with minpoly."""
    lines = [
        "option(redSB);",
        f"ring r = (0,z), (a,b,c,d), dp;",
        f"minpoly = {minpoly_str};",
    ]
    for i, f in enumerate(eqs_Kt):
        # reduce mod minpoly in z for each coeff
        lines.append(f"poly f{i} = {poly_to_sing(f)};")
    lines += [
        "ideal I = f0,f1,f2,f3;",
        "ideal J = std(I);",
        f'print(sprintf("{tag}|dim=%s|mult=%s|vdim=%s", string(dim(J)), string(mult(J)), string(vdim(J))));',
        "LIB \"primdec.lib\";",
        "if (dim(J) == 0) {",
        "  ideal rad = radical(I);",
        "  ideal Jr = std(rad);",
        f'  print(sprintf("{tag}|rad_vdim=%s|nprim=%s", string(vdim(Jr)), string(size(primdecGTZ(I)))));',
        "}",
        # lex for RUR shape if feasible
        "ring rlex = (0,z), (a,b,c,d), lp;",
        "ideal Ilex = fetch(r, I);",
        "ideal Glex = std(Ilex);",
        f'print(sprintf("{tag}|lex_size=%s", string(size(Glex))));',
        "if (size(Glex) > 0) {",
        f'  print(sprintf("{tag}|lex_G1_deg=%s", string(deg(Glex[1]))));',
        "  list fac = factorize(Glex[1]);",
        f'  print(sprintf("{tag}|nfac=%s", string(size(fac[1]))));',
        "  for (int i=1; i<=size(fac[1]); i++) {",
        f'    print(sprintf("{tag}|fac%s_deg=%s|fac%s_mult=%s", string(i), string(deg(fac[1][i])), string(i), string(fac[2][i])));',
        "  }",
        "}",
    ]
    script = HERE / f"_weil_{tag}.sing"
    script.write_text("\n".join(lines) + "\n")
    try:
        out = subprocess.check_output(
            ["singular", "-q", str(script)],
            text=True,
            stderr=subprocess.STDOUT,
            timeout=900,
        )
    except subprocess.TimeoutExpired:
        return {"error": "timeout", "raw": "TIMEOUT"}
    except subprocess.CalledProcessError as e:
        return {"error": "fail", "raw": (e.output or "")[:4000]}
    info = {"raw": out.strip()}
    for line in out.splitlines():
        if not line.startswith(tag + "|"):
            continue
        for part in line.split("|")[1:]:
            if "=" in part:
                k, v = part.split("=", 1)
                info[k] = int(v) if v.lstrip("-").isdigit() else v
    return info


def run_singular_weil48_mod(weil_48, mod, tag):
    """Optional modular QQ 48-var system from z-coeff expansion (holdout)."""
    # Variables a0.. only use a,b,c,d as scalars mod p - this is NOT full Weil;
    # skip full 48-var. Instead reduce eqs_Kt mod (p, root of minpoly) when linear factor.
    return {"skipped": True, "reason": "use Kt algebraic ring primary"}


def main():
    """Delegate to modular multi-prime producer (load-bearing path)."""
    import run_modular_fano

    run_modular_fano.main()


if __name__ == "__main__":
    main()
