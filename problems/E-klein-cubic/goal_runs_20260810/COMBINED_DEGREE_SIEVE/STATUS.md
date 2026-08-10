# Combined degree sieve for the CLEAN branch — status

Problem E remains **OPEN**.

## Exit ledger

```text
COMBINED-SIEVE-TABLE

SELFMAP-EXCESS-DEGREE-IDENTITY-PROVED
COMMON-FACTOR-INVARIANT-DEGREE-SET-PROVED
CLEAN-INERT-VALUATION-CRITERION-PROVED
COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED
```

`COMBINED-SIEVE-ALL-DEGREE-CLOSURE` is **not** obtained, and
`COMBINED-SIEVE-NO-PERIODIC-CLOSURE-PROVED` records why it cannot be: the cell
\(\delta=3\) satisfies every sealed constraint at every live degree, so no
residue class mod any modulus dies.

## Headline

The combined sieve produces the exact survivor table and, with it, a proof that
the arithmetic route to closing CLEAN is exhausted.  Every sealed constraint in
the repository is either an upper bound on \(\delta\) or a membership condition
on \(\delta\); none is a lower bound past \(\delta\ge3\), and \(3\) is a norm
from \(\mathbf Q(\sqrt{-11})\).  Closing CLEAN needs a geometric exclusion of
small \(\delta\), not more congruences.

## One-line boundary per task

1. **Ledger.** Thirteen degree conditions examined.  Seven usable sealed rows
   (A1–A7 of `CONSTRAINT_LEDGER.md`); four excluded as unsealed or
   inapplicable (the mod-330 residue sieve, the \(D\)-parity statements, the
   \(V_4\)-line order bound, the F55 material).  The mod-330 sieve is excluded
   twice over: it is an unedited external transcript, and its own text says it
   does not constrain the degree.
2. **\(\delta\)–\(d'\) bookkeeping.** Proved
   \(3\delta=3d'^3-3d'z-e\) with \(z=\deg(H\cap s_1(Z,X))\),
   \(e=\deg s_0(Z,X)\) (Fulton Prop. 4.4); proved \(3\mid z\) by integrality of
   \(p_*g^*\ell\) on \(H^4(X,\mathbf Z)=\mathbf Z\ell\), and
   \(2d'z+e=3a\) with \(a\ge0\) by effectivity of \(g_*[E]\).  Hence
   \(\delta=d'^3-d'\zeta-a\) and, for a one-dimensional base scheme,
   \(1\le\delta\le d'^3-d'\).  Bézout on \(X\) gives \(\deg Z\le3d'^2\).
   **The identity yields an interval and no congruence.**
3. **CLEAN as congruences.** \(\delta\) is a norm iff \(v_p(\delta)\) is even
   for every inert \(p\), and \(p\ne11\) is inert iff
   \(p\bmod11\in\{2,6,7,8,10\}\) — \(2\) included, so \(v_2(\delta)\) is even
   and \(\delta\equiv2\pmod4\) is impossible.  Verified against direct
   representation by \(x^2+xy+3y^2\) on \([1,20000]\).  \(\delta=1\) is a norm;
   the \(u_\varphi=\pm1\) rigidity is out of sieve scope.
4. **The sieve.** For \(22\le d\le30\) both branches die by
   `FIX-P2-SWEEP2-EMPTY-THROUGH-30`.  For \(31\le d\le60\) both branches live:
   the retraction branch at the single value \(\delta=1\), the all-ambient
   branch at exactly the norms in \([3,d^3-d]\) (6782 values at \(d=31\), 44364
   at \(d=60\), minimum always \(3\)).  Where CLEAN survives, **CARRIER
   remains** as the standing alternative — the CARRIER branch was out of scope
   and is not analysed.
5. **No periodic closure.** For every modulus \(M\) and residue \(r\), the
   least \(d\ge31\) with \(d\equiv r\) admits the explicit cell
   \((k,d',\zeta,a,\delta)=(0,d,1,d^3-d-3,3)\).  Certified for 10724
   \((M,r)\) pairs.

## New sealed ingredients

* The removed divisor is \(G\)-invariant, and
  \(\dim H^0(X,\mathcal O_X(k))^G\ge1\) exactly for
  \(k\in\{0\}\cup\{5,6,7,\ldots\}\); hence \(d'\ne d-1,d-2,d-3,d-4\).
* The excess-intersection identity and its integrality/positivity refinement.
* The inert-valuation form of the CLEAN norm condition.

The character data underlying the first is confirmed independently: it
reproduces the covariant dimensions \(32,41,49,59,73,86,100\) at \(d=15..21\)
that `AMBIENT_REES_SELFMAP_CLASSIFICATION/LOW_DEGREE_DOMINANT_MAPS.md` obtained
by Reynolds averaging modulo the split prime \(67\).

## Scope and nonclaims

* The CARRIER branch is **not** analysed; "CARRIER remains" is recorded wherever
  CLEAN survives, as instructed.
* Dominance of \(\varphi=A|_X\) is an **inherited hypothesis** from
  `RT_SPLIT_AND_DICHOTOMY/THEOREM_RESTRICTED_DICHOTOMY.md` §1, not proved here.
* No upper bound on \(d\) is claimed, and no degree above \(60\) is tabulated;
  Theorem 5.2 is uniform in \(d\) and covers them structurally.
* A1, A2 and A4 are merged-on-`main` packet theorems, not hash-sealed
  certificates; A3 is machine-replayed.  Each row of `CONSTRAINT_LEDGER.md`
  states its own level.

## Exact checks

```text
python3 verify_combined_sieve.py
```

Exact integer and exact cyclotomic-integer arithmetic only.  No floating point,
no Groebner basis, no finite-field sampling, no search.  Terminal markers:

```text
COMBINED_SIEVE_CHARACTER_DATA_OK
COMBINED_SIEVE_INVARIANT_DEGREE_SET_OK
COMBINED_SIEVE_NORM_CRITERION_OK
COMBINED_SIEVE_DELTA_INTERVAL_OK
COMBINED_SIEVE_TABLE_OK
COMBINED_SIEVE_NO_PERIODIC_CLOSURE_OK
```
