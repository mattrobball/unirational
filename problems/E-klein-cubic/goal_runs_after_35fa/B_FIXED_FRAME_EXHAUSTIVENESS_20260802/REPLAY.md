# Replay

From this directory in a full repository checkout:

```sh
PYTHONDONTWRITEBYTECODE=1 python3 -u produce.py
PYTHONDONTWRITEBYTECODE=1 python3 -u produce_seal.py
PYTHONDONTWRITEBYTECODE=1 python3 -u verify.py
```

Expected terminal markers:

```text
B-EXHAUSTIVENESS-PAYLOAD-PRODUCED
B-EXHAUSTIVENESS-SEAL-PRODUCED
B-FIXED-FRAME-EXHAUSTIVENESS-REFUTED
B-BRIDGE-REFUTED
HEADLINE-OPEN
```
