# PC.3 fixed degree-25 multiplier maps

## Result

The fixed 59-circuit basis of `K1_25` has been connected to the installed
strict 43-space by a frozen `59 x 43` Cramer inclusion.  Multiplication by
the installed invariants `f6` and `f10` has then been expressed in the fixed
degree-31 and degree-35 cross-circuit bases, giving `198 x 43` and `361 x 43`
coordinate maps.

The producer materializes the maps at the two good split primes `419` and
`463`.  The independent verifier rebuilds all four maps from the upstream
Reynolds/cross circuits and separately checks that the fixed source and its
43-space agree with the installed 189-Reynolds arrangement and strict models.

| prime | `rank(K1_25)` | order-two rank | strict rank | `rank(f6)` | `rank(f10)` |
|---:|---:|---:|---:|---:|---:|
| 419 | 59 | 16 | 43 | 43 | 43 |
| 463 | 59 | 16 | 43 | 43 | 43 |

For every target and both primes, the reconstructed target-coordinate map
agrees with the multiplied covariant on all `80 x 5 = 400` evaluation rows.
At `p=463`, both maps also agree entry by entry with the previously installed
59-column multiplier embedding composed with the new `59 x 43` inclusion.

## Authoritative `p=89` chart repair

The frozen characteristic-zero Cramer chart used above is not integral at
the authoritative PC.2 fibre: its selected `16 x 16` minor has rank 15 and
determinant zero modulo 89.  Thus the stored 419/463 arrays cannot simply be
reduced into PC.2 coordinates.

`verify_pc3_p25_multiplier_p89.py` deterministically selects a different
unit chart at `p=89`, with determinant 74.  It identifies the resulting
rank-43 space with the accepted DVR monic basis and the authoritative
`Q(37)|K(6)` frame, then reconstructs maps of shapes `198 x 43` and
`361 x 43`.  Both have rank 43 and zero residual on all 400 evaluation rows.
This makes the ambient maps executable at the PC.2 fibre; see
`PC3_P25_MULTIPLIER_P89_AUDIT.md`.

## Frozen exact circuit

The old helper selected the second commuting involution by the lexicographic
bytes of its reduction.  That rule is prime-dependent.  This packet instead
freezes group index `609`, whose exact `PSL_2(F_11)` key is `(4,8,2,7)`.

Let `J` be the `72 x 59` common-line order-two evaluation circuit in the
fixed cross basis.  Freeze rows `0,...,15` and pivot columns

```text
0,1,2,3,4,5,6,7,14,15,16,17,18,19,20,35.
```

Writing these columns as `P` and the remaining 43 columns as `F`, the source
inclusion is the Cramer circuit

```text
N[F,:] = I_43,
N[P,:] = -J[0:16,P]^{-1} J[0:16,F].
```

For target evaluation matrices `D31,D35`, their installed fixed maximal-minor
rows `R31,R35`, and the fixed source evaluation matrix `L25`, the maps are

```text
F31 = D31[R31]^{-1} (f6  * L25 * N)[R31],
F35 = D35[R35]^{-1} (f10 * L25 * N)[R35].
```

The nonzero good-fibre minors certify that these exact Cramer denominators are
nonzero over `Q(zeta_11)`.  Multiplication by the nonzero invariants has exact
rank 43 on the exact 43-space.

## Scope boundary

The `.npz` file contains the 419/463 reductions, not reconstructed entries in
`Q(zeta_11)`.  The exact arithmetic circuits are fixed and replayable, but an
entrywise characteristic-zero expansion remains open.  The separate `p=89`
verifier recomputes its repaired maps rather than storing them as additional
arrays.  These specializations are not being relabelled as an entrywise
cyclotomic expansion.

These are linear maps on the full strict 43-space.  They do not decide the
authoritative nonlinear PC.2 landing scheme inside that space.  Consequently,
the actual degree-31 and degree-35 images of the PC.2 landing scheme remain
dependent on the PC.2 output.

## Replay

```bash
python3 P25_COV_SUPPORT/produce_pc3_p25_multiplier_maps.py
python3 P25_COV_SUPPORT/verify_pc3_p25_multiplier_maps.py
python3 P25_COV_SUPPORT/verify_pc3_p25_multiplier_p89.py
```

The verifier must end with

```text
PC3_P25_MULTIPLIER_MAPS_VERIFIED
PASS_PC3_P25_MULTIPLIER_P89_AMBIENT_REPAIR
```

Artifacts:

- `pc3_p25_multiplier_maps.json`: circuit recipe, input hashes, and rank ledger;
- `pc3_p25_multiplier_maps.npz`: modular inclusions and multiplier maps;
- `verify_pc3_p25_multiplier_maps_result.json`: independent replay result.
- `verify_pc3_p25_multiplier_p89_result.json`: authoritative-fibre repair
  ledger and matrix hashes.
