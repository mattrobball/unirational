# Replay

From
`/Users/worker/unirational/problems/E-klein-cubic/goals_2026-08-01` run:

```bash
python3 Q_SCHUR_DESCENT/parallel/h_trace_three_kummer_planes/verify.py
```

Requirements:

- Python 3 standard library;
- Singular on `PATH` (verified here with Singular 4.4.1).

Expected terminal marker:

```text
H_TRACE_THREE_KUMMER_TEN_GENERIC_SMOOTH_OK
```

The verifier checks the four authoritative source hashes, the four imported
pair-packet hashes, reconstructs all exact cyclotomic arithmetic, compares
the compact and ordered expansions, proves all 30 specialized gradient-chart
ideals are unit ideals in Singular, and reruns the imported pair verifier.

