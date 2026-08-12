"""Master weight formula at tuple level — generalisation of STAGE2 Theorem 1.2.

Character arithmetic is prime-free (Z/n).  Modular checks of spectra / F at
p = 331, 661 live in tangent_cone.py and the verifier.

Lemma (tuple-level weight rule; proof quotes Thm 1.2).
----------------------------------------------------
Let T be any G-equivariant reduced landing lift of degree d.  Let S be a
g-fixed source stratum (g of order n) reached by a chain of g-invariant
blowups whose successive relative conormal weights are the characters
χ_ℓ of relative weight c_ℓ ∈ Z/n, and let k_ℓ ≥ 0 be the leading order of T
in the normal direction χ_ℓ (k_ℓ = 0 means the previous leading map is already
non-zero there).  Write a_k for the g-weight of the level-0 centre, and let
the multidegree / tangential slots contribute w_tang ∈ Z/n (for a point
stratum of ambient degree d this is d · a_k; for a positive-dim stratum with
Γ-character ψ and slot characters μ_r of multidegree a_r it is the evaluation
character weight of ψ^{-1} · ∏ μ_r^{a_r}).

Then the value of T at the generic point of S lies in the g-eigenspace of
weight

    w(S)  ≡  w_tang  +  Σ_ℓ  k_ℓ · c_ℓ     (mod n),

or is 0 (undefined along S).  In particular the leading normal jet of
character χ (weight c) at order k maps into the target normal character of
relative weight congruent to the same arithmetic — the combinatorial shadow

    χ′  =  ψ_S · χ^{k} · (slot factors)

in multiplicative notation on X(Γ).

Proof.  Identical to STAGE2 Theorem 1.2 (pinning): Level 0 is the monomial
character congruence (Lemma 1.1 of STAGE2) on the centre; the inductive step
expands in the eigenchart v = e_k + Σ y_j e_j, reads the coefficient of y^ν
from Lemma 1.1, blows up y = s · u, and reads the induced map on the
exceptional divisor.  The only change is that the "degree-d monomial on the
centre" is replaced by the Γ-equivariant multiform of character ψ_S and
multidegree (a_r) on the tangential slots of a positive-dimensional stratum —
the same equivariance T(g v) = g T(v) (Lemma 0.1: G perfect ⇒ no character
twist) produces the same additive formula in Z/n.  Landing (Lemma 0.2) forces
the value onto X.  ∎
"""
from __future__ import annotations

# Spectra of g on W (sealed STAGE2 / RECEIVER_LEDGER_X; rechecked at 331,661).
SPECTRUM = {
    2:  {"weights": (0, 0, 0, 1, 1), "onX": None},  # C2: W+^3 ⊕ W-^2; onX via E/L
    3:  {"weights": (0, 1, 1, 2, 2), "onX": {0: False, 1: True, 2: True}},
    5:  {"weights": (0, 1, 2, 3, 4),
         "onX": {0: False, 1: True, 2: True, 3: True, 4: True}},
    6:  {"weights": (0, 1, 2, 4, 5),
         "onX": {0: False, 1: True, 2: False, 4: False, 5: True}},
    11: {"weights": (1, 3, 4, 5, 9),
         "onX": {1: True, 3: True, 4: True, 5: True, 9: True}},
}
QR11 = (1, 3, 4, 5, 9)


def wset(n):
    return set(SPECTRUM[n]["weights"])


def onX_weights(n):
    ox = SPECTRUM[n]["onX"]
    if ox is None:
        return None
    return {w for w, f in ox.items() if f}


def pathA_weight(n, w_tang, chain):
    """chain = [(k_ℓ, c_ℓ), ...]; closed-form value weight mod n."""
    w = int(w_tang)
    for k, c in chain:
        w += int(k) * int(c)
    return w % n


def pathB_weight_monomial(n, exponents, weights=None):
    """PATH B: monomial weight Σ α_j a_j mod n (Lemma 1.1)."""
    a = weights if weights is not None else SPECTRUM[n]["weights"]
    return sum(int(exponents[j]) * int(a[j]) for j in range(len(a))) % n


def relative_weights(n, a_k):
    """Relative g-weights of T_p P(W) at the weight-a_k eigenpoint."""
    ws = list(SPECTRUM[n]["weights"])
    # remove one copy of a_k (the radial / centre direction)
    removed = False
    out = []
    for w in ws:
        if not removed and w == a_k:
            removed = True
            continue
        out.append((w - a_k) % n)
    return sorted(out)


def forbidden_relative_weight(n, a_value):
    """dF at weight-a eigenpoint of X is supported on weight (-2a);
    ker(dF) drops relative weight (-2a - a) = -3a.  (STAGE2 Prop 6.1.)"""
    return (-3 * a_value) % n


def tangent_characters_X(n, a_value):
    """Relative weights of T_p X at a weight-a eigenpoint on X.

    = relative ambient weights minus the conormal weight -3a.
    Returns None if the eigenpoint is off X.
    """
    ox = SPECTRUM[n]["onX"]
    if ox is not None and not ox.get(a_value, False):
        return None
    amb = relative_weights(n, a_value)
    forb = forbidden_relative_weight(n, a_value)
    return sorted(c for c in amb if c != forb)


def chi_image_weight(n, w_tang, chi_c, k):
    """Image absolute weight of a single normal character χ of rel weight c
    at leading order k, under the master formula."""
    return (int(w_tang) + int(k) * int(chi_c)) % n


def admissible_k_for_value(n, w_tang, chi_c, a_value, kmax=12):
    """Orders k ≥ 1 such that the weight rule lands on the given value weight.

    For a pure one-character normal response (other k_ℓ = 0):
        a_value ≡ w_tang + k · chi_c  (mod n).
    Also admits k = 0 when w_tang ≡ a_value (map already defined non-zero on
    the previous level; whole exceptional fibre takes one value — Thm 1.2
    degenerate case).
    """
    hits = []
    for k in range(0, kmax + 1):
        if chi_image_weight(n, w_tang, chi_c, k) == (a_value % n):
            hits.append(k)
    return hits


def admissible_assignment(n, w_tang, conormal_cs, a_value, kmax=6):
    """All tuples (k_1,...,k_r) with 0 ≤ k_j ≤ kmax such that
        a_value ≡ w_tang + Σ k_j c_j  (mod n).

    Returns list of dicts {c_j: k_j}.  Empty ⇒ value unreachable by the
    weight rule from this conormal set (character incompatibility).
    """
    from itertools import product
    cs = list(conormal_cs)
    if not cs:
        # no normal directions: only the tangential weight
        if (w_tang % n) == (a_value % n):
            return [dict()]
        return []
    out = []
    for ks in product(range(kmax + 1), repeat=len(cs)):
        w = w_tang
        for k, c in zip(ks, cs):
            w += k * c
        if w % n == a_value % n:
            out.append({int(c): int(k) for c, k in zip(cs, ks)})
    return out


def differential_blocks(n, a_src, a_tgt):
    """Relative weights on which a first-order (k=1) normal response can land
    in T_{tgt} X.  STAGE2 Prop 6.1: dT preserves relative weight; target drops
    -3 a_tgt.
    """
    if SPECTRUM[n]["onX"] is not None and not SPECTRUM[n]["onX"].get(a_tgt, False):
        return None
    src = set(relative_weights(n, a_src))
    tgt = set(tangent_characters_X(n, a_tgt) or [])
    return sorted(src & tgt)


def multiplicative_rule_label(psi, chi, k, slots=None):
    """Human / ledger form: χ′ = ψ · χ^k · (slot factors)."""
    parts = []
    if psi is not None:
        parts.append("ψ=%s" % psi)
    parts.append("χ=%s^%d" % (chi, k))
    if slots:
        parts.append("slots=%s" % slots)
    return " · ".join(parts)
