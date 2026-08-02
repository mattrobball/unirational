# Problem E reassessment after G2 and V3

**Audited state:** `main @ 141f6042f628f984771fc79d8d16beb12cedcb94`  
**Date:** 2026-08-02  
**Headline verdict:** **OPEN**

## 1. What G/G2 now proves

The packet

```text
goal_runs_after_35fa/G_UNIVERSAL/
```

closes the universal-object and all-degree questions.  With

\[
S=\operatorname{Sym}(W^*),\quad R=S^G,\quad
M=(S\otimes W)^G,
\]

and with `T/K_proj` the generic projective `G`-torsor, it proves canonical
bijections among

1. `X_T(K_proj)`;
2. `G`-equivariant rational maps `P(W) --> X`;
3. nonzero homogeneous landing covariants in arbitrary degree, modulo
   homogeneous invariant scalar multiplication;
4. primitive landing covariants modulo constants; and
5. rational points of the explicit normalized cubic

   \[
   V(\Phi)\subset\mathbf P^4_{K_{\rm proj}}.
   \]

The exact 35 coefficients of `Phi` are installed in

```text
goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json.
```

This is the decisive change in route ranking.  A finite degree ladder is not
an approximation to a missing theorem: the complete all-degree problem is
already one finite arithmetic cubic.

## 2. What V3 now proves

The packet

```text
goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/
```

puts every possible valuation obstruction into normal form.  A henselian
nonpoint must satisfy all of

```text
inertia = 1;
residue is not C1;
residue transcendence degree >= 2;
rational rank <= 2;
Krull rank <= 2;
decomposition group = G or maximal 11:5;
residue cubic smooth, pointless, and index one.
```

Every rank-at-least-three valuation is soluble.  The full-group residue models
still requiring a decision are `f5=0` and `f6=0`.  The only proper-decomposition
model is the genuine `11:5` trace cubic.  Hence no new valuation mission should
search for ramification, an index-three residue, high-rank tropical
noncancellation, or a small fixed-frame slice.

## 3. Other binding changes

- `B-BRIDGE-REFUTED`: the selected fixed ternary frame is not exhaustive in
  the genuine degree-14 Fano section.  Fixed-frame pointlessness cannot prove
  the headline by that mechanism.
- `Q2.1-DESCENT-OBSTRUCTION-AUDIT-PASS`: transfer-compatible abelian,
  commutative-torsor, finite-torsor, covered semisimple, finite-etale,
  Picard/Albanese/Brauer/Amitsur, and installed stable-cohomology obstructions
  are neutral or inapplicable.
- `H5-UNDECIDED`: the first genuine `11:5` constructive and valuation screens
  have run.  They found no `K`-point and no anisotropic residue; specialized
  finite-field fibres are routinely soluble.
- C5's prescribed idempotent equations were inconsistent.  The corrected
  model is the degree-14 Grassmannian/common-line section for five alternating
  forms.
- T3 is now an exact local normalization and `Cl/Pic[3]` program, but even a
  successful T3 theorem is fixed-frame only after B.

## 4. Headline attempt and failure point

No current packet supplies either binary exit.

### Positive side

A point of `V(Phi)` or of the corrected Fano common-line section would prove
positivity after the accepted bridge.  No exact `K_proj`-point is currently
known.  P25/COV modular survivors and good-fibre common lines do not provide
one.

### Negative side

Pointlessness of `V(Phi)`, of the full `f5` or `f6` residue cubic, or of the
genuine `11:5` trace cubic would prove negativity after the appropriate
bridge.  None is currently proved.  Index one, coprime zero-cycles, finite
support exclusions, and fixed-frame emptiness are insufficient.

Accordingly no headline seal is sound at the audited state.

## 5. Two deductions that should guide the next workers

### 5.1 Dominance should be automatic once a G3 point is found

The earlier generic-torsor argument in `SPEC.md` gives the following route.
A rational point of `V(Phi)` produces a `G`-equivariant rational map from the
linear representation to `X`.  Let `Z` be the irreducible image.  Its action
kernel is normal in the simple group `G`.  It cannot be all of `G`, because
`X^G` is empty.  Hence the action on `Z` is faithful.  Since `Z` is very
versal, the unconditional lower bound `ed(G)>=3` gives `dim Z>=3`; because
`dim X=3`, one gets `Z=X`.

Thus a separate large Jacobian computation appears unnecessary.  G3 must
audit this argument against the exact source/projectivization conventions and
record either

```text
G3-DOMINANCE-AUTOMATIC
```

or the smallest genuine gap.  It must not impose an unexplained projective
rank-four condition.

### 5.2 The `11:5` equation carries a projective degree-11 isogeny

For the cyclic degree-five extension `E/K` with generator `sigma`, put

\[
\varphi(a)=a^2\sigma(a).
\]

The genuine trace cubic is

\[
\operatorname{Tr}_{E/K}(c\varphi(a))=0,
\qquad c=r_2^{-1}.
\]

On the projective norm torus, the character-lattice operator is `2+sigma`.
The identity

\[
(2+\sigma)(5-3\sigma+\sigma^2-\sigma^3)
=11-(1+\sigma+\sigma^2+\sigma^3+\sigma^4)
\]

shows that its projectivization is an isogeny of degree 11; equivalently

\[
\prod_{j=1}^4(2+\zeta_5^j)=11.
\]

Hence H5 is a translated degree-11 torus cover of the rational trace
hyperplane on the dense torus open.  This does not decide the point question,
but it replaces another unstructured support search by an exact torsor-class
problem.

## 6. Revised ranking

1. **G3 universal cubic arithmetic.**  It is now literally equivalent to the
   full headline and has only five projective variables.
2. **C6 determinantal common-line quartic.**  It gives a concrete positive
   bridge and a smaller birational model of the corrected Fano section.
3. **G4 A5 index-11 transfer.**  The two exact A5 points should be induced to
   the generic G-torsor and processed through the 11-point permutation
   algebra rather than treated only as valuation eliminations.
4. **H6 projective degree-11 isogeny.**  It is the sharpest remaining proper
   subgroup obstruction.
5. **G5 full `f5`/`f6` residue cubics.**  These are the only full-group
   valuation sites left by V3.
6. **Q3 primitive quartic/resolvent stable maps.**  The output bridge is
   complete, but a Schur-specific splitting theorem is still missing.
7. **P25/COV positive reconstruction.**  Continue existing finite work only
   as a route to an actual covariant; finite exclusions no longer advance the
   all-degree negative side.
8. **T3/S19/M3.**  Valuable scoped geometry, but currently farther from an
   accepted headline bridge.
