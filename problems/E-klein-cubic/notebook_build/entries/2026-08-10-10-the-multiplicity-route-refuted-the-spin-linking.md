# Notebook supplement — 2026-08-10: the multiplicity route REFUTED (the SPIN-LINKING LEMMA is false as boxed; the fixed-point flank is exhausted)

## What was asked

Execute route 1 of the boxed SPIN-LINKING LEMMA
(`goal_runs_20260810/SPIN_SOURCE_NETWORK/KLEIN_SPIN_COMPLEX.md` §7): prove or
refute that at multiplicity `m >= 2`, on `P(U^{(+)m})`, the carriers of two
eigenplanes through an incidence point stay linked at every order. Engine
Thm 7.4 predicted the link, since `<chi_{T_x}, 1_K> = m - 1 >= 1` there. If it
closed, the consequence chain would be the repository headline
(`ed_C(PSL_2(F_11)) = 4`). Route 2 was already closed by Thm V3.

Packet: `goal_runs_20260810/SPIN_SOURCE_NETWORK/MULTIPLICITY_ROUTE.md`,
`THEOREM_SPIN_MULTIPLICITY.md`, `ADVERSARIAL_TESTS.md`,
`verify_spin_multiplicity.py`.

## Exits

```text
SPIN-MULTIPLICITY-REFUTED       the m >= 2 linking of Thm 7.4 does not exist,
                                at any m and at any order
SPIN-LINKING-LEMMA-FALSE        as boxed ("in every G-equivariant resolution")
D10-FIXED-POINT-ROUTE-DEAD      V14^{D_10} = empty exports no obstruction
SPIN-CHAIN-OBSTRUCTION-UNDECIDED  (unchanged; both named routes now closed)
SPIN_MULTIPLICITY_OK            (verifier marker)
```

`SPIN-CHAIN-OBSTRUCTION-PROVED` is **NOT** claimed, and is now known not to be
reachable by either named route. The headline consequence chain is **not**
triggered: it was conditional on the boxed lemma. Headline unchanged: **OPEN**.

## What was found

**The `m - 1` invariants are tangential.** At an incidence point `x` with
`K = Stab_G(x)` in `{S_3, D_10}`, let `Z = P(V_lambda)` be the locus of the
spin linear character of `Ktilde` that `x` belongs to. Then `Z ~ P^{m-1}` is
pointwise `K`-fixed and is a connected component of `P(V)^K` (`Ktilde` has
exactly two spin linear characters, so `P(V)^K = Z | | Z'`). The three exact
identities that decide the route:

```text
m_triv(T_x)  =  dim V_lambda - 1  =  m - 1  =  dim Z  =  dim T_x Z
m_triv(N_{Z/P(V)})  =  0                                for every m
```

The trivial multiplicity Thm 7.4 found grows with `m` **for exactly the reason
the `K`-fixed locus does, and no faster**: it is entirely spent on directions
*along* `Z`, and the normal representation has no invariants at any
multiplicity. Thm 7.4's reading — "the two traces on the exceptional divisor do
meet" — is a statement about blowing up the *point* `x`, and is an artifact of
that centre. The persistence induction the route needed dies at step 1, at
every `m`, including `m = 1`.

**One equivariant blowup separates everything.** The 352 incidence loci are
pairwise disjoint, so `W = | | Z_e` is a smooth `G`-invariant centre and
`B = Bl_W P(V)` is smooth. In `B` the involution-fixed locus
`Fix(B) = U_rho B^rho` has exactly `110 + 352 = 462` connected components: one
per plane (its strict transform together with the twelve `A`-loci
`P(N^{rho,+1})` it carries) and one per incidence locus (the `|Inv K|` loci
`B_rho = P(N^{rho,-1})`, glued along the sign locus `S_Z`). The `A`'s are
pairwise disjoint and disjoint from every `B`; only the `B`'s meet each other.
Since chains **push forward** along a birational equivariant morphism (images
of irreducible RCC pointwise-fixed subvarieties are again such, and consecutive
images still meet) and the carrier in any resolution maps *onto* the carrier in
`B`, no chain of the boxed lemma's type joins two carriers in any resolution
that dominates `B` — and blowing up `W` first is always a legal opening move,
`W` being smooth, `G`-invariant and inside `Ind(phi)` by Thm K4. **The boxed
lemma is false as stated.**

**The resolution-free form of the `D_10` datum is also refuted.** The sharpest
statement `V14^{D_10} = empty` supports needs no chain: an equivariant map
exists only if *some* smooth projective `G`-variety `G`-birational to `P(V)`
has empty `D_10`-fixed locus. That is satisfiable. A fixed locus survives a
blowup at a centre `C` through `p` iff `T_pX/T_pC` contains a **linear**
character of the group (for abelian groups every irreducible is one — this is
the Reichstein-Youssin fixed-point theorem, recovered as the degenerate case,
and the sanity check the criterion must pass). For `D_10` it has teeth: the
`(-1)`-eigenspace `ell_0` of the `C_10`-lift of the Sylow 5-subgroup is
2-dimensional, `L = P(ell_0 (x) C^m)` contains **both** `D_10`-fixed loci, and
`T_z^{C_5} = T_z L`, so `N_L = m W_1 (+) m W_2` has no linear character of
`D_10` at all. The 66 translates of `L` are not disjoint — 660 of the 2145
pairs meet, exactly the Sylow-5 pairs inside a common Borel, 11 lines
concurrent at each of the 12 `F_55`-points — so the centre is two-step: blow up
the 12 `F_55`-loci first (pairwise disjoint, fixed by no involution, so no
involution's fixed locus is disturbed), then the 66 now-disjoint strict
transforms. The result has empty `D_10`-fixed locus. Thm V1 is true but not
extendable: the resolution never has to create the sign point at all.

**The fixed-point flank is exhausted.** The possible spin point stabilisers are
`1, C_2, C_3, C_5, C_6, C_11, S_3, D_10, F_55`. For every **abelian** one with
`P(U)^A != empty` — the only ones whose fixed-point emptiness is a birational
invariant — `V14^A != empty`. `V14^{S_3} != empty` (measured); `V14^{D_10}` is
empty but destructible (above); the `F_55` point was already known destructible
(`KLEIN_SPIN_COMPLEX.md` §3). So no obstruction of fixed-point type remains on
the sealed and measured data, at any multiplicity, and any future attack on the
spin flank needs an invariant that is not of fixed-point type. (`V14^{C_5}` and
`V14^{C_11}` are the only audit entries not settled in-repo; both are nonempty
by `chi(V14^{C_p}) = chi(V14) = -6 mod p`, which uses the literature
`b_3(V_14) = 10` and is flagged as such in the packet. Nothing proved depends
on them.)

## Consistency tests (all four run; `ADVERSARIAL_TESTS.md`)

1. **D12 test — PASSED and informative, with a factual correction.** The brief
   assumed no single `D_12` sees an incidence point. It does: two reflections of
   `D_12` whose product has order 3 generate an `S_3 <= D_12` and their planes
   meet. So a *proof* of linking at `S_3` points would contradict Cor IX.6's
   realised `D_12`-spin-unirationality. The refutation has the opposite sign and
   explains the escape: the separating centre `W` is `G`-invariant, hence
   `D_12`-invariant, so it is available in the resolution of the realised map.
2. **m = 1 test — INVERTED, reported as such.** No induction step drops to
   trivial multiplicity 0 at `m = 1`, because the induction never starts:
   `m_triv(N_Z) = 0` at every `m`. The `m = 1` specialisation reproduces Thm K5
   exactly and is the verifier's regression check.
3. **Definedness test — PASSED.** Nothing evaluates `phi`. K4 is used only to
   say that blowing up `W` is natural, never that `phi` is defined anywhere.
4. **No withdrawn machinery — PASSED.** No Chow projector; RCC-ness is used
   only in the elementary direction "the image of an RCC variety is RCC".

An extra self-test, recorded because the first attempt failed it: the naive
one-step centre `| |_{66} L` is **not** smooth (the lines are concurrent at the
`F_55`-points), which is why the two-step centre above is the correct
statement.

## Quantifier discharge — status

Not reached and moot, since nothing is proved about `P(U)`. For the record, the
discharge argument was checked line by line: Thm 7.4's first direction (a
dominant `P(U)` map yields dominant `P(U^{(+)m})` maps) is correct but now
useless, since `P(U^{(+)m})` is unobstructed too; Lemma IX.3's folding reduces
"all sources" to "all spin sources", **not** "all spin sources" to `U`. So even
a complete obstruction for `P(U^{(+)m})` would have covered only sources
containing `U` (and, by the Galois symmetry of the integral model
`W = U (+) U'`, `U'`); the higher-dimensional faithful spin irreducibles of
`SL(2,11)` would have remained. This is stated exactly so no future packet
over-reads it.

## Verification

`verify_spin_multiplicity.py` (`SPIN_MULTIPLICITY_OK`), exact over `Q(i)` in
the 12-dimensional integral monomial model, about 40 s, python standard library
only: the network regression; the Thm K5 regression at `m = 1` on all 352 loci;
the four-sign incidence pattern `(1,0,0,1)` on all 1980 incident pairs; the
pairwise disjointness of the 352 loci on all 61776 pairs; the multiplicity
ledger for `m = 1..8`; the `462 = 110 + 352` component count of `Fix(B)` built
by union-find from the computed intersection dimensions; the `D_10` destruction
centre with the `{0: 1485, 2: 660}` split and the 12 Borels; and the abelian
audit. Stabilisers are measured by acting with all 660 elements of `G`, through
a fast monomial-action routine cross-checked against
`spin_network_lib.stab_of_point`.

`verify_spin_multiplicity.py` and `scripts/check_manifest_parity.py` pass. The
packet is on `agent/spin-multiplicity-20260810`. This notebook revision was
authored against parent head `aaf88467d8d958727933caad29be0070f38ff450`.
