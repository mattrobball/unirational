# Global profile list

## 1. Objects being classified

There are three distinct levels which must not be conflated.

1. **Strict local maps:** actual residual-equivariant morphisms between one fixed elliptic or rational curve and a component of `X^t`.
2. **Reduced-network maps:** actual `G`-equivariant morphisms of the reduced union `N` of the original 55 elliptics and 55 lines.
3. **Ambient resolved profiles:** restrictions of a morphism obtained by principalizing the base ideal of a hypothetical ambient covariant.

Levels 1 and 2 can be classified. Level 3 is not yet finite because the essential exceptional carriers have not been identified.

## 2. Strict local profile list

For an involution `t`:

### `E_t -> E_t`

\[
P\mapsto[n]P+a,
\qquad n\equiv1\pmod3,\quad a\in E_t[2].
\]

No residual-equivariant constant exists.

### `E_t -> L_t`

Actual maps exist in every permitted family satisfying

\[
u(P+q)=\omega u(P),
\qquad u(-P)=u(P)^{-1}.
\]

Their degree is a multiple of three; degree three occurs.

### `L_t -> L_t`

\[
R(z)=zA(z^3),
\qquad A(u)A(u^{-1})=1.
\]

This is infinite in every sufficiently large allowed degree.

### `L_t -> E_t`

Impossible: every map `P^1->E_t` is constant and the residual action has no global fixed point on `E_t`.

These are actual morphisms, not degree states.

## 3. Complete unbroken reduced-network list

Assume every original component survives and every restriction is nonconstant. Then type-I and type-II compatibility force the elliptic maps to be

\[
[n]:E_t\to E_t,
\qquad n\equiv1\pmod6.
\]

The line map is any residual-equivariant rational map

\[
R:P^1\to P^1
\]

which fixes the six type-I points `mu_6` pointwise. The same map, transported by conjugation, is used on all 55 lines. Therefore the genuine unbroken profiles are indexed by

\[
\mathcal P_{unbroken}
=
\{(n,R): n\equiv1\pmod6,\ R\in End_{S_3}(P^1),\ R|_{\mu_6}=id\}.
\]

This set is infinite. A concrete infinite subfamily is

\[
\Phi_{n,m}:
\begin{cases}
E_t\to E_t,&P\mapsto[n]P,\\
L_t\to L_t,&z\mapsto z^m,
\end{cases}
\qquad
n\equiv m\equiv1\pmod6.
\]

All type-I and type-II points are fixed, so the component maps glue to a `G`-morphism of `N`.

## 4. Distinguished members, without uniqueness

### Identity/retraction member

\[
\Phi_{1,1}=id_N.
\]

This is the network shadow of the degree-one/rational-retraction branch, but the network does not prove that an ambient map realizing it exists.

### Proposed degree-25 member

\[
\Phi_{-5,1}:
E_t\xrightarrow{[-5]}E_t,
\qquad
L_t\xrightarrow{id}L_t.
\]

This is the first nonidentity elliptic multiplication in absolute value among maps fixing all twelve elliptic marked points, with the identity chosen on the line. It is not unique at the network level:

- `Phi_{-5,7}` has the same elliptic multiplier and a nonidentity line map;
- `Phi_{7,1}` has the identity line map and another elliptic multiplication;
- `Phi_{1,7}` has identity elliptics and higher-degree lines;
- arbitrary nonmonomial `R` fixing `mu_6` gives further profiles.

Thus the phrase “canonical survivor” can only mean canonical after additional ambient carrier and polarization constraints.

## 5. Contracted strict components

A strict component stable under the full residual `S_3` cannot be mapped constantly:

- `E_t` has no residual fixed point because the order-three translation is free;
- `L_t` has no global fixed point for the faithful `S_3` action;
- the disjoint union `E_t sqcup L_t` therefore has no residual fixed point.

Hence a resolved profile in which an original strict `E_t` or `L_t` remains present cannot contract that component.

However, the actual base ideal may use the curve itself as a later center, replacing it by exceptional projective bundles. In that situation there is no surviving strict component to which the preceding statement applies. A proposed “all elliptics contract” profile is therefore not a profile of the unbroken network; it is a claim about replacement carriers and requires Rees-algebra analysis.

## 6. Exceptional profiles

At a first type-I or type-II blowup, the exceptional `P^2` admits:

- three coordinate directions;
- for each involution, a pointwise-fixed connector line mapping potentially to the rational target line;
- faithful-`V_4` rational conics;
- residual-`C_3` invariant curves of unbounded degree.

Further equivariant blowups can create components over positive-genus fixed centers. Consequently the abstract all-resolution component list is infinite and changes under refinement.

A finite ambient profile theorem must quotient out vertical refinements and prove that only finitely many essential horizontal carriers occur for the actual covariant base ideal.

## 7. Relation to the formal state machinery

The repaired transition category proves a forward implication:

\[
\text{ambient map}
\Longrightarrow
\text{compatible formal transition state}.
\]

It does not prove the converse, and it does not construct actual component maps. The infinite reduced-network family does not contradict the forward theorem because most network maps need not extend to the ambient threefold.

Conversely, a finite formal-state enumeration is not a finite classification of actual resolved profiles until an integration theorem identifies each state with a normalized Rees carrier and proves exhaustiveness.

## 8. Current global list

The honest list is therefore:

- **Unbroken profiles:** the infinite set `P_unbroken` above, completely classified.
- **Local exceptional possibilities:** explicit rational bypasses, faithful-action curves, and positive-genus fixed components; not finite under arbitrary refinement.
- **Ambient profiles:** an unknown subset selected by the actual base ideal and polarization.

No profile is currently proved ambiently realizable, and no theorem currently excludes all profiles.

## 9. Exit

The correct repository marker is

```text
FIXED-NETWORK-CLASSIFICATION-UNDECIDED
```

with the smallest missing result:

```text
AMBIENT-BASE-CARRIER-RIGIDITY
```

Only after that theorem can one decide whether the ambient subset is empty, consists solely of `Phi_{-5,1}`, or is another finite list.
