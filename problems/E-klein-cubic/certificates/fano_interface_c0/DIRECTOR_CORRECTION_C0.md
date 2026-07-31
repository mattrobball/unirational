# Director correction — C0 structure table, order-12 subgroup count

**Author:** director session, 2026-07-31, verifying the Track C0 packet.
**Applies to:** `C0_STRUCTURE_TABLE.md` line 55.
**Effect on the exit:** none. `C0-UNDECIDED` stands.

The C0 packet is sealed byte-identical as the worker produced it; this file is
the correction layer, following the `ROUTE_G_VERDICT.md` pattern (do not
rewrite a sealed packet — record the correction alongside it).

---

## 1. The incorrect sentence

`C0_STRUCTURE_TABLE.md` §(orbit degrees) states:

```text
Confirmed: 110 subgroups of order 12, all
StructureDescription = A4, index 55; 12 of order 11; 66 of order 5.
```

The clause **"all StructureDescription = A4"** is false.

## 2. What is actually true

Recomputed independently by the director in GAP 4.15.1
(`/opt/homebrew/Caskroom/miniforge/base/bin/gap`):

```gap
G := PSL(2,11);;
cc := ConjugacyClassesSubgroups(G);;
o12 := Filtered(cc, c -> Size(Representative(c))=12);;
for c in o12 do
  Print(StructureDescription(Representative(c)), "  class_size=", Size(c),
        "  index=", Index(G, Representative(c)), "\n");
od;
```

Output:

```text
A4   class_size=55  index=55
D12  class_size=55  index=55
total order-12 subgroups=110
n_11=12  n_5=66
```

So `PSL(2,11)` has **110 subgroups of order 12 in two conjugacy classes: 55
copies of `A_4` and 55 copies of `D_12`**, both of index 55. The packet's
count of 110 is right; its structure attribution is not.

Consistency check on the rest of the sentence: `n_11 = 12` and `n_5 = 66` are
confirmed (Sylow: `n_11 | 60`, `n_11 ≡ 1 mod 11`; `n_5 | 132`, `n_5 ≡ 1 mod 5`).

## 3. Why the exit is unaffected

The load-bearing facts are the orbit degrees and their gcd, and those are
confirmed independently:

```text
indices 55, 60, 132        gcd(55, 60, 132) = 1
```

(Director's GAP run also lists the full index set of nontrivial subgroups:
`1, 11, 12, 55, 60, 66, 110, 132, 165, 220, 330`.)

The degree-55 cycle used throughout the Pfaffian packets is the one with `A_4`
stabilizer, and that orbit exists exactly as claimed — it is simply not the
only index-55 orbit. Nothing in the C0.2 structure table, the `ρ = 1` negative,
or the restriction–corestriction lever bound depends on the miscounted
attribution.

## 4. Verified separately by the director

| Claim | Status |
|---|---|
| `verify_c0.py` replay | `VERIFY_C0_OK`, exit `C0-UNDECIDED` |
| orbit degrees 55, 60, 132, gcd 1 | recomputed in GAP, confirmed |
| 110 order-12 subgroups | confirmed, **but split 55 `A_4` + 55 `D_12`** |
| `n_11 = 12`, `n_5 = 66` | confirmed |
| `ρ(F_14) = 1` ⇒ no conic bundle / rational fibration, hence none descends | sound: a structure absent on the geometric model cannot exist over `K_proj`; `ρ = 1` is classical for the prime Fano threefold of genus 8 (cited to Mukai, Iskovskikh–Prokhorov in the packet) |
| odd-degree lever cannot kill `[D]` | sound: `cor ∘ res` is multiplication by `[E:K] = 55`, which is a unit on `Br[2]`, so an odd-degree extension preserves a 2-torsion class |

**Problem E remains OPEN.**
