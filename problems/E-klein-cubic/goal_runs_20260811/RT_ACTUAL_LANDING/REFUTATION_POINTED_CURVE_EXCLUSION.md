# The pointed-line cylinder/Gysin automorphism `T_D`, and exactly what it refutes

Exits:
`POINTED-LINE-CYLINDER-AND-GYSIN-ISOGENIES-EXIST`,
`ORBIT-SUMMED-FULL-SUPPORT-ENDOMORPHISM-EXISTS`,
`SLICE-LOCAL-POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED`,
`KLEIN-INCIDENCE-MAP-FINITE`,
`GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED` (unchanged).

Provenance: adjudicated port of external round 3, section 7 (`SOURCES.md` A,
message `[21]`). The construction is **correct**, and simpler than the source
makes it. Three steps the source asserts without proof are proved here
(2.2, 3.2, 3.3); one step is **corrected in the direction of strength** (3.1:
the "`a A`" term is identically zero, so the operator is invertible for *every*
`m != 0`, not just for all but finitely many); one hypothesis the source did not
state is supplied and discharged from the packet's own Macaulay2 computation
(2.4: `e` is finite because the Klein cubic has no Eckardt points).

**The headline of the source is overclaimed and is corrected here.** The
construction does not touch the packet's boxed exclusion as literally written.
See section 5 — this is the decisive judgment of the round.

---

## 1. Statement

`F = F(X)` is the Fano surface of lines of the Klein cubic `X`,
`I ⊂ F x X` the universal line (the **incidence threefold**), with
`pi : I → F` the `P^1`-bundle projection and `e : I → X` the evaluation.
`V = H^3(X,Q)(1)`. `G = PSL_2(F_11)` acts on all of them compatibly.

**Theorem 1.1.** Fix a `G`-invariant ample class `C` on `F`, an integer
`a >= 1`, an integer `m >= 1`, and set `xi = e^* H_X`,
`L_{a,m} = a xi + m pi^* C`. For `k >> 0` let `D ∈ |k L_{a,m}|` be a general
member. Then `D` is a smooth surface, `e|_D : D → X` is generically one-to-one
onto its image, and the composite

```
T_D  :  V --alpha_D--> H^1(D,Q) --beta_D--> V,
alpha_D = r_* q^*,        beta_D = (e|_D)_*
```

is an **automorphism** of the `G`-Hodge structure `V`. Explicitly

```
T_D  =  k m · B_C ∘ alpha_F ,                                          (T)
```

where `alpha_F = pi_* e^* : V → H^1(F,Q)` is the Clemens–Griffiths cylinder
isomorphism and `B_C = e_* pi^*(C ∪ -) : H^1(F,Q) → V`. `T_D` preserves
`H^3(X,Z)`, commutes with `G`, and therefore lies in
`End_{G-HS}(V_Z) = O_K`, `K = Q(sqrt(-11))`, where it automatically satisfies
the Rosati-norm identity `T_D^† T_D = N_{K/Q}(T_D) · id_V`.

---

## 2. The two isomorphisms

### 2.1 `alpha_F` — Clemens–Griffiths (16). CITATION CONFIRMED.

**Fact.** `alpha_F = pi_* e^* : H^3(X,Q)(1) → H^1(F,Q)` is an isomorphism of
Hodge structures.

This is the cylinder-map theorem of **Clemens–Griffiths**, *The intermediate
Jacobian of the cubic threefold*, Ann. of Math. **95** (1972), 281–356, §10 and
Theorem 11.19: the cylinder homomorphism `H_1(F,Z) → H_3(X,Z)` is an
isomorphism, equivalently `Alb(F) ≅ J(X)`; `alpha_F` is its transpose. The
source's (16) quotes it correctly, including the Tate twist. (`SOURCES.md`
item 7 already records this paper for a different theorem of the same source.)

### 2.2 `B_C` is an isomorphism (17). PROOF SUPPLIED.

The source justifies (17) by the phrase "hard Lefschetz + homological cylinder".
That is the right idea but not a proof; the second half is not a citation to
anything. Here it is.

**Proposition 2.2.** Let `C` be an ample class on `F`. Then
`B_C = e_* pi^* (C ∪ -) : H^1(F,Q) → H^3(X,Q)(1)` is an isomorphism.

*Proof.* Factor `B_C = Gamma_* ∘ (C ∪ -)` where `Gamma_* = e_* pi^*`.

**(a)** `C ∪ - : H^1(F,Q) → H^3(F,Q)(1)` is an isomorphism. `F` is a smooth
projective surface and `C` is ample, so this is **hard Lefschetz**
`L^{n-k} : H^k ≅ H^{2n-k}` with `n = 2`, `k = 1`.

**(b)** `Gamma_* = e_* pi^* : H^3(F,Q) → H^3(X,Q)` is an isomorphism. Let
`iota = (pi, e) : I ↪ F x X` be the (closed, smooth) incidence subvariety, so
`pr_F iota = pi` and `pr_X iota = e`. For `alpha ∈ H^*(F)`,

```
pr_{X*}( pr_F^* alpha ∪ [I] ) = pr_{X*} iota_* iota^* pr_F^* alpha
                              = e_* pi^* alpha = Gamma_* alpha,
```

and symmetrically `pr_{F*}(pr_X^* beta ∪ [I]) = pi_* e^* beta = alpha_F(beta)`.
Applying the projection formula twice inside `F x X`, for `alpha ∈ H^3(F)` and
`beta ∈ H^3(X)`,

```
< Gamma_* alpha , beta >_X  =  ∫_{F x X} pr_F^* alpha ∪ [I] ∪ pr_X^* beta
                            =  < alpha , alpha_F(beta) >_F .           (2.1)
```

Both pairings are the perfect Poincaré pairings
`H^3(X) x H^3(X) → Q(-3)` and `H^3(F) x H^1(F) → Q(-2)`. So (2.1) says
`Gamma_*` is the Poincaré-dual map of `alpha_F`. By 2.1, `alpha_F` is an
isomorphism; hence so is its dual `Gamma_*`.

Composing (a) and (b) gives the claim. Twists: `C ∈ H^2(F,Q)(1)`, so
`C ∪ - : H^1(F) → H^3(F)(1)`; `pi^*` preserves the twist; `e_*` between smooth
projective varieties of the same dimension is a `(0,0)`-morphism of Hodge
structures. So `B_C : H^1(F,Q) → H^3(X,Q)(1) = V`, matching `alpha_F` head to
tail. ∎

> **What was really being asserted.** "Homological cylinder" was doing the work
> of step (b), which is not an extra theorem: it is Clemens–Griffiths again,
> read through Poincaré duality. Once that is seen, `B_C alpha_F` is visibly
> "the cylinder isomorphism composed with its Lefschetz-twisted adjoint" — an
> element of `End_{G-HS}(V)` for `C` invariant.

**`G`-invariant ample classes exist** on `F`: take any ample `C_0` and set
`C = sum_{g ∈ G} g^* C_0`, which is ample (the ample cone is open and convex and
`G`-stable) and invariant. Then `B_C` commutes with `G`, so
`B_C alpha_F ∈ End_{G-HS}(V)`.

---

## 3. The divisor, and the collapse of the operator

### 3.1 `M_{a,m}` (18). CORRECTED — the `xi` term vanishes identically.

Define `M_{a,m} : H^1(F,Q) → V` by `M_{a,m}(v) = e_*( L_{a,m} ∪ pi^* v )`.

**Proposition 3.1.** `M_{a,m} = m · B_C` for all `a, m`. In particular
`M_{a,m}` is an isomorphism for **every** `m != 0`, with
`det M_{a,m} = m^{10} det B_C`.

*Proof.* `L_{a,m} = a xi + m pi^*C`, so
`M_{a,m}(v) = a e_*(e^*H_X ∪ pi^*v) + m e_*(pi^*(C ∪ v))`. By the projection
formula the first term is `a · H_X ∪ e_*(pi^* v)`, and
`e_*(pi^* v) ∈ H^1(X,Q) = 0` because `X` is a smooth cubic threefold
(`b_1(X) = 0` by Lefschetz). So the first term is zero and the second is
`m B_C(v)`. Finally `dim_Q H^1(F,Q) = 2 q(F) = 10`. ∎

> **Adjudication.** The source's route — "determinant polynomial in `m` with
> leading term `m^{10} det B_C`, hence an isomorphism for all but finitely many
> `m`" — reaches a true conclusion by a detour. The determinant polynomial is a
> *monomial*: `a A + m B_C` with `A = 0`. This **strengthens** the claim (all
> `m != 0`, not "all but finitely many") and removes the only place where the
> source's argument was non-effective.
>
> It also settles half of the repository's own
> `LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL`
> (`COUNTERMODEL_CONIC_SLICE.md` §5), which records, ported but never replayed,
> that for `[D] = r·eta + n·pi^*C` the cylinder endomorphism is `±2n·id`
> "the coefficient `r` cancelling". **The `r`-cancellation is now proved**: it is
> exactly `A = 0`, i.e. `e_* pi^* = 0` on `H^1`. The residual "`= ±2·id`" factor
> is the classical Clemens–Griffiths double-cylinder relation for the specific
> polarization class and is still **not replayed here**; nothing below depends on
> it. `LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL` stays conditional, with its first
> half discharged.

### 3.2 Ampleness — a hypothesis the source did not state. SUPPLIED.

`L_{a,m}` must be ample for `k L_{a,m}` to be very ample and for Bertini to give
a smooth `D`. `pi^*C` is nef but never ample (it is zero on the fibres of `pi`),
so ampleness rests on `xi = e^*H_X`, which is ample **iff `e` is finite**.

**Lemma 3.2 (`e` is finite on the Klein cubic).** For a smooth cubic threefold
`X`, `e : I → X` fails to be finite exactly at points lying on infinitely many
lines of `X`, and those are exactly the Eckardt points. The Klein cubic has
none, so `e : I → X` is finite (flat of degree 6) and `xi` is ample.

*Proof.* Fix `x ∈ X` and coordinates with `x = [1:0:0:0:0]`, so
`F = x_0^2 L(y) + x_0 Q(y) + C_3(y)` with `y = (x_1,...,x_4)`. A line through
`x` in direction `[y]` lies in `X` iff `L(y) = Q(y) = C_3(y) = 0`, a hyperplane,
a quadric and a cubic in `P^3`: finitely many (six) points unless
`Q|_{L=0}` and `C_3|_{L=0}` share a component in the plane `{L = 0} ≅ P^2`. A
shared component of degree `1` or `2` would make `X` contain a plane or a
quadric surface; both are impossible since `Pic X = Z·H` forces every surface in
`X` to have degree divisible by `3`. A shared component of degree `3` forces
`Q|_{L=0} ≡ 0`, i.e. the tangent hyperplane section is a cone with vertex `x`:
`x` is an **Eckardt point**. The Klein cubic has no Eckardt points — exact
Macaulay2 computation `eckardt_klein.m2`, output `ideal 1`, exit
`KLEIN-CUBIC-NO-ECKARDT-POINTS` (`THEOREM_LEAKAGE_CLASSIFICATION.md` §4.5). So
`e` is quasi-finite and proper, hence finite, and `xi = e^*H_X` is ample. ∎

Exit `KLEIN-INCIDENCE-MAP-FINITE`. This is a **new composed corollary**: the
packet's own Eckardt computation, made for an unrelated purpose (to show the
`|H|` cone countermodel does not live on the Klein cubic), is exactly the input
that makes the incidence polarization ample here.

### 3.3 The two tautological identities (the projection-formula step). PROVED.

Let `D ∈ |k L_{a,m}|` be smooth (Bertini, `k >> 0`), `j : D ↪ I` the inclusion,
`pi_D = pi ∘ j : D → F`, and `U_D = D x_F I` with `r : U_D → D`,
`pr_2 : U_D → I`, `q = e ∘ pr_2 : U_D → X`. `D ⊂ I` gives the tautological
section of `r`.

**(19) Weak Lefschetz.** `D` is a smooth ample divisor in the smooth threefold
`I`, so `H^k(I,Q) → H^k(D,Q)` is an isomorphism for `k < dim D = 2`. And
`H^1(I,Q) = pi^* H^1(F,Q)` since `pi` is a `P^1`-bundle. Hence

```
pi_D^* : H^1(F,Q)  -->  H^1(D,Q)   is an isomorphism.                  (19)
```

**Proposition 3.3(a).** `alpha_D := r_* q^* = pi_D^* alpha_F`, hence an
isomorphism `V → H^1(D,Q)`.

*Proof.* The square `(U_D, r, pr_2; D, I, pi_D, pi)` is cartesian with `pi`
proper and flat (a `P^1`-bundle), so base change gives `r_* pr_2^* = pi_D^* pi_*`
on cohomology. Therefore
`r_* q^* = r_* pr_2^* e^* = pi_D^* pi_* e^* = pi_D^* alpha_F`. Compose the
isomorphisms 2.1 and (19). ∎

**Proposition 3.3(b) — the step the source states without proof.**

```
beta_D ∘ pi_D^*  =  k · M_{a,m}  =  k m · B_C ,
```

where `beta_D = (e|_D)_* : H^1(D,Q) → V`.

*Proof.* For `v ∈ H^1(F,Q)`, using `e|_D = e ∘ j` and `pi_D^* = j^* pi^*`,

```
beta_D pi_D^* v = e_* j_* j^* pi^* v
                = e_*( pi^* v ∪ j_*(1) )        (projection formula for j)
                = e_*( pi^* v ∪ [D] )
                = k · e_*( pi^* v ∪ L_{a,m} )   ([D] = k L_{a,m})
                = k · M_{a,m}(v)  =  k m B_C(v)   (Prop. 3.1). ∎
```

**Proof of Theorem 1.1.** `T_D = beta_D alpha_D = beta_D pi_D^* alpha_F =
k m B_C alpha_F` by 3.3(a),(b), which is `(T)`. It is an automorphism of `V` as
a composite of the isomorphisms 2.1 and 2.2 times the nonzero scalar `km`. ∎

> **The collapse.** `T_D` does not depend on `D` at all beyond the scalar `km`.
> The whole divisor apparatus contributes a number; the operator is
> `B_C ∘ alpha_F`, the Clemens–Griffiths cylinder composed with its
> Lefschetz-twisted Poincaré adjoint. That is worth stating plainly, because it
> is what makes the next two items automatic.

### 3.4 Cycle formula, `G`-equivariance (21). CONFIRMED and SHARPENED.

```
T_D(x) = e_*( [D] ∪ pi^*( pi_* e^* x ) ),                              (21)
```

immediately from 3.3. So `T_D` depends only on the **cohomology class** `[D]`.

*Sharpening.* `[D] = k L_{a,m} = k(a xi + m pi^*C)` is `G`-invariant for
**every** member `D` of the system, because `xi` and `C` are. Since `pi` and `e`
are `G`-equivariant, `g^* T_D = T_D g^*` for all `g ∈ G`. So no orbit sum is
needed to make the *operator* equivariant; the source's fallback ("non-stable
`D`: sum the `G`-orbit, same operator times a positive integer") is correct but
unnecessary at the level of `T_D`. It **is** needed if one wants the *receiver
surface itself* to be `G`-stable — see the limitation in section 6.

### 3.5 Integrality and the Rosati norm (22). CONFIRMED.

`[D] ∈ H^2(I,Z)` and `pi^*, e^*, pi_*, e_*` all preserve integral cohomology, so
(21) shows `T_D` preserves `H^3(X,Z)` (which is torsion-free, `≅ Z^{10}`).
Together with `G`-equivariance and the Hodge property,

```
T_D  ∈  End_{G-HS}(V_Z)  =  O_K,     K = Q(sqrt(-11)),
```

by `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md`
eq. (4.1) (`End_{G-HS}(V) = K`, from `V_C = W_5 ⊕ W̄_5` with nonisomorphic
conjugate summands) and eq. (4.2) (`End_{G-HS}(V_Z) = O_K`, `h(K) = 1`). The
Rosati involution on `K` is complex conjugation (*ibid.*), so for any
`z ∈ O_K`, `z̄ z = N_{K/Q}(z) ∈ Z_{>0}`, i.e.

```
T_D^† T_D = N_{K/Q}(T_D) · id_V                                        (22)
```

**automatically**, with `N(T_D) = (km)^2 N(B_C alpha_F)`. This is exactly the
shape the CLEAN branch permits: `RESTRICTED-CLEAN-CM-NORM-PROVED` gives
`delta = N(u_phi) = x^2 + xy + 3y^2` for a CLEAN degree, and `T_D` is an integral
element of the same order. So the norm identity is **no obstruction at all**
here — it is a consequence of the CM structure, not a constraint the
construction has to earn.

### 3.6 The generic slice of `D` (23). CONFIRMED.

At a general point of `D`, the datum is one line of `X` with one marked point, so
in the local model `A = t b + s c` with `H = t`, `f = s`, `B = b`, `C = c`
constant. `F(tb + sc) ≡ 0` forces `F(b) = Phi(b,b,c) = Phi(b,c,c) = F(c) = 0`
(the line `<b,c>` lies in `X`), and then the four identities hold with
`R_0 = R_1 = R_3 = 0`; the slice ideal is `(s,t)` since `b, c` are independent.
This is the **line-type cell** of `SLICE_CLASSIFICATION.md` Corollary 1.2 — the
simplest one. Verified as the `e = 1` instance in
`verify_slice_universality.py` (`[line e=1]`, `R_1 = R_3 = 0`).

So the correspondence realizing an automorphism of `V` sits in the *easiest*
slice cell, not in the exotic higher-jet ones. The conic and higher-jet cells
of `SLICE_CLASSIFICATION.md` are not needed for the refutation; they are needed
only to show that no *classification* argument can restrict to lines.

---

## 4. What is true, stated as a theorem

**Theorem 4.1 (existence).** On the Klein cubic there exist smooth projective
surfaces `D`, ruled by a family of pointed lines of `X`, together with
correspondences

```
V --alpha_D--> H^1(D,Q) --beta_D--> V
```

built from that family (cylinder in, Gysin out), whose composite is an
invertible, `G`-equivariant, integral endomorphism of `V` satisfying the
Rosati-norm identity. Summing over a `G`-orbit of such `D` multiplies the
operator by a positive integer and makes the receiver `G`-stable.

Exits `POINTED-LINE-CYLINDER-AND-GYSIN-ISOGENIES-EXIST`,
`ORBIT-SUMMED-FULL-SUPPORT-ENDOMORPHISM-EXISTS`.

**Corollary 4.2 (the actual refutation).** The following statement is **FALSE**:

> **Slice-local pointed-rational-curve exclusion.** Let `S` be a surface
> carrying a family of pointed rational curves of `X` whose normalized
> two-dimensional slice ideals satisfy the landing identities `(10)`. Then the
> orbit-summed curve/Gysin correspondence `V → IH^1(S,Q) → V` vanishes.

*Proof.* Theorem 4.1 with `S = e(D)`; the generic slice is line-type and
satisfies `(10)` with `R_0 = R_1 = R_3 = 0` (3.6). ∎

Exit `SLICE-LOCAL-POINTED-RATIONAL-CURVE-FULL-SUPPORT-EXCLUSION-REFUTED`.

**Corollary 4.3 (the methodological content).** No obstruction depending only on

* the normalized two-dimensional slice ideals,
* their higher normal jets and decorated clusters, and
* the orbit-summed curve/Gysin correspondences those produce,

can close the common-factor branch of RT. Any proof must consume global data.

---

## 5. SCOPE ADJUDICATION — the decisive judgment

The source's own section 8 says "REFUTED: orbit-summed pointed rational-curve
families cannot realize the CLEAN full-support endomorphism", and its verdict
line calls the packet's requested exclusion "false". **That headline does not
survive adjudication.** The source is right in substance and wrong about which
statement it has hit; its own closing paragraph concedes the point ("The Fano
construction ... is not asserted to arise from one global ambient covariant: it
refutes the local-to-global exclusion without deciding Problem E"). We record
the concession as the finding and discard the headline.

### 5.1 What the box actually quantifies over

`BOXED_GLOBAL_COVARIANT.md` §2 reads, verbatim:

> Let `A = HB + FC` be a `G`-covariant ambient landing tuple for the Klein cubic
> `X`, i.e. a nonzero `A ∈ (Sym^d W^v ⊗ W)^G` with `F(A) = 0`, decomposed along a
> form `H` cutting the divisorial common factor `D_X` of `A|_X` ... Classify the
> normalized two-dimensional slice ideals **of such tuples** at the generic
> points of the irreducible components of `D_X` ... and prove that the
> orbit-summed correspondences of **the resulting** pointed rational-curve
> families cannot realize the full-support endomorphism required by CLEAN — that
> is, cannot produce a nonzero composite `V → IH^1(S,Q) → V` **for any orbit of
> components `S ⊂ D_X`**.

Three quantifiers are load-bearing and all three are missed by `T_D`:

1. **"of such tuples"** — the families must arise as the slice data of an
   *actual* `G`-covariant landing tuple. `D ⊂ I` is a general member of a
   linear system on the incidence threefold; no landing tuple is anywhere in
   its construction.
2. **"the resulting"** — the correspondence must be the one produced by that
   tuple's slices. `T_D`'s correspondence is produced by a divisor class chosen
   freely.
3. **"`S ⊂ D_X`"** — the receiver must be a component of that tuple's divisorial
   common factor. `e(D) ⊂ X` is not exhibited as a component of any `D_X`.

### 5.2 Verdict

```
The packet's boxed exclusion, as literally written, is NOT REFUTED.
What is refuted is the local-to-global-free (slice-local) strengthening
of its second half, Corollary 4.2.
```

This is the same distinction the packet already drew, in advance, for the conic
countermodel: `COUNTERMODEL_CONIC_SLICE.md` §4 ("Scope of the countermodel —
stated honestly") says the conic tuple "does **not** exhibit a global homogeneous
`G`-covariant landing tuple ... The distinction is recorded because it is
exactly the distinction the boxed theorem turns on." Round 3 walks into the same
distinction from the other side and, on its headline, does not respect it.

### 5.3 Consequence for the box: SHARPEN, do not delete

The box survives, and is **sharpened** in `BOXED_GLOBAL_COVARIANT.md` (revised
in this branch) to make all five global data simultaneous and explicit — global
degree, `G`-representation, incidence, attachment, and the landing identities —
and to record that the slice-local version is now *known false*, so that no
future attempt wastes effort on it. Exit
`GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED` is unchanged.

---

## 6. Consistency with the rest of the packet, and new composed corollaries

### 6.1 The double-hit input — CONFIRMED against the repository artifact

The source cites, parenthetically, a "repo double-hit argument for high very
ample divisors; split divisors occur in unbounded classes". That artifact exists
and says exactly what is needed:
`goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md` §5, verbatim:

> "Let `D_0` be a sufficiently general divisor in a high very-ample system on the
> incidence threefold `I`. On the finite locus of `e`, the off-diagonal fibre
> product `(I x_X I) \ Delta_I` has dimension three. Requiring both points to
> lie in `D_0` imposes two independent divisor conditions, so the double-hit
> locus has dimension at most one. Therefore `e|_{D_0} : D_0 ⇢ e(D_0)` is
> generically one-to-one." ... "Taking the union of the finitely many translates
> `g D_0` gives a `G`-stable split divisor ... its class grows with the chosen
> very-ample power."

Exit `DELTA1-INVARIANT-SPLIT-DIVISORS-UNBOUNDED`. Note that "on the finite locus
of `e`" is a real hypothesis there; Lemma 3.2 above discharges it globally for
the Klein cubic. **CONFIRMED**, and one hypothesis upgraded.

### 6.2 The receiver must be singular — the construction INSTANTIATES
`CLEAN-IMPLIES-NON-RATIONAL-SINGULAR-RECEIVER-PROVED`

**Corollary 6.2.** `e(D) ⊂ X` is **not** smooth, and **not** normal with
rational singularities.

*Proof.* `e(D)` is an irreducible reduced surface in the smooth cubic threefold
`X`, so `H^1(e(D), O) = 0` (`THEOREM_LEAKAGE_CLASSIFICATION.md` Lemma 4.1, whose
proof uses only that `X` is a smooth hypersurface — it is *not* special to
common-factor components). If `e(D)` were smooth, or normal with rational
singularities, then `IH^1(e(D),Q) = 0` by Theorem 4.3 there. But `e|_D` is
generically one-to-one, so `D` is a smooth model of `e(D)` and
`IH^1(e(D),Q) = H^1(D,Q) ≅ H^1(F,Q) = Q^{10} != 0` by (19). ∎

So the `T_D` construction does not contradict the packet's CLEAN-cost theorem —
it is a **witness for it**, and the mechanism is the double-hit locus of 6.1:
`e|_D` is generically injective but has a double curve (a map from a surface to a
threefold has double locus of expected dimension `2·2 - 3 = 1`), and `e(D)` is
therefore **non-normal**. Sharper: 6.2 *proves* that the double locus is
nonempty, which the dimension count alone only makes expected.

### 6.3 Relation to `CONDUCTOR-GYSIN-EXCLUSION-REFUTED-RATIONALLY`

`REFUTATION_CONDUCTOR_GYSIN.md` Theorem 2.1 already gives, by Bloch–Srinivas,
a proper divisor `D' ⊊ X` and `G`-equivariant `Q`-correspondences with
`j_* Gamma_* = id_V`, unconditionally on every smooth cubic threefold. `T_D` is
**not a contradiction and not a duplicate**: it is a refinement in three
respects — the divisor and the correspondence are *explicit*, the correspondence
is built from an *honest family of pointed lines* (which Bloch–Srinivas does not
provide), and the operator is *integral*, not merely rational. Conversely
Bloch–Srinivas gives the identity itself, which `T_D` does not (it gives
`km B_C alpha_F`, an unspecified element of `O_K^×`). The two are complementary
and consistent. No exit changes.

### 6.4 Interaction with the retraction corollary and the `d >= 6` floor — NONE,
and this is itself informative

The packet's retraction corollary is: `delta = 1` (identity restricted map)
forces `D_X != 0`, hence `D_X ∈ |kH|` with `k >= 5` by the sealed invariant-degree
lemma (`COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED`), hence `d >= 6`.

`T_D` produces no landing tuple, so it cannot lower that floor. In the other
direction:

**Corollary 6.4 (degree of the `T_D` receiver).** `e_*[D] = k(6a + lambda m) H_X`
with `lambda = C · pi_*(xi^2) > 0` — since `e` is finite of degree 6 (Lemma 3.2),
`e_* xi = e_* e^* H_X = 6 H_X`, and `pi_*(xi^2)` is a nonzero effective curve
class on `F` because `xi` is ample and `xi · (fibre) = 1`. So the receiver's
degree in `X` grows linearly in `k`, and the construction requires `k >> 0`
(for `k L_{a,m}` very ample, for Bertini smoothness, and for the double-hit count
of 6.1). Hence:

* the `T_D` route produces **no candidate in the window `5 <= k <= 10`**, which
  is precisely the window where the packet's `G`-stability lemma
  (`CLEAN-COMPONENTS-G-STABLE-FOR-k-AT-MOST-10-PROVED`) forces a single
  `G`-stable component. If a `T_D`-type object were ever realized inside a
  `D_X`, it would land in the `k >= 11` regime, where the receiver may be an
  orbit of components with `Stab(S) < G` and the packet has no leverage.
* the construction exhibits no *individually* `G`-stable smooth `D`: `[D]` is
  `G`-invariant but a general member of a `G`-invariant system is not `G`-fixed,
  and the orbit sum `sum_g gD` is reducible with permuted components. Whether a
  `G`-fixed member of `|k L_{a,m}|` can be chosen smooth (Bertini on the
  invariant subsystem `P(H^0(kL)^G)`, whose base locus is not controlled here) is
  **not decided** by this round.

Both bullets are limitations of the refutation, not of the box; they are recorded
because they say where a globalization attempt would have to start.

### 6.5 No contradiction with the leakage classification

`THEOREM_LEAKAGE_CLASSIFICATION.md` Theorem 2.3 says leakage can only go through
`S ⊂ D_X`, `dim S = 2`, `j = 0`, block `IC_S(U)(-1)`, carrier `IH^1(S,U)`, and
Corollary 3.2 says only the constant quotient of `U` leaks. `T_D` factors
through `H^1(D,Q) = IH^1(e(D),Q)` with **constant** coefficients, i.e. exactly
through the one channel that the collapse theorem leaves open. Consistent, and
in the predicted channel.

---

## 7. Verdicts, per claim of the source's section 7

| tag | claim | verdict |
|---|---|---|
| (16) | Clemens–Griffiths `alpha_F` isomorphism | **CONFIRMED** — citation correct |
| (17) | `B_C` isomorphism | **CONFIRMED WITH SUPPLIED PROOF** (Prop. 2.2: hard Lefschetz + Poincaré adjunction to `alpha_F`) |
| (18) | `M_{a,m} = aA + mB_C` iso for all but finitely many `m` | **CONFIRMED, CORRECTED AND STRENGTHENED** — `A = 0`, so `M_{a,m} = mB_C`, iso for every `m != 0` |
| (18') | `L_{a,m}` very ample | **HYPOTHESIS SUPPLIED** — needs `e` finite; discharged from `KLEIN-CUBIC-NO-ECKARDT-POINTS` (Lemma 3.2) |
| (19) | weak Lefschetz `pi_D^*` iso | **CONFIRMED** |
| (20a) | `alpha_D = pi_D^* alpha_F` | **CONFIRMED WITH SUPPLIED PROOF** (flat base change on the cartesian square) |
| (20b) | `beta_D pi_D^* = k M_{a,m}` | **CONFIRMED WITH SUPPLIED PROOF** (projection formula for `j : D ↪ I`) — the step flagged for careful checking |
| (20) | `T_D ∈ Aut_HS(V)` | **CONFIRMED**, with the closed form `T_D = km B_C alpha_F` |
| (21) | cycle formula, `G`-equivariance | **CONFIRMED AND SHARPENED** — `[D]` is invariant for every member; no orbit sum needed for the operator |
| (22) | integrality, `End_{G-HS}(V) = Q(sqrt(-11))`, automatic norm identity | **CONFIRMED** against `RT_SPLIT_AND_DICHOTOMY` (4.1), (4.2), Rosati = conjugation |
| (23) | generic slice of `D` is the line cell, all `R_i = 0` | **CONFIRMED**, machine-verified |
| §7 headline / §8 | "the requested CLEAN correspondence exclusion is false" | **SCOPE-CORRECTED** — refutes only the slice-local version (Cor. 4.2); the boxed statement is untouched and is sharpened instead |

**Problem E headline: OPEN.** Nothing here changes it.
