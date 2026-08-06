import sympy as sp
t, s, u = sp.symbols('t s u')
kp = (13 + 3*sp.sqrt(33))/16; km = (13 - 3*sp.sqrt(33))/16
bt = -4*(t+1)/((t-2)*(t+2))
sextic = sp.expand(sp.numer(sp.together(sp.simplify((kp+4) + (km+4)*bt**3))))
P6 = sp.Poly(sextic, t)
# conjugate tau: fixed points t = -1 +- sqrt(-3); s = (t - t1)/(t - t2) sends tau to s -> -s? verify.
r3 = sp.sqrt(-3)
t1, t2 = -1 + r3, -1 - r3
sof = (t - t1)/(t - t2)
tau_t = (-t - 4)/(t + 1)
s_of_tau = sp.simplify(sof.subs(t, tau_t))
print("s(tau(t)) + s(t) == 0 ?", sp.simplify(s_of_tau + sof) == 0, "; ratio:", sp.simplify(s_of_tau/sof))
# express the sextic's roots in s, expect symmetric under s -> -s (or s -> c/s etc.)
roots_t = sp.nroots(P6, n=40)
roots_s = [complex(sp.N(sof.subs(t, r), 40)) for r in roots_t]
print("roots in s (should pair as +-):")
for r in sorted(roots_s, key=lambda z: (round(abs(z),8), z.real)): print("  ", r)
