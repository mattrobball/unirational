# Replay

From `problems/E-klein-cubic` run:

```sh
python3 goal_runs_20260808/OSCULATING_ROOT_PATTERNS/verify.py
```

Expected output:

```text
PASS exact polynomial leading-term regression for all 70 vectors
PASS 70 analytically forced root-multiplicity vectors
PASS exactly 18 pair-leading and 2 triple-leading tropical survivors
PASS all pair-leading cases have nonzero order-11 unit residue
PASS exact 3^5 active-pair classification for both triple systems
PASS A local orders are 14,0,13 modulo 11
PASS B local orders are 2,0,7 modulo 11
F55-OSCULATING-ROOT-SUPPORTED-DEGREE9-EMPTY-SCOPED
```

The verifier uses integer arithmetic only.  It enumerates 70 forced
multiplicity vectors and 243 active-pair signatures per tropical system.  It
does not enumerate valuation sizes, polynomial degrees, coefficient fields,
or finite-field points.
