"""Parse msolve -g 1 leading-ideal output. Own parser."""
import os
import re

_PURE = re.compile(r"^t(\d+)(?:\^(\d+))?$")


def parse_leading_ideal(path):
    if not os.path.isfile(path) or os.path.getsize(path) == 0:
        return {"ok": False, "reason": "missing_or_empty", "path": path}
    text = open(path).read()
    if "[-1]:" in text and "length of basis" not in text:
        return {"ok": False, "reason": "no_solution_marker", "path": path}
    if "[" not in text or "]" not in text:
        return {"ok": False, "reason": "no_basis_block", "path": path}
    header = {}
    for line in text.splitlines():
        if "field characteristic:" in line:
            header["char"] = int(line.split(":")[1].strip())
        elif "variable order:" in line:
            vs = line.split(":", 1)[1].strip()
            header["vars"] = [v.strip() for v in vs.split(",") if v.strip()]
        elif "monomial order:" in line:
            header["order"] = line.split(":", 1)[1].strip()
        elif "length of basis:" in line:
            header["length"] = int(line.split(":")[1].strip().split()[0])
    body = text.split("[", 1)[1].rsplit("]", 1)[0]
    mons = []
    for raw in body.split("\n"):
        s = raw.strip().strip(",").strip()
        if s:
            mons.append(s)
    vars_ = header.get("vars") or []
    n = len(vars_)
    if n == 0:
        ids = []
        for mon in mons:
            ids.extend(int(x) for x in re.findall(r"t(\d+)", mon))
        n = max(ids) if ids else 0
        vars_ = ["t%d" % i for i in range(1, n + 1)]
        header["vars"] = vars_
    pure = {}
    for mon in mons:
        mm = _PURE.fullmatch(mon)
        if not mm:
            continue
        i = int(mm.group(1))
        e = int(mm.group(2) or 1)
        pure[i] = min(e, pure.get(i, 10 ** 9))
    missing = [i for i in range(1, n + 1) if i not in pure]
    # A homogeneous ideal is zero-dimensional iff in(I) contains a pure
    # power of every variable (equivalently: every variable's radical).
    return {
        "ok": True,
        "path": path,
        "nvars": n,
        "nlead": len(mons),
        "header": header,
        "pure_powers": {str(i): int(e) for i, e in sorted(pure.items())},
        "missing_pure": missing,
        "zero_dimensional": len(missing) == 0 and n > 0,
        "criterion": (
            "in(I) contains a pure power of each variable iff I is "
            "zero-dimensional (any monomial order); homogeneous => V={0}"
        ),
    }
