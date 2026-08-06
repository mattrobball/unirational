#!/usr/bin/env python3
"""FIX-P1 Stage 1 -- the profile sieve.

Pure arithmetic over the SEALED constraints of program FIX.  No CAS needed;
every constraint below is a citation, and the script only enumerates.

Constraints used (all sealed / director-replayed; see STATUS.md sec.1):

  (C1) H0-1 parity          : m odd, minus-half leading.
  (C2) cone bound           : r >= ceil(3m/2) = (3m+1)/2   (Note II Lemma 2.1)
                              equivalently  m <= (2r-1)/3.
  (C3) H1-1(a) degree bound : n := d-r >= 6e, e := r-m ; i.e. d >= 7r-6m.
  (C4) cell emptiness (all line degrees):
         (1,2),(1,3),(1,4),(1,5)                       [FIX-N2 / V4 Thm 2.12]
         (m,(3m+1)/2) for every odd m>=3               [Note II Lemma 2.4
             chained from (1,2): (m,r) empty with r<=2m  ==>  (m+2,r+3) empty;
             the odd-m bottom cells form exactly such a chain, and
             (3m+1)/2 <= 2m for all m>=1.]
  (C5) sweep                : Lambda != 0 as a section (H0-2 / P3).
  (C6) evasion arithmetic   : the leading-layer equalizer is EVADED only if
         lambda_{2e} = 0 at the three D12-points, i.e. ord_p(Lambda) >= 2e+1
         at each; the three points are one free C3-orbit, so
             n = deg Lambda >= 3*(2e+1) = 6e+3 .
         Otherwise lambda_{2e} != 0 and the order-0 equalizer is NONVACUOUS.
  (C7) (3,6) D_B dictionary : the only classified positive-line-degree family
         is the (3,6) family D_B(f.yz) (Thm N2B-2 + "yz is the unique degree-2
         chi_x form"); its leading datum has components g1^3, B g1 g2^2,
         g2^3, B^-1 g1^2 g2 with g1 = Theta f, g2 = Theta^2 f, so
             n = 3 * deg(f)          ==>   n = 0 (mod 3),
             ord_p(Lambda) = 3*min(ord_p g1, ord_p g2)  (a multiple of 3).
         Hence: non-evasive members are killed at every n (FIX-H1-EQ-M3-EMPTY,
         B^3 pinned off the trace curve), and evasive members need
             ord >= 2e+1 = 7  ==>  ord >= 9  ==>  n >= 27 = 6e+9,
         reproducing Correction H1-C's bound exactly.

Outputs (payloads/):
  SIEVE_TABLE.json  machine-readable
  SIEVE_TABLE.txt   human-readable
"""
import json
import os
import sys
from fractions import Fraction

HERE = os.path.dirname(os.path.abspath(__file__))
PAY = os.path.join(HERE, "payloads")

D_MIN, D_MAX = 1, 60

# ---------------------------------------------------------------- cell status

EMPTY_CELLS_EXPLICIT = {(1, 2), (1, 3), (1, 4), (1, 5), (3, 5)}
# (3,5) is both an explicit FIX-N2 theorem and the first Lemma-2.4 propagate.

POPULATED_LD0 = {(3, 6), (3, 8), (3, 9), (5, 9), (7, 12), (4, 9),
                 (2, 7), (2, 8), (2, 9), (2, 10)}


def cone_min_r(m):
    """(3m+1)/2 for m odd, 3m/2 for m even."""
    return (3 * m + 1) // 2 if m % 2 else (3 * m) // 2


def bottom_cell(m):
    return (m, cone_min_r(m))


def is_empty_all_line_degrees(m, r):
    """True iff the (m,r) cell is PROVED empty for every line degree."""
    if (m, r) in EMPTY_CELLS_EXPLICIT:
        return True, "FIX-N2 / V4 Thm 2.12 (explicit)"
    # Lemma 2.4 chain on the odd-m bottom cells, base (1,2).
    if m % 2 == 1 and m >= 3 and r == cone_min_r(m):
        return True, "Note II Lemma 2.4 chain from (1,2)"
    if m % 2 == 0 and r == cone_min_r(m):
        return True, "FIX-N2 even-m bottom cell"
    return False, ""


def cell_status(m, r):
    emp, why = is_empty_all_line_degrees(m, r)
    if emp:
        return "EMPTY_ALL_LD", why
    if (m, r) in POPULATED_LD0:
        return "POPULATED", "witness at line degree 0 (FIX-N2/N2b)"
    return "OPEN", "unclassified cell"


# ------------------------------------------------------- per-(d,m,r) analysis

def analyse(d, m, r):
    e = r - m
    n = d - r
    row = {
        "d": d, "m": m, "r": r, "e": e, "n": n,
        "parity_ok": m % 2 == 1,
        "cone_ok": r >= cone_min_r(m),
        "degbound_ok": d >= 7 * r - 6 * m,
    }
    if not (row["parity_ok"] and row["cone_ok"] and row["degbound_ok"]):
        row["admissible"] = False
        row["cell"] = None
        return row
    st, why = cell_status(m, r)
    row["cell"] = st
    row["cell_reason"] = why
    row["admissible"] = (st != "EMPTY_ALL_LD")
    # forced D12 vanishing order window
    row["ord_forced_min"] = 2 * e                     # H1-1(a)
    row["ord_max"] = n // 3                           # Lambda != 0, 3 points
    row["evasion_available"] = n >= 6 * e + 3         # (C6)
    row["equalizer_nonvacuous"] = not row["evasion_available"]
    # the classified D_B channel
    if (m, r) == (3, 6):
        row["DB_channel"] = True
        row["DB_line_degree_ok"] = (n % 3 == 0)
        row["DB_deg_f"] = (n // 3) if n % 3 == 0 else None
        row["DB_evasion_ok"] = (n % 3 == 0) and (n >= 6 * e + 9)
        if not row["DB_line_degree_ok"]:
            row["DB_verdict"] = "NO MEMBER (n not divisible by 3)"
        elif row["DB_evasion_ok"]:
            row["DB_verdict"] = "ALIVE (n3-divisible evasion sub-family)"
        else:
            row["DB_verdict"] = "DEAD (FIX-H1-EQ-M3-EMPTY, non-evasive)"
    else:
        row["DB_channel"] = False
        row["DB_verdict"] = "n/a (no classified positive-line-degree family)"
    return row


def profiles_for(d):
    out = []
    r = 1
    while 3 * r + 2 <= d + 6:          # generous; filtered below
        for m in range(1, 2 * r):
            if m % 2 == 0:
                continue
            if r < cone_min_r(m):
                continue
            if d < 7 * r - 6 * m:
                continue
            if d - r < 0:
                continue
            out.append(analyse(d, m, r))
        r += 1
    return out


def main():
    os.makedirs(PAY, exist_ok=True)
    table = {}
    for d in range(D_MIN, D_MAX + 1):
        rows = profiles_for(d)
        table[d] = rows

    # --- derived summaries
    def surviving(d):
        return [x for x in table[d] if x["admissible"]]

    def classified_alive(d):
        return [x for x in surviving(d)
                if x["DB_channel"] and x["DB_verdict"].startswith("ALIVE")]

    def evasion_alive(d):
        return [x for x in surviving(d) if x["evasion_available"]]

    first_admissible = min((d for d in table if surviving(d)), default=None)
    first_evasion = min((d for d in table if evasion_alive(d)), default=None)
    first_classified = min((d for d in table if classified_alive(d)),
                           default=None)
    # first d whose surviving set contains a profile OTHER than (3,6)
    first_other = None
    for d in sorted(table):
        oth = [x for x in surviving(d) if (x["m"], x["r"]) != (3, 6)]
        if oth:
            first_other = d
            break

    summary = {
        "constraints": ["H0-1 parity (m odd)",
                        "Note II Lemma 2.1 cone bound r >= (3m+1)/2",
                        "Theorem H1-1(a) d >= 7r-6m",
                        "cell emptiness (FIX-N2, V4 Thm 2.12, Lemma 2.4 chain)",
                        "H0-2 sweep (Lambda != 0)",
                        "evasion arithmetic n >= 6e+3",
                        "(3,6) D_B dictionary n = 3 deg f, evasion n >= 6e+9"],
        "corollary_r_bound": "d >= 3r+2, i.e. r <= (d-2)/3 "
                             "(from 7r-6m with m <= (2r-1)/3)",
        "first_d_with_any_admissible_profile": first_admissible,
        "first_d_with_evasion_arithmetically_available": first_evasion,
        "first_d_with_a_LIVE_CLASSIFIED_shape": first_classified,
        "first_d_admitting_a_profile_other_than_(3,6)": first_other,
        "d25": {
            "surviving_profiles": [[x["m"], x["r"], x["n"]]
                                   for x in surviving(25)],
            "evasion_available": bool(evasion_alive(25)),
            "classified_alive": bool(classified_alive(25)),
        },
    }

    with open(os.path.join(PAY, "SIEVE_TABLE.json"), "w") as fh:
        json.dump({"summary": summary,
                   "table": {str(k): v for k, v in table.items()}},
                  fh, indent=1, sort_keys=True)

    lines = []
    lines.append("FIX-P1  STAGE 1  --  THE PROFILE SIEVE")
    lines.append("=" * 78)
    lines.append("")
    lines.append("Corollary of (C2)+(C3):  d >= 3r+2, i.e. r <= (d-2)/3.")
    lines.append("")
    lines.append("Legend: e=r-m, n=d-r (the line degree of the leading datum");
    lines.append("        Lambda in H^0(ell_V,O(n)) (x) V_m, Lambda != 0).")
    lines.append("        ord window = [2e, floor(n/3)] : H1-1(a) forces the")
    lines.append("        lower end, Lambda != 0 the upper.")
    lines.append("        EVASION = lambda_{2e} may vanish  <=>  n >= 6e+3.")
    lines.append("")
    hdr = ("  d | (m, r) |  e |  n | cell        | ord window | evasion |"
           " D_B channel")
    lines.append(hdr)
    lines.append("-" * len(hdr))
    for d in range(20, 51):
        rows = surviving(d)
        if not rows:
            lines.append("%3d | %s" % (d, "-- no admissible profile --"))
            continue
        for x in rows:
            lines.append(
                "%3d | (%d, %d) | %2d | %2d | %-11s | [%2d, %2d]   | %-7s | %s"
                % (d, x["m"], x["r"], x["e"], x["n"], x["cell"],
                   x["ord_forced_min"], x["ord_max"],
                   "YES" if x["evasion_available"] else "no",
                   x["DB_verdict"]))
    lines.append("")
    lines.append("SUMMARY")
    lines.append("-" * 78)
    for k, v in summary.items():
        if k in ("constraints",):
            continue
        lines.append("  %-46s %s" % (k, v))
    lines.append("")
    lines.append("Excluded-cell audit at small d (why nothing below (3,6)):")
    for (m, r) in sorted(EMPTY_CELLS_EXPLICIT |
                         {bottom_cell(m) for m in (3, 5, 7, 9)}):
        emp, why = is_empty_all_line_degrees(m, r)
        lines.append("  (%d,%d)  min d = 7r-6m = %3d   EMPTY=%s  [%s]"
                     % (m, r, 7 * r - 6 * m, emp, why))
    with open(os.path.join(PAY, "SIEVE_TABLE.txt"), "w") as fh:
        fh.write("\n".join(lines) + "\n")

    print("d=24 surviving:", [(x["m"], x["r"], x["n"]) for x in surviving(24)])
    print("d=25 surviving:", [(x["m"], x["r"], x["n"]) for x in surviving(25)])
    print("d=26 surviving:", [(x["m"], x["r"], x["n"]) for x in surviving(26)])
    print("first evasion d :", first_evasion)
    print("first classified-alive d :", first_classified)
    print("first non-(3,6) d :", first_other)
    print("wrote", os.path.join(PAY, "SIEVE_TABLE.json"))


if __name__ == "__main__":
    sys.exit(main())
