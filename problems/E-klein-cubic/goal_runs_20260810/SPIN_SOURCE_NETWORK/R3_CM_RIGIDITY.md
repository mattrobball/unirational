# Residual 3: nonconstant local systems, and the CM-rigidity lemma

`TOTAL_DEGENERATION.md` §6, Residual 3: nonconstant local systems on the
eigen-strata (cell `O4g`) are untouched.  The proposed attack: prove an
equivariant CM-rigidity lemma — a polarizable weight-one variation with
`Q(sqrt(-11))`-multiplication over a quasiprojective base is isotrivial —
conclude finite monodromy, pass to the finite cover, and reduce `R3` to the
`R2`/`O4` analysis.

Verdict: **`R3-METHOD-INSUFFICIENT`, with an explicit two-line witness.**  The
lemma is true and is proved here in the right generality (§1), because it has
been wanted since the ambient packet.  But it does not apply, and the failure
is not a technicality: **its hypothesis is not what the package forces**
(§2), and even when the conclusion is granted for free — the witness has
monodromy of order **two** — the proposed reduction still does not close
anything (§3).

Machine: `python3 verify_r3_cm.py` → `R3_CM_OK`, exact, stdlib only.

---

## 1. The lemma, proved

> **Lemma R3-1 (CM rigidity for variations).**  Let `S` be a connected smooth
> quasiprojective complex variety and let `V` be a polarizable variation of
> `Q`-Hodge structure of weight one on `S`, of rank `2g`, admitting an
> integral structure (a `Z`-local system `V_Z` with `V = V_Z (x) Q`).  Suppose
> `F` is a CM field with `[F:\mathbf Q] = 2g` and there is a ring homomorphism
> \[
> F\longrightarrow \operatorname{End}_{\mathrm{VHS}}(V)
> \]
> into the endomorphisms **of the variation** (flat and horizontal).  Then:
>
> 1. the Hodge filtration is flat and the period map is constant;
> 2. the monodromy representation has **finite** image;
> 3. there is a finite étale cover `u : S' -> S` on which `u^*V` is a constant
>    variation, whose fibre is `H^1` of a CM abelian variety with CM by `F`;
> 4. if a finite group `K` acts on `S` compatibly with `V`, `u` may be taken
>    `K`-equivariantly, with `S' -> S` Galois and `K` lifting to `S'`.

*Proof.*  (1)  Fix `s in S`.  `V_s` is a `Q`-Hodge structure of weight one on
which `F` acts, and `dim_F V_s = 2g/[F:Q] = 1`.  Then
`V_s (x) C = \bigoplus_{\tau : F \to C} C_\tau` as an `F (x) C`-module, and the
Hodge decomposition `V_s (x) C = V^{1,0} (+) V^{0,1}` is `F`-stable, so
\[
V^{1,0}=\bigoplus_{\tau\in\Phi_s}C_\tau,\qquad
V^{0,1}=\bigoplus_{\tau\in\overline{\Phi_s}}C_\tau ,
\]
for a subset `Phi_s subset Hom(F,C)`; conjugacy of the two summands forces
`Phi_s ⊔ \overline{Phi_s} = Hom(F,C)`, i.e. `Phi_s` is a **CM type** for `F`.
There are only finitely many CM types, so `s \mapsto Phi_s` is a map from the
connected `S` to a finite set which is continuous (the Hodge filtration varies
holomorphically and the decomposition is by the locally constant `F`-action),
hence constant.  A weight-one Hodge structure with `F`-multiplication is
determined up to isomorphism by its CM type, so the period map is constant and
the Hodge filtration is flat.

(2)  Monodromy preserves the polarization `psi`, commutes with `F`, and
preserves the lattice `V_Z`.  The first two conditions put it inside
\[
U^1(F)=\{u\in F^\times:\ u\bar u=1\},
\]
because `End_F(V_s) = F` (as `dim_F V_s = 1`) and the Rosati involution of an
`F`-compatible polarization restricts to complex conjugation on `F`.  The
third condition puts it inside the units of an order of `F`.  An algebraic
integer `u` with `u\bar u = 1` has all archimedean absolute values equal to
`1`, so by Kronecker's theorem `u` is a root of unity; the roots of unity in a
number field form a finite group.  Hence the monodromy image is finite.

(3)  Let `S' -> S` be the finite étale cover corresponding to the kernel of
the monodromy representation.  On `S'` the local system is constant and, by
(1), so is the Hodge filtration; the constant fibre is a polarizable weight-one
Hodge structure with CM by `F`, hence `H^1` of a CM abelian variety of type
`(F, Phi)` (Shimura–Taniyama).

(4)  The kernel of the monodromy is a characteristic subgroup of the image of
`\pi_1(S)` and the `K`-action permutes the conjugates of the corresponding
subgroup; replacing it by the intersection of its finitely many `K`-translates
gives a `K`-stable finite-index normal subgroup, hence a `K`-equivariant
Galois cover.  `QED`

> **Corollary R3-2.**  If, in the situation of Theorem S3(4), the local system
> `L` on a strict support `S` underlies a polarizable weight-one variation
> **with horizontal `Q(sqrt(-11))`-multiplication of rank two**, then `L` is
> isotrivial with finite monodromy and the carrier computation reduces, after
> a finite `H`-equivariant cover, to the constant-coefficient case.

That corollary is a real statement and it does close the sub-case it names.
The rest of this file is about the fact that the package does not deliver its
hypothesis.

---

## 2. The hypothesis is not what the package forces

The condition (AHS-spin) / (5.2) is

\[
\operatorname{Hom}_{\mathrm{HS},H'}\!\left(\operatorname{Res}_{H'}T,\ IH^{\,s+4-n-j_0}(\overline S,\mathcal L)\right)\neq0 .
\]

The `E_{-11}`-isotypic structure lives on the **global** intersection
cohomology `IH^*(\overline S, L)` — one Hodge structure — not on the
variation `L`.  Nothing in the decomposition theorem, in Theorem S3, or in
Corollary S4 transports it to the fibres of `L`.

> **Observation R3-3.**  The implication
> *"`IH^i(\overline S, L)` contains a CM Hodge structure `=>` `L` has CM"* is
> **false**, and it is false for the oldest possible reason: it fails already
> for `S` a curve and `L` a rank-one local system of finite monodromy, where
> `L` carries no multiplication at all while `IH^1` is an arbitrary
> prescribable Hodge structure (§3).

This is the exact analogue, at the coefficient level, of the ambient packet's
Test 6 warning (`AMBIENT_HODGE_REES_BRIDGE/ADVERSARIAL_TESTS.md`): Prym and
cover geometries *can* carry the Weil module, and the exclusion must be run
against the actual carrier, never against a surrogate.

---

## 3. The witness

> **Theorem R3-4 (a nonconstant local system whose `IH^1` is exactly
> `H^1(E_{-11})`).**  Let `E = E_{-11}`, `iota = [-1]`, and let
> \[
> f:\ E\longrightarrow E/\iota=\mathbf P^1
> \]
> be the degree-two quotient, branched exactly at the four points
> `S = f(E[2])`.  Put `U = P^1 \ S` and let `L` be the rank-one `Q`-local
> system on `U` with monodromy `-1` around each point of `S`, so that
> `f_*\mathbf Q_E = \mathbf Q \oplus j_{!*}\mathcal L` on `P^1`.  Then `L` is
> **nonconstant**, has monodromy group of order **two**, and
> \[
> \boxed{\ IH^1(\mathbf P^1,\mathcal L)\;=\;H^1(E,\mathbf Q)^{-}\;=\;H^1(E_{-11},\mathbf Q)\ }
> \]
> a two-dimensional weight-one Hodge structure with CM by `Q(sqrt(-11))`.
> Consequently
> `Hom_{HS}(Res T, IH^1(P^1,L)) != 0`, i.e. **(AHS-spin) is satisfied** by a
> nonconstant local system on a rational curve.

*Proof.*  `f` is the quotient by an involution with four fixed points, so
`f_*Q_E` splits into the invariant part `Q_{P^1}` and an anti-invariant part;
on `U` the latter is the rank-one system with monodromy `-1` at each puncture,
and on a curve the middle extension of a local system is `j_*`, so the
anti-invariant summand of `f_*Q_E` is `j_{!*}L = j_*L`.  Taking cohomology,
`H^1(P^1, j_*L) = H^1(E,Q)^- = H^1(E,Q)`, because `iota` acts by `-1` on
`H^1` of an elliptic curve.  As a Hodge structure this is `H^1(E_{-11})`.

*Euler-characteristic cross-check (§A).*  `L` has rank one with nontrivial
local monodromy at all four punctures, so `j_*L` has zero stalk there and
`chi(P^1, j_*L) = chi_c(U, L) = 1\cdot chi(U) = 2-4 = -2`; `h^0 = 0` (no
invariants) and `h^2 = 0` (no coinvariants), so `h^1 = 2`, matching
`dim H^1(E,Q) = 2`.

*Nonzero Hom.*  `T` is `E_{-11}`-isotypic (Thm S0(2)), so
`Hom_{HS}(T, H^1(E_{-11},Q)) != 0`.  `QED`

> **Corollary R3-5 (`R3` is method-insufficient, equivariantly).**  Let
> `ell subset P(U)` be a `C_3`- or `C_5`-eigen-line, `H` its stabiliser
> (`D_12`, `C_6` or `D_10`), acting on `ell ~= P^1` through the residual
> `H/H_0` of order two.  Choose the four branch points as an
> `H/H_0`-stable subset of `ell`; the double cover branched there is an
> elliptic curve whose `j`-invariant varies nonconstantly with the
> configuration, so `j = -32768` is attained and the cover is `E_{-11}`.  The
> resulting `L` is `H`-equivariant, nonconstant, and satisfies (AHS-spin) with
> `IH^1(\ell, L) = H^1(E_{-11})`.  Hence subcell `O4g` — the only survivor of
> the `S2`, `S3` census cells for `V = U` — is **witnessed**, exactly as
> `O4d` is.

*Proof.*  The `H/H_0 = C_2` action on `P^1` is by an involution with two fixed
points; a `C_2`-stable four-point set exists in two-parameter families (e.g.
two free orbits), and the `j`-invariant of the associated double cover is a
nonconstant rational function of the configuration, hence surjective onto the
`j`-line, so `j(E_{-11}) = -32768` is attained (the same surjectivity argument
as `O4_EIGENPLANE_CURVES.md` §4's Hesse corroboration).  Equivariance of `L` is
the equivariance of `f_*Q`.  `QED`

**The reduction proposed for `R3` fails at its last step.**  Grant the
conclusion of Lemma R3-1 for free — the witness has monodromy of order two, so
it is isotrivial with finite monodromy.  "Pass to the finite cover" then lands
on `E = E_{-11}` itself, and the carrier `IH^1(P^1,L)` **is** `H^1(E)`.  There
is no residual constraint on `E`: it is a curve with `E_{-11}` in its
Jacobian, which is exactly `FRONTIER-1` of `DEPENDENCY_MAP.md` §5 — the
frontier already known to be occupied by the Theorem O4-5 Hesse cubic.  So
`R3` does not reduce to `R2`; it reduces to the frontier that blocks the
headline anyway.

---

## 4. What survives of the lemma

Lemma R3-1 is not wasted.  Three uses, stated so they are not lost:

1. It closes, unconditionally, the sub-case in which the CM structure is
   horizontal — for instance any strict support whose local system is a
   sub-variation of `R^1` of a family of abelian varieties with
   `Q(sqrt(-11))`-multiplication over the stratum.  That case is now dead.
2. It shows that "nonconstant local system" cannot be taken to mean "large
   monodromy": the witness of §3 has monodromy of order two, so the residual
   `O4g` is not a wild object and the intuition that a nonconstant `L` should
   be hard to arrange is wrong.
3. It is stated at general weight-one rank `2g` and general CM field `F`, so
   it applies verbatim to the ambient packet
   (`AMBIENT_HODGE_REES_BRIDGE/`), where the same residual was recorded and
   the same reduction was contemplated.

---

## 5. Adversarial tests

### R3-T1.  The mandatory `D_12` test (Cor IX.6) — PASSED

This file contains one kill (Cor R3-2, the horizontal-CM sub-case) and one
witness (Thm R3-4).  The witness cannot contradict an existence theorem.  The
kill removes only variations with horizontal `Q(sqrt(-11))`-multiplication; the
realised `D_12`-map is free to route through the witness instead, whose
stabiliser `D_12` acts on the `C_3`-eigen-line of orbit 55 (Prop O4-7's
stabiliser table), with `dim T^{D_12} = 2 > 0`.  **PASS**, with the same
informative sign as `O4-T1`: the surviving subcell is the one the realised map
may occupy.

### R3-T2.  Does Thm R3-4 contradict Prop O4-7 (whole eigen-lines are dead)? — NO

Prop O4-7 kills the whole eigen-line **in the constant-coefficient channel**
(`IH^1(P^1,Q) = 0`) and explicitly leaves "a nonconstant local system on a
dense open subset" as the survivor.  Thm R3-4 supplies exactly that survivor.
The two statements are the two halves of the same dichotomy.

### R3-T3.  Is `j_{!*}L = j_*L` on a curve? — YES

For a local system on a smooth open curve the intermediate extension of
`L[1]` is `(j_*L)[1]`; no stalk condition is needed beyond the standard one,
and with nontrivial local monodromy the stalks of `j_*L` at the punctures
vanish, which is what the Euler-characteristic cross-check uses.

### R3-T4.  Is the Kronecker step of Lemma R3-1 legitimate without an integral structure? — NO, AND IT IS HYPOTHESISED

Without a lattice, `U^1(F)(Q)` is infinite (Hilbert 90: `u = v/\bar v`), and
the monodromy need not be finite.  The lemma therefore **assumes** an integral
structure, which is available for the local systems occurring in the
decomposition theorem for a `Z`-Hodge module.  Stating this hypothesis is the
"exact hypotheses" the residual asked for, and it is the second reason — after
Observation R3-3 — that the naive form of the reduction is not free.

### R3-T5.  No withdrawn machinery — PASSED

No Chow projector, no canonical splitting, no restricted-graph transfer, no
fixed-point statement.  Lemma R3-1 uses only the definition of a polarizable
VHS, Kronecker's theorem and Shimura–Taniyama; Thm R3-4 uses only the
decomposition of `f_*Q` for a double cover of curves.

---

## 6. Exit

```text
R3-METHOD-INSUFFICIENT
CM-RIGIDITY-LEMMA-PROVED        (Lemma R3-1, with the integral-structure hypothesis stated)
R3-HORIZONTAL-CM-SUBCASE-DEAD   (Cor R3-2)
O4G-WITNESSED                   (Thm R3-4, Cor R3-5: IH^1(P^1,L) = H^1(E_{-11}))
R3_CM_OK                        (verifier marker)
```

`R3-CLOSED` is **not** claimed and is now known to be unreachable by this
route: the residual subcell `O4g` carries an explicit witness with monodromy of
order two, and the proposed reduction, even granted its conclusion, lands on
`FRONTIER-1`.
