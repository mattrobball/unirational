#!/usr/bin/env python3
"""Independent verifier for the M3 residual-Galois payload.

Unlike the producer, this script enumerates all determinant-one matrices
modulo signs directly, rather than generating the group from two matrices.
"""
from __future__ import annotations

from collections import Counter, deque
from itertools import combinations, product
import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
PAYLOAD = json.loads((HERE / "residual_galois.json").read_text())


def canon(a):
    p = tuple(int(x) % 11 for x in a)
    n = tuple((-x) % 11 for x in p)
    return min(p, n)


def mul(a, b):
    return canon(tuple(
        sum(a[2*i+k] * b[2*k+j] for k in range(2)) % 11
        for i in range(2) for j in range(2)
    ))


def inv(a):
    return canon((a[3], -a[1], -a[2], a[0]))


ONE = canon((1,0,0,1))
S = canon((0,2,5,0))
T = canon((1,2,0,1))


def order(a):
    x = ONE
    for n in range(1,100):
        x = mul(x,a)
        if x == ONE:
            return n
    raise AssertionError


def conjugate(g,x):
    return mul(mul(g,x),inv(g))


def digest(value):
    return hashlib.sha256(json.dumps(value,sort_keys=True,separators=(",",":")).encode()).hexdigest()


def orbit(seed, generators, action):
    out={seed}; q=deque([seed])
    while q:
        x=q.popleft()
        for g in generators:
            y=action(g,x)
            if y not in out:
                out.add(y); q.append(y)
    return out


def all_orbits(points, generators, action):
    unseen=set(points); answer=[]
    while unseen:
        seed=min(unseen)
        o=orbit(seed,generators,action)
        unseen-=o; answer.append(sorted(o))
    return answer


def main():
    # Direct determinant-one enumeration and quotient by central signs.
    group={canon(a) for a in product(range(11),repeat=4) if (a[0]*a[3]-a[1]*a[2])%11==1}
    group=sorted(group)
    assert len(group)==PAYLOAD["group_order"]==660
    hist=Counter(order(g) for g in group)
    assert {str(k):v for k,v in sorted(hist.items())}==PAYLOAD["element_order_histogram"]

    involutions=sorted(g for g in group if order(g)==2)
    assert len(involutions)==55
    index={g:i for i,g in enumerate(involutions)}
    t=involutions[0]
    centralizer=sorted(g for g in group if mul(g,t)==mul(t,g))
    assert len(centralizer)==12
    assert Counter(order(g) for g in centralizer)==Counter({1:1,2:7,3:2,6:2})

    perms={
        "S":[index[conjugate(S,x)] for x in involutions],
        "T":[index[conjugate(T,x)] for x in involutions],
    }
    assert digest(perms)==PAYLOAD["line_cover"]["permutation_digest"]

    # Stabilizer subdegrees, reconstructed directly from all twelve elements.
    unseen=set(range(55)); sub=[]
    while unseen:
        seed=min(unseen)
        o=orbit(seed,centralizer,lambda h,i:index[conjugate(h,involutions[i])])
        unseen-=o; sub.append(len(o))
    assert sorted(sub)==PAYLOAD["line_cover"]["subdegrees"]==[1,3,3,6,6,6,6,12,12]

    pair_orbits=all_orbits(
        combinations(range(55),2),
        ("S","T"),
        lambda name,pair:tuple(sorted((perms[name][pair[0]],perms[name][pair[1]]))),
    )
    assert sorted(len(o) for o in pair_orbits)==PAYLOAD["pair_orbit_sizes"]
    for actual, stored in zip(pair_orbits,PAYLOAD["pair_orbits"]):
        assert list(actual[0])==stored["seed"]
        assert len(actual)==stored["size"]
        assert digest(actual)==stored["digest"]

    triple_orbits=all_orbits(
        combinations(range(55),3),
        ("S","T"),
        lambda name,triple:tuple(sorted(perms[name][i] for i in triple)),
    )
    triple_hist={str(k):v for k,v in sorted(Counter(len(o) for o in triple_orbits).items())}
    assert triple_hist==PAYLOAD["triple_orbit_histogram"]

    # Independent simplicity check: every union of conjugacy classes containing
    # the identity is tested for subgroup closure.  There are only eight classes.
    classes=all_orbits(group,group,lambda g,x:conjugate(g,x))
    assert len(classes)==8
    id_class=next(i for i,c in enumerate(classes) if ONE in c)
    nontrivial=[]
    for mask in range(1<<len(classes)):
        if not (mask>>id_class)&1:
            continue
        candidate=set().union(*(set(classes[i]) for i in range(len(classes)) if (mask>>i)&1))
        if len(candidate) in (1,660):
            continue
        closed=True
        for a in candidate:
            if inv(a) not in candidate:
                closed=False; break
            for b in candidate:
                if mul(a,b) not in candidate:
                    closed=False; break
            if not closed: break
        if closed:
            nontrivial.append(len(candidate))
    assert not nontrivial
    assert PAYLOAD["index_four"]["exists"] is False
    assert 660>24

    print("PASS direct 660-element PSL_2(F_11) enumeration")
    print("PASS D12 stabilizer, subdegrees, pair and triple orbit data")
    print("PASS simplicity and no transitive degree-four action")
    print("M3_RESIDUAL_GALOIS_INDEPENDENT_VERIFY_OK")


if __name__=="__main__":
    main()
