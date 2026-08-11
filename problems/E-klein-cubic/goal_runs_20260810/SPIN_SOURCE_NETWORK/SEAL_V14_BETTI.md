# Sealing `b_3(V14) = 10`, `h^{2,1}(V14) = 5`, `rho(V14) = 1`

`THEOREM_SPIN_HODGE_SUPPORT.md` §0 flags three inputs of Theorem S0 as
literature values, and `SUPPORT_CENSUS.md` §7.2 names sealing them as the way
to remove the last cited input from the identification of
`T = H^3(V14,Q)(1)`.  This file does it: an exact citation **plus** an
independent in-repo derivation, to the house standard (exact arithmetic, no
sampling, replayable).

Machine: `python3 verify_v14_betti.py` → `V14_BETTI_OK`, 41 assertions,
exact integer arithmetic in the Chow ring of `Gr(2,6)`, under a second.

## 0. The model, and why it is the classical `X_14`

The sealed FIX-IX model, cited verbatim from `V14_S3_D10_MEASUREMENT.md` §1
(exit `FIX-IX-SEAL-PASS`, `goal_runs_after_c53d89a/FIX_IX_SEAL`):

\[
V_{14}\;=\;\mathrm{Gr}(2,U)\cap\mathbf P(M)\;\subset\;\mathbf P(\Lambda^2U)=\mathbf P^{14},
\qquad \dim U=6,
\]

with `M` the 10-dimensional `10'`-summand of `Lambda^2 U`, so
`P(M) = P^9` and `V14` is a **codimension-5 linear section of the 8-fold
`Gr(2,6)` in its Plücker embedding** — equivalently the zero locus of a
section of the rank-5 bundle `E = O_{Gr}(1)^{(+)5}`.  The seal's own
Macaulay2 regression, reproduced in all four modes by
`verify_v14_s3_d10.py`, gives `REG V14 dim 4 degree 14` (affine cone), i.e.
`dim V14 = 3`, `deg V14 = 14`, and char-0 smoothness is DISCHARGED there.

Two facts are therefore **inputs** here, both sealed: `V14` is smooth, and
the section is regular (`codim = 5 = rank E`).

The Schubert computation below independently reproduces, from the model
alone: `deg V14 = 14`, `-K_{V14} = O(1)|_{V14}` (index 1),
`(-K)^3 = 14` hence genus `g = 8`, `chi(O_{V14}) = 1`, and
`h^0(-K_{V14}) = 10`.  The last of these says the sealed embedding
`V14 subset P(M) = P^9` **is** the anticanonical embedding, so the model is
exactly the classical prime Fano threefold `X_14` of genus 8 — which is what
licenses the literature citation in the first place.

## 1. The citation

| value | source |
|---|---|
| `V14 = X_14 = Gr(2,6) cap P^9` is the prime Fano threefold of index 1, `rho = 1`, genus 8, degree 14; `h^{1,2} = 5` | V. A. Iskovskikh, *Fano threefolds I*, Izv. Akad. Nauk SSSR Ser. Mat. **41** (1977) 516–562 (Engl. transl. Math. USSR-Izv. 11 (1977) 485–527), and *Fano threefolds II*, Izv. **42** (1978) 506–549 — the classification tables of index-1, `rho = 1` Fano threefolds by genus |
| the same table in modern form, with the `h^{1,2}` column | V. A. Iskovskikh, Yu. G. Prokhorov, *Fano varieties*, Algebraic Geometry V, Encyclopaedia of Math. Sci. **47**, Springer 1999, §12.2 (the `rho = 1`, index-1 list `X_{2g-2}`, `2 <= g <= 12`); the genus-8 row is `X_14`, `h^{1,2} = 5` |
| `J(X_14) ~ J(Y)` for the associated cubic threefold `Y`, so `h^{1,2}(X_14) = h^{1,2}(Y) = 5` | Fano; Iskovskikh; made precise in A. Iliev, D. Markushevich, *The Abel–Jacobi map for a cubic threefold and periods of Fano threefolds of degree 14*, Doc. Math. **5** (2000) 23–47 |

The third row is a corroboration worth recording rather than a source: the
classical `X_14`–cubic-threefold correspondence says the intermediate
Jacobian of a `V14` is the intermediate Jacobian of a cubic threefold, which
is a 5-dimensional ppav — and Theorem S0 concludes `J(V14) ~ E_{-11}^5`,
i.e. the associated cubic threefold of **our** `V14` has the intermediate
Jacobian of the Klein cubic.  That is exactly the shape the twin story
predicts, and it is *not* used anywhere below.  (It is also not in tension
with [BCDP23] Thm 4.3: that theorem rules out a `G`-equivariant birational
map; the Fano–Iskovskikh birationality is non-equivariant.)

**The citation is not load-bearing.**  §§2–4 derive all three values in-repo.

## 2. `rho(V14) = 1` and `b_1 = 0`, `b_2 = 1` — the Lefschetz step

> **Theorem (Sommese's Lefschetz theorem for ample vector bundles).**  Let
> `X` be a smooth complex projective variety of dimension `n`, `E` an **ample**
> vector bundle of rank `e` on `X`, and `s in H^0(X,E)` a section whose zero
> locus `Z = Z(s)` has codimension `e`.  Then `pi_i(X, Z) = 0` for
> `i <= n - e`; consequently `H^i(X,Z) -> H^i(Z,Z)` is an isomorphism for
> `i < n-e` and injective for `i = n-e`.
>
> A. J. Sommese, *Submanifolds of abelian varieties*, Math. Ann. **233**
> (1978) 229–256, Prop. 1.16; textbook form: R. Lazarsfeld, *Positivity in
> Algebraic Geometry II*, Springer 2004, §7.1 (Thm 7.1.1 and its corollaries).

**Hypotheses, checked one by one for our section.**

1. `X = Gr(2,6)` is smooth projective of dimension `n = 8`.  ✔
2. `E = O_{Gr}(1)^{(+)5}` with `O_{Gr}(1)` the Plücker line bundle, which is
   very ample; a finite direct sum of ample line bundles is ample.  So `E` is
   ample of rank `e = 5`.  ✔
3. `s = (l_1, ..., l_5)`, the five linear forms on `P^{14}` cutting out
   `P(M) = P^9`; `Z(s) = Gr(2,6) cap P(M) = V14`.  ✔
4. `codim Z(s) = 5 = e`: sealed, `dim V14 = 3 = 8 - 5`.  ✔  (This is the one
   place a *measured* input enters, and it is sealed twice — by the FIX-IX
   Groebner data and by `verify_v14_s3_d10.py`'s `REG V14 dim 4 degree 14` in
   all four modes.)

So `H^i(Gr(2,6),Z) -> H^i(V14,Z)` is an isomorphism for `i < 3`.  The
cohomology of `Gr(2,6)` is free on the 15 Schubert classes, one per partition
in the `2x4` box, so `b_0 = 1`, `b_1 = 0`, `b_2 = 1` on `Gr` and hence on
`V14`.  `V14` is smooth projective of dimension 3, so Poincaré duality gives
`b_6 = 1`, `b_5 = 0`, `b_4 = 1`.

`V14` is Fano (§3: `-K = O(1)|` is ample), so Kodaira vanishing
`H^i(X, K_X (x) L) = 0` (`i > 0`, `L` ample) applied to `L = -K_X` gives
`H^i(O_{V14}) = 0` for `i = 1,2,3`.  Hence the exponential sequence makes
`c_1 : Pic(V14) -> H^2(V14,Z)` an isomorphism, and `NS = Pic` with

\[
\boxed{\rho(V_{14}) = b_2(V_{14}) = 1 .}
\]

## 3. `chi_top(V14) = -6` — exact Schubert calculus

The Chow ring of `Gr(2,6)` is realised as the symmetric polynomials in the
two Chern roots `x, y` of `S^dual`, with Schubert basis `s_lambda`
(`lambda` in the `2x4` box), classes outside the box set to zero — this is
exactly the quotient by `(h_5, h_6)` — and degree map "coefficient of
`s_{(4,4)}`".  With `c_j(Q) = h_j(x,y)`,

\[
c(T_{Gr})=c(S^\vee\otimes Q)=\prod_{i=1,2}\ \sum_{j=0}^{4}(1+a_i)^{4-j}c_j(Q),
\qquad a_1=x,\ a_2=y,
\]

and `[V14] = c_5(E) = sigma_1^5`, `c(T_{V14}) = c(T_{Gr})/(1+sigma_1)^5`.
All of this is exact integer arithmetic; the script asserts it, together with
the regressions

| quantity | computed | check |
|---|---|---|
| `int_{Gr} sigma_1^8` | 14 | `deg Gr(2,6) = 8!/(4!5!)` |
| `int_{Gr} c_8(T_{Gr})` | 15 | `chi_top(Gr(2,6)) = binom(6,2)` |
| `c_1(T_{Gr})` | `6 sigma_1` | index of `Gr(2,n)` is `n` |
| `c_1(T_{V14})` | `sigma_1` | Fano **index 1** |
| `deg V14 = int sigma_1^3` | 14 | matches the sealed M2 degree |
| `(-K)^3` | 14 | genus `g = (-K)^3/2 + 1 = 8` |
| `int c_1c_2` | 24 | `chi(O_{V14}) = c_1c_2/24 = 1` |
| `chi(O(-K))` by HRR | 10 | `= dim M`: the sealed `P(M) = P^9` **is** the anticanonical space |

and the target value

\[
\boxed{\chi_{\mathrm{top}}(V_{14})=\int_{V_{14}}c_3(T_{V_{14}})=-6 .}
\]

## 4. `b_3 = 10`, `h^{3,0} = 0`, `h^{2,1} = 5`

With `b = (1,0,1,b_3,1,0,1)`,

\[
\chi_{\mathrm{top}}=2b_0-2b_1+2b_2-b_3=4-b_3
\quad\Longrightarrow\quad
\boxed{b_3(V_{14})=4-(-6)=10 .}
\]

`h^{3,0} = h^0(K_{V14}) = 0` because `K = -H` with `H` ample has no nonzero
sections (equivalently `h^{0,3} = h^3(O) = 0` by the Kodaira vanishing used in
§2).  Since `b_3 = 2h^{2,1} + 2h^{3,0}`,

\[
\boxed{h^{2,1}(V_{14})=h^{1,2}(V_{14})=5 .}
\]

Every value agrees with the citation of §1.

## 5. What this changes downstream

* **Theorem S0** (`THEOREM_SPIN_HODGE_SUPPORT.md` §1) no longer leans on any
  unsealed input.  Its proof used exactly `b = (1,0,1,10,1,0,1)`,
  `h^{3,0} = 0`, `h^{2,1} = 5` and `chi_top(V14) = -6`; all four are now
  in-repo.  Its remaining inputs — `chi_W(sigma) = 1`, the sealed
  `V14^sigma`, the Auto-CM Lemma, the relatively-ample splitting — were
  already sealed or proved.
* **`MULTIPLICITY_ROUTE.md` §5** used `chi(V14) = -6` and the literature
  `b_3` for its Lefschetz congruences (`V14^{C_5}`, `V14^{C_11}` nonempty).
  That flag is now discharged as well; §5's argument stands unchanged, and
  Theorem S0(3) had already re-derived `V14^{C_11} != empty` with no
  congruence slack.
* **`SUPPORT_CENSUS.md` §7.2** (named next task: seal `b_3`) is **closed**.
* Nothing else moves.  `rho = 1` was never load-bearing for the census; it is
  sealed here because Theorem S0's proof quotes "prime Fano threefold of
  genus 8, index 1, Picard rank 1" as a package.

## 6. Honest limits

1. **Smoothness and the expected dimension of `V14` are inputs, not outputs.**
   Sommese's theorem needs `codim Z(s) = rank E`, and the Hodge-theoretic
   steps (Poincaré duality, Kodaira) need `V14` smooth.  Both come from
   `FIX-IX-SEAL-PASS` / `V14-S3-D10-MEASUREMENT-OK`.  If the sealed model were
   singular, everything in §§2–4 would have to be redone; it is not.
2. The Schubert layer computes `chi_top` of the *abstract smooth codimension-5
   linear section*; it does not know about the `G`-action, and does not need
   to.  The `G`-equivariant refinement is Theorem S0's job.
3. The citation's table numbering in [Iskovskikh–Prokhorov 1999] is quoted at
   section level (§12.2, the `rho = 1` index-1 list), not by table number, to
   avoid a false precision.  The values are independently derived above, so
   nothing rests on the pointer.
4. The `X_14`–cubic-threefold correspondence (§1, third row) is recorded as
   corroboration only.  It is **not** used, and in particular no claim is made
   that our `V14` is birational to the Klein cubic — equivariantly it is not
   ([BCDP23] Thm 4.3).

## 7. Exit

```text
V14-BETTI-SEALED
V14_BETTI_OK                (verifier marker, 41 assertions)
```

`b_3(V14) = 10`, `h^{2,1}(V14) = 5`, `rho(V14) = 1`, `chi_top(V14) = -6`:
cited to Iskovskikh / Iskovskikh–Prokhorov **and** derived in-repo from the
sealed model by Sommese's Lefschetz theorem plus exact Schubert calculus.
Headline unchanged: **OPEN**.
