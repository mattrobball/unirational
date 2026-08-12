#!/usr/bin/env python3
"""Solve affine chart Bézout identities for Fplus and emit Lean shards.

For each chart U=1, V=1, W=1, find A,B,C in Ki[X,Y] of degree ≤2 such that
  A*Fu + B*Fv + C*Fw = 1
after substituting the chart coordinate to 1.  Coefficients are proved by
the same Polynomial.funext / eval / ring pattern as the plus Segre packet.
"""
from __future__ import annotations

import argparse
import json
import sys
from fractions import Fraction
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
import export_sigma_plus_identities as g

JSON_PATH = ROOT / "results" / "sigma_plus_segre_Ki.json"

# Affine monomials of degree ≤ 2 and ≤ 4 in two variables.
AFF2 = [(0, 0), (1, 0), (0, 1), (2, 0), (1, 1), (0, 2)]
AFF4 = [
    (i, j) for i in range(5) for j in range(5 - i)
]


def lzero():
    return ([], [])


def ladd(x, y):
    return (g.add(x[0], y[0]), g.add(x[1], y[1]))


def lneg(x):
    return (g.neg(x[0]), g.neg(x[1]))


def lmul(x, y):
    return g.lmul_raw(x, y)


def lscale(c: Fraction, x):
    return ([c * a for a in x[0]], [c * a for a in x[1]])


def reduce_cell(x):
    return (g.reduce_phi(x[0]), g.reduce_phi(x[1]))


class KiVec:
    """Q-vector of dimension 20: re[0..9] + im[0..9], already reduced mod Φ11."""

    def __init__(self, re=None, im=None):
        self.re = (list(re or []) + [Fraction(0)] * 10)[:10]
        self.im = (list(im or []) + [Fraction(0)] * 10)[:10]

    @classmethod
    def from_cell(cls, cell):
        re, im = reduce_cell(cell)
        return cls(re, im)

    def to_cell(self):
        return (g.trim(self.re), g.trim(self.im))

    def coords(self):
        return self.re + self.im

    @classmethod
    def from_coords(cls, cs):
        return cls(cs[:10], cs[10:])

    def __add__(self, other):
        return KiVec(
            [a + b for a, b in zip(self.re, other.re)],
            [a + b for a, b in zip(self.im, other.im)],
        )

    def __mul__(self, other):
        return KiVec.from_cell(lmul(self.to_cell(), other.to_cell()))

    def scale(self, c: Fraction):
        return KiVec([c * a for a in self.re], [c * a for a in self.im])

    def is_zero(self):
        return all(x == 0 for x in self.coords())


def rref_fraction(A):
    """Row-reduce A in place over Q. A is list of lists (rows). Returns pivots."""
    n = len(A)
    m = len(A[0])
    pivots = []
    r = 0
    for c in range(m):
        p = None
        for i in range(r, n):
            if A[i][c] != 0:
                p = i
                break
        if p is None:
            continue
        A[r], A[p] = A[p], A[r]
        inv = Fraction(1) / A[r][c]
        A[r] = [inv * x for x in A[r]]
        for i in range(n):
            if i != r and A[i][c] != 0:
                q = A[i][c]
                A[i] = [A[i][j] - q * A[r][j] for j in range(m)]
        pivots.append(c)
        r += 1
        if r == n:
            break
    return pivots


def solve_affine_bezout(Fu, Fv, Fw):
    """Fu,Fv,Fw are dicts (i,j) -> KiVec, affine polynomials degree ≤2.

    Find A,B,C degree ≤2 with A*Fu+B*Fv+C*Fw = 1.
    """
    # unknowns: 3 * len(AFF2) KiVecs = 3*6*20 = 360 Q-coordinates
    n_poly = 3 * len(AFF2)
    n_unk = n_poly * 20
    # equations: each AFF4 monomial, 20 coords
    n_eq = len(AFF4) * 20
    # matrix n_eq x (n_unk+1)
    M = [[Fraction(0)] * (n_unk + 1) for _ in range(n_eq)]

    def put(eq_mon, eq_coord, unk_poly, unk_coord, val):
        M[eq_mon * 20 + eq_coord][unk_poly * 20 + unk_coord] += val

    Fs = [Fu, Fv, Fw]
    for fidx, F in enumerate(Fs):
        for aidx, (ai, aj) in enumerate(AFF2):
            pidx = fidx * len(AFF2) + aidx
            for (bi, bj), coeff in F.items():
                oi, oj = ai + bi, aj + bj
                if (oi, oj) not in AFF4:
                    continue
                eidx = AFF4.index((oi, oj))
                # coeff is KiVec: product of unknown Ki * coeff
                # (x_re + i x_im)(c_re + i c_im) =
                # (x_re c_re - x_im c_im) + i (x_re c_im + x_im c_re)
                cre, cim = coeff.re, coeff.im
                for k in range(10):
                    # x_re[k] contributes cre shifted by z^k, -cim to im... 
                    # we work already reduced: treat basis e_k * (cre + i cim)
                    # Too coarse: multiplication is polynomial mul then reduce.
                    pass
            # Better: for each standard basis vector of the unknown, multiply.
        # We'll fill by basis actions below.

    # Rebuild by basis:
    M = [[Fraction(0)] * (n_unk + 1) for _ in range(n_eq)]
    for fidx, F in enumerate(Fs):
        for aidx in range(len(AFF2)):
            pidx = fidx * len(AFF2) + aidx
            for b in range(20):
                basis = [Fraction(0)] * 20
                basis[b] = Fraction(1)
                unk = KiVec.from_coords(basis)
                # product unk * F, shifted by AFF2[aidx]
                ai, aj = AFF2[aidx]
                for (bi, bj), coeff in F.items():
                    prod = unk * coeff
                    oi, oj = ai + bi, aj + bj
                    if (oi, oj) not in AFF4:
                        if not prod.is_zero():
                            raise SystemExit(f"degree overflow {oi},{oj}")
                        continue
                    eidx = AFF4.index((oi, oj))
                    pcs = prod.coords()
                    for c in range(20):
                        M[eidx * 20 + c][pidx * 20 + b] += pcs[c]

    # RHS = 1 at monomial (0,0)
    one = KiVec([Fraction(1)], [])
    e0 = AFF4.index((0, 0))
    for c, val in enumerate(one.coords()):
        M[e0 * 20 + c][-1] = val

    pivots = rref_fraction(M)
    # check consistency
    for row in M:
        if all(x == 0 for x in row[:-1]) and row[-1] != 0:
            raise SystemExit("Bézout system inconsistent")
    sol = [Fraction(0)] * n_unk
    for row, piv in zip(M, pivots):
        if piv < n_unk:
            sol[piv] = row[-1]
    # decode A,B,C
    out = []
    for fidx in range(3):
        poly = {}
        for aidx, mon in enumerate(AFF2):
            pidx = fidx * len(AFF2) + aidx
            coords = sol[pidx * 20:(pidx + 1) * 20]
            kv = KiVec.from_coords(coords)
            if not kv.is_zero():
                poly[mon] = kv
        out.append(poly)
    return out


def eval_poly(P, F):
    """Multiply two affine dicts."""
    acc = {}
    for m1, c1 in P.items():
        for m2, c2 in F.items():
            m = (m1[0] + m2[0], m1[1] + m2[1])
            acc[m] = acc.get(m, KiVec()) + (c1 * c2)
    return acc


def Fplus_from_json(data):
    mons = [tuple(m) for m in data["plane_cubic_F_u"]["monomial_order"]]
    coeffs = [g.ldec(c) for c in data["plane_cubic_F_u"]["coefficients"]]
    # monoms are sorted triples (a<=b<=c) counting variable indices.
    # Reconstruct homogeneous cubic: map (n0,n1,n2) powers.
    F = {}  # (e0,e1,e2) -> KiVec
    for mon, cell in zip(mons, coeffs):
        e = [0, 0, 0]
        for idx in mon:
            e[idx] += 1
        F[tuple(e)] = KiVec.from_cell(cell)
    return F


def pderiv(F, var):
    out = {}
    for e, c in F.items():
        if e[var] == 0:
            continue
        ne = list(e)
        k = ne[var]
        ne[var] -= 1
        out[tuple(ne)] = c.scale(Fraction(k))
    return out


def restrict(F, chart):
    """Substitute X_chart = 1, return affine in the other two vars."""
    others = [i for i in range(3) if i != chart]
    acc = {}
    for e, c in F.items():
        mon = (e[others[0]], e[others[1]])
        acc[mon] = acc.get(mon, KiVec()) + c
    return acc


def lean_cell(cell):
    re, im = cell
    return g.lean_poly(re), g.lean_poly(im)


def emit_chart(name: str, A, B, C, Fu, Fv, Fw) -> list[str]:
    """Emit coefficientwise identity A*Fu+B*Fv+C*Fw = 1."""
    # verify
    acc = {}
    for P, F in ((A, Fu), (B, Fv), (C, Fw)):
        prod = eval_poly(P, F)
        for m, c in prod.items():
            acc[m] = acc.get(m, KiVec()) + c
    for m, c in acc.items():
        if m == (0, 0):
            if c.coords() != KiVec([Fraction(1)], []).coords():
                raise SystemExit(f"{name}: constant term {c.coords()}")
        elif not c.is_zero():
            raise SystemExit(f"{name}: leftover monomial {m} {c.coords()}")

    lines = [
        "/-",
        f"Auto-generated Fplus smoothness Bézout identity on chart {name}.",
        "-/",
        "import V14Formalization.D12SigmaPlusSegreEval",
        "import V14Formalization.D12SigmaPlusSegreCore",
        "",
        "noncomputable section",
        "open Matrix Polynomial MvPolynomial",
        "namespace V14Formalization.D12SigmaPlusSegreCore",
        "open D12PolynomialData",
        "",
    ]
    def emit_poly(tag, P):
        for (i, j), kv in sorted(P.items()):
            re, im = lean_cell(kv.to_cell())
            lines.append(f"def {tag}_{i}_{j}_re : Polynomial ℚ := {re}")
            lines.append(f"def {tag}_{i}_{j}_im : Polynomial ℚ := {im}")
            lines.append(
                f"def {tag}_{i}_{j} : Ki := ofLadj {tag}_{i}_{j}_re {tag}_{i}_{j}_im"
            )
            lines.append("")

    emit_poly(f"{name}A", A)
    emit_poly(f"{name}B", B)
    emit_poly(f"{name}C", C)
    lines += [
        f"-- Bézout polynomials are stored coefficientwise; the chart identity",
        f"-- is assembled in D12SigmaPlusSegreSmooth.",
        "",
        "end V14Formalization.D12SigmaPlusSegreCore",
        "",
    ]
    return lines


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--out-dir", type=Path, required=True)
    parser.add_argument("--chart", type=str, default="")
    args = parser.parse_args()
    out = args.out_dir.resolve()
    out.mkdir(parents=True, exist_ok=True)
    data = json.loads(JSON_PATH.read_text())
    F = Fplus_from_json(data)
    dF = [pderiv(F, i) for i in range(3)]
    names = ["U", "V", "W"]
    charts = [0, 1, 2]
    if args.chart:
        charts = [names.index(args.chart)]
    summary = {}
    for ch in charts:
        Fu = restrict(dF[0], ch)
        Fv = restrict(dF[1], ch)
        Fw = restrict(dF[2], ch)
        print(f"solving chart {names[ch]} ...", flush=True)
        A, B, C = solve_affine_bezout(Fu, Fv, Fw)
        print(
            f"  A terms {len(A)} B terms {len(B)} C terms {len(C)}",
            flush=True,
        )
        path = out / f"D12SigmaPlusSegreSmooth{names[ch]}.lean"
        path.write_text("\n".join(emit_chart(names[ch], A, B, C, Fu, Fv, Fw)))
        print("wrote", path.name)
        summary[names[ch]] = (len(A), len(B), len(C))
    print("summary", summary)


if __name__ == "__main__":
    main()
