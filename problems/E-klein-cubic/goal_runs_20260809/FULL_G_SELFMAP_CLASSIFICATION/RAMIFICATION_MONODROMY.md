# Ramification and monodromy

Let \(Y\to X\) be the finite part of the normalized Stein factorization of a
dominant rational selfmap, and let

\[
K=\varphi^*\mathbf C(X)\subset L=\mathbf C(X),
\qquad [L:K]=\delta.
\]

## 1. What remains valid

The accepted results remain unchanged:

- \(\delta=2\) is impossible;
- cyclic Galois restrictions are impossible;
- Galois restrictions of degrees \(2,\ldots,11\) are impossible;
- a non-Galois cubic may be deckless, and its \(S_3\) normal closure creates
  auxiliary double covers rather than a deck involution of \(X\).

The tangent-residual theorem proves that some extension with \(\delta\ge3\)
actually occurs. It does not determine whether this extension is Galois,
solvable, primitive, or deckless.

## 2. Normal closure

For a normal closure \(M/K\) with monodromy group \(\mathfrak M\), the
\(G\)-action on the pair \(L/K\) produces an extension of groups

\[
1\to\mathfrak M\to\mathcal E\to G\to1.
\tag{2.1}
\]

Only in special cases, such as \(\mathfrak M=S_3\) with trivial centre and
all automorphisms inner, does (2.1) split canonically as in the existing cubic
audit. In general simplicity of \(G\) does not force a deck transformation of
\(L/K\), and an action on normal-closure data need not give a birational
selfmap of \(X\).

The existence theorem rules out any universal group-theoretic argument that
would eliminate every possible \(\mathfrak M\).

## 3. Branch divisor

On a normal finite model, the branch divisor is \(G\)-stable. Since \(G\) is
perfect, its defining semi-invariant is invariant. The accepted invariant-ring
calculation gives no nonzero invariant divisor of class \(mH\) for
\(1\le m\le4\). Hence a nonzero branch divisor has total class at least
\(5H\); for a double cover the class is even, hence at least \(6H\).

This is not a contradiction. Finite covers of a Fano threefold may be of
general type. The exact invariant sextic cover in the degree-three audit shows
that the first double-cover class is populated.

## 4. Iteration

For a tangent-residual selfmap of degree \(\delta\ge3\), iteration produces a
tower

\[
L\supset\varphi^*L\supset(\varphi^2)^*L\supset\cdots
\]

with total degrees \(\delta^m\). Thus low-degree Galois and resolvent screens
cannot classify the full monoid. Iteration also introduces canonical
intermediate subextensions even when the first extension is primitive.

## 5. Exact stop

The ramification/monodromy program can still constrain a specified
ambient-extendable map, but it cannot prove that arbitrary equivariant
selfmaps have degree one. For Problem E it must be coupled to the global
landing identity and actual base ideal.
