#!/usr/bin/env python3
"""Produce the exact invariant-field and cyclic trace model for Goal H4.

Only standard-library arithmetic is used.  The finite-field witnesses are
not the proof of the characteristic-zero identities; they are deterministic
anchors for the formula-level lattice, covariance, and frame calculations
recorded in the accompanying Markdown files.
"""

from __future__ import annotations

from hashlib import sha256
import itertools
import json
from pathlib import Path
import random


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PINNED_STATE = "35fa8f59b6a1423cc89300aeaceefe91552be5ba"
CURRENT_STATE = "37d61c19a108781cf74af837e24810a9f7f7c3be"

GOAL = ROOT / "goals_after_35fa8f" / "GOAL_H4_11_5_GENERIC_TWIST.md"
CANONICAL_DIR = ROOT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
TWISTS = CANONICAL_DIR / "twists.json"
BRIDGE = CANONICAL_DIR / "BRIDGE.md"
WEIL = ROOT / "certificates" / "exact_weil_check.py"
EXACT_STRATA = ROOT / "certificates" / "strata" / "exact_strata.py"
NORMAL_CHARACTERS = ROOT / "certificates" / "strata" / "normal_characters.py"

EXPECTED_HASHES = {
    "goal": "8b2e48f89ebc8daa971e618d341390e6803d21f22f411b88abb3dcc28cf0ef2f",
    "twists": "e97a32d6f22a8028528bc2b4d27ee009901caeb047fd2ffe5ac2bdd1fab743cd",
    "bridge": "660577dd5848eb5f9acb747b4c82877968d3ba5c59181581eb4ba8907d8aa2f8",
    "exact_weil": "14c9bda195ccc39e3ae2cd6d6d42bbb8f45397e114b5137947fb41dd665cc2b2",
    "exact_strata": "a630b3a85d41eb0b60902a81cf8851c15fd0aa9c615c2d8a36584071dca34810",
    "normal_characters": "8cb2a9a7d8b0405672308fc300cecd639de994cd73e29ef272328fa919e5b671",
}

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


def write_json(name: str, value: object) -> None:
    (HERE / name).write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def identity(n: int) -> list[list[int]]:
    return [[int(i == j) for j in range(n)] for i in range(n)]


def mmul(a: list[list[int]], b: list[list[int]], p: int) -> list[list[int]]:
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) % p for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def madd(a: list[list[int]], b: list[list[int]], p: int) -> list[list[int]]:
    return [[(x + y) % p for x, y in zip(ra, rb)] for ra, rb in zip(a, b)]


def mscale(c: int, a: list[list[int]], p: int) -> list[list[int]]:
    return [[c * x % p for x in row] for row in a]


def mpow(a: list[list[int]], n: int, p: int) -> list[list[int]]:
    out = identity(len(a))
    while n:
        if n & 1:
            out = mmul(out, a, p)
        a = mmul(a, a, p)
        n //= 2
    return out


def minverse(a: list[list[int]], p: int) -> list[list[int]]:
    n = len(a)
    work = [row[:] + identity(n)[i] for i, row in enumerate(a)]
    for column in range(n):
        pivot = next(i for i in range(column, n) if work[i][column] % p)
        work[column], work[pivot] = work[pivot], work[column]
        scale = pow(work[column][column], -1, p)
        work[column] = [scale * x % p for x in work[column]]
        for i in range(n):
            if i == column:
                continue
            scale = work[i][column]
            work[i] = [(x - scale * y) % p for x, y in zip(work[i], work[column])]
    return [row[n:] for row in work]


def determinant(a: list[list[int]], p: int) -> int:
    work = [row[:] for row in a]
    out = 1
    for column in range(len(work)):
        pivot = next((i for i in range(column, len(work)) if work[i][column] % p), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            out = -out
        value = work[column][column] % p
        out = out * value % p
        inv = pow(value, -1, p)
        for i in range(column + 1, len(work)):
            scale = work[i][column] * inv % p
            for j in range(column, len(work)):
                work[i][j] = (work[i][j] - scale * work[column][j]) % p
    return out % p


def mv(a: list[list[int]], v: list[int], p: int) -> list[int]:
    return [sum(a[i][j] * v[j] for j in range(len(v))) % p for i in range(len(a))]


def matrix_key(a: list[list[int]]) -> tuple[int, ...]:
    return tuple(x for row in a for x in row)


def monomial_group(p: int, zeta11: int) -> tuple[list[list[int]], list[list[int]], list[list[list[int]]]]:
    t = [[pow(zeta11, WEIGHTS[i], p) if i == j else 0 for j in range(5)] for i in range(5)]
    shift = [[int(i == (j + 1) % 5) for j in range(5)] for i in range(5)]
    group = [mmul(mpow(t, a, p), mpow(shift, b, p), p) for a in range(11) for b in range(5)]
    assert len({matrix_key(h) for h in group}) == 55
    assert mpow(t, 11, p) == identity(5)
    assert mpow(shift, 5, p) == identity(5)
    assert mmul(mmul(shift, t, p), minverse(shift, p), p) == mpow(t, 5, p)
    return t, shift, group


def canonical_frame(y: list[int], p: int, zeta11: int) -> tuple[list[list[int]], int] | None:
    _, _, group = monomial_group(p, zeta11)
    ell = (1, 2, 3, 4, 5)
    out = [[0] * 5 for _ in range(5)]
    denominator_product = 1
    for h in group:
        moved = mv(minverse(h, p), y, p)
        denominator = sum(a * b for a, b in zip(ell, moved)) % p
        if denominator == 0:
            return None
        denominator_product = denominator_product * denominator % p
        c = moved[0] * pow(denominator, -1, p) % p
        out = madd(out, mscale(c, h, p), p)
    return out, denominator_product


def compositions(total: int, length: int):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, length - 1):
            yield (first,) + rest


def cubic_coefficients(frame: list[list[int]], p: int) -> dict[str, int]:
    out = {exponents: 0 for exponents in compositions(3, 5)}
    for i in range(5):
        for j, k, ell in itertools.product(range(5), repeat=3):
            exponents = [0] * 5
            exponents[j] += 1
            exponents[k] += 1
            exponents[ell] += 1
            key = tuple(exponents)
            out[key] = (out[key] + frame[i][j] * frame[i][k] * frame[(i + 1) % 5][ell]) % p
    return {",".join(map(str, key)): value for key, value in sorted(out.items()) if value}


def r_beta(y: list[int], p: int) -> tuple[list[int], list[int], int]:
    r = [
        y[(i + 1) % 5] * y[(i + 2) % 5] * pow(y[i], -2, p) % p
        for i in range(5)
    ]
    beta = [y[(i + 2) % 5] * pow(y[(i + 3) % 5], -1, p) % p for i in range(5)]
    b = r[0] ** 2 * r[1] * r[3] ** 4 * pow(r[2], -4, p) % p
    return r, beta, b


def trace_frame(y: list[int], p: int) -> tuple[list[list[int]], list[int], list[int], int]:
    r, beta, b = r_beta(y, p)
    frame = [[beta[i] * pow(r[i], j, p) % p for j in range(5)] for i in range(5)]
    return frame, r, beta, b


def trace_coefficients(r: list[int], p: int) -> dict[str, int]:
    out = {exponents: 0 for exponents in compositions(3, 5)}
    for i in range(5):
        c = pow(r[(i + 2) % 5], -1, p)
        left = [pow(r[i], j, p) for j in range(5)]
        right = [pow(r[(i + 1) % 5], j, p) for j in range(5)]
        for j, k, ell in itertools.product(range(5), repeat=3):
            exponents = [0] * 5
            exponents[j] += 1
            exponents[k] += 1
            exponents[ell] += 1
            key = tuple(exponents)
            out[key] = (out[key] + c * left[j] * left[k] * right[ell]) % p
    return {",".join(map(str, key)): value for key, value in sorted(out.items()) if value}


def vandermonde(r: list[int], p: int) -> int:
    out = 1
    for i in range(5):
        for j in range(i + 1, 5):
            out = out * (r[j] - r[i]) % p
    return out


def common_open_witness() -> dict[str, object]:
    p = 89
    zeta11 = 2
    t, shift, _ = monomial_group(p, zeta11)
    randomizer = random.Random(1155)
    for _ in range(10000):
        y = [randomizer.randrange(1, p) for _ in range(5)]
        built = canonical_frame(y, p, zeta11)
        if built is None:
            continue
        canonical, denominator_product = built
        if not determinant(canonical, p):
            continue
        trace, r, beta, b = trace_frame(y, p)
        if len(set(r)) != 5 or not determinant(trace, p):
            continue
        transition = mmul(minverse(canonical, p), trace, p)
        if not determinant(transition, p):
            continue
        for generator in (t, shift):
            moved_y = mv(generator, y, p)
            moved_canonical_data = canonical_frame(moved_y, p, zeta11)
            assert moved_canonical_data is not None
            moved_canonical, _ = moved_canonical_data
            moved_trace, _, _, _ = trace_frame(moved_y, p)
            assert moved_canonical == mmul(generator, canonical, p)
            assert moved_trace == mmul(generator, trace, p)
            assert mmul(minverse(moved_canonical, p), moved_trace, p) == transition
        trace_coeffs = trace_coefficients(r, p)
        assert trace_coeffs == cubic_coefficients(trace, p)
        assert determinant(trace, p) == vandermonde(r, p)
        assert beta[0] ** 11 % p == b
        assert beta[1] == pow(r[2] * beta[0] ** 2, -1, p)
        return {
            "prime": p,
            "zeta11": zeta11,
            "source_point": y,
            "canonical_denominator_product": denominator_product,
            "canonical_frame_determinant": determinant(canonical, p),
            "trace_frame_determinant": determinant(trace, p),
            "vandermonde": vandermonde(r, p),
            "transition_determinant": determinant(transition, p),
            "r": r,
            "beta_conjugates": beta,
            "beta_11": b,
            "transition_A_inverse_B": transition,
            "trace_twist_coefficients": trace_coeffs,
        }
    raise AssertionError("no common-open witness")


def dft_witness() -> dict[str, object]:
    p = 331
    epsilon = next(x for x in range(2, p) if pow(x, 5, p) == 1 and x != 1)
    r_coordinates = [1, 2, 7, 19, 43]
    s = [
        sum(pow(epsilon, -i * j, p) * r_coordinates[i] for i in range(5)) % p
        for j in range(5)
    ]
    assert s[0] and s[1]
    q = [1] + [s[j] * pow(s[0], -1, p) % p for j in range(1, 5)]
    invariants = [
        pow(q[1], 5, p),
        q[2] * pow(q[1], -2, p) % p,
        q[3] * pow(q[1], -3, p) % p,
        q[4] * pow(q[1], -4, p) % p,
    ]
    shifted = r_coordinates[1:] + r_coordinates[:1]
    shifted_s = [
        sum(pow(epsilon, -i * j, p) * shifted[i] for i in range(5)) % p
        for j in range(5)
    ]
    shifted_q = [1] + [shifted_s[j] * pow(shifted_s[0], -1, p) % p for j in range(1, 5)]
    shifted_invariants = [
        pow(shifted_q[1], 5, p),
        shifted_q[2] * pow(shifted_q[1], -2, p) % p,
        shifted_q[3] * pow(shifted_q[1], -3, p) % p,
        shifted_q[4] * pow(shifted_q[1], -4, p) % p,
    ]
    assert shifted_invariants == invariants
    reconstructed_q = [
        1,
        q[1],
        invariants[1] * q[1] ** 2 % p,
        invariants[2] * q[1] ** 3 % p,
        invariants[3] * q[1] ** 4 % p,
    ]
    inverse_five = pow(5, -1, p)
    reconstructed = [
        inverse_five * sum(pow(epsilon, i * j, p) * reconstructed_q[j] for j in range(5)) % p
        for i in range(5)
    ]
    scale = reconstructed[0] * pow(r_coordinates[0], -1, p) % p
    assert reconstructed == [scale * x % p for x in r_coordinates]
    return {
        "prime": p,
        "epsilon5": epsilon,
        "projective_R": r_coordinates,
        "fourier_s": s,
        "fourier_ratios": q[1:],
        "invariants_U": invariants,
        "shifted_invariants_U": shifted_invariants,
        "inverse_dft_projective_scale": scale,
    }


def main() -> None:
    input_paths = {
        "goal": GOAL,
        "twists": TWISTS,
        "bridge": BRIDGE,
        "exact_weil": WEIL,
        "exact_strata": EXACT_STRATA,
        "normal_characters": NORMAL_CHARACTERS,
    }
    actual_hashes = {name: digest(path) for name, path in input_paths.items()}
    assert actual_hashes == EXPECTED_HASHES

    source = json.loads(TWISTS.read_text())
    record = next(item for item in source["records"] if item["label"] == "11:5")
    assert record["order"] == 55
    assert record["generators"] == [[1, 1, 0, 1], [2, 0, 0, 6]]

    anchor = record["good_reduction"]
    built = canonical_frame(anchor["source_point"], anchor["prime"], anchor["zeta11"])
    assert built is not None
    frame, denominator_product = built
    assert denominator_product == anchor["denominator_product"] == 86
    assert frame == anchor["frame"]
    assert determinant(frame, anchor["prime"]) == anchor["frame_determinant"] == 87
    assert cubic_coefficients(frame, anchor["prime"]) == anchor["specialized_twist_coefficients"]

    common = common_open_witness()
    fourier = dft_witness()

    field_model = {
        "format": "H-11_5-INVARIANT-FIELD-v1",
        "constant_field": "C containing zeta_11 and epsilon_5",
        "group": {
            "presentation": "H=<T,P | T^11=P^5=1, P*T*P^-1=T^5>",
            "T_weights": list(WEIGHTS),
            "P_action": "P(e_i)=e_(i+1), hence (P y)_i=y_(i-1)",
            "authoritative_generators_psl2_f11": record["generators"],
            "chosen_generators_inside_same_H": {
                "T": "rho([1,2,0,1]) = rho([1,1,0,1])^2",
                "P": "rho([4,0,0,3]) = rho([2,0,0,6])^2",
            },
        },
        "fields": {
            "L": "C(P(W))",
            "E": "L^<T> = C(r0,...,r4)/(r0*r1*r2*r3*r4-1)",
            "K": "L^H = E^<sigma> = C(U1,U2,U3,U4)",
            "degrees": {"L_over_E": 11, "E_over_K": 5, "L_over_K": 55},
        },
        "C11_invariants": {
            "formula": "r_i=y_(i+1)*y_(i+2)/y_i^2, indices modulo 5",
            "exponent_vectors": [list(row) for row in R_EXPONENTS],
            "product_relation": "product_i r_i=1",
            "four_by_four_exponent_determinant": 11,
            "sigma_action": "sigma(f)(y)=f(P^-1 y); sigma(r_i)=r_(i+1)",
        },
        "rational_C5_quotient": {
            "R_coordinates": "[R0:...:R4]=[1:r0^-1:(r0*r1)^-1:(r0*r1*r2)^-1:(r0*r1*r2*r3)^-1]",
            "ratio": "r_i=R_i/R_(i+1)",
            "action": "sigma[R_i]=[R_(i+1)]",
            "fourier": "s_j=sum_i epsilon_5^(-i*j) R_i; q_j=s_j/s_0",
            "diagonal_action": "sigma(q_j)=epsilon_5^j*q_j",
            "transcendence_basis": {
                "U1": "q1^5",
                "U2": "q2/q1^2",
                "U3": "q3/q1^3",
                "U4": "q4/q1^4",
            },
            "forward_extension": "E=K(alpha), alpha=q1, alpha^5=U1; q_j=U_j*alpha^j for j=2,3,4",
            "inverse_DFT": "[R_i]=[1+sum_(j=1)^4 epsilon_5^(i*j) q_j] (common factor 1/5 omitted)",
            "common_open": "product_i(y_i)*s0*q1*product_i(R_i) != 0",
        },
        "finite_field_inverse_map_witness": fourier,
        "authoritative_input_hashes": actual_hashes,
    }

    norm_model = {
        "format": "H-11_5-NORM-TOWER-v1",
        "degree_11_Kummer_generator": {
            "beta": "y2/y3",
            "beta_11": "b=r0^2*r1*r3^4/r2^4",
            "sigma_beta": "1/(r2*beta^2)",
            "reconstruction_on_y0_nonzero": {
                "y1/y0": "r0*r3/(r2*beta^3)",
                "y2/y0": "r2*beta^3/r3",
                "y3/y0": "r2*beta^2/r3",
                "y4/y0": "r2^2*beta^4/r3",
            },
            "compatibility": "sigma(b)=r2^-11*b^-2 and sigma^5(beta)=beta",
        },
        "cyclic_coefficient": {
            "c": "beta^2*sigma(beta)=r2^-1",
            "norm_E_over_K": "product_i sigma^i(c)=1",
            "warning": "norm one does not solve d^2*sigma(d)=c^-1; that is the 2+sigma isogeny, not multiplicative Hilbert 90",
        },
        "coefficient_isogeny_class": {
            "isogeny": "psi(d)=d^2*sigma(d) on Res_(E/K)(G_m)",
            "degree": 33,
            "nontriviality": "psi(d)=r2 has no d in E^*: the divisor equation (2+sigma)D=0 forces D=0, then the Laurent-unit exponent system has no integral solution",
            "order_11_witness": "d=r1*r2^6*r3^-2*r4^2 satisfies psi(d)=r2^11",
            "conclusion": "the class of r2, equivalently of c=r2^-1, has exact order 11 modulo psi(E^*)",
            "point_boundary": "X_T(K) is nonempty iff c*psi(E^*) meets ker(Tr_E/K)",
        },
        "trace_model": {
            "variable": "a in E, written a=Z(r0), Z(T)=z0+z1*T+...+z4*T^4 with z_i in K",
            "equation": "Phi(z)=Tr_E/K(r2^-1*a^2*sigma(a))=sum_i Z(r_i)^2*Z(r_(i+1))/r_(i+2)=0",
            "coefficient_field": "each coefficient is fixed by cyclic permutation, hence lies in K",
        },
        "degree_five_point": {
            "field": "E",
            "polynomial": "Z0(T)=product_(k=1)^4 (T-r_k)",
            "image_under_trace_frame": "[beta0*Z0(r0):0:0:0:0]",
            "scope": "a closed point of degree five over K, not a K-rational point",
        },
        "monomial_screen": {
            "statement": "No nonzero Laurent monomial a in C[r_i^+-1]/(product r_i-1) solves Phi(a)=0",
            "reason": "Phi(a) is the C5-orbit sum of one Laurent monomial; its orbit has size 1 or 5, and distinct Laurent monomials are linearly independent in characteristic zero",
            "scope": "infinite pure-monomial ansatz only; sums and arbitrary rational functions remain",
        },
    }

    twist_model = {
        "format": "H-11_5-CANONICAL-TRACE-EQUIVALENCE-v1",
        "canonical_model": {
            "frame": "A(y)=sum_(h in H) ((rho(h^-1)y)_0 / ell(rho(h^-1)y))*rho(h), ell=y0+2y1+3y2+4y3+5y4",
            "equation": "F(A(y)u)=0",
            "source": "goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json, label 11:5",
            "good_reduction_reproduced": {
                "prime": anchor["prime"],
                "source_point": anchor["source_point"],
                "denominator_product": denominator_product,
                "frame_determinant": determinant(frame, anchor["prime"]),
                "coefficient_count": len(cubic_coefficients(frame, anchor["prime"])),
            },
        },
        "trace_frame": {
            "entries": "B_(i,j)=sigma^i(beta)*r_i^j, 0<=i,j<=4",
            "determinant": "product_i sigma^i(beta) * product_(i<j)(r_j-r_i) = product_(i<j)(r_j-r_i)",
            "covariance": "B(Ty)=T B(y), B(Py)=P B(y)",
            "pullback": "F(B(y)z)=Phi(z)",
        },
        "canonical_transition": {
            "C": "A(y)^-1*B(y) in GL5(K)",
            "forward_norm_to_canonical": "u=C*z",
            "inverse_canonical_to_norm": "z=C^-1*u",
            "identity": "F(A*u)=F(B*z)=Phi(z)",
            "common_open": "product_i(y_i)*product_h ell(rho(h^-1)y)*det(A)*product_(i<j)(r_j-r_i)*s0*q1 != 0",
        },
        "common_open_good_reduction_witness": common,
    }

    decision = {
        "format": "H-11_5-DECISION-v1",
        "exit": "H-11_5-NORM-MODEL-PASS",
        "headline": "OPEN",
        "pinned_state": PINNED_STATE,
        "repository_commit_consumed": CURRENT_STATE,
        "rational_point_over_K": None,
        "valuation_obstruction": None,
        "proved": [
            "minimal rational presentation K=C(U1,U2,U3,U4)",
            "exact degree-5 cyclic and degree-11 Kummer tower with forward and inverse maps",
            "exact trace equation Tr_E/K(r2^-1*a^2*sigma(a))=0",
            "exact invariant transition to the authoritative canonical Hilbert-90 frame",
            "degree-five closed point and index-one boundary",
            "nonexistence of a pure Laurent-monomial trace point",
            "the cyclic coefficient has exact order 11 modulo the degree-33 isogeny d -> d^2*sigma(d)",
        ],
        "not_proved": [
            "a K-rational point",
            "pointlessness over K",
            "an unramified-cohomology obstruction",
            "a decisive valuation",
            "any positive or negative PSL2(F11) headline",
        ],
        "smallest_remaining_theorem": "Decide whether there is a nonzero a in E with Tr_E/K(r2^-1*a^2*sigma(a))=0.",
    }

    write_json("field_model.json", field_model)
    write_json("norm_model.json", norm_model)
    write_json("twist_model.json", twist_model)
    write_json("decision.json", decision)
    print("H_11_5_PRODUCE_OK")


if __name__ == "__main__":
    main()
