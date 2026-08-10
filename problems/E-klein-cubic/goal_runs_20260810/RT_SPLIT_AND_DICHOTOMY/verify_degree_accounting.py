#!/usr/bin/env python3
"""Exact orbit-size/Bezout accounting for Task 3."""
from __future__ import annotations
ORBIT_SIZES=(11,11,12,55,66,660)
CODIMS=(2,3,4)
LIVE_MIN=31

def min_degree(n:int,c:int)->int:
    d=0
    while d**c<n:
        d+=1
    return d

def main()->None:
    expected={2:(4,4,4,8,9,26),3:(3,3,3,4,5,9),4:(2,2,2,3,3,6)}
    print("LIVE_DEGREE_WINDOW=d>=31")
    print("orbit_size,codim,min_d,live_status")
    for c in CODIMS:
        got=tuple(min_degree(n,c) for n in ORBIT_SIZES)
        assert got==expected[c]
        for n,d in zip(ORBIT_SIZES,got):
            assert n<=LIVE_MIN**c
            print(f"{n},{c},{d},SURVIVES_ALL_LIVE_d>=31")
    historical={c:min_degree(660,c)-1 for c in CODIMS}
    assert historical=={2:25,3:8,4:5}
    assert max(historical.values())<LIVE_MIN
    print("FREE_SURFACE_ORBIT_EXCLUDED_ONLY_FOR=d<=25")
    print("FREE_CURVE_ORBIT_EXCLUDED_ONLY_FOR=d<=8")
    print("FREE_ISOLATED_POINT_ORBIT_EXCLUDED_ONLY_FOR=d<=5")
    print("LIVE_CELL_DEATHS=NONE")
    print("DEGREE_ACCOUNTING=PASS")

if __name__=="__main__":
    main()
