# Replay

From this directory run:

```sh
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify.py
```

The replay hash-checks the authoritative subgroup and degree-11 point
inputs, reruns the upstream exact characteristic-zero point verifier, then
reconstructs both finite-field transfers and all eleven-point quadric ranks.
It ends with:

```text
A5_DEGREE11_TRANSFERRED_ORBITS_FAIL_RNC_QUADRIC_TEST_OK
```
