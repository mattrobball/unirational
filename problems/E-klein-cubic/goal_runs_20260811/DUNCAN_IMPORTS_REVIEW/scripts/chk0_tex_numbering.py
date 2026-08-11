"""CHECK 0 -- recompute the theorem numbering of
external_docs/duncan_higher_obstruction_20260805.tex from the source.

The tex preamble (lines 17-33) puts theorem/lemma/proposition/corollary/
conjecture/question/definition/example/remark/note/case on ONE counter, reset
per \\section.  So the number of a labelled environment is
(section index).(count of such environments so far in that section).

This is what makes the earlier draft's numbers ("Thm 3.10", "Prop 3.24",
"Def 6.3", "Lemma 6.4") unusable against the current file.
"""

import re
import sys

TEX = ("/Users/worker/unirational/problems/E-klein-cubic/external_docs/"
       "duncan_higher_obstruction_20260805.tex")

ENVS = {"theorem", "lemma", "proposition", "corollary", "conjecture",
        "question", "definition", "example", "remark", "note", "case"}

EXPECTED = {
    "def:toroidal": "2.1", "thm:toroidal_resolution": "2.2", "cor:cofinal": "2.3",
    "lem:fabulous_basics": "3.1", "def:fabulous": "3.2",
    "rem:meet_vs_contain": "3.3", "rem:fabulous_divisor": "3.4",
    "lem:fabulous_cofinal": "3.5", "lem:fibre_dimension": "3.6",
    "lem:flag": "3.7", "thm:fabulous": "3.8", "prop:rcc": "3.9",
    "rem:toric_criterion": "3.12", "ex:not_a_complex": "3.13",
    "thm:pairs": "4.1", "lem:tree": "4.2", "prop:noncyclic_fabulous": "4.3",
    "lem:number_theory": "4.4", "prop:cyclic_not_fabulous": "4.5",
    "ex:no_converse": "4.8", "prop:converse": "4.9",
    "lem:linear_strata": "4.10", "prop:rcc_total": "4.11",
    "cor:union_of_rc": "4.12", "def:stratified_tower": "4.14",
    "lem:rational_strata_propagate": "4.15", "cor:pn_resolved": "4.16",
    "thm:no_map_to_dp2": "4.18", "lem:strict": "5.1", "lem:game": "5.2",
    "ex:mu5": "5.3",
}


def main():
    lines = open(TEX).read().split("\n")
    sec = 0
    cnt = 0
    found = {}
    print(f"{'number':>7}  {'line':>5}  {'kind':<12} label")
    for idx, line in enumerate(lines, 1):
        if line.startswith("\\section{"):
            sec += 1
            cnt = 0
            print(f"{'--':>7}  {idx:5d}  SECTION {sec}   {line.strip()}")
            continue
        m = re.match(r"\\begin\{(\w+)\}", line.strip())
        if not m or m.group(1) not in ENVS:
            continue
        cnt += 1
        num = f"{sec}.{cnt}"
        lab = ""
        mm = re.search(r"\\label\{([^}]*)\}", line)
        if mm:
            lab = mm.group(1)
        elif idx < len(lines) and lines[idx].strip().startswith("\\label"):
            lab = re.search(r"\\label\{([^}]*)\}", lines[idx]).group(1)
        if lab:
            found[lab] = num
        print(f"{num:>7}  {idx:5d}  {m.group(1):<12} {lab}")

    print()
    bad = []
    for lab, want in EXPECTED.items():
        got = found.get(lab)
        if got != want:
            bad.append((lab, want, got))
    print(f"labels cross-checked against the recorded numbering: {len(EXPECTED)}")
    print(f"mismatches: {len(bad)}")
    for b in bad:
        print("  MISMATCH label=%s recorded=%s computed=%s" % b)
    print("RESULT:", "PASS" if not bad else "FAIL")
    return 0 if not bad else 1


if __name__ == "__main__":
    sys.exit(main())
