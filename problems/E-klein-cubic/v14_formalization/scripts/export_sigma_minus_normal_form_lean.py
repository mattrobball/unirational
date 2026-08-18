#!/usr/bin/env python3
"""Emit bounded Lean certificates for the sigma-minus two-point normal form.

The exporter independently reconstructs the four-dimensional ambient carrier,
its first eight restricted Pluecker quadrics, the eight reverse saturation
identities, and the binary quadratic on the resulting projective line.  Every
identity is emitted as a polynomial equality modulo Phi_11 and is checked in a
separate Lean declaration.  No resource-limit options or evaluator escapes are
emitted.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from fractions import Fraction
from pathlib import Path
from typing import Iterable

ROOT = Path(__file__).resolve().parents[1]
SIGMA_JSON = ROOT / "results" / "sigma_normal_form_K.json"
D12_JSON = ROOT / "results" / "d12_lean_K.json"
OUT = ROOT / "V14Formalization"

KDIM = 10
PHI = [Fraction(1)] * 11
MONS = [(0, 0), (0, 1), (0, 2), (0, 3), (1, 1),
        (1, 2), (1, 3), (2, 2), (2, 3), (3, 3)]
PLUCKER = [
    (0, 9, 1, 6, 2, 5), (0, 10, 1, 7, 3, 5),
    (0, 11, 1, 8, 4, 5), (0, 12, 2, 7, 3, 6),
    (0, 13, 2, 8, 4, 6), (0, 14, 3, 8, 4, 7),
    (1, 12, 2, 10, 3, 9), (1, 13, 2, 11, 4, 9),
]


def trim(a: list[Fraction]) -> list[Fraction]:
    while a and a[-1] == 0:
        a.pop()
    return a


def add(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    n = max(len(a), len(b))
    return trim([(a[i] if i < len(a) else 0) +
                 (b[i] if i < len(b) else 0) for i in range(n)])


def neg(a: list[Fraction]) -> list[Fraction]:
    return [-x for x in a]


def sub(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    return add(a, neg(b))


def mul(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    if not a or not b:
        return []
    out = [Fraction(0)] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return trim(out)


def smul(c: Fraction, a: list[Fraction]) -> list[Fraction]:
    return trim([c * x for x in a])


def sum_p(xs: Iterable[list[Fraction]]) -> list[Fraction]:
    out: list[Fraction] = []
    for x in xs:
        out = add(out, x)
    return out


def monomial(n: int, c: Fraction = Fraction(1)) -> list[Fraction]:
    return [Fraction(0)] * n + [c]


def div_exact(a: list[Fraction], b: list[Fraction]) -> list[Fraction]:
    a = trim(a[:])
    b = trim(b[:])
    if not b:
        raise ZeroDivisionError
    q = [Fraction(0)] * max(0, len(a) - len(b) + 1)
    while len(a) >= len(b):
        d = len(a) - len(b)
        c = a[-1] / b[-1]
        q[d] += c
        a = sub(a, mul(monomial(d, c), b))
    if trim(a):
        raise ValueError(f"nonzero remainder: {a}")
    return trim(q)


def reduce_phi(a: list[Fraction]) -> list[Fraction]:
    a = a[:] + [Fraction(0)] * max(0, 19 - len(a))
    for n in range(len(a) - 1, 9, -1):
        c = a[n]
        if c:
            a[n] = 0
            for j in range(n - 10, n):
                a[j] -= c
    return (a[:10] + [Fraction(0)] * 10)[:10]


def kdecode(x) -> list[Fraction]:
    if len(x) != KDIM:
        raise ValueError("expected ten cyclotomic coefficients")
    return [Fraction(int(a), int(b)) for a, b in x]


def kmul(a, b):
    return reduce_phi(mul(a, b))


def kmatmul(a, b):
    return [[reduce_phi(sum_p(mul(a[i][t], b[t][j])
                              for t in range(len(b))))
             for j in range(len(b[0]))] for i in range(len(a))]


def pmatmul(a, b):
    return [[sum_p(mul(a[i][t], b[t][j]) for t in range(len(b)))
             for j in range(len(b[0]))] for i in range(len(a))]


def bilinear_coeff(a, b):
    out = []
    for i, j in MONS:
        if i == j:
            out.append(mul(a[i], b[j]))
        else:
            out.append(add(mul(a[i], b[j]), mul(a[j], b[i])))
    return out


def plucker_coeff(B, q: int):
    p1, p2, p3, p4, p5, p6 = PLUCKER[q]
    x = bilinear_coeff(B[p1], B[p2])
    y = bilinear_coeff(B[p3], B[p4])
    z = bilinear_coeff(B[p5], B[p6])
    return [add(sub(x[m], y[m]), z[m]) for m in range(10)]


def lean_rat(x: Fraction) -> str:
    if x.denominator == 1:
        return str(x.numerator)
    return f"({x.numerator} / {x.denominator} : ℚ)"


def lean_poly(a: list[Fraction]) -> str:
    terms = []
    for i, c in enumerate(trim(a[:])):
        if not c:
            continue
        if i == 0:
            terms.append(f"C ({lean_rat(c)})")
        elif i == 1:
            terms.append(f"C ({lean_rat(c)}) * X")
        else:
            terms.append(f"C ({lean_rat(c)}) * X ^ {i}")
    return " + ".join(terms) if terms else "0"


def emit_matrix(name, rows, r, c):
    lines = []
    for i in range(r):
        lines += [f"def {name}_row{i} : Fin {c} → Polynomial ℚ := fun j =>",
                  "  match j.val with"]
        for j in range(c):
            if trim(rows[i][j][:]):
                lines.append(f"  | {j} => {lean_poly(rows[i][j])}")
        lines += ["  | _ => 0", ""]
    lines += [f"def {name} : Matrix (Fin {r}) (Fin {c}) (Polynomial ℚ) :=",
              "  Matrix.of fun i =>", "    match i.val with"]
    for i in range(r):
        lines.append(f"    | {i} => {name}_row{i}")
    lines += [f"    | _ => {name}_row0", ""]
    return lines


def emit_family(name, rows, r, c):
    lines = []
    for i in range(r):
        lines += [f"def {name}_row{i} : Fin {c} → Polynomial ℚ := fun j =>",
                  "  match j.val with"]
        for j in range(c):
            if trim(rows[i][j][:]):
                lines.append(f"  | {j} => {lean_poly(rows[i][j])}")
        lines += ["  | _ => 0", ""]
    lines += [f"def {name} : Fin {r} → Fin {c} → Polynomial ℚ := fun i =>",
              "  match i.val with"]
    for i in range(r):
        lines.append(f"  | {i} => {name}_row{i}")
    lines += [f"  | _ => {name}_row0", ""]
    return lines


def header():
    sha = hashlib.sha256(SIGMA_JSON.read_bytes()).hexdigest()
    return ["/- Auto-generated by scripts/export_sigma_minus_normal_form_lean.py.",
            f"   Sigma packet SHA256: {sha}",
            "   Stock-limit, kernel-checkable minus normal-form certificates. -/"]


def scalar_helpers():
    lines = [
        "private theorem C_eq_smul_one (a : ℚ) :",
        "    C a = a • (1 : Polynomial ℚ) := by",
        "  rw [Polynomial.smul_eq_C_mul, mul_one]",
        "",
        "private theorem smul_one_sq (a : ℚ) :",
        "    (a • (1 : Polynomial ℚ)) ^ 2 =",
        "      (a * a) • (1 : Polynomial ℚ) := by",
        "  rw [pow_two, smul_mul_assoc, one_mul, smul_smul]",
        "",
    ]
    for n in range(2, 65):
        lines += [f"private theorem nat{n}_as_C : ({n} : Polynomial ℚ) = C {n} :=",
                  f"  (map_natCast C {n}).symm"]
    lines.append("")
    return lines


def scalar_finish():
    ns = ", ".join(f"nat{n}_as_C" for n in range(2, 65))
    return [
        "  all_goals (try simp only [Phi11, Finset.sum_range_succ])",
        "  all_goals (try ring_nf)",
        f"  all_goals (try simp only [{ns},",
        "    C_eq_smul_one, smul_one_sq, smul_mul_assoc, mul_smul_comm,",
        "    one_mul, mul_one, smul_smul])",
        "  all_goals module",
    ]


def linear_finish():
    """Close an already-expanded polynomial identity with no products left."""
    ns = ", ".join(f"nat{n}_as_C" for n in range(2, 65))
    return [
        f"  all_goals (try simp only [{ns},",
        "    C_eq_smul_one, smul_mul_assoc, mul_smul_comm,",
        "    one_mul, mul_one, smul_smul])",
        "  all_goals module",
    ]


def load_data():
    sigma = json.loads(SIGMA_JSON.read_text())
    d12 = json.loads(D12_JSON.read_text())
    kd = lambda M: [[kdecode(x) for x in row] for row in M]
    B = kd(d12["m"]["B15x10"])
    L = kd(d12["m"]["L10x15"])
    Bminus = kd(sigma["eigenspaces"]["Bminus_15x4"])
    Kminus = kmatmul(L, Bminus)
    raw_ambient = pmatmul(B, Kminus)
    if any((raw_ambient[i][j] + [Fraction(0)] * 10)[:10] != Bminus[i][j]
           for i in range(15) for j in range(4)):
        raise ValueError("B*Kminus does not recover Bminus exactly")

    stored_q = sigma["restricted_plucker"]["minus_15_quadrics"]
    Q = []
    raw_Q = []
    for q in range(8):
        row = [[Fraction(0)] * 10 for _ in range(10)]
        for term in stored_q[q]:
            row[MONS.index((int(term["i"]), int(term["j"])))] = kdecode(term["c"])
        raw = plucker_coeff(Bminus, q)
        if [reduce_phi(x) for x in raw] != row:
            raise ValueError(f"restricted quadric {q} mismatch")
        Q.append(row)
        raw_Q.append(raw)

    minus = sigma["minus_component"]
    l1 = minus["linears"]["L1_coeffs_y0y1y2y3"]
    l2 = minus["linears"]["L2_coeffs_y0y1y2y3"]
    a, b, c, d = map(kdecode, (l1[2], l1[3], l2[2], l2[3]))
    if kdecode(l1[0]) != [Fraction(0)] * 10 or kdecode(l1[1])[0] != 1:
        raise ValueError("L1 is not normalized")
    if kdecode(l2[0])[0] != 1 or kdecode(l2[1]) != [Fraction(0)] * 10:
        raise ValueError("L2 is not normalized")

    reverse = []
    for idx, w in enumerate(minus["reverse_direction_identities"]["identities"]):
        if int(w["linear_index"]) != idx // 4 + 1 or int(w["coord_index"]) != idx % 4:
            raise ValueError("reverse identity order mismatch")
        coeff = [kdecode(x) for x in w["coefficients_c_q"][:8]]
        if any(any(v for v in kdecode(x)) for x in w["coefficients_c_q"][8:]):
            raise ValueError("unexpected reverse support beyond q7")
        reverse.append(coeff)

    form = minus["binary_quadratic_f"]
    A, BB, C = map(kdecode, (form["A"], form["B"], form["C"]))
    disc = kdecode(form["disc_B2_minus_4AC"])

    # Fail-close the emitted parametrization and the three pullback coefficients.
    v0 = [neg(c), neg(a), [Fraction(1)], []]
    v1 = [neg(d), neg(b), [], [Fraction(1)]]
    packet_v0 = [kdecode(x) for x in minus["P1_parametrization"]["v0"]]
    packet_v1 = [kdecode(x) for x in minus["P1_parametrization"]["v1"]]
    if [reduce_phi(x) for x in v0] != packet_v0 or [reduce_phi(x) for x in v1] != packet_v1:
        raise ValueError("line parametrization mismatch")
    pull = [[], [], []]
    for qm, (i, j) in zip(Q[0], MONS):
        pull[0] = add(pull[0], mul(qm, mul(v0[i], v0[j])))
        pull[1] = add(pull[1], mul(qm,
            add(mul(v0[i], v1[j]), mul(v1[i], v0[j]))))
        pull[2] = add(pull[2], mul(qm, mul(v1[i], v1[j])))
    if [reduce_phi(x) for x in pull] != [A, BB, C]:
        raise ValueError("reference pullback mismatch")
    raw_disc = sub(mul(BB, BB), smul(Fraction(4), mul(A, C)))
    if reduce_phi(raw_disc) != disc:
        raise ValueError("discriminant mismatch")
    if not any(disc):
        raise ValueError("zero discriminant")
    return Bminus, Q, raw_Q, (a, b, c, d), reverse, (A, BB, C), pull, disc, raw_disc


def emit_data(Bminus, Q, scalars, reverse, form, disc):
    a, b, c, d = scalars
    A, BB, Cc = form
    lines = header() + [
        "import V14Formalization.D12SigmaCarrierPolynomialCore",
        "import V14Formalization.D12SigmaMinusNormalForm",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaMinusNormalFormData",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12SigmaCarrierPolynomial D12SigmaMinusNormalForm",
        "",
    ]
    lines += emit_matrix("Bminus_poly", Bminus, 15, 4)
    lines += emit_family("Qcoeff_poly", Q, 8, 10)
    lines += [
        f"def a_poly : Polynomial ℚ := {lean_poly(a)}",
        f"def b_poly : Polynomial ℚ := {lean_poly(b)}",
        f"def c_poly : Polynomial ℚ := {lean_poly(c)}",
        f"def d_poly : Polynomial ℚ := {lean_poly(d)}",
        f"def A_poly : Polynomial ℚ := {lean_poly(A)}",
        f"def BB_poly : Polynomial ℚ := {lean_poly(BB)}",
        f"def C_poly : Polynomial ℚ := {lean_poly(Cc)}",
        f"def disc_poly : Polynomial ℚ := {lean_poly(disc)}",
        "",
    ]
    lines += emit_family("reverseCoeff_poly", reverse, 8, 8)
    lines += [
        "def evalQuadratic {S : Type*} [CommRing S] [Algebra ℚ S]",
        "    (z : S) (q : Fin 8) (y : Fin 4 → S) : S :=",
        "  quadValue (fun m => evalPolyAt z (Qcoeff_poly q m)) y",
        "",
        "def evalA {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) : S :=",
        "  evalPolyAt z a_poly",
        "def evalB {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) : S :=",
        "  evalPolyAt z b_poly",
        "def evalC {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) : S :=",
        "  evalPolyAt z c_poly",
        "def evalD {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) : S :=",
        "  evalPolyAt z d_poly",
        "def evalBinaryA {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) : S :=",
        "  evalPolyAt z A_poly",
        "def evalBinaryB {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) : S :=",
        "  evalPolyAt z BB_poly",
        "def evalBinaryC {S : Type*} [CommRing S] [Algebra ℚ S] (z : S) : S :=",
        "  evalPolyAt z C_poly",
        "",
        "end V14Formalization.D12SigmaMinusNormalFormData",
        "",
    ]
    (OUT / "D12SigmaMinusNormalFormData.lean").write_text("\n".join(lines))


def emit_ambient():
    lines = header() + [
        "import V14Formalization.D12SigmaMinusNormalFormData",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaMinusAmbient",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12SigmaCarrierPolynomial D12SigmaMinusNormalFormData",
        "open V14Formalization.D12PolyZReflection",
        "",
    ] + scalar_helpers()
    for i in range(15):
        lines += [
            f"private theorem row_{i} (j : Fin 4) :",
            f"    (B_poly * Kminus_poly) ({i} : Fin 15) j = Bminus_poly ({i} : Fin 15) j := by",
            "  fin_cases j <;>",
            "    simp [Matrix.mul_apply, Fin.sum_univ_succ, B_poly, Kminus_poly,",
            "      Kminus_poly_row0, Kminus_poly_row1, Kminus_poly_row2,",
            "      Kminus_poly_row3, Kminus_poly_row4, Kminus_poly_row5,",
            "      Kminus_poly_row6, Kminus_poly_row7, Kminus_poly_row8,",
            f"      Kminus_poly_row9, interpQ, toPolyZ,",
            f"      Bminus_poly, Bminus_poly_row{i}] <;>",
            "    (try norm_num) <;>",
            "    (try ring)",
        ] + linear_finish() + [
            "",
        ]
    lines += [
        "theorem B_mul_Kminus_poly : B_poly * Kminus_poly = Bminus_poly := by",
        "  apply Matrix.ext",
        "  intro i j",
        "  fin_cases i",
    ]
    for i in range(15):
        lines.append(f"  · exact row_{i} j")
    lines += ["", "end V14Formalization.D12SigmaMinusAmbient", ""]
    (OUT / "D12SigmaMinusAmbient.lean").write_text("\n".join(lines))


def emit_quadric(q, raw_Q, Q):
    ns = f"V14Formalization.D12SigmaMinusQuadric{q}"
    used_rows = sorted(set(PLUCKER[q]))
    row_defs = ", ".join(f"Bminus_poly_row{i}" for i in used_rows)
    lines = header() + [
        "import V14Formalization.D12SigmaMinusNormalFormData",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        f"namespace {ns}",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12SigmaMinusNormalForm D12SigmaMinusNormalFormData",
        "",
    ] + scalar_helpers()
    for m in range(10):
        quotient = div_exact(sub(raw_Q[q][m], Q[q][m]), PHI)
        lines += [
            f"def quotient_{m} : Polynomial ℚ := {lean_poly(quotient)}",
            "",
            f"theorem relation_{m} :",
            f"    restrictedPluckerCoeffs Bminus_poly ({q} : Fin 15) ({m} : Fin 10) -",
            f"      Qcoeff_poly ({q} : Fin 8) ({m} : Fin 10) = Phi11 * quotient_{m} := by",
            "  simp only [restrictedPluckerCoeffs, bilinearCoeffs,",
            "    Pi.sub_apply, Pi.add_apply,",
            f"    Bminus_poly, Qcoeff_poly, quotient_{m}]",
            "  norm_num [SchemeGeometry.pluckerRelation]",
            f"  all_goals simp [{row_defs}, Qcoeff_poly_row{q},",
            "    Phi11, Finset.sum_range_succ]",
            "  all_goals norm_num",
            "  all_goals simp only [C_eq_smul_one, smul_mul_assoc,",
            "    one_mul, mul_one, smul_smul]",
            "  all_goals module",
        ] + [
            "",
            f"theorem eval_relation_{m}",
            "    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S)",
            "    (hPhi : evalPolyAt z Phi11 = 0) :",
            f"    evalPolyAt z (restrictedPluckerCoeffs Bminus_poly ({q} : Fin 15) ({m} : Fin 10)) =",
            f"      evalPolyAt z (Qcoeff_poly ({q} : Fin 8) ({m} : Fin 10)) := by",
            f"  have h := congrArg (evalPolyAt z) relation_{m}",
            "  simp only [map_sub, map_mul, hPhi, zero_mul, sub_eq_zero] at h",
            "  exact h",
            "",
        ]
    lines += [
        "theorem plucker_eq_evalQuadratic",
        "    {S : Type*} [Field S] [Algebra ℚ S] (z : S)",
        "    (hPhi : evalPolyAt z Phi11 = 0) (y : Fin 4 → S) :",
        f"    D12Certificate.pluckerValue ((evalMatrixAt z Bminus_poly).mulVec y) ({q} : Fin 15) =",
        f"      evalQuadratic z ({q} : Fin 8) y := by",
        "  rw [← quadValue_restrictedPluckerCoeffs]",
        "  apply congrArg (fun coeff => quadValue coeff y)",
        "  funext m",
        "  change restrictedPluckerCoeffs",
        "      (Bminus_poly.map (evalPolyAt z))",
        f"      ({q} : Fin 15) m = evalPolyAt z (Qcoeff_poly ({q} : Fin 8) m)",
        "  rw [restrictedPluckerCoeffs_map]",
        "  fin_cases m",
    ]
    for m in range(10):
        lines.append(f"  · exact eval_relation_{m} z hPhi")
    lines += ["", f"end {ns}", ""]
    (OUT / f"D12SigmaMinusQuadric{q}.lean").write_text("\n".join(lines))


def target_reverse_coeff(which, j, scalars):
    a, b, c, d = scalars
    lin = [[], [Fraction(1)], a, b] if which == 0 else [[Fraction(1)], [], c, d]
    coord = [[] for _ in range(4)]
    coord[j] = [Fraction(1)]
    return bilinear_coeff(coord, lin)


def emit_reverse(idx, Q, scalars, reverse):
    which, j = idx // 4, idx % 4
    target = target_reverse_coeff(which, j, scalars)
    rhs = [sum_p(mul(reverse[idx][q], Q[q][m]) for q in range(8))
           for m in range(10)]
    ns = f"V14Formalization.D12SigmaMinusReverse{idx}"
    lines = header() + [
        "import V14Formalization.D12SigmaMinusNormalFormData",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        f"namespace {ns}",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12SigmaMinusNormalForm D12SigmaMinusNormalFormData",
        "",
    ] + scalar_helpers()
    lines += [
        "def targetCoeff_poly : Fin 10 → Polynomial ℚ := fun m =>",
        "  match m.val with",
    ]
    for m in range(10):
        if target[m]:
            lines.append(f"  | {m} => {lean_poly(target[m])}")
    lines += ["  | _ => 0", ""]
    for m in range(10):
        products = []
        for q in range(8):
            product = mul(reverse[idx][q], Q[q][m])
            products.append(product)
            lines += [
                f"def product_{m}_{q} : Polynomial ℚ := {lean_poly(product)}",
                "",
                f"theorem product_eq_{m}_{q} :",
                f"    reverseCoeff_poly ({idx} : Fin 8) ({q} : Fin 8) *",
                f"      Qcoeff_poly ({q} : Fin 8) ({m} : Fin 10) = product_{m}_{q} := by",
                "  simp [reverseCoeff_poly,",
                f"    reverseCoeff_poly_row{idx}, Qcoeff_poly,",
                f"    Qcoeff_poly_row{q}, product_{m}_{q}]",
            ] + scalar_finish() + [""]
        quotient = div_exact(sub(target[m], rhs[m]), PHI)
        lines += [
            f"def quotient_{m} : Polynomial ℚ := {lean_poly(quotient)}",
            "",
            f"theorem relation_{m} :",
            f"    targetCoeff_poly ({m} : Fin 10) -",
            f"      (∑ q : Fin 8, reverseCoeff_poly ({idx} : Fin 8) q *",
            f"        Qcoeff_poly q ({m} : Fin 10)) = Phi11 * quotient_{m} := by",
            "  have hsum :",
            f"      (∑ q : Fin 8, reverseCoeff_poly ({idx} : Fin 8) q *",
            f"        Qcoeff_poly q ({m} : Fin 10)) =",
            "      ∑ q : Fin 8, match q.val with",
            f"        | 0 => product_{m}_0",
            f"        | 1 => product_{m}_1",
            f"        | 2 => product_{m}_2",
            f"        | 3 => product_{m}_3",
            f"        | 4 => product_{m}_4",
            f"        | 5 => product_{m}_5",
            f"        | 6 => product_{m}_6",
            f"        | 7 => product_{m}_7",
            "        | _ => 0 := by",
            "    apply Finset.sum_congr rfl",
            "    intro q _",
            "    fin_cases q",
            f"    · exact product_eq_{m}_0",
            f"    · exact product_eq_{m}_1",
            f"    · exact product_eq_{m}_2",
            f"    · exact product_eq_{m}_3",
            f"    · exact product_eq_{m}_4",
            f"    · exact product_eq_{m}_5",
            f"    · exact product_eq_{m}_6",
            f"    · exact product_eq_{m}_7",
            "  rw [hsum]",
            "  simp only [Fin.sum_univ_succ]",
            f"  all_goals simp [targetCoeff_poly, quotient_{m},",
            f"    product_{m}_0, product_{m}_1, product_{m}_2, product_{m}_3,",
            f"    product_{m}_4, product_{m}_5, product_{m}_6, product_{m}_7,",
            "    Phi11, Finset.sum_range_succ]",
        ] + scalar_finish() + [
            "",
            f"theorem eval_relation_{m}",
            "    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S)",
            "    (hPhi : evalPolyAt z Phi11 = 0) :",
            f"    evalPolyAt z (targetCoeff_poly ({m} : Fin 10)) =",
            f"      ∑ q : Fin 8, evalPolyAt z (reverseCoeff_poly ({idx} : Fin 8) q) *",
            f"        evalPolyAt z (Qcoeff_poly q ({m} : Fin 10)) := by",
            f"  have h := congrArg (evalPolyAt z) relation_{m}",
            "  simp only [map_sub, map_sum, map_mul, hPhi, zero_mul, sub_eq_zero] at h",
            "  exact h",
            "",
        ]
    lname = "linearOne (evalA z) (evalB z)" if which == 0 else \
        "linearTwo (evalC z) (evalD z)"
    lines += [
        "theorem identity",
        "    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S)",
        "    (hPhi : evalPolyAt z Phi11 = 0) (y : Fin 4 → S) :",
        f"    y {j} * {lname} y =",
        f"      ∑ q : Fin 8, evalPolyAt z (reverseCoeff_poly ({idx} : Fin 8) q) *",
        "        evalQuadratic z q y := by",
        "  have hcoeff : (fun m : Fin 10 => evalPolyAt z (targetCoeff_poly m)) =",
        f"      (fun m => ∑ q : Fin 8, evalPolyAt z (reverseCoeff_poly ({idx} : Fin 8) q) *",
        "        evalPolyAt z (Qcoeff_poly q m)) := by",
        "    funext m",
        "    fin_cases m",
    ]
    for m in range(10):
        lines.append(f"    · exact eval_relation_{m} z hPhi")
    lines += [
        "  have htarget : (fun m : Fin 10 => evalPolyAt z (targetCoeff_poly m)) =",
        "      bilinearCoeffs (fun i : Fin 4 => if i.val = " + str(j) + " then 1 else 0)",
        ("        ![0, 1, evalA z, evalB z] := by" if which == 0 else
         "        ![1, 0, evalC z, evalD z] := by"),
        "    funext m",
        "    fin_cases m <;>",
        "      simp [targetCoeff_poly, bilinearCoeffs, evalA, evalB, evalC, evalD,",
        "        a_poly, b_poly, c_poly, d_poly, evalPolyAt]",
        "  have hlhs : y " + str(j) + " * " + lname + " y =",
        "      quadValue (fun m : Fin 10 => evalPolyAt z (targetCoeff_poly m)) y := by",
        "    rw [htarget, quadValue_bilinearCoeffs]",
        "    simp [dotProduct, Fin.sum_univ_succ, linearOne, linearTwo] <;>",
        "      ring",
        "  rw [hlhs, hcoeff]",
        "  simp only [evalQuadratic, quadValue, dotProduct, Finset.mul_sum]",
        "  rw [Finset.sum_comm]",
        "  apply Finset.sum_congr rfl",
        "  intro q _",
        "  rw [Finset.sum_mul]",
        "  apply Finset.sum_congr rfl",
        "  intro m _",
        "  ring",
        "",
        f"end {ns}",
        "",
    ]
    (OUT / f"D12SigmaMinusReverse{idx}.lean").write_text("\n".join(lines))


def emit_reference(Q, scalars, form, pull, disc, raw_disc):
    A, BB, Cc = form
    lines = header() + [
        "import V14Formalization.D12SigmaMinusNormalFormData",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaMinusReference",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12SigmaMinusNormalForm D12SigmaMinusNormalFormData",
        "",
    ] + scalar_helpers()

    def emit_mod_relation(prefix, raw_poly, stored_name, quotient):
        terms = [(degree, coeff) for degree, coeff in enumerate(quotient) if coeff]
        out = [
            f"def {prefix}_raw : Polynomial ℚ := {lean_poly(raw_poly)}",
            f"def {prefix}_quotientTerm : Fin {len(terms)} → Polynomial ℚ := fun i =>",
            "  match i.val with",
        ]
        for i, (degree, coeff) in enumerate(terms):
            out.append(f"  | {i} => {lean_poly(monomial(degree, coeff))}")
        out += [
            "  | _ => 0",
            f"def {prefix}_quotient : Polynomial ℚ :=",
            f"  ∑ i : Fin {len(terms)}, {prefix}_quotientTerm i",
            "",
        ]
        products = []
        for i, (degree, coeff) in enumerate(terms):
            product = mul(PHI, monomial(degree, coeff))
            products.append(product)
            out += [
                f"def {prefix}_product_{i} : Polynomial ℚ := {lean_poly(product)}",
                f"theorem {prefix}_product_eq_{i} :",
                f"    Phi11 * {prefix}_quotientTerm ({i} : Fin {len(terms)}) =",
                f"      {prefix}_product_{i} := by",
                f"  simp [{prefix}_quotientTerm, {prefix}_product_{i}]",
            ] + scalar_finish() + [""]
        out += [
            f"theorem {prefix}_relation :",
            f"    {prefix}_raw - {stored_name} =",
            f"      Phi11 * {prefix}_quotient := by",
            f"  rw [{prefix}_quotient, Finset.mul_sum]",
            "  have hsum :",
            f"      (∑ i : Fin {len(terms)}, Phi11 * {prefix}_quotientTerm i) =",
            f"      ∑ i : Fin {len(terms)}, match i.val with",
        ]
        for i in range(len(terms)):
            out.append(f"        | {i} => {prefix}_product_{i}")
        out += [
            "        | _ => 0 := by",
            "    apply Finset.sum_congr rfl",
            "    intro i _",
            "    fin_cases i",
        ]
        for i in range(len(terms)):
            out.append(f"    · exact {prefix}_product_eq_{i}")
        out += [
            "  rw [hsum]",
            "  simp only [Fin.sum_univ_succ]",
            f"  simp [{prefix}_raw, {stored_name},",
        ]
        for i in range(0, len(products), 5):
            suffix = "," if i + 5 < len(products) else "]"
            out.append("    " + ", ".join(
                f"{prefix}_product_{j}" for j in range(i, min(i + 5, len(products)))) + suffix)
        out += linear_finish() + [""]
        return out

    names = ["A", "B", "C"]
    stored = [A, BB, Cc]
    for i in range(3):
        quotient = div_exact(sub(pull[i], stored[i]), PHI)
        prefix = f"pullback_{names[i]}"
        lines += emit_mod_relation(
            prefix, pull[i], ['A_poly', 'BB_poly', 'C_poly'][i], quotient) + [
            "",
            f"theorem eval_pullback_{names[i]}",
            "    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S)",
            "    (hPhi : evalPolyAt z Phi11 = 0) :",
            f"    evalPolyAt z pullback_{names[i]}_raw =",
            f"      evalPolyAt z {['A_poly','BB_poly','C_poly'][i]} := by",
            f"  have h := congrArg (evalPolyAt z) pullback_{names[i]}_relation",
            "  simp only [map_sub, map_mul, hPhi, zero_mul, sub_eq_zero] at h",
            "  exact h",
            "",
        ]
    dq = div_exact(sub(raw_disc, disc), PHI)
    lines += emit_mod_relation("disc", raw_disc, "disc_poly", dq) + [
        "theorem pullback_A_raw_eq :",
        "    pullback_A_raw =",
        "      linePullbackA (Qcoeff_poly 0) a_poly c_poly := by",
        "  simp [pullback_A_raw, linePullbackA, Qcoeff_poly, Qcoeff_poly_row0,",
        "    a_poly, c_poly]",
    ] + scalar_finish() + [
        "",
        "theorem pullback_B_raw_eq :",
        "    pullback_B_raw =",
        "      linePullbackB (Qcoeff_poly 0) a_poly b_poly c_poly d_poly := by",
        "  simp [pullback_B_raw, linePullbackB, Qcoeff_poly, Qcoeff_poly_row0,",
        "    a_poly, b_poly, c_poly, d_poly]",
    ] + scalar_finish() + [
        "",
        "theorem pullback_C_raw_eq :",
        "    pullback_C_raw =",
        "      linePullbackC (Qcoeff_poly 0) b_poly d_poly := by",
        "  simp [pullback_C_raw, linePullbackC, Qcoeff_poly, Qcoeff_poly_row0,",
        "    b_poly, d_poly]",
    ] + scalar_finish() + [
        "",
        "theorem pullback",
        "    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S)",
        "    (hPhi : evalPolyAt z Phi11 = 0) (s t : S) :",
        "    evalQuadratic z 0 (lineParam (evalA z) (evalB z) (evalC z) (evalD z) s t) =",
        "      binaryQuadratic (evalBinaryA z) (evalBinaryB z) (evalBinaryC z) s t := by",
        "  unfold evalQuadratic",
        "  rw [quadValue_lineParam]",
        "  have hA := congrArg (evalPolyAt z) pullback_A_raw_eq",
        "  have hB := congrArg (evalPolyAt z) pullback_B_raw_eq",
        "  have hC := congrArg (evalPolyAt z) pullback_C_raw_eq",
        "  simp only [linePullbackA, linePullbackB, linePullbackC, map_add, map_sub,",
        "    map_mul, map_pow, map_ofNat, evalA, evalB, evalC, evalD] at hA hB hC",
        "  simp only [linePullbackA, linePullbackB, linePullbackC,",
        "    evalA, evalB, evalC, evalD]",
        "  rw [← hA, ← hB, ← hC, eval_pullback_A z hPhi,",
        "    eval_pullback_B z hPhi, eval_pullback_C z hPhi]",
        "  rfl",
        "",
        "theorem disc_raw_eq : disc_raw = BB_poly ^ 2 - 4 * A_poly * C_poly := by",
        "  simp [disc_raw, A_poly, BB_poly, C_poly]",
    ] + scalar_finish() + [
        "",
        "theorem eval_disc",
        "    {S : Type*} [CommRing S] [Algebra ℚ S] (z : S)",
        "    (hPhi : evalPolyAt z Phi11 = 0) :",
        "    evalBinaryB z ^ 2 - 4 * evalBinaryA z * evalBinaryC z =",
        "      evalPolyAt z disc_poly := by",
        "  have h := congrArg (evalPolyAt z) disc_relation",
        "  simp only [map_sub, map_mul, hPhi, zero_mul, sub_eq_zero] at h",
        "  rw [← h]",
        "  rw [disc_raw_eq]",
        "  simp only [map_sub, map_mul, map_pow, map_ofNat, evalBinaryA,",
        "    evalBinaryB, evalBinaryC]",
        "",
        "theorem eval_disc_K_ne_zero : evalPolyAt WeilRep.ζ disc_poly ≠ 0 := by",
        "  change Polynomial.aeval WeilRep.ζ disc_poly ≠ 0",
        "  intro hzero",
        "  have hne : disc_poly ≠ 0 := by",
        "    intro h",
        "    have hc := congrArg (fun p : Polynomial ℚ => p.coeff 0) h",
        "    norm_num [disc_poly, coeff_one] at hc",
        "  have hdeg : disc_poly.natDegree < WeilRep.Φ11.natDegree := by",
        "    rw [WeilRep.Φ11_natDegree]",
        "    have hle : disc_poly.natDegree ≤ 9 :=",
        "        natDegree_le_iff_coeff_eq_zero.mpr (by",
        "      intro n hn",
        "      have h0 : n ≠ 0 := by omega",
        "      have h1 : n ≠ 1 := by omega",
        "      have h2 : n ≠ 2 := by omega",
        "      have h3 : n ≠ 3 := by omega",
        "      have h4 : n ≠ 4 := by omega",
        "      have h5 : n ≠ 5 := by omega",
        "      have h6 : n ≠ 6 := by omega",
        "      have h7 : n ≠ 7 := by omega",
        "      have h8 : n ≠ 8 := by omega",
        "      have h9 : n ≠ 9 := by omega",
        "      simp [disc_poly, h0, h1, h2, h3, h4, h5, h6, h7, h8, h9,",
        "        coeff_C, coeff_X])",
        "    omega",
        "  apply AdjoinRoot.mk_ne_zero_of_natDegree_lt WeilRep.Φ11_monic",
        "    hne hdeg",
        "  rw [← AdjoinRoot.aeval_eq (f := WeilRep.Φ11) disc_poly]",
        "  exact hzero",
        "",
        "end V14Formalization.D12SigmaMinusReference",
        "",
    ]
    (OUT / "D12SigmaMinusReference.lean").write_text("\n".join(lines))


def emit_concrete():
    lines = [
        "/-",
        "Copyright (c) 2026 V14Formalization contributors.",
        "Released under Apache 2.0 license.",
        "-/",
        "import V14Formalization.D12SigmaCarrierConcrete",
        "import V14Formalization.D12SigmaMinusAmbient",
    ]
    for q in range(8):
        lines.append(f"import V14Formalization.D12SigmaMinusQuadric{q}")
    for i in range(8):
        lines.append(f"import V14Formalization.D12SigmaMinusReverse{i}")
    lines += [
        "import V14Formalization.D12SigmaMinusReference",
        "import V14Formalization.D12U6PolynomialSeal",
        "",
        "noncomputable section",
        "open Matrix Polynomial",
        "namespace V14Formalization.D12SigmaMinusConcrete",
        "open D12PolynomialData D12PolynomialEvaluation",
        "open D12SigmaCarrier D12SigmaCarrierPolynomial D12SigmaCarrierConcrete",
        "open D12SigmaMinusNormalForm D12SigmaMinusNormalFormData",
        "",
        "theorem evalMatrixK_Bminus_poly :",
        "    evalMatrixK Bminus_poly = D12SigmaCarrierConcrete.core.Bminus := by",
        "  rw [← D12SigmaMinusAmbient.B_mul_Kminus_poly]",
        "  change evalMatrixAt WeilRep.ζ (B_poly * Kminus_poly) = _",
        "  rw [evalMatrixAt_mul]",
        "  rfl",
        "",
        "theorem plucker_eq_evalQuadratic",
        "    {S : Type*} [Field S] [Algebra ℚ S] (z : S)",
        "    (hPhi : evalPolyAt z Phi11 = 0) (q : Fin 8) (y : Fin 4 → S) :",
        "    D12Certificate.pluckerValue ((evalMatrixAt z Bminus_poly).mulVec y)",
        "        ⟨q.val, by omega⟩ = evalQuadratic z q y := by",
        "  fin_cases q",
    ]
    for q in range(8):
        lines.append(f"  · exact D12SigmaMinusQuadric{q}.plucker_eq_evalQuadratic z hPhi y")
    lines += [
        "",
        "theorem linears_zero_of_quadrics",
        "    {S : Type*} [Field S] [Algebra ℚ S] (z : S)",
        "    (hPhi : evalPolyAt z Phi11 = 0) {y : Fin 4 → S} (hy : y ≠ 0)",
        "    (hQ : ∀ q : Fin 8, evalQuadratic z q y = 0) :",
        "    linearOne (evalA z) (evalB z) y = 0 ∧",
        "      linearTwo (evalC z) (evalD z) y = 0 := by",
        "  have hj : ∃ j : Fin 4, y j ≠ 0 := by",
        "    by_contra h",
        "    push_neg at h",
        "    exact hy (funext h)",
        "  obtain ⟨j, hj⟩ := hj",
        "  have h1j : y j * linearOne (evalA z) (evalB z) y = 0 := by",
        "    have hjv := j.isLt",
        "    interval_cases hv : j.val",
    ]
    for j in range(4):
        lines += [
            f"    · have : j = {j} := Fin.ext hv",
            "      subst this",
            f"      rw [D12SigmaMinusReverse{j}.identity z hPhi y]",
            "      simp [hQ]",
        ]
    lines += [
        "  have h2j : y j * linearTwo (evalC z) (evalD z) y = 0 := by",
        "    have hjv := j.isLt",
        "    interval_cases hv : j.val",
    ]
    for j in range(4):
        lines += [
            f"    · have : j = {j} := Fin.ext hv",
            "      subst this",
            f"      rw [D12SigmaMinusReverse{4+j}.identity z hPhi y]",
            "      simp [hQ]",
        ]
    lines += [
        "  exact ⟨(mul_eq_zero.mp h1j).resolve_left hj,",
        "    (mul_eq_zero.mp h2j).resolve_left hj⟩",
        "",
        "/-- Every nonzero common Plücker zero in the concrete minus carrier",
        "lies on the emitted projective line and satisfies its binary quadratic. -/",
        "theorem common_plucker_zero_parametric",
        "    (S : Type*) [Field S] [Algebra ℚ S] [Algebra WeilRep.K S]",
        "    [IsScalarTower ℚ WeilRep.K S] {y : Fin 4 → S} (hy : y ≠ 0)",
        "    (hQ : ∀ q : Fin 15, D12Certificate.pluckerValue",
        "      (((D12SigmaCarrierConcrete.core.Bminus).map",
        "        (algebraMap WeilRep.K S)).mulVec y) q = 0) :",
        "    y = lineParam",
        "        (evalA ((algebraMap WeilRep.K S) WeilRep.ζ))",
        "        (evalB ((algebraMap WeilRep.K S) WeilRep.ζ))",
        "        (evalC ((algebraMap WeilRep.K S) WeilRep.ζ))",
        "        (evalD ((algebraMap WeilRep.K S) WeilRep.ζ)) (y 2) (y 3) ∧",
        "      binaryQuadratic",
        "        (evalBinaryA ((algebraMap WeilRep.K S) WeilRep.ζ))",
        "        (evalBinaryB ((algebraMap WeilRep.K S) WeilRep.ζ))",
        "        (evalBinaryC ((algebraMap WeilRep.K S) WeilRep.ζ)) (y 2) (y 3) = 0 ∧",
        "      evalBinaryB ((algebraMap WeilRep.K S) WeilRep.ζ) ^ 2 -",
        "          4 * evalBinaryA ((algebraMap WeilRep.K S) WeilRep.ζ) *",
        "            evalBinaryC ((algebraMap WeilRep.K S) WeilRep.ζ) ≠ 0 := by",
        "  let z : S := (algebraMap WeilRep.K S) WeilRep.ζ",
        "  have hPhi : evalPolyAt z Phi11 = 0 := by",
        "    rw [evalPolyAt_extension_eq_map_evalPolyAt,",
        "      D12U6PolynomialSeal.evalPhi11_ζ, map_zero]",
        "  have hB : evalMatrixAt z Bminus_poly =",
        "      (D12SigmaCarrierConcrete.core.Bminus).map",
        "        (algebraMap WeilRep.K S) := by",
        "    rw [evalMatrixAt_extension_eq_map_evalMatrixK, evalMatrixK_Bminus_poly]",
        "  have hQ8 : ∀ q : Fin 8, evalQuadratic z q y = 0 := by",
        "    intro q",
        "    rw [← plucker_eq_evalQuadratic z hPhi q y, hB]",
        "    exact hQ ⟨q.val, by omega⟩",
        "  have hlin := linears_zero_of_quadrics z hPhi hy hQ8",
        "  have hparam := commonZero_parametric",
        "    (fun q => fun m => evalPolyAt z (Qcoeff_poly q m))",
        "    (evalA z) (evalB z) (evalC z) (evalD z)",
        "    (evalBinaryA z) (evalBinaryB z) (evalBinaryC z)",
        "    (fun _ => hlin) (D12SigmaMinusReference.pullback z hPhi) hQ8",
        "  refine ⟨hparam.1, hparam.2, ?_⟩",
        "  rw [D12SigmaMinusReference.eval_disc z hPhi,",
        "    evalPolyAt_extension_eq_map_evalPolyAt]",
        "  exact (map_ne_zero_iff (algebraMap WeilRep.K S)",
        "    (algebraMap WeilRep.K S).injective).2",
        "    D12SigmaMinusReference.eval_disc_K_ne_zero",
        "",
        "end V14Formalization.D12SigmaMinusConcrete",
        "",
    ]
    (OUT / "D12SigmaMinusConcrete.lean").write_text("\n".join(lines))


def main():
    global OUT
    parser = argparse.ArgumentParser()
    parser.add_argument("--out-dir", type=Path, default=None,
                        help="Directory that receives every generated Lean file")
    args = parser.parse_args()
    if args.out_dir is not None:
        OUT = args.out_dir.resolve()
        OUT.mkdir(parents=True, exist_ok=True)
    Bminus, Q, raw_Q, scalars, reverse, form, pull, disc, raw_disc = load_data()
    emit_data(Bminus, Q, scalars, reverse, form, disc)
    emit_ambient()
    for q in range(8):
        emit_quadric(q, raw_Q, Q)
    for idx in range(8):
        emit_reverse(idx, Q, scalars, reverse)
    emit_reference(Q, scalars, form, pull, disc, raw_disc)
    emit_concrete()


if __name__ == "__main__":
    main()
    __import__("sys").path.insert(0, __import__("os").path.dirname(__import__("os").path.abspath(__file__)))
    from module_annotation_hook import reapply_module_annotations
    reapply_module_annotations()
