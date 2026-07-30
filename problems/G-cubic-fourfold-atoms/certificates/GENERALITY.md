# Theorem 6.8 — generality, an explicit cubic, and the Lean target

**Date:** 2026-07-29
**Work order:** WP-4
**Outcome:** Part 1 is **YES**. Addington--Auel give a named smooth cubic
fourfold over \(\mathbf Q\) with \(A(X)=\mathbf Zh^2\), and their ancillary
certificate replays. Their certificate discharges the pointwise `NLGeneral`
premise: the explicit non-rationality theorem is relative to the remaining
five opaque packages, while the very-general theorem uses all six.
**Status:** worker deliverable; **STOP at director review before WP-5**.

## 1. Binary verdict and proof boundary

The expected negative answer to the effectivity question is false. In
Addington--Auel, [*Some non-special cubic
fourfolds*](https://ems.press/journals/dm/articles/8965559), Theorem 3, the
authors give
an explicit cubic \(X_{\mathrm{AA}}\subset\mathbf P^5_{\mathbf Q}\) and prove

\[
H^{2,2}_{\mathrm{prim}}(X_{\mathrm{AA}},\mathbf Z)=0.
\]

Thus \(A(X_{\mathrm{AA}})=\mathbf Zh^2\), exactly the pointwise
`NLGeneral` hypothesis consumed by the atom obstruction. This turns the
explicit-instance declaration from a speculative stretch target into a
supported Lean target.

This does **not** by itself constitute an unconditional proof that
\(X_{\mathrm{AA}}\) is non-rational. Addington--Auel certify the Hodge input,
not the quantum/atomic obstruction. The explicit non-rationality theorem is
conditional on the other five interfaces in Section 5 until those interfaces
are independently formalized. The countable-union theorem still needs the
sixth, `NL-CUBIC`, to produce its exceptional family.

## 2. The explicit Addington--Auel certificate

### 2.1 Equation

In homogeneous coordinates \(y_0,\ldots,y_5\), take

\[
\begin{aligned}
f={}&y_0^2y_1+y_0^2y_2+y_0y_1y_2+y_1y_2^2+y_2^3+y_1^2y_3
 +y_0y_2y_3+y_0y_3^2+y_1y_3^2\\
&+y_0y_1y_4+y_0y_2y_4+y_1y_2y_4+y_2^2y_4+y_0y_3y_4+y_1y_3y_4
 +y_2y_3y_4\\
&+y_0y_4^2+y_1y_4^2+y_4^3+y_3^2y_5+y_3y_4y_5+y_4^2y_5
 +y_4y_5^2+y_5^3.
\end{aligned}
\]

The local PDF is
[`addington-auel-nonspecial-cubics.pdf`](../tmp/pdfs/addington-auel-nonspecial-cubics.pdf),
SHA-256
`553229d1cd6f1eb318608ab56bb13ee013f9d8d24a218c93e2cd6ede05bc1f7a`.
The exact arXiv source/ancillary archive is
[`addington-auel-nonspecial-cubics-source.tar`](../tmp/pdfs/addington-auel-nonspecial-cubics-source.tar),
SHA-256
`0f89f0177957f189e6a7c3f4d90735298021f2d920bd358634af6ec38bfe2b09`.

### 2.2 Referee-checkable implication

The proof chain is finite and explicit.

1. `anc/thm3.m2` verifies that the reduction modulo \(2\) is smooth: the
   saturated Jacobian ideal is the unit ideal. Smoothness of the special
   fiber gives good reduction and smoothness over \(\mathbf Q\).
2. The official point counter computes, for \(1\le m\le11\),

   \[
   \begin{gathered}
   33, 297, 4641, 70945, 1084033, 17057409,\\
   270525953, 4311720449, 68853843969,
   1100585936897, 17600759586817.
   \end{gathered}
   \]

3. Newton identities and the functional equation reconstruct the normalized
   primitive Frobenius polynomial

   \[
   \begin{aligned}
   \chi(t)={}&t^{22}-\tfrac12t^{21}+\tfrac32t^{20}-\tfrac12t^{19}
   -\tfrac32t^{16}+\tfrac12t^{15}-t^{14}\\
   &+\tfrac12t^{13}+\tfrac12t^{12}+\tfrac12t^{11}
   +\tfrac12t^{10}+\tfrac12t^9-t^8+\tfrac12t^7\\
   &-\tfrac32t^6-\tfrac12t^3+\tfrac32t^2-\tfrac12t+1.
   \end{aligned}
   \]

   It is irreducible over \(\mathbf Q\) and has nonintegral coefficients.
   Hence it cannot be cyclotomic and has no root-of-unity eigenvalue.
4. Addington--Auel Proposition 2.1 specializes codimension-two cycle classes
   into root-of-unity Frobenius eigenspaces. The Hodge conjecture is known for
   codimension-two classes on cubic fourfolds, so the root-of-unity
   multiplicity bounds the rank of integral \((2,2)\)-classes. The primitive
   multiplicity is zero, proving
   \(H^{2,2}_{\mathrm{prim}}(X_{\mathrm{AA}},\mathbf Z)=0\).

No finite-field Tate conjecture is used: specialization supplies an upper
bound, and the known complex Hodge conjecture identifies the classes to which
that bound applies. Unlike the usual two-prime van Luijk strategy for K3
surfaces, one good prime already gives the required zero primitive bound.

### 2.3 Replayed artifacts

The ancillary members used above have hashes

```text
ccba5c4d814851fd2354f16f52d78e95d3d213d27edb98d302c1812958be916f  anc/thm3.m2
b84e045e89772f48ebdeafd7f93c801a38f9230f6db7330b94cc06f278a6cd26  anc/count.cpp
59a8f023335285171758f2317fc00fcb0df53c0c44611d5147e3112d653c2616  anc/coeffs_thm3.h
c5969a9c95c8b170dd0d1d9b4a2bc4fe16ee582f908cc0945d660bcbdb062679  anc/char_poly.m2
```

Fresh replay on 2026-07-29 used Macaulay2 1.26.06, Apple Clang, and SymPy.
The smoothness test returned `true`; the official counter returned the eleven
numbers above; SymPy reconstructed the displayed polynomial and returned
`irreducible=True`, `integral_coefficients=False`, and
`scaled_integral=True` for \(2^{22}\chi(t/2)\).

Minimal replay:

```sh
cd tmp/pdfs/addington-auel-source/anc
M2 -q --stop -e 'load "thm3.m2"; print(saturate ideal jacobian ideal f == ideal(1_T)); exit 0'

AA_REPLAY_DIR="$(mktemp -d)"
ln -s "$PWD/count.cpp" "$AA_REPLAY_DIR/count.cpp"
ln -s "$PWD/coeffs_thm3.h" "$AA_REPLAY_DIR/coeffs.h"
ln -s "$PWD/char_poly.m2" "$AA_REPLAY_DIR/char_poly.m2"
c++ -O3 "$AA_REPLAY_DIR/count.cpp" -o "$AA_REPLAY_DIR/count"
for m in 1 2 3 4 5 6 7 8 9 10 11; do "$AA_REPLAY_DIR/count" "$m"; done

(cd "$AA_REPLAY_DIR" && M2 -q --stop -e \
  'load "char_poly.m2"; print h; print(toList factor h); print(2^22*sub(h,t=>t/2)); exit 0')

/opt/homebrew/bin/python3 -c 'import sympy as s; N=[33,297,4641,70945,1084033,17057409,270525953,4311720449,68853843969,1100585936897,17600759586817]; tr=[None]+[s.Rational(N[m-1]-1-2**m-4**m-8**m-16**m,4**m) for m in range(1,12)]; c=[s.Integer(1)]; [c.append(-s.Rational(tr[k]+sum(c[i]*tr[k-i] for i in range(1,k)),k)) for k in range(1,12)]; t=s.symbols("t"); f=sum(c[i]*t**(22-i) for i in range(12)); h=s.Poly(s.expand(f+sum(c[i]*t**i for i in range(11))),t,domain=s.QQ); print(h.as_expr()); print("irreducible=",h.is_irreducible); print("integral_coefficients=",all(x.q==1 for x in h.all_coeffs())); print("scaled_integral=",all(x.q==1 for x in s.Poly(s.expand(2**22*h.as_expr().subs(t,t/2)),t).all_coeffs()))'
```

The Macaulay2 command runs the archived `char_poly.m2` reconstruction and
factorization; the final command independently prints the polynomial and the
three explicit SymPy booleans reported above. The archived source is retained
unchanged; the temporary symlinks make `count.cpp` consume the theorem-3
coefficient header without overwriting `anc/coeffs.h`.

## 3. Assessment of the three proposed routes

| Route | Verdict | Referee-standard reason |
|---|---|---|
| Terasoma / big monodromy / Hilbert irreducibility | Existence only | [Terasoma](https://doi.org/10.1007/BF01175050) proves that complete intersections of middle Picard number one exist over \(\mathbf Q\). This supplies arithmetic existence but not a finite certificate for a named coefficient vector; generic monodromy excludes a countable collection of loci without deciding membership for a given polynomial. |
| Characteristic-\(p\) specialization | **Effective YES** | Addington--Auel adapt the van Luijk/[Elsenhans--Jahnel](https://arxiv.org/abs/1106.3953) strategy to primitive middle \(H^4\): smooth reduction, eleven exact point counts, Frobenius reconstruction, and a no-root-of-unity certificate. [Costa--Harvey--Kedlaya](https://arxiv.org/abs/1806.00368) later give another explicit non-special cubic using controlled \(p\)-adic cohomology. |
| Complex periods / transcendence | No effective route | Numerical periods to finite precision cannot exclude an integral relation of unbounded height. Generic period/monodromy arguments prove avoidance of countably many rational hyperplanes but do not certify that a named period point avoids every one. No usable transcendence lower bound is known here. |

Thus the explicit endgame should use Frobenius, not periods. The Terasoma
route remains useful for existence and the controlled-reduction route offers
additional examples, but Addington--Auel already supplies the smallest pinned
certificate needed for this project.

## 4. Use-site minimization of the Hodge rows

### 4.1 `NL-CUBIC`

| Clause | Decision | Actual use |
|---|---|---|
| Outside a countable union of proper closed parameter-space subsets, \(H^{2,2}(X)\cap H^4(X,\mathbf Q)=\mathbf Qh^2\) | Keep | R1 identifies the degree-four fixed subspace; R4 supplies the very-general quantifier. |
| Countable exceptional family | Keep | Needed only to package `HoldsForVeryGeneralSmoothCubic`. |
| Proper algebraic closedness after pullback to the smooth cubic-form locus, followed by closure in \(\mathbf P^{55}\) | Keep | Needed by the literal parameter-space conclusion; the closure meets the smooth locus in the original Hodge locus. |
| Irreducibility or divisor structure of each Hassett locus | Delete | No proof step uses it. `ProperClosedSubset`, not `ProperClosedDivisor`, is the target type. |
| Full Hodge diamond, odd vanishing, total rank \(27\), \(h^{3,1}=1\) | Delete from this package | The coefficient \([t^2]\operatorname{HP}_{\rm fold}=1\) and elementary ambient dimensions are universal cubic calculations in internal `cubicBasicHodge`. |
| Discriminant irreducibility, nonemptiness classification, Torelli, transcendental irreducibility | Delete | No target use-site. |

The minimized row is exactly the first row of this table. Hassett Definition
3.1.1 and Theorem 3.1.2, pp. 7--8, are sufficient.

### 4.2 `HATOM-RAW`

| Clause | Decision | Actual use |
|---|---|---|
| Rational proreductive Hodge action and full \(p-q\) grading | Keep for all target varieties | Lemma 3.1, the definition of \(\rho\), and folded-Hodge weight bookkeeping. |
| Connected smooth/reduced fixed base; dense spectral locus; finite étale reduced cover | Keep | HP spreading, component surjectivity, and cover-native localization in Proposition 3.3. |
| Fixed vectors equal rational Hodge classes | Keep only for cubic \(H^4\) | R1 needs precisely the middle fixed-space identification. |
| Algebraic cycle classes \(1,c_1(L),[\mathrm{pt}]\) are fixed | Keep in this general elementary form | R5's surface lower bound. |
| Fiberwise primary decomposition | Internal | Henselian characteristic-polynomial factorization and cover CRT construct it. |
| Component surjectivity, exact invariants, invariant/weight rank constancy, \(\rho/P\) descent, additivity | Internal | These follow in Lemma 3.1, Proposition 3.3, and Corollary 3.4. |

Splitting this minimized content into more top-level records would increase
the package count without reducing trusted mathematical content, so one
`HATOM-RAW` record remains preferable.

## 5. Corrected trusted base

The top theorem has exactly six opaque packages:

\[
\{\mathrm{GW\!-\!1},\mathrm{GW\!-\!3},\mathrm{WF\!-\!4},
  \mathrm{HATOM\!-\!RAW},\mathrm{NL\!-\!CUBIC},
  \mathrm{SURF\!-\!MIN}\}.
\]

`GW-2` (`beauvilleCubicLineCorrections`) and every finite/projector/cover
deduction are internal. `SEP-CONV` is retired: all load-bearing consumers use
only the analytic restriction at \(u=0\), whose local ring is Henselian.

## 6. Concrete Lean parameter space

### 6.1 Coordinates and the smooth locus

Use fixed coordinates on \(\mathbf P^5\):

```lean
def CubicMonomial :=
  {m : Fin 6 →₀ ℕ // m.sum (fun _ e => e) = 3}

abbrev CubicCoefficients := CubicMonomial → ℂ

/-- P(H⁰(P⁵,O(3))) = P⁵⁵; there is no PGL₆ quotient. -/
abbrev CubicParameter := Projectivization ℂ CubicCoefficients
```

The new map `coefficientsToCubic` sums the 56 indexed monomials and proves
homogeneity of degree three. A projective parameter has no canonical
coefficient vector. Therefore `CubicFourfold` must be defined by
`Projectivization.lift` (or an equivalent quotient descent), using a new
lemma that multiplication of the equation by a nonzero scalar leaves the
projective zero-locus ideal unchanged. Merely selecting a representative
without this descent proof is not acceptable.

```lean
def CubicFourfold (x : CubicParameter) : Scheme :=
  Projectivization.lift
    (fun c => ProjectiveSpace.projectiveZeroLocus 5 ℂ
      (coefficientsToCubic c))
    projectiveZeroLocus_smul_eq x

def CubicFourfold.toSpec (x : CubicParameter) :
    CubicFourfold x ⟶ Spec (.of ℂ) := ...

def SmoothCubicLocus : Set CubicParameter :=
  {x | Smooth (CubicFourfold.toSpec x)}

abbrev SmoothCubicParameter := ↥SmoothCubicLocus
```

This is the parameter space requested by the work order, not a coarse moduli
space, stack, or GIT quotient.

### 6.2 Proper closed subsets

Exceptional loci are common zero sets of homogeneous equations in the 56
coefficient variables. Reuse `projectiveHypersurfacePoints` for descent:

```lean
structure ParameterEquation where
  polynomial : MvPolynomial CubicMonomial ℂ
  degree : ℕ
  homogeneous : polynomial.IsHomogeneous degree

def IsProjectiveZariskiClosed (Z : Set CubicParameter) : Prop :=
  ∃ E : Set ParameterEquation,
    Z = ⋂ e ∈ E, projectiveHypersurfacePoints e.homogeneous

structure ProperClosedSubset where
  carrier : Set CubicParameter
  isClosed : IsProjectiveZariskiClosed carrier
  isProper : carrier ≠ Set.univ
```

Use \(\mathbf N\) as the exceptional-family index and allow the empty closed
subset, so finite or arbitrary countable families can be padded to a
sequence.

### 6.3 Intrinsic Hodge generality and rationality

The rational Hodge-class carrier must be a definition, not an unnamed
proposition. The Lean phase should first construct the canonical rational
degree-four cohomology and its \((2,2)\)-submodule. One implementable interface
for that definitional work is:

```lean
structure CubicHodge22Fiber (X : SmoothCubicParameter) where
  H4Q : Type
  [addCommGroupH4Q : AddCommGroup H4Q]
  [moduleH4Q : Module ℚ H4Q]
  [finiteDimensionalH4Q : FiniteDimensional ℚ H4Q]
  classes22 : Submodule ℚ H4Q
  hyperplaneSq : H4Q
  hyperplaneSq_mem : hyperplaneSq ∈ classes22
  hyperplaneSq_ne_zero : hyperplaneSq ≠ 0

/-- Constructed from rational singular cohomology, complexification, and the
    intersection of the Hodge filtration pieces defining type (2,2). -/
noncomputable def cubicHodge22Fiber
    (X : SmoothCubicParameter) : CubicHodge22Fiber X := ...

abbrev RationalHodgeClasses22 (X : SmoothCubicParameter) :
    Submodule ℚ (cubicHodge22Fiber X).H4Q :=
  (cubicHodge22Fiber X).classes22

def NLGeneral (X : SmoothCubicParameter) : Prop :=
  Module.finrank ℚ (RationalHodgeClasses22 X) = 1

structure NLCubicFamily where
  exceptional : ℕ → ProperClosedSubset
  avoidance_nlGeneral : ∀ X : SmoothCubicParameter,
    X.1 ∉ ⋃ n, (exceptional n).carrier → NLGeneral X

def IsRational (X : SmoothCubicParameter) : Prop :=
  Scheme.BirationalOver
    (CubicFourfold.toSpec X.1)
    (ProjectiveSpace.toSpec 4 ℂ)
```

`cubicHodge22Fiber` is foundational Hodge/cohomology infrastructure, not a
seventh theorem package: the displayed structure pins the carrier and
submodule that its construction must return. `HATOM-RAW` identifies its
degree-four fixed vectors with this canonical `classes22` submodule.
`NLGeneral` is therefore intrinsic; it does not mean merely that the parameter
avoids a chosen sequence. `NLCubicFamily` is now a concrete package containing
exactly such a sequence and the one implication consumed by the proof. The
nonzero `hyperplaneSq` fields identify rank one with \(\mathbf Qh^2\).

`IsRational` is actual birationality to \(\mathbf P^4\). Problem B's
`HasUnirationalParametrization` and `IsUnirationalOver` are dominance notions
and are too weak for `WF-4`; they are not substitutes.

## 7. Final declaration ladder

Separate the five-package pointwise obstruction from the global
Noether--Lefschetz packaging. The headline countable-union theorem has exactly
the six packages in Section 5; the pointwise helper does not retain an unused
`NL-CUBIC` argument.

```lean
theorem nlGeneral_not_isRational
    (gw1 : GW1Family) (gw3 : GW3) (wf4 : WF4)
    (hatom : HAtomRawFamily) (surf : SurfaceMinimalPackage)
    (X : SmoothCubicParameter) (hX : NLGeneral X) :
    ¬ IsRational X

theorem theorem_6_8_countable_union
    (gw1 : GW1Family) (gw3 : GW3) (wf4 : WF4)
    (hatom : HAtomRawFamily) (nl : NLCubicFamily)
    (surf : SurfaceMinimalPackage) :
    ∃ D : ℕ → ProperClosedSubset,
      ∀ X : SmoothCubicParameter,
        X.1 ∉ ⋃ n, (D n).carrier → ¬ IsRational X

def HoldsForVeryGeneralSmoothCubic
    (P : SmoothCubicParameter → Prop) : Prop :=
  ∃ D : ℕ → ProperClosedSubset,
    ∀ X, X.1 ∉ ⋃ n, (D n).carrier → P X

theorem veryGeneral_smoothCubic_not_isRational
    (gw1 : GW1Family) (gw3 : GW3) (wf4 : WF4)
    (hatom : HAtomRawFamily) (nl : NLCubicFamily)
    (surf : SurfaceMinimalPackage) :
    HoldsForVeryGeneralSmoothCubic (fun X => ¬ IsRational X)
```

The explicit supported instance is:

```lean
def addingtonAuelParameter : SmoothCubicParameter := ...

theorem addingtonAuel_NLGeneral :
    NLGeneral addingtonAuelParameter := ...

theorem addingtonAuel_not_isRational
    (gw1 : GW1Family) (gw3 : GW3) (wf4 : WF4)
    (hatom : HAtomRawFamily) (surf : SurfaceMinimalPackage) :
    ¬ IsRational addingtonAuelParameter :=
  nlGeneral_not_isRational gw1 gw3 wf4 hatom surf _
    addingtonAuel_NLGeneral
```

The explicit theorem has five opaque package arguments. Its sixth input,
`NL-CUBIC`, has been replaced by the independently replayable theorem
`addingtonAuel_NLGeneral`; retaining `nl` here would hide the genuine
dependency boundary.

## 8. Reuse and exact new Lean work

Reusable declarations include Mathlib's `Projectivization`,
`ProjectiveSpace`, `ProjectiveSpace.toSpec`, `Scheme.PartialIso`, and
`Scheme.BirationalOver`; Problem B supplies `projectiveZeroLocus`,
`projectiveHypersurfacePoints`, homogeneous evaluation under scalar change,
and a useful orientation/base-compatibility model in `Unirationality.lean`.

New work is required for:

1. finiteness and cardinality 56 of `CubicMonomial`;
2. `coefficientsToCubic` and its homogeneous/nonzero lemmas;
3. scalar descent of the projective zero locus and smoothness;
4. the parameter-space closed-locus API and empty `ProperClosedSubset`;
5. the canonical rational degree-four cohomology carrier, its \((2,2)\)-class
   submodule, and `NLGeneral`;
6. the six package structures and internal atom spine;
7. the Addington--Auel smoothness/Frobenius certificate interface;
8. `HoldsForVeryGeneralSmoothCubic` and exact statement guards.

The countable-union theorem does not assert that the complement is nonempty;
that would require a separate uncountability theorem. The explicit
Addington--Auel parameter independently supplies a named point with
`NLGeneral`.

## 9. Gate

Director review should decide:

1. whether the Addington--Auel replay is an adequate explicit `NLGeneral`
   certificate;
2. whether `NL-CUBIC` and `HATOM-RAW` have been minimized without deleting a
   live use-site; and
3. whether the projectivization descent and birational `IsRational` target
   are concrete enough for WP-5 assembly and the subsequent Lean phase.

**STOP.** WP-5 has not begun.
