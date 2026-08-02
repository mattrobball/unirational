# Replay: canonical three-frame slice

Requirements: `/opt/homebrew/bin/python3` with NumPy and Singular on `PATH`.

From this directory, regenerate the twenty-triple specialization table:

```text
/opt/homebrew/bin/python3 three_frame_slice_probe.py
```

Expected markers include:

```text
ALL_240_SPECIALIZED_PLANE_QUARTICS_IRREDUCIBLE_OVER_F23
CANONICAL_DEGREE5_ALIGNED_TRIPLE=
```

Regenerate the selected-slice certificate:

```text
/opt/homebrew/bin/python3 three_frame_slice_geometry.py
```

Expected terminal marker:

```text
FULL_SCHUR_CANONICAL_THREE_FRAME_SLICE_PROBE_OK
```

Run the independent replay, which first checks the strict completed-theorem
seal, the retained three-frame discovery seal, and the installed
characteristic-zero Palatini lift, then reconstructs all factor, smoothness,
CRT-basis, and invariant-ratio data:

```text
/opt/homebrew/bin/python3 verify_three_frame_slice.py
```

Expected terminal marker:

```text
FULL_SCHUR_CANONICAL_THREE_FRAME_SLICE_REPLAY_OK
SCOPE: generic genus-three nonparametrization and bounded ratio search; no K_Schur point verdict
```

The full independent replay takes roughly three minutes under the reference
load.  The 218,596,225 count is an exact finite search after deduplicating
candidate specialization behaviors; it is not a claim about all invariant
rational functions.
