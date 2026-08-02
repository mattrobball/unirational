#!/usr/bin/env python3
"""Phi cubic API for G3A: evaluation, polarization, derivatives, specialization.

Coefficients are consumed from goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json.
Independent reconstruction is performed by verify_phi.py against the Klein
frame source, not by trusting this module alone.
"""

from __future__ import annotations

import itertools
import json
from fractions import Fraction
from pathlib import Path
from typing import Sequence

ROOT = Path(__file__).resolve().parents[3]
GENERIC_CUBIC = ROOT / "goals_2026-08-01" / "G_ALL_DEGREE" / "generic_cubic.json"
FRAME_DEGREES = (1, 4, 5, 6, 7)
FRAME_NAMES = ("x", "C", "D", "E", "K_7")
PRIMARY_DEGREES = (3, 5, 6, 8, 11)
SECONDARY_DEGREES = (0, 7, 9, 10, 12, 14, 14, 16, 18, 19, 21, 28)


def load_generic_cubic(path: Path = GENERIC_CUBIC) -> dict:
    payload = json.loads(path.read_text())
    if payload.get("schema") != "G_GENERIC_KLEIN_CUBIC_V1":
        raise ValueError("unexpected generic_cubic schema")
    if payload.get("coefficient_count") != 35:
        raise ValueError("expected 35 coefficients")
    return payload


def all_triples():
    return list(itertools.combinations_with_replacement(range(5), 3))


def coefficient_map(payload: dict | None = None) -> dict:
    payload = payload or load_generic_cubic()
    out = {}
    for item in payload["coefficients"]:
        triple = tuple(item["triple"])
        out[triple] = item
    return out


def phi_homogeneous(a: Sequence, payload: dict | None = None):
    """Evaluate Phi as a symbolic/numeric combination of triple products.

    ``a`` is a length-5 sequence of ring elements supporting +, *, and scaling
    by rationals. Returns sum over triples of multinom * c_{ijk} * a_i a_j a_k
    with the usual symmetric identification (stored as nondecreasing triples).
    """

    payload = payload or load_generic_cubic()
    cmap = coefficient_map(payload)
    # Build full symmetric tensor from nondecreasing triples
    total = 0
    for i, j, k in itertools.product(range(5), repeat=3):
        triple = tuple(sorted((i, j, k)))
        item = cmap[triple]
        # multiplicity: how many ordered triples map to this sorted triple
        # Coefficient in generic_cubic is the actual monomial coefficient for
        # the labeled product frame_i*frame_j*frame_k in the expanded F(sum a_r f_r)
        # with nondecreasing labeling — use the same convention as the producer:
        # each stored triple contributes its scalar times a_i*a_j*a_k once for
        # that ordered nondecreasing triple only. Full evaluation expands all
        # ordered products via polarization-aware sum:
        pass
    # Correct evaluation: Phi(a) = sum_{0<=i<=j<=k<=4} c_ijk * m_ijk * a_i a_j a_k
    # where m_ijk is 1,3,6 for (iii),(iij),(ijk) distinct patterns and c is
    # the stored expansion coefficient for that multiset (already includes
    # combinatorial factors from the Klein expansion). Match verify path:
    # the authoritative definition is F(sum a_r frame_r) expanded.
    # Here we use the polarization form:
    #   Phi(a) = B(a,a,a) where B is the trilinear form with B(e_i,e_j,e_k)=c_sorted / aut
    #
    # Practical API used by G3A: sum over all ordered triples of
    #   alpha_{ijk} a_i a_j a_k
    # with alpha symmetric and alpha_{sorted} recovered from stored entries
    # by dividing by the number of distinct permutations.
    alphas = {}
    for item in payload["coefficients"]:
        triple = tuple(item["triple"])
        # Represent coefficient as list of (scalar, secondary, primary_exponents)
        # For pure evaluation of the abstract cubic form over a base ring that
        # already embeds K_proj, we only need a ring homomorphism applied later.
        # Store the raw Fraction sum of numer/denom as abstract K element handle:
        alphas[triple] = item
    acc = 0
    for i, j, k in itertools.product(range(5), repeat=3):
        triple = tuple(sorted((i, j, k)))
        item = alphas[triple]
        # multinomial: stored coefficient multiplies the monomial a_i a_j a_k
        # for one ordered nondecreasing triple in the producer's expansion.
        # Authoritative evaluation uses ordered sum with 1/sym factor:
        # sym = |S3|/|Aut| 
        from collections import Counter
        cnt = Counter(triple)
        aut = 1
        for v in cnt.values():
            aut *= {1: 1, 2: 2, 3: 6}[v]
        # Number of ordered triples with sorted form `triple`:
        n_ord = 6 // aut
        # Each ordered (i,j,k) contributes stored_c / n_ord if we want
        # sum_ordered (stored/n_ord) a_i a_j a_k = stored * a_i a_j a_k for the
        # nondecreasing representative only. Simpler: only accumulate on
        # nondecreasing ordered indices.
        if (i, j, k) != triple:
            continue
        # Use first normalized entry sum as symbolic placeholder is wrong for
        # full K_proj. Callers that need the K_proj element should use
        # `coefficient_kproj_entries`. For ring elements a_i, treat coefficient
        # as applied externally.
        # For derivative APIs over QQ, specialize coefficients to QQ via
        # secondary=0 primary-only terms:
        scalar = Fraction(0)
        for entry in item["normalized_entries"]:
            # Specialization: set all positive-degree secondaries to 0 and
            # t-variables to 1 for a pure-QQ smoke model — NOT used for seal.
            if entry["secondary"] == 0 and sum(entry["projective_exponents"]) == 0:
                scalar += Fraction(entry["numerator"], entry["denominator"])
        acc = acc + scalar * a[i] * a[j] * a[k]
    return acc


def coefficient_entries(triple: tuple, payload: dict | None = None) -> list:
    payload = payload or load_generic_cubic()
    return coefficient_map(payload)[tuple(sorted(triple))]["normalized_entries"]


def polarization_B(u, v, w, payload: dict | None = None):
    """Symmetric trilinear polarization on the secondary-0 constant slice.

    Independent coefficient reconstruction is owned by verify_phi (Klein frame).
    This API is for derivative/polarization smoke checks only.
    """

    payload = payload or load_generic_cubic()
    cmap = coefficient_map(payload)

    def coeff_scalar_specialized(item, t_values=(1, 1, 1, 1)):
        """Evaluate secondary-0 slice at t3=t6=t8=t11=1."""

        s = Fraction(0)
        t3, t6, t8, t11 = t_values
        for entry in item["normalized_entries"]:
            if entry["secondary"] != 0:
                continue
            e3, e6, e8, e11 = entry["projective_exponents"]
            mon = (t3**e3) * (t6**e6) * (t8**e8) * (t11**e11)
            s += Fraction(entry["numerator"], entry["denominator"]) * mon
        return s

    total = Fraction(0)
    for i, j, k in itertools.product(range(5), repeat=3):
        triple = tuple(sorted((i, j, k)))
        item = cmap[triple]
        coef = coeff_scalar_specialized(item)
        from collections import Counter

        cnt = Counter(triple)
        aut = 1
        for multiplicity in cnt.values():
            aut *= {1: 1, 2: 2, 3: 6}[multiplicity]
        n_ord = 6 // aut
        total += (coef / n_ord) * u[i] * v[j] * w[k]
    return total


def first_partials_specialized(a: Sequence, payload: dict | None = None):
    """∂Phi/∂a_r at a, with coefficients specialized to constant secondary-0 terms."""

    # d/da_r Phi = 3 B(e_r, a, a)
    out = []
    for r in range(5):
        e = [0] * 5
        e[r] = 1
        out.append(3 * polarization_B(e, a, a, payload))
    return out


def second_partials_specialized(a: Sequence, payload: dict | None = None):
    """Hessian matrix 6 B(e_i, e_j, a)."""

    H = [[0 for _ in range(5)] for _ in range(5)]
    for i in range(5):
        for j in range(5):
            ei = [0] * 5
            ei[i] = 1
            ej = [0] * 5
            ej[j] = 1
            H[i][j] = 6 * polarization_B(ei, ej, a, payload)
    return H


def specialize_entries_mod_p(item: dict, prime: int, t_values=(1, 1, 1, 1)) -> int:
    """Evaluate a K_proj coefficient at t3,t6,t8,t11 and reduce secondaries only if 0.

    Only constant (secondary index 0) terms with projective monomials in t's
    are retained — sufficient for modular Jacobian smoke checks after setting
    higher secondary generators to 0 (a specialization, not generic).
    """

    total = 0
    t3, t6, t8, t11 = t_values
    for entry in item["normalized_entries"]:
        if entry["secondary"] != 0:
            continue
        e3, e6, e8, e11 = entry["projective_exponents"]
        mon = pow(t3, e3, prime) * pow(t6, e6, prime) * pow(t8, e8, prime) * pow(
            t11, e11, prime
        )
        mon %= prime
        num = entry["numerator"] % prime
        den = entry["denominator"] % prime
        if den == 0:
            raise ZeroDivisionError("denominator zero at specialization")
        total = (total + num * mon * pow(den, -1, prime)) % prime
    return total


def jacobian_matrix_specialized(a: Sequence[int], prime: int, payload: dict | None = None):
    """Jacobian row (∂Phi/∂a_i) as integers mod prime at point a, secondary-0 slice."""

    payload = payload or load_generic_cubic()
    cmap = coefficient_map(payload)
    # Build full symmetric cubic tensor alpha_ijk mod p on secondary-0 slice
    alpha = [[[0] * 5 for _ in range(5)] for _ in range(5)]
    for item in payload["coefficients"]:
        i, j, k = item["triple"]
        c = specialize_entries_mod_p(item, prime)
        from collections import Counter
        triple = (i, j, k)
        cnt = Counter(triple)
        aut = 1
        for v in cnt.values():
            aut *= {1: 1, 2: 2, 3: 6}[v]
        n_ord = 6 // aut
        # assign to all ordered permutations
        for oi, oj, ok in set(itertools.permutations(triple)):
            alpha[oi][oj][ok] = (c * pow(n_ord, -1, prime)) % prime if n_ord % prime else 0
            # if n_ord not invertible weird — for our aut values n_ord in {1,3,6}
            if n_ord % prime == 0:
                # distribute evenly when possible
                alpha[oi][oj][ok] = c  # fallback only when triple fully repeated n_ord=1
    # Fix: properly fill all permutations of each stored triple
    alpha = [[[0] * 5 for _ in range(5)] for _ in range(5)]
    for item in payload["coefficients"]:
        triple = tuple(item["triple"])
        c = specialize_entries_mod_p(item, prime)
        perms = list(set(itertools.permutations(triple)))
        share = (c * pow(len(perms), -1, prime)) % prime
        for oi, oj, ok in perms:
            alpha[oi][oj][ok] = share
    # ∂Phi/∂a_r = sum_{j,k} 3? actually Phi = sum_{ijk} alpha_ijk a_i a_j a_k with alpha symmetric
    # so ∂/∂a_r = 3 sum_{j,k} alpha_rjk a_j a_k
    jac = []
    for r in range(5):
        s = 0
        for j in range(5):
            for k in range(5):
                s = (s + 3 * alpha[r][j][k] * a[j] * a[k]) % prime
        jac.append(s)
    return jac
