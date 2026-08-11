# Transfer of the actual landing class, and the `D_X = 0` restricted-transfer theorem

Exits: `ACTUAL-V-TOTAL-TRANSFER-PROVED`, `RT-DX0-PROVED`,
`RETRACTION-IMPLIES-NONZERO-DX-PROVED`.

Provenance: adjudicated port of an external ChatGPT session, messages `[10]`
section 1 and `[15]` section 1 and section 5. See `SOURCES.md` and
`ADJUDICATION.md`. Every step below was re-derived here; where the external
argument was under-justified the repair is marked **[repair]** and proved.

---

## 0. Setting and notation

`G = PSL_2(F_11)`, `W` the faithful irreducible 5-dimensional representation,
`X = V(F) ⊂ P(W) = P^4` the Klein cubic threefold,

```
F(x) = sum_{i in Z/5} x_i^2 x_{i+1}                  (SPEC.md, "Convention")
```

`V = H^3(X,Q)(1)`, an irreducible rational `G`-module with
`V_C = W_5 ⊕ conj(W_5)`
(`goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md`).

An **ambient landing tuple** is a nonzero homogeneous `A ∈ (Sym^d W^v ⊗ W)^G`
with `F(A) = 0` identically — the repository convention, stated as Theorem B of
`goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/THEOREM.md`
("Let `P ∈ (Sym^d W_5^v ⊗ W_5)^G` be a nonzero homogeneous tuple with
`F(P)=0`"). Write

* `I_A ⊂ O_{P^4}` for the base ideal of `A`, `Y = Proj_{P^4} R(I_A)^~` the
  normalized ambient graph, `p : Y → P^4`, `q : Y → X` the landing map;
* `J ⊂ O_X` for the **primitive restricted base ideal**: restrict `A` to `X`,
  remove the common divisorial factor. The removed divisor is `D_X`, a
  `G`-invariant divisor in `|kH|` on `X`;
* `Γ = Proj_X R(J)^~`, `π : Γ → X` (birational), `q_Γ : Γ → X`
  (generically finite of degree `δ`).

`i : X ↪ P^4`. On `IH^3` we use the repository's canonical maps
(`THEOREM_RESTRICTED_DICHOTOMY.md`, Lemmas 2.1–2.2, Theorem 3.1):

```
i_pi, t_pi   with  t_pi i_pi = id,     e_0 = i_pi t_pi,   e_exc = 1 - e_0
i_q,  t_q    with  t_q  i_q  = delta*id
u_phi = t_pi i_q | V : V -> V          r_phi = e_exc i_q | V
```

CARRIER is `r_phi ≠ 0`, CLEAN is `r_phi = 0`.

---

## 1. The comparison morphism `h : Γ → Y` exists (repo input)

**Repository theorem.** `goal_runs_20260809/EXCEPTIONAL_CARRIER_RIGIDITY/AMBIENT_REES_COMPARISON.md`,
section 2, "Dominant-transform theorem", equation (2.1):

> Inside `Ŷ`, take the closure `X̂_dom = closure(pi^{-1}(X ∩ U))`. It is the
> unique irreducible component of the inverse image of `G_g` that dominates `X`.
> Then there is a canonical `G`-equivariant isomorphism
> `(X̂_dom)^ν ≅ Γ`. The source and landing morphisms on both sides agree.

Composing that isomorphism with normalization and the closed immersion
`X̂_dom ⊂ Y` gives the morphism the external source calls `h`:

```
h : Gamma  ---->  Y,    h  FINITE  (normalization then closed immersion),
p h = i pi,   q h = q_Gamma.                                          (1.1)
```

**Adjudication note.** The repository states the compatibility in words ("the
source and landing morphisms on both sides agree") rather than as the two
displayed equations, and never names the morphism `h`. The external source's
citation of a "dominant-transform theorem supplying `h`" is therefore
**CONFIRMED**, with the notational caveat recorded in `ADJUDICATION.md` item 2a.
One fact the external source did not use and which we do use below: **`h` is
finite**, because `Γ` is the normalization of a closed subvariety of `Y`.
`dim Y = 4`, `dim Γ = 3`, so `h(Γ)` is a divisor in `Y`.

---

## 2. The transfer morphism in `D^b MHM(Y)`

**Theorem 2.1 (transfer).** There is a `G`-equivariant morphism

```
Theta : IC_Y^H  ---->  R h_* IC_Gamma^H [1]                            (2.1)
```

in `D^b MHM(Y)`, whose composite with the canonical map from the constant Hodge
complex agrees with the pullback: the square

```
      Q_Y^H  ------------->  IC_Y^H [-4]
        |                        |
        | h-pullback             | Theta[-4]
        v                        v
   R h_* Q_Gamma^H  ---->  R h_* IC_Gamma^H [-3]
```

commutes.

*Proof.* Use the unshifted normalization `ĨC_Y = IC_Y[-4]`,
`ĨC_Γ = IC_Γ[-3]`; both are pure of weight `0`. Put
`K_Y = Cone(Q_Y^H → ĨC_Y^H)`.

**[repair] Step 1: `K_Y` has weights ≤ 0.** The external source asserts this
without proof. It does **not** follow from the triangle: from
`Q_Y → ĨC_Y → K_Y` and `w(Q_Y^H) ≤ 0`, `w(ĨC_Y) = 0`, the general estimate only
gives `w(K_Y) ≤ max(0, 0+1) = 1`, which is one unit too weak for Step 2. The
correct proof factors through a resolution. Let `rho : Ỹ → Y` be a projective
resolution (or any proper surjective `Ỹ → Y` with `Ỹ` smooth projective). Then:

* `R rho_* Q_Ỹ^H` (unshifted) is pure of weight `0`;
* `ĨC_Y` is a direct summand of `R rho_* Q_Ỹ^H` (decomposition theorem for the
  birational `rho`), and the canonical `Q_Y → ĨC_Y` factors as
  `Q_Y → R rho_* Q_Ỹ → ĨC_Y`;
* `Cone(Q_Y → R rho_* Q_Ỹ)` has weights `≤ 0`, i.e. the map is injective on the
  weight-`k` graded piece of `H^k`. In cohomological form this is exactly
  **Weber's theorem** (A. Weber, *Pure homology of algebraic varieties*,
  Topology 43 (2004) 635–644): for `Y` complete,
  `ker(H^k(Y,Q) → IH^k(Y,Q)) = W_{k-1}H^k(Y,Q)`, equivalently the image of
  `H^k(Y) → IH^k(Y)` is the pure quotient `gr^W_k H^k(Y)`; and the underlying
  descent statement `ker(H^k(Y) → H^k(Ỹ)) = W_{k-1}H^k(Y)` for `rho` proper
  surjective with `Ỹ` smooth is Deligne's. The object-level ("weights ≤ 0" in
  `D^b MHM(Y)`) form, which is what Step 2 consumes, is the corresponding
  statement in Saito's weight formalism. *Honest flag:* we verify the
  cohomological form against Weber and take the object-level form from Saito's
  six-functor weight package; we did not re-prove the object-level statement
  from scratch here. This is the one imported input of Theorem 2.1.
* Writing `R rho_* Q_Ỹ = ĨC_Y ⊕ R` with `R` pure of weight `0`, the octahedron
  gives a triangle `K_Y → Cone(Q_Y → R rho_* Q_Ỹ) → R`, hence
  `w(K_Y) ≤ max(0, w(R) - 1) = 0`.

**Step 2: weight orthogonality.** `h^*` preserves "weights ≤ w", so
`h^* K_Y[-1]` has weights `≤ -1`, while `ĨC_Γ` is pure of weight `0`. Hence

```
Hom_{D^b MHM(Gamma)} ( h^* K_Y [-1] , ĨC_Gamma ) = 0.
```

Applying `Hom(-, ĨC_Γ)` to `h^*Q_Y = Q_Γ → h^*ĨC_Y → h^*K_Y` shows the canonical
class in `Hom(Q_Γ, ĨC_Γ)` lifts to `Hom(h^*ĨC_Y, ĨC_Γ)`. Adjunction gives
`ĨC_Y → R h_* ĨC_Γ`, i.e. (2.1) after the shift by `[4]`.

**Step 3: equivariance.** The lift is *not* unique — uniqueness would need
`Hom(h^*K_Y, ĨC_Γ) = 0`, and the weight bound there is `≤ 0` against `≥ 0`,
which is not strict. The set of lifts is a torsor under that Hom-group, an
affine `Q`-subspace; the `G`-average `(1/|G|) sum_g g^* Theta` is again a lift,
and is `G`-equivariant. (Rational coefficients are essential and are what we
have.) ∎

**Corollary 2.2 (shift bookkeeping, checked).** Taking
`H^{k-4}(Y, -)` of (2.1) gives `Theta_H : IH^k(Y) → IH^k(Gamma)` for all `k`,
since `H^{k-4}(Y, R h_* IC_Γ[1]) = H^{k-3}(Γ, IC_Γ) = IH^k(Γ)` and
`dim Γ = 3`. The external source's normalizations `[−4]`, `[−3]`, `[1]` are all
internally consistent; verified line by line.

---

## 3. `Theta_H alpha_A = i_q`

Define, as in the repository,

```
alpha_A : V ---> IH^3(Y)(1),      alpha_A = nat_Y o q^*
i_q     : V ---> IH^3(Gamma)(1),  i_q     = nat_Gamma o q_Gamma^*
```

with `nat` the canonical map `H^3 → IH^3` (available because `X` is smooth, so
`V = H^3(X)(1) = IH^3(X)(1)`).

**Theorem 3.1.** `Theta_H alpha_A = i_q`.

*Proof.* By Theorem 2.1 the square commutes, so
`Theta_H o nat_Y = nat_Γ o h^*` on `H^3`. Hence
`Theta_H alpha_A = Theta_H nat_Y q^* = nat_Γ h^* q^* = nat_Γ (q h)^*
= nat_Γ q_Γ^* = i_q`, using `q h = q_Γ` from (1.1). ∎

**Lemma 3.2 (`i_q` is injective).** `q_Γ : Γ → X` is proper, surjective and
generically finite, `X` smooth. Choose a resolution `Γ̃ → Γ`; then `IH^3(Γ)` is
a direct summand of `H^3(Γ̃)` and the composite
`H^3(X) → H^3(Γ) → IH^3(Γ) ⊂ H^3(Γ̃)` is pullback along `Γ̃ → X`, which is
injective for a proper surjective map onto a smooth projective variety.
(Alternatively: `t_q i_q = delta * id` with `delta ≥ 1`, Lemma 2.2 of
`THEOREM_RESTRICTED_DICHOTOMY.md`, gives injectivity at once.) ∎

Theorem 3.1 + Lemma 3.2 is the external source's

> the actual copy of `V` cannot die under restriction, dominant-component
> selection, or normalization,

now as a morphism of `Q`-Hodge structures. Exit `ACTUAL-V-TOTAL-TRANSFER-PROVED`.

---

## 4. The `D_X = 0` theorem

Push (2.1) along `p`, using `p h = i pi`:

```
R p_* IC_Y^H  ---->  i_* R pi_* IC_Gamma^H [1]  --i_* t_pi[1]-->  i_* IC_X^H[1]. (4.1)
```

**Theorem 4.1 (RT in the no-common-factor branch).** If `D_X = 0` then

```
u_phi = t_pi i_q | V = 0        and        r_phi = i_q | V  is nonzero,
```

i.e. **the restricted graph is CARRIER**, and the full-support correspondence
of the graph vanishes identically.

*Proof.* Decompose `R p_* IC_Y^H = ⊕_j P_j[-j]` into strict-support summands.

1. *No full-support contribution.* `goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/AMBIENT_SUPPORT.md`
   section 4 and `THEOREM.md` Theorem B: `p` is an isomorphism off the base
   locus, so the only full-support constituent is `Q_{P^4}^H[4] ⊂ P_0`, with
   contribution `H^3(P^4) = 0`. Hence every contribution to `IH^3(Y)` comes
   from a **proper** strict support `M = IC_{S̄}^H(L) ⊂ P_j`, and each such `S`
   lies in the base locus of `A`.
2. *Leakage classification.* `THEOREM_LEAKAGE_CLASSIFICATION.md`, Theorem 2.4:
   a proper strict support `M` admits a nonzero component map
   `M[-j] → i_* IC_X^H[1]` only if `S ⊂ X` and `dim S = 2`; and then `S` is a
   component of `D_X`.
3. `D_X = 0` therefore kills every component map in (4.1), so the composite
   (4.1) induces the zero map on `H^{-1}(P^4, -)`, i.e.
   `t_pi Theta_H alpha_A = 0`.
4. By Theorem 3.1, `t_pi i_q|_V = 0`, i.e. `u_phi = 0`.
5. `r_phi = e_exc i_q|_V = (1 - i_pi t_pi) i_q|_V = i_q|_V`, nonzero by
   Lemma 3.2. ∎

Exit `RT-DX0-PROVED`. Equivalently, in the repository's dichotomy language:
**`D_X = 0` forces the CARRIER branch**, and `u_phi = 0`.

---

## 5. The retraction corollary

**Corollary 5.1.** If the restricted map `phi = [A]|_X` is the identity of `X`
(the retraction branch, `delta = 1`), then `D_X ≠ 0`.

*Proof.* If `phi = id_X` then `u_phi = id_V ≠ 0`, and Theorem 4.1 contrapositive
gives `D_X ≠ 0`. ∎

**Corollary 5.2 (degree floor, cross-check).** In the retraction branch,
`D_X ∈ |kH|` with `k ≥ 1` by Corollary 5.1, and `k ∈ {0} ∪ {5,6,7,...}` by the
sealed invariant-degree lemma
(`goal_runs_20260810/COMBINED_DEGREE_SIEVE/THEOREM_COMBINED_SIEVE.md`,
Lemma 2.3, exit `COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED`). Hence `k ≥ 5`.

This is a genuine cross-check rather than a new result: the repository's
retraction normal form is `T = H x + F Q` with `deg H = d - 1`
(`goal_runs_20260808/DELTA1_RETRACTION_POLAR_IDENTITY/THEOREM.md`, Theorem 1.1),
so `D_X = div(H|_X) ∈ |(d-1)H|` and `k = d-1`; Corollary 5.2 reproduces the
repository's degree floor `d ≥ 6` for a nontrivial `G`-retraction from the RT
side, independently of the polar-identity route. The two agree.

---

## 6. What this does and does not give

Proved: `D_X = 0 ⟹ RT ⟹ CARRIER` and `u_phi = 0`; and any actual landing tuple
whose restricted map is the identity has `D_X ∈ |kH|`, `k ≥ 5`.

**Not** proved, and not claimed: any contradiction. The CARRIER branch is not
excluded by the target-side receiver ledger — see
`goal_runs_20260810/RECEIVER_LEDGER_X/THEOREM.md` section 0 "Theorem boundary"
("Not proved here. Anything about existence of equivariant maps into `X`") — and
the CLEAN branch survives through the channel classified in
`THEOREM_LEAKAGE_CLASSIFICATION.md`, which `REFUTATION_CONDUCTOR_GYSIN.md`
shows cannot be closed by an abstract receiver-nonexistence argument.

**Problem E headline: OPEN.** Nothing here changes it.
