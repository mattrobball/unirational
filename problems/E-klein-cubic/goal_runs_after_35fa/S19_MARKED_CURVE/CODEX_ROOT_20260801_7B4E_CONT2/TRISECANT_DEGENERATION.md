# Exact trisecant degeneration

## Universal configuration

Over `Q(zeta_11)`, the 55 pinned orbit lines have an exact intersection graph
with 165 edges and constant degree six.  Its 55 triangles form a `55_3`
configuration: every orbit line belongs to exactly three triangles.  For any
hyperplane avoiding the orbit lines, each triangle plane cuts the hyperplane
in a trisecant through the corresponding three marked points.

A deterministic exact-cover search proves that these 55 universal
trisecants require at least 21 members to cover all 55 marks; the JSON packet
contains a 21-cover and the complete 20-cover failure replay.

## Special degree-19 cover

The triples `(3,31,34)` and `(17,27,30)` each have a `P1` family of
transversals.  The exact choices represented by nullspace combinations
`(1,-1)` and `(1,14)` determine a hyperplane over `Q(zeta_11)`.  Its reduction
at `(p,zeta)=(67,64)` is exactly

```text
[1:1:1:2:7].
```

Thus the named good-reduction gates certify 55 distinct marked points and
Hilbert function

```text
1,4,10,19,31,45,55.
```

Seventeen universal trisecants together with the two selected extra
transversals give 19 exact lines covering every marked point.

## Decisive rejection

Only line pairs `(2,5)` and `(4,17)` meet over `Q(zeta_11)`.  They meet at the
two repeated marked points 7 and 49.  The graph is a forest with 17 connected
components, so inclusion-exclusion gives

```text
P_U(t) = 19*(t+1)-2 = 19*t+17,
p_a(U) = 1-17 = -16.
```

Therefore this exact marked union is not a point of
`Hilb^{19t+1}(P3)`, is not a rational curve, and cannot enter S19.3.  The
independent verifier reconstructs the orbit configuration, special
hyperplane, marked Hilbert function, cover, exact line intersections, and
arithmetic genus without importing the producer.
