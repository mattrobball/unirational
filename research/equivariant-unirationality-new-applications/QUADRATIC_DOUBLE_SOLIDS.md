# Quadratic double solids and double quadrics

## 1. Terminology split

The phrase **quadratic double solid** is used ambiguously, so this packet
separates two geometries.

### 1.1 Double cover of \(\mathbf P^3\) branched over a quadric

A smooth double cover

\[
w^2=q_2(x_0,x_1,x_2,x_3)
\]

is itself a smooth quadric threefold in \(\mathbf P^4\). This class is
already decided by the current equivariant-unirationality theory: a
generically free action on a smooth quadric threefold satisfying Condition
(A) is stably linearizable, hence \(G\)-unirational and weakly versal.
Therefore this meaning of “quadratic double solid” cannot provide a new
negative theorem after Condition (A) passes.

**Status:** `ALREADY-DECIDED`.

### 1.2 Double cover of a smooth quadric threefold

A **double quadric** is

\[
\pi:X\longrightarrow Q^3\subset\mathbf P^4
\]

branched over

\[
B=Q^3\cap\{f_4=0\}.
\]

In weighted-projective form it is a complete intersection

\[
X_{2,4}\subset\mathbf P(1,1,1,1,1,2).
\]

Smooth members are Picard-rank-one index-one Fano threefolds with
\((-K_X)^3=4\). The deck involution is central and fixes the canonical
surface \(B\), for which

\[
K_B=\mathcal O_B(1).
\]

Thus the fixed divisor is non-uniruled, exactly the geometry desired by the
residual-RCC obstruction. The difficulty is not the deck-fixed surface; it
is finding a residual group that simultaneously passes Condition (A), has
empty deeper fixed locus, preserves no rational curve on \(B\), and lies on
a double quadric whose ordinary unirationality is known.

## 2. Literature boundary

Przyjalkowski--Shramov classify nodal double quadrics acted on by finite
simple nonabelian groups and analyze their rationality. The resulting large
simple actions are of \(A_5\)- and \(A_6\)-type. The \(A_6\) model is
singular, while the \(A_5\) locus contains explicit parameter families.
Kuznetsova identifies nodal families with Artin--Mumford obstructions.
Abban--Cheltsov--Kasprzyk--Liu--Petracci place smooth double quadrics in the
same K-moduli problem as quartic threefolds.

These papers do not supply an equivariant-unirationality theorem for the
named deck-extended actions. They also show why one should not rank the
whole class highly: ordinary rationality is generally negative, stable
rationality is delicate, and ordinary unirationality is not uniformly
available.

## 3. A local Condition-(A) screening lemma

> **Lemma (isolated fixed point with trivial fiber character).** Let a
> finite group \(H\) act on a smooth variety \(Q\), let \(L\) be an
> \(H\)-linearized line bundle, and let
> \(s\in H^0(Q,L)^H\). Suppose \(p\in Q^H\) is isolated and the action of
> \(H\) on \(L_p\) is trivial. If \(s(p)=0\), then the invariant divisor
> \(B=(s=0)\) is singular at \(p\).

**Proof.** The derivative

\[
ds_p:T_pQ\longrightarrow L_p
\]

is \(H\)-equivariant. Since \(p\) is an isolated fixed point,
\((T_pQ)^H=0\). In characteristic zero the representation is semisimple,
so there is no trivial quotient of \(T_pQ\). Since \(L_p\) is trivial,
\(ds_p=0\). Together with \(s(p)=0\), this makes \(p\) a singular point of
\(B\). \(\square\)

### Deck-cover consequence

Let \(X\to Q\) be a smooth double cover with central deck involution
\(\tau\), branched over an \(H\)-invariant divisor \(B\in|L|\). Under the
hypotheses of the lemma, a smooth branch divisor avoids every such point
\(p\). Hence

\[
X^{H\times\langle\tau\rangle}=B^H
\]

contains no point supported on that isolated fixed locus. If these are all
of \(Q^H\), Condition (A) already fails for the abelian subgroup
\(H\times\langle\tau\rangle\).

This is a useful rejection test: forcing an invariant branch divisor through
an isolated fixed point does not rescue Condition (A) when the quartic
fiber character is trivial; it destroys smoothness instead.

## 4. Exact permutation-quadric rejection theorem

Take

\[
Q=\{x_0^2+x_1^2+x_2^2+x_3^2+x_4^2=0\}
\subset\mathbf P^4
\tag{4.1}
\]

and let `c=(0123)` cyclically permute the first four coordinates and fix
`x_4`. The eigenspaces of `c` on `C^5` are:

- a two-dimensional `+1`-eigenspace
  `C(1,1,1,1,0)+C(0,0,0,0,1)`;
- one-dimensional eigenspaces spanned by
  `(1,lambda,lambda^2,lambda^3,0)` for
  `lambda=-1,i,-i`.

On the `+1`-eigenspace, the quadric restricts to

\[
4a^2+b^2=0,
\]

so it contributes two reduced projective fixed points. The `i`- and
`-i`-eigenlines lie on `Q`, while the `-1`-eigenline does not. Hence

\[
|Q^{\langle c\rangle}|=4,
\tag{4.2}
\]

and every fixed point is isolated.

At a fixed eigenline with eigenvalue `lambda`, the tautological fiber of
`O_Q(-1)` has character `lambda`; therefore `O_Q(4)` has character
`lambda^{-4}=1`. Applying the screening lemma gives:

> **Proposition.** Let `s in H^0(Q,O_Q(4))` satisfy `c*s = s` — a genuinely
> invariant section, not merely one with `c`-invariant zero divisor — and
> suppose `B=(s=0)` is smooth. Let `X -> Q` be the associated smooth double
> quadric, let `tau` be the deck involution, and lift `c` so that it commutes
> with `tau` and fixes the covering coordinate. Then
> 
> \[
> B^{\langle c\rangle}=\varnothing,
> \qquad
> X^{\langle c,\tau\rangle}=\varnothing.
> \]
> 
> Thus Condition (A) fails for the abelian subgroup
> `C4 x C2deck`.

This is an exact rejection for the invariant-section model, not a generic
heuristic. It explains why the most obvious `S5` and Frobenius-subgroup
attempts in the natural permutation model never reach the residual-RCC
obstruction.

### Exact boundary of the rejection

A divisor `B` that is only `c`-*stable* is cut by a semi-invariant section,
`c*s = chi(c) s` for a character `chi` of `C4`. This changes the target
character of `ds_p` and the rejection can fail. The exact finite data are the
`c`-characters of the tangent spaces `T_p Q` at the four fixed points, which
the verifier computes:

| fixed point | `c`-eigenvalue on the eigenline | characters of `T_p Q` |
|---|---|---|
| the two points of `P(+1-eigenspace) cap Q` | `1` | `-1, i, -i` |
| the `i`-eigenline | `i` | `i, -i, -i` |
| the `-i`-eigenline | `-i` | `i, i, -i` |

The trivial character is absent from all three rows, which is exactly the
screening lemma. But `chi=i` or `chi=-i` occurs at every fixed point, and
`chi=-1` occurs at the two `+1`-eigenspace points, so a smooth
semi-invariant branch divisor with one of those characters may pass through
the corresponding fixed points. Two remarks bound how much this matters:

- for the double cover `w^2=s` to carry a lift of `c` commuting with `tau`,
  the character `chi` must be a square in the character group of the lifted
  group; a `chi` of order four forces the lift to have order eight, so the
  abelian subgroup under test is then `C8`, not `C4 x C2deck`;
- no such semi-invariant model is analyzed here. The `chi != 1` cases are
  recorded as open, not as rejected.

Replay:

```text
python3 verify_double_quadric_c4_screen.py
```

Expected marker:

```text
DOUBLE_QUADRIC_C4_SCREEN_OK fixed_points=4
```

## 5. Ranked double-quadric targets

| candidate | exact status | obstruction potential | decisive gap | score |
|---|---|---|---|---:|
| nodal \(A_6\) double quadric, extended by deck | `PARTIALLY-COVERED` | very high group-theoretically: \(A_6\not\subset\operatorname{PGL}_2\) | singular-target resolution, Condition (A), ordinary unirationality | 61 |
| \(A_5\) parameter family of double quadrics, extended by deck | `LITERATURE-STATUS-UNCERTAIN` | canonical fixed surface explicit | \(A_5\subset\operatorname{PGL}_2\), so stable rational curves are not excluded abstractly | 52 |
| natural permutation \(S_5\) or \(C_4\)-containing subgroup | `ALREADY-REJECTED-BY-CONDITION-A` for the invariant-section model | low | exact four-point fixed-locus lemma forces branch avoidance | 20 |
| double cover of \(mathbf P^3\) branched over a quadric | `ALREADY-DECIDED` | none after Condition (A) | smooth quadric theorem is positive | 5 |

## 6. Conclusion

Quadratic branch double solids do not supply a new negative theorem because
they are quadrics and Condition (A) is sufficient. Genuine double quadrics
have the right central fixed surface, but the best large-group examples are
currently penalized by singularities, uncertain ordinary unirationality, or
failure of Condition (A). The new local lemma and exact `C4` computation
substantially narrow the search and prevent smoothness-destroying fixed-point
constructions from being mistaken for viable candidates.
