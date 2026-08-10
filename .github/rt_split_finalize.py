#!/usr/bin/env python3
from pathlib import Path
import json
import re
import subprocess

ROOT = Path(__file__).resolve().parents[1]
PROBLEM_ROOT = ROOT / "problems/E-klein-cubic"
NOTEBOOK = PROBLEM_ROOT / "NOTEBOOK.md"
MANIFEST = PROBLEM_ROOT / "notebook_build/manifest.json"
HEAD = subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, text=True).strip()
HEADING = "## 2026-08-10 RT split, restricted dichotomy, and support-escape audit"
ENTRY = r'''## 2026-08-10 RT split, restricted dichotomy, and support-escape audit

Packet: `goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/`.
Problem E remains **OPEN**.

```text
RESTRICTED-DICHOTOMY-PROVED
RESTRICTED-CARRIER-BRANCH-PROVED
RESTRICTED-CLEAN-CM-NORM-PROVED
CLEAN-CASE-TRANSFER-UNDECIDED
POINT-SUPPORT-CHARACTERIZED
SUPPORT-ESCAPE-UNDECIDED
SXX-LOCAL-REES-UNDECIDED
```

Task 1 is proved at the Hodge-module level.  Canonical unit and trace for
`pi:Gamma->X` split the unique full-support `IC_X` summand from the
proper-support complement without a chosen decomposition-theorem splitting
and without a Chow projector.  A nonzero exceptional projection gives the
intrinsic restricted condition `(AHS-Gamma)`.  In the CLEAN branch the
exceptional correction vanishes and

\[
u_\varphi^\dagger u_\varphi=\delta\operatorname{id}_V.
\]

The integral `G`-Hodge commutant is
`Z[(1+sqrt(-11))/2]`; hence every CLEAN degree is
`x^2+xy+3y^2`.  The mandatory audit passes: 2 is not represented; 3 and 5
are; the tangent-residual selfmap has only an unspecified degree `delta>=3`
and is CARRIER if that degree is not a norm; and the elliptic multiplier
`[-5]` has norm and square 25, yielding 75 in the carrier formula rather than
a threefold selfmap degree five.

Task 2 remains undecided at CT1.  Artin vanishing proves the restriction
injection exactly for `j_0>=0`, and finite normalization gives `IC` of the
dominant component plus possible proper-support summands.  But the exact
normalized toric model `I=(x,y)(x,y,t)`, with `X=(t)` and
`S=(x,y) not subset X`, has no fan cone containing both the divisor ray over
`S` and the strict-transform ray of `X`; the intervening valuation over
`S cap X` separates them.

Task 3 does not close free support.  Refined Bezout capacities are `d^2`,
`d^3`, and `d^4`.  The binding unconditional live range is `d>=31`, not
`d>=22`; a free orbit of 660 surface components is already compatible from
`d=26`, so no requested live cell dies.  Point support is characterized:
`j_0=-1` and a weight-three summand
`W_x subset H^{-1}(p^{-1}(x),IC_Y)` must contain the restricted stabilizer
representation after twist.  The fiber maps onto its target-limit image but
need not map finitely.

Task 4 proves the unit-minor local branch only.  There `I=(F,h^m)`, the
normalized Rees ray is `(m,1)`, and the dominant/vertical components meet;
the cohomological transfer is the Gysin map from `S`.  The usual `psi_h` of an
already isolated vertical block is zero, so gluing must be computed in the
total `IC` object.  The rank-one Rees fan and nonzero Gysin/IC gluing remain
open.  The criterion reproduces the exact `V4` behavior: `(v,w)` survives,
while the weak line and conic divisors with determinants `W^4-V^4` and
`u^3(v^2-w^2)` contract.

Task 5 remains held; no fixed-carrier/type-I/type-II enumeration was resumed.
The future target is exclusion of actual landing data, not the false blanket
vanishing `Hom_H(V,H^1(C))=0`.

`verify_norm_sieve.py`, `verify_degree_accounting.py`,
`verify_local_rees.py`, and `scripts/check_manifest_parity.py` all pass.  The
packet is on `agent/rt-split-dichotomy-20260810`, draft PR #18.  This notebook
revision was authored against parent head `@@HEAD@@`.
'''.replace("@@HEAD@@", HEAD)

text = NOTEBOOK.read_text(encoding="utf-8")
text, count = re.subn(
    r"(notebook parent head: `)[0-9a-f]{7,40}(`)",
    rf"\g<1>{HEAD}\g<2>",
    text,
    count=1,
)
if count != 1:
    raise SystemExit("could not update notebook parent-head pin")
if HEADING in text:
    text = text.split(HEADING, 1)[0].rstrip() + "\n\n" + ENTRY.rstrip() + "\n"
else:
    text = text.rstrip() + "\n\n" + ENTRY.rstrip() + "\n"
NOTEBOOK.write_text(text, encoding="utf-8")

manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
known = manifest.setdefault("known_branches", [])
concurrent_branch = "integrate/v22-gates-20260810"
if concurrent_branch not in known:
    known.append(concurrent_branch)
    known.sort()
MANIFEST.write_text(json.dumps(manifest, indent=1, ensure_ascii=False) + "\n", encoding="utf-8")

for rel in (".github/workflows/rt_split_finalize.yml", ".github/rt_split_finalize.py"):
    path = ROOT / rel
    if path.exists():
        path.unlink()
