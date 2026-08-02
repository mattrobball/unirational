# G3H replay

From the problem root `problems/E-klein-cubic`:

```sh
# Sealed phases 1–4 + original phase 5 decision
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/produce_all.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_all.py

# Phase 5 next: expand a_i, polar data, L_i-point hunt, Springer decision
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/produce_phase5_next.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/verify_phase5_next.py
```

Independent phase verifiers (no import of producers):

```sh
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase1.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase2.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase3.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase4.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/verify_phase5.py
python3 -u goal_runs_after_eb21458/G3H_A5_SEMILINEAR_SPRINGER/phase5_springer_next/verify_phase5_next.py
```

Expected markers:

```text
G3H-G7B-QUARANTINE-PASS
G3H-CUBIC-COMPRESSION-PASS
G3H-SEMILINEAR-LANDING-PASS
G3H-SEMILINEAR-G3-FRAME-PASS
G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED
G3H-AI-EXPANSION-DUAL-PASS
G3H_VERIFY_ALL_OK
G3H_PHASE5_NEXT_OK
```

Primary STATUS exit:

```text
G3H-SEMILINEAR-G3-FRAME-PASS
```

(with phase-5 scoped no-go and phase5_next dual-expansion pass; no Springer
reduction claim; residual gates named in STATUS).
