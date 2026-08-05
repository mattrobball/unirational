#!/usr/bin/env python3
"""FIX-N2B: write the PAYLOAD_*.txt files."""
import os, sys
import n2b_lib as L
import fullspace as FS
from n2b_lib import ONE, OM, OM2
HERE = os.path.dirname(os.path.abspath(__file__))
TAG = {ONE: '1', OM: 'om', OM2: 'om^2'}

with open(os.path.join(HERE, 'PAYLOAD_blocks.txt'), 'w') as fh:
    fh.write('# FIX-N2B: cell dimensions, C3-eigenblock dimensions, landing\n'
             '# equation counts and the PLANE ORDER of every block parameter.\n'
             '# Conventions: FIX-N2 CELL_TABLE.md section 0.\n'
             '# Parameter names: P* = a\'-block, R* = b\'-block, B* = the free\n'
             '# u_0\'-block (u_1\',u_2\' are lam^-1 sigma-images of it).\n\n')
    fh.write('r  cell dims (m=1)          block dims (lam=1,om,om^2)  eqs  orbit-red\n')
    for r in range(2, 11):
        dims = L.cell_dims(r, 1)
        bs = [L.Block(r, 1, lam) for lam in (ONE, OM, OM2)]
        fh.write('%-2d %-24s %-27s %-4d %d\n'
                 % (r, ','.join(map(str, dims)), ','.join(str(b.n) for b in bs),
                    len(L.equations(bs[0])),
                    len(L.equations(bs[0], orbit_reduce=True))))
    fh.write('\nplane orders of the block parameters\n')
    for r in range(4, 11):
        for lam in (ONE, OM, OM2):
            b = L.Block(r, 1, lam)
            fh.write('r=%-2d lam=%-5s %s\n     %s\n'
                     % (r, TAG[lam], ' '.join('%-4s' % n for n in b.names),
                        ' '.join('%-4d' % q for q in b.param_plane_orders())))
    fh.write('\nNOTE: the plane-order-1 part of every eigenblock is exactly\n'
             '2-dimensional at every r (the two corner coefficients of u_0\').\n')

with open(os.path.join(HERE, 'PAYLOAD_cone_r6.txt'), 'w') as fh:
    fh.write("""# FIX-N2B: the C3-equivariant pointwise landing cone at r = 6, classified.
#
# Engine 1  msolve Groebner + coordinate saturation over F_100057
# Engine 2  exact symbolic classification of the reduced system in char 0
#           (verify_n2b.check_r6_reduced_system)
#
# lam = 1     : cone = {0}                                  (CONE-DIM 0)
# lam = om    : CONE-DIM 1 ; forced zero: P0,P1,R0,R1,B3,B5
# lam = om^2  : CONE-DIM 1 ; forced zero: P0,P1,R0,R1,B3,B5
#   (B3, B5 are THE two plane-order-1 parameters -> no plane-order-1 point)
#
# Reduced system, lam = om^2, with a' = p UVW, b' = 0,
#   B_0 = c0 U^2 + c1 UV + c2 UW + c4 VW  (B_1 = om sigma B_0, B_2 = om^2 sigma^2 B_0):
#
#   E1  c0 c2 c4
#   E2  c0 (c4^2 + c1 c2 + p c0)
#   E3  c0 c1 c4
#   E4  c4 (c1 c2 + c0^2 + p c4)
#   E5  (c4^2 - c1 c2)(c2^2 + c1 c4)          [after p = -c1c2/c4, times c4]
#   E7  c4^3+c2^3+3c1c2c4+c1^3+3c0c1c2+c0^3+6p c1c2+6p c0c4+kp p^3
#
# Solutions (kp != 0,-4 from smoothness (1.2)):
#
#   branch A   c0 = 0, c1 c2 = c4^2, p = -c4,  c1^3 + c2^3 = (2+kp) c4^3
#              == the section-4 family  D_B(yz),  B = c2/c4,  plane order 3
#   branch B   c4 = 0, c1 c2 = c0^2, p = -c0,  c1^3 + c2^3 = (2+kp) c0^3
#              == xyz * D_B(x),                                plane order 2
#   (c0 != 0 != c4 forces c1 = c2 = 0, c0^3 = c4^3 and kp = -4: EXCLUDED)
#
# Six values of B in each branch  ->  12 lines per block; the lam = om block is
# the a' <-> b' mirror with kp replaced by km.
#
# CONSEQUENCE: every point of the r = 6 cone has plane order 2 or 3, never 1.
""")

with open(os.path.join(HERE, 'PAYLOAD_witnesses.txt'), 'w') as fh:
    fh.write("""# FIX-N2B: explicit A4-equivariant landing tuples  G * D_B(X).
#
# D_B(X):  Y = psi X (or Theta X at positive line degree), Z = psi^2 X,
#          a' = -XYZ,  b' = 0,
#          u_0' = X(X^2 + B Y^2 + B^-1 Z^2),
#          u_1' = om   Y(Y^2 + B Z^2 + B^-1 X^2),
#          u_2' = om^2 Z(Z^2 + B X^2 + B^-1 Y^2),      kp = (B^3-1)^2/B^3 .
# Residual C3 scalar lam = om^2 (mirror: a'=0, km, lam = om).
# G runs over the A4-invariants  q = x^2+y^2+z^2 (m=0), xyz (m=2),
#   e_2 = x^2y^2+y^2z^2+z^2x^2 (m=2), Delta = (x^2-y^2)(y^2-z^2)(z^2-x^2) (m=2).
# All entries verified in CHARACTERISTIC ZERO (verify_n2b.check_witnesses):
# landing identity, residual C3 equivariance with lam = om^2, and (m,r).
#
#   G                 X        (m,r)   note
    1                 x        (0,3)   the seed
    1                 yz       (3,6)   V4 packet section 4
    xyz               x        (2,6)   FIX-N2 Corollary E'
    e_2               x        (2,7)   *** NEW *** -- (2,7) is POPULATED
    q*xyz             x        (2,8)
    q                 yz       (3,8)   FIX-N2
    1                 xy^2     (3,9)   FIX-N2 (primitive)
    Delta             x        (2,9)   *** NEW ***
    (xyz)^2           x        (4,9)
    xyz               yz       (5,9)
    q^2*xyz           x        (2,10)  *** NEW ***
#
# THEOREM N2B-3.  (2,r) is POPULATED for every r >= 6:
#   d = r-3 odd  ->  G = q^{(d-3)/2} xyz ;  d even -> G = q^{(d-4)/2} e_2 ;
#   both have ord_{P_i} G = 2 and m(D_B(x)) = 0.
# With FIX-N2's (2,3),(2,4),(2,5) EMPTY this DECIDES THE WHOLE m = 2 ROW.
#
# THEOREM N2B-2.  The same construction works with X having BINARY COEFFICIENTS
# on the triple line (Y = Theta X, Z = Theta^2 X), giving A4-equivariant
# families of every line degree.  Verified for line degrees 1,2,3.
""")
print('payloads written')
