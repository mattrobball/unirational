# Resource preflight

No stage was projected to exceed 8 GiB RAM or one hour wall time, so no
checkpoint/escalation gate was triggered.

The largest mixed landing matrix is degree 35:
`6048 x 5984` over a prime field, about 138 MiB as `int32`.  Its largest dual
compatibility matrix is `139128 x 672`, about 357 MiB as `int32`; the largest
square pivot inverse is about 271 MiB as `float64`.  Arrays are freed between
fibres.  Large landing rows are certified by deterministic seeds and SHA-256
digests and independently reconstructed, rather than frozen as redundant
hundreds-of-megabytes payloads.

The saved package is about 25 MiB and contains the exact direction labels,
Reynolds seed labels, fixed-locus matrices, landing evaluation payloads for the
smaller ansätze, and independent replay code.
