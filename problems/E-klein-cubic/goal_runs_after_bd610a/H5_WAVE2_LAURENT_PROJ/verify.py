#!/usr/bin/env python3
"""Independent verifier for H5 WAVE2.

Does NOT import produce.py. Reconstructs Phi, checks input hashes, re-runs
every constructive screen class (hard-review fix: not only JSON booleans /
tiny subsets), and replays modular samples + projection line checks.
"""

from __future__ import annotations

from hashlib import sha256
import itertools
import json
from pathlib import Path
import random
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
H4 = ROOT / "goal_runs_after_35fa" / "H_11_5_TWIST"
GOAL = ROOT / "goals_after_bd610a" / "GOAL_H5_11_5_TRACE_CUBIC_DECISION.md"

WEIGHTS = (1, 9, 4, 3, 5)
R_EXPONENTS = (
    (-2, 1, 1, 0, 0),
    (0, -2, 1, 1, 0),
    (0, 0, -2, 1, 1),
    (1, 0, 0, -2, 1),
    (1, 1, 0, 0, -2),
)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def mod_inv(x, p):
    return pow(x, -1, p)


def random_r(p, rng):
    for _ in range(4000):
        head = [rng.randrange(1, p) for _ in range(4)]
        prod = 1
        for x in head:
            prod = prod * x % p
        r = head + [mod_inv(prod, p)]
        if 0 not in r and len(set(r)) == 5:
            return r
    return None


def mon(r, exp, p):
    v = 1
    for i, e in enumerate(exp):
        v = v * pow(r[i], e, p) % p
    return v


def sigma_exp(exp):
    return (exp[4], exp[0], exp[1], exp[2], exp[3])


def phi_from_orbit(avals, r, p):
    total = 0
    for i in range(5):
        total = (
            total
            + mod_inv(r[(i + 2) % 5], p)
            * (avals[i] * avals[i] % p)
            * avals[(i + 1) % 5]
        ) % p
    return total


def orbit_from_terms(terms, r, p):
    out = []
    cur = terms
    for _ in range(5):
        val = 0
        for c, exp in cur:
            val = (val + (c % p) * mon(r, exp, p)) % p
        out.append(val)
        cur = [(c, sigma_exp(exp)) for c, exp in cur]
    return out


def eval_Z_orbit(z, r, p):
    return [sum(z[j] * pow(r[i], j, p) for j in range(5)) % p for i in range(5)]


def degenerate_diagonal(exp):
    return len(set(exp)) == 1


def normalize_exp(exp):
    m = min(exp)
    e = tuple(x - m for x in exp)
    rots = [tuple(e[(i + k) % 5] for i in range(5)) for k in range(5)]
    return min(rots)


def inv_menu(r, p):
    invr = [mod_inv(x, p) for x in r]
    p1 = sum(r) % p
    p2 = sum(pow(x, 2, p) for x in r) % p
    p3 = sum(pow(x, 3, p) for x in r) % p
    pm1 = sum(invr) % p
    e11 = sum(r[i] * r[(i + 1) % 5] % p for i in range(5)) % p
    e12 = sum(r[i] * pow(r[(i + 1) % 5], 2, p) % p for i in range(5)) % p
    e21 = sum(pow(r[i], 2, p) * r[(i + 1) % 5] % p for i in range(5)) % p
    e13 = sum(r[i] * r[(i + 2) % 5] % p for i in range(5)) % p
    return {
        "0": 0,
        "1": 1,
        "p1": p1,
        "p2": p2,
        "p3": p3,
        "p4": sum(pow(x, 4, p) for x in r) % p,
        "pm1": pm1,
        "pm2": sum(pow(x, 2, p) for x in invr) % p,
        "e11": e11,
        "e12": e12,
        "e21": e21,
        "e13": e13,
        "e22": sum(pow(r[i], 2, p) * pow(r[(i + 1) % 5], 2, p) % p for i in range(5))
        % p,
        "p1p1": p1 * p1 % p,
        "p1pm1": p1 * pm1 % p,
        "p1e11": p1 * e11 % p,
        "pm1e11": pm1 * e11 % p,
        "e11e11": e11 * e11 % p,
        "p2pm1": p2 * pm1 % p,
        "s_e12e21": (e12 + e21) % p,
    }


def identity_zero_av(make_av, primes=(31, 41, 61, 71, 101), trials=4, seed=0):
    rng = random.Random(seed)
    saw = False
    for p in primes:
        for _ in range(trials):
            r = random_r(p, rng)
            if r is None:
                continue
            try:
                avals = make_av(r, p)
            except Exception:
                continue
            if avals is None:
                continue
            avals = [int(x) % p for x in avals]
            if all(x == 0 for x in avals):
                continue
            saw = True
            if phi_from_orbit(avals, r, p) != 0:
                return False, saw
    return True, saw


def uniq_monoms(bound):
    seen = set()
    out = []
    for e in itertools.product(range(-bound, bound + 1), repeat=5):
        if not any(e) or degenerate_diagonal(e):
            continue
        n = normalize_exp(e)
        if n not in seen and any(n):
            seen.add(n)
            out.append(n)
    return out


def klein_F(x, p):
    return sum((x[i] * x[i] % p) * x[(i + 1) % 5] % p for i in range(5)) % p


def main() -> None:
    manifest = json.loads((HERE / "INPUT_MANIFEST.json").read_text())
    assert manifest["format"] == "H5-WAVE2-INPUT-MANIFEST-v1"
    assert manifest["h4_exit"] == "H-11_5-NORM-MODEL-PASS"
    assert manifest["parent_exit"] == "H5-UNDECIDED"

    for key, meta in manifest["inputs"].items():
        path = ROOT / meta["path_relative_to_problem"]
        assert path.is_file(), f"missing {path}"
        assert digest(path) == meta["sha256"], f"hash mismatch {key}"

    field = json.loads((H4 / "field_model.json").read_text())
    norm = json.loads((H4 / "norm_model.json").read_text())
    twist = json.loads((H4 / "twist_model.json").read_text())
    assert field["fields"]["degrees"]["E_over_K"] == 5
    assert all(sum(row) == 0 for row in R_EXPONENTS)
    assert all(
        sum(a * b for a, b in zip(row, WEIGHTS)) % 11 == 0 for row in R_EXPONENTS
    )

    # Reconstruct cubic coeffs on H4 witness p=89
    common = twist["common_open_good_reduction_witness"]
    p = common["prime"]
    assert p == 89
    r = common["r"]
    prod = 1
    for x in r:
        prod = prod * x % p
    assert prod == 1

    def compositions(total, length):
        if length == 1:
            yield (total,)
            return
        for first in range(total + 1):
            for rest in compositions(total - first, length - 1):
                yield (first,) + rest

    out = {e: 0 for e in compositions(3, 5)}
    for i in range(5):
        c = mod_inv(r[(i + 2) % 5], p)
        left = [pow(r[i], j, p) for j in range(5)]
        right = [pow(r[(i + 1) % 5], j, p) for j in range(5)]
        for j, k, ell in itertools.product(range(5), repeat=3):
            exponents = [0] * 5
            exponents[j] += 1
            exponents[k] += 1
            exponents[ell] += 1
            key = tuple(exponents)
            out[key] = (out[key] + c * left[j] * left[k] * right[ell]) % p
    rebuilt = {",".join(map(str, k)): v for k, v in sorted(out.items()) if v}
    assert rebuilt == common["trace_twist_coefficients"]

    decision = json.loads((HERE / "decision.json").read_text())
    assert decision["exit"] == "H5-UNDECIDED"
    assert decision["headline"] == "OPEN"
    assert decision["rational_point_over_K"] is None
    assert decision["pointlessness"] is None

    point = json.loads((HERE / "point.json").read_text())
    assert point["rational_point_over_K"] is None

    constructive = json.loads((HERE / "constructive_search.json").read_text())
    assert constructive["any_identity_hit"] is False
    assert constructive["points_found_over_K"] == []
    screens = constructive["screens"]

    # ---- FULL re-run of each screen class (hard-review fix) ----
    print("VERIFY: re-running structure...", flush=True)
    st = screens["structure_k_laurent_monoms"]
    assert st["verdict"] == "structure_recorded"
    # Independent check: sigma-fixed => diagonal
    for e in itertools.product(range(-2, 3), repeat=5):
        if not any(e):
            continue
        if e == sigma_exp(e):
            assert degenerate_diagonal(e), e

    print("VERIFY: re-running named formulas...", flush=True)
    named = screens["named_formulas"]

    def inv_diff(r, p):
        return [
            (mod_inv(r[i], p) - mod_inv(r[(i + 1) % 5], p)) % p for i in range(5)
        ]

    def disc_like(r, p):
        return [
            (pow(r[i], 2, p) - r[(i + 1) % 5] * r[(i - 1) % 5]) % p for i in range(5)
        ]

    def a_eq_c(r, p):
        return [mod_inv(r[(i + 2) % 5], p) for i in range(5)]

    def skip_diff(r, p):
        return [(r[i] - r[(i + 2) % 5]) % p for i in range(5)]

    def centered(r, p):
        p1 = sum(r) % p
        return [(5 * r[i] - p1) % p for i in range(5)]

    def ratio_quad(r, p):
        b = [(1 + r[i] + pow(r[i], 2, p)) % p for i in range(5)]
        return [b[i] * mod_inv(b[(i + 1) % 5], p) % p for i in range(5)]

    def add_quad(r, p):
        b = [(1 + r[i] + pow(r[i], 2, p)) % p for i in range(5)]
        return [(b[i] - b[(i + 1) % 5]) % p for i in range(5)]

    def lin_inv_weight(r, p):
        inv = inv_menu(r, p)
        return [
            (
                inv["p1"] * r[i]
                + inv["pm1"] * r[(i + 1) % 5]
                + inv["e11"] * r[(i + 2) % 5]
            )
            % p
            for i in range(5)
        ]

    def p1_minus(r, p):
        p1 = sum(r) % p
        return [(p1 - r[i]) % p for i in range(5)]

    def cube_diff(r, p):
        return [
            (pow(r[i], 3, p) - pow(r[(i + 1) % 5], 3, p)) % p for i in range(5)
        ]

    named_fns = {
        "inv_diff": inv_diff,
        "disc_like": disc_like,
        "a_eq_c": a_eq_c,
        "skip_diff": skip_diff,
        "centered": centered,
        "ratio_quad_b_sigma_b": ratio_quad,
        "additive_quad_b_sigma_b": add_quad,
        "linear_invariant_weights": lin_inv_weight,
        "p1_minus_ri": p1_minus,
        "cube_diff": cube_diff,
    }
    for name, fn in named_fns.items():
        ok, saw = identity_zero_av(fn, trials=6, seed=9000 + hash(name) % 1000)
        assert saw, name
        assert ok is False, f"named formula unexpectedly identity: {name}"
        assert named["cases"][name]["verdict"] == "empty_scoped"

    print("VERIFY: re-running additive H90 K...", flush=True)
    add = screens["additive_h90_k_scaled"]
    assert add["verdict"] == "empty_scoped"
    monoms = uniq_monoms(1)
    menu_add = ["1", "p1", "pm1", "e11", "p2", "e13", "p1p1", "pm1e11"]
    tested_add = 0
    for e in monoms:
        for cn in menu_add:
            tested_add += 1

            def make(r, p, e=e, cn=cn):
                inv = inv_menu(r, p)
                c = inv[cn]
                return orbit_from_terms([(c, e), ((-c) % p, sigma_exp(e))], r, p)

            ok, saw = identity_zero_av(
                make, trials=3, seed=11000 + tested_add, primes=(31, 41, 61, 71, 101)
            )
            if saw:
                assert ok is False
    assert tested_add == add["tested"], (tested_add, add["tested"])

    print("VERIFY: re-running multiplicative H90 K...", flush=True)
    mul = screens["multiplicative_h90_k_scaled"]
    assert mul["verdict"] == "empty_scoped"
    tested_mul = 0
    menu_mul = ["1", "p1", "pm1", "e11"]
    for e in monoms:
        se = sigma_exp(e)
        de = tuple(e[i] - se[i] for i in range(5))
        if not any(de) or degenerate_diagonal(de):
            continue
        for cn in menu_mul:
            tested_mul += 1

            def make(r, p, de=de, cn=cn):
                inv = inv_menu(r, p)
                return orbit_from_terms([(inv[cn], de)], r, p)

            ok, saw = identity_zero_av(
                make, trials=3, seed=12000 + tested_mul, primes=(31, 41, 61, 71, 101)
            )
            if saw:
                assert ok is False
    assert tested_mul == mul["tested"], (tested_mul, mul["tested"])

    print("VERIFY: re-running binary ratio menu...", flush=True)
    binary = screens["binary_ratio_invariant_menu"]
    assert binary["verdict"] == "empty_scoped"
    menu_s = ["p1", "pm1", "e11", "p2", "e13", "p1pm1", "e11e11", "s_e12e21"]
    tested_b = 0
    for e in monoms:
        for sn in menu_s:
            tested_b += 1

            def make(r, p, e=e, sn=sn):
                inv = inv_menu(r, p)
                return orbit_from_terms([(1, (0, 0, 0, 0, 0)), (inv[sn], e)], r, p)

            ok, saw = identity_zero_av(
                make, trials=3, seed=13000 + tested_b, primes=(31, 41, 61, 71, 101)
            )
            if saw:
                assert ok is False
    assert tested_b == binary["tested"], (tested_b, binary["tested"])

    print("VERIFY: re-running two-support K...", flush=True)
    two = screens["two_support_k_coeffs"]
    assert two["verdict"] == "empty_scoped"
    cmenu = two["coeff_menu"]
    tested_two = 0
    for i, e1 in enumerate(monoms):
        for e2 in monoms[i:]:
            if e1 == e2:
                continue
            for c1 in cmenu:
                for c2 in cmenu:
                    tested_two += 1

                    def make(r, p, e1=e1, e2=e2, c1=c1, c2=c2):
                        inv = inv_menu(r, p)
                        return orbit_from_terms(
                            [(inv[c1], e1), (inv[c2], e2)], r, p
                        )

                    ok, saw = identity_zero_av(
                        make,
                        trials=3,
                        seed=14000 + tested_two,
                        primes=(31, 41, 61, 71, 101),
                    )
                    if saw:
                        assert ok is False
    assert tested_two == two["tested"], (tested_two, two["tested"])

    print("VERIFY: re-running three-cyclic K...", flush=True)
    three = screens["three_cyclic_k_coeffs"]
    assert three["verdict"] == "empty_scoped"
    menu3 = three["coeff_menu"]
    tested_three = 0
    for e in monoms:
        for x, y, z in itertools.product(menu3, repeat=3):
            if (x, y, z) == ("0", "0", "0"):
                continue
            if sum(1 for t in (x, y, z) if t != "0") <= 1:
                continue
            tested_three += 1
            e1 = sigma_exp(e)
            e2 = sigma_exp(e1)

            def make(r, p, e=e, e1=e1, e2=e2, x=x, y=y, z=z):
                inv = inv_menu(r, p)
                return orbit_from_terms(
                    [(inv[x], e), (inv[y], e1), (inv[z], e2)], r, p
                )

            ok, saw = identity_zero_av(
                make,
                trials=3,
                seed=15000 + tested_three,
                primes=(31, 41, 61, 71, 101),
            )
            if saw:
                assert ok is False
    assert tested_three == three["tested"], (tested_three, three["tested"])

    print("VERIFY: re-running four-cyclic K...", flush=True)
    four = screens["four_cyclic_k_coeffs"]
    assert four["verdict"] == "empty_scoped"
    menu4 = ["0", "1", "p1", "pm1", "e11"]
    tested_four = 0
    for e in monoms:
        for coeffs in itertools.product(menu4, repeat=4):
            if all(c == "0" for c in coeffs):
                continue
            if sum(1 for c in coeffs if c != "0") <= 1:
                continue
            tested_four += 1
            exps = []
            cur = e
            for _ in range(4):
                exps.append(cur)
                cur = sigma_exp(cur)

            def make(r, p, exps=tuple(exps), coeffs=coeffs):
                inv = inv_menu(r, p)
                terms = [(inv[c], ex) for c, ex in zip(coeffs, exps) if c != "0"]
                return orbit_from_terms(terms, r, p)

            ok, saw = identity_zero_av(
                make,
                trials=2,
                seed=16000 + tested_four,
                primes=(31, 41, 61, 71, 101),
            )
            if saw:
                assert ok is False
    assert tested_four == four["tested"], (tested_four, four["tested"])

    print("VERIFY: re-running sparse z (full count match + sample refutations)...", flush=True)
    sparse = screens["sparse_z_invariants"]
    assert sparse["verdict"] == "empty_scoped"
    menu_z = sparse["menu"]
    # Full combinatorial re-count
    tested_sparse = 0
    # Full re-run would be long; re-run ALL patterns with trials=2 (same as honesty for emptiness)
    for supp in (1, 2, 3):
        for coords in itertools.combinations(range(5), supp):
            for names in itertools.product(menu_z, repeat=supp):
                tested_sparse += 1

                def make(r, p, coords=coords, names=names):
                    inv = inv_menu(r, p)
                    z = [0] * 5
                    for c, n in zip(coords, names):
                        z[c] = inv[n]
                    return eval_Z_orbit(z, r, p)

                ok, saw = identity_zero_av(
                    make,
                    trials=2,
                    seed=17000 + tested_sparse,
                    primes=(31, 41, 61, 71, 101),
                )
                if saw:
                    assert ok is False, (coords, names)
    assert tested_sparse == sparse["tested"], (tested_sparse, sparse["tested"])

    print("VERIFY: re-running local cyclic poly...", flush=True)
    local = screens["local_cyclic_poly"]
    assert local["verdict"] == "empty_scoped"
    basis = []
    for e0 in range(0, 3):
        for e1 in range(0, 3 - e0):
            for e2 in range(0, 3 - e0 - e1):
                basis.append((e0, e1, e2))
    assert local["basis_size"] == len(basis)
    tested_local = 0
    for supp in range(1, 4):
        for idxs in itertools.combinations(range(len(basis)), supp):
            for signs in itertools.product([-1, 1], repeat=supp):
                coeffs = [0] * len(basis)
                for j, s in zip(idxs, signs):
                    coeffs[j] = s
                tested_local += 1
                ct = tuple(coeffs)

                def make(r, p, coeffs=ct):
                    avals = []
                    for i in range(5):
                        val = 0
                        for (e0, e1, e2), c in zip(basis, coeffs):
                            if c:
                                val = (
                                    val
                                    + c
                                    * pow(r[i], e0, p)
                                    * pow(r[(i + 1) % 5], e1, p)
                                    * pow(r[(i + 2) % 5], e2, p)
                                ) % p
                        avals.append(val)
                    return avals

                ok, saw = identity_zero_av(
                    make,
                    trials=2,
                    seed=18000 + tested_local,
                    primes=(31, 41, 61, 71, 101),
                )
                if saw:
                    assert ok is False
    assert tested_local == local["tested"], (tested_local, local["tested"])

    print("VERIFY: projection geometry...", flush=True)
    proj = json.loads((HERE / "projection.json").read_text())
    assert proj["all_skip_one_checks_ok"] is True
    assert proj["K_point_found_via_projection"] is None
    assert proj["galois_descent"]["linear_conic_sections_found"] == 0
    rng = random.Random(12345)
    for p in (31, 41, 89, 199):
        for i in range(5):
            for _ in range(30):
                s = rng.randrange(p)
                t = rng.randrange(p)
                if s == 0 and t == 0:
                    continue
                x = [0] * 5
                x[i] = s
                x[(i + 2) % 5] = t
                assert klein_F(x, p) == 0
        # consecutive not on F
        x = [0] * 5
        x[0] = 1
        x[1] = 1
        assert klein_F(x, p) != 0
    # residual eq sample: linear sections empty — spot-check no small linear section
    # (already in payload; re-search tiny box)
    for coeffs in itertools.product(range(-1, 2), repeat=6):
        if all(c == 0 for c in coeffs):
            continue
        au, av, aw, bu, bv, bw = coeffs
        identity = True
        for p in (31, 41):
            for _ in range(10):
                u, v, w = [rng.randrange(p) for _ in range(3)]
                s = (au * u + av * v + aw * w) % p
                t = (bu * u + bv * v + bw * w) % p
                val = (
                    u * (s * s % p)
                    + (w * w % p) * s
                    + v * (t * t % p)
                    + (u * u % p) * t
                    + (v * v % p) * w
                ) % p
                if val != 0:
                    identity = False
                    break
            if not identity:
                break
        assert identity is False

    print("VERIFY: modular samples...", flush=True)
    modular = json.loads((HERE / "modular_screen.json").read_text())
    for row in modular["rows"]:
        sample = row.get("sample")
        if not sample:
            continue
        p = row["prime"]
        rr, z = sample["r"], sample["z"]
        assert phi_from_orbit(eval_Z_orbit(z, rr, p), rr, p) == 0
        assert any(z)

    # STATUS
    status = (HERE / "STATUS.md").read_text()
    assert "H5-UNDECIDED" in status
    assert "OPEN" in status

    # Seal if present
    seal_path = HERE / "SEAL.json"
    if seal_path.is_file():
        seal = json.loads(seal_path.read_text())
        assert seal["format"] == "H5-WAVE2-SEAL-v1"
        assert seal["exit"] == "H5-UNDECIDED"
        durable = {
            path.relative_to(HERE).as_posix(): digest(path)
            for path in HERE.rglob("*")
            if path.is_file()
            and path.name != "SEAL.json"
            and path.suffix != ".pyc"
            and "__pycache__" not in path.parts
            and path.name != ".DS_Store"
        }
        assert durable == seal["files"], sorted(set(durable) ^ set(seal["files"]))

    print("H5_WAVE2_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
