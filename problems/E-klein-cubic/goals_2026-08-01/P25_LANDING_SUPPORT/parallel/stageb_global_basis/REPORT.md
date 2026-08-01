# Stage-B full-global-basis audit

## Outcome

The complete `10,767`-column degree-one FFLAS syzygy basis was recomputed and
globally analyzed.  It yields a new support-balanced r43 contraction packet
which is materially smaller than the current r43 and retains exact rank six
on every one of the 666 q-coordinate lines.

This work does **not** decide Stage B or Stage C.  The exact module and
saturation jobs have been generated but not launched because the shared
Singular PID 13036 remains live.  No degree-25 or headline verdict follows.

## 1. Complete degree-one syzygy basis

Over `F_89`, the reconstructed coefficient matrix for

```text
C(q) M2(q) = 0
```

has exact shape `14763 x 25530`, FFLAS rank `14763`, and nullity `10767`.
The full nullspace call took `38.812342` seconds (`44.844213` seconds for the
complete producer).  Its coefficient hash is the established

```text
d813f7b59057c939577faa0f22184b9fa9cce8a7d63af9c321514be9437b3f8f
```

and the sealed relation input is

```text
relation_matrix.npz
sha256 6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb
```

The complete basis artifact is:

```text
full_linear_syzygy_basis.npy
shape                 10767 x 690 x 37
file sha256           3571e9879bf1af6d6a405d9761522d4253e76e40edd129afd4b9363287d60ca3
canonical data sha256 3902a305ce766165d584853764e61db39e457d0f0f11c9289e5d3df0340c5530
```

This 262-MiB array and the 563-MiB full P3 array below are reproducible local
artifacts and are ignored for GitHub's per-file limit.  Their exact hashes are
bound in the manifests and `SEAL.json`; the small selected Stage-B/Stage-C
packets remain portable.

The producer and replay check a systematic `10767 x 10767` identity minor,
so the stored columns are exactly independent.  Global exact sparsity is:

```text
syzygy nnz min / median / max     994 / 3715 / 5084
mean syzygy nnz                   3517.403919...
columns using all 37 q directions 21
columns using q4                  669
columns using q5                  669
```

The per-column nnz, q-support masks, support histogram, and all coordinate P3
evaluations are in `global_basis_statistics.npz`, SHA-256
`c6d5d276b91494e620d729b34ba46d3c9a0210e872b4064e79b07bf01c2d419e`.

## 2. Complete P3 contraction tensor

All basis columns were contracted against the six sealed M1 blocks in 37
modular-double GEMMs.  Exactness is elementary because every unreduced dot
product is bounded by

```text
690 * 88 * 88 = 5,343,360 < 2^53.
```

The disk-backed result took `61.363748` seconds:

```text
full_p3_contractions.npy
shape                 10767 x 6 x 9139
file sha256           93eb010020c7b808039243cd64aede54677c95f74c17efe8e3abb03c5dbf2019
canonical data sha256 9d416db54e9eb10d46fdfbb2bffe2d3c10a83529ad923f0092105f71407ecc9f
```

Global P3 row nnz has minimum `32498`, median `53256`, maximum `54293`, and
mean `51057.453608...`.

## 3. Degree-three leading-term shortcut is impossible

The suggested degree-three LT-cover test was performed in a stronger,
order-independent form.  Delete the 222 pure-cube module coordinates

```text
q_i^3 e_j,  0 <= i <= 36, 0 <= j <= 5.
```

The deterministic component-major `10767 x 10767` minor of the remaining
columns has exact FFLAS rank `10767`; its uint8 coefficient hash is

```text
d84ecf7c699f4338e9f2b5cb3a4b17b5052da21837fc134d174fbfc33071abc0
```

Thus projection of the full degree-three row space `N_3` to the non-pure
coordinates is injective, and `N_3` contains no nonzero vector supported on
pure cubes.

Every admissible module term order has an absolute least degree-three term
`q_min^3 e_min`.  Covering `q_min^5 e_min` requires that exact divisor in
`in(N_3)`.  Since it is already the absolute least term, a row-space element
with that leading term would have to be the pure vector itself, which the
minor excludes.  Therefore **no degree-three leading-term cover can prove
degree-five surjectivity**, for any admissible module order.

This does not decide the full degree-five Macaulay map; higher-degree row
combinations may still make it surjective.  It also does not exhibit a Stage-B
point.  The compact profile artifact is `lt_cover_nonpure_minor.npz`, SHA-256
`f7da4f4237290d046976cb5ac9df62aa1888db17f5d657c1cb0e614cb8f9db12`.

## 4. New support-balanced r43

Selection used actual global P3 term counts, not syzygy nnz as a proxy.  Five
weighted exact-rank covers and an eight-row structured cover were followed by
deterministic one-row exchange descent.  The final packet is:

```text
support_balanced_r43_stageB.npz
sha256 f1aea8369fd56d5139b3d1f1574a194e2016c7d306006fb1aae37f0223d5fd3a
```

It has:

```text
rows                                  43
P3 terms                       1,571,280
syzygy nnz                        74,294
degree-three row rank                 43
each of six component ranks           43
rank P3(e_i), every i                   6
q coefficient support             all 37
```

Compared with the current support-cover r43:

```text
                              old r43     new r43       saving
P3 terms                    1,880,133    1,571,280      308,853 (16.43%)
syzygy nnz                    107,299       74,294       33,005 (30.76%)
```

The old packet hash is
`89a6d9feab7d08cdbd6b9ba68853fc7a7d041d2057c1c51982aa3c7ad42b7779`.

### Coordinate-line guard

For every line `P<e_i,e_j>`, the new `43 x 6` cubic matrix was restricted to
`e_i+t e_j`.  Maximal minors have degree at most 18.  Each stored determinant
was interpolated from 19 exact values and checked at a twentieth value; two to
four minors have gcd one:

```text
661 lines need 2 minors
  4 lines need 3 minors
  1 line  needs 4 minors
```

Therefore the new matrix has rank six at every geometric point of all 666
coordinate lines.  This excludes every contraction point with q-support at
most two; it says nothing global about support at least three.  The certificate
is `support_balanced_coordinate_line_minors.npz`, SHA-256
`3767ad02158ea4c8592661c832083ddf27cc3539b9a35c28db1911caad1dc2c5`,
and its independent replay result has SHA-256
`9dd9ae33a4e8157a6da059596a49248056db9432ffcc38ea45d39c0ead557f59`.

## 5. Selected P4 and direct replay

The same 43 syzygies were contracted against the scalar M0 block.  The
combined Stage-B/Stage-C packet is:

```text
support_balanced_r43_stageBC.npz
sha256 821e1340cd6242a1d89a3a59f89d6d0fbee7fa1b4207e931b28d4c402f5fbedb
P3 terms 1,571,280
P4 terms 2,936,758
```

`verify_sparse_packet.py` independently:

1. replays the full systematic basis minor and all global support/nnz arrays;
2. checks all 43 selected identities `C(q)M2(q)=0` directly;
3. rebuilds all 43-by-6 P3 cubics coefficient-by-coefficient;
4. rebuilds all 43 P4 quartics coefficient-by-coefficient;
5. rechecks the row, component, coordinate, and support ranks.

It ends:

```text
PASS: full-basis packet and direct contractions replayed
```

## 6. Exact Stage-B and Stage-C jobs

The following exact Singular 4.4.1 inputs are generated and hash-bound:

```text
support_balanced_r43_stageB_module.sing
bytes 21,643,276
sha256 80d8a15a5cc20a5ae73e46f776a9b9bfbc106b908a9bcc6e4a1b8060bd8dbd76
criterion dim(S^6/N)=0

support_balanced_r43_stageB_saturation.sing
bytes 21,645,344
sha256 43265bdbf49a2427171da9a6fb9c4e06cd7254a09733bbee6eedba881b120be8
equations P3(q)b1
saturation b1 irrelevant ideal, then q irrelevant ideal

support_balanced_r43_stageC_saturation.sing
bytes 72,310,322
sha256 3c1eab8bdbb97420a488ca725794316eb8055345be5095e92021f70bebe8d4ba
normalization b0=1
equations P4(q)+P3(q)b1
saturation q irrelevant ideal
```

`stageb_cas_jobs.json` binds the inputs, the coordinate-line guard, and the
existing hard-fence runner with suggested limits `7200 s / 32 GiB`.  None of
these jobs was launched while PID 13036 remained live.  Only a completed
decisive module or unit-saturation output has theorem content.  A timeout,
nonunit, crash, or missing result does not produce a candidate or verdict.

## Replay

From this directory:

```text
/opt/homebrew/bin/python3 -u verify_lt_cover.py
/opt/homebrew/bin/python3 -u verify_sparse_packet.py
/opt/homebrew/bin/python3 -u verify_coordinate_lines.py
```

The three completed markers are:

```text
PASS: replayed order-independent degree-three LT-cover obstruction
PASS: full-basis packet and direct contractions replayed
PASS: replayed all 666 new-r43 coordinate-line certificates
```

Fresh producers, in dependency order, are:

```text
/opt/homebrew/bin/python3 -u produce_full_basis.py
/opt/homebrew/bin/python3 -u contract_full_p3.py
/opt/homebrew/bin/python3 -u analyze_lt_cover.py
/opt/homebrew/bin/python3 -u select_sparse_packet.py
/opt/homebrew/bin/python3 -u certify_coordinate_lines.py
/opt/homebrew/bin/python3 -u contract_selected_p4.py
/opt/homebrew/bin/python3 -u produce_stageb_cas.py
```

## Theorem boundary

Proved exactly here:

- the complete FFLAS degree-one syzygy basis and its global support profile;
- the complete P3 contraction tensor;
- impossibility of any degree-three LT-cover certificate;
- a smaller exact r43 P3/P4 contraction packet;
- rank six on all coordinate axes and lines for that packet.

Not proved here:

- surjectivity of the full degree-five Macaulay map;
- unit saturation or projective emptiness in Stage B;
- unit saturation or projective emptiness in Stage C;
- a point of the original 690- or 746-equation landing scheme;
- degree-25 emptiness or a characteristic-zero landing covariant.

The P25 goal and Problem E headline therefore remain open.
