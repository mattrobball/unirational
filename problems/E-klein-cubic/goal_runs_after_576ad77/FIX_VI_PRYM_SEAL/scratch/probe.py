"""Numeric reconnaissance only. Not a check; not cited."""
import mpmath as mp
mp.mp.dps = 60

r33 = mp.sqrt(33)
kp = (13 + 3*r33)/16
km = (13 - 3*r33)/16
Kp, Km = kp+4, km+4
print("kp+km", kp+km, "kpkm", kp*km, "(k+4)prod", Kp*Km)

# P6(t) = Kp*(t^2-4)^3 - 64*Km*(t+1)^3
import mpmath
coeffs_t = [Kp, 0, -12*Kp, -64*Km, 48*Kp - 192*Km, -192*Km, -64*Kp - 64*Km]
# expand check: (t^2-4)^3 = t^6 -12t^4 +48t^2 -64 ; (t+1)^3 = t^3+3t^2+3t+1
c = [Kp, mp.mpf(0), -12*Kp, mp.mpf(0), 48*Kp, mp.mpf(0), -64*Kp]
c[3] -= 64*Km*1
c[4] -= 64*Km*3
c[5] -= 64*Km*3
c[6] -= 64*Km*1
print("P6 coeffs (t^6..t^0):", [mp.nstr(x, 12) for x in c])

roots = mp.polyroots(c, maxsteps=200, extraprec=400)
print("roots:", [mp.nstr(r, 15) for r in roots])

t1 = -1 + mp.sqrt(-3)
t2 = -1 - mp.sqrt(-3)
# s = (t-t1)/(t-t2)
S = [(r - t1)/(r - t2) for r in roots]
print("s-images:", [mp.nstr(x, 15) for x in S])
print("s^2:", [mp.nstr(x**2, 15) for x in S])

# --- j-invariants, numeric recon ---
us = sorted(set(), key=str)
uu = [x**2 for x in S]
# dedupe to 3 values
U = []
for z in uu:
    if not any(abs(z-w) < mp.mpf('1e-30') for w in U):
        U.append(z)
print("distinct u:", len(U))

def j_from_lambda(lam):
    return 256*(lam**2-lam+1)**3/(lam**2*(lam-1)**2)

def j_from_4pts(p):
    # p = list of 4 branch points (mp complex or mp.inf marker None for infinity)
    a,b,c_,d = p
    if a is None:  # infinity first
        lam = (c_-b)/(d-b)*1
    else:
        pass
    return None

def lam_of(pts):
    # cross ratio (p1,p2;p3,p4) = ((p1-p3)(p2-p4))/((p2-p3)(p1-p4)), None = infinity
    p1,p2,p3,p4 = pts
    def f(x,y):
        if x is None: return mp.mpf(1)
        if y is None: return mp.mpf(1)
        return x-y
    num = f(p1,p3)*f(p2,p4); den = f(p2,p3)*f(p1,p4)
    return num/den

# E+ : branch {u1,u2,u3, inf}
lam_p = lam_of([U[0],U[1],U[2],None])
print("j(E+) =", mp.nstr(j_from_lambda(lam_p), 30))
# E- : branch {0,u1,u2,u3}
lam_m = lam_of([mp.mpf(0),U[0],U[1],U[2]])
print("j(E-) =", mp.nstr(j_from_lambda(lam_m), 30))
