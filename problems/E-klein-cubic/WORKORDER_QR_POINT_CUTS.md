# WORKORDER — The 60-point conditions on the QR-degree window cells

Issued 2026-08-12 (director). Mechanical pinned-spec lane (Grok).
python3 only (never gap/gp/sage/magma — shell aliases trap); primes
331, 661; no git; packet `goal_runs_20260812/QR_POINT_CUTS/` only.

Context: `goal_runs_20260812/L12_ORDER11` (referee-confirmed, sealed)
proves all 60 C11-points lie in `Bs(T)` at EVERY degree; the sealed
window cells at QR degrees (`d = 36, 37, 38, 42`; dims 63/121/151/397
per `goal_runs_20260812/LANDING_SWEEP`) were built WITHOUT those point
conditions (the old B(C11) forced them only at non-residues).

Tasks:
1. Rebuild the window cells at `d ∈ {35, 36, 37, 38, 42}` with the D34
   ladder engine (`goal_runs_20260811/D34_GUIDED_SWEEP`: slicelib,
   d34lib.point_block, produce_d34 recipes; the LANDING_SWEEP packet
   has the per-degree drivers). Anchor: the sealed dims 39/63/121/151/
   397 must reproduce exactly (fatal).
2. The 60 C11-points: all eigenpoints of the order-11 elements of the
   frame's 660 matrices (collect, dedupe projectively; count must be
   exactly 60; they fall in 12 eigenframes of 5 — verify).
3. Impose `T(p) = 0` at all 60 points (evaluation rows via
   `point_block`) on each cell; report rank and new dim, both primes,
   saturation-checked (adding the points twice changes nothing).
   CONTROL (fatal): at `d = 35` (non-residue) the rank must be 0 — the
   ladder already forced these points there.
4. Re-issue the alive table `d = 34..42` with the new dims at the QR
   degrees (NQR rows unchanged; say so). If any new dim is 0: that
   window closes at the linear layer — FLAG behind an ODDZERO-standard
   audit, never claim.

Packet protocol as standard (`THEOREM.md` — never REPORT.md — scripts/,
results/, replayable `verifier.py`, `REGISTRATION_SNIPPET.md`, ODDZERO
format, entry E56, goal_run, tracked true; tiering; exits `QRCUT-*`;
"Not claimed"; headline "Problem E remains OPEN; this packet excludes
no degree"). Summary ≤ 20 lines: control status, per-degree
rank/new-dim table, the re-issued alive table, flags.
