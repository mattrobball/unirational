# Replay

All commands are run from the repository root. Total wall time about 4 minutes
on the reference machine (Darwin 25.6.0, Apple silicon).

```bash
cd problems/E-klein-cubic/goal_runs_20260811/F55_TROPICAL_INSUFFICIENCY

python3 verify_operator_identity.py     #  < 1 s
python3 verify_saturation_supports.py   #  ~ 2 min
python3 verify_tropical_lift.py         #  ~ 25 s
M2      --script crosscheck.m2          #  ~ 10 s
```

Expected terminal lines:

```text
F55_OPERATOR_IDENTITY_OK
F55_SATURATION_SUPPORTS_OK
F55_TROPICAL_LIFT_REPLAY_OK
S2 saturation is unit: true
S3 saturation is unit: true
S4 saturation is unit: true
S5 saturation is unit: true
```

Archived runs are in `logs/`:
`operator_identity.txt`, `saturation_supports.txt`, `tropical_lift.txt`,
`crosscheck_m2.txt`. (`.txt`, not `.log` — the repository's `.gitignore`
excludes `*.log`.)

## What each script decides

### `verify_operator_identity.py`

Pure integer arithmetic; a Bareiss determinant and an elementary-operation
Smith normal form, both written out in the file.

* A: `(x+2)(x^4-2x^3+4x^2-8x+16) = x^5+32` in `Z[x]`.
* B: `(2+x)G(x) = 33` in `Z[x]/(x^5-1)`; `G(1) = 11`; `33 = 3 * 11`.
* C: circulant of `2+sigma` on `Z^5` — `det = 33`, Smith form `(1,1,1,1,33)`.
* D: on `M = Z^5/Z(1,1,1,1,1)` — `det = 11`, Smith form `(1,1,1,11)`;
  `sigma^5 = 1`; `M^{sigma^d} = 0` for `d = 1..4`.
* E: `lambda = (1,9,4,3,5) mod 11` well defined on `M`, kills `(2+sigma)M`,
  `lambda(e_2) = 4 != 0`.
* F: `(2+sigma)^{-1}e_2 = (-2/11,-1/11,4/11,-4/11)`, order exactly 11;
  equals `G(sigma)e_2 / 33` with `G(sigma)e_2 = (-6,-3,12,-12)`.
* G: the two polytope-level blocking lemmas (`G(sigma)e_2` not in `11M`).

### `verify_saturation_supports.py`

Exact `Fraction` arithmetic, self-contained degrevlex Buchberger, Rabinowitsch
saturation test. No external CAS.

* Compiles every row twice (Prop 3.1 formula vs literal Laurent expansion) and
  compares, for all six supports including the 1115 rows of `S16`.
* Decides `I_S : m_S^inf = (1)` for `S1..S5`.
* For each of those, extracts a deletion-minimal unit core, deletes one row,
  and exhibits an exact torus point of the remainder over `Q` or `Q(i)`,
  re-substituted into every retained row and into the deleted row.
* Rebuilds Coverage-C's `S16`: distinctness in `M`, no singleton rows, deleting
  any point creates a singleton, the four rows `f1,f2,f3,h` (five occurrences
  each, one per `sigma`-orbit), and identity (2.2) by exact expansion.
* Runs the gate the other way on those same rows: `{f1,f2,f3}` has the explicit
  torus point `A8=-1, A9=2, A11=-2`, rest `1`, at which `h = -2 != 0`.

### `verify_tropical_lift.py`

Reads only `../../director_probes_20260806/f55_qpre_data_P01.json` and
`..._P34.json`. Fan-free: `d(w) = <U_d(C(w)), w>` by sign-vector lookup, and
nothing else. Exact integer / `Fraction` arithmetic.

* Calibrates the `sigma` direction and the `e_2` slot from 33-integrality
  alone (result: `sigma = shift_{+1}` on `N`, `<w,e_2> = w_2`; 183/183).
* Per witness family, at ~3,600 generic lattice points and all five
  `sigma`-translates: `d >= 0`; at least two of the five `d(sigma^i w)` vanish
  (multiplicity exactly 2 at every sample); the defining identity
  `2h(w) + h(sigma^{-1}w) - <w,e_2> = d + m`; `h` integer valued; the twice-min
  read off `h` alone; the mod-3 and mod-11 layers.
* Negative control: `d[0] += 1` breaks 33-integrality at 365/365 samples.

### `crosscheck.m2`

Independent engine for the gate: `saturate(I_S, m_S)` in Macaulay2 over `QQ`
for `S2, S3, S4, S5`, printing whether the result is the unit ideal.

## Regeneration

`crosscheck.m2` is generated from the same compiler:

```bash
python3 - <<'PY'
import verify_saturation_supports as V
ZERO, e, add, neg = V.ZERO, V.e, V.add, V.neg
cases = {'S2': (ZERO, e(0)), 'S3': (ZERO, add(e(0), neg(e(1)))),
         'S4': (e(0), e(1)), 'S5': (ZERO, e(0), e(1))}
out = []
for lab, S in cases.items():
    n = len(S); rows = V.compile_rows(S)
    names = ['A%d' % k for k in range(n)]
    out += ['R%s = QQ[%s];' % (lab, ','.join(names)),
            'I%s = ideal(%s);' % (lab, ', '.join(V.p_str(r, names) for r in rows.values())),
            'J%s = saturate(I%s, %s);' % (lab, lab, '*'.join(names)),
            'print("%s saturation is unit: " | toString(J%s == ideal(1_R%s)));' % (lab, lab, lab)]
open('crosscheck.m2', 'w').write('\n'.join(out) + '\nexit 0\n')
PY
```

## Provenance

Branch `agent/f55-arithmetic-round-20260811`, cut from `origin/main` at
`50ec5d2e`. Nothing under `.github/` is touched.
