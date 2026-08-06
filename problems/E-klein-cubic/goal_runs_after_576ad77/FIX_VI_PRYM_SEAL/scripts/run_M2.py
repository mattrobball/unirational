"""Runs the Macaulay2 geometry script and records its verdict as a logged CHECK.

Independent engine: M2 1.26 over toField(QQ[y]/(y^2-33)), Groebner-based
(saturation, elimination, Jacobian minors) -- no shared code with the sympy /
K-field routes.
"""
import os, re, subprocess, sys, time

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RES = os.path.join(HERE, "results")
LOG = os.path.join(RES, "checks.log")
M2S = os.path.join(HERE, "scripts", "m2_geometry.m2")

t0 = time.time()
p = subprocess.run(["M2", "--script", M2S], capture_output=True, text=True, cwd=HERE)
out = p.stdout + p.stderr
open(os.path.join(RES, "C_m2.txt"), "w").write(out)


def field(label):
    m = re.search(re.escape(label) + r"\s*:\s*(\S+)", out)
    return m.group(1) if m else None


want = {
    "saturated Jacobian ideal == unit ideal": "true",
    "conic saturated Jacobian == unit ideal": "true",
    "non-transverse locus empty": "true",
    "  => 6 distinct transverse points": "true",
    "generator divisible by claimed cube-form": "true",
}
got = {k: field(k) for k in want}
deg = field("degree (expect 6)")
dim = field("dim (affine cone, expect 1)")
rest = field("F0 - ((kp+4)a^3+(km+4)b^3) mod conic")
# M2's elimination generator must be exactly bb^3 + 21/256 y + 283/256  (rho closed form)
rho_ok = "bb^3+21/256y+283/256" in out.replace(" ", "")

ok = (p.returncode == 0 and "M2_DONE" in out
      and all(got[k] == v for k, v in want.items())
      and deg == "6" and dim == "1" and rest == "0" and rho_ok)

line = f"CHECK m2_independent_geometry {'PASS' if ok else 'FAIL'}"
detail = (f"M2: smooth cubic + smooth conic, deg(E∩K)={deg}, transverse, "
          f"restriction identity = {rest}, elimination gives b^3 = -(283+21*sqrt33)/256")
print(line + "   | " + detail)
with open(LOG, "a") as f:
    f.write(line + "\n")
print(f"[M2] {time.time()-t0:.1f}s")
sys.exit(0 if ok else 1)
