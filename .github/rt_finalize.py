#!/usr/bin/env python3
from __future__ import annotations

import json
import re
import subprocess
from pathlib import Path

ROOT = Path("problems/E-klein-cubic")
NOTEBOOK = ROOT / "NOTEBOOK.md"
MANIFEST = ROOT / "notebook_build/manifest.json"
MARKER = "## 2026-08-10 RT split completion and correction"

ENTRY = r'''

## 2026-08-10 RT split completion and correction

This entry supersedes the earlier same-day `RT split and restricted dichotomy:
packet opened` entry. Packet:
`goal_runs_20260810/RT_SPLIT_AND_DICHOTOMY/`. Branch:
`agent/rt-split-dichotomy-20260810`. Draft PR: **#16**.

**Headline:** Problem E remains **OPEN**.

**Final exits for this run:**

```text
RESTRICTED-DICHOTOMY-PROVED
RESTRICTED-CARRIER-BRANCH-PROVED
RESTRICTED-CLEAN-CM-NORM-PROVED
CLEAN-CASE-TRANSFER-UNDECIDED
POINT-SUPPORT-CHARACTERIZED
SUPPORT-ESCAPE-UNDECIDED
SXX-LOCAL-REES-UNDECIDED
```

On the restricted normalized graph, strict support is canonical per perverse
cohomology and the canonical orthogonal projector on middle intersection
cohomology gives the CARRIER/CLEAN dichotomy. No canonical splitting of the
whole derived object and no Chow projector are claimed. In CLEAN,
`u_phi^dagger u_phi=[delta]`; the scalar commutant is `Q(sqrt(-11))`, the
integral scalar order is the maximal order, and `delta=x^2+xy+3y^2`. The exact
sieve is consistent with degrees 1, 2, 3, 5, every degree statement in the
full selfmap packet, and the local `[-5]`/norm-25 bookkeeping.

For `S not subset X`, Artin vanishing proves the raw-base-change injection
exactly for `j0>=0`, but an iterated normalized-blowup model separates the
selected exceptional component from the dominant transform by an intervening
vertical component. Thus automatic CT1/CT3 transfer remains undecided.

Refined Bezout excludes only free surface cells in ambient degrees 22--25
(retraction degrees 24--25). Free curves and points survive the live range,
and free surfaces survive from degree 26. Point support in degree `j0=-1` is
characterized by a pure weight-three fiber-IC Hodge block and the stabilizer
Hom condition; no finiteness of the fiber-to-target map is assumed.

For `S subset X`, the rank-two local model is `(F,h^m)` and rank one requires
all higher minors. The exact `(v,w)` and contracted weak line/conic examples
show that Rees survival does not determine the IC gluing map. Ambient
restriction is governed by `psi_F`, not by `psi_h` alone.

Task 5 remains held. Its later target is exclusion of actual landing data on
the genus-four/Prym/Fano carriers, not the false blanket vanishing
`Hom_H(V,H^1(C))=0`.
'''


def git_lines(*args: str) -> list[str]:
    return subprocess.check_output(["git", *args], text=True).splitlines()


def main() -> None:
    head = git_lines("rev-parse", "HEAD")[0]

    text = NOTEBOOK.read_text(encoding="utf-8")
    text, count = re.subn(
        r"(notebook parent head: `)[0-9a-f]{7,40}(`)",
        lambda match: match.group(1) + head + match.group(2),
        text,
        count=1,
    )
    if count != 1:
        raise SystemExit("could not update notebook parent-head pin")
    if MARKER not in text:
        text = text.rstrip() + ENTRY + "\n"
    NOTEBOOK.write_text(text, encoding="utf-8")

    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    known = set(manifest.setdefault("known_branches", []))
    for ref in git_lines("for-each-ref", "--format=%(refname:short)", "refs/remotes/origin"):
        if ref in {"origin", "origin/HEAD"}:
            continue
        known.add(ref.removeprefix("origin/"))
    manifest["known_branches"] = sorted(known)
    MANIFEST.write_text(
        json.dumps(manifest, indent=1, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
