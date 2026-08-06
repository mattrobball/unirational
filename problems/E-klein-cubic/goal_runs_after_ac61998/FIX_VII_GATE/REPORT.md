# FIX-VII-GATE — REPORT

**Exit: `FIX-VII-GATE-CANDIDATES-EXIST`.** All checks PASS at p = 67 and
p2 = 199 (`results/checks.log`, 0 FAIL).

## The chain

```
dim M_34                     576   (Molien, exact; span certified explicitly)
n1 = 576 - rank(profile)      16   = s_34, the sealed FIX-P2 (1,6)/d=34 slice
n2 = n1 - rank(restr. to C)   13   identical at p = 67 and p = 199
```

## Stage 1 — the group
`g11 = diag(z,z^9,z^4,z^3,z^5)`, `s5`, and the Weil involution `S` from the
square-root labeling `b=(1,3,2,5,4)`, `s=(1,1,-1,1,1)`, `t=1`, normalised to
`S^2=I, det=1`: all three preserve `F`, det 1, orders 11/5/2; linear closure is
exactly 660 with profile `{1:1, 2:55, 3:110, 5:264, 6:110, 11:120}`.
Extra: this group is **literally the same 660 matrices** as FIX-P2's
`slicelib.build_frame` group at both primes (`group_matches_P2`), so the
cross-check below compares constructions, not conventions.

## Stage 2 — M_34, spanned and certified
Generator bases d<=12 by generator-equivariance null-spaces reproduce the
banked map/polar/trivial ladders exactly. The invariant ring to degree 33 was
built **multiplicatively alone** (products with the trivial-type bases of
degree <=12); contractions `<map_e, polar_k>` were never needed, and every
degree d<=33 hits the exact Molien dimension (`invariant_ladder_full`).

*Deviation (anticipated by the brief).* Products `inv[34-e] x map[e]` with
e<=12 give rank **575**, one short. Extending the map-type generators by direct
null-space gives d=13 (dim 21) and d=14 (dim 26), both = Molien; e=14 supplies
the missing dimension and the rank is exactly **576** (`span_576`). So the
degree-34 covariant module is *not* generated over the invariant ring in
degrees <= 12.

Ranks are certified by evaluation at 620 random points of F_p^5. Every form
here has degree <= 34 < p, so a nonzero form is a nonzero function, and
rank(evaluation) <= dim(span) always — hitting the Molien dimension is a
decisive equality, not an estimate.

## Stage 3 — the (1,6) profile
Conditions taken verbatim from the sealed sieve implementation (the only two
blocks `produce_sweep2` concatenates): (a) `plane_blocks(m=1)` = all five
components vanish on the plus-plane `Pi_sigma`; (b) `line_block(r=6)` = the
t-jet coefficients 0..5 of all five components along `ell_V`, all transverse
directions. **No translation ambiguity arose** — the multi-order (6;1,1,1) is
"order 6 along the line + order 1 on each plus-plane", and equivariance reduces
the three planes to one. (c) No condition at `c_sigma`, per
FIX-P2-H11-LOCAL-CONFIRMED.

Keystone: re-running the FIX-P2 pipeline itself reproduces `s_34 = 16`
(sealed `SWEEP2_p67_34_38`) at p=67, and gives 16 at p=199 too. This packet's
independent construction gives **n1 = 16 at both primes** — two unrelated bases
of M_34 (Reynolds averages of monomial seeds vs invariant x covariant
products) and two independently coded condition blocks agree.
Payload `payload/profile_basis_p{67,199}/`: 16 explicit degree-34 tuples,
re-verified from the coefficients alone (`verifier.py`) — equivariant under all
660 elements, vanishing on the plane, order exactly 6 (not 7) along the line.

## Stage 4/5 — the carrier cut
`I_C = sat((H)+jac H)`: dim 1, degree 20, HP 20i-25, 15 quartics, HF(34)=655 —
all as banked. Reducing all 80 components mod a GB gives rank **3** (each
component alone already has rank 3), so **n2 = 13** at both primes. Controls:
`H*x_i` reduces to 0; the whole conclusion is re-derived in the ring with the
opposite variable order (different GB, different normal forms) — 65/65
candidate components reduce to 0 and the 3 witnesses stay independent.
The 60 points of C(F_67) plus their tangent functionals give rank 2: a
consistent lower bound, but one G-orbit does not saturate rank 3.

Payload `payload/candidates_p{67,199}/`, 13 tuples each. Per candidate:
T != 0 and T not identically zero on X; `<T,x>` (degree 35) is **nonzero**;
`F(T) mod (F)` is **nonzero** — decisively, F(T(v)) != 0 at ~3900 of 4000
sampled F_p-points of X = V(F).

## Semantics and wall times
Modular asymmetry is respected throughout: 16 and 13 are computed mod p, so in
characteristic 0 they are **upper bounds** (rank mod P <= rank over K). Two
primes agreeing is evidence, not proof, that the char-0 dimensions are also
16 and 13; a zero would have been decisive, a nonzero is not.

Stage 1 <1s; Stage 2 44s/43s; FIX-P2 replay 63s per prime; Stage 3 48s/51s;
Stage 4 300s/305s (M2, dominated by parsing 13.6 MB of degree-34 input);
Stage 5 309s/311s; verifier 8s; C(F_67) point control 10s. Engines: python3 +
numpy 2.5.1, Macaulay2. Total ~25 min.
