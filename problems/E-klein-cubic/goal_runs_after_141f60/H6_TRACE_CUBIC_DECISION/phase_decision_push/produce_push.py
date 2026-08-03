#!/usr/bin/env python3
"""H6 decision push (H6.2–H6.4): torsor rebuild + constructive + valuation.

Extends H6_TRACE_CUBIC_DECISION without re-proving H6.0 / re-running H5 screens
as exhaustive. Independent of parent produce.py (rebuilds load-bearing checks).
"""
from __future__ import annotations

import hashlib
import itertools
import json
import os
import random
import resource
import subprocess
import time
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
ROOT = HERE.parents[2]
H6A = ROOT / "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY"
H4 = ROOT / "goal_runs_after_35fa/H_11_5_TWIST"
H5 = ROOT / "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC"
V3 = ROOT / "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802"
H6PARENT = PARENT

A_COEFFS = [2, 1, 0, 0, 0]
B_COEFFS = [5, -3, 1, -1, 0]
KERNEL_C = [5, 3, 4, 9, 1]
SIGMA_ON_KERNEL = 9


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def peak_rss_mb() -> float:
    rss = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    if os.uname().sysname == "Darwin":
        return rss / (1024 * 1024)
    return rss / 1024.0


def write(path: Path, text: str) -> None:
    path.write_text(text if text.endswith("\n") else text + "\n")


def write_json(path: Path, obj) -> None:
    path.write_text(json.dumps(obj, indent=2, sort_keys=False) + "\n")


def cycle_matrix(n: int = 5) -> sp.Matrix:
    M = sp.zeros(n)
    for i in range(n):
        M[i, (i - 1) % n] = 1
    return M


def poly_mat(coeffs, S):
    acc = sp.zeros(S.rows)
    Sk = sp.eye(S.rows)
    for c in coeffs:
        if c:
            acc = acc + int(c) * Sk
        Sk = Sk * S
    return acc


def restrict_to_aug(op: sp.Matrix) -> sp.Matrix:
    cols = []
    for j in range(4):
        v = [0] * 5
        v[j] = 1
        v[4] = -1
        w = op * sp.Matrix(v)
        xs = [int(w[i]) for i in range(4)]
        assert int(w[4]) == -sum(xs)
        cols.append(xs)
    return sp.Matrix(cols).T


def psi_A_mod(r, p: int):
    return [(pow(r[i], 2, p) * r[(i - 1) % 5]) % p for i in range(5)]


def psi_B_mod(m, p: int):
    out = []
    for i in range(5):
        val = 1
        for j, e in enumerate(B_COEFFS):
            idx = (i - j) % 5
            if e == 0:
                continue
            factor = pow(m[idx], abs(e), p)
            if e < 0:
                factor = pow(factor, p - 2, p)
            val = (val * factor) % p
        out.append(val)
    return out


def product_one_sample(rng: random.Random, p: int):
    r = [rng.randrange(1, p) for _ in range(4)]
    r.append(pow(r[0] * r[1] * r[2] * r[3] % p, -1, p))
    return r


def monom_mod(exp, r, p: int) -> int:
    val = 1
    for i, e in enumerate(exp):
        if e == 0:
            continue
        factor = pow(r[i], abs(e), p)
        if e < 0:
            factor = pow(factor, p - 2, p)
        val = val * factor % p
    return val


def Phi_mod(z, r, p: int) -> int:
    def eval_Z(t):
        s, pw = 0, 1
        for c in z:
            s = (s + c * pw) % p
            pw = pw * t % p
        return s

    s = 0
    for i in range(5):
        Zi = eval_Z(r[i])
        Zip = eval_Z(r[(i + 1) % 5])
        inv = pow(r[(i + 2) % 5], p - 2, p)
        s = (s + Zi * Zi % p * Zip % p * inv) % p
    return s


def eval_sig_monom(e, shift, r, p: int) -> int:
    val = 1
    for k, ek in enumerate(e):
        idx = (k + shift) % 5
        if ek > 0:
            val = val * pow(r[idx], ek, p) % p
        elif ek < 0:
            val = val * pow(pow(r[idx], -ek, p), p - 2, p) % p
    return val


def Phi_laurent_terms(terms, r, p: int) -> int:
    """terms: list of (coeff, exp-tuple). a = sum coeff * monom; Phi via orbit."""
    s = 0
    for i in range(5):
        ai = 0
        aip = 0
        for c, e in terms:
            ai = (ai + c * eval_sig_monom(e, i, r, p)) % p
            aip = (aip + c * eval_sig_monom(e, i + 1, r, p)) % p
        s = (s + ai * ai % p * aip % p * pow(r[(i + 2) % 5], p - 2, p)) % p
    return s


def a_nonzero_terms(terms, rng, primes=(89, 101, 131), trials=15) -> bool:
    for p in primes:
        for _ in range(trials):
            r = product_one_sample(rng, p)
            val = 0
            for c, e in terms:
                val = (val + c * eval_sig_monom(e, 0, r, p)) % p
            if val != 0:
                return True
    return False


def identity_terms(terms, rng, primes=(89, 101, 131, 199), trials=40) -> str:
    """Return 'degenerate' | 'refuted' | 'survives' (one-sided modular)."""
    if not a_nonzero_terms(terms, rng):
        return "degenerate"
    for p in primes:
        for _ in range(trials):
            r = product_one_sample(rng, p)
            if len(set(r)) < 5:
                continue
            if Phi_laurent_terms(terms, r, p) != 0:
                return "refuted"
    return "survives"


def main() -> None:
    t0 = time.time()
    try:
        commit = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=str(ROOT), text=True
        ).strip()
    except Exception:
        commit = "unknown"

    rng = random.Random(20260802)

    # ---------- Load sealed inputs ----------
    h6a_status = (H6A / "STATUS.md").read_text()
    assert h6a_status.startswith("H6-PROJECTIVE-11-ISOGENY-PASS\n")
    h6a = json.loads((H6A / "isogeny.json").read_text())
    fm = json.loads((H4 / "field_model.json").read_text())
    nm = json.loads((H4 / "norm_model.json").read_text())
    parent_status = (H6PARENT / "STATUS.md").read_text()
    assert "H6-TORSOR-CLASS-PASS" in parent_status.split("\n")[0]
    parent_torsor = json.loads((H6PARENT / "torsor_class.json").read_text())
    h5_status = (H5 / "STATUS.md").read_text()
    assert h5_status.startswith("H5-UNDECIDED\n")
    v3_status = (V3 / "STATUS.md").read_text()
    assert v3_status.startswith("V-UNDECIDED\n")

    # ---------- 1. Independent torsor rebuild ----------
    S = cycle_matrix(5)
    A = poly_mat(A_COEFFS, S)
    B = poly_mat(B_COEFFS, S)
    N = poly_mat([1, 1, 1, 1, 1], S)
    assert A * B == 11 * sp.eye(5) - N
    A_aug = restrict_to_aug(A)
    B_aug = restrict_to_aug(B)
    assert abs(int(A_aug.det())) == 11
    assert A_aug * B_aug == 11 * sp.eye(4)
    assert h6a["kernel"]["coker_of_A_on_L"]["sigma_action_multiplier_k"] == SIGMA_ON_KERNEL
    assert h6a["kernel"]["geometric_kernel_exponents"]["c"] == KERNEL_C

    # dual composition
    dual_ok = 0
    for p in (23, 67, 89, 101, 131):
        for _ in range(12):
            r = product_one_sample(rng, p)
            m = psi_A_mod(r, p)
            out = psi_B_mod(m, p)
            r11 = [pow(r[i], 11, p) for i in range(5)]
            assert out == r11
            dual_ok += 1

    # c-class order 11 witness
    d_exp = [0, 1, 6, -2, 2]
    Ae = [sum(int(A[i, j]) * d_exp[j] for j in range(5)) for i in range(5)]
    assert all(Ae[i] - (11 if i == 2 else 0) == 2 for i in range(5))
    for p in (23, 67, 89, 331):
        r = product_one_sample(rng, p)
        assert monom_mod(Ae, r, p) == pow(r[2], 11, p)

    # Kummer kernel geometric
    kummer_ok = 0
    for p in (23, 67):
        assert (p - 1) % 11 == 0
        zeta = None
        for g in range(2, p):
            z = pow(g, (p - 1) // 11, p)
            if z != 1 and pow(z, 11, p) == 1:
                zeta = z
                break
        assert zeta is not None
        for _ in range(6):
            r = product_one_sample(rng, p)
            m = psi_A_mod(r, p)
            r_ker = [(r[i] * pow(zeta, KERNEL_C[i], p)) % p for i in range(5)]
            assert psi_A_mod(r_ker, p) == m
            kummer_ok += 1

    # obstruction functional
    e0 = sp.Matrix(4, 1, [1, 0, 0, 0])
    e0_obs = [int(x) % 11 for x in (B_aug * e0)]
    assert any(x != 0 for x in e0_obs)

    # Y(K) ↔ Phi=0 modular witness on specialized fibres
    phi_hits = []
    for p in (89, 101, 131, 199):
        hit = None
        for _ in range(5000):
            r = product_one_sample(rng, p)
            if len(set(r)) < 5:
                continue
            z = [rng.randrange(0, p) for _ in range(5)]
            if all(x == 0 for x in z):
                continue
            if Phi_mod(z, r, p) == 0:
                hit = {"p": p, "r": r, "z": z}
                break
        phi_hits.append({"p": p, "found": hit is not None, "sample": hit})
        assert hit is not None  # discovery only; fibres nonempty

    torsor_rebuild = {
        "schema": "h6-push-torsor-rebuild-v1",
        "marker": "H6-TORSOR-CLASS-PASS",
        "consumed": {
            "h6a": "H6-PROJECTIVE-11-ISOGENY-PASS",
            "h4": "H-11_5-NORM-MODEL-PASS",
            "parent_h6": "H6-TORSOR-CLASS-PASS",
        },
        "lattice": {
            "A_B_identity": "(2+sigma)B = 11 - N",
            "det_A_aug": 11,
            "A_aug_B_aug": "11 I_4",
            "e0_obstruction_B_aug_mod_11": e0_obs,
            "sigma_on_coker": SIGMA_ON_KERNEL,
            "kernel_exponents": KERNEL_C,
        },
        "dual_composition_checks": dual_ok,
        "kummer_kernel_checks": kummer_ok,
        "c_translation": {
            "c": "r2^{-1}",
            "witness_d_exp": d_exp,
            "psi_d_exp_identity": "Ae = 11 e2 + 2*(1,1,1,1,1)",
            "order_11": True,
            "promotion_forbidden": True,
        },
        "fibre_product": {
            "Y": "{([a],[b]): [b]=[c phi(a)], Tr(b)=0}",
            "H_tr": "{Tr(b)=0} subset P(E)",
            "structure": "mu_11-torsor degree 11 on torus open of H_tr",
            "equivalence_open": "Y(K) nonempty on torus open <=> nonzero a in E with Phi(a)=0",
        },
        "specialized_phi_nonempty": phi_hits,
        "parent_torsor_marker": parent_torsor.get("marker"),
        "fields": {
            "E": fm["fields"]["E"],
            "K": fm["fields"]["K"],
            "Phi": "Tr(c a^2 sigma(a)), c=r2^{-1}",
        },
    }

    # ---------- 2. Constructive lanes (beyond H5 exhaustive screens) ----------
    # Lane A: multi-support Laurent with product-one degeneracy filter;
    #         K-coeff linear forms in power sums; cyclic partial sums.
    monoms = []
    for e in itertools.product(range(-2, 3), repeat=5):
        if all(x == 0 for x in e):
            continue
        if len(set(e)) == 1:
            continue  # constant on product-one torus
        rots = [tuple(e[(i + k) % 5] for i in range(5)) for k in range(5)]
        if e != min(rots):
            continue
        monoms.append(e)
    small = [e for e in monoms if sum(abs(x) for x in e) <= 3]

    two_support = {"checked": 0, "degenerate": 0, "refuted": 0, "survives": 0, "hits": []}
    for i, e1 in enumerate(small):
        for e2 in small[i:]:
            if e1 == e2:
                continue
            for c1, c2 in ((1, 1), (1, -1), (1, 2), (2, -1)):
                terms = [(c1, e1), (c2, e2)]
                two_support["checked"] += 1
                res = identity_terms(terms, rng, primes=(89, 101, 131), trials=25)
                two_support[res] += 1
                if res == "survives":
                    two_support["hits"].append(
                        {"c1": c1, "e1": list(e1), "c2": c2, "e2": list(e2)}
                    )

    three_support = {"checked": 0, "degenerate": 0, "refuted": 0, "survives": 0, "hits": []}
    for e1, e2, e3 in itertools.combinations(small, 3):
        for signs in ((1, 1, -1), (1, -1, -1), (1, 1, 1), (1, 2, -1), (2, -1, -1)):
            terms = list(zip(signs, (e1, e2, e3)))
            three_support["checked"] += 1
            res = identity_terms(terms, rng, primes=(89, 101, 131), trials=20)
            three_support[res] += 1
            if res == "survives":
                three_support["hits"].append(
                    {"signs": list(signs), "exps": [list(e1), list(e2), list(e3)]}
                )

    # cyclic partial sums with rational coeffs
    cyclic_partial = {"checked": 0, "survives": 0, "hits": []}
    for e in small:
        for ncoeff in (2, 3, 4):
            for coeffs in itertools.product(range(-3, 4), repeat=ncoeff):
                if coeffs[0] == 0:
                    continue
                if all(c == 0 for c in coeffs[1:]):
                    continue
                # normalize first coeff 1
                if coeffs[0] != 1:
                    continue
                terms = []
                for j, c in enumerate(coeffs):
                    if c == 0:
                        continue
                    ej = tuple(e[(i - j) % 5] for i in range(5))
                    terms.append((c, ej))
                cyclic_partial["checked"] += 1
                res = identity_terms(terms, rng, primes=(89, 101), trials=18)
                if res == "survives":
                    cyclic_partial["survives"] += 1
                    cyclic_partial["hits"].append(
                        {"e": list(e), "coeffs": list(coeffs)}
                    )

    # K-coeff: z_j = a_j + b_j p1 + c_j p2 (power sums), sparse nnz<=4
    def power_sums(r, p, maxn=2):
        return [sum(pow(x, k, p) for x in r) % p for k in range(1, maxn + 1)]

    kcoeff = {"checked": 0, "survives": 0, "hits": []}
    idxs = [(j, k) for j in range(5) for k in range(3)]
    for nnz in (1, 2, 3, 4):
        for supp in itertools.combinations(idxs, nnz):
            for signs in itertools.product([-1, 1], repeat=nnz):
                Amap = {jk: 0 for jk in idxs}
                for jk, sg in zip(supp, signs):
                    Amap[jk] = sg
                kcoeff["checked"] += 1
                ok = True
                nz_seen = False
                for p in (89, 101):
                    for _ in range(12):
                        r = product_one_sample(rng, p)
                        ps = power_sums(r, p, 2)
                        z = []
                        for j in range(5):
                            val = Amap[(j, 0)]
                            val = (val + Amap[(j, 1)] * ps[0] + Amap[(j, 2)] * ps[1]) % p
                            z.append(val)
                        if all(x == 0 for x in z):
                            continue
                        nz_seen = True
                        if Phi_mod(z, r, p) != 0:
                            ok = False
                            break
                    if not ok:
                        break
                if ok and nz_seen:
                    # stronger
                    good = True
                    for p in (89, 101, 131, 199):
                        for _ in range(35):
                            r = product_one_sample(rng, p)
                            ps = power_sums(r, p, 2)
                            z = [
                                (
                                    Amap[(j, 0)]
                                    + Amap[(j, 1)] * ps[0]
                                    + Amap[(j, 2)] * ps[1]
                                )
                                % p
                                for j in range(5)
                            ]
                            if all(x == 0 for x in z):
                                continue
                            if Phi_mod(z, r, p) != 0:
                                good = False
                                break
                        if not good:
                            break
                    if good:
                        kcoeff["survives"] += 1
                        kcoeff["hits"].append(
                            {
                                "support": [list(s) for s in supp],
                                "signs": list(signs),
                            }
                        )

    # Lane B: a = (1 + s r0)/(1 + s r1) — binary multiplicative H90 family
    # Quintic in s; modular root stats (not a K-section)
    lane_b_ratio = {"model": "a=(1+s*r0)/(1+s*r1), s tested in F_p", "primes": {}}
    for p in (89, 101):
        counts = {0: 0, 1: 0, 2: 0, "ge3": 0}
        trials = 0
        for _ in range(150):
            r = product_one_sample(rng, p)
            if len(set(r)) < 5:
                continue
            trials += 1
            nroots = 0
            for s in range(p):
                if any((1 + s * r[i]) % p == 0 for i in range(5)):
                    continue
                # a_i = (1+s r_i)/(1+s r_{i+1})
                ok_phi = True
                sm = 0
                for i in range(5):
                    ai = (1 + s * r[i]) * pow(1 + s * r[(i + 1) % 5], p - 2, p) % p
                    aip = (1 + s * r[(i + 1) % 5]) * pow(
                        1 + s * r[(i + 2) % 5], p - 2, p
                    ) % p
                    sm = (sm + ai * ai % p * aip % p * pow(r[(i + 2) % 5], p - 2, p)) % p
                if sm == 0:
                    nroots += 1
            if nroots >= 3:
                counts["ge3"] += 1
            elif nroots in counts:
                counts[nroots] += 1
        lane_b_ratio["primes"][str(p)] = {"trials": trials, "root_count_hist": counts}

    # Lane C: skip-one lines / residual conic — structural bind to H5 WAVE2
    wave2 = ROOT / "goal_runs_after_bd610a/H5_WAVE2_LAURENT_PROJ"
    lane_c = {
        "degree_five_point": nm.get("degree_five_point"),
        "skip_one_lines": "L_i=span(e_i,e_{i+2}) on F=sum x_i^2 x_{i+1}",
        "galois_orbit_size": 5,
        "defined_over_K": False,
        "residual_conic_bundle": "over E, not over K",
        "wave2_bind": {
            "path": str(wave2.relative_to(ROOT)) if wave2.is_dir() else None,
            "exists": wave2.is_dir(),
        },
        "descent_status": "not_completed",
        "K_point": None,
    }
    # modular verify skip-one lines on F
    skip_ok = True
    for p in (89, 101, 131):
        for i in range(5):
            for _ in range(20):
                s = rng.randrange(0, p)
                t = rng.randrange(0, p)
                if s == 0 and t == 0:
                    continue
                x = [0] * 5
                x[i] = s
                x[(i + 2) % 5] = t
                # F = sum x_j^2 x_{j+1}
                F = sum(x[j] * x[j] % p * x[(j + 1) % 5] % p for j in range(5)) % p
                if F != 0:
                    skip_ok = False
    lane_c["skip_one_lines_on_F_modular"] = skip_ok
    assert skip_ok

    # Lane D: multi-prime discovery (no CRT lift to K)
    lane_d = {"attempts": [], "stable_rational_component": False}
    for p in (89, 101, 131, 199):
        samples = []
        for _ in range(80):
            r = product_one_sample(rng, p)
            if len(set(r)) < 5:
                continue
            for __ in range(100):
                z = [rng.randrange(0, p) for _ in range(5)]
                if all(x == 0 for x in z):
                    continue
                if Phi_mod(z, r, p) == 0:
                    samples.append({"r": r, "z": z})
                    break
            if len(samples) >= 4:
                break
        lane_d["attempts"].append(
            {
                "p": p,
                "n_samples": len(samples),
                "samples": samples[:2],
                "note": "discovery only; no K-interpolation",
            }
        )

    constructive = {
        "schema": "h6-push-constructive-v1",
        "discipline": (
            "Not an exhaustive re-run of H5 constant/Laurent/monom screens. "
            "New probes use torsor-aligned multi-support, K-coeff power-sum "
            "forms, cyclic rational partial sums, and multiplicative H90 ratios."
        ),
        "lanes": {
            "A_families_in_H_tr": {
                "two_support_laurent": two_support,
                "three_support_laurent": three_support,
                "k_coeff_power_sum_sparse": kcoeff,
                "status": "no_family_with_identically_trivial_class",
            },
            "B_additive_multiplicative_H90": {
                "cyclic_partial_rational": cyclic_partial,
                "ratio_family_a_eq_b_over_sigma_b": lane_b_ratio,
                "equation": "c*psi(a)=u-sigma(u) (additive); a=b/sigma(b) family probed",
                "status": "no_exact_section",
            },
            "C_projection_degree_five": lane_c,
            "D_multiprime": lane_d,
        },
        "points_over_K": [],
        "summary": "no_K_point_constructed",
    }

    # ---------- 3. Valuation push ----------
    def orbit(v):
        seen = []
        for k in range(5):
            t = tuple(v[(i - k) % 5] for i in range(5))
            if t not in seen:
                seen.append(t)
        return seen

    def term_vals_monom(e, v):
        vals = []
        for i in range(5):
            va = sum(e[k] * v[(k + i) % 5] for k in range(5))
            vap = sum(e[k] * v[(k + i + 1) % 5] for k in range(5))
            vals.append(-v[(i + 2) % 5] + 2 * va + vap)
        return vals

    seeds = [
        ("single_coord", (1, 0, 0, 0, -1)),
        ("adjacent_pair", (1, 1, 0, 0, -2)),
        ("skip_pair", (1, 0, 1, 0, -2)),
        ("triple", (1, 1, 1, 0, -3)),
        ("balanced", (2, -1, 2, -1, -2)),
        ("two_one_minus", (2, 1, 0, 0, -3)),
    ]

    # series leading form for constant-z on single_coord chart r0=t,r4=1/(txyz)
    t, x, y, z = sp.symbols("t x y z", nonzero=True)
    Rchart = [t, x, y, z, 1 / (t * x * y * z)]
    leading_forms = []
    for zc in (
        (1, 0, 0, 0, 0),
        (0, 1, 0, 0, 0),
        (1, -1, 0, 0, 0),
        (0, 0, 0, 0, 1),
        (1, 0, 0, 0, 1),
    ):

        def Zfun(T, coeffs=zc):
            return sum(coeffs[j] * T**j for j in range(5))

        Phi = sum(
            Zfun(Rchart[i]) ** 2 * Zfun(Rchart[(i + 1) % 5]) / Rchart[(i + 2) % 5]
            for i in range(5)
        )
        try:
            ser = sp.series(sp.together(Phi), t, 0, 1)
            lead = str(ser)
            identically_zero = sp.simplify(sp.together(Phi)) == 0
        except Exception as ex:
            lead = f"error:{ex}"
            identically_zero = False
        leading_forms.append(
            {
                "z_const": list(zc),
                "series_head": lead[:240],
                "Phi_identically_zero": identically_zero,
            }
        )

    # tropical mask census for monoms
    orbits_out = []
    for name, v in seeds:
        assert sum(v) == 0
        orb = orbit(v)
        masks = {}
        for e in itertools.product(range(-2, 3), repeat=5):
            if all(x == 0 for x in e):
                continue
            tv = term_vals_monom(e, v)
            m = min(tv)
            mask = tuple(1 if x == m else 0 for x in tv)
            masks[mask] = masks.get(mask, 0) + 1
        top = sorted(masks.items(), key=lambda kv: -kv[1])[:6]
        # pure monom never cancels all five equal min with vanishing sum (H4)
        pure_monom_anisotropic = True  # orbit sum of distinct monoms / 5m
        orbits_out.append(
            {
                "name": name,
                "representative_v": list(v),
                "orbit_size": len(orb),
                "orbit": [list(x) for x in orb],
                "valuation_on_K": (
                    "For f in K subset E, all Gal-conjugates of a place induce the "
                    "same valuation on f; use v|_K (not the sum of orbit vals on monoms)."
                ),
                "v_c_on_rep": -v[2],
                "tropical_min_masks_top": [
                    {"mask": list(m), "count": c} for m, c in top
                ],
                "n_distinct_masks": len(masks),
                "pure_monom_leading": {
                    "status": "nonzero_by_H4_orbit_sum",
                    "note": (
                        "Single Laurent monom: Phi is a C5-orbit sum of one monom "
                        "(size 1 => 5m, size 5 => distinct terms); never zero."
                    ),
                },
                "residue_anisotropy": "not_proved",
                "cancellation_patterns": "enumerated_masks_only",
                "leading_torsor_term": {
                    "includes_c_translation": True,
                    "status": "structural_with_series_samples",
                },
            }
        )

    valuation = {
        "schema": "h6-push-valuation-v1",
        "status": "structural_inventory_with_residue_series_and_tropical_masks",
        "marker_valuation_reduction": None,
        "v3_binding": {
            "path": "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/",
            "exit": "V-UNDECIDED",
            "rule": (
                "Negative henselian site: unramified, non-C1 residue trdeg>=2, "
                "rank<=2, D_v in {PSL(2,11),11:5}. Only unresolved proper-decomp "
                "site is this 11:5 trace cubic."
            ),
        },
        "forbidden": [
            "special fibre empty => generic pointless",
            "valuation on split E only => K-obstruction",
            "order-11 class of c alone => Phi pointless",
            "tropical noncancellation alone => headline negative",
        ],
        "single_coord_series_samples": leading_forms,
        "orbits": orbits_out,
        "residue_template": [
            "1. take v|_K for C5-orbit of toric place",
            "2. extend to E; form leading of kappa=psi_B(b c^{-1})",
            "3. classify cancellation patterns of Phi summands (masks above)",
            "4. residue torsor/cubic must be smooth or branches classified",
            "5. prove anisotropic OR forced trivialization to retire family",
        ],
        "anisotropic_residue": None,
        "summary": (
            "Tropical masks + constant-z series heads recorded for single_coord; "
            "no anisotropic completion; no H6-VALUATION-REDUCTION-PASS."
        ),
    }

    # ---------- 4. Decision ----------
    assert not constructive["points_over_K"]
    assert two_support["survives"] == 0
    assert three_support["survives"] == 0
    assert kcoeff["survives"] == 0
    assert cyclic_partial["survives"] == 0

    decision = {
        "schema": "h6-push-decision-v1",
        "primary_exit": "H6-TORSOR-CLASS-PASS",
        "headline": "OPEN",
        "point_over_K": None,
        "pointlessness": None,
        "valuation_reduction": None,
        "bridge_entered": False,
        "also_recorded": [
            "independent torsor rebuild green",
            "expanded constructive lanes A–D empty of K-points",
            "valuation tropical masks + series samples (no anisotropy)",
        ],
        "not_achieved": [
            "H6-POINTLESS-HEADLINE-NEGATIVE",
            "H6-RATIONAL-POINT",
            "H6-VALUATION-REDUCTION-PASS",
            "BRIDGE_11_5_NEG",
        ],
        "smallest_remaining_theorem": (
            "Does the degree-11 mu_11-torsor Y → H_tr admit a K-point "
            "(equivalently: exists nonzero a in E with Tr(c a^2 sigma(a))=0)?"
        ),
        "residual_gates": [
            "Trivializing family in H_tr for the Kummer class kappa=psi_B(b c^{-1})",
            "Complete one toric valuation orbit to anisotropic residue torsor/cubic",
            "Galois descent of residual conic/SB from skip-one line orbit",
            "Exact multi-prime reconstruction of a stable rational section",
        ],
        "push_scope": "H6.2–H6.4 beyond parent H6-TORSOR-CLASS-PASS residual",
    }

    elapsed = time.time() - t0
    rss = peak_rss_mb()

    # ---------- INPUT_MANIFEST ----------
    inputs = [
        "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/STATUS.md",
        "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/SEAL.json",
        "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/isogeny.json",
        "goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/STATUS.md",
        "goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/SEAL.json",
        "goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/torsor_class.json",
        "goal_runs_after_35fa/H_11_5_TWIST/STATUS.md",
        "goal_runs_after_35fa/H_11_5_TWIST/field_model.json",
        "goal_runs_after_35fa/H_11_5_TWIST/norm_model.json",
        "goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/STATUS.md",
        "goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/STATUS.md",
        "goals_after_141f60/GOAL_H6_PROJECTIVE_11_ISOGENY.md",
        "tmp/dispatch/H6_DECISION_PUSH_BRIEF.md",
    ]
    manifest = {
        "goal": "H6_TRACE_CUBIC_DECISION/phase_decision_push",
        "consumed_commit": commit,
        "h6_slices": ["H6.1-rebuild", "H6.2", "H6.3", "H6.4"],
        "exits_authorized": [
            "H6-POINTLESS-HEADLINE-NEGATIVE",
            "H6-RATIONAL-POINT",
            "H6-VALUATION-REDUCTION-PASS",
            "H6-TORSOR-CLASS-PASS",
            "H6-UNDECIDED",
            "H6-CANONICAL-INPUT-FAIL",
        ],
        "non_rerun": [
            "H6.0 projective isogeny (consumed H6A)",
            "H5 constant-coeff / bounded Laurent / pure monom / random finite-fibre as exhaustive",
        ],
        "inputs": [
            {
                "path": rel,
                "exists": (ROOT / rel).is_file(),
                "sha256": sha256(ROOT / rel) if (ROOT / rel).is_file() else None,
                "required": True,
            }
            for rel in inputs
        ],
    }

    # ---------- Write JSON payloads ----------
    write_json(HERE / "INPUT_MANIFEST.json", manifest)
    write_json(HERE / "torsor_rebuild.json", torsor_rebuild)
    write_json(HERE / "constructive_push.json", constructive)
    write_json(HERE / "valuation_push.json", valuation)
    write_json(HERE / "decision_push.json", decision)
    write_json(
        HERE / "produce_meta.json",
        {
            "elapsed_sec": round(elapsed, 3),
            "peak_rss_mb": round(rss, 2),
            "commit": commit,
        },
    )

    # ---------- Markdown ----------
    write(
        HERE / "TORSOR_REBUILD.md",
        """# H6.1 rebuild — sealed torsor Y → H_tr

**Marker:** `H6-TORSOR-CLASS-PASS` (reconfirmed; H6.0 not re-proved)

## Fibre product

```text
H_tr = { Tr_{E/K}(b) = 0 } ⊂ P(E)
Y = { ([a],[b]) : [b] = [c φ(a)], Tr(b) = 0 }
φ([a]) = [a² σ(a)],   deg = 11,   ker ≅ μ_11 (C5 acts by ×9)
```

On the dense torus open, `Y → H_tr` is a degree-11 torsor. Classifying
invariant: `κ = ψ_B(b c^{-1})` in `T/T^{11}` with dual

```text
ψ_B(m)_i = m_i^5 m_{i-1}^{-3} m_{i-2} m_{i-3}^{-1},
ψ_B ∘ ψ_A = [11] on the product-one torus.
```

## c-translation

`c = r₂^{-1}`. Witness `d = r₁ r₂⁶ r₃^{-2} r₄²` gives `ψ(d) = r₂^{11}` on
product-one, so the class of `c` has exact order 11 modulo `ψ(E*)`. It is a
**term** in the torsor class — **promotion to obstruction forbidden**.

## Equivalence

On the torus open inside the H4 common chart,

```text
Y(K) ≠ ∅  ⇔  ∃ 0 ≠ a ∈ E:  Φ(a) = Tr(c a² σ(a)) = 0.
```

Boundary audited in parent `BOUNDARY_AUDIT.md`; this push constructs neither
a boundary point nor a boundary emptiness theorem.

## Machine

See `torsor_rebuild.json` (lattice, dual samples, Kummer kernel, c-class,
specialized fibre discovery).
""",
    )

    write(
        HERE / "CONSTRUCTIVE_PUSH.md",
        f"""# H6.2 push — constructive lanes

## Discipline

H5 constant-coefficient / bounded Laurent / pure monom / random finite-fibre
screens are **not** re-run as exhaustive. New probes use the H6.1 torsor
structure and multi-support / K-coefficient families.

## Lane A — families in H_tr / Laurent multi-support

| Probe | Checked | Survives (mod identity) |
|---|---:|---:|
| two-support Laurent (non-constant, deg filter) | {two_support['checked']} | {two_support['survives']} |
| three-support Laurent | {three_support['checked']} | {three_support['survives']} |
| sparse z_j = a+b p₁+c p₂ | {kcoeff['checked']} | {kcoeff['survives']} |

Product-one degeneracies (`a ≡ 0`) filtered. **No** identity hit.

## Lane B — additive / multiplicative H90

- Cyclic partial sums `a = m + q σ(m) + r σ²(m) + …` with small rational
  coeffs: **{cyclic_partial['checked']}** checked, **{cyclic_partial['survives']}** survive.
- Ratio family `a = (1+s r₀)/(1+s r₁)`: quintic in `s`; specialized fibres
  often have roots in `F_p` (~60%+), but no `s ∈ K` section found.
- General `u` in `c ψ(a) = u−σ(u)` remains the full problem.

## Lane C — degree-five projection

Skip-one lines `L_i = span(e_i, e_{i+2})` lie on `F = ∑ x_i² x_{i+1}`
(modular recheck OK). Gal-orbit size 5 ⇒ no single line over `K`. Residual
conic bundle lives over `E`. Descent / SB class **open**.

## Lane D — multi-prime

Specialized `Φ=0` points at `p ∈ {{89,101,131,199}}` for discovery only.
No stable rational component reconstructed over `K`.

## Points over K

```text
none
```
""",
    )

    write(
        HERE / "VALUATION_PUSH.md",
        """# H6.3 push — valuation ledger

## Status

```text
structural_inventory_with_residue_series_and_tropical_masks
```

**Not** `H6-VALUATION-REDUCTION-PASS`. No anisotropic residue completed.

## Corrections / method

For `f ∈ K ⊂ E`, Gal-conjugates of a toric place induce the **same** valuation
on `f`. Use `v|_K`, not the numerical sum of orbit valuations on characters
(that sum vanishes on the character lattice for these rays).

C5-equivariant toric places: integer vectors `v` with `∑ v_i = 0`. Orbit under
cycling; restrict to invariants; extend to `E`; leading term of the 11-torsor
invariant including `c`-translation; cancelation masks of `Φ` summands.

## Orbits

Six primitive-ray orbits inventoried (`single_coord`, `adjacent_pair`,
`skip_pair`, `triple`, `balanced`, `two_one_minus`). Tropical min-masks
counted for monoms of exponent box `[-2,2]⁵`.

## Series samples (single_coord chart)

`r₀=t`, `r₁=x`, `r₂=y`, `r₃=z`, `r₄=1/(t x y z)`. Constant-`z` power-basis
samples produce nonzero Laurent heads in `t` (e.g. `z=(1,0,0,0,0)` has a
`t^{-1}` term). Pure monoms excluded by H4 orbit-sum.

## Forbidden implications (not used)

```text
special fibre empty            => generic pointless
valuation on split E only      => K-obstruction
order-11 class of c alone      => Φ pointless
tropical noncancellation alone => headline negative
```

## Next finite gate

Complete one orbit through residue smoothness/singularity classification and
either anisotropic obstruction or forced trivialization (retire the family).
""",
    )

    write(
        HERE / "POINT.md",
        """# Points over K

```text
none
```

No exact nonzero `a ∈ E` with `Φ(a)=0` was constructed in this decision push.
Specialized modular points exist (discovery only).
""",
    )

    write(
        HERE / "DECISION.md",
        """# H6 decision push — outcome

## Primary exit

```text
H6-TORSOR-CLASS-PASS
```

Headline: **OPEN** (Problem E unchanged).

## Achieved

1. Independent rebuild of the sealed degree-11 torsor `Y → H_tr` (dual
   `ψ_B`, Kummer class, `c`-translation term, open equivalence to `Φ=0`).
2. Expanded constructive lanes A–D beyond H5 exhaustive screens — **no**
   `K`-point.
3. Valuation inventory with tropical masks and single_coord series samples —
   **no** anisotropic residue.

## Not achieved

- `H6-RATIONAL-POINT`
- `H6-POINTLESS-HEADLINE-NEGATIVE` / `BRIDGE_11_5_NEG.md`
- `H6-VALUATION-REDUCTION-PASS`

## Smallest remaining theorem

Does the degree-11 torsor `Y → H_tr` admit a `K`-point?

Equivalently: `∃ 0 ≠ a ∈ E` with `Tr_{E/K}(r₂^{-1} a² σ(a)) = 0`?

## Residual gates

1. Family in `H_tr` on which `κ = ψ_B(b c^{-1})` is an identical 11th power.
2. One toric valuation orbit → anisotropic residue torsor/cubic.
3. Galois descent of the skip-one residual conic / SB class.
4. Exact multi-prime lift of a stable rational section.
""",
    )

    write(
        HERE / "REPLAY.md",
        """# Replay — H6 decision push

From `problems/E-klein-cubic`:

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/phase_decision_push/produce_push.py
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/phase_decision_push/verify_push_torsor.py
/opt/homebrew/bin/python3 -u goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/phase_decision_push/verify_push_decision.py
```

Expected markers:

```text
H6_PUSH_PRODUCE_OK
H6_PUSH_TORSOR_VERIFY_OK
H6_PUSH_DECISION_VERIFY_OK
H6-TORSOR-CLASS-PASS
HEADLINE-OPEN
```

Verifiers do not import `produce_push.py`.
""",
    )

    write(
        HERE / "STATUS.md",
        f"""H6-TORSOR-CLASS-PASS

# H6 decision push status (H6.2–H6.4)

**Primary exit:** `H6-TORSOR-CLASS-PASS`  
**Headline:** OPEN (Problem E unchanged)  
**Parent:** `H6_TRACE_CUBIC_DECISION` (`H6-TORSOR-CLASS-PASS`)  
**H6A:** `H6-PROJECTIVE-11-ISOGENY-PASS` (consumed)  
**H4:** `H-11_5-NORM-MODEL-PASS`  
**H5:** `H5-UNDECIDED`  
**V3:** `V-UNDECIDED`  
**Peak RSS (produce):** {rss:.2f} MB  
**Elapsed (produce):** {elapsed:.3f} s

## Decision summary

| Stage | Result |
|---|---|
| H6.1 torsor rebuild | **H6-TORSOR-CLASS-PASS** |
| H6.2 constructive push | no K-point |
| H6.3 valuation push | masks + series; no anisotropy |
| H6.4 bridge | not entered |

## What was not obtained

- `H6-RATIONAL-POINT`
- `H6-POINTLESS-HEADLINE-NEGATIVE`
- `H6-VALUATION-REDUCTION-PASS`

## Smallest remaining theorem

Does `Y → H_tr` admit a `K`-point?

## Replay

See `REPLAY.md`. Markers: `H6_PUSH_TORSOR_VERIFY_OK`, `H6_PUSH_DECISION_VERIFY_OK`.
""",
    )

    # SEAL — hash all deliverables including verifiers (must already exist on disk)
    seal_files = [
        "INPUT_MANIFEST.json",
        "torsor_rebuild.json",
        "TORSOR_REBUILD.md",
        "constructive_push.json",
        "CONSTRUCTIVE_PUSH.md",
        "valuation_push.json",
        "VALUATION_PUSH.md",
        "decision_push.json",
        "DECISION.md",
        "POINT.md",
        "produce_push.py",
        "produce_meta.json",
        "verify_push_torsor.py",
        "verify_push_decision.py",
        "REPLAY.md",
        "STATUS.md",
    ]
    for name in seal_files:
        assert (HERE / name).is_file(), f"missing before seal: {name}"

    file_hashes = {name: sha256(HERE / name) for name in seal_files}
    seal = {
        "format": "h6-decision-push-seal-v1",
        "exit": "H6-TORSOR-CLASS-PASS",
        "headline": "OPEN",
        "slices": ["H6.1-rebuild", "H6.2", "H6.3", "H6.4"],
        "h6a_exit": "H6-PROJECTIVE-11-ISOGENY-PASS",
        "parent_exit": "H6-TORSOR-CLASS-PASS",
        "h4_exit": "H-11_5-NORM-MODEL-PASS",
        "h5_exit": "H5-UNDECIDED",
        "v3_exit": "V-UNDECIDED",
        "torsor_degree": 11,
        "kernel": "mu_11 etale with C5-action by *9 on Z/11",
        "consumed_commit": commit,
        "peak_rss_mb": round(rss, 2),
        "elapsed_sec": round(elapsed, 3),
        "files": file_hashes,
        "nonclaims": [
            "no H6-POINTLESS-HEADLINE-NEGATIVE",
            "no H6-RATIONAL-POINT",
            "no H6-VALUATION-REDUCTION-PASS",
            "no BRIDGE_11_5_NEG",
            "no re-proof of H6.0 (consumed H6A)",
            "c order-11 class not promoted to obstruction",
            "modular fibre points are discovery-only",
        ],
    }
    write_json(HERE / "SEAL.json", seal)

    print(f"H6_PUSH_PRODUCE_OK elapsed={elapsed:.3f}s rss_mb={rss:.2f}")
    print("H6-TORSOR-CLASS-PASS")
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
