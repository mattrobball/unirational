# C0.2 — Structural search on `F_{14,T}` (before elimination)

**Packet:** `certificates/fano_interface_c0`  
**Date:** 2026-07-31  
**Track:** C0.2 only (no elimination launched)  
**Headline:** **OPEN**

Search order fixed by work order §5:

```text
rational fibration
conic bundle
odd-degree multisection
homogeneous-space description
low-degree rational section
```

For each structure the questions are:

1. Does it exist on the geometric (split) model?
2. Is it Gal-stable / does it descend to `F_{14,T}` over `K_proj`?
3. If it descended, what would a rational point on the base plus an odd
   multisection actually give, and is the Brauer class of `A_proj` killed?

**Specific input consumed throughout:** the accepted Pfaffian descent package
(`period=index=2`, `SB_2(A)≅P²_D` rational, `H_T` five-plane, individual
isotropy via degree-55 + Springer, common line open), the classical
geometry of the genus-8 prime Fano `V_{14} = Gr(2,6) ∩ P^9`, and the
`PSL(2,11)` orbit lattice recomputed below. Arguments that would apply to an
*arbitrary* quaternion algebra with an *arbitrary* five-plane of Hermitian
forms are flagged and rejected as progress (brief §3.5).

---

## 0. Geometric baseline (split model)

| Fact | Status | Pin |
|---|---|---|
| `F_{14} = Gr(2,6) ∩ P(B_{10}) ⊂ P^{14}`, linear section of codimension 5 in `Gr(2,6)` | accepted classical / Tschinkel–Zhang | `tmp/fano14_twist/REPORT.md` §1; arXiv:2409.08392 §§3–4 |
| `dim Gr(2,6) = 8`, `dim F_{14} = 3`, degree 14, smooth | classical | dimension count `8−5=3` |
| Picard number `ρ(F_{14}) = 1`, `Pic = Z·H`, `H` = Plücker class, `H³ = 14` | classical for prime Fano genus 8, index 1 | Mukai; Iskovskikh–Prokhorov survey |
| Dual incidence with the Klein cubic threefold | classical Pfaffian | same |
| Not a Mori conic bundle / del Pezzo fibration | follows from `ρ=1` (those have `ρ≥2`) | Mori–Mukai classification |

**Independent arithmetic check (this dispatch).** GAP 4.15.1,
`PSL(2,11)` order 660:

| Stabilizer type | Order | Index = orbit degree |
|---|---:|---:|
| `A_4` | 12 | **55** (odd) |
| `C_{11}` | 11 | **60** |
| `C_5` | 5 | **132** |

`gcd(55,60,132) = 1` ⇒ every twist has a degree-one zero-cycle (index of
`F_{14,T}` as a variety is 1). Confirmed: 110 subgroups of order 12, all
`StructureDescription = A4`, index 55; 12 of order 11; 66 of order 5.

Scratch log: `tmp/c0_audit/gap_orbit_degrees.txt`.

---

## 1. Master table

| Structure | Exists on split `F_{14}`? | Descends to `F_{14,T}/K_proj`? | What a success would give | Status this dispatch |
|---|---|---|---|---|
| **Rational fibration** `F_{14} ⇢ S` (dim S ≥ 1, rational base, positive-dim fibres) | **No** non-constant morphism to a positive-dimensional base with connected fibres compatible with `ρ=1`: any such fibration pulls back a non-constant class, forcing `ρ≥2` | **No** — nothing geometric to descend | N/A | **Negative** |
| **Conic bundle** `F_{14} → S` (S surface, generic fibre smooth conic) | **No** — conic-bundle Fano threefolds have Picard number ≥ 2; genus-8 prime Fano has `ρ=1` | **No** | If it did: rational point of `S` + odd multisection ⇒ unirationality mechanism (cf. Problem B hypotheses below) | **Negative** |
| **del Pezzo fibration** | **No** (`ρ=1`) | **No** | similar | **Negative** |
| **Odd-degree multisection of `F_{14,T} → Spec(K_proj)`** | Geometric points exist; twisted form has effective zero-cycle of degree **55** (and 60, 132) | **Yes** — the `A_4`-orbit cycle descends as a Gal-stable zero-cycle of degree 55 | Gives `F_{14,T}(E)≠∅` for some odd `[E:K]`; by Springer, **each** `h∈H_T` is isotropic over `K`; does **not** give a common line over `K`; does **not** kill `[D]∈Br(K)[2]` (corestriction multiplies by odd unit on 2-torsion) | **Positive as cycle; negative as point lever** (see §2) |
| **Homogeneous-space description** under a linear algebraic group with obviously neutral class | `F_{14}` is **not** a projective homogeneous space under a semisimple group in the sense that would make `H¹` control points; it is a linear section of the homogeneous `Gr(2,6)` | The ambient `SB_2(A)≅P²_D` **is** homogeneous / rational and **does** descend; the section `F_{14,T}` does **not** inherit a transitive action with neutral class | Ambient rationality is already used; it does not put a point on the section | **Ambient yes; Fano section no** |
| **Low-degree rational section / point** | Classical `F_{14}(C)` is Zariski-dense (Fano, unirational over `C` even) | Open over `K_proj` — this is the headline-positive gate | `C-FANO-POINT` ⇒ `C_gen(K_proj)≠∅` ⇒ `G`-unirationality (Arrows B–C of `BRIDGE_AUDIT.md`) | **Open** (not constructed; not disproved) |
| **Linear section of rational homogeneous variety** (structure, not a fibration) | **Yes** — defining structure | **Yes** — `Y_T = SB_2(A) ∩ P(B_5^⊥)` with honest ambient `P^{14}` | Frames Option 2 of C0.1; does not by itself give a point | **Descends as description; point open** |
| **Incidence `P¹`-bundle to Klein cubic** | **Yes** — lines on the cubic / points of `F_{14}` | **Yes** over `K_proj` after twist (accepted Pfaffian incidence) | `F_{14,T}(K)≠∅ ⇒ C_gen(K)≠∅` (Arrow B **PASS**) | **Descends; hypothesis open** |

Negatives in the first three rows are the structural payload of this track:
there is **no** conic-bundle or rational-fibration unirationality mechanism
available on `F_{14,T}` by descent of classical Fano geometry.

---

## 2. Odd-degree multisection lever — precise reach and failure

### 2.1 What the lever **does** (accepted, specific to this `G`-action)

Input consumed: the `A_4`-fixed point on classical `F_{14}` and
`[G:A_4]=55`.

```text
degree-55 zero-cycle on F14_T
  ⇒  F14_T(E) ≠ ∅ for some residue field E/K with [E:K] odd
  ⇒  common isotropic D_E-line for all of H_T
  ⇒  for each fixed h ∈ H_T, the 12-dimensional quadratic form
        q_h(v) = h(v,v)  on  the K-space underlying D³
      is isotropic over E
  ⇒  Springer (char 0, odd degree) ⇒ q_h isotropic over K
  ⇒  every individual member of H_T is isotropic over K.
```

This uses **PSL(2,11)-orbit geometry** (degree 55) and is not an
arbitrary-five-plane theorem. Documented in
`tmp/pfaffian_explicit_descent/REPORT.md` §1.

### 2.2 What the lever **does not** do

| Claim | Verdict |
|---|---|
| Odd multisection ⇒ `F_{14,T}(K)≠∅` | **False as a general principle**; no theorem provides it; index-1 zero-cycles need not be rational points |
| Odd multisection ⇒ common isotropic **K**-line | **Not given** by Springer: five isotropic vectors for five forms need not coincide |
| Odd multisection ⇒ `[D]=0` in `Br(K)` | **False**: `cor∘res = ×[E:K]` is an odd unit on `Br(K)[2]`, so res is injective on the quaternion class |
| Same lever on a conic-bundle multisection | **N/A**: no conic bundle (table row 2) |

**Clean impossibility statement (lever scope).**

```text
There is no argument of the shape

  (index(A_proj)=2) + (odd-degree zero-cycle on F14_T)
    ⇒  F14_T(K_proj) ≠ ∅

that uses only Springer’s theorem for single quadratic forms and
restriction–corestriction on Br[2]. The same two inputs already hold,
and they yield individual isotropy of H_T without producing a common
line — which is exactly the residual open problem recorded since
Gate 1 / Gate 2.
```

This is a **positive structural result**: it closes the “apply the degree-55
trick one more time” branch for the common-line problem.

### 2.3 Relation to Problem B (read-only)

`problems/B-conic-bundle-multisections/` formalizes unirationality of smooth
bidegree `(2,3)` hypersurfaces in `P²×P²` via a tangent-residual conic
bundle plus multisection (hypotheses: field perfect, `char ∤ 6`, smoothness,
and a good-line / Tsen-section package in the closure-free form).

| Problem B hypothesis | Holds for `F_{14,T}`? |
|---|---|
| Variety is bidegree `(2,3)` in `P²×P²` | **No** — it is a codim-5 linear section of `Gr(2,6)` |
| Conic bundle structure from tangent residual | **No** ambient product structure |
| Odd multisection of that conic bundle | **N/A** |

**Conclusion:** Problem B’s formalized mechanism does **not** apply to
`F_{14,T}`. No repair of Problem B is suggested; the mismatch is geometric
type, not a missing hypothesis check.

---

## 3. Homogeneous-space and ambient rationality (trap control)

| Object | Homogeneous? | Rational over `K_proj`? | Points? |
|---|---|---|---|
| `SB_2(A_proj) ≅ P²_D` | yes (generalized Severi–Brauer) | **yes** (chart `D²`) | **yes** (index condition) |
| `I_σ` (Morita projectors) | open in `P²_D` | yes | yes (Gram–Schmidt) — **auxiliary** |
| `F_{14,T}` | no useful transitive action with neutral class | unknown | **open** |

Producing a point of `P²_D` or of `I_σ` and stopping is the
`FAIL-SCOPE` move. C0.2 refuses it.

---

## 4. Classical structures that **do** descend (descriptive only)

These are not fibrations, but they are Gal-stable geometry useful for C0.1:

1. **Linear-section description.** Five `K_proj`-hyperplanes in honest
   `P^{14}` cutting `SB_2(A)` — Option 2.
2. **Quaternionic Hermitian description.** Five forms on `D³` — Option 1.
3. **Incidence correspondence** with the generic Klein twist — Arrow B.
4. **Plücker line bundle** descends (`2α=0`).

None of (1)–(4) supplies a rational point without further arithmetic.

---

## 5. What was **not** searched (out of C0.2 / resource fence)

- Raw elimination of `F_1=…=F_5=0`
- Large Gröbner bases, dense resultants, memory-saturating Macaulay2
- New modular point searches advertised as characteristic zero
- Re-derivation of `period=index=2` or of individual isotropy
- Any write under `certificates/pfaffian_point/` or Path F packets

---

## 6. C0.2 summary

```text
Conic bundle / rational fibration / del Pezzo fibration:
    geometric absence (ρ=1) ⇒ no descent question ⇒ no unirationality
    mechanism of Problem-B type on F14_T.

Odd multisection (deg 55):
    descends as a zero-cycle; gives individual isotropy; does not give a
    common line; does not kill [D].

Homogeneous ambient P²_D:
    rational with points; section problem remains codimension five.

Low-degree rational section:
    open — equal to the live gate F14_T(K_proj)≠∅.
```

**Headline:** OPEN.
