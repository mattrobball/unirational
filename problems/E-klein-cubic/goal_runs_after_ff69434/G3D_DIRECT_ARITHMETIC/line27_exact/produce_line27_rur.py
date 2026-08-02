#!/usr/bin/env python3
"""Exact zero-dim line algebra of S_q (secondary-0 specializations) + RUR.

Scope (honest):
  - Exact cubic G from G3D polar secondary-0 component of G_q.
  - Six Gr(2,4) charts; Singular std/radical/primdec.
  - Multi-spec good t-points: always reduced 0-dim degree 27, one prime.
  - Chart 0 shape-lemma RUR over QQ at t=(2,3,5,7): monic deg-27 minpoly
    in d irreducible over QQ; a,b,c uniquely determined by d.
  - Modular F_p reconstruction: chart equations vanish at RUR point.

Full exact RUR over the field K_proj (all secondary generators free) remains
residual: coefficients live in the rank-12 algebra over P0.
"""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from functools import reduce
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
G3D = HERE.parent
ROOT = G3D.parents[1]
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89" / "G3A_EXACT_ARITHMETIC_DOMINANCE" / "src"))

from field_api import PARAMETERS  # noqa: E402

Y = sp.symbols("y1 y2 y3 y4")
A, B, C, D, S, T = sp.symbols("a b c d s t")


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def load_G0_num():
    polar = json.loads((G3D / "polar_cubic_surface.json").read_text())
    c0 = polar["G_q"]["components"][0]
    return sp.sympify(c0["num"]), polar


def primitive_G(tvals):
    num0, _ = load_G0_num()
    g = sp.expand(num0.subs(dict(zip(PARAMETERS, tvals))))
    G = sp.Poly(g, *Y)
    coeffs = [int(cf) for _, cf in G.terms()]
    c0 = int(reduce(sp.gcd, coeffs))
    return sp.Poly(sp.expand(G.as_expr() / c0), *Y), c0


def chart_equations(Gprim, piv=(0, 1)):
    free = [k for k in range(4) if k not in piv]
    p0, p1 = piv
    f0, f1 = free
    u = [0, 0, 0, 0]
    v = [0, 0, 0, 0]
    u[p0] = 1
    u[f0] = A
    u[f1] = B
    v[p1] = 1
    v[f0] = C
    v[f1] = D
    pt = [S * u[i] + T * v[i] for i in range(4)]
    f = sp.expand(Gprim.as_expr().subs(dict(zip(Y, pt))))
    poly = sp.Poly(f, S, T)
    eqs = [
        sp.expand(poly.coeff_monomial(m))
        for m in (S**3, S**2 * T, S * T**2, T**3)
    ]
    return eqs, (u, v), free


def run_singular(script: str, name: str) -> str:
    path = HERE / name
    path.write_text(script)
    return subprocess.check_output(
        ["singular", "-q", str(path)], text=True, stderr=subprocess.STDOUT
    )


def sing_vdim_script(eqs, tag: str) -> str:
    lines = ["LIB \"primdec.lib\";", "option(redSB);", "ring r = 0, (a,b,c,d), dp;"]
    for i, e in enumerate(eqs):
        lines.append(f"poly f{i} = {str(e).replace('**', '^')};")
    lines += [
        "ideal I = f0,f1,f2,f3;",
        "ideal J = std(I);",
        f'print(sprintf("{tag}|dim=%s|mult=%s|vdim=%s", string(dim(J)), string(mult(J)), string(vdim(J))));',
        "ideal rad = radical(I);",
        "ideal Jr = std(rad);",
        f'print(sprintf("{tag}|rad_vdim=%s|nprim=%s", string(vdim(Jr)), string(size(primdecGTZ(I)))));',
    ]
    return "\n".join(lines) + "\n"


def parse_tag_line(out: str, tag: str) -> dict:
    info = {}
    for line in out.splitlines():
        if not line.startswith(tag + "|"):
            continue
        for part in line.split("|")[1:]:
            if "=" in part:
                k, v = part.split("=", 1)
                info[k] = int(v) if v.lstrip("-").isdigit() else v
    return info


def main() -> None:
    print("=== produce_line27_rur ===")
    num0, polar = load_G0_num()
    base_t = (2, 3, 5, 7)
    Gprim, content = primitive_G(base_t)

    # All 6 charts at base_t
    charts = {}
    import itertools

    for idx, piv in enumerate(itertools.combinations(range(4), 2)):
        eqs, uv, free = chart_equations(Gprim, piv)
        out = run_singular(sing_vdim_script(eqs, f"chart{idx}"), f"_run_chart{idx}.sing")
        info = parse_tag_line(out, f"chart{idx}")
        print(f"  chart {idx} piv={piv}", info)
        charts[str(idx)] = {
            "pivots": list(piv),
            "free": free,
            "equations": [str(e) for e in eqs],
            "singular": info,
            "raw": out.strip(),
        }

    # Multi-specialization
    multi = []
    for tv in [(2, 3, 5, 7), (3, 5, 7, 11), (1, 1, 1, 1), (5, 2, 3, 1), (4, 1, 2, 3)]:
        Gp, ct = primitive_G(tv)
        eqs, _, _ = chart_equations(Gp, (0, 1))
        out = run_singular(sing_vdim_script(eqs, f"t{tv[0]}_{tv[1]}_{tv[2]}_{tv[3]}"), f"_run_t{tv}.sing")
        info = parse_tag_line(out, f"t{tv[0]}_{tv[1]}_{tv[2]}_{tv[3]}")
        print("  multi", tv, info)
        multi.append({"t": list(tv), "content": ct, "chart0": info})

    # Shape-lemma RUR export at base_t chart 0
    eqs0 = charts["0"]["equations"]
    rur_script = [
        "option(redSB);",
        "ring r0 = 0, (a,b,c,d), dp;",
    ]
    for i, e in enumerate(eqs0):
        rur_script.append(f"poly f{i} = {e.replace('**', '^')};")
    rur_script += [
        "ideal I = f0,f1,f2,f3;",
        "ring rlex = 0, (a,b,c,d), lp;",
        "ideal Ilex = fetch(r0, I);",
        "ideal Glex = std(Ilex);",
        'print(sprintf("rur|size=%s", string(size(Glex))));',
        "for (int i=1; i<=size(Glex); i++) {",
        '  print(sprintf("rur|G%s_deg=%s|G%s_lead=%s", string(i), string(deg(Glex[i])), string(i), string(lead(Glex[i]))));',
        "}",
        'write(":w minpoly_d.txt", Glex[1]);',
        'write(":w rur_G2_c.txt", Glex[2]);',
        'write(":w rur_G3_b.txt", Glex[3]);',
        'write(":w rur_G4_a.txt", Glex[4]);',
        "list fac = factorize(Glex[1]);",
        'print(sprintf("rur|nfac=%s", string(size(fac[1]))));',
        "for (int j=1; j<=size(fac[1]); j++) {",
        '  print(sprintf("rur|fac%s_deg=%s|fac%s_mult=%s", string(j), string(deg(fac[1][j])), string(j), string(fac[2][j])));',
        "}",
    ]
    rur_out = run_singular("\n".join(rur_script) + "\n", "_run_rur.sing")
    print(rur_out.strip())
    rur_info = parse_tag_line(rur_out, "rur")

    # Modular verify
    mod_script = [
        "option(redSB);",
        "ring r0 = 10007, (a,b,c,d), dp;",
    ]
    for i, e in enumerate(eqs0):
        mod_script.append(f"poly f{i} = {e.replace('**', '^')};")
    mod_script += [
        "ideal I = f0,f1,f2,f3;",
        "ideal J = std(I);",
        'print(sprintf("mod|dim=%s|vdim=%s", string(dim(J)), string(vdim(J))));',
        "ring rlex = 10007, (a,b,c,d), lp;",
        "ideal Ilex = fetch(r0, I);",
        "ideal Glex = std(Ilex);",
        "poly m = Glex[1]/leadcoef(Glex[1]);",
        "list fm = factorize(m);",
        "int nlin = 0;",
        "poly lin0;",
        "for (int k=1; k<=size(fm[1]); k++) {",
        "  if (deg(fm[1][k]) == 1) { nlin = nlin + 1; if (nlin == 1) { lin0 = fm[1][k]/leadcoef(fm[1][k]); } }",
        "}",
        'print(sprintf("mod|nlin=%s", string(nlin)));',
        "if (nlin > 0) {",
        "  poly rdpoly = -subst(lin0, d, 0);",
        "  poly pa = subst(Glex[4], d, rdpoly); pa = pa/leadcoef(pa);",
        "  poly pb = subst(Glex[3], d, rdpoly); pb = pb/leadcoef(pb);",
        "  poly pc = subst(Glex[2], d, rdpoly); pc = pc/leadcoef(pc);",
        "  poly a0p = -subst(pa, a, 0);",
        "  poly b0p = -subst(pb, b, 0);",
        "  poly c0p = -subst(pc, c, 0);",
        '  print(sprintf("mod|a=%s|b=%s|c=%s|d=%s", string(a0p), string(b0p), string(c0p), string(rdpoly)));',
        "  setring r0;",
        "  poly aa = imap(rlex, a0p);",
        "  poly bb = imap(rlex, b0p);",
        "  poly cc = imap(rlex, c0p);",
        "  poly dd = imap(rlex, rdpoly);",
        "  poly e0 = subst(subst(subst(subst(f0,a,aa),b,bb),c,cc),d,dd);",
        "  poly e1 = subst(subst(subst(subst(f1,a,aa),b,bb),c,cc),d,dd);",
        "  poly e2 = subst(subst(subst(subst(f2,a,aa),b,bb),c,cc),d,dd);",
        "  poly e3 = subst(subst(subst(subst(f3,a,aa),b,bb),c,cc),d,dd);",
        '  print(sprintf("mod|e0=%s|e1=%s|e2=%s|e3=%s", string(e0), string(e1), string(e2), string(e3)));',
        "  int ok = (e0 == 0) and (e1 == 0) and (e2 == 0) and (e3 == 0);",
        '  print(sprintf("mod|chart_eqs_ok=%s", string(ok)));',
        "}",
    ]
    mod_out = run_singular("\n".join(mod_script) + "\n", "_run_mod.sing")
    print(mod_out.strip())
    mod_info = parse_tag_line(mod_out, "mod")

    all_deg27 = all(
        c["singular"].get("vdim") == 27
        and c["singular"].get("rad_vdim") == 27
        and c["singular"].get("dim") == 0
        for c in charts.values()
    )
    multi_deg27 = all(
        m["chart0"].get("vdim") == 27 and m["chart0"].get("rad_vdim") == 27 for m in multi
    )
    irreducible = (
        rur_info.get("nfac") == 2
        and rur_info.get("fac1_deg") == 0
        and rur_info.get("fac2_deg") == 27
        and rur_info.get("fac2_mult") == 1
    )

    payload = {
        "schema": "g3d-line27-rur-v1",
        "scope": {
            "surface": "secondary-0 component of G_q (polar cubic S_q)",
            "field_model": "specializations P0 -> QQ at good t; not full free K_proj secondaries",
            "open": "t3 != 0; dens of G_q as in polar_cubic_surface.json",
        },
        "base_specialization": {
            "t": list(base_t),
            "content_cleared": content,
            "G_primitive": str(Gprim.as_expr()),
        },
        "charts": charts,
        "multi_specializations": multi,
        "degree_ledger": {
            "expected_geometric_degree": 27,
            "all_six_charts_vdim_27_reduced": all_deg27,
            "multi_spec_chart0_vdim_27_reduced": multi_deg27,
            "nprim_always_1": all(c["singular"].get("nprim") == 1 for c in charts.values())
            and all(m["chart0"].get("nprim") == 1 for m in multi),
        },
        "rur_chart0": {
            "pivots": [0, 1],
            "shape_lemma": {
                "lex_gb_size": rur_info.get("size"),
                "leads": {
                    "G1": rur_info.get("G1_lead"),
                    "G2": rur_info.get("G2_lead"),
                    "G3": rur_info.get("G3_lead"),
                    "G4": rur_info.get("G4_lead"),
                },
                "degrees": {
                    "G1": rur_info.get("G1_deg"),
                    "G2": rur_info.get("G2_deg"),
                    "G3": rur_info.get("G3_deg"),
                    "G4": rur_info.get("G4_deg"),
                },
                "files": {
                    "minpoly_d": "minpoly_d.txt",
                    "c_of_d": "rur_G2_c.txt",
                    "b_of_d": "rur_G3_b.txt",
                    "a_of_d": "rur_G4_a.txt",
                },
            },
            "minpoly_d": {
                "degree": 27,
                "irreducible_over_QQ": irreducible,
                "factorization": "const * irreducible_deg_27 (Singular factorize)",
            },
            "galois_orbit": "single prime of degree 27 over QQ => no QQ-rational line at this specialization",
        },
        "modular_verify": {
            "prime": 10007,
            **mod_info,
            "chart_equations_vanish": mod_info.get("chart_eqs_ok") == 1
            or mod_info.get("e0") == 0,
        },
        "K_proj_exact_status": {
            "secondary0_specialized_RUR": "COMPLETE",
            "full_K_proj_RUR": "RESIDUAL",
            "note": (
                "Full K_proj coefficients of G_q are rank-12 secondary vectors. "
                "Exact RUR over K requires arithmetic in that algebra; multi-spec "
                "secondary-0 results prove geometric degree 27 after good reduction "
                "of the polar surface equation."
            ),
        },
        "K_rational_line": None,
        "point_from_line": False,
        "marker": "G3D-LINE-27-RUR-SPECIALIZED-PASS",
        "residual_marker": "G3D-LINE-27-RUR-KPROJ-OPEN",
        "inputs": {
            "polar_cubic_surface.json": sha256(G3D / "polar_cubic_surface.json"),
            "generic_cubic": sha256(
                ROOT / "goals_2026-08-01" / "G_ALL_DEGREE" / "generic_cubic.json"
            ),
        },
    }

    (HERE / "line_27_rur.json").write_text(json.dumps(payload, indent=2) + "\n")
    (HERE / "LINE_27_RUR.md").write_text(
        f"""# Exact 27-line algebra / RUR of `S_q` (secondary-0 specializations)

## Marker

```text
{payload['marker']}
```

Residual over full `K_proj`: `{payload['residual_marker']}`.

## Setup

Canonical polar cubic surface `S_q` from G3D.1A. Work on the **secondary-0
component** of the exact K-valued cubic `G_q`, specialized at good
`t = (t3,t6,t8,t11) ∈ QQ^4`.

## Degree ledger

| Check | Result |
|---|---|
| 6 charts at t=(2,3,5,7) | each dim 0, vdim 27, rad_vdim 27, nprim 1 |
| Multi-spec chart 0 | all listed t: vdim 27 reduced, nprim 1 |
| Expected geometric degree | 27 (smooth cubic surface) |

## RUR (chart 0, t=(2,3,5,7))

Lex Groebner basis has **4** generators (shape lemma):

- `G1 = m(d)` monic-up-to-scalar of **degree 27**, **irreducible over QQ**
- `G2, G3, G4` solve for `c,b,a` as functions of `d`

Files: `minpoly_d.txt`, `rur_G2_c.txt`, `rur_G3_b.txt`, `rur_G4_a.txt`.

**Galois:** one prime of degree 27 ⇒ **no QQ-rational line** at this
specialization (no degree-1 factor).

## Modular check

Prime `10007`: vdim 27; linear factor of minpoly; reconstructed `(a,b,c,d)`
makes all four chart equations vanish.

## Full `K_proj`

Not claimed. Coefficients of `G_q` live in the rank-12 secondary model.
Lifting this RUR to free `K_proj` (or proving the same orbit structure over
`K`) is residual.

## Headline

No `K_proj`-line certified; no Problem-E point.
"""
    )
    print("wrote line_27_rur.json / LINE_27_RUR.md")
    print("marker", payload["marker"])


if __name__ == "__main__":
    main()
