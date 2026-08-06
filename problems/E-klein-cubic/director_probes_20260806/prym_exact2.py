import sympy as sp
t, s, u, v = sp.symbols('t s u v')
kp = (13 + 3*sp.sqrt(33))/16; km = (13 - 3*sp.sqrt(33))/16
bt = -4*(t+1)/((t-2)*(t+2))
P6 = sp.Poly(sp.expand(sp.numer(sp.together((kp+4) + (km+4)*bt**3))), t)
r3 = sp.sqrt(-3); t1, t2 = -1 + r3, -1 - r3
ts = sp.simplify((t2*s - t1)/(s - 1))
num = sp.expand(sp.numer(sp.together(P6.as_expr().subs(t, ts))))
Ps = sp.Poly(num, s)
even = [sp.simplify(c) for c in Ps.all_coeffs()[0::2]]
cu = sum(c*u**(3-i) for i, c in enumerate(even))
cu = sp.expand(cu/sp.LC(sp.Poly(cu, u)))
# E-: y^2 = u * c(u), a quartic with branch points {0, roots of c}
q = sp.Poly(sp.expand(u*cu), u)
# j of y^2 = quartic via classical invariants I2 (Eisenstein) route:
a4,a3,a2,a1,a0 = [q.coeff_monomial(u**k) for k in (4,3,2,1,0)]
# binary quartic invariants: S = a0a4 - a1a3/4 + a2^2/12 ; T = det-like
S = sp.simplify(a0*a4 - a1*a3/4 + a2**2/12)
T = sp.simplify(a0*a2*a4/6 - a0*a3**2/16 - a1**2*a4/16 + a1*a2*a3/48 - a2**3/216)
jm = sp.simplify(1728*S**3/(S**3 - 27*T**2))
print("j(E-) exact:", sp.simplify(sp.radsimp(jm)))
