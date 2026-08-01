# Goal D2 theorem and bridge audit

## 1. Required bridge

A candidate passes D2.0 only if all five statements are proved:

1. it is defined on the genuine quotient stack or generic twist;
2. it is functorial for the resolved map `Z^4 -> X^3` or for a precisely
   extracted correspondence;
3. it survives every actual equivariant blowup in the resolution;
4. its conclusion is not erased by the uncontrolled multisection degree `n`;
5. it can remain nonzero although every twist has index one and every Sylow
   action has a fixed point.

No audited candidate satisfies all five.

## 2. Additive mixed-prime stack classes

**Candidate.** Positive-degree Borel cohomology, positive-codimension
equivariant Chow classes, finite-coefficient cohomological invariants, their
stable additive operations, or abelian extension data.

**Verdict.** Fails requirement 5.  `SYLOW_DETECTION.md` proves that every
fixed-point-normalized obstruction in this Mackey-valued class vanishes.  Its
apparent integral mixed-prime target splits canonically into `2,3,5,11`
parts.  There is no abelian cross-prime gluing left to compute.

This includes no renaming of the Amitsur branch.  In the Klein action the
honestly linearized hyperplane already makes the universal-torsor obstruction
and all higher Amitsur groups zero.

## 3. Mod-`p` equivariant Chow motives

**Candidate.** A nontrivial extension or indecomposable summand of the
`F_p`-equivariant motive of `X`.

**Bridge failure.** For a relatively ample class `eta`, the only general
correspondence identity is

\[
r\,i=n\,\mathrm{id}.                             \tag{3.1}
\]

Modulo `p`, (3.1) yields a retraction only when `p` does not divide `n`.
The resolution supplies no such condition.  Tensoring the relatively ample
line bundle by `m` changes `n` to `mn`, so every prime can be introduced.
Neither the integral injection nor the rational splitting from Goal D implies
a mod-`p` motive summand.

The Sylow fixed points also give a zero-cycle of degree prime to `p` on every
twist, so the unit motive already splits mod `p`; an obstruction based only on
absence of the unit summand is unavailable.

**Verdict.** Fails requirements 2 and 4 before an extension calculation.

## 4. Quotient-stack Steenrod and power operations

**Candidate.** A primary operation on a class of `[X/G]`, corrected by
stabilizer data.

**Bridge failure.** Operations commute with pullback, but the hypothetical
pullback need not be injective after reduction modulo a prime dividing `n`.
Pushforward plus a relatively ample class again gives only (3.1).
Equivariant blowup formulas contain the centre normal bundle and exceptional
terms, so an original-source fixed-point calculation is not blowup-stable.
If the output is additive torsion and fixed-point-normalized, the Sylow theorem
kills it independently.

**Verdict.** Fails requirements 3--5.

## 5. Integral polarization plus `G` on the intermediate Jacobian

Let `L=H^3(X,Z)` with its alternating unimodular form `q_X`.  The only form
canonically produced on the pullback by a relatively ample class is

\[
q_{Z,\eta}(f^*x,f^*y)=n q_X(x,y).                \tag{5.1}
\]

Thus the pullback is a similitude with uncontrolled multiplier `n`, not a
primitive polarized embedding.  Since `rank(L)=10`, the discriminant is
scaled by `n^10`.  Every prime of `660` can enter through `n`; tensoring the
line bundle changes it arbitrarily.  Goal D's Prym centre already reproduces
the rational polarized Hodge structure.

**Verdict.** Fails requirement 4.  An integral polarized obstruction would
first need a theorem controlling the fibre-degree subgroup.

## 6. Equivariant cobordism with admissible centres

**Candidate.** The equivariant cobordism class modulo classes of centres that
actually occur in the base locus of a landing covariant.

**Bridge status.** Oriented-theory degree formulas retain the degree and
lower-dimensional correction terms.  Goal D shows arbitrary free-orbit
centres are too flexible.  No installed or audited theorem characterizes the
actual nonlinear base-locus centres in all degrees, and no theorem proves that
the resulting quotient of cobordism is stable under the required resolution.

**Verdict.** Fails requirements 2 and 3.  Computing a bounded list of centres
would not repair this all-degree theorem gap.

## 7. Canonical and essential dimension

The equality

\[
\operatorname{ed}_{\mathbf C}(G)=3
\quad\Longleftrightarrow\quad
X\text{ is }G\text{-unirational}
\]

is already installed.  Declaring `ed(G)` or the canonical dimension of the
generic compression to be the new invariant merely renames the desired
answer.  The prime-local values `2,1,1,1` do not determine the global value.
Duncan--Reichstein's local-to-global statement that would assemble the Sylow
data is conjectural, and Kresch--Tschinkel's versal-twist reduction does not
compute the point.

**Verdict.** The functoriality is tautological, but there is no independent
computable invariant or lower-bound theorem.  More basically, the packet's
precondition requires a genuinely new invariant, so essential dimension
itself is disqualified rather than counted as a numbered D2.0 failure.

## 8. Nonabelian or genuinely mixed descent data

Nonabelian cohomology, a compatibility obstruction between different Sylow
reductions, or an unstable integral operation could evade the CRT theorem.
No audited source provides:

- a class attached to the genuine generic Klein twist;
- a relative-dimension-one functoriality theorem;
- an equivariant blowup formula;
- and a nonzero target computation.

This is the honest surviving possibility, but it is a research prompt rather
than a selected invariant.

## 9. Candidate ledger

| Candidate | Failing D2.0 requirement | Exit consequence |
|---|---|---|
| additive torsion stack/Chow/cohomology class | 5, by Sylow detection | refuted |
| mod-`p` equivariant motive extension | 2 and 4, multiplier `n` | no bridge |
| stack Steenrod/power operation | 3--5 | no bridge |
| integral polarized `G`-lattice | 4, similitude multiplier `n` | no bridge |
| admissible-centre cobordism quotient | 2 and 3 | theorem missing |
| canonical/essential dimension | fails the new-invariant precondition | not new |
| nonabelian mixed descent | no defined functorial class | not selected |

Therefore the exact exit is

```text
D2-NO-VALID-BRIDGE
```

## 10. Primary references

- A. Duncan and Z. Reichstein, *Versality of algebraic group actions and
  rational points on twisted varieties*,
  <https://arxiv.org/abs/1109.6093>: `p`-versality, Sylow fixed points, and
  the conjectural local-to-global boundary for the Klein cubic.
- B. Totaro, *The Chow ring of a classifying space*,
  <https://arxiv.org/abs/math/9802097>: Chow groups of `BG` and quotient
  varieties; the restriction/transfer calculation here is formal.
- Yu. Tschinkel and Zh. Zhang, *Cohomological obstructions to equivariant
  unirationality*, <https://arxiv.org/abs/2504.10204>: the degree-two and
  degree-three obstruction framework already evaluated in the repository.
- F. Scavia, Yu. Tschinkel, and Zh. Zhang, *Birational invariance of higher
  Amitsur groups*, <https://arxiv.org/abs/2605.02763>: vanishing of all higher
  Amitsur groups from the universal-torsor vanishing in the present Picard
  setting.
- A. Kresch and Yu. Tschinkel, *Linearizability notions in equivariant
  birational geometry*, <https://arxiv.org/abs/2606.10965>: versal-twist
  quantifiers, not a computation of the generic Klein point.
- Goal D at commit `fc4e4900c70101d27ae5facef3bf6a706bdb9e11`:
  the exact multiplier identity and free-orbit Prym countermodel consumed by
  this audit.
