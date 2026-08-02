# PC.1 transition closure

Status: exact minimal ledger through degree four; an exact finite nonminimal
stable kernel presentation is proved through degree six.

Work over `S=F_89[q0,...,q36]` in

```text
F = S + S(-1)^6 + S(-2)^21.
```

The direct landing cubics span `V0+W` in the polynomial ring.  The residual
690 rows are the degree-three relation seeds in `F`.  Their multiplication
closure, the transition-stable relation module, and the eventual quotient
`F/N` are distinct objects.

## Degree four: pure-q projection

Projecting to the pure-q component gives

```text
rank(S1 V0)                         25530
rank(pure-q closure)                27583
new quotient dimension               2053
transition syzygies in the quotient  2087
commutator quotient rank               210
commutators adding to transition span    0
```

The cumulative transition ranks modulo `S1 V0` are

```text
690, 1332, 1702, 1923, 2031, 2053.
```

The canonical 2053-row normal form eliminates the 19 pivots of the PC.0
multiplication kernel.  This number is the minimal transition basis only in
the pure-q projection.  It is not the number of generators in the coupled
28-component module.

## Degree four: coupled module

The raw coupled candidate list contains

```text
25530  q-multiples of the 690 seeds,
 4140  T_i(seed) rows,
  315  raw quadratic commutator defects,
------
29985  raw rows.
```

The commutators are edges among 336 monic-reduction paths.  Their exact
incidence rank is 210 and their universal cycle space has dimension 105.
Every path input is byte-matched to the corresponding monic rewrite rule; by
`S`-linearity, the `315 x 336` incidence factorization holds on all 160,987
degree-four coordinates, not just on the pure-q block.

After choosing a canonical 210-row commutator basis, all

```text
25530 + 4140 + 210 = 29880
```

coupled rows are independent.  The proof constructs the complete
2297-dimensional pure-q dependency space (`2278` formal dependencies plus 19
lifted PC.0 kernels) and proves that its deterministic 3,000-coordinate
residual has rank 2297.  Therefore degree four adds exactly 4350 coupled
generators: all 4140 transitions and 210 commutators.

`verify_pc1_coupled_degree4.py` independently rebuilds the path incidence,
all-coordinate factorization, dependency space, and residual rank.  Its
terminal marker is `PASS_INDEPENDENT_PC1_COUPLED_DEGREE4_REPLAY`.

## Minimal degree five and the invalid monic shortcut

The next multiplication source is exactly

```text
M5 = S2*G3 + S1*G4,
source rows = 690*703 + 4350*37 = 646020,
dim(F5) = 1489657.
```

Modulo path commutation, the new minimal transition schedule has at most

```text
21*690 + 6*210 = 15750
```

controlling rows.  Their minimal quotient rank has not been computed.

The Betti chain `56 | 210,336,280,120,21` belongs to the leading monomial
ideal `(K)^3`.  It does not give a degree-eight bound here: the first 210
lifted syzygies reduce to the certified nonzero commutators, so the deformed
56-rule system is not a Groebner or border basis.  New q-leading remainders can
create further Schreyer pairs in arbitrarily later degrees unless explicitly
controlled.  `PC1_HIGHER_BOUND_AUDIT.md` records why this route does not give
the missing minimal ledger.

## Exact finite nonminimal stabilization

The separate border packet closes the same relation kernel without assuming
the monomial Betti chain.  With `B=1+K+Sym2(K)`, it installs

```text
690 * 28 = 19320  seed states, degrees 3--5,
210 * 28 =  5880  commutator-forest states, degrees 4--6,
             -----
             25200  finite nonminimal state generators.
```

For every one of the 56 cubic rewrite rules, the independent verifier
reconstructs the universal commutator forest and exact signed circuits for
all border columns:

```text
constant defects       56/56 zero,
linear defects        336/336 in C,
quadratic defects   1176/1176 in S1*C + sum_i T_i(C).
```

These polynomial circuit identities prove that every `T_i` preserves the
finite hull.  On its quotient the induced transitions commute, the 56 monic
rules and all 690 residual seeds vanish, and monic reduction gives inverse
maps with the original polynomial quotient.  Hence the finite hull equals
the true transition-stable relation kernel over `F_89`.

This does not give the minimal degree-5/6 ranks, syzygies, normal-form bases,
characters, or minimal transition matrices.  Accordingly the scoped border
status passes, but `PC25-STABLE-PRESENTATION-PASS` remains unauthorized.

## Representation and carrier ledger

The degree-25 coefficient space lies in
`Hom_G(Sym^25(W),W)`, so the canonical conjugation action of
`G=PSL_2(F_11)` fixes it pointwise.  Accordingly the exact coefficient-side
character of every recorded space is constant on the eight conjugacy classes.
The `315` entry is the formal commutator row-label source, while its actual
image has dimension `210`; the ledger labels those two spaces separately.

`verify_representation_characters.py` also exhausts all `6!=720` pure-K
coordinate permutations with Q fixed; only the identity preserves every
coefficient of the sealed rewrite tensor.  The nontrivial D12 source/jet
characters in the repository do not act on the Q/K coefficient module and are
kept separate.

The 28 states `1+K+Sym2(K)` form a minimal S-generating carrier: modulo the
q-irrelevant ideal, all cubic and higher relations vanish while all 28 states
survive.  This carrier minimality does not imply a minimal stabilized relation
presentation.  Exact nonminimal border reductions now exist, but minimal
higher transition matrices do not, so `PC25-STABLE-PRESENTATION-PASS` remains
unauthorized.
