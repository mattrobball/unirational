#!/usr/bin/env python3
"""Independent reconstruction and two-order exact replay for degree eight."""
from __future__ import annotations
import hashlib,json,re,struct,subprocess,tempfile
from itertools import product
from pathlib import Path

HERE=Path(__file__).resolve().parent
P=331;W=(1,9,4,3,5)

def basis():
    return tuple(e for e in product(range(9),repeat=5) if sum(e)==8 and sum(a*w for a,w in zip(e,W))%11==1)

def translate(e,k):return tuple(e[(j-k)%5] for j in range(5))

def expand(character):
    B=basis();coordinates=[]
    for i in range(5):coordinates.append([(translate(e,i),j,pow(64,character*i,P)) for j,e in enumerate(B)])
    result={}
    for i in range(5):
      for ea,a,sa in coordinates[i]:
       for eb,b,sb in coordinates[i]:
        for ec,c,sc in coordinates[(i+1)%5]:
         source=tuple(ea[j]+eb[j]+ec[j] for j in range(5));term=tuple(sorted((a,b,c)))
         p=result.setdefault(source,{});p[term]=(p.get(term,0)+sa*sb*sc)%P
    return {s:{t:a for t,a in p.items() if a} for s,p in result.items() if any(p.values())}

def term_hash(eqs):
    h=hashlib.sha256()
    for source in sorted(eqs):h.update((str(source)+":"+str(sorted(eqs[source]))+'\n').encode())
    return h.hexdigest()

def encode(eqs):
    raw=bytearray(struct.pack('<II',len(basis()),len(eqs)))
    for p in eqs.values():
      raw.extend(struct.pack('<I',len(p)))
      for term in p:
       lo=hi=0
       for i in set(term):
        if i<64:lo|=1<<i
        else:hi|=1<<(i-64)
       raw.extend(struct.pack('<QQ',lo,hi))
    return bytes(raw)

def run(executable,instance,order):
    cmd=[str(executable),str(instance)]+([] if order=='forward' else ['reverse'])
    p=subprocess.run(cmd,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,check=True)
    print(p.stdout,end='')
    m=re.search(r'^RESULT (NO_STOPPING_SUPPORT|FOUND_STOPPING_SUPPORT) states=(\d+)$',p.stdout,re.M)
    assert m
    return {'result':m.group(1),'states':int(m.group(2))}

def main():
    data=json.loads((HERE/'metadata.json').read_text())
    assert data['schema']=='klein-f55-degree8-singleton-instance-v1'
    assert data['prime']==331 and data['primitive_fifth_root']==64 and pow(64,5,331)==1
    assert len(basis())==data['coefficient_dimension']==45
    equations={k:expand(k) for k in range(5)}
    hashes={str(k):term_hash(e) for k,e in equations.items()}
    assert hashes==data['term_support_hashes_by_character']
    assert len(set(hashes.values()))==1
    assert len(equations[0])==data['equation_count']==1845
    assert sum(map(len,equations[0].values()))==data['coefficient_term_count']==232875
    raw=encode(equations[0]);installed=(HERE/'degree8.instance').read_bytes()
    assert raw==installed
    assert hashlib.sha256(raw).hexdigest()==data['instance_sha256']
    with tempfile.TemporaryDirectory(prefix='f55_d8_verify_') as td:
      executable=Path(td)/'delete_supports'
      subprocess.run(['c++','-O3','-std=c++17',str(HERE/'delete_supports.cpp'),'-o',str(executable)],check=True)
      forward=run(executable,HERE/'degree8.instance','forward')
      reverse=run(executable,HERE/'degree8.instance','reverse')
    assert forward==data['expected_deletion_results']['forward']
    assert reverse==data['expected_deletion_results']['reverse']
    print('PASS independent all-character degree-eight landing expansion')
    print('PASS exact forward deletion tree: 746332 states, no stopping support')
    print('PASS exact reverse deletion tree: 142634 states, no stopping support')
    print('F55_DEGREE8_SINGLETON_CERTIFICATE_INDEPENDENT_REPLAY_OK')
if __name__=='__main__':main()
