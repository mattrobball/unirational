# Goal H6 — decide the genuine `11:5` trace cubic via the projective degree-11 isogeny

**Pinned state:** `141f6042f628f984771fc79d8d16beb12cedcb94`  
**Priority:** 4  
**Headline direction:** negative, or retirement of the final proper subgroup site  
**Accepted negative bridge:** restriction to the generic maximal `11:5` twist

## Mission

Decide the genuine cyclic trace cubic

\[
\Phi_H(a)=\operatorname{Tr}_{E/K}
\left(ca^2\sigma(a)\right)=0,
\qquad c=r_2^{-1},
\]

using the projectivized torus map

\[
\varphi(a)=a^2\sigma(a).
\]

On the projective norm torus, `varphi` is an isogeny of degree 11.  Construct
its exact torsor class over the trace hyperplane and decide whether that class
has a rational point.

Pointlessness of this genuine generic `11:5` twist closes Problem E
negatively.  A rational point retires the last proper-decomposition valuation
site but does not prove the positive full-G headline.

## Binding inputs

Consume and hash:

```text
goal_runs_after_35fa/H_11_5_TWIST/
goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/
goals_after_bd610a/GOAL_H5_11_5_TRACE_CUBIC_DECISION.md
goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/
```

Do not repeat H5's constant-coefficient, bounded Laurent-support, pure monomial,
or random finite-fibre screens as if they were exhaustive.

## H6.0 — exact torus isogeny

Let `sigma` generate the cyclic degree-five extension.  Verify in the group
ring

\[
(2+\sigma)(5-3\sigma+\sigma^2-\sigma^3)
=11-(1+\sigma+\sigma^2+\sigma^3+\sigma^4).
\]

After quotienting scalar multiplication, construct explicit mutually inverse
isogeny data up to `[11]` for

\[
[a]\longmapsto[a^2\sigma(a)].
\]

Requirements:

1. identify the projective torus and its character lattice exactly;
2. compute the determinant `11` on the augmentation lattice;
3. determine the kernel group scheme, its Galois action, and a canonical
   generator or resolvent presentation;
4. express the dual isogeny from the displayed group-ring element;
5. verify all formulas in the authoritative four-parameter `K` model;
6. separate scalar norm factors from genuine projective classes.

Required marker:

```text
H6-PROJECTIVE-11-ISOGENY-PASS
```

## H6.1 — restrict the torsor to the trace hyperplane

Put `b=c a^2 sigma(a)`.  The equation becomes `Tr(b)=0`.  Construct the exact
fibre product

\[
Y=\{([a],[b]):[b]=[c\varphi(a)],\ \operatorname{Tr}(b)=0\}
\longrightarrow
H_{\rm tr}=\{\operatorname{Tr}(b)=0\}\subset\mathbf P(E).
\]

On the dense torus open this is a degree-11 torsor.  Produce:

- quotient-torus coordinates for `H_tr`;
- an explicit Kummer/resolvent invariant for the fibre;
- the translation contributed by `c`;
- the boundary divisor where coordinates or the isogeny degenerate;
- a proof that `Y(K)` is exactly the nonzero rational-point problem for the
  genuine trace cubic on this open, together with a separate boundary audit.

The order-11 class of `c` under `d -> d^2 sigma(d)` must emerge as a term in
this torsor class, not be promoted by itself to an obstruction.

## H6.2 — constructive trivialization lanes

### Lane A — rational curves and surfaces in `H_tr`

Parameterize complete families of lines, planes, and low-degree rational
surfaces in the trace hyperplane meeting the torus open.  Pull back the
11-torsor and compute its class.  Search for a family on which the class
vanishes identically, yielding an exact `K`-point.

### Lane B — additive Hilbert 90

Write `b=u-sigma(u)` and derive the 11-torsor class as a function of `u`.
Search for factorizations, norm equations, or conic/Severi--Brauer fibrations
whose generic fibre is decidable.  Treat general `u`, not only monomials.

### Lane C — projection from the degree-five closed point

Use the five `C11` eigenpoints and their Galois-stable secants to build a
birational model of the trace cubic or of `Y`.  Decide whether projection
produces a conic bundle, quadric bundle, or genus-one fibration with an exact
section.

### Lane D — exact multi-prime reconstruction

Use soluble finite fibres only for discovery.  Require a stable rational
component and compatible torsor trivialization at several primes, then
reconstruct over `K` and verify the trace identity symbolically.

## H6.3 — valuation obstruction on the degree-11 torsor

A negative lane must use an actual valuation of `K`, not a valuation only
after splitting `E`.

1. Construct a `C5`-equivariant toric compactification and enumerate boundary
   valuation orbits.
2. Descend each chosen orbit to `K` and compute all extensions to `E`.
3. Compute the leading term of the 11-torsor invariant, including the
   translation by `c`.
4. For every possible cancellation pattern, derive the exact residue torsor
   or residue trace cubic.
5. Prove one residue anisotropic, or prove that the class always trivializes
   and retire that valuation family.

The final residue must be smooth or its singular branches completely
classified.  Tropical noncancellation without residue anisotropy is only a
structural exit.

## H6.4 — bridge

### Pointless branch

Prove the installed model is the genuine generic/versal maximal `11:5` twist,
that the torus open plus boundary audit covers every projective point, and that
pointlessness survives the birational coordinate changes.  Then restriction
of a hypothetical full-G versal map gives a contradiction.  Deliver

```text
BRIDGE_11_5_NEG.md.
```

### Point branch

Give exact nonzero coordinates, verify `Phi_H=0`, and transport them to the
authoritative Klein equation.  Record the consequence for V3: every remaining
valuation nonpoint must have full decomposition group `G`.

## Deliverables

Write under

```text
problems/E-klein-cubic/goal_runs_after_141f60/H6_PROJECTIVE_11_ISOGENY/
```

Provide at least:

```text
INPUT_MANIFEST.json
ISOGENY.md
isogeny.json
TRACE_HYPERPLANE_TORSOR.md
torsor_class.json
BOUNDARY_AUDIT.md
CONSTRUCTIVE_SEARCH.md
VALUATION_LEDGER.md
POINT.md or POINTLESSNESS.md when obtained
BRIDGE_11_5_NEG.md when applicable
produce.py
verify_isogeny.py
verify_decision.py
REPLAY.md
SEAL.json
STATUS.md
```

## Authorized exits

```text
H6-POINTLESS-HEADLINE-NEGATIVE
H6-RATIONAL-POINT
H6-PROJECTIVE-11-ISOGENY-PASS
H6-TORSOR-CLASS-PASS
H6-VALUATION-REDUCTION-PASS
H6-UNDECIDED
H6-CANONICAL-INPUT-FAIL
```

Only `H6-POINTLESS-HEADLINE-NEGATIVE` is a full Problem-E headline candidate.
