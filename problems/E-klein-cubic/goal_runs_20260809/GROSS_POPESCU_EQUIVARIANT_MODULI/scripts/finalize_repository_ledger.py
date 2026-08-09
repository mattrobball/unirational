#!/usr/bin/env python3
"""Finalize the dated GP packet in NOTEBOOK.md (outside frozen E01--E55)."""
from __future__ import annotations

import argparse
import re
from pathlib import Path

BEGIN = "<!-- GP-EQUIVARIANT-MODULI-BEGIN -->"
END = "<!-- GP-EQUIVARIANT-MODULI-END -->"
SECTION = r'''<!-- GP-EQUIVARIANT-MODULI-BEGIN -->
## 2026-08-09 Gross--Popescu equivariant modular audit

Packet: `goal_runs_20260809/GROSS_POPESCU_EQUIVARIANT_MODULI/`.

**Headline status: OPEN.**  The audit identifies the natural level symmetry
but supplies no bridge to the standard regular Klein action.

### Natural group and equivariant model

Change of canonical level marking gives an `SL2(F11)` action on the marking
stack.  Its exact ineffective kernel is `{+I,-I}`: `-I` is 2-isomorphic to
the identity via `[-1]_A`.  The effective coarse group is
`G=PSL2(F11)`, acting faithfully and generically freely; the generic
forgetful degree is `1320/2=660`, and

```text
C(A_11^lev)^G = C(A_11).
```

Gross--Popescu's `Theta_11` is functorially equivariant: marking change
transports `H^0(I_A(2))` and its Heisenberg multiplicity plane by the even
Weil representation.  The projected Gross--Popescu basis and repository
cosine basis differ by `diag(1,2,2,2,2,2)`.  Their equations become

```text
2p23+p15=0,  2p26-p13=0,  p14+2p35=0,
p16-2p45=0,  2p46+p12=0,
```

and the exact `Q(zeta_11)` verifier identifies the same invariant `10'`
summand used by `FIX_IX_SEAL`.  Hence `A_11^lev ~_G V14` for the natural
effective level action.

Exits: `GP-NATURAL-PSL2-ACTION-PASS`, `GP-THETA11-G-EQUIVARIANT`, and
`GP-MODULI-EQUIVARIANTLY-BIRATIONAL-V14`.

### Negative theorem for the modular action

The sealed `V14` involution fixed locus is a smooth genus-one sextic plus two
points, and `V14^{D12}` is empty.  The all-degree centralizer obstruction on
the smooth projective `V14` compactification proves that the natural modular
action is not `G`-unirational and is not weakly versal.

Exit: `GP-MODULI-NON-G-UNIRATIONAL`.

### Why nothing transfers to the standard Klein action

For the hyperplane-dependent map `chi_Pi:V14 -->> K`,
`g chi_Pi = chi_{gPi} g`.  The irreducible six-dimensional Weil module has no
invariant hyperplane.  Retaining the projective/vector-bundle parameter gives
the Tschinkel--Zhang twisted stable birationality, not an equivariant map or
finite odd-degree correspondence.  Rigidity proves that the transported
modular action and standard regular Klein action are not `G`-birationally
conjugate, even after an automorphism of `G`.  The visible involution mismatch
is elliptic-sextic-plus-points on `V14` versus `E_sigma disjoint union
L_sigma` with a rational fixed line on the standard Klein cubic.

Exit: `GP-MODULAR-ACTION-IS-V14-NOT-KLEIN`.

Not claimed: `GP-BRIDGE-KLEIN-NONUNIRATIONAL`,
`KLEIN-PSL2(11)-NONUNIRATIONAL`, or
`GP-BRIDGE-KLEIN-HEADLINE-POSITIVE`.
<!-- GP-EQUIVARIANT-MODULI-END -->
'''


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--parent-head", required=True)
    parser.add_argument("--audit-base", required=True)
    args = parser.parse_args()

    for value in (args.parent_head, args.audit_base):
        if not re.fullmatch(r"[0-9a-f]{40}", value):
            raise SystemExit("full 40-hex commit required")

    here = Path(__file__).resolve()
    packet = here.parents[1]
    root = here.parents[3]
    notebook = root / "NOTEBOOK.md"

    for path in packet.glob("*.md"):
        text = path.read_text(encoding="utf-8")
        path.write_text(text.replace("AUDIT_BASE_COMMIT", args.audit_base), encoding="utf-8")

    text = notebook.read_text(encoding="utf-8")
    if BEGIN in text:
        text, count = re.subn(
            re.escape(BEGIN) + ".*?" + re.escape(END) + "\n?",
            SECTION,
            text,
            count=1,
            flags=re.S,
        )
        if count != 1:
            raise SystemExit("supplement replacement failed")
    else:
        anchor = "## 2026-08-08--09 finite-target and full-group supplement"
        if anchor not in text:
            raise SystemExit("NOTEBOOK anchor missing")
        text = text.replace(anchor, SECTION + "\n" + anchor, 1)

    text, count = re.subn(
        r"notebook parent head: `([0-9a-f]{7,40})`",
        f"notebook parent head: `{args.parent_head}`",
        text,
        count=1,
    )
    if count != 1:
        raise SystemExit("parent-head line missing")

    notebook.write_text(text, encoding="utf-8")

    required = [
        "GP-NATURAL-PSL2-ACTION-PASS",
        "GP-THETA11-G-EQUIVARIANT",
        "GP-MODULI-EQUIVARIANTLY-BIRATIONAL-V14",
        "GP-MODULI-NON-G-UNIRATIONAL",
        "GP-MODULAR-ACTION-IS-V14-NOT-KLEIN",
    ]
    assert all(exit_name in text for exit_name in required)
    assert all(
        "AUDIT_BASE_COMMIT" not in path.read_text(encoding="utf-8")
        for path in packet.glob("*.md")
    )
    print("NOTEBOOK supplement finalized against", args.audit_base)
    print("notebook parent head set to", args.parent_head)


if __name__ == "__main__":
    main()
