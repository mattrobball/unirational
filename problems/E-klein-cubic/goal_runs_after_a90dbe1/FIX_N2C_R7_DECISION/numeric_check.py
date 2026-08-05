#!/usr/bin/env python3
"""FIX-N2C: independent NUMERICAL confirmation of the witness (mpmath, 40 dps).

Plugs floating-point values of om, kp+ = (13+3 sqrt 33)/16, c and P1 into the
witness of `witness.py` and evaluates the RAW Klein normal form at random
complex (x,y,z).  Uses A1(U,V,W) = A0(V,W,U), A2(U,V,W) = A0(W,U,V).
"""
import mpmath as mp
mp.mp.dps = 40


def run(check=None):
    def ck(name, cond, extra=''):
        if check:
            check(name, cond, extra)
        else:
            print('%-58s %s %s' % (name, 'OK ' if cond else 'FAIL', extra))
        return cond

    om = mp.mpc(-1, 0)/2 + mp.sqrt(-3)/2
    kp = (13 + 3*mp.sqrt(33))/16
    om2 = om**2
    kap = kp + 2
    dl = 2*om + 1
    cs = mp.polyroots([1, 0, -3, -kap], maxsteps=300, extraprec=300)
    ps = mp.polyroots([27, -24*om*kap, 0, 32*kap], maxsteps=300, extraprec=300)
    Bs = mp.polyroots([1, 0, 0, -(kp+2), 0, 0, 1], maxsteps=300, extraprec=300)
    # the c-roots are exactly  B + 1/B  over the six D_B parameters
    cB = [b + 1/b for b in Bs]
    matched = all(min(abs(c - t) for t in cB) < mp.mpf('1e-25') for c in cs)
    ck('  numeric: c-roots are  B + 1/B  with (B^3-1)^2/B^3 = kp', matched)

    worst = mp.mpf(0)
    mp.rand()
    for c in cs:
        for P1 in ps:
            P0 = mp.mpf(1)
            B2 = dl*c
            B5 = om + (om+2)/6*B2*P1
            V = dict(P0=P0, P1=P1, B2=B2, B5=B5,
                     R0=om*B5-om2*P0, R1=-om*P1,
                     B0=-om2*B5-(om2-1)*P0, B1=-B5,
                     B3=-2*om*B5-(2*om+4)*P0, B4=-B2,
                     B6=om*B5-(om2-1)*P0-(om2+2)*P1,
                     B7=om*B5-(om2-1)*P0-(om-1)*P1,
                     B8=om2*B5+(om2-1)*P0)

            def A0(u, v, w):
                return (V['B0']*u**2*v + V['B1']*u**2*w + V['B2']*u*v**2
                        + V['B3']*u*v*w + V['B4']*u*w**2 + V['B5']*v**3
                        + V['B6']*v**2*w + V['B7']*v*w**2 + V['B8']*w**3)

            def Q(u, v, w):
                return (V['P0']*(u**2+om2*v**2+om*w**2)
                        + V['P1']*(u*v+om2*v*w+om*u*w))

            def Sf(u, v, w):
                return (V['R0']*(u**2+om*v**2+om2*w**2)
                        + V['R1']*(u*v+om*v*w+om2*u*w))

            for _ in range(5):
                X = mp.mpc(mp.rand(), mp.rand())
                Y = mp.mpc(mp.rand(), mp.rand())
                Z = mp.mpc(mp.rand(), mp.rand())
                u, v, w = X**2, Y**2, Z**2
                a = X*Y*Z*Q(u, v, w)
                b = X*Y*Z*Sf(u, v, w)
                u0 = X*A0(u, v, w)
                u1 = Y*A0(v, w, u)
                u2 = Z*A0(w, u, v)
                F = (kp*a**3 + (mp.mpf(13)/8 - kp)*b**3
                     + a*(u0**2 + om*u1**2 + om2*u2**2)
                     + b*(u0**2 + om2*u1**2 + om*u2**2) + u0*u1*u2)
                scale = max(abs(a)**3, abs(u0*u1*u2), mp.mpf(1))
                worst = max(worst, abs(F)/scale)
    ck('  numeric: |F(T)|/scale over 9 points x 5 random points',
       worst < mp.mpf('1e-25'), 'max = %s' % mp.nstr(worst, 5))
    return worst


if __name__ == '__main__':
    run()
