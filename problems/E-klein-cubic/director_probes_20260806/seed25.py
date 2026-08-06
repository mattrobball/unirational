import itertools, random
random.seed(11)
p = 397
def Fv(x):  # Klein cubic
    return sum(x[i]*x[i]*x[(i+1)%5] for i in range(5)) % p
def gFv(x):  # gradient: dF/dx_i = 2 x_i x_{i+1} + x_{i-1}^2
    return [(2*x[i]*x[(i+1)%5] + x[(i-1)%5]**2) % p for i in range(5)]
def J6v(x):
    s = 0
    for i in range(5):
        s += x[i]**4*x[(i+2)%5]*x[(i+3)%5] + x[i]**3*x[(i+1)%5]*x[(i+4)%5]**2 - x[i]**2*x[(i+1)%5]*x[(i+2)%5]**2*x[(i+3)%5]
    return s % p
def gJ6v(x):  # numeric gradient via finite differences won't work mod p; do exact partials
    g = []
    for k in range(5):
        s = 0
        for i in range(5):
            # d/dx_k of each cyclic term
            e = [0]*5; e[i] += 4; e[(i+2)%5] += 1; e[(i+3)%5] += 1
            if e[k]:
                ee = e[:]; c = ee[k]; ee[k] -= 1
                s += c * prod_pow(x, ee)
            e = [0]*5; e[i] += 3; e[(i+1)%5] += 1; e[(i+4)%5] += 2
            if e[k]:
                ee = e[:]; c = ee[k]; ee[k] -= 1
                s += c * prod_pow(x, ee)
            e = [0]*5; e[i] += 2; e[(i+1)%5] += 1; e[(i+2)%5] += 2; e[(i+3)%5] += 1
            if e[k]:
                ee = e[:]; c = ee[k]; ee[k] -= 1
                s -= c * prod_pow(x, ee)
        g.append(s % p)
    return g
def prod_pow(x, e):
    r = 1
    for xi, ei in zip(x, e):
        r = r * pow(xi, ei, p) % p
    return r
def P5(al, be, x):  # x-side polar-5: al*F*gradF + be*gradJ6
    f = Fv(x); gf = gFv(x); gj = gJ6v(x)
    return [(al*f*gf[i] + be*gj[i]) % p for i in range(5)]
# dual side: same formulas in y-coordinates (F-check, J6-check have the same shape)
def cubic_roots_gd(u, v, x0samples):
    # for given u,v lists per sample: F(g*u + d*v) = 0 as cubic in (g:d): return set of (g:d) roots mod p (projective)
    # F(g u + d v) = sum (g u_i + d v_i)^2 (g u_{i+1} + d v_{i+1})
    # expand coefficients c3 g^3 + c2 g^2 d + c1 g d^2 + c0 d^3
    roots = None
    for (u_, v_) in x0samples:
        c3 = Fv(u_); c0 = Fv(v_)
        c2 = sum((2*u_[i]*v_[i]*u_[(i+1)%5] + u_[i]*u_[i]*v_[(i+1)%5]) for i in range(5)) % p
        c1 = sum((2*u_[i]*v_[i]*v_[(i+1)%5] + v_[i]*v_[i]*u_[(i+1)%5]) for i in range(5)) % p
        rs = set()
        # d = 1: cubic in g; plus g = 1, d = 0 case
        for g in range(p):
            if (c3*g**3 + c2*g**2 + c1*g + c0) % p == 0:
                rs.add((g, 1))
        if c3 % p == 0:
            rs.add((1, 0))
        roots = rs if roots is None else (roots & rs)
        if not roots:
            return set()
    return roots
hits = []
X0 = [[random.randrange(p) for _ in range(5)] for _ in range(4)]
for albe in [(1, b) for b in range(p)] + [(0, 1)]:
    al, be = albe
    samples = []
    ok = True
    for x0 in X0:
        y0 = P5(al, be, x0)
        if all(c == 0 for c in y0):
            ok = False; break
        u = [Fv(y0)*g % p for g in gFv(y0)]
        v = gJ6v(y0)
        samples.append((u, v))
    if not ok:
        continue
    r = cubic_roots_gd(None, None, samples)
    if r:
        hits.append((albe, sorted(r)))
print("composition-surface landing hits:", hits if hits else "NONE — the 5x5 composition surface contains no seed (4 random probe points, p=397)")
