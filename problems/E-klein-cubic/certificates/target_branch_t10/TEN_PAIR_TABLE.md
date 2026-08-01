# T10.1 — Ten coordinate-pair modular fibres of `I_sing` on `S_G`

**Exit:** `T10-FOLD-UNDECIDED`  
**Headline:** **OPEN**  
**Object:** fold algebra `S_G` (not the target branch `B`)  
**Depends on:** sealed `P`, gates T2R4-PASS, `S_2` of `S_G`

---

## 1. Criterion (§1.7 work order)

```text
S_G = ( Q[A,B,Y,Z,u] / (P, P_u) ) [ (ell · P_uu · C · delta · G)^{-1} ]
I_sing = (P, P_u, P_A, P_B, P_Y, P_Z)
```

The fold has dimension three. A codimension-one singular component has
dimension two and is generated in function field by some pair among
`A,B,Y,Z,u`. Hence

```text
dim Sing(S_G) ≤ 1   iff   all ten generic fibres over Q(x_i,x_j) are empty
                          after gate saturation.
```

One nonempty generic fibre yields a finite algebra over `Q(x_i,x_j)` and
exhibits a two-dimensional singular component (`T10-FOLD-HEIGHT1`).

**Affine sections are not dimension certificates.** Random modular fibres are
**discovery only** until an exact char-0 algebra is sealed.

---

## 2. Modular method (discovery)

For each pair `(x_i,x_j)` and primes `p ∈ {101,103,107}`:

1. Specialize free pair to 5 random values in `F_p` (skip constant-gate deaths).
2. Form `I_sing` in the remaining three variables.
3. Saturate by Rabinowitsch product
   `ell · C · L · M · Q4 · P_uu · delta` with `L = A−15`, `M = B`
   (factorwise lesson retained for exact work; modular product is discovery-safe).
4. Run `/opt/homebrew/bin/msolve` solve-mode; record empty / zero-dim degree.

**Full-G certification** (specialized `G = Res_u(P,P_u)/H` in the product):

| Pair | Free vals (p=101) | Degree with full G |
|---|---|---:|
| `(A,Y)` | `(65,53)` | **9** |
| `(A,B)` | `(49,68)` | **12** |

`(A,u)` skipped for full-G poly construction (`u` free); degree-6 modular
campaign still used the partial gate product above.

Producer: `tmp/t10_modular/produce_modular_fibres.py`  
Machine table: `modular_fibre_table.json`

---

## 3. The ten-pair table

| Pair | Modular verdict | Degree samples (p=101/103/107) | Median deg | Exact cost estimate | Credible 64 GiB floor? |
|---|---|---|---:|---|---|
| `(A,u)` | **nonempty** all primes | 6 / 6 / 6 | **6** | exact finite algebra over `Q(A,u)` deg ~6; parametric GB over frac field | **yes (cheapest)** |
| `(A,Y)` | **nonempty** all primes | 9 / 6–9 / 9 | **9** | RUR over `Q(A,Y)`; full-G cert deg 9 | yes |
| `(A,B)` | **nonempty** all primes | 12 / 12 / 12 | **12** | RUR over `Q(A,B)`; full-G cert deg 12 | yes |
| `(A,Z)` | nonempty (1 bad trial @107) | 12 / 12 / 11–12 | **12** | RUR over `Q(A,Z)` | yes |
| `(Y,u)` | **nonempty** all primes | 12 / 11–12 / 11–12 | **12** | RUR over `Q(Y,u)` | yes |
| `(B,u)` | **nonempty** all primes | 16 / 15–16 / 16 | **16** | RUR deg ~16 | borderline |
| `(Z,u)` | **nonempty** all primes | 16 / 15–16 / 16 | **16** | RUR deg ~16 | borderline |
| `(B,Y)` | **nonempty** all primes | 17 / 17 / 17 | **17** | RUR deg ~17 | borderline |
| `(Y,Z)` | **nonempty** all primes | 18 / 15–17 / 18 | **18** | RUR deg ~18 | higher |
| `(B,Z)` | **nonempty** all primes | 24 / 22 / 24 | **24** | RUR deg ~24 | higher |

**Interpretation (modular discovery only).** Every pair shows consistently
nonempty specialized fibres of stable positive degree after gate saturation.
This is the modular signature of a **two-dimensional** component of
`Sing(S_G)` projecting dominantly onto every coordinate plane — i.e. the
modular prediction is `T10-FOLD-HEIGHT1`, not `T10-FOLD-NORMAL`.

No pair is modularly empty. There is therefore **no** modular empty fibre for
the independent verifier to re-run as an emptiness certificate.

---

## 4. Exact characteristic-zero status

| Attempt | Result |
|---|---|
| Heavy slot claimed for `(A,u)` via `preflight_t101.json` | claimed |
| M2 over `frac(QQ[A,u])[B,Y,Z,t]` with full gate product | **not completed** — gate product with `C` (2630 terms) expands beyond practical frac-field GB within the run; job killed cleanly |
| Singular parametric `(0,A,u),(B,Y,Z,t)` | **not completed** — same size wall; killed cleanly |
| Modular elim ideal of projection to `(A,u)` | script prepared; full 5-var elim GB not finished in time budget |

**Bottleneck:**

```text
BOTTLENECK-T101-EXACT-FUNCTION-FIELD-GB
```

Named next computation (smallest floor):

```text
Exact finite algebra / monic RUR of degree 6 over Q(A,u) for
I_sing : (ell · C · L · M · Q4 · P_uu · delta · G)^∞ in B,Y,Z;
verify all gates nonzero in the algebra; optional multiprime CRT of
the monic eliminant from many integer specializations of (A,u).
```

Peak RSS this run: modular campaign under the **8 GiB** fence; exact M2 was
capped at **32 GiB** taskpolicy and did not report a successful finish (no
measured peak for a completed exact matrix).

---

## 5. What this does / does not prove

| Claim | Status |
|---|---|
| Modular nonempty degree-stable fibres for all ten pairs | **recorded** (discovery) |
| Full-G modular cert deg 9 for `(A,Y)`, deg 12 for `(A,B)` | **recorded** |
| Exact nonempty generic fibre over `Q(x_i,x_j)` | **not sealed** |
| `dim Sing(S_G) = 2` | **not proved** |
| `T10-FOLD-NORMAL` / `T10-FOLD-HEIGHT1` | **not decided** |
| Target branch `B` nonnormal / binodal 3-primary free | separate packet T10.0 |

---

## 6. Exit

```text
T10-FOLD-UNDECIDED
```

Successful under work order §8.11: measured undecided with named bottleneck and
the ten-pair table filled.

**Headline:** **OPEN**
