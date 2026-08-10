# Status

The invariant-section route has an exact split verdict.

* A general degree-55 invariant hypersurface is smooth and restricts
  dominantly to the hypothetical map.  It is a general-type threefold, so it
  does not produce a rational source or a selfmap of the Klein cubic.
* The five `F55`-stable cubics are the five `C5` eigenlines in the span of
  `x_i^2 x_(i+1)`.  Their common reduced base is the degree-five genus-one
  coordinate pentagon.
* Dominance of the restriction to the source Klein cubic is equivalent to a
  strict inequality against horizontal exceptional multiplicities.  No
  installed theorem proves that inequality.
* The Klein cubic is explicitly **not** `F55`-birationally rigid; the known
  `F55` Sarkisov link uses exactly the pentagon center.  Beauville excludes
  only the basepoint-free morphism branch, not rational selfmaps with base.

```text
F55-DEGREE55-INVARIANT-SLICE-DOMINATES
F55-STABLE-CUBICS-ARE-FIVE-EIGENLINES-WITH-PENTAGON-BASE
F55-KLEIN-RESTRICTION-DOMINANCE-REQUIRES-NEW-BASE-INEQUALITY
F55-BIRATIONAL-SUPERRIGIDITY-INPUT-IS-FALSE
F55-BASEPOINTFREE-SELF-ENDOMORPHISM-BRANCH-EMPTY
F55-AMBIENT-RATIONAL-SELFMAP-BRANCH-OPEN
F55-GLOBAL-QUESTION-OPEN
```

Replay:

```sh
/opt/homebrew/bin/python3 goal_runs_20260808/INVARIANT_RESTRICTION/verify.py
```
