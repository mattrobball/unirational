<!-- AMBIENT_HODGE_REES_BRIDGE_20260810 -->

## 2026-08-10 ambient Hodge support on the normalized Rees graph

Packet:

`goal_runs_20260810/AMBIENT_HODGE_REES_BRIDGE/`

**Exit:** `AMBIENT-HODGE-SUPPORT-PROVED`, `RESTRICTED-TRANSFER-UNDECIDED`.
**Headline:** Problem E remains **OPEN**.  Director-reviewed and merged
(PR #15); Hanamura--Saito and de Cataldo--Migliorini citations spot-checked.

For a hypothetical dominant `G`-equivariant ambient landing map
`A:P4-->X` with primitive landing ideal `I_A`, the ambient normalized graph
\[
Y=\operatorname{Proj}_{\mathbf P^4}\overline{\mathcal R(I_A)}
\]
carries a canonical `G`-equivariant injection
`alpha_A: H^3(X,Q) -> IH^3(Y,Q)` of the **actual** landing image
(relatively-ample splitting + weight strictness + the Hanamura--Saito
middle-weight injection), not an abstract occurrence of the representation on
a refinement.  This is the resolution-independent replacement for "some
blowup center has the right `H^1`": weak factorization can move resolution
centers, but `Y`, `alpha_A`, the perverse jump, and the support package
cannot move.

The forcing theorem: in the perverse Leray filtration of `Rp_*IC_Y^H` over
`P4`, the unique full-support constituent contributes `H^3(P4)=0`, so the
irreducible `V=H^3(X,Q)(1)` has a unique perverse jump `j_0` and a nonzero
projection to at least one `G`-orbit of proper strict-support blocks
`M_{S,j_0}` with `S` in the ambient base locus and `dim S<=2`.  The necessary
condition is
\[
\operatorname{Hom}_{\mathrm{HS},H}
(\operatorname{Res}_HV,\,H^{-1-j_0}(\mathbf P^4,\mathcal M_{S,j_0})(1))\ne0,
\qquad H=\operatorname{Stab}_G(S).
\tag{AHS}
\]
The image is weight one after twist and defines a support abelian factor
`A_{S,j_0}` up to `H`-isogeny containing a nonzero `E_{-11}`-isotypic factor
(accepted Auto-CM input).

Boundary discipline, all retained and none silently strengthened: the
unconditional invariant is a strict-support Hodge-module block, not
necessarily ordinary `H^1` of a subvariety, a finite cover, an Albanese, or a
Rees divisor.  The cone-over-a-positive-genus-curve countermodel
(`CONTRACTION_COUNTERMODEL.md`) has `H^1(S)=0` and `Alb(S)=0` but
`IH^1(S)=H^1(C)`, so ordinary-Albanese descent is false in this generality.
A finite-cover ordinary-`H^1` carrier follows only under the finite-monodromy
Tate hypothesis on the selected constituent.  The free-support escape stands:
no theorem forces a support orbit to meet the 55-involution/`V4` arrangement
or to have nontrivial stabilizer.  Point-supported nonsemismall constituents
are legal.  No canonical splitting or Chow-correspondence projector is
claimed.

Transfer to the restricted normalized graph
`Gamma = Proj_X(Rees(J)-bar)` is undecided and is now the binding gap (RT):
the full-support `IC_X` term for `Gamma->X` already contributes `H^3(X)`, so
nothing forces the restricted class into exceptional support; derived
restriction may have a `V`-isotypic vanishing-cycle kernel (CT2), the
selected support may miss the dominant component (CT1), and normalization may
kill the comparison (CT3).  Neither the joint-residue theorem nor the
carrier-rigidity packet proves (RT).

Precedence note: this supersedes the 2026-08-09 exceptional-carrier entry's
"smallest remaining theorem" (the type-I/type-II exact landing-tuple
computation).  No further type-I/type-II enumeration is justified until (RT)
or an arrangement-localization substitute is proved.  The cheapest decision
point, recorded at director review: the restricted selfmap correspondence
induces `Phi` in `End_{G-HS}(V)`, zero or invertible by irreducibility; if
invertible, total full-support absorption is potentially realizable and (RT)
as stated may be unprovable without new input on the landing ideal.  Decide
`Phi` first (selfmap-classification line), then choose between proving (RT)
(perverse weak Lefschetz along the ample inclusion `X` in `P4`) and routing
around it (arrangement localization via degree/orbit-size bounds on
`Bs(I_A)`; CM-rigidity upgrade of the Tate hypothesis).
