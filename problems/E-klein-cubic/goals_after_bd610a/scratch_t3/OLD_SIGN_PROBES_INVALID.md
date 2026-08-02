# Invalid pre-correction probes

The following generated discovery files were built before the `NB/NY` sign
correction and must not be used or sealed:

```text
generic_local_normalization.sing
generic_local_normalization_p101.sing
generic_local_normalization_only_p101.sing
generic_rur_inverse_p101.sing
generic_rur_rep_p101_B.txt
generic_rur_rep_p101_Y.txt
generic_rur_rep_p101_gcd.txt
```

Their only use was diagnosing expression growth.  They contain no valid
component, normalization, or conductor certificate.  The corrected inputs
have hashes

```text
NB  3ffd1fad77d6e66d40ee8f447bb898c87d0fefb936ef6ea1bf24a02ac7a228ee
NY  5a57c14e530a4ec111731b09a59da510f578f850d8655e31e7c318849a5209ae
```

Regenerate every probe from `emit_generic_local_normalization.py` before any
future use.
