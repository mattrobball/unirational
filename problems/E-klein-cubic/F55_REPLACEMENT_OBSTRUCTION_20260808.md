# F55 replacement obstruction: polar circuits and coefficient holonomy

**Date:** 2026-08-08  
**Baseline:** `main` at `0cf63e856c1442f2704e14a00b5476fcedb9e5a2`  
**Status:** `RESEARCH-PROGRAM`; no F55 headline claim  
**Target:** prove that the cyclic trace cubic has no nonzero `K`-point

## 0. Proposed replacement

The most promising replacement for the failed valuation/polytope obstruction
is an **exact coefficient-realizability obstruction**:

```text
Newton/support shadow
    -> active coefficient equations
    -> polar circuits / binomial phase equations
    -> monomial in the saturated landing ideal.
```

The key distinction is that the old campaign retained only orders of terms.
The new object retains:

- which coefficient monomials cancel;
- their exact multiplicities (`1` versus `2` from the squared slot);
- the fifth-root phases of the F55 projective twist;
- the compatibility of those cancellations around cycles.

The degree-7 landing cone already supplies a complete calibration: its
no-singleton tropical support survives, but two exact rows generate a monomial
in the saturated ideal.  The proposed all-degree theorem is that every
primitive support contains such a polar circuit, or a bounded higher circuit
with nontrivial coefficient holonomy.

This note formulates that target precisely and separates the proved lemmas,
the finite computations, and the genuinely open uniformity theorem.

## 1. Why the obstruction must live at this altitude

The repository has tested essentially every lower-information layer.

### 1.1 Divisorial valuations are too coarse

The late corrections in `theory/FIX_IX_v14.md` and the exact witness in
`director_probes_20260806/f55_qpreimage.py` show that the corrected twice-min
boundary system has an integral-sloped PL solution and a convex lattice
polytope realization.  Therefore:

```text
support-function compatibility != coefficient realizability.
```

Any replacement that depends only on Newton polytopes, orders along divisors,
or the old conserved-eleven congruence will repeat a route already falsified
by an explicit witness.

### 1.2 Local fixed-point and curve data are compatible

The F55 germ weights are locally realizable at every order-one level.  On V14,
the target line inventory is the pentagon rather than the complete graph, but
the subsequent shifted-Pluecker/tropical system is feasible.  Thus neither
local weights nor the current curve-shadow constraints yield a contradiction.

### 1.3 Formal lifting is generically unobstructed in the analogous full-G lane

The packets under `certificates/global_lifting*` show that the first nonlinear
polar operators are generically surjective, and the scoped `(m,d)=(1,7)`
full-G witness meets the generic-surjective open.  This does not decide F55,
but it is strong evidence against another obstruction built only from one
local correction operator or one rank-drop locus.

### 1.4 Index and closed-point arithmetic stop at the cubic-descent wall

The degree-5/11/55 geometry proves index one and supplies extensive
prime-to-three closed-point data.  It does not produce a point and cannot be
turned into a negative theorem without an additional invariant.

### 1.5 The Hodge carrier condition has a free-orbit escape

`theory/FIX_VII_carrier.md` gives a genuine necessary condition on resolution
centers, but irregular centers over free orbits are not excluded.  It is a
valuable filter on constructions, not a present all-degree contradiction.

### 1.6 Exact coefficients already kill a surviving shadow at degree 7

The new probe

```text
director_probes_20260808/f55_phase_holonomy_d7.py
```

shows that coefficient multiplicities and phases can do exactly what the
support shadow cannot.  This is the principal positive evidence for the new
lane.

## 2. First exact reduction: rational solutions may be made Laurent polynomial

Let

```text
E = C(r0,...,r4)/(product ri - 1),
sigma(ri) = r(i+1),
K = E^<sigma>,
Phi(a) = Tr_{E/K}(r2^(-1) a^2 sigma(a)).
```

### Lemma 2.1 — invariant denominator clearing

If `0 != a in E` and `Phi(a)=0`, then there is a nonzero Laurent polynomial
`a_L in C[Z^5/Z(1,...,1)]` with `Phi(a_L)=0`.

### Proof

Write `a=P/Q` with nonzero Laurent polynomials `P,Q`.  Put

```text
N(Q) = Q * sigma(Q) * ... * sigma^4(Q) in K*.
```

Then

```text
a_L = N(Q) a = P * sigma(Q) * ... * sigma^4(Q)
```

is Laurent polynomial.  Since `N(Q)` is sigma-invariant,

```text
Phi(N(Q) a) = N(Q)^3 Phi(a) = 0.
```

This proves the claim.  QED.

### Consequence

A negative proof may work entirely with **finite supports** in the rank-four
character lattice.  The difficulty is uniformity over supports of unbounded
size, not rational denominators.

## 3. The exact support ideal

Let

```text
Lambda = Z^5 / Z(1,1,1,1,1)
```

and write

```text
a = sum_{m in S} A_m chi^m,
```

where `S` is finite and every `A_m` is nonzero.  Expanding gives

\[
\Phi(a)=
\sum_{i=0}^{4}\ \sum_{m,n,p\in S}
 A_mA_nA_p\,
 \chi^{\sigma^i m+\sigma^i n+\sigma^{i+1}p-\sigma^i e_2}.
\]

After fully commutativizing coefficient monomials, the terms with `m != n`
in the squared slot carry multiplicity `2`; terms with `m=n` carry
multiplicity `1`.

For every output exponent `gamma`, let `F_gamma(A)` be its coefficient, and
define

```text
J_S = ideal(F_gamma : all gamma) subset C[A_m : m in S].
```

Then a trace-cubic zero with support **exactly** `S` exists if and only if

```text
V(J_S) meets (G_m)^S,
```

or equivalently

```text
J_S : (product_{m in S} A_m)^infinity != (1).
```

The analogous degree-`d`, twist-`s` covariant landing ideal is denoted
`I_{d,s}`.  Either formulation is authoritative; the trace formulation is
support-finite without imposing a polynomial degree, while the covariant
formulation is convenient for exact finite ladders.

## 4. What the old tropical screen actually checked

The no-singleton rule checks only this necessary condition:

```text
for every displayed generator F_gamma,
its active initial form has either 0 or at least 2 monomials.
```

That is membership in the tropical **prevariety** cut out by the displayed
generators.  A genuine point requires membership in the tropical variety of
the full ideal.  Equivalently, after all polynomial consequences are included,
the relevant initial ideal must contain no monomial.

Thus the correct upgrade is not another fan refinement.  It is to compute or
prove enough **S-polynomial, resultant, or lattice-circuit consequences** to
put a monomial in every surviving initial ideal.

The degree-7 certificate is exactly such a missing consequence.

## 5. Calibration theorem: the clean polar diamond

### Definition 5.1

A support contains a **clean polar diamond** if two landing rows restrict to

\[
\begin{aligned}
f&=\alpha A_u^2A_v+\beta A_uA_w^2,\\
g&=2\alpha A_uA_vA_z+\beta A_zA_w^2,
\end{aligned}
\]

with `alpha,beta != 0` and `A_u,A_v,A_w,A_z` all active, and with no other
active terms in those two rows.

### Lemma 5.2 — polar-diamond obstruction

A clean polar diamond has no solution on the coefficient torus.

### Proof

There is the exact ideal identity

\[
A_u g-2A_z f=-\beta A_uA_zA_w^2.
\]

The right side is a nonzero monomial on the coefficient torus.  Therefore the
saturation of `(f,g)` by the active variables is the unit ideal.  QED.

The coefficient `2` is not cosmetic: it is the polarization multiplicity of
two distinct choices in the squared slot.  It is information discarded by
all valuation-only screens.

### Degree-7 instance

For each of the five projective twists `s`, every support-admissible degree-7
support contains indices `0,2,3,23`, and two rows are

\[
\begin{aligned}
f&=\zeta^s A_0^2A_2+\zeta^{3s}A_0A_{23}^2,\\
g&=2\zeta^s A_0A_2A_3+\zeta^{3s}A_3A_{23}^2.
\end{aligned}
\]

Hence

\[
A_0g-2A_3f=-\zeta^{3s}A_0A_3A_{23}^2.
\]

This proves characteristic-zero emptiness on every surviving degree-7
coefficient torus.  The finite support-universe certificate finds one maximal
support of size 18 and exactly 32 support-admissible sub-supports.

This is not an all-degree proof, but it validates the proposed mechanism on
the first degree where the generator-level tropical screen survives.

## 6. Higher coefficient holonomy

Clean diamonds are the shortest possible certificates.  More generally,
suppose a collection of active rows is binomial:

\[
\alpha_e A^{u_e}+\beta_e A^{v_e}=0,
\qquad e\in E.
\]

Put

```text
delta_e = u_e - v_e,
rho_e   = -beta_e/alpha_e.
```

A torus solution would satisfy

```text
A^delta_e = rho_e.
```

Let `D` be the integer matrix with rows `delta_e`.  For every integer relation

```text
sum_e n_e delta_e = 0,
```

one must have

```text
product_e rho_e^(n_e) = 1.
```

Over an algebraically closed characteristic-zero field these conditions are
also sufficient for the binomial subsystem.  Thus Smith/Hermite normal form
produces an exact and independently verifiable **holonomy test**.

The degree-7 diamond is the two-edge relation whose holonomy is the factor
`2`.  In other supports the obstruction may lie in

```text
Q* times mu_5
```

on the covariant side, or in the 11-primary torsor direction on the trace
side.

### Conceptual interpretation

Each active binomial chooses a ratio between coefficient monomials.  Ratios
propagate along the support-incidence graph.  A closed path must return with
product one.  Nontrivial return product is coefficient holonomy.

On trace-hyperplane charts, local lifts through `[a] |-> [a^2 sigma(a)]`
differ by the degree-11 kernel.  The 11-primary part of the same gluing data
should admit a Cech interpretation in `mu_11`.  This interpretation is a guide,
not yet a constructed unramified invariant; the exact algebraic object remains
the saturated coefficient ideal.

## 7. Proposed all-degree theorem

The desired replacement obstruction is the following.

### Polar-circuit theorem — target statement

For every finite primitive support `S` in `Lambda`, one of the following holds:

1. some landing row has exactly one active coefficient monomial;
2. `S` contains a clean polar diamond;
3. a bounded collection of landing rows has a binomial holonomy relation with
   nontrivial return product;
4. a bounded sparse polynomial consequence of the landing rows has monomial
   initial form.

Any of the four alternatives implies

```text
J_S : (product A_m)^infinity = (1).
```

Together with Lemma 2.1 this would prove `Phi` anisotropic, hence F55-NO on the
Klein cubic and V14.

The theorem is not proved here.  Its value is that it names the exact missing
uniform statement and makes every finite calculation a genuine instance of
one of four accepted certificate types.

## 8. The central uniformity problem

Killing one large support or one fan is not enough.  The critical task is to
reduce arbitrary Laurent supports to finitely many primitive circuit types.
The following structures from the repository make that plausible but do not
yet prove it.

### 8.1 K-invariant gauge

Multiplication `a |-> b a` for `b in K*` scales `Phi(a)` by `b^3`.
Consequently supports should be considered modulo invariant factors and
sigma-invariant Minkowski summands.  The general solution in
`f55_qpreimage.py`, where PL lifts differ by a sigma-invariant summand, is the
shadow of precisely this gauge freedom.

A first normalization is:

```text
choose a Laurent representative with inclusion-minimal support after removing
all nonconstant K-invariant common factors.
```

### 8.2 Fixed-rank collision semigroups

A landing collision is an equality

\[
\sigma^i m+\sigma^i n+\sigma^{i+1}p-\sigma^i e_2
=
\sigma^j m'+\sigma^j n'+\sigma^{j+1}p'-\sigma^j e_2
\]

in the rank-four lattice.  For a fixed equality pattern among the coefficient
indices and fixed cyclic slots `i,j`, these are homogeneous linear
Diophantine equations in nonnegative exponent vectors.  Their primitive
solutions form an affine semigroup with a finite Hilbert basis.

This gives a concrete route to all-degree classification:

1. enumerate equality patterns for clean diamonds and small higher circuits;
2. compute the Hilbert bases with Normaliz;
3. quotient the generators by invariant translations;
4. prove that every support-minimal cancellation complex contains one of the
   resulting primitive templates.

Steps 1--3 are finite and executable.  Step 4 is the main combinatorial
lemma.

### 8.3 Tropical-basis completion rather than fan enumeration

For each primitive cancellation template, form the exact sparse landing ideal
and compute only enough S-polynomials to obtain either:

```text
MONOMIAL-INITIAL-CERTIFICATE
```

or a genuinely surviving torus component.  The latter is not a failure: it
produces a bounded exact profile for the positive search and falsifies the
proposed universal circuit statement at a precise location.

## 9. Work plan and acceptance gates

### Gate P0 — exact compiler

Build one shared exact compiler for both formulations:

```text
support -> fully commutativized landing rows
        -> cyclotomic coefficients
        -> support hypergraph
        -> saturated sparse ideal.
```

Requirements:

- combine all coefficient triples commutatively;
- use exact `Q(zeta_5)` arithmetic, never one finite-field root;
- expose multiplicities from repeated squared-slot indices;
- independent evaluation against direct substitution.

The degree-7 probe is the first regression test.

### Gate P1 — clean-diamond census

For degrees `2 <= d <= 20` and all twists:

1. enumerate maximal no-singleton supports;
2. search every surviving support for clean diamonds;
3. record a two-row monomial identity when found;
4. output exceptional supports only.

This is discovery, not the all-degree theorem.

### Gate P2 — exact binomial holonomy

For each exceptional support:

1. collect all binomial active rows;
2. build the exponent-difference matrix `D`;
3. compute `ker_Z(D^T)` by Smith/Hermite normal form;
4. evaluate return products exactly in `Q(zeta_5)*`;
5. emit the shortest nontrivial cycle certificate.

Acceptance marker:

```text
F55-PHASE-HOLONOMY-CERTIFICATE
```

### Gate P3 — sparse tropical-basis consequences

If binomial holonomy is trivial, compute sparse S-polynomials/resultants among
small output circuits.  The accepted negative exit is an explicit identity

```text
sum h_gamma F_gamma = monomial
```

on the selected support, verified by direct expansion.

### Gate P4 — Hilbert-basis uniformity

Use the fixed collision equations to classify primitive clean diamonds and
higher circuits across all degrees.  The deliverable must distinguish:

```text
finite primitive circuit list
```

from

```text
proof that every minimal support contains a listed circuit.
```

Only the second statement permits an all-degree conclusion.

### Gate P5 — theorem assembly

Re-run the authoritative chain:

```text
rational K-point
 -> Laurent polynomial point          (Lemma 2.1)
 -> support-minimal primitive point
 -> listed polar/holonomy circuit      (P4 theorem)
 -> monomial saturation certificate   (P1/P2/P3)
 -> contradiction.
```

No F55-NO claim is permitted before every arrow is sealed.

## 10. Independent verification design

A publish-grade packet should contain:

```text
produce_supports.py
produce_circuits.py
produce_holonomy.py
verify_rows.py
verify_hilbert_basis.py
verify_monomial_identity.py
SEAL.json
```

The verifier should consume only:

- integer exponent vectors;
- exact cyclotomic coefficient vectors;
- sparse multiplier identities;
- Normaliz Hilbert-basis certificates or independently recomputed bases.

Finite-field specializations may be regression checks but may not certify
nontrivial holonomy in characteristic zero.

## 11. Failure protocol

The approach is falsifiable at several precise stages.

- If a primitive support has no clean or higher circuit, record it as a
  counterexample to the circuit theorem.
- If its binomial holonomy is trivial, do not call the support obstructed.
- If the full sparse ideal has a torus component, attempt exact reconstruction
  of a covariant or Laurent trace zero on that component.
- If primitive supports are not finite modulo invariant gauge, abandon the
  finite Hilbert-basis claim and retain only degree-by-degree exclusions.

A surviving exact component would be major positive evidence.  The program is
therefore useful whether it closes negatively or identifies the first
credible construction profile.

## 12. Present verdict

What is established now:

```text
- rational denominators can be cleared invariantly;
- the generator-level tropical shadow is known to be insufficient;
- degree 7 is killed in characteristic zero by a clean polar diamond;
- coefficient holonomy supplies exact finite certificates invisible to the
  failed valuation route.
```

What remains open:

```text
- the primitive-support uniformity theorem;
- higher-circuit completeness;
- any all-degree monomial-saturation theorem;
- F55-unirationality itself.
```

The recommended next action is Gate P1 followed immediately by P2 on the
first exceptional support.  This is narrower and more information-preserving
than another valuation, fixed-locus, or bounded random-search campaign.