D2-NO-VALID-BRIDGE

# Goal D2 status

**Headline problem:** OPEN.  This packet does not prove or disprove
`PSL(2,11)`-unirationality of the Klein cubic.

**Decision:** none of the audited candidate families supplies a genuinely new
mixed-prime invariant satisfying all five requirements of D2.0.  The largest
candidate class admits a structural no-go theorem: every additive
`|G|`-torsion stack obstruction with restriction/corestriction and fixed-point
normalization splits into primary parts and is killed by the Sylow fixed
points.  The nonadditive candidates fail for separately recorded reasons:
uncontrolled multisection degree, lack of an actual base-locus closure theorem,
or tautological equivalence to the original essential-dimension problem.

This is the exact early exit authorized by Goal D2.0: if no valid theorem and
bridge are found, stop before a large computation.  It is not a claim that no
future mixed-prime invariant can exist.

## Repository state

- Pinned state: `35fa8f59b6a1423cc89300aeaceefe91552be5ba`
- Live commit consumed: `37d61c19a108781cf74af837e24810a9f7f7c3be`
- Goal D authoritative input: commit
  `fc4e4900c70101d27ae5facef3bf6a706bdb9e11`
- Commit produced: **NONE** (no commit or publication was requested).
- Output path:
  `problems/E-klein-cubic/goal_runs_after_35fa/D2_STACK_INVARIANT/`

## Load-bearing results

1. `SYLOW_DETECTION.md` proves the primary-decomposition and Sylow-detection
   theorem for additive cohomological Mackey-valued point obstructions.
2. `THEOREM_AUDIT.md` tests every candidate direction named in Goal D2 and
   records the exact failed hypothesis.
3. `COUNTERMODELS.md` gives the arbitrary-multiplier product model and the
   polarization scaling identity.
4. `ADMISSIBLE_CENTRE_CLOSURE.md` tests Goal D's free-orbit Prym centre and
   explains why D2.1 is not entered after the D2.0 failure.
5. `invariant_payload.json` records the exact CRT idempotents, Sylow indices,
   transfer inverses, index-one certificate, and candidate ledger.
6. `verify.py` recomputes the arithmetic and all content hashes without
   trusting stored success booleans.

## Exact surviving research boundary

A successor must supply a **nonadditive** global invariant with all of the
following proved at once:

- it does not split prime-by-prime under the CRT theorem;
- it is functorial for the genuine relative-dimension-one correspondence;
- its conclusion survives every possible multisection degree;
- it is stable under the actual base-locus blowups;
- and it has a computable value not equivalent by definition to
  `ed_C(PSL(2,11))=4`.

No theorem in the audited literature supplies such an object.

## Replay

```sh
cd problems/E-klein-cubic/goal_runs_after_35fa/D2_STACK_INVARIANT
/opt/homebrew/bin/python3 produce.py
/opt/homebrew/bin/python3 seal.py
/opt/homebrew/bin/python3 verify.py
```

Expected terminal markers:

```text
D2_STACK_INVARIANT_PRODUCE_OK
D2_STACK_INVARIANT_SEAL_OK
D2_STACK_INVARIANT_VERIFY_OK
```
