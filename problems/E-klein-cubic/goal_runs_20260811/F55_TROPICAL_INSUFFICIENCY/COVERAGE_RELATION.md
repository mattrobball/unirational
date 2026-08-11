# Round 6's boxed theorem (4) versus the Coverage-C residual

**Date:** 2026-08-11
**Verdict:** they are the **same statement**. Not a refinement, not a different
decomposition. The F55 lane's bottom is **unchanged**.

---

## 1. The two formulations

**Round 6, boxed theorem (4).**

> For **every primitive finite support** `S` in `Z^5/Z(1,...,1)`, the
> coefficient ideal satisfies `I_S : (prod_{s in S} A_s)^inf = (1)`.

**Coverage-C adjudication, Theorem 1.1 item 3.**

> For **every finite support** `S` in `M`, `I_S : m_S^inf = (1)`.

Coverage-C proves that its item 3 is equivalent to items 1, 2, 4 and 5 — in
particular to *"the generic F55 trace cubic has no nonzero `K`-point"*, which
is the headline. Its recorded marker is
`F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE`.

## 2. The two are equivalent

The only difference is the range of the quantifier: *primitive* supports versus
*all* finite supports.

* **(all) implies (primitive):** trivial.
* **(primitive) implies (all):** suppose `I_S : m_S^inf = (1)` for every
  primitive support. Then no primitive support-minimal Laurent zero exists. By
  Proposition 2.2 of the parent note, if any nonzero Laurent zero existed, a
  primitive support-minimal one would exist; so there is no Laurent zero at
  all. By Proposition 2.1 (invariant denominator clearing) there is then no
  rational zero. Hence for **every** finite support `S` there is no zero with
  support exactly `S`, and Theorem 3.2 gives `I_S : m_S^inf = (1)`. ∎

So (4) is Coverage-C item 3 verbatim, restricted along an equivalence that the
repository had already proved. **(4) is headline-equivalent.**

## 3. Consequences for how the row is carried

Round 6's ledger lists

```text
F55-ALL-SUPPORT-COVERAGE   UNDECIDED
X_GEN(K_PROJ)-EMPTY        UNDECIDED
PROBLEM-E-NEGATIVE         UNDECIDED
```

as three separate rows. They are **not** three separate open problems: the
first is logically equivalent to the second, and the second is the headline.
Carrying (4) as a standalone row invites exactly the mistake Coverage-C was
written to withdraw — treating the coverage statement as *"a smaller theorem
standing between the certificates and the headline"*. The repository's
convention is to record it once, as `PROBLEM-E-HEADLINE-OPEN`, with the
equivalence noted. This packet keeps that convention.

## 4. Round 6's gap statement is weaker than the repository's

Round 6 says:

> The polar-circuit argument proves (4) only for supports containing a
> classified clean polar diamond or a failed binomial cycle; it does not prove
> that every primitive support contains such a cancellation core.

That is true as far as it goes, but the repository is **further along** in two
respects, and the round-6 sentence must not be allowed to overwrite them.

1. **The cheap alternatives are not merely unproven — they are refuted.**
   Coverage-C §2 exhibits the explicit deletion-minimal 16-point support
   `S_16` on which, exactly:

   ```text
   no nonzero row is a singleton;
   deleting any one point creates a singleton row;
   there is no clean polar pair with nonzero determinant;
   the initial binomial subsystem has eleven distinct rows, rank eleven and
     Smith diagonal (1,...,1) -- no integral holonomy relation to fail.
   ```

   Marker: `F55-PC-CHEAP-COVERAGE-REFUTED`. This packet independently
   reproduces the first two of those four facts from a from-scratch compiler
   (`verify_saturation_supports.py`).

2. **The circuit list has grown past diamonds and binomial cycles.** Coverage-C
   §§3–4 add two *universal* algebraic circuits with proofs — the four-row
   polar rectangle (3.1) and the three-row completion (4.2) — and `S_16` is
   killed by the rectangle instance (2.2), reproduced exactly in this packet.
   Marker: `F55-PC-HIGHER-CIRCUITS-PASS`. Round 6's list of two alternatives
   omits alternative (iv) of Coverage Theorem C and both higher circuits.

So the honest gap statement is not "diamonds and binomial cycles do not
obviously cover", but:

> A stated universal circuit list, together with an independently proved
> coverage theorem for it, would give a negative proof. The list currently
> contains singletons, clean polar diamonds, failed binomial holonomy, the
> four-row rectangle and the three-row completion. No coverage theorem is
> proved for any list, and by §2 above any such theorem is equivalent to the
> headline unless it comes with a **uniform bound** — a fixed number of rows
> and a fixed multiplier degree — which nobody has stated.

## 5. Net effect on the lane

```text
before this round:  F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE, F55-QUESTION-OPEN
after  this round:  F55-PC-COVERAGE-C-EQUIVALENT-TO-HEADLINE, F55-QUESTION-OPEN
```

The bottom is unchanged and is not newly structured. What round 6 contributes
here is a cleaner *phrasing* of the same residual, and a reminder that the
useful open direction is the **uniform** reading, not the unbounded one.

```text
F55-ALL-SUPPORT-COVERAGE-EQUIVALENT-TO-HEADLINE
F55-COVERAGE-C-RESIDUAL-UNCHANGED
```
