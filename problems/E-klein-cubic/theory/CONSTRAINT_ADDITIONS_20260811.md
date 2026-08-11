# Constraint additions, 2026-08-11

New constraints on landing tuples `T ∈ M_d = (Sym^d W* ⊗ W)^G` with
`F(T) ≡ 0`, folded in from the adjudicated external audit
`external_docs/chatgpt_20260811_T_constraint_audit.md` (section numbers `§`
refer to that document). Nothing here contradicts the sealed state; each item
is tagged:

- **FORMAL** — an immediate consequence of the existence of a dominant `T`;
  no new theorem needed, ready to impose in computations.
- **NEW-LANE** — a mechanism absent from our program; needs a worked
  computation or a new theorem before it bites.
- **CAVEAT** — a structural rule about how results must be stated.

Throughout: `Z → P⁴` resolves `T`, `q: Z → X` the induced map,
`H = p*O(1)`, `q*H_X = dH − Σ m_E E`, `K_Z = −5H + Σ a_E E`, `C` the generic
fiber curve (the map has one-dimensional generic fibers), `ν = H·C`,
`e_E = E·C`, `φ: X ⇢ X` the restricted self-map, `δ` its degree.

---

## C1. The genus identity package (§33–34) — FORMAL

```
K_{Z/X} = (2d−5)H + Σ_E (a_E − 2m_E) E
2g(C) − 2 = (2d−5)ν + Σ_E (a_E − 2m_E) e_E
d·ν = Σ_E m_E e_E          (from q*H_X · C = 0)
```

At `d = 35`: `2g − 2 = 65ν + Σ(a_E − 2m_E)e_E`. The forced base orbits (55
plus-planes, the V4-line profile, the C5- and C11-point vanishing, minus-line
orders) feed the `m_E` directly, so profile choices become genus equations.
A general hyperplane gives a generically finite surface map `S ⇢ X` of degree
`ν` with `K_S = f*K_X + R`, `R ≥ 0` (§34) — inequalities with no equivariance
needed. The source calls this the strongest unused numerical constraint;
adopted as such.

## C2. Multidegrees and log-concavity (§45–46) — FORMAL

Projective degrees `g_i = ∫ h₁^{4−i} h₂^i` of the graph satisfy

```
g₀ = 1,  g₁ = d,  g₃ = 3ν,  g₄ = 0   (fiber dimension one)
g₁² ≥ g₀g₂,  g₂² ≥ g₁g₃  ⇒  g₂² ≥ 3dν
```

`g₂, g₃` are computable from the Segre class of the actual base ideal,
orbit by orbit (§46). One inequality linking `d`, the fiber degree `ν`, and
the base scheme.

## C3. Dominance as commutative algebra (§28–29) — FORMAL

`T` dominant ⟺ the special-fiber algebra of `I_T = (T₀,…,T₄)` is
`C[y₀,…,y₄]/(F)`: analytic spread exactly 4, Cohen–Macaulay, Gorenstein,
Hilbert series `(1−z³)/(1−z)⁵`. Rees-ideal form:
`J_T ∩ C[y] = (F)`. The minimal free resolution of `I_T` is `G`-equivariant,
so every syzygy module must decompose into allowable `G`-representations.
Machine-testable at good primes; replaces the informal "image could be
smaller" concern with named invariants.

## C4. Polar/Hessian identity tower (§26) — FORMAL, fold into the jet compiler

Differentiating `F(T) ≡ 0`:

```
∇F(T) · J_T ≡ 0
H_F(T)(dT(u), dT(v)) + ∇F(T) · d²T(u,v) ≡ 0
```

`F` cubic ⇒ the tower is finite and explicit. These are LINEAR conditions on
jets and belong inside the `d = 35` joint evaluation map from the start, not
after algebraization.

## C5. Jacobian rank and the kernel foliation (§31–32) — NEW-LANE

Dominance forces `rank d[T] = 3` generically (determinantal saturation test:
the rank-3 minors cannot all vanish outside the base locus). The kernel of
`d[T]` is a rank-one algebraic foliation whose leaves are the fibers; it must
be `G`-invariant, integrable, singular along a `G`-stable determinantal
scheme, and compatible with every fixed stratum and normal character. Its
saturated line bundle and singular-scheme classes are computable from
`0 → T_{Z/X} → T_Z → q*T_X` (Baum–Bott, Thom–Porteous). This differential
package is entirely absent from the orbit-complex program — the biggest
genuinely new lane.

## C6. Landing-scheme tangent/obstruction spaces (§25) — FORMAL

At a candidate `T`, first-order deformations satisfy
`Σ_i (∂F/∂y_i)(T) S_i = 0`, with the explicit second-order condition on
`(S, R)`. Use on any surviving `d = 35` component to separate reduced
solutions from nonreduced phantom components and invariant-multiple loci.

## C7. Fixed-fiber realizability: Riemann–Hurwitz + Burnside marks (§35, §51) — NEW-LANE

For `x ∈ X^H`, the normalized fiber `C_x` is an `H`-curve:
`2g(C_x) − 2 = |H|(2g(C_x/H) − 2) + Σ_P (|H_P| − 1)` per component, AND the
Euler-characteristic vector `(χ(q⁻¹(x)^K))_{K ≤ H}` must be the mark vector
of an actual `H`-variety (Burnside/Dress congruences). The orbit complex
records which fixed pieces may occur; it never checks the pieces assemble
into a realizable `H`-fiber. Combine with C1 for numerical contradictions.

## C8. Lefschetz trace coupling (§53) — NEW-LANE

For each `g` of order 2, 3, 5, 6, 11, the Lefschetz number of `g∘φ` has its
`H³`-contribution determined by the element of `Z[(1+√−11)/2]` that `φ`
induces on `V = H³(X,Q)(1)`, while the graph-side intersection with fixed
loci is controlled by the orbit-complex profile. Couples the CM norm `δ` to
actual fixed-point/fixed-curve multiplicities — the two ledgers must agree.

## C9. Integral polarized lattice (§63) — NEW-LANE, strengthens CLEAN

The CLEAN branch currently uses only `End_{G-HS}(V) = Q(√−11)`, giving
`δ = x² + xy + 3y²`. The actual constraint is integral: the `O_{−11}`-lattice
with its Rosati involution, polarization type, discriminant, and `G`-action
must be carried by the correspondence. Can exclude carriers that have the
right rational Hodge structure with the wrong integral polarization.

## C10. Orbit-summed Abel–Jacobi (§50, §60) — NEW-LANE

The corrected global form of the refuted componentwise pointed-curve
exclusion: exceptional rational-curve families and special-fiber components
give cycles whose ORBIT-SUMMED Abel–Jacobi correspondence into
`J(X) ~ E_{−11}⁵` must realize the same `G`-equivariant endomorphism of `V`
as the restricted graph, with the polarization computed. Componentwise
vanishing proves nothing (sealed); the orbit sum is the object. The type-II
`αβγ = 0` condition extends to higher jets and enters here.

## C11. Spin Brauer residues and index reduction (§55, §67–68) — NEW-LANE

`T` induces `K_X ↪ K_P` on generic quotient-torsor fields, so every
cohomological invariant in `H^r(G, μ_n^{⊗s})` — above all the spin
Schur–Brauer class `β_X ∈ Br(K_X)[2]` — must pull back compatibly, with
matching residues at every divisorial valuation the normalized Rees graph
selects. Separately: the extension has transcendence degree one; determine
whether the generic fiber curve reduces the index of `β_X` (stays 2 / drops
generically / drops only after a multisection of specified degree). This
measures exactly whether the stable `P(U)`-factor can be descended — the
arithmetic flank of the vice.

## C12. Postcomposition semigroup (§78) — CAVEAT

Postcomposition with dominant `G`-self-maps of `X` produces landing maps of
unbounded degree. No uniform finite list of degrees or carrier profiles can
exist without quotienting by this semigroup. All classifications (carrier
profiles, degree windows, `δ`-forks) must be stated up to postcomposition,
and candidates sorted into primitive / postcomposed / common-factor-modified.

## C13. Tropical and Newton-polytope prefilter (§74) — FORMAL, cheap

A `G`-covariant has monomial support in complete `G`-orbits of monomials;
tropicalizing `F(T) = 0` forces cancellation among the three tropical terms
at every weight vector. Mixed volumes bound `ν` and the multidegrees of C2.
Run as a prefilter before building coefficient matrices.

## C14. Generic-fiber trichotomy (§37) — NEW-LANE tie-in

Classify the generic fiber: genus 0 (a conic-bundle/Brauer class and
multisection index), genus 1 (Jacobian torsor and monodromy), genus ≥ 2
(nontrivial `R¹q_*Q`). Whatever the branch, its variation must be compatible
with the ambient Hodge-support localization of `V` (the sealed §17
constraint). Interacts with C11's index-reduction question in the genus-0
branch.

---

## Secondary items (recorded, lower priority)

- §36: critical and discriminant loci of `d[T]` are `G`-stable cycles,
  computable by Thom–Porteous; components must be unions of permissible
  orbits.
- §47: Noether–Fano / maximal-singularity inequalities against multiplicity
  profiles that are linearly realizable but birationally impossible.
- §48: equivariant relative MMP on `q: Z → X` to bound generic-fiber types.
- §71–73: the multi-prime flatness-certificate method (already our standard),
  Hensel-lifting discipline for modular solutions (the `d = 25` failure
  mode), and point counts over `F_{p^r}` as a component detector.
- §75: Gröbner-fan enumeration of initial ideals on the `d = 35` slice,
  restricted by the forced multiplicities and analytic spread 4.

## Confirmations, not additions

The source's part VI.A opening (§23–24: one joint jet-evaluation image over
ALL orbits, then the exact landing scheme `V(Φ₃₅|_{L₃₅})` with a four-outcome
certificate) is our already-queued plan (HANDOFF_2026-08-11 §4), stated
sharply — including that allowed profiles are the image of ONE map, never a
product of rowwise images. Its part VII (17 things that must not be counted
as established) matches our corrections ledger exactly; item VII.2 (the
odd-residue zero) has since been resolved as ARTIFACT by
`goal_runs_20260811/ODDZERO_AUDIT`.

## Suggested imposition order

C4 and C6 go into the `d = 35` jet compiler immediately (linear). C13 runs
as a prefilter. C3 and C2/C1 apply to any surviving component (dominance
algebra first, then multidegrees/genus). C7, C8 need the resolved model of a
survivor. C5, C9–C11, C14 are new lanes to open only if a candidate reaches
the graph stage — except C11's residue bookkeeping, which can start now on
the forced base orbits.
