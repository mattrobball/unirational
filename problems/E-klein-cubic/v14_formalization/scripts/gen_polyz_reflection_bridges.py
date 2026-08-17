"""Generate bridge modules + transformed VQ/HM files (offline, into scratch)."""
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
    """Parse a C-X polynomial RHS into {degree: Fraction}. Return None if not parseable."""
    rhs = rhs.strip()
    if rhs == "(0 : Polynomial ℚ)":
        return {}
    coeffs = {}
    pos = 0
    for part in rhs.split(" + "):
        m = TERM.fullmatch(part.strip())
        if not m:
            return None
        num = m.group("num1") or m.group("num2")
        den = m.group("den1") or "1"
        k = int(m.group("pow")) if m.group("pow") else (1 if "* X" in part else 0)
        coeffs[k] = Fraction(int(num), int(den))
    return coeffs

def denom(coeffs):
    d = 1
    for c in coeffs.values(): d = lcm(d, c.denominator)
    return d

def numlist(coeffs, d):
    n = (max(coeffs) + 1) if coeffs else 0
    return [int(coeffs.get(k, Fraction(0)) * d) for k in range(n)]

def lean_list(zs):
    return "[" + ", ".join(str(z) for z in zs) + "]"

DEF_RE = re.compile(r'^def (\w+) : Polynomial ℚ := (.+)$', re.M)

def harvest(path):
    """name -> (den, numlist) for all C-X polynomial defs in a file."""
    out = {}
    for m in DEF_RE.finditer(open(path).read()):
        name, rhs = m.group(1), m.group(2)
        c = parse_poly(rhs)
        if c is None:
            print(f"  skip (unparsed): {name} in {os.path.basename(path)}")
            continue
        d = denom(c)
        out[name] = (d, numlist(c, d))
    return out

BRIDGE = """theorem z_{name} : {name} = interpQ {den} {lst} := by
  refine Polynomial.funext fun r => ?_
  simp [{name}, interpQ, toPolyZ, Polynomial.eval_add, Polynomial.eval_mul,
    Polynomial.eval_C, Polynomial.eval_X, Polynomial.eval_pow]
  ring
"""
BRIDGE0 = """theorem z_{name} : {name} = interpQ 1 [] := by
  rw [interpQ_nil]; rfl
"""

def bridge(name, den, lst):
    if not lst:
        return BRIDGE0.format(name=name)
    return BRIDGE.format(name=name, den=den, lst=lean_list(lst))

# ---- harvest inputs ----
tables = {}
for mod in ["D12SigmaPlusSegreSpanV", "D12SigmaPlusSegreQplus", "D12SigmaPlusSegreMinorQ"]:
    tables.update(harvest(f"{P}/{mod}.lean"))
# H_re/H_im live in D12SigmaPlusSegreCore
core = harvest(f"{P}/D12SigmaPlusSegreCore.lean")
hdefs = {k: v for k, v in core.items() if k.startswith(("H_re_", "H_im_"))}
tables.update(hdefs)
print(f"input polys harvested: {len(tables)} (H: {len(hdefs)})")

# ---- emit bridge modules ----
HEADER = """/- Auto-generated integer-reflection bridges. DO NOT HAND-EDIT. -/
import V14Formalization.D12PolyZReflection
import V14Formalization.{src}

noncomputable section
open Polynomial
namespace V14Formalization.D12SigmaPlusSegreCore
open V14Formalization.D12PolyZReflection

"""
groups = {
    "D12SigmaPlusSegreSpanVZ": ("D12SigmaPlusSegreSpanV", [n for n in tables if n.startswith("spanV_")]),
    "D12SigmaPlusSegreQplusZ": ("D12SigmaPlusSegreQplus", [n for n in tables if n.startswith("Qplus_re") or n.startswith("Qplus_im")]),
    "D12SigmaPlusSegreMinorQZ": ("D12SigmaPlusSegreMinorQ", [n for n in tables if n.startswith("minorQ_re") or n.startswith("minorQ_im")]),
    "D12SigmaPlusSegreApplyHZ": ("D12SigmaPlusSegreCore", list(hdefs)),
}
for modname, (src, names) in groups.items():
    txt = HEADER.format(src=src)
    for n in sorted(names):
        d, lst = tables[n]
        txt += bridge(n, d, lst) + "\n"
    txt += "end V14Formalization.D12SigmaPlusSegreCore\n"
    open(f"{OUT}/{modname}.lean", "w").write(txt)
    print(f"wrote {modname}: {len(names)} bridges")
