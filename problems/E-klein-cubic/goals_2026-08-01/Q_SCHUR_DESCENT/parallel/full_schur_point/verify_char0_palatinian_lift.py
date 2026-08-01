#!/usr/bin/env python3
"""Bind the exact Q(zeta_11) B5 to the mod-23 Palatini identity."""
from __future__ import annotations
import importlib.util, runpy, sys
from pathlib import Path
import numpy as np

ROOT=Path("/Users/worker/unirational/problems/E-klein-cubic")
pf=runpy.run_path(str(ROOT/"tmp/pfaffian_representation_alignment/core.py"))
spec=importlib.util.spec_from_file_location("fano_lift",ROOT/"tmp/fano14_twist/fano_covariant_scan.py")
assert spec and spec.loader
fano=importlib.util.module_from_spec(spec);sys.modules[spec.name]=fano;spec.loader.exec_module(fano)
chars_spec=importlib.util.spec_from_file_location("chars_lift",ROOT/"tmp/projective_source/character_scan.py")
assert chars_spec and chars_spec.loader
chars=importlib.util.module_from_spec(chars_spec);sys.modules[chars_spec.name]=chars;chars_spec.loader.exec_module(chars)

def reduce(x,p=23,z=2):return pf["reduce_k11"](x,z,p)

def main():
    exact_generators=pf["schur_generators"]()
    reduced=tuple(np.array([[reduce(x) for x in row] for row in g.to_list()],dtype=np.int64)%23 for g in exact_generators)
    modular=fano.six_dimensional_generators()
    assert all(np.array_equal(a,b) for a,b in zip(reduced,modular))

    embedding,homdim=pf["normalized_intertwiner"]();assert homdim==1 and embedding.rank()==5
    emod=np.array([[reduce(x) for x in row] for row in embedding.to_list()],dtype=np.int64)%23
    b5,_,_=fano.representation_data()
    assert fano.rank(emod)==5 and fano.rank(np.concatenate([emod,b5],axis=1))==5
    print("CHAR0_B5_REDUCTION_MATCH_OK prime=(23,zeta11-2) homdim=1 rank=5")

    primes=[23,67,89]; residues=[]
    for p in primes:
        chars.configure_prime(p); group=chars.paired_schur_group(); total=0
        for v,_ in group:
            total=(total+chars.complete_symmetric_traces(chars.FANO.inv(v),4)[4])%p
        residues.append(total*pow(len(group),-1,p)%p)
    value,modulus=chars.crt(residues,primes)
    assert modulus>126 and value==1
    print(f"CHAR0_V6_INVARIANT_QUARTIC_DIMENSION_ONE residues={residues} modulus={modulus}")
    print("CHAR0_PALATINI_EQUALS_REYNOLDS_I4_LIFT_OK")

if __name__=="__main__":main()
