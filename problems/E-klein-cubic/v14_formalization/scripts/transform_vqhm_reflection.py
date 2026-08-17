"""Transform VQ_*/HM_* files: reflection proofs for products and sums.
Writes candidates into scratch/candidate/ (originals untouched)."""
import re, os, sys
from fractions import Fraction
from math import lcm

P = "/Users/worker/unirational/problems/E-klein-cubic/v14_formalization/V14Formalization"
S = os.environ["S"]
OUT = os.path.join(S, "candidate")
os.makedirs(OUT, exist_ok=True)

TERM = re.compile(
    r'C \((\((?P<num1>-?\d+) / (?P<den1>\d+) : ℚ\)|\(?(?P<num2>-?\d+)\)?)\)'
    r'(?: \* X(?: \^ (?P<pow>\d+))?)?')

def parse_poly(rhs):
    rhs = rhs.strip()
    if rhs == "(0 : Polynomial ℚ)":
        return {}
    coeffs = {}
    for part in rhs.split(" + "):
        m = TERM.fullmatch(part.strip())
        if not m:
            return None
        num = m.group("num1") or m.group("num2")
        den = m.group("den1") or "1"
        k = int(m.group("pow")) if m.group("pow") else (1 if "* X" in part else 0)
        coeffs[k] = Fraction(int(num), int(den))
    return coeffs

def bridge_for(name, rhs):
    c = parse_poly(rhs)
    assert c is not None, f"unparsed local def {name}: {rhs[:80]}"
    if not c:
        return f"theorem z_{name} : {name} = interpQ 1 [] := by\n  rw [interpQ_nil]; rfl\n"
    d = 1
    for v in c.values(): d = lcm(d, v.denominator)
    n = max(c) + 1
    lst = "[" + ", ".join(str(int(c.get(k, Fraction(0)) * d)) for k in range(n)) + "]"
    return (f"theorem z_{name} : {name} = interpQ {d} {lst} := by\n"
            f"  refine Polynomial.funext fun r => ?_\n"
            f"  simp [{name}, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,\n"
            f"    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]\n"
            f"  try ring\n")

IDENT = re.compile(r'\b(spanV_(?:re|im)_\d+_\d+|Qplus_(?:re|im)_\d+_\d+|minorQ_(?:re|im)_\d+_\d+|H_(?:re|im)_\d+_\d+|Phi11|VQ_(?:pre|pim|qre|qim)_\d+_\d+(?:_\d+)?|HM_\d+_\d+_[A-Z]_(?:pre|pim)|HM_\d+_\d+_(?:qre|qim))\b')

def reflect_proof(statement):
    atoms = []
    for m in IDENT.finditer(statement):
        a = m.group(1)
        if a not in atoms:
            atoms.append(a)
    rws = ", ".join(f"z_{a}" for a in atoms)
    return (f"  rw [{rws}]\n"
            f"  simp (disch := decide) only [interp_mul, interp_add_gen, interp_sub_gen, Nat.reduceMul]\n"
            f"  apply interp_eq\n"
            f"  · decide\n"
            f"  · decide\n"
            f"  · decide\n")

TARGET = re.compile(r'^(VQ_(pre|pim)_eq_\d+_\d+_\d+|VQ_sum_poly_(re|im)_\d+_\d+|HM_\d+_\d+_[A-Z]_(pre|pim)_eq|HM_\d+_\d+_red(im)?)$')

def replace_proofs(src):
    lines = src.split("\n")
    out = []
    i = 0
    n = 0
    while i < len(lines):
        l = lines[i]
        m = re.match(r'theorem (\w+) :$', l)
        if m and TARGET.match(m.group(1)):
            # statement lines until one ends with ':= by'
            out.append(l); i += 1
            stmt = []
            while i < len(lines):
                out.append(lines[i])
                stmt.append(lines[i])
                if lines[i].rstrip().endswith(":= by"):
                    i += 1
                    break
                i += 1
            # skip old proof: indented or blank lines, stop before next decl
            while i < len(lines) and (lines[i].startswith("  ") or lines[i] == ""):
                # stop if the blank is followed by a non-indented decl
                if lines[i] == "" and i + 1 < len(lines) and not lines[i+1].startswith("  "):
                    break
                i += 1
            out.append(reflect_proof("\n".join(stmt)).rstrip("\n"))
            n += 1
        else:
            out.append(l); i += 1
    return "\n".join(out), n

def transform(path, out_path):
    src = open(path).read()
    # 1) insert local bridges after each local def
    def add_bridge(m):
        name, rhs = m.group(1), m.group(2)
        return m.group(0) + "\n" + bridge_for(name, rhs)
    src = re.sub(r'^def ((?:VQ|HM)_\w+) : Polynomial ℚ := (.+)$',
                 add_bridge, src, flags=re.M)
    # 2) replace target theorem proofs
    out, n_replaced = replace_proofs(src)
    # 3) make reflection names visible
    out = out.replace(
        "open D12PolynomialData",
        "open D12PolynomialData\nopen V14Formalization.D12PolyZReflection", 1)
    # 4) add import
    out = out.replace(
        "import V14Formalization.D12SigmaPlusSegreEval",
        "import V14Formalization.D12SigmaPlusSegreEval\nimport V14Formalization.D12PolyZReflectionBridges", 1)
    open(out_path, "w").write(out)
    return n_replaced

if __name__ == "__main__":
    which = sys.argv[1] if len(sys.argv) > 1 else "one"
    if which == "one":
        n = transform(f"{P}/D12SigmaPlusSegreVQ_0_0.lean", f"{OUT}/D12SigmaPlusSegreVQ_0_0.lean")
        print(f"VQ_0_0: {n} proofs replaced")
        n = transform(f"{P}/D12SigmaPlusSegreHM_0_0.lean", f"{OUT}/D12SigmaPlusSegreHM_0_0.lean")
        print(f"HM_0_0: {n} proofs replaced")
    else:
        import glob
        tot = 0
        for f in sorted(glob.glob(f"{P}/D12SigmaPlusSegreVQ_*_*.lean") + glob.glob(f"{P}/D12SigmaPlusSegreHM_*_*.lean")):
            b = os.path.basename(f)
            tot += transform(f, f"{OUT}/{b}")
        print(f"total proofs replaced: {tot}")
