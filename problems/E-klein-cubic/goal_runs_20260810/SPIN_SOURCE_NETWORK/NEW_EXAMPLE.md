# Part 3 — the new example: the spin flank of Problem F

**Chosen case.** `G = PSL(2,F_7)` acting on `S`, the Klein degree-two del
Pezzo surface (`w^2 = x_1^4 + x_2^4 + x_3^4`-type double cover of `P(V)`
branched over the Klein quartic `x^3y + y^3z + z^3x`); source
`P(U) = P^3` where `U` is a 4-dimensional faithful **spin** irreducible of
`Gtilde = SL(2,F_7)`.

Verifier: `verify_spin_dp2_psl27.py`, exit marker `SPIN_DP2_PSL27_OK`,
exact, characteristic 0, no sampling.

## 1. Why this is the right case

**Candidates considered.**

| candidate | verdict |
|---|---|
| `PSL(2,7)` on the degree-2 del Pezzo `S`, spin `P(U) = P^3` | **CHOSEN** |
| `V14`/`V22`-type index-1 Fanos for `2.PSL(2,7)` | no `PSL(2,7)`-equivariant model measured in-repo; target network would have to be built from scratch |
| applications-packet actions with nontrivial double cover | the read-only `research/…/CANDIDATE_TABLE.md` cases either have `Y^H` unmeasured or the group is centreless with trivial Schur multiplier |

Reasons the `PSL(2,7)`/dP2 case wins on all three criteria the brief asks
for:

1. **Explicit action, target network already measured.** `S^{C_2}` = smooth
   genus-one curve `+` 2 isolated points, computed exactly in
   `problems/F-dp2-psl27/certificates/wp1_fixed_loci.py` (line 585) and
   proved in `WP1_FIXED_LOCI.md`; the all-degree engine and its exact checker
   (`wp3_all_degree_path_obstruction.py`, marker
   `WP3_ALL_DEGREE_PATH_OBSTRUCTION_OK`) are in-repo and replay clean.
2. **Genuine prior undecidability, literature-confirmed.** Problem F's
   `SPEC.md` (lines 62-66) restricts the source to "a finite-dimensional
   complex **linear** representation of `G`". A strict search of
   `problems/F-dp2-psl27/` for `spin`, `projectively linear`,
   `Severi-Brauer` returns **zero hits**: the closed theorem never touches
   this flank. Externally, Cheltsov-Tschinkel-Zhang (arXiv:2502.19598, p.1-2)
   define `G`-unirationality only as `P(V) --> X` for `V` a genuine
   `G`-representation, so spin sources are outside the published notion by
   definition, not silently included. No paper was found treating dominant
   equivariant maps to a del Pezzo surface from a projectively-linear source.
3. **The engine's inputs are all cheap and exact** — and it turns out the
   rigidity hypothesis is *easier* to verify here than on the `V14`, because
   the target is a **surface**.

## 2. The engine's computations (all exact)

Same integral model, `q = 7`: `W = Ind_B^{SL(2,7)}(chi)` has dimension 8,
`rho(-I) = -id_8`, `<chi_W,chi_W> = 2`, so `W = U (+) U'` with `dim U = 4`.

* `-I` is the unique involution of `SL(2,7)`; `PSL(2,7)` has **21**
  involutions and **14** Klein four-groups, each with preimage `Q_8`, and

      U|_{Q_8} = 2 . H    (no 1-dimensional summand)   =>   P(U)^{V_4} = EMPTY.

* `chi_W` vanishes on the order-4 elements, so each lifted involution splits
  `U` as `2 + 2`:

      P(U)^sigma = P^1 disjoint-union P^1,     42 LINES in P^3.

  `C_G(sigma) = D_8`; the stabiliser of a single line is the index-2 `C_4`,
  and the other four elements swap the pair.
* Pair types over the 210 unordered pairs of involutions:
  `n = 2` (`V_4`) 42, `n = 3` (`S_3`) 84, `n = 4` (`D_8`) 84. `D_14` does not
  occur: `N_G(C_7) = F_21` has no involution.

### Incidence table (all 861 unordered pairs of the 42 lines)

| pair type | `<sigma,tau>` | line pairs | disjoint | meeting |
|---|---|---|---|---|
| same involution | — | 21 | 21 | 0 |
| `n = 2` | `V_4` | 168 | 168 | **0** |
| `n = 3` | `S_3` | 336 | 168 | **168** |
| `n = 4` | `D_8` | 336 | 336 | **0** |

* `V_4`: disjoint by the `Q_8` mechanism (`U = U_{+i}(sigma) (+)
  U_{eps i}(tau)`).
* `D_8`: disjoint because the preimage `Q_16` (generalised quaternion) has
  `-I` in its commutator subgroup, so `P(U)^{D_8} = empty` — the exact
  analogue of `P(U)^{D_12} = empty` in the Klein case.
* `S_3` is the **only** incidence type: preimage `Q_12`, abelianisation
  `C_4`, two spin linear characters, each of multiplicity 1 in `U`.

**Network:** 168 edges, **56 distinct incidence points**, each lying on
exactly 3 lines with `Stab_G(x) = S_3` exactly (56 = 28 `S_3`-subgroups times
2 fixed points each). A `56_3 / 42_4` configuration in `P^3`. The graph is
**connected and 8-regular**, eccentricity 3; lines of a `D_8`-generating pair
are never adjacent.

**Local structure at an incidence point:** `T_x` is a 3-dimensional honest
`S_3`-representation with `m_triv = 0`, `m_sign = 1`,
`dim T_x^{sigma,+1} = 1`, `dim T_x^{sigma,-1} = 2`, i.e.
`T_x = sign (+) std`.

## 3. What the engine DECIDES here

**Theorem F1 (rigidity — unconditional, no new target computation).** Let
`phi : P(U) --> S` be any `PSL(2,7)`-equivariant rational map. Each line
`l = P(U_{eps i}(sigma))` is contracted to a point `y(l)` of `S^sigma` fixed
by `C_4(sigma)`. Then

    y(l_sigma) = y(l_tau)  =>  sigma = tau.

*Proof.* `Stab_G(y)` contains both `C_4(sigma)` and `C_4(tau)`, hence two
**distinct** cyclic subgroups of order 4. In the subgroup lattice of
`PSL(2,7)` (`1, C_2, C_3, V_4, C_4, S_3, C_7, D_8, A_4, F_21, S_4, G`) the
only subgroups containing two distinct `C_4`'s are `S_4` and `G` (`D_8`
contains exactly one `C_4`; `V_4, A_4, F_21` contain none). But `S` is a
smooth **surface**, so `Stab_G(y)` embeds in `GL(T_y S) = GL_2`, and neither
`S_4` (its only 2-dimensional irreducible has kernel `V_4`) nor
`PSL(2,7)` (degrees 1,3,3,6,7,8) has a faithful 2-dimensional representation.
Contradiction. `QED`

This is the **tangent criterion** of engine Thm 5.1 doing real work: on the
`V14` the analogous step needed the sealed `V14^{D_12} = empty`; here the
dimension of the target supplies it for free.

**Theorem F2 (mandatory base locus).** All **56** incidence points lie in
`Ind(phi)`. `phi` restricted to a line has image an irreducible rational
subvariety of `S^sigma` = (genus-one curve) `+` 2 points, hence a point; two
lines of different involutions through a common point of definition would
contradict F1.

**Theorem F3 (no scalar birth).** No point of `P(U)^sigma` is a scalar point
of `sigma` (`sigma` acts on `T_x` with multiplicities `(1,2)`). Problem F's
engine turns exactly on the opposite fact for its **linear** source: at a
quadruple point `q = P(E_+(z))` with `dim E_+(z) = 1`, `dz|_q = -1` is
scalar, so `A_q = P(T_q)` is pointwise `z`-fixed and links the incident
strata (`WP3_ALL_DEGREE_PATH_OBSTRUCTION.md` §2, `FIX_T_gate.md` Lem T2.1).
**That link has no spin analogue.**

**Theorem F4 (first-order separation).** At an incidence point,
`T_x^K = 0`, so the traces `P(T_x^{sigma,+1})`, `P(T_x^{tau,+1})` on the
exceptional `P^2` are two **distinct points**: one blowup separates the
carriers. The lines `P(T_x^{rho,-1})` do all meet, at the sign-point, but are
disjoint from the carriers.

## 4. What it does NOT decide, and the honest payoff

The same **SPIN-LINKING LEMMA** boxed in `KLEIN_SPIN_COMPLEX.md` §7 is the
missing step, in identical form. Both instantiations of the engine terminate
at exactly the same place — which is itself the packet's cleanest structural
finding: the gap is a property of spin sources, not of either particular
group.

**Payoff if the box is closed** (stated honestly):

* It would extend Problem F from "no dominant equivariant map from any
  **linear** source" to "no dominant equivariant map from any **projective**
  source, linear or spin" — the complete statement over all
  projectively-linear `PSL(2,7)`-actions, which is exactly the scope gap that
  CTZ's definition leaves open.
* It would **not** give a new essential-dimension statement.
  `ed_C(PSL(2,7)) = 2` is already known: A. Duncan, *Finite groups of
  essential dimension 2*, Comment. Math. Helv. 88 (2013) 555-585
  (arXiv:0912.1644) Thm 1.1, restated in Beauville arXiv:1101.1372 Prop 16.3.
  And by Duncan-Reichstein (arXiv:1109.6093) Prop 9.1, a finite
  `G <= PGL_n` acting on `P^{n-1}` is weakly versal iff the extension splits;
  `SL(2,7) -> PSL(2,7)` is the (unique, nonsplit) double cover, so
  `P(spin)` is itself not weakly versal and its generic twist is a nonsplit
  Severi-Brauer variety. Spin-unirationality therefore carries no versality,
  hence no `ed`, consequence — the same mechanism that [IX §7] records for
  `PSL(2,11)`.

So the honest classification of this example is: **new theorem territory for
equivariant unirationality, not for essential dimension.** The
essential-dimension payoff of the spin flank exists only on the `PSL(2,11)`
side, through Cor IX.5, and that is repo-original and unpublished.

## 5. Literature audit (delegated, verified)

* `ed_C(PSL(2,7)) = 2` — Duncan, arXiv:0912.1644 Thm 1.1; Beauville
  arXiv:1101.1372 Prop 16.3. **Known.**
* `ed_C(SL(2,7)) = 4` — **Yu. Prokhorov, *Quasi-simple finite groups of
  essential dimension 3*, arXiv:1703.10780, Prop 2.6.** Its Lemma 2.6.1
  proves that the image `V_4 <= PSL(2,7)` of a `Q_8 <= SL(2,7)` fixes a point
  on **every** rational `PSL(2,7)`-surface, the degree-2 del Pezzo included —
  an independent published analogue of Problem F's own `V_4` Condition-(A)
  computation. **This paper is cited nowhere in `problems/F-dp2-psl27/`.**
  Flagged as a citation gap; it does not contradict anything in the packet
  (our `P(U)^{V_4} = empty` is about the 3-fold source `P^3`, not about a
  surface).
* Duncan-Reichstein arXiv:1109.6093: Thm 10.5, Prop 10.8(a)(b)(c),
  Remark 10.10 confirmed as quoted in `FIX_IX_v14.md`; §9 Prop 9.1 is the
  Severi-Brauer/versality mechanism cited above.
* Tschinkel-Zhang arXiv:2409.08392 Thm 1.1 / Prop 4.1 is the external source
  for the spin `P(V)` stable factor on the `PSL(2,11)` side.
* No external statement of "killing spin sources on the `V14` gives
  `ed_C(PSL_2(F_11)) = 4`" exists; it is repo-original (Cor IX.5) and is
  marked open there.

## 6. Exit

    NEW-EXAMPLE-ASSESSED
    SPIN-DP2-PSL27-UNDECIDED

The example is genuinely open, the engine runs on it completely and exactly,
it yields two new unconditional theorems (F1 rigidity, F2 mandatory base
locus) plus the structural diagnosis F3/F4, and it stops at the same boxed
lemma as the Klein case. It is **not** decided.
