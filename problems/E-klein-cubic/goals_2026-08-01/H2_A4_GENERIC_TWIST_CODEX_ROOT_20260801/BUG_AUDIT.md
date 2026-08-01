# Audit of the installed bounded search

The statement in the goal's structural input that degrees 1--4 had already
been excluded is not valid.

In `a4_direct_search.py`, `symmetric_action(S,mons)` stores in column `j` the
coefficients of the substituted monomial `m_j(Sy)`.  Therefore the monomial
column satisfies

\[
 m(Sy)=M^T m(y),
\]

and a coefficient matrix `C` must satisfy

\[
 C M^T=R C.
\]

The installed linear system instead imposes `C M=R C`.  Its returned vectors
are generally not covariants, so the subsequent landing ideals do not
parameterize equivariant maps.

`audit_upstream_transpose.py` reconstructs the installed degree-3,
character-1 computation modulo 331 and tests direct substitution.  Each of
the four claimed basis vectors fails for each of the two generators: eight
failures total, with 50 disagreeing coefficients in every test.  The machine
record is `upstream_transpose_audit.json`.

With the transpose corrected, characteristic zero has a four-dimensional
degree-three character-1 space and a nonempty `p0=1` landing scheme.  That
exact computation, rather than any bounded ladder claim, supplies the H2
verdict.  The invalid exploratory degree-5 files were quarantined locally and
are excluded from the deliverable and seal.

