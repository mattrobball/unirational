# P25 landing support — launch readiness (finite CAS front)

**Date:** 2026-08-02  
**Exit (overall):** `P25-UNDECIDED`  
**Pair-split package:** `parallel/r66_pair_split/`  
**Package status:** `PREPARED_NOT_RUN` / `SEALED_PREPARED_NOT_RUN`  
**Readiness verdict:** **`BLOCKED`** (not `LAUNCH_OK`) — technical non-`ps` path **exists**; live competing **COV** msolve blocks safe launch  
**Chart run outcome:** **none** (no msolve child spawned for P25 pair-split)

This note is readiness + light verification + runner repair. No multi-hour /
multi-GB F4 job was launched for P25 (COV was already heavy).

---

## 1. Mission answers (this session)

### 1.1 Non-runner / non-`ps` fail-safe path — **FOUND**

Sandbox still denies `ps` (`Operation not permitted`). That is **no longer** a
binding blocker for the pair-split runner.

| Mechanism | Purpose | Status |
|---|---|---|
| `libproc.proc_pidinfo` (PROC_PIDTASKINFO) | live RSS of msolve leader / group | **works** |
| `libproc.proc_listpids` + `PROC_PIDTBSDINFO` | process census (pid/ppid/pgid) | **works** |
| `sysctl(KERN_PROCARGS2)` | argv strings for competing-CAS markers | **works** (best-effort) |
| `vm_stat` free+speculative | prelaunch memory gate | **works** |
| fail-closed | any census/RSS failure → stop / refuse | **kept** |

This matches the pattern already used by `r66_stagec/run_guarded.py` and other
P25 `run_bounded*.py` helpers. Aggregate process-group RSS sums libproc rows
sharing the child `pgid` (fallback: leader-only).

**Honest impossibility claim:** a `ps`-only launch path remains impossible in
this sandbox. A **libproc** launch path is possible and implemented.

### 1.2 Fence proposal — **16 GiB default (flag 8–32); 4.5 GiB retired**

Hard review is accepted: **4.5 GiB is theater** after the incomplete stop at
~**4.275 GiB** (`4,482,960 KiB`). Raising by 230 MiB does not constitute a
completion plan on a 128 GiB host.

| Parameter | Old (theater) | New default | Flag range |
|---|---:|---:|---|
| RSS hard stop | 4.5 GiB | **16 GiB** | **[8, 32] GiB** |
| Wall timeout | 1200 s | **1200 s** | **[60, 3600] s** |
| Threads | 4 | 4 | fixed |
| Prelaunch free+spec | ≥14 GiB | ≥14 GiB | fixed |
| Pair cap | `-m 100` | `-m 100` | fixed (source seal) |

CLI (after gates):

```sh
/opt/homebrew/bin/python3 -u \
  .../parallel/r66_pair_split/run_pair_split.py \
  --confirm-parent-notified \
  --rss-gib 16 \
  --timeout-seconds 1200
```

### 1.3 Single-chart launch — **not executed**

Would be safe only if: memory gate pass, **no competing CAS**, parent
attestation. Observed competing COV_M1 deg-35 msolve (~3.5 GiB RSS) →
`BLOCKED_COMPETING_PROBE_GATE` if launch were attempted. Mission: prefer
alternate structural attack when COV is heavy → **no P25 F4 spawn**.

### 1.4 Alternate attack doc

See `ALTERNATE_ATTACK.md` (Rank A secondary splits, Rank C Fitting/weight
strata, engine notes, sequencing).

---

## 2. Prepared input verification (this session)

From

```text
goals_2026-08-01/P25_LANDING_SUPPORT/parallel/r66_pair_split/
```

| Step | Command | Result |
|---|---|---|
| Prepare audit | `/opt/homebrew/bin/python3 verify_prepared.py` | `PREPARED_NOT_RUN` (exit 0); process backend available |
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

---

## 3. Exact launch command (when gates pass)

**Do not launch while any COV/P25 competing msolve/singular is live.**

```sh
/opt/homebrew/bin/python3 -u \
  /Users/worker/unirational/problems/E-klein-cubic/goals_2026-08-01/P25_LANDING_SUPPORT/parallel/r66_pair_split/run_pair_split.py \
  --confirm-parent-notified \
  --rss-gib 16 \
  --timeout-seconds 1200
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

## 4. Expected memory / resource plan (RSS)

| Fence / estimate | Value |
|---|---:|
| Runner RSS hard stop (default) | **16 GiB** |
| Allowed `--rss-gib` | **8–32** |
| Wall timeout (default) | **1200 s** (flag up to 3600) |
| Threads | **4** |
| Pre-launch free+speculative minimum | **14 GiB** |
| Prior ordinary F4 (`-m 0`) on same chart | degree 5 complete; entered 1708-pair degree-6; **manual stop at ~4.28 GiB RSS** after ~549 s — **strict nonverdict** |
| Pair-cap intent (`-m 100`) | caps pairs per F4 matrix so the 1708-pair degree-6 batch cannot enter one matrix; **not** a fixed 18-block partition |
| Host RAM | 128 GiB |
| This-session free+speculative (vm_stat) | **~93 GiB** → memory gate **PASS** |
| Competing CAS (libproc census) | **live non-ancestor msolve and/or Singular** (session saw COV msolve ~3.5 GiB, later Singular ~0.4 GiB) → process gate **FAIL** |

**RSS monitoring plan (fail-closed, no `ps`):**

1. Before spawn: `vm_stat` free+speculative ≥ 14 GiB.  
2. Before spawn: live **libproc** census succeeds.  
3. Before spawn: no competing CAS markers (`msolve` / `singular` /
   `run_bounded` / `run_pair_split` / related), except documented shared
   Singular PID 13036 if still the historical boundary job.  
4. During run: poll process-group RSS every 0.25 s via libproc; stop on
   RSS > fence or wall > timeout or any poll failure
   (`rss_poll_unavailable`).  
5. Host policy: at most one high-memory job; **never** co-schedule with
   heavy COV m=1 chart CAS.

---

## 5. Launch gates — this session

| Gate | Required | Observed | Pass? |
|---|---|---|---|
| Prepared source + seal | `PREPARED_NOT_RUN` sealed | verified + resealed | **yes** |
| Free+speculative memory | ≥ 14 GiB | ~93 GiB | **yes** |
| Live process census | available + no competing probes | libproc **available**; **COV msolve competing** | **no** |
| Parent notification / mission | single chart only if safe | COV heavy → no launch | **blocks launch** |
| Fence realism | not theater | 16 GiB default (4.5 retired) | **yes** |

**Verdict: `BLOCKED`.**  
Non-`ps` path removes the old census impossibility. Runtime safety still
fails on competing COV. No P25 CAS child was spawned.

---

## 6. Residual chart list on `D(H8)` (from STATUS / cover certs)

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

Cover replay this session:

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
`PREPARED_NOT_RUN` (preferred msolve `-m 100`, long wall / large fence).

### Residual summary

```text
Stage B remaining on D(H8):  34 / 34 undecided
Stage C remaining on D(H8):  29 / 29 undecided
Prepared Stage-B pair-split: 1 chart (counts toward the 34)
Total residual affine opens: 63
```

No chart has returned a completed exact unit ideal.

---

## 7. Success criteria (unit ideal vs nonverdict)

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

## 8. Light structural check (this session)

| Check | Result |
|---|---|
| `verify_mds_stageB_cover.py` | `PASS_INDEPENDENT_STAGEB_MDS34_COVER_REPLAY` |
| libproc census self-test | available; competing COV detected |
| Heavy F4 / msolve (P25) | **not run** |

---

## 9. Files written / updated this session

| Path | Action |
|---|---|
| `LAUNCH_READINESS.md` (this file) | **rewritten** |
| `ALTERNATE_ATTACK.md` | **created** (ranked non-F4 / shrink-chart plan) |
| `parallel/r66_pair_split/run_pair_split.py` | **rewritten**: libproc+sysctl census/RSS; `--rss-gib` / `--timeout-seconds`; default 16 GiB |
| `parallel/r66_pair_split/verify_prepared.py` | **updated** for new backend + fence fields |
| `parallel/r66_pair_split/verify_prepared_result.json` | refreshed (no merge conflict; live gates) |
| `parallel/r66_pair_split/SEAL.json` | resealed |
| `parallel/determinantal_cover/verify_mds_stageB_cover_result.json` | refreshed by light cover replay |

No run artifacts under `r66_pair_split/`. No claim of `P25-DEGREE-EMPTY`.

---

## 10. One-line return

```text
READINESS: BLOCKED
  non-ps launch path: OK (libproc)
  fence: 16 GiB default (4.5 theater retired)
  residual Stage-B opens: 34
  residual Stage-C opens: 29
  prepared pair-split: PREPARED_NOT_RUN
  chart run: none (COV msolve competing)
  alternate: ALTERNATE_ATTACK.md
```
