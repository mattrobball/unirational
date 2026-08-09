# Status

`EXACT / REPLAYED / SCOPED`

The root-degree-seven support obstruction is an exact theorem for all sixteen
exact-two-residue progression families.  It excludes covariant degree 45 in
that family and extends the existing bounded two-residue exclusion from
degree 40 through degree 45.

It does **not** prove an analytic or representation-theoretic degree cutoff,
does not cover supports using three or more Frobenius residues, and does not
settle the Klein-cubic equivariant-unirationality headline.

The first generated proof used an `unknown` mask cached across several
propagation steps.  Its recorded hints could therefore repeat a factor forced
earlier in the same pass, and strict replay rejected it.  That proof and all
of its counts were discarded.  The checked generator updates `unknown`
immediately after every forced zero or nonzero coefficient; `proof.bin` is the
freshly generated replacement, and `verify.py` checks strict equality at
every row-forcing step.

The annotated 212-row `(d,r)=(1,1)` CaDiCaL assumption core is explanatory,
not the verdict certificate.  Its sealed source is
`../N7_SUPPORT/cadical_core_1_1.json`; its indices refer to the insertion-order
`clean` equation tuple returned by
`CHAR5_PROGRESSION_LOW_DEGREE/verify.py::landing_system(1,1,7)`.
`annotate_core_1_1.py` reconstructs that convention rather than treating an
index as a canonical target sort.  Only 38 of its 212 rows contain a pure
coefficient cube.  It contains no complete cyclic target-row orbit; its
cyclic orbit closure has 1,060 rows.  Thus this minimized core does not by
itself furnish a pure-cube or orbit-stable all-degree peeling lemma.
