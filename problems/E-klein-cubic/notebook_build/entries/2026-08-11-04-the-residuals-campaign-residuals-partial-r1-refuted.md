# Notebook supplement — 2026-08-11: the residuals campaign — `RESIDUALS-PARTIAL`. `R1` refuted at its unlock, `R2` narrowed, `R3` witnessed

## What was asked

Close the three boxed residuals of `TOTAL_DEGENERATION.md` §6 — the exact
statements a stronger-than-Hodge-support method must supply — then cascade and
re-derive the route verdict. Step 0 first: the dependency map (recorded in the
previous supplement, exit `O4-BLOCKS-HEADLINE-REGARDLESS`).

Packet: `R1_TOTAL_DEGENERATION.md`, `R2_AMPLE_COVERS.md`, `R3_CM_RIGIDITY.md`,
`verify_r1_degeneration.py`, `verify_r2_covers.py`, `verify_r3_cm.py`, with
updates to `SUPPORT_CENSUS.md` §9, `ADVERSARIAL_TESTS.md` §§R0-R5, `REPLAY.md`,
`STATUS.md`.

## `R1` — the proposed unlock is FALSE

The director's key unlock was: if every fibre closure of `phi` passes through
`x`, the exceptional divisor of the blowup at `x` inherits an induced
`K`-equivariant **dominant** rational map `P(T_x) --> V14`, which one then
kills at `K`-level. The first half is false and the second half would not fire.

*First half.* What does exist, and is new, is the initial map: the degree-`m`
initial forms of the landing tuple at `x` define a `K`-equivariant rational map
`psi_x : P(T_x) --> P(M)` whose image lies in `V14` — because a homogeneous
form vanishing on `V14` has vanishing lowest-order part when composed with the
tuple (Lemma R1-1). Its image is exactly the set of limits of `phi` along
**straight lines** through `x`. It is not dominant in general:

    phi : A^2 --> P^1,   (u,v) |-> [u^2 : v],   C_2 acting by u |-> -u

is equivariant, has `Gamma_0 = P^1` (along `(t^a, c t^{2a})` the limit is
`[1:c]`, and the two unbalanced regimes give the remaining two points), and has
`m = 1`, `in_1(u^2) = 0`, so `psi_0` is **constant**. So total degeneration
holds with a constant induced map. This upgrades `TOTAL_DEGENERATION.md`
Remark W0'' from an assertion to a theorem with a witness. The example is
repaired at depth **two** (a second blowup gives `[1 : w]`, dominant), but
`[u^N : v]` needs depth `N` and nothing bounds `N`, since `d` is unbounded on
the spin lane.

*Second half.* Even granting the induced map, the only available tool is
going-down for **abelian** groups, and every abelian subgroup of every
occurring stabiliser has nonempty fixed locus on the `V14` (`C_2`: the sealed
sextic plus two points; `C_11`: five points; `C_3`, `C_5`, `C_6`: nonempty by
Lefschetz, `chi = 6, 4, 2`). The two emptiness statements — `V14^{D_10}` and
`V14^{F_55}` — are at **nonabelian** groups and are unusable. That is Cor N4
(the fixed-point exhaustion) restated one level down.

*What total degeneration does pin.* `Y_x -> Gamma_x` is finite and birational
onto a normal variety, so `Y_x` **is** the `V14` in its own anticanonical
embedding with the given `K`-action, and the fibre cone has degree-one piece
`Res_K M^*` twisted by a character and dimension 4 (analytic spread
`l(I_x) = 4`). There is nothing left to constrain — which is the precise sense
in which the package is spent. `R1` therefore asks for an upper bound on the
analytic spread of the landing ideal at a base point: a commutative-algebra
statement, not a Hodge-theoretic one.

*Unconditional by-product.* On a smooth resolution, `H^4 = 0` on the threefold
target gives `(g^*H)^4 = 0` and `(g^*H)^3 = 14 g^*[pt]`; with `L = pi^*O(1)`
and `g^*H = dL - Xi`, the vanishing `L^{5-j}Xi^j = 0` for `j + dim Bs < 5`
collapses the second identity to `14 delta_F = d^3` whenever
`dim Bs(phi) <= 1`. Since `14` is squarefree and `delta_F` is a positive
integer, `dim Bs(phi) = 1` forces `14 | d`. Hence **`dim Bs(phi) >= 2` for
every even `d < 14`** — in particular at the minimal live degree `d = 4`. This
strengthens Lemma W0' (`dim Bs >= n-5 = 1`) throughout the low-degree window.
Regressions: the same computation gives `delta_F = 1` for the projection of
`P^5` from a line and `delta_F = 8` for four general quadrics.

## `R2` — narrowed, not closed; the only genuinely undetermined residual

Cor C5 asks for `E_{-11}` in `Alb` of a finite cover `Y_x` of an ample divisor
`Z_x`. Equivalently (Prop R2-1) the cover fibres over an elliptic curve
isogenous to `E_{-11}`. Two new results:

* **Cyclic covers are dead.** For a smooth `Z` with `q(Z) = 0` and `K_Z` nef —
  both hold for every smooth `Z_x in |kH|`, since the index-one identity
  `-K = H` makes a hyperplane section a K3 and `|kH|` for `k >= 2` of general
  type — and a branch divisor in `|nL|` with `L` nef and big, the splitting of
  the pushforward into `O_Z(-iL)` plus Serre duality and Kawamata–Viehweg give
  `h^1(-iL) = h^1(K_Z + iL) = 0`, so `q = 0`. The box's own remark ("branched
  covers of regular surfaces have unbounded irregularity") is true but needs a
  branch class outside the positive cone; Theorem R2-2 locates the escape.
* **No `F_55`-stable hyperplane section.** `H^0(-K) = M^*` and
  `Res_{F_55}M^* = theta_1 + theta_2` contains no linear character, so at the
  12 mandatory `F_55`-points `Z_x` lies in `|kH|` with `k >= 2` and is of
  general type, never a K3. (`k = 2` is not excluded: the `C_11`-invariants of
  `S^2 M` are 5-dimensional and form the regular `C_5`-representation.)

Residual: a **singular** `Z_x`, a **non-cyclic** cover, or a branch class
outside the restriction of `Pic(V14)`. The natural candidate shape — a nodal
member of `|kH|` resolving to a Kummer surface of `E_{-11}` squared, covered by
the abelian surface itself — is recorded and explicitly **not** claimed; a
16-nodal member of `|H| = P^9` cannot exist on a count, and `|kH|` for `k >= 2`
is an unresolved projective-geometry question.

## `R3` — method-insufficient, with a two-line witness

The CM-rigidity lemma is proved in the generality it was wanted in: a
polarizable weight-one variation of rank `2g` with an **integral structure**
and a horizontal action of a CM field of degree `2g` has constant CM type
(finitely many types, connected base), hence flat Hodge filtration; its
monodromy lies in the norm-one subgroup intersected with the units of an
order, hence consists of roots of unity by Kronecker, hence is finite; so the
variation is isotrivial and becomes constant on a finite `K`-equivariant étale
cover. The integral-structure hypothesis is load-bearing — Hilbert 90 makes the
rational norm-one group infinite without it — and stating it is the "exact
hypotheses" the residual asked for.

It does not apply. The package puts the `E_{-11}`-isotypic structure on the
**global** intersection cohomology, never on the variation, and the implication
"`IH^1` contains a CM structure, therefore the local system has CM" is false.
Witness, entirely explicit: let `f` be the degree-two quotient of `E_{-11}` by
the inversion, branched at the four 2-torsion points, with quotient `P^1`, and
let `L` be the anti-invariant summand of the pushforward of `Q` — a
**nonconstant** rank-one local system with monodromy of order **two**. Then
`IH^1(P^1, L) = H^1(E_{-11},Q)`, checked twice (by the splitting of the
pushforward, and by the Euler characteristic `1.(2-4) = -2` with `h^0 = h^2 = 0`),
so (AHS-spin) is satisfied. Equivariantly: the four branch points can be chosen
stable under the residual `C_2` on a `C_3`- or `C_5`-eigen-line, and the
cross-ratio of `(a,-a,b,-b)` is the square of `(a-b)/(a+b)`, which sweeps the
whole `lambda`-line, so `j = -32768` is attained.

The proposed reduction therefore fails at its **last** step, not its first:
granting finite monodromy for free, "pass to the finite cover" lands on
`E_{-11}` itself, whose `H^1` is the carrier — i.e. on `FRONTIER-1` of the
dependency map, the frontier that blocks the headline anyway. What the lemma
does close is the sub-case where the CM is horizontal (kill `K-q`).

## Cascade

Exactly one census entry moves: subcell `O4g` — nonconstant local systems, the
only survivor of cells `S2`, `S3` for `V = U` — becomes **witnessed**. Two
kills are added (`K-p` cyclic covers, `K-q` horizontal CM) and neither empties
anything. The mandatory `D_12` test passes on every verdict, in each case with
the informative sign: the surviving subcell is the one the realised
`D_12`-equivariant map of Cor IX.6 is free to occupy, and Theorem R1-4 has no
`D_12` analogue at all because it rests on the perfectness of `Gtilde`.

## Exits

```text
RESIDUALS-PARTIAL                     (the campaign exit)
R1-OPEN
R1-INDUCTION-REFUTED
R1-INITIAL-MAP-LANDS-IN-TARGET
R1-TOTAL-DEGENERATION-RIGIDITY
BASE-LOCUS-DIMENSION-BOUND-2
R1-F55-FILTRATION-NARROWED
R2-NARROWED-NOT-CLOSED
R2-CYCLIC-COVERS-DEAD
R2-FIBRATION-REFORMULATION
R2-F55-NO-HYPERPLANE-SECTION
R3-METHOD-INSUFFICIENT
CM-RIGIDITY-LEMMA-PROVED
R3-HORIZONTAL-CM-SUBCASE-DEAD
O4G-WITNESSED
R1_DEGENERATION_OK
R2_COVERS_OK
R3_CM_OK
```

`SPIN-ROUTE-CLOSED-METHOD-INSUFFICIENT` stands and is **not** upgradable by
this campaign; `SPIN-CHAIN-OBSTRUCTION-UNDECIDED` is unchanged. Headline:
**OPEN**.

## Named next task left behind

One Macaulay2 run: the two `F_55`-invariant `P^4` inside `P^9 = P(M)` are the
`theta_1`- and `theta_2`-isotypic eigenspaces; exactly one contains the five
sealed `C_11`-fixed points of `V14`. Compute the intersection of `V14` with
**both** in the sealed model. If the one without the five points is empty,
Prop R1-5 pins the order filtration of the landing tuple at every `F_55`-point
of every equivariant spin map. The model and the `C_11`-eigenbasis are already
built by `verify_v14_s3_d10.py`.

## Verification

`verify_r1_degeneration.py` (`R1_DEGENERATION_OK`), 117 exact assertions;
`verify_r2_covers.py` (`R2_COVERS_OK`), 179; `verify_r3_cm.py` (`R3_CM_OK`),
90; all well under a second, Python standard library only, sharing the
self-tested cyclotomic engine and metacyclic character-table builder of
`verify_r0_dependency.py`. Between them they compute: the arc-limit set of
`[u^2:v]` over an exact rational grid; the symbolic expansion of
`(dL - Xi)^k L^{5-k}` under the vanishing table, with three regressions; the
`F_55` representation theory (`theta_1` dual to `theta_2`, from `-1` being a
non-residue mod 11; `Res_{F_55}M^* = theta_1 + theta_2`; the `C_11`-weight
multiplicities of the symmetric powers); the going-down audit; the
anticanonical Hilbert function of the `V14` with the 15 Plücker quadrics
recovered as `55 - 40`; the cyclic-cover irregularity ledger term by term;
linear characters in `Res_H M^*` for all nine pointwise kernels; the CM-type
count; an exact search for norm-one algebraic integers in `Q(sqrt(-11))`
together with Hilbert-90 witnesses showing the integral-structure hypothesis is
load-bearing; Hurwitz and the Euler characteristic of the middle extension; and
the cross-ratio identity with the degree-six equation for `j = -32768`.

All four campaign verifiers plus `scripts/check_manifest_parity.py` pass. The
packet is on `agent/residuals-campaign-20260811` (PR #36). This notebook
revision was authored against parent head
`6e7c73b7a58f158f25ecd74b379dd8ec2ea539b8`.
