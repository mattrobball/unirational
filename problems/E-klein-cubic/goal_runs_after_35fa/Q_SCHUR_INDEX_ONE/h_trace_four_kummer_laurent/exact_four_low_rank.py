#!/usr/bin/env python3
"""Exhaust rank-one and rank-two collision families for four Kummer terms."""

from __future__ import annotations

from fractions import Fraction
from itertools import combinations
from math import gcd

from screen_four_modular import contributions, four_components
from screen_four_modular import EXPECTED_MOD3_BASES
from exact_four_rank3 import canonical_equation


def primitive(vector):
    divisor = gcd(*(abs(value) for value in vector))
    answer = tuple(value//divisor for value in vector)
    first = next(value for value in answer if value)
    if first < 0:
        answer = tuple(-value for value in answer)
    return answer


def cross(left, right):
    return (
        left[1]*right[2]-left[2]*right[1],
        left[2]*right[0]-left[0]*right[2],
        left[0]*right[1]-left[1]*right[0],
    )


def dot(left, right):
    return sum(a*b for a,b in zip(left,right))


def filtered_records(items, base, modulus=3):
    records = {}
    for i,j in combinations(range(len(items)),2):
        equation = canonical_equation(items[i],items[j])
        if equation is None:
            continue
        direction, delta = equation
        predicted = tuple(
            sum(direction[a]*base[a][k] for a in range(3)) % modulus
            for k in range(4)
        )
        if predicted != tuple(value%modulus for value in delta):
            continue
        records.setdefault(equation,set()).update((i,j))
    return records


def rank_one(records, item_count):
    by_direction = {}
    for (direction,delta), endpoints in records.items():
        unit = primitive(direction)
        scale = next(direction[i]//unit[i] for i in range(3) if unit[i])
        if any(value%scale for value in delta):
            continue
        h = tuple(value//scale for value in delta)
        by_direction.setdefault(unit,{}).setdefault(h,set()).update(endpoints)
    candidates = sum(len(rows) for rows in by_direction.values())
    viable = [
        (direction,h) for direction,rows in by_direction.items()
        for h,endpoints in rows.items() if len(endpoints)==item_count
    ]
    return len(by_direction), candidates, viable


def coordinates(direction, basis):
    b1,b2 = basis
    for i,j in combinations(range(3),2):
        det = b1[i]*b2[j]-b1[j]*b2[i]
        if det:
            a = Fraction(direction[i]*b2[j]-direction[j]*b2[i],det)
            b = Fraction(b1[i]*direction[j]-b1[j]*direction[i],det)
            assert all(a*b1[k]+b*b2[k]==direction[k] for k in range(3))
            return a,b
    raise AssertionError("dependent basis")


def map_key(first,second,basis):
    (d1,y1),(d2,y2)=first,second
    a1,b1=coordinates(d1,basis)
    a2,b2=coordinates(d2,basis)
    det=a1*b2-a2*b1
    if not det:
        return None
    h1=[]
    h2=[]
    for coordinate in range(4):
        h1.append((Fraction(y1[coordinate])*b2-Fraction(y2[coordinate])*b1)/det)
        h2.append((a1*Fraction(y2[coordinate])-a2*Fraction(y1[coordinate]))/det)
    return tuple(h1+h2)


def consistent(equation,basis,key):
    direction,delta=equation
    a,b=coordinates(direction,basis)
    return all(a*key[k]+b*key[4+k]==delta[k] for k in range(4))


def rank_two(records,item_count):
    directions=sorted({direction for direction,_ in records})
    normals={
        primitive(normal)
        for left,right in combinations(directions,2)
        if (normal:=cross(left,right))!=(0,0,0)
    }
    total_keys=0
    viable=[]
    plane_summaries=[]
    equations=list(records)
    for normal in sorted(normals):
        plane=[equation for equation in equations if dot(normal,equation[0])==0]
        plane_directions=sorted({direction for direction,_ in plane})
        basis_pair=next(
            (left,right) for left,right in combinations(plane_directions,2)
            if cross(left,right)!=(0,0,0)
        )
        keys=set()
        for first,second in combinations(plane,2):
            if cross(first[0],second[0])==(0,0,0):
                continue
            key=map_key(first,second,basis_pair)
            assert key is not None
            keys.add(key)
        total_keys+=len(keys)
        local_viable=0
        for key in keys:
            matched=set()
            for equation in plane:
                if consistent(equation,basis_pair,key):
                    matched.update(records[equation])
            if len(matched)==item_count:
                viable.append((normal,basis_pair,key))
                local_viable+=1
        plane_summaries.append((normal,len(plane),len(keys),local_viable))
    return len(normals),total_keys,viable,plane_summaries


def main():
    totals=[0,0,0,0]
    for indices in combinations(range(5),4):
        items=contributions(four_components(indices))
        records=filtered_records(items,EXPECTED_MOD3_BASES[indices])
        directions,rank1_candidates,rank1_viable=rank_one(records,len(items))
        planes,rank2_candidates,rank2_viable,summaries=rank_two(records,len(items))
        print(
            f"QUADRUPLE {indices} FILTERED_EQUATIONS {len(records)} "
            f"RANK1_DIRECTIONS {directions} RANK1_CANDIDATES {rank1_candidates} "
            f"RANK1_VIABLE {len(rank1_viable)} RANK2_PLANES {planes} "
            f"RANK2_CANDIDATES {rank2_candidates} RANK2_VIABLE {len(rank2_viable)}"
        )
        for row in summaries:
            if row[-1]:
                print(f"VIABLE_PLANE_SUMMARY {indices} {row}")
        totals[0]+=rank1_candidates
        totals[1]+=len(rank1_viable)
        totals[2]+=rank2_candidates
        totals[3]+=len(rank2_viable)
    print(
        f"TOTAL_RANK1_CANDIDATES {totals[0]} TOTAL_RANK1_VIABLE {totals[1]} "
        f"TOTAL_RANK2_CANDIDATES {totals[2]} TOTAL_RANK2_VIABLE {totals[3]}"
    )
    assert totals == [605,0,37770,0]
    print("H_TRACE_FOUR_KUMMER_RANK1_RANK2_EXCLUSION_OK")


if __name__=="__main__":
    main()
