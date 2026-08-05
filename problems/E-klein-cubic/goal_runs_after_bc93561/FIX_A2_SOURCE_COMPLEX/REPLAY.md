# FIX-A2 — replay instructions

Packet: `goal_runs_after_bc93561/FIX_A2_SOURCE_COMPLEX/`
Program: FIX ([E56]). Object: `𝔽(P(W))`, the decorated fixed-locus complex of the source
`P⁴ = P(W)` under `G = PSL(2,11)` (Weil representation), `theory/FIX_I_bcomplex.md` Def 1.1.

## Requirements

`python3` only (3.11+; developed on 3.14.6). Standard library only — `fractions`,
`math`, `functools`, `collections`, `json`, `random`. **No** GAP, Sage, Magma, PARI/GP,
Macaulay2 or msolve is used or needed; every computation is exact linear algebra over
cyclotomic fields `Q(ζ_n)`, `n | 330`, plus integer arithmetic in `PSL(2,F₁₁)`.
No network access. No repository file outside this packet is imported or written.

## Commands

```sh
cd goal_runs_after_bc93561/FIX_A2_SOURCE_COMPLEX
python3 produce_source_complex.py      # ~19 s  -> writes source_complex.json
python3 verify_source_complex.py       # ~160 s -> independent recomputation
```

## Expected terminal markers

| script | marker | meaning |
|---|---|---|
| `produce_source_complex.py` | `PRODUCE_FIX_A2_OK` | payload written; all internal assertions passed |
| `verify_source_complex.py` | `FIX_A2_SOURCE_COMPLEX_VERIFY_OK` | 44 checks, 0 failures, harness self-test failed as required (exit code 0) |

On any discrepancy the verifier prints `FIX_A2_SOURCE_COMPLEX_VERIFY_FAILED`, lists the
failing checks and exits 1.

## Expected headline numbers (printed by the producer)

```
660 group elements, 620 subgroups, 16 conjugacy classes of subgroups
1502 strata (H,F), 20 G-orbits of strata
96 poset edges on class representatives, 5197 in total, 46 orbit-level relations
fixed-locus shapes: 1:P^4  C2:P^2 u P^1  C3:P^0 u P^1 u P^1  V4:P^1 u 3P^0
                    C5:5P^0  S3:P^0 (x2 classes)  C6:5P^0  D10:P^0  C11:5P^0
                    D12:P^0  A4:2P^0    C11:C5, A5 (x2), PSL(2,11): EMPTY
```

## Hashes (SHA-256)

```
dc65b7528aa9f442f5b8e3420a80e5e9d7ed1f22405c454b4c4f415c2ea57e49  source_complex.json
079654214e88260bf3054460a4aa351dde1951bbecae8784cabaf2ba94095168  produce_source_complex.py
ab4946e875dc0a078cf94cf72a6ca874f9dfddbc0f8d2aa52a96b3d8230712e2  verify_source_complex.py
```

`source_complex.json` is **byte-reproducible**: it contains no timestamp, no timing and no
run metadata, and the one place randomness appears in the producer (the sample of 40
subgroups on which the equivariant-transport identity is re-checked against projectors) is
seeded deterministically (`random.Random(20260804)`). Two consecutive runs were verified
to produce identical bytes. The producer overwrites the payload in place; to check
reproducibility, copy it aside, rerun, and `shasum -a 256` both.

## What the verifier is independent of

`verify_source_complex.py` shares **no code** with the producer (it is self-contained) and
recomputes every claim by a different method:

| object | producer | verifier |
|---|---|---|
| `Q(ζ_n)` arithmetic | integer numerator tuples over a common denominator; precomputed power-reduction table; inversion by extended Euclid | `Fraction` coefficient lists; explicit polynomial remainder mod `Φ_n`; inversion by solving the multiplication-matrix system; ranks by division-free elimination |
| the group | Cayley-graph BFS from `S, T` | brute-force enumeration of the 1320 determinant-1 matrices over `F₁₁` modulo `±1` |
| subgroup lattice | coset-representative BFS from the trivial subgroup | closures of `(cyclic subgroup, element)` pairs, with a closure-under-extension completeness certificate |
| fixed strata | images of the character projectors `(1/|H|)Σ χ(h)⁻¹ρ(h)` | kernels of the stacked eigenvalue systems `[ρ(g₁)−λ₁; …; ρ(g_k)−λ_k]` |
| isotypic dimensions | projector ranks and character inner products | `dim V^{[H,H]}` = average of `χ_V` over the derived subgroup |
| normal types `δ_nr` | character identity `ν = χ̄·χ_W − dim W_χ` | honest quotient matrices of `ρ(h)` on `W/W_χ` in a completed basis |
| residual group `δ_res` | stabiliser of the **subspace** in `N_G(H)` | stabiliser of the **character** in `N_G(H)` |
| pointwise stabiliser | elements acting on `W_χ` by a scalar | membership by direct scalar test + maximality read off the poset |
| the poset | exact subspace containment, `G`-transported | independent containment on its own eigen-solved bases, orbits identified by explicit conjugation; two independent recounts of 1502 and 5197 |

The verifier also re-identifies the representation itself (`g² = −11` for the Gauss sum;
`S² = T¹¹ = (ST)³ = 1`; `ρ(a)ρ(b) = ρ(ab)` on random pairs; `⟨χ_W,χ_W⟩ = 1`; invariance of
the Klein cubic `x₀²x₁+…+x₄²x₀` under `S` and `T`), and cross-checks eight statements of
the sealed FIX-A1 payload `goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR/v4_exact.json`
(read-only). Finally it runs a **harness self-test**: the deliberately false statement
"`P(W)^{A5}` is non-empty" must be recorded as a failure; if it were to pass, the run is
declared failed.

## Payload layout (`source_complex.json`)

| key | contents |
|---|---|
| `meta` | object, definitions, conventions, encodings |
| `group` | `PSL(2,11)`: order profile, the 8 element classes with `χ_W`, the generators `S, T` |
| `subgroup_classes` | the 16 classes: order, #conjugates, order profile, abelianization, `N_G(H)`, `W|_H` (linear multiplicities, character values, certified irreducible decomposition, irreducibility flag), fixed-locus shape |
| `subgroups` | all 620 subgroups: elements (as `PSL(2,11)` tuples `(a,b,c,d) mod 11` up to sign) and a conjugator from the class representative |
| `strata` | all 1502 pairs `(H,F)`: subgroup, character key, `dim F`, orbit |
| `stratum_orbits` | the 20 `G`-orbits with **full exact decorations**: exact basis of `W_χ`, `δ_dim`, `δ_nr` (dim, linear multiplicities, certified irreducible decomposition, exact character values), `δ_res` (`W(H,F)`, order profile, exact action matrices on the basis), `δ_bir`, pointwise stabiliser, orbit size |
| `poset` | all 5197 edges `[lower, upper]` and the 46 orbit-level relations with up/down multiplicities |
| `sanity` | Euler/Lefschetz identities, totals, and the "what lies inside each stratum" table |

Field elements are encoded as `{"f": n, "num": [c₀…c_{φ(n)−1}], "den": d}`, meaning
`(Σ cᵢ ζ_nⁱ)/d ∈ Q(ζ_n) = Q[x]/Φ_n(x)`. Group elements are canonical `(a,b,c,d) mod 11`
representatives, lexicographically minimal in `{±M}`.

## Notes for downstream use

* The whole complex is the **character-restriction poset**
  `{(H,χ) : W_χ ≠ 0}`, `(H,χ) ≤ (H',χ') ⟺ H ⊇ H'` and `χ|_{H'} = χ'` — verified on all
  5197 edges. Nothing beyond the numbers `dim W_χ(H)` is needed to rebuild it.
* Every stratum is a linear `P^d` with `d ≤ 2` for `H ≠ 1`, hence RCC: the hypothesis of
  `theory/FIX_I_bcomplex.md` Corollary 4.4 holds on this model, so by Lemma 4.3 it holds
  on **every** model of `P(W)`.
* `P(W)^H = ∅` for `H ∈ {C11:C5, A5 (both classes), PSL(2,11)}`, so those subgroups impose
  no source-side constraint at all.
