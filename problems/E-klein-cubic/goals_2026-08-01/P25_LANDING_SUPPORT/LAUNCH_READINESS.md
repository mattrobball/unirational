# P25 landing support — launch readiness (finite CAS front)

**Date:** 2026-08-02  
**Exit (overall):** `P25-UNDECIDED`  
**Pair-split package:** `parallel/r66_pair_split/`  
**Package status:** `PREPARED_NOT_RUN` / `SEALED_PREPARED_NOT_RUN`  
**Readiness verdict:** **`BLOCKED`** (not `LAUNCH_OK`)

This note is readiness + light verification only. No multi-hour / multi-GB F4
or msolve job was launched.

---

## 1. Prepared input verification (this session)

From

```text
goals_2026-08-01/P25_LANDING_SUPPORT/parallel/r66_pair_split/
```

| Step | Command | Result |
|---|---|---|
| Prepare audit | `/opt/homebrew/bin/python3 verify_prepared.py` | `PREPARED_NOT_RUN` (exit 0) |
| Reseal | `/opt/homebrew/bin/python3 make_seal.py` | `SEALED_PREPARED_NOT_RUN` |
| Seal check | `/opt/homebrew/bin/python3 verify_seal.py` | `PASS_SEALED_PREPARED_NOT_RUN` |

Immutable chart bindings (unchanged):

| Item | Value |
|---|---|
| Chart | Stage B affine: `q0=1`, `b1_0=1` |
| Field | `F_89` |
| Equations / variables | 66 / 41 |
| Source | `r66_stageB_q0_1_b1_0_1_m100.ms` |
| Source bytes | `41,537,116` |
| Source SHA-256 | `9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b` |
| r66 packet SHA-256 | `b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84` |
| msolve | 0.10.1, SHA-256 `b2008fb403f38f6a2ae230d12e3023776ae0196761c49966d97fe10747131c60` |
| Only non-path option delta vs audited baseline | `-m 0` → `-m 100` |
| Hash-table reset | OFF (`-u` omitted) |
| Run artifacts present | **none** (`.leading`, `.log`, `.run.json`, `.prelaunch.json` absent) |

`verify_prepared.py` rewrites `verify_prepared_result.json` with a live memory
snapshot; after re-verify, `make_seal.py` was re-run so the seal matches the
new snapshot. Source / runner / packet hashes are unchanged.

---

## 2. Exact launch command (when gates pass)

**Do not run in the managed sandbox.** An unavailable `ps` poll is a binding
failure, not permission to continue.

```sh
/opt/homebrew/bin/python3 -u \
  /Users/worker/unirational/problems/E-klein-cubic/goals_2026-08-01/P25_LANDING_SUPPORT/parallel/r66_pair_split/run_pair_split.py \
  --confirm-parent-notified
```

Underlying msolve invocation (constructed by the runner):

```text
/opt/homebrew/bin/msolve \
  -f r66_stageB_q0_1_b1_0_1_m100.ms \
  -o r66_stageB_q0_1_b1_0_1_m100.leading \
  -t 4 -v 2 -g 1 -l 2 -q 0 -r 0 -s 20 -m 100 \
  --random-seed 2026080189
```

Pre-launch parent message is mandatory (`--confirm-parent-notified`).

---

## 3. Expected memory / resource plan (RSS)

| Fence / estimate | Value |
|---|---:|
| Runner RSS hard stop (aggregate process-group) | **4.5 GiB** (`4831838208` bytes) |
| Wall timeout | **1200 s** |
| Threads | **4** |
| Pre-launch free+speculative minimum | **14 GiB** |
| Prior ordinary F4 (`-m 0`) on same chart | degree 5 complete; entered 1708-pair degree-6; **manual stop at ~4.28 GiB RSS** (`4,482,960 KiB`) after ~549 s — **strict nonverdict** |
| Pair-cap intent (`-m 100`) | caps pairs per F4 matrix so the 1708-pair degree-6 batch cannot enter one matrix; **not** a fixed 18-block partition; peak RSS still expected to approach the 4.5 GiB fence |
| Host RAM | 128 GiB |
| This-session free+speculative (vm_stat) | **~96.4 GiB** → memory gate **PASS** |

**RSS monitoring plan (required by runner, fail-closed):**

1. Before spawn: `vm_stat` free+speculative ≥ 14 GiB.  
2. Before spawn: live `ps -axo pid=,ppid=,pgid=,rss=,command=` census succeeds.  
3. Before spawn: no competing P25 bounded CAS (`msolve` / `singular` /
   `run_bounded` / related), except the documented shared Singular PID 13036
   if still the historical boundary job.  
4. During run: poll process-group RSS every 0.25 s; stop on RSS > 4.5 GiB or
   wall > 1200 s or any `ps` failure (`rss_poll_unavailable`).  
5. Host policy: at most one unrelated job expected to exceed ~8 GiB RSS at a
   time; do not co-schedule this job with heavy COV m=1 chart CAS.

---

## 4. Launch gates — this session

| Gate | Required | Observed | Pass? |
|---|---|---|---|
| Prepared source + seal | `PREPARED_NOT_RUN` sealed | verified + resealed | **yes** |
| Free+speculative memory | ≥ 14 GiB | ~96.4 GiB | **yes** |
| Live `ps` process census | available + no competing probes | `ps`: **Operation not permitted** | **no** |
| Parent notification / mission | readiness-only; no heavy launch | readiness mission; no launch | **blocks launch** |
| Escalation for unsandboxed `ps` | historically noted until 2026-08-08 | still unavailable in this environment | **blocks launch** |

**Verdict: `BLOCKED`.**  
Memory alone would allow a launch attempt. The fail-closed runner cannot start
without a live process census, which this environment denies. No CAS child was
spawned.

---

## 5. Residual chart list on `D(H8)` (from STATUS / cover certs)

Closed (not residual):

```text
L8 = P<span(q4,...,q11)>
Stage B on L8: empty (rank 10296/10296, selected det ≡ 28 mod 89)
normalized Stage C on L8: empty (compatibility rank 6435/6435)
Stage A: empty
```

Outside ideal:

```text
H8 = (q0,q1,q2,q3,q12,...,q36)   # 29 coordinates
```

### Stage B on `D(H8) × P^5_{b1}`

| Quantity | Count | Decided empty? |
|---|---:|---|
| Certified paired MDS opens | **34** | **0** |
| **Remaining opens** | **34** | — |

Cover: Reed–Solomon paired opens  
`D(ℓ_k(q)) ∩ D(m_k(b1))`, `k = 0,…,33`, length 34, MDS support argument
`6 + 29 > 34`. Certificate replay this session:

```text
PASS_INDEPENDENT_STAGEB_MDS34_COVER_REPLAY
  (parallel/determinantal_cover/verify_mds_stageB_cover.py)
```

**Prepared first chart (subset of the 34):**  
`q0=1, b1_0=1` — `PREPARED_NOT_RUN` (pair-split). Strongest prior attempt is a
strict nonverdict (resource stop).

### Stage C on `D(H8)` (normalize `b0=1`)

| Quantity | Count | Decided empty? |
|---|---:|---|
| Outside-q affine opens | **29** | **0** |
| **Remaining opens** | **29** | — |

Prepared Stage-C chart package (separate, also not launched):  
`parallel/r66_stagec/` — `q0=1, b0=1`, 66 eqs / 42 vars, status
`PREPARED_NOT_RUN` (preferred msolve `-m 100`, 16 GiB fence, long wall).

### Residual summary

```text
Stage B remaining on D(H8):  34 / 34 undecided
Stage C remaining on D(H8):  29 / 29 undecided
Prepared Stage-B pair-split: 1 chart (counts toward the 34)
Total residual affine opens: 63
```

No chart has returned a completed exact unit ideal.

---

## 6. Success criteria (unit ideal vs nonverdict)

For the pair-split runner only (`run_pair_split.py`):

| Outcome | Runner status | Theorem scope |
|---|---|---|
| returncode 0, no resource stop, leading ideal unit (`[1]` / `[-1]` variants) | `PASS_EXACT_THIS_CHART_EMPTY` | **This affine chart only** (`q0=1,b1_0=1` Stage B r66) |
| timeout, RSS stop, crash, incomplete, missing leading, completed nonunit | `BOUNDED_NONVERDICT` | **no emptiness** |
| Signature mode / wrong field / nonhomogeneous rejection | nonverdict (already observed for `-q 1`) | **inapplicable** |

**Not authorized by one chart (or any partial cover):**

- `P25-DEGREE-EMPTY` / `PC25-DEGREE-EMPTY-SCOPED`
- characteristic-zero landing emptiness  
- Problem E headline  

Those require **complete** cover emptiness (all Stage-B 34 + Stage-C 29 on
`D(H8)`, plus already-closed `L8` / Stage A) **and** the sealed DVR transfer
hypothesis (empty complete prime-89 special fibre ⇒ char-0 empty), which is
not established.

---

## 7. Holdout / sequencing plan

1. **Holdout chart:** keep `q0=1, b1_0=1` as the first Stage-B residual until a
   completed unit or a documented nonverdict under the pair-cap fence.  
2. **Serialize heavy CAS:** at most one high-memory P25 job; never with COV
   m=1 chart CAS.  
3. **After this chart:** if unit, mark chart 0 empty and prepare the next
   MDS open (same r66 contractions, next paired flag). If nonverdict, either
   raise pair-cap/RSS carefully under a new sealed workdir or switch engine —
   do not reinterpret incomplete F4 as empty.  
4. **Stage C:** only after Stage B residuals shrink or a parallel resource
   window exists; Stage-C term count is ~2.88× the Stage-B neighbor.  
5. **Transfer:** only after the full special fibre is unit on every chart of
   the certified covers; then invoke the existing conditional DVR implication
   — never modular emptiness alone.

---

## 8. Light structural check (this session)

| Check | Result |
|---|---|
| `verify_mds_stageB_cover.py` | `PASS_INDEPENDENT_STAGEB_MDS34_COVER_REPLAY` |
| Heavy F4 / msolve | **not run** |

---

## 9. Files written / updated this session

| Path | Action |
|---|---|
| `LAUNCH_READINESS.md` (this file) | **created** |
| `parallel/r66_pair_split/verify_prepared_result.json` | refreshed by `verify_prepared.py` (memory snapshot) |
| `parallel/r66_pair_split/SEAL.json` | resealed after refresh |
| `parallel/determinantal_cover/verify_mds_stageB_cover_result.json` | refreshed by light cover replay |

No run artifacts under `r66_pair_split/`. No claim of `P25-DEGREE-EMPTY`.

---

## 10. One-line return

```text
READINESS: BLOCKED
  residual Stage-B opens: 34
  residual Stage-C opens: 29
  prepared pair-split: PREPARED_NOT_RUN (memory OK, ps census FAIL)
```
