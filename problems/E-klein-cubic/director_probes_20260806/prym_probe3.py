import sympy as sp
t, s, u = sp.symbols('t s u')
kp = (13 + 3*sp.sqrt(33))/16; km = (13 - 3*sp.sqrt(33))/16
bt = -4*(t+1)/((t-2)*(t+2))
sextic = sp.expand(sp.numer(sp.together((kp+4) + (km+4)*bt**3)))
P6 = sp.Poly(sextic, t)
r3 = sp.sqrt(-3); t1, t2 = -1 + r3, -1 - r3
sof = (t - t1)/(t - t2)
roots_t = sp.nroots(P6, n=50)
roots_s = [sp.N(sof.subs(t, r), 50) for r in roots_t]
# u-values: squares, deduplicated into 3
us = []
for r in roots_s:
    u_val = sp.expand(r**2)
    if not any(abs(complex(u_val - v)) < 1e-30 for v in us):
        us.append(u_val)
print("number of distinct u:", len(us))
u1, u2, u3 = us
def jinv_from_cubic_roots(e1, e2, e3):
    lam = (e3 - e1)/(e2 - e1)
    return 256*(lam**2 - lam + 1)**3/(lam**2*(lam - 1)**2)
# E+ : w^2 = (u-u1)(u-u2)(u-u3);  E- : w^2 = u(u-u1)(u-u2)(u-u3) -> 4 branch pts {0,u1,u2,u3}: lambda-based j too
jplus = sp.N(jinv_from_cubic_roots(u1, u2, u3), 40)
# E-: genus-1 with 4 branch points 0,u1,u2,u3: cross-ratio
lam_m = sp.N((u3 - 0)/(u2 - 0) * (u2 - u1)/(u3 - u1), 50)
jminus = sp.N(256*(lam_m**2 - lam_m + 1)**3/(lam_m**2*(lam_m - 1)**2), 40)
print("j(E+) =", jplus)
print("j(E-) =", jminus)
for name, j in (("j+", jplus), ("j-", jminus)):
    jr = sp.nsimplify(j, [sp.sqrt(33)], rational=False, tolerance=1e-25)
    print(name, "recognized:", jr, "->", sp.simplify(jr) if jr is not None else None)
    print(name, "vs 8192/11:", abs(complex(j - sp.Rational(8192,11))) < 1e-20, "; vs -4096/11:", abs(complex(j + sp.Rational(4096,11))) < 1e-20)
