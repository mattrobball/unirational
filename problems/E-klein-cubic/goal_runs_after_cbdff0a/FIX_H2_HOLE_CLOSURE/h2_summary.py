#!/usr/bin/env python3
"""FIX-H2: collect the packet's verdicts from the logs and payloads."""
import glob, json, os, re, sys
H = os.path.dirname(os.path.abspath(__file__))
def show(title, path, pat=None):
    print('\n== %s ==' % title)
    if not os.path.exists(path):
        print('   (not present)'); return
    for ln in open(path):
        if pat is None or re.search(pat, ln):
            print('   ' + ln.rstrip())
show('strata A/C re-certification', os.path.join(H,'logs/H2_STRATA_AC.log'), r'=> stratum|re-certification')
show('TASK A -- msolve side (complete)', os.path.join(H,'logs/H2_MSOLVE_ALL.log'), r'=> lam|msolve side')
show('TASK A -- Macaulay2 side', os.path.join(H,'logs/H2_M2_FINAL.log'), r'M2v =|=> lam|Macaulay2 side')
show('TASK A -- cube-root cover of CASE N', os.path.join(H,'logs/H2_CUBEROOT.log'), r'qq=|=>|cover r=')
show('strata A/C', os.path.join(H,'logs/H2_STRATA_AC.log'), r'=> stratum')
show('TASK B char-0', os.path.join(H,'logs/H2_TASKB_QQ.log'), r'TASK B qq n|SUMMARY|qq = (False|None)')
show('TASK B mod-p (finding)', os.path.join(H,'logs/H2_TASKB_FF.log'), r'TASK B ff n|SUMMARY')
for f in sorted(glob.glob(os.path.join(H,'payloads','*.json'))):
    print('\n== %s ==' % os.path.basename(f))
    print('   ' + json.dumps(json.load(open(f)), sort_keys=True)[:1500])
