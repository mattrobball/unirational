Q-UNDECIDED

# Requirement-level completion audit

Date: 2026-08-01.  Repository state audited through
`35fa8f59b6a1423cc89300aeaceefe91552be5ba`.

## Binary verdict

Neither permitted theorem has been proved:

```text
X_Schur(K_Schur) is nonempty       NOT PROVED
X_Schur(K_Schur) is empty          NOT PROVED
```

Accordingly this packet does not claim to completely resolve Goal Q and does
not contain `SEAL.json`.  The absence of a seal is intentional: a replayable
bounded exclusion or structural frontier is not one of the two binary exits.

This is also the current external theorem boundary.  Cheltsov--Tschinkel--
Zhang, *Equivariant unirationality of Fano threefolds*, dated 2026-07-18,
still list the `PSL(2,11)` action on the Klein cubic as open.

## Contract audit

| Requirement | Exact result | Completion consequence |
|---|---|---|
| Q0: rebuild the genuine twist and cycles | `K=C(P(V6))^G`, splitting field `C(P(V6))`, exact degree-55 closed point, effective degree-3 cycle, and signed degree-one cycle `Z55-18H3` | Index one is certified; effectivity in degree one is not. |
| Q0/Q3: standard obstructions | `Pic=Z[H]`, `Pic^0=Alb=0`, relative Brauer and audited higher Amitsur groups vanish | These packages cannot prove pointlessness. |
| Q1: lower the known cycle | A general cubic-surface section has a `K`-point or a full-span primitive quartic with closure `A4` or `S4`; the latter is disjoint from the Schur field | Exact reduction to the surviving Coray--Cassels--Swinnerton-Dyer quartic case. |
| Q1: resolvent secants | The quartic gives a point over its cubic resolvent algebra | This is another degree-3 cycle, not a `K`-point.  Universal collinearity of the three second residuals is false. |
| Q1: twisted-cubic linkage | The primitive quartic links to an integral quintic and the same construction returns `4 -> 5 -> 4`; the residue compositum has degree 20 | No decreasing descent and no Schur-field splitting. |
| Q1: rational-curve incidence | The degree-4 virtual point count is 192 and the degree-3 count is 8.  Exact ranks `(9,10,6)` prove general quartets have general resolvent triples, but Voisin specialization does not preserve that condition.  The generic eight-sheeted incidence cover remains integral after the marked points split | Counts alone give no fixed curve.  Cubic-closure splitting would be a new Schur-specific theorem. |
| Q1: fixed-curve bridge | Any actual `K_Schur` genus-zero stable map of odd degree, including a reducible degree-three map, has a `K_Schur`-point on its domain.  Any actual generalized-twisted-cubic Hilbert point also gives a point via `J_T(K_Schur)=0` and the theta exceptional fibre | The output implication is complete; no actual map or Hilbert point has been produced. |
| Q1/Q4: direct point construction | Exact constant-Krylov ansatzes `<1,f7>` and `<1,f7,f7^2>` are empty; selected degree-12 covariant slices are empty | Scoped coefficient exclusions only.  No tuple exists to substitute into the original cubic. |
| Q1/Q4: Gross--Popescu model | The equivariant datum is `Lambda^2(V6) ~= Sym^2(W5)`; the final Klein birationality uses a non-equivariant generic hyperplane | No equivariant map `P(V6) --> X_Klein` is obtained. |
| Q2: birational models | The original model and ten coordinate-line blowups are exact; the latter are period-index-3 genus-one fibrations | The models are not exhaustive, so failure of their sections is not pointlessness. |
| Q3: valuation obstruction | Every ramified, residue-transcendence-at-most-one, or rational-rank-at-least-four valuation is soluble.  A local nonpoint must be unramified with residue transcendence degree at least two, rational rank at most three, and decomposition group in four named classes | Exact obstruction interface, but no surviving residue cubic is proved pointless. |
| Q3: torsor obstruction | Every commutative or semiabelian torsor receiving a morphism from the full twist is trivial by the degree `3/55` restriction--corestriction identity | The suggested semiabelian route cannot supply a negative theorem. |
| Q4: headline bridge | The generic-twist/versal bridge is available | It has no binary premise to transport. |

## Smallest missing implications

A positive completion now requires at least one of:

1. an unrestricted `K_Schur` point, checked in the original five-coordinate
   cubic and transported through the versal bridge;
2. a proof that the special cubic-resolvent incidence is a finite Hilbert
   scheme of length eight and splits over the cubic closure in the `A4/C3`
   branch, followed by the now-proved fixed-curve bridge, together with a
   separate treatment of the `S4/S3` branch;
3. a new Schur-specific correspondence lowering the primitive quartic or its
   linked quintic to degree one or two;
4. a genuinely exhaustive birational model producing a section or point.

A negative completion requires an actual obstruction on the full proper
generic twist.  For the now-sharp valuation route this means constructing a
named unramified valuation in one of the surviving decomposition classes and
proving its full five-coordinate residue cubic pointless despite index one
and trivial relative Brauer group.  No such residue nonpoint is known.

## Evidence boundary

The finite computations and their independent markers are enumerated in
`REPLAY.md`.  The cited theorems of Voisin, Balestrieri, Gross--Popescu,
Graber--Harris--Starr, Harris--Roth--Starr, Bayer et al., and Zinger are
mathematical inputs, not machine-proved by those verifiers.  Every report
states this distinction and preserves the `Q-UNDECIDED` headline.
