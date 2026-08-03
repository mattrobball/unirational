# H6.1 rebuild — sealed torsor Y → H_tr

**Marker:** `H6-TORSOR-CLASS-PASS` (reconfirmed; H6.0 not re-proved)

## Fibre product

```text
H_tr = { Tr_{E/K}(b) = 0 } ⊂ P(E)
Y = { ([a],[b]) : [b] = [c φ(a)], Tr(b) = 0 }
φ([a]) = [a² σ(a)],   deg = 11,   ker ≅ μ_11 (C5 acts by ×9)
```

On the dense torus open, `Y → H_tr` is a degree-11 torsor. Classifying
invariant: `κ = ψ_B(b c^{-1})` in `T/T^{11}` with dual

```text
ψ_B(m)_i = m_i^5 m_{i-1}^{-3} m_{i-2} m_{i-3}^{-1},
ψ_B ∘ ψ_A = [11] on the product-one torus.
```

## c-translation

`c = r₂^{-1}`. Witness `d = r₁ r₂⁶ r₃^{-2} r₄²` gives `ψ(d) = r₂^{11}` on
product-one, so the class of `c` has exact order 11 modulo `ψ(E*)`. It is a
**term** in the torsor class — **promotion to obstruction forbidden**.

## Equivalence

On the torus open inside the H4 common chart,

```text
Y(K) ≠ ∅  ⇔  ∃ 0 ≠ a ∈ E:  Φ(a) = Tr(c a² σ(a)) = 0.
```

Boundary audited in parent `BOUNDARY_AUDIT.md`; this push constructs neither
a boundary point nor a boundary emptiness theorem.

## Machine

See `torsor_rebuild.json` (lattice, dual samples, Kummer kernel, c-class,
specialized fibre discovery).
