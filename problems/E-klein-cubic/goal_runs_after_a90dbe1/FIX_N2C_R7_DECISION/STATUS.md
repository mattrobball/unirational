# Status — FIX-N2C, the `(1,7)` decision

**Primary exit:** `FIX-N2C-M1-R7-POPULATED`

**Problem E headline: OPEN.**

Packet: `goal_runs_after_a90dbe1/FIX_N2C_R7_DECISION/`.
Predecessor: `goal_runs_after_fa02f05/FIX_N2B_M1_ROW/` (§2.7, the alarm).
Frame: `theory/FIX_II_jets.md` §4.

---

## 0. The verdict in one line

The `r = 7` cone **does** contain plane-order-1 points in characteristic zero.
The `(1,7)` cell is **POPULATED already at line degree 0**, by an explicit,
exactly verified, *primitive* family; FIX-N2B's `r = 7` alarm was real, and the
conjecture `FIX-N2B-STABILISATION` is **FALSE**.

---

## 1. The witness

Ground field `K = QQ(om, kp)`, `om^2+om+1 = 0`, `8kp^2-13kp-4 = 0`,
`kp = kp+ = (13 + 3 sqrt 33)/16` (the packet's sign convention).  Write

```
kap := kp + 2        ( = B^3 + B^-3 , since (B^3-1)^2/B^3 = kp )
dl  := 2 om + 1 = om - om^2 ,    dl^2 = -3
```

Adjoin two elements, each of degree 3 over `K` — **two Chebyshev cubics**:

```
c^3 - 3 c   =  kap                  so  c = z + 1/z  with  z^3 = B^3, i.e.
                                    c in { B + B^-1 , om B + om^2 B^-1 , om^2 B + om B^-1 }
v^3 - 3 v   = -27/(4 kap) ,   P1 := 2 om / v
                                    equivalently  27 P1^3 - 24 om kap P1^2 + 32 kap = 0
```

Then, in the normalisation `P0 = 1`, the `lam = 1` eigenblock coordinates of the
`(m,r) = (1,7)` cell are

```
P0 = 1                                   B2 =  dl c                B4 = -dl c
P1 = P1                                  B5 =  om (P1 c + 2)/2     B1 = -B5
R0 =  om^2 P1 c / 2                      B0 = -(P1 c - 2om - 2)/2  B8 = -B0
R1 = -om P1                              B3 = -om^2 P1 c - 2       ( = -(B6+B7) )
B6 = ( om^2 P1 c + 2(om-1) P1 + 2 )/2    B7 = ( om^2 P1 c - 2(om-1) P1 + 2 )/2
```

(`B5` = coefficient of `x y^6` in `u_0'`, `B8` = coefficient of `x z^6` — the two
plane-order-1 parameters of the cell.)  The nine `(c, P1)` pairs give **nine**
points, which is exactly the degree of the locus.

The tuple itself, `T = (a', b', u_0', u_1', u_2')`, is printed in full in
`payloads/PAYLOAD_witness.txt`.  Its `a'`- and `b'`-parts are

```
a' = xyz [ (x^4-y^4) + om(z^4-y^4) + P1( (x^2y^2-y^2z^2) + om(x^2z^2-y^2z^2) ) ]
b' = -(P1/2) xyz [ c( (x^4-y^4) + om(x^4-z^4) ) + 2( (x^2z^2-y^2z^2) + om(x^2y^2-y^2z^2) ) ]
```

**Verified exactly, in characteristic zero** (`witness.py`; everything reduced
modulo the Groebner basis `{c^3-3c-kap, 27P1^3-24 om kap P1^2+32kap, om^2+om+1,
8kp^2-13kp-4}`, whose leading monomials `c^3, P1^3, om^2, kp^2` are pairwise
coprime):

| property | status |
|---|---|
| `F(T) = 0` — all **52** coefficient equations of the raw Klein normal form | **exact, 0 nonzero remainders** |
| `F(T)` vanishes as a polynomial identity in `x,y,z` (second, independent path) | **exact** |
| residual `C_3`: `psi(T) = g(T)`, scalar `lam = 1` | **exact** |
| triple-line order | `r = 7` **exactly** |
| plane orders `(ord_{P_1}, ord_{P_2}, ord_{P_3})` | **`(1, 1, 1)`** — so `m = 1` exactly, *on every plane* |
| `a' != 0` **and** `b' != 0` | yes — **outside the `D_B` class and its mirror** |
| `gcd(a', b', u_0', u_1', u_2')` | `1` — **primitive** |
| line degree | `0` (pointwise tuple) |
| `q^k T` lands with `m = 1`, `r = 7+2k` (Cor. N2C-2), `k = 1,2` | **exact** |

By FIX-N2B's own Lemma 2.3 / §2.7, a `C_3`-equivariant pointwise tuple with
`F(T) = 0` **is** an `A_4`-equivariant landing family of line degree `0`.

> **Theorem N2C-1.**  `(m,r) = (1,7)` is POPULATED at line degree `0`.
> The plane-order-1 locus of the `r = 7`, `lam = 1` cone is a reduced
> `0`-dimensional scheme of **degree 9** over `K`, cut out — after the nine
> linear relations of §3 — by the two Chebyshev cubics above.

> **Theorem N2C-1'** (all three eigenblocks, uniformly).  The same holds for
> `lam = om` and `lam = om^2`, with the *same shape*.  Writing `lam = om^j`
> (`j = 0, 1, 2`), the exact ideal of the plane-order-1 locus in the
> normalisation `P0 = 1` is, in every case,
> ```
> B2^3 + 9 om^j B2 + 3 dl kap  = 0
> P1^3 - (8/9) om^(j+1) kap P1^2 + (32/27) kap = 0
> B5   = om + ((om+2)/6) B2 P1
> ```
> — two cubics in separate variables plus one linear equation, hence exactly
> `3 x 3 = 9` points in each block.  Macaulay2 over `K` gives `1 % I != 0`,
> `dim 0`, `degree 9` for all three, and `1 % (I + (B5)) = 0`, so `B5 != 0` at
> every one of the 27 points — plane order exactly `1` throughout.  Setting
> `B2 = dl om^(-j) c` turns the first cubic into the same Chebyshev equation
> `c^3 - 3c = kap` in every block.  The witnesses are built and verified exactly
> by `witness.py`, `witness_om.py`, `witness_om2.py`: `F(T) = 0` on all 52
> equations, `psi(T) = lam g(T)`, `r = 7`,
> `(ord_{P_1},ord_{P_2},ord_{P_3}) = (1,1,1)`, `a', b' != 0`.  So FIX-N2B's
> `lam = 1` and `lam = om` alarms were both real, and `lam = om^2` — which
> FIX-N2B never reached — is populated as well.

> **Corollary N2C-2.**  `q := x^2+y^2+z^2` is `A_4`-invariant with
> `ord_{P_i} q = 0` for all `i`, so `q^k T` is again an `A_4`-equivariant
> landing family with `m = 1` and `r = 7 + 2k`.  **`(1, r)` is POPULATED for
> every odd `r >= 7`.**  (`(1,6)` and `(1,8)` are not reached this way: there is
> no `A_4`-invariant of degree `1`, and the degree-`3` invariant `xyz` has
> `ord_{P_i} = 2`.)

---

## 2. Why the earlier packet could not close it, and what actually decided it

FIX-N2B's `r = 7` runs were correct; what was missing was a way into
characteristic zero.  The route that worked:

1. **Reproduce** the modular finding to an *explicit point*.  `msolve -P 1` on
   the packet's own `B5 = 1` system over `F_100057` (1210 s) returns a rational
   parametrization; decoding it and re-substituting into the 18 cubics gives
   **nine explicit `F_100057` points** (`payloads/PAYLOAD_modular_points.txt`).
2. **Read the structure off the points.**  The nine points span only a
   **3-dimensional** affine subspace: nine independent affine relations, with
   visibly exact coefficients in `ZZ[om]` (§3).
3. **Substitute those relations into the EXACT system over `K`.**  The 52
   equations collapse to **10 cubics in the four homogeneous parameters
   `(B5, P0, P1, B2)`** — small enough to settle exactly.  Macaulay2 over
   `toField(QQ[om,kp]/(om^2+om+1, 8kp^2-13kp-4))`: `1 % I != 0`,
   `dim = 0`, `degree = 9`; the lex basis is in shape position and gives the two
   Chebyshev cubics.
4. **Verify the resulting point exactly against the ORIGINAL 52 equations** —
   which is a proof, and is independent of whether step 2's relations were
   guessed correctly.

The logic matters: step 2 only *restricts*, so a solution found after it is a
genuine cone point.  The modular data was used purely as a search device.

### Independent confirmations of the verdict

| confirmation | engine / method | result |
|---|---|---|
| exact identity `F(T) = 0` over `K(c, P1)` | sympy, from the **raw Klein normal form** via `indep_r7.py` (no FIX-N2B code) | 0/52 nonzero |
| char-0 non-emptiness of the reduced locus | **Macaulay2** over the exact degree-4 number field | `dim 0, degree 9` |
| char-0 non-emptiness of the reduced locus | **msolve over QQ** with `om, kp` as variables + minimal polynomials | `dim 0, degree 36 = 4 x 9` |
| numerical | **mpmath, 40 dps**, `kp+ = (13+3 sqrt 33)/16`, 9 points x 5 random `(x,y,z)` | max rel. `|F(T)| = 9e-40` |
| modular, three split primes | msolve `-g 1` at `p = 100057, 100153, 1048609` | **identical** 20-element staircase, `dim 0`, `degree 10`, at all three |
| positive control | FIX-N2B's `(2,7)` witness `e_2 D_B(x)` in this packet's independently rebuilt equations | all 52 vanish; `m = 2` |
| engine cross-check | this packet's sympy build vs FIX-N2B's `n2b_lib`, all three `lam` | 52 = 52 equations, **0 mismatches** |

---

## 3. The nine linear relations (now theorems, since the witness satisfies them)

On the plane-order-1 component of the `r = 7`, `lam = 1` cone:

```
R0 =  om B5 - om^2 P0                B1 = -B5
R1 = -om P1                          B3 = -2 om B5 - (2om+4) P0   ( = 2(B5+B8) = -(B6+B7) )
B0 = -om^2 B5 - (om^2-1) P0          B4 = -B2
B6 =  om B5 - (om^2-1) P0 - (om^2+2) P1
B7 =  om B5 - (om^2-1) P0 - (om-1)  P1
B8 =  om^2 B5 + (om^2-1) P0          ( = -B0 )
```

Equivalently `om^2 P0 + om R0 = B8` and `om P0 + om^2 R0 = B5`, which turns
FIX-N2B's two sparsest equations

```
B5 (om^2 P0 B5 + om R0 B5 + B1 B8) = 0 ,   B8 (om P0 B8 + om^2 R0 B8 + B0 B5) = 0
```

into `B5 B8 (B5 + B1) = 0` and `B5 B8 (B8 + B0) = 0` — i.e. `B1 = -B5`,
`B0 = -B8`, which is what the machine found.  (These two equations are exactly
the level-4 leading equations of `F(T)` in the `P_2`-adic — and, equally, the
`P_1`-adic — grading; the odd levels are vacuous by the parity of §2.6 there.)

---

## 4. A toolchain landmine found on the way (important)

**msolve 0.10.1 silently mis-parses parenthesised coefficient expressions.**
It accepts them, exits 0, and returns the Groebner basis of a *different*
ideal — it can even report the unit ideal for a consistent system.  Details and
minimal reproductions in `MSOLVE_PARSER.md`.

* FIX-N2B's **`ff`-mode** runs are unaffected (bare integer coefficients), so
  its `r = 7` alarm stands, and so does its textual `B5 -> 1` substitution.
* FIX-N2B's **`qq`-mode** msolve path (`produce_gb.build`, `mode != 'ff'`) emits
  `((1)*om)*R0*B5^2` and is therefore **wrong**.  No FIX-N2B verdict rests on
  it, but it must not be reused.
* Every msolve input in this packet is fully expanded and parenthesis-free;
  `verify_n2c.py` step 3 asserts this and cross-checks the two emitters.

Had this not been caught, this packet's first char-0 run would have reported
`[-1]` (empty) in 0.09 s and produced exactly the wrong verdict.

---

## 5. Consequence for the conjecture and the `m = 1` row

**`FIX-N2B-STABILISATION` is refuted.**  The conjecture asserts that every
nonzero `A_4`-equivariant simultaneous landing family along the `V4` triple line
is `G · D_B(X)` or its `a' <-> b'` mirror with `G` an `A_4`-invariant and `X` of
`V4`-character `chi_1`; since `ord_{P_i}` of an invariant is even and
`m(D_B(X)) in {0} u [3,oo)`, it implies `m != 1` always, hence that the whole
`m = 1` row is EMPTY.  The witness of §1 is an `A_4`-equivariant landing family
of triple-line order `7`, line degree `0`, with `m = 1` exactly on all three
planes, `a' != 0` **and** `b' != 0`, and unit gcd — so it is neither
`G · D_B(X)` nor its mirror, and it is primitive (not an invariant multiple of
anything of lower order).  Consequently the `m = 1` row is **not** empty:
`(1,7)` is POPULATED at line degree `0`, and with `q^k` so is `(1, r)` for every
odd `r >= 7`.  What survives of FIX-N2B is exactly its proved part — `(1,r)`
EMPTY for `r <= 5`, and `(1,6)` empty at line degrees `0,1,2` — together with
the parity lemma §2.6, whose "balanced" case `G_0+G_1+G_2 = min(A,Bo)+2` is
precisely the case this witness realises: at `P_1` the witness has
`A = ord(a') = 2`, `Bo = ord(b') = 2`, `G_0 = 2`, `G_1 = G_2 = 1`, so
`G_0+G_1+G_2 = 4 = min(A,Bo)+2`.  That lemma is therefore **sharp**, not wrong:
its two settled branches genuinely exclude `m = 1`, and the one case it left
open is exactly where the family lives.  For Note III's
stalk list this is the outcome flagged in `theory/FIX_II_jets.md` §4 as
"alarm confirmed": packet-§6 exclusion (i) does **not** close, and the cosheaf
`T` acquires at the `V4`-stratum a **genuinely primitive `m = 1` branch** — a
`0`-dimensional stalk of degree `9` over `K`, defined by the two Chebyshev
cubics `c^3-3c = kap` and `v^3-3v = -27/(4 kap)`, that no
invariant-multiplication construction from the `D_B` seeds predicts, plus its
`q^k`-translates at every odd `r >= 7`.  **Nothing here bears on the Problem E
headline, which stays OPEN** (Note II §5 / the T5 gate: population of a cell is
a local statement).

---

## 6. Not decided here

* The naive Galois transport `om -> om^2` of the `lam = om` witness does **not**
  land in the `lam = om^2` block (46/52 equations survive in the best of four
  variants, `logs/TRY_OM2.log`); each block needed its own run of the §2
  pipeline.  All three are now done.
* A bookkeeping bug in the predecessor, found while reproducing: FIX-N2B's
  `lam = om`, `B8` verdict `CAN-BE-NONZERO (64 s)` is **spurious** —
  `msolve/po1d_r7_om_ff_B8.out` is a **0-byte file**, and
  `produce_gb.is_unit_ideal('')` returns `False`, so an empty or aborted msolve
  run is silently reported as `CAN-BE-NONZERO`.  (Its `lam = om`, `B5` verdict
  at 895 s is genuine, and is now confirmed in characteristic zero.)
* `(1,6)` at line degree `>= 3`, and `(1,8)`.
* Whether the nine points form one Galois orbit, and the geometry of the
  corresponding `A_4`-equivariant map `P^2 --> S`.
* Long char-0 runs on the **un-reduced** 12-variable system (Macaulay2 over `K`,
  msolve over `QQ`) were still running at close; they are strictly redundant —
  the exact witness settles the question — and their logs are kept.

---

## 7. Replay

See `REPLAY.md`.  Terminal line of the verifier:
`FIX_N2C_R7_DECISION_VERIFY_OK`.
