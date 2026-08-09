# New applications of the fixed-stratum obstruction machine

**Date:** 2026-08-09  
**Repository base:** `main` at `4b8e2ac874ea54edf1f55b0b05a928050ff546af`  
**Primary exits:**

- `FIXED-LOCUS-OBSTRUCTION-GENERALIZED`
- `NEW-EQUIVARIANT-NONUNIRATIONALITY-THEOREM`

## Headline

The literature search produced a reusable strengthening of the repository's
central/centralizer obstruction and two explicit theorem families where the
standard fixed-locus hypothesis is false or where all presently available
cohomological obstructions vanish.

### New theorem family A: odd-dihedral de Jonquières conic bundles

For every odd integer `m >= 3`, let

\[
S_m\subset \mathbf P_{\mathbf P^1}
  (\mathcal O\oplus\mathcal O(m)\oplus\mathcal O(m))
\]

be the smooth conic bundle

\[
UV=(X^{2m}+Z^{2m})W^2,
\]

and let

\[
G_m=\langle\delta\rangle\times D_{2m}
\]

where `delta` exchanges `U,V`, the rotation sends `X` to `zeta_m X`, and
the reflection exchanges `X,Z` with the natural linearization on
`O(m)`. Then:

1. `S_m` is rational and satisfies Condition (A);
2. `S_m^{delta}` is the smooth hyperelliptic curve
   `C_m: y^2=x^{2m}+1`, of genus `m-1`;
3. `S_m^{G_m}=emptyset`;
4. every Sylow subgroup of `G_m` has a fixed point, so the equivariant
   universal-torsor obstruction and all higher Amitsur groups vanish for
   every subgroup;
5. nevertheless `S_m` is not weakly `G_m`-versal and hence is not
   `G_m`-unirational.

The smallest member is

\[
(S_3,G_3),\qquad G_3\simeq C_2\times S_3,
\]

a rational conic bundle with six singular fibers and a genus-two central
fixed curve. This is the best single new application found.

The product

\[
X_m=\mathbf P^1\times S_m
\]

is a rational conic-bundle threefold. Its central fixed locus is the ruled
surface `P^1 x C_m`, which contains an entire ruling of rational curves, so
the repository's original “no rational curve” formulation does not apply.
The generalized residual-RCC theorem does apply and proves that `X_m` is
not weakly `G_m`-versal. Thus the refinement requested in the work order is
genuinely necessary, not cosmetic.

### New theorem family B: the Fermat degree-two del Pezzo and an index-one Fano

Let

\[
S_F=\{w^2=x^4+y^4+z^4\}\subset\mathbf P(2,1,1,1),
\qquad G_F=\langle\tau\rangle\times S_3,
\]

where `tau` is the Geiser involution and `S_3` permutes `x,y,z`. Then:

1. `S_F` satisfies Condition (A);
2. `S_F^tau` is the Fermat plane quartic, of genus three;
3. `S_F^{G_F}=emptyset`;
4. every Sylow subgroup fixes a point, hence the universal-torsor and all
   higher Amitsur obstructions vanish for every subgroup;
5. `S_F` is not weakly `G_F`-versal and not `G_F`-unirational.

This gives a new degree-two del Pezzo theorem outside the quaternionic
higher-Amitsur cases classified by Tschinkel--Zhang. It is a central
obstruction, not a second instance of the full Problem-F exceptional-path
argument.

The product

\[
Y_F=\mathbf P^1\times S_F
\]

is a smooth rational Fano threefold of index one. Its central fixed divisor
`P^1 x B_F` contains rational curves, but no `G_F`-stable irreducible RCC
subvariety. The generalized theorem proves that `Y_F` is not weakly
`G_F`-versal. This is a clean index-one Fano application beyond the
index-at-least-two scope of the current systematic threefold literature.

## General theorem proved here

Let `Y` be a smooth projective rationally connected `G`-variety, let
`sigma in G`, and set `N=C_G(sigma)`. Assume:

1. every `N`-stable irreducible rationally chain connected closed
   subvariety of `Y^sigma` is a point;
2. `Y^N=emptyset`.

Then no faithful linear `G`-source admits a `G`-equivariant rational map to
`Y`; in particular `Y` is not weakly `G`-versal and not `G`-unirational.

A practical quotient/MRC corollary is: it suffices that each relevant
component `F` of `Y^sigma` admits an `N`-equivariant morphism to a variety
with no positive-dimensional RCC subvarieties, and that the residual group
has no fixed point on the base.

The proof uses the controlled eigenspace-survivor induction already sealed
in `theory/FIX_IX_v14.md`, not the withdrawn claim that arbitrary
higher-dimensional fixed networks propagate as RCC objects.

## Literature verdicts

- **Degree 1:** the Bertini-central route is blocked because the unique
  anticanonical base point is fixed by the whole automorphism group. No new
  degree-one theorem was obtained.
- **Degree 2:** Problem F is not isolated as a negative phenomenon. The
  Fermat `C_2 x S_3` action gives another exact theorem, but by the central
  mechanism rather than an exceptional path. No second genuinely
  path-dependent action was verified.
- **Conic-bundle surfaces:** yes, Condition (A) is insufficient. The
  `S_m` family gives explicit rational examples with all higher Amitsur
  invariants silent.
- **Conic-bundle threefolds:** yes, a central fiber involution naturally
  produces a fixed discriminant double cover. The product family `X_m`
  demonstrates the residual-MRC form when the fixed surface contains
  rational curves.
- **Fano conic bundles:** general Mori--Mukai No. 2.18 is already
  linearizable for its full automorphism group. More decisively, the deck
  fixed surface of every smooth `(2,2)` model is a degree-two del Pezzo
  surface, hence itself rationally connected and residual-stable. Thus the
  deck involution cannot satisfy Theorem G1 even on special members; a new
  incidence or exceptional-network argument would be required.
- **Kummer double solids:** the most tempting Condition-(A)-passing cases
  containing `Q_8` are already killed by `Am^3`. In the remaining groups,
  the unresolved issue is classification of residual-stable rational
  curves on the Kummer K3 resolution. No cohomology-silent Kummer action
  was closed.
- **Burkhardt quartic:** two natural centralizer tests fail. A coordinate
  transposition centralizer fixes an eigenpoint on the quartic; for the
  open `C_3 rtimes C_4` linearizability action, the central involution fixes
  a three-nodal rational plane quartic, so the RCC criterion fails.
- **Index-one Fanos:** the product `P^1 x S_F` is a new exact example.
  No second natural prime Picard-rank-one example comparable to `V_14` was
  found. The Burkhardt audit explains one important failure.

## Literature-status discipline

For the two theorem families, the status before this packet is recorded as

`LITERATURE-STATUS-UNCERTAIN; NO PRIOR VERDICT LOCATED; CLOSED-HERE`.

The broad degree-two gap is explicitly stated in the current CTZ paper,
and the current cohomological classification does not decide the
`C_2 x S_3` Fermat action. The conic-bundle literature classifies the
birational actions and their positive-genus fixed curves, but the search
found no prior weak-versality or equivariant-unirationality verdict for the
specific odd-dihedral actions. This packet does not assert a historical
priority claim beyond that checked boundary.

## Validation

Run:

```text
python3 verify_dihedral_dejonquieres.py
python3 verify_fermat_dp2_s3.py
python3 verify_burkhardt_nearmiss.py
```

Expected markers:

```text
DIHEDRAL_DEJONQUIERES_AUDIT_OK
FERMAT_DP2_S3_AUDIT_OK
BURKHARDT_NEARMISS_AUDIT_OK
```
