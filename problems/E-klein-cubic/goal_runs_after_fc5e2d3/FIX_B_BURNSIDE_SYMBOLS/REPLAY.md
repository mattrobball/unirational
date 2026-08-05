# FIX-B — replay instructions

Packet: `goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS/`
Program: FIX ([E56]); side-goal FIX-B of `theory/FIX_I_bcomplex.md` §7.
Objects: the symbol list of `[P(W)] ∈ Burn₄(G)`, `G = PSL(2,11)`, `W` the exact
5-dimensional Weil representation; the removability audit under
`theory/FIX_I_bcomplex.md` Theorem 2.1; the `C11` weight table.

## Requirements

`python3` only (developed on 3.14). Standard library only — `fractions`, `json`, `os`,
`itertools`, `collections`. **No** GAP, Sage, Magma, PARI/GP, Macaulay2 or msolve is used or
needed: every computation is exact linear algebra / character arithmetic over `Q(ζ_330)`
plus integer arithmetic in `PSL(2,F₁₁)`. No network access. Characteristic 0 throughout.

## Commands

```sh
cd goal_runs_after_fc5e2d3/FIX_B_BURNSIDE_SYMBOLS
python3 produce_burnside_symbols.py     # ~2 s   -> symbols.json, removability.json, c11_weights.json
python3 verify_burnside_symbols.py      # ~132 s -> independent recomputation, exit 0
```

## Expected terminal markers

| script | marker | meaning |
|---|---|---|
| `produce_burnside_symbols.py` | `PRODUCE_FIX_B_OK` | three payloads written; all internal assertions passed |
| `verify_burnside_symbols.py` | `FIX_B_BURNSIDE_SYMBOLS_VERIFY_OK` | 20 checks, 0 failures, harness self-test failed as required (exit code 0) |

On any discrepancy the verifier prints `FIX_B_BURNSIDE_SYMBOLS_VERIFY_FAILED`, lists the
failing checks and exits 1.

## Expected headline numbers (printed by the producer)

```
20 stratum orbits, 19 distinct symbols, dim F + |beta| = 4 on all of them
14 abelian-stabiliser orbits, 6 nonabelian (standard form)
15 isotropy strata: 11 abelian (10 distinct symbols) + 4 nonabelian
10 admissible point-orbit centers, 1023 admissible unions
54 new G-orbits of strata across the ten blowups, 29 distinct symbols (7 already present)
11 REMOVABLE symbols, 9 in the non-removable core (2 unconditional)
60 C11 points, 12 subgroups, 10 distinct weight quadruples mod 11
```

## Inputs

* `produce_burnside_symbols.py` reads exactly one repository file:
  `goal_runs_after_bc93561/FIX_A2_SOURCE_COMPLEX/source_complex.json`
  (SHA-256 `dc65b7528aa9f442f5b8e3420a80e5e9d7ed1f22405c454b4c4f415c2ea57e49`).
* `verify_burnside_symbols.py` reads **no** repository file outside this packet. It rebuilds
  the representation in-file from the `S, T` construction of
  `certificates/exact_weil_check.py` (Gauss sum `g` with `g² = −11`, `js = [1,3,2,5,4]`,
  `signs = [1,1,−1,1,1]`, Cayley BFS from `fs = (0,2,5,0)`, `ft = (1,2,0,1)`), and reads the
  three JSON payloads of this packet to check them.

## Hashes (SHA-256)

```
c49bffcfc87dfde41900d356f64a4be6bea0d3562f9df5d927bf544da53c0589  produce_burnside_symbols.py
5b8cdc65e243aba0353973726f91fef4433618ae61264e4974814e459239f2d6  verify_burnside_symbols.py
522d9b966d51fd25c4d182ff9a8b2a0cc09d9af4b76e45e26084497741dc1235  symbols.json
fab7a84fa23e6cffa81a3262e3e22d92a169d7f9d962aac3f5e99977c066143a  removability.json
86060643a60847b04c47e9540b46c1c7b9946bf906005fe30a8b1a6d7c69d092  c11_weights.json
```

The three payloads are **byte-reproducible**: they contain no timestamp, no timing and no run
metadata, and the producer is deterministic (no randomness anywhere). Two consecutive runs
were verified to produce identical SHA-256 sums. To re-check, copy the payloads aside, rerun
the producer and `shasum -a 256` both.

## What the verifier is independent of

`verify_burnside_symbols.py` shares **no code** with the producer (it is self-contained) and
recomputes every claim by a different method:

| object | producer | verifier |
|---|---|---|
| `Q(ζ_330)` | tensor basis `ζ_3^b ζ_5^c ζ_11^d` (`b<2, c<4, d<10`), reduction by the three hand rules `ζ_3² = −1−ζ_3`, `ζ_5⁴ = −(1+…+ζ_5³)`, `ζ_11¹⁰ = −(1+…+ζ_11⁹)`; monomials placed by CRT | `Q[x]/Φ_330(x)`, with `Φ_330` built in-file by the recursion `Φ_n = (x^n − 1)/∏_{d\|n, d<n} Φ_d` using exact polynomial division, and a precomputed `x^e mod Φ_330` power table |
| `ρ` | never built; `χ_W` taken from the payload's class table | `S, T` built from the Gauss sum exactly as `certificates/exact_weil_check.py`; Cayley BFS over `PSL(2,F₁₁)`; `g² = −11`, `S² = T¹¹ = (ST)³ = 1`, Klein-cubic invariance and 660-element consistency re-asserted |
| `PSL(2,11)` | brute-force enumeration of the 1320 determinant-1 matrices mod `±1` | the BFS image of the Cayley graph, cross-checked against the brute-force set |
| `χ_W` | payload class table | traces of the built matrices |
| subgroup classes | the payload's 620 subgroups | closures `⟨a,b⟩` with `a` over element-class representatives and `b` over all of `G`; 16 classes / 620 subgroups recounted |
| `W_χ` | character multiplicities `⟨χ, χ_W\|_H⟩` | **kernels** of the stacked systems `[ρ(g_i) − χ(g_i)]` by division-free elimination over `Q(ζ_330)` |
| `dim F` | `⟨χ, χ_W\|_H⟩ − 1` | `dim ker − 1` |
| `δ_res` | stabiliser of the **character** `χ` in `N_G(H)` | stabiliser of the **subspace**: `ρ(g) W_χ = W_χ`, tested by rank |
| residual action | projector-trace identity `(1/\|H\|) Σ_h χ̄(h) χ_W(gh)` | honest restriction matrices of `ρ(g)` to `W_χ` in an explicit kernel basis, compared trace by trace across the two field encodings |
| `β` (`δ_nr`) | `ν = χ̄·χ_W − dim W_χ`, multiplicities by inner products | `mult_ψ(N) = dim W_{χψ} − [ψ = triv]·dim W_χ` from **eigenspace dimensions**, for every linear `ψ`, with the producer's own generator/exponent bookkeeping re-evaluated |
| the point-orbit centers | the payload's `pointwise_stabiliser` | recomputed: `{g ∈ G : ρ(g)v ∥ v}` for the spanning vector of each 0-dimensional stratum |
| Thm 2.1 deltas | character inner products on `T_p` | re-derived from eigenspace dimensions of `A`-twisted characters on `W`, for every subgroup `A ≤ Stab(p)` and every non-trivial linear character |
| `C11` data | payload subgroup list + inner products | closures of the recorded generators, canonicity of the generator re-checked, `J` recomputed from eigenspace dimensions, all 60 quadruples and their sums re-derived |

The verifier also runs a **harness self-test**: the deliberately false statement
“`P(W)^{A5}` is non-empty” must be recorded as a failure; if it were to pass, the run is
declared failed.

## Notes for downstream use

* `symbols.json → symbols[]` is keyed by the FIX-A2 `orbit_id`, so it joins directly onto
  `source_complex.json → stratum_orbits[]`.
* `canonical_symbol_key` is a conjugation-invariant, twist-invariant string; two orbits carry
  the same symbol iff their keys are equal. Exactly one collision occurs among the 20
  (`C5/chi1` and `C5/chi2`).
* `removability.json → blowup_deltas[]` is the complete first-order move table: for each of
  the ten centers, the destroyed orbit ids and every exceptional stratum with `H`, `χ`,
  `m_χ`, `dim`, `β_new`, residual group and `G`-orbit size. Deltas for a union of centers are
  the sums of the individual deltas (the point orbits are pairwise disjoint).
* Every verdict in `removability.json → verdicts[]` cites only `theory/FIX_I_bcomplex.md`
  Theorem 2.1. `honesty.literature_dependent_configurations` lists the 45 places where a
  Kresch–Tschinkel vanishing relation would be the natural next move; none is applied.
