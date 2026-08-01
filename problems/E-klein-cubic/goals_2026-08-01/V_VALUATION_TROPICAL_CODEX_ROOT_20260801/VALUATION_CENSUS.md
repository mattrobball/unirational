# Valuation census for the genuine generic Klein twist

## Scope convention

The binding point problem is the genuine twist

\[
Y/K_{\rm aff},\qquad
K_{\rm aff}=\mathbf C(W)^G,qquad
\Phi(a)=F(a_0x+a_1C+a_2D+a_3E+a_4K).
\]

The global point problem is equivalent to the projective-field problem over
$K_{\rm proj}$, because $K_{\rm aff}/K_{\rm proj}$ is purely
transcendental of degree one and $Y$ is proper.  A local statement is
labelled genuine only when its model is point-equivalent to this $Y$ at the
chosen valuation.

The fixed-frame Pfaffian plane cubic is an auxiliary genus-one object.  Its
local points and its index-three base-field theorem are not silently promoted
to statements about $Y$.

## Ranked census

| Rank | valuation family | exact field/model | residue/ramification | result | headline value |
|---:|---|---|---|---|---|
| 1 | $P_x=F(x)=f_3$ | genuine $K_{\rm aff}$ Hilbert--90 cubic | absolutely prime, $e=1$ | simple axis point; Hensel lift | retired as negative site |
| 2 | $P_C=F(C)=f_{12}$ | genuine $K_{\rm aff}$ Hilbert--90 cubic | absolutely prime, $e=1$ | simple axis point; Hensel lift | retired as negative site |
| 3 | $P_D=F(D)$ | genuine $K_{\rm aff}$ Hilbert--90 cubic | absolutely prime degree 15, $e=1$ | simple axis point; Hensel lift | retired as negative site |
| 4 | $P_E=F(E)$ | genuine $K_{\rm aff}$ Hilbert--90 cubic | absolutely prime degree 18, $e=1$ | simple axis point; Hensel lift | retired as negative site |
| 5 | $P_K=F(K)$ | genuine $K_{\rm aff}$ Hilbert--90 cubic | absolutely prime degree 21, $e=1$ | simple axis point; Hensel lift | retired as negative site |
| 6 | $f_5=0$ invariant boundary | genuine model not yet installed on one certified open | source prime and quotient $e=1$ known from prior audit | canonical Hessian-kernel line excluded; full residue cubic undecided | best concrete successor |
| 7 | $f_6,f_7,f_8,f_9,f_{10},f_{11},f_{14}=0$ | genuine model requires exact coefficient valuations/gauge | not censused component by component | open | possible, no exit |
| 8 | genuine cubic discriminant divisors | discriminant of $\Phi$, not auxiliary xCD/Pfaffian discriminants | factorization and inertia not installed | open | possible, higher complexity |
| 9 | frame divisor $\det[x,C,D,E,K]=0$ | current trivialization fails | a gauge boundary, not automatically bad reduction of $Y$ | must change frame first | low until re-trivialized |
| 10 | maximal-subgroup quotient divisors | proper-subgroup generic twists | owned by Goal H | not imported | separate route |
| 11 | weighted monomial/higher-rank valuations | genuine coefficients in every projective chart | infinite family | no exhaustive initial-form theorem | open |
| 12 | toroidal exceptional divisors | blowups of coefficient map | no common resolution constructed | open | high cost |

## Auxiliary valuations retained only as warnings

| site | proved auxiliary statement | why it is not a Goal V headline result |
|---|---|---|
| Pfaffian $D_3=(f_3=0)$ | exact completed point in projector open | it is a point on the auxiliary depressed plane cubic, not a point of the genuine Klein twist |
| Pfaffian $D_5=(f_5=0)$ | exact constant residue point and Hensel lift | same scope failure; it does not settle the genuine $f_5$ special cubic |
| fixed-frame target branch | one branch with residue degree one; fixed-frame special cubic smooth | its remaining index is open, and fixed-frame point-equivalence through $K_{\rm proj}/F$ is exactly the unresolved bridge |
| raw $\alpha_R$ coefficient valuations | mixed-weight diagnostic data | the saved gauge contains mixed-weight addition; coordinatewise valuation is invalid |

## Structural ranking constraints

### Index

Every genuine twist carries effective cycles of degrees $60,132,165,220$,
and the same cycles survive every scalar extension.  Thus all local indices
are one.  This removes from the ranking any candidate whose promised payoff
is:

- all component multiplicities divisible by three;
- zero-cycle specialization image $3\mathbf Z$;
- absence of a prime-to-three local zero-cycle.

Such a computation would contradict an already proved invariant rather than
resolve the problem.

### Ordinary Brauer group

For the genuine smooth cubic threefold,
$\operatorname{Br}(Y)=\operatorname{Br}(K)$.  Consequently a candidate is
not ranked on the prospect of finding a nonconstant ordinary Brauer class.
Higher unramified cohomology remains a distinct open possibility.

### Tropical geometry

More strongly, every discrete rank-one valuation of the exact 35-term cubic
has an integral tropical value vector, by the pure-cube modulo-three Newton
edge theorem in `THEOREM.md`.  A useful candidate must therefore offer
tractable **residue initial forms**, not merely a small Newton polytope.  A
valid negative computation must cover:

1. every finite coordinate-valuation cone;
2. all five projective boundary charts;
3. every coefficient cancellation on cone walls;
4. rational points over the actual residue field, not only its algebraic
   closure;
5. the field/model bridge back to $K_{\rm aff}$ or $K_{\rm proj}$.

No candidate currently meets all five tests.

## Why the exhaustive-survival exit is unavailable

The five new axis divisors form a natural infinite-pattern seed, but they do
not exhaust irreducible invariant divisors, discriminant components,
higher-rank monomial valuations, or exceptional divisors.  Therefore
`V-ALL-NATURAL-VALUATIONS-SURVIVE` is not claimed.  The exact route exit is
`V-UNDECIDED`.

## Next exact gate

Use the genuine $f_5=0$ divisor because its absolute primality and quotient
unramifiedness are already certified upstream.  Required steps:

1. express all 35 genuine Hilbert--90 coefficients integrally at $f_5$ on
   one common open;
2. prove the proper special cubic is smooth, or construct and audit a regular
   model if it is not;
3. decide its rational points over $\mathbf C(f_5=0)^G$, away from the
   excluded canonical Hessian-kernel line and with all projective charts
   exhaustive;
4. if pointless, apply smooth proper reduction to obtain a pointless
   completion and then the genuine generic-twist bridge;
5. if soluble, save a simple residue point and retire the divisor.

The residue cubic has index one and trivial relative ordinary Brauer group,
so neither fact decides Step 3.
