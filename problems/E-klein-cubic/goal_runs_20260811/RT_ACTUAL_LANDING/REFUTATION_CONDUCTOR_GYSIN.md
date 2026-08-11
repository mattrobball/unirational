# Refutation of the conductor/local-genus Gysin exclusion — with the minimal-class provenance pinned

Exit: `CONDUCTOR-GYSIN-EXCLUSION-REFUTED-RATIONALLY`.

Provenance: adjudicated port of external message `[20]` section 1. The
conclusion **survives**; the *route* the external source gives is far stronger
than it needs to be, and one coefficient-level distinction it elides is the
whole substance of the question. This file states the refutation at exactly the
coefficient level it supports, and flags the gap.

---

## 1. The statement being refuted

`THEOREM_LEAKAGE_CLASSIFICATION.md` reduces CLEAN to a surface receiver: some
component `S ⊂ D_X` whose `IH^1(S,Q) = H^1(S̃,Q)` contains `V` and maps
nontrivially back to `V = H^3(X,Q)(1)` under the singular Cartier Gysin map. The
external sources `[15]` section 7 and `[10]` section 4 proposed to close RT by
proving that no such receiver exists:

> **Conductor/local-genus Gysin exclusion (proposed).** No common-factor
> component of an actual landing tuple has a resolved normalization whose
> constant `IH^1` contains the required orbitwise Weil Hodge factor and maps
> nontrivially to `H^3(X)(1)` under the singular Cartier Gysin morphism.

## 2. The refutation, at the coefficient level it actually supports

**Theorem 2.1.** For every smooth cubic threefold `X` there exist a proper
closed subvariety `D ⊊ X` of pure dimension 2, a smooth projective model
`D̃ → D`, and correspondences over `Q` with

```
V --Gamma_*--> H^1(D̃,Q)(-1) --j_*--> V,      j_* Gamma_* = id_V.     (2.1)
```

If `X` carries a finite group action (in our case `G = PSL_2(F_11)`), `D` and
the correspondences may be taken `G`-equivariant, again over `Q`.

*Proof.* `X` is a smooth cubic threefold, hence unirational, hence
`CH_0(X_{Omega})` is trivial for every field extension. By **Bloch–Srinivas**
(*Remarks on correspondences and algebraic cycles*, Amer. J. Math. 105 (1983)
1235–1253) there is a nonzero integer `N` and a decomposition

```
N * [Delta_X]  =  Z_1 + Z_2   in  CH^3(X x X),
```

`Z_1` supported on `D x X` for a proper divisor `D ⊊ X`, `Z_2` supported on
`X x {pt}`. Acting on `H^3(X,Q)`: the point term acts as zero (`H^3` of a
point), so `N · id_{H^3(X,Q)}` is the action of `Z_1`, which factors through
`H^1` of a smooth model of `D` twisted by `(-1)`. Divide by `N` — legitimate,
because we are working with `Q` coefficients. `G`-equivariance: average the
decomposition and its support over the finite group `G`, again legitimate over
`Q`. ∎

**Corollary 2.2 (the refutation).** The proposed conductor/local-genus Gysin
exclusion is **false**: the required `V`-receiver already exists, on every
smooth cubic threefold, `G`-equivariantly, with `Q` coefficients — which is
precisely the coefficient level at which the leakage question lives, since
`V = H^3(X,Q)(1)`, `IH^1(S,Q)`, and all the Hom-groups in
`THEOREM_LEAKAGE_CLASSIFICATION.md` are `Q`-linear Hodge-structure statements.

Exit `CONDUCTOR-GYSIN-EXCLUSION-REFUTED-RATIONALLY`.

---

## 3. The minimal-class provenance, pinned

The external source derived (2.1) instead from the *minimal class*. That route
is real, and the repository does hold the input — but it is much more expensive
than the conclusion needs, and the strength of what it delivers is different in
a way that matters.

### 3.1 What the repository has sealed

`goal_runs_20260808/DELTA1_MINIMAL_CLASS/THEOREM.md`, Theorem 3.1:

> The minimal integral class `theta^4/4! ∈ H^8(J(X),Z)` is algebraic. By
> Voisin's cubic-threefold criterion, the Klein cubic has universally trivial
> `CH_0`, equivalently it admits a Chow-theoretic decomposition of the diagonal.

Exits `KLEIN-IJ-MINIMAL-CLASS-ALGEBRAIC`, `KLEIN-CUBIC-UNIVERSALLY-CH0-TRIVIAL`,
`DELTA1-ORDINARY-DECOMPOSITION-DIAGONAL-OBSTRUCTION-PASSES`,
`DELTA1-RATIONAL-G-RETRACTION-EXISTENCE-OPEN`. This is **integral**: the packet
exhibits an explicit integral Hermitian `B = M^{-1} ∈ Herm_5(Z[nu])` and an
explicit integral 1-cycle `Z_B` with `theta^4/4! = [Z_B]` in `H^8(A,Z)`.

Its inputs, verified against the literature here:

* **Roulleau**, *The Fano surface of the Klein cubic threefold*, J. Math. Kyoto
  Univ. 49 (2009) 113–129 (arXiv:1001.4853): `J(X) ≅ E^5` **as an abelian
  variety**, `E = C/Z[nu]`, `nu = (-1+sqrt(-11))/2`, i.e. CM by the maximal
  order of `Q(sqrt(-11))`. Roulleau states in the same breath that this "is not
  an isomorphism of principally polarized abelian varieties." The repository
  records this verbatim and director-verified in
  `goal_runs_20260811/RETRACT_LANDSCAPE_NOTE/THEOREM.md` section 2(i) and
  `ADJUDICATION_PR38.md` item 9. **CONFIRMED.** (Independent earlier proof:
  Adler, J. Algebra 72 (1981) 115–145.)
* **Voisin's criterion.** The correct citation is *On the universal `CH_0` group
  of cubic hypersurfaces*, JEMS 19 (2017) 1619–1653 (arXiv:1407.7261): for
  cubic threefolds, universal `CH_0`-triviality — equivalently a Chow-theoretic
  decomposition of the diagonal — is **equivalent** to algebraicity of
  `theta^4/4!` on `J(X)`. **CONFIRMED as a genuine iff.** The earlier paper
  *Abel–Jacobi map, integral Hodge classes and decomposition of the diagonal*,
  J. Alg. Geom. 22 (2013) 141–174 (arXiv:1005.1346), gives only a partial
  converse with side conditions; citing that one for the iff would be wrong.
  Voisin also records that for the **very general** cubic threefold the
  algebraicity of `theta^4/4!` is open; it is known only on a countable union of
  special loci. The Klein cubic's membership in such a locus is exactly what
  Roulleau's `J(X) ≅ E^5` (plus a polarization-free integral Hodge conjecture
  for 1-cycles on products of elliptic curves) buys.
* The repository is explicit that this last assembly is a **director assembly,
  not a published statement** (`RETRACT_LANDSCAPE_NOTE/THEOREM.md`,
  DEPENDENCIES tier C).

### 3.2 The coefficient-level finding

Three distinct statements must be kept apart.

| level | statement | status |
|---|---|---|
| **(a) rational, non-equivariant** | `id_{H^3(X,Q)}` factors through `H^1(D̃,Q)(-1)` | **unconditional** for every smooth cubic threefold, by Bloch–Srinivas; no minimal class needed |
| **(b) rational, `G`-equivariant** | the same, `G`-equivariantly over `Q` | **unconditional**, by averaging (a) over the finite `G` |
| **(c) integral, `G`-equivariant** | a `G`-fixed *integral* Chow decomposition / a primitive fixed lift of `theta^4/4!` in `CH_1(J(X))^G` | **NOT available** |

The refutation needs only (a)–(b). The external source routed it through the
integral non-equivariant statement and then averaged to get equivariance over
`Q` — arriving at (b), which is correct, but by a path that consumes an input
(integral algebraicity of the minimal class) it does not need and that is not
even settled for a general cubic threefold.

Level (c) is where the repository's own audit lands, and it is negative:
`goal_runs_20260808/DELTA1_EQUIVARIANT_MINIMAL_CLASS_AUDIT/` shows that integral
averaging forces only a fixed lift of `660 · M^{-1}` — "Division by 660 is not
legitimate in integral Chow" — with exits including
`DELTA1-PRIMITIVE-FIXED-CHOW-LIFT-NOT-FORCED-BY-CITED-THEOREMS` and
`DELTA1-EQUIVARIANT-MINIMAL-CLASS-OBSTRUCTION-DOES-NOT-CLOSE-RETRACTION`.

**Consequence, stated honestly.** The refutation is exact at the level the
leakage problem lives at, so the conductor/Gysin exclusion is genuinely dead as
an abstract receiver-nonexistence theorem. But the refutation does **not**
extend to level (c). Any future exclusion argument that is *integral and
`G`-equivariant* — e.g. one that uses the `660`-torsion gap of the equivariant
audit — is not touched by this refutation. That is a narrow door, and we do not
claim it leads anywhere; we record that this file does not close it.

### 3.3 One thing the external source got structurally right

`J(X)` is **not** `E^5` as a ppav, and cannot be: Clemens–Griffiths (Ann. of
Math. 95 (1972) 281–356, Theorem 0.12) prove `(J(V), theta_V)` is not "of level
one", i.e. not isomorphic as a ppav to a product of Jacobians of smooth curves —
and `E^5` with its product principal polarization is such a product. So the
naive inference "`J(X) ≅ E^5` ⟹ `theta^4/4! = sum_i [E_i]` is obviously
algebraic" is **not** available; the repository's route correctly goes through a
polarization-free integral Hodge statement instead. The external source did not
make the naive error, and its integral claim is supported by the repository. We
record this because it is the most tempting wrong step in the neighbourhood.

---

## 4. Structural rhyme with FRONTIER-1 and the `O4` witness

This refutation has the same shape as an already-recorded event in this problem.

`goal_runs_20260810/SPIN_SOURCE_NETWORK/O4_EIGENPLANE_CURVES.md`, Theorem O4-5,
exhibits a smooth `C_3`-stable plane cubic `S ≅ E_{-11}` in every one of the 110
eigenplanes, with `Stab_G(S) = C_6` and
`Hom_{HS,C_6}(Res T, H^1(S,Q) ⊗ psi_j) ≠ 0` for every `j ≠ 3`. Its "Consequence"
paragraph reads:

> The closing move that `SUPPORT_CENSUS.md` section 6 proposed for `(O4)` —
> exclude `E_{-11}` from the Jacobians of the `C_6`-stable plane curves in the
> eigenplanes — is not available: `E_{-11}` is not merely not excludable, it is
> **realised** ... And the family of candidates is positive-dimensional in every
> degree `>= 3`, so the question was never finite.

Exit `O4-EIGENPLANE-CURVES-OPEN-WITH-WITNESS`. The reduced frontier of that
packet (`DEPENDENCY_MAP.md` section 5) has `FRONTIER-1` — "`s = 1`: a `G`-orbit
of CURVES in `Bs(phi)` with `E_{-11}` in the Jacobian. **NONEMPTY: Thm O4-5**"
— and the packet's headline box says "**O4 BLOCKS THE HEADLINE REGARDLESS.**"

The rhyme is exact. In both cases:

* an exclusion was proposed at the level of *"no object of this type can
  exist"*;
* the object of that type **does** exist, on the actual Klein cubic
  (`O4`) or on every smooth cubic threefold (`this file`);
* therefore the remaining question is not about the existence of a receiver but
  about **the actual map and the actual tuple** — which support the *actual*
  landing ideal produces, and whether *that* correspondence is the one realising
  the identity.

`FRONTIER-2` of the same map — "`s = 2`: a `G`-orbit of SURFACES in `Bs(phi)`
with `E_{-11}` in the Albanese. Status unknown." — is, up to notation, exactly
the surface receiver of `THEOREM_LEAKAGE_CLASSIFICATION.md` section 5. The two
routes converge on the same open cell.

**Problem E headline: OPEN.**
