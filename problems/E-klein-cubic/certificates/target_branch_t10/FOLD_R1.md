# T10.1 — `R_1` decision status for the fold algebra `S_G`

**Exit:** `T10-FOLD-UNDECIDED`  
**Headline:** **OPEN**  
**Serre half:** `S_2` already proved; `R_1` still open.

---

## Binding inputs (do not re-derive)

| Fact | Marker |
|---|---|
| `S_G` is Cohen–Macaulay of dim 3 (`S_2`) | sealed `s2_cm_certificate.json` |
| `dim Sing(S_G) ≤ 2` | sealed upper bound (PIT / cut2) |
| Gates `ell, C, P_uu, delta, G` executable | T2R4-PASS |
| Target branch `B` nonnormal (codim-1 binodal) | accepted analytic + correction; **not** about `S_G` |

---

## Decision tree this packet partially fills

```text
all ten generic fibres empty after sat  →  R_1  →  T10-FOLD-NORMAL
one fibre nonempty exact finite algebra →  dim Sing = 2 → T10-FOLD-HEIGHT1
otherwise                               →  T10-FOLD-UNDECIDED
```

**Modular campaign:** all ten pairs nonempty with stable degrees 6–24
(see `TEN_PAIR_TABLE.md`). Prediction: HEIGHT1.

**Exact campaign:** cheapest pair `(A,u)` degree 6 preflighted and heavy slot
claimed; parametric GB over `Q(A,u)` not completed (gate-product size).

---

## Conductors (REPAIR §5)

Keep distinct when T10.2 starts:

```text
c_{B ⊂ S}  = Ann_B(S/B)
c_{S ⊂ S~} = Ann_S(S~/S)
```

Do not write “the conductor”.

---

## Exit

```text
T10-FOLD-UNDECIDED
BOTTLENECK-T101-EXACT-FUNCTION-FIELD-GB
```

**Headline:** **OPEN**
