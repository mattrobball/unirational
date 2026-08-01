# T11.0 — Modular simple point of the gate-saturated `(A,u)` fibre

**Exit:** `T11-MODULAR-SIMPLE-POINT`  
**Headline:** **OPEN**  
**Object:** fold singular locus `Sing(S_G)`, specialized at `(A,u)=(63,35)` mod `101`  
**Not claimed:** `T11-FOLD-HEIGHT1` (this is discovery + a certified Hensel chart only)

---

## 1. Setup

Sealed inputs:

| Object | Terms | sha256 prefix |
|---|---:|---|
| `P` | 1593 | `921816…c344` |
| `H` | 37992 | `b727ee…d501` |

Ideal:

```text
I_sing = (P, P_u, P_A, P_B, P_Y, P_Z) ⊂ F_101[B,Y,Z]
```

after specializing `(A,u)=(63,35)`, saturated by the named-gate product

```text
ell · C · Q4 · P_uu · delta · M,   M=B,   L=A−15 (=48 ≠ 0, constant).
```

`G` is evaluated at points via the sealed factorization circuit

```text
G ≡ 48 · L · M⁴ · Q4 · F27²  (mod 101),
```

with modular sparse `F27` from `tmp/t2r45/G_modp/F27_p101.tsv` (6288 terms).  
`H` is **not** a fold gate; it may vanish on the fibre.

---

## 2. Fibre

`msolve` RUR over `F_101` returns a **zero-dimensional** scheme of **degree 6**.  
Eliminant (low-to-high coeffs):

```text
w(T) = [12, 30, 94, 47, 4, 13, 1]
```

`gcd(w, w') = 1` ⇒ square-free. Factorization:

```text
w = (linear) · (quad) · (cubic)   degrees 1 + 2 + 3.
```

All six geometric points (orbit representatives) have vanishing generators; all have
every named gate nonzero (including `G` via `F27`).

---

## 3. Selected simple point

| Coord | Value mod 101 |
|---|---:|
| `A` | 63 |
| `B` | 74 |
| `Y` | 15 |
| `Z` | 15 |
| `u` | 35 |

### Gates (all nonzero)

| Gate | Value |
|---|---:|
| `ell` | 87 |
| `C` | 31 |
| `P_uu` | 12 |
| `delta` | 19 |
| `L = A−15` | 48 |
| `M = B` | 74 |
| `Q4` | 28 |
| `F27` | 10 |
| `G` | 39 |

### Jacobian minor

Selected triple (singular generators) and `3×3` minor in columns `(B,Y,Z)`:

```text
(g1,g2,g3) = (PB, PY, PZ)
Δ = det ∂(g1,g2,g3)/∂(B,Y,Z) ≡ 5 (mod 101) ≠ 0
```

There are **10** nonzero `(B,Y,Z)`-minors among the
`C(6,3)=20` triples (row `P` contributes no nonzero minor at this point).

### Multiplicity

**Multiplicity one.** Justification: square-free RUR eliminant; selected point is the
unique `F_101`-rational simple root of the linear factor of `w`; saturated fibre
degree equals `1+2+3=6`.

---

## 4. What this does / does not prove

| Claim | Status |
|---|---|
| Gate-saturated modular fibre nonempty of degree 6 | **certified** |
| Simple point with all gates units + nonzero chart minor | **certified** |
| Hensel-liftable étale chart seed for `(g1,g2,g3)` | **certified** (Jacobian criterion mod `p`) |
| Exact horizontal component over `Q(A,u)` | **not proved** — needs T11.1 |
| Fold `S_G` nonnormal | **not proved** |
| Target branch `B` nonnormal | separate sealed packet (`T-BRANCH-NONNORMAL`) |

---

## 5. Exit

```text
T11-MODULAR-SIMPLE-POINT
```

Machine payload: `modular_point.json`  
Independent verifier: `verify_modular_point.py`

**Headline:** **OPEN**
