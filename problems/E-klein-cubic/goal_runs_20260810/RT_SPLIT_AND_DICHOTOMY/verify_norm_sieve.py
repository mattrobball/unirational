#!/usr/bin/env python3
"""Exact arithmetic audit for the CLEAN CM norm equation."""
from __future__ import annotations
from dataclasses import dataclass
from math import isqrt

@dataclass(frozen=True)
class OK:
    x: int
    y: int
    def __mul__(self, other: "OK") -> "OK":
        return OK(self.x*other.x-3*self.y*other.y,
                  self.x*other.y+self.y*other.x+self.y*other.y)
    def __pow__(self, n: int) -> "OK":
        if n < 0:
            raise ValueError("negative powers")
        out, base = OK(1, 0), self
        while n:
            if n & 1:
                out = out * base
            base = base * base
            n >>= 1
        return out
    def conjugate(self) -> "OK":
        return OK(self.x+self.y, -self.y)
    def norm(self) -> int:
        return self.x*self.x+self.x*self.y+3*self.y*self.y

def representations(n: int) -> list[OK]:
    if n < 0:
        return []
    ans: list[OK] = []
    for y in range(-isqrt((4*n)//11)-1, isqrt((4*n)//11)+2):
        rhs = 4*n-11*y*y
        if rhs < 0:
            continue
        z = isqrt(rhs)
        if z*z != rhs:
            continue
        for signed_z in ({z, -z} if z else {0}):
            if (signed_z-y) % 2 == 0:
                elt = OK((signed_z-y)//2, y)
                assert elt.norm() == n
                ans.append(elt)
    return sorted(set(ans), key=lambda a: (a.x, a.y))

def represented(n: int) -> bool:
    return bool(representations(n))

def main() -> None:
    one, omega, nu = OK(1,0), OK(0,1), OK(-1,1)
    assert omega*omega == OK(-3,1)
    samples = (one, omega, nu, OK(1,1), OK(2,1), OK(3,-1), OK(-5,0))
    for a in samples:
        assert a*a.conjugate() == OK(a.norm(),0)
        for b in samples:
            assert (a*b).norm() == a.norm()*b.norm()
    assert not represented(2)
    assert nu.norm() == 3
    assert OK(1,1).norm() == 5
    assert OK(-5,0).norm() == 25 != 5
    expected = [1,3,4,5,9,11,12,15,16,20,23,25,27,31,33,36,37]
    got = [n for n in range(1,41) if represented(n)]
    assert got == expected
    for u in (nu, OK(1,1), OK(2,1), OK(3,-1)):
        for m in range(10):
            assert (u**m).norm() == u.norm()**m
    print("CM_NORM_FORM=x^2+x*y+3*y^2")
    print("REPRESENTED_THROUGH_40="+",".join(map(str,got)))
    print("DEGREE_2=NOT_REPRESENTED")
    print("DEGREE_3=REPRESENTED_BY_(-1,1)")
    print("DEGREE_5=REPRESENTED_BY_(1,1)")
    print("ELLIPTIC_SCALAR_MINUS5_NORM=25")
    print("CLEAN_ITERATE_NORMS=PASS")
    print("CLASSIFICATION_CONSISTENCY=PASS")

if __name__ == "__main__":
    main()
