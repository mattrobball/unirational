# Replay

Run:

```sh
/opt/homebrew/bin/python3 -u schur_enq_v14/verify.py
```

Verified output on 2026-08-01:

```text
D10 {'point_ranks': [2, 2, 2], 'coefficient_rank': 4, 'evaluation_ranks': [4, 4, 4]}
D12 {'point_ranks': [2, 2, 2], 'coefficient_rank': 4, 'evaluation_ranks': [4, 4, 4]}
D10 orbit 66 incidence_quadric_span_rank 21
D12 orbit 55 incidence_quadric_span_rank 21
Q_SCHUR_ENQ_V14_AUDIT_EXACT_NONTERMINAL
```

The verifier checks the pinned source hashes, Schubert hook-length degrees,
all gcd implications, both certified line equations at the split good prime,
the Pfaffian-adjugate restriction ranks, and the full 66-line and 55-line
incidence-quadric spans.  The marker is explicitly
nonterminal: it authenticates the model and stopping theorem, not a binary
decision for Goal Q.
