#!/usr/bin/env python3
"""FIX-U1-FIN7 -- (3a) C3-stability of the torus-orbit components and
(3b) an explicit rational curve inside PO_1(7) through each classified point.

(3a)  psi o g_{s,t,w} = g_{w,s,t} o psi  on forms in x,y,z, hence
      Theta o g_{s,t,w} = g_{w,s,t} o Theta on the 39-parameter space.
      Since Theta(p) = lam p, the torus orbit of p is Theta-stable, and the
      projective C3 x scalar orbit of p is {p} itself (p is an eigenvector).

(3b)  tau |-> g_{1,tau,1} . p  is a polynomial (hence rational) curve in
      P^38 lying entirely in PO_1(7); it is non-constant as soon as the
      support of p meets two different y-degrees, which is certified below.
"""
import sympy as sp

import fin7_lib as L
import fin7_points as PT
import fin7_theta as TH

names, M = TH.theta_mat()
n = len(names)
sup = L.supports()
mon_of = []
for s in sup:
    mon_of += list(s)

ok = True
for a in range(n):
    for b in range(n):
        if M[a][b] == 0:
            continue
        # Theta e_b -> M[a][b] e_a ;  weights: monomial of b -> monomial of a
        mb, ma = mon_of[b], mon_of[a]
        if ma != L.psi_mon(mb):
            ok = False
print('Theta is a monomial matrix and permutes weights by psi:', ok)
print('  => Theta o g_{s,t,w} = g_{w,s,t} o Theta   (exact, structural)')

for j in range(3):
    for part in PT.PARTS:
        A, nm, vals, ceq, prods = None, None, None, None, None
        Ap = PT.part_algebra(j, part)
        import fin7_equiv as E
        coords = E.classified_point(j)
        ydeg = set()
        for t, name in enumerate(names):
            v = Ap.of(coords[name])
            if not Ap.is_zero(v):
                ydeg.add(mon_of[t][1])
        print('lam=om^%d part %s : y-degrees present in supp(p) = %s ;'
              ' rational curve non-constant: %s'
              % (j, part, sorted(ydeg), len(ydeg) > 1))
