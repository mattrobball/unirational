# Numerical probe (non-certificate)

HomotopyContinuation.jl 2.22.2 was run on the Rabinowitsch-saturated system.
All numbers in this file are discovery data only; they are not used by the
exact replay and are not a degree or factorization theorem.

For roots `(1,2,3,4,1/24)`, polyhedral homotopy tracked the exact 26264 mixed
cells.  It reported 25753 nonsingular endpoints and 452 singular endpoint
clusters.  The latter consisted numerically of 440 singleton clusters and
12 double clusters, for a multiplicity-accounted finite count of 26217;
47 paths were unresolved or divergent.

For the more balanced but symmetric roots `(1,2,-1,-2,1/4)`, the same run
reported 25984 nonsingular endpoints and 244 singular endpoint clusters,
one of them double, for a multiplicity-accounted finite count of 26229;
35 paths were unresolved or divergent.

The changing deficit and many ill-conditioned endpoints show why these
runs cannot certify the generic degree.  They do show that the finite cover
is computationally large and close to its toric BKK bound.  No degree-one
branch or exact factorization was detected.
