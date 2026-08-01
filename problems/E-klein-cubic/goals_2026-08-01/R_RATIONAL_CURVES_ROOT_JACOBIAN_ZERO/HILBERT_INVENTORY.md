# Hilbert-scheme inventory for the genuine generic Klein twist

## Ranking and cutoff

The exact inventory cutoff is \(e_0=5\).

This is the full small-degree range in which Harris--Roth--Starr determine
the geometric rational-curve components and general Abel--Jacobi fibres for
**every** smooth cubic threefold.  Degree two is entirely controlled by
residual lines; degree three has an Aut\((X)\)-equivariant compactified
theta-desingularization; degrees four and five have all-smooth-cubic
irreducibility and general-fibre theorems.  Their distinguished canonical
zero fibres are not determined by those general-fibre results.

## Exact components through degree five

| Degree | Geometric locus over \(\mathbf C\) | Dimension / map | Twisted descent over \(K_{\rm proj}\) | Exact status |
|---:|---|---|---|---|
| 1 | Fano surface \(F(X)\) of lines | smooth projective surface | a point would give a faithful very versal image of dimension at most 2 | empty by the binding no-line theorem |
| 2 | geometrically integral conics; every conic spans a plane and has a residual line | open incidence over \(F(X)\), with planes through the residual line | a \(K\)-conic produces a \(K\)-line | **all geometrically integral \(K\)-conics excluded** |
| 3 | smooth twisted-cubic locus \(\mathcal T\) and Hilbert closure \(\overline{\mathcal T}\) | \(\mathcal T\) is smooth of dimension 6; Abel--Jacobi image \(\Theta\), generic fibre \(\mathbf P^2\) | \({}^T J(K)=0\); the moduli desingularization over zero has exceptional divisor \(X_T\) | a twisted-cubic Hilbert point forces \(X_T(K)\ne\varnothing\); no independent descended Abel--Jacobi parameter |
| 4 | smooth geometrically rational quartics \(\mathcal H_{4,0}\) | irreducible dimension 8; usual Abel--Jacobi map dominant, general fibre irreducible unirational dimension 3; the component is not rationally connected | canonical \(a_4(C)=\operatorname{AJ}(3[C]-4H^2)\) is Aut\((X)\)-equivariant and every twisted \(K\)-point lies over zero | any such \(K\)-curve forces \(X_T(K)\ne\varnothing\) by the secant bridge; the special zero fibre remains unidentified |
| 4, genus 1 | smooth quartic elliptic curves | smooth connected dimension 8; birationally a \(\mathbf P^4\)-bundle over a \(\mathbf P^2\)-bundle over \(F(X)\) | canonical residual-line morphism to \(F(X)\) | **empty on the generic twist** by the binding no-line theorem |
| 5 | smooth geometrically rational quintics \(\mathcal H_{5,0}\) | irreducible dimension 10; usual Abel--Jacobi map dominant, general fibre irreducible unirational dimension 5; the component is not rationally connected | canonical \(a_5(C)=\operatorname{AJ}(3[C]-5H^2)\) is Aut\((X)\)-equivariant and every twisted \(K\)-point lies over zero | any such \(K\)-curve forces \(X_T(K)\ne\varnothing\); cubic-scroll residuation does not itself give a zero-fibre point |
| 5, genus 1 | smooth elliptic quintics | irreducible dimension 10; usual Abel--Jacobi map dominant, general fibre irreducible unirational dimension 5 | the relative \(\operatorname{Pic}^2\) parametrizes cubic scrolls and residual rational quartics | open: if \(\alpha\) is the genus-one torsor class, the polarization gives \(5\alpha=0\), while a \(\operatorname{Pic}^2\)-point gives \(2\alpha=0\), hence \(\alpha=0\); the residual route is already a point construction |
| 5, genus 2 | smooth quintic genus-two curves | normalization smooth connected dimension 10; map to the Fano surface has rational 8-fold fibres | any \(K\)-curve is residual to a \(K\)-line in a quadric--cubic complete intersection | **empty on the generic twist** by the binding no-line theorem |

For any geometrically integral \(K\)-curve on \(X_T\) whose normalization
has genus zero, a \(K\)-point of \(X_T\) follows even if the normalization is
a nonsplit conic.  Choose a \(K\)-rational anticanonical divisor of degree
two on the normalization and take its secant line; the third intersection
with the cubic is a \(K\)-point unless the line is contained in the cubic,
in which case the line itself supplies a point.  The degree-three moduli
argument is stronger only because it also controls boundary points of the
generalized twisted-cubic component.

The cited small-curve source proves irreducibility and dimension but does
not assert global smoothness for the quartic and rational-quintic loci;
this inventory likewise makes no global smoothness claim.  Dominance to
the abelian fivefold shows that the total loci are not rationally connected
or unirational, despite the unirationality of a general fibre.

## Continuation and zero-fibre ledger

| Candidate | Reliable geometric input | Descent gap on the Klein twist | Status |
|---|---|---|---|
| rational quartic zero fibre | component dimension 8 and general Abel--Jacobi fibre dimension 3, irreducible and unirational, for every smooth cubic | the all-smooth theorem concerns the general fibre; the canonical zero fibre selected by \({}^T J(K)=0\) is not identified; the stronger fibre-birational-to-\(X\) theorem assumes a generic cubic | open special fibre |
| elliptic normal quintics | all-smooth-cubic component and general-fibre geometry are known; the relative \(\operatorname{Pic}^2\) gives the cubic-scroll residual construction | for torsor class \(\alpha\), the embedding gives \(5\alpha=0\) and a \(\operatorname{Pic}^2\)-point gives \(2\alpha=0\), hence \(\alpha=0\); the scroll choice is already equivalent to a point on the elliptic curve | open |
| rational quintic zero fibre | component dimension 10 and general Abel--Jacobi fibre dimension 5, irreducible and unirational, for every smooth cubic; a nondegenerate quintic has a unique trisecant and cubic-scroll residual quartic | the canonical zero fibre is not identified and the residual construction presupposes a descended curve/scroll | open special fibre |
| rational curves of degree \(e\ge6\) | expected dimension \(2e\) at unobstructed curves; the audited small-degree theorem stops at five | no audited component, unirationality, compactified zero-fibre theorem, or \(K\)-Hilbert point; a descended integral genus-zero curve would already solve the headline by the secant bridge | open |
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

For a degree-\(e\) family the basepoint-free normalization is

\[
a_e(C)=\operatorname{AJ}(3[C]-eH^2),
\]

because \(H^2\) has degree three and is Aut\((X)\)-invariant.  The usual
Abel--Jacobi maps in the classical sources are only defined up to
translation.  Over \(\mathbf C\), \(a_e\) is multiplication by three after
such a map, up to a fixed translation; this distinction is essential for
twisting.

For twisted cubics the zero fibre is exact through the theta blowup and is
the original cubic.  For quartics and higher degrees, identifying or
pointing the distinguished canonical zero fibre is the smallest missing
component theorem.  Geometric unirationality of a general fibre does not
imply a point on its generic twist.

## Prohibited inferences checked

- A Galois-stable geometric component is not treated as a \(K\)-point.
- A reducible Hilbert cycle is not treated as a rational curve.
- A genus-zero curve is not treated as split without an index-one proof.
- The all-smooth-cubic general-fibre theorems are not turned into a theorem
  about the distinguished zero fibre, and the generic-cubic
  fibre-birational-to-\(X\) theorem is not specialized by assertion.
- The Schur-source degree-55 point is not silently moved to
  \(K_{\rm proj}\).
- No finite-field or bounded search is used as an emptiness theorem.
