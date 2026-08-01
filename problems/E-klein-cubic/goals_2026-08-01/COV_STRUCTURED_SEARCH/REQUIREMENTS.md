# Requirement ledger

## Headline acceptance

A positive headline requires one exact nonzero primitive homogeneous
`PSL(2,11)`-equivariant map `p : W -> W`, of degree at least 25, with
`F(p)=0`, together with an exact nonzero projective Jacobian minor proving
generic rank four and the `BR-COV-POS` bridge.

Anything weaker receives only one of the scoped exits authorized by the goal
packet.  In particular, a modular point, a formal normal jet, an empty finite
ansatz, or an empty bounded degree search is not a headline theorem.

## Required production

1. Rank a bounded structured degree list using exact self-covariant and
   invariant Molien dimensions, residual classes, primitive/composition
   information, and the size of the available global restriction modules.
2. Include the first unresolved representatives of the residual `e>=7`,
   `e=1`, and `e=5` classes.  These are degrees 25, 31, and 35.
3. For every selected degree, give an exact covariant source model and exact
   arrangement/fixed-locus constraint data, with independent good-prime
   holdouts where computed.
4. Build globally equivariant structured ansatz families.  Never patch local
   coefficient vectors.
5. Decompose and solve their landing equations exactly.  Modular work is
   discovery or a characteristic-zero exclusion only when a valid proper
   specialization argument and a verified integral model apply.
6. If a candidate survives, reconstruct it in characteristic zero and verify
   equivariance, `F(p)=0`, primitivity, dense-open definition, and generic
   Jacobian rank four.
7. Deliver `STATUS.md`, `DEGREE_RANKING.md`, one directory per selected
   degree, machine-readable payloads, producer scripts, an independent
   verifier, and `SEAL.json`.

## Current theorem boundary

The repository headline is open.  Degree 25 has a 43-dimensional strict
space but its full landing support remains undecided.  The latest degree-25
lower module presentation is not `T`-stable; its sampled/compressed support
work is therefore not a positive candidate and not a characteristic-zero
emptiness certificate.  Ignored scratch packets for degrees 31 and 35 are
treated only as algorithmic hints until this directory independently binds
the data it uses.
