# T9.1 — ordered binodal component (global presentation)

**Exit:** `T9-UNDECIDED`  
**Headline:** **OPEN**  
**Depends on:** `T9-HENSEL-NONUNIT-SEALED` (this directory)

---

## 1. Object

The ordered double-root incidence

```text
Y = V( P(u₁), P_u(u₁), P(u₂), P_u(u₂) )
  ⊂ A⁴_{A,B,Y,Z} × A²_{u₁,u₂},
```

saturated by

```text
(u₁ − u₂) · ℓ · C · G · P_uu(u₁) · P_uu(u₂) · δ(u₁) · δ(u₂).
```

Analytic input (`WORKORDER_CAS_T9_P25Z.md` §1.2) already proves that a **smooth
two-dimensional** component of this locus exists in characteristic zero, through
the Hensel point sealed in T9.0. The CAS task is a usable **global** presentation
of that generic component — not an explicit high-degree closed point.

**Theorem boundary (branch `B` vs fold algebra `S_G`).** The markers
`T-BRANCH-BINODAL-DIVISOR`, `T-BRANCH-NONNORMAL`, and
`T-FOLD-LOCAL-NORMALIZATION-AT-BINODAL` concern the target branch `B`. They do
**not** assert that `S_G` is globally normal or nonnormal. This packet does not
touch `T-NONNORMAL` or `dim Sing(S_G)`.

---

## 2. Local structure at the Hensel point (recomputed)

At L4 / `p = 101`, point `(A,B,Y,Z,u₁,u₂) = (36,55,77,80,46,72)`:

| Fact | Value |
|---|---|
| Jacobian `∂(E₁…E₄)/∂(A,B,Y,Z,u₁,u₂)` rank | **4** |
| Nullspace dimension (tangent space) | **2** |
| Good Noether pairs among `{A,B,Y,Z}` | all six pairs (étale-local) |
| Preferred parameters | `(A, B)` (local det `86`) |
| RREF free variables | `(u₁, u₂)` (also étale-local) |

So every coordinate pair among `A,B,Y,Z` can serve as local Noether parameters;
`(u₁,u₂)` is free for the formal graph of `(A,B,Y,Z)`.

---

## 3. Modular degree floor (why the solve did not close)

| Probe (mod `101`) | Degree / count | Interpretation |
|---|---:|---|
| Fibre of raw 4 eqs over fixed `(u₁,u₂)=(46,72)` | **2758** | projection to `(u₁,u₂)` is finite but high degree |
| Fibre of raw 4 eqs + `(u₁−u₂)w−1` over fixed `(A,B)=(36,55)` | **496** | better Noether chart; still includes `G=0` points |
| Brute `(Y,Z)` scan at `(A,B)=(36,55)`: binodal | 10 | `deg gcd(P,P_u) ≥ 2` |
| Same scan with `H = 0` | 6 | `H=0` cuts some but not all raw binodal fibres |

**Corrections carried:**

1. The raw plane system is **positive-dimensional along the diagonal `u₁ = u₂`**
   — saturation by `(u₁−u₂)` is mandatory.
2. The degree-~2000–2700 systems **contain `G = 0` points** — factor selection
   at the Hensel point must discard them before char-0 reconstruction.
3. On the open `G ≠ 0`, two distinct double roots already force `Res = 0` and
   hence `H = 0`; `H` is needed primarily to cut components supported on `G = 0`.

A fully specialized plane-section RUR of degree ~2000 was **not** repeated
(forbidden as a nonunit certificate; permitted only as factor-selection aid).

---

## 4. What was attempted / not attempted

**Done:**

- Local Jacobian/nullspace and Noether pair selection from the verified point.
- Modular fibre-degree probes via `msolve` (correct single-line poly format).
- Preflight with ring, term counts, expected dimension, checkpoint plan,
  certificate type, and verifier design (`preflight_t91.json`).
- Preferred next chart: finite algebra over `Q[A,B]` after modular isolation
  of the Hensel factor in the degree-496 fibre.

**Not done (floor):**

- Multi-modular isolation of the monic factor through the Hensel point.
- CRT / rational reconstruction of a function-field RUR or finite
  `Q[A,B]`-algebra.
- Exact residual verification of such a presentation over `Q(t₁,t₂)`.

No component was manufactured. The heavy memory slot was **not** consumed
(no credible finite matrix floor with bounded size was available for a 64 GiB
authorization under the work-order rule).

---

## 5. Smallest unresolved computation

```text
Isolate the monic factor of the degree-496 AB-fibre eliminant at the Hensel
point across enough primes; CRT to a presentation over Q(A,B); certify a
finite Q[A,B]-algebra (or RUR) for the ordered binodal component after gate
saturation; verify dim 2, generic root distinctness, gates, and
transversality of dh₁, dh₂.
```

---

## 6. Artifacts

| File | Role |
|---|---|
| `preflight_t91.json` | measured floor, checkpoint plan, verifier design |
| `noether_parameters.json` | preferred `(A,B)` and alternatives |
| `component_presentation.json` | machine status: no closed char-0 presentation |
| `verify_component.py` | recomputes local Jacobian rank and modular degree claims |
| `BINODAL_COMPONENT.md` | this note |

Work products under `tmp/t9_component/` (msolve inputs/outputs, probes).

---

## 7. Exit

```text
T9-UNDECIDED
```

Successful exit under work order §8.13: T9.0 sealed; T9.1 floor named; no
fabricated component.

**Headline:** **OPEN**
