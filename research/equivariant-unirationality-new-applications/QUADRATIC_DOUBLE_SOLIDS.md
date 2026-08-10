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

## 4. Application to permutation-type order-four tests

In the natural five-coordinate permutation representations used for many
\(A_5/S_5\)-symmetric double quadrics, an order-four element has only
zero-dimensional fixed locus on a general invariant quadric. At every
fixed eigenline its eigenvalue \(\lambda\) satisfies \(\lambda^4=1\), so
the induced character on the quartic fiber \(\mathcal O_Q(4)_p\) is
trivial. The lemma therefore shows:

> a smooth invariant quartic branch cannot contain any of these isolated
> \(C_4\)-fixed points.

Consequently, for the direct deck extension
\(C_4\times C_2^{\rm deck}\), Condition (A) fails in this natural
permutation model. This explains why the most obvious \(S_5\) and Frobenius
subgroup attempts do not produce a new geometric obstruction: they are
eliminated one stage earlier.

The statement is deliberately restricted to invariant branch sections and
the natural permutation linearization. Semi-invariant sections with a
nontrivial character require a separate fiber-character calculation.

## 5. Ranked double-quadric targets

| candidate | exact status | obstruction potential | decisive gap | score |
|---|---|---|---|---:|
| nodal \(A_6\) double quadric, extended by deck | `PARTIALLY-COVERED` | very high group-theoretically: \(A_6\not\subset\operatorname{PGL}_2\) | singular-target resolution, Condition (A), ordinary unirationality | 61 |
| \(A_5\) parameter family of double quadrics, extended by deck | `LITERATURE-STATUS-UNCERTAIN` | canonical fixed surface explicit | \(A_5\subset\operatorname{PGL}_2\), so stable rational curves are not excluded abstractly | 52 |
| natural permutation \(S_5\) or \(C_4\)-containing subgroup | `ALREADY-REJECTED-BY-CONDITION-A` for the invariant-section model | low | isolated-fixed-point lemma forces branch avoidance | 20 |
| double cover of \(\mathbf P^3\) branched over a quadric | `ALREADY-DECIDED` | none after Condition (A) | smooth quadric theorem is positive | 5 |

## 6. Conclusion

Quadratic branch double solids do not supply a new negative theorem because
they are quadrics and Condition (A) is sufficient. Genuine double quadrics
have the right central fixed surface, but the best large-group examples are
currently penalized by singularities, uncertain ordinary unirationality, or
failure of Condition (A). The new local lemma substantially narrows the
search and prevents smoothness-destroying fixed-point constructions from
being mistaken for viable candidates.
