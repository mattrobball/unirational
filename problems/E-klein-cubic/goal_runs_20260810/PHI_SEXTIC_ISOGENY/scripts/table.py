#!/usr/bin/env python3
"""Collate results/model_<p>.json into results/evidence_table.txt."""
import json, os
from fractions import Fraction
HERE = os.path.dirname(os.path.abspath(__file__)); OUT = os.path.join(HERE, '..')
PR = [23,67,89,199,331,353,397,419,463,617,661,683,727]
lines = ["prime   #C(F_p)  a_p(C)  #E(F_p)  a_p(E)   j(C)  j(E)  8192/11 mod p   S3-match  equiv ok/bad  isolated-pts"]
rows = []
for p in PR:
    m = json.load(open(f"{OUT}/results/model_{p}.json"))
    c, t, iso = m["counts"], m.get("torsion", {}), m.get("isolated_sigma_points", {})
    jm = (8192 * pow(11, p-2, p)) % p
    isod = "-" if not iso else ("orbit{2}, rho fixes both, tau swaps" if
           (iso.get("rho_fixes_both") and iso.get("tau_swaps") and not iso.get("tau_fixes_both")) else "ANOMALY")
    lines.append(f"{p:5d}  {c['nC']:7d} {c['aC']:7d}  {c['nE']:7d} {c['aE']:7d}  {m['j_C_sigma']:>5} {m['j_E_sigma']:>5}  "
                 f"{jm:>13}   {str(t.get('equivariant_match','-')):>8}  "
                 f"{t.get('equiv_tests_ok','-')}/{t.get('equiv_tests_bad','-')}  {isod}")
    rows.append((p, c, m, jm, t, iso))
lines.append("")
lines.append(f"all #C == #E                : {all(r[1]['nC'] == r[1]['nE'] for r in rows)}")
lines.append(f"all j(C) == j(E) == 8192/11 : {all(int(r[2]['j_C_sigma']) == int(r[2]['j_E_sigma']) == r[3] for r in rows)}")
lines.append(f"all S3 structures match     : {all(r[4].get('equivariant_match') is True for r in rows if r[4].get('equivariant_match') is not None)}")
lines.append(f"all pointwise tests clean   : {all(r[4].get('equiv_tests_bad', 0) == 0 for r in rows)}")
mk = json.load(open(f"{OUT}/results/model_K.json"))
lines.append(f"exact over K                : j(C_sigma) = {mk['j_C_sigma_rational']}, j(E_sigma) = {mk['j_E_sigma_rational']}")
txt = "\n".join(lines)
open(f"{OUT}/results/evidence_table.txt", "w").write(txt + "\n")
print(txt)
