# Goal G3A — exact universal-cubic arithmetic and dominance bridge

**Audited parent state:** `0aecc89f0598cfd982295107352e6cc6e9fb04e9`  
**Priority:** 0  
**Parent goal:** [`GOAL_G3_UNIVERSAL_CUBIC_ARITHMETIC.md`](../goals_after_141f60/GOAL_G3_UNIVERSAL_CUBIC_ARITHMETIC.md)  
**Headline:** unchanged unless a canonical-input failure invalidates G2

## Mission

Extract the load-bearing mechanical part of G3 into one small sealed packet:

1. construct an authoritative exact arithmetic engine for
   `K_proj` and the 35-coefficient cubic `Phi`;
2. settle the point-to-dominant-map implication once and for all;
3. export a compact interface consumed by every later G3, G4, G7, C6, H6, and
   G5 worker.

Do **not** perform a broad point search in this goal.  The success exit is a
reliable arithmetic and bridge layer, not a rational point.

## Binding inputs

Consume and hash at least

```text
goal_runs_after_35fa/G_UNIVERSAL/
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json
goals_2026-08-01/G_ALL_DEGREE/verify_all.py
certificates/global_transition/necessity_theorem.json
SPEC.md
REPAIR.md
```

and the authoritative Hironaka-basis and multiplication-table artifacts named
by their manifests.  The exact secondary basis remains the verification
standard even if a primitive-element presentation is built for speed.

## G3A.0 — field arithmetic

Implement deterministic exact operations for

```text
addition, multiplication, equality, norm, trace, and inversion in K_proj;
conversion between the 12-element secondary basis and any optimized model;
projective degree-zero normalization;
denominator and localization bookkeeping.
```

Requirements:

1. Reconstruct the defining multiplication table from the invariant-ring
   inputs rather than copying a serialized table without semantic checks.
2. Prove that every inversion used by later code records its denominator and
   the open on which it is valid.
3. Check associativity, the unit, minimal-polynomial identities, and a fixed
   hostile set of products independently.
4. If a primitive element is used, give mutually inverse exact conversion maps
   and verify them on a basis, products, and inverses.
5. Provide sparse machine exports for Python/Sage, Magma, and Macaulay2 without
   expanding unrelated Pfaffian or target-branch objects.

## G3A.1 — reconstruct `Phi`

From the original Klein cubic and the normalized frame

```text
x, C, D, E, K_7
```

reconstruct all 35 symmetric coefficients of

\[
\Phi(a_0,\ldots,a_4).
\]

The producer may consume upstream circuits, but the independent verifier must
rebuild the coefficient ledger from the original polynomial identities.  It
must check:

- the complete 35-triple support;
- every coefficient in the 12-element field basis;
- all weight and degree-zero identities;
- cubic symmetry and polarization conventions;
- equality with `generic_cubic.json` coefficient by coefficient;
- the denominator-clearing identity back in the original Klein coordinates.

Also construct exact APIs for

```text
Phi(a),
its symmetric trilinear polarization B(a,b,c),
all first derivatives,
all second derivatives,
projective linear substitutions,
and specialization with a complete good-prime ledger.
```

## G3A.2 — smoothness boundary

Determine exactly what is already proved about smoothness of `X_gen=V(Phi)`.
If smoothness follows formally because it is the twist of the smooth Klein
cubic, write the descent argument and verify that the installed equation is on
the exact twisting open.  Also provide one direct Jacobian consistency check
at a good specialization.

Do not launch a generic five-variable Groebner basis merely to reprove a
property already carried by twisting.

## G3A.3 — dominance audit

Let a `K_proj`-point of `X_gen` clear denominators to a nonzero homogeneous
`G`-covariant rational map

\[
f:\mathbf P(W)\dashrightarrow X.
\]

Audit the following argument in the exact conventions used by G2.

1. The closure `Z` of the image is irreducible and the induced rational map
   makes `Z` weakly/very versal in the sense needed for essential dimension.
2. The kernel of `G` acting on `Z` is normal.
3. The kernel cannot be all of `G`: otherwise `Z` lies in `X^G`, and the exact
   fixed-point computation gives `X^G=empty`.
4. Simplicity of `G` makes the action on `Z` faithful.
5. A faithful finite-group action on an irreducible variety is generically
   free.
6. The accepted lower bound `ed_C(G)>=3` gives `dim Z>=3`.
7. Since `Z subset X` and `dim X=3`, one has `Z=X`; therefore `f` is dominant.

Check the possible constant-map and affine-cone loopholes explicitly.  If every
step is sound, record

```text
G3-DOMINANCE-AUTOMATIC
```

and state that no separate Jacobian-rank test is required for a later exact
point.  If any implication fails, identify the smallest exact replacement
condition; do not retain an unexplained rank-four requirement.

For the negative direction, identify the precise theorem in G2 proving that
`X_gen(K_proj)=empty` excludes **every** linear-source equivariant rational
map.  This should be a citation-and-hypothesis audit, not a new all-degree
argument.

## Deliverables

Write under

```text
problems/E-klein-cubic/goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/
```

Provide at least

```text
INPUT_MANIFEST.json
FIELD_MODEL.md
field_model.json
PHI_RECONSTRUCTION.md
phi_exact.json
POLARIZATION.md
SMOOTHNESS.md
DOMINANCE_BRIDGE.md
EXPORTS.md
src/
produce.py
verify_field.py
verify_phi.py
verify_bridge.py
verify_all.py
REPLAY.md
SHA256SUMS
SEAL.json
STATUS.md
```

## Authorized exits

```text
G3A-ARITHMETIC-DOMINANCE-PASS
G3A-ARITHMETIC-PASS-DOMINANCE-GAP
G3A-CANONICAL-INPUT-FAIL
G3A-BLOCKED
```

`G3A-ARITHMETIC-DOMINANCE-PASS` requires exact arithmetic, independent
coefficient reconstruction, and a complete dominance ledger.  It is a
structural exit, not a Problem-E headline.