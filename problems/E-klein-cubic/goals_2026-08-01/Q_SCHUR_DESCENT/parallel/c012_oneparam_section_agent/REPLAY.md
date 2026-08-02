# Replay

From this directory, run:

```bash
env PYTHONDONTWRITEBYTECODE=1 /opt/homebrew/bin/python3 -u verify.py
```

The replay requires the exact upstream packets named in
`source_manifest.json`, SymPy, `/opt/homebrew/bin/Singular`, and
`/opt/homebrew/bin/msolve`.  It takes roughly two to three minutes on the
reference machine; the degree-three chart normalized by `x1=1` is the slow
step.

The verifier:

1. checks all upstream hashes and the local packet seal;
2. reconstructs the complete specialized cubic and compares its 26-term
   exact table and hash;
3. reconstructs specialized `c4`, `c6`, and `c4^3-c6^2`, checks their exact
   hashes, and factors them over `Q(epsilon)`;
4. checks the infinity orders and reported Kodaira fibre data; and
5. reconstructs the 13 coefficient equations modulo
   `(11,epsilon-3)` and proves all twelve projective charts empty.

The successful tail is:

```text
MOD11_CHART 9 z1 EMPTY
MOD11_CHART 10 z2 EMPTY
MOD11_CHART 11 z3 EMPTY
POLYNOMIAL_SECTION_DEGREE_LE_3_MOD11 EXCLUDED
STATUS C012_GENERIC_SECTION_UNDECIDED
C012_ONE_PARAMETER_BOUNDED_STOP_OK
```

`SEAL.json` lists the authoritative files.  The older
`analyze_flex_cover.py` and `.sing` scratch files in this directory are
unsealed exploratory leftovers and establish no additional result.
