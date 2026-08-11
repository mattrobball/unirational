## 2026-08-11 RT for actual landing ideals: D_X=0 proved, the conductor/Gysin exclusion refuted rationally, and two external claims overturned

Packet: `goal_runs_20260811/RT_ACTUAL_LANDING/`. Problem E remains **OPEN**.
Adjudicated port of an external, unaudited ChatGPT session (three successive
reports, the third correcting the first two). Per-claim verdicts in
`ADJUDICATION.md`: 13 confirmed, 2 confirmed only after this packet supplied
the missing proof, 1 weakened, 2 refuted, 1 cited repository input that does
not exist, 3 literature attributions corrected.

**Proved.** There is a `G`-equivariant `Theta : IC_Y^H -> Rh_*IC_Gamma^H[1]`
in `D^b MHM(Y)` with `Theta_H alpha_A = i_q`, so the actual copy of
`V = H^3(X,Q)(1)` survives restriction, dominant-component selection and
normalization as a Hodge substructure (`ACTUAL-V-TOTAL-TRANSFER-PROVED`). The
comparison morphism `h` is supplied by the sealed dominant-transform theorem
(`EXCEPTIONAL_CARRIER_RIGIDITY/AMBIENT_REES_COMPARISON.md` sec.2 eq. 2.1);
`h` is finite, which the external source did not use.

Combining with the ambient support theorem
(`AMBIENT_HODGE_REES_BRIDGE` Thm B) and a full-support leakage classification:
a proper ambient strict support can reach the restricted full-support summand
only if `S` is a surface inside `X`, hence a component of the divisorial gcd
`D_X`, in perverse degree `j = 0`, through `IC_S(U)(-1)`; and only the
**constant quotient** of `U` leaks. Hence

```
D_X = 0  =>  u_phi = t_pi i_q|_V = 0  and  r_phi = i_q|_V != 0,
```

i.e. **`D_X = 0` forces CARRIER** (`RT-DX0-PROVED`). Corollary: if the
restricted map is the identity then `D_X != 0`, so `D_X` has degree `k >= 5`
by the sealed invariant-degree lemma -- reproducing the repository's `d >= 6`
degree floor for a nontrivial `G`-retraction from the RT side, independently
of the polar-identity route. The two agree.

**Refuted (1): the conductor/local-genus Gysin exclusion**, which was the
proposed way to close RT in the CLEAN branch. The receiver it wanted to
exclude already exists: for **every** smooth cubic threefold, Bloch-Srinivas
makes `id_V` factor through `H^1` of a smooth model of a proper divisor,
`G`-equivariantly, over `Q`, unconditionally. The external source routed this
through the integral minimal class `theta^4/4!`; that input is real and sealed
(`DELTA1_MINIMAL_CLASS`, `KLEIN-IJ-MINIMAL-CLASS-ALGEBRAIC`) but is not
needed. Coefficient-level finding: the **rational** receiver is unconditional;
the **integral G-equivariant** statement is not available at all -- the
repository's own audit forces only `660 * M^{-1}` -- so this refutation leaves
an integral-equivariant door untouched, and we claim nothing about it. Voisin's
iff is the 2017 JEMS paper, not the 2013 one, and is open for the very general
cubic threefold.

**Refuted (2): "S normal => IH^1(S,Q) = 0".** This one the external source did
not withdraw; the adjudication overturns it. The error is that for normal `S`
the map `H^1(S) -> IH^1(S)` is only injective, and `IH^1(S)` is computed on a
resolution. Exact countermodel, machine-verified:
`X' = {x0^3+x1^3+x2^3+x3^2x4+x4^3}` is a smooth cubic threefold whose
hyperplane section `{x4=0}` is the normal Cartier cone over the Fermat plane
cubic, with `H^1(S,O_S) = 0` but `IH^1(S,Q) = Q^2`. What survives is the
weaker statement, proved here: a common-factor surface that is smooth, or
normal with **rational** singularities, cannot leak. New Klein-specific fact
from the same work: the Klein cubic has **no Eckardt points** (exact M2, the
Eckardt ideal is the unit ideal), so no hyperplane section of it is a cone --
the `|H|` witness does not occur there and the Klein-specific case is
undecided.

**Countermodel confirmed.** The external session's Klein conic slice
`P(u,v) = (u^2-v^2, -2(u^2+v^2), (u-v)^2, -2(u^2+v^2), 0)` replays exactly:
`F(P) = 0` identically, base ideal `(u,v)^2`, exceptional `P^1` mapping
isomorphically to a **smooth conic** (`x0^2+x1x2+x2^2`, rank 3) rather than a
line, and the `v=0` slice `u^2*(1,-2,1,-2,0)` with its primitive value on `X`.
The five claims withdrawn in the source's own third report stay withdrawn.

**Boxed remainder.** The landing-identity system for `A = HB + FC`,

```
F(B + tC) = (F - Ht)(R_0 + R_1 t - R_3 t^2),
```

is verified exactly and shown equivalent to `F(HB+FC) = 0` given
`gcd(H,F) = 1`; it specializes at `B = x`, `R_0 = 1` to the sealed retraction
identity `F(x+tQ) = (Ht-F)(St^2-Rt-1)`, signs included. The remaining theorem
is the global-covariant pointed-rational-curve classification -- a statement
about the single global homogeneous covariant tuple, which by the above cannot
be replaced by a conductor theorem, a target fixed-locus theorem, a line normal
form, or a receiver-existence theorem
(`GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED`).

**Structural rhyme.** Same shape as the `O4` witness
(`O4-EIGENPLANE-CURVES-OPEN-WITH-WITNESS`, `FRONTIER-1` NONEMPTY): an
exclusion proposed in the abstract, defeated because the object is realised.
`FRONTIER-2` (`s = 2`: a `G`-orbit of surfaces in `Bs(phi)` with `E_{-11}` in
the Albanese, status unknown) is, up to notation, this packet's surface
receiver.

### Exits

```text
ACTUAL-V-TOTAL-TRANSFER-PROVED
RT-DX0-PROVED
RETRACTION-IMPLIES-NONZERO-DX-PROVED
LEAKAGE-SUPPORT-CLASSIFICATION-PROVED
CONSTANT-QUOTIENT-COLLAPSE-PROVED
CLEAN-IMPLIES-NON-RATIONAL-SINGULAR-RECEIVER-PROVED
CLEAN-COMPONENTS-G-STABLE-FOR-k-AT-MOST-10-PROVED
KLEIN-CUBIC-NO-ECKARDT-POINTS

CONDUCTOR-GYSIN-EXCLUSION-REFUTED-RATIONALLY
GENERIC-COMMON-FACTOR-LINE-NORMAL-FORM-REFUTED
NORMAL-SURFACE-IH1-VANISHING-REFUTED

LINE-INCIDENCE-FACTOR-TWO-CONDITIONAL
GLOBAL-COVARIANT-POINTED-RATIONAL-CURVE-EXCLUSION-UNDECIDED
RESTRICTED-TRANSFER-IN-THE-COMMON-FACTOR-BRANCH-UNDECIDED
PROBLEM-E-HEADLINE-OPEN
```

Verifiers: `verify_conic_slice.py`, `verify_landing_identity.py`,
`verify_normal_surface_countermodel.py` (each `RESULT: PASS`),
`eckardt_klein.m2` and `cone_surface_countermodel.m2` (Macaulay2). Replay in
`REPLAY.md`.

**Scope, stated where this summarises:** this packet proves no contradiction,
excludes no equivariant map, and makes no rationality claim. `D_X = 0` forces
CARRIER; the CARRIER branch is not excluded by the target-side receiver ledger,
whose own scope disclaimer says it proves nothing about the existence of
equivariant maps into `X`; and the CLEAN branch survives through the classified
surface channel.
