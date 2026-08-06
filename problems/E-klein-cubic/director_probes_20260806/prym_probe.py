import sympy as sp

a,b,x,t,w = sp.symbols('a b x t w')
kp = (13 + 3*sp.sqrt(33))/16
km = (13 - 3*sp.sqrt(33))/16
# checks on the sealed relations
assert sp.simplify(kp+km - sp.Rational(13,8)) == 0 and sp.simplify(kp*km + sp.Rational(1,2)) == 0
assert sp.simplify((kp+4)*(km+4) - 22) == 0
print("trace relations + (kp+4)(km+4)=22: OK")

# conic x^2 = 4(a^2-ab+b^2), affine a=1; parameterize from (b,x)=(0,2): x = 2+t b
bt = sp.simplify(-4*(t+1)/((t-2)*(t+2)))
xt = sp.simplify(2 + t*bt)
assert sp.simplify(xt**2 - 4*(1 - bt + bt**2)) == 0
print("conic parameterization: OK")

# F0 restricted: kp + km*b^3 + (1+b)x^2 == kp + km b^3 + 4(1+b^3)?? verify the identity (1+b)(1-b+b^2)=1+b^3
F0 = kp + km*bt**3 + (1+bt)*xt**2
F0s = sp.simplify(F0 - ((kp+4) + (km+4)*bt**3))
print("F0|_Kc = (kp+4) + (km+4) b^3 identity:", F0s == 0)

# the six branch t-values: (kp+4) + (km+4) b(t)^3 = 0
num = sp.together(sp.simplify((kp+4) + (km+4)*bt**3))
sextic = sp.numer(num)
sextic = sp.expand(sextic)
P = sp.Poly(sextic, t)
print("branch polynomial degree in t:", P.degree())
roots = sp.nroots(P, n=30)
print("six branch t-values (numeric):")
for r in roots: print("  ", sp.N(r, 12))

# the conic involution x -> -x in the t-coordinate: solve for tau(t) with b(tau)=b(t), x(tau)=-x(t)
tau = sp.symbols('tau')
sols = sp.solve([sp.Eq(bt.subs(t,tau), bt), sp.Eq(xt.subs(t,tau), -xt)], tau, dict=True)
print("involution tau(t):", sols)
