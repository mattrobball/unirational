# Goal V return bundle

This directory is the isolated result for
`../GOAL_V_VALUATION_TROPICAL_POINTLESSNESS.md`.

The exact exit is `V-UNDECIDED`.  The route proves that every local index is
one, retires five full-twist covariant divisors, proves every ramified or
closed-residue valuation locally soluble, and rules out empty
tropicalization in every rank.  It does not prove a local nonpoint of the
genuine twist.

It also imports, at its exact scope, the independently replayed theorem that
all standard successive complete-DVR fields of geometric Parshin chains of
length three or four are locally soluble.

## Files

| File | Role |
|---|---|
| `STATUS.md` | exact exit and requirement audit |
| `THEOREM.md` | concise statements and proof boundaries |
| `MODEL.md` | genuine-twist model, local index theorem, divisor bridge, tropical lemma |
| `VALUATION_CENSUS.md` | scope-aware census of named valuations |
| `proof_payload.json` | machine-readable theorem and bounded-search ledger |
| `inertia_centralizers.json` | exact centralizer/inertia classification payload |
| `produce.py` | deterministic producer/replay; no file writes |
| `verify.py` | independent verifier of load-bearing exact computations |
| `verify_inertia_centralizers.py` | independent 660-element centralizer and stable-line verifier |
| `explore_diagonal_divisors.py` | exact sparse diagonal/base-locus audit |
| `search_constant_residue_points.py` | five-frame constant-coordinate residue screen |
| `search_full_frame_bounded.py` | complete bounded homogeneous five-frame screen |
| `SEAL.json` | hashes of this packet and authoritative upstream inputs |

## Default replay

From `problems/E-klein-cubic/goals_2026-08-01`:

```bash
python3 V_VALUATION_TROPICAL/produce.py
python3 V_VALUATION_TROPICAL/verify.py
python3 V_VALUATION_TROPICAL/verify_inertia_centralizers.py
```

Required markers:

```text
GOAL_V_PAYLOAD_PRODUCER_ACCEPT
GOAL_V_INDEPENDENT_VERIFY_ACCEPT
GOAL_V_INERTIA_CENTRALIZERS_ACCEPT
```

The producer includes the exact constant-coordinate screens at `f5` and
`f6`.  The independent verifiers reconstruct the 35-term support, all five
primitive base gcds, diagonal degrees/identities, local-index arithmetic,
tropical combinatorics, the full group centralizer census, the stable
involution line, and the candidate dimensions in the bounded ledger.
The sealed upstream audit also binds the independently replayed `f5`
Hessian-kernel noncube certificate; its strict scope is one canonical line,
not the full residue cubic.

## Optional bounded replay

The complete bounded computations can be rerun explicitly:

```bash
python3 -u V_VALUATION_TROPICAL/search_full_frame_bounded.py \
  --target 5 --lower 1 --upper 15 --timeout 300
python3 -u V_VALUATION_TROPICAL/search_full_frame_bounded.py \
  --target 6 --lower 1 --upper 14 --timeout 300
python3 -u V_VALUATION_TROPICAL/search_full_frame_bounded.py \
  --target 6 --lower 15 --upper 15 --timeout 10
python3 -u V_VALUATION_TROPICAL/search_full_frame_bounded.py \
  --target 5 --lower 16 --upper 16 --timeout 300
```

The last two frontier commands end in `TIMEOUT_NONVERDICT`; they are retained
to prevent accidental relabeling of degree 15 at `f6` or degree 16 at `f5`
as exclusions.  None of these bounded commands is evidence for an all-degree
theorem.
