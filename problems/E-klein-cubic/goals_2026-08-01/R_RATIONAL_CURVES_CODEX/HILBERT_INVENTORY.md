# Hilbert-scheme inventory for the genuine generic Klein twist

## Ranking and cutoff

The exact inventory cutoff is \(e_0=3\).

This is a geometric cutoff, not a computational convenience.  Degree two
is entirely controlled by residual lines, and degree three is the first
nonplanar case for which an Aut\((X)\)-equivariant compactified
Abel--Jacobi theorem is available for **every** smooth cubic threefold.
The strongest rational-quartic fibre theorem in the audited source assumes
a generic cubic; the Klein cubic is maximally special and has automorphism
group \(G\), so that theorem is not imported across the hypothesis.

## Exact components through degree three

| Degree | Geometric locus over \(\mathbf C\) | Dimension / map | Twisted descent over \(K_{\rm proj}\) | Exact status |
|---:|---|---|---|---|
| 1 | Fano surface \(F(X)\) of lines | smooth projective surface | a point would give a faithful very versal image of dimension at most 2 | empty by the binding no-line theorem |
| 2 | geometrically integral conics; every conic spans a plane and has a residual line | open incidence over \(F(X)\), with planes through the residual line | a \(K\)-conic produces a \(K\)-line | **all geometrically integral \(K\)-conics excluded** |
| 3 | smooth twisted-cubic locus \(\mathcal T\) and Hilbert closure \(\overline{\mathcal T}\) | \(\mathcal T\) is smooth of dimension 6; Abel--Jacobi image \(\Theta\), generic fibre \(\mathbf P^2\) | \({}^T J(K)=0\); the moduli desingularization over zero has exceptional divisor \(X_T\) | a twisted-cubic Hilbert point forces \(X_T(K)\ne\varnothing\); no independent descended Abel--Jacobi parameter |

For a smooth twisted cubic \(C\simeq\mathbf P^1_K\), a point of \(C(K)\)
already gives a point of \(X_T(K)\).  The moduli argument is stronger only
in that it also controls every boundary point of the generalized
twisted-cubic component that maps to the canonical sheaf moduli space.

## Higher-degree ledger (not promoted to theorem)

| Candidate | Reliable geometric input | Descent gap on the Klein twist | Status |
|---|---|---|---|
| rational normal quartics | expected Hilbert dimension 8; for a **generic cubic** the Abel--Jacobi map is dominant with generic 3-fold fibre birational to the cubic | generic-cubic hypothesis fails for the Klein cubic; the zero fibre selected by \({}^T J(K)=0\) is not identified here | open |
| elliptic normal quintics | classical Hilbert/Serre construction; generic Abel--Jacobi fibres are projective 5-spaces, with irreducibility results extending across smooth cubics | an elliptic curve is not a rational point; the twisted projective fibre and any residual intersection must be descended exactly | open |
| rational quintics and higher rational curves | expected dimension \(2e\) at unobstructed smooth rational curves | no audited Aut\((X)\)-equivariant component compactification or \(K\)-Hilbert point | open |
| curves through the degree-55 orbit | the orbit gives a genuine closed point / incidence condition on the Schur-side model | no exact incidence component over the genuine \(K_{\rm proj}\) twist has been produced; the Schur and projective generic fields must not be conflated | open |

## Abel--Jacobi descent ledger

The key new arithmetic input is

\[
{}^T J(X)(K_{\rm proj})=0.
\]

Therefore every Aut\((X)\)-equivariant Abel--Jacobi construction on a
candidate component must land at its canonical zero after twisting.  This
does not make the component empty: it replaces “find any descended
Abel--Jacobi parameter” by the sharper task “analyze the zero fibre and
produce a geometrically integral split curve there.”

For twisted cubics the zero fibre is now exact through the theta blowup and
is the original cubic.  For quartics and higher degrees that zero-fibre
identification is the smallest missing component theorem.

## Prohibited inferences checked

- A Galois-stable geometric component is not treated as a \(K\)-point.
- A reducible Hilbert cycle is not treated as a rational curve.
- A genus-zero curve is not treated as split without an index-one proof.
- Generic-cubic quartic theorems are not specialized to the Klein cubic by
  assertion.
- The Schur-source degree-55 point is not silently moved to
  \(K_{\rm proj}\).
- No finite-field or bounded search is used as an emptiness theorem.

