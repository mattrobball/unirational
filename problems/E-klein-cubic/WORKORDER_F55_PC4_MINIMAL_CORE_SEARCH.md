# Work order F55-PC4 — smallest multinomial cancellation core

**Runner:** local CAS/search agent  
**Parents:** PC2 exact compiler and PC3 polar/holonomy filter  
**Scope:** bounded falsification and minimal-exception discovery  
**Headline:** Problem E remains `OPEN`

## Mission

Attack the sole structural gap left by the proof reduction:

```text
Does every connected support-minimal cancellation core contain a singleton,
a nonzero polar determinant, or failed binomial holonomy?
```

This work order does **not** attempt to certify the all-degree coverage theorem
by a large bounded sweep.  Its purpose is to find the smallest genuine
`MULTINOMIAL-EXCEPTION`, or to produce exact bounded data from which a human
coverage theorem can be formulated.

A negative bounded result is calibration only unless accompanied by a proved
support bound.

## Mandatory theorem discipline

The runner must preserve these facts:

1. unrestricted Laurent collision loci have affine lattice lineality;
2. `M^sigma=0`, so there is no nonzero common exponent-translation gauge;
3. multiplication by an invariant polynomial is a factor/convolution operation,
   not translation of every support exponent;
4. a Hilbert basis is finite only after a pointed cone or finite-degree bound
   has been fixed;
5. the absence of exceptions through a chosen bound is not an all-degree
   theorem.

Any output violating these rules is rejected.

## Definition of an exception

For a finite support `S`, run PC2 and PC3.  Call `S` a
**multinomial exception** when:

```text
- every nonzero row has at least two coefficient monomials;
- the variable/row incidence graph is connected;
- no clean polar pair has nonzero determinant;
- every integral holonomy relation in the binomial subsystem passes;
- at least one row has three or more coefficient monomials.
```

Call it **deletion-minimal** when every proper support obtained by deleting one
support point fails one of the first two conditions or is already killed by
PC3.

Deletion-minimality is a combinatorial search notion.  It is necessary but not
sufficient for being the support of an actual torus zero.

## Search lanes, in priority order

### Lane A — exact finite universes already present in the repository

Reuse, without broadening their theorem claims:

```text
director_probes_20260806/f55_*fan*.py
director_probes_20260806/f55_*level*.py
director_probes_20260808/f55_phase_holonomy_d7.py
```

Extract supports that survived their generator-level/no-singleton screens and
translate them into the PC2/PC3 schema where mathematically appropriate.
Do not conflate the projective-covariant and trace-cubic support spaces.

The first required regression is the degree-7 support universe: PC3 must kill
all 32 supports by the known polar identity.

### Lane B — bounded homogeneous covariant ladder

For each degree beginning with `d=10`, use the established F55 covariant weight
space and landing compiler to enumerate maximal no-singleton supports.  Apply
the same polar-determinant and holonomy filters, with exact
`Q(zeta_5)` coefficients on this bounded covariant side.

Run degrees in increasing order and stop at the first deletion-minimal
multinomial exception.  Suggested initial cap:

```text
d <= 14
```

Do not increase the cap until the runner reports universe size, MILP variable
count, estimated memory, and a checkpoint format.

This lane is calibration for the circuit mechanism; it is not the
all-Laurent trace theorem.

### Lane C — bounded trace-support universes

Build only finite, explicitly declared universes `U subset M`, for example:

```text
coordinate box [-B,B]^4;
a pointed face cone with a fixed height cap;
a collision closure generated from a selected seed support.
```

For each universe, state why it is finite and list every normalization imposed.
No normalization may use a nonexistent invariant exponent translation.

Search nonempty subsets by MILP/SAT for the no-singleton condition.  Enumerate
maximal supports first, then descend by deletion with memoized row counts.
Every solver support must be rechecked by exact integer combinatorics.

Suggested initial runs:

```text
B=1, then B=2 only if the first run is small;
seed closures of cardinality <= 40;
support cardinality cap <= 12 before any larger run.
```

## Search algorithm requirements

### PC4.1 — do not enumerate all subsets blindly

Maintain, for each row, the active term count as support variables change.
Use one of:

```text
binary MILP with AND variables for coefficient monomials;
incremental SAT/pseudo-Boolean constraints;
branch-and-bound with row-count propagation.
```

A row count of exactly one is a conflict.  Cache supports modulo literal
identity only; no unproved symmetry quotient is allowed.

### PC4.2 — exact postfilter

For every solver output:

1. rebuild PC2 rows exactly;
2. verify no-singleton exactly;
3. compute incidence connectedness;
4. run PC3 completely;
5. test all single-point deletions;
6. hash the canonical support and rows.

Only then may it be called an exception.

### PC4.3 — record the cancellation hypergraph

For the first exception, emit:

```text
support points;
all rows and coefficient monomials;
row cardinality distribution;
variable degrees in the incidence graph;
all binomial exponent differences and ratios;
all polar candidates, including polluted and zero-determinant cases;
a spanning tree of the incidence graph;
single-deletion outcomes.
```

This is the input for a human proof of Coverage Theorem C.

### PC4.4 — search for recurrence, not a headline

After locating the smallest exception, test whether it belongs to a parameter
family under:

```text
sigma action;
scaling of exponent parameters compatible with the fixed e2 defect;
Minkowski addition by an explicitly invariant polynomial factor;
slot-pattern-preserving affine lattice solutions.
```

Every proposed recurrence must be written as exact exponent equations and
verified for at least three distinct parameter values.  Do not call it an
all-degree family until the equations are proved symbolically.

## Deliverables

Create:

```text
problems/E-klein-cubic/certificates/f55_polar_circuit/pc4/
  search.py
  exact_postcheck.py
  universes/
  exceptions/
  BOUNDED_SEARCH.md
  search_summary.json
  README.md
  SEAL.json
```

For each finite universe, record:

```text
universe hash;
number of support variables;
number of landing rows and coefficient monomials;
solver and exact-postcheck counts;
maximal supports found;
exceptions found;
peak wall/RSS.
```

## Exit labels

Exactly one per run:

```text
PC4-EXCEPTION-FOUND
PC4-BOUNDED-EMPTY
PC4-RESOURCE-GATE
PC4-COMPILER-MISMATCH
```

The overall verifier prints:

```text
F55-PC4-MINIMAL-CORE-SEARCH-OK
```

## Stop conditions

Stop immediately when the first deletion-minimal exception is found and pass
it to PC5.  Do not continue merely to accumulate empty degree ranges.

If a proposed finite bound for Coverage Theorem C emerges, stop computation
and write the proof obligation explicitly.  The bound must be proved before a
bounded exhaustive run can become headline-relevant.

## Resource gate

Exploration begins under:

```text
wall <= 10 minutes per checkpoint
RSS  <= 8 GB
```

A larger run requires a committed size report and director approval.  Dense
matrices over all support subsets are forbidden.

## Theorem boundary

`PC4-BOUNDED-EMPTY` is never an F55 negative theorem.  `PC4-EXCEPTION-FOUND`
is not a positive point.  This packet supplies the smallest exact object on
which either a structural coverage proof or PC5 saturation should operate.
