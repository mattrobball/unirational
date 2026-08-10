# Duncan fabulous corners for `P(W) ⇢ X` — status

Problem E remains **OPEN**.

Packet: `goal_runs_20260810/DUNCAN_CORNER_F2/` · entry [E56] · 2026-08-10.

## Exit ledger

```text
DUNCAN-CORNER-FABULOUS-VERIFIED
DUNCAN-CORNER-INVENTORY-COMPLETE
DUNCAN-F2-EDGE-CONSTRAINT-SEALED
DUNCAN-F2-SURVIVES-T5-TRISECTION
DUNCAN-NO-CLOSURE-AT-I2
```

Machine marker: `DUNCAN_CORNER_F2_VERIFY_OK` (`python3 verifier.py`, ~2 min).

## Per-claim table

| # | Claim | Class | Status | Evidence |
|---|---|---|---|---|
| A | `G = PSL(2,11)`: a fabulous pair forces `G_{D_ij} = V4` and two **distinct commuting** involutions as divisorial stabilizers. PSL(2,11) has exactly 55 non-cyclic abelian subgroups, all Klein four-groups; no element of order 3,5,6,11 lies in one | PROVED (exhaustive, 2 primes) + import `thm:pairs` | **PASS** | `results/w3_corner_inventory.txt` |
| B | Among the classical strata of `P(W)` only `P_σ` and `L'_σ` have isotypic normal bundles, hence only they carry a boundary divisor with `G_D ≠ 1` | PROVED (rep theory + certificates) | **PASS** | `NORMAL_CHARACTERS.md:71–90`; `results/w1_corner_charts.txt` (level 0) |
| C | Any `G`-invariant smooth centre through a general point of `ℓ_V` is `ℓ_V` (the `A4`-3-dim rep is irreducible), so the tower order is forced at T1 and free afterwards | PROVED | **PASS** | `results/w5_w6_line_graph_and_stabs.txt` (`|Stab(ℓ_V)| = 12`) |
| T | The T0→T3 tower is stabilizer-stratified and each centre is smooth (a disjoint `G`-orbit) | COMPUTED (W2, 2 primes) | **PASS** | `results/w2_orbit_disjointness.txt` |
| 1 | **The corner `D_ij = E_s^V ∩ Ẽ_z` exists, `G_{D_ij} = V4`, non-cyclic ⟹ FABULOUS** | COMPUTED, two independent methods | **PASS** | `results/w1_corner_charts.txt` (M2, 45/45, exact `QQ`); `results/toric_corner.txt` (Duncan's own `H_τ` formula, exact `Z`) |
| W1 | **`D_ij` is irreducible, smooth, connected, of codim 2** — a `P¹`-bundle over `C' ≅ ℓ_V ≅ P¹` (Hirzebruch surface). *This was the load-bearing conditional of the prior report; it is now discharged.* | PROVED (bundle argument; all 5 module inputs machine-checked for all 55 `V4`s at 2 primes) + `isPrime`/`codim` in M2 | **PASS** | `results/w1_corner_global.txt`, `results/w1_corner_charts.txt` |
| W2 | `ℓ_V` meet only at the 55 `D12`-points (3 each, all off `X`); plus-planes meet in `ℓ_V` (commuting) or transversally in one `D12`/`D10` point (non-commuting); the 165 `M_τ^V` separate after T2; `ℓ_V ∩ L'_τ = ∅` for all 3025 pairs | COMPUTED (2 primes) | **PASS** | `results/w2_orbit_disjointness.txt` |
| W3 | 22 reachable `V4`-weight states; exactly 3 give codim-2 `V4`-fixed loci, all of shape `(0,0,x,y)`, `x ≠ y` nonzero. Shortest `G`-legal route is `ℓ_V → P̃_z → M̃_s`. 330 corners in **2 `G`-orbits of size 165** | COMPUTED (exhaustive BFS + 2 primes) | **PASS — INVENTORY COMPLETE** | `results/w3_corner_inventory.txt` |
| D | The only rational curves in `X_nt` are the 55 lines `L_σ`; so every connected RCC subset of `X_nt` is a point or a connected union of lines | PROVED (from pinned certificates) | **PASS** | `STRATA_EXACT.md:111,175–182`; `results/w5_line_graph.json` |
| W5 | `L_σ ∩ L_τ ≠ ∅ ⟺ σ,τ commute`; 165 edges, 6-regular, **connected**, diameter 3; every edge point is a type-I point | COMPUTED (2 primes) | **PASS** | `results/w5_line_graph.json` |
| W6 | `Stab(P_σ) = Stab(L'_σ) = D12`; `Stab(ℓ_V) = A4`; `Stab(M_τ^V) = V4`; and `Stab(D_i) ∩ Stab(D_j) = V4` at every fabulous corner | COMPUTED (2 primes) | **PASS** | `results/w5_w6_line_graph_and_stabs.txt` |
| F1 | Any divisor with `G_D = ⟨σ⟩` and `Stab_G(D) = C_G(σ) = D12` has `f(D) = L_σ`, forced (uses `X^{D12} = ∅` + rationality of strata, **not** fabulousness) | PROVED — **re-derivation, not new** | **PASS** | matches sealed `FIX_V_construction.md:16` |
| F2 | **NEW.** `f(E_s^V) ∈ {L_s, [B], [C], [D]}`; the deep `s`-divisor is **never** contracted to a type-II point | PROVED, conditional on the two imports | **SEALED** | proof in `THEOREM.md` §6; turns on `ℓ_V ∩ L'_τ = ∅` (W2.3b) |
| W7 | (F2) tested against the [E33] trisection witness per `FIX_I_bcomplex.md:313–319` / T5 (`FIX_T_gate.md:355–422`): both residual-`C3` eigenpoints of `ℓ_V` lie off `X` (110/110), so `S_κ ∩ ℓ_V = ∅` and the witness never lands on a type-II point | COMPUTED (2 primes) | **SURVIVES** (vacuously — see caveat) | `results/w7_f2_vs_e33_trisection.txt` |
| E | Theorem E (target-side receiver theorem) + **no closure at `\|I\| = 2`**: Escape 1 (`L_z ∩ L_s ≠ ∅` for the commuting pair at every fabulous corner) and Escape 2 (type-II points lie on all three elliptics of their triangle) | PROVED, conditional on imports | **PASS** | §7 of `THEOREM.md` |

## Exact checks

```text
python3 verifier.py            # DUNCAN_CORNER_F2_VERIFY_OK
```

Individually:

```text
python3 scripts/w1_corner_global.py             # W1_CORNER_GLOBAL_OK
M2 --script scripts/w1_corner_charts.m2         # W1_CORNER_CHARTS_OK   (45/45)
python3 scripts/toric_corner.py                 # TORIC_CORNER_OK
python3 scripts/w2_orbit_disjointness.py        # W2_ORBIT_DISJOINTNESS_OK
python3 scripts/w3_corner_inventory.py          # W3_CORNER_INVENTORY_OK
python3 scripts/w5_w6_line_graph_and_stabs.py   # W5_W6_OK
python3 scripts/w7_f2_vs_e33_trisection.py      # W7_F2_VS_E33_SURVIVES
```

All group/geometry work runs at **two** split primes, 331 and 661; the M2 part
is exact over `QQ`; the toric part is exact over `Z`. W4 was skipped by
instruction (target facts pinned to the existing certificates).

## Not proved here

1. **The two EXTERNAL-UNVERIFIED imports.** `thm:pairs` (pairs-iff) and
   `prop:rcc_total` (total RCC) are graded by `NOTEBOOK.md:4660–4670` as
   *"import candidates pending our own proof review"*. Every exit in this packet
   is conditional on them. If `thm:pairs` falls, the "fabulous" verdict of claim
   1 falls; if `prop:rcc_total`/`prop:rcc` falls, (F2) and Theorem E fall, while
   Propositions A/B/C/D, the tower, W1–W3, W5–W6 and (F1) stand.
2. **T4**, the remainder of the toroidal resolution away from the corner, is
   asserted (with a local toroidality check, following Duncan lines 1330–1334,
   1361) to be an isomorphism near the corners; the global bookkeeping for the
   rest of `P(W)` is not carried out.
3. **Practical bite of (F2)**: W7 shows it is not refuted, but the witness never
   populates the stratum (F2) constrains, so the survival is vacuous.
4. The 165 type-II points are taken from the sealed char-0 certificate; only
   `disc(F|_{ℓ_V}) ≠ 0` mod `p` is re-verified here.

## Boundary in one line

The mechanism is real and now runs: `P(W)` acquires genuine fabulous corners
three blowups deep, and they yield one new landing constraint. But every
fabulous corner in a `PSL(2,11)`-variety pairs two **commuting** involutions,
and for commuting involutions the two target lines `L_z, L_s` **meet** — so the
chain Duncan's theorem demands always exists. The mechanism cannot produce a
contradiction against the Klein cubic at `|I| = 2`.
