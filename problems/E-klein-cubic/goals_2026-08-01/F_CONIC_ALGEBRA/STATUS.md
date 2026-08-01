F-CONIC-CRITERION-EMPTY

# Goal F status

The exact full conic criterion is empty.  The terminal theorem is

```text
C(K_proj)=empty.
```

The proof uses the irreducible factor `D` of the reciprocal infinity
coefficient.  It gives an `(e,f)=(1,1)` place of `K_proj`; the normalized
residual cubic is the generic member of an exact ternary-cubic net whose
base scheme is one geometrically integral degree-three point.  The normal
universal net incidence has class-group generators of generic degrees
`3,0,3`, so the residual cubic has index three.  Proper specialization then
excludes every `K_proj`-point.

The exact proof and payload are in:

```text
INFINITY_OBSTRUCTION.md
infinity_obstruction.json
produce_infinity_obstruction.py
verify_infinity_obstruction.py
```

By the bidirectional point/conic equivalence, no nondegenerate `F`-conic has
intersection algebra isomorphic to the selected `K_proj`.  Thus the full
six-equation point scheme described in `CRITERION.md` is empty.

This conclusion remains scoped to the auxiliary fixed-frame plane cubic.
The repaired repository audit withholds a bridge from its pointlessness to
the genuine generic Klein twist, so the Klein-cubic headline remains
**OPEN**.
