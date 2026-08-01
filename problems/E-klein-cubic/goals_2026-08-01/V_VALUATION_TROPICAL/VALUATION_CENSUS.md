# Valuation census

## Scope labels

- **FULL** means a statement about the genuine five-coordinate generic twist
  `X_T/K`.
- **PLANE** means the `xCD` plane section.  A plane point proves a full point;
  a plane nonpoint does not prove a full nonpoint.
- **AUX** means the minimal Pfaffian characteristic cubic or another
  point-sufficient model lacking a negative bridge.

The worker started at
`2140419410cfff2f7d7dcca166acef8c16a0d41b` and the final audit consumed
`53e267a59b2d24de93c58dd9ddacc2f995fc2d68`; the goal's pinned baseline is
`715faf441289e2589b9325311b6613ea0331bf88`.  The intervening commits add
isolated goal packets from other workers.  The authoritative Goal-V source
inputs below are unchanged and are hash-pinned in `SEAL.json`.

## A. Route-wide structural census

| Candidate | Scope | Exact status | Consequence |
|---|---|---|---|
| Any valuation, any rank | FULL | local index is exactly one | rules out every index-three, degree-`3Z`, and no-prime-to-three-cycle exit |
| Rank-one discrete coefficient valuation | FULL | integral tropical value vector always exists | rules out empty value-group tropicalization; residue initial forms still matter |
| Higher-rank monomial/flag valuation | FULL | value-group tropicalization is always nonempty; closed-residue cases are locally soluble | rules out every pure value-group obstruction in arbitrary rank |
| Any ramified torsor valuation | FULL | locally soluble by the central-inertia/centralizer theorem | negative site must be unramified |
| Standard successive Parshin completion, chain length 3 or 4 | FULL | locally soluble by effective degree `55` plus Coray's complete-DVR theorem | retires the standard geometric high-rank completion family |
| Arbitrary divisor of `Y=P4/G` | FULL | infinite family, no exhaustive theorem | cannot honestly claim `V-ALL-NATURAL-VALUATIONS-SURVIVE` |

## B. Divisors with full-twist local points

Let `h_V=F(V)` for a primitive covariant `V`.  The five coordinate gcds of
each `V` are one, so the covariant is nonzero at the generic point of every
component of `h_V=0`.  The covariant-divisor theorem in `MODEL.md` gives a
residue point and then a completion point.

| Divisor upstairs | Degree | Point | Status |
|---|---:|---|---|
| `F(x)=f3=0` | 3 | `[x]` | FULL local point on every component |
| `F(C)=f12=0` | 12 | `[C]` | FULL local point on every component |
| `F(D)=0` | 15 | `[D]` | FULL local point on every component |
| `F(E)=0` | 18 | `[E]` | FULL local point on every component |
| `F(K)=0` | 21 | `[K]` | FULL local point on every component |

The exact sparse division audit also shows that no other primitive parameter
among `f5,f6,f8,f11` divides any of these five diagonal coefficients.  Thus
the preceding theorem does not accidentally retire those parameter divisors.

The installed degree-120 discriminant `D_xCD` of the `xCD` plane has a
uniform point theorem at every height-one component: after the unit gauge
`f6/f5`, each component has valuation-one nodal reduction, a residue-rational
node, a smooth residue point, and a Hensel lift.  This is a PLANE point and
therefore also a FULL local point.  The source theorem is
`tmp/xcd_discriminant_divisor/REPORT.md` and its exact line/gcd payload.

## C. Named invariant boundaries still open for the full twist

| Divisor | Installed geometry | New exact search | Full local status |
|---|---|---|---|
| `Q5: f5=0` | one geometrically integral Hessian divisor, trivial generic inertia, smooth `xCD` reduction with gauge `f7/f6` | canonical Hessian-kernel line has pure binary section and a certified noncube ratio; constant five-frame coordinates and all homogeneous five-frame landings through degree `15` are empty; degree `16` times out with 19 variables and 151 independent cubics | **OPEN** away from the excluded line; bounded exclusion is not pointlessness |
| `Q6: f6=0` | one geometrically integral divisor, trivial generic inertia, smooth `xCD` reduction with gauge `f3^2/f5` | constant five-frame coordinates empty; landings empty for degrees `1..14`; degree 15 timed out with 16 variables and 140 independent sampled cubics | **OPEN** |
| `f7,f8,f9,f10,f11,f14=0` | exact invariant forms installed | no complete full-frame residue analysis in this packet | **OPEN / uncensused** |
| frame determinant `det[x,C,D,E,K]=0` | chosen Hilbert--90 frame degenerates | no intrinsic degeneration follows | basis-change problem, not yet a valuation obstruction |

The earlier `xCD` search used only `x,C,D`.  The new bounded search uses all
five primitive columns and the complete Hironaka coefficient spaces modulo
`f5` or `f6`.  Its honest terminal boundary is still bounded.

At `f5`, the independently replayed exact identity
`det Hess(F)=32*f5` gives a canonical Hessian-kernel line.  Modulo `f5`, its
intersection equation is `s^3*f3+t^3*F(y)`, and a transverse divisor proves
`-f3/F(y)` is not a cube.  This excludes that canonical line construction
only; it does not exclude a point elsewhere on the full cubic.

## D. Branch and coefficient-map valuations

| Candidate | Scope | Exact state | Reason it is not a V headline |
|---|---|---|---|
| Every component of the `xCD` degree-120 discriminant | PLANE -> FULL positive | locally soluble | retired as an obstruction |
| Simple degree-21 target branch of the primitive sextic `K_proj/F` | PLANE / fixed-frame | residue-degree-one fold and smooth plane cubic proved; index of the target incidence remains open | a nonpoint of one plane section would still need a full-twist negative bridge |
| Squared degree-11 primitive-sextic factor | fixed-frame coefficient map | full Jacobian-rank-drop component; naive primitive-root model rejected | normalization/gauge issue, not a pointlessness theorem |
| Degree-37 upstairs critical divisor | fixed-frame coefficient map | integral/reduced; naive compactification has base-point `P2` fibres | route T normalization/class-group work, not a simpler V valuation |
| Exceptional divisors over the 60 `A3` points of `f6=0` | PLANE | every closed geometric fibre has a smooth point; doubled line has a completed class defect `Z -> Z^3` with cokernel `Z^2` | completed classes may not algebraize; no full nonpoint |

## E. All-rank inertia and tropical classification

For every Krull valuation trivial on `C`, let `D` and `I` be the decomposition
and inertia groups of a prolongation to the generic splitting field.

| Local type | Exact result | Consequence |
|---|---|---|
| `I != 1` | tame inertia is central in `D`; exact element centralizers force `D` into a group preserving a point or a contained `P1` on `X` | the full local twist has a point |
| `I = 1` | value groups agree and the torsor extends etale | local point iff the residue `D`-twist has a point |
| residue field `C` | an unramified residue torsor is trivial | every such valuation is locally soluble |
| arbitrary rank tropicalization | ramified case has a local point; unramified case inherits a split-point valuation vector in the base group | empty value-group tropicalization is impossible |

Thus weighted full-rank monomial valuations and toroidal flag valuations with
closed residue are retired.  Higher rank can still refine an unramified
positive-dimensional residue twist, but the remaining issue is residue
pointlessness, not a gap in the base value group.

The separately replayed complete-DVR certificate also retires every standard
successive completion of a saturated geometric Parshin chain of length three
or four.  It uses the effective degree-55 cycle and Coray's theorem, and is
strictly scoped to those iterated completions.  Rank-one divisors and
rank-two chains remain outside that theorem.

## F. Subgroup-adapted and toroidal centres

The nonfree ambient strata and their stabilizers are exactly enumerated in
`certificates/STRATA_EXACT.md`.  They have projective dimension at most two,
so they do not create codimension-one inertia on `P4/G`; they can create
exceptional valuations after blowups.

| Centre type | Stabilizer data | Status |
|---|---|---|
| involution plus-plane/minus-line | setwise stabilizer `D12`; fixed cubic/line geometry exact | every valuation with nontrivial inertia here is locally soluble via the descended minus-line |
| `V4`, `C3`, `C5`, `C6`, `C11` strata on `X` | exact fixed points or fixed curves on `X` | centres lying on `X` carry tautological fixed points; no obstruction obtained |
| off-`X` `D10`, `D12`, `A4` points | exact stabilizers and orbit sizes | ramified cases are retired; a genuinely unramified residue subgroup twist is a route-H problem |
| maximal `A5` (two classes) and `11:5` quotients | subgroup classes exact | their generic subgroup twists are separate open route-H problems; no V certificate imports an unproved subgroup result |

## G. Auxiliary local calculations excluded from the headline ledger

The minimal Pfaffian ternary cubic is locally soluble at both named divisors:

- `D3=(f3=0)` has an exact Hensel point in the projector open;
- `D5=(f5=0)` has an exact constant residual point and Hensel lift.

These are useful consistency checks, but they concern an auxiliary
characteristic cubic.  They neither give nor obstruct a point of the genuine
Klein twist without the missing common-isotropic-line bridge.  They are not
counted as FULL valuations above.

## Ranking after the census

1. `Q5` and `Q6` remain the simplest honest smooth-reduction divisors of the
   actual twist, but the open object is the full five-coordinate residue
   cubic with index one.
2. A higher-rank value-group refinement cannot evade the inertia theorem.
   Only a pointless unramified residue twist can remain.
3. Exceptional valuations over off-`X` stabilizer strata either ramify and
   are locally soluble, or reduce to a genuine subgroup-twist point problem.
4. The primitive-sextic target branch belongs to the more developed route T
   and is not a simpler independent V valuation.

Because rows C and F retain unramified residue problems, the exact route exit is `V-UNDECIDED`, not
`V-ALL-NATURAL-VALUATIONS-SURVIVE`.
