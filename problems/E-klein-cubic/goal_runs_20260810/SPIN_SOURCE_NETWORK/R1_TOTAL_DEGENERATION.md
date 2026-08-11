# Residual 1: total fibre degeneration at a base point

`TOTAL_DEGENERATION.md` §6, Residual 1: for a dominant `G`-equivariant
`phi : P(V) --> V14` with `V` a faithful spin source, prove
`delta(x) = dim q(p^{-1}(x)) < 3` at a base point — equivalently (Lemma W0)
that **not** every fibre closure of `phi` passes through `x`.

Verdict: **`R1-OPEN`, and the proposed unlock is `R1-INDUCTION-REFUTED`.**
The induced-map recursion — *"if every fibre closure passes through `x`, the
exceptional divisor of the blowup at `x` inherits a dominant `K`-equivariant
`P(T_x) --> V14`"* — is **false**, with an explicit two-line equivariant
counterexample (§2).  What survives is a weaker first-order object which does
exist and is new (§1), and two unconditional by-products that do not depend on
the recursion at all (§4, §5).

Machine: `python3 verify_r1_degeneration.py` → `R1_DEGENERATION_OK`, exact,
stdlib only.  Section references `§A`-`§E` point at that script.

Standing notation as in `THEOREM_SPIN_HODGE_SUPPORT.md`.  `x in P(V)` a base
point, `K = Stab_G(x)`, `Ktilde` its preimage in `Gtilde`, `ell_x subset V`
the `Ktilde`-stable line, `lambda` the character of `Ktilde` on `ell_x`
(`lambda(-I) = -1`, Prop C1), `Lambda ~= M^* subset S^dV^*` the landing tuple
(`d` even, Thm C6), `I = I_phi` the primitive landing ideal.

---

## 1. The first-order object that does exist

Choose a `Ktilde`-stable complement `V = ell_x (+) N` (possible: `Ktilde` is
finite).  Then `T_x = T_x P(V) = N (x) lambda^{-1}` and, for `f in S^dV^*`,
the expansion `f(e+v) = sum_k f^{(k)}(e^{d-k},v^k)` identifies the degree-`k`
part of `f` in the affine chart with an element of
`S^k(N^*) (x) lambda^{-(d-k)} = S^k(T_x^*) (x) lambda^{-d}`.

Let `ord_x` be the order of vanishing at `x`, put

\[
m=\min\{\operatorname{ord}_x f:\ 0\neq f\in\Lambda\}\ \ge 1,
\qquad
\Lambda_k=\{f\in\Lambda:\operatorname{ord}_xf\ge k\},
\qquad
Q=\Lambda/\Lambda_{m+1}\neq0 .
\]

All of these are `K`-submodules of `Res_K M^*` (the filtration is intrinsic).
Write `in_m : Q ↪ S^m(T_x^*) (x) lambda^{-d}` for the injection by
degree-`m` initial forms, and

\[
\psi_x:\ \mathbf P(T_x)\dashrightarrow \mathbf P(Q^*)\subset\mathbf P(M),
\qquad
u\longmapsto[\,in_m(f_0)(u):\dots:in_m(f_9)(u)\,],
\]

defined off the common zero locus of the initial forms, which is a proper
closed subset because `m` is attained.

> **Lemma R1-1 (the initial map lands in the `V14`).**  `psi_x` is a
> `K`-equivariant rational map and
> \[
> \overline{\operatorname{im}\psi_x}\ \subseteq\ V_{14}\cap
> \mathbf P\bigl(\operatorname{Ann}\Lambda_{m+1}\bigr),
> \]
> a nonempty closed `K`-invariant subvariety of `V14`.  Its points are exactly
> the limits of `phi` along **straight lines** through `x`.

*Proof.*  `K`-equivariance is the equivariance of the filtration and of
`in_m`.  Let `F in Sym(Lambda)` be homogeneous of degree `e` in the ideal of
`V14 subset P(M) = P(Lambda^*)`, so `F(f_0,\dots,f_9) = 0` identically.  Order
of vanishing at `x` is a valuation, so each monomial of `F(f)` has order
`>= em`, and the order-`em` homogeneous part of `F(f)` is exactly
`F(in_m(f_0),\dots,in_m(f_9))` (with `in_m(f_i) = 0` when
`ord_x f_i > m`).  A vanishing polynomial has vanishing lowest-degree part, so
`F(in_m(f)) = 0` as a form on `T_x`.  Hence every value of `psi_x` satisfies
every equation of `V14`.  It lies in `P(Ann Lambda_{m+1})` because
`in_m(f) = 0` for `f in Lambda_{m+1}`.  Nonemptiness is the attainment of `m`.
Finally, for a line `ell` through `x` with direction `u`, the restriction
`phi|_ell` has coordinate forms of order `>= m` at `x` with degree-`m` terms
`in_m(f_i)(u) t^m`, so `lim_{t->0} phi|_ell = psi_x(u)`.  `QED`

Two consequences worth stating separately.

> **Corollary R1-1a (a linear-section necessary condition).**  For every base
> point `x`, `V14 cap P(Ann Lambda_{m+1}) != empty`.  In particular, if
> `Lambda_{m+1}` is a `K`-submodule `P` of `Res_K M^*` for which
> `V14 cap P(Ann P) = empty`, then that filtration jump cannot occur.

> **Corollary R1-1b.**  `psi_x` is dominant onto `V14` if and only if `phi` is
> constant along the general line through `x`, in which case `phi` factors
> through the linear projection `P(V) --> P(V/ell_x) = P(T_x)` and the factored
> map is dominant and `K`-equivariant.

*Proof of R1-1b.*  If `phi` is constant on general lines through `x` then it
is constant on the fibres of the projection, hence factors; the factored map
agrees with `psi_x` off the base locus.  Conversely if `psi_x` is dominant
onto the threefold `V14` then, for general `u`, `phi|_{ell_u}` and `psi_x(u)`
agree at `x`; that alone does **not** give constancy, so the "only if" needs
the other direction: if `phi` is not constant on the general line, the general
line maps to a *curve*, and the general fibre closure `F_v` of `phi` is not a
cone with vertex `x`.  That is exactly the second alternative of §2 and is
consistent with `psi_x` non-dominant; the equivalence as stated is therefore
proved only in the direction "constant on lines `=>` dominant", and the
converse is **not** claimed.  `QED` (partial, as marked)

---

## 2. The proposed recursion is FALSE

> **Proposition R1-2 (counterexample).**  Total degeneration at `x` does
> **not** imply that `psi_x` is dominant, nor that the exceptional divisor of
> the blowup at `x` carries any dominant rational map to the target.  An
> explicit equivariant example:
> \[
> \phi:\ \mathbf A^2\dashrightarrow\mathbf P^1,\qquad
> (u,v)\longmapsto[\,u^2:v\,],
> \qquad
> K=C_2 \text{ acting by } u\mapsto-u .
> \]
> Then, at `x = (0,0)`:
>
> 1. `phi` is `K`-equivariant (both `u^2` and `v` are `K`-invariant, `K` acts
>    trivially on the target);
> 2. `Gamma_x = P^1`: **every** fibre closure passes through `x`, i.e. total
>    degeneration holds;
> 3. `m = 1`, `Lambda_2 = <u^2>`, `Q = <v>`, and `psi_x : P^1 --> P^0` is
>    **constant**;
> 4. on the blowup of `x`, the induced map is constant on the exceptional
>    divisor.

*Proof.*  (1) is immediate.  (2): along the arc `(t^a, c t^b)`,
`phi = [t^{2a} : c t^b]`, whose limit is `[1:0]` if `2a<b`, `[0:1]` if
`2a>b`, and `[1:c]` if `2a=b`.  Taking `b=2a` and `c` arbitrary sweeps the
whole `P^1`; the two remaining points are the other two cases.  (3):
`ord_x u^2 = 2 > 1 = ord_x v`, so `m = 1`, `in_1(u^2) = 0`, `in_1(v) = v`,
and the initial map is `[0:v] = [0:1]`.  (4): in the chart `u = u`,
`v = u v'` the pulled-back tuple is `[u^2 : uv'] = [u : v']`, which on `u=0`
is the constant `[0:1]`; in the chart `u = u'v`, `v = v` it is
`[u'^2 v : 1] -> [0:1]`.  `QED` (§A)

The counterexample is not an artefact of the target being a curve: multiplying
by extra coordinates, `(u,v,w_1,\dots) \mapsto [u^2 : v : \dots]`, transports
it to any target dimension, and the `C_2`-action shows that equivariance is no
obstacle.  It is exactly the phenomenon that `TOTAL_DEGENERATION.md`
Remark W0'' predicts: the fibre of the *blowup of the ideal* is computed by
the fibre cone, and arcs with degenerate leading terms contribute limits that
no tangent direction sees.

**What does happen in the example, and why it is not a repair.**  Blowing up a
second time — at the base point `u = v' = 0` of the transformed system — the
chart `u = u`, `v' = uw` gives `[u : uw] = [1 : w]`, which **is** dominant on
the second exceptional divisor.  So the recursion exists at *depth two*.  It is
not a repair, because there is no bound on the depth: the same construction
with `[u^N : v]` needs `N` blowups, and `N` is not bounded by anything in the
package (`d` is unbounded on the spin lane).  Recorded as the exact obstruction
in §6.

> **Theorem R1-3 (what is actually true).**  Suppose `Gamma_x = V14`.  Let
> `pi : W -> P(V)` be any `G`-equivariant principalization of `I_phi` and
> `g : W -> V14` the induced morphism.  Then
>
> 1. `g(pi^{-1}(x)) = V14`;
> 2. some irreducible component `D` of `pi^{-1}(x)` has `g(D) = V14`, hence
>    `3 <= dim D <= n-2`;
> 3. `K` permutes such components; for each, `g|_D` is a dominant
>    `Stab_K(D)`-equivariant rational map;
> 4. on the normalized graph itself, `Y_x = V14` with `q|_{Y_x}` the identity
>    and `Y_x` the fibre `Proj` of the fibre cone
>    `F_x(I) = (+)_k I^k/\mathfrak m_x I^k`, whose degree-one piece is
>    `Res_K M^* (x) lambda^{-d}` — so `Lambda -> I_x/\mathfrak m_xI_x` is a
>    `K`-isomorphism and the analytic spread is `l(I_x) = 4`.

*Proof.*  (1) `g` is proper and `pi` is proper birational, so
`g(pi^{-1}(x)) = q(p^{-1}(x)) = Gamma_x`.  (2) A finite union of irreducible
closed sets covering `V14` has a member of full dimension; `dim D >= 3`
because `g|_D` is surjective, and `dim D <= dim pi^{-1}(x) <= n-2` because
`pi` is birational with smooth target.  (3) is equivariance.  (4)
`Y -> Gamma subset P(V) x V14` is finite, so `Y_x -> Gamma_x = V14` is finite
and birational onto a normal variety, hence an isomorphism; `Y_x` is the
`Proj` of the fibre cone by the universal property of the blowup, its degree-one
piece is the image of `Lambda`, and since `V14` spans `P(M)` (it is
anticanonically embedded, `h^0(-K) = 10`, `SEAL_V14_BETTI.md`) that image is
all of `Lambda`, so `dim F_x(I) = dim Y_x + 1 = 4`.  `QED`

Part (4) is worth reading twice: it says the total-degeneration configuration
determines `Y_x` **completely** — it is the `V14` in its own anticanonical
embedding, with the given `K`-action.  There is nothing left to constrain.
That is the precise sense in which the Hodge-support package is spent here.

---

## 3. Why the `K`-level kills do not fire — audited group by group

Suppose, contrary to §2, that one had the induced dominant `K`-equivariant
`P(T_x) --> V14` (or the `D --> V14` of Theorem R1-3).  Would the existing
machinery kill it?  **No**, and the reason is already recorded: the
fixed-point flank is exhausted (`MULTIPLICITY_ROUTE.md` Cor N4).

The only available tool is going-down for **abelian** groups
(Reichstein–Youssin / Kollár–Szabó: a dominant `A`-equivariant rational map of
smooth projective `A`-varieties with `A` finite abelian carries `A`-fixed
points to `A`-fixed points).  So a kill needs an abelian `A <= K` with
`P(T_x)^A != empty` and `V14^A = empty`.

| `K` | orbit | `T_x` as a `K`-representation | abelian `A <= K` | `V14^A` | kill? |
|---|---:|---|---|---|---|
| `S_3` | 220 | `sign (+) 2.std` (Thm K5) | `C_2`, `C_3` | `E_sigma ⊔ 2` pts; nonempty (`chi = 6` predicted) | **no** |
| `D_10` | 132 | `sign (+) W_1 (+) W_2` (Thm K5) | `C_2`, `C_5` | nonempty; nonempty (`chi = 4` predicted) | **no** |
| `C_11` | 60 | `(+)_{a in QR}\psi^a` | `C_11` | **5 points** (sealed) | **no** |
| `F_55` | 12 | `theta_1`, faithful and irreducible | `C_11`, `C_5` | 5 points; nonempty | **no** |

`V14^{D_10} = empty` and `V14^{F_55} = empty` are exactly the two emptiness
statements one would want, and **both groups are nonabelian**, so neither is
usable by going-down; every abelian subgroup of either has a nonempty fixed
locus on the `V14`.  This is Cor N4 restated at the induced level, and it is
why `R1` cannot be closed by transporting fixed-point machinery down the
recursion even if the recursion existed.

`F_55` deserves one extra line because it has odd order and no involution.
`U|_{F_55} = (\text{linear}) (+) theta_1` (the Weil character has value
`(-1+sqrt(-11))/2 = eta` on `C_11`, i.e. `1 + sum_{a in QR}\psi^a`), so at the
`F_55`-point `ell_x` is the linear summand and `T_x ~= theta_1` — faithful,
five-dimensional, irreducible, and self-tensor-stable under linear characters
(`theta_i (x) chi ~= theta_i`, since the two `theta` are separated by their
`C_11`-restriction).  Also `Res_{F_55}M^* = theta_1 (+) theta_2` (§C).  The
`C_11`/`C_5` eigenstructure therefore matches on both sides — five fixed
points upstairs, five downstairs, one `C_5`-orbit each — and supplies no
mismatch.

---

## 4. The numerical flank — a multidegree budget, and a new unconditional bound

This section does **not** use total degeneration; it is the "does the graph's
multidegree budget tolerate it" question, answered exactly, and the answer is
a statement about `Bs(phi)` that the packet did not have.

Let `n = 6`, `P(V) = P^5`, `pi : W -> P^5` a smooth `G`-equivariant
resolution of `I_phi`, `g : W -> V14` the induced morphism, `L = pi^*O(1)`,
`H` the hyperplane class of `V14 subset P^9` (`H^3 = deg V14 = 14`), and

\[
g^*H = dL-\Xi ,\qquad \Xi\ \text{effective and }pi\text{-exceptional}
\]

(`Xi` has no divisorial part on `P^5` because the tuple is primitive).  Put
`b = dim Bs(phi)`; by Lemma W0' and Thm S3(1), `1 <= b <= 3`.

> **Lemma R1-4a (the vanishing table).**  `L^{5-j}\cdot\Xi^{\,j} = 0` whenever
> `j + b < 5`.

*Proof.*  `L^{5-j}` is the class of `pi^{-1}(P^{\,j})` for a general linear
`P^{\,j} subset P^5`; if `j + b < 5` a general `P^{\,j}` misses `Bs(phi)`, so
`pi` is an isomorphism over it and `Xi` restricts to `0`.  `QED`

> **Theorem R1-4 (multidegree budget).**  Let `delta_F = L^2\cdot g^*[\mathrm{pt}]`
> be the degree in `P^5` of the general fibre cycle of `phi` (a positive
> integer, since `pi` is birational and the general fibre is not exceptional).
> If `b = 1` then
> \[
> \boxed{\,14\,\delta_F=d^{\,3}\,}\qquad\text{and consequently}\qquad
> \boxed{\,b=1\ \Longrightarrow\ 14\mid d\,}.
> \]
> Equivalently: **for every even `d` not divisible by `14` — in particular for
> the minimal live degree `d = 4`, and for `d = 6, 8, 10, 12` — every dominant
> `G`-equivariant `phi : P(U) --> V14` has**
> \[
> \boxed{\ 2\ \le\ \dim\operatorname{Bs}(\phi)\ \le\ 3\ }.
> \]

*Proof.*  `H^4 = 0` on the threefold `V14`, so `(g^*H)^4 = g^*(H^4) = 0` and
`(g^*H)^3 = g^*(14[\mathrm{pt}]) = 14\,g^*[\mathrm{pt}]`.  Intersect the
latter with `L^2` and expand with Lemma R1-4a, which at `b = 1` kills
`L^4\Xi`, `L^3\Xi^2` and `L^2\Xi^3`:
\[
14\,\delta_F=(dL-\Xi)^3L^2=d^3L^5-3d^2L^4\Xi+3dL^3\Xi^2-L^2\Xi^3=d^3 .
\]
`delta_F` is a positive integer, so `14 \mid d^3`; `14 = 2\cdot 7` is
squarefree, so `2 \mid d` and `7 \mid d`, i.e. `14 \mid d`.  The displayed
consequence is the contrapositive together with `dim Bs <= n-3 = 3`
(Thm S3(1)).  `QED`

**Regressions (§B).**  The same computation, run with `deg = 1` in place of
`14`: (i) projection of `P^5` from a line, `d = 1`, `b = 1`, gives
`delta_F = 1` — the fibres are planes, correct; (ii) four general quadrics on
`P^5`, `d = 2`, `b = 1` (base locus a curve of degree 16), gives
`delta_F = 8` — the fibres are the residual `(2,2,2)` surfaces, correct; (iii)
at `n = 5` the identity becomes `deg(X)\,\delta_F = d^2` with two-dimensional
`Xi`-corrections, reproducing the ambient accounting.

**Consistency.**  Theorem R1-4 strengthens Lemma W0' (`dim Bs >= n-5 = 1`) to
`dim Bs >= 2` in the whole low-degree window, and is compatible with every
capacity row of `SUPPORT_CENSUS.md` §3.2 and `O4_EIGENPLANE_CURVES.md` §5,
which bound orbits of base **components** and never bound `b` from below.  It
is also compatible with the 364 mandatory points: they may (and, by
Theorem R1-4, at `d < 14` must) lie on positive-dimensional base components.

**What it does *not* do.**  It does not bear on `delta(x)` and therefore does
not close `R1`.  It is recorded because it is unconditional, new, and it
sharpens the only quantitative statement the packet had about `Bs(phi)`.

---

## 5. A first-order narrowing at the `F_55` points, and one exact question

Corollary R1-1a becomes concrete at the 12 mandatory `F_55`-points, because
`Res_{F_55}M^* = theta_1 (+) theta_2` has exactly four submodules.

> **Proposition R1-5.**  Let `x` be one of the 12 `F_55`-points, `m` as in §1.
> Then `Lambda_{m+1} in \{0,\ theta_1,\ theta_2\}` and:
>
> 1. if `Lambda_{m+1} = 0`, then `Res_{F_55}M^*` embeds into
>    `S^m(theta_1^*) (x) lambda^{-d}`, so **both** `theta_1` and `theta_2`
>    occur in `S^m(theta_1^*)` up to a linear twist;
> 2. if `Lambda_{m+1} = theta_i`, then `Q = theta_{3-i}` is irreducible of
>    dimension 5 and Corollary R1-1a requires
>    `V14 cap P(M_{theta_{3-i}}) != empty`, a section of the threefold `V14`
>    by a **codimension-five** linear space — of expected dimension `-2`;
> 3. `theta_1^* ~= theta_2` (because `-1` is a non-residue mod 11), so at
>    `m = 1` case (1) is impossible and case (2) is forced with
>    `Q = theta_2`.
>
> Exactly one of the two `F_55`-invariant `P^4 subset P^9` meets `V14` in the
> five sealed `C_11`-fixed points; the other contains **no** `C_11`-fixed
> point of `P(M)` at all (§C, §D).

*Proof.*  The submodule list is Schur's lemma for `theta_1 ncong theta_2`.
(1) and (2) are §1 verbatim.  For (3): `theta_i|_{C_{11}}` is the sum of the
`psi^a` over one coset of the squares, and dualising sends `a` to `-a`; since
`11 = 3 mod 4`, `-1` is a non-residue, so duality swaps the two `theta`.  Hence
`S^1(theta_1^*) = theta_2` contains no `theta_1` and case (1) fails at `m=1`.
For the last sentence: `M|_{C_{11}} = (+)_{a \neq 0}\psi^a` (from
`chi_M(11) = -1` and `dim M = 10`), so `P(M)^{C_{11}}` is 10 isolated points,
five in each `P(M_{theta_i})`, and `C_5 = F_55/C_11` permutes them in two
orbits of five, namely the residues and the non-residues.  `V14^{C_{11}}` is
five points (sealed, `FIX_IX_v14.md` §8, re-derived with no slack by
`chi_T(11) = -1`) and is `F_55`-stable, hence is exactly one of those two
orbits.  `QED`

```text
+---------------------------------------------------------------------------+
| NAMED EXACT QUESTION (CAS, sealed model available).                        |
| Let P^4_+ , P^4_-  subset P^9 = P(M) be the two F_55-invariant             |
| eigenspaces (theta_1- and theta_2-isotypic).  One of them contains the     |
| five sealed C_11-fixed points of V14.  Compute                            |
|            V14 cap P^4_+   and   V14 cap P^4_-                            |
| exactly in the sealed model V14 = Gr(2,U) cap P(M).  If the one WITHOUT   |
| the five points is EMPTY, then by Prop R1-5 the filtration jump            |
| Lambda_{m+1} = theta_i pointing at it is impossible, and m is pinned at    |
| every F_55-point of every equivariant spin map.  One Macaulay2 run;        |
| the model and the C_11-eigenbasis are already built by                     |
| verify_v14_s3_d10.py.                                                     |
+---------------------------------------------------------------------------+
```

This is a narrowing, not a kill: even a completely pinned `m` leaves
`delta(x)` untouched, because `psi_x` sees only the straight-line limits.

---

## 6. What would close `R1`, stated exactly

```text
+---------------------------------------------------------------------------+
| R1 RESIDUAL, sharpened.  By Theorem R1-3(4), total degeneration at x is    |
| equivalent to                                                             |
|         l(I_x) = 4   and   Proj F_x(I) = V14  anticanonically,            |
| where l is the analytic spread and F_x(I) the fibre cone.  So R1 asks for  |
| an upper bound on the analytic spread of the landing ideal at a base       |
| point:                                                                    |
|         l(I_x) <= 3   for some x in each carrying orbit.                  |
|                                                                           |
| Equivalent formulations, none of which the package can supply:            |
|   (a) some minimal reduction of I_x is generated by <= 3 elements;        |
|   (b) the special fibre ideal ker(Sym(M^*) -> F_x(I)) contains a form      |
|       cutting P(M) down below dimension 3 on V14;                        |
|   (c) not every fibre closure of phi passes through x  (Lemma W0);        |
|   (d) the induced map exists at BOUNDED depth in an equivariant           |
|       principalization tower AND is non-dominant there (section 2).       |
|                                                                           |
| The depth in (d) is the exact obstruction: the recursion is true at every  |
| FIXED depth as a dichotomy and false as an implication at depth one, and   |
| nothing bounds the depth because d is unbounded on the spin lane.         |
+---------------------------------------------------------------------------+
```

---

## 7. Adversarial tests

### R1-T1.  The mandatory `D_12` test (Cor IX.6) — PASSED, and informative

Cor IX.6 gives a **realised** dominant `D_12`-equivariant map from a spin
source.  The mission's own consistency requirement is that the induced-map
recursion must **not** kill anything at `D_12`-visible points — otherwise the
recursion would be wrong.  Two verdicts:

* §2 refutes the recursion outright, so it kills nothing anywhere; **PASS**
  trivially, and the sign is the correct one — a recursion that had worked
  would have had to be checked against the realised map at every
  `D_12`-visible base point.
* §3's audit is the sharp form: at every stabiliser occurring on the spin
  lane, including all abelian subgroups of `D_12` (`C_2`, `C_3`, `C_6`,
  `V_4` — the last not spin-admissible as a pointwise kernel), the target
  fixed locus is nonempty, so going-down never fires.  A kill at `D_12` level
  would have contradicted Cor IX.6 directly.
* Theorem R1-4 is a statement about `Bs(phi)` for a `G`-equivariant map and
  says nothing about a `D_12`-equivariant one (the parity theorem C6 and the
  identification `Lambda ~= M^*` both use the perfectness of `Gtilde`, which
  fails for `D_12tilde`).  **No interaction.**

### R1-T2.  Does Theorem R1-4 contradict Lemma W0' or the capacity tables? — NO

W0' gives `dim Bs >= n-5 = 1`; R1-4 gives `>= 2` for `14 \nmid d`.  The second
implies the first in that range and neither is claimed outside it.  The
capacity tables bound orbits of base **components** from above and are silent
about `dim Bs`; at `d = 4` the 364 mandatory points now provably lie on
positive-dimensional base components, which is consistent with
`SUPPORT_CENSUS.md` §3.2's own reading at `d = 2` (there the same conclusion
was reached by counting capacity).

### R1-T3.  Is the counterexample of §2 really total degeneration? — YES

`Gamma_0` is computed as a set, not asserted: the three cases `2a<b`, `2a=b`,
`2a>b` exhaust the arcs and the middle case sweeps `P^1` with the free
parameter `c` (§A enumerates a grid of `(a,b,c)` and checks that the limits
cover every point of `P^1(Q)` in the grid, and that the initial map is
constant on the same grid).

### R1-T4.  Does Lemma R1-1 overreach into "the fibre is the image of the tangent directions"? — NO

Lemma R1-1 claims only `im psi_x subset Gamma_x`, never equality; §2 is the
proof that the inclusion is strict in general.  `TOTAL_DEGENERATION.md`
Remark W0'' is thereby upgraded from an assertion to a theorem with a witness.

### R1-T5.  No withdrawn machinery — PASSED

No Chow projector, no canonical splitting, no restricted-graph transfer, no
fixed-point statement is used to prove anything here; §3 *cites* the
fixed-point exhaustion only to explain why a hypothetical kill would fail.
Theorem R1-4 uses only the projection formula, `H^4 = 0` on a threefold, and
purity of the exceptional locus.

---

## 8. Exit

```text
R1-OPEN
R1-INDUCTION-REFUTED            (Prop R1-2: explicit equivariant counterexample)
R1-INITIAL-MAP-LANDS-IN-TARGET  (Lemma R1-1, new)
R1-TOTAL-DEGENERATION-RIGIDITY  (Thm R1-3(4): Y_x is V14 anticanonically, l(I_x) = 4)
BASE-LOCUS-DIMENSION-BOUND-2    (Thm R1-4: 14 | d if dim Bs = 1; dim Bs >= 2 for even d < 14)
R1-F55-FILTRATION-NARROWED      (Prop R1-5 + the named CAS question)
R1_DEGENERATION_OK              (verifier marker)
```

`R1-CLOSED-<K>` is **not** claimed for any `K`, and the induced-map route to
it is closed off by Proposition R1-2.  What `R1` would need is an upper bound
on the analytic spread of the landing ideal at a base point (§6) — a
commutative-algebra statement about `I_phi`, not a Hodge-theoretic one.
