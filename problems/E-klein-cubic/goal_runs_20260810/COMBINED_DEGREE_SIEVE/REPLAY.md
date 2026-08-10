# COMBINED_DEGREE_SIEVE — exact replay

Packet: `problems/E-klein-cubic/goal_runs_20260810/COMBINED_DEGREE_SIEVE/`
Repo HEAD when produced: `263dd8d07877365b8ef05820545642c6fb2a963b`
Branch: `agent/combined-degree-sieve-20260810`
Toolchain: `python3` only (checked with 3.14.6; stdlib only, `fractions` is the
sole import).  No Macaulay2, no msolve, no floating point, no Groebner basis,
no finite-field sampling, no search.

## Commands

```sh
cd problems/E-klein-cubic/goal_runs_20260810/COMBINED_DEGREE_SIEVE
python3 verify_combined_sieve.py
```

Runs in well under a second.

## Expected output

The script prints, in order:

* section A — confirmation that the character data for \(W\) is internally
  consistent, and the line

  ```text
  A  covariant dims d=15..21 = [32, 41, 49, 59, 73, 86, 100] match the repo's mod-67 table exactly
  ```

* section B — `dim H^0(X,O_X(k))^G` for `k = 0..12`, equal to
  `[1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2, 2, 3]`, the identification
  `S = {5,6,7,...}`, and the exclusion of `d' = d-1, d-2, d-3, d-4`;

* section C — the inert primes below 60,
  `[2, 7, 13, 17, 19, 29, 41, 43]`, the agreement of the valuation criterion
  with direct representation by \(x^2+xy+3y^2\) on \([1,20000]\), and the
  \(\delta\not\equiv2\pmod4\) consequence;

* section D — `d'=2 -> delta in {3,4,5}` and
  `d'=3 -> delta in [3,4,5,9,11,12,15,16,20,23]`;

* section E — the survivor table for `d` in `[22,60]`: every `d <= 30` marked
  `DEAD FIX-P2-SWEEP2-EMPTY-THROUGH-30` in both branches; every `d` in
  `[31,60]` marked `ALIVE`, the retraction branch at `delta=1` and the
  all-ambient branch with the norm count and `min = 3`.  Then the
  no-periodic-closure certification over `10724` `(modulus, residue)` pairs,
  and the maximal norm gap `34` on `[1,215940]`.

* the six terminal markers:

  ```text
  COMBINED_SIEVE_CHARACTER_DATA_OK
  COMBINED_SIEVE_INVARIANT_DEGREE_SET_OK
  COMBINED_SIEVE_NORM_CRITERION_OK
  COMBINED_SIEVE_DELTA_INTERVAL_OK
  COMBINED_SIEVE_TABLE_OK
  COMBINED_SIEVE_NO_PERIODIC_CLOSURE_OK
  ```

A failed assertion aborts before the markers are printed; the markers are
therefore the whole pass condition.

## Files

| file | role |
|---|---|
| `STATUS.md` | exits, headline, scope and nonclaims |
| `CONSTRAINT_LEDGER.md` | every degree constraint, citation, sealed level, used/excluded |
| `THEOREM_COMBINED_SIEVE.md` | the proofs: character data, removed divisor, excess intersection, norm criterion, sieve, no-closure |
| `verify_combined_sieve.py` | the exact replay of every number quoted above |
| `REPLAY.md` | this file |

## Determinism

The script has no randomness, no time dependence, no environment dependence and
no I/O.  Every quantity is an exact integer, an exact `Fraction`, or an exact
vector of integers in \(\mathbf Z[\zeta_{11}]\).  Repeated runs are byte
identical.

## Independence of the verifier

| quantity | how the packet derives it | how the verifier recomputes it |
|---|---|---|
| eigenvalue multisets of \(W\) | solved by hand from \(\chi_W(g^j)\) (Lemma 1.1) | forward discrete Fourier transform of the stored multiplicities, compared against the power sums for every \(j\) |
| \(\dim(\operatorname{Sym}^dW^\vee\otimes W)^G\) | Molien series in \(\mathbf Z[\zeta_{11}]\) | same series, then compared against the repository's `LOW_DEGREE_DOMINANT_MAPS.md` table produced by Reynolds averaging mod 67 — a different algorithm, different arithmetic, different packet |
| \(S=\{0\}\cup\{5,6,\ldots\}\) | difference of invariant dimensions, plus multiplication by the degree-five invariant | difference computed to \(k=64\) and compared with `set(range(5,65))` |
| inert primes | quadratic reciprocity, \((-11/p)=(p/11)\) | the residue rule *and*, independently, an Euler-criterion power computation \((-11)^{(p-1)/2}\bmod p\) for every odd prime below 200 |
| \(\delta\) is a norm | valuation criterion via class number one | independently, brute-force enumeration of \(x^2+xy+3y^2\) over the exact finite box \(11y^2\le4L\), \(|2x+y|\le2\sqrt L\), compared on \([1,20000]\) |
| survivor table | intersection of the ledger constraints | rebuilt from the ledger constants, with `delta = 3` re-checked against each constraint separately |
| no periodic closure | Theorem 5.2 | an explicit admissible cell exhibited for each of 10724 \((M,r)\) pairs, each constraint asserted individually |

The integer-square-root helper avoids floating point in the brute-force box.

## Provenance / dependencies read

Read, not modified:

* `goal_runs_20260809/AMBIENT_REES_SELFMAP_CLASSIFICATION/{LOW_DEGREE_DOMINANT_MAPS,RETRACTION_DEGREE_BOUND,THEOREM,STATUS}.md`
* `goal_runs_20260809/FULL_G_SELFMAP_CLASSIFICATION/{THEOREM,STATUS}.md`
* `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/{THEOREM_RESTRICTED_DICHOTOMY,DEGREE_ACCOUNTING,STATUS,SOURCES,ADVERSARIAL_TESTS}.md`
* `goal_runs_after_2666fdb/FIX_P2_GATEWAY_D36/STATUS.md`
* `certificates/LOCAL_TRANSITION_MODULES.md`
* `external_sessions/mathematical-equivariance-query-6a70557e.md` (excluded material)
* `theory/FIX_II_jets.md`, `theory/FIX_I_bcomplex.md` (excluded material)
* `NOTEBOOK.md`, `notebook_build/manifest.json`, `scripts/check_manifest_parity.py`

External mathematical sources used: W. Fulton, *Intersection Theory*, 2nd ed.,
Prop. 4.4 and §4.3; the standard character table of
\(\operatorname{PSL}_2(\mathbf F_{11})\); Grothendieck--Lefschetz for
\(\operatorname{Pic}\) and \(\operatorname{Cl}\) of a smooth hypersurface of
dimension three.

No sibling packet's files were edited.  `research/` was not touched.
