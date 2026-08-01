# Replay

From `goals_after_35fa8f` run:

```sh
/opt/homebrew/bin/python3 -u point_attack_degree11_20260801/make_payloads.py
/opt/homebrew/bin/python3 -u point_attack_degree11_20260801/verify_exact_point.py
```

Expected terminal markers:

```text
H3_POINT_PAYLOADS_OK
H3_EXACT_BOTH_A5_POINTS_VERIFIED
```

The expensive discovery-only CRT reconstruction can be replayed with:

```sh
/opt/homebrew/bin/python3 -u point_attack_degree11_20260801/reconstruct_relations.py
```

It is not part of the trust boundary: the verifier checks the reconstructed
candidate by exact substitution.

