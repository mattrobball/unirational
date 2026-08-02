# Line monodromy, Picard lattice, and obstructions

The packet certifies the Lefschetz boundary of the pencil and the abstract
full-\(W(E_6)\) lattice calculation. It does **not** identify the actual
geometric or arithmetic permutation group of the 27 fibre lines.

The installed 55 involution-minus-lines lie on the cubic **threefold** and
become points on cubic-surface fibres. They are not the 27 lines contained in
a cubic surface.

## Exact two-prime Lefschetz certificate

At both exact-frame good reductions the critical incidence scheme is entirely
in the chart \(a_0=1\):

| prime | critical length | discriminant degree | squarefree | bad Hessian locus | infinity |
|---:|---:|---:|---|---|---|
| 23 | 24 | 24 | yes | empty | smooth |
| 67 | 24 | 24 | yes | empty | smooth |

The spatial Hessian, base derivative, and full four-by-four critical
Jacobian are nonzero at every critical point. The \(a_0=0\) complement is
empty on the other three projective charts. Thus each specialization has 24
distinct transverse \(A_1\) fibres and no singular fibre at infinity.

These are nonvanishing open conditions in a common exact integral model, so
the generic characteristic-zero Schur pencil has the same 24-node Lefschetz
profile. This is a spreading/nonvanishing inference; it does not label or
transport the individual modular nodes or their 27-line actions. The producer
retains both discriminants, factor degrees, chart tests, and hashes. The
independent verifier rebuilds the Singular ideals.

## What is not inferred from 24 nodes

Each node supplies a local Picard--Lefschetz reflection, but this packet has
not labelled those reflections as permutations of a common set of 27 lines
or computed the subgroup they generate. The universal/general-pencil
literature identifies full \(W(E_6)\) monodromy, but a pencil-specific
generality, surjectivity, or labelled-transport argument has not been sealed
here. Therefore:

- actual geometric 27-line monodromy: **unresolved**;
- actual arithmetic 27-line monodromy: **unresolved**.

As an additional exact modular check, six smooth fibres at the two good
reductions have complete reduced 27-line schemes in one Grassmann chart.
Their squarefree degree-27 eliminants exhibit five distinct cycle partitions,
all compatible with the abstract `W(E6)` action. For each characteristic
separately these constrain its finite-field arithmetic line cover. They are
not simultaneously labelled generators, and no common integral 27-line-cover
specialization map or constant-field/geometric comparison is certified.
Therefore they do not identify either characteristic-zero generic group. See
`LINE_FROBENIUS_SPECIALIZATIONS.md` and its independent verifier.

## Installed Picard group and abstract \(W(E_6)\) calculation

For \(F=K(q)\), closing a divisor from the smooth generic fibre \(S/F\) in
\(Y\), together with the installed relative Picard calculation, gives

\[
\operatorname{Pic}(S)
 =(\mathbf ZH\oplus\mathbf ZD)/\mathbf Z(H-D)
 =\mathbf Z[-K_S].
\]

This excludes a rational line class or conic-fibration class. It does not
exclude a rational point, because sections and quartic multisections are
closed points on \(S\), not divisor classes.

Separately, the producer constructs the cubic-surface Picard lattice with
basis \(h,e_1,\ldots,e_6\), intersection form
\(\operatorname{diag}(1,-1,\ldots,-1)\), and the six simple reflections.
Exact enumeration gives

\[
|W(E_6)|=51840,\qquad |\mathcal O(\text{root})|=72,\qquad
|\mathcal O(\text{line class})|=27.
\]

The common invariant lattice is \(\mathbf Z(-K)\). For integral
cohomology, the Coxeter cocycle system has 42 unknowns and rank 36. The
coboundary image has rank six and an explicitly stored \(6\times6\) minor
of determinant \(-1\), so it is saturated and equals the cocycle lattice:

\[
H^1(W(E_6),\operatorname{Pic}(S_{\bar F}))=0.
\]

This \(H^1\) statement applies to the generic fibre only **if** its actual
arithmetic action is proved to be full \(W(E_6)\). Since that premise remains
unproved here, the actual algebraic Brauer quotient remains unresolved.
Conditionally on full \(W(E_6)\), the displayed \(H^1\) computation makes
the algebraic Brauer quotient vanish through the Hochschild--Serre edge.

## Elementary obstruction and quartic boundary

Restriction to residue fields carrying the installed degree-three and
degree-55 points kills the elementary obstruction; corestriction gives
\(3\,\mathrm{ob}=55\,\mathrm{ob}=0\), hence \(\mathrm{ob}=0\). This is not a
rational-point theorem.

In the no-section branch, secant descent removes imprimitive quartic groups,
leaving \(A_4\) and \(S_4\). A quartic point need not lie on any of the 27
lines, so even a future full line-monodromy computation would not by itself
remove those two cases.

The machine-readable certificate is line_monodromy.json.
