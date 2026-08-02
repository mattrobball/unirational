# Degree-four deliverable

## Certified object

The generic cubic surface has an integral closed point of exact degree four;
equivalently, `Y/P1_K` has an integral finite-flat degree-four multisection.
The proof is unconditional and split by the exhaustive cases `S(K(q))` empty
or nonempty in `QUARTIC_MULTISECTIONS.md`.

This is a theorem-level existence result, not a coordinate tuple in a quartic
field algebra and not explicit multisection equations.  The normalization
argument nevertheless certifies exactly the
required meanings:

```text
integral:       the multisection function algebra is a field
base degree:    4
finite flat:    yes
section:        not proved
H-degree four:  not asserted
```

## Branch information

An imprimitive quartic is equivalent to a rational point on the generic
surface.  Under the hypothetical no-section assumption, the quartic is
full-span and primitive, its Galois closure is `A4` or `S4`, and its cubic
resolvent is irreducible.  That primitive arithmetic stratum is the smallest
surviving no-section object.

Because an integral quartic also exists in the section branch, this file does
not choose between section and no-section.  No `POINT.md` or positive bridge
is supplied.
