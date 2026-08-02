#!/usr/bin/env python3
"""Produce the complete degree-eight F55 coefficient-support instance."""
from __future__ import annotations
import hashlib,json,struct
from pathlib import Path

HERE=Path(__file__).resolve().parent
P=331
WEIGHTS=(1,9,4,3,5)

def comps(total,n):
    if n==1:
        yield (total,);return
    for a in range(total+1):
        for tail in comps(total-a,n-1):yield (a,)+tail

def shift(e,k):
    out=[0]*5
    for i,a in enumerate(e):out[(i+k)%5]=a
    return tuple(out)

def basis():
    return tuple(e for e in comps(8,5) if sum(a*w for a,w in zip(e,WEIGHTS))%11==1)

def equations(character):
    B=basis();root=64;scales=[pow(root,character*i,P) for i in range(5)];eqs={}
    for i in range(5):
        qi=[shift(e,i) for e in B];qn=[shift(e,i+1) for e in B]
        scalar=scales[i]*scales[i]*scales[(i+1)%5]%P
        for a,ea in enumerate(qi):
            for b,eb in enumerate(qi):
                for c,ec in enumerate(qn):
                    src=tuple(x+y+z for x,y,z in zip(ea,eb,ec));term=tuple(sorted((a,b,c)))
                    p=eqs.setdefault(src,{});p[term]=(p.get(term,0)+scalar)%P
    return {s:{t:a for t,a in p.items() if a} for s,p in eqs.items() if any(p.values())}

def support_hash(eqs):
    h=hashlib.sha256()
    for source in sorted(eqs):h.update((str(source)+":"+str(sorted(eqs[source]))+"\n").encode())
    return h.hexdigest()

def instance_bytes(eqs):
    B=basis();out=bytearray(struct.pack('<II',len(B),len(eqs)))
    for p in eqs.values():
        out.extend(struct.pack('<I',len(p)))
        for term in p:
            lo=hi=0
            for i in set(term):
                if i<64:lo|=1<<i
                else:hi|=1<<(i-64)
            out.extend(struct.pack('<QQ',lo,hi))
    return bytes(out)

def main():
    all_eq={k:equations(k) for k in range(5)};hashes={k:support_hash(e) for k,e in all_eq.items()}
    assert len(set(hashes.values()))==1
    raw=instance_bytes(all_eq[0]);(HERE/'degree8.instance').write_bytes(raw)
    data={
      'schema':'klein-f55-degree8-singleton-instance-v1','prime':P,'primitive_fifth_root':64,
      'weights':list(WEIGHTS),'degree':8,'coefficient_dimension':len(basis()),
      'equation_count':len(all_eq[0]),'coefficient_term_count':sum(map(len,all_eq[0].values())),
      'term_support_hashes_by_character':hashes,'instance_sha256':hashlib.sha256(raw).hexdigest(),
      'expected_deletion_results':{
        'forward':{'states':746332,'result':'NO_STOPPING_SUPPORT'},
        'reverse':{'states':142634,'result':'NO_STOPPING_SUPPORT'}},
      'scope':['complete degree-eight coefficient-support exclusion','all five projective characters','not an all-degree theorem']}
    (HERE/'metadata.json').write_text(json.dumps(data,indent=2,sort_keys=True)+'\n')
    print('WROTE degree8.instance',len(raw),'bytes',data['instance_sha256'])
    print('D8 variables',len(basis()),'equations',len(all_eq[0]),'terms',data['coefficient_term_count'])
    print('F55_DEGREE8_INSTANCE_OK')
if __name__=='__main__':main()
