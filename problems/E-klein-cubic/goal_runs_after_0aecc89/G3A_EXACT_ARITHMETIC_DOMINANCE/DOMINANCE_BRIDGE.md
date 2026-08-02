# Dominance bridge audit (G3A.3)

## Verdict

```text
G3-DOMINANCE-AUTOMATIC
```

A \(K_{\mathrm{proj}}\)-point of \(X_{\mathrm{gen}}=V(\Phi)\) produces a nonzero
homogeneous \(G\)-equivariant rational map \(f:\mathbf P(W)\dashrightarrow X\).
No separate projective Jacobian-rank-four test is required for dominance.

Machine ledger: `dominance_bridge.json`.

## Positive seven-step ledger

1. **Image irreducible / versality setup.**  
   Let \(Z\) be the Zariski closure of the image of \(f\).  Then \(Z\) is
   irreducible.  The \(G\)-action on \(X\) restricts to \(Z\).  
   *Status:* PASS (definitions; G2 universal-object conventions).

2. **Kernel normal.**  
   The kernel \(N=\ker(G\to\mathrm{Bir}(Z))\) (equivalently the pointwise
   kernel of the action on \(Z\)) is a normal subgroup of \(G\).  
   *Status:* PASS (group action).

3. **Kernel \(\neq G\).**  
   If \(N=G\) then \(Z\subset X^G\).  For the irreducible nontrivial Klein
   representation \(W\), one has \(W^G=0\), hence \(X^G=X\cap\mathbf P(W^G)=\varnothing\)
   (cf. SPEC “No global fixed point”; G2 perfectness of \(\mathrm{PSL}(2,11)\)).  
   *Status:* PASS.

4. **Faithful action.**  
   \(G=\mathrm{PSL}(2,11)\) is simple (order 660; G2 perfectness certificate),
   so \(N=1\) and the action on \(Z\) is faithful.  
   *Status:* PASS (`G2_PSL211_PERFECTNESS_EXACT_OK`).

5. **Generically free.**  
   A faithful action of a finite group on an irreducible variety in
   characteristic zero is generically free (stabilizers jump on a proper
   closed subset).  
   *Status:* PASS (standard; cf. UNIVERSAL_OBJECT freeness language).

6. **Essential dimension bound.**  
   Generically free faithful action realizes \(Z\) as a compression of a
   classifying torsor, so \(\dim Z\ge\mathrm{ed}_{\mathbf C}(G)\).  The accepted
   bound \(\mathrm{ed}_{\mathbf C}(\mathrm{PSL}(2,11))\ge 3\) is the standard
   literature lower bound used by SPEC (Beauville, essential dimension 3).  
   *Status:* ACCEPTED_INPUT (accepted lower bound named by the goal).

7. **Dominance.**  
   \(Z\subset X\) and \(\dim X=3\), so \(\dim Z\ge 3\) forces \(Z=X\).  Thus \(f\) is
   dominant.  
   *Status:* PASS.

## Loopholes

- **Constant maps.**  An equivariant constant map would land in \(X^G=\varnothing\).
  Forbidden.
- **Affine cone / projectivization.**  G2 identifies points of \(V(\Phi)\) with
  homogeneous landing covariants modulo invariant scalars; the induced map is
  a rational map of projective spaces.  Working throughout in the projective
  category closes the cone loophole (same conventions as
  `ALL_DEGREE_THEOREM.md`).

## Negative direction (citation audit)

G2 proves a canonical bijection between \(X_{\mathrm{gen}}(K_{\mathrm{proj}})\) and
nonzero homogeneous landing self-covariants modulo invariant scalars
(`G2-FINITE-GENERATION-PASS`, `ALL_DEGREE_THEOREM.md`, `DECISION.md`).
Therefore

\[
X_{\mathrm{gen}}(K_{\mathrm{proj}})=\varnothing
\]

is exactly the statement that **no** nonzero homogeneous \(G\)-equivariant
polynomial map \(W\to W\) lands in the Klein cubic — i.e. every linear-source
equivariant rational map to \(X\) is absent.  Promoting emptiness to a
headline-negative still requires the accepted source-exhaustiveness bridge
named by G2/DECISION (not re-proved here).

## Explicit non-claims

- No \(K_{\mathrm{proj}}\)-point is produced by G3A.
- No `G3-COVARIANT-HEADLINE-POSITIVE`.
- Dominance automatic applies only after an exact point is later supplied by G3.
