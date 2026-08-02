# PC.3 degree-25 multiplier audit at the authoritative fibre

## Verdict

The abstract characteristic-zero multiplier circuit from
`PC3_P25_MULTIPLIER_MAPS.md` is sound, but its frozen source Cramer chart is
not integral at the authoritative PC.2 fibre.  Over `F_89`, its rows
`0,...,15` and columns

```text
0,1,2,3,4,5,6,7,14,15,16,17,18,19,20,35
```

have rank `15` and determinant `0`.  Consequently the previously stored
`p=419,463` inclusions cannot simply be reduced and applied to the PC.2
special-fibre coordinates.

The verifier repairs this ambient-coordinate defect.  Deterministic
left-to-right row and column profiles select rows

```text
0,1,2,3,4,5,6,7,8,9,10,11,13,14,15,16
```

and columns

```text
0,1,2,3,4,5,6,8,14,15,16,17,18,19,20,35.
```

Their determinant is `74 mod 89`.  The resulting `59 x 43` Cramer inclusion
has rank `43`, is annihilated by the complete rank-`16` order-two map, and
spans the same evaluated strict space as the accepted DVR monic basis.

## Authoritative coordinates and maps

The replay reconstructs the accepted `Q(37)|K(6)` frame from the sealed
degree-25 change-of-basis packet.  It builds and verifies the coordinate
change from the repaired Cramer basis to that frame, then multiplies by the
installed invariants.

| target degree | target dimension | map shape | rank | 400-row residual | map SHA-256 |
|---:|---:|---:|---:|---:|---|
| 31 | 198 | `198 x 43` | 43 | 0 | `dbbf7046c34e634b013bdec02f6b1d32b5ef1e3e8142e9ab540b63a3d4babbc7` |
| 35 | 361 | `361 x 43` | 43 | 0 | `0b5e5a72503f49d890f97047577ba8cf7d77eb1f17c2f1d6d05f167d40b2a55b` |

Thus the ambient `p=89` maps are now executable in the same coefficient frame
used by PC.2.  The exact chart, coordinate-change, and map hashes are recorded
in `verify_pc3_p25_multiplier_p89_result.json`; the verifier reconstructs the
matrices from the pinned Reynolds, cross-circuit, DVR, and invariant inputs.

## Scope boundary

This repairs only the ambient linear multiplication maps.  The authoritative
nonlinear PC.2 landing scheme is still undecided, and its equations or points
have not been substituted through these maps.  Therefore no actual
degree-31/35 scheme image, factor/composition-incidence saturation, survivor,
degree-wide emptiness statement, or characteristic-zero point follows.
`PC-UNDECIDED` remains required.

## Replay

```bash
python3 -B -u P25_COV_SUPPORT/verify_pc3_p25_multiplier_p89.py
```

The terminal marker is

```text
PASS_PC3_P25_MULTIPLIER_P89_AMBIENT_REPAIR
```
