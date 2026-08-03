#!/usr/bin/env python3
"""Shared exact finite-field Schur/Weil representation core for M3."""
from __future__ import annotations

from collections import deque
from dataclasses import dataclass
import hashlib
import json

import numpy as np
import sympy as sp
F2 = tuple[int, int, int, int]


def fmul(a: F2, b: F2) -> F2:
    return tuple(
        sum(a[2*i+k] * b[2*k+j] for k in range(2)) % 11
        for i in range(2) for j in range(2)
    )  # type: ignore[return-value]


def fcanon(a) -> F2:
    pos=tuple(int(x)%11 for x in a)
    neg=tuple((-x)%11 for x in pos)
    return min(pos,neg)  # type: ignore[return-value]


def finv(a: F2) -> F2:
    return fcanon((a[3],-a[1],-a[2],a[0]))


FONE=fcanon((1,0,0,1))
FS=fcanon((0,2,5,0))
FT=fcanon((1,2,0,1))


def abstract_words() -> dict[F2,str]:
    words={FONE:""}; queue=deque([FONE])
    while queue:
        a=queue.popleft()
        for b,l in ((FS,"S"),(FT,"T")):
            c=fcanon(fmul(a,b))
            if c not in words:
                words[c]=words[a]+l; queue.append(c)
    assert len(words)==660
    return words


def forder(a: F2) -> int:
    x=FONE
    for n in range(1,100):
        x=fcanon(fmul(x,a))
        if x==FONE:return n
    raise AssertionError


def fconj(g: F2,x: F2) -> F2:
    return fcanon(fmul(fmul(g,x),finv(g)))


def mm(a,b,p):
    return (a@b)%p


def mpow(a,n,p):
    out=np.eye(a.shape[0],dtype=int)%p
    while n:
        if n&1:out=mm(out,a,p)
        a=mm(a,a,p); n//=2
    return out


def inv_matrix(a,p):
    return np.array(sp.Matrix(np.asarray(a,dtype=int).tolist()).inv_mod(p)).astype(int)%p


def det_matrix(a,p):
    a=np.asarray(a,dtype=int).copy()%p
    n=a.shape[0]; det=1
    for col in range(n):
        pivot=next((row for row in range(col,n) if a[row,col]),None)
        if pivot is None:return 0
        if pivot!=col:
            a[[col,pivot]]=a[[pivot,col]]; det=-det
        value=int(a[col,col]); det=det*value%p
        inverse=pow(value,-1,p)
        for row in range(col+1,n):
            if a[row,col]:
                factor=int(a[row,col])*inverse%p
                a[row]=(a[row]-factor*a[col])%p
    return det%p


def nullspace(a,p):
    a=np.asarray(a,dtype=int).copy()%p
    rows,cols=a.shape; row=0; pivots=[]
    for col in range(cols):
        candidates=np.flatnonzero(a[row:,col])
        if not len(candidates):continue
        pivot=row+int(candidates[0]); a[[row,pivot]]=a[[pivot,row]]
        a[row]=a[row]*pow(int(a[row,col]),-1,p)%p
        for other in range(rows):
            if other!=row and a[other,col]:
                a[other]=(a[other]-a[other,col]*a[row])%p
        pivots.append(col); row+=1
        if row==rows:break
    free=[col for col in range(cols) if col not in pivots]
    basis=[]
    for col in free:
        vector=np.zeros(cols,dtype=int); vector[col]=1
        for r,pivot in enumerate(pivots):vector[pivot]=-a[r,col]%p
        basis.append(vector)
    return np.stack(basis,axis=1)


def rank_and_pivots(a,p):
    a=np.asarray(a,dtype=int).copy()%p
    rows,cols=a.shape; row=0; pivots=[]
    for col in range(cols):
        pivot=next((r for r in range(row,rows) if a[r,col]),None)
        if pivot is None:continue
        a[[row,pivot]]=a[[pivot,row]]
        a[row]=a[row]*pow(int(a[row,col]),-1,p)%p
        for other in range(rows):
            if other!=row and a[other,col]:a[other]=(a[other]-a[other,col]*a[row])%p
        pivots.append(col); row+=1
        if row==rows:break
    return row,pivots


def digest(value) -> str:
    raw=json.dumps(value,sort_keys=True,separators=(",",":")).encode()
    return hashlib.sha256(raw).hexdigest()


@dataclass
class Model:
    p:int
    zeta:int
    words:dict[F2,str]
    S5:np.ndarray
    T5:np.ndarray
    S6:np.ndarray
    T6:np.ndarray
    records:list
    involutions:list[F2]
    involution_matrices:list[np.ndarray]
    line_bases:list[np.ndarray]


def build_model(p:int,zeta:int) -> Model:
    words=abstract_words()
    qr={1,3,4,5,9}
    gauss=sum((1 if a in qr else -1)*pow(zeta,a,p) for a in range(1,11))%p
    assert gauss*gauss%p==(-11)%p
    indices=[1,3,2,5,4]; signs=[1,1,-1,1,1]
    S5=np.zeros((5,5),dtype=int)
    for row,left in enumerate(indices):
        for col,right in enumerate(indices):
            ratio=signs[col]*pow(signs[row]%p,-1,p)%p
            difference=(pow(zeta,(9*left*right)%11,p)-pow(zeta,(-9*left*right)%11,p))%p
            S5[row,col]=ratio*difference*(-gauss)*pow(11,-1,p)%p
    T5=np.diag([pow(zeta,(i*i)%11,p) for i in indices])%p
    assert np.array_equal(mpow(S5,2,p),np.eye(5,dtype=int)%p)
    assert np.array_equal(mpow(T5,11,p),np.eye(5,dtype=int)%p)
    assert np.array_equal(mpow(mm(S5,T5,p),3,p),np.eye(5,dtype=int)%p)

    c=sum(pow(zeta,e,p) for e in (9,5,4,3))%p
    c=(c+zeta)%p
    A=np.array([
        [0,c,-1,1,0,0],
        [0,c+1,0,-c,-1,0],
        [0,c-1,0,1,0,1],
        [0,c+2,0,-c-1,0,0],
        [0,1,0,-1,0,0],
        [-1,2,0,-1,0,0],
    ],dtype=int)%p
    B=np.array([
        [1,-1,0,0,0,0],
        [1,0,0,-1,0,0],
        [c+1,0,-1,0,0,0],
        [1,0,0,0,-1,0],
        [1,0,0,0,0,0],
        [-c,0,0,0,0,-1],
    ],dtype=int)%p

    def word_matrix(word,gens,size):
        answer=np.eye(size,dtype=int)%p
        for letter in word:answer=mm(answer,gens[letter],p)
        return answer

    S6=word_matrix("BABAB",{"A":A,"B":B},6)
    T6=word_matrix("AABABAB",{"A":A,"B":B},6)
    target_inv={"S":inv_matrix(S5,p),"T":inv_matrix(T5,p)}
    source={"S":S6,"T":T6}
    records=[]; target_matrices={}
    for abstract,word in sorted(words.items()):
        target_inverse=np.eye(5,dtype=int)%p
        source_matrix=np.eye(6,dtype=int)%p
        target=np.eye(5,dtype=int)%p
        for letter in word:
            target_inverse=mm(target_inv[letter],target_inverse,p)
            source_matrix=mm(source_matrix,source[letter],p)
            target=mm(target,{"S":S5,"T":T5}[letter],p)
        records.append((abstract,word,target_inverse,source_matrix))
        target_matrices[abstract]=target

    involutions=sorted(g for g in words if forder(g)==2)
    assert len(involutions)==55
    matrices=[target_matrices[g] for g in involutions]
    identity=np.eye(5,dtype=int)%p
    assert all(np.array_equal(mpow(m,2,p),identity) for m in matrices)
    lines=[nullspace((m+identity)%p,p) for m in matrices]
    assert all(line.shape==(5,2) for line in lines)
    return Model(p,zeta,words,S5,T5,S6,T6,records,involutions,matrices,lines)


def evaluate_frame(model:Model,point):
    p=model.p; point=np.asarray(point,dtype=int)%p
    frame=np.zeros((5,5),dtype=int); invariant=0
    for _abstract,_word,target_inverse,source in model.records:
        value=pow(int(np.dot(source[5],point)%p),8,p)
        invariant=(invariant+value)%p
        frame=(frame+target_inverse*value)%p
    return frame,invariant
