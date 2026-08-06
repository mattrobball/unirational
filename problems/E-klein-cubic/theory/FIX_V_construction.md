# FIX V — The construction program (the constraints turned into a blueprint)

Program FIX ([E56]). Opened 2026-08-06 on the user's goal directive,
superseding the negative-only effort rule: *"This clearly puts
constraints on the possible rational maps giving unirationality. Use
this info as a guide to produce an explicit such map."* Everything the
negative campaign proved now serves as the SIEVE and ANSATZ for
construction. Headline target (sealed reductions, P1): an explicit
`G`-equivariant dominant `T: P(W) ⇢ X` in some degree `d` —
equivalently a nonzero landing covariant — equivalently a
`K_proj`-point of `V(Φ)`.

## 1. The forced profile of ANY map (all sealed/proved)

- multi-order `(r; m,m,m)` at the V4-lines, `m` odd, `r ≥ (3m+1)/2`;
- all 55 plus-planes in the base locus; the σ-datum sweeps `L_σ`;
- line degree `n = d − r ≥ 6(r−m)`, `Λ` vanishing `≥ 2e` at each
  D12-point, jets satisfying H1-1(b,c);
- the classified shapes are DEAD: `h·T₀` (Chebyshev) and
  non-`n₃`-divisible `D_B(f·yz)` fail the equalizer; survivors are
  exactly: (i) the `w = 0` evasion channel (deep D12-vanishing, e.g.
  `n₃ | f` for the `(3,6)` shape), and (ii) the `w ≠ 0` jet-solvable
  locus of FIX-D2 (explicit residual `Θ`-freedom `1,2,4,7…`);
- the covariant ladder ([E25], sealed): NO landing covariant in
  degrees `≤ 24` (char 0); degree 25 has LIVE modular branches over
  `F_67` (order-2 and order-≥4), char-0 transfer never completed.

## 2. The window arithmetic (the sieve)

`d ≥ 7r − 6m` per profile. At `d = 25` the ONLY admissible profile is
`(m, r) = (3, 6)` (`7·6−18 = 24 ≤ 25`; every other `(m, r)` needs
`d ≥ 26`), with `n = 19` and the germ forced into the `(3,6)`
`D_B`-evasion channel. **Open question the sieve must settle first:**
the `(3,6)` family's line-degree dictionary (the `X = f·yz` bookkeeping
and any congruence on `n`) — if a congruence excludes `n = 19`, then
`d = 25` closes by PURE PROFILE ARITHMETIC (a new ladder-closure
theorem, valuable either way) and the window walks up `d = 26, 27, …`
until profile arithmetic and the evasion structure both admit. First
`(1,7)`-window: `d = 43` (the FIX-D2 solvable jets live there).

## 3. The two construction routes

**Route 1 (primary): the guided degree-25 transfer.** Complete
[E25]'s parked char-0 transfer of the `F_67` branches — now with the
FIX ansatz imposed: the covariant is searched INSIDE the forced
profile (base-locus structure, multi-order `(6;3,3,3)`, `D_B`-shaped
leading data with `n₃`-divisible line factor, sweep and jet
conditions). The ansatz slices the 63-chart search to the profile
stratum; a hit IS the map (then verify dominance via [E17]'s
automatic-dominance, and the germ profile against the FIX
predictions — a total consistency crosscheck). A structured miss
(char-0 emptiness of the sliced stratum) closes `d = 25` and the
sieve advances.

**Route 2 (secondary): prolongation from the FIX-D2 solvable jets.**
The `(1,7)`/`w ≠ 0` jet survivors are explicit; grow them level by
level along `ℓ_V` (the H2/ladder machinery, linear per level) toward
`d = 43`, watching for the first genuine obstruction; each level is a
finite linear solve, and the boundary rigidity (5.23(i)–(ii)) plus
the conic-bundle section picture (γ-criterion, corrected sign
`γ = −u₀′`) give the presentation of choice.

## 4. Honest cautions (sealed lessons that still bind)

Jet/level solvability does not algebraize by itself (the T5 gate, the
C1 calibration); dominance must come from [E17] once a candidate
tuple exists; every constructed object gets the full two-engine seal
before any claim; and the six corrections of the Note IV campaign all
came from support/argument-slot bookkeeping — every ansatz dimension
count in this program must be machine-verified before consumption.
