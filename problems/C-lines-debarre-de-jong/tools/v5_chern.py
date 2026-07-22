#!/usr/bin/env python3
"""Exact Chern-number check for the quintic del Pezzo fivefold V_5.

The calculation takes place on G = Gr(2,5).  If x,y are the Chern roots of
S^*, then H=x+y and integration of a degree-six symmetric polynomial f is
the coefficient of x^4 y^3 in (x-y)f.
"""

import sympy as sp


x, y, t = sp.symbols("x y t")
H = x + y


def exp3(z):
    """exp(t*z), truncated after cohomological degree three."""
    return sum((t * z) ** i / sp.factorial(i) for i in range(4))


# In K(G), T_G = S^* tensor (5-S), while T_{P^9}|_G = 10 O(H)-O.
ch_normal = sp.expand(
    10 * exp3(H)
    - 1
    - (5 * (exp3(x) + exp3(y)) - 2 - exp3(x - y) - exp3(y - x))
)
ch1 = ch_normal.coeff(t, 1)
ch2 = ch_normal.coeff(t, 2)
ch3 = ch_normal.coeff(t, 3)

c1 = sp.expand(ch1)
c2 = sp.expand((c1**2 - 2 * ch2) / 2)
c3 = sp.expand(2 * ch3 - c1**3 / 3 + c1 * c2)

assert sp.expand(c1 - 5 * H) == 0
assert sp.expand(c2 - (9 * x**2 + 17 * x * y + 9 * y**2)) == 0
assert sp.expand(c3 - 5 * H**3) == 0

# For V_5=G cap P^8, the conormal sequence in P^9 gives
# 0 -> N^*_{G/P^9}(9)|_{V_5} -> E -> O_{V_5}(8) -> 0.
c3_twisted_conormal = sp.expand(
    729 * H**3 - 81 * H**2 * c1 + 9 * H * c2 - c3
)
integrand = sp.expand(8 * H**3 * c3_twisted_conormal)
answer = sp.expand((x - y) * integrand).coeff(x, 4).coeff(y, 3)

assert answer == 15856
print(f"integral_V5_c4_conormal9_times_H={answer}")
