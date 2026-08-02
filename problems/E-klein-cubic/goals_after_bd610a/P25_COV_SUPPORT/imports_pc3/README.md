# PC.3 load-bearing snapshot

These small files are hash-bound copies of the inherited literal-space and
multiplier-circuit inputs used in the PC.3 audit.  The local Bezout verifier
uses this snapshot directly.  The multiplier-map verifier imports the
authoritative upstream evaluator and historical strict helper because those
helpers resolve additional repository modules; their exact hashes are pinned
in `INPUT_MANIFEST.json` and in the verifier result.

Large landing matrices and the complete 2.5-GiB inherited packet are not
duplicated here.
