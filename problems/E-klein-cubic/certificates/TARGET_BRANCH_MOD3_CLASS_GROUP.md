# WP-T1 — Target-branch three-primary class group

**Headline: OPEN.**  
**Work package:** WP-T1 only.  
**Base commit:** `37798bf`.  
**Deliverables:** `certificates/target_branch_mod3/*`.

## Verdict

| Claim | Status |
| --- | --- |
| Ordinary `Pic(T_D) = Z H_z ⊕ Z H_λ` | Accepted input (SGA2) |
| Multiplicity-one target branch, residue degree `m = 1` | Accepted input |
| Generic cubic smooth on the branch | Accepted input |
| Cramer-saturated simple-fold model identified | Recorded |
| Codimension-two singular strata of the incidence, with contact exponents mod 3 | **Not closed globally** |
| Every vertical Weil class has order prime to 3 | **Not proved** |
| Explicit dangerous three-primary class | **Not exhibited** |
| Horizontal degree subgroup equals `3Z` | **NOT DECIDED** |
| Three-primary defect vanishes | **NOT DECIDED** |
| Negative resolution of Problem E | **Not asserted** |

**Decision exit.** Stop short of the negative resolution of Problem E. The
three-primary defect is not proved to vanish, and no explicit dangerous
three-primary class is exhibited. Headline remains **OPEN**.

## 1. Gate (accepted reduction)

Over `F = C(A,B,Y,Z)` one already has

```text
ind(C/F) = 3,   C(F) = empty,   Pic^0(C)(F) = 0,
[K_proj : F] = 6  with geometric monodromy S6.
```

A multiplicity-one target branch divisor `D` has residue degree one and smooth
generic cubic. The remaining negative gate is

```text
ind(C_{k(D)}) = 3.
```

Ordinary Picard theory for the incidence `T_D` is complete:

```text
Pic(T_D) = Z H_z ⊕ Z H_λ.
```

Only the three-primary non-Cartier defect can lower the degree subgroup:

```text
( Cl(T_D) / Pic(T_D) )[3].
```

House rule 8 is binding: no full class-group computation is required or
attempted.

## 2. Cramer-saturated multiplicity-one model

The accepted sparse consequence matrix `M` yields the raw eliminant
`E_raw = det(M)/u`. Exact content extraction gives

```text
E_raw = C(A,B,Y,Z) * P(A,B,Y,Z,u)
```

with `C` of degree 22 (2630 terms) and primitive sextic `P` of `u`-degree 6
(1593 terms). Source hashes are sealed in `payload.json`.

The multiplicity-one simple-fold model on the content-open, Cramer-open chart
is

```text
R_fold = V(P, P_u)   saturated away from   P_uu · δ · C = 0,
```

where `δ` is the accepted Cramer minor of `M`. The raw irreducible branch is
nonnormal along a double-fold locus; Cramer saturation removes the squared
Cramer-order components and retains the simple factor selected by the line
certificate `H_21`. Residue degree `m = 1` and generic cubic smoothness on
this component are accepted inputs.

This packet does **not** produce a global hypersurface equation for `D` in
`P^4`. The working model is the Cramer-saturated fold cover above.

## 3. Exact new theorem: non-isolated critical locus on the test slice

### Theorem (slice critical curve)

Specialize the exact primitive to the plane

```text
A = 0,   B = 2.
```

In `QQ[Y,Z,u]`, let

```text
J = (P, P_A, P_B, P_Y, P_Z, P_u)
```

after this specialization. Then

```text
dim J = 1,    deg J = 14,    codim J = 2.
```

The intrinsic singular ideal of the specialized hypersurface

```text
J_sing = (P, P_Y, P_Z, P_u)
```

has the same dimension and degree. Consequently the specialized ramification
hypersurface has a **one-dimensional singular locus** of degree 14: its
singularities are non-isolated.

### Replay

```sh
/usr/sbin/taskpolicy -m 4096 /opt/homebrew/bin/python3 -u \
  certificates/target_branch_mod3/produce.py
# terminal marker: TARGET_BRANCH_MOD3_PRODUCER_SEALED

/usr/sbin/taskpolicy -m 4096 /opt/homebrew/bin/python3 -u \
  certificates/target_branch_mod3/verify.py
# terminal marker: TARGET_BRANCH_MOD3_VERIFIER_ACCEPT
```

The verifier rebuilds the specialized polynomials from the primitive TSV and
does **not** import the producer. Both sides must report dimension 1 and
degree 14.

### Relation to the degree-12 RUR orbit

The accepted degree-12 H-prime RUR constructs twelve geometric points on this
same slice at which all six critical equations vanish, with transverse
Hessian rank exactly two and `P_uu` a unit. Those twelve points are therefore
points of the degree-14 critical curve, not an exhaustive 0-dimensional
singular scheme. Statements that treat them as isolated ordinary double
points (or isolated higher `cA` points) are incompatible with the theorem
above.

## 4. Local singularity interface and mod-3 danger

At the RUR orbit one still has the formal Morse normal form

```text
x y - h(z,w),    h ∈ (z,w)^3,
```

with exact vanishing of the residual cubic and corrected quartic jets
(`h_3 = h_4 = 0`). The all-orders membership

```text
P ∈ (P_A, P_B, P_Y)_m
```

remains open as a local identity, but the slice theorem shows that the
critical set is positive-dimensional on this plane, which is the global
shape of Morse–Bott (`h = 0`) rather than an isolated residual singularity.

For the class-group gate:

| Local model | Local defect | Dangerous iff |
| --- | --- | --- |
| `xy = π^n` (nodal cubic contact) | `Z/n` | `3 ∣ n` |
| `xy = ∏ p_i^{n_i}` (residual base sing.) | torsion from the `n_i` | some `3 ∣ n_i` |
| `xy = 0` (Morse–Bott) | nonnormal crossing | normalization removes the defect |

Only contact orders divisible by three can create a three-primary horizontal
Weil class capable of dropping the degree subgroup below `3Z`.

## 5. Cubic-discriminant contacts (discovery only)

A modular probe at the good prime `67` (scratch:
`tmp/wp_t1_mod3/discovery_p67.json`) found:

- abundant simple-fold points with smooth fixed-frame cubic;
- only rare fold points with singular cubic;
- on six random affine lines, every detected fold specialization had smooth
  cubic.

By house rule 11 this is **shape selection only**. It is not a
characteristic-zero list of contact orders `m_i`, and it is not advertised as
a theorem that every `m_i = 1`.

## 6. What would close the gate

A sufficient finite certificate (already recorded in the sealed payload) is:

1. Cramer-saturated simple-fold component with unit gates `P_uu`, `δ`, `C`;
2. base regular in codimension two after normalization, or certified
   Morse–Bott normalization smooth along every codimension-two stratum;
3. for each height-one prime of `Δ_cub` on the normal base, contact order
   `m_i` with `3 ∤ m_i` (reduced pullback is the cheapest success);
4. exhaustive identification of codimension-two non-Cartier strata with the
   nodal sections of step 3; residual locus of codimension at least three;
5. residual codimension-three punctured Picard exponents prime to three, or
   residual codimension at least four (fourfold lci parafactoriality).

Completed pieces in this packet: steps of ordinary Picard, generic smoothness,
`m = 1`, exact primitive model, corank-two RUR data, and the exact slice
critical-curve theorem of §3.

Still open: global primary decomposition of the fold ideal over `QQ`,
all-orders residual vanishing / local membership, global `m_i` list, and the
codimension-three incidence audit.

## 7. Self-adversarial note (why no headline conversion)

Even if one believes the Morse–Bott picture and reduced discriminant contacts,
the following attacks still stand:

- The slice theorem is only on `A = 0, B = 2`. It does not by itself give a
  global equation of the critical surface or prove `h ≡ 0` in two free
  formal parameters at every geometric point of the branch.
- Cubic-discriminant contacts were not listed over `QQ`. A single height-one
  prime with `m_E` divisible by three would reopen a three-primary escape.
- Codimension-three strata of the fourfold incidence can carry
  three-primary local class groups even when every codimension-two chart is
  prime to three.
- The Chow counterexample (evaluation hyperplanes of index one) shows that
  smooth generic fibres and ordinary Picard rank two do not force index
  three without the local class-group control above.

No candidate dangerous class was isolated strongly enough to exhibit as a
theorem. No proof that every vertical Weil class is prime to three was
obtained. Therefore the horizontal degree subgroup is **not decided**, and
Problem E stays **OPEN**.

## 8. Files

```text
certificates/target_branch_mod3/produce.py
certificates/target_branch_mod3/verify.py
certificates/target_branch_mod3/payload.json
certificates/target_branch_mod3/SEAL.json
certificates/target_branch_mod3/slice_critical_qq.m2
certificates/target_branch_mod3/slice_critical_qq.m2.log
certificates/target_branch_mod3/verify_slice_critical_qq.m2
certificates/target_branch_mod3/verify_slice_critical_qq.m2.log
certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md
```

Scratch (not sealed): `tmp/wp_t1_mod3/`.

## 9. Intended commit split

1. `certificates/target_branch_mod3/*` — producer, verifier, sealed payload,
   M2 scripts and logs.
2. `certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md` — theorem boundary and
   decision exit.
3. Optional separate commit for `tmp/wp_t1_mod3/` discovery scratch, or leave
   untracked per repository policy for scratch.

No edits to `HANDOFF.md`, `RESOLUTION.md`, `CURRENT_PATHS.md`, or `SPEC.md`.

## Terminal markers

```text
TARGET_BRANCH_MOD3_PRODUCER_SEALED
TARGET_BRANCH_MOD3_VERIFIER_ACCEPT
```
