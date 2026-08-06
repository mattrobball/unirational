#!/usr/bin/env python3
"""FIX-U1-FIN7 -- cross-checks of Theorem 5.9 (a), (b), (c) against this
packet's own build of the (m,r) = (1,7) system.  Convention pins.
"""
import fin7_lib as L

r, m = 7, 1
sup = L.supports(r, m)
sup0 = L.supports(r, 0)          # the cone WITHOUT the plane-order condition
names, eqs = L.landing_terms(r, m)

print('(a) lines land on lines, by parity alone')
for i, (coord, line) in enumerate((('x', 'L_s1 = {a=b=u0=0}'),
                                   ('y', 'L_s2 = {a=b=u1=0}'),
                                   ('z', 'L_s3 = {a=b=u2=0}'))):
    van = [k for k in range(5) if all(mo[i] >= 1 for mo in sup[k])]
    print('    on {%s = 0} the slots %s vanish identically -> image in %s : %s'
          % (coord, [L.SLOT_NAMES[k] for k in van], line,
             sorted(van) == sorted([0, 1, 2 + i])))

print('(b) source vertices')
for i, v in enumerate(('[1:0:0]', '[0:1:0]', '[0:0:1]')):
    nz0 = [L.SLOT_NAMES[k] for k in range(5)
           if any(mo[i] == r for mo in sup0[k])]
    nz1 = [L.SLOT_NAMES[k] for k in range(5)
           if any(mo[i] == r for mo in sup[k])]
    print('    vertex %s : slots not vanishing there --  m=0 cone: %s ;'
          '  m>=1 cone: %s' % (v, nz0, nz1))
print('    => at m = 0 the vertex maps to the chi-vertex (pure x^r sits only')
print('       in the matching u-slot); at m >= 1 the monomial x^r is EXACTLY')
print('       what ord_{P_1} >= 1 forbids, so the vertex is a BASE POINT of')
print('       the map.  Theorem 5.9(b) holds on the m = 0 cone; on the')
print('       plane-order->=1 cone the vertex is blown up.')

print('(c) the landing system is empty at x-level 0')
mins = [min(mo[i] for mo, _t in eqs) for i in range(3)]
print('    minimal (x,y,z)-exponents over the 52 equation monomials: %s'
      % (mins,))
print('    => x*y*z divides F(T) identically; the level-0 restriction to each')
print('       {x_i = 0} is automatically zero (L_sigma subset X).  Verified: %s'
      % all(v >= 1 for v in mins))
