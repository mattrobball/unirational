# msolve 0.10.1 silently mis-parses parenthesised coefficients

**Toolchain landmine found while setting up FIX-N2C.  It invalidates any msolve
run whose input was written with `n2b_lib.eq_str(..., mod=False)` — i.e. every
`qq`-mode msolve call in `goal_runs_after_fa02f05/FIX_N2B_M1_ROW`.**

`/opt/homebrew/bin/msolve` (version 0.10.1, J. Berthomieu, C. Eder,
M. Safey El Din) accepts input containing parentheses **without any error**, and
returns a Groebner basis of a *different* ideal.  Exit code 0, no message on
stderr, no marker in the output file.

## Reproduction

```
$ printf 'x,om\n100057\nx+om*x+1,\nom^2+om+1\n'      > good.ms
$ printf 'x,om\n100057\n(1+1*om)*x+(1),\nom^2+om+1\n' > bad.ms
$ msolve -g 2 -f good.ms -o good.out ; tail -2 good.out
[1*x^1+100056*om^1,
1*om^2+1*om^1+1]:                       <-- correct:  x = om
$ msolve -g 2 -f bad.ms  -o bad.out  ; tail -2 bad.out
[1*x^1+1,
1*om^2+1*om^1+1]:                       <-- WRONG:    x = -1
```

Worse, the failure can turn a consistent system into the **unit ideal**:

```
$ printf 'x,om\n100057\n(2+3*om)*x,\nx-1\n' > bad2.ms
$ msolve -g 2 -f bad2.ms -o bad2.out ; tail -1 bad2.out
[1]:                                    <-- WRONG: the truth is om = -2/3
```

and a single parenthesised numeric factor is simply dropped:

```
$ printf 'x,y\n0\n(3)*x-y,\ny-6\n' > bad3.ms       # truth: x = 2
$ msolve -g 2 -f bad3.ms -o bad3.out ; tail -2 bad3.out
[y-6,
x-6]:                                   <-- WRONG: the (3) was read as 1
```

What *is* safe: plain integer and rational coefficients (`13/8*x-1`,
`-3*x+2*y`), and numeric literals inside a monomial without parentheses
(`1*B0*1*B8` parses as `B0*B8` — so FIX-N2B's textual `B5 -> 1` substitution in
`produce_po1_dehom.py` is **fine**, and so is every `ff`-mode run).

## Consequence for the repository

* FIX-N2B's **`ff`-mode** msolve results (including the `r = 7` alarm of its
  `STATUS.md` §2.7) are unaffected: `n2b_lib.eq_str(..., mod=True)` emits bare
  integers.
* FIX-N2B's **`qq`-mode** msolve path (`produce_gb.build`, `mode != 'ff'`, which
  calls `L.eq_str(e, b.names)` and produces `((1)*om)*R0*B5^2`) is **wrong**.
  No verdict in that packet rests on it (its `STATUS.md` §4 only records that
  it was "no better" on timing), but the code must not be reused.
* Every msolve input written by FIX-N2C goes through
  `n2c_systems.emit_vars` / `emit_ff`, which emit **fully expanded, integer
  coefficients with no parentheses**, and `verify_n2c.py` step 3 asserts both
  that the emitters are parenthesis-free and that the two agree termwise after
  specialising `om, kp` mod `p`.
* Macaulay2 handles parentheses correctly, so `m2/*.m2` inputs keep them.

## Detection recipe for future packets

Before trusting any msolve run, assert `'(' not in source`.

## Addendum (FIX-H1, 2026-08-05): the `-g` header landmine

msolve's `-g` (Gröbner basis) output begins with a `#` comment header.
A naive unit-ideal test `output.startswith('[1]')` therefore reports
**every** run as non-unit — the inverse failure mode of the 0-byte bug
above (a false-NONEMPTY factory instead of a false-EMPTY one). It was
live for one round inside FIX-H1 and produced a spurious "the `r = 8`
cone has plane-order-1 points" reading before being caught. Correct
test: strip lines starting with `#`, then compare the body against
`('1', '-1')` — matched to FIX-N2B's parser and self-tested against
unit and non-unit controls (`FIX_H1_EQUALIZER/holes_certify2.py`).
Detection recipe: any msolve-based unit/non-unit verdict must ship with
a positive control (a known unit ideal) and a negative control run
through the same parser.
