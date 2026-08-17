import re, sys, os
P = "/Users/worker/unirational/problems/E-klein-cubic/v14_formalization/V14Formalization"

def transform_entry(text, fam, r, c):
    """Strip per-product theorems/tables; single-decide entryZ_eq. Return body
    (no imports/section/open Matrix header, no trailing end-of-file)."""
    lines = text.split("\n")
    # locate body start: the `namespace` line
    ns = f"V14Formalization.D12Piece{fam}SplitEntry{r}_{c}"
    try:
        i0 = next(i for i,l in enumerate(lines) if l.startswith(f"namespace {ns}"))
    except StopIteration:
        raise RuntimeError(f"namespace not found in {fam}{r}_{c}")
    body = lines[i0:]
    # find cut region: from first `theorem xaMulZ0 :` to `def xaEntryZ`/`def entryZ`
    try:
        cut_a = next(i for i,l in enumerate(body) if l.startswith("theorem xaMulZ0 :"))
    except StopIteration:
        raise RuntimeError(f"xaMulZ0 not found in {fam}{r}_{c}")
    cut_b = next(i for i,l in enumerate(body) if l.startswith("def xaEntryZ") or l.startswith("def entryZ"))
    assert cut_a < cut_b
    body = body[:cut_a] + body[cut_b:]
    out = "\n".join(body)
    # replace entryZ_eq proof with single decide
    out, n = re.subn(
        r"theorem entryZ_eq : entryZ = (scaleSqE0 scale|zeroZ) := by\n(?:  [^\n]*\n)+?  decide\n",
        lambda m: f"theorem entryZ_eq : entryZ = {m.group(1)} := by\n  decide +kernel\n",
        out)
    assert n == 1, f"entryZ_eq not rewritten in {fam}{r}_{c} (n={n})"
    # ensure it ends with the namespace end
    assert out.rstrip().endswith(f"end {ns}"), f"bad tail in {fam}{r}_{c}"
    return out.rstrip() + "\n"

def merge_row(fam, r, write=False):
    data_mod = f"D12Piece{fam}Data"
    entries = []
    for c in range(10):
        path = f"{P}/D12Piece{fam}SplitEntry{r}_{c}.lean"
        entries.append(transform_entry(open(path).read(), fam, r, c))
    row_path = f"{P}/D12Piece{fam}SplitRow{r}.lean"
    row_src = open(row_path).read()
    row_lines = row_src.split("\n")
    # row file: strip its import lines and `noncomputable section` (we emit our own)
    ns_row = f"V14Formalization.D12Piece{fam}SplitRow{r}"
    j0 = next(i for i,l in enumerate(row_lines) if l.startswith(f"namespace {ns_row}"))
    row_body = "\n".join(row_lines[j0:]).rstrip() + "\n"
    header = (f"/- {fam} split identity row {r}: entry certificates inlined. Auto-generated. -/\n"
              f"import V14Formalization.{data_mod}\n"
              f"import V14Formalization.D12CyclotomicVecZ\n\n"
              f"noncomputable section\nopen Matrix\n\n")
    merged = header + "\n\n".join(entries) + "\n\n" + row_body
    if write:
        open(row_path, "w").write(merged)
        for c in range(10):
            os.remove(f"{P}/D12Piece{fam}SplitEntry{r}_{c}.lean")
    return merged

if __name__ == "__main__":
    fam, r = sys.argv[1], int(sys.argv[2])
    mode = sys.argv[3] if len(sys.argv) > 3 else "dry"
    m = merge_row(fam, r, write=(mode == "write"))
    if mode == "dry":
        out = sys.argv[4]
        open(out, "w").write(m)
        print(f"dry: wrote {out} ({len(m.splitlines())} lines)")
