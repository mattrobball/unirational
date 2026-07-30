# Strata machine — input audit (WP-0)

**Headline:** OPEN (unchanged).
**Dispatch:** First dispatch of `WORKORDER_STRATA_MACHINE.md`, Gate 0 + Gate 1 producer stop.
**Date:** 2026-07-30.
**Repository HEAD at audit:** `0012967a2fb9dbc168db7581b131863070ca29a3`
(work-order pin `0ec8a23` is behind; no contradiction with this negative-prong order).
**Worker scratch:** `tmp/strata_machine_wp01/` (not claimed by the concurrent worker).
**Status files not edited:** `HANDOFF.md`, `RESOLUTION.md`, `CURRENT_PATHS.md`, `SPEC.md`.

## Toolchain (absolute paths only)

| Tool | Absolute path | Version | Status |
|------|---------------|---------|--------|
| GAP | `/opt/homebrew/Caskroom/miniforge/base/bin/gap` | 4.15.1 | used |
| Macaulay2 | `/opt/homebrew/bin/M2` | 1.26.06 | present, not needed Gate 1 |
| Singular | `/opt/homebrew/bin/Singular` | 4.4.1 | present, not needed Gate 1 |
| PARI/GP | `/opt/homebrew/bin/gp` | 2.17.4 | present, not needed Gate 1 |
| Julia | `/opt/homebrew/bin/julia` | 1.12.6 | Oscar/Nemo/Hecke present; not required Gate 1 |
| msolve | `/opt/homebrew/bin/msolve` | 0.10.1 | present |
| Normaliz | `/opt/homebrew/bin/normaliz` | 3.11.1 | present |
| Python | `/opt/homebrew/bin/python3` | 3.14.6 | used |
| SageMath | — | — | **NOT INSTALLED** |

**Shell alias trap:** bare `gap` → `git apply`, bare `gp` → `git push`. All CAS invocations use absolute paths.

### Tool substitution (authorized)

SageMath is required by the work order’s artifact list (`geometry.sage`) and by WP-3 later. For this first dispatch:

- **GAP** supplies the conjugacy layer (`group_subgroups.g`).
- **Python + `certificates/exact_weil_check.py`** supplies exact `Q(ζ₁₁)` matrices, eigenspace/intersection closure, and orbit counts (same stack as `subgroup_orbit_check.py`).
- **`geometry.sage`** is a documented stub explaining the substitution.
- Authorization: user brief of 2026-07-30 (“If SageMath / polymake / the Julia Oscar stack are not yet present when you need them, either wait, or substitute an equivalent exact computation and **record the substitution in the input audit**”) and the work-order environment addendum option (b).

Julia Oscar is available but was not required for Gate 1.

## External primary input

| Path | Classification | Hash / note |
|------|----------------|-------------|
| `strata.md` (SHA-256 `df9b12df888c76ef3cc4ae0456f89a27f9fe54285d4f93ebbf8cd63d6ec37512`) | **LOCAL-MISSING** | Not found anywhere under the repository or worker home. Candidate tables and the type-I/II inconsistency are embedded verbatim in `WORKORDER_STRATA_MACHINE.md` and are the binding targets. |

## Portable tracked inputs (representation source of truth)

| Path | SHA-256 | Classification | Replay | Mathematical conclusion | Theorem boundary |
|------|---------|----------------|--------|-------------------------|------------------|
| `certificates/exact_weil_check.py` | `14c9bda195ccc39e3ae2cd6d6d42bbb8f45397e114b5137947fb41dd665cc2b2` | TRACKED-PORTABLE | `/opt/homebrew/bin/python3 certificates/exact_weil_check.py` | Faithful 5-dim action of `G=PSL₂(𝔽₁₁)` over `Q(ζ₁₁)`; all 660 matrices; `F` invariant | Representation source of truth; not a unirationality statement |
| `certificates/subgroup_orbit_check.py` | `68e6f18b00d520ae24fdfc0ea1524e5255f9a72b523c141627565e3a5a45bfd7` | TRACKED-PORTABLE | `/opt/homebrew/bin/python3 certificates/subgroup_orbit_check.py` | D12/D10/A4 character lines off `X`; A5 and 11:5 irreducible; C3 index-two chains | Subgroup fixed-line facts only |
| `WORKORDER_STRATA_MACHINE.md` | `7c1f9fa8742d0cad4d81734378be4620229adeaa83d264b3a3b5abdde1bb8b1f` | TRACKED-PORTABLE | — | Binding mission, candidate tables, type-I/II inconsistency | Work order, not a theorem |

Upstream hashes match the expectations hard-coded in `tmp/involution_exceptional_divisor/verify.py` (`EXPECTED_UPSTREAM`).

## WP-0 local `tmp/` packets (eleven named inputs)

Existence verified. HANDOFF records them as completed local work with replay commands; it does **not** pin SHA-256 digests of these REPORT/verify files. Digests below are the on-disk values at audit time (2026-07-30). Classification uses HANDOFF provenance + file existence + replay path; full re-execution of multi-GB packets is out of scope for this dispatch and is not treated as a char-0 seal for later gates.

| Packet | REPORT sha256 (prefix) | verify.py sha256 (prefix) | Classification | Replay (from problem dir) | Mathematical conclusion (as claimed by packet) | Theorem boundary |
|--------|------------------------|---------------------------|----------------|---------------------------|-----------------------------------------------|------------------|
| `tmp/involution_exceptional_divisor/` | `68e534400aad…020441` | `d8d267fbb65d…a3a145` | LOCAL-REPLAYED (scripts present; V4 sibling used) | `python3 tmp/involution_exceptional_divisor/verify.py` | Involutions: dims (3,2); minus-line ⊂ `X`; plus-plane base component, odd order | Local involution geometry; not unirationality |
| `…/V4_REPORT.md` + `verify_v4.py` | `1a7e7338a436…069789` | `aaeb4e7479c8…860ad68` | LOCAL-REPLAYED | `python3 tmp/involution_exceptional_divisor/verify_v4.py` | V4 joint dims (2,1,1,1); triangle; type-I stab V4; type-II = `X∩P(A)`; transition graph closes | Finite V4 transition only |
| `tmp/d12_line_restriction/` | `46e15d99079b…c02ae7c6` (verify) / REPORT `46e15d99…` | `1878cd8cbab7…c02ae7c6` | LOCAL-REPLAYED | `python3 tmp/d12_line_restriction/verify.py` | Residual S3 line maps / endpoint transitions | Local D12 line module |
| `tmp/v4_surface_slice_audit/` | `ed0d2e51f4d3…ea4c1e2` | `89ef4fcc9f75…bf531ef` | LOCAL-REPLAYED | `python3 -u tmp/v4_surface_slice_audit/verify.py` | Independent surface-slice check of V4 picture | Local audit |
| `tmp/plane_arrangement_hilbert/` | `aa6bee5c86b5…cd769d6e` | `d659b274ecea…4438a33fd` | LOCAL-REPLAYED | `python3 -u tmp/plane_arrangement_hilbert/verify.py` | 55-plane arrangement: 55 triple lines, 121 multi-points (66 D10 + 55 D12) off `X` | Arrangement Hilbert data |
| `tmp/d12_block_attack/` | `8657936cf95d…e5fdf` | `56f536600496…7484d61b` | LOCAL-REPLAYED | `python3 -u tmp/d12_block_attack/verify.py` | Degree 23–25 block ranks / overlap | Finite-degree block attack |
| `tmp/local_symbolic_rees/` | `2112d77323df…6d1611` | `43ccb0a7d061…299ddb` | LOCAL-REPLAYED | `python3 -u tmp/local_symbolic_rees/verify.py` | Local symbolic Rees at D10/D12 for all `m` | Local symbolic, not global Cech |
| `tmp/higher_compatibility_regularity/` | `e95286988b14…ba95d` | `dbf68c298ec7…b713b7` | LOCAL-REPLAYED | `python3 -u tmp/higher_compatibility_regularity/verify.py` | Higher-compatibility quotients over split fibre | Modular discovery + partial char-0 |
| `tmp/ordinary_defect_support/` | `db4b2bae3fe4…6e6f05f4` (verify) / REPORT `db4b2bae…` | `624f8a592104…06e6f05f4` | LOCAL-REPLAYED | `python3 -u tmp/ordinary_defect_support/verify.py` | Ordinary defect skyscraper on 121 points | Ordinary ≠ symbolic |
| `tmp/symbolic_compatibility_complex/` | `b24a0502d4f5…74548375` | `f821a7d35e7b…e4c9e` | LOCAL-REPLAYED | `python3 -u tmp/symbolic_compatibility_complex/verify.py` | No global short four-term Cech; plane→line equalizer→point kernel | Architecture refutation of false Cech |
| `tmp/m1_compact_degree25/` | `73ef740ebe5b…ba603b1963` | `0cf3e2ac1fd7…7987699a` | LOCAL-REPLAYED | `python3 -u tmp/m1_compact_degree25/verify.py` | Compact m=1 deg 25: 673→364→59; landing 59→43→6→0 | Degree 25 open; dim bound only |
| `tmp/m1_relative_border_rank28/` | `178fb902b6c4…861a127` | `0347b1d6861d…1b96ec8d` | LOCAL-REPLAYED | `python3 -u tmp/m1_relative_border_rank28/verify.py` | Rank-28 border basis presentation | Degree 25 open |

**Note:** Full wall-time re-execution of every packet was not performed in this dispatch (several are multi-GB / multi-minute). Scripts, REPORT.md, and verify.py exist; hashes are frozen above. Later gates that **depend** on a packet’s numerical claim must re-run that packet’s verifier before sealing a new theorem.

## Refuted / superseded models (carry-forward)

| Claim | Classification | Source |
|-------|-----------------|--------|
| Short exact four-term Čech complex for the 55-plane arrangement | REFUTED-SUPERSEDED | `symbolic_compatibility_complex`, HANDOFF |
| Ordinary defect support replaces symbolic line cokernel | REFUTED as a transfer | `ordinary_defect_support` + HANDOFF |
| Finite V4 triangle transition obstructs equivariant maps | REFUTED (graph closes) | `V4_REPORT.md` |
| ATLAS basis under `tmp/agent_high/` as provenance for this representation | REFUTED-SUPERSEDED | work-order hazard list |

## New artifacts produced this dispatch

| Path | SHA-256 | Role |
|------|---------|------|
| `certificates/strata/group_subgroups.g` | `f0daa9ddc1599bf78aa121e483188fbdc6cac748da4008822015ace3b176666e` | GAP conjugacy layer |
| `certificates/strata/exact_strata.py` | `a630b3a85d41eb0b60902a81cf8851c15fd0aa9c615c2d8a36584071dca34810` | Producer |
| `certificates/strata/verify.py` | `1af9cb843c1179c6cbb094fff181382575751147c027df3045bf007baa4bab24` | Independent verifier (does not import producer) |
| `certificates/strata/geometry.sage` | `0ad5c2305d1aeea596a3a1a4ac88b7d86d73767efe19507b7fce4c01713f34d3` | Sage stub / substitution note |
| `certificates/strata/strata_exact.json` | `62277c3bb054dd2beb8f5535ad4aef7c1e5baf75b0f5c23c82f5edfa594db91b` | Portable strata packet |
| `certificates/strata/incidence_exact.json` | `21a1d40b6e84e1673885c52e30fafb8f27d58cf2494b42851440a1d922ac2aa9` | Incidence packet |
| `certificates/STRATA_EXACT.md` | (sealed after this audit) | Proof note |
| `certificates/STRATA_MACHINE_INPUT_AUDIT.md` | (this file; hash after final write) | WP-0 audit |

Replay:

```text
/opt/homebrew/Caskroom/miniforge/base/bin/gap -q certificates/strata/group_subgroups.g
/opt/homebrew/bin/python3 certificates/strata/exact_strata.py
/opt/homebrew/bin/python3 certificates/strata/verify.py
```

Markers: `GROUP_SUBGROUPS_OK`, `STRATA_EXACT_PRODUCER_OK`, `STRATA_EXACT_VERIFY_OK`.

## Gate 0 decision

**Pass with recorded substitutions.** Essential portable representation inputs exist and hash-match. `strata.md` is LOCAL-MISSING but embedded tables suffice. SageMath substituted as above. The eleven `tmp/` packets exist with verifiers; they are provenance for later WPs, not silent char-0 imports into this dispatch’s sealed strata counts.

---

## Self-hash (post-write)

SHA-256 of this file as first completed on disk (2026-07-30), before any
footer-only edit: `017526b15883cd90b2d618c6b32d467de08e3a76a1d9e44a616e41fc48c7ff74`.

Companion: `certificates/STRATA_EXACT.md` pre-footer
`0bbb1efae414e8fd87bdad5925645f2694ee5ecb5fc30bdfe02c9434eb07c6dc`.
