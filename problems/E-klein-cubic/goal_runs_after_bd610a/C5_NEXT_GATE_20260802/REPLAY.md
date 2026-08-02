# Replay

From repository root:

```sh
cd goal_runs_after_bd610a/C5_NEXT_GATE_20260802
PYTHONDONTWRITEBYTECODE=1 python3 -u produce_record_interpreter.py
PYTHONDONTWRITEBYTECODE=1 python3 -u verify_record_interpreter.py
```

Both scripts must print:

```text
C5-MORITA-RECORD-INTERPRETER-P23-PASS
```

The verifier does not import the producer.  It reloads sealed DAGs, rebuilds
the accepted modular fibre from upstream producers, walks every stored factor
string and every split-DAG node, and checks checksums in
`interpreter_probe.json`.

Resource note: peak work is matrix arithmetic over `F_23` of size at most
`6×6` and a 517-node DAG walk.  No Groebner basis, no Magma, no full `L_a`
expansion.
