#!/usr/bin/env python3
"""Emit Lean ofLadj identities for A*Fu+B*Fv+C*Fw = 1 on each affine chart."""
from __future__ import annotations

import sys
from fractions import Fraction
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import export_sigma_plus_identities as g
import export_sigma_plus_smooth_lean as sm

ROOT = Path(__file__).resolve().parents[1]
JSON_PATH = ROOT / "results" / "sigma_plus_segre_Ki.json"
OUT = ROOT / "V14Formalization"

# Fplus monomials (e0,e1,e2) and Lean suffix
FMONS = {
    (3, 0, 0): "000",
    (2, 1, 0): "001",
    (2, 0, 1): "002",
    (1, 2, 0): "011",
    (1, 1, 1): "012",
    (1, 0, 2): "022",
    (0, 3, 0): "111",
    (0, 2, 1): "112",
    (0, 1, 2): "122",
    (0, 0, 3): "222",
}

# pderiv 0 of X0^a X1^b X2^c is a * X0^(a-1) X1^b X2^c
# After U=1, remaining (b,c) with coefficient a * c_{a,b,c}


def header(extra):
    return [
        "/-",
        "Auto-generated Fplus chart Bézout product identities.",
        "-/",
        "import V14Formalization.D12SigmaPlusSegreEval",
        "import V14Formalization.D12SigmaPlusSegreSmoothU",
        "import V14Formalization.D12SigmaPlusSegreSmoothV",
        "import V14Formalization.D12SigmaPlusSegreSmoothW",
        *extra,
        "",
        "noncomputable section",
        "open Polynomial",
        "namespace V14Formalization.D12SigmaPlusSegreCore",
        "open D12PolynomialData",
        "",
    ]


def footer():
    return ["end V14Formalization.D12SigmaPlusSegreCore", ""]


def emit_mul(prefix, A_re, A_im, A_nm, B_re, B_im, B_nm, pre, pim):
    lines = [
        f"def {prefix}_pre : Polynomial ℚ := {g.lean_poly(pre)}",
        f"def {prefix}_pim : Polynomial ℚ := {g.lean_poly(pim)}",
        f"theorem {prefix}_pre_eq :",
        f"    {A_re} * {B_re} - {A_im} * {B_im} = {prefix}_pre := by",
        "  refine Polynomial.funext fun r => ?_",
        f"  simp only [{A_re}, {A_im}, {B_re}, {B_im}, {prefix}_pre]",
        "  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,",
        "    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,",
        "    Polynomial.eval_neg, Polynomial.eval_zero]",
        "  try ring",
        f"theorem {prefix}_pim_eq :",
        f"    {A_re} * {B_im} + {A_im} * {B_re} = {prefix}_pim := by",
        "  refine Polynomial.funext fun r => ?_",
        f"  simp only [{A_re}, {A_im}, {B_re}, {B_im}, {prefix}_pim]",
        "  simp [Polynomial.eval_add, Polynomial.eval_sub, Polynomial.eval_mul,",
        "    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow,",
        "    Polynomial.eval_neg, Polynomial.eval_zero]",
        "  try ring",
        f"theorem {prefix}_mul : {A_nm} * {B_nm} = ofLadj {prefix}_pre {prefix}_pim := by",
        f"  rw [{A_nm}, {B_nm}, ofLadj_mul, {prefix}_pre_eq, {prefix}_pim_eq]",
        "",
    ]
    return lines


def scale_cell(cell, n: int):
    return ([n * x for x in cell[0]], [n * x for x in cell[1]])


def main():
    data = sm.json.loads(JSON_PATH.read_text())
    F = sm.Fplus_from_json(data)
    dF = [sm.pderiv(F, i) for i in range(3)]
    # Fplus Lean names
    Fc = {}
    for e, suf in FMONS.items():
        Fc[e] = (
            f"Fplus_re_{suf}",
            f"Fplus_im_{suf}",
            f"ofLadj Fplus_re_{suf} Fplus_im_{suf}",
        )

    names = ["U", "V", "W"]
    for ch, name in enumerate(names):
        Fu = sm.restrict(dF[0], ch)
        Fv = sm.restrict(dF[1], ch)
        Fw = sm.restrict(dF[2], ch)
        print(f"solving {name}", flush=True)
        A, B, C = sm.solve_affine_bezout(Fu, Fv, Fw)
        # Affine partials as (mon -> (cell, lean_re, lean_im, lean_val, scale_already_in_cell))
        # Rebuild affine partials from Fplus coeffs with explicit scales so Lean names match.
        others = [i for i in range(3) if i != ch]
        partials = []
        for pidx, (P, tag) in enumerate(((A, f"{name}A"), (B, f"{name}B"), (C, f"{name}C"))):
            # Affine pderiv of variable pidx after chart subst
            aff = {}
            for e, cellkv in F.items():
                if e[pidx] == 0:
                    continue
                scale = e[pidx]
                ne = list(e)
                ne[pidx] -= 1
                # remaining powers of the two affine vars
                mon = (ne[others[0]], ne[others[1]])
                # cell * scale
                sc = cellkv.scale(Fraction(scale))
                aff[mon] = aff.get(mon, sm.KiVec()) + sc
            partials.append((P, tag, aff, f"pderiv {pidx}"))

        lines = header([])
        # Emit products tag_ij * Fplus coeff pieces appearing in aff
        # For each A monomial and each Fu monomial, product.
        acc = {}  # out mon -> list of (prefix, sgn already in cell)
        pid = 0
        for P, tag, aff, _ in partials:
            for am, akv in P.items():
                anm = f"{tag}_{am[0]}_{am[1]}"
                for fm, fkv in aff.items():
                    om = (am[0] + fm[0], am[1] + fm[1])
                    pre, pim = g.lmul_raw(akv.to_cell(), fkv.to_cell())
                    prefix = f"{name}P{pid}"
                    pid += 1
                    # Find a Lean name for fkv. It is a Z-linear combo of Fplus coeffs.
                    # Emit fkv as its own ofLadj from the computed cell, and prove later
                    # via the eval_pderiv lemmas. For the combination identity we only
                    # need A*Fu as numbers.
                    fre, fim = f"{prefix}_Fre", f"{prefix}_Fim"
                    lines += [
                        f"def {fre} : Polynomial ℚ := {g.lean_poly(fkv.to_cell()[0])}",
                        f"def {fim} : Polynomial ℚ := {g.lean_poly(fkv.to_cell()[1])}",
                        f"def {prefix}_F : Ki := ofLadj {fre} {fim}",
                    ]
                    lines += emit_mul(
                        prefix,
                        f"{anm}_re",
                        f"{anm}_im",
                        anm,
                        fre,
                        fim,
                        f"{prefix}_F",
                        pre,
                        pim,
                    )
                    acc.setdefault(om, []).append(prefix)

        # Sum products per output monomial and reduce mod Phi11
        const_ok = False
        for om, prefs in sorted(acc.items()):
            acc_re, acc_im = [], []
            for prefix in prefs:
                # read back from generated defs is hard; recompute
                pass
        # Recompute sums from Python
        total = {}
        for P, tag, aff, _ in partials:
            prod = sm.eval_poly(P, aff)
            for m, c in prod.items():
                total[m] = total.get(m, sm.KiVec()) + c
        one = sm.KiVec([Fraction(1)], [])
        leftover = {m: c for m, c in total.items() if not (
            (m == (0, 0) and c.coords() == one.coords()) or c.is_zero()
        )}
        if leftover:
            raise SystemExit(f"{name}: leftover { {m: c.coords()[:4] for m,c in leftover.items()} }")
        if total.get((0, 0), sm.KiVec()).coords() != one.coords():
            raise SystemExit(f"{name}: constant not 1")
        path = OUT / f"D12SigmaPlusSegreSmooth{name}Prod.lean"
        path.write_text("\n".join(lines + footer()))
        print("wrote", path.name, "products", pid)


if __name__ == "__main__":
    main()
