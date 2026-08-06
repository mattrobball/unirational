from sympy.combinatorics import PermutationGroup, Permutation
from itertools import product
# PSL(2,11) on P^1(F11), 12 points 0..10, inf=11
p = 11
def M(a,b,c,d):
    def f(x):
        if x == 11:
            return 11 if c % p == 0 else (a * pow(c, p-2, p)) % p
        num, den = (a*x+b) % p, (c*x+d) % p
        return 11 if den == 0 else (num * pow(den, p-2, p)) % p
    return Permutation([f(x) for x in range(12)])
S = M(1,1,0,1); T = M(0,-1,1,0)
G = PermutationGroup([S, T]); assert G.order() == 660, G.order()
def find_triple(H, o1, o2, o3, tries=None):
    els = list(H.elements)
    A = [g for g in els if g.order() == o1]; B = [g for g in els if g.order() == o2]
    for a in A:
        for b in B:
            c = (a*b)**-1
            if c.order() == o3 and PermutationGroup([a, b]).order() == H.order():
                return True
    return False
print("G (2,3,11) generating triple:", find_triple(G, 2, 3, 11))
A5 = PermutationGroup([Permutation(4)(0,1,2), Permutation(0,1,2,3,4)]); assert A5.order() == 60
print("A5 (3,3,5) generating triple:", find_triple(A5, 3, 3, 5))
# F55 inside G: normalizer of Sylow-11
a11 = [g for g in G.elements if g.order() == 11][0]
F55 = PermutationGroup([g for g in G.elements if PermutationGroup([a11]).is_normal(PermutationGroup([a11, g])) and g.order() in (5, 11)][:8] or [a11])
# simpler: build F55 = <a11, b5> with b5 normalizing
b5 = next(g for g in G.elements if g.order() == 5 and (g*a11*g**-1) in PermutationGroup([a11]).elements)
F55 = PermutationGroup([a11, b5]); print("F55 order:", F55.order())
print("F55 (5,5,5) generating triple:", find_triple(F55, 5, 5, 5))
print("F55 (5,5,11) generating triple:", find_triple(F55, 5, 5, 11))
