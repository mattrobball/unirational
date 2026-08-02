# Goal M3 — select the Sarkisov section alternative

**Pinned state:** `bd610a032bb9561d2daeb91a2cb60c48c082ca2f`  
**Priority:** 4  
**Possible headline direction:** positive  
**Accepted positive bridge:** the section clause of `BR-FANO-POS` / the
installed Schur-twist point bridge

## Mission

Consume the exact type-I Sarkisov link

```text
X_T <- Y=Bl_{C_012}(X_T) -> P^1_K
```

and decide whether the degree-three del Pezzo fibration has a rational
section.  In the installed graph coordinates the fibre over `[s:t]` is

```text
Phi(a_0,a_1,a_2,su,tu)=0 in P^3.
```

The current theorem proves the exact alternative

```text
rational section  OR  integral degree-four multisection.
```

A rational section gives a `K`-point of the genuine Schur twist and closes the
Klein-cubic headline positively.  A degree-four multisection alone proves no
headline and must not be promoted from index one.

## Binding inputs

Consume and replay the packet

```text
problems/E-klein-cubic/goal_runs_after_35fa/M_SARKISOV/
```

including:

- the degree-eight projective Schur frame and the exact cubic `Phi`;
- smoothness of `C_012`;
- the graph/blowup equation and Cox/intersection data;
- relative Picard rank one and the two extremal rays;
- the degree-three exceptional multisection;
- the degree-fifty-five `D_12` line-orbit multisection;
- simultaneous avoidance of the centre by all 55 lines;
- the exact theorem giving the section/degree-four alternative.

Do not replace the projective Schur field by the affine invariant field or a
stable transcendental extension.

## Work packages

### M3.0 — executable fibration and convention audit

Produce a minimal exact model over `K` for

```text
Y = {Phi(a)=0, a_3 t-a_4 s=0} in P^4 x P^1
```

and for its generic cubic-surface fibre over `K(q)`, `q=s/t` on one chart.
Verify independently:

- smoothness of the generic surface;
- the relative anticanonical and hyperplane classes;
- the degree-three and degree-fifty-five zero-cycles;
- every denominator in the Schur frame;
- the specialization/evaluation map from a section to a point of `X_T`.

### M3.1 — direct section search in Cox and graph coordinates

Parameterize a section as a tuple of homogeneous polynomials of controlled
base degree, modulo common factors and automorphisms, satisfying the graph
cubic identically.

Run by increasing `H`-degree and exploit the geometry before Groebner work:

1. use the Cox grading and intersection inequalities to list admissible
   section divisor classes;
2. solve linear syzygies and basepoint conditions first;
3. use the cubic equation coefficient-by-coefficient only after quotienting
   source automorphisms;
4. detect components by modular computation at two split primes;
5. reconstruct any section over the exact Schur field and check a holdout
   prime;
6. verify that the resulting curve maps with degree one to `P^1` and is not a
   vertical or exceptional component.

A bounded degree search may find a section but cannot prove that no section
exists without a separate degree bound.

### M3.2 — decide the integral degree-four branch

Construct the relative Hilbert/Chow problem for integral degree-four closed
points on the generic cubic surface, equivalently integral quartic
multisections of `Y/P^1`.

Use one or more exact descriptions:

- the degree-four symmetric power with diagonal and reducible loci removed;
- a primitive quartic field algebra together with a point on the base-changed
  cubic surface and descent equations;
- normalized quartic multisection curves in the graph model;
- resolvent data for the degree-four extension and the 27-line Galois action.

Required outputs are:

- an exact integral quartic multisection; or
- a characteristic-zero proof that the integral degree-four locus is empty;
  or
- the smallest explicit unresolved component.

If the integral degree-four locus is proved empty, the accepted alternative
forces a rational section.  The bridge ledger must quote the exact theorem and
check that its hypotheses and its meaning of “degree four” match the excluded
locus.

### M3.3 — arithmetic and monodromy reductions

Compute the geometric and arithmetic monodromy of the 27 lines of the generic
cubic surface and the induced action on `Pic(S_bar)`.  Use it to reduce both
section and quartic searches:

- classify invariant divisor classes of candidate sections/multisections;
- compute the algebraic Brauer group and elementary obstruction;
- identify whether a quartic point would force a specific orbit or resolvent;
- eliminate impossible quartic decomposition groups exactly.

Vanishing of the algebraic Brauer obstruction or index one is not a rational
point theorem.  This package is useful only if it removes Hilbert components
or constructs a section.

### M3.4 — secant and residual constructions from known multisections

Test whether the installed degree-three and degree-fifty-five multisections,
or an exact degree-four multisection from M3.2, support a fibrewise secant,
tangent, or residual construction that gives a degree-one curve over the
base.  Work scheme-theoretically and verify the degree of the resulting map
to `P^1`.

A formal subtraction of zero-cycle degrees, a gcd calculation, or a class in
`CH_0` is not a section.  Accept only an explicit rational curve or a proved
rational map whose generic point is a `K(q)`-point.

### M3.5 — exact section and headline bridge

For a section:

1. substitute its coordinates in the cubic identity over `K(q)`;
2. prove all coordinate tuples are not simultaneously zero;
3. verify extension across the base or identify one `K`-rational base value
   where the section is defined;
4. map to `Y`, then through the blowdown to `X_T`;
5. verify the resulting point in the authoritative Schur twist;
6. execute the accepted versality bridge to `G`-unirationality.

Deliver `BRIDGE_SARKISOV_POS.md` with no appeal to index one alone.

## Parallel worker assignments

- **Worker M-SEC:** M3.1 direct section components;
- **Worker M-4:** M3.2 quartic Hilbert/field-algebra model;
- **Worker M-WEYL:** M3.3 line monodromy, Picard, and component elimination;
- **Worker M-RES:** M3.4 exact residual constructions;
- **Worker M-INTEGRATE:** reconcile fields and produce M3.5.

## Exits

```text
M3-SECTION-HEADLINE-POSITIVE
M3-DEGREE4-LOCUS-EMPTY-HENCE-SECTION
M3-INTEGRAL-DEGREE4-MULTISECTION
M3-SECTION-COMPONENT-PASS
M3-UNDECIDED
M3-CANONICAL-INPUT-FAIL
```

The degree-four exit is structural only unless it is converted to an explicit
section.

## Output contract

Write under

```text
problems/E-klein-cubic/goal_runs_after_bd610a/M3_SARKISOV_SECTION/
```

Provide at least:

```text
INPUT_MANIFEST.json
FIBRATION_MODEL.md
SECTION_CLASSES.json
SECTION_SEARCH.md
QUARTIC_MULTISECTIONS.md
LINE_MONODROMY.md
POINT.md or DEGREE4.md
BRIDGE_SARKISOV_POS.md when applicable
produce_*.py or exact CAS scripts
verify_*.py
SEAL.json
STATUS.md
```