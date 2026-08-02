# REPLAY.md — A0 independent verifier notes

Also known as `VERIFIER_REPLAY.md` content for Goal A0.

## Environment

- Host: macOS, Python 3.14 (`/opt/homebrew/bin/python3`), FLINT 3.6 via Homebrew
- Live HEAD at start: see `CANONICAL_STATE.json` → `live_head`
- Pinned publish: `35fa8f59b6a1423cc89300aeaceefe91552be5ba`
- No sealed historical packets rewritten in place

## Replays executed

### P25 — structural (mandatory)

```bash
python3 -u certificates/degree25_p25v/verify_p25v0.py
```

Log: `replay_p25v0_structural.log`  
Result: **PASS** — `rank(V0)=690`, all **126** `Tq0` cubics outside `V0`, sealed seed/T hashes match.

### P25 — support packet hygiene

```bash
python3 -u certificates/degree25_p25v/verify_p25v1.py
shasum -a 256 -c certificates/degree25_p25v/SHA256SUMS
```

Log: `replay_p25v1.log`  
Result: **PASS** — compressions r∈{28,32,40,64} intact; no false emptiness claim.

### P25 — bulk 4140 / 315 (verifier gap)

**Defect repaired:** stock `verify_p25v0.py` only asserts JSON fields `n_Ti_out=4140` and `n_comm_out=315` without rebuilding `S_1 ⊗ V_0 → S_4`.

**Independent recompute (authoritative for A0):**

1. Hash-lock binary inputs under `tmp/p25v_closure/` (see `P25_INPUT_HASHES.json`).
2. Sparse random-column projection + FLINT RREF of projected generators:

```bash
./goal_runs_after_35fa/A0_CANONICAL_AUDIT/verify_p25_bulk_projection
```

Log: `replay_p25_bulk_projection.log`  
Result: `verify_p25_bulk_projection_result.json`

```text
ok=true
n_Ti_out_certified=4140
n_comm_out_certified=315
rank_pi_G=25530
n_*_projection_zero_remainder=0
elapsed_seconds≈1592
reads_4140_from_json=false
```

Soundness: nonzero projected remainder ⇒ original vector not in \(S_1\cdot V_0\).

**Full dense deg-0 FLINT RREF (abandoned):**

```bash
./tmp/p25v_closure/solve_deg0_flint tmp/p25v_closure_replay_a0
```

Log: `replay_p25_flint_full.log` — filled G (25530×91390), then hung at
`computing rref...` for ~1 h with no further log growth. Process **killed**
2026-08-02; incomplete; **not** load-bearing for A0 pass. Optional future
resource job only.

### C — merge authority

```bash
python3 -u goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/verify_all.py
```

Log: `replay_c_codex.log`  
Result: **PASS** → `C-PARTIAL-EXACT-INTERFACE-VERIFIED`  
Seal file hashes: 19/19 match `SEAL.json`.

Canonical marker written: `goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/CANONICAL.md`.

### COV — dual packet reconciliation

```bash
python3 -u goals_2026-08-01/COV_STRUCTURED_SEARCH_ROOT/verify_all.py
python3 -u goals_2026-08-01/COV_STRUCTURED_SEARCH/verify_all.py
```

Logs: `replay_cov_root.log`, `replay_cov_structured.log`  
ROOT: **PASS** full suite + seal.  
Structured: composition/cross/global modules verified; combined ansatz ranks checked.

Canonical markers: both COV directories get `CANONICAL.md` with exit-label repair.

### F / D / H

```bash
python3 -u goals_2026-08-01/F_CONIC_ALGEBRA/verify.py
python3 -u goals_2026-08-01/D_EQUIVARIANT_MOTIVE/verify.py
python3 -u goals_2026-08-01/H_SUBGROUP_TWISTS_ROOT_019FBE10/verify.py
```

All **PASS** (logs `replay_f.log`, `replay_d.log`, `replay_h.log`).

### Not re-run (by policy)

- Full P25 Stage-B/C msolve F4 charts (>8–40 GiB, nonverdict history): retained as resource-blocked; hashes of compressions verified.
- All Q multi-packet research CAS: out of A0 mechanical scope.
- Post-35fa research goals B, H5, etc.: no claim replay required for A0 pass beyond ledger.

## Failed / incomplete at first write

Update `STATUS.md` first line when bulk FLINT finishes. If bulk disagrees with sealed 4140/315, issue `A0-AUDIT-FAIL`.
