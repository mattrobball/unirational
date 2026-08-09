# Replay

From this directory run:

```sh
/opt/homebrew/bin/python3 verify_exact.py
```

The replay imports the audited exact Hermite builder, compares the supports
at two rational root specializations, and invokes `gfan_mixedvolume`.

Expected final marker:

```text
OSCULATING-COVARIANT-COVER-EXACT-SUPPORT-OK
```
