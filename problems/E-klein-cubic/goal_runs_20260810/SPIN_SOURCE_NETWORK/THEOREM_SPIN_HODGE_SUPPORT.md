# The ambient Hodge-support obstruction, ported to spin sources on the `V14`

The fixed-point flank of the spin lane is exhausted (`MULTIPLICITY_ROUTE.md`
Cor N4, exits `SPIN-LINKING-LEMMA-FALSE`, `D10-FIXED-POINT-ROUTE-DEAD`): any
further attack needs an invariant that is **not** of fixed-point type.  This
file ports the one such invariant the repository already owns — the ambient
normalized-graph Hodge-support theorem of
`goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/` — from the linear source
`P^4` to an arbitrary **spin** source `P(V)`, and onto the `V14` twin.

Nothing in the ambient packet's boundary is loosened: no canonical splitting,
no Chow projectors, point supports and nonconstant local systems allowed.
Three things genuinely change and are re-derived, not copied: the identity of
the target Hodge structure (§1), the fibre dimension of `q` (§3), and the
whole perverse-degree ledger, which depends on `dim P(V)` (§7).

Everything numeric is machine-checked by `verify_spin_hodge_census.py`
(marker `SPIN_HODGE_CENSUS_OK`, 206 assertions, exact integer arithmetic,
about 30 s).

## 0. Standing data, and which inputs are sealed

`Gtilde = SL(2,F_11)` (order 1320, unique involution `-I`),
`G = PSL(2,F_11)` (order 660).  A **spin source** is `P(V)` for `V` a
faithful `Gtilde`-representation with `rho(-I) = -id_V`; this is exactly the
class of projectively-linear `G`-sources that is not `P(linear)`
(`FIX_IX_v14.md` §6).  Write `n = dim V`.

> **Fact 0.1 (the spin block).**  The faithful spin irreducibles of
> `SL(2,F_11)` have dimensions `6, 6, 10, 10, 10, 12, 12` (two Weil
> representations `U`, `U'` of dimension `(q+1)/2 = 6`; three discrete series
> of dimension `q-1 = 10`, those attached to a character of the nonsplit
> torus `C_12` of order `4` or `12`; two principal series of dimension
> `q+1 = 12`).  Their squares sum to `1320 - 660 = 660`.  Hence
> **`n >= 6` for every faithful spin source.**

(`MULTIPLICITY_ROUTE.md` §7 lists this block as `6, 6, 10, 10, 12`; the
correct list has three spin `10`s, and the correction is recorded here.  The
statements in that file are unaffected — they quantify over `U^{(+)m}`.)

Sealed / accepted inputs, cited and not recomputed:

| input | where | status |
|---|---|---|
| `chi_W = (5, A, Abar, 1, -1, 1, 0, 0)` on `(1a,11a,11b,2a,3a,6a,5a,5b)`, `A = (-1+sqrt(-11))/2`; `H^{2,1}(X) = W^*` for the Klein cubic `X` | `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md` §§213-278, `character_screen.json`, exit `WP_H1_HODGE_VERIFY_OK` | SEALED |
| `b(X) = (1,0,1,10,1,0,1)`, `h^{2,1}(X) = h^{1,2}(X) = 5` | `goals_2026-08-01/D_EQUIVARIANT_MOTIVE/TARGET_INVARIANTS.md` §§14-42, exit `D-INVARIANT-REPRODUCIBLE` | SEALED |
| `V14^sigma` = smooth genus-1 sextic `E_sigma` `| |` two points; `V14^{D_12} = empty`; `C_G(sigma) = D_12` | `goal_runs_after_c53d89a/FIX_IX_SEAL`, exit `FIX-IX-SEAL-PASS` | SEALED |
| `V14^{S_3}` = 2 points, `V14^{D_10} = empty`, `V14^{A_4}` = 1 point, `V14^{A_5} = empty` (hence `V14^G = empty`) | `V14_S3_D10_MEASUREMENT.md`, exit `V14-S3-D10-MEASUREMENT-OK` | MEASURED |
| `j(E_sigma) = 8192/11`, not an algebraic integer, so `End(E_sigma) = Z` and `Hom(E_sigma, E_{-11}) = 0`; `j(E_{-11}) = -32768` | `goal_runs_after_576ad77/FIX_VI_PRYM_SEAL/REPORT.md` §31; `PHI_SEXTIC_ISOGENY/REPORT.md`; `goals_2026-08-01/J_FIXED_CENTRE_PRYM/HODGE_ISOGENY.md` §§80-92 | SEALED |
| Auto-CM Lemma: any polarizable weight-1 rational `G`-Hodge structure isomorphic to `W_Q` as a `G`-module is isogenous to `E_{-11}^5` | `theory/FIX_VII_carrier.md` §1 Lemma 1 | PROVED (hand, DRAFT-class) |
| relatively-ample splitting: `f^*` is a split `G`-equivariant injection on `H^3` | `REPAIR.md` §8; `certificates/hodge_centers/HODGE_CENTER_NECESSITY.md` §§37-123 | PROVED |
| the 110 eigenplanes, 1980 meeting pairs, 352 incidence points with `Stab = S_3` (220) or `D_10` (132), and Theorems K1-K4 | `KLEIN_SPIN_COMPLEX.md`, exit `SPIN_SOURCE_NETWORK_OK` | PROVED/COMPUTED |
| the whole ambient support package (Theorems A, B, Cor C, the boundaries) | `AMBIENT_HODGE_REES_BRIDGE/THEOREM.md`, `AMBIENT_SUPPORT.md`, exit `AMBIENT-HODGE-SUPPORT-PROVED` | PROVED |

**Not sealed, and therefore proved here or flagged:**
`H^3(V14,Q)` as a `G`-module is *not* computed anywhere in-repo; only
`b_3(V14) = 10` is used, and it is flagged in `MULTIPLICITY_ROUTE.md` §5 as a
literature value.  §1 below supplies the missing identification, from sealed
data plus one Lefschetz count.

## 1. The target: what `T` actually is on the `V14` twin

Put

\[
T=H^3(V_{14},\mathbf Q)(1).
\]

The ambient packet's `V = H^3(X,Q)(1)` for the Klein cubic is the sealed
`W_Q`, the ten-dimensional `Q`-irreducible with `W_Q (x) C = W (+) Wbar`.
The mission's caution is the right one: the Tschinkel--Zhang equivalence is a
*twisted-stable* equivalence
`V14 x P^2 x P(V) ~_G X x P^2 x P(V)` (`FIX_IX_v14.md` §2), **not** an
equivariant birational map — [BCDP23] Thm 4.3 proves both threefolds
birationally rigid, so no plain `G`-birational map exists.  Stable
equivalence of threefolds does not transport `H^3` on the nose either: weak
factorization changes `H^3` by `H^1` of blowup centres.  So the transport is
**not** available, and the identification has to be derived.  It is:

> **Theorem S0 (identification of `T`; the forcing argument).**
> `T` is isomorphic to `W_Q` as a `G`-Hodge structure.  Consequently
>
> 1. `T` is **irreducible over `Q`** as a `G`-module, with
>    `End_G(T) = Q(sqrt(-11))`;
> 2. `T` is `E_{-11}`-isotypic as a Hodge structure: `T ~ H^1(E_{-11})^{(+)5}`
>    and the intermediate Jacobian satisfies `J(V14) ~ E_{-11}^5`;
> 3. `chi_T = (10, 2, -2, 0, 2, -1)` on elements of order `(1,2,3,5,6,11)`.
>    In particular `chi_T` is a function of the element order alone.

*Proof.*  Inputs from the literature, flagged as such and consistent with
everything measured in-repo: `V14` is a prime Fano threefold of genus 8,
index 1, Picard rank 1, so `b = (1,0,1,10,1,0,1)`, `h^{3,0} = 0` and
`h^{2,1} = h^{1,2} = 5` (Iskovskikh).  Then `chi_top(V14) = 4 - 10 = -6`,
which is the value already used in `MULTIPLICITY_ROUTE.md` §5.

`G` acts on `V14` by automorphisms (the sealed model), hence on `H^3` by
Hodge-structure automorphisms; `G` is simple and `chi_{H^3}(sigma) != 10`
below, so the action is faithful.  `A := H^{2,1}(V14)` is a `G`-stable
complex subspace of dimension 5 and `H^3 (x) C = A (+) Abar`.

*Step 1 — the two absolutely irreducible tens are excluded outright.*
`PSL(2,11)` has exactly three ten-dimensional irreducible **rational**
representations: the two absolutely irreducible discrete series `10` and
`10'` (characters `(10,-2,1,0,1,-1)` and `(10,2,1,0,-1,-1)` on orders
`(1,2,3,5,6,11)`) and `W_Q = 5 + 5bar`.  If `H^3(V14,Q)` were `10` or `10'`
then `H^3 (x) C` would be irreducible, contradicting the existence of the
`G`-stable 5-dimensional subspace `A`.

*Step 2 — the remaining candidates for `A`.*  The complex irreducibles of
`G` of dimension at most 5 are the trivial one and `W, Wbar`.  A
5-dimensional complex `G`-module is therefore `1^{(+)5}`, `W`, or `Wbar`;
no mixture fits in dimension 5.

*Step 3 — the involution decides.*  Topological Lefschetz for `sigma`:
\[
\chi_{\mathrm{top}}(V_{14}^{\sigma})
=\sum_i(-1)^i\operatorname{tr}(\sigma\mid H^i)
=4-\operatorname{tr}(\sigma\mid H^3),
\qquad
\operatorname{tr}(\sigma\mid H^3)=2\,\mathrm{Re}\,\chi_A(\sigma).
\]
The seal gives `V14^sigma = E_sigma | | {2 points}` with `E_sigma` of genus
one, so `chi_top(V14^sigma) = 0 + 2 = 2`, i.e. `tr(sigma | H^3) = 2`.
For `A = 1^{(+)5}` this reads `4 - 10 = -6 != 2`.  For `A = W` or `Wbar`,
`chi_W(sigma) = 1` (sealed), giving `4 - 2 = 2`.  Only `W` and `Wbar`
survive, and both give `H^3(V14,Q) = W_Q`.

*Step 4 — the consequences.*  `W ncong Wbar` and neither is `Q`-rational, so
the only `G`-stable `Q`-subspaces of `W_Q` are `0` and `W_Q`: `T` is
`Q`-irreducible.  `End_{G,C}(W (+) Wbar) = C x C`, whose `Q`-rational part is
the field `Q(sqrt(-11))` (Schur index 1, as recorded in
`RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md` §4.1 on the Klein
side).  `T` is a polarizable weight-1 rational `G`-Hodge structure isomorphic
to `W_Q`, which is exactly the hypothesis of the Auto-CM Lemma
(`theory/FIX_VII_carrier.md` §1); so `T ~ H^1(E_{-11}^5)` and every
sub- and quotient Hodge structure of `T` is `E_{-11}`-isotypic.  Finally
`chi_T = chi_W + chi_{Wbar}` is the stated rational character.  `QED`

### 1.1 Consistency, and five falsifiable predictions

`chi_T` is a function of the element order, so Lefschetz gives, for `g` of
order `o`,
\[
\chi_{\mathrm{top}}(V_{14}^{g})=4-\chi_T(o).
\]

| `o` | 2 | 3 | 5 | 6 | 11 |
|---|---|---|---|---|---|
| predicted `chi_top(V14^g)` | **2** | 6 | 4 | 2 | **5** |

The two boldface entries are already known and **agree**: `o = 2` is the
seal (`E_sigma | | 2` points, `chi = 2`), and `o = 11` is
`FIX_IX_v14.md` §8's `V14^{C_11}` = 5 points.  The `10'` alternative would
have predicted `chi = 5` at `o = 6` and `chi = 3` at `o = 3`; the entries at
`o = 3, 5, 6` are **not** measured in-repo and each is decidable by one run
of `verify_v14_s3_d10.py`'s machinery.  They are recorded as falsifiable
predictions in `ADVERSARIAL_TESTS.md` §S4.

`chi_T(11) = -1` also re-derives, with no congruence and no slack, the
`V14^{C_11}` nonemptiness that `MULTIPLICITY_ROUTE.md` §5 had to obtain from
a Lefschetz *congruence* using the flagged literature `b_3`.

## 2. The normalized graph of a spin landing map

Let `phi : P(V) --> V14` be a hypothetical dominant `G`-equivariant rational
map, `V` any faithful spin source, `n = dim V >= 6`.  Fix the sealed model
`V14 = Gr(2,U) cap P(M) subset P^9`, `M` the `10'`-summand of `Lambda^2 U`
(`V14_S3_D10_MEASUREMENT.md` §1), and let `I_phi` be the primitive landing
ideal of `phi` (the ideal generated by the coordinate tuple; primitive =
no common factor).  Put

\[
Y=\operatorname{Proj}_{\mathbf P(V)}\overline{\mathcal R(I_\phi)},
\qquad
p:Y\to\mathbf P(V),
\qquad
q:Y\to V_{14},
\]

the normalized graph, `Y` normal and projective, both morphisms intrinsic to
`phi`, and every smooth `G`-equivariant principalization of `I_phi` factoring
through `Y` (`AMBIENT_SUPPORT.md` §1, verbatim: the argument uses only
normality and the universal property of the blowup, and is insensitive to the
source).  Let `r : Z -> Y` be any smooth `G`-equivariant resolution and
`g = q r`.  `IC_Y^H` is perversely normalized: the pure Hodge module of
weight `dim Y = n-1` realizing `j_{!*}Q_{Y_reg}[n-1]`.

Two dimension facts, both different from the ambient packet and both used
below:

* `dim P(V) = n-1 >= 5`, and the **generic fibre of `q` has dimension
  `e = n-4 >= 2`**.  In the ambient packet `e = 1`.
* `I_phi` primitive `=> codim Bs(phi) >= 2 =>` every proper strict support
  has `dim S <= n-3`.  In the ambient packet this read `dim S <= 2`; on
  `P(U) = P^5` it reads `dim S <= 3`.

## 3. Theorem S1 (a): `q^*` is injective, two-dimensional fibres and all

> **Theorem S1.**  `q^* : H^3(V14,Q) -> H^3(Y,Q)` is injective, and so is
> `g^* : H^3(V14,Q) -> H^3(Z,Q)`.  This holds for every `n >= 4`; the
> dimension `e = n-4` of the generic fibre of `q` is irrelevant.

*Proof.*  This is the accepted relatively-ample splitting (`REPAIR.md` §8),
run at general relative dimension.  Let `eta in H^2(Z,Q)` be a `G`-invariant
ample class (average an ample class over the finite group `G`; ampleness is
preserved).  `Z` is smooth projective and `g` is surjective (`phi` dominant),
so `g_*` is defined by Poincaré duality and the projection formula gives, for
`alpha in H^3(V14,Q)`,
\[
g_*\!\left(\eta^{\,e}\cup g^*\alpha\right)
=g_*(\eta^{\,e})\cup\alpha
=N\cdot\alpha,
\qquad
N=\deg\!\left(\eta^{\,e}\big|_{F}\right)>0,
\]
where `F` is a generic fibre of `g`, of dimension `e`, and `N > 0` because
`eta` is ample and `F` is a projective variety of dimension exactly `e`.
Hence `s(beta) = N^{-1} g_*(eta^e cup beta)` is a `G`-equivariant retraction
of `g^*`: `g^*` is a **split** injection.  Since `g^* = r^* q^*`, `q^*` is
injective as well.  `QED`

**Explicitly, as the brief asks.**  The only place the fibre dimension enters
is the exponent `e` on `eta`; the identity `g_*(eta^e) = N[V14]` holds in
`H^0(V14)` for every `e >= 0`, and `N` is the degree of the polarization
restricted to the generic fibre, positive whenever `eta` is ample and the
fibre is `e`-dimensional.  Nothing asks `g` to be generically finite,
equidimensional, or flat.  So the passage from `e = 1` (the linear ambient
source `P^4 --> X`) to `e = n-4 >= 2` (every spin source) costs nothing.
This is worth saying loudly because the *restricted* graph statement
(`THEOREM.md` Thm D) does use generic finiteness and a trace identity — that
argument does **not** port, and is not used here.

## 4. Theorem S2 (b): the canonical pure lift

> **Theorem S2.**  There is a canonical `G`-equivariant injection of rational
> Hodge structures
> \[
> \alpha_\phi:\;H^3(V_{14},\mathbf Q)\hookrightarrow IH^3(Y,\mathbf Q),
> \]
> namely
> `H^3(V14) --q^*--> H^3(Y) --> Gr^W_3 H^3(Y) ↪ IH^3(Y)`, and for every
> resolution `r : Z -> Y` one has `g^* H^3(V14) = r^* q^* H^3(V14)`.

*Proof.*  Verbatim from `AMBIENT_SUPPORT.md` §2 / `THEOREM.md` Theorem A;
the argument uses only that the source of `q^*` is pure of weight three
(`V14` smooth projective) and that `Y` is proper.  `q^*` is injective by
Theorem S1; strictness of morphisms of mixed Hodge structures identifies its
image with a pure weight-three sub-Hodge structure of `Gr^W_3 H^3(Y)`;
Hanamura--Saito's middle-weight theorem gives the canonical injection
`Gr^W_3 H^3(Y) ↪ IH^3(Y)` (`Y` proper, so compactly supported and ordinary
cohomology agree).  Every map is functorial for automorphisms of the graph,
hence `G`-equivariant.  The last identity is functoriality of pullback.
`QED`

As in the ambient packet, `alpha_phi(T)` is the pure intersection-cohomology
shadow of the **actual** canonical subspace `g^*H^3(V14)`, not of an abstract
occurrence of an isomorphic Hodge structure in some blowup summand; Test 1 of
`AMBIENT_HODGE_REES_BRIDGE/ADVERSARIAL_TESTS.md` transfers unchanged.

## 5. Theorem S3 (c): the forcing, and the (AHS-spin) condition

Put `P_j = {}^pH^j(Rp_* IC_Y^H)` and index the perverse Leray filtration over
the **source** by

\[
\operatorname{Gr}^P_j IH^3(Y)\;\simeq\;H^{\,4-n-j}\!\left(\mathbf P(V),\mathcal P_j\right).
\tag{5.1}
\]

(`IH^3(Y) = H^{3-\dim Y}(Y, IC_Y) = H^{4-n}(P(V), Rp_*IC_Y)`.  At `n = 5`
this is the ambient packet's `H^{-1-j}(P^4, P_j)`.)

> **Theorem S3 (the spin ambient Hodge-support theorem).**  Let
> `phi : P(V) --> V14` be dominant `G`-equivariant, `V` any faithful spin
> source.  Then:
>
> 1. **(no full support)** `p` is an isomorphism over `P(V) \ Bs(phi)`, so the
>    only full-support constituent among all `P_j` is
>    `Q_{P(V)}^H[n-1] subset P_0`, with multiplicity one, and its contribution
>    to degree three is
>    \[
>    H^{4-n}\!\left(\mathbf P(V),\mathbf Q[n-1]\right)=H^3(\mathbf P(V),\mathbf Q)=0 .
>    \]
>    **This holds for every `n`**: the shift in (5.1) conspires so that the
>    full-support term is always exactly `H^3` of the source projective space,
>    which vanishes for a projective space of any dimension.  Hence every
>    associated-graded contribution to `IH^3(Y)` has proper strict support
>    inside the non-isomorphism locus of `p`, and
>    \[
>    S\subset\operatorname{Bs}(\phi),\qquad \dim S\le n-3 .
>    \]
> 2. **(unique jump)** `T` is irreducible over `Q` as a `G`-module
>    (Theorem S0(1)), the perverse filtration is `G`-stable and consists of
>    rational Hodge substructures, so `alpha_phi(T)` meets each step in `0` or
>    all of `T`: there is a unique perverse jump `j_0`, and
>    `T ↪ Gr^P_{j_0} IH^3(Y)(1)`.
> 3. **(a proper support orbit receives it)** Pure perverse Hodge modules
>    decompose canonically by strict support; grouping supports into
>    `G`-orbits gives canonical `G`-stable blocks of the associated graded.
>    At least one orbit block receives a nonzero — hence, by irreducibility,
>    injective — projection of `T`.  With `M_{S,j_0} subset P_{j_0}` the
>    maximal strict-support summand on a representative `S` and
>    `H = Stab_G(S)`, Frobenius reciprocity gives
>    \[
>    \boxed{\;
>    \operatorname{Hom}_{\mathrm{HS},H}
>    \Bigl(\operatorname{Res}_H T,\;
>    H^{\,4-n-j_0}\bigl(\mathbf P(V),\mathcal M_{S,j_0}\bigr)(1)\Bigr)\neq 0 .}
>    \tag{AHS-spin}
>    \]
> 4. **(refinement)** If `IC_{Sbar}^H(L) subset M_{S,j_0}` is a simple
>    constituent, `H'` the stabilizer of the pair `(S,L)` and `s = dim S`,
>    then
>    \[
>    \operatorname{Hom}_{\mathrm{HS},H'}
>    \Bigl(\operatorname{Res}_{H'}T,\;IH^{\,s+4-n-j_0}(\overline S,\mathcal L)(1)\Bigr)\neq0 .
>    \tag{5.2}
>    \]
>
> `j_0` and the nonempty set of `G`-orbits of strict-support blocks with
> nonzero `T`-projection are intrinsic to `(Y,p,q)`.

*Proof.*  Projective direct image, relative hard Lefschetz and semisimplicity
give that each `P_j` is a polarizable pure Hodge module of weight
`(n-1)+j` with a canonical strict-support decomposition, that the perverse
Leray sequence degenerates, and that the induced filtration on `IH^3(Y)` is
by rational Hodge substructures (`AMBIENT_SUPPORT.md` §3, which uses nothing
about the source but properness and projectivity).  Part 1 is the
computation displayed, plus primitivity of the landing tuple for the
codimension bound.  Part 2 is Theorem S0(1) plus `G`-stability.  Part 3 is
the ambient argument verbatim.  Part 4 is
`H^{k}(P(V), IC_{Sbar}(L)) = IH^{k+s}(Sbar, L)`.  `QED`

**Regression.**  At `n = 5` (the linear ambient source) (5.2) becomes
`IH^{s-1-j_0}` — exactly equation (2.7) of
`AMBIENT_HODGE_REES_BRIDGE/THEOREM.md`.  Checked in the verifier, §F.

## 6. The weight-one abelian factor, and the `E_{-11}` requirement

The image of `T` in (AHS-spin) is, after the Tate twist, a polarizable
effective Hodge structure of weight one, hence `H^1` of an abelian variety
`A_{S,j_0}` defined up to `H`-equivariant isogeny, with

\[
\operatorname{Hom}_{\mathrm{HS},H}\!\left(\operatorname{Res}_HT,\;H^1(A_{S,j_0},\mathbf Q)\right)\neq0 .
\tag{6.1}
\]

> **Corollary S4 (`E_{-11}` per support, with the exact multiplicity floor).**
> `A_{S,j_0}` contains a nonzero `E_{-11}`-isotypic factor.  More precisely,
> let `k(H)` be half the dimension of the smallest nonzero `H`-stable
> sub-Hodge structure of `T`.  Then `A_{S,j_0}` contains at least `k(H)`
> copies of `E_{-11}` up to isogeny, and
> \[
> k(1)=k(C_2)=k(C_3)=k(C_5)=k(C_6)=k(S_3)=k(D_{10})=1,
> \qquad
> k(C_{11})=k(F_{55})=5 .
> \]

*Proof.*  By Theorem S0(2) every sub- and quotient Hodge structure of `T` is
`E_{-11}`-isotypic, so a nonzero image is `H^1(E_{-11}^k)` for some `k >= 1`;
this is the Auto-CM conclusion, now with the multiplicity made exact.  The
image is a nonzero `H`-stable Hodge quotient of `T`, so `k >= k(H)`.  For the
first seven groups `T^H != 0` (verifier §D: `dim T^H = 10, 6, 2, 2, 2, 2, 2`
respectively), `T^H` is a sub-Hodge structure, and every nonzero
`E_{-11}`-isotypic Hodge structure contains one copy of `H^1(E_{-11})`, so
`k(H) = 1` and it is attained by the projection onto the trivial isotypic
part.  For `H = C_11` and `H = F_55`, `Res_H T` is **irreducible over `Q`**
(verifier §D': `Res_{C_11}T = (+)_{k != 0} psi_k`, the unique 10-dimensional
`Q`-irreducible of `C_11`, with no invariants;
`Res_{F_55}T = theta_1 (+) theta_2` with `theta_i` the two 5-dimensional
irreducibles, Galois-conjugate over `Q(sqrt(-11))`, and **no** trivial and
**no** linear character occurs), so the only nonzero quotient is all of `T`:
`k = 5`.  `QED`

`A_{S,j_0}` is attached to the strict-support *block*, not to the Albanese of
a geometric support; Test 3 of the ambient packet (contraction of
positive-genus geometry) forbids any ordinary-irregularity reformulation, and
that boundary is inherited here unchanged.

## 7. The perverse-degree ledger — recomputed, not copied

From (5.2), a block with support of dimension `s` contributing in
intersection-cohomology degree `i` has

\[
\boxed{\;i=s+4-n-j_0\;}
\qquad\Longleftrightarrow\qquad
j_0=s+4-n-i .
\]

| channel | `s` | `i` | `j_0` at `n=5` (ambient) | `j_0` at `n=6` (`P(U)`) | `j_0` general |
|---|---|---|---|---|---|
| point support | 0 | 0 | `-1` | **`-2`** | `4-n` |
| curve, `H^1` | 1 | 1 | `-1` | **`-2`** | `4-n` |
| surface, `H^1` | 2 | 1 | `0` | **`-1`** | `5-n` |
| threefold, `H^1` | 3 | 1 | `1` | **`0`** | `6-n` |

The `n = 5` column reproduces `THEOREM_POINT_SUPPORT.md` (2.1) and the two
"classical channels" `(2,0)` and `(1,-1)` of `AMBIENT_SUPPORT.md` §8; the
`n = 6` column is new, and the threefold row does not exist at `n = 5` at all
(there `dim S <= 2`).

> **Proposition S5 (point supports need a two-dimensional exceptional
> fibre).**  Suppose `M_{x,j_0}` is a point-supported summand at `x in Bs(phi)`.
> Then `j_0 = 4-n`, and, writing `Y_x = p^{-1}(x)`, the summand contributes
> to the stalk in cohomological degree
> `j_0 + (n-1) = 3`.  Hence its Hodge structure is a weight-three
> `H`-sub-Hodge structure
> \[
> W_x\subset \mathbf H^{\,j_0}\!\left(Y_x, IC_Y^H\right)
> =\mathbf H^{\,3-(n-1)}\!\left(Y_x, IC_Y^H\right),
> \qquad\text{equal to } W_x\subset H^3(Y_x,\mathbf Q)\ \text{ when } Y\text{ is smooth near }Y_x,
> \]
> and therefore
> \[
> \boxed{\dim Y_x\ \ge\ 2 .}
> \]

*Proof.*  A skyscraper perverse summand at `x` contributes to global
hypercohomology only in degree zero, so `4-n-j_0 = 0`.  By the decomposition
theorem `Rp_*IC_Y^H = (+)_j\, P_j[-j]`, so a skyscraper summand of `P_{j_0}`
appears in `H^{j_0}` of the stalk at `x`; proper base change identifies the
stalk with `RGamma(Y_x, IC_Y^H)`, whose degree-`k` piece vanishes unless
`-(n-1) <= k <= 2\dim Y_x-(n-1)`.  With `k = j_0 = 4-n` this reads
`4-n <= 2\dim Y_x-(n-1)`, i.e. `\dim Y_x >= 3/2`, i.e. `>= 2`.  Equivalently:
the carrier is `H^3` of the fibre, and `H^3` of a curve vanishes.  `QED`

This reproduces `THEOREM_POINT_SUPPORT.md` (3.3) at `n = 5` and sharpens it
with the fibre-dimension floor, which is uniform in `n`.

> **Corollary S6 (the target-side shape of a point support).**  `Y` is finite
> over the closure of the graph in `P(V) x V14`, so `q` restricts to a finite
> map `Y_x -> Z_x := q(Y_x) subset V14`, with `Z_x` a closed
> `H`-invariant subvariety of the **threefold** `V14` of dimension
> `dim Y_x >= 2`.  A point of the source with a point-supported Hodge block
> therefore blows up to a surface or to all of `V14`.

## 8. Boundaries respected

* No canonical splitting of `Rp_*IC_Y^H` is claimed; only the canonical
  filtration, the canonical jump `j_0`, and the canonical nonempty set of
  strict-support orbits (`AMBIENT_SUPPORT.md` §9 verbatim).
* No Chow projector.  The relatively-ample idempotent of Theorem S1 depends on
  the chosen `eta`; decomposition-theorem projectors are absolute Hodge and
  André motivated but not known to be algebraic here, and `p` is not known to
  be semismall.
* Point supports, non-Tate local systems, singular supports and nonsemismall
  perverse degrees are all allowed.  Corollary C of the ambient packet
  (finite-cover `H^1` carriers) applies only under its hypotheses
  `s+4-n-j_0 = 1` and `L = U(-1)` with `U` of finite monodromy, and is not
  imposed.
* Nothing here is a fixed-point statement, which is the point: the invariant
  survives the exhaustion recorded in `MULTIPLICITY_ROUTE.md` Cor N4.  In
  particular the destructibility theorems (N3: `X_0^{D_10} = empty` is
  achievable) do **not** touch Theorem S3 — destroying a fixed locus by an
  equivariant blowup changes neither `Y`, nor `alpha_phi`, nor the support
  package, exactly as Test 2 of the ambient packet records.
* No transfer to a restricted graph is claimed.  `RESTRICTED-TRANSFER-UNDECIDED`
  stands, and its spin analogue is untouched: on the target side the
  full-support `IC_{V14}` term already contributes `H^3(V14)`.

## 9. What is new relative to the ambient packet

1. `T` is **identified on the `V14`** for the first time (Theorem S0), from
   sealed data plus one Lefschetz count, without using the Tschinkel--Zhang
   equivalence — which could not have done the job, since it is only
   twisted-stable and the twins are separately birationally rigid.
2. Injectivity of `q^*` is shown to be insensitive to the fibre dimension
   `e = n-4 >= 2` (Theorem S1), so the whole construction ports to every spin
   source, uniformly in `n`.
3. The vanishing that drives the forcing is `H^3(P^{n-1}) = 0`, which is
   **stronger and more robust** than the ambient `H^3(P^4) = 0`: it is a
   vanishing for a projective space of any dimension, and the perverse
   indexing shifts exactly so that the full-support term is always `H^3` of
   the source.
4. The perverse-degree ledger is recomputed: point supports sit at
   `j_0 = 4-n` (so `-2` on `P^5`, not `-1`), and a **threefold** support
   channel exists on `P^5` that has no ambient counterpart.
5. Corollary S4 upgrades "contains a nonzero `E_{-11}`-isotypic factor" to an
   exact per-stabilizer floor, with `k = 5` — all five copies — at `C_11` and
   `F_55`.
6. Proposition S5 / Corollary S6 give the geometric floor for point supports:
   a two-dimensional exceptional fibre, mapping finitely onto a surface (or
   all) of `V14`.

## 10. Exit

```text
SPIN-HODGE-SUPPORT-PROVED
SPIN-SUPPORT-CENSUS-TABLED          (SUPPORT_CENSUS.md)
SPIN-CHAIN-OBSTRUCTION-UNDECIDED    (unchanged)
SPIN-HODGE-SUPPORT-ESCAPE-UNDECIDED
```

`SPIN-HODGE-SUPPORT-PROVED` is the ported theorem: Theorems S0-S3,
Corollaries S4-S6.  It is a **necessary condition** on a hypothetical
dominant `G`-equivariant spin map, not an obstruction: no census cell dies
for all degrees and all spin sources, so the headline consequence chain is
**not** triggered and Problem E's spin flank remains **OPEN**.  The exact
surviving cells are boxed in `SUPPORT_CENSUS.md` §6.
