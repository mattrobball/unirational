#!/usr/bin/env python3
"""Exact verifier for the finite C11 degree-eight tangent-curve incidence."""

from collections import Counter, defaultdict
import hashlib
from math import gcd
from pathlib import Path


W = (1, 9, 4, 3, 5)
MOD = 11
HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
SOURCE_HASHES = {
    "goal_runs_after_35fa/H_11_5_TWIST/FIELD_MODEL.md":
        "a294d808585cb550cfe60c08559f4a8bc027977bf6292d83833a6efb2e22e745",
    "goal_runs_after_141f60/H6A_PROJECTIVE_11_ISOGENY/ISOGENY.md":
        "f18e94aa13f56887d8658267f5d845ce4d5571cb15331c635ca8a32eb415a7ec",
    "goal_runs_after_141f60/H6_TRACE_CUBIC_DECISION/TRACE_HYPERPLANE_TORSOR.md":
        "37d323de398bade78e8e75abab57bbde7cb0e85f4dda838a58590daef0ffd608",
}


def require(condition, message):
    if not condition:
        raise AssertionError(message)


def residue_vector(m, c):
    return tuple((m * w + c) % MOD for w in W)


def normalize(e):
    lo = min(e)
    return tuple(x - lo for x in e)


def curve_key(e):
    """Cancel endpoint base factors and quotient parameter inversion."""
    e = normalize(e)
    d = max(e)
    reverse = tuple(d - x for x in e)
    return min(e, reverse)


def difference_gcd(e):
    anchor = e[0]
    out = 0
    for x in e[1:]:
        out = gcd(out, abs(x - anchor))
    return out


def pullback_data(e):
    d = max(e)
    n = tuple(2 * e[i] + e[(i + 1) % 5] for i in range(5))
    levels = defaultdict(list)
    for i, value in enumerate(n):
        levels[value].append(i)
    return d, n, dict(sorted(levels.items()))


def verify_sources():
    for relative, expected in SOURCE_HASHES.items():
        path = PROBLEM / relative
        require(path.is_file(), f"missing source: {relative}")
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        require(actual == expected, f"source hash mismatch: {relative}")


def main():
    verify_sources()

    # Klein invariance and order-five semidirect conventions.
    require(all((2 * W[i] + W[(i + 1) % 5]) % MOD == 0 for i in range(5)),
            "Klein cubic is not C11 invariant")
    require(tuple(W[(i - 1) % 5] for i in range(5)) ==
            tuple((5 * w) % MOD for w in W),
            "coordinate-cycle multiplier is not 5")
    require(pow(5, 5, MOD) == 1 and pow(9, 5, MOD) == 1,
            "semilinear multipliers must have order dividing five")
    require(all(pow(q, k, MOD) != 1 for q in (5, 9) for k in range(1, 5)),
            "semilinear multiplier does not have exact order five")

    # Exhaust all affine-character placements.
    all_pairs = [(m, c, residue_vector(m, c))
                 for m in range(1, MOD) for c in range(MOD)]
    require(len(all_pairs) == 110, "wrong affine-character universe")
    raw_upto8 = [(m, c, e) for m, c, e in all_pairs if max(e) <= 8]
    widths = Counter(max(e) - min(e) for _, _, e in raw_upto8)
    require(len(raw_upto8) == 30, "wrong number of raw [0,8] placements")
    require(widths == Counter({7: 20, 8: 10}), "wrong raw width census")

    minimum_width = min(max(e) - min(e) for _, _, e in all_pairs)
    require(minimum_width == 7, "a degree <=6 curve unexpectedly exists")

    normalized_by_degree = {}
    curve_keys_by_degree = {}
    for d in (7, 8):
        oriented = {
            normalize(e)
            for _, _, e in all_pairs
            if max(e) - min(e) == d
        }
        keys = {curve_key(e) for e in oriented}
        require(len(oriented) == 10, f"wrong oriented degree-{d} count")
        require(len(keys) == 5, f"wrong unoriented degree-{d} count")
        require(all(max(e) == d and min(e) == 0 for e in oriented),
                f"degree-{d} normalization failed")
        require(all(difference_gcd(e) == 1 for e in oriented),
                f"degree-{d} map is not birational onto its image")
        normalized_by_degree[d] = oriented
        curve_keys_by_degree[d] = keys

    expected_degree8 = {
        (0, 8, 3, 2, 4),
        (0, 5, 6, 4, 8),
        (2, 4, 0, 8, 3),
        (3, 2, 4, 0, 8),
        (4, 0, 8, 3, 2),
    }
    require(curve_keys_by_degree[8] == expected_degree8,
            "degree-eight representatives changed")

    # All degree-eight pullbacks have exactly two exponent levels, separated
    # by 11, and one level is a singleton.  The trace relation sum A_i=0 then
    # makes the orbit-factor coefficient +/- one nonzero A_j.
    residuals = {}
    for e in sorted(curve_keys_by_degree[8]):
        d, n, levels = pullback_data(e)
        require(d == 8 and len(levels) == 2, "wrong degree-eight levels")
        low, high = tuple(levels)
        require(high - low == 11, "missing orbit factor")
        singleton_levels = [value for value, inds in levels.items()
                            if len(inds) == 1]
        require(len(singleton_levels) == 1,
                "tangency coefficient is not a coordinate monomial")
        single_level = singleton_levels[0]
        j = levels[single_level][0]
        sign = 1 if single_level == high else -1
        s_power = 24 - high
        t_power = low
        require(s_power >= 0 and t_power >= 0 and s_power + t_power == 13,
                "wrong endpoint residual degree")
        residuals[e] = {
            "n": n,
            "j": j,
            "sign": sign,
            "s_power": s_power,
            "t_power": t_power,
        }

    canonical = (0, 8, 3, 2, 4)
    require(residuals[canonical] == {
        "n": (8, 19, 8, 8, 8),
        "j": 1,
        "sign": 1,
        "s_power": 5,
        "t_power": 8,
    }, "canonical pullback is not A1*s^5*t^8*(t^11-s^11)")

    # The degree-seven curves also have the simple orbit factor.  Their
    # coefficient is a nonempty proper subset sum rather than a forced unit;
    # vanishing is the special divisor on which the entire curve lies in X.
    for e in sorted(curve_keys_by_degree[7]):
        d, _, levels = pullback_data(e)
        require(d == 7 and len(levels) == 2, "wrong degree-seven levels")
        low, high = tuple(levels)
        require(high - low == 11, "degree-seven orbit factor missing")
        require(all(0 < len(inds) < 5 for inds in levels.values()),
                "degree-seven subset sum is trivial")

    # C5 acts transitively on the five multiplier classes modulo inversion.
    def sign_class(m):
        return min(m % MOD, (-m) % MOD)

    classes = {sign_class(m) for m in range(1, MOD)}
    require(len(classes) == 5, "wrong F_11^*/+/- census")
    for q in (5, 9):
        orbit = []
        x = sign_class(1)
        for _ in range(5):
            orbit.append(x)
            x = sign_class(q * x)
        require(len(set(orbit)) == 5 and set(orbit) == classes,
                f"multiplier {q} is not transitive on curve types")
        require(q not in (1, MOD - 1),
                "order-five multiplier lies in the PGL2 normalizer image")

    print("PASS three authoritative source hashes")
    print("PASS weights and semidirect multipliers")
    print("PASS 110 affine-character pairs; raw [0,8] census 30 = 20+10")
    print("PASS five degree-7 and five degree-8 curves; none below degree 7")
    print("PASS all five degree-8 tangent incidences saturate to the unit ideal")
    print("PASS canonical pullback A1*s^5*t^8*(t^11-s^11)")
    print("PASS C5 transitively permutes curve types; no individual descent")
    print("C11_DEGREE8_TANGENT_VERIFY_OK")


if __name__ == "__main__":
    main()
