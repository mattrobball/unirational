# Ambient torsor lifting

Let `B=X/G` and let `alpha_X in H^1(C(B),G)` be the generic torsor. The accepted
generic classification identifies arbitrary dominant equivariant selfmaps with
pairs `(psi,iota)` satisfying `iota:psi^*alpha_X ~= alpha_X`.

Ambient extendability is strictly extra. Given such a pair, choose homogeneous
coordinate sections on `X` and ambient lifts `S`. Their defect is the uniquely
defined quotient

\[
F(S)=F\,A_S.
\]

Changing lifts by `S -> S+FQ` changes `A_S` by nonlinear polar terms. Thus
ambient extendability is the existence of a lift in this affine space for which
`A_S=0`.

This can be regarded as a nonlinear lifting obstruction attached to the pair,
but not presently as a single cohomology class: the transformation law of
`A_S` contains quadratic and cubic terms in `Q`. The natural object is the
zero-locus of this polynomial defect map on the space of ambient lifts.

The postcomposition theorem gives its strongest functorial property. If a pair
is ambient-extendable and `(theta,j)` is any torsor-preserving selfmap pair, then
the composite pair is ambient-extendable. In coordinates this is exactly
`F(S(P))=F(P)B(P)=0`.

Hence the ambient-extendable locus in the torsor-preserving semigroup is a
right ideal (when nonempty), not a finite rigid subset.
