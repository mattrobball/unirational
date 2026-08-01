# Audit A1 — theorem-boundary audit of standing exits

**Exit:** `AUDIT-A1-COMPLETE`  
**Headline:** **OPEN**  
**Worker:** A (work order `WORKORDER_CAS_T11_P25V_C3.md` §7)

## What this packet is

This directory contains **no new mathematics**. It records an independent
**claims-about-claims** audit of every standing exit marker named in the
Worker A brief: whether each marker’s packet actually supports, at the stated
scope, what its marker and prose assert.

## What was not done

- No new solves, Gröbner bases, reconstructions, or searches.
- Existing verifier scripts and JSON certificates were **read** (and, where
  already present, their sealed verifier reports were inspected) to see *what*
  they recompute; no producer recomputation was launched.
- No narrative files (`CURRENT_PATHS.md`, `SPEC.md`, `HANDOFF.md`,
  `RESOLUTION.md`, `REPAIR.md`, `DIRECTOR_HANDOFF.md`, work orders) were
  edited.
- No sealed packet was edited. Findings live only here.

## Contents

| File | Role |
|---|---|
| `AUDIT_FINDINGS.md` | human-readable verdicts, ranked by consequence |
| `audit_findings.json` | machine-readable copy with severities |
| `README.md` | this note |

## Verdict vocabulary

| Tag | Meaning |
|---|---|
| `SOUND` | claim matches sealed computation / honest undecided scope |
| `SCOPE-DRIFT` | computation exists but prose/marker overstates domain |
| `UNSUPPORTED` | decisive number or identity has no matching computation |
| `UNCITED-HYPOTHESIS` | argument relies on a premise not discharged in the cited artifact |

Problem E remains **OPEN**.
