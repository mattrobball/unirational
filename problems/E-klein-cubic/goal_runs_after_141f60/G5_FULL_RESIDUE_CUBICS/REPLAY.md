# G5 replay

From `problems/E-klein-cubic`:

```sh
# optional regenerate (producer)
/opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS/produce_residues.py

# independent verifiers (must not import produce_residues)
/opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS/verify_models.py
/opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS/verify_decision.py

# seal (after docs stable)
/opt/homebrew/bin/python3 -u \
  goal_runs_after_141f60/G5_FULL_RESIDUE_CUBICS/make_seal.py
```

## Expected markers

```text
G5_PRODUCE_OK
G5_MODELS_VERIFY_OK
G5_DECISION_VERIFY_OK
G5_SEAL_OK
```

## Primary STATUS line

```text
G5-F5-CUBIC-MODEL-PASS
```

## Binding inputs (hashed in INPUT_MANIFEST.json)

- `goal_runs_after_bd610a/V3_VALUATION_RESIDUE_CLOSEOUT_20260802/`
- `goal_runs_after_35fa/G_UNIVERSAL/`
- `goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json`
- `goals_2026-08-01/V_VALUATION_TROPICAL_CODEX_ROOT_20260801/`
- optional G3A / `tmp/kproj_arithmetic/normalized_kproj_table.json`

## Notes

- Producer \(\neq\) verifier: verifiers rebuild reductions and probes from
  `generic_cubic.json` and the sealed JSON payloads only.
- No GitHub Actions; local CAS only.
- Peak RSS reported in `produce_meta.json` / `STATUS.md`.
