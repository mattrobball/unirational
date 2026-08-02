H5-UNDECIDED

# Goal H5 status — genuine `11:5` cyclic trace cubic

**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`  
**H4 input:** `goal_runs_after_35fa/H_11_5_TWIST/` (`H-11_5-NORM-MODEL-PASS`)  
**Headline:** OPEN (Problem E unchanged)

## Exit

```text
H5-UNDECIDED
```

Authorized nonterminal exit from
`goals_after_bd610a/GOAL_H5_11_5_TRACE_CUBIC_DECISION.md`.  This is **not**

- `H5-POINTLESS-HEADLINE-NEGATIVE`,
- `H5-RATIONAL-POINT`,
- `H5-VALUATION-REDUCTION-PASS`,
- `H5-COEFFICIENT-CLASS-REFUTED`,
- or any Problem E headline.

## What was done

1. **Sealed workspace** under `goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/`.
2. **INPUT_MANIFEST** binds H4 `FIELD_MODEL` / `TWIST_MODEL` / `NORM_MODEL` /
   decision / seal payloads by path+SHA-256, plus retired `h_trace_*` ansatz
   packets as scope constraints.
3. **Model audit (H5.0):** lattice checks, reconstruction of
   `Phi=Tr(r2^{-1}a^2 sigma(a))`, replay of the `p=89` cubic coefficient table
   against H4.
4. **Constructive screens (H5.1 first wave):** constant `z`, additive and
   multiplicative monoms, partial cyclic sums, fixed-rational `u+v sigma(u)+w sigma^2(u)`,
   three-term constant identity in `(s,t)`, linear forms in `r_i` and `r_i^{-1}`,
   and power-basis coefficients from low cyclic invariants.  **No K-identity hit.**
5. **Modular specialization screen:** random product-one `r` over ten primes
   (including holdout `199`) finds F_p-points on specialized fibres routinely.
   Honest nonverdict: not a K-point, not emptiness.
6. **Coefficient class (H5.3):** order-11 class restated; **not** promoted.
7. **Valuation ledger (H5.2):** first toric orbit inventory only; **no**
   residue anisotropy.

## Points found

```text
none over K
```

## Smallest remaining theorem

\[
 \exists\,0\ne a\in E:
 \operatorname{Tr}_{E/K}(r_2^{-1}a^2\sigma(a))=0\ ?
\]

## Next finite gate

Exact three-or-more Laurent support classification with coefficients in `K`,
**or** projection from the degree-five closed point to a residual fibration
whose generic fibre is decidable, **or** one complete toric valuation with a
proved anisotropic residue.

## Replay

```sh
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/produce.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/seal.py
/opt/homebrew/bin/python3 -u goal_runs_after_bd610a/H5_11_5_TRACE_CUBIC/verify.py
```

Terminal marker:

```text
H5_INDEPENDENT_VERIFY_OK
```
