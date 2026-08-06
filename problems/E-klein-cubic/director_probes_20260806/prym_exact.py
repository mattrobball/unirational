import sympy as sp
t, s, u = sp.symbols('t s u')
kp = (13 + 3*sp.sqrt(33))/16; km = (13 - 3*sp.sqrt(33))/16
bt = -4*(t+1)/((t-2)*(t+2))
P6 = sp.Poly(sp.expand(sp.numer(sp.together((kp+4) + (km+4)*bt**3))), t)
r3 = sp.sqrt(-3); t1, t2 = -1 + r3, -1 - r3
# t as a function of s: invert s = (t-t1)/(t-t2)
ts = sp.simplify((t2*s - t1)/(s - 1))
sex_s = sp.together(P6.as_expr().subs(t, ts))
num = sp.expand(sp.numer(sex_s))
Ps = sp.Poly(num, s)
coeffs = Ps.all_coeffs()
odd = [sp.simplify(c) for c in coeffs[1::2]]
print("odd s-coefficients all zero:", all(c == 0 for c in odd))
# the cubic in u = s^2
even = [sp.simplify(c) for c in coeffs[0::2]]
cu = sum(c*u**(3-i) for i, c in enumerate(even))
cu = sp.simplify(cu/sp.LC(sp.Poly(cu, u)))
print("monic cubic c(u):", sp.nsimplify(sp.expand(cu)))
# j-invariant of w^2 = c(u): from the cubic's invariants
P3 = sp.Poly(sp.expand(cu), u)
a2, a1, a0 = [P3.coeff_monomial(u**2), P3.coeff_monomial(u), P3.coeff_monomial(1)]
# depressed: g2, g3 via standard formulas for y^2 = u^3 + a2 u^2 + a1 u + a0
g2 = sp.simplify(sp.Rational(4,3)*a2**2 - 4*a1)
g3 = sp.simplify(sp.Rational(-8,27)*a2**3 + sp.Rational(4,3)*a1*a2 - 4*a0)
jE = sp.simplify(1728*g2**3/(g2**3 - 27*g3**2))
print("j(E+) exact:", sp.simplify(sp.radsimp(jE)))
