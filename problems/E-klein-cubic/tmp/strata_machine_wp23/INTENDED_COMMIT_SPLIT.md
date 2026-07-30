# Intended commit split (WP-2 + WP-3 / Gate 2)

Do **not** commit from this agent (no state-mutating git). Suggested split for
the human/director:

## Commit 1 — WP-2 normal characters

```text
certificates/strata/normal_characters.py
certificates/strata/normal_characters.json
certificates/strata/verify_normal_characters.py
certificates/NORMAL_CHARACTERS.md
```

Message sketch: `E-klein-cubic: WP-2 tangent/normal character decorations`

## Commit 2 — WP-3 marked S3 geometry

```text
certificates/strata/marked_s3_geometry.py
certificates/strata/marked_s3_geometry.json
certificates/strata/marked_s3_geometry.pari-substitute
certificates/strata/verify_marked_s3.py
certificates/MARKED_S3_GEOMETRY.md
```

Message sketch: `E-klein-cubic: WP-3 marked S3 geometry; j=8192/11; E[2]-charge`

## Not touched (concurrency)

Do not include edits to `HANDOFF.md`, `RESOLUTION.md`, `CURRENT_PATHS.md`,
`SPEC.md` (other worker).

## Replay

```text
/opt/homebrew/bin/python3 certificates/strata/verify_normal_characters.py
/opt/homebrew/bin/python3 certificates/strata/verify_marked_s3.py
/opt/homebrew/bin/gp -q certificates/strata/marked_s3_geometry.pari-substitute
```

Markers: `NORMAL_CHARACTERS_VERIFY_OK`, `MARKED_S3_VERIFY_OK`, `MARKED_S3_PARI_OK`.
