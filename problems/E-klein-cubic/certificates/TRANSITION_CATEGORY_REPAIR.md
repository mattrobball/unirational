# Transition category repair (WP-R0)

**Headline: OPEN.**  
**Dispatch:** First dispatch of `WORKORDER_STRATA_LIFTING_BLOCKERS.md`.  
**Status:** Sealed and independently verified.

## Problem repaired

The WP-5 diagram treated

```text
C2_plane  -->  C2_line
```

as a single restriction/evaluation of the first normal jet. That arrow
conflated three isomorphic residual \(D_{12}\)-spaces:

1. **source** fixed line \(L_t^{\mathrm{src}}=\mathbf P(E_-(t))\subset\mathbf P(W)\);
2. **normal** fiber \(\mathbf P(E_-)^{N}\) in \(\mathbf P(N_{Z_t/Y})\simeq Z_t\times\mathbf P(E_-)\);
3. **target** fixed line \(L_t^{\mathrm{tgt}}=\mathbf P(E_-(t))\subset X^{t}\).

These are not the same geometric object. In particular
\(L_t^{\mathrm{src}}\cap Z_t=\varnothing\).

## What was done

| deliverable | role |
|-------------|------|
| `transition_repair/CATEGORY_AUDIT.md` | human-readable audit of all 16 legacy flags |
| `transition_repair/category_repaired.json` | sealed repaired category + corrected necessity |
| `transition_repair/produce.py` | producer (does not import verifier) |
| `transition_repair/verify.py` | independent verifier |

### Replacement span

\[
Z_t^{\mathrm{src}}
\;\longleftarrow\;
\mathbf P(N_{Z_t/Y})
\;\longrightarrow\;
L_t^{\mathrm{tgt}}
\qquad+\qquad
L_t^{\mathrm{src}}\dashrightarrow X^{t}
\qquad+\qquad
\text{coefficient coupling }p|_{E_-}=p_d(0,y).
\]

### Corrected necessity

Every homogeneous landing self-covariant still maps to a state of the repaired
equalizer \(\Lambda^{\mathrm{rep}}\). The forgetful map to the legacy equalizer
is surjective on linear data, so

\[
\text{corrected state space}\ \ge\ \text{legacy WP-5 state space}.
\]

WP-5 Exit P is **not** overturned. **No negative theorem** is inferred from the
repair (house rule 2).

Surviving families retained (no new Level-1 family):

- `based_minus_lines_odd_m`
- `residual_e1_swap_both`
- `residual_e_ge7_generic_swap_both`

### Verifier acceptance

The verifier:

- classifies every legacy flag independently of the producer;
- requires the four replacement arrows with the four arrow types;
- **rejects** any identification of \(L_t^{\mathrm{src}}\) with a subvariety of
  the plus-plane, and distinguishes all three copies by path tag and role;
- checks size verdict `AT_LEAST_AS_LARGE` and headline `OPEN`.

## Director-verified algebra used

- \(F(z+y)=F(z)+3\Phi(z,y,y)\) on \(E_+\oplus E_-\), and \(F|_{E_-}=0\).
- Covariance \(\Rightarrow\) \(p_r\) is \(E_+\)-valued for even \(r\) and
  \(E_-\)-valued for odd \(r\), and \(p|_{E_-}=p_d(0,y)\).

## What this package does **not** claim

- Existence or nonexistence of a landing covariant.
- Emptiness of nonlinear lifting support.
- That a formal jet is a covariant (house rule 3).

Problem E remains **OPEN**.
