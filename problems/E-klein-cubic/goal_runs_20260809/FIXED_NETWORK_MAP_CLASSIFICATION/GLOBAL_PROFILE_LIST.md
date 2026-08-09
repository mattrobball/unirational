# Global profile list

## 1. Three levels of profile

There are three distinct levels which must not be conflated.

1. **Strict local maps:** actual residual-equivariant morphisms between one
   original fixed elliptic or rational line and a component of `X^t`.
2. **Reduced-network maps:** actual `G`-equivariant morphisms of the reduced
   union `N` of the original 55 elliptics and 55 lines.
3. **Ambient resolved profiles:** restrictions of the morphism obtained by
   principalizing the base ideal of a hypothetical ambient landing covariant,
   including its essential exceptional carriers.

Levels 1 and 2 can be classified. Level 3 is not yet finite because the
essential exceptional carriers have not been identified.

## 2. Strict local profile list

For an involution `t`:

### `E_t -> E_t`

\[
P\mapsto[n]P+a,
\qquad n\equiv1\pmod3,\quad a\in E_t[2].
\]

No residual-equivariant constant exists.

### `E_t -> L_t`

The actual maps are precisely the functions satisfying

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

This is an infinite family. The monomials `z^m`, `m=1 mod 3`, already give
unbounded degree.

### `L_t -> E_t`

Impossible: every map `P^1->E_t` is constant and the residual action has no
global fixed point on `E_t`.

These are actual morphisms, not degree states.

## 3. Complete unbroken reduced-network list

Assume every original component survives and every restriction is nonconstant.
Then type-I and type-II compatibility force the elliptic maps to be

\[
[n]:E_t\to E_t,
\qquad n\equiv1\pmod6.
\]

The line map is any residual-equivariant rational map

\[
R:\mathbf P^1\to\mathbf P^1
\]

which fixes the six type-I points pointwise. The same intrinsic map,
transported by conjugation, is used on all 55 lines. Therefore the genuine
unbroken profiles are indexed by

\[
\mathcal P_{\mathrm{unbroken}}
=
\{(n,R): n\equiv1\pmod6,
\ R\in\operatorname{End}_{S_3}(\mathbf P^1),
\ R|_{\mu_6}=\operatorname{id}\}.
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

All type-I and type-II points are fixed. Formal `V_4` linearization makes the
three incident branches coordinate axes, so equality of the branch values is
the complete scheme-theoretic gluing condition. Thus these are genuine
`G`-morphisms of `N`.

## 4. Distinguished reduced-network members

### Identity/retraction member

\[
\Phi_{1,1}=\operatorname{id}_N.
\]

This is the network shadow of the degree-one rational-retraction branch, but
the network does not prove that an ambient map realizing it exists.

### Proposed degree-25 member

\[
\Phi_{-5,1}:
E_t\xrightarrow{[-5]}E_t,
\qquad
L_t\xrightarrow{\operatorname{id}}L_t.
\]

The later packet
`goal_runs_20260809/DEGREE25_MARKED_ELLIPTIC_EXTENSION/` independently proves
that this map is intrinsic and glues scheme-theoretically on the full reduced
network.

It is not unique at the network level:

- `Phi_{-5,7}` has the same elliptic multiplier and a nonidentity line map;
- `Phi_{7,1}` has the identity line map and another elliptic multiplication;
- `Phi_{1,7}` has identity elliptics and higher-degree lines;
- arbitrary nonmonomial `R` fixing `mu_6` gives further profiles.

The same later packet proves that `Phi_{-5,1}` has no strict order-zero
landing extension:

- no homogeneous tuple of one degree is defined everywhere on the network and
  induces it, because the elliptics force `d=25` and the identity lines force
  `d=1`;
- every landing covariant vanishes on every involution plus-space, hence has
  zero ordinary restriction to each original `E_t`.

Thus “canonical survivor” can only mean a profile on exceptional horizontal
carriers selected by the actual base ideal. It cannot mean the strict boundary
morphism itself.

## 5. Contracted strict components

A strict component stable under the full residual `S_3` cannot be mapped
constantly:

- `E_t` has no residual fixed point because the order-three translation is
  free;
- `L_t` has no global fixed point for the faithful `S_3` action;
- the disjoint union `E_t sqcup L_t` therefore has no residual fixed point.

Hence a resolved profile in which an original strict `E_t` or `L_t` remains
present cannot contract that component.

For an actual landing covariant, however, every original `E_t` lies in a
forced plus-plane base stratum. The principalization may replace it by an
exceptional projective bundle with no preferred horizontal section. A proposed
“all elliptics contract” or “elliptics map by `[-5]`” statement is therefore a
claim about replacement carriers, not a statement about the original strict
curves.

## 6. Exceptional profile possibilities

At a first type-I or type-II blowup, the exceptional `P^2` admits:

- three coordinate directions;
- for each involution, a pointwise-fixed connector line which may map to the
  rational target line;
- faithful-`V_4` rational conics;
- residual-`C_3` invariant curves of unbounded degree.

Further equivariant blowups can create components over positive-genus fixed
centers. Consequently the raw all-resolution component list is infinite and
changes under refinement.

A finite ambient profile theorem must quotient out vertical refinements and
prove that only finitely many essential horizontal carriers occur for the
normalized Rees algebra of an actual landing ideal.

## 7. Relation to the formal state machinery

The repaired transition category proves only the forward implication

\[
\text{ambient map}
\Longrightarrow
\text{compatible formal transition state}.
\]

It does not prove the converse and does not construct actual component maps.
The infinite reduced-network family does not contradict that theorem because
most network maps need not extend to the ambient threefold.

The degree-25 order-one formal state is also not the strict boundary map
`Phi_{-5,1}`: the former begins after plus-plane vanishing and records a normal
jet, while the latter is a nonzero order-zero elliptic map. Numerical equality
of the integer 25 does not identify them.

A finite formal-state enumeration is not a finite classification of actual
resolved profiles until an integration theorem identifies each state with an
essential normalized-Rees carrier and proves exhaustiveness.

## 8. Current global list

The honest list is:

- **Unbroken profiles:** the infinite set `P_unbroken` above, completely
  classified as actual reduced-network maps.
- **Strict ambient order-zero profiles:** the proposed `Phi_{-5,1}` is exactly
  obstructed; all landing covariants have zero ordinary elliptic restriction.
- **Local exceptional possibilities:** explicit rational bypasses,
  faithful-action curves, and positive-genus fixed components; not finite
  under arbitrary refinement.
- **Ambient resolved profiles:** an unknown subset selected by the actual
  normalized Rees algebra, normal-jet integrability, and polarization.

No resolved exceptional profile is currently proved ambiently realizable, and
no theorem currently excludes all of them.

## 9. Exit

The correct repository marker is

```text
FIXED-NETWORK-CLASSIFICATION-UNDECIDED
```

with the smallest missing result:

```text
EXCEPTIONAL-CARRIER-INTEGRATION-AND-RIGIDITY
```

Only after that theorem can one decide whether the ambient resolved subset is
empty, has a unique carrier profile numerically resembling `Phi_{-5,1}`, or is
another finite list.
